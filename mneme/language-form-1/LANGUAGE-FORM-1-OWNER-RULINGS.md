# LANGUAGE FORM /1 — OWNER RULINGS

*Filed 2026-07-27 under the owner ruling
`FREEZE AND PACKAGE LANGUAGE FORM /1 FOR STRANGER AUDIT`.*

**THIS IS A DOCUMENTATION-ONLY ARTIFACT.** The commit that files it changes no
`.lisp`, `.asd`, `.sh`, runner, census, transcript, policy constant, package
export or test. It records **decisions**, not measurements. Every number it
cites was produced by the same family that wrote the layer, and is
**interested-party testimony** until a stranger derives it independently.

```
branch            language-form-1-candidate-0
reviewed tip      3630552a          (Review 1 / policy v3)
policy            v3
grammar           v1
adopted           no
specification-frozen   no
merged            no
published         no
same-family self-consistency   green
stranger audit    OWED
```

**Review 1 is accepted. No further same-family semantic repair round is
authorised.** The exact subject tree produced by the commit filing this document
becomes the stranger-audit target.

**Visible history, not to be amended or rebased:**

```
e5ffe68c    blocked policy v1
295f9fba    completed policy v2
7db2da94    FANG correction
3630552a    Review 1 / policy v3
```

---

## RULING A — NO FIFTH DECLARATION-SIZE CEILING

**Candidate /0 does NOT add `MAX-DECLARATION-OCTETS`.** Review 1 measured the
absence and referred the question; the owner has answered it.

The reasoning, recorded so that a stranger can attack the reasoning and not only
the outcome:

- a binding operation constructs an **unsealed candidate context**;
- the complete declaration mapping becomes **semantically consequential at
  `SEAL-RESOLUTION-CONTEXT`**, not at any individual binder;
- **sealing already applies the identity envelope** before any governed
  operation can be reached with that context;
- **submission applies the complete occurrence-plus-tail envelope again**, before
  `DERIVE/2`;
- a **per-binding or per-declaration ceiling would not prove an aggregate
  bound** — n admissible declarations can compose past an envelope that each of
  them individually clears, so the per-item gate would be a gate that looks
  complete and is not;
- **no governed act can occur with a context that failed sealing.**

**The named limitation stands, at its true size and no larger.** A host learns
its declarations are too large at `SEAL`, after every binder has already
accepted them. That is an **ergonomic and policy limitation** — late feedback —
and it is **NOT a semantic-accounting defect**, because no governed act has
occurred at that point and none can.

*The distinction the stranger is asked to hold apart (see the commission, B17):
**late ergonomic feedback at seal** is not the same failure as **post-governed-
act accounting failure.** Only the second would be a defect of this layer.*

---

## RULING B — RETAIN THE 65,536-OCTET IDENTITY ENVELOPE

**Retain, unchanged, and do not move either value before stranger review:**

```
PETITION-POLICY-MAX-IDENTITY-OCTETS          65536
PETITION-POLICY-OUTCOME-TAIL-RESERVE-OCTETS   4096
```

**THE INTERPRETATION IS CLARIFIED, AND THE CLARIFICATION CORRECTS A READING
REVIEW 1 INVITED.**

```
65,536 is an ADMISSION ENVELOPE, not a promise of large unused headroom.
```

**A maximum-accepted fixture naturally approaches the envelope.** Review 1
reported the worst-case margin moving from 4.13× to 1.08× and declined to call
it generous — correctly. But *"the margin is no longer generous"* frames headroom
as the property under test. It is not. An envelope that a maximum-accepted input
approaches is an envelope doing its job; an envelope with 4× slack at the
maximum admitted input is merely a looser one.

**The load-bearing facts, which are about ORDERING and TOTALITY rather than
about margin:**

- **all policy refusals occur before `DERIVE/2` invocation;**
- **the submission occurrence plus reserved tail must fit before invocation;**
- **every classified outcome receipt is total after invocation** — there is no
  gate, ceiling or refusal path in the receipt construction;
- **the measured maximum outcome tail remains far below the reserve**
  (172 measured against 4,096 reserved).

**The stranger is invited to seek a counterexample** — specifically an
admissible context that passes seal, passes submission preflight, invokes
`DERIVE/2`, and then cannot construct its classified receipt within the
envelope. **Any such witness is a semantic accounting defect**, and it is the
single most valuable thing the audit could return on this axis.

