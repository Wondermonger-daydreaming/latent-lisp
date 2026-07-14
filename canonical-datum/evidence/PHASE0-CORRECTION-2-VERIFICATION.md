# CD/0 Phase 0 correction 2 verification

An independent review of correction commit `e86ecfb` found that the positive
verifier enforced `equality_class -> canonical_hex` but not the inverse.  It
therefore accepted two class labels for one canonical document.

The follow-up enforces both directions and adds a mutation self-test that splits
the duplicate integer-64 construction into a second class.  The corrected
verifier reports:

```text
worked vectors: 17/17 exact and grammar-derived encodings agree
additional positives: 5; equality classes and distinct pairs valid
negative vectors: 71 schema-valid and equal to reviewed finite manifest pin
mutation self-tests: wrong failure code, reversed decoded record order, and split equality class rejected
```

This is finite fixture evidence, not a formal proof of encoder injectivity.
