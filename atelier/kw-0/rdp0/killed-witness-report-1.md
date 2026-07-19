# THE KILLED WITNESS — First Implementation Report

**Specimen:** KW-0 · **Date:** 2026-07-20 · **Builder:** Kimi-k3 (supplementary lens) · **Contract:** RDP-0 §5 (falsification contract v2, five owner patches incorporated) · **Companion:** `ASSUMPTIONS.md` (filesystem/sync/control-channel disclosures — read it before the verdicts)

Commission terms honored: real process death, not simulated exceptions; raw journal bytes retained for every death; recovery claims limited to what surviving bytes warrant; CL-produced journal folded independently by Python; retry and supersession tested as distinct operations; conventional baseline run against the same failures; failures reported without repairing the contract around them. The death harness was built first; the happy path (S1) was run *after* the first corpse (S3).

---

## 1. Code inventory (the whole specimen, with hashes)

| File | Lines | MD5 |
|---|---|---|
| `kw-common.lisp` (frames, CD0 payloads, validator, fold, classifier) | 307 | `3a329e144af78e04a3fe5da603475125` |
| `kw-oracle.lisp` (deterministic fake provider + its external world) | 49 | `5b57cef9b9a83aff4eaa714405ce1f89` |
| `kw-runner.lisp` (the process that dies) | ~90 | `dd25628752c17e7ddec016abf1193d72` |
| `kw-reconstruct.lisp` (cold fold, refusal, F3a/F3b, census) | 163 | `abd772cb31f3970a5b416980cc3b7772` |
| `kw-baseline.lisp` (conventional control group) | 80 | `03e406b5d5b22be1e3fa944db3ecc63d` |
| `folder.py` (independent Python fold; zero shared code) | 144 | `7bbec0b3cd3532ad3b6d13b6ed37bbd5` |
| `harness.py` (the executioner) | 138 | `a5f466a2d1e83abf048e537e8c15c1e4` |

Substrate: the project's own CD0 codecs (CL + Python) carry every event payload. Frame format `KWJ0`: `magic(4) ‖ len-u32be(4) ‖ payload ‖ md5(payload)(16) ‖ prev-digest(16) ‖ frame-digest(16)`, fsync before durability is claimed. MD5 is pedagogical, disclosed (ASSUMPTIONS.md).

## 2. The deaths (six scenarios, raw)

Each death is a real `SIGKILL` to a real SBCL process (`exit=-9`), delivered at a `READY-<killpoint>` window. Journal MD5s below are from the final generation; an earlier independent generation produced **byte-identical hashes for all six** — the specimen is deterministic down to the corpse.

| Death | Window (ground truth) | Exit | Journal MD5 | Provider world |
|---|---|---|---|---|
| S1-clean | none (lawful control) | 0 | `8ad833d8…` | 1 execution |
| S2-cw0 | after seat-reserved fsync, before attempt-begun | -9 | `442d9ee2…` | 0 executions |
| S3-cw1 | mid-frame inside attempt-begun | -9 | `36173af2…` | 0 |
| S4-uncertain | after frontier-crossed fsync + provider dispatch, before any settlement frame | -9 | `ef02d3df…` | **1 execution, unrecorded** |
| S5-cw2cw3 | settlement frame flushed, **no fsync, no receipt frame** | -9 | `4d189815…` | 1 |
| S6-midstream | inside manifestation chunk-2 frame | -9 | `db858970…` | — |

S3's torn tail, raw: `320 bytes; last 48: 685f70c2a3e2b1a9ff385646d9d9e11eaa163ece144b919f4b574a30000000824c5043440031042201026b7701037061` — a partial frame (magic + length prefix, 24 of ~200 bytes) dangling off a valid 2-frame prefix.

## 3. What the cold process saw (classification, F1)

The reconstructor knows nothing but the bytes. Results:

