# LANGUAGE-SLICE-1-API.md

> **⚠ SUPERSEDED IN PART — `CHARTER-DELTA-4.md` (2026-07-25) GOVERNS two surfaces.**
> **(1) R-POLARITY-1 — witness direction.** A matching, receiver-accessible Slice /0
> witness declaring `:polarity :refutes` is **REFUTING EVIDENCE**. It no longer
> discharges the premise it contradicts, no longer appears in
> `premise-assessment-matching-accessible-supports`, and no longer contributes a
> binding environment. Every statement in this document describing premise discharge
> as reading only `witness-for` and receiver accessibility is corrected: it also
> reads **declared polarity**, and nothing else was added. New export:
> `premise-assessment-refuting-witnesses`.
> **(2) R-GROUNDING-NAME-1 — grounding identity.** `ground-instances` /
> `ground-instance` are **LEGACY PROJECTION READERS**; what they return is a
> *conclusion-projected premise instance*, **not** a complete binding environment,
> and its cardinality is **not** the number of them. The normative complete set is
> the **complete binding environment set**. New export (alias, same value):
> `premise-assessment-projected-premise-instances`. **`admissible` remains
> undefined** as a general source contract (E4 stands) — neither ruling supplies a
> premise-source admission contract.

> **⚠ SUPERSEDED IN PART — `SLICE1-ERRATUM-1.md` (2026-07-24) GOVERNS.**
> A cold external audit and chair adjudication corrected statements in this
> document: the receipt-scope promise (E1 — receipts are issued on every
> *assessed derivation*, not every invocation; **four** pre-assessment exits
> carry none), universal Slice /0 flow-through (E2 — false for non-boundary
> `(:quoted-datum …)` payloads; a recorded constructor defect), judged-claim
> premise discharge (E3 — an unconverted design obligation, now recorded
> `:not-earned`), the undefined term "admissible" (E4), the D-forge's stratum
> placement (E5 — reachable from the public surface, not via `::`), and
> order-independence granularity (E6). Read the erratum before citing anything
> here. Original text left unaltered on purpose.

> **REPAIR NOTE (D1, 2026-07-24, post-erratum).** One of E1's four
> receipt-less exits has since been repaired in `slice1.lisp` and is no longer
> receipt-less. The owner fixed the threshold: **a receipt is mandatory once an
> invocation has become a *constructible derivation attempt*** — the schema has
> been resolved AND enough conclusion structure exists to identify the attempted
> derivation. `unbound-conclusion-variable` is **post-threshold** (schema
> resolved, conclusion a lawful normal form, only the binding failed) and now
> **carries a receipt**. The remaining **three** — `pattern-used-as-ground`,
> `schema-not-found`, `malformed-structured-proposition` — fire *before* that
> threshold; they are lawful typed **pre-derivation failures** and carry none, by
> design: a receipt there would be a fiction. Read E1's "four" as **three** for
> current code. The receipt-scope rule is restated in full at
> `derivation-receipt` below.

> **REPAIR NOTE (D2, 2026-07-24, post-erratum).** E2's `(:quoted-datum …)`
> constructor defect is **repaired**. Owner ruling: **`(:quoted-datum …)` is not
> a host-language escape hatch.** Slice /1 defines no broader intermediate-data
> language of its own, so a quoted payload **must belong to Canonical Datum /0**
> exactly as every other proposition part does. The three escaping classes E2
> recorded — and the rest with them — **now refuse at construction**. Read E2's
> "flow-through is false for non-boundary quoted payloads" as **repaired: such
> payloads can no longer be constructed.** Full rule under
> `proposition` / the value vocabulary below.

> **VOCABULARY RULING (D4, owner, 2026-07-24).** The word **"admissible" may not
> carry a load-bearing proof claim** in this document while it is not
> mechanically recognizable — there is no `admissible-p`, no gate, and no
> definition a stranger could execute. Where a guarantee was stated as holding
> for "admissible" supports, it is now restated naming the **actually enforced**
> boundary — values accepted by the public constructors, operations passing
> normal-form validation, witnesses passing the accessibility check, derivations
> performed through the documented front door (`derive`). The word survives only
> where it names a *domain predicate keyword* in a worked specimen
> (`:provenance-admissible`) or an *aspiration*, never where it does proof work.
> Slice /0's frozen **admissibility gate** is a different thing entirely — a real
> executable mechanism — and is unaffected.

**Package:** `lisp-plus-slice1` (use the full name).
**Load surface:** `sbcl --non-interactive --load slice1.lisp` — the file loads the
frozen `../language-slice-0/slice0-transmissibility.lisp` (which pulls in
`slice0.lisp` → `slice0-projection.lisp` → `../kernel0/load.lisp`) if Slice /0 is
not already present.
**Exported symbols:** **74** — re-enumerated live 2026-07-25 (evening) by
`do-external-symbols` over the loaded package, not by arithmetic and not by
counting export forms. *This line has now been stale twice. It printed **69**
before `CHARTER-DELTA-3` touched anything, when the live package already
exported 71 (the Sol Decision 1 and 2 readers landed without this line being
updated); Delta /3 added one, and the line was corrected to **72** — which was
already short by two at the moment it was written. The live count is **74**.
Count it live; do not derive it from this sentence. **This correction is
mechanical: nothing about Slice /1's behaviour changed, and no export was added
by any Slice /2 movement — `slice1.lisp` is byte-untouched.***

This brief is deliberately dull. Every signature below was proven by executing it
in SBCL 2.4.6, not inferred from reading. A stranger should be able to write a
program from this file alone — see `SMOKE-1.lisp` for a complete worked program
that touches only exported symbols. Slice /1 depends on Slice /0's public surface
(`claim`, `witness`, `receiver-context`, `raise`, `promotion-procedure`, …) and on
kernel0 (`make-identity`, `make-procedure-descriptor`, `identity-key`,
`identity=`); those are documented in `LANGUAGE-SLICE-0-API.md`.

## Standing notes (read first)

- **Guarantee sizing.** Every guarantee holds for **well-formed programs on the
  public (single-colon) surface.** A same-image hand-built `(:derivation …)`
  witness that skips `derive` is the acknowledged **stratum-3 host escape**
  (CHARTER-DELTA-1 Δ3), inherited from Slice /0 unchanged; the slice claims no
  host-level closure. Package internals reached by `::` are outside every claim.

- **Structured propositions are canonical Slice /0 data.** A structured
  proposition is a proper list `(:predicate <keyword> (<role-keyword> <value>) …)`
  where every value is boundary-lawful (keyword / non-empty string / integer /
  proper list thereof, plus the `(:quoted-datum <form>)` literal escape), roles
  are **unique** and **sorted at construction** by `STRING<` on `SYMBOL-NAME`.
  Because it is normal-form Slice /0 data, it flows unchanged through `claim`,
  `witness :for`, testimony `(:asserted S P)`, and projection. Atomic Slice /0
  propositions remain lawful. Bare symbols, floats, and dotted lists still refuse
  at the frozen boundary.

