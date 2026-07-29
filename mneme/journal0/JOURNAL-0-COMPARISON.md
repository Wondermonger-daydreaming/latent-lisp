# JOURNAL-0-COMPARISON — language-neutral comparison vs the frozen packet

*RESTITUTOR (Claude Fable 5 subagent), 2026-07-29. Every number below is
derived live by `journal0-vectors.lisp` (transcript `RUN-VECTORS.txt`, exit
0, byte-identical on re-run) — none is transcribed from the reference tool,
which was never opened. Comparison targets: `PJ0-FIXTURE-REGISTRY.sexp`
(field-level expectations) and `PJ0-REFERENCE-TRANSCRIPT.md` (published
numbers). Where the frozen artefact and this implementation use different
vocabulary, the divergence is itemized and **adjudicates to spec text**
(Kernel Errata 0.2 §7).*

## 1. Reference-transcript agreement (all matched)

| Quantity | Reference transcript | This implementation (derived) | Agree |
|---|---|---|---|
| synced-demo store id | `pj0-store:12b099a4…d1573c` | recomputed from metadata basis (§6.1) — identical | ✓ |
| synced-demo metadata SHA-256 | `af58ab13…f6184` | identical | ✓ |
| synced-demo event-file SHA-256 | `41cda0a5…8da` | identical | ✓ |
| frames | 7 | 7 | ✓ |
| final frame starts at byte | 6684 | 6684 (derived: valid-byte-count of the 6-frame prefix) | ✓ |
| final frame length | 1235 | 1235 | ✓ |
| exhaustive truncation vectors | 1235 (offset 0 valid-end, all nonzero torn-tail) | 1235; offset 0 `:valid` 6 frames; offsets 1–1234 `:torn-tail` 6 frames; prefix byte-identical across the family | ✓ |
| genesis digest | (in frozen metadata) | SHA-256("PJ0-GENESIS-0") = `703ec8e3…63a6`, computed, equals frozen metadata | ✓ |
| terminal frame digest | (in semantic fixtures) | `d372cf52…e311`, derived; equals the snapshot/receipt fixtures' bound digest | ✓ |

## 2. Per-vector: positives (registry fields: expected-status, expected-valid-frames, sha256)

| id | expected | this implementation | writer rebuild |
|---|---|---|---|
| positive-synced-demo | valid / 7 | `:valid` / 7 / full byte count | byte-exact (EVENTS.pj0 + metadata + sidecar) |
| positive-one-record | valid / 1 | `:valid` / 1 | byte-exact |
| positive-best-effort | valid / 2 | `:valid` / 2 | byte-exact |

## 3. Per-vector: adversarial (gate = expected-status + expected-valid-frames + mapped §23 category)

All sixteen refused with matching status and frame count. The registry
`expected-error` column is the reference tool's vocabulary; the §23 category
column is this gate's adjudication (divergence class D-1 below).

| id | frames | registry expected-error | §23 category (this gate) |
|---|---|---|---|
| adversarial-bad-magic | 0 | header-magic-version | pj0-header-invalid |
| adversarial-bad-version | 0 | header-magic-version | pj0-header-invalid |
| adversarial-leading-zero-ordinal | 0 | noncanonical-ordinal | pj0-header-invalid |
| adversarial-ordinal-gap | 6 | ordinal-gap | pj0-ordinal-gap |
| adversarial-leading-zero-length | 0 | noncanonical-length | pj0-payload-length-invalid |
| adversarial-uppercase-digest | 0 | digest-syntax | pj0-header-invalid |
| adversarial-payload-hash | 6 | payload-hash | pj0-payload-digest-mismatch |
| adversarial-prev-chain | 2 | previous-frame-digest | pj0-previous-digest-mismatch |
| adversarial-frame-hash | 1 | frame-hash | pj0-frame-digest-mismatch |
| adversarial-noncanonical-record-order | 1 | payload-canonicality:noncanonical PJ-S/0 rendering | pj0-noncanonical-payload |
| adversarial-malformed-utf8 | 1 | payload-canonicality:invalid UTF-8: 'utf-8' codec can't decode byte 0xff in position 10: invalid start byte | pj0-invalid-utf8 |
| adversarial-bad-separator | 6 | bad-frame-separator | pj0-frame-separator-invalid |
| adversarial-extra-between | 1 | header-field-count | pj0-header-invalid |
| adversarial-splice-other-store | 0 | frame-hash | pj0-frame-digest-mismatch |
| adversarial-duplicate-identical | 7 | duplicate-event-id | pj0-duplicate-committed-event |
| adversarial-duplicate-conflict | 7 | duplicate-event-id | pj0-duplicate-committed-event |

