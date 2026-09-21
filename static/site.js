const siteState = {
  pageId: document.querySelector('meta[name="site-page"]')?.content || "index",
  siteData: null,
  searchIndex: null,
};

const MOCK_SEARCH_INDEX = [
  {
    id: "index",
    title: "Overview",
    url: "index.html",
    content: "Logistics Tutorial Session Schedule Numerical Methods for Computer Science",
  },
  {
    id: "ch1",
    title: "Chapter 1: Vor dem Start",
    url: "ch1.html",
    content: "Floating point arithmetic, rounding errors, stable formulas, and runnable Python examples.",
  },
];

async function readJson(path) {
  const response = await fetch(path);
  if (!response.ok) {
    throw new Error(`Could not load ${path}`);
  }
  return response.json();
}

function currentPageIndex() {
  return siteState.siteData.pages.findIndex((page) => page.id === siteState.pageId);
}

function currentPage() {
  return siteState.siteData?.pages.find((page) => page.id === siteState.pageId);
}

function renderSiteNav() {
  const nav = document.querySelector("#site-nav");
  if (!nav || !siteState.siteData) return;

  nav.replaceChildren();
  const groups = siteState.siteData.nav || siteState.siteData.pages.map((page) => ({
    group: page.group,
    links: [{ title: page.title, href: page.href }],
  }));

  groups.forEach(({ group, links, collapsible = true, href, status }) => {
    // A chapter that is not released yet (see content/_status.typ): its page was
    // never built, so the caption is a dead label carrying a 🚧 marker instead
    // of a disclosure triangle.
    if (status === "wip") {
      const container = document.createElement("div");
      container.className = "nav-group nav-group-wip";

      const caption = document.createElement("p");
      caption.className = "nav-caption nav-caption-static nav-caption-wip";
      caption.textContent = group;

      const marker = document.createElement("span");
      marker.className = "nav-wip-marker";
      marker.textContent = "🚧";
      marker.title = "Not published yet";
      caption.append(marker);

      container.append(caption);
      nav.append(container);
      return;
    }

    // A group that is itself a single page: a caption-level link with nothing to
    // disclose, so it sits at chapter level rather than nested under a caption.
    if (href) {
      const link = document.createElement("a");
      link.className = "nav-caption nav-caption-link";
      link.href = href;
      link.textContent = group;
      if (href.startsWith(`${siteState.pageId}.html`)) {
        link.setAttribute("aria-current", "page");
      }

      const container = document.createElement("div");
      container.className = "nav-group";
      container.append(link);
      nav.append(container);
      return;
    }

    const isCurrent = links.some((page) => page.href.startsWith(`${siteState.pageId}.html`));

    const list = document.createElement("div");
    list.className = "nav-group-links";

    links.forEach((page) => {
      const link = document.createElement("a");
      link.href = page.href;
      link.textContent = page.title;
      if (page.href.startsWith(`${siteState.pageId}.html`)) {
        link.setAttribute("aria-current", "page");
      }
      list.append(link);
    });

    if (!collapsible) {
      const container = document.createElement("div");
      container.className = "nav-group nav-group-flat";

      const caption = document.createElement("p");
      caption.className = "nav-caption nav-caption-static";
      caption.textContent = group;
      container.append(caption, list);
      nav.append(container);
      return;
    }

    const details = document.createElement("details");
    details.className = "nav-group";
    details.open = isCurrent;

    const summary = document.createElement("summary");
    summary.className = "nav-caption";
    summary.textContent = group;
    details.append(summary, list);
    nav.append(details);
  });
}

