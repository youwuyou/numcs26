#import "_site.typ": site, admonition, checklist, chapter-hero, web-only, code-expert, code-expert-exercise, page-heading, anchor-ref, gap, page-ref

#site("ch1", "Chapter 1 - Vor dem Start", [
  #chapter-hero("Chapter 1", "Vor dem Start")

  #web-only[
    #admonition("note", "Learning Outcomes of the Chapter")[
      #checklist((
        [Knowledge about round-off and machine precision.],
        [Familiarity with the phenomenon of "cancellation": cause, effect, remedies, and tricks.],
        [Understanding of the concepts of computational effort/cost and asymptotic complexity in numerics.],
        [Awareness of the asymptotic complexity of basic linear algebra operations.],
        [Ability to determine the (asymptotic) computational effort for a concrete (numerical linear algebra) algorithm.],
        [Ability to manipulate simple expressions involving matrices and vectors in order to reduce the computational cost for their evaluation.],
      ))
    ]
  ]

  #include "ch1/section_1_1.typ"
  #include "ch1/section_1_2.typ"
  #include "ch1/section_1_3.typ"

  #page-heading(
    "serie-01",
    [Serie 01: Auslöschung, Komplexität],
    icon: code-expert,
    href: "https://expert.ethz.ch/print/NumINFK/AS26/pTf4WZM5ScRE6JRWD",
  )
])

