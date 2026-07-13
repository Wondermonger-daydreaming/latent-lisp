# CD/0 Errata 0.1 implementation ledger

Date: 2026-07-13
Status: local implementation and verification complete; publication and targeted
independent review are recorded separately.  This ledger does not authorize or
claim a merge to `main`.

## Authority, provenance, and protected boundary

The implementation is governed by these exact bytes:

| Input | SHA-256 |
|---|---|
| `CD0-POST-IMPLEMENTATION-RULING.md` | `1a0e8ff844790c93e681f7541a23266aa73d2ee8e9ca9a6e0d753bf4e044b2bc` |
| `CANONICAL-DATUM-SPEC-ERRATA-0.1.md` | `5f1568e53c4e6ef5fc8de2e125e7a6ef2d861392048c7ead144c7df05eb16271` |
| `mneme/spec/CANONICAL-DATUM-SPEC.md` | `d578e86e4d411611b091cca0bed1cafac2636c0908e95447fd4a13badcab6abc` |

The immutable audited provenance anchors remain:

| State | Commit | Tree or role |
|---|---|---|
| Common Lisp audited tip | `45eb60ce5b80485a0b287feab53ed3b58643b1b0` | historical evidence-bearing tip |
| Python audited tip | `29d0946ad78347015b9f0c65a2f528f039fdca78` | historical evidence-bearing tip |
| Integration audited tip | `baeecd5e0347435b9e1362000344f46ea441c6ec` | tree `41d3a71c06692174701bfde8f071e7da1c719651` |
| Common Lisp seed | `e6f3b579742f5fcff0d82477d07f8c0c9ee34df3` | independence anchor |
| Python seed | `58ecca4083275ebfe16605765e575bfb9f6eb755` | independence anchor |

Independently seeded implementations under shared normative infrastructure,
with procedural—not OS-enforced—isolation, attested by the implementers and
corroborated at content tier.

The audited branch tips are seed-plus-bounded-correction states created after
differential cross-reading was authorized.  They are provenance anchors, but
they are not the independence anchors.  No audited tip was rewritten.

The release-evidence checkpoint before this documentation envelope is commit
`122ffa27b30d28b80c66a8b03c872f896ffd985a`, tree
`943b6592161507de69460a8282037c0399a2fe0e`.  The archive receipt identifies the
later documentation-complete source commit used to build the immutable archive.

No erratum authorizes a change to canonical bytes, abstract equality, accepted
documents, datum families, the wire grammar, the CD/0 format version, v1, or
unrelated Mneme semantics.  The retained compatibility gates observed zero such
changes.

## Test-first sequence

Red expectations were committed before semantic repair:

| Branch | Red-regression commit | Semantic repair commit |
|---|---|---|
| integration | `7a8c1be532da2a0dd3b13d281bdc84edfe26a1ca` | Common Lisp `9d7f8ad2ee3a124046d05538cd9ee23bbe561318`; Python `6a369f77511fbadb1e2c2c06953b6b27e66734d0` |
| Common Lisp successor | `7d7f7594260d16699f8175988c29df4dd811b990` | `82c8b8ae10a423df2e44fc15f4b2b0c8963e09a8` |
| Python successor | `c04d856499f1d7fed4cc67c56067d77e3122f566` | `679ef811c1cbb5b573f5517f43bd4a5e0a52a129` |

The audited Common Lisp A2/A9 witness was red before repair:

```text
A2-zero-denominator FAILURE InvalidCanonicalGrammar/ZeroDenominator/host-import
A2-empty-segment FAILURE InvalidCanonicalGrammar/EmptyIdentifierSegment/host-import
A2-missing-path FAILURE InvalidCanonicalGrammar/MissingIdentifierPath/host-import
A2-duplicate-field FAILURE InvalidCanonicalGrammar/DuplicateRecordField/host-import
A9-depth-one-runtime-encode FAILURE ResourceRefusal/ExcessiveNesting/type-tag
```

The audited Python witness already conformed on A2 and A9:

```text
A2-zero-denominator FAILURE UnsupportedHostInput/ZeroDenominator/host-import
A2-empty-segment FAILURE UnsupportedHostInput/EmptyIdentifierSegment/host-import
A2-missing-path FAILURE UnsupportedHostInput/MissingIdentifierPath/host-import
A2-duplicate-field FAILURE UnsupportedHostInput/DuplicateRecordField/host-import
A9-depth-one-runtime-encode OK 4c50434400300100
```

Both audited decoders had the A1 count-promised EOF stage mismatch:

```text
A1-sequence-promised-item FAILURE InvalidCanonicalGrammar/TruncatedInput/type-tag
A1-record-promised-key FAILURE InvalidCanonicalGrammar/TruncatedInput/record-key
A1-record-promised-value FAILURE InvalidCanonicalGrammar/TruncatedInput/type-tag
A1-identifier-promised-segment FAILURE InvalidCanonicalGrammar/TruncatedInput/length
```

After repair both implementations produce:

```text
A2-zero-denominator FAILURE UnsupportedHostInput/ZeroDenominator/host-import
A2-empty-segment FAILURE UnsupportedHostInput/EmptyIdentifierSegment/host-import
A2-missing-path FAILURE UnsupportedHostInput/MissingIdentifierPath/host-import
A2-duplicate-field FAILURE UnsupportedHostInput/DuplicateRecordField/host-import
A9-depth-one-runtime-encode OK 4c50434400300100
A1-sequence-promised-item FAILURE InvalidCanonicalGrammar/TruncatedInput/count
A1-record-promised-key FAILURE InvalidCanonicalGrammar/TruncatedInput/count
A1-record-promised-value FAILURE InvalidCanonicalGrammar/TruncatedInput/count
A1-identifier-promised-segment FAILURE InvalidCanonicalGrammar/TruncatedInput/count
```

The A9 success hex is the pre-existing canonical sequence `[Unit]`; the repair
changes only whether an already-valid datum is refused under an inapplicable
structural budget.

## A1–A9 closure matrix

“Changed” distinguishes observable codec/adapter behavior from additions to
tests or comments.  Every row changed shared vectors because each ruling is now
represented in the permanent 37-operation manifest.  The final two columns are
the protected hard-stop columns.

| Erratum | Affected implementation/evidence files | Old failing or blocked witness | New result | Common Lisp changed? | Python changed? | Vectors changed? | Canonical bytes changed? | v1 changed? |
|---|---|---|---|---|---|---|---|---|
| A1 | `common-lisp/cd0.lisp`, `python/cd0/__init__.py`, both suites, negative fixtures, integration adapters | count-promised sequence/record/identifier EOF reported `type-tag`, `record-key`, or `length`; depth/node fixtures used the wrong checkpoint label | promised absent item/segment/key/value is `InvalidCanonicalGrammar/TruncatedInput/count`; depth and nodes are `ResourceRefusal/<specific>/type-tag`; output refusal remains `allocation` | yes, decoder stage routing | yes, decoder stage routing | yes, 6 promoted operations plus corrected Phase-0 expectations | no | no |
| A2 | `common-lisp/cd0.lisp`, both suites, host fixtures/adapters | Common Lisp constructors returned `InvalidCanonicalGrammar/<specific>/host-import`; Python already returned `UnsupportedHostInput` | all declared constructor/importer invariant failures return `UnsupportedHostInput/<specific>/host-import` | yes, category only | no codec behavior change; conformance witnesses added | yes, 5 promoted operations and provisional row promoted | no | no |
| A3 | `common-lisp/cd0.lisp`, rational construction adapters, both suites | exact magnitude rule and pre-reduction rational construction check were blocked; Common Lisp normalized before checking supplied components | `bit_length(abs(component))`; zero uses zero bits; supplied rational components are checked before sign normalization/GCD reduction | yes, supplied rational precheck | yes, new construction adapter applies the required precheck; existing integer/decoder behavior was already conforming | yes, 6 promoted operations | no | no |
| A4 | both suites/adapters, generator, promoted vectors | aggregate namespace-plus-path interpretation was non-normative | combined namespace and path segment count is enforced on decode/import; limit 1 refuses `Id(["n"],["p"])`, limit 2 accepts | no observable codec change; existing aggregate behavior retained | no observable codec change; existing aggregate behavior retained | yes, 3 promoted operations | no | no |
| A5 | both suites, corrected Phase-0 stages, generator/qualification | simultaneous resource breach order was unspecified | deterministic order is depth, nodes, local magnitude/count/length, aggregate payload | no observable codec change; existing order retained | no observable codec change; existing order retained | yes, 3 promoted operations | no | no |
| A6 | both suites/adapters and promoted vectors | record-key tag precedence was blocked | `f0..ff` retains `PrivilegedRestorationAttempt/ForbiddenPrivilegedTag/type-tag`; other non-Identifier tags use `RecordKeyNotIdentifier/record-key` | no observable codec change | no observable codec change | yes, 2 promoted operations | no | no |
| A7 | fixture schema, `datum-from-fixture-construction`, `from_fixture_construction`, both suites, positive vectors | unreduced rational source could not be represented without pretending it was a normalized abstract datum | closed `{"op":"rational","p":"…","q":"…"}` construction descriptor is distinct from normalized abstract fixture AST | yes, new fixture-construction adapter | yes, new fixture-construction adapter | yes, 1 promoted failure plus 3 positive construction rows | no | no |
| A8 | both suites/adapters, generator/qualification and promoted vectors | key-work operand and sort-comparison multiplicity were blocked | each complete canonical Identifier `ValueBytes` is counted exactly once per field occurrence, globally per operation | no observable codec change; retained algorithm-independent accounting | no observable codec change; retained algorithm-independent accounting | yes, 6 promoted operations | no | no |
| A9 | `common-lisp/cd0.lisp`, both suites/adapters, qualification and promoted vectors | Common Lisp runtime encoding reapplied depth/nodes/varint/integer/segment/count/aggregate limits; Python did not | runtime encoding of an already-valid datum enforces output size, record-key work, and actual host allocation only; decode/import limits remain operation-specific | yes, structural encoder refusals removed | no codec behavior change; existing jurisdiction retained | yes, 5 promoted operations | no | no |

