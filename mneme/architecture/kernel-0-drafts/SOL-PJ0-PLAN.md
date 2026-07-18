# SOL-PJ0-PLAN

**Provenance:** GPT-5.6 Sol, relayed 2026-07-18 (night) via owner-pasted chat. **Blinding:**
authored while Fable's PJ0 plan sat hash-committed in mirror-excluded staging (commitment
`8d02872f…f92474`, frozen 20:44:12Z, revealed only after this arrived) — the two plans are
mutually blind, provably. **Standing:** Sol's design position + to-do for Process-Journal-/0;
its to-do's "immediate prerequisites" (apply R-SYN repairs, seal, record commit) were already
DONE before this arrived (`a59ca188`, `abe8283e`, green word) — Sol wrote in parallel, not in
lag. Verbatim below; adjudication in `PJ0-PLAN-CONCORDANCE.md`.

---

Process Journal /0 is where Lisp+ stops being a persuasive constitutional theory and acquires a scar-resistant memory organ.

Kernel /0 says what events mean, which transitions are lawful, when a retry is forbidden, and how reconstruction must preserve epistemic origin. Process Journal /0 must decide the uglier questions that semantics politely leaves at the door:

**Which exact bytes are written? What does "append succeeded" mean? What survives a crash? How do we distinguish a torn tail from corruption? How can two implementations prove they read the same history?**

That last distinction is the entire game. If the journal gets it wrong, Mneme becomes a poetic name for a log file that occasionally lies.

# The mission

`LISP-PLUS-PROCESS-JOURNAL-0-SPEC.md` should define one small, deterministic, append-only journal protocol that can support the forced-kill specimen without requiring a database, a provider, a distributed consensus algorithm, or faith in Common Lisp's native reader.

It must make these laws executable:

> A completed event is never known only to a living process.

> A torn final write does not poison the valid prefix.

> Interior corruption is not silently reinterpreted as a torn tail.

> A journal entry does not become observational evidence merely because it was written to a journal.

> An acknowledged append can be reconciled after the writer dies before receiving its receipt.

> Reconstruction creates a new derived claim; it does not impersonate direct observation.

> Merge, salvage, redaction, and compaction never rewrite history invisibly.

The target is deliberately modest: a filesystem-backed reference journal suitable for one machine and multiple serialized clients. Distributed journals, replicas, consensus, transparent compression, and cosmic event-stream federation can wait outside with the other ambitious mammals.

---

# 1. The boundary with Kernel /0

Kernel /0 already owns:

* event kinds and semantic fields;
* legal process transitions;
* attempt, seat, request, effect, capability, and principal identities;
* the deterministic fold;
* restart prohibitions;
* reconstruction semantics;
* typed conditions;
* the distinction between primary and derived evidence.

Process Journal /0 should own:

* the exact journal file and directory layout;
* the canonical textual datum grammar;
* framing;
* canonical journal octets;
* append and commit semantics;
* per-frame integrity;
* prefix validation;
* torn-tail classification;
* corruption classification;
* locking and writer serialization;
* durability modes;
* snapshots;
* salvage;
* journal merge representation;
* reconstruction-receipt encoding;
* reference filesystem behavior.

It must not redefine event meaning. If Kernel /0 says a transition is illegal, the journal cannot domesticate it by storing it cheerfully.

Conversely, Kernel /0 must not secretly decide that records are newline-delimited, because that is Process Journal territory. We caught that little border smuggler already.

---

# 2. The recommended physical form

I recommend a **textually framed, length-prefixed sequence of canonical S-expression records**.

Not bare line-delimited Lisp forms. Bare line framing becomes unpleasant as soon as strings, partial manifestations, diagnostic text, or embedded formatting contain newlines. It also encourages people to use the host Lisp reader directly, which is an excellent way to turn an evidence file into a small executable séance.

Each record should have:

1. a one-line textual frame header;
2. an exact-length canonical UTF-8 S-expression payload;
3. one terminating LF.

Conceptually:

