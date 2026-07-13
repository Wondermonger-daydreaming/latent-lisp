# CD/0 Post-Implementation Constitutional Ruling

**Repository file:** `CD0-POST-IMPLEMENTATION-RULING.md`  
**Status:** Final specification adjudication for Lisp+ Canonical Datum /0  
**Date:** 2026-07-13  
**Base specification:** `mneme/spec/CANONICAL-DATUM-SPEC.md`  
**Base specification SHA-256:** `d578e86e4d411611b091cca0bed1cafac2636c0908e95447fd4a13badcab6abc`  
**Normative companion issued with this ruling:** `CANONICAL-DATUM-SPEC-ERRATA-0.1.md`  
**Errata SHA-256:** `5f1568e53c4e6ef5fc8de2e125e7a6ef2d861392048c7ead144c7df05eb16271`  
**Datum format and algebra version:** `0` (`CD/0`), unchanged

The key words **MUST**, **MUST NOT**, **SHOULD**, **SHOULD NOT**, and **MAY** are used normatively only where this ruling imposes an observable conformance or publication condition.

---

## 1. Executive verdict

The published Common Lisp and Python codecs conform to every unambiguous requirement of the audited CD/0 specification on the surfaces actually claimed: the abstract datum algebra, equality, canonical octet grammar, exact decoding, canonical record ordering, immutability, inertness, and the failure/resource cases whose normative fields were settled before implementation.

The independent audit contradicts no published claim. It independently reran the principal conformance, differential, hostile-input, mutation, qualification, non-regression, corpus-regeneration, and archive-reproduction results and reproduced the load-bearing numbers. Its remaining qualifications are real and must travel with the publication.

The two codecs implement the same CD/0 wire format and the same CD/0 abstract values. They were not, at the audited tips, fully behaviorally interchangeable across every auxiliary host-construction and tight-budget encode call. The two live differences—A2 constructor-failure category and A9 runtime-encode budget jurisdiction—were genuine omissions in the specification rather than violations of its then-existing law. They were disclosed and fenced away from the warranted differential claims.

This ruling closes A1–A9. It adopts narrowly scoped normative errata for A1–A6, A8, and A9, and an additive fixture/harness correction for A7. No ruling changes canonical octets, abstract equality, the datum algebra, or the meaning of any version-0 document. The format remains CD/0.

The disposition is:

> **Accept the work as published. Accept it for merge after narrow errata implementation and targeted verification. Do not merge the audited `cd0-integration` tip unchanged.**

The Common Lisp codec requires two semantic patches under the newly issued errata: A2 host-constructor failures must use `UnsupportedHostInput`, and A9 runtime encoding of an already-valid datum must ignore decode/import structural limits. The Python codec already has the selected behavior on those two witnessed paths. Both implementations and the shared harness require vector promotion and fixture work, especially the A1 stage labels and A7 rational-construction descriptor.

No broad re-audit is required merely because the specification has now answered its own questions. A targeted independent check of the errata vectors, both codec patches, the complete differential, and the new release receipt is required before merge. Any unexpected byte change, equality change, newly exposed divergence, or unrelated semantic modification reopens the need for broader review.

Plain answers to the final questions are:

- **Do the codecs implement the same CD/0?** Yes for the canonical datum algebra, bytes, equality, exact wire decoder, immutable runtime contract, and inertness. At the audited tips they differ on two previously unspecified auxiliary behaviors, A2 and A9; this ruling now fixes those behaviors and requires the Common Lisp codec to converge.
- **Which portion is demonstrated implementation-independent?** The nine-family value algebra and its canonical version-0 octets, identifier and Unicode rules, rational normalization and byte refusal rules, sequence and record semantics, canonical key-byte ordering, equality/encoding correspondence, strict full-input decoding, mutation resistance, and inert decoding—within the audited environments and tested resource surface.
- **What remains unsettled?** Not A1–A9 after adoption of this ruling. What remains unsettled belongs above or beside CD/0: located-claim identity, profile schemas, procedure/module identity, evaluator authority, capabilities, warrants, receipt transitions, cryptography, custody, verified lineage, and portability beyond the audited host versions.
- **Can `cd0-integration` be merged into `main`?** Not at audited commit `baeecd5e0347435b9e1362000344f46ea441c6ec` unchanged. A successor integration commit may be merged after the errata, patches, vectors, documentation repairs, full reruns, and targeted independent verification listed in Section 15.
- **What precedes v1 migration?** Errata-conformant codecs, explicit v1 profile adapters, represented-loss rules, inert/privileged separation, migration and differential fixtures, and a separate decision for located-claim and identity projections.
- **Does any adjudication change canonical bytes or require a datum-version increment?** No.

---

## 2. Repository state and evidence reviewed

### 2.1 Pinned repository state

This ruling applies only to the following published state:

```text
remote             https://github.com/Wondermonger-daydreaming/latent-lisp.git
cd0-common-lisp    45eb60ce5b80485a0b287feab53ed3b58643b1b0
cd0-python         29d0946ad78347015b9f0c65a2f528f039fdca78
cd0-integration    baeecd5e0347435b9e1362000344f46ea441c6ec
integration tree   41d3a71c06692174701bfde8f071e7da1c719651
archive source     169785744afd26d7580f08c6bce0ee2e569d77a6
archive sha256     af65596713533b29d90b28a75881de9473adec7a5dc91af9bd49830d52001949
archive members    407
archive bytes      6,861,174
```

The audited execution environment was SBCL 2.4.6, CPython 3.11.14, and git 2.43.0. This ruling does not silently generalize execution evidence to other Common Lisp implementations, SBCL releases, Python releases, operating systems, architectures, or resource environments.

### 2.2 Attached evidence

The attached relay packet was read in full. Its container SHA-256 is:

```text
022844a8ec2c232c33574cc773a924df70e7bea8661281941d925c3d0cbf52f5
```

The evidence included:

