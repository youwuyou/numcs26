// CeTZ figure for section 5.7: the curse of dimensionality for an isotropic
// grid. Kept in its own module (separate from section_5_7_figures.typ) and
// exposed as a content value so the section source just imports and places it.
#import "../_site.typ": framed
#import "@preview/cetz:0.4.2": canvas, draw

// Shared palette: blue for the domain Omega, gray for axes, red for the nodes.
#let dom = rgb("#1f77ff")
#let axis = rgb("#555555")
#let guide = rgb("#9aa0a6")
#let node = rgb("#d62728")

#let centered-figure-body(body) = context {
  if target() == "html" {
    html.elem("div", attrs: (style: "display: flex; justify-content: center;"))[#framed(body)]
  } else {
    align(center)[#framed(body)]
  }
}

// --- fig-curse: the curse of dimensionality for an isotropic grid ---
// The same three domains as fig-domains, each filled with N = 3 nodes per
// direction (red, at the cell midpoints so all of them lie strictly inside).
// The count N^d = 3, 9, 27 is set under each panel. In the d = 3 panel the
// nodes fade with depth (back layer lightest) so the three layers separate.
#let fig-curse = figure(
  centered-figure-body(canvas(length: 1cm, {
    import draw: *
    let N = 3
    let mids = range(N).map(i => (i + 0.5) / N)
    let pt(p, alpha: 0%, r: 0.085) = circle(p, radius: r, fill: node.transparentize(alpha), stroke: 0.4pt + white)
    let count(x, d, n) = content((x, 0.45), $N^#d = 3^#d = #n$)

    // ---- d = 1 ----
    group({
      translate((0, 2.5))
      line((0, 0), (3.4, 0), mark: (end: "stealth", fill: axis), stroke: axis)
      content((3.75, 0), text(fill: axis, $x_1$))
      line((0.8, 0), (2.7, 0), stroke: 2.4pt + dom.transparentize(60%))
      line((0.8, -0.14), (0.8, 0.14), stroke: axis)
      line((2.7, -0.14), (2.7, 0.14), stroke: axis)
      for s in mids { pt((0.8 + 1.9 * s, 0)) }
    })
    count(1.75, 1, 3)

    // ---- d = 2 ----
    group({
      translate((5.0, 1.15))
      line((0, 0), (3.3, 0), mark: (end: "stealth", fill: axis), stroke: axis)
      line((0, 0), (0, 2.9), mark: (end: "stealth", fill: axis), stroke: axis)
      content((3.6, 0), text(fill: axis, $x_1$))
      content((0, 3.2), text(fill: axis, $x_2$))
      let (a, b, c, d) = (0.7, 2.5, 0.7, 2.2)
      line((a, c), (b, c), (b, d), (a, d), close: true, fill: dom.transparentize(86%), stroke: 1.6pt + dom)
      for s in mids { for t in mids { pt((a + (b - a) * s, c + (d - c) * t)) } }
    })
    count(6.6, 2, 9)

    // ---- d = 3 (same box and triad as fig-domains) ----
    group({
      translate((10.6, 0.35))
      let u3 = (0.55, 0.46)
      let o = (1.1, 0.95)
      let (w, h, dp) = (1.9, 1.55, 2.0)
      let V(i, j, k) = (o.at(0) + w * i + u3.at(0) * dp * (1 - k), o.at(1) + h * j + u3.at(1) * dp * (1 - k))
      // r = depth fraction: 0 at the front face, 1 at the back face
      let P(s, t, r) = (o.at(0) + w * s + u3.at(0) * dp * r, o.at(1) + h * t + u3.at(1) * dp * r)
      let add(p, q) = (p.at(0) + q.at(0), p.at(1) + q.at(1))
      let ed = 1.5pt + dom
      let hid = (paint: dom.transparentize(35%), thickness: 1pt, dash: "dashed")
      line(V(0, 0, 0), V(1, 0, 0), stroke: hid)
      line(V(0, 0, 0), V(0, 1, 0), stroke: hid)
      line(V(0, 0, 0), V(0, 0, 1), stroke: hid)
      // nodes, back layer first; lighter and slightly smaller with depth
      for (l, r) in mids.rev().enumerate() {
        let alpha = (70%, 40%, 0%).at(l)
        let rad = (0.062, 0.073, 0.085).at(l)
        for s in mids { for t in mids { pt(P(s, t, r), alpha: alpha, r: rad) } }
      }
      line(V(0, 0, 1), V(1, 0, 1), V(1, 1, 1), V(0, 1, 1), close: true, fill: dom.transparentize(92%), stroke: ed)
      line(V(0, 1, 1), V(0, 1, 0), V(1, 1, 0), V(1, 0, 0), V(1, 0, 1), stroke: ed)
      line(V(1, 1, 1), V(1, 1, 0), stroke: ed)

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
    count(12.9, 3, 27)
  })),
  // caption: [Curse of dimensionality: an isotropic grid with $N = 3$ nodes per direction has $N^d$ nodes ($d = 1, 2, 3$).],
)
