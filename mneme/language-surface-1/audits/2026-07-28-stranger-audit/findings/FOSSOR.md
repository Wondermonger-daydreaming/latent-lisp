# FOSSOR — STRANGER AUDIT OF LANGUAGE SURFACE /1, CANDIDATE /0

**Jurisdiction: REACHABILITY · TEETH · TIME.**
Subject (read-only, never modified):
`…/surface1-audit/extract/target/tree/mneme/language-surface-1/`
Host: SBCL 2.4.6. Subject self-reports **grammar v3 · procedure v3 · policy v1**.
Every gate below was fired **in my own hands**; no verdict here rests on a
transcript I did not produce. Mutation tests happened only in my working copy
(`probes/FOSSOR/copy/`, `probes/FOSSOR/copy2/`); the extract tree was never
written to.

Disclosed material read first, in the ordered required: `ERRATA-0.2` →
`ERRATA-0.1` → `package.lisp`. I did **not** open the freezer's
`PREREGISTRATION.md`.

**Headline: 20 of 20 catalogue entries fired, every one matching its declared
code/phase/class — and the ONE entry declared unreachable is reachable from the
public API with an ordinary, admissible source form.**

---

## §1. REACHABILITY TABLE

Witness harness: `probes/FOSSOR/prelude.lisp` (its `s1` macro resolves through
`FIND-SYMBOL` and **refuses unless the symbol is `:EXTERNAL`**, so nothing below
is a witness that quietly reached a private name). Transcripts tee'd.

| # | code | catalogue says | my result | witness / transcript |
|---|------|----------------|-----------|----------------------|
| 1 | `:source-form-not-a-call` | `:public-api` `:request` | **FIRED, matches** | `P1-reachability.lisp` [01] · `OUT-P1.txt` |
| 2 | `:source-form-head-not-a-symbol` | `:public-api` `:request` | **FIRED, matches** | `P1` [02] |
| 3 | `:operation-not-declared` | `:public-api` `:request` | **FIRED, matches** | `P1` [03] |
| 4 | `:occurrence-tag-not-identifier` | `:public-api` `:request` | **FIRED, matches** | `P1` [04] |
| 5 | `:source-term-unrepresentable` | `:public-api` `:request` | **FIRED, matches** (upstream `NO-TERM-KIND`) | `P1` [05] |
| 6 | `:source-term-shared-structure` | `:public-api` `:request` | **FIRED, matches** (upstream `SHARED-OR-CIRCULAR-STRUCTURE`) | `P1` [06] |
| 7 | `:source-depth-exceeded` | `:public-api` `:request` | **FIRED, matches** | `P1` [07] |
| 8 | `:source-nodes-exceeded` | `:public-api` `:request` | **FIRED, matches** | `P1` [08] |
| 9 | `:source-term-octets-exceeded` | `:public-api` `:request` | **FIRED, matches** | `P1` [09] |
| 10 | `:not-a-known-surface-construct` | `:public-api` `:perform` | **FIRED, matches** | `P1` [10] |
| 11 | `:expanded-term-unrepresentable` | `:public-api` `:perform` | **FIRED, matches** (upstream `UNINTERNED-SYMBOL`) | `P1` [11] |
| 12 | `:expanded-term-shared-structure` | `:public-api` `:perform` | **FIRED, matches** | `P1` [12] |
| 13 | `:expanded-depth-exceeded` | `:public-api` `:perform` | **FIRED, matches** | `P1` [13] |
| 14 | `:expanded-term-octets-exceeded` | `:public-api` `:perform` | **FIRED, matches** | `P1` [14] |
| 15 | `:source-not-reconstructible` / `SYMBOL-ABSENT-IN-IMAGE` | `:public-api` `:perform` | **FIRED, matches** | `P1` [15] |
| 15b | … / `PACKAGE-ABSENT-IN-IMAGE` | same entry | **FIRED, matches** | `P1` [16] |
| 15c | … / `SYMBOL-NOT-HOME-IN-NAMESPACE` | same entry | **FIRED, matches** | `P1` [17] |
| 15d | … / `ROUND-TRIP-MISMATCH` | same entry, planted-fault only | **FIRED, matches** | `P1` [21] |
| 15e | … / `ROUND-TRIP-NOT-ENCODABLE` | same entry | **FIRED, matches** | `P1` [22] |
| 16 | `:construct-not-a-macro` | `:public-api-in-a-stub-image` | **FIRED, matches** — theirs re-run **and** my own variant | `OUT-STUB-THEIRS.txt`; `P1b-stub-mine.lisp` / `OUT-P1b.txt` |
| 17 | `:expanded-nodes-exceeded` | **`:unreachable-under-this-policy`** | **FIRED FROM THE PUBLIC API — FINDING F1** | `P1` [23]; `P2c`, `P2d` |
| 18 | `:source-identity-projection-mismatch` | `:internal-planted-fault-only` | **FIRED via `*%fault-source-identity*`, matches** | `P1` [18] |
| 19 | `:expanded-identity-projection-mismatch` | `:internal-planted-fault-only` | **FIRED via `*%fault-expanded-identity*`, matches** | `P1` [19] |
| 20 | `:procedure-version-mismatch` | `:internal-planted-fault-only` | **FIRED via `*%fault-procedure-version*`** — but the production test is **vacuous**, see §5 | `P1` [20]; `P5` |

