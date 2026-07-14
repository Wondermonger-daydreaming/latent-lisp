# Fable LCI/0 Implementation Relay

Date: 2026-07-14

Requested disposition: **independent audit of the corrected unaffected
implementation/evidence, plus authorial closure on ten narrow packets.** Exact
r4/post final6 include the independent-audit corrections and have zero
unaffected mismatch. Overall LCI/0 conformance remains BLOCKED and no reviewer
PASS or merge recommendation is claimed.

> Paste-ready boundary: `unaffected implementation/evidence ready for
> independent audit; overall conformance BLOCKED pending authorial closure.`

## Authorization and boundary observed

Implementation was limited to independently seeded Common Lisp and Python
fixture implementations, frozen package consumption, ClaimId projection,
WarrantTarget validation/matching, fixture calculi and StableRefs, finite
Policy-A/B, inert v1 migration fixtures, and differential/hostile testing.

No production warrant or WarrantId, production standing/admissibility,
capability, authority, cryptographic choice, production module/procedure
identity, custody/verified lineage, live v1 migration, or CD/0 redesign is
implemented or claimed.

## Frozen authority identities

| Artifact | SHA-256 |
| --- | --- |
| LCI/0 candidate | `6fa2965ed727b4d89b09a3d9c171bcfa3aea8c23f486ef87dc33f85bcb9ae5ba` |
| Post-review ruling | `c2ee9dbb2b3fc72abf4745f5e9a8b4a04d9e1bfeab0fbe224d5c7946e11360a7` |
| Errata 0.1 | `f2bcea1db0e08fe271fdaa79c1f9d4406b94c2c730ab547c0024495ce962c5ea` |
| Fixture-package specification | `ac0c9265e9583c698c397801099efa548cdbf33f686ebff5bacc8bbea7cbcd2f` |
| Fixture registry | `dd19c6d6543a875b2e7e1e6a234ad731ce019f64495b447b317462c63f826327` |
| Fixture vectors | `387e76963f3087f6e41ec4363ec3eea29b1456c2a6b3c5a0cf5763418bffe3a4` |
| Fixture manifest / checksum file | `1e9b2d0d88da5ab50ffb777360e7a6f9f908b4fd7057d0038c757e24038819d7` / `d394678a851043e40d42cb7d382f77f113a54b5fcfe0bebcfed8825af6ec1050` |
| Frozen fixture ZIP | `36cc71ccf3c310a055199c54e84bf436c4505d92a6378f22e8b1d932f02e987d` |
| Fable PASS packet | `89cd11ac52478a9e3ff9ebdefcc60b2fff8fa2c8707e159b4f4bd0b6e2cefdfd` |
| Frozen CD/0 packet | `bc54a23bbd235fc0ee4d0485c2091585e506dbc7cf74b0e16318580465aa1f81` |

All final rechecks matched. Frozen specs, fixtures, CD/0 source, and production
Mneme/v1 source were not modified.

## Independence and implementation objects

The accurate claim is:

> Independently seeded implementations under shared normative infrastructure,
> with procedural—not OS-enforced—isolation.

| Object | Commit | Tree |
| --- | --- | --- |
| Common Lisp immutable seed | `b3d28bc49c3b015096cb04c6ad08c19829f511a9` | `d48c39f933cde591f3303fcd3c9f42a0dac1a869` |
| Python immutable seed | `4ec2e519d05aeacd2412cb8aedc5f76bde702571` | `9f7915b460f449976a5d7fa856861ad5ce1d36ca` |
| Common Lisp successor | `2513c354721bac6120b8c0a5eef1ed13252cf75b` | `9ce6786ee374f3dafe859c6ea5977b27e6c6f718` |
| Python successor | `db627cb6ca23abc0626aebc6f9982ab9b4406dbf` | `74c6a7e5c144d3286b83a933b27cff3d5865921d` |
| Integration code tested | `e6983952ea726366b69435b29eeb37eb76f8504d` | `daaef9bad97eced6c242fc8052cbedc8920d355a` |
| Current exact/post raw evidence | `7ff074fdc234d826a113b0beb5e36b490d94b579` | `3b6834114f8c1df4f8810b4a56f66f0bf66de8e2` |
| Superseded r3/final5 raw evidence | `041d53740165a122e27b08bf2cb097f0bd391161` | `ba00e2837cad7f107d846377bfbe33601802665f` |
| Nonregression raw evidence | `e552346123a35225023f5b33d8f288c7064e11da` | `62c405b0358a949c5590dbcc55b50c52a515ec8c` |

