# LCI/0 Evidence Archive Receipt

Date: 2026-07-14

Status: **archive reproduced and verified; unaffected implementation evidence
ready for independent audit; overall LCI/0 conformance remains BLOCKED pending
authorial closure.**

## Archive identity

| Field | Value |
| --- | --- |
| Archive | `mneme/lci0/evidence/LCI0-IMPLEMENTATION-EVIDENCE-2026-07-14.tar.gz` |
| Bytes | 9,573,988 |
| SHA-256 | `afad708a44b467c5945679001c0b49b5dbbfc6990e02a6c43d1fb4485b9a15fa` |
| Source commit before archive commit | `a8bfdbdc3f10e8c57b1b4a9c14edbea00b9ba270` |
| Source tree | `6cefd2f09f30a65ce9d5e81eef756de6aaa0624b` |
| Members excluding internal manifest | 179 |
| Members including internal manifest | 180 |
| Member payload bytes excluding internal manifest | 242,587,820 |
| Internal manifest bytes | 33,320 |
| Internal manifest SHA-256 | `0296f3fd22387ca40e61285d7bb019d69b87e300f5f5338a44d10d9f7f3b4bd6` |
| Archive schema | `lisp-plus-lci0-evidence-archive/v1` |

The archive contains the complete tracked `mneme/lci0` tree at the source
commit. That selection includes frozen normative and fixture inputs, both
language implementations and tests, differential harnesses, receipts, the
baseline/current exact and post-convergence transcripts, and the final
nonregression transcripts.

## Reproducibility and verification

The production builder required a clean Git worktree, rejected hidden index
state, bound every selected payload and executable bit to the declared commit,
refused symlinks and generated detritus, and normalized tar/gzip metadata.

The archive was built twice from the same clean source commit with:

```text
env PYTHONDONTWRITEBYTECODE=1 python3 mneme/lci0/shared/build_evidence_archive.py --root . --output mneme/lci0/evidence/LCI0-IMPLEMENTATION-EVIDENCE-2026-07-14.tar.gz --include mneme/lci0 --evidence-date 2026-07-14 --repository-head a8bfdbdc3f10e8c57b1b4a9c14edbea00b9ba270 --status 'unaffected implementation evidence ready for independent audit; overall LCI/0 conformance blocked pending authorial closure' --require-clean-git-tree
```

Both builds were 9,573,988 bytes and had the same SHA-256
`afad708a44b467c5945679001c0b49b5dbbfc6990e02a6c43d1fb4485b9a15fa`;
`cmp` reported byte identity. The 180-entry tar listing was inspected. A full
extraction into a fresh temporary directory was compared to the internal
manifest: 179 declared payloads, zero missing or size/hash-mismatched payloads,
and zero extra files.

The archive includes 72 files below the three differential artifact
directories and final nonregression raw directory, totaling 235,333,168
uncompressed bytes. Their pre-cleanup recovery boundaries are also preserved
in Git history, including current exact/post raw commit `7ff074fd...` and
refreshed nonregression raw commit `e5523461...`.

## Provenance and factual boundary

- Prompt context: authorized LCI/0 independently seeded implementation,
  differential conformance, detailed reporting, archival, publication, and
  safe removal of recoverable local detritus.
- Authorship: Codex produced the implementation and evidence under the user's
  authorization; normative documents and fixtures are frozen third-party
  inputs and are not claimed as Codex-authored.
- Factual standing: raw command output and protocol streams are observed
  execution evidence; frozen package files are inputs; authorial-return packets
  document underdetermination; this receipt records archive mechanics.
- Boundary: the archive is not an authorial closure, conformance PASS,
  independent external reviewer PASS, merge authorization, or production
  warrant/standing/cryptographic/module/live-migration authorization.

Loose raw files may be removed from the final branch tip only after this
archive and receipt are committed. The archive, immutable seed history,
standalone preimplementation bundle, frozen inputs, and authored receipts are
not cleanup detritus.
