# ROUND OA — EXPORT RECEIPT

**Uncommitted receipt.** Records that the Round OA audit parcel ordered by
`OWNER RULING 2 — POST-R1 DISPOSITION AND PARCEL A ORDER` §3 was built, sealed and
verified. **This receipt adopts nothing, publishes nothing, and disposes of
nothing.** Round OA's standing is unchanged: **HELD FOR PARCEL AUDIT.**

## The parcel

| | |
|---|---|
| Tarball | `~/Downloads/round-oa-audit-parcel-2026-08-10.tar.gz` |
| sha256 | `55d6b568491e16bd5f7028ba8f9a27316f1b02305363880c08f1606303d43f34` |
| Bytes | 429,502 |
| Contents | 26 files, 1,082,211 bytes extracted; `MANIFEST.sha256` covers all 26 (it excludes itself) |
| Fresh-extract verification | extracted to a clean temp dir; `sha256sum -c MANIFEST.sha256` → **26/26 OK, 0 failures** |

## The review object

| | |
|---|---|
| Base (frozen court-construction baseline) | commit `71422395983acf54e597445675b7dcdfcf6b63d0`, tree `6077084fdbcc6a077558343eacfac77853f7ea1e` |
| Tip (Round OA parcel commit) | commit `572f7edf50d9a9216251536753d4d77cf6ef1e30`, tree `f34fedb9ca29c8ab81227132501d29fd24913258` |
| Ancestry | `git merge-base --is-ancestor 71422395 572f7edf` → true |
| Reconstruction | `reconstruction/round-oa.bundle`, sha256 `fb9277691e58e326c507eadaee65163c3b4b5fca426c02e3eded5f493d412187`, 68,360 bytes; carries `refs/heads/round-oa-tip → 572f7edf`; prerequisite `71422395` |
| Branch | `many-acts-0-candidate` — never merged, never published |

## What the parcel carries

The six Round OA deliverables as of `572f7edf` (blob-verified); the OA proposal as
of `fa712000` and the two owner instruments as context; the five
`_staging/oneact-candidate/` subject documents as of the adopted candidate commit
`461f2013` plus the adoption record and closure transcript as of `006a2f12`, as
clearly-labelled subject-side exhibits; a scope statement; the verdicts preserved
exactly; a frozen-intact proof; every conclusion with its cited evidence
re-derived; and every unresolved question, uncollapsed.

**The result travelled verbatim:** OA-I `5/5` · OA-N `0/5` · Category 1 empty ·
Category 2 all five documents, with the owner's provisional consequence quoted in
full. No verdict word was altered, softened, strengthened, or resolved.

## Verification performed at export

- 13 frozen `71422395` artifacts (12 under `portable-judge-0/` + the languagehood
  charter): **13/13 byte-identical at `572f7edf`**; empty diff; zero modified and
  zero deleted files under the frozen directory.
- `_staging/oneact-candidate/` across the round's range: **empty diff**; the five
  documents' blobs equal at `461f2013`, `71422395` and `572f7edf`.
- 14 conclusions re-derived from the committed bytes: **14 resolve**, 2 with a
  recorded precision, 0 false, 0 repaired.
- Sealed stranger packet: located, re-hashed (`05731799…6d0d`, 374,222 bytes),
  **NOT opened** — no `tar -t`, no `tar -x`, no decompression. Status unchanged:
  SEALED, UNOPENED, NOT COURIERED, NOT ADJUDICATED; the stranger audit remains
  **waived by owner variance, never passed**.
- Closure bundle (`598c0cfc…f90635`, 721,559,941 bytes) referenced by digest and
  **not packed** (size); its rematerialization transcript stands in.

## Deliberate omission

This receipt does **not** print the five subject documents' adopted content sha256
digests. Round OA's finding at its baseline was that no record in this repository
hashes those bytes individually; printing them into a repository file would alter
the very measurement the round reports. The digests live in the parcel
(`IDENTITIES.txt` §3 and `MANIFEST.sha256`), which is a file in `~/Downloads`, not
a record in the tree.

## Standing

No One Act publication and no semantic-adoption action is authorized. Per
`OWNER RULING 2` §3: *"No One Act publication or semantic-adoption action is
authorized until I inspect and dispose of the OA parcel."* The export is a
delivery, not a disposition, and earns zero evidence toward any PortJ/0 station.

This export was a second hand re-running measurements inside the same repository,
the same chair and the same model family as the round it checked. It is **not** an
independent audit and must never be described as independently verified or
independently validated.

— packed by OBSIGNATOR (Claude Opus), commissioned by the chair (Claude Fable 5), 2026-08-10
