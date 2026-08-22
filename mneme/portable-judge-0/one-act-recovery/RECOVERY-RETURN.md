# ONE ACT /0 — PUBLICATION RECOVERY: ROUND OA RETURN

**CANDIDATE parcel — Round OA; not an adoption; frozen court-construction
baseline commit `71422395`; read-only over adopted history; zero evidence toward
any PortJ/0 station.**

Round OA opened by OWNER RULINGS 2 (2026-08-10). Six deliverables produced, all
in `experiments/latent-lisp/mneme/portable-judge-0/one-act-recovery/`. Nothing
promoted, repaired, moved, or committed. The sealed stranger packet was located
and digest-verified **without being opened**.

---

## 1. What was determined

The owner's ruling splits one question into two. Both were answered separately
for each of the five documents, and they answer differently.

**OA-I — cryptographic inclusion: PROVEN for all five, at the bundle level.**
The adoption-time closure bundle was found on this machine, its sha256 matched
the adoption record, it verified and materialized in a fresh empty repository
with no alternates, and each of the five documents' blobs was compared
byte-for-byte against the present working copies: `cmp: IDENTICAL`, five of
five. All six legs the owner enumerated are discharged from the bundle, not
substituted by tree ancestry.

**OA-N — normative incorporation: NOT ESTABLISHED for all five.** The instrument
that adopted One Act /0 speaks only in object coordinates. Its scope language
does not contain the word *contract*, the word *specimen*, the phrase *test
plan*, the word *document*, or the string `_staging` — measured, zero
occurrences each. The rulings that *do* adjudicate these documents' clauses
(R1, R0.1, R2.3) each state in terms that they do not adopt. And the verbatim
text of the adopting instrument is not in the repository at all.

## 2. Per-document verdicts

| Document | OA-I | OA-N | Category |
|---|---|---|---|
| `ONE-ACT-0-CONTRACT-CANDIDATE.md` | **PROVEN** | **NOT ESTABLISHED** (strongest case: 15+ governing-law citations from adopted source) | **2** |
| `ONE-ACT-0-SPECIMEN.md` | **PROVEN** | **NOT ESTABLISHED** (cited by gates; successor lane calls its arms "adopted") | **2** |
| `ONE-ACT-0-TEST-PLAN.md` | **PROVEN** | **NOT ESTABLISHED** (cited by `act0-gates.lisp`; owner R1 quotes its MUST-RESOLVE register) | **2** |
| `ONE-ACT-0-FAILURE-MATRIX.md` | **PROVEN** | **NOT ESTABLISHED — materially weaker** (zero source citations; self-declared "governed by" the contract) | **2** |
| `ONE-ACT-0-IDENTITY-TABLE.md` | **PROVEN** | **NOT ESTABLISHED — materially weaker** (zero source citations; "the contract controls") | **2** |

**No document reaches category 1. No document is EXCLUDED.** Per the owner's own
rule — *"If cryptographic inclusion is proven but normative incorporation
remains unproven, classify the material as category 2"* — category 1 is empty on
the present record. It is empty for want of one sentence, not for want of merit.

### Clause-level splits (recorded, not resolved)

- **R2.1 erratum clauses** (BIND-3n/3i split, A-5a coverage enumeration, arm B-R
  as the UNPAIRED F1, "six arms" not seven) — contract §2.4/A-5a/A-6, specimen
  §6.1. Authored by **chair ruling**, after the owner-blessed pre-code seal,
  never individually owner-ruled or hashed. If the parent document is elevated,
  these clauses still fork on whether the adoption reaches the adopted bytes or
  the sealed bytes.
- **The self-disclaimers** ("Nothing here is adopted", "Authority claimed: none",
  "Standing: CANDIDATE STAGING", "No implementation exists") — false of the
  adopted state, never struck by any instrument, and unpublishable as-is without
  an external correction.
- **Test plan §5.7** ("OCTETS PENDING") — superseded by run output; the frozen
  V-F table lives outside all five documents. Category-3 territory.
- **C4-01 … C4-14** (`COMMENT-LAW-SWEEP.md`) — the R2.2/R2.3 body of law,
  absent from the five documents **by construction**. Category-4 territory.

## 3. Tensions exposed (unresolved, by instruction)

1. Adopted sources call the contract *"Governing sentence"*; the adoption record
   names no document at all.
2. The adopted contract bytes say **"Authority claimed: none"** and *"not a
   contract in force"*, while the adopted implementation cites the same file as
   law. **This is the sharpest tension in the record.**
3. The sealed corpus is not the adopted corpus: the last per-file seal is
   `3c4e704d`; all five changed afterwards, by chair ruling; contract §0.2 tier 3
   reads *"This contract, once sealed"* and does not say which text it means.
4. Tree membership proves too much: **375 `_staging/` paths** ride the same
   adopted tree, including geomancy reviews, alien-philosopher probes and a
   Python permutation-null benchmark.
5. The adopting instrument's verbatim text is missing from the record.
6. Two of the five (failure matrix, identity table) are cited by **nobody** —
   not by source, not by gates, not by the successor lane.
7. Publishing the five would **not** close SD-13: roughly one and a half rounds
   of adopted law has no documentary home.
8. Many Acts /0 already relies on *"the seven adopted … arms of the specimen"*;
   a narrow OA-N ruling would unsettle live downstream language.

## 4. Evidence gaps

- **The terminal adoption ruling is not on disk.** Only the chair's
  `ADOPTION-RECORD-2026-08-08.md` and two handoff summaries survive; the handoff
  says the *"[f]ull terminal receipt [was] delivered in-chat."* Every OA-N
  judgment about the owner's act is therefore a judgment about the chair's
  record of it. **Only the owner can close this gap.**
