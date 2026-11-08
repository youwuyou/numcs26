#import "_site.typ": site, page-heading, code-expert

#site("ch6", "Chapter 6 - Nullstellensuche", [
  #html.header(class: "hero compact-hero")[
    #html.p(class: "eyebrow")[Chapter 6]
    #html.h1[Nullstellensuche]
  ]

  #include "ch6/section_6_1.typ"
  #include "ch6/section_6_3.typ"
  #include "ch6/section_6_4.typ"
  #include "ch6/section_6_5.typ"
  #include "ch6/section_6_6.typ"
  #include "ch6/section_6_7.typ"
  #include "ch6/section_6_8.typ"
  #include "ch6/section_6_9.typ"

  #page-heading(
    "serie-08",
    [Serie08: Nullstellensuche],
    icon: code-expert,
    href: "https://expert.ethz.ch/print/NumINFK/AS26/nxsLPwLezEH7ypr8c",
  )
])
