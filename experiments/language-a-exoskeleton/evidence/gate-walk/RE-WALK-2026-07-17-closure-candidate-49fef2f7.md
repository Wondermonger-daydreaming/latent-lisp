# Re-walk of the four blocked checklist lines — Language-A closure candidate `49fef2f7`

**Coordinator:** KEYSTONE (Claude Opus 4.8, 1M context — the closing hand of the mechanical closure).
**Trigger:** owner-authorized calibration attempt-02 completed ELIGIBLE + manifest rebuild + two
independent clean-room `verify-pilot.sh` runs green. Required order: the post-calibration re-walk that
supersedes `RE-WALK-2026-07-17-post-calibration-attempt.md` (which was BLOCK at `d46ec58`).
**Firewall:** no Cβ key, no real item/packet/target content read or written. Only synthetic
calibration bytes, hashes, governance records, the runner source, and the clean-room evidence were
inspected.

## The TESTED commit (this is the only object any verification claim attaches to)

| Identity | Pinned / expected | Observed in worktree | Match |
|---|---|---|---|
| commit `git rev-parse HEAD` | `49fef2f7949bae5f216b20d5ed06ff2b18736d94` | `49fef2f7949bae5f216b20d5ed06ff2b18736d94` | YES |
| tree `git rev-parse HEAD^{tree}` | `5eeaedc690bde21ca013e499545e66dd39af57f4` | `5eeaedc690bde21ca013e499545e66dd39af57f4` | YES |
| `sha256sum experiments/language-a-exoskeleton/CONSTRUCTION-MANIFEST.json` | `3f9b9e6fb51702ffaa9111ec93a9add41a0bbfc1dea28e0e87457b3d0c3a7223` | `3f9b9e6fb51702ffaa9111ec93a9add41a0bbfc1dea28e0e87457b3d0c3a7223` | YES |

Both independent clean rooms re-derived all three identities against a fresh offline clone and matched
byte-for-byte (`evidence/clean-room-verify/2026-07-17-closure-candidate-49fef2f7/cleanroom-{A,B}/REPORT.md`, §1).

**The TESTED vs. PUBLICATION distinction (load-bearing).** The commit verified above —
`49fef2f7` / tree `5eeaedc6` — is the *tested* object. The commit that publishes this re-walk and the
clean-room evidence is a **successor** whose tree was **NOT itself replayed**: adding these evidence
files changes the tree hash, so no clean-room run and no `verify-pilot.sh` green attaches to the
publication commit. **No claim of verification attaches to the successor.** Anyone auditing must
re-derive against `49fef2f7` / `5eeaedc6`, never against the publication commit. (The owner
pre-exposure signature is a separate future act; nothing here signs, claims, or substitutes for it.)

## Verdict: **all four lines TRUE at the tested commit → CLOSURE COMPLETE (mechanical, network-off scope)**

Gate definitions are quoted verbatim from `operator/FREEZE-CHECKLIST.md` (the checklist file; line
numbers cited). "L*n*" = checklist file line *n*.

