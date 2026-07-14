# LCI/0 Authorial Return — P024 Inert-Occurrence Revival

Date: 2026-07-14

Status: PROVISIONAL AUTHORIAL RETURN / `LCI0-P024` BLOCKED

## Conflict

LCI/0 §23.7 and Errata I12(e) require revival to create a new occurrence with
the reconstructed ClaimId, empty live-warrant state, and no invented standing
or authority. LCI/0 also describes a `freeze-revival` lineage edge as the
relation that can explain this discontinuity.

The frozen `revive-inert-occurrence` operation input carries exactly:

```text
predecessor
requested-claim
```

Neither the registry nor the normative algorithms define a pure field-by-field
transformation for the new occurrence's claimant, assertion time, provenance,
lineage, presentation, or open nonidentity metadata.

## Exact witnesses

| Document | Bytes | SHA-256 |
| --- | ---: | --- |
| `LCI0-P024` input | 29,375 | `c730f6e1993b6bfa77191302aae856dc92b7c973622344a7d484ac88801bb0ff` |
| input predecessor (`claim-occurrence.alpha`) | 20,477 | `fd61503c224ba21ae7e8334aeaef02529205ff69667943c1796056f61e38791f` |
| input requested ClaimId (`claim-id.file-alpha-neutral`) | 8,402 | `08be9d7b92f13a5b014866e085ff4375f44a6fd71672a36ae573e36e8e77e90b` |
| `LCI0-P024` expected result | 30,591 | `13c281e7654162ba566e8af3883ef022fb360f1c91bb8753147668fbb9389963` |
| expected `new-occurrence`, exactly registry `claim-occurrence.beta-metadata-different` | 21,360 | `b9a1877ce6cebe014aeeefb40936c15d5d1f02da6bf93e58e428c7a70e1f11a7` |

The expected new occurrence preserves only the semantic claim core and cached
ClaimId from the predecessor. It replaces claimant, assertion time,
provenance, lineage, presentation, and nonidentity metadata with values absent
from the operation input. Its lineage relation is
`lineage-relation/independent-reassertion`, not the `freeze-revival` relation
named by the revival prose.

The changes are identity-neutral for ClaimId, but that does not make them
derivable. Claimant, timestamps, provenance, lineage, and presentation remain
data whose exact values cannot be selected from ambient registry state or a
fixture name.

## Implementation disposition

The implementation snapshots inspected during preliminary review reached the
frozen expected result by selecting the registered beta occurrence or
reconstructing its values. That is a fixture lookup/expected-value shortcut,
not a pure derivation from the two input fields. This observation is not a
committed successor result; final verification remains PENDING.

Both successor implementations are required to remove that shortcut. A
defensive-copy revival may preserve only values actually supplied by the
predecessor/requested ClaimId, keep all warrants inert, and create zero live
warrants; it must not be described as reproducing the frozen expected result.
The exact vector remains blocked unless and until the author supplies the
missing transformation.

## Requested authorial closure

Please either:

1. publish a pure, total, closed, field-by-field revival algorithm that derives
   every expected output field from named input fields, including the exact
   lineage relation; or
2. correct the vector input to carry every new-occurrence value and receipt
   needed by that algorithm; or
3. revise the expected result to the exact input-derived defensive-copy form.

Please include replacement hashes and permanent vectors proving source-buffer
mutation resistance, new allocation, empty live warrants, and no ambient
registry lookup.

Until closure, `LCI0-P024` is BLOCKED and is not counted as pass, failure,
skip, or N/A. Unaffected migration and occurrence vectors may continue.

## 2026-07-14 successor execution note

The final exact sweep again executed P024 in both implementations and retained
the unsourced beta occurrence as one of the four blocked vector results. The
post-convergence source-buffer mutation and independently allocated-value
probes converged, and no live warrant was created. P024 remains outside the
pass/failure/skip/N/A counts pending authorial closure.
