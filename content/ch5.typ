#import "_site.typ": site, chapter-hero, page-heading, code-expert, divider

#site("ch5", "Chapter 5 - Numerische Quadratur", [
  #chapter-hero("Chapter 5", "Numerische Quadratur")

  #include "ch5/section_5_1.typ"
  #include "ch5/section_5_2.typ"
  #include "ch5/section_5_3.typ"
  #include "ch5/section_5_4.typ"
  #include "ch5/section_5_5.typ"
  #include "ch5/section_5_6.typ"
  #include "ch5/section_5_7.typ"

  #page-heading(
    "serie-06",
    [Serie06: Quadratur],
    icon: code-expert,
    href: "https://expert.ethz.ch/print/NumINFK/AS26/YuzZi3Jn4Z74kWYTm",
  )

  #divider()

  #include "ch5/section_5_8.typ"
  #include "ch5/section_5_9.typ"
])
