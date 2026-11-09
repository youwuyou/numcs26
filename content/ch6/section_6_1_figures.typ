// Tangent sketch for section 6.1, drawn with CeTZ. The circle x^2 + y^2 = 8 and
// the line x + y = 4 meet at the single tangent point x^* = (2, 2), so the
// nonlinear system has a unique solution. Exposed as the content value
// `fig-tangent`, so the section source just imports and places it.
#import "../_site.typ": framed, cetz-figure
#import "@preview/cetz:0.4.2": canvas, draw

#let _blue = rgb("#1e88e5")
#let _green = rgb("#00a651")

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

#let fig-tangent = cetz-figure("fig-tangent",
  centered-figure-body(canvas(length: 0.55cm, {
    import draw: *
    set-style(stroke: (cap: "round", join: "round"))

    // Axes
    let ax = (mark: (end: "stealth", size: 0.28, fill: black), stroke: black + 0.8pt)
    line((-4, 0), (7, 0), ..ax)
    line((0, -4), (0, 7), ..ax)
    content((7, 0), $x$, anchor: "west", padding: 0.12)
    content((0, 7), $y$, anchor: "south", padding: 0.12)

    // Curves
    circle((0, 0), radius: calc.sqrt(8), stroke: _green.darken(10%) + 1.8pt)
    line((-0.8, 4.8), (4.8, -0.8), stroke: _blue + 1.8pt)

    content((-2, -2), text(_green.darken(10%))[$x^2 + y^2 = 8$],
      anchor: "north-east", padding: 0.2)
    content((1.0, 3.3), text(_blue)[$x + y = 4$],
      anchor: "south-west", padding: 0.3)

    // Guide lines dropping from the tangent point to the axes
    let guide = (stroke: (paint: gray, dash: "dashed", thickness: 0.8pt))
    line((2, 0), (2, 2), ..guide)
    line((0, 2), (2, 2), ..guide)

    // Axis ticks marking the coordinates (2, 2)
    line((2, -0.15), (2, 0.15), stroke: black + 0.8pt)
    line((-0.15, 2), (0.15, 2), stroke: black + 0.8pt)
    content((2, -0.25), $2$, anchor: "north", padding: 0.1)
    content((-0.25, 2), $2$, anchor: "east", padding: 0.1)

    // Solution
    circle((2, 2), radius: 0.2, fill: white, stroke: black + 1.2pt)
    content((2, 2), $bold(x)^*$, anchor: "south-west", padding: 0.3)
  })),
  caption: [The tangent point $bold(x)^(star)$ is the only point satisfying both
    equations. The system is nonlinear because the circle equation is quadratic.],
)
