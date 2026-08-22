# ROUND P — EXPORT RECEIPT

**A receipt, not a verdict.** This file records that the Round P audit parcel ordered by
**OWNER RULING 2 §3** was built and sealed. It adopts nothing, concludes nothing, and claims
no evidence. **Round P remains HELD FOR PARCEL AUDIT; zero evidence remains earned.**

---

## The parcel

| | |
|---|---|
| **File** | `round-p-audit-parcel-2026-08-10.tar.gz` |
| **Location** | `~/Downloads/` (off-repo, hand-carried; not committed, not published, not mirrored) |
| **sha256** | `422910c9c2ad6a9b59dd657d30674132047cd40bd003a8c534f36cf496521ba8` |
| **Size** | 534370 bytes |
| **Contents** | 31 files (30 checksummed + `MANIFEST.sha256` itself) |
| **Staged dir** | `round-p-audit-parcel-2026-08-10/` |
| **Built** | 2026-08-10T20:02:46Z |

## Review object

| | |
|---|---|
| **Frozen court baseline** | `71422395983acf54e597445675b7dcdfcf6b63d0` · tree `6077084fdbcc6a077558343eacfac77853f7ea1e` |
| **Round P tip** | `ba2ffe8b23c22ffc718207cc19d414d43023766c` · tree `ac38769202c36bb4375871883b5c148ae486debf` |
| **Branch** | `many-acts-0-candidate` — not merged, not published |
| **Artifacts** | the 11 files added by `ba2ffe8b`, byte-exact (11/11 blob-identical, verified after fresh extraction) |
| **Explicitly NOT in scope** | `572f7edf` (Round OA) — a separate review object under Ruling 2 §3 |

## Staging summary

```
round-p-audit-parcel-2026-08-10/
├── PARCEL-README.md            reading order, standing, the one decision
├── IDENTITIES.txt              full sha1s + trees; the 7 commits between, with roles
├── SCOPE.md                    14 authorized subjects, 7 prohibitions, structural proof
├── FROZEN-INTACT-PROOF.txt     13/13 originals byte-identical (2 independent checks each)
├── REDLINE.md                  9 original→successor pairs, mapped to authorizations
├── CONCLUSIONS-AND-EVIDENCE.md 17 conclusions + 6 staleness + 5 disclosures, citations checked
├── UNRESOLVED.md               22 open items, 8 groups, no recommendations
├── C7-DOSSIER.md               the ordered C-7 exposure — owner decision, not derivation
├── MANIFEST.sha256             30 files; does NOT include its own hash (house law)
├── artifacts/                  the 11 review-object files, bytes as of ba2ffe8b
├── redline-diffs/              9 full unified diffs
└── reconstruction/             round-p.bundle + REPLAY.txt (recipe walked before written)
```

**Bundle:** sha256 `6dff1d4c25ea4af9061eb1f7ba980a0ef93add613481c34af638120520926f08`, 216552 bytes; head `ba2ffe8b…`, prerequisite `71422395…`, 7 commits.

## Verification performed at seal

- `sha256sum -c MANIFEST.sha256` after **fresh extraction** into an empty directory:
  **30 OK, 0 FAILED.**
- `git bundle verify` on the **extracted** bundle: *is okay*; head and prerequisite as above.
- The 11 extracted artifacts re-hashed against `git rev-parse ba2ffe8b:<path>`:
  **11/11 blob-identical.**
- The bundle's replay recipe was **executed** against a fresh clone before `REPLAY.txt` was
  written: materialize → compare → **11/11 MATCH**.
- Frozen originals: 13/13 empty diff **and** identical blob sha, plus a directory-wide status
  check — **22 added, 0 modified, 0 deleted**.
- Lane untouched: `git diff 71422395 ba2ffe8b -- …/language-many-acts-0/ …/language-act-0/`
  → **0 bytes**.

## The C-7 bottom line, as ordered

**Not derivable from already-governing law — an explicit owner decision.** C-7 is defined
inside a candidate court document, not in the adopted lane, and the frozen original
**contradicts itself** on the discriminating record.

- **Interpretation 1** (C-7 as enumerated = 4) → net **162** (161 if C-8 is also corrected)
- **Interpretation 2** (C-7 as the frozen original's own §5 row 14 applies it = 5) → net
  **161** (160 if C-8 is also corrected)
- **Discriminating record:** `ma0-selftest-suite.lisp:946` — `"prefix-frames-after=8"`.
  In the bank under Interpretation 1; removed under Interpretation 2. The **only** record
  that differs.
- Two further interpretations (9, 10) are live and are set out with their own discriminating
  records. **No interpretation was chosen.**
- **Warning carried in the parcel:** `161–162` is not agnostic about C-7 — it holds C-7 at 4
  while declaring it unresolved — and **`161` is reachable two different ways.**

## Two defects found at export, reported and not repaired

1. **`43 %` is a count printed as a percentage** — the 90-check scenario bank is 43/90 =
   **47.8 %** LANG (43.3 % is the *substrate* share). The error is in
   `VECTOR-CLASSIFICATION-CANDIDATE-P1.md` §3.3 and travels into `ROUND-P-RETURN.md` §2.
2. **The frozen original contradicts itself about C-7** — its §5 row 14 calls
   `prefix-frames-after=8` C-7-contaminated while its C-7 row does not enumerate it. C-7 is
   underdetermined **by contradiction**, not merely by silence.

A parcel audit does not repair its own review object; both are left in place.

## Standing after this export

Unchanged. **Round P: returned, HELD FOR PARCEL AUDIT.** Nothing adopted, nothing published,
no evidence earned. This receipt is uncommitted — **the chair commits.**

---

*— packed by SIGILLATOR (Claude Opus), commissioned by the chair (Claude Fable 5), 2026-08-10*
