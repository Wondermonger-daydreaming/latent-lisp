# Targeted CD/0 Errata 0.1 re-audit packet

Date: 2026-07-13

This compact packet supports a targeted review of the authorized CD/0
post-audit errata repair. It is not a request to repeat the entire original
audit unless review finds a canonical-byte, abstract-equality,
accepted-document, unrelated-generator, v1, or unrelated-source change.

## Exact review boundary

```text
audited integration base
baeecd5e0347435b9e1362000344f46ea441c6ec
tree 41d3a71c06692174701bfde8f071e7da1c719651

immutable archive source
86df3646b61cfc0ea4ec66c245a8b98600f8e86b
tree 84b276c9b44dd6adb86b713aee3430b3162afb24
```

The exact Git delta is carried by `exact-diff.bundle`. It advertises successor
commit `86df3646…` and requires audited base `baeecd5e…`:

```text
git bundle verify exact-diff.bundle
git fetch exact-diff.bundle \
  refs/heads/codex/cd0-integration-errata-0.1:refs/heads/review/cd0-errata-0.1
git diff baeecd5e0347435b9e1362000344f46ea441c6ec \
         review/cd0-errata-0.1
```

`exact-diff.name-status.txt` and `exact-diff.stat.txt` are navigational views;
the verified bundle and the two commit/tree identities are authoritative for
the exact delta.

## Suggested reading order

1. `CD0-POST-IMPLEMENTATION-RULING.md`
2. `CANONICAL-DATUM-SPEC-ERRATA-0.1.md`
3. `CD0-ERRATA-IMPLEMENTATION-LEDGER.md`
4. `cd0-errata-0.1.json`
5. `CD0-ERRATA-VERIFICATION-TRANSCRIPT.md`
6. `CD0-ERRATA-DIFFERENTIAL-RECEIPT.md`
7. `CD0-ERRATA-RELEASE-RECEIPT.md`
8. `CANONICAL-DATUM-DIVERGENCES.md`
9. `CD0-ERRATA-DOCUMENTATION-CORRECTIONS.md`
10. `CD0-ERRATA-ARCHIVE-RECEIPT.md`
11. `CD0-ERRATA-FABLE-RELAY.md`
12. the later targeted-independent-review and remote-read-back receipts

The relay is deliberately copy/paste-ready for another model or reviewer.

## Required identities

```text
ruling
1a0e8ff844790c93e681f7541a23266aa73d2ee8e9ca9a6e0d753bf4e044b2bc

Errata 0.1
5f1568e53c4e6ef5fc8de2e125e7a6ef2d861392048c7ead144c7df05eb16271

promoted A1-A9 vectors
55725e14e763075a8866be9da8be9f8647b5b06803e1fea6f661068d87651ddc

archive
09498ebdd2d3be48c93d5236816c4a4fa249a164229616597678c97626857093
20,461,944 bytes; 1,383 tar entries
```

The archive is retained outside this directory at
`../artifacts/cd0-errata-0.1-2026-07-13.tar.gz` relative to this packet
directory. Its source, two-build byte comparison, member count, and bounded
claim are in `CD0-ERRATA-ARCHIVE-RECEIPT.md`.

## Accounting checkpoint

Phase-0 is reported as dispositions, never as “71 tests passed”:

```text
71 classified = 66 octet + 5 host
Python:      71 executed, 0 N/A, 0 failures, 0 skips
Common Lisp: 68 executed, 3 N/A, 0 failures, 0 skips
```

The 37 promoted operations decompose as:

```text
A1=6 A2=5 A3=6 A4=3 A5=3 A6=2 A7=1 A8=6 A9=5
```

## Claim boundary

Independently seeded implementations under shared normative infrastructure,
with procedural—not OS-enforced—isolation, attested by the implementers and
corroborated at content tier.

The independence anchors are the seed commits named in the relay, not corrected
branch tips. No merge to `main` is claimed. Final status may be stated only as
“eligible for targeted independent verification” after the packet review and
remote read-back gates are complete.
