#import "../_site.typ": section, slidebreak, ip, definition, defbox, lemma, theorem, example, thought, admonition, proof, figure-img, sidenote, cblue, cred, conj, boxeq, divider, anchor, anchor-ref, colive

#let meta = (id: "trigonometrische-interpolation-und-fehlerabschaetzungen", title: "3.5 Trigonometrische Interpolation und Fehlerabschätzungen")

#show: section.with(meta)

== #meta.title

#thought("Monitoring approximation errors in appropriate coordinate systems.")[
In #link("https://youwuyou.github.io/numcs26/ch1.html#1-2-1big-o-notation")[section 1.2] we introduced the big-O notation. For two functions $f, g: NN -> RR$, we write $f in O(g)$ or with the notation, $f(n) = O(g)$ to denote that a #strong[benchmark function] $g$ bounds the growth of $f$. Instead of seeing $f$ as a function that tracks the use of computational resources, we now examine a different use case.#sidenote[In fact, in many previous assignments, we were already asked to monitor errors between the approximation and ground truth by recording errors $epsilon_(i)$ at each resolution $i in NN$. Then to postprocess these data, we have used the "lin-log" or "log-log" plots and examine if such discrete data points lie on a straight line, as seen in the #link("https://youwuyou.github.io/numcs26/ch0.html#d-using-matplotlib-for-data-visualization")[data visualization section].]  
]

Let $E: NN -> RR$ be the absolute *approximation error* of a scheme with problem size parameter $n$, and write $epsilon_(i) := E(n_(i))$ for the error observed at sizes $n_(1) < n_(2) < dots.c$. We distinguish between two types of converge
nce, which we call the #underline[algebraic convergence] and #underline[exponential convergence].

#defbox("Types of Convergence of Approximation Schemes (Gradinaru, p.95, 3.5.1).")[
  1. Algebraic Convergence ($p > 0$)

  $
  E(n) = O(frac(1, n^(p)))
  $

  2. Exponential Convergence ($0 < q < 1$), smooth

  $
  E(n) = O(q^(n))
  $
]

We are next interested in distinguishing these two types from measured errors. For this we assume the bounds in the definition are attained, i.e. $epsilon_(i) approx C dot g(n_(i))$ with $C > 0$ the constant from the definition of $O(g)$. An appropriate use of the line-plot scales in the $x$- and $y$-axis#sidenote[See documentation on #link("https://matplotlib.org/stable/gallery/scales/log_demo.html")[log-(scale) demo] of line plots of `matplotlib`.], respectively, then makes each type appear as a straight line.


#import "section_3_5_figures.typ": fig-algebraic, fig-exponential

#proof(title: [ *Algebraic convergence:* use log-log scale#sidenote[By using `loglog` in matplotlib.].], boxed: true)[

$
epsilon_(i) &approx C n_(i)^(-p)\
<=> log(epsilon_(i)) &approx log(C n_(i)^(-p)) \
<=> log(epsilon_(i)) &approx log(C) + log(n_(i)^(-p))\
<=> log(epsilon_(i)) &approx log(C) - p log(n_(i))
$

#boxeq[
$
log(epsilon_(i)) approx log(C) - p log(n_(i))
$
]

On log-log axes the data points $(log n_(i), log epsilon_(i))$ lie on a line of slope $-p$, from which we read off the rate of algebraic convergence.
]

#fig-algebraic


#proof(title: [*Exponential convergence:* use lin-log scale.#sidenote[By using `semilogy` in matplotlib.]], boxed: true)[


Since $0 < q < 1$, we can write $q = exp(-beta)$ with $beta := -log(q) > 0$, so that $q^(n_(i)) = exp(-beta n_(i))$.

$
epsilon_(i) &approx C exp(-beta n_(i))\
<=> log(epsilon_(i)) &approx log(C exp(-beta n_(i)))\
<=> log(epsilon_(i)) &approx log(C) + log(exp(-beta n_(i)))\
<=> log(epsilon_(i)) &approx log(C) - beta n_(i)
$

#boxeq[
$
log(epsilon_(i)) approx log(C) - beta n_(i)
$
]

