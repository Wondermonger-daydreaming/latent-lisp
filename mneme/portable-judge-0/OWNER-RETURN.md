# PORTABLE JUDGE /0 — OWNER RETURN (candidate parcel)

**CANDIDATE PARCEL — not an adoption declaration.** Date: 2026-08-10.
Chair: Claude Fable 5. Drafting crew: CHARTIST · LEGIST · NOTARIUS · CENSITOR
(all Claude Opus, all construction-loop — none eligible as J2 implementer).

**NAMING COLLISION (governing note):** the bare token "PJ0" remains reserved for the
ADOPTED Process Journal /0 (`mneme/architecture/process-journal-0/PJ0-ADOPTION-RECORD.md`,
sealed 2026-07-18). This campaign is **Portable Judge /0**, directory `portable-judge-0/`.
Final designation is the owner's to ratify (decision queue, item 1).

---

## 1. Phase-0 cold state audit (chair-executed, observed not inferred)

| Question | Answer |
|---|---|
| `54aa7783…` full identity | **sha256 of the R1 return-parcel tarball** `~/Downloads/many-acts-0-r1-return-parcel-2026-08-10.tar.gz` (268,130 B) — **NOT a git object** (`git log 54aa7783` → unknown revision; verified) |
| Its status | **Returned candidate, sealed parcel, AWAITING OWNER DISPOSITION** — not adopted, not merged, not published, not receipt-sealed |
| R1 patch base commit | `76952ea4f278d269f98f158555e412a095a3da6f` · tree `ea60fc7e1561877ede2311c29385ef5dcd912fc7` · parent `f83a06899bc82a7217b070bb27f53a352d37a9a8` (subject trees identical `f1e5e587…`, per R1 ruling §1) |
| R1 freeze | lane subtree `e94870bd9091e67f68e9cf238a6c5d0dcf302a05`, freeze-record commit `9bff7d02` |
| Branch | `many-acts-0-candidate`; **not** an ancestor of `main`; HEAD at campaign open `b358c52e` |
| Working tree | clean of modifications; 22 preserved untracked paths (`_staging/*`, one assessment, one memory backup) — **untouched** |
| Authoritative ADOPTED base | **One Act /0** (`language-act-0/ADOPTION-RECORD-2026-08-08.md`) is the last owner-adopted station. Many Acts /0 and its R1 repair are **candidates only**; every artifact in this parcel is labelled as prepared against a candidate base |

Commands: `git log --format='%H %T %P' -n1 <ref>` · `git branch -a --contains` ·
`git merge-base --is-ancestor` · `git status --porcelain` · `grep -rn 54aa7783` ·
`git ls-files` (per-claim commands are shown inside each artifact; counts in
VECTOR-CLASSIFICATION carry their grep invocations verbatim).

## 2. Files created (this parcel; nothing existing modified, nothing merged/published)

Charter (mneme root):
- `LANGUAGEHOOD-AND-SUCCESSION-CHARTER-0-CANDIDATE.md` — five stations
  (L0 · IH0 · Portable-Judge · OG0 · LM0), non-substitutability, per-station
  licensed/forbidden sentences, Article 14 registered tensions T1–T7

`portable-judge-0/`:
- `PROTOCOL-CANDIDATE.md` — center claim, two-layer scoping + Act Oracle Interface,
  observable boundary, clean-room provenance, pass conditions, §13 deficit seed
- `ADJUDICATION-CANDIDATE.md` — J1/J2 envelope comparison harness; comparator
  teeth-checks (planted divergences per distinguished category)
- `FAILURE-TAXONOMY-CANDIDATE.md` — five pre-registered verdict classes
  (port defect / underdetermination / oracle contamination / constitutional
  regression / reference defect) + adjudication procedure
- `CLEAN-ROOM-IMPLEMENTER-BRIEF-CANDIDATE.md` — the J2 charge, incl. the public-mirror
  contamination hazard and non-consultation attestation
