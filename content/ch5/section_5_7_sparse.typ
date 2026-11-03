// CeTZ figure for section 5.7: the level-2 sparse grid read by
// inclusion-exclusion. Kept in its own module and exposed as a content value
// so the section source just imports and places it, mirroring
// section_5_7_curse.typ and section_5_7_aniso.typ.
#import "../_site.typ": cetz-figure, framed
#import "@preview/cetz:0.4.2": canvas, draw

// Shared palette, matching the equation colors (cblue / cred in _site.typ):
// blue marks the isotropic (1, 1) overlap that is subtracted, red the
// anisotropic (2, 1) and (1, 2) grids that are added. Neutral gray for the
// grid lines and the brace.
#let cblue = rgb("#1f77ff")
#let cred = rgb("#e4272b")
#let axis = rgb("#555555")
#let guide = rgb("#9aa0a6")

#let centered-figure-body(body) = context {
  if target() == "html" {
    html.elem("div", attrs: (style: "display: flex; justify-content: center;"))[#framed(body)]
  } else {
    align(center)[#framed(body)]
  }
}

// --- fig-sparse: the level-2 sparse grid read by inclusion-exclusion, laid ---
// out as in the handwritten notes. The finished sparse grid sits on the left;
// a brace opens onto the signed combination it expands into, stacked top to
// bottom: the (1, 1) overlap subtracted, then the (2, 1) and (1, 2) full grids
// added. Every grid is drawn as a sheared parallelogram so the plane reads as
// a tilted square, matching the perspective of the reference sketch.
#let fig-sparse = cetz-figure("fig-sparse", centered-figure-body(canvas(length: 1cm, {
    import draw: *

    // the node coordinates of a level-l direction: 2^l + 1 points on [0, 1]
    let coords(l) = {
      let n = calc.pow(2, l)
      range(0, n + 1).map(k => k / n)
    }
    let x1 = coords(1) // 3 nodes
    let x2 = coords(2) // 5 nodes

    // a sheared unit grid: (x, y) in [0,1]^2 maps to a parallelogram of width w,
    // height h, with the top edge pushed right by the shear sk.
    let shear(ox, oy, w, h, sk, xs, ys, col) = {
      let P(x, y) = (ox + w * x + sk * y, oy + h * y)
      line(P(0, 0), P(1, 0), P(1, 1), P(0, 1), close: true, stroke: (paint: guide, thickness: 0.8pt))
      for x in xs { line(P(x, 0), P(x, 1), stroke: (paint: guide, thickness: 0.4pt)) }
      for y in ys { line(P(0, y), P(1, y), stroke: (paint: guide, thickness: 0.4pt)) }
      for x in xs { for y in ys { circle(P(x, y), radius: 0.06, fill: col, stroke: none) } }
    }

    let w = 1.8 // width of a small panel
    let h = 1.2 // height of a small panel
    let sk = 0.55 // shear of every panel

    // --- the finished sparse grid on the left: union of the (2,1) and (1,2) ---
    // node sets, drawn larger and with the same shear.
    let sw = 2.3
    let sh = 1.7
    let ssk = 0.75
    let soy = 1.75
    let Ps(x, y) = (sw * x + ssk * y, soy + sh * y)
    line(Ps(0, 0), Ps(1, 0), Ps(1, 1), Ps(0, 1), close: true, stroke: (paint: guide, thickness: 0.9pt))
    for x in x2 { line(Ps(x, 0), Ps(x, 1), stroke: (paint: guide, thickness: 0.4pt)) }
    for y in x2 { line(Ps(0, y), Ps(1, y), stroke: (paint: guide, thickness: 0.4pt)) }
    for x in x2 { for y in x1 { circle(Ps(x, y), radius: 0.065, fill: black, stroke: none) } }
    for x in x1 { for y in x2 { circle(Ps(x, y), radius: 0.065, fill: black, stroke: none) } }
    content((1.4, 1.15), text(fill: axis, $S_2^2$))

    // --- equals sign and the brace opening onto the stack ---
    content((3.35, 2.6), text(size: 1.4em, $=$))
    let bx = 4.05
    let ytop = 5.1
    let ybot = 0.1
    let ymid = 2.6
    let brace = (paint: axis, thickness: 1.0pt)
    line((bx, ytop), (bx - 0.22, ytop - 0.28), stroke: brace)
    line((bx - 0.22, ytop - 0.28), (bx - 0.22, ymid + 0.28), stroke: brace)
    line((bx - 0.22, ymid + 0.28), (bx - 0.46, ymid), stroke: brace)
    line((bx - 0.46, ymid), (bx - 0.22, ymid - 0.28), stroke: brace)
    line((bx - 0.22, ymid - 0.28), (bx - 0.22, ybot + 0.28), stroke: brace)
    line((bx - 0.22, ybot + 0.28), (bx, ybot), stroke: brace)

    // --- the three stacked component grids, top to bottom as in the notes ---
    let px = 4.7 // left edge of each small panel
    let lx = px + w + sk + 0.35 // label column, clear of the sheared top-right
    let sgn-x = 4.3 // the +/- sign, left of each panel

    // (1,1): the subtracted overlap, 3 x 3
    let oy11 = 3.8
    shear(px, oy11, w, h, sk, x1, x1, cblue)
    content((sgn-x, oy11 + h / 2), text(size: 1.3em, $-$))
    content((lx, oy11 + h / 2 + 0.22), $(ell_1, ell_2) = (1, 1)$, anchor: "west")
    content((lx, oy11 + h / 2 - 0.26), text(size: 0.85em)[$3 times 3$ nodes], anchor: "west")

    // (2,1): added, 5 x 3
    let oy21 = 1.9
    shear(px, oy21, w, h, sk, x2, x1, cred)
    content((sgn-x, oy21 + h / 2), text(size: 1.3em, $+$))
    content((lx, oy21 + h / 2 + 0.22), $(ell_1, ell_2) = (2, 1)$, anchor: "west")
    content((lx, oy21 + h / 2 - 0.26), text(size: 0.85em)[$5 times 3$ nodes], anchor: "west")

    // (1,2): added, 3 x 5
    let oy12 = 0.0
    shear(px, oy12, w, h, sk, x1, x2, cred)
    content((sgn-x, oy12 + h / 2), text(size: 1.3em, $+$))
    content((lx, oy12 + h / 2 + 0.22), $(ell_1, ell_2) = (1, 2)$, anchor: "west")
    content((lx, oy12 + h / 2 - 0.26), text(size: 0.85em)[$3 times 5$ nodes], anchor: "west")
  })),
)
