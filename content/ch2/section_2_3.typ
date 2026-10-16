#import "../_site.typ": section, defbox, example, mat, vec, matlines, ip, python, cblue, cred, cteal, sidenote, slidebreak, thought, divider, figure-img, boxeq, proof, conj, cancel, theorem, _mathcolor

#let meta = (id: "lagrange-und-baryzentrische-interpolationsformeln", title: "2.3 Lagrange- und baryzentrische Interpolationsformeln")

// Local node colors for the Lagrange-basis example: four soft, distinct hues
// to color-code $x_0, x_1, x_2, x_3$ consistently.
#let cnode0 = _mathcolor("#3a9d5d")
#let cnode1 = _mathcolor("#3a8fb0")
#let cnode2 = _mathcolor("#7a6fc4")
#let cnode3 = _mathcolor("#a85fb0")

#show: section.with(meta)

== #meta.title

The Lagrange interpolation formula is given as,


#boxeq[
$
p_(n)(x) = sum^(n)_(i =  0) y_(i) l_(i)(x)
$
]

with Lagrange polynomials defined for the no. $(n+1)$ nodes $\{x_(0), dots, x_(n)\} subset RR$ #sidenote[Gradinaru, p.50, 2.3.1.]

$
l_(i)(x) = product_(j = 0 \ j != i)^(n) frac(x - x_(j), x_(i) - x_(j))
$

then each Lagrange polynomial $l_(i)$ is of degree $n$, i.e. $deg l_(i) = n$.

#example("Lagrange basis depends on the choice of interpolation nodes.")[

Note that the definitions of Lagrange polynomials $l_(0)(x), dots, l_(n)(x)$ *depend on* the interpolation nodes, unlike the monomial basis. Let $\{ cnode0(x_(0)), cnode1(x_(1)), cnode2(x_(2)), cnode3(x_(3)) \} subset RR$ denote the nodes,

- For $i = 0$, the numerator excludes $cnode0(x_(0))$ and the denumerator consists of product of all pairwise differences between $cnode0(x_(0))$ and other nodes,

$
l_(cnode0(0))(x)
&= frac(
(x - x_(1))(x - x_(2))(x - x_(3)),
(cnode0(x_(0)) - x_(1))(cnode0(x_(0)) - x_(2))(cnode0(x_(0)) - x_(3))
)
$

- For $i = 1$, the numerator excludes $cnode1(x_(1))$ in a similar manner,

$
l_(cnode1(1))(x)
&= frac(
(x - x_(0))(x - x_(2))(x - x_(3)),
(cnode1(x_(1)) - x_(0))(cnode1(x_(1)) - x_(2))(cnode1(x_(1)) - x_(3))
)
$

- For $i = 2$,

$
l_(cnode2(2))(x)
&= frac(
(x - x_(0))(x - x_(1))(x - x_(3)),
(cnode2(x_(2)) - x_(0))(cnode2(x_(2)) - x_(1))(cnode2(x_(2)) - x_(3))
)
$


- For $i = 3$,

$
l_(cnode3(3))(x)
&= frac(
(x - x_(0))(x - x_(1))(x - x_(2)),
(cnode3(x_(3)) - x_(0))(cnode3(x_(3)) - x_(1))(cnode3(x_(3)) - x_(2))
)
$

Note that each of $l_(i)(x), forall i = 0, 1, 2, 3$ is of degree $3$.

]

#example("Kronecker property of Lagrange basis (Gradinaru, p. 50, 2.3.4, properties 1-2)")[

The Lagrange basis $l_(i)(x)$ fulfills for $i, j in {0, 1, dots, n}$ the
Kronecker property,

$
l_(i)(x_(j)) = delta_( i j) = 
cases(
1 quad "if " i = j,
0 quad "otherwise"
)
$

]

An important direct consequence of the #underline[Kronecker delta property] guarantees us that *Lagrange polynomials indeed form a basis of $cal(P)_(n)$*, which is stated as a theorem in the script#sidenote[Gradinaru, p. 51, theorem 2.3.3]. Here we provide a short proof on this statement.

#proof(title: "Proof of Lagrange polynomials " + $l_(0)(x), dots, l_(n)(x)$ + " form a basis of " + $cal(P)_(n)$)[

Assume by contradiction that $l_(i)(x)$ are linearly dependent#sidenote[To demonstrate that the Lagrange polynomials $l_(i)(x), quad i = 0, dots, n$ indeed form a basis of the vector space $cal(P)_(n)$, that is of dimension $dim cal(P)_(n) = n + 1$. We need to show $l_(i)(x)$ are linearly independent.], then there exists coefficients $y_(0), dots, y_(n) in RR$ with $sum^(n)_(i) abs(y_(i)) > 0$ such that

$
p_(n)(x) =  sum_(i = 0)^(n) y_(i) l_(i)(x) = y_(0) l_(0)(x) + dots + y_(n) l_(n)(x) =^(!) 0
$

Recall that the Lagrange basis fulfills the Kronecker property $l_(i)(x_(j)) = delta_(i j)$, and vanishes for all $i != j$. By examining this condition at $x_(0)$, we see

$
p_(n)(x_(0)) 
&=  y_(0) l_(0)(x_(0)) + cancel(y_(1) l_(1)(x_(0))) + dots + cancel(y_(n) l_(n)(x_(0))) = y_(0) l_(0)(x_(0)) =^(!) 0 => y_(0) = 0
$

which implies, the coefficient $y_(0)$ must be zero. And for $x_(1), x_(2), dots, x_(n)$ we can conclude similarly that

$
p_(n)(x_(1)) &= y_(1) l_(1)(x_(1)) =^(!) 0 => y_(1) = 0 \
p_(n)(x_(2)) &= y_(2) l_(2)(x_(2)) =^(!) 0 => y_(2) = 0 \ \
dots.v \
p_(n)(x_(n)) &= y_(n) l_(n)(x_(n)) =^(!) 0 => y_(n) = 0 \
$

However, this means that

$
sum_(i = 0)^(n) abs(y_(i)) = 0
$

this contradicts our assumption. Thus, we know Lagrange polynomials are linearly independent and indeed form a basis of $cal(P)_(n)$.

]



#divider()


🚧 Under construction.
- derivatives of Lagrange polynomials
- error estimate, Lesbegue constant, Runge phenomenon