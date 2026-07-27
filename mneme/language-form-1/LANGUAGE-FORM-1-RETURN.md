# LANGUAGE FORM /1 — CANDIDATE /0 — IMPLEMENTATION RETURN

> ## ⚠ THIS RETURN IS AMENDED. READ §14 BEFORE CITING ANYTHING BELOW IT.
>
> **Owner dispositions on this return's open questions are filed separately in
> [`LANGUAGE-FORM-1-OWNER-RULINGS.md`](LANGUAGE-FORM-1-OWNER-RULINGS.md)** —
> including the readings of §14.13 (the envelope) and §14.15 that the owner
> has settled. That document governs where it and this one differ.
>
> **The layer is at POLICY v3.** §1–§13 describe the layer as it stood at policy
> v2, and are preserved unamended except where a line is marked, so that what
> this return claimed *before* Review 1 stays legible beside what it claims now.
> Three figures in §1–§13 are superseded:
>
> | §1–§13 says | §14 measures |
> |---|---|
> | policy **v2** | policy **v3** (grammar version still 1) |
> | EG-4 holds with **4.1×** headroom | EG-4 holds with **1.08×** on the worst-case fixture |
> | `36` declared refusal codes | **37 protocol + 3 integrity alarm = 40**, split by class |
> | NC-31 is "an undetected host error" | **two different facts** — one repaired, one a declared residual |
> | suite `168` checks · application `59` | suite **210** · application **68** |

## POLICY v2 — EG-4 RESOLVED  *(superseded by §14; preserved as written)*

*Claude Opus 5 (1M context), 2026-07-27, under the owner ruling
`RESOLVE EG-4 AND COMPLETE LANGUAGE FORM /1 CANDIDATE /0`.*

```
policy                v2   (v1 failed EG-4, never merged, preserved unchanged)
EG-4                  RESOLVED — envelope holds with 4.1x headroom
merged                no
Form /0, Slice /0/1/2, Surface /0, Kernel /0, CD/0   BYTE-UNTOUCHED
governing runners     unchanged
root _staging/        untouched
```

**The before-repair record is preserved byte-for-byte**, verified against the
blocked commit rather than trusted to timestamps:

```
EG4-MEASUREMENT.lisp             15962569ac888d7a   IDENTICAL to e5ffe68c
EG4-MEASUREMENT-RUN.txt          f6184c1ebc81f0d6   IDENTICAL
EG4-WHEN-THE-GATE-FIRES.lisp     b94ecfcef93d29da   IDENTICAL
EG4-WHEN-THE-GATE-FIRES-RUN.txt  24599e0cf30e71fa   IDENTICAL
```

---

## 1. THE ANSWER TO §1 AND §3 — NEITHER BLOCKED

The ruling authorised two stops. Both were checked at the source **before any
code was written**, and neither fired.

**§1 — CD/0 CAN represent the required lossless identity value.**
`make-bytes-datum` accepts an `octet-string` directly
(`cd0.lisp:704-731`, the `(octet-string-p prepared)` branch), and
`canonical-octets` returns exactly that. So

```
identity payload datum → canonical-octets → make-bytes-datum → THE IDENTITY VALUE
```

is a direct construction with **no conversion, no stringification, no hex**.
`equal-datum` is exact over the bytes family. `bytes-datum-value` already returns
a fresh copy (`cd0.lisp:~/%copy-octet-vector`), so no mutable storage escapes.

**§3 — the exact Slice /2 identity IS representable.**
`lisp-plus-kernel0:identity->datum` is public (`kernel0/package.lisp:100`) and
yields an identifier datum with namespace `("lisp-plus-kernel0" "identity")` and
path `(DOMAIN-NAME IDENTITY-NAME)` — **the complete identity, domain included**,
not a diagnostic key. Two distinct Slice /2 receipt identities therefore yield
two distinct datums and **cannot collide observationally**.

The overstatement is withdrawn rather than silently preserved. The reader is
renamed `PETITION-SUBMISSION-RECEIPT-SLICE2-RECEIPT-IDENTITY-DATUM`, and the
honest remaining ceiling is stated separately: *the identity Slice /2 mints is
itself an image-local ordinal name — a property of Slice /2's naming, not a
durability claim by Form /1.*

---

## 2. POLICY v1 → v2 DELTA

| | **v1 (failed EG-4, never merged)** | **v2 (current)** |
|---|---|---|
| identity representation | Common Lisp **string** of `octets-to-hex ∘ canonical-octets` | **immutable CD/0 byte-string datum** |
| composition cost | hex doubles each link ⇒ **≈2.05× per link** | octets embed directly ⇒ **≈ +60 octets per link** |
| composition shape | descendants **restated** the subject and all four reference fields | **transitive, non-redundant** — predecessor + only that phase's new facts |
| equality | `string=` | **`equal-datum`** |
| hexadecimal | embedded into every successor | **diagnostic only**, never embedded |
| ceiling | `max-identity-characters 131072`, on the terminal | `max-identity-octets` envelope + `outcome-tail-reserve-octets` |
| where it could fail | **after `DERIVE/2` had run** | **before invocation**, as a build gate |
| receipt construction | could refuse | **TOTAL** |
| Slice /2 reference | `identity-key` diagnostic **string** | **`identity->datum`**, domain and name |
| `TRY-MATERIALIZE-PETITION` | unary wrapper, **dropped the receipt** | **3 values** |
| public string readers | handed out stored mutable strings | **fresh `COPY-SEQ`** |
| policy version | 1 | **2** |
| grammar version | 1 | **1 — unchanged**, the datum grammar did not change |

**Everything binds policy v2, transitively.** The validated identity commits to
the policy identity and version; content ← validated, occurrence ← content,
submission occurrence ← petition occurrence, receipt ← submission occurrence. No
descendant restates the policy, and none needs to.

---

## 3. THE IDENTITY DATUM, AND THE PROOF HEX IS DIAGNOSTIC ONLY

```lisp
(defun %identity (payload)
  (lisp-plus-cd0:make-bytes-datum (lisp-plus-cd0:canonical-octets payload)))
```

**Proof that hexadecimal never enters an identity**, by exhaustive grep of the
implementation:

```
occurrences of OCTETS-TO-HEX in form1.lisp:  1
the only one:  line 173, inside RENDER-IDENTITY-HEX
```

`RENDER-IDENTITY-HEX` is called by nothing in the implementation. It exists for
printers and measurement. Its docstring says so, and the selftest asserts the
relationship it must satisfy (hex length = 2 × encoded octets).

**Identity composition, §2's shape, as implemented:**

```
SUBJECT        canonical petition datum
PROPOSED       phase tag · grammar identity/version · SUBJECT
VALIDATED      phase tag · PROPOSED · policy identity/version · budget id
CONTENT        phase tag · VALIDATED
OCCURRENCE     phase tag · CONTENT · occurrence tag
SUBMISSION-OCC phase tag · OCCURRENCE · context occurrence id · act id · by id
               · procedure identity/version
RECEIPT        phase tag · SUBMISSION-OCC · outcome kind · exact Slice /2 refs
```

The four reference fields and the petition datum are **not restated** in any
descendant. The objects retain them as direct fields for inspection and
execution; the identity chain does not duplicate what its predecessor binds.

---

## 4. EG-4, OLD AND NEW

