#import "../_site.typ": section, thought, example, definition, sidenote, boxeq, divider, mat, vec, cblue, cred, colive, proof
#import "section_5_7_figures.typ": fig-domains, fig-dyadic
#import "section_5_7_sparse.typ": fig-sparse
#import "section_5_7_curse.typ": fig-curse
#import "section_5_7_aniso.typ": fig-aniso
#import "section_5_7_trapezoid.typ": fig-trapezoid

// Editorial review note. Typst drops `text(fill:)` in the HTML target, so emit a
// styled <span> for the website and fall back to colored text for the PDF build.
#let review(body) = context {
  if target() == "html" {
    html.elem("span", attrs: (style: "color: #e4272b"))[#body]
  } else {
    text(fill: rgb("#e4272b"), body)
  }
}

#let meta = (id: "quadratur-in-rd-und-duenne-gitter", title: "5.7 Quadratur in ℝᵈ und dünne Gitter")

#show: section.with(meta)

// Unlike other sections, the heading is written out instead of `#meta.title` so
// the domain renders as real math ($RR^d$). `meta.title` stays a plain string
// with a Unicode "ℝᵈ" for the sidebar nav and the section-number regex.
== 5.7 Quadratur in $RR^(d)$ und dünne Gitter

Let $f : Omega subset RR^(d) -> RR$ be a multivariate real-valued function. The general form of integration over $Omega$ is

$
I = integral_(Omega) f(x_(1), dots, x_(d)) d x_(1) dots d x_(d).
$

In particular, we should notice two difficulties here. The first is how to *represent* and *discretize* the domain $Omega subset RR^(d)$, and the second is how to *define* functions, extending our discussion of polynomials to the higher-dimensional setting.

=== Representation of the Domain $Omega subset RR^(d)$

Let us first refer to the domain as a *grid*, formed by the tensor product of $d$ one-dimensional intervals,

$
Omega = I_(x_(1)) times dots times I_(x_(d)),
$

where each $I_(x_(j))$, $j in {1, dots, d}$, denotes a one-dimensional interval along coordinate $x_(j)$. We may examine this visually in dimensions $d = 1, 2, 3$.

#fig-domains

For numerical treatments we need to perform a *discretization* of the domain. Note that for each dimension $j$ we may independently choose the number of points to use. In general, if all dimensions are treated equally, we say the grid is #underline[*isotropic*]; otherwise it is called #underline[*anisotropic*].

#example("Isotropic grids: a fixed " + $N$ + " per direction and the \"curse of dimensionality\".")[

If we fix the amount of discretization points in each dimension to $N$, then a $d$-dimensional grid gives rise to $N^(d)$ evaluation points, which grows rapidly in the number of nodes, as illustrated below in red.

#fig-curse
]

#example("Anisotropic grids: choosing " + $N_(j)$ + " per direction.")[

An anisotropic grid may use a different number $N_(j)$ of points per coordinate direction $j$. In the following, we denote the choice of grid points in an array,

$
bold(N) := (N_(1), N_(2)) = (16, 4)
$

Then we need in total only $64$ points,

$
N_(1) dot N_(2) = 16 dot 4 = 64
$

if we want to achieve the same finest resolution in an isotropic grid, we have to use $N^(2) = 16 dot 16 = 256$ grid points.

#fig-aniso


]

#divider()


=== Multivariate Polynomials

In the previous chapters, we considered the space of univariate polynomials spanned by monomials up to degree $n in NN_(0)$, denoted as $P_(n) := "span"{1, x, dots, x^n}$. Here, each basis function is a monomial raised to some power $alpha_(j)$.

$
b_(alpha_j)(x_j) = x_j^(alpha_j)
$

We now extend this construction to functions that takes a $d$-dimensional input argument $bold(x) = (x_1, dots, x_d)^T in RR^d$. Then, we may similarly introduce basis functions of the following form

$
b_(bold(alpha))(bold(x))
:= bold(x)^(bold(alpha))
:= product_(j=1)^d x_j^(alpha_j)
= x_1^(alpha_1) dots x_d^(alpha_d).
$

We used the *multi-index notation* above. With $bold(alpha) = (alpha_1, dots, alpha_d) in NN_0^d$, that consists of each component $alpha_j$ that specifies the exponent of the corresponding coordinate $x_j$.

Note that, an alternative view of understanding the above multivariate basis function is to see it as a tensor product of $d$ univariate monomial basis functions,

$
b_(bold(alpha))
= b_(alpha_1) times.o dots times.o b_(alpha_d),
$
where $b_(alpha_j)(x_j) = x_j^(alpha_j)$.

