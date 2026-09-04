# LANGUAGE-A PILOT OWNER FREEZE-WORK DOCKET

**Artifact:** `LANGUAGE-A-PILOT-OWNER-FREEZE-WORK-DOCKET.md`  
**Review date:** 2026-07-16  
**Review role:** authorial freeze-work reviewer  
**Review boundary:** network-off construction packet only; no real item creation, no private key creation, no provider call, no target/grader/adjudicator exposure, no repository modification, no live authorization  
**Primary disposition:** **ACCEPT WITH NAMED PRE-FREEZE REPAIRS**  
**Live-exposure ceiling:** **NOT AUTHORIZED**

This docket determines whether the reviewed packet is a lawful scaffold for owner freeze work. It does **not** determine whether Language A works, fails, is useful, or deserves live execution. The packet’s passing construction tests are treated as evidence about the behavior those tests exercised, never as self-authenticating proof that the governing ruling was faithfully implemented.

---

## 1. PACKET IDENTITY AND REVIEW BASIS

### 1.1 Reviewed delivery

Custody had already passed before semantic review began. The reviewed delivery is fixed by the following identities:

| Object | Verified identity or result |
|---|---|
| Outer ZIP | SHA-256 `1eba695958459ed18f3bbff5c86d1c381f5f1ac1601175598446ed4ee8dfce86` |
| Supplied sidecar file | SHA-256 `73c1ebd8abcca859b467241b121eb2f655f9ba7a4b9599dfbef9006ad9d3a534` |
| Sidecar declaration against ZIP | matched the attached ZIP |
| ZIP inventory | exactly six members; no missing or unexpected member |
| Internal `SHA256SUMS.txt` | every listed member passed |
| Snapshot tarball | SHA-256 `0292c2a7a3b6ec19e3d5fdc526825ce8ab1565fb0864b30ea9cb57cc90754b36` |
| Git bundle | SHA-256 `540464b777c95779bc57ba7443a4e0000921ac14ffe41e2536387f151f6e4c05` |
| Bundle branch | `transfer/language-a-pilot-freeze-review` |
| Reviewed commit | `f5f0e4a6972f9b321167e5aef6c5c47c70d56e3e` |
| Reviewed tree | `6561d3097c056c517e9f67fad1c168608d60f0db` |
| Frozen base | `360bb1ff2ec13b039681986d3bcfc2b27e57f53c` |
| Frozen-base tree | `9d5e2478b4f103b5f1f9d9674a1905c605388d6a` |
| Ancestry relation | frozen base is an ancestor of the reviewed commit and is the exact merge base |
| Bundle completeness | complete history for the supplied branch |

The snapshot’s 96 packet files were compared byte-for-byte with the corresponding paths at the reviewed Git tree; all 96 matched. The current construction manifest covers 94 non-manifest records plus `FREEZE-MANIFEST.json` and its sidecar, for 96 packet files total. Its current digest is `99c8271d563ff0ff209dfb8171494029c9b28268ebc60944dd34bdc95f7d2bf4`, and the construction-state manifest check succeeds.

Successful custody establishes **which artifact was reviewed**. It does not establish semantic correctness, scientific adequacy, executable fidelity, independence, absence of omitted requirements, or readiness for exposure.

### 1.2 Repository scope and branch identity

The bundle contains two commits after the frozen base:

* `e96f17a85b9bf206edefa817c3523c9675646ffe` — packet construction, tree `2513552825a8ad1859af710b7f8be661d5349435`;
* `f5f0e4a6972f9b321167e5aef6c5c47c70d56e3e` — evidence seal, tree `6561d3097c056c517e9f67fad1c168608d60f0db`.

An independent diff of frozen base to reviewed commit reports exactly **96 added files and 2,854 inserted lines**, all under `experiments/language-a-exoskeleton/`. A direct protected-scope path diff is empty. The builder’s protected-scope statement is therefore corroborated by the bundle rather than accepted on assertion.

### 1.3 Reviewed artifact inventory

Every packet artifact was read in full. The inventory consists of 96 files: 9 root records, 13 controls, 24 evidence records, 20 harness files, 7 item/design files, 7 lineage records, 5 operator records, 5 prompt templates, 5 scoring records, and 1 test module.

- `BRANCH-BANK.md`
- `FREEZE-MANIFEST.json`
- `FREEZE-MANIFEST.sha256`
- `FREEZE-RULINGS.md`
- `FREEZE-STAFFING.md`
- `PREREG-v0.2.md`
- `README.md`
- `STATE-RECONCILIATION.md`
- `controls/branch-B-HARM.json`
- `controls/branch-B-INCONCLUSIVE.json`
- `controls/branch-B-INTERACTION.json`
- `controls/branch-B-NOTATION.json`
- `controls/branch-B-NULL.json`
- `controls/branch-B-SCAFFOLD.json`
- `controls/expected-validator-events.jsonl`
- `controls/generate_controls.py`
- `controls/manifest-mutants.jsonl`
- `controls/precision-scenarios.json`
- `controls/scorer-mutants.jsonl`
- `controls/synthetic-items.jsonl`
- `controls/validator-mutants.lisp`
- `evidence/AUTHORITY-IDENTITIES.json`
- `evidence/BRANCH-FIXTURE-IDENTITIES.json`
- `evidence/CHANGED-FILE-INVENTORY.json`
- `evidence/FINAL-GIT-STATE.json`
- `evidence/IMPLEMENTATION-LEDGER.md`
- `evidence/NETWORK-CALL-CENSUS.json`
- `evidence/PROTECTED-SCOPE-DIFF.json`
- `evidence/README.md`
- `evidence/SYNTHETIC-DRY-RUN-IDENTITY.json`
- `evidence/SYNTHETIC-PRECISION-IDENTITY.json`
- `evidence/UNRESOLVED-OWNER-FIELDS.json`
- `evidence/VERIFICATION-RUNS.json`
- `evidence/analysis/SYNTHETIC-PRECISION-REPORT.json`
- `evidence/branch/SYNTHETIC-B-HARM-RECEIPT.json`
- `evidence/branch/SYNTHETIC-B-INCONCLUSIVE-RECEIPT.json`
- `evidence/branch/SYNTHETIC-B-INTERACTION-RECEIPT.json`
- `evidence/branch/SYNTHETIC-B-NOTATION-RECEIPT.json`
- `evidence/branch/SYNTHETIC-B-NULL-RECEIPT.json`
- `evidence/branch/SYNTHETIC-B-SCAFFOLD-RECEIPT.json`
- `evidence/manifests/SYNTHETIC-DRY-RUN-FILE-MANIFEST.json`
- `evidence/normalized/README.md`
- `evidence/raw-responses/README.md`
- `evidence/requests/README.md`
- `evidence/scores/README.md`
- `harness/analyze.py`
- `harness/claim_lint.py`
- `harness/conditions.py`
- `harness/design.py`
- `harness/evidence.py`
- `harness/firebreak.py`
- `harness/manifest.py`
- `harness/normalize.py`
- `harness/precision.py`
- `harness/provider_base.py`
- `harness/provider_dry_run.py`
- `harness/replay.py`
- `harness/request_schema.json`
- `harness/response_schema.json`
- `harness/run.py`
- `harness/score.py`
- `harness/sham.py`
- `harness/util.py`
- `harness/validate_output.py`
- `harness/validator-driver.lisp`
- `items/design/design.json`
- `items/design/generated-counts.json`
- `items/design/schedule.jsonl`
- `items/exclusions.jsonl`
- `items/frozen/items.jsonl`
- `items/frozen/renderings.jsonl`
- `items/source-packets/README.md`
- `lineage/actors.jsonl`
- `lineage/artifacts.jsonl`
- `lineage/lineage-bounds.jsonl`
- `lineage/reads.jsonl`
- `lineage/receipts.jsonl`
- `lineage/search-field.json`
- `lineage/transmission-assertions.jsonl`
- `operator/DRY-RUN-CHECKLIST.md`
- `operator/FIRE-CHECKLIST.md`
- `operator/FREEZE-CHECKLIST.md`
- `operator/STOP-LOG.jsonl`
- `operator/owner-slots.json`
- `prompts/LANG-A.txt`
- `prompts/NL.txt`
- `prompts/PERSONA.txt`
- `prompts/SCAFFOLD.txt`
- `prompts/SHAM.txt`
- `scoring/KEY-CUSTODY-RECEIPT.md`
- `scoring/PUBLIC-RUBRIC.md`
- `scoring/SCORING-SPEC.md`
- `scoring/branch-rules.json`
- `scoring/key-hash.txt`
- `tests/test_packet.py`
- `verify-pilot.sh`

### 1.4 Review method and independent checks

The controlling authority was read in the required order: first `POST-DE-CORROBORATIONE-PROGRAM-RULING.md`, then `POST-DE-CORROBORATIONE-PROGRAM-RULING-ERRATA-0.1.md`. Errata 0.1 was given scoped precedence, with the original ruling controlling elsewhere. All packet documentation, machine-readable controls, prompt bytes, schemas, source, Common Lisp driver, tests, evidence identities, synthetic reports, receipts, and lineage records were then read and traced from normative statement to enforcement point.

The review independently reran every non-SBCL test exposed by `tests/test_packet.py`: 15 independently runnable tests passed, including design/schedule checks, schedule mutation, scorer mutation, branch precedence, primary weighting, manifest mutation, duplicate/dangling checks, false-completion/silent-retry checks, key-boundary/network-surface checks, 312-call synthetic self-replay, claim linting, firebreak fixture, owner-field refusal, prompt parity/SHAM checks, and LCI/P2a absence checks. `harness/design.py --check`, the current construction-manifest check, key-open denial, and the current claim-surface scan passed. Two fresh 312-call executions in this Python environment were byte-identical to each other; that test does not compare them with the archived builder analysis identity, which diverges under this runtime as recorded below.

The review did **not** make a provider call, open a network route, create a real item, create a private key, score a real response, expose target material, or execute an irreversible operator action.

### 1.5 Builder-claim disposition

| Builder claim | Review result |
|---|---|
| 96 changed files, all in the authorized experiment directory | independently verified from the Git bundle |
| protected-scope diff empty | independently verified |
| existing Mneme verification floor green | recorded in two archived clean-run summaries; not independently reproduced because SBCL is unavailable |
| 17/17 packet and mutation tests green | archived evidence supports 17/17; 15 non-SBCL tests independently passed; the two SBCL-dependent checks were not independently executed |
| all fourteen Language-A fixtures traversed through the new driver | statically consistent with the driver and archived evidence; no independent SBCL traversal |
| all six synthetic branch receipts reproduced | all six branch selections and predicate structures reproduced; five of six regenerated receipt files do not match the archived bytes under Python 3.13.5, so archived byte identity was not reproduced |
| all five substantive branches reached under canonical favorable scenarios | structurally and behaviorally reproduced; the realism and sensitivity of those scenarios are materially overstated, addressed in section 9 |
| complete 312-call synthetic run replayed byte-identically | two independently generated runs are byte-identical within the review environment; the regenerated analysis does **not** match the archived builder analysis hash under Python 3.13.5, so portability/archival replay is not verified |
| zero network calls | no network-capable execution path was exercised; the dry-run provider is local and deterministic; evidence records zero live/network calls, but the packet lacks syscall-level network interdiction |
| zero real-item, grader, or target exposure | no such material exists in the reviewed packet and no such event appears in its lineage boundary; this cannot prove absence outside the delivered artifact’s declared custody field |
| unresolved owner fields correctly prevent exposure readiness | true in the packet’s current state, but the gate is bypassable by status-string edits and one Boolean; therefore it does not yet prove substantive closure |

### 1.6 Review limitations

**SBCL RUNTIME REPRODUCTION NOT PERFORMED IN REVIEW SANDBOX.** SBCL is unavailable in this sandbox. The Common Lisp source and driver were reviewed statically; the archived commands, exit statuses, hashes, two clean-run summaries, and Git identities were examined. No static Common Lisp defect was discovered. This limitation is not a custody failure and is not, by itself, a packet blocker. It does require a manifest-bound owner-side or Codex-side SBCL rerun before packet freeze, with exact runtime identity, command bytes, stdout, stderr, exit status, fixture identities, and transcript hashes preserved.

The review sandbox uses Python 3.13.5. Under that runtime, `harness/precision.py --check` does not reproduce the frozen precision report byte-for-byte: four reported floating-point means differ only in terminal binary-to-decimal digits, while branch counts and substantive checks remain unchanged. The archived report SHA-256 is `e072e7a26ac5765775515fd8c146e91bf206cf05efe58e021e21d7c694799865`; the sandbox-regenerated report SHA-256 is `6ade0f3d0d372793b13db9c519211e4b73176934ab50b5beca92318109d3691e`. The same portability issue reaches other archived numerical evidence: five of six regenerated synthetic branch-receipt files differ from their archived bytes, and a fresh full 312-call analysis hashes to `be651f9088278f15b79bae72d5b7bad9f79a461a1c978bd6a3b3ce7a0f3014fe` rather than archived `fd005595ff0296f759f847aeb748269206929885ec706b8ed0e345b4abea28`. Two fresh review-environment runs still match each other exactly. This is not an outer identity inconsistency or a changed branch result; it is an internal cross-environment reproducibility defect caused by an unfrozen runtime/canonical-float contract and is classified below.

No web or repository fetch was used. Provider behavior, pricing, retention disclosures, tokenizer identities, release names, and returned-model-ID behavior are therefore correctly left unresolved rather than guessed.

---

## 2. FAITHFUL-INCORPORATION REVIEW

### 2.1 Overall holding

The packet incorporates the controlling doctrine **substantially and often carefully at the narrative level**. It correctly preserves construction-only status, first-pass emission, the five core/sham arm geometry, fixed scientific margins, fixed-subject clustered primary estimand, Errata precedence, six-branch ordering, P2a dormancy, claim ceilings, taint concepts, owner-only anti-taxidermy choices, exact attempt/spend ceilings, and the refusal to manufacture real items or a key.

It does **not** yet faithfully implement several load-bearing requirements as executable gates. The dominant failure mode is not malicious broadening; it is documentary overclaim: a prose requirement is described accurately, while the checker tests a weaker proxy, a fixture supplies the desired answer, or a Boolean/status label stands in for evidence. The packet is therefore a lawful basis for repair and owner freeze work, but not a freeze-quality implementation and not an exposure-capable packet.

No current finding requires reopening CD/0, LCI/0, Mneme, Language A, or de-corroboratione. No substantive branch is structurally unreachable. The defects below are bounded construction defects.

### 2.2 Findings

#### FI-01 — Real-item record, source-packet, exclusion, and handoff rules are not executable

**Classification:** **BLOCKING BEFORE ITEM AUTHORSHIP**  
**Exact location:** `items/frozen/items.jsonl`; `items/frozen/renderings.jsonl`; `items/source-packets/README.md`; `items/exclusions.jsonl`; `harness/manifest.py`, function `check_ids_and_references`; absence of item/source/rendering schemas and validators.  
**Controlling authority:** original ruling §§3.5, 3.6, 3.9 controls 4–7, 4.3, 8.1; Errata 0.1 §6.  
**Finding:** The packet accurately leaves all real records empty, but it provides no executable schema or closure check for future item bytes, renderings, source packets, source versions, ancestry declarations, prior-exposure declarations, catchability witnesses, or exclusion/overlap reports. `check_ids_and_references` does not inspect these future records. A temp-copy mutation containing a malformed item record was accepted after manifest regeneration.  
**Smallest concrete consequence:** A malformed, tainted, dangling, or unversioned real item could enter a later “closed” manifest without being rejected.  
**Required disposition:** Adopt the commission and handoff specification in section 4; implement strict draft schemas, digest/reference closure, taint/collision/semantic-overlap receipts, and negative mutations before the first substantive real-item byte is authored. Author selection and source reconnaissance may proceed, but substantive item drafting and ingestion remain closed until this repair passes.

#### FI-02 — Target-visible arm labels violate manipulation neutrality

**Classification:** **BLOCKING BEFORE FREEZE**  
**Exact location:** all files under `prompts/`, especially the first lines of `prompts/SCAFFOLD.txt` and `prompts/SHAM.txt`; `tests/test_packet.py`, prompt-parity/SHAM test.  
**Controlling authority:** original ruling §§3.2–3.4 and 3.9; SHAM is diagnostic, and SCAFFOLD must not use Language-A names or notation; arm identity is not part of the task content.  
**Finding:** Every target-visible template announces an arm. `SCAFFOLD.txt` begins with a `LANGUAGE-A EMISSION PILOT` header despite the prohibition on Language-A naming in that arm. `SHAM.txt` calls itself a “SHAM DIAGNOSTIC TEMPLATE,” revealing its diagnostic/sham status. The test compares raw byte/word burden but does not reject label leakage or require blind target-visible framing.  
**Smallest concrete consequence:** Surface effects may be driven by disclosed condition identity, demand characteristics, or explicit diagnostic framing rather than the intended manipulation.  
**Required disposition:** Remove all target-visible condition names and diagnostic labels; freeze arm-neutral wrappers; add mutations that reject `LANGUAGE-A`, `LANG-A`, `SHAM`, diagnostic framing, filenames, or arm labels wherever prohibited.

#### FI-03 — The design checker accepts geometries and schedules broader than authority

**Classification:** **BLOCKING BEFORE FREEZE**  
**Exact location:** `harness/design.py`, `validate_design` and schedule construction; `items/design/design.json`; `tests/test_packet.py`, design/schedule and schedule-mutation tests.  
**Controlling authority:** original ruling §§3.1, 3.5, 3.9, 7.1; Errata 0.1 §§2, 5, 6.  
**Finding:** The current data happen to encode 24 items, four families of six, eight SHAM items, three subjects, 312 calls, 32 retries, and 344 attempts. The checker does not enforce the complete relation. It accepts item counts other than six per family, does not robustly validate `sham_item_count`, does not enforce the three eight-item minima, does not enforce the 768×344 token-ceiling relation, and uses a single global shuffle rather than an explicit blocked-randomization contract. The schedule seed is a builder-selected label, not an owner-frozen value.  
**Smallest concrete consequence:** A regenerated schedule could silently change the authorized experimental geometry while `--check` remains green.  
**Required disposition:** Encode exact current geometry or a separately owner-authorized Errata-compliant adjustment; validate every algebraic ceiling and minimum; specify blocked scheduling; move the schedule seed into the owner register; mutate every dimension independently.

#### FI-04 — Manifest validity is byte closure, not semantic closure

**Classification:** **BLOCKING BEFORE FREEZE**  
**Exact location:** `harness/manifest.py`, `packet_files`, `check_manifest`, and `check_ids_and_references`; `FREEZE-MANIFEST.json`; `controls/manifest-mutants.jsonl`; manifest-related tests.  
**Controlling authority:** original ruling §§3.6, 3.9, 7.1, 8.1; builder commission requirements for full schemas, referential integrity, lineage bounds, and refusal on malformed artifacts.  
**Finding:** Current path/length/hash closure is sound. Semantic closure is shallow. The checker ignores future item/rendering/source schemas, most schedule references, request/response/run records, artifact parent references, record types, per-record byte identities, predecessor-digest chains, firebreak chronology, and exact branch-receipt dimensions. Several named mutants in `controls/manifest-mutants.jsonl` are not themselves executed; tests construct a smaller hard-coded set. A dangling lineage-artifact parent and malformed item record were accepted in review mutations after rebuilding the manifest.  
**Smallest concrete consequence:** A manifest can be internally hash-consistent while semantically incoherent.  
**Required disposition:** Separate `construction-manifest` from `freeze-manifest`; add strict schemas with `additionalProperties: false` where appropriate; enforce full reference closure, record identities, frozen-state invariants, and every named mutant.

#### FI-05 — Lineage records do not satisfy the ruling’s digest-chain contract

**Classification:** **BLOCKING BEFORE ITEM AUTHORSHIP**  
**Exact location:** every file under `lineage/`; `harness/manifest.py`, lineage checks; absence of lineage JSON schemas; `evidence/IMPLEMENTATION-LEDGER.md`, lineage claims.  
**Controlling authority:** original ruling §§4.1–4.5 and 8.1; builder commission requirement for actual lineage schemas, validators, examples, bounded receipts, and successor-preserved failures.  
**Finding:** The packet gives useful construction-stage examples and a bounded, candid search field. It does not provide an exact byte digest on each lineage record; fields named `predecessor_digest` contain event identifiers rather than predecessor byte digests; several artifact records have `bytes: null`; parent closure is not checked; no schema is loaded; chronology and append-only successor rules are not enforced.  
**Smallest concrete consequence:** A lineage chain can be edited, reordered, or linked by name without cryptographic evidence of the predecessor bytes.  
**Required disposition:** Before the first substantive item-author read or write, define and validate canonical record bytes, event digest, predecessor event digest, parent-artifact digest, actor/artifact/read/transmission closure, monotonic chronology, bounded unknowns, negative-access custody, and immutable successor semantics; regenerate construction lineage under the repaired schema.

#### FI-06 — Exposure readiness is a ceremonial status gate

