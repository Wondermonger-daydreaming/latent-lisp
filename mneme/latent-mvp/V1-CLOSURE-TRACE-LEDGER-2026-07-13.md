# Mneme v1 closure sprint — append-only trace ledger

**Ledger date:** 2026-07-13
**Repository boundary:** `latent-lisp`, audited base `9e9c031` through review target `9ad804f`
**Purpose:** preserve consequential claims, decisions, corrections, and unresolved uncertainty for a later Claude review

This ledger is append-only in meaning. A later correction should add an entry that
supersedes an earlier entry rather than rewriting the earlier claim into a smoother
history.

---

id: T001
statement: The user required backups and non-destructive, reversible work before implementation.
kind: user-stated
evidence: user instruction in the session that initiated the sprint
scope: implementation workflow, 2026-07-12/13 session
status: active
confidence: high — explicit instruction
consequence: the audited base was preserved before editing, and work proceeded on a dedicated branch with staged commits
supersedes: none

---

id: T002
statement: `LANGUAGE-BOUNDARY.md` identified `9e9c031a720cd40559297c9d8bb07bf8137adb54` as its pinned audit target.
kind: observed
evidence: audit metadata recorded in `V1-COUNTEREXAMPLE-CLOSURE.md`; audit SHA-256 `c1876eba2010b5ab2fc23afb15b7982b4a2ee4550a11238e81a592965111a242`
scope: external review as received for this sprint
status: active
confidence: high — directly read and hashed during the session
consequence: no implementation decision was based on later `main`; commit ancestry begins at this revision
supersedes: none

---

id: T003
statement: The audited base is recoverable without depending only on the working branch.
kind: observed
evidence: local ref `backup/audit-9e9c031`; verified bundle `../latent-lisp-audit-9e9c031.bundle`; bundle SHA-256 `9439d8f3509a8e6c43bab946f9401aa1cbdb971add078fe596178c5bde58b35b`
scope: current Codex-Lab workspace
status: active
confidence: high — `git bundle verify` reported complete history and okay
consequence: rollback and independent inspection do not require destructive Git operations
supersedes: none

---

id: T004
statement: All seven required defect classes were reproduced by ten executable exported-client fixtures before the kernel changed.
kind: observed
evidence: commit `7b50deb441189e9cb3a48174038c4495347e9b0e`; baseline command `cd mneme/latent-mvp && sbcl --script counterexample-closure.lisp`; result `0 passed, 10 failed`, exit 1
scope: pinned kernel on SBCL 2.4.6
status: active
confidence: high — direct execution and preserved test-only commit
consequence: the green suite is discriminating against the audited defects rather than merely exercising post-repair happy paths
supersedes: none

---

id: T005
statement: A private canonical datum algebra was selected over copy-only discipline and authoritative canonical bytes.
kind: inferred
evidence: three-strategy comparison in `V1-COUNTEREXAMPLE-CLOSURE.md`; implementation in `kernel-hardened.lisp`
scope: correctness-first v1 reference kernel within exported-client threat model
status: active
confidence: medium — tradeoff judgment, not an empirical theorem
consequence: propositions, scopes, `as-of`, predecessor data, and provenance cross explicit freeze/thaw boundaries; a future normative byte codec remains separate work
supersedes: none

---

id: T006
statement: The private datum representation does not establish immutability against unrestricted same-image Common Lisp.
kind: inferred
evidence: canonical values are private Common Lisp structs; threat-model comments in `kernel-hardened.lisp`; report residuals
scope: host-language bypass boundary
status: active
confidence: high — Common Lisp package privacy is not confinement
consequence: all closure claims remain bounded to documented `mneme.client` use; evaluator/module or process isolation is still required for P4
supersedes: none

---

id: T007
statement: The first implementation of private canonical data temporarily broke lawful replay.
kind: observed
evidence: independent verification review reported adversarial 15/3 and boundary 0/9; cause was `replay-and-attest` passing a private `canonical-cons` into the client proposition validator
scope: intermediate uncommitted implementation state
status: corrected
confidence: high — existing suites failed through the predicted seam
consequence: the representation boundary had to include an explicit thaw before successor re-verification
supersedes: none

---

id: T008
statement: Lawful replay was restored by thawing the private proposition before `verify-proposition`.
kind: observed
evidence: `replay-and-attest` in `kernel-hardened.lisp`; subsequent adversarial 18/18 and boundary 9/9
scope: review target `9ad804f`
status: active
confidence: high — direct code inspection plus focused regression results
consequence: T007 no longer describes current behavior, but remains part of the implementation trace
supersedes: T007

---

id: T009
statement: Raw artifact decoding and receipt-backed revival are observably distinct at the exported API.
kind: observed
evidence: exported `decode-artifact`; receipt-only `revive`; CE8 and CE9; process-boundary suite provenance check
scope: `mneme.client` at review target `9ad804f`
status: active
confidence: high — separate functions, typed refusal, and provenance assertions
consequence: process B can claim untrusted reconstruction and local reauthentication, not receipt custody that did not cross the process gap
supersedes: none

---

id: T010
statement: Receipt transitions are guarded monotonically and illegal transition conditions carry attempted endpoints.
kind: observed
evidence: `%guard-receipt-transition`; condition readers `handoff-source-state` and `handoff-destination-state`; CE6 and CE7
scope: single-threaded observed execution under SBCL 2.4.6
status: active
confidence: medium — implementation is general, but tests sample rather than exhaust the transition matrix and no concurrency semantics exists
consequence: recommit after revival no longer rewinds state; later reviewers should test the full matrix and failure atomicity
supersedes: none

---