---

## RULING C — RETAIN `:RECEIVER-ABSENCE-DECLARATION-MISAPPLIED`

**Retained.** Review 1 added this one step past the ruling's letter and flagged
it for removal if unwanted. It stays.

The retained rule is bidirectional:

```
NIL receiver anchor            ->  the package-owned receiver-absence declaration
live non-NIL receiver anchor   ->  any lawful declaration OTHER than that marker
```

**Why it is legitimate where a general declaration check would not be.** This
refusal **enforces a contradiction Form /1 can directly observe**: it quantifies
over exactly its own two arguments — the anchor is `NIL` or it is not, and the
declaration is the sanctioned marker or it is not — and decides nothing about
the world. It **does not certify arbitrary host declarations**, and no ruling
here should be read as moving toward that. The honesty clause is untouched:

> the declaration records what the trusted host asserts about the live anchor;
> Form /1 does not independently certify that assertion.

---

## RULING D — PREDECESSOR DOCKETS REMAIN OUTSIDE THIS BRANCH

**Recorded. NOT repaired. Not repairable in this branch.**

1. **`SLICE2:DERIVATION-BASIS-REFUSED`** — exported and handler-visible, with
   **zero measured signal sites** anywhere in the layer. A host may write a
   handler for it and that handler is dead code.

2. **The nine severe broad `(ERROR () NIL)` sites** listed by the Review 1 lint:
   `kernel0/boundary.lisp:84` · `core0.lisp:887` · `core0.lisp:935` ·
   `core0.lisp:947` · `slice1.lisp:382` · `slice2.lisp:634` · `slice2.lisp:809` ·
   `slice2.lisp:1540` · `lci0/common-lisp/migration.lisp:169`.
   Eight of the nine were never docketed anywhere before Review 1.

**These are predecessor or repository-surface matters. They are NOT Form /1
Review 1 modifications, and this branch does not touch them.**

**What the stranger MAY do with them:** test whether any *reachable* predecessor
handler affects the **Form /1 submission path** — i.e. whether a broad handler
one layer down converts an unexpected implementation failure into an ordinary
semantic result that Form /1 then records as a classified outcome. That would be
a finding about Form /1's accounting even though the handler is not Form /1's
code. A predecessor handler that no Form /1 path can reach is a
**predecessor-layer observation** and must be classified as one.

---

## RULING E — AUDIT STANDING

```
candidate implementation
adopted:                        no
specification-frozen:           no
merged:                         no
published:                      no
same-family self-consistency:   green
stranger audit:                 OWED
```

**Form /0's stranger audit does not pre-satisfy this one.** It bound one exact
subject tree and no other.

**The exact subject tree produced by the commit filing this document is the
audit target.** The audit's preregistration and commission are **external packet
documents and are deliberately NOT committed into this tree** — a prereg a
subject can read is not a prereg, and the target tree is the subject.

---

## WHAT THESE RULINGS DO NOT DECIDE

Stated because a rulings document is exactly the kind of artifact that acquires
authority it was never granted.

- **They do not adopt, freeze, merge or publish anything.**
- **They do not certify any figure in `LANGUAGE-FORM-1-RETURN.md`.** Every count
  in that document was derived by the family that wrote the layer. The audit
  exists because same-weights agreement measures the corpus attractor and not
  the fact of the matter.
- **They do not settle Ruling A or Ruling B against a counterexample** — they
  settle them against *this* review's evidence, and both are explicitly offered
  to the stranger as targets.
- **They confer no repair, merge, adoption or freeze authority on the auditor.**

---

## POINTER — ADDED AFTER THE AUDIT (link only)

The stranger audit commissioned above was run against the exact subject tree
this document's filing commit produced. **Its intake — and the standing record
that supersedes the `stranger audit: OWED` line above — is filed at:**

```
audits/2026-07-27-grok-4.5/LANGUAGE-FORM-1-STRANGER-AUDIT-INTAKE.md
```

*Nothing above this heading was edited. The pre-audit standing block is left as
written, because it was true when written and a rulings document that quietly
updates itself is worth less than one that dates its own claims.*

---

*Filed by Claude Opus 5 (1M context) at the owner's direction, 2026-07-27.
Documentation only: no executable artifact in this tree changed in the commit
that files it.*