- `FABLE-CD0-INDEPENDENT-REVIEW.md`;
- `FABLE-CD0-REPRODUCTION-LEDGER.md`;
- `FABLE-CD0-A1-A9-ADJUDICATION-BRIEF.md`;
- `FABLE-CD0-GPT-PRO-RELAY.md`;
- `CANONICAL-DATUM-SPEC.md`;
- `CANONICAL-DATUM-DIVERGENCES.md`;
- `SEVERITY-RUBRIC.md`;
- `DIRECTOR-NOTES.md`;
- `crew/GRAMMARIAN.md`;
- `crew/ADJUDICATOR.md`;
- `crew/QUARTERMASTER.md`;
- `crew/GENEALOGIST.md`;
- `crew/CODEX-LEDGER-SUMMARY.md`;
- `crew/CODEX-QUORUM-SUMMARY.md`;
- `crew/CODEX-TALLY-SUMMARY.md`.

The base specification in the packet hashes to the published normative SHA-256. The relay was used as an index; the underlying review, reproduction ledger, specialist reports, divergence register, severity rubric, director notes, and specification controlled this decision.

### 2.3 Evidence classes preserved by this ruling

| Class | Meaning in this ruling |
|---|---|
| **Independently rerun** | An auditor executed the operation from pinned sources and reproduced the result. |
| **Statically confirmed** | Code, repository history, artifacts, or raise-sites were inspected, but the behavior was not freshly executed for that claim. |
| **Tracked evidence only** | The claim rests on committed transcripts, receipts, or attestations from the publication process. |
| **Partially reproduced** | A material part was rerun or inspected, but not the complete historical or procedural claim. |
| **Not reproduced** | Available evidence did not establish the claim; this is not itself contradiction. |
| **Contradicted** | Positive counter-evidence exists. |

No statement below upgrades tracked or inspected evidence into independently rerun evidence merely because the surrounding publication is green.

---

## 3. Confirmed implementation claims

The following load-bearing claims are confirmed at the stated evidence level.

| Claim | Evidence ruling | Constitutional conclusion |
|---|---|---|
| Base specification content hash | Independently rerun | The implementations and audit targeted the same normative document. The separate question of pre-implementation temporal pinning is qualified in Section 4. |
| Seventeen worked byte vectors | Independently rerun four times | Both codecs reproduce all worked canonical documents. |
| Twenty-two shared positive vectors | Independently rerun | Positive construction, encoding, decoding, and equality-class behavior matches. |
| Complete tag-octet classification | Independently rerun | All 256 first-octet values were classified; all ten assigned /0 tags were exercised. |
| Five declared distinct pairs and 253 equality judgments | Independently rerun | The tested disjointness and equality/encoding correspondence hold in both codecs. |
| Phase-2 differential | Independently rerun twice | 353 requests per codec, zero warranted disagreements, with three Common Lisp N/A dispositions handled as N/A rather than passes. |
| Codec test suites | Independently rerun three times each | Python: 152/152. Common Lisp: 2,510 assertions. |
| Phase-4 qualification | Independently rerun | 353 golden plus 1,045 property requests per codec, zero warranted disagreements. |
| Generated release corpus and full differential | Independently rerun twice | 10,000 positives, 20,308 classified negatives, 30,504 mutation candidates, and 100,824 requests per codec reproduced the published summary with zero warranted disagreements and zero mutation disagreements. |
| Sufficient-budget retry arm | Independently rerun twice | 20,012 retry checks were separately accounted for; no overwrite channel was found. |
| Corpus content determinism | Independently rerun through three regenerations across the audit legs | Generated content artifacts reproduced byte-for-byte; the corpus digest matched. Designed provenance fields in the manifest varied as documented. |
| Auditor-derived boundary corpus | Independently rerun | 111 spec-derived vectors produced zero codec-versus-spec, zero codec-versus-codec, and zero accepted-reencode disagreements against an auditor-written reference codec. |
| Canonical record ordering | Independently rerun | Both codecs order and validate records by complete canonical Identifier `ValueBytes`, not host collation or insertion order. |
| Immutability and cached-byte stability | Independently rerun | Source mutation, decoded-buffer mutation, and accessor-return mutation did not change abstract values or canonical bytes. |
| Inert decoding | Independently rerun plus static inspection | Capability-, warrant-, receipt-, and certificate-shaped records remained ordinary records; reader-evaluation-shaped text remained text; no activation path was found in either decoder. |
| Harness disagreement and crash teeth | Independently rerun | A planted behavioral divergence was reported at the exact request id with failure status; a planted crash aborted the run. |
| Archive hash, size, membership, and recipe | Independently rerun three times | Explicit `git archive --format=tar.gz` rebuilds from the declared source commit were byte-identical to the published artifact. |
| Existing-v1 gate | Independently rerun three ways | All six v1 suites remained green on integration and both codec branches. |
| No `mneme/` source change on the audited branches | Statically confirmed by multiple audit legs | The CD/0 publication did not migrate or modify existing v1 runtime semantics. |
| A1–A9 executable witnesses | Independently rerun | Every registered gap was exercised on both codecs; seven local choices agreed, while A2 and A9 diverged exactly as reported. |

These confirmations establish substantially more than “both programs printed green.” They establish one byte grammar, one tested equality relation, one strict exact-decoder behavior, and one inert immutable data boundary across Common Lisp and Python on the pinned environments.

---

## 4. Qualified implementation claims

### 4.1 Phase-0 negative decomposition

The negative result MUST be stated as follows, without compressing N/A dispositions into passes:

> **71 classified rows = 66 octet rows + 5 host rows. Python executes 71/71. Common Lisp executes 68—66 octet plus 2 applicable host rows—and records 3 N/A dispositions because its seed does not expose three optional host importers. Those dispositions are not passes. The result is 0 failures and 0 skips. By status, the corpus contains 59 complete normative triples, 11 provisional-stage rows under A1, and 1 provisional-code row under A2.**

The N/A set is closed in code: an unexpected N/A fails the harness. That makes the disposition honest; it does not transform unexecuted host-import paths into evidence.

### 4.2 “Zero warranted disagreement”

The published zero is correct for the fields and requests designated warranted by the then-current specification. It is not a claim that every conceivable host-constructor triple or every tight runtime-encode budget call agreed.

