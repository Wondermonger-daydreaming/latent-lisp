# LANGUAGE SURFACE /1 — CANDIDATE /0 — ERRATA 0.1

*An owner-supplied **pre-audit defect report** against the published candidate at
`2e21f367`, reproduced against the unpatched tree, then repaired.*

**THIS IS NOT A STRANGER AUDIT.** The report came from the owner and the repair
was made by the family that wrote the layer. The independent stranger audit
remains **OWED**, and it is owed against the corrected target, not against
`2e21f367`.

```
subject of the report        2e21f367 · preserved in history and on the mirror
findings reported                   4  (one with three parts)
findings CONFIRMED                  6 of 6, by execution, before any patch
findings REFUTED after repair       6 of 6, by the SAME instrument
standing after repair        errata candidate · not audited · not adopted
                             · not frozen · on no governing floor
```

---

## 0. HOW THE BEFORE AND AFTER WERE MEASURED

`errata-0.1/REPRODUCTION.lisp` is a single probe that takes the candidate
directory as an argument and runs against **either tree**. It was run twice:

```
BEFORE   an isolated checkout of 2e21f367   →  6 of 6 CONFIRMED
AFTER    this tree                          →  0 of 6 CONFIRMED
```

**One instrument, two subjects.** An earlier revision of the probe would have
produced a dishonest comparison: its finding-1b test interrogated the *host*
directly rather than the receipt, so it would have reported a defect against any
implementation whatsoever, and its finding-1c test assumed Candidate /0's return
type. Both were repaired **before** either capture was taken, and the BEFORE
capture was then re-run with the corrected probe so that the two captures are
comparable. The raw BEFORE transcript is preserved at
`errata-0.1/pre-errata-evidence/`.

The probe is now wired into `run-surface1-candidate.sh` as a standing regression
gate: **the runner exits non-zero if any finding is ever CONFIRMED again.**

---

## 1. FINDING 1 — MUTABLE SOURCE ALIAS / FALSE EDGE

**CONFIRMED. Classified as a truthfulness and deep-immutability defect, not as
missing test coverage.**

### What was reproduced

Candidate /0's `expansion-request` retained a `%host-form` slot holding **the
caller's own cons tree**, and Door 2 handed *that object* to the macroexpander.
A caller who mutated one literal field after Door 1, without touching the
request, got this:

```
stored source datum  == PRISTINE source ......... T
stored source datum  == MUTATED  source ......... NIL
receipt expanded     == expansion of PRISTINE ... NIL
receipt expanded     == expansion of MUTATED .... T
the expanded form actually carries version ...... '999
```

**The receipt asserted that the stored source datum produced an expansion that
was in fact computed from a different form.** That is precisely a false edge —
the one thing an account of "what form became what other form" exists to get
right. Candidate /0's central claim was therefore not merely untested; **for
mutable callers it was false.**

**1b — a mutable STRING leaf** reproduced the same defect through a different
door: CD/0 copies defensively, so the stored datum held the pre-mutation text,
while the macroexpander received the caller's live string object and the receipt
accounted for an expansion of the mutated text.

**1c — check E11 was mislabelled.** It read *"the same request performed twice
gives the SAME occurrence identity"*, and it **never performed the same request
object twice** — it constructed a fresh equivalent request. The claim it was
labelled as making was false: performing the *same object* twice with a caller
mutation in between yielded **different** occurrence identities.

### The repair — the canonical datum is the single authority

The `%host-form` slot is **gone**. Not guarded — removed. There is no path by
which a caller-owned object reaches Door 2.

```
DOOR 1   reads the caller's tree EXACTLY ONCE, encodes it, snapshots it,
         and keeps the immutable CD/0 datum and nothing else
DOOR 2   RECONSTRUCTS a fresh private host form from that datum, on EVERY
         performance, with DECODE-TERM — and expands that
```

`DECODE-TERM` is the declared inverse of `ENCODE-TERM`, and it is **public**,
because the claim *"the stored datum is what the macroexpander received"* is
only checkable if a reader can perform the reconstruction independently.

Two properties of the reconstruction are load-bearing:

- **Symbols resolve with `FIND-SYMBOL` and never `INTERN`.** A reconstruction
  that interned would *change the image it claims to be reading* and would
  manufacture a symbol the caller never wrote. A package or symbol missing from
  the image is a typed refusal — `:SOURCE-NOT-RECONSTRUCTIBLE`, with the upstream
  reason preserved — not a silent re-creation. **This is genuinely reachable**
  and is exercised (N7, N7b) by uninterning a symbol between the doors.
- **Strings are copied on reconstruction.** CD/0's reader already returns a fresh
  string; the explicit `COPY-SEQ` makes the isolation a property of *this* file,
  so a future CD/0 that stopped copying could not silently re-open 1b.

### The six proof obligations, each executed (selftest §N)

