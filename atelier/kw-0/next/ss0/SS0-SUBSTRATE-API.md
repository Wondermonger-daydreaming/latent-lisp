# SS-0 Shared Substrate API

*FROZEN 2026-07-19 (owner-approved). Substrate built, cross-language selftested (11/11), VOID-2 audited + teeth-checked; hashes in SS0-FREEZE-LEDGER.md.*

## 1. Storage (per run-directory, both languages)

- `store-append(run-dir, payload-bytes, durable?)` → appends one framed record: length-prefix + payload + CRC. If `durable?`, returns only after `fsync`. Torn/partial trailing frames are possible under `SIGKILL` and are the reader's normal case.
- `store-read-prefix(run-dir)` → `(records[], tail-status)` where `tail-status ∈ {clean, torn}`. Returns every intact record in order; a torn or checksum-failing tail is discarded and reported. **No interpretation of payloads.**

## 2. Serialization (both languages, cross-verified)

- `ser-encode(flat-map)` / `ser-decode(bytes)` — deterministic canonical encoding of string-keyed flat maps (string/int/bool values). Byte-stable across both languages: identical map → identical bytes.

## 3. Provider fixture (deterministic; owns its own world, not your records)

`provider-dispatch(run-dir, tag, attempt-id)` with tags: `effect:<label>` (executes irreversibly; appends its own `provider.log`; writes `receipt-<attempt>.txt`, settlement `executed`); `effect-ne:<label>` (durably records received-but-NOT-executed; receipt says so); `complete:<text>` / `empty` / `invalid` (payload regimes); `slow:<n>` (chunked stream). Deterministic function of (tag, attempt-id, seed). The provider does not deduplicate.

## 4. Death harness

Runner contract: `<entry> <run-dir> <scenario> [killpoint]`. The runner touches `READY-<killpoint>` and waits; the harness delivers real `SIGKILL` (exit `-9`), snapshots surviving bytes, records exit status and provider log. Scenario corpus (fixed): clean control; kill before first operation record; kill mid-record (torn write, injection helper provided); kill after dispatch before outcome recorded; kill after outcome written un-fsynced, before any completion record; kill mid-stream inside a chunk; provider-refused variant killed before its outcome recorded. Plus recovery-mode invocations defined per the brief's obligations. Exact scenario list ships frozen with the substrate.

## 5. Measurement tool

The AFEL counter (non-blank, non-comment, outside audited death-instrumentation markers), identical binary for all parties.

## 6. The substrate's negative space (binding)

The substrate provides **no semantic vocabulary and no recovery logic**: no notion of per-proposition determinacy, presence/payload classes, unresolved-effect occupancy, retry refusal, reconciliation standing, supersession lineage, reconstruction-origin marking, or claim/receipt semantics. If any of these appears in the substrate under any name, the affected runs are VOID (protocol VOID-2), verified by lexical audit **and** a planted-concept teeth-check before seeding.
