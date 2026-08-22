# CHANNEL TOOLING REPAIR /2 — RETURN (2026-08-17)

**CANDIDATE ONLY. Nothing here is accepted, closed, or independently verified.
TD-10 and TD-11 remain OPEN and continue to block `SYNC-PAUSED` removal, public-mirror
transport execution, and reliance on post-merge automatic transport. Both verifying
hands are same-root with the builder and with each other — the STRANGER AUDIT IS OWED.
Closure of any TD is a separate owner act after the new cold seat.**

## What is returned

The TD-10 + TD-11 gate repair, two build rounds and two adversarial rounds deep:

- **TD-10 cure** (`tools/latent-lisp/post-merge.sh`): transport eligibility after a
  merge is decided by the **net governed-tree change between independently established
  endpoints** (`ORIG_HEAD` → `HEAD`, both resolved to full shas), per the owner's
  structural invariant — never by the tip commit alone. Unestablishable endpoints emit
  `ENDPOINTS-UNESTABLISHED` and launch conservatively under distinct provenance; they
  never read as irrelevant. Net-tree equality ⇒ `NO-TRANSPORT-DUE` (stated limit: says
  nothing about mirror drift). `git merge --squash` ⇒ `SQUASH-PENDING-COMMIT` (decision
  handed to the later commit); `PRE == POST` ⇒ `HEAD-UNMOVED`; both decided before any
  comparison. No symbolic ref can reach `sync.sh` from the gate (40-hex choke in
  `launch()`; the round-1 `${POST:-main}` fallback is dead).
- **TD-11 cure** (`tools/latent-lisp/post-commit.sh`, under SCOPE EXTENSION 1): merge
  commits arriving via `git commit` (conflicted merges; `--no-commit`) are gated by net
  governed-tree change **against the first parent** — same rule as the post-merge gate;
  design defended in the build report and discriminated from a `-m` union gate by a
  dedicated tooth ("ours"-merge: proves `-m` *would* have fired, first-parent correctly
  does not).
- **Provenance cure** (`tools/latent-lisp/sync.sh` — flagged: this widened the diff
  surface beyond the two hooks, chair-authorized in round 2): the durable record's tool
  field now carries launch provenance (`"tool":"sync.sh(via=post-merge)"`,
  `…(via=post-merge-endpoints-unestablished)`, …) through an anchored allowlist;
  non-canonical values drop; provenance labels and can never redirect behavior.
- **Teeth** (`tools/latent-lisp/teeth-td10.sh`, new file): **195 assertions**, every
  case measured RED under a deliberately wrong gate (OLD / ALWAYS / NEVER plants —
  TD-10's lived shape reproduced exactly: old gate, 0 launches, empty log) before its
  GREEN. Items 2–8 of the commission covered, including a truthful WITHHELD under a
  harness sentinel and transport verified **by content** against a disposable local
  bare remote.

## Verification of record (whose hands, exact counts)

| Hand | teeth-td10.sh | teeth-td6-td9.sh (accepted) | Notes |
|---|---|---|---|
| FERRARIUS (builder) | 106/0 r1; **195/0 ×2** r2 | **680/0** | 3 self-caught tooth-authoring failures, reasons written into the teeth |
| QUAESTOR (adversary) | **195/0 ×2** | **680/0** (proven to exercise the *cured* sync.sh) | 7 planted faults, **all bled** (9/3/8/3/3/2/3); 7 merge shapes vs TD-11, none broke it; 19 hostile `LATENT_LISP_VIA` values, allowlist held; 40-hex choke fuzzed, all refused |
| Chair | **195/0 ×2** | **680/0** | sentinel sha + accepted-suite bytes verified independently |

`install-hook.sh --verify` GREEN (builder + adversary). `teeth-td6-td9.sh` **byte-
identical to the accepted blob** (`git diff 214c2c90` empty, all three hands). The
accepted suite bit the builder once in round 1 (TOOTH-TD-8 byte-assertion vs a
refactor) — the subject was adapted to the tooth, never the tooth to the subject.
Sentinel `tools/latent-lisp/SYNC-PAUSED` sha256 `9b741ed1ac721dca…` identical at every
hand's start and end. Caps held all rounds: no lab merge, no mirror contact, no
TD-6/TD-9 action, no lab_state/legacy-custody ground, builders committed nothing.

## QUAESTOR's verdict and the findings disposition

Round 1 (`_staging/tr2-quaestor-round1.md`, 543 lines): four CONFIRMED findings —
three cured in round 2 (false §5 provenance claim → mechanism made truthful with the
round-1 behavior planted as the RED arm; misleading squash verdict → distinct state;
`${POST:-main}` symbolic-ref race → dead), one HIGH pre-existing → owner-docketed
**TD-11** + SCOPE EXTENSION 1, cured in round 2. Round 2
(`_staging/tr2-quaestor-round2.md`, 428 lines): **SEALABLE-AS-CANDIDATE**; both of the
builder's "untestable" defensive branches converted to **shim-verified** (PATH shim:
`NET_RC != 0` → conservative launch naming git's real exit; post-commit merge-endpoint
failure → honest no-decision); one new finding **Q2-F1 (LOW, pre-existing, carried
open):** a root commit carrying governed content is invisible — named for the cold
seat, not cured, practically unreachable on lab `main`.

