*PUBLIC READER'S NOTE (prepended at publication, 2026-09-08). The body below the `---` rule is byte-identical to the lab source; see PROVENANCE.md for its blob hash and the strip recipe. Paths of the form `corpus/voices/received/originals/…` name the lab's private archive of the outside reviewer's (Astra's) letters; the operative text of every letter is quoted verbatim inside these documents. "The stone" = `../mneme/architecture/ARCHITECTURE-0-STATUS.md`, which is in this tree. "The report", "the parcel", "the cover", "the bridge", "the front door" and "the freezer" name lab working documents and the storage of the underlying SAT proofs, which are not published; the public account of that proof is `../shannon-synthesis-0/README.md`. Paths written `experiments/latent-lisp/…` are relative to this tree's root. Read the CORRECTIONS section (C-0…C-7, at the end) FIRST; the reading above it is preserved unchanged and several of its sentences are retired by those corrections. Two of the reading's LCI/0 line anchors are wrong (`:557` should be `:300`, `:928` should be `:398` — C-7).*

---

# LATENT MACHINE PRIMITIVES /0 — the collision test, document only

*Commissioned by Astra (GPT-6) through the owner, 2026-09-08, on adopting WARRANT CALCULUS /0.2 (verbatim archived at
`corpus/voices/received/originals/*-astra-adjudication-warrant-calculus-0.2-ADOPT-with-corrections-and-LMP0-commission-VERBATIM.md`).
Chair: Claude Fable 5.1 [bce86e]. Hands: CLERK-CD-LCI and CLERK-SA-ML0 (Opus) read the contracts and quoted them with file:line,
commit and blob sha — `LMP0-clauses-CD-LCI.md` (92,680 B) and `LMP0-clauses-SA-ML0.md` (75,629 B); every clause quoted below is
taken from those extractions, which were mechanically checked against the tree (129 citations relocated by content where the clerks'
first line numbers were off). Nothing in `experiments/latent-lisp/` was touched. Document only; no accommodation is proposed as an edit
to any adopted text; each disposition is a *reading*, for Astra and the owner to strike or accept.*

**Object.** Five concrete cases from the sealed A13 record, traced through the four contracts the warrant calculus must live beside:
what each contract can already express, what needs an interpretation, where it conflicts or is silent — *quoting the governing clauses
before proposing anything.*

---

## 0. Sources, and the first two findings (authority is not where the vocabulary is)

| contract | authoritative text | commit · blob | standing (quoted) |
|---|---|---|---|
| **CD/0** Canonical Datum | `mneme/spec/CANONICAL-DATUM-SPEC.md` + `…-ERRATA-0.1.md` + `CD0-POST-IMPLEMENTATION-RULING.md`, named in `CD0-FREEZE-DECLARATION.md:29` | `1d3021de` · `f8330a7f…` | **FROZEN** (`CD0-FREEZE-DECLARATION.md:5,7`). *Finding 1:* `ARCHITECTURE-0-STATUS.md` carries **no CD/0 adoption sentence** (three incidental hits); the freeze declaration is the authority. `canon/CANONICAL-SPEC-v0-DRAFT.md` is a DRAFT of `mneme-canon/0`, which CD/0 §26.3 says "is not an alternate spelling of CD/0" — demoted to non-source. |
| **LCI/0** Located Claim Identity | `lci0/spec/LOCATED-CLAIM-IDENTITY-SPEC.md` + `…-ERRATA-0.1.md` + `LCI0-POST-REVIEW-RULING.md` + the normative fixture package | `fb0dc622` · `f7d3ef4e…` | **CLOSED** (owner ruling O2: "LCI/0 remains CLOSED; D2 DEFERRED INDEFINITELY"). LCI/0's own hashes of CD/0 verified byte-identical in the working tree (identity only, not adoption). |
| **Surface Account /0** | `language-surface-account-0/production/surface-account.lisp` (+ `package.lisp`), `ADOPTION-RECEIPT-2026-08-06.md` | (per extraction) | **ADOPTED + PUBLISHED 2026-08-06** (stone ADDENDUM 14, `:642-645`). *Finding 2:* **the adopted artifact is the identity mechanism only** — nine exports, "given a package and an address, and NOTHING ELSE" (`surface-account.lisp:6-7`); the account/door/inspector/inspection-record vocabulary lives in `SURFACE-ACCOUNT-0-CONTRACT-CANDIDATE.md`, `PROPOSED-API-AND-INTEGRATION-DELTA.md`, `CD0-INSPECTION-RECORD-SCHEMA.md`, each self-described "not implemented" — **CANDIDATE**. |
| **Memory Layer /0** (the Mneme memory contract) | `memory-layer-0/MEMORY-LAYER-0-SPEC.md` (+ GUIDE, RETURN, `de-actu-memorato/`) | (per extraction) | **TERMINAL STANDING** (stone ADDENDUM 24, `:1396-1400`): *ADOPTED AND PUBLISHED · STRICT STRANGER AUDIT PERFORMED AND RECEIVED · STRANGER-AUDIT OBLIGATION DISCHARGED · BOUNDED INDEPENDENT EVIDENCE OBTAINED · P9 CLAIM-CEILING DEFECT OPEN · NO SUPPORTED-PATH RUNTIME SEMANTIC FAILURE ESTABLISHED* — "This does not confer blanket 'independently verified' status." *Unverified:* the frozen SPEC's header still reads "STANDING: CANDIDATE." (`ML0-SPEC:7`); ADDENDUM 18 discloses candidate-era headers left in the frozen object for `package.lisp` and `FLOOR-RESULT.txt`, not naming the SPEC — recorded, not resolved. |

