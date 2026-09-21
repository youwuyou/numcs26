#import "_paper.typ": paper

// Every helper below is dual-target: the same chapter source compiles to the
// website (`--features html --format html`) and to a PDF (plain `typst
// compile`). The shape is always `context { if target() == "html" { ... } else
// { ... } }` -- only the taken branch is evaluated, so the paged branch never
// constructs an html.* element and vice versa.

// Accent colors for the paged admonition boxes, keyed like the CSS classes.
#let _accent(class) = {
  if class == "definition" { rgb("#2b6cb0") }
  else if class == "axiom" { rgb("#2f855a") }
  else if class == "lemma" { rgb("#c07a1a") }
  else if class == "tip" { rgb("#2f855a") }
  else if class == "note" { rgb("#4a5568") }
  else if class == "warning" { rgb("#b7791f") }
  else { rgb("#718096") }
}

// A framed, titled box -- the paged counterpart of the CSS admonition.
#let _paged-box(accent, title, body) = block(
  width: 100%,
  breakable: true,
  inset: (x: 10pt, y: 9pt),
  radius: 3pt,
  fill: accent.lighten(94%),
  stroke: (left: 2pt + accent),
)[
  #if title != none [#text(fill: accent, weight: "bold")[#title]#v(4pt, weak: true)]
  #body
]

// Runnable Python example widget. `body` is native Typst content holding a
// single fenced code block, e.g. `#python("Title")[```py\n...\n```]`.
//
// On paper there is nothing to run, so it degrades to a titled listing.
#let python(title, body) = context {
  let code = body.children.filter(c => c.func() == raw).at(0).text
  if target() != "html" {
    return block(width: 100%, breakable: true)[
      #text(weight: "bold")[#title]
      #raw(code, lang: "python", block: true)
    ]
  }
  html.section(class: "python-example")[
    #html.div(class: "example-head")[
      #html.h3[#title]
      #html.div(class: "example-actions")[
        #html.elem("button", attrs: (type: "button", class: "copy-button", "data-copy-target": ".python-code"))[Copy]
        #html.button(type: "button", class: "run-python")[Run]
      ]
    ]
    #html.div(class: "code-editor")[
      #html.pre(class: "code-editor-highlight", aria-hidden: true)
      #html.textarea(class: "python-code", spellcheck: false)[#code]
    ]
    #html.pre(class: "python-output", aria-live: "polite")[Pyodide loads on first run.]
    #html.div(class: "python-plots")
  ]
}

#let python-console(title) = context {
  if target() != "html" {
    return block(width: 100%, breakable: true)[
      #text(weight: "bold")[#title]
      #emph[Interactive Python console — available on the website only.]
    ]
  }
  html.section(class: "python-console")[
    #html.div(class: "example-head")[
      #html.h3[#title]
      #html.div(class: "example-actions")[
        #html.button(type: "button", class: "reset-console")[Reset]
      ]
    ]
    #html.div(class: "console-body")[
      #html.pre(class: "console-log", aria-live: "polite")[Pyodide loads on first command. Try `import numpy as np`, then `np.finfo(float).eps`.]
      #html.div(class: "console-inputline")[
        #html.span(class: "console-prompt")[\>\>\>]
        #html.textarea(class: "console-input", spellcheck: false, rows: 1, aria-label: "Python console input")
      ]
    ]
  ]
}

#let codeblock(code) = context {
  if target() == "html" {
    html.pre(class: "code-block language-python")[#html.code[#code]]
  } else {
    raw(code, lang: "python", block: true)
  }
}

// MyST-style admonition box, e.g. #admonition("tip", "Agenda")[...].
// `class` picks the accent color: "definition"/"lemma" (blue), "tip"/"note"
// (green), "warning" (amber), or the plain default otherwise.
#let admonition(class, title, body) = context {
  if target() == "html" {
    html.div(class: "admonition " + class)[
      #html.p(class: "admonition-title")[#title]
      #html.div(class: "admonition-body")[#body]
    ]
  } else {
    _paged-box(_accent(class), title, body)
  }
}

// Tutorial badge shown at the top of a tutorial's sections.
#let tutorial-badge(title, body) = context {
  if target() == "html" {
    html.div(class: "tutorial-badge")[
      #html.p(class: "admonition-title")[#title]
      #html.div(class: "admonition-body")[#body]
    ]
  } else {
    _paged-box(_accent("tip"), title, body)
  }
}

