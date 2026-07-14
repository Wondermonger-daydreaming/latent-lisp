# LCI/0 Nonregression Receipt

Date: 2026-07-14

Status: **PASS within the protected CD/0 and Mneme/v1 nonregression scope.**
This is not an LCI/0 conformance PASS: the overall implementation remains
BLOCKED on ten narrow authorial-return packets.

Audit history: an independent review after exact r3/post final5 found six
Python boundary defect families. They were corrected in successor
`db627cb6ca23abc0626aebc6f9982ab9b4406dbf`, integrated with new hostile
regressions, and followed by exact r4/post final6 at `e6983952...`. The
protected CD/0/v1 results remain separately bound to this receipt and stayed
green; the superseded r3/final5 snapshot is not used as current evidence.

## Protected invariants

The LCI/0 work was required to leave unchanged:

- frozen CD/0 specification, errata, ruling, source, schemas, vectors, codecs,
  canonical octets, and behavior;
- existing Mneme/v1 tests and production behavior;
- `mneme/latent-mvp` and `mneme/verify-all.sh` protected source; and
- the absence of production warrant, standing, capability, authority,
  cryptographic-selection, custody, verified-lineage, and live-migration
  systems.

## Bound identities

| Object | Identity |
| --- | --- |
| Fetched `origin/main` commit/tree | `26ac543856e30c340cc2dd4359802442636f4b94` / `5d0fd36ad1a5b432181d491e748957355a436810` |
| Frozen CD/0 acceptance commit/tree | `efe52efe3e0e5a24181ee324e18b23e266129104` / `13871b0b0ec81e667611163bc78976b3a91ff4b7` |
| Frozen `canonical-datum` tree | `ce6e41deca3fe237ff6d0edafa2666d098ae62e8` |
| Frozen `mneme/latent-mvp` tree | `41c2934e34a04461cf50cb378394c32c7c11d344` |
| Frozen `mneme/verify-all.sh` blob | `b001ec4fde1e5e42c334589dc3fc0f34a0038a9b` |
| Integration code verified by the final exact/post runs | commit `e6983952ea726366b69435b29eeb37eb76f8504d`; tree `daaef9bad97eced6c242fc8052cbedc8920d355a` |
| Current raw exact/post transcript commit | `7ff074fdc234d826a113b0beb5e36b490d94b579`; tree `3b6834114f8c1df4f8810b4a56f66f0bf66de8e2` |
| Superseded raw exact/post transcript commit | `041d53740165a122e27b08bf2cb097f0bd391161`; tree `ba00e2837cad7f107d846377bfbe33601802665f` |
| Raw nonregression transcript commit | `e552346123a35225023f5b33d8f288c7064e11da`; tree `62c405b0358a949c5590dbcc55b50c52a515ec8c` |
| Frozen CD/0 packet ZIP SHA-256 | `bc54a23bbd235fc0ee4d0485c2091585e506dbc7cf74b0e16318580465aa1f81` |
| Frozen CD/0 specification SHA-256 | `d578e86e4d411611b091cca0bed1cafac2636c0908e95447fd4a13badcab6abc` |
| Frozen CD/0 Errata 0.1 SHA-256 | `5f1568e53c4e6ef5fc8de2e125e7a6ef2d861392048c7ead144c7df05eb16271` |
| Frozen CD/0 ruling SHA-256 | `1a0e8ff844790c93e681f7541a23266aa73d2ee8e9ca9a6e0d753bf4e044b2bc` |

The complete protected 20-file checksum inventory remains in
`LCI0-CD0-FROZEN-INVENTORY.md`.

## Final execution

All commands were run from the integration-successor worktree with CPython
3.11.14 and SBCL 2.4.6. Each command exited zero.

