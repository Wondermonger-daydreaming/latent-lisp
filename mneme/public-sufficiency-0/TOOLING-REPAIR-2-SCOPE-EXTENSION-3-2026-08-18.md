# CHANNEL TOOLING REPAIR /2 — SCOPE EXTENSION 3 (Q4-F1 + Q4-F2, 2026-08-18)

**Owner scope decision (interview fork, ~02:25Z). The THIRD and intended-final
extension before sealing, tightly bounded: kill Q4-F1's false-success collision and
Q4-F2's fail-toward-transport direction. The full content-pipeline audit
(materialize → rsync → `add -A` → `diff --cached`, and `transport-record.sh`) remains
the NAMED FUTURE LANE — QUAESTOR's round-4 dig-next pointer stands for the cold seat
and the owner, not for this round.**

## The findings (QUAESTOR round 4, `_staging/tr2-quaestor-round4.md`)

- **Q4-F1 (the gravest of the family — success-claiming, PRE-EXISTING, reproduces on
  the accepted blob with NO fault injection):** `sync.sh` can record a false
  `TRANSPORT-OK` reading *"target already equals the subject tree"* while the mirror
  is stale. Mechanism: `git archive` stamps commit-time mtimes at 1-second
  granularity; `RSYNC_FLAGS` carries no `--checksum`; two same-second commits with
  same-size governed content collide on rsync's quick-check and the copy is silently
  skipped (measured: two distinct commits sharing mtime `22:45:21.000000000`). Every
  prior member of the SOL-TR2-01 family withheld falsely; this one CLAIMS SUCCESS
  falsely — false custody evidence at the exact component CP/1's PUBLISHED
  conjunction rests on. Guarded from harm today only by the raised sentinel.
- **Q4-F2:** the pause gate's `[ -e ]` reads a stat FAILURE as *not paused* —
  fail-toward-transport, the one direction pre-named as blocking; reachability not
  demonstrated, direction indefensible. Also sits outside §R4.1's census despite
  meeting its criterion.
- **Q4-F3 (trivial):** §R4.1's line numbers are stale — refresh.

## The owner's disposition (verbatim option)

> **Extend once more, bounded** — SCOPE EXTENSION 3, tightly bounded: kill Q4-F1's
> collision (checksum-grade equality — verify against the subtree object id, not
> rsync quick-check inference) + fix Q4-F2's direction (stat failure ⇒ treated as
> PAUSED, fail-toward-withholding), RED-proven, round 5 + QUAESTOR, THEN seal. The
> full content-pipeline audit stays the named future lane. One more round; the
> success-claiming member does not ship known.

## Extended scope — exactly this, no more

- **Q4-F1 cure:** "target already equals the subject tree" may only ever be asserted
  on **checksum-grade evidence** — verification against the subtree object id (or
  equivalent content identity), never inferred from rsync's quick-check via an empty
  index diff. Whether the cure is `--checksum`, a git-native equality check, or both,
  is the builder's design, defended in writing; the RED arm is QUAESTOR's exact
  no-fault-injection reproduction (same-second, same-size collision) on the
  pre-cure blob, showing the false OK; GREEN shows either a truthful OK (content
  verified equal) or a real transport of the missed bytes.
- **Q4-F2 cure:** a stat failure at the pause gate is treated as PAUSED
  (fail-toward-withholding), with the failure recorded as itself. RED arm constructs
  the stat failure against the pre-cure gate if reachable; if reachability cannot be
  demonstrated, the tooth pins the direction at the unit level and says so.
- **Q4-F3:** refresh the table's line references.
- All standing constraints carried: accepted `teeth-td6-td9.sh` byte-untouched +
  680/0; teeth grow only, run twice; /tmp harnesses; no commits, no lab merge/push
  during build, no mirror contact; sentinel sha recorded start/end;
  `transport-record.sh`/`transport-supervisor.sh` untouched; candidate standing; new
  cold seat before any acceptance; TD-10/TD-11 OPEN and blocking throughout.

## Chain

QUAESTOR round 4 (SEALABLE + Q4-F1/F2/F3, three self-caught harness errors named) →
owner interview fork → this extension. No predecessor document is rewritten.

*— recorded by the chair, Claude Fable 5 (1M context), 2026-08-18 ~02:25Z, at the
owner's word.*
