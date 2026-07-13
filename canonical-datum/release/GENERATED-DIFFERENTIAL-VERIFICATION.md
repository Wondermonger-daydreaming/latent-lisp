# CD/0 generated differential verification

Date: 2026-07-13
Factual status: executable tooling verification; **not** final release-corpus
evidence.

## Pinned boundary

- Specification: `mneme/spec/CANONICAL-DATUM-SPEC.md`
- Required/observed SHA-256:
  `d578e86e4d411611b091cca0bed1cafac2636c0908e95447fd4a13badcab6abc`
- Divergences: A1--A9 remain open.  Provisional fields were not promoted.
- Oracle boundary: neither codec was treated as normative for the other.

## Small-corpus executable check

The committed test suite creates a generator test-mode corpus with 64 positive
rows, 512 classified negative rows, 10 mutation source samples, and a generated
mutation-candidate set.  It then checks provenance/tamper refusal and executes
all rows through both real process adapters over multiple bounded batches.

Exact commands:

```sh
python3 -m unittest discover -s canonical-datum/release/tests -v

python3 canonical-datum/generator/generate_corpus.py \
  --output-dir /tmp/cd0-release-runner-evidence-v3-20260713/corpus \
  --seed 20260713 \
  --positive-count 64 \
  --negative-count 512 \
  --mutation-sample-count 10 \
  --truncation-max-document-octets 6 \
  --allow-small \
  --allow-dirty-source

python3 canonical-datum/release/run_generated_differential.py \
  --corpus-dir /tmp/cd0-release-runner-evidence-v3-20260713/corpus \
  --allow-small-corpus \
  --batch-size 256 \
  --timeout-seconds 120 \
  --artifacts-dir /tmp/cd0-release-runner-evidence-v3-20260713/artifacts-final
```

Observed result:

- Unit/integration tests: 6 passed in 2.813 seconds.
- Generator: `cd0-corpus-generator/3`; test-mode dirty-source override was
  explicitly recorded because the release-runner files were not yet committed.
- Manifest SHA-256:
  `66efcaf7a6465e13a2fd6e2ed41e38a064093cd9b08b0c9ff437cb7956fd3750`.
- Corpus SHA-256:
  `f36f69ea5b387d47b7bd42441fa83230af2e7a9a49977384990e5417c1d04d3d`.
- Retained summary SHA-256:
  `ee59917e644cf867a4dd9b03fd08a29918a1c1a97052162d2ab83d5f4827c2b6`.
- Rows: 64 positives; 512 classified adversarial negatives; 523 unclassified
  mutation candidates; 9 host scenarios; 14 resource-boundary scenarios.
- Negative status: 506 normative; 5 provisional-blocked-stage; 1
  provisional-blocked-code.
- Minimization provenance: 303 authored-primary-template; 204
  byte-deletion-primary-minimal; 5 host-graph-scenario.  The runner independently
  rechecked all 204 byte-deletion proof shapes and matched the manifest count.
- Per implementation: 1,443 requests in 6 bounded batches; 128 equality
  judgments; 216 exact retry/re-encodes.
- Host applicability: 509 Common Lisp negative executions, 512 Python
  executions, and exactly 3 Common Lisp N/A rows which were not counted as
  passes.
- Mutations: 5 identical successes; 518 identical failure triples; 0
  minimize-required disagreements.
- Warranted comparison issues: 0.
- Runner SHA-256 at this run:
  `4d3031d9240833304dee08a68e89fabc6fdafd19b3efd4fa3e5410432084b9fb`.
- Python adapter SHA-256:
  `3b1d8017ed3a6cad375b6604e9fdcf2c01b9bdc5bccf3b336f95140abaf71db9`.
- Common Lisp adapter SHA-256:
  `5caa574534c3dc0d1975138abb228e6735807ca20dcc7da1c4c7c95887cc092c`.

The test-mode source-worktree transcript is retained in `summary.json`; it is
dirty and overridden by design, so this run cannot be mistaken for release
evidence.  The runner separately refuses a release manifest unless
`clean_before=true`, `status_before=[]`, and both override flags are false.

## Release evidence still required

This file does not claim the release floor ran.  Final integration must retain
the summary/artifacts from at least 10,000 positive and 20,308 negative rows,
including at least 20,000 mechanically demonstrated primary-minimal rows,
record the final corpus and artifact hashes, and link that
evidence from the implementation ledger/receipt.
