#import "../_site.typ": section, slidebreak, ip, definition, lemma, theorem, example, thought, admonition, proof, figure-img, sidenote, cblue, cred, conj, boxeq, divider, anchor, anchor-ref, colive

#let meta = (id: "diskrete-fouriertransformation", title: "3.2 Diskrete Fouriertransformation")

#show: section.with(meta)

== #meta.title

=== Motivation: From Approximation to Interpolation#sidenote[Gradinaru, 3.2.1 "Motivation: von der Approximation zur Interpolation"]

The Fourier coefficients of a given function $f in L^(2)(0,1)$ can be computed by,

$
hat(f)(k) = integral^(1)_(0) f(t) e^(-2 pi i k t) d t
$


#example("A first example of approximating smooth integral by the trapezoidal rule")[
To evaluate such an integral numerically we replace it by a finite sum, i.e. a *quadrature rule*. The simplest is the trapezoidal rule, approximating one interval by a single trapezoid:

$
integral^(b)_(a) f(t) d t approx frac(b - a, 2) (f(a) + f(b))
$

#figure-img(
  "content/ch3/Trapezoidal_rule_illustration.svg.webp",
  "The trapezoidal rule approximates the integral by the area of a trapezoid",
  width: 40%,
  credit: [Image Source: #link("https://en.wikipedia.org/wiki/Trapezoidal_rule")[Wikipedia, "Trapezoidal rule"].],
)[
  The integral is approximated by the area under the straight line connecting the endpoints $(a, f(a))$ and $(b, f(b))$.
]

]

#slidebreak()

#example("Composite trapezoidal rule over an equidistant interval")[

Let us take a step further and split the interval $I = [a, b]$ into $N$ equal subintervals of width $h = (b - a) slash N$, with equidistant nodes $x_(0), dots, x_(N)$.

#figure-img(
  "content/ch3/Composite_trapezoidal_rule_illustration.png",
  "The composite trapezoidal rule approximates the integral by a chain of trapezoids over equidistant nodes",
  width: 50%,
  credit: [Image Source: #link("https://commons.wikimedia.org/wiki/File:Composite_trapezoidal_rule_illustration.png")[Wikimedia Commons, "Composite trapezoidal rule illustration"].],
)[
  Composite trapezoidal rule.
]

Then the integral over $I = [a,b]$ can be equivalently written as a sum of integrals over the small subintervals $[x_(j-1), x_(j)]$,

$
integral^(b)_(a) f(t) d t = sum^(N)_(j = 1) underbrace(integral^(x_(j))_(x_(j-1)) f(t) d t, (star))
$

Now we apply the *trapezoidal rule* to each small term $(star)$ -- every subinterval has the same width $h$ -- and sum them up,

$
integral^(b)_(a) f(t) d t
&approx sum^(N)_(j = 1) frac(h, 2) (f(x_(j-1)) + f(x_(j))) \
&= frac(h, 2) (f(x_(0)) + 2 f(x_(1)) + 2 f(x_(2)) + dots.c + 2 f(x_(N-1)) + f(x_(N))).
$

Each interior node $x_(1), dots, x_(N-1)$ is shared by two neighbouring trapezoids and is therefore counted twice, while the two endpoints $x_(0)$ and $x_(N)$ appear only once. Factoring out $h$ gives the *composite trapezoidal rule*,

$
integral^(b)_(a) f(t) d t approx h (frac(1, 2) f(x_(0)) + f(x_(1)) + dots.c + f(x_(N-1)) + frac(1, 2) f(x_(N))), quad h = frac(b - a, N).
$

]

#slidebreak()

If we assume the interval $I = [0,1]$ is discretized into $N$ distinct equidistant nodes, denoted as $cred(t_(l)) = l / N$ with $l = 0, 1, dots, N -1$, and the funtion $f$ to integrate over is $1$-periodic, the following composite trapezoidal rule can be used to approximate the smooth integral by a finite sum,


#anchor("eq-trap")[#boxeq[
$
integral^(1)_(0) g(t) d t approx frac(1, N) sum^(N-1)_(ell = 0) g(t_(ell)), quad t_(ell) = frac(ell, N)
$
]]

#slidebreak()

By applying the trapezoidal rule with $g(t) := f(t) e^(-2 pi i k t)$ substituted, we obtain#sidenote[This is equation $(3.2.16)$ in script p.71.]