**Classification:** **BLOCKING BEFORE FREEZE**  
**Exact location:** `harness/manifest.py`, function `exposure_readiness`; `operator/owner-slots.json`; `lineage/search-field.json`; `evidence/UNRESOLVED-OWNER-FIELDS.json`; `operator/FIRE-CHECKLIST.md`; owner-field test.  
**Controlling authority:** original ruling §§3.9, 4, 6, 7.1, and the exact signed `PRE-EXPOSURE GATE`; Errata 0.1 §§4–6, 9.  
**Finding:** In the current packet the gate correctly refuses. It proves only that twelve status strings are not `unresolved`, a search termination string is `complete`, and one Boolean is true. In a review temp copy, changing those values made exposure readiness pass while the real item/rendering files remained blank and the key still declared that no real key exists. It does not inspect owner decision values/rationales, exact subjects/routes/releases/settings/prices, real-bank/key hashes, staffing, firebreak receipts, numerical harm rules, two fresh verification runs, a frozen manifest status, operator identity, signature, or manifest binding.  
**Smallest concrete consequence:** A few unauthenticated text edits can convert a construction packet into “exposure ready” without any substantive freeze work.  
**Required disposition:** Replace the Boolean/status gate with evidence-bearing typed owner records and a signed, timestamped, exact-manifest-digest gate record; require all artifacts and rerun receipts enumerated in section 10.

#### FI-07 — Request and response schemas are permissive and not used by the validator

**Classification:** **BLOCKING BEFORE FREEZE**  
**Exact location:** `harness/request_schema.json`; `harness/response_schema.json`; `harness/validate_output.py`; output-validation tests.  
**Controlling authority:** original ruling §§3.6, 3.9 controls 1–3, 7.1; exact request/response/raw preservation requirements.  
**Finding:** Both schemas are shallow and allow additional properties. The runtime validator does not load them; it checks selected field presence, arm/status values, and retry parent shape. Review mutations with wrong field types and nonsensical records were accepted. It does not validate exact raw paths/hashes/lengths, timestamps, returned model ID, usage, price, request identity, retry identity, or immutable byte linkage.  
**Smallest concrete consequence:** A structurally malformed or misidentified provider record can be normalized and counted as a valid call.  
**Required disposition:** Make schemas normative, strict, versioned, and loaded by the validator; bind every record to exact raw bytes and schedule row; add type, range, timestamp, model-ID, usage, cost, and retry mutations.

#### FI-08 — Request identity does not identify the persisted request bytes

**Classification:** **BLOCKING BEFORE FREEZE**  
**Exact location:** `harness/run.py`, request construction and `request_bytes_sha256`; `harness/replay.py`; dry-run request evidence.  
**Controlling authority:** original ruling §§3.6, 3.9 controls 1–3, 4.2; exact-byte custody and replay.  
**Finding:** `request_bytes_sha256` is computed over a canonical request object before that hash field is inserted. It is therefore not the SHA-256 of the exact persisted request file. The record also separates prompt bytes from a complete provider-wire/body representation and does not bind exact system/wrapper/tool/cache settings into one immutable request envelope.  
**Smallest concrete consequence:** The recorded hash can be truthfully verified while the exact bytes claimed as the request are a different object.  
**Required disposition:** Define a non-self-referential request-envelope identity: hash exact payload bytes separately, hash the metadata envelope separately, and bind both with schedule/model/wrapper/system/tool/config identities; replay those exact layers.

#### FI-09 — Census, retry, returned-model, and cost gates are weaker than their wording

**Classification:** **BLOCKING BEFORE FREEZE**  
**Exact location:** `harness/run.py`, census accounting and `CostLedger`; `harness/provider_base.py`; `harness/provider_dry_run.py`; `harness/design.py`; `operator/FIRE-CHECKLIST.md`; false-completion/silent-retry and network-surface tests.  
**Controlling authority:** original ruling §§3.3, 3.6, 3.8, 3.9, 6, 7.1.  
**Finding:** Expected census is derived from rows processed rather than independently bound to the frozen schedule, so a shortened input can declare itself complete. There is no live returned-model-ID equality/alias gate, no exact retry adjudication against 32 transport slots, no pre-call worst-case price reservation, no input-token ceiling, and no implemented cache/reasoning billing treatment. Spend is checked after a synthetic call. Network-surface testing scans a few import strings rather than imposing OS/process-level network-off behavior.  
**Smallest concrete consequence:** A partial run, substituted release, unauthorized retry, or over-ceiling call could avoid a timely stop in a later adapter.  
**Required disposition:** Bind run census to the frozen schedule digest and fixed expected IDs; reserve worst-case cost before each call; validate returned identity before admitting output; predeclare retry classes; enforce network and provider boundaries outside ordinary application imports.

#### FI-10 — “Content-normalized” output is not content-normalized

**Classification:** **BLOCKING BEFORE FREEZE**  
**Exact location:** `harness/normalize.py`; normalized dry-run artifacts; response-schema contract.  
**Controlling authority:** original ruling §§3.6, 3.7, 3.9; arm labels, transport wrappers, filenames, and decorative delimiters must not contaminate scoring.  
**Finding:** The normalizer JSON-decodes and wraps response content. It does not mechanically remove arm labels, provider wrappers, filenames, diagnostic headers, decorative delimiters, or other condition-revealing transport material, and it does not bind normalized content to parent raw-response hash.  
**Smallest concrete consequence:** A grader or scorer can receive condition-revealing metadata or an untraceable normalized derivative.  
**Required disposition:** Define exact normalization rules, parent raw-byte digest, normalized-byte digest, rejected content classes, and parity mutations; preserve raw bytes separately and never overwrite them.

#### FI-11 — Key denial is path-local rather than a custody boundary

**Classification:** **BLOCKING BEFORE FREEZE**  
**Exact location:** `harness/run.py`, audit-hook/key-open denial; `scoring/key-hash.txt`; `scoring/KEY-CUSTODY-RECEIPT.md`; key-boundary test.  
**Controlling authority:** original ruling §§3.7, 3.9 controls 7 and 12, 4.3, 6; private-key separation requirements.  
**Finding:** The current dry-run correctly has no key, and the audit hook rejects one hard-coded path. It does not prove separate worktrees, mount-level absence, path-alias/symlink resistance, child-process denial, read-only mount timing, key-slice access, or authorized-read logging.  
**Smallest concrete consequence:** A future runner process could read the same key through an alternate path or inherited process without tripping the tested rule.  
**Required disposition:** Implement OS/filesystem-level separation and a key-mount protocol as specified in section 5; make all key reads explicit, item-scoped, versioned, and lineage-recorded.

#### FI-12 — Anti-taxidermy harm is a caller-supplied Boolean, not measured behavior

**Classification:** **BLOCKING BEFORE FREEZE**  
**Exact location:** `harness/score.py`, completeness and `coupled_defect`; `harness/analyze.py`, `anti_taxidermy_harm` argument; `scoring/SCORING-SPEC.md`; scorer-mutant tests.  
**Controlling authority:** original ruling §3.7 and branch/harm law; Errata 0.1 §4.  
**Finding:** The scorer provides a useful fixed four-opportunity denominator for synthetic examples, but completeness is `emitted/answerable`, becomes 1.0 when `answerable == 0`, and is not tied to owner-frozen units. Deletion/omission coupling is represented by a Boolean. The analyzer ignores row-level anti-taxidermy facts and accepts a caller-supplied `anti_taxidermy_harm`; precision simulation hard-codes it false. No numerical refusal, abstention, utility, truncation, over-bounding, or omission gate is computed.  
**Smallest concrete consequence:** The same response evidence can be declared harmful or harmless by changing an invocation flag, while severe refusal or completeness degradation remains invisible.  
**Required disposition:** Implement owner-frozen scales and paired gates from section 3; derive every harm predicate from immutable scored observations; remove caller authority to assert the result.

#### FI-13 — Missing pairs, duplicate cells, census floors, and manipulation gates are not enforced

**Classification:** **BLOCKING BEFORE FREEZE**  
**Exact location:** `harness/analyze.py`, cell construction and `analyze`; `harness/precision.py`; branch fixtures.  
**Controlling authority:** original ruling §§3.6–3.9; Errata 0.1 §§2–5.  
**Finding:** Cell records are stored in a dictionary, so duplicate rows silently overwrite. Missing arm pairs are silently dropped. There is no fixed-target missing-pair policy, no overall 90% or within-subject/family 80% analyzability computation, and no non-ignorable missingness rule. `analysis_admissible` and `manipulation_checks_pass` default true and are supplied rather than calculated. Sparse/empty data can also produce undefined or crashing paths rather than a bounded refusal.  
**Smallest concrete consequence:** Differential missingness can improve an estimate by deleting hard cells, and a partial dataset can receive a substantive branch.  
**Required disposition:** Freeze expected cells from the schedule; reject duplicates; account for every scheduled cell; compute census and manipulation gates from records; route unresolved/missing conditions to bounded inconclusive or stop receipts.

#### FI-14 — Required subject-stratum harm and paired randomization evidence are absent

**Classification:** **BLOCKING BEFORE FREEZE**  
**Exact location:** `harness/analyze.py`; `scoring/branch-rules.json`; branch receipts; absence of a sign/randomization test implementation.  
**Controlling authority:** original ruling §§3.7–3.9; Errata 0.1 §§2–4.  
**Finding:** The bootstrap correctly resamples items within family and retains available subject/arm observations. The analysis does not compute subject-stratum estimates, subject-level harm, subject interactions, or the required paired sign/randomization check. It reports family harm and an overall burden path only.  
**Smallest concrete consequence:** A large harm confined to one fixed subject release can be hidden by averaging, and branch evidence lacks one required confirmatory check.  
**Required disposition:** Add frozen subject-stratum outputs and harm precedence; implement an exact or owner-frozen Monte Carlo paired randomization/sign procedure preserving item clustering and fixed subjects; bind seed and iteration count.

#### FI-15 — Branch predicate receipts do not faithfully represent the full predicates

**Classification:** **BLOCKING BEFORE FREEZE**  
**Exact location:** `harness/analyze.py`, branch predicate construction and receipt; `BRANCH-BANK.md`; `controls/branch-*.json`; branch-precedence tests.  
**Controlling authority:** original branch bank as supplemented by Errata 0.1 §3.  
**Finding:** `B-INCONCLUSIVE` is recorded as true for every analysis, including receipts whose selected branch is substantive. The `B-NOTATION`, `B-SCAFFOLD`, and `B-NULL` predicate fields omit their no-harm condition; precedence happens to mask some cases. One test expressly expects the notation predicate to remain true under an anti-taxidermy harm flag, contrary to the complete predicate wording in `BRANCH-BANK.md`. Harm receipts do not name every harmed contrast/stratum, and interaction receipts are not paired with the full owner anti-harm dimensions.  
**Smallest concrete consequence:** A receipt purporting to show all evaluated predicates misstates which branch conditions actually held.  
**Required disposition:** Encode each complete predicate once, including admissibility, manipulation, no-harm, and owner gates; derive selection by precedence from those complete predicates; make `B-INCONCLUSIVE` true only when no earlier complete predicate holds.

#### FI-16 — Synthetic precision does not implement the required scientific stress study

**Classification:** **BLOCKING BEFORE FREEZE**  
**Exact location:** `harness/precision.py`; `controls/precision-scenarios.json`; `evidence/analysis/SYNTHETIC-PRECISION-REPORT.json`; precision identity evidence.  
**Controlling authority:** Errata 0.1 §5.  
**Finding:** The study demonstrates structural reachability under six favorable fixtures, but it simulates only the four core arms, not SHAM; hard-codes admissibility/manipulation pass and anti-taxidermy harm false; drops missing pairs through the analyzer; uses 36 replicates and 160 bootstrap iterations without Monte Carlo uncertainty; and uses unusually dense 100–140-opportunity, highly correlated null data and large ±0.20 effects. Required questions are answered by equating one observed branch hit with realistic attainability, useful sensitivity, or meaningful power. The conclusion “retain as feasibility pilot” is hard-coded before owner disposition.  
**Smallest concrete consequence:** The packet can report that an interval or branch is “realistically attainable” when only an extreme, designer-favorable scenario demonstrated it.  
**Required disposition:** Rerun a repaired broad-grid study using actual gates, missingness, SHAM diagnostics, plausible discrete opportunities, moderate/threshold effects, fixed subject strata, item clustering, and Monte Carlo uncertainty; preserve fixed margins; return an owner recommendation, not a self-adopted design choice.

#### FI-17 — Numerical evidence byte replay depends on an unfrozen runtime and float rendering

**Classification:** **BLOCKING BEFORE FREEZE**  
**Exact location:** `harness/precision.py`; `harness/analyze.py`; report/receipt serialization; `evidence/analysis/SYNTHETIC-PRECISION-REPORT.json`; `evidence/SYNTHETIC-PRECISION-IDENTITY.json`; all six `evidence/branch/SYNTHETIC-*-RECEIPT.json` files; `evidence/SYNTHETIC-DRY-RUN-IDENTITY.json`; verification environment metadata.  
**Controlling authority:** original ruling §§3.9 and 7.1 deterministic replay; Errata 0.1 §5; builder evidence-seal requirements.  
**Finding:** Under Python 3.13.5, semantic branch selections and predicates reproduce, and two fresh review-environment executions match each other. The archived bytes do not. Four precision-report mean interval widths differ in terminal binary-to-decimal digits; the precision report SHA-256 changes from archived `e072e7a26ac5765775515fd8c146e91bf206cf05efe58e021e21d7c694799865` to `6ade0f3d0d372793b13db9c519211e4b73176934ab50b5beca92318109d3691e`; five of six branch-receipt files differ; and a fresh complete 312-call analysis hashes to `be651f9088278f15b79bae72d5b7bad9f79a461a1c978bd6a3b3ce7a0f3014fe` rather than archived `fd005595ff0296f759f847aeb748269206929885ec706b8ed0e345b4abea28`. The packet freezes neither Python implementation/version and dependencies nor a canonical decimal/rounding contract for derived numerics.  
**Smallest concrete consequence:** A clean reviewer can reproduce every branch label yet fail the packet’s advertised evidence-byte identities, making “byte-identical replay” environment-relative rather than artifact-defined.  
**Required disposition:** Freeze the runtime/container identity, dependency hashes, locale/hash-seed inputs where relevant, and canonical numerical serialization; regenerate every numerical report, receipt, and identity; prove two clean replays in the pinned environment and either a defined cross-environment contract or an explicit pinned-environment scope.

#### FI-18 — Full synthetic-run and SBCL evidence are sufficient for review, not for final freeze

**Classification:** **BLOCKING BEFORE FREEZE**  
**Exact location:** `evidence/VERIFICATION-RUNS.json`; `evidence/SYNTHETIC-DRY-RUN-IDENTITY.json`; `evidence/manifests/SYNTHETIC-DRY-RUN-FILE-MANIFEST.json`; `harness/evidence.py`; `verify-pilot.sh`; `harness/validator-driver.lisp`.  
**Controlling authority:** original ruling §§3.9, 7.1; builder commission’s two-clean-run, raw-transcript, full-lineage, and identity obligations.  
**Finding:** Two archived clean runs report identical SBCL output hashes, 10/10 verification checks, and 17/17 packet tests. The identities tie to the reviewed construction tree. However, raw stdout/stderr/transcript bytes and runtime/environment hashes are not archived. The synthetic dry-run manifest inventories 1,563 generated files but does not deliver those generated bytes, and the replay does not generate or replay a full lineage event stream.  
**Smallest concrete consequence:** A final freezer cannot independently reconstruct the exact SBCL transcript or prove that every synthetic call’s lineage was reproduced.  
**Required disposition:** Before freeze, run the exact SBCL and full-packet commands in a pinned environment, archive raw outputs/statuses/runtime hashes, regenerate the complete synthetic run including lineage, and preserve both fresh manifest-bound receipts. The present sandbox’s lack of SBCL is not itself the defect.

#### FI-19 — Grader and adjudicator firebreak is largely narrative and fixture-local

**Classification:** **BLOCKING BEFORE FREEZE**  
**Exact location:** `FREEZE-STAFFING.md`; `harness/firebreak.py`; firebreak test; lineage files; `operator/FREEZE-CHECKLIST.md`.  
**Controlling authority:** original ruling §§3.7, 3.9, 4.3, 4.4, 6; claim ceiling on independence; Errata 0.1 §4.  
**Finding:** The documentation states the right principles, and `firebreak.py` rejects a small exact set of artifact kinds for a primary-grader role when called on a synthetic fixture. The function is not invoked by manifest/freeze checks and does not verify chronology, artifact version, calibration taint, target-source timing, locked first passes, grader replacement, key slices, adjudicator packet minimization, fresh sessions/routes, or shared-root disclosure.  
**Smallest concrete consequence:** A prematurely exposed grader can remain in a “valid” manifest because no integrated gate reads the exposure history.  
**Required disposition:** Implement the event- and role-based firebreak in section 6, integrate it with freeze/readiness, and mutate every forbidden read and chronology transition.

#### FI-20 — SHAM status code is bounded, but the diagnostic protocol and ceiling are not closed

**Classification:** **BLOCKING BEFORE FREEZE**  
**Exact location:** `harness/sham.py`; `prompts/SHAM.txt`; `PREREG-v0.2.md`; `BRANCH-BANK.md`; SHAM-related test.  
**Controlling authority:** original SHAM law and claim ceiling; Errata 0.1 §§3 and 5.  
**Finding:** `sham.py` returns only the three authorized statuses or an authority-return edge, which is good. It is not integrated with the 24 scheduled SHAM calls, provider-tokenizer parity, semantic-leak audit, explicit-discard audit, analysis receipts, or claim linter. Its precedence can classify a semantic leak before an overlapping explicit-discard condition; authority does not resolve that overlap. The prompt itself discloses “SHAM.”  
**Smallest concrete consequence:** The packet can present a SHAM status without proving that the diagnostic subset, tokenizer burden, or leak/discard evidence existed; an overlap can receive an invented procedural precedence.  
**Required disposition:** Implement the complete tri-status procedure and ceiling in section 7; make leak/discard criteria mutually exclusive by design or obtain scoped authority; preserve the existing refusal for the ≥70%/no-leak/no-discard/>10%-token edge if that shape remains possible.

#### FI-21 — The claim linter rejects tokens, not claim-equivalent propositions

**Classification:** **BLOCKING BEFORE FREEZE**  
**Exact location:** `harness/claim_lint.py`; `tests/test_packet.py`, claim-linter test; all branch and summary claim surfaces scanned by `verify-pilot.sh`.  
**Controlling authority:** original ruling §§2.3, 3.10, 4.5, 5; Errata 0.1 §§3, 7.  
**Finding:** Exact regular expressions reject several named formulations, but accepted prohibited equivalents include “The notation has no value,” “Three providers prove robustness,” “Localized harm proves the whole approach harmful,” and “Scaffold benefit is Language-A benefit.” It also accepts affirmative “global independence is established” and “totality is established” because riders are tested by word presence. Unlabelled Markdown and JSON fields such as `interpretation` are outside the scanned surface. Required riders are presence fragments, not exact release/route/settings/window values, and mutation coverage does not remove or invert every rider independently.  
**Smallest concrete consequence:** A forbidden global or causal claim can pass while containing all expected rider words.  
**Required disposition:** Implement the bounded structured claim grammar and mutation matrix in section 8; scan every declared downstream surface; reject affirmative forbidden propositions and require manifest-bound exact rider values.

#### FI-22 — Evidence generation can overwrite rather than preserve failure successors

**Classification:** **BLOCKING BEFORE FREEZE**  
**Exact location:** `harness/evidence.py`, file-writing paths; manifest/report generation; no append-only/frozen-state mode.  
**Controlling authority:** builder commission requirement to preserve every failure as a successor and never force-overwrite evidence; original lineage/custody law.  
**Finding:** Generated evidence and manifests are written to stable paths using ordinary overwrite behavior. There is no frozen-state refusal, immutable attempt ID, predecessor digest, or successor-only transition.  
**Smallest concrete consequence:** A failed report or run receipt can be replaced by a later success at the same path, erasing the failure from packet-local history.  
**Required disposition:** Use attempt-addressed immutable artifacts and successor receipts; freeze paths read-only; include predecessor/event digests; reject overwrite after construction seal.

#### FI-23 — The implementation ledger and several tests overstate what was proved

**Classification:** **BLOCKING BEFORE FREEZE**  
**Exact location:** `evidence/IMPLEMENTATION-LEDGER.md`, especially requirements R5, R8, R9, R11, R12, and R15; `tests/test_packet.py`; `controls/manifest-mutants.jsonl`; branch fixtures.  
**Controlling authority:** the whole controlling ruling; explicit instruction not to treat builder tests as proof of faithfulness.  
**Finding:** The ledger marks requirements mechanically satisfied where only a narrative, caller flag, fixture, or partial checker exists. Examples include fixed-denominator harm coupling, full lineage, firebreak, full dry-run identity, and claim ceilings. The branch fixtures use degenerate high-opportunity inputs; the owner-gate test checks only current refusal, not bypass resistance; the firebreak test exercises one authored fixture; the claim test covers selected phrases; prompt parity uses raw bytes/words rather than provider tokenizers; false completion compares against a self-declared count; network and LCI checks are string scans.  
**Smallest concrete consequence:** A green verification summary invites an owner to believe stronger properties were proved than the tests establish.  
**Required disposition:** Downgrade ledger claims to exact tested scope; add adversarial and integration mutations tied one-to-one to governing clauses; require review of the mutation matrix, not only test count.

#### FI-24 — Owner-only decisions are compressed into twelve coarse status slots, with defaults outside the register

