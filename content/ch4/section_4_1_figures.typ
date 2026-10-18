// Change-of-variable sketch for section 4.1, drawn with CeTZ. Exposed as the
// content value `fig-change-of-variable` so the section source just imports and
// places it. The affine change of variable carries a point t on the reference
// interval hat(I) = [0,1] to its image x = x_(j-1) + h_j t on the subinterval I_j.
#import "../_site.typ": framed
#import "@preview/cetz:0.4.2": canvas, draw

// Palette shares the exact hexes of the math-color helpers cteal / cviolet /
// corange so the figure and the equations' variables read in the same colors,
// and avoids the red (cred) / blue (cblue) already carrying meaning in the prose:
// teal = reference coordinate t, violet = physical coordinate x, amber = the change of variable.
#let cov-ref = rgb("#009688")
#let cov-tgt = rgb("#7c3aed")
#let cov-map = rgb("#e8710a")
#let cov-gray = rgb("#555555")

#let centered-figure-body(body) = context {
  if target() == "html" {
    html.elem("div", attrs: (style: "display: flex; justify-content: center;"))[#framed(body)]
  } else {
    align(center)[#framed(body)]
  }
}

#let fig-change-of-variable = figure(
  centered-figure-body(canvas(length: 1cm, {
    import draw: *

    let cy = 2
    // reference interval hat(I) = [0,1]
    let (a0, a1) = (1, 4)
    // target subinterval I_j = [x_(j-1), x_j]
    let (b0, b1) = (6, 11)
    // the sampled parameter, as a fraction along each interval
    let f = 0.4
    let pt = (a0 + (a1 - a0) * f, cy)
    let px = (b0 + (b1 - b0) * f, cy)

    // the two interval segments
    line((a0, cy), (a1, cy), stroke: 2pt + cov-ref)
    line((b0, cy), (b1, cy), stroke: 2pt + cov-tgt, mark: (end: "stealth"))

    // endpoint ticks
    for x in (a0, a1, b0, b1) {
      line((x, cy - 0.12), (x, cy + 0.12), stroke: 1pt + cov-gray)
    }

    // interval names above
    content(((a0 + a1) / 2, cy + 1.75), text(fill: cov-ref, $hat(I) = [0, 1]$))
    content(((b0 + b1) / 2, cy + 1.75), text(fill: cov-tgt, $I_(j) = [x_(j-1), x_(j)]$))

    // endpoint labels below
    content((a0, cy - 0.42), $0$)
    content((a1, cy - 0.42), $1$)
    content((b0, cy - 0.42), $x_(j-1)$)
    content((b1, cy - 0.42), $x_(j)$)


    line((a0, cy - 1.2), (b1, cy - 1.2), stroke: none)

    // markers for the sampled point t (reference color) and its image x (target color)
    for (p, lab, col) in ((pt, $t$, cov-ref), (px, $x$, cov-tgt)) {
      line((p.at(0), cy + 0.78), (p.at(0), cy + 0.16), stroke: 1.1pt + col, mark: (end: "stealth", fill: col))
      content((p.at(0), cy + 1.02), text(fill: col, lab))
      circle(p, radius: 0.055, fill: col, stroke: none)
    }

    // arc carrying t to x = chi(t); endpoints lifted just above the lines so the
    // arrowhead stops at the interval instead of crossing it
    bezier(
      (pt.at(0), cy + 0.05), (px.at(0), cy + 0.05),
      (pt.at(0) + 1.1, cy + 1.34), (px.at(0) - 1.1, cy + 1.34),
      stroke: 0.6pt + black, mark: (end: "stealth", fill: black),
    )
    content(((pt.at(0) + px.at(0)) / 2, cy + 1.35), $chi$)
  })),
  caption: [The change of variable of $t in hat(I)$ into $x in I_(j)$.],
)

