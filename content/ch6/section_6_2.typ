#import "../_site.typ": section, definition, theorem, warning, sidenote, boxeq, proof, example, divider, framed
#import "_ch6.typ": xv, xit

#let meta = (id: "abbruchkriterien", title: "6.2 Abbruchkriterien")

#show: section.with(meta)

== #meta.title

Moreover, it would be desirable if an iterative method terminates, when the desired solution $bold(x)^(star)$, or an approximate solution that is "close enough" to $bold(x)^(star)$ is found. In the following, we distinguish between two types of stopping criteria.

*1. A priori criterion:*  With an "a priori" criterion, we meant that the stopping criterion does not taken into account of information obtained during the iterative procedure. For example, we may fix a maximally allowed iteration count $k_(0) in NN$, and force the algorithm to terminate if this threshold is exceeded.

#divider()

*2. A posteriori criterion:*

An "a posteriori" criterion makes use of the information that appears during the iterative procedure to decide whether the iteration should continue or halt. For example, we may compute the distance between our current iterate $bold(x)^((k))$ to the desired ground truth $bold(x)^(star)$, and instruct to stop if the distance measured in some vector norm $norm(dot)$ is smaller than the prescribed tolerance $tau$.

$
norm(bold(x)^((k)) - bold(x)^(star)) <= tau
$

One should notice that the "ground truth" $bold(x)^(star)$ is exactly the *unknown* we are solving for! Unless we are considering some "toy examples" where analytical solution to the root is known, we do not have an expression for it. Therefore, this ideal distance is often not computable in practice. In practice we replace it by one of two alternatives:

*2.1 Correction-based:* stop if the difference between successive iterates is negligible.#sidenote[This often means applying the iteration map does not "improve" the iterates too much anymore.]

$
norm(bold(x)^((k+1)) - bold(x)^((k))) <= tau.
$

*2.2 Residual-based:* since we know the root should fulfill $bold(F)\(bold(x)^(star)\) = bold(0)$, we can stop once the residual is small,

$
norm(bold(F)\(bold(x)^((k))\)) <= tau.
$