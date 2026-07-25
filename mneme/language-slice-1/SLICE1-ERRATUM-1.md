# SLICE /1 — ERRATUM 1

*Chair: **Claude Opus 5 (1M context)**, 2026-07-24. Issued under the owner's
cold-audit relay, which authorized "exact adjudicated documentation
corrections for B3–B5" as part of one bounded erratum cycle.*

**This document GOVERNS.** Where it corrects a statement in the charter, the
guide, the API brief, the architecture record, or the closure, **this text
controls and the original is superseded** — the originals are left in place
unaltered so the record of what was believed, and when, survives. That is the
lane's own practice (`CHARTER-DELTA-1` supersedes by naming; the Errata block
records code-forced departures).

Adjudication and evidence: `SLICE1-KIMI-COLD-AUDIT-CHAIR-ADJUDICATION.md`.
Applied code repair: commit `f878cae1` (defects B1/B2).

---

## E1 — Receipt scope: "every attempt" is CORRECTED to "every assessed derivation"

**Superseded (nine statements, all unqualified):** `LANGUAGE-SLICE-1-CHARTER.md`
§6 heading and body, §7 step 5 · `LANGUAGE-SLICE-1-API.md` §5 (`derive`) and §6
heading · `LANGUAGE-SLICE-1-GUIDE.md` closing · `LANGUAGE-SLICE-1-CLOSURE.md`
disposition line `:derivation-receipts :earned` ·
`LANGUAGE-SLICE-1-ARCHITECTURE.md` §7 stratum-1 definition · and the code's own
`ALWAYS` at `slice1.lisp:854` and `:950`.

**Corrected text.** A `derivation-receipt` is issued on **every derivation that
reaches premise assessment** — that is, on both outcomes (`:granted` and
`:refused`) of a `derive` call whose conclusion is a lawful ground proposition
and whose schema resolved. It is **NOT** issued on the four pre-assessment
exits, which signal with `slice1-condition-receipt` = NIL:

| Pre-assessment exit | Signalled at |
|---|---|
| `pattern-used-as-ground` | `slice1.lisp:954` |
| `schema-not-found` | `slice1.lisp:955` |
| `malformed-structured-proposition` (malformed `:conclusion`) | `slice1.lisp:956` |
| `unbound-conclusion-variable` | `slice1.lisp:961` |

**Naming all four is the point of this erratum.** The cold audit reported two;
there are four. Any future statement of the receipt promise that names fewer
than four is wrong again.

**Basis for correcting the documents rather than the code:** `API`'s own
per-condition table already marks receipt-carriage on exactly one row
(`derivation-refused`) and annotates none of the others; and the charter's §7
numbers receipt issuance as step 5, after schema resolution (step 1) and
conclusion binding (step 2). The authors' operative sense of "attempt" was a
derivation that got as far as assessment.

**DOCKETED, NOT DECIDED — owner question.** For `schema-not-found` and
`unbound-conclusion-variable` a receipt **is constructible** on the document's
own field semantics (`API` defines the receipt's schema-name field as the
*requested* name). Whether those two should carry receipts is a **capability**
question, deliberately not answered here. The other two exits are genuinely
pre-receipt: no lawful conclusion normal-form exists to record.

## E2 — Flow-through universality: CORRECTED; a constructor defect is recorded