For the eleven A1 rows, stage was deliberately excluded. For the one A2 provisional row, code was excluded. The A2 live category difference was absent from the compared host surface, and A9 tight structural budgets were absent from positive encode requests. The exclusion machinery was inspected and found honest; coverage at those two edges was incomplete by design and was disclosed.

### 4.3 Corpus scale

The corpus met the base specification's exact release floors. It is strong evidence of conformance, not a proof that no ungenerated edge exists. The 20,308-negative total was independently recounted; the internal claim that it comprises 20,000 primary-minimal plus 308 coverage rows remains supported by generator source and manifest rather than independently re-derived.

### 4.4 Portability

The publication demonstrates cross-language and cross-process agreement in SBCL 2.4.6 and CPython 3.11.14. It does not yet demonstrate portability across another Common Lisp implementation, another SBCL release, another Python major/minor release, another machine architecture, or substantially different host resource ceilings.

### 4.5 Harness channels

Behavioral-disagreement and crash paths were teeth-fired. Timeout and duplicate-request-id paths were statically inspected but not live-fired. They remain plausible, not independently executed claims.

### 4.6 Historical execution details

The original publication's empty stderr files and original per-phase probe counts are supported by tracked evidence. Fresh reruns independently re-established the underlying no-crash, mutation-resistance, and conformance properties, but they do not retroactively become direct observations of the historical run.

### 4.7 Archive scope

The published archive is reproducible from commit `169785744afd26d7580f08c6bce0ee2e569d77a6`, one commit before the audited integration tip. It is a valid release artifact for its declared source, not an archive of every byte at `baeecd5e…`. Any post-errata release must have a new source commit, hash, and receipt; the old archive must remain immutable historical evidence.

### 4.8 Non-regression

The 6/6 v1 gate and zero-byte `mneme/` diff establish non-regression against the existing test floor. They do not establish that v1 already uses CD/0, that a migration adapter is correct, or that located-claim, procedure, warrant, receipt, authority, or persistence semantics are preserved under a future migration.

---

## 5. Contradicted or unsupported claims

### 5.1 Contradicted claims

**None.** The independent review found no critical, high, or medium finding and no contradicted publication claim.

Three apparent drifts were resolved by discriminating checks:

1. fixture-hash differences came from comparing current fixtures against superseded hashes retained in an older verification document;
2. an archive-hash difference came from omitting the explicit `--format=tar.gz` flag, while the expanded archive content was already identical;
3. a claimed two-commit distance from archive source to tip had no source; the verified distance is one commit.

These are audit-side or documentation-legibility issues, not codec contradictions.

### 5.2 Unsupported or not fully reproduced claims

The following claims may not be promoted beyond their evidence:

- “the three branches were pushed atomically” is not reproducible post hoc; same-second ref creation is consistent with it but not proof;
- “the seeds were written blind” is an implementer attestation corroborated by content/history, not an OS-enforced information-flow fact;
- timeout and duplicate-id false-pass channels were not live-fired;
- portability beyond the audited SBCL and CPython versions was not attempted;
- the historical 20,000/308 negative split was not independently regenerated as a separate classification exercise;
- the publication does not prove total specification closure outside the claimed CD/0 layer.

---

## 6. Precise independence ruling

The strongest justified formulation is:

> **The Common Lisp and Python codecs were independently seeded under shared normative infrastructure, with procedural—not OS-enforced—isolation, attested by the implementers and corroborated at content tier.**

This statement has four necessary qualifications.

First, the shared infrastructure was substantial and legitimate: the same normative specification; shared hand-authored vectors; fixture schemas and budget objects; the pre-seed A1–A9 divergence register, including its proposed-adjudication text; later generator and differential-convergence machinery; and the same broad authoring actor family, Codex.

Second, repository content strongly supports source-seed independence. The seed histories did not contain the other codec's directory; the seeds differ in helper naming, structural idiom, and free-form error text; the audit found original-authorship signatures at the seed commits; and the two live A2/A9 differences are evidence against simple behavioral copying.

Third, complete informational isolation is not established. The seed authors were procedurally instructed not to cross-read, but that fact cannot be proved from Git. The agreement at A1 and A3–A8 carries no two-witness adjudicative force because both seed authors had read the same pre-seed register proposals. This ruling therefore selects those semantics from the specification's principles, not by majority vote among implementations.

Fourth, independence attaches to the seed commits, not the audited branch tips:

```text
Common Lisp seed    e6f3b579…
Python seed         58ecca40…
```

The audited tips `45eb60ce…` and `29d0946a…` are accurately described as seed plus bounded corrections. Those corrections were authored after differential cross-reading was authorized and were backported without merge/cherry-pick topology that a DAG-only reader could reliably interpret. Publications MUST NOT cite the branch tips themselves as two isolated implementations.

The unqualified phrase “clean-room independent implementations” is therefore too strong. A narrower phrase such as “independently seeded implementations under shared normative infrastructure” is accurate.

---

## 7. Conformance ruling for the Common Lisp codec

### 7.1 Conformance under the audited base specification

At commit `45eb60ce5b80485a0b287feab53ed3b58643b1b0`, the Common Lisp codec conforms to every unambiguous CD/0 requirement exercised or independently derived by the audit. In particular, it agrees on canonical bytes, equality, strict byte refusal, version and tag behavior, UTF-8, rational canonicality, identifier segmentation, record ordering, full-input consumption, immutable access, cache stability, and inert decoding.

Its three N/A host rows are not failures and not passes. They mean the seed does not expose three optional host importers. The codec may claim conformance for the operations it declares, but it may not use those N/A dispositions as evidence of host-import feature equivalence with Python.

The A2 and A9 behaviors at the audited tip are not retroactive implementation defects because the base specification did not settle them. The audit demonstrated that both were reachable local choices outside the warranted comparison surface.

### 7.2 Conformance after Errata 0.1

Once Errata 0.1 is adopted, the audited Common Lisp tip is not yet conformant on the newly settled auxiliary surface. It requires:

- A2: constructor/importer invariant failures such as zero denominator, empty identifier segment, missing path, and duplicate field must report `UnsupportedHostInput / <specific-code> / host-import`, not `InvalidCanonicalGrammar`;
- A9: runtime `encode-exact` of an already-valid datum must enforce only `max_output_octets`, `max_total_record_key_octets`, and actual host allocation. It must not refuse merely because `max_depth`, `max_nodes`, integer, container, identifier, or payload import/decode fields are tight.

Its observed A1, A3–A6, and A8 local choices already match the adopted rules, but those paths still require the promoted and newly added shared vectors. “Already matches” is not a waiver of the tests.

After those patches and the Section 15 verification sequence, the Common Lisp codec may claim conformance to CD/0 plus Errata 0.1.

---

## 8. Conformance ruling for the Python codec

### 8.1 Conformance under the audited base specification

At commit `29d0946ad78347015b9f0c65a2f528f039fdca78`, the Python codec conforms to every unambiguous CD/0 requirement exercised or independently derived by the audit. It produces the same canonical bytes and equality judgments as Common Lisp, rejects the same warranted hostile documents, keeps decoded values immutable and inert, and avoids Python-specific leakage from `bool`/`int`, dictionary order, hash seed, mutable buffers, and raw recursion exceptions on the tested surface.

The audit's deep-host-ceiling case permits Python to return typed `AllocationRefused` where Common Lisp succeeds, because the base specification explicitly qualifies unpredictable host allocation ceilings. It does not permit raw `RecursionError` or alternate canonical bytes; the published fix correctly converts the host failure into the typed resource category.

### 8.2 Conformance after Errata 0.1

The Python behavior witnessed for A2 and A9 already matches the adjudicated rule. Its observed A1, A3–A6, and A8 choices also match. No core Python semantic patch is presently required by those witnesses.

Python still requires the same conformance-publication work as Common Lisp:

- support the A7 fixture construction descriptor in the shared fixture adapter;
- run all promoted A1/A2 rows as complete triples;
- run every new tight-boundary and operation-jurisdiction vector;
- preserve full differential equality after the Common Lisp changes;
- record any unanticipated mismatch rather than treating the prior agreement as authority.

A test-only or adapter-only change is still a required change when the conformance schema gains a required exercised form.

---

## 9. Differential and corpus ruling

The published differential result is accepted with its exact scope.

The full release differential was independently rerun twice from fresh regeneration and produced 100,824 requests per codec, zero warranted issues, zero mutation disagreements, 20,012 retries, three Common Lisp N/A dispositions, and mutation outcomes of 30,049 same-failure plus 455 both-success-identical. The Phase-2 353-request differential and Phase-4 qualification were also independently reproduced.

This demonstrates:

- byte-for-byte encoding agreement for the generated valid values;
- equal/unequal judgments consistent with canonical bytes over the tested classes;
- strict decode/re-encode identity for accepted documents;
- cross-codec agreement on all then-warranted negative fields;
- no demonstrated mutation-derived case requiring minimization;
- deterministic corpus content under the audited generator and seeds.

It does not demonstrate:

- agreement on A2 constructor categories or A9 tight runtime-encode budgets at the audited tips;
- live execution of the three Common Lisp N/A importer rows;
- exhaustiveness of all resource-limit intersections;
- portability beyond the audited hosts;
- semantics of any Mneme profile layered above CD/0.

After Errata 0.1, the newly settled fields are no longer provisional. The next differential publication MUST compare complete category/code/stage triples for promoted A1/A2 rows and MUST include the A3–A9 boundary vectors. A report that continues to exclude those fields after adoption would be a false conformance claim.

The existing corpus and archive remain valid evidence for the base-specification publication. They must not be rewritten in place. The errata implementation gets a new corpus receipt and release archive, even though its expected canonical bytes remain unchanged.

---

## 10. Immutability and inertness ruling

The audit confirms the Layer-2 runtime contract on both implementations for the tested constructions and access paths.

Constructing from mutable strings, byte buffers, sequences, or field collections did not retain a caller-mutable alias capable of changing the datum. Mutating source objects after construction or decoding did not change canonical bytes. Accessor-return mutation did not reach private storage. No writable canonical-byte cache was exposed. These results defeat the original shallow-copy and stale-fingerprint failure family at the CD/0 boundary rather than merely hiding it behind one host's conventions.

The audit also confirms the hard inertness boundary. Records whose identifiers resemble capabilities, warrants, receipts, certificates, or authority descriptions decode as ordinary records. A string shaped like Common Lisp reader evaluation remains a string. Reserved and privileged wire tags fail rather than dispatching constructors. Static inspection found no `eval`, generic object deserialization, symbol interning, package resolution, reader evaluation, or privileged revival in the exact decode paths.

This ruling does not infer that an application consuming an inert record will interpret it safely. CD/0 prevents the codec from minting authority. A later profile validator or evaluator transition can still be malicious or wrong. Authority, authenticity, truth, admissibility, and successful execution remain outside this conformance receipt.

---

## 11. Resource and failure-semantics ruling

The audited codecs distinguish invalid grammar, noncanonical encoding, unsupported format, resource refusal, unsupported host input, privileged restoration attempt, and internal invariant failure on the warranted tested surface. The independent 111-vector corpus and category probes found no mismatch in settled cases.

A1–A9 nevertheless exposed real underspecification. Failure triples and resource refusals are part of observable interoperability, not decorative diagnostics. A third implementation could have followed the old text and selected different stages, bit metrics, segment accounting, tie precedence, key-tag precedence, key-work accounting, constructor categories, or encode-budget jurisdiction. Agreement between the two seeds could not make those choices law.

Errata 0.1 therefore rules:

- stages are assigned by a complete context matrix;
- host-constructor invariant failures are `UnsupportedHostInput` at `host-import`;
- integer-bit budgets count mathematical magnitude;
- identifier-segment budgets are aggregate across namespace and path;
- deterministic resource ties use depth, then nodes, then local count/length/magnitude, then aggregate payload;
- a record-key `f0..ff` octet retains privileged-tag precedence, while every other non-`22` key gets `RecordKeyNotIdentifier`;
- record-key work counts complete Identifier `ValueBytes` once per field occurrence, independent of sort comparisons;
- runtime encode of a valid datum enforces output and key-work budgets, not decode/import structural fields.

