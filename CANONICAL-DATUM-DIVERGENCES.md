# Canonical Datum /0 divergences

This append-only ledger records specification gaps found during the independently seeded
Phase 0 executability review.  It does not amend
`mneme/spec/CANONICAL-DATUM-SPEC.md` (SHA-256
`d578e86e4d411611b091cca0bed1cafac2636c0908e95447fd4a13badcab6abc`).
No implementation comparison had occurred when A1--A9 were recorded.

## A1 — Failure stages are not mapped completely

- **Sections:** 20.1, 20.3, 20.4, 20.5; also 17.7.
- **Minimal bytes/datum:** `4c504344002002c3` (declared two-byte string
  payload with one byte present), `4c504344003001` (one sequence element
  declared and absent), and encoding Unit under `max_output_octets = 5`.
- **Competing interpretations:** `TruncatedInput` could use `length`, `utf8`, or
  `container-content` according to the parser state; `ExcessiveOutputLength`
  could use `allocation`, `container-content`, or an unlisted output stage.
- **Affected implementation path:** both decoders' failure adapters, encoder
  output refusal, and permanent negative fixtures.
- **Failing/blocked test:** `cd0-blocked-A1-stage-matrix` cannot assert the full
  normative triple.  The ambiguous truncation case is deliberately absent from
  `cd0-negative.jsonl`.
- **Proposed adjudication (non-normative):** add a context-sensitive code/stage
  matrix, including root/container payload truncation and output-length refusal.

## A2 — Constructor failures lack normative triples

- **Sections:** 7.2, 8.1, 8.3, 14.2, 17.1--17.2, 20.1--20.4.
- **Minimal datum/host input:** `Rational(1, 0)`, `Id([], [""])`, and a record
  constructor supplied the same identifier key twice.
- **Competing interpretations:** reuse byte-decoder codes such as
  `ZeroDenominator`, `EmptyIdentifierSegment`, and `DuplicateRecordField` under
  `InvalidCanonicalGrammar`; classify them as `UnsupportedHostInput`; or define
  constructor-specific failures.  No constructor stage is listed.
- **Affected implementation path:** public constructors and fixture-AST import.
- **Failing/blocked test:** `cd0-blocked-A2-constructor-failure-triples`.
- **Proposed adjudication (non-normative):** explicitly map each constructor
  invariant failure and add a `construction` stage (or normatively require
  `host-import` for all constructor failures).

## A3 — `max_integer_bits` has no exact bit-count rule

- **Sections:** 20.3, 20.5(6), 21.2, 21.4.
- **Minimal bytes/datum:** integer `-65`, document `4c50434400108101`, with
  `max_integer_bits = 7`.
- **Competing interpretations:** count `bit_length(abs(z))` (7, accept), count
  zigzag UVAR payload bits (8, refuse), or include a sign bit.
- **Affected implementation path:** integer and rational-component decode/encode
  budget checks.
- **Failing/blocked test:** `cd0-blocked-A3-integer-bit-count`.
- **Proposed adjudication (non-normative):** define the limit as
  `bit_length(abs(mathematical component))`, with zero consuming zero bits, and
  separately retain `max_varint_octets` for wire-work control.

## A4 — Identifier segment budget may be aggregate or per side

- **Sections:** 20.3, 21.2, 21.3.
- **Minimal bytes/datum:** `Id(["n"], ["p"])`, document
  `4c504344002201016e010170`, under `max_identifier_segments = 1`.
- **Competing interpretations:** each namespace/path count may be at most one
  (accept), or their combined segment count may be at most one (refuse).
- **Affected implementation path:** identifier construction, decoding, and host
  import budgets.
- **Failing/blocked test:** `cd0-blocked-A4-identifier-segment-total`.
- **Proposed adjudication (non-normative):** state explicitly that the budget is
  aggregate across namespace and path, checking safely before addition.

## A5 — Simultaneous resource breaches have incomplete precedence

- **Sections:** 20.5(5--7), 21.3--21.5.
- **Minimal bytes/datum:** sequence `[Unit]`, `4c50434400300100`, with both
  `max_depth = 1` and `max_nodes = 1`; or a two-byte string with both
  `max_single_string_octets = 1` and `max_aggregate_payload_octets = 1`.
- **Competing interpretations:** depth before nodes or nodes before depth;
  single-payload length before aggregate payload or the reverse.
- **Affected implementation path:** deterministic resource failure selection.
- **Failing/blocked test:** `cd0-blocked-A5-resource-tie-breaks`.
- **Proposed adjudication (non-normative):** add explicit tie-break order: depth,
  nodes, context-specific count/length, then aggregate payload.

## A6 — Non-identifier record keys conflict with tag failures

