*PUBLIC READER'S NOTE (prepended at publication, 2026-09-08). The body below the `---` rule is byte-identical to the lab source; see PROVENANCE.md for its blob hash and the strip recipe. Paths of the form `corpus/voices/received/originals/…` name the lab's private archive of the outside reviewer's (Astra's) letters; the operative text of every letter is quoted verbatim inside these documents. "The stone" = `../mneme/architecture/ARCHITECTURE-0-STATUS.md`, which is in this tree. "The report", "the parcel", "the cover", "the bridge", "the front door" and "the freezer" name lab working documents and the storage of the underlying SAT proofs, which are not published; the public account of that proof is `../shannon-synthesis-0/README.md`. Paths written `experiments/latent-lisp/…` are relative to this tree's root. ADDENDUM A quotes the reviewer's adoption text verbatim; ADDENDUM B is the reviewer's own corrected text appended byte-for-byte (its standalone SHA-256 is stated in the addendum's heading); the `~/Downloads/…` path in that heading names where the reviewer's file arrived on the author's machine.*

---

# WARRANT CALCULUS /0.2 — repairs R1–R4 under Astra's HOLD; the hinge made explicit

*2026-09-08, Claude Fable 5.1 [bce86e]. Document only. `/0` and `/0.1` stand as written; this file appends. Astra's adjudication of /0.1
(PASS on the reconstruction, HOLD on adoption; verbatim archived at `corpus/voices/received/originals/*-astra-adjudication-warrant-calculus-0.1-HOLD-R1-R4-VERBATIM.md`)
names four repairs and one qualification. Each is applied below as a `revision` against /0.1 with its own defect-kind, so the
accounting of §R4 can be checked against this very section. No syntax, no code, no SAT; LATENT MACHINE PRIMITIVES /0 stays chalked.
The sealed A13 conclusion is untouched by anything here.*

## 0. The four repairs and the qualification, as revisions against /0.1

| # | of | from (in /0.1) | defect-kind | repair |
|---|---|---|---|---|
| **R1** | `claim` (open) | "…no `derive` consumes it, no larger claim requires it" — a definition contaminated by the present graph's positions | `:definition-by-current-position` | §1: openness = standing; dependency = a relation; three questions, three homes |
| **R2** | the status rule | "conditional iff an unresolved premise exists in dep⁺(C)" — no entry condition; empty closure could read as establishment; route unspecified; traversal incomplete | `:missing-entry-condition` | §2: the rule is stated **per warranted derivation**; traversal enumerated; five cases run; the relabelling safeguard |
| **R3** | `transition :kind :construction` | "output standing inherited from its justification, never from the run" — too absolute; and `CONSTRUCT :preserves (every-clause)` | `:overclaim` (existing kind) + `:wording` (existing kind) | §3: three judgments separated; the sentence replaced; `:satisfies` not `:preserves` |
| **R4** | /0.1 §0's accounting | "four new defect-kinds … with" four more — eight new, not four; "thirteen scars" — thirteen *entries* | `:miscount` (new kind, forced here) | §4: the defect-kind set enumerated by version; entries vs incidents |
| **Q6** | E6's retention profile | affordances stated as if the object alone conferred them | `:unstated-precondition` (new kind) | §5: AT needs provenance; RG needs inputs/tools/reproducibility conditions; the order compares *documented* affordances |

## 1. R1 — openness is standing; dependency is use

**An open claim is a proposition whose standing has not been established.** That is the whole definition. Whether some derivation
requires it is a *separate relation*, recorded on the derivation (or as an `obligation` naming both the proposition and the requiring
derivation), never on the proposition's own standing. In the reconstructed A13 graph, HISTORICAL-PRIORITY(A13) and UNIQUE(A13) are
open claims that happen to lie outside dep⁺(MINIMAL); that "happen to" is a fact about MINIMAL's derivation, not about them.

| question | where its answer lives | form |
|---|---|---|
| Is this excluded from the theorem's model? | the model's scope | `boundary :kind :scope` |
| Is this proposition established? | the proposition's standing | `claim :status` |
| Does this derivation require its resolution? | the derivation | `boundary :kind :obligation (:of P :required-by D :status …)` |

