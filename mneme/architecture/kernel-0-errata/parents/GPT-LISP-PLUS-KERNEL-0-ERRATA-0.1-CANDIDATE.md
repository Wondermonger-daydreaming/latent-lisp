# LISP-PLUS-KERNEL-0-ERRATA-0.1

**Status:** ADOPTION CANDIDATE — NOT GOVERNING until an explicit owner seal and filing act  
**Date:** 2026-07-18, America/Sao_Paulo  
**Scope:** compact closure of Kernel /0 implementation gaps 1–4; incorporation of adopted PJ0/AP0 semantics at their delegated boundaries; correction of the incomplete Appendix A.2 manifestation sketch  
**Amends:** `LISP-PLUS-KERNEL-0-SPEC.md`  
**Does not amend:** Canonical Datum /0 octets; PJ-S/0 grammar or PJ0 frame bytes; AP0 vector bytes; provider-specific law; Language-A factual classifications  
**Implementation consequence:** the existing pure-core implementation remains useful evidence for its previously declared subset, but its gap-1 singleton fixture and its incomplete manifestation/standing/procedure surfaces are not full post-erratum conformance evidence.

---

## 0. Governing basis and effect

Kernel /0 is already adopted and governing. Process Journal /0 and the repaired Adapter Protocol /0 are also adopted and governing in the exact scopes delegated to them by Kernel /0 §§27.1–27.2. The AP0 reissue expressly routes the Appendix A.2 mismatch back to this erratum lane rather than silently rewriting Kernel /0.

Upon adoption, this erratum governs over conflicting or incomplete language in:

- Kernel /0 §§7.3, 8.1, 15, 20.5, 20.7, 22, 23, 25.5, 25.6, 27.1, and 27.2;
- Kernel /0 Appendix A.1 and Appendix A.2;
- the implementation accommodations described as gaps 1–4 in `mneme/kernel0/README.md`.

This erratum adds no fifth outcome axis, no manifestation status, no new authority source, and no provider-specific meaning. It closes implementation ambiguity by assigning exact jurisdiction and exact refusal behavior.

Where this erratum references PJ0 or AP0 fields, PJ0 and AP0 continue to own their value spaces, canonical encodings, and conformance rules. Kernel /0 consumes those records semantically; it does not fork their byte law.

The four closures are:

1. a degenerate singleton is not a lawful `:bounded` alternative set, and the historical call-296 projection is not silently inflated into a complete concrete outcome;
2. Kernel §23 reconstruction exactness is discharged through the adopted PJ0 evidence protocol;
3. claim validation, integrity, and visibility receive minimum mechanically enforceable shapes sufficient for tests 43, 44, 47, and 48;
4. AP0 structural validation and Kernel semantic validation are distinct, typed stages joined by an explicit procedure-domain boundary.

---

## 1. Erratum E-K0-1 — bounded determinacy and the call-296 projection

### 1.1 Replacement for Kernel /0 §7.3

Replace the first sentence of Kernel /0 §7.3 with:

> `:bounded` determinacy MUST carry a finite, duplicate-free sequence of **at least two** named, mutually distinguishable alternatives. Each alternative MUST be a complete value in the domain of the proposition or outcome axis being qualified, or a durable identity resolving to such a complete value under the named procedure. A singleton is determinate if its sole value is established; if no finite complete alternative set can lawfully be named, the mode is `:indeterminate`.

Add:

**E-K0-1-DET-1.** A bounded alternatives list containing one element MUST be refused. The initial Kernel /0 condition is `standing-inflation`, carrying this requirement ID and the offending determinacy coordinate.

**E-K0-1-DET-2.** For an outcome axis, bare subfields are not complete alternatives. In particular, `:absent-after-completion` by itself is an absence-state atom, not a complete manifestation-axis alternative. A complete alternative is, for example, `(:absent :state :absent-after-completion)` or a durable identity resolving to a complete manifestation relation.

