#import "../_site.typ": section, cblue, corange, example, sidenote

#let meta = (id: "fft-schnelle-fourier-transformation", title: "3.3 – 3.4 FFT & Trigonometrische Interpolation und rechentechnische Aspekte")

#show: section.with(meta)

== #meta.title

// The former §3.4 is folded into this panel. Keep its anchor alive so old deep
// links and `#sec("3.4")` (via the registry in _refs.typ) still land here.
#context { if target() == "html" { html.div(id: "trigonometrische-interpolation-und-rechentechnische-aspekte") } }

=== Efficient Evaluation of Trigonometric Interpolants

With trigonometric interpolation, we approximate a function $f$ that is $1$-periodic, with $N$ even, by


$
p_(N-1)(t) = sum^(N/2 - 1)_(k = - N/2) cblue(hat(f)_(N)(k)) e^(2 pi i k t)
$

In the following example, we show a simplified case where the interpolation nodes and the evaluation points *coincide*. If the number of evaluation points, denoted as $M$, is larger than the number of interpolation nodes, i.e. $M > N$, then we would need to perform zero-padding, which is not needed in the procedures below.#sidenote[If $M > N$, the zeros are inserted in the middle of the coefficient vector, between the coefficients for $k >= 0$ and $k < 0$, and the result must be scaled by $M$ since `np.fft.ifft` divides by $M$.]


#example("First Step to Calculate the Fourier Coefficients " + $hat(f)_(N)(k)$)[
Note that the original Fourier coefficients $hat(f)(k)$ involve an evaluation of smooth integral, which we replace by an approximation using composite trapezoidal rule on equidistant nodes $t_(l) = l /N$ over an interval of length $1$. 

In the following, let us denote the function evaluations as  $y_(l) := f(l/N)$ and we introduce the $N$-th root of unity $omega_(N) := e^(-2 pi i / N)$, so that $omega^(k l)_(N) = e^(-2 pi i k frac(l, N))$, to simplify the writing,

$
hat(f)(k) approx
cblue(hat(f)_(N)(k))
&= cblue(frac(1, N) sum^(N-1)_(l = 0) f(l/N) e^(-2 pi i k frac(l, N))) =  cblue(frac(1, N) sum^(N-1)_(l =0 )y_(l) omega^(k l)_(N) ), quad forall k = 0, dots, N-1
$

Since $omega^((k+N) l)_(N) = omega^(k l)_(N)$, we have $hat(f)_(N)(k+N) = hat(f)_(N)(k)$, so the coefficients for $k = -N/2, dots, -1$ are the ones computed for $k = N/2, dots, N-1$. 

The equations above for approximation of all Fourier coefficients can be explicitly written out as follows

$
cblue(cases(
hat(f)_(N)(0) 
= frac(1, N) sum^(N-1)_(l = 0) y_(l) omega^(0)_(N),
quad quad quad quad dots.v, 
hat(f)_(N)(N-1) 
= frac(1, N) sum^(N-1)_(l = 0) y_(l) omega^((N-1) l)_(N) 
  
))
$

This can be equivalently written in the following matrix-vector format, with $bold(F)_(N) := (omega_(N)^( j k))_(j, k = 0)^(N-1) in CC^(N times N)$, the Fourier coefficients are product of the $bold(F)_(N) bold(y)$,


$
hat(bold(f))_(N) = frac(1, N) bold(F)_(N) bold(y)
$

]


#example("Second Step for the Full Evaluation with Another Inverse FFT")[
Substituting the $cblue(hat(f)_(N)(k))$ into the trigonometric polynomial, we have

$
p_(N-1)(frac(l, N)) 
&= sum^(N/2 - 1)_(k = - N/2) cblue(hat(f)_(N)(k)) e^(2 pi i k l/N) = sum^(N/2 - 1)_(k = - N/2) cblue(hat(f)_(N)(k)) overline(omega^( k l)_(N))
= sum^(N - 1)_(k = 0) cblue(hat(f)_(N)(k)) overline(omega^( k l)_(N))
$

where the last equality uses that both $hat(f)_(N)(k)$ and $overline(omega^(k l)_(N))$ are $N$-periodic in $k$, which is only true at the nodes $t = l/N$.

In other words, the evaluation of the trigonometric polynomial at equidistant nodes, denote $bold(p) := mat(p_(N-1)(0/N), dots, p_(N-1)((N-1)/N))^(T)$ in the following, can be computed by


$
bold(p)
&= overline(bold(F)_(N)) cblue(hat(bold(f))_(N)) 
= corange(overline(bold(F)_(N))) cblue((frac(1, N) bold(F)_(N) bold(y) )) 
$

To conclude, recall the scaled Fourier matrix $frac(1, sqrt(N)) bold(F)_(N)$ is unitary and $bold(F)_(N)$ is symmetric, meaning that $corange(bold(F)^(-1)_(N) = frac(1, N) overline(bold(F)_(N)))$, substituting it into the above formula gives $bold(p) = corange(bold(F)^(-1)_(N)) cblue((bold(F)_(N) bold(y) )) = bold(y)$.

Or in `numpy`, as `np.fft.ifft(np.fft.fft(y))`.
]

#divider()