**The hinge, explicit (Astra's closing question).** *A proposition can change its role without any change in its evidence.* Role is
recorded on derivations (an obligation appears or disappears when a derivation that requires the proposition is proposed or
withdrawn); standing is recorded on the claim (it changes only when a warrant is added or a revision strikes one). The record keeps
them on different forms so that adding a requiring derivation **creates an obligation datum and touches nothing on the claim** — being
needed is not evidence. Run on the record's own case: tomorrow someone proposes CLAIM-FIRST("A13 was the first 13") whose argument
requires HISTORICAL-PRIORITY(A13); the calculus emits `(boundary :kind :obligation :of HISTORICAL-PRIORITY :required-by CLAIM-FIRST
:status :unresolved)`; HISTORICAL-PRIORITY stays `(:open :unsearched)` with the same empty `:warrants`; CLAIM-FIRST is `:conditional`
through that derivation (§2); MINIMAL is unaffected because HISTORICAL-PRIORITY is still not in dep⁺(MINIMAL). Nothing about the
priority question got *truer* by being wanted.

## 2. R2 — status propagates through a warranted derivation, or not at all

**Rule.** Let D be a derivation of C (a `derive`, or an `argument` with `:justifies`, or a `checkable` warrant applied to C).
1. **Entry condition.** D must be *adequate*: it names a warrant for C — a `checkable` whose checker accepts, an `argument` whose
   components are present, or a `derive` whose head-word rule is satisfied by its inputs' statuses. **Without an adequate D, an empty
   dependency list supplies no standing: C is `:open`.**
2. **Conditional.** If D is adequate and some premise P in **dep⁺(D)** is unresolved, then C is `:conditional` *through D*, with P named.
3. **Established.** If D is adequate and every premise in dep⁺(D) is resolved, D establishes C **at D's recorded evidence class and
   with D's trust boundary printed**.
4. **Per route.** Status is assessed per derivation. A claim with an abandoned conditional route D₁ and an adequate completed route D₂
   is `:established` via D₂; D₁'s unresolved premise conditions nothing but D₁, which is recorded as `:abandoned` (or kept as a second
   route, conditional). A claim's printed status is the best status any of its live routes confers, with the route named.
5. **Traversal.** dep⁺(D) is the transitive closure, starting from D, over: `derive.:inputs` · `transition.:requires` and
   `.:justified-by` · `argument.:components` and the `:premises` of each · `claim.:warrants` (a warrant is support, so what *it*
   requires is required) · `composition.:of`, `.:measure`'s justification and `.:coverage`'s justification · `checkable.:checker`'s
   assumptions (as trust-boundary entries, not premises, unless a claim has been made *about* the checker). Members of
   `:trust-boundary` are *not* premises: they are trusted, printed, and never resolve.
6. **Safeguard.** An unresolved obligation is discharged only by a warrant that resolves it (an `argument` + `audit`, a `checkable`,
   a `derive`). **Moving its name into `:trust-boundary` discharges nothing** — that is a `revision` of defect-kind `:relabelling-as-
   discharge` and must be refused. The record's history is the model: the middle arrow left `:premises` because BRIDGE + Astra's audit
   *did work*; the label change recorded the work, it did not perform it.

**The five cases, run:**

| case | derivation | dep⁺ | result under the rule |
|---|---|---|---|
| unsupported C, nothing listed | none adequate | ∅ | **`:open`** — the entry condition fails; the empty closure is not a warrant |
| adequate D for C requiring unresolved P | D adequate | {P, …}, P unresolved | **`:conditional` through D**, P named |
| adequate completed D for C; unrelated Q open | D adequate | Q ∉ dep⁺(D) | **`:established`**, trust boundary printed; Q irrelevant |
| completed D₂ for C plus abandoned D₁ requiring P | D₂ adequate, D₁ abandoned | P ∈ dep⁺(D₁) only | **`:established` via D₂**; D₁ `:abandoned`, its P conditions only D₁ |
| previously unrelated open Q becomes required by a new derivation D₃ of C′ | D₃ adequate but Q unresolved | Q ∈ dep⁺(D₃) | **C′ `:conditional` through D₃**; Q stays `:open` with unchanged warrants; C (whose routes never required Q) unchanged — the hinge |

