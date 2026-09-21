#import "_site.typ": site

#site("ch7", "Chapter 7 - Intermezzo über (numerische) lineare Algebra", [
  #html.header(class: "hero compact-hero")[
    #html.p(class: "eyebrow")[Chapter 7]
    #html.h1[Intermezzo über (numerische) lineare Algebra]
  ]

  #include "ch7/section_7_1_1.typ"
  #include "ch7/section_7_1_2.typ"
  #include "ch7/section_7_1_3.typ"
])