### Old (policy v1) — preserved, unchanged

| supports | terminal identity | vs 131,072 chars |
|---:|---:|:--|
| 8 | 127,016 | within — the reachable maximum |
| 9 | 134,096 | EXCEEDED |
| 16 | 185,056 | EXCEEDED — the advertised maximum |

Plus the placement finding: at n=9, `derive/2` invocations = 1, outcome NONE,
refusal `:IDENTITY-LENGTH-EXCEEDED`, **no submission receipt** — a governed act
with no account of it.

### New (policy v2) — `EG4-IDENTITY-VALUE-MEASUREMENT.lisp`, raw capture beside it

Measured in **identity value octets**, not display characters. At the **largest
lawful petition** — 16 support references with the longest names fitting the
16,384-octet ceiling, the petition itself **15,237 octets**:

```
                        :GRANTED   :GOVERNED-REFUSAL   :DOOR-REFUSAL
terminal receipt id      15,854         15,882            15,839   octets
outcome tail                144            171               132   octets
```

```
maximum terminal identity   15,882 octets    envelope  65,536   → 4.1x headroom
maximum outcome tail           171 octets    reserve    4,096   → 24x  headroom
verdict                     EG-4 HOLDS — every admissible classified outcome fits
```

Phase-by-phase growth is now **additive**, not multiplicative:

```
n=0  short keys:  petition 286  → subject 294 → … → petition-occurrence 614
n=16 long keys:   petition 15,237 → subject 15,245 → … → petition-occurrence 15,565
```

**Envelope adjudication, by measurement.** The structural bound is
`max-petition-canonical-octets (16,384) + measured maximum phase overhead (645)
≈ 17,100` for *any* admissible petition. The envelope is **65,536** — finite,
~3.8× that bound, never reached by an admissible input. The **reserve** stays
4,096 against a measured maximum tail of 171: over-reserving only makes the
pre-invocation gate stricter, which is the safe direction to be wrong in.

---

## 5. PROOF THAT NO FORM /1 REFUSAL CAN FOLLOW A CLASSIFIED OUTCOME

This is the structural claim the whole repair turns on, so it is proved
structurally and not merely tested.

**(a) Every identity gate is pre-invocation.** All eight `%GATED-IDENTITY` call
sites, by enclosing function:

```
propose-petition       2
validate-petition      2
materialize-petition   3
submit-petition        1     ← before resolution, before the handler-case
```

**(b) The post-invocation constructor contains no gate and no refusal.**

```
occurrences of %REFUSE or %GATED-IDENTITY inside %FINISH-SUBMISSION:  0
```

`%FINISH-SUBMISSION` runs only inside the `handler-case` around `derive/2`, and
builds the receipt with the ungated `%IDENTITY`. **It is total by construction.**

**(c) Lexical order in `SUBMIT-PETITION`.** Every `%REFUSE` — species, context,
argument, identity-drift, envelope, and all four unresolved-reference paths —
occurs **before** the `handler-case`. The envelope gate reserves the outcome
tail *before* invocation, which is precisely what makes (b) safe rather than
merely hopeful.

Together: **there is no reachable state in which `DERIVE/2` has produced a
classified terminal outcome and Form /1 returns a policy refusal.** The
selftest turns this into a permanent regression by asserting, for every
classified outcome, that an invocation count of 1 implies both an outcome object
and a submission receipt exist.

---

## 6. READER BOUNDARY — BEFORE AND AFTER

Common Lisp strings are **mutable**. The blocked implementation handed stored
strings straight out, repeating the de-pignore Review 2 defect.

**Before** (`e5ffe68c`):
```lisp
(defun petition-refusal-host-type (refusal)    (%petition-refusal-host-type refusal))
(defun petition-refusal-detail (refusal)       (%petition-refusal-detail refusal))
```

**After**:
```lisp
(defun petition-refusal-host-type (refusal)
  "A FRESH string.  Common Lisp strings are MUTABLE; a reader that hands out the
stored one lets a caller edit the refusal after the fact."
  (let ((value (%petition-refusal-host-type refusal)))
    (and value (copy-seq value))))
```

Same repair applied to `petition-refusal-detail`,
`petition-submission-receipt-slice2-condition-class`,
`validated-petition-form-budget-id` and
`petition-validation-receipt-budget-id`. List-valued readers
(`petition-refusal-path`, `derivation-petition-support-references`,
`petition-refusal-codes`, `derivation-resolution-context-bound-references`)
already returned fresh structure and continue to.

**Identity readers now return immutable CD/0 data**, which needs no copy —
that is the point of the representation change.

**Anchors are documented as anchors, not snapshots**:
`petition-submission-receipt-context` and `petition-submission-receipt-by`
return the exact live objects and say so in their docstrings, per §7's
allowance.

---

## 7. `TRY-MATERIALIZE-PETITION` — BEFORE AND AFTER

**Before** — one unary wrapper for every operation, which silently discarded the
materialization receipt:
```lisp
(defun try-materialize-petition (validated occurrence-tag)
  (%with-retained-refusal (materialize-petition validated occurrence-tag)))
```

**After** — one wrapper per arity:
```lisp
(defmacro %retain-1 (&body body) …)   ; (values X nil)      / (values nil REFUSAL)
(defmacro %retain-2 (&body body) …)   ; (values A B nil)    / (values nil nil REFUSAL)

(defun try-materialize-petition (validated occurrence-tag)
  (%retain-2 (materialize-petition validated occurrence-tag)))
```

Public contracts now:

```
TRY-PROPOSE-PETITION      (values PROPOSED nil)            / (values nil REFUSAL)
TRY-VALIDATE-PETITION     (values VALIDATED nil)           / (values nil REFUSAL)
TRY-MATERIALIZE-PETITION  (values PETITION RECEIPT nil)    / (values nil nil REFUSAL)
TRY-SUBMIT-PETITION       (values OUTCOME nil)             / (values nil REFUSAL)
                          unexpected conditions ESCAPE
```

---

## 8. EXPORT CENSUS

Generated by `EXPORT-CENSUS.lisp` from the **live loaded package** —
`DO-EXTERNAL-SYMBOLS`, never a count of export forms. *The generator is
committed; this lane docketed a sibling two days ago for shipping a census
whose generator did not exist.*

```
live external symbols         116
fbound, bound or a class      116
neither                         0
policy version                  2
grammar version                 1
declared refusal codes         36
max support references         16
max petition canonical octets  16384
max identity octets            65536
outcome tail reserve octets     4096
```

---

## 9. WHAT IS NOT CLAIMED

- **Nothing here is a stranger audit.** One is owed (EG-6) and is not
  pre-satisfied by Form /0's, which binds one subject tree.
- **Self-consistency certification only.** One model family wrote the layer, its
  suite and its application.
- **No adoption, no freeze, no merge.**
- **No durability, persistence, cross-image standing or replay.** Every identity
  is image-local at the point where it touches Slice /2.
