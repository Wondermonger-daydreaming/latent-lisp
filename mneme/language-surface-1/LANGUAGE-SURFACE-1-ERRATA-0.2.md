# LANGUAGE SURFACE /1 — CANDIDATE /0 — ERRATA 0.2

> ### ⚠ SUPERSEDED IN PART BY ERRATA 0.3 — §2's CLASSIFICATION IS FALSE
>
> The 2026-07-28 stranger audit refuted this document's central classification.
> **§2 claims that "decode is injective for every admissible datum, so NO PUBLIC
> INPUT CAN REACH the round-trip mismatch — the earlier, more precise guard
> always fires first."** All three parts are false:
>
> - **Public input reaches it**, by two mechanisms using only standard Common
>   Lisp: `RENAME-PACKAGE` between the doors while retaining the old name as a
>   nickname, and a **package-local nickname in the caller's ambient `*PACKAGE*`
>   at Door 2**, which requires no mutation of anything at all.
> - **The earlier guard does not fire first** in either case — it passes, because
>   it compares package *objects* while what drifted was the package's *name*.
> - **Decode is not injective** on the data it accepted: identifiers carrying
>   surplus segments decoded to the same symbol as their one-segment
>   counterparts. Errata 0.3 refuses those data; the claim was false when made.
>
> The argument proved the wrong property. The gate does not test injectivity; it
> tests whether decode is a **section** of encode, and that fails whenever a
> namespace's package designation is non-canonical *at decode time* — which
> Common Lisp permits both across time and across dynamic context.
>
> **What survives, and it is the substance of §2:** the round-trip gate itself
> was right, it fires before macroexpansion, it mints nothing, and it is what
> prevents a false source→expansion edge. The stranger audit vindicated the
> mechanism while refuting the classification. Nothing below is deleted; see
> `LANGUAGE-SURFACE-1-ERRATA-0.3.md` and the audit return.
>
> §7's numbers (75 exports, 115/8/24 checks, grammar v3 · procedure v3) describe
> the tree as of this erratum and are correct **for that tree**; the current
> tree is Errata 0.3 and reports different figures.

*A narrow owner-supplied **pre-audit follow-up** against **Errata 0.1** at
`4f5c5982`. Three surgical corrections, not another cathedral of procedure.*

**NOT A STRANGER AUDIT.** The report came from the owner; the repair was made by
the family that wrote the layer. **The independent audit remains OWED**, against
the target this erratum produces.

```
subject             4f5c5982 (Errata 0.1) · preserved in history and on the mirror
findings reported   3   (a semantic false-edge route + two evidence-harness defects)
CONFIRMED           4 of 4 verdicts, by execution, before any patch
REFUTED after       4 of 4, by the SAME instrument
standing            errata candidate · not audited · not adopted · not frozen
                    · on no governing floor
```

---

## 1. THE IMPORTANT ONE — `FIND-SYMBOL` RECONSTRUCTED THE WRONG SYMBOL

**CONFIRMED, and it is a second false edge, one layer down from the first.**

Errata 0.1 made the canonical datum the single authority and had Door 2
reconstruct a fresh host form from it. The reconstruction resolved symbols like
this:

```lisp
(multiple-value-bind (symbol status) (find-symbol symbol-name package)
  (unless status (error ... :symbol-absent-in-image ...))
  symbol)
```

> **`FIND-SYMBOL` ANSWERS ACCESSIBILITY. THE GRAMMAR RECORDS HOME-PACKAGE
> IDENTITY.** Those are different questions, and Errata 0.1 asked the wrong one.

### Reproduced

Package `Q` exports `X`. Package `P` uses `Q` and **shadows** `X` with its own
`P`-owned symbol. A specimen is encoded naming `P::X`; between the doors, `P`'s
own `X` is uninterned.

```
(find-symbol "X" P) before . #<PACKAGE "PROBE-P"> / status :INTERNAL
(find-symbol "X" P) after .. PROBE-Q            / status :INHERITED

DECODE-TERM reconstructed a form whose bound variable is:
  symbol PROBE-Q:X · home package PROBE-Q
  is it Q's symbol? T

encode-term(decode-term(stored)) == stored ... NIL

AND IT REACHED DOOR 2: a receipt was minted.
  receipt source datum == stored ......... T
  but the form expanded bound ............ (DEFPARAMETER PROBE-Q:X …)
```

