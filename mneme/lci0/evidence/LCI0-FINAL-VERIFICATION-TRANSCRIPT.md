# LCI/0 Final Verification Transcript

Date opened: 2026-07-14

Status: DRAFT; successor verification PENDING; three authorial paths BLOCKED

This is a fill-forward transcript for the final integration-successor run. It
contains verified preflight, immutable-seed, and baseline facts, but it is not a
final PASS transcript and must not be used to assert audit eligibility.

## 1. Evidence boundary: baseline versus successor

The baseline is the unchanged dual-seed integration used to discover and
classify disagreements. The successor is the independently corrected language
branches merged only after baseline evidence was frozen. These evidentiary
roles must not be collapsed.

| Layer | Commit/tree | What it establishes | What it does not establish |
| --- | --- | --- | --- |
| Shared infrastructure | Commit `ab353b4b7f30d5e46323d274862e6c1212ebf514` | Frozen normative/fixture infrastructure and worktree base | Any language implementation result |
| Common Lisp immutable seed | Commit `b3d28bc49c3b015096cb04c6ad08c19829f511a9`; tree `d48c39f933cde591f3303fcd3c9f42a0dac1a869` | Procedurally isolated first implementation and seed-gate evidence | Cross-language convergence or post-baseline corrections |
| Python immutable seed | Commit `4ec2e519d05aeacd2412cb8aedc5f76bde702571`; tree `9f7915b460f449976a5d7fa856861ad5ce1d36ca` | Procedurally isolated first implementation and seed-gate evidence | Cross-language convergence or post-baseline corrections |
| Unchanged seed integration | Commit `71f7cfc5ebe392d59d820203dad11cc2e86a0542` | Both immutable seeds imported without copying one into the other | Correctness after discovered divergences |
| Baseline evidence | Commit `80f1202cc6d176d891179ca408d41136c9a28a97`; tree `c2e12bb976a923b9a17148ddf27c52489b5a0c9a` | Raw differential requests/responses and initial classifications | Successor convergence, final nonregression, archive/cleanup, or publication |
| Common Lisp successor | PENDING | Independently reasoned corrections from baseline witnesses | PENDING |
| Python successor | PENDING | Independently reasoned corrections from baseline witnesses | PENDING |
| Integration successor | PENDING | Recombined corrected implementations and rerun evidence | PENDING |

### Immutable seed-receipt limitation and supersession

The two seed receipts remain immutable historical records of what each seed
observed before cross-reading. They are not amended, rewritten, or retroactively
declared false merely because hostile differential testing exposed incomplete
closure. For successor/final conclusions, their implementation-result claims
are superseded by the baseline divergence ledger and the future successor
receipts wherever those later artifacts add a narrower witness or contradiction.

Specifically:

- seed corpus and red-baseline transcripts retain their historical standing;
- seed claims of zero unresolved implementation-versus-fixture mismatch do not
  govern after `LCI0-DIV-002` through `LCI0-DIV-015` were observed;
- no successor correction may rewrite a seed commit or weaken the accurate
  independence statement;
- only the final successor trees and their fresh evidence may support a final
  implementation conclusion.

The accurate claim is: independently seeded implementations under shared
normative infrastructure, with procedural—not OS-enforced—isolation.

## 2. Repository, host, and authority record

| Field | Verified preflight value | Final-run value |
| --- | --- | --- |
| Repository | `/home/gauss/Codex-Lab/latent-lisp` | PENDING |
| Origin fetch/push URL | `https://github.com/Wondermonger-daydreaming/latent-lisp.git` | PENDING read-back |
| Fetched `origin/main` | `26ac543856e30c340cc2dd4359802442636f4b94` | PENDING confirmation |
| Host | Ubuntu 24.04.3 LTS under WSL2; Linux `6.18.33.2-microsoft-standard-WSL2`, x86-64 | PENDING |
| Locale/timezone | `C.UTF-8`; `America/Sao_Paulo` | PENDING |
| Git | 2.43.0 | PENDING |
| Common Lisp | SBCL 2.4.6 | PENDING |
| Python | CPython 3.11.14 | PENDING |

