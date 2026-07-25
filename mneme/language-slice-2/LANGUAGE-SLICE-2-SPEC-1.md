# LANGUAGE SLICE /2 — SPECIFICATION /1

## Compositional Admission (Candidate /1)

*Built under `LANGUAGE-SLICE-2-WORK-ORDER-1.md`. Extends `LANGUAGE-SLICE-2-SPEC-0.md`,
which is unamended and still governs everything Candidate /0 defined.*

```
status:                 candidate implementation
specification-frozen:   no
adoption record:        NOT written in this movement, by instruction
stranger audit:         OWED, against this specification too
```

---

## 1. What this adds, in one paragraph

A claim granted by `derive/2` can now travel **with the exact admission record
that governed its grant**, as a distinct support species — a **derivation
basis** — which a later premise may explicitly require. A naked Slice /1 claim,
an ordinarily raised claim, a caller-built value of the same shape, a structural
copy, or a merely matching proposition **cannot impersonate it**.

Nothing else changes. `derive` is Slice /1's and is byte-untouched. Core /0 is
byte-untouched, exports included. Slice /1's exports are unchanged at 74.

## 2. The gap this closes

`[IX-10]`, in `de-bibliotheca-peregrina`:

> the receiving receipt holds NO witness object and NO `:ATTEMPT` identity — the
> crossing's identity is gone by the time the claim chains

Candidate /0 answered this **upstream**: an effect account reaches a premise
through a governed source basis. Downstream it was unchanged — a claim granted
under explicit per-premise contracts left the receipt as an ordinary claim, and
a later premise could not tell it from one raised over an assertion, **because
by the time it arrived there was nothing left to tell it by.**

## 3. `derivation-basis`

A governed record binding a granted claim to the receipt that granted it. **Not**
a claim, witness, refutation, source basis, judgment standing, or second
promotion.

| field | reader |
|---|---|
| identity — **the underlying claim's**, not a second name | `derivation-basis-identity` |
| version | `derivation-basis-version` |
| species — `:slice2-derivation` | `derivation-basis-species` |
| the **exact** granted claim | `derivation-basis-claim` |
| the **exact** Slice /2 receipt from the same act | `derivation-basis-receipt` |
| the claim proposition | `derivation-basis-proposition` |
| the receipt's schema id / version | `derivation-basis-schema-id` / `-schema-version` |
| the receipt's origin context | `derivation-basis-origin-context` |
| one fixed truth ceiling | `derivation-basis-truth-ceiling` |

**The constructor is internal, and that is the entire mechanism.** No public
operation pairs an arbitrary claim with an arbitrary receipt, because such an
operation would let a caller assemble a *coherent* basis for a grant that never
happened. This is `R-SOURCE-1.7` applied one layer up, before it could be
repeated: **coherence is a property of the object; the only defence is that this
image minted it.**

**One durable identity, not two.** The basis takes the claim's identity,
mirroring the source-basis/carrier arrangement. A second name for one support
act is a second thing to keep in agreement, and the accessibility path already
reads claim identities — so an application's receiver context gains a species in
its `cond` and **no new accessibility regime**.

## 4. Establishment

Minted and registered **only** by the successful `derive/2` path, into a private
image-local `EQ` registry parallel to the source-basis one.

`derivation-basis-established-in-current-image-p` **answers false — never
signals** — for a non-basis value · a basis-shaped value built through the host
object model · a structural reconstruction or copy · a basis not minted by the
successful path · **a basis whose internal claim/receipt conjunction is
inconsistent.**

That last one is checked **separately from registry membership**, and both are
required. A basis minted by `derive/2` satisfies it by construction — so the
check exists for exactly the case the work order names: **the object answers for
itself as well, and the registry is not the only authority.** `C1v` registers an
inconsistent basis by hand and shows the predicate still says false.

**Exact ceiling.** A true answer establishes *at most* that **this exact
derivation-basis object was minted in this Lisp image for this exact claim and
this exact granted Slice /2 receipt.** Not domain truth, external-world
occurrence, adapter honesty, provider honesty, cross-image standing, durability,
serialization authenticity, or cryptographic authenticity.

## 5. `derive/2` return shape

```lisp
(values GRANTED-CLAIM SLICE2-RECEIPT DERIVATION-BASIS)   ; on a grant
```

**The third value is additive.** The first two are exactly Candidate /0's, so a
caller binding one or two values behaves unchanged — demonstrated rather than
promised: the selftest's `run/2` and the library's original call sites still
bind two and are untouched.

On refusal: the existing typed `slice2-derivation-refused`, the refusal receipt
exactly as before, **no basis minted, nothing registered** (`C1j` asserts the
registry count is unchanged).

**No second claim is minted.** The granted claim remains the Slice /1 grant.

## 6. Contract versioning

| | version 0 | version 1 |
|---|---|---|
| `(:verified-judged-claim)` | ✓ | ✓ |
| `(:source-basis :relations …)` | ✓ | ✓ |
| `(:asserted-witness …)` | ✓ | ✓ |
| `(:derivation-basis)` | **refuses at construction** | ✓ |

An unknown version **refuses at construction** — a contract whose meaning this
image cannot compute must not exist, rather than be discovered unevaluable at a
premise.