**E-K0-1-DET-3.** `:bounded` means the evidence licenses one member of the named set but does not establish which. It MUST NOT be used merely to memorialize unease, incomplete authorship, a pending review, or an omitted alternative set. Those cases are represented by `:indeterminate`, a bounded-unknown entry, or a non-constructible specification projection, as appropriate.

### 1.2 Call-296 projection status

Kernel /0 §22 and Architecture 0.1 §15.2 preserve the following historical architectural projection:

```lisp
(:execution
  (:value :indeterminate
   :determinacy :indeterminate))

(:manifestation
  (:value (:absent :state :absent-after-completion)
   :determinacy :bounded
   :evidence (...)))

(:effects
  (:value :bounded
   :determinacy :bounded
   :alternatives (:billed :not-billed)))

(:interpretation
  (:value :not-applicable
   :determinacy :determinate))
```

That quotation remains the canonical Architecture 0.1/E-1 projection and remains useful as the historical algebraic exhibit. It is **not**, by itself, a complete constructible Kernel /0 outcome record.

The omission of manifestation alternatives is not repaired by inventing a singleton. The gap is closed as follows:

**E-K0-1-C296-1.** The quoted call-296 form is a non-constructible projection fixture until the governing sealed projection/evidence act supplies either:

1. a lawful finite set of at least two complete manifestation-axis alternatives; or
2. evidence establishing one complete manifestation-axis value under a named procedure, in which case the concrete determinacy mode is `:determinate`; or
3. a finding that no lawful finite set is presently available, in which case the concrete determinacy mode is `:indeterminate`.

**E-K0-1-C296-2.** An implementation MUST NOT claim to construct the complete call-296 Kernel fixture by supplying:

```lisp
:alternatives (:absent-after-completion)
```

or:

```lisp
:alternatives
  ((:absent :state :absent-after-completion))
```

Both are degenerate singletons. The first also fails the complete-axis-value rule.

**E-K0-1-C296-3.** The existing pure-core `make-call-296-fixture` singleton is retained only as historical implementation evidence for the pre-erratum bounded claim described in `mneme/kernel0/README.md`. After adoption of this erratum, it MUST be renamed, quarantined, or changed so that no test report presents it as complete Kernel /0 conformance.

**E-K0-1-C296-4.** The Kernel test suite SHALL separate:

- the byte-identical historical call-296 projection;
- a **synthetic** bounded-manifestation algebra fixture whose vector packet names at least two complete legal alternatives and synthetic evidence identities;
- any later live Language-A classification, which remains outside Kernel authoring and inside its sealed factual lane.

No synthetic alternative may be described as a fact about the live call-296 record.

### 1.3 Required negative control

Plant a determinacy constructor accepting a singleton bounded list. The post-erratum suite MUST kill it under `E-K0-1-DET-1`.

This is a semantic repair, not pedantry with a ruler. A singleton “bounded uncertainty” is a determinate value wearing a false moustache.

---

## 2. Erratum E-K0-2 — exact reconstruction evidence under PJ0

Kernel /0 §23 requires every terminal row to be constructed, journaled, killed and reconstructed, and re-derived byte-identically where determinism is declared. Process Journal /0 now supplies the exact protocol that the pure-core arc correctly declined to invent.

### 2.1 Jurisdiction

PJ0 owns:

- PJ-S/0 parsing and canonical rendering;
- metadata and store identity;
- binary frame boundaries;
- payload, predecessor-frame, and frame digests;
- append idempotency by event identity;
- serialized writer behavior;
- declared durability receipts;
- maximal prefix-valid reading;
- torn-tail versus corruption classification;
- source-preserving salvage;
- merge-journal transformation receipts;
- reconstruction receipts and exact source-prefix coordinates.

Kernel /0 owns:

- event meaning and legal transitions;
- process, seat, attempt, request, exposure, and capability semantics;
- fold rules and outcome algebra;
- unsafe-retry and unresolved-effect law;
- claim origin and standing;
- whether a structurally valid event sequence is semantically lawful.

