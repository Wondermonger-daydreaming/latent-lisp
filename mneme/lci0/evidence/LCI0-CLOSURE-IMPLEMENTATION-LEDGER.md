# LCI/0 Closure Implementation Ledger

Date: 2026-07-15
Author: INTEGRATOR (Claude Fable 5)
Branch: `codex/lci0-integration-closure` (merging `codex/lci0-common-lisp-closure`
@ `a6605403904406d3176f39433416d5a93e6427ee` and `codex/lci0-python-closure`
@ `dda8195a1e9dec25e870763eeaf78222c962e412` into
`codex/lci0-integration-successor` @ `3693799fcd03b860dad85561382113593fcfe18b`).

Authorities: `LCI0-IMPLEMENTATION-CLOSURE-RULING.md`,
`LCI0-AUTHORIAL-CLOSURE-REGISTER.json`, `LCI0-AUTHORIAL-CLOSURE-VECTORS.jsonl`
(50 successor vectors — the sole acceptance truth), fixture overlay 0.2
(zip SHA-256 `5e03c2f5a17cf69f9b562dcfc5b7dfde85563fc7f88d52fcb01ffe858c1a10eb`).

Prior (RED) evidence cited throughout:
- Baseline reproduction (pre-change, 2026-07-14):
  `_staging/lci0-closure-reverify/phase2/baseline/BASELINE-REPORT.md` — CL
  vectors 211/215 (N012, E5, P029, P024 failed), CL units 77/0/18-blocked,
  differential 50 authorial-blocked (4 vector + 38 relation + 8 hostile),
  41 cross-implementation mismatches, status
  `converged-unaffected-with-authorial-blockers`.
- Forge red evidence: `phase2/forge-cl/` (`pre-vectors.log`, `pre-tests.log`,
  `pre-closure-vectors.log` 44/50) and `phase2/forge-py/`
  (`red-evidence.json` — all 50 vectors pre-change actual behavior).

Final (GREEN) evidence: `LCI0-CLOSURE-FINAL-VERIFICATION-TRANSCRIPT.md` (this
directory) and `mneme/lci0/differential/artifacts/closure-converged-2026-07-15/`.

---

## LCI0-AC-001-N012-MATCHER

- Source question: `LCI0-AUTHORIAL-RETURN-PACKET.md` (N012 universal/symbolic
  scope-relation conflict); ledger row D1, LCI0-DIV-006/004.
- Closure ID: `LCI0-AC-001-N012-MATCHER`; acceptance vector `LCI0-ACV-ORIG-001`.
- Affected language: both.
- Files changed: CL `mneme/lci0/common-lisp/matching.lisp`; Py
  `mneme/lci0/python/lci0/core.py` (`match_target`).
- Tests/vectors: CL `ac-001-*` + `official-green-N012-closed-by-LCI0-AC-001` +
  closure runner ORIG-001; Py
  `test_closure_vectors.test_four_superseded_official_vectors` (LCI0-N012).
- Prior result: divergent — both produced
  `target-mismatch/ScopeNarrowingNotDeclared` (646 B) instead of the frozen
  document (baseline `03-cl-vectors.log` `FAIL LCI0-N012`; forge-py
  `red-evidence.json`).
- Ruled result: frozen 502-octet
  `relation-undetermined/ScopeRelationUnknown` at `/claim/location/scope`
  (SHA-256 `4c69d1ef399987736d84acd4fd159da884ff0260ee1a9fb13b73770588eba746`);
  no policy consulted; both frozen table rows retained.
- Final CL: byte-exact (215/215 vector gate; closure 50/50; zero policy
  consultations poison-proven). Final Python: byte-exact (suite green; 50/50).

## LCI0-AC-002-RELATION-FAILURE-PATHS

- Source question: `LCI0-AUTHORIAL-RETURN-PACKET-RELATION-FAILURE-PATHS.md`;
  rows D1/D2, LCI0-DIV-001/005/014.
- Closure ID: `LCI0-AC-002-RELATION-FAILURE-PATHS`; vectors
  `LCI0-ACV-REL-001..038`.
- Affected language: both + differential harness adapters.
- Files changed: CL `closure-surface.lisp`
  (`evaluate-relation-table-companion`); Py `lci0/closure.py`
  (`evaluate_relation_table`) + `lci0/runner.py`; harness
  `differential/python_adapter.py` + `differential/common_lisp_adapter.lisp`
  (ruled path deepening on exactly the 38 rows) +
  `differential/run_differential.py` (single ruled path in the oracle).
