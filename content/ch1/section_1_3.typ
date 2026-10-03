#import "../_site.typ": section, defbox, example, mat, vec, matlines, python, cblue, cred

#let meta = (id: "rechnen-mit-matrizen", title: "1.3 Rechnen mit Matrizen")

#show: section.with(meta)

== #meta.title


===  Cost of Basic Linear-Algebra Operations

In general, we consider vector 


1. Dot product ($bold(x), bold(y) in RR^(n)$)
- No. multiplications: $n$
- No. additions: $n - 1$

$
bold(x)^(T) bold(y) = mat(x_(1), dots, x_(n)) vec(y_(1), dots.v, y_(n))
$

2. Outer product ($bold(x) in RR^(m), bold(y)in RR^(n)$)
- No. multiplications: $m dot n$
- No. additions: $0$

$
bold(x)bold(y)^(T) = vec(x_(1), dots.v, x_(m)) mat(y_(1), dots, dots, y_(n))
$

3. Matrix-vector multiplication ($bold(A) in RR^(m, n)$, $bold(x) in RR^(n)$)
- No. multiplications: $m n$
- No. additions: $m (n - 1)$

$
bold(A) bold(x) = 
mat(
a_(1 1), dots, a_(1 n);
dots.v, dots.down, dots.v;
a_(m 1), dots, a_(m n);
) vec(x_(1), dots.v, x_(n))
$

4. Matrix-matrix multiplication ($bold(A) in RR^(m , n), bold(B) in RR^(n , k)$)
- No. multiplications: $n m k$
- No. additions: $(n - 1) m k$

$
bold(A) bold(B) = mat(
a_(1 1), dots, a_(1 n);
dots.v, dots.down, dots.v;
a_(m 1), dots, a_(m n);
) mat(
b_(1 1), dots, b_(1 k);
dots.v, dots.down, dots.v;
b_(n 1), dots, b_(n k);
)
$


=== Special Matrices

#example("Inspecting the structure of a matrix with `plt.spy`")[
To inspect the structure of a matrix

#python("Visualizing structures of a matrix.")[
```python
import numpy as np
import matplotlib.pyplot as plt

n = 100
A = np.diag(np.mgrid[:n])
A[:, -1] = A[-1, :] = np.mgrid[:n]
plt.spy(A)
plt.spy(A[::-1, :])
plt.spy(np.dot(A, A))
# plt.spy(np.dot(A, B))
```
]

]

1. Arrowhead matrix
2. Upper/Lower triangular matrix
3. Diagonal matrix
4. Rank-1 matrix $bold(a)bold(b)^(T)$
5. Kronecker product of two matrices ($bold(A) ⊗ bold(B)$)



#defbox("Kronecker product.")[ The Kronecker product $bold(A) ⊗ bold(B)$ of
two matrices $bold(A) in RR^(m, n)$ and $bold(B) in RR^(l, k)$, with $m, n, l, k in NN$, is
the $(m l) times (n k)$-dimensional matrix,

$
bold(A) ⊗ cblue(bold(B)) := 
mat(
  a_(1 1) cblue(bold(B)), dots, a_(1 n) cblue(bold(B));
  dots.v, dots.down, dots.v;
  a_(m 1) cblue(bold(B)), dots, a_(m n) cblue(bold(B));
) in RR^(m l, n k)
$

]


#example("Kronecker product of two 2 x 2 matrices")[
To see an example,

$
bold(A) = mat(1, 2;
3, 4), quad cblue(bold(B)) = mat(0, 5;
6, 7)
$

#matlines(cols: "solid", rows: "solid")[
$
bold(A) ⊗ cblue(bold(B)) =
mat(
  1 cblue(bold(B)), 2 cblue(bold(B));
  3 cblue(bold(B)), 4 cblue(bold(B));
  augment: #(vline: 1, hline: 1, stroke: 0.6pt + gray)
)
$
]

#matlines(cols: "none solid none", rows: "none solid none")[
$
= mat(
  0, 5, 0, 10;
  6, 7, 12, 14;
  0, 15, 0, 20;
  18, 21, 24, 28;
  augment: #(vline: 2, hline: 2, stroke: 0.6pt + gray)
)
$
]

]


// === Tricks for reducing complexity

// For all $KK$-matrices $bold(A), bold(B), bold(C)$ of compatible sizes, $alpha, beta in KK$, the following properties are fundamental in linear algebra:
// - associative 
// $
// (bold(A)bold(B))bold(C)= bold(A) (bold(B) bold(C))
// $

// - bilinear
// $
// (alpha bold(A) + beta bold(B)) bold(C) &= alpha (bold(A)bold(C)) + beta (bold(B)bold(C))\
// bold(C)(alpha bold(A)+beta bold(B))&= alpha (bold(C)bold(A)) + beta (bold(C)bold(B))
// $
// - non-commutative, it #text(fill: red, [does not], weight:"bold") hold in general that:
// $
// cred(bold(A)bold(B) != bold(B)bold(A))
// $