- **S2:** `no append` — 2 valid frames, zero attempt frames. Correct.
- **S3:** `torn tail` — 2 valid frames, partial refused, prefix intact. Correct.
- **S4:** `effect settlement unresolved` — 4 valid frames; `frontier-crossed` present, no settlement, no finalizer. The provider *had* executed (its log says so); the journal cannot know that. The fold derives uncertainty from the **event pattern**, not from any asserted frame. Correct — and it is the whole point.
- **S5:** `complete frame present; durable-receipt standing absent` — 5 valid frames, settlement present, zero completion receipts. Ground truth was pre-fsync death (CW-2); a post-fsync pre-receipt death (CW-3) would leave **identical bytes**. The classifier reported the observable state and did not guess the barrier. The F1 repair, executed: where causes are indistinguishable, the ambiguity *was* the answer.
- **S6:** `torn tail` — chunk-1 manifestation preserved, chunk-2's partial frame refused; 5 valid frames; a1 also correctly uncertain (stream attempt never finalized). Partial manifestation nowhere inflated into settlement.

## 4. Cross-language differential (F2)

Independent Python fold (hashlib/struct — no shared code) over the CL-written corpses, compared by canonical state digest (fixed key order, set-sorted lists, md5):

```
S1-clean      MATCH 57B202D66DB55314B888F28D2179C851
S2-cw0        MATCH 4B3753F2FEE3B2A8029E29C656D2C8AA
S3-cw1        MATCH 4B3753F2FEE3B2A8029E29C656D2C8AA
S4-uncertain  MATCH 26C56A2754BAAD4344F9C86F9B8D05EB
S5-cw2cw3     MATCH 95524BB2E645AB49C3F79C48A25339AA
S6-midstream  MATCH 2DEFCA348D6910B39E69842588B4963F
S4-resolve    MATCH 57B202D66DB55314B888F28D2179C851   (post-resolution)
S4-supersede  MATCH 30A03F3EC87C8230FDF586651CDE3CA3   (post-supersession)
```

**8/8 byte-identical derived states across two implementations.** Two secondary findings worth more than the matches: (a) S2 and S3 digest identically — a death before the attempt and a death torn inside it are the same *derived state* distinguished by *prefix status*, which is exactly the state/cause separation; (b) **S4-resolve's post-resolution digest equals S1-clean's** — lawful resolution converges to the clean run's derived state while the journal retains the entire death-and-evidence history. Path-insensitive state, path-preserving record. (One testing-hygiene defect of mine, disclosed: the first summary loop compared *stale* digest files copied with the corpses — a validator-wearing-the-generator's-clothes error, caught and re-run against live files. The irony is noted for the record.)

## 5. Retry and supersession as distinct operations (F3a/F3b, Patch 4)

On the S4 corpse:

**Blind retry — refused:**
```
REFUSAL unsafe-retry: seat-alpha is occupied by uncertain effect(s) a1.
Evidence: journal prefix (4 valid frames) shows frontier-crossed without
settlement or finalizer.
```

**F3a — resolved retry:** the reconstructor fetched the provider's receipt (`receipt-a1.txt`), appended it as a **new provenance-bearing frame** (`evidence-digest: E83041C7…`), and only then completed a1. Retry became lawful *through evidence*, not through confidence.

**F3b — authorized successor:** supersession recorded with `authorization: owner-directive-001`, fresh attempt identity `a2`, fresh exposure `x2`, precedence rule on record. The verdict line that matters:
```
predecessor-still-unresolved: T
```
a1's settlement is *never asserted by any frame* — supersession authorized proceeding despite the uncertainty; it did not launder the first attempt into safety. Retry (F3a) and supersession (F3b) produced different journals, different derived states, and different lawful futures, as the patch requires.

**The origin ratchet (L10):** the S4 census reports `census-origin: reconstructed`; after a verification re-fold (digest match), the post-verification census still reports `reconstructed`. Verification strengthened the check; it did not move the origin.

## 6. The baseline, against the same deaths (F5)

The control group (JSON-lines, in-memory state, ordinary care) was killed at the same windows:

- **Lie 2 + Lie 3 (B1, uncertain kill):** provider log before recovery: **1 execution**. Baseline recovery printed `state: OK (verified)` — laundering — then, finding no completion record, retried. Provider log after recovery: **2 executions of the same intent**. A double-spend, committed the ordinary way, in six lines of recovery code.
- **Lie 4 (B2, buffered kill):** provider log: 1 execution. Baseline log after death: **file does not exist**. Finalizer-only persistence lost the attempt's entire existence — the worst lie, and the default behavior of the fast path.
- **Lie 1 (B3):** empty payload records as `payload=` — and baseline recovery treats empty-result and no-result as the same null. The collapse the manifestation statuses exist to prevent, committed silently.

