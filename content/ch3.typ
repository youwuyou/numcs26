#import "_site.typ": site, admonition, checklist, chapter-hero, page-heading, code-expert, web-only

#site("ch3", "Chapter 3 - Trigonometrische Interpolation", [
  #chapter-hero("Chapter 3", "Trigonometrische Interpolation")

  #include "ch3/section_3_1.typ"
  #include "ch3/section_3_2.typ"

  #page-heading(
    "serie-03",
    [Serie03: Trigonometrische Interpolation],
    icon: code-expert,
    href: "https://expert.ethz.ch/print/NumINFK/AS26/tie22AjoBpsBPjcD8",
  )

  #divider()

  #include "ch3/section_3_3.typ"
  #include "ch3/section_3_4.typ"
  #include "ch3/section_3_5.typ"
  #include "ch3/section_3_6.typ"
])
