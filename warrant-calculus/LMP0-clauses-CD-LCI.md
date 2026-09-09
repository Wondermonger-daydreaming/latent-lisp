*PUBLIC READER'S NOTE (prepended at publication, 2026-09-08). The body below the `---` rule is byte-identical to the lab source; see PROVENANCE.md for its blob hash and the strip recipe. Paths of the form `corpus/voices/received/originals/…` name the lab's private archive of the outside reviewer's (Astra's) letters; the operative text of every letter is quoted verbatim inside these documents. "The stone" = `../mneme/architecture/ARCHITECTURE-0-STATUS.md`, which is in this tree. "The report", "the parcel", "the cover", "the bridge", "the front door" and "the freezer" name lab working documents and the storage of the underlying SAT proofs, which are not published; the public account of that proof is `../shannon-synthesis-0/README.md`. Paths written `experiments/latent-lisp/…` are relative to this tree's root. LCI/0's CLOSED standing is sourced here to an owner ruling ("LCI/0 remains CLOSED; D2 DEFERRED INDEFINITELY") whose operative sentence is quoted in full but whose source document is not published; the standing is checkable as quoted text, not against its source.*

---

# LMP/0 collision test — the CD/0 and LCI/0 reading

**Clerk:** CLERK-CD-LCI (Claude Fable 5.1), 2026-09-08 (`date`: Tue Sep 8 03:14:35 PM -03 2026 / 2026-09-08T18:14:35Z)
**Charge:** identify the authoritative texts for **Canonical Datum /0 (CD/0)** and **Located Claim Identity /0 (LCI/0)**; quote verbatim the clauses bearing on questions (a)–(e); name the silences.
**Register:** quote, cite, never paraphrase upward. Every marking of the form "bears on (x)" is the clerk's; every indented or fenced block is the source text.
**Repo tip at reading:** `b234a3bc` (working tree clean at session start).

---

## SOURCES

### Legend for the status column

Quotes in the status column are **verbatim from the named status-bearing document**, with its file:line. A blank quote means *no status sentence for this artifact was found in the document the charge named*; see UNVERIFIED §U1.

| # | Path | `git log -1` (commit · date) | blob sha (`git hash-object`) | Status quote (verbatim, with source) |
|---|---|---|---|---|
| S1 | `experiments/latent-lisp/mneme/spec/CANONICAL-DATUM-SPEC.md` | `1d3021de` 2026-07-13 | `f8330a7fe29fbfb971da3b64822c6178baf7cc3c` | Self-declared: **"Status:** Normative design for clean-room codec implementation" (`CANONICAL-DATUM-SPEC.md:4`). External: **"Lisp+ Canonical Datum /0 is frozen at the accepted merge"** (`CD0-FREEZE-DECLARATION.md:7`); **"Status: **FROZEN**"** (`:5`). Architecture 0.1: **"CD/0 is the durable value and wire substrate. Architecture 0.1 does not alter its frozen semantics."** (`LISP-PLUS-LATENT-MACHINE-ARCHITECTURE-0.1.md:1224`) → **AUTHORITATIVE / FROZEN** |
| S2 | `experiments/latent-lisp/CANONICAL-DATUM-SPEC-ERRATA-0.1.md` | `e35be69d` 2026-07-13 | `5ea6d9fb430a2e2e886ddb0200491306aefabe2a` | **"Status:** Normative errata to Lisp+ Canonical Datum /0" (`:4`); **"A conformance claim made after adoption of Errata 0.1 is a claim against the base specification plus this document."** (`:13`); included in the freeze: **"the normative post-implementation ruling and Errata 0.1;"** (`CD0-FREEZE-DECLARATION.md:29`) → **AUTHORITATIVE / FROZEN** |
| S3 | `experiments/latent-lisp/CD0-POST-IMPLEMENTATION-RULING.md` | `e35be69d` 2026-07-13 | `4c31d761adadbfbfccb07d03faa8fc12bc54f8c3` | Same freeze clause as S2 (`CD0-FREEZE-DECLARATION.md:29`) → **AUTHORITATIVE / FROZEN** (not read in full this sitting; see UNVERIFIED §U4) |
| S4 | `experiments/latent-lisp/CD0-FREEZE-DECLARATION.md` | `e35be69d` 2026-07-13 | `949fddbe63fb759949f158c11b56bf80e6a0a18e` | **"Status: **FROZEN**"** (`:5`) → **AUTHORITATIVE (status instrument)** |
| S5 | `experiments/latent-lisp/mneme/lci0/spec/LOCATED-CLAIM-IDENTITY-SPEC.md` | `fb0dc622` 2026-07-15 | `f7d3ef4e30d51d346fdd3c88e2f0097487411308` | Self-declared: **"Status:** constitutional design decision; implementation-independent normative specification" (`:5`). Owner ruling: **"**LCI/0 remains CLOSED; D2 DEFERRED INDEFINITELY.**"** (`ARCHITECTURE-0-STATUS.md:1317`, ADDENDUM 22 item 6) → **AUTHORITATIVE / CLOSED** |
| S6 | `experiments/latent-lisp/mneme/lci0/spec/LOCATED-CLAIM-IDENTITY-SPEC-ERRATA-0.1.md` | `fb0dc622` 2026-07-15 | `fb2539d0e4fef3d4638d029688ecdc8e69e5005b` | **"Status:** NORMATIVE NARROW ERRATA" (`:6`); **"Applies to:** `LOCATED-CLAIM-IDENTITY-SPEC.md` SHA-256 `6fa2965ed727b4d89b09a3d9c171bcfa3aea8c23f486ef87dc33f85bcb9ae5ba`" (`:4`) → **AUTHORITATIVE** |
| S7 | `experiments/latent-lisp/mneme/lci0/spec/LCI0-POST-REVIEW-RULING.md` | `fb0dc622` 2026-07-15 | `1a65c1b2d2d2ce7cc4b4718ecf8138014634afb5` | **"Status:** AUTHORIAL CONSTITUTIONAL RULING AFTER INDEPENDENT FABLE REVIEW" (`:5`) → **AUTHORITATIVE (ruling)** |
| S8 | `experiments/latent-lisp/mneme/lci0/spec/LCI0-NORMATIVE-FIXTURE-PACKAGE-SPEC.md` | `fb0dc622` 2026-07-15 | `d332d9455642bee8d23d9140bb123feb4642bd6d` | Incorporated by S6: **"`LCI0-NORMATIVE-FIXTURE-PACKAGE-SPEC.md`, `LCI0-FIXTURE-REGISTRY.json`, and `LCI0-FIXTURE-VECTORS.jsonl` are normatively incorporated wherever this errata delegates a first-profile value, schema, algorithm, table, or vector."** (`LOCATED-CLAIM-IDENTITY-SPEC-ERRATA-0.1.md:14`) → **AUTHORITATIVE BY INCORPORATION** (not read this sitting; §U4) |
| S9 | `experiments/latent-lisp/mneme/lci0/README.md` | `fb0dc622` 2026-07-15 | `c84fe0e40ebf165a312d7b9b8deeafa1a31baabf` | Lane self-report: **"the bounded disposition is: unaffected implementation and evidence are ready for independent audit; overall LCI/0 conformance remains blocked pending authorial closure. This is not a merge-eligibility claim."** (`:36–38`) → **LANE REPORT, not a governing status** |
| S10 | `experiments/latent-lisp/mneme/lci0/audit/README.md` | `bedb279b` 2026-07-15 | `8f1eca20c6d69f35794056a5bd491320b0f47e08` | **"This directory is audit infrastructure only. It does not alter relation, matching, policy, validation, fixture, vector, or CD/0 behavior."** (`:3–4`) → **AUDIT INFRASTRUCTURE** |
| S11 | `experiments/latent-lisp/mneme/lci0/audit/law_audit.py` | `bedb279b` 2026-07-15 | `0597bd8c731a117813165829d9922ea05b951427` | Harness; emits the audit verdict string (`:771–772`) → **AUDIT INFRASTRUCTURE** |
| S12 | `experiments/latent-lisp/mneme/canon/CANONICAL-SPEC-v0-DRAFT.md` | `5ebdde15` 2026-07-11 | `812412d06135df41d7d86b4efffcdfd19e87d2a4` | **"> **STATUS: DRAFT — every decision below is REVISABLE-UNTIL-FROZEN.** > A freezer ratifies this spec later; until then each `D-CANON-nn` is a proposal with a rationale, not a settled law."** (`:8–10`) → **DRAFT / PROPOSAL — NOT CD/0** (it specifies `mneme-canon/0`, a different artifact; see §U2) |
| S13 | `experiments/latent-lisp/mneme/language-surface-account-0/CD0-INSPECTION-RECORD-SCHEMA.md` | `d1ecbd96` 2026-08-05 | `5c8f5272c8890e6d46a9524da3c247d4da0a0cf3` | **"**Standing.** Proposed design, not implemented; the schema binds the future production round."** (`:37–38`); also **"**This file is the authoritative schema.** Contract I.8b defers to it; where any prose elsewhere disagrees, these tables win."** (`:5–7`) → **PROPOSAL within Surface Account /0; downstream CONSUMER of CD/0, not a CD/0 source** |
| S14 | `experiments/latent-lisp/mneme/architecture/ARCHITECTURE-0-STATUS.md` | `e94fea62` 2026-09-01 | `504be2204474bd657e5446bb503ee8a3fcd2613f` | Status instrument itself. |
| S15 | `experiments/latent-lisp/mneme/verify-release.sh` | `ad6c95e9` 2026-08-23 | `fb99a6b64c77640b1dd81a8bf39f5673c22856a4` | Carried DECLARED row, verbatim at `:360` — quoted in full in **LCI/0 §3** below. |
| S16 | `corpus/voices/received/2026-08-30-joint-return-owner-and-sol-succession-census-01-ACCEPTED-q1-o1-o3-ruled.md` | `c42b1a54` 2026-08-30 | `f5868b6391f001574d048834ae719f11c9d81e9c` | Owner ruling O2, verbatim at `:74–80` — quoted in **LCI/0 §3** below. |
| S17 | `experiments/latent-lisp/mneme/architecture/LISP-PLUS-LATENT-MACHINE-ARCHITECTURE-0.1.md` | `f7583616` 2026-07-18 | `1c3f307b8f8cf1417801bc33fab95cbe4fdbe333` | Governing architecture; its CD/0 status sentence quoted in S1 row. |

### Hash cross-check performed (not merely cited)

Three normative source hashes are asserted inside LCI/0's own decision receipt (`LOCATED-CLAIM-IDENTITY-SPEC.md:3435–3446`, §30.4). The clerk computed `sha256sum` on the working tree and compared:

| Artifact | Hash asserted in LCI §30.4 / errata header | Computed on this tree | Match |
|---|---|---|---|
| `mneme/spec/CANONICAL-DATUM-SPEC.md` | `d578e86e4d411611b091cca0bed1cafac2636c0908e95447fd4a13badcab6abc` | `d578e86e…cab6abc` | **YES** |
| `CANONICAL-DATUM-SPEC-ERRATA-0.1.md` | `5f1568e53c4e6ef5fc8de2e125e7a6ef2d861392048c7ead144c7df05eb16271` | `5f1568e5…b16271` | **YES** |
| `CD0-POST-IMPLEMENTATION-RULING.md` | `1a0e8ff844790c93e681f7541a23266aa73d2ee8e9ca9a6e0d753bf4e044b2bc` | `1a0e8ff8…44b2bc` | **YES** |
| `LOCATED-CLAIM-IDENTITY-SPEC.md` (candidate hash in S6 header and `LCI0-POST-REVIEW-RULING.md:7`) | `6fa2965ed727b4d89b09a3d9c171bcfa3aea8c23f486ef87dc33f85bcb9ae5ba` | `6fa2965e…b9ae5ba` | **YES** |
| `lci0/audit/LCI0-ALGEBRAIC-LAW-AUDIT-EVIDENCE.zip` vs its `.sha256` sidecar | `798a28ddf2d08bff05807fcfb2464eb6db718ac15bb387eb2c30a349f5c78f83` | same | **YES** |

Ceiling on that check: it establishes **byte identity between the tree copy and the identity each document asserts for itself or its dependency**. It establishes nothing about adoption, correctness, or conformance.

---

## CD/0 CLAUSES

Source unless otherwise marked: `experiments/latent-lisp/mneme/spec/CANONICAL-DATUM-SPEC.md` (S1). Errata quotes are marked **[ERRATA]** and cite `experiments/latent-lisp/CANONICAL-DATUM-SPEC-ERRATA-0.1.md` (S2).

### (a) What may become a Datum — serialization/transmission boundary; what is refused; hashing/identity of datums

**`:15`** — the closed family list. Bears on (a).
> Lisp+ Canonical Datum /0 is a small, inert, implementation-independent value algebra with one canonical binary encoding. It contains exactly these abstract value families:

**`:17–25`**
> 1. unit;
> 2. booleans;
> 3. arbitrary-precision signed integers;
> 4. exact reduced rational numbers that are not integers;
> 5. Unicode scalar strings;
> 6. raw byte strings;
> 7. explicitly namespaced, segmented identifiers;
> 8. ordered sequences; and
> 9. identifier-keyed records.

**`:29`** and **`:31–35`** — identity of datums. Bears on (a).
> The abstract datum algebra defines which values exist and what equality means. Canonical octets are the sole normative cross-process and cross-implementation witness of that equality. For valid /0 datums:
>
> ```text
> equal-datum(x, y)
>     if and only if
> canonical-octets(x) = canonical-octets(y)
> ```

**`:37`** — what identity is *not*. Bears on (a).
> At protocol boundaries, identity comparison MUST therefore be performed on successfully validated canonical octets, or by an equality operation proven equivalent to that octet comparison. Host pointer identity, Common Lisp package identity, Python object identity, printer output, diagnostic notation, and hash equality are not semantic identity.

**`:39`** — the exclusion list. Bears on (a).
> Canonical Datum /0 deliberately excludes native floating-point values, decimals, general maps, sets, graph identity, cyclic values, host symbols, pathnames, closures, modules, capabilities, warrants, active receipts, and generic opaque extension values. Profiles can represent several excluded informational values as ordinary explicit records, but no record shape can create live authority.

**`:41`** — what the decoder refuses. Bears on (a).
> The canonical encoding is a compact, purpose-built binary grammar beginning with the ASCII magic `LPCD` and unsigned format version `0`. […] A /0 decoder accepts canonical documents only. It rejects nonminimal forms, duplicate fields, out-of-order fields, malformed UTF-8, trailing bytes, unknown tags, and unsupported versions rather than repairing them silently.

