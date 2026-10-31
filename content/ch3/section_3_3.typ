#import "../_site.typ": section, slidebreak, boxeq, definition, example

#let meta = (id: "fft-schnelle-fourier-transformation", title: "3.3 – 3.4 FFT & Trigonometrische Interpolation und rechentechnische Aspekte")

#show: section.with(meta)

== #meta.title

// The former §3.4 is folded into this panel. Keep its anchor alive so old deep
// links and `#sec("3.4")` (via the registry in _refs.typ) still land here.
#context { if target() == "html" { html.div(id: "trigonometrische-interpolation-und-rechentechnische-aspekte") } }

Section 3.2 gave us the DFT as the matrix-vector product $c = F_(N) y$. This section answers the next question: how expensive is this product, and why do libraries compute it so quickly?

The structure is simple. First we count the cost of the direct formula. Then we split one DFT into two smaller DFTs. Repeating that split gives the fast Fourier transform (FFT). At the end we record one standard use case: convolution and polynomial multiplication.

=== Direct Evaluation

==== The Direct Formula

#example("Naive DFT")[
The DFT is a matrix-vector product,

$
c = F_(N) y,
quad
c_(k) = sum_(j = 0)^(N - 1) y_(j) omega_(N)^(j k).
$

If we compute this formula directly, then for every output coefficient $c_(k)$ we sum over all $N$ input values. Since there are $N$ coefficients, the naive algorithm needs $cal(O)(N^2)$ operations.
]

The FFT avoids this cost by reusing smaller DFTs. The key idea is to split the input into even and odd indices.

#slidebreak()

=== Divide and Conquer

==== Split into Even and Odd Entries

#example("Even-odd splitting")[
Assume first that $N = 2 n$. For the $k$th DFT coefficient,

$
c_(k)
&= sum_(j = 0)^(N - 1) y_(j) omega_(N)^(j k) \
&= sum_(j = 0)^(n - 1) y_(2 j) omega_(N)^(2 j k)
 + sum_(j = 0)^(n - 1) y_(2 j + 1) omega_(N)^((2 j + 1) k).
$

Since $omega_(N)^2 = omega_(n)$, this becomes

#boxeq[
$
c_(k)
= sum_(j = 0)^(n - 1) y_(2 j) omega_(n)^(j k)
+ omega_(N)^k sum_(j = 0)^(n - 1) y_(2 j + 1) omega_(n)^(j k).
$
]

The first sum is the DFT of the even entries $y_(0), y_(2), dots, y_(N - 2)$. The second sum is the DFT of the odd entries $y_(1), y_(3), dots, y_(N - 1)$, multiplied by the factor $omega_(N)^k$. These extra factors are often called *twiddle factors*.
]

#slidebreak()

==== Reuse the Two Half-Size DFTs

#example("Combining two smaller DFTs")[
Let

$
E_(k) := sum_(j = 0)^(n - 1) y_(2 j) omega_(n)^(j k),
quad
O_(k) := sum_(j = 0)^(n - 1) y_(2 j + 1) omega_(n)^(j k).
$

Because $E_(k)$ and $O_(k)$ are $n$-periodic in $k$, the two halves of the length-$N$ DFT are obtained from the same two length-$n$ DFTs:

#boxeq[
$
c_(k) &= E_(k) + omega_(N)^k O_(k), \
c_(k + n) &= E_(k) - omega_(N)^k O_(k),
quad k = 0, dots, n - 1.
$
]

Thus one DFT of length $N$ is reduced to two DFTs of length $N slash 2$, plus $cal(O)(N)$ work for the final combinations.
]

#slidebreak()

=== Cost of the FFT

==== Recurrence

Repeating this split gives the recurrence

$
T(N) = 2 T(frac(N, 2)) + cal(O)(N).
$

For $N = 2^ell$, this yields

#boxeq[
$
T(N) = cal(O)(N log N).
$
]

This is the FFT. In matrix form, the same idea says that, after reordering the input into even and odd entries, the large Fourier matrix can be factored into two smaller Fourier matrices and a diagonal matrix of twiddle factors. The algorithm is therefore not a new transform; it is a fast way to apply the same DFT.

#slidebreak()

==== Library Use

In Python, this is the algorithm hidden behind `numpy.fft`:

$
c = op("fft")(y),
quad
y = op("ifft")(c).
$

For the exercises we will use these routines directly. The important point is conceptual: whenever a problem can be written in terms of DFTs, the FFT often turns an $cal(O)(N^2)$ computation into an $cal(O)(N log N)$ one. This is exactly the computational tool we will use in the later interpolation sections, where we evaluate and manipulate trigonometric interpolants through their coefficients.

#slidebreak()

=== Application: Cyclic Convolution

==== Polynomial Multiplication Pattern

#example("Cyclic convolution via the FFT")[
One standard example is convolution. For $a, b in CC^N$, their cyclic convolution is

#definition("Cyclic Convolution.")[
$
(a op("⊛") b)_(k)
:= sum_(j = 0)^(N - 1) a_(j) b_((k - j) space mod space N),
quad k = 0, dots, N - 1.
$
]

The Fourier transform turns cyclic convolution into pointwise multiplication:

#boxeq[
$
a op("⊛") b
= F_(N)^(-1) (op("diag")(F_(N) a) F_(N) b).
$
]

In words: transform both vectors, multiply componentwise, and transform back. With the FFT this costs $cal(O)(N log N)$ instead of forming all sums directly.

The same idea gives the usual fast multiplication of polynomials. We pad the coefficient vectors with zeros so that no cyclic wrap-around occurs, evaluate both polynomials at roots of unity with the FFT, multiply the values pointwise, and apply the inverse FFT to recover the coefficients of the product.
]

#slidebreak()

=== Trigonometrische Interpolation und rechentechnische Aspekte

🚧 Under construction.

==== Wiederholung (3.4.1)

- [TODO]: Recap the discrete Fourier approximation and the `fftshift` reordering (Bemerkung 3.4.1, Bemerkung 3.2.11), and computing the coefficients (Code 3.4.2).

==== Auswertung: Zero-Padding (3.4.2)

- *[TODO]: Evaluate the trig interpolant at $N' > N$ points by zero-padding the coefficient vector and applying the inverse FFT (Code 3.4.3--3.4.4; ex01 `evaliptrig` evaluates at $N$ reference points, the reference solution uses the equivalent direct sum).*
- [TODO]: Note the cost advantage of the FFT route over the direct sum.
