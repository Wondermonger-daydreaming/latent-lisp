# AP0 repaired reissue verification transcript

Governing repair charge: commit `2961124b`.

## Vector suite
```text
AP0 VECTOR VALIDATION: 81/81 PASS
```

## Kernel joint algebra
```text
AP0/KERNEL JOINT ALGEBRA: 12/12 PASS
```

## Executed mutants
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

## Fake-adapter two-pass replay
```text
FAKE ADAPTER SCRIPT REPLAY: 10/10 PASS
script-absent	4	declared=absent-after-completion	computed=absent-after-completion	2af838cb27858488e39f56728d20c10a102267405ef84619629c1e0be04e5bc5
script-cancel	5	declared=present-partial	computed=present-partial	fdb017348b2f2c7ac7e422537b64d7541d0f688e83c2144c511b9188d15244a5
script-empty	4	declared=present-empty	computed=present-empty	c421947f0fac6ef52152d2cc302652e63a641f42e04c9ccfebfa28bf7b9b03e7
script-invalid	4	declared=present-invalid	computed=present-invalid	ed4a25c9c0e41815d13e0ee1c900531d942a2cacca969c76d2ae83e5a50e27dd
script-present	5	declared=present	computed=present	b8079941ebc129c27498419adf8acfa8df65da9ff50b77fec5adc10a57cff0d0
script-reconcile	4	declared=completed	computed=completed	b95afde189095f152085eef16833e75d147dc5fc2111ea6457e57e67e6a0fb30
script-w1	3	declared=unresolved-effect	computed=unresolved-effect	4b4ff6bf6ad401e4190b0afc2e59251dcb16ec05156e3cb52a0937de41194626
script-w2	6	declared=present-partial	computed=present-partial	ada745463d4eca09409b66bf8098546bad5b14bf365f326d03aa223e762884a9
script-w3	5	declared=captured-unprojected	computed=captured-unprojected	b8cde006e8ab74231acbab648076731fb419a62a30cd9fb4a978563edfb2bcbd
script-w4	6	declared=projected-unconsumed	computed=projected-unconsumed	dc227561d75938ea3ce91c91aed0deb3f24ca6fec3fcf428e28fef8fba0a3537
```

## Adjudicated hostile regressions
```text
ATK-REC-LAUNDER reject reconciliation-identity-missing,reconciliation-witness-missing
ATK-RID-COUNTER reject provider-id-invented
ATK-CAN-RELABEL reject cancellation-witness-missing
ATK-STR-DBJ reject stream-persistence-invalid
ATK-ABS-STATE-AS-STATUS reject absence-mapping-mismatch
BAD-CAN-01-RELABELLED reject cancellation-witness-missing
A-METADATA-ONLY accept 
B-UNMAPPED reject absence-table-miss
C-NO-CAPTURE-FIELD reject projection-before-capture
D-SENTINEL-CONTROL reject absence-table-miss
AP0 ADJUDICATED REGRESSIONS: 10/10 PASS
```

## Structural independence check
The validator source is not a byte substring of the vector generator and the generator does not name or write `validate_ap0_vectors.py`. This is structural separation, not independent seeding.