**E-K0-2-JUR-1.** PJ0 structural validity does not establish Kernel semantic validity. A complete, canonical PJ0 frame containing a Kernel-illegal transition remains part of the structurally valid byte prefix but MUST cause the requested lawful Kernel fold to refuse with the applicable Kernel condition. It MUST NOT be skipped, rewritten, or relabelled as a torn tail.

### 2.2 Meaning of the §23 evidence obligation

For each normative terminal row, the conformance packet MUST contain or deterministically derive an evidence bundle naming:

```lisp
(:kernel-pj0-fixture
  :fixture-id ...
  :kernel-row-id ...
  :source-store-id ...
  :source-prefix-coordinate
    (:terminal-ordinal ...
     :terminal-frame-digest ...
     :valid-byte-count ...)
  :event-ids (...)
  :canonical-event-payload-digests (...)
  :kill-point-id ...
  :expected-terminal-classification ...
  :fold-id ...
  :fold-version ...
  :expected-view-id ...
  :expected-view-digest ...
  :comparison-policy-id ...
  :expected-origin :reconstructed
  :required-conditions (...)
  :bounded-unknowns (...))
```

The exact durable rendering is PJ-S/0 under PJ0. The shape above is semantic.

**E-K0-2-RCN-1.** “Journaled” means that the event is present in a PJ0-valid committed frame, not merely retained in a Lisp object, cache, finalizer buffer, or operating-system write buffer.

**E-K0-2-RCN-2.** “Killed and reconstructed” means that the host process is interrupted at the named kill point, a fresh process validates the source journal from byte zero, selects the maximal valid prefix, performs the named Kernel fold, and emits a PJ0 reconstruction receipt.

**E-K0-2-RCN-3.** Before the reconstruction pass, finalizer products, indexes, caches, and snapshots MUST be deleted or made unavailable. Primary journal frames and metadata remain.

**E-K0-2-RCN-4.** The source journal MUST remain byte-identical throughout validation and reconstruction. A torn tail remains visible evidence. Recovery does not truncate it.

### 2.3 Byte-identity comparison

“Byte-identical where determinism is declared” has three distinct coordinates:

1. **Primary event identity.** Previously committed source frame bytes do not change.
2. **Semantic replay identity.** Canonical PJ-S/0 bytes of the re-derived deterministic view equal the frozen expected bytes under the named fold and comparison policy.
3. **Receipt-field identity.** Deterministic reconstruction-receipt fields equal the frozen expected fields. Explicit environment, implementation, operator, or host-evidence fields may vary only where the comparison policy names them as variable.

**E-K0-2-BYT-1.** Byte identity MUST NOT be demanded between a damaged source and a salvage destination, or between merge sources and a merge destination. PJ0 assigns those outputs new store identities and regenerated frame chains. Their abstract-event relation is proven by the transformation receipt, not by pretending the frame bytes should match.

**E-K0-2-BYT-2.** A test that compares only pretty-printed Lisp objects is insufficient. Canonical PJ-S/0 bytes or their exact digests are required.

### 2.4 Terminal classification

The Kernel/PJ0 joint suite MUST preserve PJ0’s distinction:

- incomplete final frame immediately after the valid prefix: `:torn-tail`;
- malformed complete frame, bad digest, bad predecessor, noncanonical payload, duplicate committed event identity, or nonterminal failure: interior corruption;
- no bytes after a complete frame, or an empty event file: `:valid-end`.

The reader does not scan forward for a plausible later header.

### 2.5 Gap-2 closure test

A post-erratum Kernel §23 row does not PASS until its PJ0 evidence bundle passes both:

1. PJ0 structural validation and crash classification; and
2. Kernel semantic fold and expected-view comparison.

Shape construction alone remains useful unit evidence and remains strictly weaker than §23 conformance.

---

## 3. Erratum E-K0-3 — minimum standing records

Architecture 0.1 makes origin, validation, integrity, visibility, and proposition-specific determinacy orthogonal. Kernel /0 tests 43, 44, 47, and 48 require mechanically enforceable surfaces rather than opaque lists.

