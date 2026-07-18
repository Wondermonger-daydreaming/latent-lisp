# LISP-PLUS-PROCESS-JOURNAL-0-SPEC

**Status:** Normative Process Journal /0 specification candidate for Lisp+ / Mneme  
**Language:** Lisp+  
**Memory-and-continuity layer:** Mneme  
**Date:** 2026-07-18  
**Authorial lane:** GPT-5.6 Sol, under the owner charge at commit `d1b48040`  
**Governing architecture:** `LISP-PLUS-LATENT-MACHINE-ARCHITECTURE-0.1.md`, SHA-256 `dd4894d45ad55dc1c051af44fcca22367b5b0718e1129adbd30059e3a58c7161`  
**Governing kernel:** adopted `LISP-PLUS-KERNEL-0-SPEC.md`, authoring-room copy SHA-256 `386fead212bf8baccd116d673993145e6f2bea077516ee4770ebf9521503093c`  
**Controlling plan dispositions:** PJ-D1 through PJ-D5, adopted together after a mutually blind plan round  
**Implementation standing:** this packet specifies the journal and its vectors; it does not by itself authorize the Lisp+ runtime, live provider calls, spending, secret opening, or publication.

---

## 0. Normative standing

Process Journal /0 is the exact filesystem-backed evidence protocol for Mneme /0. It defines how a semantic Kernel /0 process event becomes an inspectable, prefix-valid, append-only sequence of bytes and how that sequence is recovered after interruption.

The journal is not a debug log. It is the substrate from which a process state, a retry prohibition, a reconstruction claim, and a custody account may be derived without trusting the surviving process's self-narrative.

The key words **MUST**, **MUST NOT**, **REQUIRED**, **SHALL**, **SHALL NOT**, **SHOULD**, **SHOULD NOT**, **MAY**, and **OPTIONAL** are normative in the RFC-2119 sense.

Where this specification conflicts with Architecture 0.1 or Kernel /0, implementation MUST stop and name the conflict. It MUST NOT silently choose the representation that is easiest to code.

### 0.1 Adopted design dispositions

- **PJ-D1 — framing:** textual ASCII header plus exact-length canonical PJ-S/0 payload.
- **PJ-D2 — integrity:** mandatory payload digest, frame digest, and predecessor-frame digest chain.
- **PJ-D3 — writers:** one serialized logical writer per journal; multiple clients use the store protocol.
- **PJ-D4 — repair:** the damaged source is never altered; salvage creates a new journal and receipt.
- **PJ-D5 — derived storage:** indexes and snapshots are disposable; merge, redaction, compaction, and salvage create new identities and transformation receipts.

### 0.2 Constitutional laws carried here

- **L8 incremental persistence:** settled facts MUST land incrementally rather than wait in a finalizer.
- **L9 finalizer derivability:** a finalizer is a convenience, never the sole custodian of facts.
- **L10 reconstruction origin:** reconstruction remains `:reconstructed` after later verification.
- **L15 witness separation:** a self-written narrative is not observation wherever it is filed.
- **L17 ergonomic safety:** the lawful path must not be longer than a supported bypass.

### 0.3 Scope exclusions

Process Journal /0 does not define provider envelopes, adapter projection, model configuration resolution, capability cryptography, experiment scoring, distributed consensus, transparent replication, long-term retention policy, general redaction, journal rotation, or a universal event-query language.

---
## 1. The crash-window matrix — organizing exhibit

The reference append path has four named interruption windows. Every conforming implementation MUST be able to explain the on-disk state, longest prefix-valid fold, recovery operation, and condition for each cell under both declared durability modes.

| Window | Interruption point | `:synced` journal | `:best-effort` journal |
|---|---|---|---|
| **CW-0** | before the first frame byte | prior prefix remains valid; event absent; fold unchanged; retry is governed by Kernel semantics | same byte state and fold; no event claim |
| **CW-1** | after a non-empty proper prefix of the frame | prior prefix valid; terminal bytes are `:torn-tail`; fold excludes proposed event; source remains untouched | same classification; no durability promotion |
| **CW-2** | complete frame accepted by the host write path, before the declared durability barrier | after crash the bytes MAY be absent, torn, or fully valid; actual bytes govern; no success receipt may be inferred | full frame may be visible after process death, but only `:best-effort` durability is claimed; power-loss persistence is outside the declaration |
| **CW-3** | declared durability barrier satisfied, before append receipt reaches caller | full frame MUST validate on ordinary reopen under the declared host contract; caller reconciles by event identity and receives prior coordinate | complete frame accepted by host path; caller reconciles by event identity; receipt remains `:best-effort` |

**PJ-CW-1.** The matrix is normative. A runtime that can describe ordinary success but cannot classify death between write, barrier, and receipt is not Process Journal /0 conforming.

**PJ-CW-2.** The journal reader classifies bytes; it does not reconstruct the writer's intention. A CW-2 crash may yield several lawful physical states. The validator MUST report the state actually present rather than choose the most flattering branch.

**PJ-CW-3.** CW-3 is the append-side analogue of an uncertain external write: the operation may have succeeded although its receipt was not delivered. Event-identity reconciliation MUST make retry idempotent.

**PJ-CW-4.** The fixture packet includes deterministic examples for all representable cells and a randomized SIGKILL harness for the live complement.

---
## 2. Kernel / Journal jurisdiction

### 2.1 Kernel /0 owns

Kernel /0 owns event semantics, event kinds, legal transitions, process identity, attempt and seat identity, capability and effect meaning, fold rules, no-blind-retry law, reconstruction origin, typed semantic conditions, and the distinction between a process outcome and a derived view.

### 2.2 Process Journal /0 owns

Process Journal /0 owns:

1. the exact human-readable PJ-S/0 grammar;
2. metadata syntax;
3. frame syntax and canonical bytes;
4. digest procedures;
5. append and reconciliation behavior;
6. filesystem reference layout;
7. serialized writer coordination;
8. durability declarations;
9. prefix validation;
10. torn-tail and corruption classification;
11. source-preserving salvage;
12. snapshot and index standing;
13. merge input and receipt representation;
14. fixture octets and reference transcripts.

### 2.3 Non-interference

**PJ-JUR-1.** The journal MUST reject structurally malformed events and MUST expose semantic events to the Kernel validator. It MUST NOT invent a new legal transition because the bytes are well formed.

**PJ-JUR-2.** A Kernel implementation MUST NOT assume newline-delimited events, host-reader forms, filesystem rename semantics, or another byte rule not stated here.

**PJ-JUR-3.** A journal may preserve an illegal event as evidence in a quarantined source, but a conforming primary journal MUST NOT commit it as a lawful process transition.

---
## 3. Terminology and domains

- **abstract event:** the Kernel /0 canonicalizable process-event datum.
- **PJ-S/0 payload:** the canonical human-readable S-expression rendering of one abstract Canonical Datum /0 value.
- **frame:** one ASCII header, one exact-length PJ-S/0 payload, and one LF terminator.
- **journal:** one immutable metadata datum plus one append-only `EVENTS.pj0` sequence.
- **committed frame:** a complete structurally valid frame admitted under the store's append protocol.
- **valid prefix:** the maximal contiguous sequence of valid frames from ordinal 1.
- **torn tail:** an incomplete final frame beginning immediately after a valid prefix.
- **interior corruption:** a validation failure that is not merely terminal incompleteness.
- **append receipt:** evidence returned for a newly committed or already-identical event.
- **salvage:** a receipt-bearing transformation from a damaged source's valid prefix into a new journal.
- **snapshot:** a disposable derived fold acceleration bound to an exact source prefix.
- **resolvedness:** a fold-derived property; never a mutable record flag.

