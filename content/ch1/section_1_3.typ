#import "../_site.typ": section, defbox, example, mat, vec, matlines, ip, python, cblue, cred, cteal, sidenote, slidebreak, thought, divider

#let meta = (id: "rechnen-mit-matrizen", title: "1.3 Rechnen mit Matrizen")

#show: section.with(meta)

== #meta.title

=== Basic Operations and Their Cost

The following table#sidenote[It is taken from p.36. Since we consider real vectors, we use $bold(x)^(T)$ in the following. Similar reasoning proceed for $bold(x) in CC^(m)$ too, by transposing and then taking complex conjugate for $bold(x)^(H)$.] summarizes the costs of performing basic operations in dependence of dimension $m, n, p in NN$.

#context {
  // This page also builds a PDF (see `"pdf": true` in site.json), so the table
  // is emitted twice: an HTML `<table>` for the web, and a native Typst
  // `table` for print. `html.table` alone would error in the PDF target.
  let rows = (
    ([Scalar product], $bold(x), bold(y) in RR^n -> bold(x)^T bold(y)$, $n$, $n - 1$, $O(n)$),
    ([Tensor product], $bold(x) in RR^m, bold(y) in RR^n -> bold(x) bold(y)^T$, $m n$, $0$, $O(m n)$),
    ([Matrix-vector multiplication], $bold(x) in RR^n, bold(A) in RR^(m, n) -> bold(A) bold(x)$, $m n$, $(n - 1) m$, $O(m n)$),
    ([Matrix-matrix multiplication], $bold(A) in RR^(m, n), bold(B) in RR^(n, p) -> bold(A) bold(B)$, $m n p$, $(n - 1) m p$, $O(m n p)$),
  )
  let headers = ([Name], [Operation], [No. multiplications], [No. additions], [Komplexität])
  if target() == "html" {
    html.table(class: "content-table")[
      #html.thead[#html.tr[#for h in headers { html.th[#h] }]]
      #html.tbody[
        #for r in rows {
          html.tr[#for c in r { html.td[#c] }]
        }
      ]
    ]
  } else {
    align(center, table(
      columns: 5,
      align: (left, center, center, center, center),
      inset: 0.55em,
      stroke: 0.5pt + luma(180),
      table.header(..headers.map(h => strong(h))),
      ..rows.flatten(),
    ))
  }
}

#slidebreak()

Let us now examine the first two examples of the *scalar product* and *tensor product* between two vectors. It is important to understand them clearly, as this will allow us to directly apply the same pattern to analyze the complexity of #underline([matrix-vector multiplication]) and #underline[matrix-matrix multiplication].#sidenote[We should consider the scalar product and tensor product as special cases of the general matrix product.]

Here, we use a simplified notion to consider just real vectors and matrices but mirrored the complex-valued cases as in script p. 26-27.

#slidebreak()

==== Scalar product

For $bold(x), bold(y) in RR^(n)$, the scalar product computes a single number,

$
ip(bold(x), bold(y)) = bold(x)^(T)bold(y) = sum^(n)_(k = 1) x_(k) y_(k) in RR
$

To see the number of operations involved, it is easiest to see it in vectorial form,

$
bold(x)^(T) bold(y) = mat(x_(1), dots, x_(n)) vec(y_(1), dots.v, y_(n))
$

In all, we need to form no. $n$ multiplications, and no. $(n-1)$ additions to sum up each scalar.

#slidebreak()

==== Tensor product

For $bold(x) in RR^(m), bold(y) in RR^(n)$, the tensor product of them produces a matrix $bold(x)bold(y)^(T) in RR^(m, n)$ as follows,

$
bold(x)bold(y)^(T)
&= vec(x_(1), dots.v, x_(m)) mat(y_(1), dots, y_(n)) \
&=
mat(
x_(1)y_(1), dots, x_(1)y_(n);
dots.v, dots.down, dots.v;
x_(m)y_(1), dots, x_(m)y_(n);
)  in RR^(m, n)
$

Note that each of the entry in the resulting matrix is a single multiplication of $x_(i) y_(j)$. Overall, we have no. $m n$ multiplications and no. $0$ additions.