**Superseded (five statements asserting universal flow-through):**
`CHARTER` §1 (*"every structured proposition **is** a lawful Slice /0
proposition … backward compatibility by construction, not by adapter"*) ·
`ARCHITECTURE` §2 · `API` standing note 2 · `API`'s `proposition` entry ·
the `proposition` docstring at `slice1.lisp:255-257`.

**Corrected text.** Every structured proposition **whose values are
boundary-lawful** is a lawful Slice /0 proposition and flows unchanged through
`claim`, `witness :for`, testimony, and projection. **This is currently FALSE
for `(:quoted-datum FORM)` with a non-boundary payload.** At least three payload
classes construct in Slice /1, satisfy `normal-form-p`, and are then refused at
the frozen Slice /0 gate with `malformed-slice0-shape`:

- a **float** — `(:quoted-datum 1.5)`
- a **bare symbol** — `(:quoted-datum some-bare-symbol)`
- a **dotted list** — `(:quoted-datum (a . b))` *(not reported by the audit; found in chair reproduction)*

All three are named elsewhere in `API` as refusals of `proposition` itself.

**Standing [chair ruling]: this is a Slice /1 CONSTRUCTOR DEFECT, not a
licensed breadth.** No document in this lane — charter, either delta, guide,
API, architecture, closure, work order, audit, or inventory — authorizes a
deliberately broader intermediate language; five assert the opposite, two of
them written after the code existed. `CHARTER-DELTA-1` Δ5 introduced the
`(:quoted-datum …)` escape with a stated **purpose** (protect var-shaped
literals) and **no stated payload domain**, and did not reconcile the widening
with §1's law.

**DOCKETED, NOT REPAIRED — owner authorization required.** The fix is a payload
restriction to boundary-lawful values at `slice1.lisp:174-176` (one clause);
Δ5's purpose is fully served without admitting floats, bare symbols, or dotted
lists. A constructor semantic change was outside the relay's authorized repair
list, and the chair did not take it.

## E3 — Already-judged claims as premise support: an UNCONVERTED design obligation

> **⚠ E3 IS DISCHARGED (2026-07-24), UNDER `SLICE1-SOL-DESIGN-RULING-FORKS.md`
> DECISION 1 — adopted by the owner.** The obligation recorded dead below was
> converted, and its standing is now:
>
> ```text
>  :judged-claim-premise-discharge      :earned  ; judgment-identity chaining, slice1.lisp; teeth T29a–T29j (slice1-selftest.lisp); bite-before-cure transcript _staging/catena-teeth-evidence.txt
> ```
>
> **What was implemented — the ruling's reading, not the chair's.** A previously
> judged claim discharges a premise **only through an identity-bearing reference
> to the actual governed judgment**: durable claim identity · receiver-accessible
> under the already-governing rule · positive `:verified` judgment · normalized
> judged proposition matching the required ground premise · the judgment record
> read off *that exact claim* · claim identity **and** judgment basis recorded in
> the receiving derivation's receipt · the original judgment left inspectable and
> never converted into a newly minted witness. **The chair's α3 recommendation
> (schema conclusion-pattern equality via `procedure-id`) was REJECTED by the
> ruling as smuggling a source-type system into a language with no
> representation for one, and is NOT what was built:** `procedure-id` is recorded
> provenance and is read by nothing. There is **no** mode/kind relation and **no**
> recursion.
>
> **The three answers the docket asked for**, now on record: *(1) which judgment
> states discharge?* — `:verified` only. *(2) does receiver-accessibility apply to
> a claim?* — yes, the identical id-membership rule, read against `claim-id`.
> *(3) what disposition does a refuted claim produce?* — the premise stays
> `:MISSING` (the six §5 statuses are closed; no seventh is minted), but the claim
> and the exact reason it did not discharge are recorded in
> `premise-assessment-judged-claims` and named in the repair advice.
>
> **The silent-discard defect named below is also repaired:** a claim offered in
> `supports` is never invisible again, whatever becomes of it.

**Affected (three charter statements, restated once post-implementation):**
`CHARTER` §4 (*"a premise is discharged by a support or an already-judged
claim"*), §5's in-code definition of `:satisfied` (*"a matching, admissible,
accessible support/**judged claim**"*), §7 step 3 (*"matches supports /
already-judged premise claims"*), and §4's ground requirement on judged premise
claims — plus `ARCHITECTURE` §9, which **restates the promise unchanged after
implementation**.

**Corrected standing.** Judged-claim discharge is hereby labeled
**`[DESIGN-OBLIGATION — UNCONVERTED]`** at all four charter/architecture sites,
and the closure disposition gains:

```text
 :judged-claim-premise-discharge      :not-earned  ; CHARTER §4/§5/§7 promise never implemented; derive filters supports to witnesses + refutations (slice1.lisp:959-960); a matching verified claim lands :missing, silently
```

**Why this is not a narrowing.** `derive` filters `supports` into witnesses and
refutations and silently discards a `claim` — no typed refusal, no assessment
field, no receipt trace. **The narrowing was never enacted by any instrument
this lane uses to narrow**: `CHARTER-DELTA-1` supersedes explicitly five times
and maintains an Errata block — neither was used; the closure never marked it
`:not-earned`; no tooth ever tested it. The only restricting text is two
**descriptive** sentences in the API brief. Under the lane's own discipline
(`WORK-ORDER-1`: every normative must/cannot/never names its live enforcement
path or is labeled `[DESIGN-OBLIGATION]`; `CHARTER`: *"the founding specimen
converts them or they die"*), this obligation was **neither converted nor
recorded dead.** It is recorded dead now.

**~~DOCKETED, NOT REPAIRED — owner decision.~~ DISCHARGED 2026-07-24** under the
adopted Sol design ruling; see the banner at the head of E3 for the three
answers and the enforcement path. The text above is left unaltered on purpose —
it is the record of the gap, not a live claim about the implementation.

## E4 — "Admissible" is a normative term with no live enforcement path

`CHARTER` §5 and `CHARTER-DELTA-1`'s first law both require an **admissible**
support for `:satisfied`; `API`'s reader table repeats it. **No document defines
premise-level admissibility, and the implementation enforces none** — `derive`
applies exactly two filters, proposition match and receiver accessibility;
`witness-mode` and `witness-kind` appear nowhere in `slice1.lisp`. A witness
whose `:kind` belongs to an entirely different schema can discharge a premise.

**Corrected standing:** the word **`admissible`** in those three places is
labeled **`[DESIGN-OBLIGATION — UNDEFINED, UNENFORCED]`**. Reading it as merely
"accessible + matching" is not available, since that makes the charter say *"a
matching, matching, accessible support."* This is the same defect class as E3,
one size smaller. **Definition or enforcement is DOCKETED for the owner.**

## E5 — The D-forge is reachable from the PUBLIC surface; its stratum placement is corrected

**Superseded:** `ARCHITECTURE` §7, which places the D-forge in **stratum 3,
"Explicit/internal host escape,"** beside the one licensed `::`; and the
implicature of `API` standing note 1 that the ungoverned region is reached by
`::`.

**Corrected text.** The D-forge — a same-image hand-built `(:derivation …)`
witness that skips `derive` — is constructible from **exported, single-colon
symbols only**. It requires no package-internal access. It therefore lies
**inside the surface the API scopes as guaranteed**, separated from a governed
program only by the undefined term *"well-formed."*

**What this does and does not disturb.** It **confirms** the closure's
`:host-level-closure :not-earned` and ceiling 3, and vindicates `AUDIT-1`'s
refuse-no-repair as to the escape's *existence* — all intact. It **falsifies**
only the *classification*. Consequential note: the architecture defines
stratum 1 partly as *"receipt every attempt,"* so E1 corrects stratum 1's own
wording as well.

## E6 — Order-independence: the promise is narrowed to the granularity it was earned at

**Superseded:** `ARCHITECTURE` §6's unqualified sentence *"no environment is
ever selected by traversal order."*

**Corrected text.** Support order changes **neither the decision nor the
recorded environment set** — both are canonicalized and order-independent, and
tooth M3 holds. **The per-premise `ground-instance` field IS traversal-order
dependent**: `%build-assessment` instantiates it from the first environment of
an unsorted accumulation list (`slice1.lisp:756`, `:779`).

This is a **documentation overclaim, not a semantic-law violation** — no
document ever promised order-independence of recorded *fields*, and the
decision and environment-set promises are kept. **DOCKETED:** canonicalizing
the selection (`%sort-envs` before `first`) is a one-line change, deliberately
not taken tonight.

## E7 — `signal-slice1` is exported without warrant on the record

`clear-schema-registry` is **warranted**: named in the closure's admitted
surface, documented, and specimen-referenced — it passes the charter's
admission test. **`signal-slice1` is not.** It is exported and API-documented,
but **absent from the closure's evidence-based admitted surface** and
**referenced by no shipped program**, against the charter's rule that names are
*"earned by runnable specimen code only."* It also contract-checks only
`failed-invariant` and `condition-type`, so a forged condition's `:receipt`
passes through unvalidated.

**Recorded, NOT removed** — export removal was explicitly outside the
authorized repair scope. **Owner decision: retire, exercise, or ratify.**

## E8 — Deep and circular input: an open constitutional question, not a breach

No document promises a typed refusal for *all* malformed input; every refusal
statement is an enumerated list. Circular structure is excluded from the value
vocabulary only **extensionally**, via "proper lists thereof," and no Slice /0
or Slice /1 document declares an admitted input domain as to depth or acyclicity.

**Standing:** deeply-nested (100k) and circular input produce an **untyped
`CONTROL-STACK-EXHAUSTED`**, not a typed refusal. **No public-contract violation
is established.** The genuine finding is narrower: *the vocabulary implies an
exclusion that the validator never detects* — `%proper-list-p` diverges on a
cycle rather than reaching a verdict.

Recorded with the strongest argument on the other side, because it is internal:
`AUDIT-1` treated this same untyped-crash class as a **BREACH** when it touched
receipt integrity, and this path needs no `::`, no hostility, and no exotic host
behavior — only `*print-circle*` data on the public surface. **Owner/chair
constitutional call. DOCKETED.**

---

## The docket (nothing here is authorized; each is a decision, not a fix)

| # | Question | Kind |
|---|---|---|
| D1 | Should `schema-not-found` / `unbound-conclusion-variable` carry receipts? | capability |
| D2 | Restrict `(:quoted-datum …)` payloads to boundary-lawful values? | constructor semantics |
| D3 | Implement judged-claim premise discharge — and under which judgment states? | language design |
| D4 | Define or enforce premise-level "admissible" (mode/kind matching)? | language design |
| D5 | Retire, exercise, or ratify the `signal-slice1` export? | surface warrant |
| D6 | Canonicalize `ground-instance` environment selection? | one-line determinism |
| D7 | Add a cycle/depth guard, or declare the admitted input domain? | constitutional |

## Standing

Defects **B1 and B2 are repaired and chair-verified** (`f878cae1`). Findings
**B3, B4, B5** and the four additional classifications are **adjudicated and
corrected in this document**; their code-level consequences are **docketed, not
smuggled into an erratum cycle**. Nothing here opens Slice /2. Nothing here
touches Core /0. **This erratum cycle is CLOSED.**

— **Claude Opus 5 (1M context)**, chair, 2026-07-24
