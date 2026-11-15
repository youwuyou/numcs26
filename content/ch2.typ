#import "_site.typ": site, chapter-hero, page-heading, code-expert, web-only, admonition, checklist

#site("ch2", "Chapter 2 - Polynominterpolation", [
  #chapter-hero("Chapter 2", "Polynominterpolation")

  #include "ch2/section_2_1.typ"
  #include "ch2/section_2_2.typ"
  #include "ch2/section_2_3.typ"
  // 2.4 is flagged `draft: true` in its meta: self-study / further reading, not
  // lectured. It is intentionally NOT included here, so no panel renders on the
  // page -- but it stays in site.json's section list, where build.py / site.js
  // show it greyed out and unclickable in the sidebar (📖, "Self-study & further
  // reading in the script"). Add the `#include` (and drop the flag) to promote it.

  #page-heading(
    "serie-02",
    [Serie02: Polynomiale Interpolation],
    icon: code-expert,
    href: "https://expert.ethz.ch/print/NumINFK/AS26/WktSdh8CzT4uhBC7e",
  )

])
