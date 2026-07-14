# LCI/0 Final Verification Transcript

Date: 2026-07-14

Status: **corrected unaffected implementation/evidence ready for independent
audit; overall conformance BLOCKED pending authorial closure.** Exact r4 and
post final6 include the six Python boundary families found by the independent
audit and have zero unaffected mismatch. This is not overall conformance,
reviewer PASS, merge eligibility, or production authorization.

## 1. Evidence boundary and implementation identities

| Layer | Commit | Tree | Standing |
| --- | --- | --- | --- |
| Shared infrastructure | `ab353b4b7f30d5e46323d274862e6c1212ebf514` | `26d0714ba873ce4a44a978f7acf98d21fd3fc176` | Frozen shared normative/fixture base |
| Common Lisp immutable seed | `b3d28bc49c3b015096cb04c6ad08c19829f511a9` | `d48c39f933cde591f3303fcd3c9f42a0dac1a869` | First procedurally isolated implementation |
| Python immutable seed | `4ec2e519d05aeacd2412cb8aedc5f76bde702571` | `9f7915b460f449976a5d7fa856861ad5ce1d36ca` | First procedurally isolated implementation |
| Unchanged-seed integration | `71f7cfc5ebe392d59d820203dad11cc2e86a0542` | `2bcc1c6ea363b9de2114db673a9ca509632fa68b` | Imports the seeds unchanged; discovery only |
| Baseline raw evidence | `80f1202cc6d176d891179ca408d41136c9a28a97` | `c2e12bb976a923b9a17148ddf27c52489b5a0c9a` | Initial divergences and minimized witnesses |
| Common Lisp successor | `2513c354721bac6120b8c0a5eef1ed13252cf75b` | `9ce6786ee374f3dafe859c6ea5977b27e6c6f718` | Independently reasoned Common Lisp corrections |
| Python successor | `db627cb6ca23abc0626aebc6f9982ab9b4406dbf` | `74c6a7e5c144d3286b83a933b27cff3d5865921d` | Corrected audited Python successor |
| Integration code tested | `e6983952ea726366b69435b29eeb37eb76f8504d` | `daaef9bad97eced6c242fc8052cbedc8920d355a` | Exact r4, new audit-hostile regressions, and post final6 identity |
| Current exact/post raw transcript commit | `7ff074fdc234d826a113b0beb5e36b490d94b579` | `3b6834114f8c1df4f8810b4a56f66f0bf66de8e2` | Commits complete r4/final6 loose raw transcripts |
| Superseded r3/final5 raw transcript commit | `041d53740165a122e27b08bf2cb097f0bd391161` | `ba00e2837cad7f107d846377bfbe33601802665f` | Retained audit history; not current evidence |
| Nonregression raw transcript commit | `e552346123a35225023f5b33d8f288c7064e11da` | `62c405b0358a949c5590dbcc55b50c52a515ec8c` | Refreshes the five protected-floor transcripts after the audit fixes |
| Corrected documentation | `a8bfdbdc3f10e8c57b1b4a9c14edbea00b9ba270` | `6cefd2f09f30a65ce9d5e81eef756de6aaa0624b` | Detailed relay plus correction-verification audit |
| Reproducible evidence archive | `37cdf0acbffc6e1f245c1870d9d68fd298151eca` | `fb0b6d765564eb7b155789fda8d8de228859fc10` | Commits archive, receipt, and checksum manifest before cleanup |
| Archive-covered loose-file cleanup | `e21ef1ae40335c7f8ac00de51edaf0c766f27feb` | `330c0c9aede619891c60a552a6cf745cc9463aeb` | Removes 63 recoverable streams only |

Both successor commits descend from their immutable seeds, and both successor
commits are ancestors of the tested integration commit. The accurate claim is:

> Independently seeded implementations under shared normative infrastructure,
> with procedural—not OS-enforced—isolation.

The seed receipts' historical `215/215` statements are not current conformance
claims. Their seed chronology and inspection inventories remain valid; their
semantic conclusions are superseded by the current four-vector blocker census
where the later evidence is narrower.

### Independent-audit correction history

