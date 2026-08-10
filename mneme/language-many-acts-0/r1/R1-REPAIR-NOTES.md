# MANY ACTS /0 — R1 REPAIR NOTES

STANDING: CANDIDATE. Nothing here is adopted, accepted, or on a governing
floor; nothing here is independent verification (AP0 Rider 2, binding). This
round performed no merge, no publication, no adoption, and no stranger audit.
Repairs: SUTOR (Claude Opus 5, subagent), 2026-08-10, under the owner's R1
ruling.

⚠ THIS FILE IS NOT SEALED AND AMENDS NOTHING THAT IS. The seal set —
`MANY-ACTS-0-{PRESSURE-REPORT,CONTRACT-CANDIDATE,GRAMMAR,FAILURE-MATRIX}.md`,
the P1/P2 briefs, `SEAL-ADDENDUM-1` — is untouched by this round, as is
`MANY-ACTS-0-RETURN.md` and its findings registry. Where a repair needed a
policy stated in prose, it is stated **here**, beside the code comment that
carries it.

---

## 1. What R1 changed, by defect

| | Defect | Repair | Witness |
|---|---|---|---|
| D1 | `copy-tree` shared mutable string leaves across every public boundary | `%ma0-own` (ma0-structures.lisp §2c), applied in both directions at every boundary | `r1/D1-ownership.lisp` |
| D2 | branch alternatives validated against one mutable binding table | two tables: cumulative `defined`, per-path `bindings` | `r1/D2-branch-binding.lisp` |
| D3 | the validator did not terminate on circular cons structure | EQ-visited spine walk; **a lawful source is a TREE** | `r1/D3-circular-source.lisp` |
| D4 | a second environment silently redirected the first's acts | environment **generation**, checked before the first consequential act | `r1/D4-env-crosswire.lisp` |
| D5 | the generation advanced *before* the fallible construction steps, so a failed construction killed a working environment; and the default printer exposed the counter and the live store | a **commit point** after every fallible step (property 2), plus a `:print-object` | `r1/D5-generation-seam.lisp` |

Each witness is one script. It produced the red transcript in
`r1/pre-repair/` **before** the repair and the green one in `r1/post-repair/`
after. Only the exit code moved. **The pre-repair transcripts are evidence and
are never regenerated or deleted.**

---

## 2. The D3 shared-substructure policy — STATED, because code alone cannot state it

> **A lawful MA0 source is a TREE.** A cons cell reached a second time during
> validation is refused — whether the second reach is a **cycle** (the cell is
> its own ancestor) or merely **shared acyclic substructure** (a DAG).

Refusal is the existing **V-SHAPE** law with a distinct message; no refusal
code and no condition type was minted, and the sealed grammar is unchanged.

**Why the stricter of the two available rules, on the merits:**

1. **It costs nothing lawful.** The lane's own mouth is `%ma0-read-source`,
   and a reader at its default settings builds a tree — it cannot produce
   sharing at all. Shared structure can only arrive through the already-read
   FORM door, which is the hostile path.
2. **It is one sentence.** An author can hold "a source is a tree". A rule that
   is sound but unstatable is worth less than one that is both.
3. **It keeps the declared node bound honest — and it stops R1's own repair
   from opening a hole.** Under a visited table that *accepts* DAG sharing, the
   node bound counts **visits**, while `%ma0-own` (the D1 repair) copies the
   **expansion**. A source of sixty shared conses can expand to 2³⁰ nodes on
   the way to becoming the lane's own copy. Accepting sharing would have
   converted a fixed bound into an exponential one **in the same round that
   introduced the copier**. Refusing sharing makes the bound count what a copy
   will actually allocate.

Reason 3 is the decisive one. It is a fact about the interaction of two
repairs, and it is the reason this policy is not merely a preference.

Tested, not merely asserted: `r1/D3-circular-source.lisp` D3-2b and the suite's
`R1/D3 acyclic SHARED substructure is refused by the same law` plant an
**acyclic** DAG and require the refusal.

---

## 3. The D2 tension, and how it was resolved — FLAGGED FOR THE CHAIR

The R1 ruling's §3 fixture list includes:

> "the same local name used lawfully and independently in separate
> alternatives"

**This conflicts with the sealed grammar.** GRAMMAR §2's V-BIND says every
IDENT is "defined exactly once … duplicate definition anywhere (**including
across branch arms vs outer scope**) is refused — NO SHADOWING exists in this
language." A name defined in two alternatives is a duplicate definition across
branch arms, and the sealed law refuses it.

