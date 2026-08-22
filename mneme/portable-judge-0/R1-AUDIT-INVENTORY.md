# R1 RETURN-PARCEL AUDIT — EXACT INVENTORY FOR THE OWNER

**Prepared by the chair (Claude Fable 5), 2026-08-10, per OWNER-RULINGS-1 Ruling 2 /
Next-action item 3.** This inventories everything the audit needs and the recipe to
verify it. **Caveat carried up front: every witness in the parcel was re-run by the
packer (CAPSARIUS, construction loop). This audit is the first check from outside the
construction loop. It is still not a stranger audit, and nothing it greens may be
called independently verified.**

## A. The artifact

| | |
|---|---|
| Tarball | `~/Downloads/many-acts-0-r1-return-parcel-2026-08-10.tar.gz` |
| Size | 268,130 bytes |
| sha256 | `54aa7783c494d8f32baa3c10eecd48590b88b13f07f0de6c8724831807a02803` |
| Manifest | 85 entries, in-parcel, verified 85/85 by packer post-extract |
| In-parcel documents | R1 RETURN (also at lane commit `e170e1d6`) · patch (37 files, +3837/−91) vs predecessor · pre-repair red transcripts · fixtures · 7-arm coverage table · freeze IDs · P4 source + first-run transcript (preserved unaltered; missing exit code left missing) · inventory · manifest + sidecar |

## B. Repository coordinates the parcel claims (chair-reported; the audit re-derives them)

| Coordinate | Value | What it is |
|---|---|---|
| Predecessor pair | `f83a0689` ↔ `76952ea4` | differ by ONE ledger-only commit; **subject trees identical `f1e5e587…`** (R1 ruling §1 reconciliation) |
| R1 patch base | `76952ea4f278d269f98f158555e412a095a3da6f` | tree `ea60fc7e…` |
| Pre-repair reds | `9dd43fb6` | D1–D5 red-first witnesses (`r1/pre-repair/`) — **five reds preserved, not four** (D5's kept; disclosed finding) |
| Repairs | `66ed222a` | the four ruled defects (ownership, branch binding, circular source, env cross-wiring) |
| Coverage | `b0d1b844` | 7 arms / 126 facets |
| Regression floor | `0d70b516` | suite 200 |
| Property-2 fix | `b1305aa9` | env-generation clarification round; chair's wrong property-3 reading = disclosed RETURN finding |
| R1 freeze | tip `231873c7`, freeze-record `9bff7d02` | **lane subtree `e94870bd9091e67f68e9cf238a6c5d0dcf302a05`** |
| P4 "vindemia" | `ef98ede1` | GREEN FIRST RUN 11/0, fourth domain, frozen jaw |
| R1 RETURN | `e170e1d6` | lane + parcel root |
| Branch tip at parcel close | `0a403c0b` | later commits on the branch are post-close autosync/diary/PortJ-0 — none touch the lane (audit should confirm: `git log 0a403c0b..71422395 --stat -- experiments/latent-lisp/mneme/language-many-acts-0/` is empty) |

## C. Witness set (expected values; re-run is optional but recommended serially)

| Witness | Expected | Note |
|---|---|---|
| Selftest ×2 | 200/0 twice, **byte-identical outputs** | derivation cross-check: PortJ/0 census statically derives 200 = 39+2+11+35+23+90 |
| Teeth | 15 sections / 15 green / 0 red | serial, direct exit capture; a mid-run red under concurrency was the known artifact class in /0 — run serially only |
| P3 "peregrinatio" | 11/0 | first-execution transcript preserved |
| P4 "vindemia" | 11/0 | first-run transcript unaltered; the missing exit code is *supposed* to be missing — a fabricated one would be the defect |
| One Act floor | 173/0 | adopted substrate untouched |
| Release floor | 77/77/0, rows unchanged | needs `strace` (undeclared-dep scar, installed on desktop) |
| V-F digest | `2b51b4df…` intact | |

## D. The seven disclosed findings (audit should read them before any witness)

In-parcel RETURN, including at minimum: five pre-repair reds preserved where the brief
said four · the missing P4 exit code left missing · the chair's wrong property-3
reading · the D2 sealed-law tension · the store-id finding (non-discriminating
semantics; also SD-10 in the PortJ/0 register). The audit's cheapest high-value act is
checking that each finding's underlying artifact actually shows what the finding says.

## E. Verification recipe (walk it as written; open every file it names)

1. `sha256sum` the tarball → must equal `54aa7783…`.
2. Extract to a scratch dir; `sha256sum -c` the manifest → 85/85.
3. `git -C <repo> worktree add /tmp/r1-base 76952ea4` → apply the parcel patch →
   compare the resulting lane subtree hash to the frozen `e94870bd…`
   (`git rev-parse <tip>:experiments/latent-lisp/mneme/language-many-acts-0`).
4. Optionally re-run C's witnesses **serially** from the patched worktree.
   Environment scars that will bite otherwise: SBCL wrapper (operation-check
   `(lisp-implementation-version)` first) · `strace` needed by the release floor ·
   run from repo root.
5. Read the RETURN + findings against their artifacts (D above).
6. Dispose: adopt / return-with-rulings / decline. Adoption is an owner act recorded
   in an adoption record; nothing in the parcel or this inventory constitutes it.

## F. What this audit cannot establish (stated so it is not later claimed)

Not a stranger audit; not independent verification; not evidence for any PortJ/0
station; not a review of the /0 campaign's own earlier parcel (`beb6466b…`, already
owner-audited per the campaign log). It establishes only whether the R1 parcel is what
it says it is, so the base can be disposed.

— Claude Fable 5, chair, 2026-08-10
