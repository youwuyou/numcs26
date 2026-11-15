#import "../_site.typ": section, boxeq, proof, example, anchor-ref, sidenote
#import "_ch6.typ": xv, xit

#let meta = (id: "newton-verfahren-in-d-dimensionen", title: "6.7 Newton-Verfahren in d Dimensionen")

#show: section.with(meta)

// Matrices and vectors in this section are displayed with square brackets.
#set math.mat(delim: "[")
#set math.vec(delim: "[")

== #meta.title

Let $bold(F): Omega subset.eq RR^(d) -> RR^(d)$ be continuously differentiable. We can generalize the idea of using an linear approximation given by the "tangent line" to higher dimensions, e.g. by taking the "tangent plane" instead in two-dimension. Instead of using a scalar-valued derivative function $F'$, we use the Jacobian $D bold(F)$.

#boxeq(title: [Newton's method])[
$
xit(k+1) := xit(k) - D bold(F)(xit(k))^(-1) bold(F)(xit(k))
$
]

The update for the iterate at step $k + 1$ involves again a correction term $Delta xit(k) := - D bold(F)(xit(k))^(-1) bold(F)(xit(k))$, where the information from the step $k$ is used. In practice, we compute this update term by solving the linear system of equations

$
D bold(F)(xit(k)) thin Delta xit(k) = -bold(F)(xit(k))
$



#example("Newton's method for the intersection problem.")[

Let us return to the #anchor-ref("eq-intersection")[toy example], recall that the intersection problem is nonlinear and can be casted into the root-finding problem with the function $bold(F)$

$
bold(F)(x, y) = vec(x^(3) + x - y, 2 y - x - 3)
$

and the Jacobian is

$
D bold(F)(x, y) &= mat(3 x^(2) + 1, -1; -1, 2)
$

Moreover, we know from the previous discussion that there is one unique root $xv^(star) := mat(1, 2)^(T)$, which can serve as a reference solution. Next, to see how Newton's method in two-dimension works, let us try to start from an initial guess $xit(0) = mat(1, 1)^(T)$#sidenote[In practical application, people often use "zeros" as a guess, there are also techniques to make more "educated guess".].


#underline[*Newton iteration at $k = 0$*]

Recall that each step requires the current function value together with the Jacobian evaluated at the current iterate. Let us therefore first evaluate the two,

$
bold(F)(xit(0)) &= vec(1^(3) + 1 - 1, 2 dot 1 - 1 - 3) = vec(1, -2), \
D bold(F)(xit(0)) &= mat(4, -1; -1, 2).
$

We can now compute the Newton's correction $Delta xit(0)$ for the current iteration by solving the linear system $D bold(F)(xit(0)) thin Delta xit(0) = -bold(F)(xit(0))$

$
Delta xit(0) &= -mat(4, -1; -1, 2)^(-1) vec(1, -2) = -frac(1, 7) mat(2, 1; 1, 4) vec(1, -2) = vec(0, 1)
$

Using the correction term, we advanced the iterate to $xit(1)$

$
xit(1)       &= xit(0) + Delta xit(0) = vec(1, 1) + vec(0, 1) = vec(1, 2).
$

Notice that this single step already lands exactly on the root $xv^(star) = (1, 2)$, and this is related to the fact that we have chosen an initial guess that was "close enough" to the actual solution. However, if we are far from the solution, the update we perform may not guarantee that we get closer to the target.
]
