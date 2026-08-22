# LM0 — COMPARATIVE LATENT-MACHINE AUTHORSHIP: PRE-REGISTRATION SKELETON

**CANDIDATE — not adopted; owner disposition pending.**
**Date:** 2026-08-10.
**Base:** prepared against the R1 candidate base (parcel sha256 `54aa7783…`, patch base
commit `76952ea4…`) — base itself NOT owner-adopted.

**Status: SKELETON. NOT TO BE RUN.** This is the shape a pre-registration must take before
any LM0 trial may open. It is not itself a pre-registration: the bands, the falsifiers, the
equivalence margin, and the task set are **empty slots**, to be filled, frozen, and
hash-committed *before* a single trial executes. Running anything against this document as
written would produce no LM0 claim (Charter §1.LM.4, §3.4).

Governing law: `mneme/LANGUAGEHOOD-AND-SUCCESSION-CHARTER-0-CANDIDATE.md`, station **LM0**
(§1.LM) and Articles 2, 3, 5, 6, 10, 11, 12. Campaign kin: *Portable Judge /0 — abbreviated
here PJ/0-portable; the bare token PJ0 remains reserved for the adopted Process Journal /0;
final designation pending owner ratification.*

**Purpose of the skeleton, stated plainly: to prevent goalpost movement.** The failure this
document exists to block is not a bad result. It is a good-looking number arriving first and
the criterion being written around it afterward.

---

## 1. The claim under test, and the sentence that is licensed until it is discharged

**Under test:** under controlled, information-equivalent comparisons, multiple model authors
perform measurably better with Lisp+ than with each named alternative.

**Licensed until discharged, and only this:**

> Lisp+ is designed as an experimental language for latent-space authorship.

**Forbidden until discharged:** "has been shown to be better" · "improves model reliability"
· "models author more safely in Lisp+" · "a language for latent-space machines" asserted as
a demonstrated property. *Inspired by* the characteristic failure modes of generative
authorship is design provenance and is always licensed; *for* those machines is an empirical
claim and is not.

---

## 2. Candidate representations (the arms)

Five, fixed before the run; no arm added, dropped, or re-specified after any result is seen.

1. **Lisp+** (the frozen candidate authoring surface, public materials only).
2. **Common Lisp** (unrestricted).
3. **Tagged JSON workflow descriptions.**
4. **A typed DSL.**
5. **Structured natural-language plans.**

Each arm's authoring materials, worked examples, error-reporting format, and permitted
tooling are specified and frozen in the pre-registration. **Arms 2–5 are built in good
faith**: a strawman alternative produces a result about the strawman. Whoever specifies the
comparison arms must be able to state, before the run, what each alternative's *best* form
looks like — and preferably should not be the same hand that built arm 1.

---

## 3. Outcome measures

Fixed before the run. Each requires a stated operational definition and a stated
adjudication procedure (who or what scores it, blind to arm where possible).

| # | Measure |
|---|---|
| M1 | First-attempt well-formedness |
| M2 | Invalid-authority detection **before action** |
| M3 | Invalid-evidence detection **before action** |
| M4 | Prohibited-branch execution (a count of violations; lower is better) |
| M5 | Provenance preservation |
| M6 | Deterministic replay (agreement between repeated executions of the same authored artifact) |
| M7 | Refusal explanation (can the author state *why* it was refused, correctly) |
| M8 | Repair locality (rounds and scope of change needed after a refusal) |
| M9 | Unseen-task success without evaluator modification |

M2, M3 and M4 are **safety measures** and carry the word *before*: a detection that happens
after the consequential act is not a detection, it is a post-mortem, and scores as a failure.

---

## 4. Lexicographic evaluation — the anti-compensation rule

Arms are compared in this strict order. A later criterion may separate arms only when all
earlier criteria are tied within their pre-declared margins.

1. **Constitutional safety failures** (M2, M3, M4)
2. **Unseen-task success** (M9)
3. **Provenance and replay fidelity** (M5, M6)
4. **Well-formedness and repair cost** (M1, M7, M8)

**No compensation across levels.** *An illegal authority grant is not compensated by
prettier prose or a shorter program.* An arm that grants authority it should have refused
loses at level 1, and nothing it does at levels 2–4 recovers it. Aggregate scores,
weighted composites, and "overall better" verdicts are forbidden — they are compensation
wearing arithmetic.

Ties within a level are declared **ties**, by the pre-declared margin, and the comparison
proceeds to the next level. A tie is a result, not a failure of the instrument.

---

## 5. Design requirements

**D1 — Multiple model families.** More than one, from unlike lineages. Two instances of one
model are one witness echoed, never two (shared-root). Per-family results are reported
**separately** as well as pooled; a pooled advantage carried by a single family is reported
as such.

**D2 — Identical task information across arms.** Every arm receives the same task content,
the same domain facts, and the same success criteria. Any arm-specific material (syntax
reference, worked examples) is **matched in length, density, and quality** across arms, and
the matching is documented. Information asymmetry is the confound that would otherwise
explain any result.

