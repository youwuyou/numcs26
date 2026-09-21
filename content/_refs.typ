// Central registry of all section modules, keyed by their Skript number
// (e.g. "2.4", "7.1.2"), so pages like the schedule table can cite sections
// the same way a bibliography cites papers: `#sec("2.4")` / `#secs("2.3", "2.4")`.

#import "ch1/section_1_1.typ" as c1_1
#import "ch1/section_1_2.typ" as c1_2
#import "ch1/section_1_3.typ" as c1_3
#import "ch2/section_2_1.typ" as c2_1
#import "ch2/section_2_2.typ" as c2_2
#import "ch2/section_2_3.typ" as c2_3
#import "ch2/section_2_4.typ" as c2_4
#import "ch3/section_3_1.typ" as c3_1
#import "ch3/section_3_2.typ" as c3_2
#import "ch3/section_3_3.typ" as c3_3
#import "ch3/section_3_4.typ" as c3_4
#import "ch3/section_3_5.typ" as c3_5
#import "ch3/section_3_6.typ" as c3_6
#import "ch4/section_4_1.typ" as c4_1
#import "ch4/section_4_2.typ" as c4_2
#import "ch4/section_4_3.typ" as c4_3
#import "ch5/section_5_1.typ" as c5_1
#import "ch5/section_5_2.typ" as c5_2
#import "ch5/section_5_3.typ" as c5_3
#import "ch5/section_5_4.typ" as c5_4
#import "ch5/section_5_5.typ" as c5_5
#import "ch5/section_5_6.typ" as c5_6
#import "ch5/section_5_7.typ" as c5_7
#import "ch5/section_5_8.typ" as c5_8
#import "ch5/section_5_9.typ" as c5_9
#import "ch6/section_6_1.typ" as c6_1
#import "ch6/section_6_2.typ" as c6_2
#import "ch6/section_6_3.typ" as c6_3
#import "ch6/section_6_4.typ" as c6_4
#import "ch6/section_6_5.typ" as c6_5
#import "ch6/section_6_6.typ" as c6_6
#import "ch6/section_6_7.typ" as c6_7
#import "ch6/section_6_8.typ" as c6_8
#import "ch6/section_6_9.typ" as c6_9
#import "ch7/section_7_1_1.typ" as c7_1_1
#import "ch7/section_7_1_2.typ" as c7_1_2
#import "ch7/section_7_1_3.typ" as c7_1_3
#import "ch8/section_8_1.typ" as c8_1
#import "ch8/section_8_2.typ" as c8_2
#import "ch8/section_8_3.typ" as c8_3

// One entry per chapter page: its href, and the section modules it hosts.
#let chapters = (
  (href: "ch1.html", modules: (c1_1, c1_2, c1_3)),
  (href: "ch2.html", modules: (c2_1, c2_2, c2_3, c2_4)),
  (href: "ch3.html", modules: (c3_1, c3_2, c3_3, c3_4, c3_5, c3_6)),
  (href: "ch4.html", modules: (c4_1, c4_2, c4_3)),
  (href: "ch5.html", modules: (c5_1, c5_2, c5_3, c5_4, c5_5, c5_6, c5_7, c5_8, c5_9)),
  (href: "ch6.html", modules: (c6_1, c6_2, c6_3, c6_4, c6_5, c6_6, c6_7, c6_8, c6_9)),
  (href: "ch7.html", modules: (c7_1_1, c7_1_2, c7_1_3)),
  (href: "ch8.html", modules: (c8_1, c8_2, c8_3)),
)

// The Skript number is the first token of the title, e.g. "7.1.2 Wichtige..." -> "7.1.2".
#let key-of(title) = title.split(" ").at(0)

#let registry = (:)
#for ch in chapters {
  for m in ch.modules {
    registry.insert(key-of(m.meta.title), (href: ch.href, id: m.meta.id, title: m.meta.title))
  }
}

// Renders a single citation-style link, e.g. `#sec("2.4")` -> a link reading "2.4".
#let sec(key) = {
  let entry = registry.at(key, default: none)
  if entry == none {
    html.span(class: "sec-ref sec-ref-missing")[#key]
  } else {
    html.a(class: "sec-ref", href: entry.href + "#" + entry.id)[#key]
  }
}

// The title with its leading Skript number stripped, e.g. "2.4 Chebyshev-Interpolation" -> "Chebyshev-Interpolation".
#let title-of(key) = {
  let entry = registry.at(key, default: none)
  if entry == none {
    key
  } else {
    entry.title.split(" ").slice(1).join(" ")
  }
}

// Joins the (deduplicated) titles of a list of section keys, e.g.
// `#titles("2.1", "2.2")` -> "Interpolation und Polynome, Newton-Basis und dividierte Differenzen".
#let titles(..keys) = {
  let seen = ()
  let out = ()
  for key in keys.pos() {
    let t = title-of(key)
    if t not in seen {
      seen.push(t)
      out.push(t)
    }
  }
  out.join(", ")
}

// The sidebar nav href for a section key, e.g. "2.4" -> "ch2.html#chebyshev-interpolation".
// Matches exactly what site.js builds for each nav link, so it can be used to find and
// highlight the corresponding sidebar entries. Unknown keys are dropped.
#let section-targets(..keys) = {
  keys.pos()
    .map(key => {
      let entry = registry.at(key, default: none)
      if entry == none { none } else { entry.href + "#" + entry.id }
    })
    .filter(target => target != none)
    .join(",")
}

// True if `b` is the immediate successor of `a` (e.g. "2.3" -> "2.4", "7.1.2" -> "7.1.3").
#let consecutive(a, b) = {
  let pa = a.split(".").map(int)
  let pb = b.split(".").map(int)
  if pa.len() != pb.len() { return false }
  let same-prefix = true
  for i in range(pa.len() - 1) {
    if pa.at(i) != pb.at(i) { same-prefix = false }
  }
  same-prefix and pb.last() == pa.last() + 1
}

// Collapses a flat key list into runs of consecutive keys, e.g.
// ("5.1","5.2","5.3","5.4","5.6","5.7") -> (("5.1","5.2","5.3","5.4"), ("5.6","5.7")).
#let group-consecutive(items) = {
  let groups = ()
  let current = ()
  for key in items {
    if current.len() == 0 or consecutive(current.last(), key) {
      current.push(key)
    } else {
      groups.push(current)
      current = (key,)
    }
  }
  if current.len() > 0 {
    groups.push(current)
  }
  groups
}

// Renders a comma-separated list of section citations, collapsing consecutive
// runs into ranges, e.g. `#secs("1.1", "1.2", "1.3")` -> "1.1 – 1.3".
#let secs(..keys) = {
  let groups = group-consecutive(keys.pos())
  for (i, group) in groups.enumerate() {
    if i > 0 [, ]
    sec(group.first())
    if group.len() > 1 {
      [ – ]
      sec(group.last())
    }
  }
}
