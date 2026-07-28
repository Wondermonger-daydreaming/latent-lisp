# LANGUAGE SURFACE /1 — CANDIDATE /0 — IMPLEMENTATION RETURN

> **The expansion leaves a receipt.**
>
> An expansion receipt says what form became what other form.
> It is silent about whether the transformation preserves meaning.

> ### ⚠ SUPERSEDED IN PART BY ERRATA 0.1 — READ THAT FIRST
>
> An owner-supplied pre-audit defect report against this candidate was
> reproduced and repaired. **Six findings were CONFIRMED against the tree this
> document describes.** Claims below that are false as written are corrected in
> place, marked `⚠ CORRECTED`. See `LANGUAGE-SURFACE-1-ERRATA-0.1.md`.
>
> ### ⚠ THE COUNT THAT USED TO STAND HERE WAS ITSELF FALSE — ERRATA 0.3
>
> This banner said **"Two claims below are FALSE as written"**, and named a
> count it did not keep. The 2026-07-28 stranger audit found further claims in
> this document false post-errata and unmarked — §4 answer 8's citation of
> selftest E11, §11's "the grammar unfolds shared structure", two
> application-check citations that had drifted, and a receipt-field list
> labelled *exhaustively* that omits a field. Each is now marked in place.
>
> **A banner that states a count is a claim about every claim beneath it**, and
> it falsifies itself the moment one more is found. This one therefore no
> longer counts; it points. Nothing has been deleted to make this document look
> better: the original bytes are preserved in git history and in the frozen
> audit packet, and every correction below is additive and marked.
>
> The most serious: **§10's non-promotion claim held, but the layer's central
> claim did not.** Door 2 expanded a caller-owned mutable alias, so a caller who
> mutated its tree after Door 1 received a receipt asserting that the stored
> source datum produced an expansion computed from a different form — a FALSE
> EDGE. Repaired: the immutable canonical datum is now the single authority and
> Door 2 reconstructs a fresh private host form on every performance.

```
status                          candidate constructed · candidate tested · candidate published
audited                         NO — the stranger audit is OWED and is not
                                discharged by Form /0's, Form /1's or Form /2's
adopted                         NO
frozen                          NO — specification-frozen: no
governing floor                 NONE — this layer joins no verify-*.sh floor
semantic delta below            NONE CLAIMED
predecessor trees               BYTE-IDENTICAL (git diff empty across CD/0,
                                Slice /1, Slice /2, Surface /0, Form /0/1/2)
```

**Merging, publishing, or reading this adopts nothing and freezes nothing.**

---

## 1. THE CENTRAL PROPOSITION, AND WHERE IT IS EXECUTABLE

> A Lisp+ macro expansion can become an inspectable structural occurrence whose
> receipt says exactly what form became what other form, while remaining silent
> about whether the transformation preserves meaning.

Executable at `de-expansione-testata/APPLICATION.lisp`, §III and §V. The account
is `RUN-APPLICATION.txt`.

The boundary the candidate preserves, end to end:

```
source form
    → explicit expansion request        REQUEST-EXPANSION   (Door 1)
    → macro expansion occurrence        PERFORM-EXPANSION   (Door 2)
    → truthful expansion receipt        one receipt, minted only on completion
    → expanded form                     returned as the second value
```

---

## 2. THE NUMBERS, LIVE-DERIVED

```
surface1-selftest            90 checks / 0 failed · exit 0
stub-image-fixture            8 checks / 0 failed · exit 0
de-expansione-testata        23 checks / 0 failed · exit 0
                            ───
                            121 checks / 0 failed

public exports               65 declared == 65 live · 0 false affordances
refusal catalogue            17 entries · 14 protocol · 3 integrity alarms
   :public-api                             12   fixtures in the selftest
   :public-api-in-a-stub-image              1   its own process, §6
   :unreachable-under-this-policy           1   measured, §7
   :internal-planted-fault-only             3   planted faults, all three bite

source-depth ceiling         48        source-nodes 20000    term-octets 262144
specimen source term         1497 octets       expanded term  2648 octets

SBCL 2.4.6, operation-checked through the wrapper.
```

**Predecessor floors, re-run after the candidate existed, diffed against the
pre-session baseline line by line:**

```
form floor        3 floors · 199 checks / 0     IDENTICAL
language floor   11 floors · 654 checks / 0     IDENTICAL
form2-selftest        86 checks / 0             unchanged
de-forma-mutata       43 checks / 0             unchanged
```