#slidebreak()

=== Structure of Matrices

==== Sparse Matrices

In this section, we review two types of sparse matrices. First, we define what is a *diagonal matrix*, and see how addition and multiplication of two diagonal matrices preserve the sparsity. Second, we introduce a *arrow matrix*, and will show the sparsity is only #underline[conditionally] preserved.

A #underline([diagonal matrix]) is a matrix in which the entries outside the main diagonal are all zero; the term usually refers to square matrices. The elements of the main diagonal can either be zero or nonzero.

#defbox("Diagonal matrix.")[
A square matrix $bold(D) = (d_(i j)) in RR^(n, n)$ is #underline([diagonal]) if all of its off-diagonal entries are zero.

$
"diag"(d_(1), dots, d_(n)) :=
mat(
  d_(1), , 0;
  , dots.down, ;
  0, , d_(n);
) in RR^(n, n), quad d_(j) in RR, quad j = 1, dots, n.
$
]

#example("Left multiplication by a diagonal matrix scales the rows.")[

For $bold(D) in RR^(n, n)$ diagonal and $bold(A) in RR^(n, m)$, left-multiplication scales the #underline([rows]) of $bold(A)$,

$
bold(D) bold(A)
&=
mat(
  cred(d_(1)), 0, dots, 0;
  0, cblue(d_(2)), dots, 0;
  dots.v, dots.v, dots.down, dots.v;
  0, 0, dots, cteal(d_(n));
)
mat(
  a_(1 1), a_(1 2), dots, a_(1 m);
  a_(2 1), a_(2 2), dots, a_(2 m);
  dots.v, dots.v, dots.down, dots.v;
  a_(n 1), a_(n 2), dots, a_(n m);
) \
&=
mat(
  cred(d_(1)) a_(1 1), cred(d_(1)) a_(1 2), dots, cred(d_(1)) a_(1 m);
  cblue(d_(2)) a_(2 1), cblue(d_(2)) a_(2 2), dots, cblue(d_(2)) a_(2 m);
  dots.v, dots.v, dots.down, dots.v;
  cteal(d_(n)) a_(n 1), cteal(d_(n)) a_(n 2), dots, cteal(d_(n)) a_(n m);
)\
&=
mat(
  cred(d_(1)) bold(A)_(1 comma :);
  cblue(d_(2)) bold(A)_(2 comma :);
  dots.v;
  cteal(d_(n)) bold(A)_(n comma :);
) in RR^(n, m),
$

where $bold(A)_(i comma :)$ denotes the $i$-th row of $bold(A)$.

]

#example("Right multiplication by a diagonal matrix scales the columns.")[

For $bold(A) in RR^(n, m)$ and $bold(D) in RR^(m, m)$ diagonal, right-multiplication scales the #underline([columns]) of $bold(A)$,

$
bold(A) bold(D)
&=
mat(
  a_(1 1), a_(1 2), dots, a_(1 m);
  a_(2 1), a_(2 2), dots, a_(2 m);
  dots.v, dots.v, dots.down, dots.v;
  a_(n 1), a_(n 2), dots, a_(n m);
)
mat(
  cred(d_(1)), 0, dots, 0;
  0, cblue(d_(2)), dots, 0;
  dots.v, dots.v, dots.down, dots.v;
  0, 0, dots, cteal(d_(m));
) \
&=
mat(
  cred(d_(1)) a_(1 1), cblue(d_(2)) a_(1 2), dots, cteal(d_(m)) a_(1 m);
  cred(d_(1)) a_(2 1), cblue(d_(2)) a_(2 2), dots, cteal(d_(m)) a_(2 m);
  dots.v, dots.v, dots.down, dots.v;
  cred(d_(1)) a_(n 1), cblue(d_(2)) a_(n 2), dots, cteal(d_(m)) a_(n m);
)\
&=
mat(
  cred(d_(1)) bold(A)_(: comma 1),
  cblue(d_(2)) bold(A)_(: comma 2),
  dots,
  cteal(d_(m)) bold(A)_(: comma m);
) in RR^(n, m),
$

