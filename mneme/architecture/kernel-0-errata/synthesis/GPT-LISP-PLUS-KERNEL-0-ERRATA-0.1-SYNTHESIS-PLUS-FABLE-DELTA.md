# GPT-LISP-PLUS-KERNEL-0-ERRATA-0.1-SYNTHESIS-CANDIDATE

**Status:** TWO-PARENT SYNTHESIS CANDIDATE — not adopted, not governing, not merged  
**Date:** 2026-07-19  
**Synthesis author:** GPT-5.6 Thinking  
**Parent G:** `GPT-LISP-PLUS-KERNEL-0-ERRATA-0.1-CANDIDATE.md`, SHA-256
`b0708a517e1ef985d0d78d4bed0bbf2fc3ef9fa96644d6549620e291826469b0`  
**Parent F:** `FABLE-LISP-PLUS-KERNEL-0-ERRATA-0.1-CANDIDATE.md`, SHA-256
`b09c5ead25104a27ee619802d175fc74e4251d8bf936b036f8d0ef4c9776ea34`  
**Fable decision ledger:** SHA-256 `689c748a2fd99150052a07b99a56e4187a47890ec31dfb1849114d32778be121`  
**Fable trace matrix:** SHA-256 `4d1a5fc79d7cf2dac6dfe2d379ab20e249bae61e3161b34cf409145ccf21bd8e`  
**Repository basis pinned by Parent F:**
`261122d15228c9214864fc3e28381c94651996b1`  
**Companion records:** `GPT-KERNEL-0-ERRATA-CONCORDANCE.md` and
`GPT-KERNEL-0-ERRATA-OPEN-FORKS.md`

This candidate adopts the GPT recommendations in the open-forks docket so that it is a
complete proposal rather than a pasteboard of alternatives. Every contested choice
remains labeled and may be reversed during the next Fable reconciliation or by the owner.

---

## 0. Governing effect, scope, and jurisdiction

Kernel /0, PJ0, and the repaired AP0 remain governing in their adopted scopes. This
erratum rides beside the sealed Kernel /0 specification unless the owner chooses a reissue.

Upon adoption, it amends or clarifies Kernel /0 §§7.3, 8.1, 9.1, 9.4, 9.5, 13.3, 13.5,
15, 18, 20, 22, 23, 24, 25, and Appendix A.2.

It closes the union of the relevant open ledgers:

1. bounded determinacy and call-296;
2. §23 reconstruction evidence and the missing `:attempt-indeterminate` event;
3. validation/integrity/visibility enforcement and exact constructor conditions;
4. structural-versus-semantic procedure law and AP-G4's Appendix A.2 mismatch.

PJ0 retains exclusive ownership of journal grammar, canonical rendering, framing, digests,
prefix validity, torn-tail classification, salvage bytes, merge format, and
reconstruction-receipt byte law.

AP0 retains exclusive ownership of adapter descriptors, envelope custody, projection
procedures, absence tables, stream/chunk value spaces, acknowledgment, cancellation,
reconciliation, usage/cost standing, and AP0 conditions.

This erratum does not change Canonical Datum /0 octets, PJ-S/0, PJ0 frames, AP0 vector
bytes, provider-specific meaning, Language-A classifications, or capability-authority law.

---

## 1. Determinacy and call-296

### 1.1 Declared alternative spaces

**K0E-1.** Every `:bounded` outcome-axis determinacy record MUST quantify over a declared
space and carry a finite, duplicate-free sequence of **at least two** complete,
distinguishable alternatives.

- execution, manifestation, and interpretation alternatives are complete values in their
  axis domains or durable identities resolving to complete values;
- a manifestation absence candidate has complete form
  `(:absent :state <absence-state>)`; a bare absence-state atom is invalid;
- effect-axis alternatives inhabit the settlement space of the referenced §10.8
  uncertain-effect record;
- claim-level determinacy remains a separate library protocol and is not enlarged here.

A violation signals `determinacy-alternatives-invalid`.