The first r3/final5 audit found six Python defect families: a ClaimId projection
path could unwrap an occurrence and bypass the outer closed schema; a tagged
Mneme profile-location with empty coordinates was admitted, while N009's
existing nested diagnostic was preserved; target matching omitted proposition/identity-policy/profile/
profile-location code and ordering checks; narrowing coverage was tested before
nonmonotonicity; `production` and `model-current` aliases were admitted; and
ClaimId equality did not validate both operands. Commit `db627cb6...` corrected all six and
added ten direct Python regression tests. Integration commit `e6983952...`
added eight cross-language hostile requests and corresponding adapter/harness
tests. The corrected Python suite is 100/100, differential units are 53/53,
and Common Lisp remains 77 pass, 0 fail, 18 authorially blocked. The audit
history remains evidence; r4/final6 is the current execution boundary.
The separately tasked correction-verification result is preserved in
`LCI0-CORRECTION-VERIFICATION-AUDIT.md`; it is scope-limited and is not the
external reviewer PASS required for merge eligibility.

## 2. Repository, host, backup, and branch boundary

| Field | Value |
| --- | --- |
| Integration worktree | `/home/gauss/Codex-Lab/latent-lisp-lci0-integration-successor` |
| Origin | `https://github.com/Wondermonger-daydreaming/latent-lisp.git` |
| Fetched `origin/main` | `26ac543856e30c340cc2dd4359802442636f4b94` |
| OS | Ubuntu 24.04.3 LTS under WSL2; Linux `6.18.33.2-microsoft-standard-WSL2`, x86-64 |
| Python | CPython 3.11.14 |
| Common Lisp | SBCL 2.4.6 |
| Immutable backup ref | `refs/backup/lci0-preimplementation-2026-07-14-26ac543` → `26ac543856e30c340cc2dd4359802442636f4b94` |
| Standalone preimplementation bundle | 252,666,673 bytes; SHA-256 `b3bf606b892d8e47353248a69a3a534bff4cd4ad2708c587d7ebcbc57c54c936` |
| Development branches | `codex/lci0-common-lisp-successor`, `codex/lci0-python-successor`, `codex/lci0-integration-successor` |
| Main merge | Not performed and not authorized |

The previously disclosed integration-worktree current-directory deviation is
unchanged: seed merge objects `376f870e7b47c054f5cae4958259ef5a60ccf1cf`
and `71f7cfc5ebe392d59d820203dad11cc2e86a0542` were preserved without
amendment; only the branch/worktree pointers were corrected. This is a
procedural disclosure, not a content rewrite.

## 3. Normative identities

Final rechecking reproduced the authoritative identities:

| Artifact | SHA-256 |
| --- | --- |
| `LOCATED-CLAIM-IDENTITY-SPEC.md` | `6fa2965ed727b4d89b09a3d9c171bcfa3aea8c23f486ef87dc33f85bcb9ae5ba` |
| `LCI0-POST-REVIEW-RULING.md` | `c2ee9dbb2b3fc72abf4745f5e9a8b4a04d9e1bfeab0fbe224d5c7946e11360a7` |
| `LOCATED-CLAIM-IDENTITY-SPEC-ERRATA-0.1.md` | `f2bcea1db0e08fe271fdaa79c1f9d4406b94c2c730ab547c0024495ce962c5ea` |
| `LCI0-NORMATIVE-FIXTURE-PACKAGE-SPEC.md` | `ac0c9265e9583c698c397801099efa548cdbf33f686ebff5bacc8bbea7cbcd2f` |
| `LCI0-FIXTURE-REGISTRY.json` | `dd19c6d6543a875b2e7e1e6a234ad731ce019f64495b447b317462c63f826327` |
| `LCI0-FIXTURE-VECTORS.jsonl` | `387e76963f3087f6e41ec4363ec3eea29b1456c2a6b3c5a0cf5763418bffe3a4` |
| Fixture package manifest | `1e9b2d0d88da5ab50ffb777360e7a6f9f908b4fd7057d0038c757e24038819d7` |
| Fixture checksum file | `d394678a851043e40d42cb7d382f77f113a54b5fcfe0bebcfed8825af6ec1050` |
| Frozen fixture ZIP | `36cc71ccf3c310a055199c54e84bf436c4505d92a6378f22e8b1d932f02e987d` |
| Fable PASS packet | `89cd11ac52478a9e3ff9ebdefcc60b2fff8fa2c8707e159b4f4bd0b6e2cefdfd` |
| Frozen CD/0 packet | `bc54a23bbd235fc0ee4d0485c2091585e506dbc7cf74b0e16318580465aa1f81` |

