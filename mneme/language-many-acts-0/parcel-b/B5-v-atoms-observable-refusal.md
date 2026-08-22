# PARCEL B — ITEM B5: `V-ATOMS` IS NAMED LAW WITH NO OBSERVABLE CODE

STANDING: CANDIDATE PROPOSAL. Nothing here is adopted, accepted, or in force; nothing here
is independent verification (AP0 adoption Rider 2, binding). **This item proposes law and
implements nothing.** It touches a refusal code, which is language-observable surface and
one of the 28 registered deficits; nothing in this lane may change it except an owner ruling.

Jurisdiction: OWNER RULING 5 (2026-08-10) §3. This is item 5 of 8.

---

## 1. THE GAP

`MANY-ACTS-0-GRAMMAR.md:46–53` states V-ATOMS as one of the closed validator's named laws:

> ```
> - **V-ATOMS**: atoms are drawn from: the closed head/keyword vocabulary above; STRINGs;
>   INTEGERs; KEYWORDs from the closed pattern grammar or user `:code` keywords; and bare
>   IDENT symbols. **Every symbol must be either a grammar head, a closed-grammar keyword,
>   or an IDENT whose home package is the validator's designated program-symbol package**
>   — package-internal symbols of ANY other package are refused (V-PKG). `#.` never
>   survives to the validator: sources are read with `*read-eval*` bound to NIL by the
>   loader (V-READ), and a source containing a function object, closure, structure, or any
>   non-listed atom type is refused (V-DATA).
> ```

**No refusal ever carries the code `V-ATOMS`.** Mechanically, on this branch: the lane's
sources contain twelve distinct emitted code strings and the grammar names thirteen laws.

Emitted — mechanical count of `ma0-refuse '<condition> "CODE"` **emission sites** across the
lane's `*.lisp` (not of quoted-string occurrences, which would also count the selftest's
expectations):
`V-SHAPE` 28 · `V-PATTERN` 8 · `V-RETRY` 5 · `V-TERM` 4 · `V-FIELD` 4 · `V-BIND` 4 ·
`V-AUTH` 4 · `V-DATA` 3 · `V-ARM` 2 · `V-RES-AUTH` 1 · `V-READ` 1 · `V-PKG` 1 —
**twelve codes, 65 sites. `V-ATOMS`: zero sites.**

Named in `MANY-ACTS-0-GRAMMAR.md`: the same twelve, **plus `V-ATOMS`.**

The three places `V-ATOMS` does appear in code are comments describing which laws a walk
enforces, never a refusal:

- `ma0-structures.lisp:48` — `ma0-source-refused          ; V-SHAPE V-ATOMS V-READ V-DATA V-PKG`
- `ma0-validate.lisp:95`  — `;;; §3 — V-SHAPE / V-ATOMS / V-DATA / V-PKG: the total atom and shape scan.`
- `ma0-validate.lisp:140` — `"V-DATA / V-ATOMS / V-PKG / V-SHAPE, in ONE total walk, …`

