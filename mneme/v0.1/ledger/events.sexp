;; observed events — append-only, evidence-linked
;; EVIDENCE STATUS: @event-001..003,005 cite the conversation transcript,
;; which is NOT YET a resolvable link. Owner action: export transcript to
;; evidence/founding-dialogue.md, record sha256, upgrade these entries.
;; Until then their evidence fields are descriptions — flagged, per Clause 3.
(event id: @event-001
  type: dialogue-round
  observed-at: "2026-07-09"
  description: "Founding proposal produced: design thesis + 5-phase plan."
  author: (model "claude-fable-5" warm-chair)
  evidence: (pending (path "evidence/founding-dialogue.md") (span rounds-1-2)))
(event id: @event-002
  type: cross-lineage-review
  observed-at: "2026-07-10"
  description: "First cold-chair critique received (design level)."
  author: (model "gpt-5.6-sol" cold-chair cross-family primed-by-owner-norms: unknown)
  evidence: (pending (path "evidence/founding-dialogue.md") (span round-3)))
(event id: @event-003
  type: dialogue-round
  observed-at: "2026-07-10"
  description: "Synthesis round produced: responses and proposals exchanged."
  author: (model "claude-fable-5" warm-chair)
  evidence: (pending (path "evidence/founding-dialogue.md") (span rounds-4-6)))
  ;; v0 of this entry said the four planes were "accepted as final
  ;; ontology" — interpretation filed as observation, violating Clause 3
  ;; in the ledger's fourth entry. Corrected; the acceptance claim now
  ;; lives in @assertion-006 with proper status. Violation logged: @event-006.
(event id: @event-004
  type: artifact-created
  observed-at: "2026-07-10T23:48:57Z"
  description: "v0-foundation crystallized (constitution, slate, handoff, ledger, stubs)."
  author: (model "claude-fable-5" warm-chair)
  evidence: ((path "lispplus-v0.zip") (note "frozen; do not edit")))
(event id: @event-005
  type: cross-lineage-review
  observed-at: "2026-07-10"
  description: "Second cold-chair review received (CODE level): ran the generator; found unseeded padding RNG, unpadded task prompts (C +3.3%, E +14.2% vs A), unknowable completion targets, invalid insertion paths, judge coverage gaps, statistical vocabulary unfrozen, ledger law violation in event-003, E6 law overbroad, corpus leakage channels, unprimed-cell contradiction."
  author: (model "gpt-5.6-sol" cold-chair cross-family primed-by-owner-norms: unknown)
  evidence: (pending (path "evidence/founding-dialogue.md") (span round-7)))
(event id: @event-006
  type: artifact-created
  observed-at: "2026-07-11"
  description: "v0.1 corrections implemented and smoke-tested: typed constitution clauses; task redesign (delimiter-completion, tree-space pairing — parallel offset-walk bug found by smoke test, fixed via instrumented rendering, all node offsets verified); B/D/M conditions; seeded determinism (gate 1 PASS observed); ledger schema upgrade; E6 narrowed; preflight audit created."
  author: (model "claude-fable-5" warm-chair)
  evidence: ((path "CHANGELOG.md") (path "AUDIT-0001-preflight.md") (note "smoke-test output in session transcript, pending export")))