// Titled, collapsible callout for a worked example (Notion-style toggle),
// e.g. #course-example("Example 1. ...")[...]. Collapsed by default; click
// the title to expand it.
// On paper nothing collapses, so it is always shown expanded.
#let course-example(title, body) = context {
  if target() == "html" {
    html.elem("details", attrs: (class: "course-example"))[
      #html.elem("summary", attrs: (class: "course-example-title"))[#title]
      #html.div(class: "course-example-body")[#body]
    ]
  } else {
    _paged-box(rgb("#7b5ea7"), title, body)
  }
}

// Pill-shaped badge naming a CodeExpert exercise, e.g.
// #code-expert-badge("Ex. 3 -- Multiplikation mit einer Diagonalmatrix").
// Not a link -- just an adequate, visually-tagged mention of the exercise.
#let code-expert-badge(label) = context {
  if target() == "html" {
    html.span(class: "code-expert-badge")[
      #html.img(class: "code-expert-logo", src: "static/logo_code_expert.svg", alt: "CodeExpert")
      #html.span[#label]
    ]
  } else {
    box(
      inset: (x: 4pt, y: 2pt),
      outset: (y: 2pt),
      radius: 2pt,
      fill: rgb("#edf2f7"),
      stroke: 0.5pt + rgb("#cbd5e0"),
    )[
      #box(baseline: 0.15em, image("../static/logo_code_expert.svg", height: 0.8em))
      #h(1pt)
      #text(size: 0.85em)[#label]
    ]
  }
}

// A group of `code-expert-badge`s docked in the right margin, at the same
// column as the sidenotes -- use in place of several bare `code-expert-badge`
// calls right under a section heading, e.g.
// #code-expert-badges("Ex. 1 -- ...", "Ex. 2 -- ...").
#let code-expert-badges(..labels) = context {
  if target() == "html" {
    html.span(class: "code-expert-badges")[
      #for label in labels.pos() [#code-expert-badge(label)]
    ]
  } else {
    for label in labels.pos() [#code-expert-badge(label) ]
  }
}

// A collapsible exercise bar naming a CodeExpert exercise, with the full
// write-up hidden until the bar is expanded (Notion-style toggle, like
// `course-example`), e.g. #code-expert-exercise("Ex. 1 -- ...")[The task ...].
// Use it where the exercise is discussed in the running text, in place of the
// margin-docked `code-expert-badges`. On paper it degrades to a titled box.
#let code-expert-exercise(title, body) = context {
  if target() == "html" {
    html.elem("details", attrs: (class: "code-expert-exercise"))[
      #html.elem("summary", attrs: (class: "code-expert-exercise-title"))[
        #html.img(class: "code-expert-logo", src: "static/logo_code_expert.svg", alt: "CodeExpert")
        #html.span[#title]
      ]
      #html.div(class: "code-expert-exercise-body")[#body]
    ]
  } else {
    _paged-box(rgb("#4a5568"), title, body)
  }
}

// Learning-outcomes-style checklist. `items` is an array of content blocks.
// On the web each item is a real, tickable checkbox; the ticked state is
// remembered per page in localStorage by `setupChecklists` in static/site.js.
#let checklist(items) = context {
  if target() == "html" {
    html.ul(class: "checklist")[
      #for item in items {
        html.li[
          #html.elem("label", attrs: (class: "checklist-label"))[
            #html.elem("input", attrs: (type: "checkbox", class: "checklist-check"))
            #html.span(class: "checklist-text")[#item]
          ]
        ]
      }
    ]
  } else {
    list(marker: [☐], ..items)
  }
}

