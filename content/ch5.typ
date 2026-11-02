#import "_site.typ": site, chapter-hero, page-heading, code-expert

#site("ch5", "Chapter 5 - Numerische Quadratur", [
  #chapter-hero("Chapter 5", "Numerische Quadratur")

  #include "ch5/section_5_1.typ"
  #include "ch5/section_5_3.typ"
  #include "ch5/section_5_4.typ"
  #include "ch5/section_5_5.typ"
  // 5.6 is flagged `draft: true` in its meta: self-study / further reading, not
  // lectured. It is intentionally NOT included here, so no panel renders on the
  // page -- but it stays in site.json's section list, where build.py / site.js
  // show it greyed out and unclickable in the sidebar (📖, "Self-study & further
  // reading in the script"). Add the `#include` (and drop the flag) to promote it.
  #include "ch5/section_5_7.typ"

  #page-heading(
    "serie-06",
    [Serie06: Quadratur],
    icon: code-expert,
    href: "https://expert.ethz.ch/print/NumINFK/AS26/YuzZi3Jn4Z74kWYTm",
  )

  #include "ch5/section_5_8.typ"
  #include "ch5/section_5_9.typ"

  #page-heading(
    "serie-07",
    [Serie07: Einfache Monte-Carlo Methode],
    icon: code-expert,
    href: "https://expert.ethz.ch/print/NumINFK/AS26/N4XGXfoTgMhHYk2ci",
  )
])