On lin-log axes the data points $(n_(i), log epsilon_(i))$ lie on a line of slope $-beta = log(q)$, from which we read off the rate of exponential convergence.
]


#fig-exponential


#divider()

=== Asymptotic Behaviors of Approximation Errors in Trigonometric Approximation

With the classification on types of error convergence as introduced in the section above, we now study how the trigonometric interpolation error behaves as $n -> infinity$ for three functions $f, g, h$ of different smoothness#sidenote[Examples from Gradinaru, p. 101, 3.5.25 - 3.5.27.].

The following three functions are ordered by increasing smoothness: a discontinuous step function $f$, a continuous hat function $g$ with one corner, and a smooth periodic function $h$.

#import "section_3_5_functions.typ": fig-functions
#fig-functions


Here $n$ denotes the number of interpolation nodes. We use equidistant nodes $t_(k) := frac(k, n)$, $k = 0, dots, n-1$. For all three plots below, the lin-log plot is used, however, we shall notice only the $h in C^(infinity)$ function has a broad span of decrease in error magnitude, from about $10^0$ to $10^(-15)$ with increasing $n$.

#example("(Left) — " + $f$ + " Step function (Algebraic convergence)")[
  The first function we consider converges the worst, it is a discontinuous *step function* with jumps at $t = 1 / 4$ and $t = 3 / 4$.

  $
  f : [0,1] -> RR, quad
  f(t) = cases(
  0 quad "for" abs(t - frac(1,2)) > frac(1, 4),
  1 quad "else"
  )
  $

  In fact, at its jump points, we see the "Gibbs phenomenon", i.e. the oscillatory behavior of the Fourier series of a piecewise continuously differentiable periodic function around a jump discontinuity.

  #figure-img(
    "content/ch3/trig_interp_step_f.png",
    "Trigonometric interpolation of the step function for increasing n, and its error",
    width: 100%,
    credit: [Image Source: Gradinaru, p. 101, 3.5.25.],
  )[
    Trigonometric interpolation of the step function.
  ]
]

#example("(Middle) — " + $g$ + " Hat function (Algebraic convergence)")[
  A continuous hat function#sidenote[Note that the script states $g(t) = abs(t - frac(1, 2))$, it is a typo.] with one corner at $t = 1 / 2$.

  $
  g : [0, 1] -> RR, quad g(t) = frac(1, 2) - abs(t - frac(1, 2))
  $

  Here, we already see some improvements and the absence of the Gibbs phenomenon. However, the errors still only improve by a few magnitudes in exponents.

  #figure-img(
    "content/ch3/trig_interp_wedge_g.png",
    "Trigonometric interpolation of the hat function for increasing n, and its error",
    width: 100%,
    credit: [Image Source: Gradinaru, p. 101, 3.5.26.],
  )[
    Trigonometric interpolation of the hat function.
  ]
]

#example("(Right) — " + $h in C^(infinity)$ + " periodic function (Exponential convergence)")[
  This is the smoothest function and is $1$-periodic,

  $
  h : RR -> RR, quad h(t) = frac(1, sqrt(1 + frac(1, 2) sin(2 pi t)))
  $

  Here, we see a drastic decrease in errors. On a lin-log plot, this demonstrates the exponential convergence of errors, which is highly desirable.

  #figure-img(
    "content/ch3/trig_interp_smooth_h.png",
    "Trigonometric interpolation of the smooth function for increasing n, and its error",
    width: 100%,
    credit: [Image Source: Gradinaru, p. 101, 3.5.27.],
  )[
    Trigonometric interpolation of the smooth periodic function.
  ]
]


Now we collect the errors of all three functions in a single plot. The colors encode the functions directly: $cblue(f)$, $cred(g)$, and $colive(h)$. The non-smooth functions $cblue(f)$ and $cred(g)$ improve slowly, while the smooth function $colive(h)$ drops rapidly to machine precision and shows highly desirable exponential convergence of approximation errors.

#figure-img(
  "content/ch3/trig_interp_error_convergence.png",
  "Maximum-norm trigonometric interpolation error against the node count for the step, hat, and smooth functions",
  width: 70%,
  credit: [Image Source: Gradinaru, p. 96, Fig. 247.],
)[
  Maximum-norm error against the node count.
]