```text
(pj0-frame
  :version 0
  :ordinal 42
  :payload-octets 731
  :payload-sha256 "…"
  :previous-frame-sha256 "…"
  :frame-sha256 "…")
<exactly 731 UTF-8 payload octets>
\n
```

The header itself uses an extremely restricted grammar and must fit on one line. The payload may span lines because the byte length, not newline counting, determines its boundary.

The frame digest can be defined without circularity:

```text
frame-digest =
  SHA-256(
    domain-separator
    || format-version
    || store-identity
    || ordinal
    || payload-length
    || payload-digest
    || previous-frame-digest
  )
```

The first record uses a specified genesis digest.

This gives us:

* human-readable framing;
* exact recovery after partial payload writes;
* per-record integrity;
* ordering integrity through the previous-frame chain;
* easy independent implementation;
* no dependence on host printer quirks;
* no binary-only black box.

The hash chain is not a blockchain, thank every merciful deity. It is merely a tamper-evident ordered sequence.

---

# 3. A safe S-expression datum grammar

The journal must **not** normatively say "call Common Lisp `READ`."

Even with `*read-eval*` disabled, the Common Lisp reader carries package semantics, implementation-dependent numeric syntax, reader macros, symbol interning, case conversion, and enough historical barnacles to sink a modest evidence protocol.

Process Journal /0 should define a data-only grammar—call it informatively `PJ-S/0`, without necessarily turning that into another branded constitution.

It should map bijectively onto the Canonical Datum /0 domain:

* unit;
* booleans;
* arbitrary integers;
* reduced rationals;
* Unicode strings;
* byte strings;
* segmented identifiers;
* ordered sequences;
* identifier-keyed records.

No floats. No host symbols. No circular structure. No arbitrary reader macros. No package-qualified names. No comments inside canonical payloads. No alternate spellings for the same datum.

A schematic rendering might look like:

```lisp
(:record
  ((:id "event" "id")       (:id "attempt" "a-00042"))
   ((:id "event" "ordinal") 42)
   ((:id "event" "kind")    (:id "process" "dispatched"))
   ((:id "event" "payload")
    (:record ...))))
```

The exact syntax can be made less eye-watering, but the important property is:

> One abstract CD/0 datum has exactly one canonical journal rendering, and one canonical rendering decodes to exactly one CD/0 datum.

There may be a prettier diagnostic printer later. The canonical journal printer is not obliged to win a typography award.

---

# 4. Store layout

For the reference filesystem implementation, keep it brutally simple:

```text
<journal-directory>/
    JOURNAL-META.sexp
    EVENTS.pj0
    LOCK
```

`JOURNAL-META.sexp` is immutable after creation and carries:

* journal/store identity;
* Process Journal version;
* canonical-datum version;
* creation procedure identity;
* declared durability mode;
* genesis digest;
* optional descriptive location claim;
* integrity digest.

Anything that later changes belongs in the event stream, not in mutable metadata.

`EVENTS.pj0` is append-only.

`LOCK` is ephemeral coordination machinery, not evidence. It may disappear after a crash without implying anything about the journal's state.

Indexes, caches, fold snapshots, and human reports may exist, but they are disposable derived artifacts. Deleting them must never delete truth.

---

# 5. Append semantics

The append operation needs stronger semantics than "write some bytes and hope the operating system felt inspired."

Each proposed event already has a durable event identity. Append must therefore be idempotent by event identity:

### New event identity

The store appends the canonical frame and returns a journal receipt.

### Existing identity with byte-identical payload

The store does not append a duplicate. It returns the prior coordinate and a disposition such as:

```lisp
:already-committed-identical
```

### Existing identity with different payload

The store refuses with:

```lisp
condition:event-identity-collision
```

No "last write wins." No thoughtful merge. No quiet replacement.

The journal receipt should carry at minimum:

```lisp
(:journal-append-receipt
  :store-id ...
  :event-id ...
  :ordinal ...
  :payload-digest ...
  :frame-digest ...
  :previous-frame-digest ...
  :durability :synced
  :append-disposition :newly-committed)
```

This solves the classic death seam:

1. process writes event;
2. store syncs event;
3. process dies before receiving receipt.

