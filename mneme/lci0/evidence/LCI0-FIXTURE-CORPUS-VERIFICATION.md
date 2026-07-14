# LCI/0 Fixture Corpus Verification

Date: 2026-07-14

Status: successor corpus verification PENDING; no final corpus PASS asserted

## Purpose and evidence standing

This receipt separates historical preflight/seed/baseline observations from the
integration-successor verification that still must be run. It does not treat
either implementation as an oracle and does not rewrite the package's official
count to include the supplementary sweep.

## Frozen package identity

| Artifact | Verified pre-implementation SHA-256 |
| --- | --- |
| `LCI0-FIXTURE-REGISTRY.json` | `dd19c6d6543a875b2e7e1e6a234ad731ce019f64495b447b317462c63f826327` |
| `LCI0-FIXTURE-VECTORS.jsonl` | `387e76963f3087f6e41ec4363ec3eea29b1456c2a6b3c5a0cf5763418bffe3a4` |
| `LCI0-FIXTURE-PACKAGE-MANIFEST.md` | `1e9b2d0d88da5ab50ffb777360e7a6f9f908b4fd7057d0038c757e24038819d7` |
| `LCI0-FIXTURE-SHA256SUMS.txt` | `d394678a851043e40d42cb7d382f77f113a54b5fcfe0bebcfed8825af6ec1050` |
| Frozen fixture ZIP | `36cc71ccf3c310a055199c54e84bf436c4505d92a6378f22e8b1d932f02e987d` |
| Frozen fixture TAR.GZ twin | `ddc03ba184e835fdbd3c51e9a0f8d3edf4a93deb4d6b980544d82a5c47a83934` |

Preflight verified all 21 entries in the sealed package checksum file. The
fixture ZIP and TAR.GZ twin contained the same 22 members byte-for-byte. The
PASS receipt's prose count of 20/20 is retained as a non-semantic bookkeeping
typo: the sealed file has 20 payload rows plus its package-manifest row.

## Required census

| Corpus class | Required count | Historical observation | Successor result |
| --- | ---:| --- | --- |
| Registry definition documents | 675 | Preflight mechanically found 675 unique definitions | PENDING |
| Vector input documents | 215 | Preflight mechanically found 215 unique vector IDs | PENDING |
| Vector expected-result documents | 215 | Preflight mechanically found one expected result per vector | PENDING |
| Official embedded documents | 1,105 | Both baseline adapters roundtripped 1,105 | PENDING |
| Supplementary relation-table documents | 458 | Both baseline adapters roundtripped 458 | PENDING |
| Supplementary nested E1 documents | 30 | Both baseline adapters roundtripped 30 | PENDING |
| Supplementary subtotal | 488 | Historical count is 458 + 30, retained separately | PENDING |
| Complete recursive package sweep | 1,593 | Baseline: 1,593/1,593 for each implementation | PENDING |

The official figure remains 1,105. The supplementary figure remains 488. The
1,593 total is a recursive completeness sweep, not a replacement official
count.

## Verification obligations by implementation

Each successor must independently perform every row below against the exact
frozen package. A green CD/0 decode alone is insufficient.

| Check | Common Lisp successor | Python successor | Differential/coordinator |
| --- | --- | --- | --- |
| Discover every embedded canonical document recursively | PENDING | PENDING | PENDING |
| Classify official, relation-table, and nested E1 documents | PENDING | PENDING | PENDING |
| Validate supplied byte counts | PENDING | PENDING | PENDING |
| Validate supplied SHA-256 checksums | PENDING | PENDING | PENDING |
| Decode with the frozen CD/0 codec | PENDING | PENDING | PENDING |
| Compare decoded datum with package expectation | PENDING | PENDING | PENDING |
| Re-encode byte-identically | PENDING | PENDING | PENDING |
| Prove magic-prefixed documents were not missed by shallow key census | PENDING | PENDING | PENDING |
| Confirm canonical octets match across independently allocated values | PENDING | PENDING | PENDING |
| Confirm zero unknown schema forms were silently accepted | PENDING | PENDING | PENDING |

## Historical evidence, bounded

The immutable Common Lisp seed receipt records 1,105 official plus 488
supplementary documents reproduced, with a 1,593 magic-prefix census. The
immutable Python seed receipt records the same counts and also breaks the
relation set into 169 scope and 289 temporal documents. The baseline
differential evidence records 1,593/1,593 roundtrips for each seed adapter.

