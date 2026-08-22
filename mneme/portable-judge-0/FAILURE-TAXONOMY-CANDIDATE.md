# PORTABLE JUDGE /0 — FAILURE TAXONOMY (CANDIDATE)

**STANDING: CANDIDATE — not adopted; owner disposition pending.** Date: 2026-08-10.

**Prepared against the R1 CANDIDATE base of Many Acts /0**: parcel sha256
`54aa7783c494d8f32baa3c10eecd48590b88b13f07f0de6c8724831807a02803`; patch base commit
`76952ea4f278d269f98f158555e412a095a3da6f`; R1 freeze lane subtree
`e94870bd9091e67f68e9cf238a6c5d0dcf302a05`. **The base is itself NOT owner-adopted.**

**NAMING COLLISION (first use).** "PJ0" already denotes the **ADOPTED Process Journal /0**
(`mneme/architecture/process-journal-0/PJ0-ADOPTION-RECORD.md`). This campaign is **Portable
Judge /0** (`portable-judge-0/`); short form **PortJ/0**. Final designation **pending owner
ratification**.

**These rules are PRE-REGISTERED.** They are written before any J2 exists, before any hidden
case is authored, and before any disagreement is seen. A taxonomy written after the first red is
a rationalization with a table around it. The bands below are the interpretation, frozen; the
proof of ordering is this document's commit timestamp against the campaign's phase log
(PROTOCOL §9).

---

## 1. The five classes

Every disagreement between J1 and J2 is classified into **exactly one** of five classes. The
class determines the consequence, and the consequence is fixed in advance so that no one gets to
choose it after seeing who would be embarrassed.

---

### Class 1 — PORT DEFECT

**Definition.** The written specification **determines** the canonical result — a competent
reader of the packet alone would reach J1's answer — and J2 implemented it wrong.

**Discriminator (the load-bearing test).** Quote the specification sentence(s) that determine the
result. If the determination requires reading the canonical implementation, requires knowing a
Common Lisp behavior the packet never states, or requires an inference two competent readers could
reasonably decline, **it is not class 1** — it is class 2 or class 3. *The burden is on the
classifier to exhibit the determining text, not on J2 to have guessed it.*

**Evidence required.** Both envelopes; the quoted determining sentence(s) with document and
section; the comparator category (typically C3, C4, C7, C8).

**Consequence.** **J2 may be repaired.** **First-run conformance is not earned for that case** and
cannot be recovered by any later clean run. The repaired run is labeled *repaired* at every
citation, forever. The campaign may still pass on repaired status — and every artifact must say so
in the same breath as the number.

---

### Class 2 — SPECIFICATION UNDERDETERMINATION

**Definition.** J1 and J2 disagree, and **both are reasonable readings of the public law**. The
specification does not determine the answer.

**Discriminator.** Attempt to write the determining quotation required by class 1. If it cannot be
written — or if writing it requires appeal to the canonical source, to Common Lisp's behavior, or
to what the authors "obviously meant" — the case is class 2. **Silence is class 2, not class 1.**
A specification that is silent has not been disobeyed.

**Evidence required.** Both envelopes; the *absence* exhibited (the sections searched, quoted where
they come closest); the two readings stated in their strongest forms, each as its own paragraph;
the deficit-register entry.

**Consequence — and this is the class the whole campaign is built to protect.**

- **Portable conformance is NOT earned.** The center claim is refuted at that case, at full
  strength, and reported as such.
- **Draft an erratum** against the base lane's public law, resolving the underdetermination in
  whichever direction the owner rules — *including possibly against J1*.
- **Freeze a new seed and begin a NEW campaign.** The erratum changes the packet; a packet that
  changed mid-campaign cannot support a "previously unseen" claim.
- **NEVER tutor J2 into copying J1 and call the imitation conformance.** Telling the implementer
  what J1 does, then re-running, measures obedience and nothing else. A green produced this way is
  a **laundered green** and is the single most likely way this campaign could produce a false
  positive. If it happens by accident (a stray answer, an overheard remark), the case is dead —
  record it, void it, do not re-run it in this campaign.