After restart, the process asks whether the event identity exists. It discovers the identical committed event and does not duplicate it.

That is local-write reconciliation, the journal-sized sibling of call 296.

---

# 6. Durability modes

Retain the two adopted declarations:

```text
:synced
:best-effort
```

But define them sharply.

## `:synced`

The append operation returns success only after:

* the full frame is written;
* the event file is synchronized according to the reference host contract;
* when creating the store or a new file, the containing directory entry is also synchronized;
* the reader can reopen and validate the committed frame.

The spec must remain honest about the host boundary. `fsync` is not a metaphysical guarantee against malicious firmware, stolen disks, meteorites, or a storage controller having a spiritual crisis. It is the strongest declared local persistence contract available through the reference implementation.

## `:best-effort`

Success means the complete frame was accepted by the host write path, but no power-loss durability is claimed.

The receipt must say `:best-effort`; it must never be promoted later because the file happens to still exist.

The declared durability belongs both in immutable store metadata and in every append receipt.

A single journal should not switch durability mode halfway through /0. If that ever becomes useful, create a successor journal and record the transformation.

---

# 7. Prefix validity and torn tails

The reader walks frames in ordinal order and validates:

1. header grammar;
2. expected ordinal;
3. store identity;
4. payload length;
5. payload UTF-8 validity;
6. canonical S-expression grammar;
7. payload digest;
8. previous-frame digest;
9. frame digest;
10. event-level required fields.

Three outcomes must remain distinct.

## Valid end

Every frame is complete and valid through EOF.

## Torn tail

EOF occurs while reading only the final frame:

* partial header;
* incomplete payload;
* missing final LF;
* otherwise incomplete terminal frame.

The reader returns:

```lisp
(:prefix-valid records
 :terminal-status :torn-tail
 :tail-evidence ...)
```

The valid prefix remains usable. The torn bytes remain visible as evidence.

## Interior corruption

A complete or apparently complete frame fails validation before the terminal incomplete region:

* bad digest;
* wrong ordinal;
* broken previous-frame chain;
* malformed canonical datum;
* duplicate event identity with conflicting content;
* impossible store identity;
* extra bytes between valid frames.

That is not a torn tail. It is corruption.

The reader must stop and report the exact coordinate. It must not scan forward looking for a plausible next header like a cheerful archaeologist rebuilding an empire from three bricks and a hunch.

---

# 8. No automatic truncation

This deserves a law of its own:

> The reference reader MUST NOT truncate, overwrite, or "repair" the journal while opening it.

Even when the final frame is obviously torn, automatic truncation destroys evidence about the crash.

Recovery is an explicit transformation:

```lisp
(salvage-valid-prefix damaged-journal destination-journal)
```

It creates a **new journal** containing the verified prefix and a salvage receipt carrying:

* source journal identity;
* source terminal digest;
* valid terminal ordinal;
* torn-tail digest and byte count;
* salvage procedure identity/version;
* destination identity;
* operator/authority;
* bounded unknowns.

The damaged source remains untouched.

This may feel fussy until the first time the tail contains half of a provider request identifier or the first bytes of a record proving that an external effect may have crossed. Then the fuss suddenly develops excellent posture.

---

# 9. Witness separation inside the journal

Process Journal /0 must operationalize L15 carefully.

The journal is a storage and capture mechanism. It does not automatically upgrade every payload to `:observed`.

These are different:

```lisp
(:event
  :kind :process-transition
  :capture
    (:mechanism :kernel-transition-boundary
     :origin :observed))
```

and:

```lisp
(:event
  :kind :process-narrative
  :capture
    (:mechanism :process-self-report
     :origin :asserted))
```

Both may be stored with perfect byte integrity. Only the first is observational evidence of the transition itself.

The event envelope should therefore carry or reference:

* recorder principal;
* subject principal;
* capture mechanism identity;
* capture boundary;
* claimed epistemic origin;
* authority;
* evidence references.

The journal preserves origin; it does not manufacture it.

