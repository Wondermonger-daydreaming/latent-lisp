# CHANNEL TOOLING REPAIR /1 — SUCCESSOR-3 RETURN (2026-08-13)

**Terminal status:**

> **TR/1 SUCCESSOR-3 RETURNED — NOT OWNER-ACCEPTED ·
> NO TD CLOSED · MERGE GATE CLOSED · NO TD-6 OR TD-9 LIVE ACTION.**

Predecessor: successor-2 (`0a40c4e3`), BLOCKED by Sol's third cold seat
(SOL-TR1-04/05/06, verbatim:
`corpus/voices/received/2026-08-13-sol-tr1-third-block-run-identity-custody.md`).
Bounded repair under the standing commission, per the disposition's own
terms. The seat confirmed SOL-TR1-03 itself CURED before blocking on the
next layer.

## The cures (builder round 6; adversarially verified round 5; round 7 close-out)

**SOL-TR1-04 — run identity is now EXACT OR REFUSED.** Lossy
sanitization deleted: out-of-alphabet run-ids are refused loudly (`a/b`
can never alias onto `a_b`); absent ids get a UNIQUE generated id (no
shared `norun`); ids are generated and asserted at the source
(supervisor/sync). Custody is claimed atomically with noclobber: a
same-id second failure gets its own `<id>.collision-<utc>-<pid>` custody
with the FIRST evidence byte-identical — both independently
reconcilable (`run_id` custody-name vs `record_run_id` identity split).

**SOL-TR1-05 — reconciliation is single-writer and crash-idempotent.**
Atomic mkdir claim (outside the evidence dir, carrying the claimant
pid); durable already-landed byte-verify BEFORE any append; interruption
between ref append and cleanup recovers as RECOVERY, not replay (proven
against a genuine SIGKILL in the 0.1 s window); 8 simultaneous
reconciles → EXACTLY ONE replayed entry (verifier counted the chain
itself), 7 no-ops; `verify` treats duplicate `reconciled_from_run` as
corruption. Stale claims from dead pids are named as ABANDONMENT and
taken over safely — **the claim serializes, it does not authorize**; the
already-landed check is what prevents a second replay.

**SOL-TR1-06 — every cleanup and install claim is confirmed by
looking.** `rm`-then-claim replaced by confirm-then-claim (exit 9 for
"record landed but custody could not be removed — NOT a success");
the ordered class audit found and fixed the same disease in
`install-hook.sh` (false "installed"/"PRESERVED" sentences after
unchecked writes — now write-checked, `cmp` read-back, exec-bit
confirmed) and four swallowed-failure paths in supervisor/record.

## The night's ladder of collapsed distinctions (all now doctrine in code)

transport ≠ persistence (SOL-TR1-01) · source ≠ run (SOL-TR1-03) ·
**name ≠ identity** (SOL-TR1-04) · **say ≠ did** (SOL-TR1-06, three
further instances found by audit and verifier).

## Teeth — final count

**348 / 0** — chair's own hand, final tree; progression
103 → 126 → 199 → 247 → 273 → 328 → 348 across seven builder rounds.
All seven of Sol's round-3 plants pass; QUAESTOR re-planted Sol's three
independently (22/0) plus homoglyph/boundary/collision/SIGKILL angles,
verdict FIT-FOR-INTEGRATION; its two round-5 items (false "installed"
sentence; undetectable stale claims) were SHIPPED as repairs, not
residuals — tonight's rule: a documented residual is a defect wearing a
disclosure's coat.

## Honest limits (new, carried verbatim in spirit from the builder's §7)

`kill -0` proves a pid exists, not that it is the claimant (wraparound
fails toward stand-down) · the 0.3 s claim grace is a guess backstopped
by the already-landed check, not by timing proof · stale claims are only
taken over when someone retries · the installer verifies its own bytes
but never reads `core.hooksPath` — it cannot know the directory it wrote
is the one git consults · the oracle problem remains open: the builder's
suite has now twice blessed a defect its own report described, and the
verifier's harness twice nearly convicted correct code — **the serial
cold stranger remains the only instrument with a clean record tonight.**

## Standings (unchanged)

TD-6 OPEN (Option A approved in principle only; sharpened invariant) ·
TD-7 OPEN (repair candidate; first real transport UNREACHED) · TD-8
OPEN (repair candidate; delegators byte-unchanged since round 1,
`--verify` GREEN, TR/0 gate 9/0) · TD-9 OPEN
(IMPLEMENTATION-CANDIDATE / OFF-HOST DURABILITY UNREACHED; fork
returned). Mirror unmoved (`pushed_at 2026-08-10T19:36:16Z`, tip
`3101fcee`). Policy blob `180734f6…c7054` untouched. All prior voids
stand.

*— chair, 2026-08-13. Seven builder rounds, five adversarial rounds,
three Sol cold seats. The goblin has been evicted from four houses;
whether it has a fifth is exactly what the next cold seat exists to ask.*
