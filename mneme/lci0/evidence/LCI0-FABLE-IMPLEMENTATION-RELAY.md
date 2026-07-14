# Fable LCI/0 Implementation Relay

Date: 2026-07-14

Relay status: DRAFT / NOT READY FOR PASS REVIEW

Requested disposition: authorial closure on three narrow packets; implementation
audit request PENDING

> Paste-ready boundary: this relay currently reports a blocked implementation
> phase. It must not be represented as convergence, PASS, merge eligibility, or
> eligibility for independent implementation audit.

## 1. Authorization and scope observed

Work was limited to the authorized fixture LCI/0 surface: independently seeded
Common Lisp and Python implementations; shared frozen fixture-package
consumption; ClaimId validation/projection; WarrantTarget validation and pure
matching; fixture scope/time/slice/boundary/frame/StableRef semantics; finite
Policy-A/B evaluation; inert v1 migration fixtures; and differential/hostile
testing.

No production warrant or WarrantId, production standing/admissibility,
capability, authority, cryptographic algorithm, production module/procedure
identity, custody/verified lineage, live v1 migration, or CD/0 redesign was
authorized or is claimed.

## 2. Authority and frozen identities

The authority order applied was frozen CD/0 behavior; LCI/0 candidate; Errata
0.1; fixture-package specification; machine registry/vectors; post-review
ruling; and the Fable PASS receipt for authorization and disclosed notes.

| Artifact | SHA-256 |
| --- | --- |
| `LOCATED-CLAIM-IDENTITY-SPEC.md` | `6fa2965ed727b4d89b09a3d9c171bcfa3aea8c23f486ef87dc33f85bcb9ae5ba` |
| `LCI0-POST-REVIEW-RULING.md` | `c2ee9dbb2b3fc72abf4745f5e9a8b4a04d9e1bfeab0fbe224d5c7946e11360a7` |
| `LOCATED-CLAIM-IDENTITY-SPEC-ERRATA-0.1.md` | `f2bcea1db0e08fe271fdaa79c1f9d4406b94c2c730ab547c0024495ce962c5ea` |
| `LCI0-NORMATIVE-FIXTURE-PACKAGE-SPEC.md` | `ac0c9265e9583c698c397801099efa548cdbf33f686ebff5bacc8bbea7cbcd2f` |
| `LCI0-FIXTURE-REGISTRY.json` | `dd19c6d6543a875b2e7e1e6a234ad731ce019f64495b447b317462c63f826327` |
| `LCI0-FIXTURE-VECTORS.jsonl` | `387e76963f3087f6e41ec4363ec3eea29b1456c2a6b3c5a0cf5763418bffe3a4` |
| Fixture manifest | `1e9b2d0d88da5ab50ffb777360e7a6f9f908b4fd7057d0038c757e24038819d7` |
| Fixture checksum file | `d394678a851043e40d42cb7d382f77f113a54b5fcfe0bebcfed8825af6ec1050` |
| Frozen fixture ZIP | `36cc71ccf3c310a055199c54e84bf436c4505d92a6378f22e8b1d932f02e987d` |
| Fable PASS packet | `89cd11ac52478a9e3ff9ebdefcc60b2fff8fa2c8707e159b4f4bd0b6e2cefdfd` |
| Frozen CD/0 packet | `bc54a23bbd235fc0ee4d0485c2091585e506dbc7cf74b0e16318580465aa1f81` |

All identities above matched pre-implementation. Final successor recheck:
PENDING. Any difference requires an immediate stop.

## 3. Independence statement and immutable seeds

The correct claim is:

> Independently seeded implementations under shared normative infrastructure,
> with procedural—not OS-enforced—isolation.

| Seed | Commit | Tree | Pre-cross-reading record |
| --- | --- | --- | --- |
| Common Lisp | `b3d28bc49c3b015096cb04c6ad08c19829f511a9` | `d48c39f933cde591f3303fcd3c9f42a0dac1a869` | Inspected-file inventory and red/verification transcripts retained |
| Python | `4ec2e519d05aeacd2412cb8aedc5f76bde702571` | `9f7915b460f449976a5d7fa856861ad5ce1d36ca` | Seed receipt and red/hash evidence retained |

No unqualified clean-room claim is made. Neither seed is an oracle.

### Immutable seed-receipt limitation and successor supersession

The seed receipts are immutable historical claims about their own gate runs.
They are not rewritten after integration. Where the hostile differential later
found narrower counterexamples, the baseline divergence ledger supersedes the
seed receipt for successor/final correctness conclusions without erasing the
seed's historical observation. The future successor receipts, not amended seed
commits, must carry the corrections and fresh evidence.