- Prior result: blocked — no companion surface existed (38 envelope protocol
  failures in Py; no CL surface); in the differential, all 38 were
  authorial-blocked AND cross-implementation mismatches (CL `[right]` vs Py
  `[right,calculus]` on scope; CL `[left]` vs Py `[right]` on temporal) —
  baseline `07-cross-mismatch-ids.txt`.
- Ruled result: 24 scope rows
  `relation-undetermined/ScopeIncompatible/target-relation` at
  `/right-scope/calculus`; 14 temporal rows
  `relation-undetermined/AdmissibilityUndetermined/subject-time` at
  `/right-subject-time/expression/form`; relation VALUES unchanged.
- Final CL: 38/38 exact (closure runner REL-001..038). Final Python: 38/38
  exact. Differential: 458/458 relation_passed, zero cross-mismatches; the
  420 determinate rows byte-unchanged.

## LCI0-AC-003-E5-COVERAGE-CONTEXT

- Source question: `LCI0-AUTHORIAL-RETURN-PACKET-E5-COVERAGE-CONTEXT.md`;
  row D1, LCI0-DIV-015.
- Closure ID: `LCI0-AC-003-E5-COVERAGE-CONTEXT`; vector `LCI0-ACV-ORIG-002`.
- Affected language: both.
- Files changed: CL `matching.lisp`; Py `lci0/core.py`
  (`_require_target_coverage`).
- Prior result: divergent — failure context carried the unbound
  `actual-coverage-scope` (synthesized tenant-a); produced sha `86ca74bf…` ≠
  ruled (baseline `FAIL LCI0-E5-COVERAGE-INSUFFICIENT`).
- Ruled result: context reduced to input-derived `target-kind` +
  `required-candidate-scope`; 1747-octet document SHA-256
  `beb1478efe86ed5bb116269f05a3d2016c1cdd4f0f97e23760646bdc39208650`.
- Final CL: byte-exact. Final Python: byte-exact. Pinned E2-COVERAGE
  (payload-borne) untouched in both.

## LCI0-AC-004-P029-SOURCE-PRESERVATION

- Source question: `LCI0-AUTHORIAL-RETURN-PACKET-P029-SOURCE-ARTIFACT.md`;
  row I1, LCI0-DIV-012/016/023.
- Closure ID: `LCI0-AC-004-P029-SOURCE-PRESERVATION`; vector
  `LCI0-ACV-ORIG-003`.
- Affected language: neither (already conforming) — test/fixture layer only.
- Files changed: none in either implementation's migration semantics; the
  overlay supersedes the 0.1 expectation; permanent byte-exact regressions
  added on both sides.
- Prior result: blocked-as-vector — the 0.1 expectation substituted `v1/2`;
  both implementations already preserved the supplied
  `object/artifact/legacy-source/v1/1` (pre-change actual octets SHA-256
  `9da0098f2448aaea7d0d3720281a6d02eb78dafb908a4c06831b08b7358089b5`,
  54 022 B, equal on both sides = the overlay expectation).
- Ruled result: preserve the supplied source exactly in result source and
  lineage ("no change if final successor preserves source exactly").
- Final CL: exact. Final Python: exact (zero code change). See
  `LCI0-CLOSURE-P029-RECEIPT.md`.

## LCI0-AC-005-POLICY-EVALUATION-ORDER

- Source question: `LCI0-AUTHORIAL-RETURN-PACKET-POLICY-EVALUATION-ORDER.md`;
  row H1, LCI0-DIV-013/017/022.
- Closure ID: `LCI0-AC-005-POLICY-EVALUATION-ORDER`; vector
  `LCI0-ACV-HOSTILE-008`.
- Affected language: both.
- Files changed: CL `policy.lisp`; Py `lci0/core.py` (`evaluate_policy`),
  `lci0/vector.py` (`_evaluate_fixture_policy`), `lci0/closure.py`
  (`evaluate_policy_c`).
- Prior result: blocked — combined witness raised order-gap; untrusted
  external raised vocabulary-gap; three BLOCKED unit witnesses (baseline
  `01-cl-unit-tests.log`).
- Ruled result: total order floor → kind → boundary coherence → represented
  loss → inherited/external → freshness → narrowing → final; combined witness
  rejects represented loss first; registered
  `admissibility-decision/reject-external-principal`; Policy-C stays a
  non-LCI fixture-authority gap
  (`{status: authority-gap, authority_gap: "unsupported fixture policy",
  lci_failure: null}`); F-valued relations hard-inadmissible pre-policy.
