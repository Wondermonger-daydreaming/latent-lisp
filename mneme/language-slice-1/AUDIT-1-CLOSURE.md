# AUDIT /1 — CLOSURE RECEIPT

*2026-07-23, fourth sitting. Closes the AUDIT-1 arc (filed pre-repair at
`b9677049`; repairs at `74c1c99c`). The pre-repair record is untouched — the
breach and all four live paths remain visible there and in the teeth's recorded
pre-repair failures.*

## Lineage ceiling (rides every citation of this audit)

> **LIMES-II was a fresh-context but same-family audit** (Opus 4.6 — the same
> Claude lineage that authored the substrate). It supplied valuable hostile
> coverage, **not independent fresh-weights corroboration.** A finding it
> missed that a lineage-distant auditor would catch remains structurally
> possible; nothing here claims otherwise.

## Closure state

| Finding | State at closure |
|---|---|
| Mutation/aliasing breach (4 live paths: input-aliasing, registry spine, receipt rewrite, pattern-nf reader) | **CLOSED** — constructor detachment (`copy-tree` at `%normal-form`), defensive public readers on all list-valued fields across all four structs; teeth T13–T17 bite-then-pass (pre-repair failures recorded verbatim, incl. the reproduced `(:WIPED)`) |
| Non-idempotent extractor registration (doc-only) | **CLOSED** — guarded registration, stable symbol key; T16 double-load proof (3→3→3) |
| Derivation-key collision question | **CLOSED as collision-free universally** — injective encoding, last-slash/pure-digit recovery; 63 adversarial pairs |
| Hand-built `(:derivation …)` witness without `derive` | **OPEN BY DESIGN** — the acknowledged stratum-3 same-image escape (CHARTER-DELTA-1 Δ3); repair refused because it would claim host-level closure the slice does not make |
| Schema-identity vs ordinary `:procedure`-domain identity | **DEFERRED, recorded** — no gate keys on the identity today; Slice /2-consideration note |

## Verification at closure

Selftest 36/0 post-repair (now superseded by the Delta-2 revision's larger
count); both specimens, both ablations, slice0 SMOKE, kernel0 selftest green
after every repair; frozen trees byte-clean throughout.

— Claude Fable 5 (CC seat), custodian
