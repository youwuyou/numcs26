#!/usr/bin/env python3
from html.parser import HTMLParser
import hashlib
import json
import re
import shutil
import subprocess
from pathlib import Path


SECTION_META_RE = re.compile(r'#let meta = \(id: "([^"]+)", title: "([^"]+)"')
RELEASED_RE = re.compile(r"^\s*(\w+): (true|false),", re.MULTILINE)


ROOT = Path(__file__).resolve().parent
DIST = ROOT / "dist"

# Where the "Edit this page on GitHub" link points. Each page's shell carries the
# `EDIT_URL_PLACEHOLDER` token, rewritten per page to that page's own source.
REPO_EDIT_BASE = "https://github.com/youwuyou/numcs26/edit/main"
EDIT_URL_PLACEHOLDER = "__EDIT_URL__"


class TextExtractor(HTMLParser):
    def __init__(self):
        super().__init__()
        self.skip = 0
        self.main_depth = 0
        self.parts = []

    def handle_starttag(self, tag, attrs):
        if tag == "main":
            self.main_depth += 1
        if tag in {"script", "style", "nav", "footer"}:
            self.skip += 1

    def handle_endtag(self, tag):
        if tag in {"script", "style", "nav", "footer"} and self.skip:
            self.skip -= 1
        if tag == "main" and self.main_depth:
            self.main_depth -= 1

    def handle_data(self, data):
        if self.main_depth and not self.skip:
            text = " ".join(data.split())
            if text:
                self.parts.append(text)


def read_released():
    """The per-chapter publication flags from content/_status.typ.

    Single source of truth, shared with the Typst side: index.typ imports the
    same file to decide which schedule rows are still TBD. A chapter that is
    `false` here is not built at all, so it has no page, no search entry and no
    slot in the pager -- only a greyed-out sidebar caption.
    """
    text = (ROOT / "content" / "_status.typ").read_text(encoding="utf-8")
    return {key: value == "true" for key, value in RELEASED_RE.findall(text)}


def read_manifest():
    with (ROOT / "site.json").open(encoding="utf-8") as handle:
        return json.load(handle)


def compile_page(page):
    output = DIST / page["href"]
    subprocess.run(
        [
            "typst",
            "compile",
            "--features",
            "html",
            "--format",
            "html",
            "--pretty",
            page["source"],
            str(output),
        ],
        cwd=ROOT,
        check=True,
    )


def compile_pdf(page):
    """Paged build of a page, for the download menu.

    Same source as the HTML build: the helpers in content/_site.typ branch on
    `target()`, and content/_paper.typ supplies the print layout. Opt in per page
    with `"pdf": true` in site.json.
    """
    name = Path(page["href"]).with_suffix(".pdf").name
    subprocess.run(
        ["typst", "compile", "--root", ".", page["source"], str(DIST / "_sources" / name)],
        cwd=ROOT,
        check=True,
    )
    return f"_sources/{name}"


def normalize_mathml_accents(path):
    """Patch fragile MathML accents emitted by Typst's HTML exporter."""
    text = path.read_text(encoding="utf-8")
    text = text.replace("<mo>̃</mo>", "<mo>~</mo>")
    path.write_text(text, encoding="utf-8")


# The `matlines` helper in content/_site.typ wraps a matrix equation in
# <div class="matlines" data-columnlines="..." data-rowlines="..."> so we can
# recover, from the flat MathML, which block dividers the author wanted. Typst's
# own `augment` (vline/hline) draws those lines in the PDF but its MathML export
# silently drops them, and the MathML `columnlines`/`rowlines` attributes are
# gone from MathML Core (Chrome/Safari ignore them). So we translate the token
# pattern into plain CSS borders on the individual <mtd> cells, which every
# browser honors, then unwrap the marker div.
_MATLINES_DIV_RE = re.compile(r'<div class="matlines"([^>]*)>(.*?)</div>', re.DOTALL)
_MTABLE_RE = re.compile(r"<mtable>(.*?)</mtable>", re.DOTALL)
_MTR_RE = re.compile(r"<mtr>(.*?)</mtr>", re.DOTALL)
_MTD_RE = re.compile(r"<mtd>(.*?)</mtd>", re.DOTALL)
_DATA_COLS_RE = re.compile(r'data-columnlines="([^"]*)"')
_DATA_ROWS_RE = re.compile(r'data-rowlines="([^"]*)"')

