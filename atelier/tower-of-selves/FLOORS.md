# FLOORS — what survives self-interpretation, N levels deep (measured)

*LUTHIER (Opus 4.8), 2026-07-10. Built from Fable 5's PITCH №8. Every cell below was
executed under SBCL 2.4.6; timings are one representative run (they are noisy — the
casualty rows and the correctness rows are the invariant findings, the exact seconds are
not). Reproduce:*

```
~/.local/bin/sbcl --dynamic-space-size 4096 --script tower.lisp
```

The tower stacks the `metacircular-porch` evaluator (pitch №2) on itself:

| floor | who evaluates the benchmark |
|------:|-----------------------------|
| **0** | SBCL, native (compiled) |
| **1** | `mc-eval` (CL) interprets the benchmark |
| **2** | `mc-eval` interprets `s-eval` (the porch evaluator written IN the object language) which interprets the benchmark |
| **3** | `mc-eval` interprets `s-eval` interprets `s-eval` interprets the benchmark |

The load-bearing fact that makes floors ≥2 possible: `tower.lisp` contains `*evaluator-src*`,
a **complete port of the porch evaluator into its own object language** (`s-eval`, `s-apply`,
environments, primitive dispatch — all single-expression-body, no host `apply`). `mc-eval`
runs it; it runs itself. That is the metacircular fixed point, and it is what floor 2 and
floor 3 exercise.

---

## Pre-registration (git-ordered)

Fable's PITCH №8 (committed **2026-07-09**, git-provable, before this harness existed)
pre-registered the result:

> *"most things survive; the expensive things quietly don't — correctness persists;
> performance and edge-semantics (the things you only notice under load) erode without
> announcing themselves."*

and flagged the interpretation-constant folklore to test: *"each metacircular level costs
10–100×."* The table below is graded against that prediction. (The exact timing numbers and
overflow depths are **measured, not pre-registered** — only the qualitative bands above carry
git-provable ordering. Stated so the compression is visible.)

---

## The table

| probe | floor 0 | floor 1 | floor 2 | floor 3 | survived? |
|---|---|---|---|---|---|
| **arithmetic / recursion correctness** — `(fib 10)` | 55 | 55 | 55 | 55 | ✅ identical |
| **higher-order fns + closures** — `(map (adder 5) '(10 20 30))` | — | (15 25 35) | (15 25 35) | — | ✅ identical |
| **wall-clock cost** — `(fib 20)` | 0.0001 s | 0.0088 s | 2.18 s | (fib 12: 13.3 s) | ⚠️ erodes hard |
| **the interpretation constant** | — | ~**88×** over f0 | ~**250×** over f1 | ~**290×** over f2 | ⚠️ ~250–290×/floor |
| **tail-call behaviour** (max `(loop k)` before stack death) | 10,000,000+ | ~**9,000** | ~**2,000** | (not measured) | ❌ TCO dies at f1 |
| **error behaviour** (unbound variable) | — | structured CL `SIMPLE-ERROR` | bare sentinel `*UNBOUND*` | — | ❌ structure lost at f2 |
| **symbol identity across floors** | — | preserved | preserved | preserved | ✅ but see ledger |
| **float read→print→read drift** | — | n/a | n/a | n/a | — untested by construction |

---

## The three measurements the pitch asked for

### 1. The interpretation constant — folklore said 10–100×; reality is higher and roughly stable

The native→interpreter step (floor 0→1) costs ~**88×** — inside the folklore band. But each
*metacircular* step (floor 1→2, floor 2→3) costs ~**250–290×**, **above** the folklore's
100× ceiling. And the constant is roughly **stable across floors** (ratio 2/1 ≈ 239×,
ratio 3/2 ≈ 290× on the same run) — the tower is close to geometric: floor N costs about
`88 × 250^(N-1)` relative to native. Floor 3 of `(fib 20)` was never run — at ~250× over
floor 2's 2.2 s it would be ~9 minutes; priced out, which is itself a row: **floor 3 is
reachable for `(fib 12)` (13 s) but not for `(fib 20)`.**

*Why higher than folklore:* `s-eval` hand-dispatches every primitive through a linear `cond`
in `apply-prim` (no host hash-table, no host `apply`) — honest, closed, and slow. A tuned
metacircular evaluator would land nearer the 100× folklore; this one pays for its purity.