## Honest voids (carried, not converted, for the cold seat)

- **`ORIG_HEAD` freshness has no proof** (QUAESTOR F5, deliberately uncommissioned):
  `ORIG_HEAD` is also written by reset/pull/rebase; staleness across exotic flows is
  not discriminated. Next-rung candidate.
- **Q2-F1**: root-commit-with-governed-content invisible (LOW, pre-existing).
- post-commit's ordinary launches deliberately carry **no provenance**.
- The two defensive branches are **shim-verified, not production-verified**.
- No endpoint-order tooth; the 40-hex choke is SHA-1-shaped (a SHA-256 repo would
  need it revisited).
- Root-context run (`641/0` class from successor-9) **not reproduced this round**.
- **The working tree was LIVE during both build rounds** — the lab's own hooks
  executed in-progress cures (evidence: the Stop-hook checkpoints `7292927e`,
  `7c16e254`, `7d2d9b0a`, kept unrewritten; and the unplanned live confirmation: the
  chair's governed commit `3b6dfc25` ran the cured `sync.sh` 39 seconds after it was
  saved and recorded a truthful WITHHELD with the accepted unset-provenance form).
  Working-tree-is-live is a standing fact of this harness (§I-j), reported at its size.
- **No independence anywhere in this return:** builder, adversary, and chair are one
  root. Every "verified" above is same-root verification. The NEW COLD SEAT and the
  stranger audit are what stand between this candidate and any acceptance.

## Chain

Commission `7086947a` → round-1 candidate `5a70031b` → QUAESTOR r1 → TD-11 docket +
SCOPE EXTENSION 1 `3b6dfc25` → round-2 cures (checkpoints `7c16e254`, `7d2d9b0a`) →
QUAESTOR r2 (SEALABLE-AS-CANDIDATE) → chair verification → this return. No
predecessor document is rewritten; the build report's round-1 §5 false claim is
struck visibly, not silently.

## The parcel

`~/Downloads/tr2-candidate-2026-08-17.tar.gz` + `.sha256` sidecar (outer hash lives in
the sidecar and the session readback — never inside the parcel). Contents: this
return, the commission + extension, the TD docket, both QUAESTOR reports, the build
report, the subject files, a per-file manifest (18 entries, cold-extract verified
18/18 OK), and a git bundle of the candidate commits.

**CORRECTION (same sitting, walk-the-recipe): the first draft of this section said
"the cold seat needs nothing from this host but the parcel." That was an overclaim,
caught by actually verifying the extracted bundle:** `git bundle verify` reports the
bundle **requires prerequisite `2ac0a615`** — it is a range bundle
(`2ac0a615..9e0dde0b`); commit-history materialization therefore needs a lab clone.
What IS standalone: every document, every subject file, and the manifest — the parcel
**reads** cold in full; only replaying git history requires the repository. (Caught
alongside a second instrument-side slip worth recording: the chair's first bundle
check ran outside a git repository, errored, and a pipeline exit swallowed the error
under a pre-written success line — a self-manufactured false GREEN, noticed because
the error text printed above it. The verify was redone from inside a repository;
`verify-exit=0`, prerequisite as stated.)

*— recorded by the chair, Claude Fable 5 (1M context), 2026-08-17. Candidate returned;
nothing claimed beyond what three same-root hands can license, which is: the teeth are
green, the teeth can bleed, and the stranger has not yet looked.*
