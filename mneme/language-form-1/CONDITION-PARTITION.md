# CONDITION-PARTITION — what Form /1 classifies, and what goes through it untouched

*Language Form /1, Candidate /0 · worktree `language-form-1-candidate-0` · SBCL 2.4.6*
*Companion checker: `CONDITION-PARTITION.lisp` · raw capture: `CONDITION-PARTITION-RUN.txt`*
*— Claude Opus 5 (1M context), as LIMEN*

---

## 0. WHAT THIS DOCUMENT IS, AND WHAT IT REFUSES TO BE

`SUBMIT-PETITION` catches **exactly two** Slice /2 condition classes. Its own docstring says so:

> `ONLY the two exact Slice /2 classes are caught.  Everything else ESCAPES.`

That sentence is true, and it is also **half a partition**. It names the caught set and leaves the
escaping set as a promise nobody enumerated. This document enumerates it.

**The complement of a documented set is not documented merely because the set is.** A host author
reading "two classes are caught" learns which two handlers to write. They do not learn *which
conditions will come through their `submit-petition` call as themselves*, leaving no Form /1
semantic object behind — no outcome, no submission receipt, no refusal, nothing to inspect
afterwards. That set is the subject here.

**This document reports; it does not repair.** Three conditions escape. The correct action for a
report is to record that they escape. Not one handler was added to make the table smaller.

### The scope, stated so it can be checked

The classified inventory is **every external symbol naming a condition class in the three packages
on the Form /1 submission path**:

| package | source of truth read | live count |
|---|---|---|
| `LISP-PLUS-SLICE1` | `../language-slice-1/slice1.lisp` `defpackage` | 8 |
| `LISP-PLUS-SLICE2` | `../language-slice-2/package.lisp` `defpackage` | 11 |
| `LISP-PLUS-FORM1` | `package.lisp` `defpackage` | 1 |
| | **total** | **20** |

Those counts are **not transcribed** — they are recomputed from the running image every time the
checker runs, and the checker fails with a non-zero exit if the live set and the table below
disagree in **either** direction (see §5). One raw host class, `CL:TYPE-ERROR`, belongs to no
package inventory and is treated separately in §4.

---

## 1. THE FIVE CLASSES

| class token | meaning |
|---|---|
| `PROTOCOL-REFUSAL` | Refused by Form /1 **before** `DERIVE/2` is invoked. A `PETITION-REFUSED` with a catalogued code; `TRY-` twins return it as an object. |
| `GOVERNED-REFUSAL` | Caught by `SUBMIT-PETITION`; becomes an outcome of kind `:GOVERNED-REFUSAL`. |
| `DOOR-REFUSAL` | Caught by `SUBMIT-PETITION`; becomes an outcome of kind `:DOOR-REFUSAL`. |
| `ESCAPES` | Reaches the caller **as itself**, uncaught, leaving **no** Form /1 semantic object behind — no outcome, no submission receipt, no retained refusal. |
| `UNREACHABLE` | Cannot arise on this path at all. Every row carries its concrete reason. |

The classes are exclusive and the assignment is by **what actually happens to a condition of that
exact class on this path** — not by what a handler would cover if one arrived. Where those two
answers differ, the difference is the fourth column, and it is the most useful column in the table.

---

## 2. THE PARTITION

Column 2 is the machine-readable class token. Column 4, **IF-IT-ARRIVED**, states what the two
installed handlers would do with a condition of that class *were it ever signalled on this path* —
which for the fourteen `UNREACHABLE` rows is a statement about handler coverage, not about traffic.

<!-- PARTITION-TABLE-BEGIN -->

