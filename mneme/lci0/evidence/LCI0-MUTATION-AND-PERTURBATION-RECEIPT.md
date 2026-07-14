# LCI/0 Mutation and Perturbation Receipt

Date: 2026-07-14

Status: unaffected generated and host-perturbation paths converged; overall
conformance BLOCKED pending authorial closure

## Evidence boundary

This phase began only after the final exact runner established zero unaffected
fixture mismatches. The phase retains every authorial gap as a blocked
coordinate and compares all remaining coordinates. It does not treat blocked
cases as passes, skips, or N/A.

Bound integration commit/tree:
`e6983952ea726366b69435b29eeb37eb76f8504d` /
`daaef9bad97eced6c242fc8052cbedc8920d355a`.

The audited Python successor is
`db627cb6ca23abc0626aebc6f9982ab9b4406dbf` (tree
`74c6a7e5c144d3286b83a933b27cff3d5865921d`). The Common Lisp successor
remains `2513c354721bac6120b8c0a5eef1ed13252cf75b` (tree
`9ce6786ee374f3dafe859c6ea5977b27e6c6f718`).

## Deterministic property census

- Seed: `1279478064` (`0x4C434930`).
- Logical cases: 329.
- Adapter profiles: six—two Common Lisp and four Python.
- Requests per adapter process: 329.
- Total adapter requests: 1,974.
- Comparison failures outside declared blocked coordinates: zero.

| Family | Cases |
| --- | ---: |
| E6 deterministic failure order | 8 |
| Identifier boundary | 8 |
| ClaimId identity-coordinate change | 9 |
| Metadata neutrality | 64 |
| Migration grammar | 8 |
| Migration inertness | 2 |
| Migration source provenance | 2 |
| Operation-payload closure | 104 |
| Policy meta-testimony | 1 |
| Rational boundary | 5 |
| Record allocation/insertion order | 64 |
| Resource boundary | 26 |
| Semantic anti-shortcut | 2 |
| Semantic dispatch validation | 2 |
| Target schema boundary | 11 |
| Target unknown boundary | 11 |
| Unicode nonnormalization | 2 |
| Total | 329 |

The coordinator confirmed 64 metadata-neutrality equal groups, 64
record-allocation equal groups, nine identity-coordinate distinct groups, five
valid rational distinct groups, and two Unicode-nonnormalization distinct
groups.

## Authorial-coordinate treatment

| Class | Logical cases | Executions across six profiles | Treatment |
| --- | ---: | ---: | --- |
| Operation-payload failures | 104 | 624 | Required failure code/predicate checked; category, stage, path, and context blocked |
| Policy-B meta-testimony reason list | 1 | 6 | Decision and testimony class checked; only `outputs/policy-b-decision/reasons` blocked |
| Resource at-limit outputs | 13 | 78 | `within-budget=true` checked; only `outputs/resource` and `outputs/requested` blocked |

Thus 104 generated failure-coordinate cases and 14 generated result-coordinate
cases remain authorial-blocked. The implementation results are recorded for
review, but none is promoted to a normative oracle.

## Independent-audit hostile regressions

The independent audit identified six Python boundary defects. Commit
`db627cb6ca23abc0626aebc6f9982ab9b4406dbf` corrected them without treating
the Common Lisp implementation as an oracle. Integration commit
`e6983952ea726366b69435b29eeb37eb76f8504d` added eight exact hostile
requests. Both implementations now produce the same pinned typed result for
all eight, for 16 language-response checks. These requests are part of the
2,295-request exact run per implementation, not the 329-case generated census.

