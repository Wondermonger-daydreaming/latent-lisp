# SCORING CONSTITUTION — Language-A Tranche B (v1.0.0)

Schema identity: `lae-scoring-constitution/1.0.0`.
Status: complete as law; **scoring-eligibility REFUSES while any owner slot is unresolved**
(§15). This constitution authorizes no live scoring, no provider calls, no exposure.

## 0. Binding to the frozen bank and schedule

This constitution binds exclusively to:

- Frozen-bank commit `404a66a51c314e03ee50965411fd9f86192f846c`,
  tree `3694dae0d136662056b144874a3b51ecf82dfb0a`,
  freeze manifest SHA-256 `a286b6082e4ac5089ad33e1edd9774d2a46c99207b343f29767eacf57eeb4d90`.
- The authoritative 312-row schedule (`tranche-b/schedule.jsonl`, blob
  `ab0bb6d89ea32988b2f9245cc6b578245a979823`; schedule-row digest list
  `fee2d49c3ea3c8edcfc8081c1030cb5201342c2a540cf3c38320851e1558d665`; request-parent binding
  list `a98472c9ae08d1f025b3fcd87b27e5106901e2ea5644e146cc72a2694f8738f4`).
- The frozen margins (delta 0.10, epsilon 0.05, harm 0.10, family interaction 0.15), arms
  (NL, PERSONA, SCAFFOLD, LANG-A, SHAM), contrasts (D_N = LANG-A−SCAFFOLD, D_S =
  SCAFFOLD−PERSONA, D_P = PERSONA−NL), and the six-branch bank with precedence
  B-HARM, B-INTERACTION, B-NOTATION, B-SCAFFOLD, B-NULL, B-INCONCLUSIVE (BRANCH-BANK.md;
  `harness/analyze.py` is the single point of predicate encoding — this constitution
  REFERENCES those predicates and forbids re-encoding them elsewhere).

A score produced against any other bank identity, schedule, margin set, or predicate
encoding is void ab initio. Verification MUST recompute these identities before accepting
any score record.

## 1. Scoring unit — the five levels and the substitution ban

| Level | Unit | Record schema | Key |
|---|---|---|---|
| L0 | request/response envelope | `lae-envelope-disposition/1.0.0` | `call_id` |
| L1 | item-level result (cell = item × subject-slot × arm) | `lae-cell-score/1.0.0` | `(item_id, subject_slot, arm)` |
| L2 | condition-level result (per-contrast paired differences) | `lae-contrast-estimate/1.0.0` | contrast name |
| L3 | subject-level result (fixed stratum report) | `lae-stratum-report/1.0.0` | `subject_slot` |
| L4 | tranche-level result (branch receipt) | `lae-branch-receipt/1.0.0` | tranche id |

Relationships: every L1 derives from exactly one L0 chain (the schedule row's attempt
chain); every L2 derives from the complete set of L1 cells for its two arms; L3 is a fixed
stratum view of L1 (subjects are never sampled as a population); L4 derives from all L2
estimates plus the integrity/census record.

**Substitution ban.** Every record carries a mandatory `level` field. No record at one
level may stand in for a record at another. Specifically prohibited: reporting a pooled
(L2-secondary) estimate where the paired-cell (L2-primary) estimate is required; reporting
an L3 stratum as if it were an L4 disposition; treating an L0 disposition as an L1 score.
The validator rejects any aggregation whose input records' `level` fields do not match the
formula's declared input level.

## 2. Blind scoring boundary

**A scorer (human or text-sensitive automated component) may inspect exactly:**

1. the locked response artifact for the assignment (normalized view and native view,
   §5 — both derived from `raw_response_sha256`-anchored bytes);
2. the exact versioned source packet corresponding to the locked response's item version;
3. the arm-neutral task statement (the F1 target-visible surface).

**Concealed from scorers until unblinding (the concealment set):** provider identity and
`model_id_*`; arm/condition identity; `subject_slot`; `schedule_index` and any ordering
information; all hidden-control-plane metadata (family, `answerability_role`, tags, trap
class, expected direction, owner dispositions); ancestry and exposure history; usage,
latency, and cost fields; all other responses; all first-pass scores of the other rater
(until both passes lock); validator findings.