$
hat(f)(k) 
&= integral^(1)_(0) f(t) e^(-2 pi i k t) d t \
&approx frac(1, N) sum^(N-1)_(l = 0) f(cred(t_(l))) e^(-2  pi i k cred(t_(l))) \
&=^(cred(t_(l)= l/N)) frac(1, N) sum^(N-1)_(l = 0) f(cred(frac(l, N))) e^(-2  pi i k cred(frac(l, N))) \
&=^(colive(omega_(N)^(k l) := e^(2 pi i k frac(l, N)))) frac(1, N) sum^(N-1)_(l  = 0) f(cred(frac(l, N))) conj(colive(omega^(k l)_(N))) \
&:= hat(f)_(N)(k)
$


In the last step, we introduce the notion $omega_(N)^(k l) := e^(2 pi i k frac(l, N))$ for the complex-valued term and summarize the term $e^(- 2 pi i k frac(l, N))$ using the complex conjugate. This notion is related to a number-theoretic concept called the *nth root of unity*, that are complex-valued solutions to the equality $z^(n) = 1$ for a fixed degree $n$.


#slidebreak()

==== nth Root of Unity

By the end of this section, we will leverage properties of $omega_(N)^(k l)$ to refactor expressions involving $hat(f)_(N)(k)$ into a recognizable formulation to establish its connection to the trigonometric polynomial.


#definition("nth Root of Unity.")[ For a positive integer $n in NN$, a complex number $z in CC$ is called an $n$th root of unity if and only if
$
z^(n) = 1
$
]

#slidebreak()

We may see the above equation as a complex-valued polynomial $p(z) := z^(n) - 1 in CC[z]$. For a fixed degree $n in NN$, we expect exactly $n$ complex roots, counted with multiplicity#sidenote[The *fundamental theorem of algebra* guarantees $n$ roots counted with multiplicity; that these roots are in fact *distinct* is shown in the proof below.]. An important property is that such roots are equidistant on the unit circle, as shown below in the animation with an increasing degree $n$:

#figure-img(
  "content/ch3/rootsu.gif",
  "The N-th roots of unity distributed on the unit circle in the complex plane",
  width: 35%,
  credit: [Image Source: #link("https://mathworld.wolfram.com/RootofUnity.html")[Wolfram MathWorld, "Root of Unity"].],
)[
  The $n$th roots of unity, denoted as $omega_(n)^(k), quad k = 0, dots, n-1$ are equally spaced on the unit circle. #linebreak() Summing them over a full cycle cancels to zero unless $j equiv 0 space (mod n)$.
]

#slidebreak()

To distinguish from the real-valued roots, let us use $omega_(n)^(k) in CC$ to denote the complex-valued roots. The following formula allows us to directly compute the *nth root(s) of unity* by,

#boxeq[
$
omega_(n)^(k) = e^(i frac(2 pi k, n)) = exp(i frac(2 pi k, n)), quad k = 0, 1, dots, n-1
$
]

#slidebreak()

#proof(title: [Proof of the $n$th-root formula.], boxed: true)[

For $n = 1$ the only solution is $z = 1$, which satisfies the formula. We may therefore consider $n in NN, n >= 2$.

Recall that a complex number in polar coordinates is written as $z = r e^(i cblue(theta))$. Since $abs(z)^(n) = abs(z^(n)) = 1$ and $abs(z) >= 0$, we have $r = abs(z) = 1$, so the root lies on the unit circle and $z = e^(i cblue(theta))$.

$
z^n &= 1\
<=> (e^(i cblue(theta)))^(n) &= 1 \
<=> e^(i cblue(theta) n) &= 1 \
<=> cos(cblue(theta)n) + i sin(cblue(theta)n) &= 1.
$

For the left-hand-side to equal to $1$, we conclude by matching real and imaginary part respectively that it must hold $cos(cblue(theta)n) = 1$ and $sin(cblue(theta)n) = 0$, which is the case when the angle $cblue(theta)n$ is a full multiple of $2 pi$. This holds if and only if, for some $k in ZZ$,

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

#slidebreak()

#example("nth roots of unity for " + $n = 1, 2, 3, 4$)[

- *$n = 1$*, for $z^(1) = 1$ the only root is $omega_(1)^(0) = 1$
#divider()
- *$n = 2$*, for $z^(2) = 1$, there are two distinct roots given by the formula

$
omega_(2)^(k) = exp(frac(2 k pi i, 2)) = exp(k pi i)
$

For $k = 0, 1$ the two roots are $omega_(2)^(0) = 1, quad omega_(2)^(1) = e^(pi i) = -1$.

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

#slidebreak()

#example("Properties of nth root of unity")[
The following properties of roots of unity are of our interest, whose proofs we omit here but can be found in the script#sidenote[See "Bemerkung 3.3.2".]:

