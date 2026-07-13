# Lisp+ Canonical Datum /0 — Specification Errata 0.1

**Repository file:** `CANONICAL-DATUM-SPEC-ERRATA-0.1.md`  
**Status:** Normative errata to Lisp+ Canonical Datum /0  
**Errata revision:** `0.1`  
**Date:** 2026-07-13  
**Applies to:** `mneme/spec/CANONICAL-DATUM-SPEC.md`  
**Base specification SHA-256:** `d578e86e4d411611b091cca0bed1cafac2636c0908e95447fd4a13badcab6abc`  
**Datum format and algebra version after this errata:** `0` (`CD/0`)

The key words **MUST**, **MUST NOT**, **REQUIRED**, **SHOULD**, **SHOULD NOT**, and **MAY** have the same normative force as in the base specification.

This document closes divergence-register items A1–A9. It does not replace the base specification. A conformance claim made after adoption of Errata 0.1 is a claim against the base specification plus this document.

## 1. Compatibility ruling

Errata 0.1 changes no abstract CD/0 value, equality judgment, canonical type tag, canonical payload grammar, canonical field order, or canonical octet string. It adds or clarifies observable failure metadata, resource-budget jurisdiction, record-key failure precedence, and fixture-schema behavior.

Accordingly:

- every canonical document accepted before this errata is accepted after it under the same sufficient decode budget;
- every byte string rejected as invalid, noncanonical, unsupported, or privileged before this errata remains rejected;
- every successful encoding emits exactly the same octets;
- `equal-datum` is unchanged;
- the document magic and encoded version remain `LPCD` plus UVAR `0`;
- no datum-format version increment is permitted or required for these changes.

A change in typed failure category, code, or stage required below is a conformance change even though it is not a wire-format change.

## 2. E0.1-1 — Complete failure-stage assignment (A1)

### 2.1 Affected sections

This entry supplements Sections 17.7, 20.1, 20.4, and 20.5. Section 20.4's list of legal stage names remains unchanged.

### 2.2 Added normative language

Add the following after Section 20.4.

### 20.4.1 Meaning of `stage`

`stage` identifies the named codec checkpoint at which the selected failure becomes fully determinable after applying Section 20.5 precedence. It does not identify the abstract cause, the host stack frame, or the outermost container.

A failure arising while parsing a nested value retains the nested value's stage. An enclosing sequence or record MUST NOT relabel a nested integer, rational, length, UTF-8, identifier, record-order, or type-tag failure as `container-content`.

The following assignments are normative.

| Operation and failure context | Required stage |
|---|---|
| `decode-exact`: `ExcessiveInputLength` | `input-budget` |
| Magic mismatch, or end of input after a matching proper prefix of `LPCD` | `magic` |
| Version UVAR truncation, `VarintBudgetExceeded`, or `NonminimalVersionEncoding` | `version-varint` |
| `UnknownVersion` or `UnsupportedFutureVersion` after a minimal version UVAR | `version-selection` |
| Root value has no tag octet | `type-tag` |
| `ExcessiveNesting` or `NodeBudgetExceeded` at value entry | `type-tag` |
| `InvalidTypeTag`, `ReservedTypeTag`, `UnsupportedExtensionTag`, or a value-position `ForbiddenPrivilegedTag` | `type-tag` |
| Integer UVAR truncation, integer-UVAR `VarintBudgetExceeded`, `NonminimalIntegerEncoding`, or integer `IntegerBudgetExceeded` | `integer-payload` |
| Rational-component UVAR truncation, rational-component `VarintBudgetExceeded`, `NonminimalRationalComponentEncoding`, rational-component `IntegerBudgetExceeded`, `ZeroDenominator`, `ZeroRationalEncoding`, `IntegralRationalEncoding`, or `UnreducedRational` | `rational-payload` |
| String, byte-string, or identifier-segment length-UVAR truncation, length-UVAR `VarintBudgetExceeded`, `OverlongLengthEncoding`, applicable `ExcessiveDeclaredLength`, or `AggregatePayloadBudgetExceeded` discovered for that payload | `length` |
| End of input after a string, byte-string, or identifier-segment payload length has been accepted but before all declared payload octets are present | `length` |
| Invalid UTF-8 within a complete declared string or identifier-segment payload, or `ForbiddenUnicodeScalar` | `utf8` |
| Sequence, record, namespace, or path count-UVAR truncation, count-UVAR `VarintBudgetExceeded`, `OverlongCountEncoding`, `ExcessiveContainerCount`, or `ExcessiveIdentifierSegments` | `count` |
| A sequence or record count promises another element, key, or value and end of input occurs before the first octet of that promised nested item | `count` |
| An identifier count promises another segment and end of input occurs before the first octet of that segment's length UVAR | `count` |
| `EmptyIdentifierSegment` or `MissingIdentifierPath` after the relevant count or segment has been decoded | `identifier` |
| A record key's first octet is present but is neither `22` nor in `f0..ff` | `record-key` |
| A record key's first octet is in `f0..ff` | `type-tag` |
| `DuplicateRecordField` or `NoncanonicalFieldOrder` | `record-order` |
| `TrailingBytes` | `end-of-input` |
| Any host constructor or hostile-host importer rejection, including constructor-invariant, cycle, improper-list, ambiguous-identifier, host-Unicode, host-type, privileged-host-value, and deterministic host-import resource refusals, except actual allocation refusal | `host-import` |
| `RecordKeyWorkBudgetExceeded` while encoding an already-valid runtime datum | `encode-ordering` |
| `ExcessiveOutputLength` | `allocation` |
| Actual host `AllocationRefused` during decode, construction, import, or encode | `allocation` |
| `CachedOctetsMismatch` | `cache-check` |
| `EncoderInvariantFailure` or `DecoderInvariantFailure` not more specifically assigned above | `internal` |