- **No record hashes the ADOPTED bytes of the five documents individually.**
  Three earlier freeze receipts hash them per-file; every such digest is stale.
  The adopted bytes are covered by one collective object only.
- **The local freeze ref no longer exists on this machine** (only
  `refs/remotes/origin/oneact/candidate-freeze-2026-08-07`). Nothing is lost; the
  chair's proposed command form does not execute as written.
- The R2.1 erratum's own text (`_staging/oneact-r2.1-erratum.md`) was not read
  clause-by-clause in this round; its *effects* were read from
  `git diff 3c4e704d 461f2013`. Traced, compressed.
- Appendix A of the citation table gives per-file counts and the reproducing
  command rather than reprinting 82 lines of lane text. Traced, compressed.

## 5. Commands used (classes; every load-bearing one is exhibited in the deliverables)

`git rev-parse` · `git show-ref` · `git ls-tree -r` · `git cat-file blob` ·
`git hash-object` · `git diff --stat` · `git log --format/--diff-filter/--reverse` ·
`git merge-base --is-ancestor` · `git status --porcelain` · `git grep` ·
`git show <rev>:<path>` · `git init` (temp repos only) · `git bundle verify` ·
`git fetch <bundle>` · `sha256sum` · `cmp` · `grep` / `sed` / `wc`.

All git writes were confined to `mktemp -d` temp repositories
(`/tmp/oa-closure-GuxXNK`). No repository object, ref, or index in
`/home/gauss/Claude-Code-Lab` was modified.

## 6. Explicit non-actions

- **The sealed stranger packet was NOT opened.** It is at
  `/home/gauss/Downloads/oneact-0-stranger-packet-2026-08-08.tar.gz`, 374222
  bytes, sha256 `05731799f811f6e4d675489fe80adcebe3f2b15e63fccc19238c5332068c6d0d`
  — matching the adoption record exactly. Only `ls` and `sha256sum` touched it:
  **no `tar -t`, no `tar -x`, no decompression.** Its status is unchanged:
  SEALED, UNOPENED, NOT COURIERED, NOT ADJUDICATED; the waiver remains a
  variance, never a passed audit.
- **Nothing was promoted or copied into the public lane.** `language-act-0/`
  contains exactly the ten files it contained before this round.
- **Nothing was repaired.** The mis-attributed citation (`act0.lisp:81` cites
  *"contract WE-04"*; `WE-04` is in the specimen and test plan) stands as found.
  No dangling citation exists to repair; none was invented.
- **No comment-only law was converted to prose law**; no missing clause was
  drafted.
- **No file inside any lane or inside `_staging/` was created or modified.** No
  commit was made by this determination. The six deliverables are the only files
  written.
- The frozen PortJ/0 parcel artifacts at baseline `71422395` were not touched.

## 7. The owner decision points

1. **What did the terminal adoption's scope language actually say?** (Its text
   is not in the repository. This single answer governs everything below.)
2. **Which documents, if any, does that scope reach** — all five, or the three
   cited by adopted source (contract, specimen, test plan)?
3. **Does the adoption reach the adopted bytes** (post-seal, R2.1 chair erratum)
   **or only the sealed bytes at `3c4e704d`?**
4. **Do the OA-N tensions block category 1 for specific documents?** The failure
   matrix and identity table are the two most likely to remain at category 2.
5. **Provenance-header format:** sidecar (byte-identity preserved) · inline
   (breaks it) · commit-message only (invisible on the mirror)?
6. **The self-disclaimer problem:** publication note, sidecar statement, both, or
   publish bare and accept the contradiction on the public record?
7. **Are the `_staging/` originals ever retired?** (Recommended: no.)
8. **Does the claims-ceiling rider travel with any published document?**
9. **Is the R2.2/R2.3 comment-only law given a documentary home** — a separate
   owner-commissioned category-4 round — or does SD-13 stay open?
10. **Is Many Acts /0's "seven adopted arms" language addressed in the same
    ruling?**

## 8. The deliverables

| File | Contents |
|---|---|
| `RECOVERY-DETERMINATION.md` | per-document OA-I and OA-N findings with commands and quoted scope language; classification; clause-level splits; the chair's P-1/P-2/P-3 re-established |
| `BUNDLE-REMATERIALIZATION-TRANSCRIPT.txt` | verbatim transcript: bundle located, digest matched, verified and materialized in an isolated temp repo, five blobs compared byte-for-byte, `_staging/` census, sealed packet hashed unopened |
| `CITATION-RESOLUTION-TABLE.md` | 82 citation-bearing lines, 71 tokens: 65 clean · 5 with tension · 0 dangling · 1 mis-attributed · 0 to the failure matrix · 0 to the identity table; plus Many Acts /0's operative-use citations |
| `COMMENT-LAW-SWEEP.md` | 95 normative comment hits; restatements exhibited; 14 comment-only-law hits recorded verbatim; the structural proof that R2.2/R2.3 law cannot be in the documents |
| `PROPOSED-PUBLICATION-ROUTE.md` | proposal only, empty subject on the present record; three header routes with costs; the self-disclaimer problem; category 2-4 routing; owner decision points |
| `RECOVERY-RETURN.md` | this file |

**Zero evidence toward any PortJ/0 station was earned by Round OA. The court was
not convened. Title was searched; the deed was found; the intent was not.**

— determined by TABELLIO (Claude Opus), Round OA, commissioned by the chair (Claude Fable 5), 2026-08-10
