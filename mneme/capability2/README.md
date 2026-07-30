# capability2 — Capability /2, the effect-frontier candidate

> A recognized, current capability may justify attempting one exact
> protected effect — but neither the capability nor its presentation
> receipt proves that the effect occurred.

The smallest executable **candidate** in which a Mneme capability finally
**touches a world** — one exact cell write in a bounded, durable
(declared, not proven — see the limits below), deterministic fixture —
under the Kernel /0 effect-frontier discipline (§10): declared before
the frontier, authorized by a **named subset** of the §11.4 check,
journaled as `attempt:prepared` and `attempt:frontier-crossed` before
dispatch, acknowledged as **testimony with no settling force**
(AP-ACK-4), settled **only** by evidence verified against the surviving
world, and — when the process ends between the dispatch and the
acknowledgment (a planted deterministic early exit; no SIGKILL, no real
crash — RETURN §2.10) — the no-blind-retry prohibition survives in the
durable journal **in two halves, only one of which is kernel law**: the
surviving `attempt:frontier-crossed` frame with nothing after it is
refused by **this lane's own W1 pre-declaration adjudication** (§10.3 +
AP0 W1/AP-CRASH-4 — the restart refuses at [P016] *before* any §10.8
record exists), and only once the restart **structures** the §10.8
uncertain-effect record from journaled facts [P019] does kernel /0's own
§14.1 [UNC-1] fold carry it [P020]. See `CAPABILITY-2-RETURN.md` §2.5.

The lane's one novel seam, named as such: **the join of two demonstrated
halves.** core0 demonstrated no-innocent-retry in memory (its own
packet's boundary: "Nothing here demonstrates crash-survival. The event
sequence survived because the image did" —
`language-core-0/de-ponte-usto/HYPOTHESIS.md`, read at review time, not
by the builder); journal0 demonstrated restart without effects; this
lane executes the join — the retry prohibition carried across a process
death by durable bytes, against a world that survives the process while
the process's memory does not. Concretely that required **rehydration**
(`rehydrate.lisp`): journal0's own kernel-event projection carries a
named gap (stored CD/0 bodies are not rehydrated into live kernel /0
records), so a journaled §10.8 record — journaled same-life on an
ambiguous acknowledgment, or by a restart structuring what a dead
process left unaccounted — could never reach the kernel /0 fold that
enforces its retry-policy; this lane rebuilds the live records from
bytes through kernel /0's **own validating constructors** and feeds
kernel /0's **own** `check-retry-safety`. Scope of that claim: this
lane's own six event shapes, under a closed vocabulary — not a general
PJ0-to-kernel0 bridge.

**Status: candidate.** Not adopted, not frozen, no floor, no stranger
audit; all greens are same-family self-consistency. Substrate statuses at
first mention: **capability1, capability0, and journal0 are themselves
candidates** (not audited, not adopted, not frozen; journal0's PJ0 §32.5
FULL is NOT claimed) — nothing here inherits a guarantee from them.
Kernel /0 and AP0 are adopted **specifications**; consuming their text and
(for kernel0) the smoke-checked partner implementation imports no
conformance: **no AP0 conformance is claimed** and the world below is a
**controlled effect adapter under a labeled AP0 subset** — and therefore,
**under AP-CON-1** (a fake adapter is not a separate weaker species),
deliberately **not called an AP0 adapter at all**.

**Two honest limits, stated here because this page makes the claim:**
the interruption is a **planted deterministic env-var early exit** in the
adapter's acknowledgment path — **no SIGKILL, no real crash-window byte
truncation** is claimed or exercised (`journal0/de-teste-occiso` owns
those); and **durability is declared, not proven** — FINISH-OUTPUT only,
**no fsync claim**, journal0's own standing. What is exercised is
byte-equivalent, in surviving state, to a death in that window; the
claims rest on the surviving bytes, not on the death mechanics.

**This lane is NOT "Vertical Specimen /0."** It is honestly a first,
deliberately partial inhabitant of the Deterministic-fake-adapter board
lane, and four distances from VS/0 are declared here at the front door:

1. **ONE interruption point only** — the dispatch↔durable-acknowledgment
   gap (board point 2; the AP0 W1 situation). Board points 1, 3, and 4
   are untouched.
2. **No streams, no chunks, no ordering, no journal-before-delivery** —
   nothing of AP0 §10 is implemented.
3. **No derived final view and no finalization-loss trial.**
4. **No AP0 descriptor completeness and no AP-FAKE-3 terminal-fixture
   coverage** — no AP0 conformance language anywhere, and nothing in this
   lane is described as "independently verified" (AP0 adoption riders).

Said plainly: **Vertical Specimen /0 is not claimed; its four-trial
obligation and its capability-interaction, duplicate-behavior, and
negative-control obligations remain entirely open.**

