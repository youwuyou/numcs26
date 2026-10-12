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

🚧 Under construction.