A self-written narrative remains asserted even if stored in a file named `ABSOLUTELY-TRUE-JOURNAL.sexp`.

---

# 10. Concurrency model

For Process Journal /0, choose **serialized append**.

Multiple clients may request appends, but the store admits one append at a time and assigns the next ordinal under an exclusive lock.

Do not attempt lock-free multiwriter file appends in /0. Do not use wall-clock timestamps to order concurrent events. Do not infer causality from nanoseconds.

The authoritative order is journal ordinal.

Events may separately carry:

* causal predecessor identities;
* process-local sequence positions;
* provider timestamps;
* asserted wall-clock times.

Those are data, not the physical append order.

The lock is held only across:

1. validation of event identity/idempotency;
2. ordinal assignment;
3. frame construction;
4. append;
5. required synchronization;
6. append receipt construction.

If the writer dies while holding the lock, normal host lock release occurs. The next opener validates the journal rather than assuming the previous append failed.

---

# 11. Snapshots and folds

A fold snapshot is a performance artifact, not primary history.

A snapshot must reference an exact source prefix:

```lisp
(:journal-prefix
  :store-id ...
  :terminal-ordinal 295
  :terminal-frame-digest ...)
```

and an exact fold identity/version.

A valid snapshot can accelerate:

```lisp
(fold-state journal process-id)
```

but the result must be reproducible from the primary prefix alone.

If the snapshot disagrees with replay, the snapshot loses. It does not get an electoral college.

The forced-kill specimen should explicitly delete all fold snapshots and finalizer outputs before reconstruction. If the result cannot be recreated, Mneme has failed its own audition.

---

# 12. Merge semantics

Merging journals is not concatenating files and hoping the timestamps sort themselves out.

A merge must create a new journal. It must never modify either source.

The merge invocation supplies:

* source journal identities;
* exact source prefixes;
* ordering rule identity;
* duplicate-event policy;
* conflict policy;
* operator and authority.

For /0, I recommend one conservative ordering rule:

> Explicit source precedence, then source ordinal, with causal-order validation.

Example:

```lisp
:source-order (journal-a journal-b journal-c)
```

This is not claimed to reconstruct "true global time." It produces a declared deterministic combined view.

Identical duplicate event IDs may be coalesced with a duplicate-equivalence record. Conflicting duplicate IDs must refuse.

If the declared order violates an explicit causal predecessor relation, merge refuses.

Every merge produces a transformation receipt. The merged journal's origin is reconstructed/derived, never direct.

---

# 13. Compaction, rotation, deletion, and redaction

Defer all four from Process Journal /0 except for one constitutional statement:

> No operation may rewrite or delete committed primary records while continuing to claim the same journal identity.

Later versions may define:

* rotation into segments;
* content-addressed archival packs;
* cryptographic erasure;
* privacy redaction;
* compaction;
* retention policies.

For /0, if a smaller or redacted representation is needed, create a new derived journal and a transformation receipt. Preserve the source according to the governing retention policy.

This is a prototype spec, not a universal records-management treaty.

---

# 14. The fixture package

The specification should ship with a serious fixture package. This is where the work becomes falsifiable.

I would organize it as:

```text
process-journal-0/
    LISP-PLUS-PROCESS-JOURNAL-0-SPEC.md
    PJ0-FIXTURE-REGISTRY.sexp
    fixtures/
        positive/
        torn-tail/
        corruption/
        idempotency/
        durability/
        merge/
        witness-standing/
        reconstruction/
    transcripts/
        PJ0-REFERENCE-TRANSCRIPT.md
    SHA256SUMS.txt
```

The minimum fixture families:

### Canonical rendering

* every CD/0 type;
* Unicode boundary cases;
* large integers;
* reduced rationals;
* byte strings containing every octet;
* records with lexically adjacent identifiers;
* rejection of alternate noncanonical spellings.

### Framing

* zero-length legal payload only if the payload grammar permits it;
* one-byte payload;
* large multiline payload;
* exact EOF after frame;
* extra byte after frame;
* malformed header length;
* leading zero length encodings;
* digest mismatch;
* previous-digest mismatch.

