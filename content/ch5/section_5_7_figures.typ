// CeTZ figures for section 5.7 (Quadratur in R^d und duenne Gitter). Each
// drawing is exposed as a content value so the section source just imports and
// places it, mirroring the section_5_1_figures.typ pattern.
#import "../_site.typ": framed
#import "@preview/cetz:0.4.2": canvas, draw

// One hue for the domain object Omega (blue), neutral gray for axes and ticks,
// a light gray dash for the guide lines dropping onto the axes.
#let dom = rgb("#1f77ff")
#let axis = rgb("#555555")
#let guide = rgb("#9aa0a6")

#let centered-figure-body(body) = context {
  if target() == "html" {
    html.elem("div", attrs: (style: "display: flex; justify-content: center;"))[#framed(body)]
  } else {
    align(center)[#framed(body)]
  }
}
 
// --- fig-domains: the nested d = 1, 2, 3 domains, drawn as a left-to-right ---
// progression of panels so the increase in dimension reads as a sequence. Each
// Omega is the same blue object; axes and guides are neutral so the eye tracks
// the region, not the scaffolding.
#let fig-domains = figure(
  centered-figure-body(canvas(length: 1cm, {
    import draw: *
 
    // ---- Panel d = 1: the interval I = [a, b] sitting on the x_1-axis ----
    group({
      translate((0, 2.5))
      line((0, 0), (3.4, 0), mark: (end: "stealth", fill: axis), stroke: axis)
      content((3.75, 0), text(fill: axis, $x_1$))
      // the domain itself: the bold blue segment between a and b
      line((0.8, 0), (2.7, 0), stroke: 2.4pt + dom)
      line((0.8, -0.14), (0.8, 0.14), stroke: axis)
      line((2.7, -0.14), (2.7, 0.14), stroke: axis)
      content((0.8, -0.42), $a$)
      content((2.7, -0.42), $b$)
      content((1.75, 0.55), text(fill: dom, $Omega = [a, b]$))
    })
 
    // ---- Panel d = 2: the rectangle [a, b] times [c, d] ----
    group({
      translate((5.0, 1.15))
      // axes
      line((0, 0), (3.3, 0), mark: (end: "stealth", fill: axis), stroke: axis)
      line((0, 0), (0, 2.9), mark: (end: "stealth", fill: axis), stroke: axis)
      content((3.6, 0), text(fill: axis, $x_1$))
      content((0, 3.2), text(fill: axis, $x_2$))
      let (a, b, c, d) = (0.7, 2.5, 0.7, 2.2)
      // guide lines dropping the four edges onto the axes
      line((a, 0), (a, c), stroke: (paint: guide, dash: "dashed", thickness: 0.6pt))
      line((b, 0), (b, c), stroke: (paint: guide, dash: "dashed", thickness: 0.6pt))
      line((0, c), (a, c), stroke: (paint: guide, dash: "dashed", thickness: 0.6pt))
      line((0, d), (a, d), stroke: (paint: guide, dash: "dashed", thickness: 0.6pt))
      // the domain: the blue rectangle
      line((a, c), (b, c), (b, d), (a, d), close: true, fill: dom.transparentize(86%), stroke: 1.6pt + dom)
      content((a, -0.42), $a$)
      content((b, -0.42), $b$)
      content((-0.3, c), $c$)
      content((-0.3, d), $d$)
      content((1.6, 1.45), text(fill: dom, $Omega subset RR^2$))
    })
 
    // ---- Panel d = 3: the box [a, b] x [c, d] x [e, f] ----
    // Oblique view: x_1 runs right, x_2 up, x_3 recedes up-right (away from the
    // viewer), so the front face is the k = 1 face. The three hidden edges out of
    // the back-bottom-left vertex are dashed, which fixes the cube's orientation.
    // Instead of projecting onto axes (which a 2D projection of 3D cannot do
    // unambiguously), each interval is a dimension line set just off one box
    // edge: [a, b] under the front bottom edge, [c, d] left of the front left
    // edge, [e, f] beside the bottom right depth edge. A small triad gives the
    // axis directions.
    group({
      translate((10.6, 0.35))
      let u3 = (0.55, 0.46) // projected unit step along -x_3 (into the page)
      let o = (1.3, 0.95) // front-bottom-left vertex (a, c, f)
      let (w, h, dp) = (2.0, 1.55, 1.3) // box width, height, depth
      // V(i, j, k): i, j in {0, 1} pick a/b, c/d; k = 1 is the front (x_3 = f)
      let V(i, j, k) = (o.at(0) + w * i + u3.at(0) * dp * (1 - k), o.at(1) + h * j + u3.at(1) * dp * (1 - k))
      let add(p, q) = (p.at(0) + q.at(0), p.at(1) + q.at(1))
      let dim = (paint: axis, thickness: 0.7pt)
      let ext = (paint: guide, thickness: 0.6pt)
      let tk = 0.09
 
      // the domain: visible edges solid, the three hidden edges dashed
      let ed = 1.5pt + dom
      let hid = (paint: dom.transparentize(35%), thickness: 1pt, dash: "dashed")
      line(V(0, 0, 0), V(1, 0, 0), stroke: hid)
      line(V(0, 0, 0), V(0, 1, 0), stroke: hid)
      line(V(0, 0, 0), V(0, 0, 1), stroke: hid)
      line(V(0, 0, 1), V(1, 0, 1), V(1, 1, 1), V(0, 1, 1), close: true, fill: dom.transparentize(88%), stroke: ed)
      line(V(0, 1, 1), V(0, 1, 0), V(1, 1, 0), V(1, 0, 0), V(1, 0, 1), stroke: ed)
      line(V(1, 1, 1), V(1, 1, 0), stroke: ed)
      content(add(V(1, 1, 0), (0.15, 0.32)), text(fill: dom, $Omega subset RR^3$))
 
      // [a, b]: dimension line below the front bottom edge
      let off = (0, -0.38)
      let (p, q) = (add(V(0, 0, 1), off), add(V(1, 0, 1), off))
      line(add(V(0, 0, 1), (0, -0.08)), add(p, (0, -0.1)), stroke: ext)
      line(add(V(1, 0, 1), (0, -0.08)), add(q, (0, -0.1)), stroke: ext)
      line(p, q, stroke: dim)
      content(add(p, (0, -0.32)), $a$)
      content(add(q, (0, -0.32)), $b$)
 
      // [c, d]: dimension line left of the front left edge
      let off = (-0.38, 0)
      let (p, q) = (add(V(0, 0, 1), off), add(V(0, 1, 1), off))
      line(add(V(0, 0, 1), (-0.08, 0)), add(p, (-0.1, 0)), stroke: ext)
      line(add(V(0, 1, 1), (-0.08, 0)), add(q, (-0.1, 0)), stroke: ext)
      line(p, q, stroke: dim)
      content(add(p, (-0.32, 0)), $c$)
      content(add(q, (-0.32, 0)), $d$)
 
      // [e, f]: dimension line right of the bottom right depth edge
      let off = (0.38, 0)
      let (p, q) = (add(V(1, 0, 0), off), add(V(1, 0, 1), off))
      line(add(V(1, 0, 0), (0.08, 0)), add(p, (0.1, 0)), stroke: ext)
      line(add(V(1, 0, 1), (0.08, 0)), add(q, (0.1, 0)), stroke: ext)
      line(p, q, stroke: dim)
      content(add(p, (0.3, 0)), $e$)
      content(add(q, (0.24, -0.2)), $f$)
 
      // orientation triad above the box's top-left corner, its arrows parallel
      // to the three dashed hidden edges (x_3 runs along -u3, toward the viewer)
      let t = add(V(0, 1, 1), (-0.55, 0.85))
      let ar = (end: "stealth", fill: axis, scale: 0.8)
      let L = 0.75
      line(t, add(t, (L, 0)), mark: ar, stroke: axis)
      line(t, add(t, (0, L)), mark: ar, stroke: axis)
      line(t, add(t, (-L * u3.at(0) / 0.72, -L * u3.at(1) / 0.72)), mark: ar, stroke: axis)
      content(add(t, (L + 0.25, 0)), text(fill: axis, size: 0.9em, $x_1$))
      content(add(t, (0, L + 0.22)), text(fill: axis, size: 0.9em, $x_2$))
      content(add(t, (-L * u3.at(0) / 0.72 - 0.2, -L * u3.at(1) / 0.72 - 0.17)), text(fill: axis, size: 0.9em, $x_3$))
    })
  })),
)

