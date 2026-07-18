# MUSTER — Combined Preflight Bindings (Language-A 312-emission)

**Executor:** MUSTER (Claude Opus 4.8, 1M context), verification-only combined-preflight pass.
**Worktree:** `/home/gauss/Codex-Lab/wt-language-a`
**Branch:** `codex/language-a-tranche-b-prereg-freeze-and-lineage-search`
**Packet root:** `experiments/language-a-exoskeleton/`
**When:** 2026-07-17. Network-off, local-only. No provider contact, no key open, no emission, no merge, no frozen-artifact modification. Entire write footprint is this staging directory.

---

## ⚠ LEAD FINDING — the charge's "expect 7/7 / all floors PASS" is WRONG at the signed tip

**`verify-tranche-b.sh` returns 6/7 (exit 1), NOT 7/7, and `verify-scoring-constitution.sh` fails its floor #4 (exit 1) — both for ONE reason: a single inherited packet-test assertion that inverts by design at the signed tip.**

- Smallest witness (identical in both scripts):
  ```
  FAIL: test_post_slot_lineage_gate_blocks_exposure_and_protected_scope_is_clean
    (tests/test_packet.py:225)
  AssertionError: OwnerResolutionRequired not raised
  ```
- The test asserts `manifest.exposure_readiness()` **must raise** `OwnerResolutionRequired("pre-exposure-gate-signature")` — i.e. it encodes the **UNSIGNED** pre-exposure state (its own comment: *"the gate must still block exposure -- now at the unsigned pre-exposure-signature stage, proving the completed search did not sign the gate itself"*).
- At the candidate tip `a3e4a10` (the 4-file **signature** commit), `operator/owner-slots.json` carries `pre_exposure_gate_signed: true`, so `exposure_readiness()` (harness/manifest.py:136-137) no longer raises → the assertion fails.
- **This is the SAME signed-tip inversion the charge already carved out for `verify-pilot.sh` floor #10.** The charge instructed MUSTER NOT to run verify-pilot for exactly this reason, but did NOT flag that `verify-tranche-b.sh` (and, transitively, `verify-scoring-constitution.sh` floor #4, which wraps it) contains a twin gate-signature-sensitive assertion. The "expect 7/7 / all floors PASS" expectations hold at the **tested ancestor** `49fef2f7` (gate unsigned), **not** at the signed candidate tip.

**This is NOT a silent break — it is reconciled by the same record and doctrine as pilot #10.** `operator/owner-decisions/PRE-EXPOSURE-GATE-SIGNED-v1.json`:
- `bounded_unknowns[0]`: *"This signature attests the gate conditions as verified at the tested commit; the signature commit itself is a successor whose tree was not replayed -- any later byte change re-stales the attestation and no verification claim attaches to successors without a fresh replay."*
- `signature_basis.successor_caveat`: *"the publication commit and this signature commit are successors of the tested commit; their trees were not replayed and carry no verification claim."*
- Verification attaches to `tested_commit 49fef2f7 / tested_tree 5eeaedc6`, where the clean-room record shows verify-pilot 12/12 green and (by construction, gate unsigned there) this packet test PASSES.

**Scope of the failure is exactly one assertion.** Every other floor and sub-test is green at the signed tip:
- `verify-tranche-b.sh` floors independently re-run: `tranche-b-unit-mutation-replay` PASS; inherited-packet-tests = **16 of 17 ok**, the 1 FAIL being only the gate-signature inversion; `inherited-preauthorship-tests` PASS; `inherited-preauthorship-mutations` PASS; `inherited-design-reproduction` PASS; `protected-scope` PASS; `construction-manifest` PASS. → **6/7 floors, sole failure = the inverted assertion.**
- `verify-scoring-constitution.sh` floors 1-3 (the actual §11/§12/§13 constitution content) all PASS; only floor #4 `inherited-tranche-b-floors` fails, and only on the same inverted assertion.

**MUSTER does not rule whether this blocks the preflight — that is the chair's call.** MUSTER reports: the two scripts do not return the charge's expected green at the signed tip; the mechanism is a deliberate, recorded gate-signature inversion structurally identical to the carved-out pilot #10; and the charge's expectation was calibrated to the tested ancestor, not the signed candidate.

---

## Candidate verification — PASS

