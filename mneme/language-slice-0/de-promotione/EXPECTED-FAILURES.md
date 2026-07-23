# DE-PROMOTIONE — expected failures, comparison, and disposition

Specimen packet member (WORK-ORDER-0 §144). Companion to `SPECIMEN.lisp`
(18/18 checks), `BASELINE.lisp`, `ABLATION.lisp`; verdict grounds in
`RUN-RECEIPT.txt`.

## 1. The failures the specimen must catch — and does

| # | Attempted act | Condition signaled | The named missing relation | Repair demonstrated |
|---|---|---|---|---|
| T1 | testimony witness FOR P itself (flattened) | `malformed-slice0-shape`, requirement `:testimony-preserves-proposition-level` | testimony's `:for` must be `(:asserted S P)` | construct the attribution form (shown inline) |
| T2 | raise P on attribution testimony | `wrong-proposition-support` | witness is for `(:asserted :colleague P)`, not P | `why`'s `strongest-lawful-result` offers the attribution claim; T7c takes it |
| T3 | raise `(:tests-passed :suite-a)` on the exit-status warrant | `wrong-proposition-support`, requirement `:witness-for-must-equal-claim-proposition` | witness is for `(:exited :run-1 0)`, not `(:tests-passed :suite-a)` — a warrant for Q cannot promote P | T7a/T7b |
| T4 | `:verified` requested from a `:structural` procedure | `inadmissible-procedure`, requirement `:semantic-judgment-requires-semantic-procedure` | judgment-class wall (kernel0 K0E-25, one level up) | retain / defer |
| T5 | direct standing mutation | constructor rejects `:judgment`; no `(setf claim-judgment)` exists (read-only slot) | — unavailable, not refused | — |
| T8 | `:verified` requested where all admissible support refutes | `unsupported-promotion`; receipt residue `(:original-commitment :asserted :requested-judgment :verified :decision :refused :current-judgment :refuted)` | supports must not all refute; assertion history preserved | raise `:to :refuted` grants (T8b), lineage intact |

Restarts demonstrated (T7a–d): `retain-current-claim`,
`seek-matching-support` (the refused raise then **grants** on the supplied
matching witness), `construct-attribution-claim`, `defer-judgment`.
`continue-anyway` / blind `retry` are not expressible (`with-slice0-restarts`
refuses unlawful clause names at macroexpansion — teeth-checked in T0c).

## 2. Ablation expectations — confirmed

`ABLATION.lisp` alters ONE mechanism: checked `raise` → ordinary constructor
keyword (`claim*` with `:judgment`). Confirmed by run: all four launderings
succeed **silently** (exit-status→release-verified, testimony→verified,
unmatched-suite→verified, structural-procedure-stamped), 0 conditions, 0
receipts, and the ablated claim is indistinguishable by public accessors
from a lawfully raised one (empty `:support-ids` / nil `:lineage` are the
only forensic trace, and nothing checks them). The property is destroyed by
that one change — the hypothesis's load lands where claimed.

## 3. The six WORK-ORDER-0 questions, against the baseline

**What can both versions express?** Everything in the domain: both keep the
seven facts separate, both implement the honest conjunction, both reach a
truthful `:verified` for the good run. Expressiveness is not the difference.

**What misleading act is easier in ordinary CL?** `(when (zerop exit-code)
(setf (release-status claim) :verified))` — one idiomatic, silent, reviewer-
invisible line (baseline moves i–iii). The baseline's own words: *"the SETF
that lies is byte-for-byte the same construct as the SETF that tells the
truth."*

**Where does Lisp+ reject or expose it?** Exit-status→verified is refused
with the exact missing relation named (T3/T6); testimony→verified is
**unrepresentable** at construction (T1); the mutation path does not exist
on the public surface (T5); the structural-authority shortcut is refused
(T4). Every attempt leaves a receipt.

**What lawful repair becomes available?** Four restarts (T7a–d), including
the honest counter-offer: *say the thing your evidence actually supports*
(the attribution claim).

**How much ceremony does Lisp+ impose?** The lawful pipeline is ~20 lines
for three verified claims: one `claim`/`witness`/`raise` per fact, receipts
free. Roughly 2× the baseline's disciplined path in line count, and each
added form carries semantic content (procedure, mode, kind). Intelligibility
held (specimen's lawful-pipeline section reads top-to-bottom).

**Can a disciplined library reproduce the same semantic property?**
**Yes — constructively proven: `slice0.lisp` *is* one.** It is portable
Common Lisp using defstruct read-only slots, unexported internals, checked
constructor functions, typed conditions, and a whitelist macro. Every
property the specimen demonstrates is achieved by those ordinary library
means. The ablation measures the real boundary: laundering required exactly
one `::` — the protection is CL package discipline, which the baseline's
closing commentary correctly calls *"a shrug, not a wall."* Lisp+'s surface
is a **better-shaped** library (the refusal names relations; the receipt
survives failure; testimony is unrepresentable-flattened), but nothing here
is a property a disciplined CL library could not host, because it is hosted
in one.

## 4. Disposition

```lisp
(:slice-0-disposition
 :result :library-layer
 :language-claim :not-yet-earned)
```

All six acceptance-threshold clauses hold **at the public-surface trust
boundary** — but the final admission question resolves against the language
claim, on constructive evidence. What Slice /0 has earned: a validated
**semantic design** (separated categories with no scalar ladder;
construction-enforced testimony level; promotion as checked relation;
receipts that survive refusal; structure-derived explanation; a closed
lawful-repair set) whose refusals and repairs behaved exactly as chartered,
under teeth-checked gates.

Where the language claim would get a real test: a property CL library
discipline *cannot* self-host — values unavailable through any governed
surface (de-infando's ceiling), or a reader/loader that refuses programs
before evaluation. The `::`-width gap this specimen measured is precisely
the gap de-infando exists to interrogate.

— Claude Fable 5 (CC seat), 2026-07-22
