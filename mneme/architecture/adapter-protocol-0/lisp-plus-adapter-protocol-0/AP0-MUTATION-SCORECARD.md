# AP0 Mutation Scorecard

**Standing:** packet self-consistency and negative-control evidence. This is not an independent Common Lisp conformance claim.

## Headline

- Positive vectors: **44**
- Adversarial vectors: **20**
- Structural/semantic vectors checked: **64/64 PASS**
- Planted validator mutants: **12/12 KILLED**
- Deterministic fake-adapter scripts: **10/10 PASS**

## Mutants

| Mutant | Defect removed | Killing vector |
|---|---|---|
| MUT-01 | boolean capability accepted | BAD-CAP-01 |
| MUT-02 | transport acknowledgment promoted | BAD-ACK-01 |
| MUT-03 | provider request ID invented | BAD-RID-01 |
| MUT-04 | partial stream erased | BAD-PART-01 |
| MUT-05 | projection allowed before capture | BAD-ENV-01 |
| MUT-06 | absence-table miss improvised | BAD-PRJ-01 |
| MUT-07 | binary-float cost accepted | BAD-CST-01 |
| MUT-08 | socket closure promoted to cancellation settlement | BAD-CAN-01 |
| MUT-09 | incomplete-domain not-found settled no-effect | BAD-REC-01 |
| MUT-10 | provider omitted from exposed principals | BAD-EXP-01 |
| MUT-11 | implicit fallback permitted | BAD-CFG-01 |
| MUT-12 | shorter unsafe bypass permitted | BAD-ERG-01 |

The executable transcript is `transcripts/MUTATION-SUITE.txt`.
