# LCI/0 Successor Differential Receipt

Date: 2026-07-14

Status: unaffected paths converged; overall conformance BLOCKED pending
authorial closure

## Evidence boundary

This receipt binds the final exact successor run and the post-convergence run.
It does not convert an authorial blocker into a pass, failure, skip, or N/A,
and neither implementation is treated as an oracle.

The correct independence statement remains: independently seeded
implementations under shared normative infrastructure, with procedural—not
OS-enforced—isolation.

## Bound implementations and run identity

| Artifact | Commit | Tree |
| --- | --- | --- |
| Common Lisp immutable seed | `b3d28bc49c3b015096cb04c6ad08c19829f511a9` | `d48c39f933cde591f3303fcd3c9f42a0dac1a869` |
| Common Lisp successor | `2513c354721bac6120b8c0a5eef1ed13252cf75b` | `9ce6786ee374f3dafe859c6ea5977b27e6c6f718` |
| Python immutable seed | `4ec2e519d05aeacd2412cb8aedc5f76bde702571` | `9f7915b460f449976a5d7fa856861ad5ce1d36ca` |
| Audited Python successor | `db627cb6ca23abc0626aebc6f9982ab9b4406dbf` | `74c6a7e5c144d3286b83a933b27cff3d5865921d` |
| Integration tree executed | `e6983952ea726366b69435b29eeb37eb76f8504d` | `daaef9bad97eced6c242fc8052cbedc8920d355a` |
| Refreshed raw-transcript commit | `7ff074fdc234d826a113b0beb5e36b490d94b579` | `3b6834114f8c1df4f8810b4a56f66f0bf66de8e2` |

- Protocol: `lisp-plus-lci0-differential/v1`.
- Fixture profile: `0.1.0`.
- Runtime: SBCL 2.4.6; Python 3.11.14; Linux x86-64 under WSL2.
- Exact run source: `/tmp/lci0-exact-final-head-r4-20260714`.
- Post-convergence source:
  `/tmp/lci0-post-convergence-final6-20260714`.

## Mechanical exact-request census

Per implementation:

| Class | Requests |
| --- | ---: |
| Official embedded document roundtrips | 1,105 |
| Supplementary relation-table document roundtrips | 458 |
| Supplementary nested E1 roundtrips | 30 |
| Shared vector semantic executions | 215 |
| Full relation-table semantic executions | 458 |
| Exact baseline subtotal | 2,266 |
| Deterministic hostile witnesses | 29 |
| Total | 2,295 |

The adapters returned 4,590 responses. Both adapter processes exited zero and
both stderr streams were empty. The coordinator mechanically confirmed 215
unique vector IDs, all required P001–P030 and N001–N032 IDs, and 52 operation
families.

## Exact results

| Surface | Common Lisp | Python | Cross-language disposition |
| --- | ---: | ---: | --- |
| Recursive canonical documents | 1,593 pass | 1,593 pass | Identical unaffected result |
| Official vector results | 211 pass, 4 blocked | 211 pass, 4 blocked | Zero unaffected mismatch |
| Relation semantics | 420 pass, 38 path-blocked | 420 pass, 38 path-blocked | Same relation values; paths blocked |
| Hostile expectations | 21 pass, 8 blocked | 21 pass, 8 blocked | Zero unaffected mismatch |

The 41 recorded cross-implementation differences are wholly inside declared
authorial boundaries: 38 relation companion paths and three of the eight
hostile result gaps. There are zero Common Lisp and zero Python mismatches on
unaffected exact paths.

The four blocked exact vector documents are:

- `LCI0-N012` — universal/symbolic composition conflict;
- `LCI0-E5-COVERAGE-INSUFFICIENT` — expected-only coverage context;
- `LCI0-P024` — unbound beta occurrence in revival; and
- `LCI0-P029` — expected migration source differs from the bound input source.

The unaffected official-vector ceiling is therefore 211/215. The 38 relation
paths and eight hostile requests are separately reported and are not silently
deducted from another denominator.

Eight new determinate hostile witnesses from the independent implementation
audit passed in both languages: closed direct projection, exact empty
profile-location, two proposition matching/order cases, nonmonotonicity before
coverage, validated ClaimId equality, and the `production` and
`model-current` StableRef aliases. They increase only the hostile denominator;
they create no authorial blocker or return packet.

## Post-convergence differential

The post-convergence harness ran after unaffected exact convergence:

