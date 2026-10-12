// The three test functions for section 3.5, drawn with CeTZ and exposed as
// `fig-functions`. Each panel plots one 1-periodic function on [0, 1] with its
// own vertical scale, so the differing smoothness is visible at a glance:
//   f -- jump discontinuity (step),  h -- C^infinity,  g -- corner (hat).
#import "../_site.typ": framed
#import "@preview/cetz:0.4.2": canvas, draw

// f:      sampled function, t in [0,1] -> value
// ymin/ymax: vertical range used for this panel
// title:  label drawn above the curve
// breaks: array of t where the curve jumps (drawn as separate strokes)
#let fn-panel(
  f, ymin, ymax,
  title: none,
  breaks: (),
  w: 3.6, h: 2.6,
) = canvas(length: 1cm, {
  import draw: *
  let P(t, y) = (t * w, (y - ymin) / (ymax - ymin) * h)

  // axes
  let ax = (stroke: 0.6pt, mark: (end: "stealth", fill: black, scale: 0.8))
  line((0, 0), (w * 1.1, 0), ..ax)
  line((0, 0), (0, h * 1.12), ..ax)
  content((w * 1.1, 0), anchor: "north", padding: 4pt, text(size: 8pt)[$t$])

  // t-axis ticks at 0, 1/2, 1
  for t in (0, 0.5, 1) {
    line(P(t, ymin), (t * w, -0.08), stroke: 0.4pt)
    content((t * w, -0.08), anchor: "north", padding: 2pt, text(size: 7pt)[$#t$])
  }

  // curve, split at the break points
  let edges = (0,) + breaks + (1,)
  for i in range(edges.len() - 1) {
    let a = edges.at(i)
    let b = edges.at(i + 1)
    let steps = calc.max(2, int((b - a) * 100))
    let pts = range(steps + 1).map(j => {
      let t = a + (b - a) * j / steps
      P(t, f(t))
    })
    line(..pts, stroke: 1pt + rgb("#1f77ff"))
  }

  if title != none {
    content((w / 2, h * 1.12), anchor: "south", text(size: 9pt)[#title])
  }
})

#let step-f(t) = if calc.abs(t - 0.5) > 0.25 { 0.0 } else { 1.0 }
#let smooth-h(t) = 1 / calc.sqrt(1 + 0.5 * calc.sin(2 * calc.pi * t))
#let hat-g(t) = 0.5 - calc.abs(t - 0.5)

#let fig-functions = figure(
  framed(grid(
    columns: 3, column-gutter: 1.5em,
    fn-panel(step-f, -0.1, 1.25, title: $f$ + [ (step)], breaks: (0.25, 0.75)),
    fn-panel(hat-g, 0, 0.55, title: $g$ + [ (hat)]),
    fn-panel(smooth-h, 0.7, 1.5, title: $h$ + [ ($C^infinity$)]),
  )),
  caption: [Functions to reconstruct using trigonometric interpolation.],
)