This erratum adopts minimum semantic shapes. Libraries may add fields but may not weaken the required bindings or infer one facet from another.

### 3.1 Validation record

```lisp
(validation
  :value :unchecked|:checked|:verified|:refuted
  :subject-id ...
  :validator-id ...
  :procedure-id ...
  :procedure-version ...
  :scope ...
  :evidence (...)
  :bounded-unknowns (...))
```

Rules:

**E-K0-3-VAL-1.** `:verified` and `:refuted` require all fields shown above. `:evidence` MUST be non-empty. `:scope` MUST be explicit and non-empty. `:procedure-id` and `:procedure-version` identify the method under which the judgment is licensed.

**E-K0-3-VAL-2.** `:checked` requires subject, validator, procedure, version, and scope. Evidence MAY be empty only if the procedure explicitly defines a check whose result is the absence of a named defect and the record preserves the checked inputs.

**E-K0-3-VAL-3.** `:unchecked` does not require a validator or procedure, but it MUST still identify the subject and scope to which unchecked standing applies. It MUST NOT be emitted as a shortcut for missing evidence after somebody claims verification.

**E-K0-3-VAL-4.** Bare `:verified` or a `:verified` record missing validator, procedure, version, scope, or evidence signals `bare-validation-scope`.

### 3.2 Integrity record

```lisp
(integrity
  :value :open|:sealed
  :subject-id ...
  :procedure-id ...
  :procedure-version ...
  :scope ...
  :evidence (...)
  :bounded-unknowns (...))
```

Rules:

**E-K0-3-INT-1.** `:sealed` requires a named subject, procedure, version, scope, and non-empty evidence sufficient to identify the bytes, digest chain, signature, or other integrity relation asserted.

**E-K0-3-INT-2.** A seal establishes only the integrity proposition named by its procedure and scope. It MUST NOT create, copy, or upgrade a validation record.

**E-K0-3-INT-3.** A sealed claim with no validation record is sealed and unvalidated. An implementation MUST expose both facts rather than invent `:verified`.

### 3.3 Visibility record

```lisp
(visibility
  :value :published|:withheld|:redacted
  :subject-id ...
  :scope ...
  :basis ...
  :evidence (...)
  :bounded-unknowns (...))
```

Rules:

**E-K0-3-VIS-1.** `:published` requires an explicit, non-empty relational scope. Examples include a named public mirror, a named recipient, or an identified channel-policy domain. A global boolean `published-p` is nonconforming.

**E-K0-3-VIS-2.** `:withheld` and `:redacted` require scope and basis. Redaction additionally names or references the transformation receipt that produced the redacted object.

**E-K0-3-VIS-3.** Publication changes visibility and may record a publication effect. It does not create semantic validation, truth standing, observational origin, or integrity.

**E-K0-3-VIS-4.** Bare `:published` signals `bare-visibility-scope`.

### 3.4 No cross-facet constructors

**E-K0-3-ORTH-1.** No constructor for validation, integrity, or visibility may silently construct another standing facet.

**E-K0-3-ORTH-2.** Copying a claim or manifestation does not copy standing unless a named transformation receipt states what was preserved, reduced, or changed.

**E-K0-3-ORTH-3.** Origin remains independently represented. Verifying a reconstructed claim leaves origin `:reconstructed`; sealing an asserted claim leaves origin `:asserted`; publishing either leaves its origin and validation unchanged.

### 3.5 Required tests

Kernel /0 tests 43, 44, 47, and 48 are now executable as follows:

- **43 — seal does not imply verification:** construct a lawful `:sealed` integrity record over a subject with `:unchecked` or absent validation; verify no validation promotion occurs.
- **44 — publication does not imply truth:** construct a scoped `:published` visibility record over an unchecked asserted claim; verify origin and validation remain unchanged.
- **47 — bare published refused:** attempt to construct `:published` without scope; require `bare-visibility-scope`.
- **48 — bare verified refused:** omit any required `:verified` binding; require `bare-validation-scope`.

Each family requires a planted constructor that performs the forbidden implication. The suite must kill it.