// The raw samples for the connect-the-dots example: nodes x = 0,1,2,3 with
// values y = 0,1,3,2. Only the data points are drawn -- no interpolant yet --
// so the reader first sees what is to be connected.
#let fig-connect-dots-data = figure(
  centered-figure-body(canvas(length: 1cm, {
    import draw: *

    let data = ((0, 0), (1, 1), (2, 3), (3, 2))
    let x-max = 3
    let y-max = 3
    // a little headroom beyond the axes
    let xp = x-max + 0.6
    let yp = y-max + 0.6

    // axes
    line((0, 0), (xp, 0), stroke: 0.8pt + cov-gray, mark: (end: "stealth", fill: cov-gray))
    line((0, 0), (0, yp), stroke: 0.8pt + cov-gray, mark: (end: "stealth", fill: cov-gray))
    content((xp + 0.25, 0), $x$)
    content((0, yp + 0.25), $y$)

    // ticks + labels on the x-axis
    for x in range(1, x-max + 1) {
      line((x, -0.1), (x, 0.1), stroke: 0.8pt + cov-gray)
      content((x, -0.38), text(0.85em, $#x$))
    }
    // ticks + labels on the y-axis
    for y in range(1, y-max + 1) {
      line((-0.1, y), (0.1, y), stroke: 0.8pt + cov-gray)
      content((-0.38, y), text(0.85em, $#y$))
    }

    // the data points
    for (x, y) in data {
      circle((x, y), radius: 0.09, fill: cov-tgt, stroke: none)
    }
  })),
  caption: [Samples of a function $f : RR -> RR$.],
)

// The assembled piecewise linear interpolant hat(f) for the connect-the-dots
// example: the same samples, now joined by straight segments. Corners at the
// interior nodes x = 1, 2 make the non-differentiability visible.
// Both subplots share one coordinate frame: x in [0,3], y in [-1,3], with the
// same ticks. Equal vertical extent means the x-axis (origin line y = 0) sits at
// the same height in both, so side by side the two origins align.
#let cd-x-max = 3
#let cd-y-min = -1
#let cd-y-max = 3
#let cd-xp = cd-x-max + 0.6
#let cd-yp = cd-y-max + 0.6
#let cd-yn = cd-y-min - 0.6

// Shared axes + ticks, parameterised only by the vertical-axis label.
#let cd-axes(ylabel) = {
  import draw: *
  line((0, 0), (cd-xp, 0), stroke: 0.8pt + cov-gray, mark: (end: "stealth", fill: cov-gray))
  line((0, cd-yn), (0, cd-yp), stroke: 0.8pt + cov-gray, mark: (end: "stealth", fill: cov-gray))
  content((cd-xp + 0.3, 0), $x$)
  content((0, cd-yp + 0.35), ylabel)
  for x in (1, 2, 3) {
    line((x, -0.1), (x, 0.1), stroke: 0.8pt + cov-gray)
    content((x, -0.38), text(0.85em, $#x$))
  }
  for y in (-1, 1, 2, 3) {
    line((-0.1, y), (0.1, y), stroke: 0.8pt + cov-gray)
    content((-0.38, y), text(0.85em, $#y$))
  }
}

// The assembled piecewise linear interpolant hat(f) for the connect-the-dots
// example: the same samples, now joined by straight segments. Corners at the
// interior nodes x = 1, 2 make the non-differentiability visible.
#let cnv-connect-dots-interp = canvas(length: 1cm, {
    import draw: *

    cd-axes($hat(f)(x)$)

    let data = ((0, 0), (1, 1), (2, 3), (3, 2))
    // the interpolant: straight segments between consecutive samples
    for i in range(data.len() - 1) {
      line(data.at(i), data.at(i + 1), stroke: 1.6pt + cov-map)
    }
    // the samples on top
    for (x, y) in data {
      circle((x, y), radius: 0.09, fill: cov-tgt, stroke: none)
    }
  })

// The derivative hat(f)' for the connect-the-dots example: a piecewise-constant
// step function (the per-piece slopes 1, 2, -1). Filled/hollow dots mark where
// each piece is / is not defined, so the jumps at x = 1, 2 read as gaps.
#let cnv-connect-dots-deriv = canvas(length: 1cm, {
    import draw: *

    cd-axes($hat(f)'(x)$)

    // (x0, x1, slope) for each subinterval
    let steps = ((0, 1, 1), (1, 2, 2), (2, 3, -1))
    // the constant pieces, with filled/hollow endpoints marking the jumps
    for (x0, x1, m) in steps {
      line((x0, m), (x1, m), stroke: 1.6pt + cov-map)
      circle((x0, m), radius: 0.08, fill: cov-map, stroke: none)
      circle((x1, m), radius: 0.08, fill: white, stroke: 1pt + cov-map)
    }
  })

// The interpolant and its derivative, shown side by side so the corners of
// hat(f) line up with the jumps of hat(f)'. html.frame rasterizes the whole
// grid to a single inline SVG, so the two-column layout survives HTML export.
#let fig-connect-dots-fn-deriv = figure(
  centered-figure-body(grid(
    columns: 2,
    column-gutter: 1.2cm,
    align: horizon,
    cnv-connect-dots-interp,
    cnv-connect-dots-deriv,
  )),
  caption: [The interpolant $hat(f)$ (left) and its derivative $hat(f)'$ (right).],
)
