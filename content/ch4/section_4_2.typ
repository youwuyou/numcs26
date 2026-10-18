#import "../_site.typ": section, boxeq, example, warning, theorem, sidenote, divider, anchor, anchor-ref, cblue, cred, figure-img
#import "section_4_2_figures.typ": fig-phi-basis, fig-psi-basis

#let meta = (id: "kubische-hermite-interpolation", title: "4.2 Kubische Hermite-Interpolation")

#show: section.with(meta)

#divider()

== #meta.title

In the previous section, we introduced the simplest case of a piecewise interpolation scheme that gives rise to a interpolant that is continuous, yet not differentiable $hat(f) in C^(0)([a, b])$. In this section, we would like to study an alternative that allows us to have a smoother interpolant that is of class $C^(1)$, meaning that we can differentiable $hat(f)$ once.

In fact, let us denote the local polynomial as $s := p_(n): I_(j) :=  [x_(j-1), x_(j)] -> RR$, and write $h_(j) := x_(j) - x_(j-1)$ for the width of the subinterval. Within such a subinterval $I_(j)$, the interpolant $s$ is given by

#boxeq[
$
s_(j)(x) = p_(j)(x) + q_(j)(x), quad forall x in I_(j)
$
]

where each contribution of $p_(j), q_(j)$ is already parameterized to the generic interval $I_(j)$.

$
p_(j)(x) &= cblue(y_(j-1)) phi(frac(x_(j) - x , h_(j))) + cblue(y_(j)) phi(frac(x - x_(j-1), h_(j)))\
q_(j)(x) &= cred(c_(j)) h_(j) psi(frac(x - x_(j - 1), h_(j))) - cred(c_(j-1)) h_(j) psi(frac(x_(j) - x , h_(j)))
$

Note that, the Hermite basis functions $phi, psi$ that are defined on the reference interval $hat(I) = [0,1]$, given as follows


#anchor("eq-hermite-basis")[#boxeq[
$
phi(t) &= t^(2)(3 - 2t)\
psi(t) &= t^(2)(t - 1)
$
]]

#figure-img(
  "content/ch4/HermiteBasis.svg",
  "The four cubic Hermite basis functions on the unit interval.",
  width: 45%,
  credit: [Source: #link("https://commons.wikimedia.org/wiki/File:HermiteBasis.svg")[Wikimedia Commons]],
)[
  The four cubic Hermite basis functions on $hat(I) = [0, 1]$.\ In our notation, $h_(00) = phi(1 - t)$, $h_(01) = phi(t)$, $h_(11) = psi(t)$ and $h_(10) = -psi(1 - t)$.
]



==== Imposing Constraints of Values and Slopes at Endpoints

Note that, in the expressions of $p_(j), q_(j)$, unlike before that we only specified $y_(j)$ using the function values
$f(x_(j)) = y_(j)$, we also need to impose a condition to state "how steep the slope should be" at endpoints. Collectively, both the value and slope constraints on a subinterval $I_(j) = [x_(j-1), x_(j)]$ can be specified on both $x_(j-1), x_(j)$ respectively by

- On left endpoint $x_(j - 1)$ of $I_(j)$
$
cases(
cblue(s(x_(j-1)) = y_(j-1)),
cred(s^(')(x_(j-1)) = c_(j-1)),
)
$

- On right endpoint $x_(j)$ of $I_(j)$
$
cases(
cblue(s(x_(j)) = y_(j)),
cred(s^(')(x_(j)) = c_(j)),
)
$

Hence, there are total $4$ degrees of freedom. In other words, the local polynomial fulfilling such conditions should be of degree $n = cred(3)$ in this subinterval. As remarked in the lecture, the choice of slope values $cred(c_(j))$ should be "done wisely".

In fact, there are _slope estimators_ that extract information from the provided sample data points and provide suitable $cred(c_(j))$ values for us. In particular, the *PCHIP* and *Akima* were the ones mentioned in the class; while *PCHIP* has the more desirable "structure-preserving"#sidenote[DE: "formbehaltend"] property to preserve intrinsic properties of the original function $f$ while obtaining the interpolant $hat(f)$, such as the monotonicity property of a function.#sidenote[In `scipy.interpolate`, see #link("https://docs.scipy.org/doc/scipy/reference/generated/scipy.interpolate.PchipInterpolator.html")[`PchipInterpolator`] and #link("https://docs.scipy.org/doc/scipy/reference/generated/scipy.interpolate.Akima1DInterpolator.html")[`Akima1DInterpolator`].]

==== Deriving Formulas of the Hermite Basis Functions $phi, psi$

Instead of memorizing the formulas, one could also derive the formulas of $phi, psi$ by starting from a cubic polynomial on $hat(I) = [0,1]$

$
a t^(3) + b t^(2) + c t + d,
$

Now, we should recall the same idea in the construction of Lagrange basis that the Kronecker delta property was essential for the linear independence for viable basis to span the vector space. We similarly impose such conditions on $phi, psi$ and their derivatives $phi^('), psi^(')$. Let us denote $t_(0) = 0, t_(1) = 1$ for the two endpoints, then for the selected index $m in {0, 1}$, we require the Kronecker delta properties by

$
phi(t_(m)) &= delta_(m 1), quad & phi'(t_(m)) &= 0,\
psi(t_(m)) &= 0, quad & psi'(t_(m)) &= delta_(m 1).
$

This would allow us to derive the formula for $phi, psi$ by solving for the coefficients $a,b,c,d$.

#example("Deriving the formula for " + $psi$)[
For $psi$ the Kronecker conditions were
$
psi(t_(m)) = 0, quad psi'(t_(m)) = delta_(m 1), quad m in {0, 1},
$

In other words,

$
cases(
  psi(0) = 0 & quad ==> quad d = 0,
  psi'(0) = 0 & quad ==> quad c = 0,
  psi(1) = 0 & quad ==> quad a + b = 0,
  psi'(1) = 1 & quad ==> quad 3a + 2b = 1
)
$
The last two equations give $a = 1$ and $b = -1$, hence
$
psi(t) = t^(3) - t^(2) = t^(2)(t - 1) .
$

#linebreak()

#fig-psi-basis
]

#example("Deriving the formula for " + $phi$)[
For $phi$ the Kronecker conditions were
$
phi(t_(m)) = delta_(m 1), quad phi'(t_(m)) = 0, quad m in {0, 1},
$

In other words,

$
cases(
  phi(0) = 0 & quad ==> quad d = 0,
  phi'(0) = 0 & quad ==> quad c = 0,
  phi(1) = 1 & quad ==> quad a + b = 1,
  phi'(1) = 0 & quad ==> quad 3a + 2b = 0
)
$
This time $a = -2$ and $b = 3$, so
$
phi(t) = -2 t^(3) + 3 t^(2) = t^(2)(3 - 2t) .
$

#linebreak()

#fig-phi-basis
]