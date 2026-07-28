# LANGUAGE SURFACE /1 — CANDIDATE /0 — ERRATA 0.3

*Repairs against the **independent stranger audit** of 2026-07-28, which
returned `AUDIT-CLOSED — DEFECTS FOUND, REPAIR REQUIRED` against the frozen
Errata 0.2 target. Authorized by the owner; performed by the family that wrote
the layer.*

```
subject audited     65782d5c4ac9c5ffecff4cf86bdb0501a7480639
                    subtree 9b3436182c0e40c56987c77385608aef9d1f04f5
audit record        audits/2026-07-28-stranger-audit/   (IMMUTABLE — not edited)
findings returned   9 confirmed defects (D1-D9), no false receipt on any route
standing            errata candidate · audit findings addressed by the author
                    family · NOT independently re-audited after repair · NOT
                    fresh-weights audited · not adopted · not frozen as language
                    law · on no governing floor
```

**THE AUDIT'S CENTRAL RESULT, WHICH THIS ERRATUM DOES NOT DISTURB.** No route
was found on which a receipt's account diverged from the expansion actually
performed. The expansion receipts survived; what failed were the layer's
stories about its own reachability, robustness, version binding, and evidence.
This erratum repairs the stories. **It does not redesign the
source→expansion account, and nothing here should be read as improving it.**

---

## 0. WHAT THIS ERRATUM IS, AND WHAT IT IS NOT

- It is **not** a re-audit. Every repair below was made by the family whose
  work the audit graded.
- It is **not** a discharge of the audit. The audit remains closed **with
  defects** against the frozen target it examined. Errata 0.3 produces a **new
  target with new audit debt**.
- The **fresh-weights tier remains owed and unspent.** The 2026-07-28 audit was
  a fresh-context Claude-family audit and said so before returning any verdict;
  it cannot catch a Claude-wide blind spot, and neither can this erratum.
- **Nothing in the audit record was edited.** The return, the three auditor
  reports, the probes and transcripts are historical evidence. Where this
  erratum contradicts a claim in an older document, the older document is
  **marked in place**, never rewritten to look correct.

---

## 1. THE ORDER OF WORK, AND WHY IT IS PART OF THE RESULT

The ledger and the version ruling were **committed before implementation**
(`c63706e6`), and the pre-repair reproductions were **run and committed before
a line of production code changed** (`be452d28`). This is not ceremony: a
repair that decides afterwards what it was repairing can always report success.

**Pre-repair reproductions, against the unmodified candidate:**

```
PRE-REPAIR-RESULT verdicts=8 expected=8 confirmed=8      D1 · D2a/b/c · D3a/b/c · D7
D5 encode   depth 40000  ->  CONTROL STACK EXHAUSTED     (catchable)
D5 decode   depth 40000  ->  fatal abort, process death  (UNCATCHABLE)
D4 witness  selftest truncated: 35 of 115 checks ran, NO summary line, runner exit 0
D6 witness  two materially different subjects, one label, BYTE-IDENTICAL transcripts
```

---

## 2. THE VERSION RULING — WRITTEN BEFORE IMPLEMENTATION, UNCHANGED BY IT

```
grammar    3 -> 4
procedure  3 -> 4
policy     1        unchanged
```

**Grammar** moves because the correspondence itself moved: `DECODE-TERM` now
refuses identifiers carrying surplus segments (data it previously accepted,
non-injectively); the raw public term functions declare and enforce a
term-depth ceiling; and the published description of the correspondence — its
injectivity, and the reachability of its round-trip gate — was wrong and is
now right. Under this layer's own Errata 0.2 §5 rule, *the grammar is the
correspondence, and a law needs an owner*.

**Procedure** moves because construction and temporal binding changed: both
doors now capture the governing versions **as values**, receipts report what
they stored, the receipt identity composes the mint-time procedure binding, and
`:PROCEDURE-VERSION-MISMATCH` compares two independently sourced operands — so
an image upgraded *between* the doors now refuses where it used to pass unseen.

