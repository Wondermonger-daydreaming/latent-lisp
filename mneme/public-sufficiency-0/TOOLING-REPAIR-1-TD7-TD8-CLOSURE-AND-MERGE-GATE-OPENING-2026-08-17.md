# CHANNEL TOOLING REPAIR /1 — TD-7 + TD-8 CLOSURE AND MERGE-GATE OPENING (2026-08-17)

**TD-7 CLOSED (with a binding first-fire readback duty) · TD-8 CLOSED · MERGE GATE
OPENED by owner ruling of the gate's governing reading. TD-6 and TD-9 REMAIN OPEN.
This act performs NO merge, NO transport, NO publication, NO live credential, ruleset,
or settings action. CP/1 remains a candidate, NOT adopted. The merge itself remains a
separate, later, owner-authorized act in the CP/1 acceptance ordering.**

## The act

On 2026-08-17 (~19:30Z), following the successor-9 owner acceptance
(`TOOLING-REPAIR-1-SUCCESSOR-9-OWNER-ACCEPTANCE-2026-08-17.md` — which closed nothing
and stated that closure is a separate owner act each), the owner (Tomás Pavan) directed
the chair to present a separate closure fork: close TD-7 and TD-8 and open the merge
gate, leaving TD-6 and TD-9 open, with no merge, transport, publication, or live
credential/settings action inside the closure act. The chair's docket-reader (LICTOR,
state-map at `_staging/td6-9-state-map-2026-08-17.md`) surfaced one genuine ambiguity —
the merge gate's opening condition is written three ways, one circular — and one honest
void — TD-7's cure has never fired in the live channel. Both were put to the owner
explicitly via the interview tool. The owner selected, verbatim:

**Fork 1 — which reading governs the gate** (the circularity: `TOOLING-REPAIR-1-RETURN-2026-08-13.md:98–99`
conditions opening on *"(and their first real-transport evidence exists)"*, but transport
fires only on `main`, and reaching `main` requires the merge the gate forbids; the two
other formulations carry no such precondition):

> **Non-circular reading** — The parenthetical describes what the merge will produce
> (transport evidence arrives post-merge, as the ordering closure → adoption →
> authorization → merge → verified transport already states). Owner acceptance +
> TD-7/TD-8 closure suffices: the gate OPENS in this act. Merge itself still requires
> its own later authorization.

**Fork 2 — the form of TD-7's closure** (its cure is code-frozen since 08-13 and
teeth-proven in harness, but has never fired in the live channel — zero transport
events ever; the record ref does not exist):

> **Close w/ readback duty** — TD-7 CLOSED on repair + teeth + successor-9 acceptance,
> with a binding rider: the FIRST real transport's supervisor verdict and record entry
> must be read back to the owner as part of the eventual post-merge transport act — the
> void named in the closure block itself, never converted into channel evidence.

## Ruling 1 — the gate's governing reading (D-3 settled)

The owner rules that the parenthetical in `TOOLING-REPAIR-1-RETURN-2026-08-13.md:98–99`
is a **description of what the authorized merge will produce, not a precondition of
opening the gate.** The governing formulations are the non-circular pair: *"TD-7+TD-8
acceptance required first"* (`notes/2026-08-14-session-handoff-the-tr1-gauntlet.md:38`)
and *"TD-7+TD-8 demonstrably dead"*
(`CHANNEL-POLICY-1-CANDIDATE-ACCEPTANCE-2026-08-13.md:41`). This ruling resolves the
discrepancy flagged as ⚑D-3 in the 2026-08-17 state-map; no predecessor document is
rewritten by it.

## Closure — TD-7

**TD-7: CLOSED** by this instrument, at the owner's fork selection above.

