# TABULARIUS — STRANGER AUDIT OF LANGUAGE SURFACE /1, CANDIDATE /0

*Jurisdiction: the CLAIM LEDGER. Every named check read against its code; every
falsifiable claim-sentence checked against the tree or executed.*

```
subject      extract/target/tree/mneme/language-surface-1  (grammar v3 · procedure v3 · policy v1)
runtime      SBCL 2.4.6
probes       probes/TABULARIUS/probe-{A,B,C,D,E}.lisp   (read-only against the subject)
counts       surface1-selftest 115 · APPLICATION 24 · STUB 8   — all execute, all top-level
prereg       NOT read (freeze declaration §6 honoured)
```

**Headline.** One claim in the layer's **exported public contract** is false and I
refuted it by execution: the refusal code `:EXPANDED-NODES-EXCEEDED`, declared
`:unreachable-under-this-policy` and annotated *"MEASURED UNREACHABLE UNDER THIS
POLICY"*, is reachable through the public API in ~15 lines, using one of the five
constructs in the layer's own closed table. The stated mechanism for its
unreachability inverts the order of two gates in the layer's own code.

---

## §1 — MISLABELLED AND NON-LOAD-BEARING CHECKS

Severity key: **HIGH** = the check cannot fail, or its label asserts a fact
nothing in the tree tests · **MEDIUM** = label materially over-states the code, or
two counted checks share one fact · **LOW** = weaker-than-label, still bites ·
**OBS** = observation.

### F-1 · HIGH · `de-expansione-testata/APPLICATION.lisp:389-392` — the census check is a tautology, and the check it advertises does not exist

```lisp
(let ((n (hash-table-count *census*)))
  (desk "distinct FULL identities printed above: ~D" n)
  (check (= n (hash-table-count *census*)) "every printed identity was registered in full")
  (check (> n 6) "the program printed enough distinct identities to be worth checking"))
```

`n` is bound to `(hash-table-count *census*)` on the line above and then compared
to `(hash-table-count *census*)`. **It cannot fail.** The label — *"every printed
identity was registered in full"* — describes a property of `id!`, which is not
tested at all.

Worse, this check sits under the section title **"VIII. THE CENSUS — the
abbreviation did not lie"** and discharges a design note at lines 66-70:

> *"Naive prefixes of lossless identities collapse: two identities sharing a long
> head differ only far into the tail. Every identity PRINTED here registers into
> `*CENSUS*` … so nothing displayed escapes the discrimination check at the foot
> of the program."*

**There is no discrimination check.** `*census*` is keyed by the **full** hex, so
it counts distinct full identities and is structurally incapable of detecting an
abbreviation collision. The stated instrument — comparing the number of distinct
abbreviations against the number of distinct full identities — is nowhere in the
file. Two counted checks stand where the advertised measurement should be, and
neither performs it. This is the third mislabelled check, and it is in the
application, i.e. in the evidence the RETURN §1 points at as where the central
proposition is executable.

### F-2 · HIGH · `surface1-selftest.lisp:508-513` (I4) — a `notany` over a literal the author wrote

```lisp
(ok "I4 the receipt gained NO field naming the object that evaluation produced"
    (notany (lambda (slot) (search "CONTRACT" (symbol-name slot)))
            '(#:identity #:request-identity #:occurrence-identity #:source-form-datum
              #:source-form-identity #:expanded-form-datum #:expanded-form-identity
              #:operation #:expansion-context #:disposition))
    "CONSTRUCT-IDENTITY names the macro asked about, never a produced object")
```

The quoted list is a **literal written by hand**; it is not derived from the
receipt. The check asks whether a constant list of ten uninterned symbols
contains the substring "CONTRACT". **It cannot fail unless someone edits the
literal**, and it would not notice a new receipt slot however named. Reflective
enumeration was available (`sb-mop:class-slots`, one line — probe-A §P6).

The list is also **already stale**. Measured live (probe-A §P6) the receipt's
slots are:

```
IDENTITY REQUEST-IDENTITY OCCURRENCE OCCURRENCE-IDENTITY SOURCE-FORM-DATUM
SOURCE-FORM-IDENTITY EXPANDED-FORM-DATUM EXPANDED-FORM-IDENTITY OPERATION
CONSTRUCT-IDENTITY EXPANSION-CONTEXT DISPOSITION            (12)
```

The literal names 10 and omits `OCCURRENCE` — the field **Errata 0.1 added** —
and `CONSTRUCT-IDENTITY`. A check written to prove a negative about the receipt's
fields does not enumerate two of them, including the one the errata introduced.

### F-3 · HIGH · `surface1-selftest.lisp:166-168` (C3) — comparing a thing to itself

```lisp
(ok "C3 NIL encodes as the SYMBOL COMMON-LISP:NIL — the host does not separate
        the empty list from the symbol, and the grammar does not pretend to"
    (same (s1 encode-term 'nil) (s1 encode-term '())))
```

