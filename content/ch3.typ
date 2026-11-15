#import "_site.typ": site, admonition, checklist, chapter-hero, page-heading, code-expert, web-only

#site("ch3", "Chapter 3 - Trigonometrische Interpolation", [
  #chapter-hero("Chapter 3", "Trigonometrische Interpolation")

  #include "ch3/section_3_1.typ"
  #include "ch3/section_3_2.typ"

  #divider()

  #include "ch3/section_3_3.typ"
  #include "ch3/section_3_5.typ"


  #page-heading(
    "serie-03",
    [Serie03: Trigonometrische Interpolation],
    icon: code-expert,
    href: "https://expert.ethz.ch/print/NumINFK/AS26/tie22AjoBpsBPjcD8",
  )

  // 3.6 is flagged `draft: true` in its meta: self-study / further reading, not
  // lectured. It is intentionally NOT included here, so no panel renders on the
  // page -- but it stays in site.json's section list, where build.py / site.js
  // show it greyed out and unclickable in the sidebar (📖, "Self-study & further
  // reading in the script"). Add the `#include` (and drop the flag) to promote it.

  #page-heading(
    "serie-04",
    [Serie04: Chebyshev-Interpolation],
    icon: code-expert,
    href: "https://expert.ethz.ch/print/NumINFK/AS26/euXaGDb6DbwSNmWje",
  )
])
