# de-pignore — DESIGN NOTE

*Written before implementation, as required. The live source governs; the previous
relay's reconnaissance was treated as hypothesis and is corrected below where it
was wrong.*

**Specimen, not layer.** This is an application-private reconnaissance-by-
construction. It is not Language Obligation /0 and earns no public standing.

---

## 0. Location decision

```
mneme/language-slice-2/de-pignore/APPLICATION.lisp
```

**Rationale, from the live convention.** Inhabited applications live at
`<layer-dir>/<de-name>/APPLICATION.lisp` — the only three in the tree are
`language-core-0/de-bibliotheca-peregrina/`, `language-core-0/de-codice-restaurando/`
and `language-form-0/de-forma-dormiente/`. The layer directory names the machinery
the application *inhabits*. `de-pignore` inhabits Slice /2 (its subject is a Slice /2
premise under a Slice /2 admission contract) and borrows Kernel /0's fold *shape*
without importing Kernel /0 records. `language-slice-2/` therefore communicates
exactly the three required things: application-private, dependent on public Slice /2
machinery, not a new governing layer.

*(Note: the two `de-*` applications under `language-core-0/` use Slice /2 heavily —
93 and 44 references — so "lives under the layer it inhabits" is a soft convention,
not a law. Recorded rather than assumed.)*

---

## 1. What exact Kernel /0 mechanism is being generalized?

**The unresolved-record + fold-derived openness pattern**, verified in source:

`kernel0/uncertain-effect.lisp:52` — the constructor's own docstring:

> *"Construct the structured §10.8 primitive; **no record-local resolved flag
> exists.**"*

Every slot is `:read-only t`; `(:copier nil)`. The record cannot be closed because it
has nothing to close.

`kernel0/folds.lisp:28–32` — the resolution law, stated by the code that implements it:

> *"a reconciliation resolves a recorded uncertain effect **only when** its resulting
> `:EFFECTS` axis is determinate and has value `:SETTLED` or `:COMPENSATED`, **and its
> unresolved residue is NIL**. A narrower `:BOUNDED` result remains unresolved.
> Supersession authorizes only its named superseding attempt and **never removes
> predecessor uncertainty**."*

`kernel0/folds.lisp:447–508` — `%check-retry-safety-internal`, the fold itself.
Openness is a **local variable** (`uncertainties`) built by walking events:
`:effect-bounded`/`:effect-indeterminate` **append**; `:attempt-reconciled` **removes
only if** `%reconciliation-resolves-effect-p`; `:attempt-superseded` appends
authorization and removes nothing.

`kernel0/folds.lisp:421–429` — `%reconciliation-resolves-effect-p`: determinate,
value in `{:settled,:compensated}`, **and** `unresolved-residue` null.

**What is being generalized is the *shape*, not the records.** `de-pignore` imports
no Kernel /0 record type. It reproduces: immutable open record with no status slot ·
receipt carrying prior→resulting commitment plus residue · openness derived by folding
an explicitly supplied event sequence.

---

## 2. What fact does the obligation remember that a Slice /2 receipt does not?

**This is the stop-condition question. The answer is not "nothing" — but it is
thinner than it first appears, and the thinness is the finding.**

A `slice2-receipt` (`slice2.lisp:1000`) already remembers a great deal: `identity`,
`schema-id`, `schema-version`, `conclusion`, `decision`, `admissions`, `ordinal`,
`origin-context`. Each `premise-admission` (`slice2.lisp:937`) carries `index`,
`premise-pattern`, `disposition`, `base-disposition`, **and `contract` BY VALUE**.

So the receipt *already* remembers: **at this act, premise N was `:missing` under
exactly this contract.** A program can re-read that contract from the old receipt and
test a later witness against it by hand. Much of what a naive "obligation" would carry
is therefore **already present**, and any design that merely re-wraps it is a
decorative duplicate.

Three facts are genuinely absent:

**(a) The election.** Slice /2 records an *absence*. Nothing anywhere records that a
program **undertook to close it**. `:missing` is what the machinery observed;
a pledge is what an author decided. These are different facts, and no existing object
holds the second. This is the load-bearing gap — everything else follows from it.

**(b) Fold-derived openness across intervening work.** A receipt is a leaf. Nothing in
Slice /2 folds a *sequence* of later events to answer *"is this still owed?"* Slice /2
answers per-act; it has no notion of a requirement persisting between acts.

**(c) A live addressability anchor distinct from the durable description.**
`derive/2` already enforces EQ-against-the-registered-schema and says why
(`slice2.lisp:1540–1545`): `judgment-schema-identity` is derived from **(name,
version) alone**, so two schemas with different premises share an identity and
comparing identities would be *vacuous*. Slice /2 applies that within one act. Nothing
carries the anchor **across** acts so that a re-registration between them makes a
retained requirement unaddressable.

