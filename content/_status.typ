// Which chapters are published. One flag per chapter page; flip it to `true`
// when that chapter is ready to go live. Everything else follows from here:
//
//   * build.py builds only released chapters, so an unreleased one has no page
//     in dist/ at all -- a half-written stub cannot be stumbled onto, and it
//     stays out of the search index and the previous/next pager;
//   * the sidebar shows the chapter greyed out with a 🚧 marker instead of a
//     collapsible group of sections;
//   * the schedule rows in index.typ that draw on it show TBD instead of the
//     exercise sheet, the section links and a clickable tutorial ticket.
//
// build.py parses this file with a regex (`parse_released`), so keep the
// entries one per line in the `key: true/false` form.
#let released = (
  ch0: true,
  ch1: true,
  ch2: true,
  ch3: false,
  ch4: false,
  ch5: false,
  ch6: false,
  ch7: false,
  ch8: false,
)

// Chapter key of a Skript section number, e.g. "7.1.2" -> "ch7".
#let chapter-of(key) = "ch" + key.split(".").at(0)

// True when every section cited lives in a chapter that is already released.
#let all-released(..keys) = keys.pos().all(key => released.at(chapter-of(key), default: false))