Both immutable seeds remain ancestors of their successors, and both successors
are ancestors of the tested integration commit. Neither implementation was an
oracle. The seed receipts retain their historical observations, but their old
`215/215` claims do not override the current four-vector authorial blocker
census.

### Independent-audit correction history

The r3/final5 audit identified six Python boundary defect families:
occurrence-versus-ClaimId projection and outer-schema closure; tagged-empty
profile-location admission, with N009's existing nested diagnostic preserved; target match
code/order and explicit proposition/identity/profile coordinates;
nonmonotonicity-before-coverage ordering; mutable `production`/`model-current`
aliases; and validation of both ClaimId equality operands. Corrected successor
`db627cb6...` adds ten direct regressions. Integration `e6983952...` adds eight
cross-language hostile cases. Python is 100/100, differential units are 53/53,
and Common Lisp is 77 pass, 0 fail, 18 authorially blocked. The earlier raw
evidence remains in history, while r4/final6 is current.
`LCI0-CORRECTION-VERIFICATION-AUDIT.md` records the fresh scope-limited audit;
it does not stand in for an external reviewer PASS.

## Final exact differential result

Exact r4 sent 2,295 requests to each implementation and received 4,590
responses with empty adapter stderr.

| Evidence | Common Lisp | Python | Disposition |
| --- | ---:| ---:| --- |
| Official canonical documents | 1,105/1,105 | 1,105/1,105 | exact |
| Supplementary relation documents | 458/458 | 458/458 | exact |
| Supplementary nested E1 documents | 30/30 | 30/30 | exact |
| Total package sweep | 1,593/1,593 | 1,593/1,593 | exact |
| Shared vectors | 211/215 | 211/215 | 4 BLOCKED |
| Relation semantics | 420/458 | 420/458 | 38 failure paths BLOCKED |
| Hostile inputs | 21/29 | 21/29 | 8 exact results BLOCKED |

There are zero unaffected mismatches. The 41 permitted cross differences are
exactly 38 blocked relation paths plus three blocked hostile results. The four
blocked vector documents are N012, E5 coverage-insufficient, P024, and P029.
No blocked item is counted as pass, failure, skip, or N/A.

Raw r4 bindings:

```text
requests       b6b17160d2fec5177d0faad0542d9b35c2047d521925ed302bc54e5d206d3e9c
Common Lisp    46695fbdcc3d7b449297c7d591473fb842ea1db93a151bb8e65e9c9492a693a7
Python         5b185919ab0599d43e845f9624faa17940c03bc6efb3c4988a4604505cff3542
summary        7f63cd0cb59c12d0d909f19e4fdc3d5625912c1ced7562c9aef7813ccfe25d7e
manifest       d81d084cac92b10bdc8bbde66f3f5a6e89dcf55f4b6b718762653ae4d1c6b994
```

## Property, mutation, and host evidence

Post-convergence final6 used seed `0x4C434930` (`1279478064`) and generated
329 deterministic cases. Six adapter profiles executed 1,974 requests. Ten
native profiles covered Common Lisp package/printer/readtable/hash insertion,
Python hash seeds/locales, source mutation, independent allocation, unavailable
I/O/network probes, and wall-clock/runtime perturbations. The run used 20
direct commands and 24 processes.

- zero nonblocked failures;
- 104 operation-payload cases have blocked category/stage/path/context
  coordinates;
- 14 policy/resource cases have specifically named blocked result fields;
- Common Lisp native suite: 77 pass, 0 fail, 18 BLOCKED;
- Python focused native suite: 8/8 pass.

Post summary SHA-256 is
`0a318264436c6b6dd018fa31188315610d4bea8486bd0c61463d9e6a9fdcce6c`;
its manifest SHA-256 is
`8ef26d59732db292ad307ae0bfc3b5db5d512a2291b771e208965afdbe449ead`.

## Ten requested authorial closures

| Packet | Requested closure |
| --- | --- |
| `LCI0-AUTHORIAL-RETURN-PACKET.md` | exact N012 universal/symbolic matcher composition and ordering |
| `...-RELATION-FAILURE-PATHS.md` | exact category/code/stage/path documents for 38 companion failures |
| `...-E5-COVERAGE-CONTEXT.md` | input binding, pure derivation, or corrected expected coverage context |
| `...-P029-SOURCE-ARTIFACT.md` | corrected source binding/result or explicit pure rebinding rule |
| `...-POLICY-EVALUATION-ORDER.md` | exact stale/loss/trust order and external-principal decision Identifier |
| `...-CORPUS-BASIS-COHERENCE.md` | executable coherence checks and exact failure tuple |
| `...-OPERATION-PAYLOAD-FAILURES.md` | closed payload schemas and complete failure documents for 52 operations |
| `...-MIGRATION-CLASSIFICATION-COUPLING.md` | total seven-class result/content coupling rule |
| `...-TARGET-BOUNDARY-COHERENCE.md` | executable kind-specific coherence algorithms and negative vectors |
| `...-P024-REVIVAL.md` | pure field transform, bound new occurrence fields, or corrected expectation |