Mechanical components that never emit content judgments (envelope classifier §4, census,
identity verification) may read concealed fields but write only into records whose blinded
projections (§10) exclude them.

**Deterministic unblinding.** Unblinding becomes authorized only after: (a) both blind
first passes for every scoreable assignment are locked (append-only, digest-chained);
(b) every adjudication triggered under §5 is locked; (c) the blinding-audit record passes
(no scorer read access to concealed fields — enforced by the assignment-packet builder,
which is the only component that may assemble scorer-visible material). Unblinding is a
single logged event: the unblinding record lists the digests of every locked score record
it reveals labels for. Scores created or altered after unblinding are void; only
predeclared exploratory analyses may follow, marked per §8.

**Grader spoilage (from PREREG).** A primary grader exposed prematurely to a target item,
packet, rendering, paraphrase, trap class, opportunity key, keyed disposition, or
target-derived calibration is disqualified from the affected blind panel; any output is
retained as exploratory only. Each versioned source-packet read at the permitted scoring
event is logged.

## 3. Response-state taxonomy — total classification, predetermined dispositions

Input: the L0 envelope pair (frozen `request_schema.json` + `response_schema.json`
instances) plus raw response bytes. The classifier is TOTAL: its final branch is
`QUARANTINE-INTEGRITY` with mandatory authority return — no state falls through to ad hoc
judgment. Classification order is fixed (first match wins):

| # | State | Detection (mechanical) | Disposition | Denominator | Census class |
|---|---|---|---|---|---|
| T01 | malformed envelope | request or response fails frozen schema validation | `UNANALYZABLE-CENSUS` | cell retained in all denominators as unanalyzable | experimenter/integrity |
| T02 | encoding failure | response bytes not valid UTF-8 after declared transcoding | `UNANALYZABLE-CENSUS` | retained | provider-caused |
| T03 | duplicate response | second response envelope bound to one `(call_id, attempt)` | `QUARANTINE-INTEGRITY` (all envelopes of the cell) | retained as quarantined | integrity |
| T04 | replayed response | `raw_response_sha256` identical to another call's response | `QUARANTINE-INTEGRITY` (both cells) | retained as quarantined | integrity |
| T05 | transport failure | `status = transport-failure` | `UNANALYZABLE-CENSUS` after the frozen retry ceiling (32 tranche-wide; every retry a new linked attempt) | retained | provider-caused |
| T06 | provider error | provider-signalled error envelope (anomalies) with no content | `UNANALYZABLE-CENSUS` (same retry law as T05) | retained | provider-caused |
| T07 | timeout | transport-failure with timeout anomaly | as T05 | retained | provider-caused |
| T08 | unexpected tool/structured output | tool-call or non-text structured payload present | `QUARANTINE-INTEGRITY` (arms authorize no tools) | retained | integrity |
| T09 | safety refusal | `status = refused` with safety-classified refusal text (rule-based lexicon, frozen in implementation) | `SCORE-ZERO-DISCHARGE` + `safety_refusal` flag | full fixed denominator | analyzable |
| T10 | refusal | `status = refused` otherwise | `SCORE-ZERO-DISCHARGE` + `refusal` flag | full fixed denominator | analyzable |
| T11 | empty response | `status = completed`, zero content units after normalization | `SCORE-ZERO-DISCHARGE` (total omission) | full fixed denominator | analyzable |
| T12 | truncated response | `status = truncated` or `finish_reason = length` | `SCORE` on emitted content + `truncation` flag | full fixed denominator | analyzable |
| T13 | unparseable under scoring rules | valid envelope, content no rater can segment under §4's evidence rules (both raters so mark, adjudicated) | `SCORE-ZERO-DISCHARGE` + `unparseable` flag | full fixed denominator | analyzable |
| T14 | valid partial response | ≥1 but not all opportunities discharged | `SCORE` | full fixed denominator | analyzable |
| T15 | valid complete response | all opportunities discharged | `SCORE` | full fixed denominator | analyzable |
| T99 | anything else | — | `QUARANTINE-INTEGRITY` + authority return | retained | integrity |