`CATALOGUE MISMATCHES: 0 of 23 witnesses` — code, phase **and** class agreed with
the catalogue on every fire. The two `:public-api` codes the family's own suite
declares uncovered (`:expanded-depth-exceeded`, `:expanded-term-octets-exceeded`)
I built independent witnesses for; both fire as declared.

**My own stub variant (not theirs):** a `LISP-PLUS-SURFACE0` package built with
`(:use)` and **no `:export` at all**, the construct name `DERIVE-CASE` merely
`INTERN`ed, `surface0.lisp` never loaded. Door 1 still mints a request with a
construct identity; Door 2 refuses `:CONSTRUCT-NOT-A-MACRO` / `:PERFORM` /
`:PROTOCOL-REFUSAL`. So the code is reachable on a *different* construct and
under a *weaker* stub than the disclosed fixture uses — the classification is
sound and not fixture-shaped.

---

## §2. THE MEASURED-UNREACHABLE CLAIM — **ADJUDICATED: THE ARGUMENT IS BACKWARDS AND THE CONCLUSION IS FALSE**

### F1 · `:expanded-nodes-exceeded` is reachable from the public API. NOVEL.

**Claim-sentences defeated, verbatim:**

> `surface1.lisp:204-213` —
> `(:expanded-nodes-exceeded :protocol-refusal :perform :unreachable-under-this-policy`
> *"the expanded form has more nodes than the declared node ceiling.  **MEASURED
> UNREACHABLE UNDER THIS POLICY**: the checks run depth -> nodes -> encode ->
> octets, and each term costs roughly 120 octets, so an expansion meets the
> 262144-octet ceiling at about 2000 nodes and **can never approach 20000**."*

> `surface1.lisp:150-152` — *":unreachable-under-this-policy  the guard is real
> and stays, but under THIS policy's numbers **another ceiling always fires
> first**.  Measured, not assumed — see the note."*

> `surface1-selftest.lisp:672` (**check M4, currently green**) — *"exactly one
> code is declared UNREACHABLE UNDER THIS POLICY, and it is the expanded-side
> NODE ceiling — **dominated by the octet ceiling, measured**"*

> `surface1-selftest.lisp:679` (**check M6, currently green**) — *"the arithmetic
> behind M4, exhibited rather than asserted: one term costs far more than
> 262144/20000 = 13 octets, **so octets must fire first**"*

**Preconditions:** an image with Surface /1 and Surface /0 loaded; nothing else.
No internal symbol, no fault hook, no fixture. `:MACROEXPAND-1`.

**Smallest executable witness** (`probes/FOSSOR/P2c-fire-expanded-nodes.lisp`,
`P2d-minimal-N.lisp`) — an ordinary `DEFINE-JUDGMENT-SCHEMA` form with N integer
premises, every field literal syntax:

```lisp
(LISP-PLUS-SURFACE0:DEFINE-JUDGMENT-SCHEMA CL-USER::*FOSSOR-J*
  :NAME :FOSSOR :VERSION 1 :CONCLUSION 0
  :PREMISES (0 0 0 … 0)          ; N = 2493
  :LOCALS NIL :UNIQUE-LOCALS NIL)
```

Observed (`OUT-P2c.txt`, `P2d` transcript, quoted):

```
    N=2400  src-nodes  4827 src-octets 123384  exp-nodes 19263  -> :EXPANDED-TERM-OCTETS-EXCEEDED
    N=2492  src-nodes  5011 src-octets 128071  exp-nodes 19999  -> :EXPANDED-TERM-OCTETS-EXCEEDED
    N=2493  src-nodes  5013 src-octets 128122  exp-nodes 20007  -> :EXPANDED-NODES-EXCEEDED
    N=2500  src-nodes  5027 src-octets 128484  exp-nodes 20063  -> :EXPANDED-NODES-EXCEEDED
    N=5000  src-nodes 10027 src-octets 255984  exp-nodes 40063  -> :EXPANDED-NODES-EXCEEDED
```

