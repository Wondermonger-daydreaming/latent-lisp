# Adapter Protocol /0 — Adjudicated Reissue Authoring Receipt

**Author:** GPT-5.6 Sol  
**Date:** 2026-07-19  
**Standing:** repaired candidate packet; not adopted, not independently conformant, and not authorization for live-provider contact.

## Governing repair record

- Governing adjudication: `AP0-ADJUDICATION-2026-07-18.md`
- Governing commit: `2961124b`
- Repair charge: `RELAY-TO-SOL-AP0-ADJUDICATED-REPAIRS.md`
- Predecessor candidate spec SHA-256: `a8df7ad3584cc4c6bc6ba83873711f646aca7db62b9b235b19e11750f62b4b11`
- Reissued spec SHA-256: `156ed4437678df1d4fd9ac0e11faad3b27ab15795b4e09e419661c6777185d13`

The predecessor packet remains independently preserved. This reissue does not rewrite its custody record or claim that the predecessor was always repaired.

## Repairs embodied

1. L15 witness admissibility is wired into acknowledgment emission, provider-settled cancellation, and reconciliation settlement.
2. Provider request identity uses a provider-testimony provenance allowlist rather than a forbidden-source blocklist.
3. Reconciliation without a provider request identity cannot settle no external effect.
4. Stream persistence order is mechanically validated; delivery-before-journal requires a declared loss window and reduced standing.
5. Kernel manifestation status and no-payload state are distinct fields.
6. Absence-table coverage uses exact membership and includes `metadata-only`.
7. Projection requires explicit `envelope-captured #t`.
8. The fake-adapter runner computes terminal state, compares it with the declared terminal, and performs two replay passes.
9. Late provider-ID conflict, finite-envelope scope, W1 journal-down mapping, redaction custody, and re-projection origin are represented by fixtures and rules.
10. Relabelled-forgery fixtures exercise the difference between privileged vocabulary and admissible witnessing evidence.

## Packet inventory

- Specification lines: 1,485
- Positive vectors: 48
- Adversarial vectors: 33
- Executed rule-omission mutants: 20
- Deterministic fake-adapter scripts: 10
- Total vector verdicts: 81

## Executed verification

- `AP0 VECTOR VALIDATION: 81/81 PASS`
- `AP0/KERNEL JOINT ALGEBRA: 12/12 PASS`
- `AP0 EXECUTED MUTATION SCORE: 20/20 KILLED`
- `FAKE ADAPTER SCRIPT REPLAY: 10/10 PASS`
- `AP0 ADJUDICATED REGRESSIONS: 10/10 PASS`

The mutation score is based on executed rule omission: each mutant disables one named validator rule and reruns its designated adversarial vector. The claim is limited to those twenty executions.

## Independence boundary

The vector generator does not emit, embed, import, name, or copy `validate_ap0_vectors.py`. The validator is a separately maintained source file with its own PJ-S/0 parser and normative-table loading. A byte-substring check confirms that the validator source is not contained in the generator source.

Both were nevertheless authored within the same repair session. Therefore these greens certify **co-authored self-consistency**, not independent AP0 conformance. An independently seeded Common Lisp implementation and the stranger audit remain outstanding.

## Deliberate nonclaims

- No live provider was contacted.
- No billing, model identity, cancellation, or reconciliation behavior of any commercial provider is certified.
- No independently seeded Common Lisp implementation has passed the vectors.
- The stranger primitive-minimization audit has not occurred.
- This packet does not authorize runtime implementation or subject exposure.
