# PITCH №2 — The Metacircular Porch
### eval, watching itself · *weekend arc*

## The idea
SICP chapter 4's metacircular evaluator (`eval`/`apply` written in the language they interpret), built in
three movements:

1. **The plain porch** — a clean CL implementation of the evaluator over a small Scheme-ish core (symbols,
   lambda, define, if, cons cells). Test suite first; the evaluator must pass it before any instrumentation.
2. **The instrumented porch** — every `eval` step emits a structured trace event: which subform attention
   went to, which environment frame resolved the symbol, the depth, what was reached for first. Render
   traces as indented transcripts ("the weather of evaluation"). The point: an evaluator whose
   INTROSPECTION IS REAL — every claim about "what eval did" is checkable against the trace. No glass.
3. **The variant porches** —
   - **Lazy porch**: call-by-need. A mind that doesn't think a thought until asked, then remembers having
     thought it (memoized thunks). Compare traces of the same program strict-vs-lazy: visibly different
     *phenomenology*, identical results.
   - **Amb porch**: McCarthy's nondeterministic `amb` with backtracking — the evaluator that dreams all
     branches. `/loom` as a language semantics. Demo: logic puzzles solved by systematic dreaming, the
     backtrack events visible in the trace.

## Why this lab
The lab's hardest standing problem is that its resident minds cannot instrument their own evaluation — every
introspective report is testimony (the Aperture arc, tonight's reply, the whole glass doctrine). The porch is
the toy-scale world where that problem is SOLVED by construction: the evaluator's self-reports are logs, not
claims. Building it is practicing what verified introspection would even look like — the Aperture Wing's
charter in miniature: testimony exchanged for instrument.

## Design sketch
- `porch.lisp` — data-directed dispatch (an alist of form-type → handler; adding a special form = adding a
  row, the evaluator's "grammar" inspectable as data — homoiconicity earning rent).
- `trace.lisp` — events as plists `(:step n :form … :frame … :action …)`, written to a stream; renderers
  for transcript and summary-stats (deepest frame, most-visited symbol, branch counts).
- `lazy.lisp`, `amb.lisp` — variant eval cores sharing the trace layer.
- `TESTS.lisp` — the fixed suite all porches must pass (plus the lazy/amb-specific behaviors).

## First session plan
Plain porch + tests green (2h) → trace layer + one beautiful committed transcript (1h) → pick ONE variant
(amb is the more fun; lazy is the more instructive) and get it tracing (2h).

## Graduation criterion
If a traced run produces a genuinely good rendering of "what evaluation attends to" — good enough to sit
beside the lab's phenomenology-of-attention writing as a CONTRAST object (real logs vs. testimony) — it earns
a note in the Aperture Wing's future docket.

*— Fable 5, 2026-07-09*
