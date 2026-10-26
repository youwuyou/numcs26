#import "../_site.typ": section, boxeq, defbox, theorem, proof, warning, notation, example, thought, sidenote, divider, anchor, anchor-ref, cred, cteal, cviolet

#let meta = (id: "grundbegriffe-und-ideen", title: "5.3 Grundbegriffe und -ideen")

#show: section.with(meta)

== #meta.title


Let us consider the one-dimensional case with $d = 1$, where we denote 1D domain as $Omega := [a,b] subset RR$. Our goal is to approximate the value of an integral in the form

$
I := integral_(a)^(b) f(x) d x
$

by a simpler, computable formula $Q_(n)$ that we referred to as a $n$-point quadrature rule, where $n in NN$ highlights the number of point values used in such an approximation. We write $I = integral^(b)_(a) f(x) d x approx Q_(n)(f; a, b)$. 


==== Quadrature #sidenote[Gradinaru, p. 130, 5.3.1.]

The quadrature formula is defined through a *weighted sum* of point values of the integrand

#anchor("eq-quadrature-general")[#boxeq[
$
Q_(n)(f; a, b) := sum^(n)_(i = 1) omega^(n)_(i) f(c_(i)^(n))
$
]]

We call $omega^(n)_(i)$ the *quadrature weights*, and $c_(i)^(n) in [a, b]$ the *quadrature nodes*.

The error of a quadrature formula#sidenote[Gradinaru, 5.3.2] is measured using the absolute value

$
E(n) = abs(integral^(b)_(a) f(x) d x - Q_(n)(f; a, b))
$

Note that for a fixed quadrature formula, in order to minimize the errors, we should choose weights and nodes appropriately.


#example("Composite quadrature rule as applying a quadrature rule to subintervals.")[

The idea of the composite quadrature is analogous to the piecewise approach we have investigated in previous chapters, where we partition the domain $I$ by $a := x_(0) < x_(1) < dots < x_(N-1) := b$, and accumulate the total area contributed by each subinterval.

$
integral^(b)_(a) f (x) d x 
&= sum^(N-1)_(k = 0) underbrace(integral^(x_(k+1))_(x_(k)) f(x) d x, approx Q_(n)(f; x_(k), x_(k+1)) ) approx sum^(N-1)_(k = 0) Q_(n)(f; x_(k), x_(k+1))
$

For a composite quadrature rule, the error is the accumulated error of a quadrature formula over all subintervals


$
E_(Sigma)(n) 
&= sum^(N-1)_(k = 0) E(n) \
&= sum^(N-1)_(k = 0) abs(  integral^(x_(k+1))_(x_(k)) f(x) d x - Q(f; x_(k), x_(k+1))  )
$

here we used our own notation of $E_(Sigma)$ to distinguish between the error of a composite rule and the error $E(n)$ defined above.
]


=== From Polynomial Interpolation to Quadrature Rules #sidenote[Gradinaru, Remark 5.3.7]

The #anchor-ref("eq-quadrature-general")[quadrature formula] above is presented in an abstract setup. We will now provide concrete examples of such rules by establishing their relations with *polynomial interpolation*.#sidenote[The overall idea is to replace the integrand $f$ under the smooth integral by a polynomial $p_(n)$ of degree $n$, and ideally, the integral of $p_(n)$ over the domain should have a closed-form expression that we can directly evaluate.]

To illustrate it, we consider the *Lagrange interpolation formula*, recall on given data points $(x_(i), y_(i))$, the $p_(n)$ is a weighted sum of the Lagrange polynomial $l_(i)$ that depends on the choice of interpolation nodes $x_(i)$.

#anchor("eq-lagrange-interpolation")[
$
p_(n)(x) = sum^(n)_(i = 0) y_(i) l_(i)(x)
$
]

Let us replace the integrand $f$ by $p_(n)$ then


$
integral^(b)_(a) f(x) d x 
&approx integral^(b)_(a) p_(n)(x) d x\
&= integral^(b)_(a) sum^(n)_(i = 0) y_(i) l_(i)(x) d x \
&= sum^(n)_(i = 0)   y_(i) integral^(b)_(a) l_(i)(x) d x \
&= sum^(n)_(i = 0) y_(i) w_(i)
$

where the weights $w_(i) = integral^(b)_(a) l_(i)(x) d x$ depend only on the nodes, not on $f$. This corresponds to #anchor-ref("eq-quadrature-general")[quadrature formula] with $omega_(i)^(n) = w_(i)$ at nodes $c_(i)^(n) = x_(i)$ as follows

#anchor("eq-interpolatory-quadrature")[#boxeq[
$
Q_(n)(f; a, b) = sum^(n)_(i = 0) w_(i) f(x_(i)), quad w_(i) = integral^(b)_(a) l_(i)(x) d x.
$
]]



#example("Problems with interpolating in the monomial basis.")[

Before proceeding to next sections, let us examine another example to approximate the integrand $f approx p_(n)$ in the monomial basis,

$
p_(n)(x) = sum^(n)_(i = 0) alpha_(i) b_(i)(x), quad b_(i)(x) = x^(i).
$

Integrating term by term, the same swap of summation and integration as before turns the integral into a finite sum, where each elementary basis integral is evaluated in the last two steps,

$
integral^(b)_(a) f(x) d x
&= integral^(b)_(a) p_(n)(x) d x \
&= integral^(b)_(a) (sum^(n)_(i = 0) alpha_(i) b_(i)(x)) d x \
&= sum^(n)_(i = 0) alpha_(i) integral^(b)_(a) x^(i) d x \
&= sum^(n)_(i = 0) alpha_(i) [x^(i + 1) / (i + 1)]^(b)_(a) \
&= sum^(n)_(i = 0) alpha_(i) (b^(i + 1) - a^(i + 1)) / (i + 1)
$


It is worth mentioning that this is not yet in the general quadrature form. The weights here are $omega_(i) = integral^(b)_(a) x^(i) d x$, but the point values $y_(i) = f(c_(i))$ are  related to the coefficients $alpha_(i)$ that we yet need to resolve.

In particular $bold(alpha) = bold(V)^(-1) bold(y)$ involves a Vandermonde matrix $V$, and is numerically unstable as we learnt previously.
]

==== Order of a Quadrature Formula

The above viewpoint that relates numerical quadrature to polynomial interpolation naturally gives rise to the notion of the *order of a quadrature formula*.#sidenote[In the definition below, the degree is also meant in a "tight" sense, meaning that a rule of order $n+1$ strictly means that there exists polynomials of degree $n+1$ that it fails to integrate.]

#defbox("Order of a quadrature formula (Gradinaru, 5.3.8)")[
A quadrature formula has *order $n + 1$* if it  integrates every polynomial of degree at most $n$ exactly.
]

Note that polynomials of degree at most $n$ form the space $cal(P)_(n)$ of dimension $n + 1$. A quadrature formula of order $n + 1$ thus highlights that it integrates an $(n + 1)$-dimensional space of polynomials exactly by convention.