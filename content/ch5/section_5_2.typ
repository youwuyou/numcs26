#import "../_site.typ": section

// NOTE: §5.2 is folded into §5.1 (see section_5_1.typ). This file is no longer
// rendered -- it is dropped from ch5.typ and from site.json's section list.
// It survives only as a metadata carrier: _refs.typ imports it so the "5.2"
// citation key keeps resolving (to the `schneller-ueberblick` anchor that
// section_5_1.typ still emits). Do not re-add it to ch5.typ / site.json.

#let meta = (id: "schneller-ueberblick", title: "5.2 Schneller Überblick")

#show: section.with(meta)

== #meta.title

Content coming soon.
