#import "_site.typ": site

#site("ch8", "Chapter 8 - Ausgleichsrechnung", [
  #html.header(class: "hero compact-hero")[
    #html.p(class: "eyebrow")[Chapter 8]
    #html.h1[Ausgleichsrechnung]
  ]

  #include "ch8/section_8_1.typ"
  #include "ch8/section_8_2.typ"
  #include "ch8/section_8_3.typ"
])