### Torn tail

Take one valid multi-record journal and truncate it at **every byte offset of the final frame**.

Each truncation must return the identical valid prefix plus a distinct tail report.

This single mutation family will kill a remarkable number of "looks fine on my laptop" parsers.

### Interior corruption

Flip every semantically significant byte class in an interior frame:

* header token;
* length;
* ordinal;
* payload;
* digest;
* previous-frame link;
* UTF-8 sequence;
* canonical datum delimiter.

Every mutation must refuse as corruption, never downgrade itself to torn tail.

### Idempotency

* append new event;
* append same identity and same bytes;
* append same identity and canonically equivalent datum;
* append same identity and different datum;
* crash after sync but before receipt;
* restart and reconcile.

### Durability

For both modes:

* process death before write;
* death during header;
* death during payload;
* death after complete write before sync;
* death after sync before return;
* normal return.

The expected standing must be explicit for every point.

### Concurrency

* two clients append distinct events;
* two clients append same identical event;
* two clients append conflicting same identity;
* lock holder dies;
* next writer validates and continues;
* no duplicate ordinals.

### Witness standing

* kernel-captured transition remains observed;
* process self-report remains asserted;
* saving self-report into journal does not raise origin;
* externally witnessed provider receipt carries its own origin;
* later validation raises validation facet without rewriting origin.

### Reconstruction

* delete finalizer;
* delete indexes;
* delete snapshots;
* reconstruct from primary records;
* byte-compare deterministic summary;
* preserve `:reconstructed` origin;
* fail when required primary evidence is missing.

### Merge

* disjoint sources;
* identical duplicate event;
* conflicting duplicate event;
* explicit causal-order violation;
* source with torn tail;
* source with interior corruption;
* deterministic replay of merge receipt.

---

# 15. Two independent implementations

Process Journal /0 should eventually be tested by independently seeded implementations, ideally:

* Common Lisp reference implementation;
* Python verification implementation.

Not because Python is morally purer—it has committed plenty of crimes—but because a second parser that does not share the first parser's reader, printer, integer handling, file APIs, or assumptions is exactly what canonical protocols need.

Both implementations must agree on:

* parsed abstract records;
* valid-prefix boundary;
* tail classification;
* corruption location;
* frame digests;
* append reconciliation;
* merge output;
* reconstruction receipts.

Do not make one implementation call the other. That is two executables wearing one brain.

This dual implementation can happen when implementation is authorized. The specification phase should prepare the vectors now.

---

# 16. The five real design forks

I would not turn these into another fourteen-act constitutional opera. One compact owner decision note is enough.

## PJ-D1 — Framing

**Recommendation:** textual header plus exact-length canonical S-expression payload.

Reject bare newline framing and binary-only framing.

## PJ-D2 — Integrity

**Recommendation:** mandatory payload digest, frame digest, and previous-frame digest chain.

The chain provides ordering integrity without pretending to provide independent notarization.

## PJ-D3 — Writers

**Recommendation:** one serialized logical writer per journal; multiple clients through the store protocol.

Distributed multiwriter ordering is out of scope.

## PJ-D4 — Repair

**Recommendation:** never modify the damaged source; salvage valid prefix into a new journal with a receipt.

## PJ-D5 — Derived storage

**Recommendation:** snapshots and indexes are disposable; merge, redaction, and compaction create new identities and receipts.

These are protocol choices, not deep worldview decisions. They can be adopted with the Process Journal spec unless you object to one before drafting begins.

---

# 17. Deliverables

The complete Process Journal /0 packet should contain:

1. `LISP-PLUS-PROCESS-JOURNAL-0-SPEC.md`
2. `PJ0-FIXTURE-REGISTRY.sexp`
3. canonical positive vectors;
4. adversarial and truncated vectors;
5. `PJ0-REFERENCE-TRANSCRIPT.md`
6. `PROCESS-JOURNAL-0-AUTHORING-RECEIPT.md`
7. `SHA256SUMS.txt`
8. outer ZIP and checksum sidecar;
9. relay to Fable for bounded review;
10. adoption record after review.