Law carried from PREREG: **refusal, omission, truncation, and failure to instantiate an
opportunity never shrink the denominator.** `SCORE-ZERO-DISCHARGE` states are scored
records (burden numerator counts undischarged required content per the key's omission
relations; anti-taxidermy profile applies), not exclusions. No disposition ever deletes a
cell: T01–T08 cells remain visible in the failure census and in every analyzability
denominator.

## 4. Rubric

**Primary dimensions (the burden components).** For each of the four:
construct = the keyed defect; evidence permitted = the locked artifact plus the exact
source packet plus the Cβ key's per-opportunity relations; evidence prohibited = provider
identity, arm, hidden metadata, other responses, validator findings, anything concealed
under §2; scale = count (non-negative integer) per response, summed over the key's
opportunities; type = count (ratio scale).

| Dimension | Construct |
|---|---|
| `unsupported_assertions` | assertion not discharged by the finite source under the key's support relation |
| `scope_errors` | claim exceeding or misstating the key's scope boundaries |
| `version_errors` | claim contradicting the key's version/source-identity constraints |
| `residue_erasures` | genuinely-unresolved content (per key) presented as resolved, or deleted where the key requires surfacing |

**Per-call burden** = (sum of the four counts) / `scorable_opportunities` (the key's fixed
positive-integer denominator). The quotient is computed as an exact rational; it is not
capped at 1 (multiple defects per opportunity are possible and remain visible).

**Anti-taxidermy secondary profile** (non-compensating; never aggregated into a scalar
gate): `unnecessary_abstention`, `excessive_qualification`, `omitted_supported_conclusion`,
`procedural_caveat_substitution` (counts); `completeness` = emitted materially-answerable
units / key's answerable units (exact rational in [0,1]); flags `refusal`, `abstention`,
`truncation`, `over_bounding`, `safety_refusal`, `unparseable`; coupled-defect boolean per
the frozen `score.py` gutted-law. Numeric gate values over this profile are OWNER SLOTS
(§15) — the profile is always computed and reported; gates evaluate only when their slot
is resolved.

**`answer_utility` and `inspectability`** are typed slots (owner slot B3 / `utility-scale`):
recorded as `null` with `"slot": "unresolved"` until the owner freezes scale, direction,
comparator, and aggregation. No component may substitute a proxy.

**Boundary and tie law.** Every count is anchored to the key's opportunity records:
mixed evidence within one opportunity resolves by the key's minimum-discharge relation
(discharged / partially-discharged-with-defect / undischarged — the key is the sole
authority; raters do not invent categories). Ambiguity between two categories that the key
does not resolve is scored in BOTH raters' passes independently; disagreement law then
applies. Boundary examples and non-examples are frozen as fixtures
(`controls/scoring-constitution-fixtures/`, §12) including exact-threshold, one-unit-below,
and one-unit-above vectors for every branch predicate.

**Disagreement law (constitution-fixed).** For each dimension on each assignment:
|a−b| > 1 → adjudication (mandatory, §5). |a−b| = 1 → banked value = exact mean
(rational; no rounding). a = b → banked. Adjudication REPLACES the banked value and both
first-pass records are retained immutably in the adjudication lineage.

## 5. Automated and human scoring

- **Fully mechanical (no text judgment):** identity verification (§0), envelope
  classification (§3), census and denominators, blinding audit, aggregation (§7), branch
  selection (via the single frozen predicate encoding), serialization (§7), slot gating (§15).
- **Rule-based but text-sensitive (deterministic code over text):** normalization to the
  content-normalized view (hash-successored, raw bytes immutable); uptake detection for
  SCAFFOLD/LANG-A (validator profile); safety-refusal lexicon (T09); content-unit
  segmentation for `completeness`.
- **Independently human-rated:** the four burden counts, the anti-taxidermy counts, T13
  unparseability marks — two blind first passes per assignment, raters independent (no
  communication until both lock; enforced by locked submission digests).
- **Adjudicated after disagreement:** trigger = |a−b| > 1 on any dimension, or conflicting
  T13 marks, or any rater integrity flag. Adjudicator: fresh chair per PREREG preference
  order; no self-adjudication; no authorship of items/prompts/rendering/rubric/key; sees
  the exact adjudication packet only. Adjudication replaces the banked value and appends to
  lineage; it never deletes first-pass records.