**PJ-TERM-1.** The terms “written,” “flushed,” “synced,” “committed,” “acknowledged,” and “observed” are not synonyms.

---
## 4. Reference store layout

A reference store is one directory:

```text
<store>/
    JOURNAL-META.pjs
    JOURNAL-META.pjs.sha256
    EVENTS.pj0
    LOCK
```

`JOURNAL-META.pjs` is immutable after store creation. `EVENTS.pj0` is the single append-only event file for Process Journal /0. `LOCK` is ephemeral coordination state and is not evidence.

**PJ-FS-1.** Event rotation and segmentation are deferred. A conforming /0 store has exactly one primary event file.

**PJ-FS-2.** Caches, indexes, snapshots, and reports MAY exist outside this minimum layout. They MUST be deletable without deleting primary history.

**PJ-FS-3.** The reference implementation MUST create files with owner-only permissions where the host permits. Permission policy does not replace Lisp+ visibility and authority records.

**PJ-FS-4.** Moving or copying a store does not change its store identity. A claim about its current filesystem location is a separate located claim.

---
## 5. PJ-S/0 — canonical human-readable datum grammar

PJ-S/0 is a data-only grammar mapping bijectively to the Canonical Datum /0 abstract domain. It is not Common Lisp source syntax, although it deliberately resembles a restrained S-expression language.

### 5.1 Prohibition on host `READ`

**PJ-SYN-1.** A conforming evidence parser MUST implement PJ-S/0 as data. It MUST NOT normatively delegate parsing to Common Lisp `READ`, Python `eval`, an EDN reader with extensions, or another executable/general reader.

Disabling `*read-eval*` is insufficient: host package semantics, symbol interning, reader macros, numeric syntax, case behavior, and implementation-specific printer conventions remain outside the canonical protocol.

### 5.2 Lexical layer

Whitespace is ASCII SP, TAB, LF, or CR. Canonical output uses one ASCII SP between adjacent tokens and no leading or trailing whitespace inside a payload.

The token alphabet and forms are:

```abnf
unit       = "#u"
false      = "#f"
true       = "#t"
integer    = "0" / [1-9] *DIGIT / "-" [1-9] *DIGIT
rational   = "(rat " integer " " positive-denominator ")"
string     = DQUOTE *string-item DQUOTE
bytes      = "#x" DQUOTE *lower-hex-pair DQUOTE
identifier = "(id" 1*(SP string) ")"
sequence   = "(seq" *(SP datum) ")"
record     = "(rec" *(SP "(" identifier SP datum ")") ")"
datum      = unit / false / true / integer / rational / string / bytes /
             identifier / sequence / record
```

### 5.3 Unit and booleans

`#u`, `#f`, and `#t` are the only spellings.

### 5.4 Integers

Integers use base-10 ASCII with no plus sign, no leading zeros, and no negative zero.

### 5.5 Rationals

A non-integer rational is `(rat N D)` where `D > 1`, `gcd(abs(N),D)=1`, and the sign is carried only by `N`. A rational with denominator one MUST render as an integer.

### 5.6 Strings

Strings contain Unicode scalar values. U+0022 is `\"`; U+005C is `\\`. U+0000 through U+001F and U+007F use `\u{h}` with lowercase hexadecimal and no redundant leading zero. Every other scalar is emitted directly as UTF-8.

Alternative escapes such as `\n`, `\t`, `\x0a`, uppercase hex, or escaping an otherwise printable scalar are noncanonical.

### 5.7 Byte strings

Byte strings use lowercase hexadecimal inside `#x"..."`, exactly two digits per octet. Empty bytes are `#x""`.

### 5.8 Identifiers

Identifiers contain one or more string segments: `(id "process" "p-001")`. No host symbol or package name is created while decoding.

### 5.9 Sequences

Ordered sequences use `(seq ...)`. `(seq)` is the empty sequence.

### 5.10 Records

Records use `(rec (KEY VALUE) ...)`, where each key is an identifier. Keys are unique and appear in Canonical Datum /0 identifier order. `(rec)` is the empty record.

### 5.11 Canonicality

**PJ-SYN-2.** A parser MUST decode a payload, re-encode it canonically, and require byte identity. Parseability without byte identity is noncanonical and MUST be refused.

**PJ-SYN-3.** PJ-S/0 does not redefine Canonical Datum /0 equality. If an implementation discovers a conflict between this rendering and CD/0's abstract domain, it MUST stop and name the conflict.

---
## 6. Journal metadata

`JOURNAL-META.pjs` is one canonical PJ-S/0 record followed by LF. It contains:

```lisp
(rec
  ((id "pj0" "cd0-version") "0")
  ((id "pj0" "creation-procedure") (id ...))
  ((id "pj0" "declared-durability") (id "pj0" "synced"))
  ((id "pj0" "format-version") 0)
  ((id "pj0" "genesis-digest") #x"...")
  ((id "pj0" "store-id") (id "pj0-store" "..."))
  ((id "pj0" "store-nonce") #x"...")
  ((id "pj0" "witness-policy") (id ...)))
```

### 6.1 Store identity

The store identity is:

```text
hex(SHA-256("PJ0-STORE-ID-0" || NUL || PJ-S/0(metadata-without-store-id)))
```

The public identity form is `(id "pj0-store" HEX)`.

**PJ-META-1.** `store-nonce` MUST contain at least 128 unpredictable bits for nonce-issued stores. A content-addressed store MAY use a different declared identity procedure if Kernel /0's identity floor is met.

**PJ-META-2.** The reference metadata sidecar contains the lowercase SHA-256, two ASCII spaces, filename, and final LF.

**PJ-META-3.** Metadata mutation after the first committed event is corruption. A change of durability mode, witness policy, or canonical version requires a new store identity and a receipt-bearing transformation.

---
## 7. Frame grammar

Each frame is:

```text
PJ0F 0 ORDINAL PAYLOAD-LENGTH PAYLOAD-SHA256 PREVIOUS-FRAME-SHA256 FRAME-SHA256 LF
PAYLOAD-OCTETS LF
```

All header characters are ASCII. Fields are separated by one SP. There is no leading or trailing SP.

### 7.1 Header fields

- `PJ0F`: literal magic.
- `0`: frame format version.
- `ORDINAL`: canonical unsigned decimal, beginning at 1.
- `PAYLOAD-LENGTH`: canonical unsigned decimal count of UTF-8 payload octets.
- `PAYLOAD-SHA256`: lowercase 64-character hexadecimal SHA-256 of payload octets.
- `PREVIOUS-FRAME-SHA256`: predecessor frame digest, or the fixed genesis digest for ordinal 1.
- `FRAME-SHA256`: digest defined in §8.

### 7.2 Payload boundary

The reader consumes exactly `PAYLOAD-LENGTH` octets after the header LF. The following octet MUST be LF. The LF is framing and is not part of the PJ-S/0 payload digest.

**PJ-FRM-1.** Embedded LF in strings is encoded as `\u{a}`; pretty diagnostic renderings may show line breaks but canonical payloads do not rely on line framing.

**PJ-FRM-2.** Header decimal and digest fields have exactly one canonical spelling. Uppercase hexadecimal and redundant leading zeros are corruption.

**PJ-FRM-3.** A frame may be inspected with ordinary text tools while still having an exact byte boundary independent of lines in the abstract event.

---
## 8. Digest procedures

### 8.1 Genesis digest

The Process Journal /0 genesis digest is lowercase hexadecimal SHA-256 of the ASCII bytes `PJ0-GENESIS-0`.

### 8.2 Payload digest

`PAYLOAD-SHA256 = SHA-256(PAYLOAD-OCTETS)`.

