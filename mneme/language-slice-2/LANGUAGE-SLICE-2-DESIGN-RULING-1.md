# LANGUAGE SLICE /2 — DESIGN RULING /1

*Owner-adopted 2026-07-25 after independent verification of the Source-Basis Paper /0
package. **This adopts a negative design result.** It adopts no vocabulary, no
representation, no attachment locus, and no paper carrier.*

*— Claude Opus 5 (1M context), chair · SBCL 2.4.6*

```
status:                       owner-adopted design ruling
implementation-authorized:    no
public-api-authorized:        no
specification-frozen:         no
representation-selected:      no
attachment-locus-selected:    no
Slice /2 design progression:  HELD ON CORE /0 ISSUANCE QUESTION
```

---

## 1. What was executed

A paper specimen built *beside* the language: zero package-internal access, no
monkey-patching, no exports, no repository writes. Sixteen traces, eight candidate
designs instantiated and **run to refutation**, five construction vectors. **The chair
ran it twice from clean images: exit 0 both times, byte-identical to the builder's
transcript, 93 checks / 0 failed.**

```
package   slice2-source-basis-paper-0-2026-07-25.zip
bytes     118042
SHA-256   01ac2ec9789a9a3faa01306c00f4457878dcd0eaf80a0e26fe939ba621e8f645
```

Every enclosed entry passed the package's own `SHA256SUMS.txt`, independently verified
by the owner. **The 2,533-line specimen and its transcript are deliberately NOT in this
repository.** This ruling is the durable record; the identity above retrieves the
evidence.

---

## 2. The result — the missing relation has three layers, not two

The owner's reading, adopted:

```
STRUCTURAL COHERENCE    Is this record internally consistent?         REPRESENTABLE
SEMANTIC COMPETENCE     May a coherent record of this shape and       REPRESENTABLE
                        status establish this exact proposition?
ISSUANCE AUTHENTICITY   Did this record actually arise from the       NOT REPRESENTABLE
                        governed act whose history it claims?
```

The first two were **built and executed**. The eight binding clauses are real checks:
they reject empty records, incoherent splices, copied identifiers, mismatched
manifestations, tokens inconsistent with the recorded manifestation, resolver-only
designs and payload-copy designs, and they blocked all eleven promotion routes.
Semantic projection is genuinely independent — binding passes while projection
refuses, at five distinct clauses, and the refusals are contingent in both directions.

**A fully coherent caller-constructed record passes all of them.** The refuting trace:

```
a chamber cycle that never ran
    → an application constructs a complete, coherent Core /0 account for it
    → the kernel event sequence VALIDATES
    → the attempt folds to :COMPLETED
    → source binding reports COHERENT
    → semantic projection reports ESTABLISHES
    → the judgment is ADMITTED
```

and the record's only honest warning is the field it has carried on every line:
`:BINDING-AUTHENTICITY :PAPER-NOT-EVALUABLE`.

> **Coherence is a property of the object. Authenticity is a property of its history,
> and no public reader reaches a history.**

```lisp
(:slice-2-source-basis-paper-0
 :structural-coherence :representable
 :semantic-projection :representable
 :binding-and-projection :independently-varying
 :status-laundering-through-raise :blocked-by-source-basis
 :coherent-forged-source-record :passes
 :source-record-authenticity :not-publicly-evaluable
 :binding-authenticity :not-evaluated
 :core0-subject-readability :insufficient
 :semantic-overreach :refused
 :next-question :core0-evidence-issuance-and-authenticity)
```

---

## 3. The adopted rulings

### R-SOURCE-1.1 — coherence is not authenticity

A record may be internally coherent without having arisen from the act it names.
Kernel validation, event/attempt agreement, manifestation agreement and token agreement
establish **coherence among fields**. They do not establish **historical issuance**.

### R-SOURCE-1.2 — source binding presently has a strict truth ceiling

Under the present public surface, *"source-bound"* can mean only:

> This record is internally coherent, and this semantic relation is competent to
> interpret records of this shape and status.

It **cannot** mean:

> This record was issued by the governed act it names.

### R-SOURCE-1.3 — semantic projection is independent of coherence

A coherent source record may still be **incompetent** to establish the requested
proposition. These stay distinct:

```
attempt account exists · account reports acknowledgment · adapter records success
domain action completed · post-condition established · safe to exhibit
```

### R-SOURCE-1.4 — successful execution is not automatic domain truth

No generic successful effect account establishes arbitrary downstream domain
conditions.

### R-SOURCE-1.5 — status laundering is no longer the earliest failure

Admission Paper /0 showed a fabricated assertion could be promoted and laundered
through standing. **Source-Basis Paper /0 blocks that route.** The surviving route is
earlier:

```
fabricate a coherent source record
  → establish a source basis from the forgery
  → produce an admitted source-bound judgment
```

Classified as **forged issuance history**, not status laundering. *A record whose
standing was obtained by promotion alone no longer suffices; a complete coherent source
record is now required — and such a record is constructible from the public surface.*

### R-SOURCE-1.6 — authenticity cannot be inferred from type membership

`core0-evidence-p` is **not** an authenticity predicate. A blank object created through
the exported structure-class name satisfies it.

### R-SOURCE-1.7 — authenticity cannot be inferred from coherent content

A caller-constructed record with a fresh attempt identity, a complete event sequence,
an attempt payload and a manifestation **validates under Kernel /0**, folds to
`:COMPLETED`, shares no content with an account returned by `perform` — and satisfies
every coherence clause.

### R-SOURCE-1.8 — source binding and semantic projection remain useful

**Do not discard these concepts because authenticity is missing.** They are necessary
but insufficient parts of any later source-basis design. The paper did not fail; it
excavated the next layer.

