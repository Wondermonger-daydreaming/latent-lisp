# LCI/0 Cleanup Receipt

Date: 2026-07-14

Status: **safe archive-covered cleanup complete.** This receipt changes no
implementation, normative input, expected result, or semantic evidence claim.

## Preconditions

Cleanup began only after all of the following were true:

- current exact/post raw transcripts were committed at
  `7ff074fdc234d826a113b0beb5e36b490d94b579`;
- refreshed nonregression transcripts were committed at
  `e552346123a35225023f5b33d8f288c7064e11da`;
- corrected documentation was committed at
  `a8bfdbdc3f10e8c57b1b4a9c14edbea00b9ba270`;
- the reproducible archive and its checksum receipt were committed at
  `37cdf0acbffc6e1f245c1870d9d68fd298151eca`; and
- the archive's two builds were byte-identical, its 180-entry listing was
  inspected, and all 179 declared payloads passed extracted size/SHA-256
  verification with zero missing or extra files.

Archive recovery identity:

```text
mneme/lci0/evidence/LCI0-IMPLEMENTATION-EVIDENCE-2026-07-14.tar.gz
9,573,988 bytes
afad708a44b467c5945679001c0b49b5dbbfc6990e02a6c43d1fb4485b9a15fa
```

## Tracked loose files removed from the final tip

| Directory/class | Files | Bytes before removal |
| --- | ---: | ---: |
| Baseline request/response/stderr streams | 5 | 75,513,999 |
| Corrected exact r4 request/response/stderr streams | 5 | 75,974,750 |
| Post final6 requests, cases, command transcript, adapter/native/suite/runtime streams | 43 | 80,576,429 |
| Final nonregression command stdout/stderr streams | 10 | 28,368 |
| **Total** | **63** | **232,093,546** |

Every removed path is present with matching bytes and SHA-256 in the committed
archive and remains recoverable from its earlier raw-evidence Git commit. Git's
name-status record for the commit containing this receipt is the exact
path-by-path deletion inventory.

## Compact evidence retained at the final tip

- baseline `summary.json` and `sha256-manifest.json`;
- exact r4 `summary.json` and `sha256-manifest.json`;
- post final6 `summary.json` and `sha256-manifest.json`;
- nonregression `COMMANDS.md`, `SHA256SUMS.txt`, and
  `cd0-frozen-inventory.sha256`;
- the complete reproducible evidence archive, archive receipt, and checksum
  manifest;
- every normative specification, fixture/package archive, implementation,
  test, authorial-return packet, seed receipt, and final relay; and
- immutable seed/successor history, the local backup ref, and standalone
  preimplementation Git bundle.

The tracked `mneme/lci0` working-tree footprint fell from approximately 232 MiB
to approximately 20 MiB after removal. This is a worktree cleanup; Git history
still intentionally retains the earlier raw blobs.

## Generated detritus

Ignored Python bytecode caches under the integration worktree were removed
before archive construction. They were generated runtime detritus, not evidence
members. After the tracked cleanup commit, task-specific temporary replay,
extraction, and duplicate-archive files may also be removed from `/tmp` because
their authoritative archive and receipts are committed.

## Explicitly preserved boundaries

No frozen CD/0, LCI/0 normative file, fixture, seed commit, implementation
source, test, summary, manifest, receipt, archive, backup ref, bundle, unrelated
user file, or branch/worktree was deleted. Main was not modified or merged.

The semantic disposition is unchanged: unaffected implementation/evidence is
ready for independent audit; overall LCI/0 conformance remains BLOCKED pending
the ten authorial closures.