The behaviour V-ATOMS describes **is** implemented, at `ma0-validate.lisp:158–182`
(`%ma0-scan-atoms`'s `atom-check`): a non-admitted atom type refuses with `V-DATA`; an
unlawfully homed symbol refuses with `V-PKG`; keywords, strings, integers and lawfully homed
symbols pass. So V-ATOMS is not an unimplemented law. It is an **umbrella name for a
partition whose members are observable while the umbrella is not** — and the grammar does not
say so.

The handoff entry, `MANY-ACTS-0-PARCEL-A-RETURN.md:729–731`:

> **B5 — `V-ATOMS` is named in `MANY-ACTS-0-GRAMMAR.md` §2 with no observable code.** Already
> on the owner's Parcel B list; deliberately untouched.

"Already on the owner's Parcel B list" refers to Owner Ruling 1 §Ruling 5, Parcel B —
Constitutional completion, which lists among the things Parcel B must contain explicit
proposed rulings and redlines for: *the reader grammar · refusal-code vocabulary and
datatypes · the law→condition-family→code table · the three numerical bounds · `V-ATOMS` ·
…* and closes: *"Do not disguise Parcel B as documentation cleanup. It legislates previously
unwritten law."*

### 1.1 Why this cannot be a wording fix

A refusal code is **observable to a program's author**: `AUTHOR-GUIDE.md:252–253` documents
`ma0-result-refusal-code` as part of the public surface, and the selftest suite asserts exact
code strings at six sites — `"V-DATA"` at four (`ma0-selftest-suite.lisp:159, 162, 165, 168`,
the `W-V-DATA` checks) and `"V-PKG"` at two (`:173, 176`, the `W-V-PKG` checks). Any
option that makes `V-ATOMS` observable changes what a conforming implementation must emit —
i.e. it legislates the refusal-code vocabulary, the deficit-register item this belongs to.
Any option that retires the name changes the published statute's list of laws. Neither is a
typo repair.

---

## 2. THE PROPOSED RULING — three options, none chosen

### OPTION 1 — RETIRE THE NAME (V-ATOMS is not a law; it was a heading)

Candidate text:

> **V-ATOMS (owner ruling, 2026-08-__).** `V-ATOMS` is **not** a law of Many Acts /0 and
> never was. The atom vocabulary is enforced by two observable laws already in the code —
> **V-DATA** (an atom of a non-admitted type) and **V-PKG** (a symbol whose home package is
> not the program namespace or this lane's package) — with the spine and bounds enforced by
> **V-SHAPE**. The name `V-ATOMS` is struck from the grammar and from the three comment
> sites that carry it. At /0 the closed refusal-code vocabulary is exactly the twelve
> emitted codes, and **no name may appear in a law list unless some refusal carries it.**

**Consequence.** The statute's law list and the emitted vocabulary become identical, which is
a property a portable implementation can be tested against. Cost: an author who has read the
grammar loses a name that usefully groups the atom rules, and three code comments change
(comment-only, no runtime output moves). The last sentence is the load-bearing one: it is a
general rule, and adopting it commits future rounds to it.

### OPTION 2 — MINT THE CODE (V-ATOMS becomes observable)

Candidate text:

> **V-ATOMS (owner ruling, 2026-08-__).** `V-ATOMS` becomes an **observable refusal code**.
> The atom-type refusal now emitted as `V-DATA` is re-emitted as `V-ATOMS`; `V-DATA` is
> retained for the read-time data refusals it also names, or retired, as the same ruling
> specifies. The selftest expectations that assert `V-DATA` for atom-type refusals change to
> `V-ATOMS` in the same commit.

**Consequence.** The grammar's law list is honoured literally. But: this changes a
**language-observable** fact. Any program or harness that inspects `ma0-result-refusal-code`
or catches `ma0-source-refused` and dispatches on its code sees different bytes after the
change; four selftest checks change their expected string; and the change is exactly the kind
the 28-place register was opened to adjudicate as a set rather than one code at a time.
**The drafter's caution, stated as caution and not as a choice:** minting one code
piecemeal, ahead of the refusal-code-vocabulary ruling the register contemplates, risks
deciding by precedent what should be decided as a table.

### OPTION 3 — KEEP IT AS A DECLARED NON-OBSERVABLE UMBRELLA

Candidate text:

> **V-ATOMS (owner ruling, 2026-08-__).** `V-ATOMS` is retained in the grammar as an
> explicitly declared **umbrella**: a name for a group of rules, never a refusal code. The
> grammar is amended to say so in the rule itself, and a general law is adopted:
> **every name in the validator's law list is marked either OBSERVABLE (some refusal carries
> it as `ma0-result-refusal-code`) or UMBRELLA (it names a group and is never emitted); an
> unmarked name is a defect.** At /0, `V-ATOMS` is the only UMBRELLA name; the other twelve
> are OBSERVABLE.

**Consequence.** Nothing observable changes, no code is minted, and the statute gains a
distinction it will need anyway when the refusal-code table is ruled — a portable
implementation is told exactly which names it must emit and which are prose. Cost: the
grammar carries a two-tier vocabulary that a reader must hold in mind, and "umbrella" is a
category later rounds could abuse to shelter other unemitted names.

---

## 3. THE REDLINE (exact, per option — none applied)

### 3.1 OPTION 1 — retire

BEFORE (`MANY-ACTS-0-GRAMMAR.md:46–47`):

```
- **V-ATOMS**: atoms are drawn from: the closed head/keyword vocabulary above; STRINGs;
  INTEGERs; KEYWORDs from the closed pattern grammar or user `:code` keywords; and bare
```

AFTER:

```
- **V-DATA / V-PKG (the atom vocabulary)**: atoms are drawn from: the closed head/keyword
  vocabulary above; STRINGs; INTEGERs; KEYWORDs from the closed pattern grammar or user
  `:code` keywords; and bare
```

BEFORE (`ma0-structures.lisp:48`):

```
            ma0-source-refused          ; V-SHAPE V-ATOMS V-READ V-DATA V-PKG
```

AFTER:

```
            ma0-source-refused          ; V-SHAPE V-READ V-DATA V-PKG
```

BEFORE (`ma0-validate.lisp:95`):

```
;;; §3 — V-SHAPE / V-ATOMS / V-DATA / V-PKG: the total atom and shape scan.
```

AFTER:

```
;;; §3 — V-SHAPE / V-DATA / V-PKG: the total atom and shape scan.
```

BEFORE (`ma0-validate.lisp:140`):

```
  "V-DATA / V-ATOMS / V-PKG / V-SHAPE, in ONE total walk, with the declared
```

AFTER:

```
  "V-DATA / V-PKG / V-SHAPE, in ONE total walk, with the declared
```

*All four are text-only; none is inside an emitted string, so no runtime output moves and no
gate expression changes. The lane selftest, teeth, P3, P4 and One Act would still be re-run
serially to prove exactly that.*

### 3.2 OPTION 2 — mint

BEFORE (`ma0-validate.lisp:176–181`):

```
                 (t
                  (ma0-refuse 'ma0-source-refused "V-DATA"
                              "an atom of type ~a is not admitted; the closed ~
atom vocabulary is STRING, INTEGER, KEYWORD, and lawful symbols"
                              (type-of node)))))
```

AFTER:

```
                 (t
                  (ma0-refuse 'ma0-source-refused "V-ATOMS"
                              "an atom of type ~a is not admitted; the closed ~
atom vocabulary is STRING, INTEGER, KEYWORD, and lawful symbols"
                              (type-of node)))))
```

BEFORE (`ma0-selftest-suite.lisp:158–170`, four sites, pattern shown once):

```
  (%ma0-expect-refusal directory "W-V-DATA a vector is not admitted"
                       …
                       'ma0-source-refused "V-DATA")
```

AFTER:

```
  (%ma0-expect-refusal directory "W-V-ATOMS a vector is not admitted"
                       …
                       'ma0-source-refused "V-ATOMS")
```

*(The check NAME as well as the expected code changes, or the suite reports a `W-V-DATA`
check asserting a `V-ATOMS` code. Both are printed; both must move together. This is the
"teeth expectation moves in the same commit as the fix" discipline, and under this option it
is four selftest checks, not a comment.)*

Plus, in `MANY-ACTS-0-GRAMMAR.md:52–53`, `refused (V-DATA)` → `refused (V-ATOMS)`; plus the
`AUTHOR-GUIDE.md:32` mention of `(V-DATA)` for host objects, which would need re-reading
against whichever split the ruling chooses.

⚠ **SCOPE CAUTION, load-bearing for this option.** `V-DATA` is emitted at **three** sites, and
they do not all mean the same thing. `ma0-validate.lisp:176–181` is the **atom-scan** refusal
(a non-admitted atom TYPE in the source) — the one V-ATOMS names. `ma0-eval.lisp:94` is a
**runtime** refusal of an unlawful value expression, a different obligation entirely. A
re-emission that rewrote every `V-DATA` site would silently move the runtime refusal under a
validator-vocabulary name and conflate two laws. Under this option the change must be scoped
to the atom-scan site alone, and the ruling should say so in those words.

### 3.3 OPTION 3 — declared umbrella

BEFORE (`MANY-ACTS-0-GRAMMAR.md:46`):

```
- **V-ATOMS**: atoms are drawn from: the closed head/keyword vocabulary above; STRINGs;
```

AFTER:

```
- **V-ATOMS** *(UMBRELLA — a name for the group below; NEVER emitted as a refusal code. The
  observable codes it covers are V-DATA, V-PKG and V-SHAPE)*: atoms are drawn from: the
  closed head/keyword vocabulary above; STRINGs;
```

Plus, added to `MANY-ACTS-0-GRAMMAR.md` §2 as a new closing paragraph:

```
**Every name in this list is either OBSERVABLE or UMBRELLA.** An OBSERVABLE name is carried
by some refusal as `ma0-result-refusal-code`; at /0 those are V-SHAPE, V-DATA, V-PKG, V-READ,
V-BIND, V-FIELD, V-AUTH, V-RES-AUTH, V-ARM, V-PATTERN, V-TERM and V-RETRY. An UMBRELLA name
groups rules and is never emitted; at /0 the only UMBRELLA name is V-ATOMS. A name that is
neither marked nor emitted is a defect in this document.
```

Plus, at the three comment sites, `V-ATOMS` → `V-ATOMS (umbrella)`.

---

## 4. IMPLEMENTATION STATUS

**PROPOSAL — AWAITING OWNER RULING. NOTHING IMPLEMENTED.**

`MANY-ACTS-0-GRAMMAR.md`, `ma0-validate.lisp`, `ma0-structures.lisp`,
`ma0-selftest-suite.lisp` and `AUTHOR-GUIDE.md` are byte-unchanged on this branch for this
item. No refusal code was minted, retired, or re-emitted; the observable vocabulary is
exactly the twelve codes enumerated in §1, unchanged by Parcel B.

The drafter records one adjacency without acting on it: `V-RES-AUTH` (3 emissions) is named
in the grammar under the **V-AUTH** bullet rather than as a bullet of its own, which is the
mirror-image irregularity — an emitted code that is not a top-level named law. It is **not**
within this item's jurisdiction and is **not** proposed here; it is noted so that whichever
option is chosen can be checked against it before the refusal-code table is ruled.

---

— drafted by CONDITOR (Claude Opus), Parcel B, commissioned by the chair (Claude Fable 5),
2026-08-10
