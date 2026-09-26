#import "_site.typ": site, panels, code-expert, sidenote
#import "_refs.typ": sec, secs, titles, section-targets
#import "_status.typ": all-released

#let ticket(href, body) = html.a(class: "schedule-ticket", href: href)[#body]
#let muted-ticket(body) = html.span(class: "schedule-ticket schedule-ticket-muted")[#body]
// `extra`: nav hrefs that are not Skript sections (e.g. the Python warm-up
// page), highlighted alongside the sections this session covered.
#let session-ticket(date, ..keys, extra: ()) = {
  let targets = (section-targets(..keys),) + extra
  html.elem("a", attrs: (
    class: "schedule-ticket",
    href: "#",
    data-highlight-sections: targets.filter(t => t not in (none, "")).join(","),
  ))[#date]
}

#let extra-section-link(href, body) = html.a(class: "sec-ref", href: href)[#body]

// Tutorial Focus cell: the exercise sheet and the two or three themes the
// session actually drills, with the Skript section titles it draws on kept in a
// tooltip. The titles are the right thing to have when picking revision
// material, but spelled out in the cell they crowd out the rest of the row.
#let serie(number, topics, ..keys) = html.elem("span", attrs: (
  class: "serie-focus",
  tabindex: "0",
))[
  #html.span(class: "serie-label")[Serie #number: #topics]
  #html.elem("span", attrs: (class: "serie-sections", role: "tooltip"))[#titles(..keys)]
]

#let mixed-serie-focus(prefix, number, topics, ..keys) = html.elem("span", attrs: (
  class: "serie-focus",
  tabindex: "0",
))[
  #html.span(class: "serie-label")[#prefix#text[; parts of Serie ]#number: #topics]
  #html.elem("span", attrs: (class: "serie-sections", role: "tooltip"))[#titles(..keys)]
]

#let custom-focus(label, ..keys) = html.elem("span", attrs: (
  class: "serie-focus",
  tabindex: "0",
))[
  #html.span(class: "serie-label")[#label]
  #html.elem("span", attrs: (class: "serie-sections", role: "tooltip"))[#titles(..keys)]
]

// A week whose chapter pages are not published yet (see content/_status.typ):
// the dates stay -- they are the lecture plan, not ours -- but the sheet, the
// section links and the clickable ticket are still provisional, so they show as
// TBD rather than pointing at pages that do not exist.
#let tbd = html.span(class: "schedule-tbd")[TBD]

#let row(week, lecture_1, lecture_2, focus, sections, tutorial) = html.tr[
  #html.td[#week]
  #html.td[#lecture_1]
  #html.td[#lecture_2]
  #html.td[#focus]
  #html.td[#sections]
  #html.td[#tutorial]
]

// One tutorial week: the sheet `number`/`topics` and the Skript sections `keys`
// it draws on, rendered only once every one of those chapters is released.
// `extra`: nav hrefs outside the Skript to highlight alongside (e.g. the Python
// warm-up page). `note`: trailing text for the Sections cell.
#let week-row(week, lecture_1, lecture_2, number, topics, date, ..keys, extra: (), extra-sections: (), note: none, focus: none) = {
  if all-released(..keys) {
    row(
      week,
      lecture_1,
      lecture_2,
      if focus == none { serie(number, topics, ..keys) } else { focus },
      [#extra-sections.join[#text[, ]]#if extra-sections.len() > 0 and keys.pos().len() > 0 [, ]#secs(..keys)#note],
      session-ticket(date, ..keys, extra: extra),
    )
  } else {
    row(week, lecture_1, lecture_2, tbd, tbd, muted-ticket(date))
  }
}

// One FAQ entry, collapsed by default. `icon`: ❓ for the questions about the
// exercises and the exam, ❔ for the ones about GenAI, so the two kinds are
// tellable apart at a glance while scanning the closed list.
#let faq(icon, question, answer) = html.elem("details", attrs: (class: "faq-item"))[
  #html.elem("summary", attrs: (class: "faq-question"))[
    #html.span(class: "faq-icon")[#icon] #question
  ]
  #html.div(class: "faq-answer")[#answer]
]

