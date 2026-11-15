#import "../_site.typ": section, definition, example, theorem, boxeq, proof, sidenote, framed
#import "_ch6.typ": xv, yv, xit

// algorithms
#import "@preview/lovelace:0.3.0": *

// Center a (layout) algorithm block in both targets: a flex div in HTML (where
// `framed` rasterizes the pseudocode to inline SVG), `align(center)` when paged.
#let centered-algorithm(body) = context {
  if target() == "html" {
    html.elem("div", attrs: (style: "display: flex; justify-content: center;"))[#framed(body)]
  } else {
    // `box` shrink-wraps the full-width pseudocode block so `align(center)`
    // actually centers it (and its caption follows).
    align(center)[#box(framed(body))]
  }
}

#let meta = (id: "fixpunktiteration", title: "6.3 Fixpunktiteration")

#show: section.with(meta)

== #meta.title

In the following sections, we will examine iterative methods that belong to the family of the *fixed-point iteration*. The iteration map is denoted as $phi.alt := phi.alt_(bold(F))$, where the subscript $bold(F)$ indicates its construction is related to function $bold(F)$ in the root-finding problem to be resolved. Given such an iteration map $phi.alt$ and an initial point $xit(0)$, we generate the sequence by repeatedly applying the map to the previous iterate,

$
xit(k+1) := phi.alt(xit(k))
$

We can consider an appropriate stopping criterion as discussed previously, such that this procedure that generates the iterates terminates at some point. The "blueprint" of such algorithms can be summarized as follows:#sidenote[Note that, here we assume a 1-point iteration. This means the iteration map $phi.alt$ requires only one previous iterate $bold(x)^((k))$ as input. In general, we may compute the updated iterate at $bold(x)^((k+1))$ reuse multiple previous iterates, $bold(x)^((k)), bold(x)^((k-1)), bold(x)^((k-2)), dots$. ]


#figure(
  [#centered-algorithm(pseudocode-list(booktabs: true, numbered-title: [Iterative root-finding])[
    + *Input:* iteration map $phi.alt$, initial guess $bold(x)^((0))$ at $k <- 0$
    + *repeat*
      + $bold(x)^((k+1)) <- phi.alt(bold(x)^((k)))$
      + $k <- k + 1$
    + *until* stopping criterion is met
    + *return* $bold(x)^((k))$ as an approximate solution of $bold(x)^(star)$
  ])#v(12pt)],
  kind: "algorithm",
  supplement: [Algorithm],
  caption: [An abstract blueprint of an iterative root-finding procedure.],
)<alg-iterative>

=== Consistency

A very important property such an iteration map should satisfy is called the *consistency*. Assume that such an fixed-point iteration map should fulfill the property that there exists some $bold(x)$, at which the mapping $phi.alt$ maps $bold(x)$ to itself, i.e. $phi.alt(bold(x)) = bold(x)$, meaning that it indeed has a "fixed point".

In relation to the correction-based criterion from the earlier discussion, we know if we had no improvements, the algorithm terminates and returns a solution. For such an iteration to be of any use for our root-finding problem, its fixed points must coincide exactly with the roots of $bold(F)$, expressed as follows:

#definition("Consistency of fixed-point iteration.")[

$
bold(F)(xv) = bold(0) <=> phi.alt(xv) = xv
$

]

=== Existence and Uniqueness of the Fixed-Point for Contractive Mapping

We have seen that for fixed-point iterations, we rely heavily on the assumption that provided an iteration map $phi.alt$, there is a fixed-point associated with it. But when do we have the guarantee that such a fixed-point actually exist, if an arbitrary mapping $phi.alt$ is handed to us?

Therefore, we need to carefully examine the mapping itself. An important property we can examine is called the *contractivity*. We say a mapping $phi.alt: Omega subset.eq RR^(d) -> Omega$ is a contraction, if we consider two arbitrary elements $bold(x), bold(y) in Omega$ such that under application of $phi.alt$, the results $phi.alt(bold(x)), phi.alt(bold(y))$ have a closer distance than that before the mapping. The following definition abstract this idea and use a factor $L$ to allow more quantitative description of relation between these distances before and after mapping.

#definition("Contraction.")[

A function $phi.alt$ is a contraction if exists $L < 1$, such that

$
norm(phi.alt(xv) - phi.alt(yv)) <= L norm(xv - yv), quad forall xv, yv
$

]

To see why this helps, suppose $xv^(star)$ is a fixed-point of a contraction $phi.alt$. Substituting $xit(k+1) = phi.alt(xit(k))$ and $xv^(star) = phi.alt(xv^(star))$ into the contraction estimate, we obtain

$
norm(xit(k+1) - xv^(star)) = norm(phi.alt(xit(k)) - phi.alt(xv^(star))) <= L norm(xit(k) - xv^(star))
$

Notice that the error shrinks by at least a factor $L < 1$ at each step, so the iterates converge to $xv^(star)$.#sidenote[Recall that the convergence rate is referring to that of the sequence for iterative methods, not the same as the algebraic/exponential convergence of errors that we introduced earlier.] In case of a contractive iteration map, we fortunately have a guarantee for existence, and even uniqueness of such a fixed-point as given by the *Banach fixed-point theorem*:

#theorem("Banach fixed-point theorem.")[

Let $Omega subset RR^(d)$ a closed set, and assume $phi.alt: Omega -> Omega$ is a contraction. Then there exists an unique fixed-point $xv^(star)$, such that $phi.alt(xv^(star)) = xv^(star)$. It is the limit of the sequence $xit(k+1) = phi.alt(xit(k))$.
]
