# LCI/0 Closure Hostile-Result Receipt (LCI0-AC-007, LCI0-AC-005)

Date: 2026-07-15
Author: INTEGRATOR (Claude Fable 5)

## What was closed

The 8 formerly blocked hostile result tuples (`BLOCKED_HOSTILE_REQUESTS` in
the pre-closure census; successor vectors `LCI0-ACV-HOSTILE-001..008`).

## Ruled results and outcomes

| Successor ID | Request | Ruled result | Prior (RED) | Final |
|---|---|---|---|---|
| HOSTILE-001 | `stable-ref-alias-package-symbol-spelling` | failure `reference-refusal/UnresolvedAlias` @ `/material/object-id`, stage `stable-reference` | bounded blocked (two candidates) | exact, both impls |
| HOSTILE-002 | `observed-with-executed-target-schema` | failure `invalid-input/TargetSchemaKindMismatch` @ `/target-schema`, stage `target-schema` | bounded blocked; cross-diff on `failure` allowed | exact, both impls |
| HOSTILE-003 | `executed-with-observed-target-schema` | same as HOSTILE-002 | bounded blocked | exact, both impls |
| HOSTILE-004 | `target-nested-coverage-future-selector` | failure `invalid-input/UnknownField` @ `/boundaries/coverage-scope/expression/future-selector`, stage **`target-boundary`** | divergent: stage `scope` (both candidates were `scope`-staged; the ruling re-stages) | exact, both impls |
| HOSTILE-005 | `resource-stable-ref-material-5000` | failure `resource-refusal/StableReferenceMaterialBudgetExceeded` @ `/material`, stage `validation` | bounded blocked (`[material]` vs `[]` candidates); baseline cross-mismatch | exact, both impls |
| HOSTILE-006 | `resource-maximum-nesting-at-limit-64` | **success** with value `{limit: 64, requested: 64, within-budget: true, workload: "maximum-nesting"}` | blocked bounded-success (only `within-budget: true` frozen); baseline cross-mismatch on result octets | exact, byte-identical result documents (581 octets), CL == Python == oracle |
| HOSTILE-007 | `migration-grammar-reference-substitution` | failure `migration-refusal/UnsupportedLegacyForm` @ `/grammar`, stage `migration-source` | divergent: CL/Py produced `reference-refusal/InvalidStableReference`-family refusals; baseline cross-mismatch | exact, both impls |
| HOSTILE-008 | `policy-c-fail-closed` | authority-gap: `{status: authority-gap, authority_gap: "unsupported fixture policy", lci_failure: null}` (LCI0-AC-005; a non-LCI fixture-authority gap, never a Policy-B-like accept, never an LCIFailure) | blocked authority-gap (identical across impls) | exact, both impls; now a legitimate pass in the differential |

## Discipline preserved

- Malformed payloads fail **structurally**, never by host exception: the
  Python runner-level test
  (`test_hostile_requests_never_escape_host_exceptions_via_runner`) is
  green; both differential adapter stderr streams are empty in the
  converged run; the CL adapter signals structural failure documents only.
- The wholesale 52-schema expansion remains **deferred** as ruled (the
  corresponding fail-closed unit witnesses remain BLOCKED by design — 10 of
  the 10 remaining CL blocked units).
- The 21 previously exact hostile requests are untouched (not named by any
  new hostile record) and still pass: differential `hostile_passed` 29/29.

## Evidence

- Prior: baseline `06-mismatch-summary.txt` (8 hostile blocked, both
  implementations), `07-cross-mismatch-ids.txt` (3 hostile cross-mismatches:
  material-5000, at-limit-64, grammar-substitution); forge red evidence
  (`phase2/forge-cl/pre-closure-vectors.log` — HOSTILE-004/006/007 red;
  `phase2/forge-py/red-evidence.json` — 5 envelope protocol failures, 1
  unruled success shape, 1 internally conforming).
- Final: converged differential (`closure-converged-2026-07-15/summary.json`)
  — hostile 29/29 both implementations, zero mismatches, zero cross;
  CL closure runner 50/50; Python `test_8_hostile_expectations` green.
