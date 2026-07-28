# SPECULUM — REPAIR OF `surface1-selftest.lisp` UNDER ERRATA 0.3

*Jurisdiction: ONE FILE — `surface1-selftest.lisp`. Nothing else in the tree was
edited. `surface1.lisp`, `package.lisp` and everything under `audits/` were read
only; `git diff` against HEAD confirms no change to any of them from this hand.*

*Controlling inventory: `audits/2026-07-28-stranger-audit/findings/TABULARIUS.md`
§1 (F-1…F-17). Checklist: `errata-0.3/D8-DISPOSITIONS.md`. Ledger:
`errata-0.3/DEFECT-LEDGER.md`.*

```
runtime            SBCL 2.4.6
command            sbcl --non-interactive --load surface1-selftest.lisp
before             111 passed / 4 failed   (L6, M2, M4, O6 — all four expected)
after              139 checks / 0 failed   · exit 0 · ~6.7 s wall
                   (SUPERSEDED by §8: 3.28 s after the chair's DECODE-TERM repair)
canonical line     SELFTEST-RESULT checks=139 expected=139 failed=0
declared literal   *expected-checks* = 139, at the head of the file
old total          115 — NOT preserved, and not a target; see §5
```

---

## 1 — PER-ITEM DISPOSITION TABLE

`teeth` = a fault was planted against the thing the check asserts and the check
was **observed red** (transcripts in §4). `—` = not teeth-tested; the reason is
given in the row.

