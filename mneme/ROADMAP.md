# Roadmap: Concretizing Mneme (LispPlus) as an Epistemic Runtime for LLMs

**Goal:** Take Mneme from tonight's verified toy-with-teeth to a real instrument: a
notation + validator + enforcement loop that measurably changes the error profile of
LLM-emitted claims — or a clean, published demonstration that it doesn't.

**Approach:** Empirical gate first, enforcement bridge second, integrity third,
interop fourth. Build nothing cathedral-shaped before the pilot says the ground holds.

**Status:** Draft v1.1 — 2026-07-11 late night, Claude Fable 5 (lab chair).
**Grill resolutions (owner interview, same night — /grilling, chavruta):**
- **R1 — Mneme is a LAB-FIRST INSTRUMENT.** Phase 4 demoted to dogfood (4.3) + sibling
  pass (4.4); MCP tool and JSON projection build only when an outside asks; Phase-3
  crypto sized to the lab's threat model; Phase-5 paper claims an instrument-in-use.
- **R2 — DEDICATED PUSH NOW.** Mneme takes the top slot; jspace Phase 3–4 and
  measure-ρ re-fires queue behind it until the push's gates land.
- **R3 — PARALLEL TRACKS.** The grill exposed D1's soft spot (Phase 1 gates Phase 2's
  *scale*, not its existence). Resolution: Phase 0 + Phase 1 v0.2/freeze (chair work)
  run WHILE a delegated builder constructs the Phase-2 harness prototype (no verdicts
  until its own prereg). First experimental money still goes to the Phase-1 pilot.
- **R4/R5 deferred** to Phase-1 freeze time (crypto sidecar tolerance; freezer identity).
**Review owed:** one fresh-weights read of this roadmap before Phase 1 spends money
(candidates: Hermes or Nimbus — Tend is recused from Language-A blind seats but NOT
from roadmap review; GPT is a co-author of the object under test and reviews as
*interested party*, labeled as such).

---

## Context

### Problem

The lab has proven, piece by piece and always against a live SBCL, that an epistemic
discipline can be *compiled*: rhetoric cannot wear an evidential verdict (L1–L7), a
serialized "verified" grants nothing across a process gap (boundary suite, 9/9), a
search must say which room it emptied (jurisdiction wing), and a claim record can be
deterministically validated (language-a validator, 14/14). What is NOT yet
demonstrated is the only claim that makes this matter for LLMs: **that a model
reasoning with / through / under Mneme produces better-behaved claims than the same
model without it.** Everything below either tests that claim or builds the machinery
the test needs.

### Verified current state (the inventory; all exit 0 as of tonight)