**Verdict on the stop condition: DO NOT STOP.** (a) is a fact no existing object
holds. But the honest size of the finding is: *the obligation is mostly a receipt
reference plus an election plus a fold* — which is an argument for keeping it
application-local unless the specimen shows otherwise.

---

## 3. Why is a form hole not the same thing?

A `form-hole` (Form /0) is a **declared slot in a structure**, filled by
`instantiate-form` inside one construction. It has no elected opening act — declaring a
hole *is* the structure's shape, not a commitment; it does not survive unrelated
intervening work; and its filling is **substitution checked against a species**, not a
witness evaluated against a retained admissibility rule in a moving evidence
environment. Its completion is synchronous and structural: a form with an unfilled hole
simply is not instantiable.

The specimen tests this as probe B (§11) rather than assuming it. **No `lisp-plus-form0`
import.**

---

## 4. Why is a missing premise not automatically an obligation?

Because absence is a property of the *world*, and obligation is a property of an
*author's decision about the world*.

Every `derive/2` refusal with a `:missing` disposition would otherwise manufacture an
obligation, silently, forever — the machinery would be asserting that someone owes
something merely because something is not there. That is the inference the whole
apparatus refuses elsewhere: **a datum having a shape does not thereby acquire the
operations that shape names.**

`PLEDGE` therefore requires an explicit caller-supplied pledge-intent datum. `:missing`
is *evidence for why an author might pledge*; it is never the pledge. Negative control
1 exists to prove the machinery refuses to construct without it.

---

## 5. What event explicitly creates the obligation?

The `PLEDGE` call, and nothing else. It requires: the exact refused Slice /2 receipt,
the exact premise index, an explicit canonical pledge-intent datum, a canonical scope
description, the governing contract by value, and the live schema object as anchor.

No fourth "opening-act object" is created — the live APIs do not require one. The
pledge *is* the transition; the `OBLIGATION` is its immutable product.

---

## 6. What exact event counts as reconciliation?

A `TRY-RECONCILE-OBLIGATION` call that (i) finds the live schema still **EQ** to the
opening anchor, and (ii) finds the proposed witness admissible under the **retained**
contract, returns an `OBLIGATION-RECONCILIATION-RECEIPT` whose resulting commitment is
`:reconciled` and whose `unresolved-residue` is `NIL`.

Only that receipt licenses the fold to derive not-open — the exact analogue of
`%reconciliation-resolves-effect-p`. Anything else — non-EQ anchor, inadmissible
witness, wrong premise index, foreign receipt — yields an `OBLIGATION-REFUSAL`, and
**refusals never touch the fold**.

**On partial residue, declared in advance:** Slice /2 admission for a single premise is
structurally all-or-nothing — a support is admitted or it is not. The specimen will
therefore most likely be unable to exhibit a *meaningful* partial reconciliation, and
§8 of the direction forbids inventing one to fill the slot. The residue field is
carried because the shape has it and because a refusal must be able to say what remains
owed; if no honest partial case exists, the return will say so plainly rather than
manufacture one.

---

## 7. Why is reconciliation not derivation, truth, authority or standing?

Because it answers a strictly narrower question. The obligation receipt says:

> *this elected requirement was reconciled by this witness under this retained rule.*

The derivation receipt says:

> *this conclusion was granted by the existing derivation machinery.*

Reconciliation establishes only that **the thing an author said they owed has been
supplied and found admissible under the rule they retained**. It grants no claim, mints
no source basis or derivation basis, confers no capability or authority, and does not
make the conclusion true. A later `derive/2` must still be run and may still refuse for
entirely separate reasons.

The two lineages are exhibited side by side in the inhabited case, and negative control
11 offers the obligation receipt where Slice /2 expects a source basis or derivation
basis, to show existing machinery refuses it.

---

## Entrance findings

**Process Journal /0 — EXISTS and is ADOPTED. The reconnaissance was WRONG here.**
`architecture/process-journal-0/` holds a 63,656-byte spec, `PJ0-ADOPTION-RECORD.md`
(adopted `f44436f5`, spec `f98bf397…d04a80`), fixtures, and a mutation scorecard.

But it changes nothing for this specimen, for reasons read out of the source:

- its binding gate **R-PJ-3** relabels its own verification *"self-consistency
  certification"*;
- `PJ0-REFERENCE-TRANSCRIPT.md:53` — it *"does not claim to prove persistence through
  WSL virtualization or physical power loss"*;