| item | disposition taken | what I did | checks now | teeth? |
|---|---|---|---|---|
| **F-1** | *(not mine)* | APPLICATION.lisp census — another hand's jurisdiction. Untouched. | — | n/a |
| **F-2** | REPLACE | I4's hand-written ten-symbol literal deleted. The receipt's slots are now enumerated reflectively from the live class (`sb-mop:class-slots`) and TWO things are asserted: the negative the label states (no slot name contains "CONTRACT") **and the full 15-slot census**, so a slot added by a later erratum turns the check red instead of sailing past. The old literal was stale by two fields (`OCCURRENCE`, added by Errata 0.1, and `CONSTRUCT-IDENTITY`). | **069** | ✅ T3 |
| **F-3** | REPLACE | C3 compared `encode-term 'nil` with `encode-term '()` — one object, twice. It now compares against a **hand-built** `TERM{KIND=TERMKIND/SYMBOL, VALUE=COMMON-LISP/NIL}`; the `'()` identity is stated as a consequence, not offered as the evidence. | **016** | ✅ T2b |
| **F-4** | MERGE | G4 **deleted**. Its expression was byte-identical to G1's; its label was a claim about the *suite's conduct*. G1 keeps the nondeterminism datum and its label now names, in one sentence, the conduct fact the datum can actually bear; the fuller statement sits in prose beside it. | **058** (G4 gone) | — (deletion) |
| **F-5** | NARROW | E10's self-comparison conjunct deleted (`EQUAL-DATUM` on a datum and itself cannot fail). Label narrowed to *"the whole receipt's own identity is a bytes datum"*. The real stability work already lives in I2/I3, across an intervening evaluation. | **045** | — (narrowing; I2/I3 unchanged) |
| **F-6** | REPLACE | The hand-written `*EXERCISED*` list is **gone**. A live registry (`*OBSERVED-CODES*`, fed by `OBSERVE` at every refusal-acquisition site) records the code of every refusal this run actually produces. The coverage section was **moved to the foot of the file** — it used to measure before sections N and O had run. A real Door-1 shared-structure check was added (P17), producing the `:SOURCE-TERM-SHARED-STRUCTURE` the old list falsely claimed as exercised. | **133–139**, **127** | ✅ T12 |
| **F-7** | REPLACE | A5's `(and (integerp n) (plusp n))` — which an implementation returning 1 for everything passes — replaced by an equality against a length computed **without calling `IDENTITY-OCTETS`**, over three data of different sizes, plus an assertion that the three answers are three distinct numbers. | **005** | ✅ T1 |
| **F-8** | MERGE | L4 **deleted** (a symbol that does not exist cannot be `:EXTERNAL`, so L4 was a consequence of L8). L8's label now carries the absence claim exactly, including the "never reaches a receipt" half, which is true *because* there is no slot and no name. | **087** (L4 gone) | — (deletion) |
| **F-9** | REPLACE | L2's enumeration extended to the fourth minted object: `COPY-EXPANSION-OCCURRENCE`. | **081** | — (absence check; see note §6) |
| **F-10** | NARROW + PROSE | L3's label now states exactly what is scanned: *"no EXTERNAL SYMBOL NAME names a SET-style mutator — a name scan, and only a name scan."* The wider "of any kind" claim moved to prose citing `:read-only t` on every slot as the real owner, with an explicit note that this is a property of the `DEFSTRUCT` forms and not something the scan measures. | **082** | — (narrowing) |
| **F-11** | REPLACE | N4b, N4c, N7, O1, O3 no longer accept "some error was signalled". Two helpers (`TERM-UNREPRESENTABLE-REASON`, `TERM-IRRECONSTRUCTIBLE-REASON`) return the exact reason keyword, or a list naming whatever else was signalled. N4b → `:SHARED-OR-CIRCULAR-STRUCTURE` (keeping its `STORAGE-CONDITION` exclusion, which was the point of that check and was well made); N4c → same; N7 → `:SYMBOL-ABSENT-IN-IMAGE`; O1 → `:SYMBOL-NOT-HOME-IN-NAMESPACE`; **O3 → `:SYMBOL-NOT-HOME-IN-NAMESPACE` exactly**, which is the load-bearing one: a status-only guard would have passed that datum *without error*, so "an error happened" left the whole conjunct-distinguishing claim resting on a predicate any failure satisfies. | **093, 094, 098, 101, 103** | ✅ T7/T8/T14 exercise the same helper path; O3's reason is asserted by identity |
| **F-12** | REPLACE | I6 rebuilt. **One** receipt is minted, and the form evaluated is **that receipt's own** expansion (Candidate /0 measured receipt `i6` while evaluating a form from a second request `i6b`). The failure is now **asserted by condition type** — `lisp-plus-slice2:admission-contract-error` — so a silently-accepting Slice /2 turns the check red instead of leaving it green. Both the identity and the stored expanded datum are compared before/after. | **071** | ✅ T4 |
| **F-13** | NARROW | C6's label named "every encoded specimen term" and checked one. It now names the one: *"the encoding of `*SPECIMEN*`, the one control term this suite carries throughout."* | **019** | — (narrowing) |
| **F-14** | REPLACE | N3 asserts **both directions**: `"alpha"` present **and** `"Zlpha"` absent. A leak that appended rather than replaced now goes red. | **090** | ✅ T13 |
| **F-15** | *(not mine)* | `errata-0.1/REPRODUCTION.lisp` — another hand's jurisdiction. Untouched. | — | n/a |
| **F-16** | *(not mine)* | Instrument `s1` helpers in four other files — another hand's jurisdiction. **This file's `s1` already resolves via `FIND-SYMBOL` requiring `:EXTERNAL` and that discipline is preserved throughout**, including in every check added here. | — | n/a |
| **F-17** | DELETE | The retracted nondeterminism sentence (*"a receipt for a non-deterministic expansion would be an account that could not be true twice"*) is **deleted** from the section-G comment and replaced by a supersession note pointing at Errata 0.1 §5 and at N8, which executes the replacement rationale. | (comment) | — (prose) |
| **M4/M6 (D1)** | REPLACE | M4's catalogue-field-read-back-to-itself and M6's "arithmetic behind M4" (the arithmetic of an argument that does not hold) are **both gone**. Replaced by an executable public witness: Door 1 **accepts** a `DEFINE-JUDGMENT-SCHEMA` with 2491 atomic premises (P12), Door 2 refuses with **exactly** `:EXPANDED-NODES-EXCEEDED` (P13), the catalogue field reads `:PUBLIC-API` and **no** code anywhere is declared `:UNREACHABLE-UNDER-THIS-POLICY` (P14), and the retracted "octets fire first" order is refuted by one premise: 2490 → octets, 2491 → nodes (P15). | **122–125**, **137** | ✅ T10 |

---

## 2 — THE FOUR FAILING CHECKS, REPAIRED TRUTHFULLY

