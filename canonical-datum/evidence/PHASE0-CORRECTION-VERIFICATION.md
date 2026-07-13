# CD/0 Phase 0 correction verification

This follow-up corrects the fixture architecture after an independent audit.  It
does not replace the historical initial receipt in `PHASE0-VERIFICATION.md`.

## Corrected obligations

| ID | Obligation | Evidence | Status | Residual boundary |
|---|---|---|---|---|
| P0C-1 | Express §28.1 octet and §28.2 host rows | Draft 2020-12 `oneOf` schema and five host rows | satisfied | host descriptors are fixture metadata, not serialized host objects |
| P0C-2 | Couple failure code to category | schema unions plus verifier map | satisfied | A1/A2 provisional rows remain marked |
| P0C-3 | Detect fixture semantic drift | reviewed negative-manifest SHA-256 and wrong-code mutation self-test | satisfied | finite reviewed pin, not an independent decoder |
| P0C-4 | Enforce canonical `expected_decoded` record order | recursive check and reversed-order mutation self-test | satisfied | no codec decode occurs in Phase 0 |
| P0C-5 | Exercise seed equality/order/boundaries | five added positives and distinct-pair manifest | satisfied | rational construction AST remains blocked by A7 |
| P0C-6 | Cover deterministic resource retry and precedence | added canonical tight-budget/retry and minimized ordering/rational cases | satisfied | A3/A8/A9 and provisional stages remain open |

## Exact verification

```text
$ python3 canonical-datum/tools/verify_phase0.py
spec sha256: d578e86e4d411611b091cca0bed1cafac2636c0908e95447fd4a13badcab6abc
worked vectors: 17/17 exact and grammar-derived encodings agree
additional positives: 5; equality classes and distinct pairs valid
negative vectors: 71 schema-valid and equal to reviewed finite manifest pin
mutation self-tests: wrong failure code and reversed decoded record order rejected
type tags: 256/256 classified; all 10 assigned tags exercised; reserved/forbidden boundaries present
sha256 f7e3a26760350f021041bd0d492da95ce3be20c27d5410e49d29370128c35dce  canonical-datum/vectors/cd0-positive.jsonl
sha256 6000f52e1559ea579d866eca25fd25e443f07ac35cc65d3ff7166499e64de4a5  canonical-datum/vectors/cd0-negative.jsonl
sha256 ee966c62c49e2f64f6378901e1bc33db352a5b2a7d69f0dd606947eb02e73d27  canonical-datum/vectors/cd0-distinct-pairs.json
sha256 ac0e8c60ca8ca50ef42d334b987226cea5f85e3ca4d4c27d4be6f259075c5c98  canonical-datum/vectors/cd0-budgets.json
sha256 4ae8789b791128591dae47c811d99049e7d5fffee4fdc65857633874409e5e13  canonical-datum/schema/cd0-fixtures.schema.json
```

Runtime boundary: CPython 3.11.14 with `jsonschema` 4.26.0.  The Common Lisp and
Python codecs had not been compared and no seed implementation source was read.
