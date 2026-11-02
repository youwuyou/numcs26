#import "../_site.typ": section, thought, example, definition, sidenote, boxeq, anchor, anchor-ref, divider, mat, vec, cblue, cred
#import "section_5_7_figures.typ": fig-domains, fig-dyadic
#import "section_5_7_curse.typ": fig-curse
#import "section_5_7_aniso.typ": fig-aniso

// Editorial review note. Typst drops `text(fill:)` in the HTML target, so emit a
// styled <span> for the website and fall back to colored text for the PDF build.
#let review(body) = context {
  if target() == "html" {
    html.elem("span", attrs: (style: "color: #e4272b"))[#body]
  } else {
    text(fill: rgb("#e4272b"), body)
  }
}

#let meta = (id: "quadratur-in-rd-und-duenne-gitter", title: "5.7 Quadratur in ℝᵈ und dünne Gitter")

#show: section.with(meta)

// Unlike other sections, the heading is written out instead of `#meta.title` so
// the domain renders as real math ($RR^d$). `meta.title` stays a plain string
// with a Unicode "ℝᵈ" for the sidebar nav and the section-number regex.
== 5.7 Quadratur in $RR^(d)$ und dünne Gitter

Let $f : Omega subset RR^(d) -> RR$ be a multivariate real-valued function. The general form of integration over $Omega$ is

$
I = integral_(Omega) f(x_(1), dots, x_(d)) d x_(1) dots d x_(d).
$

In particular, we should notice two difficulties here. The first is how to *represent* and *discretize* the domain $Omega subset RR^(d)$, and the second is how to *define* functions, extending our discussion of polynomials to the higher-dimensional setting.

=== Representation of the Domain $Omega subset RR^(d)$

Let us first refer to the domain as a *grid*, formed by the tensor product of $d$ one-dimensional intervals,

$
Omega = I_(x_(1)) times dots times I_(x_(d)),
$

where each $I_(x_(j))$, $j in {1, dots, d}$, denotes a one-dimensional interval along coordinate $x_(j)$. We may examine this visually in dimensions $d = 1, 2, 3$.

#fig-domains

For numerical treatments we need to perform a *discretization* of the domain. Note that for each dimension $j$ we may independently choose the number of points to use. In general, if all dimensions are treated equally, we say the grid is #underline[*isotropic*]; otherwise it is called #underline[*anisotropic*].

#example("Isotropic grids: a fixed " + $N$ + " per direction and the \"curse of dimensionality\".")[

If we fix the amount of discretization points in each dimension to $N$, then a $d$-dimensional grid gives rise to $N^(d)$ evaluation points, which grows rapidly in the number of nodes, as illustrated below in red.

#fig-curse
]

#example("Anisotropic grids: choosing " + $N_(j)$ + " per direction.")[

An anisotropic grid may use a different number $N_(j)$ of points per coordinate direction $j$. In the following, we denote the choice of grid points in an array,

$
bold(N) := (N_(1), N_(2)) = (16, 4)
$

Then we need in total only $64$ points,

$
N_(1) dot N_(2) = 16 dot 4 = 64
$

if we want to achieve the same finest resolution in an isotropic grid, we have to use $N^(2) = 16 dot 16 = 256$ grid points.

#fig-aniso


]

#divider()
