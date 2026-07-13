# CD/0 Python implementation

This directory contains the dependency-free CPython codec for Lisp+ Canonical
Datum /0 plus Errata 0.1. Its semantic inputs are the pinned repository copy of
`mneme/spec/CANONICAL-DATUM-SPEC.md` and the companion errata; it does not
import or adapt the v1 kernel.

“Independently seeded implementations under shared normative infrastructure, with procedural—not OS-enforced—isolation, attested by the implementers and corroborated at content tier.”

The Python independence anchor is seed commit
`58ecca4083275ebfe16605765e575bfb9f6eb755`, not this corrected branch tip.
The audited tip contains the seed plus bounded corrections authored after
cross-reading was authorized and then backported; it remains provenance, not an
independent-seed anchor.

## Surface

The `cd0` package exports:

- explicit constructors for Unit, Boolean, Integer, Rational, String,
  ByteString, Identifier, Sequence, and Record;
- `equal_datum`, `encode_exact`, and `decode_exact`;
- frozen `ResourceBudget` values and typed `CD0Failure` exceptions;
- `from_fixture_ast` and `to_fixture_ast` for the shared typed fixture form,
  plus `from_fixture_construction` for the distinct rational-construction
  descriptor;
- `import_host_descriptor` for the closed Section-28.2 conformance descriptors
  (this is not a generic object deserializer);
- `diagnostic_render`, which is explicitly non-identity-bearing.

Successful datums use frozen, slotted dataclasses whose observable leaves and
views are Python `str`, `bytes`, and tuples.  Mutable byte buffers and collection
inputs are snapshotted.  `bool` is rejected by the integer constructor.  Record
constructors accept explicit key/value sequences, reject duplicates, and sort by
complete canonical identifier value bytes.  Exact decoding is a dedicated byte
parser and returns only those nine inert types.

The integration hardening pass keeps Python host limits outside datum identity:

- `equal_datum` and `to_fixture_ast` use explicit worklists, so deeply nested
  valid runtime values do not depend on Python call-stack depth;
- recursive encode/decode and fixture/descriptor import translate host stack or
  allocation exhaustion to `ResourceRefusal/AllocationRefused/allocation`
  instead of leaking `RecursionError`;
- fixture decimal parsing and formatting are manual and bounded, reject the
  schema-forbidden spelling `-0`, and do not depend on
  `sys.set_int_max_str_digits`;
- fixture hex and list/tuple declarations are checked against their applicable
  budgets before proportional conversion or snapshotting.

Run the complete Python suite from the repository root:

```text
PYTHONPATH=canonical-datum/python python3 -m unittest discover -s canonical-datum/python/tests -v
```

The focused host-boundary regressions can be run with:

```text
PYTHONPATH=canonical-datum/python:canonical-datum/python/tests python3 -m unittest -v test_cd0.HostStackSafetyTests test_cd0.DecimalGuardTests test_cd0.HostImportPreallocationTests
```

## Errata 0.1 A1--A9 conformance

The post-implementation ruling and Errata 0.1 settle the following behavior.
Every failure below is compared as the complete category/code/stage triple.

| Adjudication | Implemented behavior |
|---|---|
| A1 | A declared count promising an absent item, field key/value, or identifier segment reports `InvalidCanonicalGrammar/TruncatedInput/count`. Root absence remains `type-tag`; an output-size refusal uses `allocation`. |
| A2 | Constructor/importer invariant failures use `UnsupportedHostInput`, the applicable specific code, and `host-import`. |
| A3 | `max_integer_bits` counts `bit_length(abs(component))`; zero consumes zero bits. The construction adapter checks supplied rational components before reduction. |
| A4 | `max_identifier_segments` aggregates namespace and path segments. |
| A5 | Resource precedence is depth, nodes, local magnitude/count/length, then aggregate payload. |
| A6 | A record-key tag in `f0..ff` reports `ForbiddenPrivilegedTag`; other non-`22` tags report `RecordKeyNotIdentifier`. |
| A7 | Rational construction uses a separate `{op,p,q}` descriptor; fixture `rat` remains an already-normalized abstract datum. |
| A8 | Key work counts each field occurrence's complete canonical Identifier `ValueBytes` exactly once. |
| A9 | Encoding an already-valid runtime datum enforces output size, record-key work, and actual host-allocation limits only. Decode and import retain their operation-specific admission budgets. |

## Bounded host guarantees

The immutability claim covers the supported Python API and ordinary mutation
operations.  CPython reflection can deliberately bypass a frozen dataclass via
`object.__setattr__`; the seed does not claim a Python object is a security
boundary against code already executing in the same interpreter.  The encoder
revalidates private invariants and returns `EncoderInvariantFailure` if a
tampered value is detected where practical.

The suite establishes finite conformance against 25 positive rows and the exact
Phase-0 accounting of 71 classified negative rows: 66 octet rows plus 5 host
rows. Python executes all 71 negative rows with complete triples; on the
recorded CPython 3.11.14 run there were 0 N/A dispositions, 0 failures, and 0
skips. The Common Lisp accounting is separate: 68 executed rows plus 3 explicit
language-specific N/A dispositions. N/A rows are neither successes nor
failures. The finite hand corpus does not by itself establish universal
cross-language conformance or replace the generated release qualification.