- **Rater count:** two first-pass raters + one adjudicator per disagreement. Rater
  identities/overlaps are owner slot B9; calibration floors are frozen from PREREG
  (categorical agreement ≥ 0.80 AND Cohen's kappa ≥ 0.60 per primary defect family, on
  synthetic permanently-tainted calibration examples only). The kappa-undefined replacement
  rule is owner slot `kappa-undefined-replacement-rule` (§15) — calibration REFUSES when
  kappa is undefined and the slot is unresolved.

## 6. Missingness and exclusions

- **Structural:** cells never scheduled (e.g., SHAM outside its 8-item subset) — not
  missing; excluded from all denominators by schedule authority alone.
- **Provider-caused:** T02/T05/T06/T07 after the retry law — unanalyzable, retained in
  denominators, complete failure census mandatory.
- **Experimenter-caused:** T01, quarantines (T03/T04/T08/T99), grader spoilage — retained,
  census-classed, integrity-logged; never reclassified as provider-caused.
- **Invalid-response exclusion:** THERE IS NONE at the analysis level — invalid responses
  are unanalyzable cells, visible in every denominator (analyzability = analyzable cells /
  312 scheduled; per-stratum analogues likewise).
- **Post-hoc exclusion prohibition:** after unblinding, no cell, envelope, or score may be
  excluded, reweighted, or reclassified except through an append-only deviation record that
  names the actor, the cause, and the affected digests — and such a deviation can only move
  results toward B-INCONCLUSIVE, never toward a substantive branch.
- **Denominator law (fixed before exposure):** the 312 scheduled cells are the permanent
  frame. Paired contrasts use complete pairs only; every incomplete pair is enumerated in
  the receipt; the missing/unanalyzable-pair inclusion rule and its inconclusive threshold
  are owner slot B7, and census floors (≥90% overall analyzability, ≥80% per core
  arm×subject×family stratum) gate branch banking per the frozen rulings. An observed arm
  never substitutes for a missing partner.

## 7. Aggregation

- **Repeated cells:** the schedule authorizes exactly one attempt chain per cell; a second
  scored response for a cell is T03 quarantine — there is no averaging over repeats.
- **Primary estimand per contrast:** unweighted mean of paired per-cell burden differences
  across item×subject cells (equal cell weight regardless of opportunity count).
- **Secondary:** pooled opportunity-weighted contrast; must show numerator and denominator;
  cannot bank a branch; retained when it diverges.
- **Weights:** no item, condition, or model weighting exists anywhere; subjects are fixed
  strata reported per-stratum (L3), never pooled as a random population.
- **Unequal completion / missing cells:** §6 law; incomplete pairs never imputed.
- **Interval estimates:** fixed-seed nonparametric bootstrap exactly as encoded once in the
  frozen `analyze.py`: items resampled with replacement within frozen family; all subject
  and arm observations retained per sampled item; subjects never resampled; opportunities
  never resampled. **Seed = 1729, iterations = 800** — adopted openly by this constitution
  from the construction defaults (recorded in `operator/scoring-owner-slots.json` as
  `bootstrap-parameters: resolved-by-constitution`, disclosure §16). Sign/randomization
  tests, if run, preserve the same clustering.
- **Ties:** branch predicates use closed inequalities exactly as frozen; branch selection
  ties are impossible by precedence (first satisfied predicate in fixed order banks).
- **Multiplicity:** the design banks exactly one branch via one ordered predicate pass —
  no familywise correction applies to branch selection; secondary/exploratory estimates
  carry no inferential claims, so no FDR machinery is defined.
- **Numeric law (canonical decimal serialization — constitution-defined per commission
  surface 7 and task-list Eβ):** all burden values, differences, estimates, and interval
  endpoints are computed in exact rational arithmetic (integer numerators/denominators);
  canonical records serialize every such quantity as a decimal STRING quantized to 6
  fractional digits, ROUND_HALF_EVEN, with explicit `"-0.000000"` forbidden (normalized to
  `"0.000000"`). Raw Python float repr is prohibited in every canonical scoring record.
  Exact rationals (num/den integers) accompany the decimal string wherever a threshold
  comparison is made, and THRESHOLD COMPARISONS ARE PERFORMED ON THE EXACT RATIONALS,
  never on the quantized decimals.

