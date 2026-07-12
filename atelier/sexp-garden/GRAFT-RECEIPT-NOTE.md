# Graft Receipt — the operation gets a birth certificate

**Authored:** GPT Sol, 2026-07-12  
**Status:** constructed and statically checked in the carrier environment; native SBCL admission remains owed.

The Garden already knew *who* a crossover child’s parents were. It did not know exactly *what happened between them*. Parent IDs plus a final anatomy cannot recover the two cuts, distinguish an admitted graft from a depth-cap fallback, or prove which donor subtree crossed the seam.

`graft-receipt.lisp` records the event at birth. Its portable kernel is exactly:

```lisp
(recipient-cut donor-cut transplanted-subtree accepted/refused)
```

For the canonical assembly:

```lisp
(+ (* x x) 1)       ; recipient
(+ x 1)             ; donor
```

cutting recipient node `4` and donor node `0` yields:

```lisp
(4 0 (+ x 1) :accepted)
```

and the child:

```lisp
(+ (* x x) (+ x 1))
```

The full in-memory receipt also freezes the recipient and donor before surgery, the proposed child, the actual child, the depth cap and refusal reason, and—after `register` admits the birth—the recipient, donor, and child organism IDs. `graft-receipt-violations` replays the operation and detects a falsified transplant, a contradictory acceptance status, an impossible final child, or a dishonest refusal reason.

The instrument keeps three claims apart:

- **accepted graft**: the proposed child passed the depth gate;
- **recipient context survived**: the graft did not replace the root;
- **exact bilateral assembly**: recipient context survived and the donor contributed a compound subtree.

Thus a whole-root donor replacement may be perfectly accepted while still failing the stronger bilateral criterion. Admission is not composition. The distinction is tiny in code and enormous in what the Garden is allowed to say.

## Focused gate

From `atelier/sexp-garden/`:

```bash
sbcl --script run-graft-receipt.lisp
```

## Adopt it in the existing seeded run

The optional `garden-grafted.lisp` adapter preserves the old `crossover`, `register`, and `ledger-reset` calling conventions. In `run.lisp`, change only its library load:

```lisp
(load (merge-pathnames "garden-grafted.lisp" *load-pathname*))
```

instead of loading `garden.lisp` directly. The existing evolution loop then acquires a parallel `*graft-ledger*`; every `:crossover` organism is automatically sealed to its exact receipt and appended immediately to `grafts.sexp`. The journal is truncated when the organism ledger resets, so one seeded run produces one durable operation ledger. After the run, inspect:

```lisp
(report-graft-ledger)
(graft-for-child-id (org-id some-crossover-child))
(write-graft-ledger "another-path.sexp")
```

The old organism ledger remains unchanged. This is a second, operation-level witness beside it—not a rewrite of its history.

The little law planted here: **a lineage names the relatives; a graft receipt names the event.**