- `NORMATIVE-OBSERVATION-FORMAT-0-CANDIDATE.md` — tagged-JSON transport ("plumbing,
  not jurisdiction"); value domain verified against the law: **string · integer ·
  keyword · ordered sequence** (unit/booleans/rationals/bytes/segmented-ids/records
  ABSENT at /0 — reserved, non-conformant to emit); hex-of-UTF-8 subject text;
  hashed observation core vs excluded attestation; 16 planted-divergence categories
- `SPEC-DEFICIT-REGISTER-CANDIDATE.md` — **28 deficits** (SD-01…SD-28; LEGIST's 12
  absorbed, 16 added); cure classes A-18/B-8/C-2; severities S1-7/S2-11/S3-10
- `VECTOR-CLASSIFICATION-CANDIDATE.md` — 7-way classification, all counts static
  with commands shown
- `PUBLIC-SEED-MANIFEST-CANDIDATE.txt` — per-file sha256+bytes; MANIFEST-HASH
  `3eab4cef…f4f9` (explicitly of an INCOMPLETE body — two placeholders TBD-at-freeze;
  freeze mints the real packet only at owner ratification)
- `HOLDOUT-COMMITMENT-CANDIDATE.txt` — commitment scheme only; **no hidden vectors
  exist yet**; authoring is post-ratification; custody off-mirror, out-of-band
- `OG0-SKETCH-CANDIDATE.md` · `LM0-PREREGISTRATION-SKELETON-CANDIDATE.md` — outlines
  only, not executable; P5 recorded as first bounded inhabitation specimen, never
  open-endedness
- `OWNER-RETURN.md` — this file

## 3. Classification counts (static; NOTHING EXECUTED this session)

- Many Acts /0 suite derives to **exactly 200** (39 validator + 2 footprint + 11
  immutable + 35 R1 floor + 23 grep gates + 90 scenarios) — independently corroborates
  the parcel seal's 200/0 **by static derivation, not by run**.
- Teeth derive to **15 sections**; concordance 7 arms × 18 facets = **126**; One Act
  88 static sites expanding to the authorized 173.
- **Portable-bank candidate: 149 checks** (from gross 188: cat-1 141 + cat-3 25 +
  holdout 22, minus 39 hard-blocked for oracle contamination), **+ 6 disease
  obligations + 1 metamorphic obligation**. Rider: **none of the 149 is scorable
  today** — all are stdout line-matches on CL-printed values; re-expression in the
  observation format is a post-ratification build task.
- **The commission's quoted bank numbers (38 · 12 · 9 · 110 · 8/8 · 14/10/8/12 ·
  13/13) belong to a different, already-adopted lane** — they appear as a block in
  `language-surface-account-0/ADOPTION-RECEIPT-2026-08-06.md` (chair-spot-checked).
  No Many Acts /0 or One Act /0 bank corresponds; MA0's disease bank is 5 diseases /
  6 pairs; One Act's loader witnesses are 6 cases; "battery 13/13" unmatched in these
  lanes — unverified for this campaign.

## 4. The findings that shape the campaign (each chair-verified or marked)

1. **SD-13 — One Act /0 has NO public specification in the published tree**
   (chair-confirmed: `git ls-files language-act-0/` shows sources + adoption record
   only; the contract/failure-matrix/identity-table live in `_staging/oneact-candidate/`
   at repo root, outside the mirrored subtree; `package.lisp` cites "contract §…"
   throughout). Consequence: the Act Oracle Interface is **forced by a publication
   gap**, not merely chosen; and J2's law for the act layer does not publicly exist.
2. **Act Oracle Interface (PROTOCOL §3)** — J2 consumes a frozen canonical act
   transcript; portability is claimed for the **language layer only**. This narrows
   the commissioned center claim; stated openly as an owner fork.
3. **SD-8/SD-14 — datum ingestion is unwritten CL `read`**, and its sharpest edge is
   not exotic: source `:unexpected` vs observable `UNEXPECTED` (verified in
   `p5/p5-FIRST-RUN.txt`) — a case-sensitive J2 coin-flips on **every**
   program-authored refusal code. Predicted class-2 (underdetermination) site.
4. **Public law defects found while drafting** (lane-doc repairs, owner-gated, left
   untouched): AUTHOR-GUIDE §10.9 says concordance teeth "have not been built" while
   R1 reports 126 facets/0 divergences; CONTRACT §6 export list disagrees with
   `package.lisp` (omits `ma0-environment-stale`, `-store-id`); teeth header says
   "159" (now 200); concordance header says "4 arms/72 facets" (now 7/126);
   F-GUIDE-2 (continuation-rule sentence missing from guide) re-registered from the
   P5 protocol file; `V-ATOMS` named in GRAMMAR §2 with no observable code.
