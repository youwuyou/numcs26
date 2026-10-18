// Hermite basis sketch for section 4.2, drawn with CeTZ. Exposed as the content
// value `fig-hermite-basis` so the section source just imports and places it.
// Two rows, two columns: the value basis phi (top) and slope basis psi (bottom),
// each shown on the left with its derivative on the right, all on t in [0,1].
#import "../_site.typ": framed
#import "@preview/cetz:0.4.2": canvas, draw

// Both the value curves (left column) and the derivatives (right column) are
// drawn in plain black.
#let _blue = black
#let _red = black

#let centered-figure-body(body) = context {
  if target() == "html" {
    html.elem("div", attrs: (style: "display: flex; justify-content: center;"))[#framed(body)]
  } else {
    align(center)[#framed(body)]
  }
}

// The two basis functions and their derivatives.
#let _phi = t => t * t * (3 - 2 * t)        // phi(t)  = t^2 (3 - 2t)
#let _dphi = t => 6 * t * (1 - t)           // phi'(t) = 6t(1 - t)
#let _psi = t => t * t * (t - 1)            // psi(t)  = t^2 (t - 1)
#let _dpsi = t => 3 * t * t - 2 * t         // psi'(t) = 3t^2 - 2t

// One panel: the graph of `fn` over t in [0,1], autoscaled to [ymin, ymax].
// The baseline is drawn at v = 0 (always inside the range here), so the sign of
// each curve reads off directly. `curve` sets the stroke colour of the graph.
// The two endpoint values are marked with dots and labelled (`v0` at t = 0, `v1`
// at t = 1). `unit: true` adds a dashed guide to height 1 for the panels whose
// curve reaches a unit value.
#let _panel(fn, ymin, ymax, title, curve: black, unit: false, v0: $0$, v1: $0$) = canvas(length: 1cm, {
  import draw: *
  let W = 3.0                     // width in cm for t in [0, 1]
  let H = 2.0                     // height in cm for the full y-range
  let ys = H / (ymax - ymin)
  let X = t => t * W
  let Y = v => (v - ymin) * ys
  let ax = rgb("#555555")

  // axes
  line((X(0), Y(0)), (X(1) + 0.5, Y(0)), stroke: 0.8pt + ax, mark: (end: "stealth", fill: ax))
  line((X(0), Y(ymin) - 0.15), (X(0), Y(ymax) + 0.5), stroke: 0.8pt + ax, mark: (end: "stealth", fill: ax))

  // tick at t = 1 and endpoint labels
  line((X(1), Y(0) - 0.08), (X(1), Y(0) + 0.08), stroke: 0.8pt + ax)
  content((X(0) - 0.24, Y(0) - 0.3), text(0.85em)[$0$])
  content((X(1), Y(0) - 0.32), text(0.85em)[$1$])
  content((X(1) + 0.55, Y(0) - 0.3), text(0.85em)[$t$])

  // unit guide: dashed line to the y-axis for the panels that reach height 1
  if unit {
    line((X(0), Y(1)), (X(1), Y(1)), stroke: (paint: ax, thickness: 0.6pt, dash: "dashed"))
    line((X(0) - 0.08, Y(1)), (X(0) + 0.08, Y(1)), stroke: 0.8pt + ax)
  }

  // the curve, sampled and connected
  let N = 48
  let pts = ()
  for i in range(N + 1) {
    let t = i / N
    pts.push((X(t), Y(fn(t))))
  }
  line(..pts, stroke: 1.6pt + curve)

  // endpoint markers at t = 0 and t = 1, each labelled with its cardinal
  // condition (e.g. phi(0) = 0). The canvas bounds grow to fit labels that
  // spill past the axes, so no clipping occurs.
  circle((X(0), Y(fn(0))), radius: 0.07, fill: curve, stroke: none)
  circle((X(1), Y(fn(1))), radius: 0.07, fill: curve, stroke: none)
  content((X(0) - 0.18, Y(fn(0)) + 0.34), text(0.72em, fill: curve)[#v0], anchor: "east")
  content((X(1) + 0.18, Y(fn(1)) + 0.34), text(0.72em, fill: curve)[#v1], anchor: "west")

  // panel title
  content((X(0.5), Y(ymax) + 0.95), title)
})

#let _basis-row(left, right) = centered-figure-body(grid(
  columns: 2,
  column-gutter: 1.4cm,
  align: horizon,
  left, right,
))

#let fig-phi-basis = figure(
  _basis-row(
    _panel(_phi, 0, 1.1, $phi(t)$, curve: _blue, unit: true, v0: $phi(0) = 0$, v1: $phi(1) = 1$),
    _panel(_dphi, 0, 1.6, $phi'(t)$, curve: _red, v0: $phi'(0) = 0$, v1: $phi'(1) = 0$),
  ),
  caption: [The Hermite basis function $phi$ and its derivative $phi^(')$.],
)

#let fig-psi-basis = figure(
  _basis-row(
    _panel(_psi, -0.17, 0.05, $psi(t)$, curve: _blue, v0: $psi(0) = 0$, v1: $psi(1) = 0$),
    _panel(_dpsi, -0.4, 1.1, $psi'(t)$, curve: _red, unit: true, v0: $psi'(0) = 0$, v1: $psi'(1) = 1$),
  ),
  caption: [The Hermite basis function $psi$ and its derivative $psi^(')$.],
)