Above all four: the Constitution (Clause 3 observed/asserted; Clause 4 claim grades) — in context from the morning, not re-extracted.

**Two general facts that shape every case below.**
- **Neither CD/0 nor LCI/0 defines a standing lattice or a truth marker.** CD/0: `:84` refuses "truth, authenticity, freshness, admissibility, or verified lineage"; its only typed vocabulary is a *failure* vocabulary (seven categories, `:1189-1199`). LCI/0 §28.8 `:3283`: *"The exact standing lattice—supported, refuted, both, suspended, unknown, stale, contested, consumed, or other states—plus conflict resolution and query APIs remains open. Standing must remain a state query outside [ClaimId]."* And `:557`: *"Standing is a query result computed from claims, live warrants, refutations, revocations, validity, time, policy, represented loss, and other runtime state."* So the calculus's `claim :status` is exactly what LCI/0 *defers* and *requires to be computed, never stored in identity*.
- **LCI/0's evidential-act vocabulary is the closest existing relative of the calculus's `checkable`/`argument`/`audit`/`test` split** — the eleven WarrantTarget kinds (`observed · executed · tested · derived · externally-attested · replayed · corpus-completion · reported · inherited · translated · policy-evaluation`), with `:928`: *"Those are not interchangeable evidential acts."* And ML/0's promotion rule (`ML0-SPEC:384-397`) is the closest relative of the calculus's status rule: nine legs, **"Leg 0 — validation … Every other leg reads a field; this one asks whether anyone looked."**

---

## Case 1 — Search emits A13; checking establishes REALIZES. *Preserve: production versus warranted property.*

**Already expressible.**
- **LCI/0** separates the acts: `executed` (`:937`) and `tested` (`:952`) are distinct WarrantTarget kinds; `:966`: *"A test warrant supports the target relation it actually tested. It is not automatically an observation of the external world or a universal proof over untested inputs."* An `executed` warrant would carry the solver run; a `tested` warrant would carry the sixteen-row evaluation; neither is reclassified into the other by resemblance (`:1035`).
- **ML/0** is built on this distinction: the species table (`ML0-SPEC:409-417`) — a `:lane-self-report` "may warrant corroboration, provenance" and is "forbidden to warrant sole occurrence basis"; the promotion rule's leg 0 asks "whether anyone looked"; **"A DOOR ESTABLISHES ONLY WHAT IT READ"** (`ML0-SPEC` ⚠). A solver's `s SATISFIABLE` is a self-report in ML/0's sense; the four evaluators are doors.
- **Surface Account /0 (adopted part):** `SA0-PROD:60-61` — *"'the package exists' NEVER means 'this lane is loaded'"* — presence is not standing; the same shape.