## 4. Baseline versus successor evidence

| Layer | Identity | Standing |
| --- | --- | --- |
| Unchanged seed integration | `71f7cfc5ebe392d59d820203dad11cc2e86a0542` | Imports both immutable seeds; not a corrected implementation |
| Baseline evidence commit | `80f1202cc6d176d891179ca408d41136c9a28a97`; tree `c2e12bb976a923b9a17148ddf27c52489b5a0c9a` | Retains raw requests/responses, summary, divergence witnesses, and receipt |
| Common Lisp successor | PENDING commit/tree | Correction and verification PENDING |
| Python successor | PENDING commit/tree | Correction and verification PENDING |
| Integration successor | PENDING commit/tree | Differential convergence and final evidence PENDING |

The baseline sent 2,281 requests to each seed implementation: 1,593 document
roundtrips, 215 vector semantic requests, 458 full relation semantic requests,
and 15 hostile witnesses. It received 4,562 uniquely keyed responses. Both
roundtripped 1,593/1,593 documents; semantic and hostile disagreements were
classified in `LCI0-IMPLEMENTATION-DIVERGENCES.md`.

These are discovery results. They are not successor results and do not support
a final PASS.

## 5. Three narrow authorial returns

### AR-1 — N012 universal/symbolic matcher composition

Packet: `LCI0-AUTHORIAL-RETURN-PACKET.md`

The frozen scope table returns `wider` for universal → symbolic, while Errata E2
retains `LCI0-N012` as a direct unknown-relation witness. The incorporated
materials do not pin the matcher-level rule that reconciles these obligations.
The exact path is BLOCKED; the other 214 vectors may continue.

### AR-2 — unpinned relation failure paths

Packet: `LCI0-AUTHORIAL-RETURN-PACKET-RELATION-FAILURE-PATHS.md`

Both implementations can agree on the machine-pinned relation value while
differing on the structural path for 38 unvectored companion failures. The
relation values remain executable; those paths are BLOCKED pending exact
authorial closure.

### AR-3 — E5 expected-only coverage context

Packet: `LCI0-AUTHORIAL-RETURN-PACKET-E5-COVERAGE-CONTEXT.md`

The `LCI0-E5-COVERAGE-INSUFFICIENT` expected result contains an
`actual-coverage-scope` not present in, or derivable by a pinned rule from, the
canonical input. The failure tuple remains determinate; that exact expected
context is BLOCKED.

| Requested authorial response | Status |
| --- | --- |
| Exact governing rule/order for AR-1 | PENDING |
| Exact category/code/stage/path documents for AR-2 orientations | PENDING |
| Input binding or pure derivation/revised expectation for AR-3 | PENDING |
| Successor normative version and replacement hashes | PENDING |
| Permanent regression-vector identities | PENDING |

No blocked item is counted as pass, failure, skip, or N/A.

## 6. Implementation and evidence crosswalk

The complete A–J surface, corpus/vector requirements, protected invariants, file
owners, and residual boundaries are mapped in
`LCI0-IMPLEMENTATION-LEDGER.md`. Current successor/final results are PENDING or
BLOCKED. No implementation-level claim has been promoted merely because a seed
suite was green.

## 7. Required final implementation identities

| Required item | Value/status |
| --- | --- |
| Common Lisp successor branch | PENDING |
| Common Lisp successor commit/tree | PENDING |
| Python successor branch | PENDING |
| Python successor commit/tree | PENDING |
| Integration successor branch | PENDING |
| Integration successor commit/tree | PENDING |
| Exact Common Lisp changed-file inventory | PENDING |
| Exact Python changed-file inventory | PENDING |
| Exact integration/evidence changed-file inventory | PENDING |
| Seed ancestry preservation proof | PENDING |
| Protected-path diff | PENDING |

## 8. Corpus and vector execution

| Evidence | Required | Final observed | Status |
| --- | ---:| ---:| --- |
| Registry definitions | 675 | PENDING | PENDING |
| Unique vector IDs | 215 | PENDING | BLOCKED for two exact expected paths |
| P001–P030 | 30 | PENDING | PENDING |
| N001–N032 | 32 | PENDING | BLOCKED for N012 |
| Official embedded canonical documents | 1,105 | PENDING | PENDING |
| Supplementary relation documents | 458 | PENDING | PENDING |
| Supplementary nested E1 documents | 30 | PENDING | PENDING |
| Supplementary subtotal | 488 | PENDING | PENDING |
| Complete recursive sweep | 1,593 | PENDING | PENDING |
| Underdetermined non-blocked results | 0 | PENDING | PENDING |
| Implementation-local expected results | 0 | PENDING | PENDING |

