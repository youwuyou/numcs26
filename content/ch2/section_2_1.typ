#import "../_site.typ": section, defbox, example, mat, vec, matlines, ip, python, cblue, cred, cteal, sidenote, slidebreak, thought, divider, figure-img, boxeq, anchor, anchor-ref, stage, warning

#let meta = (id: "interpolation-und-polynome", title: "2.1 Interpolation und Polynome")

#show: section.with(meta)

== #meta.title

Given distinct datapoints $(x_(i), y_(i)), i = 0, dots, n$ of an unknown function $f : RR -> RR$, where

$
y_(i) = f(x_(i)), quad i = 0, dots, n
$

We want to reconstruct $f$ by a simpler function $tilde(f)$ that has a closed-form expression. We call such a function $tilde(f)$ an *interpolant*. It should go through the sampled data points exactly, i.e. fulfilling the #underline[interpolation conditions],

#anchor("eq-algebraic-condition")[$
y_(i) = tilde(f)(x_(i)), quad i = 0, dots, n
$]

In the following sections, we distinguish between two stages in the interpolation process to *construct*#sidenote[For a given basis, we want to determine the unknown coefficients by solving a LSE.] or *evaluate*#sidenote[If all coefficients are known to us, the polynomial expression can be evaluated for all $x in KK$.] the interpolant at a given point $x$.


=== Space of Polynomials in Monomial Basis

#defbox("Space of polynomial (Monomial Basis).")[
The space of polynomials of degree $n in NN$ is given in monomial basis $\{1, x, dots, x^(n) \}$ as,

$
cal(P)_(n) := {x mapsto a_(n) x^(n) + a_(n-1) x^(n-1) + dots + a_(1) x + a_(0)}
$

where the coefficients $a_(i)$ belong to a field $KK$.#sidenote[We usually consider the field to be the set
of real numbers $KK := RR$, or the set of complex numbers $KK := CC$.]
]

// - [TODO]: Mention smoothness: $cal(P)_(n) subset C^infinity(RR)$ and relate this to the spaces $C^0, C^1, C^infinity$.
// - [TODO]: Compare $f$ in an infinite-dimensional function space with $p_n in cal(P)_(n)$ finite-dimensional.

It is important to note that $cal(P)_(n)$ is a linear vector space with dimension $dim cal(P)_(n) = n + 1$. In particular, any polynomial $p_(n) in cal(P)_(n)$ of degree at most $n$ can be expressed as a linear combination in a suitable basis as follows,

#boxeq[
$
p_(n)(x) = sum^(n-1)_(j =  0) alpha_(j) b_(j)(x)
$
]

Here, we consider each $b_(j)$ to be a monomial basis,

$
b_(j)(x) = x^(j), forall j = 0, 1, dots, n
$

Note that we start the indexing here from $j = 0$. If $j$ starts with $1$, we shall write $b_(j)(x) = x^(j-1)$.#sidenote[This indexing is used in Gradinaru, p.42, Beispiel 2.1.3. But we resort to start indexing from $0$ throughout to stay consistent with the indexing used in all summations.]

#example("LSE with a Vandermonde matrix in monomial basis.")[

The polynomial of degree $n$ in the *monomial basis* is given as:

$
p_(n)(x) := a_(0) + a_(1) x^(1) + dots + a_(n) x^(n)
$

If we assume the interpolant $tilde(f) = p_(n)$ to be of this form, then #anchor-ref("eq-algebraic-condition")[the interpolation condition] becomes

$
p_(n)(x_(i)) &= y_(i), quad i = 0, dots, n \
<=> a_(0) + a_(1) x^(1)_(i) + dots + a_(n) x_(i)^(n) &= y_(i), quad i = 0, dots, n \
$

#slidebreak()

Explicitly written out these $(n + 1)$-equations involving the coefficients $a_(i)$ as *unknowns*,

$
cases(
  a_(0) + a_(1) x_(0) + dots + a_(n) x_(0)^n &= y_(0),
  a_(0) + a_(1) x_(1) + dots + a_(n) x_(1)^n &= y_(1),
  &dots.v,
  a_(0) + a_(1) x_(n) + dots + a_(n) x_(n)^n &= y_(n)
)
$

Thus the coefficients are obtained from the linear system

$
mat(
  1, x_(0), dots, x_(0)^n;
  1, x_(1), dots, x_(1)^n;
  dots.v, dots.v, dots.down, dots.v;
  1, x_(n), dots, x_(n)^n
)
vec(a_(0), a_(1), dots.v, a_(n))
=
vec(y_(0), y_(1), dots.v, y_(n)).
$

The system matrix is called a *Vandermonde matrix*.
]

#slidebreak()



#stage[Evaluation]

As soon as the coefficients $a_(0), dots, a_(n)$ are known to us, we can compute the function values $tilde(f)(x)$
for all $x in RR$ the polynomial function by directly evaluating the closed-form formula at $x$.


$
tilde(f)(x) = p_(n)(x) = sum^(n-1)_(j = 0) alpha_(j) b_(j)(x)
$

It is important to note that, a direct evaluation of the above formula is *not efficient*.

#warning("Naive evaluation leads to " +$O(n^(2))$ + " time complexity.")[

The most naive implementation recomputes every power $x^(n)$ from scratch without reusing previously computed powers $x^(n-1)$. This would require:
- No. multiplications: $1 + 2 + dots + n = frac(n (n + 1), 2)$
- No. additions: $n$

Overall, the work grows quadratically in $O(n^2)$.
]

#example("Improving complexity by reusing computed powers.")[
As hinted above, a significant improvement could be made by keeping the previously computed powers $x^(n-1)$ in memory, and reuse it to raise to a higher power by one additional multiplication $x^(n) = x^(n-1) dot x$. This already brings the cost down to $O(n)$ that requires:
- No. multiplications: $(n - 1) + n = 2n - 1$,
- No. additions: $n$.
]


The *Horner scheme* improves upon the idea to reuse already computed powers, and in addition leverage the distributivity with respect to the variable $x$ to rewrite $p_(n)$ in a nested fashion as follows,

#boxeq[

$
p(x) = a_(0) + x (a_(1) + x (a_(2) + dots + x (a_(n - 1) + x a_(n)) dots))
$

]

This scheme is also of $O(n)$ but requires the smallest elementary arithmetic operation count with only no. $n$ multiplications and no. $n$ additions.

#example("Efficient evaluation of a degree-4 polynomial in monomial basis with Horner scheme.")[

To see how to arrive at the Horner scheme in action,

$
p_(4)(x)
&= a_(0) + a_(1) x + a_(2) x^2 + a_(3) x^3 + a_(4) x^4\
&= a_(0) + x (a_(1) + a_(2) x + a_(3) x^2 + a_(4) x^3)\
&= a_(0) + x (a_(1) + x (a_(2) + a_(3) x + a_(4) x^2))\
&= a_(0) + x (a_(1) + x (a_(2) + x (a_(3) + a_(4) x)))
$

Thus evaluation at a fixed $x$ uses $4$ multiplications and $4$ additions.
]

#divider()