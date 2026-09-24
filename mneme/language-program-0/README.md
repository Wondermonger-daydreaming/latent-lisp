# PROGRAM /0 — write and run a Lisp+ program

Lisp+ programs are plain text files of parenthesised forms. You define functions, pass them around,
build and fold lists, and run the file with one command:

```sh
bash mneme/language-program-0/lisp-plus-run.sh mneme/language-program-0/programs/sum-of-squares.lp
```

```
sum of squares 1..10  = 385
closed form           = 385
agree for 1..50?      = true
338350
```

The last line is the value of the program's last form; the lines above it are what the program
`print`ed. Every example in this guide is executable; the three in `programs/` are run by the
selftest and compared with their recorded output byte for byte.

**Standing: CANDIDATE.** The specification is `PROGRAM-0-GRAMMAR-AND-SEMANTICS.md`; `program0.lisp`
executes it. Under adopted law W-02 the specification supplies the meaning, the executor only runs
it. Tested environment: SBCL 2.4.6 on Linux (the runner refuses another version). Selftest:
`bash mneme/language-program-0/run-selftest.sh` → `program0 selftest: N passed, 0 failed`.

## 1. A first program

Write `hello.lp`:

```lisp
(define (greet name)
  (string-append "hello, " name))

(greet "world")
```

Run it: `bash mneme/language-program-0/lisp-plus-run.sh hello.lp` → `"hello, world"` (a string
prints quoted as a value; `print` writes it bare).

A file is a **sequence of forms**, evaluated in order. `define` binds a name; the value of the
last form is printed. Comments start with `;`.

## 2. Definitions and lexical scope

```lisp
(define x 1)
(define (f x) (+ x 1))     ; this x is the parameter — it shadows the outer x inside f only
(list (f 10) x)            ; → (11 1)
```

Names live in **frames**. A function call makes a fresh frame under the frame the function was
*defined* in; a `let` makes a fresh frame under the current one. The innermost binding wins.
A name is bound **once per frame**: defining `x` twice at the top level is `E-REDEFINE`; defining
your own `map` at the top level is a lawful *shadow* of the prelude's.

```lisp
(let ((x 2))
  (let ((x 3)) x))         ; → 3, and the outer x is still 1
```

`let` evaluates its right-hand sides in the **outer** frame (it is a parallel let):

```lisp
(define x 1)
(let ((x 2) (y x)) y)     ; → 1
```

There is no assignment. Nothing changes a binding after it is made.

## 3. Functions are values; closures capture

```lisp
(define (make-adder n)
  (lambda (x) (+ x n)))    ; n is captured from make-adder's frame

(define add5 (make-adder 5))
(add5 10)                  ; → 15   — make-adder's frame is gone; the capture is not
```

Capture is **lexical**: a closure sees the frame it was written in, not the frame it is called from.

```lisp
(define (make-scaler k) (lambda (x) (* k x)))
(define (call-with-k f) (let ((k 1000)) (f 2)))
(call-with-k (make-scaler 3))   ; → 6, not 2000
```

A `define` inside a body makes a local helper — recursive ones included:

```lisp
(define (factorial n)
  (define (go n acc) (if (= n 0) acc (go (- n 1) (* acc n))))
  (go n 1))
(factorial 10)             ; → 3628800
```

Primitives are values too: `((lambda (op) (op 2 3)) *)` → `6`.

## 4. Lists and higher-order functions

The prelude (`prelude.lp`, written in Lisp+) gives you `map filter fold fold-right for-each range
iota repeat sum product any? all? count-if compose identity constantly square even? odd? zero?
positive? negative? nth take drop last zip`.

```lisp
(map (lambda (x) (* x x)) (list 1 2 3))   ; → (1 4 9)
(filter even? (range 1 11))               ; → (2 4 6 8 10)
(fold + 0 (range 1 101))                  ; → 5050
(fold-right cons () (list 1 2 3))         ; → (1 2 3)

(define (pipeline xs) (sum (map square (filter even? xs))))
(pipeline (range 1 11))                   ; → 220

((compose square square) 3)               ; → 81
```

Lists are proper lists. `()` is the empty list and **is a value, not a boolean**; `(car ())` is an
error (`E-TYPE`), never a silent `()`. `(map square ())` → `()`, `(fold + 0 ())` → `0`.

## 5. Conditionals, without truthiness

`true` and `false` are the only booleans. `if` needs one of them in test position and **requires an
else**; `cond` needs a clause to hold or an `else`; `and`/`or`/`not` take booleans only.

