#import "../_site.typ": section, slidebreak, ip, definition, lemma, theorem, example, thought, admonition, proof, figure-img, sidenote, cblue, cred, colive, corange, conj, boxeq, divider, proof

#let meta = (id: "trigonometrische-polynome-und-fourier-reihen", title: "3.1 Trigonometrische Polynome und Fourier-Reihen")

#show: section.with(meta)

== #meta.title

#thought("A Formal Introduction to the Space " + $L^(2)$)[ In this section, we take a formal approach to the Fourier series by first introducing the function space $L^(2)(0,1)$. It is an infinite-dimensional vector space, where each function $f in L^(2)(0,1)$ is a vector. In particular, it is also an inner product space. To see this, we will introduce a suitable definition of the inner product and see how it introduces an induced norm, that further allows us to "measure distances" between functions.#sidenote[Although this might be a new view to some of our readers, it is closely analogous to the familiar Euclidean space $RR^(n)$.] We then will develop an alternative notion of convergence that is particularly suited to the study of Fourier series.

]

#slidebreak()

=== Function Space $L^(2)$ as an Inner Product Space

We study complex-valued functions $f: (0, 1) -> CC$ on a bounded interval $(0, 1) subset RR$#sidenote[We may also consider $(a, b)$ for $a<b$; working on $(0,1)$ costs no generality, as any such interval reparametrizes to $(0,1)$, see "Bemerkung 3.1.4".]. We restrict to those that are *square-integrable*, meaning $abs(f)^(2)$ is Lebesgue-integrable:

$
integral_(0)^(1) abs(f(x))^(2) d x < infinity.
$


These form a function space, the $L^(2)$-space#sidenote["$L$" for Lebesgue, "$2$" the exponent on the absolute value.].


#definition("Function Space " + $L^(2)(0,1)$)[ The function space over the domain $I = (0,1) subset RR$ of *square-integrable functions* is defined as

$
L^(2)(0,1) := {f : (0,1) -> CC: integral_(0)^(1) abs(f)^(2) d x < infinity  }.
$
]

#slidebreak()

The $L^(2)(0,1)$ space as defined above is a *vector space*. Moreover, it is an *inner product space* w.r.t. the following definition of an $L^(2)$-inner product.#sidenote[Its definition is analogous to the inner product $ip(dot, dot): CC^(n) times CC^(n) -> CC$ on $CC^(n)$, where $ip(bold(x),bold(y)) = bold(x)^(H)bold(y)$ conjugates the first argument.]

$
ip(g, f)_(L^(2)(0,1)) := integral_(0)^(1) conj(g(x))f(x) d x,
$

where $conj(g(x))$ is the complex conjugate of $g(x)$. The inner product induces the $L^(2)$-norm#sidenote[On the square-integrable functions this is strictly only a *seminorm*, since $norm(f)_(L^(2)) = 0$ merely forces $f = 0$ _almost everywhere_.]

$
norm(f)_(L^(2)(0,1)) := sqrt(ip(f, f)_(L^(2)(0,1))).
$

#slidebreak()

=== Convergence in $L^(2)$

In a normed space, we are particularly interested in understanding limiting behaviour. With the norm defined above, we say a sequence of approximations $(p_(N))_(N in NN)$ converges to some $f$ in $L^(2)(0,1)$ if

$
norm(p_(N) - f)_(L^(2)(0,1)) -> 0 quad "as" N -> infinity.
$

Writing out the norm, this means the total squared error vanishes,

$
norm(p_(N) - f)_(L^(2)(0,1)) = sqrt(integral_(0)^(1) abs(p_(N)(x) - f(x))^(2) d x) -> 0.
$

#slidebreak()

Convergence in $L^(2)$ does not require the error to be small at every point. Intuitively, it only requires the total squared error to vanish, so large errors may remain on small sets, as shown below,

#figure-img(
  "content/ch3/gibbs_phenomenon_square_wave.png",
  "Partial Fourier sums (green) of a box function (blue) for n = 10 and n = 70 (Gibbs phenomenon).",
  width: 90%,
)[
  Comparison of the partial Fourier sums $s_(N)$ (green) approximating the box function $f$ (blue). \
 Note that there is overshoot particularly near the jump points, this is the *Gibbs phenomenon*.
]

#slidebreak()

=== Orthonormal Fourier Basis, Fourier Series and Coefficients

The functions $phi_(k)(t) = exp(2 pi i k t)$, $k in ZZ$, form a *complete orthonormal basis* of the $L^(2)$-space. Orthonormality can be checked directly by computing the inner product for indices $k, j in ZZ$,

$
ip(phi_(k), phi_(j))_(L^(2)(0,1)) = cases(
1 quad k = j,
0 quad k != j
)
$

#proof(title: "Proof of the Orthonormality")[
By definition, the inner product conjugates its first argument. Since $phi_(k)(t) = exp(2 pi i k t)$, we have $conj(phi_(k)(t)) = exp(-2 pi i k t)$, so for indices $k, j in ZZ$,

$
ip(phi_(k), phi_(j))_(L^(2)(0,1))
&= integral_(0)^(1) conj(phi_(k)(t)) phi_(j)(t) d t \
&= integral_(0)^(1) e^(-2 pi i k t) e^(2 pi i j t) d t \
&= integral_(0)^(1) e^(2 pi i (j - k) t) d t = delta_(k j) = cases(
1 quad &"if" k = j,
0 quad &"if" k != j.
)
$
]

#slidebreak()

The choice of this basis leads to very desirable properties of convergence when approximating a function $f in L^(2)(0,1)$ with its Fourier series,

#theorem("Fourier series representation of " + $L^(2)$ +"-functions (Gradinaru, p.66, 3.1.9)")[ Let $f in L^(2)(0,1)$, then $f$ equals the $L^(2)$-limit of its *Fourier series*,

$
f(t)
&= sum^(infinity)_(k = - infinity) hat(f)(k) phi_(k)(t)  \
&= sum^(infinity)_(k = - infinity) hat(f)(k) exp(2 pi i k t),
$

with the *Fourier coefficients*

$
hat(f)(k) = ip(phi_(k), f)_(L^(2)(0,1)) = integral^(1)_(0) f(t) e^(-2 pi i k t) d t, quad k in ZZ.
$

These are the coordinates of $f$ along $phi_(k)$.

]

#slidebreak()

==== Bridging Time- and Frequency Domain with Parseval's Identity

The *Parseval's identity* states that expressing $f$ in the basis ${phi_(k)}_(k in ZZ)$ preserves its norm in respective function spaces.

#boxeq[
$
sum^(infinity)_(k = - infinity) abs(hat(f)(k))^(2) = norm(f)^(2)_(L^(2)(0,1))
$

]

#slidebreak()

Intuitively, the identity lets us use two equivalent representations of the same function $f$. We can describe $f$ either in the *time domain*,

$
t mapsto f(t)
$

The alternative *frequency domain* definition is described by its Fourier coefficients. Such coefficients determine the contributions of a fixed oscillation mode, represented by the basis $phi_(k)(t) = exp(2 pi i k x)$ of our choice,

$
k mapsto hat(f)(k), quad k in ZZ
$

#figure-img(

"content/ch3/time_vs_frequency_domain.png",

"Representation in Time-domain (Left) and Frequency-domain (Right).",

width: 78%,

)[

The same functions viewed as $t mapsto f(t)$ and as $k mapsto hat(f)(k)$.#linebreak() Smooth periodic functions have rapidly decaying Fourier coefficients.

]


#slidebreak()

=== Trigonometric Polynomial

🚧 Under construction.