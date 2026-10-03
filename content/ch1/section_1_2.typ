#import "../_site.typ": section, python, admonition, thought, defbox, definition, axiom, lemma, theorem, proof, course-example, example, anchor, anchor-ref, figure-img, page-ref, sidenote, slidebreak, cblue, corange, cred, idea

#let meta = (id: "rechenaufwand", title: "1.2 Rechenaufwand")

#show: section.with(meta)

== #meta.title

The *asymptotic complexity* of an algorithm characterizes the *worst-case* dependence of the #underline([computational effort])
to run the algorithm, when #underline([problem size parameter(s)]) tend to $infinity$. 

#slidebreak()

=== Big-O Notation

Let $f: NN -> RR$ denote a function that takes the problem size parameter $n$ and outputs the time or space requirements of an algorithm. We want to provide an upper-bound on $f(n)$ by taking another *benchmark function* $g: NN -> RR$, and use it as a reference. #sidenote[In particular, polynomial functions $g(n) = n^(p)$, exponential function $g(n) = c^(n), c > 1$ or factorial $g(n) = n!$ are well-known functions whose growths are well-studied, and thus suitable to take as a reference.] If we fixed a reference function, we can capture all functions that can be bounded by $g$ by the following set#sidenote[Some definitions use the $abs(f)$ in their set predicate, here since $f(n)$ represents size or time which are nonnegative, we omit it.]:

$
O(g) := {f : NN -> RR | exists C >0, exists n_(0) in NN, forall n >= n_(0), f(n) <= C dot g(n) }
$

#slidebreak()

Intuitively, a function $f in O(g)$ can be characterized by another function $g$ if after scaling, for all $n in NN$ parameters after a fixed threshold $n_(0)$, its function values lie below $C dot g(n)$.


#figure-img(
  "content/ch1/BigO.png",
  "Big-O notation",
  width: 30%,
  credit: [Image Source: #link("https://www.maniuk.net/2019/06/introduction-in-big-o-notation.html")["Introduction in Big-O Notation"].],
)[
  The asymptotic growth of $f$ is bounded above by $c g(n)$, once $n >= n_(0)$.
]

#slidebreak()

In the script, the following definition was introduced. Note that instead of writing $f in O(g)$, we write $f(n) = O(g)$. This is commonly used, yet mathematically it is a small "abuse of notation".

#defbox("Big-O Notation.")[ For functions $F, G : NN -> RR$, written as

$
F(n) = O(G(n))
$

If there is a constant $C > 0$ and a $n_(0) in NN$, such that

$
F(n) <= C dot G(n) quad forall n >= n_(0)
$
]

#slidebreak()

=== Sharpness

Note that the above definition leaves a lot of freedom. In particular, one may choose an extremely bad benchmark function $g$ for stating meaningless bounds. For example, an algorithm that runs with linear complexity $O(n)$ can be correctly labelled as possessing $O(n!)$ complexity.

To avoid this, we will always use the tightest bound possible. This is what we meant with the *sharpness* of a complexity bound. #sidenote[In fact, we could have introduced the notation of $Omega(g)$, which characterizes the *lower-bound* instead. And then express sharpness by the class $Theta(g) = O(g) inter Omega(g)$. This is a widely used notation in theoretical computer science.]

#slidebreak()

=== Little-$o$ Notation

In addition, there is also the little-$o$ notation. It is stricter than the big-$O$ bound as it requires $f$ to be upper-bounded by scaled $C dot g$ for all possible constant $forall C > 0$, not just $exists C > 0$ as in the above definition.#sidenote[In script it is stated that how little-$o$ and big-$O$ differs is its use of parameter $n -> infinity$ or $h -> 0$, which is imprecise.] For example, this notation occurs when expressing the *approximation error* when approximating a function $f$ with its Taylor polynomial. But note that their definitions imply

$
o(g) subset O(g)
$

Therefore our course resorts to another small abuse of notation and use $O(g)$ although $o(g)$ is meant occasionally.