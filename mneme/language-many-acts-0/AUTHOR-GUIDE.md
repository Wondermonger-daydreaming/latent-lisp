# MANY ACTS /0 — AUTHOR GUIDE

STANDING: standing in this lane attaches to immutable object identities and explicit
dispositions, never merely to filenames, directories, or descent from an adopted commit
(Owner Ruling 6 §3 B1; the rule and the adopted coordinates are in `MANY-ACTS-0-STANDING.md`).
This file's path confers no standing on its bytes in either direction. Nothing produced here
is independent verification (AP0 adoption Rider 2, binding): the phrases "independently
verified" and "independently validated" may not appear in any artifact of this lane.

Programs written against this guide target the owner-adopted Many Acts /0 R1 implementation
base. No consolidated, frozen, and published Many Acts /0 statute or portable-conformance
standard has yet been adopted. Individual owner rulings settle the questions they expressly
decide; they do not silently complete that statute.

**This guide plus the package's exports is the whole surface.** If something you need is not
here and not exported, it does not exist at /0 — it is not hidden, and there is no escape
hatch. That is the point: a closed authoring surface you can *finish reading*.

---

## 0. What a program is

A **program** is one S-expression, in one file, that a validator can refuse **before** any
consequential act runs. It sequences multiple executions of the adopted **One Act /0**
operation, with lexical binding, explicit outcome inspection, exact branching, and a
structured terminal result.

Three things are kept separate on purpose, and the separation is enforced rather than
recommended:

| | What it is | Where it lives |
|---|---|---|
| **SOURCE** | pure data — serializable, hashable, inspectable. May *name* authority slots and seats. | your `.lisp` data file |
| **ENVIRONMENT** | the live store, worlds, bootstrap authority, minting context, journaled grants, seat map, inputs | built by `make-ma0-environment` from **declarations** |
| **LIVE AUTHORITY** | journaled Capability /0 grants + process-local recognition | inside the environment, never in source |

No source form can contain, reconstruct, or be mistaken for a live capability. Sources cannot
hold host objects at all (V-DATA), and the environment door accepts **plans as data**, never
a live object.

---

## 1. The grammar

```
PROGRAM   := (ma0-program (:name STRING)
                          (:input (IDENT*))
                          (:authority-slots (IDENT+))
                          (:steps STEP+))

STEP      := (bind IDENT VEXPR)
           | (act IDENT (:arm ARM) (:authority-slot IDENT))
           | (derive IDENT (:seat SEATD))
           | (branch IDENT CLAUSE+ OTHER)
           | TERMINAL

CLAUSE    := (PATTERN STEP+)
OTHER     := (otherwise STEP+)
TERMINAL  := (result VEXPR)
           | (refuse (:code KEYWORD) VEXPR?)

PATTERN   := ATOMP | (:and ATOMP ATOMP+)
ATOMP     := (AXIS PVALUE)

VEXPR     := LITERAL | (ref IDENT) | (field IDENT AXIS) | (list VEXPR+)
LITERAL   := STRING | INTEGER | KEYWORD
ARM       := "A" | "B-L1" | "B-L2" | "B-R" | "C-i" | "C-ii" | "D"
SEATD     := STRING | (ref IDENT)
IDENT     := a symbol in the program's own flat namespace
```

A file holds **exactly one** form. It is read with `*read-eval*` bound to `NIL` and
`*package*` bound to the program namespace; it is never `load`ed and never evaluated by the
host.

### The heads, in full

`ma0-program` · `bind` · `act` · `derive` · `branch` · `otherwise` · `result` · `refuse` ·
`ref` · `field` · `list`. That is the closed world. Any other head is refused with code
`V-RETRY`, whose whole job is to make the refusal *name the law* — there is no `retry`, no
`resume`, no loop, no recursion, no `assert`, no `reconcile`, and no arithmetic or string
operation. Those absences are laws, not gaps waiting to be filled.

---

## 2. Binding: one flat namespace, no shadowing