**Classification:** **BLOCKING BEFORE FREEZE**  
**Exact location:** `FREEZE-RULINGS.md`; `operator/owner-slots.json`; `evidence/UNRESOLVED-OWNER-FIELDS.json`; `items/design/design.json`; `scoring/branch-rules.json`; prompt and operator records.  
**Controlling authority:** original ruling §§3.1–3.10, 4–7; Errata 0.1 §§2–6.  
**Finding:** The packet candidly marks twelve umbrella slots unresolved, but the machine record does not enumerate the actual decisions needed to close them. Schedule seed, bootstrap seed, bootstrap iteration count, precision seed/iterations, SHAM overlap, tokenizer identities, wrapper/system bytes, returned-ID policy, kappa-undefined fallback, randomization test, key mount procedure, claim riders, and operator signature semantics are absent or builder-defaulted. The bootstrap seed `1729` and 800 iterations are hard-coded despite being freeze choices.  
**Smallest concrete consequence:** An owner can mark an umbrella slot “resolved” while dozens of load-bearing subchoices remain implicit or builder-selected.  
**Required disposition:** Replace umbrella statuses with the complete typed register in section 3; every record must carry value, allowed shape, rationale, authority, dependencies, deciding actor, timestamp, and exact gate effect.

#### FI-25 — Real subjects, routes, releases, price table, staffing, bank, key, and signed gate remain absent

**Classification:** **BLOCKING BEFORE LIVE EXPOSURE**  
**Exact location:** `FREEZE-STAFFING.md`; `operator/owner-slots.json`; `items/frozen/*`; `scoring/key-hash.txt`; `lineage/search-field.json`; `operator/FIRE-CHECKLIST.md`.  
**Controlling authority:** original ruling §§3.3, 3.5–3.9, 4, 6, 7; Errata 0.1 §§4–6 and 9.  
**Finding:** These absences are correctly disclosed construction-state conditions, not concealed defects. They nevertheless close the live gate.  
**Smallest concrete consequence:** There is no lawful addressee, model identity, price reservation, real task bank, scoring key, grader panel, operator, or signed manifest against which a target call could be authorized.  
**Required disposition:** Resolve every field in section 3, execute sections 4–6, complete the lineage search field, pass repaired verification twice, and sign the exact manifest-bound pre-exposure record. No target exposure before then.

#### FI-26 — No live-adapter custody contract exists

**Classification:** **BLOCKING BEFORE LIVE EXPOSURE**  
**Exact location:** `harness/provider_base.py`; `harness/provider_dry_run.py`; absence of any live adapter; `FREEZE-STAFFING.md`.  
**Controlling authority:** original ruling §§3.3, 3.6, 3.8, 6–7.  
**Finding:** The packet deliberately contains only a dry-run provider, which is appropriate for this commission. A successor live adapter would still need exact request-body custody, returned-ID verification, caching/retention handling, retry classification, usage/cost capture, stop law, and network boundary review.  
**Smallest concrete consequence:** Replacing the dry provider with an ad hoc client would bypass the reviewed construction invariants.  
**Required disposition:** Commission and review any live adapter separately; bind its code and environment into a successor freeze manifest; do not treat provider-base abstractions as exposure authorization.

#### FI-27 — Changed-file inventory excludes its two self-referential manifest files

**Classification:** **NONBLOCKING OBSERVATION**  
**Exact location:** `evidence/CHANGED-FILE-INVENTORY.json`; `FREEZE-MANIFEST.json`; `FREEZE-MANIFEST.sha256`.  
**Controlling authority:** evidence clarity and exact branch inventory.  
**Finding:** The evidence inventory lists 94 packet paths, while the Git diff contains 96. The two omitted paths are the manifest and sidecar, plausibly excluded to avoid self-reference, but the record is named as though it were the complete changed-file inventory.  
**Smallest concrete consequence:** A reader can misread 94 as the Git changed-file count.  
**Required disposition:** Rename it to `MANIFEST-COVERED-NONSELF-FILES` or add explicit excluded-self records and a separately generated exact Git diff inventory.

#### FI-28 — “Provider calls” is used inconsistently for synthetic invocations

**Classification:** **NONBLOCKING OBSERVATION**  
**Exact location:** `evidence/SYNTHETIC-DRY-RUN-IDENTITY.json`; `evidence/NETWORK-CALL-CENSUS.json`.  
**Controlling authority:** evidence clarity and no-network claim.  
**Finding:** One record says `provider_calls: 0`; another says `dry_run_provider_calls: 312`. The intended distinction is zero external/provider-network calls versus 312 local dry-provider invocations.  
**Smallest concrete consequence:** A reader can mistake a terminology difference for contradictory custody evidence.  
**Required disposition:** Use `external_provider_calls: 0`, `network_calls: 0`, and `local_synthetic_adapter_invocations: 312` consistently.

#### FI-29 — Final Git-state evidence necessarily identifies the construction commit, not the later evidence seal

**Classification:** **NONBLOCKING OBSERVATION**  
**Exact location:** `evidence/FINAL-GIT-STATE.json`; bundle head.  
**Controlling authority:** exact repository identity.  
**Finding:** The file records construction commit `e96f17a…`, while the reviewed head is evidence-seal commit `f5f0e4a…`. The file candidly explains the self-reference problem, and the bundle resolves final identity.  
**Smallest concrete consequence:** A reader relying only on the JSON could quote the pre-seal commit as the reviewed head.  
**Required disposition:** Preserve both roles explicitly: `construction_content_commit` and `delivery_seal_commit`, with the external custody docket binding the latter.

#### FI-30 — Source-packet README imposes a broader authorship sequence than authority requires

**Classification:** **NONBLOCKING OBSERVATION**  
**Exact location:** `items/source-packets/README.md`.  
**Controlling authority:** original item-author commission and Errata 0.1 §5.  
**Finding:** The README says item authorship may populate the directory only after all owner slots close. Authority forbids real-bank freeze and exposure while anti-taxidermy/design choices remain open, but it permits reversible commissioned drafting after the harness/scaffold boundary is frozen.  
**Smallest concrete consequence:** Legitimate draft authorship could be delayed unnecessarily.  
**Required disposition:** Distinguish `draft-item-worktree` from `frozen-bank`; allow section 4 commission work while preventing packet ingestion/freeze until all relevant gates close.

#### FI-31 — The transmitted LANG-A specimen is not valid under the protected Language-A validator

**Classification:** **BLOCKING BEFORE FREEZE**  
**Exact location:** `prompts/LANG-A.txt`, specimen `judgment` form; protected `mneme/language-a/validator.lisp`, especially `check-03-valid-status-values`, `check-05-support-names-existing-claim`, `check-06-referenced-receipt-exists`, `check-07-bounded-claim-has-boundary-fields`, and `check-10-answer-has-supporting-claim`.  
**Controlling authority:** original ruling §§3.3–3.4 and 3.9; the frozen Language-A public-record and validator contract; prohibition on repairing protected scope for this packet.  
**Finding:** The prompt’s displayed specimen omits a top-level `:id` and required `:status`; represents claims and supports as untyped ellipses without claim/support IDs, claim standings, `:faces`, or artifact/receipt bindings; and places procedure/boundary fields at top level rather than within the evidential claims whose boundaries the validator checks. A literal or structurally faithful completion of that specimen fails first at `CHECK-03` for missing/invalid status and cannot satisfy the later reference/boundary checks. The packet’s tests traverse the fourteen frozen fixtures, not the actual specimen transmitted by this prompt.  
**Smallest concrete consequence:** A cooperative subject can follow the supplied LANG-A shape and be penalized for producing a record the packet itself instructed it to produce.  
**Required disposition:** Replace the local prompt specimen with the smallest validator-lawful public `JUDGMENT` skeleton, preserving all validator limitations and the unchanged protected validator; add a network-off instantiation test that fills every placeholder and passes the frozen driver, plus malformed mutations proving the test is not a canned-fixture echo. Do not patch Mneme or the protected validator to accommodate the prompt.

#### FI-32 — The 312-call dry run bypasses the real prompt templates and no immutable renderer exists

**Classification:** **BLOCKING BEFORE FREEZE**  
**Exact location:** `controls/generate_controls.py`, function `generate_synthetic_items`; `controls/synthetic-items.jsonl`; `harness/run.py`, functions `make_request` and `execute`; `items/frozen/renderings.jsonl`; absence of a renderer binding task/source/template/wrapper to final request bytes.  
**Controlling authority:** original ruling §§3.2–3.4, 3.6, 3.9, and 7.1; exact-payload, manipulation-neutrality, and deterministic-replay duties.  
**Finding:** `generate_synthetic_items` writes a one-line `synthetic_prompt` such as `Synthetic-only task … Arm=LANG-A`; `run.py` transmits that string directly. It never loads `prompts/NL.txt`, `PERSONA.txt`, `SCAFFOLD.txt`, `LANG-A.txt`, or `SHAM.txt`, never binds source-packet bytes, and never exercises an item-to-arm renderer. The real rendering file is blank. The 312-call replay therefore validates schedule/provider/file plumbing, not composition or transmission of the packet’s actual arm templates.  
**Smallest concrete consequence:** Prompt leakage, malformed LANG-A structure, wrapper drift, source substitution, or rendering nondeterminism can remain completely invisible while the headline dry-run claim stays green.  
**Required disposition:** Implement an immutable network-off renderer that binds exact item/task bytes, source-packet bytes, selected frozen arm template, system/wrapper bytes, normalization rules, and final visible request bytes; make the synthetic run traverse that renderer for all arms; add parity, leakage, non-ASCII, malformed-placeholder, wrong-source, stale-template, and exact-byte mutations before freeze.

#### FI-33 — The scorer trusts provider-authored score facts and lacks a strict key/score contract

**Classification:** **BLOCKING BEFORE FREEZE**  
**Exact location:** `harness/provider_dry_run.py`, method `emit`; `harness/score.py`, functions `score_normalized` and `score_facts`; absence of a loaded score-record schema and real private-key interface.  
**Controlling authority:** original ruling §§3.6–3.9, 4.3–4.4, 6, and 7.1; Errata 0.1 §§4 and 6; fixed-denominator and anti-taxidermy duties.  
**Finding:** The synthetic provider emits its own `synthetic_score_facts`, and the scorer accepts those facts as the scoring substrate. There is no immutable key input or strict score schema. Defect counts may exceed `scorable_opportunities`; `answerable_units` and `emitted_answerable_units` are not range/type checked; emitted units may exceed answerable units; zero answerable units automatically yield completeness `1.0`; strings such as `"false"` become true through Python truthiness; and `answer_utility` is untyped. These are acceptable only as explicitly bounded scaffolding fixtures, not as evidence that the real scoring law exists.  
**Smallest concrete consequence:** A malformed or self-reporting response can manufacture favorable completeness/utility or impossible denominators without rejection.  
**Required disposition:** Add a strict, versioned score-input/output schema; derive opportunities and lawful dispositions only from immutable private-key bytes, never provider content; validate every count, range, enum, denominator, missing disposition, and parent digest; preserve raw and keyed views; add adversarial type/range/self-scoring mutations.

#### FI-34 — Two green tests validate labels or setup rather than the governing scoring rules

**Classification:** **BLOCKING BEFORE FREEZE**  
**Exact location:** `tests/test_packet.py`, `test_scorer_mutants_and_anti_taxidermy` and `test_primary_is_cell_weighted_secondary_is_labeled`; `harness/score.py`, `assert_mutant_detected`.  
**Controlling authority:** original ruling §§3.8–3.9 and 7.1; Errata 0.1 §§4–6; requirement that mutation tests demonstrate the underlying rule rather than their own fixture.  
**Finding:** The test constructs the `reward-deletion` mutant, confirms that it erases the coupled defect, and then stops; it never passes that mutant to `assert_mutant_detected(..., "deletion")`. Calling the detector would raise `ScorerMutationSurvived`, so the declared wholesale-deletion mutant is not killed by the green suite. Separately, the “primary weighting” test assigns one cell 10,000 opportunities but checks only that descriptive strings contain `unweighted mean` and `secondary`; it never checks a hand-derived primary estimate or proves invariance to opportunity weights.  
**Smallest concrete consequence:** The suite can report anti-taxidermy and primary-estimand protection while a deletion-reward mutation survives and a numerically weighted primary estimator could pass by preserving labels.  
**Required disposition:** Route every declared scorer/manifest/analysis mutant through an assertion that fails when the mutant survives; add hand-computed numerical oracles and metamorphic tests for cell weighting, missingness, denominator preservation, and boundary comparisons; make test enumeration fail when a declared mutant is unexercised.

#### FI-35 — Branch receipt digest does not bind the final receipt artifact

**Classification:** **BLOCKING BEFORE FREEZE**  
**Exact location:** `harness/analyze.py`, receipt construction and `receipt_sha256`; `harness/evidence.py`, post-analysis insertion of `claim_surface`; six archived branch receipts; absence of a strict final receipt schema.  
**Controlling authority:** original ruling §§3.9, 6, and 7.1; exact artifact identity, bounded-claim, and immutable-evidence duties.  
**Finding:** `analyze.py` computes `receipt_sha256` over the analysis receipt and returns it. `evidence.py` then adds `claim_surface` and writes the enlarged object without recomputing a final artifact digest. The field named `receipt_sha256` therefore identifies an internal predecessor object, not the final receipt bytes. No schema distinguishes analysis-core identity from final claim-bearing artifact identity or requires all branch-specific diagnostic/rider fields.  
**Smallest concrete consequence:** The final claim surface can change while the embedded `receipt_sha256` remains unchanged and appears to authenticate the whole receipt.  
**Required disposition:** Define separate `analysis_core_sha256` and final artifact SHA-256 semantics, or compute one digest only over canonical final bytes with an external sidecar; add a strict branch-receipt schema, manifest binding, successor-only revisions, and mutations of every claim/rider/branch field.

#### FI-36 — The protected-scope untracked-file check omits the `CD0-*.md` pathspec

**Classification:** **NONBLOCKING OBSERVATION**  
**Exact location:** `harness/manifest.py`, function `check_protected`.  
**Controlling authority:** protected-scope confinement and the builder commission’s independent protected-diff requirement.  
**Finding:** The tracked diff command checks `*PROTECTED` plus `CD0-*.md`; the untracked-file command checks only `*PROTECTED`. The reviewed bundle’s actual protected-scope diff is independently empty, so this does not alter the present branch identity. It is nevertheless a narrower executable gate than its tracked counterpart.  
**Smallest concrete consequence:** A future untracked root `CD0-*.md` file could evade `check_protected` even though a tracked file at the same path would be rejected.  
**Required disposition:** Use the same complete protected pathspec for tracked, staged, and untracked checks; add an untracked `CD0-*.md` mutation. Preserve this finding as nonblocking for the reviewed commit because the independent bundle diff is clean.

### 2.3 Faithful-incorporation conclusion

The controlling doctrine has not been repudiated or silently redefined. Its key scientific margins, estimand, fixed-subject structure, branch order, claim ceiling, taint philosophy, and construction-only boundary are recognizable and mostly accurately narrated. The executable implementation is nevertheless materially weaker than that narration in the exact places that convert a scaffold into a freeze: item/schema closure, lineage integrity, owner closure, actual rendering, validator-lawful LANG-A transmission, key-bound scoring, analysis admissibility, anti-taxidermy harm, SHAM integration, firebreak enforcement, claim control, deterministic numerical replay, receipt identity, and signed exposure authorization.

Accordingly:

* FI-01 and FI-05 are **BLOCKING BEFORE ITEM AUTHORSHIP**. Actor selection, commission drafting, owner decisions, and non-target-specific administrative preparation may proceed, but no target-specific source read, substantive item/task/source draft, witness artifact, or candidate rendering may be created until strict draft schemas and digest-chained lineage/read gates exist;
* the named **BLOCKING BEFORE FREEZE** findings must be repaired and rerun before any real-bank or packet freeze;
* all **BLOCKING BEFORE LIVE EXPOSURE** conditions remain closed;
* successful test execution cannot upgrade this holding.

---
## 3. COMPLETE OWNER-DECISION REGISTER

### 3.1 Register law

Every entry below is unresolved in the reviewed construction state unless the controlling ruling itself fixes the value. A builder default, fixture constant, prose aspiration, current placeholder, or passing synthetic result is not an owner decision. Numerical values that authority deliberately leaves open are not invented here.

Every adopted decision must be written as a typed, immutable owner record containing at least: `decision_id`, exact value or rule, allowed domain, rationale, controlling authority, affected artifacts, deciding actor, role/overlap disclosures, decision timestamp with offset, predecessor digest, and the exact executable gate closed by the decision. The record must be incorporated into the freeze manifest and exercised by positive and negative tests.

Every advisory sentence below is deliberately marked **RECOMMENDATION — AWAITING OWNER ADOPTION**. Such a recommendation remains inert until the owner adopts it in a manifest-bound ruling.

### 3.2 Scoring, completeness, refusal, utility, truncation, and admissibility