| Line | Definition (verbatim, `operator/FREEZE-CHECKLIST.md`) | Verdict | Evidence |
|---|---|---|---|
| **L4** (line 4) | "Record all people, overlaps, routes, releases, settings, tokenizers, prices, and custody." | **TRUE** | `operator/owner-slots.json` `price-table` slot `status:"resolved"` — three subject rows **pinned** (claude-haiku-4.5 1.00/5.00, gpt-5.6-luna 1.00/6.00, kimi-k3 0.00/0.00 USD/MTok), `decision_record owner-decision:scoring-r6-closed-v2` (`record_digest sha256:eae4cd90…`). People/overlaps/routes/releases/custody resolved under the same R6 record chain (per `evidence/gate-walk/CHECKLIST-WALK-2026-07-17.md` line-4 row). **Settings + tokenizers** recorded as owner-authorized **deferrals to emission actuals**; owner ruled a sealed disclosed deferral satisfies the pre-gate record requirement (`evidence/gate-walk/inputs/OWNER-GATE-WALK-RULING-2026-07-17.md` Interview D → operative effect 2; sealed `operator/owner-decisions/GATE-WALK-R12-ADOPTED-v1.json`). The prior AMBIGUOUS finding (a price contradiction: frozen `PREREG-v0.2.md:73` "price tables remain unresolved" vs. the later R6 closure) is **resolved without editing the frozen bytes**: `PREREG-v0.2-ERRATUM-01.md` records the ~20-minute post-freeze supersession and reconciles §73 to the controlling record; `owner-slots.json` price row synced (commit `fe3f0b2`). No side-by-side contradiction on a required field remains. |
| **L8** (line 8) | "Complete synthetic-only grader calibration and enforce the target-bank/source-packet firebreak." | **TRUE** | **Firebreak: enforced** — `CALIBRATION-REPORT.json firebreak.status:"PASS"`, `reads_checked:66`, all `synthetic-calibration-example`; clean-room `verify-pilot.sh` floor `packet-unit-and-mutation-tests` + firebreak tests PASS. **Calibration: completed, ELIGIBLE** — attempt-02 (`evidence/grader-calibration/live/attempt-02/`) fired synthetic-only via OpenRouter under `owner-decision:gate-walk-r12-adopted-v1` + the option-a runner patch (`RUNNER-PATCH-2026-07-17-option-a.md`). `CALIBRATION-REPORT.json overall_calibration:"ELIGIBLE"`; **all four primary families clear the frozen floors** (agreement ≥0.80 ∧ κ ≥0.60, `tooling/run_calibration.py:83-85,445-510`): unsupported_assertions agr 0.928571 / κ 0.887097; scope_errors, version_errors, residue_erasures each 1.000 / 1.000; n=28/family. The **4 `CENSUS_NULL_CONTENT` exclusions** (attempt-01's crash condition — reasoning models exhausting the 1024-tok budget on reasoning, emitting null content) were **handled per the owner option-(a) rule**: censused to `UNANALYZABLE-CENSUS` rather than crashing, which is precisely why attempt-02 completed where attempt-01 crashed (`RUN-RECORD.md` §3, §0). Independent recompute (`RUN-RECORD.md` §5, TALLY) reproduces every rational and verdict; the ELIGIBLE is **robust to the census counterfactual** (§6a: had the two adjudicator censuses entered the pool, unsupported_assertions = agr 0.8667 / κ 0.7909, still ELIGIBLE). Cost USD 0.545625 (« USD 1 bound). |
| **L11** (line 11) | "Run all mutations and two fresh-directory verifications." | **TRUE** | **All mutations green at HEAD** (run live in the worktree at `49fef2f7`): `verify-tranche-b.sh` 7/7 (incl. `tranche-b-unit-mutation-replay`, `inherited-preauthorship-mutations`); `verify-scoring-constitution.sh` 4/4 (incl. `scoring-constitution-freeze-self-test`); the clean-room `verify-pilot.sh` mutation floors `packet-unit-and-mutation-tests` + `preauthorship-schema-lineage-mutations` PASS. **Two fresh-directory verifications green** — two **independent** clean rooms, each a fresh offline `git clone` + detached checkout at exactly `49fef2f7` (identities triple-verified per room), ran the documented `bash verify-pilot.sh` and both exited `0` with the verbatim final line **"ALL PILOT PACKET FLOORS HOLD — 12/12 network-off checks green."** Evidence published at `evidence/clean-room-verify/2026-07-17-closure-candidate-49fef2f7/cleanroom-{A,B}/` (logs sha256 `384256bc…` / `bdf95218…`). The stale 10-check runs that failed the prior walk are superseded. |
| **L12** (line 12) | "Rebuild the manifest only after all bytes are final." | **TRUE** | `CONSTRUCTION-MANIFEST.json` rebuilt at commit `49fef2f7` ("Rebuild CONSTRUCTION-MANIFEST.json as Language-A closure-candidate manifest") **after** the calibration bytes landed (`1ebbd49`) and after README claim-ceiling riders landed (`fe3f0b2`); manifest sha256 `3f9b9e6f…` (pinned). **Bytes are final:** the prior blocker — `README.md` failing `claim-ceiling-lint` — is cleared: clean-room `verify-pilot.sh` floor `claim-ceiling-lint` PASS and `manifest-lineage-protected` PASS at this commit; `verify-tranche-b.sh construction-manifest` floor PASS live. No frozen file is modified (worktree `git status` clean before publication). |

**Compact:** L4 → TRUE · L8 → TRUE · L11 → TRUE · L12 → TRUE.

## Calibration verdict intact

The calibration verdict of record — attempt-02 **ELIGIBLE**, all four families over the frozen floors,
evidence committed at `1ebbd49` — stands unchanged; this re-walk weighs it, it does not re-open it.

## Scope honored — the gate stays UNSIGNED

Nothing here signs the pre-exposure gate. `operator/owner-slots.json pre_exposure_gate_signed:false`;
`harness/manifest.py exposure-readiness` still refuses live with
`OwnerResolutionRequired: pre-exposure-gate-signature` (clean-room floor
`unresolved-owner-exposure-refusal` PASS — a *passing refusal to expose*). No provider contact, no
target output, no key exposure, no scoring, no merge is authorized or performed by this document. The
census floors are all zero (`network_calls`, `live_provider_calls`, `real_item_model_exposures`,
`real_item_grader_exposures`, `pilot_verdicts` = 0; `dry_run_provider_calls:312` is the declared
offline rendering count, not constrained to zero). Checklist line 13 remains **HONORED**: the four
lines being TRUE is a *readiness* finding for the owner's separate signature act, not the signature.

— KEYSTONE (Claude Opus 4.8, 1M context), 2026-07-17
