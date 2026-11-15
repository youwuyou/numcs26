// Cubic sketch for section 6.1, drawn with CeTZ. The strictly increasing cubic
// y = x^3 + x meets the line 2y - x = 3 at the single point x^* = (1, 2):
// the line's slope 1/2 stays below the cubic's minimal slope 1, so the curves
// cross exactly once and the system has a globally unique solution at which the
// Jacobian is nonsingular (det DF = 3x^2 + 1/2 > 0 everywhere). Exposed as the
// content value `fig-cubic`, so the section source just imports and places it.
#import "../_site.typ": framed, cetz-figure
#import "@preview/cetz:0.4.2": canvas, draw

#let _blue = rgb("#1e88e5")
#let _green = rgb("#00a651")

// The cubic is tall relative to its x-extent, so we compress the vertical axis
// by `sy` to keep a readable aspect ratio and relabel the y tick accordingly.
#let sy = 0.5

// Centers the drawing in both targets: a flex div in HTML, align(center) when
// paged. Mirrors the helper the other figure modules use so the live HTML path
// centers the figure even when the SVG cache is not in play.
#let centered-figure-body(body) = context {
  if target() == "html" {
    html.elem("div", attrs: (style: "display: flex; justify-content: center;"))[#framed(body)]
  } else {
    align(center)[#framed(body)]
  }
}

#let fig-cubic = cetz-figure("fig-cubic",
  centered-figure-body(canvas(length: 0.8cm, {
    import draw: *
    set-style(stroke: (cap: "round", join: "round"))

    // Axes (y-axis is drawn in compressed canvas units)
    let ax = (mark: (end: "stealth", size: 0.28, fill: black), stroke: black + 0.8pt)
    line((-2, 0), (2, 0), ..ax)
    line((0, -3), (0, 3), ..ax)
    content((2, 0), $x$, anchor: "west", padding: 0.12)
    content((0, 3), $y$, anchor: "south", padding: 0.12)

    // Cubic curve y = x^3 + x, sampled as a polyline over [-1.5, 1.5]
    let n = 60
    let pts = range(0, n + 1).map(i => {
      let x = -1.5 + 3.0 * i / n
      let y = x * x * x + x
      (x, y * sy)
    })
    line(..pts, stroke: _green.darken(10%) + 1.8pt)

    // Line 2y - x = 3, i.e. y = (1/2) x + 3/2 (drawn in compressed canvas units)
    let line-y(x) = (0.5 * x + 1.5) * sy
    line((-2, line-y(-2)), (2, line-y(2)), stroke: _blue + 1.8pt)

    content((-1.5, -1.5 * sy), text(_green.darken(10%))[$y = x^3 + x$],
      anchor: "north-east", padding: 0.2)
    content((-0.9, line-y(-0.9)), text(_blue)[$2 y - x = 3$],
      anchor: "south-east", padding: 0.18)

    // Guide lines from the intersection point to the axes
    let guide = (stroke: (paint: gray, dash: "dashed", thickness: 0.8pt))
    line((1, 0), (1, 2 * sy), ..guide)
    line((0, 2 * sy), (1, 2 * sy), ..guide)

    // Axis ticks marking the coordinates (1, 2)
    line((1, -0.15), (1, 0.15), stroke: black + 0.8pt)
    line((-0.15, 2 * sy), (0.15, 2 * sy), stroke: black + 0.8pt)
    content((1, -0.25), $1$, anchor: "north", padding: 0.1)
    content((-0.25, 2 * sy), $2$, anchor: "east", padding: 0.1)

    // Solution
    circle((1, 2 * sy), radius: 0.12, fill: white, stroke: black + 1.2pt)
    content((1, 2 * sy), $bold(x)^*$, anchor: "south-east", padding: 0.28)
  })),
  caption: [The intersection point $bold(x)^(star)$ is the only point satisfying both equations.],
)
