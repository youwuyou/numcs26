#import "_site.typ": site, chapter-hero, page-heading, code-expert

#site("ch4", "Chapter 4 - Stückweise Polynomiale Interpolation", [
  #chapter-hero("Chapter 4", "Stückweise Polynomiale Interpolation")

  #include "ch4/section_4_1.typ"
  #include "ch4/section_4_2.typ"
  #include "ch4/section_4_3.typ"

  #page-heading(
    "serie-05",
    [Serie05: Stückweise Polynomiale Interpolation],
    icon: code-expert,
    href: "https://expert.ethz.ch/print/NumINFK/AS26/ywpFmt8XnMHThmE72",
  )

  // 4.4 is flagged `draft: true` in its meta: self-study / further reading, not
  // lectured. It is intentionally NOT included here, so no panel renders on the
  // page -- but it stays in site.json's section list, where build.py / site.js
  // show it greyed out and unclickable in the sidebar (📖, "Self-study & further
  // reading in the script"). Add the `#include` (and drop the flag) to promote it.
])
