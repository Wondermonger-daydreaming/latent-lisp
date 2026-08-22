# CHANNEL TOOLING REPAIR /2 — SCOPE EXTENSION 1 (TD-11, 2026-08-17)

**Owner scope decision, per the TR/2 commission's own cap ("this blocking repair may
not be silently enlarged — any scope growth requires a separate owner scope
decision"). This instrument IS that decision, and only for what it names.**

## The finding that occasioned it

QUAESTOR round 1 (`_staging/tr2-quaestor-round1.md`), CONFIRMED HIGH: merges on
`main` completed by `git commit` (conflicted merges; `--no-commit`) bypass the
post-merge hook entirely (git fires `post-merge` only for merges concluded by
`git-merge`), and `post-commit.sh`'s `git diff-tree` lacks `-m`, leaving it
structurally blind to merge commits — governed content can land main-ancestral with
zero machinery events. Pre-existing code, byte-identical across the TR/2 candidate.

## The owner's disposition (interview fork, verbatim option)

> **Docket TD-11 + extend TR/2** — Docket as TD-11 (owner-named or
> chair-drafted-for-your-approval), and extend the TR/2 commission to cure it in the
> same candidate — post-commit.sh gains merge-commit awareness (`-m` + range logic or
> equivalent), with its own RED-proven teeth — so ONE cold seat reviews one coherent
> gate repair. TD-11 joins TD-10 in blocking sentinel lift.

## Extended scope — exactly this, no more

- `tools/latent-lisp/post-commit.sh` may now be modified, solely to make merge
  commits observable at the commit path: merge-commit awareness (`-m` on the
  diff-tree, or range logic against the merge's parents, or equivalent — builder's
  design, defended in writing), preserving the hook's exit-0 contract, recursion
  guard, thin-delegator architecture, and the successor-9 authority doctrine.
- RED-proven teeth for the TD-11 shapes: a conflicted merge resolved by `git commit`
  with governed content; a `--no-commit` merge committed later; squash-commit
  interaction with the round-2 squash state; ordinary non-merge commits as controls.
  All in disposable harnesses; teeth-td6-td9.sh stays byte-untouched; accepted suite
  must re-run 680/0 (TOOTH-TD-8's byte-assertions on post-commit.sh, if any bite,
  are handled as in round 1: adapt the subject to the tooth or show the tooth's
  expectation is versioned by design — never weaken the accepted suite).
- Everything else in the TR/2 commission carries unchanged: the ten evidence items,
  all caps (no live merge, no sentinel change, no mirror contact, no TD-6/TD-9
  action, no lab_state/legacy-custody ground, no commits by builders), sealed
  candidate for a NEW cold seat, candidate standing only.
- **TD-11 blocking effect immediate:** `SYNC-PAUSED` removal, public-mirror
  transport execution, and reliance on post-merge automatic transport are blocked by
  TD-11 as by TD-10, until each is closed by its own owner act.

## Provenance

TR/2 commission (`7086947a`) → FERRARIUS round 1 candidate (`5a70031b`) → QUAESTOR
round 1 (four CONFIRMED findings; three in-scope cures already commissioned to the
builder; this HIGH pre-existing finding put to the owner) → owner's interview fork →
this extension + docket TD-11 entry (same commit). No predecessor document is
rewritten.

*— recorded by the chair, Claude Fable 5 (1M context), 2026-08-17, at the owner's word.*
