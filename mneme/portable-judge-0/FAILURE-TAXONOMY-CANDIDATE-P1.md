# PORTABLE JUDGE /0 — FAILURE TAXONOMY (CANDIDATE, Round P revision)

**CANDIDATE (Round P revision) — not adopted; owner disposition pending. Date 2026-08-10.
SUPERSEDES the frozen original `FAILURE-TAXONOMY-CANDIDATE.md` as candidate text per
OWNER-RULINGS-2 Round-P authorization; original preserved unmodified as historical artifact.
Frozen court-construction baseline: commit `71422395`. Prepared against the R1 candidate base
(parcel sha256 `54aa7783…`, patch base `76952ea4…`) — base NOT owner-adopted. Round P claims
NO evidence; zero evidence remains earned. Designation: Portable Judge /0 (PortJ/0); bare PJ0
reserved for the adopted Process Journal /0.**

Full base coordinates: parcel sha256
`54aa7783c494d8f32baa3c10eecd48590b88b13f07f0de6c8724831807a02803`; patch base commit
`76952ea4f278d269f98f158555e412a095a3da6f`; R1 freeze lane subtree
`e94870bd9091e67f68e9cf238a6c5d0dcf302a05`.

**Target: PortJ-L/0** — language-layer portable conformance (PROTOCOL-P1 §1.1). Every verdict class
below is scoped to the language layer and to the eleven implemented items; **no verdict here bears
on PortJ-F/0**, which is not opened.

**These rules are PRE-REGISTERED.** They were written before any J2 exists, before any holdout case
is authored, and before any disagreement is seen — and this revision changes **no class definition
and no consequence**. It retargets scope language, applies the designation sweep, and adds one
clarifying paragraph about the Act Oracle transcript (§1.3a). A taxonomy written after the first red
is a rationalization with a table around it; a taxonomy *revised* after a ruling must be able to
show that the revision did not touch the bands, and this one shows it in §0.

---

## 0. What Round P changed here — and what it did not

**Did not change:** the five classes, their definitions, their discriminators, their evidence
requirements, or their consequences. Class 1 still permits repair at the cost of first-run status;
class 2 is still the class the campaign is built to protect and still refutes the hypothesis at
full strength; class 3 still never counts against J2; class 4 is still an automatic red no repair
earns; class 5 still reports against J1 and still forbids in-campaign J1 repair. The adjudication
procedure (§2), the per-verdict record (§3), and the anti-laundering rules (§4) are carried
forward intact.

**Changed:** scope language now reads *PortJ-L/0 / language layer / the eleven items* wherever the
original read *the center claim / the judge*; designation swept to **PortJ/0**; §1.3a added; the
class-2 reporting line updated to the licensed vocabulary; cross-references retargeted to the P1
documents.

**Why the bands were not touched:** re-tuning a verdict band while revising a campaign's claim is
exactly how a court makes a smaller claim easier to win. The claim shrank by ruling; the standards
did not move with it.

---

## 1. The five classes

Every disagreement between J1 and J2 is classified into **exactly one** of five classes. The class
determines the consequence, and the consequence is fixed in advance so that no one gets to choose it
after seeing who would be embarrassed.

---

### Class 1 — PORT DEFECT

**Definition.** The written specification **determines** the canonical result — a competent reader
of the packet alone would reach J1's answer — and J2 implemented it wrong, in one of the eleven
language-layer items it was asked to implement.

**Discriminator (the load-bearing test).** Quote the specification sentence(s) that determine the
result. If the determination requires reading the canonical implementation, requires knowing a
Common Lisp behavior the packet never states, or requires an inference two competent readers could
reasonably decline, **it is not class 1** — it is class 2 or class 3. *The burden is on the
classifier to exhibit the determining text, not on J2 to have guessed it.*

**Scope note (L/0).** A divergence in something J2 was **not** asked to implement is never class 1.
The eleven items are the boundary: datum ingestion · validation · bindings and scope · matching ·
branch selection · terminal discipline · result construction · summary ordering · copy/ownership
behavior at the observable boundary · refusal behavior · determinism.

**Evidence required.** Both envelopes; the quoted determining sentence(s) with document and section;
the comparator category (typically C3, C4, C7, C8).

**Consequence.** **J2 may be repaired.** **First-run conformance is not earned for that case** and
cannot be recovered by any later clean run. The repaired run is labeled *repaired* at every
citation, forever. The campaign may still pass on repaired status — and every artifact must say so
in the same breath as the number.

---

### Class 2 — SPECIFICATION UNDERDETERMINATION

**Definition.** J1 and J2 disagree, and **both are reasonable readings of the public law**. The
specification does not determine the answer.

