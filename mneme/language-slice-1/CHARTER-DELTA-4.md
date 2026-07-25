# CHARTER DELTA /4 — witness direction, and grounding identity

**Status:** `owner-adopted`
**Date:** 2026-07-25
**Scope:** witness direction (R-POLARITY-1) + grounding identity (R-GROUNDING-NAME-1)
**Slice /2:** unopened
**Governs:** `slice1.lisp`, `slice1-selftest.lisp`, and every document describing them.

Two rulings, each **narrow**. The first forbids one specific inversion. The second
corrects one specific **name**. Neither opens a new question, and neither may be
read as larger than it is.

---

## Δ4.1 — R-POLARITY-1: polarity is load-bearing direction

**PROSPECTIVE, NOT RETROACTIVE.** `witness-polarity` appears in **no** Slice /1
governing document prior to this delta. The Slice /1 charter had not settled it.
This ruling assigns it meaning **from adoption onward** and makes no claim about
what any earlier document intended.

### The defect

A matching, receiver-accessible Slice /0 witness declaring `:polarity :refutes`
was pushed onto the **positive matching-support roster**, discharged the premise it
contradicted, and granted. Beside a supporting witness the positive count read
**2**. That is not an omission — it is an **inversion**: explicit counter-evidence
tallied on the positive side of the ledger.

The pre-cure gate read exactly two things about a witness: its
`witness-for` proposition (via the proposition-match gate) and
`%support-accessible-p`. Direction was never consulted.

### The semantics, from adoption onward

| condition | result |
|---|---|
| matching + accessible + `:supports` | candidate positive support |
| matching + accessible + `:refutes` | **REFUTING EVIDENCE** |
| matching + **INACCESSIBLE** | `:INACCESSIBLE`, regardless of polarity |
| proposition **MISMATCH** | `:MISMATCHED`, regardless of polarity |

A `:refutes` witness **never** discharges a positive premise, appears as positive
corroboration, increases the positive matching-support count, or is represented as
though its declared direction were `:supports`. It contributes **no** binding
environment: it does not extend the assessment environment set and never reaches
the receipt's `complete-binding-environments`.

**Precedence** follows the behaviour the language already demonstrated for the
refutation species:

```
supporting witness + Slice /1 refutation object     → :REFUTED   (existing)
∴ supporting witness + accessible matching :refutes → :REFUTED   (adopted here)
```

Direction is classified **before** positive matching support is accumulated.
Enforced in code at `%witness-refutes-p`, the single predicate the gate consults —
isolated so a tooth can blind it and restore the defect exactly.

### Representation

`premise-assessment-refuting-supports` is **unchanged**: its published contract is
homogeneous (*"refutations naming this premise"*), and `%repair-for` reads
`refutation-id` off its elements, so widening it would break a live caller **and**
silently change a public reader's value species — the same defect class as Δ4.2.
The second species gets the smallest parallel reader:

```
(premise-assessment-refuting-witnesses ASSESSMENT)  ; ONE new export
```

A premise is `:REFUTED` on the **UNION** of the two rosters. The decision
procedure, `%repair-for`, and `render-derivation-why` all consult the union. Repair
advice for a premise refuted only by refutation objects is **byte-identical** to
its pre-delta form; a refuting witness adds
`:withdraw-or-answer-refuting-witness`. The rendering names such a witness as
counter-evidence and never as support.

The six dispositions of charter §5 stand. **No new condition family. No new premise
disposition. No seventh status.** A refuting witness is a **recognized species**,
classified once — never unsupported residue (CHARTER-DELTA-1 Δ2.4, Δ2.7:
counter-evidence and coexisting positive support both remain visible).

### THE CEILING — what this ruling does NOT do

It **does not solve P-3** and must not pretend to. It creates **no premise-source
contract**. It makes **none** of these into admission gates: `mode`, `kind`,
`source`, `procedure`, `content`, `transmissible`, `accessible-to`. Receiver-context
`accessible-supports` remains the **sole** Slice /1 accessibility rule. It binds no
assertion to any real observation or effect — a witness declaring `:supports` over a
fabricated account still discharges, exactly as before, and
`de-codice-restaurando` `[VII-i]` continues to say so. `admissible` **remains
undefined** as a general source contract. **It forbids one specific inversion and
nothing more.**

```lisp
(:slice-1-witness-polarity-direction
 :supports :candidate-positive-support
 :refutes :refuting-evidence
 :matching-accessible-refutes-may-discharge-positive nil
 :mixed-support-and-refute :refuted
 :accessibility :receiver-context
 :mode-kind-source-procedure-content-admission :unchanged)
```

---

## Δ4.2 — R-GROUNDING-NAME-1: Decision 2 names complete environments

