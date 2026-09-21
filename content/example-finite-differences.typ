#import "_site.typ": site, python

#site("finite-differences", "Finite Differences", [
  #html.header(class: "hero compact-hero")[
    #html.h1[Finite Differences]
  ]

  #html.section(id: "finite-differences", class: "panel")[
    #html.p(class: "section-kicker")[Example]
    #html.h2[Forward and central finite differences]
    #html.p[
      This reusable notebook example compares forward and central
      differences for #html.em[f(x) = sin(x)] at #html.em[x = 1].
      The main phenomenon is the competition between truncation error and
      floating-point cancellation.
    ]

    #python("Forward and central finite differences")[
```py
import numpy as np
import matplotlib.pyplot as plt

def f(x):
    return np.sin(x)

x = 1.0
exact = np.cos(x)
h = 10.0 ** (-np.arange(1, 16))

forward = (f(x + h) - f(x)) / h
central = (f(x + h) - f(x - h)) / (2 * h)

fig, ax = plt.subplots()
ax.loglog(h, np.abs(forward - exact), "o-", label="forward")
ax.loglog(h, np.abs(central - exact), "o-", label="central")
ax.invert_xaxis()
ax.set_xlabel("h")
ax.set_ylabel("absolute error")
ax.legend()
ax.grid(True, which="both")
```
]

    #html.p[
      #html.strong[Observation:] the central difference usually
      achieves a smaller truncation error, but both formulas eventually
      suffer from floating-point cancellation when #html.code[h] is
      too small.
    ]
  ]
])