- **No global exactly-once submission.** Occurrence tags, act ids and context
  tags are host-supplied; Form /1 binds them into identities and guarantees only
  that *different tags ⇒ different identities*.
  **⚠ AMENDED BY REVIEW 1 — read §14 before citing this bullet.** The sentence
  that stood here read *"Identical tags ⇒ identical identities, an **undetected
  host error**, preserved as a tested limitation."* That one sentence covered
  **two different failures**: a defect of this layer (a context's declared
  content was never recorded at all, so two contexts declaring different things
  were indistinguishable) and a boundary no in-image record can cross (a trusted
  host declaring truly and binding otherwise). The first is **REPAIRED** under
  policy v3; the second is the **declared residual**. A context identity is no
  longer the host's tag — it is content-derived from the context's declarations
  — so identical *tags* no longer imply identical identities.
- **A petition is not evidence of anything**, including a granted one.

---

## 10. UNCHANGED FLOORS AND NON-MODIFICATION

```
                       BASELINE      AFTER REPAIR
form floor             3 · 199 · 0   3 · 199 · 0
language floor        11 · 654 · 0  11 · 654 · 0
verify-all             6/6 green     6/6 green
SBCL                   2.4.6 (operation-checked through the wrapper)
```

Governed-file non-modification: `git diff --name-only` against the branch base
over `canonical-datum/`, `kernel0/`, `language-core-0/`, `language-slice-0/`,
`language-slice-1/`, `language-slice-2/`, `language-surface-0/`,
`language-form-0/` and all three `verify-*.sh` → **0 files**.

Root `_staging/`: untouched. Public mirror: unchanged; the main-only guard was
observed logging `SKIPPED` for every branch commit.


---

## 11. THE COMPLETED CANDIDATE

### 11.1 What ran, and what it produced

```
form1-selftest.lisp                168 checks passed / 0 failed · exit 0
de-forma-petente/APPLICATION.lisp   59 checks passed / 0 failed · exit 0
run-form1-candidate.sh                                            exit 0
check-form1-transcript.sh          RECONCILIATION CLEAN           exit 0
                                   byte-identical on re-run
EXPORT-CENSUS.lisp                 116 externals · 0 unaccounted
```

Every figure above was re-run by the chair, not taken from a builder's report.

### 11.2 Refusal codes — and an honest deduction

```
declared      36
produced      36      set-difference EMPTY IN BOTH DIRECTIONS
```

**But three of the thirty-six are not reachable through the public surface**, and
the suite says so rather than letting the clean set-difference imply otherwise:
`:PROPOSED-IDENTITY-DRIFT`, `:VALIDATED-IDENTITY-DRIFT`,
`:PETITION-IDENTITY-DRIFT`.

The reason is a property of CD/0 that is *good*: every accessor copies
(`bytes-datum-value` → `%copy-octet-vector`, `sequence-datum-elements` →
`copy-seq`), so **no public caller can force a stored datum to stop
recomputing.** Their fixtures *induce* drift by shimming the internal recompute,
and the suite pins that ceiling with its own check:

> `[46] ok  CEILING ON THE DRIFT GUARDS: BYTES-DATUM-VALUE hands back a COPY, so
> no public caller can force real drift`

**The accurate statement is therefore: 36 codes declared · 33 publicly reachable
· 3 defensive-only, labelled.** They are not deleted — they are real guards
against internal corruption — and they are not claimed as ordinary reachability.
**Docketed as an EG-5 nuance**, in the same spirit as the Form /0 stranger
audit's refusal to let *"10 planted, 10 killed"* travel alone.

### 11.3 The policy v2 gravestone, and NC-28

```
NC-28   Door 1 (propose → validate → materialize)   derive/2 invocations = 0
        Door 2 POSITIVE CONTROL                     derive/2 invocations = 1
```

The positive control is what makes the zero mean anything. And the permanent
regression that buries policy v1:

> **for every classified outcome, invocation count = 1 ⇒ a
> PETITION-SUBMISSION-OUTCOME and a PETITION-SUBMISSION-RECEIPT both exist.**
> There is no state with count = 1, outcome NIL and a Form /1 policy refusal.

The suite proves the tooth *can* fail by injecting exactly that state and
watching it go red.

### 11.4 Planted faults — 5 of 5, at the intended tooth

| | fault | died at | intended? |
|---|---|---|---|
| PF-1 | `MATERIALIZE-PETITION` able to invoke `DERIVE/2` | NC-28 step 3 (0→1) | **yes** |
| PF-2 | pre-filter resolved supports before `DERIVE/2` | NC-10 | **yes, but only at the argument-capture half** |
| PF-3 | receiver reference satisfied from the support table | NC-35 | **yes** |
| PF-4 | aggregate reader aliases stored value | NC-20(a) | **yes** |
| PF-5 | `(error () …)` converting an implementation condition | NC-21 | **yes; never reached NC-34** |

**Not collapsed into "5 killed."** PF-2's distribution is the useful one: a
pre-filtered call still yields `:GOVERNED-REFUSAL`, so the outcome-kind assertion
alone would have waved it through. NC-10 was strengthened to assert `DERIVE/2`
received the resolved supports **`EQ`-identical and in order**. That is the
Form /0 mutation-battery lesson — *a death near the tooth is not a death at the
tooth* — applied prospectively instead of discovered by a stranger.

### 11.5 The envelope gates fire

Observed live in the suite output, both **before** invocation:

```
identity value is 80663 octets; the Candidate /0 envelope is 65536 octets
submission occurrence identity is 63350 octets and the reserved outcome tail
is 4096; together they exceed the envelope of 65536. DERIVE/2 is NOT invoked.
```

### 11.6 Candidate genealogies

| | candidate | observed |
|---|---|---|
| **A** | two-element Form /0-shaped call | Form /1 refuses `:NOT-A-DERIVATION-PETITION`; **Form /0, loaded separately with a real sealed environment, refuses in its OWN voice** |
| **B** | unresolved support reference | refuses before invocation; **no submission receipt** — and the absence of an invocation is *shown*, not claimed: two control derivations bracket it and the Slice /2 ordinal advances by the same step as two adjacent controls |
| **C** | right species/mode/kind, **wrong subject** | `:GOVERNED-REFUSAL` · claim **NIL** · basis **NIL** · receipt EXISTS naming `receipt:slice2-receipt-9` · Slice /2 decision `:REFUSED` · petition identities recompute unchanged |
| **D** | exact case | `:GRANTED` · claim, Slice /2 receipt and derivation basis all present |

Also exercised: receiver bound to `NIL` under an optional contract (distinct from
unresolved, and `DERIVE/2` **is** invoked); a receiver-required contract with
`NIL` producing the governed outcome rather than a Form /1 refusal;
role-confused binding; the same context occurrence id with different bindings;
the same submission-act id reused.

**Identity discrimination: 72 printed, 49 distinct full = 49 distinct short** —
requiring a **96-char head + 160-char tail + length**. The check failed **twice**
on real data first: a 10-char tail merged five identities into three because
submission identities share a principal/procedure/version suffix, and a 12-char
head missed the phase tag and merged a validation receipt with an equal-length
content identity. The collisions are on the record.

**And docket D-3 is now exhibited rather than asserted.** Form /0 refuses two
structurally different things with one code:

```
candidate A's datum        REFUSED  GRAMMAR / UNKNOWN-PRODUCTION  at path (1)
a LAWFUL Form /1 petition  REFUSED  GRAMMAR / UNKNOWN-PRODUCTION  at path NIL
```

### 11.7 Three chair errors the builders refused to paper over

Recorded because a return that hid them would be the defect this layer polices.