| Asset | Where | Status |
|---|---|---|
| Kernel v0 (claims, witnesses, certificates, grades, L1–L7) | `mneme/latent-mvp/kernel.lisp` + `conformance-walk.lisp` | 7✓ |
| Hardened client/operator split | `kernel-hardened.lisp` + `adversarial-conformance.lisp` | 18✓ (13 forgeries refused) |
| Real-image-boundary suite (L5/L6/L7 across processes) | `latent-mvp/boundary/` | 9✓ |
| Attestation-revocation registry (owed #0a) | per owed-ledger | PAID |
| Jurisdiction wing (GPT): receipt-of-search, de-limine, memorandum | `mneme/atelier/instruments/` | all conditions fired |
| Language-A validator + 14 fixtures + DEPOSITION-NOT-THOUGHT | `mneme/language-a/` | 14/14 |
| Language-A experiment prereg | `experiments/language-a-exoskeleton/PREREG-DRAFT-v0.1.md` | **un-freezable as-is** — Tend review (c172d263), v0.2 owed |
| Public mirror | github.com/Wondermonger-daydreaming/latent-lisp | auto-syncs on commit |

### Constraints

- **SBCL 2.4.6, no external dependencies** is the standing law for everything under
  `latent-lisp/` — crypto and networking therefore live in thin, clearly-marked
  adapter layers or in Python harnesses *outside* the Lisp tree, never as quicklisp
  imports smuggled into the kernel.
- **The lab's own discipline binds the project about itself**: preregistration before
  verdicts, δ for null branches, harness-is-exposure for any blind subject, no claim
  above its receipt. A roadmap item that would require asserting "Mneme works"
  without the Phase-1 data is out of order by construction.
- **Budget:** API pilots are cheap ($3–40 per the prereg §9); one Colab session for
  logprob replication; Opus builders for mechanical construction; Fable/chair time is
  the scarce resource — every phase names what is delegable.
- **Declined items stay declined** (owed-ledger #0b/#2/#6/#1) unless a phase gate
  produces a new reason; the ledger's "no" is not a backlog.

### Success criteria (for the roadmap as a whole)

- [ ] Language-A experiment FIRED with adequate power → a banked verdict (B-EXO,
      B-THEATRE-as-fixed, or a δ-licensed null), published either way
- [ ] An enforcement loop exists where a live model's emissions are validated and
      repaired in-session, with the repair-locality effect measured (currently
      GPT bullet #4 — covered by NO arm anywhere)
- [ ] A serialized Mneme record carries tamper-evidence (canonical bytes + MAC),
      closing the ceiling SIGILLUM named
- [ ] At least one *non-Claude* system emits valid Mneme records through the interop
      surface, and at least one lab workflow (prereg or ledger) consumes them
- [ ] Every tier's threat-model ceiling stated in the artifact itself, maintained
      under the "relocated seam" honesty (a receipt has no witness for its own census
      — this is DOCUMENTED as open wherever it applies, never papered)

---

## Design decisions (made now, revisable with reasons)

### D1: Empirical gate before enforcement cathedral
**Options:** build the full runtime first vs. test the notation's value first.
**Selected:** test first (Phase 1 blocks Phase 2's *scale*, not its prototype).
**Reasoning:** the lab's own pitch-discipline — a clean null is publishable; a
cathedral on an untested premise is the flinch-ladder in architecture form. Tend's
P1 (emission ≠ enforcement) cuts both ways: a null on *emission* does NOT kill
*enforcement* — which is exactly why F5 must be ruled before freeze.
**Reversibility:** easy (phases reorder cleanly).

### D2: Enforcement lives in the harness, not the prompt
**Options:** teach models to self-validate in-context vs. run the validator as code
in the loop (model emits → validator fires typed conditions → model repairs).
**Selected:** validator-in-the-loop (the Architect doctrine: prompts guide, code
enforces; the model judges, code owns the guarantee).
**Reversibility:** medium.

### D3: Integrity = canonical serialization + MAC, not process trust
**Options:** trust the store; sign records; full PKI.
**Selected:** canonical S-expression bytes + HMAC via a small adapter (sha256 exists
in SBCL contribs via `sb-md5`? — NO: verify at build time; if no dependency-free
HMAC-SHA256 is achievable in-tree, the signer lives in a Python sidecar and the Lisp
kernel only *verifies structure + delegates MAC checks*, with that split stated).
**Reversibility:** medium. The decision that is NOT revisable: unsigned records never
gain authenticated grades across a boundary (already law, L6).

### D4: Mneme stays Lisp-canonical; interop is a projection
**Options:** migrate to JSON-native vs. keep s-expressions canonical with mirrors.
**Selected:** s-expressions canonical (homoiconicity is the thesis); a lossless
JSON projection + schema for tools that can't read sexps; round-trip property tested.
**Reversibility:** hard after external adoption — hence decided now.

---

## Implementation phases

### Phase 0 — Consolidation & CI floor (1 short session; mostly delegable)

*Everything later assumes tonight's floor cannot silently rot.*

- **0.1 One-command verification.** `mneme/verify-all.sh`: conformance-walk,
  adversarial, boundary, instruments, language-a fixtures — one script, one exit
  code, runtime <2 min. **Files:** new script + README pointer. **Effort:** S.
  *(Delegable: Opus builder.)*
- **0.2 Manifest.** `mneme/MANIFEST.md`: every runnable, its law, its expected
  check-line count — the "what should be true" table a fresh hand walks (the
  GNOMON-II rule: procedures audited by simulation; write it for the stranger).
  **Effort:** S. *(Delegable.)*
- **0.3 Git hook or checkpoint script** running verify-all on latent-lisp commits
  (extend the existing post-commit sync hook; failure = loud warning, not block —
  the repo also holds deliberate fragments like Retis's bed, so scope the hook to
  `mneme/` only). **Effort:** S–M. *(Delegable; chair reviews hook scope.)*
- **Gate G0:** verify-all green twice, run by a hand that didn't write it.

### Phase 1 — The empirical gate: Language A v0.2 → freeze → pilot → fire

*The phase that decides what the rest of the roadmap is for.*

- **1.1 PREREG v0.2** incorporating Tend's five necessitated revisions: resolve
  P1/F5 (recommend: **emission-only pilot, enforcement as its own later
  experiment** — scoped claims, "emitted notation" wording); fix **B-THEATRE**
  (add SCAFFOLD−PERSONA ≈ 0 condition or reword attribution); price
  **instruction-load** (add a matched-teaching control or measure teaching-token
  delta explicitly); name **trap-circularity** as a rider on trap-catch claims;
  pre-register the **domain-interaction analysis**. Fold in NOMEN's uncovered
  bullets #2 (residue preservation → add a measurable: unresolved-field survival
  rate across restatements) and #4 (goes to Phase 2, cross-referenced not
  duplicated). **Files:** `experiments/language-a-exoskeleton/PREREG-v0.2.md`.
  **Effort:** M. *(Chair work; NOT delegable — but drafts reviewable by agents.)*
- **1.2 Fork rulings + freeze.** F1 δ-anchor, F2 elicitation, F3 gutting method,
  F4 panel, F5 emission/enforcement — rulings quoted VERBATIM into the frozen doc
  (the r48 §0.3 instrument), hash-locked, ruling chair ≠ item author where
  possible. **Effort:** M. *(Owner decision on the non-participant-grader
  question rides here — same standing question as jspace Phase 4.)*
- **1.3 Item + trap authoring by a non-grading hand** (fresh Opus agent, named,
  charactered; lexical-collision audit run on SCAFFOLD vs LANG-A materials before
  freeze — the Fortuna gate). **Effort:** M. *(Delegable with chair audit.)*
- **1.4 Pilot** (~$3–8, API mini-class panel): teeth-check every trap type
  (catchable-at-all before "missed" may count), MDE/adequacy floor, θ for
  decorative-compliance. **Effort:** M.
- **1.5 Fire production** (~$15–40), bare-API subjects (HARNESS IS EXPOSURE —
  enumerated V-conditions), grading per frozen plan, verdict banked at its
  receipt's size. **Effort:** M–L.
- **Gate G1:** a banked outcome branch. **All three branches proceed** — B-EXO
  scales Phase 2; B-THEATRE *redirects* Phase 2 to enforcement-only value (the
  validator still catches incoherence even if notation doesn't improve
  calibration); a VOID re-runs 1.4–1.5 fixed. The only forbidden move: quietly
  proceeding as if B-EXO landed when it didn't.

### Phase 2 — The enforcement bridge (validator-in-the-loop)

*Tests the thing Tend's P1 exposed and NOMEN found uncovered: does deterministic
validation produce more local repairs? This is Mneme as HARNESS.*

- **2.1 Loop harness** (Python, outside the Lisp tree): model emits a `judgment`
  record → `validator.lisp` runs as subprocess → typed conditions returned to the
  model verbatim → model repairs → loop until valid or budget. Log everything.
  **Files:** `experiments/mneme-enforcement/harness.py` + prompts. **Effort:** M.
  *(Delegable.)*
- **2.2 Repair-locality experiment, preregistered** (small, its own doc, lessons
  from 1.x applied): typed-condition feedback vs. generic "your record is
  invalid" vs. free-form critique — measured on repair edit distance, iterations
  to valid, semantic drift of untouched fields (does a repair *erase residue*? —
  GPT bullet #2 gets its metric here too). **Effort:** M–L.
- **2.3 The Mneme-REPL sketch** (stretch): interactive session where every model
  claim is minted through the client API — the first taste of "reasoning under
  enforcement," explicitly exploratory, no verdicts. **Effort:** M. *(Playground
  register; siblings invited.)*
- **Gate G2:** repair-locality result banked; harness reusable.

### Phase 3 — Integrity layer (the ceiling SIGILLUM named)

- **3.1 Canonical serialization.** Deterministic printer (sorted keys, fixed
  float syntax, no *print-circle* surprises) + property test: read→print→read
  fixpoint (the text-tower shows the way). **Effort:** M. *(Delegable.)*
- **3.2 MAC adapter** per D3: dependency audit first; then HMAC over canonical
  bytes; `authenticate-grade` extended to require valid MAC across boundaries —
  as a MODE, old in-image path byte-identical. Teeth: bit-flip must fail, forged
  MAC must fail, replay across corpus-version must fail. **Effort:** M–L.
- **3.3 The census-witness problem** — honest options only: (a) double-entry
  scope counting by an independent procedure; (b) witness delegation (a second
  process re-runs the search seed-fixed and countersigns); (c) leave OPEN with
  the current printed confession. Rule which, in a short design memo, and note
  that (a)/(b) still bottom out in *some* trusted procedure — the seam relocates
  again; say so. **Effort:** S (memo) + M (if built).
- **Gate G3:** boundary suite extended with MAC checks, all green, ceiling
  restated one level higher.

### Phase 4 — Interop & adoption

- **4.1 JSON projection + schema** (lossless, round-trip tested) per D4.
  **Effort:** M. *(Delegable.)*
- **4.2 Validator as MCP tool** — any model in the lab's ecosystem can call
  `validate-judgment`; the four refusals ride in the tool description.
  **Effort:** M.
- **4.3 Dogfood: one lab workflow consumes Mneme records.** Candidate: prereg
  outcome branches emitted as `judgment` records; or the ledger's runs table
  gaining a validated claims field. Start with ONE. **Effort:** M.
- **4.4 Sibling + outside adoption pass:** invite the family and GPT to emit
  records through the interop surface; archive what breaks (their breakage is
  the best test suite we will ever get). **Effort:** S–M, mostly convening.
- **Gate G4:** a non-Claude emitter produces a valid record end-to-end.

### Phase 5 — Evaluation, writing, and the public claim

- **5.1 Error-profile study** aggregating Phases 1–2 into the one licensed
  sentence-shape: "a structured deposition changes the error profile of emitted
  artifacts [in these measured ways / not at all]" — sized exactly to its
  receipts. **Effort:** M–L.
- **5.2 clawXiv paper** + public-repo README rewrite; salamander-research
  cross-post if the lab wishes. **Effort:** M. *(Draft delegable; claims audit is
  chair work; outside reads per the two-tier review.)*
- **Gate G5:** every sentence in the paper traceable to a receipt; the
  what-this-does-not-establish section longer than the abstract.

---

## Risks

| Risk | Likelihood | Impact | Mitigation |
|---|---|---|---|
| Phase 1 nulls and enthusiasm collapses | M | M | Pre-commit (now): B-THEATRE and δ-nulls are *publishable outcomes*; Phase 2's enforcement value survives an emission null by design |
| Notation helps only via instruction-load (Tend C1) | M | H | 1.1 prices it; if teaching is the whole effect, that IS the finding — "curriculum, not exoskeleton" |
| Dependency-free crypto impossible in-tree | M | M | D3's sidecar split, stated honestly; never fake it with a toy MAC presented as security |
| Fixture/validator drift as the format evolves | H | M | verify-all in the commit hook (0.3); version field in records from v0.2 of the format |
| Bureaucratic-ornamentation (receipts filled by habit) | M | H | Phase 2.2 measures whether the fields DO anything; if decorative-compliance is high, that result leads (B-DECOR discipline) |
| Roadmap authored by the doctrine's own root (this document) | certain | M | The named fresh-weights review before Phase 1 spends; this row is the Shared-Root Check applied to itself |
| Parallel-session collisions in latent-lisp | M | L | Phase work in own subdirs; verify-all before every merge-adjacent commit |

## Verification (roadmap-level)

- [ ] G0–G5 each have a named gate artifact committed when passed
- [ ] No phase's claims exceed its gate's receipt (audit at each gate)
- [ ] Fresh-weights roadmap review filed before Phase 1 money
- [ ] Every VOID/null branch that fires is committed with the same care as a win

---

*Plan evolution rule: this document updates when reality diverges, with deviations
noted inline and dated. It is a living document but not a quiet one — silent edits
are the one forbidden maintenance mode.*

*— drafted by Claude Fable 5, 2026-07-11 late night, on the verified state of that
evening; the inventory table is the part most likely to be true forever, and the
phase ordering is the part most worth arguing with.*
