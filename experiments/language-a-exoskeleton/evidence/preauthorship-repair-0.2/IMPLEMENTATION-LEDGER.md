# Repair 0.2 implementation ledger

Commission basis: `sha256:ef5366139065c741d9ee4d7bcc02fd426a1cdae7abb7d2fd61b4d27abc0981fa`
(24,058 bytes), adopted by `REPAIR-0.2-ADOPTION-RULING-FINAL.md` at
`sha256:968c9e0e65fc8fcd5dd76582cf7a0ae063aff96ea219eb724e3d2d6da88d222f`
(3,501 bytes).

| ID | Obligation | Owning artifacts | Deterministic verification | Standing | Residual boundary |
|---|---|---|---|---|---|
| PV-01 | Replace aggregate/multi-role ODR-60 algebra | schema bundle, `ODR-60-CANDIDATE-ALLOCATION-0.2.json`, allocation validator | exact 24-row family/role/tag derivation and ODR-60 mutants | candidate closed | payload remains unresolved and authorizes no items |
| PV-02 | Make owner adoption append-only and lineage-bound | owner schema, owner graph validator, strict lineage v2 | immutable predecessor hashes, synthetic complete adoption graph, bypass/dangling mutations | candidate closed | no owner adoption record exists |
| PV-03 | Make freezer states evidence-bearing | state-transition/final-decision schemas and graph validator | candidate→accepted→frozen synthetic graphs plus real/synthetic bypass mutants | candidate closed | all transition material is permanently tainted synthetic evidence |
| PV-04 | Require exact frozen-bank/handoff set equality | frozen-bank and key-handoff schemas/validator | omission, duplicate, extra, cardinality, and stale-version mutations | candidate closed | no real bank or key handoff exists |
| PV-05 | Require byte-bound nonempty transmissions | strict lineage event v2 and appended correction/successor | empty/actor/byte/receipt/read/supersedes mutations | candidate closed | legacy v1 defect is preserved only as superseded failed evidence |
| A–B | Bind commission custody and promote escaped defects to permanent mutants | commission copies, escaped-fixture registry and five witness files | exact byte/hash checks and `mutation:pv-01-witness`…`mutation:pv-05-witness` | satisfied in Repair 0.2 scope | no Fable artifact or authority promotion |
| C–D | Audit vacuous collections and synthetic bypass | census, schema minima, state validator, mutation registry | empty rendering/taint/transmission and synthetic-transition mutants | satisfied for enumerated preauthorship surfaces | finite audit, not a proof about future code |
| E | Preserve mutation identity across tranches | registry predecessor digest, ordered first 45 IDs, result evidence | exact declaration/handler equality; declared-unexecuted and undeclared-executed empty | satisfied | future tranches must retain the chain |
| F | Bind runtime identity for two fresh runs | `VERIFICATION-RUNS.json` | command bytes, interpreter, jsonschema, platform, exit status | populated after final fresh runs | single-environment scope is explicit |
| G | Publish canonicalization contract and golden vector | README and golden-vector controls | independent byte/digest fixture check plus altered-byte mutant | satisfied | SHA-256 provides change detection, not authenticity |
| H | Derive ODR-60 totals exclusively from rows | candidate allocation and validator | no stored total keys; stored-total mutant rejected | satisfied | owner may still reject or supersede the candidate |
| SCOPE | Preserve protected repository areas and authorization ceilings | protected diff and boundary evidence | Git path audit, zero-call/exposure census, full packet floors | satisfied in observed tree | targeted owner re-verification remains required |

## Deliberately unperformed

No real item, source packet, target rendering, catchability witness, private key,
score, threshold, provider route/call, packet freeze, target output, exposure, or
ODR-43/ODR-60 adoption was created or authorized. Protected Language-A,
CD/0, LCI/0, Mneme, de-corroboratione, main, the predecessor branch, and loose
owner task-list files remain outside the changed scope.
