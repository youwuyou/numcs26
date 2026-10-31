#import "../_site.typ": section, example, divider, boxeq, stage

#let meta = (id: "b-splines", title: "4.4 B-Splines", draft: true)

#show: section.with(meta)

#divider()

== #meta.title

For all $j = 0, 1, dots, l-1$, define *box function*

$
N^(0)_(j)(t) = cases(
1 quad "for" t in [u_(j), u_(j+1)),
0 quad "otherwise"
)
$

then use convex combination of $N_(j)^(k-1), N_(j+1)^(k-1)$

$
N^(k)_(j)(t) = frac(t- u_(j), u_(j+k) - u_(j)) N^(k-1)_(j)(t) + frac(u_(j + k+1) - t, u_(j+k+1) - u_(j+1))N^(k-1)_(j+1)(t)
$

- $N^(1)_(2)(t)$ the hat function
- fractions above if it is denominator zero then just take $0$



*recursive definition*

#example("Support")[

Let $f: RR -> RR$

$
"supp" f = \{ x in RR: f(x) != 0 \}
$
]

#example("Globally continuously differentiable")[
- locally degree $k$, p.w.
$
N_(j)^(k) in C^(k-1)
$
]





#boxeq[

$
sum^(i)_(j = i - k) N^(k)_(j)(t) = 1, quad forall t in [u_(i), u_(i+1)], i = k, k+1, dots, l-k-1
$

]


=== LSE
- good conditioned

$
bold(A) bold(c) = bold(y)
$

where 

$
sum^(l-k-1)_(j = 0) c_(j) N^(k)_(j)(t_(i)) = y_(i), quad i = 0,1, dots, l
$



#stage[Evaluation]
- use Aitken-Neville/Richardson, recursive computation