**K0E-2.** A singleton `:bounded` list is invalid for an outcome axis. If one current value
is positively licensed under the named procedure, the mode is `:determinate`. If no lawful
finite set of at least two complete alternatives can be named, the mode is
`:indeterminate` or the enclosing specification projection remains non-constructible.
**Kernel /0 §7.4 is amended to match: its sentence "`:indeterminate` means the kernel
cannot currently provide a lawful finite alternative set under the available evidence and
procedure" is REPLACED by "`:indeterminate` means the kernel cannot currently provide a
lawful finite alternative set of at least two complete alternatives under the available
evidence and procedure."** The three determinacy definitions (§7.2, §7.3 as amended by
K0E-1/K0E-2, §7.4 as amended here) are thereby boundary-consistent:
exactly-one-licensed ⇒ determinate; two-or-more-bounded ⇒ bounded; otherwise
indeterminate.

### 1.2 Membership and one-source uncertainty

**K0E-3.** When an axis carries a current value and bounded determinacy, the current value
MUST be a member of its alternatives, except that the effect-axis enum value `:bounded`
is checked through K0E-4.

**K0E-4.** A bounded effect axis MUST reference a §10.8 uncertain-effect record and its
determinacy alternatives MUST be set-identical under the named Kernel equality to that
record's `:possible-effects`.

### 1.3 Call-296

The byte-identical §22/A0.1 call-296 form remains the controlling historical projection.
It is not a complete constructible Kernel outcome.

**K0E-5.** The missing manifestation alternatives MUST NOT be repaired by either a bare
atom or the singleton:

```lisp
((:absent :state :absent-after-completion))
```

The complete call-296 outcome remains non-constructible until a sealed owner/evidence act:

1. supplies at least two complete licensed alternatives;
2. establishes one value and authorizes determinate concrete standing;
3. amends the closed absence-state vocabulary; or
4. explicitly adopts a different singleton-bounded law.

The existing pure-core singleton fixture remains historical pre-erratum evidence only and
MUST be quarantined from post-erratum conformance counts.

**K0E-5a.** Kernel /0 §23 is amended accordingly: the §22 call-296 row's obligation to
be *"constructed, journaled, killed-and-reconstructed, and re-derived byte-identically"*
is **STAYED** pending the K0E-5 sealed act. The stay is a **named exclusion** that MUST
appear, with this requirement ID, in every conformance report; a report that counts the
row as passed, or omits the exclusion, is nonconforming evidence. The synthetic K0E-6
fixture discharges the algebra-coverage intent of the row during the stay. All twelve
remaining §23 rows keep their full obligation unchanged.

**K0E-6.** The test suite MUST preserve separately:

- the historical call-296 projection;
- a synthetic bounded-manifestation fixture with at least two complete alternatives and
  synthetic evidence;
- later Language-A factual classification, which remains in its sealed lane.

**K0E-7.** Record `:absence-state-name-presupposes-completion` as an unresolved
**architecture-level** unknown, at its true scale: the limit is a **row-class** problem,
not a call-296 quirk. Architecture 0.1 §17's "uncertain write" row itself classifies the
manifestation as *"bounded or absent-so-far,"* and §13.8's tail-could-contain-settlement
cases raise the same need on the manifestation axis — in every such case the second
complete alternative is unnameable under the closed vocabulary without a payload identity
(§9.6). Until an Architecture 0.1 act amends the absence-state vocabulary (or otherwise
supplies the missing law), every uncertain-write-shaped manifestation axis carries this
bounded unknown and falls under the K0E-2 non-constructibility/indeterminate branch rather
than a derived singleton. This erratum does not invent a new absence state (§28 stops 1
and 3).

---

## 2. PJ0 reconstruction evidence and process events

### 2.1 Six distinct standings

**K0E-8.** Every §23 row's evidence distinguishes:

1. PJ0 structural validity of the byte prefix;
2. Kernel semantic validity of the decoded event sequence;
3. source-frame identity within one store;
4. deterministic semantic replay identity of the fold-derived view;
5. reconstruction-receipt identity and deterministic field agreement;
6. abstract event identity across lawful salvage/merge transformations.

