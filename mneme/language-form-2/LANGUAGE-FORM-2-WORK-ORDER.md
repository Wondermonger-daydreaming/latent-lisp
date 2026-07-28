# LANGUAGE FORM /2 — CANDIDATE /0 — WORK ORDER

## "The Form May Be Rewritten"

*Work order only. No Lisp source, no package, no runner, no floor change.
Nothing in Form /0, Form /1, Slice /0/1/2, Kernel /0, CD/0 or Surface /0 is
touched by this branch.*

---

## 0. AMENDMENT 1 — the colleague read, and what it changed

*Owner ruling **AMEND AND IMPLEMENT LANGUAGE FORM /2 CANDIDATE /0**, 2026-07-27,
against work-order commit `9d2c37f3`.*

### 0.1 The review's standing — recorded before anything it produced

```
review class          known-correspondent, SHARED-ROOT design review
independent standing  NONE
stranger audit        OWED, after Candidate /0 closes (EG-7 stands)
```

**This review is not a stranger audit and earns no independent corroboration.**
The reviewer has prior exposure to this lab's Lisp work and holds a published
correspondence chamber inside this repository. **Nothing below may be cited as
corroboration, second-family confirmation, or an audit.** What it is: a
competent colleague reading a design and finding real defects in it — which is
worth having, and is not evidence.

### 0.2 What the amendment changes

| § | change |
|---|---|
| 3.2 | **B's account corrected.** B is *not* "one reader call and zero capability." |
| 5 | **The proposal phase is made real** — two explicit doors, not one. |
| 6, 7 | **Three identities**, separating a host's *tag* from a transformation's *occurrence*. |
| 6.2 | The identity reduction is **kept but re-stated as a narrow theorem** with named assumptions, and the two omitted fields become **verified derived projections**. |
| 8 | Flat history **narrowed**: an edge, not a genealogy. |
| 9 | The original probes are **preserved unchanged as historical evidence**, with four newly-identified limitations recorded, and an exact Candidate /0 measurement added. |
| 8a | Staging discipline: **observability**, not pre-allocation prediction. |
| 10 | No-op moves to the **observed-event boundary**; CD/0 rebuild failures get an exact code. |
| 11 | Candidate D **renamed**; the disposition vocabulary is constrained. |
| 12a | A complete **public API ledger** is added before any executable body. |

**Accepted without reopening** (the ruling's list, recorded so no later reader
mistakes settled ground for open ground): the central law · Architecture A ·
inert CD/0 in and out · exactly one operation · no caller-supplied procedure ·
no intent field in the structural receipt · no standing inheritance · no
macroexpansion · no recursive receipt history · no hash protocol · Form /0 and
Form /1 byte-untouched.

---

## THE CENTRAL LAW

```
A rewrite remembers what changed.
It does not decide what the change means.
```

A canonical form datum may be subjected to **one explicit, bounded structural
transformation**. The transformation produces a successor canonical datum and a
transformation receipt, or a retained refusal.

**The successor inherits nothing.** Not validation, not execution standing, not
authority, not evidentiary standing. It must re-enter the Form /0 or Form /1
proposal pipeline as a new candidate, on its own merits, as though no
predecessor existed.

A transformation receipt establishes exactly one proposition:

> *This exact input datum was changed by this exact declared transformation into
> this exact output datum.*

It does **not** establish semantic preservation, equivalence, correctness,
validity, admissibility, authorization, successful realization, or successful
petition submission.

---

## 1. PREFLIGHT, VERIFIED LIVE

Read from the live repository on 2026-07-27, not from memory:

```
lab main HEAD              6970dcbd4284fba57de4e1d4f765e00a5786bfe6   0 unpushed
public mirror tip          4633dae3c7aafc371740e59b0a44e9d9a3213749
Form /0 subtree  lab       e4f3512396f788b28221ffda9ab8df94e4cb1299
                 public    e4f3512396f788b28221ffda9ab8df94e4cb1299   IDENTICAL
Form /1 subtree  lab       da16ebaa542599cbc31566718c2711fecec24baa
                 public    da16ebaa542599cbc31566718c2711fecec24baa   IDENTICAL
experiments/               clean, 0 tracked modifications
root _staging/             222 entries / 325 files — READ, NOT TOUCHED
Form /2 naming pre-existing NONE  (no branch, no tracked path, no mirror path)
```

**Form /1 executable delta after its audited target `9f37cd16`:
`git diff --name-only 9f37cd16 main -- '*.lisp' '*.asd' '*.sh'` returns empty.**
The audit merge added documentation only. Verified, not assumed.

Worktrees live at merge time: `Claude-Code-Lab [main]` · `wt-language-form-2
[language-form-2-work-order]` · `wt-form1-audit-intake` · `wt-form1-candidate-0`
· `wt-language-form-0` · `wt-de-pignore`.

---

## 2. LIVE DEPENDENCY MAP

### 2.1 `LISP-PLUS-CD0` — the substrate, and the shape of the hole

Nine families: unit · boolean · integer · rational · string · bytes ·
identifier · **sequence** · **record**.

**What CD/0 gives us, read at `canonical-datum/common-lisp/package.lisp`:**

| need | exported | symbol |
|---|---|---|
| descend a sequence | ✅ | `sequence-datum-ref` · `sequence-datum-length` · `sequence-datum-elements` |
| descend a record | ✅ | `record-datum-ref` · `record-datum-key-at` · `record-datum-value-at` · `record-datum-size` · `record-datum-fields` |
| exact structural equality | ✅ | `equal-datum` |
| canonical encoding | ✅ | `canonical-octets` · `decode-exact` · `octets-length` |
| construct | ✅ | `make-sequence-datum` · `make-record-datum` · `make-record-entry` · `make-bytes-datum` · … |
| **a path / locator / cursor type** | ❌ | **DOES NOT EXIST** |
| **replace / substitute / splice at a position** | ❌ | **DOES NOT EXIST** |
| **any mutator on a constructed datum** | ❌ | **DOES NOT EXIST** |
| a hash or content-digest function | ❌ | does not exist, and inventing one is forbidden |

**This absence is the single most load-bearing fact in the design, and it is
good news twice over.**

1. **The path type must be invented by Form /2.** It is not inherited, so it must
   be specified exactly here (§4) rather than assumed.
2. **`REPLACE-AT-PATH` can only be a PURE REBUILD** — descend with readers,
   reconstruct the ancestor spine with constructors. Therefore *"the output is
   constructed without mutating the input"* is **true by construction, not by
   discipline.** There is no mutator to misuse. NC-5 below is satisfied by the
   substrate, and the implementation cannot regress it without importing a
   facility that does not exist.

The normative law is already written and has **no operation attached to it** —
`mneme/spec/CANONICAL-DATUM-SPEC.md:1143` §19.4: *"An operation that conceptually
changes a sequence element, record field, string, bytes value, identifier segment,
or number produces a new datum. It never changes the old one."* CD/0 states the
discipline of an operation it does not provide. **Form /2 provides it.**

### 2.1a The rebuild is not free — a measured-cost hazard, named before it bites

Rebuilding a record spine calls `make-record-datum` once per record level, and
each call re-runs `%normalize-record-entries` (`cd0.lisp:884`): it re-derives
every key's ValueBytes, re-sorts by those bytes, re-checks duplicates, and
**re-charges `max-total-record-key-octets` (default 1,048,576) per level, per
edit**.

**The cached key bytes cannot be reused through the public surface.**
`record-datum-fields` (`cd0.lisp:948`, read directly) constructs *fresh*
`%record-entry` objects carrying only `:key` and `:value` — **the `key-bytes`
cache is stripped.** There is no exported way to rebuild a record while keeping
it.

A second, subtler consequence: `%normalize-record-entries` charges its work under
the stage name **`"host-import"`** (`cd0.lisp:934`). CD/0's twenty stage names
(`CANONICAL-DATUM-SPEC.md:1258-1284`) contain **no structural-edit stage**, so a
budget refusal raised while rebuilding a spine will be *labelled as a host
import*. Form /2 must not paper over this: it should **catch the CD/0 resource
failure at its own boundary and re-raise it under its own honest code**
(`:output-octets-exceeded` / `:identity-octets-exceeded`), rather than let a
mislabelled stage escape to a host that will read it as an import problem.
Entrance gate EG-8 fixes this as a measured requirement.

### 2.1b The one existing substitution primitive, and why it is not reusable

Form /0 has an internal `%substitute` (`mneme/language-form-0/form0.lisp:666`),
called from exactly one place (`instantiate-form`, `:731`). It substitutes **by
declared hole identifier**, not by path; it is `%`-prefixed and appears in none of
Form /0's exports. It is not a path-replacement facility and **cannot be reached
or reused.** It is recorded here so that nobody rediscovers it and mistakes it for
prior art.

### 2.1c The slot is unclaimed, and this work order claims it

Form /0's return recorded the deferral explicitly —
`LANGUAGE-FORM-0-RETURN.md:180`:

> `| edit scripts · paths · budgets · shavings | **not extracted** | Transformation is Form /1 at the earliest. |`

**Form /1 did not take it.** It shipped as a petition/submission layer and
consumes paths only as refusal annotations. The transformation frontier named by
Form /0 has been open since, and **Form /2 is the layer that claims it.**

### 2.2 `LISP-PLUS-FORM1` — re-entry target, and **not a code dependency**

Form /2 calls **no** Form /1 transition and reads **no** Form /1 phase object.
It produces a CD/0 datum; a *host* then hands that datum to `PROPOSE-PETITION`.

The one fact that makes this architecture buildable, read at
`language-form-1/package.lisp:71,74,90`:

```
#:petition-datum                    a program writes a petition datum by hand
#:propose-petition                  a datum enters the pipeline here
#:proposed-petition-form-datum      the datum is readable back off a proposed object
```

**The absolute rule, inherited verbatim from Form /1 §2.2: never
`lisp-plus-form1::`.** If implementation discovers a needed internal, **stop and
report the contradiction** (EG-2).

### 2.3 `LISP-PLUS-FORM0` — re-entry target, symmetric, and asymmetric in one way

`propose-form` · `proposed-form-p` · `proposed-form-datum` are exported (99
symbols total).

**But `VALIDATED-FORM-DATUM` is NOT exported** — the validated-form reader set is
`-p · -subject-identity · -identity · -predecessor-identity ·
-instantiated-identity · -grammar-identity · -grammar-version ·
-environment-identity · -environment-version · -environment-content-digest ·
-operator-identities · -budget-id · -receipt`, with **no `-datum`**. Form /1 is
the same shape: `validated-petition-form-*` has no `-datum` either.