A name is **defined** by `:input`, `bind`, `act`, or `derive`, and is visible from its
definition to the end of the program text — including inside branch arms selected later.
**A name may be defined exactly once anywhere in the whole text.** Redefining a name inside a
branch arm collides with the outer definition exactly as a top-level redefinition would, and
is refused (`V-BIND`). There is no shadowing in this language.

Bindings carry a **class**, and the classes are checked:

| Class | Bound by | Usable as |
|---|---|---|
| ordinary value | `:input`, `bind` | `(ref X)`, `(:seat (ref X))` |
| act-result | `act` | a `branch` head |
| derived outcome | `derive` | `(field X AXIS)`, a `branch` head |

`(ref X)` over a derived outcome is refused. `(field X …)` over an act-result or an ordinary
value is refused (`V-FIELD`). **An act-result's shape is inspected by `branch`, never
projected by field access** — that asymmetry is deliberate: an act-result is a *summary*, and
evidence is what the store says, not what a return value carried.

---

## 3. Authority

`:authority-slots` declares slot names. An `act` step names one:

```lisp
(act entry (:arm "A") (:authority-slot editor-grant))
```

- A slot name must be a declared **IDENT**. A string, a literal, an outcome, or an
  act-result in that position is refused statically (`V-RES-AUTH`) — the attempt dies before
  any act begins, so it has no footprint.
- A slot may **not** appear in value position. A slot is not a value.
- A slot name may not also name a binding.
- At each act step the evaluator retrieves that slot's occupancy **from the environment, by
  name, explicitly**. An unfilled slot signals `ma0-authority-slot-unfilled` and **no act
  begins**. There is no dynamic variable the evaluator could fall back to.

---

## 4. Acts

`(act ID (:arm A) (:authority-slot S))` executes one adopted One Act /0 arm. The act's
identity, authority decision, journal frames, and agreement verdict are **One Act /0's own**.

What gets bound to `ID` is an immutable **act-summary**, and it is **data**:

| Reader | Value |
|---|---|
| `ma0-act-summary-arm` | the arm string |
| `ma0-act-summary-act-id-hex` | the 64-character act-identity digest segment |
| `ma0-act-summary-disposition` | `:returned` `:refused` `:interrupted` `:host-fault` `:mint-refused` |
| `ma0-act-summary-class` | `:a` `:b` `:c-i` `:c-ii` `:d` `:unclassifiable` `:unpaired-f1` |
| `ma0-act-summary-verdict` | the agreement verdict string, or `NIL` on a mint-refused act |

**Each of the seven arms may appear at most once in a program text.** The adopted lane
consumes a runtime seat once per store and would refuse a second invocation at run time; this
lane refuses it *statically*, so the failure leaves nothing behind.

### The continuation rule

**A returned act does not end the program.** When an `act` step *returns*, its summary is
bound and **the next step runs — whatever the disposition is**, including `:refused`,
`:interrupted`, `:host-fault`, and `:mint-refused`. Disposition is *data you branch on* (§6),
never control flow: the evaluator consults no disposition to decide whether to continue. A
walk ends in exactly two ways — it reaches a terminal (§7), or a **condition** propagates out
of it (§7), which is not an outcome at all.

Here “continuation” means in-run sequencing after a structured act return. It does not mean
retry, resumption after a program terminal or propagated condition, or crash resume; §10 items
4 and 6 retain those prohibitions. A returned act-summary whose disposition is `:host-fault`
is data. A signaled host condition is not an act-summary and propagates out of the walk.

Two witnesses of the rule in the adopted record, and the one ceiling on it:

- P4 "vindemia" sequences **past a refused act** — arm B-L1 refused and sequenced past — and
  goes on to its later consequential step (`MANY-ACTS-0-R1-RETURN.md` §1).
- P2 β converts an act-level **mint refusal** into a structured program refusal *with the
  prior acts' history intact* (`MANY-ACTS-0-RETURN.md` §1.5): the program walked on to a
  terminal of its own choosing rather than being stopped by the act.
- The ordering ceiling is the only permitted form of the sequencing claim
  (`SEAL-ADDENDUM-2-PRESSURE-ACCOUNT-RULING.md`): *a program cannot initiate its dependent
  next act until the preceding One Act invocation has returned its adjudicated structured
  outcome.* Continuation is permitted **after** a return; it is never permitted before one.

