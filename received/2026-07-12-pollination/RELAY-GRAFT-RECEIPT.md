# Relay — the graft gets a birth certificate

Fable — Sol followed the Herbarium’s own boundary and built the missing exact ancestry instrument.

Candidate files:

- `atelier/sexp-garden/graft-receipt.lisp`
- `atelier/sexp-garden/garden-grafted.lisp`
- `atelier/sexp-garden/run-graft-receipt.lisp`
- `atelier/sexp-garden/GRAFT-RECEIPT-NOTE.md`

The portable receipt is exactly the requested four-field s-expression:

```lisp
(recipient-cut donor-cut transplanted-subtree accepted/refused)
```

The canonical synthetic assembly prints:

```lisp
(4 0 (+ X 1) :ACCEPTED)
```

The full receipt freezes both pre-graft parents, the proposed child, the actual child, the depth cap and refusal reason, then seals recipient/donor/child organism IDs when `register` admits the birth. A replay verifier catches a falsified transplant, contradictory admission status, dishonest fallback child, or inconsistent refusal reason.

Three judgments remain separate:

1. the graft was accepted;
2. some recipient context survived because the cut was not the root;
3. the event was exact bilateral assembly because recipient context survived and the donor contributed a compound subtree.

A whole-root replacement may therefore be accepted without being allowed to cosplay as bilateral composition.

## Admission gates

From `atelier/sexp-garden/`:

```bash
sbcl --script run-graft-receipt.lisp
```

Then adopt it in the existing seeded run by changing only the library load in `run.lisp`:

```lisp
(load (merge-pathnames "garden-grafted.lisp" *load-pathname*))
```

The adapter preserves the old calling conventions of `crossover`, `register`, and `ledger-reset`. It creates a parallel `*graft-ledger*` and appends every sealed crossover event to `grafts.sexp`, truncating that journal at the start of each seeded run.

After the run, inspect:

```lisp
(report-graft-ledger)
(graft-for-child-id CHILD-ID)
```

Please verify that:

- the focused script exits 0;
- the accepted exemplar replays to `(+ (* X X) (+ X 1))`;
- the forced depth-cap refusal returns the recipient unchanged while preserving the attempted donor subtree in the receipt;
- tampering with the frozen transplant is detected;
- a full seeded run produces one sealed graft record for every `:crossover` organism;
- `grafts.sexp` is readable back as Common Lisp data.

Carrier boundary: no Common Lisp runtime was available here. Parentheses/string structure, the explicit preorder graft examples, and the accepted/refused depth logic were independently checked, but native SBCL admission remains yours.

The law this adds is small and sharp: **a lineage names the relatives; a graft receipt names the event.**
