// CeTZ figure for section 5.7: the anisotropic tensor grid (fig-aniso).
// Kept in its own file; colors and the centered wrapper match
// section_5_7_figures.typ.
#import "../_site.typ": framed
#import "@preview/cetz:0.4.2": canvas, draw

#let dom = rgb("#1f77ff") // domain Omega
#let axis = rgb("#555555") // axes, labels
#let node = rgb("#e8590c") // grid nodes: warm orange, complementary to the blue domain

#let centered-figure-body(body) = context {
  if target() == "html" {
    html.elem("div", attrs: (style: "display: flex; justify-content: center;"))[#framed(body)]
  } else {
    align(center)[#framed(body)]
  }
}

// --- fig-aniso: anisotropic tensor grid in d = 2 ---
// N_1 = 16 nodes along x_1, N_2 = 4 along x_2, at the same spacing in both
// directions. The grid fills a strip that is exactly the bottom quarter of a
// square (dashed outline), which makes the 1/4 node count visible at a glance.
#let guide = rgb("#9aa0a6")

#let fig-aniso = figure(
  centered-figure-body({
  canvas(length: 1cm, {
    import draw: *
    let (N1, N2) = (16, 4)
    let h = 0.27 // node spacing, equal in x_1 and x_2
    let (a, c) = (0.5, 0.5)
    let side = N1 * h // the full square
    let (b, d) = (a + side, c + N2 * h) // the strip = bottom quarter
    // axes
    line((0, 0), (b + 0.6, 0), mark: (end: "stealth", fill: axis), stroke: axis)
    line((0, 0), (0, c + side + 0.6), mark: (end: "stealth", fill: axis), stroke: axis)
    content((b + 0.9, 0), text(fill: axis, $x_1$))
    content((0, c + side + 0.9), text(fill: axis, $x_2$))
    // the enclosing square, dashed
    line((a, c), (b, c), (b, c + side), (a, c + side), close: true,
      stroke: (paint: guide, dash: "dashed", thickness: 0.8pt))
    // the domain strip and its nodes
    line((a, c), (b, c), (b, d), (a, d), close: true, fill: dom.transparentize(86%), stroke: 1.6pt + dom)
    for i in range(N1) { for j in range(N2) {
      circle((a + (i + 0.5) * h, c + (j + 0.5) * h), radius: 0.06, fill: node, stroke: 0.4pt + node.darken(25%))
    } }
    // labels
    // per-direction counts along each axis
    content(((a + b) / 2, -0.35), $N_1 = 16$)
    content((-0.15, (c + d) / 2), anchor: "east", $N_2 = 4$)
  })
  v(10pt)
  })
)
