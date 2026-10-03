#import "../_site.typ": section, admonition, defbox, example, python, slidebreak, cblue, cred

#let meta = (id: "serie-01-bridge", title: "Serie 01: Bridge Notes")

#show: section.with(meta)

== #meta.title

These notes are meant as a compact bridge between Sections 1.1--1.3 and the CodeExpert exercises of Serie 01.

=== 1. Derivative by Forward Difference and Imaginary Step

Let $f : RR -> RR$ be the restriction of a sufficiently smooth function that can be evaluated at complex arguments near $x$. Taylor expansion gives

$
f(x + h) = f(x) + h f'(x) + frac(h^2, 2) f''(x) + cal(O)(h^3).
$

Therefore the first-order difference quotient is

$
D_"fw"(h) := frac(f(x+h) - f(x), h)
       = f'(x) + frac(h, 2) f''(x) + cal(O)(h^2).
$

The truncation error is proportional to $h$, but the numerator subtracts two almost equal floating-point numbers when $h$ is small. A useful mental model for the total error is

$
abs(D_"fw"(h) - f'(x)) approx C_1 h + C_2 frac("eps", h).
$

So the error first decreases, then increases again once roundoff dominates.

#slidebreak()

For the imaginary-step method, expand in the imaginary direction:

$
f(x + i h)
&= f(x) + i h f'(x) + frac((i h)^2, 2) f''(x)
   + frac((i h)^3, 6) f'''(x) + cal(O)(h^4) \
&= f(x) + i h f'(x) - frac(h^2, 2) f''(x)
   - i frac(h^3, 6) f'''(x) + cal(O)(h^4).
$

Taking imaginary parts removes the real terms:

$
D_"cs"(h) := frac("Im"(f(x+i h)), h)
       = f'(x) - frac(h^2, 6) f'''(x) + cal(O)(h^4).
$

There is no subtraction of nearly equal real numbers. This is why the imaginary-step method can often use very small $h$ without the usual cancellation wall.

#admonition("warning", "When complex step applies")[
The function must accept complex input and must not discard imaginary parts internally. For example, `np.sin`, `np.exp`, and polynomial expressions work. A function using `abs`, comparisons, `max`, or branches depending on the sign of the input may not be complex analytic.
]

#python("Forward difference versus complex step")[
```python
import numpy as np
import matplotlib.pyplot as plt

def diff_forward(f, x, h):
    return (f(x + h) - f(x)) / h

def diff_complex_step(f, x, h):
    return np.imag(f(x + 1j * h)) / h

tests = [
    (np.exp, np.exp, 1.0, "exp(x) at x=1"),
    (np.sin, np.cos, 1.0, "sin(x) at x=1"),
]

h0 = 1.0
levels = 60
hs = h0 * 0.5 ** np.arange(levels)

plt.figure(figsize=(8, 5))
for f, df, x, label in tests:
    exact = df(x)
    err_fw = [abs(diff_forward(f, x, h) - exact) for h in hs]
    err_cs = [abs(diff_complex_step(f, x, h) - exact) for h in hs]

    # Plot at most 25 points per method and function, as requested in CodeExpert.
    idx = np.linspace(0, levels - 1, 25, dtype=int)
    plt.loglog(hs[idx], np.array(err_fw)[idx], "o-", label=f"forward, {label}")
    plt.loglog(hs[idx], np.array(err_cs)[idx], "s-", label=f"complex, {label}")

plt.gca().invert_xaxis()
plt.xlabel("step size h")
plt.ylabel("absolute error")
plt.grid(True, which="both")
plt.legend()
plt.show()
```
]

#slidebreak()

=== 2. Central Difference and Richardson Acceleration

The centered difference quotient is

$
D_0(h) := frac(f(x+h) - f(x-h), 2h).
$

Taylor expansion around $x$ gives

$
f(x+h) &= f(x) + h f'(x) + frac(h^2, 2) f''(x)
       + frac(h^3, 6) f'''(x) + cal(O)(h^4), \
f(x-h) &= f(x) - h f'(x) + frac(h^2, 2) f''(x)
       - frac(h^3, 6) f'''(x) + cal(O)(h^4).
$

Subtracting cancels the even powers:

$
D_0(h) = f'(x) + c_2 h^2 + c_4 h^4 + c_6 h^6 + dots.
$

The leading truncation error is order $h^2$.

#slidebreak()

Richardson extrapolation removes the leading error term. Since