#example("Constructing multivariate " + $b_(bold(alpha))$ + "using tensor products " + $times.o$ + "of univariate " + $b_(alpha_(j))$)[

The tensor product provides a general way of constructing multivariate functions from univariate ones. Given functions $f_1, dots, f_d: RR -> RR$, their tensor product is the function
#boxeq[
$
(f_1 times.o dots times.o f_d)(bold(x))
:= product_(j=1)^d f_(j)(x_j).
$
]

Thus, a tensor product combines one function of each coordinate into a single function of $d$ variables. The multivariate monomials above are a particular example, obtained by taking each $f_j$ to be a univariate monomial.

]

To proceed, we need to introduce ways of specifying degrees of a multivariate basis function in a more "fine-grained" manner. Unlike in the univariate case, the degree of a multivariate monomial involves several exponents. We will consider two natural ways of constraining these exponents, leading to two different notions of multivariate polynomial spaces.


==== Constraint on the Total Degree

The first way to specify the degrees of such a polynomial is to enforce a constraint on the *total degree*. We introduce the notion with $abs(dot)_(1)$, to require the sum of all powers may not exceed $N in NN_(0)$

$
abs(bold(alpha))_(1) := sum_(i = 1)^(d) alpha_(i) < N
$

This naturally gives rise to the *total-degree space*.

#definition("Total-Degree Space " + $P_(n)(RR^(d))$)[
The total-degree $d$-variate polynomial space is defined as

$
P_(n)(RR^(d)) := { bold(x) |-> sum_(abs(bold(alpha))_(1) <= n) c_(bold(alpha)) b_(bold(alpha))(bold(x)), quad c_(bold(alpha)) in RR }.
$


here, $n in NN_(0)$ is a fixed upper-bound on the total degree of each basis function, expressed by using $abs(bold(alpha))_(1) <= n$.

]


#example("Bivariate Polynomial Space - " + $P_(2)(RR^(2))$)[
As an example, the bivariate ($d = 2$) space of degree $n = 2$ is spanned by

$
P_(2)(RR^(2)) = "span"{ 1, x_(1), x_(2), x_(1)^(2), x_(2)^(2), x_(1) x_(2) },
$

where every basis monomial $x_(1)^(alpha_(1)) x_(2)^(alpha_(2))$ satisfies the total-degree bound $alpha_(1) + alpha_(2) <= 2$.
]

#divider()

==== Constraint on the Highest Degree

The other alternative is to impose the constraint on the *highest degree reached in any coordinate direction*. We introduce $abs(dot)_(infinity)$ to express the bound on the largest exponent as follows, #sidenote[On an anisotropic grid we may allow a separate bound $n_(j)$ per direction, which can be formulated as a weighted $abs(dot)_(infinity)$ constraint $max_(1 <= j <= d) alpha_(j) / n_(j) <= 1 <=> alpha_(j) <= n_(j), forall j$.]

$
abs(bold(alpha))_(infinity) := max_(1 <= i <= d) alpha_(i) <= n
quad <==> quad
alpha_(i) <= n quad forall i,
$

#definition("Tensor-Product Space " + $cal(Q)_(n)(RR^(d))$)[
The tensor-product $d$-variate polynomial space is defined as

$
cal(Q)_(n)(RR^(d)) := { bold(x) |-> sum_(abs(bold(alpha))_(infinity) <= n) c_(bold(alpha)) b_(bold(alpha))(bold(x)), quad c_(bold(alpha)) in RR }.
$


here, $n in NN_(0)$ is a fixed upper-bound on the highest coordinate degree of each basis function, expressed by using $abs(bold(alpha))_(infinity) <= n$.

]

Note that this definition above may be generalized to consider a bound of each direction on its own through a degree vector $bold(n) = (n_(1), dots, n_(d)) in NN_(0)^(d)$, i.e. $alpha_(i) <= n_(i)$ for all $i$, giving the *anisotropic* tensor-product space $cal(Q)_(bold(n))(RR^(d))$, again using the multi-index notation.


#example("Bivariate Polynomial Space - " + $cal(Q)_(2)(RR^(2))$)[
As an example, the bivariate ($d = 2$) space of degree $n = 2$ is spanned by

$
cal(Q)_(2)(RR^(2)) = "span"{ 1, x_(1), x_(2), x_(1) x_(2), x_(1)^(2), x_(2)^(2), x_(1)^(2) x_(2), x_(1) x_(2)^(2), x_(1)^(2) x_(2)^(2) },
$

where every basis monomial $x_(1)^(alpha_(1)) x_(2)^(alpha_(2))$ satisfies the maximal-degree bound $max{alpha_(1), alpha_(2)} <= 2$, giving $3 times 3 = 9$ basis functions.
]

