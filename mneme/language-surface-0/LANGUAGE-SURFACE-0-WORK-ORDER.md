# LANGUAGE SURFACE /0 — WORK ORDER

## Macroexpansion as the Honest Compiler

*Owner-issued 2026-07-25. Continues from Language Slice /2 Candidate /1, which
is **accepted for continuation** — `[IX-10]` closed within its declared
current-image, non-cryptographic ceiling.*

```
status:                        owner-issued work order
implementation-authorized:     yes
specification-frozen:          no
semantic delta below surface:  none claimed
adoption record:               NOT to be written
stranger audit:                OWED — not a gate for constructing Surface /0
```

**Not to be done:** open Slice /3 · freeze or adopt Candidate /1 · commission
the stranger audit · produce another paper-only design movement before
implementation. **The implementation is the design specimen.**

---

## 1. Purpose

Let an ordinary Lisp+ program declare judgment schemas, admission contracts and
Slice /2 schemas, and handle derivation outcomes, **without manually assembling
every underlying constructor call**.

Syntax and compilation only. **No new judgment, admission, provenance,
accessibility, effect or authority semantics.**

## 2. The governing surface law

> **Surface syntax may remove repetition. It may not remove the place where a
> standing-relevant choice is made.**

So the following stay explicit in source: schema identity and version · contract
identity and version · every premise position · every accepted support clause ·
proposition relation · receiver-accessibility requirement · retention
requirements · truth ceilings · `derive` vs `derive/2` · grant vs typed refusal ·
claim vs source basis vs derivation basis.

**No authority-bearing default may be inferred** from a name, package, procedure
identity, predicate, variable name or nearby declaration.

## 3. The five forms, and no ergonomic aliases

`define-judgment-schema` · `define-admission-contract` · `define-slice2-schema` ·
`derive-case` · `derive/2-case`

A reader must be able to run `macroexpand-1` and see the governing substrate:
the existing public constructors, the existing registry operation, the existing
`derive`/`derive/2` call, the existing typed refusal, and ordinary Common Lisp
bindings and control flow. **Macroexpansion is the compiler in this movement.**

No reader macro, custom readtable, parser, interpreter, evaluator,
source-to-source string processor, hidden policy engine or second runtime. **The
direct constructor API remains public and fully usable.**

## 4. What must not be sugared

`perform` · `establish-core0-source-basis` · `derive` · `derive/2` — their names
stay visible at the point where the program performs them.

No `with-authority`, `prove`, `verify`, `establish`, `trust`, `settle`,
`do-judgment`, `action`, or any generic form collapsing the two-door
architecture. No macro that automatically performs an effect, mints a witness,
raises a claim, establishes a source basis, obtains a derivation basis, supplies
all support identities to a receiver context, retries a refused derivation, or
turns a receipt into a truth value.

**No receiver-context convenience macro** — automatically adding every offered
support identity would erase a live semantic refusal while presenting itself as
ergonomics. Whether a safe recurring form is needed belongs to a later candidate.

## 5. Surface syntax refusal

Malformed macro syntax must not fail as an accidental host error (`CAR of NIL`,
malformed property list, odd keyword arguments). One typed family,
`surface-syntax-refused`, with readers for the complete source form, a stable
reason keyword, and the offending field — distinguishing at least
`:missing-field` · `:duplicate-field` · `:unknown-field` · `:malformed-clause` ·
`:wrong-operation`.

**It governs malformed surface grammar only.** A syntactically valid declaration
naming a semantically unknown contract version or support clause must reach the
**existing Slice /2 refusal**, not be reclassified as surface damage.

## 6. Expansion discipline

Public symbols only · no `::` escape · no `eval`, `compile`, `read-from-string`
or runtime source parsing · no hidden package mutation or interning · every
caller expression evaluated **exactly once** · source evaluation order preserved ·
no caller-variable capture · no generated binding leaking into receipts or
identities · works under `compile-file` + `load`, not only interactive `eval` ·
no new authority-bearing runtime object species · the schema registry's duplicate
behaviour unchanged · the direct constructor surface still available.

## 7. Verification

**Differential semantic testing.** Every declarative macro gets a direct-API
twin, compared **only through public observations** — and *not* by `EQ` where the
public contract does not promise it. Six scenarios must agree on both paths: an
ordinary Slice /1 derivation · a Slice /2 source-basis derivation · a downstream
derivation-basis-only premise · refusal by naked claim · refusal by
inaccessibility · a refuted premise.

**Twenty-six focused controls**, plus two planted faults: the contract macro
silently adding `(:verified-judged-claim)`, and a derivation control form
supplying all offered support identities as accessible. Both must be shown to
**fire**, both files restored, and **restoration verified by hash**.

Assert typed conditions, receipt fields, dispositions and reader observations.
**Never settle for "it failed."**

## 8. Movement XII

`de-bibliotheca-peregrina` gains one movement, **Movements I–XI byte-identical**,
using Surface /0 declarations for one finite continuation of the existing chain:
a schema, a version-1 derivation-basis contract, an indexed attachment, a visible
`derive/2` through `derive/2-case`, an already-established derivation basis
consumed, one modest explicit application judgment, the new claim/receipt/third
value retained, the prior receipt shown reachable, the modest ceiling rendered,
and **no courier script, adapter outcome, Core /0 event or source relation
altered**.

Plus one compact `macroexpand-1` specimen beside it. **No vanity line-count
comparison.** The point is inhabitability: *can the source now be read as a Lisp+
program while every consequential operation and every standing-relevant choice
remains visible?*

## 9. Floor and discipline

Surface /0 becomes a **distinct floor**; the language floor moves from 10 to 11.
Existing lower-floor counts must remain unchanged. Focused suites during
construction; the complete floor **once** after they are green.

**One implementation hand. No helper agents.** An isolated clone with no
publishing remote while unfinished. The live tree is not touched until the
focused checks are green, both planted faults have fired, restoration hashes
match, and Movement XII is green.

---

*Received against lab `f47ab98e` · baseline 10 floors / 609 checks / 0 failed ·
SBCL 2.4.6 operation-checked through the wrapper.*

*Standing caps carried: self-consistency, not corroboration. Every account is a
labelled scripted fake adapter, never evidence that an external deed occurred.
The stranger audit remains OWED, against this work order too.*

— **Claude Opus 5 (1M context)**, 2026-07-25