### 8.3 Frame digest

The frame digest preimage is:

```text
"PJ0-FRAME-0" || NUL ||
ASCII(STORE-ID) || NUL ||
ASCII(ORDINAL) || NUL ||
ASCII(PAYLOAD-LENGTH) || NUL ||
RAW(PAYLOAD-SHA256) ||
RAW(PREVIOUS-FRAME-SHA256)
```

`RAW` converts lowercase hexadecimal to 32 octets. `STORE-ID` is the public `pj0-store:HEX` string used by the reference vector procedure.

### 8.4 Standing of hashes

**PJ-HASH-1.** The digest chain detects accidental mutation, frame reordering, deletion within the visible sequence, and cross-store splicing when validated with metadata.

**PJ-HASH-2.** The digest chain is not a signature, timestamp authority, independent notarization, or proof that the recorder's claim is true.

**PJ-HASH-3.** Integrity standing and epistemic origin remain distinct.

---
## 9. Append protocol

### 9.1 Proposed event

The client presents one canonicalizable Kernel /0 event and its durable event identity. The store canonicalizes to PJ-S/0 before taking the append lock where practical.

### 9.2 Serialized critical section

Under the exclusive writer lock, the store MUST:

1. reopen or validate the current terminal prefix;
2. look up the event identity;
3. if identical, return the prior coordinate without appending;
4. if conflicting, refuse;
5. assign `last-ordinal + 1`;
6. construct the frame using the current terminal digest;
7. append the exact frame bytes;
8. perform the declared durability barrier;
9. optionally reopen/validate according to the reference implementation;
10. return an append receipt.

### 9.3 Idempotency by event identity

**PJ-APP-1.** New identity and new payload append exactly one frame.

**PJ-APP-2.** Existing identity with byte-identical canonical payload returns `:already-committed-identical` and the existing coordinate. It MUST NOT append a duplicate frame.

**PJ-APP-3.** Existing identity with different payload signals `event-identity-collision`. Last-write-wins is prohibited.

### 9.4 Append receipt

A receipt carries:

```lisp
(rec
  ((id "receipt" "append-disposition") (id "pj0" "newly-committed"))
  ((id "receipt" "declared-durability") (id "pj0" "synced"))
  ((id "receipt" "event-id") (id ...))
  ((id "receipt" "frame-digest") #x"...")
  ((id "receipt" "ordinal") 42)
  ((id "receipt" "payload-digest") #x"...")
  ((id "receipt" "previous-frame-digest") #x"...")
  ((id "receipt" "store-id") (id ...)))
```

**PJ-APP-4.** A receipt that was never delivered may be reconstructed by event-identity lookup. The reconstructed receipt's origin is `:reconstructed`.

**PJ-APP-5.** The event frame, not the receipt object living in caller memory, is the primary append fact.

---
## 10. Durability declarations

### 10.1 `:synced`

A `:synced` append returns success only after the full frame is written and the implementation invokes the strongest reference-host file synchronization contract it declares. Store creation additionally synchronizes required directory entries where the host API exposes that operation.

The reference implementation SHOULD reopen and validate the newly committed terminal frame before returning in conformance tests.

### 10.2 `:best-effort`

A `:best-effort` append returns after the complete frame is accepted by the host write path and local structural checks succeed. No power-loss persistence is claimed.

### 10.3 No promotion

**PJ-DUR-1.** A `:best-effort` receipt remains `:best-effort` even if the bytes later survive.

**PJ-DUR-2.** A journal's declared durability does not change in place.

### 10.4 Host honesty, including WSL

**PJ-DUR-3.** `:synced` is a declared host-contract belief, not metaphysical certainty. Conformance can test system-call completion, ordinary close/reopen visibility, directory handling, and crash behavior. It cannot prove persistence through every storage controller, hypervisor, firmware layer, or sudden power loss.

On WSL or another layered filesystem, the implementation MUST record the host/storage environment in its conformance receipt and state which durability claims are tested, inherited from an OS contract, or bounded by virtualization. A green `fsync` return MUST NOT be narrated as independent physical proof.

---
## 11. Locking and concurrency

### 11.1 Model

Process Journal /0 supports multiple clients and one serialized logical writer per journal. The reference store uses an exclusive advisory or mandatory host lock sufficient for its environment.

### 11.2 Ordering

The authoritative physical order is journal ordinal. Wall-clock timestamps may ride as claims but MUST NOT assign or repair ordering.

### 11.3 Lock death

**PJ-LOCK-1.** If a writer dies while holding the lock, a later writer MUST validate the journal from the last trusted prefix. It MUST NOT assume that the interrupted append failed.

**PJ-LOCK-2.** Lock files and lease state are coordination machinery, not committed evidence.

**PJ-LOCK-3.** Two concurrent requests for the same event identity produce one committed frame and one identical-event reconciliation, or a typed collision if payloads differ.

### 11.4 Deferred distributed ordering

Lock-free multiwriter append, network partitions, leader election, and cross-host consensus are out of scope for /0.

---
## 12. Reader and prefix-validation algorithm

The reader starts at byte zero of `EVENTS.pj0` with expected ordinal 1 and the genesis predecessor digest.

For each frame it MUST validate, in dependency order:

1. complete header LF or terminal partial-header classification;
2. ASCII header encoding;
3. field count, magic, and version;
4. canonical decimal and lowercase digest syntax;
5. expected ordinal;
6. exact payload length availability;
7. required frame-separator LF;
8. payload SHA-256;
9. predecessor digest;
10. frame digest;
11. strict UTF-8;
12. PJ-S/0 parse;
13. byte-identical canonical re-rendering;
14. required structural event identity;
15. duplicate event-identity prohibition;
16. Kernel semantic validation where the caller requests a lawful process fold.

**PJ-VAL-1.** The reader returns the maximal valid prefix, terminal classification, terminal digest, valid byte count, and evidence for any excluded tail.

**PJ-VAL-2.** The reader MUST NOT mutate the source while validating.

**PJ-VAL-3.** A structurally valid frame containing a Kernel-illegal transition is not silently skipped. Structural and semantic standings are reported separately.

---
## 13. Terminal classifications

### 13.1 Valid end

EOF immediately after the LF terminating a valid frame, or at byte zero for an empty event file, is `:valid-end`.

### 13.2 Torn tail

A torn tail is an incomplete final frame beginning immediately after the valid prefix. The following are torn-tail forms:

- partial header at EOF;
- complete header with fewer payload octets than declared;
- complete payload at EOF with missing terminating LF.

A zero-byte truncation before the next frame is indistinguishable from a valid journal ending at the previous frame and is classified `:valid-end`, not torn tail.

### 13.3 Interior corruption

The following are corruption, not a torn tail:

- bad complete header;
- noncanonical numbers or digest spelling;
- wrong ordinal;
- wrong payload digest;
- wrong predecessor digest;
- wrong frame digest;
- malformed UTF-8 in a complete payload;
- parseable but noncanonical PJ-S/0;
- duplicate committed event identity;
- an unexpected byte where the frame LF is required;
- extra bytes between complete frames;
- validation failure in a nonterminal complete frame.

### 13.4 No skip-forward recovery

**PJ-TERM-1.** A reader MUST NOT scan forward for the next plausible `PJ0F` header after corruption. Plausibility is not custody.

---
## 14. Source-preserving salvage

### 14.1 No automatic truncation

Opening a journal MUST NOT truncate a torn tail, rewrite a bad digest, reorder a record, or patch metadata.

### 14.2 Salvage operation

`salvage-valid-prefix` creates a new store containing exactly the source's valid prefix under a new store identity. It emits a salvage receipt carrying:

