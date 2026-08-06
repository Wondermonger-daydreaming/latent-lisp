# SURFACE ACCOUNT /0 — ADOPTION RECEIPT

**Date:** 2026-08-06 (written 20:00 −03, `date` run at writing).
**Authority:** owner ruling "ACCEPT R4.3" (2026-08-06) — R4.3 accepted, R4 laboratory
terminally closed, controlled adoption/publication round authorized from
`718f998382512a1f42fd2df2809cbb4904e1ba15`; push separately owner-authorized in-session
("Publish mirror + push lab origin") after the merge was staged behind `SYNC-PAUSED`.
**Chair:** Claude Fable 5 (adoption executed by the chair's own hands; readback by an
independent fresh-context Opus seat).

## Identities

| Identity | Value |
|---|---|
| Accepted candidate tip | `718f998382512a1f42fd2df2809cbb4904e1ba15` (branch `surface-account-0-r4`, 15 linear commits on accepted base `2c1ac711…`) |
| Adoption merge commit (lab `main`) | `6715d2c480aa37c2584d11d353de17ad55816484` (`--no-ff`; merge message cites the ruling) |
| Lab committed subject tree after merge | `310586ed9b5923d7be153747fc6d9064631d9a36` — **byte-equal to the candidate's subject tree** (chair-verified pre-publication) |
| Published mirror tip | `134389feac0694d6e06f3b588fdeb27671b50416` (github.com/Wondermonger-daydreaming/latent-lisp, `ced1b2c..134389f`) |
| Readback (content) | `verify-sync.sh`: **IN SYNC** — mirror content equals lab committed subject tree (chair-run); independent readback: 4650 files/side, zero diffs, 9/9 sha256 spot-checks MATCH |
| Lab origin push | `7151b49d..6715d2c4  main -> main` (Wondermonger-daydreaming/Claude-Code-Lab) |
| Frozen probe lane | `8a8bf75f…` unchanged through adoption |
| Surface `/3` | **still shut** — untouched by this round |

## Publication discipline

The merge was performed behind the `SYNC-PAUSED` sentinel; the post-merge auto-sync
fired and was **refused by the sentinel** ("nothing published" — logged), so nothing
reached any remote before the owner's explicit push authorization. On authorization the
sentinel was removed, `sync.sh` published the committed subject tree (git-archive
materialization; the working tree cannot publish), and lab `main` was pushed to origin.

## Gates at the published identity (independent public-clone rerun, SBCL 2.4.6 exact)

From a bare clone of the public mirror at `134389fe…`, all executed by the READBACK
seat (report: `_staging/adoption-readback-findings.md`, sealed in the receipt parcel):

- production self-test **38/38** (planted-fault tooth fires, exit 1)
- inhabited `/0 → /2` specimen **12/12**
- ASDF/umbrella graph gate **9/9**
- hostile execution **110/110** (7 roles + 4 loader cases)
- disease comparators **8/8 detected, 8/8 controls clean**
- commissioned loader witnesses **14 + 10 + 8 + 12**
- frozen R3.3.3 battery: **13/13 profiles accepted**, `SURFACE-ACCOUNT-0-PROBE-PASS`
- cold ASDF through the umbrella: package=T ready=T, **9 exports, all `:EXTERNAL` and fbound**
- repository floor: **full 94 attempted / 92 passed / 2 blocked; CI 76 / 74 / 2** — up
  from the historical public 87+2 / 71+2 by exactly the five new surface-account rows,
  which pass **5/5 (full) and 3/3 (CI)**. The two blocked rows are the known
  `431fee16`-absence phenomenon (lab-private Surface /1 evidence addendum; one cause,
  two rows) — the standing public-clone limitation, unchanged by this adoption.

## Standing interpretations carried from the ruling

- The identity mechanism, `/0 → /2` inhabitance, and frozen R3.3.3 regressions are
  **PASS — LOCKED**.
- The **forged-package residual** (nine external counterfeits + pre-interned carrier
  satisfying the guard) is real and **non-blocking**: the readiness predicate
  establishes API shape under ordinary image composition and is not a security or
  provenance boundary. The source phrase "interned only by actually reading the
  implementation" is interpreted under the **non-forging package precondition**; the
  carrier is a completeness marker, not cryptographic attestation.

## Custody chain (sealed parcels, `/home/gauss/Downloads/`)

- R4 return: `SURFACE-ACCOUNT-0-R4-PRODUCTION-CANDIDATE-RETURN-2026-08-06.zip`,
  SHA-256 `3cbce84b…` — owner ruling: HALT (readiness-guard defect), R4.3 commissioned.
- R4.3 return: `SURFACE-ACCOUNT-0-R4.3-LOADER-FINALITY-RETURN-2026-08-06.zip`,
  SHA-256 `75fd2ca9e484cd7a2f400ee7f7fda4dc09396fae55c132e327b30e4142c00506` — owner
  ruling: **ACCEPT / ADOPT**.
- Adoption receipt parcel: `SURFACE-ACCOUNT-0-ADOPTION-RECEIPT-2026-08-06.zip`
  (sealed after this file's commit; its sidecar carries the hash).

Adoption executed, published, read back, and gate-verified at the published identity.
The lane's laboratory is closed; what remains open is only what the owner opens next.
