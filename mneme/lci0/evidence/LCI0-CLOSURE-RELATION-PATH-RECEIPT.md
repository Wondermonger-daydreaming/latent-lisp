# LCI/0 Closure Relation-Path Receipt (LCI0-AC-002)

Date: 2026-07-15
Author: INTEGRATOR (Claude Fable 5)

## What was closed

The 38 formerly blocked relation companion-failure paths
(`LCI0-ACV-REL-001..038`; `BLOCKED_RELATION_PATH_REQUESTS` in the pre-closure
census; ledger rows LCI0-DIV-001/005/014): 24 cross-calculus scope
orientations and 14 symbolic-right temporal orientations. The relation
VALUES were always pinned and undisputed; only the companion failure path
was underdetermined.

## Ruled coordinates (LCI0-AC-002-RELATION-FAILURE-PATHS)

| Family | Rows | Ruled tuple | Ruled path (closure-vector naming) | Ruled path (differential operand naming) |
|---|---:|---|---|---|
| scope cross-calculus (`incompatible`) | 24 | `relation-undetermined / ScopeIncompatible / target-relation` | `/right-scope/calculus` | `fixture-field:right / calculus` |
| temporal symbolic-right (`unknown`) | 14 | `relation-undetermined / AdmissibilityUndetermined / subject-time` | `/right-subject-time/expression/form` | `fixture-field:right / expression / form` |

Precedence evidence (per the register): left operand validated first; the
right nested coordinate is the first that completes the proof; retained
competing causes recorded in the overlay members
(`relation-failures/LCI0-ACV-REL-*.json`).

## Prior (RED)

- Baseline differential (2026-07-14): all 38 requests
  `disposition: authorial-blocked` AND genuine cross-implementation
  mismatches — CL emitted `[right]` (scope) / `[left]` (temporal), Python
  emitted `[right, calculus]` / `[right]`; ids archived verbatim in
  `phase2/baseline/07-cross-mismatch-ids.txt`.
- Forge-Py red evidence: all 38 were `InvalidFixtureVectorEnvelope`
  protocol failures on the closure-vector surface (no operation existed).

## Implementation

- CL: `closure-surface.lisp` `evaluate-relation-table-companion` (closure
  vectors) — 38/38 exact in `run-closure-vectors`.
- Python: `lci0/closure.py` `evaluate_relation_table` + runner dispatch —
  38/38 exact in `test_closure_vectors.test_38_relation_companion_failures`.
- Differential adapters (both languages): the engine's own companion failure
  is deepened to the ruled coordinate on exactly the closure conditions
  (scope `ScopeIncompatible` → append `calculus`; temporal
  `AdmissibilityUndetermined` with symbolic right operand →
  `right/expression/form`), in the differential's own operand naming.
- Differential oracle: pins the single ruled path per row (the pre-closure
  two-path underdetermined branch is gone).

## Final (GREEN)

- Differential: `relation_passed` **458/458** in both implementations;
  **zero** relation entries in either mismatch list; **zero**
  cross-implementation mismatches (previously 38 of the 41).
- The 420 determinate relation rows are byte-unchanged: their oracle
  branches were not modified, and the converged run shows all 420 still
  passing with the engines' original paths.
- Engine-pinned 0.1 paths preserved: `LCI0-TEMPORAL-UNKNOWN` still pins
  `('fixture-field:left',)` on the direct engine surface;
  `LCI0-SCOPE-SYMBOLIC-UNKNOWN` still pins `('fixture-field:right',)`
  (215/215 vector gate green in both languages, all four perturbation
  profiles).