**The stored source datum names `P/X`; the form handed to the macroexpander bound
`Q:X`; and a receipt was minted saying the first produced the expansion of the
second.** N7 and N7b missed it because their temporary packages inherit from
nothing — they tested *absence*, never *substitution*.

### The repair

```lisp
(unless (and (member status '(:internal :external))
             (eq (symbol-package symbol) package))
  (error '%term-irreconstructible :reason :symbol-not-home-in-namespace ...))
```

**Both conjuncts are load-bearing and neither implies the other:**

- the **status** test alone misses an **imported** symbol, which is `:INTERNAL`
  in the importing package while its home package is elsewhere — measured:
  `(find-symbol "Y" P2)` returns status `:INTERNAL` with home package `Q2`;
- the **home** test alone would admit `:INHERITED` in the degenerate case.

*A finding my own probe raised and I then had to withdraw:* an **imported symbol
has no hole on the encode side**, because `ENCODE-TERM` writes
`(package-name (symbol-package s))` — the **home** package. Measured (**O3b**).
So the reachable question is a **datum whose namespace names a package where the
symbol is only accessible**, and no encode path produces such a datum. It is
built by hand in the probe and in check **O3**, because a test that cannot be
reached by construction has to be reached by construction.

---

## 2. THE ROUND TRIP IS NOW AN EXECUTED GATE

**CONFIRMED.** N5 asserted `encode(decode(d)) == d` for ordinary specimens. The
runtime did not enforce it, and the inherited-symbol substitution walked straight
through the gap.

> **A test asserting that a gate exists is not the same creature as the gate
> existing.** This lane has learned that before; it learned it again here.

`%RECONSTRUCT-SOURCE` now re-encodes the reconstruction and requires exact CD/0
equality with the stored datum **before anything reaches the macroexpander**. A
mismatch is `:SOURCE-NOT-RECONSTRUCTIBLE` with upstream `ROUND-TRIP-MISMATCH`;
a reconstruction that will not re-encode at all is `ROUND-TRIP-NOT-ENCODABLE`.

**And the honest classification, which matters more than the gate:**

> With the home-package guard in place, **decode is injective for every
> admissible datum, so NO PUBLIC INPUT CAN REACH the round-trip mismatch** — the
> earlier, more precise guard always fires first. The gate is **defence in
> depth**, and a gate that has never fired is untested, not passing.

So it is proved live by **planted fault** (`*%fault-decode-substitution*`,
internal, checks **O4/O4b**), and **O5** asserts the ordering — that the symbol
guard fires and the round-trip guard does not. The ceiling was not lowered and no
fixture was invented to make the gate theatrically reachable.

---

## 3. THE REGRESSION RUNNER WAS FAIL-OPEN

**CONFIRMED by simulation.** The runner recorded `REPRO_RAN=$?` and then omitted
it from the success condition:

```bash
SELFTEST_EXIT=0 STUB_EXIT=0 APP_EXIT=0 REPRO_RAN=9 REPRO_CONFIRMED=0
→ WRAPPER SAYS: PASS
```

**A reproduction that crashed before printing anything scored zero `CONFIRMED`
lines and the wrapper reported peace in the kingdom.** Counting zero of a string
is not evidence that the string was ever going to be printed.

Each instrument now emits **one canonical machine-readable line**:

```
REPRODUCTION-RESULT verdicts=6 expected=6 confirmed=0
REPRODUCTION-RESULT verdicts=4 expected=4 confirmed=0
```

and the wrapper requires the **exact** line plus `exit 0` from each instrument.
A truncated run, a renamed label, an early exit and a crash now all fail closed —
verified by re-running the same simulation, which now reports `FAILS CLOSED`.

---

## 4. THE TRANSCRIPT IDENTIFIED ITSELF AS THE WRONG SUBJECT

**CONFIRMED.** The instrument's banner was hard-coded:

```lisp
(format t "SBCL ~A · candidate 2e21f367, unpatched~%" ...)
```

so the AFTER capture — taken against the repaired tree — announced itself as the
unpatched candidate. **In a layer devoted to truthful accounts, the evidence had
wandered onstage wearing the subject's nametag.**

Both instruments now derive their header and assert nothing:

```
subject     <argv[2], or the tree's git short SHA, or "working tree">
directory   <resolved truename of the candidate under test>
SBCL 2.4.6 · grammar vN · procedure vN · policy vN
```

The two captures now distinguish themselves by content, not by filename:
Errata 0.1 reports `grammar v2 · procedure v2`; this tree reports `v3 · v3`.

