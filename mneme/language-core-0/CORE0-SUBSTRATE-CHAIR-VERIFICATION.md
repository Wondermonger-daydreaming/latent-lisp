# CORE /0 SUBSTRATE — CHAIR VERIFICATION AND GAP ADJUDICATION

*2026-07-24. Chair: Claude Fable 5 (CC seat). Builder: FABER-EFFECTUS-II
(Claude Opus 4.8, 1M), build report adopted at
`census/../FABER-EFFECTUS-II-REPORT.md` (this directory). Everything below was
verified by the chair's own runs, not banked from the builder's summary.*

## Battery (chair's hand, this sitting)

| Check | Result |
|---|---|
| Core /0 selftest (`core0-selftest.lisp`, fresh image, SBCL 2.4.6 wrapper-verified) | **29 passed / 0 failed, exit 0**; all nine work-order §1.4 teeth printed their bite (typed refusal caught) before their cure |
| kernel0 regression gate (read-only) | **33 passed / 23 excluded / 0 failed, 59 mutants killed (56 independent + 3 re-attributions), exit 0** |
| Frozen trees | `git status`: zero modifications under `kernel0/`, `language-slice-0/`, `language-slice-1/` — only new files in this lane |
| `::` audit | zero double-colons outside the one receipted seam (`lisp-plus-slice0::*why-extractors*`, ×2 = find-guard + push; `CORE0-DEFECT-RECEIPT-0.md`) |

All greens are **self-consistency certification** (AP0 §24.1 label carried). No
PJ0 reliance, no durability claim, no AP0-conformance language — chair-checked
in file headers and selftest banner.

## GAP adjudication (builder's 10 declared decisions → chair dispositions)

| # | Decision | Disposition |
|---|---|---|
| 1 | `outcome-kind` as one-arg projection over the outcome's own axes, with tooth T5 cross-checking the view against independent `fold-attempt-outcome` standing | **ACCEPTED** as the synthesis §3b conservative completion; the T5 cross-check is exactly the guard that keeps the axes from being self-report |
| 2 | Pre-frontier refusal encoding (execution `:refused`, effect `:not-entered`, no frontier event, terminal `:attempt-refused`) | **ACCEPTED** — declared encoding, Kernel §12.6-anchored |
| 3 | W1 kill encoding byte-shape-identical to kernel0 `load.lisp`'s own W1 smoke | **ACCEPTED** — strongest possible precedent anchor |
| 4 | Capability liveness as fresh un-serializable cons token; scope plist frontier check; no revocation/restoration | **ACCEPTED**, scoped per work order §1.1; lane 2 arrives whole later |
| 5 | Adapter designators as **keywords** (`:fake-courier`), deviating from the illustrative `'fake-courier` | **ACCEPTED as implementation-forced** — package-dependence of bare symbols would break cross-package designator identity; illustrative source was declared non-normative |
| 6 | `match-outcome` deferred / `with-outcome` refused | **CONFIRMED** — work-order §2 law |
| 7 | Manifestation on the `:producer-identity` (non-AP0) branch, K0E-27 | **ACCEPTED** — correct branch for a labeled non-AP0 scripted subset |
| 8 | Interpretation axis `:not-applicable` / `:not-attempted` (no minted procedure) | **ACCEPTED** — the two lawful procedure-free cases |
| 9 | The one `::` seam, receipted, re-instancing Slice /1's licensed pattern | **ACCEPTED** — one receipt per seam honored; runtime list extension, not a frozen-source edit |
| 10 | `process-context` constructor (Amendment-1 name), execution-standing axis distinct from `receiver-context`'s evidentiary position | **ACCEPTED** — the owner's two-door ruling honored in the bytes |

No disposition required invention beyond the synthesis's grades; no GAP was
resolved by concealment (each names its spec §).

## Standing after this verification

Substrate deliverables 1, 2, 4 of the work order are **built and
chair-verified**. Deliverable 3 (the three specimens in house form) and §1.5
(`CORE-0-CLOSURE.md`) remain open — next hands. Nothing here closes Core /0.

— Claude Fable 5 (CC seat), 2026-07-24
