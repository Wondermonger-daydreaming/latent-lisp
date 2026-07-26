# LANGUAGE SURFACE /0 — CLOSURE

*What was built under `LANGUAGE-SURFACE-0-WORK-ORDER.md`, what it costs, and
what it does not do. **Not an adoption record** — the work order forbids one.*

```
status:                        candidate implementation
specification-frozen:          no
semantic delta below surface:  NONE CLAIMED
surface0 exports:              10   (five macros, four readers, one accessor)
slice2 exports:                100 → 100   (byte-untouched)
slice1 / slice0 / kernel0 / core0:  byte-untouched
stranger audit:                OWED, against this closure too
```

---

## 1. The floor

Complete language floor, **once**, after every focused suite was green:

```
core0-substrate         29 /  0     unchanged
core0-issuance          73 /  0     unchanged
slice1-selftest        123 /  0     unchanged
slice1-smoke             9 /  9     unchanged
de-codice-restaurando  101 /  0     unchanged
de-cursore-aereo        23 /  0     unchanged
de-ponte-usto           17 /  0     unchanged
slice2-selftest        108 /  0     unchanged
slice2-smoke            10 / 10     unchanged
de-bibliotheca         123 /  0     was 116   (+7, Movement XII)
surface0-selftest       38 /  0     NEW — the eleventh floor
                       ─────────
                  11 floors · 654 checks · 0 failed     (was 10 / 609)
```

**Nine of eleven floors did not move.** For a movement that claims *no semantic
delta below itself*, that is the whole result; the two that moved are additions,
not changes.

## 2. What the differential testing actually established

Each declarative macro has a direct-API twin, compared **only through public
observations**, across six scenarios: an ordinary Slice /1 derivation · a Slice /2
source-basis derivation · a downstream derivation-basis-only premise · refusal by
naked claim · refusal by inaccessibility · a refuted premise. All six agree.

**One methodological catch, recorded because it nearly produced a false red.**
The first comparison used `EQUAL` on `proposition-pattern` objects. A
proposition-pattern is a `defstruct`, and Common Lisp's `EQUAL` on structures is
`EQ` — so two structurally identical patterns are **not** `EQUAL`, and a
perfectly correct macro failed its own test. The work order had already said it:
*do not require `EQ` where the public contract does not promise it.* The
comparison now goes through the public normal-form reader. A second instance of
the same class: `claim-judgment` returns a **judgment-record**, not a keyword, and
the test asserted the keyword directly.

Both failures were the **test's** fault, both were found by running rather than
reading, and both are noted in the suite so the next reader does not rediscover
them.

## 3. The two planted faults

Real file edits, restoration **verified by hash** (`PLANTED-FAULTS.sh`):

**FAULT A** — the contract macro silently adds `(:verified-judged-claim)`.
**Five controls fired**, including `SD3` (the clause differential) and `SD10` —
the naked granted claim became **admissible at a derivation-bound premise**,
which is precisely the impersonation Candidate /1 exists to prevent.

**FAULT B** — the control form rewrites the caller's `:receiver` into a
permissive one built from `:supports`. **Three controls fired** — and two of them
were not aimed at it:

```
SC17  inaccessibility repaired          → :GRANTED, :SATISFIED   (the target)
SC19  operand evaluated 2 times         → collateral
SC20  evaluation order (:A :B :C :C)    → collateral
```

That collateral damage is the most informative result in this movement.
Decomposing the operation form to rewrite one argument **automatically** broke
the evaluate-once and source-order guarantees, because `:supports` got spliced
into two places. It is direct evidence for the claim in `surface0.lisp`'s own
header: placing the operation **verbatim** is what makes those guarantees
*structural* rather than promised. A design that had decomposed the form for
convenience would have needed those two controls to catch what the structure now
prevents.

## 4. Costs and holes, named

**(a) No receiver-context form, and the absence is load-bearing.** Writing
accessibility by hand is the most repetitive thing left in a surface-native
program, and it is exactly the repetition that must not be removed yet — fault B
is what removing it looks like. Whether a *safe* recurring form exists is a real
open question for a later candidate, and it should be answered by an inhabited
program, not by taste.

**(b) No optional declaration fields at all.** Every field of every declaration
must be written, including `:locals ()` and `:unique-locals ()`. This makes short
declarations less short than they could be. It is deliberate: an omitted
standing-relevant field is the silent default the boundary law forbids. If a
later candidate adds a genuinely optional field, `%parse-fields` already
separates *allowed* from *required* so the contract need not be rewritten.

**(c) The mixed form is a real seam.** `define-slice2-schema` is the one place
where literal syntax and evaluated expressions sit in one form. It is documented
at the point of use, and the indices are literal precisely so a premise position
can never be computed — but it is the form most likely to confuse a new reader,
and it is named here rather than smoothed.

**(d) Reloading a file that declares a schema hits Slice /1's duplicate
behaviour.** The obvious "fix" — clearing or silently replacing — was refused;
`SC24` asserts no registry clearing appears in the expansion. That means a
surface-native file is not blindly re-loadable, and that is Slice /1's answer,
not a Surface /0 defect to route around.

**(e) Self-consistency, not corroboration.** One model family wrote the language,
the applications, this layer, its tests and its documents.

**(f) Every account is a labelled scripted fake adapter** — a real governed
in-image act, never evidence that an external deed occurred.

## 5. Movement XII

`de-bibliotheca-peregrina` gained one movement; **Movements I–XI are
byte-identical** — verified as four insertion-only diff hunks with **zero
deletions**. The additions are the Surface /0 load, the movement-index entry,
Movement XII itself, and one additive closing paragraph.

`[XII-1]`–`[XII-7]` show the surface-built derivation granting identically,
consuming the basis Movement X established, binding the exact third value, the
prior receipt still reachable by object, the modest ceiling surviving to the
renderer, nothing altered to make it pass, and the expansion naming the public
constructor with no internal symbol in it. `12b` prints the expansion so the
readability claim is **checkable rather than asserted** — and there is no
line-count comparison anywhere.

## 6. What this movement did not do

No change to Kernel /0, Slice /0, Slice /1, Slice /2 Candidate /1, Core /0, Core
/0 issuance, source-basis or derivation-basis establishment, receiver
accessibility, refutation, ambiguity, claim or receipt identity, truth ceilings,
or the two-door `perform`/`derive` boundary — each verified byte-identical by
hash.

No adoption record. No specification freeze. No stranger audit. Slice /3 not
opened.

---

*Built against lab `f47ab98e` in an isolated clone with no remotes and disabled
hooks · SBCL 2.4.6 operation-checked through the wrapper · floor 11/654/0 ·
`specification-frozen: no`.*

— **Claude Opus 5 (1M context)**, 2026-07-25
