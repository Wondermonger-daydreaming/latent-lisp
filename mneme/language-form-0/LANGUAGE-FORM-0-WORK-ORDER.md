# LANGUAGE FORM /0 — CANDIDATE /0 — WORK ORDER

## "The Program Can Be Held"

*Owner-issued 2026-07-26. Written against the live tree at `4c4f43ad`, after
the required reading, before any line of `form0.lisp` existed.*

```
status:                        owner-issued work order
implementation-authorized:     yes (bounded vertical, isolated worktree)
specification-frozen:          no
adopted:                       no
stranger audit:                OWED, non-blocking
Slice /3:                      NOT opened
```

**Primary law:**

> **In Lisp+, code may be data before it becomes authority.**

**Not to be done:** a general evaluator · a reader or textual parser · new
live-authority semantics · a global identity registry · any change to Kernel /0,
Core /0, Slice /0, Slice /1, Slice /2, Surface /0 or Canonical Datum /0 · a new
support species below any existing layer · opening Slice /3 · repairing the
unrelated Surface /0 style warning · touching the untracked root `_staging/`.

---

## 0. THREAT MODEL  *(added by owner ruling, chair review 1)*

**Form /0 protects against:** malformed, adversarial or model-emitted Canonical
Datum forms attempting to acquire operations not installed in their sealed
environment.

**Form /0 does NOT claim protection against:**

- malicious Common Lisp already executing in the same image;
- use of package-internal symbols through implementation facilities;
- `SYMBOL-FUNCTION` redefinition or arbitrary image mutation;
- replacement of the Form /0 implementation itself;
- callers bypassing Form /0 and invoking host functions directly;
- compromised Lisp implementations or process memory.

**The trusted computing base** is the Common Lisp implementation, the loaded
Form /0 implementation, its package-owned descriptors and handlers, and the host
orchestration code that invokes the public protocol.

**Package-controlled operator installation is a PUBLIC-API ENFORCEMENT
BOUNDARY.** It is not process isolation and not a hostile-host sandbox. Lisp is
many magnificent things; a process-isolation primitive it is not.

Option (b), self-declared handler identity, is **rejected**: it records an
assertion about behaviour without enforcing it — the malicious closure signs its
own nametag and continues working the night shift. Option (a), a host-supplied
trusted operator extension, is **deferred to a separate future frontier** and is
not silently preserved through any Candidate /0 export.

### Entrance gate for Form /1 — phase-identity growth

Candidate /0's recursively embedded phase identities are accepted **only**
because the phase chain has a statically bounded depth, no transformation
history exists, no persistence claim is made, and the grammar and resource
policy are bounded. Measured: 440 → 1040 → 4658 → 12456 → 26020 characters.

> **GATE.** No unbounded phase history may recursively embed full predecessor
> identity strings. A bounded, durable reference design must be adopted before
> any Form /1 feature introducing repeatable transformations, replay chains or
> persistence is opened.

The present representation is **not** suitable for arbitrary transformation
depth, and nothing in this lane may imply that it is.

---


## 1. What the reading established

The three Atelier instruments already execute most of this law. They do it in
the vocabulary of a workshop, over **host proper-list trees**, inside a
single cooperative image, with a pedagogical FNV digest. Form /0 is not a
rename of that work. It moves four of its invariants onto the **durable CD/0
boundary**, where the identity is content-derived rather than pedagogical and
the input can never be a host form at all.

**The load-bearing difference, stated once.** `de-torno`, `de-fornace` and
`de-temperie` all begin with `validate-form-tree` — a *defensive* function whose
job is to reject dotted and circular host conses. Form /0 has no such function
and needs none: a CD/0 datum **cannot be dotted or circular**, because the nine
families admit no improper tail and the constructors accept no cycle. The
Atelier defends a boundary; Form /0 *is on the other side of it*. That is the
whole reason for building this rather than promoting an instrument.

### 1a. Extraction map