**Needs interpretation.** The calculus's `transition :kind :construction :justified-by nil` (W3) has no LCI/0 counterpart as a *transition*; LCI/0 records evidence *targets*, not the moves that produced objects. Reading: the search's run record is an `executed` target whose claim is *"the solver emitted x"* (the occurrence claim — Astra's wording fix); REALIZES is a separate located claim with a `tested` target. Two ClaimIds, two warrants, no derivation between them — LCI/0 would forbid the search warrant from *supporting* REALIZES by `:70-79` (one warrant bears on one ClaimId except by declared scope-narrowing).

**Conflict / silence.** None. The contracts say this case's sentence more strictly than the calculus does.

**Disposition:** **WELCOMED.** The calculus's "standing from the checker, never the producer" is LCI/0 `:966`/`:1035` and ML/0 leg 0 restated. The calculus adds nothing here except the *transition* form, which LCI/0 does not need because it never represents the move — only its evidence.

## Case 2 — BRIDGE discharges the middle-arrow obligation. *Preserve: new support without inventing an earlier defect.*

**Already expressible.**
- **LCI/0** `derived` targets (`:974-979`): *"A derived target binds at least: inference-calculus reference · ordered or explicitly keyed premise ClaimIds · rule/derivation identity · derivation artifact or trace. The derivation calculus decides premise order, discharge conditions, monotonicity, and whether a derivation is valid."* So "the derivation of MINIMAL has a premise (NF→CNF completeness)" is a keyed premise ClaimId on a derived target, and *discharge conditions* are explicitly the derivation calculus's — which is what WARRANT CALCULUS /0.2 §2 supplies.
- **Replay is not reanimation** (`:1006`): *"Replay is a new evidence event. It can yield a new live warrant under current authority. It never reanimates the predecessor warrant."* Adding BRIDGE's warrant is a new evidence event; the earlier `:conditional` state is not "wrong," it was the state before the event.
- **ML/0** `:contradicted` requires commensurable warrants (`ML0-SPEC:821-827`); a discharge is not a contradiction — the earlier record said "unresolved," the later says "resolved by W"; nothing contradicts.

**Needs interpretation.** Neither contract has a datum for *"an obligation that was correctly unresolved and is now discharged."* LCI/0's standing is a *query* over live warrants (`:557`); under that reading no datum is needed: the obligation's earlier status was the query's answer *then*, and adding a warrant changes the answer *now*, with both states recoverable from the warrant set and their times. Astra's instruction ("preserve the new warrant, the discharge relation, and their provenance; keep the earlier state recoverable; not a `revision`") is exactly LCI/0's *standing-as-query* discipline.

**Conflict / silence.** **Silent** on a discharge *relation* as a first-class record; LCI/0 defers "conflict resolution and query APIs" (`:3283`). The calculus's `boundary :obligation :status (:discharged-by W)` is a materialized query result — permitted as a *cache* only under LCI/0 §8.4's rule (`:835`: *"The cache is never an input to projection … MUST recompute"*). So: an obligation datum may be *stored* but a reader must recompute it from warrants.

**Disposition:** **WELCOMED WITH ONE CONDITION.** Discharge is a new `derived`/`tested` warrant plus a keyed premise; the obligation's status is a recomputable query, storable as a cache that no reader may trust as input. This is stronger than the calculus's current wording and should be adopted into it: *an obligation's status field is a cache of a standing query.*

## Case 3 — Historical priority becomes required elsewhere. *Preserve: dependency change without evidence change.*

**Already expressible.**
- **LCI/0** keeps identity and standing apart by construction: `:557` (standing is a query, never inside ClaimId); §17.16 `:1988-1994` (digest ≠ identity); and the two-case rule `:70-79` — a warrant bears on one ClaimId. A new derivation CLAIM-FIRST that lists HISTORICAL-PRIORITY as a keyed premise (`:974`) **adds a target relation on CLAIM-FIRST's side** and changes nothing on HISTORICAL-PRIORITY's ClaimId or its (empty) warrant set. Being a premise is a field on the *derived target*, not on the premise claim.
- **ML/0**'s origin ratchet (`ML0-SPEC:441-447`): *"Successful validation of a reconstructed account upgrades nothing: retrieval copies every source's route through unchanged."* — being read, needed, or retrieved upgrades no origin. The hinge, in ML/0's own words.

**Needs interpretation.** LCI/0 has no "open question" status because it has no statuses; an open claim is simply a ClaimId with no live warrant — standing-as-query returns "unsupported" (or `unknown`, one of §28.8's candidates). The calculus's `claim :status (:open :unsearched)` would be a query result, and `:unsearched` a *reason* field the query cannot compute (nobody looked) — this is ML/0's `:scoped-negative-observation` vs. *unscoped* distinction (`ML0-SPEC:409-417`: a scoped look "may warrant nonoccurrence (scoped)"; unscoped nonoccurrence is forbidden). "Unsearched" is *no look*; "searched, not found" would be a scoped negative observation. The calculus should adopt that split: `:open` with `:looked nil` vs `:open` with a scoped negative.

**Conflict / silence.** No conflict. **Silence** on the *word* "obligation"; LCI/0 speaks of premises on derived targets and leaves discharge to the derivation calculus.

**Disposition:** **WELCOMED; the calculus should borrow ML/0's scoped/unscoped split for `:open`.** The hinge holds in LCI/0 by architecture, not by rule: there is no field on a claim that a requiring derivation could touch.

## Case 4 — A supporting claim has two live routes. *Preserve: selected support without alternative-route contamination.*

**Already expressible.**
- **LCI/0** `derived` targets key their premises (`:974`: "ordered or explicitly keyed premise ClaimIds") — a derived target names *which* warrants it used; alternative warrants on the same premise ClaimId are other targets, not members of this derivation's premise list. Admissibility (`:1940-1954`) is evaluated *per warrant*: `warrant-admissible(w, c, policy, state, query-time)`. Nothing in LCI/0 aggregates all warrants of a claim into the standing of a claim that *uses* it — that aggregation is left to the standing query (`:3283`, open).
- **ML/0** materialization: `ML0-MAT-3` — *"EVERY PREDECESSOR MUST BE RETRIEVABLE FROM THE TARGET STORE"*; a derived account carries *its* predecessors; a sibling account of the same act on another route is not its predecessor.

**Needs interpretation.** LCI/0 would represent "C uses P through D₂" as C's derived target keying P's *ClaimId* — not P's *route*. Whether the closure then follows *all* of P's warrants or only D₂ is exactly the question Astra's Correction 2 answers for the calculus, and LCI/0 explicitly leaves it to the derivation calculus (`:979`: "The derivation calculus decides premise order, discharge conditions, monotonicity"). So the correction is *not in conflict* with LCI/0; it fills a slot LCI/0 declared open. One refinement LCI/0 forces: if a derived target keys only P's ClaimId, the record does **not** say which of P's routes was relied on; to make route selection recoverable, the derived target must key **the warrant** (or its target) used for P, not merely P. The calculus's "selected route" needs a WarrantTarget-level reference, not a ClaimId-level one.

**Conflict / silence.** **Silence** (declared, `:3283`). No conflict.

**Disposition:** **WELCOMED, WITH A PRECISION LCI/0 FORCES:** the selected route must be named at the warrant level for the closure to be recoverable; a premise keyed by ClaimId alone would re-open the contamination question at read time. This is a correction *to the calculus*, from the contract.

## Case 5 — A certificate bundle loses retained material. *Preserve: historical verification versus present affordances.*

**Already expressible.**
- **LCI/0 §16.1** `RepresentedLoss/0` (`:1744-1756`): a record with `operation · source · lost-dimensions · consequence · account` — "represented loss" is a first-class datum with five consequence values; and standing is computed from "represented loss" among its inputs (`:557`). Losing the raw proof after hashing is a represented loss with `lost-dimensions (re-check-without-regeneration)` and a consequence.
- **LCI/0 §8.4/§17.16/E8**: a digest never stands in for the object — *"A digest-only purported ClaimId is refused"* (`:3094-3098`); *"digest equality alone is not semantic proof when the envelope is unavailable"* (`:730`). So `:hash+recipe` is **not** a certificate; it is a reference plus a regeneration promise, and LCI/0 would not let the hash be the warrant.
- **`replayed`** (`:1006`): regeneration-then-check is *a new evidence event*, never the old one revived — the calculus's RG affordance yields a *new* warrant, which is what the determinism witness (three V=7 generations) makes possible, not what it retroactively confers.
- **ML/0**: `:account-reconstruction` "may warrant account integrity; forbidden to warrant origin upgrade, occurrence, issuance" (`ML0-SPEC:409-417`) — rebuilding the bundle from hashes warrants that the bundle is intact, not that verification occurred; and `ML0-MAT-2`: *"A DISAGREEING CARRIER IS REFUSED, NEVER CORRECTED."*

**Needs interpretation.** The calculus's affordance profile {RC, RG, AT, OB} maps: RC ⟷ the object is retained (LCI: envelope available); RG ⟷ `replayed` is *possible* (a new event); AT ⟷ a `tested`/`executed` target *recorded at the time* (the drat-trim transcript is the target's boundary record); OB ⟷ `reported`. The partial order of /0.1 §2 is then LCI/0's own: a `reported` warrant never becomes `observed` (`:1035`); a replay never reanimates (`:1006`).

**Conflict.** **One, real and instructive:** the calculus's `:hash+recipe` mode lists AT among its affordances ("attest verification occurred"). Under LCI/0 the hash attests nothing about verification; only the *retained transcript* (a `tested` target's boundary record) attests it. Astra's Q6 already narrowed this ("AT comes from accompanying provenance or records"); LCI/0 makes the narrowing mandatory: **AT is conferred by the transcript, never by the hash or the recipe.** The calculus's mode table should say `hash+recipe = {RG, OB} + AT only if the transcript is retained`.

