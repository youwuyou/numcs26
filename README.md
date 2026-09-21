# Tutorial Sessions (G04-B): Numerical Methods for Computer Science (HS2026)

The administrative page of the tutorial sessions (group G04-B). The page is supported with typst and Pyodide.

Preview locally:

```bash
make serve
```

Then open <http://localhost:8001>.

The page list lives in `site.json`. Add a page by creating a Typst file under
`content/` and adding one entry with `id`, `title`, `group`, `href`, and
`source`.

The shared Typst page shell and helpers live in `content/_site.typ`. Use
`#site(...)` for pages, `#python(...)` for editable Pyodide examples, and
`#codeblock(...)` for highlighted static Python snippets.

The recovered Jupyter Book-style functionality is split into small static
pieces:

- `build.py`: compiles every Typst page and writes `site-data.json` plus
  `search-index.json`.
- `static/site.js`: generated sidebar navigation, page TOC, previous/next
  links, full-text search, dark mode, copy buttons, and lightweight Python
  highlighting.
- `static/runner.js`: Pyodide execution for editable examples.
- `static/site.css`: PyData/Jupyter Book-inspired visual chrome.
