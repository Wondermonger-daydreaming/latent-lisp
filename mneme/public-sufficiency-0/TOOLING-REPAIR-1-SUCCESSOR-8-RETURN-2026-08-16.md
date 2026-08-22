# CHANNEL TOOLING REPAIR /1 — SUCCESSOR-8 RETURN (2026-08-16)

**TR/1 SUCCESSOR-8 RETURNED — NOT OWNER-ACCEPTED · NO TD CLOSED · MERGE GATE CLOSED ·
NO TD-6 OR TD-9 LIVE ACTION.**

Predecessor: successor-7 (return `TOOLING-REPAIR-1-SUCCESSOR-7-RETURN-2026-08-16.md`; Sol's
cited subject `4c5c6d7f…` = the sealed parcel's bundle tip, verified identical by content to
the lab tree at the pin — digest `003de65c…`), BLOCKED by Sol's eighth disposition —
**SOL-TR1-20** (resolved hook path ≠ effective git hook execution: the `.` and
trailing-newline forms) and **SOL-TR1-21** (skipped tooth ≠ inert tooth: TOOTH-SOL-TR1-06's
fixture before its root check contaminated the shared lab) — archived verbatim at
`corpus/voices/received/2026-08-16-sol-tr1-eighth-disposition-successor7-blocked.md`.
**Both findings CONCEDED, neither disputed**; both replanted chair-hand and builder-hand
against the exact cited subject before any edit (transcripts `f1`/`f2`/`f5`; the chair's
first newline plant FAILED — and the builder's byte-exact remeasurement `f4` then showed the
chair's stated lesson was itself wrong: *git stores what it is given; the LF died in the
chair's own `$( )` before git ever saw it*. The correction is carried here, not buried).
Successor-8 subject: lab `5e7abce1`, tools-tree digest `24e9cfcd…`; deltas vs successor-7
1409/54 (3 files), vs campaign base 4737/51 (7 files); `transport-record.sh` untouched by
this successor.

## SOL-TR1-20 — measured before modelled, then cured structurally

**The mechanism matrix (`f3`, chair-reproduced) is the round's discovery.** Relative values
were *not* the problem — `hp-rel`, `./hp-rel`, `sub/dir` fire from every cwd. Only `.`
fails, and it fails **dangerously**: `git rev-parse --git-path hooks/post-commit` returns
the bare name `post-commit`, and git resolves a bare name **through `$PATH`** — a planted
PATH decoy *ran* while the repository's own file did not (measured by builder and chair
independently). The trailing-LF form: `--get`, `--path --get`, and `rev-parse --git-path`
all faithfully carry the LF; the old tool's command substitution stripped it and then
*printed the stripped path as "git resolved:"* — the shell lying in the report. Git hooks
run with cwd = the toplevel (measured three ways), so the authority must be asked from
there.

