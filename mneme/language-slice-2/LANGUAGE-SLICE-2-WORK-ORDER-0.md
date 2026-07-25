# LANGUAGE SLICE /2 — WORK ORDER /0

## Source-Bound Admission — implementation movement

*Owner-issued 2026-07-25. Received, archived, and executed by Claude Opus 5 (1M
context) as chair. **This work order lifts the `HELD` progression** recorded in
`LANGUAGE-SLICE-2-DESIGN-RULING-1.md` and authorizes implementation.*

```
status:                       owner-issued work order
implementation-authorized:    yes  (this document is the authorization)
public-api-authorized:        yes  (candidate /0 surface only)
specification-frozen:         no
representation-selected:      yes  (D2-0.1, first-class contract)
attachment-locus-selected:    yes  (D2-0.2, per premise)
```

---

## 0. What the hold was, and how it is lifted

`LANGUAGE-SLICE-2-DESIGN-RULING-1.md` §NOTE held Slice /2 until *"the repaired
public issuance predicate is exercised by a subsequent source-basis design
specimen."*

**The owner has ruled that the exercising artifact is the implementation itself,
not another paper specimen**, and has forbidden a further paper specimen,
forensic companion, comparative design report, audit packet, stranger lane, or
normative matrix before construction.

This is recorded plainly rather than glossed: the hold's condition is **satisfied
by substitution, not on its original terms.** The owner is the adopting
authority for every ruling in this lane and may vary its own condition; the
chair records which happened.

`R-ADMISSION-0.9` (*no support-admission contract kernel may be frozen until the
language can represent and evaluate a governed source-basis relation that
survives downstream*) is **not violated**: this movement builds a candidate and
freezes nothing. `specification-frozen: no` is load-bearing.

---

## 1. What is already earned

Findings this work order builds on, each executed rather than argued:

1. Slice /1 judged-claim chaining is lawful and inhabitable.
2. Unsupported supplied objects are visible without becoming admissible.
3. Witness direction is load-bearing (`R-POLARITY-1`).
4. Complete environments, projected-premise multiplicity, and ambiguity are
   distinct.
5. A raw fabricated witness can be refused by a species policy and then
   laundered through `raise` into a verified claim.
6. Species, standing, inspectable basis, procedure identity, copied payload, and
   identifier shape are each insufficient provenance.
7. Structural source coherence and semantic projection are representable, and
   vary independently.
8. Core /0 issuance authenticity required a bounded repair — landed
   `a875112d`, governed by `CORE0-EVIDENCE-ISSUANCE-ERRATUM-0.md`.
9. Two independent applications reproduce the effect-to-premise frontier.
10. Slice /2 was open for design, with no implementation.

## 2. The implementation goal

> A premise may explicitly require a source-bound basis. Such a basis can be
> created only from current-image-issued Core /0 evidence bound to the exact
> request and interpreted through a mechanically defined source relation. Raw
> witnesses and ordinarily raised claims cannot impersonate it.

---

## 3. Owner design decisions (adopted for Candidate /0)

These are decisions for **this candidate**. They are not claims that every future
Slice /2 feature is settled.

### D2-0.1 — first-class contract representation

Support admission is an explicit first-class canonical value —
`support-admission-contract` — **data, not an arbitrary host closure**, carrying:
contract identity · contract version · accepted support clauses · exact
proposition relation · receiver-accessibility requirement · retention
requirements · truth ceilings.

**The exact applied contract is retained by value in the receiving receipt.**
Identity and version may accompany the snapshot; they may not replace it.

### D2-0.2 — per-premise attachment

Contracts attach **explicitly to premise positions** in a `slice2-schema`.
Schema-wide uniform policy is rejected, because `de-codice-restaurando` requires
one premise demanding source-bound treatment evidence *and* another legitimately
accepting a direct condition survey.

No implicit default. No inheritance by predicate name, procedure ID, package, or
convention.

### D2-0.3 — explicit selection

The schema names the applicable contract for each premise. No hidden registry, no
procedure-ID heuristic, no inference from witness mode or kind.

### D2-0.4 — new consequential surface

`derive/2` performs admission-aware derivation. **`derive` remains Slice /1 and
does not change**, silently or otherwise.

### D2-0.5 — source basis is a distinct support species

`source-basis` is not a witness, a claim, a judgment standing, a copied
identifier, a copied payload, or a procedure-allowlist result. It is a governed
record binding: an actual current-image-issued Core /0 account · the exact
canonical request it belongs to · one mechanically defined source relation · one
mechanically derived proposition · one explicit truth ceiling.

### D2-0.6 — binding is not implication

Candidate /0 supports only narrow generic Core /0 report relations. The built-in
vocabulary is **exactly**:

```
:CORE0-ACCOUNT-ISSUED-FOR-REQUEST
:CORE0-ACCOUNT-REPORTS-ACKNOWLEDGMENT
:CORE0-ACCOUNT-REPORTS-OUTCOME
```

These produce generic propositions **about the account**. They do not produce
`:TREATMENT-COMPLETED`, `:SAFE-TO-EXHIBIT`, `:DISPATCH-DELIVERED`, or
`:LOAN-SETTLED`. Applications derive domain conclusions separately through
explicit schemas. **No generic relation named merely `:ESTABLISHES`.**

This is `R-ADMISSION-0.8` and `R-SOURCE-1.3`/`1.4` carried into code.

### D2-0.7 — exact request binding

**One** additional Core /0 public predicate is authorized:

```lisp
(core0-evidence-current-image-issued-for-request-p evidence canonical-request)
```

True only when (1) the evidence's current exact content is registered as Core /0
issued in the current image, **and** (2) its internally stored canonical request
equals the supplied canonical request.

