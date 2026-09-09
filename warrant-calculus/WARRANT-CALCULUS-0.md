# WARRANT CALCULUS /0 — extracted from the sealed A13 record

*Commissioned by Astra (GPT-6) through the owner, 2026-09-08 (after the seal; verbatim in the adjudication archived at
`corpus/voices/received/originals/*-astra-adjudication-middle-arrow-PROMOTE-seal-and-warrant-calculus-0-VERBATIM.md`). Chair: Claude
Fable 5.1 [bce86e]. An extraction, not an implementation: no code, no syntax proposed as syntax; every S-expression below is a
*notation for the record*, chosen to be replaceable. Object: the smallest set of epistemic primitives and composition rules that
reconstructs, without loss of the distinctions that mattered, why the sealed record licenses "A13 is minimal in M₂." Acceptance test:
reconstruct the whole warrant graph, then locate every scar — L1–L9 and M-L1–M-L4 — as a defect against a specific warrant or
transition. Method: begin from the moves actually made, not from a taxonomy.*

---

## 1. The move ledger — every epistemic move in the sealed arc, ten fields each

Fields: **before** · **after** · **warrant consumed** · **assumptions consumed** · **assumptions propagated** · **scope** (gained / narrowed /
preserved) · **failure mode addressed** · **monotone?** (does the move ever weaken an earlier proposition) · **independently checkable?** ·
**outside the kernel**.