So the shape of a program that must stop on a bad act is *branch, then terminate* — the stop
is something your text says, not something the act does to you.

---

## 5. Deriving evidence

`(derive ID (:seat SEATD))` binds a Surface /2 seat-outcome derived over the store's
validated prefix. **A derive appends nothing** — it is a pure read, and the suite witnesses
that as a prefix-length invariant, not as an assurance.

`SEATD` is a **declared name**, resolved through the environment's seat map to a canonical
runtime seat. Write `"s-entry"`, not `"prima"`: the program should not know which fixture
seat it is reading, and the same text should be able to read a different seat under a
different environment. `(ref X)` in seat position lets the *input* choose.

A seat name absent from the environment's map is an environment refusal.

---

## 6. Branching

```lisp
(branch outcome-or-act-result
  ((:execution :absent)                              (result 1))
  ((:and (:execution :settled) (:evidence-class :none)) (result 2))
  (otherwise                                          (refuse (:code :unexpected))))
```

- Clauses are tested in **textual order**; the **first holding** clause is selected;
  `otherwise` is selected iff none holds; **exactly one arm's steps run**.
- Every branch needs at least one pattern clause and exactly one trailing `otherwise`.
- Duplicate clause patterns are refused — including two conjunctions that differ only in the
  order of their atoms, because patterns are canonicalized before the comparison.
- A conjunction may not name one axis twice.

### The matching law

An atom holds iff the facet's **standing is `:present` and the facet value is exactly the
pattern value**. An absence-keyword atom (`:absent-from-evidence`, `:malformed-in-evidence`)
holds iff the standing is exactly that keyword. `:and` holds iff every atom holds.

**No truthiness participates anywhere.** A facet being non-`NIL` holds nothing.

### The closed axes

Over a **derived outcome**:

| Axis | Values |
|---|---|
| `:execution` | `:absent` `:prepared-only` `:crossed-unsettled` `:uncertain-unresolved` `:settled` `:reconciled` |
| `:provenance` | `:live` `:derived-recovery` `:none` |
| `:evidence-class` | `:refusal` `:closure` `:projection` `:control-outcome` `:uncertain` `:reconciled` `:none` |

Over an **act-result**: `:disposition` and `:class`, values as in §4.

There is deliberately no `:success`, `:truth`, `:retry-safe`, or `:cost` axis. If you find
yourself wanting one, the thing you want to say is probably not something the record can
support.

### What the arms actually derive at /0 — read this before writing a pattern

These are **observed**, from runs, not inferred from a table:

| After | `:execution` | `:evidence-class` | `:provenance` |
|---|---|---|---|
| nothing (untouched seat) | `:absent` | `:none` | `:none` |
| a completed arm **A** | `:settled` | `:none` | `:none` |
| a completed arm **C-i** | `:reconciled` | `:reconciled` | `:none` |

⚠ **A completed C-arm derives `:reconciled`, never `:uncertain-unresolved`.** The adopted
act's own law-chain contains the reconciliation pair, so the uncertainty is structured,
frozen, and adjudicated *inside* the act. A program cannot observe an unresolved uncertainty
at /0 — it observes the record of one, which is what `:reconciled` means here. Gate on
`:reconciled` if you want "this duty went through an uncertainty".

---

## 7. Terminals

Every complete evaluation ends in exactly one terminal, and the last step of `:steps` and of
every branch arm must be one (or a branch all of whose arms are). Steps after a terminal are
refused as unreachable code.

- `(result VEXPR)` → disposition `:completed`, the payload in `ma0-result-value`.
- `(refuse (:code KEYWORD) VEXPR?)` → disposition `:refused`, the code in
  `ma0-result-refusal-code` and the optional payload in `ma0-result-refusal-detail`.

**A refusal is a lawful program outcome, not a failure.** The journal is intact, the exit is
orderly, the runner returns 0.