For a count-promised nested value, the `count` assignment applies only when no octet of that nested value is available. Once a nested tag octet is available, parsing has entered that nested value and its own stage assignments apply.

For an identifier segment, `count` applies when the promised segment has not begun; `length` applies once the segment-length UVAR has begun or completed; `utf8` applies only after the complete declared payload is present and its UTF-8 content is being validated.

`container-content` remains a legal diagnostic stage name in the base vocabulary, but Errata 0.1 assigns no CD/0 core failure code to it. A future specification revision may assign it without changing existing triples; a /0 implementation MUST NOT substitute it for a stage assigned above.

### 2.3 Observable conformance consequence

The eleven `provisional-blocked-stage` hand vectors and the corresponding generated rows can be promoted to full category/code/stage comparison after their expected stages are made consistent with this matrix. In particular, the depth and node fixtures MUST change their expected stage from `container-content` to `type-tag`.

An encoder output-budget vector for Unit under `max_output_octets = 5` MUST report:

```text
ResourceRefusal / ExcessiveOutputLength / allocation
```

### 2.4 Compatibility

Canonical octets, abstract equality, and accepted abstract values do not change. Some previously provisional failure metadata becomes mandatory. No codec-format version changes.

## 3. E0.1-2 — Constructor and hostile-host importer failures (A2)

### 3.1 Affected sections

This entry supplements Sections 7.2, 8.3, 11, 14.2, 17.1–17.2, and 20.1–20.4. It qualifies the category column of Section 20.3 for failures raised at a host boundary.

### 3.2 Added normative language

Add the following after Section 20.2.

### 20.2.1 Host-boundary invariant failures

`InvalidCanonicalGrammar` is the category for defects determined from a CD/0 byte document. A public typed constructor, fixture-AST constructor, or hostile-host importer does not parse a CD/0 byte document. When such an operation rejects supplied host data because no valid CD/0 datum can be constructed, the category MUST be `UnsupportedHostInput` and the stage MUST be `host-import`, unless the input is a live privileged value or an actual allocation refusal.

When a host-boundary failure has the same precise semantic cause as an existing decoder failure code, the implementation MUST reuse that code. This context-sensitive reuse includes at least:

```text
UnsupportedHostInput / ZeroDenominator          / host-import
UnsupportedHostInput / EmptyIdentifierSegment   / host-import
UnsupportedHostInput / MissingIdentifierPath    / host-import
UnsupportedHostInput / DuplicateRecordField     / host-import
```

A public rational constructor may normalize a negative denominator as required by Section 8.3. A low-level importer presented with a malformed purported runtime-rational representation may instead report:

```text
UnsupportedHostInput / NegativeDenominatorHostRational / host-import
```

A value belonging to the wrong disjoint host-import family, including Python boolean supplied to an integer-only fixture constructor, MUST report:

```text
UnsupportedHostInput / UnsupportedHostType / host-import
```

