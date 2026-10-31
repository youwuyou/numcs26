#import "../_site.typ": section

#let meta = (id: "fft-schnelle-fourier-transformation", title: "3.3 – 3.4 FFT & Trigonometrische Interpolation und rechentechnische Aspekte")

#show: section.with(meta)

== #meta.title

// The former §3.4 is folded into this panel. Keep its anchor alive so old deep
// links and `#sec("3.4")` (via the registry in _refs.typ) still land here.
#context { if target() == "html" { html.div(id: "trigonometrische-interpolation-und-rechentechnische-aspekte") } }
