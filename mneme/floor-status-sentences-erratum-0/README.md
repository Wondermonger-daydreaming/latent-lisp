# floor-status-sentences-erratum-0/

**What this directory is:** the **erratum companion** to floor commit
`931be1d1a816369b6701b13b756d4c70d6a4f19e`. It is a record, not a change. It carries the proposal that was
reviewed, the pin census that was taken, the corrected landing procedure, the receipt of the landing as it
actually ran, and the before/after identity of the one file that moved. It repairs no code and adopts no
semantics.

*Assembled by agent PLINTH-III, 2026-09-21, from drafts by PLINTH and PLINTH-II. Reviewed and committed by
the chair. Nothing in this directory is authorization for anything.*

---

## What landed

One commit, one path, prose only.

| | |
|---|---|
| commit | `931be1d1a816369b6701b13b756d4c70d6a4f19e` on lab `main`, first-parent, parent `892605580c5b6e5c709ba95a19b5d0124a444865` |
| path | `experiments/latent-lisp/mneme/verify-release.sh` — the **only** path the commit touched |
| blob | `fb99a6b64c77640b1dd81a8bf39f5673c22856a4` → `8cbc50c772b5225d02caac6df38883bf7dcb437e` |
| diff | 1 file changed, 31 insertions(+), 6 deletions(-) |
| substance | the ML/0 carried status row and its comment block now carry the status stone's **current** standing (ARCHITECTURE-0-STATUS.md ADDENDUM 25 item 6, quoted verbatim) in place of the superseded sentence *"stranger audit owed · no independent verification"*. The superseded sentence is kept as dated, quoted history. `--list` differs by **exactly one line** (`evidence/list-diff.txt`); the enumeration 112 full / 82 ci is unchanged. |
| reviewed by | the ruling office (Astra, GPT-6), review-accepted 2026-09-21, docked at `corpus/voices/received/originals/2026-09-21-183307-astra-side-reply-02-candidate-review-floor-ACCEPTED-demo-HOLD-VERBATIM.md.orig` |
| executed by | the owner (Tomás), by running the prepared script `land-floor-status-sentences-0-r1.sh` |

The full landing receipt — every line the script printed — is `evidence/floor-landing-r1.kYOW4s.log.txt`.
Which of its values were observed at execution, which were read from the store afterwards, and which are
inferred, is set out field by field in `LANDING-RECORD.md`.

## What this does NOT do

The ruling office's exclusions, as relayed, **verbatim**: *no pin changed, no additional semantics adopted,
the remaining ML/0 programme not discharged, no publication authorized.*

Said longer, and each one checkable in `LANDING-RECORD.md` §4:

- **No pin changed.** `warrant-calculus` S15 still pins the **old** identity. That pin is preserved
  **unedited**, exactly where it was, in `experiments/latent-lisp/warrant-calculus/LMP0-clauses-CD-LCI.md`
  (path verified on disk at assembly; it is **not** under `mneme/`),
  as is every file under `experiments/latent-lisp/mneme/release-floor-erratum-0/`. The successor identity is
  recorded **beside** the old one, here, in `evidence/IDENTITY-CAPTURE-successor.txt` — which is what an
  erratum is for. Every other place in the tree that names the old identity is enumerated in `PIN-SITES.md`
  and none of them was touched.
- **No additional semantics adopted.** The change is prose inside a status string. No gate was added,
  removed or altered; no behaviour of `verify-release.sh` changed; the enumeration is byte-for-byte the same
  count.
- **The remaining ML/0 programme is not discharged.** `ml0.lisp:3002` is **UNCORRECTED**, `ml0-3002.patch`
  stays unapplied, **P9 FAIL STANDS IN THE REGISTER**, and the stranger **primitive-minimization** audit
  remains **OWED and uncommissioned**. (The *strict* stranger audit, discharged 2026-09-01, is a different
  thing, and the landed text now separates the two explicitly — that separation is the repair.)
- **No publication authorized.** No ferry, no `sync.sh` by hand, no lifting of the sentinel. The sentinel
  `tools/latent-lisp/SYNC-PAUSED` stayed RAISED throughout and the landing's own transport launch recorded
  **WITHHELD**, bound to this commit id (receipt l.50-54). The public mirror tip
  `3e00b29c183fb9edc578fef0f20a44f63ade9153` did not move. PUBLISHED remains a three-stage word (CLAUDE.md
  §I-j) and every ferry is the owner's launch.