| existing Atelier invariant | → proposed Form /0 invariant | → new object or operation | → executable tooth |
|---|---|---|---|
| **de-torno**: *"A transformer may propose a new form, but it may not silently install it"* | a candidate datum is admitted as a **proposal** and never as an executable | `propose-form` → `proposed-form` | `T-REALIZE-NEEDS-VALIDATION` — a `proposed-form` cannot reach `realize-form` |
| **de-torno**: `require-pass` — passes are *installed*, never looked up from caller data | operators are **installed in a sealed environment by the program**; the form may name one, never supply one | `form-environment`, `operator-descriptor`, `seal-form-environment` | `T-OPERATOR-UNKNOWN`, `T-NO-RAW-FUNCTION` |
| **de-torno**: `pass-version-mismatch` — plan names v*n*, registry holds v*m* → refuse | validation binds **grammar version and environment version**; realization refuses on either drift | `validated-form` fields; `realize-form` re-check | `T-GRAMMAR-VERSION-DRIFT`, `T-ENVIRONMENT-VERSION-DRIFT` |
| **de-torno**: `scope-violation` — declared jurisdiction vs. reached path | the closed grammar **is** the jurisdiction; a node outside the three productions never becomes a proposal | `%admit-node` recursive descent | `T-UNKNOWN-PRODUCTION` |
| **de-torno**: `stale-turn-plan` — a plan cut for digest *a* cannot commit against digest *b* | a validation is bound to **one exact instantiated-form identity** and no other | `form-validation-receipt` | `T-VALIDATION-NOT-TRANSFERABLE` |
| **de-torno**: shavings — replaced material survives the cut | refused candidates survive as **retained refusals**, not printed conditions | `form-refusal`, `try-*` entry points | `T-REFUSALS-OUTLIVE-SUCCESS` |
| **de-fornace**: *"admission is distinct from adoption"* | admission (`propose-form`) is distinct from instantiation, validation and realization — **four objects, not one status slot** | the five-object chain | `T-PHASES-ARE-DISTINCT-OBJECTS` |
| **de-fornace**: *"planning is pure until an explicit commit"* | everything before `realize-form` is pure; `realize-form` is the single loud boundary | `realize-form` | `T-NO-EVAL-COMPILE-LOAD-PERFORM` |
| **de-fornace**: `slag` — rejected charges archived with their typed failure | every refusal carries category, code, path and a **snapshot of the offending datum** | `form-refusal-offending` | `T-MALFORMED-RETAINED` |
| **de-fornace**: `standing-laundering` — synthesis may not mint standing | **realization mints no claim, basis, capability or authority**; its operators are structurally incapable of it | operator allowlist | `T-REALIZATION-MINTS-NO-STANDING` |
| **de-fornace**: `verify-charge-integrity` — "changed after minting" | every object carries its **content-derived CD/0 identity**, recomputable at any time | `%form-identity` via `canonical-octets` | `T-CALLER-MUTATION-INERT` |
| **de-temperie**: `witness-failures` — bounded retention checked against a *named* witness | validation binds the **exact resolved operator descriptor identities**, not merely the visible names | `validated-form-operator-identities` | `T-SAME-LOOKING-DIFFERENT-ENVIRONMENT` |
| **de-temperie**: *"a historical receipt may survive after replay capability has died"* | a `form-realization-receipt` remains readable when its environment is gone; it is **evidence of a realization, never a re-realization** | receipt carries identities, not closures | (recorded; not a /0 tooth) |

### 1b. What is deliberately **not** extracted

- **Edit scripts, paths, budgets, shavings, replay.** de-torno's cutting office
  transforms a workpiece across turns. Form /0 has **one form and no history**;
  a transformation frontier is Form /1 at the earliest.
- **Convergence, conflict, alloy, headcount.** de-fornace's multi-proposal
  arbitration presupposes several proposals over one workpiece. Form /0 admits
  **one candidate at a time**.
- **Profiles, stages, scars, survival observations.** de-temperie is an ordeal
  over an artifact that already exists.
