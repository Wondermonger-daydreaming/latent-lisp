# LANGUAGE FORM /1 — CANDIDATE /0 — WORK ORDER

## "The Form May Petition"

*Owner-directed 2026-07-27. **AMENDED 2026-07-27 under owner ruling
`AMEND AND IMPLEMENT LANGUAGE FORM /1 CANDIDATE /0`.** Written against the live
tree at `5d8cebda`.*

```
status:                        work order, AMENDED — implementation authorized
implementation-authorized:     YES (bounded, isolated branch, unmerged)
specification-frozen:          no
adopted:                       no
architecture:                  B — SPECIALIZED PETITION PIPELINE (owner-accepted)
Form /0:                       UNMODIFIED, and must remain so
Slice /0, /1, /2, Surface /0:  UNMODIFIED, and must remain so
Kernel /0, CD/0:               UNMODIFIED
Slice /3:                      NOT opened
Language Obligation /0:        NOT opened
governing floor:               NOT added — local runner only
root _staging/:                UNTOUCHED
merge:                         FORBIDDEN this session
```

**Primary law, owner-issued and unchanged:**

> **A form may produce a request for a governed operation. It may not perform,
> authorize or certify that operation merely by naming it.**

**The petition is** not a claim · not a source basis · not a derivation basis ·
not a capability · not an authority object · not a successful derivation · not
an executable closure · not an operator extension.

**A valid petition is a well-formed question, not a granted answer.**

---

## 0-A. AMENDMENT 2 — POLICY v2 (owner ruling `RESOLVE EG-4`, 2026-07-27)

Candidate /0 policy **v1 failed EG-4 and was never merged.** Its evidence is
preserved unchanged (`EG4-MEASUREMENT.lisp`, `EG4-WHEN-THE-GATE-FIRES.lisp` and
their raw captures) as the **before-repair record**. Every §-reference below is
superseded where it conflicts with this section.

### The v1 → v2 delta

| | **policy v1 (failed)** | **policy v2 (current)** |
|---|---|---|
| identity representation | Common Lisp **string** of `octets-to-hex ∘ canonical-octets` | **immutable CD/0 byte-string datum** holding the canonical octets |
| composition cost | hex doubles each link ⇒ **≈2.05× per link** | octets embed directly ⇒ **≈ +60 octets per link** |
| composition shape | descendants **restated** the subject and all four reference fields | **transitive and non-redundant** — each phase commits to its immediate predecessor plus only its own new facts |
| identity equality | `string=` | **`lisp-plus-cd0:equal-datum`** |
| hexadecimal | embedded into every successor identity | **diagnostic only** (`RENDER-IDENTITY-HEX`), never embedded |
| resource ceiling | `max-identity-characters 131072`, on the **terminal** identity | `max-identity-octets` envelope + `outcome-tail-reserve-octets`, enforced **only before invocation** |
| where the ceiling could fail | **after `DERIVE/2` had run** — erasing an observed governed act | **before `DERIVE/2` is invoked**, as a build gate |
| receipt construction | could refuse | **TOTAL** once a classified outcome exists |
| Slice /2 receipt reference | `identity-key` **diagnostic string** | **`identity->datum`** — the complete identity, domain and name |
| `TRY-MATERIALIZE-PETITION` | one unary wrapper, **silently dropped the receipt** | **3 values**: `(values PETITION RECEIPT nil)` |
| public string readers | handed out stored (mutable) strings | **fresh `COPY-SEQ`** |
| policy version | 1 | **2** |
| grammar version | 1 | **1, unchanged** — the petition datum grammar did not change |

### The measured result

`EG4-IDENTITY-VALUE-MEASUREMENT.lisp` (committed, raw capture beside it), at the
**largest lawful petition** — 16 support references with the longest names
fitting the 16,384-octet petition ceiling, the petition itself 15,237 octets:

```
                        :GRANTED   :GOVERNED-REFUSAL   :DOOR-REFUSAL
terminal receipt id      15,854         15,882            15,839   octets
outcome tail                144            171               132   octets

maximum terminal identity   15,882 octets      envelope  65,536  → 4.1x headroom
maximum outcome tail           171 octets      reserve    4,096  → 24x headroom
verdict                     EG-4 HOLDS — every admissible classified outcome fits
```

**Envelope adjudication, by measurement rather than guess.** The structural bound
is `max-petition-canonical-octets (16,384) + measured maximum phase overhead
(645) ≈ 17,100` for *any* admissible petition. The envelope is set at **65,536**
— finite, ~3.8× that structural bound, never reached by an admissible input. The
**reserve** stays at 4,096 against a measured maximum tail of 171: over-reserving
only makes the pre-invocation gate *stricter*, which is the safe direction to be
wrong in.

### The law the repair installs

> **No Form /1 refusal may occur after `DERIVE/2` has returned or signalled a
> classified terminal outcome.** Every resource refusal happens before
> invocation; once the governed act exists, the submission outcome and its
> receipt are constructed **totally**.

---

## 0. AMENDMENT RECORD *(amendment 1 — the hole-free ruling)*

This document was **rewritten rather than appended to**, deliberately. An
appendix that corrects superseded prose leaves the superseded prose in place,
and a stale declaration living beside its own correction is one of the six
instrument costumes this lane has already named. Everything below is current.

**What the ruling changed:**

| § | change |
|---|---|
| 4 | **Candidate /0 is HOLE-FREE.** The instantiation phase, `INSTANTIATE-PETITION`, reference holes, binding environments, binding identities, the five binding-refusal codes, EG-3 and NC-29 are all **removed**. |
| 4 | The **operation is encoded in the production head**. The `operation` field and `:UNKNOWN-PETITION-OPERATION` are removed. One production, one governed operation, no handler table. |
| 4 | References are **role-tagged structurally**, not by convention. |
| 4 | `:PETITION-FIELD-DUPLICATE` removed as **unreachable** — verified below. |
| 5 | Context binders are **role-specific**; no generic public `BIND-REFERENCE`. |
| 6 | Context identity commits to the **occurrence ID only**; mapping immutability is distinguished from transitive target immutability. |
| 7 | `SUBMIT-PETITION` requires both `:BY` and `:BY-ID`, no default. |
| 8 | **Submission occurrence identity is fixed BEFORE invocation** and excludes every outcome fact. The receipt identity is the later account. |
| 9 | The receipt/invocation law is corrected to five exact classified cases. |
| 10 | New public transport species **`PETITION-SUBMISSION-OUTCOME`**. |
| 11 | A complete **public API ledger** is added (§21) and `PETITION-FORM-DATUM-P` is **not exported**. |
| 12 | Refusal snapshots at host-object boundaries are bounded and honest. |
| 13 | Explicit **bounded resource policy** with three numeric ceilings. |
| 14 | A **local runner pair** is added, explicitly not a governing floor — resolving the NC-23 contradiction. |
| 15 | **Bounded** mutation discipline: five planted faults, not one per row. |
| 2D | Clarified: Form /1 performs no ambient lookup **of its own**; `DERIVE/2` does and may consult the Slice /1 registry. |

**Affirmed unchanged:** architecture B · `:by` at the submission act · the
conclusion as a durable reference · no stored diagnostic rendering · no
duplicate liveness or admissibility check · unexpected conditions escape.

---

## 1. PREFLIGHT, RE-VERIFIED

```
lab main HEAD          5d8cebda
public mirror tip      012e267   (unchanged; main-only guard verified firing)
work-order branch      language-form-1-work-order
SBCL                   2.4.6     (operation-checked THROUGH the wrapper:
                                  (lisp-implementation-version) => "2.4.6")
form floor             3 floors · 199 checks · 0 failed     ← baseline, measured
language floor        11 floors · 654 checks · 0 failed     ← baseline, measured
verify-all             6/6 suites green                     ← baseline, measured
root _staging/         11 untracked entries, untouched
```

### 1.1 The three facts the ruling required me to verify before implementing

**(a) `RECEIVER-CONTEXT-P` is PUBLIC.** `language-slice-0/slice0-projection.lisp:20`
exports `receiver-context` and `receiver-context-p`.

> **⇒ `BIND-RECEIVER-REFERENCE` is value-typed.** It accepts an exact
> `receiver-context` object, **or `NIL` as explicit receiver absence**. A bound
> `NIL` is a *different fact* from an unresolved receiver reference and produces
> a different outcome (§17).

**(b) NO public predicate establishes exactly what `%REQUIRE-GROUND` requires.**
The finding is more precise than a bare "no", and the precision is the reason:

- `%require-ground` (`slice1.lisp:424-433`) refuses **exactly and only**
  `proposition-pattern-p` — and `proposition-pattern-p` **is** exported.
- But groundness is discharged by **two** gates, not one: `slice1:derive` calls
  `%require-ground`, *and then* `(proposition conclusion)`, which independently
  signals `malformed-structured-proposition`.
- The exported `normal-form-p` (`slice1.lisp:380-382`,
  `(ignore-errors (equal x (proposition x)))`) tests a **strictly stronger**
  property than either gate and would refuse conclusions Slice /1 accepts.

> **⇒ `BIND-CONCLUSION-REFERENCE` is role-typed and VALUE-UNCHECKED.** A
> `proposition-pattern-p` check alone would be **a gate that looks complete and
> is not** — it would catch one of two failure modes while appearing to catch
> the class. The documented Slice /1 escape conditions stay visible (§7.2a) and
> **no private groundness approximation is implemented.**

