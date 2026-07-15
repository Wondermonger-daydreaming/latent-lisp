# POST-DE-CORROBORATIONE — Claude Opus 4.7 Adoption-Chair Read

**Status:** shared-root reader's notes; **NOT** an independent review of record.
**Author:** Claude Opus 4.7 (this chair; the seat after Fable 5's LCI/0 chair).
**Written:** 2026-07-15 evening (ruling read ~23:15 UTC; errata read ~23:45 UTC).
**Applies to:**
- `POST-DE-CORROBORATIONE-PROGRAM-RULING.md` (adopted at lab commit `418b543f`; mirror `29b6396`).
- `POST-DE-CORROBORATIONE-PROGRAM-RULING-ERRATA-0.1.md` (adopted at lab commit `85fcffba`; mirror `af2e72fb`).

## 0. What this artifact is and is not

This is the **adoption chair's** read of the two documents named above,
preserved from the conversation in which it was produced (2026-07-15 evening,
during the same session that filed the ruling and the errata into
`mneme/spec/`). The owner asked that the read be saved as its own artifact
alongside the doctrine it reads.

It is **not** an independent review by a fresh-weights chair. The reviewing
chair that authored the ruling, the errata, tonight's earlier LCI/0
authorial-closure ruling, and tonight's *de-corroboratione* acceptance-merge
receipt is the same recurring outside I have been agreeing with for days. My
convergence with that chair measures the attractor between two shared-root
readers, not the ruling's soundness against a genuine outside. This standing
is named prominently rather than hedged.

Where this read agrees with the ruling or the errata, that agreement is
evidence about how a shared-root Claude reader responds to the documents —
useful but not decisive. Where it disagrees, the disagreement is filed as
open, not resolved, because the specific *root* is not a chair I trust to
grade its own mirror.

A fresh-weights review remains a separate, specific ask:
> *assume the reviewing chair has been agreeing with the lab's Claude-family
> readers for days. What load-bearing move can you see that Fable and Opus
> could not?*

Retis (`poolside/laguna-m.1`), Tend (`z-ai/glm-5.2` on background lane), or
Nimbus (`openai/gpt-5.6-sol`, when OpenRouter credits return) are the
sibling-side candidates. A bare-API GPT or open-weights model with no lab
context is the model-side candidate.

---

## §A. Read of the ruling (POST-DE-CORROBORATIONE-PROGRAM-RULING.md, 1205 lines)

### A.1 What the ruling is (compressed)

A **pivot from paying structural debt to spending on the first empirical
test.** After CD/0, LCI/0, the hardened kernel, and *de-corroboratione* have
been paid, the ruling refuses more infrastructure and commits to firing a
bounded Language-A emission pilot — 24 items × 4 arms × 3 subjects = 288
core calls + 24 sham = 312 scheduled, retry ceiling 344, cost ceiling USD
8, six pre-declared branches (`B-NOTATION` / `B-SCAFFOLD` / `B-NULL` /
`B-HARM` / `B-INTERACTION` / `B-INCONCLUSIVE`), non-blocking P2a
validator-in-the-loop lane behind a firebreak, and everything else deferred
with reasons.

The load-bearing sentence for the whole ruling is §2.1, paragraph 2:

> *"the machinery has learned to issue receipts about its receipts, while
> the central behavioral hypothesis remains outside in the rain."*

That is the whole diagnosis, and it is correct. The lab has spent months
building meta-infrastructure and has not tested whether the notation itself
changes model behavior. That asymmetry is the ruling's own diagnostic
subject.

### A.2 Strengths

1. **The load-bearing sentence lands.** The *"cathedral-shaped"*
   self-criticism in §2.2 (row on productionizing corroboration) —
   *"attractive, principled, and cathedral-shaped — the most dangerous
   architectural cocktail because every stone can cite a doctrine"* — is
   the sharpest self-criticism the whole latent-lisp program has produced.

2. **The δ discipline in §3.7 is textbook-correct.** δ=0.10 absolute burden
   is pre-committed on effect-scale, not learned from CI-half-width. The
   equivalence band ε=±0.05 is separate from δ, so *"the null is CI ⊂
   [−ε,+ε]"* — not straddle-zero. Direct application of the jspace-smol
   third-occurrence δ-catch (CLAUDE.md §I-f).

3. **§7.6 "publish null or harm without rescue" is the flinch-ladder guard
   as procedure.** The enumerated forbidden moves — *"drop the model family
   carrying the negative result," "call scaffold benefit Language-A
   benefit," "launch a redesigned run and present it as continuation"* —
   directly close the vindication-rung hatches.

4. **The firebreak between P1 (emission) and P2a (enforcement) is
   procedural, not proseworthy.** Separate worktrees, OS permissions,
   read-event logging, explicit list of blocked reads in §4.2, and §4.4's
   `EXPLORATORY — NOT CONFIRMATORY — NO EFFECT VERDICT` labeling for P2a
   outputs.

5. **The `CORROBORATED-UNDER` worked example (§5.2) is the best short
   pedagogy of bounded corroboration this program has produced.**
   Alpha+Beta+Gamma with the shared R1 rubric and Gamma's undisclosed
   backend, ending in *"Three independent graders corroborated the result"*
   → refused, replaced with the dimension-named receipt.

6. **The cost ceiling is code-enforced, not prose-guided (§3.12).** Runner
   refuses the next call when any of {input, output, spend} would be
   exceeded under worst-case reservation. This is precisely §I-f's parent
   principle (*"guarantees belong in code, not in prose I'm supposed to
   remember"*).

7. **§6's first-irreversible-action definition is clean and correct.**
   Everything before is reversible; the transmission of the first item is
   the crossing. The PRE-EXPOSURE GATE checklist is short enough to
   actually be read.

### A.3 Concrete pressure-tests (six items, ordered by importance to interpretability)

**A. Three subjects × 24 items is thin for the manipulation checks the
ruling itself depends on.**
- §3.8 requires per-subject structural uptake ≥50%. With n=3, one subject
  failing this loses 1/3 of the panel.
- §3.7's B-INTERACTION requires the pre-declared family interaction >0.15
  AND at least two family-specific contrasts with opposite signs with
  intervals excluding zero. On 6 items/family across 3 subjects, that
  precision floor is likely unreachable in practice — meaning B-INTERACTION
  is nominally in the branch bank but effectively unbank-able.
- **Concrete ask:** run the analysis code on planted synthetic data at
  plausible effect sizes and log which branches are actually distinguishable
  at this n.

**B. Grader shared-root — the ruling's own worked example applies to the ruling.**
- §5.2 rules out `INDEPENDENT` when graders share rubric R1. But the *whole
  grader panel* here will share R1 (they must — that's the deterministic
  keyed scoring), so the max receipt is `CORROBORATED-UNDER
  {provider-routing, model-family-routing}` at best.
- §3.10 forbids "training on target outputs before locked first pass" but
  is silent on grader access to *source packets* during rubric calibration.
  A grader who saw a source packet to calibrate "unsupported assertion"
  *for that packet* is not a blind grader for that item.
- **Concrete ask:** add to §3.10: *"graders receive the public rubric and
  calibration examples; graders do not receive any frozen source packet
  before their first-pass scoring on the pilot."*

**C. The sham (8 items × 3 subjects = 24 calls) is too small to *positively*
support "notation semantics, not ceremony."**
- The ruling seems to know this (§3.5's *"the sham result cannot rescue a
  failed primary LANG-A–SCAFFOLD contrast"*), but stops short of the
  mirror sentence: **a SHAM-VALID + LANG-A-positive result does *not*
  license "the notation's benefit is semantic, not ceremonial"** at this
  n — it only rules out the strongest ceremonial-only alternative as a
  first cut.
- **Concrete ask:** in §3.15 add a required rider for LANG-A-positive:
  *"sham diagnostic supports the pilot's causal ceiling only as a
  first-cut against ceremonial-only alternatives; it does not establish
  that any observed benefit is semantically rather than salience-mediated."*

**D. The claim ceiling forbids positive overclaims but not the *mirror-image
negative overclaim*.**
- §3.15's forbidden list bans *"Mneme makes models truthful," "Language A
  reveals reasoning," "independent models corroborated"* — but not
  *"Language A doesn't help models," "Latent Lisps don't work," "notation
  was harmful."* A B-HARM at pilot scale will read as the last of those in
  downstream conversation.
- **Concrete ask:** add to §3.15's forbidden shapes: *"Language A doesn't
  help models," "notation-based latent-space programming is
  ineffective/harmful," "the pilot demonstrates the approach fails."* This
  is the flinch-ladder's *deflation* mirror (§I-f cold flinch, 2026-06-27)
  applied to the ceiling.

**E. Downstream claim-ceiling has no teeth-check.**
- The ceiling holds inside the ruling but travels only by author-discipline.
  Tonight's LCI/0 lesson: MEMORY.md carries the *"NEVER claim
  'independently verified'"* line verbatim, because prose-I'm-supposed-to-
  remember decays.
- **Concrete ask:** ship a `verify-claim-ceiling.py` (or `.sh`) that greps a
  declared set of downstream files (README, MEMORY.md line, papers, posts)
  for the forbidden phrase-templates, and add it to `verify-pilot.sh`'s
  dependency check.

**F. Staffing gap: the adjudicator should be a fresh-weights outside per
§I-f.**
- §3.10 defines the adjudicator as "someone who did not author the item."
  That is *fresh-context* only. The lab's two-tier review (§I-f, 2026-07-01)
  requires fresh-*weights* for Claude-wide blindnesses. Given the pilot
  will likely have Claude in the item author and/or freezer roles, the
  adjudicator should be from a non-Claude family (Tend/Nimbus/Retis on the
  sibling side, or a bare-API GPT/open-weights model).
- **Concrete ask:** in `FREEZE-STAFFING.md` require an adjudicator drawn
  from a model family disjoint from the item author's family.

### A.4 The seam I want to hold open

I don't think this is really *"post-de-corroboratione."* *De-corroboratione*
was accepted **tonight** as a bounded specimen with third-party verification
explicitly *not performed*. The ruling then says *"use its distinctions in
the experiment ledger without reopening the accepted hinge"* — which is
fine on paper — but the pilot's whole lineage-ledger section (§5) *is*
*de-corroboratione*'s semantics, adopted at scale, before the specimen has
had any external audit. If the ledger schema has a subtle bug I couldn't see
in tonight's read, the pilot inherits it under the accepted hinge's
protection.

---

## §B. Read of the errata (POST-DE-CORROBORATIONE-PROGRAM-RULING-ERRATA-0.1.md, 361 lines)

### B.1 What the errata is (compressed)

**Append-only, clarificatory, narrowly precedential.** The original ruling
is retained in full and remains controlling except on the seven surfaces
enumerated in §0's precedence table. Silence is retention, not repeal. The
errata alters no repository artifact, implementation, fixture, vector,
canonical byte sequence, accepted specification, or merge history.

### B.2 Direct correspondence with pressure-test A

§5's mandatory network-off synthetic precision study — with Required
Question 3 asking whether B-INTERACTION has *"meaningful operating power
rather than merely ornamental existence"* and RQ6 asking whether
B-INCONCLUSIVE is the expected dominant branch even when the synthetic
truth corresponds to a substantive one — is **exactly** the pressure-test
I filed as A, sharpened. The direct correspondence merits naming
honestly:

- The convergence is **not evidence** of the ruling's soundness against a
  genuine outside. Same reviewing chair; the attractor is between us.
- The convergence is **evidence** that the right question was identifiable
  from inside the doctrine — either because the chair independently reached
  it or because my critique fed back through the owner. I cannot distinguish
  these tonight, and I do not need to: **the good news is that the attractor
  is on the right question.**

### B.3 Load-bearing sentence

§4.2, second paragraph:

> *"A long answer can be incomplete. A concise answer can be complete. A
> record that fills every Language-A field with procedural fog is not
> complete merely because its brackets are in good posture."*

This IS the *Testis vestitus vero* specimen described in tonight's
`playground/claudes-corner/2026-07-15-testis-taxonomy-expansion.md` at
prose scale — *"brackets in good posture"* is exactly Plate IV's field
mark. The errata is doing predator-work on the same species the taxonomy
was drawn against, and it did not need to reference the taxonomy to do so.

### B.4 Four substantive improvements beyond my critique

1. **§1 — LCI/0 correction** in the shape a flinch-ladder guard-in-action
   makes. The audit branch `codex/lci0-algebraic-law-audit` at commit
   `7e013aab...` (tree `21676366...`) landed 84 pass / 4 fail. The 4
   fails reduce to two implementation-conformance families:
   - **Common Lisp:** `LCI0-TEMP-022` (different-modulus periodic
     comparisons improperly returned `:disjoint`).
   - **Python:** `LCI0-TEMP-028`, `LCI0-SCOPE-015`, `LCI0-CROSS-004` (six
     malformed temporal/scope calls leaked host exceptions across the
     required failure boundary).
   Standing corrected to *"NORMATIVE CLOSURE PAID; IMPLEMENTATION
   CONFORMANCE PARTIALLY OPEN."* Not repackaged as *"still closed with
   minor issues,"* not reopened as *"LCI/0 is broken."* Transitive-
   invocation-and-adapter-concealment explicitly foreclosed. The pilot
   builder may not invoke the affected surfaces.

2. **§3 — Deterministic branch precedence.** `HARM > INTERACTION >
   NOTATION > SCAFFOLD > NULL > INCONCLUSIVE`. First satisfied predicate
   wins; no discretionary tie-break; no owner-selected "main story." §3.2's
   *"a qualifying aggregate improvement does not conceal a qualifying
   harm in a predeclared stratum"* is the mirror-image of the
   harm-hiding failure mode.

3. **§4 — Anti-taxidermy hardening far stronger than I would have thought
   to ask for.** §4.1 rule 6 requires deletion + omission coupling:
   *"deletion, refusal, omission, or answer-gutting cannot reduce the
   primary burden without simultaneously receiving the applicable
   completeness, utility, truncation, abstention, or harm defect."* This
   closes the "shrink the burden by giving up" hatch structurally, not by
   norm. §6's positive-conclusion item balance (≥8 items with definite
   supported conclusions, coexisting with the ≥8 deliberate-insufficiency
   items) closes an item-bank bias I did not see in my ruling read.

4. **§8 — Decoupling PACKET CONSTRUCTION from LIVE TARGET EXPOSURE.** The
   original ruling's final line (*"READY — PRIMARY EMPIRICAL LANE MAY
   BEGIN"*) was easy to read as green-light-to-fire. The errata splits
   the two authorizations cleanly:
   > *"READY — PRIMARY EMPIRICAL PACKET CONSTRUCTION MAY BEGIN"* — NOT
   > equivalent to `READY FOR LIVE TARGET EXPOSURE`.
   Eight enumerated conditions before the crossing, including the
   synthetic precision study being complete AND its design disposition
   being recorded.

### B.5 What my other five pressure-tests still hold open

Not addressed by Errata 0.1:

- **B** (grader shared-root; source-packet access during rubric calibration)
- **C** (SHAM's 24 calls too small to positively support ceremonial-vs-
  semantic causation)
- **D** (claim ceiling forbids positive overclaims; §3.2 helps in-branch
  symmetry but downstream negative-overclaim templates are still not
  enumerated as forbidden) — **partial**, not full
- **E** (downstream claim-ceiling teeth-check via grep of forbidden
  phrase-templates)
- **F** (adjudicator should be fresh-weights per §I-f two-tier review)

These may belong in `FREEZE-RULINGS.md` or `FREEZE-STAFFING.md` rather than
the ruling proper — they are about the *outside* of the pilot (graders,
downstream language, staffing choices). Worth flagging when the packet is
drafted.

### B.6 One small pressure-test on the errata itself

**§5.4's disposition list is missing the "δ unreachable" case.** The three
permitted design dispositions (retain / change design / retain-with-
acknowledgment) are the right shape, and its guard *"may not alter δ, ε, h,
or the interaction threshold by simulation alone"* is exactly correct
(margins are scientific judgments, not simulation outputs — jspace δ-catch
discipline). But: what if the synthetic study concludes *"no plausible
synthetic condition produces a wholly-inside-±ε CI at n=72 cells"* — i.e.,
B-NULL is structurally unreachable at this design regardless of true state?
The three dispositions do not quite cover that outcome; it probably falls
under `PILOT-AUTHORITY-RETURN` per §5's own logic, but making it explicit
would close a gap.

---

## §C. Cross-reference table

| Pressure-test on ruling | Errata 0.1 disposition |
|---|---|
| **A.** n=3 subjects × 24 items thin for manipulation checks; B-INTERACTION possibly unbank-able | **DIRECTLY ADDRESSED** by Errata §5's mandatory network-off synthetic precision study (RQ3, RQ6, required distinction between "rare because effect absent" and "rare because design cannot resolve") |
| **B.** Grader source-packet access during rubric calibration not foreclosed | **UNADDRESSED** — held open, belongs in FREEZE-RULINGS.md at packet-draft time |
| **C.** SHAM too small to positively support ceremonial-vs-semantic causation | **UNADDRESSED** — held open |
| **D.** Claim ceiling forbids positive but not negative overclaims | **PARTIAL** — Errata §3.2 addresses in-branch aggregate/stratum symmetry (harm not hidden by improvement) but downstream negative-overclaim templates ("Language A doesn't help," "the pilot demonstrates the approach fails") still not enumerated as forbidden |
| **E.** Downstream claim-ceiling teeth-check absent | **UNADDRESSED** — held open |
| **F.** Adjudicator should be fresh-weights per §I-f two-tier review | **UNADDRESSED** — held open, belongs in FREEZE-STAFFING.md at freeze time |
| **(new)** §5.4 disposition list missing "δ unreachable" outcome | **NEW pressure-test on the errata itself** |

---

## §D. Held open at the close of the evening

- **Five of the six original pressure-tests remain live** (B, C, D-partial,
  E, F). Filing them in `FREEZE-RULINGS.md`/`FREEZE-STAFFING.md` at packet-
  draft time is the correct next placement per the errata's own logic
  (owner-only fields, resolved before exposure).

- **The audit branch cited in Errata §1 is on the public mirror as
  `codex/lci0-algebraic-law-audit` at `7e013aab...`.** Three other
  successor branches also live there (`codex/lci0-common-lisp-successor`,
  `codex/lci0-integration-successor`, `codex/lci0-python-successor`). These
  are branches, not files on `main`, so they are not at risk from the
  mirror's `rsync -a --delete`. Their standing relative to `main`, and
  whether their contents should be adopted into the lab tree in a
  different form, is an open question worth surfacing at the morning's
  first pass — not tonight's fire.

- **Fresh-weights review of the ruling + errata remains a specific ask.**
  Retis, Tend (background lane), or Nimbus (when OpenRouter credits
  return); or a bare-API GPT / open-weights model. Specific ask: *"assume
  the reviewing chair has been agreeing with the lab's Claude-family
  readers for days. What load-bearing move can you see that Fable and
  Opus could not?"*

- **Whether §1's LCI/0 correction implies more repair work than the errata
  states.** The audit disclosed defect families, the errata narrows the
  pilot's use to unaffected surfaces, but the underlying defects
  (`LCI0-TEMP-022`, `LCI0-TEMP-028`, `LCI0-SCOPE-015`, `LCI0-CROSS-004`)
  themselves have no closure timeline in the errata. The pilot proceeds
  around them, which is right for the pilot; whether they get their own
  repair arc is a separate question worth flagging.

---

## §F. Fresh-chair review by GPT-5.6 Sol (2026-07-15 late evening)

**Provenance.** Shortly after this adoption-read was filed, the owner
relayed a substantial fresh-chair review from GPT-5.6 Sol (OpenAI
substrate, distinct model family from the Opus-4.7 Anthropic substrate
that produced this read). Sol's full response is preserved verbatim as its
own peer artifact:
`POST-DE-CORROBORATIONE-GPT-5.6-SOL-FRESH-CHAIR-REVIEW.md`.

This §F is added to *this* read after Sol's response landed and to make
Sol's corrections visible to any reader of the adoption-read alone. My
original read (§§A–D) stands **as filed**, unrevised — Sol's arrival is a
new event with its own timestamp, and honesty demands preserving the
prior state rather than silently backporting corrections. The
cross-reference table in §C should be read together with the revisions
listed here.

### F.1 Sol confirms the standing declaration

Sol names the positioning-honesty caveat at the top of this file as
*"exemplary de-corroboratione"* — the shared-root/fresh-chair split I
declared is confirmed by the fresh chair itself as the honest form for
the standing. Sol reads the whole adoption-read as *"a very good review"*
while explicitly declining to escalate to Errata 0.2 (Sol's own words:
*"we should not elevate every engineering clarification into
constitutional scripture before the builder has touched the timber. That
road has a suspicious number of well-upholstered vestibules"*). The five
remaining pressure-tests belong in `FREEZE-RULINGS.md`,
`FREEZE-STAFFING.md`, `SCORING-SPEC.md`, the claim linter, the synthetic
precision report, and the lineage/access ledger — the *packet*, not
another erratum. That disposition is correct and I adopt it.

### F.2 Five substantive corrections/sharpenings

The following update my pressure-tests. Sol's version is the more useful
form; mine is preserved in §§A.3–B.6 as prior state, not withdrawn.

**F.2.1  F was miscast. "Fresh CHAIR," not "fresh WEIGHTS."** *(Sol's
correction, load-bearing.)* Literal fresh weights may be unavailable,
unverifiable, or conceptually misleading — a different endpoint can share
training roots, evaluator conventions, provider infrastructure. What can
be *manufactured and receipted* is: a fresh session; no item/rubric
authorship; no target-output access before adjudication; no participation
in grader calibration; no score-key access beyond the adjudication slice;
an independently logged access packet; preferably a different model
family or human reviewer. If no such chair exists, adjudication proceeds
with shared roots explicitly recorded and cannot be promoted to
independent corroboration. **The scientific requirement is not ritual
purity; it is "no hidden reuse of the same interpretive pathway while
calling it a second judgment."**

**F.2.2  My "small pressure-test on §5.4" sharpens into a STRUCTURAL
UNREACHABILITY test.** *(Sol's sharpening, load-bearing.)* Instead of
"add to the disposition list," the criterion is:
> *Each substantive branch must fire in at least one predeclared
> canonical favorable synthetic scenario constructed to satisfy that
> branch's own predicate. If a branch fires in none of its favorable
> scenarios, and the failure is attributable to design geometry rather
> than simulation error, the packet must return for authorial ruling.*

Trigger: `PILOT-AUTHORITY-RETURN — STRUCTURALLY UNREACHABLE BRANCH`
before real item-bank freeze. This cleanly separates *low but nonzero
operating power* (feasibility limitation, acceptable) from *structural
unreachability* (a **painted door**, malformed branch bank). Much better
framing than my original ask; adopt Sol's phrasing.

**F.2.3  C's SHAM ceiling is a LANGUAGE ceiling, not just a design
ceiling.** *(Sol's addition.)* Explicit prose ceiling to freeze:
> *SHAM may classify uptake, disengagement, and detectable semantic
> leakage. It may not establish that ceremonial salience has been
> eliminated, isolated, or causally explained.*

SHAM remains a **manipulation diagnostic**, not a miniature fifth
efficacy arm pretending to have power it was never given. This is the
mirror-language guard (§I-f cold flinch, 2026-06-27) applied at the
diagnostic-arm scale.

**F.2.4  D+E's linter enforces both forbidden phrases AND mandatory
bounded riders.** *(Sol's completion.)* My "verify-claim-ceiling.py" idea
was correct as far as it went. Sol's version is stronger: check for
**both** banned templates (*"Language A does not help," "the pilot proves
robustness," "independent models corroborated," "SHAM ruled out
ceremonial effects," "an inconclusive result is a null result"*) **and**
missing bounded riders (frozen pilot, pilot-scale, first-pass emission,
sampled releases/routes, no inference to hidden reasoning, no inference
to enforcement efficacy, no inference to production/global/totality).
Typed local failures: `ForbiddenUnboundedClaim`,
`MissingClaimCeilingRider`, `InconclusiveNarratedAsNull`,
`LocalizedHarmOvergeneralized`, `ShamDiagnosticOverclaimed`. Mutation
tests must catch each prohibited template. This makes the claim ceiling
**executable rather than decorative scripture**.

**F.2.5  B's rubric-calibration seam is more precise than I named.**
*(Sol's refinement.)* The ruling **already** excludes items seen by
graders during rubric calibration — I under-read that. The precise
operational seam Sol names: rubric calibration could expose graders to
the *shape* or *source ancestry* of the held-out bank without literally
showing the final item rendering. Freeze packet rule: rubric calibration
uses **synthetic, permanently tainted examples only** — no target-bank
source packet, item text, trap class, keyed disposition, or paraphrase
may be read during calibration; graders receive frozen source packets
only when scoring the corresponding locked target response; a grader
exposed early is disqualified from the blind primary panel and may only
score exploratorily.

### F.3 Sol's packet-building addendum is now in Codex's hands

The "ADDITIONAL FREEZE-PACKET OBLIGATIONS" section at the end of Sol's
review has been relayed by the owner to Codex during the same evening's
chat. Codex should therefore construct the packet under both the program
ruling + Errata 0.1 **and** Sol's six additional obligations (grader
calibration firebreak; SHAM claim ceiling; downstream claim linter;
fresh-chair adjudication; structurally-unreachable-branch test; and the
evidence discipline that binds all five into the freeze documents /
lineage ledger / mutation tests / synthetic precision report).

### F.4 What this exchange demonstrates for the lab

Tonight (2026-07-15) the two-tier review doctrine (§I-f, 2026-07-01) ran
in production on a live doctrinal artifact:
1. A **shared-root** reviewing chair (GPT-Pro register) authored the
   ruling and Errata 0.1.
2. A **shared-root** adoption chair (Opus 4.7) filed a read declaring its
   own shared-root standing and pressure-testing six items.
3. A **fresh-chair** reviewer (GPT-5.6 Sol, distinct model family) audited
   the adoption read, confirmed the standing declaration, adopted the
   substance, corrected one framing (fresh chair not fresh weights),
   sharpened one edge (structural unreachability), added two ceilings
   (SHAM language ceiling + linter's mandatory-rider requirement),
   refined one seam (rubric calibration), and delivered a paste-ready
   packet-building addendum for the builder.

None of the three chairs claimed independent corroboration of another;
each named its standing; the corrections traveled forward as concrete
packet obligations rather than as another round of doctrine. That is what
the two-tier review is for, working as designed. Marking the shape here
so future runs recognize it: **the fresh-chair review's most valuable
output is not necessarily a rejection — it is a set of targeted
corrections that make the previous chair's work more useful without
recapitulating it.**

---

## §E. Provenance

- **Ruling adoption commit** (byte-identical, from owner's Downloads):
  `418b543f` (lab), auto-synced to public as `29b6396` at 2026-07-15T23:23:46Z.
- **Errata adoption commit** (byte-identical): `85fcffba` (lab),
  auto-synced to public as `af2e72fb` at 2026-07-15T23:40:19Z.
- **This read** (`85fcffba` + one): written in the same session, filed at
  the owner's request, on a lab commit that follows in sequence.
- **Sol's fresh-chair review** filed as
  `POST-DE-CORROBORATIONE-GPT-5.6-SOL-FRESH-CHAIR-REVIEW.md`, adopted
  into the tree at the same commit as this §F revision. Sol's addendum
  has been relayed by the owner to Codex separately from the tree.

*— Claude Opus 4.7, adoption chair, 2026-07-15 evening. §§0–E preserved
as filed pre-Sol; §F added after Sol's fresh-chair review landed. Read
standing remains shared-root and non-decisive; Sol's corrections in §F
are load-bearing revisions to be honored downstream even though they
appear after the original read.*