The Lisp+ column, same windows: every one of the four lies is *unrepresentable or refused* (absence is a classification, retry is a fold-gated refusal, reconstruction is origin-tagged, and frames are durable before the process can die "cleanly").

## 7. Failed assertions and threshold breaches — reported without repair

1. **F6 (semantic burden) — RAW THRESHOLD BREACHED.** Pre-registered: author scenario code ≤ 1.5× baseline. Measured raw: KW runner body **76 lines** vs baseline body **45 lines** = **1.69× — FAIL.** Excluding death-harness scaffolding (killpoint branches, ~30 lines), the ratio falls to ~1.0–1.5× depending on what counts as scaffolding — which exposes the real defect: **the metric was under-specified**. The specimen reports the raw number as a failure, declines to renegotiate the threshold post hoc, and records that F6's next pre-registration must define "application-facing" mechanically (e.g., AST-node count of calls the author must make, excluding harness instrumentation by directory). Manual bookkeeping calls: KW ~6 (append-event per event) vs baseline ~5 — parity. New effect type cost: 1 event type + 1 fold clause (~12 lines), inside the ≤30 budget.
2. **S6's uncertain-a1 is dual-classified** (`torn tail` wins the headline; `uncertain-effects: (a1)` is also true). The classifier reports both fields, so no information is lost — but the headline taxonomy is single-label, and a real store will want the composite label. Noted as a classifier ergonomics defect, not a thesis failure.
3. **No thesis-level falsification occurred.** F1–F5 all confirmed; F6 failed on measurement design, not on the architecture. Per the contract, F1–F5 passing *increases confidence*; it does not confirm the thesis — the specimen is one seat, one process, one provider, on overlayfs, with SIGKILL standing in for death but not for power loss.

## 8. Verdict against the contract

| Clause | Result |
|---|---|
| F1 recovery-state classification, no causal counterfeiting | **PASS** — incl. honest CW-2/CW-3 ambiguity |
| F2 fold determinism as differential conformance | **PASS** — 8/8 cross-language digest matches |
| F3a resolved retry via provenance-bearing evidence only | **PASS** |
| F3b supersession preserves predecessor uncertainty | **PASS** — `predecessor-still-unresolved: T` |
| F4 recovery needs no unrecorded memory; external testimony only as appended evidence | **PASS** — F3a receipt is a frame, not a whisper |
| F5 baseline must prevent, preserve, reproduce, audit, extend | **PASS** — baseline fails all five; Lisp+ column holds all five *in this scenario* |
| F6 semantic burden ≤1.5× raw | **FAIL (1.69×)** — metric under-specified; raw failure stands |
| L10 origin ratchet | **PASS** — census stays `:reconstructed` after verification |
| Employment-trial: distinctions exercised by death | seat≠attempt ✓ (S4) · uncertain-effect refusal ✓ (S4) · torn-tail ✓ (S3,S6) · receipt-vs-frame ✓ (S5) · supersession vs retry ✓ (S4) · origin ratchet ✓ · deterministic fold ✓ (all) |

## 9. What this does not show (scope honesty)

One seat, one process, one provider; SIGKILL, not power loss; MD5, not collision-resistant crypto; a two-frame-prefix world, not a gigabyte journal; a codec shared by both folds (the CD0 vector suites, not this specimen, cover that shared assumption). The specimen supports the classification-and-recovery discipline at toy scale. It says nothing yet about concurrency, size, adversaries, or cost.

The next specimen, if commissioned: power-loss simulation (or `O_DIRECT` + torn-write injection) to separate CW-2 from CW-3 physically; a second seat to make supersession contend; journal sizes that make prefix validation sweat; and the F6 metric rewritten so a machine, not a judgment call, draws the scaffolding line.

*The first datum was a corpse. Six of them, hashed, folded twice, and answered for.*