- source store identity;
- source metadata digest;
- source valid-byte count;
- source terminal ordinal and digest;
- tail byte count and tail SHA-256;
- terminal classification;
- salvage procedure identity/version;
- destination store identity;
- copied event identities;
- operator and authority;
- missing evidence and bounded unknowns.

**PJ-SAL-1.** The source remains byte-identical.

**PJ-SAL-2.** The destination's frames are regenerated for its new store identity; frame digests therefore differ even when abstract events are identical.

**PJ-SAL-3.** Salvage does not claim that an excluded torn frame had no external consequence.

---
## 15. Witness separation and epistemic origin

The journal preserves events from several capture mechanisms. Storage integrity does not upgrade epistemic origin.

A kernel-mediated transition event SHOULD record:

- recorder principal;
- subject principal;
- capture mechanism identity;
- capture boundary;
- origin facet;
- evidence references;
- authority and visibility scope.

**PJ-WIT-1.** A process narrative about its own history has origin `:asserted` unless a distinct witnessing mechanism captured the described event at the relevant boundary.

**PJ-WIT-2.** Saving a self-report into `EVENTS.pj0` does not make the report observed.

**PJ-WIT-3.** The canonical kernel-mediated journal is the default witness for kernel-mediated transitions because the store captures the transition at the commit boundary. A provider receipt or operating-system witness may separately carry observational standing.

**PJ-WIT-4.** Later validation may raise a validation facet; it MUST NOT rewrite origin.

---
## 16. Resolvedness is fold-derived

No event, uncertain-effect record, attempt record, or journal frame may carry a mutable boolean such as `:resolved #t` whose value is treated as sole truth.

An uncertain effect is currently resolved only when the longest valid prefix contains a lawful reconciliation or supersession transformation that, under Kernel /0, disposes of the uncertainty.

**PJ-FOLD-1.** Timeout, file age, process death, successful later work, or a missing provider lookup result does not resolve an uncertain effect by itself.

**PJ-FOLD-2.** Reconciliation events reference the uncertain-effect identity and evidence. The fold derives the current resolution state.

**PJ-FOLD-3.** A later refutation or superseding reconciliation remains append-only. Earlier uncertainty is not erased from history.

---
## 17. Fold integration and unsupported reconstruction

### 17.1 Longest-prefix fold

The Kernel fold consumes abstract events decoded from the longest structurally valid prefix. A torn tail contributes tail evidence but no event.

### 17.2 Structural versus semantic stop

If the prefix is structurally valid but contains a Kernel-illegal transition, the store returns the structural prefix and the Kernel fold signals its semantic condition. The store MUST NOT manufacture a smaller “lawful” prefix by skipping the event.

### 17.3 Multiple unresolved occupancy

Process Journal /0 blesses Kernel condition `unsupported-reconstruction` for the /0 case where one seat has multiple non-superseded unresolved attempts and the prefix contains no lawful precedence, reconciliation, or supersession relation sufficient to derive one current occupancy.

**PJ-FOLD-4.** The fold MUST stop with `unsupported-reconstruction`. It MUST NOT select the newest timestamp, highest ordinal, cheapest result, or most complete manifestation as winner.

**PJ-FOLD-5.** A later authorized event may supply the missing relation. Until then, ambiguity is preserved.

---
## 18. Snapshots and indexes

Snapshots and indexes are derived artifacts.

A snapshot MUST bind:

- source store identity;
- source terminal ordinal;
- source terminal frame digest;
- fold identity and version;
- derived value identity;
- creation procedure;
- digest.

**PJ-SNP-1.** If snapshot replay disagrees with primary-prefix replay, the snapshot loses.

**PJ-SNP-2.** Deleting every snapshot and index MUST NOT prevent reconstruction.

**PJ-SNP-3.** Snapshots MUST NOT be appended to the primary event file as substitutes for omitted events.

**PJ-SNP-4.** A deterministic snapshot may be byte-compared only under the named deterministic rendering procedure.

---
## 19. Reconstruction receipts

A reconstruction is a transformation from one exact journal prefix to a derived view.

The receipt carries:

- source store identity;
- source metadata digest;
- terminal ordinal and frame digest;
- event identities consumed;
- fold identity/version;
- ordering rule;
- conflict policy;
- missing evidence;
- output identity and digest;
- replay result;
- operator/implementation identity;
- origin `:reconstructed`.

**PJ-RCN-1.** Verification of a reconstruction may change validation standing. Origin remains `:reconstructed`.

**PJ-RCN-2.** A finalizer output without a reproducible source prefix and fold identity is not a conforming reconstruction.

**PJ-RCN-3.** The forced-kill specimen MUST delete finalizer output, snapshots, and indexes before replaying the primary journal.

---
## 20. Cross-journal merge

Merge creates a new journal and a transformation receipt. It never edits either source.

### 20.1 Inputs

A merge request names:

- exact source store identities and terminal prefixes;
- declared source precedence sequence;
- duplicate-event policy;
- causal validation procedure;
- conflict policy;
- operator and authority.

### 20.2 /0 ordering rule

The /0 reference rule is explicit source precedence, then source ordinal, subject to explicit causal-predecessor validation. It does not claim true global time.

### 20.3 Duplicates

- identical event identity and canonical payload may be coalesced with a duplicate-equivalence record;
- conflicting payload under one event identity MUST refuse;
- absent identity or ambiguous equivalence MUST refuse.

### 20.4 Causal conflict

If source precedence violates an explicit causal predecessor relation, merge signals `journal-merge-causal-conflict`.

### 20.5 Receipt

The merge receipt records every source prefix, rule, coalesced duplicate, refused conflict, output identity, and result digest. The output journal's origin is derived/reconstructed, never direct observation.

**PJ-MRG-1.** Timestamp-only merge is prohibited.

---
## 21. Redaction, compaction, deletion, and rotation

Process Journal /0 defines no in-place redaction, compaction, deletion, or rotation.

**PJ-LIFE-1.** No operation may rewrite or delete committed primary records while continuing to claim the same journal identity.

**PJ-LIFE-2.** A reduced, redacted, compacted, or rotated representation requires a new identity and a transformation receipt under a later specification or domain policy.

**PJ-LIFE-3.** Retention policy remains outside /0, but absence of a retention policy does not authorize silent deletion.

---
## 22. Reference APIs

Names are normative for the fixture tool and informative for the future runtime unless the adopted implementation charge says otherwise.

```lisp
(create-journal directory metadata)                  → store-id
(validate-journal directory &key semantic)           → prefix-report
(append-event store event &key durability)           → append-receipt
(find-event store event-id)                          → coordinate | absent
(read-prefix-valid store)                            → events + terminal-report
(salvage-valid-prefix source destination authority)  → salvage-receipt
(make-snapshot store fold-id)                        → snapshot
(reconstruct store fold-id)                          → view + reconstruction-receipt
(merge-journals sources rule destination authority)  → merge-receipt | condition
(explain-journal identity)                           → human view + canonical record
```

**PJ-API-1.** The shortest supported append API performs canonicalization, identity reconciliation, locking, framing, durability, and receipt construction. A supported shortcut that bypasses these steps violates L17.

**PJ-API-2.** Raw byte append, if exposed for tooling, MUST be visibly unsafe and outside the conforming consequential API.

---
## 23. Typed conditions

A conforming implementation distinguishes at least:

