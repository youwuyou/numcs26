#import "doc-template.typ": *
#show: numcs-doc

= Numerical Stability

Inline variables such as $x$, $y$, and $epsilon$ stay mathematical, while
operators and explicit text can be written upright as $"fl"$ and $"if"$.

== Display Equations

Block equations are centered and numbered automatically:

$
  "fl"(x + y) = (x + y)(1 + delta), quad abs(delta) <= epsilon_m
$

=== Callouts

#definition-box(title: [Machine Epsilon])[
  The machine epsilon $epsilon_m$ is the smallest positive number such that
  $1 + epsilon_m$ is distinguishable from $1$ in the floating point system.
]