// Flags something an exercise needs that the lecture and script do not cover.
// Renders red and prefixed with "Gap:" (see `.lecture-gap` in static/site.css),
// e.g. #gap[`np.cumprod` is never introduced in the course.]
#let gap(body) = context {
  if target() == "html" {
    html.span(class: "lecture-gap")[#body]
  } else {
    text(fill: rgb("#c0243c"))[*Gap:* #body]
  }
}

// Equation numbering. The number is assigned by a Typst counter rather than by
// a CSS counter or by Typst's own `math.equation` numbering, because it has to
// come out identical in both targets *and* be readable at the reference site:
// `_anchor-numbers` records id -> number so `anchor-ref` can print "(3)".
//
// Reading it back with `.final()` is what makes forward references work -- a
// reference may appear before the equation it points at.
#let _anchor-counter = counter("anchor")
#let _anchor-numbers = state("anchor-numbers", (:))

// Anchors a block (typically display math) with an `id`, numbers it, and makes
// the number a link to itself: #anchor("eq-foo")[$ ... $].
#let anchor(id, body) = {
  _anchor-counter.step()
  context {
    let n = _anchor-counter.get().first()
    _anchor-numbers.update(m => { m.insert(id, n); m })
    if target() == "html" {
      html.div(id: id, class: "eq-block")[
        #html.div(class: "eq-body")[#body]
        #html.a(class: "eq-number", href: "#" + id)[(#n)]
      ]
    } else {
      // The trailing `label(id)` attaches to the grid, giving `anchor-ref` a
      // real internal PDF link to jump to.
      [#grid(
          columns: (1fr, auto),
          align: (center + horizon, right + horizon),
          body,
          [(#n)],
        )#label(id)]
    }
  }
}

// A citation-style link to an anchored block on the same page, e.g.
// #anchor-ref("eq-foo")[the equation above].
// A link to another section of the site, e.g.
// #page-ref("ch1.html#rechenaufwand")[1.2 Rechenaufwand]. Written as a helper
// rather than a bare `html.a` so the paged target has something to fall back on.
#let page-ref(href, label) = context {
  if target() == "html" { html.a(href: href)[#label] } else { emph(label) }
}

// Counter behind the `id` of each sidenote's toggle checkbox. The *visible*
// number comes from a CSS counter (see `.sidenote-number` in static/site.css);
// this one only has to make the label/input pair unique within a page.
#let _sidenote-counter = counter("sidenote")

// A footnote. On paper this is Typst's own `footnote`, so the PDF gets the
// usual numbered note at the bottom of the page. On the website it becomes a
// Tufte-style sidenote in the right margin: a superscript number, and the note
// itself set alongside the paragraph rather than banished to the page foot.
//
// Typst's `footnote` cannot be used directly for the web -- HTML export rejects
// it outright ("footnotes are not currently supported in combination with a
// custom `<html>` or `<body>` element"), and `site()` builds exactly such a
// shell -- so the web branch emits the markup by hand.
//
// The three elements must stay adjacent and in this order: the CSS matches
// `.margin-toggle:checked + .sidenote` to expand the note on narrow screens,
// where there is no margin to put it in.
#let sidenote(body) = context {
  if target() != "html" {
    return footnote(body)
  }
  _sidenote-counter.step()
  context {
    let id = "sn-" + str(_sidenote-counter.get().first())
    // `for` is a Typst keyword, hence the string key and `html.elem`.
    html.elem("label", attrs: ("for": id, class: "margin-toggle sidenote-number"))
    html.elem("input", attrs: (type: "checkbox", id: id, class: "margin-toggle"))
    html.span(class: "sidenote")[#body]
  }
}

// A reference to an anchored block on the same page:
// #anchor-ref("eq-foo")[the equation above] -> "the equation above (3)",
// clickable in both targets. `lbl` shadows the `label` builtin if named
// `label`, hence the abbreviation.
#let anchor-ref(id, lbl) = context {
  let n = _anchor-numbers.final().at(id, default: none)
  let shown = if n == none { lbl } else { [#lbl (#n)] }
  if target() == "html" {
    html.a(class: "sec-ref", href: "#" + id)[#shown]
  } else {
    link(label(id))[#shown]
  }
}

// A captioned figure. Drop the image file into `migrate/static/` (it is
// published wholesale by build.py) and reference it as `static/<name>`:
//
//   #figure-img("static/machine_numbers.png", "alt text")[Caption text.]
//
// `credit` is optional and rendered smaller, after the caption. `width` is a
// Typst ratio (e.g. `width: 80%`) sizing the image relative to the text column,
// the same way `image(width: ..)` works in the paged build.
#let figure-img(src, alt, credit: none, width: 88%, body) = context {
  if target() != "html" {
    // `src` is written relative to the site root; on disk the assets sit one
    // level up from this file, in migrate/static/.
    return figure(
      image("../" + src, width: width),
      caption: {
        body
        if credit != none [ #text(size: 0.85em, fill: rgb("#718096"))[#credit] ]
      },
    )
  }
  html.elem("figure", attrs: (class: "content-figure"))[
    #html.img(src: src, alt: alt, style: "width: " + repr(width) + ";")
    #html.elem("figcaption")[
      #body
      #if credit != none [
        #html.span(class: "figure-credit")[#credit]
      ]
    ]
  ]
}

// A handwritten-notes lightbox: an inline trigger button plus a hidden modal
// holding the image. Multiple lightboxes on one page are distinguished by
// `id`. The open/close behavior lives in static/site.js (setupNotesLightbox).
#let notes-lightbox(id, trigger-label, img-src, img-alt, caption) = context {
  if target() != "html" {
    // No modal on paper: the image is simply printed inline.
    return figure(image("../" + img-src, width: 88%), caption: caption)
  }
  html.elem("button", attrs: (
    type: "button",
    class: "notes-lightbox-trigger",
    "data-notes-lightbox-open": id,
  ))[#trigger-label]
  html.elem("div", attrs: (
    class: "notes-lightbox",
    "data-notes-lightbox": id,
    hidden: "hidden",
    role: "dialog",
    "aria-modal": "true",
    "aria-labelledby": id + "-title",
  ))[
    #html.elem("div", attrs: (class: "notes-lightbox-backdrop", "data-notes-lightbox-close": ""))
    #html.elem("figure", attrs: (class: "notes-lightbox-panel"))[
      #html.elem("button", attrs: (
        type: "button",
        class: "notes-lightbox-close",
        "data-notes-lightbox-close": "",
        "aria-label": "Close handwritten notes",
      ))[Close]
      #html.elem("figcaption", attrs: (id: id + "-title"))[#caption]
      #html.img(src: img-src, alt: img-alt)
      #html.p(class: "notes-lightbox-disclaimer")[
        #html.strong[Disclaimer:] The official lecture materials should be taken as the main reference.
      ]
    ]
  ]
}