```lisp
(if (< 1 2) (quote yes) (quote no))       ; → yes
(if 1 2 3)                                ; E-TYPE: `if` needs true or false, got 1
(cond ((= 1 2) (quote a)) (else (quote b))) ; → b
(and (< 1 2) (< 2 3))                     ; → true
```

## 6. The existing semantic bridge: Kernel /0 from inside a program

Lisp+'s Kernel /0 refuses a determinacy record that carries a global confidence scalar
(requirement K0E-33). From a program you ask the kernel through its own constructor, and its
answer comes back as a **value**:

```lisp
(define plain     (kernel0/determinacy :mode :determinate))
(define confident (kernel0/determinacy :mode :determinate :confidence 0.8))

(host-value? plain)                        ; → true  — a record the kernel built
(kernel0/determinacy-mode plain)           ; → :determinate
(refused? confident)                       ; → true  — the kernel said no
(refusal-requirement confident)            ; → "K0E-33"
(refusal-law confident)                    ; → "§7.5 and Errata 0.2 §6: determinacy MUST NOT carry a global confidence, ..."
```

`programs/determinacy.lp` maps this over a list of offers and counts what the kernel admitted:

```
("plain determinate" admitted :determinate)
("with a confidence 0.8" refused "K0E-33")
("plain indeterminate" admitted :indeterminate)
("an unknown mode" refused "K0E-2")
admitted: 2 refused: 2
("K0E-33" "K0E-2")
```

Constructing a record is a **derivation**: nothing is performed. A function value handed to the
kernel is refused at the boundary (`E-BOUNDARY`) — no closure ever reaches a record. The lanes that
*perform* (Core /0, One Act, Many Acts) are not loaded by the runner; `perform`, `act`, `derive` are
simply unbound names here.

## 7. Errors

An error stops the program, prints to stderr, and exits 2:

```lisp
(define (f x)
  (+ x nosuch))

(f 10)
```
```
lisp-plus: E-UNBOUND at err.lp:4:0
  unknown name `nosuch`
  in: nosuch
  within: (+ x nosuch) · (f 10)
  frames: f
  (a name has no binding)
```

Codes: `E-READ E-SYNTAX E-UNBOUND E-REDEFINE E-ARITY E-TYPE E-ARITH E-BUDGET E-BOUNDARY` — the
closed list is in the specification §8. Locations are the line and column of the **top-level form**;
the innermost forms and the user-function frames are printed beneath. Exit codes: `0` value ·
`2` language error · `3` usage · `1` host fault (an implementation defect, labelled as such).

## 8. Execution limits, plainly

- **Why there is a budget:** unrestricted recursion. Once a function may call itself, nothing in a
  program's shape bounds its run, so the run is bounded by policy instead. **Steps:** one run may
  evaluate at most **1,000,000** forms. **Depth:** at most **4,000** nested user-function calls — a
  bound on nesting, not on how long a program or a list may be. Either exhausted → `E-BUDGET`, with
  a location. `(define (f) (f)) (f)` is refused, not run forever.
- **No tail-call elimination.** `map`/`filter`/`fold` recurse; a list longer than the depth limit
  is refused. `(sum (range 1 1000))` runs; `(map square (range 0 5000))` is `E-BUDGET`.
- **No mutation, no macros, no error handling inside a program, no input, no vectors or tables,
  no REPL.** Strings: literals, `string-append`, `number->string`, `print`.
- **Numbers** are SBCL's: integers of any size, exact ratios, double floats.
- **Reader:** `#.` is dead; a package-qualified symbol like `cl:eval` is not a name (`E-SYNTAX`),
  quoted or not, and `cl:if` is not an `if`; dotted pairs, vectors, characters and circular `#1=`
  structure are refused at the source (`E-READ`, cycle-safe); `(/ 1 0.0)` and float overflow are
  `E-ARITH`; user code is never handed to `cl:eval`.

## 9. Files

| file | what |
|---|---|
| `PROGRAM-0-GRAMMAR-AND-SEMANTICS.md` | the specification — the meaning lives here |
| `package.lisp` · `program0.lisp` | the executor: reader under the law, frames, evaluator, primitives, Kernel /0 bridge |
| `prelude.lp` | the library, in Lisp+ |
| `run.lisp` · `lisp-plus-run.sh` | the one command |
| `programs/*.lp` · `programs/*.expected` | three programs and their recorded outputs |
| `program0-selftest.lisp` · `run-selftest.sh` | the focused tests |

Governance, rulings and the rest of the construction: the repository `README.md` and
`mneme/architecture/ARCHITECTURE-0-STATUS.md`.
