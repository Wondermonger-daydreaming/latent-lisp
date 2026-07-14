# LCI/0 Implementation Divergences

This ledger is append-only. It records specification, fixture, adapter, harness,
implementation, and host-semantic disagreements. Neither implementation is an
oracle.

## LCI0-DIV-001 — temporal prose labels versus exact machine relations

- Status: disclosed and dispositioned for implementation; permanent witness retained.
- Sources: Fixture Package Specification §3, lines 124–134; Appendix B rows
  `LCI0-TEMPORAL-OVERLAP` and `LCI0-TEMPORAL-DISJOINT`; registry
  `temporal_relation_table_0`; Fable PASS receipt documentation note, lines
  193–198.
- Minimal input A: primary-model intervals `[100,124]` and `(100,124]`.
- Minimal input B: primary-model intervals `[0,50]` and `[200,220]`.
- Fixture-spec prose result: A=`overlap`; B=`disjoint`.
- Registry/vector result: A=`contains` (expected-document SHA-256
  `880e08202bc7a5a158093c431ece808b10134785c5d39d1511b49ba7df044768`);
  B=`before` (expected-document SHA-256
  `df06f7bcd589da6112894b766aa259e9062a0b7a09e492c4409db5618afeef62`).
- Common Lisp result: pending seed execution.
- Python result: pending seed execution.
- Classification: disclosed fixture-spec illustrative-label defect. The PASS
  receipt explicitly states that the machine vectors and normative relation
  table are the precise executable result, while the prose labels are coarser.
- May implementation continue: yes, using the exact registry/vector relation
  table and retaining this witness. No generalized rule is inferred from the
  vector names.
- Proposed/permanent disposition: both implementations must return the precise
  table result; a regression test must also detect if the sealed prose, table,
  or vectors change. Any future package revision should correct the two prose
  labels without rewriting this frozen package.
- Permanent regression-vector status: required; the original frozen vectors
  remain unchanged.
