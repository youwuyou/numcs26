#import "_site.typ": site

// A panel whose `==` heading carries an icon and a permalink `#` anchor,
// e.g. the little Polybox/VIS logos next to "Polybox" / "VIS Community Solution".
#let link-section(id, label, icon, body) = {
  let anchor = label + "-heading"
  show heading.where(level: 2): h => html.h2(class: "useful-link-heading " + label + "-heading", id: anchor)[
    #html.img(src: icon, alt: "", aria-hidden: true)
    #html.span[#h.body]
    #html.a(class: "headerlink", href: "#" + anchor, title: "Link to this heading")[\#]
  ]
  html.section(id: id, class: "panel")[#body]
}

#site("links", "Useful Links", [
  #html.header(class: "hero compact-hero")[
    #html.p(class: "eyebrow")[Extra Materials]
    #html.h1[Useful Links]
  ]

  #link-section("polybox", "polybox", "static/polybox.png")[
    == Polybox

    The following links contain materials of the respective teaching
    assistants from the semester HS2025 and may be useful:

    - #link("https://polybox.ethz.ch/index.php/s/YH6dxebeF2WQo6G")[David Mihnea-Stefan (EN)]
    - #link("https://polybox.ethz.ch/index.php/s/nDdo43CpRZ7rX7g")[Henry Schrader (DE)]
    - #link("https://polybox.ethz.ch/index.php/s/wYpC7k6sJDazMgc")[Niklas Damm (DE)]
  ]

  #link-section("vis-community-solution", "vis", "static/vis_logo.svg")[
    == VIS Community Solution

    Past exams, solutions and more summaries contributed by other students
    can be found #link("https://exams.vis.ethz.ch/category/numericalmethodsforcse")[here].
    Note that the lecture has been significantly restructured in the semester HS2025 (included), the exams prior to it may be outdated
    and the content from this semester is of higher importance to focus on.
  ]
])
