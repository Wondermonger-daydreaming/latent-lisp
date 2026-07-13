# CD/0 exact final verification transcript — 2026-07-13

Factual status: exact commands and bounded observed outcomes for the final local
verification gates. Raw high-volume request/response transcripts are retained
at the referenced paths. This file is not a formal proof or a specification
amendment.

## Pinned authority and runtimes

```text
specification path: mneme/spec/CANONICAL-DATUM-SPEC.md
specification sha256: d578e86e4d411611b091cca0bed1cafac2636c0908e95447fd4a13badcab6abc
Common Lisp: SBCL 2.4.6
Python: CPython 3.11.14
```

The release generator source checkpoint was clean commit
`aed2f393781456dfd495ac5d5822bdcd58bea711`, tree
`7f8d2a2d11dd70d1143dc5c339267fe97c675670`. The corpus checkpoint was
`42a71429cfdafe63a989e3f44e706f828efab20e`, tree
`947444fde812754ac8e04bb5a0fbe29f690df3d0`. The retained full differential
checkpoint is `3aed0d991781ca7b58d53a4e08cd7747ed7e5726`, tree
`003a398a60c9535b567d93d62605ac9d471fb051`.

## Mechanical and source tests

The following source gates were executed on the final generator/runner bytes:

```text
python3 canonical-datum/tools/verify_phase0.py
python3 -m unittest discover -s canonical-datum/generator/tests -v
python3 -m unittest discover -s canonical-datum/release/tests -v
```

Observed:

- Phase 0: specification pin matched; 17/17 worked vectors; five additional
  positives; 71 negatives; 256/256 tag classifications; mutation self-tests
  detected deliberately corrupted expectations;
- generator: 27 tests, all `OK`;
- release runner: 8 tests, all `OK`, including regressions against symmetric
  noncanonical normalization and retry-AST disagreement.

## Release generation and differential

Generator command (executed twice, under hash seeds 1 and 777):

```text
python3 canonical-datum/generator/generate_corpus.py \
  --output-dir canonical-datum/generated/release-v0 \
  --seed 3439329281 \
  --positive-count 10000 \
  --negative-count 20308 \
  --mutation-sample-count 128 \
  --truncation-max-document-octets 16
```

`diff -qr` over the two output directories exited zero. Manifest SHA-256:
`2b3fee981a2db8f46a03909d8a7c1a505248875b5a8aa9686e0afcef0f8410c3`.
Corpus digest:
`83e35b3ac9641e06a6573fbec404149ca78130ca0a0ff9d550ff693dbdd819be`.

Differential command:

```text
python3 canonical-datum/release/run_generated_differential.py \
  --corpus-dir canonical-datum/generated/release-v0 \
  --batch-size 2048 \
  --timeout-seconds 120 \
  --artifacts-dir canonical-datum/evidence/generated-differential-release-v0
```

Exact observed terminal summary:

```text
CD/0 generated differential: PASS
spec sha256: d578e86e4d411611b091cca0bed1cafac2636c0908e95447fd4a13badcab6abc
manifest sha256: 2b3fee981a2db8f46a03909d8a7c1a505248875b5a8aa9686e0afcef0f8410c3
corpus sha256: 83e35b3ac9641e06a6573fbec404149ca78130ca0a0ff9d550ff693dbdd819be
release-qualified corpus: True
rows: positive=10000 classified-negative=20308 mutation=30504
negative status: normative=20302 provisional-stage=5 provisional-code=1
equality: self=10000 neighbor=10000
resource retries: 20012 exact retry/re-encodes
Common Lisp optional importer N/A (not pass): 3
unclassified mutations: both-success-identical=455 same-failure=30049 minimize-required=0
batches: 50; requests per codec: 100824
warranted cross-codec disagreements: 0
```

Retained summary SHA-256:
`66b6122d4145e97c59b931d2e90be041e7094329b1a72df7586ac7bbf3799232`.

## Final hostile/property qualification

```text
python3 canonical-datum/qualification/run_qualification.py \
  --mode default \
  --artifacts-dir canonical-datum/qualification/evidence/final-run
```

Exact observed terminal summary:

```text
CD/0 Phase-4 qualification (default): PASS
spec sha256: d578e86e4d411611b091cca0bed1cafac2636c0908e95447fd4a13badcab6abc
golden requests per codec: 353
ephemeral randomized round trips: 512
ephemeral equality/encoding properties: 513
classified hostile/resource failures: 14
resource retries: 6
warranted cross-codec disagreements: 0
Common Lisp language-specific host descriptors: 3 not applicable (not passes)
A1-A9: preserved; provisional failure stages were observed but not promoted to normative fields
Phase-3 10k/20k corpus: neither consumed nor claimed
```

The last line is an intentional scope statement: this qualification runner is
independent of the separately retained release-corpus differential above.
Final-run summary SHA-256:
`5580c47e6bce23001e93b8259e6d9c6e432c6a25dcbcb25ee298821dd93fa585`.
The run includes 152 Python tests and 2,510 Common Lisp assertions.

## Untouched v1 behavioral gate

Command:

```text
mneme/verify-all.sh
```

Observed exit status: zero. Exact suite result lines:

```text
PASS  conformance-walk              expected 7 ✓, got 7 (L1–L7 hold)
PASS  adversarial-conformance       expected 18 passed 0 failed, got 18 passed 0 failed
PASS  counterexample-closure        expected 10 passed 0 failed, got 10 passed 0 failed
PASS  boundary                      expected 9 passed 0 failed, got 9 passed 0 failed
PASS  atelier                       expected 4 pass-banners, got 4 (6 specimens + jurisdiction wing + decad + post-decad)
PASS  language-a-fixtures           expected 14 PASS + SUITE PASSED, got 14 PASS / suite-line 1
ALL FLOORS HOLD — 6/6 suites green.
```

No path outside `canonical-datum/**`, `CANONICAL-DATUM-DIVERGENCES.md`, and
the requested root implementation ledger is intended to differ from fetched
base `ae767f00975395369f9a91283a954f0963fb6724`. The final changed-path audit is
recorded in that ledger after documentation is assembled.

## Explicit residuals

- A1--A9 remain open; matching provisional fields are not normative law.
- Three Common Lisp language-specific optional importers remain N/A, not pass.
- Additional Common Lisp implementations and Python runtimes were unavailable.
- Finite mutation/inertness hooks do not prove safety against every allocator,
  FFI, syscall, reflection facility, or thread schedule.
- Canonical identity is not truth, authority, custody, authenticity, verified
  lineage, or semantic validity of record contents.
