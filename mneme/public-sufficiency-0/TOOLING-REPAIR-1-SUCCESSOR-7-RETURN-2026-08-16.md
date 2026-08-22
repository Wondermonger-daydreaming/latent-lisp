# CHANNEL TOOLING REPAIR /1 — SUCCESSOR-7 RETURN (2026-08-16)

**TR/1 SUCCESSOR-7 RETURNED — NOT OWNER-ACCEPTED · NO TD CLOSED · MERGE GATE CLOSED ·
NO TD-6 OR TD-9 LIVE ACTION.**

Predecessor: successor-6 (`aa9a1330`, subject pinned at `26949d44`, Sol-authenticated
outer archive `2cc0bd24…5f3d8`), BLOCKED by Sol's seventh disposition — SOL-TR1-16
(configured empty ≠ unset) · SOL-TR1-17 (guard exists ≠ another actor reconciled) ·
SOL-TR1-18 (the guard-linkage tooth passes its own mismatch) · SOL-TR1-19 (`~user/`
actual firing unproven) — owner-relayed, archived verbatim at
`corpus/voices/received/2026-08-16-sol-tr1-seventh-disposition-successor6-blocked.md`.
**All four findings CONCEDED, none disputed.** Sol's order of work followed literally:
replant first (chair-hand and builder-hand, against the authenticated subject, failed
transcripts preserved untouched: `a1`/`a2`/`a3`), cure second. Successor-7 subject:
lab `a9494384` (this branch); tools-tree content digests base/succ-6/succ-7 =
`6277ee17…` / `72b87e8c…` / `003de65c…` (16-hex prefixes; full recipe in the parcel's
`environment.txt`).

## The cures (FERRARIUS rounds 13 + 13b; QUAESTOR round-9 verification)

- **SOL-TR1-16:** presence is now Git's **exit status**, never output non-emptiness.
  Four states, four sentences: ABSENT (rc=1 → `$GIT_DIR/hooks`, wording "absent" —
  "unset" is retired), PRESENT-BUT-EMPTY (rc=0, empty → **FAIL CLOSED, exit 3**, in
  every mode including `--print`: nothing installed, no directory certified, never
  called "unset"), PRESENT-NONEMPTY (git's own `--path` resolution, unchanged incl.
  the refuse-if-unresolvable branch), CONFIG ERROR (rc≥2 → **fail closed, exit 4**).
  Teeth measure firing with canaries: the state the old tool certified GREEN —
  byte-correct delegators in an inert directory — is now *measured* inert
  (`default_hook_fired=NO` with correct bytes present). Absent/nonempty paths
  byte-compatible: a mode added, not a fork.
- **SOL-TR1-17:** the transaction stands (it was law and refused correctly); its
  post-failure epistemology is replaced. `classify_guard_state()` **reads before it
  classifies**: guard target (peeled `^{commit}`), record tip, our own candidate's
  reachability, guard-target reachability, the guarded `record.json`, its
  `reconciled_from_run`, its original bytes against the intended replay. Classes and
  exits: **SIBLING RECONCILED 12** (only after all three read-backs match),
  **ORPHAN/INCONSISTENT 13** (says exactly what it read, claims **nothing about who
  created the ref**, retains custody), **WRITE OUTCOME UNCERTAIN 14** (read-backs
  failed — nothing claimed either way), already-landed unshadowed (it runs before any
  write attempt). "NOTHING WAS WRITTEN" is **earned per branch by read-back** (our
  candidate shown unreachable from the tip, and the sentence says that is how it was
  established); a loud arm reports the inverse case (candidate reachable despite
  reported failure) without explaining it. `verify` gained a **guard-namespace
  audit**: dangling / contradictory / orphan / unreadable / mismatched, each named
  per guard; zero guards is a vacuous pass that says so. Sol's plant, replanted:
  pre-cure exit 12 + the false sentence over replays 0→0; post-cure **exit 13,
  provenance unclaimed, custody retained, verify RED naming the guard** — and
  (QUAESTOR's extension beyond the builder's own check) verify **stays RED after the
  marker is hand-deleted**, where the pristine tool went GREEN.
- **SOL-TR1-18:** in the deterministic two-racer schedule the mismatch arm is now
  **RED** ("this schedule moves it nowhere"). The tooth **extracts the shipped oracle
  lines with awk** and executes them — it tests the oracle, not a paraphrase. Plants:
  guard repointed at a reachable-but-wrong record (ORACLE-SAYS-BAD + verify
  MISMATCHED), at a worktree commit (BAD + ORPHAN), a ref naming an absent object
  (DANGLING), two guards on one commit (CONTRADICTORY), restored (OK + GREEN). Prior
  counts (`519/0`, `524/0`) are **not carried** as guard-linkage certification.