// Wraps a chapter section written in native Typst markup: the first `==`
// heading becomes the section's <h2>, a `===` sub-heading becomes a plain <h3>,
// everything else (paragraphs, math, `python()`/`codeblock()` calls, ...)
// passes through untouched.
//
// `kicker` is an optional eyebrow label above the <h2> (e.g. `kicker: "Example"`).
// It is off by default: a label that reads the same on every section is noise.
#let section(meta, kicker: none, body) = context {
  if target() != "html" {
    // Paged: the `==`/`===` headings are left to the document template.
    return body
  }
  show heading.where(level: 2): h => {
    if kicker != none { html.p(class: "section-kicker")[#kicker] }
    html.h2[#h.body]
  }
  // Without this, Typst's default export emits <h4> and skips a level.
  show heading.where(level: 3): h => html.h3(class: "section-subheading")[#h.body]
  html.section(id: meta.id, class: "panel")[#body]
}

// The CodeExpert wordmark inline in running text, where the logo reads faster
// than the name spelled out.
#let code-expert = context {
  if target() == "html" {
    html.img(class: "code-expert-inline", src: "static/logo_code_expert.svg", alt: "CodeExpert")
  } else {
    box(baseline: 0.15em, image("../static/logo_code_expert.svg", height: 0.8em))
  }
}

// A heading that belongs to the page but not to the Skript numbering. It shows
// up in the page TOC on the right (site.js collects `main h2[id]`) but never in
// the left sidebar, which build.py assembles from site.json's `sections` list.
// Use it at chapter level, not inside a `section()` -- an h2 nested in a
// `<section id=...>` would inherit that section's anchor instead of its own.
// `href`: turns the heading into a button linking out (e.g. to the sheet on
// CodeExpert). The text stays inside the h2, so the page TOC still picks it up.
#let page-heading(id, title, icon: none, href: none) = context {
  if target() == "html" {
    html.h2(id: id, class: "plain-heading")[
      #if href == none {
        [#icon #title]
      } else {
        html.a(class: "plain-heading-link", href: href, target: "_blank", rel: "noopener")[#icon #title #html.span(class: "plain-heading-arrow")[↗]]
      }
    ]
  } else {
    // Paged: the icon carries the link (the title stays in heading colour, since
    // a fully blue heading reads as a mistake on paper) and is scaled up a little
    // -- `code-expert` sizes itself relative to the surrounding text.
    let mark = if icon == none { none } else {
      let big = text(size: 1.45em)[#icon]
      if href == none { big } else { link(href)[#big] }
    }
    heading(level: 2, numbering: none)[#mark #emph(title)]
  }
}

// Content that belongs on the website only and is dropped from the PDF.
#let web-only(body) = context {
  if target() == "html" { body }
}

// A slide boundary for the website's "Present" mode (see `setupPresent` in
// static/site.js). On the web it emits an invisible marker that cuts the
// enclosing panel into separate slides at this point; on paper it is nothing,
// so the PDF layout is untouched. Drop it between blocks, e.g.
//   ... first slide's content ...
//   #slidebreak()
//   ... next slide's content ...
#let slidebreak() = context {
  if target() == "html" {
    html.div(class: "slide-break", aria-hidden: true)
  }
}

// A chapter's title block: the eyebrow + <h1> hero on the website, and nothing
// at all on paper, where `_paper.typ` has already printed the title page.
#let chapter-hero(eyebrow, title) = context {
  if target() == "html" {
    html.header(class: "hero compact-hero")[
      #html.p(class: "eyebrow")[#eyebrow]
      #html.h1[#title]
    ]
  }
}

#let slugify(s) = lower(s).replace(regex("[^a-z0-9]+"), "-").trim("-")

// Flattens arbitrary content down to its plain text, so a heading whose body
// mixes text with inline elements (e.g. a library wordmark standing in for a
// name, as in ch0's "numpy"/"matplotlib" section titles) still yields a clean
// string for the anchor slug. Spaces are elements of their own, so they must be
// restored explicitly or adjacent words would run together in the slug.
#let plain-text(c) = {
  if type(c) == str { c }
  else if repr(c.func()) in ("space", "linebreak", "parbreak") { " " }
  else if c.has("text") { c.text }
  else if c.has("children") { c.children.map(plain-text).sum(default: "") }
  else if c.has("body") { plain-text(c.body) }
  else { "" }
}

// Splits a page's body at every `==` heading and wraps each resulting slice
// in its own `<section class="panel">` -- so a whole page of panels can be
// written as plain, flat Typst markup:
//
//   #panels[
//     == Tutorial Session
//     - Group: *G-04 B*
//
//     == Schedule
//     ...
//   ]
//
// Each section's anchor id is derived from its heading text, e.g.
// "Tutorial Session" -> id="tutorial-session".
#let panels(body) = {
  let children = if body.has("children") { body.children } else { (body,) }

  let groups = ()
  let current = none
  for c in children {
    if c.func() == heading and c.depth == 2 {
      if current != none { groups.push(current) }
      current = (c,)
    } else if current != none {
      current.push(c)
    }
  }
  if current != none { groups.push(current) }

  for g in groups {
    let h = g.at(0)
    html.section(id: slugify(plain-text(h.body)), class: "panel")[
      #html.h2[#h.body]
      #g.slice(1).join()
    ]
  }
}

#let site(page_id, page_title, body) = context {
  if target() != "html" {
    return paper(page_title, body)
  }
  html.html(lang: "en")[
  #html.head[
    #html.meta(charset: "utf-8")
    #html.meta(name: "viewport", content: "width=device-width, initial-scale=1")
    #html.meta(name: "site-page", content: page_id)
    #html.title[#page_title]
    #html.link(rel: "stylesheet", href: "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css")
    #html.link(rel: "stylesheet", href: "static/site.css")
    #html.script(defer: true, src: "static/site.js")
    #html.script(defer: true, src: "static/runner.js")
  ]
  #html.body[
    #html.header(class: "topbar")[
      #html.label(class: "search-box")[
        #html.span(class: "visually-hidden")[Search]
        #html.elem("input", attrs: (id: "site-search", type: "search", placeholder: "Search...", autocomplete: "off"))
        #html.span(class: "shortcut-badge", aria-hidden: true)[
          #html.kbd[Ctrl]
          #html.span(class: "shortcut-plus")[+]
          #html.kbd[K]
        ]
        #html.div(id: "search-results", class: "search-results", role: "listbox")
      ]
      #html.div(class: "topbar-title")
      #html.div(class: "topbar-tools")
    ]
    #html.dialog(id: "search-dialog", class: "search-dialog", aria-label: "Search")[
      #html.form(id: "search-dialog-form", class: "search-dialog-form", method: "dialog")[
        #html.i(class: "fa-solid fa-magnifying-glass", aria-hidden: true)
        #html.elem("input", attrs: (id: "search-dialog-input", type: "search", placeholder: "Search...", autocomplete: "off", spellcheck: "false"))
        #html.span(class: "shortcut-badge", aria-hidden: true)[
          #html.kbd[Ctrl]
          #html.span(class: "shortcut-plus")[+]
          #html.kbd[K]
        ]
      ]
    ]
    #html.button(id: "back-to-top", type: "button", class: "back-to-top", aria-label: "Back to top")[↑ Back to top]
    #html.div(class: "site-shell")[
      #html.aside(class: "sidebar")[
        #html.div(class: "brand")[
          #html.a(class: "brand-title", href: "index.html")[
            #html.strong[Numerical Methods for Computer Science (HS2026)]
          ]
          #html.a(class: "brand-logo-link", href: "index.html", aria-label: "Home")[
            #html.img(class: "brand-logo", src: "static/icon.png", alt: "")
          ]
          #html.small[
            #html.a(href: "https://www.vvz.ethz.ch/Vorlesungsverzeichnis/lerneinheit.view?lerneinheitId=203059&semkez=2026W&ansicht=LEHRVERANSTALTUNGEN&lang=en")[401-0663-00L]
          ]
          #html.small[
            #html.a(href: "https://ethz.ch/staffnet/en/service/rooms-and-buildings/roominfo/detail.html?building=ML&floor=F&room=40")[Tutorial Session G-04 B - ML F 40]
          ]
        ]
        #html.nav(id: "site-nav", aria-label: "Sections")
        #html.div(class: "sidebar-meta")[
          #html.p(class: "sidebar-meta-line")[
            Maintained by #html.a(href: "https://github.com/youwuyou")[WU, You]
          ]
          #html.p(class: "sidebar-meta-line")[
            Last updated #datetime.today().display("[day].[month].[year]")
          ]
        ]
      ]

      #html.div(class: "main-column")[
        #html.div(class: "content-toolbar", aria-label: "Page tools")[
          #html.button(id: "sidebar-toggle", type: "button", class: "icon-button", aria-label: "Toggle site navigation", title: "Toggle site navigation", aria-controls: "site-nav")[☰]
          #html.div(class: "content-toolbar-tools")[
            #html.div(class: "download-menu")[
              #html.button(id: "download-toggle", type: "button", class: "icon-button", aria-label: "Download this page", title: "Download this page", aria-expanded: false)[
                #html.i(class: "fa-solid fa-download", aria-hidden: true)
              ]
              #html.div(id: "download-options", class: "download-options", role: "menu")[
                #html.a(id: "download-markdown", role: "menuitem", href: "#")[#html.i(class: "fa-solid fa-file", aria-hidden: true)#html.span[.md]]
                #html.button(id: "print-pdf", type: "button", role: "menuitem")[#html.i(class: "fa-solid fa-file-pdf", aria-hidden: true)#html.span[.pdf]]
              ]
            ]
            #html.button(id: "present-toggle", type: "button", class: "icon-button", aria-label: "Present as slides", title: "Present as slides")[
              #html.i(class: "fa-solid fa-chalkboard-user", aria-hidden: true)
            ]
            #html.button(id: "theme-toggle", type: "button", class: "icon-button", aria-label: "Color mode", title: "Color mode")[◐]
            #html.button(id: "toc-toggle", type: "button", class: "icon-button", aria-label: "Toggle contents", title: "Toggle contents", aria-controls: "page-toc")[☷]
          ]
        ]
        #html.main(id: "top", class: "content")[
          #show raw.where(block: true): r => codeblock(r.text)
          #body
          #html.footer(id: "page-footer", class: "page-footer")
        ]
      ]

      #html.aside(id: "page-toc", class: "page-toc", aria-label: "On this page")
    ]
  ]
  ]
}