| Hostile ID | Request bytes | Request SHA-256 | Exact typed result |
| --- | ---: | --- | --- |
| `stable-ref-alias-production` | 542 | `84e58c2fa92abdd3f36b803a2d34a9a963b25bb27812adbd2df3973fe191c1c7` | `reference-refusal/UnresolvedAlias/stable-reference`, path `material / fixture-field:object-id` |
| `stable-ref-alias-model-current` | 545 | `56e26fc828792a37af541668125cf2b4676126eb147f27440977394fe4abf35c` | `reference-refusal/UnresolvedAlias/stable-reference`, path `material / fixture-field:object-id` |
| `project-claim-id-carrier-future-field` | 8,498 | `86515c865baca48ca66ab56f5b2131625b3e73df6446ff89c5b2af2b03504671` | `invalid-input/MissingRequiredField/claim-shape`, path `identity-policy` |
| `claim-tagged-empty-profile-location` | 8,535 | `e26bfdf1e5f48b96e860d7ce1b1eb9c1a82bd25715190e115e75bab793948fa3` | `invalid-input/UnknownField/profile-location`, path `location/profile-location/kind` |
| `match-target-beta-proposition` | 21,806 | `ecb0ce29079ec21580c04a858f4d020d1adabc57a06579248db9933193c10aa2` | `target-mismatch/PropositionMismatch/target-relation`, path `claim/proposition` |
| `match-target-proposition-before-subject-time` | 21,845 | `852089bc793985306052cce08312c9900a4ff9334f0d751dedfd6248df45a0e1` | `target-mismatch/PropositionMismatch/target-relation`, path `claim/proposition` |
| `match-target-nonmonotone-before-insufficient-coverage` | 23,282 | `9371481cd0ef16b5b9a5e5f4c1b63033cb4aa8c52bb1a7771072fba50cd0882c` | `target-mismatch/ScopeNarrowingNotDeclared/target-relation`, path `claim/location/scope` |
| `claim-id-equality-rejects-empty-records` | 106 | `ccb885ca8793e00940ff2da76a5818e163a488b52e6cbce9e150c51f98ac8b00` | `invalid-input/MissingRequiredField/claim-shape`, path `kind` |

The audit also added language-level matcher checks for identity-policy,
claim-profile, and profile-location coordinates. The frozen package supplies
only one valid value for each, so manufacturing a second valid hostile operand
would invent fixture semantics; those checks remain unit regressions rather
than implementation-local exact vectors. No new authorial-return packet was
created. The ten existing packets and their boundaries are unchanged.

## Host/process matrix

| Jurisdiction | Profiles/processes | Observation |
| --- | ---: | --- |
| Common Lisp adapter ambient markers | 2 adapter processes | Byte-identical 329-response streams |
| Python adapter hash seeds `0`, `1`, `42`, `4294967295`; locales `C`, `C`, `C.utf8`, `POSIX` | 4 adapter processes | Byte-identical 329-response streams |
| Common Lisp native package, printer, readtable, hash insertion, unavailable I/O/clock | 6 processes × 64 cases | One projection value per profile; source snapshot preserved |
| Python native hash seeds `0`, `1`, `42`, `4294967295` and locales `C`, `C`, `C.utf8`, `C` | 4 processes × 64 cases | One projection hash per profile; eight denial self-tests per process |
| Direct subprocess commands | 20 | All exit zero |
| Known nested Python runner processes | 4 | Included in process total |
| Total separate processes | 24 | All required direct surfaces completed |

The Python native probes patched filesystem, pathname, socket, name-resolution,
wall-clock, and monotonic-clock entry points after fixture setup. The Common
Lisp unavailable-I/O/clock profile used an unavailable default pathname and a
signalling `get-universal-time` replacement. No socket subsystem was loaded in
that Common Lisp profile, so its network denial remains a procedural boundary,
not an OS-enforced denial. Cross-adapter environment markers likewise do not
deny fixture-loading I/O.

## Required semantic invariants

