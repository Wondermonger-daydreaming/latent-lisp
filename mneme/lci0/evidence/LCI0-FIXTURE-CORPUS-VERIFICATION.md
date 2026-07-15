# LCI/0 Fixture Corpus Verification

Date: 2026-07-14

Status: canonical corpus verification converged in both successors; overall
LCI/0 conformance remains BLOCKED pending authorial closure

## Frozen package identity

| Artifact | Verified SHA-256 |
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

## Bound execution

- Integration commit/tree executed:
  `e6983952ea726366b69435b29eeb37eb76f8504d` /
  `daaef9bad97eced6c242fc8052cbedc8920d355a`.
- Common Lisp successor: commit
  `2513c354721bac6120b8c0a5eef1ed13252cf75b`, tree
  `9ce6786ee374f3dafe859c6ea5977b27e6c6f718`.
- Python successor: commit
  `db627cb6ca23abc0626aebc6f9982ab9b4406dbf`, tree
  `74c6a7e5c144d3286b83a933b27cff3d5865921d`.
- Runtime: SBCL 2.4.6; Python 3.11.14; Linux x86-64 under WSL2.
- Exact summary: 1,541,123 bytes, SHA-256
  `7f63cd0cb59c12d0d909f19e4fdc3d5625912c1ced7562c9aef7813ccfe25d7e`.

## Required census and results

| Corpus class | Required count | Common Lisp | Python |
| --- | ---: | ---: | ---: |
| Registry definition documents | 675 | 675 pass | 675 pass |
| Vector input documents | 215 | 215 pass | 215 pass |
| Vector expected-result documents | 215 | 215 pass | 215 pass |
| Official embedded documents | 1,105 | 1,105 pass | 1,105 pass |
| Supplementary relation-table documents | 458 | 458 pass | 458 pass |
| Supplementary nested E1 documents | 30 | 30 pass | 30 pass |
| Supplementary subtotal | 488 | 488 pass | 488 pass |
| Complete recursive package sweep | 1,593 | 1,593 pass | 1,593 pass |

The official figure remains 1,105. The supplementary figure remains 488. The
1,593 result is a complete recursive sweep and does not replace the official
count.

## Verification obligations

Each language independently consumed the package and performed the following
checks. The coordinator compared the response envelopes without supplying
expected results to either adapter.

| Check | Common Lisp | Python | Coordinator |
| --- | --- | --- | --- |
| Discover embedded canonical documents recursively | PASS | PASS | Counts 1,593 unique request identities |
| Classify official, relation-table, and nested E1 documents | PASS | PASS | 1,105 + 458 + 30 |
| Validate supplied byte counts and SHA-256 where present | PASS | PASS | Zero document mismatch |
| Decode with the frozen CD/0 codec | PASS | PASS | Zero protocol refusal |
| Compare decoded abstract datum with package expectation | PASS | PASS | Zero document mismatch |
| Re-encode byte-identically | PASS | PASS | 1,593/1,593 each |
| Find magic-prefixed documents beyond a shallow key-name census | PASS | PASS | 1,133 registry + 460 vector magic values = 1,593 |
| Preserve independently allocated equal canonical values | PASS | PASS | Post-convergence allocation groups converged |
| Fail closed rather than accept an unknown adapter surface | PASS | PASS | Adapter schema-census and hostile tests green |

The magic-prefix count is a completeness witness, not another corpus total:
1,133 registry values plus 460 vector values are the same 1,593 recursive
documents classified above.

## Semantic blockers do not invalidate corpus reproduction

The ten authorial-return packets concern derivation or exact failure/result
coordinates. They do not alter the frozen bytes. In particular:

- N012, E5 coverage, P024, and P029 input and expected documents all decode and
  reproduce byte-identically even though their exact semantic result paths are
  blocked;
- all 458 relation documents reproduce while 38 companion failure paths remain
  unpinned; and
- all hostile carrier documents used by the post-convergence phase reproduce
  while explicitly named novel coordinates remain blocked.

No nearby, regenerated, or implementation-local fixture revision was used.

## Raw evidence

The raw exact transcript was committed in
`7ff074fdc234d826a113b0beb5e36b490d94b579` under
`mneme/lci0/differential/artifacts/successor-final-2026-07-14/`.

| Member | Bytes | SHA-256 |
| --- | ---: | --- |
| `requests.jsonl` | 24,458,265 | `b6b17160d2fec5177d0faad0542d9b35c2047d521925ed302bc54e5d206d3e9c` |
| `common-lisp-responses.jsonl` | 25,763,401 | `46695fbdcc3d7b449297c7d591473fb842ea1db93a151bb8e65e9c9492a693a7` |
| `python-responses.jsonl` | 25,753,084 | `5b185919ab0599d43e845f9624faa17940c03bc6efb3c4988a4604505cff3542` |
| `summary.json` | 1,541,123 | `7f63cd0cb59c12d0d909f19e4fdc3d5625912c1ced7562c9aef7813ccfe25d7e` |
| `sha256-manifest.json` | 804 | `d81d084cac92b10bdc8bbde66f3f5a6e89dcf55f4b6b718762653ae4d1c6b994` |

Both adapter stderr members are empty and have the standard empty-file
SHA-256 `e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855`.

Raw bulk members may be removed from the final branch tip only after a verified
evidence archive contains them; their raw-evidence commit remains immutable in
history. Archive construction, loose-file cleanup, publication, and remote
read-back are documented separately and are not inferred here.

## Reproduction command

```text
PYTHONDONTWRITEBYTECODE=1 PYTHONPATH=mneme/lci0/differential:mneme/lci0/python:canonical-datum/python python3 mneme/lci0/differential/run_differential.py --output /tmp/lci0-exact-final-head-r4-20260714
```

## Disposition

The frozen fixture corpus is reproduced in full by both successor
implementations: 1,105 official documents and 488 supplementary documents,
reported separately, with a 1,593-document recursive sweep. This corpus
obligation is satisfied. Overall semantic conformance remains BLOCKED pending
authorial closure; no global PASS or merge eligibility is asserted.
