# NORMATIVE OBSERVATION FORMAT /0 — `ma0-observation/0` (CANDIDATE)

**STANDING: CANDIDATE — not adopted; owner disposition pending.** Date: 2026-08-10.

**Prepared against the R1 CANDIDATE base of Many Acts /0**: parcel sha256
`54aa7783c494d8f32baa3c10eecd48590b88b13f07f0de6c8724831807a02803`; patch base commit
`76952ea4f278d269f98f158555e412a095a3da6f`; R1 freeze lane subtree
`e94870bd9091e67f68e9cf238a6c5d0dcf302a05`. **The base is itself NOT owner-adopted.** A
format prepared against a candidate base can never raise the standing of what it observes.

**NAMING COLLISION (first use, per campaign law).** The token "PJ0" already denotes the
**ADOPTED Process Journal /0** (`mneme/architecture/process-journal-0/PJ0-ADOPTION-RECORD.md`).
This campaign is **Portable Judge /0**, directory `portable-judge-0/`; the short form used
here is **PortJ/0**. Final designation **pending owner ratification**.

**Inherited vocabulary rider (AP0 adoption Rider 2).** The two prohibited phrases — the
"independently ..." pair barred in the base lane — are used nowhere in this document except in
this sentence, which names the prohibition, and may not be introduced by any citation of it.
Two judges producing byte-identical envelopes is **cross-implementation conformance under
declared provenance** and nothing else.

**Companions.** `PROTOCOL-CANDIDATE.md` (the campaign's protocol, the Act Oracle Interface
scoping, and the observable boundary OB-1..OB-9) · `SPEC-DEFICIT-REGISTER-CANDIDATE.md`
(what the public texts do not say, including every `[DEFICIT SD-nn]` marker below).

---

## 0. The charter sentence

> **JSON is plumbing, not semantic jurisdiction.**

JSON is used here because two implementations on two substrates need a byte stream neither
of them owns. It is **transport**. It contributes **no** type, no ordering rule, no equality,
and no value distinction to Lisp+ or to Many Acts /0. Where JSON's native repertoire is
richer than the subject language's (floats, `null`, unordered objects, arbitrary numeric
syntax), the surplus is **forbidden below**, because a transport that can express what the
law cannot is a transport that will eventually be read as law. Where JSON's repertoire is
poorer (ordered records, byte strings, exact integers of unbounded size, the difference
between a keyword and a string), the encoding is **tagged and explicit**, because a
distinction the law owns must survive the wire.

Three consequences, stated as rules and enforced by §5:

1. **This format encodes exactly what Many Acts /0's public law declares.** It defines no
   representation for a value type the law does not have. Reserved encodings for the wider
   Canonical Datum /0 domain are given in §4.9 and are **forbidden to emit at /0**.
2. **This format never repairs a silence.** Where the public law underdetermines an
   observable, the field carries a `[DEFICIT SD-nn]` marker pointing at the register, and
   the format either declares its policy in-band (so the policy travels with the bytes) or
   refuses to emit.
3. **The format is not evidence of itself.** §7 lists the planted-divergence categories the
   format's own teeth must catch before any comparison run is admitted. A format that has
   never been shown able to *fail* is untested, not passing.

---

## 1. What is being compared, and where the boundary sits

Two judges evaluate the same case:

- **J1** — the lane's canonical Common Lisp evaluator at the R1 freeze
  (`e94870bd…`), i.e. `ma0-validate` + `make-ma0-environment` + `ma0-run-program`.
- **J2** — a future clean-room implementation on a non-Common-Lisp substrate (Python
  recommended, PROTOCOL §4), constructed from the frozen public packet.

Each emits **one observation document per case**. The documents are compared by **byte
equality of the canonical encoding of the `observation` member** (§5), and, equivalently,
by the sha256 of those bytes.

