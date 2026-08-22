# CHANNEL TOOLING REPAIR /2 — SCOPE EXTENSION 2 (Q3-F2, 2026-08-18)

**Owner scope decision (interview fork, this sitting). Extends TR/2 once more, exactly
this far: cure Q3-F2 and sweep `sync.sh`'s `if ! git` idiom under requirement-4
semantics, RED-proven, before the successor parcel seals. `transport-record.sh` is NOT
in scope — it is a NAMED FUTURE LANE for the cold seat and the owner (117 KB, sole
writer of custody evidence, unexamined by any hand in three rounds; QUAESTOR round 3
named it as standing furniture-blindness).**

## The finding (QUAESTOR round 3, `_staging/tr2-quaestor-round3.md`)

**Q3-F2 (MEDIUM):** the SOL-TR2-01 class — failed observation converted into
affirmative classification — lives one layer below the hooks. `sync.sh` runs
`set -euo pipefail`, so most unchecked git calls abort safely; but the `if ! git …`
idiom is exempt from `set -e`, and QUAESTOR demonstrated a `git merge-base` erroring
(exit 129) writing `"reason":"main-only guard: … is not reachable from lab main"`
into the **durable record** for a commit that WAS reachable — fails safe for
publication, **writes a false reason into custody evidence** (lines 256/262/308 at
the time of measurement).

## The owner's disposition (verbatim option)

> **Extend TR/2 + cure, then seal** — SCOPE EXTENSION 2: cure Q3-F2 + a bounded sweep
> of sync.sh's `if ! git` idiom under requirement-4 semantics (truthful failure
> reasons in the record, never invented ones), RED-proven teeth, builder round 4 +
> QUAESTOR re-check, THEN seal. transport-record.sh stays a named future lane for the
> cold seat. Costs one more round; avoids shipping a known class member to the
> stranger who hunts this class.

## Extended scope — exactly this, no more

- `tools/latent-lisp/sync.sh` may be modified solely so that **a git query's failure
  is never spoken as a determinate classification**: every `if ! git …` (and any
  equivalent set-e-exempt guard) whose failure currently produces a definite reason
  string must distinguish QUERY-FAILED from QUERY-SAYS-NO, recording the failure as
  itself (exit code + which query) with requirement-4 semantics — fail-safe direction
  for publication preserved (a failed query still withholds transport), truthful
  reason in the record.
- RED-proven teeth reproducing QUAESTOR's Q3-F2 demonstration (merge-base error →
  false reason) and covering the swept idiom instances.
- Round-4 hygiene items, builder's: correct the `|| exit 0` floors' false declaration
  (Q3-F3 — the "nowhere to write" justification is false as stated; declare the true
  grounds or cure); document Q3-F1's healthy-path log delta (sha prefix 8→12) as
  deliberate, in the report and the file comment.
- Everything else carried unchanged: both commissions + extension 1 + successor-1
  commission caps; accepted suite byte-untouched and 680/0; teeth grow only;
  candidate standing; new cold seat before any acceptance; TD-10/TD-11 OPEN and
  blocking throughout; SOL-TR2-02 parcel recipe unchanged (chair's).

## Chain

QUAESTOR round 3 (SEALABLE verdict + Q3-F1/F2/F3) → owner interview fork → this
extension. No predecessor document is rewritten.

*— recorded by the chair, Claude Fable 5 (1M context), 2026-08-18, at the owner's word.*
