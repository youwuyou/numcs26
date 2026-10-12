// Convergence sketches for section 3.5, drawn with CeTZ. The two figures are
// exposed as content values -- `fig-algebraic` and `fig-exponential` -- so the
// section source just imports and places them. Error samples eps_i = E(n_i)
// are drawn relative to the benchmark C g(n).
#import "../_site.typ": framed
#import "@preview/cetz:0.4.2": canvas, draw

// Thin diagonal hatching for the region allowed by O(g)
#let conv-hatch = tiling(size: (4pt, 4pt), {
  place(line(start: (0%, 0%), end: (100%, 100%), stroke: 0.35pt))
})

// f:       benchmark curve in normalized coords, x in [0,1] -> y in [0,1]
// dots:    array of (x, factor); each sample is drawn at height factor * f(x),
//          so factor > 1 lies above C g(n) and factor < 1 below it
// n0:      normalized position of n_0
// curve-lab, lab-at: label of the curve and its normalized position
// slope:   none, or (a, b, label) to draw a slope triangle between x = a and x = b
#let conv-panel(
  f, dots, n0,
  xlab: $n$, ylab: $epsilon$,
  curve-lab: none, lab-at: (1, 0),
  slope: none,
  w: 5, h: 3.4,
) = canvas(length: 1cm, {
  import draw: *
  let P(x, y) = (x * w, y * h)
  let xs = range(101).map(i => i / 100)

  // region allowed by O(g): below C g(n) for n >= n_0
  line(
    P(n0, 0), P(n0, f(n0)),
    ..xs.filter(x => x > n0).map(x => P(x, f(x))),
    P(1, 0),
    close: true, fill: conv-hatch, stroke: none,
  )

  // axes
  let ax = (stroke: 0.6pt, mark: (end: "stealth", fill: black, scale: 0.8))
  line((0, 0), (w * 1.08, 0), ..ax)
  line((0, 0), (0, h * 1.1), ..ax)
  content((w * 1.08, 0), anchor: "north", padding: 4pt, xlab)
  content((0, h * 1.1), anchor: "east", padding: 4pt, ylab)

  // n_0
  line(P(n0, 0), P(n0, f(n0)), stroke: (thickness: 0.5pt, dash: "dashed"))
  content(P(n0, 0), anchor: "north", padding: 4pt, $n_0$)

  // benchmark curve C g(n)
  line(..xs.map(x => P(x, f(x))), stroke: 0.9pt)
  if curve-lab != none {
    content(P(..lab-at), anchor: "south-west", padding: 3pt, curve-lab)
  }

  // slope triangle
  if slope != none {
    let (a, b, lab) = slope
    let st = 0.5pt
    line(P(a, f(a)), P(b, f(a)), P(b, f(b)), stroke: st)
    content(P(b, (f(a) + f(b)) / 2), anchor: "west", padding: 4pt, lab)
  }

  // samples eps_i
  for (x, k) in dots {
    circle(P(x, k * f(x)), radius: 1.5pt, fill: black, stroke: none)
  }
})

// Samples shared by the "straightened" panels: above the line before n_0,
// slightly below it afterwards.
#let conv-line(x) = 0.92 - 0.75 * x
#let conv-line-dots = (
  (0.05, 1.12), (0.16, 1.08),
  (0.32, 0.94), (0.45, 0.94), (0.60, 0.93), (0.75, 0.92), (0.92, 0.9),
)

// Algebraic convergence: linear vs. log-log
#let fig-algebraic = figure(
  framed(grid(
    columns: 2, column-gutter: 2em,
    conv-panel(
      x => 0.95 / (1 + 9 * x),
      ((0.04, 1.25), (0.14, 1.3),
       (0.32, 0.85), (0.45, 0.85), (0.60, 0.85), (0.78, 0.85), (0.95, 0.85)),
      0.24,
      curve-lab: $C n^(-p)$,
    ),
    conv-panel(
      conv-line, conv-line-dots, 0.25,
      xlab: $log n$, ylab: $log epsilon$,
      slope: (0.5, 0.7, [slope $-p$]),
    ),
  )),
  caption: [*Algebraic convergence.* in linear (left) or log-log axes (right). \
    In the subplot with log-log axes, the error $epsilon_(i) approx C n_(i)^(-p)$ makes the data points $(n_(i), epsilon_(i))$ lie on a line of slope $-p$.],
)

// Exponential convergence: linear vs. lin-log
#let fig-exponential = figure(
  framed(grid(
    columns: 2, column-gutter: 2em,
    conv-panel(
      x => 0.95 * calc.exp(-7 * x),
      ((0.04, 1.2), (0.11, 1.25),
       (0.26, 0.8), (0.38, 0.8), (0.52, 0.8), (0.68, 0.8), (0.85, 0.8)),
      0.18,
      curve-lab: $C q^n$, lab-at: (0.2, 0.3),
    ),
    conv-panel(
      conv-line, conv-line-dots, 0.25,
      xlab: $n$, ylab: $log epsilon$,
      slope: (0.5, 0.7, [slope $log q = -beta$]),
    ),
  )),
  caption: [*Exponential convergence.* in linear (left) or lin-log axes (right). \
    In the subplot with lin-log axes, the error $epsilon_(i) approx C q^(n_(i))$ makes the data points $(n_(i), epsilon_(i))$ lie on a line of slope $log q = -beta$.],
)
