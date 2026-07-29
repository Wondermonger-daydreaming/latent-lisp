# de-vadimonio — DESIGN NOTE

*Written before implementation, as required. The live source governs; the
reconnaissance that preceded this note was treated as hypothesis, and every
load-bearing claim below was re-verified against the tree before being written
down.*

**Specimen, not layer.** This is an application-private reconnaissance-by-
construction. It is not Language Obligation /0 and does not open it. That name
remains a fenced frontier: `LANGUAGE-FORM-1-WORK-ORDER.md:19` carries
`Language Obligation /0: NOT opened`, and both Form /1 (§18) and Form /2 (§16)
list it among explicit non-goals. Nothing here reverses those reservations.

**What this specimen is FOR.** `de-pignore/SPECIMEN-RETURN.md` ruled:

> *public Obligation layer: NOT WARRANTED … A public layer would mint a
> ministry for a single inhabitant. … if a second genuine inhabitant appears,
> the specimen is already written and the question reopens with evidence
> rather than enthusiasm.*

`de-vadimonio` is the candidate second inhabitant, built to that standard: if
it stands, the reopening question acquires evidence; if it collapses into
`de-pignore`'s tenant or into a rejected generalization, the return must say so
and the reservation stands confirmed. Either outcome is the deliverable.

---

## 0. The name

*Vadimonium*: in Roman procedure, the defendant's solemn undertaking to
**appear** before the court on a set day. It is opened by an explicit act, it
binds the one who gave it and nobody else, a merely similar appearance (wrong
person, wrong standing) does not discharge it, and a deserted vadimonium
(*vadimonium desertum*) remains on the record no matter what happens later.
The word collides with nothing in the tree (verified: zero occurrences), and
deliberately avoids every reserved term: *pledge/pignus* is `de-pignore`'s,
*obligation* is Slice /0 projection vocabulary, *discharge* is Slice /1
premise vocabulary, *acknowledgment/settlement/reconciliation* belong to
AP0 and Kernel /0.

## 0b. Location decision

```
mneme/language-form-2/de-vadimonio/APPLICATION.lisp
```

Inhabited applications live at `<layer-dir>/<de-name>/APPLICATION.lisp`, where
the layer directory names the machinery the application inhabits (soft
convention, recorded in `de-pignore/DESIGN-NOTE.md` §0, not a law). The
vadimonium's opening subject is a **Form /2 transformation receipt** — the
undertaking exists because a Form /2 rewrite happened — so it lives under
`language-form-2/`, beside `de-forma-mutata`. Form /1 is used as a client (the
witness source), Slice /1 and Slice /2 are used as clients in the terminal
submission demonstration, borrowing `de-forma-mutata`'s fixture world.

---

## 1. The question