function setupScheduleTickets() {
  document.addEventListener("click", (event) => {
    const ticket = event.target.closest(".schedule-ticket[data-highlight-sections]");
    if (!ticket) return;
    event.preventDefault();

    const nav = document.querySelector("#site-nav");
    if (!nav) return;

    nav.querySelectorAll("a.nav-highlight").forEach((link) => link.classList.remove("nav-highlight"));
    nav.querySelectorAll("details.nav-group[open]").forEach((details) => details.removeAttribute("open"));

    const targets = ticket.dataset.highlightSections.split(",").filter(Boolean);
    if (targets.length === 0) return;

    let first = null;
    targets.forEach((target) => {
      const link = nav.querySelector(`a[href="${CSS.escape(target)}"]`);
      if (!link) return;
      link.classList.add("nav-highlight");
      link.closest("details.nav-group")?.setAttribute("open", "");
      if (!first) first = link;
    });

    first?.scrollIntoView({ behavior: "smooth", block: "center" });
  });
}

function renderPageToc() {
  const toc = document.querySelector("#page-toc");
  const headings = [...document.querySelectorAll("main h2[id], main section[id] > h2")];
  if (!toc || headings.length === 0) return;

  toc.replaceChildren();
  const title = document.createElement("p");
  title.className = "toc-title";
  title.textContent = "Contents";
  toc.append(title);

  headings.forEach((heading) => {
    const section = heading.closest("section[id]");
    const id = heading.id || section?.id;
    if (!id) return;
    const link = document.createElement("a");
    link.href = `#${id}`;
    link.textContent = heading.textContent;
    toc.append(link);
  });

  setupTocActiveState(headings);
}

function setupTocActiveState(headings) {
  const links = [...document.querySelectorAll(".page-toc a")];
  if (links.length === 0) return;

  const setActive = (id) => {
    links.forEach((link) => {
      link.classList.toggle("is-active", link.hash === `#${id}`);
    });
  };

  const sections = headings
    .map((heading) => heading.closest("section[id]"))
    .filter(Boolean);

  setActive(sections[0]?.id || links[0].hash.slice(1));

  if (!("IntersectionObserver" in window)) return;

  const observer = new IntersectionObserver(
    (entries) => {
      const visible = entries
        .filter((entry) => entry.isIntersecting)
        .sort((a, b) => a.boundingClientRect.top - b.boundingClientRect.top)[0];
      if (visible) setActive(visible.target.id);
    },
    { rootMargin: "-22% 0px -68% 0px", threshold: 0 },
  );

  sections.forEach((section) => observer.observe(section));
}

function renderPrevNext() {
  const footer = document.querySelector("#page-footer");
  if (!footer || !siteState.siteData) return;

  const pageable = siteState.siteData.pages.filter((page) => !page.excludeFromPager);
  const index = pageable.findIndex((page) => page.id === siteState.pageId);
  if (index === -1) return;
  const previous = pageable[index - 1];
  const next = pageable[index + 1];

  footer.replaceChildren();
  [
    ["Previous", previous, "prev"],
    ["Next", next, "next"],
  ].forEach(([label, page, direction]) => {
    const link = document.createElement(page ? "a" : "span");
    link.className = `page-link ${direction}`;
    if (page) link.href = page.href;
    link.innerHTML = `<small>${label}</small><strong>${page ? page.title : ""}</strong>`;
    footer.append(link);
  });
}

function setupTheme() {
  const button = document.querySelector("#theme-toggle");
  const system = window.matchMedia("(prefers-color-scheme: dark)");
  const modes = ["auto", "light", "dark"];

  const applyMode = (mode) => {
    const validMode = modes.includes(mode) ? mode : "auto";
    const resolved = validMode === "auto" ? (system.matches ? "dark" : "light") : validMode;
    document.documentElement.dataset.mode = validMode;
    document.documentElement.dataset.theme = resolved;
    localStorage.setItem("numcs-mode", validMode);
    button?.setAttribute("aria-label", `Color mode: ${validMode}`);
    button?.setAttribute("title", `Color mode: ${validMode}`);
    if (button) button.textContent = validMode === "light" ? "☀" : validMode === "dark" ? "☾" : "◐";
  };

  applyMode(localStorage.getItem("numcs-mode") || "auto");

  button?.addEventListener("click", () => {
    const current = document.documentElement.dataset.mode || "auto";
    const next = modes[(modes.indexOf(current) + 1) % modes.length];
    applyMode(next);
  });

  system.addEventListener("change", () => {
    if (document.documentElement.dataset.mode === "auto") applyMode("auto");
  });
}