**The boundary this format encodes is the *observable semantic boundary* of PROTOCOL §5:
the language layer.** It does not encode the substrate layer (One Act /0 arm execution,
the journal store, Capability /0//1//2, Surface /2 derivation, digest arithmetic). Under
the Act Oracle Interface those values are *supplied* to both judges as case data; what the
format compares is **which of them the judge carried, in what order, into what structure,
with what disposition** — never whether the judge could have computed them.

**What is NOT observable, and is therefore not representable in this format:**

| Not observable | Why |
|---|---|
| condition **report text** | the base lane states in its own sources that SBCL condition report text is not a stable interface; the campaign honors that |
| printed representations of any host object | unlegislated; excluded by harness decision, not by a reading of the law — **[DEFICIT SD-11]** |
| wall-clock time, PID, run root path, temporary file names | not in the law's observable surface; a producer that emits them is non-conformant |
| host memory addresses, hash order, `sxhash`, `gensym` identity | Kernel /0 §2.3 [F: HOST-3] forbids these at any durable boundary |
| the *selected branch clause*, as such | **no public construct records it** — see §4.8 and **[DEFICIT SD-27]** |

---

## 2. Document shape: the comparable core and the excluded attestation

A conforming file is a JSON object with **exactly two** members:

```
{ "attestation": { … }, "observation": { … } }
```

- **`observation`** — the **comparison unit**. Its canonical encoding (§5) is what is
  compared and hashed. It contains **nothing** that identifies the producer.
- **`attestation`** — producer identity, host, timestamps, the recorded
  `observation_sha256`, and any human gloss. **Excluded from the comparison by
  construction.**

This split exists because hash-level comparison and producer provenance are in direct
tension: a document that carries "I am J2, Python 3.12, at 04:31" inside the hashed core can
never be byte-equal to J1's. Putting provenance *outside* the hashed member is the only
arrangement in which both are kept and neither is fudged.

**Rule OF-1.** No member of `observation`, at any depth, may vary with the producer, the
host, the clock, the filesystem, or the run. A producer that cannot honor this for some
field must omit the *case*, not the field.

### 2.1 `attestation` (not compared, not hashed)

| Member | Type | Meaning |
|---|---|---|
| `judge` | `"J1"` \| `"J2"` | which implementation produced this |
| `implementation` | string | free text, e.g. `"lisp-plus/many-acts-0 @ e94870bd"` |
| `host` | string | free text, e.g. `"SBCL 2.4.6 / Linux"` |
| `case_id` | string | the frozen case identifier from the vector bank |
| `observation_sha256` | 64 lowercase hex | sha256 of the canonical bytes of `observation` |
| `format` | `"ma0-observation/0-candidate"` | the format version this file claims |
| `gloss` | object, optional | human-readable mirrors of hex-encoded fields (§4.2); **advisory only, never compared** |

### 2.2 `observation` (compared, hashed)

Required members, in canonical (ascending) order:

```
acts                – array of act-summary objects, oldest act first (§4.7)
case               – object: the case's frozen identity (§3)
declarations       – object: the in-band policy declarations (§3.1)
grammar_version    – decimal-string integer (§4.3)
outcome            – object: exactly one of the three outcome shapes (§4.5–4.6)
program_name       – string value (§4.2)
```

**Every required member is always present.** Optionality is *never* expressed by omitting a
key; it is expressed by the explicit `{"t":"absent"}` value (§4.4). This is the format's
answer to the missing-vs-empty problem, and it is total: **a missing key is a defect, not a
value.**

---

## 3. `case` and `declarations`

### 3.1 `declarations` — policies that travel with the bytes

The subject language leaves several representational questions open (see the register).
Rather than pick silently, this format **requires the producer to declare its policy in the
hashed core**, so two judges that resolved a silence differently produce *different bytes*
and the divergence surfaces as a divergence instead of hiding as a coincidence.

| Member | Permitted values at /0 | Meaning |
|---|---|---|
| `string_normalization` | `"as-observed"` | Subject strings are emitted as the exact octets observed; **no** Unicode normalization is applied. NFC is *not* imposed, because imposing it would make two judges agree about a string neither preserved. **[DEFICIT SD-23]** — if a future round legislates input normalization, this value becomes `"nfc-enforced-at-input"` and the format version bumps. |
| `keyword_identity` | `"symbol-name-verbatim"` | An open-set keyword (a program-authored `:code`, a keyword literal in a value) is identified by the **exact octets of its symbol-name as observed after ingestion**, not by its spelling in the source text. **[DEFICIT SD-14, SD-8]** |
| `enum_spelling` | `"public-law-lowercase"` | A closed-vocabulary keyword whose value set the public law publishes (dispositions, classes, axes, standings) is emitted as the law's own published spelling: lowercase, no leading colon. |
| `absent_encoding` | `"tagged"` | See §4.4. |
| `integer_encoding` | `"decimal-string-unbounded"` | See §4.3. |

A producer MUST emit all five. A producer that cannot honor a declared value MUST emit an
`observation_refused` outcome (§4.6) rather than a differently-shaped one.

### 3.2 `case`

| Member | Type | Meaning |
|---|---|---|
| `id` | ASCII string | the frozen case identifier |
| `source_sha256` | 64 lowercase hex | sha256 of the case's program source **octets as delivered** |
| `environment_sha256` | 64 lowercase hex | sha256 of the case's canonicalized environment declaration as delivered by the harness |

`case` fixes *what was judged*. It is inside the hashed core deliberately: an envelope that
is byte-identical for two different inputs would be worse than useless.

---

## 4. The value and outcome grammar

### 4.1 The observable value domain, item by item, against the commissioned checklist

The commission supplied a wish-list of value types. Each is adjudicated **from the public
law alone** — `MANY-ACTS-0-GRAMMAR.md` (§1 `LITERAL`, `VEXPR`; §4 axes; §5.2, §5.3),
`AUTHOR-GUIDE.md` (§1 grammar box, §2 binding classes, §4 act summary, §6 axes, §7
terminals, §8 environment table), `MANY-ACTS-0-CONTRACT-CANDIDATE.md` (§6 export surface).

| Wish-list item | Standing at /0 | Citation / reason |
|---|---|---|
| **unit** | **ABSENT — N/A** | No unit value exists. `nil`/`()` is not a lawful `VEXPR`: `LITERAL := STRING \| INTEGER \| KEYWORD` and `(list VEXPR+)` requires ≥1 element (GRAMMAR §1; AUTHOR-GUIDE §1). No encoding is defined. |
| **booleans** | **ABSENT — N/A** | No boolean literal, no boolean axis, no truthiness anywhere: *"No truthiness participates anywhere"* (GRAMMAR §4; AUTHOR-GUIDE §6). Introducing a boolean encoding would import exactly the concept the matching law exists to exclude. No encoding is defined. |
| **integers — arbitrary precision** | **PRESENT as a type; PRECISION UNDERDETERMINED** | `LITERAL := … \| INTEGER` (GRAMMAR §1). The law states declared bounds on source *depth* and *node count* (GRAMMAR §2 V-SHAPE) but no bound on integer *magnitude*, and never states that integers are unbounded. Encoded as an unbounded decimal string (§4.3) — the only choice that cannot silently truncate. **[DEFICIT SD-22]** |
| **reduced rationals** | **ABSENT — N/A** | Not in `LITERAL`. A ratio is refused as a source atom. No encoding is defined at /0; a reserved encoding is given in §4.9 and is forbidden to emit. |
| **Unicode strings** | **PRESENT; normalization and scalar policy UNDERDETERMINED** | `LITERAL := STRING …`; the lane's reader opens sources with an explicit UTF-8 external format. The law states no normalization form and no forbidden-scalar rule. Encoded as UTF-8 octets in hex (§4.2) with the policy declared in-band (§3.1). **[DEFICIT SD-23]** |
| **byte strings** | **ABSENT — N/A** | No octet-vector value exists; V-DATA's closed atom vocabulary is STRING, INTEGER, KEYWORD, lawful symbol. The one hex-shaped observable, `act-id-hex`, is a **string** (AUTHOR-GUIDE §4), not an octet vector, and is encoded as a string. Reserved encoding in §4.9. |
| **segmented identifiers** | **ABSENT as a value type — N/A** | Programs cannot construct or observe a segmented identifier. The act-identity *is* a segmented Journal /0 identifier upstream, but the language layer observes only its last segment, as a string (AUTHOR-GUIDE §4). Reserved encoding in §4.9. **[DEFICIT SD-26]** — the public MA0 texts never say which specification governs that segment's derivation. |
| **ordered sequences** | **PRESENT** | `(list VEXPR+)` (GRAMMAR §1). Order is authored and meaningful; nesting is meaningful. Encoded in §4.4, order preserved, nesting preserved exactly. |
| **ordered records / identifier-keyed maps** | **ABSENT as a value type — N/A** | No record, map, alist, or plist value is constructible in a program. The *envelope* structures (program result, act summary) are fixed-shape records defined by this format, not by a general record type in the language. Reserved encoding in §4.9. |
| **keywords** | **PRESENT (not on the wish-list, and load-bearing)** | `LITERAL := … \| KEYWORD`; `refuse (:code KEYWORD)` with an **open** author-chosen keyword set (GRAMMAR §1, §2 V-ATOMS "user `:code` keywords"). A keyword is **not** a string and must not be collapsed into one. Encoded in §4.2. |
| **absence keywords as values** | **PRESENT ONLY IN SOURCE** | `(field X AXIS)` over a facet whose standing is not `:present` yields the **standing keyword** as a program value. Public law defines standings for *matching* only (GRAMMAR §4; AUTHOR-GUIDE §6) and never for *projection*. Encodable (it is a keyword) but registered: **[DEFICIT SD-16]** |

**Net value domain at /0: string · integer · keyword · ordered sequence.** Four things.
Everything else on the wish-list is N/A, and this format defines no way to say it.

### 4.2 Text-bearing fields: hex, not JSON strings

Every field whose content comes **from the subject** — program name, string values, keyword
names, verdict, store-id, act-id-hex, condition type, refusal code — is carried as
**lowercase hex of its UTF-8 octets**, never as a JSON string.

```json
{"t":"string","utf8_hex":"636f6465782d73616e67616c6c656e736973"}
```

**Why.** A JSON string forces two decisions the subject language has not made: an escaping
policy and a normalization policy. Hex removes the questions instead of answering them
wrongly. It also yields a strong checkable property: **the canonical bytes of a conforming
`observation` contain no backslash at all** (§5, rule C7) — so an escaping divergence
between two judges is not merely detectable, it is *impossible to hide*.

Convention follows the existing lab precedent rather than inventing one: Canonical Datum /0's
shared fixture schema (`canonical-datum/schema/cd0-fixtures.schema.json`) already carries
strings as `{"t":"string","utf8_hex":…}` with `^(?:[0-9a-f]{2})*$`, identifiers as hex path
segments, and integers as `^(?:0|-?[1-9][0-9]*)$` decimal strings. This format reuses those
lexical rules exactly.

`attestation.gloss` MAY mirror any hex field in readable form. The gloss is never compared,
never hashed, and never authoritative.

### 4.3 Integers

```json
{"t":"int","v":"-4096"}
```

`v` matches `^(?:0|-?[1-9][0-9]*)$` — base 10, no radix prefix, no `+`, no leading zeros,
**no `-0`**, unbounded length. JSON numbers are **forbidden everywhere** in `observation`
(§5, rule C3): a JSON number would re-open float coercion, precision loss, and
implementation-specific serialization, all of which are exactly the divergences this
campaign exists to detect.

### 4.4 Keywords, sequences, and absence

```json
{"t":"keyword","name_utf8_hex":"554e4558504543544544"}       ← open-set keyword
{"t":"seq","items":[ …value… , …value… ]}                  ← ordered, nesting exact
{"t":"absent"}                                             ← the law says there is no value
```

- **`keyword`** carries the exact symbol-name octets as observed after ingestion
  (`declarations.keyword_identity`). It is a distinct tag from `string`: a program that
  refuses with `:unexpected` and a program that returns `"unexpected"` are different
  programs, and an encoding that could not tell them apart would be lying.
- **`seq`** preserves both order and nesting. A one-element sequence is **not** collapsed to
  its element; an empty `items` array is **unreachable at /0** (`(list VEXPR+)` requires ≥1)
  and a producer emitting one is non-conformant.
- **`absent`** is used **only** where the public law states there is no value: a `result`
  terminal has no refusal code and no refusal detail; a `refuse` terminal has no value; a
  `refuse` with no optional `VEXPR` has no detail; a mint-refused act has no verdict
  (AUTHOR-GUIDE §4, §7). `{"t":"absent"}` is **not** the empty string, **not** the empty
  sequence, and **not** a missing key. JSON `null` is forbidden.

**Rule OF-2 (missing vs empty).** A **missing** member is a malformed document. An **empty**
value (`""`, `[]`) is a *value*, distinct from absence, and at /0 the only reachable empty
value is the empty string (`(:name STRING)` requires non-empty, but a `bind`/`result` payload
string may be empty). **Absence is `{"t":"absent"}` and nothing else, unless a future
normative sentence says otherwise.**

### 4.5 The `result` outcome

Emitted when `ma0-run-program` returned a program result.

```json
"outcome": {
  "kind": "result",
  "disposition": "completed",            ← "completed" | "refused"
  "value": <VALUE|absent>,
  "refusal_code": <KEYWORD|absent>,
  "refusal_detail": <VALUE|absent>,
  "store_id": <STRING|absent>
}
```

- `disposition` is drawn from the published closed set (`:completed`, `:refused`;
  GRAMMAR §5.3, AUTHOR-GUIDE §7), spelled per `declarations.enum_spelling`.
- **Disposition is never laundered.** A `refuse` terminal produces `"refused"` on every
  path. A producer that emits `"completed"` for a refusal is non-conformant, and §7 category
  PD-11 plants exactly that.
- `store_id` is carried as a **field, never as an identity**: R1-F5 records that a store-id
  is content-derived and cannot discriminate two stores. Comparators MUST NOT use it to
  decide whether two runs touched the same store. **[DEFICIT SD-10]**

### 4.6 The `condition` and `void` outcomes

A refusal is a lawful outcome; **an error is not an outcome at all** (AUTHOR-GUIDE §7) — it
propagates as a condition, and the format must be able to say so without pretending a
program result exists.

```json
"outcome": {
  "kind": "condition",
  "condition_type": "ma0-source-refused",     ← closed set, §4.6.1
  "code": <STRING|absent>,
  "code_normative": false
}
```

```json
"outcome": { "kind": "void", "reason": "one-act-0-environment-preflight" }
```

```json
"outcome": { "kind": "observation_refused", "reason": "<closed token, §4.6.2>" }
```

#### 4.6.1 `condition_type` — closed, and one member is contested

Permitted tokens, from `MANY-ACTS-0-CONTRACT-CANDIDATE.md` §6 plus the lane's export list:

```
ma0-refusal · ma0-source-refused · ma0-environment-refused ·
ma0-authority-slot-unfilled · ma0-binding-refused · ma0-pattern-refused ·
ma0-composition-divergence · ma0-environment-stale
```

⚠ **`ma0-environment-stale` is exported by the lane but is absent from CONTRACT §6's
"closed" export list and from the AUTHOR-GUIDE entirely.** It is admitted here because a
format that could not name a condition the surface can signal would be unfaithful — but its
admission is a *format decision*, not a reading of the law. **[DEFICIT SD-6, SD-25]**

#### 4.6.2 `code` is carried, and is explicitly NOT normative at /0

`code_normative` is **required** and MUST be `false` at this format version. The reason is
stated rather than smuggled: the public texts name some law-codes (`V-SHAPE`, `V-BIND`,
`V-RETRY`, …) as *law names*, never publish the complete set, never state the code's
**datatype**, and omit the entire environment/runtime family. A clean-room J2 cannot emit a
conforming code from the packet. Therefore:

- J1 and J2 both emit `code`, hex-encoded, for the record;
- the comparator **excludes `code` from the pass/fail decision at /0** and reports code
  agreement as a *separate, advisory column*;
- if a code table is later published, `code_normative` becomes `true` and the format version
  bumps.

**[DEFICIT SD-1]** — and note the sharper edge found in drafting: GRAMMAR §2 names a law
**`V-ATOMS`**, and **no refusal in the lane carries the code `V-ATOMS`** (atom refusals carry
`V-PKG` or `V-DATA`). A published law name with no corresponding observable is precisely the
kind of thing a differential judge will trip over.

`observation_refused` reasons are a closed set: `unrepresentable-scalar` (a lone surrogate or
otherwise unencodable octet sequence), `undeclarable-policy` (§3.1 could not be honored),
`boundary-exceeded` (an implementation limit was reached), `producer-nonconformance`. A
producer that meets any of these **refuses the observation** rather than guessing — the same
discipline the subject language applies to its own sources.

### 4.7 `acts` — the ordered act summaries

```json
"acts": [
  { "arm": <STRING>,
    "act_id_hex": <STRING|absent>,
    "disposition": "returned",
    "class": "a",
    "verdict": <STRING|absent> }
]
```

- The array is ordered **oldest act first** (AUTHOR-GUIDE §8, `-act-summaries`
  *"ordered, oldest act first"*). Order is normative; a newest-first producer is
  non-conformant (§7, PD-07).
- `disposition` ∈ `returned · refused · interrupted · host-fault · mint-refused`;
  `class` ∈ `a · b · c-i · c-ii · d · unclassifiable · unpaired-f1` (AUTHOR-GUIDE §4).
  Both are published closed sets and use `enum_spelling`.
- `arm` ∈ the seven sealed arms `A · B-L1 · B-L2 · B-R · C-i · C-ii · D`, carried as a
  **string** (it is a string in the law), hex-encoded like any other subject string. Note the
  arm strings are case-bearing (`B-L1`, `C-i`) and must not be normalized.
- `act_id_hex` is a string, or `{"t":"absent"}`. **The law's nullability statement is
  incomplete**: AUTHOR-GUIDE §4 documents `NIL` for `verdict` on a mint-refused act but
  gives no nullability rule for `act_id_hex`. **[DEFICIT SD-19]**
- `verdict` is *"the agreement verdict string"* with **no published vocabulary**.
  **[DEFICIT SD-18]**

### 4.8 The branch-execution observation, and what it honestly is

The commission asks for a branch-execution witness. **The public law provides no construct
that records which clause was selected.** What it provides is a consequence: exactly one
arm's steps run, and *"the untaken arm leaves no journal footprint and no act summary"*
(FAILURE-MATRIX W-BRANCH-ONE).

Therefore, in this format, **`acts` IS the branch-execution observation** — the ordered list
of acts that actually occurred, together with the terminal reached in `outcome`. That is an
**indirect** witness and is labelled as one. The format deliberately defines **no**
`branch_trace`, `selected_clause`, or `clause_index` member, and a producer emitting one is
non-conformant: inventing an observable that the law does not have would make J2 fail for
disagreeing with a fiction. **[DEFICIT SD-27]** records the gap; §7 category PD-12 plants the
temptation and requires the teeth to bite it.

### 4.9 RESERVED encodings — defined, and forbidden to emit at /0

Given so a later lane extends rather than re-invents, and so that a producer emitting one
today is *mechanically* non-conformant rather than merely unexpected. All follow Canonical
Datum /0's fixture-schema conventions.

```json
{"t":"unit"}
{"t":"bool","v":true}
{"t":"rat","p":"-3","q":"4"}                       ← reduced; q > 0; p,q decimal strings
{"t":"bytes","hex":"0a1b2c"}                       ← lowercase hex, even length
{"t":"id","namespace_utf8_hex":[…],"path_utf8_hex":[…]}   ← segmented identifier
{"t":"record","fields":[{"key":{"t":"id",…},"value":…}]}  ← ORDERED array of pairs
```

**A record is an ordered array of key/value pairs, never a JSON object.** JSON objects are
unordered by their own specification and, in most host libraries, by their implementation;
a record type whose order is normative cannot be carried by a construct whose order is not.
This rule is stated here even though /0 has no record value, because the temptation to
"just use an object" is exactly where a later round would lose the ordering law.

**Rule OF-3.** At format version `ma0-observation/0`, emitting any `t` from §4.9 is
non-conformance, not extension.

---

## 5. Canonicalization — byte-level, so two implementations produce identical bytes

A conforming producer serializes `observation` by these rules and no others. Two producers
that both honor them emit **byte-identical** streams for the same judgment, which is what
makes sha256 comparison meaningful.

| ID | Rule |
|---|---|
| **C1** | **UTF-8, no BOM.** The canonical byte stream is the UTF-8 encoding of the canonical text. In practice, by C7, it is pure ASCII. |
| **C2** | **No insignificant whitespace.** No space, tab, CR, or LF anywhere. Not between tokens, not after `:` or `,`, and no trailing newline. The whole `observation` is one line. |
| **C3** | **Restricted JSON repertoire.** Permitted: objects, arrays, strings, and the literals `true`/`false` **only** in `{"t":"bool","v":…}`, which §4.9 forbids at /0. **JSON numbers are forbidden. JSON `null` is forbidden.** Every integer is a decimal string (§4.3); every absence is `{"t":"absent"}` (§4.4). |
| **C4** | **Member order.** Members of every object are emitted in ascending order of member name, compared as sequences of UTF-16 code units (the RFC 8785 rule). Every member name in this format is ASCII `[a-z0-9_]`, so this is plain byte order. Arrays are **never** reordered: array order is subject data (§4.7). |
| **C5** | **No duplicate member names.** A duplicate is malformed, not a last-wins. |
| **C6** | **Member names are the exact ASCII tokens named in this document.** No aliases, no abbreviations, no extra members. An unknown member makes the document malformed (this is what makes silent field addition detectable — §7, PD-12). |
| **C7** | **No escape sequences.** All subject text is hex-encoded (§4.2); all remaining strings are drawn from closed ASCII token sets defined here and contain no `"`, no `\`, and no control characters. **A backslash anywhere in the canonical bytes is a defect.** This retires JSON string escaping as a divergence site entirely. |
| **C8** | **Hex is lowercase**, `[0-9a-f]`, even length; the empty string encodes as `""` (zero octets), which is a *value* and not an absence. |
| **C9** | **Integers** match `^(?:0\|-?[1-9][0-9]*)$` — no `+`, no leading zeros, no `-0`, unbounded length. |
| **C10** | **Unicode normalization is not applied** (`declarations.string_normalization = "as-observed"`). Observed octets are carried through unchanged. A producer that normalizes is non-conformant. |
| **C11** | **Unrepresentable input refuses.** A lone surrogate or any octet sequence the producer cannot faithfully carry produces `outcome.kind = "observation_refused"`, never a best-effort encoding. (The doctrine is Canonical Datum /0's D-CANON-07: a canonicalizer that silently best-effort-prints produces *"a broken fixpoint wearing a success costume."*) |
| **C12** | **Digest.** `observation_sha256` = sha256 of the canonical bytes of `observation`, lowercase hex. It lives in `attestation` and therefore never participates in what it measures. |
| **C13** | **Independent re-derivation.** The canonical bytes are a function of the judgment alone. No producer may consult ambient state — printer settings, locale, environment variables, library defaults — in producing them. (Kernel /0 §2.3 [F: HOST-3] applied one level out.) |

### 5.1 Comparison procedure

1. Both judges emit their document for case *c*.
2. The comparator extracts each `observation`, re-serializes it under C1–C11 **itself**
   (never trusting either producer's serializer), and computes sha256.
3. **Equal digests ⇒ conformant on this case.** Unequal digests ⇒ the comparator emits a
   structural diff naming the first divergent path in canonical order, plus the advisory
   `code` column (§4.6.2) reported separately.
4. `attestation` is never read by the comparator except to record which file was whose.

Re-serializing rather than comparing the delivered bytes is deliberate: it prevents a
producer's serializer bug from being scored as a semantic divergence, and it prevents two
producers with the *same* serializer bug from agreeing on nonsense.

---

## 6. Worked examples

⚠ **These are FORMAT ILLUSTRATIONS, not run transcripts.** Both programs are assembled
**exclusively** from fragments printed in `AUTHOR-GUIDE.md` — §3's `act` line, §5's `derive`
form, §6's branch example verbatim, §8's environment declaration and its derived-facet table.
No private test, no hidden vector, and no fixture file was consulted.

Fields whose values the public law does **not** fix are shown as **SYNTHETIC PLACEHOLDERS**
and are marked as such in every case. Nothing below should be read as an observed value.

### 6.1 The program text (guide fragments only)

```lisp
(ma0-program
  (:name "guide-example")
  (:input (manuscript-label))
  (:authority-slots (editor-grant))
  (:steps
    (act entry (:arm "A") (:authority-slot editor-grant))          ; AUTHOR-GUIDE §3
    (derive entry-record (:seat "s-entry"))                        ; AUTHOR-GUIDE §5, §8
    (branch entry-record                                           ; AUTHOR-GUIDE §6, verbatim
      ((:execution :absent)                                   (result 1))
      ((:and (:execution :settled) (:evidence-class :none))   (result 2))
      (otherwise                                              (refuse (:code :unexpected))))))
```

Environment, from AUTHOR-GUIDE §8 verbatim: `:arms '("A")` ·
`:grants '((:slot "editor-grant" :arm "A"))` · `:revocations '()` ·
`:seat-map '(("s-entry" . "prima"))` ·
`:inputs '(("manuscript-label" . "codex-sangallensis"))`.

AUTHOR-GUIDE §6's derived-facet table gives the row this selects: **after a completed arm A,
`:execution :settled`, `:evidence-class :none`, `:provenance :none`** — so clause 2 holds and
the terminal is `(result 2)`.

### 6.2 A completed outcome

```json
{
  "attestation": {
    "case_id": "guide-example-A",
    "format": "ma0-observation/0-candidate",
    "gloss": {
      "acts[0].arm": "A",
      "outcome.value": "2 (integer)",
      "program_name": "guide-example"
    },
    "host": "SBCL 2.4.6 / Linux",
    "implementation": "lisp-plus/many-acts-0 @ e94870bd (R1 freeze)",
    "judge": "J1",
    "observation_sha256": "<sha256 of the canonical bytes of observation>"
  },
  "observation": {
    "acts": [
      {
        "act_id_hex": {"t":"string","utf8_hex":"30303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030"},
        "arm": {"t":"string","utf8_hex":"41"},
        "class": "a",
        "disposition": "returned",
        "verdict": {"t":"string","utf8_hex":"6167726565"}
      }
    ],
    "case": {
      "environment_sha256": "<sha256 of the delivered environment declaration>",
      "id": "guide-example-A",
      "source_sha256": "<sha256 of the delivered program source octets>"
    },
    "declarations": {
      "absent_encoding": "tagged",
      "enum_spelling": "public-law-lowercase",
      "integer_encoding": "decimal-string-unbounded",
      "keyword_identity": "symbol-name-verbatim",
      "string_normalization": "as-observed"
    },
    "grammar_version": "0",
    "outcome": {
      "disposition": "completed",
      "kind": "result",
      "refusal_code": {"t":"absent"},
      "refusal_detail": {"t":"absent"},
      "store_id": {"t":"string","utf8_hex":"<store-id octets, SYNTHETIC>"},
      "value": {"t":"int","v":"2"}
    },
    "program_name": {"t":"string","utf8_hex":"67756964652d6578616d706c65"}
  }
}
```

**Placeholder disclosures for 6.2, exhaustively:**

- `acts[0].act_id_hex` — **SYNTHETIC**: sixty-four ASCII `0` characters. The public law states
  only that this is *"the 64-character act-identity digest segment"* (AUTHOR-GUIDE §4); no
  public text fixes a value, and none was read from a run.
- `acts[0].verdict` — **SYNTHETIC**: the octets of `agree`. The guide publishes no verdict
  vocabulary (**[DEFICIT SD-18]**).
- `acts[0].disposition` / `.class` — `returned` / `a`. **NOT in the AUTHOR-GUIDE**: §4
  publishes the *vocabulary* but not the arm→disposition/class mapping (F-GUIDE-1 territory).
  The pairing shown is taken from the P5 packet's guide addendum table
  (`notes/2026-08-10-p5-sol-inhabitation-protocol.md`, "Guide addendum content"), whose values
  were extracted from the exported fixture table. **[DEFICIT SD-3, SD-28]**
- `outcome.store_id` — **SYNTHETIC**; and per §4.5 a store-id is a label, never an identity.
- `case.*_sha256` and `attestation.observation_sha256` — angle-bracket slots, not values. A
  live producer fills them; this document must not fabricate a digest.
- Everything else is fixed by the public law: `value` is the integer `2` from the guide's own
  `(result 2)`; `program_name` is the `:name` string; the two `absent` members are required by
  §4.4 because a `result` terminal has neither a refusal code nor a refusal detail.

### 6.3 A refusal outcome

Same guide fragments, arm **C-i** and its seat. AUTHOR-GUIDE §6's table gives the third row —
**after a completed arm C-i, `:execution :reconciled`, `:evidence-class :reconciled`** — so
neither published clause holds, `otherwise` is selected, and the terminal is the guide's own
`(refuse (:code :unexpected))`, which carries **no** optional payload.

```json
{
  "attestation": {
    "case_id": "guide-example-Ci",
    "format": "ma0-observation/0-candidate",
    "gloss": {
      "outcome.refusal_code": ":UNEXPECTED (symbol-name verbatim; source spelling was :unexpected)"
    },
    "host": "SBCL 2.4.6 / Linux",
    "implementation": "lisp-plus/many-acts-0 @ e94870bd (R1 freeze)",
    "judge": "J1",
    "observation_sha256": "<sha256 of the canonical bytes of observation>"
  },
  "observation": {
    "acts": [
      {
        "act_id_hex": {"t":"string","utf8_hex":"30303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030"},
        "arm": {"t":"string","utf8_hex":"432d69"},
        "class": "c-i",
        "disposition": "interrupted",
        "verdict": {"t":"string","utf8_hex":"6167726565"}
      }
    ],
    "case": {
      "environment_sha256": "<sha256 of the delivered environment declaration>",
      "id": "guide-example-Ci",
      "source_sha256": "<sha256 of the delivered program source octets>"
    },
    "declarations": {
      "absent_encoding": "tagged",
      "enum_spelling": "public-law-lowercase",
      "integer_encoding": "decimal-string-unbounded",
      "keyword_identity": "symbol-name-verbatim",
      "string_normalization": "as-observed"
    },
    "grammar_version": "0",
    "outcome": {
      "disposition": "refused",
      "kind": "result",
      "refusal_code": {"t":"keyword","name_utf8_hex":"554e4558504543544544"},
      "refusal_detail": {"t":"absent"},
      "store_id": {"t":"string","utf8_hex":"<store-id octets, SYNTHETIC>"},
      "value": {"t":"absent"}
    },
    "program_name": {"t":"string","utf8_hex":"67756964652d6578616d706c65"}
  }
}
```

**What this example is *for*, beyond illustration.** Three of the format's load-bearing rules
are visible in it at once, and each corresponds to a live deficit:

1. `refusal_code` is a **keyword**, not a string — a distinction JSON has no native way to
   make and that this format therefore tags. The source text says `:unexpected`; the encoded
   name is `UNEXPECTED` (hex `554e4558504543544544`), because ingestion upcases. **A J2 whose
   reader does not upcase produces different bytes here — which is the campaign working, not
   the campaign failing.** **[DEFICIT SD-14, SD-8]**
2. `refusal_detail` is `{"t":"absent"}` — the guide's `(refuse (:code :unexpected))` has no
   optional `VEXPR`. It is not `""`, not `[]`, not a missing key. **[Rule OF-2]**
3. `value` is `{"t":"absent"}` — a refusal has no result payload. `disposition` stays
   `"refused"` on every path; §7 PD-11 plants the laundering.

---

## 7. Conformance note: this format needs its own teeth first

**This format is untested until it has been shown able to fail.** A gate that has never
fired is untested, not passing (the lab's TESSERA rule). Before any J1/J2 comparison run is
admitted, a planted-divergence suite MUST be built, and each category below MUST be shown to
turn the comparator **red** while the restored control stays **green**.

| ID | Planted divergence | Must be caught by |
|---|---|---|
| **PD-01** | Object member order altered (one member moved out of ascending order) | C4 |
| **PD-02** | Whitespace or pretty-printing introduced (indentation, trailing newline) | C2 |
| **PD-03** | A subject string NFC/NFD-normalized on one side only | C10 + §4.2 hex |
| **PD-04** | An integer emitted as a JSON number; or with a leading zero, a `+`, or `-0` | C3, C9 |
| **PD-05** | Keyword case altered (`UNEXPECTED` ↔ `unexpected`) | §3.1 `keyword_identity` + §4.2 |
| **PD-06** | Absence conflated: `{"t":"absent"}` replaced by `""`, `[]`, `null`, or key omission | OF-2, C3, C6 |
| **PD-07** | `acts` reordered (newest-first) | §4.7 ordering |
| **PD-08** | Nesting flattened: a one-element `seq` collapsed to its element, or a nested `seq` spliced | §4.4 |
| **PD-09** | An escape sequence introduced (a backslash-u escape written where the plain character belongs, or a backslash-solidus), or uppercase hex in a `utf8_hex` | C7, C8 |
| **PD-10** | Type collapse: integer `2` emitted as `{"t":"string",…"32"}`, or a keyword as a string | §4.3, §4.4 tags |
| **PD-11** | Disposition laundering: a `refuse` terminal reported as `"completed"` | §4.5 |
| **PD-12** | Silent field addition: a `branch_trace`, a `timestamp`, a `duration_ms`, a producer id inside `observation` | C6, OF-1, §4.8 |
| **PD-13** | Duplicate member name (last-wins accepted instead of malformed) | C5 |
| **PD-14** | Attestation leakage: `judge`/`host` moved inside `observation`, or `observation_sha256` computed over the whole file | OF-1, C12 |
| **PD-15** | A §4.9 reserved tag emitted at /0 (`{"t":"bool",…}`, `{"t":"record",…}`) | OF-3 |
| **PD-16** | `code` promoted into the pass/fail decision while `code_normative` is `false` | §4.6.2 |

**Two further teeth that are about the comparator, not the format**, and are required by the
same logic: (a) an **identity control** — the same judgment serialized twice by the same
producer must be byte-identical, run twice, proving determinism before difference means
anything; and (b) a **cross-producer control on a case both judges are known to agree on**,
proving the comparator can say *green* as well as *red*.

---

## 8. What this format does not do

- It does **not** make J1 and J2 comparable on the substrate layer. Digest arithmetic, journal
  bytes, capability recognition, and Surface /2 derivation are supplied through the Act Oracle
  Interface and are not judged here (PROTOCOL §3).
- It does **not** settle any deficit. Every `[DEFICIT SD-nn]` marker above is a silence in the
  public law that this format *declares around*, in-band, so the silence produces a visible
  difference instead of an invisible agreement.
- It does **not** claim that byte-identical envelopes mean the two implementations mean the
  same thing. It means they *said* the same thing about the cases they were shown. The
  difference is the whole reason the hidden vector bank exists.
- It is **not adopted**, and neither is the base it observes.

---

*— drafted by NOTARIUS (Claude Opus), commissioned by the chair (Claude Fable 5), 2026-08-10*