A structurally valid frame containing a Kernel-illegal event remains structurally present
and causes the Kernel fold to refuse. It is not relabeled as a torn tail or skipped.

### 2.2 Terminal-row evidence bundle

**K0E-9.** Each normative terminal row MUST bind or deterministically derive:

```lisp
(:kernel-pj0-fixture
  :fixture-id ...
  :kernel-row-id ...
  :source-store-id ...
  :durability-mode ...
  :source-prefix-coordinate
    (:terminal-ordinal ...
     :terminal-frame-digest ...
     :valid-byte-count ...)
  :append-receipt-ids (...)        ; PJ0 append receipts BY REFERENCE (PJ0 §9.4);
                                   ; never restated frame bytes — no second grammar
  :event-ids (...)
  :event-payload-digests (...)
  :kill-point-id ...
  :crash-window-id ...
  :post-kill-validation-report-id ...
  :tail-evidence-id ...
  :derived-artifact-deletion-attestation-id ...
  :fold-id ...
  :fold-version ...
  :expected-view-id ...
  :expected-view-digest ...
  :comparison-policy-id ...
  :reconstruction-receipt-id ...
  :kernel-semantic-verdict ...
  :required-conditions (...)
  :bounded-unknowns (...))
```

The durable rendering belongs to PJ0.

**K0E-10.** “Journaled” means present in a committed PJ0-valid frame, not merely in memory
or an operating-system buffer.

**K0E-11.** “Killed and reconstructed” means a fresh host process starts from byte zero,
validates the source, selects the maximal valid prefix, excludes all finalizer products,
caches, indexes, and snapshots, performs the named fold, and emits a reconstruction
receipt.

**K0E-12.** The source store remains byte-identical during validation/reconstruction.
Torn-tail bytes remain visible; recovery never truncates the source.

### 2.3 Comparison law

**K0E-13.**

- source-frame bytes are identical only within the unchanged source store;
- §23 byte identity compares canonical derived-view bytes under the named deterministic
  fold/rendering;
- reconstruction receipts are compared fieldwise for deterministic source-binding and
  output fields; act-specific identity, operator, host, and environment fields vary only
  as declared by the comparison policy;
- salvage and merge produce new stores and regenerated frame chains; their relation is
  proven by receipts and abstract event identity, not source-frame equality.

Pretty-printed host objects are not a canonical comparison.

### 2.4 Tail, corruption, salvage, merge

**K0E-14.** The joint suite preserves PJ0's exact terminal classification and does not
scan forward after corruption.

**K0E-15.** At least one fixture MUST show a torn tail whose possible consequential
settlement record causes bounded/indeterminate standing in the Kernel fold.

**K0E-16.** At least one fixture MUST show salvage preserving abstract events and replay
identity while frame/store identity changes.

### 2.5 `:attempt-indeterminate`

**K0E-17.** Add `:attempt-indeterminate` to §13.3.

It:

- may occur only after `:attempt-begun`;
- is a terminal attempt event;
- references the evidence preventing determinate terminal classification;
- commonly references an `:effect-bounded`, `:effect-indeterminate`, uncertain-effect, or
  torn-tail report;
- does not resolve an uncertain effect;
- cannot be followed by a second terminal event except reconciliation metadata that does
  not rewrite history.

Nothing in this section defines journal bytes.

---

## 3. Claim standing

### 3.1 Validation

**K0E-18.** A validation record binds:

```lisp
(validation
  :status :unchecked|:checked|:verified|:refuted
  :subject-id ...
  :validator-principal-id ...
  :procedure-id ...
  :procedure-version ...
  :scope ...
  :evidence (...)
  :bounded-unknowns (...))
```

`:verified` and `:refuted` require every field and non-empty evidence.
`:checked` requires subject, validator, procedure/version, and scope; an empty evidence list
is lawful only when the named procedure defines an inspectable negative check over
preserved inputs. `:unchecked` still names subject and scope.

Bare strong standing signals `bare-validation-scope`.

### 3.2 Integrity

