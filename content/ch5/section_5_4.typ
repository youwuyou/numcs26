#import "../_site.typ": section, thought, divider, example, boxeq, proof, ip, figure-img, sidenote, anchor-ref, theorem

#let meta = (id: "aequidistante-stuetzstellen", title: "5.4 Äquidistante Stützstellen")

#show: section.with(meta)

== #meta.title

In the following, we consider a family of quadrature formulas called the *Newton-Cotes formulas*. In fact, these formulas are obtained by integrating a #anchor-ref("eq-lagrange-interpolation")[Lagrange interpolating polynomial] through equally spaced sampling points.

=== Newton-Cotes Formulas


Recall that the #anchor-ref("eq-interpolatory-quadrature")[quadrature formula based on Lagrange interpolation] is given as,


#boxeq[
$
Q_(n)(f; a, b) = sum^(n)_(i = 0) w_(i) f(x_(i)), quad w_(i) = integral^(b)_(a) l_(i)(x) d x.
$
]

For a fixed $n in NN_(0)$, choose $n + 1$ equidistant nodes $x_(0), dots, x_(n)$. Since the quadrature rule integrates the Lagrange interpolant exactly, it is exact for every polynomial of degree at most $n$. Thus its order is *at least* $n + 1$.


In the following, we can see an illustration on an example interval, where we show $Q_(1), Q_(2), Q_(3)$, with the equidistant nodes $x_(j)$ chosen.

#figure-img(
  "content/ch5/three_shapes.svg",
  "The three classical Newton-Cotes rules: midpoint, trapezoidal, and Simpson's rule.",
  width: 90%,
  credit: [Source: #link("https://personal.math.ubc.ca/~CLP/CLP2/clp_2_ic/sec_numeric_int.html")[CLP-2 Integral Calculus], #link("https://personal.math.ubc.ca/~CLP/CLP2/clp_2_ic/clp_2_ic-2.html")[§1.11].],
)[
  $n = 1, 2, 3$: the midpoint, trapezoidal, and Simpson's rule.
]

=== Deriving Midpoint, Trapezoidal and Simpson's Rule from Lagrange Interpolation Formula

Note that since this family of quadrature rules have weights given by the Lagrange basis polynomial, we only need to compute weights $w_(i)$ with different number of nodes $n = 1, 2, 3$.


In the following, we denote the width of the interval $h := b -a$. We compute $l_(i)$ and then integrate over $[a,b]$ to arrive at $Q_(i)(f; a,b)$ by

$
w_(i) = integral^(b)_(a) l_(i)(x) d x
$

- Midpoint Rule

#boxeq[
$
Q_(1)(f; a, b) = (b - a) f(frac(a + b, 2))
$
]

- Trapezoidal Rule


#boxeq[

$
Q_(2)(f; a, b) = frac(b - a, 2) ( f(a) +  f(b))
$

]

- Simpson's Rule

#boxeq[
$
Q_(3)(f; a, b) = frac( b - a, 6) (f(a) + 4 f(frac(a+b, 2)) + f(b))
$
]


#example("Deriving Midpoint rule (order 2).")[

For $n = 1$, the node $x_(0) = frac((a+b), 2)$ is chosen as the midpoint of the interval $I = [a,b]$, and the cardinal basis is

$
l_(0)(x) = 1
$

Integrate by the formula gives rise to the weight $omega_(0)$,

$
omega_(0) = integral^(b)_(a) 1 d x = h
$

Thus, the quadrature formula is

$
Q_(1)(f; a,b) = h f(x_(0)) = h f(frac(a + b, 2))
$

]

#example("Deriving Trapezoidal rule (order 2).")[

For $n = 2$, the nodes $x_(0) = a$, $x_(1) = b$ are chosen as the endpoints of the interval $I = [a,b]$, and the cardinal basis is

$
l_(0)(x) = (x - x_(1)) / (x_(0) - x_(1)), quad l_(1)(x) = (x - x_(0)) / (x_(1) - x_(0))
$

Integrate by the formula gives rise to the weights $omega_(0), omega_(1)$,

$
omega_(0) &= integral^(b)_(a) l_(0)(x) d x = h / 2, quad\
omega_(1) &= integral^(b)_(a) l_(1)(x) d x = h / 2
$

Thus, the quadrature formula is

$
Q_(2)(f; a,b) = h / 2 (f(x_(0)) + f(x_(1))) = h / 2 (f(a) + f(b))
$

]

#example("Deriving Simpson's rule (order 4).")[

For $n = 3$, the nodes $x_(0) = a$, $x_(1) = (a + b) \/ 2$, $x_(2) = b$ are chosen equidistantly on the interval $I = [a,b]$, and the cardinal basis is

$
l_(0)(x) &= ((x - x_(1))(x - x_(2))) / ((x_(0) - x_(1))(x_(0) - x_(2))), \
l_(1)(x) &= ((x - x_(0))(x - x_(2))) / ((x_(1) - x_(0))(x_(1) - x_(2))), \
l_(2)(x) &= ((x - x_(0))(x - x_(1))) / ((x_(2) - x_(0))(x_(2) - x_(1)))
$

Integrate by the formula gives rise to the weights $omega_(0), omega_(1), omega_(2)$,

$
omega_(0) &= integral^(b)_(a) l_(0)(x) d x = h / 6, \
omega_(1) &= integral^(b)_(a) l_(1)(x) d x = (2 h) / 3, \
omega_(2) &= integral^(b)_(a) l_(2)(x) d x = h / 6
$

Thus, the quadrature formula is

$
Q_(3)(f; a,b) 
&= h / 6 (f(x_(0)) + 4 f(x_(1)) + f(x_(2)))\
&= h / 6 (f(a) + 4 f(frac(a + b, 2)) + f(b))
$

]


==== Orders of the Newton-Cotes Rules

As one might wonder, the midpoint rule above uses a degree $0$ Lagrange polynomial $p_(0)$ to approximate the integrand, why would we prescribe it to have an order $2$.

To understand this, one should note that the degree is incremented by $1$ as a result of leveraging symmetry. For linear polynomials, i.e. geometrically as a line segment connecting the endpoints $a, b$; its area under the curve is exactly the same as the area of the rectangle with its height defined by $f(frac(a + b, 2))$ at the midpoint.

In fact, such symmetric properties in remarked in the script 5.3.9 to refer to such quadrature formulas as *symmetric*, if the quadrature nodes and weights are both symmetric, with respect to their definitions in a reference interval $hat(I) := [-1, 1]$.

We may check the conditions

$
omega_(i) = omega_(n + 1 - i), quad c_(i) = - c_(n+1 - i)
$

Lastly, it is important to keep an important consequence in mind.#sidenote([Gradinaru, p. 136, theorem 5.3.11.])

#theorem("Symmetry of a quadrature formula.")[The order of a symmetric quadrature formula is always an even number.
]


#divider()