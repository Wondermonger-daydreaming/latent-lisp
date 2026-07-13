# Lisp+ Canonical Datum /0 — Common Lisp seed

This directory is the dependency-free Common Lisp implementation of the
nine-family CD/0 algebra in `mneme/spec/CANONICAL-DATUM-SPEC.md`, as qualified by
`CANONICAL-DATUM-SPEC-ERRATA-0.1.md`. It neither loads nor modifies the v1
runtime. SBCL 2.4.6 is the seed qualification host.

“Independently seeded implementations under shared normative infrastructure,
with procedural—not OS-enforced—isolation, attested by the implementers and
corroborated at content tier.”

The Common Lisp independence anchor is seed commit
`e6f3b579742f5fcff0d82477d07f8c0c9ee34df3`, not this corrected branch tip.

## Interface

Load `package.lisp` followed by `cd0.lisp`.  The package
`LISP-PLUS-CD0` exports:

- explicit constructors and predicates for unit, boolean, integer, rational,
  string, bytes, identifier, sequence, and record datums;
- defensive accessors and read-only `octet-string` results;
- `equal-datum`, `encode-exact`, `canonical-octets`, and `decode-exact`;
- immutable `resource-budget` values covering all Section 21 counters;
- the typed `cd0-failure` condition with stable category, code, and stage;
- `datum-from-fixture-ast` and `datum-to-fixture-ast` using string-keyed alists,
  plus the non-datum `datum-from-fixture-construction` metadata adapter;
- `render-diagnostic`, whose output is explicitly not an identity witness.

`encode-exact` returns an `octet-string` wrapper rather than a publicly mutable
Common Lisp vector.  `octets-ref` reads it and `octets-copy` makes an explicitly
mutable host copy.  `decode-exact` accepts either that wrapper or a host vector,
which it snapshots before parsing.  String, byte, identifier, sequence, and
record construction likewise snapshots every mutable source component.

Fixture AST objects are alists such as `(("t" . "int") ("v" . "1"))`.
Within the explicitly typed boolean node, host `T` and `NIL` denote true and
false.  There is no generic NIL importer and no host-symbol-to-identifier
mapping.

Run the independent seed suite from the worktree root:

```text
sbcl --noinform --disable-debugger --script canonical-datum/common-lisp/run-tests.lisp
```

The harness contains a data-only JSON parser and reads the shared JSONL vectors
directly.  It performs no Common Lisp reader evaluation on fixture content.

## Errata 0.1 closure

A1--A9 are closed normatively by Errata 0.1. The codec compares complete
failure triples, classifies constructor/importer invariant failures as
`UnsupportedHostInput` at `host-import`, uses aggregate identifier-segment and
operation-wide record-key-work accounting, and implements the specified
resource precedence. Rational construction metadata is kept distinct from the
normalized datum AST. Runtime encoding of an already-valid datum enforces only
output size and record-key work, in addition to actual host allocation limits;
decode and host-import structural budgets retain their existing jurisdiction.

## Integration conformance corrections (2026-07-13)

The integration hardening checkpoint kept the public API stable while adding
four specification-derived corrections:

- rational decode applies `max_integer_bits` to a complete minimal numerator
  UVAR before reading its denominator, as required by Section 20.5(6);
- fixture decimal components reject canonical-schema negative zero and enforce
  `max_integer_bits` incrementally at the explicit `host-import` stage;
- `equal-datum` uses an explicit worklist, preserving the nine disjoint
  structural cases without consuming host control-stack depth per datum level;
- host sequence, identifier, fixture-object, and record import paths preflight
  applicable count, aggregate-segment, schema-field, and record-key-work bounds
  before avoidable proportional copies or unreachable value traversal.

Permanent regression witnesses cover denominator truncation/overlong/varint
adjacencies, all fixture integer/rational decimal positions, 20,000-level equal
and unequal values, and the importer preflight order.  The exact commands,
results, and residual boundaries are recorded in
`canonical-datum/evidence/COMMON-LISP-INTEGRATION-FIX-VERIFICATION.md`.

## Representation and security boundary

Runtime nodes are private classes with no public mutators.  Strings are retained
as validated private UTF-8 snapshots, bytes as private octet snapshots, and
containers as private vectors of immutable nodes.  Accessors either return
immutable datum references/scalars or defensive host copies.

Decoding recognizes only the fixed CD/0 grammar.  It performs no generic object
deserialization, symbol interning, package resolution, module loading, registry
lookup, evaluator transition, or I/O.  Capability-, warrant-, claim-,
certificate-, authority-, and receipt-shaped records remain ordinary records.
Canonicalization establishes stable inert structure and bytes, not truth,
authority, custody, authenticity, or verified lineage.
