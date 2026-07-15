# LCI/0 FIXTURE OVERLAY 0.2 MANIFEST (repository bookkeeping)

**Overlay package root:** `lci0-fixture-overlay-0.2-2026-07-14/`
**Overlay revision:** `0.2` (additive fixture-authority overlay)
**Archive:** `archives/lci0-fixture-overlay-0.2-2026-07-14.zip`
**Archive SHA-256:** `5e03c2f5a17cf69f9b562dcfc5b7dfde85563fc7f88d52fcb01ffe858c1a10eb`
**Archive bytes:** `274618`

## Standing

This overlay instantiates the ten LCI/0 authorial closures
(`LCI0-AC-001` … `LCI0-AC-010`) from the verified closure packet:

- `LCI0-AUTHORIAL-CLOSURE-VECTORS.jsonl` SHA-256
  `14db4a8400714b669eee781dedfc92d7a1f7af6c77a01eef23f83c30270f1582`
- `LCI0-AUTHORIAL-CLOSURE-REGISTER.json` SHA-256
  `5d4fcc279f6333fe7492fa4d2ffd38a40a40e6243ce3cbe8973631c68ee8f909`

The 0.1 fixture package (`archives/lci0-errata-0.1-fixture-package-2026-07-14.zip`)
remains byte-for-byte unchanged and historically reachable. The overlay is
strictly additive: it supersedes exactly four 0.1 vector expectations
(`LCI0-N012`, `LCI0-E5-COVERAGE-INSUFFICIENT`, `LCI0-P029`, `LCI0-P024`),
adds 38 relation companion-failure documents, eight hostile expectations,
and four register-only closure records. Every other 0.1 entry remains
authoritative and unchanged (Errata F0.2-1).

## Installed fixture-root layout (cross-language contract)

```
<fixture-root>/
  LCI0-FIXTURE-REGISTRY.json            (0.1, unchanged)
  LCI0-FIXTURE-VECTORS.jsonl            (0.1, unchanged)
  ... other 0.1 members, unchanged ...
  lci0-fixture-overlay-0.2-2026-07-14/  (overlay package root, extracted)
    LCI0-FIXTURE-OVERLAY-0.2-INDEX.json
    LCI0-FIXTURE-OVERLAY-0.2-MANIFEST.md
    LCI0-FIXTURE-OVERLAY-0.2-SHA256SUMS.txt
    LCI0-FIXTURE-PACKAGE-ERRATA-0.2.md
    supersessions/    (4 members)
    relation-failures/ (38 members)
    hostile/          (8 members)
    closure-records/  (4 members)
```

Loaders detect the overlay subdirectory, verify
`LCI0-FIXTURE-OVERLAY-0.2-SHA256SUMS.txt` against the extracted tree, and
consult `LCI0-FIXTURE-OVERLAY-0.2-INDEX.json` (overlay-first for the four
supersession keys; fall-through to 0.1 for everything else). A fixture root
without the overlay subdirectory behaves exactly as before.

## Overlay member digests

| Member | SHA-256 |
| --- | --- |
| `LCI0-FIXTURE-OVERLAY-0.2-INDEX.json` | `949d0c802ea02903b858aa692ee5b846220a2442c3f481b397b4171a3b4a44ff` |
| `LCI0-FIXTURE-OVERLAY-0.2-MANIFEST.md` | `78a1dc7b7bc3413649319a02582dd5d8f90d59e81eb122e71578691d32be14bc` |
| `LCI0-FIXTURE-OVERLAY-0.2-SHA256SUMS.txt` | `60036d2d94c75f80b66afc63b72f5f94a1a90d1a28e92bf47baa1112b5594b81` |
| `LCI0-FIXTURE-PACKAGE-ERRATA-0.2.md` | `18d4f18ee4d211234a9281da3421e44b5cda534c9dfaad7af07c1f99e13b19ec` |

58 members total: 54 closure-mapped payload members + 4 infrastructure
members. Per-member digests are carried inside the overlay's own
`LCI0-FIXTURE-OVERLAY-0.2-SHA256SUMS.txt`.

— installed by FORGE-CL on branch `codex/lci0-common-lisp-closure`
