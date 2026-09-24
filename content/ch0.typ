#import "_site.typ": site, python, panels, python-console, figure-img, sidenote, slidebreak

#site("ch0", "Einführung in Python", [
  #html.header(class: "hero compact-hero")[
    // Icon-before-title layout, same idiom as the Polybox/VIS headings on the
    // Useful Links page (see `.title-with-icon` in static/site.css).
    #html.h1(class: "title-with-icon")[
      #html.img(class: "title-icon", src: "static/python-logo.svg", alt: "", aria-hidden: true)
      #html.span[Einführung in Python]
    ]
  ]

  // Section 3 (Benchmarking) nests inside "Linear Algebra"; without this,
  // Typst's default HTML export skips a level and emits <h4> for it, the same
  // bug `section()` in _site.typ works around for the chapter pages.
  #show heading.where(level: 3): h => html.h3(class: "section-subheading")[#h.body]

  #panels[
    == Overview
    This page complements the discussion of the #link("https://moodle-app2.let.ethz.ch/pluginfile.php/2588645/mod_resource/content/1/serie00.pdf")[Aufwärmübungen], we will introduce necessary notions to get you started with the first coding exercises of week 1.

    The Python version used in the course is Python 3.11.

    #python-console("Try it live!")

    == A. Numeric Types

    The following three #link("https://docs.python.org/3/library/stdtypes.html#numeric-types-int-float-complex")[numeric types] are built-in in Python.

    #html.table(class: "content-table")[
      #html.thead[
        #html.tr[
          #html.th[Type]
          #html.th[Example literals]
          #html.th[Notes]
        ]
      ]
      #html.tbody[
        #html.tr[
          #html.td[`int`]
          #html.td[`42`, `-7`, `1_000`]
          #html.td[Integers have **unlimited** precision.]
        ]
        #html.tr[
          #html.td[`float`]
          #html.td[`3.14`, `2.`, `1e-3`]
          #html.td[Floating-point numbers are usually implemented using double in C; information about the precision and internal representation of floating-point numbers for the machine on which your program is running is available in `sys.float_info`.]
        ]
        #html.tr[
          #html.td[`complex`]
          #html.td[`complex(re, im)` builds `re + im*1j`, `2 + 3j`, `1j` (not `1i`!)]
          #html.td[Complex numbers have a real and imaginary part, which are each a floating-point number.]
        ]
      ]
    ]

    Keep in mind that *the imaginary unit is `j`, not `i`.* #sidenote[Moreover, digits before the `j` may be written as an integer or a float, e.g. `1j`, `1.j` and `1.0j` are all the same number, since the imaginary part is always stored as a `float`.] Beyond these built-ins, once we work with numpy we also reach for its fixed-width numeric types.#sidenote[NumPy's #link("https://numpy.org/doc/stable/reference/arrays.scalars.html#sized-aliases")[sized aliases] — such as `np.float64`, `np.int32` or `np.complex128`.]

    #slidebreak()


    #python("Numeric types at a glance")[
      ```python
      print(type(42), type(3.14), type(2 + 3j))

      z = 2 + 3j
      print(z.real, z.imag, z.conjugate())   # 2.0 3.0 (2-3j)

      print(float("1_000.5"), float("nan"))  # 1000.5 nan
      print(complex(2, 3))                    # (2+3j)
      print(complex("2+3j"))                  # (2+3j)
      ```
    ]

    == B. Functions

    In the paradigm of functional programming, functions are treated as *first-class citizens*. This means the language supports passing functions as arguments to other functions, returning them as the values from other functions, and assigning them to variables or storing them in data structures.
    
    While not a purely functional language, Python supports many functional programming concepts, including the support of first-class functions. We will see what it means in practice by introducing the concept of a *lambda function* and a *decorator*.

    #slidebreak()

    === B.1 Lambda Functions

    Often in exercises, we encounter the use of **"Lambda functions"**, which are small, short-lived functions that may be passed to another function. We consider a function `F` consisting of two arguments `a`, `b` that performs a simple subtraction.

    ```python
    def F(a,b):
        return a - b
    ```

    The same function can be written as a one-line *lambda*. 
    
    ```python
    F = lambda a, b: a - b   # equivalent to the def F above
    ```

    #slidebreak()
    
    A lambda has four parts: an (optional) name it is bound to, the `lambda` keyword, its arguments, and the single expression whose value it returns.

    #figure-img(
      "static/lambda-anatomy.webp",
      "Anatomy of a Python lambda: f = lambda a: a * a, labelling the keyword, the argument, the one-line expression, and the resulting function object.",
      credit: [Source: #link("https://levelup.gitconnected.com/mastering-lambda-expressions-in-python-a-hands-on-guide-e6f380701e96")[Mastering Lambda Expressions in Python].],
      width: 80%,
    )[The anatomy of a lambda function.]

    #slidebreak()

    We may also keep Lambda functions anonymous, without explicitly assigning them a name:

    #python("Applying an anonymous lambda function")[
    ```python
    def apply(func, x):
        return func(x)

    x = apply(lambda z: z**2, 2.)
    print(x)
    ```      
    ]

    #slidebreak()

    === B.2 Decorator

    Decorators allow us to wrap another function in order to extend the behavior of the wrapped function, without permanently modifying it. In the following, we see an example of a custom decorator that measures the elapsed time.

    #python("A first example of a decorator for runtime measurement")[
      ```python
      import time

      def timer(func):
          def wrapper():
              before = time.time()
              func()
              print("Function took:", time.time() - before, "seconds")
          return wrapper

      @timer
      def run():
          time.sleep(2)

      run()  # outputs elapsed time
      ```
    ]

    == C. Linear Algebra with #html.a(href: "https://numpy.org/doc/2.4/", class: "heading-lib-link")[#html.img(class: "heading-lib-logo", src: "static/numpy-logo.svg", alt: "", aria-hidden: true)#html.span(class: "visually-hidden")[numpy]] in Python

    Numpy allows us to efficiently perform array operations. Its array operations are often based on highly optimized library routines implemented in C or FORTRAN (cf. use of #link("https://numpy.org/devdocs/building/blas_lapack.html")[BLAS and LAPACK in `numpy`])

    To use `numpy`, we need to import the module. We commonly give it an alias of `np` for conciseness,

    #python("Import the numpy module with an alias")[
    ```python
    # `import numpy` but assign an alias for referencing it shorthanded
    # `from numpy import *` would import its nams into the global scope, not recommended due to possible name clashes
    import numpy as np
    ```
    ]


    #slidebreak()

    === Data Storage

    Although we are concerned with N-dimensional arrays, their actual memory layout is only one-dimensional as a flat 1D block of memory. The rule that specifies the order how the entries of an N-dimensional array are stored in the computer memory is called the *storage order*.
    
    *Row-major order* is also known as *C order*, since the C language uses it, and new numpy arrays are row-major by default. Fortran and MATLAB instead use *column-major* order (*F order*)

    #figure-img(
      "static/row-column-major.webp",
      "A 3x3 matrix flattened in row-major order (row after row) versus column-major order (column after column).",
      credit: [Source: #link("https://commons.wikimedia.org/wiki/File:Row_and_column_major_order.svg")[Wikimedia Commons], CC BY-SA 3.0.],
      width: 35%,
    )[Row-major vs. column-major storage of a matrix.]

    #slidebreak()

    In the following, we illustrate the difference between both orders, we use `np.ravel` to obtain the contiguous flattened array and specify the view (`C`, `F`) of choice:

    #python("Row-major (C) vs. column-major (F) order")[
      ```python
      A = np.array([[1, 2, 3],
                    [4, 5, 6]])

      print(A.ravel(order='C'))       # [1 2 3 4 5 6]  row after row (default)
      print(A.ravel(order='F'))       # [1 4 2 5 3 6]  column after column

      print(A.flags['C_CONTIGUOUS'])
      print(A.flags['F_CONTIGUOUS'])
      ```
    ]

    #slidebreak()

    === Matrices and vectors

    To get started with linear algebra with `numpy`, let us consider the following concrete example of a matrix $M$ and a vector $v$ of compatible dimensions,

    $ M = mat(1, 2, 3; 4, 5, 6; 7, 8, 9) in RR^(3 times 3), quad v = vec(1, 2, 3) in RR^(3 times 1), $

    The initialization mirrors closely the mathematical notation,

    #python("Initializing a matrix and a vector")[
      ```python
      M = np.array([[1, 2, 3],
                    [4, 5, 6],
                    [7, 8, 9]])
      v = np.array([[1], [2], [3]])   # a column vector

      print(M.shape)   # (3, 3)
      # print(v.shape)   # what is the dimension of v?

      # u = np.array([1, 2, 3])
      # print(u.shape)   # how does u differ from v?
      ```
    ]

    Here, the use of `.shape` indicates their dimensions.

    #slidebreak()

    Rather than typing every entry by hand, we usually start from one of numpy's constructors:

    ```python
    np.zeros((2, 2))       # [[0. 0.] [0. 0.]]
    np.ones((1, 2))        # [[1. 1.]]
    np.full((2, 2), 7)     # [[7 7] [7 7]]  -- a constant array
    np.eye(3)              # 3x3 identity matrix
    np.arange(0, 6, 2)     # [0 2 4]  -- like range(), but an array
    np.linspace(0, 1, 5)   # [0.  0.25 0.5  0.75 1. ]  -- 5 points, endpoints included
    ```

    #slidebreak()

    === Transpose

    To transpose a matrix $A$, we may use `np.transpose(A)`, or the shorthanded notion `A.T`. This is the transpose $C = A^T$ you already know, defined by $c_(i j) = a_(j i)$, with the familiar identities

    $ (A + B)^T = A^T + B^T, quad (A B)^T = B^T A^T, $

    #python("Transpose")[
      ```python
      A = np.array([[1, 2, 3],
                    [4, 5, 6]])
      print(A.T.shape)   # (3, 2)
      # print(A.T)
      # print(np.transpose(A))
      ```
    ]



    #slidebreak()



    === Norms, determinants, and decompositions

    The `np.linalg` module supports convenient linear algebra operations such as the calculation of norms, determinants and allows us to decompose a matrix,

    $ norm(x)_2 = sqrt(sum_(i=1)^n x_i^2), quad norm(x)_1 = sum_(i=1)^n abs(x_i), quad norm(x)_p = (sum_(i=1)^n abs(x_i)^p)^(1\/p), $

    #html.table(class: "content-table")[
      #html.thead[
        #html.tr[
          #html.th[Call]
          #html.th[What it computes]
        ]
      ]
      #html.tbody[
        #html.tr[
          #html.td[`np.linalg.norm(x)`]
          #html.td[a vector or matrix norm — Euclidean $norm(x)_2$ by default]
        ]
        #html.tr[
          #html.td[`np.linalg.det(A)`]
          #html.td[the determinant $det A$ (e.g. $a_(11) a_(22) - a_(12) a_(21)$ for a $2 times 2$)]
        ]
        #html.tr[
          #html.td[`np.linalg.inv(A)`]
          #html.td[the inverse $A^(-1)$, satisfying $A A^(-1) = A^(-1) A = I$]
        ]
        #html.tr[
          #html.td[`np.linalg.solve(A, b)`]
          #html.td[the solution of $A x = b$ — preferred over `inv` for solving systems]
        ]
        #html.tr[
          #html.td[`np.linalg.eig(A)`]
          #html.td[eigenpairs $A u = lambda u$; the eigenvalues solve $det(A - lambda I) = 0$]
        ]
        #html.tr[
          #html.td[`np.linalg.svd(A)`]
          #html.td[the singular value decomposition $A = U Sigma V^T$]
        ]
      ]
    ]

    If we pass a matrix `A` to `norm()`, the Frobenius norm is used $norm(A)_F = sqrt(sum_(i, j) abs(a_(i j))^2)$.

    #slidebreak()

    #python("A short tour of np.linalg")[
      ```python
      M = np.array([[1.0,  0.0],
                    [0.0,  1.0]])

      print(np.linalg.det(M))

      vals, vecs = np.linalg.eig(M)   # eigenvalues, and eigenvectors as columns
      U, S, Vt = np.linalg.svd(M)     # M == U @ np.diag(S) @ Vt
      ```
    ]#sidenote[A common trap in the SVD call: numpy returns `Vt`, which is already $V^T$ in the usual $A = U Sigma V^T$ convention — not $V$. Transpose it back if you need $V$ itself.]


    #slidebreak()


    === Entries and submatrices

    In numpy the indices are given one per axis, `M[row, col]`, and each axis accepts the usual `start:stop` *slice* (0-based). A slice does *not* copy by default; when you need an independent array, ask for one explicitly with `.copy()`.

    #python("Indexing, slicing, and views")[
      ```python
      M = np.array([[1, 2, 3],
                    [4, 5, 6],
                    [7, 8, 9]])

      print(M[0, 2])     # 3
      # print(M[:2, 1:3])

      # row = M[1]
      # row[0] = 99
      # print(M[1, 0])
      ```
    ]

    #slidebreak()

    === Hadamard product and matrix product

    The *Hadamard* (entrywise) product is

    $ (A ⊙ B)_(i j) = a_(i j) b_(i j), $

    whereas the *matrix product* from linear algebra is

    $ C = A B, quad c_(i j) = sum_(k=1)^(m) a_(i k) b_(k j), $

    whose special case for two vectors is the inner product $v dot w = sum_(i) v_i w_i$, which gives a single scalar.

    #python("Element-wise vs. matrix product")[
      ```python
      M = np.array([[1, 2, 3],
                    [4, 5, 6],
                    [7, 8, 9]])
      v = np.array([[1], [2], [3]])

      print(3 * v)             # [[3] [6] [9]]     -- scalar, element-wise
      print(np.multiply(M, v)) # [[ 1  2  3]        -- element-wise (with broadcasting)
                               #  [ 8 10 12]
                               #  [21 24 27]]
      print(M @ v)             # [[14] [32] [50]]   -- matrix-vector product
      print(M.dot(v))          # [[14] [32] [50]]   -- the same thing
      ```
    ]

    #slidebreak()

    === Reduction and Scan

    We may also specify operations to apply along a particular row/column. We consider a *reduction* (`np.sum`, `np.max`, `np.mean`), and a *scan* (`np.cumsum`, `np.cumprod`).

    #python("Summing along an axis, and cumulative scans")[
      ```python
      A = np.array([[1, 2, 3],
                    [4, 5, 6]])

      print(np.sum(A, axis=1))   # [ 6 15]  -- collapse the columns, one value per row
      print(np.sum(A, axis=0))   # [5 7 9]  -- collapse the rows, one value per column

      print(np.cumsum([1, 2, 3, 4]))    # [ 1  3  6 10]
      print(np.cumprod([1, 2, 3, 4]))   # [ 1  2  6 24]
      ```
    ]

    == D. Using #html.a(href: "https://matplotlib.org/stable/gallery/index.html", class: "heading-lib-link")[#html.img(class: "heading-lib-logo heading-lib-logo--wide", src: "static/matplotlib-logo.svg", alt: "", aria-hidden: true)#html.span(class: "visually-hidden")[matplotlib]] for Data Visualization

    We use `matplotlib` for data visualization. For beginners, it is useful to keep the following anatomy of a plot in mind. You do not need to memorize it, but knowing what they correspond to may be useful to not get confused with the plotting routines in exercises:

    #figure-img(
      "static/matplotlib-anatomy.png",
      "Annotated anatomy of a matplotlib figure, labelling the Figure, Axes, Axis, title, legend, grid, line, markers, tick labels and spines, each with the method call that controls it.",
      credit: [Source: #link("https://matplotlib.org/stable/gallery/showcase/anatomy.html")[Anatomy of a figure], © The Matplotlib development team.],
      width: 70%,
    )[The anatomy of a matplotlib figure — each label names a part and the method that controls it.]


    #slidebreak()

    Any label passed as `label=...` may contain LaTeX between dollar signs, e.g. `'$h^2$'` or `'$O(n^2)$'`, which is how the reference lines get their mathematical captions. A complete timing plot then looks like this:

    #python("A log-log timing plot")[
      ```python
      import numpy as np
      import matplotlib.pyplot as plt

      n = np.array([2**k for k in range(4, 12)])   # problem sizes
      t_slow = 1e-9 * n**3                          # (pretend) measured times
      t_fast = 1e-9 * n**2

      plt.loglog(n, t_slow, '*', label='direct way')
      plt.loglog(n, t_fast, 'D', label='fast way')
      plt.loglog(n, 1e-9 * n**3, 'b-', label='$O(n^3)$')   # reference slope
      plt.loglog(n, 1e-9 * n**2, '--', label='$O(n^2)$')   # reference slope

      plt.xlabel('size n')
      plt.ylabel('time (s)')
      plt.grid(True, which="both")
      plt.legend()
      plt.show()
      ```
    ]

    #slidebreak()

    === Global styling

    Rather than restyle every figure by hand, we set matplotlib's *runtime configuration* once at the top of a script through `plt.rcParams`. Every plot made afterwards inherits the settings. The parameters worth knowing for this course:

    #html.table(class: "content-table")[
      #html.thead[
        #html.tr[
          #html.th[Parameter]
          #html.th[Controls]
        ]
      ]
      #html.tbody[
        #html.tr[
          #html.td[`figure.figsize`]
          #html.td[figure size in inches, e.g. `(12, 12)`]
        ]
        #html.tr[
          #html.td[`axes.labelsize`, `axes.titlesize`]
          #html.td[font size of the axis labels and the title]
        ]
        #html.tr[
          #html.td[`legend.fontsize`]
          #html.td[font size of the legend text]
        ]
        #html.tr[
          #html.td[`xtick.labelsize`, `ytick.labelsize`]
          #html.td[font size of the tick labels]
        ]
        #html.tr[
          #html.td[`lines.markersize`]
          #html.td[default size of the data markers]
        ]
      ]
    ]

    #slidebreak()

    #python("Set the style globally")[
      ```python
      import matplotlib.pyplot as plt

      params = {
          'figure.figsize'  : (12, 12),
          'axes.labelsize'  : 20,
          'axes.titlesize'  : 16,
          'legend.fontsize' : 16,
          'xtick.labelsize' : 16,
          'ytick.labelsize' : 16,
          'lines.markersize': 12,
      }
      plt.rcParams.update(params)   # applies to every plot from here on
      ```
    ]
    
    == Solution to "Aufwärmübungen"

    A #link("https://jupyter.org")[Jupyter notebook] allows us to write a python script cell by cell and we can supply explanations to the code using Markdown cells. Providers such as #link("https://colab.research.google.com")[Google Colab] allow us to start working on such a notebook without local installation of Python and package environment etc..

    The full solutions to the Aufwärmübungen live in one such notebook, you can open it and run it cell by cell:

    #html.a(href: "https://colab.research.google.com/drive/12_7a_jgcYqty0C91QW0WhUNp01x9pPtP", class: "colab-badge")[#html.img(class: "colab-badge-logo", src: "static/colab-logo.svg", alt: "", aria-hidden: true)#html.span[Open the "Aufwärmübungen" in Google Colab]]   

    #slidebreak()

    === Contour Plot

    Let $(x, y) in RR^(2)$, we want to plot contour lines of

    $
    f(x, y) = sin(2 pi (x^(2) + y))
    $

    #python("Contour Plot from `Aufwärmübungen`")[
      ```python
      import numpy as np
      import matplotlib.pyplot as plt

      def f(x, y):
          return np.sin(2 * np.pi * (x**2 + y))

      # build the grid
      x = np.linspace(-1, 1, 100)
      y = np.linspace(-1, 1, 100)
      X, Y = np.meshgrid(x, y)
      Z = f(X, Y)

      # how it works without meshgrid, but slow...
      Z_slow = np.zeros((len(y), len(x)))
      for i, y_val in enumerate(y):
          for j, x_val in enumerate(x):
              Z_slow[i,j] = f(x_val, y_val)

      # three different plots
      fig, axes = plt.subplots(1, 3, figsize=(15, 4))

      # contour lines
      axes[0].contour(X, Y, Z)
      axes[0].set_title('contour')

      # filled contour lines
      axes[1].contourf(X, Y, Z)
      axes[1].set_title('contourf')

      # color plot
      axes[2].pcolormesh(X, Y, Z)
      axes[2].set_title('pcolormesh')

      plt.show()
      ```
    ]

    #slidebreak()

    === Julia Set

    Let $f(z) = z^(2) - 0.4 + 0.6bold(i)$ and $D = [-1, 1]^(2) subset CC$. For $1000 times 1000$ points $z in D$, calculate

    $
    g(z) = max{n in NN : abs(f^(n)(z)) < 100}
    $

    #python("Contour Plot from `Aufwärmübungen`")[
    ```python
    import numpy as np
    import matplotlib.pyplot as plt

    def julia_set():
        # (a) implement the function
        def f(z):
            return z**2 - 0.4 + 0.6j

        # (d) grid for D ⊂ ℂ
        x = np.linspace(-1, 1, 1000)
        y = np.linspace(-1, 1, 1000)
        X, Y = np.meshgrid(x, y)
        Z = X + 1j * Y  # complex grid

        # (e) iteration
        n_times_finite = np.zeros((1000, 1000))
        z_current = Z.copy()

        for k in range(60):
            mask = np.abs(z_current) < 100
            n_times_finite[mask] += 1
            z_current[mask] = f(z_current[mask])

        # (f) plotting
        plt.figure(figsize=(8, 8))
        plt.pcolormesh(X, Y, np.log(n_times_finite), cmap='hot')
        plt.title('Julia set')
        plt.axis('equal')
        plt.show()

    julia_set()
    ```
    ]

  ]
])