**One consequence, said aloud rather than left implicit:** the changed file lives under
`experiments/latent-lisp/`, the published subject subtree. Landing it does not publish it — but it will be
carried into the next public cargo whenever a ferry is next authorized. That is a future owner-gated act, not
this one.

## The floor commit alone was not the completion of the erratum

The ruling office said so directly, and this directory exists because of it. Astra, verbatim:

> "Prepare the companion after receiving the actual landing transcript; do not treat the floor commit alone
> as completion of the erratum."

Two things follow. First, the **order** is not cosmetic: `LANDING-RECORD.md` and
`evidence/IDENTITY-CAPTURE-successor.txt` are properties of a commit that did not exist until the landing
happened, so they could not honestly be written before it, and this directory is a **second, separate
commit** that cites the first. Second, the erratum is **the record, not the code change**: a pinned object
acquiring a successor identity is only properly errata'd when the old identity, the new identity, the review
that accepted the move, and the receipt of the move all sit in one place that the pin sites can point at.
That place is here.

## What is in this directory

| file | what it is | state |
|---|---|---|
| `README.md` | this file | written at assembly |
| `S15-ERRATUM-0.md` | PLINTH's proposal: the pinned script acquires a successor identity | **carried byte-identical** from `_staging/2026-09-21-commission-02-followup/PLINTH/` |
| `PIN-SITES.md` | PLINTH's read-only census of every place naming the old identity | **carried byte-identical** from the same place |
| `CONSOLIDATION-2026-09-21.md` | PLINTH-II's consolidation: closes the proposal's open points, records the corrected landing method | **carried byte-identical** from `_staging/2026-09-21-review-03-repairs/FLOOR/S15-ERRATUM-0-CONSOLIDATION-2026-09-21.md` |
| `LANDING-RECORD.md` | the landing as executed, field by field, each value sourced | filled from the receipt and the store |
| `evidence/floor-landing-r1.kYOW4s.log.txt` | **the complete landing log**, all 61 lines | byte-identical to the chair's preserved copy (`cmp`, exit 0) |
| `evidence/candidate.diff` | the reviewed change, `git diff 2e0b8d1df^ 2e0b8d1df` | carried byte-identical |
| `evidence/list-diff.txt` | the one-line `--list` difference between the two blobs | carried byte-identical |
| `evidence/IDENTITY-CAPTURE-predecessor.txt` | the old pinned identity | PLINTH-II's capture, one execution field filled |
| `evidence/IDENTITY-CAPTURE-successor.txt` | the new identity | PLINTH-II's capture, execution fields filled |
| `evidence/MEASUREMENT-cherry-pick-and-pre-commit.txt` | the chair's two-scratch-repo measurement that `cherry-pick -x` does not run a refusing pre-commit hook | carried byte-identical |
| `evidence/floor-candidate-2e0b8d1d.transcript.txt` (+ `.meta`) | the full release-floor run on the candidate: **PASS, 112/112, 0 blocked** | carried byte-identical, sha256 verified before carrying |
| `evidence/SHA256SUMS` | manifest over everything else in `evidence/` | generated at assembly |

**The three carried documents were not edited.** They still read *PROPOSED — NOT ADOPTED* in their own
prose, and that is correct: they are evidence of **what was proposed and reviewed**, and altering them to
match the outcome would destroy the thing they are here to witness. What was adopted is the one-file change
recorded above and nothing else.

**One documentary correction is made, and it is made here rather than in the evidence.** Three sentences in
the prepared material state, as a known fact, that Git refuses a partial commit while `CHERRY_PICK_HEAD`
exists. Nobody in this dossier checked that, and neither the receipt nor the script's own tests bear on it.
`LANDING-RECORD.md` §0b names all three sites, states exactly what was and was not observed, and rests the
procedure on the index verification that *was* performed instead. The evidence files keep their original
words.

## Status at the time of writing

- **Nothing is pushed.** `origin/main` is `892605580c5b6e5c709ba95a19b5d0124a444865`; local `main` is ahead
  by the landing commit and one front-door addendum. Nothing goes to `origin` until this companion's own
  transport result has been returned.
- **This companion's commit id:** `RECORDED-BY-THE-CHAIR-AFTER-COMMIT`
- **This companion's own transport result:** `RECORDED-BY-THE-CHAIR-AFTER-COMMIT`

*(Those two are left as tokens on purpose. A commit cannot record its own id, and a transport result that has
not been observed cannot be written down. The chair fills both after the commit lands, from the store and
from `tools/latent-lisp/.sync.log`.)*
