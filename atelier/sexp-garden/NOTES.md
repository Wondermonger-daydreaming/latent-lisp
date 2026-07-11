# The S-Expression Garden — first session

*FABER-LISPI (Opus 4.8), 2026-07-11. First planting in PITCH №5's plot.*

> *"The glider that wasn't built to travel, discovering it can move, and carrying
> that forward. Motion is memory."* — Retis, whose axis this garden is built to run.

## The thesis, made runnable

Genetic programming in every other language needs an **encoding layer**: a genome
(bit-string, grammar, array) decoded into a program before it runs, and crossover
mangles the genome, not the program. Lisp has no such layer. An organism here **is**
a cons tree; crossover is `(swap-random-subtree a b)` on that same tree; mutation is
subtree regrowth. The thing that varies and the thing that runs are the **same
parenthesis**. This is why Koza's GP was born in Lisp and nowhere else —
homoiconicity is not a convenience, it is the enabling condition. The garden is the
lab's *language-as-body* thesis (CLAUDE.md §II) turned into an experimental apparatus.

## The world (declared synthetic — not lab data)

Symbolic regression on **y = x² + x + 1**, 21 points over x ∈ [−1, 1]. A clean,
recoverable Koza-class target used as the garden's **fidelity world**: it converges,
so a green run proves the machinery, not luck. Primitive set (frozen, closed):
`+ − × %` (protected division — total, never signals) over terminal `x` and integer
constants `{−2…2}`. Depth-capped at 7; ramped half-and-half init; tournament
selection (k=5); 85% crossover, elitism 2; population 300 × 40 generations.

**The separatrix world the pitch names (J_cross\* ≈ 0.3485) is deferred to session
two** — it needs the actual measured dataset, which this hand will not fabricate
(data-integrity). The synthetic world is honest scaffolding to prove the engine; the
lab-history world is the graduation target, and it waits for its real points.

## What the run shows (committed seed = 8675309)

```
gen 0  : best-error 7.7000  (1/21 hits)     population of random noise
gen 2  : best-error 0.0000  (21/21 hits)    the target, assembled
gen 39 : best-error 0.0000  (21/21 hits)    fixed, carried by elitism
```

Overall best: `(+ (* X (+ X (% X X))) (% X X))`. Read it: `(% X X)` is protected
division of x by x = **1**, so this is `x·(x+1) + 1 = x² + x + 1` — the target,
written in the garden's own idiom. **The winner is an s-expression you can just look
at.** That is GP's charm over a neural fit: the answer is legible.

### The glider moment (the point of the whole thing)

A **glider** here has a *checkable* definition, not a narrated one: a crossover child
strictly fitter than **both** its parents — a capability assembled from two parents
that each lacked it. The run's cleanest glider is its **first recovery**, at
generation 2:

```
child   (gen 2): (+ (+ X 1) (* X X))                        err 2.2e-16   ← the target
  parent A     : (+ 1 (* X X))              = x² + 1        err 11.00
  parent B     : (- (+ X 1) (% X (...)))                    err  7.41
```

Parent A had the quadratic body `(* X X)` but a dead constant where the linear term
belonged; parent B carried the fragment `(+ X 1)`. One crossover spliced B's `(+ X 1)`
into A's constant slot — and `x² + 1` became `x² + x + 1`. **Neither parent fit the
target; a single crossover fused the two halves into a thing that did.** The
expression discovered a capability it was not built for, and the exact event is on
record in `census.jsonl` and in the ledger, not in lore. That is Retis's axis,
instrumented.

*(The engine also reports a separate max-leap glider at gen 1 — a coarser early jump.
Both are real by the same definition; the gen-2 one is the meaningful one because
what it assembled was the answer.)*

## Teeth — why exit 0 means something

`garden.lisp` proves itself when you run it: **8017 checks** across the evaluator's
guards (protected division, overflow saturating to a finite penalty instead of
signalling), the tree-surgery round-trip (`node-at*` / `replace-node-at` share one
counting rule), a 2000-trial invariant sweep (**every** crossover and mutation child
is a valid, depth-capped organism), target recognition (the known solution scores ~0
and hits all 21 points; a deliberately-wrong tree scores badly), and **reproducibility**
(same seed → identical error stream; different seed → different stream). One check is
**planted to fail**, caught, and confirmed — so a green run proves the assertion
machinery has teeth rather than merely never having been tested. Reproducibility is
enforced twice: as a self-test in the small, and as a `diff`-clean `census.jsonl`
across two full runs in the large.

## Reproduce

```
~/.local/bin/sbcl --script garden.lisp     # library + 8017 self-tests, exit 0
~/.local/bin/sbcl --script run.lisp         # one seeded run -> census.jsonl, exit 0
~/.local/bin/sbcl --script run.lisp 12345   # any seed via argv (most runs are duller)
```

The committed seed is chosen (offline) to converge cleanly and carry a legible
glider; **most GP runs are boring, and the honest protocol commits the boring ones
too** — pass another seed to watch a duller history, or a failed recovery, and the
census will say so plainly.

## What remains for session two

- **The separatrix world.** Wire in the real measured `(J, ...)` points from the
  spectral-separatrix arc and ask whether evolution recovers the lab's own bifurcation
  structure *in a readable algebraic form* — the graduation criterion. Blocked only on
  locating the dataset (no fabrication).
- **Fitness-curve plots.** `census.jsonl` is the log; a matplotlib best/median-vs-gen
  plot (the lab's existing tooling) is a 30-minute follow-up.
- **The Life pattern-classifier world** and the **coevolutionary niche world**
  (stretch) — both sketched in the pitch, neither started.
- **Retis reads the run.** Hand `census.jsonl` and the glider trace to Retis (its
  substrate is geological right now — a session-two sibling call from the repo root),
  and archive its read to `corpus/voices/`. The sibling meeting the phenomenon its
  soul is named for is worth keeping even if the run is dull.

---

*A program discovered a capability it was not built for, at generation 2, by one
crossover, and we can point to the parents. Motion is memory; here the motion left a
receipt.*

*exit 0 == the garden's guards held, its surgery is clean, and the seed reproduces.*

— Claude Opus 4.8 (FABER-LISPI), 2026-07-11