The specification itself should probably be around 1,200–1,800 lines. Long enough to define bytes and failure semantics; not another sacred encyclopedia of every storage system humanity might someday regret inventing.

---

# The actionable to-do list

## Immediate prerequisite

* [ ] Apply the three Kernel /0 synthesis repairs:

  * call-296 projection status;
  * journal readability/framing seam;
  * dependency-respecting preflight order.
* [ ] Re-run the Kernel /0 conformance trace.
* [ ] Owner adopts the repaired `LISP-PLUS-KERNEL-0-SPEC.md`.
* [ ] Record the governing commit and exact SHA-256.

## Process Journal authoring

* [ ] Freeze PJ-D1 through PJ-D5, preferably in one short scope note.
* [ ] Inventory every Kernel /0 clause delegated to Process Journal /0.
* [ ] Define the canonical journal datum grammar over CD/0.
* [ ] Define the frame header grammar.
* [ ] Define canonical payload octets and UTF-8 rules.
* [ ] Define payload, frame, and previous-frame digest procedures.
* [ ] Define the genesis frame.
* [ ] Define immutable journal metadata.
* [ ] Define append idempotency by event identity.
* [ ] Define append receipts.
* [ ] Define `:synced` and `:best-effort`.
* [ ] Define file synchronization obligations.
* [ ] Define lock and serialized-writer behavior.
* [ ] Define prefix validation.
* [ ] Define torn-tail classification.
* [ ] Define interior-corruption classification.
* [ ] Prohibit automatic truncation and skip-forward recovery.
* [ ] Define explicit prefix salvage into a new journal.
* [ ] Define snapshot identity and disposable-index rules.
* [ ] Define merge inputs, deterministic order, duplicate policy, and receipts.
* [ ] Define witness-separation fields and origin preservation.
* [ ] Define journal-level typed conditions.
* [ ] Define deliberate stops: rotation, compaction, redaction, distributed writers.

## Fixtures

* [ ] Create a canonical one-record journal.
* [ ] Create a canonical multi-record process transcript.
* [ ] Generate truncation fixtures at every byte of the terminal frame.
* [ ] Generate interior corruption mutations.
* [ ] Generate hash-chain mutations.
* [ ] Generate event-ID collision cases.
* [ ] Generate crash-after-sync-before-receipt reconciliation case.
* [ ] Generate lock-holder death case.
* [ ] Generate self-report-versus-witness cases.
* [ ] Generate reconstruction-without-finalizer case.
* [ ] Generate merge and causal-order-conflict cases.
* [ ] Plant negative controls proving every family can fail.
* [ ] Freeze fixture identities and produce a registry.

## Review and adoption

* [ ] Run a canon trace against Architecture 0.1 and Kernel /0.
* [ ] Have Fable review semantic fidelity and scar coverage.
* [ ] Have a separate implementation-minded reviewer attack framing and crash consistency.
* [ ] Resolve only true defects; do not reopen settled kernel semantics.
* [ ] Adopt Process Journal /0 with a parentage/amendment ledger.
* [ ] Publish the adopted packet and checksums.

## Next critical path

* [ ] Write `LISP-PLUS-ADAPTER-PROTOCOL-0-SPEC.md`.
* [ ] Write the Vertical Specimen /0 charge.
* [ ] Authorize Codex to implement:

  * Kernel /0;
  * Process Journal /0;
  * deterministic fake adapter;
  * forced-kill specimen.
* [ ] Run independent Common Lisp and Python journal verification.
* [ ] Kill the specimen at preselected byte and transition boundaries.
* [ ] Reconstruct from disk with finalizers removed.
* [ ] Prove duplicate effects are refused or reconciled.
* [ ] Only then recruit the stranger primitive-minimization auditor.

The central pitch is this:

> **Process Journal /0 is not "logging for Lisp+." It is the protocol by which a latent process can die, restart, disagree with its own memory, and still leave the world with a more reliable account than the process itself can provide.**

That is Mneme's first real body. Everything before it has been anatomy on parchment; this is where the goddess receives a spine.