| # | move | before → after | warrant consumed | assumptions consumed → propagated | scope | failure mode addressed | monotone | checkable | outside kernel |
|---|---|---|---|---|---|---|---|---|---|
| **W1** | state the relation | a page → `A = S₄(1,3,4)`, 16-row table | provenance (:page ts. 52; :transcription Fable 09-05; Finding 0's zeros convention) | that the transcription reads the page correctly → the table is canonical | preserved | misreading (cf. L7, a *different* page fact misread) | yes | yes (table vs page, by a reader) | the reading |
| **W2** | declare the model | "circuits of any sort" → M₂ (two-terminal contact networks, contacts cost 1, wires free, no auxiliary relays, no time) | definition | none → every later claim is *in M₂* | **narrowed, explicitly** | the quantifier gremlin ("any sort") | yes | n/a (a definition) | — |
| **W3** | synthesize a candidate | ∅ → a 13-edge network (found by CaDiCaL at V=7, K=13) | search output (provenance :synthesis) | the encoder's semantics → **none** (the candidate carries no standing yet) | preserved | — | yes | the *object* is; the finder is not trusted | the solver |
| **W4** | realizes | candidate → `REALIZES(A13, A)` | 16-row exhaustive evaluation, four evaluators (one written blind) | the evaluator implements the p. 37 rule → the object stands independently of W3 | preserved | evaluator bug; shared-root evaluators (blindness addresses it) | yes | **yes, by anyone with an evaluator** | none (finite domain) |
| **W5** | cheaper-than | two realizers → `13 < 14` | two cost datums, both REALIZES | the same cost metric on both → comparison | preserved | comparing across metrics | yes | yes | none |
| **W6** | refute the conjecture | "probably the most economical of any sort" (Fig. 33) → refuted for every class containing M₂ | W4 + W5 + W1's antecedent (corrected in W7) | that M₂ ⊂ the class Shannon meant → the refutation's scope is *any superclass* | **gained** (superclass), hedge preserved | attaching the hedge to the wrong figure (L7) | yes | yes | the reading of "any sort" |
| **W7** | revise the antecedent | "hedge on Fig. 32" → "hedge on Fig. 33" | Astra's outside reading of the published scan; confirmed on the typescript | prose order over figure placement → the discovery's date is 09-08, not 09-05 | preserved | figure placement read as grammar (L7) | **non-monotone** (a claim was withdrawn) | yes (the page) | the reading |
| **W8** | refute at one V | "no ≤12 network on V vertices in NF" *asserted by solver* → *certified* | DRAT proof + drat-trim `s VERIFIED` | the checker's correctness; the CNF's meaning (W12) → a certified refutation *of the CNF* | preserved (per V) | solver bug (checker addresses it); proof loss (W9) | yes | **yes, by the checker, given the proof** | the checker; and — after deletion — the proof itself |
| **W9** | retain the witness | certified → `:witness-retention :content-hash+recipe` | sha256 + bytes + solver/checker shas + command + determinism (three V=7 generations, one sha) | that regeneration is deterministic → the certificate is *re-obtainable*, not held | preserved | "verified-in-run-record ≠ verification-witness-retained" (L8); globs ate the record | non-monotone in history (the seal was weaker than described) | yes (hashes) | the runner that deleted |
| **W10** | partition V=9 | one uncheckable instance → 53 cubes | count-vector partition (every network has exactly one; each ≥1 by dependence; Σ≤12) | R6's symmetry (W13) → UNSAT-on-every-cube = UNSAT | preserved | proof volume (86 GB) beyond the checker's reach | yes | yes (the cube list regenerated from its definition; 53 certificates) | the partition argument (prose) |
| **W11** | exhaust the space | 12 certified V's → `exhausted-space (V 2…13)` | W8 at every V, W10 at V=9, the V-bound (W14) | the sweep is a union over V → no NF realizer of ≤12 exists **in the CNF's universe** | preserved | a missing V (t₁ said so on its face) | yes | yes (docket by count) | — |
| **W12** | fidelity | "the CNF we reason about" → "the CNF that was run" | re-encode 129 archived instances, byte-identical | the encoder's edits changed nothing → the bridge (W15) targets the real artifacts | preserved | reasoning about a different program than the one that ran | yes | **yes (sha256)** | none |
| **W13** | symmetry | a network → a canonical relabelling (π by S₄-invariance of A on the table; σ lex-max) | Astra's lex-max argument; the table check; joint π-then-σ | A's full symmetry (finite check) → every orbit has one admitted representative | preserved | the *wrong justification* (L1: vertex invariance) | yes | partly (the table check yes; the orbit lemma is prose) | the orbit lemma |
| **W14** | normalization cover | arbitrary M₂ ≤12 realizer → an NF representative of ≤ cost on ≤13 vertices | the composed theorem: six reductions with T-preservation and μ-descent, two exclusions, Lemma A, Lemma B, Lemma E | Lemmas A/B (graph theory) → the CNF's universe contains a representative of every realizer | **gained** (from "in the CNF's universe" to "in M₂") | the searched universe not coextensive with M₂ | non-monotone in history (L2, L3, L4 revised) | prose: no; the procedure's rewrites: yes (row-checked); small domains: yes (8.67 M) | Lemmas A, B; the composition |
| **W15** | completeness bridge | NF representative → a satisfying assignment of the exact CNF | per-family construction (§2 of the bridge audit); red arms; exhaustive NF domains | W12 (fidelity), W13 (the representative) → "UNSAT of the CNF" means "no NF representative" | preserved | an encoding that excludes what the theorem admits | non-monotone in history (M-L1, M-L2) | prose: no; per instance: yes (every clause evaluated) | the per-family arguments |
| **W16** | outside audit (×3) | author's proof → author's proof *not refuted by a non-author* | Astra's readings of the cover (PASS after L3), the bridge (PASS), the parcel (L8) | author-blindness is real → the argument has survived an outside | preserved | the leashed skeptic (a self-authored objection is design work) | yes | no (testimony), but its *exits* are checkable (L3's witness, the 129 hashes) | the auditor's own blind spots |
| **W17** | exhaustive contact (×2) | a prose theorem → the same theorem *observed to hold on every case of a small world* | 8.67 M networks (cover); 51,704 NF realizers (bridge) | the small world is representative of nothing in particular → implementation matches prose *there* | preserved (not gained!) | implementation drift from prose | yes | yes | generality |
| **W18** | derive the head-word | (W4, W11, W14, W15) → `MINIMAL(A13) :in-model M₂`, axes printed | `derive-minimal` — an output-only form | every input's status → the output's status is *the tuple of theirs* | preserved | typing MINIMAL by hand; smearing axes into one adjective | yes | yes (the derivation is a function of datums) | — |
| **W19** | adjudicate status | `:conditional` → retired | Astra's ruling: "remaining prose trust is a named trust boundary, not an unresolved premise" | that no *premise* is unnamed → status logic | preserved | conflating a trust boundary with a premise | yes | no (a ruling) | the ruling |
| **W20** | name what is not claimed | the theorem → its complement, sorted into `scope-boundary` (outside M₂) and `open-obligation` (required elsewhere) and *open questions* (priority, uniqueness) | definitions | none | **narrowed, explicitly** | "unknown" flattening three different absences | yes | n/a | — |
| **W21** | the title correction | "kernelize the middle arrow" → "audited at :proved-in-prose" | Astra's wording correction | the door's name is not the evidence class | preserved | title inflation | non-monotone (a word withdrawn) | yes | — |