## 3. Normative and package identities

| Artifact | Verified SHA-256 | Final recheck |
| --- | --- | --- |
| `LOCATED-CLAIM-IDENTITY-SPEC.md` | `6fa2965ed727b4d89b09a3d9c171bcfa3aea8c23f486ef87dc33f85bcb9ae5ba` | PENDING |
| `LCI0-POST-REVIEW-RULING.md` | `c2ee9dbb2b3fc72abf4745f5e9a8b4a04d9e1bfeab0fbe224d5c7946e11360a7` | PENDING |
| `LOCATED-CLAIM-IDENTITY-SPEC-ERRATA-0.1.md` | `f2bcea1db0e08fe271fdaa79c1f9d4406b94c2c730ab547c0024495ce962c5ea` | PENDING |
| `LCI0-NORMATIVE-FIXTURE-PACKAGE-SPEC.md` | `ac0c9265e9583c698c397801099efa548cdbf33f686ebff5bacc8bbea7cbcd2f` | PENDING |
| `LCI0-FIXTURE-REGISTRY.json` | `dd19c6d6543a875b2e7e1e6a234ad731ce019f64495b447b317462c63f826327` | PENDING |
| `LCI0-FIXTURE-VECTORS.jsonl` | `387e76963f3087f6e41ec4363ec3eea29b1456c2a6b3c5a0cf5763418bffe3a4` | PENDING |
| Fixture manifest | `1e9b2d0d88da5ab50ffb777360e7a6f9f908b4fd7057d0038c757e24038819d7` | PENDING |
| Fixture checksum file | `d394678a851043e40d42cb7d382f77f113a54b5fcfe0bebcfed8825af6ec1050` | PENDING |
| Fixture ZIP | `36cc71ccf3c310a055199c54e84bf436c4505d92a6378f22e8b1d932f02e987d` | PENDING |
| Fable PASS packet | `89cd11ac52478a9e3ff9ebdefcc60b2fff8fa2c8707e159b4f4bd0b6e2cefdfd` | PENDING |
| Frozen CD/0 packet | `bc54a23bbd235fc0ee4d0485c2091585e506dbc7cf74b0e16318580465aa1f81` | PENDING |

If any final recheck differs, stop. Do not continue with a nearby or regenerated
revision.

## 4. Backup and branch/worktree preservation

| Item | Verified or required value | Final status |
| --- | --- | --- |
| Immutable backup ref | `refs/backup/lci0-preimplementation-2026-07-14-26ac543` → `26ac543856e30c340cc2dd4359802442636f4b94` | PENDING confirmation |
| Standalone preimplementation bundle | 252,666,673 bytes; SHA-256 `b3bf606b892d8e47353248a69a3a534bff4cd4ad2708c587d7ebcbc57c54c936` | PENDING recheck |
| Common Lisp seed branch preserved | `codex/lci0-common-lisp` | PENDING ancestry audit |
| Python seed branch preserved | `codex/lci0-python` | PENDING ancestry audit |
| Integration baseline preserved | `codex/lci0-integration` at/after evidence commit | PENDING final branch map |
| Common Lisp successor branch | PENDING | PENDING |
| Python successor branch | PENDING | PENDING |
| Integration successor branch | PENDING | PENDING |
| Main modified or merged | Must be no | PENDING confirmation |

## 5. Baseline differential transcript

Command run from the integration worktree:

```text
PYTHONDONTWRITEBYTECODE=1 PYTHONPATH=mneme/lci0/differential:mneme/lci0/python:canonical-datum/python python3 mneme/lci0/differential/run_differential.py
```