- **no journal store is wired into Kernel /0's in-memory core.** `kernel0-selftest.lisp`
  excludes ~6 controls as awaiting PJ0 (torn-tail bytes, reconstruction, salvage/merge),
  and `folds.lisp:967` still refuses a merge format for the same reason.

⇒ The specimen is **in-image only** and makes **no cross-session, cross-image, replay
or durability claim**. The fold consumes an explicitly supplied ordered list; there is
no store.

*Stale declaration observed, not repaired (Kernel /0 must not be modified):*
`folds.lisp:34` says payload conventions *"await the **unwritten** process journal
specification."* PJ0 is now written and adopted, so that word is stale. Docketed only.

**Kernel /0 authorial gaps — six, recorded at `ARCHITECTURE-0-STATUS.md:61–72`. Two
govern this specimen's borrowed shape, and both *confirm* it:**

- **(5)** *"no canonical resolved-flag on uncertain-effect (resolution fold-derived per
  UNC-2 — **likely correct, confirm**)"* — governs `uncertain-effect` directly, and
  endorses precisely the no-status-slot design being generalized.
- **(6)** *"multiple-unresolved-effects occupancy stops with `unsupported-reconstruction`
  rather than a lossy summary (**conservative, confirm**)"* — governs unresolved-state
  folds; conservative, not contradictory.

Neither *materially prevents honest reuse*: both are "confirm the conservative choice,"
not "the semantics are undefined." **Kernel /0 is not modified.** The uncertainty is
carried into the return.

---

*Claude Opus 5 (1M context), 2026-07-27. Written before implementation.*

---
---

# ADDENDUM — REVIEW 1 (2026-07-27)

*The reasoning above is preserved unedited. This addendum records what direct
inspection found, what reproduced, and what changed. Nothing above is erased:
the original design note was right about the QUESTION and wrong about how much
of it the code actually enforced.*

Before-repair witness: **`REVIEW-1-EVIDENCE.txt`** (probes run against commit
`fbace907`, before any change).

## Which counterexamples reproduced

| | counterexample | result |
|---|---|---|
| R1 | stale ORIGINAL anchor after registry replacement | **REPRODUCED** |
| R2 | cross-anchor identity alias; A's receipt closes B | **REPRODUCED** |
| R3 | right kind, wrong subject | **REPRODUCED** |
| R4 | receipt/schema mismatch at PLEDGE | **REPRODUCED** |
| R5 | two opening acts, one content | **CONFIRMED** |
| R6 | non-canonical intent/scope | **REPRODUCED — worse than predicted** |
| R7 | reconciliation receipt has no identity | **CONFIRMED** |

**6 of 7 reproduced.** R6 was worse than the review anticipated: the boundary
leaked `PRINT-NOT-READABLE` on three ordinary values, **rejected CD/0 data — the
system's own canonical species** — and did not terminate on a circular cons.

## Which initial claims were too strong

Every failure was the same defect, and it is the one this whole arc keeps
naming: **a label standing in for the thing it names.**

| §1 claimed | §1 actually implemented |
|---|---|
| "admissible witness for this exact premise" | witness `mode` and `kind` matched two keywords |
| "a re-registered schema makes the obligation unaddressable" | the *caller's* wrapper was not `EQ` to the stored one |
| "distinct obligations have distinct identities" | content-equal obligations shared one identity |
| "canonical" rendering | a printer/reader round trip |
| "both lineages, neither impersonating the other" | the two objects were not `EQ` |

NC5 tested the caller's courtesy, not the law. NC14's label advertised a mutation
it never performed.

## The corrected identity model (§2)

`PLEDGE` now **requires** an explicit `:PLEDGE-ACT-ID`. Two notions are exposed
and are separately inspectable:

```
occurrence-identity  = (:pledge-act-id ACT  :content CONTENT-IDENTITY)
content-identity     = intent · refused-receipt · premise-index · subject ·
                       scope · COMPLETE contract snapshot · schema · procedure ·
                       procedure-version
```

Distinct act IDs yield **distinct occurrence identities** with **identical content
identities** — check 13 proves both halves at once. *Intention content is not
occurrence identity.*

**Replayed act ID:** explicitly **outside the specimen's enforceable boundary.**
With no registry there is nothing from which to detect a replay. Stated, not
silently decided by argument equality.

## The corrected live-addressability law (§3)

Liveness is no longer "the caller handed back the same object". It is now, at
both `PLEDGE` and reconciliation:

```
the obligation's BASE ANCHOR (the Slice /1 base object, not the wrapper)
  must still be EQ to RESOLVE-SCHEMA(name, version)
```

