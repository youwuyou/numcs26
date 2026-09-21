#import "_site.typ": site

#site("ch4", "Chapter 4 - Stückweise Polynomiale Interpolation", [
  #html.header(class: "hero compact-hero")[
    #html.p(class: "eyebrow")[Chapter 4]
    #html.h1[Stückweise Polynomiale Interpolation]
  ]

  #include "ch4/section_4_1.typ"
  #include "ch4/section_4_2.typ"
  #include "ch4/section_4_3.typ"
])
