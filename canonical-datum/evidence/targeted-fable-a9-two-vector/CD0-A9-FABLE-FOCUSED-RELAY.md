# Paste-ready relay to Fable — focused A9 two-vector re-verification

Please perform only the focused two-vector re-verification returned under Fable
protocol `49b3cf88`, report commit `40462613`. The report copy used by the
implementer has SHA-256
`67d6c2923f8ff93946dfce141696592826b25927249e0089dcbbf6e5a0f5263b`.
All other findings passed in the targeted review and were not reopened.

Status submitted: **eligible for Fable’s focused two-vector re-verification**.
This is not a claim of merge eligibility or merge completion.

Please verify only:

1. `canonical-datum/vectors/cd0-errata-0.1.json` contains exactly these two new
   permanent rows, in the existing schema and data-driven `runtime-encode` path:

   - ID `cd0-errata-a9-runtime-seq-unit-depth-one`; AST
     `{"t":"seq","items":[{"t":"unit"}]}`; sole override
     `{"max_depth":1}`; expected status `ok`; canonical hex
     `4c50434400300100`.
   - ID `cd0-errata-a9-runtime-seq-unit-nodes-one`; the same AST; sole override
     `{"max_nodes":1}`; expected status `ok`; canonical hex
     `4c50434400300100`.

2. Both rows execute through both existing generic codec adapters. Retained
   response lines are in
   `canonical-datum/evidence/a9-two-vector-2026-07-13/hand/`; both Common Lisp
   and Python return the exact expected hex for both IDs. No codec core or
   adapter semantic source changed in this delta.

3. Arithmetic was mechanically recomputed from runner output:

   ```text
   promoted operations: 37 -> 39; A9: 5 -> 7
   hand requests/codec:  465 -> 467
   release requests:     100,861 -> 100,863 per codec
   Phase-0:              71 classified = 66 octet + 5 host
   Python:               71 executed, 0 N/A, 0 failures, 0 skips
   Common Lisp:          68 executed, 3 N/A, 0 failures, 0 skips
   ```

4. Semantics and unrelated paths are unchanged. The hand historical comparator
   found zero canonical-octet, normalized-datum, equality-result, and historical
   disposition changes. The release gate compared 10,000 valid rows with zero
   canonical-octet, abstract-datum, decoded-AST, or equality-class changes.
   Projection hash remained
   `21399286466dd5c85c95a591c750d00799a997677c6c8357b6287e683ad8aa58`.
   `mneme/` is unchanged from audited integration tip `baeecd5e…`, and v1 is
   6/6 green.

5. Publication is descendant-only, non-force, and leaves `main`, original
   audited tips, first successor commits, and Fable review history unchanged.
   Verify the exact remote identities and ancestry in the accompanying remote
   read-back receipt.

Primary review files:

- `CD0-A9-TWO-VECTOR-DELTA-RECEIPT.md`
- `CD0-ERRATA-IMPLEMENTATION-LEDGER.md` (focused return addendum)
- `CD0-ERRATA-VERIFICATION-TRANSCRIPT.md` (focused addendum)
- `canonical-datum/evidence/targeted-fable-a9-two-vector/FABLE-CD0-TARGETED-VERIFICATION-REPORT.md`
- `canonical-datum/evidence/targeted-fable-a9-two-vector/cd0-errata-0.1.json`
- `canonical-datum/evidence/a9-two-vector-2026-07-13/hand/summary.json`
- `canonical-datum/evidence/a9-two-vector-2026-07-13/release/summary.json`
- `canonical-datum/evidence/a9-two-vector-2026-07-13/qualification/summary.json`
- the focused archive and checksum manifest named in the archive receipt

Key hashes:

```text
old vector 55725e14e763075a8866be9da8be9f8647b5b06803e1fea6f661068d87651ddc
new vector 731a74ed61352200d378771f43b747d64bfcc0dea793b116d25b0b888ee11bc3
hand       8dd3156abfbf14ca15c90e64d539ca022d3f930a42f0adabaf943458c4641078
release    c229e377ef160b7038b1a901630cb440a08666d39f8737d20c4b2b77ce1e3c2e
qualification 0e8abf173dffea60f072c6b20fca48a8cb178fabfa79308e8c02bedfb4a72a86
corpus manifest 101cd0d59e6ad2dad5d9aff4d3179936ac393ad32a9be1736453a0b8cc4b8d92
corpus digest   62a18766d59e9144d6beb1371d3b2886ffc35df511f7ec32a85f0be8af4b2b58
```

Please return a focused PASS or the smallest exact remaining witness. Do not
repeat the original full audit unless this delta is shown to change bytes,
equality, accepted documents, generator semantics outside the two authorized
vectors, v1, or unrelated source.