**Policy** does not move. No ceiling value changed. D1 repaired the
*description* of how the existing ceilings interact, not their numbers, and no
ceiling was raised or lowered to make any code more or less reachable.

---

## 3. D1 — A CODE ADVERTISED UNREACHABLE, REACHED BY ORDINARY PUBLIC INPUT

`:EXPANDED-NODES-EXCEEDED` was catalogued `:unreachable-under-this-policy`
with a note beginning **"MEASURED UNREACHABLE UNDER THIS POLICY"**, restated in
five places and certified green by selftest checks M4 and M6. The audit reached
it from the public API with an ordinary admissible form.

**The argument failed in both halves, and the shape of the failure is the
lesson.** It cited the gate order that refutes it — `%ENCODE-CHECKED` runs
depth → nodes → encode → octets, so on the expanded side the **node check runs
before anything is encoded** and no octet count can pre-empt it; the note even
states this correctly one sentence later, *for the source side*, without
noticing the same sentence applies verbatim to the expanded side. And its
arithmetic was wrong: a term costs ~38–70 octets, not "roughly 120" — the
layer's own application prints `One term costs 70 octets` in the same run the
runner blesses — while `DEFINE-JUDGMENT-SCHEMA` amplifies ~4.0× because it
wraps every premise.

**Repaired:** reclassified `:public-api`; every retracted sentence deleted; the
measurement recorded honestly, *including that amplification is
construct-dependent and no single threshold is universal*; M4/M6 replaced by an
executable public witness. **The guard was correct throughout and is
unchanged.** No ceiling moved — and REPRODUCTION-III carries an **inverted**
verdict that fires if one ever does.

---

## 4. D2 — THE REFUSAL MACHINERY CRASHED WHILE DESCRIBING WHAT IT REFUSED

`%DESCRIBE-HOST-OBJECT` called `(string (type-of object))`. `TYPE-OF` lawfully
returns a **compound specifier** — a cons — for exactly the types the boundary
law names as refused: `(COMPLEX (INTEGER 1 2))`, `(SIMPLE-VECTOR 3)`,
`(SIMPLE-ARRAY T (2 2))`. `STRING` of a cons signals, so the designed
`:SOURCE-TERM-UNREPRESENTABLE` refusal was never minted and a raw host
`TYPE-ERROR` escaped — including through `TRY-REQUEST-EXPANSION`, **whose
entire contract is that it does not signal**.

**Repaired in the helper, not behind a handler at the door.** A crash inside
the refusal machinery is a defect of that machinery; wrapping the door would
have hidden it. A compound specifier is now reduced to its head symbol, nothing
recurses, nothing prints the object, every branch returns a bounded string.

---

## 5. D3 — THE ROUND-TRIP GATE IS PUBLICLY REACHABLE, AND DECODE WAS NOT INJECTIVE

Errata 0.2 §2 claimed *"decode is injective for every admissible datum, so NO
PUBLIC INPUT CAN REACH the round-trip mismatch — the earlier, more precise
guard always fires first."* All three parts are false.

- **`RENAME-PACKAGE`** between the doors, retaining the old name as a
  **nickname**: `FIND-PACKAGE` resolves the stored namespace to the *same
  package object*, so the home-package guard passes; re-encoding then writes the
  package's new **primary** name.
- **A package-local nickname in the caller's ambient `*PACKAGE*`** at Door 2 —
  **requiring no mutation of anything at all.** Door 2's reconstruction is
  therefore a function of *(datum, image, dynamic context)*, which no document
  had stated.
- **Decode was not injective** on the data it accepted: identifiers with
  surplus segments decoded to the same symbol as their one-segment
  counterparts, because `%SEG` read segment 0 and discarded the rest.

**The proof proved the wrong property.** The gate does not test injectivity; it
tests whether decode is a **section** of encode, and that fails whenever a
namespace's package designation is non-canonical *at decode time* — which
Common Lisp permits both across time and across dynamic context.

