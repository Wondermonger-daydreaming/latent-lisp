# FABER-EFFECTUS-II — Language Core /0 substrate build report

*2026-07-24. Claude Code (Opus 4.8, 1M), substrate-wright, second of the name.
Jurisdiction: `experiments/latent-lisp/mneme/language-core-0/` only. All greens
below are **self-consistency certification** — no PJ0 reliance, no durability
claim, no AP0-conformance language anywhere.*

---

## 1. Files delivered (all under `.../mneme/language-core-0/`)

| File | Lines | Role |
|---|---|---|
| `core0.lisp` | 1039 | package `lisp-plus-core0`: `process-context`, `mint-capability`, `perform`, `outcome-kind`, `continue-from`, `why`/`render-core0-why`, the typed condition family + `signal-core0` + `with-core0-restarts` |
| `fake-courier.lisp` | 140 | package `lisp-plus-fake-courier`: deterministic scripted-subset adapter + private in-memory ledger world (4 fixtures) |
| `core0-selftest.lisp` | 342 | all nine work-order §1.4 teeth, each biting before cure, + the three-way-view extras |
| `CORE0-DEFECT-RECEIPT-0.md` | 60 | the one licensed `::` seam (`lisp-plus-slice0::*why-extractors*`) |

72 top-level definitions in `core0.lisp`; `perform`/`outcome-kind`/`continue-from`
each defined exactly once (dedup-checked). **`git status` confirms only these
new files; the frozen trees (`kernel0/`, `language-slice-0/`, `language-slice-1/`)
show zero modifications.**

## 2. Load chain

`core0-selftest.lisp` → `fake-courier.lisp` → `core0.lisp` →
`../language-slice-1/slice1.lisp` → `slice0-transmissibility.lisp` (pulls
`slice0-projection.lisp` → `slice0.lisp`) → kernel0 `load.lisp` (CD/0 + all 12
kernel0 modules in dependency order). Loads clean; the kernel0 foundations /
algebra / records+folds smokes print PASS during the chain. Runtime:
**`(lisp-implementation-version)` = "2.4.6" through the wrapper**
(`/home/gauss/.local/bin/sbcl` → `~/.local/sbcl-2.4.6/`), operation-checked
before every run.

## 3. Selftest output (verbatim tail, fresh image)

```
== Language Core /0 substrate teeth (self-consistency certification) ==
-- Tooth 1: bare-value return attempt --
  ok   T1 bite: a bare string where an outcome is required refuses — bit: caught MALFORMED-REQUEST
  ok   T1 cure: perform returns a structured 4-axis outcome, never a bare value
  ok   T1 cure: the manifestation is a record, not the bare payload string
-- Tooth 2: boolean summary attempt --
  ok   T2 bite: a boolean summary (t) refuses — bit: caught MALFORMED-REQUEST
  ok   T2 bite: a boolean summary (nil) refuses — bit: caught MALFORMED-REQUEST
  ok   T2 cure: outcome-kind is a keyword view, not a boolean — view=:COMMITTED
-- Tooth 3: ambient-authority attempt --
  ok   T3 bite: perform with :authority nil refuses (never reads ambient) — bit: caught AMBIENT-AUTHORITY-FORBIDDEN
  ok   T3 bite: a durable mint-receipt is refused as authority — bit: caught AMBIENT-AUTHORITY-FORBIDDEN
  ok   T3 cure: perform with an explicit live capability commits
-- Tooth 4: blind-retry attempt --
  ok   T4 setup: the kill produced an interrupted condition + evidence
  ok   T4 bite: a blind retry into the seat fires live check-retry-safety — bit: caught UNSAFE-RETRY
  ok   T4 cure: continue-from reconciles without retrying
-- Tooth 5: ack-settles attempt --
  ok   T5 bite: the attempt WAS acknowledged
  ok   T5 bite: despite the ack, the fold leaves the effect UNRESOLVED (ack≠settle)
  ok   T5 bite: an acked-but-bounded outcome-kind is :indeterminate, NOT :committed
  ok   T5 cure: after reconciliation the fold settles (unresolved-effect-p nil)
-- Tooth 6: duplicate-invocation-after-continuation --
  ok   T6 setup: the ledger holds exactly one row after the kill
  ok   T6 bite→cure: after continuation the ledger STILL holds exactly one row — rows=1
  ok   T6 cure: the continuation never re-invoked the adapter (row count is the witness)
-- Tooth 7: event-order violation --
  ok   T7 bite: frontier-before-prepared fires journal-illegal-transition — bit: caught JOURNAL-ILLEGAL-TRANSITION
  ok   T7 cure: the lawful order validates
-- Tooth 8: capability scope violation --
  ok   T8 bite: a :deliver capability refuses a :shred request (pre-frontier) — bit: caught CAPABILITY-SCOPE-VIOLATION
  ok   T8 bite: the refused attempt left NO ledger row
  ok   T8 cure: an authorised request commits, and a row lands
-- Tooth 9: quiet-zone leak --
  ok   T9 bite: a program touching a governed package is flagged — leaked: (PERFORM)
  ok   T9 cure: the ordinary abacus program references ZERO governed symbols
-- Extra: the three-way view (refused / committed / indeterminate) --
  ok   X refused: adapter refuse-before-frontier signals core0-refused — view=:REFUSED
  ok   X indeterminate: a W1 kill's outcome-kind is :indeterminate
  ok   X indeterminate: a withholding ledger yields an indeterminate continuation
== Core /0 substrate teeth: 29 passed / 0 failed ==
(self-consistency certification — no PJ0 reliance, no durability claim, no AP0-conformance claim)
```
Exit code 0.

