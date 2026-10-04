#import "../_site.typ": section, slidebreak, ip, definition, lemma, theorem, example, thought, admonition, proof, figure-img, sidenote, cblue, cred, conj, boxeq, divider, anchor, anchor-ref

#let meta = (id: "diskrete-fouriertransformation", title: "3.2 Diskrete Fouriertransformation")

#show: section.with(meta)

== #meta.title

=== Motivation: From Approximation to Interpolation#sidenote[Gradinaru, 3.2.1 "Motivation: von der Approximation zur Interpolation"]

🚧 Under construction.

==== nth Root of Unity

#definition("nth Root of Unity.")[ For a positive integer $n in NN$, a complex number $z in CC$ is called an $n$th root of unity if and only if
$
z^(n) = 1
$
]

We may see the above equation as a complex-valued polynomial $p(z) := z^(n) - 1 in CC$. For a fixed degree $n in NN$, we expect to obtain exactly $n$ complex roots of it#sidenote[This is also called the *fundamental theorem of algebra*.]. An important property is that such roots are equidistant on the unit circle, as shown below in the animation with an increasing degree $n$:

#figure-img(
  "content/ch3/rootsu.gif",
  "The N-th roots of unity distributed on the unit circle in the complex plane",
  width: 35%,
  credit: [Image Source: #link("https://mathworld.wolfram.com/RootofUnity.html")[Wolfram MathWorld, "Root of Unity"].],
)[
  The $n$th roots of unity, denoted as $omega_(n)^(k), quad k = 0, dots, n-1$ are equally spaced on the unit circle. #linebreak() Summing them over a full cycle cancels to zero unless $j equiv 0 space (mod n)$.
]


To distinguish from the real-valued roots, let us use $omega_(n)^(k) in CC$ to denote the complex-valued roots. The following formula allows us to directly compute the *nth root(s) of unity* by,

#boxeq[
$
omega_(n)^(k) = e^(i frac(2 pi k, n)) = exp(i frac(2 pi k, n)), quad k = 0, 1, dots, n-1
$
]


#proof(title: [Proof of the $n$th-root formula.], boxed: true)[

For $n = 1$ the only solution is $z = 1$, which satisfies the formula. We may therefore consider $n in NN, n >= 2$.

Recall that a complex number in polar coordinates is written as $z = r e^(i cblue(theta))$. Here, $r = abs(1) = 1$, since $z^(n) =^(!) 1$ requires the root to lie on the unit circle. Hence $z = e^(i cblue(theta))$.

$
z^n &= 1\
<=> (e^(i cblue(theta)))^(n) &= 1 \
<=> e^(i cblue(theta) n) &= 1 \
<=> cos(cblue(theta)n) + cancel(i sin(cblue(theta)n)) &= 1.
$

For the left-hand-side to equal to $1$, we conclude by matching real and imaginary part respectively that it must hold $cos(cblue(theta)n) = 1$ and $sin(cblue(theta)n) = 0$, which is the case when the angle $cblue(theta)n$ is a full multiple of $2 pi$. Thus, by periodicity it holds for all $k in ZZ$

$
cblue(theta) n = 2 pi k <=>
cblue(theta) = cblue(frac(2 pi k, n)).
$


For $k = 0, 1, dots, n - 1$ the angles $cblue(theta) = cblue(frac(2 pi k, n))in [0, 2 pi)$ and are all distinct, this concludes that the formula below indeed gives $n$ distinct roots

#boxeq[
$
omega_(n)^(k) = e^(i cblue(theta)) = e^(i cblue(frac(2 pi k, n)) ) = exp(i cblue(frac(2 pi k, n))) = cos(cblue(frac(2 pi k, n))) + i sin(cblue(frac(2 pi k, n))).
$
]
]

#example("nth roots of unity for " + $n = 1, 2, 3, 4$)[

- *$n = 1$*, for $z^(1) = 1$ the only root is $omega_(1)^(0) = 1$
#divider()
- *$n = 2$*, for $z^(2) = 1$, there are two distinct roots given by the formula

$
omega_(2)^(k) = exp(frac(2 k pi i, 2)) = exp(k pi i)
$

plugging in index of the *$2$th roots of unity*, for $k = 0, 1$ the two roots are $omega_(2)^(0) = 1, quad omega_(2)^(1) = e^(pi i) = -1$.

#divider()
- *$n = 3$*, for $z^(3) = 1$, the formula gives

$
omega_(3)^(k) = exp(frac(2 k pi i, 3))
$ 

For $k = 0, 1, 2$, we have the three distinct roots

$
omega_(3)^(0) &= 1 \
omega_(3)^(1) &= cos(frac(2 pi, 3)) + i sin(frac(2 pi, 3)) = -frac(1, 2) + frac(sqrt(3), 2) i \
omega_(3)^(2) &= cos(frac(4 pi, 3)) + i sin(frac(4 pi, 3)) = -frac(1, 2) - frac(sqrt(3), 2) i
$
#divider()
- *$n = 4$*, for $z^(4) = 1$, $omega_(4)^(k) = exp(frac(2 k pi i, 4)) = exp(frac(k pi i, 2))$ for $k = 0, 1, 2, 3$:
$
omega_(4)^(0) = 1, quad omega_(4)^(1) = e^(pi i slash 2) = i, quad omega_(4)^(2) = e^(pi i) = -1, quad omega_(4)^(3) = e^(3 pi i slash 2) = -i.
$
]

#example("Properties of nth root of unity")[
The following properties of roots of unity are of our interest, whose proofs we omit here but can be found in the script#sidenote[See "Bemerkung 3.3.2".]:

1. *$n$-periodicity* (3.2.11). For a fixed degree $n in NN$, there are only $n$ distinct roots, thus the $(k + n)$-th root is identical as the $k$-th root.#sidenote[This lets us reindex a DFT sum freely modulo $n$ -- the key step behind `fftshift`, which relabels the upper half of the spectrum as negative frequencies.]
   #boxeq[$ omega_(n)^(k + n) = omega_(n)^(k), quad forall k in ZZ. $]

2. *Special values* (3.2.13), (3.2.14). By its definition, the $n$th power of a root returns to $1$. In addition, if $n in NN$ is an even number, the symmetry in roots distribution guarantees us the $z^(n/2) = -1$.
   #boxeq[$ omega_(n)^(n) = 1, quad omega_(n)^(n slash 2) = -1 quad (n "even"). $]

3. *Orthogonality* (3.2.15). If we interpret $omega_(n)^(k j)$ as $(omega_(n)^(k))^(j)$, in which we further raise a nth root of unity to some power $j in NN$.
   #boxeq[$ sum^(n-1)_(k = 0) omega_(n)^(k j) = cases(n quad &"if" j equiv 0 space (mod n), 0 quad &"else.") $]

If $j equiv 0$, each term within the summation is $(omega_(n)^(k))^(0) = 1$, thus they sum to $n$. Otherwise, the geometry on the unit circle intuitively shows such powers cancel out and the sum is $0$.#sidenote[Algebraically a geometric series: $sum_(k=0)^(n-1) (omega_(n)^(j))^(k) = frac(1 - omega_(n)^(j n), 1 - omega_(n)^(j)) = 0$ for $omega_(n)^(j) != 1$, since $omega_(n)^(j n) = 1$. This is the heart of the DFT: it gives $bold(F)_(N)^(H) bold(F)_(N) = N bold(I)$ and hence the inversion formula.]

]


==== Establishing Relation to Interpolation
🚧 Under construction.


=== - 3.2.4 
🚧 Under construction.
