// Trapezoidal refinement: hierarchical surpluses Delta_2 and Delta_3.
// Usage:  #import "section_5_7_trapezoid.typ": fig-trapezoid
//         #fig-trapezoid
#import "@preview/cetz:0.4.2"
#import "../_site.typ": framed, cetz-figure

// ---- palette (muted, harmonious; frost blue + terracotta) ----------------
#let c-ink    = rgb("#2E3440")  // charcoal: the function f and text
#let c-coarse = rgb("#3E7CC4")  // clear cornflower blue: the coarser rule
#let c-area   = rgb("#D9EEFD")  // fresh sky blue: area under the coarser rule
#let c-fine   = rgb("#5CB878")  // fresh light green: the finer rule
#let c-diff   = rgb("#E8618C")  // rose pink: the difference triangles
#let c-grid   = rgb("#D8DEE9")  // pale snow-storm grid
#let c-axis   = rgb("#4C566A")  // slate axis

#let hatch = tiling(size: (3.6pt, 3.6pt))[
  #place(line(start: (0pt, 3.6pt), end: (3.6pt, 0pt),
    stroke: 0.45pt + c-diff.transparentize(40%)))
]

// ---- the function and the quadrature nodes -------------------------------
#let f(x) = (1 + 0.3 * x + 0.6 * calc.sin(calc.pi * x)
  + 0.8 * calc.pow(calc.sin(2 * calc.pi * x), 2))

#let sx = 6.6   // horizontal scale (cm per unit of x)
#let sy = 1.45  // vertical scale   (cm per unit of y)
#let P(x, y) = (x * sx, y * sy)

// nodes of the trapezoidal rule with n subintervals on [0, 1]
#let nodes(n) = range(n + 1).map(k => P(k / n, f(k / n)))

#let panel(nc, nf, tag, show-f: false) = cetz.canvas(length: 1cm, {
  import cetz.draw: *

  let coarse = nodes(nc)
  let fine   = nodes(nf)
  let curve  = range(161).map(i => P(i / 160, f(i / 160)))

  // area under the coarse rule
  line((0, 0), ..coarse, (sx, 0), close: true,
    fill: c-area, stroke: none)

  // difference region: fine polyline, then back along the coarse one
  let diff = fine + coarse.rev().slice(1, -1)
  line(..diff, close: true, fill: c-diff.transparentize(87%), stroke: none)
  line(..diff, close: true, fill: hatch, stroke: none)

  // trapezoid side edges, so each trapezoid reads as a closed shape:
  // coarse trapezoids get solid edges in the coarse colour, the extra edges
  // that the finer rule inserts (odd fine nodes) are solid in the fine colour
  for (k, p) in fine.enumerate() {
    if calc.odd(k) {
      line((p.at(0), 0), p,
        stroke: (paint: c-fine, thickness: 0.9pt))
    }
  }
  for p in coarse {
    line((p.at(0), 0), p, stroke: 1.1pt + c-coarse)
  }

  // x-axis with ticks
  line((-0.25, 0), (sx + 0.45, 0),
    stroke: 0.6pt + c-axis, mark: (end: "stealth", fill: c-axis))
  for (x, lbl) in ((0, $a$), (0.5, $(a + b) / 2$), (1, $b$)) {
    line((x * sx, 0), (x * sx, -0.08), stroke: 0.6pt + c-axis)
    content((x * sx, -0.18), anchor: "north", text(fill: c-axis, lbl))
  }

  // f, coarse rule, fine rule
  line(..curve, stroke: 1.2pt + c-ink)
  line(..coarse, stroke: 1.4pt + c-coarse)
  line(..fine, stroke: (paint: c-fine, thickness: 1.1pt))

  // node markers
  for p in fine   { circle(p, radius: 0.065, fill: white, stroke: 1pt + c-fine) }
  for p in coarse { circle(p, radius: 0.08, fill: c-coarse, stroke: 0.8pt + white) }

  // f is shared by both panels, so it is named once, directly on the curve,
  // with a short leader line from the label to the graph
  if show-f {
    let xt = 0.86
    line(P(xt, f(xt) + 0.02), P(0.93, 2.42), stroke: 0.6pt + c-ink)
    content(P(0.93, 2.42), anchor: "south-west", padding: 0.04,
      text(fill: c-ink, size: 1.15em, $f$))
  }

  // panel tag
  content((-0.25, 2.75 * sy), anchor: "north-west", text(fill: c-axis, [(#tag)]))
})

// ---- shared legend, written for a general level k --------------------------
#let legend = cetz.canvas(length: 1cm, {
  import cetz.draw: *
  let sw = 0.55                       // swatch width
  let entry(x, swatch, lbl) = {
    swatch(x, 0)
    content((x + sw + 0.15, 0), anchor: "west", text(size: 0.9em, fill: c-ink, lbl))
  }
  let sw-coarse(x, y) = {
    rect((x, y - 0.13), (x + sw, y + 0.13), fill: c-area, stroke: none)
    line((x, y), (x + sw, y), stroke: 1.4pt + c-coarse)
    circle((x + sw / 2, y), radius: 0.08, fill: c-coarse, stroke: 0.8pt + white)
  }
  let sw-fine(x, y) = {
    line((x, y), (x + sw, y), stroke: (paint: c-fine, thickness: 1.1pt))
    circle((x + sw / 2, y), radius: 0.065, fill: white, stroke: 1pt + c-fine)
  }
  let sw-diff(x, y) = {
    rect((x, y - 0.13), (x + sw, y + 0.13), fill: c-diff.transparentize(87%), stroke: none)
    rect((x, y - 0.13), (x + sw, y + 0.13), fill: hatch,
      stroke: 0.4pt + c-diff.transparentize(40%))
  }
  entry(0,   sw-coarse, $Q_(k-1) (f; a, b)$)
  entry(3.6, sw-fine,   $Q_k (f; a, b)$)
  entry(6.5, sw-diff,   $Delta_(k) := Q_k - Q_(k-1)$)
})

#let fig-trapezoid = cetz-figure("fig-trapezoid",
  framed(stack(spacing: 0.9em,
    grid(columns: 2, column-gutter: 1.2em,
      panel(1, 2, "a", show-f: true),
      panel(2, 4, "b"),
    ),
    align(center, legend),
    v(10pt)    
  )),
  // caption: [Trapezoidal refinement on $[a, b]$: (a) $k = 2$; (b) $k = 3$.],
)
