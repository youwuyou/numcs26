#import "_site.typ": site, page-heading, code-expert

#site("ch7", "Chapter 7 - Intermezzo über (numerische) lineare Algebra", [
  #html.header(class: "hero compact-hero")[
    #html.p(class: "eyebrow")[Chapter 7]
    #html.h1[Intermezzo über (numerische) lineare Algebra]
  ]

  #include "ch7/section_7_2.typ"
  #include "ch7/section_7_3.typ"
  #include "ch7/section_7_4.typ"
  #include "ch7/section_7_5.typ"
  // 7.6 is flagged `draft: true` in its meta: self-study / further reading, not
  // lectured. It is intentionally NOT included here, so no panel renders on the
  // page -- but it stays in site.json's section list, where build.py / site.js
  // show it greyed out and unclickable in the sidebar (📖, "Self-study & further
  // reading in the script"). Add the `#include` (and drop the flag) to promote it.

  #page-heading(
    "serie-09",
    [Serie09: Intermezzo über (numerische) lineare Algebra],
    icon: code-expert,
    href: "https://expert.ethz.ch/print/NumINFK/AS26/eHkY24zrivZdmcJcg",
  )
])
