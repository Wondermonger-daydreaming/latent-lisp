# LCI/0 Closure — Final Verification Transcript

Date: 2026-07-15
Author: INTEGRATOR (Claude Fable 5)
Branch: `codex/lci0-integration-closure`
Runtime: SBCL 2.4.6; Python 3.11.14; Linux x86-64 (WSL2).
Full raw logs: `_staging/lci0-closure-reverify/phase2/integrator/battery/`
(this transcript quotes the summary lines; the logs hold every line).

Commit structure verified before the battery: merge `9502dbab` (CL forge
`a6605403`), merge `eebe6ed1` (Py forge `dda8195a`), harness flip
`89ecfc62`, ledger addendum `64a97e5e`; base
`3693799fcd03b860dad85561382113593fcfe18b`; both forge heads unmodified
ancestors. Battery run at `89ecfc62`/`64a97e5e` (the differential and
post-convergence artifacts record their execution heads; the only
subsequent commits are evidence documents and the post-convergence status-
label correction, itself re-run green below).

Environment for every run: `LCI0_FIXTURE_ROOT` = `LCI0_FIXTURE_DIR` =
`/tmp/lci0-integration-fixtures-1784084025` (fresh root: 0.1 materialized +
overlay 0.2 additively materialized; registry `dd19c6d6…`, vectors
`387e7696…` verified), except post-convergence whose fixture root is pinned
in code (see §D).

---

## A. Common Lisp battery (`battery/cl-battery.log`)

```
$ sbcl --noinform --disable-debugger --script mneme/lci0/common-lisp/run-tests.lisp
LCI0 COMMON LISP UNIT SUMMARY: 85 passed, 0 failed, 10 blocked, 95 total
LCI0 CLOSURE SUMMARY: 50/50 exact; 0 failed
LCI0 CLOSURE REGRESSION SUMMARY: 12 passed, 0 failed, 12 total
LCI0 PRE-SEED RISK SUMMARY: 15 green, 0 red, 15 total
EXIT=0

$ sbcl … --script mneme/lci0/common-lisp/run-vectors.lisp
LCI0 VECTOR SUMMARY: 215/215 exact; 0 failed                    EXIT=0

$ sbcl … --load mneme/lci0/common-lisp/load.lisp --eval '(… verify-fixture-corpus)' --quit
LCI0 CORPUS SUMMARY: (:REGISTRY-DEFINITIONS 675 :VECTORS 215
                      :OFFICIAL-DOCUMENTS 1105 :RELATION-TABLE-DOCUMENTS 458
                      :NESTED-E1-DOCUMENTS 30 :SUPPLEMENTARY-DOCUMENTS 488
                      :TOTAL-DOCUMENTS 1593 :MAGIC-PREFIXED-JSON-VALUES 1593)
EXIT=0

$ LCI0_PERTURBATION=package     sbcl … run-perturbation.lisp → 215/215 exact  EXIT=0
$ LCI0_PERTURBATION=printer     sbcl … run-perturbation.lisp → 215/215 exact  EXIT=0
$ LCI0_PERTURBATION=readtable   sbcl … run-perturbation.lisp → 215/215 exact  EXIT=0
$ LCI0_PERTURBATION=hash-insertion sbcl … run-perturbation.lisp → 215/215 exact EXIT=0

$ sbcl … --script canonical-datum/common-lisp/run-tests.lisp   (CD/0)
total assertions: 2633                                          EXIT=0
```

The 10 blocked CL units are the coordinates the ruling explicitly KEEPS
deferred (52-schema expansion, eleven-kind algorithms, inverse matrices,
novel tuples) — fail-closed by design.

## B. Python battery (`battery/py-battery.log`)