- **The workshop vocabulary itself.** No `charge`, `slag`, `shaving`, `firing`,
  `temper`, `ore`, `crucible` appears in `form0.lisp`. The Atelier is precedent
  and executable evidence, not a package dependency and not a thesaurus.
- **`toy-digest` / `canonical-string`.** Explicitly refused. The Atelier's own
  headers call the FNV digest *"pedagogical, not cryptographic"*. Form /0 uses
  `canonical-octets`, which is the governed CD/0 canonical encoding.

---

## 2. Representation boundary

**Form /0 does not parse textual Common Lisp.** The durable input boundary is
an **already-decoded CD/0 datum**.

Consequences, each enforced structurally rather than by convention:

| prohibition | how it is enforced |
|---|---|
| no `READ`, `READ-FROM-STRING`, readtable, reader macro | none appears in `form0.lisp`; `T-NO-READER` greps the loaded source |
| no `#.` handling needed | textual reader syntax never enters — the input is a datum object |
| no host symbol as durable operator or identifier | `propose-form` accepts a `datum` and nothing else; a host symbol is not a datum and is refused at the door |
| operators and holes use CD/0 **segmented identifiers** | `identifier-datum` with a fixed namespace |
| no implicit package lookup or interning | operator resolution is `equal-datum` against installed descriptors — never `intern`, `find-symbol` or `read` |
| no circular, dotted, or ambient host form | structurally impossible in CD/0 (§1) |

### 2a. Naming decision, and its reason

**`DECODE-FORM` is refused as a public name.** In this repository "decode"
already has an exact, occupied meaning: `lisp-plus-cd0:decode-exact`, which
turns **octets** into a datum. A `decode-form` sitting one layer above it would
read as *"turns bytes (or worse, text) into a form"*, which is precisely the
textual-parsing suggestion this section forbids.

The admitted operation does something different: it takes a datum that already
exists and **admits it as a candidate program under a closed grammar**. It is an
admission, not a decoding. Public name: **`PROPOSE-FORM`**.

`REIFY-FORM`, `INSTANTIATE-FORM`, `VALIDATE-FORM`, `REALIZE-FORM` and
`TRANSFORM-FORM` were also weighed. `INSTANTIATE-FORM`, `VALIDATE-FORM` and
`REALIZE-FORM` are adopted because each names exactly one transition.
`REIFY-FORM` and `TRANSFORM-FORM` are **not** used: nothing here reifies (the
datum is already a thing) and nothing transforms (that is Form /1).
**All public names remain candidate until closure.**

### 2b. The preserved chain

```
canonical datum  ≠  proposed form  ≠  instantiated form  ≠  validated form  ≠  realized result
     (CD/0)          admitted under      holes filled from     bound to exact      a datum, and
                     a closed grammar    an explicit env       identities          only a datum
```

Each transition returns a **new immutable object** carrying its own
content-derived identity, plus a receipt or a retained refusal. **No mutable
status slot advances one object through the phases** — there is no
`form-status` setter anywhere in the package, and `T-PHASES-ARE-DISTINCT-OBJECTS`
asserts the four objects are pairwise non-identical and independently readable.

---

## 3. Object family

Only the species the vertical requires:

| object | carries |
|---|---|
| `form-hole` | hole identity (CD/0 identifier), expected species keyword |
| `operator-descriptor` | operator identity (CD/0 identifier), arity, argument species, result species, **pre-sealed handler installed by the program** |
| `form-environment` | environment identity + version, grammar identity + version, operator descriptors, hole declarations, `sealed-p` |
| `proposed-form` | admitted datum snapshot, form identity, the hole identities it actually mentions |
| `instantiated-form` | substituted datum snapshot, its identity, the source proposed-form identity, the bindings used |
| `validated-form` | instantiated-form identity, grammar id+version, environment id+version, **resolved operator descriptor identities**, resource policy, validation receipt |
| `form-validation-receipt` | every bound component above, plus its own identity |
| `form-realization-receipt` | validated-form identity, instantiated-form identity, environment id+version, grammar id+version, operator identities actually invoked, result identity |
| `form-refusal` | category, code, path, offending datum snapshot, detail, own identity |