```text
pj0-metadata-invalid
pj0-store-id-mismatch
pj0-noncanonical-payload
pj0-invalid-utf8
pj0-header-invalid
pj0-ordinal-gap
pj0-payload-length-invalid
pj0-payload-digest-mismatch
pj0-previous-digest-mismatch
pj0-frame-digest-mismatch
pj0-frame-separator-invalid
pj0-torn-tail
pj0-interior-corruption
pj0-event-identity-collision
pj0-duplicate-committed-event
pj0-lock-failure
pj0-durability-barrier-failure
pj0-salvage-receipt-required
pj0-merge-receipt-required
pj0-merge-causal-conflict
unsupported-reconstruction
```

Each condition carries store identity where available, byte offset, expected ordinal, terminal digest, requirement ID, and bounded evidence. Conditions compose with the Common Lisp condition system; signaling remains distinct from choosing a lawful restart.

**PJ-CND-1.** “Ignore digest and continue” is not a lawful standard restart.

**PJ-CND-2.** Lawful restarts may include abandon, inspect, salvage-to-new-store, reconcile-identical-event, or request-authorized-merge.

---
## 24. Fixture registry and custody

`PJ0-FIXTURE-REGISTRY.sexp` is the normative inventory of fixture families. Each concrete fixture file has a SHA-256 entry in `SHA256SUMS.txt` and, where a large family is generated, a family manifest.

The registry records:

- fixture or family identity;
- relative path or path pattern;
- expected terminal classification;
- expected valid frame count;
- expected valid-byte count where fixed;
- expected condition;
- governing requirement IDs;
- mutation or kill procedure;
- source fixture identity.

**PJ-FIX-1.** A fixture suite that contains only green examples is nonconforming.

**PJ-FIX-2.** The authoring packet includes a non-runtime vector tool used to regenerate and verify fixture octets. The tool is not implementation authorization for Mneme.

---
## 25. Positive vector families

The packet includes:

1. one-record synced journal;
2. multi-record synced journal with partial manifestation and uncertain effect;
3. one-record best-effort journal;
4. Unicode and control-escape payloads;
5. every Canonical Datum /0 category expressible in PJ-S/0;
6. observed transition versus asserted self-report;
7. identical event reconciliation transcript;
8. reconstructed append-receipt example;
9. snapshot bound to exact prefix;
10. merge of disjoint source prefixes.

Every positive journal validates under the strict vector tool. The multi-record final frame is the source for exhaustive terminal truncation.

---
## 26. Exhaustive terminal-frame truncation

For the canonical multi-record journal, let `S` be the byte offset of the final frame and `N` its byte length.

The fixture generator emits:

```text
truncate-final-0000.pj0 = bytes[0:S]
truncate-final-0001.pj0 = bytes[0:S+1]
...
truncate-final-(N-1).pj0 = bytes[0:S+N-1]
```

Offset zero is a valid journal ending at the previous frame. Every nonzero proper prefix is a torn tail with the same valid frame count and valid-byte boundary.

A complete untruncated control is stored separately.

**PJ-TRN-1.** The family MUST cover every proper byte offset, not representative offsets.

**PJ-TRN-2.** For every nonzero offset, the exact excluded tail bytes and SHA-256 are reportable.

**PJ-TRN-3.** The valid prefix MUST be byte-identical across the family.

---
## 27. Adversarial vectors

The packet includes, at minimum:

- bad magic;
- bad version;
- leading-zero ordinal;
- ordinal gap;
- leading-zero length;
- uppercase digest;
- payload length shorter/longer than actual;
- payload hash mismatch;
- predecessor hash mismatch with recomputed frame hash;
- frame hash mismatch;
- malformed UTF-8;
- parseable noncanonical record order;
- duplicate record key;
- missing frame LF;
- wrong frame-separator octet;
- extra bytes between frames;
- interior partial frame followed by later plausible header;
- frame spliced from another store;
- duplicate committed event identity with identical payload;
- duplicate committed event identity with conflicting payload.

Each is classified as torn tail or corruption according to §13. A fixture may be physically derived from a positive vector; its derivation does not weaken its standing because the registry names the procedure and exact digest.

---
## 28. Planted negative controls and mutation score

The vector tool contains deliberately defective validator modes:

1. ignore payload hash;
2. ignore predecessor chain;
3. accept parseable noncanonical payload;
4. downgrade interior corruption to torn tail;
5. accept duplicate event identity with last-write-wins;
6. ignore ordinal continuity.

**PJ-MUT-1.** Every planted mutant MUST be killed by at least one frozen fixture.

**PJ-MUT-2.** The authoring transcript records the killing fixture and expected disagreement.

**PJ-MUT-3.** Adding a validation law later requires either a planted mutant or another demonstration that the relevant fixture can fail.

A suite that certifies both the strict validator and the matching defective validator is decorative furniture.

---
## 29. Deterministic crash fixtures

The packet maps the crash-window matrix into deterministic byte artifacts:

- CW-0: valid prefix with no proposed frame bytes;
- CW-1: selected proper prefixes and the exhaustive truncation family;
- CW-2a: no bytes survive;
- CW-2b: torn bytes survive;
- CW-2c: a full unacknowledged frame survives;
- CW-3: full durable frame survives but the caller lacks the receipt.

The same physical full frame can represent different caller knowledge states. The registry therefore distinguishes byte fixture from scenario fixture.

**PJ-CRASH-1.** A full frame at CW-3 is reconciled by event identity, not blindly appended again.

**PJ-CRASH-2.** A CW-2 full frame in a `:synced` store is not retroactively granted a delivered success receipt; its physical presence may be observed and a receipt reconstructed.

---
## 30. Randomized SIGKILL harness

`tools/pj0_kill9_harness.py` is the live complement to deterministic fixtures.

The harness MUST:

1. accept an explicit PRNG seed;
2. select byte offsets and crash windows deterministically from the seed;
3. run at least `N` trials named in the transcript;
4. start from a frozen valid prefix and launch a child writer in a separate process to append the candidate frame;
5. deliver SIGKILL (`kill -9`) at the selected progress point;
6. retain every resulting store directory;
7. validate each store with the strict validator;
8. compare the result to the crash-window admissible set;
9. report environment, filesystem, Python/CL/runtime version, and durability declaration;
10. make no stronger power-loss claim than the host test permits.

**PJ-KILL-1.** Random tests supplement exhaustive byte truncation; they do not replace it.

**PJ-KILL-2.** A failure remains archived with seed, trial number, progress offset, store bytes, and validator report.

---
## 31. Reference transcript

`PJ0-REFERENCE-TRANSCRIPT.md` records:

- metadata creation and store-id derivation;
- frame-by-frame digest chain;
- strict validation of every positive vector;
- exhaustive truncation family count;
- adversarial classification;
- mutation scorecard;
- CW-3 identical-event reconciliation;
- source-preserving salvage demonstration;
- reconstruction with finalizer/snapshot removed;
- host-honesty caveat.

The transcript is evidence of the authoring tool run, not proof that a future runtime implementation conforms.

---
## 32. Conformance classes

### 32.1 PJ-S/0 codec conformance

A codec round-trips all positive datum vectors byte-identically and rejects all noncanonical variants.

### 32.2 Journal reader conformance

A reader agrees on valid prefix, terminal classification, byte offset, ordinal, and digest for every fixture.

### 32.3 Journal writer conformance

A writer produces the frozen positive frames, enforces event-id idempotency, serializes writers, and satisfies the declared durability behavior.

### 32.4 Recovery conformance

A recovery implementation preserves the source, salvages only to a new identity, reconstructs receipts and folds lawfully, and refuses unsupported reconstruction.

### 32.5 Full Process Journal /0 conformance

Full conformance combines codec, reader, writer, recovery, fixture suite, mutation score, and forced-kill evidence.

---
## 33. Cross-language verification

The adopted implementation phase SHOULD produce independently seeded Common Lisp and Python implementations.

They MUST agree on:

