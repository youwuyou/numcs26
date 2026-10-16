#import "../_site.typ": section, defbox, example, mat, vec, matlines, ip, python, cblue, cred, cteal, sidenote, slidebreak, thought, divider, figure-img, boxeq, stage

#let meta = (id: "newton-basis-und-dividierte-differenzen", title: "2.2 Newton-Basis und dividierte Differenzen")

#show: section.with(meta)

== #meta.title

The Newton interpolation polynomial is a linear combination of Newton basis polynomials

#boxeq[
$
p_(n)(x) = sum^(n)_(j =  0) beta_(j) N_(j)(x)
$

]

with Newton basis polynomials $N_(0), dots, N_(n)$ defined on distinct nodes $\{x_(0), dots, x_(n)\} subset RR$ as

$
N_(n)(x) = product^(n-1)_(i = 0) (x - x_(i))
$

#example("Newton’s basis as a cumulative product that 'keeps the memory'.")[

The Newton’s basis is given as follows,

$ N_0 (x) & := 1\
N_1 (x) & := x - x_0\
N_2 (x) & := (x - x_0) (x - x_1)\
dots.v\
N_n (x) & := product_(i = 0)^(n - 1) (x - x_i)\
$

Note that we should interpret a Newton's basis as a cumulative product that "keeps the memory" of all previous data points $forall j = 0, 1, dots, i-1$. Moreover, all previous basis functions $N_0, dots, N_(n-1)$ remain unchanged when we need to compute $N_(n)$ for a new data point $(x_(n),y_(n))$.
]


#example("LSE with a lower triangular matrix in Newton's basis.")[

The Newton's polynomial of degree $n$ fulfills the interpolation conditions at $(n + 1)$ distinct data points $(x_i , y_i), forall i = 0, 1, dots, n$,

$ 
p_n (x_i) = sum_(j = 0)^(n) beta_j N_j (x_i) =^(!) y_i quad upright("for ") i = 0 , dots.h , n 
$

This gives rise to the following linear system of equations:

$ cases(delim: "{", beta_0 N_0 (x_0) & = y_0, beta_0 N_0 (x_1) + beta_1 N_1 (x_1) & = y_1, beta_0 N_0 (x_2) + beta_1 N_1 (x_2) + beta_2 N_2 (x_2) & = y_2, dots.v, beta_0 N_0 (x_n) + beta_1 N_1 (x_n) + dots.h + beta_n N_n (x_n) & = y_n) $

Plugging in expressions of Newton basis functions $N_j (x_i)$, we get

$ cases(delim: "{", beta_0 & = y_0, beta_0 + beta_1 (x_1 - x_0) & = y_1, beta_0 + beta_1 (x_2 - x_0) + beta_2 (x_2 - x_0) (x_2 - x_1) & = y_2, dots.v, beta_0 + beta_1 (x_n - x_0) + dots.h + beta_n product_(i = 0)^(n - 1) (x_n - x_i) & = y_n) $

In matrix-vector form, we see the above system consists of a lower triangular system matrix,

$ mat(1, 0, 0, dots.h, 0; 1, x_1 - x_0, 0, dots.h, 0; 1, x_2 - x_0, (x_2 - x_0) (x_2 - x_1), dots.h, 0; dots.v, dots.v, dots.v, dots.down, dots.v; 1, x_n - x_0, (x_n - x_0) (x_n - x_1), dots.h, product_(i = 0)^(n - 1) (x_n - x_i)) vec(beta_0, beta_1, beta_2, dots.v, beta_n) = vec(y_0, y_1, y_2, dots.v, y_n) $

]



The interpolant $p_(n)$ using Newton's basis can be constructed iteratively from $p_(n-1)$ as follows,

$ 
p_(n) (x) = p_(n-1) (x) + beta_n N_n (x) 
$

here it is helpful to see $beta_(n)N_(n)(x)$ as the "correction" term to ensure the interpolation condition is fulfilled for the newly appended data points. We illustrate it in the following animation.


#figure-img(
  "content/ch2/newton_interpolation.gif",
  "Animation building the Newton interpolant one data point at a time",
  width: 95%,
  paged-src: "content/ch2/newton_interpolation.pdf",
  credit: [Image Source: © 2026 - WU, You],
)[
  Iterative construction of a Newton's polynomial of degree $n = 3$.
]

- [TODO]: construction: divided difference


#stage[Evaluation]
- [TODO]: evaluation: horner's scheme for newton, error in relation with differentiability


#divider()
