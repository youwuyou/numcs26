#import "_site.typ": site, python

#site("interpolation", "Interpolation Preview", [
  #html.header(class: "hero compact-hero")[
    #html.h1[Interpolation Preview]
  ]

  #html.section(id: "interpolation-preview", class: "panel")[
    #html.p(class: "section-kicker")[Example]
    #html.h2[Runge function samples]
    #html.p[
      This notebook-style example prepares the polynomial interpolation
      weeks by sampling the Runge function on equidistant nodes.
    ]

    #python("Sampling the Runge function")[
```py
import numpy as np

def runge(x):
    return 1 / (1 + 25 * x**2)

x = np.linspace(-1, 1, 9)
y = runge(x)

print("nodes:", x)
print("values:", y)
```
]

    #html.p[
      #html.strong[Next step:] add plots comparing equidistant nodes
      and Chebyshev nodes once the interpolation task details are available.
    ]
  ]
])