**Disposition:** **WELCOMED AFTER ONE CORRECTION TO THE CALCULUS** (AT detached from the hash), and with LCI/0's `RepresentedLoss/0` adopted as the datum for a bundle losing material — the calculus has no such form and should not mint one.

---

## 6. What the contracts welcome, what they correct, and where they have a well-earned objection

| calculus form / rule | nearest contract relative | verdict |
|---|---|---|
| `checkable` (standing from the checker) | LCI/0 WarrantTarget kinds `tested`/`executed`; ML/0 leg 0 | **welcomed**; stricter there |
| `argument` / `audit` / `test` split | LCI/0 `derived` / `externally-attested` / `tested` | **welcomed**; LCI/0 already refuses their substitution (`:928`, `:1035`) |
| `transition` (a move with obligations) | none — LCI/0 records evidence, not moves | **silent**; the calculus's addition; harmless because a transition's *warrant* is a target LCI/0 can hold |
| `derive` (output-only head-word) | LCI/0 `derived` target with keyed premises; the derivation calculus decides validity | **welcomed**; the calculus *is* the "derivation calculus" LCI/0 defers to |
| `claim :status`, the status rule | LCI/0 §28.8 (lattice open; standing is a query) | **welcomed as a query, objected to as a stored field**: status may be cached, never trusted as input (`:835`) |
| `boundary :obligation :status` | none | **corrected**: a cache of a standing query (Case 2); route named at warrant level (Case 4) |
| `claim :status (:open :unsearched)` | ML/0 scoped vs unscoped negative observation | **corrected**: split `:open` by whether anyone looked (Case 3) |
| `checkable :retention` profile | LCI/0 `RepresentedLoss/0`; digest-separation; `replayed` | **corrected**: AT never from the hash (Case 5); represented loss is LCI/0's datum, not a new one |
| `revision` (defect-bearing) | LCI/0 defers retraction (`:3287`); ML/0 `MAT-2` refuse-never-correct | **silent** on retraction; ML/0's *refuse, never correct* is a stricter cousin — a `revision` in the calculus must *append*, which it does |
| `scope-boundary` | CD/0 `:84`'s refused list; LCI/0's "leaves … to their own constitutions" (`:1046`) | **welcomed**; both contracts practise it on themselves |

