# AUDIT-0001 — Preflight gates (engineering-invariants; pass/fail, no API spend before all pass)

Each gate is an *observation* to be produced, not a claim to be admired.
Log pass/fail per gate as ledger events with evidence links.

 1. Determinism: same seed → byte-identical items.jsonl (run twice, diff).
 2. Condition equivalence: every rendered condition (A,B,C,D,E) of every
    item normalizes to the same canonical AST under strip+parse.
 3. Tree-space pairing: every intervention (cut, corruption, insertion)
    targets the same canonical node across all conditions of an item.
 4. Insertion validity: every insertion path resolves to an existing node
    that admits a child at the stated position.
 5. Target inferability: every scored task's ground truth is uniquely
    determined by the material shown to the model (delimiter-completion:
    the closer suffix is forced by balance + boundary tags; synthesis:
    the AST is supplied).
 6. Token accounting: prompt lengths measured with the actual tokenizer of
    each model under test, ON THE PROMPT SENT, recorded per item per
    condition in items.jsonl; max cross-condition spread ≤ 2%.
 7. Controls present: B (anonymous), D (consistent-arbitrary identity),
    and the mismatch probe set all generate and parse.
 8. Judge coverage: the judge parses 100% of generated items AND every
    specimen in corpus/design/ (currently FALSE for the Python toy reader
    — this gate is expected to force E4 or an explicit synthetic-only
    scope declaration before spend).
 9. Stimulus honesty: items are labeled `synthetic-sexpr` unless produced
    by the arity-aware executable generator (not yet built).
10. Scorer self-test: FakeModel fixtures (perfect / null / malformed /
    checksum-blind) produce exactly the known scores through the full
    scoring path, including per-condition and per-depth aggregation.
