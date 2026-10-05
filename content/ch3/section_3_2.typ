#import "../_site.typ": section, slidebreak, ip, definition, lemma, theorem, example, thought, admonition, proof, figure-img, sidenote, cblue, cred, conj, boxeq, divider, anchor, anchor-ref

#let meta = (id: "diskrete-fouriertransformation", title: "3.2 Diskrete Fouriertransformation")

#show: section.with(meta)

== #meta.title

=== Motivation: From Approximation to Interpolation#sidenote[Gradinaru, 3.2.1 "Motivation: von der Approximation zur Interpolation"]

To motivate this section, consider a function $f in L^(2)(0, 1)$, i.e. a $1$-periodic signal of finite energy. #text(fill: red)[Its *Fourier series* (synthesis) reconstructs $f$ from coefficients given by the *analysis* integral:]

$
cred(f(t) = sum_(k in ZZ) hat(f)(k) e^(2 pi i k t)), quad cred(hat(f)(k) = integral^(1)_(0) f(t) e^(-2 pi i k t) d t).
$

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

On the $N$ equidistant nodes $t_(ell) = ell slash N$, $ell = 0, dots, N-1$, this becomes the *composite* rule. #text(fill: red)[It assigns half-weights to the two endpoints, but since $g$ is $1$-periodic they coincide ($g(0) = g(1)$) and merge into one full weight, so every sample carries the same weight $1 slash N$ -- the *periodic trapezoidal rule*:]#sidenote[For a $1$-periodic $g$ the composite rule $frac(1, N)[frac(1, 2) g(t_0) + g(t_1) + dots.c + g(t_(N-1)) + frac(1, 2) g(t_N)]$ has $g(t_0) = g(t_N)$, merging the two half-weights into one full weight $1 slash N$.]

#anchor("eq-trap")[#boxeq[
$
cred(integral^(1)_(0) g(t) d t approx frac(1, N) sum^(N-1)_(ell = 0) g(t_(ell))), quad cred(t_(ell) = frac(ell, N)).
$
]]

Applying the #anchor-ref("eq-trap")[periodic trapezoidal rule] to $g(t) = f(t) e^(-2 pi i k t)$ turns the coefficient integral into the *discrete coefficient* $hat(f)_(N)(k)$ computed by the DFT:

#anchor("eq-dft-coeff")[#boxeq[
$
cred(hat(f)(k) = integral^(1)_(0) f(t) e^(-2 pi i k t) d t approx frac(1, N) sum^(N - 1)_(ell = 0) f(t_(ell)) e^(-2 pi i k t_(ell)) =: hat(f)_(N)(k).)
$
]]


#thought("Relating approximation and interpolation")[
#text(fill: red)[These coefficients do more than *approximate*: the trigonometric polynomial built from them *interpolates* $f$ at the nodes $t_(ell) = ell slash N$. With $N$ coefficients against $N$ nodes the system is square, pinning them down uniquely. We prove this under _Establishing Relation to Interpolation_ below, once the $n$th roots of unity are in hand.]

]


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

We now prove the claim previewed above: the polynomial built from the #anchor-ref("eq-dft-coeff")[discrete coefficients] $hat(f)_(N)(k)$ *interpolates* $f$ at the nodes $t_(ell) = ell slash N$.

#text(fill: red)[First we fix signs. The roots above run counterclockwise ($e^(+2 pi i k slash n)$), but the DFT uses the *clockwise* root matching the $e^(-2 pi i k t)$ of the analysis integral:]

#boxeq[
$
cred(w_(N) := e^(+2 pi i slash N)) quad cred(omega_(N) := conj(w_(N)) = e^(-2 pi i slash N)).
$
]

#text(fill: red)[The synthesis matrix $bold(V)$ is built from $w_(N)$; its conjugate $omega_(N)$ drives the forward DFT $bold(F)_(N) = bold(V)^(H)$ and the coefficients $hat(f)_(N)(k)$, so every DFT sum is a power $omega_(N)^(k j)$ of this one root.] Assuming $N$ even, the trigonometric polynomial

$
cred(p_(N)(t) = sum^(frac(N, 2) - 1)_(k = -frac(N, 2)) hat(f)_(N)(k) e^(2 pi i k t))
$

interpolates $f$ at the nodes $t_(ell) = ell slash N, ell = 0, 1, dots, N-1$.

#proof(title: [Proof of the interpolation property.])[

Substitute the coefficients $hat(f)_(N)(k)$ into $p_(N)$, evaluate at a node $t_(ell) = ell slash N$, and swap the order of summation. With $e^(2 pi i k t_(ell)) = omega_(N)^(-k ell)$,

$
cred(p_(N)(t_(ell)))
&= cred(sum^(frac(N, 2) - 1)_(k = -frac(N, 2)) hat(f)_(N)(k) omega_(N)^(-k ell)) \
&= cred(frac(1, N) sum^(N-1)_(j = 0) f(t_(j)) underbrace(sum^(frac(N, 2) - 1)_(k = -frac(N, 2)) omega_(N)^(k (j - ell)), = thin N "if" j = ell", else" 0)).
$

By *orthogonality* (3.2.15) the inner sum equals $N$ exactly when $j = ell$ and vanishes otherwise, so only the term $j = ell$ survives:#sidenote[Discrete analogue of $#ip($e^(2 pi i k t)$, $e^(2 pi i j t)$) = delta_(k j)$: the roots of unity form an orthogonal basis, which is what makes the DFT invertible.]

