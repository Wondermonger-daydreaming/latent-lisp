# SURFACE-2-CONTRACT — Language Surface /2: Outcomes Keep Their Axes

**Authorized by:**
`mneme/RULING-vertical0-closure-language-surface-2-2026-07-30.md` (§5).
**Committed BEFORE any implementation code of this lane exists** (the
commit is the ordering proof). Scope G1 only: outcome pattern matching
that keeps its axes. The governing sentence:

> Lisp+ may make the honest path shorter, but never by shortening the
> evidence carried home.

**Owner adjudication of the Surface /1 integration collision (recorded
2026-07-30, via live interview):** Surface /1's construct table is
deliberately closed (its RETURN declares the closure law; no public
registration point), so the charge's "pass through the existing
Surface /1 discipline" and "do not modify Surface /1" cannot both hold
literally. **Ruled: Surface /2 implements its OWN expansion-receipt
discipline, S1-shaped, meeting the charge's five bullets — exact source
form · exact expansion · macro identity/version · expansion receipt ·
no semantic-preservation overclaim — with ZERO Surface /1 edits, plus a
negative control proving the real Surface /1 honestly refuses this
lane's foreign heads (`:not-a-known-surface-construct`) and a path-diff
proving `language-surface-1/` byte-unchanged.** Builder model ruled:
Fable core + Opus support.

## 1. The empirical ground (LEXICON survey, chair-adopted)

No composite outcome object exists in the stack: the four axes are
derived from four unrelated sources, joined by format-string identity
conventions, and read through erasure-prone helpers (`body-string`'s
NIL means absent OR wrong-type OR empty; `(or ap0 vertical)` provenance
discards; `multiple-value-bind (standing)` drops the evidence plist;
NIL-dropping plist→record construction). The inhabited-vertical target
is `%derive-seat-outcome` (`vertical0/program/census.lisp:49-108`) —
pure, fixture-drivable without the campaign, four axes, hand-written
cross-axis and totality guards, and a pre-built kill-grammar in
`defects.lisp`. Vertical /0 files are **read-only** to this lane.

## 2. The outcome object — `seat-outcome` (reified, complete, read-only)

A struct (package `#:lisp-plus-surface2`), constructed ONLY by
`derive-seat-outcome (store events seat-id &key namespace)` over the
same public predecessor APIs the census uses. Slots (all read-only):

- `seat-id` · `attempt-name` (identity — derived once, carried as value)
- `execution-standing` (keyword from cap2 `derive-effect-standing`) and
  `execution-evidence` (the details plist — RETAINED, never dropped)
- `manifestation-status` · `no-payload-state` ·
  `manifestation-provenance` (`:live` / `:derived-recovery` /
  `:none` — the `(or …)` erasure is forbidden; provenance is a slot)
- `effect-standing` (the census's effect string, derived by the same
  laws) · `chunks-preserved` (integer or `:not-applicable`)
- `refusal` (`nil` or a retained refusal description: condition type
  name + journaled detail/disposition — type and explanation kept
  distinct)
- `interpretation-class` (string or `:not-interpreted`)
- `field-standing` — per-facet three-state reader law (§3)
- `source-events` (the event list consulted — the witness retained)

**Absence is typed, never NIL-punned:** every facet reader returns
`(values value standing)` where standing ∈ `:present` /
`:absent-from-evidence` / `:malformed-in-evidence`. The `body-string`
three-meaning NIL is structurally impossible through this surface.

## 3. The two forms

**`(with-outcome (var derivation-form) body…)`** — evaluates
`derivation-form`, refuses (typed, `surface2-not-an-outcome`) unless the
value is a `seat-outcome`, binds `var` for `body`. The complete object
stays bound; nothing is projected away.

**`(match-outcome var (clause…)… (otherwise …))`** — clauses test axis
facets; the expansion:

- requires `var` be bound to a `seat-outcome` (same typed refusal);
- **requires an explicit `otherwise` clause** — a match without one
  refuses AT EXPANSION (`:non-exhaustive-match`); the `otherwise` body
  receives the whole outcome (unmatched context preserved);
- refuses duplicate patterns (`:duplicate-pattern`) and patterns
  shadowed by an earlier equal-or-wider pattern (`:unreachable-pattern`)
  AT EXPANSION;
- clause patterns name axes explicitly — e.g.
  `((:execution :crossed-unsettled) …)`,
  `((:manifestation "present-partial") …)`,
  `((:refusal budget-ceiling-exceeded) …)`, conjunctions allowed —
  and may destructure selected facets into clause-local bindings;
- **the parent outcome remains bound in every clause body** — no
  expansion path reduces the outcome to payload-or-NIL, success
  boolean, manifestation alone, or exception-or-value;
- cross-axis conjunctions express the census's hand-written guards
  (e.g. projection-present ∧ execution-not-settled is writable as a
  clause that REFUSES — the guard becomes structure).

**Forbidden inferences (no pattern vocabulary may express them; the
controls prove the expansion cannot conflate):** execution from
manifestation · truth from parseability · settlement from
acknowledgment · safe retry from failure · zero cost from missing cost.

## 4. The Surface /2 expansion discipline (S1-shaped, own package)

