#import "_site.typ": site

#site("search", "Search", [
  #html.header(class: "doc-title")[
    #html.h1[Search]
  ]

  #html.section(class: "search-page")[
    #html.p(id: "search-status", class: "search-status")[]
    #html.ul(id: "search-results-page", class: "search-result-list")[]
  ]
])