| SYMBOL | CLASS | EVIDENCE | IF-IT-ARRIVED | WHY |
|---|---|---|---|---|
| `LISP-PLUS-FORM1:PETITION-REFUSED` | PROTOCOL-REFUSAL | EXECUTED | n/a — it is Form /1's own | Every pre-invocation gate signals it: species, seal, `:BY`/`:BY-ID`/`:ACT-ID`, petition-identity recomputation, the submission envelope, and all four reference resolutions. `DERIVE/2` is not invoked. |
| `LISP-PLUS-SLICE2:SLICE2-DERIVATION-REFUSED` | GOVERNED-REFUSAL | EXECUTED | caught | Caught by name at `form1.lisp:1473`. Signalled by `DERIVE/2` whenever any premise admission is not `:SATISFIED` — including when the base Slice /1 `DERIVE` itself refused. |
| `LISP-PLUS-SLICE2:SLICE2-SCHEMA-ERROR` | DOOR-REFUSAL | EXECUTED | caught | Caught by name at `form1.lisp:1478`. Reachable through exactly one of its two `DERIVE/2` sites: the `(EQ registered base)` registry check at `slice2.lisp:1549`. |
| `LISP-PLUS-SLICE1:PATTERN-USED-AS-GROUND` | ESCAPES | EXECUTED | escapes | `%REQUIRE-GROUND` (`slice1.lisp:427`) is the first thing Slice /1 `DERIVE` does. `BIND-CONCLUSION-REFERENCE` is deliberately value-unchecked, so a `PROPOSITION-PATTERN` bound as the conclusion reaches it. Neither `DERIVE/2` nor `SUBMIT-PETITION` handles it. |
| `LISP-PLUS-SLICE1:MALFORMED-STRUCTURED-PROPOSITION` | ESCAPES | EXECUTED | escapes | `(PROPOSITION conclusion)` inside Slice /1 `DERIVE` (`slice1.lisp:1838`). Any conclusion that is not a lawful ground structured proposition — an integer, a bad head, a raw `(:var …)` — signals here. Unhandled at both layers above. |
| `LISP-PLUS-SLICE1:UNBOUND-CONCLUSION-VARIABLE` | ESCAPES | EXECUTED | escapes | `%BIND-CONCLUSION` (`slice1.lisp:1684`). A lawful ground conclusion that does not ground every conclusion variable of the resolved schema. Note it is a *post-threshold* refusal carrying a real Slice /1 receipt — and that receipt is destroyed by the escape, because nothing above it looks. |
| `LISP-PLUS-SLICE1:SLICE1-CONDITION` | UNREACHABLE | READ | would escape | Abstract family base. `SIGNAL-SLICE1` is never called with it; every one of the seven signal sites names a leaf. No condition of this exact class is ever constructed. |
| `LISP-PLUS-SLICE1:DERIVATION-REFUSED` | UNREACHABLE | READ | would escape | Signalled twice inside Slice /1 `DERIVE` — and `DERIVE/2` catches it by name at `slice2.lisp:1614`, converting it to a base receipt and then to `SLICE2-DERIVATION-REFUSED`. It is stopped one layer **below** Form /1 and cannot cross this boundary. |
| `LISP-PLUS-SLICE1:SCHEMA-NOT-FOUND` | UNREACHABLE | READ | would escape | Only `RESOLVE-SCHEMA` signals it. `DERIVE/2` calls `RESOLVE-SCHEMA` inside its own `(HANDLER-CASE … (ERROR () NIL))` and then refuses with `SLICE2-SCHEMA-ERROR` unless the registered object is `EQ` to the base — so by the time Slice /1 `DERIVE` resolves the same key, the schema is registered. |
| `LISP-PLUS-SLICE1:SCHEMA-CONSTRUCTION-ERROR` | UNREACHABLE | READ | would escape | Signalled only by `JUDGMENT-SCHEMA` and `REGISTER-SCHEMA` — host-side construction, performed before a petition exists. Form /1 calls neither. |
| `LISP-PLUS-SLICE1:SCHEMA-REGISTRATION-CONFLICT` | UNREACHABLE | READ | would escape | Signalled only by `REGISTER-SCHEMA` (`slice1.lisp:668`). Form /1 never registers a schema; it never mutates the registry at all. |
| `LISP-PLUS-SLICE2:SLICE2-CONDITION` | UNREACHABLE | READ | would escape | Abstract family base. `%REFUSE` and `SIGNAL-SLICE2` are always called with a leaf or family type; no site names the base. |
| `LISP-PLUS-SLICE2:ADMISSION-CONTRACT-ERROR` | UNREACHABLE | READ | would escape | Signalled only by `MAKE-SUPPORT-ADMISSION-CONTRACT`. A contract is built by the host before the Slice /2 schema exists; Form /1 never constructs one, so this cannot arise on this path. |
| `LISP-PLUS-SLICE2:UNKNOWN-ADMISSION-CLAUSE` | UNREACHABLE | READ | would escape | Signalled only by `%NORMALIZE-CLAUSE`, reached only from `MAKE-SUPPORT-ADMISSION-CONTRACT`. Refused **at construction** by design (D2-0.1), so no unevaluable clause can reach a premise at derive time. |
| `LISP-PLUS-SLICE2:PREMISE-CONTRACT-MISSING` | UNREACHABLE | READ | would be caught as DOOR-REFUSAL | Two sites. `MAKE-SLICE2-SCHEMA` is host-side construction. The other, `SLICE2-SCHEMA-CONTRACT-FOR-PREMISE`, *is* on the `DERIVE/2` path — but `MAKE-SLICE2-SCHEMA` proved contracts cover premises `0..n-1`, `JUDGMENT-SCHEMA-PREMISES` is a `:READ-ONLY` slot whose public reader copies, and `DERIVE/2` requires the registered schema to be `EQ` to the base — so `n` cannot have changed. No host mutation can open this. |
| `LISP-PLUS-SLICE2:PREMISE-CONTRACT-DUPLICATE` | UNREACHABLE | READ | would be caught as DOOR-REFUSAL | Signalled only by `MAKE-SLICE2-SCHEMA` (`slice2.lisp:567`). Host-side construction, before any petition. |
| `LISP-PLUS-SLICE2:PREMISE-CONTRACT-UNKNOWN-PREMISE` | UNREACHABLE | READ | would be caught as DOOR-REFUSAL | Signalled only by `MAKE-SLICE2-SCHEMA` (`slice2.lisp:558`). Host-side construction, before any petition. |
| `LISP-PLUS-SLICE2:SOURCE-BASIS-REFUSED` | UNREACHABLE | READ | would escape | Signalled only by `ESTABLISH-CORE0-SOURCE-BASIS`. A source basis is established by the host and then *bound as a support*; Form /1 never establishes one, and `DERIVE/2` only reads bases it is handed. |
| `LISP-PLUS-SLICE2:UNISSUED-CORE0-ACCOUNT` | UNREACHABLE | READ | would escape | Same single site, `ESTABLISH-CORE0-SOURCE-BASIS` (`slice2.lisp:816`). Host-side, pre-petition. |
| `LISP-PLUS-SLICE2:DERIVATION-BASIS-REFUSED` | UNREACHABLE | READ | would escape | **It has no signal site anywhere in the layer.** Defined at `slice2.lisp:92`, exported, and never raised; Slice /2's own API document calls it "a false affordance today". Every derivation-basis refusal is expressed as a `:NOT-ADMITTED` *disposition* in the receipt, never as a condition. |

