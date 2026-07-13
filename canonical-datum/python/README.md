# CD/0 Python seed

This directory contains the dependency-free CPython seed codec for Lisp+
Canonical Datum /0.  Its semantic input is the pinned repository copy of
`mneme/spec/CANONICAL-DATUM-SPEC.md`; it does not import or adapt the v1 kernel.

## Surface

The `cd0` package exports:

- explicit constructors for Unit, Boolean, Integer, Rational, String,
  ByteString, Identifier, Sequence, and Record;
- `equal_datum`, `encode_exact`, and `decode_exact`;
- frozen `ResourceBudget` values and typed `CD0Failure` exceptions;
- `from_fixture_ast` and `to_fixture_ast` for the shared typed fixture form;
- `import_host_descriptor` for the closed Section-28.2 conformance descriptors
  (this is not a generic object deserializer);
- `diagnostic_render`, which is explicitly non-identity-bearing.

Successful datums use frozen, slotted dataclasses whose observable leaves and
views are Python `str`, `bytes`, and tuples.  Mutable byte buffers and collection
inputs are snapshotted.  `bool` is rejected by the integer constructor.  Record
constructors accept explicit key/value sequences, reject duplicates, and sort by
complete canonical identifier value bytes.  Exact decoding is a dedicated byte
parser and returns only those nine inert types.

Run the seed suite from the repository root:

```text
PYTHONPATH=canonical-datum/python python3 -m unittest discover -s canonical-datum/python/tests -v
```

## A1--A9 implementation-local choices

The root divergence ledger remains authoritative about what the specification
does not settle.  The choices below make this seed executable but are
non-normative and are not claimed as shared failure triples.

| Divergence | Python seed choice |
|---|---|
| A1 | A missing declared string/bytes/segment payload uses stage `length`; malformed complete payload uses `utf8`; a missing nested value tag uses `type-tag`; a missing record key uses `record-key`; encoder output refusal uses `allocation`. |
| A2 | Constructor invariant failures use category `UnsupportedHostInput`, the nearest existing code, and stage `host-import`. |
| A3 | `max_integer_bits` counts `bit_length(abs(z))`; zero uses zero bits. |
| A4 | `max_identifier_segments` is aggregate across namespace and path. |
| A5 | Depth refusal precedes node refusal.  A context-specific single-payload limit precedes aggregate payload refusal. |
| A6 | A record-key tag in `f0..ff` reports `ForbiddenPrivilegedTag`; every other non-`22` key tag reports `RecordKeyNotIdentifier`. |
| A7 | Fixture `rat` denotes only an already-normalized abstract Rational.  Unreduced constructor inputs are tested directly through `rational`, not smuggled into the fixture AST. |
| A8 | Key work counts each field's complete canonical identifier `ValueBytes` once and accumulates across the operation. |
| A9 | Encoding an already-valid runtime datum enforces `max_output_octets` and `max_total_record_key_octets`; decode and fixture-host import enforce their applicable structural and payload limits. |

## Bounded host guarantees

The immutability claim covers the supported Python API and ordinary mutation
operations.  CPython reflection can deliberately bypass a frozen dataclass via
`object.__setattr__`; the seed does not claim a Python object is a security
boundary against code already executing in the same interpreter.  The encoder
revalidates private invariants and returns `EncoderInvariantFailure` if a
tampered value is detected where practical.

The suite establishes finite conformance against the shared hand corpus and its
listed probes: 22 positives and 71 negatives at the seed checkpoint.  It
compares all three failure fields for the 59 normative negative rows, only
category/code for the 11 `provisional-blocked-stage` rows, and only
category/stage for the one `provisional-blocked-code` row.  This preserves the
A1/A2 boundary instead of laundering proposed fields into normative agreement.
It is not the Phase-3 generated 10,000/20,000 release corpus and contains no
cross-language differential result.
