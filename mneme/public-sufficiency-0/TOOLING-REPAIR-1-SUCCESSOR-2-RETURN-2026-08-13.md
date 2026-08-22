# CHANNEL TOOLING REPAIR /1 — SUCCESSOR-2 RETURN (2026-08-13)

**Terminal status, exactly as the second cold-seat disposition holds it:**

> **TR/1 SUCCESSOR-2 RETURNED — NOT OWNER-ACCEPTED ·
> NO TD CLOSED · MERGE GATE CLOSED · NO TD-6 OR TD-9 LIVE ACTION.**

Predecessor: the repaired TR/1 successor (integration `cbdf0464`),
BLOCKED by Sol's second cold seat (SOL-TR1-03, archived verbatim:
`corpus/voices/received/2026-08-13-sol-tr1-second-block-marker-clearing.md`).
This successor-2 answers that BLOCK under the standing commission (the
disposition's own ruling: a bounded implementation repair, no new owner
policy choice required).

## SOL-TR1-03 — source-keyed marker clearing: REPAIRED

The conceded defect: `clear_evidence_markers(repo, C)` keyed by source
commit alone — a later successful WITHHELD (run B) erased run A's
unresolved evidence gap on the same commit, and the teeth had encoded
that as the expected oracle, so **199/0 certified the wrong behavior**.
The collapsed distinction, now load-bearing in code and output:
**THE GAP BELONGS TO THE RUN, NOT TO THE COMMIT** (source identity ≠
transport-run identity; a later event concerning the same object cannot
replace a missing earlier event).

Per Sol's five requirements:

1. **Ordinary append clears nothing.** `clear_evidence_markers()` is
   DELETED — a tombstone stands where it stood.
2. **Minimal safe default:** every marker is retained; `verify` stays RED
   (exit 5) until each gap is explicitly reconciled.
3. **Explicit reconciliation, run-keyed:**
   `transport-record.sh reconcile --run-id <id>` replays that run's
   EXACT preserved record from an untruncated sidecar (the builder
   caught that the marker's embedded copy truncates at 400 bytes and
   would have replayed an approximation), flags it `reconciled:true` +
   `reconciled_at` while preserving the ORIGINAL `utc_time` (history
   never falsified as contemporaneous), confirms the chain landing,
   removes ONLY that marker. One at a time. Reconciliation shares
   `persist_record()` with append, so the SOL-TR1-01 class applies to it
   through the same code: replay failure → exit 6, marker retained;
   exact bytes unavailable → exit 7, refuses to guess.
4. **Teeth for every ordered case** — different-event/same-source and
   same-event/different-run both prove the marker SURVIVES (RED, run A
   still named); multiple independent gaps on one commit counted
   exactly; one-at-a-time reconciliation reaches GREEN only when the
   LAST gap closes; reconcile-under-plant keeps the marker, nonzero.
5. **The wrong oracle corrected and inventoried:** six round-3
   assertions inverted or deleted (worst: a block whose reason string
   read "gap closed by a later successful append"), old→new inventory in
   the builder report, the round-3 transcript left unrewritten as
   evidence of what had been certified. Recounted after editing. A
   doc-layer grep found zero fossils of the dead doctrine.

## The adversarial hand (round 4) and the hardening (round 5)

QUAESTOR re-planted Sol's exact scenario by hand (real supervisor path,
both variants), confirmed the cure, and probed reconcile adversarially:
nonexistent run-id inert · traversal run-id finds nothing · double
reconcile idempotent, no double entry · deleted/invalid sidecar → exit 7,
marker retained · flipping `reconciled:true→false` makes the preserved
original time trip the clock check (tampering is self-defeating).
Its one finding — a consistently-tampered sidecar replayed faithfully —
was **shipped as a repair, not a residual** (two documented residuals
have already returned as BLOCKs): reconcile now cross-checks the
sidecar's `run_id`/`source_commit`/`event` against the marker's own
untruncated front-of-file scalars (cut before the embedded copy so it
cannot masquerade as the second witness); any disagreement → exit 7,
both witnesses' values named, no adjudication of which is lying. Teeth
both directions, each tampered sidecar first asserted still-valid JSON
so the tooth tests the cross-check, not the JSON validator.

**Honest bound, stated plainly:** the cross-check witnesses three
fields; `reason`, `exit_code`, `attempted_ref`, `subject_subtree`,
`utc_time` remain unwitnessed. It raises forgery cost from one edit to
two consistent edits. **It is not a signature** — an exterior
cryptographic anchor remains out of scope (the TD-9 fork's remote is the
nearest instrument).

## Teeth — final count

**273 assertions / 0 failures** — progression 103 → 126 → 131 → 199 →
247 → 273; final run by the chair's own hand; the builder ran the final
tree twice; the verifier ran round-4's tree cold and hand-replanted
beyond the suite. Standing methodological caveat, the builder's own
words carried forward: it has twice shipped a suite certifying a defect
it had itself described, and no process change here prevents a third —
**a green suite is only as good as its oracle; the serial cold stranger
remains the only instrument that has caught every oracle error so far.**

## TD-by-TD standing (unchanged — no premature closure)

TD-6 OPEN (approved in principle only; sharpened invariant; no live
action) · TD-7 OPEN (repair candidate incl. EVIDENCE-FAILED +
reconciliation layers; first real-transport evidence UNREACHED) · TD-8
OPEN (repair candidate; delegators byte-unchanged since round 1's
install, `--verify` GREEN) · TD-9 OPEN (**IMPLEMENTATION-CANDIDATE /
OFF-HOST DURABILITY UNREACHED**; owner fork returned, unexecuted).
Mirror unmoved throughout (`pushed_at 2026-08-10T19:36:16Z`, tip
`3101fcee`). Accepted policy blob `180734f6…c7054` untouched. All
predecessor voids stand.

*— chair, 2026-08-13, deep night again. Five builder rounds, four
adversarial rounds, two Sol cold seats, one chair residual close-out:
the machinery now refuses every false green either seat could construct
— and the next false green, if it comes, will come from a class nobody
at this table has imagined, which is why the stranger audit stays OWED.*