A live privileged host value remains:

```text
PrivilegedRestorationAttempt / PrivilegedHostValue / host-import
```

An actual inability to allocate remains `ResourceRefusal / AllocationRefused / allocation`.

The category assigned to a code is therefore operation-sensitive for the four shared semantic-invariant codes above: byte-document defects use their Section 20.3 `InvalidCanonicalGrammar` category; host-construction defects use `UnsupportedHostInput`. Implementations MUST NOT classify host-constructor input as malformed canonical bytes merely because the same invariant also exists in the byte grammar.

### 3.3 Observable conformance consequence

Add negative host-construction vectors for zero denominator, empty identifier segment, missing identifier path, duplicate record key, and boolean-as-integer. They MUST compare the complete triple.

The Common Lisp codec behavior reported in the audit for zero denominator, empty identifier segment, and missing identifier path must change category from `InvalidCanonicalGrammar` to `UnsupportedHostInput`. The Python behavior already reported for those witnesses matches this ruling. This adoption is based on the host-boundary distinction above, not on either implementation's prior choice.

### 3.4 Compatibility

No canonical byte is accepted or rejected differently. No valid abstract datum or equality judgment changes. The same invalid host inputs remain invalid; only their normative category becomes fixed. No datum-format version changes.

## 4. E0.1-3 — Exact `max_integer_bits` metric (A3)

### 4.1 Affected sections

This entry supplements Sections 20.3, 20.5(6), 21.2, and 21.4.

### 4.2 Added normative language

Add the following to Section 21.3.

For a mathematical integer component `z`, define:

```text
magnitude-bits(z) = 0                              when z = 0
                  = floor(log2(abs(z))) + 1        otherwise
```

Equivalently, this is `bit_length(abs(z))` in hosts that provide such an operation.

`max_integer_bits` limits `magnitude-bits(z)`. It does not count a sign bit, zigzag-transformed payload bits, UVAR continuation bits, or UVAR framing octets. `max_varint_octets` independently limits wire-level UVAR work.

For a rational byte payload, the numerator and denominator are checked as separate mathematical components. For a hostile-host rational construction, the supplied numerator and denominator magnitudes MUST be checked before a potentially expensive reduction, and the normalized result MUST also satisfy the runtime invariant. Runtime `encode-exact` of an already-valid datum does not enforce `max_integer_bits`; see E0.1-9.

### 4.3 Observable conformance consequence

Required boundary vectors include:

```text
Integer(-65), max_integer_bits = 7  -> accept
Integer(-65), max_integer_bits = 6  -> IntegerBudgetExceeded / integer-payload
Integer(0),   max_integer_bits = 0  -> accept
```

Equivalent numerator and denominator boundary cases MUST be included for rationals.

### 4.4 Compatibility

Canonical octets and equality do not change. Resource acceptance at previously ambiguous bit-count boundaries becomes fixed. Existing vectors away from those boundaries remain valid. No datum-format version changes.

## 5. E0.1-4 — Aggregate identifier-segment budget (A4)

### 5.1 Affected sections

This entry supplements Sections 20.3, 21.2, and 21.3.

### 5.2 Added normative language

`max_identifier_segments` limits the total number of segments in one identifier:

```text
namespace-count + path-count
```

It is not a separate per-namespace and per-path allowance. A decoder MUST reject as soon as the already-known namespace count alone exceeds the limit. After obtaining the path count, it MUST compare without overflowing by checking:

```text
path-count > max_identifier_segments - namespace-count
```

provided the namespace count has already been shown not to exceed the limit. A host importer MUST perform the equivalent aggregate check before traversing or allocating storage proportional to all segments.

The byte decoder reports `ResourceRefusal / ExcessiveIdentifierSegments / count`; a host constructor/importer reports the same category and code at `host-import`.

### 5.3 Observable conformance consequence

For `Id(["n"],["p"])`:

```text
max_identifier_segments = 1 -> refuse ExcessiveIdentifierSegments
max_identifier_segments = 2 -> accept
```

### 5.4 Compatibility

Canonical octets and abstract equality do not change. Tight-budget resource behavior becomes fixed. Existing vectors whose namespace count alone exceeds the budget remain valid. No datum-format version changes.

## 6. E0.1-5 — Simultaneous resource-refusal precedence (A5)

### 6.1 Affected sections

This entry supplements Sections 20.5(5–7) and 21.3–21.5.