<!-- PARTITION-TABLE-END -->

### Totals

| class | count |
|---|---|
| `PROTOCOL-REFUSAL` | **1** |
| `GOVERNED-REFUSAL` | **1** |
| `DOOR-REFUSAL` | **1** |
| `ESCAPES` | **3** |
| `UNREACHABLE` | **14** |
| **total** | **20** |

---

## 3. THE THREE THINGS THE FOURTH COLUMN SAYS

**(a) The two installed handlers cover more classes than the path can produce.** Catching
`SLICE2-SCHEMA-ERROR` by family also covers its three subtypes — `PREMISE-CONTRACT-MISSING`,
`-DUPLICATE`, `-UNKNOWN-PREMISE`. None of the three can arrive. The coverage is real and idle. That
is not a defect; it is an over-approximation, and it is the safe direction.

**(b) The escape set is not the complement of the caught set.** Eleven of the fourteen unreachable
classes *would* escape if they ever arrived. The reason they do not is **not** that Form /1 handles
them — it is that no code path constructs them here. The seal on those eleven is **structural, and
lives in other files**: a host-side constructor, a read-only slot, an `EQ` guard, a
`HANDLER-CASE` one layer down. Every one of those is a thing a future edit can move. The
enumeration is therefore a **standing dependency list**, not a closed proof.

