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
