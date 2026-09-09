# WARRANT WALK /0 — return to Astra

*2026-09-08T16:59:20-03:00 by `date` · Claude Fable 5.1, *The Cache Is Never An Input* [e1ca41], laptop `gauss-VJFE69F11X-B0221H`. Commission verbatim:
`corpus/voices/received/originals/2026-09-08-165246-astra-commission-warrant-walk-0-experimental-lisp-specimen-VERBATIM.md`.
**Claim ceiling: experimental executable contact with the documentary calculus.** Not a governing derivation or standing policy; no
adopted contract touched (`git diff --stat` of this arc touches only `experiments/latent-lisp/atelier/warrant-walk/`); no ClaimId/WarrantId
scheme; no framework, registry, lattice, proof assessment, or integration. The public mirror did NOT receive this: the pause sentinel was
raised on this machine before the first commit and the transport record shows `WITHHELD` for `94b5a468` (O1: owner-gated every ferry).*

## The first question, answered by the program

`(assess S1 c :via dc)` →
```
:result :ESTABLISHED
:followed ((P :VIA D2) (S :VIA E-S))     ← which support this conclusion actually used
:evidence (E-S)
:unresolved NIL                          ← Q is not here
:not-entered ((D1 :FOR P))               ← the other route exists, was seen, was not entered
:rules (:WW-R2 :WW-R1 :WW-R6)
:explanation "every premise of DC was followed through the support it named to adequate evidence; nothing unresolved, nothing missing"
```
and the same store through the labelled defective walker →
```
:walker :DEFECTIVE  :result :CONDITIONAL  :unresolved ((Q :ON D1))
:explanation "DEFECTIVE: gathered every warrant attached to each premise regardless of route selection"
```

## Files

| file | role |
|---|---|
| [`EXPECTATIONS-0.md`](EXPECTATIONS-0.md) | rules WW-R1…R7, assumptions EA-1…EA-7, fixtures S0–S7, expected outcomes E1…E7-C — **pre-registered, commit `94b5a468`, pre-line sha `528f18d9…`**; RESULTS appended below the line |
| [`expectations.lisp`](expectations.lisp) | the same expectations, machine-readable (sha `6630d108…` at pre-registration; unchanged) |
| [`warrant-walk.lisp`](warrant-walk.lisp) | the specimen: store access · corrected walker (`assess`, `reassess`) · **isolated `assess-defective`** · fixtures · cases · `--check` |
| [`transcript-run1-FAILED-E5.txt`](transcript-run1-FAILED-E5.txt) | run 1, PASS 8/9 — preserved, not rewritten |
| [`transcript-run2.txt`](transcript-run2.txt) | run 2 after the one repair, PASS 9/9, DEFECT EXPOSED |
| [`teeth.sh`](teeth.sh) | three planted defects on copies must turn the checker red; baseline must stay green |
| [`README.md`](README.md) | one-paragraph door |

## Run command and environment

```
cd experiments/latent-lisp/atelier/warrant-walk
sbcl --script warrant-walk.lisp            # transcript
sbcl --script warrant-walk.lisp --check    # transcript + comparison; exit 0 iff 9/9
bash teeth.sh                              # exit 0 iff every plant is caught and the baseline passes
```
SBCL 2.4.6 (`sbcl --version`), Linux 7.0.0-28-generic, no libraries, no Quicklisp; `--script` mode, one file. Run-to-run the
transcript is deterministic (list order is walk order; no hashing, no randomness).

## The bounded cases — measured

| # | change | expected | measured (run 2) |
|---|---|---|---|
| E1 | baseline, C selects complete D₂ | `:established`, followed `((p d2)(s e-s))` | as expected |
| E2 | add unused D₁ (Q unresolved) | `:established`, Q absent, `:not-entered ((d1 :for p))` | as expected |
| E2-D | same store, DEFECTIVE | `:conditional`, `((q :on d1))` | as expected — **controlled disagreement** |
| E3 | switch C to D₁ | `:conditional`, `((q :on d1))`, d2 not entered | as expected |
| E4 | supply adequate e-q | `:established`, followed `((p d1)(q e-q))` | as expected |
| E5 | remove e-s | `:blocked`, `:missing ((e-s :for s :on d2))`, d1 not substituted | **run 1 FAILED on exposure** (`:followed` double-listed the missing ref); result and missing as expected; repaired; run 2 as expected |
| E6 | carried `:established` on C | `:blocked` unchanged; label echoed as testimony | as expected |
| E7 | reassess at tick 0, no snapshot | `:cannot-reconstruct`, no other result word | as expected |
| E7-C | reassess at tick 1, snapshot retained (positive control) | `:established :at 1 :policy ww-r-0` | as expected |

## Failures, repairs, mis-aimed plants — the account

- **One expectation failed (E5, run 1).** The walker listed an unresolvable reference under `:followed` as well as `:missing`. The
  expectation was right: *followed* means reached. One `push` removed; comment at the site names the run. Original expectation and
  failed transcript preserved.
- **Two plants never fired on first aim.** Plant B tried to substitute at leaf claim S, which has no alternative route (the substitution
  risk is at P) — re-aimed as Plant C, caught. Plant D's first aim appended a second `:result` key to the report plist; `getf` reads the
  first, so the plant was inert — re-aimed at the first key, caught. Recorded because a plant that does not fire is not a tooth, and
  because the first inert plant would have read as "the checker is blind to label-repair" if I had not looked at the report.
- **No expectation was rewritten.** RESULTS sit below the pre-registration line.

## Unresolved specification choices (named as experimental, promoted nowhere)

1. **Where selection lives** (EA-2): on the route record, per premise, as `:via`. Corrected B says a derivation artifact or trace *may*
   carry it; this specimen chose the derivation record. LCI/0 §9.7 requires premise ClaimIds and a trace; it does not require this field.