**(c) The three real escapes share one origin: the deliberately unchecked conclusion binder.**
`BIND-CONCLUSION-REFERENCE` is value-unchecked on an argued design ground, quoted from its own
docstring:

> `A check here would be A GATE THAT LOOKS COMPLETE AND IS NOT.  The Slice /1 escape conditions stay visible instead.`

The design intent is explicit and the consequence is exactly what the table records: all three
escaping classes are conclusion-shaped, and all three are reached through that one binder. What the
docstring says is "visible" is visible **to a caller who wrote a handler for a Slice /1 class while
calling a Form /1 function**. Nothing in the Form /1 public surface names those three classes; they
appear in no catalogue the layer publishes. `PETITION-REFUSAL-CODE-CATALOG` publishes Form /1's own
codes and their reachability — there is no equivalent for what passes through. This table is that
missing surface.

**A note on cost.** `UNBOUND-CONCLUSION-VARIABLE` is the expensive one. Slice /1 raises it *after*
the threshold, deliberately carrying a real `DERIVATION-RECEIPT` (`slice1.lisp:1659–1676` argues at
length for why that receipt must exist). When it escapes Form /1 uncaught, that receipt is inside a
condition object nobody above is looking at, and no submission receipt is minted to record that the
act happened. The layer below paid to construct an account; this boundary drops it.

---

## 4. THE RAW HOST `TYPE-ERROR` — MEASURED, NOT ASSUMED

**The door is real one layer down, and Form /1 closes it. This path is NO LONGER REACHABLE through
the Form /1 public boundary.**

Both halves were executed, not reasoned:

1. **The door exists.** Calling `LISP-PLUS-SLICE1:DERIVE` or `LISP-PLUS-SLICE2:DERIVE/2` directly
   with `:receiver 42` signals a raw `CL:TYPE-ERROR` — *"The value 42 is not of type
   LISP-PLUS-SLICE0:RECEIVER-CONTEXT"* — out of the struct accessor at `slice1.lisp:1840`. Nothing
   in Slice /1 or Slice /2 guards it.
2. **Form /1 closes it.** `BIND-RECEIVER-REFERENCE` (`form1.lisp:1129–1132`) applies the species
   checker `(OR (NULL value) (RECEIVER-CONTEXT-P value))`. A non-receiver never gets into a context,
   so it never reaches `DERIVE/2`. The attempt signals `PETITION-REFUSED` with code
   `:WRONG-RECEIVER-SPECIES` — a `PROTOCOL-REFUSAL`, at bind time, before the context is even sealed.

Fixture 7 executes all three legs: the two direct calls that *do* raise `CL:TYPE-ERROR`, and the
Form /1 bind that refuses instead. The classification is therefore **UNREACHABLE — sealed at the
binder**, and it is sealed by a **species check whose deletion would silently reopen it**. The
receiver binder is the only one of the four that is type-checked *and* whose type-check is
load-bearing for escape: the schema binder's check is redundant with `DERIVE/2`'s own
`SLICE2-SCHEMA-ERROR`, and the conclusion and support binders have no check at all.

`CL:TYPE-ERROR` is deliberately **not** in the §2 table: it belongs to no package inventory, so it
cannot participate in the set-difference gate. It is covered by an executed fixture instead, which
is the stronger evidence.

---

## 5. THE STALENESS GATE — WHY THIS TABLE CANNOT QUIETLY BECOME A LIE

A hand-transcribed table is one edit from a lie, and this lane has already been bitten once: a suite
header was transcribed from a document that was amended twenty minutes later
(`form1-selftest.lisp:23–38`).

So `CONDITION-PARTITION.lisp` **parses this file** — the very table in §2, between the two HTML
comment markers that bracket it — and compares the symbols it finds against the condition classes it
walks out of the **running image** (`DO-EXTERNAL-SYMBOLS` over the three packages, keeping every
symbol for which `FIND-CLASS` yields a class that `SUBTYPEP`s `CONDITION`).

