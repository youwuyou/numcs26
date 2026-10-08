#import "../_site.typ": section, python, admonition, thought, defbox, definition, axiom, lemma, theorem, proof, course-example, example, anchor, anchor-ref, figure-img, page-ref, sidenote, slidebreak, cblue, corange, cred

#let meta = (id: "rundungsfehler", title: "1.1 Rundungsfehler und Fehlerpropagation")

#show: section.with(meta)

== #meta.title

#thought("From infinite to finite in numerical mathematics.")[
Mathematical analysis often relies on the _ideal_ concept of *"infinity"*. For example, series may involve the addition of infinitely many terms, and limiting arguments underlie the basic theory of differentiation and integration. Real numbers also require infinitely many digits for an exact decimal representation.

In numerical mathematics, however, we are constrained by the _realistic_ limitations of the *"finite"*. For example, since a program must terminate, an infinite series used to compute a quantity has to be truncated and therefore becomes an approximation. Moreover, only finite precision representations of real numbers are possible in computers.
]

#slidebreak()

=== Roundoff Errors

The set of real numbers $RR$ is *closed under elementary arithmetic operations* $star in {+, -, times, \/}$, meaning that for
$x, y in RR$#sidenote[In the case of division we require $y != 0$, since the multiplicative inverse only exists for nonzero elements.], the result is again in $RR$,

$
x star y in RR
$

However, denote the set of machine numbers as $cal(M)$. In general, we may have for both $x, y in cal(M)$

$
x star y in.not cal(M)
$

For example, although both $1$ and $10$ are representable in $cal(M)$, their division $1 / 10 = 0.1 in.not cal(M)$#sidenote[Assume we use base $2$ for our machine number representation. To represent $0.1$ we would need infinitely many digits, which is impossible with finite memory. See #link("https://www.exploringbinary.com/why-0-point-1-does-not-exist-in-floating-point/")["Why 0.1 Does Not Exist In Floating-Point"] if interested.].
As a result, a *rounding operation $"rd"(dot)$* is performed to approximate the result by mapping it to the closest representable machine number. The errors introduced in the rounding that are intrinsic to the finite precision of the machine-number set $cal(M)$ are called the *roundoff errors*.


#slidebreak()


==== Floating-Point Representation of Real Numbers


#defbox("Floating-point representation")[

A floating-point representation of real numbers is defined by four values $(B, m, e_(min), e_(max))$, where the parameters are:
- a base $cblue(B) in NN$ with $cblue(B) > 1$
- an exponent range $E := {e_(min), dots, e_(max)} subset ZZ$
- a precision $corange(m) in NN$, i.e. the number of mantissa digits

]


A floating-point number is always "signed", we highlight this with a "$plus.minus$" at front. For a normalized representation, the first digit in the "mantissa" is never zero:

#anchor("eq-normalized-form")[
$
x = plus.minus 0.underbrace(square square dots dots square, corange(m "-digit mantissa")) dot cblue(B)^e
$
]


#slidebreak()

#example("Relation to 'scientific notation' in base " + $cblue(B = 10)$)[

The "scientific notation" is closely related to this format.

Consider the exact value of the Avogadro constant $N_(A) = 6.02214076 times 10^(23)$ (in unit $"mol"^(-1)$). By moving the decimal point one place to the left, the exponent becomes $e = 24$, and the number takes the #anchor-ref("eq-normalized-form")[form]:

$
N_(A) = +0.underbrace(6 0 2 2 1 4 0 7 6, corange(9 "digits")) dot cblue(10)^(24)
$

We may also represent a negative value of the elementary charge for an electron, $q_e = -1.602176634 times 10^(-19)$ (in unit $"C"$). In the same representation, with exponent $e = -18$,

$
q_e = -0.underbrace(1 6 0 2 1 7 6 6 3 4, corange(10 "digits")) dot cblue(10)^(-18)
$

The minimal floating-point system that represents both constants exactly is given by $(cblue(B), corange(m), e_(min), e_(max)) = (cblue(10), corange(10), -18, 24)$.
]

#slidebreak()

#example("Extremal magnitudes in base " + $cblue(B = 10)$)[

Let $(cblue(B), corange(m), e_(min), e_(max)) = (cblue(10), corange(10), -18, 24)$ and $x != 0$ denotes a normalized *positive* floating-point number in this system.

The largest positive number fills all mantissa digits with $B - 1 = 9$, and uses $e_(max) = 24$ as exponent,

$
x_(max)
&= +0.underbrace(9 9 9 9 9 9 9 9 9 9, corange(10 "digits")) dot cblue(10)^(24)\
&= (1 - cblue(10)^(-10)) dot cblue(10)^(24)
$

The smallest positive normalized number has first mantissa digit $1$, all remaining mantissa digits $0$, and uses $e_(min) = -18$ as exponent,

$
x_(min)
&= +0.underbrace(1 0 0 0 0 0 0 0 0 0, corange(10 "digits")) dot cblue(10)^(-18)\
&= cblue(10)^(-1) dot cblue(10)^(-18) \
&= cblue(10)^(-19)
$

]

