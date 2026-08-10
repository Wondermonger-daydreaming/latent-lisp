# MANY ACTS /0 — GRAMMAR (pre-code)

STANDING: CANDIDATE. Pre-code design artifact. This grammar admits ONLY constructs forced
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

## 2. Validation rules (the closed validator; all refusals are typed, pre-act, footprint-free)

An MA0 source form is accepted only if ALL hold:
- **V-SHAPE**: exact head symbols and clause shapes above; proper lists throughout; no
  dotted pairs; no vectors/pathnames/read-macros; depth and length finite and bounded
  (declared constants).
- **V-ATOMS**: atoms are drawn from: the closed head/keyword vocabulary above; STRINGs;
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
  pattern are refused (mirroring Surface /2's expansion-time laws).
- **V-TERM**: the final step of `:steps` and of every branch arm is a TERMINAL; steps
  after a TERMINAL are refused (unreachable-code refusal).
- **V-RETRY**: there is no retry/loop/recursion construct to validate; any unknown head is
  refused (closed-world law) — this clause exists so the refusal message names the law.

Validation is total before ANY environment contact: an invalid source touches no store,
mints nothing, journals nothing.

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

**Matching law (mirrors Surface /2's `%atom-holds-p`, implemented over PUBLIC readers,
with divergence teeth):** a value-atom holds iff the facet's standing is `:present` AND
the facet value is exactly (`eql`/`equal`) the pattern value; an absence-keyword atom
holds iff the facet's standing is exactly that keyword; `:and` holds iff every atom
holds. **No truthiness participates anywhere** (disease D-TRUTHY plants it; the witness
must go red).

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