**K0E-19.** An integrity record binds:

```lisp
(integrity
  :status :open|:sealed
  :subject-id ...
  :representation-id ...
  :method-id ...
  :method-version ...
  :sealing-principal-id ...
  :evidence (...)
  :bounded-unknowns (...))
```

A seal establishes only the named identity/bytes/chain integrity relation. It does not
establish truth, validation, origin, semantic acceptance, or visibility.

### 3.3 Visibility

**K0E-20.** A visibility record binds:

```lisp
(visibility
  :status :published|:withheld|:redacted
  :subject-id ...
  :representation-id ...
  :scope-id ...
  :authorizing-basis ...
  :redaction-receipt-id ...
  :evidence (...)
  :bounded-unknowns (...))
```

`:published` requires a non-empty relational scope.
`:withheld` and `:redacted` require scope and basis.
`:redacted` requires a transformation receipt.

Bare publication signals `bare-visibility-scope`.

The `:authorizing-basis` field is a **reference, granting nothing**: it names the
capability fingerprint or claim identity under which the visibility act was authorized,
and confers no authority itself. Capability-authority law is unchanged by this erratum.

### 3.4 Orthogonality and transformation

**K0E-21.** Origin, validation, integrity, visibility, and determinacy do not construct or
upgrade one another.

A genuinely new transformed claim/representation:

- receives a new identity;
- has output origin `:derived`;
- preserves the source claim's origin in provenance;
- receives no transferred integrity standing;
- receives validation only where the original procedure's explicit scope and a
  transformation receipt license transfer;
- receives visibility only through a new scoped visibility record.

A byte-identical alias to the same claim identity is not a transformation.

**K0E-22.** Kernel /0 MUST NOT expose context-free `verified-p` or `published-p`
accessors. Queries bind procedure/scope, for example:

```lisp
(claim-validated-under-p claim procedure-id scope)
(claim-published-to-p claim scope-id)
```

### 3.5 Executable tests

K0E-18..22 make tests 43, 44, 47, and 48 executable and require planted promotions for
sealed→verified and published→true/accepted/observed.

---

## 4. Structural versus semantic validation

### 4.1 Procedure descriptor

**K0E-23.** Every interpretation procedure identity/version resolves to:

```lisp
(procedure-descriptor
  :procedure-id ...
  :version ...
  :judgment-class :structural|:semantic
  :input-domain ...
  :result-vocabulary (...)
  :evidence-requirements (...)
  :bounded-unknowns (...))
```

A reference site MAY cache `:judgment-class`, but the cached value MUST equal the
descriptor. One identity/version cannot change class by caller. A tool performing both
classes exposes separate procedure identities or versions.

### 4.2 Structural jurisdiction

**K0E-24.** AP0 structural procedures may establish:

- envelope custody and integrity;
- parser/decoder result under a named procedure;
- selectors and exhaustive absence-table application;
- structural manifestation status;
- payload or no-payload identity;
- adapter identity;
- stream/chunk relation;
- projection receipt and derived origin;
- declared losses, bounded unknowns, and structural failure.

They do not establish truth, answer quality, semantic acceptance/rejection, claim
verification, billing from estimates, or effect settlement beyond separately admissible
evidence.

### 4.3 Kernel and domain-semantic jurisdiction

**K0E-25.** Kernel semantic validation checks outcome algebra, per-axis determinacy,
identities, transition legality, effect/frontier/retry law, manifestation field relations,
standing law, and procedure-domain legality.

`:accepted` and `:rejected` require:

1. `:present` or `:present-empty`;
2. a semantic procedure descriptor;
3. a domain accepting that manifestation kind/status;
4. the procedure's required evidence.

`:invalid` may be licensed by a structural or semantic procedure. A `:present-invalid`
manifestation preserves payload and parser identity and cannot be relabeled accepted or
rejected without a receipt-bearing transformation into the semantic procedure's domain.

### 4.4 Joint report

**K0E-26.** A joint AP0+Kernel report carries at least:

