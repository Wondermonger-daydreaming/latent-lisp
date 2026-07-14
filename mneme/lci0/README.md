# Lisp+ Located Claim Identity /0

This tree is the isolated LCI/0 implementation workspace authorized by the
Fable PASS receipt dated 2026-07-14. It does not modify CD/0 or production
Mneme/v1 behavior and does not implement live warrants, authority, standing,
cryptography, module identity, or live v1 migration.

The frozen fixture registry is 158 MB, so the repository tracks the exact
checksum-bound fixture ZIP rather than a regenerated or Git-hostile expanded
copy. Verify it and optionally materialize it with:

```text
python3 mneme/lci0/shared/fixture_package.py verify
python3 mneme/lci0/shared/fixture_package.py census
python3 mneme/lci0/shared/fixture_package.py materialize --destination /tmp/lci0-fixtures-2026-07-14
```

`spec/` contains exact, unedited copies of the normative and Fable review
documents. `fixtures/archives/` contains the frozen fixture package and PASS
packet. Language-specific adapters and implementations live in `common-lisp/`
and `python/`; cross-reading starts only after both seed commits exist.

The accurate independence statement is: independently seeded implementations
under shared normative infrastructure, with procedural—not OS-enforced—
isolation.