**Path drift, also corrected.** The captures live at
`errata-0.1/pre-errata-evidence/` and `errata-0.2/pre-errata-evidence/` in the
repository; the Errata 0.1 *parcel* carried them under `evidence/reproduction/`.
The parcel layout now mirrors the repository, and the runner banner prints both
paths.

---

## 5. IDENTITY-VERSION ADJUDICATION, EXPLICITLY

```
grammar   2 -> 3
procedure 2 -> 3
policy    1        unchanged — no ceiling moved
```

**Procedure**, plainly: the reconstruction procedure changed again. It now
enforces the round trip before expanding, and it rejects inputs its predecessor
accepted. A procedure that rejects what it used to accept is a different
procedure.

**Grammar — and this is the ruling the report asked for.** `DECODE-TERM` **is**
part of the declared term grammar, and this erratum is what makes that explicit.
The grammar is the **correspondence** between host forms and canonical data, not
merely the encoding direction. Errata 0.2 narrows the decode relation: a datum
whose namespace names a package where the symbol is only *accessible* no longer
decodes at all. **The set of `(datum → form)` pairs the grammar sanctions is
strictly smaller**, so the grammar version moves.

The alternative reading — that the grammar is the encode direction only, and
`DECODE-TERM` is procedure — was available and is rejected, because under it the
round-trip law would be a property of *no* declared artifact: encode would not
own it, and a procedure version could change without the correspondence being
said to have changed. **A law needs an owner.** The grammar owns it.

**Every identity this layer mints therefore differs again from Errata 0.1's.**
That is correct: they are accounts of a different correspondence and a different
procedure.

---

## 6. WHAT THIS ERRATUM DID NOT DO

- **No stranger audit.** Owed, against this target.
- **No new feature. No Surface /0 modification. Form /3 and Surface /2 unopened.**
- **No adoption, no freeze, no governing floor.**
- **No DAG representation and no alpha-normalization.** Still the two named next
  representation laws.
- **No claim of completeness.** Three findings reported, four verdicts confirmed,
  four refuted by the same instrument. **A statement about four verdicts, not
  about the layer.** Errata 0.1 also refuted six and this report still found more.

---

## 7. THE NUMBERS

```
surface1-selftest           115 checks / 0 failed · exit 0   (0.1 was 107)
stub-image-fixture            8 checks / 0 failed · exit 0   (unchanged)
de-expansione-testata        24 checks / 0 failed · exit 0   (unchanged)
reproduction I                verdicts=6 expected=6 confirmed=0
reproduction II               verdicts=4 expected=4 confirmed=0
                            ───
                            147 checks / 0 failed

public exports               75 declared == 75 live   (unchanged; the new fault
                                                       hook is internal)
refusal catalogue            20 entries · 17 protocol · 3 alarms (unchanged —
                             the new reasons ride an existing code as UPSTREAM
                             values, which is what upstream preservation is for)
grammar version              2 -> 3        procedure version  2 -> 3
policy version               1  unchanged
```

**Before and after, one instrument, two subjects:**

```
REPRODUCTION-II vs 4f5c5982 (Errata 0.1)   grammar v2 · procedure v2   4 of 4 CONFIRMED
REPRODUCTION-II vs this tree               grammar v3 · procedure v3   0 of 4 CONFIRMED
```

Predecessor floors after the erratum: **form floor 199/0, language floor 654/0,
identical to the pre-session baseline; `verify-all` 6/6.** `git diff` across
CD/0, Slice /1, Slice /2, Surface /0 and Form /0/1/2 is **empty**.

---

## 8. FOR THE STRANGER

This target is the one to freeze. Two things the auditor should be told plainly,
because they are the shape of what has happened twice now:

1. **Both errata were found by an outside, and both were found in the repair of
   the previous one.** Errata 0.1 fixed a false edge and introduced the
   conditions for a second. The layer has never yet survived a reading it did not
   already fail.
2. **Every green in this tree was still graded by the hand that wrote it.** The
   proof obligations, the fault hooks, the canonical result lines — all of them
   were designed by the same author whose work they check. That is exactly the
   thing an independent audit is for, and it is exactly the thing this document
   cannot supply.

---

*— Claude Opus 5 (1M context), 2026-07-28. SBCL 2.4.6 operation-checked through
the wrapper. Subject `4f5c5982`, preserved. Standing: errata candidate,
**not audited, not adopted, not frozen, on no governing floor.***
