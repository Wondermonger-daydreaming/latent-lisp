# CD/0 first differential convergence verification

This is the bounded Phase-2 receipt for the first Common Lisp/Python
differential convergence pass on `2026-07-13`.  It records exact retained
process artifacts and minimized repair cases.  It is not a specification
amendment, a Phase-3 release-corpus receipt, or a claim that inert datum content
is truthful or authoritative.

## Frozen inputs and transition

| Item | Observed value |
|---|---|
| Normative specification | `mneme/spec/CANONICAL-DATUM-SPEC.md` |
| Specification SHA-256 | `d578e86e4d411611b091cca0bed1cafac2636c0908e95447fd4a13badcab6abc` |
| Integration seed HEAD | `9745bb112d3c6694e2d2dca9a0be8dd3eb5846ad` |
| Integration seed tree | `c0cd628095d3eb1e42c526fa5d2b4b7ee8eca6aa` |
| Repaired pre-harness HEAD | `bad5293e2accf337868e6b4df96bea6b65569b43` |
| Repaired pre-harness tree | `fc7fd3cb61c82941d44fbb1802a0320a2c974366` |
| Common Lisp | `SBCL 2.4.6` |
| Python | `CPython 3.11.14` |

The two seed commits existed before integration began:

- Common Lisp seed `e6f3b579742f5fcff0d82477d07f8c0c9ee34df3`;
- Python seed `58ecca4083275ebfe16605765e575bfb9f6eb755`, imported with
  integration parentage as `9745bb112d3c6694e2d2dca9a0be8dd3eb5846ad`.

The precise clean-room transition and inspected-source list are in
`INTEGRATION-SOURCE-ACCESS.md`.  Cross-reading occurred only after both seed
commits and their first complete local conformance runs existed.

## Obligation receipt

| ID | Obligation | Evidence | Status | Residual uncertainty |
|---|---|---|---|---|
| D1 | Compare the same hand vectors through separate codec processes | 353-request retained JSONL transcript: 22 positive, 71 negative, 253 equality, seven regression requests per codec | satisfied for the reviewed finite corpus | three language-specific host descriptors are explicitly N/A in Common Lisp, not counted as passes |
| D2 | Compare canonical bytes, normalized AST, equality, and warranted failures | runner assertions plus response JSONL | satisfied; zero issues | 11 A1 stages and one A2 code remain intentionally provisional |
| D3 | Preserve, minimize, classify, and permanently test each discovered disagreement | `cases/cd0-integration-regressions.json`, language-local regression suites, divergence ledger | satisfied for seven retained cases | the 5,000-digit preflight stress case is compactly generated but is a boundary stressor, not a globally byte-minimal datum |
| D4 | Derive repairs from the pinned specification rather than imitation | repair receipts, Section references, independent cross-review | satisfied for the classified repairs | A1--A9 remain unadjudicated and implementations retain their different A9 choices |
| D5 | Isolate host-state effects from datum identity | Python process uses `PYTHONHASHSEED=137` and `PYTHONINTMAXSTRDIGITS=640`; 641-digit success case compares complete results | satisfied for these finite perturbations | other Python/Common Lisp versions were unavailable or not run |
| D6 | Retain exact machine evidence | requests, both responses, both empty stderr files, summary, SHA-256 table below | satisfied | elapsed time is observational and not a conformance value |

## Disagreement and repair classifications

The 22/71 hand corpus and complete 253-pair equality relation had no warranted
cross-codec disagreement.  Separate boundary probes found the following.  The
manifest preserves the exact or compactly generated inputs, expected per-host
outcome, section references, and classification.

