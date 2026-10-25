#import "_site.typ": site, chapter-hero, page-heading, code-expert

#site("ch5", "Chapter 5 - Numerische Quadratur", [
  #chapter-hero("Chapter 5", "Numerische Quadratur")

  #include "ch5/section_5_1.typ"
  #include "ch5/section_5_3.typ"
  #include "ch5/section_5_4.typ"
  #include "ch5/section_5_5.typ"
  #include "ch5/section_5_7.typ"

  // 5.6, 5.8 and 5.9 are flagged `draft: true` in their metas: self-study /
  // further reading, not lectured. They are intentionally NOT included here, so no
  // panel renders on the page -- but they stay in site.json's section list, where
  // build.py / site.js show them greyed out and unclickable in the sidebar (📖,
  // "Self-study & further reading in the script"). Add the `#include` (and drop
  // the flag) if one is ever promoted to a full lectured section.

  #page-heading(
    "serie-06",
    [Serie06: Quadratur],
    icon: code-expert,
    href: "https://expert.ethz.ch/print/NumINFK/AS26/YuzZi3Jn4Z74kWYTm",
  )
])