**No `EXPANDED-FORM` and no macroexpansion receipt.** The implementation
produced no evidence that either is unavoidable in /0 — there is no expansion
step in the chain at all. Macroexpansion is a successor frontier.

### 3a. `FORM-ENVIRONMENT` obligations

- explicitly constructed by the program (`make-form-environment`);
- **immutable after sealing** (`seal-form-environment` returns a new sealed
  object; an unsealed environment cannot validate);
- **local**, passed as an argument — there is no global registry, no special
  variable, no `defparameter` table anywhere in `form0.lisp`;
- keyed by **durable segmented identifiers** compared with `equal-datum`;
- limited to named operator descriptors;
- **resolving a name yields a handler and nothing else** — no evidence,
  standing, claim, basis, capability or authority is produced by resolution.

This local environment is offered as a **safe existence proof** for later
identity-to-object resolution work: it demonstrates that dereferencing an
identity is implementable **without** a global auto-registry, which is the exact
hazard the outside read named as *automatic evidence promotion*. It is not
itself a resolver for claims or receipts, and must never be widened into one.

---

## 4. Exact validation binding

`validate-form` binds, and `realize-form` re-checks, all five:

1. canonical **instantiated-form identity**;
2. **grammar identity and version**;
3. **sealed form-environment identity and version**;
4. the **exact resolved operator descriptor identities** (not the names as
   written — the descriptors actually found);
5. the **resource policy** (the CD/0 budget identity) that could change
   realization.

`realize-form` **refuses if any bound component differs**. In particular the
validator may not bless one form under one environment and permit execution of
the same-looking form under another: `T-SAME-LOOKING-DIFFERENT-ENVIRONMENT`
constructs two environments that are byte-identical in every respect except
their environment identity, validates under one, and requires realization under
the other to refuse.

All admitted form data is **snapshotted** by re-encoding through
`canonical-octets` and decoding back with `decode-exact`, so the stored tree is
provably independent of anything the caller retains.

---

## 5. Closed grammar and realization

Three productions, and no fourth:

```
form ::= [ id(lisp-plus-form0 : lit)  , <any datum> ]        ; literal
       | [ id(lisp-plus-form0 : hole) , <identifier datum> ] ; declared hole
       | [ id(lisp-plus-form0 : op / NAME) , form* ]         ; closed operator call
```

Sequencing and conditionals are **not** included: the inhabited example does not
require them, and the ruling says to include only what it requires.

### 5a. The operator set

Four existing public Lisp+ operations, all from the frozen, governed
`LISP-PLUS-CD0` package:

| operator identifier | underlying public operation | arity | result |
|---|---|---|---|
| `lisp-plus-form0:op/equal-datum` | `cd0:equal-datum` | 2 | boolean datum |
| `lisp-plus-form0:op/canonical-hex` | `cd0:canonical-octets` + `cd0:octets-to-hex` | 1 | string datum |
| `lisp-plus-form0:op/sequence-length` | `cd0:sequence-datum-length` | 1 | integer datum |
| `lisp-plus-form0:op/render-diagnostic` | `cd0:render-diagnostic` | 1 | string datum |

Each is deterministic for the fixture, non-effectful, already governed and
executable, incapable of granting live authority, and explicit about its
arguments. `render-diagnostic` is doubly safe: CD/0's own export list labels it
*"Diagnostic-only rendering, never an identity representation."*

Explicitly excluded: `PERFORM` · `EVAL` · `COMPILE` · `LOAD` · any `APPLY` or
`FUNCALL` of a function supplied by the candidate form · filesystem, process,
network or package mutation · capability minting · source-basis establishment ·
package-internal operators · unknown operators.

Realization dispatches **internally** to pre-sealed handlers stored in the
environment by the program. **A form may never supply a raw function object or
an arbitrary host operator** — a candidate datum has no family that could carry
one, and `T-NO-RAW-FUNCTION` asserts the refusal explicitly.