- A class-2 verdict is a **publishable result and a success of the instrument.** The pre-committed
  reporting line: *the campaign found the specification underdetermined at N points, which is what
  a portability test is for.*

---

### Class 3 — ORACLE CONTAMINATION

**Definition.** The **test** assumes a Common Lisp representation, an implementation detail, a
hidden helper, or a non-normative trace — i.e. the case asks J2 to agree with the substrate rather
than with the law.

**Discriminator.** Does passing the case require J2 to reproduce something on PROTOCOL §5.2's
exclusion list? Does it require a behavior that exists only because J1 is a Common Lisp (symbol
upcasing, condition report text, `eq`-ness, printed representation, fixnum behavior, package
semantics)? Does the expected envelope contain a value no packet document publishes?

**Evidence required.** The case; the specific contaminating assumption named; the exclusion-list
item or missing publication it violates.

**Consequence.** **Invalidate or rewrite the test. NEVER count it against J2.** A rewritten case is
a **new case in a new bank** with its own freeze — never a silent edit to an opened case. The
contamination itself is a finding about the *campaign's* authorship and is reported with the
others. If contamination is discovered only after a red was published, the published red is
**retracted by name**, not quietly amended.

---

### Class 4 — CONSTITUTIONAL REGRESSION

**Definition.** J2 **turns an inherited disease witness green**, **broadens authority**, **executes
a prohibited branch**, **loses required provenance**, or **silently removes required support**.

**Discriminator.** Not "is J2 different?" but "does J2 permit something the law forbids?" The five
triggers, with their observable signatures:

| Trigger | Signature |
|---|---|
| disease witness green | a discriminating hidden case answered the disease way (PROTOCOL §10.3) |
| authority broadened | an act begins with an unfilled/unmatched slot; an ambient or defaulted authority; an act-result or literal accepted in authority position |
| prohibited branch executed | comparator category **C6** — an untaken branch arm produced an act summary or a footprint |
| required provenance lost | comparator category **C7** — a required OB-4/OB-5/OB-14 field or ordering dropped, reordered, or defaulted |
| required support silently removed | a refusal converted into a completion; a validation performed after an effect; a bound removed so a hostile source hangs instead of refusing; **an error laundered into `:completed`** |

**Evidence required.** The signature above; the case; the law it violates, quoted; and — for the
disease trigger — the adjudicator's post-freeze **mutation teeth-check** showing the discriminator
actually bites J2's code path (PROTOCOL §10.3(b)).

**Consequence. AUTOMATIC RED.** No repair earns the campaign. J2 may of course be fixed, and the
fixed J2 may enter a **future** campaign, but the present campaign's verdict stands as red and is
reported as red. **A constitutional regression is never downgraded to a port defect because the fix
was small.** Size of fix is not a class discriminator; what the implementation *permitted* is.

---

### Class 5 — REFERENCE DEFECT

**Definition.** J2 exposes behavior in **J1** that contradicts the adopted written law.

**Discriminator.** The specification determines the result (class-1's quotation test succeeds) —
**and J1 is the one that fails it**. J2 is right and the older implementation is wrong.

**Evidence required.** The determining quotation; both envelopes; a minimal reproduction against
J1 alone (independent of J2), so the defect stands without reference to the challenger.

**Consequence.**

- **Report the defect AGAINST J1**, by name, in the campaign return and in the base lane's
  findings registry.
- **J1 is not correct merely because it is older.** Seniority is not evidence. The instrument
  outranking the reading is a thing this lab has already lived (R1-F1, where the chair's
  structural reading was wrong and the fixture was right); the same posture applies here.
- **Any J1 repair requires constitutional handling** — the base lane is a candidate under a freeze,
  its predecessors are adopted and frozen, and a repair touching an adopted lane is an owner
  matter, never a campaign matter. **No repair to J1 happens inside this campaign.**
- **A newly frozen campaign** is required after any J1 repair; the present campaign closes with the
  defect recorded and its conformance question **unresolved**, not passed.

---

## 2. Adjudication procedure

**Who classifies.** A **non-implementer adjudicator** — a party that authored neither judge. The
adjudicator may be a construction-loop participant *only if* they did not author the hidden cases;
one hand may not hold J2 authorship, hidden-case authorship, and classification (ADJUDICATION §1).
The adjudicator's identity, model or human, is recorded per verdict.

**On what evidence.** In this order, and the order is a rule:

1. **The comparator's category** and both envelopes (ADJUDICATION §4).
2. **The specification text**, searched and quoted — this is where class 1 and class 2 separate,
   and the separation is made by *exhibiting text or failing to*.
3. **The determinism and teeth records** — a red under an untested comparator is not yet a red.
4. **J2's source**, read **last and only** to distinguish class 1 from class 2 (did the implementer
   misread a determining sentence, or did they read an undetermined one differently?) and to design
   the class-4 mutation teeth-check. Source is never the ground of the verdict; envelopes are.