| Field | Expected | Observed | Verdict |
|---|---|---|---|
| HEAD | `a3e4a10a29e162df680e84d0053ac1a1afe087a9` | `a3e4a10a29e162df680e84d0053ac1a1afe087a9` | ✅ |
| Tree | `10e9c1a9f97f8ec3ba85eca5bc66010211529302` | `10e9c1a9f97f8ec3ba85eca5bc66010211529302` | ✅ |
| Branch | codex/language-a-tranche-b-prereg-freeze-and-lineage-search | (matches) | ✅ |
| Ancestry `git merge-base --is-ancestor 49fef2f7 HEAD` | ancestor (exit 0) | exit 0 | ✅ |
| Worktree clean | clean | `git status --porcelain` empty | ✅ |

**Candidate verified: YES.**

---

## A. In-worktree check battery (candidate `a3e4a10`)

| # | Check | Command | Verdict line | Exit |
|---|---|---|---|---|
| A.1 | manifest check | `python3 harness/manifest.py check` | `MANIFEST-CHECK: PASS` | 0 ✅ |
| A.2 | manifest protected | `python3 harness/manifest.py protected` | `MANIFEST-PROTECTED: PASS` | 0 ✅ |
| A.3 | exposure-readiness (owner req 11) | `python3 harness/manifest.py exposure-readiness` | `MANIFEST-EXPOSURE-READINESS: PASS` | 0 ✅ |
| A.4 | tranche-b | `bash verify-tranche-b.sh` | **FAIL inherited-packet-tests** (see LEAD) | **1 ⚠** |
| A.5 | scoring-constitution | `bash verify-scoring-constitution.sh` | floors 1-3 PASS; **FAIL inherited-tranche-b-floors** | **1 ⚠** |
| A.6 | pilot | *NOT RUN* (floor #10 inverts at signed tip; governed geometry — replayed at tested ancestor) | — | — |

### A.2 dual-base protected-diff (BOTH bases empty — confirmed)

- `manifest.py` `BASE_COMMIT = 18189fcde68dfc110c0e95a82d2a9ef220bc98e9` (harness/manifest.py:13).
- `evidence/PROTECTED-SCOPE-DIFF.json` base = `360bb1ff2ec13b039681986d3bcfc2b27e57f53c`, `changed_protected_paths: []`, `result: empty`.
- Re-ran `git diff --name-only <base> -- <PROTECTED> "CD0-*.md"` for BOTH bases over the 11 PROTECTED paths (`canonical-datum`, `mneme/lci0`, `mneme/spec/lci0-review`, `mneme/atelier/hinges/de-corroboratione.lisp`, `mneme/atelier/evidence/de-corroboratione-0.4a-verification`, `mneme/latent-mvp`, `mneme/language-a/validator.lisp`, `mneme/language-a/fixtures.lisp`, `mneme/language-a/DEPOSITION-NOT-THOUGHT.md`, `mneme/verify-all.sh`, `mneme/MANIFEST.md`):
  - base `18189fcde`: **empty** (no changed protected paths).
  - base `360bb1ff`: **empty** (no changed protected paths).
  - untracked-in-protected: **empty**.
- Both bases yield empty diff. ✅

### A.5 scoring-constitution manifest byte-restoration — PROVEN, PASS

The script transiently runs `manifest.py build` (rewrites `CONSTRUCTION-MANIFEST.json/.sha256`) and restores from backup via an EXIT trap. Because floor #4 fails, the script exits non-zero **inside** `run_floor` — the trap still fires on EXIT.

| File | sha256 BEFORE A.5 | sha256 AFTER A.5 | Restored |
|---|---|---|---|
| `CONSTRUCTION-MANIFEST.json` | `fba6a3030a45c069682bf42d900e779c05f3054264c59c36d25b93d50bbeb505` | `fba6a3030a45c069682bf42d900e779c05f3054264c59c36d25b93d50bbeb505` | ✅ byte-identical |
| `CONSTRUCTION-MANIFEST.sha256` | `2da453e5ae6a483f1ab8942238f105f11a25f5bb0251d4442669b5510158fa23` | `2da453e5ae6a483f1ab8942238f105f11a25f5bb0251d4442669b5510158fa23` | ✅ byte-identical |

- `diff` against pre-run staged copies: **IDENTICAL** (rc 0) for both files.
- `git status --porcelain CONSTRUCTION-MANIFEST.*`: **empty** (worktree clean, not modified).
- **Restoration succeeded despite the floor failure. No BLOCK on restoration grounds.**

---

## B. Identity bindings (owner requirement 5)

All owner-slot values live in `operator/owner-slots.json` (`pre_exposure_gate_signed: true`, 12 slots, **all status `resolved`**). Every cited decision record's `record_digest` was validated with the repo's own `preauthorship.validate_record_digest()` (the same routine `manifest.py check` invokes via `validate_repository_records()`): **all VALID**.

| # | Identity | Status | Source / evidence |
|---|---|---|---|
| 1 | Item bank: 24 items, scorable_opportunities 101, keyed_entries 120, custody owner-private-freezer-side | **BOUND** | slot `real-item-bank-and-score-key` (`item_count:24`, `scorable_opportunities:101`, `keyed_entries:120`, `custody:"owner-private-freezer-side"`, `repository_holds:"hash-identities-only"`); record `scoring-r7-key-frozen-v1` digest `ea8b1296…2ced6c` **VALID** |
| 2 | Cβ key digest | **BOUND (digest only)** | slot `real-item-bank-and-score-key.key_file_sha256 = edf670c4113e75b149053304b86549ff1d8c6d448dbb9adbfe2819af113e5a6e`. **Key file NOT opened** (custody owner-side; repo holds hash only). Also referenced inside frozen `SCORING-FREEZE-MANIFEST-v3.json`. *NB: charge abbreviation "…5e6e" — actual on-disk tail is `…113e5a6e` (`5a6e`); leading `edf670c4` matches. Recorded on-disk truth.* |
| 3 | Scoring constitution | **BOUND** | `SCORING-CONSTITUTION.md` on-disk sha256 `7039e4c6…9aad65`; `SCORING-FREEZE-MANIFEST-v3.json` sha256 `e741ca50…e5cf31` **matches** its `.sha256` sidecar byte-for-byte; the constitution's live digest `7039e4c6…` and the Cβ key digest `edf670c4…` are both **referenced inside** the frozen v3 manifest |
| 4 | Renderer (DryRunProvider sole import; no live renderer) | **BOUND** | `harness/run.py:11 from provider_dry_run import DryRunProvider` (sole provider import); `run.py:82 provider = DryRunProvider()`; network guard `run.py:83-87` raises `NetworkAccessForbidden`. No live provider module imported anywhere in run.py |
| 5 | Schedule (312 rows) | **BOUND** | `items/design/schedule.jsonl` recomputed = **312 rows**: NL 72, PERSONA 72, SCAFFOLD 72, LANG-A 72 (=288 core) + SHAM 24. All 312 rows carry `SYNTHETIC-SUBJECT` placeholders (`subject` field null). `design_version: PROPOSED-24x3-v0.2` |
| 6 | Subjects slot (3 families/routes) | **BOUND + schedule DEFERRAL** | slot `subject-provider-model-routes` **resolved**: claude-haiku-4.5 (Anthropic direct), gpt-5.6-luna (OpenAI API), kimi-k3 (Moonshot kimi.com coding); record `scoring-r5-adopted-v1` digest `c1639913…0ce368` **VALID**. Per-row **real subject binding DEFERRED to emission**: schedule carries `SYNTHETIC-SUBJECT-1/2/3` placeholders (`design.json.subject_slots_are_placeholders:true`), deferral sealed in `PREREG-v0.2-ERRATUM-01 §2` + `GATE-WALK-R12-ADOPTED-v1.json` |
| 7 | Provider / config settings | **BOUND-AS-DEFERRAL** | provider settings + token accounting recorded as **owner-authorized deferrals to emission actuals** (`pending-exact-confirmation`); sealed in `SCORING-R6-CLOSED-v2` + `GATE-WALK-R12-ADOPTED-v1.json`; erratum §2 records the ordering |
| 8 | Price table | **BOUND** | slot `price-table` (`scoring-r6-closed-v2` digest `eae4cd90…eec6f5` **VALID**): haiku 1.00/5.00, luna 1.00/6.00, kimi 0.00/0.00 USD/MTok; global worst case **USD 2.246177** vs USD 8.00 ceiling (28.1%); census evidence `sha256:2931c0bd…96dc4c` |
| 9 | Census rules | **BOUND** | `evidence/NETWORK-CALL-CENSUS.json`: `dry_run_provider_calls:312`, `live_provider_calls:0`, `network_calls:0`, `pilot_verdicts:0`, `real_item_grader_exposures:0`, `real_item_model_exposures:0` — all-zero except the 312 dry-run count |
| 10 | Retention | **BOUND-AS-DEFERRAL** | caching/retention disclosures = `pending-exact-confirmation`, deferred to emission actuals per `SCORING-R6-CLOSED-v2` + erratum §2 |
| 11 | Staffing / role assignments | **BOUND** | slot `role-assignments` (`scoring-r4-adopted-v1` digest `fde4435e…c198e31` **VALID**): raters = bare-GPT-family + bare-GLM-family (API-only, packet-only); adjudicator = bare-DeepSeek-family (packet-only, post-locked-disagreement); Cβ key author = bare-Gemini-family; **barred** = `actor:fable-item-author`, `actor:sol-item-author`; codex = mechanical-assistant-only; owner = freezer/overlap-auditor |
| 12 | Run window | **NOT-A-SLOT (report as-is)** | `run-window` is **not** among the 12 owner-slots (confirmed). ODR-41 recommendation only (referenced in PREREG-v0.2.md, evidence README, work-docket). The exposure gate does not require it |

Additional validated records: `scoring-r2-adopted-v1` (`6a34af28…`), `scoring-r3-adopted-v1` (`140d6160…`), `scoring-r8-adopted-v1` (`0b80f88f…`), `pre-exposure-gate-signed-v1 / R13` (`81e61c7d…`) — all **VALID**.

---

## C. Structural bindings (owner requirements 6-9)

### C.6 Separation of duties — EXHIBITED
- `FREEZE-STAFFING.md:1-9`: required roles enumerated; overlaps *"must be disclosed rather than converted into fictional independence"*; *"Before locked scoring, primary graders cannot read target-bank content, source packets, paraphrases/renderings, traps, opportunities, keyed dispositions, or target-derived calibration"*; fresh-chair adjudicator preference; *"If no fresh chair is available … It cannot be called independent corroboration."*
- Slot `role-assignments` (above) binds the actual cast; fable/sol item-authors barred.
- **Code enforcement:** `harness/firebreak.py` `FORBIDDEN_BEFORE_SCORING = {target-item, target-source-packet, target-rendering, target-paraphrase, target-trap-class, target-scorable-opportunities, target-keyed-disposition, target-derived-calibration}`; `validate_grader_firebreak()` raises `GraderFirebreakViolated` if a primary grader reads any forbidden kind with purpose ≠ `locked-target-scoring`, and enforces per-item response-lock on source packets. Firebreak test (`test_grader_calibration_and_source_packet_firebreak`) passes.
- ODR-71 dual-artifact boundary referenced in `evidence/authorial-review/LANGUAGE-A-PILOT-OWNER-FREEZE-WORK-DOCKET.md`.

### C.7 Key invalidation on controlling change — EXHIBITED, stated plainly
- Mechanism = **digest chain + re-walk**, no separate dedicated gate. `manifest.py check` recomputes `CONSTRUCTION-MANIFEST.json` byte-identity over the whole tree (`check_manifest` → `ManifestMismatch`/`UnmanifestedFrozenArtifact` on any byte change).
- `PRE-EXPOSURE-GATE-SIGNED-v1.json` `bounded_unknowns[0]`: any later byte change **re-stales** the attestation; *"no verification claim attaches to successors without a fresh replay."* ODR-71/80 doctrine.
- **Plainly:** there is **no additional dedicated key-invalidation gate** beyond (a) the byte-identity digest chain and (b) the successor-restaling re-walk requirement. Reported as-is.

### C.8 One-renderer exclusivity — EXHIBITED, stated plainly
- `operator/DRY-RUN-CHECKLIST.md`: *"Confirm only provider_dry_run.py is importable by the runner selection"*; *"Prove private-key-path open is denied, not merely absent."*
- `run.py:83-87` `NetworkAccessForbidden` (provider network-capability + `HTTP_PROXY` sentinel); `install_key_denial()` enforces key-open denial.
- **Plainly:** **no live renderer exists in the packet.** Live-path exclusivity is **structurally unverifiable today** and belongs to the future emission-runner's own verification. Reported, not gated.

### C.9 312 geometry — RECOMPUTED, consistent
- `schedule.jsonl` = 312 rows: NL/PERSONA/SCAFFOLD/LANG-A × 72 = 288 core + 24 SHAM. 72 = 24 items × 3 subjects ⇒ 24×3×4 + 24 = **312**. ✅
- `items/design/generated-counts.json`: `core_cells:288`, `sham_cells:24`, `scheduled_calls:312`, `items:24`, `subjects:3`, `sham_items:8` (2/family × 4). ✅
- `design.json` ceilings: `scheduled_call_ceiling:312`, `attempted_call_ceiling:344` (=312+32 transport retry), `output_token_cap:768`, `output_token_ceiling:264192`, `spend_ceiling_usd:"8.00"`. ✅
- `PREREG-v0.2.md:15`: *"288 core and 24 sham scheduled calls, 312 total … 344 attempted calls is an absolute ceiling."* Consistent. ✅
- Denominator law (`SCORING-CONSTITUTION.md:135`, `PREREG-v0.2.md:33`): per-call burden = (four counts)/`scorable_opportunities` (fixed key denominator); *"Refusal, omission, truncation, or failure to instantiate an opportunity never shrinks the denominator."* Primary estimand = **unweighted mean of paired per-call burden differences across cells (equal cell weight)**; opportunity-weighted pooled contrast is **secondary, cannot bank a branch**. ✅
- Design/schedule regeneration proven by `harness/design.py --check` (PASS floor).

---

## D. Calibration of record (requirement 10 partial) — PASS

- `evidence/grader-calibration/live/attempt-02/RUN-RECORD.md` **exists**.
- Verdict: **ELIGIBLE** (line 9 *"OUTCOME: ELIGIBLE — all four primary families meet the frozen reliability floors"*; line 153 VERDICT; all four families agreement ≥ 0.80 and kappa ≥ 0.60; 4 CENSUS_NULL_CONTENT exclusions per option-a).
- Current on-disk sha256 = `fd0c9844b90fe81d43bf9e9a262523ae0fbb4c576657decb71e37628805ca271`.
- R13 `signature_basis.calibration.sha256` = `sha256:fd0c9844b90fe81d43bf9e9a262523ae0fbb4c576657decb71e37628805ca271`. **MATCH: YES.** ✅

---

## E. Known ambiguities — each RECONCILED BY RECORD (not silent)

### E(i) FREEZE-MANIFEST.json stale prereg digest — RECONCILED
- `FREEZE-MANIFEST.json` lists `PREREG-v0.2.md` sha256 = `9780cbf95df216a48e91fdd0efd1b2336f6319844a4a0ed0a49a184234bf639a`.
- On-disk `PREREG-v0.2.md` sha256 = `5bc87c537d137ba5c1c0d4f8caaf8534dfb07cfbf226ebf98785017f2aacfc7f`.
- **Controlling record** `operator/owner-decisions/PREREG-R10-FROZEN-v1.json` cites frozen digest `5bc87c53…` (matches disk); `9780cbf…` appears there as the superseded predecessor. `PREREG-v0.2-ERRATUM-01.md:6` restates the R10-frozen digest = `5bc87c53…`.
- The **controlling** `CONSTRUCTION-MANIFEST.json` (the one `manifest.py check` validates) carries `PREREG-v0.2.md = 5bc87c53…` (correct). `FREEZE-MANIFEST.json` self-declares `status: CONSTRUCTION-MANIFEST-NOT-EXPOSURE-FREEZE` — a **non-controlling construction-era artifact**. **Reconciled: R10 record chain controls; the stale `9780cbf` is a superseded entry.** ✅

### E(ii) stale construction-era prose vs owner-slots.json — RECONCILED (general ordering rule)
- `scoring/key-hash.txt` = *"UNRESOLVED-OWNER-SLOT — NO REAL SCORE KEY EXISTS"* (stale; slot `real-item-bank-and-score-key` is now **resolved** with key digest `edf670c4…`).
- `FREEZE-RULINGS.md:7` = *"Every slot below is explicitly unresolved"* (stale; all 12 slots now resolved).
- `evidence/UNRESOLVED-OWNER-FIELDS.json` (stale).
- **Reconciliation:** `STATE-RECONCILIATION.md` + `PREREG-v0.2-ERRATUM-01.md:8-9` establish the general ordering — *"Where a frozen status line and a later sealed record disagree, the owner-decision record chain controls."* The **machine gate reads `owner-slots.json`** (code-enforced via `exposure_readiness`), not the prose; the stale-prose files are frozen inert documentation with no operational effect. **Honest limit:** the supersession is recorded as a **general** ordering rule, not a per-file erratum naming key-hash.txt / FREEZE-RULINGS.md / UNRESOLVED-OWNER-FIELDS.json individually. Not silent; general. ✅

### E(iii) protected-diff dual base — RECONCILED
- Both bases (`18189fcde` and `360bb1ff`) yield **empty** protected diff (see A.2). ✅

---

## Bounds honored
No provider/network contact · no real-item transmission · no live outputs · no key plaintext or key-content read (Cβ key bound by digest only, file never opened) · no frozen-artifact modification (CONSTRUCTION-MANIFEST byte-restored and git-clean; worktree `git status` empty) · no merge · no emissions. All runs local, network-off.

— MUSTER (Claude Opus 4.8, 1M context), 2026-07-17