**Repaired:** both claims withdrawn from the catalogue and marked in Errata
0.2; the catalogue now states plainly that the operation *can* reach the
mismatch, that it fires **before** macroexpansion, and that nothing is minted;
surplus segments are refused. **The gate itself is preserved and was
vindicated** — it caught, fail-closed, every route the audit found, and is now
field-proven by public input rather than by planted fault alone.

---

## 6. D5 — THE PUBLIC CHECKING FUNCTIONS KILLED THE IMAGE

Errata 0.1's own indictment was *"a public function turning hostile input into
a host accident."* Its repair moved the accident from cyclic input to **deep
acyclic** input; it did not remove it. `ENCODE-TERM` exhausted the control
stack (bisected: fine at 25222, dead at 25375), with `%SHARED-CONS-COUNT` — the
Errata 0.1 repair itself — as the blowing frame. `DECODE-TERM`, **published on
purpose so a reader can check the layer's central claim independently**, died
with a *fatal, uncatchable* abort: the reader invited to verify could be handed
a datum that killed their image.

**Repaired:** `%SHARED-CONS-COUNT` is iterative (explicit work stack); both raw
public functions declare an introspectable `TERM-DEPTH-CEILING`, measured
iteratively and enforced **before** recursion, on both sides of the
correspondence. Door behaviour is untouched — the policy ceiling of 48 fires
thousands of levels earlier. Verified to 500,000 levels on the encode side and
at the former fatal depth on the decode side.

---

## 7. D7 — A RECEIPT THAT COULD NOT SAY WHAT MINTED IT, AND AN ALARM WITH ONE OPERAND

The version accessors were constant functions that ignored the receipt and read
the **live** package, under the comment *"a receipt cannot disagree with the
package that minted it."* True only vacuously: the receipt stored no version,
so it had nothing to disagree with. The audit measured an old receipt's
reported procedure version **move from 3 to 4** when the package was redefined
beneath it. The same absence made `:PROCEDURE-VERSION-MISMATCH` a comparison of
the package with itself — **an alarm no state of the world could violate**,
whose fault hook did not perturb a gate but manufactured the only difference a
self-comparison could have.

**Repaired:** both doors capture the governing versions as values; receipts
report what they stored; the receipt identity composes the mint-time procedure
binding; and the alarm compares the **Door-1 capture** against the
**live-at-mint** value. An image upgraded between the doors now refuses.

---

## 8. D4 · D6 — THE EVIDENCE HARNESS

*(Movement II. Filled from the live gate: see §11.)*

**D4 — fail-open for three of five instruments.** Only the two reproductions
carried a required canonical line; the selftest, stub fixture and application
were gated on exit code alone, and a check that never ran never fails. The
audit truncated the selftest to 35 of 115 checks — and to **zero checks with no
summary at all** — and the runner exited 0.

**Repaired:** every instrument emits one canonical machine-readable line from
**live counters**, after all intended checks have executed; the runner requires,
for each, process exit 0 **and** the exact line **and** self-consistent counts
**and** zero failures. Negative teeth controls are captured for every
instrument, not merely the reproduction pair.

**D6 — the label was not a measurement.** `git rev-parse HEAD` answers *what
was last committed here*, never *what is in these files*; the audit produced
byte-identical transcripts under one label for two materially different
subjects — in exactly the scratch-copy condition the runner's own packaging
note requires an auditor to work in.

**Repaired:** a deterministic **content-derived subject digest** over an
exact-path manifest of the real load closure, with unambiguous framing, working
outside a git checkout, hard-failing on a missing member, excluding generated
transcripts by exact path (never by basename — this lane has a scar there). The
human label survives, marked **advisory**.

---

## 9. D8 · D9 — THE SELF-CERTIFYING CHECKS AND THE CLAIM INVENTORY