$
D_0(h) &= f'(x) + c_2 h^2 + c_4 h^4 + dots, \
D_0(h/2) &= f'(x) + c_2 frac(h^2, 4) + c_4 frac(h^4, 16) + dots,
$

the combination

$
D_1(h/2) := D_0(h/2) + frac(D_0(h/2) - D_0(h), 4 - 1)
$

cancels the $c_2 h^2$ term and has error $cal(O)(h^4)$.

More generally, build a triangular table. With $h_k = h_0 / 2^k$,

$
R_(k,0) &= D_0(h_k), \
R_(k,j) &= R_(k,j-1) + frac(R_(k,j-1) - R_(k-1,j-1), 4^j - 1),
quad j = 1, dots, k.
$

The last entry of row $k$ is the best extrapolated value available after using steps $h_0, h_1, dots, h_k$.

#python("Centered difference and Richardson table")[
```python
import numpy as np

def diff_central(f, x, h):
    return (f(x + h) - f(x - h)) / (2 * h)

def diff_richardson(f, x, h0=1.0, max_iter=30, rtol=1e-12, atol=1e-14):
    table = []

    for k in range(max_iter):
        h = h0 * 0.5 ** k
        row = [diff_central(f, x, h)]

        for j in range(1, k + 1):
            improved = row[j - 1] + (row[j - 1] - table[k - 1][j - 1]) / (4**j - 1)
            row.append(improved)

        table.append(row)

        if k > 0:
            estimate = abs(table[k][k] - table[k - 1][k - 1])
            threshold = atol + rtol * abs(table[k][k])
            if estimate <= threshold:
                return table[k][k], estimate, k + 1, table

    return table[-1][-1], abs(table[-1][-1] - table[-2][-2]), max_iter, table

value, err_est, steps, table = diff_richardson(np.exp, 1.0)
print(value, "estimated error:", err_est, "rows:", steps)
print("exact:", np.exp(1.0))
```
]

#python("Error plot for central difference and Richardson")[
```python
import numpy as np
import matplotlib.pyplot as plt

f = np.sin
df = np.cos
x = 1.0
exact = df(x)

h0 = 1.0
levels_central = 50
levels_richardson = 20

hs_c = h0 * 0.5 ** np.arange(levels_central)
err_c = [abs(diff_central(f, x, h) - exact) for h in hs_c]

rich_values = []
rich_h = []
table = []
for k in range(levels_richardson):
    h = h0 * 0.5 ** k
    row = [diff_central(f, x, h)]
    for j in range(1, k + 1):
        row.append(row[j - 1] + (row[j - 1] - table[k - 1][j - 1]) / (4**j - 1))
    table.append(row)
    rich_h.append(h)
    rich_values.append(row[-1])

err_r = [abs(v - exact) for v in rich_values]

plt.figure(figsize=(8, 5))
plt.loglog(hs_c, err_c, "o-", label="central difference")
plt.loglog(rich_h, err_r, "s-", label="Richardson")
plt.gca().invert_xaxis()
plt.xlabel("step size h")
plt.ylabel("absolute error")
plt.grid(True, which="both")
plt.legend()
plt.show()
```
]

#slidebreak()

=== 3. Multiplication with a Diagonal Matrix

Let $D = "diag"(d_1, dots, d_n)$ and $x in RR^n$. Direct matrix-vector multiplication gives

$
(D x)_i = sum_(j=1)^n D_(i j) x_j.
$

But all off-diagonal entries vanish. Hence

$
(D x)_i = d_i x_i.
$

So the dense method does about $n^2$ scalar checks/multiplications and stores $n^2$ numbers, while the structured method uses only $n$ multiplications and stores only the vector $d$.

#python("Diagonal matrix: dense versus structured")[
```python
import numpy as np
import matplotlib.pyplot as plt

def diag_dense(d, x):
    return np.diag(d) @ x

def diag_structured(d, x):
    return d * x

ns = np.array([2**k for k in range(4, 12)])
t_dense = []
t_struct = []

for n in ns:
    rng = np.random.default_rng(0)
    d = rng.normal(size=n)
    x = rng.normal(size=n)

    assert np.allclose(diag_dense(d, x), diag_structured(d, x))

    t_dense.append(time_min(lambda: diag_dense(d, x)))
    t_struct.append(time_min(lambda: diag_structured(d, x)))

plt.figure(figsize=(8, 5))
plt.loglog(ns, t_dense, "o-", label="np.diag(d) @ x")
plt.loglog(ns, t_struct, "s-", label="d * x")
plt.loglog(ns, t_dense[0] * (ns / ns[0])**2, "k--", label="$O(n^2)$")
plt.loglog(ns, t_struct[0] * (ns / ns[0]), "k:", label="$O(n)$")
plt.xlabel("n")
plt.ylabel("time (s)")
plt.grid(True, which="both")
plt.legend()
plt.show()
```
]