---

## 4. Erratum E-K0-4 — structural versus semantic validation

AP0 §24.3 states the joint jurisdiction: structural AP0 validation and Kernel semantic validation are separate steps. This erratum makes the distinction mechanically visible to Kernel /0.

### 4.1 Procedure descriptor floor

Every parser, projection, validator, rubric, or policy that contributes an interpretation or standing judgment MUST resolve to a procedure descriptor containing at least:

```lisp
(procedure-descriptor
  :procedure-id ...
  :version ...
  :judgment-class :structural|:semantic
  :input-domain ...
  :result-vocabulary (...)
  :acting-principal-id ...
  :evidence-requirements (...)
  :bounded-unknowns (...))
```

**E-K0-4-PROC-1.** A single procedure identity/version has one `:judgment-class`. An implementation that performs both structural projection and semantic evaluation exposes two procedure identities or two separately versioned entry points joined by a transformation receipt. It MUST NOT use an ambiguous “validator” identity whose domain changes according to the caller’s hopes.

### 4.2 AP0 structural jurisdiction

A procedure with `:judgment-class :structural` may establish, under the governing AP0 descriptor and captured evidence:

- binary envelope custody and integrity;
- envelope grammar membership;
- selector or path application;
- decoding under a named parser;
- exhaustive absence-table membership;
- structural manifestation status:
  `:present`, `:present-empty`, `:present-invalid`,
  `:present-partial`, `:absent`, `:withheld`, or `:redacted`;
- payload identity or no-payload state;
- adapter identity;
- stream/chunk relation;
- projection receipt identity and output origin `:derived`;
- declared losses, bounded unknowns, and structural failure.

It may emit `:present-invalid` when bytes are present but undecodable under the named parser. It may establish that a subject field is structurally absent under the exhaustive mapping table.

It MUST NOT establish:

- truth or falsity of emitted content;
- answer quality;
- rubric acceptance or rejection;
- claim verification;
- effect settlement not licensed by separate evidence;
- provider billing from an estimate;
- any Language-A factual classification outside the sealed lane.

### 4.3 Kernel semantic jurisdiction

A procedure with `:judgment-class :semantic` may contribute a Kernel interpretation or validation only within its declared input domain and result vocabulary.

Kernel semantic validation checks at least:

- the closed execution, manifestation, effect, and interpretation algebras;
- per-axis determinacy;
- required payload, parser, producer, adapter, and stream relations;
- cross-axis invariants;
- effect/frontier and retry law;
- identity, authority, exposure, and standing law;
- interpretation-procedure domain;
- claim-validation and visibility scope;
- lawful process transitions during a requested fold.

**E-K0-4-SEM-1.** `:accepted` or `:rejected` requires:

1. a manifestation whose status is `:present` or `:present-empty`;
2. a named procedure descriptor with `:judgment-class :semantic`;
3. a domain admitting that manifestation kind and status;
4. evidence required by the procedure.

A structural parser or AP0 projection receipt is insufficient.

**E-K0-4-SEM-2.** Parser-valid, canonically decoded, structurally projected, captured, sealed, or published are not aliases for semantic acceptance.

**E-K0-4-SEM-3.** A `:present-invalid` manifestation preserves its payload and structural parser identity. It cannot receive ordinary Kernel interpretation `:accepted` or `:rejected` without a new lawful transformation that yields a manifestation inside the semantic procedure’s declared domain. Re-labelling the same invalid manifestation is standing inflation.

### 4.4 Joint execution and reporting

The lawful joint path is:

```text
captured bytes
→ PJ0/AP0 structural validation
→ AP0 structural projection
→ Kernel manifestation validation
→ Kernel outcome/process semantic validation
→ optional domain semantic procedure
→ claim/standing construction
```

**E-K0-4-JOINT-1.** If AP0 structural validation fails, no Kernel semantic acceptance is attempted. The AP0 condition and evidence coordinate are preserved.

**E-K0-4-JOINT-2.** If AP0 structural validation succeeds but Kernel outcome algebra fails, the joint report records:

- AP0 structural result: PASS;
- Kernel semantic result: FAIL;
- the exact Kernel condition and requirement ID.

The failure MUST NOT be rewritten as an AP0 parser defect.

**E-K0-4-JOINT-3.** If Kernel outcome algebra succeeds but no semantic domain procedure has run, interpretation remains `:not-attempted`, `:not-applicable`, or another lawfully evidenced non-acceptance value. It does not default to `:accepted`.

**E-K0-4-JOINT-4.** A divergence report preserves both stages. A one-bit green counter is insufficient evidence.

### 4.5 Gap-4 test 45

Kernel /0 test 45 is now complete when the suite demonstrates all of:

1. a structurally valid AP0 projection with a present payload;
2. no semantic procedure run;
3. semantic interpretation not promoted to `:accepted`;
4. a planted implementation that equates parser validity with acceptance;
5. the planted implementation rejected under `standing-inflation` carrying `E-K0-4-SEM-2`.

---

## 5. Erratum E-K0-A2 — replacement Appendix A.2 manifestation sketch

Replace Kernel /0 Appendix A.2 with the following semantic sketch:

```lisp
(manifestation
  :manifestation-id ...
  :attempt-id ...
  :kind ...
  :status
    :present|:present-empty|:present-invalid|:present-partial|
    :absent|:withheld|:redacted

  :payload-id ...          ; required for every :present* status
  :absence-state ...       ; required where the closed status mapping requires it
  :parser-id ...           ; required for :present-invalid
  :source-boundary ...

  :adapter-identity ...    ; required iff produced by an AP0 adapter
  :producer-identity ...   ; required iff produced outside AP0

  :stream-relation         ; required iff produced from a stream or chunk
    (:stream-id ...
     :chunk-record-ids (...)       ; non-empty, ordered by declared relation
     :projection-receipt-id ...)   ; required when output is derived from
                                   ; more than direct identity with one chunk

  :visibility (...))
```

The sketch is semantic, not a PJ-S/0 byte schema.

### 5.1 Producer identity law

**E-K0-A2-ID-1.** Exactly one production branch is required:

- AP0-produced manifestation: `:adapter-identity` is present and resolves to the bound adapter descriptor/live-adapter relation;
- non-AP0-produced manifestation: `:producer-identity` is present and names the producing principal or procedure.

An AP0 implementation MUST NOT hide adapter provenance behind a generic source-boundary atom. A fake adapter occupies the adapter field exactly as an external adapter would.

**E-K0-A2-ID-2.** Missing adapter identity on an adapter-produced manifestation uses AP0’s `adapter-identity-missing`; missing adapter identity on a stream chunk uses `stream-chunk-adapter-identity-missing`. A non-adapter manifestation missing producer identity is refused under Kernel `standing-inflation` carrying `E-K0-A2-ID-1`.

### 5.2 Stream/chunk relation law

**E-K0-A2-STR-1.** A manifestation produced from one or more stream chunks MUST carry `:stream-relation`. A boolean `streamed-p`, a sequence count without identities, or a payload concatenation with no chunk lineage is insufficient.

**E-K0-A2-STR-2.** `:chunk-record-ids` names AP0 chunk/checkpoint records. Those records retain the AP0 fields and laws, including:

- stream and chunk identity;
- attempt and adapter identity;
- sequence number and predecessor chunk identity;
- payload identity and octet count;
- chunk kind and finality evidence;
- capture boundary;
- visibility, exposed principals, and evidence;
- persistence order;
- visible gaps, reordering, duplicates, and collisions.

The manifestation relation references that law; it does not duplicate or weaken it.

**E-K0-A2-STR-3.** If a manifestation payload is derived by concatenation, normalization, decoding, batching, or another transformation over chunks, `:projection-receipt-id` is REQUIRED. The receipt names order, procedure/version, inputs, output, losses, gaps, and bounded unknowns.