**L6 → checks 084 / 085.** The old form was `(= 75 (length *declared*))` — a literal
beside a measurement, whose only failure mode is "someone changed the package and
forgot this line." It is now a **two-source reconciliation**: the `:export` clause
is read out of `package.lisp` **with the host reader** and its length compared
against the live `do-external-symbols` count (084). A symbol exported by some
later `export` call the `defpackage` never mentioned breaks it. The live figure
is then **stated** as 80 (085), and both print their numbers as detail.

**M2 → check 134.** Measured, not read. `*OBSERVED-CODES*` is built from refusals
this run actually obtained; `*uncovered*` is `set-difference` of the catalogue's
`:PUBLIC-API` codes and that set. **The measured remainder is EMPTY** — 16 of 16
`:PUBLIC-API` codes were produced in this process by this file. That required
driving three codes the suite had never driven: `:SOURCE-TERM-SHARED-STRUCTURE`
(P17), `:EXPANDED-TERM-OCTETS-EXCEEDED` (P15), `:EXPANDED-DEPTH-EXCEEDED` (P16).
The section prints the observed count (19) and the uncovered list before asserting,
so the figure travels with the verdict. Three companion checks were added because
one number is not a measurement: M1 (every observed code is declared), M2b (the
observed set is a catalogue subset and strictly larger than the public set), M5
(**every** `:INTERNAL-PLANTED-FAULT-ONLY` alarm actually fired — a gate that has
never fired is untested, not passing), M6 (both node ceilings observed, so the
source/expanded pair is covered by observation rather than by an argument about
which check runs first).

**Cap, stated in the file and repeated here: that a code FIRED is not that the
guard behind it is correct.** Coverage is a statement about this suite's reach and
about nothing else.

**M4 → check 137.** No longer reads a field back to itself. It asserts that **no**
code is declared `:UNREACHABLE-UNDER-THIS-POLICY`, that `:EXPANDED-NODES-EXCEEDED`
now reads `:PUBLIC-API`, **and that this run observed it** — the claim is retired
by a witness, not by an edit.

**O6 → check 108.** Asserts grammar **4**, procedure **4**, policy **1**, with the
reasons this errata gives written into the label, plus the three policy numbers the
ruling says did not move (48 / 20000 / 262144) — because "policy stays 1" is a
claim about ceilings, and it should fail if a ceiling moved.

---

## 3 — THE NEW REGRESSIONS (section P), EACH OF WHICH FAILS IF ITS REPAIR IS REVERTED

| repair | checks | what bites |
|---|---|---|
| **D2** compound-`TYPE-OF` crash | 109 (P1), 110 (P2), 111 (P3) | `#C(1 2)`, `(vector 1 2 3)`, a 2-D array — each through **both** doors. P1 asserts the designed `:SOURCE-TERM-UNREPRESENTABLE` / `NO-TERM-KIND` / `term-encode` through the signalling door; **P2 deliberately catches nothing** around `TRY-REQUEST-EXPANSION`, so a host condition escaping there kills the run rather than being absorbed; P3 asserts the detail names the type family and is ≤40 chars. |
| **D5** term-depth ceiling | 112–116 (P4–P8) | `TERM-DEPTH-CEILING` exported and = 2000 (P4); `ENCODE-TERM` works at exactly 2000 host levels and refuses at 2001 with `:TERM-DEPTH-EXCEEDED` (P5); `DECODE-TERM` works at datum-depth 2000 and refuses at 2001 (P6); the asymmetry recorded (P7, see §6); cycles and sharing still refuse with their own reason, so the iterative rewrite kept its verdicts (P8). |
| **D3** decode narrowing + the two public round-trip routes | 117–121 (P9–P11b) | A surplus-segment datum refuses `:SYMBOL-IDENTIFIER-SHAPE` (P9) while the one-segment datum it shadowed still decodes (P9b). **Mechanism 1** — `rename-package` keeping the old name as a nickname (P10). **Mechanism 2** — `sb-ext:add-package-local-nickname` in the caller's ambient `*PACKAGE*`, mutating nothing at all (P11). Each asserts `:SOURCE-NOT-RECONSTRUCTIBLE` / upstream `ROUND-TRIP-MISMATCH` / phase `:PERFORM` and that **nothing was minted** (all three values nil-or-refusal). P11b performs the same request from a package with no nickname and shows it **crosses** the gate — so the refusal is caused by the dynamic context and nothing else. Both fixtures restore the image under `UNWIND-PROTECT`. |
| **D1** the reachable node ceiling | 122–126 (P12–P16) | Door 1 accepts with source depth and nodes measured under their ceilings; Door 2 refuses exactly `:EXPANDED-NODES-EXCEEDED`; the catalogue field reads `:PUBLIC-API`; 2490 vs 2491 exhibits that neither expanded-side ceiling dominates; and the third expanded ceiling is driven too. |
| **D7** version binding by value | 128–132 (P18–P22) | The **request** carries readable captured versions (P18). The live `EXPANSION-PROCEDURE-VERSION` is redefined to 99 under `UNWIND-PROTECT`; the old receipt still reports **4** (P19) and its identity octets are unchanged (P20); the definition is restored and the restoration is itself asserted inside P19. P21 drives `:PROCEDURE-VERSION-MISMATCH` from a **real two-operand comparison** — a request minted before the move, performed after it. P22 shows the alarm is not stuck on. |

