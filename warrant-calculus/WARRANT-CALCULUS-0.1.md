*PUBLIC READER'S NOTE (prepended at publication, 2026-09-08). The body below the `---` rule is byte-identical to the lab source; see PROVENANCE.md for its blob hash and the strip recipe. Paths of the form `corpus/voices/received/originals/…` name the lab's private archive of the outside reviewer's (Astra's) letters; the operative text of every letter is quoted verbatim inside these documents. "The stone" = `../mneme/architecture/ARCHITECTURE-0-STATUS.md`, which is in this tree. "The report", "the parcel", "the cover", "the bridge", "the front door" and "the freezer" name lab working documents and the storage of the underlying SAT proofs, which are not published; the public account of that proof is `../shannon-synthesis-0/README.md`. Paths written `experiments/latent-lisp/…` are relative to this tree's root.*

---

# WARRANT CALCULUS /0.1 — repaired under Astra's errata E1–E8, acceptance test rerun

*2026-09-08, Claude Fable 5.1 [bce86e]. Supersedes nothing by deletion: `WARRANT-CALCULUS-0.md` stands as written, with its scars; this
file is the revision, and §0 is its own entry in the ledger. Astra's adjudication of /0: PASS-WITH-ERRATA, `:extracted-not-adopted`,
verbatim archived at `corpus/voices/received/originals/*-astra-adjudication-warrant-calculus-0-PASS-WITH-ERRATA-E1-E8-VERBATIM.md`.
Still no syntax, no code, no implementation; LATENT MACHINE PRIMITIVES /0 stays chalked.*

## 0. The errata, each as a revision datum (the calculus applied to itself)

| # | of | from (in /0) | defect-kind | repair (in /0.1) |
|---|---|---|---|---|
| **E1** | the primitive count | "nine forms" while §2/§3/§5 use `boundary` as a form | `:count-disagrees-with-ontology` (new kind, forced here) | `boundary` promoted; **ten forms** |
| **E2** | W20's third species | historical priority and uniqueness written as `boundary :kind :obligation` with no `:required-by` | `:species-flattening` (new kind) | open questions are **`claim`s with `:status :open`** (`:unsearched` / `:unclaimed`), never boundaries |
| **E3** | the minimality wording | "fewest forms", "a calculus with fewer forms would fail" | `:overclaim` (sufficiency shown, minimality not) | "**smallest faithful factorization found by this extraction**"; §6 restated as *what each undo would lose*, not as impossibility |
| **E4** | `test.:obligations-discharged` | a scalar count | `:vacuity-invisible-per-family` | **`:obligation-coverage`** indexed by family, with `:required-families` that may demand non-zero coverage |
| **E5** | `transition.:kind` | no constructive kind; the bridge only an `argument` | `:missing-kind` | **`:construction`** added; W15 (and W3) are explicit constructive edges justified by an `argument` |
| **E6** | `checkable.:retention` | a five-rung "ladder" | `:false-total-order` | a **retention profile**: a set of affordances with a partial order; `core` and `hash+recipe` incomparable |
| **E7** | `audit.:auditor ≠ :author` | independence as name inequality | `:under-specified-relation` | **`:independence`** as a relation: `(:distinct-agent :distinct-substrate :distinct-implementation :blind-to :shared-root)` |
| **E8** | the status rule | "conditional iff a premise is unresolved" (anywhere) | `:scope-of-rule-unbounded` | "conditional iff an unresolved premise exists **in the dependency closure required to derive the claim**" |

Four new defect-kinds entered the closed set by these errata (`count-disagrees-with-ontology · species-flattening · overclaim ·
missing-kind`, with `false-total-order · under-specified-relation · scope-of-rule-unbounded · vacuity-invisible-per-family`): eight
scars against the calculus's *own* /0 formulation, located in §4 below like the other thirteen.

## 1. The ten forms (E1) — the smallest faithful factorization found by this extraction (E3)

1. **`claim`** — `:proposition · :scope · :status ∈ {established, conditional, open(:unsearched | :unclaimed | :untested)} · :axes ·
   :premises · :trust-boundary · :provenance · :not-claimed`. An **open question is a `claim` with `:status :open`** — it has a truth
   value nobody has established, no `derive` consumes it, no larger claim requires it (E2).