5. **Sharpest oracle-contamination suspects in the existing banks**: identifier case
   (readtable up-casing presented by the guide as designed law); 4 scenario oracles
   that are package-qualified CL condition class names; ~40 expectations on printed
   CL forms; substrate magnitudes with no public derivation (prefix-frames 8/21/22,
   store-id-length 74).
6. **Charter tensions T1–T7** (Article 14), notably: T2 — Sol authored the adopted
   Process Journal /0 packet, so Sol is a construction participant in the
   architecture lane itself (permanent J2/stranger ineligibility, grounded in the
   adopted record); T4 — OG0 requires outsider authors, so the ladder's order is not
   its implication order.
7. **Hidden-bank do-not-author list**: "support"/"unsupported-support"/"fabricated
   evidence" and "inaccessible support" are **not laws of this lane**; rationals are
   refused; bignums ARE in the law. Vectors for non-laws would convict a correct J2.

## 5. What has and has not been earned (claim state, unchanged by this parcel)

EARNED (standing per prior records; this parcel adds NO evidence): L0 languagehood at
mixed standing (adopted One Act /0 + Surface Account /0; strongest witnesses ride the
un-adopted MA0/R1 candidate — charter T5 carries the contraction rule); P5 at exactly
the owner's governing sentence (cross-substrate semantic agreement, non-implementation
author, disclosed exposure — NOT stranger inhabitation, NOT guide-only transmission).

NOT EARNED (and not advanced one inch by this parcel): independent implementation ·
portable conformance · stranger inhabitation at IH0's own name · disease-conserving
generativity · any comparative latent-machine authorship claim. **This parcel is
court-construction only.** No vectors were run; no judge exists but J1; nothing here
is "verified" beyond the per-claim commands shown.

## 6. Decision queue for the owner (each genuinely forks the campaign)

1. **Designation** — ratify "Portable Judge /0" (and its short form) vs rename;
   bare "PJ0" collision with the adopted Process Journal /0 is structural (R-PJ-3 is
   itself an independence gate of similar shape).
2. **R1 disposition** — everything here is drafted against the R1 candidate base;
   adoption/decline changes what the frozen seed can contain.
3. **Act Oracle Interface** — amend the center claim to language-layer portability,
   or demand full-stack portability (which requires resolving item 4 first).
4. **One Act /0 public law (SD-13)** — promote the `_staging/oneact-candidate/` law
   docs into the published tree (lane edit, owner-gated), or accept the act layer as
   permanently oracle-mediated for J2.
5. **Lane-doc repair round** — SD-5/SD-6/staleness/F-GUIDE-2 (finding 4 above);
   owner-gated like all lane edits.
6. **Identifier-case ruling** — is case-insensitive matching designed law or
   readtable artifact? This one ruling reclassifies dozens of vectors.
7. **Hidden-bank authoring authorization** — post-ratification step; scheme in
   HOLDOUT-COMMITMENT-CANDIDATE.txt.

## 7. Exact next instruction for a clean-room J2 implementer

**None may be issued yet.** The brief exists (`CLEAN-ROOM-IMPLEMENTER-BRIEF-CANDIDATE.md`)
but is issuable only after: owner ratification of base + designation (queue 1–3) →
deficit cures or explicit non-normative rulings for the S1 deficits → packet freeze
with real MANIFEST-HASH → holdout commitment published. Issuing it today would hand a
fresh mind a packet whose own register proves it insufficient — the campaign's honest
current answer to "can a clean-room implementer build J2 from the public law?" is:
**not yet, and now we know precisely where not, in 28 registered places.**

## 8. Candidate commit

This file rides in the candidate commit on `many-acts-0-candidate`; the commit SHA and
tree are readable from `git log` and are reported in the chair's session report (a file
cannot contain its own commit's hash). Nothing merged to main; nothing published to the
mirror (main-ancestry guard); no adoption claimed.

— Claude Fable 5, chair, 2026-08-10
