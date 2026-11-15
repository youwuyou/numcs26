#import "_site.typ": site, chapter-hero, page-heading, code-expert

#site("ch6", "Chapter 6 - Nullstellensuche", [
  #chapter-hero("Chapter 6", "Nullstellensuche")

  #include "ch6/section_6_1.typ"
  #include "ch6/section_6_2.typ"
  #include "ch6/section_6_3.typ"
  // 6.4 is flagged `draft: true` in its meta: self-study / further reading, not
  // lectured. It is intentionally NOT included here, so no panel renders on the
  // page -- but it stays in site.json's section list, where build.py / site.js
  // show it greyed out and unclickable in the sidebar (📖, "Self-study & further
  // reading in the script"). Add the `#include` (and drop the flag) to promote it.
  #include "ch6/section_6_5.typ"
  #include "ch6/section_6_7.typ"

  #page-heading(
    "serie-08",
    [Serie08: Nullstellensuche],
    icon: code-expert,
    href: "https://expert.ethz.ch/print/NumINFK/AS26/nxsLPwLezEH7ypr8c",
  )
])
