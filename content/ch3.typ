#import "_site.typ": site

#site("ch3", "Chapter 3 - Trigonometrische Interpolation", [
  #html.header(class: "hero compact-hero")[
    #html.p(class: "eyebrow")[Chapter 3]
    #html.h1[Trigonometrische Interpolation]
  ]

  #include "ch3/section_3_1.typ"
  #include "ch3/section_3_2.typ"
  #include "ch3/section_3_3.typ"
  #include "ch3/section_3_4.typ"
  #include "ch3/section_3_5.typ"
  #include "ch3/section_3_6.typ"
])
