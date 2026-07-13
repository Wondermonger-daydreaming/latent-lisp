# Lisp+ Canonical Datum /0

**Repository file:** `CANONICAL-DATUM-SPEC.md`  
**Status:** Normative design for clean-room codec implementation  
**Datum format and algebra version:** `0`  
**Document revision:** 2026-07-13  
**Audited repository baseline:** `9e9c031a720cd40559297c9d8bb07bf8137adb54`

The key words **MUST**, **MUST NOT**, **REQUIRED**, **SHALL**, **SHALL NOT**, **SHOULD**, **SHOULD NOT**, **RECOMMENDED**, **MAY**, and **OPTIONAL** in this document are to be interpreted as normative requirements only when written in uppercase. Every such requirement is intended to be testable through codec output, decoded values, typed failures, observable mutation behavior, or prohibited side effects.

---

## 1. Executive decision

Lisp+ Canonical Datum /0 is a small, inert, implementation-independent value algebra with one canonical binary encoding. It contains exactly these abstract value families:

1. unit;
2. booleans;
3. arbitrary-precision signed integers;
4. exact reduced rational numbers that are not integers;
5. Unicode scalar strings;
6. raw byte strings;
7. explicitly namespaced, segmented identifiers;
8. ordered sequences; and
9. identifier-keyed records.

The normative representation architecture is a **hybrid of immutable typed values and canonical octets**. A conforming implementation exposes immutable typed values for traversal and canonical octets for interchange and identity. It may physically retain either or both, but whenever both exist they MUST describe the same abstract datum. Cached bytes cannot become stale because runtime datums are immutable.

The abstract datum algebra defines which values exist and what equality means. Canonical octets are the sole normative cross-process and cross-implementation witness of that equality. For valid /0 datums:

```text
equal-datum(x, y)
    if and only if
canonical-octets(x) = canonical-octets(y)
```

At protocol boundaries, identity comparison MUST therefore be performed on successfully validated canonical octets, or by an equality operation proven equivalent to that octet comparison. Host pointer identity, Common Lisp package identity, Python object identity, printer output, diagnostic notation, and hash equality are not semantic identity.

Canonical Datum /0 deliberately excludes native floating-point values, decimals, general maps, sets, graph identity, cyclic values, host symbols, pathnames, closures, modules, capabilities, warrants, active receipts, and generic opaque extension values. Profiles can represent several excluded informational values as ordinary explicit records, but no record shape can create live authority.

The canonical encoding is a compact, purpose-built binary grammar beginning with the ASCII magic `LPCD` and unsigned format version `0`. It uses one-byte type tags, minimal unsigned LEB128 lengths, zigzag integers, strict UTF-8, count-prefixed sequences, and records whose identifier keys are strictly ordered by their canonical key encodings. A /0 decoder accepts canonical documents only. It rejects nonminimal forms, duplicate fields, out-of-order fields, malformed UTF-8, trailing bytes, unknown tags, and unsupported versions rather than repairing them silently.

This design is prospective. It is not a polished description of the repaired Common Lisp structs, the current v1 proposition grammar, Language A, `mneme-canon/0`, SBCL printing, or MD5 fingerprints.

---

## 2. Status, scope, and non-goals

### 2.1 Status

This document settles the normative design required before independent Common Lisp and Python codecs are written. A codec claiming conformance to Lisp+ Canonical Datum /0 MUST implement the abstract values, equality, canonical octets, immutable runtime contract, strict failures, and conformance laws specified here.

The format name is **Lisp+ Canonical Datum /0**, abbreviated **CD/0**. The wire media-type registration, if one is later assigned, is outside this document.

### 2.2 Intended uses

CD/0 is suitable as the inert substrate for:

- claim propositions and claim-location components;
- scopes and temporal-boundary records;
- names, module references, and procedure-reference records;
- warrant-target components and inert warrant testimony;
- artifact manifests and evidence-edge payloads;
- represented-loss reports;
- Language-A and later profile records;
- cross-process and cross-implementation identity;
- future content-addressing, signature inputs, and Merkle payloads.

Suitability means that these consumers can express their inert fields as CD/0 values. It does not mean that CD/0 defines those consumers' schemas or semantics.

### 2.3 Non-goals

CD/0 does not define:

- a Lisp+ evaluator;
- Lisp+ lexical scope, macro expansion, module loading, or effect handling;
- the complete proposition grammar of any Mneme profile;
- the complete Language-A record vocabulary;
- the located-claim identity projection;
- scope subsumption, temporal logic, corpus identity, or revocation standing;
- capability minting, warrant issuance, authority grants, receipt transitions, or custody;
- procedure behavior, closure identity, or code equivalence;
- a cryptographic hash, signature, key, certificate, or trust system;
- truth, authenticity, freshness, admissibility, or verified lineage;
- a universal resource limit for all deployments;
- a general object serializer for Common Lisp or Python.

No current Common Lisp package name, schema number, filename, persistence path, prototype depth limit, character limit, printer setting, float spelling, digest algorithm, or process-local object identity becomes language law through this specification.

### 2.4 Inertness boundary

Decoding canonical octets MUST return only ordinary inert CD/0 values represented by the codec's fixed private runtime types. Beyond those inert representation nodes, it MUST NOT construct, restore, activate, or mint a capability, live warrant, authenticated claim, verifier authority, authority grant, active receipt, closure, module, file handle, socket, pathname, continuation, restart object, arbitrary source-specified host-language object, or evaluator-owned privileged value.

A privileged Lisp+ value may contain CD/0 fields. The privileged value itself is outside CD/0. A record whose fields spell “capability,” “warrant,” “receipt,” “certificate,” “authority,” or any similar word remains an ordinary record. A separate evaluator transition may inspect such data and produce a privileged value only under separately specified authority and semantics.

---

## 3. Evidence considered

The following precedence governed this adjudication:

1. this specification is implementation-independent and controls future CD/0 behavior;
2. the attached closure report and repaired source/test artifacts are the freshest executable evidence about the current v1 exported-client surface;
3. `LANGUAGE-BOUNDARY.md` supplies the broader architectural classification and migration requirements;
4. the public repository at the pinned baseline supplies surrounding and historical context only where it does not conflict with the attached closure evidence.

Every file in the attached packet was read in full:

| Evidence | SHA-256 | Role in this decision |
|---|---|---|
| `GPT-PRO-V1-COUNTEREXAMPLE-CLOSURE-PACKET-2026-07-13.zip` | `cee06bd06f35f6a26cc5bcd8e9c8fa270805b75424d916a4fadecf757dfe9bce` | Packet container. |
| `LANGUAGE-BOUNDARY.md` | `c1876eba2010b5ab2fc23afb15b7982b4a2ee4550a11238e81a592965111a242` | Architectural audit of the pinned repository baseline. |
| `V1-COUNTEREXAMPLE-CLOSURE.md` | `31ee6f452b6426f5889439b78871cbc83193a1f2b382fb66fa4436ab24ee976a` | Fresh closure ruling and bounded verification record. |
| `V1-CLOSURE-TRACE-LEDGER-2026-07-13.md` | `9a24734e09ccec77c16c67bbd42fc50ea9c52e4b761881ce6b7529ae97cb8f62` | Reproduction, repair, command, and residual-boundary ledger. |
| `counterexample-closure.lisp` | `05a5d39c8044ce8c6ec9697bf8c799803d54e7893e1a3d025a3105fb515e2761` | Permanent ten-case exported-client fixture. |
| `kernel-hardened.lisp` | `fe3f496d626c2401962f00ecfb56faa6b2a969c54d2deabbe9465a9a80f1632c` | Repaired local Common Lisp kernel evidence. |