`E8` was also repaired here, though the audit did not flag it: its label read
*"procedure and policy versions come from the PACKAGE, not from a slot — a receipt
cannot disagree with the package that minted it."* **That is the D7 defect described
as a virtue**, and it would have gone on certifying the repaired layer with the
broken layer's rationale. It now says the versions are **stored at mint** and equal
the package's only in an image that has not moved.

`O5` was likewise repaired unflagged: its label was *"NO PUBLIC INPUT CAN REACH THE
ROUND-TRIP MISMATCH … decode is injective"* — **a live retracted claim inside the
suite, contradicted twenty checks later by P10 and P11.** Narrowed to what its
fixture actually exhibits: an ordering, on **one** input.

---

## 4 — TEETH: FIFTEEN PLANTED FAULTS, ALL OBSERVED RED

Faults were planted in a **scratch copy** of the tree
(`…/scratchpad/teeth/latent-lisp/…`), never in the repo, so the "do not edit
`surface1.lisp`" rule held while the checks were still genuinely broken. The
scratch baseline reproduces `139 / 0 / exit 0` before every plant and after the last.

| # | fault planted | observed |
|---|---|---|
| T1 | `IDENTITY-OCTETS` made a constant (`1`) | `[005] FAIL A5` · `failed=1` |
| T2b | encoder gives `NIL` the nickname namespace `CL` instead of `COMMON-LISP` | `[016] FAIL C3` · `failed=1` |
| T3 | a slot named `CONTRACT-WITNESS` added to the receipt `defstruct` | `[069] FAIL I4` · `failed=1` |
| T4 | I6's "failing" downstream form replaced by one Slice /2 **accepts** | `[071] FAIL I6` · `failed=1` |
| T5 | one extra symbol exported at runtime, undeclared in `package.lisp` | `[084] FAIL L6` + `[085] FAIL L6b  declared 81` · `failed=2` |
| T6a | `%DESCRIBE-HOST-OBJECT` reverted to `(string (type-of object))` | **run ABORTS at P1** with `Unhandled SIMPLE-TYPE-ERROR … datum: (COMPLEX (INTEGER 1 2))`; **no canonical line**, exit 1 — the audit's crash, fail-closed |
| T6b | the type name left unbounded (+300 chars) | `[111] FAIL P3` · `failed=1` |
| T7 | encode-side depth ceiling doubled | `[113] FAIL P5` · `failed=1` |
| T8 | `%EXACTLY-ONE-SEGMENT-P` reverted to always true | `[117] FAIL P9` · `failed=1` |
| T9 | the round-trip gate disabled (`unless t`) | `[105] FAIL O4` + `[119] FAIL P10` + `[120] FAIL P11` · `failed=3` |
| T10 | catalogue field put back to `:UNREACHABLE-UNDER-THIS-POLICY` | `[124] FAIL P14` + `[137] FAIL M4` · `failed=2` — and **P13 stayed green**, which is the point: the field was the lie, not the behaviour |
| T11 | receipt version accessor reverted to a constant function | `[129] FAIL P19` · `failed=1` |
| T12 | P17's shared-structure fixture made unshared | `[127] FAIL P17` + `[134] FAIL M2` · `failed=2` — the coverage measurement follows the observation, which is the whole repair |
| T13 | the mutated text injected into the rendering N3 reads | `[090] FAIL N3` · `failed=1` |
| T14 | decode-side depth ceiling doubled | `[114] FAIL P6` + `[115] FAIL P7` · `failed=2` |
| **T15** | **file truncated at a clean top-level boundary** (the audit's T6) | 108 checks execute, **process exits 0**, **no `SELFTEST-RESULT` line and no summary line** — the runner's verbatim-line requirement catches what the exit code cannot |

Two faults (T6a, T2's first form) killed the run instead of reddening a line. That
is not a weaker result: both die **before** the canonical line, so the D4 contract
holds — the absence of the line is the failure signal, and the exit code alone
never was one.

---

## 5 — COUNTS

```
before   115 checks (frozen Errata 0.2 tree) → 111 passed / 4 failed against the repaired layer
deleted  G4 (F-4 merge) · L4 (F-8 merge) · M4-old · M6-old · M1-old/M2-old rebuilt   =  5 removed
added    L6b · P1–P22 (24 checks) · M2b · M5 rebuilt-as-new                          = 29 added
after    139 checks / 0 failed
```

**No filler was added to preserve a total, and no total was preserved.** Every
added check drives a behaviour and every one of the twenty-four in section P was
observed to fail against a reverted repair or is a conjunct of one that was. The
old 115 was a custody figure of the pre-repair tree, and the D8 checklist says so.

Runtime moved 2.2 s → 6.7 s. Four seconds of that is check **P6** alone: `DECODE-TERM`
at datum-depth 2000. See §6.

---

## 6 — WHAT I FOUND THAT THE AUDIT DID NOT

These are **reported, not repaired** — `surface1.lisp` is not my jurisdiction. Each
is stated at the size the evidence supports.

**(a) The D5 ceiling is one NUMBER over TWO UNITS, and the two do not compose.**
`surface1.lisp:468` calls the repair *"a DECLARED, INTROSPECTABLE, SYMMETRICAL
ceiling … on BOTH sides of the correspondence."* The **number** is symmetrical; the
**effect** is not. `ENCODE-TERM` measures the depth of a *host form*; `DECODE-TERM`
measures the depth of a *term datum*; and encoding a host form of depth *D* yields a
datum of depth *D+1*, because the innermost atom becomes a term of its own. Measured:

```
host depth 2000  → ENCODE-TERM: OK        (at the ceiling)
host depth 2001  → ENCODE-TERM: REFUSED   :TERM-DEPTH-EXCEEDED
datum depth 2000 → DECODE-TERM: OK        (= encoding of host depth 1999)
datum depth 2001 → DECODE-TERM: REFUSED   (= encoding of host depth 2000)
```

**So the deepest host term `ENCODE-TERM` accepts encodes to a datum `DECODE-TERM`
refuses.** That is a one-level gap at the very edge, far above the policy ceiling of
48, so no door behaviour is affected and nothing about the layer's accounts changes.
But it is exactly the shape of claim this errata exists to police: a published
symmetry that the numbers do not have. Check **P7** records it as measured fact and
says in its own detail line that it is reported, not repaired. A layer that wanted
the symmetry would check `+term-depth-ceiling+ - 1` on the host side, or `+1` on the
datum side, and say which unit the published number is denominated in.

**(b) `DECODE-TERM` re-measures depth at every recursive level — O(n²).**
`decode-term` runs `%datum-term-depth-exceeds-p` over the *whole remaining datum* on
entry, and then calls itself for each `LIST` element, so the top-level guard is
re-run once per level. At datum depth 2000 this costs **~4.0 s** — measured, and it
is the single largest cost in this suite (6.7 s total). It is correct, and it is not
a soundness defect; it is a public checking surface whose cost is quadratic in the
depth of the input it was just given a ceiling to bound. A depth check hoisted out
of the recursion (or a recursive body that does not re-check) would make it linear.

**(c) `:PROCEDURE-VERSION-MISMATCH` may no longer be `:INTERNAL-PLANTED-FAULT-ONLY`.**
Check **P21** reaches that alarm **without the fault hook**, by redefining
`LISP-PLUS-SURFACE1:EXPANSION-PROCEDURE-VERSION` — which is an **exported** symbol —
between the doors. That is an image mutation and not a public *call*, so I have not
asserted a reclassification and P21's detail line says exactly that. But the D7
repair changed what the alarm compares, and a client that redefines an exported
function of this layer can now violate it. The catalogue's reachability vocabulary
distinguishes "a fixture in the selftest reaches it" from "reachable only from inside
this package", and this case is neither cleanly. **Owner's call.**

**(d)** *(CORRECTION, second pass — this item was MIS-FILED. §6 is headed "reported,
not repaired", and E8 and O5 were in fact **repaired in the first pass**, as §3 says
two paragraphs earlier. The two halves of this report contradicted each other and the
coordinator reasonably read the §6 heading as governing. The finding below is real
and correctly described; only its filing was wrong. What was genuinely left undone
was the **sweep** the last sentence recommends, and that is discharged in §8.)*

**Two live claims inside the suite were retracted-but-unflagged.** Neither is in
the F-1…F-17 inventory, and both would have survived the errata: **E8**'s label
(*"versions come from the PACKAGE, not from a slot"* — the D7 defect stated as the
design) and **O5**'s label (*"NO PUBLIC INPUT CAN REACH THE ROUND-TRIP MISMATCH …
decode is injective"* — the D3 claim the audit refuted, sitting in the same file that
would now contain P10 and P11 refuting it). The stranger audit's F-list was built
from *checks whose predicate does not match their label*; these two are the adjacent
class — **checks whose predicate matches a label the layer has since withdrawn.**
Both pass, both are green, and greenness is exactly why they are dangerous. Anyone
running a further sweep should grep the suite for labels citing Errata 0.1/0.2
rationales that Errata 0.3 has moved.

**(e) The old M section measured coverage before a third of the suite had run.**
Sections N and O produce `:SOURCE-NOT-RECONSTRUCTIBLE` and several others, and the
coverage check sat **above** them. This was invisible while the check read a
hand-written list — a list does not care when it is read. The moment coverage becomes
a live measurement the ordering becomes load-bearing, and it is now last in the file.
Filed as a general shape: **a measurement moved into a position a constant occupied
inherits none of the constant's indifference to position.**

---

## 7 — LIMITS OF THIS REPAIR

- Every green here remains **self-consistency certification by the family that wrote
  the layer**, exactly as the file's own closing block says. A stranger audit of the
  repaired suite is owed and has not happened.
- Coverage is measured **reach**, never soundness. M2's empty remainder says every
  publicly-declared code was produced in this process; it says nothing about whether
  any guard behind those codes is right.
- Fifteen faults were planted. Fifteen is not "every check has been shown able to
  fail" — the checks not listed in §4 (most of sections A–L, which the audit did not
  flag) carry the same untested-gate risk they always did, at their pre-existing size.