### 6.2 Added normative language

Within decode and hostile-host import, deterministic resource checks follow this order whenever more than one listed limit would refuse at the same traversal checkpoint:

1. `max_depth`;
2. `max_nodes`;
3. the applicable per-value or context-specific magnitude, count, or declared-length limit;
4. `max_aggregate_payload_octets`.

Consequently:

- at value entry, `ExcessiveNesting` precedes `NodeBudgetExceeded`;
- after a minimally encoded payload length is known, the applicable `max_segment_octets`, `max_single_string_octets`, or `max_single_bytes_octets` check precedes aggregate-payload accounting;
- after a minimally encoded container count is known, the applicable sequence, record, or aggregate identifier-segment count check precedes traversal of contents;
- varint-octet budget, termination, and minimality retain their existing Section 20.5 precedence before magnitude/count/length budget checks;
- a resource refusal determined by this order precedes testing whether a declared in-budget payload happens to be truncated, as already required by Section 20.5(7–8).

The order applies to deterministic declared budgets, not to asynchronous or host-dependent allocation failure. `AllocationRefused` may occur only where the host actually cannot allocate a representation that the declared budgets permit.

### 6.3 Observable conformance consequence

At minimum, shared vectors MUST assert:

```text
Sequence([Unit]), max_depth = 1 and max_nodes = 1
  -> ResourceRefusal / ExcessiveNesting / type-tag

String("ab"), max_single_string_octets = 1
              and max_aggregate_payload_octets = 1
  -> ResourceRefusal / ExcessiveDeclaredLength / length
```

### 6.4 Compatibility

No canonical bytes, abstract values, or equality judgments change. Only the selected deterministic resource code in simultaneous-breach cases is fixed. Existing single-breach vectors remain valid. No datum-format version changes.

## 7. E0.1-6 — Record-key first-octet gate (A6)

### 7.1 Affected sections

This entry supplements Sections 15.3, 15.10, 18.5, 20.3, and 20.5(9–11).

### 7.2 Added normative language

Before parsing a declared record key, the decoder MUST inspect its first octet using this gate:

```text
first octet absent       -> TruncatedInput at stage count
first octet 22           -> parse an Identifier key normally
first octet f0..ff       -> PrivilegedRestorationAttempt /
                             ForbiddenPrivilegedTag /
                             type-tag
every other first octet  -> InvalidCanonicalGrammar /
                             RecordKeyNotIdentifier /
                             record-key
```

For the final branch, the decoder MUST NOT reinterpret the octet as an ordinary nested value tag. Thus a reserved tag such as `03` in record-key position produces `RecordKeyNotIdentifier`, not `ReservedTypeTag`. The permanently privileged `f0..ff` range takes precedence everywhere, including record-key position, so its security classification is not hidden by a generic key-shape error.

### 7.3 Observable conformance consequence

Shared negative vectors MUST include record-key-first-octet `03` and `f0` cases and compare the complete triples shown above.

### 7.4 Compatibility

No invalid byte string becomes valid and no valid byte string becomes invalid. Canonical octets and equality do not change. Only failure classification for an ambiguous invalid-key case is fixed. No datum-format version changes.

## 8. E0.1-7 — Rational construction descriptor in fixtures (A7)

### 8.1 Classification and affected sections

A7 is a fixture/harness defect, not a defect in the abstract algebra or canonical grammar. This entry corrects the inconsistency between Sections 27.2 and 27.3.

### 8.2 Added fixture language

A positive or negative fixture MAY contain an optional `construction` member distinct from the normalized datum AST. The first standardized construction form is:

```json
{"op":"rational","p":"2","q":"4"}
```

`p` and `q` are exact decimal integer strings. The fixture adapter invokes the public rational constructor on those mathematical integers. The vector's `abstract` and `expected_decoded` members remain normalized datum ASTs. For example:

```json
{
  "id": "cd0-pos-rational-construction-two-fourths",
  "datum_version": 0,
  "construction": {"op":"rational","p":"2","q":"4"},
  "abstract": {"t":"rat","p":"1","q":"2"},
  "expected_decoded": {"t":"rat","p":"1","q":"2"},
  "canonical_hex": "4c50434400110202",
  "equality_class": "rat:1/2",
  "notes": ["constructor normalization; construction metadata is not a datum"]
}
```

