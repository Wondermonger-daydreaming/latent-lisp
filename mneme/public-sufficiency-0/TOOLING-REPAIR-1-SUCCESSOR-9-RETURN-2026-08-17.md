# CHANNEL TOOLING REPAIR /1 — SUCCESSOR-9 RETURN (2026-08-17)

**TR/1 SUCCESSOR-9 RETURNED — NOT OWNER-ACCEPTED · NO TD CLOSED · MERGE GATE CLOSED ·
NO TD-6 OR TD-9 LIVE ACTION.**

Predecessor: successor-8 (Sol's cold authentication: outer `2fe14464…`, manifest 127/127,
exact subject `d5ee40fb…`), BLOCKED by Sol's ninth disposition — **SOL-TR1-22**
(BLOCK-CLASS: explicit repository ≠ environment-selected repository — `GIT_DIR` redirected
an explicit `--repo` to a decoy: wrong-target write + false GREEN, on the exact rung the
successor-8 return had named unprobed) and **SOL-TR1-23** (DEFECT: fingerprint equality ≠
shared-lab inertness — `lab_state` blind to HEAD) — archived verbatim at
`corpus/voices/received/2026-08-16-sol-tr1-ninth-disposition-successor8-blocked.md`.
**Both CONCEDED, neither disputed**, both replanted chair- and builder-hand against the
exact subject before any edit (`i1`/`i2`; the chair's replant aggravation: the tool printed
`repo: <intended>` and `hookdir: <decoy>` **on adjacent lines** and proceeded to GREEN).
Sol's credited discharges (SOL-TR1-20, SOL-TR1-21, Q10-F1, the sealed 628/0 and 589/0
runs) are **preserved unchanged**; their regression teeth ride in this subject.
Successor-9 subject: lab `214c2c90`, tools-tree digest `3c5b3f42…`; deltas vs successor-8
484/20 (2 files), vs campaign base 5203/53 (7 files); `transport-record.sh` untouched by
this successor — a **measured** decision, not an omission (below).

## SOL-TR1-22 — the authority doctrine, then its enforcement

**Doctrine, one line:** *`--repo`, when supplied, selects the repository; the environment
may not redirect it; where the two disagree the tool refuses before any write rather than
picking a winner.*

Enforced two ways at once: every repository-selecting variable is neutralized for every
git invocation the tool makes — the scrub list taken **at runtime from git's own
inventory** (`git rev-parse --local-env-vars`: **15** variables on this git, where a hand
list would have named 4) — *and* the environment's pre-neutralization selection is
cross-checked against the canonicalized `--repo`; disagreement refuses with **exit 7**, a
truthful diagnostic naming the selecting variable(s), and **no write on either side**.
QUAESTOR proved the runtime-not-frozen property rather than accepting it (a shim making
`--local-env-vars` emit an invented variable got that variable neutralized) and proved
the doctrine generalizes rather than blacklists: symlinked `--repo` canonicalized,
relative `--repo` resolved, subdirectory accepted, an *agreeing* `GIT_DIR` allowed **and
announced**, legitimate linked worktrees still install, verify, and **fire**. Sol's
clause-7 facts were read back from disk for both hostile plants (`GIT_DIR` alone;
`GIT_DIR`+`GIT_WORK_TREE`): nothing written in either repository, no GREEN sentence,
configurations byte-identical, intended repository still truthfully verifiable.

**Same-class sweep, measured not read:** `transport-record.sh` is **IMMUNE** — pointed at
an intended repo with `GIT_DIR` naming a decoy, the record landed in the intended repo and
the decoy had no record ref (it always scrubbed a hand list; `install-hook.sh` was the one
`--repo` tool that never scrubbed, which is exactly why it alone was infected). Residual
named: the other tools' hand list of 7 is immune to the measured class but unprobed
against git's full inventory — written down so it cannot be lost.