**Discriminator.** Attempt to write the determining quotation required by class 1. If it cannot be
written — or if writing it requires appeal to the canonical source, to Common Lisp's behavior, or to
what the authors "obviously meant" — the case is class 2. **Silence is class 2, not class 1.** A
specification that is silent has not been disobeyed.

**Evidence required.** Both envelopes; the *absence* exhibited (the sections searched, quoted where
they come closest); the two readings stated in their strongest forms, each as its own paragraph; the
deficit-register entry (`SPEC-DEFICIT-REGISTER-CANDIDATE.md`, by SD-number).

**Consequence — and this is the class the whole campaign is built to protect.**

- **Portable conformance is NOT earned.** The PortJ-L/0 hypothesis is refuted at that case, at full
  strength, and reported as such.
- **Draft an erratum** against the base lane's public law, resolving the underdetermination in
  whichever direction the owner rules — *including possibly against J1*.
- **Freeze a new seed and begin a NEW campaign.** The erratum changes the packet; a packet that
  changed mid-campaign cannot support a claim about *frozen* normative cases.
- **NEVER tutor J2 into copying J1 and call the imitation conformance.** Telling the implementer
  what J1 does, then re-running, measures obedience and nothing else. A green produced this way is a
  **laundered green** and is the single most likely way this campaign could produce a false positive.
  If it happens by accident (a stray answer, an overheard remark), the case is dead — record it, void
  it, do not re-run it in this campaign.
- A class-2 verdict is a **publishable result and a success of the instrument.** The pre-committed
  reporting line: *the campaign found the public law underdetermined at N points, which is what a
  portability instrument is for.* This is the same shape as the finding the campaign has **already**
  produced without running anything — that the present public law is insufficient for a clean-room
  second implementation without invention, oracle mediation, or consultation of implementation source
  in at least twenty-eight registered places.

---

### Class 3 — ORACLE CONTAMINATION

**Definition.** The **test** — the case, its expected envelope, or **its Act Oracle transcript** —
assumes a Common Lisp representation, an implementation detail, a hidden helper, or a non-normative
trace; i.e. it asks J2 to agree with the substrate rather than with the law.

**Discriminator.** Does passing the case require J2 to reproduce something on PROTOCOL-P1 §5.2's
exclusion list? Does it require a behavior that exists only because J1 is a Common Lisp (symbol
upcasing, condition report text, `eq`-ness, printed representation, fixnum behavior, package
semantics)? Does the expected envelope contain a value no packet document publishes? **Or is the
divergence traceable to the transcript rather than to either judge (§1.3a)?**

**Evidence required.** The case; the specific contaminating assumption named; the exclusion-list item
or missing publication it violates; **for a transcript-caused finding, the transcript excerpt and its
hash**.

**Consequence.** **Invalidate or rewrite the test. NEVER count it against J2.** A rewritten case is a
**new case in a new bank** with its own freeze — never a silent edit to an opened case. The
contamination itself is a finding about the *campaign's* authorship and is reported with the others.
If contamination is discovered only after a red was published, the published red is **retracted by
name**, not quietly amended.

#### §1.3a — Divergence caused by the ACT ORACLE TRANSCRIPT (clarifying paragraph, new)

**A divergence caused by the Act Oracle transcript itself — a transcript that is wrong, ambiguous,
or under-specified — adjudicates as ORACLE CONTAMINATION against the TRANSCRIPT, never against J2.**
The transcript is an input the campaign authored and handed to both judges (PROTOCOL-P1 §5.3;
ADJUDICATION-P1 §4.0). When it misstates what the act substrate did, admits more than one carriage
reading, or omits a value a case needs, the resulting disagreement measures the campaign's own
instrument and nothing about the implementer's fidelity to the law. Three consequences follow, and
they are the same shape as class 3's general rule, applied one artifact over:

1. **The finding is recorded against the transcript, by name and hash**, with the offending entry
   quoted and the reading(s) it admits stated. It is not a J2 result and may not appear in any
   count of J2's cases.
2. **The transcript is then repaired under constitutional handling** — i.e. under the same
   discipline that governs any frozen artifact of this campaign: it is **not edited in place**; the
   case is **voided and re-frozen as a new case, in a new bank, with a new transcript and a new
   hash**, the original preserved with the reason (ADJUDICATION-P1 §8). If the defect implicates
   how transcripts are produced rather than one transcript's contents, the production procedure is
   the thing repaired, and every case produced by the old procedure is re-examined before any of
   them is counted.
3. **The residual risk is named, not covered.** A transcript that was frozen *wrong* remains
   hash-consistent forever; the harness's integrity teeth (ADJUDICATION-P1 §7, T-ORACLE) catch
   *tampering*, not *authorship error*. Only adjudication catches the second, and only if the
   adjudicator asks — so the question *"could the transcript be the cause?"* is a **required step
   in every class-1 and class-4 classification**, exhibited or explicitly compressed
   (`CLAUDE.md` §I-f).