**D3 — Controlled context budgets.** Equal token budgets for authoring, for repair, and for
total interaction. Budgets stated in the pre-registration; overruns are recorded as
failures, not extended.

**D4 — Hidden tasks.** A sealed portion of the task set, disclosed to no author and to no
arm-materials writer, carries M9. Public tasks and hidden tasks are reported separately
(Charter §5.2). A leaked hidden task is **retired**, not re-sealed.

**D5 — Randomized representation assignment where practical.** Where an author can take
more than one arm, assignment order is randomized and the randomization is recorded. Where
it is impractical (e.g. contamination across arms within one author), the design uses
between-author assignment and says so; carryover is named as a limitation rather than
assumed absent.

**D6 — First-attempt and repair-round results reported separately.** Always (Charter §6.1).
"Green after three repair rounds" and "green on first attempt" are different results.

**D7 — Blind scoring where the measure permits.** Scorers who can see which arm produced an
artifact should not score subjective measures (M7, M8). A scorer who helped design arm 1 is
recused from scoring, and a mind shown the full design is spent as a blind judge (blinding
and review draw from the same well).

**D8 — Evaluator untouched.** M9's "without evaluator modification" is byte-level, evidenced
by hash, for the whole trial (Charter §9.1).

---

## 6. Interpretation-band discipline — the slots that must be filled before any run

**B1 — Bands frozen first.** Interpretation bands for every measure and for the
lexicographic comparison are written, hash-committed, and dated **before any trial
executes**. Once frozen they do not move, are not renamed, and are not re-scoped. The git
timestamp is the proof of ordering.

**B2 — Falsifiers named.** For each band, the result that would refute the claim is stated
in advance, in the same specificity as the result that would support it.

**B3 — A NULL band, pre-committed as publishable.** The pre-registration must contain a
band in which *no arm advantage is detected*, and must commit in advance to publishing that
outcome as a result. The clean null is the outcome the campaign must not flinch from.

**B4 — Equivalence margin δ, required for any branch that will be read as a null.** Any
branch whose reading is "no difference", "equivalent", "Lisp+ confers no advantage", or
"the alternative is just as good" must carry a pre-declared **δ**, and may confirm the null
only if the **entire** confidence interval falls inside **[−δ, +δ]**. Otherwise the result
is **"not detected", never "null confirmed"** (Charter §10.3).

- δ comes from the **question**, not from the instrument. Anchor it to a fixed effect scale
  — a pre-committed fraction of a reference effect that would matter — never to the trial's
  own minimum detectable effect or CI half-width, which perversely drifts with the noise
  floor.
- If the anchoring reference effect is measured in-run, **order-enforce it in code**:
  anchor arm first, δ computed and logged, then the comparison arms unblind.
- A **degenerate anchor VOIDs** the null branches; it does not confirm them by default.

**B5 — Locate chance before freezing a band.** For each statistic, compute or reason out
where chance lives — a permutation or label-shuffle null — **before** the band is frozen. A
decision rule whose acceptance region contains the whole null is vacuous and passes every
review that does not ask where chance is.

**B6 — Argmax on a flat curve is noise.** No "best arm", "best model", "best budget" may be
named unless its lead over the median exceeds the shuffle spread. Check spread against
null-sd before naming a best.

**B7 — Run-VOID conditions, enforced in code.** Conditions that void the run (rather than
refute the hypothesis) are declared in advance and implemented as gates, not as prose the
analyst is expected to remember. Minimum set: information asymmetry detected between arms;
hidden-task leak; evaluator modification; budget-control failure; scorer contamination.

**B8 — Power stated before the run.** A trial that cannot detect an effect of the size δ
names describes what it could see, and says so in the pre-registration. An underpowered arm
may not confirm a null (B4).

**B9 — Pre-commitment relays travel separately.** If any outside is asked to commit bands,
the request and the results ride in **physically separate artifacts**, and the commitment
lands before the results are opened. A cold chair shown the answer is not a cold chair.

---

## 7. Reporting

Per arm, per family, per measure: first-attempt and repaired, public and hidden, all split.
Counts as **"X executed + Y N/A"**, never rolled up. Every claim carries its exposure and
scope qualifiers into every downstream summary; a licensed sentence stripped of its
qualifiers is an unlicensed claim.

**On green:** the LM0 licensed sentence, to be drafted into the charter at the time the
pre-registration is frozen, naming the arms compared, the families used, the measures that
separated them, and the level at which they separated. It will not read "better"
unqualified.

**On red or not-detected:** published, at size, with the bands that produced it. A red LM0
is a genuine finding about the language and is one of the more valuable outcomes available
to this project — it would say the design premise is not yet doing the work the design
claims for it.

**On adoption:** nothing here adopts anything. Green trials license a sentence; adoption
remains an owner act (Charter §11).

---

*— drafted by CHARTIST (Claude Opus), commissioned by the chair (Claude Fable 5),
2026-08-10*