# MathML line tokens (one per inter-cell gap) -> CSS border shorthand. The
# matching padding keeps the digits off the rule so it reads as a deliberate
# divider rather than a glyph touching a border.
_LINE_CSS = {"solid": "1px solid gray", "dashed": "1px dashed gray"}
_LINE_PAD = {"right": "padding-right:0.35em", "bottom": "padding-bottom:0.2em"}


def apply_matrix_lines(path):
    """Render matrix block-dividers requested via the `matlines` helper.

    `data-columnlines`/`data-rowlines` are space-separated MathML tokens, one
    per gap: token c styles the gap after column c (border-right on the c-th
    cell of every row), token r the gap after row r (border-bottom on every cell
    of the r-th row). Only the first, outer <mtable> is treated as the matrix;
    its cells are assumed to hold no nested table (true for the current usage).
    """
    text = path.read_text(encoding="utf-8")

    def render(div):
        attrs, inner = div.group(1), div.group(2)
        cols_attr = _DATA_COLS_RE.search(attrs)
        rows_attr = _DATA_ROWS_RE.search(attrs)
        col_tokens = cols_attr.group(1).split() if cols_attr else []
        row_tokens = rows_attr.group(1).split() if rows_attr else []

        def style_table(mtable):
            new_rows = []
            for r, row in enumerate(_MTR_RE.findall(mtable.group(1))):
                new_cells = []
                for c, cell in enumerate(_MTD_RE.findall(row)):
                    styles = []
                    if c < len(col_tokens) and col_tokens[c] in _LINE_CSS:
                        styles.append("border-right:" + _LINE_CSS[col_tokens[c]])
                        styles.append(_LINE_PAD["right"])
                    if r < len(row_tokens) and row_tokens[r] in _LINE_CSS:
                        styles.append("border-bottom:" + _LINE_CSS[row_tokens[r]])
                        styles.append(_LINE_PAD["bottom"])
                    if styles:
                        new_cells.append(f'<mtd style="{";".join(styles)}">{cell}</mtd>')
                    else:
                        new_cells.append(f"<mtd>{cell}</mtd>")
                new_rows.append("<mtr>" + "".join(new_cells) + "</mtr>")
            return "<mtable>" + "".join(new_rows) + "</mtable>"

        return _MTABLE_RE.sub(style_table, inner, count=1)

    text = _MATLINES_DIV_RE.sub(render, text)
    path.write_text(text, encoding="utf-8")


def bust_asset_caches():
    """Stamp `?v=<hash>` onto the stylesheet and scripts in every built page.

    Without this a browser happily serves a cached `static/site.css` after a
    rebuild, so CSS changes appear not to have landed at all. The hash is over
    the file's own bytes, so the URL changes exactly when the asset does.
    """
    versions = {}
    for name in ("site.css", "site.js", "runner.js"):
        asset = ROOT / "static" / name
        if asset.exists():
            digest = hashlib.sha256(asset.read_bytes()).hexdigest()[:10]
            versions[f"static/{name}"] = f"static/{name}?v={digest}"

    for page in DIST.glob("*.html"):
        text = page.read_text(encoding="utf-8")
        for plain, stamped in versions.items():
            text = text.replace(f'"{plain}"', f'"{stamped}"')
        page.write_text(text, encoding="utf-8")


def extract_text(path):
    parser = TextExtractor()
    parser.feed(path.read_text(encoding="utf-8"))
    return " ".join(parser.parts)


def markdown_export(page, text):
    title = page.get("title", "Document")
    wrapped = "\n\n".join(part.strip() for part in text.split("  ") if part.strip())
    return f"# {title}\n\n{wrapped}\n"


def parse_section_meta(path):
    text = Path(path).read_text(encoding="utf-8")
    match = SECTION_META_RE.search(text)
    if not match:
        raise ValueError(f"no `#let meta = (id: ..., title: ...)` found in {path}")
    return {"id": match.group(1), "title": match.group(2)}