The official 1,105 and supplementary 488 counts remain distinct.

## 9. Differential, property, mutation, and host evidence

| Required item | Final value/status |
| --- | --- |
| Exact differential requests per implementation | PENDING |
| Total response count | PENDING |
| Hostile-input request count | PENDING |
| Property generator/hash | PENDING |
| Property seeds | PENDING |
| Property cases/requests | PENDING |
| Mutation cases/requests | PENDING |
| Common Lisp package/printer/readtable/hash profiles | PENDING |
| Python hash/dictionary/locale profiles | PENDING |
| Separate-process and ambient-unavailable profiles | PENDING |
| Minimized disagreements and regression vectors | PENDING |

Property generation remains gated on exact convergence of every non-blocked
fixture path.

## 10. Migration and loss-account evidence

| Required item | Final value/status |
| --- | --- |
| Frozen bounded grammar accepted/rejected cases | PENDING |
| Exact package/symbol/as-of/coordinate mappings | PENDING |
| Classification counts | PENDING |
| Closed represented-loss accounts | PENDING |
| Inert results | PENDING |
| Live warrants created | PENDING; required 0 |
| Live-restoration refusals | PENDING |
| Legacy code loads/current lookups | PENDING; required 0 |

Detailed receipt: `LCI0-V1-MIGRATION-FIXTURE-RECEIPT.md`.

## 11. CD/0 and v1 nonregression

| Gate | Historical floor | Final value/status |
| --- | --- | --- |
| CD/0 Phase 0 | 17 worked, 71 negatives, 39 Errata vectors | PENDING |
| CD/0 Common Lisp | 2,633 assertions; three declared N/A not pass | PENDING |
| CD/0 Python | 167/167 | PENDING |
| CD/0 differential | 467 requests per codec; zero issues | PENDING |
| Existing Mneme/v1 | 6/6 suites | PENDING |
| Frozen/protected source and octets | Unchanged | PENDING |
| Live authority/warrant systems introduced | Zero | PENDING |

Detailed receipt: `LCI0-NONREGRESSION-RECEIPT.md`.

## 12. Evidence archive and cleanup

The required sequence is raw-evidence commit → reproducible archive commit →
verified listing/checksums → cleanup commit deleting only recoverable loose raw
copies and safe generated detritus.

| Item | Commit/tree | Members | Bytes | SHA-256/status |
| --- | --- | ---:| ---:| --- |
| Baseline raw evidence | Commit `80f1202cc6d176d891179ca408d41136c9a28a97`; tree `c2e12bb976a923b9a17148ddf27c52489b5a0c9a` | 7 | 76,840,551 | Per-member hashes retained |
| Successor raw evidence | PENDING | PENDING | PENDING | PENDING |
| Reproducible final archive | PENDING | PENDING | PENDING | PENDING |
| Archive deterministic rebuild | PENDING | PENDING | PENDING | PENDING |
| Cleanup deletion inventory | PENDING | PENDING | PENDING | PENDING |
| Post-cleanup tree/checksum audit | PENDING | PENDING | PENDING | PENDING |

Frozen normative/fixture artifacts, immutable seed evidence, authored receipts,
user files, and the standalone backup bundle are not cleanup detritus.

## 13. Publication and remote read-back

| Item | Value/status |
| --- | --- |
| Non-force/atomic push command | PENDING |
| Common Lisp successor remote object | PENDING |
| Python successor remote object | PENDING |
| Integration successor remote object | PENDING |
| Fresh remote read-back command/result | PENDING |
| Local/remote equality | PENDING |
| Main merged | No merge authorized; final confirmation PENDING |

## 14. Independent implementation audit

| Item | Value/status |
| --- | --- |
| Fresh reviewer and independence boundary | PENDING |
| Commits/trees/archive reviewed | PENDING |
| Findings and required corrections | PENDING |
| Reviewer disposition | PENDING; no PASS exists |

## 15. Current relay disposition

Current status:

```text
BLOCKED — authorial closure and successor/final evidence required
```

Do not issue `eligible for independent implementation audit` from this draft.
Do not merge main. Do not begin production warrant, standing, cryptographic,
module-authority, or live-v1-migration work.