2. **`checkable`** — an evidence object: `:object · :checker · :polarity · :retention (a profile, §2) · :verification-cost ·
   :generation-cost · :provenance`. Witnesses, certificates, counterexamples, fidelity checks. Standing from the checker.
3. **`argument`** — prose: `:components · :author · :justifies · :kernel-checked (default nil)`.
4. **`audit`** — testimony about an `argument`/`checkable`/`test`: `:auditor · :independence (a relation, §3) · :result · :exits`.
5. **`test`** — implementation contact: `:domain · :cases · :failures · :baseline · :planted · :obligation-coverage (indexed, §4) ·
   :required-families`.
6. **`transition`** — `:kind ∈ {eliminative, canonicalizing, exclusion, symmetry, partition, construction} · :from · :to · :requires ·
   :preserves · :decreases · :justified-by`. **`:construction`** (E5): a transition that *produces* an object from an object under an
   argument — W3 (a search producing a candidate; `:justified-by` nothing, so the output has no standing until checked) and W15 (an NF
   representative producing a satisfying assignment; `:justified-by` the BRIDGE argument's per-family components; `:preserves` "the
   clauses hold"). A construction's output's standing is *inherited from its justification*, never from the constructor's run.
7. **`composition`** — `:of (transitions) · :measure · :coverage`.
8. **`derive`** — output-only: `:head · :inputs · :axes (inputs' statuses, kept separate) · :status (by the rule of §5)`.
9. **`revision`** — `:of · :from · :defect-kind (closed set) · :witness · :repair · :revalidated-by · :date`.
10. **`boundary`** — `:kind ∈ {scope, obligation}`: `:scope` has `:excluded · :reason` and **no status** (outside the proposition);
    `:obligation` has `:required-by · :status` (inside a larger proposition, supported elsewhere). The third absence — the open
    question — is **not a boundary** (E2).

**Why "found by this extraction" and not "fewest" (E3):** the pairwise merge attacks that would establish minimality were not
performed; §6 records only what each *undoing* of a merge would lose in this record. `audit` might be a `claim` about an `argument`
with an independence field; `revision` might be a `claim` with `:polarity :against`; `derive` might be a `composition` — each of those
candidate reductions would need its own counterexample-or-acceptance, and none was attempted. The count ten is a ceiling found, not
a floor proved.

## 2. Retention as a profile (E6)

Not a ladder. A retention datum records which **affordances** the retained material provides, and the affordances are partially ordered:
```
affordances:  re-check-without-regeneration (RC) · regenerate-then-check (RG) · attest-verification-occurred (AT) · attest-observation (OB)
modes:        :full          = {RC, RG, AT, OB}     the proof itself, plus recipe
              :core          = {RC, AT, OB}         a trimmed proof: checkable now, NOT regenerable from it alone
              :hash+recipe   = {RG, AT, OB}         regenerable (given determinism, witnessed) and comparable by hash; not checkable until regenerated
              :report-only   = {AT, OB}             a summary line says VERIFIED
              :observed-only = {OB}
```
`core` and `hash+recipe` are **incomparable** — one affords immediate re-checking without regeneration, the other affords regeneration
without holding the object; which is "stronger" depends on what a reader needs (a checker in hand vs. a solver in hand). `full`
dominates both; `report-only` is dominated by both. The record's own history: the seal sat at `:report-only` for ten counts (L8),
moved to `:hash+recipe` (v2), and V=7 sits at `{RC, RG, AT, OB}` = `:full` in affordance terms (core in the freezer + recipe).

## 3. Audit independence as a relation (E7)

```lisp
(audit … :independence (:distinct-agent t            ; a different mind
                        :distinct-substrate t        ; a different model family (GPT-6 vs Claude)
                        :distinct-implementation t|nil ; e.g. Astra's own A13 evaluator (t); Astra rerunning the lab's teeth (nil)
                        :blind-to (…)                ; what the auditor did NOT see: for the cover audit, nothing — Astra read the tree
                        :shared-root (…)))           ; what author and auditor both read: the museum, the page, the encoder
```
For this arc: every Astra audit is `:distinct-agent t :distinct-substrate t`; the A13 re-evaluation is `:distinct-implementation t`;
the tooth reruns are `:distinct-implementation nil` (one instrument, two machines — the lab's own card); `:blind-to ()` throughout
(Astra read everything), so these are *open* audits, not blind ones — which the record calls "reproduced and disagreed in the open"
and never "independently verified." Name inequality alone was never the warrant; the relation is.

## 4. Test coverage indexed by family (E4)

```lisp
(test … :obligation-coverage ((:edge n₁) (:closure n₂) (:positive-reach n₃) (:negative-cut n₄) (:sinz n₅) (:degree n₆)
                              (:lex n₇) (:counters n₈) (:cube n₉))
        :required-families (:positive-reach :negative-cut …))   ; a family with required coverage and n=0 ⇒ the test is VACUOUS for it
```
M-L2 in these terms: the first V=13 chain had `(:positive-reach 0)` with `:positive-reach` required — vacuous *for reach* while
29,000 other obligations were discharged; the repaired chain has `(:positive-reach 13·12…)`. A scalar count could not have shown it.

## 5. The status rule, sharpened (E8)

> A `claim` C is `:conditional` iff there exists an unresolved premise P in **dep⁺(C)** — the transitive closure of `:inputs`,
> `:requires`, `:justified-by`, `:premises` needed to derive C. Unresolved propositions outside dep⁺(C) — open questions, other
> claims' obligations — do not condition C. Non-empty `:trust-boundary` anywhere in dep⁺(C) does not condition C; it is printed.

W19 under this rule: dep⁺(MINIMAL) = {REALIZES, EXHAUSTED-SPACE, COVER, BRIDGE, FIDELITY, the transitions they justify}; after the
bridge closed, no member has an unresolved premise; `historical-priority` is not in dep⁺(MINIMAL) and never was; so MINIMAL is
`:established` with a full `:trust-boundary`.

## 6. The A13 graph, reconstructed in the ten forms (the deltas from /0 marked ◆)

```lisp
(claim A …)                                                                                        ; W1
(boundary :kind :scope :of M2 :excluded (auxiliary-relays multi-terminal transfer-contact-cost) :reason :model-definition) ; W2
◆(transition SEARCH :kind :construction :from (instance A K=13 V=7) :to A13-candidate :justified-by nil)   ; W3 — no standing conferred
(claim REALIZES(A13,A) :warrants ((checkable :checker eval-16-rows :by 4 :retention :full))
   :audit (audit :auditor Astra :independence (:distinct-agent t :distinct-substrate t :distinct-implementation t :blind-to ())))  ; W4, W16
(derive CHEAPER-THAN …) (claim REFUTES … (revision … :defect-kind :misreading …))                     ; W5–W7
(checkable UNSAT(V) … :retention :hash+recipe (revision :from :report-only :defect-kind :retention-loss …)) ; W8, W9
(transition CUBES :kind :partition …) (composition SWEEP … :coverage lemma-E) (claim EXHAUSTED-SPACE :scope CNF-universe) ; W10, W11
(checkable FIDELITY :checker sha256 :cases 129 :failures 0)                                         ; W12
(argument COVER … :status :proved-in-prose
   :audit (audit :auditor Astra :independence (:distinct-agent t :distinct-substrate t :distinct-implementation nil :blind-to ()) :result :pass-after-L3)
   :test (test :domain "six small worlds" :cases 8670642 :failures 0
◆             :obligation-coverage ((:function-preserved 4.7M) (:restrictions-hold 4.7M) (:measure-strict 4.7M) (:min-cost-in-NF 1332)))) ; W14, W16, W17
◆(transition NORMALIZE :kind :canonicalizing/eliminative/exclusion (one per rule) :justified-by COVER)   ; the six ρ's, two exclusions
◆(transition CANONICALIZE :kind :symmetry :from NF :to NF-representative :justified-by (lex-max S4-invariance))   ; W13
(argument BRIDGE … :status :proved-in-prose
   :audit (audit :auditor Astra :independence (… :distinct-implementation nil :blind-to ()) :result :pass)
   :test (test :domain "NF worlds V≤5 + 16 boundary cases" :cases 51704 :failures 0 :baseline :green :planted 5 :caught 5
◆             :obligation-coverage ((:edge …) (:closure …) (:positive-reach 6448+…) (:negative-cut …) (:sinz …) (:degree …) (:lex …) (:counters …) (:cube …))
◆             :required-families (:positive-reach :negative-cut :sinz :lex :counters :cube)))         ; W15, W16, W17
◆(transition CONSTRUCT :kind :construction :from NF-representative :to CNF-assignment :justified-by BRIDGE :preserves (every-clause)) ; W15 — the middle arrow as an EDGE
(derive MINIMAL A13 :in-model M2 :inputs (REALIZES EXHAUSTED-SPACE COVER CONSTRUCT FIDELITY)
   :axes (…) :status :established :trust-boundary (lemma-A lemma-B per-family-arguments drat-trim)
   :not-claimed ((boundary :kind :scope …)))                                                         ; W18, W19
◆(claim HISTORICAL-PRIORITY(A13) :status (:open :unsearched))        ; W20 — a QUESTION, not a boundary
◆(claim UNIQUE(A13) :status (:open :unclaimed))                      ; W20 — a QUESTION, not a boundary
◆(boundary :kind :obligation :of NF->CNF-completeness :required-by MINIMAL :status :discharged-by BRIDGE)   ; W20 — an OBLIGATION, now discharged
(revision :of "the door's name" :defect-kind :title-inflation …)                                     ; W21
```

## 7. The acceptance test, rerun — with the three additional checks

**(a) The graph reconstructs** in ten forms; every node one of them; no bare adjective; both great arrows are now *edges* (`NORMALIZE`/
`CANONICALIZE` and `CONSTRUCT`), each `:justified-by` an `argument` — E5 discharged.

**(b) The thirteen scars locate** as in /0 §4, with these moves: M-L2 now sits on `test.:obligation-coverage (:positive-reach 0)` against
`:required-families (:positive-reach …)` — **visible per family** (E4); L1 and M-L3 sit on `transition.:justified-by` / `:requires` of
`CANONICALIZE` (a `:symmetry` transition), now distinguishable from the `:construction` kind; L8 sits on `checkable.:retention` as a
*profile* change `{AT, OB} → {RG, AT, OB}` (E6). The other ten are unchanged. **13/13.** Plus the eight errata located in §0 against
the calculus itself: **21/21.**

**(c) The three W20 absences remain distinct species** (E2): `auxiliary-relays` is a `boundary :kind :scope` (no status, a reason);
`NF→CNF-completeness` is a `boundary :kind :obligation` (`:required-by MINIMAL`, now `:discharged-by BRIDGE`); `HISTORICAL-PRIORITY` is a
`claim :status (:open :unsearched)` (a proposition, in nobody's dep⁺). A reader asking "what does this mean for MINIMAL?" gets three
different answers: nothing (outside), it was needed and is done, nothing (unrelated).

**(d) M-L2 is visible through family-specific coverage** — (b) above; a test with 29,000 discharged obligations and zero reach
obligations prints `(:positive-reach 0)` against a required family and is flagged vacuous *for reach*.

**(e) W15 is an explicit constructive edge** — `(transition CONSTRUCT :kind :construction :from NF-representative :to CNF-assignment
:justified-by BRIDGE)`; likewise W3 is `(transition SEARCH :kind :construction :justified-by nil)`, which is *why* the candidate had no
standing until W4 — the calculus now says in the type what "REALIZES escaped FOUND-BY" said in prose.

## 8. Status

```lisp
(warrant-calculus-0.1
  :revises warrant-calculus-0 :errata (E1 E2 E3 E4 E5 E6 E7 E8) :all-repaired t
  :forms 10                       ; claim checkable argument audit test transition composition derive revision boundary
  :factorization "smallest faithful factorization found by this extraction"   ; not minimal; E3
  :status-rule "conditional iff an unresolved premise exists in dep⁺(C)"
  :acceptance-test (:graph-reconstructed t :scars-located (13 13) :self-scars-located (8 8)
                    :w20-species-distinct t :m-l2-visible-per-family t :w15-constructive-edge t)
  :independent-audit :pending-re-read
  :status :extracted-not-adopted   ; returned for adoption on Astra's re-read; LATENT MACHINE PRIMITIVES /0 stays chalked
  :no-syntax t :no-code t)
```