#slidebreak()

In general, the largest and smallest *positive* number in $cal(M)$ are given by
$
x_(max) &= (1 - cblue(B)^(-corange(m))) dot cblue(B)^(e_(max))\
x_(min) &= cblue(B)^(e_(min)-1)
$

In the illustration we see an example distribution of machine numbers, each $x in cal(M)$ is represented as a red dot. We shall notice there are only finitely many machine numbers, and all other numbers in the "gap" must be rounded to the closest machine number to be represented in a computer.

#figure-img("content/ch1/non-normalized-near-zero.png", "Spacing of machine numbers near zero", width: 92%)[
  The nonnegative half of the real line, with machine numbers as a discrete subset. #linebreak() Within a fixed exponent the numbers are equidistant.
]

#slidebreak()

=== Error Propagation

The errors in number representation are typically very small in magnitude, and thus for most of our investigation they are negligible, unless they accumulate or get magnified. We will focus on understanding a special case called the *cancellation* to see how *relative errors* may propagate in simple arithmetic operations.

Let us first formally define two different types of errors.

#defbox("Relative and absolute error.")[Let $tilde(bold(x)) in RR^n$ be an approximation of $bold(x) in RR^n$, and let $norm(dot): RR^(n) -> RR_(>=0)$ be a norm on $RR^n$. We introduce:
1. Absolute error

$
norm(tilde(bold(x)) - bold(x))
$
2. Relative error ($bold(x)!= bold(0)$)

$
norm(tilde(bold(x)) - bold(x))/norm(bold(x))
$
]

$->$ in this section, we may just consider the scalar values in $RR$ ($n = 1$) and take the absolute value as the norm $abs(dot)$.

#slidebreak()

==== Cancellation
The *cancellation* is the phenomenon that relative errors are amplified when two nearly equal numbers are subtracted from one another. 

#figure-img("content/ch1/cancellation-illustration.png", "Cancellation when subtracting two nearly equal numbers", width: 38%)[
  Here the parts colored in red denote absolute errors in the representation of two positive numbers. #linebreak() We see extreme amplification of relative errors in the result of subtraction.
]

Therefore, we want to be able to *identify whether an analytic formula is affected* and if possible, use some tricks to *avoid cancellations* before implementing the formula numerically. In the following, we examine important examples mentioned in class.


#slidebreak()

#example("Roots of a quadratic polynomial")[

The roots of $p(x) = a x^2 + b x + c$ are
$
x_(1,2) = (-b plus.minus sqrt(b^2 - 4 a c)) / (2 a).
$

This formula is affected by cancellation especially when $b^(2) >> 4 a c$, such that the square root term is dominated by $sqrt(b^(2) - 4 a c) approx abs(b)$. Depending on the sign of $b$, exactly one of the two roots then subtracts two nearly equal numbers in its numerator. 

*To avoid this*, we always first compute the root whose numerator _adds_ two terms of equal sign, so that no cancellation occurs,

$
x_1 = cases(
  (-b - sqrt(b^2 - 4 a c)) / (2 a) & "if " b >= 0\,,
  (-b + sqrt(b^2 - 4 a c)) / (2 a) & "if " b < 0\,,
)
$
then recover the other root from *Vieta's formula* $x_1 x_2 = c \/ a$,
$
x_2 = c / (a x_1).
$
]

#slidebreak()

#example("Exponential function via its power series")[

The exponential function has the power series
$
exp(x) = sum_(n=0)^infinity x^n / n! .
$

For $x < 0$, substituting $a = -x > 0$, the terms alternate in sign and cancellation is present,
$
exp(x) = exp(-a) = 1 - a + a^2 / 2! - a^3 / 3! + dots.c.
$

*To avoid this*, we sum the series only for $x >= 0$ and recover negative arguments from#sidenote[Since $exp(x) exp(-x) = 1$.] the identity
$
exp(x) = 1 / exp(-x) .
$

For example, to compute $exp(-15)$ we instead sum the all-positive series for $exp(15)$ and take the reciprocal.

$
exp(-15) = 1 / exp(15) = 1 / (1 + 15 + 15^2 / 2! + dots.c)
$

We see the above formula does not contain subtraction anymore.
]

#slidebreak()

#example("Derivative via a difference quotient")[

The derivative of a differentiable function $f: I subset RR -> RR$ at $x in I$ is a limit of difference quotients. As an approximation, the following *forward difference* formula is used, however, it is also affected by cancellation:
$
f'(x) approx (f(x + h) - f(x)) / h quad "for" abs(h) << 1 .
$

*To avoid this*, we can perform differentiation on the complex plane $CC$. Intuitively, the idea is to take the step $h$ into the imaginary direction instead of along the real axis, which is expressed by an increment by $i h$. The formula that is free of cancellations is given by

$
f'(x) = (op("Im") f(x + i h)) / h + O(h^2) .
$

However, this method is applicable only to real-analytic functions $f$ that are locally represented by a convergent power series.#sidenote[The full derivation is given in the lecture script, where taking the imaginary part makes the real terms drop out thanks to $i^(2) = -1$.]

]