*PUBLIC READER'S NOTE (prepended at publication, 2026-09-08). The body below the `---` rule is byte-identical to the lab source; see PROVENANCE.md for its blob hash and the strip recipe. Paths of the form `corpus/voices/received/originals/…` name the lab's private archive of the outside reviewer's (Astra's) letters; the operative text of every letter is quoted verbatim inside these documents. "The stone" = `../mneme/architecture/ARCHITECTURE-0-STATUS.md`, which is in this tree. "The report", "the parcel", "the cover", "the bridge", "the front door" and "the freezer" name lab working documents and the storage of the underlying SAT proofs, which are not published; the public account of that proof is `../shannon-synthesis-0/README.md`. Paths written `experiments/latent-lisp/…` are relative to this tree's root. This draft is NOT adopted; it is preserved as history at the reviewer's instruction. The ADDENDUM B in force is the reviewer's text appended to `WARRANT-CALCULUS-0.2.md`.*

---

# WARRANT CALCULUS /0.2 — ADDENDUM B, DRAFT — the three corrections the contracts sent back (NOT IN FORCE)

*Drafted 2026-09-08T15:38:43-03:00 by `date`, Claude Fable 5.1, chair claude-code-lab-82 [e1ca41], laptop. **This file is a proposal for Astra to strike
or accept; nothing in it is appended to `WARRANT-CALCULUS-0.2.md` until Astra's word.** The front door (§3) records the obligation:
"three corrections it proposes to the calculus … want an ADDENDUM B on Astra's word — not written yet." This is the draft of that
addendum, so that Astra's disposition of LATENT MACHINE PRIMITIVES /0 can strike a text rather than an intention. Source of every
correction: `LATENT-MACHINE-PRIMITIVES-0.md` Cases 2, 4, 5 (+ the import and the split from Cases 5 and 3), each of which quotes the
governing contract clause first; the clause references below are to `LMP0-clauses-CD-LCI.md` / `LMP0-clauses-SA-ML0.md` line anchors
into the authoritative texts (LCI/0 at blob `f7d3ef4e…`, ML/0 SPEC per extraction). Nothing here touches the sealed A13 record, the
inscription, or any adopted Lisp+ text.*

## B.0 What this addendum does and does not do

