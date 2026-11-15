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





=== Gedämpftes Newton-Verfahren

While the Newton's method performs excellently provided the initial iterate is already close to the desired solution, it has the problem that if we are far away from it, performing a full Newton's correction significantly lead us to a worse solution, in this case, the method "overshoots".

The underlying idea of the damped Newton's method is therefore to shorten the step by a factor $lambda^((k)) in (0, 1]$, note that for the damping to work appropriately, there are conditions such a factor needs to satisfy, which we do not elaborate here.

#boxeq(title: [Damped Newton's method])[
$
xit(k+1) := xit(k) - lambda^((k)) D bold(F)(xit(k))^(-1) bold(F)(xit(k))
$
]


=== Das Quasi-Newton Verfahren

In higher dimensions, forming the Jacobian $D bold(F)$ at every step can be costly. The idea behind the secant method of section 6.6, where we replaced the derivative by the slope of a secant line, generalizes to the family of *quasi-Newton methods*: instead of forming the Jacobian, we carry a cheap approximation $bold(J)^((k)) approx D bold(F)(xit(k))$ and refine it after each step. Its classical instance is *Broyden's method*.

#boxeq(title: [Broyden's method])[
$
xit(k+1) &:= xit(k) + Delta xit(k) \
Delta xit(k) &= - (bold(J)^((k)))^(-1) bold(F)(xit(k))\
bold(J)^((k+1)) &= bold(J)^((k)) + frac(bold(F)(xit(k+1)) (Delta xit(k))^(T) , norm(Delta xit(k))^(2)_(2) )
$

]

where we initialize $bold(J)^((0)) := D bold(F)(xit(0))$. Notice that each step alters $bold(J)^((k))$ only by a rank-one matrix. Therefore, the inverse needed for the correction $Delta xit(k)$ can be updated cheaply via the *Sherman-Morrison formula*.

#proof(title: [Deriving the rank-one update from the secant condition])[

To obtain the update rule used above, we require the new approximation $bold(J)^((k+1))$ to satisfy the secant condition:

$
bold(J)^((k+1)) thin Delta xit(k) = bold(F)(xit(k+1)) - bold(F)(xit(k)).
$

Note that the above condition is an equation involving a *matrix* as the unknown, since the correction $Delta xit(k)$ is already computed from the previous iteration step. Moreover, to actually resolve for $bold(J)^((k+1))$ the above condition needs to be supplied together with $(d- 1)$ more equations such that the matrix can be uniquely determined.

The idea underlying the Broyden's method is to fix the remaining degrees of freedom by enforcing the constraint that the desired matrix should change the previous correction term as little as possible, keeping $bold(J)^((k+1))$ equal to $bold(J)^((k))$ on all directions orthogonal to $Delta xit(k)$. Equivalently, among all matrices satisfying the secant condition it takes the one closest to $bold(J)^((k))$ in the Frobenius norm. This choice is unique and given by the rank-one update

$
bold(J)^((k+1)) = bold(J)^((k)) + frac((bold(F)(xit(k+1)) - bold(F)(xit(k)) - bold(J)^((k)) Delta xit(k)) thin (Delta xit(k))^(T), norm(Delta xit(k))^(2)_(2)).
$

Finally, since the correction solves $bold(J)^((k)) Delta xit(k) = -bold(F)(xit(k))$, we substitute this into the numerator and simplify,

$
bold(J)^((k+1)) &= bold(J)^((k)) + frac((bold(F)(xit(k+1)) - bold(F)(xit(k)) - bold(J)^((k)) Delta xit(k)) thin (Delta xit(k))^(T), norm(Delta xit(k))^(2)_(2)) \
&= bold(J)^((k)) + frac((bold(F)(xit(k+1)) - bold(F)(xit(k)) + bold(F)(xit(k))) thin (Delta xit(k))^(T), norm(Delta xit(k))^(2)_(2)) \
&= bold(J)^((k)) + frac(bold(F)(xit(k+1)) thin (Delta xit(k))^(T), norm(Delta xit(k))^(2)_(2)),
$

recovering the form used above.
]

