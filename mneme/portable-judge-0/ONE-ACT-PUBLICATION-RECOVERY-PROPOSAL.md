# ONE ACT /0 PUBLICATION-RECOVERY PARCEL — PROPOSED CONTENTS

**Prepared by the chair (Claude Fable 5), 2026-08-10, per OWNER-RULINGS-1 Ruling 4 /
Next-action item 4.** This is the *proposal* for the bounded recovery parcel — not the
parcel. Nothing has been moved, promoted, or edited. Per the ruling: only category 1
may eventually be promoted as publication recovery without a new semantic adoption;
categories 2–4 require an owner-reviewed candidate round; nothing moves silently.

## 0. The subject

Five tracked documents at repo root, outside the mirrored subtree:

```
_staging/oneact-candidate/ONE-ACT-0-CONTRACT-CANDIDATE.md
_staging/oneact-candidate/ONE-ACT-0-FAILURE-MATRIX.md
_staging/oneact-candidate/ONE-ACT-0-IDENTITY-TABLE.md
_staging/oneact-candidate/ONE-ACT-0-SPECIMEN.md
_staging/oneact-candidate/ONE-ACT-0-TEST-PLAN.md
```

The publication gap (SD-13): `language-act-0/` in the published tree carries sources +
adoption record + closure transcript only; `package.lisp` cites "contract §…"
throughout; the mirror publishes `experiments/latent-lisp/` and excludes `_staging/`
— so the adopted lane's prose law is invisible to any outside reader, including a
future clean-room implementer.

## 1. Preliminary chair-verified facts (this session; commands shown; the parcel re-establishes them formally)

- **P-1. All five documents are IN the adopted candidate tree.**
  `git ls-tree -r 461f2013 --name-only | grep oneact-candidate` → all five paths
  present. (`461f2013` = the adopted candidate commit per
  `ADOPTION-RECORD-2026-08-08.md`; merged into main **unmodified**.)
- **P-2. Zero post-adoption drift.**
  `git diff --stat 461f2013 HEAD -- _staging/oneact-candidate/` → empty. The working
  copies are byte-identical to the adopted tree's.
- **P-3. Real construction history, not reconstruction.** `git log --follow` on the
  contract shows it riding the One Act rounds (R1 repair `0f59cb8b`, R2 documentary
  repair `3c4e704d`, implementation round `5ea01c9d` — vector re-freezes, erratum
  incorporation), i.e. these are the documents the campaign actually reviewed and
  amended through its owner-ruled rounds.

**Prima facie reading (to be confirmed, not assumed):** category **1 —
adopted-but-failed-to-publish.** The adoption bundled and merged the whole candidate
tree; these paths were in it; the "failure to publish" is a *location* accident
(`_staging/` at repo root, outside the mirrored subtree), not a review gap. The parcel
exists to prove or break this reading clause-by-clause, not to assert it.

## 2. Ruling 4's five determinations → the checks that decide them

| Determination | Deciding check |
|---|---|
| Byte-identical to documents reviewed during adoption? | Extract closure bundle `598c0cfc…` into a fresh empty repo (`git bundle verify` + materialize, repeating the closure transcript's own method); `git ls-tree -r` the materialized candidate tree; per-file sha256 vs working copies. Expected from P-1/P-2: identical — but the bundle is the adoption-time object, so it, not HEAD ancestry, is the formal witness |
| Does the adoption record cite or hash them? | Textual audit of `ADOPTION-RECORD-2026-08-08.md` + `CLOSURE-TRANSCRIPT-2026-08-08.txt`. Known: the record hashes the **bundle** (`598c0cfc…`) and the candidate **tree** (`1123c3c3`) — i.e. the docs are hashed *by tree membership*, not cited per-file. The parcel states this precisely: covered by the adopted tree hash; never individually named. Whether tree-membership citation satisfies "cites or hashes" is an **owner call** the parcel poses, not answers |
| Do their clauses correspond to the adopted implementation and gates? | Enumerate every `contract §N` citation in `language-act-0/*.lisp` (+ the R1-era MA0 docs that cite One Act law, if any); resolve each against the contract text; run the adopted lane's own checks (`act0-selftest` 173-expansion, gates, load witnesses) unmodified as the behavioral cross-reference. Output: a citation-resolution table — resolves cleanly / resolves with tension / dangling |
| Later amendments? | `git log --follow -p` per document from the freeze ref (`oneact/candidate-freeze-2026-08-07`) to HEAD. Expected from P-2: none post-adoption; every pre-adoption amendment listed with its owner-ruling provenance (R1/R2/R2.1 commits) |
| Normative content only in source comments? | Sweep of `act0.lisp` / `package.lisp` / `act0-gates.lisp` comment blocks for normative sentences (MUST/never/law/rule/governing) absent from the five documents; each hit classified: restatement (harmless) / **comment-only law (category 4 candidate — new proposed law, never publication recovery)** |

## 3. Proposed parcel contents (deliverables)

1. `RECOVERY-DETERMINATION.md` — the five determinations answered with evidence
   inline (commands + outputs), and a **per-document, per-category classification
   table** (1 adopted-unpublished / 2 reviewed-candidate / 3 post-adoption
   reconstruction / 4 new proposed law). Mixed classifications allowed at clause
   granularity — one document may be category 1 with two category-4 clauses; the
   table says which.
2. `BUNDLE-REMATERIALIZATION-TRANSCRIPT.txt` — the closure-bundle extraction and
   per-file sha256 comparison, verbatim.
3. `CITATION-RESOLUTION-TABLE.md` — every source-side `contract §` citation and its
   resolution status.
4. `COMMENT-LAW-SWEEP.md` — the category-4 candidate list (possibly empty; the search
   shown either way).
5. `PROPOSED-PUBLICATION-ROUTE.md` — **proposal only**, for whatever lands in
   category 1: byte-identical copies into
   `experiments/latent-lisp/mneme/language-act-0/` via an owner-ratified commit
   labelled *publication recovery — no semantic adoption*, each file carrying a
   provenance header (adopted tree `1123c3c3`, bundle `598c0cfc…`, original path,
   sha256), originals left in place under `_staging/` untouched. Categories 2–4
   routed to their own owner-reviewed candidate round, explicitly out of recovery
   scope.
6. `RECOVERY-RETURN.md` — bounded return; no promotion performed.

## 4. Execution notes

- **Read-only over adopted history**; parallel-safe with the R1 audit (Round OA in
  the revision plan) — it touches neither the MA0 lane nor any candidate coordinate.
- One Opus hand (suggested character: a title-searcher — someone who proves chain of
  custody and refuses to notarize what the chain doesn't show) + chair verification
  of every load-bearing hash.
- The stranger packet (`oneact-0-stranger-packet-2026-08-08.tar.gz`, sha
  `05731799…`) stays **SEALED** — the recovery parcel has no need to open it, and
  must not; its dormant status is part of the adoption record's variance.
- PortJ-F/0 linkage: this parcel *settles the publication route* (S-freeze
  precondition ③) but does not by itself make the predecessor stack's law "publicly
  sufficient" — that judgment waits on the parcel's citation-resolution results and
  the owner's reading of them.

— Claude Fable 5, chair, 2026-08-10
