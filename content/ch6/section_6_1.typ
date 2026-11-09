#import "../_site.typ": section, definition, theorem, warning, sidenote, boxeq, proof, example
#import "_ch6.typ": xv, xit
#import "section_6_1_figures.typ": fig-tangent

#let meta = (id: "iterative-verfahren-und-abbruchkriterien", title: "6.1-6.2 Iterative Verfahren und Abbruchkriterien")

#show: section.with(meta)

== #meta.title

=== Solving Nonlinear System of Equations

In this chapter, we are interested in *solving nonlinear systems of equations* of the form


$
bold(g)(bold(x)) = bold(b)
$

where $g : Omega subset RR^(d) -> RR^(d)$, $d in NN_(0)$, and $bold(x), bold(b) in RR^(d)$.

#divider()

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
Let us consider a toy example of a system of nonlinear equations. For a circle centered at the origin and a line that is tangent to it, we look for the unique point $bold(x)^(star)$ where both geometric figures exactly meet.

#fig-tangent

The two figures are described by the equations

$
cases(
x^(2) + y^(2) = 8,
x + y = 4.
)
$

whose solution can determined analytically to be $bold(x)^(star) = (x, y) = (2, 2)$. 

Here we are fortunate enough to find the solution by hand, but this is rarely the case in higher dimensions. Let us therefore recast this toy problem in the root-finding form introduced above, so that the methods developed in this chapter apply to it directly. By moving each right-hand side to the left in the above equations, we collect the two expressions into a single vector-valued map $bold(F) : RR^(2) -> RR^(2)$,

$
bold(F)(bold(x)) := bold(F)(x, y) = vec(x + y - 4, x^(2) + y^(2) - 8).
$

Finding the intersection point is then precisely finding a root of $bold(F)$,

$
bold(F)(bold(x)) attach(=, t: !) bold(0).
$


]


Note that in general, such $bold(x)^(star)$ may not be unique. But for the discussions in this chapter, we have the simplest scenario in mind, assuming the above root-finding problem is uniquely solvable by a single solution $bold(x)^(star)$.