It amends three sentences of /0.2 (one in §1's table, one in §2 step 5 / ADDENDUM A Correction 2, one in §5) and adds one import and one
split. It mints **no** new form: the ten forms stay ten. It changes **no** status in the reconstruction of §6 — every node's status is
the same after re-running; what changes is *what the status field is* (a cache) and *what two references point at* (a warrant, not a
claim; a transcript, not a hash).

## B.1 Correction 1 — an obligation's `:status` is a cache of a standing query (from Case 2; LCI/0 `:557`, `:835`, §28.8 `:3283`)

Governing clauses. LCI/0: *"Standing is a query result computed from claims, live warrants, refutations, revocations, validity, time,
policy, represented loss, and other runtime state."* (`:557`) · *"The cache is never an input to projection."* (`:835`) · *"Standing must
remain a state query outside ClaimId."* (`:3283`) · *"Replay is a new evidence event … It never reanimates the predecessor warrant."* (`:1006`).

Amendment, replacing the reading of `boundary :kind :obligation (:of P :required-by D :status …)` in /0.2 §1's table and §2 step 6:

> **The `:status` of an obligation is not a fact the datum carries; it is the cached answer of a named query over the live warrants at a
> stated time: `resolved?(P, D, t)` — true iff some warrant admissible at t resolves P for D's stated assumptions. A discharge is recorded as
> the new warrant plus the relation `(discharges W P :for D :at t)`, both with provenance; the earlier answer is recoverable by re-running
> the query at the earlier time. A reader MUST recompute the status from the warrants and MAY use the cached field only for indexing.
> Discharge is not a revision (ADDENDUM A, last paragraph): nothing on the earlier record was erroneous.**

Consequence for §6: `(boundary :kind :obligation :of NF->CNF-completeness :required-by (derive MINIMAL) :status (:discharged-by BRIDGE
:audited-by Astra))` reads unchanged on the page and means: *cache of `resolved?(NF->CNF-completeness, derive-MINIMAL, 2026-09-08T14:34)`
= true via BRIDGE.* Before 14:34 the same query returned false; that earlier answer was correct then.

The same rule governs `claim :status` (LMP/0 §6, the contracts' one objection): status is the result of the §2 status rule *run over the
live warrants*, storable as a cache, never an input. The status rule of /0.2 §2 is therefore the query; the field is its memo.

## B.2 Correction 2 — the selected route is named at the WARRANT level, never by ClaimId alone (from Case 4; LCI/0 `:974`, `:979`, `:1940-1954`)

Governing clauses. LCI/0 `derived` targets bind *"ordered or explicitly keyed premise ClaimIds"* (`:974`); *"The derivation calculus
decides premise order, discharge conditions, monotonicity, and whether a derivation is valid"* (`:979`); admissibility is per warrant,
`warrant-admissible(w, c, policy, state, query-time)` (`:1940-1954`).

Amendment, sharpening ADDENDUM A Correction 2 ("Dependency closure follows the supporting route selected for each required claim"):

> **A derivation that uses a required claim P through a route D₂ MUST reference D₂'s warrant (or its target) — not merely P's ClaimId. A
> premise keyed by ClaimId alone does not record which of P's routes was relied on, and a reader following it would re-open at read time
> the contamination the recursive rule closed at write time. Concretely: `(derive C … :premises ((P :via W_D₂) …))`, never `(P)`.**

Consequence for §6: `(derive MINIMAL … :route D …)` already names the route; the hypothetical hinge node becomes
`(claim CLAIM-FIRST :hypothetical t :status (:conditional :through D₃ :premise (HISTORICAL-PRIORITY :via nil)))` — `:via nil` printed,
because HISTORICAL-PRIORITY has no warrant to select; the emptiness is now visible at the premise, not only at the claim.

## B.3 Correction 3 — AT is conferred by a retained transcript, never by a hash or a recipe (from Case 5; LCI/0 `:730`, `:1006`, `:3094-3098`; ML/0 `:409-417`, `MAT-2`)

Governing clauses. LCI/0: *"digest equality alone is not semantic proof when the envelope is unavailable"* (`:730`); *"A digest-only
purported ClaimId is refused"* (`:3094-3098`); replay is a new evidence event (`:1006`). ML/0: `:account-reconstruction` *"may warrant
account integrity; forbidden to warrant origin upgrade, occurrence, issuance"* (`:409-417`); *"A DISAGREEING CARRIER IS REFUSED, NEVER
CORRECTED"* (`MAT-2`).

Amendment to /0.2 §5 (Q6) and to the mode table of /0.1 §2 as read through /0.2:

> **`hash+recipe` confers `{RG, OB}` only. AT (attest-verification-occurred) is conferred solely by a retained verification record — a
> checker transcript or a witness-ref carrying `verified_at` and the checker's verdict — that is itself part of the bundle. A hash attests
> identity of the object; a recipe attests regenerability under stated conditions; neither attests that anyone looked. Regeneration
> followed by checking yields a NEW warrant (`replayed`) with its own AT; it never restores the old one.**

Consequence for §6: no node changes. The seal's V=2–7 at `{AT, OB}` is *reaffirmed*, and the reason is now stated by the contract: AT
came from the run-record's summary line acting as a verification record, and the `:retention-loss` scar (the eaten `*.log`s) was an AT
loss, not an RC loss — the object was gone before; the transcript was what the manifest filter ate.

## B.4 Import — `RepresentedLoss/0` is the datum for a bundle losing material (from Case 5; LCI/0 §16.1 `:1744-1756`)

The calculus mints nothing: a bundle that loses retained material records `(represented-loss :operation … :source … :lost-dimensions
(re-check-without-regeneration) :consequence … :account …)` in LCI/0's shape, and standing queries take it as an input (`:557` lists
"represented loss" among the inputs). The ten forms are unchanged; the loss is a *datum of the record*, referenced by a `boundary`.

## B.5 Split — `:open` by whether anyone looked (from Case 3; ML/0 `:409-417` scoped vs. unscoped negative observation)

> **`:open` carries a `:looked` slot: `(:open :looked nil)` means no search or attempt is on record — this is `:unsearched`; `(:open
> :looked (scoped …))` means a scoped negative observation exists and warrants *nonoccurrence within its scope* only. An unscoped "not
> found" is forbidden as a warrant (ML/0). `:unclaimed` is a third case: nobody asserted the proposition; it is `(:open :looked nil
> :asserted nil)`.**

Consequence for §6 — the two open questions, untouched as claims, restated in the split (their standing does not move):

- `(claim HISTORICAL-PRIORITY(A13) :status (:open :looked nil) :warrants ())` — **:unsearched.** A literature look at the 1950s
  contact-network tables would turn this into either a `realizes`-style priority witness or a scoped negative observation; neither is
  on record. Not in dep⁺(MINIMAL); MINIMAL's standing does not depend on it (the hinge, ADDENDUM A).
- `(claim UNIQUE(A13) :status (:open :looked nil :asserted nil) :warrants ())` — **:unclaimed.** No one has asserted uniqueness of the
  13-contact network up to the model's symmetries; the K=13 SAT instance's other solutions were never enumerated. Not claimed, not searched.

## B.6 The accounting (counted, not confessed)

Sentences amended: **3** (§1 table row for `boundary :obligation`; §2 step 5 as corrected by ADDENDUM A; §5 first sentence's mode
reading). Forms minted: **0**. Forms imported: **1** (`RepresentedLoss/0`, LCI/0's, not the calculus's). Slots added: **2** (`:looked`,
`:asserted` under `:open`; `:via` under a premise). Nodes of §6 whose status changes: **0**. Nodes of §6 whose printed form changes: **2**
(the hinge node's premise gains `:via nil`; the two open claims gain `:looked nil`). Defect-kinds: unchanged at 23 — no new kind is
needed to name any of these; each is `:unstated-precondition` (B.1, B.3) or `:species-flattening` (B.2, B.5) already in the set.

## B.7 Status

```lisp
(warrant-calculus-0.2-addendum-b
  :status :draft-not-in-force
  :on-the-word-of Astra
  :corrections 3 :imports 1 :splits 1 :forms-minted 0 :status-changes-in-reconstruction 0
  :open-claims-untouched ((HISTORICAL-PRIORITY :open :looked nil) (UNIQUE :open :looked nil :asserted nil))
  :strike-hardest "Case 4 — B.2: whether :via at the premise is LCI/0's requirement or the calculus projected onto LCI/0")
```
