# NORMATIVE OBSERVATION FORMAT /0 — `ma0-observation/0` (CANDIDATE, Round P revision)

**CANDIDATE (Round P revision) — not adopted; owner disposition pending. Date 2026-08-10.
SUPERSEDES the frozen original `NORMATIVE-OBSERVATION-FORMAT-0-CANDIDATE.md` as candidate
text per OWNER-RULINGS-2 Round-P authorization; original preserved unmodified as historical
artifact. Frozen court-construction baseline: commit `71422395`. Prepared against the R1
candidate base (parcel sha256 `54aa7783…`, patch base `76952ea4…`) — base NOT owner-adopted.
Round P claims NO evidence; zero evidence remains earned. Designation: Portable Judge /0
(PortJ/0); bare PJ0 reserved for the adopted Process Journal /0.**

---

## P.0 What Round P changed in this document, and what it did not

Round P is authorized by `OWNER-RULINGS-2-2026-08-10.md` ("Round P — OPEN") to do exactly two
things to this document:

1. **add the candidate Act Oracle envelope to the observation-format design** (§9, new);
2. **record Ruling 6 as owner-directed candidate law awaiting Parcel B** (§10, new).

Plus the campaign-wide designation sweep (`PJ/0-portable` → `PortJ/0`; PortJ-L/0 versus
PortJ-F/0 scoping) which touches wording only.

**Everything else in this document is the frozen original's content, carried in substance.**
Where a Round-P addition touches the frozen original's own text, the touch is marked
**[P1]** inline and the frozen original's sentence is preserved beside it. Three such touches
exist and they are enumerated here so no reader has to hunt:

| # | Where | The change | Why it is not a silent edit |
|---|---|---|---|
| **T-1** | §3.2 `case` | one new member, `act_oracle_envelope_sha256` | the envelope is part of *what was judged*; §3.2's own stated rationale ("an envelope byte-identical for two different inputs would be worse than useless") applies to the oracle transcript exactly as it applies to the source |
| **T-2** | §7 | two new planted-divergence categories, **PD-17** and **PD-18** | commissioned by the Round-P authorization; PD-18 is marked conditional and is inert until/unless Parcel B adopts Ruling 6 |
| **T-3** | §3.1 | a **reserved, forbidden-to-emit** declaration vocabulary (Rule **OF-4**) | the same discipline §4.9 already applies to value tags: name the future encoding so a producer that emits it today is *mechanically* non-conformant rather than merely surprising |

**⚠ T-1 IS A COMPARISON-UNIT CHANGE, AND IT IS NOT BACKWARD COMPATIBLE.** `case` is inside
the hashed core. **No observation produced under the frozen original is byte-comparable with
one produced under this revision**, and none should be represented as such. The format
version string therefore becomes `ma0-observation/0-candidate-p1` in `attestation.format`.
This is stated rather than absorbed because a format that changes its hashed core quietly is
the exact failure the format exists to detect in others.

**What Round P did NOT do here.** It did not settle a single spec deficit. It did not change
the /0 value domain (still **string · integer · keyword · ordered sequence**, §4.1). It did
not put Ruling 6 into force anywhere in the /0 body — §10 is a **candidate-law record**, and
every clause of it is inert until Parcel B adopts it. It claims no evidence of any kind.

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

**[P1] A fourth consequence, added by the envelope (§9).** The format now also encodes *what
the judge was given*, not only *what the judge said*. An oracle transcript is an input, and
an input that is not hashed into the comparison is an input that can be swapped between the
two judges without leaving a mark.

---

## 0.1 Designation (campaign-wide, Round P)

The campaign is **Portable Judge /0**. Authorized forms: **Portable Judge /0**, **PortJ/0**,
`portable-judge-0/`. The retired form `PJ/0-portable` is **used** nowhere in this document;
it is **mentioned** exactly twice — in this sentence and in §P.0's change-list — and both
mentions exist in order to retire it. (The idiom is the lane's own, inherited from the
Rider-2 prohibited-phrase notice: name the retired token once, visibly, rather than write a
self-refuting "appears nowhere" beside an appearance.) The
bare token **PJ0 is reserved for the adopted Process Journal /0**
(`mneme/architecture/process-journal-0/`) and denotes that campaign and no other; this
paragraph is the only place the reserved token appears here, and it appears in order to
reserve it.

The campaign is divided (Ruling 3) into:

- **PortJ-L/0** — language-layer portable conformance. **This format serves PortJ-L/0.**
- **PortJ-F/0** — full-stack portable conformance. **Not open.** This format does not serve
  it and does not claim to.

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
the language layer** — the eleven behaviors Ruling 3 assigns to PortJ-L/0 (datum ingestion ·
validation · bindings and scope · matching · branch selection · terminal discipline · result
construction · summary ordering · copy/ownership behavior at the observable boundary ·
refusal behavior · determinism). It does not encode the substrate layer (One Act /0 arm
execution, the journal store, Capability /0//1//2, Surface /2 derivation, digest arithmetic).
Under the Act Oracle Interface those values are *supplied* to both judges as case data
(**[P1]** — now as a hashed envelope, §9); what the format compares is **which of them the
judge carried, in what order, into what structure, with what disposition** — never whether
the judge could have computed them.

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
| `format` | `"ma0-observation/0-candidate-p1"` **[P1]** | the format version this file claims |
| `gloss` | object, optional | human-readable mirrors of hex-encoded fields (§4.2); **advisory only, never compared** |

### 2.2 `observation` (compared, hashed)

Required members, in canonical (ascending) order:

```
acts                – array of act-summary objects, oldest act first (§4.7)
case               – object: the case's frozen identity (§3.2)
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
| `string_normalization` | `"as-observed"` | Subject strings are emitted as the exact octets observed; **no** Unicode normalization is applied. NFC is *not* imposed, because imposing it would make two judges agree about a string neither preserved. **[DEFICIT SD-23]** — **[P1]** Ruling 6(8) proposes exactly this as law ("Strings preserve their authored UTF-8 scalar sequence exactly"); **if Parcel B adopts it, this value stops being a format decision and becomes law-backed** — the token does not change, its standing does. See §10.6. |
| `keyword_identity` | `"symbol-name-verbatim"` | An open-set keyword (a program-authored `:code`, a keyword literal in a value) is identified by the **exact octets of its symbol-name as observed after ingestion**, not by its spelling in the source text. **[DEFICIT SD-14, SD-8]** — **[P1]** Ruling 6(3)(4) would replace this with a published canonicalization rather than an observed accident. See §10.2 and the reserved value in Rule OF-4. |
| `enum_spelling` | `"public-law-lowercase"` | A closed-vocabulary keyword whose value set the public law publishes (dispositions, classes, axes, standings) is emitted as the law's own published spelling: lowercase, no leading colon. **[P1]** — this member and `keyword_identity` together are **the two competing equality laws Ruling 6(5) names**; see §10.3, which is the most consequential entry in §10. |
| `absent_encoding` | `"tagged"` | See §4.4. |
| `integer_encoding` | `"decimal-string-unbounded"` | See §4.3. |

A producer MUST emit all five. A producer that cannot honor a declared value MUST emit an
`observation_refused` outcome (§4.6) rather than a differently-shaped one.

#### **[P1] Rule OF-4 — reserved declaration vocabulary, forbidden to emit at /0**

The following declaration members and values are **defined here and forbidden at
`ma0-observation/0-candidate-p1`**, for the same reason §4.9 reserves value tags: a future
lane should extend rather than re-invent, and a producer that emits one today should be
**mechanically** non-conformant rather than merely unexpected.

| Reserved member | Reserved value(s) | Activates if/when |
|---|---|---|
| `keyword_identity` | `"ascii-uppercase-canonical"` | Parcel B adopts Ruling 6(3)(4) — §10.2 |
| `identifier_alphabet` *(new member)* | `"ascii-only"` | Parcel B adopts Ruling 6(2) — §10.1 |
| `name_equality` *(new member)* | `"single-law-canonical-uppercase"` | Parcel B adopts Ruling 6(5) — §10.3 |
| `seat_name_equality` *(new member)* | `"exact-unicode-case-sensitive"` | Parcel B adopts Ruling 6(7) — §10.5 |
| `string_normalization` | `"nfc-enforced-at-input"` | *only* if some future round overrules Ruling 6(8); Ruling 6(8) points the other way |

**Emitting any reserved member or value at this format version is non-conformance, not
extension.** Adding a member to `declarations` also violates C6 independently, which is the
belt to OF-4's braces.

### 3.2 `case`

| Member | Type | Meaning |
|---|---|---|
| `act_oracle_envelope_sha256` **[P1 · T-1]** | 64 lowercase hex, or the tagged absence `{"t":"absent"}` | sha256 of the canonical bytes of the case's Act Oracle **envelope** core (§9). `{"t":"absent"}` **only** for a case that reaches no act step and no derive step and therefore has no envelope — and that absence is itself a claim the comparator checks against the envelope inventory. |
| `id` | ASCII string | the frozen case identifier |
| `source_sha256` | 64 lowercase hex | sha256 of the case's program source **octets as delivered** |
| `environment_sha256` | 64 lowercase hex | sha256 of the case's canonicalized environment declaration as delivered by the harness |

`case` fixes *what was judged*. It is inside the hashed core deliberately: an envelope that
is byte-identical for two different inputs would be worse than useless.

**[P1] Why the oracle digest belongs here and not in `attestation`.** Under the Act Oracle
Interface, the frozen transcript is *case data* in exactly the sense the other two digests
are. If it sits outside the hashed core, two judges consuming **different** transcripts can
produce byte-identical observations and be scored green — the confound PROTOCOL §3 names
("an oracle interface is a confound factory") arriving through the one door the format left
open. Members are ordered ascending per C4, which places the new member first; that is a
byte-level consequence and is why T-1 is version-breaking.

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
| **integers — arbitrary precision** | **PRESENT as a type; PRECISION UNDERDETERMINED** | `LITERAL := … \| INTEGER` (GRAMMAR §1). The law states declared bounds on source *depth* and *node count* (GRAMMAR §2 V-SHAPE) but no bound on integer *magnitude*, and never states that integers are unbounded. Encoded as an unbounded decimal string (§4.3) — the only choice that cannot silently truncate. **[DEFICIT SD-22]** — **[P1]** Ruling 6 does **not** cure this; magnitude is a separate Parcel B item. |
| **reduced rationals** | **ABSENT — N/A** | Not in `LITERAL`. A ratio is refused as a source atom. No encoding is defined at /0; a reserved encoding is given in §4.9 and is forbidden to emit. **[P1]** Ruling 6(9) names ratios among the constructs that must acquire an **explicit refusal phase and code**; that would make the refusal *specifiable*, and would not make the value representable. |
| **Unicode strings** | **PRESENT; normalization and scalar policy UNDERDETERMINED** | `LITERAL := STRING …`; the lane's reader opens sources with an explicit UTF-8 external format. The law states no normalization form and no forbidden-scalar rule. Encoded as UTF-8 octets in hex (§4.2) with the policy declared in-band (§3.1). **[DEFICIT SD-23]** — **[P1]** Ruling 6(8) would settle normalization (none) and leave the validity rule to the new reader grammar. |
| **byte strings** | **ABSENT — N/A** | No octet-vector value exists; V-DATA's closed atom vocabulary is STRING, INTEGER, KEYWORD, lawful symbol. The one hex-shaped observable, `act-id-hex`, is a **string** (AUTHOR-GUIDE §4), not an octet vector, and is encoded as a string. Reserved encoding in §4.9. |
| **segmented identifiers** | **ABSENT as a value type — N/A** | Programs cannot construct or observe a segmented identifier. The act-identity *is* a segmented Journal /0 identifier upstream, but the language layer observes only its last segment, as a string (AUTHOR-GUIDE §4). Reserved encoding in §4.9. **[DEFICIT SD-26]** — the public MA0 texts never say which specification governs that segment's derivation. |
| **ordered sequences** | **PRESENT** | `(list VEXPR+)` (GRAMMAR §1). Order is authored and meaningful; nesting is meaningful. Encoded in §4.4, order preserved, nesting preserved exactly. |
| **ordered records / identifier-keyed maps** | **ABSENT as a value type — N/A** | No record, map, alist, or plist value is constructible in a program. The *envelope* structures (program result, act summary) are fixed-shape records defined by this format, not by a general record type in the language. Reserved encoding in §4.9. |
| **keywords** | **PRESENT (not on the wish-list, and load-bearing)** | `LITERAL := … \| KEYWORD`; `refuse (:code KEYWORD)` with an **open** author-chosen keyword set (GRAMMAR §1, §2 V-ATOMS "user `:code` keywords"). A keyword is **not** a string and must not be collapsed into one. Encoded in §4.2. **[P1]** Ruling 6(2) would restrict a keyword's *name alphabet* to ASCII at /0; the tag, the encoding, and the string/keyword distinction are unaffected. |
| **absence keywords as values** | **PRESENT ONLY IN SOURCE** | `(field X AXIS)` over a facet whose standing is not `:present` yields the **standing keyword** as a program value. Public law defines standings for *matching* only (GRAMMAR §4; AUTHOR-GUIDE §6) and never for *projection*. Encodable (it is a keyword) but registered: **[DEFICIT SD-16]** |

**Net value domain at /0: string · integer · keyword · ordered sequence.** Four things.
Everything else on the wish-list is N/A, and this format defines no way to say it.
**[P1] Round P did not change this domain and is not authorized to.**

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
  decide whether two runs touched the same store. **[DEFICIT SD-10]** — **[P1]** and under
  the envelope, `store_id` is **carried from §9's envelope**, so agreement on it is a
  transcription property; see §9.5.

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

**[P1] Ruling 6 does not touch this.** The condition-family vocabulary and the
law→condition-family→code table are *separate* Parcel B items (Ruling 5, Parcel B list).
Nothing in §10 improves the standing of this closed set.

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
`boundary-exceeded` (an implementation limit was reached), `producer-nonconformance`,
**[P1]** `envelope-exhausted` (§9.3: the judge reached more act or derive steps than the
frozen envelope holds), **[P1]** `envelope-mismatch` (§9.3: the envelope delivered does not
bind to this case). A producer that meets any of these **refuses the observation** rather
than guessing — the same discipline the subject language applies to its own sources.

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
  arm strings are case-bearing (`B-L1`, `C-i`) and must not be normalized. **[P1]** Ruling
  6(7)'s datatype argument applies here with full force and is *already* the format's
  practice: an arm name is a **declared string**, not an identifier, and therefore case-exact.
- `act_id_hex` is a string, or `{"t":"absent"}`. **The law's nullability statement is
  incomplete**: AUTHOR-GUIDE §4 documents `NIL` for `verdict` on a mint-refused act but
  gives no nullability rule for `act_id_hex`. **[DEFICIT SD-19]**
- `verdict` is *"the agreement verdict string"* with **no published vocabulary**.
  **[DEFICIT SD-18]**

**[P1] Provenance of these five members under the envelope.** `arm` is **judge-produced**
(the judge chose which act step to reach, on which arm). `act_id_hex`, `class`,
`disposition`, and `verdict` are **envelope-carried** — supplied by §9 and transcribed. The
consequence is stated plainly in §9.5 and must be attached to any reading of a green run:
**agreement on an envelope-carried member is a transcription property, not a semantic one.**

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

**[P1] The envelope strengthens the indirect witness without inventing an observable.**
Because §9 binds requests **by ordinal** (§9.3, AOE-2), a judge that selects the wrong branch
consumes the wrong response and the divergence propagates into `acts` — visibly. This is the
design reason ordinal binding was chosen over content matching; content matching would let a
wrong-branch judge silently draw the "right" response and agree. The envelope thereby makes
branch selection *more* observable while adding **zero** members to `observation`.

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
non-conformance, not extension. **[P1]** The rule carries unchanged to
`ma0-observation/0-candidate-p1`, and Rule OF-4 (§3.1) applies the same discipline to
declaration vocabulary.

---

## 5. Canonicalization — byte-level, so two implementations produce identical bytes

A conforming producer serializes `observation` by these rules and no others. Two producers
that both honor them emit **byte-identical** streams for the same judgment, which is what
makes sha256 comparison meaningful. **[P1] The same rules govern the envelope core (§9.4)**
— one canonicalization law for the whole campaign, never two.

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
| **C13** | **Independent re-derivation.** The canonical bytes are a function of the judgment alone. No producer may consult ambient state — printer settings, locale, environment variables, library defaults — in producing them. (Kernel /0 §2.3 [F: HOST-3] applied one level out.) **[P1]** The frozen envelope is *case data*, not ambient state; consulting it is required, not a violation. |

### 5.1 Comparison procedure

1. **[P1]** The harness delivers the frozen envelope for case *c* to **both** judges, and
   records its digest. Both judges' `case.act_oracle_envelope_sha256` must equal that digest;
   a mismatch **voids the case** before any semantic comparison (§9.3, AOE-3).
2. Both judges emit their document for case *c*.
3. The comparator extracts each `observation`, re-serializes it under C1–C11 **itself**
   (never trusting either producer's serializer), and computes sha256.
4. **Equal digests ⇒ conformant on this case.** Unequal digests ⇒ the comparator emits a
   structural diff naming the first divergent path in canonical order, plus the advisory
   `code` column (§4.6.2) reported separately.
5. `attestation` is never read by the comparator except to record which file was whose.
6. **[P1]** The comparator reports envelope-carried members (§9.5) in a **separate column**
   from judge-produced members. A green run in which *every* difference-bearing member is
   envelope-carried is a transcription result and must be reported as one.

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
    "format": "ma0-observation/0-candidate-p1",
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
      "act_oracle_envelope_sha256": "<sha256 of the canonical bytes of the case's envelope core>",
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
  public text fixes a value, and none was read from a run. **[P1]** Under §9 this member is
  **envelope-carried**.
- `acts[0].verdict` — **SYNTHETIC**: the octets of `agree`. The guide publishes no verdict
  vocabulary (**[DEFICIT SD-18]**). **[P1]** Envelope-carried.
- `acts[0].disposition` / `.class` — `returned` / `a`. **NOT in the AUTHOR-GUIDE**: §4
  publishes the *vocabulary* but not the arm→disposition/class mapping (F-GUIDE-1 territory).
  The pairing shown is taken from the P5 packet's guide addendum table
  (`notes/2026-08-10-p5-sol-inhabitation-protocol.md`, "Guide addendum content"), whose values
  were extracted from the exported fixture table. **[DEFICIT SD-3, SD-28]** **[P1]**
  Envelope-carried.
- `outcome.store_id` — **SYNTHETIC**; and per §4.5 a store-id is a label, never an identity.
  **[P1]** Envelope-carried.
- `case.*_sha256` and `attestation.observation_sha256` — angle-bracket slots, not values. A
  live producer fills them; this document must not fabricate a digest. **[P1]** This now
  includes `case.act_oracle_envelope_sha256`, which is likewise a slot and not a value.
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
    "format": "ma0-observation/0-candidate-p1",
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
      "act_oracle_envelope_sha256": "<sha256 of the canonical bytes of the case's envelope core>",
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
   **[P1] THE STANDING OF THIS SENTENCE IS EXACTLY WHAT RULING 6 WOULD CHANGE, AND HAS NOT
   YET CHANGED.** Today the upcasing is an *unexamined readtable inheritance* the format
   declares around; if Parcel B adopts Ruling 6(3)(4) it becomes *published law* and a
   non-upcasing J2 is wrong **by statute** rather than wrong **by accident of substrate**.
   The bytes shown would be identical either way. The *reason* they are correct would not be.
   See §10.2.
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
| **[P1] PD-17** | **Oracle-transcript tampering.** One judge is handed an envelope altered in one byte — a `verdict` flipped, an `ordinal` renumbered, a facet standing changed, a `prefix_lengths` entry edited. **Three sub-plants are required, and the third is the real test:** (a) a tamper that changes a *carried* observation member; (b) a tamper that changes only *ordering*; (c) **a tamper the case never reads** (edit a `prefix_lengths` entry for a boundary this program never reaches). Sub-plant (c) is caught **only** by the digest binding — if it passes, `case.act_oracle_envelope_sha256` is not doing its job and T-1 has bought nothing. | §3.2 `act_oracle_envelope_sha256`, §5.1 step 1, §9.3 AOE-3 |
| **[P1] PD-18** ⚠ **CONDITIONAL — INERT AT /0** | **Case-canonicalization divergence.** *Activates only if/when Ruling 6 is adopted in Parcel B.* Four sub-plants: (a) an ASCII identifier canonicalized to lowercase instead of uppercase; (b) source case preserved rather than canonicalized; (c) a **seat name** canonicalized (it must stay exact, case-sensitive Unicode — Ruling 6(7)); (d) a non-ASCII identifier **accepted** rather than refused (Ruling 6(2)). Until Parcel B adopts Ruling 6, **this row is a design placeholder and MUST NOT be built as a live gate** — a gate that enforces unadopted law is worse than a missing gate, because it convicts a J2 that correctly implemented the *published* packet. | *(on adoption)* `declarations.name_equality`, `seat_name_equality`, `identifier_alphabet` — all reserved and forbidden at /0 per Rule OF-4 |

**Two further teeth that are about the comparator, not the format**, and are required by the
same logic: (a) an **identity control** — the same judgment serialized twice by the same
producer must be byte-identical, run twice, proving determinism before difference means
anything; and (b) a **cross-producer control on a case both judges are known to agree on**,
proving the comparator can say *green* as well as *red*.

**[P1] A third comparator tooth, required by the envelope:** (c) a **transcription control** —
a case constructed so that *every* member of `observation` that could differ is
envelope-carried (§9.5). Two judges will agree on it trivially. **The comparator must report
that agreement in the transcription column and must not report it as semantic conformance.**
If the comparator scores this case as ordinary green, the §9.5 accounting is decorative.

---

## 8. What this format does not do

- It does **not** make J1 and J2 comparable on the substrate layer. Digest arithmetic, journal
  bytes, capability recognition, and Surface /2 derivation are supplied through the Act Oracle
  Interface and are not judged here (PROTOCOL §3). **[P1]** This is the PortJ-L/0 versus
  PortJ-F/0 line (Ruling 3), and it is a scope boundary, not a caveat.
- It does **not** settle any deficit. Every `[DEFICIT SD-nn]` marker above is a silence in the
  public law that this format *declares around*, in-band, so the silence produces a visible
  difference instead of an invisible agreement. **[P1] §10 does not settle any deficit
  either** — it records what an owner-directed candidate law *would* settle if adopted.
- It does **not** claim that byte-identical envelopes mean the two implementations mean the
  same thing. It means they *said* the same thing about the cases they were shown. The
  difference is the whole reason the hidden vector bank exists.
- **[P1]** It does **not** claim that agreement on an envelope-carried member is evidence of
  anything but transcription (§9.5).
- It is **not adopted**, and neither is the base it observes. **[P1] Nor is this revision.**

---

# **[P1] 9. The candidate Act Oracle envelope — `ma0-act-oracle/0-candidate-p1`**

**STANDING: CANDIDATE, and its standing is one rung lower than the rest of this document.**
The Act Oracle Interface itself is accepted in principle by Ruling 3 ("a legitimate
instrument for testing the portability of the Many Acts language layer"); **the envelope's
concrete shape below is Round-P design work and has received no owner disposition at all.**

### 9.1 What the envelope is, in one sentence

> The envelope is the **host-neutral, canonically encoded, hash-bound freeze of every
> substrate answer a case's judge is permitted to consume** — an **INPUT artifact**, shared
> by both judges, hashed into the packet at freeze, and **never a compared observation.**

Four adjectives, each load-bearing and each doing work the frozen original's §1 gestured at
but did not encode:

- **host-neutral** — no CL printed forms, no host object graphs, no package-qualified names;
  the same tagged-JSON idiom as §4, so a Python J2 reads it with a stdlib JSON parser and
  nothing else (PROTOCOL §4's standard-library-only constraint applies to the envelope
  reader exactly as it applies to the program reader);
- **canonically encoded** — C1–C13, verbatim, so the envelope has a *byte identity* and
  therefore a *digest*;
- **hash-bound** — that digest lives in the hashed comparison core (§3.2, T-1), so the
  transcript cannot be swapped between judges without the comparison seeing it;
- **an input, never an observation** — the envelope is *not* compared; §9.5 states exactly
  what that costs.

### 9.2 Shape

A conforming envelope file is a JSON object with **exactly two** members, the same split and
for the same reason as §2:

```
{ "attestation": { … }, "envelope": { … } }
```

`envelope` is the hashed core. `attestation` records the provenance of the instrumented
native run that produced it and is excluded from the digest.

**`envelope` — required members, ascending order (C4):**

```
act_responses        – array, ordered by request ordinal (§9.2.1)
case                 – object: {environment_sha256, id, source_sha256} (§9.2.4)
derive_responses     – array, ordered by request ordinal (§9.2.2)
envelope_version     – decimal-string integer; "0" at this revision
prefix_lengths       – array, ordered by step-boundary ordinal (§9.2.3)
request_discipline   – object: the binding rule, in-band (§9.3)
```

`envelope.case` deliberately does **not** carry `act_oracle_envelope_sha256` — a manifest may
never include its own hash, and an envelope that hashed itself would be an unsolvable
fixpoint wearing a completeness costume.

#### 9.2.1 `act_responses[i]`

```json
{ "act_id_hex": <STRING|absent>,
  "arm": <STRING>,
  "class": "a",
  "disposition": "returned",
  "ordinal": "0",
  "verdict": <STRING|absent> }
```

- `ordinal` — decimal-string integer per C9, **zero-based, dense, strictly ascending**, equal
  to the array index. It is carried *redundantly* on purpose: an envelope whose ordinals
  disagree with its own array order is malformed, and PD-17(b) plants exactly that.
- `arm` · `act_id_hex` · `class` · `disposition` · `verdict` — the same five members and the
  same closed vocabularies as §4.7, hex-encoded by the same rules. **The envelope and the
  observation share one vocabulary and one encoding; a second, envelope-only spelling of the
  same closed set would be a second equality law** (the structural defect Ruling 6(5) names,
  reappearing one layer down).
- `verdict` is `{"t":"absent"}` on a mint-refused act, per AUTHOR-GUIDE §4. **[DEFICIT SD-18]**
  — the vocabulary is still unpublished, so the envelope *carries* a verdict string it cannot
  validate.
- `act_id_hex` nullability remains unstated in the public law. **[DEFICIT SD-19]** The
  envelope therefore permits `{"t":"absent"}` and records that permitting it is a *format
  decision*, not a reading.

#### 9.2.2 `derive_responses[i]`

```json
{ "evidence_class": "none",
  "execution": "settled",
  "ordinal": "0",
  "provenance": "none",
  "seat": <STRING>,
  "seat_resolution": "resolved",
  "standings": { "evidence_class": "present",
                 "execution": "present",
                 "provenance": "present" } }
```

- `seat` is a **declared string**, carried exactly, **case-sensitive**, hex-encoded. This is
  the one place in the whole campaign where the slot/seat asymmetry (**[DEFICIT SD-15]**,
  Ruling 6(6)(7)) is directly visible in an artifact, and stating it here positively is the
  point: **a seat name is a string datum, an identifier is a name; they are different
  datatypes and are therefore compared by different laws.**
- `seat_resolution` ∈ `resolved · unresolved` — a closed set **this format declares**, because
  the public law names the seat-map and its failure mode but publishes no token for the
  outcome. Registered as a format decision, not a reading. **[DEFICIT SD-3]** neighbours it.
- the three axes and their standings use the published closed vocabularies (GRAMMAR §4,
  AUTHOR-GUIDE §6) under `enum_spelling`.
- `standings` is required and total: a facet is `present`, `absent-from-evidence`, or
  `malformed-in-evidence`. Where the standing is not `present`, the axis member carries the
  **standing keyword itself** as the projected value (**[DEFICIT SD-16]**) — the envelope thus
  makes SD-16's underdetermination visible in the input rather than letting each judge invent
  a projection.

#### 9.2.3 `prefix_lengths[i]`

```json
{ "boundary_ordinal": "0", "validated_prefix_length": "8" }
```

One entry per **step boundary**, so that `derive`-appends-nothing (W-DERIVE-NE-PERFORM) and
untaken-arm-leaves-no-footprint (W-BRANCH-ONE) are checkable **without a store**.

⚠ **A standing warning attaches to this member.** The magnitudes here are exactly the
substrate quantities the vector classification flags as contaminated (C-7: `prefix-frames=8`,
`=21`, `=22`, `earlier-frame-rows=10`; **no public law derives them**). Putting them in the
envelope makes them *available* to a J2; it does **not** make them *specified*. A vector whose
expectation is a prefix magnitude remains a transcription check under §9.5, forever, until
One Act /0 has public prose law. **The envelope is not a cure for SD-13.**

#### 9.2.4 `envelope.case`

`{environment_sha256, id, source_sha256}` — identical values to the observation's §3.2
members of the same names. **The envelope binds itself to exactly one case**, and a judge
that receives an envelope whose `case` does not match the case it was asked to judge MUST
emit `observation_refused` with reason `envelope-mismatch` (§4.6.2). It must not proceed
with a warning.

### 9.3 The three envelope rules

**AOE-1 — INPUT, NEVER A COMPARED OBSERVATION.** No member of `envelope` is compared between
judges; the envelope is *identical* for both by construction, so comparing it would measure
the harness. The envelope's role in the comparison is exactly one thing: its **digest** is
bound into the hashed observation core (§3.2). Values the public law places in the act
summary (§4.7) do travel from envelope to observation — that is the law's own shape, not a
leak — and §9.5 accounts for what their agreement is worth.

**AOE-2 — REQUEST IDENTITY IS BY ORDINAL, STRICTLY, AND NEVER BY CONTENT.** The *n*-th act
step a judge reaches, in execution order, consumes `act_responses[n]`; the *n*-th derive step
consumes `derive_responses[n]`; the *n*-th step boundary consumes `prefix_lengths[n]`.

> **This is the load-bearing design choice of the whole envelope, and it is chosen against the
> obvious alternative.** Content matching — "find the response whose `arm` equals the arm this
> step names" — is friendlier and is wrong: it lets a judge that selected the **wrong branch**
> silently draw the response that belongs to the right one, converting a branch-selection
> divergence into an agreement. Ordinal binding makes a wrong branch consume a wrong response
> and pushes the error forward into `acts`, where the comparison can see it. **An oracle that
> forgives the judge's mistake is an oracle that measures itself** (PROTOCOL §3's confound,
> arriving through the friendliest possible door).

In-band, so the rule travels with the bytes:

```json
"request_discipline": { "binding": "ordinal-strict",
                        "on_overrun": "observation-refused",
                        "on_underrun": "permitted" }
```

- **overrun** (the judge reaches more steps than the envelope holds) ⇒
  `observation_refused`, reason `envelope-exhausted`. It is *not* an error to be invented
  around: a judge asking for an act the canonical run never performed has already diverged,
  and refusing the observation says so without fabricating a response.
- **underrun** (the judge reaches fewer steps) ⇒ **permitted, and normal.** A lawful branch
  may perform no acts at all (W-BRANCH-ONE: `summary-count=0`). The divergence, if any,
  surfaces in `acts` — which is where §4.8 says branch selection is observed.

**AOE-3 — TAMPER DETECTION IS THE DIGEST'S JOB, AND THE DIGEST MUST BE INSIDE THE
COMPARISON.** The envelope's canonical bytes (C1–C13) have one sha256; that digest is
recorded in the frozen packet manifest, delivered by the harness, and written by **both**
judges into `case.act_oracle_envelope_sha256`. §5.1 step 1 voids the case on mismatch, before
any semantic comparison. PD-17(c) exists to prove the binding is real: a tamper the case never
*reads* must still turn the comparator red.

### 9.4 Canonicalization of the envelope

**C1–C13 apply verbatim to `envelope`**, with `envelope`'s core standing where `observation`
stands. In particular: no whitespace; no JSON numbers; no `null`; ascending member order;
lowercase hex; no backslash anywhere; and the digest lives in the *manifest and the
observation*, never inside the envelope itself.

**One canonicalization law for the campaign.** A second serializer for the envelope would be
a second place for a serializer bug to live, and — worse — a second place for two judges to
share one. The comparator re-serializes the envelope under C1–C11 itself before computing its
digest, for the same reason §5.1 re-serializes observations.

### 9.5 What the envelope costs the claim, in members and in plain words

Of the members of `observation` that can differ between judges, some are **judge-produced**
and some are **envelope-carried**. The accounting is not decoration; it is the honest content
of a green run.

| `observation` member | Provenance | What agreement shows |
|---|---|---|
| `program_name` | judge-produced | ingestion + result construction |
| `outcome.kind` · `.disposition` · `.value` · `.refusal_code` · `.refusal_detail` | judge-produced | matching, branch selection, terminal discipline, refusal behavior, value construction |
| `outcome.condition_type` | judge-produced *(with a caveat)* | validation and refusal behavior — **except** for conditions the substrate raises (e.g. a propagated One Act condition), which are envelope-carried |
| `outcome.store_id` | **envelope-carried** | transcription |
| `acts[i].arm` | judge-produced | which act steps the judge reached, in which order |
| `acts` **length and order** | judge-produced | summary ordering, branch selection |
| `acts[i].act_id_hex` · `.class` · `.disposition` · `.verdict` | **envelope-carried** | transcription |
| `case.*` | harness-supplied | that both judges judged the same case with the same transcript |
| `declarations.*` | judge-declared | that both judges resolved the same silences the same way |
| `grammar_version` | fixed | nothing |

> **Said without cushioning: on a case whose only difference-bearing members are
> envelope-carried, two judges agree because they were handed the same answers.** That is a
> transcription result. It is not worthless — a judge that mangles a transcribed value has a
> real defect — but it is **not evidence of semantic portability**, and the comparator's
> separate column (§5.1 step 6) exists so that no summary can quietly total the two together.

### 9.6 What the envelope does not do

- It does **not** make the substrate portable, and a green PortJ-L/0 run says nothing about
  PortJ-F/0 (Ruling 3).
- It does **not** specify anything. Every magnitude it carries whose derivation is unpublished
  (prefix lengths, act-identity digests, store-ids, verdict strings, classification tokens) is
  unpublished *still*. **[DEFICIT SD-13, SD-18, SD-26]**
- It does **not** exist yet. No envelope has been produced, no instrumented native run has
  been performed, and the replay adapter that would produce one is **not authorized**
  (Ruling 3 requires it be an external harness or wrapper, and — if J1 must be modified — a
  separately identified pre-campaign candidate passing a byte-identity gate over the full
  inherited floor; Ruling 7 and the "Rounds still closed" list keep that shut).
- It does **not** claim any evidence. **Zero evidence remains earned.**

---

# **[P1] 10. Ruling 6 — owner-directed CANDIDATE LAW AWAITING PARCEL B**

> **STATUS OF EVERYTHING IN THIS SECTION: owner-directed candidate law awaiting Parcel B.
> NOT adopted. NOT implemented. NOT frozen. NOT in force.** `OWNER-RULINGS-2` authorizes
> Round P to *record* Ruling 6 and forbids describing the reader/case law as adopted,
> implemented, or frozen. Nothing in §§0–9 above depends on any clause below; the /0 body
> stands on the frozen original's verified value domain (**string · integer · keyword ·
> ordered sequence**) and on the published law as it exists today.

Each entry states **(a)** the ruling clause, **(b)** what this format **WILL** encode if
Parcel B adopts it, **(c)** the current status, and **(d)** what the format does **today**.

### 10.1 A substrate-neutral lexical grammar; ASCII alphabet at /0 — Ruling 6(1)(2)

**(a)** *"source identifiers and keyword tokens use an explicitly published, substrate-neutral
lexical grammar. Common Lisp `read` is not the normative grammar."* · *"The /0 identifier and
keyword alphabet is ASCII. Unicode remains fully available inside string literals but is not
admitted into identifier or keyword tokens at /0."*

**(b) WILL encode on adoption.** A sixth declaration, `identifier_alphabet: "ascii-only"`
(reserved in Rule OF-4), enters `declarations`; the format version bumps. A non-ASCII
identifier or keyword token becomes **lexically invalid input** (Ruling 6(9)'s first
category), producing a `condition` outcome with the reader-grammar's own refusal code — not
an `observation_refused`, because the refusal is then *the subject language's*, not the
observer's.

**(c) STATUS: CANDIDATE.** Awaiting Parcel B.

**(d) TODAY.** The format encodes keyword names as observed octets and says nothing about the
admissible alphabet, because the packet says nothing. **[DEFICIT SD-08]** stands at severity
S1 and is named in the register as the single largest deficit and the most likely site of a
class-2 verdict.

### 10.2 Case-insensitive at ingestion, canonical **uppercase** for identity — Ruling 6(3)(4)

**(a)** *"ASCII letters in identifiers and keywords are case-insensitive at ingestion and
canonicalized to uppercase for identity and observation"* — so `:unexpected`, `:Unexpected`,
`:UNEXPECTED` denote one keyword whose **canonical observed name is `UNEXPECTED`** — and
*"Program-authored refusal codes are keywords and follow that same rule. P5's source
`:earth-entry-quarantined` therefore canonically observes as `EARTH-ENTRY-QUARANTINED`. This
is law, not an SBCL accident."*

**(b) WILL encode on adoption.** `declarations.keyword_identity` takes the reserved value
`"ascii-uppercase-canonical"` (Rule OF-4). The `{"t":"keyword","name_utf8_hex":…}` encoding is
**unchanged** — the octets in §6.3 stay `554e4558504543544544` — but the *warrant* changes
from "this is what SBCL's readtable did and we declared around it" to "this is the published
canonical identity." PD-18(a)(b) become live gates. **[DEFICIT SD-14]** is cured; **[SD-07]**
(upcase vs downcase vs full Unicode folding) is **dissolved rather than cured** at /0, because
6(2) removes the non-ASCII cases in which simple and full case mapping differ.

**(c) STATUS: CANDIDATE.** Awaiting Parcel B.

**(d) TODAY.** `keyword_identity` = `"symbol-name-verbatim"`, an **observed** identity, with
SD-14 and SD-8 attached. §6.3's commentary marks the difference explicitly.

### 10.3 ONE equality law — Ruling 6(5) *(the most consequential entry in this section)*

**(a)** *"Closed enumerations may be rendered in lowercase inside human-facing documentation
and transport glosses, but their normative identity must be mechanically related to the
canonical token identity. **The observation format must not maintain two competing equality
laws.**"*

**(b) WILL encode on adoption — and here the format must change, not merely re-declare.**

⚠ **The frozen original maintains exactly the structure this clause forbids, and Round P
records that finding rather than repairing it.** Two declarations sit side by side in §3.1:

| Declaration | Applies to | Spelling in the hashed core |
|---|---|---|
| `keyword_identity: "symbol-name-verbatim"` | **open-set** keywords (program-authored `:code`, keyword literals) | **UPPERCASE** in practice (`UNEXPECTED`) |
| `enum_spelling: "public-law-lowercase"` | **closed-set** keywords (dispositions, classes, axes, standings) | **lowercase** (`refused`, `c-i`, `settled`) |

**Two keyword-valued vocabularies, two spellings, two equality laws, in one hashed core.**
The format's own defence — that closed sets are *published* in lowercase while open sets are
*observed* upcased — is a true account of how it got there and is not a defence at all under
6(5).

On adoption, the cure is **one canonical identity plus a mechanically derived gloss**:

- the hashed core carries the **canonical uppercase token** for *both* vocabularies;
- lowercase renderings live **only** in `attestation.gloss`, which is never compared;
- the relation is a published total function on the admitted alphabet —
  `gloss = ascii-downcase(canonical)`, `canonical = ascii-upcase(gloss)` — and, restricted to
  ASCII by 6(2), it is a **bijection**, which is what "mechanically related" has to mean if it
  is to mean anything checkable;
- a new declaration `name_equality: "single-law-canonical-uppercase"` (Rule OF-4) records it
  in-band;
- **the format version bumps and the comparison unit changes again**: `"refused"` becomes
  `"REFUSED"`, `"c-i"` becomes `"C-I"`. Every canonical byte stream in §6 changes. This is a
  larger break than T-1 and must not be smuggled in as a spelling preference.

**(c) STATUS: CANDIDATE.** Awaiting Parcel B. **The two-law structure remains in force in
§§0–9 above**, because the format may not implement unadopted law — and because implementing
it *unilaterally* would produce a format that disagrees with the frozen original for reasons
no owner ruling authorized.

**(d) TODAY.** Two declarations, two spellings. Registered here as a **known structural
defect under a candidate law**, visible, dated, and not repaired.

### 10.4 Slot and input names are identifier-like — Ruling 6(6)

**(a)** *"Slot and input names are identifier-like names and follow ASCII case-insensitive
canonicalization."*

**(b) WILL encode on adoption.** Slot and input names appear in the observation only
indirectly (a slot name may occur inside a refusal detail; an input value flows into a
result), so no member changes shape. What changes is that a J2 may **implement**
`%ma0-name-key`'s behavior from the packet instead of reverse-engineering it: today the rule
lives only in source (**[DEFICIT SD-07]**).

**(c) STATUS: CANDIDATE.** **(d) TODAY.** The format encodes whatever octets the judge
produced and declares nothing about name equality, because the packet declares nothing.

### 10.5 Seat names are declared strings — Ruling 6(7), stated positively

**(a)** *"Seat names are declared strings, not identifiers. They remain exact, case-sensitive
Unicode strings. The slot/input versus seat asymmetry is therefore retained but must be stated
positively and justified by datatype, not left as an omission for the reader to
reverse-engineer."*

**(b) WILL encode on adoption.** `seat_name_equality: "exact-unicode-case-sensitive"`
(Rule OF-4) enters `declarations`; §9.2.2's `seat` member's case-exactness stops being a
format decision and becomes law. PD-18(c) becomes a live gate.

**The asymmetry, stated positively as the ruling requires** — and it is worth saying that the
format already *practises* this justification in §4.7, for arms: **a name whose datatype is
IDENTIFIER is canonicalized; a name whose datatype is STRING is exact.** `editor-grant` is an
identifier and matches `EDITOR-GRANT`; `"s-entry"` is a declared string and does not match
`"S-Entry"`; `"B-L1"` is a declared string and is case-bearing. One rule, applied by datatype,
producing what looks like an asymmetry only if you forget which datatype you are holding.
**[DEFICIT SD-15]** is cured by *stating* this, not by changing it.

**(c) STATUS: CANDIDATE.** **(d) TODAY.** SD-15 records the asymmetry as an *undeclared*
behavior, and the register marks it a **fork** (state the asymmetry, or decide it is a defect
and unify). **Ruling 6(7) takes the first branch.** Recording that the fork has an
owner-directed answer is not the same as the answer being adopted.

### 10.6 Strings keep their authored UTF-8 scalar sequence — Ruling 6(8)

**(a)** *"Unicode normalization is not applied to string values at /0. Strings preserve their
authored UTF-8 scalar sequence exactly, subject to whatever explicit validity rule the new
reader grammar adopts."*

**(b) WILL encode on adoption.** `declarations.string_normalization` keeps the token
`"as-observed"` and changes **standing**: from *the format's choice, declared in-band so a
divergence surfaces* to *the subject language's published law*. C10 keeps its text and gains a
citation. The reserved value `"nfc-enforced-at-input"` (Rule OF-4) becomes effectively dead
unless a later round overrules the ruling.

**One thing 6(8) leaves open, and the format must not close it:** *"subject to whatever
explicit validity rule the new reader grammar adopts"* — lone surrogates, noncharacters,
overlong encodings. Until that rule exists, C11's `observation_refused` /
`unrepresentable-scalar` path stays exactly where it is, and **[DEFICIT SD-23]**'s
forbidden-scalar half stays open.

**(c) STATUS: CANDIDATE.** **(d) TODAY.** `"as-observed"` as a **format decision**, declared
in-band, with SD-23 attached.

### 10.7 The reader must name what it admits; three-way refusal taxonomy — Ruling 6(9)

**(a)** *"The constitutional-completion parcel must define the exact result of all non-grammar
reader constructs. It must distinguish: lexically invalid input; a syntactically readable but
unlawful value; a valid form rejected by the validator. Do not inherit `#x`, `#.`, ratios,
vectors, characters, dotted pairs, package markers, comments, escapes, or radix behavior
merely because Common Lisp recognizes them. Each admitted construct must be named by the
Lisp+ grammar; everything else must have an explicit refusal phase and code."*

**(b) WILL encode on adoption — and this is the clause that most changes the observation
format's outcome grammar.** A **three-way refusal taxonomy** must become visible in
`outcome`, because the three phases are three different facts about a program:

| Ruling 6(9) phase | Candidate encoding on adoption |
|---|---|
| **lexically invalid input** | `outcome.kind = "condition"` with a reader-phase condition family and a reader-grammar code |
| **syntactically readable but unlawful value** | `outcome.kind = "condition"`, atom/value phase (the present `V-DATA`/`V-PKG` territory) |
| **valid form rejected by the validator** | `outcome.kind = "condition"`, validator phase (the present `V-SHAPE`/`V-BIND`/… territory) |

Adopting 6(9) is therefore a **precondition for `code_normative` becoming `true`** (§4.6.2):
a published phase taxonomy plus a published code table is exactly what a clean-room J2 needs
in order to emit a conforming code, and §4.6.2's advisory-column arrangement exists only
because neither exists today. Ruling 6(9) supplies half.

**Every construct the ruling names is already a live vector or a live gap in the bank** —
`#.` (W-V-READ), vectors/characters/floats/pathnames (W-V-DATA), package markers (W-V-PKG),
dotted pairs (W-V-SHAPE), ratios (refused, uncovered), radix and escapes (uncovered). See the
vector classification's Ruling-6-pending table.

**(c) STATUS: CANDIDATE.** **(d) TODAY.** `code_normative` is **`false`**, mandatorily; the
comparator excludes `code` from pass/fail; the three phases are not distinguished in
`outcome` at all, and this format does not distinguish them.

### 10.8 The smaller portable law, chosen deliberately — Ruling 6, closing

**(a)** *"This ruling intentionally chooses a smaller, portable /0 lexical law over an unnamed
dependency on the full Common Lisp reader."*

**(b)/(c)/(d).** Nothing to encode. Recorded because it is the ruling's own account of its
cost, and because a successor reading §10 should know that the shrinkage is **deliberate**,
not an oversight to be helpfully re-widened by a later format revision. A format that quietly
re-admits `#x` because a host reader made it easy would be undoing an owner ruling by
convenience.

### 10.9 Roll-up: what §10 would move, if adopted

| Deficit | Ruling 6 clause | Effect if adopted |
|---|---|---|
| **SD-08** (CL `read` unwritten; S1) | 6(1)(9) | **cured in principle** — the grammar becomes published; the *content* of the grammar is Parcel B's work, not Ruling 6's |
| **SD-14** (keyword identity; S2, pervasive) | 6(3)(4) | **cured** |
| **SD-07** (case-normalization source-only; S2) | 6(2)(3) | **dissolved at /0** — the divergent cases are outside the alphabet |
| **SD-15** (seat/slot asymmetry; S2) | 6(6)(7) | **cured by statement** |
| **SD-23** (string policy) | 6(8) | **half cured** — normalization settled; the forbidden-scalar rule left to the reader grammar |
| **SD-22** (integer magnitude) | — | **untouched** |
| **SD-01** (refusal-code table/datatype) | 6(9) *partially* | phase taxonomy supplied; **the code table is a separate Parcel B item** |
| **SD-11** (printed representations) | — | **untouched** |
| **SD-13** (One Act /0 has no public specification) | — | **untouched, and it is the larger obstacle** |
| **SD-27** (no branch-selection observable) | — | **untouched** |

**The honest shape of that table: Ruling 6 addresses the *lexical* half of the packet's
silence and leaves the *substrate* half exactly where it was.** SD-13 is not a lexical
problem, and no reader grammar cures it.

---

*— revised by SIGNATOR (Claude Opus), Round P, commissioned by the chair (Claude Fable 5),
2026-08-10*