**(a) The `eq`-receipt tooth I specified is false as stated.**
`MATERIALIZE-PETITION` freshly allocates a receipt per call, so two calls can
*never* return `EQ` objects. FANG implemented the real claim instead — shimming
the loud operation to return sentinels, proving the twin hands back **the exact
objects it produced** (delegation, not rebuild) — plus a companion tooth
recording that across two calls the objects are **not** `EQ` while their
identities **are** `equal-datum`.

**(b) The source-grep tooth I specified fails on `form1.lisp`'s own lines
38–40**, which sit below the marker and name every banned token — including
`(ERROR () ...)` — while *stating the prohibition*. The scanner therefore strips
comments and string literals first, and is itself teeth-checked (T-SCAN-01..06)
before it is believed. **A scanner that has not been shown able to miss is not a
scanner.**

**(c) I amended the work order while an agent was reading it.**
`LANGUAGE-FORM-1-WORK-ORDER.md` was rewritten to policy v2 at 02:54:33, after
FANG's 02:33 read. Its transcribed header was wrong within twenty minutes. It
caught this and corrected against the live file — and it became the documented
argument for reading the code set from `(petition-refusal-codes)` **in the
running image** rather than from any transcribed table. My coordination error;
its finding.

Two stale lines in the work order were also caught by SCRIBA — the catalogue
still named `:identity-length-exceeded` (which no longer exists) and EG-4 still
stated its ceiling in v1 characters. Both repaired, with the superseded row
struck through rather than deleted.

---

## 12. RECOMMENDATION

```
READY FOR OWNER REVIEW — FORM /1 CANDIDATE /0
```

EG-4 is resolved by measurement, not by adjustment. The two defects that blocked
policy v1 are gone by construction rather than by care: the doubling is removed
at its cause, and the post-act refusal path does not exist. The candidate is
complete — suite, application, runner, reconciler, census — and every number in
this return was produced by a committed program that can be re-run.

**Not merged.** Not adopted. Not frozen. A stranger audit is owed and is not
pre-satisfied by Form /0's.


---

## 13. POST-RETURN — WHAT THE ADVERSARIAL PASS FOUND

*Added after the return was first written. The suite's author was asked, from
its own transcript, four questions it had not been asked before: which of its
teeth is weakest, what it scoped out, whether CD/0's copy-on-access is a
guarantee or a happenstance, and where a cold stranger would attack. Its answers
make this return **worse**, which is why they are here rather than summarized.*

### 13.1 TWO OF THE 168 CHECKS WERE HOLLOW. Both are repaired and teeth-checked.

**Check [46] — the drift-ceiling tooth — was a TAUTOLOGY**, and it was the only
thing in the suite claiming to establish the property §11.2's entire
"defensive-only" framing rests on.

It filled the *first* read of `bytes-datum-value` and then compared the store
against a datum rebuilt from a *second* read. Under an aliasing accessor **both
sides are zeroed**, so equality holds regardless. It demonstrated that
`make-bytes-datum ∘ bytes-datum-value` round-trips, wearing a label claiming it
demonstrated defensive copying.

Repaired to ask the discriminating question — *did the STORE survive the
caller's fill* — and verified against a faithful aliasing simulation that hands
back the datum's actual internal vector:

```
                REAL     ALIASING
  OLD [46]      T        T          *** CANNOT FAIL — HOLLOW ***
  NEW [46]      T        NIL        DISCRIMINATES
```

**Check [129] — NC-34 — was VACUOUS TWICE OVER.** It compared a *keyword*
against labels that are always *strings* (`eq` is `NIL` for every entry), and no
entry ever carried that label under any representation. Repaired to test its
actual claim — that the escaping path returns **no values at all** — and
teeth-checked:

```
  malformed conclusion (should escape)  -> T
  valid conclusion     (should return)  -> NIL      DISCRIMINATES
```

**A chair error, recorded because it is the same defect class.** My first
teeth-check harness reported that the OLD [46] *did* discriminate, which would
have made this whole finding a false alarm. The harness was **unfaithful**: it
aliased the accessor's *return value* but not the datum's *internal store*, so
`equal-datum` still read uncorrupted bytes. **A simulation standing in for the
thing simulated** — inside the session whose subject is descriptions acquiring
the standing of what they describe. Caught only because the result disagreed
with a report I had reason to trust.

### 13.2 THE SUITE WAS NEVER EXHAUSTIVELY SWEPT — and "teeth-checked" overclaimed

The return said the suite was teeth-checked. That rested on **six named
mutants**, all of which went red. Six teeth are demonstrably able to fail; **the
other 162 were never swept**, and the six were selected by the same mind that
wrote them — precisely the selection bias the practice exists to defeat.

**The missing instrument is boring and mechanical:** flip each check's condition
in turn, assert the suite goes red. 168 runs, entirely scriptable, and it would
have caught both hollow teeth in one pass. **Docketed as the highest-value open
item on this layer.** The clever version of the discipline was done; the
exhaustive one was skipped.

### 13.3 Q3 ANSWERED — and the answer improved on inspection

**CD/0's copy-on-access is a GENUINE GUARANTEE, not a happenstance.** CD/0's own
`tests.lisp` pins it explicitly (`"mutated string accessor copy"`,
`"mutated bytes accessor copy"`, `"mutated identifier accessor copy"`,
`"mutated sequence accessor copy"`, `"mutated adjustable fill-pointer bytes"`);
`COMMON-LISP-SEED-VERIFICATION.md` records fifteen mutation probes under
*"Immutable views and aliases"*; the Python seed carries a matching
`test_fixture_ast_output_is_a_defensive_copy`. It is **cross-language and
spec-adjudicated**, one layer down, in code.

**The residual, which is smaller but real:** if CD/0 ever regressed, **CD/0's**
suite goes red — not Form /1's, which would keep printing green while the threat
model beneath it had changed. The repaired [46] therefore earns its place not as
coverage but as **a tripwire on an assumption imported from another layer**.

### 13.4 THE CODE LEDGER FLATTENS A DISTINCTION IT SHOULD PRINT

`T-CODESET` reports `declared 36 · produced 36` with **no partition** between
codes produced by exercising the layer and codes produced by shimming its
internals. The distinction is labelled in a section header and a comment; **the
ledger — which is what a reader of green output sees — flattens it.**

That is a count standing in for a demonstration: the same defect class the tooth
exists to prevent. **The fix is two ledgers printed separately: 33 reachable + 3
induced.** Docketed.

**And a related affordance problem, larger than it looks.** A host author
reading `+petition-refusal-codes+` today and writing a handler for
`:PROPOSED-IDENTITY-DRIFT` is **writing dead code with no way to tell.** The
distinction belongs in the catalogue the host reads, not only in the suite that
tests it.

### 13.5 THE FINDING I EXPECT A STRANGER TO LEAD WITH

**A sealed context's bound VALUES are unauditable through the public surface.**
`derivation-resolution-context-bound-references` collects `(list role (car cell))`
and drops the `cdr` — you can enumerate *which* references were bound, **never
to what**. That is the right call for aliasing. But it means **the durable
record of a governed act never commits to the evidence resolved into it.**

Combine it with what NC-31 already demonstrates in four lines of ordinary
fixture code — two contexts, same supplied occurrence id, different bindings,
**identical submission occurrence identities and opposite outcomes
(`:GRANTED` vs `:GOVERNED-REFUSAL`)** — and the sharp statement is:

> **Two submissions can be identical in every durable field Form /1 records and
> differ in outcome.**

This return and the work order call that an *undetected host error*, which is
honest and sounds like an edge case. **It is four lines of fixture code.** The
gap between what the layer claims to make auditable and what it actually records
is a defect of *framing*, not of implementation — and it is structurally invisible
to a suite written against the layer's own claims. This one was.

### 13.6 UNTESTED CLAIMS, NAMED

- **Identity injectivity.** The non-redundant chain is justified by *"the
  predecessor already commits to X"* — a transitivity argument, and transitivity
  arguments are where substitution attacks live. Check [84] shows **sensitivity**
  (one perturbation moves all five descendants); **no attempt was made to
  construct two different genealogies sharing a terminal identity.** Believed to
  hold because the encoding is lossless — *an argument, not a test*, and **the
  single most load-bearing untested claim in the layer.**
- **`:by` vs `:by-id` may diverge freely.** Both required, neither related. A
  host can submit with `:by` the clerk and `:by-id` the director; the live value
  reaches `DERIVE/2` and the durable record names the director. The docstring is
  honest about it. **Untested.** Stacked on §13.5, the durable account of a
  governed act commits to neither the evidence resolved nor the principal who
  acted.
- **The escape partition was never enumerated.** One escaping class was
  demonstrated. **The full Slice /1 and Slice /2 condition inventories were never
  walked** to confirm nothing that *is* a governed disposition escapes instead of
  being classified. If one does, that is a real defect and this suite is blind to
  it.

### 13.7 Two smaller observations, verified

- **`%host-type-descriptor` collapses every numeric type** to the constant
  `"COMPOUND-HOST-TYPE"` (because `(type-of 42)` is a cons), so `:not-a-datum`
  refusals for integers, rationals and specialized arrays are observationally
  identical in that field. §12's discipline arguably requires this — but it is
  the same *reader-cannot-tell-which-happened* complaint §11 makes against
  Form /0's `:UNKNOWN-PRODUCTION`.
- **The validated identity embeds a host config fact** — `"cd0-conformance-default"`
  via `(%budget-id)` — so validated identities differ across images running
  different budgets. Presumably intended, but the docs call identities
  *content-derived* and this one carries an image fact.
- **The 4,096-octet reserve is safe but its argument lives elsewhere.** Measured
  tails are 132–172. The tail is a constant header plus the outcome kind plus
  `identity->datum` of a **Slice /2** identity plus `%host-type-descriptor` of a
  **foreign** condition class. Slice /2's ordinals grow with image activity and
  the class string is whatever package a future signalling class lives in.
  **Nothing in Form /1 notices if Slice /2 renames or nests** until a submission
  refuses.

### 13.8 THE RECOMMENDATION, RESTATED HONESTLY

`READY FOR OWNER REVIEW` **stands** — nothing above is a contradiction, and the
two hollow teeth are repaired and now discriminate.

But the phrase means less than it did before §13 existed, and the accurate form
is: **ready for review, with the first four things review should attack already
named** — the unauditability of bound values (§13.5), identity injectivity
(§13.6), the unswept suite (§13.2), and the flattened code ledger (§13.4).

The suite's author put its own limit better than I can:

> *I tested the layer very hard against its own stated claims, and not at all
> against whether those are the right claims. Every fixture took the work order's
> framing as given — including its framing of what counts as an acceptable
> limitation. That is the gap a stranger fills.*

**That is the honest standing of this candidate**, and it is a stronger argument
for the owed stranger audit than anything in §9.

---

*— Claude Opus 5 (1M context), 2026-07-27. Committed, pushed, unmerged.
§13 added after the adversarial pass, and it makes this document worse on
purpose.*

---

# 14. REVIEW 1 — THE CONTEXT-DECLARATION REPAIR

*Claude Opus 5 (1M context), 2026-07-27, under the owner ruling
`LANGUAGE FORM /1 REVIEW 1`. Appended, not merged into the text above, so that
what this return claimed **before** the review stays legible beside what it
claims now.*

```
starting tip     7db2da94
policy           v2 -> v3      grammar version UNCHANGED at 1
merged           no            published   no
Form /0, Slice /0/1/2, Kernel /0, CD/0     0 files changed (git diff --name-only)
root _staging/                             untouched
```

**The blocked policy-v1 commit `e5ffe68c` remains load-bearing history. It was
not rewritten, squashed or removed, and this review did not touch it.**

---

## 14.1 FANG'S TWO HOLLOW-TOOTH FINDINGS, RECORDED VERBATIM IN SUBSTANCE

Both are preserved **executable** in `REVIEW-1-HOLLOW-CHECKS.lisp`, run against a
discriminating pair of worlds, with both captures committed. They are **not**
absorbed into the suite.

**[46], the drift-ceiling tooth, was a TAUTOLOGY.** It filled the *first* read of
`bytes-datum-value` and compared the store against a datum rebuilt from a
*second* read; under an aliasing accessor both sides are the same zeroed vector,
so equality held either way. It demonstrated that
`MAKE-BYTES-DATUM ∘ BYTES-DATUM-VALUE` round-trips, wearing a label that claimed
it demonstrated defensive copying.

```
form                  REAL   ALIASING(faithful)   verdict
OLD [46] (shipped)     T           T              *** CANNOT FAIL — HOLLOW ***
NEW [46] (repaired)    T          NIL             DISCRIMINATES
```

**[129], NC-34, was VACUOUS TWICE OVER.** It compared a *keyword* against labels
that are always *strings* (`eq` was `NIL` for every entry any fixture could
produce), and **no call site ever passed that label in any representation**, so
the world in which it fails was never constructible by the suite.

```
log as the suite actually builds it        OLD [129] -> T
log WITH the hunted label, as a STRING     OLD [129] -> T
log WITH the hunted label, as a KEYWORD    OLD [129] -> NIL
malformed conclusion (SHOULD escape)       NEW [129] -> T
valid conclusion     (SHOULD return)       NEW [129] -> NIL     DISCRIMINATES
```

## 14.2 THE CHAIR'S FIRST INCORRECT SIMULATION, AND WHY IT WAS WRONG

The chair's **first** teeth-check harness reported that the OLD [46] *did*
discriminate — which would have made the entire hollow-tooth finding a false
alarm and left the tautology in the suite. The harness aliased the accessor's
**return value** across calls but left the datum's **internal store** untouched,
so `equal-datum` still read uncorrupted bytes.

```
form                  REAL   ALIASING(UNFAITHFUL)  verdict
OLD [46] (shipped)     T           NIL             REPORTED DISCRIMINATING — WRONG
```

**A simulation standing in for the thing simulated**, inside the session whose
subject is exactly that. It was caught only because its answer disagreed with a
report the chair had reason to trust. It is preserved as a **live control** in
`REVIEW-1-HOLLOW-CHECKS.lisp`, still running, still giving the wrong answer —
because a review that finds a description standing in for the thing described
must be able to find its own.

## 14.3 CD/0 COPY-ON-ACCESS IS A GOVERNED IMPORTED GUARANTEE

Not a happenstance. CD/0's own `tests.lisp` pins five mutation cases; the seed
verification records fifteen probes; the Python seed carries a matching test. It
is **cross-language and spec-adjudicated**, one layer down, in code.