- `%DESCRIBE-HOST-OBJECT` is exercised through three compound specifiers. `TYPE-OF`
  may return other compound shapes; P1–P3 are witnesses for the three the audit
  measured, not a totality claim.
- The D1 witness uses `DEFINE-JUDGMENT-SCHEMA` at N=2491. **Amplification is
  construct-dependent** and that number is a threshold for one construct in one
  image, not a universal one — the catalogue note already says so and this file does
  not say otherwise.

---

*— SPECULUM, for Claude Fable 5 · errata branch `surface1-errata-0.3` · 2026-07-28.
The mirror does not flatter: four of the checks it repaired had been green for three
errata, and two of them were green because their labels named a design the layer had
already abandoned.*

---

## 8 — SECOND PASS: FINDING 4 CLOSED, AND THE CHAIR'S THREE REPAIRS RECEIVED

*Written after the chair repaired findings (a), (b) and (c) in `surface1.lisp`.
Suite re-verified at each step; no file but `surface1-selftest.lisp` and this
report was touched.*

```
after second pass   139 checks / 0 failed · exit 0
canonical line      SELFTEST-RESULT checks=139 expected=139 failed=0
wall clock          3.28 s   (was 6.72 s — see §8.2)
count movement      none: three labels/comments corrected, one conjunct added to P21
```

