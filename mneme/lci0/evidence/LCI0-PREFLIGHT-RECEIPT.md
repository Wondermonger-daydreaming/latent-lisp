# LCI/0 Pre-Implementation Receipt

Date: 2026-07-14. Evidence standing: direct local observation unless marked as
historical packet evidence. No LCI implementation source existed when this
receipt's observations were made.

## Repository and host

- Repository: `/home/gauss/Codex-Lab/latent-lisp`
- Authoritative remote: `https://github.com/Wondermonger-daydreaming/latent-lisp.git`
- Development base: fetched `origin/main`
  `26ac543856e30c340cc2dd4359802442636f4b94`, tree
  `5d0fd36ad1a5b432181d491e748957355a436810`.
- Frozen CD/0 acceptance: `efe52efe3e0e5a24181ee324e18b23e266129104`,
  tree `13871b0b0ec81e667611163bc78976b3a91ff4b7`.
- Frozen evidence publication: `56f0ce55253ef8dd4caaf80b03e49835c4087406`,
  tree `e73d50772b22651df4f9620cd971baaf4de74739`.
- Diff inspection established that the fetched successors add evidence/review
  documents only; the `canonical-datum` and production `mneme/latent-mvp`
  subtrees are unchanged.
- Host: Ubuntu 24.04.3 LTS under WSL2; Linux
  `6.18.33.2-microsoft-standard-WSL2`, x86_64; locale `C.UTF-8`; timezone
  `America/Sao_Paulo`; git 2.43.0.
- Common Lisp: SBCL 2.4.6 at `/home/gauss/.local/bin/sbcl`.
- Python: CPython 3.11.14 (selected interpreter); system CPython 3.12.3 also
  present.

The configured fetch and push URL is
`https://github.com/Wondermonger-daydreaming/latent-lisp.git`. The complete
remote-reference set recorded immediately after fetch was:

```text
refs/remotes/origin-readback-final/cd0-integration-errata-0.1 369de53bff4ef5edbd31db3428456fde58d90cf5
refs/remotes/origin-readback/cd0-common-lisp-errata-0.1 ddadedf846afb6dff75fb8ffe449a8bbd03231df
refs/remotes/origin-readback/cd0-integration-errata-0.1 2722213ded71ff2c82494b65b654015a8c267128
refs/remotes/origin-readback/cd0-python-errata-0.1 5890235d9456031972b2ee7f40278d653dd1e6ae
refs/remotes/origin/HEAD 26ac543856e30c340cc2dd4359802442636f4b94
refs/remotes/origin/cd0-common-lisp 45eb60ce5b80485a0b287feab53ed3b58643b1b0
refs/remotes/origin/cd0-integration baeecd5e0347435b9e1362000344f46ea441c6ec
refs/remotes/origin/cd0-python 29d0946ad78347015b9f0c65a2f528f039fdca78
refs/remotes/origin/codex/cd0-common-lisp-errata-0.1 ddadedf846afb6dff75fb8ffe449a8bbd03231df
refs/remotes/origin/codex/cd0-integration-errata-0.1 369de53bff4ef5edbd31db3428456fde58d90cf5
refs/remotes/origin/codex/cd0-python-errata-0.1 5890235d9456031972b2ee7f40278d653dd1e6ae
refs/remotes/origin/codex/v1-counterexample-closure 1bc9e3ce08b14d0d1ad4a559cae13d77be3c3c48
refs/remotes/origin/main 26ac543856e30c340cc2dd4359802442636f4b94
refs/remotes/origin/rescue/cd0-disk-full-2026-07-13 e20762c8c441b9b6cac5044b05c7c8faad704637
```

## Backup and isolation setup

- Backup ref: `refs/backup/lci0-preimplementation-2026-07-14-26ac543` ->
  `26ac543856e30c340cc2dd4359802442636f4b94`.
- Standalone bundle:
  `/home/gauss/Codex-Lab/latent-lisp-lci0-preimplementation-2026-07-14.bundle`.
- Bundle bytes: 252,666,673.
- Bundle SHA-256:
  `b3bf606b892d8e47353248a69a3a534bff4cd4ad2708c587d7ebcbc57c54c936`.
- `git bundle verify` result: complete history, 49 refs, valid.
- Main was not modified. Shared infrastructure uses
  `codex/lci0-infrastructure`; language seed and integration worktrees are
  created only from its frozen shared-infrastructure commit.