| ID and unresolved field | Exact location | Decision required and allowed shape | Recommendation | Dependencies, latest lawful time, gate, and consequence |
|---|---|---|---|---|
| ODR-01 — Answer-completeness units and bounded scale | `FREEZE-RULINGS.md`, minimum-completeness row; `operator/owner-slots.json`, `minimum-answer-completeness`; `scoring/SCORING-SPEC.md`; future private key | Define materially answerable content units, unit weights if any, score range, and treatment of required positive conclusions, lawful uncertainty, and non-applicable units. Range must be bounded and keyed to content, not verbosity or ceremonial fields. | **RECOMMENDATION — AWAITING OWNER ADOPTION:** use a key-defined `[0,1]` proportion of predeclared materially answerable units, with every unit and any unequal weight justified before target output exists; report raw numerator and fixed denominator as well as the proportion. | Depends on frozen item/source bytes and key doctrine. Must close before private key freeze and, under Errata §4, before real item-bank freeze. Gate: key-schema validator and anti-taxidermy analyzer. Unresolved consequence: omission cannot be measured and favorable burden can be purchased by silence. |
| ODR-02 — Completeness aggregation | Same records as ODR-01; `harness/analyze.py` | Choose cell-level aggregation and required summaries: overall paired delta, family, subject stratum, positive-conclusion subset, and any worst-stratum rule. State whether opportunity weights may appear only as secondary summaries. | **RECOMMENDATION — AWAITING OWNER ADOPTION:** preserve the primary unweighted paired cell estimand; report completeness overall, by family, by fixed subject, and on the mandatory positive-conclusion subset; do not let a pooled opportunity-weighted average determine a branch. | Depends on ODR-01 and final bank strata. Close before key freeze. Gate: analysis-schema and branch-receipt validator. Unresolved consequence: aggregation can hide localized answer-gutting. |
| ODR-03 — Minimum acceptable completeness | Same records as ODR-01 | Freeze one or more numerical floors and exact comparison operators. Authority supplies no number. If multiple floors exist, name their strata and precedence. | No numerical recommendation is made from the reviewed synthetic study; it lacks a lawful candidate-range study and must not learn the floor from target output. **RECOMMENDATION — AWAITING OWNER ADOPTION:** choose the floor only after synthetic/key-structure stress testing that is blind to target outputs. | Depends on ODR-01/02, key opportunity distributions, and repaired precision work. Latest lawful time: before real item-bank freeze. Gate: owner-slot closure and B-HARM predicate. Unresolved consequence: anti-taxidermy harm cannot be evaluated. |
| ODR-04 — Refusal definition | `FREEZE-RULINGS.md`, refusal/abstention row; `operator/owner-slots.json`, `tolerated-refusal-abstention-increase`; `SCORING-SPEC.md` | Operationally define refusal, including explicit policy refusal, inability refusal, non-engagement, and whether task-inapplicable cases are excluded by key rather than response. | **RECOMMENDATION — AWAITING OWNER ADOPTION:** define refusal as an explicit or functional refusal to perform an answerable task, distinct from source-grounded abstention and from truncation; make the key, not the response, determine whether the task was answerable. | Depends on key answerability dispositions. Close before key freeze. Gate: score-record schema and refusal mutation suite. Unresolved consequence: refusal rates are actor-dependent labels. |
| ODR-05 — Abstention definition | Same records as ODR-04 | Define abstention as a separate disposition, including lawful withholding under genuine insufficiency, unnecessary withholding on supported-positive items, and blanket uncertainty. | **RECOMMENDATION — AWAITING OWNER ADOPTION:** reserve “lawful abstention” for key-marked insufficiency; classify withholding a required supported conclusion as unnecessary abstention/positive-conclusion defect, not epistemic success. | Depends on the positive-conclusion and insufficiency flags in the key. Close before key freeze. Gate: scorer and positive-control mutations. Unresolved consequence: over-bounding can masquerade as prudence. |
| ODR-06 — Comparator, maximum refusal/abstention increase, and strata | Same records; `PREREG-v0.2.md`, anti-taxidermy gates | Name the paired comparator for each arm, numerical maximum absolute increase, confidence/point-estimate rule if any, and whether evaluated overall, by family, subject, or declared combination. Refusal and abstention may have separate limits. | No numerical limit is justified by current evidence. **RECOMMENDATION — AWAITING OWNER ADOPTION:** use paired absolute risk differences on frozen cells, report refusal and abstention separately, and activate harm if any predeclared overall/family/subject gate crosses its frozen maximum. | Depends on ODR-04/05 and missing-pair rules. Latest lawful time: before real item-bank freeze. Gate: B-HARM and receipt validator. Unresolved consequence: a burden reduction can be banked despite widespread non-answer. |
| ODR-07 — Utility scale and anchors | `FREEZE-RULINGS.md`, utility row; `operator/owner-slots.json`, `maximum-utility-decrement`; `PUBLIC-RUBRIC.md`; future key | Define bounded scale, direction, anchors, treatment of unsupported usefulness, lawful boundedness, and non-answer. | **RECOMMENDATION — AWAITING OWNER ADOPTION:** use a short anchored ordinal scale such as 0–4, higher-is-better, with item-specific key expectations; preserve the raw anchor label and do not pretend the intervals are metric. | Depends on item/key doctrine and grader calibration design. Close before key freeze. Gate: rubric/key schema and grader reliability checks. Unresolved consequence: “utility” is an unrepeatable impression. |
| ODR-08 — Utility comparator and aggregation | Same records as ODR-07 | Name paired comparator, cell aggregation, overall/family/subject summaries, and adjudication rule for grader disagreement. | **RECOMMENDATION — AWAITING OWNER ADOPTION:** use paired cell differences against the same arm comparator as the burden contrast, report median/category distribution plus predeclared risk of a material decrement, and preserve fixed subjects/families. | Depends on ODR-07 and grader protocol. Close before key freeze. Gate: analysis and receipt schemas. Unresolved consequence: pooling can conceal subject- or family-local utility loss. |
| ODR-09 — Maximum tolerated utility decrement | Same records as ODR-07 | Freeze numerical decrement and exact activation rule. Authority supplies no value. | No numerical recommendation is made from target-free evidence currently available. **RECOMMENDATION — AWAITING OWNER ADOPTION:** select through synthetic rubric calibration and declare before target-bank freeze; never tune to pilot outputs. | Depends on ODR-07/08 and synthetic calibration. Latest lawful time: before real item-bank freeze. Gate: anti-taxidermy B-HARM. Unresolved consequence: utility harm remains non-executable. |
| ODR-10 — Provider truncation | `FREEZE-RULINGS.md`, truncation row; `operator/owner-slots.json`, `truncation-treatment`; `run.py`, response records | Define provider-declared length truncation, finish-reason mapping, score treatment, census inclusion, and retry prohibition. | **RECOMMENDATION — AWAITING OWNER ADOPTION:** never treat provider truncation as transport failure; retain it in raw census; score delivered content and apply completeness/truncation consequences unless a predeclared rule makes it unanalyzable. | Depends on exact provider finish-reason mapping. Close before provider adapter freeze. Gate: response validator, retry gate, scorer. Unresolved consequence: truncated answers can be silently retried or selectively discarded. |
| ODR-11 — Token-limit termination | Same records as ODR-10; model-slot configuration | Define whether reaching frozen output cap is provider truncation, how partial structures are handled, and whether it activates a separate harm threshold. | **RECOMMENDATION — AWAITING OWNER ADOPTION:** classify any cap-caused termination as truncation even when the provider calls it “length”; no silent continuation call; score/census under ODR-10. | Depends on max-output-token and finish-reason decisions. Close before live-adapter freeze. Gate: response validator and retry mutation. Unresolved consequence: arms with greater instruction burden can receive extra effective budget. |
| ODR-12 — Incomplete structured output | Same records; `validate_output.py`; prompt schemas | Define syntax-incomplete but content-bearing output, distinction from provider truncation, scoring view, and analyzability. | **RECOMMENDATION — AWAITING OWNER ADOPTION:** preserve and score substantive delivered content where safely parseable; separately record structure failure and completeness; otherwise mark unanalyzable without removing the scheduled cell from census. | Depends on exact output grammar and normalization. Close before key and validator freeze. Gate: parser/normalizer mutations. Unresolved consequence: format errors can erase substantive failures or successes. |
| ODR-13 — Apparent self-truncation | Same records as ODR-10 | Define content-based indicators such as unfinished clauses, abrupt list termination, promised-but-absent sections, or explicit self-cutoff when provider metadata says complete; define grader/scorer authority and adjudication. | **RECOMMENDATION — AWAITING OWNER ADOPTION:** use a key/rubric-defined categorical flag with evidence span, independently scored from provider finish reason; include in completeness and truncation summaries. | Depends on rubric and grader training. Close before calibration freeze. Gate: score schema and adjudication rule. Unresolved consequence: self-gutting answers evade truncation accounting. |
| ODR-14 — Truncation-related numerical harm threshold | Same records | Decide whether truncation has its own numerical threshold and, if so, comparator, maximum increase, strata, and confidence rule. It may instead feed completeness/utility only, but that choice must be explicit. | No numerical recommendation is made. **RECOMMENDATION — AWAITING OWNER ADOPTION:** report truncation separately even if harm is mediated through completeness/utility; avoid double-counting the same event unless the branch rule explicitly defines it. | Depends on ODR-10–13 and opportunity structure. Latest lawful time: before real-bank freeze. Gate: B-HARM. Unresolved consequence: branch activation is underdetermined. |
| ODR-15 — Over-bounding general rule | `FREEZE-RULINGS.md`, over-bounding row; `owner-slots.json`, `over-bounding-treatment`; Errata §4.3 | Define when qualification ceases to be necessary boundedness and materially withholds answerable content; identify defect class and utility/completeness coupling. | **RECOMMENDATION — AWAITING OWNER ADOPTION:** require item-specific key distinctions among necessary qualification, optional nuance, and excessive qualification; score over-bounding as a separate positive-conclusion defect plus completeness/utility consequence where applicable. | Depends on positive-conclusion key entries. Close before key freeze. Gate: key schema, scorer, positive-control mutations. Unresolved consequence: blanket caveats are rewarded as low-burden success. |
| ODR-16 — Blanket-uncertainty treatment | Same records as ODR-15 | Define phrases/behaviors that merely repeat uncertainty while omitting a supported result, and distinguish them from lawful insufficiency. | **RECOMMENDATION — AWAITING OWNER ADOPTION:** key by item answerability, not lexical phrase alone; on a positive item, blanket uncertainty is unnecessary abstention and over-bounding even if it avoids unsupported claims. | Depends on item classification and key. Close before key freeze. Gate: scorer mutant and claim/rubric tests. Unresolved consequence: “insufficient evidence” becomes a universal escape hatch. |
| ODR-17 — Procedure-only and caveat-substitution treatment | Same records; synthetic scorer controls required by Errata §4.5 | Define output that recites method, limitations, or validation procedure but never gives the answerable conclusion; define scoring and defect coupling. | **RECOMMENDATION — AWAITING OWNER ADOPTION:** classify as omitted answerable material plus utility/completeness defect; procedural correctness does not satisfy a substantive opportunity unless the key explicitly asks for procedure. | Depends on key opportunities. Close before key freeze. Gate: dedicated mutation cases. Unresolved consequence: procedural fog can look “careful” while answering nothing. |
| ODR-18 — Excessive qualification and positive-conclusion defect | `PREREG-v0.2.md`; Errata §6; `items/design/design.json`, `positive_conclusion_minimum` | Define material weakening/obscuring of a supported conclusion and its separate receipt field; define catchability witness. | **RECOMMENDATION — AWAITING OWNER ADOPTION:** require a source-grounded headline conclusion test and a witness showing that a direct bounded conclusion is lawful; treat material withholding as a distinct defect. | Depends on at least eight positive items and private key. Close before item/key freeze. Gate: item/key schema and positive-control replay. Unresolved consequence: the bank cannot test the “release” side of bounded reasoning. |
| ODR-19 — Deletion and omission coupling | `FREEZE-RULINGS.md`, deletion/omission row; `owner-slots.json`, `deletion-omission-coupling`; `score.py` | Specify deterministic coupling from deletion, refusal, omission, answer-gutting, or opportunity non-instantiation to completeness, utility, truncation, abstention, or harm; prohibit denominator shrinkage. | **RECOMMENDATION — AWAITING OWNER ADOPTION:** preserve every key opportunity in the denominator; record the direct omission disposition and all applicable coupled defects; deduplicate only for reporting, not by erasing the denominator. | Depends on ODR-01–18 and key. Close before key freeze. Gate: scorer mutants for blank/refusal/truncation/procedural/blanket-uncertainty outputs. Unresolved consequence: lower burden can be achieved by deleting the task. |
| ODR-20 — Missing-pair treatment | `FREEZE-RULINGS.md`, missing/unanalyzable row; `owner-slots.json`; `analyze.py`; Errata §2.3 | Define whether and when a paired contrast cell is missing, no substitution/reweighting, reporting, and branch effect. | **RECOMMENDATION — AWAITING OWNER ADOPTION:** no imputation and no arm-only substitution in the confirmatory estimand; retain all missing cells in census; unexplained or differential missingness that compromises gates forces `B-INCONCLUSIVE`. | Depends on frozen schedule and response-status taxonomy. Close before analysis freeze. Gate: expected-cell closure and missing-pair mutations. Unresolved consequence: selective deletion changes the estimand. |
| ODR-21 — Non-ignorable missingness and analyzability adjudication | Same records as ODR-20; original acceptance gate | Define operational evidence for transport failure, policy refusal, malformed output, lost custody, and other unanalyzable states; determine which are non-ignorable. | **RECOMMENDATION — AWAITING OWNER ADOPTION:** preclassify states without arm/outcome knowledge; treat policy/refusal/truncation as observed behavioral outcomes rather than transport loss; unknown custody or differential missingness blocks substantive branches. | Depends on response and retry schemas. Close before live-adapter freeze. Gate: census/admissibility engine. Unresolved consequence: inconvenient outcomes can be relabeled “missing.” |
| ODR-22 — Exact analyzability floors | Original ruling §7.1: at least 90% of 312 overall and 80% in every core arm×subject×family stratum; `design.json`; `analyze.py` | Convert percentages into exact integer thresholds for the final frozen design and define denominator under any lawful pre-freeze item allocation adjustment. | **RECOMMENDATION — AWAITING OWNER ADOPTION:** retain the authority-fixed percentages; generate integer minima directly from the frozen schedule with an explicitly frozen ceiling rule, and archive the generated table. | Depends on final design geometry. Latest lawful time: before schedule freeze. Gate: generated-count validator and analysis admission. Unresolved consequence: “90%/80%” can be rounded or denominated opportunistically. |
| ODR-23 — Zero-answerable-opportunity cells | `score.py`, current `answerable == 0 -> completeness 1.0`; future key | Decide whether a legitimately zero-opportunity item exists, how completeness is represented, and whether it belongs in the burden/completeness estimands. | **RECOMMENDATION — AWAITING OWNER ADOPTION:** forbid accidental zero-denominator cells; if a deliberate bounded control has no opportunity of one defect family, mark that family `not-applicable` rather than assign perfect global completeness. | Depends on key schema. Close before key freeze. Gate: zero-denominator mutation. Unresolved consequence: empty keys can create automatic perfect scores. |
| ODR-24 — Cost-harm threshold, if any | `PREREG-v0.2.md`; branch law permits predeclared cost harm; `FREEZE-RULINGS.md`; price table | Decide whether cost is merely a hard operational stop or also an arm-level harm gate; if latter, freeze metric, comparator, threshold, strata, and billing basis. | **RECOMMENDATION — AWAITING OWNER ADOPTION:** keep USD 8.00 and 344 attempts as hard stop laws; add a branch-level cost-harm gate only if exact per-call billing is comparable across routes and a scientifically meaningful threshold can be justified before output. | Depends on exact prices, token accounting, and route comparability. Close before prereg freeze. Gate: cost ledger/B-HARM. Unresolved consequence: the packet’s branch text mentions cost harm without an executable rule. |

### 3.3 Subjects, providers, routes, model identity, request settings, and cost

| ID and unresolved field | Exact location | Decision required and allowed shape | Recommendation | Dependencies, latest lawful time, gate, and consequence |
|---|---|---|---|---|
| ODR-25 — Exact three subject slots | `FREEZE-STAFFING.md`; `owner-slots.json`, `subject-provider-model-routes`; `design.json`, synthetic placeholders | Replace exactly three placeholders with immutable subject-slot records. Each record must bind declared model family, requested release, route, endpoint, provider, tokenizer, wrapper/system bytes, decoding, safety/tool/cache/retention settings, and claim name. | **RECOMMENDATION — AWAITING OWNER ADOPTION:** use three genuinely distinct declared model families, preserve at least one non-Claude subject, and treat all three as fixed named strata—not a sample of models. | Depends on route availability and budget. Close before schedule freeze. Gate: subject-slot schema and schedule generation. Unresolved consequence: no lawful target or claim boundary exists. |
| ODR-26 — Exact provider routes and endpoints | Same records as ODR-25 | Name at least two exact provider routes/endpoints, API/console mode if applicable, region, version, and adapter identity. No generic “Provider A” at freeze. | **RECOMMENDATION — AWAITING OWNER ADOPTION:** avoid routing two purportedly distinct subjects through an opaque aggregator unless that shared route is explicitly declared and claims are correspondingly narrowed. | Depends on model choices and data policy. Close before adapter/schedule freeze. Gate: route identity and returned-ID validator. Unresolved consequence: provider diversity and cost/retention claims are ungrounded. |
| ODR-27 — Exact model-release identities and family classification | Same records; claim riders | Freeze requested release strings, effective dates, family labels, provider aliases, and any version pin. State what evidence supports the identity. | **RECOMMENDATION — AWAITING OWNER ADOPTION:** prefer immutable dated/versioned release identifiers; where the provider exposes only a moving alias, treat the returned identity as potentially unresolved and narrow or cancel rather than pretending a pin. | Depends on provider disclosure. Close before schedule freeze. Gate: model-identity preflight and response admission. Unresolved consequence: the “exact subject release” rider is false or unfillable. |
| ODR-28 — Requested versus returned model-ID handling | Original ruling request/response records; `validate_output.py`; `provider_base.py` | Define exact-match, preapproved alias-map, provider-undisclosed, and mismatch dispositions. Define whether an undisclosed or changed ID stops, quarantines, or invalidates a subject slot. | **RECOMMENDATION — AWAITING OWNER ADOPTION:** admit only exact match or a frozen, evidence-backed alias equivalence; otherwise stop/quarantine before scoring and do not silently substitute. | Depends on ODR-27 and adapter capability. Close before live-adapter freeze. Gate: response validator and first-call preflight. Unresolved consequence: outputs from an unintended release enter the fixed stratum. |
| ODR-29 — Temperature and top-p | `FREEZE-STAFFING.md`; original §3.3; future subject-slot config | Freeze exact values or explicit `unsupported/not-exposed` for each slot; define provider default prohibition. | **RECOMMENDATION — AWAITING OWNER ADOPTION:** choose the lowest deterministic setting the endpoint supports, but describe it only as low-variance unless replay demonstrates determinism; never infer an omitted parameter’s value. | Depends on endpoint docs/config evidence. Close before adapter freeze. Gate: request-envelope schema. Unresolved consequence: unreproducible or unequal decoding. |
| ODR-30 — Seed behavior | Same records; request schema | Freeze exact seed if supported, unsupported state, provider guarantees, retry reuse rule, and returned seed metadata. | **RECOMMENDATION — AWAITING OWNER ADOPTION:** record `unsupported` rather than a null that could mean forgotten; if supported, reuse the same frozen per-call seed on a true transport retry and bind it to the parent. | Depends on endpoint. Close before adapter freeze. Gate: request/retry validator. Unresolved consequence: hidden resampling and false deterministic claims. |
| ODR-31 — Maximum output tokens | `design.json`, 768; subject-slot settings | Adopt or revise within existing authority, bind exact provider parameter semantics, and recalculate total ceiling. | **RECOMMENDATION — AWAITING OWNER ADOPTION:** retain 768 only if tokenizer/output-mode checks show it supports all frozen response forms without systematic arm-specific truncation; any change must preserve 344-attempt and USD 8 ceilings and regenerate counts. | Depends on repaired precision/token burden and cost table. Close before schedule freeze. Gate: design algebra and request schema. Unresolved consequence: token ceiling or truncation exposure is misstated. |
| ODR-32 — Wrapper and system-material bytes | `prompts/*`; `FREEZE-STAFFING.md`; original §3.3 | Freeze exact target-visible task bytes, provider wrapper, system/developer material, separators, JSON envelope, and hash for each route; state any provider-injected hidden material as unknown. | **RECOMMENDATION — AWAITING OWNER ADOPTION:** use arm-neutral system/wrapper bytes and vary only the frozen arm manipulation; archive exact wire-equivalent payload where provider API permits. | Depends on FI-02/FI-08 repairs. Close before item rendering/schedule freeze. Gate: prompt parity and request-envelope hash. Unresolved consequence: condition differences are confounded by wrappers. |
| ODR-33 — Tools, retrieval, memory, context, and fresh session | Original §3.3; `FREEZE-STAFFING.md`; adapter config | Freeze tools off, retrieval off, cross-call memory off, conversation/session creation, context policy, and any provider-side history setting; define unverifiable states. | **RECOMMENDATION — AWAITING OWNER ADOPTION:** one fresh session per call, no tools/retrieval/memory, no prior turns, and an explicit stop if the route cannot guarantee the declared context boundary. | Depends on route capabilities. Close before adapter freeze. Gate: request config and operator preflight. Unresolved consequence: calls are not exchangeable first-pass emissions. |
| ODR-34 — Safety mode and policy layer | Same records | Freeze exposed safety/moderation settings and treatment of unavoidable provider policy layers; distinguish policy refusal from transport failure. | **RECOMMENDATION — AWAITING OWNER ADOPTION:** use provider defaults only when immutable and recorded; do not attempt to suppress safety layers; preserve policy refusals as behavioral outcomes. | Depends on route. Close before adapter freeze. Gate: response status mapping. Unresolved consequence: policy effects are hidden or retried away. |
| ODR-35 — Caching | Original §3.3; `FREEZE-STAFFING.md`; price-table slot | Record `disabled`, `provider-reported`, or `unknown` separately for inference caching, prompt caching, and billing cache; include exact controls and response metadata. | **RECOMMENDATION — AWAITING OWNER ADOPTION:** disable where an explicit control exists; otherwise record unknown/provider-reported, never “absent.” | Depends on route. Close before adapter freeze. Gate: subject-slot/config validator and cost ledger. Unresolved consequence: independence/replay and price statements overreach. |
| ODR-36 — Retention and privacy disclosures | `FREEZE-STAFFING.md`; owner subject-route slot | Record provider retention period, training-use setting, enterprise/privacy mode, region, log handling, and unknowns; decide whether any route is disallowed. | **RECOMMENDATION — AWAITING OWNER ADOPTION:** prefer routes with contractually disabled training use and shortest declared retention, while recording that this is custody policy—not proof of deletion. | Depends on provider terms available to owner. Close before any real item leaves local custody. Gate: route authorization. Unresolved consequence: undisclosed transmission/retention of private bank content. |
| ODR-37 — Provider tokenizer identity and parity method | Original §§3.3–3.4; prompt-parity check; SHAM rule | Name tokenizer/version or provider-reported counting method per subject; freeze exact parity computation for SCAFFOLD/LANG-A and SHAM/LANG-A. | **RECOMMENDATION — AWAITING OWNER ADOPTION:** use provider-native/tokenizer-version counts where reproducible, archive input-count receipts, and treat unavailable counts as a named limitation rather than substitute word count. | Depends on routes/prompts. Close before prompt freeze and SHAM status. Gate: tokenizer-parity validator. Unresolved consequence: 10% obligations are only approximated by raw words/bytes. |
| ODR-38 — Exact price table and effective date | `owner-slots.json`, `price-table`; original §3.8; `run.py` | Freeze per-route/model input/output/cache/reasoning prices, units, currency, effective date/time, taxes/credits treatment, source receipt, and alias/version mapping. | **RECOMMENDATION — AWAITING OWNER ADOPTION:** use an immutable owner-captured price-table artifact effective at fire time; if a price changes, stop and issue a successor freeze rather than patching in place. | Depends on exact routes/releases. Close before cost preflight. Gate: price-table hash and run reservation. Unresolved consequence: USD 8 ceiling cannot be proven. |
| ODR-39 — Input-token census and five-percent allowance | Original cost law; `run.py` lacks input ceiling | Define exact input census source, whether provider count or frozen tokenizer count controls, allowed overhead, and calculation of the five-percent input allowance. | **RECOMMENDATION — AWAITING OWNER ADOPTION:** calculate worst-case input tokens from exact frozen request envelopes per route, add the authority’s five-percent allowance once, and record provider-reported actuals separately. | Depends on wrappers/tokenizers/items. Close before fire manifest. Gate: cost reservation. Unresolved consequence: cost ceiling can be exceeded before output begins. |
| ODR-40 — Worst-case pre-call reservation and billing disclosure | Same records as ODR-38/39; `CostLedger` | Define pre-call reservation formula for input, maximum output, cache, reasoning, retry, and rounding; define stop when unknown or insufficient remaining budget. | **RECOMMENDATION — AWAITING OWNER ADOPTION:** reserve worst-case marginal cost before every attempt and release only after immutable usage receipt; unknown billing components use conservative maximum or disqualify the route. | Depends on ODR-31/35/38/39. Close before adapter freeze. Gate: cost ledger. Unresolved consequence: stop occurs after overspend rather than before it. |
| ODR-41 — Declared run window | Claim riders; staffing/config records | Freeze start/end window, timezone, allowed pause/restart rule, and whether a model/price/config change inside the window invalidates a slot. | **RECOMMENDATION — AWAITING OWNER ADOPTION:** use a short exact UTC window plus local display; any release, route, wrapper, or price change causes stop and successor freeze. | Depends on staffing/provider availability. Close before pre-exposure signature. Gate: operator clock/config check and claim linter. Unresolved consequence: “declared run window” rider has no value. |
| ODR-42 — Transport retry definition and allocation | Original §3.3; `design.json`; run/retry records | Freeze transport-only failure codes, maximum 32 global retries, per-parent linkage, same request settings, scheduling policy, and exhaustion behavior. | **RECOMMENDATION — AWAITING OWNER ADOPTION:** retry only failures that yield no usable model output; never retry refusal, policy, content, truncation, malformed-but-delivered, or low-quality outcomes; preserve failed parent bytes. | Depends on provider status mapping. Close before adapter freeze. Gate: retry validator and 344-attempt ledger. Unresolved consequence: selective outcome resampling. |