| Baseline class | Per implementation |
| --- | ---:|
| Official document roundtrips | 1,105 |
| Supplementary relation document roundtrips | 458 |
| Supplementary nested E1 roundtrips | 30 |
| Shared vector semantic executions | 215 |
| Full relation semantic executions | 458 |
| Baseline subtotal | 2,266 |
| Deterministic hostile witnesses | 15 |
| Total | 2,281 |

The adapters returned 4,562 uniquely keyed responses with empty stderr. Both
roundtripped 1,593/1,593 documents. Common Lisp reproduced 215/215 baseline
vector expected documents; Python reproduced 210/215. Common Lisp matched
117/169 scope and 259/289 temporal relation values; Python matched all 458.
The hostile matrix exposed shared and language-specific closure defects. These
are baseline defect observations, not successor results.

Baseline raw evidence is retained under
`mneme/lci0/differential/artifacts/baseline-2026-07-14/` and bound in
`LCI0-DIFFERENTIAL-RECEIPT.md`.

## 6. Successor commits and changed-file inventories

| Branch | Commit | Tree | Parent/seed ancestry | Immutable after review |
| --- | --- | --- | --- | --- |
| Common Lisp successor | PENDING | PENDING | PENDING | PENDING |
| Python successor | PENDING | PENDING | PENDING | PENDING |
| Integration successor | PENDING | PENDING | PENDING | PENDING |
| Documentation/archive commit | PENDING | PENDING | PENDING | PENDING |
| Cleanup commit | PENDING | PENDING | PENDING | PENDING |

### Common Lisp changed files

PENDING exact `git diff --name-status` inventory.

### Python changed files

PENDING exact `git diff --name-status` inventory.

### Integration/evidence changed files

PENDING exact `git diff --name-status` inventory, including differential
harness, receipts, raw transcript commit, archive commit, and cleanup commit.

### Protected-path diff

PENDING. Expected empty for `canonical-datum/`, `mneme/latent-mvp/`, frozen
normative/fixture content, and `mneme/verify-all.sh`.

## 7. Successor verification command log

| Seq. | Worktree/commit | Exact command | Runtime/profile | Exit | Count/result | Duration | Evidence member |
| ---:| --- | --- | --- | ---:| --- | --- | --- |
| 01 | Common Lisp successor | PENDING | PENDING | PENDING | PENDING | PENDING | PENDING |
| 02 | Python successor | PENDING | PENDING | PENDING | PENDING | PENDING | PENDING |
| 03 | Integration successor exact differential | PENDING | PENDING | PENDING | PENDING | PENDING | PENDING |
| 04 | Integration corpus sweep | PENDING | PENDING | PENDING | PENDING | PENDING | PENDING |
| 05 | Common Lisp host perturbations | PENDING | PENDING | PENDING | PENDING | PENDING | PENDING |
| 06 | Python host perturbations | PENDING | PENDING | PENDING | PENDING | PENDING | PENDING |
| 07 | Shared mutation/property suite | PENDING | PENDING | PENDING | PENDING | PENDING | PENDING |
| 08 | v1 fixture migration suite | PENDING | PENDING | PENDING | PENDING | PENDING | PENDING |
| 09 | Frozen CD/0 Phase 0 | PENDING | PENDING | PENDING | PENDING | PENDING | PENDING |
| 10 | Frozen CD/0 Common Lisp | PENDING | PENDING | PENDING | PENDING | PENDING | PENDING |
| 11 | Frozen CD/0 Python | PENDING | PENDING | PENDING | PENDING | PENDING | PENDING |
| 12 | Frozen CD/0 differential | PENDING | PENDING | PENDING | PENDING | PENDING | PENDING |
| 13 | Existing Mneme/v1 floor | PENDING | PENDING | PENDING | PENDING | PENDING | PENDING |
| 14 | Evidence checksum/archive verification | PENDING | PENDING | PENDING | PENDING | PENDING | PENDING |
| 15 | Fresh independent implementation audit | PENDING | PENDING | PENDING | PENDING | PENDING | PENDING |