The full `F-1 … F-17` inventory from the audit's TABULARIUS report was worked
as a mandatory checklist, one disposition per item — replace, narrow, merge,
delete, or move to prose — recorded in `errata-0.3/D8-DISPOSITIONS.md`. Among
them: a census check comparing a value to its own defining expression while the
measurement its section advertised existed nowhere; `encode-term` of `'nil`
compared with `encode-term` of `'()` — one object, twice; a hand-written slot
literal stale by two receipt fields; a coverage claim asserting *"nothing else
is left uncovered"* while a code it listed as exercised was produced by no check
in the tree.

**Coverage is now measured, not declared:** the suite records every refusal code
it actually produces and asserts the observed set against the catalogue.

**D9:** the RETURN's banner claimed *"Two claims below are FALSE as written"* —
a banner that states a count is a claim about every claim beneath it, and
falsifies itself when one more is found. It now points instead of counting.
The stale `E11` citation, §11's pre-errata *"unfolds shared structure"*, the
drifted check numbers and the *"exhaustively"* field list are each corrected
**in place and marked**. `package.lisp` now states in writing that **"exact
source form" means the exact TERM under the declared grammar, never
host-object identity** — the question a stranger asked, answered where a reader
will meet it.

---

## 10. WHAT THIS ERRATUM FOUND IN ITS OWN REPAIRS

**This lane's signature failure is that each defect lives in the repair of the
previous one. It happened again, four times, and every instance was caught
before publication — three by a checker commissioned to grade the repair, one
by the chair's own instrument.**

1. **The depth ceiling was not symmetrical**, though the ledger claimed it. The
   datum walk counted the leaf term as a level the host walk does not, so the
   **deepest host term the encoder accepted produced a datum the decoder
   refused** — an encodable term that could not be read back, which is precisely
   what this layer's depth-ceiling section exists to prevent.
2. **The decode repair was quadratic in depth**, re-measuring the remaining
   subtree at every level. Split into a door that measures once and a body that
   descends bounded: a 1900-deep decode fell from seconds to 0.015 s.
3. **`:PROCEDURE-VERSION-MISMATCH` was left catalogued
   `:INTERNAL-PLANTED-FAULT-ONLY` while the D7 repair had just made it publicly
   reachable** — the exported version function, redefined between the doors,
   reaches it with no internal symbol and no fault hook. Recording it otherwise
   would have republished, *inside this erratum*, the exact defect class the
   erratum was authorized to repair.
4. **Two instrument bugs in the chair's own probes**, both of the class under
   repair: a check that compared two CD/0 octet **objects** (a CLOS class — so
   `EQUALP` was object identity, testing nothing), and a probe that searched a
   catalogue note for a retracted claim and **matched it inside the sentence
   that retracts it**. A probe that greps for a claim cannot tell an assertion
   from its retraction.

---

## 11. THE NUMBERS

