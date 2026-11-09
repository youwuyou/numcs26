#import "../_site.typ": section, boxeq, proof, figure-img
#import "_ch6.typ": xv, xit, scalar

#let meta = (id: "newton-verfahren-in-1-dimension", title: "6.5 Newton-Verfahren in 1 Dimension")

#show: section.with(meta)

== #meta.title

In this section, we examine a simple 1D example to see how Newton's method works, we will generalize it to higher dimension in the later section.

#boxeq(title: [Newton's method in 1D], muted: true)[
$
scalar(xit(k+1) := xit(k) - frac(F(xit(k)), F'(xit(k))))
$
]


#proof(title: [Deriving the formula using the root-finding of the tangent line])[

At each iteration step $k$, we approximate the underlying (nonlinear) function $F$ by its linear approximation, denoted as $tilde(F)^((k))$, 

$
scalar(tilde(F)^((k))(upright(x)) := F(xit(k)) + F'(xit(k))(upright(x) - xit(k)))
$

Denote the root of $tilde(F)$ as $upright(x)^(star)$ such that $tilde(F)(upright(x)^(star)) = 0$ fulfills

#scalar[$
          & F(xit(k)) + F'(xit(k))(upright(x)^(star) - xit(k)) = 0 \
  <==>quad & F'(xit(k))(upright(x)^(star) - xit(k)) = -F(xit(k)) \
  <==>quad & upright(x)^(star) = xit(k) - frac(F(xit(k)), F'(xit(k)))
$]

Thus, we see the Newton's update is effectively using the root of the linear approximant as the next iterate.
]

In fact, as shown in the derivation of the formula we see the iterates are given by roots of the linear approximants $tilde(F)^((k))$ for the current iteration $k$, whose root is easier to compute. This can be easily illustrated in 1D as follows.

#figure-img(
  "content/ch6/Newton_iteration.svg",
  "Geometric construction of a Newton iteration step in one dimension",
  width: 55%,
  credit: [Image Source: #link("https://commons.wikimedia.org/wiki/File:Newton_iteration.svg")[Wikimedia Commons, "Newton iteration"].],
)[
 Illustration of one Newton's iteration advancing $upright(x)_(n)$ to $upright(x)_(n+1)$.
]

=== Sekantenverfahren

The underlying idea of the secant's method is to avoid computing the derivative for constructing the approximant. In fact, we can start with two initial values $scalar(xit(0)), scalar(xit(1))$ and construct the secant line through the corresponding data points on $F$ and repeat this process. This gives the following recurrence formula.



#boxeq(title: [Secant Method - Damped Newton's method in 1D], muted: true)[
#scalar[$
xit(k+1) &:= xit(k) - frac(F(xit(k)), q^((k)))\
q^((k))  &= frac(F(xit(k)) - F(xit(k-1)), xit(k) - xit(k-1))
$]
]

Here the tangent slope $F'(xit(k))$ of Newton's method is replaced by the slope $q^((k))$ of the secant line.

#proof(title: [Deriving the formula using the root-finding of the secant line])[

Instead of the tangent, we now approximate $F$ by the secant line $tilde(F)^((k))$ through the two most recent iterates,

#scalar[$
tilde(F)^((k))(upright(x)) &:= F(xit(k)) + q^((k))(upright(x) - xit(k))\
q^((k)) &= frac(F(xit(k)) - F(xit(k-1)), xit(k) - xit(k-1))
$]

where $q^((k))$ is the slope of the secant. Denote the root of $tilde(F)^((k))$ as $upright(x)^(star)$ such that $tilde(F)^((k))(upright(x)^(star)) = 0$ fulfills

#scalar[$
          & F(xit(k)) + q^((k))(upright(x)^(star) - xit(k)) = 0 \
  <==>quad & q^((k))(upright(x)^(star) - xit(k)) = -F(xit(k)) \
  <==>quad & upright(x)^(star) = xit(k) - frac(F(xit(k)), q^((k)))
$]

Similarly, the root of the secant line is taken as the next iterate $scalar(xit(k+1))$. This recovers the recurrence above.
]

#figure-img(
  "content/ch6/secant.svg",
  "Geometric construction of one secant step in one dimension",
  width: 55%,
  credit: [Source: #link("https://personal.math.ubc.ca/~CLP/CLP1/clp_1_dc/clp_1_dc.html")[CLP-1 Differential Calculus], #link("https://personal.math.ubc.ca/~CLP/CLP1/clp_1_dc/app_root_finding.html")[§C.4].],
)[
 Illustration of one secant step using information from $upright(x)_(n-1)$ and $upright(x)_(n)$ to find the next iterate $upright(x)_(n+1)$.
]