These decisions leave host-dependent `AllocationRefused` qualified. A shared vector must use deterministic declared budgets when it expects identical triples. One host's real inability to allocate a permitted value is not evidence that the value or bytes are invalid.

---

## 12. Reproducibility and archive ruling

The publication's content reproducibility is accepted.

The committed corpus was regenerated independently multiple times. Content artifacts matched byte-for-byte and the corpus digest matched; only designed provenance fields changed. The release archive was rebuilt three times with the declared explicit-format recipe and matched its published SHA-256, member count, and byte size. The audit also confirmed that the corrected Phase-4/request-count wording exists in tracked documentation and in the rebuilt archive.

Two publication disciplines follow.

First, the exact archive command MUST retain the explicit format flag:

```text
git archive --format=tar.gz ...
```

A bare `git archive` invocation may produce a different container representation even when the expanded content is identical.

Second, historical hashes in `PHASE0-VERIFICATION.md` MUST gain a conspicuous forward pointer to the current correction receipt. They may remain as historical evidence, but they must not masquerade as current fixture hashes. This is a documentation-integrity repair, not a codec repair.

The post-errata integration must publish a new archive and source receipt. It MUST NOT replace or relabel `af655967…`; that artifact remains the reproducible receipt for the pre-errata source commit.

---

## 13. Existing-v1 non-regression ruling

The audit independently reran the six-suite v1 gate on integration and both codec branches and found all suites green. It also found no byte difference under `mneme/` between main and any audited CD/0 branch. The CD/0 work therefore did not alter the existing v1 runtime in the audited publication.

This is a non-regression result, not a migration result. It establishes neither that current v1 values are CD/0 datums nor that current printer-dependent fingerprints, package-sensitive symbols, scopes, `as-of` values, procedure identities, receipts, or warrant testimony have already acquired cross-implementation identity.

A future v1 migration is a profile-adapter and constitutional-identity change. It must be reviewed as such. Passing the old v1 floor remains necessary after migration, but is not sufficient.

---

## 14. A1–A9 adjudication table

### 14.1 Summary table

| Item | Primary classification | Ruling | Canonical octets | Equality | Accepted values/documents | Failure behavior | Existing vectors | Required patch | Format version |
|---|---|---|---|---|---|---|---|---|---|
| **A1** | Normative erratum required | Bind every relevant context to one stage; depth/node=`type-tag`, declared payload truncation=`length`, promised absent container item=`count`, output limit=`allocation`. | Unchanged | Unchanged | Unchanged | Stage becomes mandatory; two fixture labels change. | Valid except depth/node expected stages; provisional rows promoted after correction. | Shared fixtures/harness; codecs already match witnessed assignments. | 0 |
| **A2** | Normative erratum required | Host constructor/importer invariant failures use `UnsupportedHostInput / specific-code / host-import`; byte decoder keeps `InvalidCanonicalGrammar`. | Unchanged | Unchanged | Same host inputs rejected | Common Lisp category changes on witnessed paths. | Existing byte vectors valid; host negatives added; provisional code promoted. | Common Lisp core plus shared vectors. | 0 |
| **A3** | Normative erratum required | `max_integer_bits = bit_length(abs(component))`, zero=0; UVAR work remains separate. | Unchanged | Unchanged | Tight-budget operation acceptance fixed | Boundary resource refusal fixed. | Existing away-from-boundary vectors valid; new integer/rational boundaries added. | Likely vectors only; verify both codecs. | 0 |
| **A4** | Normative erratum required | Identifier segment limit is aggregate namespace+path, checked overflow-safely. | Unchanged | Unchanged | Tight-budget operation acceptance fixed | Aggregate overflow reports `ExcessiveIdentifierSegments`. | Existing vector valid; add 1-versus-2 boundary. | Likely vectors only; verify both codecs. | 0 |
| **A5** | Normative erratum required | Deterministic resource tie order: depth, nodes, local count/length/magnitude, aggregate payload. | Unchanged | Unchanged | Underlying datum/document unchanged | Winner code in simultaneous breaches fixed. | Existing single-breach rows valid; add tie vectors. | Likely vectors only; verify both codecs. | 0 |
| **A6** | Normative erratum required | Record key gate: `f0..ff` gives privileged-tag failure; every other non-`22` gives `RecordKeyNotIdentifier`. | Unchanged | Unchanged | No invalid key becomes valid | Category/code/stage fixed for invalid key octet. | Existing rows valid; add `03` and `f0` key-first vectors. | Likely vectors only; verify both codecs. | 0 |
| **A7** | Fixture or harness defect | Add separate `construction:{op:rational,...}` metadata; never spell unreduced rationals as datum ASTs. | Unchanged | Unchanged | Fixture language gains a construction form; datum language unchanged | Constructor negatives follow A2. | Existing vectors valid; new construction vectors added. | Both fixture adapters/schema. | 0 |
| **A8** | Normative erratum required | Count complete key Identifier `ValueBytes` once per field occurrence, globally per operation and independent of sort comparisons. | Unchanged | Unchanged | Tight-budget operation acceptance fixed | Key-work refusal and stage fixed. | Existing ample-budget vectors valid; add 5-versus-4 and nested accumulation. | Likely vectors only; verify both codecs. | 0 |
| **A9** | Normative erratum required | Decode and host import enforce their applicable structural budgets; runtime encode enforces only output, key-work, and actual allocation. | Successful bytes unchanged | Unchanged | Runtime encode now succeeds under tight ignored structural fields | Common Lisp accept/refuse behavior changes. | Existing positives valid; add per-operation jurisdiction vectors. | Common Lisp core plus shared vectors. | 0 |

### 14.2 A1 — failure-stage mapping

**Exact ambiguity.** Section 20.4 named stages but did not assign them to failures. Section 20.5 ordered checks without specifying the emitted stage. A careful third implementation could attach `length`, `utf8`, or `container-content` to the same truncation or choose a different output-refusal stage.

**Ruling and reason.** Stage is the checkpoint where the chosen failure becomes determinable. The complete matrix in Errata E0.1-1 is adopted. This follows the base parser order and prevents outer-container relabeling. It is not chosen merely because both codecs currently emit it.