==== Comparing Different Degree Constraints

To conclude, we may again use the tensor products to put these two spaces in parallel, with the $d$-variate basis denoted as $b_(alpha_(1)) times.o dots times.o b_(alpha_(d))$, one shall notice the spaces differ only in how bounds on powers $bold(alpha)$ are specified,

#boxeq[
$
P_(n)(RR^(d)) &= "span"{ b_(alpha_(1)) times.o dots times.o b_(alpha_(d)) : abs(bold(alpha))_(1) <= n }\
cal(Q)_(n)(RR^(d)) &= "span"{ b_(alpha_(1)) times.o dots times.o b_(alpha_(d)) : abs(bold(alpha))_(infinity) <= n } \
$
]

In the following, we consider a fixed degree $n$ and examine an arbitrary function $f$ in each space, respectively. Let us resort to a two-dimensional case with $d = 2$. A tensor-product polynomial $f in cal(Q)_(bold(n))(RR^(2))$ can then be written as follows, with $bold(phi), bold(psi)$ collecting the univariate basis functions along each coordinate direction, respectively.

$
f(bold(x)) &= bold(phi)(x_(1))^(T) bold(C) bold(psi)(x_(2)) \
&= mat(b_(0)(x_(1)), dots, b_(n_(1))(x_(1)))
mat(
  c_(0 0), dots, c_(0 n_(2));
  dots.v, dots.down, dots.v;
  c_(n_(1) 0), dots, c_(n_(1) n_(2))
)
vec(b_(0)(x_(2)), dots.v, b_(n_(2))(x_(2))),
$

The distinction between total-degree and tensor-product spaces then translates into *which entries of the coefficient matrix $bold(C)$ are allowed to be nonzero*, as the following examples show.

#example("Function in the isotropic tensor-product space " + $cal(Q)_(3)(RR^(2))$)[

For $f in cal(Q)_(3)(RR^(2))$ we have $f(bold(x)) = sum_(abs(bold(alpha))_(infinity) <= 3) c_(alpha_(1) alpha_(2)) x_(1)^(alpha_(1)) x_(2)^(alpha_(2))$, i.e. in matrix form

$
f(bold(x)) = mat(1, x_(1), x_(1)^(2), x_(1)^(3))
mat(
  c_(00), c_(01), c_(02), c_(03);
  c_(10), c_(11), c_(12), c_(13);
  c_(20), c_(21), c_(22), c_(23);
  c_(30), c_(31), c_(32), c_(33)
)
vec(1, x_(2), x_(2)^(2), x_(2)^(3)),
$

where we pick the monomial basis up to degree $3$ for both coordinate directions. It is notable that the coefficient matrix $bold(C)$ may be in general fully populated.
]

#example("Function in the total-degree space " + $P_(3)(RR^(2))$)[

For $f in P_(3)(RR^(2))$ we instead have $f(bold(x)) = sum_(abs(bold(alpha))_(1) <= 3) c_(alpha_(1) alpha_(2)) x_(1)^(alpha_(1)) x_(2)^(alpha_(2))$, so the total-degree bound $alpha_(1) + alpha_(2) <= 3$ forces the lower-right entries to vanish,

$
f(bold(x)) = mat(1, x_(1), x_(1)^(2), x_(1)^(3))
mat(
  c_(00), c_(01), c_(02), c_(03);
  c_(10), c_(11), c_(12), 0;
  c_(20), c_(21), 0, 0;
  c_(30), 0, 0, 0
)
vec(1, x_(2), x_(2)^(2), x_(2)^(3)).
$

Note that the coefficient matrix $bold(C)$ is an upper-triangular matrix.
]

#divider()

=== Tensor Products of Quadrature Rules and Sparse Grids

So far, we set up the preliminaries to describe a multivariate polynomial. More specifically, we saw how the tensor product uses $d$ univariate functions to construct a $d$-variate function.

We will now see a first application to *quadrature rules*, and we will use tensor product to allow extending the 1D quadrature rule $Q(f; a, b)$, which we learnt in the previous sections to higher dimensions.


==== Halving Intervals Up to the Level of Refinement $ell$

In the following, we may consider a one-dimensional reference interval $hat(I) = [0, 1]$. Moreover, we consider the refined sequence of such a grid up to a certain level $ell in NN_(0)$, by halving such an interval $ell$ times. At refinement level $ell$, the interval is partitioned into $2^(ell)$ subintervals, giving the node set

$
X_(ell) = { j / 2^(ell) : j = 0, dots, 2^(ell) }.
$