Mirrors Surface /1's shape without touching it: a closed construct
table (`with-outcome`, `match-outcome` — two rows, this lane's own
namespace `("lisp-plus-surface2" "construct")`); grammar/procedure/
policy identities + versions (all start at 1); request/perform doors
returning retained receipt structs carrying: source-form CD/0 datum +
digest identity · expanded-form datum + digest identity · construct
identity · operation + disposition · the three versions; a typed
refusal catalog (protocol refusals vs integrity alarms kept distinct)
including `:non-exhaustive-match`, `:duplicate-pattern`,
`:unreachable-pattern`, `:source-form-not-a-call`,
`:not-a-known-surface2-construct`, `:occurrence-tag-not-identifier`;
**the inherited forbidden vocabulary** (Form /2 + Surface /1's list:
repair/preserved/equivalent/normalized/…/hygienic/same-meaning/
faithful/verified/sound — none in any disposition, receipt field,
refusal code, or fixture title). Receipts claim WHICH BYTES expanded to
WHICH BYTES under WHICH procedure — never meaning, hygiene, or
semantic preservation.

## 5. The inhabited vertical

`surface2-inhabited` re-expresses the `%derive-seat-outcome` passage
using `derive-seat-outcome` + `match-outcome`, then over the SAME
canonical fixtures (the preserved `vertical0/runs/campaign-1/exec`
journal and config, read-only) proves against the UNTOUCHED census
path: canonically equal decisions (the 12-seat outcome map byte-equal
as CD/0 encodings) · equal retained context (every facet the old path
read is readable from the new objects, plus the provenance/evidence
the old path dropped — the surplus is listed, never silently) · equal
typed refusals (the cross-axis guard and totality guard fire
identically on mutated fixtures) · journal effects not involved (the
passage is pure; stated, not waved). The surface may remove
repetition; the place where each standing-relevant choice is made must
remain visible in the rewritten passage.

## 6. Teeth (each fired live; a gate that has never fired is untested)

Refusal/exposure controls: branch discarding the effect axis (a clause
consuming manifestation while its body writes an effect conclusion —
killed by comparison against the census truth) · absent manifestation
treated as failed execution (mutant maps `:absent-from-evidence` →
execution-failed; killed: the true outcome's execution axis
contradicts it on a fixture where execution settled with absent
manifestation — seat-burned-draft) · present-invalid treated as
absence (killed on seat-broken-glass) · retry of an uncertain effect
(control proves the surface exposes `:crossed-unsettled` /
`:uncertain-unresolved` such that the CAP2-W1 scan still refuses; the
surface adds no retry affordance) · payload accepted while losing the
parent outcome (no such accessor exists; a mutant adding
payload-or-NIL is the planted defect, killed by the controls) ·
non-exhaustive match (expansion refusal, fired) · duplicate pattern
(fired) · unreachable pattern (fired) · missing expansion receipt
(every gate expansion checks its receipt exists and its digests
re-verify; a mutant skipping the receipt is caught) · runner
truncation (child with DIE env → exit 3, no RESULT sentinel).
Negative control vs Surface /1: the real `request-expansion` +
`perform-expansion` on a `match-outcome` form refuses
`:not-a-known-surface-construct`; `language-surface-1/` proven
byte-unchanged by path-diff.

Positive controls: every pattern class matches and RUNS its body on
lawful fixtures (all 12 campaign seats dispatched through
`match-outcome` with every clause exercised); universal refusal is not
ergonomic conformance.

## 7. Layout, gates, publication

```
mneme/language-surface-2/
  SURFACE-2-CONTRACT.md            (this file, committed pre-code)
  surface2.lisp                    (package + outcome + discipline + forms)
  surface2-selftest.lisp        →  RUN-SELFTEST.txt (+ -SECOND, byte-identical)
  surface2-controls.lisp        →  RUN-CONTROLS.txt (+ -SECOND)
  surface2-inhabited.lisp       →  RUN-INHABITED.txt (+ -SECOND)
  SURFACE-2-RETURN.md              (front door, claims ceiling)
  PATH-DIFF (in return or file)    (surface-1 + vertical0 byte-unchanged)
```

House gate style (check/note/RESULT sentinel, live counters, plant-fault
+ die teeth). Deterministic transcripts. Closed scope: no process DSL ·
no parallel seats · no joins · no cancellation/retry combinators · no
live provider · no Surface /3 · no stranger audit.

**Publication ceiling (verbatim):** Language Surface /2 candidate
constructed · outcome-pattern surface tested · Surface /1 expansion
receipts preserved *(this lane's receipts are S1-SHAPED under the
owner's adjudication; Surface /1 itself is byte-unchanged and its own
receipts undisturbed)* · one Vertical /0 passage re-expressed
equivalently *(equivalence = the canonical-equality demonstrations of
§5, never a semantic-preservation claim — the forbidden vocabulary
binds this document too)* · not audited · not adopted · not frozen ·
not on a governing floor.

*— Claude Fable 5, chair, 2026-07-30.*

---

## ADDITIVE CORRECTIONS (dated; the pre-code text above is unchanged)

### C1 — 2026-07-30, after implementation evidence: the unit-datum value

The real fixtures journal `no-payload-state` as a CD/0 unit datum on
manifested seats — a fourth evidence shape §2's reader law did not
enumerate. Adjudicated: typed as the VALUE `:declared-none` with
standing `:present`; the three-standing set is unchanged. Evidence had
been observed when this was adjudicated (RUN-SELFTEST [S007]).

### C2 — 2026-07-30, after implementation evidence: surplus facets

`seat-outcome` additionally carries an `evidence-class` facet (which
census evidence class the precedence selects) and exposes
`attempt` / `execution-evidence` in the destructuring grammar — beyond
§2's slot list, derived from facts already on the object, recorded as
surplus (RETURN §8.3). The §2 list is a floor, not a ceiling; nothing
listed was removed.

### C3 — 2026-07-30: one catalog divergence from the S1 shape

Surface /1's `:construct-not-a-macro` has no analogue here: both table
rows name macros defined in this lane's own file, so that state is not
constructible from outside — a code no caller can reach would be a
false affordance. Divergence documented in the catalog header.
