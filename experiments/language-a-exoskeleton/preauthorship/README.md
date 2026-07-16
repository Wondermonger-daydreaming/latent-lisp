# Pre-authorship repair boundary

This successor closes the technical FI-01 and FI-05 defects needed for a later
owner adoption. It does not itself authorize substantive item drafting. The
executable drafting gate remains closed until both `ODR-43` and `ODR-60` have
typed, digest-valid `adopted` successors with real owner decisions, rationales,
deciding actors, shared-root disclosures, timestamps, and exact gate effects.

The current authorization ceiling is `candidate`. A `draft` or `candidate`
record cannot be consumed by the runner, schedule, scoring key, exposure
manifest, or key-author handoff. The typed refusal is
`DraftItemUsedAsFrozen`. Neither a filename, a directory named `frozen`, a
status string, nor a Boolean changes record state. This tranche creates no real
item, source packet, rendering, witness, answer, opportunity, score key, or
branch receipt.

## Canonical record identity

Every versioned record carries a stable ID, schema version, actor/declarant,
offset timestamp, exact parent versions, bounded unknowns, canonical byte
length, and SHA-256. `record_digest` is computed over UTF-8 canonical JSON with
sorted keys, compact separators, `ensure_ascii` disabled, and exactly one
terminal LF after removing only the two derived members, `record_digest` and
`canonical_byte_length`. The committed golden vector under
`controls/canonicalization-golden/` lets an external replayer test those exact
bytes before validating any other record. The validator
recomputes both fields. External content bindings separately name stable
artifact IDs, storage paths, media types, exact byte lengths, and SHA-256s;
paths are locations, never identities.

Lineage uses the same digest material. Every event after the first names the
exact predecessor record digest. Artifact parents and reads name exact artifact
event digests. Strict v2 transmission and handoff events require nonempty
artifact, basis, input, parent, and claim collections; sender, recipient,
authorization, byte identity, and acknowledged or explicitly pending receipt
closure. The legacy empty v1 transmission remains preserved as a failed
predecessor and is closed only by an appended correction plus a strict v2
successor. Corrections and successors preserve their superseded events; the
reviewed lineage files remain unchanged and are inventoried beside the
successor ledger.

## Two-artifact authorship boundary

`ITEM-FREEZER-DOSSIER` is freezer-only. Its schema may contain proposed role
membership, expected-answer artifacts, proposed opportunities and trap classes,
catchability witnesses, lawful/failing examples, ancestry and exposure
deliberation, and overlap review.

`KEY-AUTHOR-INPUT` is the only future key-author input. It must equal—not merely
be a subset of—the authorized set in a referenced frozen-bank manifest. Its
closed entry enum
allows only frozen item/task/rendering bytes, exact source manifests and source
components, controlling scoring doctrine, authority identities, and neutral
custody receipts. It rejects dossiers, item-author roles, expected answers,
opportunities, trap labels, witnesses, examples, synthetic outcomes, schedules,
and grader material. Each permitted public kind closes to its dedicated record
schema and exact byte binding, so relabeling private data as doctrine or
authority metadata also fails. It rejects any moving-bank item or source version.
The current repository contains no real instance of either artifact. Synthetic
state-transition and frozen-bank fixtures remain permanently tainted and obey
the same decision, predecessor, actor/authority, source, rendering, version,
and receipt rules as a future real record.

## Owner adoption and allocation boundary

The byte-identical unresolved ODR-43 and ODR-60 records remain immutable.
Future adoption requires separate successor IDs, exact predecessor-record
digests, preserved predecessors, strict owner-adoption events, owner
jurisdiction, exact decision-payload and gate closure, and resolved actor,
read, exposure, and shared-root graphs. Status editing cannot satisfy the
drafting gate.

`ODR-60-CANDIDATE-ALLOCATION-0.2.json` is an unresolved 24-row candidate bound
to the adopted Repair 0.2 commission. It stores no totals; family, role, and tag
cardinalities are derived from the rows on every validation. It adopts no owner
decision and authorizes no item drafting.

## Construct-validity capacity and deferral

The owner-supplied anti-taxidermy note is tracked as reviewed design input, not
promoted to authority. The schema bundle now has future-only private opportunity
provenance, hierarchical keyed units, orthogonal structural-validity and
substantive-discharge axes, differential truncation position, a non-compensating
anti-taxidermy profile, and mandatory future receipt-rider capacity. A missing,
zero, or not-applicable opportunity cannot default to perfect completeness;
zero and not-applicable branches each require their own explicit justification.

TXD-01 through TXD-10 are committed only as identity records in a permanently
tainted synthetic-specimen registry. They cannot enter a target bank,
`KEY-AUTHOR-INPUT`, a private key, grader calibration, or held-out material.

Incorporated now: schema capacity, taint registry, provenance hooks, and
orthogonal validity axes.

Deferred to freeze-quality repair: scoring implementation, specimen behavior,
thresholds, substantive-content adjudication, precision study, and branch
receipt riders. Schema adequacy does not establish construct validity.

## Verification surfaces

- `schemas/preauthorship.schema.json` — strict Draft 2020-12 schema bundle;
- `harness/preauthorship.py` — byte, schema, reference, state, handoff, owner,
  lineage, taint, and mutation validation;
- `controls/preauthorship-mutations.json` — declared mutations; declaration and
  executable-handler sets must match exactly;
- `lineage/successor/events.jsonl` — repaired append-only construction lineage;
- `operator/owner-decisions/` — typed unresolved ODR-43 and ODR-60 records;
- `preauthorship/registries/` — permanent taint and synthetic specimen identities;
- `preauthorship/deferred/` — explicit freeze-quality deferral boundary.

`CONSTRUCTION-MANIFEST.json` is the successor construction manifest. The
reviewed `FREEZE-MANIFEST.*` bytes are retained as historical evidence and do
not freeze or promote the successor.