## 4. Teeth-bite evidence (each fault fires its typed refusal BEFORE its cure)

All nine work-order §1.4 teeth bit. The refusing condition type is printed on each
bite line above ("bit: caught …"):

| # | Tooth | Bite (typed refusal caught) | Cure |
|---|---|---|---|
| 1 | bare-value return | `%require-outcome` on a string → **MALFORMED-REQUEST** (core0-refused) | perform returns an `outcome-p`; manifestation is a record, not the payload string |
| 2 | boolean summary | `%forbid-boolean-summary` on t / nil → **MALFORMED-REQUEST** | `outcome-kind` = keyword `:committed`, never t/nil |
| 3 | ambient authority | perform `:authority nil` (with a tempting ambient cap bound) → **AMBIENT-AUTHORITY-FORBIDDEN**; a durable mint-receipt as authority → same | perform with an explicit live capability commits |
| 4 | blind retry | live `check-retry-safety` on a retry-into-seat → **UNSAFE-RETRY** | `continue-from` reconciles without retrying |
| 5 | ack settles | acked-but-bounded standing stays `unresolved-effect-p`=T; `outcome-kind`=`:indeterminate` (not `:committed`) | reconciliation (the fold, not the ack) settles |
| 6 | duplicate after continuation | ledger row count = 1 before AND after continuation (never 2); continuation never re-invoked | — |
| 7 | event-order violation | frontier-before-prepared → **JOURNAL-ILLEGAL-TRANSITION** | lawful order validates (returns t) |
| 8 | capability scope | `:deliver` cap on a `:shred` request → **CAPABILITY-SCOPE-VIOLATION**, 0 ledger rows | authorised request commits, row lands |
| 9 | quiet-zone leak | machine-scan flags `(PERFORM)` in a governed-touching program | abacus program → ZERO governed-external references |

The no-blind-retry tooth (§4) is wired into the **real** `continue-from` path via
`%prove-blind-retry-unsafe`, which runs the LIVE kernel `check-retry-safety`,
asserts its `unsafe-retry` fires, then refuses to retry — so the central tooth is
not just a test but the enforced continuation mechanism.

## 5. Kernel0 regression gate (read-only, both runs)

| When | Result |
|---|---|
| PRE-work | `kernel0 selftest: 33 passed, 23 excluded (out-of-scope), 24 controls fired, 5 controls named-excluded, 59 mutants killed (56 independent + 3 re-attributions), 0 failed` |
| POST-work | `kernel0 selftest: 33 passed, 23 excluded (out-of-scope), 24 controls fired, 5 controls named-excluded, 59 mutants killed (56 independent + 3 re-attributions), 0 failed` |

**33 passed / 23 excluded / 0 failed both times — no drift.**

## 6. GAPS — every stretch / encoding decision, with its spec §

Each is the closest lawful encoding over kernel0's noun-layer; the chair adjudicates.