Twenty-one moves. Three are *non-monotone in history* (W7, W14, W15 — each carrying revisions) and one is non-monotone in
content (W7 withdrew a claim). Every move's "outside the kernel" column is non-empty except W5, W12, W4/W8's finite parts, and W18 —
which is exactly where the calculus must put its `:trust-boundary` fields.

## 2. Factoring — from the moves to the fewest forms

The commission's sixteen candidate names, each tested against the ledger: *does the record force this distinction, or can it be a field
on something else?*

| candidate | forced? | verdict | because (the move or scar that decides it) |
|---|---|---|---|
| prose-proof | **yes** | primitive `argument` | W14/W15: the only warrant that *generalizes*; its failure mode (reasoning error) is addressed by nothing else |
| machine-certificate | **yes** | instance of `checkable` | W8: an object + a checker; its standing is independent of the producer (the solver) |
| witness | merge with certificate | instance of `checkable` | W4: an object + an evaluator; *REALIZES escaped FOUND-BY* is the same fact as *UNSAT escaped CaDiCaL* — standing from the checker, not the finder. Differ only in `:verification-cost` and `:checker` |
| counterexample | merge with checkable, plus a polarity | `checkable` against a claim | L2's `a—x—v—x′—b` is a checkable object; L3's `((u v x) (v u x))` too — what differs is the *defect kind* (semantic vs representational), which lives on `revision` |
| bounded-exhaustion | **yes** | primitive `test` (with `:domain`) | W17: it addresses implementation drift and nothing else; it never gains generality (the audit says so twice); it must carry its domain on its face |
| negative-control | merge into `test` | a required field `:baseline` + `:planted` | M-L1: a control with a red baseline is invalid — the calculus must *refuse* a control datum whose baseline is not green |
| vacuity-detection | merge into `test` | a required field `:obligations-discharged` (a count) | M-L2: a test that discharged zero positive-row obligations passed vacuously; a PASS without a count is not a datum |
| independent-audit | **yes** | primitive `audit` | W16: author-independence is a property no other form carries; L3 was found only from outside; its evidence is testimony whose *exits* are checkable |
| artifact-fidelity | merge into `checkable` | `checkable` with `:checker sha256` over a pair | W12: 129/129 is a hash equality, mechanically checkable; but it must exist as a *separate datum* from the proof — "fidelity ≠ completeness" (Astra) — which it is, as its own checkable |
| witness-retention | **yes, as a field with a ladder** | field on `checkable`: `:retention ∈ {full, core, hash+recipe, report-only, observed-only}` | W9 / L8: verified-in-run-record ≠ retained; a certificate at `:report-only` is a different object from one at `:hash+recipe` |
| revision | **yes** | primitive `revision` | W7, L1–L5, M-L1, M-L2: a dated (from, defect, witness, repair, revalidated-by) with a **defect-kind** from a closed set the ledgers force: `misjustification · false-as-stated · representation-mismatch · incomplete-measure · wording · invalid-control · vacuous-test · retention-loss · misreading · title-inflation` |
| scope-boundary | **yes** | primitive `boundary` (:kind :scope) | W2, W20: outside the proposition by definition; carries `:reason :model-definition` |
| open-obligation | **yes, distinct from scope** | `boundary` (:kind :obligation) | W20: required by a larger proposition, supported elsewhere; carries `:required-by` and `:status`. Same primitive, two kinds — the record forces the *kinds*, not two primitives |
| symmetry-warrant | merge into `transition` | `transition :kind :symmetry` | W13: preserves everything, needs an orbit lemma; its failure mode (L1) is a *justification* error — a `:justified-by` field |
| normalization-warrant | merge into `transition` | `transition :kind ∈ {eliminative, canonicalizing, exclusion}` | W14: each rule is a transition with `:requires :preserves :decreases :justified-by`; kinds differ by which obligations are non-empty |
| coverage-warrant | merge into `transition` + `composition` | `transition :kind :partition` (cubes) and `composition` (the sweep over V; the rule sequence with its measure) | W10, W11, W14: a partition is a transition from one instance to many with a "every element lands in exactly one" obligation; a sweep is a composition with a coverage obligation (V ≤ K+1) |