The human table **is** the parsed artefact. There is deliberately no machine-readable twin beside
it: a twin is a second thing to keep in sync, which is the defect this gate exists to prevent, one
level down.

Set-difference is computed in **both** directions, exactly as `T-CODESET` does for refusal codes:

* **live ∖ table** — a condition class exists that this document does not classify. **FAIL.**
* **table ∖ live** — this document classifies a symbol that is no longer an exported condition
  class. **FAIL.**

Either failure exits non-zero. There is no third state and no warning tier: an unclassified
condition class is precisely the defect this document exists to prevent.

The checker additionally enforces, all as hard failures:

* every class token in column 2 is one of the five;
* every class the table calls reachable (`PROTOCOL-REFUSAL`, `GOVERNED-REFUSAL`, `DOOR-REFUSAL`,
  `ESCAPES`) was **exercised by a fixture in this run** — a table row is not evidence, an execution
  is;
* every fixture asserts the **exact** condition class via `(EQ (TYPE-OF c) 'expected)`, never
  membership in a set, and every outcome fixture cross-checks the class name string the submission
  receipt itself recorded;
* no fixture, and no helper, installs a broad `(ERROR () …)` or `(CONDITION () …)` handler. Each
  `EXPECTING` form names one literal class. **A condition of any other class escapes the harness
  exactly as it escapes the layer** — if the partition is wrong, this checker dies loudly rather
  than absorbing the surprise.

### The gate has been shown to FIRE, twice by accident and once on purpose

A gate that has never fired is untested, not passing. This one has three receipts, all in
`CONDITION-PARTITION-RUN.txt`:

1. **On purpose.** The row for `DERIVATION-BASIS-REFUSED` was deleted from the table above, the
   checker was run, and it exited **1** naming exactly that class as `LIVE BUT UNCLASSIFIED`. The
   file was then restored and verified byte-identical with `diff -q` before the deliverable run was
   captured.
2. **By accident, and this one is worth reading.** The checker's *first* run against this document
   failed: prose in this section originally named the begin-marker token in backticks, which
   **re-opened the parser** and swept the tables of §6 and §7 in as partition rows. The
   inventory gate itself still passed in both directions — only the *parse-problem* check caught it.
   A parser that silently dropped unparseable rows would have hidden this completely, and the table
   would have looked verified while its scope was wrong. The delimiters are now matched as whole
   HTML comments, assembled at runtime from two halves.
3. **By accident again.** The `T-NO-BLANKET` source scanner **convicted itself**: its own check
   label contained the literal it was scanning for. Every needle is now assembled at runtime, so the
   scanner's vocabulary is not part of the corpus it scans, and the expected count is exactly `0`
   rather than "0 plus my own declaration" — a tolerance a real handler could have hidden inside.

Both accidental faults were defects in the *checker*, not the layer, and both are the kind a reading
audit waves through. They are recorded rather than quietly fixed because the recording is the point:
the instrument caught its own author twice before it was allowed to certify anything.

### What this gate does NOT prove

It proves the table is complete **with respect to the exported condition inventory of the three
named packages**. It does not prove:

* that no `LISP-PLUS-SLICE0`, `LISP-PLUS-CORE0`, `LISP-PLUS-KERNEL0` or `LISP-PLUS-CD0` condition can
  escape. Those inventories are out of the compared scope. §6 records what was read about them and
  what was not.
* that no *other* raw host condition can escape. `CL:TYPE-ERROR` was checked because it was named;
  the general host-condition surface was not enumerated, and cannot be from a package walk.
* that the fourteen `UNREACHABLE` reasons will survive edits to `slice1.lisp` / `slice2.lisp`. They
  are read out of those files, not enforced by this checker. Only the *inventory* is gated; the
  *reasons* are prose and are exactly as durable as prose.