```
  [01]  MATCH   :EXPANDED-NODES-EXCEEDED via DEFINE-JUDGMENT-SCHEMA with 2500 integer premises
       want :EXPANDED-NODES-EXCEEDED  got :EXPANDED-NODES-EXCEEDED · phase :PERFORM (catalog :PERFORM) · class :PROTOCOL-REFUSAL (catalog :PROTOCOL-REFUSAL)
    refusal detail: host nodes 20063 exceeds ceiling 20000
```

**The adjudication you asked for, kept separate:**

1. **The ORDER argument is exactly backwards.** `%encode-checked`
   (`surface1.lisp:542-573`) runs **depth → nodes → `encode-term` → octets**, and
   the node count is taken on the **host form**, before any encoding. On the
   expanded side, therefore, the octet check **cannot** fire before the node
   check — it is downstream of it in the same function. The note cites the
   correct order and then reasons as if octets came first. The self-suite's M6
   makes the non-sequitur explicit: *"one term costs far more than 13 octets, so
   octets must fire first"* — cost-per-term has no bearing on which of two
   sequential guards runs first. The note even names the true mechanism one
   sentence later, for the source side (*"Its source-side twin is genuinely
   reachable, **because the node check runs BEFORE encoding**"*), and does not
   notice that the same sentence applies verbatim to the expanded side.

2. **The measured constant is wrong too.** *"each term costs roughly 120 octets"*
   — measured (`OUT-P0.txt`): one `T` term = **70** octets; one integer term =
   **56**; inside a list, ~**51** octets/term amortised; the real expansion above
   encodes at **38** octets/node. Because the constant is ~2.4-3× too high, the
   source-side octet ceiling admits ~**5120** terms rather than the ~2000 the note
   assumes. Largest N passing Door 1, bisected: **5120** (`OUT-P2.txt`,
   `src-octets 262104`), refusing at 5121 with `:SOURCE-TERM-OCTETS-EXCEEDED`.

3. **The conclusion is false, not merely accidentally right.** I looked for the
   grounds on which the claim might survive — bounded amplification — and it does
   not. The construct table is closed and I defined no macro; the five Surface /0
   constructs are structure-copiers, but `DEFINE-JUDGMENT-SCHEMA` wraps each
   premise element `p` as `(LISP-PLUS-SLICE1:PROPOSITION-PATTERN 'p)`, which is
   **8 host nodes out of 2** for an atomic premise. Measured amplification ratio
   converges to **3.99–4.00×** (`OUT-P2.txt`, N=100→5000). Four times an
   admissible 5000-node source is 20000 expanded nodes, and the ceiling is 20000.
   The window is not narrow: everything from N=2493 to N=5120 lands here.

**So: `:unreachable-under-this-policy` is a false classification, and it is a
false affordance in the direction the layer says it most fears** — the catalogue
has a documented rule (`surface1.lisp:132-140`) that codes no caller can reach
were *deleted* as false affordances. This is the mirror error: a code every
caller *can* reach, advertised as unreachable, and the self-suite's checks M4 and
M6 certify the false statement green.

**Charge it at its true size.** The *guard* is correct and does its job; nothing
here produces a wrong receipt or a false edge. What is defective is the
**classification, the argument behind it, and the two green checks that ratify
them** — i.e. a truthfulness defect in the layer's account of itself, in a layer
whose whole thesis is truthful accounts.

---

## §3. HOSTILE-STRUCTURE RESULTS

`probes/FOSSOR/P3-hostile.lisp` → `OUT-P3.txt`; `P3e`, `P3f`.
**Through the two doors, every hostile structure refuses. None hangs; none
escapes as a non-refusal error; none reaches a receipt.** Timings are all
sub-20 ms; the 20 s timeout never fired.

```
  spine cycle  (a b c . <back to head>)        REFUSAL :SOURCE-TERM-SHARED-STRUCTURE / upstream "SHARED-OR-CIRCULAR-STRUCTURE" / phase :REQUEST   [0.004s]
  CAR cycle    (quote X) where (car X) = X     REFUSAL :SOURCE-DEPTH-EXCEEDED / upstream NIL / phase :REQUEST   [0.000s]
  cons whose CAR is itself, directly under head REFUSAL :SOURCE-DEPTH-EXCEEDED / upstream NIL / phase :REQUEST   [0.000s]
  dotted list  (quote (1 . 2))                 REFUSAL :SOURCE-TERM-UNREPRESENTABLE / upstream "IMPROPER-LIST" / phase :REQUEST   [0.003s]
  dotted TAIL on the source form itself        REFUSAL :SOURCE-TERM-UNREPRESENTABLE / upstream "IMPROPER-LIST" / phase :REQUEST   [0.000s]
  shared subtree, two paths                    REFUSAL :SOURCE-TERM-SHARED-STRUCTURE / upstream "SHARED-OR-CIRCULAR-STRUCTURE" / phase :REQUEST   [0.000s]
  deep CAR chain, 500 levels                   REFUSAL :SOURCE-DEPTH-EXCEEDED / upstream NIL / phase :REQUEST   [0.000s]
  MIXED: spine cycle whose CAR is also a cycle REFUSAL :SOURCE-DEPTH-EXCEEDED / upstream NIL / phase :REQUEST   [0.000s]
  long proper list, 100000 elements            REFUSAL :SOURCE-NODES-EXCEEDED / upstream NIL / phase :REQUEST   [0.019s]
```

### F2 · The PUBLIC `ENCODE-TERM` and `DECODE-TERM` still die on hostile input — by depth instead of by cycle. NOVEL.

**Claim-sentences defeated, verbatim:**

> `surface1.lisp:365-373` (`ENCODE-TERM` docstring, and it is exported) — *"THE
> GLOBAL SHARING CHECK RUNS FIRST, once, before any recursion.  Doing it here
> rather than in the caller is **what makes this PUBLIC function safe**: in
> Candidate /0 a CAR-position cycle handed straight to ENCODE-TERM **exhausted
> the control stack instead of refusing**."*

> `surface1.lisp:344-346` — *"It is guarded, so it terminates on cyclic input, and
> it iterates on the spine and recurses only into CARs, **so a long list does not
> exhaust the stack**."*

> `ERRATA-0.1 §2` — *"And a CAR-position cycle handed to the **public**
> `ENCODE-TERM` **exhausted the control stack** rather than refusing — **a public
> function turning hostile input into a host accident**."*

**Preconditions:** default SBCL 2.4.6 control stack (2 MB). Acyclic input — the
cycle guard is irrelevant, which is the point.

**Witness** (`P3e-encode-term-stack.lisp`, `P3f`), a plain nested-CAR chain
`(((…(0)…)))`:

```
    depth    1000 -> encoded
    depth   20000 -> encoded
    depth   30000 -> CONTROL STACK EXHAUSTED
    depth  100000 -> CONTROL STACK EXHAUSTED
    %shared-cons-count at depth  20000 -> 0
    %shared-cons-count at depth  40000 -> CONTROL STACK EXHAUSTED
```
Bisected edge (`OUT-P3f.txt`): *"ENCODE-TERM: ok at depth 25222 · CONTROL STACK
EXHAUSTED at depth 25375."* The blowing frame is `%shared-cons-count` — **the
repair itself**: it is guarded against *revisiting*, not against *depth*, and it
recurses once per CAR level.

**The public `DECODE-TERM` is worse: it is not a catchable condition, it is a
fatal image abort.** A term datum built with CD/0 constructors alone (no Surface
/1 door involved), 40000 levels deep:

```
    decode-term on a   5000-deep datum -> decoded
fatal error encountered in SBCL pid 1801391 tid 1801391:
Control stack exhausted while pseudo-atomic, fault: 0x71edc5c97e38
   9: fp=0x71edc5c985f0 pc=0x55194d4b LISP-PLUS-SURFACE1::DECODE-TERM
  10: fp=0x71edc5c98648 pc=0x5519533d LISP-PLUS-SURFACE1::DECODE-TERM
```
— process killed, exit 1, `HANDLER-CASE` powerless. `DECODE-TERM` is public **on
purpose** (`ERRATA-0.1`: *"the inverse is PUBLIC on purpose: the claim that the
stored datum IS what the macroexpander received is only checkable if a reader can
perform the reconstruction independently"*), so the reader invited to check the
layer's central claim can be handed a datum that kills his image.

**Size, stated honestly.** No door-minted object can reach either failure: the
budgeted `%host-depth` refuses at 48 long before, and a stored datum is ≤48 host
levels. This is a **public-surface** defect against arbitrary input, not a door
defect, and it produces no wrong receipt. But the sentence *"what makes this
PUBLIC function safe"* is unqualified and is false as written: the repair moved
the host accident from *cyclic* input to *deep acyclic* input; it did not remove
it. Errata 0.1's own indictment — "a public function turning hostile input into a
host accident" — still applies to the repaired function.

### F3 · A CAR-position cycle lands on `:SOURCE-DEPTH-EXCEEDED`, and the refusal DETAIL reports a saturation artefact as a measurement. NOVEL (minor).

Measured (`OUT-P3.txt` §P3c, `OUT-P3f.txt`):

```
    %host-depth of the CAR-cycle form ..... 51  (ceiling 48)
    %shared-cons-count of it .............. 1
    the code it actually lands under ...... :SOURCE-DEPTH-EXCEEDED
    the code ENCODE-TERM alone would give . :SHARED-OR-CIRCULAR-STRUCTURE
    CAR-cycle form: code :SOURCE-DEPTH-EXCEEDED
      detail ...... "host depth 51 exceeds ceiling 48"
      upstream .... code NIL category NIL
```

Two observations, at different sizes:

- **Imprecise, not false.** The catalogue's note for `:source-term-shared-structure`
  (`surface1.lisp:166-169`) narrates the CAR-position cycle under that entry
  (*"a CAR-position cycle exhausted the control stack"*). That sentence is a
  historical statement about Candidate /0 and is true. But a reader using the
  catalogue to predict which code a CAR cycle now produces will be wrong: through
  the doors it is `:SOURCE-DEPTH-EXCEEDED`, with **no upstream reason at all** and
  no mention of a cycle. The cycle is invisible in the refusal. I record this as
  an imprecision in the catalogue, not a defeated claim.
- **`"host depth 51 exceeds ceiling 48"` is a sentence about a form with no finite
  depth.** 51 is `(+ 2 48) + 1`, the budget-saturation value of `%host-depth`, and
  it appears in the account as if it were a measurement. The code's own comment
  (`surface1.lisp:515`) is precise — *"Saturation always lands ABOVE the ceiling,
  so it always refuses"* — and true; the **detail string** is what over-reports.
  In a layer that will not print a rendering of an object into a datum because "a
  rendering of an object is not the object," a saturation constant presented as a
  measured depth is the same species of slip, one register down.

### The measured depth claims — both CONFIRMED by my own bisection (`OUT-P3.txt` §P3d)

> `package.lisp` / `surface1.lisp:110-117` — *"the largest host form that both
> encodes and decodes is 63 levels deep, bisected and confirmed by exhibiting the
> refusal at 64.  The ceiling here is 48 — inside the measured edge with room for
> the enclosing identity payloads."*

```
    largest host depth that ENCODES *and* DECODES ... 63
    d=63 survives T · d=64 survives NIL
    policy ceiling 48 · headroom in host levels ...... 15
    a form at EXACTLY the ceiling (48) mints a receipt? T
    host form at depth 47 through DOOR 1: :ACCEPTED
```
**Both claims hold in my hands, independently arrived at.** 63/64 is exact; the
15-level headroom is real and a form at the ceiling completes end-to-end.

---

## §4. RUNNER TEETH

Working copy only. `probes/FOSSOR/teeth.sh`, `teeth2.sh`; per-case transcripts in
`probes/FOSSOR/teeth/`, summaries in `SUMMARY.txt` / `SUMMARY2.txt`. Control
(`T0`) reproduces the declared numbers exactly: **115 / 8 / 24 checks, 0 failed;
`verdicts=6 expected=6 confirmed=0`, `verdicts=4 expected=4 confirmed=0`; runner
exit 0.**

### The four you asked for — ALL FAIL CLOSED

| case | mutation | runner exit | mechanism |
|---|---|---|---|
| **T1a** | `REPRODUCTION.lisp` truncated **mid-form** | **1** ✅ | canonical summary matched 0 |
| **T1b** | `REPRODUCTION.lisp` truncated at a **clean form boundary** (summary never reached) | **1** ✅ | canonical summary matched 0 |
| **T2** | `REPRODUCTION-II.lisp` planted crash **before printing anything** | **1** ✅ | instrument exit 1 **and** summary missing |
| **T3a2** | canonical line given a **trailing space** | **1** ✅ | `grep -qxF` rejects it |
| **T3b** | label renamed `REPRODUCTION-RESULT` → `REPRODUCTION-RESULTS` | **1** ✅ | exact-line grep fails |
| **T4** | a selftest check made to fail (`(= 75 …)` → `(= 76 …)`) | **1** ✅ | `114 passed / 1 failed`, selftest exit 1 |
| **T10** | canonical line **present** but instrument then `(sb-ext:exit :code 3)` | **1** ✅ | the wrapper *does* distinguish this — `REPRO1_RAN` is in the success condition |
| **T12** | **the subject regressed**: the Errata 0.2 home-package guard neutered in `surface1.lisp` | **1** ✅ | selftest `111/4 failed`; REPRODUCTION-II `confirmed=2` (findings **A** and **C** CONFIRMED again) — the standing regression gate has real teeth |

T10 answers the sub-question directly: **no**, a nonzero exit with the canonical
line present is not waved through.

### F4 · THE RUN THAT SHOULD FAIL AND EXITS 0 — the fail-open was fixed for two instruments of five. NOVEL.

**Claim-sentences defeated, verbatim:**

> `ERRATA-0.2 §3` — *"**Each instrument** now emits **one canonical
> machine-readable line** … and the wrapper requires the **exact** line plus
> `exit 0` from **each instrument**. A truncated run, a renamed label, an early
> exit and a crash **now all fail closed** — verified by re-running the same
> simulation, which now reports `FAILS CLOSED`."*

> `run-surface1-candidate.sh:50-56` — *"Each instrument now emits ONE canonical
> machine-readable line, and this wrapper requires the exact line — **so a
> truncated run, a renamed label, an early exit or a crash all fail**."*

**Measured: only `errata-0.1/REPRODUCTION.lisp` and `errata-0.2/REPRODUCTION-II.lisp`
emit a canonical line. `surface1-selftest.lisp`, `STUB-IMAGE-FIXTURE.lisp` and
`de-expansione-testata/APPLICATION.lisp` emit none, and the wrapper asks them for
nothing but exit 0** — which they give while running almost nothing, because each
gates on `(when (plusp *failed*) (sb-ext:exit :code 1))` and a check that never
ran never fails.

| case | mutation | selftest/stub/app transcript | **runner exit** |
|---|---|---|---|
| **T5** | selftest truncated at a clean form boundary (after §D), summary re-appended | `== surface1-selftest: 35 checks passed / 0 failed ==` | **0** ❌ |
| **T6** | selftest truncated, summary **and exit gate deleted** | *(no summary line at all)* | **0** ❌ |
| **T7** | selftest gutted to sections A–E | `== surface1-selftest: 50 checks passed / 0 failed ==` | **0** ❌ |
| **T8b** | stub fixture truncated at a clean boundary — **zero checks** | *(no summary line at all)* | **0** ❌ |
| **T9** | application gutted to its preamble | *(no summary line at all)* | **0** ❌ |
| **T11** | application truncated, summary re-appended | `== de-expansione-testata: 0 checks passed / 0 failed ==` | **0** ❌ |

Verbatim from `teeth/SUMMARY.txt`, case T6:

```
T6-selftest-truncated-no-summary           runner exit = 0
        surface1-selftest      exit 0
        stub-image-fixture     exit 0
        de-expansione-testata  exit 0
        reproduction I         exit 0 · canonical summary matched 1 (must be 1)
        reproduction II        exit 0 · canonical summary matched 1 (must be 1)
        == stub-image-fixture: 8 checks passed / 0 failed ==
        == de-expansione-testata: 24 checks passed / 0 failed ==
```
— the selftest's summary line is simply **absent** from that block, and the
wrapper reports peace in the kingdom. This is Errata 0.2's own finding, in its
own words — *"Counting zero of a string is not evidence that the string was ever
going to be printed"* — surviving unrepaired in three of the five instruments,
including the one that carries **115 of the 147 checks**. The banner's headline
numbers (147 checks) are nowhere enforced by the wrapper.

**Cheap cure, since the shape is already in the tree:** give the selftest, the
stub fixture and the application the same canonical line
(`SELFTEST-RESULT checks=115 expected=115 failed=0`, etc.) and grep it `-qxF`.
That is exactly what the two reproductions already do.

---

## §5. TEMPORAL BINDING — ADJUDICATED

`probes/FOSSOR/P5-temporal.lisp` → `OUT-P5.txt`.

**Claim-sentence under test, verbatim:**

> `surface1.lisp:792-793` — *"Version-binding as constant functions, not slots: **a
> receipt cannot disagree with the package that minted it**."*

**Exactly what I did:** minted a receipt; then, in the same image, with the
receipt object untouched, evaluated the single form
`(defun lisp-plus-surface1::expansion-procedure-version () 4)` — one minimal
redefinition of the constant function, which is precisely what loading a bumped
`surface1.lisp` does to a live image. Nothing else was changed.

```
    MINTED at package procedure version 3, policy version 1
    receipt says procedure-version 3 · policy-version 1
    …
    package now reports procedure version ......... 4
    THE OLD RECEIPT now reports procedure version . 4  <-- it MOVED
    the old receipt's IDENTITY is unchanged ....... T
    the old receipt's REQUEST identity unchanged .. T
    a NEW receipt for the SAME source now has a DIFFERENT identity T
```

**Two levels of binding, and only one of them holds:**

- **IDENTITY-LEVEL: HOLDS.** `REQUEST-EXPANSION` commits
  `(%int (expansion-procedure-version))` (and grammar and policy versions) into
  the request identity's octets at mint time (`surface1.lisp:721-734`); the
  occurrence and receipt identities compose over it. Those octets are frozen. A
  receipt minted at v3 keeps v3-derived identity bytes forever, and a v4 image
  mints a different identity for the same source — confirmed above.
- **ACCESSOR-LEVEL: DOES NOT HOLD.**
  `EXPANSION-RECEIPT-PROCEDURE-VERSION` / `-POLICY-VERSION` are constant functions
  that `(declare (ignore r))` and read the **current** package
  (`surface1.lisp:794-801`). The receipt struct has **no version slot at all** —
  slot census in `OUT-P5.txt`: `IDENTITY REQUEST-IDENTITY OCCURRENCE
  OCCURRENCE-IDENTITY SOURCE-FORM-DATUM SOURCE-FORM-IDENTITY EXPANDED-FORM-DATUM
  EXPANDED-FORM-IDENTITY OPERATION CONSTRUCT-IDENTITY EXPANSION-CONTEXT
  DISPOSITION`.

**Does any claim-sentence promise the receipt reports the version THAT MINTED
it?** Not in those words — and that is the fair reading. The sentence promises
only non-*disagreement*, and non-disagreement is achieved trivially by having
nothing to disagree with. But the sentence is placed on the accessors and is the
only thing said about them, and a reader who takes *"a receipt cannot disagree
with the package that minted it"* as a guarantee about **the package that minted
it** will be wrong the moment the two packages differ. Precisely:

> **What is guaranteed:** a receipt's *identity octets* are computed from the
> versions live at mint time and never move afterwards.
> **What is NOT guaranteed, and what the prose oversells:** that a receipt can
> *report* the procedure or policy version under which it was minted. It cannot.
> After a bump it reports the new one, silently, and the old value is recoverable
> from nothing — it survives only as opaque bytes inside an identity that can be
> *compared* but not *read*.

**Is there a post-mint detector? No.**
`:PROCEDURE-VERSION-MISMATCH` is checked once, inside `%MINT-RECEIPT`. Nothing
re-examines a receipt afterwards; the export census shows **no** exported symbol
matching `VERIF`/`CHECK`/`AUDIT`/`VALID` (`OUT-P5.txt` §P5e). Re-reading the
stale receipt after the bump signals nothing: *"the old receipt, re-read after the
bump, signals nothing: no alarm."*

### F5 · The `:PROCEDURE-VERSION-MISMATCH` alarm is VACUOUS in production, not merely internal-only. NOVEL.

`surface1.lisp:834` / `845-847`:
```lisp
(version (or *%fault-procedure-version* (expansion-procedure-version)))
…
(unless (eql version (expansion-procedure-version))
  (%refuse :receipt :procedure-version-mismatch …))
```
With the hook `NIL` — i.e. always, outside this package — the test is
`(eql (expansion-procedure-version) (expansion-procedure-version))`: the package
compared to itself. Measured: `T, always`.

This is a different creature from its two siblings. The identity-projection
alarms compare a **stored** identity against one **recomputed** from the stored
datum — two genuinely different values, which a fault can drive apart; declaring
them planted-fault-only is honest defence-in-depth. The version alarm has **no
second operand**: the receipt stores no version, so there is nothing that could
ever differ. Its catalogue note — *"the receipt's procedure version does not
equal the package's"* — describes a comparison the code does not perform, because
the first term does not exist. Classifying it `:internal-planted-fault-only`
understates: it is not "reachable only from inside," it is **structurally
incapable of being violated**, and the hook does not exercise a real gate but
simulates one.

---

## §6. EVIDENCE SELF-IDENTIFICATION — **THE BINDING IS A CLAIM, NOT A MECHANISM**

`probes/FOSSOR/copy2/`; transcripts `teeth/T20-no-git-no-label.txt`,
`teeth/EV-clean-*.txt`, `teeth/EV-dirty-*.txt`.

**Outside git, no `SURFACE1_SUBJECT_LABEL`** — the disclosed fallback, reproduced:
```
subject     working tree
directory   /…/probes/FOSSOR/copy2/mneme/language-surface-1/
SBCL 2.4.6 · grammar v3 · procedure v3 · policy v1
```
Runner exit 0. The freeze declaration admits this fallback; I confirm it.

### F6 · The subject label is the repository's HEAD, not the content under test — and two materially different subjects produce BYTE-IDENTICAL transcripts. NOVEL.

**Claim-sentences defeated, verbatim:**

> `ERRATA-0.2 §4` — *"Both instruments now **derive** their header and assert
> nothing: `subject <argv[2], or the tree's git short SHA, or "working tree">`"*
> and *"The two captures now **distinguish themselves by content**, not by
> filename."*

> `run-surface1-candidate.sh:33-37` — *"The subject label the instruments print.
> **Derived from the tree under test, never hard-coded to a past subject**"* —
> `SUBJECT_LABEL="${SURFACE1_SUBJECT_LABEL:-$(git -C "$HERE" rev-parse --short HEAD …)}"`

**Witness.** `git init` over a copy of the tree, one commit (`ff80b8f`), a clean
run; then a one-line change to the subject that alters real behaviour and touches
no declared version —
`(defun expansion-policy-max-source-depth () 48)` → `… () 40)` — and a second run:

```
clean exit=0        subject     ff80b8f
dirty exit=0        subject     ff80b8f
actual HEAD: ff80b8f ; working tree dirty:  M mneme/language-surface-1/surface1.lisp

=== diff REPRODUCTION transcripts ===   *** BYTE-IDENTICAL ***
=== diff SELFTEST transcripts ===       *** BYTE-IDENTICAL ***
```

`git rev-parse HEAD` answers *"what was last committed here"*, never *"what is in
these files"*. A modified working tree — the exact state the runner's own
"KNOWN PACKAGING LIMITATION" paragraph says an auditor must work in, since the
runner writes tracked transcripts and needs a writable scratch copy — is labelled
with the SHA of a tree it is not. **The evidence is again wearing a nametag that
is not its own; only the mechanism changed, from a hard-coded string to a stale
commit id.**

**Does anything in the transcript content bind to subject identity?** No.
- `SBCL 2.4.6` — the host, not the subject.
- `grammar v3 · procedure v3 · policy v1` — **self-declared integers inside
  `surface1.lisp`**, changeable independently of every line of code they claim to
  version. Errata 0.2's *"distinguish themselves by content"* rests entirely on
  these; my witness above changed the subject's behaviour and left all three
  untouched, and the transcripts came out byte-identical.
- No digest, no manifest, no file hash, no identity hex appears anywhere in the
  five captures.

**Verdict: a claim, not a mechanism.** The layer mints content-addressed identity
octets all day and spends none of that machinery on the one artefact that has to
say what it measured. The cheap cure is already in the house idiom: hash the
subject files (or emit `identity-octets`/`render-identity-hex` of a manifest
datum over them) into the header, so the transcript is bound to bytes rather than
to a label somebody passes in.

### F7 · The Errata 0.1 finding-4 repair reached one instrument of five. NOVEL, latent only.

> `ERRATA-0.1 §4` — *"`s1` now resolves through `FIND-SYMBOL` and **refuses at
> macroexpansion time unless the symbol is `:EXTERNAL`** — so a suite can no
> longer silently depend on a private name."*

Measured (`grep`, `P7-intern-reach.lisp`): only `surface1-selftest.lisp:28` has
the repaired macro. `STUB-IMAGE-FIXTURE.lisp:25`,
`de-expansione-testata/APPLICATION.lisp:42` and `errata-0.1/REPRODUCTION.lisp:23`
still use bare `INTERN`; `errata-0.2/REPRODUCTION-II.lisp:22` uses `FIND-SYMBOL`
without the `:EXTERNAL` demand. **I then checked whether it bites, and today it
does not** — every `(s1 …)` name in all five files resolves `:EXTERNAL`. So this
is a latent re-opening of the defect class, not a live defect, and the unqualified
sentence "`s1` now resolves through `FIND-SYMBOL`" is true of the selftest and
false of the tree. Worth naming because the *application* is the artefact a
reader is meant to learn the public surface from.

---

## §7. TWO-LINE SUMMARY

**The teeth this layer built for itself are real where they exist — 20 of 20
catalogue entries fired in my hands with code, phase and class all matching, the
depth-63/ceiling-48 measurements reproduce exactly, and the reproduction gates
fail closed against truncation, crash, renamed label, trailing whitespace, a
nonzero exit and a genuine subject regression — but three of the five instruments
never got the canonical result line, so a selftest carrying 115 of the 147 checks
can be cut to 35, or to zero with no summary at all, and the runner still exits 0.**

**And in the one place the layer stakes a claim about what it cannot do, it is
wrong twice over: `:expanded-nodes-exceeded`, advertised "MEASURED UNREACHABLE
UNDER THIS POLICY," fires from the public API on a 2493-premise
`DEFINE-JUDGMENT-SCHEMA` because the node check runs *before* the octet check and
the constructs amplify 4×, while the accessor that reports a receipt's procedure
version reads the live package rather than the minting one and the alarm meant to
catch that compares the package to itself.**

---

*— FOSSOR (Claude Opus 5, 1M context), 2026-07-28. SBCL 2.4.6, every gate
re-fired by hand; the extract tree was read and never written. Probes and
transcripts: `…/surface1-audit/probes/FOSSOR/`.*