*(Every figure below is derived from the live transcripts of the final gate
run, not from a previous document. Filled at §12's gate.)*

**The complete gate, every instrument, one run** (`runner exit 0`):

```
SELFTEST-RESULT          checks=139 expected=139 failed=0    subject=9214b59bda190327
STUB-RESULT              checks=8   expected=8   failed=0    subject=9214b59bda190327
APPLICATION-RESULT       checks=26  expected=26  failed=0    subject=9214b59bda190327
REPRODUCTION-RESULT      verdicts=6 expected=6   confirmed=0 subject=9214b59bda190327
REPRODUCTION-RESULT      verdicts=4 expected=4   confirmed=0 subject=9214b59bda190327
REPRODUCTION-III-RESULT  verdicts=12 expected=12 confirmed=0 refuted=12 classification=3
                                                             subject=9214b59bda190327
digest agreement         1   (all six computed it independently and agree)
subject-digest           9214b59bda190327dc879186bd6d567eae8d2e7d0d162f869148fad1ad6aaf99
```

```
173 checks / 0 failed        (139 selftest · 8 stub · 26 application)
 22 verdicts / 0 confirmed   (6 reproduction I · 4 II · 12 III)
```

**These totals moved, and the movement is correct.** Errata 0.2 reported
`115 / 8 / 24 = 147`; checks were deleted as non-evidence, merged where two
counted one fact, and added where a repair needed a regression. **No filler was
added to preserve a total, and no total was preserved for its own sake.**

**Teeth, all six instruments:** 43 planted faults across 5 fault classes ×
6 instruments plus 7 apparatus-failure cases — *every one refused, 0 holes*
(`errata-0.3/teeth/`). Before this erratum, three of five instruments could run
zero checks and be blessed.

**Subject digest:** git-free SHA-256 over a **25-member exact-path manifest**,
the load closure traced by encapsulating `LOAD` rather than by reading load
forms, framed as fixed-width digest + delimiter + newline-terminated path with
the member count bound in — so no variable-length concatenation can make one
manifest impersonate another. Demonstrations in
`errata-0.3/digest-demo/DEMONSTRATIONS.txt`, including the audit's own
experiment restaged: **same git HEAD `8ec18a8` on both subjects, digests
`9214b59b…` vs `66c3ee8e…`, and the six transcripts that were byte-identical
now all differ.**

**Predecessor floors, run post-repair:**

```
form floor       199 checks / 0 failed     exit 0
language floor   654 checks / 0 failed     exit 0
```

Both identical to the pre-session baseline. **`git diff` from the audited
commit to this tree is EMPTY for all ten predecessor trees** — CD/0, Kernel /0,
Core /0, Slices /0/1/2, Surface /0, Forms /0/1/2 — so the blast radius is
confined to `language-surface-1/` in bytes as well as in behaviour
(`errata-0.3/floors/PREDECESSOR-DIFF-PROOF.txt`).

**Coverage, measured rather than declared:** 17 `:PUBLIC-API` codes declared,
uncovered **NIL**, with a companion check guarding against vacuity in the other
direction. The 17th is `:PROCEDURE-VERSION-MISMATCH`, which this erratum's own
D7 repair made publicly reachable.

**Exports:** 75 → **80** (`TERM-DEPTH-CEILING`, three request version readers,
three receipt version readers; two constant-function accessors became slot
readers). Declared and live reconciled against `package.lisp`'s own `:export`
clause rather than against a hand-typed number.

---

## 12. WHAT THIS ERRATUM DID NOT DO, AND WHAT REMAINS OPEN

- **No stranger audit.** Owed against *this* target, and harder than the last
  one: the tree is public, so a prereg committed to it is a published prereg.
- **No fresh-weights reading.** Still the only tier that can catch a
  Claude-wide blind spot.
- **No new feature. No Surface /0 modification. Form /3 and Surface /2
  unopened.** No adoption, no freeze, no governing floor.
- **No DAG representation and no alpha-normalization.** Still the two named
  next representation laws.
- **THE STALE-LABEL CLASS RE-OPENS ON EVERY MOVE OF `surface1.lisp`, AND
  NOTHING DETECTS IT.** Two of the three stale labels this erratum swept were
  *created by repairs made during this erratum*: fixing the depth asymmetry
  orphaned a comment that still taught it as design, and reclassifying the
  version alarm orphaned a check detail that still called it "NOT a public
  call". Both were green and false. A check's label is prose about code, and no
  assertion in this tree relates the two. **This is not closed; it is named.**
- **No claim of completeness.** Nine findings repaired, and the audit that
  produced them was explicit that it could not enumerate what it had not
  reached. Errata 0.1 refuted six findings and this lane still found more twice
  over.

---

## 13. STANDING

```
candidate repaired through Errata 0.3
audit findings addressed by the author family
NOT independently re-audited after repair
NOT fresh-weights audited
not adopted · not frozen as language law · on no governing floor
```

**The 2026-07-28 audit remains closed with defects against the frozen Errata
0.2 target.** Errata 0.3 creates a new target, and new audit debt with it.
Nothing here licenses "now correct", "audit closed clean", or any adjective
about quality.

---

*— Claude Fable 5, 2026-07-28. SBCL 2.4.6, operation-checked before any Lisp
ran. Repairs by the author family; the audit record is unedited; the frozen
subject `9b343618…` remains byte-identical in the packet that was audited.*
