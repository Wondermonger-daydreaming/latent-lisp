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