**Resolved conservatively: the sealed law stands.** Making that fixture green
would require weakening V-BIND, which is grammar growth — forbidden this round.
The fixture item is therefore satisfied **as an exhibited refusal**:

- `r1/D2-branch-binding.lisp` probe **D2-4** shows the refusal
  (`MA0-BINDING-REFUSED [V-BIND]`), and
- the suite check `R1/D2 the sealed define-once law still spans sibling
  alternatives` holds it in the regression floor.

**Two independent reasons the resolution is not a judgement call:**

1. The suite already carried, **before R1**, a green fixture asserting exactly
   this refusal: `W-V-BIND no shadowing across branch arms`. Weakening V-BIND
   would have turned an existing green fixture red.
2. The refusal is what the sealed text says. R1 repairs behaviour that
   contradicts the grammar; it does not repair the grammar.

**→ For the chair's RETURN to state plainly:** the ruling's fixture item is
met as *"refused by the sealed no-shadowing law, exhibited"*, not as
*"accepted"*. If the chair intends the name to be independently reusable per
alternative, that is a **grammar change** and needs its own round.

## 3b. The post-branch definite-boundness question is VACUOUS

The ruling anticipated an all-paths problem: a name bound in only *some*
alternatives must not be treated as definitely bound *after* the branch.

**There is no "after the branch".** V-TERM requires every branch arm to end in a
terminal; `%ma0-check-steps` refuses any sequence that does not, and then
refuses any step following one that closed. A branch therefore always closes its
sequence, and no step can follow it — which is what GRAMMAR §1 already states
as the single-shape law ("fall-through across a branch is refused").

GRAMMAR §3's sentence — a name is visible "from its definition to the end of the
program text (including inside subsequently selected branch arms)" — governs
names defined **before** a branch being visible **inside** its arms. That is
sound on every path, because such a name is bound on every path that reaches the
branch.

**No all-paths analysis was written, and none is needed.** The vacuity is
**witnessed, not assumed**: the suite fixture `R1/D2 THE VACUITY WITNESS no step
may follow a branch (V-TERM)` requires the refusal.

---

## 3c. The generation seam (owner's pre-freeze gate) — PROPERTY 2

The owner accepted the generation design in principle subject to executable
proof of its **construction-failure semantics**, requiring one of three lawful
properties (verbatim text: `R1-GENERATION-SEAM-FINAL-CHECK.md`).

**Answered executably, and the first answer was RED.** `r1/D5-generation-seam.lisp`
found that **property 1 does not hold: the post-increment window is reachable
from the public API.** A declaration of 70 000 input rows passes every plan
check — each row is `(STRING . INTEGER)` — and then refuses `MA0-OWN-BOUND`
inside the ownership walk, which under the original ordering ran *after* the
counter had moved. Observed (`r1/pre-repair/D5-red.txt`):

- the generation advanced 1 → 2;
- the previously-good environment **A went STALE**;
- the five specials were left pointing at B's root.

**A failed construction of B destroyed a working A.** That is worse than
property 3's "no usable environment": an unrelated caller error takes a live
environment away.

**Isolated, not asserted.** Five other construction failures — an arm outside
the sealed seven, a grant naming an undeclared arm, a bad seat map, a non-atom
input value, a revocation for an undeclared arm — all left A current, its root
byte-unchanged, the specials on A, and the mint counter unmoved. **Exactly one
of six public-API failure modes reached the window.**

### The repair: a COMMIT POINT (property 2)

All fallible construction now runs first — the grant and revocation journaling
(which uses the **local** `store`, never the special, and that is what made the
move possible) and the `%ma0-own` calls (which can refuse). Then, and only
then:

```
;; THE COMMIT POINT — nothing below can signal.
(incf *ma0-environment-generation*)
(setf … the five specials …)
(%make-ma0-environment … :generation *ma0-environment-generation* …)
```

An `incf` of a bound integer, five assignments, one structure allocation.
**Property 2 holds as a property of where those forms sit**, not as a promise
about them. The counter and the specials move together and in that order, so
there is no instant at which the specials name one environment and the
generation another.

**The success path is unchanged, and that is shown rather than claimed.** For
identical declarations, before and after the reordering:

```
store/EVENTS.pj0  sha256 9360794514848d200b4df2fa9e8f3d516c268b70279872052ee684a2d6429b0e   (both)
store/EVENTS.pj0  2362 bytes ·  JOURNAL-META.pjs 545 ·  world-apply/CELLS.txt 85   (both)
store-id          pj0-store:b9afe334…65760                                          (both)
```

### The second red: exposure by the default printer