## 8. Successor count ledger

| Evidence class | Common Lisp | Python | Coordinator/differential | Status |
| --- | ---:| ---:| ---:| --- |
| Official embedded documents | PENDING | PENDING | Required 1,105 | PENDING |
| Supplementary relation documents | PENDING | PENDING | Required 458 | PENDING |
| Supplementary nested E1 documents | PENDING | PENDING | Required 30 | PENDING |
| Total recursive corpus | PENDING | PENDING | Required 1,593 | PENDING |
| Unique vector IDs | PENDING | PENDING | Required 215 | BLOCKED for two exact vector documents |
| Required P001–P030 | PENDING | PENDING | Required 30 | PENDING |
| Required N001–N032 | PENDING | PENDING | Required 32 | BLOCKED for N012 |
| Relation values | PENDING | PENDING | Required 458 | PENDING values; 38 paths BLOCKED |
| Exact differential requests | PENDING | PENDING | PENDING | PENDING |
| Hostile-input requests | PENDING | PENDING | PENDING | PENDING |
| Property cases/requests | PENDING | PENDING | PENDING | PENDING |
| Mutation cases/requests | PENDING | PENDING | PENDING | PENDING |
| Underdetermined results | PENDING | PENDING | Required 0 outside blocked paths | PENDING |
| Implementation-local expected results | PENDING | PENDING | Required 0 | PENDING |

## 9. Property, mutation, and host profiles

| Field | Value/status |
| --- | --- |
| Exact-convergence gate | PENDING |
| Property generator/hash | PENDING |
| Seeds | PENDING |
| Cases per seed | PENDING |
| Total property requests | PENDING |
| Mutation count | PENDING |
| Common Lisp package/printer/readtable/hash profiles | PENDING |
| Python hash-seed/dictionary/locale profiles | PENDING |
| Separate-process profiles | PENDING |
| Unavailable filesystem/network profiles | PENDING |
| Wall-clock/runtime-state profiles | PENDING |
| Minimized disagreements | PENDING |

## 10. Migration fixture result

| Field | Value/status |
| --- | --- |
| Valid fixture grammar cases | PENDING |
| Rejected undeclared grammar/source cases | PENDING |
| Exact mapping cases | PENDING |
| Classification counts | PENDING |
| Represented-loss account counts | PENDING |
| Inert migration results | PENDING |
| Live warrants created | PENDING; must be 0 |
| Live-restoration attempts refused | PENDING |
| Legacy runtime loads/lookups | PENDING; must be 0 |

See `LCI0-V1-MIGRATION-FIXTURE-RECEIPT.md` for the detailed fill-in table.

## 11. Authorial-return register

| Packet | Smallest blocked surface | Current disposition | Final authorial response/hash |
| --- | --- | --- | --- |
| `LCI0-AUTHORIAL-RETURN-PACKET.md` | N012 universal/symbolic direct matcher composition | BLOCKED; other 214 vectors may continue | PENDING |
| `LCI0-AUTHORIAL-RETURN-PACKET-RELATION-FAILURE-PATHS.md` | 38 unpinned companion failure paths | BLOCKED; 458 relation values remain testable | PENDING |
| `LCI0-AUTHORIAL-RETURN-PACKET-E5-COVERAGE-CONTEXT.md` | Expected-only E5 `actual-coverage-scope` context | BLOCKED; failure tuple remains testable | PENDING |

No implementation is an oracle. No missing semantic rule may be resolved by
copying the other implementation. These blocked paths are not N/A and are not
included in pass counts.

## 12. Divergence ledger closure