These packets are narrow. Unaffected work is not stopped, but no missing rule
was silently chosen and no implementation was made to copy the other.

## Migration and nonregression

All determinate migration fixtures agree, represented-loss accounts remain
closed, migrated results remain inert, attempted live restoration is refused,
live warrants created are zero, and legacy v1 code/current lookups are zero.
P024, P029, and novel classification coupling remain blocked as listed above.

Protected floors were rerun at the final integration boundary:

| Gate | Result |
| --- | --- |
| CD/0 Phase 0 | PASS: 17 worked, 71 classified negatives, 39 Errata cases |
| CD/0 Common Lisp | PASS: 2,633 assertions; 3 declared N/A not pass |
| CD/0 Python | PASS: 167/167 |
| CD/0 differential | PASS: 467 requests/codec; zero issues |
| Existing Mneme/v1 | PASS: 6/6 suites |
| Protected source/object comparison | unchanged |
| Production live authority/warrant systems added | zero |

## Evidence/archive/publication state

The current exact/post raw files were committed at `7ff074f...`; superseded
r3/final5 evidence remains at `041d537...`; protected nonregression raw files
were refreshed at `e552346...`. Archive commit `37cdf0a...` preserves every
stream, and cleanup commit `e21ef1a...` removes only recoverable loose copies
from the final tip.

| Item | Status |
| --- | --- |
| Reproducible evidence archive members/bytes/SHA-256 | 180 / 9,573,988 / `afad708a44b467c5945679001c0b49b5dbbfc6990e02a6c43d1fb4485b9a15fa` |
| Deterministic archive rebuild | PASS; two byte-identical builds and zero extracted manifest discrepancy |
| Cleanup commit and loose-file deletion inventory | `e21ef1ae40335c7f8ac00de51edaf0c766f27feb`; 63 files / 232,093,546 bytes; exact path list in Git name-status |
| Non-force branch push and remote read-back | PENDING |
| Independent reviewer disposition | PENDING; no PASS exists |

Main was not merged. Frozen artifacts, seeds, authored receipts, the standalone
backup bundle, and user files are not cleanup detritus.

## Paste-ready Fable implementation-audit relay

```text
LCI/0 IMPLEMENTATION RELAY — 2026-07-14

Authorization boundary observed. Common Lisp seed
b3d28bc49c3b015096cb04c6ad08c19829f511a9 and Python seed
4ec2e519d05aeacd2412cb8aedc5f76bde702571 were independently seeded under
shared normative infrastructure with procedural, not OS-enforced, isolation.
Reviewed successors are 2513c354721bac6120b8c0a5eef1ed13252cf75b and
db627cb6ca23abc0626aebc6f9982ab9b4406dbf. Exact and post-convergence code
was tested at e6983952ea726366b69435b29eeb37eb76f8504d, tree
daaef9bad97eced6c242fc8052cbedc8920d355a.

Each implementation reproduced 1,105 official plus 488 supplementary
canonical documents. Exact r4 executed 2,295 requests per implementation:
211/215 vectors exact with four authorially blocked; 420/458 relation results
exact with 38 failure paths blocked; 21/29 hostile results exact with eight
blocked. There are zero unaffected mismatches. Post-convergence final6 ran 329
deterministic cases at seed 0x4C434930 across six adapter profiles and ten
native profiles, with zero nonblocked failures; 104 failure-coordinate and 14
result-coordinate cases remain explicitly blocked.

CD/0 Phase 0, CD/0 Common Lisp (2,633 assertions, three N/A retained as N/A),
CD/0 Python (167/167), CD/0 differential (467 requests/codec, zero issues),
and Mneme/v1 (6/6) are green. Protected objects are unchanged. Zero live
warrants or production authority systems were introduced.

Please issue authorial closure for the ten attached narrow packets: N012;
relation failure paths; E5 coverage context; P029 source artifact; policy
order/decision identity; CorpusBasis coherence tuple; operation payload
failure schemas; MigrationResult coupling; target-boundary algorithms; and
P024 revival source fields.

STATUS: corrected unaffected implementation/evidence ready for independent
audit. Overall LCI/0 conformance remains BLOCKED pending the ten authorial
closures. Reviewer PASS, merge eligibility, and production authorization are
not claimed.
```
