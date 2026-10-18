#import "../_site.typ": section, boxeq, defbox, notation, example, thought, sidenote, divider, anchor, anchor-ref, cred, cteal, cviolet
#import "section_4_1_figures.typ": fig-change-of-variable

#let meta = (id: "stueckweise-lineare-interpolation", title: "4.1 Stückweise lineare Interpolation")

#show: section.with(meta)

== #meta.title

In the following, we examine the simplest piecewise interpolation scheme, i.e. *piecewise linear interpolation*. This gives us an interpolant $hat(f): I := [a,b] -> RR$ that is #underline[continuous, but not differentiable] on $I$. More compactly, we denote such functions to be $hat(f) in C^(0)([a,b])$.

#notation("Differentiability classes")[
On an interval $I = [a,b] subset.eq RR$, we write#sidenote[See #link("https://en.wikipedia.org/wiki/Smoothness#Differentiability_classes")[Smoothness — differentiability classes] on Wikipedia.]
- $C^(0)(I) eq.delta$ space of _continuous_ functions $I -> RR$
- $C^(d)(I) eq.delta$ space of $d$-times _continuously differentiable_ functions $I -> RR$
]

Intuitively, piecewise linear interpolation is simply a game of "connect-the-dots".#sidenote[We borrow this nice analogy from the textbook #link("https://fncbook.com/python/pwlin/")["Fundamentals of Numerical Computation" by Tobin A. Driscoll and Richard J. Braun.]] We will see it is closely related to the Lagrange polynomial of degree $cred(n = 1)$, performed on each subintervals.


#anchor("eq-lagrange-deg1")[#boxeq[
$
p_(cred(1))(t) = sum^(cred(1))_(i = 0) y_(i) l_(i)(t) = y_(0)l_(0)(t) + y_(1)l_(1)(t)
$
]]


The Lagrange basis polynomials $l_(0), l_(1)$ are given by the product formula

#anchor("eq-lagrange-basis")[
$
l_(i)(t) = product^(cred(bold(1)))_(j = 0, j != i) frac(t - t_(j), t_(i) - t_(j))
$
]

and it is important to keep in mind that they depend on the choice of nodes $t_(0), t_(1)$.


=== Degree-$1$ Lagrange Polynomial on $[0, 1]$

Let us first concretize the above formulas on a reference subinterval $hat(I) := [t_(0), t_(1)] = [0, 1]$ that is easy to compute. Plugging the nodes $t_(0) = 0$ and $t_(1) = 1$
into the #anchor-ref("eq-lagrange-basis")[basis formula] gives

$
l_(0)(t) &= frac(t - t_(1), t_(0) - t_(1)) = frac(t - 1, 0 - 1) = 1 - t\
l_(1)(t) &= frac(t - t_(0), t_(1) - t_(0)) = frac(t - 0, 1 - 0) = t
$

Substituting them into #anchor-ref("eq-lagrange-deg1")[degree-$1$ Lagrange interpolation formula] leads to the
following formula

#boxeq[
$
p_(cred(1))(t) &= y_(0)l_(0)(t) + y_(1) l_(1)(t)  \
<=> hat(s)(t) := p_(cred(1))(t) &= y_(0)(1 - t) + y_(1)t
$  
]

In particular, we write $hat(s) := p_(1)$ to highlight the interpolant is defined on the reference interval $hat(I)$. Note that
$y_(0), y_(1)$ are just placeholders for function values on endpoints of this subinterval.

=== Mapping to a Generic Interval $[x_(j-1), x_(j)]$

Let $a =: x_(0) < x_(1) < dots < x_(N) := b$ be a partition of the entire interval $I := [a,b]$ into subintervals. Now, let us examine
an *arbitrary* subinterval $I_(j) := [x_(j-1), x_(j)]$ and denote its length by $h_(j) := x_(j) - x_(j-1)$.

==== Change of Variables

To transfer the reference interpolant to $I_(j)$, we perform a *change of variables* between the reference coordinate $cteal(t in [0,1])$ and the transformed coordinate $cviolet(x  in I_(j) = [x_(j-1), x_(j)] )$.


$
chi: cteal(hat(I)) &-> cviolet(I_(j))\
cteal(t) &mapsto cviolet(x_(j-1) + h_(j) t := x)
$


Under such a transformation, the degrees of polynomials remain unchanged. In fact, we could visualize
the change of variable as follows

#fig-change-of-variable

#example("Use change of variables to transform interpolant onto "+ $I_(j)$)[

To apply the change of variables as defined above in order to obtain a transformed interpolant on $I_(j)$.
Let the concrete function values at the endpoints be $y_(j-1), y_(j)$, then

$
s_(j)(x) = hat(s)(cteal(t))
&= y_(j-1)(1 - cteal(t)) + y_(j) cteal(t) \
&= y_(j-1)(1 - cviolet(frac(x - x_(j-1), h_(j)))) + y_(j) cviolet(frac(x - x_(j-1), h_(j))) \
&= y_(j-1) frac(h_(j) - (x - x_(j-1)), h_(j)) + y_(j) frac(x - x_(j-1), h_(j)) \
&= y_(j-1) frac(x_(j) - x, h_(j)) + y_(j) frac(x - x_(j-1), h_(j))
$
]

To summarize, we started from a simpler expression $hat(s): hat(I) := [0,1] -> RR$ defined 
for a reference interval, and generalize it to a more generic subinterval $I = [x_(j-1), x_(j)]$
as $s: I_(j) -> RR$, by using the change of variables.

#anchor("eq-local-interpolant")[#boxeq[
$
s_(j)(x) = y_(j-1) frac(x_(j) - x, h_(j)) + y_(j) frac(x - x_(j-1), h_(j)), quad x in [x_(j-1), x_(j)] .
$
]]