- **Sections:** 15.3, 15.10, 18.5, 20.3, 20.5(9--11).
- **Minimal bytes/datum:** `4c504344003101f0` and
  `4c50434400310103` (one record field whose key begins with a forbidden or
  reserved tag).
- **Competing interpretations:** fail immediately with `RecordKeyNotIdentifier`,
  or parse the nested tag and return `ForbiddenPrivilegedTag` /
  `ReservedTypeTag`.
- **Affected implementation path:** record-key parser and security telemetry.
- **Failing/blocked test:** `cd0-blocked-A6-record-key-tag-precedence`.
- **Proposed adjudication (non-normative):** specify a dedicated one-octet key-tag
  gate and its precedence; prefer `ForbiddenPrivilegedTag` for `f0..ff`, then
  `RecordKeyNotIdentifier` for every other non-`22` tag.

## A7 — Fixture AST has no rational-construction form

- **Sections:** 8.3, 27.2, 27.3.
- **Minimal datum/fixture:** source rational pair `2/4`, expected normalized datum
  `{"t":"rat","p":"1","q":"2"}`.
- **Competing interpretations:** place unreduced `2/4` in the `rat` AST even
  though that is not an abstract datum, or add a separate constructor descriptor
  that Section 27.2 does not define.
- **Affected implementation path:** constructor-normalization fixtures and AST
  adapters.
- **Failing/blocked test:** `cd0-blocked-A7-rational-construction-ast`.
- **Proposed adjudication (non-normative):** retain `abstract` as the normalized
  datum and standardize a separate `construction` object such as
  `{"op":"rational","p":"2","q":"4"}`.

## A8 — Record-key work octets are not counted exactly

- **Sections:** 14.3, 17.4, 20.3, 21.2, 21.5.
- **Minimal datum/host input:** a one-field record keyed by `Id([], ["a"])`
  under `max_total_record_key_octets = 1`.
- **Competing interpretations:** count only the one UTF-8 payload octet; count
  segment framing; or count the complete five-octet identifier `ValueBytes`
  (`22 00 01 01 61`).  Sorting comparisons/re-reads may or may not count again.
- **Affected implementation path:** hostile record import and encoder ordering
  budgets.
- **Failing/blocked test:** `cd0-blocked-A8-key-work-accounting`.
- **Proposed adjudication (non-normative):** count each complete canonical
  identifier `ValueBytes` once after construction, independent of sort algorithm
  comparison count.

## A9 — Encoder use of non-output budgets is underspecified

- **Sections:** 17.1, 17.4, 17.7, 21.2, 21.5, 29.16.
- **Minimal datum/host input:** encode immutable sequence `[Unit]` with
  `max_depth = 1` but sufficient `max_output_octets`.
- **Competing interpretations:** all Section 21 limits govern `encode-exact`;
  only output and record-key-work limits govern already-valid runtime datums; or
  limits differ between runtime encoding and hostile host import.
- **Affected implementation path:** encoder budget accounting and cross-codec
  resource triples.
- **Failing/blocked test:** `cd0-blocked-A9-encoder-budget-surface`.
- **Proposed adjudication (non-normative):** specify separate immutable budget
  fields for decode, runtime encode, and host import, while retaining one shared
  object if desired; list exactly which fields each operation enforces.

## Phase 0 disposition

All unambiguous Section 15 vectors and compact negative cases continue to be
executable.  A1--A9 remain open and must not be resolved by copying behavior from
either seed implementation.  Proposed adjudications above are review material,
not CD/0 law.

## Phase 0 correction note — provisional fixture stages

An independent fixture audit confirmed the current compact inputs' categories
and primary codes but also showed that A1 reaches permanent hand rows.  The
following rows now carry `status: provisional-blocked-stage`; their recorded
stage is a testable proposal, not a normative adjudication:

- `cd0-neg-tag-20-string-truncated`
- `cd0-neg-tag-21-bytes-truncated`
- `cd0-neg-tag-22-id-truncated`
- `cd0-neg-tag-30-seq-truncated`
- `cd0-neg-tag-31-record-truncated`
- `cd0-neg-id-missing-path`
- `cd0-neg-id-empty-segment`
- `cd0-neg-record-key-not-id`
- `cd0-neg-resource-identifier-segments`
- `cd0-neg-resource-depth`
- `cd0-neg-resource-nodes`

`cd0-neg-host-bool-as-integer` similarly carries
`status: provisional-blocked-code` under A2: type disjointness and refusal are
normative, while the exact constructor/importer code is not uniquely assigned.
Differential conformance must compare only the warranted portions of these rows
until the specification is adjudicated.

## Phase 2 differential disposition — 2026-07-13