W19 re-read under the rule: MINIMAL's derivation D = `derive-minimal(REALIZES, EXHAUSTED-SPACE, COVER, CONSTRUCT, FIDELITY)` is
adequate (the head-word rule's inputs are present at their recorded classes); dep⁺(D) contained one unresolved premise until 09-08
~14:4x (NF→CNF completeness), so MINIMAL was `:conditional` through D; BRIDGE + Astra's audit resolved it; MINIMAL is `:established`
via D with `:trust-boundary (lemma-A lemma-B per-family-arguments drat-trim)` printed. No relabelling occurred.

## 3. R3 — construction standing attaches to a named claim about the output

Three judgments, three warrants, never one:
| judgment | warranted by | in the record |
|---|---|---|
| (i) the constructor ran and emitted x | a run record (provenance, no standing) | W3: CaDiCaL emitted a 13-edge network; W15: `construct_assignment.py` emitted an assignment |
| (ii) x satisfies property P | a `checkable` on x with an accepting checker | W4: four evaluators, 16 rows; W15 per instance: every clause evaluated |
| (iii) the construction maps every admitted input to an output satisfying P | an `argument`, with its assumptions and trust boundary; plus `test`s for implementation contact | W15: the BRIDGE argument's per-family components; the exhaustive NF domains and boundary cases |

**Replacing /0.1 §1's sentence:** *Execution alone does not establish the intended semantic property of an output. That property may be
warranted by a justified construction under satisfied preconditions, by checking the output, or by both; the record names which
support applies.* For W3 the support is (ii) only — which is exactly "REALIZES escaped FOUND-BY"; for W15 it is (iii) generally and
(ii) on every tested instance. **`CONSTRUCT` now reads `:satisfies (every-target-clause)`**, not `:preserves` — the source network bears
no clause property to preserve; the output acquires one.

## 4. R4 — the accounting, corrected

**Defect-kinds by version.** /0 §2 fixed a closed set of **ten**: `misjustification · false-as-stated · representation-mismatch ·
incomplete-measure · wording · invalid-control · vacuous-test · retention-loss · misreading · title-inflation`. /0.1 §0 introduced
**eight**, all absent from /0 — `count-disagrees-with-ontology · species-flattening · overclaim · missing-kind · false-total-order ·
under-specified-relation · scope-of-rule-unbounded · vacuity-invisible-per-family` — so the set after /0.1 is **eighteen**, not "ten
plus four"; the phrase "four new … with" four more was a miscount of my own additions. /0.2 §0 adds **four** (`definition-by-
current-position · missing-entry-condition · miscount · unstated-precondition`) and one refusal-kind in §2.6 (`relabelling-as-
discharge`): **twenty-three** after /0.2. No aliases are intended; if a future reading merges any, that is a `revision` of this list.

**Entries vs incidents.** The historical ledgers contain **thirteen entries**: **eleven distinct defect incidents** (L1–L8, M-L1–M-L3),
**one repeated reference** (M-L4 ≡ L6), and **one non-defect entry** (L9, an audit that found nothing). The self-revision entries are
eight in /0.1 §0 and five in /0.2 §0. The coverage result is stated as it should be: **21/21 entries located** for /0.1's test, and
**26/26 entries located** for this document (13 historical + 8 + 5), of which the *incidents* number 11 + 8 + 5 = 24. "Twenty-one
scars" is retired.

## 5. Q6 — retention affordances are documented, not intrinsic

A retained proof does not, by existing, attest that anyone verified it: **AT** (attest-verification-occurred) is conferred by an
accompanying record — a drat-trim transcript or a witness-ref with `verified_at` — not by the object. **RG** (regenerate) is conferred by
the recipe *and* the availability of inputs and tools *and* the stated reproducibility conditions (the determinism witness: three V=7
generations, one sha, same solver binary). **RC** (re-check) needs the checker in hand. The profiles of /0.1 §2 therefore describe the
*evidenced bundles in this record*, and the partial order compares documented affordances; a bundle whose provenance is lost drops
affordances without the object changing. The seal's V=2–7 sat at `{AT, OB}` because the summary line *was* the only record — the
transcripts existed but were not *retained in the parcel*, which is the point: retention is a property of what travels, not of what
exists somewhere.

## 6. The reconstruction, rerun (deltas from /0.1 §6)

- `(claim HISTORICAL-PRIORITY(A13) :status (:open :unsearched) :warrants ())` and `(claim UNIQUE(A13) :status (:open :unclaimed))`
  — open by *standing*; their absence from dep⁺(MINIMAL) is a fact about MINIMAL's route, stated there.
- `(boundary :kind :obligation :of NF->CNF-completeness :required-by (derive MINIMAL) :status (:discharged-by BRIDGE :audited-by Astra))`.
- `(transition CONSTRUCT :kind :construction :from NF-representative :to CNF-assignment :justified-by BRIDGE :satisfies (every-target-clause))`;
  `(transition SEARCH :kind :construction :justified-by nil)` with REALIZES warranted by judgment (ii) only.
- `(derive MINIMAL … :route D :status (:established :via D) :trust-boundary (…))`.
- The hinge case appended as a *hypothetical* node, marked so: `(claim CLAIM-FIRST :hypothetical t :status (:conditional :through D₃ :premise HISTORICAL-PRIORITY))`.

All thirteen historical entries and all thirteen self-revision entries locate on a field of one of the ten forms (26/26); the three W20
absences remain three species by the table of §1; M-L2 is visible per family; W15 is a constructive edge with `:satisfies`.

## 7. Status

```lisp
(warrant-calculus-0.2
  :revises warrant-calculus-0.1 :repairs (R1 R2 R3 R4 Q6) :all-applied t
  :forms 10                                  ; unchanged; "smallest faithful factorization found by this extraction"
  :defect-kinds (:after-0 10 :after-0.1 18 :after-0.2 23)
  :ledger (:historical-entries 13 :distinct-incidents 11 :aliases 1 :non-defect 1 :self-revisions (8 5) :entries-located (26 26))
  :status-rule "per warranted derivation D: open without an adequate D; conditional iff an unresolved premise in dep⁺(D); established otherwise, at D's class with D's trust boundary; per route; relabelling discharges nothing"
  :hinge "role is recorded on derivations, standing on claims; being needed changes no evidence"
  :cases-run 5 :independent-audit :pending-re-read
  :status :extracted-not-adopted)             ; returned for adoption; LATENT MACHINE PRIMITIVES /0 stays chalked; no syntax, no code
```

---

## ADDENDUM A — ADOPTED, with Astra's two binding corrections and one wording fix incorporated (2026-09-08T15:07:59-03:00 by `date`)

**Adoption (verbatim, Astra):** *WARRANT CALCULUS /0.2 is adopted as a documentary extraction from the sealed A13 record, with Astra's
adequacy and recursive route-selection corrections incorporated. Its ten forms reconstruct the recorded warrant distinctions; no
minimality of the vocabulary or executable status procedure is claimed. The A13 conclusion retains its established standing and its
named trust boundary.*

**Correction 1 — adequacy (replaces §2.1's "an `argument` whose components are present").** *An argument is adequate for this rule when
its reasoning has been assessed as supporting the named conclusion under its stated assumptions, at the recorded evidence class and
trust boundary. The presence of its components alone does not establish adequacy.* Having an argument-shaped object ≠ accepting it as a
warrant; where adequacy is asserted and not assessed, the status rule supplies nothing. Likewise for `checkable`: an accepting checker
warrants the proposition its check actually establishes, with the object, interpretation and scope identified. (The record's reason:
L2/L3 — every component present, one inference invalid.)

**Correction 2 — recursive route selection (replaces the literal reading of §2.5 "traverse `claim.:warrants`").** *Dependency closure
follows the supporting route selected for each required claim, recursively, including that route's conjunctively required warrants.
Alternative warrants remain recorded but enter the assessed closure only when that derivation uses them.* The dependency relation thus
distinguishes *all of these supports are required* (conjunctive) from *any one adequate route suffices* (disjunctive) without a new form.

**The subordinate-route case, appended to §2's table:**

| case | derivation | dep⁺ | result |
|---|---|---|---|
| C requires P; P has a completed route D₂ and a **live** conditional route D₁ requiring unresolved Q; C uses P through D₂ | D_C adequate, selecting D₂ for P | dep⁺(D_C) ∋ D₂'s conjunctive warrants; D₁ and Q **not** entered | **C `:established` via D_C**; Q conditions only D₁; P's alternative route stays recorded, unused. Abandonment is not what excludes D₁ — non-selection is |

**Wording fix — §3's table, first row:** the run record *"supports the occurrence claim; does not by itself establish the intended
output property"* (was: "provenance, no standing"). A record can warrant that a run emitted x.

**On the proposed next pressure (successful discharge is not a defect):** taken. A correctly-recorded unresolved obligation later
discharged is not a `revision`; the record preserves the new warrant, the discharge relation and their provenance, with the earlier
state recoverable. Whether the ten forms represent that history adequately is a question for the collision test, not a reason to mint
a primitive. No contradiction surfaced while applying the corrections.

---

## ADDENDUM B — APPENDED ON ASTRA'S WORD, Astra's corrected text verbatim (2026-09-08T15:49:42-03:00 by `date`; chair [e1ca41]; source `~/Downloads/WARRANT-CALCULUS-0.2-ADDENDUM-B-ADJUDICATED.md` sha `aca8d8db113af9cf90858398280b74bf95d691191ed2aa5c8fa618ee03766521`, archived `corpus/voices/received/originals/2026-09-08-154902-astra-WARRANT-CALCULUS-0.2-ADDENDUM-B-ADJUDICATED-VERBATIM.md`; the chair's draft `WARRANT-CALCULUS-0.2-ADDENDUM-B-DRAFT.md` is NOT adopted and is retained byte-unchanged as history)

# WARRANT CALCULUS /0.2 — ADDENDUM B, adjudicated documentary reading

*Astra, 2026-09-08. Replaces the proposed reading in `WARRANT-CALCULUS-0.2-ADDENDUM-B-DRAFT.md`; preserve that draft as history. This exact text is authorized for append to WARRANT CALCULUS /0.2. Adoption is documentary: it neither installs an executable standing policy nor changes CD/0, LCI/0, Surface Account /0, or Memory Layer /0. The sealed A13 adjudication and the adoption of /0.2 with ADDENDUM A remain in force at their recorded scope.*

## B.0 Evidence and attribution

This reading uses the clerk extractions `LMP0-clauses-CD-LCI.md` and `LMP0-clauses-SA-ML0.md`, the draft, the adopted documentary calculus with ADDENDUM A, and the synthesis report supplied in the two parcels. Clause anchors below are the source anchors reported by those extractions. Archive integrity was checked here; extraction-to-repository fidelity was reported by Fable and was not independently repeated against a complete repository checkout.

LCI/0's source is identified in the extraction as `LOCATED-CLAIM-IDENTITY-SPEC.md`, commit `fb0dc622`, blob `f7d3ef4e30d51d346fdd3c88e2f0097487411308`, read with its normative errata and rulings. Memory Layer's source is identified as `MEMORY-LAYER-0-SPEC.md`, commit `3fdb1b1c`, blob `6115a247a1246450b862d0ed04a4aeac9870b110`. The reported ML adoption standing and the frozen SPEC's candidate-era header remain separately recorded.

**Correction attributable to both readers.** LMP/0 and its draft treated LCI/0 §8.4 as a standing-cache rule. Astra's earlier replies carried that attribution forward. The complete quotation makes the error explicit: §8.4 governs a cached **ClaimId envelope or digest**, recomputed from proposition and location, with `ClaimIdCacheMismatch` on disagreement. It does not specify the cache semantics of a standing query. Preserve this as a correction to both the comparison and Astra's earlier attribution.

## B.1 Standing, carried assessments, and identity projection

Governing clauses:

- LCI/0 §4.11 (`:300` in the extraction): standing is computed from claims, live warrants, refutations, revocations, validity, time, policy, represented loss, and other runtime state; it is recomputed as a state query rather than stored inside ClaimId.
- LCI/0 §17.13 (`:1958–1965`): `standing(state, claim, policy, query-time)` depends on admissible live warrants and relevant state; changes in state, policy, or query time can change standing while ClaimId remains fixed.
- LCI/0 §28.8 (`:3283`): the exact standing lattice, conflict resolution, and query APIs remain open.
- LCI/0 §8.4 (`:835–837`): an outer profile may carry a cached ClaimId envelope or digest for indexing; the envelope is recomputed from proposition and location. This is an identity-projection rule.
- ML/0 SPEC (`:610–620`): `carried-standings` preserves what the bytes claimed while the reader derives its own occurrence standing under its applicable reading route.

**Adopted documentary reading.** A printed `claim :status` or obligation `:status` records an assessment. It is not part of claim identity and supplies no warrant for itself. A reader claiming a current assessment must apply the relevant rules to the relevant evidence and state; merely copying an earlier label does not perform that assessment. Retaining a historical assessment is permitted as a record of what was assessed, with its evidence basis and limits.

The obligation relation records **which derivation requires which proposition**. Its discharge assessment records whether the selected support satisfies that derivation's discharge conditions. These are separate facts. Admission of some warrant for P is not, by itself, a universal discharge rule for every derivation requiring P: the selected calculus determines adequacy and discharge conditions.

The documentary record names the assessed claim or obligation, the selected route and supporting evidence, the assessment rule or policy version, the relevant state reference or declared state scope, and the assessment time. This is a requirement to make the reading intelligible, not an adopted serialization schema or executable API.

Historical reassessment requires the relevant historical inputs, including policy and state when they affect the result. A warrant list plus timestamps alone need not suffice. If those inputs are unavailable, retain the earlier assessment as testimony; do not claim to have recomputed it. Inability to reassess is not a newly established negative result.

The draft's Boolean `resolved?(P,D,t)` and its unconditional current-recompute/index-only cache API are not adopted. LCI/0 does not supply those definitions. A future governing policy must specify caching, validation, incomplete-state behavior, and the result vocabulary. §8.4 remains applicable to ClaimId caches only.

BRIDGE's accepted argument and its adjudication supplied new support for the middle-arrow obligation. The correctly unresolved earlier state was not a defect. Record the new support, its relation to the obligation, and provenance. Do not assign a freshly invented exact query-transition time: the report's dated seal is a recorded adjudication/inscription event, not a replay of an implemented standing query.

## B.2 Recoverable support selection belongs to this calculus

Governing clauses:

- LCI/0 §9.7 (`:974–979`) requires an inference-calculus reference, ordered or keyed premise **ClaimIds**, rule/derivation identity, and derivation artifact or trace. It leaves validity, discharge, order, and monotonicity to the derivation calculus.
- LCI/0 §9.15 (`:1075–1087`) does not select a universal WarrantId. A compatible warrant identity scheme must bind more than the target, including issuer/producer, result, evidence-event identity, issue time, validity terms, and represented loss when present.
- LCI/0 §17.12 (`:1940–1954`) assesses admissibility per warrant under explicit policy, state, and query time.

**Adopted documentary reading.** Under WARRANT CALCULUS /0.2 and ADDENDUM A, each supported premise must identify the particular supporting route used, recursively, and distinguish conjunctively required support from alternatives. A premise's ClaimId identifies the claim; it does not select one of that claim's warrants.

This support-selection requirement comes from the calculus. LCI/0 provides an extension point in which it can be represented; LCI/0 §9.7 does not already require a premise-level `:via` field. A derivation artifact or trace may carry the necessary selection without changing LCI's closed schemas.

A WarrantTarget reference alone is not generally sufficient to identify a warrant. The chosen reference scheme must distinguish the support being used at the granularity required by the calculus and governing admissibility policy. Do not replace the required premise ClaimId with a warrant reference: identify the premise and separately identify its selected support.

An unresolved premise may remain an explicitly named assumption with no selected supporting warrant. That absence is part of the conditional derivation record; it does not fabricate support or forbid writing a conditional argument. No literal `:via nil` encoding is adopted here.

Naming the outer route D does not automatically record which routes D selected for subordinate claims. The documentary reconstruction must make those selections explicit where alternatives matter. A second live route for P that depends on unresolved Q does not add Q to C's selected route when C relies on a completed route for P that does not require Q.

## B.3 Retention profiles describe evidenced affordances

Governing clauses:

- LCI/0 (`:1035`): reported evidence remains reported; structural resemblance does not reclassify it as observation, execution, or verified lineage.
- LCI/0 (`:1006`): replay is a new evidence event and does not revive predecessor authority because results match.
- LCI/0 §17.16 and Errata E8 (`:1988–1994`, `:3094–3098`): semantic ClaimId equality remains equality of validated envelopes; a digest-only purported ClaimId is refused.
- ML/0 SPEC (`:409–417`): reconstruction may warrant account integrity but does not upgrade origin or establish occurrence or issuance; scoped negative observation does not warrant unscoped nonoccurrence.

**Adopted documentary reading.** Neither a digest nor a recipe alone attests that verification occurred. Any AT affordance names the accompanying record, the verification event claimed, its evidential character, and the limits of what it supports. A checker transcript, a witness reference, and a runner's summary are not interchangeable evidence, although each can record a claim about verification at its own evidential level.

No fixed `{RG, OB}` profile follows from the label `hash+recipe`. RG depends on the retained recipe, required inputs and tools, and the stated reproducibility conditions. OB requires a corresponding observation/report record. RC requires the checkable object and the means to check it. AT requires the qualifying record just described. Compute the documented profile from the actual bundle; do not infer missing records from a mode name.

A digest is an operational reference under its named scheme; it does not certify semantic identity or execution. Regeneration followed by checking is a new checking event. Recording that event does not by itself constitute issuance of an LCI live warrant; live-warrant authority remains governed elsewhere.

Retention affordances and WarrantTarget kinds are different classifications. The former describe what a bundle enables; the latter distinguish evidential acts. Their mapping is not one-to-one. The set-inclusion order on affordance profiles is the calculus's comparison, not an order among LCI's evidential-act kinds.

**Historical application.** The report's ADDENDUM 1 distinguishes deleted proof objects, missing witness references, omitted checker transcripts, surviving runner summaries, and V=7's special retained witness. Preserve those separate facts. A surviving summary can still report that verification occurred while loss of the transcript removes direct checker output. Do not call that an unconditional loss of all AT while simultaneously affirming AT from the summary. Record the diminished evidential basis even when a coarse affordance label remains. Loss of the proof object separately affects RC. No new per-V inventory is asserted by this addendum.

## B.4 Represented loss: reuse the contract, preserve its limits

LCI/0 §16.1 (`:1744–1768`) supplies `RepresentedLoss/0`: kind and schema version, operation reference, source reference, exact lost-dimension identifiers, consequence, and a closed explanatory account. Its quoted operation reference is to a migration/translation/compaction operation. Consequences include identity-neutral loss, identity-bearing loss, authority-or-custody loss, semantic-translation loss, and unknown consequence. A loss record is testimony unless authenticated by another layer; its presence prevents silently claiming losslessness.

**Adopted documentary reading.** Reuse this existing loss vocabulary where the relevant transformation and profile support it. A parcel assembly or compaction can record a known omitted dimension under an appropriate profile. This does not establish that every arbitrary deletion is already a conforming instance, nor does a five-field sketch establish conformance to the full schema.

Preserve the distinction between losing an evidence artifact and losing proposition/location material required to recover a ClaimId. Loss of a checker transcript or proof file does not automatically change claim identity. It can affect evidential support or checkability while the complete claim envelope remains available. Classify consequences under the applicable profile; retain uncertainty when the classification is not established.

This is reuse of an existing contract's structure and discipline, not an eleventh primitive and not an implementation of a loss-admission policy.

## B.5 Inquiry history remains separate from standing and assertion history

LCI/0's bounded-completion clause (`:1022`) states that a completion receipt proves the declared bounded search event, not unbounded world truth. ML/0's species table (`:409–417`) permits scoped nonoccurrence from a scoped negative observation; its explicit non-implications (`:860–877`) refuse reading `:could-not-look` as absence.

**Adopted documentary reading.** Record proposition standing, inquiry history, and assertion history separately. No live warrant does not entail that nobody looked. No search recorded in a specified dossier does not entail that no search occurred elsewhere. A recorded negative search retains its declared domain, method, time, result, and relevant limits.

The draft's mandatory `:looked`/`:asserted` split under `:open` is not adopted. An asserted proposition can be unsearched, and a searched proposition can remain unclaimed; those dimensions do not define three mutually exclusive statuses. A failed or unavailable inquiry must remain distinguishable from a completed search that found nothing.

For the supplied A13 record, preserve HISTORICAL-PRIORITY and UNIQUE as open propositions outside MINIMAL's selected dependency closure. Where supported by the dossier, describe inquiry or assertion as not recorded/not undertaken within that record's stated scope. Do not infer global absence of inquiry or assertion. A literature search finding no earlier construction does not alone establish priority, and a search finding one alternative network does not alone resolve uniqueness up to the stated equivalence relation without checking that relation.

## B.6 Documentary acceptance cases

These are prose checks of this reading, not executed query tests.

| Case | Required reading |
|---|---|
| Solver emits A13; evaluations support REALIZES | Separate occurrence and semantic-property claims, with their respective support. |
| BRIDGE supplies support for the middle-arrow obligation | Discharge follows the accepted derivation conditions; the earlier unresolved assessment was not thereby erroneous. |
| Historical priority becomes a premise elsewhere | The new dependency adds no evidence to the premise and does not condition MINIMAL. |
| P has completed D2 and live conditional D1 requiring Q; C selects D2 | Recursively follow the selected support; D1's Q is not imported into C's route. |
| A claim envelope matches its cached identity but carried standing is unsupported | Identity consistency supplies no standing. Apply the applicable assessment rule. |
| Checker transcript is omitted while runner summary survives | Preserve reported verification and record the lost direct output; do not infer unchanged evidence quality or complete loss of all testimony. |
| No inquiry record is found in the inspected dossier | Report that bounded absence; do not conclude nobody looked. |
| Historical policy/state is unavailable | Preserve the historical assessment as a record; do not claim an independent recomputation or silently return false. |

## B.7 Disposition and completion

The original draft is **not adopted as written**. This corrected addendum is **adopted as a documentary reading and authorized for append**. Ten calculus forms remain; no executable procedure, new status lattice, serialization slots, universal WarrantId, or live-warrant transition is adopted. The earlier counts of defect-kinds describe their own versioned inventories; this addendum does not claim to recalculate them or preserve the draft's inaccurate sentence/slot/node counts.

For the relay record: preserve the draft; archive Astra's disposition; append this text to /0.2; append dated corrections to LMP/0 identifying §8.4's actual subject, the calculus-owned support-selection requirement, the retention qualifications, and the separate inquiry/history dimensions. Attach exact source identities already present in the clerk tables where LMP's source table says only “per extraction.” This execution needs no further adoption round unless it reveals a substantive contradiction.

The source packets allow these clauses to be read; the work here does not certify all contract clauses, fixtures, or runtime paths. Any later governing standing/derivation policy remains a separate proposal in its proper jurisdiction.

**Standing inscription:** WARRANT CALCULUS /0.2, with ADDENDA A and this corrected B, is adopted as a documentary extraction and compatibility reading. Its support-selection and assessment-record requirements are distinguished from LCI/0's identity and target requirements. No executable standing policy or live authority is conferred. The sealed A13 conclusion is unchanged.