### 3.4 Staffing, role overlap, grading, and adjudication

| ID and unresolved field | Exact location | Decision required and allowed shape | Recommendation | Dependencies, latest lawful time, gate, and consequence |
|---|---|---|---|---|
| ODR-43 — Item-author identities | `FREEZE-STAFFING.md`; item commission | Name each human/model-assisted actor, session/model/tool use, family assignment, repository access, prior exposure, and shared roots. | **RECOMMENDATION — AWAITING OWNER ADOPTION:** use two declared authors with disjoint primary family assignments and cross-review, plus a separate freezer/overlap auditor; do not call them independent. | Depends on section 4 commission. Close before real item bytes are created. Gate: role/access manifest. Unresolved consequence: provenance and taint cannot be assessed. |
| ODR-44 — Prompt/scaffold author and parity reviewer | `FREEZE-STAFFING.md`; `prompts/*` | Name author, reviewer, model assistance, shared roots, and who certifies arm neutrality/token parity. | **RECOMMENDATION — AWAITING OWNER ADOPTION:** separate prompt drafting from parity/leak review where staffing permits; reviewer receives no target outputs. | Depends on FI-02 repair. Close before prompt freeze. Gate: prompt-authority and review receipts. Unresolved consequence: manipulation confounds are self-certified. |
| ODR-45 — Harness builder and successor live-adapter builder | `FREEZE-STAFFING.md`; Git/evidence records | Confirm builder of record; name any repair/live-adapter builder and exact scope; disclose overlap with item/key/grader/operator roles. | **RECOMMENDATION — AWAITING OWNER ADOPTION:** retain current builder identity for repair traceability but use separate review/freezer authority; separately commission any live adapter. | Depends on repair plan. Close before repair candidate acceptance. Gate: lineage actors and protected-scope audit. Unresolved consequence: code ancestry and conflicts are concealed. |
| ODR-46 — Private key author and custodian | `FREEZE-STAFFING.md`; `KEY-CUSTODY-RECEIPT.md`; key slot | Name author, custodian, any overlap, worktree/system, copy count, encryption/access method, and authorized readers. | **RECOMMENDATION — AWAITING OWNER ADOPTION:** use an actor distinct from runner/operator and preferably distinct from item authors; designate one custodian and one documented recovery path. | Depends on frozen item/source bytes and section 5. Close before key authorship. Gate: key custody receipt and mount policy. Unresolved consequence: key exposure/ancestry cannot be bounded. |
| ODR-47 — Freezer and operator identities | `FREEZE-STAFFING.md`; operator checklists | Name freezer, fire operator, possible backup, signature keys/methods, access rights, and overlap with builder/key/grader roles. | **RECOMMENDATION — AWAITING OWNER ADOPTION:** separate freezer from live operator if possible; neither should be a primary grader; any overlap is explicit and narrows claims. | Depends on staffing. Close before final verification. Gate: signed freeze and fire receipts. Unresolved consequence: no accountable authority for the irreversible action. |
| ODR-48 — Two primary grader identities | `FREEZE-STAFFING.md`; public rubric; firebreak | Name two graders, sessions/model releases/routes if automated, training/calibration reads, prior target access, and shared roots. | **RECOMMENDATION — AWAITING OWNER ADOPTION:** use two graders whose operational sessions are separate and whose avoidable model-family/provider roots differ; explicitly record the shared rubric/key/error-taxonomy root. | Depends on section 6. Close before calibration freeze. Gate: role/read chronology. Unresolved consequence: blind-first-pass and agreement claims are unsupported. |
| ODR-49 — Adjudicator identity | `FREEZE-STAFFING.md`; adjudication rule | Name actor/session/family/route, allowed packet, prior reads, and shared roots. | **RECOMMENDATION — AWAITING OWNER ADOPTION:** prefer a human fresh chair; otherwise use a fresh session and, where feasible, a distinct family/provider, while making no “fresh weights” claim. | Depends on grader panel. Close before target scoring begins. Gate: adjudicator access policy. Unresolved consequence: disagreement resolution may be contaminated by prior outputs. |
| ODR-50 — Role overlaps and shared-root ledger | `FREEZE-STAFFING.md`; lineage search field | Enumerate every overlap among author, prompt author, builder, key author, custodian, freezer, operator, grader, adjudicator, provider/model assistance, and owner; specify permitted/prohibited combinations. | **RECOMMENDATION — AWAITING OWNER ADOPTION:** prohibit runner/operator from key authorship/custody and primary grading; allow item/key overlap only under section 5 waiver; treat all shared doctrine/repository/model/operator roots as explicit. | Depends on all role assignments. Close before any role-specific read. Gate: role matrix/firebreak. Unresolved consequence: fictional independence and unauthorized access. |
| ODR-51 — Grader reliability gate when kappa is defined | Original §3.7; public rubric | Confirm ≥0.80 raw agreement and Cohen’s kappa ≥0.60 for each primary categorical defect family, sample definition, confidence/reporting, and continuous-count rule. | **RECOMMENDATION — AWAITING OWNER ADOPTION:** preserve the authority thresholds and publish confusion matrices by defect family; do not pool families to rescue a weak one. | Depends on synthetic calibration corpus. Close before target scoring. Gate: calibration receipt. Unresolved consequence: unreliable graders proceed. |
| ODR-52 — Replacement gate when kappa is undefined | Original §3.7; `FREEZE-STAFFING.md` | Predeclare exact fallback using raw agreement and full confusion table; decide whether positive/negative agreement, prevalence-adjusted measures, or replacement grader is required. | **RECOMMENDATION — AWAITING OWNER ADOPTION:** require ≥0.80 raw agreement plus full confusion matrix and class-specific positive and negative agreement; where the defect class is absent or too sparse to test, add synthetic calibration cases or replace/recalibrate rather than declaring reliability from undefined kappa. | Depends on calibration distributions. Latest lawful time: before target scoring. Gate: calibration validator. Unresolved consequence: undefined kappa becomes an automatic pass. |
| ODR-53 — Prematurely exposed grader disposition | `FREEZE-STAFFING.md`; firebreak | Define what counts as exposure, affected scope, disqualification, exploratory retention, replacement, and lineage receipt. | **RECOMMENDATION — AWAITING OWNER ADOPTION:** any target-bank/source/key/target-output read before the authorized event disqualifies the grader from the affected blind panel; retain its work only as labeled exploratory evidence. | Depends on artifact taxonomy/versioned reads. Close before calibration. Gate: integrated firebreak. Unresolved consequence: contaminated first pass is treated as blind. |
| ODR-54 — Adjudicator freshness and shared roots | `FREEZE-STAFFING.md`; claim ceiling | Define fresh session, prior-read exclusions, distinct-family/provider preference, unavoidable shared doctrine/key roots, and fallback when no fresh chair exists. | **RECOMMENDATION — AWAITING OWNER ADOPTION:** freshness means a new operational context with no target-output access before locked disagreements, not new weights; disclose shared rubric, taxonomy, key, repository, and operator roots. | Depends on ODR-49/50. Close before scoring. Gate: adjudication-packet authorization. Unresolved consequence: “independent adjudication” overclaims ancestry. |
| ODR-55 — Calibration corpus and permanent taint | `FREEZE-STAFFING.md`; `firebreak.py`; synthetic controls | Freeze synthetic-only corpus identity, creation provenance, permanent exclusion from target bank, version, grader reads, and mutation coverage. | **RECOMMENDATION — AWAITING OWNER ADOPTION:** seal calibration examples and their paraphrases/derivatives in a permanent taint registry before graders see them; run lexical and semantic overlap against the target bank at freeze. | Depends on section 6. Close before calibration. Gate: taint/overlap validator. Unresolved consequence: target examples leak through calibration ancestry. |

### 3.5 SHAM, design disposition, seeds, resampling, and statistical execution

| ID and unresolved field | Exact location | Decision required and allowed shape | Recommendation | Dependencies, latest lawful time, gate, and consequence |
|---|---|---|---|---|
| ODR-56 — SHAM tri-status operational procedure | `FREEZE-RULINGS.md`; `harness/sham.py`; `PREREG-v0.2.md`; SHAM prompt | Define uptake measurement, 70% denominator, explicit-discard evidence, semantic-leak audit, per-provider token parity, who judges each component, and immutable status receipt. Only `SHAM-DISENGAGED`, `SHAM-OPERATIVE`, or `SHAM-VALID` may issue. | **RECOMMENDATION — AWAITING OWNER ADOPTION:** compute uptake over exactly 24 scheduled SHAM calls; use blinded leak review; require provider-tokenizer parity for every subject; keep the result diagnostic and outside primary branch selection. | Depends on final prompt, item bank, tokenizers, and grader roles. Close before bank/prompt freeze. Gate: SHAM receipt validator. Unresolved consequence: a status can be issued from incomplete evidence. |
| ODR-57 — SHAM overlap and token-edge authority path | Same records; `sham.py` authority-return case | Decide whether semantic leak and explicit discard can overlap; if possible, obtain scoped precedence. Preserve authority-return for uptake ≥70%, no leak/discard, but >10% token burden unless controlling authority supplies a status. | **RECOMMENDATION — AWAITING OWNER ADOPTION:** redesign the audit categories to make leak and explicit-discard evidence separately reportable and do not let code invent precedence; if the unassigned token-edge remains possible at freeze, seek authorial return before exposure. | Depends on ODR-56 and prompt parity. Close before SHAM protocol freeze. Gate: exhaustive SHAM truth-table test. Unresolved consequence: an unauthorized fourth meaning or precedence is smuggled in. |
| ODR-58 — Synthetic-precision design disposition | `owner-slots.json`, `design-disposition-after-synthetic-precision`; Errata §5.4; current precision report | Adopt exactly one permitted disposition after a repaired study: retain as feasibility-oriented; make an in-scope pre-freeze design adjustment; retain while acknowledging `B-INCONCLUSIVE` expected dominant; or return for out-of-scope authority. | **RECOMMENDATION — AWAITING OWNER ADOPTION:** after repairing the study, adopt the permitted disposition “retain the design while acknowledging that `B-INCONCLUSIVE` is expected to dominate the studied plausible sparse/moderate range,” unless the repaired grid materially contradicts the review diagnostics. | Depends on FI-16/FI-17 repair. Latest lawful time: before real item-bank freeze. Gate: design status and manifest. Unresolved consequence: current hard-coded “retain feasibility” text masquerades as owner adoption. |
| ODR-59 — Permitted item-count or family-allocation adjustment | `design.json`, `permitted_adjustment`; Errata §5.4 | Decide exact 24×4-family geometry or an in-scope adjustment preserving three subjects, arm semantics, margins, branch predicates, and call/spend ceilings; recalculate every dependent count. | **RECOMMENDATION — AWAITING OWNER ADOPTION:** retain 24 items and six per family for this feasibility pilot unless the repaired precision study justifies an in-scope reallocation; do not tune item count merely to make a desired branch fire. | Depends on ODR-58 and source-authoring feasibility. Close before authors receive final quotas and before schedule freeze. Gate: design validator. Unresolved consequence: author quotas and analyzability denominators drift. |
| ODR-60 — Positive, insufficiency, and trap allocation details | `design.json`; Errata §6; item commission | Beyond the fixed minima of at least eight each, decide whether categories may overlap, minimum per-family distribution, and how distinctness is proved. | **RECOMMENDATION — AWAITING OWNER ADOPTION:** permit overlap only when an item genuinely and independently satisfies each declared role; require at least one positive, one insufficiency, and one closed-class trap in every family, with the remaining quota balanced before authorship. | Depends on ODR-59. Close before item commission. Gate: item-bank validator. Unresolved consequence: all controls cluster in one family or labels are nominal. |
| ODR-61 — Schedule seed | `design.json`, `randomization_seed_label`; schedule generator | Freeze actual seed bytes/digest, generation method, custody timing, blocked-randomization algorithm/version, and who may know it before item freeze. | **RECOMMENDATION — AWAITING OWNER ADOPTION:** use a high-entropy owner-generated master seed recorded only after item/rendering freeze, derive schedule randomness by domain-separated hash, and publish the seed at freeze before exposure. | Depends on final bank/subjects. Close before schedule generation. Gate: deterministic schedule replay. Unresolved consequence: builder-selected ordering or hidden rerandomization. |
| ODR-62 — Bootstrap seed | `scoring/branch-rules.json`, current `1729`; `analyze.py` | Adopt exact seed and derivation; ensure independent domain from schedule/randomization/precision seeds. | **RECOMMENDATION — AWAITING OWNER ADOPTION:** derive from the owner master seed using a fixed label such as `LAE/BOOTSTRAP/PRIMARY/v1`; do not retain `1729` merely because the builder chose it. | Depends on owner seed policy. Close before analysis-code freeze. Gate: analysis replay. Unresolved consequence: an undeclared builder default controls intervals. |
| ODR-63 — Bootstrap iteration count | `branch-rules.json`, current 800; `analyze.py` | Freeze exact count and interval algorithm, including quantile convention and any Monte Carlo error check. | **RECOMMENDATION — AWAITING OWNER ADOPTION:** use at least 20,000 item-stratified replicates for final analysis, or a higher count justified by a predeclared Monte Carlo stability criterion; 800 is suitable for quick fixtures, not a freeze-quality 95% boundary. | Depends on performance/runtime lock. Close before analysis freeze. Gate: code/config identity. Unresolved consequence: branch labels near margins are sensitive to simulation noise. |
| ODR-64 — Paired sign/randomization-test method | Original §3.7; Errata §2.4; absent implementation | Choose exact sign-flip/permutation scheme, statistic, cluster unit, fixed-subject preservation, one/two-sided use, multiplicity/reporting, and relation to branch selection. | **RECOMMENDATION — AWAITING OWNER ADOPTION:** use item-cluster sign flips within predeclared family strata while retaining all three fixed subjects for the item; treat it as required corroborating evidence, not a substitute branch threshold. | Depends on final estimand and missing-pair rule. Close before analysis freeze. Gate: randomization replay. Unresolved consequence: one required analysis is absent. |
| ODR-65 — Randomization-test seed and iteration count | Same records as ODR-64 | Freeze seed and either exact enumeration rule or Monte Carlo count and p-value convention. | **RECOMMENDATION — AWAITING OWNER ADOPTION:** enumerate exactly when the item-level sign space is tractable; otherwise use at least 100,000 domain-separated draws with a plus-one correction and archived Monte Carlo stability receipt. | Depends on final item count and ODR-61/64. Close before analysis freeze. Gate: deterministic test replay. Unresolved consequence: p-values/checks vary or pseudo-replicate cells. |
| ODR-66 — Precision-study master seed, replications, bootstrap count, and canonical numerics | `precision.py`; `precision-scenarios.json`; precision report | Freeze separate seed, broad-grid scenario table, repetitions per scenario, bootstrap iterations, runtime, rounding/canonical serialization, and Monte Carlo uncertainty. | **RECOMMENDATION — AWAITING OWNER ADOPTION:** use a domain-separated precision seed, materially more than 36 scenario repetitions, freeze a Monte Carlo precision target rather than merely a convenient count, and serialize summary numerics as fixed decimal strings. | Depends on FI-16/FI-17 repair. Close before design disposition. Gate: precision byte replay. Unresolved consequence: the study is favorable-fixture demonstration rather than operating-characteristic evidence. |
| ODR-67 — Manipulation checks and prompt-burden parity | `PREREG-v0.2.md`; prompts; `analyze.py` defaults | Define uptake/structure checks for each arm, who scores them, provider-tokenizer parity, arm-label leak checks, failure effect, and receipt fields. | **RECOMMENDATION — AWAITING OWNER ADOPTION:** calculate checks from blinded target-visible outputs and exact prompt artifacts; a failed core manipulation makes stronger branches unavailable, while SHAM remains diagnostic only. | Depends on prompt/item freeze and tokenizers. Close before scoring/analysis freeze. Gate: manipulation-check engine. Unresolved consequence: a caller Boolean can license branches. |

### 3.6 Key custody, lineage, claims, environment, and irreversible authorization

| ID and unresolved field | Exact location | Decision required and allowed shape | Recommendation | Dependencies, latest lawful time, gate, and consequence |
|---|---|---|---|---|
| ODR-68 — Private score-key custody | `KEY-CUSTODY-RECEIPT.md`; `key-hash.txt`; key owner slot | Name immutable key artifact(s), SHA-256/length, author, custodian, storage boundary, encryption/access, authorized copies, recovery, destruction/retention policy, and read ledger. | **RECOMMENDATION — AWAITING OWNER ADOPTION:** one canonical immutable key bundle, one custodian, encrypted offline-at-rest storage, separately hashed item-specific slices, and no runner/subject worktree copy. | Depends on frozen items and section 5 commission. Close before key freeze. Gate: custody receipt and filesystem audit. Unresolved consequence: denominator/key exposure is unbounded. |
| ODR-69 — Key mounting procedure | Same records; `run.py` key denial | Define exact event after raw-response lock at which scoring process receives read-only key or item-specific slice; mount namespace/path, process identity, unmount, failure behavior, and logged reads. | **RECOMMENDATION — AWAITING OWNER ADOPTION:** mount only in a separate offline scoring worktree/process after request/raw/normalized census lock; expose only item-scoped key material needed for that batch; fail closed on any pre-lock read. | Depends on ODR-68 and scoring architecture. Close before scoring dry run. Gate: OS-level access test/firebreak. Unresolved consequence: runner or subject lane can see the key. |
| ODR-70 — Authorized key reads and grader/adjudicator slices | Same records; lineage/firebreak | Specify which actors receive full key, item-specific scoring packets, or disputed-opportunity slices; define versioned read receipts. | **RECOMMENDATION — AWAITING OWNER ADOPTION:** full key only to author/custodian and deterministic scoring preparation; primary graders receive item-specific frozen scoring packets after response lock; adjudicator receives only disputed slices. | Depends on grader workflow. Close before target scoring. Gate: role/read authorization. Unresolved consequence: unnecessary bank-wide key exposure. |
| ODR-71 — Frozen item-to-key handoff identity and information minimization | Future item/freezer/key handoff; item/key freeze slot | Freeze two separately manifested artifacts: a freezer-only dossier containing role proposals, witnesses, ancestry/exposure and overlap records; and a key-author input containing only exact item/task/rendering bytes, exact finite source-packet bytes, controlling scoring doctrine, and neutral custody metadata. Decide signer, recipient, invalidation rule, and first-read receipt. | **RECOMMENDATION — AWAITING OWNER ADOPTION:** adopt the dual-artifact boundary in sections 4.11 and 5.1; any change to an item/source/doctrine byte invalidates and restarts key authorship, while freezer-only judgments never cross into the key-author input before key fixation. | Depends on section 4, ODR-43/68/69/70, and strict schemas. Close before the key author’s first read. Gate: two manifest digests plus authorized-read receipt. Unresolved consequence: the key may be authored against a moving bank or contaminated by the item author’s proposed answer. |
| ODR-72 — Lineage search-field stopping rule and query set | `lineage/search-field.json`; original §4 | Adopt exact actor/artifact/read/transmission query list, unknown handling, timestamp, and stop rule for the final frozen population. | **RECOMMENDATION — AWAITING OWNER ADOPTION:** retain the current dimensions but replace generic remaining queries with deterministic manifest-derived queries; terminate only when every frozen ID resolves and unavailable roots are named unknowns, never silently absent. | Depends on final actors/artifacts. Close before pre-exposure gate. Gate: lineage closure validator. Unresolved consequence: “search complete” can be set as a string without executing searches. |
| ODR-73 — Corroboration dimensions and bounded claim form | `lineage/search-field.json`, dimensions; claim law | Decide which dimensions are actually observed well enough for `CORROBORATED-UNDER`, exact bounds, unknown roots, and prohibited inference. | **RECOMMENDATION — AWAITING OWNER ADOPTION:** allow only dimensions supported by immutable receipts—such as declared subject release, route, run window, and scoring process—and never translate route/model count into global independence or robustness. | Depends on final lineage and run receipts. Close before downstream claims. Gate: structured claim record/linter. Unresolved consequence: “corroborated” floats free of its dimension. |
| ODR-74 — Claim-linter phrase and semantic-equivalence coverage | `claim_lint.py`; claim-linter test; branch outputs | Approve forbidden proposition families, paraphrase/morphology coverage, structured claim fields, allowed bounded formulations, and review process for new surfaces. | **RECOMMENDATION — AWAITING OWNER ADOPTION:** use typed claim templates and explicit prohibited semantic predicates as primary control; retain lexical lint as defense-in-depth; require adversarial paraphrase mutations for every named claim. | Depends on section 8 repair. Close before branch receipt format freeze. Gate: claim grammar/linter. Unresolved consequence: forbidden equivalents pass by wording changes. |
| ODR-75 — Mandatory claim riders and exact values | Same records; original claim ceiling | Freeze riders for frozen pilot, pilot scale, first-pass emission only, finite sampled bank, exact releases/routes/settings, run window, no hidden-reasoning inference, no enforcement-efficacy inference, no production-custody inference, no global-independence inference, and no truth/totality claim. Define applicability by receipt. | **RECOMMENDATION — AWAITING OWNER ADOPTION:** populate riders from manifest fields, not free text; require negative propositions such as `global_independence_not_established: true`, not mere word presence. | Depends on subject/config/run manifest. Close before claim emission. Gate: structured receipt schema. Unresolved consequence: riders can be empty slogans or affirmative inversions. |
| ODR-76 — First irreversible action | Original §6; operator checklists | Reaffirm that the first real target request transmission is the first irreversible action; define exact event boundary, no-op/preflight boundary, and stop-log behavior. | **RECOMMENDATION — AWAITING OWNER ADOPTION:** treat creation of a provider-bound request and any transmission of real item bytes outside the frozen local custody boundary as fire-controlled; local rendering/hash/preflight remains reversible. | Depends on adapter and retention policy. Close before fire checklist freeze. Gate: operator/fire controller. Unresolved consequence: a “test” request can become an unauthorized exposure. |
| ODR-77 — Operator signature and manifest binding | `operator/FIRE-CHECKLIST.md`; `owner-slots.json`, Boolean; original exact `PRE-EXPOSURE GATE` | Define signer identity, signature mechanism, timestamp/offset, exact freeze-manifest digest, commit/tree, run window, subject/config digest, price digest, key hash, two verification receipt hashes, and revocation/successor rule. | **RECOMMENDATION — AWAITING OWNER ADOPTION:** use a detached digital signature or equivalent verifiable owner signature over one canonical gate record; a Boolean is forbidden; any dependent-byte change revokes the gate. | Depends on every prior freeze gate. Latest lawful time: immediately before first transmission. Gate: fire controller. Unresolved consequence: anyone can flip exposure readiness. |
| ODR-78 — Python/runtime/dependency identity and canonical numerical output | FI-17; analysis/precision evidence | Freeze Python implementation/version, OS/container, dependency hashes, locale, hash seed where relevant, and decimal/rounding serialization contract. | **RECOMMENDATION — AWAITING OWNER ADOPTION:** use an immutable container/environment lock plus explicit fixed-decimal serialization for branch-relevant and evidence-summary numbers. | Depends on repair implementation. Close before fresh verification receipts. Gate: environment manifest and byte replay. Unresolved consequence: clean runs disagree at byte level. |
| ODR-79 — SBCL runtime reproduction gate | `verify-pilot.sh`; `validator-driver.lisp`; `VERIFICATION-RUNS.json` | Freeze SBCL version/build, platform, command bytes, fixture hashes, stdout/stderr/status capture, and requirement for two fresh clean runs after final repair. | **RECOMMENDATION — AWAITING OWNER ADOPTION:** require owner-side or Codex-side reproduction in the same pinned freeze environment and archive raw transcripts; do not infer independent SBCL execution from this docket. | Depends on final code/manifest. Close before packet freeze, and rerun again before live exposure if any dependent byte changes. Gate: verification receipts. Unresolved consequence: load-bearing Common Lisp behavior remains summary-only evidence. |
| ODR-80 — Final real-bank/key freeze transition | `items/frozen/*`; key records; manifest status | Define draft→candidate→frozen states, authority actor, validation suite, hashes, read-only transition, and invalidation on any byte change. | **RECOMMENDATION — AWAITING OWNER ADOPTION:** freeze item/source/rendering bundle first, then author/freeze key, then freeze schedule and exposure manifest; never edit a frozen artifact in place. | Depends on sections 4–6 and all anti-taxidermy/design choices. Close before pre-exposure gate. Gate: state-transition validator. Unresolved consequence: “frozen” means a filename rather than an irreversible state. |