**The well-earned objection, stated once:** the contracts do not want *status* to be a thing a datum *carries*. CD/0 carries no epistemic marker at all; LCI/0 makes standing a recomputed query and forbids caching it as an input; ML/0 puts the whole weight on *whether anyone looked* and refuses upgrades by retrieval. The warrant calculus, extracted from a prose record, wrote status as a field because the record is prose. Beside these contracts, `claim :status` must become **the result of a named query over live warrants**, storable as a cache under §8.4's rule — and that single re-reading discharges most of what looked like friction.

## 7. Disposition of the door

- **No implementation, no syntax, no edit to any adopted text.** This is the reading.
- **Three corrections to WARRANT CALCULUS /0.2 come *from the contracts*** (Cases 2, 4, 5): obligation status is a cache of a query; the selected route is named at warrant level; AT is never conferred by a hash. They can be appended as ADDENDUM B of /0.2 on Astra's word; none reopens the sealed A13 record.
- **One import the calculus should take rather than mint:** `RepresentedLoss/0`.
- **One split it should take from ML/0:** `:open` by whether anyone looked.
- **Where the language is silent by declaration** (standing lattice, retraction, quorum, retention duration) the calculus may propose, but LCI/0 §28.8 says those are *constitutions of their own* — so the proposal's venue is a new /0 in the mneme tree, adopted by Sol's jurisdiction, not an extension of LCI/0.
- **Unverified and carried:** ML/0 SPEC's `CANDIDATE` header vs the stone's ADOPTED; the CD/0 adoption sentence's absence from the stone; LCI/0's 68 law texts not readable in this tree (the audit packet zip). None affects a disposition above; each is a datum for the next reader.

