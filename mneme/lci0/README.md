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

## Current implementation status

The Common Lisp and Python successors converge on every implementation-owned
path exercised by the frozen package and the seeded post-convergence harness.
The exact sweep reproduces 1,593/1,593 embedded CD/0 documents in each
language and obtains identical determinate results for 211/215 vectors. Four
vectors, 38 relation companion paths, and eight hostile result tuples remain
explicitly blocked because the frozen authorial materials do not pin a unique
complete result. They are not counted as passes, failures, skips, or N/A.

Accordingly, the bounded disposition is: unaffected implementation and
evidence are ready for independent audit; overall LCI/0 conformance remains
blocked pending authorial closure. This is not a merge-eligibility claim.

Start with:

- `evidence/LCI0-FABLE-IMPLEMENTATION-RELAY.md` for the paste-ready relay;
- `evidence/LCI0-CORRECTION-VERIFICATION-AUDIT.md` for the fresh,
  scope-limited audit of the six corrected defect families;
- `evidence/LCI0-FINAL-VERIFICATION-TRANSCRIPT.md` for commands and counts;
- `evidence/LCI0-IMPLEMENTATION-DIVERGENCES.md` for the append-only divergence
  record and ten authorial-return packets; and
- `differential/POST-CONVERGENCE-HARNESS.md` for replay instructions.
