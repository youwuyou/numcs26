#!/usr/bin/env python3
"""Live-reloading dev server for the site.

Watches the Typst/content/static sources, reruns build.py on any change, and
serves dist/ with a tiny injected poll script so the open browser tab reloads
itself when a new build lands. Stdlib only -- no extra packages to install
(which matters on NixOS, where a global `pip install` is blocked).

Usage:
    python3 dev.py            # serve on :8001, watch and auto-reload
    python3 dev.py --port 9000

Caveat: build.py recompiles every page, so each save pays a full `typst
compile` before the reload fires -- expect a second or two of lag.
"""
import argparse
import subprocess
import sys
import threading
import time
from functools import partial
from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path

ROOT = Path(__file__).resolve().parent
DIST = ROOT / "dist"

# Directories whose files, when changed, should trigger a rebuild. build.py
# itself is watched too so edits to the build logic take effect live.
WATCH_DIRS = (ROOT / "content", ROOT / "static")
WATCH_FILES = (ROOT / "build.py", ROOT / "site.json")
WATCH_EXTS = {".typ", ".css", ".js", ".json", ".png", ".jpg", ".jpeg",
              ".webp", ".svg", ".gif", ".woff", ".py"}

POLL_INTERVAL = 0.4  # seconds between source-change checks

# Bumped after every successful rebuild. The injected client polls
# /__livereload and reloads when this value changes.
_build_version = 0
_version_lock = threading.Lock()

# Injected before </body> on every served HTML page. Polls the version endpoint
# and reloads on change. Kept inline so there is no extra asset to serve.
_RELOAD_SNIPPET = b"""<script>
(function () {
  var current = null;

  // Signature of the loaded CSS/JS assets. If these change, a DOM swap is not
  // enough (new stylesheet/script must actually load), so we fall back to a
  // full reload. For content edits they stay the same and we swap in place.
  function assetSig(doc) {
    var urls = [];
    (doc || document).querySelectorAll(
      'link[rel="stylesheet"][href], script[src]'
    ).forEach(function (el) {
      urls.push(el.getAttribute("href") || el.getAttribute("src"));
    });
    return urls.join("|");
  }
  var myAssets = assetSig(document);

  // Pull the freshly-built version of this same page and swap only <main>'s
  // contents into the live DOM. No navigation -> scroll position and page
  // state are untouched, and there is no reload flash.
  function refresh() {
    fetch(location.href, { cache: "no-store" })
      .then(function (r) { return r.text(); })
      .then(function (html) {
        var doc = new DOMParser().parseFromString(html, "text/html");
        if (assetSig(doc) !== myAssets) { location.reload(); return; }
        var fresh = doc.querySelector("main");
        var live = document.querySelector("main");
        if (fresh && live) {
          live.replaceWith(fresh);
        } else {
          location.reload();  // no <main> to target; fall back
        }
      })
      .catch(function () { location.reload(); });
  }

  function poll() {
    fetch("/__livereload", { cache: "no-store" })
      .then(function (r) { return r.text(); })
      .then(function (v) {
        if (current === null) { current = v; }
        else if (v !== current) { current = v; refresh(); }
      })
      .catch(function () { /* server restarting; try again next tick */ })
      .finally(function () { setTimeout(poll, 500); });
  }
  poll();
})();
</script>
"""


def snapshot():
    """Map of watched source path -> mtime, for change detection."""
    state = {}
    for base in WATCH_DIRS:
        if not base.exists():
            continue
        for path in base.rglob("*"):
            if path.is_file() and path.suffix.lower() in WATCH_EXTS:
                try:
                    state[path] = path.stat().st_mtime
                except OSError:
                    pass
    for path in WATCH_FILES:
        if path.exists():
            state[path] = path.stat().st_mtime
    return state


def build():
    """Run the existing full build; bump the version only if it succeeds."""
    global _build_version
    result = subprocess.run([sys.executable, "build.py"], cwd=ROOT)
    if result.returncode == 0:
        with _version_lock:
            _build_version += 1
        print(f"  rebuilt (v{_build_version})", flush=True)
    else:
        print("  build failed -- keeping last good output", flush=True)


def watch_loop():
    last = snapshot()
    while True:
        time.sleep(POLL_INTERVAL)
        current = snapshot()
        if current != last:
            changed = sorted(
                p.relative_to(ROOT)
                for p in set(current) | set(last)
                if current.get(p) != last.get(p)
            )
            print(f"change: {', '.join(str(c) for c in changed[:5])}"
                  + (" ..." if len(changed) > 5 else ""), flush=True)
            build()
            # Re-snapshot after build so build.py's own writes to dist/ (which
            # is not watched) or source touches don't retrigger immediately.
            last = snapshot()


class Handler(SimpleHTTPRequestHandler):
    def do_GET(self):
        if self.path.split("?", 1)[0] == "/__livereload":
            with _version_lock:
                body = str(_build_version).encode()
            self.send_response(200)
            self.send_header("Content-Type", "text/plain")
            self.send_header("Cache-Control", "no-store")
            self.send_header("Content-Length", str(len(body)))
            self.end_headers()
            self.wfile.write(body)
            return
        super().do_GET()

    def send_head(self):
        """Serve HTML with the reload snippet injected; everything else as-is."""
        path = self.translate_path(self.path)
        p = Path(path)
        if p.is_dir():
            p = p / "index.html"
        if p.suffix.lower() in {".html", ".htm"} and p.is_file():
            data = p.read_bytes()
            if b"</body>" in data:
                data = data.replace(b"</body>", _RELOAD_SNIPPET + b"</body>", 1)
            else:
                data += _RELOAD_SNIPPET
            self.send_response(200)
            self.send_header("Content-Type", "text/html; charset=utf-8")
            self.send_header("Content-Length", str(len(data)))
            self.send_header("Cache-Control", "no-store")
            self.end_headers()
            # send_head's contract is to return an open body stream; hand back
            # the already-rendered bytes.
            from io import BytesIO
            return BytesIO(data)
        return super().send_head()

    def log_message(self, fmt, *args):
        pass  # quiet; the watcher prints the interesting events


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--port", type=int, default=8001)
    args = parser.parse_args()

    print("initial build...", flush=True)
    build()

    threading.Thread(target=watch_loop, daemon=True).start()

    handler = partial(Handler, directory=str(DIST))
    server = ThreadingHTTPServer(("", args.port), handler)
    print(f"serving http://localhost:{args.port}  (watching for changes, "
          f"Ctrl-C to stop)", flush=True)
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        print("\nstopping", flush=True)


if __name__ == "__main__":
    main()
