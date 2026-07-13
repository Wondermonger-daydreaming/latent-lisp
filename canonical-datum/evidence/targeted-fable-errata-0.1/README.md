# Targeted Fable packet — CD/0 Errata 0.1

Packet date: 2026-07-13

This directory is the compact targeted re-audit packet requested by the
post-implementation ruling. Start with `CD0-ERRATA-FABLE-RELAY.md`.

## Local closure contents

- byte-exact ruling and Errata 0.1 copies;
- implementation ledger;
- promoted 37-case A1–A9 vector manifest;
- final local verification transcript;
- release and archive receipts;
- four-LOW documentation-correction receipt;
- exact name-status and stat views from audited integration tip to archive
  source commit;
- a verified Git bundle carrying the exact object diff;
- targeted independent-review and remote-read-back receipts, added by later
  envelope commits after those events occur.

The archive itself is retained at
`canonical-datum/evidence/artifacts/cd0-errata-0.1-2026-07-13.tar.gz` rather than
duplicated inside this packet.

## Exact diff boundary

```text
audited base:  baeecd5e0347435b9e1362000344f46ea441c6ec
archive source: 6c82787f7cff4ccd14e78885af11ff79130b0313
source tree:     9b6ef7cfe9bb06b78f152741a384f94febf8cdd8
```

`exact-diff.bundle` contains the successor branch ref at the archive source and
declares the audited base as its prerequisite. It was verified with:

```text
git bundle verify \
  canonical-datum/evidence/targeted-fable-errata-0.1/exact-diff.bundle
```

The result was `is okay`, with contained ref
`6c82787f7cff4ccd14e78885af11ff79130b0313` and required ref
`baeecd5e0347435b9e1362000344f46ea441c6ec`.

To inspect the exact textual diff after fetching/unbundling:

```text
git diff --find-renames \
  baeecd5e0347435b9e1362000344f46ea441c6ec \
  6c82787f7cff4ccd14e78885af11ff79130b0313
```

The retained path inventory contains 332 paths. Its stat is 396,228 insertions
and 596 deletions; most additions are generated corpus and exact request/response
evidence. No path under `mneme/` changed.

## Load-bearing hashes

```text
exact-diff.bundle
7e712e4ac4480b065bec19bb7b507f3d9d7826b40f8e867dce9f99e511429f43

exact-diff.name-status.txt
7395eb8796147b4d07f01b660421dafbaaea18dd11f484dd6d5c640edcd4da6e

exact-diff.stat.txt
9da6316af9214748acc8074ced052776fa3f4dd56080c72af2641b1d1611fdb5

archive
0886d90f17643b2b8e47402d6735c0417a1621b7866dd5ea385c60f813963e0a
```

The packet checksum manifest is generated after the independent-review and
remote-read-back members are present. A review should recompute, not merely
trust, every listed digest.

## Scope boundary

This packet supports a targeted A1–A9 and documentation review. A broad repeat
of the original audit is required only if inspection finds a canonical-byte,
abstract-equality, accepted-document, generator-semantic-outside-authorized-
vectors, v1, or unrelated-source change. No merge to `main` is represented.