#slidebreak()

=== 4. Upper Part of a Low-Rank Matrix

Assume a matrix $A in RR^(n times n)$ has rank at most $r$ and is represented as

$
A = U V^T,
quad U,V in RR^(n times r).
$

The upper triangular part $T = "triu"(A)$ satisfies

$
T_(i j) = cases(
  A_(i j), & j >= i,
  0, & j < i.
)
$

For $y = T x$ we get

$
y_i
&= sum_(j=i)^n A_(i j) x_j \
&= sum_(j=i)^n sum_(ell=1)^r U_(i ell) V_(j ell) x_j \
&= sum_(ell=1)^r U_(i ell) underbrace(sum_(j=i)^n V_(j ell) x_j)_("suffix sum").
$

The inner sum is a suffix sum over the rows of $V * x$. Once these suffix sums are known, each $y_i$ costs only $r$ multiplications.

#python("Upper triangular part of a low-rank matrix")[
```python
import numpy as np
import matplotlib.pyplot as plt

def upper_lowrank_dense(U, V, x):
    A = U @ V.T
    return np.triu(A) @ x

def upper_lowrank_structured(U, V, x):
    # W[j, ell] = V[j, ell] * x[j]
    W = V * x[:, None]

    # S[i, ell] = sum_{j=i}^{n-1} W[j, ell]
    S = np.cumsum(W[::-1, :], axis=0)[::-1, :]

    # y[i] = sum_ell U[i, ell] * S[i, ell]
    return np.sum(U * S, axis=1)

ns = np.array([2**k for k in range(5, 12)])
r = 5
t_dense = []
t_struct = []

for n in ns:
    rng = np.random.default_rng(1)
    U = rng.normal(size=(n, r))
    V = rng.normal(size=(n, r))
    x = rng.normal(size=n)

    assert np.allclose(upper_lowrank_dense(U, V, x),
                       upper_lowrank_structured(U, V, x))

    t_dense.append(time_min(lambda: upper_lowrank_dense(U, V, x), repeat=3))
    t_struct.append(time_min(lambda: upper_lowrank_structured(U, V, x), repeat=3))

plt.figure(figsize=(8, 5))
plt.loglog(ns, t_dense, "o-", label="form triu(U @ V.T) @ x")
plt.loglog(ns, t_struct, "s-", label="suffix sums")
plt.loglog(ns, t_dense[0] * (ns / ns[0])**2, "k--", label="$O(n^2)$")
plt.loglog(ns, t_struct[0] * (ns / ns[0]), "k:", label="$O(n r)$ for fixed r")
plt.xlabel("n")
plt.ylabel("time (s)")
plt.grid(True, which="both")
plt.legend()
plt.show()
```
]

#slidebreak()

=== 5. Multiplication with a Kronecker Product

Let $A in RR^(m times n)$, $B in RR^(p times q)$, and $K = A ⊗ B$. Then $K$ has size $(m p) times (n q)$. Forming $K$ explicitly can be much more expensive than applying it.

With NumPy's default row-major reshape convention, let

$
x = "reshape"(X), quad X in RR^(n times q).
$

The row index of $K$ is the pair $(i_A, i_B)$ and the column index is $(j_A, j_B)$. Thus

$
((A ⊗ B) x)_(i_A, i_B)
&= sum_(j_A=1)^n sum_(j_B=1)^q
   A_(i_A j_A) B_(i_B j_B) X_(j_A j_B) \
&= (A X B^T)_(i_A, i_B).
$

Therefore

$
(A ⊗ B) x = "reshape"(A X B^T).
$

For square $n times n$ factors, explicit multiplication with $A ⊗ B$ costs order $n^4$, while the reshaped formula uses two ordinary matrix multiplications of order $n^3$.