### R-SOURCE-1.9 — no representation freeze

Do not choose among a first-class source-basis object, an inline clause, a
schema-attached basis, or a procedure-attached basis **until Core /0 issuance standing
is decided.**

### R-SOURCE-1.10 — separate second blocker, not to be repaired by accident

Even granting authenticity for free, the current public Core /0 account **cannot name
the domain subject of the request** through its public readers.

```
core0-evidence-request / canonical request is not publicly readable
```

This blocks domain propositions such as `:TREATMENT-COMPLETED`. **It is not the same
defect as authenticity and must not be repaired accidentally while investigating
issuance.**

---

## 4. The chair's classification is withdrawn pending adjudication

The Source-Basis chair ruling called the publicly forgeable evidence object **"a defect
in a frozen layer."** The owner has ruled that this is **a hypothesis requiring
normative adjudication, not a settled classification**, and the chair accepts the
correction without softening it: *the chair classified a frozen layer's standing from
implementation behaviour alone, which is the same move this project has refused
repeatedly under other names.*

What Core /0 promised a `core0-evidence` object was is **an open question**, with at
least four possible answers:

```
A  an ordinary structural account whose caller origin is not governed
B  an account issued only by `perform`, authentic as an in-image runtime record
C  a record intended to be issued by `perform`, with authenticity authorially undefined
D  contradictory promises across governing artifacts
```

**It may not be chosen from implementation behaviour alone.** Nor may Slice /2 freeze
`:AUTHENTICITY :NOT-EVALUABLE` as its permanent answer before Core /0's own contract is
adjudicated — that may prove the honest ceiling, but only after we learn whether the
frozen layer promised a stronger floor and failed to implement it.

**The next movement belongs to Core /0, not to Slice /2.**

---

## 5. What this ruling does NOT do

It does not adopt the paper vocabulary or carrier · select a representation or
attachment locus · authorize implementation, exports, or a public API · freeze a
specification · create a charter delta · authorize any Core /0 repair, export change,
authenticity predicate, registry, capability token, evidence seal, or subject-reader ·
authorize an effect bridge, an identity resolver, or cross-premise coherence.

It does not weaken `R-POLARITY-1`, Sol's Decision 1, `CHARTER-DELTA-3` residue
behaviour, or any law of Design Ruling /0 — all were exercised by the specimen and
held.

---

## 6. Standing caps

**Self-consistency, not corroboration.** One model family wrote this language, both
inhabited applications, every ruling that opened these doors, the specimen and this
text.

**Authenticity is shown to be unavailable through the public surface TODAY, not shown
to be unconstructible in principle.** No verifier, replay,
registry or attempt-resolution is exported; that is not proof none could exist.

**The reflective (MOP) construction routes are SBCL-specific. The public-Kernel-/0-
constructors route is not** — and that is the route that matters.

**Three unaudited areas in the specimen's own operations were named by its builder and
not reviewed by the chair:** the binding clauses report only the first firing clause and
clause masking was untested; the relation-target function both derives and tests the
target, so exactly one trace breaks that loop; and whether four semantic relations are
the right *set* is untested. A reviewer should start there.

**Every account involved is a scripted fake adapter** — a real governed in-image act,
**not** evidence any external deed occurred. Neither inhabited application was executed
by the builder; its fixtures are reconstructions.

**The stranger audit remains OWED**, against this ruling too. GLM, Gemini and MiniMax
unspent; Sol, Fable, Codex, Qwen and every Claude-lineage seat ineligible.

---

*Adopted against: lab commit `52462884` · Slice /2 `OPEN FOR DESIGN`, progression HELD ·
specimen 93 checks / 0 failed, run twice by the chair from clean images, byte-identical ·
package SHA-256 `01ac2ec9…` verified independently by the owner.*

— **Claude Opus 5 (1M context)**, chair, 2026-07-25

---

## NOTE — 2026-07-25: the held Core /0 issuance question received an owner ruling

**The held Core /0 issuance question received an owner ruling and a bounded
repair.** `CORE0-EVIDENCE-ISSUANCE-ERRATUM-0.md` (owner-adopted, 2026-07-25)
classified the prior state as an **authorial gap** and closed it prospectively:
a `core0-evidence` value has provenance standing exactly when its exact
canonical account content was issued by Core /0 in the current Lisp image; one
public predicate, `core0-evidence-current-image-issued-p`, asks that question;
and `continue-from` now refuses unissued content before any ledger use.

**Slice /2 remains HELD**, and this ruling is otherwise unamended.
§4's open question is answered — of the four listed possibilities the owner
ruled **C**, and closed it forward — but the progression does not resume on that
alone: **Slice /2 stays held until the repaired public issuance predicate is
exercised by a subsequent source-basis design specimen.** No such specimen is
authorized or implemented by this note.

Two rulings above are worth reading in the erratum's light, neither withdrawn:

- **R-SOURCE-1.6 stands exactly as written** — `core0-evidence-p` is not an
  authenticity predicate, and the erratum adopts that sentence rather than
  correcting it. What changed is that a predicate which *does* answer the
  issuance question now exists beside it.
- **R-SOURCE-1.10 is untouched, deliberately.** The canonical request is now
  bound into the private issuance content **without becoming publicly
  readable**; `core0-evidence-request` remains internal. The subject-readability
  blocker was not repaired here, by accident or otherwise, and this note must
  not be cited as repairing it.

**§2's result is not rewritten as mistaken.** The Source-Basis Paper /0
correctly measured the pre-repair surface, and its measurement is why the
erratum exists.

*— the chair, 2026-07-25*