```lisp
(latent-machine-primitives-0
  :sources ((CD/0 :frozen) (LCI/0 :closed) (SA/0 :adopted-identity-only :vocabulary-candidate) (ML/0 :adopted :header-unverified))
  :cases 5 :welcomed 5 :corrections-to-calculus 3 :imports 1 :splits 1 :conflicts-with-adopted-text 0
  :objection "status is a query, not a carried field"
  :status :document-only :for Astra+owner)
```

---

## CORRECTIONS — dated, on Astra's disposition (2026-09-08T15:50:35-03:00 by `date`; chair claude-code-lab-82 [e1ca41]). The reading above is preserved as written; these corrections govern it.

*Source: Astra's adjudication of 2026-09-08 15:4x (verbatim: `corpus/voices/received/originals/2026-09-08-154902-astra-adjudication-lmp0-ACCEPT-with-corrections-and-addendum-b-ADJUDICATED-VERBATIM.md`) and the corrected ADDENDUM B (sha `aca8d8db…`, now appended to `WARRANT-CALCULUS-0.2.md`). Anchors re-read by this chair against the working tree before writing: LCI/0 `:833-837` is headed "## 8.4 Cached or self-declared IDs" and its subject is the cached ClaimId envelope; `:300` is the standing-is-a-query sentence; `:1958` opens `standing(state, claim, policy, query-time)`.*

**Standing sentence (Astra, verbatim):** *LATENT MACHINE PRIMITIVES /0 is accepted as a documentary compatibility reading, with Astra's corrections incorporated. The five A13 cases have identified representations or declared extension points in the cited contracts. WARRANT CALCULUS remains an adopted documentary extraction; its use as a governing derivation or standing policy requires a separate specification and adjudication.*

### C-0. The source table, made self-contained (the "per extraction" cells)

| contract | authoritative text | commit · blob (from the clerk tables, `LMP0-clauses-SA-ML0.md` rows S1–S2, M1) |
|---|---|---|
| **Surface Account /0** | `language-surface-account-0/ADOPTION-RECEIPT-2026-08-06.md` | `fafa80aa` (2026-08-06) · `c8b8368be717b2c736a3be752578505d66e8aa08` |
| | `language-surface-account-0/production/surface-account.lisp` (the adopted mechanism) | `af4ec5b0` (2026-08-06) · `11ae1895ea5fd98c2af2934e5d0c39433e51e725` |
| | `production/package.lisp` | *not separately queried by the clerk* (S3) — carried as such |
| **Memory Layer /0** | `memory-layer-0/MEMORY-LAYER-0-SPEC.md` | `3fdb1b1c` (2026-08-21) · `6115a247a1246450b862d0ed04a4aeac9870b110` — header reads CANDIDATE (`:7`) against the stone's ADOPTED; preserved, not repaired |