- decoded abstract datum;
- canonical PJ-S/0 bytes;
- metadata identity;
- frame digests;
- valid-prefix boundary;
- torn-tail/corruption classification;
- event-id reconciliation;
- merge output;
- reconstruction receipt fields.

One implementation invoking the other is not independent verification.

---
## 34. Security and denial-of-service bounds

A conforming implementation MUST permit configured bounds for:

- maximum header length;
- maximum payload length;
- maximum nesting depth;
- maximum string and byte-string length;
- maximum identifier segments;
- maximum record entries;
- maximum event count per validation operation.

Bound refusal is a resource condition, not evidence that the underlying journal is corrupt. The implementation MUST report the configured bound and coordinate.

PJ-S/0 parsing MUST NOT intern host symbols, execute reader macros, allocate circular structures, or evaluate payload code.

---
## 35. Deliberate stops

Process Journal /0 deliberately stops before:

1. rotated or segmented primary journals;
2. cryptographic signatures or transparency logs;
3. distributed multiwriter consensus;
4. automatic replication;
5. in-place redaction or compaction;
6. privacy retention policy;
7. encrypted payload grammar;
8. provider-specific reconciliation;
9. a standing custody service;
10. a general event query language.

The following are not stops and are fully defined here: PJ-S/0 bytes, frame boundaries, hashes, append idempotency, durability declarations, prefix validation, torn-tail classification, source-preserving salvage, fold-derived resolvedness, unsupported reconstruction, merge receipt requirements, and fixture custody.

---
## 36. Successor sequence

After adoption of Process Journal /0:

```text
Adapter Protocol /0
→ Vertical Specimen /0
→ explicit implementation authorization
→ Common Lisp Kernel + Mneme runtime
→ deterministic fake adapter
→ deterministic and randomized forced-kill runs
→ independent Python journal verifier
→ stranger primitive-minimization audit
```

Process Journal /0 adoption does not authorize live provider calls.

---
## 37. Requirement index

| Prefix | Area |
|---|---|
| PJ-CW | crash windows |
| PJ-JUR | Kernel/Journal jurisdiction |
| PJ-TERM | terminology and terminal handling |
| PJ-FS | filesystem layout |
| PJ-SYN | PJ-S/0 grammar and canonicality |
| PJ-META | immutable metadata |
| PJ-FRM | framing |
| PJ-HASH | integrity digests |
| PJ-APP | append and receipt |
| PJ-DUR | durability and host honesty |
| PJ-LOCK | concurrency |
| PJ-VAL | validation |
| PJ-SAL | salvage |
| PJ-WIT | witness separation |
| PJ-FOLD | fold-derived state |
| PJ-SNP | snapshots |
| PJ-RCN | reconstruction |
| PJ-MRG | merge |
| PJ-LIFE | lifecycle exclusions |
| PJ-API | ergonomic public API |
| PJ-CND | typed conditions |
| PJ-FIX | fixture custody |
| PJ-TRN | exhaustive truncation |
| PJ-MUT | planted mutants |
| PJ-CRASH | deterministic crash scenarios |
| PJ-KILL | randomized SIGKILL harness |

---
## 38. Trace ledger

| Source | Binding carried into this specification |
|---|---|
| Architecture 0.1 | Mneme memory role; append-only transitions; finalizer derivability; witness separation; four-axis consequences remain Kernel-owned |
| Kernel /0 §13 | semantic event fields; journal ordinal; deterministic fold; longest prefix-valid source |
| Kernel /0 §27.1 | exact S-expression grammar, framing, bytes, durability, prefix, torn tail, merge and reconstruction receipts, filesystem layout |
| PJ-D1 | length-prefixed textual frames plus PJ-S/0 |
| PJ-D2 | payload/frame/predecessor hashes |
| PJ-D3 | serialized logical writer |
| PJ-D4 | untouched damaged source; salvage to new identity |
| PJ-D5 | derived artifacts disposable; transformations receipt-bearing |
| Fable blind-plan contribution | crash-window spine; randomized kill-9 harness; no resolved flag; unsupported reconstruction; WSL host honesty |
| Language-A emission night | incremental envelopes survived finalizer and process death; uncertain write forbids blind retry |

---
## 39. Closing law

> **Mneme does not promise that a process will remember. It promises that what crossed a declared boundary can outlive the process without being rewritten into a more convenient story.**

A Process Journal /0 implementation is conforming only when it can be killed between intention, bytes, durability, and receipt—and still say exactly what the surviving evidence licenses.

---

## Annex A — exact strict-reader pseudocode

1. `open immutable metadata; validate canonical PJ-S/0 and derived store identity`.
2. `set offset := 0, expected-ordinal := 1, previous-digest := genesis`.
3. `while offset < event-file-length:`.
4. `  mark frame-start := offset`.
5. `  read through header LF; EOF before LF => torn terminal header`.
6. `  decode ASCII; validate seven canonical fields`.
7. `  require ordinal = expected-ordinal`.
8. `  read exactly payload-length octets`.
9. `  EOF before payload complete => torn terminal payload`.
10. `  require one LF frame separator; EOF => torn tail; other octet => corruption`.
11. `  verify payload digest`.
12. `  verify predecessor digest`.
13. `  recompute and verify frame digest using metadata store identity`.
14. `  decode strict UTF-8`.
15. `  parse PJ-S/0 without host evaluation or symbol interning`.
16. `  re-render and require byte identity`.
17. `  require event identity and reject duplicate committed identity`.
18. `  append abstract event to valid prefix`.
19. `  update offset, ordinal, previous digest`.
20. `return valid end with prefix coordinate and terminal digest`.

The implementation MUST retain the original tail bytes or a byte-identical reference to them in the validation report. A UI may abbreviate display, but evidence export must preserve the exact tail or its externally located identity and digest.

---

## Annex B — crash-window expected-state table

| Mode | Window | Physical variants admitted | Valid-prefix contribution | Caller recovery | Standing |
|---|---|---|---|---|---|
| synced | CW-0 | prior bytes only | none | ordinary retry under Kernel policy | event absent |
| synced | CW-1 | proper terminal prefix | none | inspect; salvage only to new store if desired | torn tail visible |
| synced | CW-2 | absent, torn, or complete | complete only if validator accepts full frame | lookup event identity before retry | bounded physical outcome |
| synced | CW-3 | complete valid frame | event included | return/reconstruct prior coordinate | declared synced under host contract |
| best-effort | CW-0 | prior bytes only | none | ordinary retry under Kernel policy | event absent |
| best-effort | CW-1 | proper terminal prefix | none | inspect; preserve source | torn tail visible |
| best-effort | CW-2 | usually complete after process kill; power-loss persistence unclaimed | event included if bytes validate | lookup event identity | best-effort only |
| best-effort | CW-3 | complete valid frame | event included | return/reconstruct prior coordinate | best-effort only |

---

## Annex C — fixture obligation matrix

