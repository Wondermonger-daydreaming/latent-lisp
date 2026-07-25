# CHARTER DELTA /3 — the unsupported-support residue ruling (owner-adopted)

> **⚠ EXTENDED BY `CHARTER-DELTA-4.md` (2026-07-25).** Delta /3's three **recognized
> species** (Slice /0 witness · Slice /1 refutation · Slice /0 claim) are
> **unchanged** — Delta /4 admits no new species and creates no new residue class.
> What it changes is how ONE recognized species is *classified within* premise
> assessment: a witness declaring `:polarity :refutes` is **refuting evidence**, not
> positive support. It is still a recognized witness, still classified **exactly
> once**, and is **never** unsupported residue. `:supports` handling and the
> receipt-level `unsupported-supports` record are untouched.

*2026-07-25. Owner ruling, verbatim law adopted; this delta licenses the
substrate revision that implements it. Scope: **this repair only.** It repairs
**R-SUPPORT-1**, docketed in `de-bibliotheca-peregrina/FIELD-REPORT.md` §9.3 and
deliberately left unrepaired there pending owner authorisation.*

## The defect

An object explicitly supplied in `derive`'s `:supports` that was neither a
Slice /0 witness, a Slice /1 refutation, nor a Slice /0 claim fell through all
three filters and was **silently discarded**. Through every public receipt
reader, supplying such an object was **indistinguishable from supplying
nothing** — while a *claim* that failed to discharge was at least recorded.

Chair-reproduced, one one-premise schema, verbatim:

```
core0-evidence supplied  → premise :MISSING, no witness residue, no claim roster
                           entry, no receipt indication anything was supplied
nothing supplied         → the IDENTICAL public account
self-minted claim        → :MISSING but roster=1   ← a failed CLAIM is RECORDED
```

**This delta makes unsupported supply VISIBLE. It does NOT make the object
admissible evidence.**

## The adopted ruling

```lisp
(:slice-1-unsupported-support-residue
 :classification :exactly-once
 :recognized-species (:witness :refutation :judged-claim)
 :unsupported :record-at-derivation-receipt
 :entry-shape (:index nonnegative-integer
               :reason :unsupported-support-species)
 :index-base 0
 :entry-order :caller-input-order
 :duplicates :preserve
 :retain-raw-object nil
 :decision-effect :none
 :new-premise-disposition nil
 :public-reader derivation-receipt-unsupported-supports)
```

## Governing law (executable reading)

1. Once an invocation reaches the **existing** assessed-derivation threshold,
   **every** element of `:supports` is classified **exactly once**.
2. The **recognized species** are unchanged: Slice /0 witness · Slice /1
   refutation · Slice /0 claim (judged or unjudged).
3. Any other element is **unsupported residue**.
4. Unsupported residue **cannot** discharge a premise, refute a premise, bind a
   variable, create or resolve ambiguity, or authorize a grant; it is **not**
   silently converted into `:missing`; and it **is recorded at the
   derivation-receipt level.**
5. Each entry is canonical inert data —
   `(:index N :reason :unsupported-support-species)` — with `N` the
   **zero-based** position of the element in the caller's own `:supports` list.
6. **Input order and duplicates are preserved.** The receipt records what the
   caller supplied, not a set. **Diagnostic only; it must not affect decisions.**
7. **The raw object is NOT retained.** Not the object, not its `TYPE-OF`, not
   its printed representation, not its `SXHASH`, not an address-like identity,
   not implementation class metadata, not a host pointer. An arbitrary host
   object may be mutable, circular, unreadable, noncanonical or
   identity-bearing; Slice /1 must not pretend to durably snapshot one.
8. **The exact ceiling:** *the receipt proves an unsupported value was supplied,
   where it appeared, and that it had no semantic effect. It does not preserve
   or identify arbitrary unsupported host data after the call.*
9. Residue does **not** force refusal. Decisions remain determined by the
   recognized species alone:

   | supplied | outcome |
   |---|---|
   | recognized support alone | the existing decision |
   | recognized support + unsupported | the **same** decision, residue additionally recorded |
   | unsupported alone | premise remains `:MISSING` (the closed six-disposition vocabulary), but the receipt differs **observably** from supplying nothing |

10. **No seventh premise disposition.**
11. **No new condition family.**
12. Existing **pre-assessment** exits are unchanged. A call that does not reach
    the current receipt threshold does **not** acquire a fictional receipt
    merely because `:supports` held an unsupported value — and the
    post-threshold `unbound-conclusion-variable` receipt, which is issued
    *before* `:supports` is classified at all, carries **no** residue field it
    did not earn.
13. This ruling does **not**: make Core /0 evidence admissible · bind a witness
    to a real attempt · validate `witness-procedure`/`witness-content` · close
    the `:direct` door · change promotion admissibility · repair non-witness
    `raise` · create an identity resolver · open Slice /2.

## Public surface

Exactly **one** new exported symbol:

```lisp
derivation-receipt-unsupported-supports
```

`NIL` when there is no residue; otherwise a proper list, e.g.

```lisp
((:index 0 :reason :unsupported-support-species)
 (:index 3 :reason :unsupported-support-species))
```

The receipt slot is **read-only**; **no** public constructor is added; **no**
raw object is stored; the reader returns a **defensive structural copy**, so
mutating a returned list or any plist inside it cannot revise the stored
receipt. Two reads are structurally `EQUAL` and need not be `EQ`.

Residue belongs to the **invocation-level derivation receipt, not to any premise
assessment** — an unrecognized object cannot be meaningfully matched against an
individual premise, so attributing it to one would be an invention.

## Implementation consequence

The three independent `remove-if-not` filters in `derive` (witnesses,
refutations, claims) — whose union was a **proper subset** of `:supports` — are
replaced by **one** classification step, `%classify-supports`, returning four
values. Exactly-once is *provable*, not assumed: `witness`, `claim` and
`refutation` are three `defstruct`s with no `:include`, three sibling structure
classes directly under `structure-object`, so the predicates are pairwise
disjoint and the `cond`'s order is not a silent precedence rule. Caller-relative
order within the three recognized buckets is exactly what the filters produced.

`render-derivation-why` reports receipt-level residue on **granted and refused**
receipts alike, from the stored field only. The **structured reader, not the
prose, is authoritative.**

## What is superseded

- `LANGUAGE-SLICE-1-CHARTER.md` and `LANGUAGE-SLICE-1-API.md` wherever they
  describe `:supports` handling without naming the residue.
- `SLICE1-ERRATUM-1.md`'s docket entry **R-SUPPORT-1** — repaired here. **The
  erratum's own cycle is CLOSED and is not reopened**; this is a supersession
  banner, not a new cycle.

## What is NOT superseded

`CHARTER-DELTA-1` and `CHARTER-DELTA-2` stand entire. The six premise
dispositions stand. The direct-witness ceiling stands exactly as adjudicated in
`FIELD-REPORT.md` §9.1. The effect frontier (§9.2, `R-EFFECT-2`) **remains
blocked**: a Core /0 effect account is now *visible* when supplied and is still
*inadmissible*. **Slice /2 is not opened.**

*— adopted by the owner; implemented by ADSCRIPTA, Claude Opus 5 (1M context)*