The normalized datum form `{"t":"rat",...}` MUST continue to describe only a valid reduced non-integral Rational datum. It MUST NOT be overloaded to carry an unreduced source pair. A fixture processor MUST NOT pass `construction` JSON through `decode-exact`, and the fixture metadata has no identity authority.

The shared fixture schema SHOULD identify this additive schema revision as `0.1`. Existing vectors without `construction` remain valid without modification.

### 8.3 Observable conformance consequence

Add at least:

- positive constructor normalization `2/4 -> Rational(1,2)`;
- positive integral normalization `2/2 -> Integer(1)`;
- positive zero normalization `0/7 -> Integer(0)`;
- negative constructor input `1/0 -> UnsupportedHostInput / ZeroDenominator / host-import`.

Both fixture adapters require support for the new metadata form. This is a harness/adapter patch, not a core wire-codec patch.

### 8.4 Compatibility

No canonical octet, abstract equality rule, or datum acceptance rule changes. The fixture language gains one non-datum construction descriptor. The datum-format version remains 0.

## 9. E0.1-8 — Record-key work accounting (A8)

### 9.1 Affected sections

This entry supplements Sections 14.3, 17.4, 20.3, 21.2, and 21.5.

### 9.2 Added normative language

For `max_total_record_key_octets`, the cost of one record key is the length in octets of that key's complete canonical Identifier `ValueBytes`:

```text
22 || UVAR(namespace-count) || Segments(namespace)
   || UVAR(path-count)      || Segments(path)
```

The document magic and format version are not included. The identifier tag, count UVARs, segment-length UVARs, and segment UTF-8 payloads are included.

The operation's total is the sum of that quantity once for every record-field occurrence encountered across the complete datum being imported or encoded. A normal runtime record contributes once per unique field. A hostile source field sequence contributes once for each supplied field key after that key has been successfully converted to an Identifier, even if a later check discovers a duplicate.

Sorting comparisons, comparison retries, cached-key lookups, and re-encoding performed as an implementation detail MUST NOT increment the normative total. The result is therefore independent of sorting algorithm, sorting stability, and internal record representation.

A hostile-host importer reports `ResourceRefusal / RecordKeyWorkBudgetExceeded / host-import`. Runtime `encode-exact` reports `ResourceRefusal / RecordKeyWorkBudgetExceeded / encode-ordering`.

### 9.3 Observable conformance consequence

The complete `ValueBytes` for `Id([], ["a"])` is five octets:

```text
22 00 01 01 61
```

A one-field record using that key MUST accept with `max_total_record_key_octets = 5` and refuse with the code above at `4`. A vector with multiple and nested records MUST verify operation-wide accumulation.

### 9.4 Compatibility

Canonical ordering, canonical octets, and equality do not change. Tight-budget host-import and runtime-encode behavior becomes fixed. Existing vectors under ample key-work budgets remain valid. No datum-format version changes.

## 10. E0.1-9 — Per-operation resource-budget jurisdiction (A9)

### 10.1 Affected sections

This entry supplements Sections 17.1, 17.4, 17.7, 21.2, 21.5, and 29.16.

### 10.2 Replacement for the first sentence of Section 21.2

Replace:

> Every decode and hostile-host import is governed by an immutable resource budget.

with:

> Every `decode-exact`, hostile-host import or public conformance constructor, and runtime `encode-exact` is governed by an immutable resource-budget object. Each operation MUST enforce exactly the fields assigned to it below and MUST ignore the other well-formed fields for refusal purposes.

### 10.3 Added per-operation table

| Budget field | `decode-exact` | Host import / public conformance construction | Runtime `encode-exact` of an already-valid datum |
|---|:---:|:---:|:---:|
| `max_input_octets` | enforce | ignore | ignore |
| `max_output_octets` | ignore | ignore | enforce |
| `max_varint_octets` | enforce | ignore | ignore |
| `max_integer_bits` | enforce | enforce | ignore |
| `max_depth` | enforce | enforce | ignore |
| `max_nodes` | enforce | enforce | ignore |
| `max_sequence_items` | enforce | enforce | ignore |
| `max_record_fields` | enforce | enforce | ignore |
| `max_identifier_segments` | enforce | enforce | ignore |
| `max_segment_octets` | enforce | enforce | ignore |
| `max_single_string_octets` | enforce | enforce | ignore |
| `max_single_bytes_octets` | enforce | enforce | ignore |
| `max_aggregate_payload_octets` | enforce | enforce | ignore |
| `max_total_record_key_octets` | ignore | enforce | enforce |

