# CHANNEL TOOLING REPAIR /1 — REPAIRED SUCCESSOR RETURN (2026-08-13)

**Terminal status, exactly as the cold-review disposition prescribes:**

> **REPAIRED TR/1 SUCCESSOR RETURNED — NOT OWNER-ACCEPTED.
> NO TD CLOSED · MERGE GATE CLOSED · NO LIVE TD-6 ACTION.**

Predecessor: the TR/1 candidate at `9b5ae663`, RETURNED FOR REPAIR by the
Sol cold review (archived verbatim:
`corpus/voices/received/2026-08-13-sol-tr1-cold-review-returned-for-repair.md`).
This successor answers SOL-TR1-01 and SOL-TR1-02 and carries the TD-6
sharpened invariant. Exact delta from `9b5ae663` = the commit range ending
at this document's integration commit; the machine-readable patch travels
in the parcel (`tr1-successor-tooling.patch`).

## SOL-TR1-01 — persistence-failure false green: REPAIRED AT CLASS LEVEL

The conceded defect: an `update-ref` failure under the real supervisor
path yielded "recorded", supervisor exit 0, marker cleaned, status
NOT EVIDENCED — the evidence machinery failing silently about its own
evidence. The class rule now enforced in all four tools, verbatim in each:
**TRANSPORT OUTCOME ≠ PERSISTENCE OUTCOME — bytes may have moved
successfully while their required evidence failed.**

Per Sol's seven requirements (each independently re-verified by the
adversarial hand, which re-planted the attack itself):

1. No append failure is ever followed by "recorded" — the sentence is
   unreachable unless the append returned 0 (grep-proven across all
   outputs, disclaimers excluded).
2. Supervisor exits 5 on persistence failure; source-commit standing
   never falsified.
3. Distinct terminal host-local marker
   (`.git/latent-lisp/transport-evidence-failed/<run-id>.json`) —
   survives the EXIT trap by construction; not collapsed into
   TRANSPORT-FAILED / PENDING / abandoned / NOT EVIDENCED / ABSENT.
4. `transport-status.sh` verdict **EVIDENCE-FAILED, exit 5, checked
   FIRST** (outranks NOT EVIDENCED/ABSENT), carrying intended event kind,
   transport exit/result, run-id, time, append error.
5. Direct `sync.sh`: all seven exit paths route through a `finish()`
   gate — qualified non-green + exit 5 when its own event could not
   persist even though the transport succeeded, with the transport
   success still honestly stated.
6. The semantic distinction is load-bearing vocabulary in code and
   output.
7. CAS/concurrent-append failure = same class: bounded retry (fresh
   parent), then marker; adversarial 8-way concurrent run accounted for
   as 6 landed + 2 marked — zero silent losses.
   `verify` additionally refuses GREEN (exit 5) while a known event is
   missing from the chain.

Required tooth **TOOTH-SOL-TR1-01**: every clause of Sol's plant executed
— seed → two plant classes (stale `.lock` AND readonly refs dir) → real
supervisor path × both transport outcomes → RED status → no false
sentence → marker survives → unplant → GREEN with marker cleanup → direct
`sync.sh` both ways.

## SOL-TR1-02 — off-host durability: TOOTH UPGRADED; OWNER FORK RETURNED

- **TOOTH-SOL-TR1-02** (disposable): ref pushed to a bare remote → the
  originating repo and every copy DESTROYED (`rm -rf`; the adversarial
  hand hunted the hardlink trap: 0 shared inodes, nlink 1, no alternates,
  then `repack`/`fsck --strict` on the durable side) → clone from the
  remote ONLY → documented refspec fetch → complete chain verified at a
  byte-identical tip. The tooth's own output states the real crossing is
  an owner act.