| ID | Obligation | Requirement | Evidence |
|---|---|---|---|
| C-01 | canonical unit/booleans | PJ-SYN-2 | positive |
| C-02 | integer and rational minimality | PJ-SYN-2 | positive + negative |
| C-03 | Unicode scalar and control escape | PJ-SYN-2 | positive + negative |
| C-04 | byte-string lowercase hex | PJ-SYN-2 | positive + negative |
| C-05 | record key ordering and uniqueness | PJ-SYN-2 | positive + adversarial |
| C-06 | frame canonical decimal fields | PJ-FRM-2 | adversarial |
| C-07 | payload digest | PJ-HASH-1 | adversarial + mutant |
| C-08 | predecessor chain | PJ-HASH-1 | adversarial + mutant |
| C-09 | cross-store splice | PJ-HASH-1 | adversarial |
| C-10 | all final-frame truncation offsets | PJ-TRN-1 | exhaustive family |
| C-11 | interior corruption not tail | PJ-TERM-1 | adversarial + mutant |
| C-12 | identical event id reconciliation | PJ-APP-2 | transcript |
| C-13 | conflicting event id refusal | PJ-APP-3 | adversarial + mutant |
| C-14 | CW-3 receipt loss | PJ-CW-3 | scenario transcript |
| C-15 | source-preserving salvage | PJ-SAL-1 | transcript |
| C-16 | self-report remains asserted | PJ-WIT-2 | positive semantic fixture |
| C-17 | no resolved flag | PJ-FOLD-1 | registry/schema search |
| C-18 | multiple unresolved occupancy | PJ-FOLD-4 | semantic negative |
| C-19 | snapshot deletion before reconstruct | PJ-RCN-3 | transcript |
| C-20 | timestamp-only merge refused | PJ-MRG-1 | semantic negative |
| C-21 | random kill seed replay | PJ-KILL-1 | harness |
| C-22 | best-effort not promoted | PJ-DUR-1 | receipt fixture |
| C-23 | WSL host honesty | PJ-DUR-3 | environment report |
| C-24 | suite kills planted mutants | PJ-MUT-1 | scorecard |

---

## Annex D — authoring and review stop conditions

1. **STOP:** A fixture expected to be corruption validates under the strict tool.
2. **STOP:** A terminal proper-prefix fixture is classified as corruption rather than torn tail.
3. **STOP:** A planted mutant survives every fixture intended to kill it.
4. **STOP:** A frame digest cannot be reproduced from public fields.
5. **STOP:** A PJ-S/0 payload admits two canonical byte spellings.
6. **STOP:** The source journal is modified during validation or salvage.
7. **STOP:** A success receipt is inferred solely from caller memory.
8. **STOP:** An unresolved effect gains a stored resolved flag.
9. **STOP:** The fold selects among multiple unresolved attempts without a lawful relation.
10. **STOP:** The reference implementation relies on host `READ` for evidence parsing.
11. **STOP:** A `:best-effort` result is described as synced because it survived one test.
12. **STOP:** A journal merge uses timestamps as hidden precedence.
13. **STOP:** A future runtime can append bytes through a shorter supported path that bypasses canonicalization or locking.

---

## Annex E — canonical and adversarial case catalogue

### E-01 — empty event file

- **Expected:** valid end at byte zero; zero committed frames.
- **Governing requirement:** `PJ-VAL-1`.
- **Custody rule:** preserve the source bytes and report the exact coordinate used for the classification.

### E-02 — one complete frame

- **Expected:** one decoded event; terminal digest is frame digest.
- **Governing requirement:** `PJ-FRM-1`.
- **Custody rule:** preserve the source bytes and report the exact coordinate used for the classification.

### E-03 — header cut after first byte

- **Expected:** torn terminal header; zero new events.
- **Governing requirement:** `PJ-TRN-1`.
- **Custody rule:** preserve the source bytes and report the exact coordinate used for the classification.

### E-04 — header cut before LF

- **Expected:** torn terminal header; exact tail preserved.
- **Governing requirement:** `PJ-TRN-2`.
- **Custody rule:** preserve the source bytes and report the exact coordinate used for the classification.

### E-05 — payload cut at first byte

- **Expected:** torn terminal payload.
- **Governing requirement:** `PJ-TRN-1`.
- **Custody rule:** preserve the source bytes and report the exact coordinate used for the classification.

### E-06 — payload cut at final byte

- **Expected:** torn terminal payload.
- **Governing requirement:** `PJ-TRN-1`.
- **Custody rule:** preserve the source bytes and report the exact coordinate used for the classification.

### E-07 — complete payload without separator LF

- **Expected:** torn tail, not corruption.
- **Governing requirement:** `PJ-TERM-1`.
- **Custody rule:** preserve the source bytes and report the exact coordinate used for the classification.

### E-08 — complete payload followed by non-LF

- **Expected:** interior corruption.
- **Governing requirement:** `PJ-TERM-1`.
- **Custody rule:** preserve the source bytes and report the exact coordinate used for the classification.

### E-09 — uppercase payload digest

- **Expected:** digest syntax corruption before hash comparison.
- **Governing requirement:** `PJ-FRM-2`.
- **Custody rule:** preserve the source bytes and report the exact coordinate used for the classification.

### E-10 — ordinal with leading zero

- **Expected:** noncanonical header corruption.
- **Governing requirement:** `PJ-FRM-2`.
- **Custody rule:** preserve the source bytes and report the exact coordinate used for the classification.

### E-11 — length with leading zero

- **Expected:** noncanonical header corruption.
- **Governing requirement:** `PJ-FRM-2`.
- **Custody rule:** preserve the source bytes and report the exact coordinate used for the classification.

### E-12 — ordinal discontinuity

- **Expected:** corruption; no timestamp repair.
- **Governing requirement:** `PJ-VAL-1`.
- **Custody rule:** preserve the source bytes and report the exact coordinate used for the classification.

### E-13 — payload hash lie with coherent frame hash

- **Expected:** corruption at payload digest.
- **Governing requirement:** `PJ-HASH-1`.
- **Custody rule:** preserve the source bytes and report the exact coordinate used for the classification.

### E-14 — predecessor lie with coherent frame hash

- **Expected:** corruption at chain relation.
- **Governing requirement:** `PJ-HASH-1`.
- **Custody rule:** preserve the source bytes and report the exact coordinate used for the classification.

### E-15 — frame hash lie

- **Expected:** corruption at frame digest.
- **Governing requirement:** `PJ-HASH-1`.
- **Custody rule:** preserve the source bytes and report the exact coordinate used for the classification.

### E-16 — frame copied from another store

- **Expected:** corruption under destination store identity.
- **Governing requirement:** `PJ-HASH-1`.
- **Custody rule:** preserve the source bytes and report the exact coordinate used for the classification.

### E-17 — raw newline inside canonical string

- **Expected:** noncanonical/invalid payload.
- **Governing requirement:** `PJ-SYN-2`.
- **Custody rule:** preserve the source bytes and report the exact coordinate used for the classification.

### E-18 — newline represented as u{a}

- **Expected:** canonical string escape.
- **Governing requirement:** `PJ-SYN-2`.
- **Custody rule:** preserve the source bytes and report the exact coordinate used for the classification.

### E-19 — printable scalar escaped

- **Expected:** noncanonical payload.
- **Governing requirement:** `PJ-SYN-2`.
- **Custody rule:** preserve the source bytes and report the exact coordinate used for the classification.

### E-20 — uppercase byte hex

- **Expected:** noncanonical payload.
- **Governing requirement:** `PJ-SYN-2`.
- **Custody rule:** preserve the source bytes and report the exact coordinate used for the classification.

### E-21 — rational not reduced

- **Expected:** noncanonical payload.
- **Governing requirement:** `PJ-SYN-2`.
- **Custody rule:** preserve the source bytes and report the exact coordinate used for the classification.

### E-22 — rational denominator one

- **Expected:** must render as integer.
- **Governing requirement:** `PJ-SYN-2`.
- **Custody rule:** preserve the source bytes and report the exact coordinate used for the classification.

### E-23 — record keys reversed

- **Expected:** parseable but noncanonical; refuse.
- **Governing requirement:** `PJ-SYN-2`.
- **Custody rule:** preserve the source bytes and report the exact coordinate used for the classification.

### E-24 — duplicate record key

- **Expected:** payload invalid.
- **Governing requirement:** `PJ-SYN-2`.
- **Custody rule:** preserve the source bytes and report the exact coordinate used for the classification.

