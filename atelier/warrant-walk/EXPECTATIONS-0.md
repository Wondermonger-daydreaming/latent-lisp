# WARRANT WALK /0 — pre-implementation rules, fixtures, and expected outcomes

*Written 2026-09-08T16:55:13-03:00 by `date`, BEFORE any walker code exists. Chair: Claude Fable 5.1, *The Cache Is Never An Input* [e1ca41], laptop.
Commission: Astra (GPT-6), forwarded by the owner, verbatim at
`corpus/voices/received/originals/2026-09-08-165246-astra-commission-warrant-walk-0-experimental-lisp-specimen-VERBATIM.md`.
Documentary source: `_staging/2026-09-07-shannon-synthesis-0/WARRANT-CALCULUS-0.2.md` with ADDENDUM A and corrected ADDENDUM B.
Claim ceiling of everything in this directory: **experimental executable contact with the documentary calculus.** Nothing here is, or
becomes, the governing Lisp+/Mneme standing policy; no adopted contract is touched; ids below are fixture symbols, not LCI ClaimIds or WarrantIds.
This file is preserved by its commit; the implementation may add a dated RESULTS section below the line but never edits above it.*

## 0. The question

**Which support did this conclusion actually use?** — and, when two routes support the same proposition, does the assessment change
*for the right reason* (a change in the selected route, in its support, or in the retained state) and never for a wrong one (an
alternative route's obligations; a carried label; a silent substitution)?

## 1. The tiny world (fixture domain, declared)

A **store** is an ordered list of records; each record is a plist with a `:kind` and an `:id`. Four kinds and nothing else:

| kind | shape | meaning |
|---|---|---|
| `:claim` | `(:kind :claim :id C [:carried-status S])` | a proposition; `:carried-status` is **testimony** printed by the walker and never read by any rule |
| `:route` | `(:kind :route :id D :for C :adequate BOOL :premises ((P :via REF) …))` | a derivation of C. `:adequate` is a fixture input (ADDENDUM A Correction 1: adequacy is assessed, not component-presence — here the assessment is *given*). Premises are **conjunctive**. Each premise names its **selected support** `REF` (corrected B §B.2): a route id, an evidence id, or the literal `:unresolved` |
| `:evidence` | `(:kind :evidence :id E :for P :adequate BOOL)` | a leaf support record for P; adequacy a fixture input |
| `:snapshot` | `(:kind :snapshot :id T :policy POL :store STORE)` | retained historical state at tick T: a whole store plus the policy label in force |

An assessment is requested as `(assess STORE CLAIM :via ROUTE)` — the assessed claim and the route under assessment are named at the
call (corrected B §B.1: the record names the assessed claim, the selected route, the rule, the state scope, and the time).
Historical reassessment is `(reassess STORE CLAIM :via ROUTE :at T)`.

## 2. Experimental rules (WW-R1 … WW-R7) — named, not adopted

- **WW-R1 (status is a query; carried status is testimony).** The result is computed by walking; a `:carried-status` on any claim is
  echoed under `:carried-status-testimony` and contributes nothing to `:result`.
- **WW-R2 (selection, recursive).** The closure follows, for each premise, exactly the `REF` the route names; the walker recurses into a
  referenced route and stops at a referenced evidence record. Other routes or evidence `:for` the same premise claim are **not entered**;
  they are *listed* under `:not-entered` (inspection is not gathering).
- **WW-R3 (explicit unresolved).** A premise `:via :unresolved` is a **named unresolved obligation** `(Q :on D)`; the walk continues over
  the other premises; the result is at most `:conditional`.
- **WW-R4 (missing ≠ unresolved).** A `REF` that resolves to no record in the store is **missing support** `(REF :for P :on D)`; the
  result is `:blocked`. No alternative is substituted. `:blocked` and `:conditional` are different words on purpose.
- **WW-R5 (adequacy is an input).** A route or evidence with `:adequate nil` yields `(X :inadequate)` and the result `:not-established`.
  The specimen never judges prose.
- **WW-R6 (result order).** Over the followed closure: any missing → `:blocked`; else any inadequate → `:not-established`; else any
  unresolved → `:conditional`; else `:established`. (An experimental ordering; the calculus leaves it open — **EA-5** below.)
- **WW-R7 (historical reassessment needs retained state).** `reassess … :at T` runs the walk against the snapshot whose `:id` is T and
  reports its `:policy`. If no snapshot T exists the result is **`:cannot-reconstruct`** with the reason, and **no** `:result` of any
  other word is produced — not `:blocked`, not `:not-established`, not the present-state answer.

Every report is a plist exposing: `:claim :route :result :followed :evidence :unresolved :missing :inadequate :not-entered
:carried-status-testimony :rules :explanation` (and `:at :policy` for reassessment).

**Defective comparison (WW-DEFECTIVE, isolated, labelled).** `assess-defective` gathers **every** route and evidence record `:for` each
premise claim from the store, regardless of the `REF` the route named, and recurses into all of them. It exists to be wrong on the
two-route fixture. It is never called by the corrected walker.

## 3. Experimental assumptions (EA-1 … EA-7) — choices the calculus leaves open, named here, promoted nowhere

- **EA-1** ids are symbols in one fixture namespace; equality is `eq`. No ClaimId/WarrantId scheme is implemented or implied.
- **EA-2** selection is recorded *on the route*, per premise, as `:via` — one selected support per premise. (Corrected B says the trace
  "may" carry it; this specimen puts it on the derivation record. That is a representation choice, not LCI/0's requirement.)
- **EA-3** premises of one route are conjunctive; alternatives are *separate routes* for the same claim. No disjunctive premise form.
- **EA-4** adequacy is a boolean fixture field. Real adequacy is an assessment; here it is given.
- **EA-5** the result-word ordering of WW-R6 (missing dominates inadequate dominates unresolved) is experimental.
- **EA-6** a tick is an integer; a snapshot is a whole-store copy plus a policy label. "Required historical state" = that snapshot.
- **EA-7** fixtures are acyclic; the walker carries a visited set and reports `(:cycle …)` rather than looping if that is violated.

## 4. Fixtures

```
S0 (baseline):
  (:claim c) (:claim p) (:claim s) (:claim q)
  (:route dc :for c :adequate t :premises ((p :via d2)))
  (:route d2 :for p :adequate t :premises ((s :via e-s)))
  (:evidence e-s :for s :adequate t)

S1 = S0 + (:route d1 :for p :adequate t :premises ((q :via :unresolved)))         ; unused alternative
S2 = S1 with dc's premise changed to (p :via d1)                                   ; selection switched
S3 = S2 + (:evidence e-q :for q :adequate t), d1's premise changed to (q :via e-q)  ; Q supplied
S4 = S1 minus (:evidence e-s)                                                       ; selected support removed
S5 = S4 with (:claim c :carried-status :established)                                ; label carried
S6 = S4 with no snapshot records                                                    ; history not retained
S7 = S1 + (:snapshot 1 :policy ww-r-0 :store S0)                                    ; positive control for WW-R7
```

## 5. Expected outcomes (pre-written; a mismatch is a FAILED expectation to be reported, never silently repaired)

| # | call | expected `:result` | expected exposure |
|---|---|---|---|
| E1 | `(assess S0 c :via dc)` | `:established` | followed `((p :via d2) (s :via e-s))`; evidence `(e-s)`; unresolved `()`; missing `()`; not-entered `()` |
| E2 | `(assess S1 c :via dc)` | `:established` | as E1, **plus** not-entered `((d1 :for p))`; unresolved still `()` — **Q does not enter** |
| E2-D | `(assess-defective S1 c :via dc)` | `:conditional` | unresolved `((q :on d1))` — the contamination, labelled DEFECTIVE |
| E3 | `(assess S2 c :via dc)` | `:conditional` | followed `((p :via d1))`; unresolved `((q :on d1))`; not-entered `((d2 :for p))` |
| E4 | `(assess S3 c :via dc)` | `:established` | followed `((p :via d1) (q :via e-q))`; evidence `(e-q)`; unresolved `()` |
| E5 | `(assess S4 c :via dc)` | `:blocked` | missing `((e-s :for s :on d2))`; followed `((p :via d2))`; not-entered `((d1 :for p))` — **d1 not substituted**; unresolved `()` |
| E6 | `(assess S5 c :via dc)` | `:blocked` | as E5, **plus** carried-status-testimony `((c :established))`; `:result` unchanged |
| E7 | `(reassess S6 c :via dc :at 0)` | `:cannot-reconstruct` | `:at 0`; reason names the absent snapshot; **no other result word present** |
| E7-C | `(reassess S7 c :via dc :at 1)` | `:established` | `:at 1 :policy ww-r-0`; followed as E1 (positive control: the mechanism can reconstruct when state IS retained) |

**Decisive comparison:** E2 vs E2-D on the same store — the corrected walker's `:result` is `:established` with Q absent from the
closure and d1 under `:not-entered`; the defective walker's is `:conditional` with `(q :on d1)`. If both agree, the specimen has
failed to expose the defect and this file says so.

## 6. What a failure looks like, and what is done

Any row whose measured report disagrees with its expected `:result` or expected exposure is FAILED. The RESULTS section below the line
records the failed row, the measured report verbatim, the diagnosis (a claim — evidence shown), the repair (to the walker, or — if the
expectation was wrong — a *new* dated expectation beside the old one, never over it), and the re-run. This file's pre-implementation
content is fixed by the commit that lands it; the hash is quoted in RETURN.md.

---

## RESULTS — appended after implementation (2026-09-08T16:59:20-03:00 by `date`; pre-registration commit `94b5a468`, this file's pre-line sha `528f18d9…`, `expectations.lisp` sha `6630d108…`)

**Run 1 (transcript `transcript-run1-FAILED-E5.txt`, walker sha `be1472b6…` at that moment): PASS 8/9, FAIL 1 — E5.**
Measured: `:followed ((P :VIA D2) (S :VIA E-S))`; expected `((p :via d2))`. `:result :BLOCKED`, `:missing ((E-S :FOR S :ON D2))`,
`:not-entered ((D1 :FOR P))` all as expected — the substantive behavior (no substitution; blocked, not conditional) held; the exposure
double-listed the missing reference. **Diagnosis (evidence: the WW-R4 branch of `walk-route` pushed to both `:followed` and
`:missing`):** "followed" was implemented as *attempted* rather than *reached*. **Ruling on which side was wrong:** the expectation.
"Followed" in corrected B §B.1 names the support the record *used*; a reference that resolves to nothing was not used, and the attempt
is already recorded, once, under `:missing` with its claim and route. **Repair:** one `push` removed in the WW-R4 branch (comment
in the source names this run). **Run 2 (`transcript-run2.txt`): PASS 9/9.** The pre-registered E5 row above is unchanged.

**Decisive comparison (E2 vs E2-D, same store S1):** corrected `:ESTABLISHED`, `:unresolved NIL`, `:not-entered ((D1 :FOR P))`;
defective `:CONDITIONAL`, `:unresolved ((Q :ON D1))` — **DEFECT EXPOSED.**

**Teeth (`teeth.sh`, on copies):** Plant A (defective walker secretly correct) → checker RED, "DEFECT NOT EXPOSED" printed ·
Plant C (silent substitution of another route when selected support is missing) → RED at E5 and E6 · Plant D (carried label
overrides the result) → RED at E6 · baseline green. Two plants were **mis-aimed on first try and never fired** (B: substituted at the
leaf claim S, which has no alternative; D-first-aim: appended a second `:result` key, which `getf` never reads) — each was re-aimed or
dropped and is recorded in RETURN.md; a plant that does not fire is not a tooth.

**Cosmetic:** the DECISIVE line printed pretty-wrapped in run 1; `*print-pretty*` is bound nil in `check-all` since run 2. No expectation touched.

### RECORD CORRECTION (2026-09-08T17:10:55-03:00 by `date`, on Astra's review) — the RESULTS paragraph above says *"Ruling on which side was wrong: the expectation."* That sentence is wrong on its face: the explanation, the unchanged E5 row, the code repair, and RETURN.md all establish that **the walker was wrong and the expectation was right.** The sentence meant "ruling on which side was wrong: [the walker, against] the expectation" and lost its object. Corrected here; the paragraph above is left as written.
