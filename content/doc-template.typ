// Reusable Typst document styling for NumCS tutorial notes.
// Import with:
//   #import "doc-template.typ": *
//   #show: numcs-doc

#let doc-font = "Liberation Sans"
#let accent-blue = rgb("#2188ff")
#let callout-bg = rgb("#f7f8f9")

#let numcs-doc(body) = {
  set text(font: doc-font, size: 11pt, lang: "en")
  set par(leading: 0.62em, justify: true)
  set heading(numbering: none)
  set math.equation(numbering: "(1)")

  show heading: set text(font: doc-font, weight: "semibold")
  show heading.where(level: 1): set text(size: 22pt, weight: "bold")
  show heading.where(level: 2): set text(size: 17pt, weight: "semibold")
  show heading.where(level: 3): set text(size: 13pt, weight: "semibold")

  show math.equation.where(block: true): equation => align(center, equation)

  body
}

#let definition-box(title: none, body) = block(
  width: 100%,
  fill: callout-bg,
  stroke: (left: 3pt + accent-blue),
  radius: (right: 4pt),
  inset: 12pt,
)[
  #text(font: doc-font, weight: "bold")[
    #text(fill: accent-blue)[▸]
    Definition#if title != none [ (#title)]
  ]
  #v(6pt)
  #body
]