The first process-isolated hand-corpus comparison found no disagreement in the
22 positive rows, 71 negative dispositions, or complete 253-pair equality
matrix.  Additional boundary probes found seven permanent integration cases.
They do not amend A1--A9:

| Case | Minimal or compact witness | Classification | Disposition |
|---|---|---|---|
| rational numerator precedence | `4c504344001102`, `max_integer_bits=0` | Common Lisp defect | resolved from Section 20.5(6); both now return `ResourceRefusal/IntegerBudgetExceeded/rational-payload` |
| fixture negative zero | `{"t":"int","v":"-0"}` | fixture defect in both | refused; A2 still blocks a normative exact code |
| bounded decimal preflight | compact 5,000-digit decimal, eight-bit budget | host-import preflight defect in both | incremental refusal before an input-sized integer is built |
| ambient Python decimal guard | 641 digits with `PYTHONINTMAXSTRDIGITS=640` | Python host-assumption leak | both now succeed with identical bytes/AST under a sufficient budget |
| fixture bytes preflight | 4,096 declared zero octets, zero byte budget | Python defect | declared length refuses before hex conversion |
| deep exact decode | canonical depth-1,500 singleton sequence | Python host-assumption leak | raw recursion replaced by typed allocation refusal; Common Lisp success is allowed by host-allocation qualification |
| deep exact encode | depth-1,500 singleton sequence | Python defect with A9 boundary | raw recursion replaced by typed allocation refusal; encoder budget-surface disagreement remains A9 |

The permanent machine-readable cases are in
`canonical-datum/integration/cases/cd0-integration-regressions.json`.  Their
full input, budgets, competing per-host outcomes where applicable, specification
sections, and warranted fields are retained there.  Repairing these cases did
not make one codec imitate the other's unwarranted behavior.

## Errata 0.1 closure addendum — 2026-07-13

This addendum preserves A1--A9 above as the historical pre-adjudication record.
They are no longer open after adoption of:

- `CD0-POST-IMPLEMENTATION-RULING.md`, SHA-256
  `1a0e8ff844790c93e681f7541a23266aa73d2ee8e9ca9a6e0d753bf4e044b2bc`;
- `CANONICAL-DATUM-SPEC-ERRATA-0.1.md`, SHA-256
  `5f1568e53c4e6ef5fc8de2e125e7a6ef2d861392048c7ead144c7df05eb16271`.

The historical A2 witness was a genuine split: Common Lisp reported
`InvalidCanonicalGrammar/<specific-code>/host-import`, while Python reported
`UnsupportedHostInput/<specific-code>/host-import`.  Errata 0.1 selects the
Python-observed category because the operation is a host boundary, not because
either implementation was treated as specification authority.  The historical
A9 witness was likewise a genuine split: Common Lisp reapplied structural
budgets during runtime encoding, while Python enforced only output, record-key
work, and actual host allocation.  Errata 0.1 defines the latter operation
boundary on its own stated rationale.

| Entry | Normative closure | Permanent witness location | Format/equality effect |
|---|---|---|---|
| A1 | complete checkpoint-stage matrix; promised absent items use `count`; depth/nodes use `type-tag` | promoted 71-row manifest plus `cd0-errata-0.1.json` | none |
| A2 | host invariant failures use `UnsupportedHostInput/<specific-code>/host-import` | A2 host/construction cases | none |
| A3 | `bit_length(abs(component))`, zero is zero bits, supplied rationals checked before reduction | A3 boundary cases | none |
| A4 | namespace and path segments aggregate | A4 decode/import cases | none |
| A5 | depth, nodes, local, aggregate precedence | A5 simultaneous-breach cases | none |
| A6 | `f0..ff` retains privileged precedence in record-key position | A6 first-octet cases | none |
| A7 | construction metadata is distinct from normalized abstract datum metadata | three positive constructions plus A7 negative | none |
| A8 | complete Identifier `ValueBytes` once per field occurrence | A8 exact/nested/duplicate cases | none |
| A9 | per-operation resource jurisdiction; runtime encode enforces only output/key work/allocation | A9 isolated-operation cases | none |

The permanent additive manifest contains 37 complete operation cases spanning
A1--A9.  Phase-0 remains exactly 71 classified rows: 66 octet rows and 5 host
rows.  Python executes 71.  Common Lisp executes 68 and records exactly three
language-specific N/A dispositions.  N/A rows are neither passes nor failures;
the intended final disposition is recorded separately as executed rows, N/A,
failures, skips, and classified total.  The observed result is 0 failures and
0 skips.

No closure entry authorizes a canonical-octet, abstract-equality, accepted
document, datum-family, grammar, format-version, v1, or unrelated Mneme change.