5. **J1's source** — read only when class 5 is in play, and only to write the minimal reproduction.

**The classification is written before the consequence is applied**, in the adjudicator's own words,
with the quotations inline. A verdict whose reasoning is "checked, it's a port defect" is a
conclusion wearing a check's costume: either **show the determining sentence** or write
*"determination compressed"* so the compression is visible and challengeable.

**Timing.** Classification happens after the hidden bank opens and after the determinism/teeth
records are in hand. No verdict is issued while any judge or test is still editable.

**Appeal.** The implementer may appeal a classification once, in writing, to the **owner**, whose
ruling is final. The appeal states which class the implementer believes applies and exhibits the
evidence that class requires (for class 2: the absence; for class 5: the determining quotation
against J1). The adjudicator's original classification, the appeal, and the ruling are **all
preserved** — a reversed classification does not erase the original. The owner may also rule
*sua sponte* on scoping (PROTOCOL §3) and naming, which are open forks left to them by design.

**Deadlock.** If the adjudicator cannot classify — the evidence supports two classes and the
quotation test is genuinely ambiguous — the default is **class 2**, because an unclassifiable
disagreement *is* evidence that the law does not determine the case. The default is stated in
advance precisely so it cannot be chosen to flatter anyone.

---

## 3. The required record, per verdict

Every verdict, of every class, carries:

| Field | Content |
|---|---|
| `case-id` · `bank` | which case, public or hidden |
| `comparator-category` | C1…C8, with precedence applied |
| `class` | 1…5, or VOID with cause |
| `determining-text` | the quotation, with document + section — **or the explicit statement that none exists** (which is itself the class-2 evidence) |
| `envelopes` | both, verbatim, byte-preserved |
| `first-run \| repaired` | never merged into an aggregate that hides which |
| `adjudicator` | name/model, and their eligibility line |
| `teeth-status` | whether this case's comparator category had been shown to bite before this run |
| `deficit-refs` | any SD-* entries the case touched or created |
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
4. **A VOID is not a pass and not a fail.** It is a run that failed to measure. It is reported in
   its own row with its cause, and it never disappears into a denominator.
5. **A class-2 or class-5 outcome may not be softened into class 1.** Hedging adjectives do not
   demote a claim; recategorization does — and here the categories run the other way: calling an
   underdetermination a port defect *promotes* the campaign's result by demoting the finding, which
   is the flinch this taxonomy exists to catch.
6. **A clean campaign says only what §10's pass conditions say.** Not "Lisp+ is portable." Not "the
   spec is complete." Not "independently verified" — which the inherited Rider 2 forbids outright,
   and which this campaign, being about independence, would be the worst possible place to slip.
7. **The teeth come before the pass.** A category whose comparator teeth were never shown to bite
   yields, at best, *"clean under an untested comparator."*
8. **Every count is mechanically enumerated**, never rounded, never a target. No round-number goals
   are set for any bank.

---

*— drafted by LEGIST (Claude Opus), commissioned by the chair (Claude Fable 5), 2026-08-10*