Sol's **Decision 2 substance stands**: every distinct complete binding environment
is preserved, canonically ordered, deduplicated only when complete canonical
encodings are byte-identical. **The word `ground-instances` is corrected as a NAME,
not as substance.** This is naming/API clarification — **not** a collapse of the
complete set.

### The collision

The object stored under `ground-instances` is a **conclusion-projected premise
instance**: the premise pattern with the bindings available **on entry to that
premise** substituted — conclusion bindings, plus any schema-local already bound by
an **earlier** premise — with schema-locals *this* premise binds left as
**variables**. Deduplicated on byte-identical canonical encodings.

That is **not** a complete binding environment, and its cardinality is **not** the
number of them. A premise binding a schema-local projects that local as a variable,
so several complete environments differing only in it **collapse to one
projection**. Measured, on a one-premise schema with three supports differing only
in the local:

```
complete-binding-environments  3
binding-environments           3
projected-premise-instances    1      ← the local is still (:VAR :TAG)
ambiguities                    0
```

**The name promised axis 2 and delivered axis 1.** Two live readers stood under it,
and one of them — the singular projection — **answers** in exactly this case,
looking for all the world like evidence of singular grounding while three complete
environments stand in the receipt.

### The correction

The **normative complete set is the COMPLETE BINDING ENVIRONMENT set**, read at
`premise-assessment-binding-environments` (per premise) and
`derivation-receipt-complete-binding-environments` (across premises). Decision 2's
ordering and dedup law applies to **that** set; the implementation already preserved
it, unchanged.

A precise public name is added as an **alias over the existing projection
implementation** — same value, same shape, same copy behaviour:

```
(premise-assessment-projected-premise-instances ASSESSMENT)  ; ONE new export
```

The legacy readers stay **operational and unchanged in return shape**, documented as
**legacy projection readers**:

- `premise-assessment-ground-instances` — legacy plural projection reader.
- `premise-assessment-ground-instance` — legacy **singular** projection reader.

**No symmetric receipt-level alias is added:** no public receipt-level
ground-instance reader exists, so the condition for one is not met.

They are **not repurposed** to return complete environments — that would silently
change the value species of a live public API. They are **not removed**. **No
representative complete environment is ever selected, by any rule whatsoever.**

### THREE INDEPENDENT AXES

1. **projected-premise multiplicity** — `projected-premise-instances` (legacy:
   `ground-instances`).
2. **complete-environment plurality** — `binding-environments` /
   `complete-binding-environments`. **NORMATIVE.**
3. **ambiguity** — `ambiguities` / `uniqueness-conflicts`, from declared
   `:unique-locals`.

None is a bound on another, in either direction. **(1) may read 1 while (2) reads 3.
(1) may read 3 on a later premise of the same receipt.** Declaring a local unique
moves **only** (3).

**The singular projection reader does not protect complete-environment plurality.**
It answers whenever the *projection* is singular, which is the ordinary case for a
premise that binds a schema-local. Its refusal above cardinality one guards the
**projection's** cardinality only — and that refusal is **reachable in ordinary
use**, on any premise entered with a schema-local already bound (the existing tooth
`T30e` fires it, and `T32-G4b` shows one receipt where the reader **answers** on
premise 1 and **refuses** on premise 2 while the environment plurality is the same
for both).

```lisp
(:slice-1-grounding-identity
 :normative-complete-set :complete-binding-environments
 :projection :conclusion-projected-premise-instances
 :legacy-ground-instances :compatibility-alias
 :legacy-singular :projection-only
 :arbitrary-complete-environment-selection :forbidden)
```

---

## Teeth

Both clusters are planted-and-caught, not merely asserted green:

- **T-POLARITY** — blinds `%witness-refutes-p` to `nil`, restoring the pre-delta
  gate verbatim. The polarity cluster fails: case B grants and reads `:satisfied`
  with the refuting witness counted as positive support; case C's positive count
  inflates to 2. Restored, green.
- **T-GROUND-NAME** — makes the new projection reader return complete
  environments. The grounding cluster fails: `T32-G4`'s legacy-equals-precise
  identity breaks, and `T32-G2`'s projected count reads 3 instead of 1. Restored,
  green.

## What is NOT touched

Slice /2 stays unopened. No premise-source admission. Slice /0 `:admits` is not
imported into Slice /1. No effect-account validation; the effect frontier remains
blocked. Witnesses are not bound to attempts. Procedure and content are not
inspected for discharge. Receiver-context accessibility is unchanged. `transmissible`
and witness `accessible-to` receive no Slice /1 meaning. No global identity
resolution. R-SUPPORT-1 residue behaviour, judged-claim chaining, and
complete-environment canonical ordering are all unchanged.

## Self-consistency cap

One model family wrote this language, its tests, and the commission that ordered
these two repairs. Nothing in this delta or its teeth is independent verification of
anything, and no conformance is claimed.
