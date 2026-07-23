# DE-PROMOTIONE — banked disposition (append-only)

**This file refines; it does not replace.** The specimen's original blunt
disposition (EXPECTED-FAILURES.md §4, commit `6ae3c6f7`) is preserved
verbatim as history:

```lisp
;; original, 2026-07-22 (commit 6ae3c6f7) — preserved, not retracted
(:slice-0-disposition
 :result :library-layer
 :language-claim :not-yet-earned)
```

## Refined multidimensional receipt (2026-07-23)

The original was honest but underspecified — it compressed several earned
and unearned things into one axis. The banked reading:

```lisp
(:slice-0-disposition
 :semantic-model :validated
 :public-surface :embedded-language-kernel
 :governed-language-act :earned
 :host-level-enforcement :not-earned
 :standalone-language-claim :not-yet-earned
 :escape-surface :common-lisp-package-internals)
```

**Governing interpretation.** Slice /0 has implemented a real governed
language act — checked evidential promotion — inside Common Lisp. Its public
surface distinguishes execution, testimony, proposition identity,
procedure-relative judgment, immutable assertion history, structured
refusal, and lawful repair. These guarantees hold within the governed Lisp+
surface. Arbitrary host-level access through Common Lisp internals can
bypass them, so host-closed and standalone-language claims remain unearned.

Common Lisp can host embedded languages — that is what it is for. What the
ablation measured is that the **current escape boundary is too cheap and
insufficiently visible** (one `::`, indistinguishable output objects, no
audit trace beyond empty `:support-ids`) for any stronger enforcement claim.
Host bypass is **not** evidence that the semantic act does not exist; it is
evidence about where the act's enforcement perimeter currently sits.

## Banked semantic findings

### DPM-1 — No scalar standing ladder
The test-runner sequence did **not** become
`:launched < :exited < :parsed < :passed < :verified`. Those became distinct
propositions, events, supports, and judgments. Verification is not a higher
grade of execution; it is a procedure-relative judgment about a proposition
under suitable support. (Charter §2; specimen throughout; resolves
INVENTORY-0 M3 without minting a fourth vocabulary.)

### DPM-2 — Checked promotion is a governed act
`raise` is not public slot mutation. It creates a promotion attempt,
considers proposition-sensitive support, returns a receipt on **every**
attempt, and either grants or refuses the requested judgment. (T5a/T5b:
mutation unavailable; T7a: refused attempt still receipted.)

### DPM-3 — Assertion history survives judgment
A claim's original assertion remains present when later evidence refutes it
or a verification request fails. Refutation does not revisionistically erase
assertion. (T8/T8b: residue carries `:original-commitment :asserted`
alongside `:current-judgment :refuted`; lineage names the asserted
original.)

### DPM-4 — Testimony preserves proposition level
Evidence that speaker S asserted P supports the second-order attribution
"S asserted P"; it does not automatically become direct support for P.
**Construction-time unrepresentability of flattened testimony is accepted as
stronger than raise-time refusal**, conditional on the lawful second-order
form staying ergonomic (it is one `witness` form — see SPECIMEN T1b, and the
ergonomics checks added under this banking pass, T2c).

### DPM-5 — Proposition surface is provisionally atomic
Slice /0 currently accepts only the proposition forms the canonical boundary
supports as established by execution: keywords, strings, integers, and
proper lists thereof.

> This is a temporary public-surface restriction. The semantic domain of
> propositions is canonical structured data; Slice /0 does not claim that
> propositions are inherently atomic.

Host symbols are **refused, never silently stringified** (the first draft
stringified; the CD/0 execution evidence forced the refusal — commit
`c714bc60`).

### DPM-6 — Kernel0 supplies a negative law, Lisp+ supplies the act
Kernel0 already prevents structural procedures from licensing semantic
acceptance or rejection (K0E-25). Slice /0's contribution is making that law
programmer-facing: `raise` · typed refusal · receipts · `why` · constrained
restarts. (T4 is the law surfacing one level up.)

### DPM-7 — Public enforcement is not host closure
The ablation's single `::` demonstrates that Common Lisp package privacy is
an explicit but inexpensive escape route. The exact boundary:

> The governed public surface enforces the semantics. Arbitrary same-image
> host access does not.

This is not a cryptographic, process-isolation, or hostile-custody result,
and must not be cited as one.

— Claude Fable 5 (CC seat), 2026-07-23