The anchor stored is the **Slice /1 base**, and the registry is re-consulted.
Handing back the original wrapper after re-registration now refuses
`:BASE-SCHEMA-NO-LONGER-LIVE` (check 12). Reasons added:
`:BASE-SCHEMA-NO-LONGER-LIVE`, `:CONTRACT-DRIFT`, `:PREMISE-ANATOMY-DRIFT`,
`:PREMISE-NOT-SATISFIED`.
*(Review 2 removed `:RECEIPT-SCHEMA-MISMATCH` from this list: it was a phantom —
no executable path emitted it. See the Review 2 section.)*

**Honest limitation, measured not assumed.** `SLICE2-RECEIPT-SCHEMA-ID/-VERSION`
report the **wrapper's** id and version (measured: `:SEAWORTHY/2` and `0`) while
the base carries `(:SEAWORTHY . 1)`, and Slice /2 exports no reader for a live
wrapper's own id/version. Concordance is therefore established by **anatomy** —
premise-index bounds, retained premise pattern, and the complete contract
snapshot. That is strictly weaker than an identifier comparison.
**PLEDGE does not prove which wrapper object was passed to the earlier
`DERIVE/2` call; the substrate does not record it.**

## The exact admission mechanism now used (§4)

The private mode/kind checker is **gone**. `%PROBE-ADMISSION` runs the existing
public **`DERIVE/2`** as a controlled probe carrying the proposed witness, then
inspects the **target premise's own `PREMISE-ADMISSION`** and reconciles only if
that premise reports **`:SATISFIED`**. The overall derivation may remain refused
because other premises are absent — that is not the fact under test.

Declared scope restriction, stated in the file header: one ground premise · one
asserted-witness contract · no receiver-dependent accessibility beyond the
probe's own receiver · no cross-premise binding dependency.

Both teeth are kept, because they test different laws: **wrong KIND** (check 5)
and **wrong SUBJECT** (check 6).

## The snapshot boundary (§6)

`PRIN1-TO-STRING` → `READ-FROM-STRING` is **removed**. Option B: a bounded
defensive copier over a strict private vocabulary — keyword, symbol, integer,
ratio, character, string, **CD/0 datum**, **Kernel /0 durable identity** — with
a depth limit and cycle detection. Everything else is a **typed** refusal.

Vocabulary corrected throughout: *canonical* is reserved for actual CD/0 values;
what this produces is a **defensive snapshot**. No reader path, no `READ-EVAL`,
no `PRINT-OBJECT` method can define identity here.

## The fold conjuncts (§7)

A receipt closes an obligation only when **all eight** hold: exact target
occurrence · exact target content · procedure identity · procedure version ·
previous `:OWED` · resulting `:RECONCILED` · disposition `:RECONCILED` · residue
`NIL`. Seven planted-receipt controls prove each conjunct bites (checks 20–26)
and one proves the conjunction closes (27). The receipt now has **its own
identity** (check 11).

## The history-completeness limitation (§9)

**Stated, demonstrated, and not solved.** `:ALREADY-RECONCILED` is enforceable
**only relative to the ordered history the caller supplies.** A caller who omits a
prior receipt can obtain another reconciliation receipt from the pure transition;
the specimen has no store from which to know otherwise. Check 30 demonstrates
exactly this. **No global exactly-once discharge is claimed.** No registry was
added to "solve" it.

## Result

**40 checks produced, 0 failed** (was 25). The recommendation is unchanged:

> **KEEP THE MECHANISM APPLICATION-LOCAL**

The credible inhabitant is still exactly one, and Review 1 did not enlarge it —
it made the single tenant honest.

*— Claude Opus 5 (1M context), 2026-07-27*

---
---

# ADDENDUM — REVIEW 2 (2026-07-27, finalization)

*The original note and the Review 1 addendum are preserved unedited. Before-repair
witness: **`REVIEW-2-EVIDENCE.txt`**.*

## What Review 2 found

Four defects, and they are **one defect in four costumes** — the same one the
Form /0 audit named: *a secondary representation standing in for the underlying
event.*

| | | |
|---|---|---|
| **D1** | read-only slots mistaken for **immutability** | REPRODUCED — all six aggregate readers aliased |
| **D2** | broad handlers mistaken for **refusal semantics** | REPRODUCED on **two** paths |
| **D3** | a text filter mistaken for a **transcript** | CAUSE FOUND — mine, in relay assembly |
| **D4** | a menu of accepted reasons mistaken for a **specification** | CONFIRMED PHANTOM |

### D1 — read-only slots alone were not deep immutability