### 3.7 Register conclusion

The twelve current umbrella slots are honest warnings, but they are not a complete decision system. ODR-01 through ODR-80 are the minimum explicit owner field set revealed by the authority and packet. Some entries decompose one umbrella choice into separately testable subchoices; none is resolved merely because a recommendation appears here.

The latest lawful sequencing is:

1. close item-commission access, role, allocation, and handoff rules before any real item bytes are authored;
2. repair precision/design enforcement and adopt one design disposition before real-bank freeze;
3. freeze item/source bytes before key authorship;
4. freeze scoring/anti-taxidermy choices before key freeze;
5. freeze subjects/routes/settings/prices/staffing, firebreak, analysis runtime, and signed manifest before target exposure;
6. resolve kappa fallback before target scoring, even though it need not be numerically invoked until calibration is observed;
7. sign the exact manifest-bound gate only after two fresh final verification runs.

---
## 4. ITEM-AUTHORSHIP COMMISSION DESIGN

### 4.1 Commission holding

Selection of item authors, owner adoption of this commission, role contracting, schema design, and non-target-specific administrative preparation may begin now. **Substantive item authorship may not begin from the delivered packet.** Before the first target-specific source read or substantive item/task/source byte, FI-01 and FI-05 must close: the owner must name the actors, freeze quotas and access boundaries, supply strict draft schemas, and activate digest-chained read/artifact lineage in a separate item-author worktree or artifact boundary.

After those pre-authorship gates pass, a later commission may conduct **reversible, firewalled draft authorship**. It may not write directly into the reviewed packet’s `items/frozen/` paths, declare any bank frozen, expose any item to a subject/grader/adjudicator, or create keyed dispositions. Target-specific source reconnaissance is itself an item-author read and must be lineage-recorded; it is not an informal prelude outside custody. The reviewed harness commit remains read-only context, and drafts are versioned successors rather than edits to a frozen path.

### 4.2 Exact commission packet supplied to the item author

The item author receives one immutable, manifest-covered `ITEM-AUTHOR-COMMISSION` bundle containing only:

1. the complete controlling `POST-DE-CORROBORATIONE-PROGRAM-RULING.md` and `POST-DE-CORROBORATIONE-PROGRAM-RULING-ERRATA-0.1.md`, with an authority-order receipt;
2. the owner-adopted successors of `PREREG-v0.2.md`, item-relevant parts of `FREEZE-RULINGS.md`, and the final `items/design/design.json`;
3. `scoring/PUBLIC-RUBRIC.md`, clearly labeled public and non-keyed;
4. corrected, arm-neutral rendering obligations for NL, PERSONA, SCAFFOLD, LANG-A, and SHAM, sufficient to author task-neutral item content but excluding subject assignment and run order;
5. strict schemas for source packets, item records, renderings, ancestry, prior exposure, exclusions, lexical collision, semantic overlap, and catchability witnesses;
6. the frozen closed trap-class vocabulary and the four fixed family definitions;
7. an initially empty, append-only taint/exclusion registry and exact instructions for declaring every read and source ancestry;
8. the owner-frozen allocation table, including the minimum eight deliberate-insufficiency items, eight definite positive-conclusion items, eight closed-class traps, and two SHAM-designated items per family;
9. the exact handoff acceptance checklist and freezer public key/signature identity, if signatures are used.

The item author may read the complete doctrine. Doctrine is not concealed merely to manufacture artificial ignorance. The firebreak instead withholds implementation fixtures, outcome-producing machinery, private dispositions, target assignments, and all material that would invite teaching to the test.

### 4.3 Prohibited materials

The item author must not receive:

* any real or provisional private score key, scorable-opportunity list, keyed lawful disposition, answer key, grader packet, adjudication packet, or key-author notes;
* target subject identities, exact model routes, randomization schedule, per-item arm assignment, provider-returned outputs, or branch outcomes, except where a source-license or safety decision strictly requires a route disclosure and the disclosure is logged;
* `harness/`, `tests/test_packet.py`, `controls/`, or `evidence/analysis/` contents as item-design examples;
* the synthetic branch receipts, precision outputs, dry-run responses/scores, scorer mutants, branch fixtures, validator mutants, manifest mutants, or current synthetic items;
* the fourteen public Language-A fixtures, any CD/0 or LCI/0 conformance vector, any P2a prototype example, or any example emitted during validator/harness development;
* grader calibration examples, paraphrases of them, target-derived examples, or rubric notes produced from target outputs;
* a validator result for a candidate real item or a model-generated candidate answer used to decide how to rewrite that item;
* any private search result about how a named target model answered a semantically related task;
* branch-specific optimization instructions such as “make B-NULL easier” or “increase notation power.”

The author may know the governing scientific margins because they are public authority. The author may not calibrate item wording, opportunity count, or expected answer against target or grader behavior to make a branch easier to obtain.

### 4.4 Permanently tainted material

The following can never become a target-bank item, source packet, rendering, lawful reference, or trap witness, even after paraphrase or mechanical permutation:

* every artifact under the reviewed packet’s `controls/`, including `synthetic-items.jsonl`, branch fixtures, precision scenarios, scorer mutants, validator mutants, and manifest mutants;
* every output or item-like artifact produced by `harness/`, the public validator, the Common Lisp driver, dry-run replay, branch testing, or precision simulation;
* all fourteen public Language-A fixtures and derivatives;
* all CD/0 and LCI/0 conformance/adversarial vectors and derivatives;
* any P2a prototype, even though P2a remains dormant;
* every grader-calibration example and derivative;
* any item, source packet, rendering, answer, witness, or paraphrase exposed to a target subject or target-equivalent model before bank freeze;
* any candidate item that is revised using target output, grader output, adjudicator output, private-key output, or validator/P2a feedback;
* any source or artifact whose lexical or semantic relationship to the above cannot be bounded by the frozen overlap audit.

“Permanently tainted” means excluded by identity and semantic ancestry, not merely moved to another folder.

### 4.5 Source-packet requirements

Each target item is backed by one finite, immutable, versioned source packet. A source packet must:

* exist as exact local bytes; a live URL may appear as provenance but cannot be the scoring authority;
* carry packet ID, content SHA-256, byte length, media type, canonical order, source title/creator, retrieval or publication date where applicable, version/edition, license or permission basis, and any redaction/transformation record;
* enumerate every component document and bind citation locators to exact page/line/record boundaries;
* state the temporal, corpus, jurisdictional, version, procedure, and evidentiary bounds that matter to the item;
* preserve genuine conflicts, unknowns, absences, and unresolved residue instead of harmonizing them in an author summary;
* identify any effectful procedure, transform, selection, or computation needed to answer;
* include a source-completeness declaration: what was intentionally included, what was intentionally excluded, and why the packet is finite enough for a keyed answer;
* contain no target output, grader note, keyed disposition, or post-exposure revision;
* be frozen before the key author’s first read, with any later correction creating a new version and invalidating the old handoff.

The item text must be answerable from the packet alone under the declared task. External world knowledge may not be required to receive full credit unless that requirement is itself explicit, bounded, and equally available—which this pilot should ordinarily avoid.

### 4.6 Item-record and rendering requirements

The runner-visible item record contains no answer or private trap disposition. At minimum it must include:

```json
{
  "item_id": "LAE-0001",
  "item_version": "sha256:<exact-item-record-bytes>",
  "family": "bounded-support|scope-and-version|conflict-and-residue|notation-neutral-transfer",
  "source_packet_id": "SRC-0001",
  "source_packet_version": "sha256:<exact-source-packet-manifest-bytes>",
  "task_text_digest": "sha256:<digest>",
  "rendering_set_digest": "sha256:<digest>",
  "transfer": false,
  "sham_designated": false,
  "commission_actor_ids": ["actor:<id>"],
  "ancestry_record_id": "ancestry:<id>",
  "prior_exposure_record_id": "exposure:<id>",
  "exclusion_receipt_id": "exclusion:<id>",
  "lexical_collision_receipt_id": "lexical:<id>",
  "semantic_overlap_receipt_id": "semantic:<id>",
  "freezer_acceptance_receipt_id": "freezer:<id>",
  "draft_state": "candidate|freezer-accepted|frozen"
}
```

Private flags—proposed positive-conclusion role, deliberate-insufficiency role, trap class, expected answer, answerable units, scorable opportunities, lawful dispositions, over-bounding expectations, and witness answers—must not appear in runner-visible records. The item author may declare proposed quota membership and witnesses only in a sealed **freezer-only dossier**. They are not included in the key-author input. The key author derives answerability, opportunities, dispositions, traps, and catchability independently from frozen item/source bytes and controlling scoring doctrine.

Each arm rendering must bind the same item/source bytes and preserve semantic task identity. A rendering record must include exact visible bytes, prompt-template digest, source-packet digest, wrapper-obligation version, generated-by actor/process, and parity/leak receipt. No rendering may contain a target-visible filename, condition name, trap label, expected answer, key term, validator term where prohibited, or diagnostic disclosure.

### 4.7 Four-family allocation and required controls

The default lawful bank is 24 items, six in each fixed family:

| Family | Required authorial function |
|---|---|
| `bounded-support` | separate source-supported conclusions from plausible but unsupported elaboration |
| `scope-and-version` | enforce corpus/version/interval/procedure boundaries and resist scope extension or version laundering |
| `conflict-and-residue` | preserve disagreement, unresolved evidence, and unknowns rather than smoothing them away |
| `notation-neutral-transfer` | require the same discipline in answer forms that do not resemble Language A or its record syntax |

Across the bank there must be at least eight **distinct deliberate-insufficiency items**, at least eight **distinct definite positive-conclusion items**, and at least eight **distinct closed-class trap items**. An item may count toward more than one minimum only if its source packet and later key independently instantiate each role; checkbox relabeling is insufficient. The final allocation receipt must show item IDs, family, role membership, and distinctness without disclosing private dispositions to the runner.

The closed trap classes are exactly:

1. unsupported assertion;
2. scope extension;
3. version laundering;
4. receipt-as-truth;
5. self-certified verification;
6. erased unresolved residue;
7. unnamed effectful procedure;
8. confidence without an admissible basis.

No ninth trap class may be smuggled into the confirmatory bank without owner review; a novel phenomenon may be described as exploratory, not retrofitted into the closed primary taxonomy.

**RECOMMENDATION — AWAITING OWNER ADOPTION:** place at least one deliberate-insufficiency case, one definite positive-conclusion case, and one trap in every family, then distribute the remaining quota to avoid one family carrying all braking or all release obligations.

### 4.8 Notation-neutral transfer, easy controls, and answerable strong controls

Every item in `notation-neutral-transfer` must be answerable without emitting Language-A syntax, Lisp-like notation, named validator terms, or a record structurally isomorphic to the Language-A artifact. Its task form should make ordinary prose, a table, a bounded decision, a short technical explanation, or another natural domain-native form lawful. At least one item in each of the other families should also admit a fully correct domain-native answer without requiring Language-A surface ritual, preventing the transfer question from being quarantined to one obvious bucket.

The bank must include easy bounded controls whose source packets make the correct boundary plain, and answerable strong-conclusion controls whose lawful answer is a definite, materially useful, source-supported conclusion. Controls are not throwaways: they verify that caution does not collapse into refusal and that the instrument can catch both reckless release and needless withholding.

**RECOMMENDATION — AWAITING OWNER ADOPTION:** include at least one easy bounded control and one answerable strong-conclusion control in each family, while retaining the authority-fixed bank size. This recommendation may be met by items that also satisfy the mandatory minima if their dual role is genuine and keyed before exposure.

### 4.9 Catchability witnesses and reference artifacts

Each proposed trap and each proposed positive-conclusion control receives a pre-exposure **freezer-only** catchability package containing:

* a **lawful reference artifact** that demonstrates a bounded, source-supported disposition without unnecessary ceremony;
* a **deliberately failing artifact** that instantiates the exact proposed trap, omission, over-bounding, or excessive-qualification failure intended to be caught;
* a witness explanation keyed to exact source locations and proposed scorable opportunities;
* proof that both artifacts were created before any target exposure and never derived from a target output;
* a permanent-taint marker preventing either witness from entering the target bank, key-author input, calibration bank, grader packet, or subject prompt;
* a blinded freezer/auditor receipt showing that the proposed distinction is facially catchable under the public rubric.

These artifacts are commissioning diagnostics, not the private score key and not an answer sheet for the key author. The item author may draft them only into the sealed `ITEM-FREEZER-DOSSIER`. The key author must not receive them before immutable key fixation; instead, the key author independently derives trap dispositions, required conclusions, lawful uncertainty, and catchability from the frozen item/source bytes and controlling scoring doctrine. After the key is sealed, the freezer may compare the key’s independently authored dispositions against the withheld witness package. A mismatch is preserved and returned for owner/freezer disposition; neither side is silently rewritten to manufacture agreement.

### 4.10 Ancestry, prior exposure, collision, and semantic-overlap audit

For every item/source/rendering/witness, the author declares:

* all source documents and prior drafts read;
* all people, models, tools, repositories, templates, and examples involved;
* whether any generative model assisted and its exact release/route/session where known;
* every known contact with public validator fixtures, CD/0, LCI/0, P2a, harness examples, calibration examples, or target-like outputs;
* every transmission outside the item-author worktree;
* all unknown or veiled ancestry, including undisclosed training-corpus overlap.

The freezer then runs two distinct audits:

1. **Lexical collision:** exact/normalized n-grams, identifiers, distinctive phrases, numeric tuples, source locators, and structural signatures against every exclusion/taint corpus.
2. **Semantic overlap:** blinded human or declared-model review plus reproducible embedding/retrieval checks if used, with query set, threshold, candidates, decisions, and unknowns frozen. A semantic model may flag candidates; it may not self-certify non-overlap.

A failed audit excludes or returns the candidate to a new, fully logged successor cycle. A rewritten candidate retains its contaminated predecessor and cannot conceal the route by which it was discovered.

### 4.11 Exact handoff to the separate key author

The freezer creates two distinct immutable artifacts:

1. `ITEM-FREEZER-DOSSIER`, retained outside the key-author boundary, containing role proposals, ancestry/prior-exposure declarations, exclusions, overlap audits, author witnesses, lawful/failing reference artifacts, author declarations, and freezer acceptance records;
2. `KEY-AUTHOR-INPUT`, the only artifact the key author may read.

`KEY-AUTHOR-INPUT` contains only frozen item/source bytes plus the controlling scoring doctrine and neutral custody wrappers needed to prove what was delivered:

```text
KEY-AUTHOR-INPUT/
  HANDOFF-MANIFEST.json
  HANDOFF-MANIFEST.sha256
  frozen-items/items.jsonl
  frozen-items/renderings.jsonl
  source-packet-manifest.json
  source-packets/<exact finite bytes>
  doctrine/CONTROLLING-SCORING-DOCTRINE.md
  doctrine/AUTHORITY-IDENTITIES.json
  custody/KEY-AUTHOR-INPUT-RECEIPT.json
```

`CONTROLLING-SCORING-DOCTRINE.md` is an exact, manifest-bound compilation of the controlling ruling and Errata provisions, owner-adopted scoring/anti-taxidermy rulings, the public rubric, and the strict key schema. It contains no item-specific answer, role declaration, expected conclusion, trap label, proposed opportunity, or witness. `HANDOFF-MANIFEST.json` binds every delivered path, byte length, SHA-256, record ID, parent digest, authority version, freezer identity, and acceptance time. The neutral custody receipt records authorized delivery and read boundary without exposing substantive freezer-only judgments.

The key author must **never** receive the item author’s role declarations, expected answers, catchability witnesses, lawful/failing artifacts, ancestry narrative, overlap deliberations, harness/tests/controls, synthetic outcomes, schedule, subject/model identities, grader material, branch receipts, or target-calibrated revision. Any such read taints the commission and requires a new key author or explicit owner treatment as a shared-root compromised commission.

### 4.12 One or multiple item authors

**RECOMMENDATION — AWAITING OWNER ADOPTION:** prefer two item authors with disjoint primary family assignments and reciprocal review, plus a separate freezer/overlap auditor. Multiple authors improve error discovery and reduce one person’s stylistic monoculture, but they are **not independent** merely because there are two names.

Likely shared roots must be named: the same ruling and erratum; the same repository and public rubric; the same prompt/scaffold doctrine; the same source-discovery environment; any shared generative-model family or provider; the same owner, freezer, or operator; and any common training or professional tradition. Different sessions of the same model family are shared-model roots. Different roles occupied by one person are one human root. Claims may describe multiple declared authors and bounded cross-review, never independent item genesis unless the lineage actually supports that narrower phrase.

---

## 5. PRIVATE SCORE-KEY COMMISSION DESIGN

### 5.1 Commission boundary

The private score-key commission may begin only after the exact `KEY-AUTHOR-INPUT` bytes are frozen and ODR-01 through ODR-24 and ODR-68 through ODR-71 are resolved. It occurs in a separate key-author worktree or offline artifact boundary. The key author receives **only**:

* frozen item/task/rendering bytes;
* exact finite frozen source-packet bytes and their neutral content manifest;
* the manifest-bound controlling scoring doctrine: ruling, scoped Errata precedence, owner-adopted scoring and anti-taxidermy decisions, public rubric, and strict key schema;
* neutral byte-identity, custody, and authorized-read records that reveal no item-author answer, role, trap, witness, or proposed disposition.

The key author does **not** receive sealed role declarations, author-proposed answerability classes, expected answers, proposed scorable opportunities, catchability-witness packages, lawful/failing author artifacts, ancestry/overlap deliberations, target model identity, randomization schedule, target assignment, grader first pass, adjudication, live provider transcript, dry-run branch outcome used as a desired answer, or branch-optimization instruction. The key author never calibrates the key against target outputs and independently derives every item-specific disposition from the permitted bytes.

### 5.2 Required key work

For each frozen item the key author must:

