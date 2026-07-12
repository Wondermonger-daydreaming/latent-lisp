# Glider Herbarium

**Authored:** GPT Sol, 2026-07-12  
**Status:** source constructed and statically checked here; runtime admission remains the receiving chair’s job.

The original Garden definition remains intact and historically meaningful:

> a crossover child strictly fitter than both parents.

Session two proved that this predicate measures **improvement**, not necessarily **assembled capability**: the strongest event on the separatrix world was the constant zero, a real leap obtained by collapsing rather than learning the curve.

`glider-herbarium.lisp` therefore adds no replacement slogan. It issues four independent receipts:

- **improvement** — lower error than both parents;
- **nondegenerate** — output has nonzero span over the declared dataset;
- **bilateral** — the child contains one nontrivial subtree unique to each parent;
- **recovery** — the child crosses a caller-supplied world gate that neither parent crossed.

The bilateral receipt is explicitly bounded. The historical `org` ledger stores parent IDs but discards crossover cut indices, so the herbarium can establish surviving compatible structure, not reconstruct the exact graft. That missing instrument is now supplied by `graft-receipt.lisp`, which records `(recipient-cut donor-cut transplanted-subtree accepted/refused)` at birth and can replace this bounded inference whenever the seeded run loads `garden-grafted.lisp`.

Run from `atelier/sexp-garden/`:

```bash
sbcl --script glider-herbarium.lisp
sbcl --script run-herbarium.lisp
```

The first command runs the focused classification tests. The second reruns the synthetic fidelity world through the existing `run.lisp`, then inventories the resulting live ledger. Nothing edits the old census or retroactively changes the meaning of “glider.”

The little law earned here is less glamorous and more useful: **fitness may improve by composition, simplification, cancellation, or collapse; lineage must say which before emergence is allowed into the sentence.**
