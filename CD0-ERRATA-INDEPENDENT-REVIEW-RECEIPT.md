# CD/0 Errata 0.1 targeted independent review receipt

Date: 2026-07-13
Reviewer identity: two fresh read-only Codex sub-reviewers, not Fable
Reviewed envelope: `edb809f30b93ea95512be6e4def54478ac9f3bd4`
Envelope tree: `99bc35f2f43b0c8ce2090320731cb8602091d288`
Archive source: `168470c4dde7a83eeec353ee584801fb69155873`
Archive-source tree: `24b571f3430d037def1ef2d819a0b7c9e80a9470`
Audited base: `baeecd5e0347435b9e1362000344f46ea441c6ec`

## Verdict

PASS. No blocking, High, Medium, or Low finding was reported within the
targeted boundary. The reviewed local state is eligible for a non-force
publication attempt; live remote read-back remains mandatory afterward.

This is independent review evidence from fresh Codex agents. It is not a claim
that Fable performed the review, not a merge authorization, and not a claim of
universal conformance.

## A1-A9 closure

| Adjudication | Verdict | Independently checked result |
|---|---|---|
| A1 | PASS | Count-promised EOF uses `count`; depth/nodes use `type-tag`; output refusal uses `allocation`. |
| A2 | PASS | Direct Common Lisp base/current probe changed `InvalidCanonicalGrammar/ZeroDenominator/host-import` to `UnsupportedHostInput/ZeroDenominator/host-import`. |
| A3 | PASS | `bit_length(abs(component))`, zero as zero bits, and pre-reduction rational construction checks are present and exercised. |
| A4 | PASS | Namespace and path identifier segments aggregate. |
| A5 | PASS | Depth precedes nodes; local magnitude/count/length precedes aggregate payload. |
| A6 | PASS | Record-key `f0..ff` retains `ForbiddenPrivilegedTag` precedence. |
| A7 | PASS | Construction descriptor remains distinct from normalized datum; injected descriptor-key `MemoryError` becomes `ResourceRefusal/AllocationRefused/allocation`. |
| A8 | PASS | Complete Identifier `ValueBytes` is counted once per occurrence, operation-wide; deterministic key-work refusal precedes complete key materialization. |
| A9 | PASS | Base Common Lisp refused `[Unit]` at depth 1; current succeeds with `4c50434400300100`; operation-jurisdiction vectors pass in both codecs. |

The four documentation LOW repairs also passed: the concrete A2 split,
seed-versus-corrected-tip provenance, depth/node `type-tag` wording with honest
dispositions, and conspicuous forwarding from superseded Phase-0 material.

## Fresh executable checks

Focused Python A7/A8 command:

```text
env PYTHONDONTWRITEBYTECODE=1 \
  PYTHONPATH=canonical-datum/python:canonical-datum/python/tests \
  python3 -m unittest -v \
    test_cd0.ErrataClosureTests.test_A7_construction_descriptor_translates_key_validation_allocation \
    test_cd0.ErrataClosureTests.test_A8_encoder_key_work_precedes_key_materialization \
    test_cd0.ErrataClosureTests.test_A8_fixture_key_work_precedes_key_materialization \
    test_cd0.ErrataClosureTests.test_A8_record_key_work_counts_each_occurrence_once
```

Exit `0`; four of four passed.

Phase-0 command:

```text
python3 canonical-datum/tools/verify_phase0.py
```

Exit `0`. Exact accounting reproduced:

```text
71 classified = 66 octet + 5 host
Python:      71 executed, 0 N/A, 0 failures, 0 skips
Common Lisp: 68 executed, 3 N/A, 0 failures, 0 skips
```

Promoted vector SHA-256:
`55725e14e763075a8866be9da8be9f8647b5b06803e1fea6f661068d87651ddc`.
Decomposition:

```text
A1=6 A2=5 A3=6 A4=3 A5=3 A6=2 A7=1 A8=6 A9=5
```

Complete Common Lisp command:

```text
sbcl --noinform --disable-debugger \
  --script canonical-datum/common-lisp/run-tests.lisp
```

Exit `0`; 2,633 assertions, 25/25 positives, 68 applicable classified
negative executions plus exactly three N/A dispositions, zero failures, and
zero skips.