**E-K0-A2-STR-4.** Captured chunks are never erased by terminal absence, cancellation, parser failure, or missing finality. One or more captured chunks without lawful terminal settlement yields `:present-partial` unless a later receipt-bearing transformation establishes another legal manifestation while preserving the partial lineage.

**E-K0-A2-STR-5.** A non-stream manifestation omits `:stream-relation`; it does not carry an empty relation merely to satisfy a uniform host struct.

### 5.3 Constructor consequence

The post-erratum manifestation constructor must accept and defensively copy the new identity and relation fields. It must refuse:

- neither adapter nor producer identity;
- both fields where one branch is expected;
- adapter production represented only by source boundary;
- stream production with no stream relation;
- empty chunk-record list;
- derived aggregate with no projection receipt;
- a stream relation that names chunk records from another attempt or adapter;
- a `:present-partial` stream whose captured chunk lineage has been discarded.

AP0 retains authority over the exact chunk-record value spaces and named AP0 conditions. Kernel validates their relation to the manifestation and outcome.

---

## 6. Required implementation deltas

Adoption of this erratum authorizes no shortcut around the independent implementation gates. It does define the minimum delta required before the vertical specimen.

### 6.1 Pure Kernel /0

The pure core must:

1. reject singleton bounded determinacy;
2. separate the historical call-296 projection from a complete constructible fixture;
3. add adapter/producer identity and stream relation to manifestation records;
4. add minimum validation, integrity, visibility, and procedure-descriptor records;
5. implement the joint structural/semantic checks needed for tests 43–48;
6. add accessors and inspection output without exposing bare context-discarding convenience paths;
7. preserve defensive-copy behavior for all list and record fields.

### 6.2 PJ0 joint layer

The independently seeded Common Lisp PJ0 implementation must supply the exact evidence used to close gap 2. Kernel unit fixtures do not substitute for it.

### 6.3 AP0 joint layer

The independently seeded Common Lisp AP0 implementation must validate AP-G4 fields and execute joint reports where structural AP0 and semantic Kernel outcomes diverge.

### 6.4 No Python transplantation

Neither Common Lisp path may import, translate, mechanically port, embed, or line-by-line imitate the Python generator, serializer, parser, validator, fake-adapter state machine, or expected-result computation.

Frozen vectors are evidence inputs. The adopted specification text is the implementation source of law. Divergences are adjudicated against the specification, not against whichever implementation arrived first.

---

## 7. Post-erratum conformance obligations

A post-erratum implementation does not claim closure merely because its ordinary examples are green. The following controls are mandatory.

| ID | Required demonstration | Expected failure when violated |
|---|---|---|
| E01 | singleton bounded alternatives rejected | `standing-inflation` / `E-K0-1-DET-1` |
| E02 | call-296 historical projection not presented as complete constructor fixture | conformance report failure |
| E03 | adapter-produced manifestation carries adapter identity | AP0 `adapter-identity-missing` |
| E04 | non-adapter manifestation carries producer identity | Kernel `standing-inflation` |
| E05 | streamed manifestation carries non-empty chunk lineage | AP0 stream identity/relation condition |
| E06 | derived aggregate names projection receipt | `projection-procedure-missing` or relation refusal |
| E07 | sealed does not imply verified | planted promotion killed |
| E08 | published does not imply truth/verification | planted promotion killed |
| E09 | bare published refused | `bare-visibility-scope` |
| E10 | bare verified refused | `bare-validation-scope` |
| E11 | parser-valid does not imply accepted | `standing-inflation` / `E-K0-4-SEM-2` |
| E12 | AP0 structural PASS + Kernel semantic FAIL preserved as dual result | joint-report mismatch |
| E13 | §23 fixture rebuilt from PJ0 prefix with finalizers/indexes/snapshots absent | reconstruction failure |
| E14 | torn tail remains visible and source unchanged | PJ0 conformance failure |
| E15 | salvage destination not falsely compared as source frame identity | comparison-policy failure |
| E16 | all planted defects killed for the intended requirement | mutation-score failure |

The implementation report must name exclusions. “Not yet implemented” is lawful; silently counting an exclusion as PASS is not.