| Permanent case | Classification | Disposition |
|---|---|---|
| `cd0-reg-cl-rational-numerator-budget-precedence` | Common Lisp defect | fixed by applying Section 20.5(6) after the complete numerator UVAR and before denominator parsing |
| `cd0-reg-fixture-negative-zero` | fixture-adapter defect in both | fixed; fixture spelling `-0` is refused without changing mathematical Integer zero |
| `cd0-reg-fixture-integer-preflight` | host-import preflight defect in both | fixed with incremental, budgeted decimal parsing |
| `cd0-reg-python-ambient-decimal-ceiling` | Python host-assumption leak | minimized to 641 digits under CPython's smallest nonzero 640-digit ambient guard; both codecs now succeed identically |
| `cd0-reg-fixture-bytes-preflight` | Python defect | fixed by checking declared hex octets before conversion; local instrumentation proves conversion is not entered |
| `cd0-reg-python-deep-decode-host-ceiling` | Python host-assumption leak | raw recursion is now typed `ResourceRefusal/AllocationRefused/allocation`; Common Lisp succeeds, permitted by Sections 21.7 and 29.16 |
| `cd0-reg-python-deep-encode-host-ceiling` | Python defect at the A9 boundary | raw recursion is now typed; the different structural encoder-budget surfaces remain recorded A9 choices |

Original repair commits were:

- Python `db964524ded723f0841188a322b13ac9896c67d6`, integrated as
  `f0cc62272ed076513d7f533fca25548d73f0d342`;
- Common Lisp `776385ef13865b78a803004d67f9d3661045fc61`, integrated as
  `bad5293e2accf337868e6b4df96bea6b65569b43`.

Their language-specific receipts record red witnesses, focused commands, full
suite results, and residuals.

## Exact retained run

Command, from the integration worktree root:

```text
python3 canonical-datum/integration/run_differential.py \
  --artifacts-dir canonical-datum/evidence/transcripts/phase2-convergence
```

Observed summary:

```text
CD/0 differential convergence: PASS
spec sha256: d578e86e4d411611b091cca0bed1cafac2636c0908e95447fd4a13badcab6abc
requests: 353 in each of 2 isolated codec processes
shared positives: 22/22
shared negatives dispositioned: 71/71
  Common Lisp executed: 68; host N/A: 3
  Python executed: 71; host N/A: 0
complete equality matrix: 253/253
minimized integration regressions: 7/7
provisional unwarranted-field differences observed: 0
common-lisp process: exit 0; responses 353; stderr bytes 0
python process: exit 0; responses 353; stderr bytes 0
warranted cross-codec disagreements: 0
```

The Common Lisp adapter ran under SBCL in one process.  The Python adapter ran
in a distinct process with the two recorded ambient perturbations.  Adapter
exception text and host object equality are never compared.

## Artifact SHA-256

| Artifact | SHA-256 |
|---|---|
| `integration/common_lisp_adapter.lisp` | `5caa574534c3dc0d1975138abb228e6735807ca20dcc7da1c4c7c95887cc092c` |
| `integration/python_adapter.py` | `3b1d8017ed3a6cad375b6604e9fdcf2c01b9bdc5bccf3b336f95140abaf71db9` |
| `integration/run_differential.py` | `f614f844f73476be0817cba3760bdf07ab420fd2d75927fcff02a7dc8d312205` |
| `integration/cases/cd0-integration-regressions.json` | `c4c52419b81d2fab87c20c7c4949222df236aacc5451feedd1673e8f90e9ea79` |
| `transcripts/phase2-convergence/requests.jsonl` | `27b08bf39956649d4a672e0f12ba6b8b30223c6ec3aa656a2105dde74c6a4da9` |
| `transcripts/phase2-convergence/common-lisp-responses.jsonl` | `b34a4795f8fb0e4211d6496ed73dddc2949ee477e59cd3912f44afb281b71abf` |
| `transcripts/phase2-convergence/python-responses.jsonl` | `a9531377299dfd969cb8d48d26c95c343d255388372471e9f4ad4f484ec8706c` |
| each stderr file (empty) | `e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855` |
| `transcripts/phase2-convergence/summary.json` | `69b0b9025db187074ebcca4252bd2b02c5072211ff3a8fe0d63b39c65914f6b0` |

The final verification/archive phase will additionally publish the enclosing
commit and tree.

## Explicit non-results at this checkpoint

- The 10,000-positive/20,000-negative generated release corpus is a later gate.
- The seven regressions do not adjudicate A1--A9.
- Three Common Lisp-inapplicable, language-specific host adapters remain
  visible in the summary; N/A is not success.
- Only SBCL 2.4.6 and CPython 3.11.14 were available for qualification.
- This phase did not modify the normative specification or migrate v1.
- No remote branch was pushed at this checkpoint.