`D5-3` found that the default structure printer emitted **every** slot of an
environment — the private `GENERATION`, and with it the **live** journal store,
bootstrap authority and minting context — to any `~s` anywhere. Repaired with a
`:print-object` that prints `#<MA0-ENVIRONMENT pj0-store:…>` inside
`print-unreadable-object`, so a printed environment cannot be read back into
one. The store-id is already public, so this **adds no reader and removes
several**. Printing a *result* was already clean.

### What was already green, recorded so the repair is not credited with it

`D5-4`: **both** `ma0-run-program` and `ma0-complete-act` already refused a
stale environment before any act construction, capability activity, journal
mutation or world mutation — both roots byte-unchanged across each refusal,
mint counter unmoved, installed environment still usable. `ma0-complete-act`
is handed a plist that would certainly crash if the seam had not fired first,
which is what proves the check precedes every use of the result argument.

### Where each proof lives, and why it is split

| Proof | Where | Why there |
|---|---|---|
| construction-failure semantics | `r1/D5-generation-seam.lisp` | needs several environments and real stores |
| no exposure | same | needs the export census and a printed object |
| entry-point ordering + zero footprint | same | needs two environments and byte snapshots |
| monotonic · never reset · never reused | **the suite** | the counter is package-internal, so a public-only witness sees only its shadow; the suite is in-package and can read the integer |

The suite half also carries a **source gate** — exactly one increment site, and
nothing that decrements, resets, rebinds or unbinds the counter — with two
planted violations proving the detector fires before its clean pass is
reported.

### The fixture's own constraint, worth carrying forward

**A One Act identity is minted PER IMAGE, not per store.** Running one arm
twice in a single image raises `ACT-IDENTITY-TAKEN [ACT-9b]` however many
separate environments and stores are involved. `D5` therefore spends a
*different* arm at each of the three places it must prove an environment RUNS
(A, B-L1, C-i) and keeps result objects rather than re-earning them. Two drafts
of the fixture died on this before it was understood.

---

## 4. Recorded, not repaired — a store identifier cannot discriminate stores

Observed while capturing `r1/pre-repair/D4-red.txt`: a journal store's
identifier is derived from its **content**, so two environments built from the
same declarations carry the **same** store-id string. The identifier cannot
distinguish two stores, and therefore could never have revealed the crosswire on
its own.

This is a property of the predecessor's identity scheme, not of this lane, and
R1 did not touch it. It is stated in `ma0-environment-store-id`'s docstring, in
`%ma0-check-environment-current`, and in the stale-environment refusal message,
so that no reader infers a discriminating power the string does not have.

---

## 5. Two defects R1 introduced and caught in the same round

Recorded because a repair round that reports only the defects it was sent to fix
is reporting half of what happened.

1. **`%ma0-own` recursed on the CDR**, making stack depth equal list length; a
   long flat list exhausted the control stack before the walk budget could
   refuse. **Found by its own budget tooth** on the tooth's first run. The spine
   is now copied iteratively; recursion descends only into CARs, so depth tracks
   nesting, which V-SHAPE already bounds.
2. **`%ma0-expect-refusal` builds a scratch filename out of the check label**,
   so a fixture labelled `R1/D2 …` produced a path with a nonexistent directory
   component and killed the suite mid-section with a `SIMPLE-FILE-ERROR` —
   reporting `0 checks, 0 failures` and withholding the sentinel. Hardened by
   `%ma0-scratch-basename`.

---

## 6. Where the R1 files live

```
r1/
├── D1-ownership.lisp          the four witnesses; each is both the red and the
├── D2-branch-binding.lisp     green witness for its defect
├── D3-circular-source.lisp
├── D4-env-crosswire.lisp
├── D5-generation-seam.lisp    the owner's pre-freeze gate on the generation
├── capture.sh                 writes a transcript with command, date -u, and
│                              what the run proves
├── run-r1-program.lisp        one traversal program, one image
├── ma0-coverage.sh            the seven-arm traversal table, harvested
├── programs/
│   ├── r1-bl1-traversal.lisp  arm B-L1, end to end
│   └── r1-d-traversal.lisp    arm D, end to end
├── pre-repair/                ⚠ EVIDENCE. Never regenerated, never deleted.
└── post-repair/               the same scripts, after the repairs
```

Teeth sections 8–13 run all of it. The suite carries the in-image half
(sections `R1/D1`, `R1/D2`, `R1/D3` of `ma0-selftest-suite.lisp`); the
environment-side ownership boundary and the zero-footprint stale-environment
refusal stay in the r1 witnesses, because both need more than one image or a
real store.
