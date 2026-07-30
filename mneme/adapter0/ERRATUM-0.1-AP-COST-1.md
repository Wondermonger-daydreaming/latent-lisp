# Adapter /0 Erratum 0.1 — AP-COST-1 and the ketiv/qere discipline

**Authorized by:** the owner ruling
`mneme/RULING-adapter0-closure-ap-cost-1-vertical0-2026-07-30.md` (Part II),
resolving the spec-erratum candidate filed in `ADAPTER-0-RETURN.md` §3 /
`ARCHITECTURE-0-STATUS.md` Addendum 12 (D-2's class).

**This document is written and committed BEFORE the patch** — the version
ruling below is recorded prior to any production-path change, and the git
ordering of this file's commit against the patch commit is the proof.

## 1. The contradiction, at its exact size

- **AP-COST-1 (adopted, verbatim):** *"Durable monetary amounts MUST use
  Canonical Datum integers or reduced rationals in a declared unit. Binary
  floating-point is forbidden."*
- **Frozen positive fixture `vectors/positive/CST-01.pjs`:** carries
  `amount = "1932912/1000000"` — a **string**, and an **unreduced**
  spelling.
- **Adapter /0 runtime (`extract-cost`, pre-erratum):** emitted the durable
  amount as a string datum `"~a/1000000"` — exact and non-float, but a
  *spelling*, not a Canonical Datum /0 number, and unreduced.

## 2. The resolution — ketiv / qere

The received lexical spelling is **testimony about what arrived** (the
*ketiv*: what was written). The canonical amount is **the value on which
the machine may act** (the *qere*: what is canonically read and enacted).

```text
ketiv — source-lexeme     : "1932912/1000000"   (string, retained unchanged)
qere  — canonical-amount  : 120807/62500        (CD/0 reduced rational)
```

Laws (from the ruling, binding on this patch):

- a fixture amount string is fixture-language syntax;
- the exact original lexeme may be retained unchanged as lexical evidence;
- the durable amount slot must contain an actual Canonical Datum /0
  integer or reduced rational;
- a string does not become durable money merely because its characters
  spell a rational number;
- equivalent rational spellings produce one canonical durable value;
- missing cost is not zero;
- estimated cost is not settled billed cost.

**Frozen CST-01 bytes are preserved exactly.** The fixture's string is
lawful *fixture-language*; the fixture-validation rules (`rules.lisp`)
continue to read it as such. Only the **runtime production path**
(`extract-cost` in `operations.lisp`) and its directly dependent tests
change. AP-COST-1 is not weakened to accommodate the fixture spelling.

## 3. The narrow exact-number parser

`parse-cost-lexeme` accepts ONLY the declared grammar:

```text
lexeme   := ["-"] digits [ "/" digits ]
digits   := one or more of 0-9
constraint: a denominator, when present, must be nonzero
```

No whitespace, no exponents, no decimal points, and none of the Common
Lisp reader: **no read-time evaluation, no floating-point syntax, no
complex numbers, no package syntax, no arbitrary reader macros.** Native
CL rationals are the value substrate (host `/` auto-reduces and collapses
`n/1` to the integer), but the CL reader is never the cost-field grammar.

Refusals: floating-point syntax → `cost-float-noncanonical` (AP-COST-1);
any other malformation (empty, junk characters, missing numerator or
denominator, zero denominator) → `cost-lexeme-noncanonical` (AP-COST-1,
new adapter-local condition in the same §22 cost group).

Canonicalization: reduced host rational → `make-integer-datum` when the
reduced denominator is 1, else `make-rational-datum` (CD/0 normalizes
sign and GCD; the erratum parser feeds it already-validated integers).

## 4. Version ruling (recorded before patching)

Surfaces inspected:

- **Descriptor `adapter-version`** — owned by the frozen reissue fixtures
  (`descriptors/FAKE-ADAPTER-DESCRIPTOR-*.pjs`). **Not moved** (unrelated
  fixture version; the ruling forbids moving it).
- **Grammar / policy / fixture versions** — none touch cost production.
  **Not moved.**
- **The fake cost procedure identity** — callers of `extract-cost` pass
  `"fake-cost-procedure-0"`, and the emitted cost record binds that
  identity as `procedure-id`. The procedure's emitted durable behavior
  **changes type** under this erratum (string amount → source-lexeme +
  canonical-amount datum). This is the behavior-bound version.
  **ADVANCED: `"fake-cost-procedure-0"` → `"fake-cost-procedure-1"`** in
  every directly dependent test and in the erratum gate.
- **Implementation standing** — Adapter /0 now stands as **"Adapter /0
  corrected through Erratum 0.1"**; this document is the version record.

## 5. Executable controls (the erratum gate)

`adapter0-erratum-cost.lisp` (run twice; pair byte-identical) proves:

```text
"1932912/1000000" → canonical-amount 120807/62500 (rational datum)
"100/1000000"     → canonical-amount 1/10000
"2/4" and "1/2"   → the SAME canonical durable value
binary floating-point input refuses (cost-float-noncanonical)
malformed rational syntax refuses (cost-lexeme-noncanonical)
zero denominator refuses (cost-lexeme-noncanonical)
missing cost remains missing (typed marker, not a record)
missing cost is not zero (marker is not a number, carries reason)
estimated cost remains distinct from billed cost
the source lexeme remains available as testimony (byte-equal retention)
arithmetic uses only the canonical amount (sum over canonical values;
  the lexemes are never re-parsed at use time)
equivalent spellings collapse: "4/2" and "2" → one canonical value
  (integer datum), proving the integer/rational seam is canonical
```

Existing gates (selftest, vectors, scripts, joint, l17, controls,
specimen) re-run green after the patch; the cost-check lines in the
selftest/controls transcripts change under the erratum, and the new
transcript digests are recorded in `SEAL-RECORD.md` as an additive
erratum section (the pre-erratum digests remain on record, labeled).

## 6. What this erratum does NOT do

No frozen fixture byte changes · no new monetary type invented · no CD/0
law altered · no AP0 spec text edited (the spec-erratum remains recorded
at the AP0 level as adjudicated by the ruling; this is the Adapter /0
implementation-side resolution) · no audit or separate review arc.

*— Claude Fable 5, chair, 2026-07-30.*
