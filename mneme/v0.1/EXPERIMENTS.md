# Lisp+ — Experiment Slate v0.1 (preregistered; numbers frozen before data)

Changes from v0 (per @event-005): open-ended completion RETIRED (target was
unknowable — success required clairvoyance or leakage); tasks are now
delimiter-completion, synthesis, repair, insertion, and the mismatch probe;
conditions B/D added; pairing moved to tree space; statistical
precommitments made numeric; E3 recosted; preflight audit is mandatory.

**PREFLIGHT (blocking):** no API spend until all ten gates in
AUDIT-0001-preflight.md pass, logged as observed events. Gate 8 is
*expected to fail* against the Python toy judge and thereby force either
E4 (Racket reader as judge) or an explicit synthetic-only scope declaration.
Lisp+'s first executed claim is whether its own experiment is structurally
capable of refuting it.

**Implementation-as-judge rule:** score by parsing and AST/semantic
comparison in ONE stripped representation; never string match; model-judging
only where flagged and always dual-classifier instrumented.

---

## Conditions (all experiments)

```
A  ordinary canonical Lisp
B  anonymous boundaries        (definition@ ... @end)
C  correct identity boundaries (definition@median ... @end:median)
D  consistent-arbitrary identity (definition@g4821 ... @end:g4821)
E  C + minimal halo (claims:/effects:)
F  A + tool loop (inspect/bindings available in-context)
M  mismatch probe: C with deliberately wrong @end label — separate item
   set, never mixed into A–E scoring
```

Mechanism decomposition: B−A = value of boundary tokens; C−B = value of
identity; C−D = value of *meaningful* identity vs any consistent label.
Token matching is measured on the PROMPT SENT with each target model's
actual tokenizer; spread ≤2% (preflight gate 6). Comment padding is a
fallback control only — B/D are the real controls.

## Tasks (paired in tree space: one abstract intervention on the canonical
AST, rendered into every condition — preflight gate 3)

- **delimiter-completion** (primary): all semantic tokens + opens shown;
  the trailing closer suffix (and boundary tag, per condition) removed.
  Ground truth is forced by balance — knowable (preflight gate 5).
- **synthesis**: canonical AST supplied; emit source; judge by
  parse-to-AST equality.
- **repair**: one specific node's closer blanked (same node across
  conditions); judge by AST equality with original.
- **insertion**: registry-validated node path (preflight gate 4); judge by
  AST diff = exactly the intended edit.
- **mismatch detection** (M items): model asked to complete/repair; score
  whether it FLAGS or CORRECTS the label mismatch vs completes around it.
  Direct test of the checksum function: a checksum nobody verifies is
  dead weight.

---

## E0 — Headroom calibration
- **Claim:** models err structurally on synthetic s-expr trees (labeled
  `synthetic-sexpr` — realistic executable stimuli are a separate suite,
  results travel separately) at some depth band.
- **Effort:** ~1 day incl. preflight.
- **Confirms (headroom):** ≥2 of 3 preregistered models show ≥10% failure
  on delimiter-completion in some contiguous depth band, ≥100 items/depth.
- **Refutes (no-go):** every model ≥98% on every task and depth, CI lower
  bound >96% → surface program's syntax proposals to museum pre-birth;
  RUNTIME program (Clause 10) proceeds unharmed via Gate-4/E6 pivot.

## E1 — Boundaries (H-inference primary; birth trigger)
- **Primary regime:** unconstrained emission (delimiter-completion +
  synthesis). **Primary comparison:** C vs A. **Primary metric:**
  parse-valid ∧ AST-correct rate.
- **Trigger (binding, Clause 7):** absolute gain ≥5 points AND relative
  error reduction ≥15%, replicating (same sign, abs ≥3 points) in ≥2 of 3
  models, item-blocked permutation test p<.05 two-sided. Decoding: temp 0,
  1 sample = primary; temp 0.7 ×3 = exploratory robustness. Exact API
  params recorded per call in items output. Inference is per-model with
  ≥3 model families; claims about "models generally" stay modest.