All three operations remain subject to actual host allocation refusal. Host-specific stack, address-space, or allocation ceilings MUST surface as `ResourceRefusal / AllocationRefused / allocation`, not as a fabricated deterministic structural-budget failure.

`decode-exact` need not sort keys because canonical byte order is verified in place; therefore it does not enforce record-key sorting-work budget. A hostile importer may need to construct and order keys, so it enforces all applicable structural import limits and record-key work. Runtime encoding receives a datum already admitted into the immutable algebra; reapplying import/decode structural limits would make refusal depend on an unrelated prior budget and would not remove the already-resident structure. Runtime encoding therefore enforces only complete-output size and canonical-key ordering work.

An implementation MAY expose separate operation-specific budget types or one shared record. If it exposes one shared record, a small value in an ignored field MUST NOT change that operation's result. Implementations MUST still validate that supplied budget fields are representable nonnegative limits according to their API contract; this syntactic budget-object validation is outside datum equality and canonical bytes.

### 10.4 Observable conformance consequence

For the already-valid datum `Sequence([Unit])` and sufficient output/key-work limits:

```text
runtime encode with max_depth = 1 -> success
runtime encode with max_nodes = 1 -> success
canonical document              -> 4c50434400300100
```

The same canonical document under `decode-exact` with `max_depth = 1` MUST refuse `ExcessiveNesting / type-tag`; the same host construction under a host-import depth limit of `1` MUST refuse at `host-import`.

The Common Lisp codec reported by the audit must stop applying decode/import structural limits to runtime encoding. The Python runtime-encode behavior reported for these witnesses already matches this ruling. Again, this is selected from the operation boundary defined by the specification, not inherited from Python.

Shared vectors MUST also verify that:

- `decode-exact` ignores an artificially small `max_output_octets`;
- runtime `encode-exact` ignores small `max_input_octets`, `max_varint_octets`, `max_integer_bits`, `max_depth`, `max_nodes`, container, identifier, and payload fields;
- hostile-host import ignores `max_input_octets`, `max_output_octets`, and `max_varint_octets` but enforces its structural and key-work fields;
- insufficient `max_output_octets` still yields `ExcessiveOutputLength / allocation` atomically;
- insufficient runtime record-key work still yields `RecordKeyWorkBudgetExceeded / encode-ordering`.

### 10.5 Compatibility

Canonical bytes and abstract equality do not change. The set of valid abstract datums does not change. Runtime encode acceptance changes at the previously unspecified boundary: a valid datum may no longer be refused merely because a decode/import structural field in the shared budget object is tight. No datum-format version changes.

## 11. Conformance-vector promotion and validity

After this errata is adopted:

1. all A1 provisional-stage rows MUST be assigned the stages in E0.1-1 and compared as complete triples;
2. the depth and node fixture labels MUST be corrected to `type-tag` before promotion;
3. the A2 provisional-code row MUST be assigned `UnsupportedHostType` where it represents a wrong disjoint host family and compared as a complete triple;
4. new host-construction negatives MUST exercise E0.1-2;
5. tight boundary vectors MUST exercise E0.1-3 through E0.1-6 and E0.1-8;
6. the A7 construction descriptor MUST be exercised without treating it as a datum AST;
7. runtime-encode jurisdiction vectors MUST exercise E0.1-9 in both directions.

Existing positive canonical hex vectors remain valid. Existing negative byte vectors remain valid except for the two erroneous expected `stage` labels identified above. No existing expected canonical octet string may be changed as part of this errata implementation.

## 12. Format and identity receipt

```text
errata:                         CANONICAL-DATUM-SPEC-ERRATA-0.1
base-spec-sha256:               d578e86e4d411611b091cca0bed1cafac2636c0908e95447fd4a13badcab6abc
abstract-algebra-changed:       no
abstract-equality-changed:      no
canonical-octet-grammar-changed:no
existing-canonical-octets-changed:no
accepted-canonical-documents-changed:no
failure-semantics-changed:      yes, narrowly as E0.1-1 through E0.1-9
fixture-metadata-schema-changed:yes, additive construction descriptor
format-version-before:          0
format-version-after:           0
new-privileged-value-path:      no
located-claim-semantics-changed:no
cryptographic-semantics-changed:no
```