id: T011
statement: Predecessor testimony survives the tested second handoff without becoming live authenticated authority.
kind: observed
evidence: `freeze` appends inherited predecessor data and current warrant data; CE10; authenticated set remains empty on decode/revival
scope: recorded two-hop fixture on SBCL 2.4.6
status: active
confidence: high for the fixture, low for arbitrary lineage depth/compaction because not tested
consequence: the documented second-hop erasure is closed; verified transitive lineage is not established
supersedes: none

---

id: T012
statement: The initial green implementation left repository verification metadata stale.
kind: observed
evidence: final independent audit found README/MANIFEST still claiming five floors, adversarial 16/0, and three atelier banners after `verify-all.sh` had six floors
scope: intermediate state at commit `76ac3fd`
status: corrected
confidence: high — direct textual contradiction
consequence: a documentation-only commit was required before handoff
supersedes: none

---

id: T013
statement: Verification metadata now matches the six-floor umbrella.
kind: observed
evidence: commit `9ad804f4e640e2901e9405a64af4444ee7fa9eb5`; README; `mneme/MANIFEST.md`; final `verify-all.sh` output
scope: review target `9ad804f`
status: active
confidence: high — direct inspection and repeated umbrella run
consequence: T012 is historical rather than current, and Claude should review six declared floors
supersedes: T012

---

id: T014
statement: At review target `9ad804f`, all six declared SBCL floors pass.
kind: observed
evidence: `bash mneme/verify-all.sh` on 2026-07-13: conformance 7/7; adversarial 18/18; counterexamples 10/10; boundary 9/9; atelier 4 banners; Language-A 14/14; exit 0
scope: SBCL 2.4.6, current workspace and committed tree `ca62f47f2ace3ccdef0194f65056be6373732bb2`
status: active
confidence: high — direct execution, but finite and implementation-specific
consequence: no known regression remains in the declared suite; this does not imply untested equivalence or language closure
supersedes: none

---

id: T015
statement: A warrant can still raise same-proposition claims with different `as-of` values.
kind: observed
evidence: Tesla's direct SBCL probe reported both `as-of-1 raised=T` and `as-of-2 raised=T`; residual recorded in `V1-COUNTEREXAMPLE-CLOSURE.md`
scope: exported façade at review target; defect deliberately outside the seven-class sprint
status: unresolved
confidence: high — executable counterexample observed by independent reviewer
consequence: no complete located-claim identity should be claimed; a future repair must begin with its own permanent red fixture
supersedes: none

---

id: T016
statement: Proposition fingerprinting still depends on ambient Common Lisp printer/package state.
kind: observed
evidence: Tesla's direct probe asserted and verified equivalent numeric propositions under different `*print-base*` bindings and observed target mismatch; audit and final report record the debt
scope: exported façade at review target; deliberately outside the seven-class sprint
status: unresolved
confidence: high — executable counterexample observed by independent reviewer
consequence: the current fingerprint is not host-independent canonical identity; a future repair needs a red ambient-state fixture and eventually a normative codec
supersedes: none

---

id: T017
statement: `receipt-path` and arbitrary operator-supplied attestation principals remain potential mutable host aliases.
kind: inferred
evidence: exported readers and storage paths identified in Tesla's source audit; recorded as residual façade debt in the final report
scope: adjacent exported surface at review target
status: unresolved
confidence: medium — source-level alias analysis; no permanent exploit fixture was added in this sprint
consequence: the private datum strategy should not be generalized into a claim that every exported field is canonical
supersedes: none

---

id: T018
statement: Three agreeing reviewers do not constitute independent implementation evidence.
kind: inferred
evidence: Tesla, Hubble, and Jason inspected the same Common Lisp implementation and SBCL-derived fixtures
scope: evidentiary interpretation of multi-agent review
status: active
confidence: high — shared artifact and runtime ancestry are explicit
consequence: their value is independent reading and counterexample generation, not P5 cross-implementation agreement
supersedes: none

---

id: T019
statement: The final warranted description is bounded P3 counterexample closure, not P4/P5 language closure.
kind: inferred
evidence: T004, T006, T009–T018; `V1-COUNTEREXAMPLE-CLOSURE.md`; final suite banner
scope: ten specified fixtures and protected existing floors at review target `9ad804f`
status: active
confidence: high — positive evidence and missing isolation/specification evidence are both explicit
consequence: future summaries must carry the exported-client/SBCL/finite-test boundary close to any success claim
supersedes: none

---

## State transition at handoff

### What became known

- The seven required façade defect classes were real and executable at the pinned
  revision.
- The ten fixtures distinguish that baseline from the repair.
- Private canonical data, structural scope, guarded receipt transitions, explicit
  raw decode, and cumulative predecessor testimony satisfy those fixtures at the
  current review target.
- Existing suite integration and verification metadata are green and aligned.

### What was corrected or abandoned

- Passing private canonical data directly into replay was abandoned; replay now
  thaws before re-verification.
- Calling raw cross-process reconstruction “revival” was abandoned; it is now
  explicitly untrusted decoding.
- Five-floor and stale-count verification metadata was corrected to the current
  six-floor state.

### What remains unresolved

- complete located-claim identity, including `as-of`;
- ambient-state-independent fingerprints and normative canonical bytes;
- remaining mutable exported aliases;
- exhaustive receipt-transition and failure-atomicity tests;
- verified transitive lineage and loss representation;
- revocation-aware standing, warrant reuse policy, code/effect identity;
- evaluator/module/process isolation and a second implementation.

### Next observation with the highest decision value

Have Claude generate a new exported-client counterexample outside CE1–CE10,
preferably by exhaustively mutating every value returned by every `mneme.client`
reader and checking whether any later authority-bearing transition changes meaning
without changing accepted identity. A new witness there would decide whether the
private datum repair is a coherent boundary or merely the next incomplete list of
copiers.
