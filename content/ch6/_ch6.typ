// Shared math helpers for Chapter 6 (Nullstellensuche).
//
// Notation convention for the whole chapter:
//   * vector variables x, y  -> bold UPRIGHT, via `xv` / `yv`
//   * the solution/fixed point -> `xv^(star)`  (never `xit(star)`, which would
//     parenthesize the star like an iteration index: x^((*)))
//   * vector-valued function / operators -> `bold(F)`, `bold(J)`; the
//     derivative operator stays non-bold: Jacobian is `D bold(F)`
//   * vector zero -> `bold(0)`
//   * scalar (1D) case -> plain x, F, F'; wrap in `scalar(...)` so the shared
//     iterate helpers render non-bold.
//
// Classical iterate notation: bold UPRIGHT x with a parenthesized superscript,
// usable directly in math mode: $xit(k)$ -> x^(k), $xit(k - 1)$, $xit(0)$.

// Whether the iterate vector renders bold (default) or scalar/non-bold.
// Flipped off inside `scalar(...)` for the one-dimensional case.
#let ch6-bold = state("ch6-bold", true)

#let xv = context if ch6-bold.get() { $bold(upright(x))$ } else { $upright(x)$ }
#let yv = context if ch6-bold.get() { $bold(upright(y))$ } else { $upright(y)$ }
#let xit(k) = $xv^(( #k ))$

// Scalar (1D) rendering: same iterate notation but non-bold, for the
// one-dimensional case where x is a scalar. Usage in math mode:
// $scalar(xit(k + 1) := xit(k) - frac(F(xit(k)), F'(xit(k))))$.
#let scalar(body) = {
  ch6-bold.update(false)
  body
  ch6-bold.update(true)
}