- **What is closed:** the defect as defined (`TOOLING-DEFECT-DOCKET-2026-08-12.md:92–95`
  — the post-commit hook discarded `sync.sh`'s exit status). The repair: both hooks now
  fire `transport-supervisor.sh`, which survives to harvest the terminal exit into the
  durable transport record; hooks still exit 0 unconditionally (source-commit success is
  never falsified by a later transport failure). Five distinct verdicts/exits via
  `transport-status.sh`; exact failure code preserved (proven with a planted 42);
  SOL-TR1-01's append-failure false-"recorded" cured by the EVIDENCE-FAILED state
  (*transport outcome ≠ persistence outcome*).
- **Teeth satisfied before closure:** TOOTH-TD-7 (`tools/latent-lisp/teeth-td6-td9.sh`)
  proven RED-capable — a failed transport becomes RED with its exact exit code preserved.
- **THE BINDING FIRST-FIRE READBACK DUTY (owner's rider, integral to this closure):**
  the first real transport's supervisor verdict and record entry MUST be read back to
  the owner as part of the eventual post-merge transport act. Until that readback, the
  cure's channel evidence is UNREACHED and may not be claimed.
- **Non-conversion clause:** this closure does NOT convert harness evidence into channel
  evidence. **First real transport UNREACHED** — `refs/latent-lisp/` is empty (zero
  events ever, measured this sitting); the 5202-line `.sync.log` shows every event ending
  at the main-only branch guard. And per ⚑D-5: TD-7's evidence layer routes into the
  TD-9 record ref, whose off-host durability is itself an open defect — closing TD-7
  asserts nothing about TD-9.

## Closure — TD-8

**TD-8: CLOSED** by this instrument, at the owner's direction.

- **What is closed:** the defect as defined (`TOOLING-DEFECT-DOCKET-2026-08-12.md:96–99`
  — the installed `.git/hooks/post-merge` was a stale copy missing the 2026-08-02
  `--commit` fix). Measured this sitting, the defect as literally defined is dead:
  - `.git/hooks/post-merge` — 92 bytes, byte-exact thin delegator, sha256
    `62f085c95edbaf81aed3fc6dc48e6fd0269360a77be27aa8e91fecd383e14123`;
  - `.git/hooks/post-commit` — 93 bytes, byte-exact thin delegator, sha256
    `cce20178f5486b132733f6afb42c43ce47d67f856ef6ebedff55f208b891aa1f`;
  - both delegate to `tools/latent-lisp/{post-merge,post-commit}.sh`, each carrying
    `--commit "$FULL"` to the supervisor; `core.hooksPath` is unset, so these are the
    hooks git runs;
  - the stale hook is preserved as evidence at
    `.git/hooks/post-merge.pre-td8-backup-20260813T181941Z` (910 bytes, sha256
    `8520185aaac0465ecc2a1553058ac23295b77f60f59a97efa342dbb82f011747`, matching the
    2026-08-13 session-start measurement in `TOOLING-REPAIR-1-RETURN-2026-08-13.md:33`).
- **Teeth satisfied before closure:** TOOTH-TD-8 proven RED-capable (installed-hook
  drift caught, cured, and caught again). The TD-8 verifier (`install-hook.sh`) is the
  most adversarially battered artifact in the arc — SOL-TR1-16..22 (nine cold seats)
  all landed on it, through the successor-9 wrong-target-write/false-GREEN cure the
  owner accepted.
- **Non-conversion clause:** this closure does NOT convert byte-verification into
  merge-path channel evidence — **the post-merge path has never been exercised through
  a real merge** (`TOOLING-REPAIR-1-RETURN-2026-08-13.md:62`; the merge was forbidden
  while the gate stood closed). Carried unconverted with it: **Q11-O1** (the guard's
  own first call can write when legacy custody exists — genuine maintenance defect,
  filed, guarded by the successor-9 binding rider: `lab_state` must gain a genuinely
  read-only verification mode before any legacy-migration reorder or skip-guard
  extension into that state), the **clock-order false RED** (open, deliberately), and
  all environment limits stated in the successor-9 return.

## Ruling 2 — THE MERGE GATE IS OPENED

With TD-7 and TD-8 both owner-accepted (successor-9 acceptance) and now owner-CLOSED,
and with Ruling 1 settling the gate's governing reading, **the merge gate established by
the R-1 disposition (`CHANNEL-POLICY-1-R1-DISPOSITION-2026-08-13.md:44–48`) is OPENED.**

What "opened" means — and does not mean:

- The standing prohibition *"TD-7 AND TD-8 must BOTH be repaired before ANY
  branch→`main` merge covered by that ruling"* is **satisfied**. The gate no longer
  blocks a covered merge.
- **NO merge is performed, authorized, or scheduled by this act.** The merge remains a
  separate, later, owner-authorized act, in the CP/1 acceptance ordering
  (`CHANNEL-POLICY-1-CANDIDATE-ACCEPTANCE-2026-08-13.md:41–45`): TD-7/TD-8 closure →
  **CP/1 adoption act (§8.1 commencement)** → **authorization acts** → owner-gated
  branch→main merge → verified transport + R-2b-ruled receipt (which now carries the
  TD-7 first-fire readback duty) → PS/0 far-side readback.
- The integration itself is to be prepared with the **SYNC-PAUSED sentinel held
  throughout**, so that reaching `main` does not auto-fire transport — transport stays
  a deliberate separate act.

## What this act does NOT do (negative space, complete)

- **No branch→main merge performed.** The gate is open; the door is not walked through.
- **No mirror transport, no publication, no PUBLISHED standing** — nothing reached the
  public mirror; the main-ancestry guard and main-only branch guard stand untouched.
- **No TD-6 action:** the mirror's `main` remains unprotected; Option A remains
  approved in principle only; **no credential, deploy-key, or ruleset mutation
  occurred.** TD-6 remains **OPEN**.
- **No TD-9 action:** the record ref has never crossed to any remote; `.sync.log`
  remains gitignored host-local testimony. TD-9 remains **OPEN — IMPLEMENTATION-
  CANDIDATE / OFF-HOST DURABILITY UNREACHED**, its written four-step closure criterion
  untouched.
- **CP/1 remains a candidate, NOT adopted.** No authorization act occurred.
- **No settings, config, or hook mutation** — the closure is paper over verified,
  frozen bytes (`git diff --stat 214c2c90..HEAD -- tools/latent-lisp/` = empty; the
  owner-accepted subject is byte-unchanged at HEAD `5043b03e`).

## Docket carriage (⚑D-1 / ⚑D-2, cured append-only)

A STANDING block is appended (same commit) to
`TOOLING-DEFECT-DOCKET-2026-08-12.md` recording: the TR/1 commission and nine-successor
chain that superseded the second-series header's "no repair authorized" clause (the
header itself stands unrewritten, per append-only practice); TD-7/TD-8 closure by this
instrument; and the fact that TD-8's definition text is now historical — it describes a
hook that no longer exists.

## Provenance

Chain: TOOLING-DEFECT-DOCKET second series (2026-08-12/13) → TR/1 commission → nine
successor returns, ten Sol dispositions, eleven QUAESTOR rounds → successor-9 owner
acceptance with rider (2026-08-17 ~01:00) → LICTOR state-map
(`_staging/td6-9-state-map-2026-08-17.md`) → owner's two-fork interview (this act,
~19:30Z) → this instrument. No predecessor document is rewritten.

*— recorded by the chair, Claude Fable 5 (1M context), 2026-08-17, at the owner's word.*