**[46] is therefore classified as an IMPORTED-ASSUMPTION TRIPWIRE, not
independent Form /1 coverage.** If CD/0 regressed, **CD/0's** suite is what goes
red — [46] exists so Form /1 does not keep printing green while the threat model
beneath it has changed.

## 14.4 THE CONTEXT-DECLARATION REPAIR

**The defect, as FANG stated it and as NC-31 exhibited it in four lines:** the
context occurrence identity committed only to a host-supplied *name*; the
context's public declaration omitted its bound values; the submission occurrence
identity therefore did not commit to what the petition's references were declared
to denote. Two submissions, **identical 838-octet submission occurrence
identities, opposite governed outcomes** — captured in full at
`REVIEW-1-NC31-BEFORE-RUN.txt`.

**The repair.** Every binding now carries **two distinct facts**:

```
DENOTATION DECLARATION   an immutable CD/0 datum supplied by the host, naming
                         what the reference is intended to denote.  DURABLE.
                         It enters identity.
LIVE ANCHOR              the exact image-local object handed to DERIVE/2.
                         NOT durable, NOT canonically encodable, NEVER in an identity.
```

No declaration is derived from an anchor — not from `TYPE-OF`, a printed
rendering, a hash, or an address. **No arbitrary-host-object canonicalizer was
invented.** The public binders require the declaration **explicitly**, with no
default:

```lisp
(bind-schema-reference     context reference live-schema     denotation-id)
(bind-conclusion-reference context reference live-conclusion denotation-id)
(bind-support-reference    context reference live-support    denotation-id)
(bind-receiver-reference   context reference live-receiver   denotation-id)
```

A receiver bound to `NIL` requires exactly `(RECEIVER-ABSENCE-DECLARATION)`, the
package-owned sanctioned marker — and **that marker is refused for a live
receiver**, both directions checked, because a sanctioned marker means one thing
or it means nothing. (The reverse direction goes one step past the ruling's
letter; it is named here rather than folded in silently.)

**The split identity model:**

```
CONTEXT-DECLARATION-IDENTITY   content-derived from the complete
                               role / reference / denotation-declaration mapping,
                               in a CANONICAL ORDER
CONTEXT-OCCURRENCE-IDENTITY    phase tag · host occurrence tag ·
                               declaration identity · policy identity/version
```

The submission occurrence identity commits to the **context occurrence
identity**, not to the bare host tag. Insertion order is canonicalized away
(role sequence, then reference key ascending — a total order, since a duplicate
reference within a role is refused), so two contexts holding the same
declarations in different orders carry the same declaration identity: NC-31C.

**The honesty clause, carried in the package header, the binder docstrings and
the inspection readers:**

> Reference resolution is not evidence admission.
> A denotation declaration is not certification of its live anchor.

## 14.5 THE TWO INSPECTION SURFACES

`DERIVATION-RESOLUTION-CONTEXT-BOUND-REFERENCES` is **gone**. Two surfaces
replace it, different in kind:

| | returns | safe as an aggregate? |
|---|---|---|
| `…-CONTEXT-DECLARATIONS` | fresh immutable `CONTEXT-BINDING-DECLARATION` records — role, exact reference, exact declaration | **yes** — all immutable CD/0 data |
| `…-CONTEXT-LIVE-ANCHOR` | the exact image-local object, `(values ANCHOR FOUND-P)` | **no** — exact role/reference lookup only, one at a time |

Dropping the live value from the aggregate was always right. The answer to
*"right to drop"* is not *"record nothing"* — it is **record the declaration**.
Neither surface mints standing, admits evidence, installs an operator, performs
ambient lookup, or changes the mapping. A bound `NIL` is `FOUND`, and is a
different fact from unbound.

## 14.6 NC-31A AND NC-31B — THE SPLIT CONTROL

```
                                 NC-31A                NC-31B
                                 diff declarations     same declaration
context occurrence TAGS          IDENTICAL             IDENTICAL
support DECLARATIONS             DIFFERENT             IDENTICAL
context DECLARATION identities   DIFFERENT (397/399)   IDENTICAL (392/392)
context OCCURRENCE identities    DIFFERENT             IDENTICAL
SUBMISSION OCCURRENCE identities DIFFERENT (1324/1326) IDENTICAL (1319/1319)
GOVERNED OUTCOMES                OPPOSITE              OPPOSITE
```

**NC-31A is the repair.** The same fixture that used to exhibit the defect now
exhibits its absence, and the submission receipt binds the exact context
occurrence *and* declaration identities, so a reader of the receipt alone can
tell A from B.

**NC-31B is the residual, classified precisely:**

```
trusted-host false declaration or identifier reuse;
not detected by Form /1;
not claimed to be detected;
no cross-image certification earned.
```

What survives is stated exactly, because it is so much less than certification:
the exact **context anchors** reached through the two receipts are different
objects, and the exact **Slice /2 receipt identities** differ. An in-image reader
holding both receipts can see what no durable field records.

**THE EXISTENCE OF NC-31B DOES NOT EXCUSE NC-31A.** A was a defect of this
layer and is fixed. B is a boundary of what any in-image record can do.

**The corrected standing, in the shape the ruling names:**

```
unrecorded context content defect      REPAIRED
false host declaration                 DECLARED RESIDUAL
```

## 14.7 `:BY` AND `:BY-ID` — THE SAME DOCTRINE, EXPLICITLY

`:BY-ID` is the host's durable declaration naming the exact live `:BY` anchor.
**Form /1 does not certify that relation.** Both arguments are retained and
`DERIVE/2`'s `NIL -> :DERIVER` default is still not inherited.

```
NC-BY-A   same live :BY (EQ), DIFFERENT :BY-ID   ->  DIFFERENT submission occurrence identities
NC-BY-B   DIFFERENT live :BY, same :BY-ID        ->  IDENTICAL declared submission identity
                                                     (recorded as a trusted-host false declaration)
                                                     …and the two granted claims are asserted by
                                                     different principals — in-image observable
NC-BY-C   the submission receipt exposes BOTH the exact live :BY anchor and the
          immutable :BY-ID declaration.  Two readers, two kinds of fact.
```

## 14.8 THE SPLIT REFUSAL CATALOGUE

`PETITION-REFUSAL-CODES` **is removed from the package entirely** — checked in
the suite by `find-symbol`, not remembered. Three readers replace it, all
**derived from one catalogue**, so their union is the complete implementation
code set *by construction*:

```
PETITION-PROTOCOL-REFUSAL-CODES     37   :public-api
PETITION-INTEGRITY-ALARM-CODES       3   :internal-planted-fault-only
PETITION-REFUSAL-CODE-CATALOG       40   code · class · REACHABILITY · note
```

**On the arithmetic, stated rather than smoothed:** the ruling names `33 + 3`.
That was the pre-repair split. The repair added **four** protocol codes
(`:denotation-declaration-required`, `:receiver-absence-declaration-required`,
`:receiver-absence-declaration-misapplied`, `:unknown-binding-role`) and renamed
`:context-occurrence-id-required` to `:context-occurrence-tag-required`. So the
split is **37 + 3 = 40**. The *classification* is the requirement; the count
moved because the repair added public protocol surface.