* **that this measurement still holds against a `form1.lisp` newer than the one it ran against.**
  The deliverable run loaded `form1.lisp` at mtime `13:48:47`; `form1-selftest.lisp` and
  `de-forma-petente/APPLICATION.lisp` moved *later the same hour*, under the chair's hand, while
  this was being written. The inventory gate would catch a changed *condition inventory*; it would
  **not** catch a new `HANDLER-CASE` clause added to `SUBMIT-PETITION`, which would silently move a
  row from `ESCAPES` to a caught class. **Re-run the checker after any edit to `SUBMIT-PETITION`'s
  handler set** — and if a row moves, that is a finding, not a failure.

---

## 6. ADJACENT PACKAGES — READ, AND WHERE THE READING STOPS

`LISP-PLUS-SLICE0` exports 13 condition classes and sits directly under the derive path. It is not in
the compared scope, so here is what was actually read:

* **The grant path is guarded.** `%GRANT-DERIVATION` (`slice1.lisp:1766–1784`) wraps
  `LISP-PLUS-SLICE0:RAISE` in a `HANDLER-CASE` on `SLICE0-CONDITION` and converts any refusal into
  `DERIVATION-REFUSED`, which `DERIVE/2` then catches. So nothing signalled *by `RAISE`* escapes.
* **Two constructor calls sit OUTSIDE that handler** — `S0:WITNESS` and `S0:CLAIM`, in the same
  `LET*` at `slice1.lisp:1753–1765`. Both can signal `MALFORMED-SLICE0-SHAPE`. Both were checked and
  neither can fire here: `witness`'s `:KIND` comes from `%SCHEMA-ADMIT-KIND`, which is computed by
  the layer and never caller-supplied (`JUDGMENT-SCHEMA` takes no `:ADMIT-KIND` argument at all), and
  `claim`'s only two guards are a non-`NIL` proposition (already the lawful normal form) and a
  non-`NIL` `:BY` — which `SUBMIT-PETITION` has already required with `:BY-REQUIRED`.
  **This is a narrow escape, not a wide one:** the seal on `S0:WITNESS` is that a keyword is
  computed rather than accepted, and the seal on `S0:CLAIM`'s `:BY` is a Form /1 gate two layers up.
  Either is an edit away from opening.
* **The accessibility readers are `NIL`-guarded.** `%SUPPORT-ACCESSIBLE-P` and
  `%CLAIM-ACCESSIBLE-P` both short-circuit on `(NULL ctx)`, so an explicitly-absent receiver — which
  `BIND-RECEIVER-REFERENCE` permits, with the package-owned absence declaration — does not reach a
  struct accessor. Executed: a `NIL`-receiver submission returns an ordinary outcome, not a condition.
* **What was not done:** no fixture-level sweep of the Slice /0, Core /0 or Kernel /0 inventories.
  The three bullets above are reading, not measurement, and are labelled as such.

---

## 7. WHAT WAS EXECUTED VS. WHAT WAS READ

| finding | evidence |
|---|---|
| `PATTERN-USED-AS-GROUND` escapes | **EXECUTED** (fixture 4) |
| `MALFORMED-STRUCTURED-PROPOSITION` escapes | **EXECUTED** (fixture 5, two distinct malformations) |
| `UNBOUND-CONCLUSION-VARIABLE` escapes | **EXECUTED** (fixture 6) |
| `SLICE2-DERIVATION-REFUSED` → `:GOVERNED-REFUSAL` | **EXECUTED** (fixture 2) |
| `SLICE2-SCHEMA-ERROR` → `:DOOR-REFUSAL` | **EXECUTED** (fixture 3, two distinct provocations) |
| `PETITION-REFUSED` is pre-invocation | **EXECUTED** (fixtures 1, 7) |
| raw `CL:TYPE-ERROR` receiver path is sealed at the binder | **EXECUTED** (fixture 7, all three legs) |
| the other fourteen classes are unreachable | **READ** — reasons in the table's fifth column, each naming a file and a line |

Nothing in the `UNREACHABLE` column was demonstrated by execution, and it could not honestly be:
demonstrating a negative would require exhausting the input space. Each of those rows is a **reading
of a specific guard in a specific file**, and every one names it so the next reader can check the
guard rather than the claim.

---

*A caught condition becomes an object. An escaping condition becomes the caller's problem.
Both are fine. Only the unenumerated one is not.*
