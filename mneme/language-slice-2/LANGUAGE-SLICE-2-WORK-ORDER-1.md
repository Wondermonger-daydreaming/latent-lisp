# LANGUAGE SLICE /2 — WORK ORDER /1

## Compositional Admission — Candidate /1

*Owner-issued 2026-07-25 (evening). Received and executed by Claude Opus 5
(1M context). Continues directly from Candidate /0.*

```
status:                    owner-issued work order
implementation-authorized: yes
specification-frozen:      no
adoption record:           NOT to be written in this movement
stranger audit:            OWED — and explicitly NOT a progression gate here
```

**The implementation is the design specimen.** No further design ruling,
comparative review, paper specimen, reproduction packet, authority matrix or
fresh-chair lane precedes construction.

---

## 1. The gap being closed

`[IX-10]`, recorded in `de-bibliotheca-peregrina` and carried forward as an open
item in `LANGUAGE-SLICE-2-ADOPTION-0.md` §5.3:

> the receiving receipt holds NO witness object and NO `:ATTEMPT` identity — the
> crossing's identity is gone by the time the claim chains

Candidate /0 closed the *upstream* frontier: an effect account can now reach a
premise through a governed source basis. It left the *downstream* one open — a
claim granted by `derive/2` travelled onward as an ordinary Slice /1 claim,
indistinguishable from one that had never faced an admission contract.

**Objective.** A claim granted by `derive/2` must be able to travel with the
exact Slice /2 admission record that governed its grant, as a distinct support
species a later premise may explicitly accept. A naked Slice /1 claim, an
ordinarily raised claim, a caller-fabricated value, a copied token, or a merely
matching proposition must not impersonate that species.

Slice /3 is **not** to be opened unless an executed contradiction shows
Candidate /1 cannot preserve Slice /2's narrowing architecture.

## 2. The new species — `derivation-basis`

Not a claim, witness, refutation, source basis, judgment standing, or second
promotion. It binds: the exact granted claim · the exact Slice /2 receipt from
the same act · the claim proposition · the receipt's schema identity and version
· the receipt's origin context · one fixed truth ceiling · image-local
establishment standing.

**Internal constructor only** — no public constructor may pair an arbitrary claim
with an arbitrary receipt. Directly inspectable through public readers; **no
identifier-to-object resolver may be required**. Existing copy discipline
preserved: mutable cons/string leaves defensively copied, read-only structure
leaves may remain the exact objects under the already-declared undetached-object
ceiling.

**Identity:** prefer **one** durable identity — reuse the underlying claim's,
mirroring the source-basis/carrier arrangement — unless an executed counterexample
shows this violates an existing accessibility invariant.

## 3. Establishment

Minted and registered **only after `derive/2` reaches a genuine Slice /2 grant**,
into a private current-image `EQ` registry parallel to the source-basis one.

`derivation-basis-established-in-current-image-p` **answers false, never
signals**, for: a non-basis value · a basis-shaped value built through the host
object model · a structural reconstruction or copy · a basis not minted by the
successful `derive/2` path · a basis whose internal claim/receipt conjunction is
inconsistent.

**A true answer establishes at most:** *this exact derivation-basis object was
minted in this Lisp image for this exact claim and this exact granted Slice /2
receipt.* Not domain truth, external occurrence, adapter or provider honesty,
cross-image standing, durability, serialization authenticity, or cryptographic
authenticity.

## 4. `derive/2` return shape

On grant: `(values GRANTED-CLAIM SLICE2-RECEIPT DERIVATION-BASIS)`. The first two
are **exactly** the existing values; the third is **additive**, and callers taking
one or two values behave unchanged.

On refusal: signal the existing typed `slice2-derivation-refused`, retain the
refusal receipt exactly as today, **mint no basis, register nothing.**

**No second claim is minted.** The granted claim remains the Slice /1 grant; the
basis is a distinct support object carrying the admission account.

## 5. Contract versioning

Via the existing `contract-version` field — Candidate /0 contracts are not
silently changed.

- **Version 0** — exactly the existing three clause families; **refuses**
  `(:derivation-basis)`; all Candidate /0 behaviour preserved.
- **Version 1** — all Candidate /0 families plus exactly one fourth,
  `(:derivation-basis)`, with **no caller-selectable options**, at the fixed
  ceiling `:PRIOR-EXPLICIT-ADMISSION-JUDGMENT`.
- **Unknown versions refuse at construction.**

**The ceiling, exactly:** *this exact claim was granted by `derive/2` under
explicit per-premise admission contracts whose resulting admission record is
retained in the attached receipt.*

It does **not** mean every premise was source-bound · every premise was
externally verified · an admitted asserted witness became source evidence · the
conclusion inherits `:CURRENT-IMAGE-ISSUED-ACCOUNT-REPORT` · the conclusion is
externally true · an effect occurred or settled.

**An effect-sensitive premise requiring an actual Core /0 account report must
still require a `source-basis`. A `derivation-basis` must never impersonate
one.**

## 6. Classification and projection

Recognized positive species become: **source basis · derivation basis · witness ·
claim**, refutations continuing on their existing path. Caller support indices and
route identity preserved.

For a derivation basis: project its **exact underlying claim** into Slice /1's
base `derive`; retain a carrier-claim → basis association; let **Slice /1** keep
deciding proposition matching, positive judgment, claim identity, receiver
accessibility, refutation, binding and ambiguity; let **Slice /2** decide only
whether the premise's explicit contract accepts the derivation-basis route.