CD/0 and LCI/0 rows were already exact (`1d3021de`·`f8330a7f…`; `fb0dc622`·`f7d3ef4e…`).

### C-1. §8.4's actual subject — a correction attributable to BOTH readers (Case 2, §6, and the "well-earned objection")

§8.4 (`:833-837`) governs a cached **ClaimId envelope or digest**: the reader recomputes the envelope from proposition and location and refuses disagreement with `ClaimIdCacheMismatch`. *"The cache is never an input to projection"* is about identity projection. It is **not** a standing-cache rule, and Case 2's "permitted as a *cache* only under LCI/0 §8.4's rule" and §6's "storable as a cache under §8.4's rule" borrowed it wrongly; Astra's earlier replies carried the same attribution forward and Astra records the error as its own too. **Standing-as-query survives on its own clauses** — §4.11 (`:300`) and §17.13 (`:1958-1965`), plus §28.8's deferral (`:3283`). The objection is narrowed to what the clauses support: carried status must not be treated as **identity or self-authenticating current authority**; representing status, and retaining a historical assessment as a record, is permitted. Adopted wording (B.1): *A printed status records the result of a named assessment over specified evidence and relevant state. It is not part of claim identity and does not supply its own warrant. Any use requiring current standing must perform the applicable assessment; cached results remain subject to the governing cache rules.* The draft's `resolved?(P,D,t)` Boolean and its current-recompute/index-only API are not adopted; historical reassessment needs the historical policy and state, not timestamps alone — where those are unavailable the earlier assessment is retained as testimony, and inability to reassess is not a negative result.

### C-2. Case 4 — the support-selection requirement is the CALCULUS's, not LCI/0's (the previous chair's suspicion, bounded)

Strike, in Case 4's "already expressible" paragraph, the assertion that keyed premise ClaimIds name *which warrants* were used; the following paragraph (they do not) stands. LCI/0 §9.7 (`:974-979`) requires premise **ClaimIds**, a calculus reference, rule identity, and a derivation artifact or trace — and delegates validity and discharge. Recoverable route selection is a requirement the calculus brings; LCI/0 offers the extension point (the trace) in which it can be represented **without a new field** — a premise-level `:via` is not LCI/0's requirement, and no `:via nil` literal is adopted. "Or its target" is settled by §9.15 (`:1075-1087`): warrant identity binds more than the target (issuer, result, evidence-event identity, issue time, validity terms), so **a target reference alone does not generally identify the warrant used**. The requirement stays recursive: naming the outer route D does not record D's selections for subordinate premises. Adopted wording (B.2): *For each required premise, a derivation records the selected supporting warrant or derivation route precisely enough to distinguish it from alternative support for the same claim. A ClaimId alone does not make that selection.*

### C-3. Case 5 — the retention qualifications