| ID | Command | Observed result | Raw transcript |
| --- | --- | --- | --- |
| NR-01 | `python3 canonical-datum/tools/verify_phase0.py` | PASS: 17/17 worked vectors; 71 classified negatives; 39 Errata cases; zero failures/skips | `mneme/lci0/evidence/raw/nonregression-final-2026-07-14/phase0.*` |
| NR-02 | `sbcl --noinform --disable-debugger --script canonical-datum/common-lisp/run-tests.lisp` | PASS: 2,633 assertions; 68/68 applicable classified rows; 3 declared N/A | `mneme/lci0/evidence/raw/nonregression-final-2026-07-14/common-lisp-cd0.*` |
| NR-03 | `env PYTHONPATH=canonical-datum/python python3 -m unittest discover -s canonical-datum/python/tests -v` | PASS: 167/167 | `mneme/lci0/evidence/raw/nonregression-final-2026-07-14/python-cd0.*` |
| NR-04 | `python3 canonical-datum/integration/run_differential.py --json` | PASS: 467 requests per codec; zero issues; both processes exit zero | `mneme/lci0/evidence/raw/nonregression-final-2026-07-14/cd0-differential.*` |
| NR-05 | `bash mneme/verify-all.sh` | PASS: 6/6 existing Mneme/v1 suites | `mneme/lci0/evidence/raw/nonregression-final-2026-07-14/mneme-v1.*` |

The Common Lisp suite's three optional-host importer dispositions remain N/A.
They are not passes. There were no new N/A, skips, failures, CD/0 differential
issues, or v1 floor failures.

## Protected-tree comparison

The captured command `git diff --name-status
26ac543856e30c340cc2dd4359802442636f4b94..7ff074fdc234d826a113b0beb5e36b490d94b579
-- canonical-datum mneme/latent-mvp mneme/verify-all.sh` produced no entries.
A separate receipt recheck—not an additional raw transcript member—compared
`mneme/lci0/spec` and `mneme/lci0/fixtures` between shared base
`ab353b4b7f30d5e46323d274862e6c1212ebf514` and executed integration commit
`e6983952ea726366b69435b29eeb37eb76f8504d`; it also produced no entries.

| Protected object | Seed-base object | Verified object | Result |
| --- | --- | --- | --- |
| `canonical-datum/` | `ce6e41deca3fe237ff6d0edafa2666d098ae62e8` | same | PASS |
| `mneme/latent-mvp/` | `41c2934e34a04461cf50cb378394c32c7c11d344` | same | PASS |
| `mneme/verify-all.sh` | `b001ec4fde1e5e42c334589dc3fc0f34a0038a9b` | same | PASS |
| Frozen LCI specs/fixtures | no tracked content change | no diff | PASS |
| CD/0 canonical behavior | 467-request differential floor | zero issues | PASS |
| Existing v1 behavior | 6 suites | 6/6 green | PASS |

The added code remains under `mneme/lci0/` and is fixture-only. Review found no
production warrant, WarrantId, standing, capability, authority,
cryptographic-selection, custody, verified-lineage, or live-migration object.
No live warrant was created by migration fixtures.

## Artifact-identity recheck

The final worktree reproduced the required LCI candidate, ruling, Errata,
fixture-package specification, fixture manifest/checksum file, fixture ZIP,
and Fable PASS packet hashes. In particular, the candidate, ruling, Errata,
fixture-package specification, registry, and vectors remained respectively:

```text
6fa2965ed727b4d89b09a3d9c171bcfa3aea8c23f486ef87dc33f85bcb9ae5ba
c2ee9dbb2b3fc72abf4745f5e9a8b4a04d9e1bfeab0fbe224d5c7946e11360a7
f2bcea1db0e08fe271fdaa79c1f9d4406b94c2c730ab547c0024495ce962c5ea
ac0c9265e9583c698c397801099efa548cdbf33f686ebff5bacc8bbea7cbcd2f
dd19c6d6543a875b2e7e1e6a234ad731ce019f64495b447b317462c63f826327
387e76963f3087f6e41ec4363ec3eea29b1456c2a6b3c5a0cf5763418bffe3a4
```

## Evidence lifecycle still pending

The final nonregression raw files are committed at
`e552346123a35225023f5b33d8f288c7064e11da`. Reproducible archive
bytes/SHA-256, cleanup commit, branch publication, and remote read-back are
intentionally left for the later archive/publication receipts. No archive or
remote identity is guessed here.

## Disposition

The protected CD/0 and Mneme/v1 nonregression obligation is satisfied by
independent frozen-suite, differential, protected-object, and source-diff
evidence. This does not cure the ten LCI/0 authorial blockers. The corrected
unaffected LCI implementation/evidence is ready for independent audit, while
overall completion remains **BLOCKED pending authorial closure**.