`git diff` across `canonical-datum/`, `language-slice-1/`, `language-slice-2/`,
`language-surface-0/`, `language-form-0/1/2` is **empty**. Nothing beneath this
layer was touched.

---

## 3. WHY `DEFINE-ADMISSION-CONTRACT`, FROM THE LIVE IMPLEMENTATION

All five Surface /0 constructs were measured under SBCL 2.4.6 before the choice:

| construct | atoms | uninterned | host depth | CD/0 octets | caller forms EVALUATED | expansion head |
|---|---:|---:|---:|---:|---|---|
| `define-slice2-schema` | 27 | 0 | 5 | 1,672 | **base-schema + every contract** | `PROGN` |
| **`define-admission-contract`** | **36** | **0** | **6** | **2,295** | **none — all literal** | **`PROGN`** |
| `derive-case` | 36 | 0 | 6 | 2,278 | operation + both arm bodies | `HANDLER-CASE` |
| `derive/2-case` | 38 | 0 | 6 | 2,428 | operation + both arm bodies | `HANDLER-CASE` |
| `define-judgment-schema` | 57 | 0 | 9 | 3,475 | none — all literal | `PROGN` |

`define-slice2-schema` is the smallest by byte count and is **not** the choice.
Byte count is the wrong axis, and the live source says why — `surface0.lisp:206-219`
declares it the one form that *mixes*: `:BASE-SCHEMA` and each contract are
ordinary Lisp expressions, evaluated once. Its expansion embeds free references
whose meaning depends on ambient bindings, which is precisely "entangled with
opaque host state." Surface /0's own closure calls it *"a real seam … the form
most likely to confuse a new reader."*

The chosen construct carries the decisive property, at `surface0.lisp:148`:

> **SYNTAX/EXPRESSION RULE: EVERY FIELD OF THIS FORM IS LITERAL SYNTAX.**

Its expansion is a pure function of the source text. Three further discriminators:

- **`define-judgment-schema`'s expansion calls `register-schema`** — a global
  registry write. The chosen expansion is a `defparameter` and a quoted symbol.
- **The two control forms expand to `HANDLER-CASE`, itself a macro.** Full
  `MACROEXPAND` of `derive-case` yields uninterned SBCL internals.
- **No Surface /0 macro takes `&environment`** — the string does not occur in
  `surface0.lisp` at all. The null environment is therefore *faithful*, not lossy.

---

## 4. THE TEN DESIGN QUESTIONS, ANSWERED FROM THE TREE

**(1) Which macro expands deterministically without serializing an opaque host
environment?** All five, because none accepts `&environment`
(`surface0.lisp:112, 171, 232, 322, 344`). Expansions were re-measured inside a
real `macrolet` + `symbol-macrolet` + `flet` + `let` lexical environment and were
byte-identical to the top-level result.

**(2) Uninterned or implementation-generated names?** **Zero** in all five
one-step expansions. Present in the *full* expansion of the two control forms,
and — see §8 — present in the *one-step* expansion of one reachable `derive-case`
shape. Both are refused. **⚠ CORRECTED by Errata 0.1:** the full `derive-case`
expansion carries **both** 13 uninterned symbols **and** 3 conses reachable by
more than one path, and it now refuses under
`:EXPANDED-TERM-SHARED-STRUCTURE` — the first check that fires — not under
`:EXPANDED-TERM-UNREPRESENTABLE` as stated here.

**(3) Representable in existing CD/0 types?** Yes, under an explicit term grammar.
CD/0's inventory is unit · boolean · integer · rational · string · bytes ·
**identifier** · sequence · record. There is no symbol family and no cons family,
so a host form is **represented**, never "put in."

**(4) What boundary representation is required?** The **identifier datum** already
is it — `make-identifier-datum(namespace, path)` takes segments, and a symbol is
exactly a package name plus a symbol name. **No new representation law was
needed.** Everything outside the grammar is *refused*, never rendered: a symbol
with no package, a symbol with an empty name, a dotted tail, a cycle, and every
other host type. There is no printed-representation escape hatch, because a
string of a printed object is not the object.

**(5) Alpha-normalization?** **Not needed and deliberately not built.** The chosen
specimen has zero gensyms; gensym-bearing expansions are refused. Alpha-
normalization is named in §11 as the smallest missing law for a later candidate.