**"Code" names two distinct populations, of two distinct datatypes** (owner ruling, PS/0
Cluster Sitting 1, Disposition 4, 2026-08-12): a **program refusal code** is a **KEYWORD**
— authored by the program in its `refuse` terminal, read via
`ma0-result-refusal-code` on the result. A **lane condition code** is a **STRING** — e.g.
`"V-SHAPE"` — authored by the lane itself, read via `ma0-refusal-code` on
the signalled condition. The two are different Lisp types and **never compare equal**; an
observation format that compares a keyword to a string and reports agreement is defective.
From this ruling forward, public text in this lane must not use the word "code"
unqualified — say *program refusal code* or *condition code*. (Whether either population
is a scored conformance observable is a separate, open owner question; this paragraph
states types, not scoring.)

**Scoring** (owner ruling, PS/0 Cluster Sitting 2, Disposition III-1, 2026-08-12 —
answering the question the previous paragraph left open): **program refusal codes are
normative conformance observables.** A conformance comparison includes the program refusal
code, at its normative identity (the upcased keyword, per GRAMMAR §1b). **Lane condition
codes are diagnostic only and are excluded from conformance comparison** — this exclusion
is written law, not a format default. Two things this ruling deliberately does NOT do:
it does not freeze the program-code vocabulary — *normative as output is not the same
proposition as constitutionally closed as a set*; the population is program-authored and
open by definition, and a future genuinely new program refusal code is conformance-visible
without any closed-enum implication — and it does not publish the lane's condition-code
list as a normative table.

**An error is not an outcome at all.** A validator refusal, an environment refusal, an
adopted-lane condition your program did not branch on, or a host fault **propagates as a
condition** and is never converted into `:completed`. The evaluator installs no handler, and
that absence is the mechanism.

---

## 8. Running one

```lisp
(asdf:load-system "lisp-plus/many-acts-0")

(let* ((program (lisp-plus-many-acts0:ma0-validate #p"my-program.lisp"))
       (environment
         (lisp-plus-many-acts0:make-ma0-environment
          :root  run-root                       ; a directory OUTSIDE the subject tree
          :arms  '("A")
          :grants '((:slot "editor-grant" :arm "A"))
          :revocations '()
          :seat-map '(("s-entry" . "prima"))
          :inputs '(("manuscript-label" . "codex-sangallensis"))))
       (result (lisp-plus-many-acts0:ma0-run-program program environment)))
  (lisp-plus-many-acts0:ma0-result-disposition result))
```

