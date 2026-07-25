# LANGUAGE SLICE /2 — SPECIFICATION, CANDIDATE /0

## Source-bound admission

*Built under `LANGUAGE-SLICE-2-WORK-ORDER-0.md` (owner-issued, 2026-07-25).
Where this document and the work order differ, the work order controls.*

```
status:                    candidate implementation
specification-frozen:      no          (load-bearing — R-ADMISSION-0.9)
representation:            D2-0.1, first-class contract value
attachment-locus:          D2-0.2, per premise
public-api:                candidate /0 surface only
```

---

## 1. What this builds

> A premise may explicitly require a source-bound basis. Such a basis can be
> created only from current-image-issued Core /0 evidence bound to the exact
> request and interpreted through a mechanically defined source relation. Raw
> witnesses and ordinarily raised claims cannot impersonate it.

Four design movements preceded this one and each ended in a negative result.
Their laws are carried here as **code**, not as prose to be remembered:

| law | where it lives now |
|---|---|
| `R-ADMISSION-0.1` species is not provenance | admission consults the established-basis registry, never the species alone |
| `R-ADMISSION-0.2` standing is not origin | a `:VERIFIED` claim is admitted only where a contract names `:VERIFIED-JUDGED-CLAIM` |
| `R-ADMISSION-0.5` procedure allowlisting does not cure laundering | no relation, procedure identity or witness attribute is an admission credential |
| `R-ADMISSION-0.8` binding is not implication | the three relations produce propositions **about accounts** |
| `R-SOURCE-1.1` coherence is not authenticity | issuance is asked of Core /0, never inferred from content |
| `R-SOURCE-1.6` authenticity is not type membership | a value of the source-basis *shape* is not an established basis |
| `R-SOURCE-1.10` the request stays unreadable | the new predicate **confirms** a request; it does not return one |
| `R-ISSUANCE-0.10` the issuance ceiling | carried in every basis as a field, not only in prose |

---

## 2. The four values

### 2.1 `support-admission-contract` — data, not a closure

A canonical value carrying: contract identity · contract version · accepted
support clauses · exact proposition relation · receiver-accessibility
requirement · retention requirements · truth ceilings.

It is **data** because a receipt that retains a closure retains something no
downstream reader can inspect: "the contract that applied" would become a
promise instead of a record. Every slot is read-only; the clause list is
defensively copied on ingress and on egress.

**Exactly three clause families exist in Candidate /0.**

```lisp
(:verified-judged-claim)

(:source-basis :relations (:core0-account-issued-for-request
                           :core0-account-reports-acknowledgment
                           :core0-account-reports-outcome))

(:asserted-witness :mode :direct :kind :condition-survey :truth-ceiling :asserted)
```

A fourth family is a **language change**, not a configuration change, and is
refused **at construction** with a typed Slice /2 condition. So is an unknown
option, a missing required option, a relation outside the vocabulary, an empty
relation list, and a repeated clause species. There are no arbitrary predicate
functions anywhere in the surface.

**Truth ceilings are not caller-selectable except where the caller is
acknowledging a limit.** Two of the three are fixed by the mechanism —

```
:source-basis          → :current-image-issued-account-report
:verified-judged-claim → :prior-governed-judgment
```

— because a caller who could *declare* a stronger ceiling than the mechanism
earns is doing exactly what `R-ADMISSION-0.2` and `R-SOURCE-1.2` exist to stop.
The asserted-witness ceiling **is** written by the caller and **must** be
written as `:ASSERTED`, so writing it is an acknowledgement rather than a
choice (`D2-0.10`).

`:MODE :DERIVATION` is refused in an asserted-witness clause. That is the mode
Slice /1 grants wear and the mode a source basis's carrier wears; a clause
admitting it would let a bare witness stand where a governed basis is required.

### 2.2 `slice2-schema` — per-premise attachment

Contracts attach to **premise positions**, zero-based against the base Slice /1
schema's own premise order. Every position gets exactly one contract: a
missing index, a duplicate index and an index the base schema does not have
each refuse with their own typed condition.

There is **no implicit default**, no inheritance by predicate name, procedure
ID, package or convention, no hidden registry, no procedure-ID heuristic, and
no inference from witness mode or kind. The schema names the contract, or the
schema does not exist.

Contracts are **snapshot** at registration — a fresh contract with deep-copied
clause data — so caller mutation after registration cannot revise the
registered schema, and the snapshots stay fully inspectable.

`de-codice-restaurando` is the reason this locus was chosen. Its post-treatment
standing has one premise that must demand source-bound treatment evidence and a
sibling that legitimately accepts a conservator's direct condition survey. A
schema-wide policy would have to be wrong about one of them.

### 2.3 `source-basis` — a distinct support species

Not a witness, not a claim, not a judgment standing, not a copied identifier,
not a copied payload, not a procedure-allowlist result. A governed record
binding an actual current-image-issued Core /0 account · the exact canonical
request it belongs to · one mechanically defined source relation · one
mechanically derived proposition · one explicit truth ceiling.

`establish-core0-source-basis` performs, in this order:

```
1. Core /0 current-image issued-FOR-REQUEST check
2. relation-specific account-field check
3. generic proposition construction
4. truth-ceiling assignment
5. defensive source snapshot
6. durable source-basis identity creation
7. registration in this image's established-basis registry
```

**The carrier, stated plainly because it is the one place a reader could be
misled.** A source basis holds an internal Slice /0 witness whose `:FOR` is the
produced proposition. That witness is a **transport** — it is how the derived
proposition reaches Slice /1's matcher, which Slice /2 does not reimplement. It
is **not the authority.** Admission is decided by the established-basis
registry, never by the carrier's mode, kind, source, procedure or content. A
caller who mints a witness with identical attributes gets a witness; a caller
who obtains a genuine carrier and offers it bare gets an unadmitted witness at
a source-bound premise. The carrier is exposed by no public reader.

This honours `R-ADMISSION-0.5` rather than evading it: the promotion procedure
is deliberately **not** the discriminator, because a promotion procedure is
publicly constructible and would separate nothing.

**The registry is an `EQ` table, and that is a deliberate difference from Core
/0's exact-content registry.** Core /0 had to let a defensive *copy* of an
account survive, because copying an account is a lawful thing for a client to
do. A source basis is a token this image hands out and takes back, so a
structural reconstruction of one is **not admitted**, and Slice /2 says so
rather than pretending copies are safe. The registry has no public reader and
no id-to-object lookup; the only question it answers is *"is this object one I
established?"*, asked about an object the caller already holds.

### 2.4 The relation vocabulary — exactly three

```
:CORE0-ACCOUNT-ISSUED-FOR-REQUEST
:CORE0-ACCOUNT-REPORTS-ACKNOWLEDGMENT
:CORE0-ACCOUNT-REPORTS-OUTCOME
```

Each produces a generic proposition **about the account**, built through the
public Slice /1 `proposition` constructor so it is in normal form with roles
sorted and can actually match a premise pattern:

```lisp
(:predicate :core0-account-issued-for-request
 (:attempt "attempt:core0/attempt/4")
 (:request (:quoted-datum (:predicate :deliver (:payload "…")))))

(:predicate :core0-account-reports-acknowledgment
 (:acknowledgment :acknowledged) (:attempt "…") (:request (:quoted-datum …)))

(:predicate :core0-account-reports-outcome
 (:attempt "…") (:outcome :completed) (:request (:quoted-datum …)))
```

The request rides as `(:quoted-datum …)` because it is **literal data** whose
shape must never be read as a variable. The attempt rides as its identity key
string rather than as the identity object, because `EQUAL` on two structurally
equal identity structures is `EQ` and a premise pattern written literally would
never match.

None produces `:TREATMENT-COMPLETED`, `:SAFE-TO-EXHIBIT`, `:DISPATCH-DELIVERED`
or `:LOAN-SETTLED`. **There is no relation named merely `:ESTABLISHES`** and no
wildcard. Applications derive domain conclusions separately, through explicit
schemas — both migrated applications do exactly that, and both show the refusal
firing when the account is offered directly at a domain premise.

**Where each field check comes from.** Every one is a live public reader:

| relation | reader |
|---|---|
| issued-for-request | `core0-evidence-current-image-issued-for-request-p` (the conjunction itself) |
| reports-acknowledgment | a `:REQUEST-ACKNOWLEDGED` event for the account's own attempt, off `core0-evidence-events` |
| reports-outcome | `kernel0:fold-attempt-outcome` over the account's own events and attempt, read through `attempt-outcome-standing-terminal-class` |

The acknowledgment reader deserves a note, because a reader will want to
over-read it. **A `:REQUEST-ACKNOWLEDGED` event is present in both a clean
commit and an interrupted, ledger-withholding crossing** — measured, not
assumed. "Acknowledged" means the provider took the request and nothing about
whether the effect settled. That is exactly why acknowledgment and outcome are
two relations rather than one, and `de-codice-restaurando` `[X-3]` exercises an
account that reports acknowledgment **and** `:FAILED` at the same time.

---

## 3. Core /0 — exactly one new public predicate

```lisp
(core0-evidence-current-image-issued-for-request-p evidence canonical-request)
```

True only when the evidence's current exact canonical content is registered as
Core /0-issued in the current image **and** the canonical request bound inside
that content equals the supplied one. Comparison is `structured-proposition=`
on normal forms.

It **confirms**; it does not read. `core0-evidence-request` remains internal
and unexported, so `R-SOURCE-1.10` and `R-ISSUANCE-0.11` stand and were not
repaired by accident. It does not mutate the registry, consults no ledger, and
answers false — never signals — for a non-evidence value, unencodable content,
or a malformed or non-ground request.

**Exports go 61 → 62.** No other Core /0 operation was added, changed or
removed.

---

## 4. `derive/2`

`derive` remains Slice /1's and does not change, silently or otherwise.
`derive/2` calls it; it does not replace, shadow or reimplement it.

**Fixed evaluation order**, and where each step happens:

```
 1 classify recognized support species          Slice /2
 2 preserve unsupported residue                 Slice /2 (at the CALLER's indices)
 3 proposition match / mismatch                 Slice /1
 4 receiver-relative accessibility              Slice /1 (+ the contract's own requirement)
 5 direction / refutation semantics             Slice /1
 6 apply the explicit premise admission contract Slice /2
 7 judged-claim standing and identity rules     Slice /1 (CATENA), consulted
 8 source-basis relation requirements           Slice /2
 9 ordinary binding and ambiguity logic         Slice /1
10 record the exact contract and basis          the Slice /2 receipt
```

**Admission is a narrowing conjunct, and the narrowing is structural rather
than promised.** Steps 3, 4, 5, 7 and 9 are Slice /1's answers, read and never
rewritten, so `derive/2` grants only where `derive` already granted. It may
refuse positive support. It may **not** readmit a mismatch, override
inaccessibility, suppress refutation, convert unsupported evidence into an
admitted species, replace CATENA's claim-identity rules, or select policy
through metadata.

**Dispositions** are Slice /1's six plus exactly one new term:

```
:satisfied  :refuted  :inaccessible  :mismatched  :ambiguous  :missing
:not-admitted   ← the premise had recognized, matching, accessible support
                  that its contract does not accept
```

`:NOT-ADMITTED` is a seventh term rather than a reuse of `:MISSING` because
*"nothing was offered"* and *"what was offered is not the kind this premise
takes"* are different facts. Collapsing them would reproduce the misdirection
defect Slice /1 already paid to repair.

**A missing contract is a typed refusal with no permissive fallback.** Slice
/1's open admission behaviour is not inherited silently; it cannot be inherited
at all, because `make-slice2-schema` refuses to build a schema with an
uncontracted premise and `derive/2` re-checks against the schema in hand.

`derive/2` also refuses when the schema registered under the base schema's key
is not the very object the contracts were attached to. The check is `EQ`, and
deliberately so: `judgment-schema-identity` is derived from `(name, version)`
alone — measured, not assumed — so comparing identities there would be vacuous.

### 4.1 A design decision stated as a cost, not hidden

**Every recognized support reaches the base derivation, and the narrowing
happens afterwards.** The alternative was implemented first and rejected:
pre-filtering unadmitted supports out of the base call makes an unadmitted
support *vanish* — the premise reports `:MISSING` and the receipt cannot tell
"nothing was offered" from "what was offered is not the kind this premise
takes." That is the defect `CHARTER-DELTA-3` paid to fix one layer down.

The cost: **when the base derivation grants and Slice /2 then refuses, a Slice
/1 grant was computed and is discarded.** `raise` writes no registry and no
store — Slice /0's only mutable global is its ordinal counter — so the
discarded grant is a pure value no reader can reach. It is also not hidden: the
base receipt rides in the Slice /2 receipt, so a reader sees precisely what
Slice /1 would have done and what admission took away. Both migrated
applications print that pair side by side.

---

## 5. The Slice /2 receipt

A new receipt that **wraps** the Slice /1 one. No existing Slice /1 public
return shape changes, and `derivation-receipt` is reachable whole through
`slice2-receipt-base-receipt`.

It exposes: base derivation receipt · applied admission contract per premise ·
admitted supports · recognized-but-not-admitted supports · source bases used ·
judged claims used · refuting supports and refuting witnesses · unsupported
residue · complete binding environments · projected-premise instances ·
ambiguities · decision · per-premise truth ceilings · per-premise reasons.

**The applied contract is retained by value.** The source basis is retained by
defensive snapshot. **No global resolver may be required to understand why a
premise discharged** — everything the question needs is reachable from the
receipt in hand, and Slice /2 keeps no schema registry at all.

`render-slice2-why` distinguishes eight cases: unsupported species · recognized
species not admitted by contract · admitted asserted witness · admitted judged
claim · admitted source basis · refuting evidence · inaccessible support ·
proposition mismatch. **It never prints "effect occurred."** A source-bound
premise renders as what it is — an issued account **reporting** a field — with
the source attempt identity, the exact request, the relation kind, the reported
status, the truth ceiling and the source-basis identity.

---

## 6. Ceilings, restated where a reader will find them

A source basis establishes **at most**:

> this exact canonical account content was minted by the Core /0 runtime in
> this Lisp image, for this request, and the account **reports** the stated
> field.

It does **not** establish that the external-world deed occurred, that the
provider told the truth, that the adapter is honest, that the account's
semantic interpretation is correct, that a downstream domain proposition holds,
or that any effect is settled. Nothing here earns crash survival, durability,
cross-image standing or serialization authenticity, and no cryptographic claim
is made or implied.

**Self-consistency, not corroboration.** One model family wrote this language,
both inhabited applications, every ruling, and this text. **The Core /0
accounts are produced by scripted fake adapters** — a real governed in-image
act, not evidence that any external deed occurred. **The stranger audit remains
owed**, against this specification too.

---

*Verified against SBCL 2.4.6, operation-checked through the wrapper.*

— **PONS, builder, 2026-07-25**