`(:derivation-basis)` has **no caller-selectable options**. There is nothing to
configure, because the only question it asks is whether this premise accepts the
route.

### The ceiling

```
:PRIOR-EXPLICIT-ADMISSION-JUDGMENT
```

> This exact claim was granted by `derive/2` under explicit per-premise
> admission contracts whose resulting admission record is retained in the
> attached receipt.

It does **not** mean: that every premise was source-bound · that every premise
was externally verified · that an admitted asserted witness became source
evidence · that the conclusion inherits `:CURRENT-IMAGE-ISSUED-ACCOUNT-REPORT` ·
that the conclusion is externally true · that an effect occurred or settled.

**An effect-sensitive premise requiring an actual Core /0 account report must
still require a source basis.** The two ceilings are distinct keywords precisely
so that no reader can confuse a prior judgment with an account report (`C1d`).

## 7. Classification, projection, and the two roads

Recognized positive species: **source basis · derivation basis · witness ·
claim**; refutations on their existing path. Disjoint structure classes with no
`:INCLUDE`, so the `cond`'s order is not a silent precedence rule. A
basis-shaped value whose claim slot holds no claim is **residue at the caller's
own index**, reason `:derivation-basis-without-carrier`.

A derivation basis projects **its exact claim object** into Slice /1's base
`derive` — not a copy, because the conjunct that matters compares by `EQ`
against what Slice /1 judged.

**The projection is deduplicated; the admission record is not.** The asymmetry is
deliberate and is the subtlest thing in this specification:

- handing Slice /1 **one claim object twice** would let it count twice and could
  manufacture an ambiguity the caller never created;
- collapsing the two **roads** would erase the distinction the whole species
  exists to draw.

So when a caller supplies both the naked claim and its basis, **both roads are
evaluated on their own terms and both verdicts are recorded** — in one
derivation, one refused and one admitted (`C1x`).

### The ten conjuncts

Slice /2 owns four; six arrive already decided and are read, never recomputed.

```
 1  contract is version 1 AND explicitly names (:DERIVATION-BASIS)   slice /2
 2  the basis is established in THIS image                            slice /2
 3  its underlying claim is the EXACT claim projected into slice /1   slice /2
 7  reachable under the applicable receiver context                   slice /2

 4  slice /1 discharged that claim under CATENA                       slice /1
 5  the proposition matched through the normalized machinery          slice /1
 6  accessibility, refutation, binding and ambiguity permit it        slice /1

 8  the receipt decision is :GRANTED                    inside conjunct 2
 9  receipt conclusion and claim proposition agree      inside conjunct 2
10  the fixed truth ceiling is intact                   inside conjunct 2
```

Conjunct 1 checks the version explicitly even though a version-0 contract
**cannot** hold the clause. The redundancy is deliberate: **a law enforced only
as a side effect of another mechanism is one silent refactor from being gone.**

Admission remains a **narrowing conjunct**. It may refuse positive support; it
may not readmit a mismatch, override inaccessibility, suppress refutation, repair
ambiguity, substitute another claim, or infer policy from procedure IDs,
metadata, package names, identity shape or copied payloads.

## 8. Receipts and explanation

`premise-admission-derivation-bases` · `slice2-receipt-derivation-bases-used` —
the **basis objects themselves**, so a reader reaches the prior claim, the prior
receipt, the applied contracts, the prior source bases and the real per-premise
ceilings **without a resolver.** `[XI-4]` walks closure standing → prior receipt
→ source basis → the Core /0 attempt, by object.

`render-slice2-why` gains four cases: admitted basis · a **recognized** basis this
contract does not accept · a basis **this image did not establish** (a different
fact, never collapsed with the previous one) · a basis-shaped value with no
usable carrier.

It says *"prior explicit admission judgment"*. It never prints *proved*, *effect
occurred*, *externally verified* or *settled*.

**A note on how that is enforced.** The check is a **blunt substring search**,
which cannot tell an assertion from a denial — so when the renderer's own
*disclaimer* tripped it during construction, the **disclaimer was reworded and
the check was left blunt.** A test that cannot be gamed is worth more than one
clever enough to parse around itself.

## 9. What Candidate /1 does not do

No change to: Slice /1 `derive` or CATENA · Slice /0 · Kernel /0 · Core /0
semantics or exports · the Core /0 request oracle · the source-basis registry ·
the `R-ISSUANCE-0.12` structure types · `%iss-refuse` or adapter-name policy ·
cross-image or serialized standing · cryptographic authenticity.

No arbitrary policy closures, schema-name allowlists, procedure-ID allowlists,
wildcards, generic `:ESTABLISHES` relations, or caller-selectable truth ceilings.

**Slice /3 was not opened.** Nothing executed demonstrated that Candidate /1
cannot preserve Slice /2's narrowing architecture.

---

*Standing caps, unchanged and carried: self-consistency, not corroboration — one
model family wrote the language, the applications and these checks. Every account
is a labelled scripted fake adapter, a real governed in-image act, **never**
evidence that any external deed occurred; a lying adapter produces identical
readers throughout. The stranger audit remains OWED.*

— **Claude Opus 5 (1M context)**, 2026-07-25