### 8.1 — Finding 4: the correction first

**E8 and O5 were already repaired, in the first pass.** §3 of this report says so;
§6(d) filed them under a heading that reads *"reported, not repaired."* That
contradiction is mine and it cost the coordinator a wasted instruction. E8 has read
*"a receipt reports the … versions STORED at mint"* since the first pass, and O5 has
read *"an ordering exhibited on ONE input"* since the first pass. I have marked the
mis-filing in place rather than rewriting §6(d) silently.

**What was genuinely undone was the sweep** — §6(d)'s own last sentence: *"anyone
running a further sweep should grep the suite for labels citing Errata 0.1/0.2
rationales that Errata 0.3 has moved."* I had named the class and not swept it. Done
now, across the whole file, and it caught **three** live withdrawn claims — two of
them created by the very repairs of this second pass, which is the finding under the
finding: **this class regenerates every time the layer moves.**

| # | withdrawn claim, live in the file | why it was withdrawn | disposition |
|---|---|---|---|
| 1 | The `P/D5` section comment: *"those units are NOT the same object … encoding a host form of depth D produces a datum of depth D+1 … Checks P6/P7 record that asymmetry as measured fact rather than asserting a symmetry the numbers do not have."* | The chair repaired the off-by-one. The asymmetry was a property of a **defective repair**, never of the design — and the comment taught it as design. **I wrote this one**, and the chair's fix to P6/P7 left it standing above the two checks that now assert the opposite. | **REPLACE** — rewritten to quote the retracted sentence, name what was actually wrong (`%DATUM-TERM-DEPTH-EXCEEDS-P` began its walk one level in), and state the repaired property. The history is kept because the sequence is the evidence; what does not survive is the retracted sentence stated as current fact. |
| 2 | `P21`'s detail line: *"reached by redefining the layer's own version function — an image mutation, NOT a public call."* | The chair reclassified `:PROCEDURE-VERSION-MISMATCH` to `:PUBLIC-API`. My hedge was wrong in the direction that matters — the fixture touches **no internal symbol and binds no fault hook**; it redefines an **exported** function. | **REPLACE** — detail line now reads *"reached with no internal symbol and no fault hook — only a redefinition of an EXPORTED function"*, and a **new conjunct asserts the catalogue field reads `:PUBLIC-API`**, at the one place in the suite that reaches the code by the public route. Teeth-tested: T16. |
| 3 | `M5`'s label: *"… and all three fired here."* | Same reclassification: `:INTERNAL-PLANTED-FAULT-ONLY` went from three codes to two. **The predicate stayed correct** — it derives its set from the catalogue — so the check remained green while its label went false. | **NARROW + DERIVE** — the numeral is gone from the label; the count is computed from the catalogue and printed as detail (`declared 2 · unfired: NIL`). Teeth-tested: T17b. |