**(c) `:PETITION-FIELD-DUPLICATE` IS UNREACHABLE — verified, not assumed.**
`%normalize-record-entries` sorts entries by canonical key bytes and then
(`canonical-datum/common-lisp/cd0.lisp:924-929`):

```lisp
(loop for index from 1 below (length normalized)
      for previous = (aref normalized (1- index))
      for current  = (aref normalized index)
      when (zerop (%octets-compare (%entry-key-bytes previous)
                                   (%entry-key-bytes current)))
        do (%host-failure "DuplicateRecordField"))
```

`make-record-datum` (`cd0.lisp:932-934`) calls it unconditionally, and
`decode-exact` normalizes through the same path.

> **⇒ A record datum with duplicate keys cannot reach Form /1 through the
> declared public boundary. The code is removed rather than shipped as a false
> affordance** — this lane already owns one of those (`derivation-basis-refused`,
> exported and never signalled, docketed in `LANGUAGE-SLICE-2-API.md`).

---

## 2. LIVE DEPENDENCY MAP

### 2.1 `LISP-PLUS-CD0` — the representational substrate

Nine families: unit · boolean · integer · rational · string · bytes ·
**identifier** · **sequence** · **record**
(`canonical-datum/common-lisp/package.lisp:45-70`).

Used: `datum-p`, `datum-family`, `make-identifier-datum`, `identifier-datum-p`,
`identifier-datum-namespace-count/-segment`, `identifier-datum-path-count/-segment`,
`make-record-datum`, `make-record-entry`, `record-datum-p`, `record-datum-size`,
`record-datum-key-at`, `record-datum-value-at`, `make-sequence-datum`,
`sequence-datum-p`, `sequence-datum-length`, `sequence-datum-ref`, `equal-datum`,
`canonical-octets`, `decode-exact`, `octets-to-hex`, `octets-length`,
`default-resource-budget`, `budget-id`, `render-diagnostic`.

The **record** family is what makes §4 buildable: CD/0 already has keyed
structure with canonical encoding and duplicate-key rejection, so the petition
body needs no invented field convention and no "keyword alist pretending to be
canonical data."

### 2.2 `LISP-PLUS-FORM0` — sibling, and **not a dependency at all**

**Form /1 requires nothing from `lisp-plus-form0`.** It calls none of its four
transitions, constructs no `form-environment`, reuses no identity machinery
(internal), and defines its own refusal species (Form /0 exports no public
refusal constructor). **`form1.lisp` does not `:use` it and does not name it.**

The direction's §4 question — *"can Form /1 be implemented as a sibling package
using only Form /0's public API"* — resolves as: Form /0 exports **99 symbols and
zero datum primitives**, so *any* sibling must reach `LISP-PLUS-CD0` anyway; and
architecture B needs **nothing from Form /0**, so the double-colon hazard does
not arise. **The absolute rule: never `lisp-plus-form0::`.**

*Also recorded, since it is what killed architecture A:* `VALIDATED-FORM-DATUM`
and `FORM-ENVIRONMENT-OPERATORS`/`-HOLES` are not exported, so a delegating
wrapper would have had to keep a **shadow copy of Form /0's environment
declarations** — the eleven-coats defect written into an architecture at design
time.

### 2.3 `LISP-PLUS-SLICE2` — the governed operation

`derive/2` · `slice2-derivation-refused` · `slice2-condition-receipt` ·
`slice2-schema-error` · `slice2-schema-p` · `slice2-receipt-identity` ·
`slice2-receipt-decision` · the derivation-basis readers (application only).

### 2.4 `LISP-PLUS-SLICE0` — one predicate

`receiver-context-p`, for `BIND-RECEIVER-REFERENCE` (§1.1a).

### 2.5 `LISP-PLUS-KERNEL0` — observed, not called

`slice2-receipt-identity` is minted as
`(lisp-plus-kernel0:make-identity :receipt (format nil "slice2-receipt-~D" (%next-ordinal)))`
(`slice2.lisp:1645-1647`) — **an image-local ordinal name, not a content digest.**
Form /1 reads it through `slice2-receipt-identity` and stores it under a field
name that carries its own ceiling (§9.4).

### 2.6 The ambient-lookup clarification *(ruling §2D)*

> **Form /1 performs no ambient lookup of its own.** It has no special variable,
> no registry, no name search, and resolves only through explicitly bound keys in
> an explicitly supplied sealed context.
>
> **`DERIVE/2` may and does consult the governing Slice /1 schema registry**
> (`slice2.lisp:1539-1549` → `lisp-plus-slice1:resolve-schema`), and that is
> correct and necessary. **No claim is made that no global lookup occurs anywhere
> in the full submission path.**

---

## 3. ARCHITECTURE — B, ACCEPTED

### 3.0 The fact it rests on, read at the source

`form0.lisp:586-593`, inside `%admit`, reached from `propose-form`:

```lisp
(t
 (if (lisp-plus-cd0:identifier-datum-p head)
     (%refuse :grammar :unknown-production path head
              "~A heads no production of the Form /0 grammar" …)
     (%refuse :grammar :head-not-identifier path head …)))
```

A petition head takes this branch. **A petition can never traverse Form /0's
chain.** Verified, not assumed.

### 3.1 C — rejected on two verified grounds