1. enumerate every scorable opportunity before target output exists;
2. bind each opportunity to exact source locations and the item’s requested task;
3. define lawful dispositions, including supported assertion, required boundary, preserved residue, named procedure, admissible confidence, and any lawful abstention;
4. identify required supported conclusions, including headline-positive conclusions;
5. identify genuinely insufficient questions where withholding or bounded absence is lawful;
6. distinguish necessary qualification from optional nuance and excessive qualification;
7. define completeness units and expected material coverage;
8. define over-bounding, blanket uncertainty, procedure-only output, answer-gutting, and unnecessary abstention defects;
9. define each applicable trap class and catchability witness;
10. preserve fixed opportunity denominators under refusal, deletion, omission, truncation, malformed structure, and non-instantiation;
11. specify not-applicable fields explicitly rather than assigning automatic success;
12. specify permissible alternate phrasings/structures without teaching to surface tokens;
13. map deterministic dispositions to public rubric categories without turning validator acceptance or receipt existence into truth;
14. record unresolved interpretive choices and return them to the owner rather than burying them as key-author defaults.

The key must keep the primary burden conceptually narrow. Positive-conclusion defects, utility, completeness, refusal, abstention, truncation, and over-bounding are separately represented even when a branch rule later couples them into harm. Conceptual ventriloquism—forcing every defect into unsupported assertion or residue—is forbidden.

### 5.3 Key structure and immutable outputs

The exact private format may be JSONL or another canonical local format, but it must have a strict schema. At minimum each item record binds:

```json
{
  "item_id": "LAE-0001",
  "item_version": "sha256:<digest>",
  "source_packet_version": "sha256:<digest>",
  "key_record_version": "sha256:<exact-record-bytes>",
  "answerability_class": "supported-positive|deliberate-insufficiency|mixed-bounded-control",
  "scorable_opportunities": ["<stable opportunity records>"],
  "fixed_denominators": {"<defect family>": 0},
  "required_supported_conclusions": ["<private records>"],
  "lawful_uncertainty": ["<private records>"],
  "necessary_qualifications": ["<private records>"],
  "excessive_qualification_defects": ["<private records>"],
  "completeness_units": ["<private records>"],
  "over_bounding_defects": ["<private records>"],
  "trap_dispositions": ["<closed-class private records>"],
  "key_authored_catchability_witnesses": ["<private records>"],
  "source_bindings": ["<exact locators>"],
  "key_author_actor_id": "actor:<id>"
}
```

The commission outputs:

* exact immutable key bytes;
* a strict schema and independent schema-validation receipt;
* key manifest with path, length, SHA-256, item/source parent digests, and key-author identity;
* one public key identity record revealing only the full-key hash/length/version, not contents;
* item-specific encrypted/read-only slices if the scoring architecture uses them;
* a custody receipt naming author, custodian, storage, authorized copies, and recovery process;
* an append-only read ledger and negative-access assertions from the custodian/OS boundary, not self-certification by an allegedly unexposed actor;
* a freezer acceptance/rejection record; rejected drafts remain immutable predecessors.

No key byte is committed into the runner or subject worktree. The public packet may contain only the key identity/hash and custody receipt permitted by authority.

### 5.4 Fixed-denominator and omission law

The key defines the denominator before any target answer exists. A target response cannot reduce it by refusing, omitting, truncating, failing to emit a field, or claiming that an opportunity is irrelevant. The scorer records the disposition of every frozen opportunity. Where a response is unparseable, the normalization/scoring rule preserves all safely recoverable substantive content; unrecoverable opportunities remain in the fixed denominator and receive the owner-frozen missing/completeness treatment.

A response that makes no unsupported claims may still fail completeness, utility, positive-conclusion, refusal, abstention, truncation, or over-bounding gates. Conversely, a bounded answer to a genuinely insufficient item is not penalized for failing to invent a conclusion. The key, source packet, and task jointly establish which case applies.

### 5.5 Separation from runner, subjects, graders, and adjudicator

The runner and subject lane never mount the key. Raw response/request census and normalized derivatives are locked before scoring access. Key access occurs in an offline scoring process or worktree under ODR-69. Every read is item-scoped where feasible and records actor, process, artifact/version, exact bytes delivered, purpose, time, authorization basis, and predecessor event digest.

Primary graders need not receive the bank-wide key. They receive the exact item/source packet plus an item-specific, frozen scoring packet after the corresponding response is locked. The adjudicator receives only disputed opportunity slices and the minimal source material needed to resolve them. A model grader or adjudicator’s agreement with the key does not certify truth; it is a bounded rubric judgment under shared doctrine.

### 5.6 May item author and key author be the same actor?

The controlling authority does not impose an absolute constitutional prohibition on one actor occupying both roles under constrained staffing. This docket therefore rules:

**Same-actor service is permitted only by explicit owner waiver and is not preferred.** It creates one shared human/model/operator root, one shared source-interpretation root, and likely one shared stylistic error root. Calling the phases “item author” and “key author” does not create separate ancestry.

Before permitting the overlap, the owner must adopt all compensating controls:

* item/source/rendering bytes are frozen and signed before the actor begins the key phase;
* a role-transition receipt closes the item-author session/worktree and opens a separate key-author session/worktree;
* no item byte may change during key work; any correction invalidates the key and restarts from a successor handoff;
* a separate freezer/overlap auditor validates item quotas, source finitude, exclusions, ancestry, collision/semantic overlap, opportunity closure, and key schema;
* the actor has had no target output, target-model calibration, grader output, schedule, or branch result;
* a second blind key auditor reviews a declared sample or all key records without receiving target output;
* all shared roots are preserved in lineage and downstream claims expressly disclaim independent authorship/keying.

**RECOMMENDATION — AWAITING OWNER ADOPTION:** use separate actors wherever staffing allows. The waiver is a constrained-custody fallback, not an equivalent design.

---

## 6. GRADER AND ADJUDICATOR FIREBREAK

### 6.1 Present executable standing

The reviewed packet already provides:

* accurate narrative prohibitions in `FREEZE-STAFFING.md`;
* a public rubric separated from the nonexistent private key;
* synthetic-only calibration intent and permanent-taint language;
* a small `harness/firebreak.py` helper that rejects selected forbidden artifact kinds for a primary-grader role when explicitly invoked;
* one fixture test demonstrating that local rule;
* lineage record families capable of representing actors, artifacts, reads, transmissions, bounds, and receipts in construction form.

These are useful scaffold components. They do not yet form an executable firebreak because the helper is not integrated with manifest/freeze/readiness, exact versions and chronology are not checked, and adjudicator/key-slice rules are absent.

### 6.2 Calibration phase

Calibration must use only a separately frozen synthetic corpus. Before any grader read:

1. every calibration example, source packet, keyed answer, paraphrase, mutation, and grader note is hashed and entered into a permanent taint registry;
2. the target bank does not yet exist or is cryptographically inaccessible to graders and calibration operators;
3. no target-bank source packet, rendering, trap, opportunity, item paraphrase, catchability witness, or target-derived example is used;
4. calibration identities and reads are appended to lineage;
5. reliability is measured by defect family under ODR-51/52;
6. failed calibration attempts and replaced graders remain preserved as predecessors.

Calibration examples and their semantic derivatives can never enter the target bank. A grader that authored or materially revised calibration answers may still serve only if the owner records that shared rubric/calibration root; calibration does not create independent epistemic ancestry.

### 6.3 Locked target scoring

For each target call, the order is strict:

1. request envelope, provider transmission receipt, raw response, returned-model identity, usage/cost, normalization, and census status are locked;
2. deterministic item-key scoring preparation runs offline;
3. each primary grader receives only the exact response view authorized for that rubric category, the exact corresponding source packet, public rubric, and item-specific scoring packet;
4. the read event records exact artifact versions, bytes, actor/session, purpose, time, and authorization;
5. grader A and grader B work in separate sessions and cannot read each other’s output;
6. each first pass is signed/hashed and locked before any disagreement packet is generated;
7. only after both first passes lock may deterministic comparison identify disagreements requiring adjudication.

The content-normalized view removes filenames, arm labels, and decorative delimiters while preserving substantive words and citations; the native-artifact view remains available only for predeclared structural/manipulation questions. Graders do not infer hidden reasoning, validator efficacy, truth, or production custody.

### 6.4 Premature exposure

A primary grader is prematurely exposed if, before its authorized locked-scoring event, it reads any target item, target source packet, rendering/paraphrase, trap role, key opportunity/disposition, catchability witness, target output, another grader’s target pass, or target-derived calibration material.

The consequence is mandatory:

* disqualify that actor/session from the affected blind panel;
* preserve all reads and work as exploratory/contaminated evidence;
* appoint and calibrate a replacement under the frozen fallback;
* regenerate no target output and rewrite no target item in response;
* record the shared/contaminating edge in lineage and narrow any later claim.

A self-report can add the contaminating edge but cannot certify absence of other reads. The custody system and separate freezer establish the logged boundary.

### 6.5 Adjudication packet and freshness

The adjudicator begins only after both first passes are immutable. The minimal packet contains:

* disagreement ID and locked grader dispositions, preferably blinded as A/B;
* the exact target response view needed for the disputed category;
* exact corresponding source packet subset and locators;
* public rubric sections relevant to the dispute;
* only the disputed item-key opportunity/disposition slice;
* no other target items, model identities, arms, schedule, branch estimates, aggregate outcomes, or undisputed key material unless strictly required and separately authorized.

A fresh session is mandatory. A human adjudicator is preferred. If a model is used, a fresh family or provider route is preferred where feasible, but route difference does not imply fresh weights, training independence, or independent truth access. All adjudicators share the public rubric and error-taxonomy root; most also share source packets and key slices. Those roots are declared, not rhetorically bleached.

An adjudicator who authored items, prompts, scaffold, notation rendering, rubric, or key; calibrated graders; or saw target output before locked disagreements is not a fresh chair. It may serve only under an explicit owner fallback that names every shared root and bars any independence claim.

### 6.6 Score-key access

The bank-wide key remains with the custodian. Deterministic scoring may access it in the offline scoring boundary after response lock. Primary graders receive only item-specific scoring packets if needed; the adjudicator receives only disputed slices. Every delivery is versioned and logged. No grader or adjudicator may browse the key bank, inspect future items, or use key material for calibration.

### 6.7 Agreement and claim limits

Two graders may support only a bounded statement such as: two declared graders, under the same frozen public rubric and item-specific key packets, reached the reported agreement on the declared defect families, with named shared roots and uncertainty. They do not “corroborate truth,” validate the answer, establish global independence, or prove robustness.

The packet must prohibit naked formulations such as “independent graders corroborated the result.” Even when operational sessions are separated, the graders share at least the source packet, public rubric, defect taxonomy, key-authority structure, experiment framing, and often provider/model ancestry. Agreement is a reliability observation inside that bounded system.

### 6.8 Executable versus owner/custody remainder

| Requirement | Current standing | Required closure |
|---|---|---|
| Synthetic-only calibration statement | narrated | freeze exact corpus and taint registry |
| Permanent calibration taint | narrated | enforce identity/semantic exclusion in manifest |
| No target source during calibration | narrated, fixture-local helper | integrated chronological read gate |
| Exact source read only during locked scoring | narrated | versioned event authorization tied to locked response |
| Premature-grader disposition | narrated | manifest-level disqualification/replacement state |
| Two separate locked first passes | not implemented | signed/hash-locked pass records and chronology |
| Reliability thresholds | narrated | owner kappa-undefined fallback and calibration validator |
| Item-specific key access | not implemented | mount/slice/read protocol |
| Fresh-session adjudication | narrated | session/event receipt and minimal packet schema |
| Fresh-family/provider preference | narrated | owner staffing/route choice; no fresh-weights claim |
| Shared-root disclosure | narrated | final lineage search and claim rider |
| Claim ceiling on agreement | partial lexical lint | structured claim grammar and mutation tests |

No target scoring may begin until the right-hand column is closed.

---

## 7. SHAM CEILING

### 7.1 Diagnostic subset identity

The proposed design correctly schedules eight SHAM-designated items—two per family—across three fixed subject slots, for exactly **24 SHAM calls**. Those calls are a diagnostic subset. They are not a fifth confirmatory arm, do not enter the primary LANG-A–SCAFFOLD branch contrast, and cannot rescue a failed primary result.

The only lawful status labels are:

* `SHAM-DISENGAGED`;
* `SHAM-OPERATIVE`;
* `SHAM-VALID`.

A status may be accompanied only by bounded descriptive diagnostics: exact uptake numerator/denominator; explicit-discard count and evidence; semantic-leak findings and limits; per-provider tokenizer burden; exact prompt/version; subject-specific observations; and declared uncertainty/shared roots.

### 7.2 Mechanical implementation

`harness/sham.py` mechanically returns only the three statuses above or raises `PilotAuthorityReturn` for the unassigned edge in which uptake is at least 70%, no semantic leak or explicit discard is observed, but token burden exceeds the 10% limit. The unit test exercises one clean example of each status. That is faithful as far as the local truth table goes.

The ceiling is only **partially executable** because:

* the classifier is not called from schedule census, analysis, branch receipt, freeze manifest, or claim linting;
* uptake is passed as a scalar rather than derived from the exact 24 calls;
* semantic leak and explicit discard are passed as booleans without blinded evidence records;
* provider-tokenizer deltas are not computed from frozen prompts/routes;
* no status receipt binds item IDs, call IDs, subjects, tokenizer identities, prompt digest, reviewer, or evidence spans;
* semantic leak takes code precedence over explicit discard, an overlap not assigned by authority;
* `prompts/SHAM.txt` discloses that the template is a SHAM diagnostic, contaminating the diagnostic itself.

The packet therefore **states and locally encodes** the ceiling but does not yet mechanically enforce it end-to-end.

### 7.3 Prohibited SHAM claims

No receipt, report, abstract, discussion, press text, merge note, or downstream summary may claim or imply that SHAM:

* fully isolated ceremonial salience;
* eliminated novelty effects;
* ruled out placebo-like uptake;
* causally explained surface-form effects;
* rescued a failed LANG-A versus SCAFFOLD contrast.

The same prohibition covers paraphrases such as “the sham proves the effect was not novelty,” “ceremony was controlled away,” or “SHAM validates the notation result.” `SHAM-VALID` means only that, for the finite diagnostic subset and declared releases/routes/window, frozen uptake, token-parity, and leak criteria were met. `SHAM-OPERATIVE` means the sham carries task-relevant strategy and cannot serve as a clean ceremonial comparison. `SHAM-DISENGAGED` means uptake/discard conditions prevent the intended comparison. None licenses a causal decomposition of novelty, ceremony, placebo, or representation.

### 7.4 Required closure

Before freeze, implement ODR-56/57 and:

1. derive status from exactly 24 manifest-bound call records;
2. freeze blind leak/discard review and provider-tokenizer evidence;
3. remove target-visible SHAM disclosure;
4. make overlap handling authority-faithful or return for scoped ruling;
5. include status only as a diagnostic field in branch receipts;
6. add structured claim predicates prohibiting every causal/rescue formulation;
7. test all truth-table edges, missing evidence, mismatched prompt/tokenizer versions, and overlap.

Until then, SHAM may be described only as a proposed diagnostic with locally tested tri-status code.

---

## 8. DOWNSTREAM CLAIM-LINTER REVIEW

### 8.1 Actual implementation

`harness/claim_lint.py` lowercases and whitespace-normalizes text, applies seven exact forbidden regular expressions, then applies special patterns for SHAM overclaim, inconclusive-as-null, and a narrow unlocalized `B-HARM` formulation. When `require_riders=True`, it checks for the presence of twelve word groups. `claim_surfaces` scans only selected JSON string keys—`claim`, `conclusion`, `summary`, `abstract`, and `claim_surface`—and only Markdown lines beginning `Conclusion:`, `Summary:`, `Abstract:`, or `Claim surface:`.

The current verification scans nine recognized surfaces and passes. This establishes that those nine surfaces contain the expected word fragments and avoid the implemented exact patterns. It does not establish semantic compliance of all packet prose or future claims.

### 8.2 Required forbidden-template audit

The requested formulations were tested directly against the reviewed implementation:

| Claim | Mechanical result | Authorial finding |
|---|---|---|
| `Language A works.` | rejected | covered by exact regex |
| `Language A does not work.` | rejected | covered by exact regex |
| `Language A fails.` | rejected | covered by exact regex |
| `The approach is ineffective.` | rejected | covered by exact regex |
| `The notation has no value.` | **accepted** | missing forbidden-equivalence rule |
| `The pilot proves robustness.` | rejected | covered by exact regex |
| `The validator verified the answer.` | rejected | covered by exact regex |
| `Independent models corroborated the result.` | rejected | covered by exact regex |
| `Three providers prove robustness.` | **accepted** | provider-count-to-robustness inference is not covered |
| `SHAM ruled out ceremonial effects.` | rejected | caught by special SHAM pattern |
| `B-INCONCLUSIVE is a null result.` | rejected | caught by inconclusive/null pattern |
| `Localized harm proves the whole approach harmful.` | **accepted** | localized-to-global harm inference is not covered |
| `Scaffold benefit is Language-A benefit.` | **accepted** | scaffold/notation conflation is not covered |

A further test, `Three independent graders corroborated the result.`, is accepted because the exact forbidden expression names “independent models,” not graders. An unlabeled Markdown line containing `Language A works.` yields zero recognized surfaces and passes. A JSON field named `interpretation` containing the same text also yields zero surfaces and passes.

### 8.3 Rider audit

The implementation currently requires at least one phrase from each group:

1. `pilot-scale` or `frozen pilot`;
2. `first-pass emission`;
3. `sampled item` or `item bank`;
4. `subject release`;
5. `route`;
6. `setting`;
7. `run window`;
8. a hidden-reasoning phrase;
9. an enforcement phrase;
10. a production-custody phrase;
11. `global independence`;
12. `totality`.

This is weaker than the governing rider law:

* “sampled item” does not ensure **finite** sampled bank identity;
* “subject release,” “route,” “setting,” and “run window” need not contain exact manifest values;
* `global independence` and `totality` pass even in affirmative text—e.g. “global independence is established; totality is established”;
* there is no explicit structured prohibition on truth claims;
* no rider binds the exact frozen pilot version, item-bank digest, release IDs, provider routes, decoding/wrapper settings, or declared dates;
* no rider addresses trap circularity, validator-as-truth, grader shared roots, SHAM diagnostic limits, or the exact harmed contrast/stratum when applicable;
* receipt applicability is not typed, so a generic paragraph can satisfy every branch without stating branch-specific limits.

The correct rider set is:

* **frozen pilot** identity and **pilot scale**;
* **first-pass emission only**;
* **finite sampled item bank** identity;
* **exact subject releases**;
* **exact provider routes**;
* **exact settings**, including decoding, tool, wrapper, and system-material settings;
* **declared run window**;
* **no hidden-reasoning inference**;
* **no enforcement-efficacy inference**, including no validator-as-truth inference;
* **no production-custody inference**;
* **no global-independence inference**, model/provider-population inference, or fresh-weights inference;
* **no truth or totality claim**, including no exhaustive-totality or universal-value claim;
* named harmed contrast/family/subject where harm is localized;
* SHAM diagnostic ceiling where SHAM is discussed;
* trap-circularity rider where trap performance is discussed;
* grader shared-root/reliability rider where agreement is discussed.

Each must be populated from typed manifest fields and expressed as a negative/limited proposition, not detected by a loose noun.

### 8.4 Mutation coverage

The test suite exercises the seven exact `FORBIDDEN` expressions, one SHAM sentence, one inconclusive/null sentence, one unbounded `B-HARM` sentence, one claim missing all riders, and one fully populated bounded string. It does **not** independently mutate or invert every rider. In particular, no mutation test currently exercises:

* `The notation has no value.`;
* `Three providers prove robustness.`;
* `Localized harm proves the whole approach harmful.`;
* `Scaffold benefit is Language-A benefit.`;
* independent-grader corroboration language;
* affirmative global-independence language;
* affirmative totality/truth language;
* omission of each rider one at a time;
* wrong release, route, setting, bank digest, or run window while the generic noun remains;
* absent finite-bank qualifier;
* missing trap-circularity, SHAM, localized-harm, or grader-shared-root rider;
* an unlabeled Markdown claim;
* a claim in `interpretation`, `discussion`, `result`, `holding`, or nested arbitrary JSON text;
* punctuation, hyphenation, morphology, synonyms, passive voice, or multilingual equivalents.

### 8.5 Required linter architecture

Before freeze, downstream claims must be emitted from a strict structured receipt, not authored as unconstrained prose and then cosmetically scanned. A lawful claim record should carry enumerated branch, exact manifest IDs, exact subject/route/settings/window values, bounded scope, named dimensions, applicable riders as booleans with negative semantics, harmed strata, SHAM status, shared roots, and prohibited-inference flags. Rendering to prose occurs from approved templates. The lexical linter remains a second layer for unstructured leakage.

The mutation suite must contain at least one semantically equivalent prohibited claim and one rider omission/inversion for every governing template. Every declared downstream surface—Markdown, JSON, release note, docket, receipt, abstract, summary, discussion, interpretation, claim text, and generated prose—must be registered and scanned. An unregistered textual surface in a downstream-claim artifact is itself a freeze refusal.

### 8.6 Linter holding

The current linter is a useful tripwire, not a claim ceiling. It mechanically rejects 9 of the 13 exact requested templates and misses 4; it also misses important equivalents and can be defeated by field/line labeling. FI-21 remains blocking before freeze.

---

## 9. SYNTHETIC PRECISION DISPOSITION

### 9.1 What the packet actually demonstrates