Those observations establish the seed baseline only. Successor validation and
resource corrections have not yet been bound to a committed integration tree,
so no final result is inferred from them.

## Successor command transcript

| Field | Common Lisp | Python | Coordinator |
| --- | --- | --- | --- |
| Commit/tree | PENDING | PENDING | PENDING |
| Runtime/version | PENDING | PENDING | PENDING |
| Exact command | PENDING | PENDING | PENDING |
| Start/end or monotonic duration | PENDING | PENDING | PENDING |
| Exit status | PENDING | PENDING | PENDING |
| Official pass/fail count | PENDING | PENDING | PENDING |
| Supplementary pass/fail count | PENDING | PENDING | PENDING |
| Missed-magic-prefix count | PENDING | PENDING | PENDING |
| Raw result member and SHA-256 | PENDING | PENDING | PENDING |

## Disagreement and authorial-return discipline

Any prose, registry, vector, adapter, or implementation inconsistency must be
reduced to a smallest witness and added to
`LCI0-IMPLEMENTATION-DIVERGENCES.md`. Canonical document discovery, decode,
and byte-identical re-encoding are not currently blocked by the ten provisional
authorial packets. The packets constrain semantic derivation or exact failure
records; every cited witness document remains independently round-trippable.
If a corpus identity or canonical document differs, this receipt becomes
`BLOCKED` and implementation must not substitute a nearby revision.

| Authorial packet | Corpus impact |
| --- | --- |
| `LCI0-AUTHORIAL-RETURN-PACKET.md` | No canonical roundtrip impact known; semantic N012 result remains BLOCKED |
| `LCI0-AUTHORIAL-RETURN-PACKET-RELATION-FAILURE-PATHS.md` | Relation values/documents remain testable; 38 unpinned paths remain BLOCKED |
| `LCI0-AUTHORIAL-RETURN-PACKET-E5-COVERAGE-CONTEXT.md` | Input and expected bytes remain discoverable; semantic derivation remains BLOCKED |
| `LCI0-AUTHORIAL-RETURN-PACKET-P029-SOURCE-ARTIFACT.md` | Input and expected bytes round-trip; cross-document source binding remains BLOCKED |
| `LCI0-AUTHORIAL-RETURN-PACKET-POLICY-EVALUATION-ORDER.md` | Policy and minimized carrier documents round-trip; combined decision derivation remains BLOCKED |
| `LCI0-AUTHORIAL-RETURN-PACKET-CORPUS-BASIS-COHERENCE.md` | Both revision-specific boundary documents round-trip; exact mixed-revision rejection tuple remains BLOCKED |
| `LCI0-AUTHORIAL-RETURN-PACKET-OPERATION-PAYLOAD-FAILURES.md` | Official payload documents round-trip; novel missing/unknown failure tuples remain BLOCKED |
| `LCI0-AUTHORIAL-RETURN-PACKET-MIGRATION-CLASSIFICATION-COUPLING.md` | Migration fixtures round-trip; the unpinned classification/content matrix remains BLOCKED |
| `LCI0-AUTHORIAL-RETURN-PACKET-TARGET-BOUNDARY-COHERENCE.md` | Eleven target schema documents round-trip; opaque kind-coherence semantics remain BLOCKED |
| `LCI0-AUTHORIAL-RETURN-PACKET-P024-REVIVAL.md` | P024 input and expected documents round-trip; derivation of the injected beta occurrence remains BLOCKED |

## Archive, cleanup, and publication fill-in

| Item | Status/value |
| --- | --- |
| Raw successor corpus transcript commit | PENDING |
| Raw transcript members/bytes/SHA-256 | PENDING |
| Evidence archive member path | PENDING |
| Evidence archive member count/bytes/SHA-256 | PENDING |
| Deterministic archive rebuild comparison | PENDING |
| Loose raw files removed only after archive commit | PENDING |
| Safe detritus deletion inventory | PENDING |
| Post-cleanup tree audit | PENDING |
| Published branch/remote object ID | PENDING |
| Remote read-back verification | PENDING |

## Current disposition

Successor corpus verification is PENDING. This document does not claim final
fixture convergence, audit eligibility, archive completion, cleanup completion,
publication, or PASS.