**A hand-typed count beside a derived set is the same defect as a hand-written
coverage list beside a live one, one size smaller.** F-6 was that defect at the scale
of a whole section; M5's "three" was it at the scale of one word. Both were green.

### 8.2 — The new wall clock

```
first pass    6.72 s   (P6 alone cost ~4.0 s: DECODE-TERM was O(n²) in depth)
second pass   3.28 s   — a 51% reduction, 3.44 s of it recovered from finding (b)
```

The chair's `%DECODE-TERM-1` split (measure once, descend without re-measuring)
removed essentially all of it. The remaining ~3.3 s is dominated by the D1
node-ceiling witnesses (P13/P15 macroexpand a 2491-premise schema twice) and by SBCL
start-up plus the load of CD/0, Surface /1, Surface /0 and the slices — i.e. by work
that is not this suite's to shrink.

### 8.3 — M2 recheck under the 17th `:PUBLIC-API` code

**Coverage stays complete, and it stays complete by measurement rather than by luck.**

```
:PUBLIC-API declared          17   (was 16 — :PROCEDURE-VERSION-MISMATCH joined)
observed this run             19
uncovered remainder           NIL
:INTERNAL-PLANTED-FAULT-ONLY   2   (was 3) — both observed
:UNREACHABLE-UNDER-THIS-POLICY 0
:PUBLIC-API-IN-A-STUB-IMAGE    1   — correctly NOT observed here
```

