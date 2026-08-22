# MANY ACTS /0 — GRAMMAR (pre-code)

STANDING: standing in this lane attaches to immutable object identities and explicit
dispositions, never merely to filenames, directories, or descent from an adopted commit
(Owner Ruling 6 §3 B1; rule and coordinates in `MANY-ACTS-0-STANDING.md`). This file's path
confers no standing on its bytes in either direction. Pre-code design artifact, amended
prospectively by owner ruling. This grammar admits ONLY constructs forced
by P1/P2 (see MANY-ACTS-0-PRESSURE-REPORT.md §3, §5). Seat strings in the briefs are
placeholders; canonical seats are read from the adopted fixtures via the exported
`act-fixture-runtime-seat`.

## 1. Source grammar (over plain S-expressions)

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

CLAUSE    := (PATTERN STEP+)              ; STEP+ ends in a TERMINAL or falls through to
OTHER     := (otherwise STEP+)            ; the program's remaining steps? NO — see §5.3:
                                          ; every branch arm must END in a TERMINAL or in
                                          ; steps whose last is a TERMINAL; fall-through
                                          ; across a branch is refused (single-shape law).
TERMINAL  := (result VEXPR)
           | (refuse (:code KEYWORD) VEXPR?)

PATTERN   := ATOMP | (:and ATOMP ATOMP+)
ATOMP     := (AXIS PVALUE)                ; closed; see §4

