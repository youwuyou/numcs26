#import "../_site.typ": section, thought

#let meta = (id: "motivation", title: "5.1 – 5.2 Motivation & Schneller Überblick")

#show: section.with(meta)

== #meta.title

// The former §5.2 is folded into this panel. Keep its anchor alive so old deep
// links and `#sec("5.2")` (via the registry in _refs.typ) still land here.
#context { if target() == "html" { html.div(id: "schneller-ueberblick") } }

// #thought("Worum geht es?")[
//   TODO
// ]