| Measure | Result |
| --- | ---: |
| Deterministic seed | `1279478064` (`0x4C434930`) |
| Generated logical cases | 329 |
| Adapter profiles | 6 |
| Adapter requests | 1,974 |
| Generated failure-coordinate cases with authorial gaps | 104 |
| Generated result-coordinate cases with authorial gaps | 14 |
| Nonblocked comparison failures | 0 |
| Direct commands | 20, all exit zero |
| Separate processes, including four nested Python runners | 24 |

All six profiles agreed after redacting only the exact named blocked
coordinates. The 104 payload-closure cases still assert their pinned
fail-closed code/predicate; category, stage, path, and context remain blocked.
The 14 result cases retain every nonblocked coordinate: one policy reason-list
coordinate and the `resource`/`requested` fields of thirteen at-limit resource
cases remain unpinned. These are blocked observations, not passes.

## Raw evidence

Exact directory:
`mneme/lci0/differential/artifacts/successor-final-2026-07-14/`

| Member | Bytes | SHA-256 |
| --- | ---: | --- |
| `requests.jsonl` | 24,458,265 | `b6b17160d2fec5177d0faad0542d9b35c2047d521925ed302bc54e5d206d3e9c` |
| `common-lisp-responses.jsonl` | 25,763,401 | `46695fbdcc3d7b449297c7d591473fb842ea1db93a151bb8e65e9c9492a693a7` |
| `common-lisp-stderr.txt` | 0 | `e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855` |
| `python-responses.jsonl` | 25,753,084 | `5b185919ab0599d43e845f9624faa17940c03bc6efb3c4988a4604505cff3542` |
| `python-stderr.txt` | 0 | `e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855` |
| `summary.json` | 1,541,123 | `7f63cd0cb59c12d0d909f19e4fdc3d5625912c1ced7562c9aef7813ccfe25d7e` |
| `sha256-manifest.json` | 804 | `d81d084cac92b10bdc8bbde66f3f5a6e89dcf55f4b6b718762653ae4d1c6b994` |

Post-convergence directory:
`mneme/lci0/differential/artifacts/post-convergence-final-2026-07-14/`

| Member | Bytes | SHA-256 |
| --- | ---: | --- |
| `requests.jsonl` | 8,818,612 | `41f979e6b946b22fda82c5fd3dae3ee17137ce21ecea86fc044d3213783fde89` |
| `cases.json` | 243,600 | `5a573656458f41a8418e9d2fc8a8f5d97aea5cd3c373dd30cc5999b1f281f6d1` |
| `command-transcript.jsonl` | 27,472 | `2cadd48fb70d93a8939088d5a95c9e619b7e6847b196bdb349d864ac78997c9a` |
| `summary.json` | 357,939 | `0a318264436c6b6dd018fa31188315610d4bea8486bd0c61463d9e6a9fdcce6c` |
| `sha256-manifest.json` | 6,897 | `8ef26d59732db292ad307ae0bfc3b5db5d512a2291b771e208965afdbe449ead` |

Raw files were committed before the evidence-archive and later loose-file
cleanup sequence. Commit history remains the recovery boundary if the final
tip removes loose bulk transcripts after archive verification.

## Commands

From the integration worktree root:

```text
PYTHONDONTWRITEBYTECODE=1 PYTHONPATH=mneme/lci0/differential:mneme/lci0/python:canonical-datum/python python3 mneme/lci0/differential/run_differential.py --output /tmp/lci0-exact-final-head-r4-20260714
```

```text
PYTHONDONTWRITEBYTECODE=1 PYTHONPATH=mneme/lci0/differential:mneme/lci0/python:canonical-datum/python python3 mneme/lci0/differential/post_convergence.py --successor-artifacts /tmp/lci0-exact-final-head-r4-20260714 --output /tmp/lci0-post-convergence-final6-20260714 --seed 1279478064 --allocation-cases 64
```

The exact adapter monotonic durations were 20,627,528,338 ns for Common Lisp
and 11,232,851,902 ns for Python. The post-convergence command transcript
records the 20 subprocess invocations and their exit statuses but no elapsed
duration field, so no post-convergence duration is inferred.

## Disposition

The unaffected dual implementation and post-convergence evidence are ready for
independent inspection. Overall LCI/0 conformance remains BLOCKED pending
authorial closure of the ten existing narrow return packets. This receipt does
not claim PASS, merge eligibility, or authority for any production warrant,
standing, cryptographic, module-authority, or live-v1-migration system.