| # | obligation | check |
|---|---|---|
| 1 | caller mutation after Door 1 cannot change what Door 2 expands | **N1** |
| 2 | mutation by one macroexpansion cannot change a later performance | **N2** |
| 3 | mutable string leaves are isolated | **N3**, **N3b** |
| 4 | shared or circular cons structure faithfully represented or refused globally | **N4**, **N4b**, **N4c** |
| 5 | the stored source datum is exactly the source handed to the macroexpander | **N5**, **N5b** |
| 6 | the same request object performed repeatedly without drift | **N6** |

N2 is worth naming: it takes the form returned by one performance, **destroys it
in place**, and shows a third performance is unaffected and still equals the
second. N5b recomputes the expansion independently, from the reconstruction a
reader can build for itself, and compares.

E11 now says what it does; **E11b** makes the same-object claim and tests it.

---

## 2. FINDING 2 — SHARED-STRUCTURE COLLAPSE

**CONFIRMED, including the documentation claim that made it worse.**

`package.lisp` said: *"a CIRCULAR OR SHARED structure — refused; the grammar has
no DAG."* **The code did not do that.** Its check walked only each list's spine,
with a fresh table per call, so:

```
shared tree : distinct conses 3 · max refcount 2 · shared conses 1
copied tree : distinct conses 4 · max refcount 1 · shared conses 0
the two encodings are IDENTICAL ... T
```

A subtree reachable by two paths and two distinct equal copies **encoded to the
same bytes**. And a CAR-position cycle handed to the **public** `ENCODE-TERM`
**exhausted the control stack** rather than refusing — a public function turning
hostile input into a host accident.

*(Method note: the probe's own first census was broken in the same direction —
it guarded before counting, so every count was 1 and it could not have seen
sharing at all. It was rewritten as a reference-count traversal before any
verdict was recorded.)*

### The repair

One **global reference-count traversal**, run **once, inside `ENCODE-TERM`,
before any recursion**. A cons reachable by more than one path has a reference
count above one, and that single measurement covers **both** sharing and cycles —
a cycle is a reference that returns. It is guarded (terminates on cyclic input),
iterates on the spine and recurses only into CARs (a long list cannot exhaust the
stack).

Two new codes: `:SOURCE-TERM-SHARED-STRUCTURE`, `:EXPANDED-TERM-SHARED-STRUCTURE`.

**Refusing globally is viable, and that was measured before it was chosen.** The
real specimens carry no sharing at all:

```
 ADMISSION SOURCE    distinct   20 · max refcount 1 · SHARED 0
 ADMISSION EXPANSION distinct   39 · max refcount 1 · SHARED 0
  JUDGMENT SOURCE    distinct   29 · max refcount 1 · SHARED 0
  JUDGMENT EXPANSION distinct   56 · max refcount 1 · SHARED 0
```

Faithful DAG representation was the alternative. It is a **new representation
law** with its own design — labels, references, and a decode that rebuilds
sharing — and it is named in §6 as future work rather than bolted on here.

### A consequence that corrects the original RETURN

Candidate /0's return and check F5 both stated that the **full** expansion of
`derive-case` refuses with `:EXPANDED-TERM-UNREPRESENTABLE` / `UNINTERNED-SYMBOL`.

**Measured now, that expansion carries BOTH disqualifying properties** — 3 conses
reachable by more than one path **and** 13 uninterned symbols — and since the
global sharing check runs first, the reported code is
`:EXPANDED-TERM-SHARED-STRUCTURE`.

Reporting the first check that fires is correct behaviour. **Claiming the other
code was not**, and the claim is corrected here, in F5, and in the return.
**F5b** exhibits both properties and shows that a gensym-bearing expansion with
*no* sharing still lands on the other code — so the two are genuinely
distinguished rather than merged.

---

## 3. FINDING 3 — OCCURRENCE-TYPE REQUIREMENT VARIANCE

**CONFIRMED as a requirement variance.** The governing brief required *one
occurrence type*. Candidate /0 returned an occurrence **identity** — a bytes
datum — and defined no occurrence **object**.

**Two designs were available and they are NOT equated:**

- **(a) a first-class immutable occurrence object**, or
- **(b) an owner ruling that identity-only representation was intended.**

**I implemented (a), and I am flagging the choice rather than burying it.** The
reasoning: the original brief already required an occurrence type, so restoring
it is a repair rather than a new design decision, and the two designs differ in
what they permit — an identity is a *value asserting that an occurrence
happened*; an occurrence is *the thing that happened*, which can be handed
around, asked questions, and denied a public constructor.

**This is reversible and the owner may still rule for (b).** If so, delete the
struct and return the identity again; nothing else in the layer depends on the
object's existence.

```lisp
(defstruct (expansion-occurrence (:constructor %make-occurrence) (:copier nil))
  identity · request-identity · expanded-form-datum
  expanded-form-identity · disposition · occurrence-tag)   ; all :read-only
```

