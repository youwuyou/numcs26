#import "_site.typ": site

#site("ch5", "Chapter 5 - Numerische Quadratur", [
  #html.header(class: "hero compact-hero")[
    #html.p(class: "eyebrow")[Chapter 5]
    #html.h1[Numerische Quadratur]
  ]

  #include "ch5/section_5_1.typ"
  #include "ch5/section_5_2.typ"
  #include "ch5/section_5_3.typ"
  #include "ch5/section_5_4.typ"
  #include "ch5/section_5_5.typ"
  #include "ch5/section_5_6.typ"
  #include "ch5/section_5_7.typ"
  #include "ch5/section_5_8.typ"
  #include "ch5/section_5_9.typ"
])