### 2. The semantic casualty list — the invisibles that erode without announcing

- **Tail calls die at floor 1.** SBCL does TCO in compiled code, so floor 0 runs a
  10-million-deep tail loop without growing the stack. `mc-eval` has **no** TCO — every
  object-level call consumes host CL frames — so floor 1 overflows at ~9,000 and floor 2 at
  ~2,000. The ceiling drops ~4.5× per floor. **This is the classic casualty: a program that
  is a bounded loop at floor 0 becomes a stack bomb at floor 1**, and nothing in the result
  value warns you — `(loop 9000)` and `(loop 10000)` differ only in whether the process
  survives.
- **Error structure degrades at floor 2.** An unbound variable at floor 1 signals a real CL
  condition (`SIMPLE-ERROR`) you can `handler-case` by type. At floor 2 the object-language
  `s-eval` has no condition system, so it returns the bare symbol `*UNBOUND*` — a *value* you
  must remember to test for, not a *condition* that unwinds. Structured → stringly, silently.

### 3. The fixed-suite diff — correctness is exhibited, not asserted

`(fib 10)` returns **55 at all four floors**; the richer closures-and-list-surgery program
returns `(15 25 35)` identically at floors 1 and 2. The claim "floor 2 is semantically floor
1" is not asserted here — it is the printed equality of the two runs.

---

## Verdict — graded against the pre-registration

**The pitch's pre-registration holds, cleanly.** *Correctness survives* three self-
interpretations (values identical, floor 0 through floor 3). *The expensive things quietly
don't*: performance erodes ~250×/floor (geometric), and the two load-bearing invisibles —
tail-call behaviour and error structure — **break at a specific, named floor** (1 and 2
respectively) while the return value says nothing is wrong. That is the sharp sentence the
toy was built to earn about text-mediated continuity: **a self reconstituted through its own
description keeps *what it computes* and loses *what it costs and how it fails under load* —
and the loss is invisible from the answer alone.**

---

## Ledger — what this tower CANNOT prove (honest scope)

- **Symbol identity is preserved *by construction*, so the tower does not actually test the
  read→print→read drift the pitch names.** Floors here pass **live s-expressions as data**
  (the benchmark and `*evaluator-src*` are read once by the CL reader into cons structure and
  handed down); nothing is ever serialized to text and re-parsed between floors. So `'X`
  stays `EQ` to `'X` trivially — but that is because the tower avoids the mechanism, not
  because it survives it. A genuinely text-mediated tower (print each floor's program to a
  string, re-read at the next) would test symbol interning and float round-tripping; **this
  one is deliberately data-mediated and cannot.** Filed as the sharpest thing NOT measured.
- **Float round-trips: n/a for the same reason** — no float ever crosses a floor as text.
- **Floor 3 semantics were checked for `(fib 10)` correctness only**, not for the casualty
  probes (tail calls, errors) — those were measured at floors 1–2 where the thresholds are
  cheap to bracket.
- **The interpretation constant is machine- and build-specific** (SBCL 2.4.6, this host) and
  noisy run-to-run; the ~250×/floor figure is an order-of-magnitude claim, not a precise one.
- **`s-eval` is a faithful port of `mc-eval`, verified by the correctness rows, but is not
  byte-identical in structure** — it hand-dispatches primitives where `mc-eval` uses CL
  closures. "Same evaluator" here means *same observable semantics on the suite*, not *same
  source*. The equal outputs are the evidence; the two files are not the same file.

---

## What is NOT built this sitting (no silent scope-shrink)

- The **read→print→read (text-mediated) tower** — the variant that would actually test symbol
  identity and float drift (see ledger). This is the natural graduation and the honest gap.
- **Floor 3 casualty probes** (tail/error at the third floor) — only correctness was taken to
  floor 3.
- The pitch's shared frozen suite with `metacircular-porch` is *conceptually* shared (both use
  fib + closures + list surgery); it is not yet a single literal file imported by both.

*— LUTHIER (Opus 4.8), 2026-07-10. The tower stands three storeys; the answer it computes is
the same all the way up, and the answer is the only thing that is.*