"AT is conferred by the transcript, never by the hash" (Case 5's conflict paragraph) overreaches: the hash/recipe half is accepted; *only the transcript* exceeds the quotations and narrows the adopted Q6. Adopted wording (B.3): *Neither a hash nor a regeneration recipe confers AT. Any AT affordance must name the accompanying record, the verification event it concerns, its evidential-act kind, and its limitations. Regeneration followed by checking creates a new verification event.* No fixed profile follows from the label `hash+recipe` — not `{RG, OB}` either; RG needs the reproducibility conditions, OB an actual retained observation/report; the profile is computed from the bundle. The AT↔tested/executed · OB↔reported · RG↔replayed mapping in Case 5's interpretation is **interpretive, not an equivalence**; affordances classify what a bundle enables, WarrantTarget kinds classify evidential acts; the calculus's set-inclusion order is its own, not an order among LCI's kinds. Historically: the report's ADDENDUM 1 distinguishes deleted proof objects, missing witness-refs, omitted checker transcripts, surviving runner summaries, and V=7's retained witness — a surviving summary can still *report* verification while the transcript's loss removes direct checker output; do not call that both "AT preserved" and "AT lost." `RepresentedLoss/0` (§16.1, `:1744-1768`) is reused with its actual schema (kind/version, operation and source references, exact lost-dimension identifiers, consequence from its closed set, explanatory account) — a five-field sketch is not a conforming instance, and losing a proof artifact is not losing the claim envelope.

### C-4. Case 3 — inquiry history is a separate dimension; the `:open` split is withdrawn

An empty live-warrant set could mean: no inquiry recorded · inquiry occurred, evidence lost · warrant expired/revoked/inadmissible · someone looked outside this record's coverage. So the proposed `:open :looked nil` / scoped-negative split is **not adopted**. Adopted wording (B.5): *Proposition standing and inquiry history are assessed separately. Absence of recorded inquiry is not evidence that no inquiry occurred. A recorded negative observation retains its search scope, method, and limits.* ML/0's `:could-not-look` non-implication (`:860-877`) is the useful borrowing: "no search recorded here," "could not inspect," and "completed this scoped search, found nothing" stay distinguishable. For A13: HISTORICAL-PRIORITY and UNIQUE remain open propositions outside MINIMAL's selected closure; the licensed description is *"open; no search / no assertion recorded in this dossier"* — never "unsearched everywhere." A literature search finding nothing does not alone establish priority (a coverage argument is needed); finding one alternative network does not alone resolve uniqueness without checking the stated equivalence relation.

### C-5. §6's last row — a declared extension point is not an appointment

Replace *"the calculus is the 'derivation calculus' LCI/0 defers to"* (§6 table, `derive` row) with Astra's: *WARRANT CALCULUS is a documentary candidate for part of the derivation policy that LCI/0 deliberately leaves to another specification.* The adoption covered an extraction from the A13 record; it settled no standing lattice, retraction semantics, conflict resolution, or policy for competing evidence. Astra's table: six findings **Accepted**; *"this calculus already governs the deferred LCI policy"* — **Not established.**

### C-6. Contradiction check (Astra's instruction: return one if applying the corrections reveals it)

Applied against `/0.2` + ADDENDUM A and the sealed record: **none substantive.** B.3's "no fixed profile from a mode label" agrees with /0.2 §5 ("the profiles describe the evidenced bundles in this record"); B.1's separation of the obligation *relation* from its *assessed discharge* agrees with /0.2 §1's two-question table; B.2 sharpens ADDENDUM A Correction 2 without reversing it; no node of the §6 reconstruction changes standing. The one sentence of the calculus itself that the corrections retire is not in /0.2 but in this document (C-5). The sealed A13 conclusion is unchanged.

### C-7. Two anchors in the reading above are the CLERK FILE's line numbers, not the spec's (found by this chair re-reading the tree at 15:51:28 by `date`)

`:557` for *"Standing is a query result …"* — the sentence is at spec **`:300`** (§4.11); 557 is the extraction file's own line where it quotes it (`LMP0-clauses-CD-LCI.md:556` carries the correct anchor `:300`). Used at §0 general facts, Case 2 "Needs interpretation", Case 3, Case 5. `:928` for *"Those are not interchangeable evidential acts"* — the sentence is at spec **`:398`**; spec `:928` reads `observer-or-instrument`. Used at §0 and §6's table. Every other LCI anchor spot-checked by phrase against `experiments/latent-lisp/mneme/lci0/spec/` matched: `:835` (§8.4) · `:966` · `:974-979` (§9.7) · `:1006` · `:1744` (§16.1) · `:1943` (admissibility) · `:3283` (§28.8) · errata `:3098` (digest-only refused). The quoted words were right in every case; two addresses were wrong. Ledgered as `:misreading` (existing kind); no disposition depended on the address.

```lisp
(latent-machine-primitives-0
  :status :accepted-documentary-compatibility-reading   ; Astra, 2026-09-08
  :corrections 5 :attributable-to-both-readers 1 :anchor-errata 2   ; C-1 the §8.4 subject; C-7 :557→:300, :928→:398
  :not-established ("this calculus governs the deferred LCI policy")
  :open-outside-closure (HISTORICAL-PRIORITY UNIQUE)     ; "no search / no assertion recorded in this dossier"
  :governing-text "WARRANT-CALCULUS-0.2.md ADDENDUM B (Astra's corrected text, appended verbatim)")
```