where $bold(A)_(: comma j)$ denotes the $j$-th column of $bold(A)$.

]

#example("Matrix operations with diagonal matrices.")[

In the following, we denote $bold(A) := "diag"(a_(1), dots, a_(n)) in RR^(n, n)$ and $bold(B) := "diag"(b_(1), dots, b_(n)) in RR^(n, n)$ two diagonal matrices of the same dimension, then under addition and multiplication of both matrices, the result is again a diagonal matrix,

*1. Addition.* The corresponding diagonal entries are added,

$
mat(
  a_(1), , 0;
  , dots.down, ;
  0, , a_(n);
)
+
mat(
  b_(1), , 0;
  , dots.down, ;
  0, , b_(n);
)
=
mat(
  a_(1) + b_(1), , 0;
  , dots.down, ;
  0, , a_(n) + b_(n);
),
$

*2. Multiplication.* The corresponding diagonal entries are multiplied,

$
mat(
  a_(1), , 0;
  , dots.down, ;
  0, , a_(n);
)
mat(
  b_(1), , 0;
  , dots.down, ;
  0, , b_(n);
)
=
mat(
  a_(1) b_(1), , 0;
  , dots.down, ;
  0, , a_(n) b_(n);
).
$


*3. Inverse.* The diagonal matrix $"diag"(a_(1), dots, a_(n))$ is invertible if and only if the entries $a_(1), dots, a_(n)$ are all nonzero.


$
mat(
  a_(1), , 0;
  , dots.down, ;
  0, , a_(n);
)^(-1)
=
mat(
  a_(1)^(-1), , 0;
  , dots.down, ;
  0, , a_(n)^(-1);
).
$

]

2. Arrowhead matrix

#divider()


==== Upper & Lower Triangular Matrix

3. Upper/Lower triangular matrix

#divider()


#slidebreak()


==== Dense Matrices#sidenote[Bemerkung 1.3.15 in the script (p. 36).]

For a large dense matrix it is often convenient to regard it as a collection of smaller sub-matrices, or *matrix blocks*. Let us start with a matrix $bold(A) in RR^(M, N)$ and partition it into four blocks by splitting its rows into $M = a + c$ and its columns into $N = b + d$, where  $a, b, c, d in NN$.

#matlines(cols: "solid", rows: "solid")[
$
bold(A) = mat(
  bold(A)_(1 1), bold(A)_(1 2);
  bold(A)_(2 1), bold(A)_(2 2);
  augment: #(vline: 1, hline: 1, stroke: 0.6pt + gray)
) in RR^(M, N).
$
]


#slidebreak()


We can also partition a vector in the same manner, let $bold(x) in RR^(N)$, we can see it as a vertical stack its sub-vectors,

#matlines(rows: "solid")[
$
bold(x) = mat(bold(x)_(1); bold(x)_(2); augment: #(hline: 1, stroke: 0.6pt + gray)) in RR^(N),
$
]

here we picked the split to make $bold(x)_(1) in RR^(b), bold(x)_(2) in RR^(d)$ compatible to perform blockwise matrix-vector multiplication, as we show in the example below.


#slidebreak()


#example("Dimensions of submatrices.")[

Since each matrix block should inherit its dimensions from the split. For the above example, the dimension of each submatrix is given as,

$
bold(A)_(1 1) in RR^(a, b), & quad bold(A)_(1 2) in RR^(a, d), \
bold(A)_(2 1) in RR^(c, b), & quad bold(A)_(2 2) in RR^(c, d).
$
]


#slidebreak()


#example("Block matrix-vector multiplication.")[

For block matrix and vector of compatible dimensions, we can perform linear algebra operations as we are used to, but note that, now each entry consists of a sum of block products. We demonstrate an example below,

#matlines(cols: "solid | | ", rows: "solid | solid | solid")[
$
bold(A) bold(x)
= mat(
  bold(A)_(1 1), bold(A)_(1 2);
  bold(A)_(2 1), bold(A)_(2 2);
  augment: #(vline: 1, hline: 1, stroke: 0.6pt + gray)
)
mat(bold(x)_(1); bold(x)_(2); augment: #(hline: 1, stroke: 0.6pt + gray))
= mat(
  bold(A)_(1 1) bold(x)_(1) + bold(A)_(1 2) bold(x)_(2);
  bold(A)_(2 1) bold(x)_(1) + bold(A)_(2 2) bold(x)_(2);
  augment: #(hline: 1, stroke: 0.6pt + gray)
) in RR^(M).
$
]
]