1. *$n$-periodicity* (3.2.11). For a fixed degree $n in NN$, there are only $n$ distinct roots, thus the $(k + n)$-th root is identical to the $k$-th root.//#sidenote[This lets us reindex a DFT sum freely modulo $n$ -- the key step behind `fftshift`, which relabels the upper half of the spectrum as negative frequencies.]
   #boxeq[$ omega_(n)^(k + n) = omega_(n)^(k), quad forall k in ZZ. $]

2. *Special values* (3.2.13), (3.2.14). By its definition, the $n$th power of a root returns to $1$. In addition, if $n in NN$ is even, then $omega_(n)^(n slash 2) = -1$.
   #boxeq[$ omega_(n)^(n) = 1, quad omega_(n)^(n slash 2) = -1 quad (n "even"). $]

3. *Orthogonality* (3.2.15). For $j in ZZ$, summing the powers $omega_(n)^(k j) = (omega_(n)^(k))^(j)$ over $k = 0, dots, n-1$ cancels to $0$ unless $j equiv 0 space (mod n)$:
   #boxeq[$ sum^(n-1)_(k = 0) omega_(n)^(k j) = cases(n quad &"if" j equiv 0 space (mod n), 0 quad &"else.") $]

If $j equiv 0$, each term within the summation is $(omega_(n)^(k))^(0) = 1$, thus they sum to $n$. Otherwise, the geometry on the unit circle intuitively shows such powers cancel out and the sum is $0$.#sidenote[Or algebraically derive the formula by using a geometric series, as shown in the lecture note.]

]

#slidebreak()

==== Establishing Relation to Interpolation

Recall at the beginning of this section, we apply the composite trapezoidal rule and approximate the Fourier coefficient $hat(f)(k) = integral^(1)_(0) f(t) e^(-2 pi i k t) d t$ as

$
cblue(hat(f)(k) approx frac(1, N) sum^(N-1)_(j = 0) f(frac(j,N)) e^(-2 pi i k frac(j, N)))
$

Now, if we use this *approximate Fourier coefficient* $hat(f)(k)$ in the expression of a *trigonometric polynomial* of degree $N-1$#sidenote[Since we have $N$ equidistant nodes.]. Recall its expression in general is,

$
p_(n)(t) = sum^(m)_(k = - m) hat(f)_(n)(k) e^(2 pi i k t)
$

#slidebreak()

Let us evaluate the polynomial at the nodes, which we previously introduced as $t_(l) = frac(l, N)$,

$
p_(N-1)(t_(l)) 
&= p_(N-1)(frac(l, N)) \
&= sum^(frac(N, 2) - 1)_(k = - frac(N, 2)) cblue(hat(f)_(N)(k)) e^(2 pi i k frac(l, N))\
&= sum^(frac(N, 2) - 1)_(k = - frac(N, 2)) cblue(( frac(1, N) sum^(N-1)_(j = 0) f(frac(j,N)) e^(-2 pi i k frac(j, N)) )) e^(2 pi i k frac(l, N))\
&= cblue(frac(1, N)sum^(N-1)_(j = 0) f(frac(j, N))) sum^(N/2 - 1)_(k = -N/2) cblue(e^(-2 pi i k frac(j, N)))e^(2 pi i k frac(l, N)) \
&= cblue(frac(1, N)sum^(N-1)_(j = 0) f(frac(j, N))) sum^(N/2 - 1)_(k = -N/2) omega_(N)^(k(l - j))
$

In the last step we swapped the summations and collected the two exponentials back into $omega_(N)^(k(l - j))$. Now, we apply  the *orthogonality* property (3.2.15) of $n$th root of unity to the summation term, since $omega_(N)^(k(l - j))$ is $N$-periodic in $k$, summing it over the $N$ indices $k = -N/2, dots, N/2 - 1$ gives

$
sum^(N/2 - 1)_(k = -N/2) omega_(N)^(k(l - j)) = cases(
N quad &"if" (l - j) equiv 0 space (mod N),
0 quad &"else."
)
$

#slidebreak()

For $l, j in {0, dots, N-1}$ the condition $(l - j) equiv 0 space (mod N)$ holds only when $j = l$, so only that single term survives,

$
p_(N-1)(t_(l)) = cblue(frac(1, N)) dot cblue(f(frac(l, N))) dot N = f(t_(l))
$

Overall, we proved that

#boxeq[
$
p_(N-1)(t_(l)) = f(t_(l)), quad forall t_(l) = frac(l, N), l = 0, 1, dots, N-1
$
]

#slidebreak()

=== - 3.2.4 
🚧 Next week! :D
