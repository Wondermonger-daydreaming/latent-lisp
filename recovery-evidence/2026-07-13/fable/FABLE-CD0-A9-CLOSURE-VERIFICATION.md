# FABLE — CD/0 A9 Two-Vector Closure Verification (focused)

*Claude Fable 5, audit director, 2026-07-13 (night). Focused closure verification of the
single item returned under protocol `49b3cf88` (report `40462613`). Scope executed exactly
as pre-committed in the verification report's "On resubmission" section — nothing widened,
nothing reopened, nothing weakened. No modification, repair, merge, or push was performed
on the subject repository during verification.*

## OUTCOME

**PASS** — the sole returned item is closed. Integration commit
`369de53bff4ef5edbd31db3428456fde58d90cf5` is **eligible for merge into main**.
(The merge itself, per standing arrangement, is executed by the implementer/owner —
eligibility is the whole of this verdict's claim.)

## Per-item results (all observed first-hand unless noted)

| # | Item | Observed |
|---|---|---|
| 1 | Two permanent rows | **PASS** — `cd0-errata-a9-runtime-seq-unit-depth-one` (sole override `max_depth:1`) and `…-nodes-one` (sole override `max_nodes:1`), both `runtime-encode` of `{"t":"seq","items":[{"t":"unit"}]}` → `ok`/`4c50434400300100`; notes cite protocol `49b3cf88` |
| 2 | Generic path, both codecs, no special case | **PASS** — codec cores/adapters have ZERO diff in the delta (`git diff --stat` on `canonical-datum/{python,common-lisp}/` empty); I re-ran the hand differential myself: both ids answered by both codecs through `lisp-plus-cd0-differential/v1` with exact golden hex (my own artifacts retained) |
| 3 | Vector sha transition | **PASS** — old `55725e14…` (re-hashed from `851cffc2` blob) → new `731a74ed…` (hashed on disk) |
| 4 | Arithmetic | **PASS** — 39 promoted / A9=7 (counted from file); hand 467 = 25+71+325+7+39 recomposed from MY re-run (PASS, 0 issues, empty stderr); release 100,863 = last round's independently re-run 100,861 + exactly 2, with EVERY other count field identical between GAUNTLET's retained summary and the closure summary (field-level diff shown: only requests/A9/vector-count changed) |
| 5 | Phase-0 accounting | **PASS** — verifier exit 0 on closure tree: 71 = 66 octet + 5 host; Py 71 executed/0 N/A; CL 68 + 3 N/A; 0 failures, 0 skips; N/A ≠ pass |
| 6 | No semantic changes | **PASS** — positive/negative/budgets/distinct-pairs vector files byte-identical (same shas as prior round, printed by verifier); codec sources untouched; `mneme/` diff EMPTY; harness diffs read line-by-line: count constants 37→39 / A9 5→7, the new vector sha pin, test-count updates, and one addition (see Observations); historical comparator vs pre-errata baseline: zero protected differences (current invocation) |
| 7 | Protected projection | **PASS** — `21399286…` at both `baseline_projection_sha256` and `current_projection_sha256` in the closure release summary, whose input-hash block pins the new vector file and the unchanged fixtures |
| 8 | Ancestry / non-rewrite | **PASS** — all three new successors: trees exact (`c6107f2c…`/`14478ba8…`/`13871b0b…`), audited tips AND first errata successors both ancestors; fetch was fast-forward on all three (no force) |
| 9 | Remote main / no forbidden merge | **PASS** — `main` = `ae767f00…`; none of the four successor commits reachable from main |
| 10 | Split archive | **PASS** — part-00 94,371,840 B `4250bf49…`; part-01 13,852,034 B `2d433e14…`; concatenation 108,223,874 B `3414dbeb…` (all hashed by me); prior archives (`cd0-release-…`, `cd0-errata-0.1-…`) still beside; full remote ref sweep shows only the 7 expected cd0/main heads + the pre-existing `codex/v1-counterexample-closure` (commit dated 00:07−03 this morning, independent arc) — the failed oversized push left no ref debris |

Delta surface: 93 changed paths = the vector file + harness count-pins + receipts/ledger/
transcript addenda + new evidence tree + split archive parts + register append (0 deleted
lines; closure note honest: *"returned no semantic divergence; … only the absence of two
exact permanent A9 shared-vector instantiations"*). Nothing outside the authorized scope.

## Observations (non-blocking, for the record)

1. **A welcome addition:** `verify_phase0.py` now structurally asserts the two rows' exact
   shape (ids, AST, sole overrides, expected hex). The returned item is not merely fixed —
   it is enforced by the corpus's own gate from now on. Check-tightening scoped precisely
   to the authorized delta; not a §15.3 harness-behavior change.
2. **Comparator historical invocation:** `compare_errata_hand_baseline.py`'s count pin
   (37→39) means the first-closure documented command (against
   `transcripts/phase2-errata-0.1`, which frozenly holds 37) now fails BY DESIGN; the
   current invocation (against `evidence/a9-two-vector-2026-07-13/hand/`) passes with zero
   protected differences — I ran both. The transcript's supersession banner ("retained as
   factual transcripts of the first closure run; not the current focused-delta arithmetic")
   covers this. A one-line pointer naming the current comparator target beside the
   historical command would be a courteous future touch; it conditions nothing.
3. **Scope discipline:** the release differential was NOT re-fired by me — per the
   pre-committed resubmission scope, the release figure was verified by recomposition
   (prior independently re-run total + the exactly-2 authorized additions, all other count
   fields identical) against the retained closure summary whose corpus digest
   (`62a18766…`) and projection hash I checked. The hand differential, Phase-0, and
   comparator were re-executed by my hand.

## Post-PASS sequence (implementer/owner's, restated from the relay)

Merge `369de53b…` into main preserving provenance · push non-force · fresh remote
read-back · record merge commit/tree/parents + successor-ancestry confirmation ·
post-merge smoke set + protected projection · publish `CD0-MERGE-RECEIPT.md` · freeze
CD/0 implementation · open the located-claim identity chamber as its own arc.

— Claude Fable 5, audit director. Evidence: `scratch/fable-verify/closure-hand-run.json`
+ `closure-hand-artifacts/` (this repo), worktree `_staging/cd0-audit/wt-closure/`.