def build_nav(manifest, released):
    pages_by_id = {page["id"]: page for page in manifest["pages"]}
    nav = []
    for entry in manifest.get("nav", []):
        if released.get(entry.get("page", ""), True) is False:
            # Unreleased: the caption stays so the outline of the course is
            # visible, but there is nothing to disclose and nowhere to go.
            nav.append({"group": entry["group"], "links": [], "status": "wip"})
            continue
        if "href" in entry:
            # A group that is itself a single page: rendered as a caption-level
            # link with no children (e.g. the Python warm-up page).
            nav.append({"group": entry["group"], "href": entry["href"], "links": []})
            continue
        if "page" in entry:
            page = pages_by_id[entry["page"]]
            links = [
                {"title": meta["title"], "href": f"{page['href']}#{meta['id']}"}
                for meta in (
                    parse_section_meta(ROOT / section) for section in page.get("sections", [])
                )
            ]
            links.extend(entry.get("extra", []))
        else:
            links = entry.get("links", [])
        nav.append({
            "group": entry["group"],
            "links": links,
            "collapsible": entry.get("collapsible", True),
        })
    return nav


def main():
    manifest = read_manifest()
    released = read_released()
    manifest["pages"] = [
        page for page in manifest["pages"] if released.get(page["id"], True)
    ]
    DIST.mkdir(exist_ok=True)
    (DIST / "static").mkdir(exist_ok=True)
    (DIST / "_sources").mkdir(exist_ok=True)
    # Serve `_sources/` verbatim: GitHub Pages otherwise runs Jekyll, which drops
    # any path starting with an underscore.
    (DIST / ".nojekyll").touch()

    # An earlier build may have published a chapter that has since been pulled
    # back to `false`; drop its artefacts rather than leaving them reachable.
    for page in read_manifest()["pages"]:
        if released.get(page["id"], True):
            continue
        stem = Path(page["href"]).stem
        (DIST / page["href"]).unlink(missing_ok=True)
        for suffix in (".typ", ".md", ".pdf"):
            (DIST / "_sources" / f"{stem}{suffix}").unlink(missing_ok=True)

    pdf_hrefs = {}
    for page in manifest["pages"]:
        compile_page(page)
        if page.get("pdf") is True:
            pdf_hrefs[page["id"]] = compile_pdf(page)
        source = ROOT / page["source"]
        source_name = Path(page["href"]).with_suffix(".typ").name
        shutil.copy2(source, DIST / "_sources" / source_name)

        # Point "Edit this page" at this page's own source file on GitHub.
        built = DIST / page["href"]
        edit_url = f"{REPO_EDIT_BASE}/{page['source']}"
        built.write_text(
            built.read_text(encoding="utf-8").replace(EDIT_URL_PLACEHOLDER, edit_url),
            encoding="utf-8",
        )
        normalize_mathml_accents(built)
        apply_matrix_lines(built)

    # Everything in migrate/static/ is published as-is: to add a site asset
    # (logo, icon, favicon), just drop the file in there and reference it as
    # `static/<name>`.
    shutil.copytree(ROOT / "static", DIST / "static", dirs_exist_ok=True)

    # Content figures live beside their chapter source, under content/<chapter>/,
    # and are referenced as `content/<chapter>/<name>`. Publish every image found
    # under content/ at the same relative path so those references resolve.
    figure_exts = {".png", ".jpg", ".jpeg", ".webp", ".svg", ".gif"}
    for asset in (ROOT / "content").rglob("*"):
        if asset.suffix.lower() not in figure_exts:
            continue
        dest = DIST / asset.relative_to(ROOT)
        dest.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(asset, dest)

    bust_asset_caches()

    search = []
    for page in manifest["pages"]:
        text = extract_text(DIST / page["href"])
        md_name = Path(page["href"]).with_suffix(".md").name
        (DIST / "_sources" / md_name).write_text(markdown_export(page, text), encoding="utf-8")
        search.append(
            {
                "id": page["id"],
                "title": page["title"],
                "url": page["href"],
                "href": page["href"],
                "content": text,
                "text": text,
            }
        )

    pages = []
    for page in manifest["pages"]:
        item = dict(page)
        item["source_href"] = f"_sources/{Path(page['href']).with_suffix('.typ').name}"
        item["markdown_href"] = f"_sources/{Path(page['href']).with_suffix('.md').name}"
        # `"pdf": true` -> the PDF we just built; a string -> a hand-supplied one.
        item["pdf_href"] = pdf_hrefs.get(page["id"], page.get("pdf") if isinstance(page.get("pdf"), str) else None)
        pages.append(item)

    (DIST / "site-data.json").write_text(
        json.dumps(
            {
                "title": manifest["title"],
                "nav": build_nav(manifest, released),
                "pages": pages,
            },
            indent=2,
        ),
        encoding="utf-8",
    )
    (DIST / "search-index.json").write_text(json.dumps(search, indent=2), encoding="utf-8")


if __name__ == "__main__":
    main()