VEXPR     := LITERAL | (ref IDENT) | (field IDENT AXIS) | (list VEXPR+)
LITERAL   := STRING | INTEGER | KEYWORD
ARM       := one of "A" "B-L1" "B-L2" "B-R" "C-i" "C-ii" "D"
SEATD     := STRING | (ref IDENT)
IDENT     := a symbol in the program's own flat namespace (see §3)
```

## 1b. Datum ingestion (the reader law, by reference — owner ruling, PS/0 Cluster Sitting 1, Disposition 1, 2026-08-12)

An MA0 source is ingested by **Common Lisp `read`** — the standard reader of
ANSI Common Lisp — under exactly these bindings, which are law: the source
file holds **exactly one form** (an empty file and a file with more than one
form are both refused, V-SHAPE); `*read-eval*` is bound to **NIL**;
`*package*` is bound to **the program namespace**
(`lisp-plus-many-acts0.program`); `*read-default-float-format*` is bound to
**`double-float`**; the file is opened with external format **UTF-8**; and
the **standard readtable** applies, including its standard `readtable-case`
of `:upcase`. Everything the standard reader does under those bindings —
token grammar, symbol upcasing, keyword syntax, integer syntax (signs and
radix markers), string escaping, character and comment syntax, dotted-pair
reading — is thereby the datum-ingestion law of Many Acts /0, **by
reference, not by restatement**.

Three consequences are stated here so no reader must derive them:

- **Keyword identity (spelling).** The observable identity of a keyword is
  its **upcased symbol-name**: a source-authored
  `(:code :earth-entry-quarantined)` is observed as
  `:EARTH-ENTRY-QUARANTINED`. Wherever a keyword (including a program
  refusal code) is compared or reported, the upcased form is the normative
  form; lowercase source spellings are authoring convenience only.
- **Integers.** `INTEGER` in §1 means Common Lisp integer syntax at
  **arbitrary precision**. No magnitude bound exists or is implied; the
  declared V-SHAPE bounds (§2) constrain source *structure* — depth and node
  count — never numeric magnitude. (This matches the layer below: Canonical
  Datum /0 pins integers as unbounded.)
- **Floats and ratios.** The reader *reads* them (deterministically, under
  the float-format binding above) and the validator then *refuses* them:
  they are not `LITERAL` atoms, and they surface as V-DATA refusals. They
  are readable, never lawful.
- **Strings — content policy** *(owner ruling, PS/0 Cluster Sitting 2,
  Dispositions III-2 and III-3, 2026-08-12; terminology confined by Parcel
  3 Repair 1)*. A string is the **exact character sequence produced by the
  admitted reader. No Unicode normalization is performed** — at ingestion
  or anywhere else; canonically equivalent sequences (`U+00E9` vs
  `U+0065 U+0301`) are **distinct strings**. This adopts **Canonical Datum
  /0's frozen non-normalization rationale** — normalization could erase a
  meaningful distinction, and this lane's payloads carry program-authored
  evidence — **and does NOT adopt CD/0's repertoire**: CD/0 strings are
  sequences of Unicode scalar values (surrogates excluded by definition);
  MA0 /0's repertoire is deliberately the reader-admitted one. **Any
  character the admitted reader accepts is lawful string content** — no
  forbidden-character rule exists at /0. *Disclosed hazard, carried with
  the rule:* such a string may lawfully contain a reader-admitted lone
  surrogate code point (which is not a Unicode scalar value) or a Unicode
  noncharacter; downstream serializers may reject these; a lawful MA0
  datum is **not** thereby guaranteed universally serializable. A future
  interchange profile may narrow its own repertoire explicitly; the core
  string domain is not narrowed by that prospect.

## 2. Validation rules (the closed validator; all refusals are typed, pre-act, footprint-free)

An MA0 source form is accepted only if ALL hold:
- **V-SHAPE**: exact head symbols and clause shapes above; proper lists throughout; no
  dotted pairs; no vectors/pathnames/read-macros; depth and length finite and bounded
  (declared constants — **normative values, published by owner ruling, PS/0 Cluster
  Sitting 1, Disposition 2, 2026-08-12: maximum source depth 32; maximum source nodes
  4096**. A third declared constant, the ownership walk's termination budget of 65536, is
  **an implementation guard against an unbounded copy, not a policy bound on program
  size** — it is published here as **non-normative and free**: a conforming
  implementation is not required to reproduce it, and its behavior is excluded from
  conformance comparison).
- **V-ATOMS** *(UMBRELLA — a name for the group of obligations below; NEVER emitted as a
  refusal code. At /0 it is an umbrella over the relevant V-DATA, V-PKG and V-SHAPE
  obligations; owner ruling, Parcel B item B5, 2026-08-10)*: atoms are drawn from: the
  closed head/keyword vocabulary above; STRINGs;
  INTEGERs; KEYWORDs from the closed pattern grammar or user `:code` keywords; and bare
  IDENT symbols. **Every symbol must be either a grammar head, a closed-grammar keyword,
  or an IDENT whose home package is the validator's designated program-symbol package**
  — package-internal symbols of ANY other package are refused (V-PKG). `#.` never
  survives to the validator: sources are read with `*read-eval*` bound to NIL by the
  loader (V-READ), and a source containing a function object, closure, structure, or any
  non-listed atom type is refused (V-DATA).
- **V-BIND**: every IDENT is defined exactly once (input, bind, act, derive) before any
  use; duplicate definition anywhere (including across branch arms vs outer scope) is
  refused — NO SHADOWING exists in this language. `(ref X)` and `(field X …)` require X
  defined and, for `field`, X outcome-bound (derive) — `field` over an act-result or
  ordinary value is refused (V-FIELD; the act-result's shape is inspected by `branch`
  through its DERIVED evidence, never projected by field access).
- **V-AUTH**: `:authority-slot` names must be declared in `:authority-slots`; a STRING,
  outcome IDENT, act IDENT, or literal in authority position is refused (V-RES-AUTH).
  Authority slots may not appear in VEXPR position (a slot is not a value).
- **V-ARM**: `:arm` must be one of the seven adopted arms; each arm may appear at most
  once in the whole program text (the adopted lane would refuse a second invocation at
  runtime; MA0 refuses it statically so the failure has no footprint).
- **V-PATTERN**: patterns obey §4; a `branch` requires ≥1 clause and exactly one trailing
  `otherwise`; duplicate canonicalized patterns and patterns shadowed by an earlier equal
  pattern are refused (this lane's own closed expansion-time laws, stated here and
  witnessed by this lane's own scenarios; the design was informed by similar principles,
  and no agreement or equivalence with another lane's laws is claimed — owner ruling,
  Parcel B item B6, 2026-08-10).