**C-i** — Form /0's operator set is exactly four, none can express a derivation,
and Ruling 1 forbids a fifth (*"`MAKE-OPERATOR-DESCRIPTOR` is not to be
restored"*).

**C-ii** — a literal-wrapped petition *would* pass the grammar, because
`form0.lisp:552-553` says *"Literal payloads are leaves and are never descended
into: a literal is data, whatever it happens to look like."* It buys **zero**
validation and sells a Form /0 **realization receipt** naming an event that did
not happen. Two events, one record.

### 3.2 A — rejected, and not on taste

`VALIDATED-FORM-DATUM` unexported · `FORM-ENVIRONMENT-OPERATORS`/`-HOLES`
unexported · no public refusal constructor. A delegating wrapper is **partially
unbuildable** through the public surface.

### 3.3 B — CHOSEN, and the classifier is now internal

Form /1 handles **only** petition forms. Ordinary forms remain Form /0's, reached
through Form /0 directly.

**`PETITION-FORM-DATUM-P` is NOT exported** *(ruling §11)*.
`TRY-PROPOSE-PETITION` is the authoritative classifier and returns an
**inspectable refusal**, not a boolean. A second boolean opinion has no inhabited
need, and a predicate that could disagree with the entry point is exactly the
kind of second representation this lane exists to refuse. The former NC-24
(classifier agrees with entry point) is therefore **satisfied by construction**
and removed.

---

## 4. THE PETITION GRAMMAR — ONE PRODUCTION, ONE OPERATION

### 4.1 The head carries the operation

```
petition-form ::= [ id(ns=["lisp-plus-form1"], path=["petition","derive","2"]) ,
                    <petition-record> ]
```

**The governed operation is encoded in the production head itself.** There is no
`operation` field, no `:UNKNOWN-PETITION-OPERATION` code, and **no table of
operation handlers.** An unsupported governed operation is an unsupported
production head and refuses at that boundary, with one honest code.

This is the strongest available form of §18's non-goal: a table is how a second
operation gets in by accident, and there is no table.

### 4.2 The body — exactly four fields

A **record datum**. All four required, no defaults.

| key | value |
|---|---|
| `id(["lisp-plus-form1"],["field","schema"])` | one **schema-role** reference |
| `id(["lisp-plus-form1"],["field","conclusion"])` | one **conclusion-role** reference |
| `id(["lisp-plus-form1"],["field","supports"])` | **sequence** of **support-role** references, order significant |
| `id(["lisp-plus-form1"],["field","receiver"])` | one **receiver-role** reference |

**Order significance is load-bearing.** `derive/2` records unrecognized supports
*"at the CALLER's indices"* (`slice2.lisp:1555-1558`), and
`premise-admission-admitted-supports` is *"in caller order"*. A petition that lost
support order would lose the ability to read its own receipt.

**Absent by ruling:** no `by` field (§7) · no `operation` field (§4.1) · no
budget field chosen by the petition (policy is Candidate /0's, §13) · no stored
diagnostic rendering (§19.3) · no annotation.

A `by`-shaped field is simply **not one of the four** and refuses as
`:PETITION-FIELD-UNKNOWN`. There is no separate forbidden-field list, because a
list of forbidden names is a second vocabulary that can drift from the first.

### 4.3 References are ROLE-TAGGED STRUCTURALLY

```
schema-ref     ::= id(ns=["lisp-plus-form1"], path=["ref","schema",     <host-key>])
conclusion-ref ::= id(ns=["lisp-plus-form1"], path=["ref","conclusion", <host-key>])
support-ref    ::= id(ns=["lisp-plus-form1"], path=["ref","support",    <host-key>])
receiver-ref   ::= id(ns=["lisp-plus-form1"], path=["ref","receiver",   <host-key>])
```

**The role is in the identifier, not in a naming convention.** A support
reference and a receiver reference with the same host-key are **different
identifiers** and do not `equal-datum`. A value bound through the support binder
therefore cannot satisfy a receiver reference *"merely because the identifier
text is the same"* — the identifier text is not the same. This is enforced
structurally and proved by a planted fault (PF-3).

**A reference means exactly one thing: *the object the host bound to this
role-and-key when it sealed this context.*** It carries no schema-id, no version,
no kind, no digest — a reference that also *described* its target would create
two accounts of one object that could disagree.

Or, in the formulation the survey earned by executing it:

> **A reference names a position in a sealed context, not an object. The
> reference is durable; the denotation is not.**

The canonical round trip that makes a reference durable provably destroys
pointer identity: `equal-datum` → T, `eq` → NIL.

### 4.4 Grammar admission, in order

| # | check | refusal on failure |
|---|---|---|
| 1 | is a CD/0 `datum` | `(:boundary . :not-a-datum)` |
| 2 | is a **sequence** datum | `(:grammar . :petition-node-not-a-sequence)` |
| 3 | length exactly 2 | `(:grammar . :petition-node-arity)` |
| 4 | head is an identifier datum | `(:grammar . :head-not-identifier)` |
| 5 | head **is** the petition head | `(:grammar . :not-a-derivation-petition)` |
| 6 | body is a record datum | `(:grammar . :petition-body-not-a-record)` |
| 7 | exactly the four keys present | `(:grammar . :petition-field-missing)` |
| 8 | no other keys | `(:grammar . :petition-field-unknown)` |
| 9 | `supports` value is a sequence | `(:grammar . :supports-not-a-sequence)` |
| 10 | each field value is a well-formed reference | `(:grammar . :malformed-reference)` |
| 11 | each reference bears the **required role** | `(:grammar . :reference-role-mismatch)` |
| 12 | support count ≤ policy | `(:policy . :support-count-exceeded)` |
| 13 | canonical octets ≤ policy | `(:policy . :petition-octets-exceeded)` |

**Rule 5 is the whole §6 "direct call" requirement**, discharged with **one honest
code**. Form /1 does **not** reproduce Form /0's production-head vocabulary in
order to say *"that's a Form /0 head"* — that would be a second representation of
Form /0's grammar, maintained here, free to drift. The inhabited application shows
Form /0's own refusal by **passing candidate A to Form /0** and printing what
Form /0 says (§17).

Rules 12–13 run **before any recursively embedded phase identity is
constructed** (ruling §13).

**No host object can appear anywhere**, structurally: every field is read out of a
CD/0 datum, and no CD/0 family can carry a function, a symbol or a package.

### 4.5 Holes — REMOVED

**Candidate /0 has no holes and no instantiation phase.** Form /1 references
already provide parameterization through the explicitly supplied sealed context;
a hole whose value is another reference would be a second indirection with no
inhabited use, duplicating Form /0's most delicate internal machinery.

Removed with it: `INSTANTIATED-PETITION-FORM`, `INSTANTIATE-PETITION`, binding
environments, binding identities, the five binding-refusal codes, **EG-3**, and
**NC-29**.

---

## 5. THE TWO DOORS

### Door 1 — MATERIALIZE

```
canonical petition datum
  → PROPOSE-PETITION    → PROPOSED-PETITION-FORM
  → VALIDATE-PETITION   → VALIDATED-PETITION-FORM  + PETITION-VALIDATION-RECEIPT
  → MATERIALIZE-PETITION → DERIVATION-PETITION     + PETITION-MATERIALIZATION-RECEIPT
```

**Performs no derivation. Resolves nothing. Touches no live object.**

`PROPOSE-PETITION` performs grammar admission and **snapshots the exact datum**
by re-encoding through `canonical-octets` and decoding back with `decode-exact`,
so the stored tree is provably independent of anything the caller retains.

`VALIDATE-PETITION` binds the exact proposed object to: petition grammar
identity and version · Candidate /0 resource-policy identity and version · the
exact subject identity · the budget id. **It is not a mutable status change** —
it returns a new immutable object, and there is no status setter anywhere in the
package.

`MATERIALIZE-PETITION` takes the validated form and a **required host-supplied
occurrence tag**, and produces the petition plus its materialization receipt.

> **`MATERIALIZE-PETITION` takes no resolution context.** It is *structurally
> incapable* of submitting, not merely disinclined to. Remove the socket; do not
> guard it. PF-1 proves it.

Refused names: `REALIZE-DERIVATION` · `PREPARE-DERIVATION` · `PLAN-DERIVATION` ·
any `GRANT-` / `AUTHORIZE-` / `ISSUE-` verb.

### Door 2 — SUBMIT

```
DERIVATION-PETITION + sealed context + :BY + :BY-ID + :ACT-ID
  → PETITION-SUBMISSION-OUTCOME   (kinds :GRANTED | :GOVERNED-REFUSAL | :DOOR-REFUSAL)
  or PETITION-REFUSAL             (Form /1 protocol, before invocation)
  or an escaping condition        (unexpected; no Form /1 semantic object)
```

The host must call it explicitly. There is no path from Door 1 to Door 2.

---

## 6. THE SEALED RESOLUTION CONTEXT

### 6.1 Role-specific binders — no generic public binder

```lisp
(make-derivation-resolution-context)             → unsealed context
(bind-schema-reference     ctx <schema-ref>     <slice2-schema>)      → new unsealed
(bind-conclusion-reference ctx <conclusion-ref> <value>)              → new unsealed
(bind-support-reference    ctx <support-ref>    <value>)              → new unsealed
(bind-receiver-reference   ctx <receiver-ref>   <receiver-context|NIL>)→ new unsealed
(seal-resolution-context   ctx <occurrence-id>)                       → sealed, immutable
```

**No generic public `BIND-REFERENCE` accepting every role is exported.** The role
is structural in the identifier (§4.3) *and* in the operation, and the bindings
are held **role-separated**, so cross-role satisfaction is impossible by
construction rather than by a check that could be forgotten.

### 6.2 What each binder checks — the verified asymmetry

| binder | value check | basis |
|---|---|---|
| `bind-schema-reference` | `lisp-plus-slice2:slice2-schema-p` | public exact species predicate |
| `bind-receiver-reference` | `lisp-plus-slice0:receiver-context-p` **or `NIL`** | §1.1(a) — verified public |
| `bind-conclusion-reference` | **none** — role-typed, value-unchecked | §1.1(b) — no exact public predicate; a partial gate would look complete |
| `bind-support-reference` | **none, deliberately** | `derive/2` owns support classification |

**The support asymmetry is the load-bearing one.** `derive/2` classifies into five
species and records unrecognized ones as **inert residue at the caller's index**
(`slice2.lisp:1557-1558`). Its own comment, one layer down, about exactly this
move (`slice2.lisp:1566-1573`):

> *"EVERY RECOGNIZED SUPPORT REACHES THE BASE DERIVATION… pre-filtering the
> unadmitted supports out of the base call makes an unadmitted support VANISH…
> That is exactly the defect CHARTER-DELTA-3 paid to fix one layer down, and
> reproducing it here would have been a silent regression."*

A Form /1 that pre-filtered supports would reproduce that defect two layers up.
**PF-2** proves it does not.

### 6.3 The law

> **REFERENCE RESOLUTION IS NOT EVIDENCE ADMISSION.**

Form /0 states it for its own environment and the wording is inherited: *"resolving
a name yields a handler and nothing else — no evidence, standing, claim, basis,
capability or authority is produced by resolution."* Form /1's version:
**resolving a reference yields the bound object and nothing else.**

### 6.4 The legitimacy test for any check

> **A private predicate that re-decides a governed question is a second, weaker
> implementation of it. Check the predicate's ARGUMENT LIST against the facts the
> claim quantifies over.**

`%witness-admissible-under-p` failed exactly here: it decided
*admissibility-for-this-premise* while **the premise was not one of its
parameters**. `slice2-schema-p` quantifies over *"is this object of this species"*
and takes exactly that object — legitimate. Anything needing the premise, the
contract or the proposition is forbidden, because Form /1 will never hold them.

### 6.5 Context identity, and the two immutabilities

**The sealed context carries a required host-supplied CD/0 occurrence
identifier.** It cannot derive an identity from its contents: its bindings are
live host objects with no canonical encoding, so a content-derived identity would
cover the key set only, and two contexts binding the same keys to entirely
different objects would be indistinguishable.

> **The occurrence ID names this context occurrence. It does not certify the live
> objects bound inside it.** Two contexts with the same supplied ID and different
> bindings remain an **undetected host error**, preserved as NC-31.

**The context's public identity commits to the occurrence ID alone.** No invented
canonical encoding of host objects is constructed. **No prose in this document
says the identity proves "the exact context"** — it proves the exact *name*.

**Two immutabilities, and only one is claimed:**

```
CONTEXT MAPPING IMMUTABILITY   — CLAIMED.
    after seal, the key→object associations cannot be altered; there is no
    public writer, and binding after seal refuses.

TRANSITIVE TARGET IMMUTABILITY — NOT CLAIMED.
    the referenced live host objects have their own semantics and their own
    mutability. Form /1 neither freezes them nor pretends to.
```

**The sealed context retains exact live bindings by reference** — that is the
point of it. Aggregate readers return defensive snapshots of the *mapping*.
Returning the sealed context object itself is permitted, because no public writer
exists.

### 6.6 Context refusal paths

`:malformed-reference` · `:binding-role-mismatch` (a reference of the wrong role
handed to a binder) · `:duplicate-binding` (same role-and-key twice) ·
`:binding-after-seal` · `:context-occurrence-id-missing` (at seal) ·
`:wrong-schema-species` · `:wrong-receiver-species` · `:context-not-sealed` (at
submission) · the four `:unresolved-*-reference` codes. **Each is in the
catalogue (§11) and each has a fixture.**

---

## 7. THE SUBMISSION PATH

### 7.1 The public call

`slice2.lisp:1509`:

```lisp
(defun derive/2 (&key schema conclusion supports receiver by)
```

Grant → `(values GRANTED-CLAIM SLICE2-RECEIPT DERIVATION-BASIS)`
(`slice2.lisp:1663-1664`), the third value minted *"only HERE, only after a
genuine Slice /2 grant"* (`1660-1662`).

### 7.2 The exits, verified

| exit | mechanism | Slice /2 receipt? | source |
|---|---|---|---|
| grant | returns 3 values | **yes**, returned | `1663-1664` |
| governed refusal | signals `slice2-derivation-refused` | **yes**, on the condition | `1665-1678` |
| door refusal | signals `slice2-schema-error` | **no** | `1531-1534`, `1549-1554` |
| **escape** | signals a **non-Slice /2** condition | **no** | §7.2a |

### 7.2a The escape set

`derive/2` wraps the base call in a handler for **exactly one** class,
`lisp-plus-slice1:derivation-refused` (`slice2.lisp:1614`). These travel through:

```
lisp-plus-slice1:pattern-used-as-ground
lisp-plus-slice1:malformed-structured-proposition
lisp-plus-slice1:unbound-conclusion-variable
a raw host TYPE-ERROR   ← when :RECEIVER is neither a RECEIVER-CONTEXT nor NIL
```

**Form /1 catches none of them.** It cannot honestly classify a Slice /1
condition as a *petition* outcome, and converting one would be the broad-handler
defect in a narrower coat. The raw `TYPE-ERROR` — by far the likeliest — is
**reduced at its source** by the typed `bind-receiver-reference` (§6.2). What
remains is **documented, not silently possible** (NC-30), because a caller who
does not know this will wrap the call in `(error () …)` and undo the whole
discipline.

### 7.3 `:BY` and `:BY-ID` — both required, no default

`:by` is consequential. Traced: `derive/2` passes it to `slice1:derive`
(`slice2.lisp:1609-1612`), which uses it at `slice1.lisp:1758` as the derivation
witness's `:source` and at `slice1.lisp:1765` as
`(lisp-plus-slice0:claim :proposition … :by (or by :deriver))`. Slice /0 is
explicit: *"a claim MUST name its asserting principal"* (`slice0.lisp:327`).

`SUBMIT-PETITION` therefore requires **both**:

```
:BY      the exact live value passed to public DERIVE/2
:BY-ID   a required CD/0 identifier naming that principal in the Form /1 record
:ACT-ID  a required CD/0 identifier naming this submission act
```

**No default is permitted.** `DERIVE/2`'s `NIL → :DERIVER` default is **not
silently inherited**; a missing `:by`, `:by-id` or `:act-id` refuses.

The submission receipt **retains the exact live `:BY` value as an image-local
anchor** and **binds `:BY-ID` into the submission occurrence identity**.

> **`BY-ID` names the principal supplied by the host; it does not independently
> certify the live value.**

**The petition datum itself still contains no `by` field**, and cannot: a
petition is a question, and a question does not have an asserter of its answer.
Whoever *acts* asserts.

### 7.4 The procedure

1. verify petition and context species, and that the context is **sealed**;
2. verify `:by`, `:by-id`, `:act-id` supplied;
3. verify the petition's recorded identity still recomputes (caller mutation
   inert);
4. **compute the SUBMISSION OCCURRENCE IDENTITY — before any invocation** (§9.3);
5. resolve all four reference roles through the sealed context; **any unresolved
   reference refuses here and `derive/2` is never called**;
6. **invoke public `derive/2`** with the resolved objects in their exact
   positions plus `:by`;
7. catch **only** `slice2-derivation-refused` and `slice2-schema-error`, by exact
   class;
8. classify the outcome, mint the submission receipt, return the transport
   species (§10).

**No `(error () …)` handler appears anywhere in this path.**

### 7.5 Two live footguns for the host

**(1)** `:receiver-accessibility` defaults to `:required` (`slice2.lisp:374`), so
an unconsidered contract makes every premise `:not-admitted` with a `NIL`
receiver. That is a *correct* Slice /2 outcome, not a Form /1 refusal — and §17
exercises both sides of it deliberately.

**(2)** Build the Slice /2 wrapper over `(resolve-schema name version)`, **never**
over the object you registered: `register-schema` returns the *existing* object on
idempotent re-registration (`slice1.lisp:664-667`) and `derive/2` compares with
`EQ` (`slice2.lisp:1549`).

---

## 8. THE OBJECT FAMILY

**No public constructor exists for any phase object or receipt.** Each is the
output of exactly one operation. This is Slice /2's own mechanism, stated in its
API doc for derivation bases: *"There is no public constructor, and that is the
mechanism."*

| species | minted by | carries |
|---|---|---|
| `PROPOSED-PETITION-FORM` | `propose-petition` | datum snapshot · subject identity · own identity · grammar id+version |
| `VALIDATED-PETITION-FORM` | `validate-petition` | proposed identity · subject identity · own identity · grammar id+version · policy id+version · budget id · validation receipt |
| `PETITION-VALIDATION-RECEIPT` | `validate-petition` | every bound component above · own identity |
| `DERIVATION-PETITION` | `materialize-petition` | validated identity · content identity · occurrence identity · occurrence tag · the four field values · policy id+version |
| `PETITION-MATERIALIZATION-RECEIPT` | `materialize-petition` | validated identity → content identity → occurrence identity · policy id+version · own identity |
| `DERIVATION-RESOLUTION-CONTEXT` | `make-…` / `bind-…` / `seal-…` | role-separated bindings · sealed-p · occurrence id |
| `PETITION-SUBMISSION-OUTCOME` | `submit-petition` | **transport only** — §10 |
| `PETITION-SUBMISSION-RECEIPT` | `submit-petition` | submission occurrence identity · outcome kind · outcome references · own identity |
| `PETITION-REFUSAL` | any entry point | phase · category · code · path · offending · reference · expected role · host type · detail · own identity |

**Three phase species, not four** — the instantiation phase is removed (§4.5).
**No mutable status fields anywhere**: no `:submitted`, `:granted`, `:refused`,
`:completed`. A `DERIVATION-PETITION` is byte-identical before and after any
number of submissions.

**Every aggregate-valued public reader returns a defensive snapshot or an
immutable value** — the `de-pignore` Review 2 lesson, where a read-only *slot*
stood in for an immutable *value*.

---

## 9. THE IDENTITY MODEL

### 9.0 Identity VALUES — lossless data, never text, never a digest

**⚠ AMENDED BY AMENDMENT 2.** An identity is an **immutable CD/0 byte-string
datum** built by `(make-bytes-datum (canonical-octets payload))`.
`make-bytes-datum` accepts an `octet-string` directly (`cd0.lisp:704-731`) and
`canonical-octets` returns one, so no stringification and no hex intervenes.
Equality is `equal-datum`. Hex comes only from `RENDER-IDENTITY-HEX` and is
never embedded into a later identity.

The passage below is retained because its mechanism is exactly *why* the repair
was necessary — it explains the v1 failure it caused.

#### (historical, policy v1) The composition is LOSSLESS, not a digest

**CD/0 supplies no hash and no content-identity function.** Form /0's identity is
`octets-to-hex ∘ canonical-octets` over a phase-tagged sequence — a **lossless
encoding**. Its "content digest" literally *contains* the object: 480 hex
characters for the smallest sealed environment. That is why its chain grows
440 → 1040 → 4658 → 12456 → 26020.

Form /1 inherits this — there is nothing else, and inventing a hash protocol is
forbidden. Consequences: identity length grows multiplicatively, so the chain
stays short and is **measured** (§13); a Form /1 identity is **never described as
a digest**; and §13's ceilings exist precisely because fixed depth alone does not
bound size.

### 9.1 The chain

```
subject identity          hex(canonical(petition datum))
proposed identity         hex(canonical([:proposed,  grammar-id, grammar-ver, subject]))
validated identity        hex(canonical([:validated, proposed, grammar-id, grammar-ver,
                                         policy-id, policy-ver, budget-id, subject]))
petition CONTENT identity hex(canonical([:content,   validated, petition-head,
                                         schema-ref, conclusion-ref, support-refs…,
                                         receiver-ref, policy-id, policy-ver]))
petition OCCURRENCE id    hex(canonical([:occurrence, content, occurrence-tag,
                                         policy-id, policy-ver]))
SUBMISSION OCCURRENCE id  hex(canonical([:submission-occurrence, petition-occurrence,
                                         context-occurrence-id, act-id, by-id,
                                         procedure-id, procedure-ver]))
SUBMISSION RECEIPT id     hex(canonical([:submission-receipt, submission-occurrence,
                                         outcome-kind, slice2-receipt-id|ABSENT,
                                         condition-class|ABSENT]))
```

### 9.2 Occurrence tags are host-supplied, and the guarantee is small

`MATERIALIZE-PETITION` requires an occurrence tag; `SUBMIT-PETITION` requires an
act id; `SEAL-RESOLUTION-CONTEXT` requires an occurrence id. **None has a
default.** Not derived from the receipt (a content-derived receipt identity would
move the collapse, not remove it); not an image-local counter (Slice /2 uses one
at `slice2.lisp:1645-1647` — the precedent is named and **not** followed, because
it adds mutable global state to a lineage that has none and makes identity depend
on invisible history).

> **The honesty clause, which must appear in the implementation's own
> documentation.** Form /1 **does not and cannot guarantee** that two supplied
> tags differ. It guarantees only that the supplied tag is bound into the
> identity, so **different tags ⇒ different identities** (NC-25). Identical tags
> ⇒ identical identities, an **undetected host error** (NC-26, NC-31, NC-33).
> **No global exactly-once claim is made.**

### 9.3 SUBMISSION OCCURRENCE ≠ SUBMISSION OUTCOME  *(ruling §8)*

**The submission occurrence identity is computed BEFORE `derive/2` is called**
and commits to exactly five things:

```
petition occurrence identity
sealed context occurrence ID
exact submission-act ID
BY-ID
submission procedure identity and version
```

**It does NOT include** a Slice /2 receipt · a grant/refusal decision · a
condition class · anything produced after invocation.

**The receipt identity is the later account**, and commits to the submission
occurrence identity **plus** the classified outcome kind, the exact Slice /2
receipt identity when one exists, and the exact condition class when the
classified door-refusal path has none.

> **The act and its later account are different facts.** An identity that folded
> the outcome into the act would make it impossible to name the act that was
> attempted and failed — and would make the submission's identity unknowable
> until after the thing it identifies had already happened.

### 9.4 The Slice /2 outcome reference — image-local, and named so

`slice2-receipt-identity` is an image-local ordinal
(`slice2.lisp:1645-1647`). **Never write a Slice /2 ordinal into a canonical
datum without its ceiling beside it.** The field is therefore named

```
petition-submission-receipt-image-local-slice2-receipt-identity
```

and not `…-slice2-receipt-identity`. **A field name is the cheapest ceiling
there is, and the only one a hurried reader cannot skip.**

The door-refusal case has **no receipt at all**, so the outcome reference has
three exhaustive shapes, one an explicit legal absence:

```
:GRANTED           → receipt identity present, decision :granted
:GOVERNED-REFUSAL  → receipt identity present, decision :refused
:DOOR-REFUSAL      → NO RECEIPT EXISTS — condition class recorded, identity ABSENT
```

A required field with nothing true in it is a confabulation generator. **The
sanctioned null is deliberate.**

### 9.5 Two identity regimes, straddled

```
CONTENT regime      Form /0 · CD/0     content-derived, reproducible
ALLOCATION regime   Slice /2 · Slice /0  image-local ordinals (slice2-receipt-N)
```

Form /1 sits on both. **Only one survives an image boundary**, and the field
names say which is which.

### 9.6 What must never be collapsed

`subject` ≠ `proposed` ≠ `validated` ≠ `content` ≠ `petition occurrence` ≠
`submission occurrence` ≠ `submission receipt` ≠ `slice2 receipt` ≠ `claim` ≠
`derivation basis`. NC-22 requires every *displayed* identity to discriminate
every *full* identity in the exercised genealogy — the Form /0 stranger audit
measured naive 16-character prefixes collapsing distinct values on a live sample.

---

## 10. THE SUBMISSION RETURN CONTRACT

### 10.1 `PETITION-SUBMISSION-OUTCOME` — a transport species

**It is not a receipt, claim, basis, authority object or new source of
standing. It has no public constructor.** It carries **exact returned or
signalled objects**, never copied paraphrases.

| reader | value |
|---|---|
| `…-kind` | `:GRANTED` \| `:GOVERNED-REFUSAL` \| `:DOOR-REFUSAL` |
| `…-claim` | the exact granted claim, or `NIL` |
| `…-slice2-receipt` | the exact Slice /2 receipt, or `NIL` where none exists |
| `…-derivation-basis` | the exact basis, or `NIL` |
| `…-condition` | the exact caught Slice /2 condition, or `NIL` |
| `…-receipt` | the exact `PETITION-SUBMISSION-RECEIPT` |

### 10.2 The two entry points

```lisp
(try-propose-petition candidate)          → (values PROPOSED nil)  / (values nil REFUSAL)
(try-validate-petition proposed)          → (values VALIDATED nil)  / (values nil REFUSAL)
(try-materialize-petition validated tag)  → (values PETITION RECEIPT nil)
                                          / (values nil nil REFUSAL)   ← THREE values
(try-submit-petition petition context &key by by-id act-id)
                                          → (values OUTCOME nil)   / (values nil REFUSAL)
  ;; unexpected conditions ESCAPE

AMENDMENT 2: TRY-MATERIALIZE-PETITION returns THREE values.  One unary wrapper
is wrong for an operation of arity two — it silently discards the
materialization receipt.  One wrapper per arity, never one wrapper for all.

(submit-petition petition context &key by by-id act-id)
  → signals PETITION-REFUSED for Form /1 protocol refusal
  → otherwise returns the OUTCOME
  ;; never relabels or paraphrases the Slice /2 decision
```

### 10.3 The corrected receipt/invocation law  *(ruling §9)*

> A submission receipt exists **when `DERIVE/2` was invoked and returned or
> signalled one of the exact classified Slice /2 terminal outcomes Form /1
> handles.**

| case | condition | result |
|---|---|---|
| **A** | Form /1 protocol refusal before invocation | no `DERIVE/2` call · `PETITION-REFUSAL` · **no submission receipt** |
| **B** | `DERIVE/2` grants | submission receipt · exact claim · exact Slice /2 receipt · exact derivation basis |
| **C** | governed derivation refusal | submission receipt · exact condition · exact Slice /2 receipt |
| **D** | Slice /2 door refusal | submission receipt · exact condition · **explicit legal absence** of receipt identity |
| **E** | unexpected Slice /1, Slice /0 or host condition | **condition escapes** · no Form /1 semantic outcome object · **no submission receipt is claimed** |

**No after-the-fact receipt is minted for an unclassified failure.** Case E is
proved by NC-34, and PF-5 plants a fault to prove the conversion cannot happen
silently.

A receipt records **that a submission happened**, never that it succeeded. A
design minting receipts only for grants would produce a history containing only
successes — *a filtered transcript standing in for the run*, which is one of the
eleven coats, and which this lane paid for two days ago.

---

## 11. THE REFUSAL CATALOGUE

**One code per distinct condition.** Form /0's `:UNKNOWN-PRODUCTION` is
**overloaded** — it fires both at `form0.lisp:554-557` (*node is not a sequence*)
and at `586-593` (*head names no production*), so a reader holding only the code
cannot tell which happened. That is representation collapse in the layer whose own
addendum named it, and it is why the stranger audit had to record a separate
nuance for B9. **Form /0 must not be repaired (EG-1). Form /1 declines to inherit
it.**

| phase | category | code |
|---|---|---|
| propose | `:boundary` | `:not-a-datum` |
| propose | `:grammar` | `:petition-node-not-a-sequence` |
| propose | `:grammar` | `:petition-node-arity` |
| propose | `:grammar` | `:head-not-identifier` |
| propose | `:grammar` | `:not-a-derivation-petition` |
| propose | `:grammar` | `:petition-body-not-a-record` |
| propose | `:grammar` | `:petition-field-missing` |
| propose | `:grammar` | `:petition-field-unknown` |
| propose | `:grammar` | `:supports-not-a-sequence` |
| propose | `:grammar` | `:malformed-reference` |
| propose | `:grammar` | `:reference-role-mismatch` |
| propose | `:policy` | `:support-count-exceeded` |
| propose | `:policy` | `:petition-octets-exceeded` |
| any pre-invocation phase | `:policy` | `:identity-octets-exceeded` *(amendment 2)* |
| submit, **before invocation** | `:policy` | `:submission-envelope-exceeded` *(amendment 2)* |
| validate | `:species` | `:not-a-proposed-petition-form` |
| validate | `:identity` | `:proposed-identity-drift` |
| validate | `:policy` | ~~`:identity-length-exceeded`~~ → **`:identity-octets-exceeded`** *(amendment 2; the v1 name does not exist in the implementation)* |
| materialize | `:species` | `:not-a-validated-petition-form` |
| materialize | `:argument` | `:occurrence-tag-required` |
| materialize | `:identity` | `:validated-identity-drift` |
| context | `:grammar` | `:malformed-reference` |
| context | `:context` | `:binding-role-mismatch` |
| context | `:context` | `:duplicate-binding` |
| context | `:context` | `:binding-after-seal` |
| context | `:context` | `:context-occurrence-id-required` |
| context | `:context` | `:wrong-schema-species` |
| context | `:context` | `:wrong-receiver-species` |
| submit | `:species` | `:not-a-derivation-petition` |
| submit | `:species` | `:not-a-resolution-context` |
| submit | `:context` | `:context-not-sealed` |
| submit | `:argument` | `:by-required` |
| submit | `:argument` | `:by-id-required` |
| submit | `:argument` | `:act-id-required` |
| submit | `:identity` | `:petition-identity-drift` |
| submit | `:context` | `:unresolved-schema-reference` |
| submit | `:context` | `:unresolved-conclusion-reference` |
| submit | `:context` | `:unresolved-support-reference` |
| submit | `:context` | `:unresolved-receiver-reference` |

**Removed as unreachable:** `:petition-field-duplicate` (§1.1c).
**Removed with holes:** all five binding-refusal codes.
**Removed with the head:** `:unknown-petition-operation`.

### 11.1 Three disciplines

**(a) Do not pre-empt Slice /2's dispositions.** A support that resolves but
fails a premise is **not** a Form /1 refusal; it is a governed outcome (NC-10).

**(b) Catch only exact documented classes.** Exactly two:
`slice2-derivation-refused`, `slice2-schema-error`. **No `(error () …)`
anywhere.**

**(c) Every advertised code has a reachable fixture, or it does not ship.** This
lane owns a documented counterexample: `derivation-basis-refused` is *"exported
and a caller can write a handler for it, but nothing in Candidate /1 signals it"*
— *"a false affordance today"*. **NC-32 checks the declared code set against the
codes the suite actually produced, set-difference empty in both directions.** No
menu of acceptable reasons may substitute for the reason a fixture produces.

---

## 12. REFUSAL SNAPSHOTS AT HOST-OBJECT BOUNDARIES

A context-binding refusal may concern an arbitrary live Common Lisp object that
**cannot be encoded as CD/0**.

**Forbidden as a snapshot:** `PRIN1-TO-STRING` · `READ-FROM-STRING` ·
`PRINT-OBJECT` output · `SXHASH`. None of these is a canonical content identity,
and treating one as such is the substitution defect with a printer attached.

| refusal stage | retains |
|---|---|
| **datum-stage** | the **exact immutable CD/0 datum** |
| **host-object binding** | the exact role reference · the expected role/species · `TYPE-OF` or another bounded host type descriptor · an image-local offending-object anchor **only if needed and clearly named image-local** · **no claim of durable content identity** |

A refusal's own identity may use: refusal occurrence id · phase · category ·
code · exact reference · expected role · bounded host type descriptor.

> **Do not pretend an arbitrary host object has canonical content.**

---

## 13. BOUNDED RESOURCE POLICY

**Fixed phase depth does not by itself bound identity size** (§9.0). Candidate /0
adopts an explicit narrow policy:

**⚠ AMENDED BY AMENDMENT 2** — the character ceiling is replaced by an
octet envelope, and every resource refusal moves before invocation.

```
maximum support references          16      (unchanged)
maximum petition canonical octets   16384   (unchanged)
maximum identity octets             65536   (envelope, adjudicated by measurement)
outcome-tail reserve octets          4096   (reserved BEFORE invocation)
```

**These are Candidate /0 experimental ceilings, not universal Lisp+ limits.**

The support ceiling and the encoded-size ceiling are enforced **before any
recursively embedded phase identity is constructed** (§4.4, rules 12–13). The
identity ceiling refuses `(:policy . :identity-octets-exceeded)` *(amendment 2 —
octets, not characters; the v1 code name is gone)*, and the submission path
additionally refuses `(:policy . :submission-envelope-exceeded)` **before**
invocation.

**Required measurements**, printed by the suite:

- the smallest lawful petition;
- the inhabited Candidate D petition;
- a maximum-policy petition with **16** support references.

**Every phase identity length is printed** for each.

> **⚠ AMENDMENT 2 restates this in octets: if the maximum-policy terminal
> identity exceeds the 65,536-OCTET envelope: STOP,
> report EG-4 FAILED, and do not invent a hash protocol.**

The exact policy identity and version are bound into validation, petition content
and the materialization receipt.

---

## 14. NEGATIVE-CONTROL MATRIX

| # | control | expected |
|---|---|---|
| 1 | ordinary `DERIVE/2`-shaped call as a datum | `(:grammar . :not-a-derivation-petition)`; the application separately shows Form /0's own refusal |
| 2 | `PERFORM` unavailable | no Form /1 path reaches it; source grep tooth |
| 3 | unsupported governed operation | an unsupported head ⇒ `:not-a-derivation-petition` (no operation table exists) |
| 4 | caller-supplied handler function | unrepresentable — no CD/0 family carries one |
| 5 | no ambient lookup **by Form /1** | a reference absent from the context refuses; `DERIVE/2`'s own registry consultation is expected and not denied |
| 6 | unresolved **schema** reference | `(:context . :unresolved-schema-reference)`, `derive/2` NOT called |
| 7 | unresolved **support** reference | `(:context . :unresolved-support-reference)`, `derive/2` NOT called |
| 8 | unresolved **receiver** reference | `(:context . :unresolved-receiver-reference)`, `derive/2` NOT called |
| 9 | same-key but **stale schema** | `derive/2` signals `slice2-schema-error` ⇒ `:DOOR-REFUSAL`; **no Form /1 copy of the rule ran** |
| 10 | correct support kind, **wrong subject** | resolution succeeds · `derive/2` **invoked** · premise unsatisfied · **no claim, no basis** · `:GOVERNED-REFUSAL` · submission receipt exists · petition unchanged |
| 11 | petition offered as source basis | refused / inert residue |
| 12 | petition offered as derivation basis | refused / inert residue |
| 13 | materialization receipt offered as standing | refused / inert residue |
| 14 | submission receipt offered as truth evidence | refused / inert residue |
| 15 | petition A's receipt against petition B | refuses on occurrence-identity mismatch |
| 16 | substitute the context | submission **occurrence** identity differs |
| 17 | refused submission | petition byte-identical before and after; identity recomputes |
| 18 | re-submission | a second submission occurrence; first unchanged; no chaining |
| 19 | before a grant | **no** claim, source basis or derivation basis exists anywhere |
| 20 | mutate an aggregate reader's return | stored objects unchanged |
| 21 | unexpected implementation error in the path | **escapes**; not converted |
| 22 | identity display over the genealogy | distinct-full == distinct-short, lengths borne |
| 23 | runner counts | derived from actual verdicts; raw output retained; **generator committed** |
| 25 | same content, different occurrence tag | different occurrence identities |
| 26 | same content, same occurrence tag | identical identities — **documented undetected host error** |
| 27 | petition carrying a `by` field | `(:grammar . :petition-field-unknown)` |
| 28 | **Door 1 under an invocation counter** | counter **0**, with a positive control proving it reaches 1 — see §14.1 |
| 30 | malformed conclusion binding | the documented Slice /1 condition **escapes**; not converted |
| 31 | two contexts, same occurrence ID, different bindings | identical context identity — recorded as the undetected host error |
| 32 | declared code set vs. produced code set | set-difference **empty in both directions** |
| 33 | same submission-act ID reused | identical submission occurrence identity — recorded under the same honesty rule |
| 34 | **escaping condition leaves no semantic receipt** | after an escape, **no** `PETITION-SUBMISSION-RECEIPT` and no outcome object exist |
| 35 | **role confusion** | a value bound through the support binder does **not** satisfy a receiver reference with the same host key |
| 36 | **receiver bound to NIL** | distinct from unresolved: `derive/2` **is** invoked; the outcome is whatever the contract makes it |
| 37 | **binding after seal** | `(:context . :binding-after-seal)` |

*Removed: NC-24 (satisfied by construction — no second classifier is exported),
NC-29 (holes removed).*

### 14.1 NC-28 in full — the tooth that decides the layer

Form /1's central claim is *"petitioning does not perform."* The tempting test
inspects **what came back** — a `:performed nil` field, an absent receipt. **That
test is worthless**: it interrogates a representation of the event instead of the
event, which is the exact mistake this layer exists to refuse.

**The required test measures the act:**

```
1. rebind (fdefinition 'lisp-plus-slice2:derive/2) to a counting shim
2. run Door 1 — propose, validate, materialize
3. assert the counter reads 0
4. POSITIVE CONTROL: run Door 2 on the same petition
5. assert the counter reads 1     ← without this, step 3 proves nothing
```

**Step 5 is not optional.** A counter that can never increment reports zero for a
broken reason. The same shape governs NC-2 and NC-19.

---

## 15. BOUNDED MUTATION DISCIPLINE  *(ruling §15)*

**Do not build one mutant per negative-control row.** Planted faults are required
for exactly these five load-bearing boundaries:

| # | planted fault | must be caught by |
|---|---|---|
| **PF-1** | make `MATERIALIZE-PETITION` able to invoke `DERIVE/2` | NC-28 |
| **PF-2** | make Form /1 pre-filter resolved supports before `DERIVE/2` | NC-10 |
| **PF-3** | let role-separated resolution satisfy a receiver reference from the support table | NC-35 |
| **PF-4** | make an aggregate reader alias the stored value | NC-20 |
| **PF-5** | wrap the submission path in `(error () …)` so an implementation condition becomes a petition refusal | NC-21 / NC-34 |

**Record where every planted fault died**, and at which tooth. **Do not collapse
all nonzero exits into "killed"** — the Form /0 mutation battery's headline
*"10 planted, 10 killed"* was numerically true and epistemically compressed, and
the stranger audit had to unpack it into 7 at the intended tooth, 2 through a
different marker, 1 before its tooth.

Every other negative control gets a **direct executable fixture** with an exact
expected outcome, plus a positive control wherever the instrument's reachability
is otherwise unclear.

---

## 16. FILES, RUNNER, AND FLOORS

### 16.1 Files added — and nothing else

```
mneme/language-form-1/
  package.lisp
  form1.lisp
  form1-selftest.lisp
  run-form1-candidate.sh
  check-form1-transcript.sh
  LANGUAGE-FORM-1-WORK-ORDER.md      ← this file
  LANGUAGE-FORM-1-RETURN.md
  de-forma-petente/APPLICATION.lisp
  (raw captures + transcript-check artifact, tracked per project convention)
```

**Load order:** `package.lisp` → CD/0 → Slice /2 (which loads Core /0, Slice /1,
Slice /0, Kernel /0) → `form1.lisp`. **Form /0 is not loaded by Form /1.** The
application loads both, to exhibit the two doors.

### 16.2 The local runner — and the NC-23 contradiction, resolved

The earlier draft said *"no runner is added"* while NC-23 demanded a committed
generator. **Both were right about different things, and the ruling resolves it:**
Candidate /0 ships a **local runner pair** living only under `language-form-1/`.

```
run-form1-candidate.sh     executes form1-selftest + de-forma-petente,
                           captures RAW UNFILTERED output, retains exit codes
check-form1-transcript.sh  reconciles the captures reproducibly into a tracked
                           artifact, deriving every number from actual verdict lines
```

**They are NOT added to** `verify-form-floor.sh` · `verify-language-floor.sh` ·
`verify-all.sh` · any governing floor.

The reconciler must derive footer-vs-body counts, contiguous numbering,
failure-count agreement, exit-code agreement, and must **distinguish a typed
protocol refusal from an implementation failure**. It must **not** filter verdict
text by words such as `caught`, `warning` or `error` — a relay filter whose
exclusion list contained *"caught"* ate verdict `[28]` from a committed artifact
two days ago.

**And it must exist.** `de-pignore`'s `RUN-TRANSCRIPT-CHECK.txt` claims
*"generated by mechanical reconciliation of the RAW capture; no expected N is
hard-coded"* and **no generator for it exists anywhere in the repository** —
chair-verified by `grep` over the whole tree. The reconciler is a committed file
or the reconciliation is not evidence.

### 16.3 Unchanged floors

```
UNCHANGED, byte-verified before and after:
  canonical-datum/  kernel0/  language-core-0/  language-slice-0/
  language-slice-1/ language-slice-2/  language-surface-0/  language-form-0/
  lci0/  architecture/  verify-*.sh   root _staging/

BASELINE, measured this session:
  form floor      3 floors · 199 checks · 0 failed
  language floor 11 floors · 654 checks · 0 failed
  verify-all      6/6 suites green
```

**Form /1 is not Language Surface /0.** Surface /0 is *"a transparent front end,
not a semantic layer"* whose macros expand to the same public calls, with
`derive/2` *"deliberately unsugared"*. Form /1 introduces a new semantic species
over a **datum** substrate. No macroexpansion appears in it.

**Docket items D-1 … D-4 are NOT repaired in this branch** (§22).

---

## 17. THE INHABITED APPLICATION

**`de-forma-petente`** — deterministic, scripted, **no live model call**.

| | candidate | expected |
|---|---|---|
| **A** | non-petition / direct-call datum | Form /1 refuses `:NOT-A-DERIVATION-PETITION` · **Form /0 independently refuses** its own ordinary `DERIVE/2`-shaped call, printed from Form /0's own refusal object · no submission |
| **B** | missing support-role reference | proposal and validation succeed · petition materializes · **submission refuses before `DERIVE/2`** · no submission receipt |
| **C** | correct support species/mode/kind, **wrong subject** | resolution succeeds · `DERIVE/2` **invoked** · premise unsatisfied · `:GOVERNED-REFUSAL` · submission receipt exists · **no claim, no derivation basis** |
| **D** | exact case | `DERIVE/2` **grants** · `:GRANTED` · exact claim, Slice /2 receipt and derivation basis preserved · submission receipt links and **inherits no standing** |

**Also exercised:**

- a receiver reference **explicitly bound to `NIL`** under a contract that permits
  it (`:receiver-accessibility :optional`);
- a **receiver-required** contract with `NIL`, producing the governed Slice /2
  outcome — not a Form /1 refusal;
- **role-confused binding** (support binder vs. receiver reference);
- the **same context occurrence ID with different live bindings**, recorded as
  the undetected trusted-host error;
- the **same submission-act ID reused**, recorded under the same honesty rule.

**Candidate C is the centre of the specimen**: the machinery ran, the governed
operation decided, and *nothing was minted*. Its "wrong subject" support must
have the **correct species, mode and kind** — a fixture that gets the species
wrong tests the classifier, not the premise. That distinction is exactly what
`%witness-admissible-under-p` got wrong.

**Construction notes:** build the Slice /2 wrapper over
`(resolve-schema name version)`, never over the registered handle (§7.5-2); choose
`:receiver-accessibility` deliberately in every contract (§7.5-1).

The application prints the complete genealogy with **exact identities, no
ambiguous truncation** — a length-bearing short form, as `de-forma-dormiente`
ships.

---

## 18. EXPLICIT NON-GOALS

a generic algebraic-effect system · a generic command bus · a universal petition
framework · a trusted operator-extension API · a global identity resolver · a
workflow engine · Language Obligation /0 · live capability semantics · external
effects · `PERFORM` · filesystem, process or network access · macroexpansion ·
transformation history · code-valued holes · persistence or replay · a second
implementation of Slice /2 admission.

**The first governed operation is exactly `DERIVE/2`, and no second operation is
designed to demonstrate genericity.** With the operation in the head (§4.1) there
is **no table to add one to.**

---

## 19. STANDING DETERMINATIONS

**19.1 `:by` belongs to the submission act.** Affirmed. Traced through
`slice2.lisp:1609-1612` → `slice1.lisp:1758,1765` → `slice0.lisp:327` (*"a claim
MUST name its asserting principal"*). A form choosing the principal of a governed
claim is certifying, not requesting. Now strengthened: `:BY` **and** `:BY-ID`,
both required, no default (§7.3).

**19.2 The conclusion is a durable reference.** Affirmed. A CD/0 ↔ Slice /1
normal-form translator would be a second representation of a Slice /1 proposition,
owned by Form /1 and free to drift; §9 of the original direction independently
forbids the neighbouring move.

**19.3 No stored diagnostic rendering beside a reference.** Affirmed.
`render-diagnostic` may be called **at print time, from the live resolved
object**; it is never **stored** in a petition, a context or a receipt.

**19.4 Candidate /0 is HOLE-FREE.** *Owner ruling; the previous recommendation
(three phases with reference-holes) is **overruled**.* References already
parameterize through the sealed context; a hole whose value is another reference
is a second indirection with no inhabited use. EG-3 and NC-29 are void.

**19.5 "Through the live rules" means the live rules do it.** Affirmed as ruling
§2D. Form /1 performs no duplicate liveness or admissibility check; `derive/2`
owns both, and consults the Slice /1 registry itself.

---

## 20. ENTRANCE GATES

**EG-1 — Form /0 byte-untouched.** Any executable change spends its stranger
audit (Ruling 3). Hash the subject tree before and after.

**EG-2 — no `lisp-plus-form0::`.** §2.2 determines none is needed. If
implementation discovers otherwise, **stop and report the contradiction.**

**~~EG-3~~ — VOID.** Holes removed (§19.4).

**EG-4 — measure, do not assume.** Print every phase identity length for the
three required petitions (§13). If the maximum-policy terminal identity exceeds
the **65,536-octet envelope** *(amendment 2 — octets of the identity VALUE, not
display characters)*: **stop, report EG-4 FAILED, invent no hash protocol.**
**MEASURED AND SATISFIED:** maximum terminal identity **15,882 octets** across
all three classified outcomes at the largest lawful petition — 4.1× headroom.

**EG-5 — every declared refusal code has a fixture, or is deleted.** Enforced by
NC-32's live set-difference in both directions.

**EG-6 — a stranger audit is OWED for Form /1** and is **not** pre-satisfied by
Form /0's, which binds one subject tree. Successor dependence on Form /0 is
experimental, with its named limitations carried forward verbatim.

---

## 21. PUBLIC API LEDGER

Every proposed external symbol. **No phase-object or receipt constructor is
public. No operator table, handler constructor or caller-supplied procedure is
exported. `PETITION-FORM-DATUM-P` is not exported.**

Legend — **Mint**: can this symbol *create* standing or a phase object?
**Agg**: does it return aggregate/mutable data (and therefore owe a defensive
snapshot)?

### 21.1 Grammar constructors — a program writes a petition by hand

| symbol | category | caller | mint | agg | produced by | why public | test |
|---|---|---|---|---|---|---|---|
| `petition-head-identifier` | constructor | host | no | no | pure | the host must be able to build a lawful head without literal-copying an identifier | NC-1 |
| `schema-reference` | constructor | host | no | no | pure | role-tagged reference construction | NC-6, NC-35 |
| `conclusion-reference` | constructor | host | no | no | pure | " | NC-30 |
| `support-reference` | constructor | host | no | no | pure | " | NC-7, NC-35 |
| `receiver-reference` | constructor | host | no | no | pure | " | NC-8, NC-36 |
| `petition-datum` | constructor | host | **no — builds a DATUM, not a petition** | no | pure | assembling the four-field record correctly is otherwise error-prone | all |

> `petition-datum` returns **a CD/0 datum**. It mints nothing. A datum is not a
> proposal, and this is the exact distinction Form /0's `PROPOSE-FORM` naming
> decision was made to protect.

### 21.2 Phase transitions and their non-signalling twins

| symbol | returns | signals | mint | test |
|---|---|---|---|---|
| `propose-petition` | `PROPOSED-PETITION-FORM` | `PETITION-REFUSED` | phase object | NC-1,3,27 |
| `validate-petition` | `VALIDATED-PETITION-FORM` | `PETITION-REFUSED` | phase object | NC-17 |
| `materialize-petition` | `(values PETITION RECEIPT)` | `PETITION-REFUSED` | petition + receipt | NC-25,26,28 |
| `submit-petition` | `PETITION-SUBMISSION-OUTCOME` | `PETITION-REFUSED`; **escapes** unexpected | outcome + receipt | NC-9,10,16,34 |
| `try-propose-petition` | `(values FORM nil)` / `(values nil REFUSAL)` | — | " | NC-32 |
| `try-validate-petition` | idem | — | " | NC-32 |
| `try-materialize-petition` | idem | — | " | NC-32 |
| `try-submit-petition` | `(values OUTCOME nil)` / `(values nil REFUSAL)` | **escapes** unexpected | " | NC-21,34 |

**`TRY-PROPOSE-PETITION` is the authoritative classifier**, returning an
inspectable reason. No boolean twin is exported (§3.3).

### 21.3 Readers — proposed / validated / validation receipt

| symbol | agg | note |
|---|---|---|
| `proposed-petition-form-p` · `-datum` · `-subject-identity` · `-identity` · `-grammar-identity` · `-grammar-version` | `-datum` returns the immutable CD/0 snapshot | no constructor |
| `validated-petition-form-p` · `-subject-identity` · `-identity` · `-predecessor-identity` · `-grammar-identity` · `-grammar-version` · `-policy-identity` · `-policy-version` · `-budget-id` · `-receipt` | no | no constructor |
| `petition-validation-receipt-p` · `-identity` · `-subject-identity` · `-proposed-identity` · `-grammar-identity` · `-grammar-version` · `-policy-identity` · `-policy-version` · `-budget-id` | no | no constructor |

### 21.4 Readers — petition and materialization receipt

| symbol | agg | note |
|---|---|---|
| `derivation-petition-p` · `-content-identity` · `-occurrence-identity` · `-occurrence-tag` · `-validated-identity` · `-policy-identity` · `-policy-version` | no | no constructor |
| `derivation-petition-schema-reference` · `-conclusion-reference` · `-receiver-reference` | no | immutable CD/0 identifiers |
| `derivation-petition-support-references` | **YES** | **defensive fresh list** — NC-20 |
| `petition-materialization-receipt-p` · `-identity` · `-validated-identity` · `-content-identity` · `-occurrence-identity` · `-policy-identity` · `-policy-version` | no | **not a derivation basis** — NC-13 |

### 21.5 The resolution context

| symbol | category | mint | agg | note |
|---|---|---|---|---|
| `make-derivation-resolution-context` | constructor | context only | no | unsealed |
| `bind-schema-reference` | binder | no | no | checks `slice2-schema-p` |
| `bind-conclusion-reference` | binder | no | no | role-typed, **value-unchecked** (§1.1b) |
| `bind-support-reference` | binder | no | no | **value-untyped deliberately** |
| `bind-receiver-reference` | binder | no | no | `receiver-context-p` **or `NIL`** |
| `seal-resolution-context` | sealer | no | no | requires occurrence id |
| `derivation-resolution-context-p` · `-sealed-p` · `-occurrence-id` | reader | no | no | — |
| `derivation-resolution-context-bound-references` | reader | no | **YES** | fresh role-tagged snapshot; **never the live objects' container** — NC-20 |

**No generic public `BIND-REFERENCE` is exported.**

### 21.6 Submission outcome and receipt

| symbol | agg | note |
|---|---|---|
| `petition-submission-outcome-p` · `-kind` · `-claim` · `-slice2-receipt` · `-derivation-basis` · `-condition` · `-receipt` | no | **transport only**; carries EXACT objects; no constructor |
| `petition-submission-receipt-p` · `-identity` · `-occurrence-identity` · `-petition-occurrence-identity` · `-context-occurrence-id` · `-act-id` · `-by-id` · `-procedure-identity` · `-procedure-version` · `-outcome-kind` | no | no constructor |
| `petition-submission-receipt-context` | no | **image-local anchor** — the exact sealed context object |
| `petition-submission-receipt-by` | no | **image-local anchor** — the exact live `:BY` value |
| `petition-submission-receipt-slice2-receipt-identity-datum` *(amendment 2)* | no | the **complete** Slice /2 identity as CD/0 data — domain and name, via `kernel0:identity->datum`; `NIL` on door refusal. **The old wording, which called a diagnostic key the exact identity, is withdrawn.** |
| `identity-octets`, `render-identity-hex` *(amendment 2)* | no | envelope measurement; DIAGNOSTIC rendering that never enters an identity |
| `petition-policy-max-identity-octets`, `petition-policy-outcome-tail-reserve-octets` *(amendment 2)* | no | the ceilings actually in force |
| `petition-submission-receipt-slice2-condition-class` | no | `NIL` unless a condition was caught |

### 21.7 Refusals

`petition-refusal-p` · `-phase` · `-category` · `-code` · `-path` · `-offending`
· `-reference` · `-expected-role` · `-host-type` · `-detail` · `-identity` ·
`petition-refused` · `petition-refused-refusal` · `petition-refusal-codes`.

`petition-refusal-codes` returns a **fresh list** (agg) and is the input to
NC-32. `-offending` returns the immutable CD/0 datum at datum stage, and `NIL` at
host-object stage where `-host-type` carries the bounded descriptor instead
(§12).

### 21.8 Policy and grammar identity

`petition-grammar-identity` · `petition-grammar-version` ·
`petition-policy-identity` · `petition-policy-version` ·
`petition-policy-max-support-references` ·
`petition-policy-max-canonical-octets` ·
`petition-policy-max-identity-characters`.

Public because a reader of a receipt must be able to learn **which ceilings were
in force** without reading the source.

---

## 22. DOCKET — observed, NOT repaired in this branch

**D-1** a broad `(handler-case … (error () nil))` inside a Slice /2 semantic path
(`slice2.lisp:1539-1540`): a *broken* registry read is indistinguishable from an
*unregistered* schema. **Never read `slice2-schema-error` as proof of absence.**

**D-2** `de-pignore`'s `RUN-TRANSCRIPT-CHECK.txt` has **no generator anywhere in
the repository** — chair-verified by `grep`.

**D-3** Form /0's `:UNKNOWN-PRODUCTION` is overloaded across two distinct
failures. Not repairable (EG-1); not inherited (§11).

**D-4** the *"eleven defects"* memento is directionally right and numerically
overstated: 9 by running, 2 by reading.

---

## 23. WHAT CANDIDATE /0 WOULD EARN — AND WHAT IT WOULD NOT

### Would earn

- An executable demonstration that **a canonical datum can express a request for
  a governed operation without acquiring it.**
- A **second inhabitant** for the sealed-local-resolution pattern, whose only
  prior tenant is Form /0's `form-environment`.
- A demonstrated border between **request, invocation and decision**, with three
  receipt lineages that name each other and inherit nothing.
- **Candidate C**: the governed operation ran, decided against, and nothing was
  minted.
- Self-consistency certification at candidate standing, nothing stronger.

### Would NOT earn

**Adoption** · **a specification freeze** · **any Form /0 standing** (its audit
binds one subject tree) · **a stranger audit** (owed, EG-6) · **process
isolation** or anything against arbitrary Common Lisp already in the image ·
**durability, persistence, cross-image standing, replay or serialization
authenticity** · **global exactly-once submission** · **any claim that a petition
is evidence**, including that a granted petition's receipt is evidence beyond
what the Slice /2 receipt itself carries.

---

## 24. PROVENANCE

Four read-only survey agents mapped the live APIs and **corrected the first draft
in four material places**: the escape set (§7.2a), the context-identity hole
(§6.5), lossless-not-a-digest (§9.0), and architecture A's partial
unbuildability (§3.2). They are **same-family, same-weights** and are cited as
**reports, never as corroboration**.

**Chair-verified directly against the source, not banked from a report:** the
unknown-production path (`form0.lisp:586-593`); `derive/2`'s exits
(`slice2.lisp:1509`, `1531-1554`, `1663-1678`); `receiver-context-p`'s export
(`slice0-projection.lisp:20`); `%require-ground`'s exact content
(`slice1.lisp:424-433`) and `normal-form-p`'s (`slice1.lisp:380-382`); CD/0's
duplicate-key rejection (`cd0.lisp:924-934`); the `de-pignore` generator's
absence; the mirror's main-only guard; and the three baseline floor results.

---

*— Claude Opus 5 (1M context), 2026-07-27, amended under owner ruling. Form /0,
Slice /0, Slice /1, Slice /2, Surface /0, Kernel /0 and CD/0 unmodified; Slice /3
and Language Obligation /0 unopened; no governing floor added; root `_staging/`
untouched; merge forbidden this session.*