function textForCopy(button) {
  const scope = button.closest(".python-example")
    || button.closest(".code-block-wrap")
    || button.parentElement?.nextElementSibling
    || document;
  const target = button.dataset.copyTarget;
  const node = scope.querySelector?.(target) || document.querySelector(target);
  if (!node) return "";
  return "value" in node ? node.value : node.textContent;
}

// navigator.clipboard only exists in a secure context (https or localhost);
// over plain http it is undefined and writeText throws. Fall back to a hidden
// textarea + execCommand so copy still works on http deployments.
async function copyText(text) {
  if (navigator.clipboard && window.isSecureContext) {
    await navigator.clipboard.writeText(text);
    return;
  }
  const helper = document.createElement("textarea");
  helper.value = text;
  helper.setAttribute("readonly", "");
  helper.style.position = "fixed";
  helper.style.top = "-1000px";
  helper.style.opacity = "0";
  document.body.append(helper);
  helper.select();
  try {
    if (!document.execCommand("copy")) throw new Error("execCommand copy failed");
  } finally {
    helper.remove();
  }
}

function setupCopyButtons() {
  document.querySelectorAll(".code-block").forEach((block) => {
    // Wrap the <pre> so the copy button can be pinned inside the code chunk
    // (a positioning context that ignores the block's horizontal scroll).
    if (block.parentElement?.classList.contains("code-block-wrap")) return;
    const wrap = document.createElement("div");
    wrap.className = "code-block-wrap";
    block.parentNode.insertBefore(wrap, block);
    wrap.append(block);
    const button = document.createElement("button");
    button.type = "button";
    button.className = "copy-button code-copy-inset";
    button.dataset.copyTarget = ".code-block code";
    button.textContent = "Copy";
    wrap.append(button);
  });

  document.querySelectorAll(".copy-button").forEach((button) => {
    button.addEventListener("click", async () => {
      const original = button.textContent;
      try {
        await copyText(textForCopy(button));
        button.textContent = "Copied";
      } catch {
        button.textContent = "Failed";
      }
      window.setTimeout(() => {
        button.textContent = original;
      }, 1200);
    });
  });
}

const PY_KEYWORDS = new Set([
  "and", "as", "assert", "async", "await", "break", "class", "continue", "def", "del",
  "elif", "else", "except", "finally", "for", "from", "global", "if", "import", "in",
  "is", "lambda", "nonlocal", "not", "or", "pass", "raise", "return", "try", "while",
  "with", "yield", "print",
]);
const PY_BOOLEANS = new Set(["True", "False", "None"]);