- Final CL: HOSTILE-008 exact; A-before-B consultation proven on LCI0-P022.
  Final Python: HOSTILE-008 exact; order/spelling record tests green.

## LCI0-AC-006-CORPUS-BASIS-COHERENCE

- Source question: `LCI0-AUTHORIAL-RETURN-PACKET-CORPUS-BASIS-COHERENCE.md`;
  row D3, LCI0-DIV-018.
- Closure ID: `LCI0-AC-006-CORPUS-BASIS-COHERENCE` (closure-record; no
  differential request id — exercised through unit witnesses, as at baseline).
- Affected language: both.
- Files changed: CL `validation.lisp`; Py `lci0/core.py` (`validate_basis`).
- Prior result: blocked — the retained r3/r4 witness (4 005 B, SHA-256
  `7c92ea0639c7de40dbed630587b9ecbf1ce36e374bb66db966d6536aa1c1a0be`, rebuilt
  = ledger digest) was rejected fail-closed as `InvalidBasis` at the wrong
  coordinate.
- Ruled result: `invalid-input/BasisMismatch/corpus-basis` at
  `/semantic-boundary/manifest/revision`, context
  `{basis_revision: 3, semantic_boundary_manifest_revision: 4}`, after the
  declared cross-field checks; reverse orientation stays fail-closed
  `InvalidBasis` (no inverse matrix).
- Final CL: exact tuple witnessed (`corpus-boundary-cross-coherence-exact-tuple-LCI0-AC-006`).
  Final Python: exact tuple witnessed (`test_ac006_corpus_basis_coherence_exact_tuple`).

## LCI0-AC-007-OPERATION-PAYLOAD-FAILURES

- Source question: `LCI0-AUTHORIAL-RETURN-PACKET-OPERATION-PAYLOAD-FAILURES.md`;
  row A2, LCI0-DIV-008/009/010/011/019.
- Closure ID: `LCI0-AC-007-OPERATION-PAYLOAD-FAILURES`; vectors
  `LCI0-ACV-HOSTILE-001..007`.
- Affected language: both + differential harness adapters.
- Files changed: CL `validation.lisp` (target-boundary staging),
  `migration.lisp` (`UnsupportedLegacyForm` at `/grammar`),
  `closure-surface.lisp` (hostile surface + within-budget projection); Py
  `lci0/closure.py` (`hostile_validate`, `conformance_semantics`,
  `migration_failure_semantics`) + `lci0/runner.py`; harness: both
  differential adapters normalize to the ruled tuples and emit the ruled
  at-limit-64 within-budget value document.
- Prior result: mixed — HOSTILE-001/002/003/005 tuple-conforming but
  differentially blocked-bounded; HOSTILE-004 divergent stage (`scope` vs
  ruled `target-boundary`); HOSTILE-006 unruled success shape; HOSTILE-007
  divergent refusal family (`reference-refusal/InvalidStableReference` vs
  ruled) — 3 of these were baseline cross-mismatches.
- Ruled result: the seven exact tuples of `LCI0-ACV-HOSTILE-001..007`
  (see `LCI0-CLOSURE-HOSTILE-RESULT-RECEIPT.md`); malformed payloads fail
  structurally, never by host exception; the 52-schema wholesale expansion
  stays deferred.
- Final CL: 7/7 exact. Final Python: 7/7 exact (+ runner-level
  no-host-exception test). Differential: hostile_passed 29/29, zero cross.

## LCI0-AC-008-MIGRATION-CLASSIFICATION

- Source question:
  `LCI0-AUTHORIAL-RETURN-PACKET-MIGRATION-CLASSIFICATION-COUPLING.md`;
  row I2, LCI0-DIV-020.
- Closure ID: `LCI0-AC-008-MIGRATION-CLASSIFICATION` (closure-record).
- Affected language: both.
- Files changed: CL `validation.lisp` + `values.lisp`
  (+`InvalidMigrationResult` in the allowlist); Py `lci0/migration.py` +
  `lci0/model.py`.
- Prior result: blocked — the retained classification-only mutation
  (31 107 B, SHA-256
  `565494e413cb849836d922b3ae6455c771f2f7f2c0a31ac4b30d9991ccee3726`,
  rebuilt = ledger digest) was ACCEPTED.