#python("Kronecker product: explicit versus reshape identity")[
```python
import numpy as np
import matplotlib.pyplot as plt

def kron_dense(A, B, x):
    return np.kron(A, B) @ x

def kron_structured(A, B, x):
    n = A.shape[1]
    q = B.shape[1]
    X = x.reshape(n, q)          # row-major convention
    Y = A @ X @ B.T
    return Y.reshape(-1)

# Correctness check on a nonsquare case.
rng = np.random.default_rng(2)
A = rng.normal(size=(3, 4))
B = rng.normal(size=(2, 5))
x = rng.normal(size=A.shape[1] * B.shape[1])
assert np.allclose(kron_dense(A, B, x), kron_structured(A, B, x))

ns = np.array([2**k for k in range(2, 8)])
t_dense = []
t_struct = []

for n in ns:
    rng = np.random.default_rng(3)
    A = rng.normal(size=(n, n))
    B = rng.normal(size=(n, n))
    x = rng.normal(size=n * n)

    assert np.allclose(kron_dense(A, B, x), kron_structured(A, B, x))

    t_dense.append(time_min(lambda: kron_dense(A, B, x), repeat=3))
    t_struct.append(time_min(lambda: kron_structured(A, B, x), repeat=3))

plt.figure(figsize=(8, 5))
plt.loglog(ns, t_dense, "o-", label="np.kron(A, B) @ x")
plt.loglog(ns, t_struct, "s-", label="reshape: A @ X @ B.T")
plt.loglog(ns, t_dense[0] * (ns / ns[0])**4, "k--", label="$O(n^4)$")
plt.loglog(ns, t_struct[0] * (ns / ns[0])**3, "k:", label="$O(n^3)$")
plt.xlabel("factor size n")
plt.ylabel("time (s)")
plt.grid(True, which="both")
plt.legend()
plt.show()
```
]

#slidebreak()

=== 6. Efficient Construction of a Vandermonde Matrix

For nodes $x_0, dots, x_n$ and degree at most $m$, the increasing-order Vandermonde matrix is

$
V =
mat(
1, x_0, x_0^2, dots, x_0^m;
1, x_1, x_1^2, dots, x_1^m;
dots.v, dots.v, dots.v, dots.down, dots.v;
1, x_n, x_n^2, dots, x_n^m
).
$

The naive formula recomputes powers independently:

$
V_(i j) = x_i^j.
$

But powers satisfy the recurrence

$
V_(i,0) = 1,
quad
V_(i,j+1) = V_(i,j) x_i.
$

So after the first column, each new column is obtained from the previous one by one elementwise multiplication.

#python("Three Vandermonde constructors")[
```python
import numpy as np

def vander_loop(x, degree):
    V = np.empty((len(x), degree + 1), dtype=float)
    V[:, 0] = 1.0
    for j in range(1, degree + 1):
        V[:, j] = V[:, j - 1] * x
    return V

def vander_cumprod(x, degree):
    V = np.empty((len(x), degree + 1), dtype=float)
    V[:, 0] = 1.0
    if degree > 0:
        repeated_x = np.broadcast_to(x[:, None], (len(x), degree))
        V[:, 1:] = np.cumprod(repeated_x, axis=1)
    return V

def vander_numpy(x, degree):
    return np.vander(x, N=degree + 1, increasing=True)

x = np.linspace(-1.0, 1.0, 8)
degree = 5

V1 = vander_loop(x, degree)
V2 = vander_cumprod(x, degree)
V3 = vander_numpy(x, degree)

assert np.allclose(V1, V2)
assert np.allclose(V1, V3)
```
]

#python("Benchmark Vandermonde construction")[
```python
import numpy as np
import matplotlib.pyplot as plt

ns = np.array([2**k for k in range(5, 13)])
t_loop = []
t_cumprod = []
t_numpy = []

for n in ns:
    x = np.linspace(-1.0, 1.0, n)
    degree = n - 1

    t_loop.append(time_min(lambda: vander_loop(x, degree), repeat=3))
    t_cumprod.append(time_min(lambda: vander_cumprod(x, degree), repeat=3))
    t_numpy.append(time_min(lambda: vander_numpy(x, degree), repeat=3))

plt.figure(figsize=(8, 5))
plt.loglog(ns, t_loop, "o-", label="column recurrence loop")
plt.loglog(ns, t_cumprod, "s-", label="np.cumprod")
plt.loglog(ns, t_numpy, "^-", label="np.vander")
plt.loglog(ns, t_numpy[0] * (ns / ns[0])**2, "k--", label="$O(n^2)$ entries")
plt.xlabel("number of nodes n")
plt.ylabel("time (s)")
plt.grid(True, which="both")
plt.legend()
plt.show()
```
]

#admonition("note", "What to remember")[
The Vandermonde matrix has $(n)(m+1)$ entries, so constructing all entries cannot be asymptotically cheaper than $cal(O)(n m)$. The goal is to avoid slow Python work per entry and avoid recomputing powers from scratch.
]
