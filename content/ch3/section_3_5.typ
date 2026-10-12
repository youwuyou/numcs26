#import "../_site.typ": section, defbox, sidenote

#let meta = (id: "trigonometrische-interpolation-und-fehlerabschaetzungen", title: "3.5 Trigonometrische Interpolation und Fehlerabschätzungen")

#show: section.with(meta)

== #meta.title

🚧 Under construction.

In this short introduction, we use $epsilon_i$ for absolute approximation errors from a numerical experiment and distinguish between two types of convergence, which we call the #underline[algebraic convergence]  and #underline[exponential convergence].

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

We are next interested in knowing how to monitor the convergence. An appropriate use of the line-plot scales in the $x$- and $y$-axis#sidenote[See documentation on #link("https://matplotlib.org/stable/gallery/scales/log_demo.html")[log-(scale) demo] of line plots of `matplotlib`.], respectively, allows us to distinguish them.

- *Algebraic convergence:* use log-log scale#sidenote[Specified via `loglog` in matplotlib.].

$
epsilon_(i) &approx C n_(i)^(-p)\
<=> log(epsilon_(i)) &approx log(C n_(i)^(-p)) \
<=> log(epsilon_(i)) &approx log(C) + log(n_(i)^(-p))\
<=> log(epsilon_(i)) &approx log(C) - p log(n_(i))
$

$=>$ slope of line for data points $(log n_(i), log epsilon_(i))$ predicts rate of algebraic convergence.

- *Exponential convergence:* use lin-log scale.#sidenote[Specified via `semilogy` in matplotlib.]

$
epsilon_(i) &approx C exp(-beta n_(i))\
<=> log(epsilon_(i)) &approx log(C exp(-beta n_(i)))\
<=> log(epsilon_(i)) &approx log(C) + log(exp(-beta n_(i)))\
<=> log(epsilon_(i)) &approx log(C) - beta n_(i)
$

$=>$ slope of line for data points $(n_(i), log epsilon_(i))$ predicts rate of exponential convergence.