## 4. Truncation family, semantic vectors, crash windows, mutants

- **Family (1,235 members):** every member sha-verified, exact terminal
  offset (file length = 6684 + offset), offsets exactly 0..1234 each once
  (F-04), offset 0 `:valid-end`, all nonzero `:torn-tail` with exact tail
  evidence (PJ-TRN-2), valid prefix byte-identical across the family
  (PJ-TRN-3). `COMPLETE-CONTROL.pj0` equals the frozen synced-demo bytes.
- **Semantic (6):** all sha-verified, all decode as canonical PJ-S/0 under
  this codec, and each satisfies its requirement's content assertion
  (PJ-WIT-2 origins; PJ-RCN-1 reconstructed origin + disposition; snapshot
  binding to the store id / ordinal 7 / terminal digest this reader derives;
  PJ-MRG-1 timestamp-ordering #f; PJ-FOLD-4 condition shape; PJ-FOLD-1 no
  mutable resolved flag).
- **Crash windows (outside the registry; driven from §29 + Annex B):**
  cw0 `:valid`/6 · cw1-mid-header `:torn-tail`/6 · cw1-mid-payload
  `:torn-tail`/6 · cw2 `:valid`/7 · cw3 `:valid`/7. cw2 ≡ cw3 byte-identical
  (the CW-2c/CW-3 distinction is declared-durability + caller-knowledge
  scenario metadata, never bytes); PREFIX-BEFORE-FINAL + FINAL-FRAME
  concatenate to the full bytes; the crash-window store identity equals the
  synced-demo identity. CW-3 reconciliation transcript executed: re-append
  of the final event returned `:already-committed-identical` at ordinal 7,
  zero new bytes, receipt origin `:reconstructed` (PJ-CRASH-1, PJ-APP-2/4).
- **Mutation score: 6/6 killed**, each by its scorecard-designated fixture,
  with the scorecard's exact expected mutant result reproduced
  (ignore-payload-hash→valid, ignore-prev-chain→valid,
  accept-noncanonical→valid, interior-as-tail→torn-tail,
  duplicate-last-write-wins→valid, ignore-ordinal→valid). The mutant
  implementations are this store's own, written from §28's normative list.

## 5. Itemized divergences (each adjudicated to spec text)

- **D-1 — registry `expected-error` strings (16 vectors, field
  `expected-error`).** Reference-tool vocabulary, including one verbatim
  CPython codec message no CL implementation can emit. Adjudication: §23
  names the normative condition taxonomy; the gate compares the mapped §23
  condition CATEGORY plus expected-status plus expected-valid-frames, never
  string equality. Recorded per vector in RUN-VECTORS.txt.
- **D-2 — record-key ordering (field-level spec ambiguity; inherited,
  verified, kept).** §5.10 says record keys appear "in Canonical Datum /0
  identifier order"; CD/0's only defined record order (§14.3 canonical
  ValueBytes) is length-prefixed and would sort `(id "pj0" "store-id")`
  before `(id "pj0" "cd0-version")` — but every frozen positive vector
  orders keys by plain unsigned lexicographic comparison of segment octets
  ("cd0-version" first). The two orders are irreconcilable; the codec
  implements the corpus order because PJ-SYN-2's byte-identity gate is
  anchored to the §24-normative fixture corpus. Identifier EQUALITY still
  delegates to CD/0. Flagged for a future spec erratum.
  *Contested step exhibited (executed, this life):* the CD/0 canonical
  octets of the two keys are `…3 pj0 1 11 "cd0-version"` vs
  `…3 pj0 1 8 "store-id"` — the varint length octet (11 vs 8) sorts
  `store-id` FIRST under §14.3 unsigned-octet comparison, and CD/0's own
  record constructor confirms it (`record-datum-key-at 0` on the parsed
  frozen metadata returns `(pj0 store-id)`), while the frozen metadata
  BYTES render `cd0-version` first. The conflict is real and forced by the
  corpus, not adopted for convenience.
