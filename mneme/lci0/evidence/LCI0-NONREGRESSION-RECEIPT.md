# LCI/0 Nonregression Receipt

Date: 2026-07-14

Status: final successor nonregression PENDING

## Protected invariants

The LCI/0 work must leave all of the following unchanged:

- frozen CD/0 specification, errata, ruling, source, schemas, vectors, codecs,
  canonical octets, and behavior;
- existing Mneme/v1 tests and production behavior;
- `mneme/latent-mvp` and `mneme/verify-all.sh` protected source;
- the absence of live warrant, standing, capability, authority,
  cryptographic-selection, production identity, custody, verified-lineage, and
  live-migration systems.

## Bound baseline identities

| Object | Pre-implementation identity |
| --- | --- |
| Fetched `origin/main` commit | `26ac543856e30c340cc2dd4359802442636f4b94` |
| Fetched `origin/main` tree | `5d0fd36ad1a5b432181d491e748957355a436810` |
| Frozen CD/0 acceptance commit | `efe52efe3e0e5a24181ee324e18b23e266129104` |
| Frozen CD/0 acceptance tree | `13871b0b0ec81e667611163bc78976b3a91ff4b7` |
| Frozen `canonical-datum` tree at seed base | `ce6e41deca3fe237ff6d0edafa2666d098ae62e8` |
| Frozen `mneme/latent-mvp` tree at seed base | `41c2934e34a04461cf50cb378394c32c7c11d344` |
| Frozen CD/0 packet ZIP SHA-256 | `bc54a23bbd235fc0ee4d0485c2091585e506dbc7cf74b0e16318580465aa1f81` |
| Frozen CD/0 specification SHA-256 | `d578e86e4d411611b091cca0bed1cafac2636c0908e95447fd4a13badcab6abc` |
| Frozen CD/0 Errata 0.1 SHA-256 | `5f1568e53c4e6ef5fc8de2e125e7a6ef2d861392048c7ead144c7df05eb16271` |
| Frozen CD/0 ruling SHA-256 | `1a0e8ff844790c93e681f7541a23266aa73d2ee8e9ca9a6e0d753bf4e044b2bc` |

The exact 20-file protected CD/0 hash inventory is retained in
`LCI0-CD0-FROZEN-INVENTORY.md` and must be rechecked from the final successor
tree.

## Historical preflight floor

Before tracked LCI implementation changes, the following commands were observed
green from the accepted CD/0 main worktree:

| Gate | Historical result | Final successor result |
| --- | --- | --- |
| `python3 canonical-datum/tools/verify_phase0.py` | PASS; 17 worked vectors, 71 classified negatives, 39 Errata vectors | PENDING |
| `sbcl --noinform --disable-debugger --script canonical-datum/common-lisp/run-tests.lisp` | PASS; 2,633 assertions; three declared N/A dispositions not counted as pass | PENDING |
| `env PYTHONPATH=canonical-datum/python python3 -m unittest discover -s canonical-datum/python/tests -v` | PASS; 167/167 | PENDING |
| `python3 canonical-datum/integration/run_differential.py --json` | PASS; 467 requests per codec; zero issues | PENDING |
| `bash mneme/verify-all.sh` | PASS; 6/6 existing Mneme/v1 suites | PENDING |

These results are a baseline, not a substitute for rerunning against the final
integration-successor commit.

## Required final commands

