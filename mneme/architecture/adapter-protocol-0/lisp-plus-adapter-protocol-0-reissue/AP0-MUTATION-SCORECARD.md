# AP0 mutation scorecard — repaired reissue

The suite executes 20 rule-omission validator mutants. For each mutant, the normal validator rejects its designated single-defect target and the validator with that named rule disabled accepts it. This is executed negative-control evidence, still bounded to co-authored self-consistency.

```text
AP0 EXECUTED MUTATION SCORE: 20/20 KILLED
KILLED	MUT-01	BAD-CAP-01	boolean-capability
KILLED	MUT-02	BAD-ACK-01	ack-promotion
KILLED	MUT-03	BAD-ACK-RELABELLED	ack-outside-witness-set
KILLED	MUT-04	BAD-ACK-NO-WITNESS	ack-witness-missing
KILLED	MUT-05	BAD-RID-COUNTER	provider-id-invented
KILLED	MUT-06	BAD-RID-CONFLICT	provider-id-conflict
KILLED	MUT-07	BAD-PART-01	partial-erased
KILLED	MUT-08	BAD-STR-DBJ	stream-persistence-invalid
KILLED	MUT-09	BAD-ENV-MISSING-CAPTURE	projection-before-capture
KILLED	MUT-10	BAD-PRJ-01	absence-table-miss
KILLED	MUT-11	BAD-PRJ-02	absence-mapping-mismatch
KILLED	MUT-12	BAD-PRJ-ORIGIN	projection-origin-invalid
KILLED	MUT-13	BAD-ENV-REDACTION	redaction-custody-invalid
KILLED	MUT-14	BAD-CAN-RELABELLED	cancellation-witness-missing
KILLED	MUT-15	BAD-REC-RELABELLED	reconciliation-witness-missing
KILLED	MUT-16	BAD-REC-NO-ID	reconciliation-identity-missing
KILLED	MUT-17	BAD-CST-01	float-money
KILLED	MUT-18	BAD-EXP-01	provider-omitted
KILLED	MUT-19	BAD-CFG-01	implicit-fallback
KILLED	MUT-20	BAD-WIN-JOURNAL-DOWN	journal-down-misclassified
```