The 17th code is driven by **P21**, my own D7 regression, through `REFUSAL-OF` —
which observes. So the reclassification did not open a hole. I verified this by
reading the printed partition, not by inferring it from a green check: had P21 not
driven it, M2 would have named it in `*uncovered*` and gone red, which is exactly
what T12 demonstrated the mechanism does. The arithmetic also still closes: 17 public
+ 2 planted-fault = 19 observed, and M2b's *"covers more than the public codes
alone"* remains true with the margin now exactly 2.

### 8.4 — Verdict on the chair's P6/P7 rewrite

**It preserves my intent and improves on it; I have no objection.** Specifically:

- **P6 is now stronger than what I wrote.** My version drove the ceiling-edge from
  `ENCODE-TERM` output on both sides, which meant the ceiling+1 case could only be
  reached because the encoder happened to permit that depth. The `NEST-TERM-DATUM`
  helper builds the over-deep datum from CD/0 constructors directly, so the decoder's
  refusal is driven by a datum **the encoder now refuses to make** — which is the only
  honest way to test a decoder bound once the two bounds agree. I would not have
  reached that helper without the repair.
- **P7 keeping the record in a comment while moving the assertion is the right call**,
  and the chair's sentence for it — *"a suite that records a defect as a passing check
  is telling the truth about the world and a lie about the design"* — states the rule
  better than my §6(a) did. My check asserted a defect as a **stable property**; that
  is a real hazard, because it would have gone red on the repair and looked like a
  regression.
- **One residue the rewrite left**, now fixed by me: the section comment above P6/P7
  still taught the asymmetry as design (item 1 in §8.1). The checks moved; the prose
  above them did not. That is the same shape as F-17 — a retracted claim surviving in
  a comment twenty lines from the check that contradicts it — and it is worth naming
  that **this file committed that defect itself, within one erratum of repairing it.**

### 8.5 — Teeth for everything written in the second pass

Faults planted in the scratch copy (`…/scratchpad/teeth/…`), never in the repo;
baseline re-verified at `139 / 0 / exit 0` before and after.

| # | fault planted | observed |
|---|---|---|
| T16 | catalogue field for `:PROCEDURE-VERSION-MISMATCH` reverted to `:INTERNAL-PLANTED-FAULT-ONLY` | `[131] FAIL P21` · `failed=1` — the new conjunct bites |
| T17b | one planted-fault alarm dropped from the observation path | `[138] FAIL M5` · `failed=1` · detail printed `declared 2 · unfired: (:SOURCE-IDENTITY-PROJECTION-MISMATCH)` — the derived count is live |
| T18 | decode-side depth ceiling doubled, against the **repaired** `surface1.lisp` | `[114] FAIL P6` · `failed=1` — the rewritten P6 still bites post-repair |
| T17 | (attempted) the source-identity projection alarm disabled outright | run **aborts at K2** with no canonical line, exit 1 — fail-closed, but it never reaches M5, so T17b was substituted as the isolating fault. Recorded because a fault that dies early is not evidence about the check you aimed it at. |

Item 1 of §8.1 is prose and carries no predicate; it is not teeth-testable and is not
claimed to be.

### 8.6 — What is still open

- The withdrawn-label class is **not closed by this sweep, only swept**. Two of the
  three items found were created by repairs made *during* this erratum. Every future
  move of `surface1.lisp` re-opens it, and nothing in the suite detects it — a stale
  label is green by construction. If it is worth mechanising, the shape would be a
  check that no label or comment in the file names a reachability, a version, or a
  count that the live catalogue contradicts; I have not built it, and I would not
  trust a substring scan to do it (cf. F-10).
- Sections A–L, which the audit did not flag, remain teeth-untested at their
  pre-existing size. Eighteen faults have now been planted across two passes; that is
  not "every check has been shown able to fail."
- Every green here is still self-consistency certification by the family that wrote
  the layer. A stranger audit of the **repaired** suite is owed and has not happened.

*— SPECULUM, second pass, 2026-07-28. The first pass found four defects in a file
that had been green for three errata. The second pass found three more, two of which
the first pass created.*
