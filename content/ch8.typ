#import "_site.typ": site, page-heading, code-expert, divider

#site("ch8", "Chapter 8 - Ausgleichsrechnung", [
  #html.header(class: "hero compact-hero")[
    #html.p(class: "eyebrow")[Chapter 8]
    #html.h1[Ausgleichsrechnung]
  ]

  #include "ch8/section_8_1.typ"

  #page-heading(
    "serie-10",
    [Serie10: Lineare Ausgleichsrechnung],
    icon: code-expert,
    href: "https://expert.ethz.ch/print/NumINFK/AS26/ZKHTxZhBs3BpSArsu",
  )

  #divider()

  #include "ch8/section_8_2.typ"

  #page-heading(
    "serie-11",
    [Serie11: Nichtlineare Ausgleichsrechnung],
    icon: code-expert,
    href: "https://expert.ethz.ch/print/NumINFK/AS26/9reaA5PGimjRyNeww",
  )

  #divider()

  #include "ch8/section_8_3.typ"
])