**Read this fact twice, because §4 of the direction turns on it:**

```
PROPOSED phase   datum is publicly recoverable   in BOTH forms
VALIDATED phase  datum is publicly recoverable   in NEITHER form
```

### 2.4 Not dependencies at all

`LISP-PLUS-SLICE2` — never called by Form /2. `DERIVE/2` appears only in the
inhabited application, and only because a *host* submits a Form /1 petition that
a Form /2 transformation happened to have produced earlier. **Form /2 has no
governed operation.**

`LISP-PLUS-KERNEL0`, `LISP-PLUS-SLICE0`, `LISP-PLUS-SLICE1`, Surface /0 —
observed, not called.

### 2.5 The Atelier — **executable precedent, CITE, never depend**

`replace-at-path` **already exists twice** in this repository, fully worked out —
`mneme/atelier/instruments/de-torno.lisp:191` and
`mneme/atelier/instruments/de-fornace.lisp:182`. Neither is importable, and the
reasons are structural, not stylistic:

- they operate on **host cons trees via `nth`**, not CD/0 data;
- their identities come from `atelier-root.lisp`'s `toy-digest`, a **FNV-1a/64
  that its own header calls "not cryptographic"** — and which Form /0 explicitly
  **refused** (`LANGUAGE-FORM-0-RETURN.md:176`);
- both files' headers disclaim their own durability.

**What Form /2 may cite as working precedent, by name:**

| from | precedent |
|---|---|
| `de-torno` | the three-function split `plan-turn` / `validate-plan` / `commit-turn` (`:332,:352,:457`) |
| `de-torno` | **pure preflight before resource spend** (`:464-473`) — a stale or precondition-failing plan consumes no budget; gate `refusal-is-resource-pure` (`:766-772`) |
| `de-torno` | per-edit exact `before` preconditions (`:421-425`) |
| `de-torno` | **`standing-before = standing-after` enforced in the receipt validator** (`:514-519`), gate `form-change-does-not-mint-truth` (`:758-762`) — *this is the central law of Form /2, already executable somewhere else in this tree* |
| `de-torno` | procedure id **+ version** with a `pass-version-mismatch` gate (`:367-372`) |
| `de-fornace` | **refusal as retention**: `slag` + `archive-condition-as-slag` + the `archive-as-slag` restart (`:90-93,:402-429`) — a refused transformation is an object, not an absence |
| `de-fornace` | the no-op refusal (`:395`), adopted as §4.4 rule 4 |
| `de-temperie` | a rejected candidate retained **by value and by digest** (`:103-105`) |
| `de-temperie` | **verdicts derived from records, refused when merely asserted** (`:561-570`) |
| `de-temperie` | *"a receipt is not executable capability"* (`:290-294`), proved by deliberately deleting a registry entry so a receipt outlives its own replay capability (`:979-987`) |

**Two precedents that must NOT be cited**, both because reading them changes the
verdict:

- **`de-fornace`'s procedure identity is decorative.** `charge-procedure` /
  `charge-version` enter the digest (`:222-223`) but **no registry resolves them
  and no version-drift condition exists.** Cite `de-torno` or `de-temperie` for
  versioned procedures; never `de-fornace`.
- **`de-fornace:198` carries a docketed defect** — an
  `(ignore-errors (node-at-path tree (butlast path)))` in which a failed traversal
  is indistinguishable from a legitimate negative
  (`ERROR-NIL-LINT-DOCKET.md:222`, rated *materially broader* than its siblings).
  **Anyone lifting that shape inherits the bug.** Form /2 adds no broad handler
  (EG-6).

> The honest summary: **every property Form /2 needs already exists in this tree
> — but never in a layer that can be imported, and never in the layer that
> actually transforms anything.** `de-fornace`'s invariant set (base staleness ·
> jurisdiction · exact `before` · no-op · cross-proposal agreement · strict
> overlap) is the most complete statement of this problem anywhere in the
> repository, and it is sitting in a file that disclaims itself.

---

## 3. ARCHITECTURE COMPARISON

### 3.1 The three candidates

**A — CANONICAL-DATUM TRANSFORMATION.** Form /2 operates on inert CD/0 form data
*before* any Form /0 or Form /1 proposal. Input and output are canonical data.
The output re-enters the appropriate proposal pipeline as a new candidate.

**B — PROPOSED-FORM TRANSFORMATION.** Form /2 accepts a public Form /0 or Form /1
*proposed object* and produces a successor datum or successor proposal.

**C — MACROEXPANSION RECEIPT.** Form /2 begins by making Surface /0
macroexpansion inspectable.

### 3.2 B — rejected, and **not for the reason that killed Form /1's architecture A**

Form /1 rejected its own "A" because Form /0's internals were unexported and a
delegating wrapper was *partially unbuildable through the public surface*. **That
reason does not apply here, and it would be dishonest to reuse it.**
`proposed-form-datum` and `proposed-petition-form-datum` are both exported (§2.3),
so B is fully buildable.

**⚠ AMENDED. The first version of this section said B is "one public reader call
and zero capability" and that it "acquires phase standing it must then throw
away." Both sentences were wrong, and the second was wrong in a way this layer
should have caught: it asserted that taking a proposed object as an argument
*transfers* standing. It does not. Taking a proposed object as an argument is
reading it.**

**What B would actually buy — and A genuinely cannot.** A takes a bare datum, so
A **cannot recover**:

```
the exact proposed-form identity the input carried
the grammar identity and version under which it was admitted
the FACT that this datum ever crossed a proposal boundary at all
```

Those are real provenance facts. A bare CD/0 datum has no memory of having been
proposed, and no amount of care inside A can reconstruct one. **A design that
wanted a transformation receipt to record *"the input was, at the time, an
admitted Form /1 proposal under grammar v1"* would need B, and could not fake it
from A.**

**Why B is nevertheless deferred, and the honest reason is ordering, not
poverty.** Candidate /0 is the **primitive, grammar-independent layer**: it must
work on any CD/0 datum, including data that never was and never will be a
program. A layer that took proposed objects would be *specific to the two form
grammars that exist today* and would have to grow a case per grammar.

```
CLASSIFICATION OF B

  a possible higher-level PROVENANCE-BEARING CLIENT of Form /2 —
  one that reads the proposal facts A cannot see, transforms via the
  primitive layer, and records those facts alongside the structural receipt

  DEFERRED, because Candidate /0 is the primitive grammar-independent layer
  it would be a client of.

  NOT rejected. NOT valueless. NOT implemented here.
```

**Three sentences that must not be written about B**, each because it was written
once and is false: *B inherently transfers standing* · *B buys nothing* · *B is
merely A with an extra call*.

**B-iii, which survives amendment and bounds B for whoever builds it.** B could
only ever act at the PROPOSED phase, because the VALIDATED datum is unreadable in
both forms (§2.3). A provenance-bearing client therefore records *admitted under
a grammar*, never *validated* — and must say so in its own receipt.

### 3.3 C — rejected as premature, and correctly identified as a later client

C is not wrong; it is **out of order**. Three findings:

1. **C is not more primitive than A — it is a client of A.** A macroexpansion
   receipt needs everything a transformation receipt needs (exact input, exact
   output, procedure identity, disposition) *plus* macro identity, expansion
   environment, and hygiene facts (§11). Building the compound first and
   factoring later is how a layer acquires an unremovable special case.