- Ruled result: `invalid-input/InvalidMigrationResult/migration-result` at
  `/classification` with both coordinates in context; no total inverse
  matrix inferred; `InvalidMigrationResult` is a closure-authorized
  failure-code extension (registry stays 84 + the authorized additions).
- Final CL: exact tuple witnessed; N028 and the five valid results keep
  standing (215/215). Final Python: exact tuple witnessed; untouched
  original still validates.

## LCI0-AC-009-TARGET-BOUNDARY-COHERENCE

- Source question:
  `LCI0-AUTHORIAL-RETURN-PACKET-TARGET-BOUNDARY-COHERENCE.md`; row G1,
  LCI0-DIV-010/021.
- Closure ID: `LCI0-AC-009-TARGET-BOUNDARY-COHERENCE` (closure-record).
- Affected language: both.
- Files changed: CL `validation.lisp` + `values.lisp`; Py `lci0/core.py`
  (`_target_kind_coherence`) + `lci0/model.py`.
- Prior result: blocked — the retained premise mutation (20 341 B, SHA-256
  `d0baf4a9470db970e014b707509d79e1c25581b320c100fda1ee66a5f6218b0b`,
  rebuilt = ledger digest) validated silently / matched `exact-target`.
- Ruled result: the explicit /0 deferral
  `unsupported-fixture-behavior/LCI0-UNSUPPORTED-FIXTURE-BEHAVIOR/fixture`
  at `/boundaries/premise-claim-ids/0` (a non-LCI condition; never
  adjudicated as mismatch); all pinned shape/type/coordinate/scope checks
  and official target vectors unchanged; eleven-kind algorithms stay
  deferred.
- Final CL: deferral witnessed; pinned positive still validates; 215/215.
  Final Python: deferral witnessed; pinned checks retained.

## LCI0-AC-010-P024-INERT-REVIVAL

- Source question: `LCI0-AUTHORIAL-RETURN-PACKET-P024-REVIVAL.md`; row I1,
  LCI0-DIV-012/023.
- Closure ID: `LCI0-AC-010-P024-INERT-REVIVAL`; vector `LCI0-ACV-ORIG-004`.
- Affected language: both + differential harness adapters.
- Files changed: CL `operations.lisp`; Py `lci0/closure.py`
  (`revival_semantics`); harness: both differential adapters emit the ruled
  inert defensive document (byte-identical across languages, 1 169 octets).
- Prior result: divergent — CL returned a full revival record; Py mechanics
  were registry-free but no ruled result document existed; the 0.1 expected
  carried invented beta metadata with no input source.
- Ruled result: the exact inert defensive reconstruction —
  `production_revival "deferred"`, null claimant/assertion-time/
  provenance/authority/custody, `live_warrants_created 0`,
  `mode "inert-defensive-reconstruction"`, supplied ClaimId preserved
  exactly, defensive CD/0 copy, zero registry lookups.
- Final CL: exact (whole-registry poison proves zero lookups). Final
  Python: exact (invariants verified before emission). See
  `LCI0-CLOSURE-P024-RECEIPT.md`.

---

## Evidence-count changes

| Gate | Before (baseline 2026-07-14) | After (this branch) |
|---|---|---|
| CL unit tests | 77 passed / 0 failed / 18 blocked (95) | 85 passed / 0 failed / 10 blocked (95) + closure 50/50 + closure-regressions 12/12 + pre-seed 15/15 |
| CL vectors | 211/215 exact (4 failed) | 215/215 exact |
| Python suite | 100 tests OK | 110 tests OK |
| Differential mismatches | 50 authorial-blocked per impl | 0 |
| Cross-implementation mismatches | 41 | 0 |
| Differential status | converged-unaffected-with-authorial-blockers | converged-authorial-closures-complete |
| Census | vector 211p/4b, relation 420p/38b, hostile 21p/8b | vector 215p, relation 458p, hostile 29p (all-passed; sum 4590 unchanged) |

The 10 remaining CL blocked units are the genuinely deferred coordinates the
ruling keeps open (52-schema expansion, eleven-kind algorithms, inverse
matrices, novel tuples) — fail-closed by design, not closure regressions.

## Unchanged protected surfaces

See `LCI0-CLOSURE-NONREGRESSION-RECEIPT.md` (git-object level proof):
CD/0 subtree, 0.1 fixture archive/registry/vectors, envelope/ClaimId/
WarrantTarget/policy/profile/schema versions, the 211/420/21 prior
determinate results, migration posture (inert-only; zero live warrants),
production boundaries.
