# LCI/0 Authorial Return Packet — E5 coverage context

Date: 2026-07-14

Status: affected exact-result path blocked; authorial disposition required

## Scope

This packet concerns only the `actual-coverage-scope` context field in
`LCI0-E5-COVERAGE-INSUFFICIENT`. The failure category, code, stage, and path
are determinate and undisputed. It does not reopen the ClaimId model, scope
relations, target kinds, policy, standing, warrants, or CD/0.

## Exact witnesses

| Witness | Bytes | SHA-256 |
|---|---:|---|
| `LCI0-E5-COVERAGE-INSUFFICIENT` input | 21,896 | `08cbf5bde9a42d9180161f90f75c8b6bd5c7d8c2e453ed9aaa31718c6d42e773` |
| `LCI0-E5-COVERAGE-INSUFFICIENT` expected result | 2,923 | `dcc9deda2e494a8adab5e04a39c04d61c056d5b9bcb0a390c1667c67351dc613` |

A structural census of the canonical input finds one tenant-`b` scope and one
department-`research` scope, with no tenant-`a` scope. The expected failure
context contains one tenant-`a` scope as `actual-coverage-scope`.

LCI/0 §9.3 requires every scope boundary to be explicit and says no boundary
is inferred from ambient state. Section 10.6 requires target boundaries to
cover the candidate scope, but supplies no pure rule that changes sampled
planned coverage from tenant `b` to actual coverage tenant `a`.

## Implementation observations

The Common Lisp seed synthesized tenant `a` when the target was observed and
sampled, thereby matching the expected bytes. The Python seed did not include
that expected-only datum. Neither implementation is an oracle, and exact-byte
agreement obtained by copying the Common Lisp construction would not close the
missing normative rule.

## Requested closure

The authorial response should choose and publish one coherent closure:

1. add an explicit actual-inspected-coverage boundary to the target input and
   update the target schema and canonical input;
2. define an exact pure derivation from already bound target fields, including
   why tenant `a` follows from this input; or
3. revise the expected context to contain only data derivable from the input.

The response should provide successor artifact hashes, version consequences,
and a permanent regression vector. Until then, the required successor
disposition is to preserve the failure tuple using only input-derived context
and report this exact expected document as blocked rather than passed, failed,
skipped, or N/A.

## 2026-07-14 successor execution note

Both final adapters executed E5 from the frozen input and retained the
input-derived failure as one of four blocked vector results. No implementation
fabricated the expected tenant coverage, and E5 was not counted as pass,
failure, skip, or N/A. Unaffected vector results converged.