This gives rise to a nested sequence of grid subdivisions $X_(ell - 1) subset X_(ell)$, where division points at level $ell - 1$ are always contained in the grid at the next level $ell$, while new nodes are introduced between the existing ones, as illustrated below.

#fig-dyadic

For a fixed level $l$, we denote the composite trapezoidal quadrature rule over the entire interval $hat(I)$ as $Q_(ell)^(1)$ that consists of $2^(l)$ such "trapezoids" used to approximate the area under the curve of a function. Therefore, the nested grids give rise to a sequence of composite quadrature rules $Q_(1)^(1), Q_(2)^(1), Q_(3)^(1), dots$, that are defined on increasingly finer grids.

==== Difference Triangles

Before we proceed, it is important to note that such a nested sequence of grids allows for an alternative way of tracking improvements across refinement levels, by tracking only what each new level *adds upon* the previous level. In the following, we illustrate this idea geometrically. Note that the left subplot shows $Q_(1)^(1)(f; a,b)$ and $Q_(2)^(1)(f; a, b)$, and we observe their difference consists of geometrically exactly a single triangle. We may denote the difference as $Delta_(2)^(1)$,

$
Delta_(2)^(1) := Q_(2)^(1)(f; a, b) - Q_(1)^(1)(f; a, b).
$

By performing one more level of refinement, we obtain the composite rule $Q_(3)^(1)$ that now consists of $4$ trapezoids. We can also see there are two triangular pieces as increments, these differences are tracked by $Delta_(3)^(1)$ defined as follows:

$
Delta_(3)^(1) := Q_(3)^(1)(f; a, b) - Q_(2)^(1)(f; a, b),
$


#fig-trapezoid

To allow for a more general treatment, we call the increment a *difference triangle*, this is a function that tracks the difference a level-$ell$ quadrature rule adds over a level-$ell - 1$ rule. It is defined as:

$
Delta_(ell)^(1) := Q_(ell)^(1) - Q_(ell - 1)^(1).
$

Next, we highlight an important identity that relates the sum of $ell$ difference triangles to a level-$ell$ quadrature rule.#sidenote[This is the quadrature instance of a general hierarchical decomposition. Writing $V_(ell)$ for the space of functions resolved at level $ell$, the nested grids give $V_(0) subset V_(1) subset dots$, and each level splits off a complement $W_(ell)$ with $V_(ell) xor W_(ell) = V_(ell + 1)$. The telescoping sum below is then the counterpart of $f = f_(0) + Delta f_(0) + Delta f_(1) + dots$, whose increments $Delta f_(ell) in W_(ell)$ form the *hierarchical basis*. Gradinaru.]

#boxeq[
$
Q_(ell)^(1) = sum_(k = 1)^(ell) Delta_(k)^(1).
$
]

#proof(title: [Proof. Trapezoidal quadrature as a sum of difference triangles.], boxed: true)[

The definition of the difference triangle given as $Delta_(k)^(1) = Q_(k)^(1) - Q_(k - 1)^(1)$ can be rearranged to $Q_(k)^(1) = Q_(k - 1)^(1) + Delta_(k)^(1)$. We now make use of this identity to unroll a quadrature rule $Q^(1)_(ell)$ refined at level $ell$ down to the base level,

$
Q_(ell)^(1) f
&= Q_(ell - 1)^(1) f + Delta_(ell)^(1) f \
&= Q_(ell - 2)^(1) f + Delta_(ell - 1)^(1) f + Delta_(ell)^(1) f \
& dots.v \
&= underbrace(Q_(0)^(1) f, = 0) + Delta_(1)^(1) f + dots + Delta_(ell - 1)^(1) f + Delta_(ell)^(1) f
= (sum_(k = 1)^(ell) Delta_(k)^(1)) f.
$
]

We can now make use of the above summation and examine a simple case to combine two 1D quadrature rules $Q^(1)_(ell_(1)), Q^(1)_(ell_(2))$ of arbitrary refinement levels $ell_(1), ell_(2) in NN_(0)$, respectively, to a two-dimensional quadrature rule. We do it by taking their tensor products, with the sum of difference triangles substituted in.

$
Q_(ell_(1))^(1) times.o Q_(ell_(2))^(1)
&= (sum_(k_(1) = 1)^(ell_(1)) Delta_(k_(1))^(1)) times.o (sum_(k_(2) = 1)^(ell_(2)) Delta_(k_(2))^(1))\
&= sum_(k_(1) = 1)^(ell_(1)) sum_(k_(2) = 1)^(ell_(2)) Delta_(k_(1))^(1) times.o Delta_(k_(2))^(1).
$