- **V-TERM**: the final step of `:steps` and of every branch arm is a TERMINAL; steps
  after a TERMINAL are refused (unreachable-code refusal).
- **V-RETRY**: there is no retry/loop/recursion construct to validate; any unknown head is
  refused (closed-world law) — this clause exists so the refusal message names the law.

Validation is total before ANY environment contact: an invalid source touches no store,
mints nothing, journals nothing.

**Every name in this list is either OBSERVABLE or UMBRELLA** (owner ruling, Parcel B item
B5, 2026-08-10). An **OBSERVABLE** name is carried by some refusal as
`ma0-result-refusal-code`; at /0 those are V-SHAPE, V-DATA, V-PKG, V-READ, V-BIND, V-FIELD,
V-AUTH, V-RES-AUTH, V-ARM, V-PATTERN, V-TERM and V-RETRY — twelve names, mechanically the
twelve distinct codes named at the lane's 65 `ma0-refuse` emission sites. An **UMBRELLA**
name groups rules and is never emitted; at /0 the only UMBRELLA name is V-ATOMS, and it
carries zero emission sites. A name that is neither marked nor emitted is a defect in this
document. No code was minted, retired, or re-emitted by this amendment, and nothing
observable to a program author changed.

Three counts are distinct and may not impersonate one another: **emission sites** (an
`ma0-refuse` form naming the code), **code occurrences** (the literal code string anywhere
in the lane's sources, including a selftest's or a witness's *expectation* of it), and
**prose references** (the code named in lane prose). V-RES-AUTH, for one, has **1 emission
site** and **3 code occurrences** — two different numbers for one code, and its prose
references are a third number again, measurable but not fixed, since every document that
names the code (including this sentence) moves it. Any count quoted for a code must say
which of the three it is, and must be derived mechanically at the moment it is quoted.

## 3. Lexical scope and shadowing

One flat program namespace. A name is DEFINED by `:input`, `bind`, `act`, or `derive`, and
VISIBLE from its definition to the end of the program text (including inside subsequently
selected branch arms). Shadowing is refused statically (V-BIND). Binding classes are
distinct and checked: ordinary values (input/bind), act-results (act), derived outcomes
(derive); each construct's operand positions state which classes they accept:
`ref` → ordinary values; `field` → derived outcomes; `branch` head → derived outcomes or
act-results (§5.2); `:seat` `(ref …)` → ordinary values.

## 4. Pattern grammar and the exact branch-selection law

Axes and closed value sets are EXACTLY Surface /2's published sets (grammar-version pinned
in the contract): `:execution` ∈ {:absent :prepared-only :crossed-unsettled
:uncertain-unresolved :settled :reconciled}; `:provenance` ∈ {:live :derived-recovery
:none}; `:evidence-class` ∈ {:refusal :closure :projection :control-outcome :uncertain
:reconciled :none}; plus the absence keywords {:absent-from-evidence
:malformed-in-evidence} as matchable PVALUEs on any axis. There is deliberately NO
:success, :truth, :retry-safe, or :cost axis.

**Matching law (this lane's own closed law, implemented over PUBLIC readers, with
divergence teeth; the design was informed by similar principles, and no agreement or
equivalence with any other lane's matcher is claimed — owner ruling, Parcel B item B6,
2026-08-10):** a value-atom holds iff the facet's standing is `:present` AND
the facet value is exactly (`eql`/`equal`) the pattern value; an absence-keyword atom
holds iff the facet's standing is exactly that keyword; `:and` holds iff every atom
holds. **No truthiness participates anywhere.** The witness is the selftest scenario
`w-branch-exact` (5 checks: a non-`NIL` facet holds nothing; the standing must be
`:present` and the value exact), not a planted disease — **there is no `D-TRUTHY`.** This
lane's planted-disease inventory is exactly five named families — `D-BOTH-ARMS` ·
`D-AMBIENT` · `D-AUTO-RETRY` · `D-SKIP-VALIDATE` · `D-SPECIAL-CASE` — exercised through six
disease/control invocations (`ma0-diseases.sh`; R1 adoption Rider 6 forbids substituting
either count for the other). The pre-code draft of this line named a sixth disease that was
never built.