> Form /2's own law is that a rewritten successor **inherits nothing** and
> must re-enter the proposal pipeline *"as though no predecessor existed"*
> (form2 package header; RETURN §13: *"a successor that re-enters proposal as
> a stranger to its own history"*). The layers are deliberately amnesiac
> across that boundary. **Can an author's explicit undertaking — that this
> exact successor will be carried through Form /1 re-entry — remain
> identifiable and open across unrelated intervening work, be refused by
> merely similar witnesses, be discharged only by the exact one, and keep a
> truthful record of failed appearances that no later success rewrites —
> without a new language layer, without mutating any object from :OPEN to
> :CLOSED, and without the substrate ever consulting it?**

The last clause is load-bearing: the vadimonium binds the **author's
program**, never the machinery. A negative control proves Form /1 will
validate and submit without ever asking about vadimonia.

## 2. What exact mechanism is being generalized?

The same shape `de-pignore` borrowed from Kernel /0, at second remove —
verified in the same sources (`kernel0/uncertain-effect.lisp:52` — *"no
record-local resolved flag exists"*; `kernel0/folds.lisp:28–32, 421–429,
447–508`):

- immutable open record with **no status slot**;
- receipts carrying prior→resulting commitment plus residue;
- openness **derived by folding** an explicitly supplied ordered history;
- a receipt closes only when an exact conjunction holds; refusals never touch
  the fold; nothing is ever removed from history.

No Kernel /0 record type is imported. No Kernel /0, AP0, or PJ0 office is
touched: no attempts, seats, frontiers, retry safety, supersession,
acknowledgment classes, request identities, or cancellation. The subject is
not an effect and never crosses an image boundary.

## 3. What fact does the vadimonium remember that existing receipts do not?

The stop-condition question, answered against the live objects:

A Form /2 receipt already remembers *this input became this output by this
declared transformation* — including `output-datum-identity`. A Form /1
validated form already remembers *this subject datum was validated under this
grammar and policy* — including `subject-identity`. Both identities are the
same construction (a CD/0 bytes-datum of the subject's canonical octets —
`form1.lisp` `%identity`, `form2.lisp` `%identity`; verified), so a program
can already join them **by hand**, per act.

Three facts are genuinely absent:

**(a) The election.** Nothing records that an author **undertook** to carry
this successor through re-entry. The Form /2 receipt is evidence for why an
author *might* undertake; it is never the undertaking. (The same load-bearing
gap as `de-pignore` §2(a), over a different subject.)

**(b) The kinship across the amnesia.** Form /2 deliberately refuses to give
the successor any standing relation to its predecessor, and Form /1
deliberately receives it as a stranger. No object anywhere binds *the
successor identity a rewrite produced* to *the subject identity a later
validation must exhibit*. The vadimonium is precisely the author's memory
that the stranger is kin — held outside both layers because both layers
refuse, correctly, to hold it.

**(c) Fold-derived openness across intervening work.** Both layers answer
per-act; neither holds a requirement that persists between acts.

**Verdict on the stop condition: DO NOT STOP** — (a) and (b) are facts no
existing object holds. But the honest size is the same as `de-pignore`'s: an
election plus a retained expectation plus a fold. The specimen's value is
that this thin mechanism now has a **second, structurally different tenant**
— or provably does not.

## 4. Why is this a SECOND inhabitant and not de-pignore's tenant again?

The distinctions, stated so the return can test them:

| | de-pignore | de-vadimonio |
|---|---|---|
| subject | an **absence of evidence** (a `:missing` Slice /2 premise) | **standing lost by transformation** (a successor that inherits nothing) |
| opening evidence | a **refusal** receipt (`derive/2` refused) | a **success** receipt (the rewrite succeeded — and *because* it succeeded, the successor is standing-less) |
| span | within one layer (Slice /2 premise under its own contract) | across the deliberate amnesia **between two layers** (Form /2 output → Form /1 subject) |
| recognition | admissibility **probe** through the real `derive/2` under the retained contract | **exact identity recognition**: witness subject identity `equal-datum` the committed successor identity, under retained grammar/policy expectations |
| discharge witness | an admitted support | a real Form /1 **validated form** for the exact successor |

Neither rejected generalization applies: this is not *poetic closure* and not
*ordinary program-form incompleteness* — the successor is complete and
well-formed; what it lacks is **standing**, and the tree's own law says so.

If review shows these distinctions collapse — that a "successor owing
re-entry" is just an elected evidentiary requirement wearing different
clothes — the return must say the second tenant failed to materialize.

## 5. Why is a successful rewrite not automatically a vadimonium?

The same refusal `de-pignore` §4 made, at this subject: a rewrite receipt is
a property of the **world**; an undertaking is a property of an **author's
decision about the world**. Every Form /2 receipt would otherwise manufacture
an obligation silently, forever — asserting someone owes something merely
because something changed. `UNDERTAKE-VADIMONIUM` therefore requires an
explicit caller-supplied intent datum and an explicit act identifier.
A negative control proves construction refuses without them.

## 6. What event creates the vadimonium?

The `UNDERTAKE-VADIMONIUM` call, and nothing else. It requires:

- the exact Form /2 **transformation receipt** (the real object);
- the **successor datum itself** — and the constructor verifies
  `%identity(successor) equal-datum receipt.output-datum-identity`, so the
  binding is checked, never trusted;
- an explicit canonical **intent** datum and **scope** description;
- an explicit **act identifier** (`:vadimonium-act-id`).

It retains, by value at undertaking time: the awaited subject identity (the
successor's), the transformation-receipt identity, and the **retained
expectations** — Form /1's grammar identity/version and policy
identity/version then in force. The identity model is `de-pignore`'s
corrected one, adopted as sealed vocabulary:

```
occurrence-identity  = (:vadimonium-act-id ACT  :content CONTENT-IDENTITY)
content-identity     = intent · transformation-receipt identity ·
                       awaited subject identity · scope ·
                       retained grammar id/version · retained policy id/version
```

Distinct act IDs over identical content yield distinct occurrence identities
with equal content identities; a check proves both halves. Replayed act IDs
are outside the enforceable boundary (no registry), stated not silently
decided.

## 7. What exact event counts as appearance (the discharge)?

A `TRY-PRESENT-APPEARANCE` call that finds **all** of:

1. the fold over the supplied history says the vadimonium is still owed;
2. the presented witness is a real Form /1 **validated-petition-form**;
3. witness subject identity `equal-datum` the awaited subject identity;
4. witness grammar identity/version equal the retained expectations;
5. witness policy identity/version equal the retained expectations;

returns an `APPEARANCE-RECEIPT` (own identity; prior `:owed` → resulting
`:appeared`; residue `NIL`). Anything else returns a typed
`VADIMONIUM-REFUSAL` naming exactly what failed, and **refusals never touch
the fold**. The fold closes only on a receipt whose exact conjunction holds —
target occurrence identity, target content identity, resulting `:appeared`,
residue `NIL` — each conjunct proven to bite by a planted receipt, plus one
positive control proving the conjunction is satisfiable (a teeth suite in
which everything refuses is indistinguishable from one that works).

**The desertion.** An appearance journey can fail at Form /1 itself: the
author carries the successor to the doors and Form /1 refuses it in its own
voice. `RECORD-DESERTION` mints a `DESERTION-RECORD` (own identity; the
Form /1 refusal's facts snapshotted via public readers; resulting commitment
still `:owed`). Desertions enter history and **never close**; they are the
truthful record that an undertaking was attempted and not met. Because
Form /1 validation is deterministic over a fixed datum, a deserted
vadimonium over an invalid successor can never later be discharged — the
specimen exhibits one such vadimonium left honestly open forever, beside a
second (over the repaired successor) that discharges. **Later success of the
kindred undertaking must not close, alter, or reword the deserted one** —
checked by byte-comparing the desertion record's identity and every reader
before and after the kindred discharge, and by folding the deserted history
again after it.

**Partial residue, declared in advance:** appearance is structurally
all-or-nothing — a validated form either exhibits the exact subject identity
or it does not. As in `de-pignore`, no partial case will be invented to
populate the residue field; if none exists, the return says so.

## 8. Why is appearance not validation, truth, authority or standing?

Because the witness **is** the standing-bearer and the vadimonium confers
nothing. Form /1 alone validated the successor; the appearance receipt only
records that *the thing an author undertook has been exhibited and
recognized under the rule they retained*. It grants no claim, mints no
basis, does not make the successor lawful, does not entitle submission, and
is consulted by no governing machinery. Two controls make this executable:

- **the substrate ignores vadimonia** — a petition validates and submits
  through the real Form /1 path with no vadimonium anywhere in its history;
- **the author's program, not the machinery, gates on the fold** — the
  dependent action (materialize + submit through the real Slice /2 world)
  is taken only after the fold says not-owed, and the withholding before
  that is the author's recorded decision, not a substrate refusal.

## 9. The vertical (the inhabited narrative)

One fixture world, borrowed from `de-forma-mutata` (same schema shapes, with
attribution):

1. An original petition datum O (support reference "clearance") earns
   standing (Form /1 propose → validate → materialize).
2. **Rewrite 1** (Form /2): O's support reference is replaced with a lawful
   CD/0 datum that is **not reference-shaped** — the B-shape's move, aimed at
   a support slot. The rewrite **succeeds**; successor S1 is standing-less
   and, unknown to the undertaking author, unvalidatable.
3. **Undertaking 1**: the author undertakes vadimonium-1 for S1.
   Negative controls: no intent → refusal; predecessor passed as successor →
   `:successor-identity-mismatch`; non-receipt → `:not-a-transformation-receipt`.
4. **The desertion**: Form /1 refuses S1 in its own voice;
   `RECORD-DESERTION`; fold-1 still owed. Vadimonium-1 will remain owed for
   the rest of the run — that is the truthful state, not a loose end.
5. **Rewrite 2**: S1's broken support is replaced with a lawful reference
   **different from O's** → successor S2 + receipt-2 (so S2's identity is
   distinct from O's — the chain O → S1 → S2 has three distinct identities;
   a head-repair narrative was rejected in design because it would make S2
   byte-identical to O and the stale witness would truly discharge).
   **Undertaking 2**: vadimonium-2. Note S2 descends from S1, yet S2's
   validated form cannot appear for vadimonium-1 — **descent is not
   identity**; the vadimonium awaits S1 itself.
6. **Irrelevant intervening work**: an unrelated rewrite and an unrelated
   validation occur; fold-2 unchanged.
7. **Near-matches, refused**: the original O's own validated form (right
   shape, real object, **stale subject**) → refused; a sibling successor S3's
   validated form (a different lawful replacement applied to S1, validated) →
   refused; and cross-presentation — S2's own validated form offered to
   vadimonium-1 → refused (its subject is S2, not S1). Fold-2 still
   owed. No similarity is measured anywhere — a near-match and a far-match
   fail identically; the fixtures are near so the refusal is seen to be
   exact rather than approximate.
8. **The appearance**: successor-2 validates (real Form /1); presented →
   appearance receipt; fold-2 not-owed.
9. **Cross-closure refused**: appearance-receipt-2 folded into vadimonium-1's
   history does not close it.
10. **History truth**: desertion-record and near-match refusals byte-identical
    after the discharge; fold-1 still owed.
11. **The dependent action**: only now does the author materialize and submit
    successor-2 through the real Slice /2 world; the earlier withholding is
    the author's recorded branch on the fold.
12. **Teeth**: planted receipts proving each fold conjunct bites + the
    positive control; aliasing teeth on every aggregate reader (defensive
    snapshots — `de-pignore` D1); a planted unexpected condition **escapes**
    rather than laundering into a semantic refusal (D2); the transcript is
    raw, tracked, and mechanically reconciled with no hard-coded count (D3);
    every advertised refusal reason has an executable path (D4).

## 10. What this specimen will NOT show (declared before building)

- **No persistence, replay, or cross-image claim.** The fold consumes a
  caller-supplied ordered list. There is no store. (PJ0 is adopted as spec;
  no journal store is wired into the in-memory core.)
- **No global exactly-once.** `:already-appeared` is enforceable only
  relative to the supplied history; a caller omitting the receipt can obtain
  another. Demonstrated, not solved with a registry.
- **No authority, truth, standing, or minted basis.** See §8.
- **No enforcement.** The substrate never consults a vadimonium; the gate
  lives in the author's program. This is a feature and is proven, not
  excused.
- **No wall-clock.** A vadimonium has no term, no expiry, no scheduler. The
  Roman *dies certus* is exactly the part NOT taken: nothing here is
  governed by time, only by succession.
- **No second relation.** Recognition is exact identity plus retained
  expectations. No pattern language, no predicate parameter, no callback —
  a CD/0 datum cannot be a function, and no caller-supplied procedure
  reaches any surface.
- **No external corroboration.** All greens are same-family
  self-consistency. An adversarial review by a differently-charactered hand
  is part of the build plan, and is still same-model-line review; the
  return will say so.

## 11. Vocabulary discipline

Uses: *vadimonium, undertake, appearance, desertion, owed/appeared* (private
commitment values). Avoids as owned elsewhere: *pledge* (de-pignore),
*obligation* (Slice /0 projection), *discharge* (Slice /1 premises),
*acknowledgment / settlement / reconciliation / cancellation* (Kernel /0,
AP0), *witness* is used only in its Slice /0 sense when speaking of Slice
objects and otherwise avoided in exported names, *canonical* reserved for
CD/0 values (a host copy is a *defensive snapshot*). The occurrence-vs-
content identity split is adopted as sealed vocabulary, not renamed.

---

*Claude Fable 5 (lab chair), 2026-07-29. Written before implementation.
Implementation charged to an Opus hand under this note; adversarial review
follows before any return is written.*

---

# ADDENDUM — CENSOR REVIEW (2026-07-29)

*Appended after implementation and after CENSOR's adversarial pass. **Everything
above this line is the original note, unedited** — it is the pre-implementation
record and its value is that it was written before anything ran. This addendum
does not correct the text above; it records where execution found the text
claiming more than it holds, and what the implementation now does instead. The
verdict was `REPAIR NEEDED — enumerated defects`, with the central
second-tenant claim SURVIVING under executed test.*

## A. §4's "complete and well-formed" is true only of the discharging branch

§4 defends the second tenant by ruling out *ordinary program-form
incompleteness*: "the successor is complete and well-formed; what it lacks is
**standing**, and the tree's own law says so."

**That is false of S1**, the successor vadimonium-1 awaits. Form /1 refuses S1
at `:propose` with code `:malformed-reference`, category **`:grammar`**
(transcript checks [020]–[021]). S1 is not a standing-less well-formed datum; it
is grammatically malformed. The sentence is true of **S2**, the successor that
appears — and only of it.

The distinction §4 draws survives the correction, but by a different argument
than the one written. CENSOR ran the steelman: *vadimonium-1 is "an obligation
over a program awaiting repair"* — and it dies on executed evidence, because
awaiting-repair means **repair discharges it**, and S2 (the repair of S1),
validated by real Form /1, is **refused** for vadimonium-1
(`:subject-identity-mismatch`). Descent is not identity. A deserted vadimonium
over an unvalidatable successor is *permanently undischargeable* — the opposite
of an incompleteness, which is completable by construction.

**Consequence for the return:** the second tenant's distinctness is a difference
in **relation and span**, not in mechanism. §3 already conceded the shared
skeleton ("the honest size is the same as de-pignore's"); the return must say
so in those words, because a stranger reading §4's "structurally different
tenant" could take more than the evidence gives.

## B. §11's discharge-avoidance was practiced as names-only; it is now scoped

§11 lists *discharge* among words "avoided as owned elsewhere" (Slice /1 premise
vocabulary). As implemented in the first round, the avoidance was **names-only**
— no exported name, no type, no slot bears the word — while it appeared in two
rendered check labels, in rendered prose, and eleven times in this note.

**Scope, declared:** the word is avoided in **exported and internal names, in
rendered check labels, and in rendered program prose**. The specimen was swept
accordingly. It is *retained* in source comments and throughout this note, where
it is the ordinary English word for the concept and no object bears it. A
vocabulary discipline that claimed more than names would have been a discipline
nobody was practicing.

## C. A ceiling §10 did not name: RECORD-DESERTION binds nothing

§7 introduces the desertion as "the truthful record that an undertaking was
attempted and not met." The transition type-checks its evidence — that it **is**
a Form /1 petition refusal — and stops. It does not, and with Form /1's public
reader surface cannot, check that the refusal is the one **this** vadimonium's
successor met.

CENSOR recorded Form /1's refusal of **S1** as a desertion of **vadimonium-2**,
whose own successor validates cleanly; the record carried vadimonium-2's
identities beside S1's refusal facts as if that had been its journey.

This is now the **third declared unenforceable**, beside replayed act
identifiers (§6) and global exactly-once (§10) — added to the specimen's
does-not-show list and **demonstrated** in the run rather than solved. The
repair is a declaration, deliberately: UNDERTAKE binds its successor to its
receipt and PRESENT binds its witness to the awaited subject, but a half-binding
at DESERT would be a label stronger than the thing it names. The record is an
account of what an author says happened. It never closes anything, so an unbound
record can be an *untrue account* but never a *false closing*.

## D. The fold's conjuncts, extended — and what they still do not police

§7 fixed the closing conjunction at four: target occurrence identity, target
content identity, resulting `:appeared`, residue `NIL`. The implementation
carried this file's procedure identity and version **inside** the content
identity and argued that conjunct 2 therefore covered them.

**True of the identity; false of the receipt.** CENSOR built a receipt
*declaring* `:procedure-identity "NOT-THIS-PROCEDURE-AT-ALL"` and
`:procedure-version 99` while copying the correct identity bytes — it **closed**;
so did one declaring `:previous-commitment :never-owed`. Three slots the receipt
struct carried were read by no closing path.

**The conjunction is now SEVEN**, at de-pignore parity
(`de-pignore/APPLICATION.lisp:549-557`): the two identities, the receipt's own
procedure identity and version, its previous commitment `:owed`, its resulting
commitment `:appeared`, and its residue `NIL`. Each of the three new conjuncts
has a planted receipt proving it bites.

**What the extension does police:** what a receipt **declares about itself**.
**What it does not, and cannot:** where the receipt came from. A receipt that
copies every field correctly closes — now **demonstrated in the run** rather
than left for a reader to discover. A fold cannot authenticate provenance from a
record's own contents; a receipt is an ACCOUNT, not an AUTHENTICATION, and this
extension does not change that word.

## E. What CENSOR did not find

No probe moved the mechanism. Under every adversarial history — garbage
elements, foreign records, duplicates, reordering, cross-plants in both
directions — the shipped fold, transitions and records behaved exactly as their
docstrings claim. The defects were in the **certification apparatus** (four
teeth that could not fail, three that compared an event to itself, a suite blind
to its central identity's composition, a read-only census that counted rather
than bound) and in **one unbound transition plus two overclaims of prose**. All
are repaired or declared above.

*— FIDEIUSSOR (Claude Opus 5), recording CENSOR's findings (Claude Fable 5) and
the chair's adjudication, 2026-07-29. The original note above stands unedited.*