The last step uses bilinearity to distribute the tensor product over both sums, turning it into a single double sum with one tensor product of two difference triangles per index pair $(k_(1), k_(2))$.

#divider()

==== The Tensor-Product Grid

By generalizing the operation of taking tensor products to combine $d$ one-dimensional quadrature rules, we obtain $d$-dimensional quadrature rule on a *tensor-product grid*, defined as follows:

#definition("Quadrature on tensor-product grids.")[

The $d$-dimensional quadrature rule on a tensor-product grid is defined by a tensor product of $d$ one-dimensional quadrature rules, given as:

$
Q_(bold(ell))^(d)
&= Q_(ell_(1))^(1) times.o dots times.o Q_(ell_(d))^(1) = sum_(k_(1) = 1)^(ell_(1)) dots sum_(k_(d) = 1)^(ell_(d)) Delta_(k_(1))^(1) times.o dots times.o Delta_(k_(d))^(1)
$

here $bold(ell) := (ell_(1), dots, ell_(d))$ denotes the refinement levels chosen for each coordinate direction.

]

If we set $bold(ell) = (ell, dots, ell)$, this gives rise to an *isotropic* grid, whose degree constraints can be expressed by $abs(bold(k))_(infinity) <= ell$, this gives the following simplified notation

$
Q_(ell)^(d) = sum_(abs(bold(k))_(infinity) <= ell) Delta_(bold(k))^(d).
$

However, the quadrature formula defined above is strongly affected by the "curse of dimensionality". To reduce the overall degrees of freedom, but still reach a desired level of refinement $ell$, we should borrow the idea from the previous section to *constrain the total degree* instead. 

==== The Smolyak Sparse Grid

In fact, we may discard "unimportant" contributions that refine many directions at once, and keep only those whose total refinement $abs(bold(k))_(1)$ stays small. This is the underlying idea of the quadrature formula on a *Smolyak sparse grid*.


#definition("Quadrature on Smolyak sparse grids")[

The $d$-dimensional quadrature rule on a Smolyak sparse grid that reaches the finest level $ell in NN_(0)$ in a single coordinate direction is given as

$
S_(ell)^(d) f := sum_(abs(bold(k))_(1) <= ell + d - 1) Delta_(bold(k))^(d) f.
$

here the bound $ell + d - 1$ ensures the most refined term reach level $ell$ in a single direction, in the form of $bold(k) = (ell, 1, dots, 1)$.

]


In practical applications, we use the following formula that is equivalent to the above formula, but *reuses the quadrature formulas* $Q_(k)^(1)$. The alternating sum comes directly from the fact that each difference triangle is a subtraction of two quadrature rules, and $q$ is used as a counting argument to group these terms by their total refinement $abs(bold(k))_(1) = ell + q$.

#boxeq[
$
S_(ell)^(d) f = sum_(q = 0)^(d - 1) (-1)^(d - 1 - q) binom(d - 1, q) sum_(abs(bold(k))_(1) = ell + q) (Q_(k_(1))^(1) times.o dots times.o Q_(k_(d))^(1)) f.
$
]

#example("Quadrature rule " + $S^(2)_(2)$ + " on a two-dimensional Smolyak sparse grid.")[

For $d = 2$ and $ell = 2$, we apply the combinatorial formula and have

$
S_(2)^(2) f
&= sum_(q = 0)^(1) (-1)^(1 - q) binom(1, q) sum_(abs(bold(k))_(1) = 2 + q) (Q_(k_(1))^(1) times.o Q_(k_(2))^(1)) f \
&= underbrace((-1)^(1) binom(1, 0), = -1) sum_(abs(bold(k))_(1) = 2) (Q_(k_(1))^(1) times.o Q_(k_(2))^(1)) f
+ underbrace((-1)^(0) binom(1, 1), = +1) sum_(abs(bold(k))_(1) = 3) (Q_(k_(1))^(1) times.o Q_(k_(2))^(1)) f \
&= - underbrace(cblue((Q_(1)^(1) times.o Q_(1)^(1))), "isotropic " (1\,1))f
+ underbrace(cred((Q_(2)^(1) times.o Q_(1)^(1) + Q_(1)^(1) times.o Q_(2)^(1))), "anisotropic " (2\,1)\, (1\,2))f.
$

]

We can see that the two-dimensional rule adds the contributions of the two anisotropic grids and subtracts their isotropic overlap. In fact, we may illustrate the construction of $S_(2)^(2)$ as follows:

#fig-sparse

Note that since a level-$ell_(i)$ direction carries $2^(ell_(i)) + 1$ nodes, we have in total $21$ nodes on the sparse grid.