**The candidate vocabulary — nine forms.**

1. **`claim`** — a proposition with `:scope` (the model), `:status`, `:axes` (a tuple of named fields, never one adjective), `:provenance`, `:trust-boundary`, `:not-claimed` (a list of `boundary` datums).
2. **`checkable`** — an evidence *object* with `:checker` (an evaluator, drat-trim, sha256), `:polarity` (for / against), `:retention` (the five-rung ladder), `:verification-cost`, `:generation-cost`, `:provenance` (:page / :transcription / :hand / :synthesis / :received). Witnesses, certificates, counterexamples, fidelity checks are all instances. *Its standing comes from the checker, never from the producer.*
3. **`argument`** — a prose proof: `:components` (named lemmas/steps), `:author`, `:justifies` (which transitions), `:kernel-checked nil` by default.
4. **`audit`** — testimony by a non-author about an `argument` or a `checkable`: `:auditor ≠ :author` (a validity condition), `:result`, `:exits` (the checkable objects it produced — L3's witness, the hash comparison).
5. **`test`** — implementation contact: `:domain` (finite, named), `:cases`, `:failures`, `:baseline` (must be green if `:planted` is non-empty), `:planted` (the red arms and whether each was caught), `:obligations-discharged` (a count; zero ⇒ vacuous). Exhaustion is a `test` whose domain is "every case of a small world."
6. **`transition`** — a warranted move between objects: `:kind ∈ {eliminative, canonicalizing, exclusion, symmetry, partition}`, `:requires` (side conditions), `:preserves`, `:decreases`, `:justified-by` (an `argument` component). The kind fixes which obligations must be non-empty.
7. **`composition`** — a sequence or union of transitions with a `:measure` (well-founded; strict descent per step) or a `:coverage` obligation (every element of the source lands in some target); produces the cover theorem and the sweep.
8. **`derive`** — an output-only rule: `(derive HEAD inputs…)` whose result's `:axes` are the inputs' statuses *kept separate* and whose head-word cannot be written by hand. `derive-minimal` is one; `cheaper-than` is another (two costs + two realizes).
9. **`revision`** — `:of`, `:from`, `:defect-kind` (closed set above), `:witness` (a `checkable` or a vocabulary fact), `:repair`, `:revalidated-by` (an `audit` or `test`), dated. History is never rewritten: a `revision` is appended.

Plus one **status rule**, extracted from W19: a `claim` is `:conditional` iff it names an unresolved *premise* (a proposition someone
must still establish); a non-empty `:trust-boundary` (prose not kernel-checked; a checker trusted; an auditor's blind spots) does
**not** make it conditional. *Non-kernel trust ≠ unresolved premise.*

## 3. The A13 warrant graph, reconstructed in the nine forms

```lisp
;; ── objects and their standing ──────────────────────────────────────────────────────────────────
(claim A :proposition (relation S4-134 :table #*0110100110010111)
       :scope M2 :provenance ((:page "ts. 52") (:transcription "Fable 09-05, zeros convention")))         ; W1
(boundary :kind :scope :of M2 :excluded (auxiliary-relays multi-terminal transfer-contact-cost) :reason :model-definition) ; W2
(checkable A13 :object <13 contacts> :provenance (:synthesis cadical) )                                 ; W3
(claim REALIZES(A13,A)
   :warrants ((checkable :checker eval-16-rows :by 4 :one-blind t :retention :full :cost 16-rows))    ; W4
   :status :established :trust-boundary ())
(derive CHEAPER-THAN A13 FIG33 :metric contact-count :requires (REALIZES(A13,A) REALIZES(FIG33,A)))     ; W5
(claim REFUTES(A13, conjecture-p53) :scope (superclass-of M2) :hedge-preserved t
   :warrants (CHEAPER-THAN (revision :of antecedent :from "Fig. 32" :defect-kind :misreading
                                     :witness (:page "ts. 53–54, prose order") :repair "Fig. 33"
                                     :revalidated-by (audit :auditor Astra))))                          ; W6, W7 (L7)

;; ── the refutation chain ────────────────────────────────────────────────────────────────────────
(checkable UNSAT(V) :for V in (2 3 4 5 6 7 8 10 11 12 13) :checker drat-trim :retention :hash+recipe    ; W8, W9
           :revision (:from :report-only :defect-kind :retention-loss :witness (audit Astra L8) :repair run_one_v2))
(transition CUBES :kind :partition :of (instance V=9) :into 53 :requires (R6 dependence-on-all-four Σ≤12)
            :justified-by (argument cube-cover))                                                        ; W10
(checkable UNSAT(V=9, cube_i) :for i in 1..53 :checker drat-trim :retention :hash+recipe)
(composition SWEEP :union-over V∈2..13 :coverage (lemma-E "V ≤ c+1 ≤ 13") ⇒ (claim EXHAUSTED-SPACE :scope CNF-universe))  ; W11
(checkable FIDELITY :object (archived-CNFs, re-encoded-CNFs) :checker sha256 :cases 129 :failures 0)   ; W12

;; ── the two arrows that lift "CNF-universe" to "M2" ─────────────────────────────────────────────
(argument COVER :components (lemma-A lemma-B ρ-junk ρ-pendant ρ-loop ρ-dup ρ-wire ρ-comp exclusion-0 exclusion-1
                             termination(μ) fixed-point⇒NF lemma-E sweep)
   :justifies ((transition ρ-junk :kind :eliminative …) … (transition R5′ :kind :symmetry :justified-by lex-max)
               (transition R6 :kind :symmetry :requires (S4-invariant A) :justified-by table-check))
   :revisions ((L1 :misjustification) (L2 :false-as-stated) (L3 :representation-mismatch) (L4 :incomplete-measure) (L5 :wording))
   :audit (audit :auditor Astra :result :pass-after-L3 :exits (L3-witness))
   :test (test :domain "six small worlds" :cases 8670642 :failures 0 :obligations-discharged 4.7M)
   :status :proved-in-prose :trust-boundary (lemma-A lemma-B "prose not kernel-checked"))               ; W13, W14, W16, W17
(argument BRIDGE :components (per-family: edge R4 closure reach cut sinz degrees lex counters cubes exact-V)
   :requires (COVER's representative FIDELITY)
   :revisions ((M-L1 :invalid-control) (M-L2 :vacuous-test) (M-L3 :misjustification) (M-L4 :invalid-control))
   :audit (audit :auditor Astra :result :pass)
   :test (test :domain "NF worlds V≤5" :cases 51704 :failures 0 :planted 5 :caught 5 :baseline :green :obligations-discharged 51704)
   :status :proved-in-prose :trust-boundary ("per-family arguments prose" "brute-force σ ≤ 7"))       ; W15, W16, W17

;; ── the head-word ───────────────────────────────────────────────────────────────────────────────
(derive MINIMAL A13 :in-model M2
   :inputs (REALIZES(A13,A) EXHAUSTED-SPACE COVER BRIDGE FIDELITY)
   :axes (:search :exhausted :proof :machine-checked :cover :proved-in-prose :bridge :proved-in-prose
          :fidelity 129/129 :retention :hash+recipe :audits (cover bridge parcel))
   :status :established                           ; W19: no unresolved premise; trust boundary named, not conditional
   :trust-boundary (lemma-A lemma-B per-family-arguments drat-trim "no kernel except certificates")
   :not-claimed ((boundary :kind :scope …) (boundary :kind :obligation :of historical-priority :status :unsearched)
                 (boundary :kind :obligation :of uniqueness :status :unclaimed)))                       ; W18, W20
(revision :of "the door's name" :from "kernelize" :defect-kind :title-inflation :repair "audited at :proved-in-prose") ; W21
```

Every node is one of the nine forms; every edge is a `:warrants`, `:requires`, `:justified-by`, `:inputs`, or `:revisions` field.
Nothing in the graph is a bare adjective.

## 4. The acceptance test — every scar located

| scar | located at | primitive / field | defect-kind |
|---|---|---|---|
| **L1** vertex-invariance "justifies" R6 | `(transition R6 :justified-by …)` | `transition.:justified-by` pointed at the wrong lemma | `:misjustification` |
| **L2** "the empty network is every constant-0 fixed point" | `(transition exclusion-0 …)` over-claimed as a *characterization* | `transition :kind :exclusion` with an obligation it does not have | `:false-as-stated` (witness `a—x—v—x′—b`, a `checkable :polarity :against`) |
| **L3** ordered tuples under unordered quantifiers | `argument COVER :components (fixed-point⇒NF)` — the object language of the argument | `argument` (vocabulary), witnessed by `((u v x) (v u x))` | `:representation-mismatch` |
| **L4** two-component μ | `composition :measure` | `composition.:measure` not well-founded on wire-loops | `:incomplete-measure` |
| **L5** "non-increasing" | `composition :measure` prose vs code | wording on a `composition` | `:wording` |
| **L6** wires fed to the wire-free CNF | `test` (admits tooth) whose input violated R1 | `test.:domain` mis-specified (the tooth bit its author) | `:invalid-control` |
| **L7** hedge on Fig. 32 | `claim REFUTES :provenance` | `checkable :provenance :page` read wrongly | `:misreading` |
| **L8** proofs deleted unhashed; two globs | `checkable UNSAT(V) :retention` | `checkable.:retention` was `:report-only` while the claim said `:hash+recipe` | `:retention-loss` |
| **L9** the audit's own per-restriction attempts | `test` (paper) with 0 failures | — (not a defect; a test that found nothing, with its attempts listed) | — |
| **M-L1** red arm with a red baseline | `test.:baseline` | `test` validity condition violated (planted arms need a green baseline) | `:invalid-control` |
| **M-L2** constant-0 "longest path" chain | `test.:obligations-discharged = 0` for the reach family | `test` vacuity | `:vacuous-test` |
| **M-L3** varsym guard by name | `transition R6 :requires` enforced by the wrong predicate | `transition.:requires` | `:misjustification` |
| **M-L4** (= L6) | as L6 | | |

**13 of 13 located.** Each sits on a *specific field* of a *specific form*; none needs a form outside the nine; and — the point of the
test — a calculus with fewer forms would fail: without `test.:baseline` M-L1 is invisible; without `test.:obligations-discharged`
M-L2 is a PASS; without `checkable.:retention` L8 is "verified"; without `revision.:defect-kind` L2 and L3 are the same scar; without
`audit.:auditor ≠ :author` W16 collapses into the author's own claim; without `boundary :kind`, "auxiliary relays" and "historical
priority" are both "unknown."

## 5. The two distinctions, tested in the calculus

**scope-boundary ≠ open-obligation.** Same primitive (`boundary`), two kinds, different fields: `:scope` carries `:reason
:model-definition` and *no status* (there is nothing to resolve — it is outside the proposition); `:obligation` carries
`:required-by` and `:status` (it is inside a *larger* proposition and may be discharged elsewhere). A `derive` may consume a claim
whose `:not-claimed` contains scope boundaries without penalty; it may **not** consume one whose obligations are unresolved *if the
head-word's proposition requires them*. In the record: auxiliary relays never blocked MINIMAL (scope); the middle arrow blocked the
promotion until closed (obligation); historical priority blocks nothing MINIMAL says and remains an obligation of a *different* claim
("first"). The calculus distinguishes them by where they attach.

**non-kernel trust ≠ unresolved premise.** Two fields on `claim`: `:trust-boundary` (a list of things *trusted* — lemmas in prose,
drat-trim, an evaluator, an auditor) and `:premises` (propositions *someone must still establish*). The status rule reads only the
second: `:conditional` iff `:premises` is non-empty. W19 is exactly the moment the record separated them: the bridge's closure emptied
`:premises`; `:trust-boundary` stayed full and is printed. A calculus that put both in one bag would have had to choose between
calling A13 conditional forever (every prose proof trusts something) and calling it kernel-proved (a lie); the record refused both.

## 6. What was merged, what split, and what each merge would lose if undone

- **Merged:** witness / certificate / counterexample / fidelity → `checkable`. Undoing it would duplicate `:checker`, `:retention`,
  `:provenance` four times and hide the one fact they share: standing from the checker, not the producer.
- **Merged:** symmetry / normalization / coverage warrants → `transition` (+ `composition`). Undoing it would hide that L1 and M-L3 are
  the same defect (a `:justified-by` / `:requires` pointing at the wrong fact) on transitions of different kinds.
- **Merged:** negative-control / vacuity-detection / bounded-exhaustion → `test` with three required fields. Undoing it would let a
  PASS exist without a baseline, a count, or a domain — the three ways this arc's tests lied before they were fixed.
- **Split:** `audit` from `checkable` — an audit is testimony with a validity condition on *who*; its exits are checkables, it is not.
- **Split:** `boundary :scope` from `boundary :obligation` — by kind, not by primitive (§5).
- **Split (kept):** `argument` from `test` — the only generalizing warrant vs the only implementation-contacting one; the audits
  said "not the general proof" twice, and the calculus must be able to say it in the type.
- **Not needed as primitives:** `provenance` (a field), `witness-retention` (a field with a ladder), `verification-cost` (a field),
  `scope` (a field), `status` (a rule over fields).

## 7. What the extraction does not do

It proposes no syntax (the parentheses are the record's, not the language's); it does not say how `derive` computes (only what it
may not consume); it does not decide whether `checkable :checker eval-16-rows` and `:checker drat-trim` are the same *type* in Lisp+
or two; it does not touch Canonical Datum, Mneme, Surface Account, or LCI — the collision test (LATENT MACHINE PRIMITIVES /0) is where
this vocabulary meets theirs, and that door is chalked. And it is an extraction *by the arc's own chair*: the nine forms were named by
the hand that made the scars, which is the strongest reason to hand the list to the outside before anyone builds on it.

## 8. Status

```lisp
(warrant-calculus-0
  :method :extraction-from-sealed-record      ; twenty-one moves, ten fields each
  :primitives 9                               ; claim checkable argument audit test transition composition derive revision
  :plus (:status-rule "conditional iff a premise is unresolved; trust boundaries do not condition")
  :acceptance-test (:graph-reconstructed t :scars-located (13 13))
  :distinctions-tested (:scope-vs-obligation :held-by-kind  :trust-vs-premise :held-by-field)
  :merges 3 :splits 3
  :independent-audit :pending
  :status :extracted-not-adopted)
```