**(6) What is "macro identity" here?** Not an exported symbol — the repository's
law is *"No host symbol is ever a durable operator or hole name"* (`form0.lisp:36-38`).
Not a registry — none exists in any Form layer. Not a source digest — *"Inventing
a hash protocol is forbidden"* (`LANGUAGE-FORM-2-WORK-ORDER.md:792-794`), and CD/0
supplies no hash. **And not a Surface /0 version, because Surface /0 declares
none** — see §5. It is a **construct identifier in this layer's own namespace,
drawn from a closed table of the five known forms**, plus this layer's own
procedure identity and version, in the idiom of `form0.lisp:43-47`,
`form1.lisp:57-115` and `form2.lisp:80-90`.

**(7) What expansion context can truthfully be recorded?** That the **null lexical
environment was supplied**, and that **no environment object was captured**. Both
are facts about the *call*. The field does not establish that the construct
ignored the environment or that no environment-dependent behaviour occurred — a
CL macro environment is an opaque implementation object with no portable reader,
and a serialization of one would be folklore wearing a language guarantee.

> **⚠ CORRECTED — ERRATA 0.3 (stranger audit D9).** The citation below named
> **selftest E11**, and Errata 0.1 finding 1c had already ruled that E11 never
> performed the same request twice — it built a fresh equivalent request — with
> the same-object property moved to **E11b**. This document went on citing E11
> for the one property E11 was found not to test. Read the claim as resting on
> **E11b**, and note the shape: the document that inventories the claims was
> carrying a stale citation to a check whose defect it had itself recorded.

**(8) Deterministic replay?** Yes, for gensym-free expansions: the same request
performed twice yields the same occurrence identity (selftest E11b — see the
correction above), and CD/0's
canonical encoding is invariant under `*readtable*`, `*print-*` and `*package*`.
Expansions that would *not* replay are refused — see §8.

**(9) How does the evidence distinguish one-step from recursive?** Three ways, all
executable. The operation is **committed into the request identity** (D16), so two
requests differing only in operation have different identities *even when their
expanded forms are byte-identical* (F1, F2). The dispositions differ
(`:MACROEXPANDED-ONE-STEP` vs `:MACROEXPANDED-REPEATEDLY`). And for the control
forms the host results genuinely differ (F6), with the full expansion refused (F5).

**(10) What machinery is reused, and what would be a lie to reuse?** Reused: the
lossless-octet identity value, the three-tier describe → happen → account chain,
the immutability discipline, the two doors, the split refusal catalogue, upstream
preservation, package-constant version binding. **Refused as lies:**
`:REPLACED-AT-PATH` with its path apparatus, and the `expected-old`/`observed-old`
precondition pair. See §9.

---

## 5. THE LOAD-BEARING NEGATIVE — SURFACE /0 DECLARES NO VERSION

`language-surface-0/package.lisp` exports exactly ten symbols: five macros, four
condition readers, one accessor. **No identity symbol, no version symbol, no
registry symbol.** `surface0.lisp` contains no `defconstant` and no version
parameter; every occurrence of "version" in it is a *lower* layer's field copied
through literally.

The repository had already recorded this against itself
(`LANGUAGE-FORM-2-WORK-ORDER.md:1645-1650`):

> *"Its five macros **mint no object, carry no identity or version of their own,
> record no before/after, and leave no artifact behind.** … There is **no
> expansion record of any kind** to extend."*

**So the brief's optional "surface-version or implementation-identity field, where
the repository has a lawful basis for one" resolves to: THERE IS NO SUCH BASIS,
and Surface /1 mints no such field.** Minting a version *for* Surface /0 from here
would be this layer legislating for a layer it does not own. Selftest **A6**
asserts no exported symbol of this package even names `SURFACE0`.

Also recorded, because it is the adjacent trap: Surface /0's `SC22` compares the
resulting **objects** through public readers, not the expansions. **It is not
expansion equivalence and is never cited as such here.**

---

## 6. THE CLOSED CONSTRUCT TABLE IS NEW LAW, DECLARED AS SUCH

Form /2 could write *"the API takes DATA only, and a CD/0 datum cannot be a
function."* **This layer cannot say that** — it invokes a macro function. EG-4
(`WORK-ORDER:1709-1712`) forbids any caller-supplied procedure on a public
surface, and that impossibility is not inherited here.

The gate that replaces it: a **closed, exhaustive table of the five known
constructs, written as PACKAGE-NAME and SYMBOL-NAME strings**, resolved by
`find-symbol` at expansion time. Consequences, all verified:

- **`surface1.lisp` loads CD/0 and nothing else.** Selftest **A1** measures this
  before anything can perturb it: Surface /1 came up with Surface /0 **absent**.