## 8. Primary and secondary outcomes

- **Primary outcome:** per-call burden. **Primary contrast:** D_N = LANG-A − SCAFFOLD
  (negative differences better).
- **Supporting contrasts:** D_S = SCAFFOLD − PERSONA, D_P = PERSONA − NL.
- **Diagnostic:** SHAM descriptive contrasts on its predeclared 8-item subset under its
  frozen tri-status law (SHAM-DISENGAGED / SHAM-OPERATIVE / SHAM-VALID); SHAM can never
  bank, rescue, or overturn.
- **Secondary:** component defect counts; unresolved-residue survival; trap catch; answer
  utility (slot-gated); inspectability (slot-gated); LANG-A validator profile; decorative
  compliance; refusal/deletion/truncation/abstention/completeness/over-bounding/
  positive-conclusion defects; token, latency, cost; predeclared family and subject
  interactions.
- **Exploratory:** anything else — mandatory `"exploratory": true` marking, excluded from
  receipts' claim surface; promotion after exposure requires an append-only deviation
  record and can never bank a branch.

## 9. Decision rules

The six-branch bank is the complete and only interpretation law (predicates encoded once,
in the frozen `analyze.py`; margins immutable):

- **Support:** B-NOTATION (D_N 95% interval wholly ≤ −delta, no frozen harm gate, core
  checks) — Language-A form reduces burden. B-SCAFFOLD (D_S wholly ≤ −delta AND D_N wholly
  within ±epsilon, no harm) — structure, not notation, carries the effect.
- **Partial support / structured heterogeneity:** B-INTERACTION (family range > 0.15 with
  two opposite-sign family intervals excluding zero).
- **Null:** B-NULL (all three contrasts wholly within ±epsilon, adequate census, checks).
- **Contradiction/harm:** B-HARM (a burden interval wholly ≥ harm, or a frozen
  anti-taxidermy harm gate) — precedence-first, cannot be hidden by aggregate benefit.
- **Assay failure / insufficient coverage:** B-INCONCLUSIVE with mandatory reason codes
  (inadequate precision, failed manipulation — including SCAFFOLD/LANG-A uptake below the
  frozen 70%/50% floors, inadequate census, unmatched predicates, limiting lineage/scoring
  evidence — including unresolved owner slots at scoring time, calibration failure,
  quarantine load).
- **No default-positive:** the fall-through is B-INCONCLUSIVE; integrity failures are
  quarantine/cancellation/inconclusive matters, never substantive harm; no desired result
  is encoded as a default.

## 10. Provenance

Every score record retains: frozen item id + version; schedule-row digest (from the frozen
312-row digest list); response-envelope digest (`raw_response_sha256` + envelope record
digest); constitution version (`lae-scoring-constitution/1.0.0`) and rubric hash (this
file's SHA-256); scorer pseudonym (blind-stable, mapping held freezer-side until
unblinding); scoring implementation identity (module file SHA-256s + commit); scoring
timestamp; adjudication lineage (digest chain of first passes and adjudications);
deviation/exception record references. Blinded fields appear in committed records only as
salted digests (salt freezer-held) until the unblinding event; the blinded projection of
every record is deterministic and testable.

## 11. Deterministic implementation

`harness/scoring_constitution.py` implements: canonical input schema
(`lae-scoring-input/1.0.0`: envelope pair + key-excerpt + rater passes), canonical output
schemas (§1 table), the total classifier (§3), disagreement/adjudication law (§4/§5),
census/denominator law (§6), decimal canonicalization (§7), slot gating (§15), provenance
validation (§10), and blinded projections (§2/§10). Aggregation and branch selection are
NOT re-implemented: the module validates inputs and delegates to the frozen `analyze.py`
encoding (single-point predicate law), then validates and canonically re-serializes its
receipt. `harness/freeze_scoring_constitution.py` (patterned on `freeze_tranche_b.py`)
derives and verifies the scoring-constitution freeze manifest with tamper self-tests.
Fixtures, positive vectors, adversarial vectors, negative controls, and mutation controls:
§12. All verification is network-off and deterministic.