Minted **only on a completed expansion**; for a refusal the object does not come
into existence — not null, not absent-marked. The third value of
`PERFORM-EXPANSION` is now the occurrence; its identity remains reachable through
`EXPANSION-OCCURRENCE-IDENTITY`, and the receipt carries both.

---

## 4. FINDING 4 — PUBLIC CATALOGUE ACCESSOR

**CONFIRMED, both halves.**

```
REFUSAL-CATALOG-ENTRY-CODE          status :EXTERNAL  fbound T
REFUSAL-CATALOG-ENTRY-CLASS         status :EXTERNAL  fbound T
REFUSAL-CATALOG-ENTRY-PHASE         status :EXTERNAL  fbound T
REFUSAL-CATALOG-ENTRY-NOTE          status :EXTERNAL  fbound T
REFUSAL-CATALOG-ENTRY-REACHABILITY  status :INTERNAL  fbound T   ← live, private
```

The accessor is exported now (**L7**). But the second half is the more useful
finding: **the selftest reached it without noticing, because its `s1` macro used
`INTERN`**, which cannot distinguish an internal symbol from an external one. A
suite that reaches through `INTERN` cannot tell whether it is testing a public
surface or a private one.

`s1` now resolves through `FIND-SYMBOL` and **refuses at macroexpansion time
unless the symbol is `:EXTERNAL`**. The export census (**L5**) also gained a
`FIND-CLASS` predicate — a condition class is neither `FBOUNDP` nor `BOUNDP`, and
the first version of that census reported the layer's own condition type as dead.

---

## 5. THE NONDETERMINISM RATIONALE, REVISED

Candidate /0 said, in `package.lisp`, in its return, in its application, and in
its commit message:

> *"A receipt for a non-deterministic expansion would be an account that could
> not be true twice."*

**That was wrong, and it was the most rhetorically attractive sentence in the
candidate — which is why it survived.** A receipt accounts for **one
occurrence**. A nondeterministic occurrence can have a perfectly truthful
receipt: it says what form became what other form **on that occasion**, which is
exactly what a receipt is for. Determinism is a property a reader may want; it is
**not a precondition of truthfulness**, and the layer must not confuse the two.

**The actual reason, which is the only one:**

> Gensym-bearing expansions are refused because **the current term grammar cannot
> injectively account for uninterned-symbol identity and binding structure**. An
> uninterned symbol has no package, so it has no namespace; and two distinct
> gensyms bearing one name collapse to a single identifier datum, because CD/0
> compares identifier segments bytewise. The grammar therefore cannot represent
> the structure that makes such a symbol mean anything.

**A grammar limit, not an epistemic one.** Check **N8** asserts that the code
agrees: the refusal such an expansion lands under names the **term grammar** as
its upstream category.

---

## 6. WHAT THIS ERRATUM DID NOT DO

- **No stranger audit.** Still owed, now against the corrected target.
- **No adoption, no freeze, no governing floor.**
- **No new language feature. Form /3 not opened. Surface /2 not opened.**
- **No repair of the two Surface /0 defects** reported in the candidate's handoff.
  They are still reported and still not repaired.
- **No DAG representation.** Sharing is refused, not represented. A faithful
  DAG encoding is the named next representation law, together with
  alpha-normalization for uninterned symbols — the two together are what an
  expansion layer would need to account for gensym-bearing expansions at all.
- **No claim that the repair is complete.** Six findings were reported, six were
  confirmed, six are refuted by the same instrument. **That is a statement about
  six findings, not about the layer.**

---

## 7. THE NUMBERS AFTER THE REPAIR

```
surface1-selftest           107 checks / 0 failed · exit 0   (was 90)
stub-image-fixture            8 checks / 0 failed · exit 0   (unchanged)
de-expansione-testata        24 checks / 0 failed · exit 0   (was 23)
reproduction probe            0 of 6 findings confirmed      (was 6 of 6)
                            ───
                            139 checks / 0 failed

public exports               75 declared == 75 live          (was 65)
refusal catalogue            20 entries · 17 protocol · 3 alarms   (was 17/14/3)
grammar version              1 -> 2   the admissible term set shrank
procedure version            1 -> 2   Door 2 reconstructs rather than aliases
policy version               1        ceilings unchanged
```

**EVERY IDENTITY THIS LAYER MINTS DIFFERS FROM CANDIDATE /0'S**, because the
grammar and procedure versions are committed into the request identity and
everything downstream of it. That is correct: they are accounts of a different
procedure, and an identity that did not move would be claiming otherwise.

Predecessor floors, re-run after the erratum: **form floor 199/0, language floor
654/0, byte-identical.** `git diff` across CD/0, Slice /1, Slice /2, Surface /0
and Form /0/1/2 is empty.

---

*— Claude Opus 5 (1M context), 2026-07-28. SBCL 2.4.6 operation-checked through
the wrapper. Subject `2e21f367`, preserved. Standing: errata candidate,
**not audited, not adopted, not frozen, on no governing floor.***
