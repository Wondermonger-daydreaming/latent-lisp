# LCI/0 Authorial Return — MigrationResult Classification Coupling

Date: 2026-07-14

Status: PROVISIONAL AUTHORIAL RETURN / CLASSIFICATION-CROSS-FIELD PATH BLOCKED

## Gap

LCI/0 §23.4 gives the eleven-field MigrationResult/0 shape, and Errata E9
defines the meaning of seven classification Identifiers. The registry freezes
five valid migration results and `migration.classification-map.0` (3,352
bytes, SHA-256
`685f33dfa7ec653aa9ee2ec924a91a4104f2bbcd9d99898ac97215f4ce4ab693`).

It does not freeze a closed MigrationResult schema with classification-specific
cross-field checks. In particular, no machine rule says which combinations of
`claim`, `claim-id`, `lineage`, `represented-loss`, `legacy-testimony`, and
`live-warrants-created` are legal for each classification.

`LCI0-N028` pins only one direction: a lossy classification without required
represented loss fails with `RepresentedLossRequired`. It does not define an
inverse or complete classification/result matrix.

## Minimal mutation witness

The valid `migration-result.inert-predecessor` is 31,123 bytes, SHA-256
`52e3082b19db7cf38bcc0f0ad93a11cf9397917c881f764584544d328eebb57a`,
and classifies the inert predecessor relation as
`privileged-runtime-relation-outside-claim-id`.

Replace only `classification` with the registered
`exact-after-explicit-tagging` Identifier (86 bytes, SHA-256
`d8909cb03e910b2eb9e312c92a4b1eb3886d5fba03a28dded10f7739a7dedfdb`).
The resulting canonical document is 31,107 bytes with SHA-256
`565494e413cb849836d922b3ae6455c771f2f7f2c0a31ac4b30d9991ccee3726`.
Every other field, including inert testimony, represented loss, and
`live-warrants-created=false`, is unchanged.

The base result and replacement Identifier are machine-pinned registry
documents. The mutated hash is coordinator-constructed by one field
replacement and frozen CD/0 re-encoding; independent Common Lisp
reconstruction remains PENDING and it is not a package expected result.

The Common Lisp validator snapshot inspected during preliminary review
accepted this mutation because it checked only Identifier shape plus selected
loss-presence implications. The Python vector-operation snapshot at that
review point unconditionally emitted the N028 failure and therefore did not
perform generic MigrationResult validation. These are non-commit-bound defect
observations; successor verification remains PENDING and neither is an oracle.

The classification meanings strongly indicate that classification must be
coupled to content, but the package does not pin the complete coupling or a new
`InvalidMigrationResult` category/code/stage/path for this witness. This relay
therefore does not infer an inverse matrix from the five positive documents.

## Requested authorial closure

Please provide:

1. a closed MigrationResult schema and declared cross-field-check order;
2. a total allowed/required field-content rule for each of the seven
   classifications;
3. the exact failure document for the mutation above; and
4. single-fault vectors for each prohibited classification/content pairing.

The novel classification-coupling path is BLOCKED. `LCI0-N028` and the five
unchanged valid results retain their existing standing.