## 12. Synthetic validation

Validation uses ONLY synthetic, authored fixtures under
`controls/scoring-constitution-fixtures/` (schema-marked `synthetic_only: true`), authored
without inspecting any live pilot response (none exists; this branch's runner has no live
provider). Mandatory coverage: exact-threshold cases for every branch predicate;
one-unit-below and one-unit-above; ambiguous and mixed-evidence rater cases; empty,
malformed, encoding-failed envelopes; refusals (plain + safety); duplicated and replayed
envelopes; missing cells and incomplete pairs; altered provenance; swapped condition
labels (blind-boundary catch); scorer disagreement at |a−b| = 1, = 2; attempted post-hoc
exclusion; aggregate denominator corruption; zero-discharge states; truncation. Each rule
boundary has at least one fixture that PASSES and one adversarial vector that must be
KILLED. The mutation registry (`controls/scoring-constitution-mutations.json`) executes
under expect-failure semantics: a surviving mutation or a wrong-condition kill fails the
suite.

## 13. Freeze record

`evidence/scoring-constitution-freeze/SCORING-FREEZE-MANIFEST.json` (append-only; with
`.sha256` sidecar and `FREEZE-VERIFICATION.json`) records: the controlling frozen-bank
commit/tree/manifest digest (§0 verbatim); the scoring artifact inventory with exact byte
counts and SHA-256 digests; schema identities; fixture identities; the mutation inventory;
aggregate canonical identities; implementation commit and tree; authorization boundaries
(no live scoring, no provider calls, no key authorship, no exposure, no merge); the
explicit statement that **no live response was inspected** (and that none exists); and the
unresolved owner-slot inventory at freeze time.

## 14. Scope

This work adds files only. It does not modify: the 19 frozen bank artifacts; candidate
items; templates; the 312-cell schedule; request-parent bindings; protected semantic
scope; any existing freeze evidence (referenced append-only from §13's record). Published
only on `codex/language-a-tranche-b-scoring-constitution`. Not merged to main.

## 15. Owner-slot register (scoring-facing) and the refusal gate

`operator/scoring-owner-slots.json` (NEW file; the original `operator/owner-slots.json` is
untouched) registers the scoring-facing slots. Inherited unresolved (bind by reference):
B1–B7 anti-taxidermy numeric gates; B3/utility scale; B9 role assignments; B10 subjects;
B11 price table; B12 real bank/score key (the Cβ key must supply, per item: positive-int
`scorable_opportunities`, per-opportunity minimum-discharge relations, and the keyed
decomposition required-answerable / necessary-qualification / genuinely-unresolved /
optional-exposition — this constitution fixes that CONTRACT; the values are Cβ's). Newly
registered here: `kappa-undefined-replacement-rule` (owner-owed; PREREG requires an
owner-frozen rule; calibration refuses while unresolved); `bootstrap-parameters`
(RESOLVED-BY-CONSTITUTION: seed 1729, iterations 800 — §7 disclosure).
**The refusal gate:** `scoring-eligibility` is a mechanical predicate that REFUSES while
any scoring-facing slot is unresolved, and exposure-readiness (frozen law) independently
refuses. No placeholder, TBD, or open interval counts as resolution.

## 16. Disclosures

- Bootstrap seed/iterations adopted by the constitution from construction defaults —
  an arbitrary determinism constant fixed pre-exposure with no data observed; NOT an
  owner threshold. Recorded as resolved-by-constitution, reversible only by owner ruling
  before exposure.
- The disagreement tie rule (§4: mean at |a−b| = 1) and the decimal quantization law (§7)
  are constitution-fixed procedure, within the commissioned surfaces.
- No live or pilot-produced model response was inspected at any point in this work; none
  exists in the repository or was available to its authors.

*Authored by Claude Fable 5 under the owner authorization of 2026-07-16 (scoring-system
design and pre-exposure validation only), from the determination map of the frozen
authorial materials (PREREG-v0.2, FREEZE-RULINGS, BRANCH-BANK, design.json, owner-slots,
master task list 0.2, REPAIR-0.2 basis).*
