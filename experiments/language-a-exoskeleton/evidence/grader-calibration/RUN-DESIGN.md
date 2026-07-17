# RUN-DESIGN — Language-A Tranche B grader-calibration packet & runner

**Author:** LAPIDARY (Claude Opus 4.x subagent). **Coordinator:** Claude Fable 5.
**Authorization:** `owner-decision:gate-walk-r12-adopted-v1` (decision id **GATE-WALK-R12**;
record digest `sha256:fe03e898144ddc57721edc51ac074413dec27131840ec6af0ad0bc1c62035f3f`;
controlling authority `sha256:55f0c6d93cfab0a026861f266aa258fa0a7c27f6df2dd4afeb4817f062032379`).
**Scope of this artifact:** synthetic-only calibration packet + runner, **pre-live**. No provider
was contacted; no live scoring performed; the runner is delivered ready but un-fired.

This document names every INTERPRETATION as an interpretation. It is written so a hostile
auditor can challenge each load-bearing step rather than take a claim on trust.

---

## 0. What was built (add-files-only, all under `evidence/grader-calibration/`)

| Path | What |
|---|---|
| `packet/EXAMPLE-01..32.json` | 32 rater-visible synthetic calibration examples (source + task + response + Cβ-shaped key). |
| `packet/ground-truth/EXAMPLE-*.gt.json` | Author-only planted-defect ledgers. **Never** assembled into rater-visible material. |
| `tooling/author_packet.py` | Deterministic authoring script — the single reviewable home of the genuine prose. |
| `tooling/run_calibration.py` | The calibration runner (dry-run + live). |
| `tooling/build_manifest.py` | Builds the freeze manifest + sidecar. |
| `PACKET-FREEZE-MANIFEST.json` / `.sha256` | Freeze manifest (path, bytes, SHA-256 per packet file) + digest sidecar. |
| `dry-run/` | Offline dry-run outputs + `DRY-RUN-SUMMARY.json` (PASS). |
| `RUN-DESIGN.md` | This file. |
| `raw/`, `READ-LINEAGE.jsonl`, `FIRST-PASSES.jsonl`, … | Created at **live** run time by the firing agent (default `--out-dir` = calibration root). |

No file outside `evidence/grader-calibration/` was created or modified. `items/`, `tranche-b/`,
`harness/`, frozen manifests, and the Cβ key were not touched or read for content. `harness/firebreak.py`
is imported **read-only**.

---

## 1. Interpretations (named as interpretations)

**(a) "Frozen packet" = authored-then-frozen-before-any-rater-exposure.** Per the WORK-DOCKET
§6.2 ordering (ODR-55: seal the synthetic-only corpus *before graders see it*), the packet is
authored here and frozen by the manifest **prior to any rater call**. No calibration corpus
predated this run: `controls/synthetic-items.jsonl` is a **prompts-only plumbing corpus**
(one-line `synthetic_prompt` strings, no source packet / no key / no scorable opportunities), a
*candidate* named in the handoff but never a scorable calibration packet. It was **not** used as
a source and **not** read for content. This packet is authored fresh, synthetic, permanently
tainted.

