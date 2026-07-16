# Tranche B item-bank freeze receipt

| ID | Obligation | Artifact | Verification | Status | Residual boundary |
|---|---|---|---|---|---|
| F1 | Bind the freeze to the owner-authorized candidate commit/tree | `FREEZE-MANIFEST.json` | Git object, tree, ancestry, and direct-remote checks | satisfied | Successor commit/tree are necessarily post-record observables. |
| F2 | Freeze the exact reviewed bank, template, and schedule bytes without rewriting them | freeze inventory and sidecar | authorized-blob comparison for all 19 artifacts | satisfied | No authenticity claim beyond owner authorization and observed Git custody. |
| F3 | Bind all 312 row digests and request-parent identities | schedule section of the freeze manifest | authoritative schedule validation and six focused negative controls | satisfied | Provider-live behavior remains unauthorized and untested. |
| F4 | Preserve candidate items, templates, schedule, request parents, and protected scope | successor diff | exact scoped diffs | satisfied | Only this freeze successor is evaluated. |
| F5 | Retain independently executable verification and deterministic regression evidence | verifier and consolidated evidence | focused verifier, self-test, and seven Tranche B verification floors | satisfied | Finite tests are engineering evidence, not formal proof. |

The reviewed candidate's embedded `candidate-not-frozen` and false authorization fields are preserved as pre-authorization historical bytes. The later owner authorization and this append-only record perform the freeze transition without rewriting those reviewed artifacts.