const PY_TOKEN_RE = /(#.*$)|('''[\s\S]*?'''|"""[\s\S]*?"""|'(?:\\.|[^'\\])*'|"(?:\\.|[^"\\])*")|(\b\d+(?:\.\d+)?(?:[eE][-+]?\d+)?\b)|(\b[A-Za-z_]\w*\b)(?=\s*\()|(\b[A-Za-z_]\w*\b)/gm;

function escapeHtml(text) {
  return text
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;");
}

function highlightPython(code) {
  return escapeHtml(code).replace(PY_TOKEN_RE, (match, comment, string, number, callee, ident) => {
    if (comment) return `<span class="tok-comment">${comment}</span>`;
    if (string) return `<span class="tok-string">${string}</span>`;
    if (number) return `<span class="tok-number">${number}</span>`;
    if (callee) {
      return PY_KEYWORDS.has(callee)
        ? `<span class="tok-keyword">${callee}</span>`
        : `<span class="tok-function">${callee}</span>`;
    }
    if (ident) {
      if (PY_BOOLEANS.has(ident)) return `<span class="tok-bool">${ident}</span>`;
      if (PY_KEYWORDS.has(ident)) return `<span class="tok-keyword">${ident}</span>`;
      return ident;
    }
    return match;
  });
}

function setupHighlighting() {
  document.querySelectorAll(".language-python code").forEach((code) => {
    code.innerHTML = highlightPython(code.textContent);
  });
}

function renderEditorHighlight(textarea) {
  const pre = textarea.closest(".code-editor")?.querySelector(".code-editor-highlight");
  if (!pre) return;
  const html = highlightPython(textarea.value);
  pre.innerHTML = textarea.value.endsWith("\n") ? `${html} ` : html;
}

function setupCodeEditors() {
  document.querySelectorAll(".python-code").forEach((textarea) => {
    renderEditorHighlight(textarea);

    textarea.addEventListener("input", () => renderEditorHighlight(textarea));

    textarea.addEventListener("scroll", () => {
      const pre = textarea.closest(".code-editor")?.querySelector(".code-editor-highlight");
      if (!pre) return;
      pre.scrollTop = textarea.scrollTop;
      pre.scrollLeft = textarea.scrollLeft;
    });

    textarea.addEventListener("keydown", (event) => {
      if (event.key !== "Tab") return;
      event.preventDefault();
      const start = textarea.selectionStart;
      const end = textarea.selectionEnd;
      textarea.setRangeText("    ", start, end, "end");
      renderEditorHighlight(textarea);
    });
  });
}

function setupSearch() {
  const input = document.querySelector("#site-search");
  const results = document.querySelector("#search-results");
  const dialog = document.querySelector("#search-dialog");
  const dialogInput = document.querySelector("#search-dialog-input");
  const dialogForm = document.querySelector("#search-dialog-form");
  if (!input || !results) return;

  const goToSearch = (query) => {
    const trimmed = query.trim();
    if (!trimmed) return;
    window.location.href = `/search.html?q=${encodeURIComponent(trimmed)}`;
  };

  const openSearch = (value = input.value) => {
    if (!dialog || !dialogInput) {
      input.focus();
      input.select();
      return;
    }

    dialogInput.value = value;
    if (!dialog.open) dialog.showModal();
    window.setTimeout(() => {
      dialogInput.focus();
      dialogInput.select();
    }, 0);
  };

  let restoringFocus = false;

  const closeSearch = () => {
    restoringFocus = true;
    if (dialog?.open) dialog.close();
    input.blur();
    dialogInput?.blur();
    restoringFocus = false;
  };

  input.addEventListener("focus", () => {
    if (restoringFocus) return;
    openSearch();
  });
  input.addEventListener("click", () => openSearch());
  input.addEventListener("beforeinput", () => openSearch());

  document.addEventListener("keydown", (event) => {
    if (event.key === "Escape" && dialog?.open) {
      event.preventDefault();
      closeSearch();
      return;
    }

    const isShortcut = (event.ctrlKey || event.metaKey) && event.key.toLowerCase() === "k";
    if (!isShortcut) return;
    event.preventDefault();
    openSearch();
  }, true);

  input.addEventListener("keydown", (event) => {
    if (event.key !== "Enter") return;
    event.preventDefault();
    goToSearch(input.value);
  });

  dialogForm?.addEventListener("submit", (event) => {
    event.preventDefault();
    goToSearch(dialogInput?.value || "");
  });

  document.addEventListener(
    "pointerdown",
    (event) => {
      if (!dialog?.open) return;
      const rect = dialog.getBoundingClientRect();
      const isInside =
        event.clientX >= rect.left &&
        event.clientX <= rect.right &&
        event.clientY >= rect.top &&
        event.clientY <= rect.bottom;
      if (!isInside) closeSearch();
    },
    true
  );

  dialog?.addEventListener("cancel", (event) => {
    event.preventDefault();
    closeSearch();
  });

  dialog?.addEventListener("close", () => {
    input.blur();
  });

  document.addEventListener("click", (event) => {
    if (!event.target.closest(".search-box")) results.replaceChildren();
  });
}

// Search results also escape quotes. Named distinctly from the highlighter's
// escapeHtml (which must leave quotes intact so its string regex still matches);
// two same-named function declarations in one scope would collide, with the
// later one silently winning for both callers.
function escapeHtmlText(value) {
  return value
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;")
    .replace(/'/g, "&#039;");
}

function escapeRegExp(value) {
  return value.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
}

function highlightMatches(text, query) {
  if (!query) return escapeHtmlText(text);
  const pattern = new RegExp(escapeRegExp(query), "gi");
  let cursor = 0;
  let html = "";

  text.replace(pattern, (match, offset) => {
    html += escapeHtmlText(text.slice(cursor, offset));
    html += `<mark>${escapeHtmlText(match)}</mark>`;
    cursor = offset + match.length;
    return match;
  });

  return html + escapeHtmlText(text.slice(cursor));
}

function snippetAroundMatch(content, query, length = 100) {
  const normalized = content.replace(/\s+/g, " ").trim();
  const index = normalized.toLowerCase().indexOf(query.toLowerCase());
  if (index < 0) return normalized.slice(0, length);

  const half = Math.floor(length / 2);
  const start = Math.max(0, index - half);
  const end = Math.min(normalized.length, index + query.length + half);
  const prefix = start > 0 ? "..." : "";
  const suffix = end < normalized.length ? "..." : "";
  return `${prefix}${normalized.slice(start, end)}${suffix}`;
}

function normalizeSearchIndex(index) {
  const source = Array.isArray(index) && index.length ? index : MOCK_SEARCH_INDEX;
  return source.map((page) => ({
    id: page.id,
    title: page.title || "",
    url: page.url || page.href || "#",
    content: page.content || page.text || "",
  }));
}

function renderSearchPage() {
  const status = document.querySelector("#search-status");
  const list = document.querySelector("#search-results-page");
  const input = document.querySelector("#site-search");
  if (!status || !list) return;

  const query = new URLSearchParams(window.location.search).get("q")?.trim() || "";
  if (input) input.value = query;
  const dialogInput = document.querySelector("#search-dialog-input");
  if (dialogInput) dialogInput.value = query;

  list.replaceChildren();
  if (!query) {
    status.textContent = "Search finished, found 0 page(s) matching the search query.";
    return;
  }

  const index = normalizeSearchIndex(siteState.searchIndex);
  const lowered = query.toLowerCase();
  const matches = index.filter((page) =>
    page.title.toLowerCase().includes(lowered) || page.content.toLowerCase().includes(lowered)
  );

  status.textContent = `Search finished, found ${matches.length} page(s) matching the search query.`;

  matches.forEach((page) => {
    const item = document.createElement("li");
    item.className = "search-result-item";

    const link = document.createElement("a");
    link.href = page.url;
    link.innerHTML = highlightMatches(page.title, query);

    const snippet = document.createElement("p");
    snippet.className = "search-result-snippet";
    snippet.innerHTML = highlightMatches(snippetAroundMatch(page.content, query), query);

    item.append(link, snippet);
    list.append(item);
  });
}

function setupDownloadMenu() {
  const toggle = document.querySelector("#download-toggle");
  const menu = document.querySelector("#download-options");
  const markdown = document.querySelector("#download-markdown");
  const print = document.querySelector("#print-pdf");
  if (!toggle || !menu) return;

  const setOpen = (open) => {
    toggle.setAttribute("aria-expanded", String(open));
    menu.classList.toggle("is-open", open);
  };

  toggle.addEventListener("click", (event) => {
    event.stopPropagation();
    setOpen(!menu.classList.contains("is-open"));
  });

  markdown?.addEventListener("click", () => setOpen(false));
  print?.addEventListener("click", () => {
    setOpen(false);
    const pdfHref = print.dataset.pdfHref;
    if (pdfHref) {
      window.location.href = pdfHref;
      return;
    }
    window.print();
  });

  document.addEventListener("click", (event) => {
    if (!event.target.closest(".download-menu")) setOpen(false);
  });

  document.addEventListener("keydown", (event) => {
    if (event.key === "Escape") setOpen(false);
  });
}

function setupExportLinks() {
  const markdown = document.querySelector("#download-markdown");
  const pdf = document.querySelector("#print-pdf");
  const page = currentPage();
  if (!page) return;

  if (markdown && page.markdown_href) {
    markdown.href = page.markdown_href;
    markdown.download = page.markdown_href.split("/").pop();
  }

  if (pdf && page.pdf_href) {
    pdf.dataset.pdfHref = page.pdf_href;
    pdf.title = "Download precompiled PDF";
  }
}

function setupFullscreen() {
  const button = document.querySelector("#fullscreen-toggle");
  if (!button) return;

  button.addEventListener("click", () => {
    const isFullscreen = document.fullscreenElement || document.webkitFullscreenElement;
    if (isFullscreen) {
      if (document.exitFullscreen) document.exitFullscreen();
      else if (document.webkitExitFullscreen) document.webkitExitFullscreen();
    } else if (document.documentElement.requestFullscreen) {
      document.documentElement.requestFullscreen();
    } else if (document.documentElement.webkitRequestFullscreen) {
      document.documentElement.webkitRequestFullscreen();
    }
  });
}

function setupSidebarToggles() {
  const primary = document.querySelector("#sidebar-toggle");
  const secondary = document.querySelector("#toc-toggle");

  const readSession = (key) => {
    try {
      return sessionStorage.getItem(key);
    } catch {
      return null;
    }
  };

  const writeSession = (key, value) => {
    try {
      sessionStorage.setItem(key, value);
    } catch {
      /* Storage may be unavailable in private or local browser modes. */
    }
  };

  const bind = (button, className, storageKey) => {
    if (!button) return;
    const apply = (hidden) => {
      document.body.classList.toggle(className, hidden);
      button.setAttribute("aria-expanded", String(!hidden));
      writeSession(storageKey, hidden ? "true" : "false");
    };
    apply(readSession(storageKey) === "true");
    button.addEventListener("click", () => apply(!document.body.classList.contains(className)));
  };

  bind(primary, "primary-sidebar-hidden", "numcs-primary-sidebar-hidden");
  bind(secondary, "secondary-sidebar-hidden", "numcs-secondary-sidebar-hidden");
}

function setupBackToTop() {
  const button = document.querySelector("#back-to-top");
  if (!button) return;

  button.addEventListener("click", () => window.scrollTo({ top: 0, behavior: "smooth" }));
  window.addEventListener("scroll", () => {
    button.classList.toggle("is-visible", window.scrollY > 360);
  }, { passive: true });
}

function setupNotesLightbox() {
  document.querySelectorAll("[data-notes-lightbox]").forEach((modal) => {
    const key = modal.dataset.notesLightbox;
    const openButtons = document.querySelectorAll(`[data-notes-lightbox-open="${key}"]`);
    let lastFocused = null;

    function open() {
      lastFocused = document.activeElement;
      modal.hidden = false;
      document.body.classList.add("notes-lightbox-open");
      modal.querySelector("[data-notes-lightbox-close]")?.focus();
    }

    function close() {
      modal.hidden = true;
      document.body.classList.remove("notes-lightbox-open");
      lastFocused?.focus();
    }

    openButtons.forEach((button) => button.addEventListener("click", open));
    modal.querySelectorAll("[data-notes-lightbox-close]").forEach((item) => {
      item.addEventListener("click", close);
    });
    document.addEventListener("keydown", (event) => {
      if (event.key === "Escape" && !modal.hidden) close();
    });
  });
}

// Learning-outcome checklists: make each item tickable and remember the state
// per page in localStorage, keyed by page id + the item's position so the keys
// stay stable as long as the list itself does not change.
function setupChecklists() {
  document.querySelectorAll(".checklist").forEach((list, listIndex) => {
    const checks = list.querySelectorAll(".checklist-check");
    checks.forEach((check, itemIndex) => {
      const key = `numcs-checklist-${siteState.pageId}-${listIndex}-${itemIndex}`;
      if (localStorage.getItem(key) === "1") check.checked = true;
      check.addEventListener("change", () => {
        if (check.checked) localStorage.setItem(key, "1");
        else localStorage.removeItem(key);
      });
    });
  });
}

// Present mode: reflow the current page's panels into a slide deck shown one
// slide at a time. Panels start a new slide; a `.slide-break` marker (emitted
// by `#slidebreak()`) cuts a panel into further slides. Nodes are *moved*, not
// cloned, so live widgets (runnable Python, the console) keep their listeners;
// on exit they are moved back to their original positions.
function setupPresent() {
  const button = document.querySelector("#present-toggle");
  const main = document.querySelector("main.content");
  if (!button || !main) return;

  let overlay = null;
  let slides = [];
  let index = 0;
  let moved = []; // { node, parent, next } recorded so exit() can restore order

  function show(i) {
    index = Math.max(0, Math.min(i, slides.length - 1));
    slides.forEach((slide, n) => slide.classList.toggle("is-active", n === index));
    const counter = overlay.querySelector(".slide-counter");
    if (counter) counter.textContent = `${index + 1} / ${slides.length}`;
    const bar = overlay.querySelector(".slide-progress-bar");
    if (bar) bar.style.width = `${((index + 1) / slides.length) * 100}%`;
    const active = slides[index];
    if (active) active.scrollTop = 0;
  }

  function buildDeck() {
    const deck = document.createElement("div");
    deck.className = "slide-deck";
    slides = [];
    moved = [];

    main.querySelectorAll(":scope > section.panel").forEach((panel) => {
      let slide = null;
      const startSlide = () => {
        slide = document.createElement("section");
        slide.className = "slide";
        deck.appendChild(slide);
        slides.push(slide);
      };
      startSlide();
      // Snapshot first: appending to a slide mutates panel.childNodes.
      Array.from(panel.childNodes).forEach((node) => {
        moved.push({ node, parent: node.parentNode, next: node.nextSibling });
        const isBreak = node.nodeType === 1 && node.classList.contains("slide-break");
        slide.appendChild(node);
        if (isBreak) startSlide();
      });
    });
    // Drop trailing empty slides (e.g. a break at the very end of a panel).
    slides = slides.filter((s) => s.childNodes.length > 0 || s.parentNode === deck);
    // Sidenotes float into the right margin on the page, which is off-slide in
    // present mode. Collect each slide's notes into a footnote strip pinned to
    // the bottom, renumbering per slide. Notes are moved (not recorded in
    // `moved`), so exit() still restores them to their original inline spot.
    slides.forEach((slide) => {
      const notes = slide.querySelectorAll(".sidenote");
      if (!notes.length) return;
      const foot = document.createElement("div");
      foot.className = "slide-footnotes";
      let n = 0;
      notes.forEach((note) => {
        n += 1;
        note.dataset.snNum = n;
        let label = note.previousElementSibling;
        while (label && !label.classList.contains("sidenote-number")) {
          label = label.previousElementSibling;
        }
        if (label) label.dataset.snNum = n;
        foot.appendChild(note);
      });
      slide.appendChild(foot);
      slide.classList.add("has-footnotes");
    });
    // Put the page hero (icon + <h1> title) at the top of the first slide, so
    // the deck opens with a proper title. Moved (recorded in `moved`) so exit()
    // restores it to the top of <main>.
    const hero = main.querySelector(":scope > header.hero");
    if (hero && slides.length) {
      moved.push({ node: hero, parent: hero.parentNode, next: hero.nextSibling });
      slides[0].insertBefore(hero, slides[0].firstChild);
      slides[0].classList.add("has-hero");
    }
    return deck;
  }

  // True while the caret is in an editable field (a code editor textarea or the
  // REPL console input) — there the arrows/space/etc. belong to the text, not
  // the deck, so we must not flip the slide.
  function isEditable(el) {
    if (!el) return false;
    const tag = el.tagName;
    return tag === "TEXTAREA" || tag === "INPUT" || tag === "SELECT" || el.isContentEditable;
  }

  function onKey(event) {
    if (event.key === "Escape") { exit(); return; }
    // Once a code block (or any input) has focus, leave its keys alone.
    if (isEditable(event.target) || isEditable(document.activeElement)) return;
    if (["ArrowRight", "ArrowDown", "PageDown", " ", "Spacebar"].includes(event.key)) {
      event.preventDefault();
      show(index + 1);
    } else if (["ArrowLeft", "ArrowUp", "PageUp"].includes(event.key)) {
      event.preventDefault();
      show(index - 1);
    } else if (event.key === "Home") {
      event.preventDefault();
      show(0);
    } else if (event.key === "End") {
      event.preventDefault();
      show(slides.length - 1);
    }
  }

  function mkButton(cls, label, aria, onClick) {
    const b = document.createElement("button");
    b.type = "button";
    b.className = cls;
    b.innerHTML = label;
    if (aria) b.setAttribute("aria-label", aria);
    b.addEventListener("click", onClick);
    return b;
  }

  function enter() {
    overlay = document.createElement("div");
    overlay.className = "present-overlay";

    const deck = buildDeck();
    if (!slides.length) { overlay = null; return; }

    // Top bar: deck title (left) and slide counter (right).
    const topbar = document.createElement("header");
    topbar.className = "slide-topbar";
    const title = document.createElement("span");
    title.className = "slide-deck-title";
    title.textContent = document.title || "";
    const counter = document.createElement("span");
    counter.className = "slide-counter";
    topbar.append(title, counter);

    // Footer: navigation controls over a thin progress bar.
    const controls = document.createElement("div");
    controls.className = "slide-controls";
    controls.append(
      mkButton("slide-btn", "‹", "Previous slide", () => show(index - 1)),
      mkButton("slide-btn", "›", "Next slide", () => show(index + 1)),
      mkButton("slide-btn slide-btn-ghost", '<i class="fa-solid fa-expand" aria-hidden="true"></i>', "Toggle fullscreen", toggleFullscreen),
      mkButton("slide-btn slide-btn-ghost", "Exit", "Exit presentation", () => exit()),
    );
    const progress = document.createElement("div");
    progress.className = "slide-progress";
    const progressBar = document.createElement("div");
    progressBar.className = "slide-progress-bar";
    progress.appendChild(progressBar);

    overlay.append(topbar, deck, controls, progress);
    document.body.appendChild(overlay);
    document.body.classList.add("presenting");
    button.setAttribute("aria-pressed", "true");
    document.addEventListener("keydown", onKey);
    show(0);
  }

  function toggleFullscreen() {
    if (!overlay) return;
    if (document.fullscreenElement) {
      document.exitFullscreen?.().catch(() => {});
    } else {
      overlay.requestFullscreen?.().catch(() => {});
    }
  }

  function exit() {
    document.removeEventListener("keydown", onKey);
    if (document.fullscreenElement) document.exitFullscreen?.().catch(() => {});
    // Restore nodes back-to-front so each `next` anchor is already in place.
    for (let i = moved.length - 1; i >= 0; i--) {
      const { node, parent, next } = moved[i];
      parent.insertBefore(node, next);
    }
    moved = [];
    slides = [];
    if (overlay) overlay.remove();
    overlay = null;
    document.body.classList.remove("presenting");
    button.setAttribute("aria-pressed", "false");
  }

  button.addEventListener("click", () => (overlay ? exit() : enter()));
}

async function boot() {
  setupTheme();
  setupCopyButtons();
  setupHighlighting();
  setupCodeEditors();
  setupSearch();
  setupDownloadMenu();
  setupFullscreen();
  setupSidebarToggles();
  setupBackToTop();
  setupScheduleTickets();
  setupNotesLightbox();
  setupChecklists();
  setupPresent();

  try {
    [siteState.siteData, siteState.searchIndex] = await Promise.all([
      readJson("site-data.json"),
      readJson("search-index.json"),
    ]);
    renderSiteNav();
    renderPageToc();
    renderPrevNext();
    setupExportLinks();
    renderSearchPage();
  } catch (error) {
    console.warn(error);
    renderSearchPage();
  }
}

boot();