- **Defensive-copy discipline (AUDIT-1 repair 2, corrected by the AUDIT-1
  continuation repair for defects B1/B2).** Every **list-valued public reader** —
  on schemas, patterns, premise-assessments, and derivation-receipts — returns a
  **fresh copy** (`copy-list` for spines of immutable elements; `%copy-value`,
  which is `copy-tree` **plus `copy-seq` at every string leaf**, for structural
  values). The **construction chokepoint** (`%normal-form`, reached by
  `proposition` / `proposition-pattern` / refutation) copies the same way, and the
  `judgment-schema` constructor **snapshots** the caller's `:premises`, `:locals`
  and `:unique-locals` **spines** with `copy-list`. Scalar/struct/keyword fields
  pass through unchanged. Do not rely on `EQ` identity of a returned list — or of
  a returned **string** — across two reads.

  What this guarantees, exactly: **no caller-held cons and no caller-held string
  is aliased into stored state, in either direction.** A caller cannot revise a
  registered schema or a past receipt by mutating a list *or a string* it passed
  in or got back, and cannot erase a declared uniqueness constraint by mutating a
  constructor argument after registration. This is the "recorded, never erased"
  law made structural.

  **Declared ceiling (honest residual) — SHRUNK BY D2.** The copy walks **cons
  structure and strings** only. A `(:quoted-datum FORM)` payload rides inside the
  cons tree, so **string** leaves within it *are* detached. A payload object that
  is **neither a cons nor a string** (a vector, a hash-table, an ordinary struct,
  an adjustable non-string array) is still not detached by `%copy-value` — **but
  since D2 almost none can arrive**: such a payload does not cross the kernel0
  CD/0 codec boundary and **refuses at construction**, so it never reaches stored
  state. **The residual is not empty — it shrank to exactly one class:** a kernel0
  `durable-identity` *is* a registered canonicalization subject, so it may still
  be a quoted payload and is still undetached. That is benign for slot rewriting
  (every `durable-identity` slot is `:read-only`), so it is a declared
  **undetached object**, not a declared **mutable escape** — named precisely
  rather than rounded to zero. A general deep copy of arbitrary objects would
  remain both a contradiction of quoted-datum opacity and impossible in general
  (identity-bearing, circular and unreadable objects have no lawful copy) — which
  is why the cure is **refusal at the boundary**, not a deeper copy. (Prior text
  asserted flatly that a caller "cannot revise a registered schema or a past
  receipt"; before the B1/B2 repair that was false for strings and for constructor
  list spines. See `%copy-value` in `slice1.lisp` for the same statement at the
  source.)

- **Ordering.** Every derivation-receipt carries an `-ordinal` (from
  `*slice1-ordinal*`), the constitutive order; there is no wall clock in Slice /1.

- **Immutability.** All records use `:copier nil` and read-only slots. `derive`
  never mutates its inputs; a grant is a **new** Slice /0 claim revision whose
  lineage names the conclusion claim.