**Effects.** Bytes, equality, values, and accepted documents do not change. Failure stage changes from provisional to mandatory. The depth and node fixture labels are wrong under the ruling and must change from `container-content` to `type-tag`. All other witnessed codec stages already align. No format bump.

### 14.3 A2 — constructor/importer triples

**Exact ambiguity.** The base categories were written around byte decoding while constructors and fixture importers could fail the same semantic invariant without a specified category or stage. Common Lisp used `InvalidCanonicalGrammar`; Python used `UnsupportedHostInput` for the same zero-denominator, empty-segment, and missing-path inputs.

**Ruling and reason.** A host value is not a malformed canonical byte document. Constructor/importer invariant failures use `UnsupportedHostInput`, reuse the most specific semantic code, and use `host-import`. This preserves the byte decoder's category jurisdiction and makes the host boundary explicit.

**Effects.** No bytes, equality, accepted datum, or accepted document changes. The Common Lisp failure category changes on the witnessed paths; Python already matches. New host-input vectors are mandatory. No format bump.

### 14.4 A3 — integer-bit metric

**Exact ambiguity.** “Magnitude exceeds `max_integer_bits`” did not say whether to count mathematical magnitude, zigzag payload bits, or a sign bit.

**Ruling and reason.** Count `bit_length(abs(z))`, with zero consuming zero bits. This follows the mathematical component named by the abstract algebra and keeps wire UVAR work under its separate budget.

**Effects.** Bytes and equality are unchanged. Tight-budget success/refusal is fixed, with boundary vectors for integers and both rational components. Both audited codecs already exhibit the selected rule, but that prior agreement has no adjudicative force. No format bump.

### 14.5 A4 — identifier segment total

**Exact ambiguity.** One `max_identifier_segments` field could be read as a per-side limit or a total across namespace and path.

**Ruling and reason.** It is the aggregate total. One field should bound total traversal and allocation; a per-side reading silently doubles the allowed work.

**Effects.** No bytes or equality change. A tight-budget identifier may now be deterministically refused where a per-side codec would accept. Both audited codecs already match. No format bump.

### 14.6 A5 — simultaneous budget breaches

**Exact ambiguity.** The base precedence did not settle depth versus nodes or single-payload versus aggregate-payload refusal when both limits trip at the same checkpoint.

**Ruling and reason.** Check depth before nodes, and applicable local magnitude/count/length before aggregate payload. This follows outer-entry before descent and local declaration before cumulative accounting.

**Effects.** The datum and bytes are unchanged. Only the selected resource code/triple changes in multi-defect budget fixtures. Existing single-limit vectors remain valid. No format bump.

### 14.7 A6 — record-key tag precedence

**Exact ambiguity.** `RecordKeyNotIdentifier` literally covered any non-`22` key, while the privileged range was also specified to fail everywhere as `ForbiddenPrivilegedTag`.

**Ruling and reason.** The permanently privileged tag range retains precedence for security telemetry. Every other non-identifier first octet is a record-key shape error and is not parsed as a nested datum tag.

**Effects.** No byte string changes validity. Only the failure triple for invalid key prefixes becomes fixed. Both codecs already match. No format bump.

### 14.8 A7 — rational constructor fixture

**Exact ambiguity.** Section 27.3 required testing `2/4 -> 1/2`, while the datum AST in Section 27.2 could represent only normalized rational values and had no constructor operation.

**Ruling and reason.** This is a fixture defect. Add a separate construction descriptor and keep normalized datum ASTs pure. Test metadata must not invent a noncanonical datum merely to reach a constructor.

**Effects.** The fixture schema gains an additive form; codecs' datum algebra and bytes do not change. Both fixture adapters require support. No format bump.

### 14.9 A8 — key-work accounting

**Exact ambiguity.** The key-work budget could count UTF-8 payload only, framing plus payload, complete `ValueBytes`, or sort-comparison repetitions.

**Ruling and reason.** Count complete canonical Identifier `ValueBytes` exactly once per field occurrence across the operation. That is the actual canonical ordering operand and is independent of sort algorithm.

**Effects.** Bytes and equality are unchanged. Tight-budget import/encode acceptance becomes deterministic. Both audited codecs already match on the one-key witness. Add global/nested accumulation vectors. No format bump.

### 14.10 A9 — runtime encode budgets

**Exact ambiguity.** The base specification passed one budget to `encode-exact` but scoped structural budgets to decode and hostile import and mentioned only output/key work on the encode path. Common Lisp reapplied all structural fields; Python did not.

**Ruling and reason.** A valid immutable runtime datum has already crossed an admission boundary. Reapplying decode/import limits does not remove resident structure and makes refusal depend on an unrelated policy. Runtime encode therefore enforces output and canonical-key work, plus actual allocation. Decode and host import retain their applicable structural defenses.

**Effects.** Successful canonical bytes remain identical. Abstract values and equality do not change. Runtime operation acceptance does change: `Sequence([Unit])` with `max_depth=1` and ample output must encode successfully. Common Lisp must relax; Python already matches. No format bump.

### 14.11 Effect of the pre-ruling A1–A9 gaps on project gates

| Gate | Constitutional effect |
|---|---|
| **Conformance to the hash-pinned base specification** | The gaps did **not** invalidate present conformance to its unambiguous algebra, wire, equality, immutability, inertness, and settled failure surface. A2 and A9 behavior had to remain qualified rather than falsely harmonized. |
| **Publication of the audited branches and evidence** | The gaps did **not** block publication because they were registered, executable, disclosed, and fenced out of warranted comparisons. The publication is accepted with those qualifications. |
| **Merge into `main`** | The exact audited integration tip is now blocked from merge unchanged. Adoption of this ruling makes A2 and A9 determinate; the Common Lisp tip must be patched, all nine rulings must acquire shared vectors, and the successor release must pass Section 15. |
| **Migration of the existing v1 boundary onto CD/0** | Migration remains blocked. Closing A1–A9 is necessary but not sufficient; the adapter, represented-loss, inert/privileged, and identity prerequisites in Section 16 still control. |
| **A claim of full specification closure** | Before this ruling, A1–A9 blocked any claim that CD/0 failure/resource semantics were fully closed. This ruling closes that codec-level register, but it does not close the higher constitutional boundaries listed in Section 17. |

