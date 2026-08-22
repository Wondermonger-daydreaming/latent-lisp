# CHANNEL TOOLING REPAIR /2 — SUCCESSOR-1 COMMISSION (2026-08-17, after the first cold seat)

**The TR/2 candidate is BLOCKED by the cold seat's first disposition (SOL-TR2-01,
SOL-TR2-02; archived verbatim:
`corpus/voices/received/2026-08-17-sol-tr2-first-disposition-blocked.md`). NOT
ACCEPTABLE FOR OWNER ACCEPTANCE. No TD closes. Credit stands where the disposition
grants it (parcel authentication 18/18; 195/0 independently reproduced; the TD-10
post-merge repair survived every examined case) — and credit is not acceptance. This
commission binds the successor to the disposition's six requirements plus the parcel
cure.**

## What the cold seat proved (the shape of the miss)

Three same-root hands — builder, adversary, chair — cured exit-status discard in
`post-merge.sh` (round 2's `NET_RC` handling) while leaving the SAME defect-class
alive in `post-commit.sh`'s new merge path, then verified each other clean. Sol's
plants: (1) a shimmed `diff-tree` exit 77 on a real two-parent merge → the hook wrote
a **false** `NO-TRANSPORT-DUE … (the merge WAS examined, not skipped)` — a failed
observation converted into an affirmative empty observation, the exact
silent-classification family TD-10/TD-11 exists to abolish; (2) a failed parent
census → `NPAR=-1` → the merge fell through the ordinary non-merge gate, zero log,
zero launch — TD-11's original invisibility, recreated inside its own cure. QUAESTOR's
"both defensive branches tested" was true of the two branches he tested and did not
cover these two. Same-root verification measured the same blindness three times.

## Successor requirements (the disposition's six, verbatim, binding)

> 1. Preserve and examine the exit status of the parent census.
> 2. Preserve and examine the exit status of the merge-commit tree comparison.
> 3. Parent-census failure must not fall through as an ordinary commit.
> 4. Comparison failure must never produce `NO-TRANSPORT-DUE`. When the fixed 40-hex
>    merge subject is known, conservatively launch it with explicit failure
>    provenance; otherwise record an explicit no-decision/human-required state.
> 5. Add RED-proven teeth for both exact plants.
> 6. Re-run the TR/2 suite and the accepted 680/0 regression suite without weakening
>    either.

Item 5 means the teeth reproduce **Sol's exact plants** (PATH shim on the specific
`diff-tree` call → exit 77 on a real two-parent merge; forced failure of
`git rev-list --parents -n 1 HEAD`), each shown RED against the blocked candidate's
behavior before GREEN against the cure.

## SOL-TR2-02 cure (parcel; chair's sealing recipe, specified here so the cold seat can judge it)

The successor parcel's commit bundle must **verify in an EMPTY repository** (the
disposition's test). A full-history lab bundle is disproportionate (~705 MiB object
store), so the successor parcel carries a **self-rooted filtered-history repository**:
the candidate lineage exported with history limited to the subject paths
(`tools/latent-lisp/` and the TR/2 instruments), rooted in the parcel itself, zero
prerequisites, bundled whole — plus a **lab→parcel commit mapping table**, stated as
what it is: the parcel materializes the subject-tree evolution byte-exactly under
synthetic commit ids; the lab repository remains the sole authority for full-tree
commit identity. Cold verification recipe (empty repo → `git clone <bundle>` →
byte-compare subject files against the parcel's flat copies) ships in the parcel and
is WALKED before sealing, in an empty directory, by the chair — with the walk's
transcript included.

## Carried unchanged

The TR/2 commission + SCOPE EXTENSION 1 in full: all caps (no live merge, no sentinel
change — sha `9b741ed1ac721dca…` start and end, no mirror contact, no TD-6/TD-9
action, no lab_state/legacy-custody ground, builders commit nothing); accepted
`teeth-td6-td9.sh` byte-untouched and re-run 680/0; teeth-td10.sh grows, never
shrinks; candidate standing only; a NEW cold-seat pass on the successor parcel before
any owner acceptance; TD-10 and TD-11 OPEN and blocking sentinel lift, transport
execution, and auto-transport reliance throughout.

## Chain

TR/2 return `9e0dde0b`/`ecc0c5d7` → parcel `a9adbb59…` → cold seat 1 → **BLOCKED**
(SOL-TR2-01/02) → this successor commission. No predecessor document is rewritten.

*— recorded by the chair, Claude Fable 5 (1M context), 2026-08-17 ~23:50Z.*