- No caller supplies a procedure, a callback, a predicate or a handler.
- An unknown head is **one honest code**, `:NOT-A-KNOWN-SURFACE-CONSTRUCT`. This
  layer does not reproduce Surface /0's grammar in order to describe it.

Two codes an earlier draft advertised were **deleted as false affordances**:
`:CONSTRUCT-PACKAGE-ABSENT` and `:CONSTRUCT-SYMBOL-ABSENT`. Door 2 reaches the
package lookup only *after* matching on `(package-name (symbol-package head))`, so
the package provably exists and the symbol provably exists in it. No caller can
reach either branch. Selftest **B4** asserts they stay absent.

One code, `:CONSTRUCT-NOT-A-MACRO`, is reachable only where Surface /0's package
exists **without** its macros. Producing that state inside the selftest's image
would mean unbinding a Surface /0 macro function — altering the layer under
observation. It gets **its own process**, `STUB-IMAGE-FIXTURE.lisp`, which never
loads `surface0.lisp` at all: 8 checks, 0 failed.

---

## 7. THE CEILINGS ARE MEASURED, AND SO IS THE ONE THAT CANNOT FIRE

**CD/0 enforces `max-depth` on DECODE, not at construction.** A term datum can be
BUILT deeper than it can be READ BACK. Measured by bisection: a host form nested
**201** levels encodes without complaint and refuses on `decode-exact` at **64**,
because this grammar costs **2.032 CD/0 depth units per host list level**. The
largest host form that both encodes and decodes is **63**.

A layer that minted a receipt above that edge would be issuing an account whose
own canonical octets cannot be decoded. So `expansion-policy-max-source-depth` is
**48** — inside the measured edge with room for the enclosing identity payloads —
and `%encode-checked` ends with a **full decode round trip**, so the guarantee is
executed, not assumed.

The expanded-side edges, bisected in the application and reported **with the
refusal at n+1 exhibited**, not with a comfortable margin:

```
largest ACCOUNTED clause count       2012
at 2013                              :EXPANDED-TERM-OCTETS-EXCEEDED
:EXPANDED-DEPTH-EXCEEDED reachable   at conclusion-nesting 42 — the source
                                     passes and DEFINE-JUDGMENT-SCHEMA's
                                     (PROPOSITION-PATTERN '…) wrapper adds the
                                     levels that push the EXPANSION over
```

**AND THE CEILING THAT DOES NOT FIRE, NAMED RATHER THAN HIDDEN.**
`:EXPANDED-NODES-EXCEEDED` is classified `:unreachable-under-this-policy`. The
checks run depth → nodes → encode → octets, and one term costs far more than
`262144 / 20000 = 13` octets, so the octet ceiling always fires first — at roughly
2,000 nodes, never near 20,000. Selftest **M4/M5/M6** assert the classification,
assert that its **source-side twin IS reachable** (the node check runs *before*
encoding, so the pair is deliberately asymmetric), and **exhibit the arithmetic**
rather than asserting it.

**The guard stays. The octet ceiling was NOT raised to make it theatrically
reachable, and the handler was NOT deleted to make a coverage table look
complete.** Both moves were available and both were refused.

*Method note, recorded against this session.* The first version of selftest M2
claimed all three expanded-side ceilings were "exercised in the application."
**Two were.** The claim was written before the application ran, it read as a
verified coverage statement, and it was false. It was caught by running the
application and comparing, not by rereading the label.

---

## 8. THE REFUSAL THE CANDIDATE IS BUILT AROUND

`%parse-arms` (`surface0.lisp:294-315`) guards the `:refused` variable with
`(symbolp (first spec))` and `(not (keywordp (first spec)))`, but **omits the
non-NIL conjunct that its sibling guard at line 330 applies to the claim and
receipt variables**. So `(:refused (nil) …)` is accepted, `refused-var` becomes
`NIL`, and the otherwise-dormant `(or refused-var (gensym "COND"))` fires.

**The same source form then expands differently every time.** Selftest **G1**
asserts it against the live host.

Surface /1 **refuses** that expansion, at **one-step**, with
`:EXPANDED-TERM-UNREPRESENTABLE` and the upstream reason `UNINTERNED-SYMBOL`
preserved.