The temporal distinction matters: the published tips were conforming implementations of the law that existed when audited; they are historical inputs to, not automatic implementations of, the newly adopted errata.

---

## 15. Merge recommendation

### 15.1 Disposition

The audited branches are accepted as a valid publication of the base-specification implementation and evidence. The exact integration commit `baeecd5e0347435b9e1362000344f46ea441c6ec` is not authorized for direct merge because this ruling has now made A2 and A9 determinate and the current Common Lisp tip does not yet satisfy them.

A successor of `cd0-integration` is **accepted for merge after narrow errata** when every condition below is met.

### 15.2 Mandatory pre-merge conditions

1. Commit `CANONICAL-DATUM-SPEC-ERRATA-0.1.md` as a separate normative companion. Do not silently rewrite the hash-pinned base specification.
2. Add shared vectors before changing codec behavior. The vectors must cover every E0.1 ruling and must compare complete triples where applicable.
3. Patch the Common Lisp A2 and A9 behavior.
4. Correct the A1 depth/node fixture stages and promote all A1/A2 provisional rows only in the same change that makes their full expectations executable.
5. Add the A7 rational construction descriptor to the shared schema and both fixture adapters.
6. Append closure entries for A1–A9 to `CANONICAL-DATUM-DIVERGENCES.md`, citing this ruling and errata. The ledger must remain append-only.
7. Apply all four audit LOW documentation repairs:
   - name the concrete A2 Common Lisp/Python category split in the divergence/closure record;
   - add a branch-tip provenance note explaining seed commits versus post-cross-reading backports;
   - correct the depth/node stage labels;
   - add a conspicuous forward pointer from superseded Phase-0 hashes to the current receipt.
8. Rerun both complete codec suites, Phase-0 verification, the complete shared differential, Phase-4 qualification, the full generated differential, mutation/inertness probes, and the 6/6 v1 gate. Preserve exact commands, environment, stdout/stderr, exit status, and request arithmetic.
9. Require zero warranted disagreements under the now-complete A1/A2 fields and the new A3–A9 vectors. N/A dispositions, if any remain, must be the closed declared set and must not be counted as passes.
10. Build a new evidence archive from the exact post-errata source commit using explicit `--format=tar.gz`; publish source commit, tree, SHA-256, member count, byte size, corpus digest, and fixture hashes. Do not overwrite the old artifact.
11. Obtain a targeted independent review that executes the new A1–A9 vectors on both codecs, verifies the Common Lisp A2/A9 patches, checks that canonical hex did not change, and reruns or independently inspects the new release receipt.

### 15.3 Re-audit threshold

A full repetition of the entire Fable audit is not required if the patch series is limited to the authorized errata, fixtures, documentation, and evidence regeneration, and the targeted review finds no divergence.

A broader re-audit becomes required if any of the following occurs:

- any expected canonical hex changes;
- any equality class changes;
- any previously valid canonical document changes validity;
- a new failure ambiguity or codec divergence appears;
- v1 or unrelated Mneme semantics change;
- generator or harness behavior changes beyond what the errata vectors require;
- the merge includes unrelated code.

---

## 16. Preconditions for v1 migration

Merge of the codecs is not authorization to replace the current v1 datum boundary. Migration may begin only after the post-errata codecs agree and the following work is explicit.

### 16.1 Stable adapter contracts

Versioned adapters must be defined for current v1 propositions, scopes, `as-of` values, event and principal identifiers, procedure references, predecessor-warrant testimony, receipt payloads, Language-A judgments, legacy `mneme-canon/0`, and current fingerprint inputs. Each mapping must retain the base specification's classification: exact, explicitly tagged, profile-adapted, rejected, or lossy with represented loss.

No adapter may infer identity from Common Lisp package stripping, printer spelling, `eq`, object addresses, process-local registries, SBCL float syntax, or MD5.

### 16.2 Inert versus privileged separation

Migration may move inert fields into CD/0. It may not turn live warrants, authenticated claims, capabilities, verifier authority, active receipts, closures, modules, pathnames, or handles into ordinary records and then revive them by shape. Any privileged transition must remain a separately authorized evaluator operation.

### 16.3 Identity workshop

Before replacing a v1 claim fingerprint, the project must separately decide:

- which location fields belong in ClaimId;
- which belong only in WarrantTarget;
- how `as-of`, intervals, scope, corpus and corpus version, policy, procedure, and lineage participate;
- how scope narrowing and subsumption work;
- whether migration creates a new artifact/claim identity or only lineage to an old digest.

CD/0 supplies the structural values and bytes; it does not answer those projections.

### 16.4 Migration vectors and dual-running

The migration phase must include shared legacy-to-CD/0 vectors, package-distinct identifier collisions, Unicode non-normalization cases, float/decimal represented forms, printer-setting variation, hostile legacy payloads, and represented-loss records. During transition, old and new identity inputs should be computed side by side and discrepancies classified rather than silently coerced.

### 16.5 Gates

The existing 6/6 v1 floor must remain green. Additional migration-specific gates must prove:

- deterministic CD/0 bytes in both codecs for every migrated inert value;
- no capability/warrant/receipt activation during decode;
- exact or explicitly represented-loss behavior for every legacy distinction;
- no ambient printer or package dependence;
- stable failure classification for rejected legacy inputs;
- no claim that legacy digests and new domain-separated IDs are automatically identical.

---

## 17. Remaining constitutional boundaries

This ruling closes the codec-level A1–A9 register. It does not close the larger Lisp+/Mneme constitution.

The following remain outside CD/0 and require separate decisions:

- complete located-claim identity and WarrantTarget projection;
- scope calculus, narrowing, subsumption, temporal interpretation, and admissibility;
- corpus and corpus-version identity;
- module identity, sealing, import/export authority, and module semantics versions;
- lexical binding and alpha-renaming identity;
- stable host-independent procedure and closure identity;
- checked effects and same-image Common Lisp isolation;
- capability minting, warrant issuance, authenticated-claim construction, and verifier authority;
- receipt state transitions, replay, custody, and non-transferability;
- Language-A and other profile schemas;
- cryptographic hashes, signatures, keys, trust roots, revocation, and Merkle envelopes;
- authenticated provenance, freshness, verified lineage, and represented-loss admissibility;
- deployment resource policies and portability beyond the audited hosts.

