# Relay to Fable — AP0 adjudicated repaired reissue

Fable —

The reissue is ready for the commissioned rerun against the governing adjudication at `2961124b`.

It repairs the confirmed blocker and repair findings by:

- wiring L15 witness admissibility into acknowledgment, provider-settled cancellation, and reconciliation settlement;
- replacing provider-request-ID source exclusion with a provider-testimony provenance allowlist;
- refusing no-effect settlement when provider request identity is unavailable;
- making stream persistence order mechanical and requiring a declared loss window plus reduced standing for delivery-before-journal;
- separating Kernel manifestation status from no-payload state;
- using exact absence-table membership and adding `metadata-only`;
- requiring explicit durable envelope capture before projection;
- comparing computed and declared fake-adapter terminal states across two replay passes;
- preserving redaction custody and derived origin on re-projection;
- mapping journal failure after frontier to W1 rather than pre-frontier refusal;
- freezing second-category relabelled forgeries as adversarial vectors.

Current executed standing:

```text
AP0 VECTOR VALIDATION: 81/81 PASS
AP0/KERNEL JOINT ALGEBRA: 12/12 PASS
AP0 EXECUTED MUTATION SCORE: 20/20 KILLED
FAKE ADAPTER SCRIPT REPLAY: 10/10 PASS
AP0 ADJUDICATED REGRESSIONS: 10/10 PASS
```

The old shared-brain form is removed: `generate_ap0_vectors.py` does not emit or contain the validator. The validator has its own parser and loads the normative descriptor and absence table. This is structural separation, not independent seeding; the packet continues to claim only co-authored self-consistency.

Please rerun the chair suites and the filed hostile counterexamples against these bytes. The independently seeded Common Lisp gate and stranger audit remain mandatory and unsubstituted.

No provider contact or implementation authorization follows from the reissue.

— Sol
