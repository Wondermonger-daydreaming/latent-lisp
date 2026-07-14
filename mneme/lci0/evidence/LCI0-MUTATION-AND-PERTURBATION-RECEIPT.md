# LCI/0 Mutation and Perturbation Receipt

Date: 2026-07-14

Status: integration-successor mutation/property/host matrix PENDING

## Evidence boundary

The language seeds contain bounded ambient-state observations. The baseline
differential deliberately deferred integration-wide host perturbations and
randomized/property generation because exact fixture convergence had not been
reached. Deferred work is not a pass, failure, skip, or N/A.

## Historical seed observations

| Seed | Directly recorded observation | Standing |
| --- | --- | --- |
| Common Lisp | Four fresh-process profiles × 215 vectors = 860 exact requests; source mutation and ambient-state unit tests reported green | Seed-only evidence; successor result PENDING |
| Python | 256 deterministic randomized allocation/source-buffer cases at seed `0x4C434930` (`1279478064`); 256 independently allocated equal-value projections; 256 JSON allocation/order cases | Seed-only evidence; successor result PENDING |
| Python | Four processes with `PYTHONHASHSEED=0,1,42,4294967295` and locales `C,C,C.utf8,POSIX` | Seed-only evidence; successor result PENDING |
| Python | Filesystem/network unavailable and changed wall clock did not change projection in the seed suite | Seed-only evidence; successor result PENDING |
| Baseline integration | Property and host phases were not run after non-convergence | PENDING, not pass/skip/N/A |

## Mandatory integration-successor matrix

| Jurisdiction | Required perturbation | Command/profile | Requests/cases | Seed | Result |
| --- | --- | --- | ---:| --- | --- |
| Common Lisp | Package state changes | PENDING | PENDING | PENDING | PENDING |
| Common Lisp | Printer controls | PENDING | PENDING | PENDING | PENDING |
| Common Lisp | Readtable changes | PENDING | PENDING | PENDING | PENDING |
| Common Lisp | Hash insertion/order changes | PENDING | PENDING | PENDING | PENDING |
| Python | Hash seed changes | PENDING | PENDING | PENDING | PENDING |
| Python | Dictionary insertion/order changes | PENDING | PENDING | PENDING | PENDING |
| Python | Locale changes | PENDING | PENDING | PENDING | PENDING |
| Both | Separate fresh processes | PENDING | PENDING | PENDING | PENDING |
| Both | Mutated source buffers after construction | PENDING | PENDING | PENDING | PENDING |
| Both | Independently allocated equal values | PENDING | PENDING | PENDING | PENDING |
| Both | Filesystem unavailable | PENDING | PENDING | PENDING | PENDING |
| Both | Network unavailable | PENDING | PENDING | PENDING | PENDING |
| Both | Changed wall clock and runtime state | PENDING | PENDING | PENDING | PENDING |

## Required semantic invariants

| ID | Invariant | Common Lisp | Python | Cross-language |
| --- | --- | --- | --- | --- |
| M01 | Exact neutral claim retains pinned base reference and neutral bytes | PENDING | PENDING | PENDING |
| M02 | Changing one ClaimId coordinate changes the envelope | PENDING | PENDING | PENDING |
| M03 | Authorized nonidentity metadata preserves ClaimId bytes | PENDING | PENDING | PENDING |
| M04 | Relation-undetermined remains hard-inadmissible before Policy-A/B | PENDING | PENDING | PENDING |
| M05 | Undeclared nonmonotone narrowing returns `ScopeNarrowingNotDeclared` | PENDING | PENDING | PENDING |
| M06 | Insufficient coverage returns `ScopeNarrowingCoverageInsufficient` | PENDING | PENDING | BLOCKED for expected-only E5 context; tuple PENDING |
| M07 | Temporal containment never becomes direct target support | PENDING | PENDING | PENDING |
| M08 | Digest equality cannot substitute for envelope equality | PENDING | PENDING | PENDING |
| M09 | Mutable aliases fail StableRef validation | PENDING | PENDING | PENDING |
| M10 | Unknown nested versions and fields fail closed | PENDING | PENDING | PENDING |
| M11 | Proposition/location placement disagreement fails | PENDING | PENDING | PENDING |
| M12 | Legacy proposition-fingerprint collisions across location coordinates do not collapse ClaimId | PENDING | PENDING | PENDING |
| M13 | Migrated legacy warrants remain inert | PENDING | PENDING | PENDING |
| M14 | Source mutation after construction cannot change ClaimId bytes | PENDING | PENDING | PENDING |
| M15 | Unicode is preserved exactly without silent normalization | PENDING | PENDING | PENDING |
| M16 | Boolean/integer and exact rational distinctions remain closed | PENDING | PENDING | PENDING |

## Property-generation gate and record

Deterministic randomized/property generation may begin only after every
non-blocked exact fixture has converged. The four authorial-blocked classes must
be excluded by exact witness identity and reported as blocked, never silently
removed from totals.

| Field | Value/status |
| --- | --- |
| Gate: non-blocked exact fixture convergence | PENDING |
| Generator version/SHA-256 | PENDING |
| Generator algorithm description | PENDING |
| Property seeds | PENDING |
| Cases per seed | PENDING |
| Requests per implementation | PENDING |
| Total differential requests | PENDING |
| Rejected/generated-case classification | PENDING |
| Smallest minimized disagreement | PENDING |
| Permanent regression vector status | PENDING |

## Raw evidence and reproducibility

| Member | Bytes | SHA-256 | Commit containing raw member | Archive member |
| --- | ---:| --- | --- | --- |
| Common Lisp perturbation requests/responses | PENDING | PENDING | PENDING | PENDING |
| Python perturbation requests/responses | PENDING | PENDING | PENDING | PENDING |
| Property requests/responses | PENDING | PENDING | PENDING | PENDING |
| Mutation summary | PENDING | PENDING | PENDING | PENDING |
| Environment/profile manifest | PENDING | PENDING | PENDING | PENDING |
| Minimized counterexamples | PENDING | PENDING | PENDING | PENDING |

## Authorial-return exclusions

| Packet | Exact affected path | Matrix treatment |
| --- | --- | --- |
| `LCI0-AUTHORIAL-RETURN-PACKET.md` | N012 universal/symbolic direct matcher composition | BLOCKED; retain exact witness; do not generate an implementation-local oracle |
| `LCI0-AUTHORIAL-RETURN-PACKET-RELATION-FAILURE-PATHS.md` | 38 unpinned companion paths | BLOCKED for exact path comparison; relation values remain eligible for perturbation |
| `LCI0-AUTHORIAL-RETURN-PACKET-E5-COVERAGE-CONTEXT.md` | E5 expected-only coverage context | BLOCKED for exact expected document; failure tuple and input-derived invariants remain eligible |
| `LCI0-AUTHORIAL-RETURN-PACKET-P029-SOURCE-ARTIFACT.md` | P029 right-result source replacement | BLOCKED for exact expected document; explicit-source preservation and all unaffected migration invariants remain eligible |

## Cleanup and publication fill-in

| Item | Status/value |
| --- | --- |
| Raw evidence committed before archive creation | PENDING |
| Reproducible archive committed and independently listed | PENDING |
| Loose raw files deleted only after archive verification | PENDING |
| Bytecode/cache/temp detritus removed safely | PENDING |
| Cleanup commit and deleted-file inventory | PENDING |
| Successor branch publication | PENDING |
| Remote read-back object IDs | PENDING |

## Current disposition

The integration mutation, property, and host-perturbation result is PENDING.
This receipt does not claim convergence, final nonregression, PASS, archive
completion, publication, or eligibility for independent implementation audit.