#boxeq[
$
cred(p_(N)(t_(ell)) = frac(1, N) dot f(t_(ell)) dot N = f(t_(ell)).)
$
]
]

#example("Interpolation as inverting the DFT matrix")[

#text(fill: red)[Interpolation amounts to inverting a Vandermonde matrix. Sampling the polynomial]

$
P(x) = p_0 + p_1 x + p_2 x^2 + dots.c + p_(N-1) x^(N-1)
$

at the nodes $x_(k) = w_(N)^(k)$ gives the values $P(w_(N)^(k))$, and recovering the coefficients inverts the Vandermonde matrix:

$
vec(p_0, p_1, p_2, dots.v, p_(N-1))
=
mat(
1, 1, 1, dots.c, 1;
1, w_(N), w_(N)^2, dots.c, w_(N)^(N-1);
1, w_(N)^2, w_(N)^4, dots.c, w_(N)^(2(N-1));
dots.v, dots.v, dots.v, dots.down, dots.v;
1, w_(N)^(N-1), w_(N)^(2(N-1)), dots.c, w_(N)^((N-1)(N-1));
)^(-1)
vec(P(w_(N)^0), P(w_(N)^1), P(w_(N)^2), dots.v, P(w_(N)^(N-1))).
$

#text(fill: red)[Here $bold(V) = (w_(N)^(j k))$ is the synthesis matrix, with inverse $bold(V)^(-1) = frac(1, N) bold(V)^(H) = frac(1, N) bold(F)_(N)$ where $bold(F)_(N) = (omega_(N)^(j k))$ -- the clockwise root reappears.]

]



==== Numerical Representation

#text(fill: red)[A computer stores $f$ only as the sample vector $bold(y) = (f(t_0), dots, f(t_(N-1)))$. The $L^(2)$-inner product of Section 3.1 then has a discrete counterpart on $CC^(N)$,]

$
cred(ip(bold(x), bold(y))_(N) = frac(1, N) sum^(N-1)_(j = 0) conj(y_(j)) x_(j),)
$

#text(fill: red)[under which the DFT matrix $bold(F)_(N)$ is, up to scaling, *unitary* -- the discrete analogue of Parseval's identity.]


// === Numerics: Discrete Representation

// So far everything was continuous. On a computer, however, the inner product

// $
// #ip($f$, $g$)_(L^2(0,1)) = integral_0^1 overline(g(t)) f(t) dif t
// $

// is defined through an *integral* — so the natural question is: how do we represent such a "plain integral" on a computer?

// The idea is to approximate the integral by a quadrature rule. For the periodic setting the natural choice is the *trapezoidal rule*, and we assume from now on that we sample on *equidistant nodes* $x_j$.

// #text(fill: red)[*TODO (lecture):* write out the trapezoidal-quadrature step explicitly on the nodes $x_j$ and show how it turns the integral into a finite sum.]


=== - 3.2.4 
🚧 Under construction.

// #thought("Time and Frequency Domain (Bemerkung 3.2.8)")[
// ]


// $
// bold(F)_(N) = bold(V)^(H) = 

// mat(
// omega^(0)_(N), omega^(0)_(N), dots, omega^(0)_(N);
// omega^(0)_(N), omega^(1)_(N), dots, omega^(N-1)_(N);
// dots.v, dots.down, dots.down, dots.v;
// omega^(0)_(N), omega^(N-1)_(N), dots, omega^((N-1)^(2))_(N);
// )

// = (omega^(j k)_(N))^(N-1)_(j, k = 0) in CC^(N times N)
// $


// #definition("Discrete Fourier Transformation (DFT).")[



// $
// c_(k) = sum^(N-1)_(j = 0) y_(j) omega^(k j)_(N), quad k = 0, 1, dots, N-1
// $

// ]


// #example("Unitary")[

// $
// bold(F)^(-1)_(N) = 
// $

// ]

// #example("Shifting")[

// $
// frac(1, N) bold(F)_(N)bold(F)_(N) 
// vec(y_(0), y_(1), dots.v, y_(N-1)
// ) = 
// vec( y_(0), y_(N-1), dots.v y_(2), y_(1)
// )
// $

// #example("")[

// Eigenvalues ${1, -1, i, -i}$

// $
// frac(1, sqrt(N)) bold(F)_(N)
// $

// ]

// ]

// #slidebreak()


// === `fftshift` and First Applications
// - section 3.2.3


// - Forward FFT `c = np.fft.fft(y)`
// $
// bold(c) = bold(F)_(N) bold(y)
// $


// - Inverse FFT `y = np.fft.ifft(c)`
// $
// bold(y) = frac(1, N) bold(F)^(H)_(N) bold(c)
// $


// === Ein Blick aus der Perspective der Linearen Algebra
// - section 3.2.4
// - Definition 3.2.25 p. 82
// #definition("Circular Matrix.")[

// ]

// - diagonalisation of shift matrix $bold(S)_(N)$


// #lemma("")[

// $
// bold(S)_(N) = bold(U) bold(D) bold(U)^(H)
// $

// ]

// - theorem 3.2.27
// #theorem("gleichzeitige")[

// ]

// - Definition 3.2.28 Faltung
// #definition("Convolution")[

// ]


// === Discrete Fourier Transform

// #text(fill: red)[
// *TODO (open points to resolve before writing this section):*
// - Problem: the $N$-th root was introduced too abruptly, the connection is unclear.
// - periodicity — the proof is important.
// - geometric formula.
// - even / odd powers.
// ]