| Classification | Open | Resolved | Permanent regression | Status |
| --- | ---:| ---:| ---:| --- |
| Common Lisp defect | PENDING | PENDING | PENDING | PENDING |
| Python defect | PENDING | PENDING | PENDING | PENDING |
| Fixture-adapter defect | PENDING | PENDING | PENDING | PENDING |
| Fixture-package ambiguity | PENDING | PENDING | PENDING | BLOCKED where authorial packet applies |
| Specification/errata ambiguity | PENDING | PENDING | PENDING | BLOCKED where authorial packet applies |
| Harness defect | PENDING | PENDING | PENDING | PENDING |
| Host semantic leak | PENDING | PENDING | PENDING | PENDING |

Complete dispositions remain in `LCI0-IMPLEMENTATION-DIVERGENCES.md`.

## 13. Nonregression

| Gate | Expected | Final result |
| --- | --- | --- |
| Frozen CD/0 Phase 0 | Existing counts/hashes unchanged | PENDING |
| Frozen CD/0 Common Lisp | 2,633 assertions; three N/A retained as N/A | PENDING |
| Frozen CD/0 Python | 167/167 | PENDING |
| Frozen CD/0 differential | 467 requests per codec; zero issues | PENDING |
| Existing Mneme/v1 | 6/6 suites green | PENDING |
| Protected tracked-source diff | Empty | PENDING |
| Live warrant/authority/standing additions | Zero | PENDING |

See `LCI0-NONREGRESSION-RECEIPT.md` for the exact protected inventory and
command slots.

## 14. Raw evidence, archive, and cleanup sequence

The required order is: commit raw transcripts; build and inspect a reproducible
archive containing them; commit the archive and checksum manifest; only then
delete safe loose copies and other operation detritus in a separate cleanup
commit. Git history and the archive must retain the raw evidence.

| Step | Commit | Tree | Members/count | Bytes | SHA-256/result |
| --- | --- | --- | --- | ---:| --- |
| Baseline raw transcript evidence | `80f1202cc6d176d891179ca408d41136c9a28a97` | `c2e12bb976a923b9a17148ddf27c52489b5a0c9a` | 7 baseline members | 76,840,551 known bytes across listed files | Per-member hashes in differential receipt |
| Successor raw transcripts | PENDING | PENDING | PENDING | PENDING | PENDING |
| Reproducible evidence archive | PENDING | PENDING | PENDING | PENDING | PENDING |
| Archive deterministic rebuild | PENDING | PENDING | PENDING | PENDING | PENDING |
| Cleanup of loose raw files/detritus | PENDING | PENDING | PENDING deletion inventory | PENDING | PENDING |
| Post-cleanup checksum/tree audit | PENDING | PENDING | PENDING | PENDING | PENDING |

Safe cleanup candidates must be proven generated and recoverable before
deletion. Frozen specs, fixtures, seeds, authored receipts, user files, and the
standalone preimplementation bundle are not detritus.

## 15. Publication and remote read-back

| Field | Value/status |
| --- | --- |
| Branches pushed | PENDING |
| Push mode | PENDING; must be non-force, atomic where practical |
| Push command/output | PENDING |
| Remote Common Lisp successor object | PENDING |
| Remote Python successor object | PENDING |
| Remote integration successor object | PENDING |
| Fresh fetch/read-back command | PENDING |
| Local/remote object equality | PENDING |
| Main merge | Must be no; PENDING confirmation |

## 16. Fresh independent audit

| Field | Value/status |
| --- | --- |
| Reviewer/agent and independence boundary | PENDING |
| Reviewed commits/trees | PENDING |
| Reviewed archive/checksum manifest | PENDING |
| Audit commands | PENDING |
| Findings | PENDING |
| Required changes | PENDING |
| Reviewer disposition | PENDING; no PASS exists |

## 17. Current final-status line

`BLOCKED — not eligible for independent implementation audit while three
authorial-return packets and successor/final evidence remain unresolved.`

This line may be replaced only after authorial closure, non-blocked exact
convergence, final nonregression, archive/cleanup verification, publication
read-back, and the required independent implementation audit evidence. Do not
merge main and do not begin production warrant, standing, cryptographic,
module-authority, or live-v1-migration work.