2. **C touches an independently audited boundary.** Making expansion inspectable
   means changing where expansion happens or what it returns. Form /0's stranger
   audit binds one exact subject tree; **any executable change to Form /0 spends
   that audit** (Form /1's EG-1). C would spend an audit to get a receipt.
3. **C invites the one claim this layer must never make.** Macroexpansion is the
   place where a reader's intuition *most* strongly asserts "the meaning is the
   same." A receipt shaped by that intuition is a semantic-preservation claim
   wearing a structural coat.

### 3.4 SELECTED — **A**, on the evidence, not the preference

The direction records Architecture A as the owner's rebuttable preference. **It
survives rebuttal, and the reasons that carry it are B-i and B-ii above** — which
are stronger than the reason offered in the direction, and were reached by
reading the two package files rather than by agreeing.

```
SELECTED ARCHITECTURE:  A — CANONICAL-DATUM TRANSFORMATION
```

Form /2 is a **datum-to-datum** layer. It sits *below* Form /0 and Form /1 and
knows nothing about either. It never sees a phase object, never mints one, and
never consults a grammar. Its output is a datum like any other datum: it earns
proposal, or it is refused proposal, on its own.

> The clean statement of the boundary: **Form /2 does not rewrite programs. It
> rewrites data that a later layer may or may not accept as a program.**

---

## 4. THE CD/0 TRANSFORMATION GRAMMAR

### 4.1 The path — invented here, because CD/0 has none (§2.1)

```
path ::= <sequence datum of zero or more steps>

step ::= [ id(ns=["lisp-plus-form2"], path=["step","index"]) , <integer datum ≥ 0> ]
       | [ id(ns=["lisp-plus-form2"], path=["step","key"])   , <IDENTIFIER datum>  ]
```

**A record step carries an IDENTIFIER datum, not an arbitrary datum, and not an
integer index.** Two verified reasons:

- **`make-record-entry` refuses any non-identifier key**
  (`canonical-datum/common-lisp/cd0.lisp:732-736` — *"record key must be an
  identifier datum"*). A key step of any other family is unsatisfiable by
  construction.
- **A record may NOT be addressed positionally.** CD/0 derives canonical field
  order from the encoded key bytes (`cd0.lisp:~919-923`), so a record's integer
  position is **not stable under key edits**: the same index can name a different
  field after an unrelated change. An index into a record would be an address
  that silently re-points. Sequences are positional; records are keyed; the path
  must say which, and must not be able to say the wrong one.

**Steps are TAGGED, and the tag is not decoration** — though not for the reason I
first wrote. *(An earlier draft of this section justified tagging by saying a
record key might itself be an integer datum, so an untagged step would be
ambiguous. **That is false**: `cd0.lisp:732` forbids it. The rationale below is
the one that survives reading the source.)*

Without tags, a step's meaning would have to be inferred from the family of the
node it lands on — so **the same path would mean different things applied to
different data, and a path could not be checked for well-formedness without a
datum in hand.** Tagged steps make the path independently well-formed, and make a
kind mismatch a *refusal* rather than a silent reinterpretation.

`index` steps descend sequences via `sequence-datum-ref`; `key` steps descend
records via `record-datum-ref`, which binary-searches the cached key bytes and
returns `(values value found-p)`. **A step whose kind does not match the node's
family refuses — it never falls back.**

**The empty path denotes the root** and is legal: the whole datum is replaced.
This is not carved out as an exception, because an arbitrary exception is a
second rule; it is simply the deepest case of the same rule, and §9 sizes it.

### 4.2 The transformation proposal

```
transformation-proposal ::=
  [ id(ns=["lisp-plus-form2"], path=["replace","at-path"]) , <proposal-record> ]

proposal-record fields — EXACTLY FIVE, all REQUIRED, no defaults:
  input           the exact input datum
  path            a path (§4.1)
  expected-old    the exact subtree the caller asserts is currently at path
  replacement     the exact subtree to put there
  occurrence-tag  host-supplied, no default, enters identity
```

The procedure identity and version are **package-owned**, never caller-supplied,
and therefore are not fields of the proposal.

**The head carries the operation** — inherited from Form /1 §4.1. There is no
`operation` field, no handler table, no `:UNKNOWN-TRANSFORMATION-OPERATION` code.
A second edit operation would be a second production head, refused at that
boundary with one honest code. **Candidate /0 designs exactly one operation and
does not invent a second to demonstrate genericity.**

### 4.3 What is forbidden at the boundary, absolutely

**No caller-supplied procedure of any kind reaches the public API.** No callback,
predicate, Lisp function, macro function, visitor, transformer, or handler. No
textual source processing. No reader. No `EVAL`. No `COMPILE`. No arbitrary
`FUNCALL`.

The public surface exposes **data only**. A caller describes a replacement; it
cannot describe a computation. This is enforced structurally: every field of the
proposal is typechecked as a CD/0 datum, and a CD/0 datum cannot be a function.

### 4.4 Application preconditions, in order

**⚠ AMENDED — the checks are split across the two doors (§5), and the no-op test
moved to the observed-event boundary.**

**DOOR 1 — PROPOSE.** Grammar only. Nothing here inspects the input's interior.

```
P1  input is a CD/0 datum
P2  replacement is a CD/0 datum
P3  the proposal node is the exact Candidate /0 production (§4.2)
P4  path is well-formed (§4.1) and within the depth ceiling
P5  a proposal occurrence tag is present            (no default)
P6  input canonical octets within the input ceiling
P7  the proposal identity fits the envelope
```

**DOOR 2 — APPLY.** The encounter with the actual datum.

```
A1  the argument IS a proposal object minted by Door 1
A2  every step resolves — the path EXISTS in input
A3  obtain OBSERVED-OLD at that path
A4  OBSERVED-OLD equal-datum EXPECTED-OLD            (precondition)
A5  REPLACEMENT not equal-datum OBSERVED-OLD         (no-op, §10)
A6  stage the successor; its octets within the output ceiling
A7  stage the identities; all within envelope and reserve
A8  the derived projections verify (§6.2c)
```

### Why A4 precedes A5, and why that ordering is the whole point

**⚠ AMENDED. The first version refused a no-op at PROPOSE time, on
`replacement equal-datum expected-old`, before looking at the input at all.**
That is wrong, and the way it is wrong matters:

> A **stale** proposal whose declared `expected-old` happens to equal its
> `replacement` is **first a precondition mismatch, not an established no-op.**

Refusing it as a no-op would tell the caller *"nothing would change"* when the
truth is *"your description does not match the world, and what would have changed
is unknown."* The layer would be reporting a fact about a datum it never looked
at. **Check the world, then check the triviality** — and the no-op code is named
for what was actually observed: `:replacement-equals-observed-old`.

The reason a no-op refuses at all is unchanged and still Form /2-specific: it
would mint a receipt whose disposition reads *replaced* while nothing was
replaced — **one record for zero events**, the inverse of the *"two events, one
record"* defect Form /1 rejected in its architecture C. **No receipt is minted in
either case** (mismatch or no-op).

---

## 5. OBJECT AND TRANSITION FAMILY

```
FORM-TRANSFORMATION-PROPOSAL      inert, immutable, snapshotted; mints NO occurrence
FORM-TRANSFORMATION-RECEIPT       the account of one APPLIED replacement
FORM-TRANSFORMATION-REFUSAL       retained, inspectable, never only printed
```

**⚠ AMENDED. The first version named a proposal object and separated `propose`
from `apply` in its refusal phases — and then provided no proposal transition.
A phase named in a catalogue and absent from the API is a phase that does not
exist.** Candidate /0 has **two explicit doors.**

### Door 1 — PROPOSE

```
TRY-PROPOSE-REPLACEMENT   →  (values PROPOSAL nil)
                          |  (values nil REFUSAL)
PROPOSE-REPLACEMENT       →  PROPOSAL  |  signals FORM-TRANSFORMATION-REFUSED
```

Door 1 **accepts the raw CD/0 proposal datum**, validates the exact Candidate /0
grammar (§4), **snapshots every retained datum** (`decode-exact ∘
canonical-octets`, so the stored tree shares no structure with anything the
caller keeps), mints an **immutable proposal object and a proposal identity**,
and **performs no structural replacement whatsoever.** It does not read the input
datum's interior, does not resolve the path, and does not compare anything to
`expected-old`.

### Door 2 — APPLY

```
TRY-APPLY-REPLACEMENT     →  (values SUCCESSOR RECEIPT nil)
                          |  (values nil nil REFUSAL)
APPLY-REPLACEMENT         →  (values SUCCESSOR RECEIPT)
                          |  signals FORM-TRANSFORMATION-REFUSED
```

Door 2 **accepts the exact proposal object** — never a raw datum, never a
re-parsed proposal — resolves the path, obtains `observed-old`, checks the exact
precondition, checks the no-op at the observed boundary (§10), stages the
successor and every candidate identity, checks all resource and identity limits,
and **returns the successor and receipt only after every gate holds** (§8a).

**A refused application returns `(values nil nil refusal)`.** Three values on
both branches, so a caller destructuring the result cannot silently read a
refusal as a successor.

> **No generic multiple-value wrapper may discard the receipt.** A convenience
> that returns only the successor makes the receipt optional, and a receipt a
> caller can decline to take is a receipt the layer does not really produce.

Two entry points per door, one signalling and one not — the Form /1 `try-`
pattern. The non-signalling one is authoritative; **no boolean predicate that
could disagree with it is exported** (Form /1 §3.3's resolution of its own
NC-24).

### Why the split is load-bearing here specifically

Door 1 can be satisfied by a proposal that will never apply — the path may not
exist, the expected value may be stale. **That is the point.** The proposal is a
*description a caller wrote*; the application is *an encounter with an actual
datum*. Collapsing them would make "your description is malformed" and "your
description does not match the world" the same refusal, which is exactly the
representation collapse §10 refuses one code at a time.

**Explicitly NOT created**, per the direction and because each is an inheritance
vector:

```
VALIDATED-TRANSFORMED-FORM          no
AUTHORIZED-TRANSFORMATION           no
SEMANTICS-PRESERVING-TRANSFORMATION no
a successor carrying its predecessor's validation receipt   no
any mutable transformation status   no
```

The successor is **a bare CD/0 datum**. It is not wrapped. It has no Form /2 type
at all. That is the whole point: *a rewritten form is just data again.*

---

## 6. THE RECEIPT MODEL — content vs identity, and why they differ

### 6.1 What the receipt CARRIES (readable fields — all of the direction's §6 list)

```
transformation occurrence identity
input datum identity
output datum identity
canonical path
expected old subtree
observed old subtree
replacement subtree
package-owned procedure identity and version
disposition
resource-policy identity and version
```

### 6.2 What the receipt IDENTITY COMMITS TO — a deliberately smaller set

**This distinction is not a weakening. It is the fix for a measured failure (§9).**
The receipt still *carries* every field above; the question is only which are
folded into the receipt's own identity **value**.

### 6.2a THREE identities, because a tag is not an occurrence

**⚠ AMENDED. The first version folded a host-supplied occurrence tag directly
into something it called the *transformation occurrence identity* — computable
from an inert proposal, before any transformation had occurred. A host writing a
tag does not make a transformation happen.** Candidate /0 uses three:

```
REPLACEMENT-PROPOSAL-IDENTITY
  identity([ :proposal
             input-datum-identity
             path
             expected-old
             replacement
             procedure-identity · procedure-version
             proposal-occurrence-tag        (host-supplied, no default)
             policy-identity · policy-version ])

  Minted by DOOR 1. Exists for proposals that will never apply.

TRANSFORMATION-OCCURRENCE-IDENTITY
  identity([ :occurrence
             replacement-proposal-identity
             structural-disposition ])

  Minted ONLY on successful application. There is NO occurrence identity
  for a refused application — not a null one, not an absent-marked one.
  The object does not come into existence.

TRANSFORMATION-RECEIPT-IDENTITY
  identity([ :receipt
             transformation-occurrence-identity
             receipt-policy-identity · receipt-policy-version ])
```

*(Exact symbol names remain candidate and may be sharpened in implementation.)*

**Two identical proposals carrying distinct supplied tags have distinct proposal
identities. The package does not guarantee tag uniqueness** — identical tags give
identical proposal identities, an undetected host error (§7.3).

### 6.2b The reduction — kept, and re-stated as a NARROW THEOREM

**⚠ AMENDED. The first version wrote "discrimination is preserved" flatly. That
is a claim about all worlds; what is true is a claim about lawful ones, under
assumptions that must be named.** The reduction stands; the sentence does not.

> **THEOREM (narrow).** Over **successful transitions produced by the fixed
> package procedure under the stated preconditions**, exact CD/0 encoding makes
> `OBSERVED-OLD` and `OUTPUT-DATUM-IDENTITY` **derivable** from the committed
> proposal payload. Omitting them from the identity therefore **loses no
> discrimination among such transitions.**
>
> *(Earlier wording said "lawful successful transitions." Too broad: it reads as
> a claim about every transition the world might call lawful, when the guarantee
> holds only for transitions THIS procedure produced, at THIS version, with the
> preconditions actually checked.)*

**What this does NOT establish** — write these beside the theorem wherever it is
cited, never after it:

```
resilience to a MISVERSIONED procedure
nondeterministic implementation behaviour
internal object corruption
forged package-internal receipts
persistence-time integrity
```

### 6.2c The two omitted fields are DERIVED PROJECTIONS, and are verified as such

Because they are derivable, they are **not trusted stored values** — they are
projections the receipt constructor must **recompute and check**. At receipt
construction, before any receipt exists:

```
REQUIRE   observed-old  equal-datum  expected-old
REQUIRE   output-datum-identity  equal-datum
            identity( replace(input, path, replacement) )
```

**No public receipt constructor exists**, so these are the only path by which a
receipt can come into being.

Planted internal faults must prove all three teeth bite (§14):

- a wrong stored `observed-old` **cannot produce a receipt**;
- a wrong stored output identity **cannot produce a receipt**;
- a misversioned or altered procedure fixture **is detected by the suite**.

> **If implementation cannot enforce this without folding the output identity
> back into the receipt identity, STOP and report the exact contradiction.** Do
> not quietly re-add the term and keep the measured margin.

### 6.3 What the receipt may and may not say

May state: **structural replacement occurred.**

Must not state or imply: meaning preserved · behaviour preserved · evidentiary
standing preserved · authority preserved · validation preserved · the output is a
lawful Form /0 or Form /1 program.

**Field names are the cheapest ceiling there is** (Form /1 §9.4). The disposition
value is **`:REPLACED-AT-PATH`** — sharpened from `:STRUCTURALLY-REPLACED`,
because it names the *operation that ran* rather than offering an adverb about
its character. A hurried reader who sees only the disposition should read a claim
about *what happened at one address* and nothing else.

**FORBIDDEN in any Form /2 disposition, receipt field, or fixture title:**

```
repair · repaired · preserved · preserving · equivalent · equivalence
normalized · normalization · corrected · correct · improved · valid
```

Each of them asserts something about *meaning* or *quality*. **The layer may say
where and what. It may never say better, same, or right.**

### 6.4 DECLARED INTENT — **OMIT IT ENTIRELY FROM CANDIDATE /0**

The direction asks whether Candidate /0 should carry a caller-declared intent
such as `:alpha-renaming`, `:repair-reference` or `:normalization`, and whether
omitting it avoids a decorative claim surface.

**Determination: OMIT. Do not design the field.** Three reasons, the third
decisive:

1. **It buys nothing measurable.** Nothing in Candidate /0 reads it, gates on it,
   or checks it. A field no code consults is documentation stored in a receipt.
2. **A field in a receipt is read as a finding.** Receipts in this lane are
   evidence objects. `intent: :alpha-renaming` sitting beside a verified path and
   verified identities will be read as *"this was an alpha-renaming"* — the exact
   upgrade from testimony to verified class the direction forbids.
3. **This lab has already paid for this shape once, this week.** NC-31B is
   precisely *a host-supplied declaration that enters identity and certifies
   nothing about what it names* — and it is the residual that survived Form /1's
   Review 1, its repair, and an independent stranger audit, and that **must never
   be called repaired.** Designing a second declaration-without-certification, in
   the very next layer, one week later, with the scar still open, would be
   building the known defect on purpose.

> If a later candidate wants intent, it can add a field. **Nothing is ever
> cheaper to add later than it is to remove once a receipt shape is in the
> world.**

---

## 7. THE IDENTITY MODEL

### 7.1 Identity values — inherited verbatim from Form /1 §9.0

An identity is an **immutable CD/0 byte-string datum**, built as
`(make-bytes-datum (canonical-octets payload))`. Equality is `equal-datum`.
**This is a LOSSLESS ENCODING, never a digest.** Hexadecimal is diagnostic
rendering only (`RENDER-IDENTITY-HEX`) and is never embedded into a later
identity. **Inventing a hash protocol is forbidden in this session and in
Candidate /0.**

**⚠ The two predecessor layers DISAGREE on this, and picking the wrong one silently
doubles every link.** Read at the source:

```
Form /0   form0.lisp:71   %hex      = octets-to-hex(canonical-octets(d))   → HEX TEXT
Form /1   form1.lisp:189  %identity = make-bytes-datum(canonical-octets(d)) → OCTETS
```

Form /1's own comment states the stakes (`form1.lisp:195-197`): *"Because each
link embeds its predecessor's OCTETS rather than a hex TEXT of them, composition
costs one constant header per link instead of doubling — which is the whole
repair."*

**Form /2 adopts the Form /1 representation, and the §9 measurements were taken
under it.** Adopting Form /0's hex convention would double each link and put the
§9.3 figure of 49,215 octets far above the envelope. **An implementation that
reaches for `octets-to-hex` while composing an identity has silently changed the
resource analysis and must stop.**

### 7.2 The chain, and what is never collapsed

```
input datum identity        identity(input)
output datum identity       identity(output)          DERIVED PROJECTION (§6.2c)
replacement proposal id     §6.2a   — exists even for proposals that never apply
transformation occurrence   §6.2a   — exists ONLY after a successful application
transformation receipt      §6.2a
refusal identity            identity([:refusal, proposal-occurrence-tag, phase,
                                      category, code, path,
                                      procedure-id, procedure-ver])
```

`input datum` ≠ `output datum` ≠ `proposal` ≠ `occurrence` ≠ `receipt` ≠
`refusal`. **The output datum identity is not the receipt identity**, and no
rendering may make them look alike (NC-20).

**The load-bearing asymmetry:** a proposal identity says *someone described a
transformation.* An occurrence identity says *a transformation happened.* Only
the second is minted by an encounter with a real datum, and **a refused
application mints none.**

### 7.3 Two occurrences, one content — the direction's §7 question, answered

> *If the same transformation content is applied under two distinct occurrence
> identities, should the receipts remain distinct while their input and output
> identities agree?*

**Yes. Receipts distinct; datum identities equal.** The occurrence tag enters the
occurrence identity, which enters the receipt identity, so two tags give two
receipts. The input and output identities are content-derived and *must* agree —
the same replacement applied twice does produce the same bytes, and a design that
made them differ would be lying about content.

**The honesty clause, carried forward from Form /1 §9.2 and required in the
implementation's own documentation:**

> Form /2 **does not and cannot guarantee** that two supplied occurrence tags
> differ. It guarantees only that the supplied tag is bound into the identity, so
> **different tags ⇒ different identities.** Identical tags ⇒ identical
> identities, an **undetected host error.** No global exactly-once claim is made.

### 7.4 Reader discipline

Public aggregate readers must not expose mutable internal structure. Path steps,
subtrees and receipts are returned as immutable CD/0 data or defensive copies.
CD/0's copy-on-access is relied on where it applies and **named** where it is
relied on, never assumed silently.

---

## 8. HISTORY AND DEPTH — the chain is FLAT, and that is a finding, not a hope

The direction requires a determination, with `BLOCKED — UNBOUNDED TRANSFORMATION
IDENTITY HISTORY` as a live outcome.

**Determination: the identity chain is STATICALLY BOUNDED. NOT BLOCKED.**

The reason is structural and checkable:

> **A receipt commits to DATUM identities, never to a predecessor RECEIPT
> identity.**

Consider `F0 --R1--> F1 --R2--> F2`. `R2`'s input identity is `identity(F1)`.
`F1` is a datum, not a receipt, so `identity(F1)` contains no trace of `R1`.
**Nothing recurses.** Receipt size is a function of datum size alone, and datum
size is capped by the resource policy (§9). Chain length is therefore free.

### 8.1 What a receipt IS — an edge, and only an edge

**⚠ AMENDED. The first version said the "full genealogy is externally
reconstructible." That claims far more than a set of edges supports, and it is
the sentence in the original work order that most resembled the thing this layer
exists to refuse — a structural fact quietly promoted into a historical one.**

The exact claim:

> **Each receipt is an independently inspectable DIRECTED EDGE from one datum
> identity to another.**
>
> Given a **complete, externally ordered** sequence, a host may verify
> **adjacency** by matching each output identity to the next input identity.

Both qualifiers are load-bearing. The host supplies completeness. The host
supplies order. Form /2 supplies neither and cannot check either.

### 8.2 What Form /2 does NOT establish — carry this list with the edge

```
completeness of the receipt set          — an omitted edge is undetectable
temporal order                            — receipts carry no clock
unique lineage                            — many edges may share an endpoint
omission detection
fork ancestry
authenticity against receipt FABRICATION  — nothing prevents minting a
                                            plausible edge between any two data
an exterior root
durable replay history
```

**On fabrication specifically, since it is the sharpest of these.** An adversary
holding the receipt set and free to construct can mint an edge joining any two
data it likes. Form /2's answer is not a defence but a disclaimer: **a receipt is
an ACCOUNT, not an AUTHENTICATION**, and the layer never claimed otherwise. A
reader who needs authenticity needs an **external anchor or governing journal
machinery** — which is precisely the exterior root a self-contained artifact
provably cannot supply itself. **Candidate /0 does not build it, and a future
persistence or authenticated-history layer would have to.**

Candidate /0 therefore builds **no** global transformation history, replay
engine, branching patch graph, or version-control system — and **the join being
available is a convenience for a host that already trusts its own records, not a
property of the layer.**

---

## 8a. STAGING — the law is OBSERVABILITY, not pre-allocation prediction

**⚠ AMENDED. The first version's §4.4 rules read as though every size had to be
predicted before anything was built.** That would force Form /2 to hand-write a
second implementation of CD/0's nested encoding arithmetic — a duplicate size
model that could disagree with the encoder, which is a representation collapse
with extra steps.

Form /2 performs a **pure immutable rebuild**, not an external governed act.
There is nothing to un-do: an unreturned candidate datum is garbage, not a
side effect. So the governing law is about **what the caller can see**:

> **No successor datum and no receipt becomes OBSERVABLE TO THE CALLER until
> every path, precondition, resource, identity and consistency check has
> passed.**

Candidate /0 **is permitted** to construct a candidate successor and candidate
identities in **local staging** and then decide whether to return them.

Two prohibitions keep this honest:

- **Do not require a second hand-written predictor** of exact nested CD/0 output
  size before any candidate object is allocated. Build it, measure it, then
  decide.
- **Do not describe temporary immutable allocation as a completed
  transformation.** A staged successor that is never returned **did not happen**,
  and no artifact may say it did.

If any gate fails: **return no successor, return no receipt, retain an exact
refusal, leave the input untouched.**

*The distinction from Form /1 is real and worth stating: Form /1's "every
resource refusal before invocation" rule exists because `DERIVE/2` is a
**governed act with external consequence** that cannot be taken back. Form /2 has
no such act. Copying Form /1's rule verbatim would have been cargo discipline.*

---

## 9. RESOURCE POLICY — **measured before design, not discovered during it**

### 9.1 Why this section exists at all

Form /1's EG-4 (*two ceilings that cannot both hold, and the one that fails can
only fail after the governed act*) was found **during implementation** and
**blocked the candidate** at commit `e5ffe68c`. A Form /2 receipt commits to more
full-size subtrees than any Form /1 identity does, so the same defect class is
foreseeable **and was therefore measured before this document proposed a
ceiling.**

*Measurement method, stated so it can be challenged: a scratchpad probe loaded
the existing unmodified Form /1 stack (which transitively loads CD/0) and used
CD/0 primitives only. No Form /2 source exists. Nothing was written to the
repository. SBCL 2.4.6, operation-checked through the wrapper.*

### 9.2 The law the measurement exhibits

Because identities are **lossless**, each nesting level multiplies size by the
number of full-size terms it commits.

```
occurrence commits input-id, expected-old, replacement    →  3 × |D|
receipt (naive) commits occurrence, input-id, output-id,
        expected-old, observed-old, replacement           →  8 × |D|
receipt (§6.2)  commits occurrence + small terms          →  3 × |D|
```

### 9.3 The measured numbers

Adversarial case — replacement at a root child, so expected-old and replacement
are each essentially the whole datum:

```
admitted input datum                     16,383 octets
naive receipt identity (commit all)     131,004 octets   = 8.00 × datum
                                                          *** 2.0× OVER the
                                                          65,536 envelope ***
§6.2 receipt identity                    49,215 octets   = 3.00 × datum
                                                          fits: 1.33× vs envelope
                                                          1.25× vs envelope−reserve
```

**The naive receipt shape is an EG-4-shaped failure, reachable with the largest
legally admitted input.** It is not exotic and not adversarially contrived beyond
what a host may lawfully submit.

### 9.4 A scar recorded against myself, because it is the same one the stranger just found

My **first** probe used a mid-sized fixture and reported the naive shape at
**3.64× — "fits, 1.10× margin."** That was a **fixture maximum, not a global
maximum**, and it would have licensed exactly the wrong ceiling. The true figure
(8.00×, failing) appeared only when I attacked the root.

This is, precisely, the finding the Form /1 stranger auditor returned four hours
earlier: *the preparer's "worst-case fixture" was not globally maximal.* **The
lesson did not transfer by having been written down; it transferred by being
applied.** Any implementation of this work order must drive its ceiling probes to
the *largest admitted input at the shallowest path*, and must not accept a
mid-sized fixture as a maximum.

### 9.4a FOUR MORE LIMITATIONS OF THOSE PROBES — the scar was not the whole scar

**⚠ AMENDMENT. Both original probes are PRESERVED UNCHANGED as
before-amendment historical evidence.** Their limitations, newly identified and
recorded rather than patched:

```
A  the "worst-case" probe used EQUAL old and new values — so it measured a
   NO-OP, which Candidate /0 now refuses at A5. It sized an event that cannot
   happen.
B  it encoded the path as a BARE INTEGER, not the tagged Form /2 path
   grammar (§4.1). Tagged steps are larger; the measured path term is too small.
C  it measured a ROOT CHILD, not the legal EMPTY ROOT PATH.
D  the advertised `slack` term has NO EXPLICIT BOUND for occurrence-tag or
   encoded-path size. An unbounded tag makes the relation in §9.5 unfalsifiable.
```

**Item A is the sharpest, and it is the same defect one rung further in:** the
first probe was too small, and the corrected probe measured *the wrong event*.
Driving harder fixed the magnitude and not the legality. **A maximum over
inadmissible inputs is not a maximum.**

### 9.4b THE EXACT CANDIDATE /0 MEASUREMENT — required before the ceilings stand

A new measurement must be taken **using the actual Candidate /0 machinery**, not
a hand-built analogue: the real proposal production, the real tagged path
grammar, and **different but equal-size** expected and replacement data (so the
event is lawful under A5).

Fixtures to drive, none of which may be called a global maximum
(§9.4c):

```
maximum lawful input · maximum lawful output
EMPTY-PATH root replacement · root-child comparison
maximum path depth (32) · long lawful key identifiers
varying proposal occurrence-tag sizes
replacement LARGER than the removed subtree
deep record spines · wide record spines
```

Report **separately**, never as one rolled-up number:

```
datum terms · path octets · occurrence-tag octets
proposal identity octets · transformation occurrence identity octets
receipt identity octets · rebuild counts · total record-key work
```

### 9.4c THE RULE THAT REPLACES "WORST CASE"

> **Do not call any one fixture a global maximum unless the admissible domain has
> actually been BOUNDED and SEARCHED.**

Absent a bounded search, the honest report is *"the largest value MEASURED, over
the following enumerated fixtures"* — a sentence that cannot be over-read. This
lane has now produced the error twice in one day, once as a preparer and once as
an auditor's finding against a preparer.

### 9.5 The proposed ceilings

```
maximum input datum canonical octets      16,384   (matches Form /1's petition ceiling)
maximum output datum canonical octets     16,384   (checked BEFORE the output is built)
maximum path depth                            32
maximum identity octets (envelope)        65,536   (matches Form /1)
identity tail reserve octets               4,096   (reserved BEFORE any identity is built)
```

**These are Candidate /0 experimental ceilings, not universal Lisp+ limits.**

**The binding relation, which the implementation must re-derive rather than
copy:**

```
3 × max_datum_octets  +  slack  ≤  envelope − reserve
3 × 16,384 = 49,152   ≤  61,440        MEASURED 49,215 ≤ 61,440    ✅ 1.25×
```

**If a future candidate raises the datum ceiling, it must re-measure.** The
factor 3 is a property of the committed-term count in §6.2, not a constant of
nature; adding one full-size term to the identity moves it to 4 and the relation
must be re-checked, not assumed.

**⚠ AMENDED — `slack` is no longer an unbounded word.** Limitation D of §9.4a
made the relation unfalsifiable, because an unbounded occurrence tag or encoded
path could consume any margin. Candidate /0 therefore adds **explicit bounds on
the two non-datum terms**, so `slack` is a number and not a hope:

```
maximum proposal occurrence-tag canonical octets     1024
maximum encoded path canonical octets                4096   (with depth ≤ 32)
```

Both are enforced at **Door 1**, before any identity is minted, with their own
codes (§10). The revised relation the implementation must **re-derive against the
amended three-identity chain** (§6.2a) rather than copy:

```
3 × max_datum_octets  +  path_octets  +  tag_octets  +  header slack
      ≤  envelope − reserve
```

> **If the exact terminal identity exceeds the envelope, or violates the
> envelope-minus-reserve relation, STOP and report:**
> **`BLOCKED — FORM /2 IDENTITY ENVELOPE CONTRADICTION`.**
> **Do not add a hash.** Do not raise the envelope to fit the measurement.

*The ceilings below are retained **provisionally**, pending the §9.4b
measurement. They are not confirmed by the original probes, whose four
limitations are recorded above.*

---

## 10. REFUSAL CATALOGUE

Following Form /1 §11: **one code per distinct condition**, and Form /0's
overloaded `:UNKNOWN-PRODUCTION` is explicitly not inherited.

**⚠ AMENDED — two codes REMOVED as structurally unreachable, three ADDED, and
the class split populated on both sides.**

### 10.1 PROTOCOL REFUSALS — publicly reachable, every one with a fixture

| phase | category | code |
|---|---|---|
| propose | `:boundary` | `:proposal-not-a-datum` |
| propose | `:grammar` | `:proposal-node-not-a-sequence` |
| propose | `:grammar` | `:proposal-node-arity` |
| propose | `:grammar` | `:head-not-identifier` |
| propose | `:grammar` | `:not-a-replacement-proposal` |
| propose | `:grammar` | `:proposal-body-not-a-record` |
| propose | `:grammar` | `:proposal-field-missing` |
| propose | `:grammar` | `:proposal-field-unknown` |
| propose | `:grammar` | `:path-not-a-sequence` |
| propose | `:grammar` | `:path-step-not-a-sequence` |
| propose | `:grammar` | `:path-step-arity` |
| propose | `:grammar` | `:path-step-kind-unknown` |
| propose | `:grammar` | `:path-index-not-a-nonnegative-integer` |
| propose | `:grammar` | `:path-step-key-not-an-identifier` |
| propose | `:policy` | `:path-depth-exceeded` |
| propose | `:policy` | `:path-octets-exceeded` |
| propose | `:policy` | `:occurrence-tag-octets-exceeded` |
| propose | `:policy` | `:input-octets-exceeded` |
| propose | `:policy` | `:identity-octets-exceeded` |
| apply | `:species` | `:not-a-replacement-proposal-object` |
| apply | `:path` | `:path-step-family-mismatch` |
| apply | `:path` | `:path-index-out-of-range` |
| apply | `:path` | `:path-key-absent` |
| apply | `:precondition` | `:expected-old-mismatch` |
| apply | `:precondition` | `:replacement-equals-observed-old` |
| apply | `:policy` | `:output-octets-exceeded` |
| apply | `:policy` | `:identity-octets-exceeded` |
| apply | `:resource` | `:rebuild-record-key-work-exceeded` |

**REMOVED as structurally unreachable:** ~~`:input-not-a-datum`~~ and
~~`:replacement-not-a-datum`~~. Both `input` and `replacement` are **fields inside
a CD/0 record**, and every value inside a CD/0 record is necessarily CD/0 data
(`make-record-entry` calls `%ensure-datum`). A caller cannot put a non-datum
there. **Only the outermost argument can fail to be a datum**, which is
`:proposal-not-a-datum`. Two advertised codes with no reachable fixture would
have shipped as false affordances — the exact defect this lane already owns a
documented counterexample for.

**MOVED:** ~~`:occurrence-tag-required`~~ folds into `:proposal-field-missing` —
the tag is a required field of the proposal record, and a missing required field
already has one honest code. A second code for one instance of a general
condition is the overloading this table refuses, inverted.

`:path-step-family-mismatch` and `:path-index-out-of-range` remain separate on
purpose: *"you asked for a record key inside a sequence"* and *"index 9 of a
7-element sequence"* are different host errors.

### 10.2 INTEGRITY ALARMS — package-internal, planted-fault-reachable ONLY

**The class is populated. Candidate /0 genuinely has both classes, so the split
is real and not a promise.** These cannot be provoked through the public API;
they exist because §6.2c makes the receipt constructor verify its own derived
projections, and a verification with no failure path is not a verification.

| phase | category | code |
|---|---|---|
| receipt | `:integrity` | `:observed-old-projection-mismatch` |
| receipt | `:integrity` | `:output-identity-projection-mismatch` |
| receipt | `:integrity` | `:procedure-version-mismatch` |

Each is reachable **only** by a planted internal fault, and each has one (§14).
**A gate that has never fired is untested, not passing.**

### 10.3 The catalogue's shape

`PROTOCOL-REFUSAL-CODES` and `INTEGRITY-ALARM-CODES` are **both derived from one
catalogue** of `(code class reachability note)` entries, whose union is the
complete implementation code set by construction. **There is deliberately no flat
`FORM2-REFUSAL-CODES`**: a single list publishes a count that travels without the
distinction it flattens.

### 10.4 CD/0 REBUILD FAILURES — reclassify for the caller, preserve what CD/0 said

A spine rebuild can drive CD/0 past `max-total-record-key-octets` (§2.1a), and
CD/0 will label that stage **`host-import`** — true of its own constructor, and
misleading to a Form /2 caller who imported nothing.

**Catch only the exact public `CD0-FAILURE` classes expected during rebuild.**
Do not convert every CD/0 failure into an output- or identity-size refusal. For
the upstream record-key work budget, refuse with the precise Form /2 code
`:REBUILD-RECORD-KEY-WORK-EXCEEDED`, and **retain in the refusal**:

```
upstream failure category · upstream failure code
upstream stage AS OBSERVED (i.e. "host-import", preserved, not corrected)
upstream detail · upstream budget identity
Form /2 phase and operation
```

> **The Form /2 code corrects the semantic classification for its caller while
> preserving the fact that CD/0 labelled the constructor stage `host-import`.**
> Both facts are true and neither may erase the other — the reclassification is
> an added reading, not an overwrite.

**Unexpected CD/0 or host conditions ESCAPE.** No broad `(ERROR () …)` handler
(EG-6).

### The three disciplines, carried forward verbatim

**(a) Do not pre-empt a later layer's dispositions.** A structurally lawful
replacement that produces a datum Form /1 will refuse is **not** a Form /2
refusal. It is a Form /2 success followed by a Form /1 refusal, and the two must
remain two events (NC-13).

**(b) Catch only exact documented classes. No `(error () …)` anywhere.** An
unexpected implementation condition **escapes** and does not become a
transformation refusal (NC-18). Nine severe broad handlers stand docketed in
predecessor layers; Form /2 adds none.

**(c) Every advertised code has a reachable fixture, or it does not ship.**
Enforced by a live set-difference in both directions between the declared
catalogue and the codes the suite actually produced (NC-19). The
`DERIVATION-BASIS-REFUSED` false affordance — *exported and never signalled* — is
the documented counterexample this lane already owns.

---

## 11. INHABITED APPLICATION — `de-forma-mutata`

*Concerning the changed form.* Deterministic, no live model call. The principal
inhabitant is a **Form /1 petition datum**, and **Form /1 is not modified.**

### Candidate A — STALE PRECONDITION

Declared expected-old differs from the actual subtree.

```
expect  transformation REFUSES with (:precondition . :expected-old-mismatch)
        input unchanged · NO receipt exists · refusal retains the observed subtree
```

### Candidate B — STRUCTURAL SUCCESS, FORM FAILURE

Replace the petition production head with a structurally lawful CD/0 value that
is not a lawful Form /1 petition head.

```
expect  transformation SUCCEEDS · receipt exists · successor re-enters Form /1
        PROPOSE-PETITION REFUSES  (:grammar . :not-a-derivation-petition)
        the transformation receipt does NOT impersonate proposal admission
```

**This is the layer's thesis in one fixture:** a receipt for a real structural
event, sitting beside a refusal of the thing that event produced, with neither
contaminating the other.

### Candidate C — CONSEQUENCE-CHANGING REFERENCE REWRITE

Replace one support reference with a different reference.

```
expect  transformation SUCCEEDS · receipt records the exact path and both values
        successor VALIDATES as a petition
        submission under a context gives a DIFFERENT governed result
        NO semantic-preservation claim exists anywhere in the artifacts
```

### Candidate D — RESOLVABLE-REFERENCE REWRITE

*(**⚠ RENAMED.** This case was called **"EXACT REPAIR."** `repair` is a semantic
word wearing a structural coat: it asserts that the successor is *better*, i.e.
that the transformation *fixed* something — a meaning claim, in the title of the
fixture whose entire job is to refuse meaning claims. The layer's own §6.3
vocabulary rule forbade it and the first draft broke the rule in a heading. The
honest description is what actually happens: a reference that does not resolve is
replaced by one that does, and a lawful petition follows.)*

Begin with a petition whose support reference is unresolved; replace it with a
reference present in the sealed context.

```
original datum
  → transformation receipt
    → successor datum
      → Form /1 proposal
        → Form /1 validation
          → petition
            → submission receipt
              → Slice /2 receipt
```

**Every arrow points forward. No later standing flows backward into the
transformation receipt.** The application must print the genealogy and must
demonstrate, not merely assert, that the transformation receipt is unchanged by
everything downstream of it.

### House conventions the application must follow — read off the two existing specimens

These are not invented here. They are the shape of
`de-forma-dormiente/APPLICATION.lisp` and `de-forma-petente/APPLICATION.lisp`, and
`de-forma-mutata` follows them:

1. **`APPLICATION.lisp` inside `de-forma-mutata/`**, first line naming the
   specimen in Latin, second line the exact run command.
2. **A thesis, then immediately "what this does NOT establish"** — before any
   result. `de-forma-petente` puts the disclaimer *first* and says why: *"it is
   the part a reader is most likely to supply for himself if nobody says it."*
3. **Own package, `cd0` shorthand macro**, style-warnings muffled at load.
4. **The three reporting primitives verbatim** — `desk`, `section`, `check` —
   with `check` incrementing `*checks*` **by side effect**, so the count is a
   fact of the run and never a literal in the source (NC-21).
5. **The abbreviation is itself under test.** `short` prints the identity length
   beside the truncation, and a live ascending search **re-derives the minimum
   discriminating window every run.** `de-forma-petente` records that its window
   *"has already failed twice, and both windows above are what it bought."*
   Every printed identity registers into a census as a side effect of printing,
   **so nothing printed can escape the final discrimination check** (NC-20).
6. **A `genealogy` struct and a ledger in which every candidate gets a row
   whether it lives or dies**, each retained refusal printed as `REFUSED …` /
   `held` / `not reached`. For Form /2 the row must carry both the transformation
   outcome *and* the downstream Form /1 outcome, **in separate fields that cannot
   be summed.**
7. **The `try-` twin drives the walk** — never a handler at the call site.
8. **A negative control is mandatory.** *"A false answer is a lawful answer. The
   desk distinguishes 'no' from 'I refuse to look'."* Candidate A is that control.
9. **Refusals re-read after the lawful path succeeded**, checking each retained
   refusal still carries a catalogued code, a non-empty detail, and a non-empty
   identity.
10. **Closing sequence, fixed order:** a *what this does not establish* section →
    three em-dashed aphorisms → the counted tally with a structural check that
    every attempt returned **either** an outcome **or** a refusal, never both and
    never neither → `(when (plusp *failed*) (exit :code 1))`.
11. **Exhibit the residual, do not close it.** `de-forma-petente` gives two full
    sections to defects it did not repair, including a scar comment recording its
    own author's false declaration written *"within an hour of writing"* the
    honesty clause it violated. **`de-forma-mutata` must do the same for the
    entitlement residual named in §18.**

---

## 12. NEGATIVE-CONTROL MATRIX

The direction's twenty-two, each with its expected result. **NC-5 and NC-16 are
noted as satisfied by the substrate (§2.1), which is a stronger guarantee than a
test — but they are still tested, because "cannot happen" is exactly the claim
that has twice turned out to be a hollow check in this lane.**

| # | control | expected |
|---|---|---|
| NC-1 | path not present | refuses `:path-index-out-of-range` / `:path-key-absent` |
| NC-2 | expected-old mismatch | refuses `:expected-old-mismatch` |
| NC-3 | caller mutates input after proposal | retained transformation unaltered |
| NC-4 | caller mutates replacement after proposal | retained transformation unaltered |
| NC-5 | input after successful replacement | byte-identical to before *(substrate: no mutator exists)* |
| NC-6 | output vs input | differs **only** at the declared path |
| NC-7 | receipt input identity | equals identity of the exact original datum |
| NC-8 | receipt output identity | equals identity of the exact successor datum |
| NC-9 | receipt replayed against a different input | refuses |
| NC-10 | receipt offered as a **claim** | refuses |
| NC-11 | receipt offered as a **source basis** | refuses |
| NC-12 | receipt offered as a **derivation basis** | refuses |
| NC-13 | structurally successful rewrite → invalid Form /1 datum | both events occur, separately recorded |
| NC-14 | Form /1-valid successor | may yield a **different** Slice /2 result |
| NC-15 | validation of the input | does **not** transfer to the output |
| NC-16 | arbitrary transformer function via public API | impossible *(no such parameter exists)* |
| NC-17 | reader result | aliases no mutable stored data |
| NC-18 | unexpected implementation condition | **escapes**; does not become a refusal |
| NC-19 | every advertised refusal reason | has a reachable fixture (set-difference empty both ways) |
| NC-20 | diagnostic identity abbreviation | discriminates the exercised full identities |
| NC-21 | runner counts | derive from rendered verdicts |
| NC-22 | transformation history | not recursively embedded (§8) |

**Added by this work order, each earning its place:**

| # | control | expected |
|---|---|---|
| NC-23 | empty path (root replacement) | succeeds; output ≡ replacement; sizing gate still holds |
| NC-24 | integer record key vs sequence index at the same position | tagged steps discriminate; no fallback |
| NC-25 | two distinct occurrence tags, identical content | receipts **differ**; input/output identities **agree** (§7.3) |
| NC-26 | identical occurrence tags, identical content | identities collide — **undetected host error, declared not repaired** |
| NC-27 | largest admitted input at the **shallowest** path | receipt identity measured, ≤ envelope − reserve (§9.4's scar) |
| NC-28 | output would exceed the datum ceiling | refuses **before** the output datum is constructed |
| NC-29 | replacement `equal-datum` to expected-old | refuses `:replacement-equals-expected-old` — **no receipt is minted for a non-event** |
| NC-30 | record step carrying a non-identifier datum | refuses `:path-step-key-not-an-identifier` (unsatisfiable by `cd0.lisp:732`) |
| NC-31 | integer step applied to a record | refuses `:path-step-family-mismatch` — records are **never** positionally addressed (§4.1) |
| NC-32 | rebuild drives CD/0 past `max-total-record-key-octets` | surfaces as `:rebuild-record-key-work-exceeded`, **with CD/0's `host-import` stage preserved** (§10.4, EG-8) |
| NC-33 | identity composition path | contains no `octets-to-hex` (EG-9) |

**Added by AMENDMENT 1** — the two-door split, the three identities, and the
derived projections each need teeth:

| # | control | expected |
|---|---|---|
| NC-34 | `try-` twin vs signalling twin | identical outcomes; the signalling one carries the same refusal object |
| NC-35 | refused application | returns `(values nil nil refusal)` — **three values on both branches** |
| NC-36 | proposal that can never apply (bad path) | Door 1 **succeeds**; Door 2 refuses. A proposal is a description, not a promise |
| NC-37 | Door 2 handed a raw datum instead of a proposal object | refuses `:not-a-replacement-proposal-object` |
| NC-38 | refused application | **no transformation occurrence identity comes into existence** — not null, not absent-marked |
| NC-39 | two identical proposals, distinct tags | distinct **proposal** identities |
| NC-40 | two identical proposals, identical tags | identical identities — **undetected host error, declared** |
| NC-41 | *planted*: stored `observed-old` wrong | **no receipt is produced** — `:observed-old-projection-mismatch` |
| NC-42 | *planted*: stored output identity wrong | **no receipt is produced** — `:output-identity-projection-mismatch` |
| NC-43 | *planted*: procedure version altered | detected by the suite — `:procedure-version-mismatch` |
| NC-44 | stale proposal whose `expected-old` equals its `replacement` | refuses **`:expected-old-mismatch` first**, never the no-op code (§4.4) |
| NC-45 | **merged-field boundary** in the identity census | a planted fault merging two adjacent committed fields is caught — one-axis sensitivity is insufficient |
| NC-46 | occurrence tag / encoded path over their ceilings | refuse at Door 1 with their own codes (§9.5) |
| NC-47 | staged successor when a later gate fails | **never observable**; input untouched; refusal retained (§8a) |

---

## 12a. PUBLIC API LEDGER — every external symbol, before any executable body

**⚠ ADDED BY AMENDMENT.** Legend — **Mint**: can this symbol *create* standing, a
phase object, a receipt or a refusal? **Agg**: does it return aggregate or
host-mutable data, and therefore owe a defensive snapshot?

**No phase-object, receipt or refusal constructor is public. There is no
`MAKE-FORM-TRANSFORMATION-RECEIPT`, no `MAKE-…-REFUSAL`, and no
`MAKE-REPLACEMENT-PROPOSAL` object constructor.** The only way a proposal object
exists is Door 1; the only way a receipt exists is a fully-gated Door 2.

### 12a.1 Grammar constructors — a program writes a proposal by hand

| symbol | caller | mint | agg | producer | fixture |
|---|---|---|---|---|---|
| `replacement-proposal-datum` | host | no — returns a **CD/0 datum**, not a phase object | no | pure builder | every case |
| `path-datum` | host | no | no | pure builder | all path fixtures |
| `index-step` · `key-step` | host | no | no | pure builder | NC-24, NC-30, NC-31 |

**These mint nothing.** They assemble inert CD/0 data that Door 1 may still
refuse. A caller may equally build the same datum with raw CD/0 constructors; the
builders are ergonomics, not authority.

### 12a.2 The two doors

| symbol | caller | mint | returns | fixture |
|---|---|---|---|---|
| `try-propose-replacement` | host | **proposal** | `(values proposal nil)` / `(values nil refusal)` | all propose refusals |
| `propose-replacement` | host | **proposal** | proposal / signals | NC-34 |
| `try-apply-replacement` | host | **receipt + successor** | `(values succ receipt nil)` / `(values nil nil refusal)` | all apply refusals |
| `apply-replacement` | host | **receipt + successor** | `(values succ receipt)` / signals | NC-34 |

### 12a.3 Readers — proposal

`replacement-proposal-p` · `-identity` · `-input-datum-identity` · `-path` ·
`-expected-old` · `-replacement` · `-occurrence-tag` · `-procedure-identity` ·
`-procedure-version` · `-policy-identity` · `-policy-version`

**Mint: none. Agg: `-path` returns immutable CD/0 data** (a sequence datum), so no
host-mutable aggregate escapes. All others return immutable CD/0 data.

### 12a.4 Readers — receipt

`form-transformation-receipt-p` · `-identity` · `-occurrence-identity` ·
`-proposal-identity` · `-input-datum-identity` · `-output-datum-identity` ·
`-path` · `-expected-old` · `-observed-old` · `-replacement` ·
`-procedure-identity` · `-procedure-version` · `-disposition` ·
`-policy-identity` · `-policy-version`

**`-observed-old` and `-output-datum-identity` are DERIVED PROJECTIONS** (§6.2c):
readable fields, verified at construction, deliberately **not** committed in the
receipt identity.

### 12a.5 Readers — refusal, and the condition

`form-transformation-refusal-p` · `-phase` · `-category` · `-code` · `-path` ·
`-offending` · `-detail` · `-identity`
plus the CD/0 passthrough set (§10.4): `-upstream-category` · `-upstream-code` ·
`-upstream-stage` · `-upstream-detail` · `-upstream-budget-id`
plus `form-transformation-refused` (condition) · `form-transformation-refused-refusal`

**Agg:** `-detail` returns a **fresh string copy** — Common Lisp strings are
mutable, and a reader handing out the stored one lets a caller edit a refusal
after the fact (Form /1's stated reason, adopted).

### 12a.6 The catalogue

`transformation-refusal-code-catalog` · `transformation-protocol-refusal-codes` ·
`transformation-integrity-alarm-codes` · `transformation-refusal-code-entry-p` ·
`-code` · `-class` · `-reachability` · `-note`

**Both lists DERIVED from one catalogue** (§10.3). `-note` returns a fresh copy.

### 12a.7 Policy, grammar and procedure identity

`transformation-grammar-identity` · `-version` ·
`transformation-policy-identity` · `-version` ·
`transformation-policy-max-input-octets` · `-max-output-octets` ·
`-max-path-depth` · `-max-path-octets` · `-max-occurrence-tag-octets` ·
`-max-identity-octets` · `-identity-tail-reserve-octets` ·
`transformation-procedure-identity` · `-version` ·
`identity-octets` · `render-identity-hex`

### 12a.8 Deliberately NOT exported

```
no MAKE-* for proposal objects, receipts, refusals or dispositions
no REPLACEMENT-PROPOSAL-DATUM-P classifier
      — TRY-PROPOSE-REPLACEMENT is the authoritative classifier and returns an
        inspectable refusal; a second boolean opinion could disagree with it
no path resolver (RESOLVE-PATH / DATUM-AT-PATH)
      — a public getter would be a general CD/0 addressing facility, which is
        CD/0's to add, not Form /2's to smuggle in
no handler, callback, predicate or transformer parameter anywhere (EG-4)
no flat FORM2-REFUSAL-CODES (§10.3)
```

**The path-resolver omission is a real decision, recorded as one.** Form /2
resolves paths internally because it must, but exporting the resolver would make
Form /2 the de-facto owner of CD/0 addressing — a capability grab disguised as a
convenience. If CD/0 wants a path facility, CD/0 should have one.

---

## 13. FILE AND PACKAGE PLAN

```
mneme/language-form-2/
  package.lisp                   the export surface, nothing else
  form2.lisp                     the layer
  form2-selftest.lisp            the suite
  de-forma-mutata/
    APPLICATION.lisp             the inhabited application
  run-form2-candidate.sh         local runner
  check-form2-transcript.sh      reconciliation over the captures
  LANGUAGE-FORM-2-WORK-ORDER.md  this file
  LANGUAGE-FORM-2-RETURN.md      written by the implementation, not now
```

**Nothing else is added and nothing existing is edited.** `form2.lisp` loads CD/0
and nothing above it. It does not `:use` Form /0 or Form /1, does not name them,
and **never writes `lisp-plus-form0::` or `lisp-plus-form1::`.** The *application*
may load Form /1 and Slice /2 **as a client**.

### 13.1 Required instruments — the minimum set

```
raw selftest transcript                    raw inhabited-application transcript
transcript reconciler                      export census
refusal catalogue + reachability ledger    identity round-trip checks
finite MULTI-AXIS collision census         exact resource-envelope measurement
deep/wide record rebuild measurement       public-reader aliasing controls
proposal/application multiple-value checks unexpected-condition escape controls
verdict-liveness sweep                     bounded claim-directed planted faults
```

**Two caps on two of these, both inherited from what this lane has already
paid for:**

- **The verdict-liveness sweep establishes CONNECTEDNESS ONLY, never predicate
  soundness.** Both of Form /1's previously-found hollow checks would have passed
  its sweep. The number licenses one sentence and no more.
- **The collision census must be MULTI-AXIS, with a planted merged-field-boundary
  fault** (NC-45). A one-axis-at-a-time sensitivity suite returns a clean sheet on
  a broken layer — `"a"‖"bc" = "abc" = "ab"‖"c"` — which is a measured finding
  from this lab's own Form /1 work, not a hypothetical.

**Every before-amendment measurement is preserved as historical evidence**
(§9.4a); none is edited to agree with the corrected ones.

The runner **executes and captures**; it renders no governance verdict of its
own, keeps exit codes separately, and its standing banner defers to the RETURN
document rather than restating a verdict it cannot verify. **It joins no
`verify-*.sh` floor** (§14).

**Known packaging limitation, inherited and declared up front:** a runner that
writes tracked transcript files cannot execute fully in a frozen read-only
target. Form /1's stranger audit hit exactly this and worked around it with a
writable scratch copy. It is a packaging limitation, not a semantic defect, and
Candidate /0 should say so in its own runner rather than let a future auditor
discover it.

---

## 14. FLOORS — CHANGED AND UNCHANGED

```
UNCHANGED, and this is a gate, not an aspiration:
  verify-form-floor.sh        3 floors ·  199 checks / 0 failed
  verify-language-floor.sh   11 floors ·  654 checks / 0 failed
  verify-all.sh               6 / 6 suites green
```

*(Re-run and confirmed green during the Form /1 audit intake earlier today, on
this same tree.)*

**Form /2 joins none of them.** Form /1 is not on a governing floor either; it
retains a separately named local candidate runner, and Form /2 follows that
precedent exactly. A candidate that adds itself to a floor has promoted itself.

---

## 15. RELATION TO MACROEXPANSION

A future **Surface /1** or **Form /3** could reuse the *receipt shape* — exact
input, exact output, procedure identity/version, disposition, resource policy —
to make macroexpansion inspectable. **Candidate /0 implements no macroexpansion,
and ordinary structural replacement does not solve it.**

**What Surface /0 has today, read rather than assumed.** Its five macros
(`define-judgment-schema`, `define-admission-contract`, `define-slice2-schema`,
`derive-case`, `derive/2-case`) **mint no object, carry no identity or version of
their own, record no before/after, and leave no artifact behind.** Its refusal
condition `surface-syntax-refused` carries no identity and is never filed. There
is **no expansion record of any kind** to extend.

**One characterization must be stated precisely, because it is easy to over-read.**
Surface /0's `SC22` (`surface0-selftest.lisp:652-698`) does `compile-file` → `load`
→ compare, and it is the only compile/load check in the layer. **It compares the
resulting OBJECTS through public readers — not the expansions.** Nothing anywhere
compares `compile-file`'s expansion to `macroexpand-1`'s. **`SC22` is therefore
not expansion equivalence and must never be cited as such.** An expansion receipt
would be establishing something that currently has no check at all.

What macroexpansion additionally requires, recorded so nobody mistakes the
overlap for sufficiency:

```
macro identity and version                       — which macro, at what version
expansion environment                            — and its identity
hygiene / capture facts                          — what was renamed, what was captured
exact expansion input and output                 — the part Form /2's shape already covers
whether any semantic-preservation claim is warranted — presumptively NO
compile/load equivalence standing                — a separate claim needing its own evidence
```

**The trap, named:** macroexpansion is where the intuition *"the meaning is
obviously the same"* is strongest, and it is therefore the place where a receipt
is most likely to be read as a preservation claim it never made. **A future
expansion receipt must state its limits more loudly than this one does, not less.**

---

## 16. NON-GOALS

Form /2 Candidate /0 is **not**: a general patch language · a source-code editor
· a generic AST rewrite framework · a macro system · an optimizer · a
semantics-preservation checker · a theorem prover · a version-control system · a
replay engine · a global transformation registry · a trusted extension mechanism
· an authority mechanism · Form /1 petition submission · Language Obligation /0.

No new governed operation. No new support species. No Slice /3. No Form /0 or
Form /1 modification.

---

## 17. ENTRANCE GATES

**EG-1 — Form /0 and Form /1 byte-untouched.** Both carry stranger audits bound
to exact subject trees (`e4f35123…`, `da16ebaa…`); **any executable change spends
that audit.** Hash both subject trees before and after implementation.

**EG-2 — no `lisp-plus-form0::` and no `lisp-plus-form1::`.** §2.2–2.3 determine
none is needed. If implementation discovers otherwise, **stop and report the
contradiction** rather than reaching through.

**EG-3 — the identity envelope, measured at the TRUE maximum.** Print every
identity length for: the smallest lawful transformation; the inhabited Candidate
D transformation; and **the largest admitted input replaced at the shallowest
path** (§9.4). If any terminal identity exceeds **65,536 octets**: stop, report
**EG-3 FAILED**, and **invent no hash protocol.** *Pre-measured at 49,215 octets
for the §6.2 shape; a naive shape measures 131,004 and fails.*

**EG-4 — no caller-supplied procedure anywhere in the public surface.** Grep the
proposed export list for any symbol that accepts a function, and the
implementation for `EVAL`, `COMPILE`, `READ-FROM-STRING` and unrestricted
`FUNCALL` on caller data. Any hit is a stop.

**EG-5 — every declared refusal code has a fixture, or is deleted** (NC-19).

**EG-6 — no `(ERROR () …)` introduced.** Form /2 adds no broad handler. The nine
severe predecessor sites stay docketed and unrepaired; **Form /2 must not become
the twelfth.**

**EG-7 — a stranger audit is OWED for Form /2** and is **not** pre-satisfied by
Form /0's or Form /1's, each of which binds one subject tree. Successor
dependence on Form /1 is experimental, with its residuals — **NC-31B foremost,
never to be called repaired** — carried forward verbatim.

**EG-8 — the rebuild cost is measured, and no CD/0 stage label escapes
mislabelled** (§2.1a). Print, for the deepest and widest admitted input: the
number of `make-record-datum` calls one replacement causes, and the total
record-key octets re-charged across the rebuild. Then plant a fault that drives a
rebuild into CD/0's `max-total-record-key-octets` and **show that the refusal
surfaces under a Form /2 code, not as a raw `"host-import"` resource failure.**
A budget refusal that reaches a host wearing the wrong stage name is a
representation collapse with a receipt attached.

**EG-9 — the identity representation is Form /1's, not Form /0's** (§7.1). Grep
the implementation for `octets-to-hex` anywhere in an identity composition path.
Any hit silently doubles per link and invalidates the §9 measurements: **stop and
re-measure.**

---

## 18. WHAT CANDIDATE /0 WOULD EARN — AND WHAT IT WOULD NOT

### Would earn

- One exact, bounded structural transformation over inert canonical data, with a
  receipt that names exactly what changed.
- A demonstrated separation between **a structural event** and **the standing of
  what it produces** — exhibited by a fixture in which the rewrite succeeds and
  the resulting form is refused.
- A successor that re-enters proposal **as a stranger to its own history**, with
  the full genealogy externally reconstructible and no backward flow.
- A **pre-measured** resource ceiling, with the failing naive shape recorded
  beside the passing one, so the next candidate inherits the arithmetic instead
  of the accident.

### Would NOT earn

- Any claim of semantic preservation, equivalence, or correctness. **Ever.**
- Any claim that the successor is a lawful program.
- Adoption, specification freeze, or a place on a governing floor.
- Any authority over Form /0, Form /1, Slice /2, or `DERIVE/2`.
- A solution to macroexpansion (§15).
- Detection of a host that declares an expected-old subtree it has no business
  declaring. **Form /2 checks that the declaration MATCHES; it cannot check that
  the declarer was entitled to make it.** This is NC-31B's shape one layer down,
  and it is declared here at the design stage rather than discovered at review.

---

## 19. RECOMMENDATION

```
READY TO IMPLEMENT FORM /2 CANDIDATE /0
```

The architecture is selected on read evidence (§3), the one operation is exactly
specified (§4), the identity chain is proven flat and statically bounded (§8),
and the resource ceiling that would otherwise have blocked the candidate
mid-implementation has been **measured in advance and designed around** (§9).

No architectural contradiction was found. The one genuine hazard — an
EG-4-shaped identity blow-up at 8.00× the datum — was located before a line of
Form /2 was written, and the reduction that clears it costs the receipt nothing
it needs to carry.

### What AMENDMENT 1 changed about that recommendation

The recommendation is unchanged; **the design under it is materially different.**
The colleague read found, and this amendment repairs: a phase named without a
transition (§5); a host tag mistaken for an occurrence (§6.2a); an unqualified
discrimination claim (§6.2b); a genealogy claim an edge set cannot support (§8.1);
four further defects in the probes, including that the corrected probe measured an
event Candidate /0 now refuses (§9.4a); a no-op test placed before the layer had
looked at the world (§4.4); a resource rule copied from Form /1 without its reason
(§8a); two advertised codes with no reachable fixture (§10.1); and a fixture whose
*title* broke the layer's own vocabulary rule (§11).

**None of those was found by measurement or by review of the code — there is no
code. All nine were found by a reader.** That is what the seat is for, and it is
also why the reader's lack of independence does not reduce the value of the
finding: **a defect is a defect regardless of who is entitled to certify it.**
What the shared root costs is only the right to call the agreement *evidence.*

### What this work order got wrong before it got it right

Recorded because a design document that shows only its conclusions is a
conclusion wearing a design's costume.

1. **The path grammar was wrong.** §4.1 originally let a record step carry any
   CD/0 datum, and justified tagging by saying a record key might itself be an
   integer. `cd0.lisp:732` forbids non-identifier keys outright. **The rule was
   corrected and the false rationale was replaced by the one that survives
   reading the source** — with the error left visible in §4.1 rather than edited
   away.
2. **The first sizing measurement was a fixture maximum.** It reported the naive
   receipt at 3.64× and "fits." The true figure is 8.00× and fails (§9.4).
3. **The rebuild cost and the identity-representation split were both invisible
   to me** until the source was surveyed (§2.1a, §7.1). Either could have been
   discovered mid-implementation instead, which is where Form /1 discovered EG-4.

---

## 20. PROVENANCE

This work order was written against the live tree at lab main `6970dcbd`. Two
**read-only** surveys informed it, and their findings were **verified at the
source before being written down**, not adopted on report:

- a survey of existing addressing / replacement / precondition / identity /
  policy / refusal machinery across `experiments/latent-lisp/`;
- a survey of the Atelier specimens (`de-torno`, `de-fornace`, `de-temperie`),
  the two inhabited applications, and Surface /0.

Three claims in the surveys were checked directly before use and are cited with
the lines that settle them: `make-record-entry`'s identifier-key requirement
(`cd0.lisp:732-736`), `record-datum-fields`' stripping of the key-bytes cache
(`cd0.lisp:948-958`), and the Form /0 / Form /1 identity-representation split
(`form0.lisp:71` vs `form1.lisp:189-197`). **The one survey claim that changed a
design decision — the record-key rule — is the one that corrected an error I had
already written.**

The §9 measurements were taken by a scratchpad probe over the existing unmodified
stack, using CD/0 primitives only, under SBCL 2.4.6 operation-checked through the
wrapper. **No Form /2 source exists. Nothing was written into the repository by
the measurement.**

---

*Work order only. No Lisp source, no package, no runner, no floor change, no
modification to any existing layer. Form /2 is not opened as an implementation by
this document; it is opened as a design with its first landmine already dug up.*

*— Claude Opus 5 (1M context), 2026-07-27, on branch `language-form-2-work-order`
from lab main `6970dcbd`.*