- **TD-9 standing, exactly:** **IMPLEMENTATION-CANDIDATE / OFF-HOST
  DURABILITY UNREACHED — not CLOSED.** The real crossing is specified,
  not executed, in the returned owner fork:
  `TOOLING-REPAIR-1-TD9-DURABILITY-OWNER-FORK-2026-08-13.md`
  (destination = the LAB remote's `refs/latent-lisp/transport-record`,
  outside Channel Policy /1's public-mirror domain; automatic fail-soft
  push recommended; append-only ⇒ fast-forward-only, non-FF = alarm,
  never force; closure criterion = authorized real crossing + fresh
  materialization from the real remote, verified GREEN, owner-accepted).

## TD-6 — APPROVED IN PRINCIPLE ONLY; NO LIVE ACTION

Sharpened invariant appended to the TD-6 owner fork per the disposition:
exactly one deploy key · dedicated solely to `sync.sh` · bypass actor =
DeployKey CLASS, so any additional key is a review trigger reopening the
exclusivity claim (census must alarm on count > 1) · owner/admin ordinary
credentials hold no `main`-update bypass · before/after API census and
rollback mandatory. Option B fallback-only. Nothing executed: no ruleset
change, no deploy-key creation, no credential mutation (mirror
re-confirmed unmoved: `pushed_at 2026-08-10T19:36:16Z`, tip `3101fcee`).

## Documentary consequences — DISCHARGED

Machinery Erratum 1 carries a SECOND DATED CORRECTION (original text not
rewritten; accepted policy blob `180734f6…c7054` untouched): "every
terminal outcome is appended" is corrected to "attempted — a failed
append is itself surfaced as a distinct evidenced failure, never silently
absorbed."

## Teeth — revised count

**199 assertions / 0 failures** — run fresh by THREE hands: the builder
(twice), the adversarial verifier (cold), and the chair (final run before
integration). Progression 103 → 126 → 131 → 199. The verifier additionally
re-planted Sol's attack independently (85/0 across its own matrix) and
ran three novel marker-layer attacks (9/0). Its round-2 leading-zero
residual is confirmed closed.

## TD-by-TD standing (no premature closure)

| Defect | Standing |
|---|---|
| TD-6 | OPEN — Option A approved in principle only; execution awaits explicit owner authorization under the sharpened invariant |
| TD-7 | OPEN — repair candidate (now including the EVIDENCE-FAILED layer); awaits owner acceptance; first real-transport evidence still UNREACHED |
| TD-8 | OPEN — repair candidate (delegators byte-verified, unchanged this round); awaits owner acceptance |
| TD-9 | OPEN — IMPLEMENTATION-CANDIDATE / OFF-HOST DURABILITY UNREACHED; owner fork returned |

## Residuals and voids carried honestly

All predecessor voids stand (no real transport ever performed · post-merge
never exercised through a real merge · historical refusals not
retro-imported · `--dry-run` records nothing · sentinel `-1`
distinguishable only by reason text · TOOTH-TD-6 GREEN is about `/tmp`,
not github.com). New this round: evidence-failure markers are HOST-LOCAL
and do not cross (they are the local trace of a local failure; the
durable layer is TD-9's fork) · if `.git` itself is unwritable no
queryable trace survives (tooling still exits 5; hook-path output lands
in `.sync.log`) · display nit: the status readout truncates the embedded
intended-record JSON (operator-relevant; non-blocking, on the docket for
any future round) · the verifier's observation that with SYNC-PAUSED
removed, the main-only branch guard stands alone against the
auto-committing Stop hook — true, and it is the same guard that held
~100 times in `.sync.log`; noted, not repaired (it is the designed
mechanism, not a defect).

*— chair, 2026-08-13. Three hands on the record: FERRARIUS built (rounds
1–3), QUAESTOR verified adversarially (rounds 1–3, own plants), the chair
filed, measured TD-6 live, closed one residual, and ran the final teeth.
Full transcripts: `_staging/tr1-ferrarius-builder-report.md` (3645 lines),
`_staging/tr1-quaestor-verification.md` (828 lines).*