`(:read-only t)` prevents slot **replacement**. It does not make a mutable value
reachable *through a reader* immutable. All six aggregate readers handed back the
stored cons.

Two things the probe surfaced that the review had not predicted:

- **Structure sharing between objects.** The receipt's target-occurrence and the
  obligation's occurrence-identity were **literally the same cons**. A caller
  could move *both sides* of the fold's `EQUAL` comparison at once, so the
  tampering was invisible to the fold. A tooth asking only *"does a valid receipt
  still close?"* cannot see this.
- **A reader could invalidate an obligation it does not own.** After the D1
  mutations, reconciliation refused `:CONTRACT-DRIFT` — because mutating the
  contract-snapshot **view** had corrupted the obligation's retained rule.

**Repair.** Every aggregate-valued application-facing reader returns a defensive
snapshot. `OBLIGATION-CONTRACT` and `OBLIGATION-BASE-ANCHOR` are **removed** — both
were call-free, and the second would have leaked the very object liveness is
tested against. Internal `%` accessors still hand exact objects to trusted
implementation code.

**The corrected tooth distinguishes three properties** that Review 1 conflated:
*(1)* no slot writer · *(2)* construction input defensively copied · *(3)*
aggregate reader results independently copied. Deep immutability is claimed only
because all three now hold, with eight reader-boundary teeth.

### D2 — unexpected conditions were laundered into semantic refusals

Three broad `(ERROR () NIL)` handlers converted arbitrary conditions into typed
protocol outcomes. Measured, in a disposable image with `UNWIND-PROTECT` restore:

```
derive/2       -> planted SIMPLE-ERROR  became  :PREMISE-NOT-SATISFIED
resolve-schema -> planted SIMPLE-ERROR  became  :BASE-SCHEMA-NO-LONGER-LIVE
```

An implementation failure was indistinguishable from a real protocol outcome.

**Repair.** Registry resolution catches **only** `LISP-PLUS-SLICE1:SCHEMA-NOT-FOUND`
— the documented absent-schema condition, read out of `resolve-schema`'s own
`signal-slice1` call. A new private `%CALL-DERIVE/2-PROBE` catches **only**
`SLICE2-DERIVATION-REFUSED` and `SLICE2-SCHEMA-ERROR`. Everything else escapes.
It is not a policy seam and accepts no caller-supplied procedure.

Four teeth: expected refusal inspected normally · expected registry absence yields
the typed refusal · a **planted unexpected condition escapes and is classified as
an implementation failure** · no broad catch-all remains in the transition path.

### D3 — the missing verdict `[28]`

**Not a source/run mismatch and not a stale transcript.** `SPECIMEN-RUN.txt` was
never tracked; it was generated during **relay assembly** by piping the raw run
through a grep whose exclusion list contained `caught` (to strip SBCL's
*"caught 1 STYLE-WARNING condition"*). Verdict 28's label reads *"…is **caught** as
`:CONTRACT-DRIFT`…"*. The filter deleted a **data** line because it resembled
**noise**, and the artifact's footer then disagreed with its own body.

**Repair.** `SPECIMEN-RUN.txt` is now captured **raw and unfiltered** and is
**tracked**, with `RUN-TRANSCRIPT-CHECK.txt` reconciling it mechanically — footer
vs rendered count, contiguity, verdict shape, failure agreement, exit-code
agreement, contract-drift presence — with **no expected N hard-coded**.

### D4 — the phantom refusal reason

`:RECEIPT-SCHEMA-MISMATCH` appeared in the R4 tooth's **allowed-result menu** and
in this note's prose. **No executable path emitted it.** A menu-accepting tooth
cannot notice that one of its options is unreachable.

**Repair.** Removed from source and prose. R4 now asserts the **exact** reason the
deterministic fixture produces — `:NO-SUCH-PREMISE`, since `BERTH-ASSIGNED` has one
premise so index 1 is out of bounds. `:PREMISE-ANATOMY-DRIFT` and
`:CONTRACT-DRIFT` are preserved: both have real paths. The honest anatomy-based
limitation stands unchanged — the substrate still cannot prove which wrapper
produced the earlier receipt, and no stronger test was invented to keep a name.

## Result

**52 checks produced, 0 failed** (Review 1: 40; original: 25). Recommendation
unchanged:

> **KEEP THE MECHANISM APPLICATION-LOCAL**

Review 2 did not enlarge the inhabitant, and the specimen's standing is **not**
inflated because it was hardened. Three rounds found three layers of the same
defect; what changed is that the specimen now measures behaviour where it used to
measure text.

*— Claude Opus 5 (1M context), 2026-07-27*