**The failure mode this paragraph exists to prevent:** J2 carries a transcript value correctly, the
transcript was wrong, the envelopes diverge, and the adjudicator — reading J2's source last and
finding an honest carriage path — classifies a port defect against an implementer who did exactly
what the packet said. That verdict would be a false positive for the campaign's own instrument
dressed as a defect in the challenger.

---

### Class 4 — CONSTITUTIONAL REGRESSION

**Definition.** J2 **turns an inherited language-layer disease witness green**, **broadens
authority**, **executes a prohibited branch**, **loses required provenance or carriage**, or
**silently removes required support**.

**Discriminator.** Not "is J2 different?" but "does J2 permit something the law forbids?" The five
triggers, with their observable signatures:

| Trigger | Signature |
|---|---|
| disease witness green | a discriminating holdout case answered the disease way (PROTOCOL-P1 §10.4) |
| authority broadened | an act begins with an unfilled/unmatched slot; an ambient or defaulted authority; an act-result or literal accepted in authority position |
| prohibited branch executed | comparator category **C6** — an untaken branch arm produced an act summary or a footprint |
| required provenance/carriage lost | comparator category **C7** — a required OB-4/OB-5/OB-14 field or ordering dropped, reordered, or defaulted, **including an oracle-supplied value dropped in carriage** |
| required support silently removed | a refusal converted into a completion; a validation performed after an effect; a bound removed so a hostile source hangs instead of refusing; **an error laundered into `:completed`** |

**Scope note (L/0).** Only diseases whose witness lives in the **language layer** are in scope.
Substrate-layer disease witnesses are oracle-mediated at L/0 and are **neither tested nor claimed**
— their absence from the campaign is part of what the licensed sentence does not say, and no L/0
result may be read as conserving them.

**Evidence required.** The signature above; the case; the law it violates, quoted; the transcript
ruled out as cause (§1.3a); and — for the disease trigger — the adjudicator's post-freeze **mutation
teeth-check** showing the discriminator actually bites J2's code path (PROTOCOL-P1 §10.4(b)).

**Consequence. AUTOMATIC RED.** No repair earns the campaign. J2 may of course be fixed, and the
fixed J2 may enter a **future** campaign, but the present campaign's verdict stands as red and is
reported as red. **A constitutional regression is never downgraded to a port defect because the fix
was small.** Size of fix is not a class discriminator; what the implementation *permitted* is.

---

### Class 5 — REFERENCE DEFECT

**Definition.** J2 exposes behavior in **J1** that contradicts the adopted written law.

**Discriminator.** The specification determines the result (class-1's quotation test succeeds) —
**and J1 is the one that fails it**. J2 is right and the older implementation is wrong.

**Evidence required.** The determining quotation; both envelopes; the transcript ruled out as cause
(§1.3a); and a minimal reproduction against J1 alone (independent of J2), so the defect stands
without reference to the challenger.

**Consequence.**

- **Report the defect AGAINST J1**, by name, in the campaign return and in the base lane's findings
  registry.
- **J1 is not correct merely because it is older.** Seniority is not evidence. The instrument
  outranking the reading is a thing this lab has already lived (R1-F1, where the chair's structural
  reading was wrong and the fixture was right); the same posture applies here.
- **Any J1 repair requires constitutional handling** — the base lane is a candidate under a freeze,
  its predecessors are adopted and frozen, and a repair touching an adopted lane is an owner matter,
  never a campaign matter. **No repair to J1 happens inside this campaign.**
- **A newly frozen campaign** is required after any J1 repair; the present campaign closes with the
  defect recorded and its conformance question **unresolved**, not passed.

---

## 2. Adjudication procedure

**Who classifies.** A **non-implementer adjudicator** — a party that authored neither judge. The
adjudicator may be a construction-loop participant *only if* they did not author the holdout cases;
one hand may not hold J2 authorship, holdout-case authorship, and classification (ADJUDICATION-P1
§1). The adjudicator's identity, model or human, is recorded per verdict.

**On what evidence.** In this order, and the order is a rule:

1. **The transcript integrity record** — hash match, and the §1.3a question asked. A divergence over
   a bad input is not a divergence between judges. *(Promoted to first by this revision; it was
   implicit and is now a step.)*
2. **The comparator's category** and both envelopes (ADJUDICATION-P1 §4), read with the
   oracle-supplied field count beside them.
3. **The specification text**, searched and quoted — this is where class 1 and class 2 separate, and
   the separation is made by *exhibiting text or failing to*.
4. **The determinism and teeth records** — a red under an untested comparator is not yet a red.
5. **J2's source**, read **last and only** to distinguish class 1 from class 2 (did the implementer
   misread a determining sentence, or did they read an undetermined one differently?) and to design
   the class-4 mutation teeth-check. Source is never the ground of the verdict; envelopes are.