**The cure (per Sol's clauses, all discharged):**
- Configuration bytes are read **byte-exact** (`git config --null`, sentinel-idiom capture)
  and **never rewritten** — unsafe forms are refused with the value displayed escaped, and
  the human decides.
- The effective hook path for **every** state comes from git's own
  `rev-parse --git-path hooks/<name>`, asked from the toplevel, byte-checked.
- **Accepted class, one line:** *the configured value carries no control bytes, git's own
  answer carries no control bytes, and that answer contains a directory separator.*
  Everything else fails closed: exit 5 (control bytes — the trailing-LF form) or exit 6
  (separator-free dispatch — the `.` form, refused with the PATH mechanism stated as
  measured). GREEN is never awarded to bytes in a computed directory.
- **Exact hostile plants**, as commissioned: `.` and trailing-LF (stored via config-file
  escape, the storage route that actually preserves the byte), each proving at commit time
  that git ran nothing while the old tool said GREEN, and that the cured tool refuses
  without rewriting. Every previously-proven firing form still fires (absolute, relative,
  `~/`, `~user/` in userns, `%(prefix)`), and QUAESTOR's fifteen-form hostile matrix
  produced **no false GREEN and no false RED** — including a `.`-class form nobody had
  named (`./`), UTF-8 paths, symlinked hook dirs, and a spoof-resistant sentinel check.

## SOL-TR1-21 — the tooth heals, and the class is swept

The fixture (lock-plant → gapped append → unplant) moved **inside the runnable arm** — *a
fixture that is never built cannot be left behind* — and the suite grew a reusable
skip-inertness guard: `lab_state` fingerprints custody markers, sidecars, claims, every
ref under `refs/latent-lisp/` with target, **every `*.lock`**, the **full recursive
evidence-tree listing**, and the verifier's exit code; `skip_guard_begin` /
`skip_guard_end` assert identity across every skip. **Nine sites, one convention** (begin =
the tooth's first line, before any fixture; end asserts on the skip arm, closes on the
runnable arm), **9 armed on both hosts**.

**Proven by plants, not readings:** Sol's contamination replanted on the pinned subject
under root — **518/16, exit 1**, sixteen downstream teeth inheriting the marker (builder
`f5`, QUAESTOR's own hand `q2-suite-PINNED-root.txt`) → cured suite under root **589/0**
with skips printing UNTESTED-stated-not-skipped and then *proving they left nothing
behind*. QUAESTOR's regression plant (fixture restored to its old position) originally
sailed past the guard (Q10-F4); after the bracket-placement fix the guard is **the first
failure, at the tooth** (`h2`). A planted stale `transport-record.lock` — formerly
invisible to the fingerprint — now takes the suite RED (`h1`).

## Verification — QUAESTOR round 10, carried whole, and the round-14b repairs

QUAESTOR round 10: **VERIFIED-WITH-FINDINGS** — both cure sets discharged clause-by-clause
by execution; custody chained by content from Sol's cited bundle tip to the lab pin;
say-did clean; boundaries clean. Its findings, all four **repaired in round 14b**, each
proven by a plant:

- **Q10-F1 (BLOCK-CLASS):** with `core.hooksPath` *absent* the tool still computed
  `$GIT_DIR/hooks` by hand → in a **linked worktree** it installed into
  `.git/worktrees/<n>/hooks`, certified GREEN, and git ran the common `.git/hooks` —
  inert install, false verdicts in both directions. *(Demonstrated on a stale worktree the
  chair itself had left registered from the morning's authentication — the chair's own
  scaffolding became the verifier's evidence; the worktree is removed and the scar logged.)*
  **Fixed:** the last hand-computed directory is gone — every state, absent included,
  asks git. New sixteen-assertion linked-worktree tooth: install, verify, and **actual
  firing** from the linked worktree against git's common-dir answer; the old behavior's
  state planted and required RED. One **headlined behavior change**: bare repo +
  configured `core.hooksPath` is now *accepted* (git's answer is taken), stated with its
  limit — no `post-commit` fires in a bare repo, so that form rests on git's word,
  unexercised.
- **Q10-F2 (DEFECT):** `lab_state` was blind to a stale ref `.lock`. Fixed + planted RED.
- **Q10-F3 (DEFECT):** four of nine guard sites had both calls inside the skip arm —
  guards that could not fail. Fixed by the single convention; execution reconciled per
  host (9 = 9+0 non-root, 9 = 4+5 root).
- **Q10-F4 (DEFECT):** the guard passed a regression of its own motivating defect
  (snapshot taken after the fixture had already dirtied the lab). Fixed by
  begin-before-fixture; the regression replant now fails at the guard.

## Teeth

| run | host | result |
|---|---|---|
| builder ×2 | non-root | **628 / 0**, identical |
| builder ×1 | root (`unshare -r`) | **589 / 0** |
| chair ×1 | non-root | **628 / 0**, exit 0 |
| chair ×1 | root (`unshare -r`) | **589 / 0**, exit 0 |

Reported total = printed assertions on every run (the 13b invariant, holding on both
hosts). Count history: … 568 → 578 (succ-7) → 612 (round 14: +34, the SOL-TR1-20 section)
→ **628 non-root / 589 root** (round 14b: +16, enumerably the linked-worktree tooth).
Per-host difference reconciled **by label diff, not arithmetic**: 628 − 50 skipped + 11
root-only = 589 (`g4`/`h3`). Against the pinned successor-7 subject the same both-hosts
comparison read **578/0 vs 518/16** — Sol's finding, reproduced twice, now closed visibly.
Every count is an environment-conditional fact of this host (git 2.43.0, bash 5.2.21,
Linux 6.18.33.2 WSL2; root = uid 0 in an unprivileged user namespace).

## Evidentiary limits (stated, not shrunk)

1. **The gate's authority is `git rev-parse --git-path`, and that authority is unprobed
   through the environment** (`$GIT_DIR`, `includeIf`, `--work-tree`, hostile env vars).
   If git's own answer can be made to lie, the cure lies with it. Named by the builder
   unprompted; the known next rung, offered.
2. Bare repo + configured `core.hooksPath`: accepted on git's word, unexercised (no
   commit-time firing exists to measure in a bare repo).
3. `~user/` firing still proven only where `unshare -rm` works; root runs prove uid-0
   behavior in a **user namespace**, not a genuine root login.
4. The clock-order false RED under concurrent appends (pre-existing, `b2`) remains open,
   deliberately unrepaired.
5. Q9-O1/O2/O3 observations stand; `b1`'s "40 iterations" remains compressed-not-exhibited.
6. The Stop hook checkpointed in-flight builder edits again (locally, never pushed);
   builders made no commits and no pushes.
7. Nine seats and ten verification rounds have each found a rung above the last cure —
   this round's were found by the verifier inside the guard machinery itself. The
   builder's sentence stands one round older and still true: *I did not find these
   either.*

## Standings (unchanged — no premature closure)

TD-6 OPEN (approved in principle only; no live action) · TD-7 OPEN (first real transport
UNREACHED) · TD-8 OPEN · TD-9 OPEN (off-host durability UNREACHED; guard refs are
host-local custody protection). Channel Policy /1 blob untouched, NOT adopted; mirror
unmoved; live custody zero (zero `refs/latent-lisp/` refs — verified again this round); no
predecessor instrument rewritten (rounds 13/13b/14, QUAESTOR 1–10, and both prior returns
intact; ROUND 14b and QUAESTOR ROUND 10 are appends). Q9-F3's two cold reproductions are
preserved in the record as the lineage of SOL-TR1-20, as commissioned. **Unexecuted
boundaries:** identical list to the successor-7 return — no acceptance, no TD closure, no
CP/1 act, no merge, no mirror transport, no publication, no live TD-6/TD-9 action, no
GitHub-settings or credential changes, no live `/etc` changes.

## The parcel

Same discipline as successor-7, extended one commit: **self-contained bundle**
(`tr1-successor8.bundle`, four commits: campaign base `9b5ae663` → successor-6 `26949d44`
→ successor-7 (Sol's `4c5c6d7f…` content) → successor-8 `5e7abce1`; no lab history) **and**
the four clear trees (digests `6277ee17…` / `72b87e8c…` / `003de65c…` / `24e9cfcd…`,
each matching its lab commit); the eighth disposition verbatim; cumulative + immediate
tools deltas; full branch changed-file inventory; builder report rounds 1–14b entire;
verifier report rounds 1–10 entire; all transcripts (a–h, q, q2); environment facts;
MANIFEST; basename-only outer sidecar. **Executable path, walked not assumed:** clone the
bundle, run `tools/latent-lisp/teeth-td6-td9.sh` from the clone (the chair walked this
from the sealed bytes; the clear trees are for inspection and are not git repos as
received).

**Do not describe successor-8 as accepted, integrated, adopted, complete, or as closing
any TD. Returned for a new cold seat.**

*— chair, 2026-08-16. Claude Fable 5 (1M context). Measured before modelled; refused
rather than rewritten; a skipped tooth now proves its own inertness; and the one door this
round closed hardest was the one nobody asked about — the bare name that `$PATH` was
allowed to answer. Still, correctly, NOT ACCEPTED.*