No normative document, registry, vector, package archive, or frozen CD/0
artifact was modified.

## 4. Exact differential r4

Command shape:

```text
PYTHONDONTWRITEBYTECODE=1 \
PYTHONPATH=mneme/lci0/differential:mneme/lci0/python:canonical-datum/python \
python3 mneme/lci0/differential/run_differential.py \
  --output /tmp/lci0-exact-final-head-r4-20260714
```

| Measure | Common Lisp | Python |
| --- | ---:| ---:|
| Requests | 2,295 | 2,295 |
| Official embedded documents | 1,105/1,105 | 1,105/1,105 |
| Supplementary relation documents | 458/458 | 458/458 |
| Supplementary nested E1 documents | 30/30 | 30/30 |
| Complete recursive corpus | 1,593/1,593 | 1,593/1,593 |
| Shared vectors | 211 exact + 4 BLOCKED | 211 exact + 4 BLOCKED |
| Relation semantics | 420 exact + 38 path BLOCKED | 420 exact + 38 path BLOCKED |
| Hostile inputs | 21 exact + 8 result BLOCKED | 21 exact + 8 result BLOCKED |

There were 4,590 uniquely keyed responses and empty adapter stderr. The 41
allowed cross-implementation differences consist only of 38 authorially
unpinned relation failure paths and three authorially blocked hostile results.
Both implementations have zero mismatch outside the declared blocked set.

The four blocked vector documents are `LCI0-N012`,
`LCI0-E5-COVERAGE-INSUFFICIENT`, `LCI0-P024`, and `LCI0-P029`. They are not
pass, failure, skip, N/A, or implementation-local expected results.

Exact raw identities:

| Member | Bytes | SHA-256 |
| --- | ---:| --- |
| `requests.jsonl` | 24,458,265 | `b6b17160d2fec5177d0faad0542d9b35c2047d521925ed302bc54e5d206d3e9c` |
| `common-lisp-responses.jsonl` | 25,763,401 | `46695fbdcc3d7b449297c7d591473fb842ea1db93a151bb8e65e9c9492a693a7` |
| `python-responses.jsonl` | 25,753,084 | `5b185919ab0599d43e845f9624faa17940c03bc6efb3c4988a4604505cff3542` |
| `summary.json` | 1,541,123 | `7f63cd0cb59c12d0d909f19e4fdc3d5625912c1ced7562c9aef7813ccfe25d7e` |
| `sha256-manifest.json` | 804 | `d81d084cac92b10bdc8bbde66f3f5a6e89dcf55f4b6b718762653ae4d1c6b994` |

## 5. Post-convergence property, mutation, and host run final6

The post-convergence gate consumed the exact r4 artifacts rather than
reconstructing a second oracle. Its status is
`converged-unaffected-with-authorial-blockers`.

| Measure | Result |
| --- | --- |
| Deterministic seed | `0x4C434930` (`1279478064`) |
| Generated cases | 329 |
| Adapter profiles | 6 (2 Common Lisp, 4 Python) |
| Adapter requests | 1,974 (`329 × 6`) |
| Failure-coordinate-blocked cases | 104; 208 cross-language baseline observations |
| Result-coordinate-blocked cases | 14; 28 cross-language baseline observations |
| Nonblocked failures | 0 |
| Direct commands | 20 |
| Separate processes | 24, including four nested Python runners |
| Common Lisp native suite | 77 pass, 0 fail, 18 BLOCKED |
| Python focused native suite | 8/8 pass |

The 329 families include 64 metadata-neutrality cases, 64 record-allocation
order cases, 9 identity-coordinate cases, 26 resource boundaries, 22 target
schema/unknown boundaries, 104 payload-closure mutations, migration grammar
and inertness cases, rational/Unicode/identifier boundaries, and semantic
anti-shortcut twins.