## Normative and package identities

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
| Fixture ZIP | `36cc71ccf3c310a055199c54e84bf436c4505d92a6378f22e8b1d932f02e987d` |
| Fixture TAR.GZ twin | `ddc03ba184e835fdbd3c51e9a0f8d3edf4a93deb4d6b980544d82a5c47a83934` |
| Fable constitutional review | `65a989381fce365ba7057f07f6511e7a606ab4d2f2b4b052acda07dd11d1a50e` |
| Fable issue register | `a22e9f430c32f96472c4fcbe327309fb343a498094e47f486c00359a92221806` |
| Fable readiness relay | `9502d24b03675db1d8b5fd7788ebfb50ea31ab9e452d8a440f3e935fd5b9ef03` |
| Fable PASS receipt | `96859328cee6caa3afcd44c00b8bf84cb20ccc55a7139271b7862a34f8a587a2` |
| Fable PASS packet | `89cd11ac52478a9e3ff9ebdefcc60b2fff8fa2c8707e159b4f4bd0b6e2cefdfd` |
| Frozen CD/0 packet ZIP | `bc54a23bbd235fc0ee4d0485c2091585e506dbc7cf74b0e16318580465aa1f81` |
| Frozen CD/0 specification | `d578e86e4d411611b091cca0bed1cafac2636c0908e95447fd4a13badcab6abc` |
| Frozen CD/0 Errata 0.1 | `5f1568e53c4e6ef5fc8de2e125e7a6ef2d861392048c7ead144c7df05eb16271` |
| Frozen CD/0 ruling | `1a0e8ff844790c93e681f7541a23266aa73d2ee8e9ca9a6e0d753bf4e044b2bc` |

All six identities supplied in the implementation authorization match. The
fixture ZIP and TAR.GZ contain the same 22 file members byte-for-byte. The
fixture checksum file verifies 21/21 entries. The PASS packet has 42 file
members: 41 non-manifest members verify against its manifest, plus the manifest
itself. The frozen CD/0 checksum file verifies 14/14 entries.

The PASS receipt says “20/20” for the package checksum command while the sealed
checksum file and BOOKKEEPER evidence correctly contain 21 entries (20 payload
rows plus the package manifest). This is recorded as a non-semantic bookkeeping
typo; no identity differs.

The exact executable CD/0 source, adapter, schema, and vector hashes are
recorded separately in `LCI0-CD0-FROZEN-INVENTORY.md`; all twenty files in that
inventory were read in full before either language seed began.

## Frozen baseline execution

Commands were run from the clean accepted CD/0 main worktree before any LCI
tracked change:

```text
python3 canonical-datum/tools/verify_phase0.py
sbcl --noinform --disable-debugger --script canonical-datum/common-lisp/run-tests.lisp
env PYTHONPATH=canonical-datum/python python3 -m unittest discover -s canonical-datum/python/tests -v
python3 canonical-datum/integration/run_differential.py --json
bash mneme/verify-all.sh
```

Observed results:

- Phase 0: PASS; 17/17 worked vectors; 71 classified negatives; 39 Errata
  vectors; all frozen vector/schema hashes reproduced.
- Common Lisp: PASS; 2,633 assertions; 25/25 positive rows; 68 executed
  negative rows and exactly three declared N/A optional host importers; zero
  failures/skips.
- Python: PASS; 167/167 tests.
- Differential: PASS; 467 requests per codec; zero issues; three declared
  Common Lisp N/A dispositions were not counted as passes.
- Existing Mneme/v1: all 6/6 suites green.

## Package census and disclosed divergence

Machine parsing reproduced 675 unique registry definitions and 215 unique
vectors, with all P001–P030 and N001–N032 present. The official scope is 1,105
canonical documents. A magic-prefix recursive sweep independently retains the
supplementary 458 relation-table plus 30 nested E1 documents, for 488
supplementary and 1,593 total.

The temporal prose/machine mismatch disclosed by Fable is preserved as
`LCI0-DIV-001`. It is not silently normalized. The Fable PASS receipt explicitly
dispositions the precise registry/vector relations as executable and the two
prose labels as coarser illustrative wording; the permanent witness remains in
the divergence ledger.
