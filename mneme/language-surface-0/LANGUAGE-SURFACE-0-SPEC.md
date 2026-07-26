# LANGUAGE SURFACE /0 — SPECIFICATION

## Macroexpansion as the Honest Compiler

```
status:                        candidate implementation
specification-frozen:          no
semantic delta below surface:  NONE CLAIMED
stranger audit:                OWED
```

---

## 1. What this layer is

A small, explicit Common Lisp macro layer over the **existing public APIs** of
Slice /1 and Slice /2. `macroexpand-1` shows the governing substrate: the same
public constructors, the same registry operation, the same `derive` or
`derive/2` call, the same typed refusal, and ordinary Common Lisp bindings and
control flow.

There is no reader macro, custom readtable, parser, interpreter, evaluator,
source-to-source string processor, hidden policy engine or second runtime. **The
direct constructor API remains public and fully usable** — Surface /0 adds a way
to say the same thing, never a different thing to say.

## 2. The boundary law

> **Surface syntax may remove repetition. It may not remove the place where a
> standing-relevant choice is made.**

Applied, this is why every declaration form below has **no optional fields at
all**. The Slice /2 contract constructor defaults `:proposition-relation`,
`:receiver-accessibility` and `:retain`; Surface /0 refuses to inherit those
defaults, because a contract is precisely the object whose purpose is to say what
a premise will accept, and a contract with an unwritten acceptance rule is the
thing this layer exists to prevent. Likewise `:locals` and `:unique-locals` must
be written even when empty — uniqueness-bearing locals are standing-relevant
(`CHARTER-DELTA-2`), so `:unique-locals ()` is a sentence the author has to say
out loud.

## 3. Syntax versus expression, stated per form

The work order requires no state in which a reader cannot tell whether a subform
is syntax or a runtime expression. The answer here is uniform in two of the three
declaration forms and explicit in the third.

| form | rule |
|---|---|
| `define-judgment-schema` | **every field is literal syntax.** Nothing is evaluated. |
| `define-admission-contract` | **every field is literal syntax.** Nothing is evaluated. |
| `define-slice2-schema` | `:schema-id`, `:schema-version` and each **premise index** are literal; `:base-schema` and each **contract** are ordinary expressions, evaluated once, in written order. |

The third mixes because it must: a base schema and a contract are *objects*
produced by the first two forms, and the whole point of attaching them is to name
the variables holding them. Quoting those would make the form useless. Leaving
the **indices** unquoted would let a premise position be computed — which is
exactly the attachment-by-inference the boundary law forbids.

A program needing a computed schema or contract uses the direct constructor API.

## 4. The five forms

### `define-judgment-schema`

Expands to an ordinary top-level binding, construction through
`lisp-plus-slice1:judgment-schema`, and registration through
`lisp-plus-slice1:register-schema` — all three visible under `macroexpand-1`.

It does **not** clear the registry, replace a registration silently, or weaken
duplicate detection to make reloading idempotent. Reloading hits Slice /1's
existing duplicate behaviour unchanged, because that behaviour is a
standing-relevant choice this layer has no licence to soften.

### `define-admission-contract`

**The macro translates nothing.** It does not add `(:verified-judged-claim)`, add
`(:source-basis …)`, add `(:derivation-basis)`, select a source relation, invent
a truth ceiling, or upgrade a derivation-basis ceiling to a source-basis ceiling.
The clause list reaches the public constructor **as written**, so an unknown
version or an unknown clause reaches the *existing governed refusal* rather than
being pre-normalized into something acceptable.

### `define-slice2-schema`

**Attachment is by written index and nothing else** — not by list position alone,
proposition predicate, contract name, schema name, matching variable names, a
package convention, or a wildcard. Missing, duplicate and out-of-range
attachments reach Slice /2's existing typed refusals. Surface /0 may catch a
malformed *shape* earlier; it never turns a governed semantic refusal into a
successful construction.

### `derive-case` and `derive/2-case`

Each wraps **one visibly written public call**, checked at macroexpansion time to
be the expected operator (`:wrong-operation` otherwise — a control form named for
one operation that quietly wraps another is a lie in the source).

The operation form is placed into the expansion **verbatim**, never decomposed
and re-emitted. That is what makes *"evaluated exactly once, in source order"*
**structurally true** rather than a promise a test must keep re-checking — and
planted fault B below is the demonstration: decomposing the form to rewrite one
argument broke the evaluate-once and source-order controls *as a side effect*.

**Only the governed derivation-refusal type is caught.** Never `error`, never
`serious-condition`, never `condition`. An unexpected host error escapes — a
surface that swallowed a real bug as a refusal would be lying about the language.
Nothing is retried; no support is added, removed or reordered; no condition
becomes `nil` or a boolean; the selected arm's values are the form's values.

**Scope is deliberately asymmetric:**

```
:granted   the result variables are bound to the EXACT returned objects
:refused   the condition variable and the RECEIPT are bound;
           the claim (and derivation basis) are NOT IN SCOPE AT ALL
```

A refusal has no claim and no basis. Binding them to `nil` would invite
`(when claim …)` to read as a decision when it is really a shrug; leaving them
unbound makes the mistake a compile-time unbound variable instead.

## 5. Surface grammar refusal

`surface-syntax-refused`, with readers for the complete form, a stable reason
keyword and the offending field. Reasons: `:missing-field` · `:duplicate-field` ·
`:unknown-field` · `:malformed-clause` · `:wrong-operation`.

**It never absorbs a semantic refusal.** A syntactically valid declaration naming
an unknown contract version or an unknown support clause passes through untouched
and is refused by Slice /2, with Slice /2's own typed condition and message.
Controls SC8–SC12 assert exactly that boundary.

## 6. What is deliberately not sugared

`perform` · `establish-core0-source-basis` · `derive` · `derive/2` keep their
names at the point where the program performs them. Those are the verbs where
the program does something consequential, and they should clang when struck.

**No receiver-context convenience form exists**, and its absence is a decision,
not an omission: automatically supplying every offered support identity would
erase a live semantic refusal while presenting itself as ergonomics. Planted
fault B does precisely that, and control SC17 catches it.

## 7. What Surface /0 does not do

No change to Kernel /0 · Slice /0 · Slice /1 · Slice /2 Candidate /1 · Core /0 ·
Core /0 issuance · source-basis or derivation-basis establishment · receiver
accessibility · refutation · ambiguity · claim or receipt identity · truth
ceilings · the two-door `perform`/`derive` boundary.

No custom reader, evaluator, parser, generic proof language, proof graph,
automatic evidence search, implicit support promotion, hidden defaults,
cross-image standing, serialization authenticity or cryptographic standing.

**Surface /0 is a transparent front end over the current language kernel, and
claims no semantic delta below itself.**

---

*Standing caps: self-consistency, not corroboration — one model family wrote the
language, the applications and these checks. Every account is a labelled scripted
fake adapter, never evidence that an external deed occurred. The stranger audit
remains OWED.*

— **Claude Opus 5 (1M context)**, 2026-07-25