#site("index", "NumCS Tutorial Notes", [
  #html.header(class: "doc-title")[
    #html.h1[Logistics]
    #html.p(class: "course-link-row")[
      #html.a(class: "course-icon-link moodle-icon-link", href: "https://moodle-app2.let.ethz.ch/course/view.php?id=28728", aria-label: "Open Moodle course")[
        #html.img(src: "static/moodle.png", alt: "ETH Zürich Moodle")
      ]
      #html.a(class: "course-icon-link video-portal-icon-link", href: "https://video.ethz.ch/lectures/d-math/2026/autumn/401-0663-00L", aria-label: "Open lecture video portal")[
        #html.img(class: "ethz-logo", src: "static/ethz-logo-transparent.png", alt: "", aria-hidden: true)
        #html.span(aria-hidden: true)[Video Portal]
      ]
    ]
  ]

  #panels[
    == Tutorial Session
    This page keeps tracks of the materials used in the exercise session of *group G-04 B* for the course "Numerical Methods for Computer Science".#sidenote[#linebreak()
      *Lecturer:* V. C. Gradinaru.#linebreak()
      *Exercise Coordinators:* Valentina Galbiati, Levi Lingsch.#linebreak()
      *Lectures:* Monday, 08:15-10:00, HG F 1 (video transmission to HG F 3) and Thursday, 10:15-12:00, HG F 1.
    ]
    - Teaching Assistant: *WU, You* (#link("mailto:youwuyou@ethz.ch")[youwuyou\@ethz.ch])
    - Time: *Mondays, 14:15-16:00*
    - Room: *#link("https://ethz.ch/staffnet/en/service/rooms-and-buildings/roominfo/detail.html?building=ML&floor=F&room=40")[ML F 40]*

    == Schedule

    The following schedule for the Monday tutorial session is tentative and follows the official course schedule based on the plan on #link("https://people.math.ethz.ch/~gradinar/Teaching/CronLectures/NumMet_INFK2026.html")[Dr. Gradinaru's website].

    #html.table(class: "schedule-table")[
      #html.thead[
        #html.tr[
          #html.th[Week]
          #html.th[Lecture 1]
          #html.th[Lecture 2]
          #html.th[Tutorial Focus]
          #html.th[Sections]
          #html.th[Tutorial]
        ]
      ]
      #html.tbody[
        #week-row(
          [1],
          [-],
          link("https://video.ethz.ch/lectures/d-math/2026/autumn/401-0663-00L/v/E9GTIc9xr_J")[17.09.2026],
          "01",
          [Auslöschung],
          [21.09.2026],
          "1.1",
          extra: ("ch0.html",),
          extra-sections: (extra-section-link("ch0.html", [0]),),
          focus: mixed-serie-focus([Einführung in Python], "01", [Auslöschung], "1.1"),
        )
        #week-row(
          [2],
          link("https://video.ethz.ch/lectures/d-math/2026/autumn/401-0663-00L/v/Fu4DWF0mWwT")[21.09.2026],
          link("https://video.ethz.ch/lectures/d-math/2026/autumn/401-0663-00L/v/HiOlNUGSJkX")[24.09.2026],
          "02",
          [Polynomiale Interpolation],
          [28.09.2026],
          "1.2", "1.3", "2.1", "2.2", "2.3",
          focus: custom-focus([parts of Serie 01: Komplexität; Serie 02: Polynomiale Interpolation], "1.2", "1.3", "2.1", "2.2", "2.3"),
        )
        #week-row(
          [3],
          [28.09.2026],
          [01.10.2026],
          "03",
          [Trigonometrische Interpolation],
          [05.10.2026],
          "3.1", "3.2", "3.3", "3.4", "3.5",
        )
        #week-row(
          [4],
          [05.10.2026],
          [08.10.2026],
          "04",
          [Chebyshev-Interpolation],
          [12.10.2026],
          "2.4", "3.5", "3.6",
        )
        #week-row(
          [5],
          [12.10.2026],
          [15.10.2026],
          "05",
          [Stückweise Polynomiale Interpolation],
          [19.10.2026],
          "4.1", "4.2", "4.3",
        )
        #week-row(
          [6],
          [19.10.2026],
          [22.10.2026],
          "06",
          [Quadratur],
          [26.10.2026],
          "5.1", "5.2", "5.3", "5.4", "5.5", "5.6", "5.7",
        )
        #week-row(
          [7],
          [26.10.2026],
          [29.10.2026],
          "07",
          [Einfache Monte-Carlo Methode],
          [02.11.2026],
          "5.8", "5.9",
        )
        #week-row(
          [8],
          [02.11.2026],
          [05.11.2026],
          "08",
          [Nullstellen],
          [09.11.2026],
          "6.1", "6.2", "6.3", "6.4", "6.5", "6.6", "6.7", "6.8", "6.9",
        )
        #week-row(
          [9],
          [09.11.2026],
          [12.11.2026],
          "09",
          [Intermezzo in LA],
          [16.11.2026],
          "7.1.1", "7.1.2", "7.1.3",
        )
        #week-row(
          [10],
          [16.11.2026],
          [19.11.2026],
          "10",
          [Lineare Ausgleichsrechnung],
          [23.11.2026],
          "8.1",
        )
        #week-row(
          [11],
          [23.11.2026],
          [26.11.2026],
          "11",
          [Ausgleichsrechnung mit Nebenbedingung],
          [30.11.2026],
          "8.1", note: [ (Nebenbedingungen, no own number)],
        )
        #week-row(
          [12],
          [30.11.2026],
          [03.12.2026],
          "12",
          [Nichtlineare Ausgleichsrechnung],
          [07.12.2026],
          "8.2",
        )
        #row(
          [13],
          [07.12.2026],
          [10.12.2026],
          [-],
          if all-released("8.3") [#sec("8.3")] else [#tbd],
          muted-ticket([No tutorial]),
        )
        #row(
          [14],
          [14.12.2026],
          [17.12.2026],
          [-],
          [Rückblick and mock exam],
          muted-ticket([No tutorial]),
        )
      ]
    ]

    == FAQ

    Here is a collection of commonly asked questions for the organization of the course, please take the main lecture page and words of the lecturer as main reference; the list will be maintained and updated:

    #faq([❓], [What may I use while working on the #code-expert exercises and Moodle quizzes?], [
      You are allowed to use the following aids:

      - the lecture document "Numerische Methoden" by Dr. Gradinaru
      - the lecture notes, i.e. "Aufschriebe" by Dr. Gradinaru
      - any book of your choice
      - the documentation of the Python packages you use
      - your preferred GenAI(s), *Pro/Deep versions only* (cf. #link("https://ethz.ch/en/the-eth-zurich/education/ai-in-education/tools.html")[the AI tools ETH provides]).
    ])

    #faq([❓], [What am I allowed to use in the exam?], [
      The exam will take place using Moodle and with CodeExpert within it as the coding environment, provided aids are:
      - the lecture document “Numerische Methoden” by Dr. Gradinaru
      - the lecture notes, i.e. “Aufschriebe” by Dr. Gradinaru
      - #strike[(tentatively) a Jupyter window as scratch paper may be allowed, but its outputs are ignored when grading]#sidenote[This year's exam will not provide a Jupyter notebook window.]
    ])

    #faq([❓], [How important are the exercises and the Moodle quizzes?], [
      In Dr. Gradinaru's words:

      #html.blockquote(class: "faq-quote")[
        #html.p[Die Prüfung folgt ziemlich genau (95-100%?) den Übungen: CodeExpert und Moodle Quizze.]
      ]
    ])

    #faq([❓], [How does the 0.25 grade bonus work?], [
      A bonus of +0.25 in the final grade of the session exam is awarded if you obtained *at least 70%* of the available points from the Moodle quizzes and #code-expert combined. Both kinds of "Serie (n)" appear weekly and count with the following weight:

      #html.table(class: "weight-table")[
        #html.thead[
          #html.tr[
            #html.th[Source]
            #html.th[Weight]
          ]
        ]
        #html.tbody[
          #html.tr[
            #html.td[Moodle "Serie (n)" quiz]
            #html.td[1]
          ]
          #html.tr[
            #html.td[#code-expert "Serie (n)" task]
            #html.td[2]
          ]
        ]
      ]

    ])

    #faq([❓], [How are the #code-expert exercises graded?], [
      Since most numerics tasks in this course cannot be tested automatically, the TAs manually examine and grade the exercises based on the code quality and alignment of your results vs. the expected outcomes.
    ])

    #faq([❔], [Can I use a GenAI for the exercises, and how?], [
      Yes, the one you prefer, but only a *Pro/Deep* version. You have to declare the use in a comment, and you are fully responsible for what you hand in. Without directly passing lecture materials to the AI(s), you are allowed to:
      - asking about an intermediate step in doubt
      - critically test and analyze outputs
      - ...
    ])

    #faq([❔], [Can I upload the course material to a GenAI?], [
      No. The lecture document, the lecture notes and the exercises must not be directly uploaded anywhere.
    ])

    #html.p(class: "faq-source")[Source: Moodle / Allgemeines (Erlaubte Hilfsmitteln, Notenbonus) · last checked 26.09.2026]
  ]
])