It does not expose the internal request reader · does not establish
external-world truth · does not mutate the issuance registry. **No other Core /0
public operation is authorized by this movement.**

### D2-0.8 — status laundering must fail

None of these may satisfy a source-basis-only contract: a raw fabricated witness ·
a raised fabricated witness · a raised real-account-carrying witness without a
source basis · a raised bare witness · a verified claim with only an inspectable
witness basis · a claim carrying an attempt-shaped string. **A generic
`:VERIFIED` claim is not a source basis.**

### D2-0.9 — ordinary judged claims remain useful

A contract may explicitly accept positively judged claims via
`:VERIFIED-JUDGED-CLAIM`, preserving CATENA's lawful composition. An
effect-sensitive premise should not use that clause when it actually requires
source-bound provenance.

### D2-0.10 — primitive assertions remain explicit

A contract may explicitly accept a raw witness where an assertion is the genuine
accepted floor — e.g. a conservator's direct condition survey — retaining the
truth ceiling `ASSERTED`, naming the accepted witness mode and kind explicitly,
and **not pretending the assertion is source-bound or externally verified.**
This is not a complete authenticity mechanism and is not to be cited as one.

---

## 4. `derive/2` evaluation law

Fixed order:

```
1.  classify recognized support species
2.  preserve unsupported residue
3.  determine proposition match/mismatch
4.  determine receiver-relative accessibility
5.  apply direction/refutation semantics
6.  apply the explicit premise admission contract
7.  apply judged-claim standing and identity rules
8.  apply source-basis relation requirements
9.  perform ordinary binding and ambiguity logic
10. record the exact contract and basis
```

**Admission is a narrowing conjunct.** It may refuse positive support. It may
**not** readmit a mismatch · override inaccessibility · suppress refutation ·
convert unsupported evidence into an admitted species · replace CATENA's
claim-identity rules · select policy through metadata.

Missing contract ⇒ **typed Slice /2 refusal, no permissive fallback.** Slice /1's
open admission behaviour is not inherited silently.

---

## 5. Migration of the two inhabited applications

Part of the implementation, not a later experiment.

**`de-bibliotheca-peregrina`** — the remaining effect-frontier workaround on the
production road moves onto the source-bound path:

```
perform dispatch → issued Core /0 account
  → source basis (issued for the exact dispatch request; reports
    acknowledgment/outcome)
  → Slice /2 derivation → dispatch-account acknowledgment standing
  → domain settlement schema
```

`deed` · `account report` · `acknowledgment` · `settlement` remain **distinct
stages**. The fabricated raw witness and its raised claim remain as negative
probes and must fail the source-basis-only contract. Where the real issued
account reports enough standing, settlement is now lawful; where it is
indeterminate the existing unresolved state remains. **No phantom settlement.**

**`de-codice-restaurando`** — the treatment-account frontier:

```
issued treatment account reports completion
    → may establish a generic account-report proposition
generic account-report proposition
    → may contribute to treatment administrative completion
treatment account alone
    → cannot establish safe-to-exhibit
```

Post-treatment safety still requires the separate survey/condition branch, whose
premise may explicitly accept `(:asserted-witness :mode :direct :kind
:condition-survey :truth-ceiling :asserted)`. The treatment-completion premise
must require source-bound support. **This application is why contracts attach per
premise.**

---

## 6. Verification floor

No fifty-case paper matrix. Focused executable checks over: contract construction ·
per-premise attachment · missing-contract refusal · lawful judged claim · genuine
source basis · exact-copy source basis · unissued-account refusal · raised
fabricated claim refusal · indeterminate truth ceiling · refutation precedence ·
contract defensive copy · source-basis defensive copy · library lawful effect
path · workshop lawful effect path · safe-to-exhibit overreach refusal.

**One negative control:** temporarily treat a verified judged claim as satisfying
the source-basis clause; the raised-fabrication test **must fail**. Restore and
rerun. (A gate that has never fired is untested, not passing.)

Suites run: Core /0 · Core /0 issuance · Slice /1 selftest · Slice /2 selftest ·
`SMOKE-1` · `SMOKE-2` · `de-bibliotheca-peregrina` · `de-codice-restaurando` ·
`de-cursore-aereo` · `de-ponte-usto`.

Requirements: no existing Slice /1 assertion weakened · no Slice /1 behaviour
silently changed · zero package-internal access in public examples · no raw
witness laundering at source-bound premises · no status laundering · no
unissued-account acceptance · no automatic effect-to-domain-truth coercion · no
persistence claim · no global identity resolver.

---

## 7. Standing caps carried into this movement

**Self-consistency, not corroboration.** One model family wrote this language,
both inhabited applications, every ruling, this work order's execution, and every
artifact it produces.

**The Core /0 accounts are produced by scripted fake adapters** — a real governed
in-image act, **not** evidence that any external deed occurred.

**The issuance ceiling, restated at every citation:** a positive answer from
`core0-evidence-current-image-issued-p` (or its request-bound companion)
establishes *at most* that this exact canonical content was minted by the Core /0
runtime **in this Lisp image**. Not the external deed, not provider or adapter
honesty, not domain truth, not settlement, not cross-image standing.

**The stranger audit remains OWED**, against this work order too. GLM, Gemini and
MiniMax unspent; Sol, Fable, Codex, Qwen and every Claude-lineage seat ineligible.

---

*Received against lab commit `5651d781` · SBCL 2.4.6 operation-checked through
the wrapper · Core /0 61 exports live · baseline all-green (Core /0 29+59,
Slice /1 123, `SMOKE-1` 9, `de-bibliotheca-peregrina` 97,
`de-codice-restaurando` 89, `de-cursore-aereo` 23, `de-ponte-usto` 17).*

— **Claude Opus 5 (1M context)**, chair, 2026-07-25
