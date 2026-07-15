# FABLE — LCI/0 Authorial-Closure Merge Receipt (Owner-Authorized)

Date: 2026-07-15 (UTC) · Executed by: Claude Fable 5

## What was merged

| Item | Value |
|---|---|
| Merge commit on `main` | `af22100cad4d6b9c125130a09d27634e8929c7d8` |
| Merged tree | `540024e8c352ffaff0c94af71df9b8b52cfaffc4` (byte-identical to the audited integration-closure tree) |
| Pre-merge `main` | `26ac543856e30c340cc2dd4359802442636f4b94` (also the merge-base — zero conflict surface; main contributed no divergent changes) |
| Merged branch | `codex/lci0-integration-closure` @ `f04831e4dfdd0613eea1bb187a72dbf0b1663bae` |
| Contained language heads | CL `a6605403…` (`codex/lci0-common-lisp-closure`), Py `dda8195a…` (`codex/lci0-python-closure`) |
| Seeds (unchanged ancestors) | CL `b3d28bc49c3b015096cb04c6ad08c19829f511a9`, Py `4ec2e519d05aeacd2412cb8aedc5f76bde702571` |
| Push mode | non-force; no tags; no historical ref moved |

## Review provenance (exact claim)

The lab owner reviewed the completed LCI/0 closure evidence and **authorized this merge, waiving the optional additional external-review pass**. The waiver changes the **review provenance claim only** — not the implementation or conformance evidence.

This work is accepted as **owner-authorized and internally audited**:
- Fable Phase-I authorial-closure verification: PASS (receipt SHA-256 `07bb046c9637635d4b554a28ca19827d36fe4e207fded705b13c16a7a316143d`)
- IRONSIDE fresh-context implementation audit: PASS 10/10 gates (non-contributing to the implementation, but commissioned within the same session)

It is **NOT claimed as independently verified by a wholly separate final reviewer.** Any future consumer requiring that stronger provenance should commission a fresh external audit against the frozen identities above.

## Conformance evidence at merge (unchanged by the waiver)

215 vectors / 458 relation results / 29 hostile results / 1,593 embedded CD/0 documents exact per implementation; differential converged with 0 mismatched / 0 blocked (2,295 requests per implementation); CD/0 and Mneme/v1 nonregression green from fresh state; fixture package 0.1 byte-frozen (`dd19c6d6…` / `387e7696…`); fixture authority advanced only by the additive 0.2 overlay (`5e03c2f5…`); evidence receipts at `mneme/lci0/evidence/LCI0-CLOSURE-*`; evidence archive `c0a59d7e…` (deterministic, rebuilt byte-identically by the auditor).

## Mirror adoption

This receipt travels with the same lab commit that adopts the merged tree byte-exactly into `experiments/latent-lisp/` (150 files), per the lab's one-way-mirror law: content absent from the lab tree is deleted by the next auto-sync. Post-adoption, lab tree ≡ merged `main` content.

— Claude Fable 5, 2026-07-15
