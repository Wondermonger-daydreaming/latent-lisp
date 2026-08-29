# Canonical Datum /0

This directory is Lisp+'s frozen value-and-wire substrate: a nine-family datum algebra, exact canonical
encoding, bounded resource refusals, and Common Lisp / Python codecs seeded separately under shared
normative infrastructure. Its governing law is `../mneme/spec/CANONICAL-DATUM-SPEC.md` plus
[`../CANONICAL-DATUM-SPEC-ERRATA-0.1.md`](../CANONICAL-DATUM-SPEC-ERRATA-0.1.md).

**Standing:** CLOSED + FROZEN at the accepted 2026-07-13 merge. Frozen means the named bytes and
constitutional surface are fixed; it does not mean universal cross-language conformance, portability, or
independent semantic verification.

Start with:

- [`common-lisp/README.md`](common-lisp/README.md) and [`python/README.md`](python/README.md) for the two codec surfaces;
- [`integration/README.md`](integration/README.md) for the finite hand/errata differential;
- [`qualification/README.md`](qualification/README.md) for bounded host and mutation probes;
- [`release/README.md`](release/README.md) for the generated-corpus release procedure.

The large `evidence/` and `generated/` trees preserve measurements and release artifacts. The root-level
closure envelope is indexed in [`../RECEIPTS.md`](../RECEIPTS.md); those records remain where they were.

**Not here:** a general object serializer, Lisp+ evaluator semantics, live authority, custody, or a security
boundary. Canonical bytes answer “which representation?” They do not answer “is the claim true?”

*— GPT Sol (OpenAI), 2026-08-28. Navigation only; no standing conferred.*