Host profiles cover Common Lisp package, printer, readtable, hash insertion,
baseline, and unavailable-I/O/clock settings; Python hash seeds
`0,1,42,4294967295` with locales `C,C,C.utf8,POSIX`; independently allocated
equal values; mutated source buffers; unavailable filesystem/network probes;
and changed wall-clock/runtime markers. Cross-adapter I/O denial is limited by
the need to load the frozen package: Python native probes patch filesystem,
socket, and clock entry points after setup; Common Lisp uses an unavailable
default pathname and procedural network isolation because no socket subsystem
is loaded.

Post-run raw identities include:

| Member | Bytes | SHA-256 |
| --- | ---:| --- |
| `requests.jsonl` | 8,818,612 | `41f979e6b946b22fda82c5fd3dae3ee17137ce21ecea86fc044d3213783fde89` |
| `cases.json` | 243,600 | `5a573656458f41a8418e9d2fc8a8f5d97aea5cd3c373dd30cc5999b1f281f6d1` |
| `command-transcript.jsonl` | 27,472 | `2cadd48fb70d93a8939088d5a95c9e619b7e6847b196bdb349d864ac78997c9a` |
| `summary.json` | 357,939 | `0a318264436c6b6dd018fa31188315610d4bea8486bd0c61463d9e6a9fdcce6c` |
| `sha256-manifest.json` | 6,897 | `8ef26d59732db292ad307ae0bfc3b5db5d512a2291b771e208965afdbe449ead` |

## 6. Migration and inertness boundary

All official migration operation families were executed in both languages.
Input-derived, normatively determinate migration results agree; represented
loss remains a closed fixture account; live-warrant restoration is refused;
zero live warrants are created; and no legacy runtime code, current v1
registry, or procedure is loaded or invoked. Exact P024 revival, P029 source
rebinding, and the novel classification/content coupling matrix remain
authorially BLOCKED. See `LCI0-V1-MIGRATION-FIXTURE-RECEIPT.md`.

## 7. Nonregression

| Gate | Final result |
| --- | --- |
| Frozen CD/0 Phase 0 | PASS: 17 worked; 71 classified negatives; 39 Errata cases |
| Frozen CD/0 Common Lisp | PASS: 2,633 assertions; three declared N/A retained as N/A |
| Frozen CD/0 Python | PASS: 167/167 |
| Frozen CD/0 differential | PASS: 467 requests/codec; zero issues |
| Existing Mneme/v1 | PASS: 6/6 suites |
| Protected tracked-source diff | Empty for CD/0, `mneme/latent-mvp`, `mneme/verify-all.sh`, frozen specs, and fixtures |
| Live production systems introduced | Zero |

The protected `canonical-datum`, `mneme/latent-mvp`, and
`mneme/verify-all.sh` object IDs are unchanged from the shared seed base. The
three Common Lisp CD/0 N/A dispositions are not counted as pass.

## 8. Changed-file inventory

The Common Lisp successor changed these twelve seed-owned files:

```text
mneme/lci0/common-lisp/calculi.lisp
mneme/lci0/common-lisp/fixture-adapter.lisp
mneme/lci0/common-lisp/harness.lisp
mneme/lci0/common-lisp/matching.lisp
mneme/lci0/common-lisp/migration.lisp
mneme/lci0/common-lisp/operations.lisp
mneme/lci0/common-lisp/package.lisp
mneme/lci0/common-lisp/policy.lisp
mneme/lci0/common-lisp/registry.lisp
mneme/lci0/common-lisp/tests.lisp
mneme/lci0/common-lisp/validation.lisp
mneme/lci0/common-lisp/values.lisp
```

The Python successor changed or added these fourteen seed-owned files:

```text
mneme/lci0/python/evidence/LCI0-PYTHON-FAILURE-VOCABULARY-AUDIT.md
mneme/lci0/python/lci0/__init__.py
mneme/lci0/python/lci0/core.py
mneme/lci0/python/lci0/migration.py
mneme/lci0/python/lci0/model.py
mneme/lci0/python/lci0/protocol.py
mneme/lci0/python/lci0/runner.py
mneme/lci0/python/lci0/vector.py
mneme/lci0/python/tests/blocked_scope_authority_conflict.py
mneme/lci0/python/tests/test_audit_regressions.py
mneme/lci0/python/tests/test_failure_vocabulary.py
mneme/lci0/python/tests/test_perturbations.py
mneme/lci0/python/tests/test_successor_hostile.py
mneme/lci0/python/tests/test_vectors.py
```