**The projected carrier must not become a naked verified claim merely because
Slice /1 saw it as one.** The admission record must distinguish *offered naked*
from *offered through an established derivation basis* **even when both routes
involve the same claim object** — and if the caller supplies both, the routes are
**not** deduplicated in a way that erases the distinction. The receipt says which
route was admitted and which was not.

**Admitted only when all ten hold:** contract is version 1 and explicitly contains
`(:derivation-basis)` · basis established in this image · its underlying claim is
the exact claim projected into Slice /1 · Slice /1 discharged that claim under
CATENA · proposition matches through the existing normalized machinery · Slice /1's
accessibility, refutation, binding and ambiguity answers permit positive support ·
basis reachable under the applicable receiver context · receipt decision is
`:GRANTED` · receipt conclusion and claim proposition agree · fixed truth ceiling
intact.

Admission remains a **narrowing conjunct**: it may refuse positive support; it may
not readmit a mismatch, override inaccessibility, suppress refutation, repair
ambiguity, substitute another claim, or infer policy from procedure IDs, metadata,
package names, identity shape or copied payloads.

## 7. Receipts and explanation

Public readers at least: `derivation-basis-p` ·
`derivation-basis-established-in-current-image-p` · `-identity` · `-version` ·
`-claim` · `-receipt` · `-proposition` · `-schema-id` · `-schema-version` ·
`-origin-context` · `-truth-ceiling`; plus
`premise-admission-derivation-bases` and `slice2-receipt-derivation-bases-used`.

The receipt **retains the admitted basis directly** — no global resolver may be
needed to discover the prior claim, prior receipt, applied contracts, source
bases, or actual per-premise truth ceilings.

`why` / `render-slice2-why` gain separate cases for: admitted derivation basis ·
recognized-but-not-admitted · basis-shaped value without a usable carrier · basis
not established in this image. The renderer says *"prior explicit admission
judgment"* or equivalent, and **never** prints *proved*, *effect occurred*,
*externally verified* or *settled* merely because a basis was admitted.

## 8. Inhabited application

One new movement in `de-bibliotheca-peregrina`, using an **already-earned**
Slice /2 grant and capturing its third value. A downstream premise whose
version-1 contract accepts **only** `(:derivation-basis)` demonstrates, in
executable code: the naked granted claim is recognized but `:NOT-ADMITTED` · an
ordinarily raised claim with the same proposition is `:NOT-ADMITTED` · the
established basis discharges the premise · the downstream receipt reaches the
exact prior Slice /2 receipt · the rendered explanation preserves the modest
ceiling · **no courier script, fake-adapter outcome, Core /0 event or source
relation is altered to make the result pass.**

The downstream conclusion is an **explicit application judgment**. A
derivation basis never establishes settlement, delivery, treatment, exhibition
safety or any domain conclusion automatically.

Plus one **two-hop composition test** beyond the application movement:

```
source basis → Slice /2 claim + derivation basis A
             → downstream claim + derivation basis B
             → one further premise accepting derivation basis B
```

This demonstrates **finite composition**, not a generic proof-graph framework.

## 9. Negative controls — twenty, asserted not merely observed

Contract /0 refuses the clause · contract /1 accepts it · unknown version refuses
· grant returns a third value · refusal mints nothing · naked claim fails ·
ordinarily raised matching claim fails · host-fabricated basis-shaped value fails
· structural copy fails establishment · claim/receipt mismatch fails · mismatched
proposition fails through Slice /1 · inaccessible support stays inaccessible ·
refutation retains precedence · naked-vs-basis routes stay distinct · the basis
ceiling does not become a source-basis ceiling · a multi-hop chain composes · the
prior receipt is reachable without a resolver · a planted fault removing the
establishment conjunct is caught · a planted fault accepting the carrier as a
naked claim is caught · all previous floors stay green.

**Do not measure only "did it fail?"** Assert the relevant typed condition,
disposition, receipt field or rendered reason.

## 10. Non-goals — not to be "fixed" here

Slice /1 `derive` · Slice /1 CATENA semantics · Slice /0 · Kernel /0 · Core /0
issuance semantics or exports · the Core /0 request oracle · the source-basis `EQ`
registry · the seven other `R-ISSUANCE-0.12` structure types · `%iss-refuse` or
adapter-name policy · cross-image or serialized standing · cryptographic
authenticity · external provider honesty · the stranger-audit docket.

No arbitrary policy closures, schema-name allowlists, procedure-ID allowlists,
wildcards, generic `:ESTABLISHES` relations, or caller-selectable truth ceilings.

## 11. Execution discipline

**One hand implements this movement. No helper agents.** An isolated worktree or
clone, so the mirror cannot publish unfinished working-tree content.

Language floor **once** before modification; focused Slice /2 tests during
construction; the complete floor **once** after the focused suite is green. A
repeat full run only when a concrete failure requires diagnosis — **no duplicate
ceremonial reproductions.** The floor's count is an expectation to update
deliberately, **not an immutable sacred number.**

Stop only for an exact semantic contradiction, a changed controlling authority,
or a reproducible regression in an existing language law. Otherwise build.

---

*Received against lab `60c1d4d2` · baseline floor 10 floors / 568 checks / 0
failed · SBCL 2.4.6 operation-checked through the wrapper.*

*Standing caps unchanged and carried: self-consistency, not corroboration — one
model family wrote the language, the applications, the rulings and this movement.
Every account is a labelled scripted fake adapter, never evidence that an
external deed occurred. The stranger audit remains OWED, against this work order
too.*

— **Claude Opus 5 (1M context)**, 2026-07-25