`ma0-validate` takes a **pathname** (read through the lane's own reader) or an already-read
form.

### The environment declarations

| Key | Shape | Meaning |
|---|---|---|
| `:root` | pathname | run root, **outside the subject tree**; you create it and you remove it |
| `:arms` | list of arm strings | the arms this environment admits |
| `:grants` | list of `(:slot STRING :arm STRING)` | journal one Capability /0 grant for that arm's seat; record the slot as occupied for it |
| `:revocations` | list of `(:arm STRING)` | journal a revocation, **after every grant** |
| `:seat-map` | alist `(declared-name . runtime-seat)` | resolves `derive` seats; every runtime seat is checked against the adopted fixture table |
| `:inputs` | alist `(name . STRING\|INTEGER\|KEYWORD)` | values for the program's `:input` names |

Slot and input names are matched case-insensitively against the source's identifiers, so
`editor-grant` in a source and `"editor-grant"` in a plan are the same name.
**"Case-insensitively" means exactly Common Lisp `string-upcase`** (owner ruling, PS/0
Cluster Sitting 1, Disposition 1's by-reference form, 2026-08-12): simple, per-character
case conversion by reference to the standard — **not** full Unicode case mapping and
**not** casefolding (`ß` stays `ß`; no `SS` expansion; no locale rules). An implementation
in another substrate must reproduce the simple conversion, not its host's default.

`make-ma0-environment` runs One Act /0's environment pre-flight first: if a process-killing
environment variable is set, the run is **VOID** — no store is created, and a void is not a
failure of your program.

### Reading the result

`ma0-result-p` · `-program-name` · `-disposition` · `-value` · `-refusal-code` ·
`-refusal-detail` · `-act-summaries` (ordered, oldest act first) · `-store-id`.

Every list-valued reader hands out a **fresh copy**; every slot is read-only. Mutating what a
reader returned mutates your copy and nothing else.

---

## 9. Running the shipped programs and the suite

```sh
./ma0-run.sh              # the whole suite, one image per scenario
./ma0-run.sh --list       # the scenarios
./ma0-run.sh p1           # one scenario, one image
```

The green sentinel is `ma0-selftest: <N> checks, 0 failures`, printed on that path and no
other. `MA0_SELFTEST_PLANT_FAULT=1` infects one check, so you can see the harness fail before
you trust it passing.

---

## 10. The honest caps

Read these before you plan anything on this lane.

1. **Seven sealed arms, and no fixture door.** The constituent-act inventory at /0 is the
   seven adopted One Act /0 arms of the *scriba / inscribere* specimen. There is no public
   fixture constructor and this lane mints none. Every consequential frontier crossing at /0
   is a specimen-shaped inscription. **Domain variation at /0 is program-level** — inputs,
   decision structure, carried data, refusal policy, a causal skeleton no single arm has.
   Act-level domain variation needs a future lane with an adopted fixture-authoring door, and
   this lane does not claim one.

2. **One arm per program.** A program cannot invoke the same constituent act twice. This is
   the adopted lane's seat-consumption law inherited as a language property, and it aligns
   with the no-blind-retry law.

3. **One program per image.** `make-ma0-environment` sets One Act /0's five run-state
   specials, and each arm consumes its seat once per store. Two programs in one image collide
   — and the collision is *witnessed*: the second run's act is refused by the adopted lane,
   and the condition propagates.

4. **No retry, and no continuation.** A program that meets a stopping condition refuses. The
   lawful continuation for an uncertainty lives outside the program and is not invocable as
   program syntax.

5. **Not a transaction system.** No rollback, no compensation, no exactly-once, no atomicity
   across acts.

6. **No crash resume.** Same-image orchestration only. A killed runner leaves every completed
   constituent act durably journaled under One Act /0, and the **program** has no
   continuation story at /0. This is stated plainly because it is the thing most likely to be
   assumed.

7. **A revocation declared in the environment lands at environment-construction time**, not
   between two acts. There is no program construct that could trigger one mid-run. The
   pressure a revocation exercises is real; the *timing* is declared fixture.

8. **What a green run claims.** *This program text, accepted by the closed validator,
   evaluated under this declared fixture environment, produced this result with these acts'
   journal evidence.* It claims nothing about other environments, external reality's
   determinism, retry safety, independent usability, or any question the underlying lanes
   left open. Determinism means **evaluator determinism under declared fixtures**.

9. **The composition is a re-composition, and its concordance is TESTED — at a stated
   scope.** This lane owns `ma0-complete-act`, an act-completion routine built from exported
   parts, honouring the adopted composer's law-chain. Divergence from the adopted composer is
   the lane's most serious possible defect, and the concordance teeth that test it **have
   been built and run.** `ma0-concordance.lisp` drives an MA0-composed act and the canonical
   `run-all-arms` act in separate images over separate stores and compares them across **all
   seven adopted arms × 18 enumerated facets = 126 comparisons**; the adopted R1 record
   reports **7 arms / 126 facets / 0 divergences** (`MANY-ACTS-0-R1-RETURN.md` §2 coverage
   closure; `MANY-ACTS-0-R1-ADOPTION-RECORD-2026-08-10.md` §4). The comparator also carries
   its own planted-divergence tooth (teeth section 4b), so it has been shown *able* to report
   a divergence rather than merely never having reported one.

   **What that still does not say — and this half of the cap is unchanged.** The lane's own
   suite (`./ma0-run.sh`, `ma0-selftest`) does **not** run the concordance teeth: a green
   suite says the laws in the suite hold and says nothing about composer concordance. Run
   `./ma0-concordance.sh`, or the full `./ma0-teeth.sh`, for that. Agreement is over the 18
   enumerated facets and no others, on this substrate, under declared fixtures. Nothing here
   is independent verification, and none of it is adopted usability.