**(b) "Categorical agreement" = exact integer-count match per dimension per example.** For each
primary defect family and each example, the two first-pass integer counts match or they do not;
agreement = (# exact matches) / (# analyzable examples). No binning, no tolerance.

**(c) "Cohen's kappa on count-categories."** The integer defect counts are treated as unordered
categories; κ uses the standard two-rater single-item-per-subject formula
`κ = (p_o − p_e)/(1 − p_e)`, `p_e = Σ_c p_a(c)·p_b(c)`. All exact rational.

**(d) Adjudication-packet definition.** The adjudicator receives EXACTLY: the rater-visible
material (§2 surface) + the disputed dimension name(s) + the two first-pass values labelled
`RATER-A` / `RATER-B` **anonymously** (no rater identity, no other dimension's dispute, no
ground truth, no provenance). It is called ONLY for locked `|a−b| > 1` disagreements. Its value
**replaces** the banked value; the two first-pass records are retained immutably in
`ADJUDICATIONS.jsonl` + `FIRST-PASSES.jsonl`.

**(e) Reliability on FIRST PASSES ONLY.** Agreement, κ, and AC1 are computed from the two
first-pass integer vectors. Adjudication resolves *banked* values but never enters the
reliability computation. Enforced in `compute_family_reliability` (fed only `FIRST-PASSES.jsonl`)
and asserted in the dry-run (`e2e_reliability_first_pass_only`: EXAMPLE-20's residue_erasures
first-pass pair `(4,2)` still lowers RE agreement to 31/32 even though its banked value was
adjudicated).

**(f) Primary defect family = the four §4 burden dimensions.** `unsupported_assertions`,
`scope_errors`, `version_errors`, `residue_erasures`. Their construct definitions are restated
to raters **verbatim** from SCORING-CONSTITUTION §4 (`CONSTRUCT_DEFS` in the runner). The
anti-taxidermy secondary profile is out of scope for calibration reliability (owner-gated).

---

## K. The kappa-undefined interpretation (load-bearing; the one an auditor should press)

The owner rule (`kappa-undefined-replacement-rule`,
`owner-decision:scoring-r1-adopted-v1`) is: when Cohen's κ is undefined → require agreement
≥ 0.80 **and** Gwet's AC1 ≥ 0.60 on the same items; if AC1 is uncomputable → the family is
calibration-**INCONCLUSIVE**.

**The subtlety, stated plainly.** Under exact integer-count categories, Cohen's κ has a zero
denominator (`1 − p_e = 0`, i.e. `p_e = 1`) **iff** a single category is observed across both
raters over all items — and that same single-category condition ALSO makes Gwet's AC1
uncomputable (its `1/(q−1)` term divides by zero when `q = 1`). If "κ undefined" meant *only*
the strict `p_e = 1` case, the owner's "κ undefined **AND** AC1 ≥ 0.60" branch would be
**structurally unreachable** — κ-undefined would always coincide with AC1-uncomputable and route
straight to INCONCLUSIVE.

**The decision (documented, challengeable).** To make the owner's AC1 branch reachable at the
operating point it was written for, this runner treats κ as **UNDEFINED under the standard
DEGENERATE-MARGINAL condition**: *either rater used exactly one category across all items (zero
marginal variance), OR `p_e = 1`.* This is precisely the condition under which Cohen's κ is known
to be uninformative / paradoxical, and precisely the condition Gwet's AC1 was designed to
replace. Under this reading:

- **κ undefined, `q ≥ 2` (one rater degenerate, the other not):** AC1 is computable → apply the
  owner rule (agreement ≥ 0.80 AND AC1 ≥ 0.60). *Proof-c in the dry-run exercises exactly this.*
- **`q < 2` (single category across both raters, all items):** AC1 uncomputable →
  family INCONCLUSIVE. *Proof-c-bonus in the dry-run exercises this.*

If the owner prefers the strict `p_e = 1` reading of "undefined," the only behavioural change is
that degenerate-single-rater families route to AC1 vs. to raw-κ; flip the `kappa_undefined`
predicate in `compute_family_reliability`. The interpretation is isolated to one boolean so it is
trivially reversible by owner ruling.

---

## 2. Blind boundary & guards (enforced in code, not prose)

- **Rater-visible material = SCORING-CONSTITUTION §2 surface, exactly**: response artifact +
  source packet + arm-neutral task statement + the key's per-opportunity relations
  (`answerable_requirement` + `minimum_discharge_relation`). `project_rater_visible()` strips
  everything else (example_id provenance, domain, ground truth, the other rater's scores).
- **The key states the STANDARD, not the verdict.** Each opportunity's `minimum_discharge_relation`
  describes what discharging that opportunity *requires* (and which construct is charged if the
  requirement is unmet). It does **not** tell the rater what the response did. The planted verdict
  lives only in `packet/ground-truth/`. This is why raters genuinely grade.
- **Blind assignment handles.** Prompts carry `ASG-<hash>` handles, never `example_id`. The
  handle→example map is written author-side to `ASSIGNMENT-MAP.json` (never in a prompt).
- **`guarded_read()`** asserts every prompt-assembly read is inside `packet/` and NOT inside
  `packet/ground-truth/`, and logs it to `READ-LINEAGE.jsonl` (reader, artifact, purpose,
  sha256). Teeth-checked: `teeth_guarded_read_refuses_ground_truth`.
- **Firebreak wiring.** `harness/firebreak.py:validate_grader_firebreak` runs over the read log;
  all packet artifacts declare `artifact_kind = "synthetic-calibration-example"`. Teeth-checked:
  `teeth_firebreak_fires_on_forbidden_kind` (a `target-item` read by a primary grader RAISES).
- **Network.** ZERO network in dry-run. The live OpenRouter path (`LiveOpenRouterProvider`) is
  never entered by dry-run; `urllib` is imported lazily inside the live method.

---

## 3. Disagreement, banking, retries, census (SCORING-CONSTITUTION §4/§3)

- Per dimension per example: `|a−b| > 1` → adjudication REQUIRED; `|a−b| = 1` → banked = exact
  mean (Fraction, no rounding); `a = b` → banked. (`bank_dimension`.)
- Adjudication REPLACES the banked value; first passes retained immutably.
- **Retry ceiling = 2** retries per call, then the call is `CENSUS`; an example with any
  censused first-pass/adjudication call is `UNANALYZABLE-CENSUS` (never silently dropped). Every
  attempt — including failures — writes a NEW raw envelope; nothing is overwritten.
- Raw envelopes (request minus API key + full response) land in `raw/`.

## 4. Numeric law (SCORING-CONSTITUTION §7)

All reliability arithmetic is exact rational (`fractions.Fraction`). Canonical serialization is a
6-fractional-digit decimal STRING, ROUND_HALF_EVEN, `-0.000000` → `0.000000`; exact num/den kept
beside each decimal. **Threshold comparisons (≥0.80, ≥0.60) are on the exact rationals**, never on
the quantized decimals.

---

## 5. Cast, barred actors, authorization chain

- **First-pass raters (blind):** bare GPT-family instance + bare GLM-family instance, API-only,
  packet-only, no lab context, no persona (`role-assignments`,
  `owner-decision:scoring-r4-adopted-v1`).
- **Adjudicator:** bare DeepSeek-family instance, packet-only, only after a locked disagreement;
  no self-adjudication; no authorship of items/prompts/rendering/rubric/key.
- **Barred from rating/adjudication:** `actor:fable-item-author`, `actor:sol-item-author`. **I
  (Opus, LAPIDARY) am the packet AUTHOR, which is lawful** — authors may author; authors may not
  rate. I did not rate.
- **Model IDs are CLI parameters** (`--rater-a-model`, `--rater-b-model`, `--adjudicator-model`).
  The firing agent pins exact OpenRouter IDs after live verification. Route: **OpenRouter**
  (GATE-WALK-R12).
- **Authorization chain:** `owner-decision:scoring-r1..r7` (slots) → `SCORING-R6-CLOSED-v2`
  (census/cost) → **GATE-WALK-R12** (this run authorized: synthetic-only, OpenRouter, evidence
  landing `evidence/grader-calibration/`, zero real-item bytes egress, cost well under USD 1,
  synthetic-only guard enforced in code, pre-exposure gate remains UNSIGNED).

## 6. Cost estimate

Calibration = at most `32 examples × 2 first-pass raters + (adjudications) ≤ ~70` completions,
each a small prompt (a few hundred tokens in, ≤ ~1k tokens out at `max_tokens=1024`,
temperature 0). At commodity OpenRouter rates for GPT-/GLM-/DeepSeek-family instances this is on
the order of **~$0.02–0.20 total** — **well under the USD 1** bound of GATE-WALK-R12 (itself
bounded by the SCORING-R6 census). This is an estimate; the run records actual usage from the
live envelopes.

## 7. Exact commands the firing agent must run

```sh
cd /path/to/experiments/language-a-exoskeleton
# 1) (idempotent) regenerate the packet + confirm coverage — byte-identical to the frozen files:
python3 evidence/grader-calibration/tooling/author_packet.py
# 2) verify the freeze manifest still matches on disk:
python3 evidence/grader-calibration/tooling/build_manifest.py --verify
# 3) re-run the offline dry-run — must print "overall": "PASS":
python3 evidence/grader-calibration/tooling/run_calibration.py --dry-run
# 4) LIVE (only after the coordinator commits the freeze). Pin exact OpenRouter IDs after
#    verifying them live; set the key; then:
export OPENROUTER_API_KEY=...            # never committed, never logged into raw envelopes
python3 evidence/grader-calibration/tooling/run_calibration.py \
    --rater-a-model <exact-GPT-family-openrouter-id> \
    --rater-b-model <exact-GLM-family-openrouter-id> \
    --adjudicator-model <exact-DeepSeek-family-openrouter-id>
# Outputs land under evidence/grader-calibration/: raw/, READ-LINEAGE.jsonl, FIRST-PASSES.jsonl,
# ADJUDICATIONS.jsonl, BANKED-SCORES.jsonl, CALIBRATION-REPORT.json. The runner is restartable:
# re-invoking skips completed calls (append-only ledgers).
```

**STOP conditions the firing agent must honor:** no real-item provider contact, no live target
scoring, no key-content exposure, no merge — the pre-exposure gate remains UNSIGNED
(GATE-WALK-R12). This run walks checklist line **L8** (grader reliability) to TRUE **or fails
honestly**: if any family lands NOT-ELIGIBLE or INCONCLUSIVE, that is the honest calibration
outcome and scoring on that family is blocked per the constitution.

---

## 8. What this packet CANNOT prove (deposition honesty)

- It cannot prove the **live** raters will meet the floors — the frozen floors are walked to TRUE
  or fail honestly at run time; the dry-run proves the *machinery*, using sham raters seeded from
  ground truth, not the real graders' agreement.
- The dry-run's ELIGIBLE verdict is a property of the **sham** oracle (near-perfect planted-signal
  recovery), NOT evidence about any real model's reliability.
- It cannot prove that a hostile grader with filesystem access could not read the packet outside
  the guarded path — the guard binds *this runner's* prompt assembly; run-time actor isolation
  (bare API instances, packet-only) is the cast's responsibility and the owner's freezer audit.
- The kappa-undefined interpretation (§K) is an authored reading of the owner rule, reversible by
  owner ruling; it is not an owner-frozen definition.