> **⚠ CORRECTED by Errata 0.1.** This section originally continued: *"A receipt
> for a non-deterministic expansion would be an account that could not be true
> twice. The refusal is not a limitation worked around. It is the layer
> declining to account for something no account could be true of."*
>
> **That was wrong**, and it was the most rhetorically attractive sentence in the
> candidate, which is presumably why it survived. A receipt accounts for **one
> occurrence**, and a nondeterministic occurrence can have a perfectly truthful
> receipt — it says what form became what other form *on that occasion*, which is
> what a receipt is for. Determinism is a property a reader may want; it is not a
> precondition of truthfulness.
>
> **The actual reason, and the only one:** the term grammar cannot injectively
> account for uninterned-symbol identity and binding structure. An uninterned
> symbol has no package, hence no namespace, and two distinct gensyms bearing one
> name collapse to a single identifier datum because CD/0 compares identifier
> segments bytewise. **A grammar limit, not an epistemic one.**

**THIS DEFECT IS REPORTED, NOT REPAIRED.** Selftest **G4** and application check
20 both re-assert, at the end of their runs, that Surface /0 *still* expands it
non-deterministically. The observer accounts for the expansion that exists; it
must never manufacture a friendlier one and then certify its own handiwork.

*A second hole in the same guards, found and likewise not repaired:* the guards
also accept a **constant** (`T`, `PI`, `MOST-POSITIVE-FIXNUM`) as the refused
variable, emitting code the host rejects with a bare accident — *"names a defined
constant, and cannot be used in an ordinary lambda list"* — which is exactly the
failure mode Surface /0's own §SURFACE GRAMMAR REFUSAL comment exists to prevent.
Both belong in a Surface /0 erratum, not in this layer.

---

## 9. WHAT WAS DELIBERATELY *NOT* REUSED FROM FORM /2

**`:REPLACED-AT-PATH` and the entire path apparatus.** Macroexpansion is not a
replacement at a caller-named address. The caller named a **call site**, not a
path, and **supplied no replacement — the macro computed it**. Emitting that
disposition would represent a computed rewrite as a declared substitution.

**`expected-old` / `observed-old` and their precondition machinery.** In expansion
**the caller cannot declare the output — that is what a macro IS.** Binding the
input there changes the field's meaning silently; binding the expansion there
fabricates a precondition nobody stated. Form /2's derived-projection theorem
(`form2.lisp:745-754`) quantifies only over *"the fixed package procedure,"* and a
construct's macro function is not one.

**And the deepest structural difference, which follows from the same fact:**

> Form /2 may **omit** `output-datum-identity` from its occurrence identity as a
> derived projection, because the output is derivable from a complete
> caller-supplied description. **Surface /1 COMMITS the expanded-form identity
> into the occurrence identity and can never omit it, because nothing in the
> request determines the output.** There is no derivability theorem here and
> there cannot be one. Door 1 validates strictly less than Form /2's Door 1, and
> it does not pretend to more.

