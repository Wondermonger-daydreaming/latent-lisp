# LANGUAGE SLICE /2 — API, CANDIDATE /0

*The public surface of `lisp-plus-slice2`. Candidate, not frozen. Companion to
`LANGUAGE-SLICE-2-SPEC-0.md`, which is authoritative for semantics.*

Load: `(load "slice2.lisp")` — it loads Core /0, which loads Slice /1, Slice /0,
Kernel /0 and CD/0.

---

## Contracts

### `(make-support-admission-contract &key contract-id contract-version accepted-clauses proposition-relation receiver-accessibility retain)` → contract

Constructs a canonical **value**. Refuses at construction on any malformed
field, so an unevaluable contract cannot exist.

| key | default | notes |
|---|---|---|
| `:contract-id` | — | **required**; keyword or string. A receipt must be able to name it. |
| `:contract-version` | `0` | integer |
| `:accepted-clauses` | — | **required**, non-empty; each species at most once |
| `:proposition-relation` | `:exact-normalized-equality` | the only value Candidate /0 defines |
| `:receiver-accessibility` | `:required` | `:required` \| `:optional` |
| `:retain` | all four items | subset of `:contract-snapshot :support-identity :support-basis :source-basis` |

**Clause families — exactly three.**

```lisp
(:verified-judged-claim)
(:source-basis :relations (<one or more of the three relations>))
(:asserted-witness :mode M :kind K :truth-ceiling :asserted)
```

`:mode` is `:direct` or `:testimony`. `:derivation` is refused — it is the mode
Slice /1 grants wear and the mode a source-basis carrier wears.
`:truth-ceiling` must be written, and must be `:asserted`.

**Readers** (every list-valued one returns a defensive structural copy):

```
support-admission-contract-p
support-admission-contract-contract-id
support-admission-contract-contract-version
support-admission-contract-accepted-clauses
support-admission-contract-proposition-relation
support-admission-contract-receiver-accessibility
support-admission-contract-retain
support-admission-contract-truth-ceilings      ; ((SPECIES . CEILING) …)
support-admission-contract-admits-species-p    ; species test only, NOT the decision
```

Fixed ceilings: `:source-basis → :current-image-issued-account-report`,
`:verified-judged-claim → :prior-governed-judgment`, `:asserted-witness →
:asserted`.

---

## Schemas

### `(make-slice2-schema &key schema-id schema-version base-schema premise-contracts)` → schema

`:base-schema` is a Slice /1 `judgment-schema`. `:premise-contracts` is a list
of `(INDEX CONTRACT)` or `(INDEX . CONTRACT)`, zero-based against the base
schema's own premise order.

Every premise position gets exactly one contract. Refusals, each typed:

```
premise-contract-missing           a position with no contract   (no implicit default)
premise-contract-duplicate         a position named twice
premise-contract-unknown-premise   an index the base schema lacks
slice2-schema-error                a non-contract in a contract position; a non-schema base
```

Contracts are **snapshot** at registration; later mutation of anything the
caller holds cannot revise the registered schema.

```
slice2-schema-p
slice2-schema-schema-id
slice2-schema-schema-version
slice2-schema-base-schema
slice2-schema-premise-contracts        ; ((INDEX . CONTRACT) …) in premise order
slice2-schema-contract-for-premise     ; never NIL, never a default
```

---

## Source bases

### `(establish-core0-source-basis &key evidence request relation expected-outcome)` → basis

`:evidence` a Core /0 account · `:request` a Slice /1 ground structured
proposition · `:relation` one of the three · `:expected-outcome` optional.

When `:expected-outcome` is supplied, the relation's reported value must equal
it or this refuses. When omitted, the basis reports whatever the account
truthfully reports, including `:not-reported`.

Refusals:

```
unissued-core0-account   the content is not registered as Core /0-issued in this
                         image FOR THIS REQUEST.  Its meaning is exactly that; it
                         makes no accusation about the caller.
source-basis-refused     an unknown relation, a non-account, a malformed request,
                         or a reported value that is not the expected one
```

**Readers:**

```
source-basis-p
source-basis-established-in-current-image-p   ; the admission-relevant question
source-basis-identity          source-basis-version
source-basis-species           source-basis-attempt-id
source-basis-request           source-basis-relation-kind
source-basis-relation-version  source-basis-proposition
source-basis-account-status    source-basis-account-outcome
source-basis-truth-ceiling     source-basis-issuance-basis
source-basis-account-snapshot  ; exactly the fields the relation consulted
```

The internal carrier witness is exposed by no reader.

### Relations

```lisp
(core0-source-relations)        ; → a FRESH list of exactly three
(core0-source-relation-p x)     ; → boolean
```

```
:CORE0-ACCOUNT-ISSUED-FOR-REQUEST
:CORE0-ACCOUNT-REPORTS-ACKNOWLEDGMENT
:CORE0-ACCOUNT-REPORTS-OUTCOME
```

Produced propositions, all in Slice /1 normal form:

```lisp
(:predicate :core0-account-issued-for-request
 (:attempt <identity-key string>) (:request (:quoted-datum <request-nf>)))

(:predicate :core0-account-reports-acknowledgment
 (:acknowledgment :acknowledged | :not-reported)
 (:attempt …) (:request …))

(:predicate :core0-account-reports-outcome
 (:attempt …) (:outcome :completed | :failed | :refused | :cancelled
                        | :indeterminate | :superseded | :not-reported)
 (:request …))
```

---

## Derivation

### `(derive/2 &key schema conclusion supports receiver by)` → `(values GRANTED-CLAIM SLICE2-RECEIPT)`

`:schema` is a `slice2-schema` **value** — Slice /2 keeps no schema registry.
The base Slice /1 schema must be registered under its own name and version, and
must be the very object the contracts were attached to.

Recognized `:supports` species — four, pairwise disjoint:

```
a Slice /2 source basis · a Slice /0 witness · a Slice /1 refutation · a Slice /0 claim
```

Anything else is inert residue recorded at the receipt with the **caller's**
zero-based index. A source-basis-shaped value with no usable carrier is residue
too, with reason `:source-basis-without-carrier`.

On refusal it signals `slice2-derivation-refused` carrying the Slice /2
receipt — the shape Slice /1's `derivation-refused` has, so a `consider`-style
wrapper is written the same way:

```lisp
(handler-case
    (multiple-value-bind (claim receipt)
        (lisp-plus-slice2:derive/2 :schema s :conclusion c
                                   :supports sup :receiver ctx)
      (values claim receipt))
  (lisp-plus-slice2:slice2-derivation-refused (e)
    (values nil (lisp-plus-slice2:slice2-condition-receipt e))))
```

**Receiver contexts** reach a source basis by its `source-basis-identity` — the
same id-membership rule Slice /1 already applies to witnesses and claims, read
against a third durable identity. A contract declaring
`:receiver-accessibility :required` is not satisfied by a null receiver
context.

---

## Receipts

```
slice2-receipt-p
slice2-receipt-base-receipt        ; the Slice /1 receipt, whole and unchanged
slice2-receipt-schema-id           slice2-receipt-schema-version
slice2-receipt-conclusion          slice2-receipt-decision      ; :granted | :refused
slice2-receipt-identity            slice2-receipt-origin-context
slice2-receipt-admissions          ; one PREMISE-ADMISSION per premise, in order
slice2-receipt-source-bases-used   slice2-receipt-judged-claims-used
slice2-receipt-unsupported-supports
slice2-receipt-complete-binding-environments
slice2-receipt-uniqueness-conflicts
slice2-receipt-strongest-lawful-result   ; computed over SLICE /2's dispositions
```

### Per-premise admission record

```
premise-admission-p
premise-admission-index                    premise-admission-premise-pattern
premise-admission-contract                 ; the applied contract, BY VALUE
premise-admission-disposition              ; the Slice /2 answer
premise-admission-base-disposition         ; Slice /1's own, unaltered
premise-admission-admitted-supports
premise-admission-recognized-not-admitted  ; the narrowing, made visible
premise-admission-source-bases             premise-admission-judged-claims
premise-admission-refuting-supports        premise-admission-refuting-witnesses
premise-admission-projected-premise-instances
premise-admission-binding-environments     premise-admission-ambiguities
premise-admission-truth-ceilings           ; what ACTUALLY discharged, not the table
premise-admission-reasons
```

**Dispositions** — Slice /1's six, plus one:

```
:satisfied  :not-admitted  :refuted  :inaccessible  :mismatched  :ambiguous  :missing
```

---

## Explanation

```lisp
(lisp-plus-slice2:why object)                        ; structured, never a string
(lisp-plus-slice2:render-slice2-why receipt stream)  ; text
```

`render-slice2-why` never prints "effect occurred". A source basis renders with
its attempt identity, exact request, relation kind, reported status, truth
ceiling and basis identity.

---

## Conditions

```
slice2-condition                      base; -failed-invariant -offending-field
                                      -offending-value -receipt
  admission-contract-error
    unknown-admission-clause
  slice2-schema-error
    premise-contract-missing
    premise-contract-duplicate
    premise-contract-unknown-premise
  source-basis-refused
    unissued-core0-account
  slice2-derivation-refused           carries the Slice /2 receipt
```

---

## Core /0, one addition

```lisp
(lisp-plus-core0:core0-evidence-current-image-issued-for-request-p evidence request)
```

The conjunction of the issuance question and an exact request comparison. It
**confirms** a request the caller already holds; it does not read one out of an
account. `core0-evidence-request` stays internal. Exports 61 → 62.

---

## Ceiling

A source basis establishes at most that this exact canonical account content was
minted by the Core /0 runtime **in this Lisp image**, for **this request**, and
that the account **reports** the stated field. Not that the deed occurred, that
the provider told the truth, that the adapter is honest, or that any domain
proposition holds. Image-local; no durability, cross-image standing,
serialization authenticity or cryptographic property is claimed.

— **PONS, builder, 2026-07-25**