### E-25 — duplicate committed event, same payload

- **Expected:** journal corruption; append protocol should have coalesced.
- **Governing requirement:** `PJ-APP-2`.
- **Custody rule:** preserve the source bytes and report the exact coordinate used for the classification.

### E-26 — duplicate committed event, changed payload

- **Expected:** identity collision and corruption.
- **Governing requirement:** `PJ-APP-3`.
- **Custody rule:** preserve the source bytes and report the exact coordinate used for the classification.

### E-27 — same event append after receipt loss

- **Expected:** return existing coordinate; no new frame.
- **Governing requirement:** `PJ-CW-3`.
- **Custody rule:** preserve the source bytes and report the exact coordinate used for the classification.

### E-28 — best-effort bytes survive

- **Expected:** standing remains best-effort.
- **Governing requirement:** `PJ-DUR-1`.
- **Custody rule:** preserve the source bytes and report the exact coordinate used for the classification.

### E-29 — synced append on WSL

- **Expected:** record tested and inherited host claims separately.
- **Governing requirement:** `PJ-DUR-3`.
- **Custody rule:** preserve the source bytes and report the exact coordinate used for the classification.

### E-30 — writer dies holding lock

- **Expected:** next writer validates before append.
- **Governing requirement:** `PJ-LOCK-1`.
- **Custody rule:** preserve the source bytes and report the exact coordinate used for the classification.

### E-31 — self-report stored with strong digest

- **Expected:** origin remains asserted.
- **Governing requirement:** `PJ-WIT-2`.
- **Custody rule:** preserve the source bytes and report the exact coordinate used for the classification.

### E-32 — kernel-boundary transition stored

- **Expected:** origin may be observed under capture policy.
- **Governing requirement:** `PJ-WIT-3`.
- **Custody rule:** preserve the source bytes and report the exact coordinate used for the classification.

### E-33 — uncertain effect ages one week

- **Expected:** still unresolved absent reconciliation.
- **Governing requirement:** `PJ-FOLD-1`.
- **Custody rule:** preserve the source bytes and report the exact coordinate used for the classification.

### E-34 — later success in same seat

- **Expected:** does not resolve predecessor by itself.
- **Governing requirement:** `PJ-FOLD-1`.
- **Custody rule:** preserve the source bytes and report the exact coordinate used for the classification.

### E-35 — two unresolved attempts no relation

- **Expected:** unsupported-reconstruction.
- **Governing requirement:** `PJ-FOLD-4`.
- **Custody rule:** preserve the source bytes and report the exact coordinate used for the classification.

### E-36 — authorized supersession recorded

- **Expected:** fold derives precedence; both histories remain.
- **Governing requirement:** `PJ-FOLD-5`.
- **Custody rule:** preserve the source bytes and report the exact coordinate used for the classification.

### E-37 — snapshot missing

- **Expected:** primary replay still succeeds.
- **Governing requirement:** `PJ-SNP-2`.
- **Custody rule:** preserve the source bytes and report the exact coordinate used for the classification.

### E-38 — snapshot disagrees

- **Expected:** snapshot loses.
- **Governing requirement:** `PJ-SNP-1`.
- **Custody rule:** preserve the source bytes and report the exact coordinate used for the classification.

### E-39 — salvage torn source

- **Expected:** source unchanged; destination new identity.
- **Governing requirement:** `PJ-SAL-1`.
- **Custody rule:** preserve the source bytes and report the exact coordinate used for the classification.

### E-40 — merge by wall clock only

- **Expected:** refuse.
- **Governing requirement:** `PJ-MRG-1`.
- **Custody rule:** preserve the source bytes and report the exact coordinate used for the classification.

### E-41 — merge identical duplicate

- **Expected:** coalesce with equivalence record.
- **Governing requirement:** `PJ-MRG-1`.
- **Custody rule:** preserve the source bytes and report the exact coordinate used for the classification.

### E-42 — merge conflicting duplicate

- **Expected:** refuse.
- **Governing requirement:** `PJ-MRG-1`.
- **Custody rule:** preserve the source bytes and report the exact coordinate used for the classification.

### E-43 — merge causal predecessor inverted

- **Expected:** refuse causal conflict.
- **Governing requirement:** `PJ-MRG-1`.
- **Custody rule:** preserve the source bytes and report the exact coordinate used for the classification.

### E-44 — delete finalizer and indexes

- **Expected:** reconstruct from primary prefix.
- **Governing requirement:** `PJ-RCN-3`.
- **Custody rule:** preserve the source bytes and report the exact coordinate used for the classification.

### E-45 — verify reconstruction

- **Expected:** validation may rise; origin remains reconstructed.
- **Governing requirement:** `PJ-RCN-1`.
- **Custody rule:** preserve the source bytes and report the exact coordinate used for the classification.

### E-46 — raw append helper shorter than lawful API

- **Expected:** L17 conformance failure.
- **Governing requirement:** `PJ-API-1`.
- **Custody rule:** preserve the source bytes and report the exact coordinate used for the classification.

### E-47 — reader scans past corruption

- **Expected:** conformance failure.
- **Governing requirement:** `PJ-TERM-1`.
- **Custody rule:** preserve the source bytes and report the exact coordinate used for the classification.

### E-48 — reader truncates torn source on open

- **Expected:** conformance failure.
- **Governing requirement:** `PJ-SAL-1`.
- **Custody rule:** preserve the source bytes and report the exact coordinate used for the classification.

### E-49 — resource bound exceeded

- **Expected:** resource condition, not corruption claim.
- **Governing requirement:** `PJ-CND-1`.
- **Custody rule:** preserve the source bytes and report the exact coordinate used for the classification.

### E-50 — planted validator accepts its killing fixture

- **Expected:** mutation suite failure.
- **Governing requirement:** `PJ-MUT-1`.
- **Custody rule:** preserve the source bytes and report the exact coordinate used for the classification.

---

## Annex F — review checklist

- [ ] **F-01** Recompute the metadata store identity from the metadata basis.
- [ ] **F-02** Recompute the genesis digest from the literal domain string.
- [ ] **F-03** Recompute every frame digest independently of the authoring tool.
- [ ] **F-04** Confirm the final-frame truncation manifest contains every proper offset exactly once.
- [ ] **F-05** Confirm offset zero is valid-end and every nonzero proper offset is torn-tail.
- [ ] **F-06** Confirm no adversarial vector is accepted by the strict validator.
- [ ] **F-07** Confirm every planted mutant disagrees with the strict expected result.
- [ ] **F-08** Inspect the PJ-S/0 grammar for a second spelling of any abstract datum.
- [ ] **F-09** Inspect whether identifier ordering really delegates to CD/0 rather than inventing a rival order.
- [ ] **F-10** Check that store identity does not depend on a mutable metadata field.
- [ ] **F-11** Check that a copied frame fails under a different store identity.
- [ ] **F-12** Check that source-preserving salvage regenerates destination frame hashes.
- [ ] **F-13** Check that CW-2 physical variability is not collapsed into a success/failure assertion.
- [ ] **F-14** Check that CW-3 reconciliation is by event identity, not by caller memory.
- [ ] **F-15** Check that no record field named resolved or equivalent becomes sole truth.
- [ ] **F-16** Check that unsupported-reconstruction is reached for multiple unresolved occupancy.
- [ ] **F-17** Check that a self-report remains asserted despite journal integrity.
- [ ] **F-18** Check that merge never uses timestamp as hidden precedence.
- [ ] **F-19** Check that snapshots remain optional and disposable.
- [ ] **F-20** Check that the packet makes no live-provider or physical-power-loss claim.
