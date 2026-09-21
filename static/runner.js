const PYODIDE_URL = "https://cdn.jsdelivr.net/pyodide/v0.26.4/full/pyodide.js";

let pyodidePromise = null;

function loadScript(src) {
  return new Promise((resolve, reject) => {
    const script = document.createElement("script");
    script.src = src;
    script.onload = resolve;
    script.onerror = () => reject(new Error(`Could not load ${src}`));
    document.head.appendChild(script);
  });
}

async function getPyodide(output) {
  if (!pyodidePromise) {
    output.textContent = "Loading Pyodide...";
    pyodidePromise = loadScript(PYODIDE_URL).then(async () => {
      const pyodide = await loadPyodide();
      return pyodide;
    });
  }

  return pyodidePromise;
}

const USE_AGG_BACKEND_CODE = `
try:
    import matplotlib
    matplotlib.use("Agg")
except ImportError:
    pass
`;

const COLLECT_FIGURES_CODE = `
def __collect_figures():
    import base64, io, json
    try:
        import matplotlib.pyplot as plt
    except ImportError:
        return "[]"
    images = []
    for num in plt.get_fignums():
        fig = plt.figure(num)
        buf = io.BytesIO()
        fig.savefig(buf, format="png", bbox_inches="tight")
        buf.seek(0)
        images.append(base64.b64encode(buf.read()).decode("ascii"))
    plt.close("all")
    return json.dumps(images)
__collect_figures()
`;

async function runExample(example) {
  const button = example.querySelector(".run-python");
  const code = example.querySelector(".python-code");
  const output = example.querySelector(".python-output");
  const plots = example.querySelector(".python-plots");

  button.disabled = true;
  output.textContent = "Running...";
  if (plots) plots.replaceChildren();

  try {
    const pyodide = await getPyodide(output);
    output.textContent = "Loading packages...";
    await pyodide.loadPackagesFromImports(code.value);
    if (code.value.includes("matplotlib")) {
      await pyodide.runPythonAsync(USE_AGG_BACKEND_CODE);
    }
    let text = "";
    pyodide.setStdout({ batched: (line) => { text += `${line}\n`; } });
    pyodide.setStderr({ batched: (line) => { text += `${line}\n`; } });
    output.textContent = "Running...";
    await pyodide.runPythonAsync(code.value);
    output.textContent = text.trim() || "Done.";

    if (plots && code.value.includes("matplotlib")) {
      const imagesJson = await pyodide.runPythonAsync(COLLECT_FIGURES_CODE);
      const images = JSON.parse(imagesJson);
      images.forEach((base64) => {
        const img = document.createElement("img");
        img.className = "python-plot";
        img.src = `data:image/png;base64,${base64}`;
        img.alt = "Plot output";
        plots.append(img);
      });
    }
  } catch (error) {
    output.textContent = error.message;
  } finally {
    button.disabled = false;
  }
}

document.querySelectorAll(".python-example").forEach((example) => {
  const button = example.querySelector(".run-python");
  button.addEventListener("click", () => runExample(example));
});

// --- Interactive REPL console (option 1: pyodide.console.PyodideConsole) ---

function makePyConsole(pyodide) {
  // A fresh namespace per widget/reset, so state does not leak between them.
  return pyodide.runPython(`
import pyodide.console
pyodide.console.PyodideConsole({"__name__": "__console__", "__doc__": None})
`);
}

function setupConsole(root) {
  const log = root.querySelector(".console-log");
  const input = root.querySelector(".console-input");
  const promptEl = root.querySelector(".console-prompt");
  const resetButton = root.querySelector(".reset-console");

  let pyconsole = null;
  let reprFn = null;
  let busy = false;
  let ready = false;

  const PROMPT = ">>>";
  const CONT = "...";

  function write(text, cls) {
    const span = document.createElement("span");
    if (cls) span.className = cls;
    span.textContent = text;
    log.append(span);
    log.scrollTop = log.scrollHeight;
  }

  function setPrompt(p) {
    promptEl.textContent = p;
  }

  function autosize() {
    input.style.height = "auto";
    input.style.height = `${input.scrollHeight}px`;
  }

  async function ensureConsole() {
    if (ready) return;
    write("Loading Pyodide...\n", "console-meta");
    const pyodide = await getPyodide(document.createElement("div"));
    reprFn = pyodide.runPython("repr");
    pyconsole = makePyConsole(pyodide);
    pyconsole.stdout_callback = (s) => write(s);
    pyconsole.stderr_callback = (s) => write(s, "console-err");
    ready = true;
    // Clear the loading/help text once the runtime is up.
    log.replaceChildren();
    write("Python (Pyodide). numpy is available via `import numpy as np`.\n", "console-meta");
  }

  function safeDestroy(proxy) {
    try {
      if (proxy && typeof proxy.destroy === "function") proxy.destroy();
    } catch (_) {
      // Already destroyed (Pyodide auto-destroys settled ConsoleFutures).
    }
  }

  // Push one source line into the console; returns its syntax_check state.
  async function pushLine(line) {
    const future = pyconsole.push(line);
    const state = future.syntax_check;
    if (state === "syntax-error") {
      write(`${future.formatted_error.trimEnd()}\n`, "console-err");
      safeDestroy(future);
      return state;
    }
    if (state === "incomplete") {
      safeDestroy(future);
      return state;
    }
    try {
      const value = await future;
      // PyodideConsole does not auto-print; echo the repr of an expression
      // result the way an interactive shell would (statements return None).
      if (value !== undefined) {
        write(`${reprFn(value)}\n`, "console-result");
        safeDestroy(value);
      }
    } catch (error) {
      // A Pyodide PythonError's message already holds the full traceback.
      write(`${(error.message || String(error)).trimEnd()}\n`, "console-err");
    } finally {
      safeDestroy(future);
    }
    return state;
  }

  async function submit() {
    if (busy) return;
    const source = input.value.replace(/\n$/, "");
    input.value = "";
    autosize();

    busy = true;
    input.disabled = true;
    try {
      await ensureConsole();
      const lines = source.split("\n");
      // Echo the block the way a terminal would, with >>> / ... prefixes.
      lines.forEach((line, i) => {
        write(`${i === 0 ? PROMPT : CONT} ${line}\n`, "console-echo");
      });
      let state = "complete";
      for (const line of lines) {
        state = await pushLine(line);
      }
      // A trailing blank line finalises an open block (e.g. a for-loop).
      if (state === "incomplete") {
        await pushLine("");
      }
      setPrompt(PROMPT);
    } finally {
      busy = false;
      input.disabled = false;
      input.focus();
    }
  }

  input.addEventListener("keydown", (event) => {
    if (event.key === "Enter" && !event.shiftKey) {
      event.preventDefault();
      submit();
    }
  });
  input.addEventListener("input", autosize);

  // Clicking the log area focuses the input, like a real terminal.
  log.addEventListener("click", () => {
    if (!window.getSelection().toString()) input.focus();
  });

  resetButton.addEventListener("click", async () => {
    if (busy) return;
    log.replaceChildren();
    input.value = "";
    autosize();
    setPrompt(PROMPT);
    if (ready) {
      const pyodide = await pyodidePromise;
      pyconsole = makePyConsole(pyodide);
      pyconsole.stdout_callback = (s) => write(s);
      pyconsole.stderr_callback = (s) => write(s, "console-err");
      write("Session reset.\n", "console-meta");
    }
    input.focus();
  });

  autosize();
}

document.querySelectorAll(".python-console").forEach(setupConsole);
