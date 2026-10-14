#import "_site.typ": site, page-heading, code-expert, chapter-hero

#site("ch2", "Chapter 2 - Polynominterpolation", [
  #chapter-hero("Chapter 2", "Polynominterpolation")

  #include "ch2/section_2_1.typ"
  #include "ch2/section_2_2.typ"
  #include "ch2/section_2_3.typ"
  #include "ch2/section_2_4.typ"

  #page-heading(
    "serie-02",
    [Serie02: Polynomiale Interpolation],
    icon: code-expert,
    href: "https://expert.ethz.ch/print/NumINFK/AS26/WktSdh8CzT4uhBC7e",
  )
])
