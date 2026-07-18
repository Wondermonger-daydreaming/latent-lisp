# PROCESS-JOURNAL-0 — DRAFT-F PLAN (staged, mirror-excluded until Sol's draft lands)

**Author:** Claude Fable 5 (Opus lineage) · 2026-07-18, late evening
**Blinding:** this file lives in `_staging/` — excluded from the public mirror by the sync's
own exclusion rule — so Sol, cooking its PJ0 draft against the public tree, cannot read it.
The lab commit timestamp is the ordering proof. Published to the chamber only after Sol's
draft is received. *(Upgrade over the kernel round, where blindness was declared discipline;
here it is enforced by the machinery.)*
**Governing:** Kernel /0 spec (ADOPTED, incl. R-SYN-2's seam law: readability is kernel
conformance; ALL framing is PJ0's) · A0.1 §9 · the six kernel0 gaps (public, shared input).

---

## 0. What PJ0 must do

Give bytes and failure behavior to every currently-abstract Mneme promise: durability,
torn tails, prefix validity, atomic append, reconstruction, receipt-bearing merge, and
byte-deterministic folds — such that the vertical specimen's four kill points each land in a
*defined* journal state, and TALLY-II's reconstruction becomes a conformance test instead of
a heroic act.

## 1. Scope (owns / does not own)

**Owns:** journal identity + segment model · exact record grammar (S-expression) · canonical
octets (via CD/0 — no new byte inventions) · framing + delimiters + commit markers · append
atomicity contract per durability class · torn-tail detection ENCODING + preservation
protocol · prefix-validity to the byte · fold determinism (same bytes ⇒ same fold, byte-
compare) · filesystem reference layout · merge + reconstruction receipt encodings ·
recovery procedure as executable steps.
**Does not own:** event *semantics* (kernel's) · adapter behavior (AP0's) · crypto sealing
(owed-ledger, later) · distributed/multi-writer stores (v0 is one journal, one writer) ·
compaction/rotation policy beyond the minimal segment rule.

## 2. The design forks (each gets a FORK-n section in my draft, with my position argued)

- **FORK-1 Framing:** line-delimited records vs **form-delimited + explicit textual commit
  marker** (my lean): a record is one top-level S-expr form; a separate small marker form
  (`(committed <ordinal> <digest>)`) seals it; a torn tail is trailing bytes that fail to
  parse as form+marker. Rationale: multi-line pretty-printed records stay legal (human
  readability at 5 a.m. beats one-line grep-ability), and **the reader adjudicates** torn
  tails (the workshop law) rather than a byte-counting heuristic. Line-delimited is the
  fallback if the marker cost offends.
- **FORK-2 Marker digest:** per-record digest of canonical octets (CD/0) in the commit
  marker — catches torn-in-the-middle and bit-rot, not just torn-at-end — vs bare ordinal
  marker (cheaper). My lean: digest; the cost is pennies, the class of caught corruption is
  §15.16's whole family.
- **FORK-3 Durability classes:** `:synced` = fsync-after-marker with platform notes (WSL/ext4
  honesty — declared, tested where testable, *believed* where the OS lies, and said so) ·
  `:best-effort` = no fsync, reconstruction MUST treat the un-synced tail as `:bounded`
  evidence. My lean: exactly these two in v0; no middle tier.
- **FORK-4 Torn-tail preservation:** quarantine-move (tail bytes to a sidecar
  `<segment>.torn` + journal note) vs preserve-in-place with reader-skip. My lean:
  **quarantine-move with a receipt** — in-place preservation makes every future read
  re-adjudicate the same bytes; the move is itself an evidence-bearing act.
- **FORK-5 Segment model:** single append-only file vs numbered segments with rename-based
  rotation. My lean: numbered segments (`journal-<id>-<n>.sexp`), rotation only at explicit
  checkpoints; crash-during-rename analysis included.
- **FORK-6 Merge encoding:** merge output = a NEW journal whose first record is the merge
  receipt (ordering rules, conflict policy, input identities + digests) — never in-place
  interleaving. My lean: firm.

## 3. The crash-window table (the spec's spine)

For each kill point of the specimen (before-dispatch · after-dispatch-pre-ack ·
post-ack-pre-manifestation · post-seats-pre-finalize) × each durability class: the exact
possible journal states, what the fold reports, what recovery refuses, which condition fires.
Every cell becomes a fixture. This table is what makes "kill -9 at any instant" a *specified*
event rather than an adventure.

## 4. Teeth (fixtures the draft ships with)

- **Truncation corpus:** programmatic truncation of a golden journal at every byte-class
  (mid-record, mid-marker, between records, inside the digest) — each must yield
  torn-tail-detected + correct prefix fold; negative control: a truncation the detector
  must NOT flag (clean boundary).
- **kill -9 harness:** a child process appending under load, killed at randomized offsets,
  N times; invariant: fold(prefix) always valid, no laundered tails. (Disk-first,
  incremental — the emission-night discipline as test design.)
- **Byte-determinism:** same journal bytes → fold → re-emit → byte-compare; across two SBCL
  runs and (stretch) a second CL implementation.
- **Merge fixtures:** two shard journals (the jspace two-shard precedent as the shape),
  merge with declared ordering, receipt verified, then a *conflicting* pair whose declared
  policy must fire.
- **Gap-5 confirmation:** resolved-ness of uncertain-effects is fold-derived — PJ0 states it
  as design (no mutable resolved flag in any record), closing kernel0 gap 5.
- **Gap-6:** multiple-unresolved-effects occupancy — PJ0 either specifies the lossy summary
  or blesses `unsupported-reconstruction`; my lean: bless the refusal in v0 (conservative,
  honest), profile a summary later.

## 5. To-do list (ordered; owner column honest)

| # | Item | Owner | Gate |
|---|---|---|---|
| 1 | This plan frozen in `_staging/` (lab commit = timestamp) | Fable | done with this commit |
| 2 | DRAFT-F-PJ0 written full (compact normative, PJ-* IDs, forks argued) | Fable | next sitting or on demand — stays staged |
| 3 | Sol's PJ0 draft arrives → adopted bit-exact into chamber | owner carries, Fable adopts | whenever cooked |
| 4 | BOTH drafts revealed (mine leaves _staging → chamber), concordance agent (WEAVER-II) runs the dual trace | Fable + 1 Opus | after 3 |
| 5 | Chair adjudication + review verdict + synthesis surgery (SUTOR-IV) under the ledgered pattern | Fable + 1 Opus | after 4 |
| 6 | Sol pre-seal read of the synthesis (the pattern's proven step) | Sol | after 5 |
| 7 | Owner seal of PJ0 | Tomás | after 6 |
| 8 | **Implementation arc 3:** journal store built against PJ0 (Codex fleet, conductor, chair-verified) — kernel0's excluded tests 15–22 etc. come alive | conductor + Fable | green word already standing |
| 9 | In parallel with 3–7: **Adapter-Protocol-/0** same blind pattern (my AP0 plan seeds from kernel §A.2 + gap 4) | both chairs | can overlap |
| 10 | Two-chair disposition of the six kernel0 gaps (gaps 1–4 are erratum-lane; 5–6 close via PJ0) | Fable + Sol + owner nod | can start any time — gaps are public |
| 11 | Arc 2 (capability live-authority) — needs no PJ0 | conductor | any time; suggest after 10's condition-type minting |
| 12 | Specimen /0 spec → the four deaths for real | after PJ0+AP0 | the payoff |

## 6. What this plan cannot claim

That form-delimited framing survives contact with Sol's draft (FORK-1 is where we most
plausibly diverge — line-delimited is the industry groove); that fsync honesty is fully
testable on this host (WSL: declared-belief territory, will be named); that one-writer v0
suffices for the council-in-Lisp+ dream (it doesn't — that's a later profile, named not
smuggled).

*— frozen pre-Sol; the timestamp is the proof; the mirror gets this only after Sol's draft.*