**`:57`** and **`:59–67`** — the intended-use list (a datum's downstream consumers). Bears on (a) and (c).
> CD/0 is suitable as the inert substrate for:
>
> - claim propositions and claim-location components;
> - scopes and temporal-boundary records;
> - names, module references, and procedure-reference records;
> - warrant-target components and inert warrant testimony;
> - artifact manifests and evidence-edge payloads;
> - represented-loss reports;
> - Language-A and later profile records;
> - cross-process and cross-implementation identity;
> - future content-addressing, signature inputs, and Merkle payloads.

**`:69`** — the suitability ceiling. Bears on (a).
> Suitability means that these consumers can express their inert fields as CD/0 values. It does not mean that CD/0 defines those consumers' schemas or semantics.

**`:92`** — the inertness boundary (the transmission boundary proper). Bears on (a) and (b).
> Decoding canonical octets MUST return only ordinary inert CD/0 values represented by the codec's fixed private runtime types. Beyond those inert representation nodes, it MUST NOT construct, restore, activate, or mint a capability, live warrant, authenticated claim, verifier authority, authority grant, active receipt, closure, module, file handle, socket, pathname, continuation, restart object, arbitrary source-specified host-language object, or evaluator-owned privileged value.

**`:94`** — shape does not mint privilege. Bears on (a) and (b).
> A privileged Lisp+ value may contain CD/0 fields. The privileged value itself is outside CD/0. A record whose fields spell "capability," "warrant," "receipt," "certificate," "authority," or any similar word remains an ordinary record. A separate evaluator transition may inspect such data and produce a privileged value only under separately specified authority and semantics.

**`:410`** — how the exclusion table is to be read. Bears on (a).
> The table favors a small core. Exclusion does not imply that the information is forbidden; it means the information must be made explicit through stable primitive values and a profile schema rather than inherited from a host object.

Rows of §9 (`:370–408`) that bear directly on (a) for warrant vocabulary:
> | Capabilities and authority grants | Permanently outside canonical inert data | Descriptive records remain inert; live capability is nominal and evaluator-owned. | Privileged behavior. |
> | Live warrants and authenticated claims | Permanently outside canonical inert data | Inert testimony/claim records are data; authenticated runtime values are not. | Privileged behavior and authenticity. |
> | Active receipts, file handles, sockets, continuations, restarts | Permanently outside canonical inert data | Descriptive data only. | Privileged behavior, process locality, and mutable external state. |

**`:994`** — the encoder's admission rule. Bears on (a).
> `encode-exact` accepts only a valid immutable CD/0 runtime datum. Conversion from arbitrary host objects is a separate importer. An implementation may expose convenience constructors, but those constructors MUST establish the abstract type explicitly and must not infer ambiguous meanings from host values.

**`:1043`** — refusal of a live value at the boundary. Bears on (a) and (b).
> Unsupported ordinary host input fails with `UnsupportedHostType` or a more specific host-input failure. An evaluator-owned privileged value passed directly to the core encoder fails with `PrivilegedHostValue`. A caller may separately project approved inert fields into a record, but that projection is a privileged-layer operation and does not serialize the live value itself.

### (b) Statuses / epistemic markers, and who may set them

**CD/0 defines no epistemic status vocabulary. Its only typed vocabulary is a failure vocabulary.** The clauses:

**`:1177–1183`** — the failure record's fields. Bears on (b).
> Every conformance failure has at least:
>
> ```text
> category : one of the seven categories below
> code     : stable symbolic code
> stage    : stable parse/encode stage
> ```

**`:1189–1199`** — the seven categories, complete. Bears on (b).
> | `InvalidCanonicalGrammar` | Input does not describe one valid CD/0 abstract datum/document. |
> | `NoncanonicalEncoding` | Input describes a value only after a forbidden canonical repair. |
> | `UnsupportedFormat` | The document belongs to a future, unknown, or unsupported format/extension. |
> | `ResourceRefusal` | An explicit budget or allocation limit prevents safe processing. |
> | `UnsupportedHostInput` | An encoder/importer received a host value outside its declared mapping. |
> | `PrivilegedRestorationAttempt` | Input requests or uses a representation reserved for live privileged values. The category describes the prohibited representation class, not the sender's subjective intent. |
> | `InternalInvariantFailure` | The implementation's own retained representations disagree or an impossible internal state is detected. |

**`:1185`** — where the conformance surface lies (i.e. who "sets" a failure is not a host concern). Bears on (b).
> Implementations may use host exceptions or condition classes, but the shared tests compare the normative category, code, and stage.

**`:1501–1513`** — the explicit negative list. Bears on (b) and (d).
> Successful canonical decoding does **not** establish:
>
> - truth or factual correctness;
> - authenticated provenance or authorship;
> - authority, permission, or capability possession;
> - freshness, current standing, or non-revocation;
> - custody, delivery, or receipt chronology;
> - successful procedure execution;
> - verified lineage or continuity across handoffs;
> - legal, scientific, or policy admissibility;
> - correct profile interpretation;
> - absence of malicious semantic content;
> - safety of passing decoded strings to shells, databases, templates, paths, or evaluators.

**`:1515`** — the same, as a sentence. Bears on (b).
> Canonicalization gives stable inert structure and bytes. It does not alchemize testimony into truth—the serialization layer is a meticulous clerk, not an oracle.

**Migration table row, `:1679`** — the only place CD/0 speaks of a *status vocabulary*, and it is explicitly a profile's, not CD/0's. Bears on (b).
> | current v1 claim grades/statuses | **Exact after explicit tagging** | Map status vocabulary to namespaced identifiers in a claim-profile record. Decoding does not create an authenticated claim or current standing. |

**Migration table row, `:1683`** — the closest CD/0 comes to an "asserted/observed" marker. Bears on (b) and (c).
> | raw artifact decode provenance | **Exact after explicit tagging** | Preserve "untrusted raw decode" as an explicit provenance/status identifier. It remains an assertion until authenticated by another layer. |

**[ERRATA] `:26`** — a failure-metadata change is a conformance change. Bears on (b).
> A change in typed failure category, code, or stage required below is a conformance change even though it is not a wire-format change.

### (c) Provenance / lineage fields; run-record vs property-of-the-output

**`:1565`** — legacy fingerprints as *lineage metadata*, never identity. Bears on (c) and (e).
> Legacy MD5 or printer-derived fingerprints may be carried as explicitly labeled historical metadata. They MUST NOT be treated as CD/0 semantic identity or as equivalent to a new domain-separated ID unless a separate verified mapping proves that relation. In ordinary migration, the new canonical artifact receives a new identity and records its predecessor.

**`:1587–1599`** — the located-claim components CD/0 will carry as *data*. Bears on (c).
> A located-claim profile can represent, as ordinary records:
>
> - proposition structure;
> - subject or entity identifiers;
> - corpus and corpus-version references;
> - scope components;
> - temporal points, intervals, and `as-of` boundaries;
> - policy and verifier-policy identifiers;
> - procedure and module references;
> - evidence and predecessor links;
> - schema and identity-policy versions.

**`:1601`** — the ceiling on that carriage. Bears on (c).
> CD/0 makes those components immutable and structurally comparable. It does not decide what each component means.

**`:1653–1659`** — the migration pipeline's provenance step, verbatim item 7. Bears on (c).
> 1. capture the richest available source representation and context before package stripping, printer conversion, or digesting;
> […]
> 7. record predecessor artifact IDs/digests as lineage metadata rather than asserting identity continuity.

**`:1678`** — "reported" is not "verified". Bears on (c) and (d).
> | predecessor-warrant testimony | **Requiring a profile adapter; exact after explicit tagging** for the reported fields | Preserve cumulative reported predecessor records and explicit loss markers. "Reported" is not "verified lineage." Signatures/custody are separate. |

**`:1681`** — receipt payload as data. Bears on (c).
> | receipt payload fields | **Requiring a profile adapter** | Encode digest labels, artifact references, endpoints, status testimony, and timestamps as data. Host pathnames require an explicit path/URI profile representation. |

**§4.1 table row, `:155`** — the run-record/output distinction as CD/0 draws it. Bears on (c).
> | Raw artifact provenance | Explicit raw decode records untrusted provenance. | Provenance is data unless separately authenticated. |

**`:1546–1556`** — what an identity scheme must declare (the fullest provenance-adjacent obligation in CD/0). Bears on (c) and (d).
> Every higher-level identity scheme MUST specify, either in the envelope or in an unambiguous versioned scheme definition:
>
> - the domain-separation label;
> - the Canonical Datum version, retained through the complete canonical document;
> - the identity-policy or projection version;
> - the exact payload fields included and excluded;
> - every evaluator, module, procedure, profile, scope, time, corpus, or schema version that changes the intended identity;
> - the hash algorithm and output encoding used by the resulting ID, if a hash is used;
> - treatment of dependencies, referenced artifacts, and represented loss;
> - whether the identifier denotes content, a name binding, a claim projection, a procedure, an artifact, or another domain.

### (d) Obligations / dependencies / derivations / closure / alternative routes

**`:1573–1585`** — what a later ClaimId/WarrantTarget layer *may rely on*, and what it may not. Bears on (d).
> A future ClaimId or WarrantTarget specification may rely on these CD/0 operations and laws:
>
> - construction of typed immutable primitive values;
> - exact structural record and sequence construction;
> - exact identifier namespace preservation;
> - `equal-datum`;
> - deterministic record-field projection by identifier;
> - `canonical-octets`;
> - strict `decode-exact`;
> - domain-framed cryptographic input under Section 24;
> - represented-loss records supplied by a profile.
>
> It may not rely on host object identity, package interning, source record order, diagnostic spelling, current process registries, ambient printer state, or hash collision assumptions.

**`:1619–1624`** — the field-addition obligation (a version bump is the alternative route). Bears on (d).
> A semantically relevant addition MUST NOT be introduced silently under the same identity-policy version. The higher-level specification must either:
>
> - include the field and increment the identity-policy/schema version; or
> - state explicitly that the field is non-identity metadata and explain why.

**`:1524`** — ordering obligation between canonicalization and cryptography. Bears on (d).
> A cryptographic layer must receive immutable canonical octets only after the datum and the identity-relevant projection have been fixed.

**`:1528–1540`** — the domain-framed preimage template (the one interface CD/0 hands upward). Bears on (d) and (e).
> A future content-ID, module-ID, procedure-ID, claim-ID, artifact-ID, manifest, signature, or Merkle specification SHOULD define its preimage using this framing template:
>
> ```text
> IdentityPreimage(domain_label, envelope) =
>     4c 50 49 44 00                       ; ASCII "LPID" followed by NUL
>     UVAR(length(domain_label_octets))
>     domain_label_octets
>     canonical-octets(envelope)
> ```
> […] A scheme may define a different unambiguous framing, but it MUST provide equivalent domain separation and exact metadata binding. Hashing raw payload canonical octets without an identity-domain definition is insufficient.

**`:1561`** — a signature is not a proof of the thing signed. Bears on (d).
> A signature over canonical bytes authenticates those bytes under the signature policy; it does not prove that a testimony is true or that a procedure ran successfully.

**`:2164`** — the closure/deferral rule. Bears on (d).
> Deferral means these questions require their own explicit specifications. It does not permit implementations to answer them silently inside a codec.

### (e) Retention / regeneration — hashes standing in for objects, receipts, deletion

**`:27`** — retention is optional; agreement is not. Bears on (e).
> A conforming implementation exposes immutable typed values for traversal and canonical octets for interchange and identity. It may physically retain either or both, but whenever both exist they MUST describe the same abstract datum. Cached bytes cannot become stale because runtime datums are immutable.

**`:1039`** — cache-hit obligation and the mismatch failure. Bears on (e).
> An implementation MAY cache canonical octets. A cache hit MUST return bytes equal to a fresh canonical encoding. If an implementation detects a mismatch between cached octets and the runtime value, it MUST signal `CachedOctetsMismatch` or another `InternalInvariantFailure`; it MUST NOT choose one silently.

**`:1159`** — no silent refresh. Bears on (e).
> Cached canonical octets are immutable snapshots. Returning canonical octets must not expose a writable cache. Because datums cannot mutate, caches require no invalidation. Any detected disagreement is an internal invariant failure, never a reason to refresh identity silently.

**`:1431`** — byte stability, i.e. regenerability. Bears on (e).
> Canonical bytes for a CD/0 abstract value are stable forever. If a profile changes only its implementation while constructing the same abstract datum, bytes remain identical. If it changes its schema, identity projection, Unicode policy, numeric representation, or semantics-bearing fields, it constructs a different datum and therefore a new artifact/identity input.

**`:1433`** — migration preserves identity only under equality. Bears on (e).
> A migration preserves CD/0 abstract identity only when the before and after values are the same /0 datum. Migration from a legacy format creates a CD/0 identity for the first time; a legacy digest can be retained as lineage metadata but is not automatically the same identity.

**`:1435`** — the no-silent-deletion rule. Bears on (e).
> When a migration cannot preserve a source distinction, it must reject or emit an explicit represented-loss record under a profile schema. It may not hide the loss in a renamed field or a comment.

**`:1427`** — opaque preservation of what cannot be parsed (retention without participation). Bears on (e).
> A /0 decoder returns `UnsupportedFutureVersion` for a minimally encoded nonzero version and does not parse the value. A storage system may preserve the complete unknown document as an external opaque byte blob with media-type/version metadata. That wrapper is not a CD/0 datum and cannot participate in `equal-datum` or field traversal.

**`:1363–1370`** — refusal leaves no partial residue. Bears on (e).
> On a resource refusal, `decode-exact` MUST:
>
> - return no partial datum;
> - perform no evaluator transition, symbol interning, registry mutation, file/network action, or profile validation side effect;
> - leave caller-visible application state unchanged;
> - not retain the input through a newly published partial object.

**`:1033`** — the encoder's atomicity twin. Bears on (e).
> The core `encode-exact` operation returns either one complete immutable octet string or a typed failure. […] On semantic, host-input, resource, or invariant failure it MUST NOT return a prefix as a successful result.

**`:2213–2221`** — what CD/0's own decision receipt contains, verbatim. Bears on (e) (what a receipt must contain, by example).
> ```text
> receipt-id:        lisp-plus-canonical-datum-0-design-2026-07-13
> status:            accepted for independent codec implementation
> scope:             abstract datum algebra, immutable runtime contract,
>                    canonical octets, diagnostic notation, failures,
>                    resources, versioning, migration interface
> baseline:          9e9c031a720cd40559297c9d8bb07bf8137adb54
> fresh-evidence:    attached v1 counterexample-closure packet dated 2026-07-13
> cryptographic:     no; this receipt is a design record, not an authenticated signature
> ```

### CD/0 — clauses naming what it is silent on / declines to govern

**`:73–86`** — the non-goals, complete.
> CD/0 does not define:
>
> - a Lisp+ evaluator;
> - Lisp+ lexical scope, macro expansion, module loading, or effect handling;
> - the complete proposition grammar of any Mneme profile;
> - the complete Language-A record vocabulary;
> - the located-claim identity projection;
> - scope subsumption, temporal logic, corpus identity, or revocation standing;
> - capability minting, warrant issuance, authority grants, receipt transitions, or custody;
> - procedure behavior, closure identity, or code equivalence;
> - a cryptographic hash, signature, key, certificate, or trust system;
> - truth, authenticity, freshness, admissibility, or verified lineage;
> - a universal resource limit for all deployments;
> - a general object serializer for Common Lisp or Python.

**`:88`**
> No current Common Lisp package name, schema number, filename, persistence path, prototype depth limit, character limit, printer setting, float spelling, digest algorithm, or process-local object identity becomes language law through this specification.

**`:164–180`** — the preserved boundaries, verbatim.
> The closure report explicitly leaves the following outside its proof, and CD/0 does not pretend otherwise:
>
> - `as-of` and other located-claim targeting dimensions;
> - ambient-printer-dependent legacy fingerprints;
> - arbitrary host Common Lisp closures and procedure rebinding;
> - same-image access through `mneme::` and package internals;
> - package access as a non-security boundary;
> - process-local registries and incomplete concurrency rules;
> - residual host aliases such as receipt paths and operator-supplied principals where they remain on the v1 surface;
> - incomplete module, authority, and evaluator isolation;
> - effect labels without checked effect semantics;
> - cryptographic authenticity, custody, and verified multi-hop lineage;
> - stable host-independent procedure, module, and claim identity.

**`:182`**
> CD/0 supplies future layers with immutable structural values and reproducible octets. It does not close those constitutional questions by itself.

**`:1628–1641`** — the deferred located-claim questions, verbatim (this is the list LCI/0 later answers).
> The separate claim-identity workshop must decide at least:
>
> - which fields belong in ClaimId;
> - which fields belong only in WarrantTarget;
> - whether lineage affects identity, admissibility, both, or neither;
> - whether policy identity affects claim identity or only admissibility;
> - how scope narrowing, widening, and subsumption work;
> - how `as-of`, event time, observation time, validity time, and intervals participate;
> - how corpus identity and corpus version participate;
> - whether procedure, code, module, model, and verifier versions participate;
> - how subject/entity aliases and renames participate;
> - whether current standing, revocation, or warrant consumption affects identity;
> - how represented loss affects identity and admissibility;
> - whether two translated claims are successors, equivalents under a policy, or distinct claims.

**`:1643`**
> CD/0 intentionally settles none of these projections.

**`:2120`** and §31.1–31.5 (`:2122–2162`) — the deferred constitutional questions. Excerpt of §31.1, which is the one bearing on warrant vocabulary:
> ### 31.1 Located claims and evidence
>
> - the ClaimId and WarrantTarget field projections;
> - temporal, scope, corpus, subject, policy, and procedure participation;
> - scope subsumption and admissibility;
> - revocation, current standing, warrant reuse, and consumption;
> - verified versus reported lineage and compaction;
> - represented-loss effects on admissibility and identity.

**`:1445–1449`** (§23.1, security boundary) is cited for completeness of the "declines to govern" set but not quoted in full; see §U4.

---

## LCI/0 CLAUSES

Source unless otherwise marked: `experiments/latent-lisp/mneme/lci0/spec/LOCATED-CLAIM-IDENTITY-SPEC.md` (S5). Errata quotes are marked **[ERRATA]** and cite `…/LOCATED-CLAIM-IDENTITY-SPEC-ERRATA-0.1.md` (S6).

### (a) What may become a Datum / an identity object; what is refused

**`:44`** — the executive decision. Bears on (a).
> A proposition is normalized semantic content. A located claim is that proposition paired with the semantic coordinates that determine which situated assertion exists. A ClaimId is the exact CD/0 identity envelope of that pair under a named claim profile and identity-policy version. The ClaimId is the envelope itself, not a hash. A later compact identifier may hash a domain-framed canonical encoding of the envelope, but hash collision resistance is a separate cryptographic property and never defines semantic sameness.

**`:48–58`** — the closed envelope. Bears on (a).
> ```text
> ClaimIdEnvelope =
>   identity-policy
>   claim-profile
>   proposition
>   location = {
>     scope,
>     subject-time,
>     basis,
>     interpretation-frame,
>     profile-location
>   }
> ```

**`:62`** — no optional fields, no aliasing of neutrality. Bears on (a).
> Every field is required. Mneme LCI/0 uses an empty `profile-location` record. There are no optional identity fields in version 0. An explicit neutral value is used when a coordinate is semantically neutral: universal scope, atemporal subject-time, world basis, self-describing interpretation frame, and an empty profile-location record. Omission and explicit Unit are not aliases for those neutral values.

**`:64`** — what changes identity. Bears on (a).
> Changing any of the following creates a different ClaimId: normalized proposition; claim-profile version; identity-policy version; exact scope or scope-calculus identity; proposition subject-time or temporal-model identity; a semantic corpus, immutable corpus revision, dataset slice, or closed-world completion boundary; interpretation frame; or any profile-approved identity-bearing location component.

**`:66`** — what does not. Bears on (a) and (c).
> Changing only claimant, issuer, assertion event, observation event, execution history, evidence procedure, code version used to obtain evidence, model or prompt used as evidence, admissibility policy, validity state, revocation state, current standing, provenance, lineage, display spelling, or identity-neutral presentation metadata preserves ClaimId. Such changes may create a different claim occurrence, warrant, provenance record, lineage edge, admissibility result, or standing result.

**`:714–718`** (§7.12) — ClaimId is the envelope. Bears on (a) and (e).
> For LCI/0:
>
> ```text
> ClaimId(x) = claim-id-envelope(x)
> ```
>
> The semantic identity value is not a hash, pointer, UUID, row key, package symbol, printed string, or runtime registration token.

**`:394`** (§5.4) — what ClaimId does not identify. Bears on (a).
> ClaimId does not identify a claimant, assertion event, database row, runtime object, artifact custody chain, live authority, or standing snapshot.

**`:376–380`** (§5.3) — the minimality test governing what may enter location. Bears on (a) and (d).
> The minimality test is:
>
> > An identity-bearing location field is justified only when changing it, while holding proposition and all other identity coordinates fixed, either distinguishes a different semantic claim or makes direct reuse of an existing exact warrant unsound.

**`:906`** (§9.2) — the target's admission rule. Bears on (a).
> All six fields are required. No target kind may omit `claim` or replace it with a proposition-only fingerprint. No target may use a mutable claim record, current standing, or a caller-supplied hash in place of the complete validated envelope.

**`:912–921`** (§9.3) — the common target laws (what is refused at the target boundary). Bears on (a) and (d).
> A valid target MUST satisfy all of the following:
>
> - `claim` validates as a closed ClaimId envelope;
> - `target-schema` is stable and supports the declared `target-kind`;
> - `boundaries` is closed under that schema;
> - every procedure, module, model, artifact, corpus, policy, principal, invocation, trace, premise, or receipt reference required by the schema is a stable reference;
> - every temporal boundary is an explicit versioned temporal value;
> - every scope boundary is an explicit versioned scope value;
> - no boundary is inferred from a display name, mutable registry, current process, or ambient clock;
> - a boundary inconsistent with the embedded ClaimId produces a typed refusal.

**`:1534`** (§14.1) — the reference-admission rule; aliases refused. Bears on (a) and (c).
> Every identity-bearing reference in ClaimId or WarrantTarget uses `StableRef/0` or a profile record whose semantics are at least as explicit. Display names, package names, symbols, filenames, URLs, model marketing names, and policy labels are aliases unless a stable scheme explicitly makes their exact versioned content identity-bearing.

**`:837`** (§8.5, excerpt) — cross-field rejections; the "claimed neutral coordinate" refusal. Bears on (a).
> The profile validator MUST reject at least: […] a location field encoded under a display alias rather than stable reference material; a claimed neutral coordinate represented by omission or Unit.

### (b) Statuses / epistemic markers a datum or claim may carry, and who may set them

This is LCI/0's densest surface. Four distinct vocabularies exist and the spec forbids substituting one for another.

**(b-1) The nine relations (§4.16, `:320–328`).** Bears on (b) and (d).
> These are distinct relations:
>
> - **same claim**: exact ClaimId equality;
> - **proposition-equivalent**: a profile/calculus judgment about semantic proposition equivalence;
> - **claim-refines**: a safe narrowing relation defined in Section 17, limited in LCI/0 to scope;
> - **claim-translates-to**: an explicit translation relation with a receipt and loss account;
> - **claim-descends-from**: an explicit lineage path;
> - **target matches**: a WarrantTarget relation to a claim;
> - **warrant admissible**: a current policy judgment.

**`:330`**
> No one of these relations substitutes for the others.

**(b-2) The eleven WarrantTarget kinds (§9.4–9.14, `:923–1069`)** — the evidential-act vocabulary. Bears on (b). Kind names, as headed in the text: `observed` (`:923`), `executed` (`:937`), `tested` (`:952`), `derived` (`:968`), `externally-attested` (`:981`), `replayed` (`:994`), `corpus-completion` (`:1008`), `reported` (`:1024`), `inherited` (`:1037`), `translated` (`:1051`), and policy-evaluation/profile targets (`:1065`). Governing sentence, **`:398`** (§5.5):
> The same located claim may be observed, executed, derived, reported, translated, or supported by corpus completion. Those are not interchangeable evidential acts. WarrantTarget therefore includes a complete ClaimId and a kind-specific boundary record.

Non-reclassification clauses, verbatim:
**`:1035`** —
> Reported evidence remains reported. It is not reclassified as observation, execution, or verified lineage by structural resemblance.

**`:966`** —
> A test warrant supports the target relation it actually tested. It is not automatically an observation of the external world or a universal proof over untested inputs.

**`:1022`** —
> The target schema MUST require the target corpus, revision, slice, and semantic boundary to agree with the embedded ClaimId. A completion receipt proves only the declared bounded search event. It does not turn corpus absence into unbounded world truth.

**`:1006`** —
> Replay is a new evidence event. It can yield a new live warrant under current authority. It never reanimates the predecessor warrant merely because the new result matches.

**`:1049`** —
> An inherited target describes succession testimony. It does not carry live predecessor authority. An admissibility policy can accept inherited testimony for limited purposes, but LCI/0 never treats it as a live warrant by default.

**(b-3) The relation-result vocabulary of the matcher (§10.1, `:1100–1119`)** — including the **fifth-state** members `unknown` and `incompatible`. Bears on (b).
> Target matching is a typed relation, not a single permissive boolean. For a validated WarrantTarget `t` and validated claim `c`, the LCI/0 matcher returns one of:
>
> ```text
> R("exact-target")
> R("supports-by-scope-narrowing")
>
> or a typed refusal/mismatch, including:
>   F("proposition-mismatch")
>   F("subject-time-mismatch")
>   F("basis-mismatch")
>   F("interpretation-frame-mismatch")
>   F("profile-location-mismatch")
>   F("scope-widening-forbidden")
>   F("scope-overlap-insufficient")
>   F("scope-disjoint")
>   F("scope-incompatible")
>   F("scope-relation-unknown")
>   F("target-boundary-mismatch")
>   F("unsupported-target-kind")
> ```

**`:1121`**
> The relation result is not an admissibility result.

**(b-4) The scope-relation vocabulary (§11.2, `:1269–1288`)** — seven values, two of which are the non-answers. Bears on (b).
> `scope-relation(a,b)` returns exactly one of:
>
> ```text
> R("equal")
> R("narrower")
> R("wider")
> R("overlap")
> R("disjoint")
> R("incompatible")
> R("unknown")
> ```
> […]
> - `incompatible`: they cannot be compared under one semantics, usually because their calculi or domain types lack a declared bridge;
> - `unknown`: comparison is meaningful but the implementation, available facts, or calculus cannot determine the relation.

**`:1290`** — the three-valued subsumption predicate. Bears on (b).
> `scope-subsumes(a,b)` is true exactly when `scope-relation(a,b)` is `equal` or `wider`, false for `narrower`, `overlap`, or `disjoint`, and unknown for `incompatible` or `unknown` unless a profile specifies a stronger typed refusal.

**`:1295`** (§11.3) — who returns which non-answer. Bears on (b).
> A matcher MUST return `ScopeIncompatible` when no declared bridge exists. It MUST return `ScopeRelationUnknown` when a declared comparison domain exists but no relation can be proved.

**(b-5) Warrant / admissibility / standing — the terms and who sets them.**

**`:284`** (§4.8) —
> A **Warrant** is a genuine evidence or authorization-bearing occurrence that supports, refutes, observes, executes, tests, derives, reports, translates, inherits, or otherwise bears on a WarrantTarget. Its inert projection can be represented as CD/0 data. A live warrant may additionally involve runtime authority that CD/0 cannot contain.

**`:286`** —
> A decoded record shaped like a warrant is testimony about a warrant, not a live warrant.

**`:294`** (§4.10) —
> **Warrant admissibility** is a policy-relative judgment that a genuine warrant may currently count for a candidate claim. It can depend on target relation, warrant kind, authority, issuer, procedure, code, freshness, validity, revocation, represented loss, jurisdiction, requested warrant kind, consumption state, and query time.

**`:296`** —
> Admissibility is not claim identity and is not structural CD/0 equality.

**`:300`** (§4.11) —
> **Standing** is a query result computed from claims, live warrants, refutations, revocations, validity, time, policy, represented loss, and other runtime state. LCI/0 does not define a final standing lattice. It does require standing to be recomputed as a state query rather than stored inside ClaimId.

**`:404`** (§5.6) — who may set admissibility. Bears on (b).
> A conforming admissibility implementation MUST accept the policy and runtime state as explicit inputs. It MUST NOT read an admissibility-policy identifier from ClaimId or silently change ClaimId when a policy changes.

**`:410`** (§5.7) — who may set standing. Bears on (b).
> A conforming standing implementation MUST compute standing for an explicit query state and query time. Revocation, expiry, new refutation, policy replacement, or warrant consumption can change standing without changing ClaimId.

**`:412`** —
> A serialized historical status is testimony about a former result. It is not current standing merely because its record shape is valid.

**`:366`** (§5.1) — the direction rule. Bears on (b) and (d).
> No arrow runs backward from standing, revocation, a decoded warrant-shaped datum, or a claimant's self-declaration into ClaimId.

**`:1998`** (§17.17, No self-certification law) — nobody may set their own marker. Bears on (b).
> A claim, warrant, model output, or artifact cannot establish its own identity, authority, or admissibility by containing fields that say it has them. Validators recompute identity and consult the proper runtime or policy layer.

**`:1092`** (§9.16) —
> The serialization clerk remains a clerk. It does not moonlight as a high priest of epistemic legitimacy.

**(b-6) The typed failure envelope (§18.1–18.2, `:2006–2043`).** Bears on (b).
> LCI/0 operations return successful values or typed failures. Host exception text is not a conformance surface.
>
> A serializable failure projection uses:
>
> ```text
> LCIFailure/0 = Record{
>   K("kind")           => T("failure"),
>   K("schema-version") => 0,
>   K("category")       => <Identifier>,
>   K("code")           => <Identifier>,
>   K("stage")          => <Identifier>,
>   K("path")           => <Seq of field Identifiers and sequence indexes>,
>   K("context")        => <closed inert Record>
> }
> ```

**`:2028–2041`** — the ten LCI failure categories.
> LCI/0 defines at least:
>
> ```text
> F("invalid-input")
> F("unsupported-version-or-profile")
> F("projection-refusal")
> F("reference-refusal")
> F("target-mismatch")
> F("relation-undetermined")
> F("migration-refusal")
> F("privilege-refusal")
> F("resource-refusal")
> F("internal-invariant-failure")
> ```

**`:2043`** — namespace non-relabelling. Bears on (b).
> CD/0 decode, canonicality, and resource failures retain their frozen CD/0 categories. An LCI layer does not relabel malformed CD/0 bytes as an LCI semantic failure.

**[ERRATA] `:3146`** (I12(c)) — the same rule from the other side.
> `PrivilegedRestorationAttempt` in this packet is an LCI failure code. It does not replace, alias, broaden, narrow, or reinterpret any frozen CD/0 category or code bearing similar words.

**[ERRATA] `:2983–2987`** (E2 — positive admissibility floor). Bears on (b) and (d); this is the clause that fixes *which* markers may be promoted.
> > A warrant MAY proceed to admissibility-policy evaluation only when `match-target` returns `R("exact-target")` or `R("supports-by-scope-narrowing")`.
>
> Every F-valued target result is hard-inadmissible at this boundary. This includes `relation-undetermined`, `target-mismatch`, unsupported, incompatible, unknown, malformed, resource-refused, and every typed failure result regardless of its subcode.
>
> An admissibility policy MAY reject either successful R-valued relation. It MUST NOT convert, wrap, reinterpret, downgrade, or otherwise promote an F-valued result into support. The policy is not consulted for the purpose of curing an F-valued relation.

**[ERRATA] `:3142`** (I12(b)) — the policy-evaluation target's two mandatory status fields. Bears on (b).
> A policy-evaluation WarrantTarget MUST record `inner-target-relation` and `testimony-mode`. The fixture mode is meta-testimony: it says that a named policy evaluated a named warrant under a named state snapshot and query time. It is not direct support for the embedded claim, and no consumer may erase that distinction.

### (c) Provenance / lineage fields; run-record vs property-of-the-output

**`:304`** (§4.12) —
> **Provenance** records historical facts about an occurrence or artifact: source, claimant, assertion event, parser, importer, procedure, observation, custody testimony, external artifact, display text, or transformation receipt. Provenance may influence admissibility without being semantic claim identity.

**`:308`** (§4.13) —
> **Lineage** is an explicit relation among claim occurrences, artifacts, or identity envelopes: copy, independent re-derivation, inheritance, freeze/revival, reconstruction, translation, correction, migration, compaction, or other succession. Lineage explains history. It neither follows from equal ClaimIds nor makes unequal ClaimIds equal.

**`:416`** (§5.8) — the run-record/output-property line, stated directly. Bears on (c).
> Claimants, source artifacts, import receipts, translation events, and predecessor links can matter greatly to admissibility and historical understanding. They do not enter ClaimId unless they alter normalized proposition or one of the semantic location coordinates.

**`:418`** —
> Equal ClaimIds do not prove common lineage. A copied claim and an independently re-derived claim can share ClaimId. Conversely, a correction or translation can have explicit lineage while changing ClaimId.

**`:1630`** (§15.1) —
> Lineage does not participate in ClaimId. It is an explicit historical relation among claim occurrences and artifacts. Equal ClaimIds neither prove nor imply lineage. Lineage neither proves nor implies equal ClaimIds.

**`:1636–1650`** (§15.2) — the lineage-edge record. Bears on (c).
> ```text
> ClaimLineageEdge/0 = Record{
>   K("kind")                   => T("claim-lineage-edge"),
>   K("schema-version")         => 0,
>   K("relation")               => <lineage relation Identifier>,
>   K("source-occurrence")      => <StableRef/0>,
>   K("destination-occurrence") => <StableRef/0>,
>   K("source-claim")           => <ClaimIdEnvelope/0>,
>   K("destination-claim")      => <ClaimIdEnvelope/0>,
>   K("receipt")                => <inert CD/0 receipt Record>,
>   K("represented-loss")       => <Seq of RepresentedLoss/0>
> }
> ```

**`:1652`** — an empty loss list is a report, not a proof. Bears on (c) and (e).
> All fields are required. An empty loss sequence explicitly states that the edge reports no represented loss; it does not prove that the transformation was lossless or authenticated. The edge itself is inert testimony until a lineage-verification system accepts it.

**`:1656–1670`** (§15.3) — the eleven reserved lineage relation names. Bears on (c).
> LCI/0 reserves semantic relation names for at least:
>
> ```text
> R("exact-copy")
> R("independent-rederivation")
> R("freeze-revival")
> R("reconstruction")
> R("translation")
> R("correction")
> R("provenance-correction")
> R("migration")
> R("inheritance")
> R("compaction")
> R("supersession")
> ```

**`:1672`** —
> A later lineage profile fixes exact edge evidence and verification rules. The relation name alone does not prove the event.

**`:1730–1732`** (§15.13) —
> `claim-descends-from(x,y,graph,policy)` is a query over an explicit lineage graph and a lineage-verification policy. It is not derivable from ClaimId bytes alone.
>
> A conforming implementation MUST NOT return true solely because `same-claim(x,y)` is true. It MUST NOT return false solely because ClaimIds differ, because corrections, translations, and migrations can create genuine lineage across changed identities.

**`:1736`** (§15.14) — succession carries no status. Bears on (c) and (d).
> No lineage relation—copy, inheritance, revival, reconstruction, translation, or migration—automatically transfers current standing. Standing is recomputed for the destination occurrence/claim under current warrants, state, policy, and query time.

**`:1488–1503`** (§13.4) — the interpretation receipt, i.e. the run-record of the surface→proposition step. Bears on (c).
> A profile may use an inert record equivalent to:
>
> ```text
> InterpretationReceipt/0 = Record{
>   K("kind")                 => T("interpretation-receipt"),
>   K("source-artifact")      => <StableRef/0 or explicit not-applicable value>,
>   K("surface-form")         => <CD/0 value>,
>   K("source-language")      => <stable language/dialect reference>,
>   K("interpretation-frame") => <InterpretationFrame/0>,
>   K("interpreter")          => <StableRef/0 to procedure/model/human-process scheme>,
>   K("result-proposition")   => <normalized proposition>,
>   K("represented-loss")     => <Seq of represented-loss records>
> }
> ```
>
> The receipt can be targeted by a `translated`, `reported`, or profile-defined interpretation warrant. The receipt is not automatically authenticated by being well formed.

**`:1075–1085`** (§9.15) — minimum warrant-identity material, and the three status fields explicitly barred from it. Bears on (b), (c), (d).
> LCI/0 does not select a universal WarrantId, but any warrant identity scheme claiming LCI/0 compatibility MUST bind at least:
>
> ```text
> complete WarrantTarget/0
> warrant kind and schema
> issuer/producer stable identity
> verdict, result, or supported relation
> kind-specific evidence-event identity
> issue/mint time
> validity terms
> represented loss, when present
> ```

**`:1087`**
> It MUST bind immutable procedure/code/model/module/invocation/artifact material whenever the target schema requires it. It MUST NOT include current revocation state, current admissibility, or current standing as identity fields. A later revocation changes whether the same warrant counts; it does not retroactively make it a different evidence occurrence.

**`:1418–1428`** (§12.6) — freshness as an admissibility predicate over a named input set. Bears on (b), (c), (d).
> Freshness is an admissibility predicate over at least:
>
> ```text
> claim subject-time
> observation or execution time
> warrant issue time
> warrant validity interval
> standing-query time
> policy
> runtime state
> ```
>
> Freshness never changes ClaimId. A stale warrant remains the same warrant targeted at the same claim; it simply may no longer count.

### (d) Obligations / dependencies / derivations / premises / closure / alternative routes

**`:70–79`** (§1) — the two-case rule for one warrant bearing on more than one claim, and the forbidden substitutions. Bears on (d).
> One warrant can bear on more than one located ClaimId only in two LCI/0 cases:
>
> 1. the claims have exactly the same ClaimId, even if they are distinct assertion occurrences; or
> 2. the warrant targets a broader scope and a separately versioned scope calculus proves that the candidate claim is a narrowing, the exact target schema declares downward scope monotonicity for that target kind and normalized proposition form, every non-scope ClaimId coordinate is exactly equal, all kind-specific boundaries remain satisfied, and the selected admissibility policy permits the projection.
>
> LCI/0 does not permit generic temporal widening or narrowing, corpus substitution, interpretation-frame substitution, proposition equivalence, translation, or policy substitution during direct target matching. Those require an explicit derivation, translation, replay, or other new warrant.

**`:974–979`** (§9.7, derived target) — premises. Bears on (d).
> A `derived` target binds at least:
>
> ```text
> inference-calculus reference
> ordered or explicitly keyed premise ClaimIds
> rule/derivation identity
> derivation artifact or trace
> ```
>
> The derivation calculus decides premise order, discharge conditions, monotonicity, and whether a derivation is valid. CD/0 equality alone does not prove the inference.

**§17 laws, verbatim, each bearing on (d):**

**`:1919–1924`** (§17.9, exact-target law) —
> ```text
> warrant-target-exact(t, c)
>     iff
>   t.claim = ClaimId(c)
>   and target-boundaries-cohere(t,c)
> ```
>
> A proposition-only target cannot satisfy this law.

**`:1928–1932`** (§17.10, scope-projection law) —
> ```text
> warrant-target-matches(t,c) = supports-by-scope-narrowing
> ```
>
> only under all conditions in Section 10.3. No other ClaimId field can differ.

**`:1936`** (§17.11, no widening law) —
> If `scope(t.claim)` is narrower than `scope(ClaimId(c))`, direct target matching fails with `ScopeWideningForbidden`. No admissibility policy can turn that same target into direct broad support without an explicit derived warrant.

**`:1940–1954`** (§17.12, admissibility law) —
> Conceptually:
>
> ```text
> warrant-admissible(w, c, policy, state, query-time)
>     iff
>   genuine-warrant(w, state)
>   and target-relation-permitted(w.target, c, policy)
>   and authority-valid(w, state, policy)
>   and validity-holds(w, query-time, state)
>   and freshness-holds(w, c, query-time, policy)
>   and loss-permitted(w, policy)
>   and all policy-specific conditions hold
> ```
>
> LCI/0 fixes neither the full predicate set nor their order, but a conforming system MUST NOT return admissible when target matching fails, the warrant is only inert predecessor testimony, or revocation state known to the policy invalidates it.

**`:1958–1965`** (§17.13, standing law) —
> ```text
> standing(state, claim, policy, query-time)
>     = query over admissible live warrants,
>       refutations, revocations, validity,
>       consumption, and policy state
> ```
>
> Changing `state`, `policy`, or `query-time` can change standing while ClaimId remains fixed.

**`:1969–1974`** (§17.14, inertness law) —
> ```text
> decode-exact(canonical-octets(warrant-shaped-record))
>     -> inert CD/0 value
> ```
>
> It never yields a live warrant, authority, capability, active receipt, or current standing. Privilege requires a separate runtime act.

**`:1886–1897`** (§17.6, claim refinement law) — the only refinement LCI/0 defines. Bears on (d).
> LCI/0 defines scope refinement only:
>
> ```text
> claim-refines(x, y)
>     iff
>   identity-policy/profile/proposition/subject-time/basis/frame/profile-location
>       are exactly equal
>   and
>   scope-relation(scope(x), scope(y)) is R("narrower")
> ```
>
> `claim-refines` does not imply `same-claim`. It does not include temporal, corpus, frame, translation, or proposition-equivalence refinement.

**`:1864`** (§17.4, metadata-neutrality law, closing sentence) — the fail-closed rule for unknown fields. Bears on (d).
> An unknown field is not presumed nonidentity; it is rejected.

**`:1882`** (§17.5) — the four-valued equivalence result, another "fifth state". Bears on (b) and (d).
> `proposition-equivalent` is profile/calculus-relative and can return true, false, incompatible, or unknown.

**`:1293`** (§11.3) — bridges as the alternative route between calculi. Bears on (d).
> Two structurally different scope-calculus references are not silently treated as equivalent. A bridge between calculi is itself a stable, versioned relation artifact.

**[ERRATA] `:3084–3088`** (E7.2, future bridge rule). Bears on (d).
> 1. No declared bridge means different StableRef envelopes remain different ClaimIds/targets.
> 2. A bridge MUST be explicit, stable, versioned, total over its declared source domain, deterministic, and independently tested.
> 3. Canonicalization through a bridge occurs before projection; failure to bridge is typed and fail-closed.
> 4. A bridge does not retroactively make unequal CD/0 envelopes structurally equal and does not rewrite historical ClaimIds.
> 5. Migration, equivalence, and operational lookup remain explicit records. They do not collapse semantic equality.

**[ERRATA] `:3150`** (I12(d), recursive version closure). Bears on (d).
> Unsupported nested calculus, temporal-model, slice-calculus, boundary-calculus, frame-schema, StableRef scheme/material, target schema, represented-loss account schema, and closed record versions fail closed recursively. No enclosing supported version may legalize an unsupported nested version.

**[ERRATA] `:2995–3003`** (E3.1, version-bump tie-break) — which obligation attaches to which change. Bears on (d).
> 1. A change to the ClaimId field set, field ownership, projection role, or identity projection **changes the identity-policy version**.
> 2. A change to proposition grammar, normalization contract, semantic interpretation, interpretation-frame schema, or proposition/location consistency rules while the projection field set remains the same **changes the claim-profile version and/or frame-schema version** according to the changed owner.
> 3. A correction to an implementation that changes no accepted abstract input, normalized proposition, ClaimId, target relation, admissibility-floor result, or typed failure result need not change either version, but MUST carry conformance evidence proving preservation.
> 4. No meaning-changing normalizer revision may remain under the same declared claim-profile/frame-schema version. Finite vectors alone are insufficient authority for such a revision.
> 5. A change that crosses both ownership boundaries changes both applicable versions; authors MUST NOT use one version axis to conceal a change owned by the other.

**[ERRATA] `:3013–3020`** (E4, pre-projection normalization discipline) — six obligations on any identity-bearing normalizer. Bears on (d).
> Every identity-bearing pre-projection normalizer for scope, subject-time, interpretation frame, dataset slice, and semantic boundary MUST be:
>
> - total over its declared accepted source domain;
> - deterministic;
> - explicitly versioned and governed by E3;
> - pure and independent of ambient state, locale, printer settings, registries, clocks, environment variables, network services, or mutable aliases;
> - loss-reporting whenever source distinctions are discarded;
> - applied before ClaimId projection.

**[ERRATA] `:3046–3053`** (E6, deterministic intra-rank multi-fault precedence) — the total failure-selection walk. Bears on (b) and (d).
> 1. Frozen CD/0 parsing/decoding failures occur before any LCI-layer validation.
> 2. LCI validation ranks from the candidate specification are applied in their existing order.
> 3. Within one rank, missing required fields are tested in the schema's declared field order.
> 4. Present declared fields are recursively validated depth-first in that same field order.
> 5. Sequence members are visited by increasing zero-based index.
> 6. After declared fields, unknown fields are visited in canonical CD/0 Identifier key order.
> 7. Named cross-field coherence checks run last in their declared order.
> 8. The first failure reached is returned with its exact category, code, stage, and structural path.

### (e) Retention / regeneration — hashes standing in for objects, receipts, what may be deleted

**`:835–837`** (§8.4) — the cache rule; a stored ID is never an input. Bears on (e).
> An outer artifact profile may carry a cached ClaimId envelope or digest for indexing. The cache is never an input to projection.
>
> When a cache is present, a conforming reader MUST recompute the envelope from proposition and location. It MUST reject a non-equal cached envelope with `ClaimIdCacheMismatch`. It MUST verify any digest under the digest scheme before using it as an index. It MUST NOT accept a model-generated, user-supplied, or decoded record merely because it declares its own ClaimId.

**`:855–861`** (§8.6) — retention of the complete document. Bears on (e).
> ```text
> claim-id-octets(e) = CD0.canonical-octets(e)
> ```
>
> The complete canonical CD/0 document, including `LPCD` magic and version `0`, is retained. Implementations MUST compare either validated envelopes by CD/0 equality or their validated canonical octets. They MUST NOT compare diagnostic text, host hashes, printer output, package symbols, dictionary order, or pointer identity.

**`:865–881`** (§8.7) — regenerability as a cross-implementation law. Bears on (e).
> More usefully, for any two independent conforming implementations `A` and `B`:
>
> ```text
> A.project(c) = B.project(c)
> A.canonical-octets(A.project(c))
>   = B.canonical-octets(B.project(c))
> ```

**`:1988–1994`** (§17.16, digest-separation law) — the hash may not stand in for the object. Bears on (e).
> For any later digest function `H`:
>
> ```text
> H(domain-frame(ClaimId(x))) = H(domain-frame(ClaimId(y)))
> ```
>
> is not the definition of `same-claim`. Semantic equality remains envelope equality. The cryptographic scheme defines what operational confidence a digest comparison provides.

**[ERRATA] `:3094–3098`** (E8, digest authority) — the same rule, sharpened, plus the refusal. Bears on (e).
> Digest equality is never the definition of semantic ClaimId equality.
>
> Semantic equality remains equality of validated ClaimId envelopes, witnessed by canonical CD/0 octets. A later digest MAY be an operational reference only under its own named cryptographic scheme. No collision rule, envelope-resolution rule, lookup convention, content-addressing convention, or successful digest verification may promote digest equality into semantic equality.
>
> A digest-only purported ClaimId is refused. The fixture digest vectors deliberately use a nonproduction constant digest to prove that equal digests with unequal envelopes remain semantically unequal.

**`:730`** (§7.12, closing) — a collision is not an identity. Bears on (e).
> LCI/0 selects no hash algorithm. A digest collision does not make unequal envelopes the same claim, and digest equality alone is not semantic proof when the envelope is unavailable or collision handling is unspecified.

**`:1744–1756`** (§16.1) — the represented-loss record and its five consequence values. Bears on (e).
> ```text
> RepresentedLoss/0 = Record{
>   K("kind")            => T("represented-loss"),
>   K("schema-version")  => 0,
>   K("operation")       => <StableRef/0 to migration/translation/compaction operation>,
>   K("source")          => <StableRef/0 to source artifact or occurrence>,
>   K("lost-dimensions") => <Seq of exact Identifier values>,
>   K("consequence")     => <Identifier>,
>   K("account")         => <closed explanatory Record>
> }
> ```

**`:1758–1766`**
> `consequence` is one of a profile's exact values including at least:
>
> ```text
> R("identity-neutral-loss")
> R("identity-bearing-loss")
> R("authority-or-custody-loss")
> R("semantic-translation-loss")
> R("unknown-consequence")
> ```

**`:1768`**
> A loss record is testimony unless authenticated by another layer. Its presence nevertheless prevents a conforming adapter from silently claiming losslessness.

**`:1786–1789`** (§16.4) — what may not be deleted or guessed. Bears on (e).
> If proposition or location cannot be recovered exactly, an adapter MUST NOT emit the ClaimId it guesses the source intended. It has two conforming choices:
>
> 1. reject migration with `IdentityBearingLoss`; or
> 2. construct a new proposition/location that explicitly asserts the uncertainty or ambiguity under a profile-defined tagged form, thereby producing a different ClaimId.

**`:1789` (continued)**
> Unit, field omission, empty string, zero, `nil`, `None`, a wildcard, or "latest" cannot stand in for an unknown identity coordinate unless a profile explicitly defines that as the proposition's meaning. Such a loss-qualified claim is not an alias for any concrete original claim.

**`:1811`** (§16.9) — the completeness obligation on a loss account. Bears on (e).
> A migration or transformation claiming compatibility with LCI/0 MUST enumerate every known lost source dimension and classify its consequence. An empty loss sequence means "this operation reports no known loss," not "mathematical proof of perfect preservation."

**`:1726`** (§15.12) — what compaction may delete. Bears on (e).
> Compaction can preserve ClaimId when it drops only identity-neutral provenance and records that loss. If it drops or conflates proposition/location distinctions, it cannot claim the original ClaimId. A new loss-qualified claim or refusal is required.

**`:1696–1698`** (§15.7) — reconstruction's retention floor. Bears on (e).
> Exact ClaimId recovery is permitted only when every identity-bearing field is deterministically recovered and validated. Confidence that a missing field was "probably" some value is not equality. An unresolved identity field requires a new proposition/location that explicitly represents uncertainty, or refusal to construct a located claim.

**`:2778–2799`** (§23.3) — the migration pipeline, verbatim, including what the receipt must link and the zero-warrant start. Bears on (c) and (e).
> A conforming v1-to-LCI/0 adapter performs, in order:
>
> ```text
> 1. Snapshot the exact source bytes and bind a source artifact reference.
> 2. Parse with a frozen, non-evaluating, resource-bounded legacy parser.
> 3. Validate the exact legacy schema/version; reject trailing or active forms.
> 4. Map symbols/identifiers with explicit namespace and package/module evidence.
> 5. Map the v1 proposition into the normalized Mneme proposition profile.
> 6. Classify `as-of` into explicit temporal roles.
> 7. Map scope into Scope/0 and select an exact scope calculus.
> 8. Construct Basis/0 and InterpretationFrame/0 from explicit source evidence.
> 9. Record every ambiguity or lost distinction as RepresentedLoss/0.
> 10. Refuse same-claim reconstruction when any identity field is unresolved.
> 11. Project a new ClaimIdEnvelope/0.
> 12. Convert old fingerprints, attestations, statuses, receipts, and predecessor
>     material into inert provenance/lineage/warrant testimony.
> 13. Produce a migration receipt linking source artifact and new occurrence.
> 14. Start with no migrated live warrants.
> ```

**`:2802–2820`** (§23.4) — the migration result record; note `live-warrants-created => false` as a literal field. Bears on (c) and (e).
> ```text
> MigrationResult/0 = Record{
>   K("kind")                 => T("migration-result"),
>   K("schema-version")       => 0,
>   K("source")               => <StableRef/0>,
>   K("adapter")              => <StableRef/0>,
>   K("classification")       => <Identifier>,
>   K("claim")                => <validated located-claim data or explicit refusal payload>,
>   K("claim-id")             => <ClaimIdEnvelope/0 when successful>,
>   K("lineage")              => <Seq of inert lineage edges>,
>   K("represented-loss")     => <Seq of RepresentedLoss/0>,
>   K("legacy-testimony")     => <Seq of inert records>,
>   K("live-warrants-created") => false
> }
> ```
>
> A failure form uses `LCIFailure/0` rather than placing Unit in `claim-id`.

**`:2836–2840`** (§23.6) — no regeneration of authority from a retained record. Bears on (e).
> No serialized or reconstructed v1 warrant becomes a live LCI warrant by migration.
>
> The default and normative posture is inert testimony. A successor system may perform a separately authorized replay, fresh observation, fresh execution, or re-attestation that checks the complete LCI WarrantTarget and current authority. That act creates a new LCI warrant with a new evidence-event identity. The old warrant remains predecessor testimony; it is not transmuted into the new live object.

**[ERRATA] `:3003–3009`** (E3.2) — what a normalizer revision must retain as evidence, and the anti-smuggling clause. Bears on (e).
> Every normalizer revision MUST bind all three of the following exact records:
>
> - `normalizer.conformance-binding.0` […] immutable content identity or exact normative source artifact for the normalizer;
> - `normalizer.mutation-vector.0` […] at least one mutation witness per revision, including rejected and remapped surfaces where applicable;
> - `normalizer.semantic-projection-ledger.0` […] a before/after ledger over accepted-domain classes stating whether abstract input acceptance, normalized proposition, ClaimId, relation, or failure changed.
>
> The ledger is an assurance artifact, not a field of ClaimId. The implementation binary, process image, compiler output, host path, deployment hash, or mutable package version MUST NOT be placed in ClaimId merely to establish conformance.

**`:3389–3396`** (§30.1) — the LCI/0 decision receipt's own fields. Bears on (e).
> ```text
> receipt-id: LCI0-CONSTITUTIONAL-DECISION-2026-07-13
> subject: Lisp+ Located Claim Identity /0 and Mneme profile
> artifact: LOCATED-CLAIM-IDENTITY-SPEC.md
> status: normative design selected; implementation not performed
> ```

### LCI/0 — clauses naming what it is silent on / explicitly declines to govern

**`:110–123`** (§2.3, non-goals, complete).
> LCI/0 does not:
>
> - alter CD/0 values, equality, canonical octets, wire grammar, decoder behavior, datum version, errata, or conformance vectors;
> - define the full Mneme proposition language;
> - define a complete theorem prover or general semantic-equivalence procedure;
> - define a complete scope algebra;
> - define a complete temporal ontology or calendar/time-scale system;
> - choose a hash, signature, key, capability, or cryptographic custody system;
> - declare any claim true, authoritative, fresh, admissible, or currently standing;
> - define complete WarrantId, warrant-consumption, revocation, or standing semantics;
> - define verified lineage or succession authority;
> - migrate v1 runtime objects or reanimate serialized warrants;
> - constitutionalize the current v1 field layout, printer-derived fingerprint, package conventions, or process-local registries;
> - implement Common Lisp or Python libraries.

**`:81`** (§1, closing).
> LCI/0 leaves truth, authority, custody, cryptographic choice, the complete scope logic, the complete temporal logic, warrant admissibility policy, standing lattice, revocation semantics, procedure/module identity schemes, and verified lineage protocols to their own constitutions. It fixes the boundaries those later systems must respect.

**`:3251`** and §28.1–28.14 headings (`:3255–3307`) — the fourteen deferred questions. Headings verbatim: Complete Mneme proposition grammar · Complete scope calculus · Complete temporal model · Basis, slice, and semantic-boundary calculi · Proposition equivalence and normalization proofs · Warrant calculus and complete WarrantId · Admissibility policy language · Standing semantics · Authority, capability, revocation, and custody · Module, procedure, model, and artifact identity schemes · Cryptographic algorithms and compact references · Verified lineage · Privacy and selective disclosure · Cross-version identity bridges.

**`:3283`** (§28.8) — the standing lattice is explicitly open, and its candidate states are named as *candidates*. Bears on (b).
> The exact standing lattice—supported, refuted, both, suspended, unknown, stale, contested, consumed, or other states—plus conflict resolution and query APIs remains open. Standing must remain a state query outside ClaimId.

**`:3311–3322`** (§28.15, "Not deferred") — the counter-list; these are closed.
> The following are settled by this document and are not open implementation choices:
>
> - the ClaimId envelope fields and their required status;
> - ClaimId as the canonical envelope rather than a selected hash;
> - scope, subject-time, basis, frame, and profile-location as identity coordinates;
> - exclusion of policy, procedure history, claimant, provenance, lineage, standing, and revocation from ClaimId by default;
> - typed WarrantTarget as complete ClaimId plus boundaries;
> - exact subject-time for direct target matching;
> - constrained broad-to-narrow scope matching and forbidden widening;
> - closed schemas and fail-closed unknown fields;
> - inert v1 warrant migration and new authorized replay/re-attestation;
> - separation of semantic identity from truth, authority, admissibility, and standing.

**`:3475–3477`** (§30.8, change boundary).
> This artifact performs no Common Lisp or Python implementation, no v1 migration, no CD/0 redesign, no cryptographic selection, and no authority/standing adjudication. It ends at the constitutional specification and implementation handoff.

**[ERRATA] `:3154`** (I12(e), inert/live warrant debt) — a named future obligation and a present prohibition. Bears on (b) and (d).
> Inert/live warrant separation is a mandatory debt of the future warrant constitution. The present identity implementation may parse inert testimony and may refuse restoration. It MUST NOT invent issuance, standing, revocation, custody, revival, or live-authority transitions.

---

## LCI/0 §3 — ALGEBRAIC LAWS, "LAW HOLDS", PRESERVED VIOLATIONS, AND D2

### 3.1 What the algebraic-law audit is, and what it is not

`experiments/latent-lisp/mneme/lci0/audit/README.md:1–5`:
> # LCI/0 algebraic-law audit harness
>
> This directory is audit infrastructure only. It does not alter relation,
> matching, policy, validation, fixture, vector, or CD/0 behavior. The frozen
> Errata 0.1 design packet remains an external checksum-bound input.

`…/audit/README.md:24–28`:
> The Python and Common Lisp runners independently construct and validate the
> 36-value temporal and 13-value scope domains, then execute their native public
> operations. The neutral comparator consumes JSONL records only. A law failure
> produces a minimized, non-repair-authorized witness; it never changes production
> semantics.

### 3.2 What "law holds" means, operationally

The inventory is external and checksum-bound. Harness census gate, `law_audit.py:496–498`:
```python
    if len(laws) != 68 or sum(row["codex_hard_gate"] for row in laws.values()) != 50:
        raise AuditAuthorityError("inventory census mismatch")
```
Bears on the meaning of "holds": a law is **evaluated per language** over a **finite enumerated domain** (36 temporal values / 13 scope values; pairs and triples thereof), and each `(law_id, language)` row records `cases`, `failures`, and a `status` of `PASS` or `FAIL` — `law_audit.py:487–491`:
```python
def _record_check(results, law_id, language, cases, failures, evidence):
    results.append({"law_id": law_id, "language": language, "cases": cases,
                    "failures": len(failures), "status": "FAIL" if failures else "PASS",
                    "smallest_failure": failures[0] if failures else None,
                    "evidence_mode": evidence})
```
Laws in the hard-gate set that the enumeration does not reach are recorded as PASS **by a different evidence mode**, explicitly named — `law_audit.py:765–768`:
```python
    for law_id in baseline_ids:
        results.append({"law_id": law_id, "language": "both-identically", "cases": 1,
                        "failures": 0, "status": "PASS",
                        "evidence_mode": "frozen-baseline-regression-suite"})
```
The audit also declines to treat cross-language agreement as independent corroboration — `law_audit.py:787–788`:
```python
    write_json(evidence / "baseline-nonregression.json", {"receipts": baseline_receipts,
        "decision": "pass", "cross_language_agreement_is_independent_corroboration": False})
```

Underlying normative laws for the two relation vocabularies live in the spec: §11.2 `scope-relation` (`:1269–1288`), §11.5 narrowing/widening (`:1303–1320`), §12 temporal roles and matching (`:1348–1444`), and §17 (quoted above). The composition tables the harness gates against are external packet artifacts (`LCI0-TEMPORAL-COMPOSITION-TABLE.json`, `LCI0-SCOPE-COMPOSITION-TABLE.json`) — see §U3.

### 3.3 How a violated law is recorded — "preserved violations"

Terminal status string, `law_audit.py:771–772`:
```python
    final = ("AUDIT COMPLETE — MINIMIZED LAW VIOLATIONS PRESERVED; AUTHORIAL RULING REQUIRED"
             if failures else "AUDIT COMPLETE — NO REQUIRED-LAW VIOLATIONS FOUND")
```
The witness record's terminal fields, `law_audit.py:689`:
```python
        "failure-classification": classification, "repair-authorized": False, "repair-lane-status": "stopped",
```
Three failure classifications exist: `"implementation-defect"` (default, `law_audit.py:631`), `"shared-required-law-violation"` (both languages fail identically, `:735`), and `"cross-language-divergence"` (`:744`).

**Read out of the sealed evidence archive** (`audit/LCI0-ALGEBRAIC-LAW-AUDIT-EVIDENCE.zip`, sha256 `798a28dd…5c78f83`, matching its tracked sidecar):

- `final-status.txt`, complete file contents:
  > AUDIT COMPLETE — MINIMIZED LAW VIOLATIONS PRESERVED; AUTHORIAL RULING REQUIRED
- `law-results.jsonl`: **88 rows over 50 distinct law ids — 84 PASS, 4 FAIL.**
- The four FAIL rows, verbatim tuples `(law_id, language, failures, cases)`:
  `('LCI0-CROSS-004', 'python', 6, 94)` · `('LCI0-SCOPE-015', 'python', 4, 48)` · `('LCI0-TEMP-022', 'common-lisp', 12, 25)` · `('LCI0-TEMP-028', 'python', 2, 46)`
- `minimized-witnesses.jsonl`: **6 witnesses**, all `law-classification: NORMATIVE-REQUIRED`, all `repair-authorized: false`, all `repair-lane-status: stopped` —
  `LCI0-LAW-WIT-PYTHON-LCI0-CROSS-004-0001` (implementation-defect) ·
  `LCI0-LAW-WIT-PYTHON-LCI0-SCOPE-015-0001` (implementation-defect) ·
  `LCI0-LAW-WIT-PYTHON-LCI0-TEMP-028-0001` (implementation-defect) ·
  `LCI0-LAW-WIT-COMMON-LISP-LCI0-TEMP-022-0001` (implementation-defect) ·
  `LCI0-LAW-WIT-CROSS-LANGUAGE-LCI0-TEMP-028-0001` (cross-language-divergence) ·
  `LCI0-LAW-WIT-CROSS-LANGUAGE-LCI0-TEMP-022-0001` (cross-language-divergence)

Carried release-floor status row, `experiments/latent-lisp/mneme/verify-release.sh:360`, verbatim:
> lci0|KNOWN-UNRESOLVED|LCI/0 algebraic-law audit: 84 laws PASS, 4 laws preserved FAIL|LCI0-CROSS-004, LCI0-SCOPE-015, LCI0-TEMP-022, LCI0-TEMP-028 remain preserved failures with six minimized witnesses; the lane's own evidence reads "AUDIT COMPLETE — MINIMIZED LAW VIOLATIONS PRESERVED; AUTHORIAL RULING REQUIRED". No authorial disposition exists. This milestone does not repair, adjudicate, or rebuild them.

Header of the section that carries it, `verify-release.sh:355`:
> \# DECLARED, NOT EXECUTED — carried honestly, never turned green

**Clerk's note on a wording drift (bears on any citation of these numbers):** the DECLARED row says "84 laws PASS". The archive's `law-results.jsonl` shows **84 PASS *rows*** across `(law_id, language)` pairs over **50 distinct law ids**, and the harness gate asserts an inventory of **68 laws, 50 of them `codex_hard_gate`**. "84 laws" is therefore a row count, not a law count. Quote the row verbatim; do not restate it as 84 distinct laws.

### 3.4 The D2 deferral

Two texts. The owner ruling, verbatim, `corpus/voices/received/2026-08-30-joint-return-owner-and-sol-succession-census-01-ACCEPTED-q1-o1-o3-ruled.md:72–80`:
> ## OWNER RULING O2 — LCI/0 D2
>
> **LCI/0 remains CLOSED. D2 is DEFERRED INDEFINITELY.**
>
> The four preserved law violations remain preserved exactly as findings. They are not cured, waived, adjudicated away, or promoted into present work.
>
> "AUTHORIAL RULING REQUIRED" is henceforth read as a gate on any future act that would reopen LCI/0, promote its standing, repair those findings, or rely on a claim requiring their disposition. It is not a live commission and creates no present obligation.
>
> Any future reopening requires a fresh owner act naming its scope.

The stone's entry of it, verbatim, `experiments/latent-lisp/mneme/architecture/ARCHITECTURE-0-STATUS.md:1317–1318` (ADDENDUM 22, item 6):
> 6. **O2 (owner):** **LCI/0 remains CLOSED; D2 DEFERRED INDEFINITELY.** The four preserved violations stay preserved as findings.
>    "AUTHORIAL RULING REQUIRED" = a gate on any future reopening/promotion/repair, not a live commission.

Restated in the succeeding addendum, `ARCHITECTURE-0-STATUS.md:1360` (ADDENDUM 23, item 7, excerpt):
> LCI/0 D2 remains DEFERRED INDEFINITELY

**What "D2" names.** The label is a row in the LCI/0 implementation ledger, `experiments/latent-lisp/mneme/lci0/evidence/LCI0-IMPLEMENTATION-LEDGER.md:64` (blob `61caa80b54413d2c50555df52862c203df30a70e`, commit `fb0dc622` 2026-07-15), verbatim:
> | D2 | Temporal model and relation table without converting containment into direct target support | LCI §13; Errata E1, E2, E5 | 289 temporal relation documents; temporal vectors | `common-lisp/calculi.lisp`, `common-lisp/matching.lisp`, `common-lisp/pre-seed-red-tests.lisp` | `python/lci0/core.py`, `python/tests/test_red_boundaries.py` | Full relation-table execution; `LCI0-DIV-001`, `005`, `014` | BLOCKED | Exact relation values are machine-pinned; 14 companion paths await closure |

See UNVERIFIED §U5 on whether the ledger's D2 and the ruling's D2 are the same referent.

---

## SILENCES — what neither text says

Each item below is a proposition the clerk could not find asserted in either CD/0 (S1+S2) or LCI/0 (S5+S6). Where a text explicitly *declines* the subject, the declining clause is cited; where the text is merely silent, that is marked SILENT (no clause found).

1. **A truth value, or any "verified / true / confirmed" marker on a datum or claim.** Both texts refuse it explicitly: `CANONICAL-DATUM-SPEC.md:84` ("truth, authenticity, freshness, admissibility, or verified lineage") and `:1503`; `LOCATED-CLAIM-IDENTITY-SPEC.md:118` ("declare any claim true, authoritative, fresh, admissible, or currently standing").
2. **A standing lattice — i.e. the actual set of epistemic states a claim may be in.** LCI/0 names candidates and defers: `LOCATED-CLAIM-IDENTITY-SPEC.md:3283`. CD/0 does not raise the subject beyond `:80`. **No enumeration exists in either text.**
3. **An "observed vs asserted" binary as a *datum status*.** LCI/0 has `observed` and `reported` as **WarrantTarget kinds** (`:923`, `:1024`), never as a status field on a claim or a datum. CD/0 has one adjacent phrase, and it is a migration instruction, not a status: `:1694` ("Preserve 'untrusted raw decode' as an explicit provenance/status identifier"). **SILENT** on a datum-level observed/asserted marker.
4. **Any notion of "candidate" or "adopted" as a document/claim status.** Neither text defines these. They are lab governance vocabulary (`ARCHITECTURE-0-STATUS.md` passim); they are not CD/0 or LCI/0 terms. **SILENT.**
5. **Who the actors are.** Both texts speak of "a conforming implementation", "a validator", "an adapter", "a policy", "a claimant", "an issuer" — none is given an identity scheme by these texts. LCI/0 defers actor identity: `:3289` (§28.9), `:3291` (§28.10). CD/0: `:81`, `:1675` (principal identifiers row).
6. **Retention duration, expiry, or deletion policy for evidence.** Both texts govern *what a record must contain* and *what may not be silently dropped* (CD `:1435`; LCI `:1726`, `:1811`), and neither states how long anything is kept or when it may be deleted. **SILENT.**
7. **Cost, budget, or effort as a property of a claim or warrant.** CD/0 has resource budgets, but only as a *decode/encode refusal* mechanism (§21), never as a recorded property of an output. LCI/0 has `F("resource-refusal")` (`:2039`) and nothing else. **SILENT.**
8. **Confidence, probability, or degree.** LCI/0 forbids using it as identity — `:1698` ("Confidence that a missing field was 'probably' some value is not equality") — and mentions "quantity/uncertainty records" only as a deferred proposition-grammar item (`:3255`). CD/0 treats a confidence float as a migration problem, not a semantic category (`:1685`). **No degree vocabulary exists in either text.**
9. **A registry, index, or lookup as authority.** Both texts refuse: CD `:1694` ("Process-local registries, package names, gensym identity, object addresses | **Rejected**"); LCI `:77`, `:920`, `:1534`. **This is an explicit joint refusal, not a silence.**
10. **How a claim is *retracted*.** LCI/0 names revocation as an input to admissibility and standing (`:294`, `:300`) and defers its semantics (`:3287`). Neither text defines a retraction operation. **SILENT.**
11. **Any obligation on a *reader* to act.** Both texts bind producers, encoders, decoders, validators, matchers, adapters, and policies. Neither defines a duty attaching to a consumer of a claim beyond validation. **SILENT.**
12. **Multi-party or quorum evidence.** LCI/0 defers it inside admissibility policy (`:3279`, "independence, conflict, quorum") and inside verified lineage (`:3299`, "multi-party testimony"). Neither text supplies a rule. **Deferred, not silent.**

---

## UNVERIFIED

**U1 — The charge asked for CD/0's adoption status quoted from `ARCHITECTURE-0-STATUS.md`. There is no such sentence in that file.** A `grep -n -E "CD/0|Canonical Datum|CANONICAL DATUM"` over `ARCHITECTURE-0-STATUS.md` returns exactly three hits — `:571`, `:574`, `:794` — all incidental references inside other addenda (Adapter /0 erratum, the Vertical /0 assembled-stack list, a memory-account body description). None is a status sentence for CD/0. The status quotes in row S1 are therefore drawn from `CD0-FREEZE-DECLARATION.md:5,7` and `LISP-PLUS-LATENT-MACHINE-ARCHITECTURE-0.1.md:1224`, both named in the row. **The clerk did not find, and does not assert, a CD/0 adoption sentence in the file the charge named.**

**U2 — `mneme/canon/CANONICAL-SPEC-v0-DRAFT.md` (S12) is not a CD/0 source.** It specifies `mneme-canon/0`, a *different and superseded* canonical byte encoding, and CD/0 says so explicitly at `CANONICAL-DATUM-SPEC.md:1699–1709` (§26.3, "`mneme-canon/0` … is not an alternate spelling of CD/0") and `:1709` ("a migration tool may expose `import-mneme-canon-0`, but `decode-exact` never accepts that notation"). Its own status line is DRAFT (`:8–10`). It is listed for completeness and **contributes no governing clause to the collision test**.

**U3 — The algebraic-law inventory and composition tables are external.** `LCI0-ALGEBRAIC-LAW-INVENTORY.json`, `LCI0-TEMPORAL-COMPOSITION-TABLE.json`, `LCI0-SCOPE-COMPOSITION-TABLE.json`, `LCI0-LAW-WITNESS-SCHEMA.json`, and `LCI0-SEMANTIC-DRIFT-SURFACE.json` are read by `law_audit.py` from `--packet-dir`, i.e. from `LCI0-ALGEBRAIC-LAW-AUDIT-PACKET-ERRATA-0.1.zip` (`PACKET_SHA256 = "61451eaa5f7682544b2ccc5aeebc7c94a82417b32b3029abb80d3e3af4277176"`, `law_audit.py:53`). **That packet is not in this tree.** The clerk therefore quotes the *plain-language statement* of no individual law and cannot state what any of the 68 laws says. Everything in §3.2 above about "law holds" is read from the harness code and from the sealed evidence archive, not from the law texts.

**U4 — Not read this sitting:** `CD0-POST-IMPLEMENTATION-RULING.md` (S3, hash-verified only), `LCI0-NORMATIVE-FIXTURE-PACKAGE-SPEC.md` (S8, 274,969 bytes), `LCI0-POST-REVIEW-RULING.md` §§3–end (S7, read to `:60`), the whole of LCI/0 §§6, 7.1–7.11, 19, 20, 21 (the twenty worked scenarios), 22, 24–27, and CD/0 §§8, 10–16, 18, 19.1–19.5, 21.1–21.5, 23.1–23.3, 27–30. **Any clause in the unread ranges could bear on (a)–(e) and is not represented here.** The §31/§28 deferral lists and the §33/§30 receipts were read in full, so the "declines to govern" sets above are complete *as those texts state them*.

**U5 — "D2" has at least two referents in the tree and the clerk did not establish they are the same.** (i) `LCI0-IMPLEMENTATION-LEDGER.md:64` D2 = a work-item row ("Temporal model and relation table…", status BLOCKED). (ii) The owner ruling O2 speaks of "D2" alongside "the four preserved law violations", of which two (`LCI0-TEMP-022`, `LCI0-TEMP-028`) are temporal-domain laws and two (`LCI0-SCOPE-015`, `LCI0-CROSS-004`) are not. The `_staging/lci0-adjudication-draft-2026-08-02.md` and `PROJECT-STATE-ASSESSMENT-2026-08-02.md:224` ("rule on the 4 violations (D2)") treat D2 as the adjudication of the four violations. **The clerk reports both readings and asserts neither.** Quote O2 verbatim rather than expanding "D2".

**U6 — Nothing here was executed.** No codec was run, no audit was re-run, no vector was checked. Every conformance-shaped statement above is a quotation of a document or a read of a sealed evidence file, never a measurement made by this clerk. The only measurements performed are: `git log`, `git hash-object`, `sha256sum`, `unzip -l`/`unzip -p` on a read-only archive, `grep -n`, and `wc`.

**U7 — Line numbers.** Every `file:line` above was obtained by `grep -n` on a distinctive substring of the quoted text, or by `sed -n` over a heading-anchored range. Multi-line quotes cite the line of their **first** quoted line. A file edited after this sitting will shift them; the blob shas in SOURCES pin the exact bytes read.

**U8 — The lab's memory line for this lane reads "68 executed + 3 N/A, never 71 passed."** That formula does not appear in any file the clerk read this sitting. It is not contradicted by anything read; it is simply **not sourced here**. Do not cite it to this document.

---

*CLERK-CD-LCI · reading only · no tracked file modified · no commit made.*