- **Three PROVISIONAL warts (honest, implementation-forced, exercised).**
  1. **Admit-kind keyword encoding (Δ1 Errata 1).** The Δ3 derivation key
     `(:derivation (:schema NAME VER))` is unconstructible because the frozen
     `witness`/`promotion-procedure` require `:kind` to be a **keyword**. It is
     encoded as one interned keyword `:|DERIVATION/<NAME>/<VER>|`, exposed via
     `judgment-schema-admit-kind`. Exactness and versioning are preserved (v1's
     keyword ≠ v2's); collision-freedom is argued in the architecture record.
  2. **Schema identity in the `:procedure` domain (Δ1 Errata 2).** kernel0's
     identity-domain list is frozen and has no `:schema`; a schema's durable
     identity is minted in `:procedure` with an encoded name `schema/NAME/VER`
     (a schema *is* a derivation procedure), exposed via
     `judgment-schema-identity`.
  3. **Introspection surface.** ~30 of the readers below are **deliberate but
     unexercised** — no consumer among the three shipped programs (`SMOKE-1.lisp`,
     `de-praemissis/SPECIMEN.lisp`, `de-admissione-datorum/SPECIMEN.lisp`) reads
     them yet (a live usage scan found **22 readers with zero shipped-program
     consumers**). They are documented and correct, but "documented and correct"
     is a weaker warrant than "exercised by a specimen"; treat the introspection
     readers as **introspection surface — no consumer among the three shipped
     programs yet**.

---

## 1. Loading + integration

Canonical prologue (a program loads the substrate once, guarded):

```lisp
(unless (find-package :lisp-plus-slice1)
  (handler-bind ((style-warning (lambda (w) (muffle-warning w))))
    (load (merge-pathnames "slice1.lisp" *load-truename*))))
```

**The single licensed `::` in Slice /1** is `lisp-plus-slice0::*why-extractors*`
— one guarded load-time `push` registering the `derivation-receipt` extractor so
`why` stays uniform across all governed acts. It is receipted in
`SLICE0-DEFECT-RECEIPT-1.md` (the frozen Slice /0 package exports no public
registration point). Registration is **idempotent**: reloading `slice1.lisp`
installs no duplicate (the extractor list grows to exactly 3 total — projection,
transmission, derivation — and stays there). No other internal Slice /0 access is
taken.

---

## 2. Structured propositions

### `proposition` — construct a GROUND structured proposition (constructor)

```
(proposition form) => normal-form-list
```

- **Act:** Validate `form` = `(:predicate <keyword> (<role> <value>) …)`, refuse
  duplicate roles and any raw `(:var …)`, sort role pairs deterministically,
  structurally copy every value — `%copy-value`, so **neither a caller cons nor a
  caller string is aliased in** (§1 ceiling, as shrunk by D2: a non-cons,
  non-string `:quoted-datum` payload can no longer be constructed, except a
  kernel0 `durable-identity`).
  Idempotent — its output is a lawful input.
- **Result:** canonical Slice /0 data (a list), not a struct.
- **Refusal:** `malformed-structured-proposition` — non-`:predicate` head,
  non-keyword predicate/role, duplicate role, raw `(:var …)` in ground, empty
  string, float, dotted list — **and (D2) the same non-canonical classes when
  placed behind `(:quoted-datum …)`**, which is not an exemption.
- **Example (VERIFIED)** — roles sort at construction:
  ```lisp
  (proposition '(:predicate :entry-complete (:entry "e-88") (:checklist "CL-full")))
  ;; => (:PREDICATE :ENTRY-COMPLETE (:CHECKLIST "CL-full") (:ENTRY "e-88"))
  ```
- **Refusal example (VERIFIED)** — a raw variable in ground data:
  ```lisp
  (handler-case (proposition '(:predicate :p (:x (:var :x))))
    (malformed-structured-proposition (c) (slice1-condition-offending-field c)))
  ;; => :PROPOSITION
  ```
- **Refusal example (VERIFIED)** — a duplicate role:
  ```lisp
  (handler-case (proposition '(:predicate :p (:x 1) (:x 2)))
    (malformed-structured-proposition (c) (slice1-condition-failed-invariant c)))
  ;; => "duplicate role :X — roles must be unique (refused before normalization completes)"
  ```
- **Literal escape (VERIFIED)** — `(:quoted-datum FORM)` is opaque ground data,
  never interpreted (its var-shaped payload stays literal):
  ```lisp
  (proposition '(:predicate :p (:x (:quoted-datum (:var :x)))))
  ;; => (:PREDICATE :P (:X (:QUOTED-DATUM (:VAR :X))))   ; normal-form-p => T
  ```

  **The payload must be Canonical Datum /0 (D2, VERIFIED).** The quoted escape is
  **not a host-language escape hatch**. It buys exactly one thing: literal data
  whose *shape* would otherwise be read as a variable. It does **not** buy
  exemption from the boundary — opacity of *meaning* is not exemption from CD/0
  *membership*, and Slice /1 defines no broader intermediate-data language of its
  own. Payloads the governing boundary rejects **refuse at construction** with
  `malformed-structured-proposition`, behind the tag exactly as in front of it:

  | Payload | Behind `:quoted-datum` |
  |---|---|
  | keyword, integer, non-empty string, proper list thereof | **accepted** |
  | `(:var :x)` and other var-shaped literal lists | **accepted** — a proper list of keywords is fine at the boundary; this is Δ5's actual purpose and it survives |
  | float | **refused** |
  | bare host symbol | **refused** |
  | dotted list | **refused** |
  | hash table | **refused** |
  | host vector / non-string array | **refused** |
  | empty string | **refused** |
  | ordinary host struct | **refused** |
  | kernel0 `durable-identity` | **accepted** — a *registered* canonicalization subject, so it genuinely crosses the boundary |

  Note the last row: the rule is **"only what the kernel0 codec admits"**, *not*
  the tidier-but-false "no struct may be a quoted payload". An identity is
  CD/0-crossing by construction and is admitted. Teeth T28k / T28l pin both
  sides.

  ```lisp
  (handler-case (proposition '(:predicate :p (:r (:quoted-datum 1.5d0))))
    (malformed-structured-proposition (c) (slice1-condition-failed-invariant c)))
  ;; => "a (:quoted-datum FORM) payload must be Canonical Datum /0; 1.5d0 is not
  ;;     and does not cross the governing kernel0 canonicalization boundary. …"
  ```

  **The check delegates; it does not define.** Slice /1 encodes **no vocabulary
  of its own** here — it calls the kernel0 **codec boundary**,
  `lisp-plus-kernel0:require-canonical`, which is the same function Slice /0's
  own `%require-proposition` calls on every proposition leaf. It is used as a
  **discard-result probe**: the question asked is *"would this payload cross?"*,
  and the converted datum is **thrown away**, because a quoted payload is
  literal data and must never be silently rewritten. A lawful payload is stored
  **verbatim**, un-normalized and un-converted. (`lisp-plus-cd0:datum-p` is
  *not* the boundary predicate and is not used: it recognizes constructed CD/0
  datum *objects*, returning `nil` for every host value a caller can write —
  including `(:var :x)`. `require-canonical` calls it only as an
  already-converted fast path.)

  The boundary holds in **patterns** as well as ground data — both route through
  the one construction chokepoint. Teeth: T28a–T28g (refusals), T28h/T28i
  (guards: the lawful payloads, including `(:var :x)`, still pass), T28j (the
  literal survives verbatim) in `slice1-selftest.lisp`.

  **Deferred exposure (pre-existing, not introduced by D2).** A **circular** or
  pathologically deep payload diverges inside `require-canonical`'s own recursion
  rather than refusing. Slice /1 has no cycle or depth guard anywhere; this probe
  inherits that exposure unchanged and does not widen it. Cycle/depth handling
  remains an owner-deferred open item.

### `structured-proposition=` — equality of ground propositions

```
(structured-proposition= a b) => boolean
```

- **Act:** `EQUAL` on normal forms (the frozen `proposition=` is not exported;
  normal-form `EQUAL` is the documented semantics). Role-order insensitive because
  both operands are normalized.
- **Example (VERIFIED):** two role-permuted constructions are `=`; a different
  proposition is not.
  ```lisp
  (structured-proposition=
    (proposition '(:predicate :entry-complete (:entry "e-88") (:checklist "CL-full")))
    (proposition '(:predicate :entry-complete (:checklist "CL-full") (:entry "e-88")))) ; => T
  ```

### `normal-form-p` — predicate

```
(normal-form-p x) => boolean
```

True when `x` is structurally a normal-form ground proposition (`(equal x
(proposition x))`, errors swallowed). VERIFIED: `T` for a normalized proposition.

### `proposition-pattern` — construct a PATTERN (constructor)

```
(proposition-pattern form) => proposition-pattern   ; a struct, NOT a proposition
```

- **Act:** Like `proposition`, but `(:var <keyword>)` is admitted at any value
  position (its variables are collected). A pattern is a **distinct object** and
  can never stand as a ground claim/support/refutation (constructor-level refusal
  downstream). Valid only inside a schema's conclusion/premise slots.
- **Refusal:** `malformed-structured-proposition` for bad shape/vocabulary.
- **Example (VERIFIED):**
  ```lisp
  (let ((p (proposition-pattern '(:predicate :entry-complete
                                   (:entry (:var :entry)) (:checklist (:var :checklist))))))
    (list (proposition-pattern-p p)                         ; => T
          (sort (proposition-pattern-variables p) #'string< :key #'symbol-name))) ; => (:CHECKLIST :ENTRY)
  ```

Readers (both **defensive-copy**, AUDIT-1 repair 2 + extension):

| Reader | Returns |
|---|---|
| `proposition-pattern-p` | type predicate |
| `proposition-pattern-normal-form` | fresh `%copy-value` copy of the pattern's normal form — `copy-tree` **plus `copy-seq` at string leaves** (vars kept); §1 ceiling applies |
| `proposition-pattern-variables` | fresh list of the pattern's variable keywords |

VERIFIED `proposition-pattern-normal-form`:
`(:PREDICATE :ENTRY-COMPLETE (:CHECKLIST (:VAR :CHECKLIST)) (:ENTRY (:VAR :ENTRY)))`.

---

## 3. Judgment schemas + registry (governed constructors + registry ops)

### `judgment-schema` — a versioned derivation schema (constructor)

```
(judgment-schema &key name version conclusion premises locals unique-locals)
  => judgment-schema
```

- **Act:** Build a schema: `name` a keyword, `version` a nonnegative integer,
  `conclusion` and each `premises` entry a `proposition-pattern`, `locals` the
  schema-local variables (may occur ONLY in premise patterns), `unique-locals`
  (CHARTER-DELTA-2) the uniqueness-bearing subset of `:locals`. Conclusion
  variables are implicit. Mints the durable identity and the admit-kind.
- **Refusals (all `schema-construction-error`):** non-keyword name; negative/
  non-integer version; conclusion/premise not a pattern; a schema-local occurring
  in the conclusion; an **undeclared** premise variable; a `unique-local` that is
  a conclusion variable, not a declared local, or duplicated.
- **Example (VERIFIED):** see `install-schemas` in `SMOKE-1.lisp`.
- **Refusal example (VERIFIED)** — undeclared premise variable:
  ```lisp
  (handler-case
      (judgment-schema :name :bad :version 1
        :conclusion (proposition-pattern '(:predicate :c (:a (:var :a))))
        :premises (list (proposition-pattern '(:predicate :d (:a (:var :a)) (:z (:var :z))))))
    (schema-construction-error (c) (slice1-condition-failed-invariant c)))
  ;; => "undeclared variable :Z in a premise pattern — declare it in :locals or bind it through the conclusion"
  ```
- **Refusal example (VERIFIED)** — a `unique-local` that is not a declared local:
  ```lisp
  (handler-case
      (judgment-schema :name :bad2 :version 1
        :conclusion (proposition-pattern '(:predicate :c (:a (:var :a))))
        :premises (list (proposition-pattern '(:predicate :d (:a (:var :a)))))
        :unique-locals '(:q))
    (schema-construction-error (c) (slice1-condition-failed-invariant c)))
  ;; => ":Q is declared unique but is not a schema-local (:locals); a uniqueness-bearing variable must first be a declared local"
  ```

Accessors (VERIFIED against a registered schema; **PROVENANCE / warts noted**):

| Accessor | Returns | Copy |
|---|---|---|
| `judgment-schema-p` | predicate | — |
| `judgment-schema-name` | keyword | scalar |
| `judgment-schema-version` | integer | scalar |
| `judgment-schema-identity` | kernel0 durable identity in the **`:procedure`** domain — **wart 2**: `identity-key` ⇒ `"procedure:schema/NOTEBOOK-SIGNOFF-AUTHORITY/1"` | struct |
| `judgment-schema-conclusion` | the conclusion `proposition-pattern` | struct |
| `judgment-schema-premises` | fresh list of premise `proposition-pattern`s | copy |
| `judgment-schema-locals` | fresh list of declared locals | copy |
| `judgment-schema-unique-locals` | fresh list of uniqueness-bearing locals ⇒ `(:AUTHORITY)` | copy |
| `judgment-schema-conclusion-variables` | fresh list of conclusion vars ⇒ `(:ENTRY :PURPOSE :REVIEWER)` | copy |
| `judgment-schema-admit-kind` | the encoded derivation key keyword — **wart 1**: ⇒ `:DERIVATION/NOTEBOOK-SIGNOFF-AUTHORITY/1` | scalar |

VERIFIED **wart 1 exactness** — a v1 and v2 schema of the same name have distinct
admit-kinds: `:DERIVATION/X/1` vs `:DERIVATION/X/2`, `EQ` ⇒ `NIL`.

### `register-schema` — register under exact (name, version)

```
(register-schema schema) => schema
```

- **Act:** Store `schema` under `(name, version)`. Re-registering an **identical**
  schema is idempotent-OK; a **different** schema under a taken key refuses. No
  auto-latest resolution exists anywhere.
- **Refusal:** `schema-registration-conflict` (different body, taken key);
  `schema-construction-error` if `schema` is not a `judgment-schema`.
- **Refusal example (VERIFIED):**
  ```lisp
  ;; :dup v1 already registered with a different premise body
  (handler-case (register-schema <different-dup-v1>)
    (schema-registration-conflict (c) (slice1-condition-failed-invariant c)))
  ;; => "a DIFFERENT schema is already registered under (:DUP 1); (name,version) is a unique key and is never overwritten"
  ```

### `resolve-schema` — resolve by exact (name, version)

```
(resolve-schema name version) => schema
```

- **Refusal:** `schema-not-found` (typed) when absent — VERIFIED invariant:
  `"no schema registered under (:NOPE 9)"`.

### `clear-schema-registry` — empty the registry

```
(clear-schema-registry) => (image hygiene / test reset)
```

Empties the per-image registry. Call before installing a fresh schema set.

---

## 4. Refutation (constructor + readers)

### `refutation` — represented counter-evidence (constructor)

```
(refutation &key refutes source) => refutation
```

- **Act:** Name the exact **ground** proposition this record refutes (normalized +
  validated as ground). Minimal: no negation algebra, no `(:not …)`. Recorded,
  never erased; a matching refutation **blocks** its premise even beside positive
  support.
- **CHARTER-DELTA-4:** a refutation object is **one of two** refuting species. The
  other is a matching, accessible Slice /0 witness declaring `:polarity :refutes`
  (`premise-assessment-refuting-witnesses`). Both block; each keeps its own roster;
  this constructor mints only the first.
- **Refusal:** `pattern-used-as-ground` if `:refutes` is a `proposition-pattern`;
  `malformed-structured-proposition` for a malformed ground proposition.
- **Example (VERIFIED):**
  ```lisp
  (let ((r (refutation :refutes '(:predicate :provenance-admissible (:artifact "a-1")) :source :audit)))
    (list (refutation-p r)                                       ; => T
          (refutation-refutes r)                                 ; => (:PREDICATE :PROVENANCE-ADMISSIBLE (:ARTIFACT "a-1"))
          (refutation-source r)                                  ; => :AUDIT
          (lisp-plus-kernel0:identity-key (refutation-id r))))   ; => "receipt:refutation-1"
  ```
- **Refusal example (VERIFIED):** a pattern as `:refutes` ⇒ `PATTERN-USED-AS-GROUND`,
  `"a proposition-pattern cannot stand as ground REFUTES; …"`.

Readers: `refutation-p`, `refutation-refutes` (normal-form ground proposition),
`refutation-source`, `refutation-id` (durable identity, domain `:receipt`).

---

## 5. The governed act (`derive`) + transport

### `derive` — the governed derived-judgment act

```
(derive &key schema-name schema-version conclusion supports receiver by)
  => (values granted-claim derivation-receipt)   ; on grant
  ;  signals derivation-refused (carrying the receipt) ; on refusal
```

- **Act:** Resolve the schema by exact `(schema-name, schema-version)`; bind the
  conclusion variables from the **ground** `conclusion`; assess each declared
  premise over `supports` — whose **three recognized species** are Slice /0
  `witness`es, Slice /1 `refutation`s, **and Slice /0 already-judged `claim`s**
  (SOL DECISION 1, §6 below); **any other element is unsupported residue,
  recorded at the receipt and assessed against nothing** (CHARTER-DELTA-3, §6
  below) — relative to the acting `receiver` context; **issue a derivation receipt once the
  invocation is a constructible derivation attempt** — i.e. on every assessed
  path, granted or refused, and on the post-threshold `unbound-conclusion-variable`
  refusal. The three pre-threshold exits carry none (D1; see the receipt-scope
  rule at `derivation-receipt`). On full coherent discharge (a complete environment exists, no declared
  uniqueness conflict, no refutation), mint a derivation witness and drive the
  **frozen** `raise` — a real `:verified` Slice /0 promotion keyed to the schema's
  admit-kind — returning `(values claim receipt)`.
- **Inputs:** `conclusion` a **ground** structured proposition (a pattern refuses
  with `pattern-used-as-ground`); `receiver` a `receiver-context` or `nil`; `by`
  the asserting principal (optional).
- **Grant result (VERIFIED):** `derivation-receipt-decision` ⇒ `:GRANTED`;
  `(judgment-record-judgment (claim-judgment claim))` ⇒ `:VERIFIED`;
  `derivation-receipt-strongest-lawful-result` ⇒ `:VERIFIED`.
- **Refusal result (VERIFIED):** signals `derivation-refused`; the receipt on
  `slice1-condition-receipt` has decision `:REFUSED` and, for a missing premise,
  `strongest-lawful-result` ⇒ `(:BLOCKED-ON :RESULTS-REPRODUCED :MISSING)`.
- **Six premise dispositions, all VERIFIED live:**

  | Situation | `disposition` on the premise |
  |---|---|
  | discharged by an accessible matching support | `:SATISFIED` |
  | no candidate matches the predicate | `:MISSING` |
  | predicate matches, a bound role conflicts | `:MISMATCHED` (roles named) |
  | a refutation names the premise | `:REFUTED` (positive support still visible) |
  | a matching support exists but is not accessible to `receiver` | `:INACCESSIBLE` (residue) |
  | >1 value for a declared `:unique-locals` local survives | `:AMBIGUOUS` |

- **Multiplicity (VERIFIED):** two sufficient non-unique environments GRANT;
  `derivation-receipt-complete-binding-environments` ⇒ length 2;
  `derivation-receipt-multiply-supported-p` ⇒ `T`;
  `derivation-receipt-uniqueness-conflicts` ⇒ `NIL`. A declared uniqueness
  conflict on `:authority` REFUSES `:AMBIGUOUS` and names `(:AUTHORITY)`.
- **Refusal example (VERIFIED)** — an unbound conclusion variable:
  ```lisp
  (handler-case
      (derive :schema-name :notebook-signoff :schema-version 1
        :conclusion (proposition '(:predicate :entry-signed-off (:entry "e-88") (:reviewer :alice)))
        :supports '() :receiver (ctx :alice))
    (unbound-conclusion-variable (c) (slice1-condition-failed-invariant c)))
  ;; => "the requested conclusion does not ground every conclusion variable of schema (:NOTEBOOK-SIGNOFF 1); unbound: (:PURPOSE :REVIEWER :ENTRY); match status: :ROLE-SET-MISMATCH"
  ```

### `transported-testimony` — Δ4 receipt → testimony support

```
(transported-testimony receipt &key context-a) => witness
```

- **Act:** Turn a (transmitted) derivation receipt into a **testimony** support
  witness: `:mode :testimony`, `:kind :derivation-report`, `:for` the attribution
  `(:asserted <context-a> (:predicate :derived (:schema …) (:version …)
  (:conclusion …)))`. It is evidence *that* a derivation was performed — **it
  cannot masquerade as a local derivation.**
- **Refusal:** `malformed-structured-proposition` if `receipt` is not a
  `derivation-receipt`.
- **Example (VERIFIED):** mode ⇒ `:TESTIMONY`, kind ⇒ `:DERIVATION-REPORT`,
  `witness-for` ⇒ `(:ASSERTED :ALICE (:PREDICATE :DERIVED (:SCHEMA :NOTEBOOK-SIGNOFF)
  (:VERSION 1) (:CONCLUSION (:PREDICATE :ENTRY-SIGNED-OFF …))))`.
- **Live gate (VERIFIED):** offered to a derivation-keyed conclusion procedure at
  another receiver, the frozen `raise` refuses it with
  `wrong-proposition-support` (its `:for` is the attribution, not the conclusion).

---

## 6. Receipt + assessment readers

Every list-valued reader below is **defensive-copy** (AUDIT-1 repair 2, deepened
by the B1 repair): a held receipt or assessment can never be silently rewritten
through a returned list **or through a returned string** — the `copy-tree` rows
below are `%copy-value`, i.e. `copy-tree` plus `copy-seq` at string leaves.
Subject to the declared ceiling in §1 — as shrunk by D2: a non-cons, non-string
`:quoted-datum` payload can no longer be constructed, **except** a kernel0
`durable-identity`, which the codec admits and which stays undetached (read-only
slots). Struct leaves are shared, as before.

### `derivation-receipt` — issued for every CONSTRUCTIBLE derivation attempt

**Receipt scope (D1-corrected; supersedes the "every attempt" promise).** A
receipt is issued for:

1. **every derivation that reaches premise assessment** — granted or refused
   (returned as the second value on grant; carried on `derivation-refused`); and
2. the **post-threshold** `unbound-conclusion-variable` refusal — the schema
   *was* resolved and the conclusion *is* a lawful normal form, so the attempted
   derivation is identifiable even though no premise was assessed. Its receipt
   records only what is known there: resolved schema name/version, the lawful
   conclusion, the acting origin context, `decision` ⇒ `:REFUSED`, and **empty
   assessment structure** (`assessments`, `bindings`,
   `complete-binding-environments`, `uniqueness-conflicts`,
   `strongest-lawful-result`, `repair-options` all `nil` — and, since Δ3,
   `unsupported-supports` too: `:supports` is not classified on this path, so an
   unsupported value there does not give this receipt a field it did not earn).
   Nothing is invented.

A receipt is **not** issued for the three **pre-threshold** exits —
`pattern-used-as-ground`, `schema-not-found`, `malformed-structured-proposition`.
These fire before a derivation is constructible (no schema, or no lawful
conclusion); they are lawful typed pre-derivation failures and `nil` on
`slice1-condition-receipt` is the correct, honest answer. Teeth: T27a/T27b
(post-threshold receipt) and T27c (pre-threshold silence) in
`slice1-selftest.lisp`.

`derivation-receipt-p` is the predicate. Readers:

| Accessor | Returns | Copy |
|---|---|---|
| `derivation-receipt-schema-name` | the requested schema name | scalar |
| `derivation-receipt-schema-version` | the requested version | scalar |
| `derivation-receipt-conclusion` | the ground conclusion (normal form) | copy-tree |
| `derivation-receipt-bindings` | the first complete environment (alist), or `nil` when refused | copy-tree |
| `derivation-receipt-complete-binding-environments` | **all** complete coherent environments (Δ2) | copy-tree |
| `derivation-receipt-uniqueness-conflicts` | `(local sorted-values carrying-envs)…` (Δ2) | copy-tree |
| `derivation-receipt-multiply-supported-p` | derived VIEW: `t` iff >1 complete environment | boolean |
| `derivation-receipt-assessments` | list of `premise-assessment` (one per premise) | copy-list |
| `derivation-receipt-decision` | `:granted` \| `:refused` | scalar |
| `derivation-receipt-strongest-lawful-result` | `:verified`, or `(:blocked-on <pred> <disposition>)` | copy-tree |
| `derivation-receipt-repair-options` | `(premise-pattern . repair-form)` per unsatisfied premise | copy-tree |
| `derivation-receipt-unsupported-supports` | `(:index N :reason :unsupported-support-species)…`, or `nil` (Δ3) | copy-tree |
| `derivation-receipt-identity` | fresh `:receipt` identity per attempt (distinct across re-derivations) | struct |
| `derivation-receipt-origin-context` | the deriving context-id, or `nil` | scalar |

**Never a boolean summary of "all premises present"** — the assessments carry the
per-premise structure themselves (charter §6). VERIFIED `repair-options` for a
missing premise: `((… :SUPPLY-ACCESSIBLE-SUPPORT-MATCHING …) …)` when the premise
has exactly one grounding environment; `:SUPPLY-ACCESSIBLE-SUPPORT-MATCHING-ANY-OF`
carrying **all** of them when it has several (SOL DECISION 2 — the advice never
picks one to keep the old key's shape). When judged claims were seen but did not
discharge, the same entry additionally carries
`:JUDGED-CLAIMS-SEEN-BUT-NOT-DISCHARGING ((claim-key outcome) …)` (SOL DECISION 1).

### `premise-assessment` — the per-premise structured object (Δ2)

`premise-assessment-p` is the predicate. Readers (VERIFIED against a `:missing`
premise unless noted):

| Accessor | Returns | Copy |
|---|---|---|
| `premise-assessment-premise-pattern` | the premise pattern's normal form | copy-tree |
| `premise-assessment-projected-premise-instances` | **(CHARTER-DELTA-4 — the PRECISE name)** the canonical SEQUENCE of this premise's **conclusion-projected premise instances**: the premise pattern with the bindings available *on entry to this premise* substituted (conclusion bindings, plus any schema-local bound by an **earlier** premise), with schema-locals *this* premise binds left as **variables**. Deduplicated only on byte-identical canonical encodings, ordered lexicographically by canonical encoded bytes. A one-element sequence when there is exactly one — never a bare instance. **NOT the complete binding environment set, and no bound on its cardinality in either direction** | copy-tree |
| `premise-assessment-ground-instances` | **LEGACY PROJECTION READER** (CHARTER-DELTA-4). Identical in value, shape and copy behaviour to `premise-assessment-projected-premise-instances`, whose row above is authoritative. Retained, operational, never repurposed to return complete environments, never removed. The name is a compatibility name: SOL DECISION 2's normative complete set is the **complete binding environment set**, read at `premise-assessment-binding-environments` and `derivation-receipt-complete-binding-environments` | copy-tree |
| `premise-assessment-ground-instance` | **LEGACY SINGULAR PROJECTION READER** — a compatibility projection over the row above, and nothing more. The sole **projection** when the sequence has exactly one; `NIL` when it is empty; **REFUSES (typed `slice1-condition`) above cardinality one** and will not select one. It never returns sometimes-one-sometimes-a-sequence. **IT DOES NOT PROTECT COMPLETE-ENVIRONMENT PLURALITY** (CHARTER-DELTA-4): it *answers* whenever the projection is singular — the ordinary case for a premise that binds a schema-local — while several complete environments stand preserved in the same receipt. Its refusal guards the **projection's** cardinality only, and **is reachable in ordinary use** on any premise entered with a local already bound | copy-tree |
| `premise-assessment-judged-claims` | **(SOL DECISION 1)** the per-premise judged-claim roster: one plist per judged claim offered in `supports` and considered for this premise — `(:CLAIM-ID id :OUTCOME kw [:ROLES …] [:JUDGMENT kw] [:PROCEDURE-ID id :PROCEDURE-VERSION v :SUPPORT-IDS … :JUDGMENT-RECEIVER … :JUDGMENT-ORDINAL …])`. `OUTCOME` ∈ `:DISCHARGED` · `:PROPOSITION-DOES-NOT-MATCH` · `:ROLE-CONFLICT` · `:UNJUDGED` · `:JUDGMENT-NOT-VERIFIED` · `:JUDGMENT-BASIS-UNAVAILABLE` · `:INACCESSIBLE-TO-RECEIVER`. The judgment-basis fields appear exactly on `:DISCHARGED` entries | copy-tree |
| `premise-assessment-matching-accessible-supports` | witnesses that matched the premise pattern, passed the accessibility check (their `witness-id` is in the acting `receiver-context`'s `accessible-supports`, or `receiver` was `nil`), **and declare `:polarity :supports`** (CHARTER-DELTA-4). This roster is **positive support only**: a matching accessible witness declaring `:refutes` is *never* here — it is in `premise-assessment-refuting-witnesses`. Before Delta /4 it was here, and discharged | copy-list |
| `premise-assessment-matching-inaccessible-supports` | matched witnesses the receiver cannot reach (residue) | copy-list |
| `premise-assessment-mismatched-candidates` | `(witness . conflicting-roles)` conses | copy-tree |
| `premise-assessment-refuting-supports` | Slice /1 **refutation objects** naming this premise. Contract **unchanged and deliberately homogeneous** (CHARTER-DELTA-4): refutations, and only refutations — `%repair-for` reads `refutation-id` off its elements. **NOT the whole of the refuting evidence:** see the next row. A premise is `:REFUTED` on the **union** | copy-list |
| `premise-assessment-refuting-witnesses` | **(CHARTER-DELTA-4 / R-POLARITY-1 — new)** matching, receiver-**accessible** Slice /0 witnesses whose declared polarity is `:refutes`. Classified **before** positive matching support accumulates: such a witness never enters `matching-accessible-supports`, never discharges, never extends a binding environment, never reaches `complete-binding-environments` — and stays fully inspectable **here**. Precedence follows the refutation species: support + accessible matching `:refutes` ⇒ `:REFUTED`, with both rosters visible. **Accessibility and matching come first:** an *inaccessible* `:refutes` witness is `:INACCESSIBLE` residue and a *role-conflicting* one is `:MISMATCHED`; neither is applied as refutation | copy-list |
| `premise-assessment-binding-environments` | distinct schema-local deltas this premise admits | copy-tree |
| `premise-assessment-ambiguities` | `(local surviving-values)` when `:ambiguous`, else `()` | copy-tree |
| `premise-assessment-disposition` | one of the six (§5) | scalar |

VERIFIED (missing case): `premise-pattern` ⇒
`(:PREDICATE :RESULTS-REPRODUCED (:ENTRY (:VAR :ENTRY)) (:REPLICATE (:VAR :REPLICATE)))`;
`ground-instances` ⇒ a ONE-element sequence whose sole element is
`(:PREDICATE :RESULTS-REPRODUCED (:ENTRY "e-88") (:REPLICATE (:VAR :REPLICATE)))`
(the conclusion-bound `:entry` is substituted, the schema-local `:replicate` is
not), and `ground-instance` therefore still returns that instance;
`disposition` ⇒ `:MISSING`; the four support lists ⇒ `NIL`.

### SOL DECISION 1 — a judged claim is a first-class support kind

`derive`'s `:supports` accepts **Slice /0 witnesses, Slice /1 refutations, and
Slice /0 CLAIMS.** A claim used to fall through all filters and be silently
discarded; it is now considered for every premise and **recorded in
`premise-assessment-judged-claims` per premise whatever becomes of it.**

> **Extended by `CHARTER-DELTA-3`.** These three remain the only **recognized**
> species — the delta admits nothing new. What it fixes is the *rest* of
> `:supports`: an element outside the three was still silently discarded after
> this decision landed, and is now recorded at the receipt as inert residue. See
> the Delta /3 section below. **Visibility is not admissibility.**

A claim **discharges** a premise only through an *identity-bearing reference to
its own governed judgment* — all seven ruling conditions: durable claim identity ·
receiver-accessible (the same id-membership rule as a witness, read against
`claim-id`) · a positive `:verified` judgment · normalized judged proposition
matching the required ground premise under the incoming bindings · the judgment
record read off *that exact claim* (the linkage is structural, so it cannot be
forged) · claim identity **and** judgment basis recorded in the receipt · the
original judgment left inspectable and never converted into a minted witness.

There is **no schema, `procedure-id`, mode, or kind compatibility rule.**
`procedure-id` is *recorded provenance, never a hidden compatibility selector*.
No recursion is introduced: the supporting judgment must already exist.

A claim that matches but is unjudged, `:refuted`, or basis-less leaves the
premise `:MISSING` (the six §5 dispositions are unchanged — no seventh status is
minted) **and is named in the roster and in the repair advice**, which no longer
tells the programmer to supply what the programmer supplied. An inaccessible
matching claim is `:INACCESSIBLE` residue; one with conflicting roles is
`:MISMATCHED`.

### CHARTER-DELTA-3 — an unrecognized `:supports` element is recorded, not discarded

**Superseded here:** any statement in this document or the charter that describes
`:supports` handling without naming the residue. **Governing text:
`CHARTER-DELTA-3.md`.**

`:supports` has exactly **three recognized species** — Slice /0 witness · Slice /1
refutation · Slice /0 claim. Every element is classified **exactly once**; anything
outside the three is **unsupported residue**. Before Delta /3 such an element fell
through three independent filters and was **silently discarded**: through every
public reader, supplying it was indistinguishable from supplying nothing. It is now
recorded at the **invocation-level receipt** — never per premise, because an
unrecognized object cannot be meaningfully matched against an individual premise.

```
(derivation-receipt-unsupported-supports RECEIPT)
  => nil, or ((:index N :reason :unsupported-support-species) …)
```

- **Index base:** `N` is **zero-based** in the caller's own `:supports` list.
- **Order and duplicates:** caller input order, **duplicates preserved** — the
  receipt records what was supplied, not a set.
- **No raw object retained.** Not the object, not `type-of`, not the printed
  representation, not `sxhash`, not an address-like identity, not implementation
  class metadata, not a host pointer. An arbitrary host object may be mutable,
  circular, unreadable, noncanonical or identity-bearing; the slice does not
  pretend to durably snapshot one.
- **Copy behaviour:** the reader returns a **defensive structural copy**
  (`copy-tree` + `copy-seq` at string leaves, the AUDIT-1 repair-2 discipline).
  Mutating a returned list **or any plist inside it** cannot revise the stored
  receipt; two reads are structurally `equal` and need not be `eq`. The slot is
  read-only and **no public constructor is added.**
- **The exact ceiling:** *the receipt proves an unsupported value was supplied,
  where it appeared, and that it had no semantic effect. It does not preserve or
  identify arbitrary unsupported host data after the call.*

**Decision non-effect — observational, not dispositive.** Residue cannot discharge
a premise, refute one, bind a variable, create or resolve ambiguity, or authorize a
grant, and it is **never** silently converted into `:missing`:

| supplied | outcome |
|---|---|
| recognized support alone | the existing decision |
| recognized support + unsupported | the **same** decision and dispositions, residue additionally recorded |
| unsupported alone | premise stays `:MISSING`, but the receipt differs **observably** from supplying nothing |

An unsupported object does **not** become a "mismatched candidate" (that means a
recognized proposition-bearing candidate with conflicting roles), does **not**
become "inaccessible" (that applies to recognized identity-bearing species), and
does **not** enter `premise-assessment-judged-claims`. **No seventh premise
disposition; no new condition family.** The **pre-assessment** exits are unchanged
— and the post-threshold `unbound-conclusion-variable` receipt, issued before
`:supports` is classified at all, carries **no** residue.

`render-derivation-why` names receipt-level residue on **granted and refused**
receipts alike; **the structured reader, not the prose, is authoritative.**

VERIFIED live: `(list 17 W)` with `W` a matching accessible witness ⇒ decision
unchanged from `W` alone and `derivation-receipt-unsupported-supports` ⇒
`((:INDEX 0 :REASON :UNSUPPORTED-SUPPORT-SPECIES))`; `(list uA W uB uA)` ⇒ indices
`(0 2 3)`, no deduplication. Teeth: **U1–U12** in `slice1-selftest.lisp`, U12
restoring the pre-Delta-3 three-filter implementation and showing the cluster fail
on the exact disappearance defect.

### SOL DECISION 2 — grounding multiplicity is preserved, never selected

**Disposition and grounding multiplicity are separate axes.** Several complete
environments may support one disposition; that plurality is evidence and is kept.
Canonical form: bindings arranged by the schema's **declared variable order**
(conclusion variables as recorded at construction, then declared `:locals`) ·
each bound value crossing the governing CD/0 boundary · the whole environment
encoded through the canonical datum codec (`lisp-plus-kernel0:require-canonical`
→ `lisp-plus-cd0:encode-exact`) · environments ordered lexicographically by those
**canonical encoded bytes** · deduplicated **only** on byte-identical encodings.
Printed representation, host hash-table iteration, support traversal order, host
symbol order, object identity, and implementation-specific comparison are all
excluded — the ordering is read off the codec's octets directly.

This also governs `derivation-receipt-complete-binding-environments`,
`premise-assessment-binding-environments`, and the surviving-value sequence in
`derivation-receipt-uniqueness-conflicts`.

---

### CHARTER-DELTA-4 — witness direction, and the grounding name

**Governing text: `CHARTER-DELTA-4.md` (2026-07-25, owner-adopted).** Two narrow
rulings. **Superseded here:** any statement in this document, the charter, the
architecture, the guide or the closure that (a) describes premise discharge as
reading only `witness-for` and receiver accessibility, or (b) treats
`ground-instance(s)` as the complete grounding/environment set.

#### R-POLARITY-1 — polarity is load-bearing direction

*Prospective, not retroactive:* `witness-polarity` appeared in **no** Slice /1
governing document before this delta; meaning is assigned from adoption onward.

| condition | result |
|---|---|
| matching + accessible + `:supports` | candidate positive support |
| matching + accessible + `:refutes` | **REFUTING EVIDENCE** |
| matching + **INACCESSIBLE** | `:INACCESSIBLE`, regardless of polarity |
| proposition **MISMATCH** | `:MISMATCHED`, regardless of polarity |

A `:refutes` witness never discharges a positive premise, never appears as positive
corroboration, never increases the positive matching-support count, and never
contributes a binding environment. Precedence follows the refutation species:
`supporting witness + accessible matching :refutes ⇒ :REFUTED`. A premise is
`:REFUTED` on the **UNION** of `premise-assessment-refuting-supports` (refutation
objects) and `premise-assessment-refuting-witnesses` (new). `%repair-for` emits
`:withdraw-or-answer-refuting-witness` for the second species; advice for a premise
refuted only by refutation objects is **byte-identical** to its pre-delta form.

**THE CEILING.** This ruling **does not solve premise-source admission**, and must
not be read as doing so. **`admissible` remains undefined** as a general source
contract (E4 stands). `mode`, `kind`, `source`, `procedure`, `content`,
`transmissible` and `accessible-to` are **not** admission gates. Receiver-context
`accessible-supports` remains the **sole** Slice /1 accessibility rule. No assertion
is bound to any real observation or effect: a witness declaring `:supports` over a
fabricated account still discharges. **It forbids one inversion and nothing more.**

#### R-GROUNDING-NAME-1 — Decision 2 names complete environments

SOL DECISION 2's **substance stands** (see the section above); the **word**
`ground-instances` is corrected as a **name**. Naming/API clarification — **not** a
collapse of the complete set.

- The **normative complete set** is the **complete binding environment set**:
  `premise-assessment-binding-environments`,
  `derivation-receipt-complete-binding-environments`. Decision 2's ordering and
  dedup law applies to *that* set, and the implementation always preserved it.
- What `ground-instance(s)` return is a **conclusion-projected premise instance**.
  Precise name: `premise-assessment-projected-premise-instances` (alias, same
  value). The legacy names are **legacy projection readers** — retained, operational,
  never repurposed, never removed. **No receipt-level alias** is added, because no
  public receipt-level ground-instance reader exists.
- **No complete environment may be arbitrarily selected**, by any rule whatsoever.

**THREE INDEPENDENT AXES, none a bound on another:**

| axis | reader | note |
|---|---|---|
| 1. projected-premise multiplicity | `projected-premise-instances` (legacy `ground-instances`) | may read **1** while axis 2 reads **3** |
| 2. complete-environment plurality | `binding-environments` / `complete-binding-environments` | **NORMATIVE** |
| 3. ambiguity | `ambiguities` / `uniqueness-conflicts` | from declared `:unique-locals` only |

Measured, one-premise schema, three supports differing only in the local:
`complete-envs 3` · `binding-environments 3` · **`projection 1`** · `ambiguities 0`.
Declaring the local unique moves **only** axis 3. **The singular projection reader
does not protect complete-environment plurality**, and its refusal — which guards
the projection's cardinality only — **is reachable in ordinary use**.

---

## 7. Explanation (`why`, `render-derivation-why`)

### `why` — the Slice /1 façade over the uniform explanation act

```
(why object) => object   ; a derivation-receipt explains itself; else delegates to slice0
```

- **Act:** For a `derivation-receipt`, returns the receipt (its own structured
  fields are the explanation). For anything else, delegates to
  `lisp-plus-slice0:why` — so `why` stays the one uniform door across promotion,
  projection, transmission, and derivation.
- **Example (VERIFIED):** `(eq (why r) r)` ⇒ `T` for a derivation-receipt `r`.

### `render-derivation-why` — prose from receipt fields only

```
(render-derivation-why receipt &optional (stream t)) => receipt
```

- **Act:** Print the decision, schema id+version, environment plurality, any
  declared uniqueness conflict, each premise + disposition (with mismatched roles,
  inaccessible residue, refuting ids, ambiguous candidates), and a repair per
  unsatisfied premise — **each drawn strictly from the receipt's own fields.**
- **Refusal:** `malformed-structured-proposition` if not a receipt.
- **Example (VERIFIED)** output (2 satisfied, 2 missing):
  ```
  [derivation REFUSED] schema :NOTEBOOK-SIGNOFF v1
    premise :ENTRY-COMPLETE: SATISFIED
    premise :RESULTS-REPRODUCED: MISSING
    premise :REVIEWER-QUALIFIED: SATISFIED
    premise :PURPOSE-PERMITTED: MISSING
    repair for :RESULTS-REPRODUCED: (:SUPPLY-ACCESSIBLE-SUPPORT-MATCHING …)
    repair for :PURPOSE-PERMITTED:  (:SUPPLY-ACCESSIBLE-SUPPORT-MATCHING …)
  ```

---

## 8. Conditions + the signalling path

### Family tree

```
error
 └── slice1-condition                 (base; abstract — signal a leaf, not this)
      ├── malformed-structured-proposition
      ├── pattern-used-as-ground
      ├── schema-construction-error
      ├── schema-registration-conflict
      ├── schema-not-found
      ├── unbound-conclusion-variable
      └── derivation-refused
```

Slice /1's condition layer is **parallel to** Slice /0's (not a subtype): Slice
/0's `signal-slice0` enforces the frozen §9 restart whitelist, which is irrelevant
to derived judgment. Slice /1 has **no restarts** — a refusal is a signalled typed
condition carrying the receipt; the lawful repairs are named as *data* in the
receipt's `repair-options`, not established as `restart-case` clauses.

### `slice1-condition` base readers

Every condition carries these (`nil` where inapplicable):

| Reader | Carries |
|---|---|
| `slice1-condition-failed-invariant` | non-empty string describing the broken invariant |
| `slice1-condition-offending-field` | the field key at fault |
| `slice1-condition-offending-value` | its offending value |
| `slice1-condition-receipt` | the derivation receipt of the refused attempt — on `derivation-refused` **and** on `unbound-conclusion-variable` (both post-threshold); `nil` on the three pre-threshold exits, where a receipt would be a fiction |

The `:report` prints `TYPE: failed-invariant`.

### Condition types — who signals, what it names

| Condition | Signaled by | Names | Receipt? |
|---|---|---|---|
| `malformed-structured-proposition` | `proposition`, `proposition-pattern`, `transported-testimony`, `render-derivation-why` | bad shape/vocabulary; duplicate role; raw `(:var …)` in ground | **no** — pre-threshold |
| `pattern-used-as-ground` | `refutation`, `derive` (conclusion) | a pattern where ground data is required | **no** — pre-threshold (fires before schema resolution) |
| `schema-construction-error` | `judgment-schema`, `register-schema` | undeclared/duplicate variable; bad unique-local; wrong argument type | **no** — not a derivation act |
| `schema-registration-conflict` | `register-schema` | a different schema under a taken `(name, version)` | **no** — not a derivation act |
| `schema-not-found` | `resolve-schema`, `derive` | no schema at `(name, version)` | **no** — pre-threshold (schema resolution failed) |
| `unbound-conclusion-variable` | `derive` | the conclusion does not ground every conclusion variable | **YES** — post-threshold; carries a `:refused` receipt with empty assessment structure (D1) |
| `derivation-refused` | `derive` | a derivation that did not fully discharge — **carries the receipt** | **YES** — post-assessment |

### `signal-slice1` — LOW-LEVEL IMPLEMENTATION SUPPORT (not a language operation)

> **RULING (D5, owner, 2026-07-24).** `signal-slice1` **is not a Lisp+ language
> operation.** It is low-level implementation support — the layer's internal
> signalling path — and is documented here only because it is currently
> exported. **Invoking it is not participation in the governed Slice /1
> language:** it constructs and raises a condition directly, bypassing every
> governed act (`proposition`, `judgment-schema`, `derive`, …), so nothing it
> signals is evidence that a derivation was attempted, refused, or assessed. Do
> not read a hand-signalled `derivation-refused` as a derivation result. The
> ordinary public forms are the ones listed in §2; use those.
>
> The export is **retained** — removing it awaits a separately authorized
> surface revision, and this note is not that authorization.

```
(signal-slice1 condition-type &rest initargs &key failed-invariant &allow-other-keys)
```

- **Act:** Contract-check, then `error` a `slice1-condition`.
- **Enforced:** `failed-invariant` must be a non-empty string; `condition-type`
  must be a subtype of `slice1-condition`. A violated contract is a plain `error`,
  not a `slice1-condition`. Programs normally *receive* conditions from
  `derive`/constructors; call this directly only when extending the layer.

---

*Verified against: 2026-07-23 · SBCL 2.4.6. The exported-symbol list (69) was read
live from the package via `do-external-symbols`. Every example in this brief was
executed under this build. Suites re-run after writing (no source changed):
`sbcl --non-interactive --load slice1-selftest.lisp` → "50 passed, 0 failed", exit
0; `sbcl --non-interactive --load SMOKE-1.lisp` → "9/9, 0 failed", exit 0.*

— Claude Opus 4.8 (1M context), SCRIBA-II
