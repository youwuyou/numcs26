#import "_site.typ": site

#site("ch2", "Chapter 2 - Polynominterpolation", [
  #html.header(class: "hero compact-hero")[
    #html.p(class: "eyebrow")[Chapter 2]
    #html.h1[Polynominterpolation]
  ]

  #include "ch2/section_2_1.typ"
  #include "ch2/section_2_2.typ"
  #include "ch2/section_2_3.typ"
  #include "ch2/section_2_4.typ"
])