Historical context was also taken from the public repository at commit [`9e9c031a720cd40559297c9d8bb07bf8137adb54`](https://github.com/Wondermonger-daydreaming/latent-lisp/tree/9e9c031a720cd40559297c9d8bb07bf8137adb54), especially the latent MVP, Language-A validator, canonicalization prototype, constitutional documents, and verification layout. The public tree is not treated as fresher than the attached local closure packet.

The evidence supports two simultaneous conclusions:

- the ten bounded v1 exported-client counterexamples are closed and are not reopened here; and
- their local repair does not provide host-independent datum identity, a language evaluator, authority isolation, stable located-claim identity, cryptographic authenticity, or cross-implementation canonical bytes.

---

## 4. Relationship to the completed v1 closure

### 4.1 Closed defects

The attached closure sprint reproduced ten documented counterexamples against the pinned kernel, recorded a red baseline of `0 passed, 10 failed`, repaired the bounded exported-client surface, and recorded `10 passed, 0 failed`. Its final SBCL 2.4.6 verification record was:

```text
conformance walk:          7/7
adversarial conformance: 18/18
counterexample closure:  10/10
boundary tests:           9/9
Language-A fixtures:     14/14
atelier:                   4 banners
all verification floors green
```

CD/0 accepts those results as executable evidence. It does not reclassify any of the following as an open v1 exported-client defect:

| Closure case | Established v1 result | CD/0 consequence |
|---|---|---|
| Mutable input string leaf | Claim storage no longer aliases the input leaf. | Core strings are immutable values; all codecs must prevent mutable aliases. |
| Mutable accessor string leaf | Exported access no longer reaches internal mutable storage. | Accessors must return immutable views or copies. |
| Stale fingerprint after mutation | The documented exploit is closed by private frozen data and a recheck. | Identity-bearing bytes must be derived from immutable values; cached-byte validity is a language contract. |
| Scope compared by host `eq` | Repaired client behavior uses structural frozen data. | CD/0 equality is structural and host-independent. |
| Mutable scope accessor | Repaired accessor is defensive. | No accessor may expose mutable backing storage. |
| Receipt recommit rewind | Illegal rewind is refused. | Receipt state machines remain outside CD/0; their inert payloads may use CD/0. |
| Receive before commit | Illegal transition is refused. | Same separation. |
| Raw text impersonates receipt revival | Raw decode and receipt revival are separated. | CD/0 decoding never asserts custody or receipt continuity. |
| Raw artifact provenance | Explicit raw decode records untrusted provenance. | Provenance is data unless separately authenticated. |
| Second-handoff predecessor testimony loss | The repaired path preserves predecessor testimony. | Future lineage schemas may use CD/0, but verification and compaction rules remain separate. |

### 4.2 Useful local techniques that are not language law

The repaired kernel's private tagged datum structures, recursive freeze/thaw operations, deep string isolation, structural datum comparison, defensive accessors, transition guards, raw-decode separation, and cumulative predecessor lists are useful Common Lisp implementation techniques. A Common Lisp CD/0 codec may reuse analogous techniques.

They are not normative representations. In particular, CD/0 does not expose or prescribe the repaired kernel's struct names, cons topology, package organization, constructor discipline, internal tags, printer behavior, or receipt representation. A Python implementation need not imitate those structures, and a Common Lisp implementation may choose a different private layout while satisfying the same observable contract.

### 4.3 Preserved boundaries

The closure report explicitly leaves the following outside its proof, and CD/0 does not pretend otherwise:

- `as-of` and other located-claim targeting dimensions;
- ambient-printer-dependent legacy fingerprints;
- arbitrary host Common Lisp closures and procedure rebinding;
- same-image access through `mneme::` and package internals;
- package access as a non-security boundary;
- process-local registries and incomplete concurrency rules;
- residual host aliases such as receipt paths and operator-supplied principals where they remain on the v1 surface;
- incomplete module, authority, and evaluator isolation;
- effect labels without checked effect semantics;
- cryptographic authenticity, custody, and verified multi-hop lineage;
- stable host-independent procedure, module, and claim identity.

CD/0 supplies future layers with immutable structural values and reproducible octets. It does not close those constitutional questions by itself.

---

## 5. Terminology

**Abstract datum**  
A mathematical CD/0 value defined by Section 8, independent of any host object.

**Runtime datum**  
A host implementation's immutable representation of one abstract datum.

**Canonical value encoding**  
The self-delimiting byte encoding of one datum without the document magic or format version. Nested values use this form.

**Canonical document**  
The magic prefix, format version, one canonical value encoding, and end of input.

**Canonical octets**  
The complete canonical document bytes for one abstract datum.

**Exact decoder**  
The normative decoder operation that accepts one complete canonical document and rejects trailing input.

**Importer**  
A separate, explicitly typed adapter from a host value, legacy notation, or profile representation into CD/0. An importer may normalize unambiguous source forms, but it is not the canonical decoder.

**Profile**  
A schema and semantic layer that uses CD/0 records and sequences. Language A, Mneme claim records, artifact manifests, and represented-loss records are profiles, not core datum types.

**Identifier**  
A case-sensitive, non-normalized, segmented symbolic name with explicit namespace and path components.

**Semantic identity**  
Equality of abstract CD/0 values. At interchange boundaries it is witnessed exactly by equality of validated canonical octets.

**Content identity**  
An identifier produced by a separately specified content-hash scheme over a domain-separated preimage. CD/0 does not choose that scheme.

**Privileged value**  
An evaluator-owned value whose possession or construction can confer authority, execution, custody, or access. Privileged values are outside CD/0.

**Canonical input**  
A byte string that is exactly one valid CD/0 canonical document.

**Noncanonical input**  
Bytes that can be understood as denoting a valid abstract value only after a forbidden normalization or repair, such as an overlong integer or an unreduced rational.

**Invalid input**  
Bytes or host input that do not denote a valid abstract datum, such as malformed UTF-8, duplicate record fields, or a cyclic host graph.

**Resource refusal**  
A typed refusal caused by an explicit decode/encode budget or an inability to allocate, rather than by semantic invalidity.

**Represented loss**  
An explicit inert record stating that a migration, translation, compaction, or import could not preserve some source distinction. The schema belongs to a profile; the payload is CD/0.

---

## 6. Separation of the four layers

The following layers are distinct and MUST remain distinct in APIs, specifications, and tests.

| Layer | Normative subject | Authority over identity | What it must not inherit |
|---|---|---|---|
| 1. Abstract datum algebra | Values and equality. | Defines semantic identity. | Common Lisp predicates, Python equality quirks, printer spelling, object topology. |
| 2. Immutable runtime representation contract | Observable behavior of host representations and accessors. | May implement equality, but cannot redefine it. | Mutable aliases, pointer identity, package identity, cached-state drift. |
| 3. Canonical octet encoding | Unique bytes for each abstract value and strict byte decoding. | Sole normative cross-process witness and interchange form. | Host reader/printer formats, locale, implementation float syntax, generic object serialization. |
| 4. Human-readable notation | Diagnostic display and optional source convenience. | No identity authority. | Common Lisp reader semantics, package interning, reader evaluation, hidden normalization. |

Layer 1 is logically prior: it says that two records with the same fields are equal even if their source order differed, and that two differently normalized Unicode strings are distinct. Layer 3 is the operational authority at protocol boundaries: it provides exactly one octet string for each Layer-1 value. The following invariant binds the layers:

```text
abstract equality  <==>  canonical-octet equality
```

A runtime implementation that produces different bytes for equal abstract values is nonconforming. A byte decoder that maps one canonical document to different abstract values in two implementations is nonconforming. A diagnostic renderer that changes spelling without changing the abstract value does not change identity.

No implementation may claim that two values are identical solely because their host objects are `eq`, `eql`, `equal`, `is`, `==`, interned to the same symbol, printed the same, or hashed to the same digest.

---

## 7. Selected normative architecture

### 7.1 Strategy comparison

| Criterion | 1. Deep-copied host trees | 2. Private immutable typed tree | 3. Canonical octets primary, decoded views | 4. Mutually checked immutable values + octets |
|---|---|---|---|---|
| Semantic clarity | Low. Host atoms and predicates remain part of the apparent model. | High if every type is private and specified. | High at the wire; lower for traversal semantics unless views are specified. | Highest: abstract types, views, and bytes are all tied by explicit laws. |
| Mutation resistance | Fragile. A missed mutable leaf recreates aliasing. | Strong with correct constructors and accessors. | Strong for stored bytes; decoded view aliases still require discipline. | Strong; immutable views prevent stale caches and bytes anchor identity. |
| Common Lisp difficulty | Superficially easy, then error-prone around strings, vectors, symbols, and cycles. | Moderate to high; requires private wrappers and defensive access. | Moderate; parsing is straightforward, ergonomic views are more work. | High initially, but explicit and testable. |
| Python difficulty | Superficially easy, but `bool`/`int`, mutable lists/dicts, buffers, and custom equality leak. | Moderate; frozen classes/tuples help. | Moderate; byte slicing and lazy views are natural. | Moderate to high; easiest to make reliable with frozen dataclasses plus immutable bytes. |
| Memory cost | Potentially high due repeated deep copies. | One tree plus overhead. | Lowest when views are lazy; repeated traversal can allocate. | Potentially tree plus bytes; implementations may derive or discard one side. |
| Encoding cost | Repeated traversal and host-type dispatch. | Predictable traversal. | Already encoded when bytes are primary. | One encode can be cached permanently; decode can retain validated source bytes. |
| Traversal ergonomics | Familiar but semantically treacherous. | Good typed access. | Inferior unless a full view layer is built. | Good typed access with reproducible bytes. |
| Canonicality drift | High; host tree distinctions creep into encoders. | Medium; tree and encoder can diverge. | Low for decoded bytes, but constructed values still need a canonical builder. | Lowest when construction, decode, and cache invariants are tested differentially. |
| Cached-byte invalidation | Hard; any shared leaf can invalidate silently. | Avoidable if immutability is complete. | Not applicable for byte-primary values. | Impossible as an observable success if the immutability contract is met; mismatch is an internal invariant failure. |
| Identity-bearing suitability | Poor. | Good, but only with a separately proven encoder. | Excellent for storage and interchange, awkward for evaluator use. | Excellent for both identity and evaluator integration. |
| Hostile-input attack surface | Broad host constructors/readers and recursive copying. | Narrow, provided parsing is dedicated. | Narrow byte parser; lazy views require validation discipline. | Narrow byte parser plus explicit host importer boundary. |
| Host semantic leakage | Severe. | Low. | Low. | Lowest; leakage is caught by byte/equality vectors. |
| Future evaluator integration | Tempting but unsafe because host values masquerade as language values. | Good. | Weak unless views become first-class. | Best: evaluator values can contain immutable datum fields while privileged nominal types remain separate. |

### 7.2 Ruling

Strategy 4 is normative.

A conforming implementation MUST provide:

- an immutable typed representation of every CD/0 value;
- `equal-datum` behavior matching Section 10;
- `canonical-octets` behavior matching Section 15;
- exact decoding into inert runtime datums;
- mutation-resistant accessors;
- a detectable internal-invariant failure if retained canonical bytes and a retained decoded value ever disagree.

An implementation MAY physically store only a typed tree and derive bytes, only validated bytes and derive views, or both. That storage choice is unobservable. Once a typed view or a byte cache is returned as a successful CD/0 value, subsequent operations MUST remain consistent with the original abstract datum.

Decoded values may retain the original validated byte slice. Constructed values may cache their canonical encoding. Such caches require no invalidation because successful runtime datums cannot mutate.

### 7.3 Relation to the current v1 repair

The repaired Common Lisp private datum tree is evidence that defensive freezing can close the documented exported-client aliases. It is a plausible implementation seed for Layer 2. It is not Layer 1 or Layer 3. CD/0 replaces its host-specific cons/string/tag choices with an abstract algebra and exact byte grammar that a Python codec can implement independently.

---

## 8. Abstract datum grammar

### 8.1 Mathematical domains

Let `Scalar` be a Unicode scalar value: an integer code point in `U+0000..U+10FFFF` excluding `U+D800..U+DFFF`.

Let `ScalarString` be a finite sequence of `Scalar`. The empty sequence is permitted.

Let `Segment` be a nonempty `ScalarString`.

Let `Identifier` be an ordered pair:

```text
Identifier(namespace, path)

namespace : finite sequence of Segment; may be empty
path      : nonempty finite sequence of Segment
```

The CD/0 datum domain `D` is the least finite, acyclic set satisfying:

```text
D ::= Unit
    | Boolean(false | true)
    | Integer(z), z in the mathematical integers
    | Rational(p, q), p in integers, q in positive integers,
        p != 0, q > 1, gcd(abs(p), q) = 1
    | String(ScalarString)
    | Bytes(finite sequence of octets)
    | Id(Identifier)
    | Sequence(finite ordered sequence of D)
    | Record(finite mapping from Identifier to D)
```

A record is a mathematical finite mapping. It cannot contain the same identifier key twice. Record field order is not part of the abstract value.

Every datum is finite and acyclic. Runtime sharing is not part of the abstract value. A host graph in which two references point to the same acyclic subvalue denotes the same datum as a host graph containing two equal copies, provided an explicit importer accepts that host graph.

### 8.2 Unit and absence

`Unit` is one ordinary value. It does not intrinsically mean SQL null, JSON null, missing, unknown, false, empty sequence, or end of list. A profile may assign one of those meanings to unit in a particular field, but absence of a record field remains distinct from presence with a unit value.

### 8.3 Rational constructor normalization

The abstract `Rational` variant contains only non-integral reduced rationals. An explicit rational constructor accepting mathematical numerator `n` and denominator `d` behaves as follows:

1. `d = 0` is invalid.
2. If `d < 0`, negate both `n` and `d`.
3. Divide numerator and denominator by `gcd(abs(n), d)`.
4. If the reduced numerator is `0`, produce `Integer(0)`.
5. If the reduced denominator is `1`, produce the corresponding `Integer`.
6. Otherwise produce `Rational(p, q)` with `q > 1`.

This constructor normalization is an abstract-value operation. The canonical decoder does not repair noncanonical rational bytes; it rejects them.

### 8.4 No implicit host mapping

The grammar does not imply that Common Lisp `nil`, a Python `None`, a Common Lisp symbol, a Python `dict`, a pathname, a float, or an arbitrary cons tree is automatically a datum. Host mappings are explicit import operations governed by Sections 17 and 26.

---

## 9. Type inclusion and exclusion table

The ruling column uses these categories: **included in /0**, **represented through a more primitive canonical form**, **excluded from /0 but plausible in a future extension**, and **permanently outside canonical inert data**.

| Candidate | Ruling | CD/0 treatment | Principal reason for exclusion or representation |
|---|---|---|---|
| Null | Represented through a more primitive canonical form | A profile may use `Unit` or field absence, but must choose explicitly. | Semantic ambiguity. |
| Unit | Included in /0 | One distinguished `Unit` value. | Needed to express an explicit zero-information value without overloading false or empty sequence. |
| Booleans | Included in /0 | Distinct `false` and `true`. | Stable exact semantics. |
| Arbitrary-precision signed integers | Included in /0 | Mathematical integers with one zero. | Stable exact semantics and broad utility. |
| Rational numbers | Included in /0 | Reduced, positive denominator, non-integral rationals. | Stable exact semantics; normalization is fully decidable. |
| Fixed-scale decimals | Represented through a more primitive canonical form | Profile record containing an explicit decimal-semantics identifier, coefficient integer, scale integer, and any rounding/context metadata. | Profile specificity and deferred design. |
| IEEE floating-point values | Represented through a more primitive canonical form | Profile record containing an explicit format identifier and exact bit-pattern bytes. | Cross-implementation arithmetic differences and unnecessary core complexity. |
| NaN | Represented through a more primitive canonical form | Exact IEEE format plus bit pattern, if a profile needs it. No core numeric equality. | NaN payload and equality ambiguity. |
| Infinities | Represented through a more primitive canonical form | Exact format plus bit pattern, or a profile-defined tagged record. | Profile specificity. |
| Negative zero | Represented through a more primitive canonical form | Exact format plus bit pattern, or an explicit sign field in a profile record. Core integer zero has no sign. | Numeric-domain ambiguity. |
| Unicode strings | Included in /0 | Finite Unicode scalar sequences. | Stable once normalization is explicitly forbidden. |
| Individual characters | Represented through a more primitive canonical form | A string containing exactly one Unicode scalar. Profiles may enforce length one. | Unnecessary duplicate type. |
| Raw byte strings | Included in /0 | Finite octet sequences. | Necessary for hashes, code blobs, manifests, and exact external encodings. |
| Identifiers | Included in /0 | Explicit namespace segments plus nonempty path segments. | Necessary to avoid host-symbol and package leakage. |
| Module-qualified identifiers | Represented through a more primitive canonical form | A profile record combining a module identity datum and a local `Identifier`. | Module identity belongs to a later layer. |
| Ordered sequences | Included in /0 | Finite ordered values. | Fundamental structural form. |
| Vectors versus lists | Represented through a more primitive canonical form | Both map to `Sequence` when only ordered value semantics matter. A profile tag is required if the distinction is semantic. | Host representation is not semantic. |
| Records | Included in /0 | Finite identifier-keyed mappings. | Needed for profile-neutral structured data. |
| General maps | Excluded from /0 but plausible in a future extension | Use records when keys are identifiers; otherwise use a profile-defined sequence of entries with explicit key policy. | Comparator complexity, attack surface, and deferred design. |
| Tagged unions | Represented through a more primitive canonical form | Record with an explicit profile/schema identifier and discriminant field. | Profile specificity; no need for a separate core variant type. |
| Sets | Excluded from /0 but plausible in a future extension | Profile-defined canonical sequence with explicit uniqueness and ordering rules. | Comparator complexity and deferred design. |
| Timestamps | Represented through a more primitive canonical form | Profile record declaring time scale, epoch/calendar, precision, and integer/rational coordinate. | Semantic ambiguity and profile specificity. |
| Time intervals | Represented through a more primitive canonical form | Profile record declaring endpoint semantics, inclusivity, open bounds, and time model. | Semantic ambiguity and profile specificity. |
| UUID-like identifiers | Represented through a more primitive canonical form | Profile record containing a UUID scheme identifier and 16-byte payload, or an identifier where appropriate. | Profile specificity. |
| URIs | Represented through a more primitive canonical form | Profile-tagged string. CD/0 performs no URI parsing or normalization. | URI equivalence is scheme-dependent. |
| Improper lists | Permanently outside canonical inert data as implicit cons topology | Reject as host input. A profile may explicitly record `head` and `tail` fields if that topology is meaningful. | Host-specific representation and semantic ambiguity. |
| Cyclic structures | Permanently outside the CD/0 algebra | Reject. Cyclic graph information must be reified as explicit node/edge records. | Resource risk and graph-identity ambiguity. |
| Shared substructure | Represented through value repetition | Sharing is unobservable; equal repeated values are encoded repeatedly. | Host object identity is not semantic. |
| Graph identity | Represented through a more primitive canonical form | Explicit graph schema with node identifiers and edge records. | Host pointer identity is unstable. |
| Host symbols | Represented through a more primitive canonical form | Explicit importer to `Identifier` with namespace mapping. | Cross-implementation and package instability. |
| Common Lisp keywords | Represented through a more primitive canonical form | Explicit identifier namespace selected by the importing profile. | Common Lisp package identity is not language law. |
| Pathnames | Permanently outside as host pathname objects; represented as data when needed | Use a profile record with URI/string/byte fields and declared path semantics. | Host behavior, mutability, and privileged I/O association. |
| Opaque extension values | Excluded from /0 but subject to a future version decision | /0 has no generic opaque datum. Whole unsupported documents may be preserved outside the datum API. | Extension confusion and deferred design. |
| Closures and procedure objects | Permanently outside canonical inert data | Use an inert procedure-reference record; live closure remains evaluator-owned. | Privileged behavior and host identity. |
| Capabilities and authority grants | Permanently outside canonical inert data | Descriptive records remain inert; live capability is nominal and evaluator-owned. | Privileged behavior. |
| Live warrants and authenticated claims | Permanently outside canonical inert data | Inert testimony/claim records are data; authenticated runtime values are not. | Privileged behavior and authenticity. |
| Active receipts, file handles, sockets, continuations, restarts | Permanently outside canonical inert data | Descriptive data only. | Privileged behavior, process locality, and mutable external state. |

The table favors a small core. Exclusion does not imply that the information is forbidden; it means the information must be made explicit through stable primitive values and a profile schema rather than inherited from a host object.

---

## 10. Equality and normalization laws

### 10.1 Type disjointness

The nine value families are pairwise disjoint. In particular:

- `false` and `true` are not integers;
- `Unit` is not false, zero, an empty sequence, or an empty record;
- an identifier is not a string;
- bytes are not strings;
- a sequence is not a record;
- an integer is not a rational variant, although a rational constructor may normalize an integral input to an integer.

A Python implementation MUST distinguish `bool` from `int` when importing host values. A Common Lisp importer MUST NOT infer from `nil` alone whether the source intended false, unit, an empty sequence, or absence; the expected source type or profile schema must decide.

### 10.2 Recursive equality

`equal-datum` is defined as follows:

- all `Unit` values are equal;
- booleans are equal exactly when their truth values match;
- integers are equal exactly when they are the same mathematical integer;
- rationals are equal exactly when their normalized numerators and denominators match;
- strings are equal exactly when their Unicode scalar sequences match element for element;
- byte strings are equal exactly when their octets match element for element;
- identifiers are equal exactly when namespace segment sequences and path segment sequences match, including case and every scalar;
- sequences are equal exactly when lengths match and corresponding elements are equal in order;
- records are equal exactly when they have the same identifier key set and equal values for every key.

Record source order never affects equality. Sequence order always affects equality.

### 10.3 Required numeric examples

| Source notion | CD/0 abstract result | Equal to `Integer(1)`? |
|---|---|---|
| Integer `1` | `Integer(1)` | Yes. |
| Rational input `1/1` through the rational constructor | Normalizes to `Integer(1)` | Yes. |
| Rational input `2/2` through the rational constructor | Normalizes to `Integer(1)` | Yes. |
| Binary float `1.0` represented as an IEEE profile record | A record, not a core number | No. |
| Decimal `1.0` represented as a decimal profile record | A record, not a core number | No. |

A valid abstract `Rational` can never have denominator `1`, numerator `0`, a common factor, or a negative denominator.

### 10.4 Unicode non-normalization

CD/0 performs no Unicode normalization. Two canonically equivalent Unicode strings, such as the single scalar `U+00E9` and the two-scalar sequence `U+0065 U+0301`, are distinct strings and therefore distinct datums. The same rule applies to identifier segments and testimony strings.

A profile may separately assert a normalized-name policy, but it must do so before constructing its identity-bearing CD/0 value and must retain represented loss when normalization discards a source distinction. The core codec never normalizes silently.

### 10.5 Sharing and topology

Graph sharing is not observable. A host input containing two references to one immutable leaf and a host input containing two equal leaf copies may import to the same sequence or record. Cycles do not denote CD/0 datums and are rejected.

### 10.6 Diagnostic and host spelling

Diagnostic spelling, whitespace, escape choice, host symbol print names, package prefixes, printer base, printer case, locale, and sorting-library stability do not affect equality.

An explicit importer MAY accept a noncanonical but unambiguous host form and construct its normalized abstract value. Examples include a rational pair `2,4` normalized to `1/2`, or a host list copied into a sequence after cycle detection. The canonical byte decoder MUST NOT perform such repair. It accepts canonical encodings only.

### 10.7 Equality/encoding correspondence

For every pair of valid CD/0 datums `x` and `y`:

```text
equal-datum(x, y)
    iff
canonical-octets(x) byte-for-byte equals canonical-octets(y)
```

This is not merely a desired hash property; it is a conformance law. Digest equality is never a substitute because digests can collide.

---

## 11. Identifier and namespace model

### 11.1 Identifier structure

An identifier is:

```text
Id(namespace = [segment ...], path = [segment, ...])
```

The namespace may be empty. The path must contain at least one segment. Every segment is a nonempty Unicode scalar string.

Examples at the abstract layer:

```text
Id([], ["status"])
Id(["mneme", "claim"], ["as-of"])
Id(["org", "example", "module"], ["exports", "predict"])
```

These examples are names, not automatically module IDs or procedure IDs.

### 11.2 Exact spelling rules

Identifier comparison is case-sensitive and scalar-exact. Namespace and path components are not case-folded, locale-folded, NFC-normalized, NFKC-normalized, width-normalized, punctuation-normalized, or confusable-folded.

Thus all of the following are potentially distinct:

- `Id([], ["A"])` and `Id([], ["a"])`;
- `Id([], ["é"])` and `Id([], ["e\u0301"])`;
- `Id([], ["a", "b"])` and `Id([], ["ab"])`;
- identifiers with the same path but different namespaces;
- identifiers whose glyphs look alike but use different scripts or code points.

CD/0 permits any Unicode scalar in an identifier segment, including NUL and control scalars. A language or security profile SHOULD impose a narrower lexical policy for identifiers intended for human entry. Such a profile may warn about confusables, but it MUST NOT silently merge them after an identity has been established.

### 11.3 Names versus identities

CD/0 separates several notions that host symbol systems often conflate:

- A **human-readable name** is usually a string or identifier and may be an alias.
- A **lexical binding name** is an identifier used by a source-language profile.
- A **stable binding identity** requires a module identity plus a binder/export identity defined by the module layer.
- A **module identity** is a later-layer record or content reference, not merely a module name.
- A **procedure identity** is a later-layer record that may include module identity, export identifier, code/content identity, semantics version, and ABI/profile information.
- A **content identity** is produced by a separately specified domain-separated hash scheme.

A bare `Identifier` never proves that a module, procedure, principal, or policy exists. It carries no authority.

### 11.4 Renaming

Changing any segment of an identifier changes that CD/0 datum. Whether a higher-level entity retains identity across a rename is a policy of that entity's identity scheme:

- changing only an explicitly non-identity presentation-label field may leave a higher-level ID projection unchanged;
- changing a field included in a module, procedure, claim, or artifact identity projection changes that identity;
- source-level alpha-renaming may preserve program semantics, but a stable lexical binding identity must then be represented independently of the presentation spelling;
- an alias relation must be explicit data and cannot make two identifiers equal in CD/0.

### 11.5 Schema field names and profile tags

Record field keys use the same `Identifier` type. Profile tags, schema IDs, semantic labels, event-kind names, and exported binding names may also use identifiers. Profiles SHOULD use nonempty namespaces for globally interpreted fields to avoid accidental collision. CD/0 reserves no magic identifier spelling that can activate behavior.

### 11.6 Common Lisp symbol migration

A Common Lisp symbol can be imported only with an explicit mapping that supplies namespace and path segments. Package stripping and downcasing are forbidden for identity-bearing migration because they collapse distinctions.

A migration adapter MUST distinguish package-distinct symbols when the source still contains that information. An uninterned symbol or `gensym` has no stable cross-process identity merely because it has a print name; it requires an explicitly supplied stable identifier or the import fails with `AmbiguousIdentifier`.

Common Lisp keywords may be mapped to a declared profile namespace, but the keyword package is not automatically a Lisp+ namespace. Python enum members and object attribute names receive the same treatment: they are source conveniences, not canonical identifiers until mapped explicitly.

---

## 12. Unicode and string rules

### 12.1 Repertoire

A CD/0 string is a finite sequence of Unicode scalar values. Surrogate code points `U+D800..U+DFFF` are forbidden. Unicode noncharacters, including `U+FDD0..U+FDEF` and code points ending in `FFFE` or `FFFF`, are permitted and preserved. Their use may be discouraged by a profile, but the core does not erase them.

Because CD/0 uses only scalar values and not Unicode character properties, its core equality does not depend on a particular Unicode database version.

### 12.2 UTF-8

Strings and identifier segments use UTF-8 in canonical octets. The encoding MUST be the shortest well-formed UTF-8 encoding of each scalar. The accepted byte shapes are exactly:

```text
00..7f
c2..df 80..bf
e0 a0..bf 80..bf
e1..ec 80..bf 80..bf
ed 80..9f 80..bf
ee..ef 80..bf 80..bf
f0 90..bf 80..bf 80..bf
f1..f3 80..bf 80..bf 80..bf
f4 80..8f 80..bf 80..bf
```

Octets `80..bf` cannot begin a scalar; `c0`, `c1`, and `f5..ff` are invalid leading octets. The syntactically three-byte patterns `ed a0..bf 80..bf` identify surrogate code points and fail as `ForbiddenUnicodeScalar`. Other illegal shapes, overlong encodings, incomplete scalar sequences within a complete declared payload, and values above `U+10FFFF` fail as `InvalidUTF8`. If the document ends before the declared payload length is present, the failure is `TruncatedInput` before UTF-8 validation.

A byte-order mark is not stripped. If `U+FEFF` occurs in the string, it is data.

### 12.3 Normalization and combining sequences

No Unicode normalization is performed at construction, encoding, decoding, equality, identifier comparison, or diagnostic parsing. Combining sequences are preserved exactly. Canonically equivalent strings remain distinct. This rule is deliberate for testimony, names, source text, quoted evidence, and any domain where normalization could erase a meaningful distinction.

### 12.4 Length

The binary encoding records the number of UTF-8 octets, not the number of host code units, scalars, grapheme clusters, glyphs, or display columns. A runtime API that exposes string length as part of the CD/0 abstraction MUST define that length as the number of Unicode scalars. Host-specific code-unit counts may be exposed only under a clearly host-specific name.

### 12.5 NUL and controls

Strings may contain `U+0000` and all other permitted scalar controls. APIs MUST therefore not rely on NUL termination. Diagnostic notation escapes controls as specified in Section 16.

### 12.6 Host strings

A Python `str` containing an isolated surrogate cannot be imported as a CD/0 string. A Common Lisp string containing a character with no Unicode scalar mapping cannot be imported. These fail before canonical bytes are produced. Mutable host strings must be snapshotted into immutable runtime storage at datum construction.

### 12.7 Identifiers versus testimony strings

Identifiers and ordinary strings share the same scalar-validity and no-normalization rules. Identifiers add nonempty segment structure and exact namespace/path equality. Profiles may impose stricter lexical rules on identifiers without changing testimony strings.

---

## 13. Numeric rules

### 13.1 Integers

CD/0 integers are mathematical signed integers of unbounded theoretical magnitude. Each implementation may impose explicit resource budgets, but no language-level minimum or maximum integer is built into the abstract algebra.

There is one integer zero. Negative zero is not an integer value and has no integer encoding.

### 13.2 Rationals

A valid rational is `p/q` where:

- `p` is nonzero;
- `q` is greater than one;
- `q` is positive;
- `gcd(abs(p), q) = 1`;
- the sign, if any, is carried only by `p`.

Rational equality is exact mathematical equality after constructor normalization. Because valid rationals are already reduced and non-integral, equality reduces to exact numerator and denominator equality.

CD/0 defines no approximate comparison, tolerance, decimal context, rounding mode, unit conversion, or ordering across distinct numeric/profile representations.

### 13.3 Decimal values

Decimals are excluded from the core because “decimal” can mean a fixed-scale quantity, an arbitrary decimal rational, an IEEE decimal format, a money type, or a context-dependent arithmetic value. If only the exact mathematical quantity matters and scale/trailing-zero significance does not, a finite decimal may be converted explicitly to a reduced core rational. A profile that needs fixed scale, lexical precision, or trailing-zero significance SHOULD instead use an ordinary record carrying at least:

- a decimal-semantics or schema identifier;
- an integer coefficient;
- an integer scale or explicit denominator rule;
- any required rounding/context identifier;
- any unit or currency identifier.

The profile defines interpretation. Structurally different decimal records remain different CD/0 values even if a domain-specific arithmetic layer considers their numerical quantities equal.

### 13.4 IEEE floating-point values

Native floating-point values are excluded from /0. A profile that needs to preserve an IEEE value exactly MUST represent:

- the precise format identifier, such as binary32 or binary64; and
- the exact bit pattern as a byte string with profile-specified byte order.

That representation preserves normal values, subnormals, infinities, positive and negative zero, quiet/signaling NaN encodings, and NaN payloads without invoking host printing or host arithmetic. The resulting record is not a core number; CD/0 equality is structural.

A profile that needs a measured or approximate quantity SHOULD additionally record unit, uncertainty/error model, rounding method, and producing procedure or observation context. Merely wrapping a host float in a record does not create implementation-independent measurement semantics.

### 13.5 Consequences

- `Integer(1)` is distinct from any decimal or IEEE record spelling `1.0`.
- Different NaN payload records are distinct if their bit-pattern bytes differ.
- Positive and negative IEEE zero records are distinct if their bits differ.
- No codec may call a host float printer to establish CD/0 identity.
- A legacy float can migrate exactly only when its format and exact bits are known; otherwise the migration must reject or record represented loss.

---

## 14. Sequence, record, and map rules

### 14.1 Sequences

A sequence is finite and ordered. Its length and every element participate in equality. Empty sequence, empty record, empty string, empty bytes, false, zero, and unit are all distinct.

CD/0 does not preserve whether a source sequence was a Common Lisp list, Common Lisp vector, Python tuple, Python list, or another host collection. A profile that assigns semantics to that distinction must encode an explicit record tag.

### 14.2 Records

A record is a finite mapping from `Identifier` keys to CD/0 values.

- Duplicate keys are invalid, not “last one wins.”
- Source field order is not part of the abstract value.
- Canonical bytes order fields as specified below.
- A record carries no implicit schema, class, constructor, prototype, or package.
- Profile interpretation requires explicit schema/profile identifiers in the data or in a separately bound protocol context.

If source field order is provenance that must survive, it must be represented explicitly as a sequence field. The record's serialization order cannot be used as provenance.

### 14.3 Canonical field ordering

Let `ValueBytes(k)` be the canonical value encoding of identifier key `k`, including the identifier type tag but excluding the document magic and version. Record fields are ordered by unsigned lexicographic comparison of `ValueBytes(k)`:

1. compare the first differing octet numerically from `0` to `255`;
2. if one byte sequence is an exact prefix of the other, the shorter sorts first;
3. byte-for-byte equality means the same key and is a duplicate.

No locale, Unicode collation, case folding, decoded numeric comparison, map iteration order, or sorting stability participates. An encoder sorts by this rule. A decoder verifies strict increase and rejects input that is equal or decreasing; it does not silently sort.

### 14.4 Maps and sets

General maps and sets are not /0 types. Arbitrary datum keys would require a broader comparator policy, introduce sorting and denial-of-service complexity, and invite semantic confusion over numeric and profile values.

A profile can represent a map as a sequence of entry records and define its own key uniqueness/order. A profile can represent a set as a sequence with an explicit canonical element-order rule. Those profile rules do not alter core equality unless and until the profile constructs a particular canonical sequence.

### 14.5 Tagged variants

A tagged union is represented as a record containing explicit profile/schema and variant identifiers. No field spelling is magical to CD/0. A record shaped like a variant that a consumer does not recognize remains inert data.

---

## 15. Canonical octet grammar

### 15.1 Overview

A canonical document is binary:

```text
Document = Magic Version Value EndOfInput
Magic    = 4C 50 43 44              ; ASCII "LPCD"
Version  = UVAR(0)                   ; exactly 00 for /0
```

All multibyte structures below are concatenations in the order shown. There is no checksum, compression, alignment padding, host byte order, or hidden metadata.

### 15.2 Unsigned variable integer: `UVAR`

`UVAR(n)` is minimal unsigned LEB128 for a nonnegative mathematical integer `n`:

- each octet contributes seven payload bits, least-significant group first;
- bit 7 is `1` on every non-final octet and `0` on the final octet;
- `n` is the sum of each seven-bit payload shifted by `7 * index`;
- zero encodes as the single octet `00`;
- an encoding longer than one octet is minimal only if the final seven-bit payload is nonzero.

Examples:

```text
0       -> 00
1       -> 01
127     -> 7f
128     -> 80 01
16383   -> ff 7f
16384   -> 80 80 01
```

`80 00`, `81 00`, and any other redundant high zero group are noncanonical. The abstract format has no fixed UVAR width; resource budgets bound parsing in a deployment.

### 15.3 Type-tag allocation

| Tag | Value form | Payload |
|---:|---|---|
| `00` | Unit | none |
| `01` | Boolean false | none |
| `02` | Boolean true | none |
| `10` | Integer | zigzag integer UVAR |
| `11` | Rational | zigzag numerator UVAR, then denominator UVAR |
| `20` | String | UTF-8 octet length UVAR, then bytes |
| `21` | Byte string | octet length UVAR, then bytes |
| `22` | Identifier | namespace count and segments, path count and segments |
| `30` | Sequence | element count UVAR, then values |
| `31` | Record | field count UVAR, then identifier/value pairs |
| `03..0f`, `12..1f`, `23..2f`, `32..ef` | Reserved in /0 | no /0 meaning; reject |
| `f0..ff` | Permanently forbidden privileged-value tag range | reject as attempted privileged restoration |

Reserved tags acquire no meaning within format version 0. A future value form requires a new top-level format version. Tags `f0..ff` are reserved permanently so that no canonical datum version can assign direct wire tags to live capabilities, warrants, active receipts, closures, or similar privileged values.

### 15.4 Zigzag signed integers

For mathematical integer `z`, define:

```text
zigzag(z) = 2*z          when z >= 0
             -2*z - 1    when z < 0
```

The inverse is unique:

```text
unzigzag(u) = u / 2              when u is even
               -(u + 1) / 2      when u is odd
```

An integer value encoding is:

```text
10 UVAR(zigzag(z))
```

Examples:

```text
0   -> 10 00
-1  -> 10 01
1   -> 10 02
-2  -> 10 03
64  -> 10 80 01
```

There is no sign octet and no negative-zero spelling.

### 15.5 Rational encoding

A rational value encoding is:

```text
11 UVAR(zigzag(p)) UVAR(q)
```

The decoder requires `p != 0`, `q > 1`, and `gcd(abs(p), q) = 1`. Consequently:

- denominator zero is invalid;
- denominator one is a noncanonical encoding of an integer;
- numerator zero is a noncanonical encoding of integer zero;
- an unreduced pair is noncanonical;
- a negative denominator has no byte representation because `q` is unsigned.

The rational `-1/2` encodes as `11 01 02`.

### 15.6 String encoding

```text
20 UVAR(byte_count) utf8_octets[byte_count]
```

The byte count is the exact UTF-8 payload length. The payload must decode to Unicode scalar values under Section 12 and must use shortest-form UTF-8.

### 15.7 Byte-string encoding

```text
21 UVAR(byte_count) octets[byte_count]
```

Every octet value is permitted.

### 15.8 Identifier encoding

```text
22
UVAR(namespace_segment_count)
Segment * namespace_segment_count
UVAR(path_segment_count)
Segment * path_segment_count

Segment = UVAR(utf8_byte_count) utf8_octets[utf8_byte_count]
```

Every segment byte count must be greater than zero. The path segment count must be greater than zero. Segment text follows the same strict UTF-8 and scalar rules as strings. Segment payloads omit the string type tag because their position fixes the type.

### 15.9 Sequence encoding

```text
30 UVAR(element_count) Value * element_count
```

Each nested `Value` is self-delimiting. The element count appears before contents.

### 15.10 Record encoding

```text
31 UVAR(field_count) Field * field_count
Field = IdentifierValue Value
```

`IdentifierValue` is a complete nested identifier value encoding beginning with tag `22`. Keys must be strictly increasing under Section 14.3. The decoder checks a key's ordering immediately after parsing that key and before decoding its associated value.

### 15.11 End of input and concatenation

The exact decoder succeeds only if the root value ends exactly at end of input. Any additional octet produces `TrailingBytes`, even if the suffix is another valid canonical document.

Nested values and the root value are self-delimiting. A separate streaming operation MAY expose `decode-one(input, offset, budget) -> (datum, next-offset)`, and a transport MAY define a sequence of complete documents. That operation is not `decode-exact`; concatenated documents never constitute one CD/0 document.

### 15.12 Canonical-only decoding

The normative byte decoder accepts only canonical encodings. A broader migration parser or diagnostic parser is a separate API. A decoder MUST NOT accept an overlong UVAR, reduce an encoded rational, reorder record fields, discard duplicate fields, normalize Unicode, or ignore trailing bytes and then return a successful datum.

### 15.13 Unknown versions and tags

A /0-only decoder seeing a minimally encoded nonzero format version returns `UnsupportedFutureVersion` without interpreting the value payload. A decoder supporting later registered versions distinguishes unsupported future versions from gaps or unknown assigned versions as specified in Section 20.

Within version 0, reserved tags are invalid. They are not opaque values and cannot be assigned implementation-local meanings. This prevents two implementations from assigning different values to identical /0 bytes.

### 15.14 Streaming and theoretical size

The grammar is stream-decodable because all variable payloads have counts or lengths and all nested values are self-delimiting. Exact success still requires end-of-input confirmation.

The abstract maximum datum size is unbounded but finite: every individual datum, count, string, byte string, and integer is finite, while no universal finite upper bound is part of the algebra. Every practical decoder uses explicit budgets under Section 21.

### 15.15 Worked canonical documents

Spaces below are visual only. Hexadecimal is lowercase. Each row includes the complete `LPCD 00` document prefix.

| Abstract datum | Canonical hexadecimal |
|---|---|
| Unit | `4c5043440000` |
| false | `4c5043440001` |
| true | `4c5043440002` |
| integer `0` | `4c504344001000` |
| integer `-1` | `4c504344001001` |
| integer `1` | `4c504344001002` |
| integer `64` | `4c50434400108001` |
| rational `-1/2` | `4c50434400110102` |
| string `"A"` | `4c50434400200141` |
| string containing `U+00E9` | `4c504344002002c3a9` |
| string containing `U+0065 U+0301` | `4c50434400200365cc81` |
| bytes `00 ff` | `4c50434400210200ff` |
| `Id(["mneme"], ["claim", "as-of"])` | `4c504344002201056d6e656d650205636c61696d0561732d6f66` |
| sequence `[Unit, true, 1]` | `4c50434400300300021002` |
| record `{Id([], ["a"]): 1, Id([], ["b"]): true}` | `4c50434400310222000101611002220001016202` |
| empty sequence | `4c504344003000` |
| empty record | `4c504344003100` |

The two visually related `é` examples have different scalar sequences and different canonical octets, as required.

---
## 16. Human-readable notation

### 16.1 Status

CD/0 defines a preferred diagnostic notation for logs, review, test reports, and hand-authored examples. The notation is **not** the semantic identity representation and is not a substitute for canonical octets.

Every valid abstract datum has one preferred diagnostic rendering. An implementation may offer an optional parser, but parser acceptance does not make the source text canonical bytes. A protocol requiring identity MUST encode the resulting datum and use Section 15.

### 16.2 Preferred forms

```text
Unit                         unit
Boolean                      false | true
Integer                      0 | -1 | 27 | ...
Rational                     rat(-1,2)
String                       "ASCII and escapes"
Bytes                        hex"00ff"
Identifier                   id(ns=["mneme"],path=["claim","as-of"])
Sequence                     [unit,true,1]
Record                       record{id(ns=[],path=["a"])=>1,id(ns=[],path=["b"])=>true}
```

The preferred rendering is one line with no insignificant whitespace. The preferred renderer uses these exact rules:

- integers are base-ten with no leading `+`, no leading zero except `0`, and no negative zero;
- rationals use normalized numerator and denominator, no spaces inside `rat(`, and a comma separator;
- byte strings use lowercase hexadecimal, two digits per octet, and no internal whitespace;
- record fields use canonical key order;
- commas have no following space in the preferred spelling;
- identifier namespace and path are explicit; an identifier is never printed as a bare symbol.

### 16.3 String escapes

The preferred diagnostic string is ASCII-only:

- ASCII scalars `U+0020..U+007E` are emitted literally except `"` and `\`;
- quote and backslash are `\"` and `\\`;
- line feed, carriage return, and tab are `\n`, `\r`, and `\t`;
- every other scalar is `\u{h}`, where `h` is lowercase hexadecimal with no leading zero unless the scalar is zero.

Thus precomposed and decomposed Unicode remain visibly distinguishable:

```text
"\u{e9}"
"e\u{301}"
```

Diagnostic escaping does not alter the scalar sequence.

### 16.4 Parsing

A preferred-notation parser is OPTIONAL. If present:

- it MUST have no reader-evaluation, package-interning, object-construction, import, or code-execution side effects;
- it MUST return only inert runtime datums;
- it MUST reject values outside the abstract grammar;
- any acceptance of extra whitespace, uppercase hex, alternate escapes, or other non-preferred spelling MUST be documented as a noncanonical source-input convenience;
- a strict “preferred spelling” check MUST compare the parser's preferred re-rendering with the complete supplied text.

The diagnostic parser is not the canonical byte decoder and may not be used as an identity oracle.

### 16.5 Invalid and privileged-looking shapes

A valid record that resembles a capability, warrant, certificate, or receipt is rendered as an ordinary `record{...}`. No diagnostic syntax marks it as live or authenticated.

Invalid input has no datum rendering. Error reporters may use a notation such as `!invalid(code=...,offset=...)`, but any spelling beginning `!invalid` is outside the datum grammar and MUST NOT parse as a value.

---

## 17. Encoder requirements

### 17.1 Normative operation

The conformance operation is conceptually:

```text
encode-exact(runtime-datum, budget) -> immutable octet string
                                      | typed failure
```

The successful result is the complete canonical document, including magic and version.

### 17.2 Accepted values

`encode-exact` accepts only a valid immutable CD/0 runtime datum. Conversion from arbitrary host objects is a separate importer. An implementation may expose convenience constructors, but those constructors MUST establish the abstract type explicitly and must not infer ambiguous meanings from host values.

Examples of required distinctions include:

- Python `True` imported as a boolean is not integer `1`;
- Common Lisp `nil` requires an expected source type;
- a Common Lisp symbol requires explicit identifier mapping;
- a Python dictionary is not automatically a record unless a record importer validates identifier keys and duplicates;
- a host float is unsupported by the core encoder;
- a live capability or receipt is not encodable merely because it exposes data-like fields.

### 17.3 Determinism and ambient state

For a fixed abstract datum and sufficient budget, encoder output MUST be byte-for-byte invariant under changes to:

- Common Lisp `*package*`, printer base, printer case, print circle, print level, print length, readtable, locale, and implementation;
- Python locale, hash randomization, dictionary insertion order, object `repr`, and interpreter process;
- host memory addresses, object identities, thread scheduling, and cache state.

The encoder MUST implement Section 15 directly or through behavior proven equivalent. Host printer output cannot appear in canonical bytes except when it was already explicit CD/0 string data.

### 17.4 Record handling

A record constructor MUST reject duplicate keys. The encoder MUST emit fields in Section 14.3 order regardless of source or runtime iteration order. Sorting compares canonical identifier value bytes, not host strings or symbols.

An encoder accepting a hostile host field sequence through an importer MUST apply field-count and key-byte work budgets before unbounded sorting. A normal runtime record is already a valid finite mapping.

### 17.5 Host graph import

An importer that accepts recursive host collections MUST detect cycles by active traversal ancestry. A cycle fails with `CyclicHostInput`. Repeated references to an already completed acyclic subvalue are permitted and denote repeated value occurrences; sharing is not encoded.

Improper Common Lisp lists fail unless an explicit profile importer maps their topology to a record. Mutable host strings, byte arrays, lists, and dictionaries must be snapshotted before a successful runtime datum is returned.

### 17.6 Normalization boundary

Typed constructors may normalize unambiguous mathematical inputs as specified in Section 8.3. Once a runtime datum exists, `encode-exact` MUST NOT change its abstract value, infer a schema, normalize Unicode, case-fold identifiers, convert decimal/float objects, or discard fields.

### 17.7 Output atomicity

The core `encode-exact` operation returns either one complete immutable octet string or a typed failure. If the canonical result would exceed `max_output_octets`, it returns `ExcessiveOutputLength`. On semantic, host-input, resource, or invariant failure it MUST NOT return a prefix as a successful result. Temporary internal allocations may become unreachable.

A separate streaming writer MAY expose partial sink writes caused by transport failure, but it is outside the atomic conformance operation and must label that behavior explicitly. It cannot redefine the canonical bytes.

### 17.8 Cached bytes

An implementation MAY cache canonical octets. A cache hit MUST return bytes equal to a fresh canonical encoding. If an implementation detects a mismatch between cached octets and the runtime value, it MUST signal `CachedOctetsMismatch` or another `InternalInvariantFailure`; it MUST NOT choose one silently.

### 17.9 Unsupported and privileged host values

Unsupported ordinary host input fails with `UnsupportedHostType` or a more specific host-input failure. An evaluator-owned privileged value passed directly to the core encoder fails with `PrivilegedHostValue`. A caller may separately project approved inert fields into a record, but that projection is a privileged-layer operation and does not serialize the live value itself.

---

## 18. Decoder requirements

### 18.1 Normative operation

The conformance operation is conceptually:

```text
decode-exact(immutable-octet-snapshot, budget) -> immutable runtime datum
                                                  | typed failure
```

A mutable input buffer must be snapshotted or held through an API that guarantees it cannot change during and after successful decoding. Later mutation of the caller's original buffer MUST NOT alter the returned datum or its canonical octets.

### 18.2 Required parse sequence

Subject to the failure precedence in Section 20.5, `decode-exact` performs:

```text
1. Enforce the input-octet budget.
2. Match magic 4c 50 43 44.
3. Read one minimal version UVAR.
4. Require supported format version 0.
5. Parse one Value at root depth 1.
6. Validate every local canonicality and resource condition while parsing.
7. Require the parse position to equal input length.
8. Return an immutable inert runtime datum.
```

The decoder MUST consume and validate the complete document before reporting success.

### 18.3 Dedicated parser

Successful decoding MUST have no observable reader evaluation, generic object deserialization, package resolution, host symbol interning, class lookup, constructor dispatch, module loading, file access, network access, evaluator transition, or registry mutation.

In particular, the exact decoder cannot be implemented by passing bytes to the Common Lisp reader, Python `eval`, `pickle`, a generic serializer with object hooks, or any mechanism whose accepted grammar can instantiate arbitrary host objects.

### 18.4 Strict canonicality

The decoder rejects rather than repairs:

- nonminimal version, integer, rational-component, length, count, or segment UVARs;
- rational zero, integral rational spellings, or unreduced rationals;
- out-of-order record fields;
- duplicate record fields;
- alternate Unicode normalization;
- trailing bytes.

A successful `decode-exact` therefore guarantees that re-encoding produces the exact original bytes.

### 18.5 Unknown and forbidden tags

A tag reserved in version 0 fails; the decoder does not return an opaque datum. Tags `f0..ff` fail as `ForbiddenPrivilegedTag`. A record shape never triggers that failure, because records remain inert regardless of their labels.

### 18.6 Lazy materialization

An implementation MAY lazily materialize strings, sequence elements, or record values after it has validated the entire canonical document, all nesting, all UTF-8, all field order, and all resource constraints. Lazy implementation MUST NOT defer a canonicality or resource failure until an accessor is called after successful decode.

The returned value's behavior, equality, canonical bytes, and failures must be indistinguishable from eager decoding.

### 18.7 Exact versus streaming decode

`decode-one` and streaming-document iterators are optional separate operations. They may return the position after one self-delimiting document. `decode-exact` always rejects any suffix. A caller must choose the operation explicitly; no heuristic treats a suffix as harmless.

### 18.8 Inert result

The only successful result is a runtime datum in the nine-family algebra. Profile validation, signature verification, warrant recognition, receipt revival, and authority transitions occur in separate APIs. A profile validator may return a typed validated profile value, but the core decoder itself never does.

---

## 19. Immutability contract

### 19.1 Core guarantee

A successfully constructed or decoded runtime datum is immutable for its entire observable lifetime. No operation on the datum, its accessors, its source objects, or its cached bytes may change the abstract value.

### 19.2 Mutable leaves and buffers

Decoded or constructed strings and byte strings MUST NOT retain caller-mutable storage in a way that can alter the datum. This includes:

- mutable Common Lisp strings, adjustable arrays, displaced arrays, and vectors with fill pointers;
- Python `bytearray`, writable `memoryview`, mutable extension buffers, and lists of integers;
- memory-mapped or foreign buffers whose contents can change.

An implementation may copy, freeze into private storage, or retain storage protected by a real immutability guarantee. Merely promising not to mutate a publicly mutable object is insufficient.

### 19.3 Accessors

Accessors MUST return:

- immutable scalar values;
- immutable datum references;
- immutable sequence/record views; or
- defensive copies that cannot mutate internal storage.

No accessor may expose an internal mutable array, hash table, cons spine, string, or byte buffer whose mutation changes the datum. An operation explicitly named as conversion to a mutable host value may return a deep mutable copy; subsequent changes to that copy remain external.

### 19.4 Persistent update

An operation that conceptually changes a sequence element, record field, string, bytes value, identifier segment, or number produces a new datum. It never changes the old one. Host attempts to mutate a read-only view may signal a host mutation error or may operate on an external copy, but cannot change the datum.

### 19.5 Structural sharing and hash-consing

Internal structural sharing, hash-consing, interning of immutable datum nodes, lazy views, and memoization are allowed. They are unobservable:

- pointer identity is not datum equality;
- two equal datums need not share storage;
- two unequal datums must not become equal through interning;
- a cache or memo table cannot confer authority;
- garbage collection or cache eviction cannot change bytes or equality.

### 19.6 Canonical-byte caches

Cached canonical octets are immutable snapshots. Returning canonical octets must not expose a writable cache. Because datums cannot mutate, caches require no invalidation. Any detected disagreement is an internal invariant failure, never a reason to refresh identity silently.

This rule directly prevents a value from changing after a fingerprint or canonical encoding has been cached.

### 19.7 Concurrency

Concurrent reads, equality checks, and canonical encodings of one successful runtime datum MUST observe the same abstract value. Implementations may compute the same cache more than once or install it atomically; race timing cannot affect the result.

### 19.8 Lazy decode failure timing

All grammar, canonicality, Unicode, version, and declared-resource checks occur before decode success. A lazy accessor may still encounter an external host failure such as allocation refusal while creating a requested host copy, but it cannot reveal that the original canonical document was invalid after the decoder already succeeded.

---

## 20. Typed failure vocabulary

### 20.1 Failure record

Every conformance failure has at least:

```text
category : one of the seven categories below
code     : stable symbolic code
stage    : stable parse/encode stage
```

When available it also carries an octet `offset`, a structural `path`, a non-sensitive detail value, and the active resource-budget identifier. Details must not expose privileged host objects or mutable internal storage.

Implementations may use host exceptions or condition classes, but the shared tests compare the normative category, code, and stage.

### 20.2 Categories

| Category | Meaning |
|---|---|
| `InvalidCanonicalGrammar` | Input does not describe one valid CD/0 abstract datum/document. |
| `NoncanonicalEncoding` | Input describes a value only after a forbidden canonical repair. |
| `UnsupportedFormat` | The document belongs to a future, unknown, or unsupported format/extension. |
| `ResourceRefusal` | An explicit budget or allocation limit prevents safe processing. |
| `UnsupportedHostInput` | An encoder/importer received a host value outside its declared mapping. |
| `PrivilegedRestorationAttempt` | Input requests or uses a representation reserved for live privileged values. The category describes the prohibited representation class, not the sender's subjective intent. |
| `InternalInvariantFailure` | The implementation's own retained representations disagree or an impossible internal state is detected. |

### 20.3 Normative failure codes

| Code | Category | Required condition or use |
|---|---|---|
| `InvalidMagic` | Invalid canonical grammar | Prefix is not exactly `4c504344`. |
| `InvalidTypeTag` | Invalid canonical grammar | A value tag has no valid role in the selected version; `ReservedTypeTag` is the /0 specialization. |
| `ReservedTypeTag` | Invalid canonical grammar | A /0 tag in `03..0f`, `12..1f`, `23..2f`, or `32..ef`. |
| `TruncatedInput` | Invalid canonical grammar | Required prefix, UVAR terminator, payload octet, or nested value is missing at end of input, subject to resource precedence. |
| `TrailingBytes` | Invalid canonical grammar | A complete root value is followed by any octet. |
| `InvalidUTF8` | Invalid canonical grammar | Illegal byte shape, overlong scalar encoding, truncation within a declared payload, or value above `U+10FFFF`. |
| `ForbiddenUnicodeScalar` | Invalid canonical grammar | A structurally decoded code point is in the surrogate range. |
| `ZeroDenominator` | Invalid canonical grammar | Rational denominator is zero. |
| `EmptyIdentifierSegment` | Invalid canonical grammar | Identifier segment has declared UTF-8 byte length zero. |
| `MissingIdentifierPath` | Invalid canonical grammar | Identifier path segment count is zero. |
| `RecordKeyNotIdentifier` | Invalid canonical grammar | A record field key does not begin with identifier tag `22`. |
| `DuplicateRecordField` | Invalid canonical grammar | Current canonical key bytes equal the previous key bytes. |
| `NonminimalVersionEncoding` | Noncanonical encoding | Version UVAR is overlong. |
| `NonminimalIntegerEncoding` | Noncanonical encoding | Integer zigzag UVAR is overlong. |
| `NonminimalRationalComponentEncoding` | Noncanonical encoding | Numerator or denominator UVAR is overlong. |
| `OverlongLengthEncoding` | Noncanonical encoding | String, byte-string, or segment length UVAR is overlong. |
| `OverlongCountEncoding` | Noncanonical encoding | Sequence, record, namespace, or path count UVAR is overlong. |
| `ZeroRationalEncoding` | Noncanonical encoding | Rational numerator is zero and should be integer zero. |
| `IntegralRationalEncoding` | Noncanonical encoding | Rational denominator is one and should be an integer. |
| `UnreducedRational` | Noncanonical encoding | Numerator and denominator share a factor greater than one. |
| `NoncanonicalFieldOrder` | Noncanonical encoding | Current record key bytes are lexicographically less than the previous key. |
| `UnknownVersion` | Unsupported format | A registered-version space contains an unassigned/gap value not meaningfully ordered as a future version. A /0-only implementation normally does not emit this for positive nonzero versions. |
| `UnsupportedFutureVersion` | Unsupported format | The minimally encoded document version is greater than the greatest version implemented; for a /0-only codec, every nonzero version has this result. |
| `UnsupportedExtensionTag` | Unsupported format | Reserved for a future version with a defined extension registry; it is never success under /0. |
| `ExcessiveInputLength` | Resource refusal | Input snapshot exceeds `max_input_octets`. |
| `ExcessiveOutputLength` | Resource refusal | A canonical encoding would exceed `max_output_octets`. |
| `ExcessiveDeclaredLength` | Resource refusal | A minimally encoded payload length exceeds the applicable budget. |
| `ExcessiveContainerCount` | Resource refusal | A sequence or record count exceeds its budget. |
| `ExcessiveIdentifierSegments` | Resource refusal | Namespace/path segment counts exceed their budget. |
| `ExcessiveNesting` | Resource refusal | A value would exceed `max_depth`. |
| `IntegerBudgetExceeded` | Resource refusal | Integer or rational component magnitude exceeds `max_integer_bits`. |
| `VarintBudgetExceeded` | Resource refusal | A UVAR continues beyond `max_varint_octets` before termination. |
| `NodeBudgetExceeded` | Resource refusal | Parsed value-node count would exceed `max_nodes`. |
| `AggregatePayloadBudgetExceeded` | Resource refusal | Aggregate string/byte/segment payload would exceed its budget. |
| `RecordKeyWorkBudgetExceeded` | Resource refusal | Host import/encoding would exceed key-byte or record-sorting work budget. |
| `AllocationRefused` | Resource refusal | The host cannot allocate a permitted representation safely. |
| `UnsupportedHostType` | Unsupported host input | No explicit importer mapping exists for the supplied host value. |
| `CyclicHostInput` | Unsupported host input | Active traversal encounters an ancestor again. |
| `ImproperHostList` | Unsupported host input | A host list has a non-list tail where a sequence importer was requested. |
| `AmbiguousIdentifier` | Unsupported host input | A symbol/name lacks enough namespace/stable-identity information or a mapping is non-injective. |
| `InvalidHostUnicode` | Unsupported host input | A host string/character cannot be represented as Unicode scalar values. |
| `NegativeDenominatorHostRational` | Unsupported host input | A low-level host rational object violates the runtime-datum invariant. A public rational constructor may instead normalize it before datum creation. |
| `ForbiddenPrivilegedTag` | Privileged restoration attempt | A value tag in `f0..ff` occurs. |
| `PrivilegedHostValue` | Privileged restoration attempt | A live evaluator-owned value is passed to the core encoder/importer. |
| `PrivilegedRestorationRequested` | Privileged restoration attempt | A caller invokes a datum API mode that purports to activate a decoded record. No such mode is valid in /0. |
| `EncoderInvariantFailure` | Internal invariant failure | An impossible encoder state or malformed private runtime datum is detected. |
| `DecoderInvariantFailure` | Internal invariant failure | The parser's internal state contradicts already validated input. |
| `CachedOctetsMismatch` | Internal invariant failure | Cached canonical octets and retained typed value encode differently. |

There is no `ForbiddenNegativeZeroEncoding` for the core because the integer grammar has no sign-magnitude zero and native floats/decimals are excluded. A host negative-zero float supplied directly to the core is `UnsupportedHostType`; an IEEE profile adapter preserves its exact bits.

A negative rational denominator also has no canonical-byte spelling because the denominator uses unsigned UVAR. It can occur only at a host constructor/import boundary.

### 20.4 Failure stages

Shared vectors use these stage names:

```text
input-budget
magic
version-varint
version-selection
type-tag
integer-payload
rational-payload
length
count
utf8
identifier
record-key
record-order
container-content
end-of-input
host-import
encode-ordering
allocation
cache-check
internal
```

A structural path is a sequence of selectors such as sequence indexes and record-key identifiers. An octet offset is zero-based from the beginning of the complete document.

### 20.5 Deterministic failure precedence

For tests designed with one primary defect, implementations MUST return the listed failure. For inputs with multiple defects, the first determinable failure follows this precedence:

1. reject `ExcessiveInputLength` before reading input beyond the supplied snapshot;
2. validate magic left to right: an available mismatching octet yields `InvalidMagic`, while end of input after a matching proper prefix yields `TruncatedInput`;
3. read version UVAR, enforcing varint budget, termination, then minimality;
4. select or reject the version before parsing its value;
5. before reading a value tag at depth `d`, enforce depth and node budgets;
6. for each UVAR, enforce varint-octet budget while reading, require termination, check minimality, then apply magnitude/count/length budgets;
7. after a minimally encoded declared length or count exceeds budget, return the resource refusal before allocating or checking whether the full declared payload is present;
8. if the declaration is within budget, missing payload produces `TruncatedInput`;
9. validate local payload and canonical numeric/Unicode constraints before returning the value;
10. traverse sequence elements and record fields left to right;
11. for a record, parse and validate the key, compare it with the previous key, and reject duplicate/order defects before parsing that field's value;
12. after one root value, reject any suffix as `TrailingBytes`.

For rational semantic checks, denominator zero precedes numerator-zero, denominator-one, and reduction checks. Numerator zero precedes denominator one when both apply after a nonzero denominator.

Arbitrary fuzzer inputs may contain many competing defects. A divergence found on such input must be minimized to a single-fault vector before its exact code becomes a permanent cross-implementation requirement.

---

## 21. Resource model

### 21.1 No universal prototype constants

CD/0 does not constitutionalize depth `32`, a `100,000`-character limit, or any other current prototype bound. The algebra permits every finite datum. Deployments decide what they can safely process.

### 21.2 Explicit budget

Every decode and hostile-host import is governed by an immutable resource budget. A convenience API may select a named deployment default, but conformance tests pass the budget explicitly. The resolved budget must cover at least:

```text
max_input_octets
max_output_octets
max_varint_octets
max_integer_bits
max_depth
max_nodes
max_sequence_items
max_record_fields
max_identifier_segments
max_segment_octets
max_single_string_octets
max_single_bytes_octets
max_aggregate_payload_octets
max_total_record_key_octets        ; encoder/importer work
```

Implementations may add time, allocation, or host-specific ceilings. Such additions produce `ResourceRefusal`, not a claim that the bytes are invalid.

### 21.3 Counter definitions

- Root value depth is `1`.
- Every sequence element, record key identifier, and record value is one level deeper than its containing sequence/record.
- Identifier segments are not values and do not increment value depth, but they count against segment and payload budgets.
- Every encoded `Value`, including a record key identifier, counts as one node.
- Aggregate payload counts the declared UTF-8/octet payloads of strings, byte strings, and identifier segments; it does not count container framing.

These definitions make shared resource vectors reproducible.

### 21.4 Pre-allocation checks

After a length/count UVAR has been minimally decoded, the decoder MUST compare it with the relevant budget before allocating storage proportional to that declaration. A malicious declaration of terabytes cannot cause a proportional allocation, loop, or buffer reservation before `ExcessiveDeclaredLength` is returned.

An integer parser MUST track varint octets and effective bit magnitude so it can return `VarintBudgetExceeded` or `IntegerBudgetExceeded` before constructing an unbounded host integer.

### 21.5 Amplification and nesting

Because CD/0 has no compression, reference table, implicit zero fill, or shared-object expansion, declared lengths bound direct payload. Node and depth budgets bound container amplification. Record decoders verify already ordered keys and therefore need no attacker-controlled sort.

Host importers and encoders may need to sort record fields; field-count and total-key-byte budgets bound that work.

### 21.6 Refusal atomicity and state

On a resource refusal, `decode-exact` MUST:

- return no partial datum;
- perform no evaluator transition, symbol interning, registry mutation, file/network action, or profile validation side effect;
- leave caller-visible application state unchanged;
- not retain the input through a newly published partial object.

Temporary internal allocations may have occurred and may later be reclaimed. The finite-octet conformance API does not advance a caller stream because it receives a snapshot.

An optional streaming decoder may advance its transport while discovering a refusal, but it MUST report the consumed position, return no partial datum, and cannot promise rollback unless wrapped in a separately specified transactional buffer.

### 21.7 Allocation refusal

Even input within declared semantic budgets can encounter host allocation failure. The implementation returns `AllocationRefused` rather than a partial datum. It may choose stricter deployment budgets to avoid predictable allocation pressure.

### 21.8 Conformance floor

Language semantics contain no fixed acceptance floor. The shared conformance corpus declares budgets for each vector, and a codec submitted as a conforming CD/0 implementation MUST decode every positive vector under its declared budget. A deployment may advertise smaller operational policies, but it must label them as deployment constraints rather than alternate datum semantics.

---

## 22. Versioning and extension rules

### 22.1 Format/algebra version

The `/0` in CD/0 denotes the paired abstract algebra, equality law, and canonical octet grammar defined here. Format version `0` appears in every document immediately after the magic.

A change that would alter the meaning of existing canonical bytes, equality of existing values, tag payload grammar, Unicode treatment, identifier equality, numeric normalization, or record ordering requires a new top-level Canonical Datum version. Identical version-0 bytes keep the same meaning forever.

### 22.2 No in-band /0 extension values

Version 0 has no generic extension tag and no opaque value. Reserved tags have no implementation-local meaning. Profiles extend vocabulary by ordinary records containing explicit profile/schema identifiers, not by claiming reserved wire tags.

A future datum version may define additional inert value forms, but its document version separates those meanings from /0. Such a new form may change equality only within that new version's explicitly specified algebra; it cannot alter `equal-datum` for /0 values. Profile-specific interpretation never changes core record equality. Tags `f0..ff` remain forbidden for privileged values in all versions governed by this family.

### 22.3 Independent version dimensions

The following are distinct and MUST NOT be inferred from the CD/0 format version:

- Lisp+ evaluator semantics version;
- module semantics and module-format version;
- procedure ABI or calling-semantics version;
- Mneme or Language-A profile version;
- claim-identity policy version;
- scope-calculus version;
- individual record schema version;
- hash/signature/manifest scheme version.

When one of these affects interpretation or identity, the relevant profile or identity envelope must include it explicitly.

### 22.4 Profile schemas

A profile-specific record SHOULD carry an explicit schema or profile identifier and version whenever interpretation is not fully fixed by an already authenticated protocol context. Adding a semantically meaningful field requires a schema/version or identity-policy change; consumers cannot silently widen an old record's meaning.

Unknown profile records remain ordinary inert CD/0 records. A profile validator may reject or preserve them, but the core decoder succeeds because it recognizes only the record structure, not the profile semantics.

### 22.5 Negotiation

Version negotiation occurs in a transport or protocol layer before semantic use. A peer may advertise supported Canonical Datum versions and profile versions. A decoder never guesses a lower version from payload shape and never interprets a version-1 document as version 0.

### 22.6 Old-decoder behavior and opaque preservation

A /0 decoder returns `UnsupportedFutureVersion` for a minimally encoded nonzero version and does not parse the value. A storage system may preserve the complete unknown document as an external opaque byte blob with media-type/version metadata. That wrapper is not a CD/0 datum and cannot participate in `equal-datum` or field traversal.

This separation permits lossless forwarding without letting old implementations invent equality or semantics for unknown values.

### 22.7 Byte stability and migration

Canonical bytes for a CD/0 abstract value are stable forever. If a profile changes only its implementation while constructing the same abstract datum, bytes remain identical. If it changes its schema, identity projection, Unicode policy, numeric representation, or semantics-bearing fields, it constructs a different datum and therefore a new artifact/identity input.

A migration preserves CD/0 abstract identity only when the before and after values are the same /0 datum. Migration from a legacy format creates a CD/0 identity for the first time; a legacy digest can be retained as lineage metadata but is not automatically the same identity.

When a migration cannot preserve a source distinction, it must reject or emit an explicit represented-loss record under a profile schema. It may not hide the loss in a renamed field or a comment.

### 22.8 Extensions and privilege

No format version or profile extension can create live authority merely by decoding. An extension may define additional inert data types in a future version; privileged evaluator values remain nominal, separately constructed, and outside Canonical Datum.

---

## 23. Security and hostile-input model

### 23.1 Security boundary

CD/0 is a safe inert-data boundary, not a trust boundary for the statements carried inside it. Exact decoding is intended to be safe on adversarial bytes when supplied a finite resource budget.

A conforming decode has no observable code execution, host object construction beyond private datum representations, package/symbol interning, module loading, capability minting, authority grant, receipt transition, or I/O. Consumers remain responsible for profile validation and for treating strings/bytes as untrusted content.

### 23.2 Required adversarial cases

| # | Adversarial case | CD/0 ruling and required defense |
|---:|---|---|
| 1 | A mutable string leaf remains shared after `copy-tree`. | Runtime construction snapshots mutable leaves. Later source mutation cannot change string scalars, equality, or bytes. A shallow `copy-tree` representation alone is nonconforming. |
| 2 | A datum changes after canonical bytes or a fingerprint have been cached. | Datums are immutable; any retained cache must still equal fresh encoding. Mismatch is `CachedOctetsMismatch`, never silent identity drift. |
| 3 | An accessor returns mutable storage that changes the internal datum. | Accessors expose immutable views or defensive copies. Mutation of returned host storage cannot change the datum. |
| 4 | Two package-distinct Common Lisp symbols collapse to one printed name. | Symbols require explicit injective namespace mapping to segmented identifiers. Package-stripped migration rejects or records loss. |
| 5 | Identical abstract data prints differently under ambient printer settings. | Printer output is not canonical input. Canonical bytes are unchanged under printer/package/locale settings. |
| 6 | A valid canonical datum is followed by trailing bytes. | `decode-exact` returns `TrailingBytes`. A separate `decode-one` must be selected explicitly. |
| 7 | A record contains duplicate fields. | Duplicate canonical identifier keys return `DuplicateRecordField`; no first/last-wins rule. |
| 8 | One integer has multiple accepted encodings. | Minimal UVAR is required; overlong integer UVAR returns `NonminimalIntegerEncoding`. |
| 9 | A rational is unreduced or has a negative denominator. | Unreduced bytes are rejected. Byte denominators are unsigned; host negative denominators normalize only through the public rational constructor or fail at import. |
| 10 | UTF-8 is malformed. | Strict shortest-form scalar decoding rejects with `InvalidUTF8` or `ForbiddenUnicodeScalar`. |
| 11 | Unicode normalization changes testimony. | Codec performs no normalization. Testimony scalar sequence and bytes are preserved exactly. |
| 12 | Two canonically equivalent Unicode strings are treated inconsistently. | They are consistently distinct in strings, identifiers, equality, ordering, and canonical bytes. |
| 13 | A host input contains a cycle. | Recursive importer detects active-ancestor recurrence and returns `CyclicHostInput`; no reference-table encoding exists. |
| 14 | A host input contains shared substructure. | Sharing is unobservable. Import produces repeated equal values; no graph identity leaks. |
| 15 | A record is shaped like a capability. | Decode returns an inert record. Only a separate authorized evaluator transition could create a capability. |
| 16 | A record is shaped like a warrant. | Same: ordinary inert data, no authentication or target authority. |
| 17 | A record is shaped like an active receipt. | Same: no custody, chronology, file access, or state transition follows from shape. |
| 18 | A declared length is maliciously enormous. | Minimal length is budget-checked before proportional allocation or payload loop; return `ExcessiveDeclaredLength`. |
| 19 | Nesting is intended to exhaust the decoder. | Depth and node budgets are checked before descending; return `ExcessiveNesting` or `NodeBudgetExceeded`. |
| 20 | A NaN payload or signed zero differs between implementations. | Native floats are excluded. Profiles preserve exact format and bits as ordinary records; no host numeric equality is invoked. |
| 21 | Common Lisp and Python sort record keys differently. | Both sort unsigned lexicographically by complete canonical identifier value bytes. Decoders verify rather than sort. |
| 22 | An unknown extension tag is interpreted differently by two versions. | /0 reserved tags are rejected. Future meanings require a different document version. No local extension interpretation is allowed. |
| 23 | A decoder accepts a noncanonical encoding and re-emits different bytes. | Exact decoder rejects noncanonical forms. For every successful canonical input, re-encoding equals input. |
| 24 | Concatenated canonical values are mistaken for one value. | Exact decoder requires end of input and returns `TrailingBytes`; streaming operation is separately named. |
| 25 | An identifier differs only by case, normalization, or namespace. | Those are distinct identifiers and distinct bytes. Profiles may reject confusing names, never merge established identities silently. |
| 26 | A profile schema attempts to smuggle live authority through an inert field. | Core returns data only. Privileged construction requires a separate nominal evaluator operation and authority check; field shape has no minting power. |
| 27 | Migration from `mneme-canon/0` collapses package-distinct identifiers. | Migration uses original package-aware source plus explicit mapping, or rejects/records represented loss. Legacy stripped text alone cannot recover the distinction. |
| 28 | A current v1 scope depends on host `eq` identity. | Pointer identity has no CD/0 mapping. Structural scope data can migrate; object-identity semantics require rejection or a later constitutional decision. |
| 29 | A current fingerprint depends on `prin1-to-string`. | New identity inputs use canonical octets and an explicit domain/version envelope. Legacy fingerprints remain metadata only. |
| 30 | A second implementation cannot reproduce bytes without copying SBCL behavior. | The byte grammar, UTF-8, integers, rationals, identifiers, and ordering are specified independently. Shared golden vectors and differential tests enforce exact agreement. |

### 23.3 Additional hostile-input controls

The design also prevents or bounds:

- reader evaluation such as Common Lisp `#.`;
- structure/object constructors such as `#S`, Python pickle reducers, or generic deserializer hooks;
- package resolution and symbol-table pollution;
- integer bombs and unterminated varints;
- decompression-like expansion through implicit references or zero fill;
- pathological arbitrary-key map comparison;
- schema-version defaulting and tag confusion;
- mutation between validation and identity calculation.

### 23.4 What CD/0 does not establish

Successful canonical decoding does **not** establish:

- truth or factual correctness;
- authenticated provenance or authorship;
- authority, permission, or capability possession;
- freshness, current standing, or non-revocation;
- custody, delivery, or receipt chronology;
- successful procedure execution;
- verified lineage or continuity across handoffs;
- legal, scientific, or policy admissibility;
- correct profile interpretation;
- absence of malicious semantic content;
- safety of passing decoded strings to shells, databases, templates, paths, or evaluators.

Canonicalization gives stable inert structure and bytes. It does not alchemize testimony into truth—the serialization layer is a meticulous clerk, not an oracle.

---
## 24. Cryptographic interface

### 24.1 Canonicalization is not cryptography

CD/0 provides deterministic octets. It does not provide collision resistance, preimage resistance, signatures, keys, authentication, freshness, or custody. No hash or signature can repair ambiguous values, mutable backing storage, namespace collapse, or an underspecified identity projection.

A cryptographic layer must receive immutable canonical octets only after the datum and the identity-relevant projection have been fixed.

### 24.2 Domain-framed preimage interface

A future content-ID, module-ID, procedure-ID, claim-ID, artifact-ID, manifest, signature, or Merkle specification SHOULD define its preimage using this framing template:

```text
IdentityPreimage(domain_label, envelope) =
    4c 50 49 44 00                       ; ASCII "LPID" followed by NUL
    UVAR(length(domain_label_octets))
    domain_label_octets
    canonical-octets(envelope)
```

`domain_label_octets` is a nonempty, exact, case-sensitive ASCII byte string assigned by the higher-level identity specification. It is not Unicode-normalized or inferred from a display name. The UVAR follows Section 15.2.

The `envelope` is a CD/0 record whose exact schema is fixed by that identity domain. A scheme may define a different unambiguous framing, but it MUST provide equivalent domain separation and exact metadata binding. Hashing raw payload canonical octets without an identity-domain definition is insufficient.

### 24.3 Required identity-scheme metadata

Every higher-level identity scheme MUST specify, either in the envelope or in an unambiguous versioned scheme definition:

- the domain-separation label;
- the Canonical Datum version, retained through the complete canonical document;
- the identity-policy or projection version;
- the exact payload fields included and excluded;
- every evaluator, module, procedure, profile, scope, time, corpus, or schema version that changes the intended identity;
- the hash algorithm and output encoding used by the resulting ID, if a hash is used;
- treatment of dependencies, referenced artifacts, and represented loss;
- whether the identifier denotes content, a name binding, a claim projection, a procedure, an artifact, or another domain.

The hash algorithm identifier may be part of the resulting identifier wrapper rather than the preimage, provided the scheme is unambiguous and algorithm agility cannot confuse two ID domains.

### 24.4 Signatures, manifests, and Merkle structures

A signature scheme may sign the framed preimage, a specified digest of it, or a manifest record that contains it. This document selects no signature system.

Merkle node and leaf schemes require distinct domain labels and exact child-order rules. Manifests must state profile/schema and identity-policy versions. A signature over canonical bytes authenticates those bytes under the signature policy; it does not prove that a testimony is true or that a procedure ran successfully.

### 24.5 Migration and old fingerprints

Legacy MD5 or printer-derived fingerprints may be carried as explicitly labeled historical metadata. They MUST NOT be treated as CD/0 semantic identity or as equivalent to a new domain-separated ID unless a separate verified mapping proves that relation. In ordinary migration, the new canonical artifact receives a new identity and records its predecessor.

---

## 25. Relation to future located-claim identity

### 25.1 What this specification supplies

A future ClaimId or WarrantTarget specification may rely on these CD/0 operations and laws:

- construction of typed immutable primitive values;
- exact structural record and sequence construction;
- exact identifier namespace preservation;
- `equal-datum`;
- deterministic record-field projection by identifier;
- `canonical-octets`;
- strict `decode-exact`;
- domain-framed cryptographic input under Section 24;
- represented-loss records supplied by a profile.

It may not rely on host object identity, package interning, source record order, diagnostic spelling, current process registries, ambient printer state, or hash collision assumptions.

### 25.2 Structured location components

A located-claim profile can represent, as ordinary records:

- proposition structure;
- subject or entity identifiers;
- corpus and corpus-version references;
- scope components;
- temporal points, intervals, and `as-of` boundaries;
- policy and verifier-policy identifiers;
- procedure and module references;
- evidence and predecessor links;
- schema and identity-policy versions.

CD/0 makes those components immutable and structurally comparable. It does not decide what each component means.

### 25.3 Scope

A scope value encoded as CD/0 can be compared for exact structural equality across processes and implementations. Scope narrowing, widening, subsumption, overlap, satisfiability, and authorization remain functions of a separately versioned scope calculus.

A future WarrantTarget can include canonical scope bytes or a scope-ID record. It must not substitute pointer identity or a process-local scope object.

### 25.4 Temporal boundaries

Temporal boundaries should be explicit profile records that state time scale, coordinate/precision, open or closed endpoints, and any uncertainty required by the profile. A bare host timestamp or printer string has no canonical temporal semantics.

CD/0 can reproduce the record exactly. It does not decide whether two time representations denote the same instant, whether `as-of` belongs in ClaimId, or how intervals affect admissibility.

### 25.5 Adding semantically relevant fields

A claim profile and its identity scheme must define an explicit projection from the full claim record to the ClaimId envelope. Adding a field to a record changes the full record datum, but it changes ClaimId only if the versioned projection includes it.

A semantically relevant addition MUST NOT be introduced silently under the same identity-policy version. The higher-level specification must either:

- include the field and increment the identity-policy/schema version; or
- state explicitly that the field is non-identity metadata and explain why.

The same rule applies to WarrantTarget.

### 25.6 Deferred located-claim questions

The separate claim-identity workshop must decide at least:

- which fields belong in ClaimId;
- which fields belong only in WarrantTarget;
- whether lineage affects identity, admissibility, both, or neither;
- whether policy identity affects claim identity or only admissibility;
- how scope narrowing, widening, and subsumption work;
- how `as-of`, event time, observation time, validity time, and intervals participate;
- how corpus identity and corpus version participate;
- whether procedure, code, module, model, and verifier versions participate;
- how subject/entity aliases and renames participate;
- whether current standing, revocation, or warrant consumption affects identity;
- how represented loss affects identity and admissibility;
- whether two translated claims are successors, equivalents under a policy, or distinct claims.

CD/0 intentionally settles none of these projections.

---

## 26. Migration from current v1 and `mneme-canon/0`

### 26.1 Migration principles

Migration is an explicit adapter operation, not an alias for canonical decoding. Each adapter has a stable identifier and version and records the source format/profile. It follows this sequence:

1. capture the richest available source representation and context before package stripping, printer conversion, or digesting;
2. parse legacy data with a frozen, hostile-input-safe legacy parser appropriate to that format;
3. map every source atom and structural role explicitly to CD/0 types;
4. reject ambiguity or emit represented loss under a declared migration policy;
5. construct and validate an immutable CD/0 datum;
6. emit canonical octets;
7. record predecessor artifact IDs/digests as lineage metadata rather than asserting identity continuity.

Legacy compatibility never justifies preserving package collapse, ambient printer spelling, host pointer identity, mutable aliases, or live authority in the new substrate.

### 26.2 Migration classification

| Current representation | Classification | CD/0 migration ruling |
|---|---|---|
| v1 proposition `(:equals (:call PROC-ID INPUT) EXPECTED)` | **Requiring a profile adapter; exact after explicit tagging** when every leaf is mappable | Preserve the tree's intended roles in a versioned Mneme proposition record/sequence. Map tags and field labels to explicit identifiers. Characters map to one-scalar strings. Common Lisp floats, complex numbers, and other non-core `number` leaves require declared profile records, exact bits/components, represented loss, or refusal. Do not make this grammar a core CD/0 proposition type. Package-sensitive or ambiguous symbols require mapping or refusal. |
| v1 proposition result equality | **Requiring a later constitutional decision** | CD/0 preserves expected result data. The meaning of “equals,” procedure result equality, and profile semantics are outside the core. |
| repaired v1 scope data | **Exact after explicit tagging** for values whose leaves are mappable; **requiring a profile adapter** | Encode proper list structure as sequences where the scope profile declares list/vector topology irrelevant. If an improper cons topology is semantically relevant, reify each cons as explicit `head`/`tail` records; do not smuggle host cons identity into the core. Symbols, characters, and non-core numbers follow their explicit mappings. Exact equality then uses CD/0. |
| legacy scope whose meaning depends on host `eq` | **Rejected**, or **lossy with represented loss** under an approved migration; **requiring a later constitutional decision** | Object identity cannot cross process or implementation. Do not fabricate a stable identity from print form or address. |
| `as-of` values | **Requiring a profile adapter**; often **exact after explicit tagging** | Integers/strings can be preserved as data; a temporal profile should add scale, precision, and endpoint semantics. Whether `as-of` participates in ClaimId/WarrantTarget is deferred. |
| procedure identifier symbols and versions | **Requiring a profile adapter; exact after explicit tagging** only with explicit namespace/module mapping | Produce an inert procedure-reference record separating display name, module identity, exported binding identifier, semantics/version, and any known code/content ID. |
| arbitrary host Common Lisp procedure closure | **Rejected** as CD/0; **requiring separation between inert datum and privileged runtime value** | A closure cannot be serialized as a procedure identity. Preserve only an approved inert reference. Process-local registry bindings do not establish host-independent identity. |
| event kinds such as verification/default events | **Exact after explicit tagging** | Map to declared namespaced identifiers. Do not inherit the Common Lisp keyword package automatically. |
| principal identifiers | **Exact after explicit tagging** when source namespace is known; otherwise **lossy or rejected** | Use explicit namespaced identifiers or principal-reference records. The datum does not authenticate the principal or bind it to a caller. |
| attestation/warrant target components | **Requiring a profile adapter and later constitutional decision** | Encode proposition/location/policy/procedure components as inert records. Do not claim that the current proposition-only fingerprint is a complete located target. |
| live v1 warrant or authenticated attestation | **Requiring separation between inert datum and privileged runtime value** | Export only inert testimony fields under an explicit schema. Decoding those fields never recreates the live warrant. |
| predecessor-warrant testimony | **Requiring a profile adapter; exact after explicit tagging** for the reported fields | Preserve cumulative reported predecessor records and explicit loss markers. “Reported” is not “verified lineage.” Signatures/custody are separate. |
| current v1 claim grades/statuses | **Exact after explicit tagging** | Map status vocabulary to namespaced identifiers in a claim-profile record. Decoding does not create an authenticated claim or current standing. |
| freeze/artifact claim payload | **Requiring a profile adapter** | Replace host/printer forms with a versioned artifact schema over proposition, location, standing testimony, predecessor links, and represented loss. The artifact remains inert. |
| receipt payload fields | **Requiring a profile adapter** | Encode digest labels, artifact references, endpoints, status testimony, and timestamps as data. Host pathnames require an explicit path/URI profile representation. |
| active prepared/committed/received/revived receipt | **Requiring separation between inert datum and privileged runtime value** | Receipt state-machine values remain nominal runtime objects. A record with the same fields is not an active receipt and cannot advance custody. |
| raw artifact decode provenance | **Exact after explicit tagging** | Preserve “untrusted raw decode” as an explicit provenance/status identifier. It remains an assertion until authenticated by another layer. |
| Language-A judgment record | **Requiring a profile adapter; exact after explicit tagging** for structurally known fields | Map the package-specific top-level tag, field keys, statuses, references, and nested lists to explicit identifiers, records, and sequences. Carry profile/schema version. Clause order is discarded only where the Language-A profile declares it nonsemantic. |
| Language-A confidence float | **Exact** only if the original IEEE format and bits are available; otherwise **lossy with represented loss** or **rejected** | Encode exact bits in an IEEE profile record, or encode an explicitly specified decimal/measurement record. SBCL printer spelling is not core numeric identity. |
| Language-A `t`/`nil` and empty-list occurrences | **Requiring a profile adapter** | The schema must decide boolean, unit, absent field, or empty sequence. No global `nil` mapping is allowed. |
| `mneme-canon/0` canonical string | **Requiring a legacy profile adapter; often lossy** | Treat as a historical Language-A notation, not CD/0 bytes. Parse with a frozen safe legacy parser, require full input, then construct CD/0. The resulting canonical octets and ID are new. |
| Package-stripped/downcased symbols already emitted by `mneme-canon/0` | **Lossy with represented loss** or **rejected** for identity-bearing use | The lost package/case distinction cannot be recovered from the canonical string alone. Original source plus mapping is needed for exact migration. |
| `mneme-canon/0` SBCL-pinned float text | **Requiring a profile adapter; potentially lossy** | Preserve the legacy spelling and declared SBCL/version context as data, or recover exact source bits if available. Do not ask another implementation to copy SBCL printing. |
| Existing hostile-decoder payloads and reader fixtures | **Requiring a legacy test adapter** | Retain them as negative fixtures for the old reader boundary. Translate their security intentions into CD/0 negative vectors; do not feed them to a Common Lisp reader as the new codec. |
| Current `prin1-to-string` proposition fingerprints | **Lossy lineage metadata; new identity required** | Preserve digest algorithm, text if available, printer/package context if known, and old digest as legacy metadata. Recompute new domain-separated IDs from CD/0 records. |
| Current MD5 digests/content addresses | **Lossy lineage metadata; new identity required** | MD5 is not selected by CD/0. Never equate the legacy digest with new content identity solely because payloads seem related. |
| Repaired private `canonical-cons`/`canonical-string`-style structures and freeze/thaw logic | **Useful implementation technique; exact only through a typed adapter** | A Common Lisp codec may reuse private immutable wrappers and defensive thawing. Their struct tags and layout disappear behind the Layer-2 API and never enter bytes. |
| Process-local registries, package names, gensym identity, object addresses | **Rejected** | No stable CD/0 mapping without an explicit externally meaningful identifier. |
| Host pathnames and persistence layout | **Rejected as host objects; requiring a profile adapter as data** | Preserve textual/URI/path-segment data plus declared platform semantics when needed. Decoding never opens or resolves the path. |

### 26.3 `mneme-canon/0` compatibility boundary

`mneme-canon/0` remains useful as a historical fixture and migration input. It is not an alternate spelling of CD/0 because it:

- is Language-A-specific;
- strips symbol package identity and downcases names;
- uses a string where octets are required;
- delegates float spelling to a pinned SBCL behavior;
- has legacy reader behavior, including a documented trailing-input defect;
- uses pedagogical MD5 helpers;
- is not the current v1 claim fingerprint path.

A migration tool may expose `import-mneme-canon-0`, but `decode-exact` never accepts that notation.

### 26.4 Techniques to retain

The implementation phase should retain these lessons as local techniques:

- private constructors and nominal separation for privileged values;
- recursive freezing of mutable leaves;
- defensive accessors;
- cycle/improper-list refusal in host import;
- strict full-input consumption;
- structural scope data rather than `eq`;
- separation of raw artifact decoding from receipt revival;
- monotone receipt transition guards outside CD/0;
- cumulative predecessor testimony plus explicit represented loss;
- permanent adversarial fixtures and red/green trace ledgers.

### 26.5 Techniques to hide or replace

The future abstraction boundary replaces or hides:

- shallow `copy-tree` as an immutability claim;
- Common Lisp cons/string struct topology as semantic representation;
- Common Lisp package and keyword identity;
- `eq`, `eql`, or `equal` as the language equality definition;
- ambient `prin1-to-string` fingerprints;
- SBCL float spelling;
- package stripping/downcasing;
- MD5 as an implied identity system;
- process-local closure registries as procedure identity;
- raw host pathnames and object addresses;
- any decoder path that activates a capability, warrant, claim, or receipt from shape alone.

---

## 27. Positive golden-vector schema

### 27.1 Packaging

Shared positive vectors SHOULD be stored as UTF-8 JSON Lines in a repository path such as `canonical-datum/vectors/cd0-positive.jsonl`. JSON is only fixture metadata; it is not a canonical datum encoding and has no identity authority.

Every line contains:

```json
{
  "id": "cd0-pos-rat-neg-half",
  "datum_version": 0,
  "abstract": {"t": "rat", "p": "-1", "q": "2"},
  "canonical_hex": "4c50434400110102",
  "diagnostic": "rat(-1,2)",
  "expected_decoded": {"t": "rat", "p": "-1", "q": "2"},
  "equality_class": "rat:-1/2",
  "notes": ["reduced", "negative sign on numerator"]
}
```

Required fields are:

- `id`: unique stable vector identifier;
- `datum_version`: integer `0`;
- `abstract`: typed fixture description of the construction/input value;
- `canonical_hex`: complete canonical document, lowercase hex without whitespace;
- `expected_decoded`: normalized typed fixture value expected after decode;
- `equality_class`: stable label grouping alternate constructions that denote the same abstract datum;
- `notes`: array of relevant boundary or provenance notes, possibly empty.

`diagnostic` is optional.

### 27.2 Typed fixture AST

The fixture AST uses these forms:

```text
{"t":"unit"}
{"t":"bool","v":false}
{"t":"int","v":"-123"}
{"t":"rat","p":"-1","q":"2"}
{"t":"string","utf8_hex":"65cc81"}
{"t":"bytes","hex":"00ff"}
{"t":"id","namespace_utf8_hex":["6d6e656d65"],
          "path_utf8_hex":["636c61696d","61732d6f66"]}
{"t":"seq","items":[ ... ]}
{"t":"record","fields":[{"key": <id AST>, "value": <datum AST>}, ...]}
```

Integer components are decimal strings to avoid JSON number limits. Strings and identifier segments use UTF-8 hex so the fixture cannot normalize or mishandle surrogates. Record fields in `expected_decoded` appear in canonical key order. An `abstract` construction descriptor may intentionally list fields in another order to test order independence.

### 27.3 Equality classes

Vectors with different source constructions but the same normalized abstract value share an `equality_class` and canonical hex. Examples include:

- rational-constructor input `2/4` and abstract rational `1/2` through the host-constructor test layer;
- records supplied in different source field orders;
- shared versus duplicated acyclic host substructure;
- different immutable host layouts representing the same string or bytes.

Values that merely look similar, such as precomposed/decomposed Unicode or integer `1` versus an IEEE `1.0` record, use different equality classes.

### 27.4 Positive-vector assertions

For every positive vector and its declared sufficient budget, both implementations MUST assert:

1. fixture AST construction succeeds;
2. encoding equals `canonical_hex`;
3. exact decoding succeeds;
4. decoded AST equals `expected_decoded`;
5. re-encoding decoded value equals the original hex;
6. every vector in the equality class compares equal and emits the same bytes;
7. vectors in explicitly distinct classes compare unequal when paired by the corpus manifest;
8. mutation-resistance probes do not alter the value or bytes.

---

## 28. Negative and adversarial-vector schema

### 28.1 Byte-input vectors

Shared negative byte vectors SHOULD be stored in `canonical-datum/vectors/cd0-negative.jsonl`. A byte-input example is:

```json
{
  "id": "cd0-neg-int-zero-overlong",
  "input_kind": "octets",
  "input_hex": "4c50434400108000",
  "budget": "cd0-conformance-default",
  "expected_failure": {
    "category": "NoncanonicalEncoding",
    "code": "NonminimalIntegerEncoding",
    "stage": "integer-payload"
  },
  "input_classification": "noncanonical",
  "resource_state_unchanged": true,
  "partial_output_forbidden": true,
  "notes": ["zigzag zero encoded as overlong UVAR 80 00"]
}
```

Required fields are:

- `id`;
- `input_kind`, either `octets` or `host`;
- `input_hex` for byte input, or `host_input` for a host descriptor;
- explicit budget object or named budget fixture;
- expected category, code, and stage;
- `input_classification`: `invalid`, `noncanonical`, `unsupported`, `resource`, `host-unsupported`, or `privileged`;
- whether caller-visible resource/application state must remain unchanged;
- whether partial output is forbidden;
- notes.

An optional expected octet offset/path may be included when the fault location is stable.

### 28.2 Host-input vectors

Host vectors describe abstract hostile host graphs rather than serializing a real Common Lisp or Python object. A descriptor may use stable `$id`/`$ref` labels:

```json
{
  "id": "cd0-neg-host-cycle-1",
  "input_kind": "host",
  "host_input": {
    "root": {"$ref": "x"},
    "objects": {
      "x": {"host_type": "sequence", "items": [{"$ref": "x"}]}
    }
  },
  "importer": "generic-sequence-import/v0",
  "expected_failure": {
    "category": "UnsupportedHostInput",
    "code": "CyclicHostInput",
    "stage": "host-import"
  },
  "input_classification": "host-unsupported",
  "resource_state_unchanged": true,
  "partial_output_forbidden": true,
  "notes": []
}
```

A shared acyclic descriptor uses repeated `$ref` but no active-ancestor cycle and belongs in positive importer tests.

### 28.3 Corpus generation

The implementation phase MUST generate rather than hand-maintain the bulk corpus. The generator MUST record its version, deterministic seed, command line, and source revision. The release corpus MUST include at least `10,000` positive generated values and `20,000` minimized negative/adversarial vectors, in addition to the hand-authored normative examples.

Generation MUST cover:

- every type tag, reserved-tag range boundary, and forbidden-tag boundary;
- UVAR boundaries around `0`, `1`, `127`, `128`, `16383`, `16384`, and much larger integers;
- positive/negative zigzag boundaries and arbitrary-precision values;
- rational reduction, zero, denominator-one, denominator-zero, sign, and large-GCD cases;
- empty and nonempty strings/bytes, NUL, ASCII boundaries, all UTF-8 sequence lengths, maximum scalar, noncharacters, surrogates, overlong forms, and truncations;
- precomposed/decomposed and confusable identifier cases;
- empty and nested containers, exact depth/node/count budget boundaries;
- record key permutations, duplicates, prefix-like key encodings, and large key sets;
- every truncation point for all hand vectors and for generated canonical documents up to a configured size;
- appended garbage and concatenated complete documents;
- overlong version, integer, rational, count, length, and segment encodings;
- declared lengths/counts above budgets without matching payload;
- host cycles, improper lists, mutable aliases, shared acyclic substructure, ambiguous symbols, uninterned symbols, Python bool/int confusion, and privileged host values;
- capability-, warrant-, certificate-, and receipt-shaped ordinary records that must decode successfully and remain inert.

### 28.4 Mutation-derived negatives

For each sampled positive document, the generator MUST derive mutations by:

- deleting each octet position or suffix;
- appending one or more octets;
- replacing type tags with reserved/forbidden tags;
- making a UVAR overlong;
- changing a declared length/count near a boundary;
- corrupting UTF-8 continuation/lead bytes;
- swapping or duplicating record fields;
- replacing rational components with zero, one, or a common-factor pair.

The generator MUST NOT assume that every random mutation has only one defect. Any Common Lisp/Python disagreement MUST be shrunk to a minimal reproducer and added as a permanent vector with one primary expected failure.

### 28.5 Resource and state assertions

Resource vectors include the exact budget. They assert:

- the expected resource code rather than semantic invalidity;
- no partial datum;
- no symbol/package/registry/evaluator/I/O side effect;
- no allocation proportional to a declaration already known to exceed budget;
- successful retry under a larger sufficient budget when the underlying bytes are canonical.

---

## 29. Cross-implementation properties

Let `E(x)` be the complete canonical document from a sufficient-budget encoder, `D_B(b)` the exact decoder under budget `B`, and `≈` abstract datum equality.

### 29.1 Determinism

For every valid datum `x`, all successful invocations and all conforming implementations produce the same bytes:

```text
E_CL(x) = E_Python(x) = E(x)
```

Ambient host state cannot alter the result.

### 29.2 Unique encoding and equality correspondence

For all valid datums `x` and `y`:

```text
x ≈ y    iff    E(x) = E(y)
```

This entails both injectivity of encoding over abstract values and canonical coalescing of all permitted constructor normalizations.

### 29.3 Round trip

For every valid datum `x` and a budget sufficient for `E(x)`:

```text
D_B(E(x)) ≈ x
```

The returned runtime datum is immutable and inert.

### 29.4 Canonical-byte round trip

For every canonical valid byte string `b` and sufficient budget:

```text
E(D_B(b)) = b
```

This law does not apply to noncanonical bytes because `D_B` rejects them.

### 29.5 Full input consumption

For canonical document `b` and any nonempty suffix `s`:

```text
D_B(b || s) = TrailingBytes
```

unless the selected operation is the separately named streaming `decode-one`.

### 29.6 Noncanonical refusal

Every byte sequence classified by this specification as a noncanonical spelling fails under `decode-exact`. A decoder cannot accept then normalize it to different bytes.

### 29.7 Immutability

After successful construction or decode, mutation of every supplied mutable host source and every accessor-returned mutable copy leaves:

```text
E(x), equal-datum(x, y), and every datum accessor
```

unchanged for the original datum.

### 29.8 Inert decoding

Decoding any canonical record, including a privileged-looking one, returns only an inert record. Tests instrument evaluator transitions, package/symbol tables, registries, filesystem, and network hooks and observe no activation side effect.

### 29.9 Namespace preservation

Identifiers that differ in namespace, path segmentation, case, or scalar sequence compare unequal and encode differently. Explicitly equal identifiers compare equal across hosts without symbol interning.

### 29.10 Resource-bounded refusal

For a canonical `b` that exceeds explicit budget `B` but fits `B'`:

```text
D_B(b)  = ResourceRefusal
D_B'(b) = successful datum
```

The first result does not imply invalid bytes and publishes no partial datum.

### 29.11 Version separation

A /0-only decoder accepts only minimally encoded version `0`. A document with another version never falls through to /0 tag interpretation. Version-prefixed bytes from distinct versions cannot be equal canonical documents.

### 29.12 Extension non-confusion

No reserved /0 tag can succeed or become an implementation-local opaque value. A future version cannot retroactively assign new /0 semantics to the same complete bytes.

### 29.13 Host independence

The vector suite must run under at least:

- independent Common Lisp and Python implementations;
- changed Common Lisp printer/package/readtable settings;
- changed Python hash seed and dictionary insertion order;
- distinct processes;
- multiple supported host implementation versions where available.

The results compared are canonical bytes, abstract equality, and typed failure category/code/stage—not host exception text.

### 29.14 Differential failure classification

Both codecs run every negative vector with the same declared budget and report the same normative failure triple. Any divergence is a conformance failure or a specification ambiguity. It is never silently waived because both implementations happened to reject.

### 29.15 Randomized and mutation properties

Each implementation runs independently generated randomized round trips, then exchanges seeds and fixture ASTs. Differential testing compares:

- bytes for every generated valid datum;
- equality classes;
- decode/re-encode identity;
- hostile-input refusal classification;
- mutable-source and accessor mutation behavior;
- cycle versus sharing behavior;
- resource-boundary behavior.

### 29.16 Qualification by budget and host failure

Round-trip success laws assume a declared sufficient budget and successful host allocation. Insufficient budget produces `ResourceRefusal`; it does not weaken equality or permit alternate bytes. Unexpected host allocation refusal is classified but may not be reproducible across machines, so shared vectors use deterministic budget thresholds for differential comparison.

---

## 30. Rejected alternatives and reasons

### 30.1 Deep-copied Common Lisp/Python trees

Rejected as normative architecture. Deep copying is a useful import technique, but it is not a semantic model. It misses mutable leaves unless every host type is audited, preserves host distinctions accidentally, cannot provide cross-process identity, and invites `nil`, symbol, list/vector, bool/int, and pointer-identity leakage.

### 30.2 Common Lisp reader and printed S-expressions

Rejected. The reader has package resolution, symbol interning, implementation extensions, dispatch macros, readtable state, printer/read round-trip subtleties, float syntax, circular notation, and potential evaluation/object-construction features. Disabling a few dangerous macros does not specify one implementation-independent canonical grammar.

S-expression-shaped diagnostic text remains welcome for humans; Common Lisp's reader and printer are not the authority.

### 30.3 JSON

Rejected as the canonical encoding. Ordinary JSON lacks raw bytes, arbitrary-precision number guarantees, exact rationals, first-class identifiers, type distinction between integer and approximate number, duplicate-key consensus, and a required Unicode normalization policy. Parser behavior and number conversion vary.

### 30.4 Canonical JSON

Rejected as the selected foundation. A precise canonical JSON profile could solve ordering and spelling, but it would still require tagged wrappers for bytes, big integers, rationals, identifiers, and disjoint types, plus strict duplicate and Unicode rules. The result would be larger, more escape-heavy, and easier for generic JSON tooling to misinterpret as ordinary JSON semantics.

### 30.5 CBOR and deterministic CBOR

Not adopted without qualification. CBOR is a strong general-purpose format, but its full surface includes floats, arbitrary map keys, semantic tags, indefinite lengths, multiple integer/bignum representations, and implementation choices that CD/0 intentionally excludes. “Deterministic CBOR” alone does not decide Lisp+ rational normalization, identifier structure, Unicode equality, privileged-tag behavior, profile extension policy, or whether decoders reject all nonpreferred forms.

A sufficiently tight CBOR profile could encode the chosen algebra, but it would need nearly all of this document plus a larger attack surface and ecosystem decoders that often accept broader inputs. The purpose-built nine-tag grammar is smaller to implement, easier to audit, and makes forbidden forms syntactically conspicuous.

### 30.6 MessagePack

Rejected as the normative foundation. It has multiple integer/string/bin/container encodings, extension types, map-key freedom, and float forms. A restrictive profile would again need custom canonicality and semantic rules while retaining unused surface.

### 30.7 Generic serialization libraries

Rejected. Libraries that serialize host objects tend to encode class names, module paths, object hooks, reference identity, private fields, implementation versions, or mutable graph topology. Their convenience is precisely the semantic leakage CD/0 is designed to remove.

### 30.8 `mneme-canon/0`

Rejected as the language substrate while retained as a legacy fixture. It is profile-specific, package-collapsing, string-returning, SBCL-float-pinned, reader-dependent, and historically separate from v1 fingerprints. Its useful lessons—ordered data lists, sorted record clauses, cycle refusal, and ambient-printer suspicion—are preserved in host-independent form.

### 30.9 Canonical octets as the only public representation

Rejected as the complete architecture. Byte-primary storage is excellent for identity and persistence, but evaluators, validators, and profile code need safe typed traversal. Making every consumer reparse bytes increases complexity and tempts ad hoc decoded host objects. The selected hybrid retains byte authority while specifying immutable views.

### 30.10 A richer /0 numeric or collection core

Rejected. Native floats, decimals, timestamps, maps, sets, graphs, UUIDs, URIs, and opaque extensions would force policy decisions not needed for the initial substrate. Exact records can carry those data under explicit profiles without pretending that their domain semantics are universal.

### 30.11 Unicode normalization in the core

Rejected. Normalization can erase distinctions in testimony, source text, names, and external evidence; normalization versions and security policies also evolve. Exact scalar preservation is simpler and safer. Profiles may validate or intentionally normalize before identity construction while recording loss.

---

## 31. Deferred constitutional questions

The following questions are intentionally not answered by CD/0:

### 31.1 Located claims and evidence

- the ClaimId and WarrantTarget field projections;
- temporal, scope, corpus, subject, policy, and procedure participation;
- scope subsumption and admissibility;
- revocation, current standing, warrant reuse, and consumption;
- verified versus reported lineage and compaction;
- represented-loss effects on admissibility and identity.

### 31.2 Evaluator, modules, and procedures

- lexical binding and alpha-renaming identity;
- module sealing, import/export authority, and module identity;
- code equivalence, closure identity, procedure ABI, and content IDs;
- checked effect declarations and enforcement;
- same-image isolation from Common Lisp internals, FFI, conditions, restarts, and host mutation;
- process-local registry replacement.

### 31.3 Privileged values

- capability and authority-grant semantics;
- warrant issuance and verification transitions;
- authenticated-claim nominal types;
- receipt state-indexed types, custody, and replay rules;
- privileged evaluator transitions from validated inert records.

### 31.4 Profiles and domain values

- the complete Language-A schema and later profile vocabularies;
- decimal, measurement, timestamp, interval, URI, UUID, graph, map, and set profiles;
- identifier lexical/security restrictions and confusable-warning policy;
- record-schema discovery and profile negotiation.

### 31.5 Cryptography and operations

- hash and signature algorithms;
- key, certificate, trust-root, revocation, and rotation systems;
- content-address and Merkle registry formats;
- custody and multi-hop lineage verification;
- production resource floors, streaming transports, persistence layout, and media-type registration;
- governance of future Canonical Datum versions and domain-label registries.

Deferral means these questions require their own explicit specifications. It does not permit implementations to answer them silently inside a codec.

---

## 32. Concise Codex implementation handoff

Paste the following into Codex CLI from the repository root:

```text
Implement Lisp+ Canonical Datum /0 codecs from CANONICAL-DATUM-SPEC.md.
Treat that file as normative. Do not infer semantics from the current Common Lisp
kernel, mneme-canon/0, SBCL printing, package identity, or Python host equality.

Deliver two independent codecs: one Common Lisp and one Python. Where practical,
write each clean-room implementation without consulting the other's source until
both can run the shared fixtures. Both must expose immutable typed datums,
equal-datum, encode-exact, decode-exact, explicit resource budgets, and the
normative typed failure category/code/stage.

Create shared positive and negative JSONL vectors using Sections 27-28, including
the worked bytes from Section 15. Generate the larger deterministic corpus with
recorded generator version and seeds. Run randomized round trips, canonicality,
full-input, mutation-resistance, hostile-input, resource, namespace, inertness,
and differential byte/failure tests.

Record every missing, contradictory, or ambiguous rule in
CANONICAL-DATUM-DIVERGENCES.md. Demonstrate each entry with a failing, blocked, or
divergent test. Never resolve missing semantics silently and never make the two
implementations agree by copying an undocumented choice from one into the other.
After adjudication, add the minimized reproducer to the permanent shared vectors.

Run differential tests only after the initial independent implementations exist.
Preserve exact commands, host/runtime versions, seeds, exit status, and complete
results in a verification ledger. Do not modify unrelated Mneme semantics,
capability/warrant/receipt behavior, Language-A policy, or located-claim identity.

Do not migrate the existing v1 datum boundary until the Common Lisp and Python
codecs agree on all shared vectors and differential properties. During migration,
report which current repair choices remain useful local implementation techniques
and which are replaced or hidden by the CD/0 abstraction. Keep live authority and
active receipts outside the datum decoder.
```

---

## 33. Decision receipt

### 33.1 Receipt metadata

```text
receipt-id:        lisp-plus-canonical-datum-0-design-2026-07-13
status:            accepted for independent codec implementation
scope:             abstract datum algebra, immutable runtime contract,
                   canonical octets, diagnostic notation, failures,
                   resources, versioning, migration interface
baseline:          9e9c031a720cd40559297c9d8bb07bf8137adb54
fresh-evidence:    attached v1 counterexample-closure packet dated 2026-07-13
cryptographic:     no; this receipt is a design record, not an authenticated signature
```

### 33.2 Major adjudications

| Decision ID | Adjudication | Consequence |
|---|---|---|
| `CD0-D01` | Abstract equality defines semantic identity; canonical octets are its exact cross-process witness. | Host equality, object identity, diagnostics, and hashes cannot redefine identity. |
| `CD0-D02` | Select the mutually checked immutable-value/canonical-octet hybrid. | Traversal remains ergonomic while cached identity cannot drift. |
| `CD0-D03` | Include only unit, booleans, integers, reduced rationals, scalar strings, bytes, identifiers, sequences, and records. | /0 stays small and exact. |
| `CD0-D04` | Exclude native floats and decimals; represent exact bits or declared decimal semantics in records. | No SBCL/Python float-printer or NaN/signed-zero disagreement enters the core. |
| `CD0-D05` | Preserve Unicode scalar sequences exactly; perform no normalization. | Testimony and identifiers retain source distinctions. |
| `CD0-D06` | Use segmented, explicit, case-sensitive namespace/path identifiers. | Package stripping, case folding, and symbol interning are not identity. |
| `CD0-D07` | Include identifier-keyed records; exclude general maps and sets. | Canonical ordering is simple, byte-defined, and hostile-input auditable. |
| `CD0-D08` | Adopt the `LPCD` versioned binary grammar with minimal UVAR, zigzag integers, strict UTF-8, and count framing. | Every datum has one canonical document independent of host printers/readers. |
| `CD0-D09` | Require canonical-only exact decoding and full input consumption. | Noncanonical repair, trailing data, and concatenation confusion are refused. |
| `CD0-D10` | Reserve tags `f0..ff` permanently against privileged values. | No canonical byte tag can directly restore live authority. |
| `CD0-D11` | Require explicit resource budgets rather than prototype constants. | Deployments can refuse safely without changing semantic validity. |
| `CD0-D12` | Require deep observable immutability and defensive access. | Mutable leaves and stale cached fingerprints cannot recur. |
| `CD0-D13` | Make runtime sharing unobservable and reject cycles. | Cross-language equality remains tree/value based rather than pointer based. |
| `CD0-D14` | Permit profile evolution through explicit records; require a top-level version change for core type/equality changes. | Identical /0 bytes never acquire a second meaning. |
| `CD0-D15` | Return no opaque unknown datum under /0. | Old decoders cannot invent equality for future values; whole bytes may be preserved externally. |
| `CD0-D16` | Keep capabilities, warrants, authenticated claims, closures, modules, and active receipts outside canonical inert data. | Shape alone never mints privilege. |
| `CD0-D17` | Define only a domain-framed cryptographic input interface, not a hash/signature system. | Canonicalization and cryptographic trust remain separate. |
| `CD0-D18` | Accept the ten v1 closure results while treating their private Common Lisp representation as local technique. | Closed defects stay closed; host-specific repairs do not become language law. |
| `CD0-D19` | Migrate legacy values through explicit versioned adapters with rejection or represented loss. | Package, printer, float, `eq`, and MD5 accidents are not preserved as new identity. |
| `CD0-D20` | Defer ClaimId/WarrantTarget projections, scope calculus, module/procedure identity, effects, custody, and verified lineage. | CD/0 supplies stable components without preempting later constitutions. |

### 33.3 Acceptance criterion

The decision is successful only when two clean-room implementers—one Common Lisp and one Python—can, without consulting one another's code or copying SBCL's object model:

- construct the same abstract values;
- make the same equality judgments;
- produce identical canonical octets;
- reject the same hostile/noncanonical inputs with the same normative failure classification;
- preserve immutability under mutation probes; and
- return inert data without authority or evaluator side effects.

Any failure of that criterion is either an implementation defect or a specification divergence to be recorded and adjudicated. It is not permission for implementation-local semantics.

### 33.4 Final paste-ready handoff

```text
Treat CANONICAL-DATUM-SPEC.md as normative. Implement independent Common Lisp and
Python CD/0 codecs with immutable typed values, exact canonical bytes, explicit
budgets, and typed failures. Share positive/negative vectors but avoid consulting
one implementation while initially writing the other where practical. Record every
ambiguity in CANONICAL-DATUM-DIVERGENCES.md and demonstrate it with a failing,
blocked, or divergent test; never resolve missing semantics silently. Generate and
run the shared corpus, randomized round trips, canonicality, mutation, hostile-input,
resource, inertness, and differential byte/failure tests. Preserve exact commands,
versions, seeds, and results. Do not modify unrelated Mneme semantics. Migrate the
v1 datum boundary only after both codecs agree, and report which current repairs
remain local techniques versus which are replaced by CD/0.
```