In Common Lisp `'nil` and `'()` **read to the same object** (`(eq 'nil '())` → `T`,
probe-A §P5). The check therefore compares `encode-term(x)` with
`encode-term(x)` — a pure function applied twice to one argument. It cannot fail
and it tests nothing about the claim in its label. The claim itself is *true*
(probe-A §P5 builds the datum `TERM{KIND=TERMKIND/SYMBOL, VALUE=COMMON-LISP/NIL}`
by hand and it matches) — it is simply **untested by the check that carries it**.

### F-4 · MEDIUM · `surface1-selftest.lisp:436` (G1) and `:450` (G4) — one assertion, two counted checks

A mechanical scan of all 115 `ok` forms (probe: `python3` s-expression walk, see
transcript in this report's §5 note) found **exactly one** pair of byte-identical
assertions:

```lisp
G1 "the host really does expand that form differently twice"
G4 "Surface /0 IS UNMODIFIED BY THIS SUITE — the defect is reported, not repaired"
    ;; both:  (not (equal (macroexpand-1 *nondet-form* nil) (macroexpand-1 *nondet-form* nil)))
```

G4's label asserts a fact about the **suite's conduct** (that it modified nothing
in Surface /0); the expression re-runs G1. The check is not *vacuous* — a suite
that had made the expansion deterministic would trip it — but it is one datum
counted twice, with the second label promoted well past what the datum supports.
`RETURN §8` leans on exactly this pair (*"Selftest G4 and application check 20
both re-assert…"*).

### F-5 · MEDIUM · `surface1-selftest.lisp:317-320` (E10) — "stable" tested against itself

```lisp
(ok "E10 the whole receipt's own identity is a bytes datum and is stable"
    (and (cd0 bytes-datum-p (s1 expansion-receipt-identity *receipt*))
         (same (s1 expansion-receipt-identity *receipt*)
               (s1 expansion-receipt-identity *receipt*))))
```

The second conjunct reads one read-only slot of one object twice and compares the
results. `EQUAL-DATUM` on a datum and itself cannot fail. "Stable" across *what*
is unstated and untested; §I (I2/I3) does the real stability work, across an
intervening evaluation, and does it properly.

### F-6 · MEDIUM · `surface1-selftest.lisp:644-683` (M1/M2) — the coverage claim is false, and coverage is never measured

`*exercised*` (line 644) is a **hand-written list**. Nothing checks that the suite
actually drives each code in it; M1 only checks that each is *declared*. One entry
is wrong:

> `:SOURCE-TERM-SHARED-STRUCTURE` appears in the entire tree exactly three times:
> its catalogue entry (`surface1.lisp:166`), its argument position in
> `request-expansion` (`surface1.lisp:712`), and **the `*exercised*` list
> (`surface1-selftest.lisp:650`)**. No check in `surface1-selftest.lisp`,
> `APPLICATION.lisp`, `STUB-IMAGE-FIXTURE.lisp`, `REPRODUCTION.lisp` or
> `REPRODUCTION-II.lisp` ever produces or asserts a refusal carrying that code.

N4/N4b/N4c exercise the *raw* `ENCODE-TERM` condition, never the Door-1 refusal;
`REPRODUCTION.lisp:235-241` sends a CAR cycle through Door 1 and prints the code
it actually gets — `:SOURCE-DEPTH-EXCEEDED`.

The code is genuinely reachable (probe-A §P4: a source whose `:accepted-clauses`
list holds one cons in two positions refuses at Door 1 with
`:SOURCE-TERM-SHARED-STRUCTURE` / upstream `SHARED-OR-CIRCULAR-STRUCTURE`), so
this is unexercised coverage, not a dead code. Consequently **M2's label is false
as written**:

> *"the :PUBLIC-API codes this suite does not exercise are exactly the two
> expanded-side ceilings … **Nothing else is left uncovered.**"*

Three are uncovered, not two. The check passes only because the falsehood lives
in the list the check reads.

### F-7 · MEDIUM · `surface1-selftest.lisp:94-97` (A5) — label says "reports the length", code says "is a positive integer"

```lisp
(ok "A5 IDENTITY-OCTETS reports the encoded octet length — the unit every
        ceiling in this layer is denominated in"
    (let ((n (s1 identity-octets (cd0 make-bytes-datum (cd0 canonical-octets (tag "x"))))))
      (and (integerp n) (plusp n))))
```

The label states an equality; the code states non-nil-ness of a plausible shape.
An implementation returning `1` for everything passes. (The function is in fact
correct — probe-A §P7: 28 = 28 — the *check* is the defect.) This is the exact
shape named in my charge: *label says "X equals Y", code checks "X is non-nil"*.

### F-8 · MEDIUM · `surface1-selftest.lisp:609-611` (L4) and `:637-639` (L8) — L8 subsumes L4

L4 asserts `EXPANSION-REQUEST-%HOST-FORM` is not `:EXTERNAL`; L8 asserts the
symbol does not exist at all. **A symbol that does not exist cannot be
external**, so L4 is a logical consequence of L8 — two counted checks, one fact.
L4's label additionally claims *"it never reaches a receipt"*, which no part of
either expression tests.

### F-9 · LOW · `surface1-selftest.lisp:603-605` (L2) — "any minted object", three of four named

Label: *"no copier is exported for any minted object."* The enumerated names are
`COPY-EXPANSION-{REQUEST,RECEIPT,REFUSAL}`. The **occurrence** — the fourth minted
object, introduced by Errata 0.1 — is not enumerated. (It has `(:copier nil)`, so
the claim holds; the check just does not cover it.) Same staleness class as F-2.

### F-10 · LOW · `surface1-selftest.lisp:606-608` (L3) — "no setter of any kind" via substring scan

The code searches external symbol *names* for `"SET-"` / `"-SET"`. A `(setf foo)`
function or a `defsetf`/setf-expander carries no such name and would be invisible.
The claim is true in fact (every slot is `:read-only t`, so SBCL defines no setf
expander) but the instrument cannot establish the "of any kind".

### F-11 · LOW · N4b, N4c, N7, O1, O3 — refusal asserted as "some error was signalled"

`(handler-case (progn … nil) (error () t))` accepts **any** error as proof of the
labelled refusal. N4b (line 771-773) at least excludes `storage-condition`, which
is the point of that check and is well done. The others do not name the reason,
though the stronger form was clearly available and is used elsewhere — N7b (821)
and O2 (881) assert the *upstream code* and are the model. O3 in particular
(885-905) carries the load-bearing claim that the **home-package** conjunct does
work the **status** conjunct cannot, and settles for "an error happened".

### F-12 · LOW · `surface1-selftest.lisp:516-539` (I6) — the "FAILING evaluation" is never asserted to fail, and a different receipt is measured

Label: *"a FAILING downstream evaluation leaves the receipt equally unchanged."*
The evaluation is wrapped `(handler-case … (error () nil))` and **nothing asserts
an error occurred** — if Slice /2 silently accepted the form, the check still
passes. Separately, the receipt whose octets are compared is `bad` (tag `i6`)
while the form evaluated comes from a *second, distinct* request (tag `i6b`);
the two are different objects, so the comparison is between a receipt and itself
across an event that never touched it. (Compare APPLICATION `*slice2-refused*`,
lines 248-253, which does it correctly by catching
`lisp-plus-slice2:admission-contract-error` specifically.)

### F-13 · LOW · `surface1-selftest.lisp:176-179` (C6) — "every encoded specimen term" is one specimen.

### F-14 · LOW · `surface1-selftest.lisp:727-741` (N3) — isolation by `(search "alpha" …)`

The check asserts the accounted expansion still *contains* `"alpha"`; it never
asserts the mutated text `"Zlpha"` is **absent**. A leak that appended rather than
replaced would pass. (`REPRODUCTION.lisp:144-150` does this properly, asserting
both directions.)

### F-15 · MEDIUM · `errata-0.1/REPRODUCTION.lisp:274-276, 287-293` — verdict texts claim more than their predicates

This file is a **standing regression gate** whose output the runner requires
verbatim, so its verdict sentences are load-bearing.

- Finding 3's REFUTED text: *"a first-class immutable occurrence object exists and
  is the third value."* The predicate is `(null (find-symbol "EXPANSION-OCCURRENCE-P" …))`
  — the presence of one **symbol**. Neither the third value's type nor
  immutability is tested. (The `line` above prints `type-of`, but printing is not
  asserting.)
- Finding 4's REFUTED text: *"the accessor is exported."* The predicate confirms
  only that it is **not** live-and-internal; a symbol that had vanished entirely
  would also be reported as "exported". A gate that reports the good news when
  the thing it measures is absent is fail-open in the small.

### F-16 · MEDIUM · **disclosed-class, unrepaired outside the selftest** — three instruments still reach the layer through `INTERN`

Errata 0.1 finding 4, second half, is the finding the errata itself calls *"the
more useful"*: *"a suite that reaches through `INTERN` cannot tell whether it is
testing a public surface or a private one."* The repair was applied to
`surface1-selftest.lisp:28-38` only. In the frozen tree:

| file | line | `s1` resolves by | `:EXTERNAL` required |
|---|---|---|---|
| `surface1-selftest.lisp` | 34 | `find-symbol` | **yes** |
| `de-expansione-testata/APPLICATION.lisp` | 42 | `intern` | no |
| `STUB-IMAGE-FIXTURE.lisp` | 25 | `intern` | no |
| `errata-0.1/REPRODUCTION.lisp` | 23 | `intern` | no |
| `errata-0.2/REPRODUCTION-II.lisp` | 22 | `find-symbol` | no |

`REPRODUCTION.lisp` states the defect in its own finding-4 verdict text (line 292)
while committing it three lines from the top of the same file. No instrument
currently reaches a private symbol — I checked every `s1` name used — so this is
a **removed guard, not a live breach**; but the class the errata named is repaired
in one file out of five, and the errata's own numbers (`139`, `147` checks) are
aggregated across all of them.

### F-17 · OBS · `surface1-selftest.lisp:426-429` — the retracted sentence is still live in the tree

```lisp
;;; It refuses, and the refusal is the point: a receipt for a
;;; non-deterministic expansion would be an account that could not be true twice.
```

This is verbatim the sentence Errata 0.1 §5 declares **wrong** ("the most
rhetorically attractive sentence in the candidate — which is why it survived") and
reports as corrected in `package.lisp`, the RETURN, the application and the commit
message. It survives here, twenty lines above **N8**, whose label asserts the
replacement rationale. The application (`APPLICATION.lisp:360-372`) carries the
correction properly. Filed as an observation because it is a section comment
rather than declared contract — but it is a retracted claim, live, contradicted
in the same file.

### Counts

- `surface1-selftest.lisp`: **115** `ok` forms, all top-level, all execute
  (transcript `[001]`–`[115]`). One duplicate assertion pair (F-4); five checks
  that cannot fail or cannot fail meaningfully (F-2, F-3, F-5, F-8-as-redundant,
  F-1 is in the application).
- `APPLICATION.lisp`: **24** `check` forms; transcript `[01]`–`[24]`. ✓
- `STUB-IMAGE-FIXTURE.lisp`: **8**; transcript `[01]`–`[08]`. ✓
- `REPRODUCTION.lisp` 6 verdicts / `REPRODUCTION-II.lisp` 4 verdicts, matching
  their canonical lines. ✓

---

## §2 — THE CLAIM TABLE

### C-1 · **FALSE** · CRITICAL · `surface1.lisp:204-213` (exported catalogue note) — `:EXPANDED-NODES-EXCEEDED` is **not** unreachable

**Claim, verbatim** (`surface1.lisp:204-213`, reachability field
`:unreachable-under-this-policy`, reachable to any client through
`EXPANSION-REFUSAL-CODE-CATALOG` / `REFUSAL-CATALOG-ENTRY-{REACHABILITY,NOTE}`):

> *"the expanded form has more nodes than the declared node ceiling. **MEASURED
> UNREACHABLE UNDER THIS POLICY**: the checks run depth -> nodes -> encode ->
> octets, and each term costs roughly 120 octets, so an expansion meets the
> 262144-octet ceiling at about 2000 nodes and can never approach 20000."*

Restated as fact in: `surface1.lisp:150-152` (the reachability vocabulary,
*"Measured, not assumed — see the note"*), selftest **M4** (`:672-674`) and **M6**
(`:679-683`), `APPLICATION.lisp:307-320` and its printed transcript, and
`LANGUAGE-SURFACE-1-RETURN.md:288-299` (*"the octet ceiling always fires first —
at roughly 2,000 nodes, never near 20,000"*).

**Check performed — refuted by execution** (`probes/TABULARIUS/probe-C.lisp`):

```
DEFINE-JUDGMENT-SCHEMA with 2491 one-atom premises, :macroexpand-1

N=2490  SOURCE depth 4 · nodes 5018 · octets 153273   Door 1 ACCEPTED
        EXPANDED depth 8 · nodes 19994 · octets 784663
        verdict :EXPANDED-TERM-OCTETS-EXCEEDED
N=2491  SOURCE depth 4 · nodes 5020 · octets 153334   Door 1 ACCEPTED
        EXPANDED depth 8 · nodes 20002 · octets 784977
        verdict :EXPANDED-NODES-EXCEEDED          ← the "unreachable" code
        gensyms in the expansion: 0
        catalogue says this code is: :UNREACHABLE-UNDER-THIS-POLICY
```

Every ceiling the source must clear, it clears with room: depth 4 of 48, nodes
5020 of 20000, octets 153334 of 262144. Nothing exotic is used — no hand-built
datum, no internal symbol, no planted fault. `DEFINE-JUDGMENT-SCHEMA` is entry 1
of the layer's own closed table.

**Why the claim failed, both halves:**

1. **The order is inverted.** `%encode-checked` (`surface1.lisp:542-573`) runs
   *depth → nodes → encode → octets*. The note cites that order and then concludes
   *"octets fires first"*. On the expanded side **nodes is checked before the
   encoder ever runs**, so any expansion above 20000 nodes lands on
   `:EXPANDED-NODES-EXCEEDED` whatever its octet count. The only argument that
   could have supported the classification is one about **Door 1** filtering the
   *source* — and that argument is never made anywhere in the tree.
2. **The blowup factor was never measured.** The classification implicitly assumes
   expansion ≈ source. Measured (probe-B): `define-admission-contract` 1.00×,
   `define-slice2-schema` 1.40×, **`define-judgment-schema` 3.98×** — because it
   wraps *every* premise as `(lisp-plus-slice1:proposition-pattern 'p)`
   (`surface0.lisp:137-139`), 8 expanded nodes per 2 source nodes. The application's
   bisection (`APPLICATION.lisp:272-320`) drives only
   `define-admission-contract` — the 1.00× construct — and generalises from it.

**What this does *not* mean.** No false edge, no truthfulness defect: the layer
refuses correctly and mints nothing. What is false is a **published claim about
the layer's own reachability surface**, asserted as measured, restated in five
places, and defended in the RETURN with a paragraph about how the guard was
deliberately *not* made "theatrically reachable". It was already reachable.

**Also note the direction of the tell.** The RETURN §7 records a *method note*
about this very region: an earlier M2 *"claimed all three expanded-side ceilings
were exercised in the application. Two were… It was caught by running the
application and comparing, not by rereading the label."* The same region, one
level deeper, was not run.

### C-2 · **FALSE** · MEDIUM · the catalogue's arithmetic contradicts the tree's own transcript

| claim | where | measured |
|---|---|---|
| "each term costs roughly **120** octets" | `surface1.lisp:208` | **70** (`encode-term 'CL:T`; probe-A §P2, and `RUN-APPLICATION.txt` prints `One term costs 70 octets`) |
| "meets the 262144-octet ceiling at about **2000** nodes" | `surface1.lisp:208-209` | **3744** (`262144/70`; printed in the same transcript) |
| "the octet ceiling always fires first — at roughly **2,000** nodes" | `RETURN:290-292` | same |

The layer's own application prints the refuting numbers in the same run whose exit
code the runner blesses. (The "about 2000" looks like the *clause* count 2012 from
the bisection, which is a count of `:accepted-clauses` entries, not of nodes.)

### C-3 · **FALSE** · MEDIUM · `RETURN:8-13` — "Two claims below are FALSE as written and are corrected in place, marked ⚠ CORRECTED"

Two `⚠ CORRECTED` markers exist (`:143` and `:324`) and both are apt. At least two
further claims in the RETURN are false as written post-errata and carry **no
marker**:

- **`RETURN:183-184` (§4 answer 8):** *"the same request performed twice yields the
  same occurrence identity (selftest **E11**)."* Errata 0.1 finding **1c** is
  precisely the ruling that E11 *never performed the same request twice* — it built
  a fresh equivalent request — and that the same-object claim now lives in **E11b**.
  The RETURN still cites E11 for the property E11 was found not to test. This is
  the mislabelled-check defect surviving in the document that inventories the
  claims.
- **`RETURN:457-458` (§11):** *"a sharing/DAG representation, **since the grammar
  unfolds shared structure** and refuses cycles."* Errata 0.1 finding 2 replaced
  unfolding with a global refusal; `surface1.lisp:374-378` refuses. The sentence
  describes the pre-errata grammar.

Because the banner states a **count**, each unmarked false claim falsifies the
banner as well as itself.

### C-4 · **FALSE** · MEDIUM · `RETURN` citations of application check numbers

| citation | claimed | at `2e21f367` (pre-errata capture) | today |
|---|---|---|---|
| `RETURN:342-343` "application check **20**" (the nondeterminism re-assertion) | 20 | **21** | **22** |
| `RETURN:399-400` "Application checks **7–9**" (the absence checks) | 7–9 | 7–9 ✓ | **8–10** |

The first was **wrong when written** — at `2e21f367` check 20 was *"an expansion
bearing an implementation-generated name is REFUSED"*
(`errata-0.1/pre-errata-evidence/RUN-APPLICATION.txt:121`). The second was correct
then and drifted when Errata 0.1 inserted a check at position 2; it is unmarked.

### C-5 · **FALSE** · MEDIUM · "the receipt's fields, **exhaustively**" omits a field that exists

- `de-expansione-testata/APPLICATION.lisp:181-186` — a **live, current** evidence
  artifact, printed in today's `RUN-APPLICATION.txt` — lists eleven fields plus the
  package constants under the word *exhaustively*. The receipt has **twelve**
  slots; `OCCURRENCE` is missing (probe-A §P6), and `EXPANSION-RECEIPT-OCCURRENCE`
  is an **exported** accessor (`package.lisp:323`).
- `RETURN:392-396` carries the same list under the same word. There it is
  *superseded-by-drift* (correct at `2e21f367`, unmarked now). In the application it
  is simply false in the current tree.

### C-6 · **FALSE AS STATED / conclusion holds** · MEDIUM · `ERRATA-0.2 §2` + `surface1.lisp:196-201, 806-812` — "decode is injective for every admissible datum"

**Claim:** *"With the home-package guard in place, **decode is injective for every
admissible datum**, so NO PUBLIC INPUT CAN REACH the round-trip mismatch — the
earlier, more precise guard always fires first."*

The freeze declaration §5 names this the claim most likely to be wrong. It is
wrong, though not in the way that would produce a second false edge.

**Executed (probe-E):**

```
CASE 1 — datum naming the package by NICKNAME
  decode(TABE-NICK/W) → TABE-REAL::W ; home package TABE-REAL ; guard SILENT
  re-encode == the decoded datum? NIL     (encode writes the PRIMARY name)

CASE 2 — two DISTINCT data decoding to ONE symbol
  A = SYMBOL{ns ("TABE-REAL"), path ("W")}
  B = SYMBOL{ns ("TABE-REAL" "IGNORED-SECOND-SEGMENT"), path ("W" "IGNORED")}
  equal-datum(A,B) = NIL ;  decode(A) EQ decode(B) = T
  ⇒ DECODE-TERM is NOT injective on the data it accepts
     (%SEG, surface1.lisp:442-443, reads segment 0 and discards the rest)

CASE 3 — encode(decode(B)) == B ?  NIL
  ⇒ for this class the symbol guard is silent and ONLY the round-trip gate bites
```

So: (a) the injectivity premise is false; (b) *"the earlier, more precise guard
always fires first"* is false for the nickname and multi-segment classes — the
round-trip gate is the sole catcher there, i.e. **not** pure defence in depth for
that class. The **conclusion** nevertheless holds, for a reason the errata does not
give: a request can only ever hold `ENCODE-TERM` output, and `ENCODE-TERM`
(`surface1.lisp:396`) always writes exactly one namespace segment carrying the
home package's **primary** name, so no such datum can reach Door 2. `DECODE-TERM`
is public and does accept them — which matters, because the errata's stated
justification for publishing it is that *a reader can perform the reconstruction
independently*. A reader who does so with a nickname-named datum gets a silent
non-round-tripping reconstruction.

This is the same defect shape as C-1: **the conclusion survives, the published
mechanism does not.** Twice in one tree, in the two places where reachability is
argued rather than exercised.

### C-7 · **TRUE** · `surface1.lisp:132-140` + `RETURN:248-252` — the two deleted false affordances are genuinely unreachable

Claim: `:CONSTRUCT-PACKAGE-ABSENT` and `:CONSTRUCT-SYMBOL-ABSENT` are unreachable
because *"Door 2 reaches the package lookup only after `%LOOKUP-CONSTRUCT` matched
on `(package-name (symbol-package head))` — so the package provably exists, and the
symbol provably exists in it."*

I walked `%resolve-macro` (`:909-925`) against the adversarial cases my charge
named and the argument holds:

- `%lookup-construct` matched ⇒ `(symbol-package head)` is non-`NIL` and its
  `package-name` is `string=` to `"LISP-PLUS-SURFACE0"`. `FIND-PACKAGE` on that
  string resolves by name-or-nickname over a registry in which names are unique
  and a nickname may not collide with a name, so `target-pkg` is **that same
  package**. `(find-package (first entry))` cannot fail.
- `(find-symbol (second entry) target-pkg)` cannot fail either: `head`'s home
  package is `target-pkg`, and a symbol whose home package is P is present in P
  (`UNINTERN` from the home package sets `SYMBOL-PACKAGE` to `NIL`, which would
  have failed the lookup one step earlier; `SHADOWING-IMPORT` uninterns the
  conflicting symbol, same result).
- No user code runs between reconstruction and resolution — `perform-expansion`
  calls `%reconstruct-source` then `%resolve-macro` with no intervening callback
  (the layer accepts none), so no mutation window exists.
- The argument does **not** depend on the Errata 0.2 home-package guard: even
  pre-0.2, `%lookup-construct` keys on `(symbol-package head)`, i.e. on the home
  package by construction.

Verdict **TRUE**. Noting the asymmetry that follows: the layer's *reasoned*
unreachability claim about deleted codes is sound, while its *asserted-as-measured*
unreachability claim about a live code (C-1) is false.

### C-8 · **TRUE** · `package.lisp:169-180` / `RETURN:262-274` — the depth-edge numbers

Executed (probe-D): a host form nested **201** levels encodes without complaint
(so does 500); the largest nesting that both encodes and **decodes** is **63**; the
smallest that fails decode is **64**. Ceiling 48 is inside that edge. ✓

### C-9 · **TRUE** · the census numbers

| claim | source | verified |
|---|---|---|
| 75 declared exports == 75 live | `ERRATA-0.1 §7`, selftest L5/L6 | 75 in `package.lisp`, **75** live external, **0** duplicates (probe-A §P1) |
| catalogue 20 entries · 17 protocol · 3 alarms | `ERRATA-0.1/0.2 §7` | 20 / 17 / 3 ✓ (counted in `+refusal-catalog+`) |
| 115 + 8 + 24 = 147 checks | `ERRATA-0.2 §7` | ✓ (transcripts) |
| 107 + 8 + 24 = 139 | `ERRATA-0.1 §7` | ✓ arithmetic |
| 90 + 8 + 23 = 121 | `RETURN §2` (superseded, so marked) | ✓ arithmetic; matches the pre-errata captures |

### C-10 · **TRUE** · `surface1.lisp:126-128` — "deliberately NO flat list of all codes"

Exported are `EXPANSION-REFUSAL-CODE-CATALOG` (the table, entries intact),
`EXPANSION-PROTOCOL-REFUSAL-CODES` and `EXPANSION-INTEGRITY-ALARM-CODES`. No
export yields a flat all-codes list. (Trivially derivable by the client, which the
claim does not deny.) ✓

### C-11 · **TRUE, with a wording note** · `ERRATA-0.1 §2` / selftest F5 — "3 conses reachable by more than one path AND 13 uninterned symbols"

Measured on the full expansion of the control form (probe-A §P3): **3** shared
conses (max refcount 2, 94 distinct conses) and **13 uninterned symbol
occurrences** — but only **4 distinct** uninterned symbols. "13 uninterned
symbols" is a count of occurrences. F5b's code counts occurrences too, so the
document and the check agree; a reader will read "13 symbols" as 13 symbols.

### C-12 · **UNVERIFIABLE FROM THE PACKET** (recorded, not charged)

`form floor 199/0` · `language floor 654/0` · `verify-all 6/6` · *"`git diff`
across CD/0, Slice /1, Slice /2, Surface /0 and Form /0/1/2 is empty"* · commits
`2e21f367`, `4f5c5982`, `65782d5c`, `0595c68e` · *"the subject subtree is
byte-identical to the repository's, verified by `diff -r`"*. None of these can be
checked from inside the frozen packet: the floors' scripts are not carried and
there is no `.git`. They are claims about a repository the auditor cannot see.

---

## §3 — EXPORT AUDIT

**Declared vs live: clean.** `package.lisp` declares **75**; `do-external-symbols`
finds **75**; no duplicates; L5's three-predicate census (`fboundp` / `boundp` /
`find-class`) is the right shape and finds nothing dead (probe-A §P1 reproduces the
list in full).

**Documented-as-absent, and genuinely absent** ✓ — `:CONSTRUCT-PACKAGE-ABSENT`,
`:CONSTRUCT-SYMBOL-ABSENT` (B4), `EXPANSION-REQUEST-%HOST-FORM` (L8),
`MAKE-EXPANSION-{REQUEST,RECEIPT,REFUSAL}`, `COPY-*` (L1/L2), no
`:MACROEXPAND-ALL` (D7), no symbol naming `SURFACE0` (A6), no
`EXPANSION-RECEIPT-{MEANING,ENVIRONMENT}` (application 8/9).

**Exported but omitted from every "exhaustive" field list** — `EXPANSION-RECEIPT-OCCURRENCE`
(`package.lisp:323`). See **C-5**; also missing from selftest I4's literal (**F-2**)
and unmentioned in `RETURN §10`. It is the one export in the tree that no document
inventories.

**Struct type names are not exported** — `EXPANSION-{REQUEST,RECEIPT,REFUSAL,OCCURRENCE}`
are reachable only through their `-P` predicates and accessors. Consistent with
*"no public constructor"* and with Errata 0.1 finding 3's *"a first-class immutable
occurrence object… can be handed around, asked questions, and denied a public
constructor"* — a client can ask it questions but cannot `typep` or specialise on
it. Observation only; no document claims otherwise.

**Documented-as-public and public** ✓ — `DECODE-TERM` (Errata 0.1's *"public on
purpose"*), all five `REFUSAL-CATALOG-ENTRY-*` accessors (Errata 0.1 finding 4;
confirmed `:EXTERNAL` live), `ENCODE-TERM`, `IDENTITY-OCTETS`,
`RENDER-IDENTITY-HEX` (marked diagnostic-only in code and never composed into an
identity — `%identity` at `:50` uses `%octets`, not hex ✓).

---

## §4 — EVIDENCE IDENTITY

### E-1 · The packet's own integrity check FAILS as delivered — 2 of 48

`FREEZE-DECLARATION.md §1` instructs, *"Verify before reading anything else:
`cd target && sha256sum -c SHA256SUMS.txt`"*. Run read-only against the packet as
handed to me:

```
./tree/mneme/language-surface-1/RUN-REPRODUCTION-II.txt: FAILED
./tree/mneme/language-surface-1/RUN-REPRODUCTION.txt:    FAILED
sha256sum: WARNING: 2 computed checksums did NOT match      (exit 1)
```

`SHA256SUMS.txt` itself still digests to the declared
`63945091be544baa9721fdb600d24748675a94a77146a337dd7e7e786fb04096`, so the manifest
is intact and the **transcripts** moved. The cause is structural, not tampering:
the gate was re-run **inside the target** (all six `RUN-*.txt` carry a later mtime
than the rest of the tree), and exactly the two transcripts that print an
**absolute directory path** cannot reproduce their frozen bytes outside the
directory they were frozen from. The other four are path-free and re-ran
byte-identical.

The packet therefore contains two instructions that cannot both be satisfied in
place: §1 *"verify the manifest"* and §3 *"run the runner"* (§3 does say to copy
the tree first — the copy that reached me had been run in situ). Nothing in the
declaration lists an expected-to-change set. A stranger following §1 literally
meets a checksum failure as their first observation, with no note telling them
whether it matters. **This is a walk-the-recipe defect in the freeze packaging,
not in Surface /1's semantics** — but the packet's opening instruction is the one
step whose failure most looks like something else.

Consequence for the record: **the frozen bytes of the two reproduction transcripts
are not recoverable from this packet.** What I read are today's, naming today's
extract directory.

### E-2 · The subject label is an assertion supplied from outside the instrument

Errata 0.2 §4 says the instruments *"now derive their header and assert nothing"*,
and the freeze declaration repeats it. What the instruments derive is the
**directory** (`truename`) and the **versions** (called live) — both genuinely
derived and both good. The **subject** line is `argv[2]`
(`REPRODUCTION.lisp:50`, `REPRODUCTION-II.lisp:30`), defaulting to
`"<unlabelled subject>"`; the git-SHA fallback lives in the shell wrapper
(`run-surface1-candidate.sh:37`), and outside a checkout it yields `working tree`.
Today's transcripts read `subject frozen 65782d5c` because
`SURFACE1_SUBJECT_LABEL` was set as the declaration instructs. That string is a
claim about a repository commit which **nothing in the packet can corroborate**,
printed beside a `directory` line naming a scratch path. The repair over the
hard-coded banner is real and material; "asserts nothing" over-states it by one
field, and it is the field a reader keys on.

### E-3 · The pre-errata captures do identify their subjects — correctly and by content ✓

| capture | subject line | versions | counts |
|---|---|---|---|
| `errata-0.1/pre-errata-evidence/REPRODUCTION-OUTPUT-2e21f367.txt` | `Candidate /0 (2e21f367)` | grammar **v1** · procedure **v1** | 6 of 6 CONFIRMED |
| `errata-0.1/pre-errata-evidence/RUN-SELFTEST.txt` | header `CANDIDATE /0` | **v1 · v1 · v1** | **90** checks |
| `errata-0.1/pre-errata-evidence/RUN-APPLICATION.txt` | — | **v1 · v1 · v1** | **23** checks |
| `errata-0.2/pre-errata-evidence/REPRODUCTION-II-OUTPUT-4f5c5982.txt` | `Errata 0.1 (4f5c5982)` | grammar **v2** · procedure **v2** | 4 of 4 CONFIRMED |
| today's `RUN-REPRODUCTION*.txt` | `frozen 65782d5c` | **v3 · v3** | 0 of 6, 0 of 4 |

Errata 0.2 §4's claim that *"the two captures now distinguish themselves by
content, not by filename — Errata 0.1 reports grammar v2 · procedure v2; this tree
reports v3 · v3"* is **TRUE and verified**, and the version-triple discriminates
all four generations. Each capture's directory line names a distinct session path,
so no capture claims to have measured a tree it did not. The one thing no capture
carries is the manifest digest of the tree it ran against — the version triple is
doing that work, and it is coarse (it identifies a *generation*, not a *tree*).

### E-4 · The claimed before/after pairing is coherent ✓

`REPRODUCTION.lisp` is API-agnostic by construction (`occ-id`, lines 42-44, accepts
either Candidate /0's bare identity or Errata 0.1's occurrence object), which is
what makes the before/after captures a comparison of two subjects rather than two
instruments. That is a genuinely careful piece of work and it holds up on reading.

### E-5 · The runner's fail-closed repair is real ✓

`run-surface1-candidate.sh:66-71, 120-122` requires both the exact canonical
summary line (`grep -qxF`) **and** `exit 0` from each reproduction, and the exit
codes are recorded separately in `RUN-EXITCODES.txt`. The Errata 0.2 §3
fail-open defect is genuinely closed. (The wrapper hard-codes `verdicts=6` and
`verdicts=4`, so adding a verdict to either instrument without editing the wrapper
fails closed — the right direction.)

---

## §5 — SUMMARY, TWO LINES

**One published claim in the layer's exported contract is false and I refuted it by
execution — `:EXPANDED-NODES-EXCEEDED`, declared "MEASURED UNREACHABLE UNDER THIS
POLICY" and defended in five documents, is reached from the public API by
`DEFINE-JUDGMENT-SCHEMA` with 2491 premises, because the note's own cited gate
order (`nodes` before `octets`) contradicts its conclusion and the 3.98× expansion
blowup of that construct was never measured; the same shape recurs in Errata 0.2
§2, whose injectivity premise is false while its conclusion survives for an unstated
reason.**

**The third mislabelled check exists and there are several: the application's census
check `(= n (hash-table-count *census*))` cannot fail and the abbreviation-collision
check its section advertises does not exist anywhere; selftest I4 tests a hand-written
literal that is already stale by two receipt fields; C3 compares `encode-term` of one
object with itself; G1 and G4 are byte-identical assertions under different labels; and
M2's "nothing else is left uncovered" is false because `:SOURCE-TERM-SHARED-STRUCTURE`
is listed as exercised while no check in the tree ever produces it.**

---

*— TABULARIUS, 2026-07-28. Claude Opus 5 (1M context). Prereg not read. Probes at
`probes/TABULARIUS/probe-{A,B,C,D,E}.lisp`; nothing in the subject tree was
modified — verified by re-running `sha256sum -c` after the probes, which reports
the same two files and no others.*