// --- fig-dyadic: the dyadic refinement of the reference interval [0, 1]. ---
// Three stacked number lines for levels ell = 1, 2, 3; level ell carries the
// nodes k / 2^ell, so the interval is split into 2^ell equal pieces. The level
// labels sit on the left; the shared endpoints 0 and 1 are marked only on the
// bottom line to keep the upper lines uncluttered.
#let fig-dyadic = figure(
  centered-figure-body(canvas(length: 1cm, {
    import draw: *

    let total = 8.0 // drawn width of the unit interval [0, 1]
    // vertical placement of the three levels (top to bottom: ell = 1, 2, 3)
    let rows = ((1, 2.6), (2, 1.3), (3, 0.0))

    for (lv, y) in rows {
      // the base line of this level
      line((0, y), (total, y), stroke: axis)
      content((-0.9, y), text(fill: axis, $ell = #lv$))
      let n = calc.pow(2, lv)
      for k in range(0, n + 1) {
        let x = total * k / n
        // endpoints get a taller tick, interior dyadic nodes a shorter one
        let h = if k == 0 or k == n { 0.22 } else { 0.15 }
        let col = if k == 0 or k == n { axis } else { dom }
        line((x, y - h), (x, y + h), stroke: 1.2pt + col)
      }
    }

    // shared endpoint labels 0 and 1 under the bottom line
    content((0, -0.5), $0$)
    content((total, -0.5), $1$)
  })),
  caption: [Dyadic refinement of $hat(I) = [0, 1]$: level $ell$ has nodes $k \/ 2^ell$, $k = 0, dots, 2^ell$.],
)