1. **`outcome-kind` is a ONE-argument projection over the outcome's own four
   axes** (not a two-arg function over events), matching the illustrative surface
   `(outcome-kind outcome)`. Faithful because `perform` builds the axes **from**
   its fold-derived lowering, so the axes are not self-report — a tooth (T5)
   cross-checks the outcome view against the independent `fold-attempt-outcome`
   standing. Spec: synthesis §3b ("a projection over the 4-axis × determinacy
   lattice"); Kernel §12.6/§13.6. Grade: **conservative authorial completion**.

2. **Pre-frontier refusal is encoded** as execution `:refused` (no
   frontier-qualifier) + effect `:not-entered` + manifestation
   `(:absent :state :refused-pre-effect)`, with a terminal `:attempt-refused`
   event and **no** `:frontier-crossed` event. This makes `outcome-kind`→`:refused`
   a pure lattice projection. Kernel §12.6 (refusal emits no frontier-crossed
   event), §9.2 (execution algebra). Declared encoding.

3. **W1-shaped kill is encoded** as execution `:failed` (`:post-frontier`) +
   effect `:bounded` referencing a structured `uncertain-effect` + manifestation
   `(:absent :state :withheld)` + terminal `:attempt-failed`. This is byte-shape-
   identical to kernel0 `load.lisp`'s own W1 records+folds smoke. Kernel §14.1,
   §10.8; AP0 §11 W1.

4. **Minimal capability** (synthesis §3a step 2, graded *conservative authorial
   completion, scoped*): liveness is a **fresh un-serializable cons token** (§11.2
   — not reconstructible from serialized fields; the tokenless `capability-mint-
   receipt` cannot rebuild it); the frontier check compares a scope plist and
   records the requested (adapter, predicate) as the equal-or-narrower effect
   scope (§11.4). **No revocation registry, no restoration flow** (lane 2's), per
   the work order.

5. **Adapter designators are KEYWORDS** (e.g. `:fake-courier`), not arbitrary
   symbols as in the illustrative `'fake-courier`. Forced: a bare symbol's package
   makes the capability-scope name and the adapter name fail to match across the
   `lisp-plus-fake-courier` / caller packages. Keywords are package-independent
   designators (AP0 §4 stable identity). Lawful designator choice; flagged so the
   chair sees the deviation from the illustrative bytes.

6. **`match-outcome` / `with-outcome` are NOT built** (work-order §2 / synthesis
   §3b): `match-outcome` is deferred library convenience; `with-outcome` is refused
   outright (unspecified semantics). Only the `outcome-kind` view ships.

7. **The manifestation uses the non-AP0 `:producer-identity` branch** (K0E-27),
   because the fake courier is a labeled non-AP0 scripted subset; a streamed /
   AP0-produced manifestation would require the `:adapter-identity` branch, out of
   scope. Manifestation §8.1 / Appendix A.2.

8. **`interpretation` axis is `:not-applicable` (commit) / `:not-attempted`
   (refused, kill)** — Core /0 performs effects, not interpretations, so no
   interpretation procedure is minted; both values are the two §9.5 cases that
   lawfully carry no procedure-id.

9. **The `why` `::` seam** into `lisp-plus-slice0::*why-extractors*` — one
   find-guarded load-time `push` of `(core0-evidence-p . identity)`, receipted in
   `CORE0-DEFECT-RECEIPT-0.md`, re-instancing exactly Slice /1's licensed seam.
   This is a runtime `defvar`-list extension, **not** a frozen-source edit; the
   owner ruling names `why` as shared substrate ("the extractor registry takes
   both"). No other `::` is used.

10. **`process-context`** carries the three shared context identities (process,
    logical-operation, seat), minted deterministically from a `:label`, so a
    continuation shares standing. It is a constructor-made object (receiver-context
    precedent), NOT a `with-…` macro (a binding macro would establish ambient
    standing — forbidden). Amendment-1 name honored (process-context, not
    consequence-context); its docstring axis is execution *standing*, distinct
    from derive's receiver-context evidentiary *position* (owner ruling).

## 7. What is NOT claimed (gates carried verbatim)

No PJ0 reliance; nothing survives image death; the fake courier is a labeled
scripted subset, never AP0-conformant; every green is self-consistency
certification (AP0 §24.1); no "independently verified/validated" anywhere. The
in-image continuation's own packet-truth: *the event sequence survived because
the image did — nothing here demonstrates crash-survival.* Specimens (work-order
deliverable 3) and `CORE-0-CLOSURE.md` (§1.5) are **not** in this jurisdiction and
were not built.

— Claude Code (FABER-EFFECTUS-II), Opus 4.8 (1M), 2026-07-24