**Selection law:** clauses are tested in textual order; the FIRST holding clause is
selected; `otherwise` is selected iff no clause holds; EXACTLY ONE arm's steps are
evaluated (disease D-BOTH-ARMS plants double execution; witness must go red). For a
branch over an ACT-RESULT (§5.2) the same textual-order law applies over the act-result
pattern atoms.

## 5. Evaluation semantics

### 5.1 Order and effects
Steps evaluate strictly in textual order, exactly once, same-image, sequentially. `act`
is the ONLY consequential step. `derive` is effect-free by construction (Surface /2
derivation over the validated prefix). Program orchestration at /0 is SAME-IMAGE ONLY:
the runner does not resume after process death; each completed constituent act remains
durably journaled under One Act regardless. **Many Acts /0 is not a transaction system:
no rollback, no compensation, no exactly-once theorem, no atomicity across acts.**

### 5.2 The `act` step and its result
`(act ID (:arm A) (:authority-slot S))` executes the adopted arm A through the public One
Act composition (contract §4): environment supplies store/worlds/bootstrap/minting-context
and the journaled grant occupying slot S; the act's identity, authority decision, journal
frames, and agreement verdict are One Act's own. The act-result bound to ID is an
immutable MA0 summary: `{arm, act-id-hex, disposition, class, verdict-or-refusal}` — it
is DATA. It is not a capability (V-RES-AUTH statically; Capability /1 recognition law at
runtime), and it is not evidence (evidence is derived from the store by `derive`).
A `branch` over an act-result matches on the closed atoms
`(:disposition {:returned :refused :interrupted :host-fault :mint-refused})` and
`(:class {:a :b :c-i :c-ii :d :unclassifiable :unpaired-f1})` — the two axes P2 forces,
nothing more.

### 5.3 Terminals, refusal vs error
Every complete evaluation ends in exactly one TERMINAL, producing an immutable
program-result: `{program-name, disposition ∈ {:completed :refused}, value-or-refusal
{code, detail}, ordered act summaries, store-id}`. **Structured refusal** (`refuse`
terminal, or an act-level refusal the program branches into a `refuse`) is a LAWFUL
program outcome — disposition `:refused`, exit still orderly, journal intact. **Errors**
(host conditions: validator refusals raised before running; environment refusals; adopted
lane conditions the program did not branch on; host faults) propagate as conditions and
are NEVER converted into `:completed`. The boundary: refusal is spoken by the PROGRAM in
its own grammar; error is anything that interrupts the evaluator from below.

### 5.4 Program-level claim ceiling
A green program run claims: this program text, validated by the closed validator,
evaluated under the declared fixture environment, produced this result with these acts'
journal evidence. It claims NOTHING about: other environments, external reality's
determinism, retry safety, independent usability, or any semantic question the underlying
lanes left open. Determinism claims are "evaluator determinism under declared fixtures,"
never determinism of arbitrary external reality.

## 6. Source / environment / authority separation (restated as grammar law)

SOURCE is the S-expression above: pure data, serializable, hash-able, inspectable; it may
NAME authority slots and seats. ENVIRONMENT is a host object built by the runner (never
serialized into source): store, worlds, bootstrap, minting context, seat map, slot→grant
occupancy. LIVE AUTHORITY exists only as journaled grants + process-local recognition
(Capability /0 + /1) inside the environment. No source form can contain, reconstruct, or
be mistaken for a live capability: sources cannot hold host objects (V-DATA), and
capability structs are unexported/unserializable upstream. Disease D-AMBIENT plants an
evaluator that fills an unoccupied slot from a dynamic variable; the witness must go red.