```
$ (cd mneme/lci0/python) python3 -m unittest discover -s tests -p 'test_*.py'
Ran 110 tests … OK                                              EXIT=0
$ (cd canonical-datum/python) python3 -m unittest discover …   (CD/0)
Ran 167 tests … OK                                              EXIT=0
$ PYTHONHASHSEED=0      … discover → Ran 110 tests OK           EXIT=0
$ PYTHONHASHSEED=1      … discover → Ran 110 tests OK           EXIT=0
$ PYTHONHASHSEED=random … discover → Ran 110 tests OK           EXIT=0
```

## C. Differential exact run (`battery/differential-run.log`; item c)

```
$ PYTHONDONTWRITEBYTECODE=1 PYTHONPATH=mneme/lci0/differential:mneme/lci0/python:canonical-datum/python \
    python3 mneme/lci0/differential/run_differential.py --output /tmp/lci0-integrator-exact-1784087974
status: converged-authorial-closures-complete
authorial_return_required: false
common-lisp: 0 mismatches; python: 0 mismatches
cross_implementation_mismatches: 0
counts (both impls): document 1593/1593 · vector 215/215 · relation 458/458 · hostile 29/29
adapters: 2295 requests / 2295 responses / exit 0 (each)
EXIT=0
```

ZERO mismatches, ZERO blocked, full convergence, 2295 requests per
implementation — the required closure outcome. Curated artifacts:
`mneme/lci0/differential/artifacts/closure-converged-2026-07-15/`.
Determinism cross-check: an independent converged run (the harness
implementer's, `…/integrator/forgewright/converged-summary.json`) is
byte-identical modulo `runtime`/`adapter_runs` timing fields.

## D. Post-convergence (`battery/post-convergence-final.log`; item d)

```
$ python3 mneme/lci0/differential/post_convergence.py \
    --successor-artifacts /tmp/lci0-integrator-exact-1784087974 \
    --output /tmp/lci0-integrator-post3-1784088977 --seed 1279478064 --allocation-cases 64
{"cases": 329, "seed": 1279478064, "status": "converged-authorial-closures-complete"}
EXIT=0
```

329 property cases, 6 adapter profiles (CL baseline + ambient-markers;
Python hash-0/1/42/max × locales), 1 974 total adapter requests, 10 native
projection probes, 0 failures, 0 mismatches, gate `converged: true` with
every blocker count 0. The 104/14 blocked-coordinate observations are the
ruling's explicitly deferred coordinates — never counted pass or fail.
Curated artifacts:
`mneme/lci0/differential/artifacts/post-convergence-closure-2026-07-15/`.

**Deviation record (disclosed, not papered over):**
1. The FIRST post-convergence attempt FAILED (exit 1, one failure:
   `suite-common-lisp-unit` nonzero — `battery/post-convergence.log`).
   Cause: the harness pins its fixture root in code to
   `/tmp/lci0-seed-fixtures-20260714` (the CL seed froze that extraction
   path), and that root — the baseline's — carried no overlay, so the three
   overlay-superseded green regressions (E5/P024/P029) failed against
   superseded 0.1 expectations. Fix: the overlay was materialized
   **additively** into the pinned root (task-sanctioned; 0.1 member hashes
   verified unchanged before and after: registry `dd19c6d6…`, vectors
   `387e7696…`). Re-run green (`battery/post-convergence-rerun.log`).
2. That green re-run exposed stale status labels in `post_convergence.py`
   itself (top-level `status` still read
   `converged-unaffected-with-authorial-blockers` and
   `authorial_return_required: true` despite empty blocker lists and zero
   failures). The labels were corrected to the closed state (4 sites), the
   49 harness self-tests re-ran OK, and the FINAL run above is the
   corrected, fully green execution.

## E. v1 migration — zero live warrants (`battery/v1-migration-live-warrants.log`; item e)

Explicit scan decoding every response document from BOTH implementations'
fresh differential artifacts:

```
common-lisp: 10 live-warrant coordinates, all Boolean:False / Integer:0   OK
python:      10 live-warrant coordinates, all Boolean:False / Integer:0   OK
  (P024 outputs/value/live_warrants_created = 0; P027/P028/P029 left+right
   live-warrants-created = false; E9-INERT-PREDECESSOR result + account = false/0)
restore-live-warrant vectors (both impls): N029 → LegacyWarrantInert,
  N030 → PrivilegedRestorationAttempt, E9-LIVE-RESTORATION → PrivilegedRestorationAttempt
V1-MIGRATION LIVE-WARRANT CHECK: PASS — zero live warrants everywhere      EXIT=0
```

The migration suite itself is inside A/B (vector gate 215/215 includes all
migration vectors; the Python suite's migration tests are inside the 110);
the post-convergence `migration-inertness` family (2 cases × 6 profiles)
converges with restoration refused.

## F. Harness self-tests

```
$ (cd mneme/lci0/differential) python3 -m unittest test_run_differential test_post_convergence test_python_adapter
Ran 49 tests … OK
```

(run twice: after the census flip, and again after the post-convergence
label correction — both OK).

## G. Deterministic evidence archive (item f)

Built twice from the same clean commit with
`mneme/lci0/shared/build_evidence_archive.py` (sorted member names, zeroed
mtime/uid/gid metadata, zeroed gzip timestamp — the repository's
deterministic builder); byte-identity of the two builds verified by SHA-256
equality. The archive is built from the committed receipts tree, so its
digest cannot appear inside the tree it archives: the digest sidecar
`LCI0-CLOSURE-EVIDENCE-ARCHIVE.sha256` is committed immediately after the
build, and the archive file itself lives in the integration evidence
staging area, referenced by digest — recorded choice, matching the
raw-JSONL treatment.

## H. Non-regression boundary (asserted; proofs in LCI0-CLOSURE-NONREGRESSION-RECEIPT.md)

- CD/0 (families/octets/decoder/version): `canonical-datum/` subtree object
  `ce6e41deca3fe237ff6d0edafa2666d098ae62e8` identical to both forge bases;
  CD/0 suites green on the integrated tree (A5: 2 633 assertions; B2: 167
  tests).
- Envelope/ClaimId/WarrantTarget/policy/profile/schema versions: unchanged
  (`0.1.0` fixture profile; protocol `lisp-plus-lci0-differential/v1`;
  schema-version 0; failure-code registry census exactly 84 + the two
  closure-authorized allowlist extensions).
- The 211/420/21 prior determinate results: unchanged and passing
  (215 = 211 + 4 closed; 458 = 420 + 38 closed; 29 = 21 + 8 closed).
- Migration posture: inert-only, zero live warrants (§E), restoration
  refused, production revival deferred.
- Production boundaries: no production warrant/standing/crypto/live-
  migration surface touched (changed-file inventory:
  `LCI0-CLOSURE-CHANGED-FILES.txt` — all paths under `mneme/lci0/*` and
  `mneme/lci0/differential/*`).
- 0.1 fixture files byte-unchanged: archive blob `dcaaa3eb…` identical at
  base and tip (file SHA-256 `36cc71cc…`); materialized registry/vectors
  hashes verified in every root used.

## Scoreboard

| Gate | Result | Exit |
|---|---|---|
| CL run-tests (unit+closure+regressions+pre-seed) | 85/0/10 · 50/50 · 12/12 · 15/15 | 0 |
| CL run-vectors | 215/215 exact | 0 |
| CL corpus | 1593/1593 documents | 0 |
| CL perturbation ×4 | 215/215 each | 0 |
| CD/0 CL | 2633 assertions | 0 |
| Py suite | 110 OK | 0 |
| CD/0 Py | 167 OK | 0 |
| Py suite × PYTHONHASHSEED 0/1/random | 110 OK each | 0 |
| Differential exact run | 0 mismatch / 0 blocked / 0 cross; 2295/impl | 0 |
| Harness self-tests | 49 OK | 0 |
| Post-convergence (seed 1279478064, 329 cases, 6 profiles) | converged; 0 failures | 0 |
| v1 migration live-warrant scan | PASS (all false/0; restoration refused) | 0 |
| Evidence archive ×2 | byte-identical | 0 |