---

## 8. Trace ledger

| Existing gap or governing clause | Closure in this erratum |
|---|---|
| `mneme/kernel0/README.md` gap 1: call-296 bounded manifestation lacks alternatives; singleton used as accommodation | §1 rejects singleton bounded sets, preserves the projection as non-constructible, and requires a separate synthetic algebra fixture |
| gap 2: no exact reconstruction protocol in pure core | §2 binds Kernel §23 evidence to adopted PJ0 framing, prefix, kill, reconstruction, and comparison law |
| gap 3: tests 43, 44, 47, 48 lack enforcement surfaces | §3 supplies minimum validation, integrity, and visibility records and executable tests |
| gap 4: parser validity versus semantic procedure not mechanically distinguished | §4 adds procedure judgment class and exact AP0/Kernel joint jurisdiction |
| Kernel §8.1 requires adapter/producer identity and stream relation | §5 makes the Appendix A.2 sketch complete |
| AP0 AP-G4-1 | §5.1 requires adapter identity for AP0-produced manifestations |
| AP0 AP-G4-2 | §5.2 requires explicit stream/chunk lineage |
| AP0 AP-G4-3 | §§0 and 5 preserve AP0 ownership of field value spaces and conformance rules |
| AP0 AP-G4-4 | this document is the routed Kernel erratum |
| AP0 §24.3 joint jurisdiction | §4 defines the mechanically visible two-stage boundary |
| PJ0 §12 structural/semantic separation | §§2.1 and 4.4 preserve dual standing and prohibit skip/reclassification |
| Architecture 0.1 L3/L4 | §3 prohibits cross-facet standing inflation |
| Kernel tests 43–48 | §§3–4 make the previously opaque cases executable |

---

## 9. Adoption effect and remaining gates

If adopted, this erratum closes Kernel /0 gaps 1–4 as specification ambiguities.

It does **not** by itself establish:

- a passing independently seeded Common Lisp PJ0 implementation;
- a passing independently seeded Common Lisp AP0 implementation;
- AP0 independent verification or validation;
- stranger-audit completion;
- a working Mneme journal store;
- live capability safety;
- fake-adapter conformance;
- vertical-specimen success;
- any live-provider authorization;
- any Language-A factual disposition.

The immediate lawful sequence after adoption remains:

```text
independently seeded Common Lisp PJ0/AP0 verifier
→ Mneme single-file journal store
→ live capability machinery
→ deterministic fake adapter
→ four-death vertical specimen
→ hostile implementation review
→ stranger primitive-minimization audit
→ LISP-PLUS-FREEZE-CANDIDATE-0
```

No specimen may use the pre-erratum singleton accommodation as evidence that gap 1 was solved. No joint validator may flatten AP0 structural and Kernel semantic results into one green bit. No journal implementation may infer success from caller memory when a receipt was lost.

The architecture has finished writing laws for ghosts. The next evidence must come from processes that actually die, restart, remember exactly what survived, and refuse to remember power they no longer possess.

---

## 10. Adoption record fields

A later adoption record should bind at least:

```lisp
(:kernel-erratum-adoption
  :artifact "LISP-PLUS-KERNEL-0-ERRATA-0.1.md"
  :artifact-sha256 ...
  :adopted-by ...
  :adoption-time ...
  :repository-commit ...
  :kernel-spec-id ...
  :pj0-spec-id ...
  :pj0-repairs-id ...
  :ap0-reissue-spec-id ...
  :ap0-adoption-record-id ...
  :implementation-phase-board-id ...
  :dispositions
    (:gap-1 :closed
     :gap-2 :closed
     :gap-3 :closed
     :gap-4 :closed
     :ap-g4 :folded-into-kernel)
  :remaining-gates
    (:independent-cl-pj0
     :independent-cl-ap0
     :vertical-specimen
     :hostile-review
     :stranger-audit)
  :bounded-unknowns (...))
```

Until that record exists, this file remains an adoption candidate and must not be described as governing.