#divider()

#slidebreak()


#underline([*Operations on Block Matrices*])

In the following, let us consider a concrete use case of the block matrices. In the lecture, we learned about the *Kronecker product* which is an operation on two matrices of arbitrary size resulting in a block matrix.

#defbox("Kronecker product. (Gradinaru, p. 39, 1.3.22)")[ The Kronecker product $bold(A) ⊗ bold(B)$ of
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


#slidebreak()


#example("Kronecker product " + $bold(A) ⊗ bold(B)$ + " of two 2×2 matrices")[
Let us see an example, consider $bold(A), cblue(bold(B)) in RR^(2, 2)$

$
bold(A) = mat(1, 2;
3, 4), quad cblue(bold(B)) = mat(0, 5;
6, 7)
$

To build the Kronecker product between the two matrices, we apply the definition,


#matlines(cols: "solid | none solid none", rows: "solid | none solid none")[
$
bold(A) ⊗ cblue(bold(B))
&=
mat(
  1 cblue(bold(B)), 2 cblue(bold(B));
  3 cblue(bold(B)), 4 cblue(bold(B));
  augment: #(vline: 1, hline: 1, stroke: 0.6pt + gray)
) \
&=
mat(
  0, 5, 0, 10;
  6, 7, 12, 14;
  0, 15, 0, 20;
  18, 21, 24, 28;
  augment: #(vline: 2, hline: 2, stroke: 0.6pt + gray)
)
$
]

the resulting matrix lives in $RR^(4, 4)$.

]


#slidebreak()


#example("Kronecker matrix-vector product " + $(bold(A) ⊗ bold(B)) bold(x)$ + " with " + $bold(A) in RR^(2, 2), bold(B) in RR^(l, k), bold(x) in RR^(2 k)$)[

If we perform a matrix-vector multiplication in form of $(bold(A) ⊗ bold(B)) bold(x)$, it is often helpful to keep track of its blockwise structure, before explicitly writing out its entries. Consider again $bold(A) in RR^(2, 2)$

$
bold(A) = mat(1, 2; 3, 4) in RR^(2, 2),
$

and let $cblue(bold(B)) in RR^(l, k)$ be any matrix. Then $bold(x)$ has length $2k$, and we split it into two chunks (one per column of $bold(A)$) by,

#matlines(rows: "solid")[
$
bold(x) = mat(bold(x)_(1); bold(x)_(2); augment: #(hline: 1, stroke: 0.6pt + gray)), quad quad bold(x)_(1), bold(x)_(2) in RR^(k)
$
]

Now, we can examine the structure of the final product. We perform the matrix-vector multiplication blockwise on $bold(x)$,

#matlines(cols: "solid | | ", rows: "solid | solid | solid")[
$
(bold(A) ⊗ cblue(bold(B))) bold(x)
= mat(
  1 cblue(bold(B)), 2 cblue(bold(B));
  3 cblue(bold(B)), 4 cblue(bold(B));
  augment: #(vline: 1, hline: 1, stroke: 0.6pt + gray)
) mat(bold(x)_(1); bold(x)_(2); augment: #(hline: 1, stroke: 0.6pt + gray))
= mat(
  1 cblue(bold(B)) bold(x)_(1) + 2 cblue(bold(B)) bold(x)_(2);
  3 cblue(bold(B)) bold(x)_(1) + 4 cblue(bold(B)) bold(x)_(2);
  augment: #(hline: 1, stroke: 0.6pt + gray)
)
$
]

Notice that $cblue(bold(B)) bold(x)_(1)$ and $cblue(bold(B)) bold(x)_(2)$ each appear only twice in the final result, this motivates on possibilities to improve the performance of such operations by avoiding redundantly compute the same blocks.

]