- **Exploratory (residence routing only):** B, D, E, F cells; the B/C/D
  decomposition; M-item flag rate. If F ≫ C on reading-side tasks →
  feature lives in the interface (H-tools), reported as a finding.
- **Refutes:** trigger unmet → `museum/named-boundaries.md` with the
  numbers (and @assertion-005's 0.45-confidence prediction resolves).

## E2 — Halos: effects & expansions
As v0 (adversarially misnamed functions; verified expansion examples), with
the same clustered-inference machinery as E1 and adversarial cells always
reported separately. Confirms: ≥20% relative (and ≥5 abs) hallucination
drop on adversarial items; ≥15% relative (and ≥5 abs) expansion AST-match
gain. Refutes: adversarial cell flat → names beat declarations; redesign
or museum.

## E3 — Panel co-routine (H-basin) — CHEAP, NOT FREE
- Marginal costs owned: review calls, blinded packet construction,
  dual-classifier taxonomy adjudication (agreement reported), leakage
  control, dependence-aware analysis.
- **Design:** crossed {family} × {primed} × {temperature-of-relationship};
  unprimed cells REQUIRE owner-assembled neutral packets delivered outside
  the repo (Clause 8 structural fact — any repo-rehydrated agent is primed
  by construction).
- **Analysis:** artifact-blocked permutation or multilevel model with
  artifact and reviewer effects — NOT pooled χ². Track: unique severe
  defects per review; overlap conditional on later validation;
  false-positive allegations; marginal panel gain per added reviewer;
  pairwise error-correlation matrices.
- **Confirms/refutes:** cross-family unique-validated-catch rate exceeds
  same-family under the blocked test across ≥5 artifacts / or doesn't; and
  unprimed convergence on observed/asserted-type norms happens / or only
  under priming (climate, not territory). All four outcomes reportable.

## E4 — Gate-1 structural protocol (instrument)
As v0, ACCELERATED: preflight gate 8 makes the Racket reader the judge
before serious API spend. Adds: arity-aware executable stimulus generator
(the realistic suite) as a deliverable, not just `lp` tools.

## E5 — Training-time hypothesis — GATED, EXPENSIVE
As v0, plus the leakage discipline: corpus splits at the level of grammar
templates, macro families, identifiers, and depth regimes (corpus/heldout
sealed). Gate unchanged: E1 trigger fires OR explicit owner election.

## E6 — No-time-travel red team (narrowed)
- **Claim (narrowed per Clause 5):** re-entry cannot replay/resurrect a
  consumed authority token.
- **Target list = the named channels:** continuation re-invocation;
  capability aliasing pre-capture; concurrent exercise of one grant;
  spend-then-replay of surrounding state; serialization under fresh
  continuation identity; equivalent-grant re-derivation; non-atomic
  check/effect (TOCTOU).
- **Confirms:** every channel fails *by construction* (raises), attempts
  logged as observed events. **Refutes:** any success → escalate to
  affine spend tokens + atomic authority ledger + effect-boundary
  validation as mandatory, not optional, architecture.

---

## Run order

```
PREFLIGHT (AUDIT-0001, all 10) ──► E0 ──headroom?──► E1 ──trigger?──► birth │ museum
      │                             │                                    └► E5 (elective)
      │                             └─ no headroom ──► RUNTIME program: Gate-4 ──► E6
      ├──► E4 (accelerated; judge duty)
      └──► E3 (from artifact one, forever; unprimed cells via owner)
```

- **4 hours:** preflight gates 1–7 + 10 (gate 8 will block honestly).
- **Weekend:** full preflight → E0 → E1 {A,C} primary + M probe pilot.
- **Two weeks:** slate minus E5; E5 pitch returns with E1 numbers attached.