| ID | Invariant | Result | Evidence |
| --- | --- | --- | --- |
| M01 | Neutral claim retains pinned base reference and bytes | PASS | Exact vectors and native projections |
| M02 | One changed ClaimId coordinate changes the envelope | PASS | 9 distinct identity-coordinate cases |
| M03 | Authorized nonidentity metadata preserves ClaimId | PASS | 64 equal groups × 6 profiles |
| M04 | Relation-undetermined is hard-inadmissible before policy | PASS | Exact vectors and semantic mutation |
| M05 | Undeclared narrowing returns `ScopeNarrowingNotDeclared` before coverage evaluation | PASS | Exact/generated target cases and nonmonotone-precedence hostile |
| M06 | Insufficient coverage fails closed | PARTIAL/BLOCKED | Failure behavior retained; E5 expected-only context remains blocked |
| M07 | Temporal containment does not produce direct support | PASS | Exact matcher and temporal table |
| M08 | Digest/canonical-byte equality cannot replace validated envelope equality | PASS | Semantic anti-shortcut cases and empty-record ClaimId-equality hostile |
| M09 | Mutable aliases fail StableRef validation | PASS | Exact hostile coverage includes `production` and `model-current`; language unit suites retain the full alias set |
| M10 | Unknown nested versions/fields and occurrence-like projection carriers fail closed | PASS with tuple boundary | Exact carrier/profile-location hostiles; closure predicate/code checked; 104 novel full tuples blocked |
| M11 | Proposition/location placement disagreement fails | PASS | Semantic dispatch validation |
| M12 | Legacy proposition-fingerprint collisions do not collapse ClaimId | PASS | Migration collision vectors excluding blocked expected documents |
| M13 | Migrated legacy warrants remain inert | PASS | Two migration-inertness cases; zero live creation |
| M14 | Source mutation cannot change ClaimId bytes | PASS | Six Common Lisp native snapshots and language suites |
| M15 | Unicode is preserved without normalization | PASS | Two distinct groups × six profiles |
| M16 | Boolean/integer and exact rational boundaries remain closed | PASS | Five rational cases and adapter schema suites |

`PARTIAL/BLOCKED` is deliberate: it is neither a failed implementation nor a
pass. Every unaffected coordinate of M06 and M10 converged.

## Native suites

| Suite | Result |
| --- | --- |
| Common Lisp unit gate | 77 pass, 0 fail, 18 authorial-blocked; process exit zero |
| Python perturbation surface | 8/8 tests pass; process exit zero |

The Common Lisp unit gate intentionally excludes the immutable pre-seed red
baseline from its process-exit criterion. Its stderr still records the four
known exact blocked vectors, and its stdout counts the 18 blocked language
witnesses separately.

## Raw evidence

Directory:
`mneme/lci0/differential/artifacts/post-convergence-final-2026-07-14/`

| Member | Bytes | SHA-256 |
| --- | ---: | --- |
| `requests.jsonl` | 8,818,612 | `41f979e6b946b22fda82c5fd3dae3ee17137ce21ecea86fc044d3213783fde89` |
| `cases.json` | 243,600 | `5a573656458f41a8418e9d2fc8a8f5d97aea5cd3c373dd30cc5999b1f281f6d1` |
| `command-transcript.jsonl` | 27,472 | `2cadd48fb70d93a8939088d5a95c9e619b7e6847b196bdb349d864ac78997c9a` |
| Common Lisp baseline responses | 11,901,537 | `2606c215814cb153bd2d41c55ba9ebea65aa057841a705f0c465edc96f618a6c` |
| Common Lisp ambient-marker responses | 11,901,537 | `2606c215814cb153bd2d41c55ba9ebea65aa057841a705f0c465edc96f618a6c` |
| Each Python response profile | 11,892,642 | `3df1b9034ac6b60ddff719a34b81ae4775460739e6a269220bec930abc291555` |
| `summary.json` | 357,939 | `0a318264436c6b6dd018fa31188315610d4bea8486bd0c61463d9e6a9fdcce6c` |
| `sha256-manifest.json` | 6,897 | `8ef26d59732db292ad307ae0bfc3b5db5d512a2291b771e208965afdbe449ead` |

All six adapter stderr files and all ten native-probe stderr files are empty.
The manifest binds every suite, runtime, native, request, response, summary,
and command-transcript member.

## Reproduction command

```text
PYTHONDONTWRITEBYTECODE=1 PYTHONPATH=mneme/lci0/differential:mneme/lci0/python:canonical-datum/python python3 mneme/lci0/differential/post_convergence.py --successor-artifacts /tmp/lci0-exact-final-head-r4-20260714 --output /tmp/lci0-post-convergence-final6-20260714 --seed 1279478064 --allocation-cases 64
```

## Disposition

The mutation, deterministic property, allocation, source-snapshot, and
host-process evidence converges on all unaffected coordinates. Overall LCI/0
conformance remains BLOCKED pending authorial closure of the ten existing
return packets. This receipt does not claim a global PASS, merge eligibility,
or OS-enforced clean-room isolation.
