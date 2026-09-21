// Paged (PDF) layout for a chapter. Used only when `site()` is compiled with
// the default target; the HTML target never reaches this file.
//
// The chapter sources are shared between both targets -- every helper in
// `_site.typ` branches on `target()` -- so this file only decides how the
// printed document looks, not what is in it.
#import "@preview/kunskap:0.1.0": kunskap

#let paper(title, body) = {
  show: kunskap.with(
    title: [#title],
    author: "Handout for the Tutorial Session G-04 B organized by WU, You",
    // kunskap interpolates `header` as content, so it can carry a link: the
    // course title opens the VVZ entry. Only on page 1 -- on the running header
    // of the following pages the same link would just be repeated clutter.
    header: context {
      let course = [Numerical Methods for Computer Science (HS2026)]
      if counter(page).get().first() == 1 {
        link(
          "https://www.vvz.ethz.ch/Vorlesungsverzeichnis/lerneinheit.view?lerneinheitId=203059&semkez=2026W&ansicht=LEHRVERANSTALTUNGEN&lang=en",
          course,
        )
      } else {
        course
      }
    },
    // No date: these notes are revised continuously, and a build date on the
    // title block only makes a printout look stale. kunskap omits the line
    // entirely when this is `none`.
    date: none,
    paper-size: "a4",
    body-font: ("New Computer Modern Sans",),
    raw-font: ("New Computer Modern Mono", "DejaVu Sans Mono"),
    headings-font: ("New Computer Modern Sans",),
  )

  body
}