- **SOL-TR1-19:** `~user/` **ACTUAL FIRING proven** in an unprivileged user namespace:
  crafted passwd bind-mounted **inside the namespace only** (live `/etc/passwd`
  verified untouched by an in-tooth check), named user `tr1test` with a harness home;
  git resolves `~tr1test/hooks` into the harness; install exits 0; the delegator is
  on disk in Git's resolved directory; **a real commit writes the canary**; `--verify`
  is GREEN against the same directory; a final assertion prints and compares all
  three paths. **RESOLVER AGREEMENT is a separate, differently-named assertion** —
  round 12's fact, kept, no longer sitting in the firing requirement's chair. Where
  `unshare -rm` is unavailable the tooth prints UNTESTED-IN-THIS-RUN, stated not
  skipped, and it is not a pass.

## Verification, and its findings — carried whole, never the softer side

QUAESTOR round 9: **VERIFIED-WITH-FINDINGS** — all four cure sets discharged bullet
by bullet under its own replants (built from Sol's text alone, run against both the
pristine `26949d44` extraction and the cured tree) and fourteen plants the builder
did not make; say-did audit 15/15 true. Findings: **1 BLOCK-CLASS, 3 DEFECT, 4
OBSERVATION** (its ROUND 9, in the parcel, is authoritative):

- **Q9-F1 (BLOCK-CLASS):** five assertions of the `~/`-firing arm ran inside a
  `( … )` subshell — they printed `✔`/`✘` into counters that died with it. A planted
  failure yielded `✘ FAIL` printed, `assertions FAILED : 0`, *"every tooth fired RED
  on its planted failure"*, **exit 0**; the suite executed 573 assertions and
  reported 568. Pre-existing in successor-6; load-bearing because 568/0 was the
  carried number and one of the five is the `~/` ACTUAL-FIRING requirement from
  Sol's sixth BLOCK.
- **Q9-F2 (DEFECT):** the SIBLING branch still printed *"the guard ref was created
  in the SAME transaction as its record"* — provenance no read-back establishes;
  QUAESTOR forged a guard satisfying every read (guard and record created by two
  separate hand update-refs) and the sentence was false of it. *(Chair note, at its
  true size: this converged with a chair finding deliberately withheld from the
  verifier's brief. The convergence is same-root — one Claude lineage, divergent
  contexts — so it counts as an echo-resistant catch, never as two witnesses.)*
- **Q9-F3 (DEFECT):** two *resolved* `core.hooksPath` values — `.` and a value with
  a trailing newline — still earn `HOOKS GREEN` exit 0 while git runs nothing.
- **Q9-F4 (DEFECT, minor):** the loud arm printed "Do NOT re-run before verify" and
  then "Re-run to complete any custody cleanup" in one message.

**Round 13b repaired Q9-F1, Q9-F2, Q9-F4**, each proven by reaching the state:
the `~/` arm now runs without a subshell and is **proven able to bleed** (the same
planted failure now yields `FAILED : 1`, TEETH RED, exit 1 — transcript `e1`); the
whole suite was swept for the class and **no second instance** exists (inventory in
`e3` and the builder report); the SIBLING message now separates *what the chain
evidences* (read) / *what this invocation witnessed* / *what is not claimed*, with
two `hasnt` tripwires that fail if the retired clause ever returns; the loud arm was
reached deterministically (`e2`) and no longer prints a re-run instruction.

**Q9-F3 is OPEN, UNREPAIRED, AND NAMED — offered, not hidden.** Chair adjudication:
it is pre-existing, outside SOL-TR1-16's literal bullets (the value *is* resolved and
nonempty), and its mechanism is undiagnosed; the honest cure is structural (*a
verifier may only certify a directory whose effectiveness it has established*), and a
hasty grammar special-case would be the CONFIGURED ≠ EFFECTIVE disease wearing a
repair's coat for the sixth time. It is the known next rung. Transcripts:
`q-hookspath-hostile-values.txt`, `q-plant-hookspath-false-green-values.txt`.

## Teeth

Round history: 103 · 126 · 199 · 247 · 273 · 328 · 348 · 395 · 411 · 458 · 478 ·
524 · 568 · **578** (13b). The 568→578 step is an **honesty correction plus repair,
not growth**: +5 assertions freed from the subshell (they executed, uncounted, in
every successor-6 run), +1 HOME-restore tooth, +5 licensed-wording/tripwire
assertions, −1 retired assertion that required the old provenance sentence. For the
first time the reported total is **measured equal to the assertions executed**, two
independent ways (a `$BASHPID` census — 578 executed, 0 in a foreign pid — and a
printed-line count).

**578 / 0 failures:** builder ×3 consecutive (e1-control, runs 8, 9);
**chair final hand ×1 — 578 printed `✔ PASS`, 0 printed `✘ FAIL`, exit 0**
(this sitting, after 13b; the chair's run-count cross-check used the printed-line
method). Every count is an **environment-conditional fact of this host** — git
2.43.0, GNU bash 5.2.21, Linux 6.18.33.2 (WSL2, x86_64) — and zero failures may
travel only with the exact asserted set and these limits. One additional
count-hygiene note carried per PLUMB: transcript `b1`'s "40 iterations" figure is
**compressed, not exhibited** (Q9-O1).

## Evidentiary limits (stated, not shrunk)