| ID | Exact command | Runtime | Exit/result | Raw evidence | Status |
| --- | --- | --- | --- | --- | --- |
| NR-01 | `python3 canonical-datum/tools/verify_phase0.py` | PENDING | PENDING | PENDING | PENDING |
| NR-02 | `sbcl --noinform --disable-debugger --script canonical-datum/common-lisp/run-tests.lisp` | PENDING | PENDING | PENDING | PENDING |
| NR-03 | `env PYTHONPATH=canonical-datum/python python3 -m unittest discover -s canonical-datum/python/tests -v` | PENDING | PENDING | PENDING | PENDING |
| NR-04 | `python3 canonical-datum/integration/run_differential.py --json` | PENDING | PENDING | PENDING | PENDING |
| NR-05 | `bash mneme/verify-all.sh` | PENDING | PENDING | PENDING | PENDING |
| NR-06 | Recompute `LCI0-CD0-FROZEN-INVENTORY.md` hashes | PENDING | PENDING | PENDING | PENDING |
| NR-07 | Compare protected subtree object IDs/diffs to seed base | Git PENDING | PENDING | PENDING | PENDING |
| NR-08 | Inspect introduced public symbols/types for live warrant/authority systems | PENDING | PENDING | PENDING | PENDING |

## Protected-tree comparison

| Protected path/object | Expected identity or diff | Observed final identity/diff | Result |
| --- | --- | --- | --- |
| `canonical-datum/` | No tracked source/schema/vector change | PENDING | PENDING |
| `mneme/latent-mvp/` | No tracked production change | PENDING | PENDING |
| `mneme/verify-all.sh` | No tracked change | PENDING | PENDING |
| `mneme/lci0/spec/` | Exact frozen normative copies, unedited | PENDING | PENDING |
| `mneme/lci0/fixtures/` | Exact frozen archives/manifests, unedited | PENDING | PENDING |
| CD/0 canonical outputs | Byte-identical on all frozen vectors | PENDING | PENDING |
| Existing v1 behavior | 6/6 suites green, no production semantic change | PENDING | PENDING |
| Live warrant/authority object inventory | Zero | PENDING | PENDING |

## N/A and failure accounting

The Common Lisp CD/0 suite historically reports three declared optional-host
importer dispositions as N/A. They must remain reported as N/A and must never be
added to a pass count. Any unavailable final command, skipped test, new N/A,
changed count, protected-tree diff, or canonical-byte difference must be listed
as a distinct unresolved item.

| Classification | Count/detail |
| --- | --- |
| Final failures | PENDING |
| Final skips | PENDING |
| Declared historical Common Lisp N/A | PENDING confirmation; expected 3 and not pass |
| New N/A | PENDING; expected 0 |
| Protected-tree differences | PENDING; expected empty |
| Canonical-octet differences | PENDING; expected 0 |

## Authorial returns and nonregression

The N012 matcher, relation-failure-path, and E5 coverage-context authorial
packets block exact LCI integration conclusions. They do not waive any CD/0 or
v1 nonregression gate. Nonregression must be run and reported independently of
their disposition.

| Packet | Authorial response/hash | Effect on final nonregression result |
| --- | --- | --- |
| `LCI0-AUTHORIAL-RETURN-PACKET.md` | PENDING | Matcher path BLOCKED; CD/0 and v1 gates remain PENDING and mandatory |
| `LCI0-AUTHORIAL-RETURN-PACKET-RELATION-FAILURE-PATHS.md` | PENDING | Thirty-eight paths BLOCKED; CD/0 and v1 gates remain PENDING and mandatory |
| `LCI0-AUTHORIAL-RETURN-PACKET-E5-COVERAGE-CONTEXT.md` | PENDING | Expected context BLOCKED; CD/0 and v1 gates remain PENDING and mandatory |

## Archive, cleanup, and publication fill-in

| Item | Status/value |
| --- | --- |
| Final successor commit/tree tested | PENDING |
| Raw nonregression transcripts committed | PENDING |
| Transcript member bytes/SHA-256 | PENDING |
| Reproducible evidence archive membership | PENDING |
| Archive bytes/SHA-256 | PENDING |
| Loose transcripts removed only after archive commit | PENDING |
| Safe detritus cleanup inventory and commit | PENDING |
| Non-force branch publication | PENDING |
| Remote read-back of tested objects | PENDING |

## Current disposition

Final CD/0 and v1 nonregression are PENDING. This receipt does not claim final
nonregression, convergence, PASS, archive completion, cleanup completion,
publication, or eligibility for independent implementation audit.
