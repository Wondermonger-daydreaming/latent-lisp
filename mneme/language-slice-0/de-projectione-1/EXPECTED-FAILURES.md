# DE-PROJECTIONE Session 1 — expected failures, comparison, disposition

Companion to `SPECIMEN.lisp` (17/17), `BASELINE.lisp`, `ABLATION.lisp`;
grounds in `RUN-RECEIPT.txt`.

## 1. What the specimen catches (and how)

| Check | Distinction | Mechanism |
|---|---|---|
| P1/P1b | source judgment not copied | receiver's claim carries NO judgment unless the receiver's **own** `raise` grants one; a granted receiver judgment is a fresh record, never `eq` the source's |
| P2 | source context stays real | receipt records source context, source licensing `(:verified "suite-verification")`, and what was transmitted |
| P3a/P3b | testimony level survives travel | the attribution claim verifies AS attribution at the partner; P itself gains nothing (`:proposition-mismatch` blocker) |
| P4 | warrant/proposition matching | accessible+recognized warrant for Q excluded by name; matching warrant still licenses |
| P5a/P5b/P5c | redaction requires derivation | underived public form → `:underived-redaction` blocker (teeth); derived form verifies as the derivative; the private warrant crosses only as a named `:mute` ceiling |
| P6/P6b | inaccessible ≠ absent | inaccessible supports held in the receipt + `supports-lost` with reasons; exportable ones become `(:export id)` obligations |
| P7a/P7b | authority is contextual | blocker carries `:in-context :stranger`; the same claim grants at the recognizing position — blocked-here, not impossible-everywhere |
| P8 | muteness is local | the non-reifiable object raises a ceiling **about itself**, while the receiver's own locally minted equivalent check verifies the proposition |
| P9 | consequences compose | one projection: views `(:regraded :redacted :obligation-producing :ceiling-bound)` — no single-symbol collapse |
| P10 | source immutable | all source claims byte-identical in standing after every projection |

## 2. Ablation expectations — confirmed

Copy-the-judgment restores every laundering silently: client and stranger
both "hold" `:verified` labeled `:preserved`, 0 blockers, 0 receipts, no
inaccessible residue — and the copied judgment names a licensing procedure
the receiver cannot run. Travel no longer changes anything.

## 3. The six WORK-ORDER-0 questions, against the baseline

**Both versions express** the whole domain: positions, stores, redaction,
recomputed standing — the baseline's good-faith `project-claim` is genuinely
receiver-relative. **Easier misleading act in CL:** all six drift moves are
one line each (`copy-claim` carrying `:verified`; `(setf (claim-holder ...))`;
a hash write laundering testimony; a warrant-id keyword copy; a
`remove-if-not` that leaves no trace of the lost; a single-symbol return).
**Where Lisp+ rejects/exposes:** the receiver's judgment can only arrive via
the receiver's own `raise` (no public path writes a judgment); every
projection returns a receipt in which loss, blockage, ceiling, and obligation
are *represented*; the flat-label collapse is replaced by composable views.
**Lawful repair:** obligations name the export that would repair (P6b);
attribution claims give testimony a lawful target; local minting repairs
muteness (P8). **Ceremony:** ~one `receiver-context` per position and one
`project-claim` per travel — the receipt is free. **Library
reproducibility:** yes — constructively, as with de-promotione; the
substrate is portable CL and the ablation again needed internals access.

## 4. Questions recorded for de-infando (not begun — Task 10)

This specimen attached non-transmissibility to the **support object**
(`witness :transmissible nil`) and that sufficed for locality-of-muteness.
Open for de-infando: whether non-transmissibility must also attach to
(a) the proposition (sensitivity traveled here as a redaction argument, not
a property); (b) the procedure (may a receiver be barred from *running* a
procedure it possesses?); (c) a capability object distinct from evidence;
(d) the resulting value (a verified claim as non-exportable value);
(e) combinations. And the framing constraint from the banked de-promotione
disposition: de-infando's question is whether Lisp+ makes host escape
**explicit, auditable, and outside ordinary well-formed programs** — not
whether same-image code becomes metaphysically powerless.

## 5. Disposition (multidimensional; the binary is not supported)

```lisp
(:de-projectione-1-disposition
 :reconstruction-semantics :validated
 :receipt-composition :validated          ; views compose, no scalar collapse
 :inaccessible-residue :represented
 :testimony-level-across-travel :preserved
 :governed-language-act :earned           ; projection as checked reconstruction
 :host-level-enforcement :not-earned      ; same :: escape as de-promotione
 :standalone-language-claim :not-yet-earned
 :escape-surface :common-lisp-package-internals)
```

**The lane's question was: does the refusal survive travel?** Within the
governed surface — yes: what arrives at a receiver is exactly what that
position's supports, authorities, and procedures license, the losses are
receipted, and the composed consequences cannot be flattened to one symbol.
Outside the governed surface the same one-`::` escape stands, unchanged and
now twice measured.

— Claude Fable 5 (CC seat), 2026-07-23
