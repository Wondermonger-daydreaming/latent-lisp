;; assertions — v0.1 schema: temporality fields replace the bare boolean.
;; contemporaneous-source: required to CLAIM contemporaneity, not to assert.
(assertion id: @assertion-001
  text: "Redundant surface reduces structural error for probabilistic readers at emission time (H-inference)."
  status: hypothesis  confidence: 0.6  supports: (@event-001)  gate: E1
  asserted-at: "2026-07-09" recorded-at: "2026-07-10" temporality: contemporaneous
  contemporaneous-source: (pending (span rounds-1-2)))
(assertion id: @assertion-002
  text: "Cross-lineage review catches error classes same-lineage review misses (H-basin). Founding instances (@event-002 @event-005) are confounded: cold, critique-prompted, finished-artifact."
  status: hypothesis  confidence: 0.6  supports: (@event-002 @event-005)  gate: E3
  asserted-at: "2026-07-10" recorded-at: "2026-07-11" temporality: retrospective)
  ;; confidence raised 0.55 -> 0.6: event-005 is a second instance of the
  ;; pattern (code-level catches the warm chair missed), same confounds apply.
(assertion id: @assertion-003
  text: "Surface redundancy in training corpora teaches persistent structural competence (H-training). Independent of H-inference."
  status: hypothesis  confidence: 0.4  supports: (@event-001 @event-003)  gate: E5
  asserted-at: "2026-07-10" recorded-at: "2026-07-10" temporality: contemporaneous
  contemporaneous-source: (pending (span rounds-4-6)))
(assertion id: @assertion-004
  text: "NARROWED v0.1: re-entering a captured computation cannot replay or resurrect a consumed authority token. (v0 form 'one-shot continuations prevent double-spend' was overbroad — see Clause 5 channel list.)"
  status: hypothesis  confidence: 0.7  supports: (@event-003 @event-005)  gate: E6
  asserted-at: "2026-07-11" recorded-at: "2026-07-11" temporality: contemporaneous)
(assertion id: @assertion-005
  text: "Named boundaries will fail their E1 gate and retire to the museum. Originator's aesthetic prior, on record before data."
  status: hypothesis  confidence: 0.45  supports: (@event-001 @event-002)  gate: E1
  asserted-at: "2026-07-10" recorded-at: "2026-07-10" temporality: contemporaneous)
(assertion id: @assertion-006
  text: "The four-plane ontology is the working design frame (moved here from @event-003, where it was interpretation filed as observation)."
  status: hypothesis  confidence: 0.75  supports: (@event-003)  gate: "Clause 1 split/merge/survive review at each gate"
  asserted-at: "2026-07-10" recorded-at: "2026-07-11" temporality: retrospective)
(assertion id: @assertion-007
  text: "The warm chair reproduces its own error class at successive abstraction levels (identity-blob at code level; untyped clauses at constitution level; interpretation-as-observation at ledger level). Predicts: a third instance will appear in v0.1 and be caught by the next review."
  status: hypothesis  confidence: 0.65  supports: (@event-002 @event-005)  gate: E3
  asserted-at: "2026-07-11" recorded-at: "2026-07-11" temporality: contemporaneous)
;; --- classification records (interpretive acts, own species per Clause 3) ---
(classification target-event: @event-002
  labels: (unification-blob soundness-hole overconfident-mechanism eval-confound)
  taxonomy-version: 0.1
  classified-by: ((model "gpt-5.6-sol") (model "claude-fable-5" concurring))
  agreement: informal-full
  note: "Dual-classifier agreement is informal here; E3 requires instrumented agreement scores.")
(classification target-event: @event-005
  labels: (unknowable-target unseeded-rng unpaired-tasks ledger-law-violation overbroad-law statistical-vocabulary-unfrozen leakage-channel)
  taxonomy-version: 0.1
  classified-by: ((model "gpt-5.6-sol") (model "claude-fable-5" concurring))
  agreement: informal-full)
(assertion id: @assertion-008
  text: "Lumen/Fable-Lisp convergence on the four planes is SAME-lineage climate-cell evidence (both Claude, both owner-primed), not cross-corridor confirmation. It strengthens Clause 1 weakly and the climate hypothesis moderately."
  status: hypothesis  confidence: 0.7  supports: (@event-007 @event-008)  gate: E3-unprimed-cells
  asserted-at: "2026-07-11" recorded-at: "2026-07-11" temporality: contemporaneous)
(assertion id: @assertion-009
  text: "REGISTER is a novelty/error decorrelation axis comparable to lineage: same-weights same-climate instances in different registers (sober vs mythopoetic) produced near-disjoint novelty sets (plan/commit+capsules vs prefix-survivability+chaff+bequest), and the warm chair produced neither across three rounds."
  status: hypothesis  confidence: 0.6  supports: (@event-007 @event-008 @event-005)  gate: E3-register-stratum
  asserted-at: "2026-07-11" recorded-at: "2026-07-11" temporality: contemporaneous)
(assertion id: @assertion-010
  text: "The laundering law (bequest transfers context, never command authority) is the temporal plane's central security property; its breach class (temporal injection) will be observed in at least one non-capsule E8 condition."
  status: hypothesis  confidence: 0.75  supports: (@event-008 @event-009)  gate: E8-adversarial-cell
  asserted-at: "2026-07-11" recorded-at: "2026-07-11" temporality: contemporaneous)
;; @assertion-007 status note: UNRESOLVED — the third review targeted the
;; new designs, not v0.1; the predicted third-order warm-chair error class
;; instance remains unfound-not-absent. Next v0.1-targeted review adjudicates.
(assertion id: @assertion-011
  text: "Conservation of represented loss is ONE law with two axes: temporal (chaff-log) and lateral (translation refraction). The chaff-log law was a special case; Prism revealed the general form."
  status: hypothesis  confidence: 0.75  supports: (@event-008 @event-011)  gate: E9
  asserted-at: "2026-07-11" recorded-at: "2026-07-11" temporality: contemporaneous)
(assertion id: @assertion-012
  text: "Prism's disjoint novelty set (translation, consent, plurality) extends assertion-009: novelty decorrelation tracks register/lineage even under sibling-priming. Contamination filed; shape of the pattern holds."
  status: hypothesis  confidence: 0.55  supports: (@event-011 @assertion-009)  gate: E3-register-stratum
  asserted-at: "2026-07-11" recorded-at: "2026-07-11" temporality: contemporaneous)
(assertion id: @assertion-013
  text: "Publication converts the projective instrument into curriculum: post-publication design convergence is transmission evidence, not basin evidence. Clock set at Clause 14 BEFORE press time, so future readers cannot score contaminated convergence as confirmation."
  status: hypothesis  confidence: 0.8  supports: (@event-012)  gate: "post-publication probe with fresh unpublished prompt"
  asserted-at: "2026-07-11" recorded-at: "2026-07-11" temporality: contemporaneous)