The three integrity alarms are unchanged:
`:PROPOSED-IDENTITY-DRIFT`, `:VALIDATED-IDENTITY-DRIFT`,
`:PETITION-IDENTITY-DRIFT`. CD/0 copy-on-access makes them unreachable through
the intended public surface — **a genuine governed guarantee, not a current
accident** (§14.3). They remain useful as package-internal integrity guards and
planted-fault alarms, and a public caller cannot naturally provoke them. A host
author reading the catalogue can now **tell**, which is the point: previously it
would have written a handler for a code it could never receive, with no way to
find out.

**Executable requirements, each its own tooth (NC-32A…F):** every protocol
refusal produced through the public API · every integrity alarm produced under
an internal planted fault · the declared sets disjoint · **the produced sets
also disjoint** (observed, not merely asserted) · union equals the catalogue ·
no advertised code without a fixture, both directions, both classes. The suite
records production into **two ledgers**, keyed on whether an internal function
was shimmed at the moment the code was produced.

## 14.9 IDENTITY INJECTIVITY

**The claim, stated narrowly and not one word wider:**

> Form /1 identity values are injective over their declared CD/0 phase payloads,
> assuming Canonical Datum /0 exact encoding.

**Not claimed: injectivity over unrecorded live host facts.** Two contexts with
identical declarations and different live anchors produce the same identity **by
design**; that is NC-31B, not a collision, and the census counts it separately.

**A. Structural round trip — 12/12 identity species**, plus both branches where
the payload branches (submission receipt with the Slice /2 receipt present *and*
absent; refusal with path+reference *and* with host-type). Each identity's octets
were decoded with `DECODE-EXACT` and compared against a payload **rebuilt
independently** from public readers and public CD/0 constructors, with the
phase-tag and absence conventions **re-expressed rather than borrowed**, so
naming drift fails loudly.

**B. Finite collision census:**

```
population size            7776 submissions
distinct declared payloads 2592
distinct identity values   2592
collisions                    0
collision witness          none
```

Axes varied: petition subject · petition occurrence tag · **context
declaration** · context occurrence tag · submission act id · `:BY-ID` ·
procedure version · outcome kind · Slice /2 receipt presence/absence.

**One axis could not be varied publicly and is labelled as such at every
report: procedure version** is a constant function with no setter. It was varied
by rebinding an internal `fdefinition`, installed for one arm, restored, and the
restoration asserted. **An axis varied by a shim is weaker evidence than one
varied by a caller**, and the artifact says which is which per axis.

**The finding that justifies the census's shape, and it is the most useful thing
the instrument produced.** Under a planted merged-field-boundary fault, the
census measured — rather than argued — that:

> moving the denotation alone moves the identity; moving the reference key alone
> moves the identity; **moving both does not** — because `"a"‖"bc"` = `"abc"` =
> `"ab"‖"c"`.

**A one-axis-at-a-time SENSITIVITY suite returns a clean sheet on a broken
layer.** That is exactly the gap the pre-review suite could not see, and it is
why the census varies axes simultaneously.

**Two limits stated in the artifact and not smoothed over:** the full census's
*receipt* arm is partly carried by Slice /2's image-local ordinal (weak evidence
— hence a separate ordinal-free door-refusal sub-census, 2592/2592/0); and this
is a **finite search, not a proof over all inputs**. The general argument is
Part A's — a lossless encoding means round trip implies injectivity — and it
rests on CD/0 exactness, which the file assumes rather than proves.
**No hash was added.**

## 14.10 THE CONDITION ESCAPE PARTITION

`CONDITION-PARTITION.md` classifies **20 live exported condition classes** across
`SLICE1` / `SLICE2` / `FORM1`:

```
Form /1 pre-invocation protocol refusal    1   PETITION-REFUSED
Slice /2 classified governed refusal       1   SLICE2-DERIVATION-REFUSED
Slice /2 classified door refusal           1   SLICE2-SCHEMA-ERROR
UNEXPECTED CONDITION THAT ESCAPES          3
unreachable through the public boundary   14   each with a reason, file and line
```

**All three escapes and all three caught classes were confirmed BY EXECUTION**
(`PATTERN-USED-AS-GROUND`, `MALFORMED-STRUCTURED-PROPOSITION` in two
malformations, `UNBOUND-CONCLUSION-VARIABLE`) — all reached through the
deliberately value-unchecked `BIND-CONCLUSION-REFERENCE`. **The 14 unreachable
rows are classified by READING, not demonstrated by execution, and the document
says so.**

**The raw `TYPE-ERROR` receiver path is NO LONGER REACHABLE — measured, not
assumed.** It is real one layer down (`s1:derive` and `s2:derive/2` with
`:receiver 42` both signal `CL:TYPE-ERROR`), and `BIND-RECEIVER-REFERENCE`'s
species check refuses `42` / `"desk"` / `:desk` with exactly
`:WRONG-RECEIVER-SPECIES` before a context can be sealed. **It is sealed by one
check whose deletion would reopen it silently.**

**No class was caught merely to make the table smaller. No broad
`(ERROR () …)` handler appears in the checker.** The table is **checked against
the live package inventories in the running image**, set-difference both
directions, exiting non-zero on disagreement — so it cannot silently go stale.
That gate was teeth-checked by deleting a row (exit 1, naming exactly that
class, then restored byte-identical) and it **also convicted its own author
twice**, both recorded in the run capture.

**One thing worth the owner's eye, outside this review's scope:**
`SLICE2:DERIVATION-BASIS-REFUSED` has **zero signal sites anywhere in the
layer** — exported, handler-writable, never raised.

## 14.11 THE EXHAUSTIVE VERDICT-LIVENESS SWEEP

```
verdict count                 210
verdicts successfully forced  210
exact expected tooth reached  210
died elsewhere                  0
sweep harness failure           0
survived                        0
```

Each index was forced false **inside `check`, after the counter increments**, so
every fixture ran exactly as it does now and exactly one rendered verdict
flipped. One fresh SBCL process per index (the suite mutates global state and
rebinds `fdefinition`s; a shared image would measure contamination).

**The mandatory control passed:** the injected copy with **no** index forced ran
byte-identical to the pristine suite — both `sha256 1210c499f3e8e7f1…`, exit 0,
210/0. The instrument is transparent to its subject.

**The sweep's own teeth were checked**, because a zero-survivor report is
otherwise a green banner on a rumour: its `SURVIVED` verdict had never fired, so
two negative controls were planted — injection made deaf (exit 0) and a
*different* index forced red (nonzero exit while the requested index still
prints `ok`, the limb that stops nonzero-exit alone reading as a bite). Both
fired 3/3, plus an independent hand spot-check of five indices outside the
adjudicator's parsing path.

**THE LIMITATION, STATED PROMINENTLY AND NOT SOFTENED.** This sweep establishes
**only**:

> every rendered verdict is connected to the suite's failure result.

It does **not** establish that any original predicate correctly measures its
label. A tautological `(check (or x t) "…")` is forced red by this instrument
exactly as easily as a sound one — **and both hollow checks this suite already
shipped would have been forced red successfully here.** The sweep catches
*disconnected* verdicts; it does not catch *vacuous* ones. The five §M
claim-directed planted faults and FANG's faithful simulations remain the only
evidence bearing on whether a tooth measures its label, and they are preserved,
not replaced.

**Tooth classification** (the five original claim-directed planted faults are
unchanged and still die at their intended teeth):