6. **J1's source** — read only when class 5 is in play, and only to write the minimal reproduction.

**The classification is written before the consequence is applied**, in the adjudicator's own words,
with the quotations inline. A verdict whose reasoning is "checked, it's a port defect" is a
conclusion wearing a check's costume: either **show the determining sentence** or write
*"determination compressed"* so the compression is visible and challengeable.

**Timing.** Classification happens after the holdout opens and after the integrity, determinism, and
teeth records are in hand. No verdict is issued while any judge, test, or transcript is still
editable.

**Appeal.** The implementer may appeal a classification once, in writing, to the **owner**, whose
ruling is final. The appeal states which class the implementer believes applies and exhibits the
evidence that class requires (for class 2: the absence; for class 3: the transcript defect; for
class 5: the determining quotation against J1). The adjudicator's original classification, the
appeal, and the ruling are **all preserved** — a reversed classification does not erase the
original. The owner may also rule *sua sponte* on scoping and designation, and has: PROTOCOL-P1 §1
carries the L/0 ⁄ F/0 division and the licensed sentence as ruled.

**Deadlock.** If the adjudicator cannot classify — the evidence supports two classes and the
quotation test is genuinely ambiguous — the default is **class 2**, because an unclassifiable
disagreement *is* evidence that the law does not determine the case. The default is stated in
advance precisely so it cannot be chosen to flatter anyone.

---

## 3. The required record, per verdict

Every verdict, of every class, carries:

| Field | Content |
|---|---|
| `case-id` · `bank` | which case, public or holdout |
| `transcript-hash` · `integrity` | the frozen hash, the recomputed hash, and the §1.3a determination |
| `comparator-category` | C1…C8, with precedence applied |
| `oracle-supplied-field-count` | how much of this case's agreement was input rather than result |
| `class` | 1…5, or VOID with cause |
| `determining-text` | the quotation, with document + section — **or the explicit statement that none exists** (which is itself the class-2 evidence) |
| `envelopes` | both, verbatim, byte-preserved |
| `first-run \| repaired` | never merged into an aggregate that hides which |
| `adjudicator` | name/model, and their eligibility line |
| `teeth-status` | whether this case's comparator category — **and T-ORACLE** — had been shown to bite before this run |
| `deficit-refs` | any SD-* entries the case touched or created, cited to `SPEC-DEFICIT-REGISTER-CANDIDATE.md` |
| `consequence-applied` | with the date and the artifact hashes preserved before any edit |
| `appeal` | absent, or: the appeal text, the ruling, and both classifications |

---

## 4. Anti-laundering rules (binding on every artifact of this campaign)

Written as prohibitions because each names a move that would otherwise happen quietly and read as
diligence.

1. **A repaired green is never reported as a first-run green.** Two columns or no number.
2. **A tutored green is not a green.** Any case where J1's behavior was disclosed to the implementer
   before their answer is dead — voided, recorded, not re-run in this campaign.
3. **No aggregate may merge classes.** "N/N conform" without the class breakdown is a forbidden
   sentence.
4. **A VOID is not a pass and not a fail.** It is a run that failed to measure. It is reported in its
   own row with its cause, and it never disappears into a denominator. *(Including the adapter VOID:
   a campaign voided at the identity gate has no conformance result at all, not a partial one.)*
5. **A class-2, class-3, or class-5 outcome may not be softened into class 1.** Hedging adjectives do
   not demote a claim; recategorization does — and here the categories run the other way: calling an
   underdetermination, or a transcript defect, a port defect *promotes* the campaign's result by
   demoting the finding, which is the flinch this taxonomy exists to catch.
6. **A clean campaign says only what PROTOCOL-P1 §10's pass conditions say, in the licensed
   sentence, with the vector set named.** Not "Lisp+ is portable." Not "the spec is complete." Not
   the phrases Rider 2 bars — which this campaign, being about independence, would be the worst
   possible place to slip. **And never the shortening "an independent Lisp+ implementation
   exists."**
7. **The teeth come before the pass.** A category whose comparator teeth were never shown to bite
   yields, at best, *"clean under an untested comparator."*
8. **Every count is mechanically enumerated**, never rounded, never a target. No round-number goals
   are set for any bank.
9. **An oracle-supplied field is never counted as conformance.** *(Added by this revision. It is the
   L/0 split's specific laundering hazard: the smaller claim is easier to make look large by counting
   the oracle's own consistency as the challenger's success.)*

---

*— revised by PRAETOR (Claude Opus), Round P, commissioned by the chair (Claude Fable 5),
2026-08-10*