Complete Python command:

```text
PYTHONPATH=canonical-datum/python \
  python3 -m unittest discover -s canonical-datum/python/tests -v
```

Exit `0`; 167 tests, `OK`.

Hand differential command:

```text
python3 canonical-datum/integration/run_differential.py --json
```

Exit `0`; PASS; `issues: []`; 465 requests per codec; 37/37 promoted
operations; exact negative dispositions reproduced.

Historical comparator command:

```text
python3 canonical-datum/tools/compare_errata_hand_baseline.py \
  --baseline-dir canonical-datum/evidence/transcripts/phase2-convergence \
  --errata-dir canonical-datum/evidence/transcripts/phase2-errata-0.1 \
  --json
```

Exit `0`; zero changes over, per codec, 22 positives, 71 negative
dispositions, 253 equality judgments, and seven regressions.

Existing-v1 command:

```text
bash mneme/verify-all.sh
```

Exit `0`; all six suites green. `git diff --exit-code` over `mneme/` from the
audited base to the reviewed envelope also exited `0`.

## Protected projection

The executable reviewer independently aligned the 10,000 audited and current
positive rows and recomputed:

```text
canonical_hex changes:    0
abstract changes:         0
expected_decoded changes: 0
equality_class changes:   0
```

Both projections hash to
`21399286466dd5c85c95a591c750d00799a997677c6c8357b6287e683ad8aa58`.

The 30,504-row mutation selection remained exactly bounded: 22 A7-linked
worked-vector truncations were added and 22 configured-size tail truncations
were displaced. Candidates remain unclassified.

## Packet and archive integrity review

The second reviewer independently verified the bundle, packet copies, receipt
hashes/counts, wording, seed ancestry, audited-tip ancestry, and Mneme scope.
An isolated bundle import reproduced archive-source tree
`24b571f3430d037def1ef2d819a0b7c9e80a9470`. Regenerated name-status and stat
views byte-matched the packet files.

Two new archive builds compared equal to each other and to the retained file:

```text
SHA-256        f6c8cf9fa62b36521703a1c1f1f10b288edbdf555cc3fd0c87105f0529c528f2
bytes          20,463,020
tracked files  1,233
tar entries    1,385
listing SHA    8a53e4a738cf63e5d45458aa39ffeee55819af012a7b60eaed7cacfe27a59a5d
```

`gzip -t` passed. The baseline extracted from the rebuilt archive hashes to
`5ace3291811f2131a50e1ff6afe281e7bc4a251dd3dd50771bcd8a54894318bb`.

The integrity reviewer also recomputed the aggregate corpus digest
`62a18766d59e9144d6beb1371d3b2886ffc35df511f7ec32a85f0be8af4b2b58`,
the identical protected projections above, the 608,000-byte hand-evidence
total, the 52,625,151-byte generated corpus total, and the 252-file /
134,880,443-byte generated-differential total.

## Residual bounds

- The reviewers did not rerun the 100,861-request release-scale differential,
  the full default qualification, or deterministic 52 MB corpus generation;
  they inspected the committed summaries/hashes and independently recomputed
  the 10,000-row protected projection.
- Historical container hashes `4816ac63…` for the supplied ruling ZIP and
  `022844a8…` for an attached historical relay packet were not independently
  rehashed because those containers are not retained in the worktree. No
  conflicting byte object or hash was found.
- Evidence remains bounded to SBCL 2.4.6, CPython 3.11.14, Git 2.43.0, the
  retained finite vectors/corpora, and reviewed source.
- The three Common Lisp optional-importer rows remain N/A, not passes.
- Remote successor availability and remote tips were not checked. That is the
  next mandatory gate.
- Finite evidence supports no accepted-document change on the audited surfaces;
  it is not a proof over every possible byte string, host, or runtime.

## Publication disposition

The corrected Common Lisp tip `ee3baa9ab504f65d39015f212050748fd300160a`,
Python tip `9f46a32351095dc1a52724a31574e0b9e62ed221`, and reviewed integration
envelope `edb809f30b93ea95512be6e4def54478ac9f3bd4` are eligible for a non-force
publication attempt. Publication success must be followed by live remote
read-back of all successor and audited refs plus the retained archive identity.

No merge to `main` is authorized or claimed.