| class | what it is |
|---|---|
| direct semantic observation | a fixture exercises the layer and the tooth reads the result |
| boundary negative control | NC-* — the layer must *not* do something, and the counter proves it |
| instrument self-check | T-SCAN-01…06, the planted-fault ledger, the sweep's own controls |
| source-shape assertion | T-NO-HOST-ESCAPE, T-NO-BROAD-HANDLER, T-NO-FORM0 |
| **imported-guarantee tripwire** | **[46] — CD/0 copy-on-access. NOT independent Form /1 coverage.** |

## 14.12 THE `(ERROR () NIL)` LINT — INFORMATIONAL, NOTHING REPAIRED

`ERROR-NIL-LINT-DOCKET.md`. Read-only sweep, 2,647 files walked.

```
occurrences found                                    121
convert an implementation failure to a protocol result  33
SEVERE (governed semantics, converts failure to result)  9
previously docketed                                      1   (D-1, slice2.lisp:1539-1540)
NEW                                                    120
```

The nine severe sites are `kernel0/boundary.lisp:84`, `core0.lisp:887/935/947`,
`slice1.lisp:382`, `slice2.lisp:634/809/1540`,
`lci0/common-lisp/migration.lisp:169`.

**`form1.lisp` itself is CLEAN — zero broad handlers**, verified both by the
sweep and by its own teeth-checked source gate. **All nine severe sites are in
layers beneath Form /1. Nothing was repaired**, and this scan does not widen
Form /1 Review 1 into a Slice /2 repair.

**A stated limit:** the tree was being edited by the chair during the scan. The
nine severe sites were all re-read afterwards and are byte-identical; a
whole-tree re-sweep to diff against the first **could not complete** (ripgrep
timed out twice), so the docket does not claim nothing appeared elsewhere in
that window, and says so rather than implying otherwise.

## 14.13 EG-4 RE-MEASURED — THE MARGIN MOVED, AND IT IS A FINDING

Every identity grew: the context declaration identity enters the context
occurrence identity, which enters the submission occurrence identity. **EG-4 was
re-proved, not assumed to survive.**

```
policy v2, worst-case fixture                 15882 / 65536  =  4.13x
policy v3, governed-identity declarations     ~32776 / 65536  ≈  2.00x
policy v3, WORST-CASE fixture                 60873 / 65536  =  1.08x
verdict                                       EG-4 HOLDS
```

**The margin is no longer generous, and calling it generous would be the flinch
this lane is named for.** The 65,536 envelope was chosen under v2 when the worst
case sat 3.8× below it; on the same fixture it is now 7% below it.

**The cliff, measured — and the first draft of this paragraph was WRONG.** It
asserted in prose that an oversized declaration is discovered only at `SUBMIT`
and that *"no earlier gate warns of it."* Running it refuted that in one line.
The retraction is left visible in the measurement file:

```
declaration   1000 → decl-identity  1287 · :COMPLETED :GRANTED                      · DERIVE/2 1
declaration  20000 → decl-identity 20289 · :COMPLETED :GRANTED                      · DERIVE/2 1
declaration  55000 → decl-identity 55289 · :COMPLETED :GRANTED                      · DERIVE/2 1
declaration  61000 → decl-identity 61289 · :SUBMIT    :SUBMISSION-ENVELOPE-EXCEEDED · DERIVE/2 0
declaration  64000 → decl-identity 64289 · :SUBMIT    :SUBMISSION-ENVELOPE-EXCEEDED · DERIVE/2 0
declaration  70000 → decl-identity     — · :CONTEXT   :IDENTITY-OCTETS-EXCEEDED     · DERIVE/2 0
```

**There are TWO pre-invocation gates, not one.** `SEAL-RESOLUTION-CONTEXT` gates
the declaration and occurrence identities as it mints them; `SUBMIT-PETITION`
gates the submission occurrence identity plus the reserved outcome tail. **In
every refusing row `DERIVE/2` was invoked ZERO times** — the policy v2 ordering
repair still holding under v3: a resource ceiling refuses *before* the governed
act, never after it.

**A RESIDUAL FOR THE OWNER, MEASURED AND NAMED, NOT TAKEN.** There is **no
policy ceiling on declaration size as such** — no `MAX-DECLARATION-OCTETS`
beside the four existing ceilings. What bounds it is the identity envelope,
enforced at seal and again at submit. The practical consequence is narrow: a
host learns its declarations are too large only when it **seals**, after every
binder has already accepted them. Whether that warrants a fifth ceiling is a
**policy decision this review was not authorised to take.**

## 14.14 VERIFICATION

```
form1-selftest                210 checks / 0 failed · exit 0   (was 168)
de-forma-petente               68 checks / 0 failed · exit 0   (was  59)
runner + reconciler            exit 0 · RECONCILIATION CLEAN
CONDITION-PARTITION            70 checks / 0 failed · exit 0
IDENTITY-INJECTIVITY          170 checks / 0 failed · exit 0
verdict-liveness sweep        210/210 forced · 0 survived
export census                 133 externals · 0 unaccounted
refusal ledger                37 protocol + 3 integrity alarm = 40 catalogued

form floor       3 floors ·  199 checks · 0 failed     UNCHANGED
language floor  11 floors ·  654 checks · 0 failed     UNCHANGED
verify-all      6/6 suites green                        UNCHANGED
SBCL            2.4.6 (operation-checked THROUGH the wrapper)

git diff --name-only 7db2da94 -- Form /0, Slice /0, Slice /1, Slice /2,
                                 Kernel /0, canonical-datum   ->  0 files
root _staging/                                                ->  untouched
```

## 14.15 EXACT RESIDUAL LIMITATIONS AFTER THIS REVIEW

1. **Trusted-host false declaration (NC-31B).** Not detected, not claimed to be
   detected, no cross-image certification earned. Not repairable in-image.
2. **No declaration-size ceiling** (§14.13). Measured, named, left to the owner.
3. **The verdict-liveness sweep licenses one sentence only** (§14.11). It does
   not establish that any predicate measures its label.
4. **14 of the 20 partition rows are classified by reading**, not by execution
   (§14.10).
5. **The injectivity census is a finite search**, and its general argument rests
   on CD/0 exactness, assumed rather than proved (§14.9).
6. **`:BY` remains any host value.** No canonicalizer was invented and none
   should be.
7. **`[46]` is a tripwire on an imported guarantee**, not Form /1 coverage.
8. **The stranger audit is still OWED** and is not pre-satisfied by Form /0's.
9. **The `(ERROR () NIL)` docket is informational.** Nine severe sites in
   governed predecessor layers are **unrepaired by design**.
10. **Self-consistency only.** One model family wrote the layer, its suite, its
    application, this review and the instruments that checked it. The four
    sub-agents were same-weights kin, not an outside — **shared-root, and their
    agreement measures the corpus attractor, not the fact of the matter.**

## 14.16 RECOMMENDATION

```
READY TO PACKAGE FORM /1 STRANGER AUDIT
```

**Not merged. Not published. Not adopted. Not frozen.** The recommendation is
that the candidate is now in a state where a *stranger* is the right next
instrument — with the ten residuals above named in advance, which is a stronger
argument for the audit than a clean sheet would have been.

*— Claude Opus 5 (1M context), 2026-07-27.*
