# LCI/0 Closure Non-Regression Receipt

Date: 2026-07-15
Author: INTEGRATOR (Claude Fable 5)
Scope: proves the closure integration changed ONLY the ten ruled surfaces
and their harness/oracle plumbing — every protected boundary is unchanged.

## CD/0 (families / octets / decoder / version) — unchanged at git-object level

- `canonical-datum/` subtree object at CL forge base `2513c354`:
  `ce6e41deca3fe237ff6d0edafa2666d098ae62e8`.
- `canonical-datum/` subtree object at the integrated branch: **identical**
  (`ce6e41deca3fe237ff6d0edafa2666d098ae62e8`) — no commit on any of the
  three closure branches touches CD/0.
- Executed anyway on the integrated tree: CL `canonical-datum/common-lisp/run-tests.lisp`
  EXIT 0 (2 633 assertions); Python `canonical-datum/python/tests` — 167
  tests OK.

## 0.1 fixture package — byte-unchanged

- Archive blob `dcaaa3ebd40ee505950ef5ea8215e18607d33271` identical at base
  and integrated HEAD (file SHA-256 `36cc71cc…f02e987d`).
- Materialized members: registry `dd19c6d6…f826327`, vectors
  `387e7696…bffe3a4` — verified in both fixture roots used.
- Overlay 0.2 is strictly additive (see
  `LCI0-CLOSURE-FIXTURE-OVERLAY-RECEIPT.md`).

## Envelope / ClaimId / WarrantTarget / policy / profile / schema versions — unchanged

- Fixture profile version: `0.1.0` throughout (differential summary field;
  vector envelopes still validate `fixture-profile-version` against it).
- Protocol: `lisp-plus-lci0-differential/v1` unchanged.
- Schema-version `0` on all produced documents; no new document kinds.
- The failure-code registry census remains exactly the 84 frozen codes
  (CL `failure-code-registry-census-is-exactly-84` PASS) with only the
  closure-authorized extensions (`InvalidMigrationResult`,
  `LCI0-UNSUPPORTED-FIXTURE-BEHAVIOR`) in the allowlist, each citing its
  closure (CL `failure-code-allowlist-equals-frozen-registry-plus-closure`
  PASS; Py `test_failure_vocabulary` asserts 84 + the two, cited).
- Policy vocabulary: only the registered
  `admissibility-decision/reject-external-principal` spelling was adopted
  (per the ruling); Policy-C remains a non-LCI fixture-authority gap.

## The 211 / 420 / 21 prior determinate results — unchanged

- 211 previously exact official vectors: not named by any supersession key;
  vector gate 215/215 in both languages (so all 211 still byte-exact);
  Python `test_211_unaffected_expected_semantic_results` green under
  `PYTHONHASHSEED` 0/1/random; all four CL perturbation profiles 215/215.
- 420 previously complete relation results: not named by any
  companion-path addition; differential `relation_passed` 458 = 420
  unchanged + 38 closed.
- 21 previously exact hostile requests: not present in the eight new
  hostile records; differential `hostile_passed` 29 = 21 unchanged + 8
  closed.

## Migration posture — unchanged (inert-only)

- Zero live warrants: explicit scan over BOTH implementations' fresh
  differential response documents found 10 live-warrant coordinates each,
  every one `false`/`0` (P024 `live_warrants_created = 0`; P027/P028/P029
  left+right `live-warrants-created = false`; E9-INERT-PREDECESSOR
  migration-result + account coordinates 0/false); all three
  `restore-live-warrant` vectors refused
  (`LegacyWarrantInert` / `PrivilegedRestorationAttempt`). Log:
  `_staging/…/integrator/battery/v1-migration-live-warrants.log`.
- The post-convergence `migration-inertness` property family (2 logical
  cases × 6 adapter profiles) converges with restoration refused.
- No legacy v1 code loaded or evaluated; no current-registry consultation
  (P024's zero-registry-lookup poison proof; the fail-closed I/O/clock
  profiles in post-convergence).
- Production revival and live migration remain deferred/unauthorized; this
  integration operates strictly inside ruling §12 scope (inert fixtures,
  differential tests).

## Production boundaries — unchanged

- No production warrant, standing, crypto, or live-migration surface was
  added or modified; the closure work touches fixture expectations, the
  ten ruled semantic sites, tests, and the differential harness only (see
  `LCI0-CLOSURE-CHANGED-FILES.txt` — every path is under
  `mneme/lci0/{common-lisp,python,shared,fixtures,differential,evidence}`).
- The genuinely deferred coordinates stay fail-closed BLOCKED by design
  (10 CL unit witnesses; 4 Python blocked witnesses failing-by-design when
  run directly).