Promoted-operation arithmetic is A1=6, A2=5, A3=6, A4=3, A5=3, A6=2,
A7=1, A8=6, and A9=5, for 37 classified operations.  These operations are a
separate class and do not alter the 71-row Phase-0 total.

## Shared fixture and accounting changes

| Artifact | Result |
|---|---|
| `canonical-datum/vectors/cd0-positive.jsonl` | 25 rows; three rational construction rows added; SHA-256 `34fe63302e686efc0bcf1b1d841dbc5392c7f5abae393390eca40680179492b4` |
| `canonical-datum/vectors/cd0-negative.jsonl` | exactly 71 classified rows; A1/A2 expectations promoted; SHA-256 `d491d83e8b27d3224567f1948e90b92db2ea02689c464fe6144c69bb2cb851a6` |
| `canonical-datum/schema/cd0-fixtures.schema.json` | construction descriptor separated from normalized datum; SHA-256 `6609a6d97140f1fda5a538ccb908bb820bcdad380b7dd8efb05fa8a9e7a0407c` |
| `canonical-datum/vectors/cd0-errata-0.1.json` | 37 A1–A9 operations; SHA-256 `55725e14e763075a8866be9da8be9f8647b5b06803e1fea6f661068d87651ddc` |

Phase-0 accounting is deliberately not reported as “71 tests passed”:

```text
classified total: 71 = 66 octet rows + 5 host rows
Python:            71 executed, 0 N/A, 0 failures, 0 skips
Common Lisp:       68 executed, 3 language-specific N/A,
                   0 failures, 0 skips
```

N/A rows are neither passes nor failures.  The closed Common Lisp N/A set is
`cd0-neg-host-ambiguous-identifier`, `cd0-neg-host-bool-as-integer`, and
`cd0-neg-host-privileged-value` because that seed does not expose the optional
importers those descriptors target.

## Changed source surface

The exact path-level and object-level diff is retained in the targeted packet.
The semantic and conformance source surface is:

- normative companions and closure: `.gitattributes`,
  `CD0-POST-IMPLEMENTATION-RULING.md`,
  `CANONICAL-DATUM-SPEC-ERRATA-0.1.md`, and
  `CANONICAL-DATUM-DIVERGENCES.md`;
- Common Lisp: `canonical-datum/common-lisp/{README.md,cd0.lisp,package.lisp,tests.lisp}`;
- Python: `canonical-datum/python/{README.md,cd0/__init__.py,tests/test_cd0.py}`;
- shared fixtures: `canonical-datum/schema/cd0-fixtures.schema.json`,
  `canonical-datum/vectors/{cd0-positive.jsonl,cd0-negative.jsonl,cd0-errata-0.1.json}`,
  and `canonical-datum/tools/verify_phase0.py`;
- hand differential: `canonical-datum/integration/{README.md,run_differential.py,common_lisp_adapter.lisp,python_adapter.py}`,
  `canonical-datum/integration/cases/cd0-integration-regressions.json`, and
  `canonical-datum/tools/compare_errata_hand_baseline.py`;
- generated corpus/release: generator, release runner, their READMEs/source-access
  notes/tests, the new `release-errata-0.1` corpus, and retained 50-batch evidence;
- qualification: qualification runner, probes' surrounding documentation/tests,
  and retained `errata-final-run` evidence;
- documentation integrity: the historical `PHASE0-VERIFICATION.md` forward
  pointer and the exact independence/seed provenance language in codec,
  integration, release, and qualification documentation.

Generated JSONL, response, stderr, and summary artifacts are evidence outputs,
not additional semantic source.  `git diff --name-status` from the audited
integration tip to the archive source commit is included verbatim in the
targeted review packet; the bundle in that packet carries the exact object diff.

## Protected-invariant result

The release runner hard-compared all 10,000 valid generated rows against the
audited `release-v0` projection:

```text
canonical_octet_changes: 0
abstract_datum_changes:  0
decoded_ast_changes:     0
equality_class_changes:  0
```

The historical hand-corpus comparator also found zero response changes for the
22 historical positives, 71 historical negative dispositions, 253 historical
equality judgments, and seven integration regressions.  Additions were three
rational-construction positives, 72 additional equality judgments induced by
the 25-row positive matrix, and 37 separately classified errata operations.

`git diff` reports no change under `mneme/` from the audited integration tip,
and `mneme/verify-all.sh` reports all six v1 floors green.  No new divergence or
unexpected ambiguity was observed; consequently no affected path was stopped
and no `CD0-ERRATA-DIVERGENCES.md` entry was required.

This is a conformance-repair ledger.  It does not treat canonical identity as
truth or authority and makes no claim about located-claim identity, warrants,
capabilities, receipts, modules, effects, cryptography, custody, or lineage.