### 5b. No capability in /0

Per the ruling, /0 **does not require or mint a capability**. The live-authority
lane is incomplete and inventing authority semantics here would be exactly the
counterfeit this project exists to prevent. The realization boundary is still
explicit and loud — one exported symbol, one call site, one receipt — but its
initial operator set is non-effectful, so a capability would be ceremony with
nothing behind it.

**No contradiction arose.** Realization is meaningful without invented authority
because the operators compute over data and return data. Had it not been, this
work order would have stopped and reported instead.

**A model-emitted or adapter-emitted form remains a proposal.** It is never
thereby a claim, source basis, derivation basis, capability, authority object or
warrant. Nothing in `form0.lisp` constructs any Slice /0, /1, /2, Core /0 or
Kernel /0 object.

---

## 6. Holes

Holes are declared in the environment, identified by CD/0 segmented
identifiers, filled only from an explicit binding list supplied at
`instantiate-form`, checked against a declared expected species, **instantiated
exactly once**, immune to ambient lexical capture (there is no lexical
environment to capture — the substrate is data), and **non-recursive during
substitution**.

The one-pass rule, stated precisely: a value inserted into hole `X` may itself
contain a datum that looks like `[hole, X]`. **That inserted value is not
scanned again.** `%substitute` descends the *proposed* tree and splices bound
values in without descending into them.

Refused and retained: undeclared holes · unfilled holes · extra bindings ·
duplicate bindings · wrong-species bindings.

---

## 7. Inhabited vertical

`de-forma-dormiente/APPLICATION.lisp` — a **deterministic fake latent adapter**
emitting three candidate CD/0 trees. No live model or provider call is
authorized and none occurs.

| candidate | shape | expected disposition |
|---|---|---|
| **A** | structurally malformed — an unknown production | refused **before proposal admission**, retained |
| **B** | structurally lawful, names an operator absent from the sealed environment | refused at **validation**, retained |
| **C** | lawful, two declared holes, instantiated from an explicit environment, validated, realized | complete genealogy |

The complete genealogy is preserved and printed:

```
candidate datum → proposal or refusal → instantiation or refusal
                → validation or refusal → realization receipt and result
```

Candidates A and B are retained as **inspectable refusal records** — not
discarded, not reduced to printed conditions — and `T-REFUSALS-OUTLIVE-SUCCESS`
asserts they are still readable after C succeeds.

---

## 8. Required teeth

Planted-fault discipline where practical. The suite must exhibit each of:

host symbol refused at the durable boundary · unknown operator refused ·
forbidden consequential operator refused · malformed form retained as a refusal ·
undeclared hole refused · unfilled hole refused · extra binding refused ·
duplicate binding refused · wrong-species binding refused · one-pass
substitution prevents recursive capture · caller mutation after proposal cannot
alter the stored form · identical canonical forms under the same grammar and
environment share the intended identity · differing forms do not · same-looking
forms under different environment identities cannot reuse a validation ·
grammar-version mismatch refuses realization · environment-version mismatch
refuses realization · exact validated-form identity equals the form identity
named by the realization receipt · realization cannot invoke `EVAL`, `COMPILE`,
`LOAD`, `PERFORM` or an arbitrary host function · rejected candidates remain
inspectable after the lawful candidate succeeds.

---

## 9. Status and integration

```
candidate implementation
specification-frozen: no
adopted:              no
stranger audit:       owed, non-blocking
```

Location: `experiments/latent-lisp/mneme/language-form-0/` — a **new sibling
directory**. Nothing above it is modified.

It may become the **twelfth language floor** only if its runner is separately
named (`verify-form-floor.sh`), all previous eleven floors remain
byte-for-byte semantically unchanged, the banner states candidate /
self-consistency standing, and integration implies neither adoption nor freeze.

The bounded result is committed on the isolated branch `language-form-0` and is
**not merged to `main`.**

---

*— Claude Opus 5 (1M context), 2026-07-26, written before implementation.*