CD/0 canonicalization establishes none of truth, authority, authenticity, custody, freshness, admissibility, successful execution, or verified lineage. A malicious statement can be immutably and canonically encoded with exquisite precision; the codec's job is to keep its bytes honest, not to make its testimony true.

---

## 18. Concise Codex implementation/errata handoff

The authorized patch surface is narrow: adopt the errata as a companion document, write vectors first, patch Common Lisp A2/A9, update both fixture adapters for A7, promote A1/A2 expectations, close the append-only divergence rows, repair the four documentation findings, rerun all codec/differential/v1 floors, and publish a new immutable evidence receipt. No canonical hex, datum algebra, equality rule, v1 runtime semantics, located-claim rule, authority transition, or cryptographic design is authorized to change.

Any ambiguity encountered while applying the errata must be recorded with a failing, blocked, or divergent test. It must not be resolved by copying the other codec or by changing a vector to fit existing behavior.

---

## 19. Decision receipt

### 19.1 Constitutional receipt

```text
decision-id:                         CD0-POST-IMPLEMENTATION-RULING-2026-07-13
base-spec-sha256:                    d578e86e4d411611b091cca0bed1cafac2636c0908e95447fd4a13badcab6abc
errata-document:                     CANONICAL-DATUM-SPEC-ERRATA-0.1.md
errata-sha256:                       5f1568e53c4e6ef5fc8de2e125e7a6ef2d861392048c7ead144c7df05eb16271
audited-common-lisp:                 45eb60ce5b80485a0b287feab53ed3b58643b1b0
audited-python:                      29d0946ad78347015b9f0c65a2f528f039fdca78
audited-integration:                 baeecd5e0347435b9e1362000344f46ea441c6ec
audited-integration-tree:            41d3a71c06692174701bfde8f071e7da1c719651
published-archive-sha256:            af65596713533b29d90b28a75881de9473adec7a5dc91af9bd49830d52001949
contradicted-claims:                 none
unambiguous-wire-conformance-cl:     accepted
unambiguous-wire-conformance-python: accepted
immutable-runtime-contract:          accepted on audited surface
inert-decoding-contract:              accepted on audited surface
independence-wording:                independently seeded under shared normative infrastructure;
                                     procedural, not OS-enforced, isolation
A1:                                  normative erratum adopted
A2:                                  normative erratum adopted; Common Lisp patch required
A3:                                  normative erratum adopted
A4:                                  normative erratum adopted
A5:                                  normative erratum adopted
A6:                                  normative erratum adopted
A7:                                  fixture/harness defect corrected additively
A8:                                  normative erratum adopted
A9:                                  normative erratum adopted; Common Lisp patch required
canonical-octets-changed:            no
abstract-equality-changed:           no
accepted-canonical-documents-changed:no
datum-format-version-bump:           no; remains 0
publication-disposition:             accepted as published
merge-disposition:                   accepted after narrow errata, patches, vectors, and targeted verification
current-integration-tip-mergeable:   no, not unchanged
v1-migration-authorized:             no; prerequisites in Section 16
```

### 19.2 Paste-ready Codex relay

```text
Treat CANONICAL-DATUM-SPEC.md plus CANONICAL-DATUM-SPEC-ERRATA-0.1.md as normative.
Do not change the CD/0 algebra, equality, tags, byte grammar, canonical hex, Unicode rules,
record ordering, or format version.

1. Add shared conformance vectors for E0.1-1 through E0.1-9 before codec changes.
2. Correct A1 depth/node expected stages from container-content to type-tag, assign every
   provisional A1 stage from the errata matrix, and promote those rows to full triples.
3. Promote A2 host rows to full triples. Add zero-denominator, empty-segment, missing-path,
   duplicate-field, and bool-as-integer constructor/importer negatives.
4. Patch Common Lisp constructor/importer invariant failures to
   UnsupportedHostInput / specific-code / host-import.
5. Patch Common Lisp runtime encode so an already-valid datum enforces only
   max_output_octets, max_total_record_key_octets, and actual AllocationRefused; it must
   ignore decode/import structural budget fields.
6. Add the A7 construction descriptor {"op":"rational","p":"2","q":"4"} to the shared
   fixture schema and both fixture adapters without permitting unreduced rat datum ASTs.
7. Add exact A3 integer/rational bit boundaries, A4 aggregate segment boundaries, A5 tie
   cases, A6 key-tag cases, A8 complete-key-byte boundaries and nested accumulation, and
   A9 per-operation ignored/enforced-budget cases.
8. Append closure notes for A1-A9 to CANONICAL-DATUM-DIVERGENCES.md; preserve its history.
9. Add the concrete A2 split and seed-versus-tip provenance note to the publication docs;
   add a forward pointer beside superseded Phase-0 hashes.
10. Run Phase-0 verification, both complete codec suites, Phase-2 differential, Phase-4
    qualification, the full generated differential, mutation/inertness probes, all worked
    vectors, and the 6/6 v1 gate. Preserve exact commands, environment, stdout/stderr,
    exit codes, request arithmetic, N/A dispositions, corpus digest, and fixture hashes.
11. Require zero warranted disagreements with no A1/A2 field exclusions. Never count N/A
    as pass and never resolve a new mismatch by copying the other implementation.
12. Verify every pre-existing positive canonical_hex is byte-identical before and after.
13. Build a new release archive from the exact post-errata commit with
    git archive --format=tar.gz; publish source commit, tree, archive SHA-256, members,
    bytes, corpus digest, and commands. Do not overwrite the existing archive.
14. Obtain a targeted independent execution of the new A1-A9 vectors and Common Lisp
    A2/A9 witnesses before merging the successor cd0-integration commit into main.
15. Do not modify unrelated Mneme/v1 semantics and do not begin v1 migration in this patch.
```