The Kernel reserved verbs stay unclaimed: §19.5 `check-capability` (this
lane implements a SUBSET of §11.4 — no budgets, counts, roles, or
expiry), §19.3 `prepare-effect` / `cross-frontier` / `settle-effect` /
`record-bounded-effect` / `record-indeterminate-effect` /
`compensate-effect`, §19.2 `begin-attempt` / `reconcile-attempt` /
`supersede-attempt`, and the §19.4 manifestation verbs; `perform` and
`mint-capability` are occupied by `lisp-plus-core0` and are not touched.
The entry points are the deliberately unreserved `authorize-effect-attempt`
· `attempt-protected-effect` · `declare-uncertain-effect` ·
`reconcile-uncertain-effect`.

## Layout

| file | contents |
|---|---|
| `package.lisp` | `#:lisp-plus-capability2` public surface; the four `:import-from` lists are the consumed substrate surface |
| `load.lisp` | dependency order: capability1 (which loads capability0 → journal0 → CD/0 + smoke-checked kernel0) → this lane |
| `conditions.lisp` | the seven own-minted typed conditions, each with its why-not-substrate adjudication inline; the reuse list (kernel0's `unsafe-retry`, `duplicate-attempt-identity`, `unstructured-uncertainty`, `reconciliation-insufficient` are signaled, never re-minted) |
| `world.lisp` | the world: a controlled effect adapter under a labeled AP0 subset — CELLS.txt + REQUEST-LEDGER.txt, durable, deterministic, scripted, **no idempotency** (§14.5), with the planted env-var interruption point in its acknowledgment path |
| `events.lisp` | the journaled effect-event shapes (the PJ0 crash-window fixture grammar, envelope and bodies) + `derive-effect-standing` (the fold; no stored flag exists to consult) |
| `rehydrate.lisp` | **the novel seam**: stored bytes → live kernel /0 records (through kernel0's own validating constructors) → kernel0's own `check-retry-safety`; plus the pre-declaration W1 half; the extension-event adjudication lives in this file's header |
| `authorize.lisp` | `authorize-effect-attempt` — the §11.4 NAMED SUBSET, bullet by bullet, with the not-implemented bullets named; produces the prefix-bound authorization-to-attempt receipt (never journaled) |
| `attempt.lisp` | `attempt-protected-effect` — the §10.4 preflight in adjudicated order, the §10.3 frontier, dispatch, acknowledgment-as-testimony, evidence-derived settlement or §10.8 structuring |
| `reconcile.lisp` | `declare-uncertain-effect` + `reconcile-uncertain-effect` — §10.8 structuring and §14.2/UNC-2 evidence-carrying resolution, both branches (applied / not-applied) first-class |
| `mutants.lisp` | `+planted-defects+` (`:ack-promotes-to-settled`, `:auto-retry-on-uncertain`, `:stored-resolved-flag`) + `run-mutant-kill` |
| `capability2-selftest.lisp` | 29 unit checks incl. the rehydration seam, the two-half retry gate, laws 1/2/6, all three mutant kills, and the planted-fault gate tooth |
| `capability2-controls.lisp` | 27 checks: the owner's vertical end to end + the negative controls, each naming the exact typed condition/decision that fired |
| `de-effectu-incerto/` | the inhabited uncertain-effect restart specimen (separate OS processes; death in the acknowledgment window; preserved raw artifacts incl. BOTH journal states and the world files) |
| `RUN-*.txt` | raw transcripts + `RUN-EXITCODES.txt` (exit codes, determinism shas, gate teeth) |
| `ALLOWED-SOURCES.md` | exposure fence (documents exposure; written at lane close and says so — no pre-coding ordering claim) |
| `CAPABILITY-2-PROVENANCE.md` | every file this hand opened |
| `CAPABILITY-2-RETURN.md` | **the deliverable**: what is demonstrated, design adjudications, what is NOT claimed |

## Run recipe (from the latent-lisp root; SBCL 2.4.6)

```
sbcl --script mneme/capability2/capability2-selftest.lisp                  # 29 checks, exit 0
sbcl --script mneme/capability2/capability2-controls.lisp                  # 27 checks, exit 0
sbcl --script mneme/capability2/de-effectu-incerto/run-specimen.lisp       # 29 checks, exit 0
```

Regression gates stay green beside it: capability1's candidate suites
(30/0 selftest, 27/0 controls, 29/0 specimen — transcript byte-identical
to its committed capture), capability0's (28/0, 36/0, 24/0
byte-identical), journal0's (66/0 selftest, 89/0 vectors), and the CD/0
floor `bash mneme/verify-all.sh` (6/6). Exit codes + determinism proof:
`RUN-EXITCODES.txt`.

— CLAVIGER-III (Claude Fable 5 subagent), 2026-07-30