1. `~user/` firing is proven **only where `unshare -rm` works**; elsewhere the tooth
   reports UNTESTED and the requirement stands undischarged on that host.
2. The config-error state is exercised for a malformed config returning 128; on this
   git a **multivalued** `core.hooksPath` is rc=0/last-value → PRESENT-NONEMPTY, not
   a config error.
3. The guard audit checks **soundness, never provenance**: a well-forged guard
   satisfying every read is indistinguishable from a sibling's. The cure removed a
   false claim; it did not add a true one about who acted.
4. **Q9-F3 open** (above). 5. A **clock-order false RED under legitimate concurrent
   appends** was demonstrated **pre-existing** on the pristine subject (`b2`; a 40-run
   probabilistic attempt failed to reproduce first — `b1` — and is filed as a failure
   to reproduce, not an absence). Unrepaired, out of scope: loosening the clock rule
   to green a tooth is the wrong trade. False RED is the safe direction of error and
   still a defect.
6. The lab's `session-checkpoint` Stop hook committed in-flight builder edits
   several times across both rounds (`273b1dfa`, `0271a928`, `8405f69b`, and later);
   it commits locally and never pushes. The builders made no commits and no pushes;
   the round-13 pristine baseline is pinned by revision (`26949d44`) with digests
   printed inside the Phase-A transcripts precisely because of this.
7. Q9-O2 (guard faults counted against the record count in verify's summary line)
   and Q9-O3 (a symbolic-ref guard classified by its target, symbolic nature
   unnamed) are open observations.
8. Four sequential cold seats have each found a rung above the previous cure, and
   this round's verifier found one more inside the instrument itself. There is no
   reason to believe this rung is the last. The builder's own sentence is carried:
   *"I did not find these four either."*

## Standings (unchanged — no premature closure)

TD-6 OPEN (approved in principle only; no live action) · TD-7 OPEN (first real
transport UNREACHED) · TD-8 OPEN · TD-9 OPEN (IMPLEMENTATION-CANDIDATE / OFF-HOST
DURABILITY UNREACHED; guard refs are host-local custody protection — a missing guard
means "reconciled before this mechanism," never "free to duplicate"). Channel Policy
/1 blob `180734f6…` untouched and NOT adopted; mirror unmoved; live custody zero
(zero `refs/latent-lisp/` refs in the lab — verified this round by QUAESTOR, not
assumed). No predecessor instrument or report rewritten (round 13b and QUAESTOR
round 9 are appends; the seventh disposition is archived verbatim). All prior voids
and both dated corrections stand.

**Unexecuted this round, by boundary:** no owner acceptance · no TD closure · no
CP/1 adoption or modification · no branch-to-main integration · no public-mirror
transport · no publication authorization or PUBLISHED standing · no live TD-6
deploy-key/ruleset/credential action · no live TD-9 off-host durability action · no
changes to GitHub rulesets, branch protection, deploy keys, applications,
credentials, or the public mirror · no live `/etc/passwd`, account, or hook-config
changes (the namespace bind-mount never left its namespace).

## The parcel (independently executable — the successor-6 gap closed)

Successor-6 shipped patches against a private base a fresh reviewer could not see.
This parcel closes that with **both** of Sol's options: **(a) a self-contained git
bundle** (`tr1-successor7.bundle`, three commits: campaign base = lab `9b5ae663`
tools tree · successor-6 subject = lab `26949d44` · successor-7 subject = lab
`a9494384`; no lab history; `git clone tr1-successor7.bundle` reproduces all three
states cold) and **(b) the exact executable trees in the clear** (`base-tree/`,
`successor6-tree/`, `subject-tree/` — content digests above, matching the lab
commits, recipe in `environment.txt`). Plus: the seventh disposition verbatim ·
cumulative tools delta (base→successor-7) and immediate tools delta
(successor-6→successor-7) · full branch changed-file inventory (nothing hidden:
the branch also carries unrelated session work, listed) · builder report (rounds
1–13b entire) · verifier report (rounds 1–9 entire) · all 27+ planted-failure and
replant transcripts · environment and git-version facts · `MANIFEST.sha256` ·
basename-only outer `.sha256` sidecar. **Executable path, walked not assumed:** the
suite self-locates via `git rev-parse --show-toplevel`, so the runnable form is the
bundle — `git clone tr1-successor7.bundle w && bash w/tools/latent-lisp/teeth-td6-td9.sh`
(chair-walked from the sealed bytes in a bare directory; the bare `subject-tree/` copy
is for inspection and diffing and **fails at startup as received** — `fatal: not a git
repository` — unless first made a repo). This sentence replaced an earlier draft that
claimed the bare tree runnable; the claim failed its own walk and is corrected here
rather than shipped.

**Do not describe successor-7 as accepted, integrated, adopted, complete, or as
closing any TD. Returned for a new cold seat.**

*— chair, 2026-08-16. Claude Fable 5 (1M context). The transaction is the law; a
count that cannot bleed is not a count; existence is not testimony; the sentence
each tool prints is now, to the best of five hands' knowledge, a fact something
read. Still, correctly, NOT ACCEPTED.*