```lisp
(:structural-verdict
  (:value :pass|:fail|:not-run
   :procedure-id ...
   :condition-ids (...)
   :requirement-ids (...))
 :semantic-verdict
  (:value :pass|:fail|:not-run
   :procedure-id ...
   :condition-ids (...)
   :requirement-ids (...)))
```

Structural PASS / semantic FAIL is lawful and survives aggregation. A single green counter
is nonconforming evidence.

Absent a semantic procedure run, interpretation does not default to accepted.

---

## 5. Appendix A.2 replacement

Replace Appendix A.2 with:

```lisp
(manifestation
  :manifestation-id ...
  :attempt-id ...
  :kind ...
  :status :present|:present-empty|:present-invalid|:present-partial|
          :absent|:withheld|:redacted

  :payload-id ...
  :absence-state ...
  :parser-procedure-id ...
  :emptiness-rule-id ...
  :source-boundary ...

  :adapter-identity ...      ; required iff AP0-produced
  :producer-identity ...     ; required iff not AP0-produced

  :stream-relation           ; required iff streamed
    (:stream-id ...
     :relation-kind :direct-chunk|:aggregate|:projection
     :chunk-record-ids (...)
     :projection-receipt-id ...)

  :visibility (...))
```

This is a semantic sketch, not a byte schema.

**K0E-27.** Exactly one producer branch is present:

- AP0-produced → `:adapter-identity`;
- non-AP0-produced → `:producer-identity`.

The durable adapter identity resolves to its descriptor/version.

**K0E-28.** A streamed manifestation carries a non-empty ordered list of AP0 chunk or
checkpoint record identities. The referenced records remain the authority for sequence,
predecessor, payload count, finality evidence, persistence order, gaps, duplicates,
collisions, adapter identity, and attempt identity.

**K0E-28a.** The §21 inspection surface MUST traverse the stream relation: a conforming
inspector reaches the referenced chunk records' sequence, predecessor, finality, and
adapter-identity evidence starting from the manifestation record, without requiring the
caller to negotiate a separate store contract. Reference-based lineage is lawful because
it remains inspectable; a reference a conforming inspector cannot resolve is a missing
relation, not a lean one.

**K0E-29.** Kernel validates that all referenced chunk records belong to the same declared
stream and lawful attempt/adapter relation.

**K0E-30.** `:projection-receipt-id` is required whenever output is aggregated,
concatenated, normalized, decoded, batched, or otherwise derived from one or more chunks.
It may be omitted only for direct identity with one captured chunk.

**K0E-31.** Captured partials are never erased by absence, cancellation, parser failure,
or missing finality. A stream with captured chunks and no lawful terminal settlement is
`:present-partial`.

**K0E-32.** A non-stream manifestation omits `:stream-relation`. A bare `streamed-p`,
generic source label, sequence count without identities, or duplicated host-only chunk
list is insufficient.

AP0 owns exact field value spaces and AP0 conditions.

---

## 6. Conditions

Add:

```lisp
malformed-constructor-shape
determinacy-mode-invalid
determinacy-alternatives-invalid
global-uncertainty-scalar-rejected
interpretation-class-violation
```

**K0E-33.**

- malformed fields, duplicate/unknown fields, or missing Kernel-only required producer/
  stream fields → `malformed-constructor-shape`;
- illegal modes, alternatives on non-bounded modes, or empty sets →
  `determinacy-mode-invalid`;
- cardinality-one outcome alternatives, wrong domain/form, membership failure, or
  effect-set mismatch → `determinacy-alternatives-invalid`;
- global confidence/uncertainty/probability scalar →
  `global-uncertainty-scalar-rejected`;
- structural procedure licensing accepted/rejected →
  `interpretation-class-violation`.

AP0-produced identity/stream violations use the adopted AP0 conditions where applicable.

`standing-inflation` remains reserved for actual epistemic promotion. The pure core's
earlier use as a generic typed refusal remains valid historical evidence for its declared
pre-erratum subset but is not the post-erratum condition surface.

---

## 7. Implementation charge

After adoption, modify at least:

- `conditions.lisp`;
- `determinacy.lisp`;
- `outcome.lisp`;
- `manifestation.lisp`;
- `records.lisp`;
- `uncertain-effect.lisp`;
- `fixtures.lisp`;
- `folds.lisp`;
- `kernel0-selftest.lisp`;
- `package.lisp`;
- `README.md`.

The independently seeded Common Lisp PJ0/AP0 implementation MUST be written from governing
specifications and frozen vectors. It MUST NOT import, translate, mechanically port,
embed, or line-by-line imitate the Python generator, serializer, parser, validator,
fake-adapter state machine, or expected-result computation.

Divergences adjudicate to specification text.

---

## 8. Required controls

The post-erratum suite includes, at minimum:

1. singleton outcome-axis bounded set refused;
2. bare-atom alternative refused;
3. wrong-domain alternative refused;
4. current value outside alternatives refused;
5. effect alternatives differing from `:possible-effects` refused;
6. call-296 singleton not counted as complete conformance;
7. synthetic two-alternative bounded manifestation accepted;
8. unauthorized effect narrowing refused;
9. `:attempt-indeterminate` transition-order violations refused;
10. semantic-illegal event inside structurally valid PJ0 prefix reported as dual standing;
11. reconstruction skipping corruption refused;
12. derived-artifact deletion attestation required;
13. torn tail preserved and capable of yielding bounded standing;
14. salvage changes frame identity but preserves abstract events/replay;
15. sealed→verified mutant killed;
16. published→true/accepted/observed mutant killed;
17. bare verified/published refused;
18. integrity copied to mismatched representation refused;
19. context-free standing accessor rejected;
20. structural procedure licensing accepted/rejected refused;
21. joint verdict flattening rejected;
22. AP0-produced manifestation missing adapter identity refused;
23. non-AP0 manifestation missing producer identity refused;
24. streamed manifestation missing chunk relation refused;
25. aggregate without receipt refused;
26. partial erasure mutant killed;
27. missing emptiness rule for present-empty refused;
28. global scalar refused;
29. all planted defects fail for the intended requirement.

---

## 9. What adoption would not prove

Adoption alone does not prove:

- independent CL PJ0 conformance;
- independent CL AP0 conformance;
- a working journal store;
- crash durability;
- live capability safety;
- fake-adapter conformance;
- vertical-specimen success;
- stranger primitive-minimization;
- Language-A factual classification;
- live-provider authorization;
- primitive minimality;
- independent validation of the final combined system.

The call-296 complete-outcome row remains excluded under this synthesis candidate until
FORK-1/FORK-2 receive a different owner disposition or the missing architecture law is
supplied.

---

## 10. Adoption-record sketch

```lisp
(:kernel-erratum-adoption
  :artifact "LISP-PLUS-KERNEL-0-ERRATA-0.1.md"
  :artifact-sha256 ...
  :adopted-by ...
  :adoption-time ...
  :parent-candidates
    ((:artifact "GPT-LISP-PLUS-KERNEL-0-ERRATA-0.1-CANDIDATE.md"
      :sha256 "b0708a517e1ef985d0d78d4bed0bbf2fc3ef9fa96644d6549620e291826469b0")
     (:artifact "FABLE-LISP-PLUS-KERNEL-0-ERRATA-0.1-CANDIDATE.md"
      :sha256 "b09c5ead25104a27ee619802d175fc74e4251d8bf936b036f8d0ef4c9776ea34"))
  :concordance-id ...
  :open-forks-disposition-id ...
  :repository-commit "261122d15228c9214864fc3e28381c94651996b1"
  :governing-effect :rides-beside
  :gap-dispositions (...)
  :requirement-dispositions (...)
  :unchanged-artifacts (...)
  :remaining-gates
    (:independent-cl-pj0
     :independent-cl-ap0
     :vertical-specimen
     :hostile-review
     :stranger-audit)
  :bounded-unknowns
    (:call-296-completion-presupposition
     :call-296-complete-outcome-not-constructible))
```

Until that record exists, this remains one synthesis proposal in a two-synthesis
reconciliation process.