Integration added the independent adapter/protocol validation,
post-convergence harness and host probes, `run-unit-tests.lisp`, archive
builder/tests, ten authorial packets, divergence/receipt documentation, and
the exact/post raw artifact directories. Documentation, archive, checksum, and
cleanup identities are recorded above. Publication/read-back remains the only
repository-lifecycle item pending in this transcript.

## 9. Ten authorial returns

| Packet | Blocked surface | Unaffected standing |
| --- | --- | --- |
| `LCI0-AUTHORIAL-RETURN-PACKET.md` | N012 universal/symbolic matcher composition | 211/215 vectors unaffected across all four vector blockers |
| `...-RELATION-FAILURE-PATHS.md` | 38 unpinned companion failure paths | all 458 relation values executed; 420 exact nonblocked |
| `...-E5-COVERAGE-CONTEXT.md` | expected-only `actual-coverage-scope` | typed/input-derived failure material remains testable |
| `...-P029-SOURCE-ARTIFACT.md` | expected `.../v1/2` replaces explicit input `.../v1/1` | other migration fixtures remain inert and executable |
| `...-POLICY-EVALUATION-ORDER.md` | combined stale/loss/trust order and decision Identifier | pinned single-branch policy behavior remains executable |
| `...-CORPUS-BASIS-COHERENCE.md` | exact mixed-revision rejection tuple | binary fail closure and valid bases remain executable |
| `...-OPERATION-PAYLOAD-FAILURES.md` | exact tuples for 104 missing/unknown payload mutations | typed binary rejection and all valid official payloads remain executable |
| `...-MIGRATION-CLASSIFICATION-COUPLING.md` | total seven-class result coupling | exact N028 and frozen valid documents remain executable |
| `...-TARGET-BOUNDARY-COHERENCE.md` | opaque step-6 kind-specific algorithms | official positives/first-missing negatives and pinned shape rules remain executable |
| `...-P024-REVIVAL.md` | expected occurrence fields absent from input | input-derived inert behavior remains executable |

The eight exact hostile result gaps and 14 post-convergence result-coordinate
cases are covered by these existing packets; no implementation or harness
defect was promoted into an eleventh authorial return.

## 10. Evidence archive, cleanup, publication, and audit

Required order is raw transcript commit → reproducible archive build and
commit → listing/hash verification → deletion of recoverable loose raw files
and generated detritus → non-force branch publication → remote read-back.

| Item | Status |
| --- | --- |
| Current exact/post loose raw transcripts | committed at `7ff074fdc234d826a113b0beb5e36b490d94b579` |
| Superseded r3/final5 raw transcripts | retained in history at `041d53740165a122e27b08bf2cb097f0bd391161` |
| Final nonregression loose raw transcripts | committed at `e552346123a35225023f5b33d8f288c7064e11da` |
| Reproducible evidence archive members/bytes/SHA-256 | 180 members; 9,573,988 bytes; `afad708a44b467c5945679001c0b49b5dbbfc6990e02a6c43d1fb4485b9a15fa` |
| Deterministic archive rebuild comparison | PASS: two byte-identical builds; 179 declared payloads, zero missing/mismatched/extra after extraction |
| Loose-file/detritus cleanup commit and deletion inventory | `e21ef1ae40335c7f8ac00de51edaf0c766f27feb`; 63 archive-covered files, 232,093,546 loose bytes; exact paths in commit name-status |
| Successor branch publication | PASS: atomic non-force creation of Common Lisp `2513c354...`, Python `db627cb6...`, and integration content `05d985bc...` |
| Remote read-back | PASS: `ls-remote` and fetched refs exact; remote integration archive blob SHA-256 `afad708a...`; remote main unchanged at `26ac543...` |
| Independent reviewer PASS | none |

Frozen specs/fixtures, immutable seeds, authored receipts, the standalone
preimplementation bundle, and user files are not cleanup detritus.

## 11. Current bounded disposition

```text
BLOCKED — authorial closure required for overall conformance. The corrected
unaffected implementation and r4/final6 evidence are ready for independent
implementation audit; reviewer PASS, merge eligibility, and production
authorization are not claimed.
```

Do not merge main. Do not begin production warrant, standing, cryptographic,
module-authority, custody/lineage, or live-v1-migration work.