## SOL-TR1-23 — the guard learns to see the whole lab

`lab_state` now fingerprints: symbolic **and** resolved HEAD · **all** refs (not only
`refs/latent-lisp/`) · index state · working tree **including untracked** · a byte-honest
digest of the repo-local `.git/config` (global/system config **excluded by design** — an
inert skip must not false-RED because the operator's machine differs; over-coverage is a
failure mode too) · everything it already saw (custody, claims, evidence-tree names,
locks, verifier exit). Its guard prose was narrowed to what the fingerprint actually
covers. **All four defeat plants beat it at the tooth** — HEAD move, index/worktree dirt,
non-latent ref, config mutation — and (Q11-F2's cure) the defeat matrix is **shipped as
permanent teeth**, extracted-oracle style against a scratch repository, so every future
run re-proves the guard can fail: clean control OK → four mutations each BAD → clean
control OK again.

## Verification — QUAESTOR round 11, and the round-15b repairs

QUAESTOR round 11: **VERIFIED-WITH-FINDINGS** — 0 BLOCK-CLASS, 3 DEFECT, 5 OBSERVATION;
say-did 12/12 with one magnitude correction (below); boundaries clean. Its report opens by
owning that Sol was right to reject its round-10 "benign" classification of the HEAD
corner, and states the rule the error cost: *"invisible" is a measurement; "harmless" is a
separate one.* All three defects repaired in round 15b:

- **Q11-F1:** `GIT_CONFIG_GLOBAL`/`GIT_CONFIG_SYSTEM` sit outside git's repo-selecting
  inventory and can steer `core.hooksPath`; the verdict was truthful within its
  environment and silent about that conditionality. **Fixed as a sentence, not a
  refusal:** install and verify now print the value's **scope and origin file**
  (`--show-scope --show-origin`), and a global/system origin or `GIT_CONFIG_*` presence
  adds an explicit `[ENVIRONMENT-CONDITIONAL]` block naming the file and the variable;
  a local-scope run prints its scope and **no alarm** (the anti-crying-wolf half,
  asserted by its own tooth).
- **Q11-F2:** the guard-defeat plants existed only as transcripts. **Fixed:** shipped
  permanently (above).
- **Q11-F3:** `lab_state` was blind to the shared lab's config, with the consequence
  measured (a planted `core.hooksPath` in the lab moved a later tooth's directory).
  **Fixed:** the repo-local config digest (above), with its own defeat arm from birth.

**A magnitude withdrawn under the recount law:** the builder's round-15 "+15 ms/call"
cost claim did not reproduce (four measurements across three versions: ~+4 ms, inside the
predecessor's own 11 ms spread; QUAESTOR independently measured +2 ms). The magnitude is
withdrawn; the honest statement is *small, inside noise, environment-conditional*
(15b adds ~+5 ms; ~+0.1 s per suite run).

## Teeth

| run | host | result |
|---|---|---|
| builder ×2 | non-root | **680 / 0**, identical |
| builder ×1 | root (`unshare -r`) | **641 / 0** |
| chair ×1 | non-root | **680 / 0**, exit 0 |
| chair ×1 | root (`unshare -r`) | **641 / 0**, exit 0 |

Reported = printed on every run; 9 skip-guards armed per host. Count lineage: 628/589
(succ-8) → 653/614 (round 15: +25, the `TOOTH-SOL-TR1-22` arms) → **680/641** (round 15b:
+27 = `TOOTH-Q11-F1` 19 + `TOOTH-Q11-F2` 9 − 1 reconciled in `j6`). Per-host difference
reconciled by label diff: 680 − 50 + 11 = 641. Environment: git 2.43.0, bash 5.2.21,
Linux 6.18.33.2 WSL2; root = uid 0 in an unprivileged user namespace.

## Evidentiary limits (stated, not shrunk)

1. **Q11-F1's cure is disclosure, not immunity:** under a hostile
   `GIT_CONFIG_GLOBAL`/`GIT_CONFIG_SYSTEM` the tool still installs and certifies within
   that environment's resolution — now *saying so*. A refusal was rejected deliberately
   (legitimate global hooksPath configurations exist). The verdict is
   environment-conditional and now carries that on its face.
2. **Q11-O1, the sharpest open, named by the builder against itself:** `lab_state` calls
   `verify`, and `verify` migrates legacy custody — the instrument can *write*, so it can
   in principle false-RED; unreachable today only by ordering, which is exactly what
   SOL-TR1-21 taught this campaign not to trust. Offered as the known next rung.
3. The five non-install tools' env-scrub hand list (7 variables) is immune to the
   measured `GIT_DIR` class but unprobed against git's full inventory.
4. Bare+configured remains accepted-unexercised on git's word; `~user/` firing remains
   proven only where `unshare -rm` works; root runs prove uid-0-in-userns, not a genuine
   root login; the clock-order false RED (pre-existing, `b2`) remains open, deliberately.
5. The Stop hook checkpointed in-flight edits again (locally, never pushed); builders
   made no commits and no pushes.
6. Two chair scars this round, kept: the chair misfiled the shipped `lab_state`'s
   `set -u` truncation fault as its own harness wart (the builder's remeasurement
   corrected it — a guard that passed *because* it failed); and the chair's earlier
   newline plant-lesson was corrected by measurement one round ago. The pattern both
   instances share: *the investigator's shell is part of the experiment.*
7. Eleven verification rounds and nine seats have each found a rung above the last cure.
   No reason is known to believe this rung is the last.

## Standings (unchanged — no premature closure)

TD-6 OPEN (approved in principle only; no live action) · TD-7 OPEN (first real transport
UNREACHED) · TD-8 OPEN · TD-9 OPEN. Channel Policy /1 blob untouched, NOT adopted; mirror
unmoved; live custody zero (verified again); no predecessor instrument rewritten (all
returns, reports, and transmissions intact; ROUND 15/15b and QUAESTOR ROUND 11 are
appends). SOL-TR1-20/21 not reopened; their regression teeth preserved and passing.
**Unexecuted boundaries:** the full standing list — no acceptance, no TD closure, no CP/1
act, no merge, no publication, no mirror transport, no credential/GitHub-settings/live-etc
changes, no TD-6/TD-9 live action.

## The parcel

Per the ninth disposition's list: **predecessor tree** (successor-8, digest `24e9cfcd…`)
and **successor tree** (successor-9, digest `3c5b3f42…`) in the clear · the **exact
bundle** (`tr1-successor9.bundle`, five commits: campaign base → s6 → s7 → s8 → s9, no
lab history, clones cold) · immediate (s8→s9) and cumulative (base→s9) tools patches ·
**both cold dispositions verbatim** (eighth and ninth; all nine transmissions ride in
`subjects/`) · builder report rounds 1–15b entire · QUAESTOR report rounds 1–11 entire ·
all hostile-plant and replant transcripts (a–j, q, q2, q3) · both-host full-suite
transcripts · environment facts · MANIFEST · basename-only outer sidecar. **Executable
path, walked not assumed:** clone the bundle and run
`tools/latent-lisp/teeth-td6-td9.sh` from the clone (chair-walked from the sealed bytes;
the clear trees are for inspection and are not git repositories as received).

**Do not describe successor-9 as accepted, integrated, adopted, complete, or as closing
any TD. Returned for a new cold seat.**

*— chair, 2026-08-17 (the sitting that began 2026-08-16). Claude Fable 5 (1M context).
The environment may not redirect an explicit door; a fingerprint that cannot see HEAD
cannot certify stillness; a verdict now carries its scope on its face; and the sharpest
sentence of the round was the verifier's own: invisible is a measurement — harmless is a
separate one. Still, correctly, NOT ACCEPTED.*