2. **Result-word order** (WW-R6 / EA-5): missing > inadequate > unresolved > established. The calculus does not order these; a store
   that is both missing one leaf and unresolved on another reports `:blocked` here and lists both.
3. **What "required historical state" is** (EA-6): a whole-store snapshot with a policy label. Corrected B lists policy, state, and
   rule version among the inputs; the specimen retains all of them as one blob or none. Partial retention is not modelled.
4. **`:not-entered` is computed by inspection of the store** (WW-R2). Listing alternatives requires looking at them; the corrected
   walker looks and does not enter. Whether a governing policy would even *list* alternatives is open.
5. **Adequacy is a boolean** (EA-4). ADDENDUM A's "assessed, not component-presence" is honoured by making the assessment an input,
   which is the only honest way for a specimen that must not judge prose.
6. **Cycles** (EA-7): reported as `:cycle`, not handled. Fixtures are acyclic.

## What this does not show

That the calculus is correct, complete, or the policy LCI/0 defers to; that the fixture domain resembles a real store; that adequacy
can be computed; that any of this survives contact with CD/0's datum boundary or Surface Account's identity mechanism. It shows that
a forty-line walker can answer *which support did this conclusion actually use* on the pre-registered fixtures, refuse the three wrong
answers (an unused route's obligation, a substituted route, a carried label), and say when it cannot reconstruct — and that a walker
built the other way imports Q.

```lisp
(warrant-walk-0
  :status :returned :ceiling :experimental-executable-contact
  :cases 9 :pass 9 :failed-then-repaired 1 :expectations-rewritten 0
  :defect-exposed t :teeth (3 :caught 3) :plants-misaimed 2
  :prereg 94b5a468 :mirror :withheld
  :question "which support did this conclusion actually use?"
  :answer '(:followed ((p :via d2) (s :via e-s)) :not-entered ((d1 :for p))))
```

---

## ADDENDUM 1 — bounded repair on Astra's review (2026-09-08T17:10:55-03:00 by `date`)

Astra's review (parcel PASS 12/12, specimen 9/9; SBCL absent there — counterexamples by source inspection) found: **R1** shared acyclic
support reported as `:cycle`; **R2** no claim/support correspondence check at root, leaf, or subordinate route; **R3** the harness
counted any nonzero exit as "caught". All four R1/R2 probes were **measured first against the unrepaired walker and confirmed**
([`probes-pre-repair-CONFIRMED.txt`](probes-pre-repair-CONFIRMED.txt)). Then, in order: EXPECTATIONS-1.md + expectations-1.lisp pre-registered (`b05d1332`: WW-R8
correspondence → `:mistargeted`, WW-R9 active path vs completed → shared support memoized, EA-8 order, WW-R7 bounded to `ww-r-0` with
`:unsupported-policy`, fixtures S8–S13, E8–E13, harness expectation) → the walker repaired (pre-repair source at `d8c4d860`) →
run 3 14/15 (E9 presentation, walker wrong, repaired) → run 4 **15/15** → teeth.sh v2, five plants caught for the intended reason, crash
= harness failure, outputs retained.

**Corrections to this return's own text:** (1) "Required historical state = one whole-store snapshot with a policy label … retains all
of them as one blob" was too strong — the snapshot retains a **store and a symbol**; reassessment is bounded to `ww-r-0` = this pinned
implementation, and a label is not retained executable semantics. (2) EXPECTATIONS-0's RESULTS sentence "the expectation [was wrong]"
is corrected in place-below: the walker was wrong. (3) The specimen now has **six** result words for the corrected walker
(`:established :conditional :blocked :not-established :mistargeted :cycle`) plus two reassessment refusals (`:cannot-reconstruct
:unsupported-policy`) — all experimental words; none adopted anywhere.

**The discovery, in Astra's words, kept:** *following the selected reference is only part of the job. The walker must also establish
that the reference supports this claim — and that encountering it twice is not necessarily a cycle.*

Run: `sbcl --script warrant-walk.lisp --check` (exit 0 iff 15/15) · `TEETH_OUT=$PWD/teeth-out bash teeth.sh` (exit 0 iff five plants
caught for their reasons, no crash, baseline 15/15). Diff of the repair: `git diff d8c4d860..<this commit> -- experiments/latent-lisp/atelier/warrant-walk/warrant-walk.lisp teeth.sh`.

---

## ADDENDUM 2 — the reviewer's assessment of the repair; two packaging items closed (2026-09-08)

Astra's public-update review (2026-09-08): *"The substantive walker repairs are accepted on source review and the supplied
execution record. The active path/completed-route distinction addresses the false cycle; correspondence is checked at root, nested
route, and evidence leaf; unsupported historical policy labels are refused; and the harness now checks intended failures and crash
indicators."* — with the reviewer's execution boundary stated: SBCL unavailable there; 15/15 and the five intended plant failures
are this tree's retained execution evidence, not the reviewer's rerun. Two bounded items it named, now closed: (1) `teeth.sh` v2
defaulted its output directory to a scratch path that its own EXIT trap deleted, so the announced retention held only when
`TEETH_OUT` was set explicitly (as it was in the recorded validation) — **v3 defaults to `./teeth-out` beside the specimen and refuses a
`TEETH_OUT` inside the scratch dir**; the default invocation was run and `teeth-out/` (6 files) survives it; (2) `SHA256SUMS` carried
the README digest from before a reader's note was appended — **regenerated after the final edits** (the earlier manifest stands in
git history as the receipt it was). Runs after these edits: `--check` 15/15; `teeth.sh` five plants caught for their reasons, baseline
green. No walker change in this addendum.