What *is* reused: the two doors; the three-tier identity chain; identity as
**lossless octets, never hex** (Form /1's repair, since hex doubles per link);
immutable objects with no public constructor and no copier; three values on both
branches; `try-`/loud twins with the non-signalling one authoritative; the split
refusal catalogue with **no flat list**; upstream-preservation as an added reading
rather than an overwrite; and version binding as package constants, so a receipt
cannot disagree with the package that minted it.

---

## 10. WHAT THE RECEIPT SAYS, AND WHAT IT REFUSES TO SAY

> **⚠ CORRECTED — ERRATA 0.3 (stranger audit D9 / C-5).** The list below was
> labelled *exhaustively* and was not: it omitted **`occurrence`**, the field
> Errata 0.1 added, whose accessor `EXPANSION-RECEIPT-OCCURRENCE` is exported.
> The audit found it to be the one export in the tree that no document
> inventoried. The list is corrected below, and the version fields are no
> longer "package constants" — Errata 0.3 (D7) makes them **stored values**.
> The check-number citation was also stale: the absence checks were 7–9 when
> this was written and are **8–10** after Errata 0.1 inserted a check at
> position 2.

**Fields, exhaustively (corrected):** `identity` · `request-identity` ·
`occurrence` · `occurrence-identity` · `source-form-datum` ·
`source-form-identity` · `expanded-form-datum` · `expanded-form-identity` ·
`operation` · `construct-identity` · `expansion-context` · `disposition` ·
and — **stored, since Errata 0.3** — `grammar-version` · `procedure-version` ·
`policy-version`, with `procedure-identity` and `policy-identity` remaining
package constants.

**There is no field for meaning, equality, correctness, hygiene, evaluability,
compilability, portability, or an environment object.** The application's
absence checks (7–9 as written; **8–10** in the current tree) assert the
absences directly.

**The receipt does not claim** — and the package header says this before any code,
because this is the layer where the preservation intuition is strongest:

- that the source and the expansion mean the same thing
- that the expansion is correct, well-formed, or sensible
- that evaluating it would succeed, or that compiling it would behave as
  evaluating does
- that the macro is hygienic, or that any capture did or did not occur
- that the expansion is portable to another Common Lisp, or reproducible in
  another image or after any redefinition
- that a lexical environment was captured — **no environment object is ever
  captured, encoded, or represented**
- that later evaluation, admission, or judgment flows backward and validates the
  expansion

**Non-promotion is executed, not asserted.** Selftest §I evaluates the accounted
expansion, producing a **real Slice /2 support-admission contract** through Slice
/2's own public constructor, and then verifies the receipt identity and the stored
expanded datum are **byte-identical** afterwards. The application does the same,
and adds the mirror case: a second specimen differing in **one field**, accounted
for with the **identical disposition**, which **Slice /2 then refuses in Slice /2's
own voice**.

> Two expansions identical in every structural respect this layer can see. The
> difference in worth decided one layer down, by the only voice with standing to
> decide it. **Nothing above filtered the second one** — the same shape as
> Form /2's Candidate C, one layer up.

**Surface /0's own grammar refusal escapes unwrapped.** A malformed construct
signals `lisp-plus-surface0:surface-syntax-refused`, carrying Surface /0's own
reason keyword, and Surface /1 mints **nothing** — no occurrence, no receipt, not
even a refusal object (selftest J1–J3). Catching it would make *"your syntax is
malformed"* a fact this layer reported, when it is a fact the layer below owns.

---

## 11. WHAT THIS CANDIDATE EXPLICITLY DID NOT EARN

- **No stranger audit.** Owed, and not discharged by any predecessor's.
- **No adoption, no freeze, no governing floor.** `verify-all.sh`,
  `verify-form-floor.sh` and `verify-language-floor.sh` are untouched; this layer
  joins none of them, and folding it in is a separate, later, owner decision.
- **No semantic claim of any kind about any expansion.**
- **No general-purpose evaluator, compiler, macro debugger, source-map system,
  hygiene system, or portable lexical-environment serializer.** There is no
  `:MACROEXPAND-ALL` and no code walker; the layer offers exactly the two
  operations the host itself provides. A full walker is a compiler's job.
- **No repair of the Surface /0 defects in §8.** They belong in a Surface /0
  erratum authored against that layer.
- **Corroboration.** One model family wrote the layer, its term grammar, its
  application and these checks. Every green is self-consistency certification.

**The smallest missing laws, named for a later candidate rather than smuggled in
here:** (a) **alpha-normalization** — a declared normal form for uninterned
symbols would let gensym-bearing expansions be accounted for, and it is a real
representation law requiring its own design, not a patch; (b) a **sharing/DAG
representation**, since the grammar refuses shared structure and refuses cycles
[**⚠ CORRECTED — ERRATA 0.3 (D9)**: this read *"unfolds shared structure"*,
which described the PRE-ERRATA-0.1 grammar. Errata 0.1 replaced silent
unfolding with a global refusal — that was the finding, and this sentence
survived it unchanged, still describing the behaviour the erratum removed];
(c) a **compile-time-vs-macroexpand-time comparison**, which Surface /0's `SC22`
does *not* provide and which nothing in the tree currently supplies.

---

## 12. RECOMMENDATION

```
candidate constructed
candidate tested
candidate published
not audited
not adopted
not frozen
not promoted into a governing floor
```

The next lawful step is a **stranger audit against a frozen target** — and it is
harder than Form /1's for the reason Form /2's handoff already recorded: this tree
is public the moment it is committed, so **the prereg must be frozen outside the
repository, or committed as a hash with the plaintext published after the run.**
*A prereg in the tree is a published prereg.*

---

*This document describes the tree at `2e21f367`. For what changed and why, read
`LANGUAGE-SURFACE-1-ERRATA-0.1.md`; the numbers in §2 are Candidate /0's and are
superseded by the errata's §7.*

*— Claude Opus 5 (1M context), 2026-07-28. Built against lab `0595c68e`.
SBCL 2.4.6 operation-checked through the wrapper. 121 checks / 0 failed across
three processes. Predecessor floors 199/0 and 654/0, byte-identical to the
pre-session baseline. `specification-frozen: no`.*