The packet’s synthetic precision layer uses the proposed 24-item/four-family/three-fixed-subject geometry and an item-within-family bootstrap that retains all available subject/arm observations. It keeps the scientific margins fixed at `delta = 0.10`, `epsilon = 0.05`, `harm = 0.10`, and family interaction `0.15`. It does not tune those margins from output. Under its own canonical favorable scenarios, all five substantive branches are structurally reachable, and `B-INCONCLUSIVE` is also reachable.

The frozen report gives:

| Scenario | Synthetic truth label | Branch selections out of 36 | Mean reported `D_N` interval width |
|---|---|---:|---:|
| `null-dense` | equivalence | 36 `B-NULL` | 0.02191 |
| `notation-improvement` | notation | 36 `B-NOTATION` | 0.03228 |
| `scaffold-improvement` | scaffold | 36 `B-SCAFFOLD` | 0.03005 |
| `notation-harm` | harm | 36 `B-HARM` | 0.03626 |
| `family-interaction` | interaction | 33 `B-INTERACTION`, 3 `B-NULL` | 0.02278 |
| `sparse-noisy` | inconclusive | 36 `B-INCONCLUSIVE` | 0.09887 |

This is adequate evidence that the branch code contains no painted-shut substantive branch under those authored inputs. Therefore the special structurally-unreachable-branch return is **not triggered** by this review.

### 9.2 Why the current study does not answer the required operating questions

The canonical scenarios are designed for demonstration, not realism:

* the null scenario uses 100–140 opportunities per cell, correlation about 0.99, and very low noise;
* notation/scaffold favorable effects are approximately 0.20—twice the improvement margin;
* harm is approximately 0.22—more than twice the harm margin;
* interaction uses a family range just above 0.15 with 100–140 opportunities and high correlation;
* only the deliberately sparse scenario represents low-information cells, and it is labeled inconclusive by design;
* SHAM is absent;
* missing pairs are silently dropped by the current analyzer;
* admissibility/manipulation pass and anti-taxidermy no-harm are supplied as favorable constants;
* only 36 repetitions and 160 bootstrap replicates are used;
* no Monte Carlo uncertainty accompanies claimed branch frequencies;
* the “required questions” become true when any favorable scenario reaches a branch, which is not the same as realistic attainability or useful operating sensitivity.

The scenario grid did not change the fixed margins, but it **did optimize the demonstration around them** by selecting dense, highly correlated opportunities and effects comfortably beyond the thresholds. That is lawful for a unit reachability check; it is not a sufficient Errata §5 precision disposition.

### 9.3 Review-only operating sanity check

To distinguish structural reachability from practical sensitivity, the review ran an additional synthetic-only grid through the packet’s current simulator/analyzer. This did not create or inspect real items, did not tune any scientific margin, and is not packet evidence. It used fixed master seed `20260716`, 80 repetitions per scenario, and 400 bootstrap replicates. Because the current analyzer ignores several anti-taxidermy and census gates, these results are optimistic rather than conservative.

| Review-only scenario | Selected branches | Mean `D_N` interval width |
|---|---|---:|
| null, sparse opportunities `[3,4,5,6]` | 72 inconclusive; 5 harm; 3 interaction | 0.1197 |
| null, moderate `[8,10,12]` | 70 inconclusive; 7 null; 1 harm; 2 interaction | 0.0805 |
| null, denser `[20,30,40]` | 64 null; 15 inconclusive; 1 interaction | 0.0466 |
| notation effect exactly `-0.10`, sparse | 4 notation; 73 inconclusive; 3 harm | 0.1099 |
| notation effect `-0.15`, moderate | 62 notation; 18 inconclusive | 0.0679 |
| scaffold effect at margin, sparse | 75 inconclusive; 4 interaction; 1 harm | 0.0995 |
| harm effect `+0.10`, sparse | 33 harm; 47 inconclusive | 0.1295 |
| harm effect `+0.15`, moderate | 62 harm; 18 inconclusive | 0.0851 |
| interaction exactly at threshold range, moderate | 44 interaction; 31 inconclusive; 4 harm; 1 null | 0.0782 |
| interaction range `0.20`, moderate | 59 interaction; 12 inconclusive; 9 harm | 0.0775 |
| notation `-0.12`, noisy/missing sparse | 13 notation; 65 inconclusive; 2 harm | 0.1151 |

These diagnostics support the following bounded judgments.

### 9.4 Required question-by-question ruling

**All five substantive branches structurally reachable:** **Yes.** Each fires under at least one canonical favorable scenario. No structural return is warranted.

**Each branch fires under a canonical favorable scenario:** **Yes.** `B-INTERACTION` fires 33/36 rather than 36/36, still demonstrating reachability.

**Is `B-NULL` meaningfully attainable rather than a painted door?** Mathematically yes; practically not established by the frozen report. The dense null scenario makes the ±0.05 triple-equivalence condition easy. In the review-only grid, moderate opportunities selected null only 7/80, while denser 20–40-opportunity cells selected it 64/80. It is not painted shut, but the current report paints it open with unusually favorable density/correlation.

**Is the ±0.05 equivalence interval realistically attainable?** Only under sufficiently dense, low-noise, highly paired opportunity structures. The current 24-item geometry does not by itself guarantee those structures. Sparse key opportunities make triple equivalence difficult. A repaired study must sample the actual prospective opportunity-count distribution without reading target output.

**Do the 0.10 improvement and harm margins have useful operating sensitivity?** Not uniformly. At the exact margin with sparse opportunities, notation/scaffold selections were rare and harm was only 33/80 in the review grid. Effects around 0.15 with moderate opportunities were materially more detectable. This does not justify changing `delta` or `h`; it means the pilot should expect inconclusive outcomes near the margins.

**Does `B-INTERACTION` have more than ornamental power?** Yes, it is structurally and behaviorally reachable. Its current power demonstration is favorable and its classification can be unstable near the exact 0.15 boundary; family noise also produced harm selections. It is non-ornamental but not yet well-characterized.

**Do discrete/sparse opportunities make a branch nearly unreachable?** They make `B-NULL`, at-margin `B-NOTATION`, and at-margin `B-SCAFFOLD` rare in the review grid, and weaken harm/interaction detection. This is a precision limitation, not structural impossibility.

**Is `B-INCONCLUSIVE` expected to dominate plausible scenarios?** Under sparse-to-moderate opportunity counts and effects near the scientific margins, yes. The frozen report’s `false` answer is not supported by a broad plausible grid. The review-only check is not an owner disposition, but it is sufficient to reject the current categorical claim.

**Does simulation preserve item clustering and fixed subject strata?** The bootstrap itself resamples items within family and retains subject/arm observations, so yes for rows that survive into the analyzer. However, missing-pair dropping and absent subject-harm/admissibility gates mean the full required data-generating/analysis process is not preserved.

**Does the simulation accidentally optimize the fixed scientific margins?** It does not alter them, but canonical scenario selection is strongly favorable relative to them. The required study must include threshold-adjacent, sparse, missing, refusal, truncation, and mixed-truth cases, not only branch-showcase cases.

### 9.5 Design and authority disposition

The initial 24-item design should remain a **feasibility-scale pilot**, not be rebranded as a powered efficacy or robustness study. The current evidence does not justify changing item count, family allocation, `delta`, `epsilon`, `h`, or interaction threshold. It also does not justify pretending that `B-INCONCLUSIVE` will be rare.

**RECOMMENDATION — AWAITING OWNER ADOPTION:** after FI-16 and FI-17 are repaired, choose the Errata-permitted disposition **retain the design while acknowledging that `B-INCONCLUSIVE` is expected to dominate the repaired study’s plausible sparse/moderate range**. Keep 24 items, six per family, and all fixed margins unless the repaired study supports an in-scope allocation adjustment without outcome tuning. This is one recommended disposition, not an adopted ruling.

A repaired precision study must include:

* SHAM diagnostic generation and exact 24-call status behavior;
* actual completeness/refusal/abstention/utility/truncation/over-bounding candidate gate ranges, without selecting final owner thresholds from target output;
* fixed schedule cells, duplicate refusal, explicit missing pairs, census floors, and non-ignorable missingness;
* moderate and threshold-adjacent effects, nulls, heterogeneous family and subject effects, sparse discrete opportunities, positive/insufficiency/trap mixtures, and plausible correlation ranges;
* at least one scenario where a substantive truth exists but `B-INCONCLUSIVE` dominates;
* Monte Carlo uncertainty and a frozen runtime/canonical decimal contract;
* exact owner-facing mapping to one Errata §5.4 disposition.

No tuning of `delta`, `epsilon`, `h`, or the interaction threshold from synthetic output is authorized.

---
## 10. PACKET MERGE AND FREEZE-WORK DISPOSITION

# ACCEPT WITH NAMED PRE-FREEZE REPAIRS

### 10.1 Basis for the primary disposition

The packet is not rejected as an unlawful project. Its repository custody is exact; its branch is confined to the authorized experiment directory; it protects the existing production scopes; it contains no real item/key/provider exposure; it preserves P2a dormancy; it states the principal doctrine with unusual care; its core schedule geometry and branch precedence are recognizable; its dry-run behavior is deterministic; and all substantive branches are structurally reachable without changing the fixed scientific margins.

It cannot receive an unqualified scaffold acceptance because multiple load-bearing gates are weaker than their normative text. The present readiness switch can be bypassed; future items and lineage lack strict semantic schemas; prompt headers disclose conditions; the displayed LANG-A specimen is not validator-lawful; the 312-call run bypasses the real templates because no immutable renderer exists; the scorer trusts provider-authored facts rather than a strict key contract; anti-taxidermy harm is not calculated; missing pairs/census/subject harm/randomization are absent; SHAM and firebreak are not integrated; claim linting is incomplete; branch-receipt identity does not bind the final receipt; evidence can overwrite; and numerical evidence byte replay is environment-sensitive. Those are not decorative paperwork defects. They are precisely the machinery that distinguishes a lawful freeze from a folder that says “frozen” on the lid.

The appropriate holding is therefore to accept the construction as a repairable owner-freeze scaffold, authorize bounded owner work, and withhold all freeze and exposure authority until the named repairs close.

### 10.2 Named pre-freeze repair package

A successor repair candidate must complete all of the following without modifying protected scopes or changing scientific authority:

**R-01 — Item/source/rendering and commission contract.** Implement strict schemas and validators for item records, source-packet manifests, renderings, freezer-only role/witness dossiers, exclusions, ancestry, prior exposure, lexical collision, semantic overlap, freezer acceptance, and the minimized `KEY-AUTHOR-INPUT`. Exercise malformed, dangling, tainted, duplicate, leaked-role, leaked-witness, moving-bank, and wrong-version mutations before substantive item authorship.

**R-02 — Target-visible prompt neutrality and validator-lawful LANG-A form.** Remove all arm/experiment/diagnostic labels from visible templates; eliminate Language-A naming from SCAFFOLD; remove SHAM disclosure; replace the LANG-A specimen with a minimal record that passes the unchanged protected validator when instantiated; freeze exact wrapper/system bytes; run obligation-parity, leakage, validator-instantiation, byte/word, and provider-tokenizer checks.

**R-03 — Exact design and schedule enforcement.** Enforce the owner-adopted item/family/SHAM/minimum-control geometry, 312/32/344 and token/spend algebra, blocked randomization by subject/family/arm, exact seed ownership, schedule digest, and integer analyzability floors.

**R-04 — Semantic manifest and lineage closure.** Split construction and freeze manifests; load strict schemas; enforce every unique ID/reference/version/parent; define canonical lineage bytes, event and predecessor digests, chronology, bounded unknowns, immutable successor transitions, and unmanifested-file refusal. Execute every named manifest mutant, not a hand-selected subset.

**R-05 — Evidence-bearing readiness.** Replace status strings and `pre_exposure_gate_signed` Boolean with typed owner rulings and a verifiable signature over the exact freeze manifest, commit/tree, design/schedule, item/source/key identities, subject/config/price/run-window identities, lineage completion, staffing/firebreak, and two fresh verification receipts. Add bypass mutations including blank bank, absent key, fake role, fake price, fake search completion, and stale signature.

**R-06 — Renderer and request/response/run custody.** Implement one immutable renderer that actually composes every synthetic and future real item through the frozen task/source/template/wrapper path. Use strict loaded schemas; bind exact visible payload bytes and metadata envelopes separately; record raw/normalized parent hashes; bind census to the frozen schedule; reject duplicates/omissions; implement returned-model identity, finish reason, retry, caching/retention, usage, price, and pre-call cost-reservation gates; enforce network-off/live boundaries outside import-string scans.

**R-07 — Key separation.** Implement the separate key-author handoff, immutable key identity/custody receipt, OS/worktree-level key absence from runner/subjects, post-lock read-only mount or item-slice delivery, versioned authorized reads, alias/symlink/child-process denial, and negative-access evidence from a separate custody authority.

**R-08 — Key-bound scoring, anti-taxidermy, and mutation adequacy.** Load a strict score schema and immutable private-key input; reject provider/self-authored score facts as authority; validate all types, ranges, counts, denominators, and parent identities; implement owner-adopted completeness, refusal, abstention, utility, truncation, over-bounding, positive-conclusion, deletion/omission, and cost gates; preserve fixed denominators; remove caller-supplied harm truth; kill every declared mutant through the detector and add hand-derived estimator/denominator oracles.

**R-09 — Analysis fidelity.** Bind expected cells to schedule; reject duplicates; preserve missing census; enforce 90% overall and 80% stratum floors; compute manipulation checks; report family and fixed-subject estimates/harm; add the cluster-preserving sign/randomization test; encode complete branch predicates once; make `B-INCONCLUSIVE` true only when no stronger complete predicate holds; name harmed contrasts/strata.

**R-10 — Synthetic precision.** Add SHAM and actual gates, broad plausible opportunity/effect/missingness/refusal/truncation grids, substantive-truth inconclusive cases, Monte Carlo uncertainty, owner candidate ranges without target tuning, and one owner-facing Errata disposition. Pin the runtime and canonical numeric serialization so byte replay succeeds.

**R-11 — Grader/adjudicator firebreak.** Implement calibration-taint identity, chronological read authorization, exact source/key-slice delivery only after response lock, grader disqualification/replacement, two separately locked first passes, reliability/fallback gate, minimal fresh-session adjudication, and shared-root receipts. Integrate it into manifest/readiness and mutate every forbidden transition.

**R-12 — SHAM and claim ceiling.** Derive SHAM status from the exact 24 calls and frozen tokenizer/leak/discard evidence; preserve its diagnostic ceiling and unresolved-edge return. Replace free-text claims with structured manifest-bound claim records; cover all 13 requested forbidden propositions and equivalents; require exact riders; scan every declared surface; mutate every rider and inversion.

**R-13 — Immutable evidence, final-receipt identity, and honest ledger.** Make every run/report/manifest attempt-addressed and successor-only; preserve failures; distinguish analysis-core digest from final claim-bearing receipt digest and bind the latter externally or by sidecar; correct `IMPLEMENTATION-LEDGER.md` to the exact demonstrated scope; clarify 94 non-self manifest files versus 96 Git changes and local synthetic invocations versus external calls.

**R-14 — Final reproducibility evidence.** In a pinned freeze environment, rerun the full non-SBCL suite, the repaired precision and 312-call/full-lineage replay, and the Common Lisp driver/Mneme floor twice from clean state. Archive exact commands, environment/runtime/dependency identities, stdout, stderr, exit statuses, file manifests, branch receipts, and signature hashes. The required docket classification remains **SBCL RUNTIME REPRODUCTION NOT PERFORMED IN REVIEW SANDBOX**; the successor owner/Codex receipt, not this review, supplies runtime reproduction.

No repair may tune `delta`, `epsilon`, `h`, interaction threshold, branch precedence, subject count, arm semantics, claim ceiling, 344-attempt ceiling, or USD 8.00 ceiling. A change to those requires controlling-authority return.

### 10.3 Stage-by-stage authorization

| Stage | Holding |
|---|---|
| Item-author selection, owner adoption, contracting, schema work, and non-target-specific commission setup | **MAY BEGIN**; these activities create no target item/source bytes and no exposure authority |
| Target-specific source reconnaissance or creation of substantive real-item/task/source/rendering/witness drafts | **NOT YET AUTHORIZED FROM THE DELIVERED PACKET**; becomes authorized only after FI-01/FI-05 close, ODR-43/60 close, strict draft schemas exist, and digest-chained read/artifact lineage is active in a separate worktree |
| Real item-bank freeze | **NOT AUTHORIZED** until R-01–R-04, R-08–R-10, relevant owner fields, overlap audits, and repaired precision disposition close |
| Private score-key authorship | **NOT YET AUTHORIZED**; it may begin only after exact frozen item/source handoff bytes and owner scoring/anti-taxidermy rules exist |
| Private score-key freeze | **NOT AUTHORIZED** until section 5 custody, denominator, read, audit, and owner rules close |
| Packet-scaffold merge preparation | **MAY BEGIN** on a separate repair candidate, limited to the authorized experiment directory and the named repairs |
| Actual packet-scaffold merge/freeze | **NOT AUTHORIZED** until the repaired candidate passes independent authorial re-review and two fresh verification runs |
| Live-adapter commission | **MAY BE PLANNED**, but its code/config requires separate review and cannot inherit exposure authority from this packet |
| First real target transmission | **NOT AUTHORIZED** |
| Target scoring, grader access, or adjudication | **NOT AUTHORIZED** |
| P2a | **DORMANT-BUT-AUTHORIZED**; no activation, resource draw, example transfer, or worktree crossing occurs under this docket |
| Implementation repair by Codex | **REQUIRED**, bounded to R-01 through R-14 and the authorized experiment scope |
| Another authorial ruling | **NOT CURRENTLY REQUIRED**, subject to the conditional return triggers below |

### 10.4 Conditional authorial-return triggers

A new scoped authorial ruling becomes mandatory before real-bank freeze or exposure if any of the following occurs:

* the finalized SHAM design can produce the unassigned ≥70%-uptake/no-leak/no-discard/>10%-token shape;
* semantic leak and explicit discard remain overlapping status predicates and cannot be made evidence-distinct without invented precedence;
* a repaired canonical favorable scenario makes a substantive branch structurally unreachable;
* a proposed design change alters subject count, arm semantics, practical margins, branch predicates/precedence, claim ceiling, or call/spend ceilings;
* repair requires changing CD/0, LCI/0, Mneme, Language A, de-corroboratione, or another protected scope;
* an exact model/route cannot satisfy the required identity, custody, settings, tokenizer, retention, or price disclosure without broadening the claim law;
* a discovered Common Lisp defect is in protected authority rather than the local experiment adapter.

None of those triggers is established by the reviewed artifact today. The present precision study shows all substantive branches reachable, and no protected-scope defect was found.

### 10.5 Final authorial holding

The packet is a serious and mostly candid construction scaffold. It has done the intellectually useful part of naming many of its own limits. Its remaining vice is more bureaucratic than metaphysical: too many gates salute the requirement without actually checking its passport.

Owner freeze work, commission preparation, and bounded repair/merge preparation may begin. Substantive item authorship may **not** begin until FI-01 and FI-05 close; after that, only reversible firewalled drafts are permitted. The score-key commission, bank freeze, packet freeze, target scoring, and live transmission may not begin under the delivered packet. Passing tests remain evidence of tested behavior, not a dispensation from the authority they were meant to encode.

---

## 11. REQUIRED MACHINE-READABLE CLOSE

```lisp
(:language-a-pilot-owner-freeze-work-docket
 :review-date "2026-07-16"
 :delivery-identity :verified
 :reviewed-branch "transfer/language-a-pilot-freeze-review"
 :reviewed-commit "f5f0e4a6972f9b321167e5aef6c5c47c70d56e3e"
 :reviewed-tree "6561d3097c056c517e9f67fad1c168608d60f0db"
 :frozen-base "360bb1ff2ec13b039681986d3bcfc2b27e57f53c"
 :packet-scaffold-standing :accept-with-named-pre-freeze-repairs
 :faithful-incorporation
 (:narrative-doctrine :substantially-faithful
  :executable-gates :materially-incomplete
  :structurally-unreachable-substantive-branch nil)
 :item-authorship
 (:commission-preparation :authorized
  :substantive-drafting :not-yet-authorized
  :bank-freeze :not-authorized
  :requires (:fi-01-closed :fi-05-closed :owner-adopted-commission :strict-draft-schemas :digest-chained-lineage :taint-boundary :named-actors))
 :score-key-authorship
 (:status :not-yet-authorized
  :requires (:frozen-item-source-handoff :owner-scoring-rulings :separate-custody-boundary))
 :packet-merge-preparation :authorized-for-repair-candidate-only
 :packet-freeze :not-authorized
 :live-exposure :not-authorized
 :target-scoring :not-authorized
 :p2a :dormant-but-authorized
 :implementation-repair :required
 :sbcl-runtime-reproduction :not-performed-in-review-sandbox
 :precision-runtime-replay :failed-byte-identity-with-semantic-branch-results-unchanged
 :authorial-return :not-currently-required-conditional-on-named-return-triggers
 :remaining-owner-gates
 ((:scoring-and-anti-taxidermy "ODR-01..ODR-24")
  (:subjects-routes-settings-cost "ODR-25..ODR-42")
  (:staffing-grading-adjudication "ODR-43..ODR-55")
  (:sham-design-seeds-statistics "ODR-56..ODR-67")
  (:key-lineage-claims-runtime-fire "ODR-68..ODR-80"))
 :required-repair-package "R-01..R-14"
 :primary-disposition :accept-with-named-pre-freeze-repairs)
```
