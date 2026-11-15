#import "../_site.typ": section, definition, theorem, warning, sidenote, boxeq, proof, example, divider
#import "_ch6.typ": xv, xit
#import "section_6_1_figures.typ": fig-cubic

#let meta = (id: "iterative-verfahren", title: "6.1 Iterative Verfahren")

#show: section.with(meta)

== #meta.title

=== Solving Nonlinear System of Equations

In this chapter, we are interested in *solving nonlinear systems of equations* of the form


$
bold(g)(bold(x)) = bold(b)
$

where $g : Omega subset RR^(d) -> RR^(d)$, $d in NN_(0)$, and $bold(x), bold(b) in RR^(d)$.

We can convert the above problem to an equivalent *root-finding problem* by introducing the function $bold(F)$,

$
bold(F)(bold(x)) := bold(g)(bold(x)) - bold(b)
$

The desired solution $bold(x)^(star)$ is then a #emph[root] of $bold(F)$,

#boxeq[
$
bold(F)(bold(x)^(star)) = bold(0)
$
]



#example("A first example of a nonlinear system of equations.")[
Let us consider a toy example of a system of nonlinear equations. In the following, we are interested in finding the *intersection point(s)* of a cubic curve given by $y = x^(3) + x$ and a straight line $2 y - x = 3$. Or expressed in the following to solve the following system of equations, where the *nonlinearity* is introduced via the cubic term:



$
cases(
y = x^(3) + x,
2 y - x = 3.
)
$

In fact, we may draw them on an Euclidean plane, and see how it looks like geometrically:




#fig-cubic


We shall easily see that for this example such a point is in fact *unique*, let us denote this point where the two curves meet as $bold(x)^(star)$. Moreover, for this simple example, we can solve for the coordinates analytically, which is given by $bold(x)^(star) = (x, y) = (1,2)$.

#divider()

#underline[*Solving numerically*]

In this chapter, we are interested in solving such systems numerically. But in order to do this, let us therefore recast this toy problem in the root-finding form introduced above, so that the methods that we will develop in this chapter directly applies. 

By moving each right-hand side to the left in the above equations, we collect the two expressions into a single vector-valued map $bold(F) : RR^(2) -> RR^(2)$,

$
bold(F)(bold(x)) := bold(F)(x, y) = vec(x^(3) + x - y, 2 y - x - 3).
$

Finding the intersection point is then precisely finding a root of $bold(F)$,

$
bold(F)(bold(x)) attach(=, t: !) bold(0).
$

We will soon see how such a root-finding problem can be solved numerically in a computer.

]


Note that in general, such $bold(x)^(star)$ is often not unique. But for the discussions in this chapter, we have the simplest scenario in mind, assuming the above root-finding problem is uniquely solvable by a single solution $bold(x)^(star)$.


=== Iterative Methods for Root-Finding

An iterative method for solving the nonlinear equation (or the equivalent root-finding problem) is an algorithm generating a sequence of approximate solutions. We further assume the generation of such a sequence is given by a function $phi.alt_(bold(F))$ that takes into account the problem structure, i.e. the properties of $bold(F)$, to generate such a sequence $\{ bold(x)^((k)) \}_(k in NN_(0))$.

$
bold(x)^((0)), bold(x)^((1)), dots
$


Ideally, when such an algorithm terminates at some step $k in NN_(0)$, the obtained approximate solution $bold(x)^((k))$ should be "close enough" to the true solution, denoted as $bold(x)^(star)$.

$
bold(x)^((k)) -> bold(x)^(star) in Omega
$

Beyond asking *whether* the iterates converge, we are interested in *how fast* they approach $xv^(star)$. This is captured by the notion of *order of convergence*. #sidenote[The case $p = 1$ is called *linear convergence*. We will encounter it shortly as a direct consequence of contractivity in section 6.3.]

#definition("Order of convergence.")[

A sequence $xit(k)$ converges to $xv^(star)$ with *order* $p >= 1$ if there exists $C > 0$ such that

$
norm(xit(k+1) - xv^(star)) <= C norm(xit(k) - xv^(star))^(p), quad forall k in NN,
$

where we additionally require $C < 1$ in the case $p = 1$.

]