- **D-3 — nonce floor scope (positive-best-effort, metadata field
  `store-nonce`).** PJ-META-1 demands ≥128 unpredictable bits for
  nonce-issued stores; the frozen best-effort fixture carries a 15-octet
  nonce, and the demo nonces are predictable ASCII. Adjudication: Annex A
  step 1 scopes reader-side metadata validation to canonicality + derived
  identity, so the floor binds store CREATION (enforced in
  `build-metadata-record`), not fixture validation; unpredictability is not
  checkable by any validator.
- **D-4 — identifier rendering convention (codec-level).** PJ-S/0
  `(id s1 … sn)` maps to CD/0 identifier namespace=[s1…s(n-1)],
  path=[sn]. A CD/0 identifier with a multi-segment path has no PJ-S/0
  rendering here and is refused on encode. Evidence: the §8.3 public store
  string joins segments with ":" and the whole frozen corpus round-trips
  byte-identically under this convention.
- **D-5 — K0E-15 kernel-side bounded standing (named exclusion).** The
  torn-tail → bounded-determinacy fixture is discharged on the journal side
  only (tail preserved with evidence; `tail-could-hide-settlement-p`
  reported); the Kernel-fold construction of the bounded outcome from that
  flag is not built, because the projection carries no settlement-payload
  records (named gap in fold.lisp). Errata §8 control 13 is therefore
  PARTIAL; controls 10, 11, 12, 14 are discharged (see RUN-VECTORS.txt).

## 6. §32 conformance statement (exact, per class)

- **§32.1 codec — DEMONSTRATED.** All positive datum vectors (three stores'
  frame payloads, PJ-S0-ALL-TYPES, registry, truncation manifest, six
  semantic fixtures) round-trip byte-identically under this codec;
  noncanonical variants refused (E-17..E-24 selftest checks + the two
  payload-canonicality adversarial vectors).
- **§32.2 reader — DEMONSTRATED.** Agreement on valid prefix, terminal
  classification, byte offset, ordinal, and digest for every fixture:
  3 positive + 16 adversarial + 1,235 truncation members + control + 5
  crash-window byte states.
- **§32.3 writer — DEMONSTRATED, with the PJ-DUR-3 bound and one live
  complement missing.** The writer reproduces all three frozen positive
  stores byte-exactly from decoded abstract events; enforces PJ-APP-1..3
  idempotency (including CW-3 receipt-loss reconciliation); serializes via
  an exclusive lock (held-lock refusal proven). Durability: the `:synced`
  barrier is fsync(2) plus post-append reopen validation — a host-contract
  belief (WSL-free Linux ext4 host recorded in RUN-EXITCODES.txt), never
  physical power-loss proof. The §30 randomized SIGKILL harness was NOT run
  in this lane — it belongs to the restart specimen (de-teste-occiso).
- **§32.4 recovery — DEMONSTRATED.** Source preserved byte-identically
  under salvage (PJ-SAL-1 proof obligation checked at runtime); salvage
  only to a new identity with regenerated frames (PJ-SAL-2, K0E-16);
  reconstruction deletes and attests derived artifacts (PJ-RCN-3), keeps
  origin `:reconstructed`, and refuses reconstruction beyond the validated
  prefix (K0E-11) and unsupported multi-occupancy (PJ-FOLD-4).
- **§32.5 FULL conformance — NOT CLAIMED.** Full conformance additionally
  requires forced-kill evidence (§30). Honest partial: codec + reader +
  recovery + fixture suite + 6/6 mutation score + writer-except-forced-kill.
