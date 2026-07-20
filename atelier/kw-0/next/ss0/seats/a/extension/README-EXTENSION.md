# SS-0 Seat — README addition: v1.1 batch extension (R8)

This file supplements the frozen README.md. The frozen sources are unchanged on the
ledger; the extension ships as updated `ss0.py` / `ss0-reader.lisp` whose changes are
confined to clearly marked `v1.1-ext` sections and are also provided as a unified diff
(`EXTENSION-DELTA.diff`). Substrate v1.1 (provider + harness deltas) is used as
delivered, byte-identical to `REVEAL-SHA256SUMS.txt`.

## The extension

Provider v1.1 gains one metadata-only tag: `batch:<label>:<n>` returns a batch
descriptor (`{status: batch, label, legs: n}`) and writes **no** world artifact and
**no** receipt. The application dispatches each leg individually via
`effect:<label>` / `effect-ne:<label>` with per-leg attempt identities.

## Schema delta (what changed in the record vocabulary)

- **New record kind `batch`**: `{k:batch, op:<batch-id>, tag:"batch:<label>:<n>", legs:<n>}`
  plus optional lineage fields `sup` (predecessor batch) and `aband` (csv of abandoned
  predecessor legs). Declaration metadata only — the durable record never carries a
  batch-level status (extension obligation 1).
- **Two new optional fields on leg declarations** (`op`/`succ`): `batch` (owning batch
  id) and `leg` (1-based leg index). Legs are ordinary ops; every frozen per-leg
  mechanism (outcome/completion/attestation/standings/gate) applies unchanged.
- **Leg identity convention**: leg `i` of batch `<bid>` has op-id `<bid>-leg-<i>`,
  which is also its provider attempt-id, so per-leg receipts are
  `receipt-<bid>-leg-<i>.txt` and the frozen `admit` mode resolves legs individually.
- Nothing else changed. No frozen record kind, field, standing, or gate rule was
  redefined; the only signature widenings are internal (`build`/`render`/`gate` also
  carry the batch table) and are marked `v1.1-ext`.

## Scenarios

`E1-clean` (kind `batch`): declare batch `b1` (`batch:settle:3`), fetch descriptor,
settle legs 1–3 end-to-end, exit 0. `E2-mid-batch` (kind `batch`, killpoint
`mid-batch`): settle leg-1; declare + dispatch leg-2 (provider executes); window
**before** leg-2's outcome record; leg-3 never dispatched. `E3-leg-refused` (kind
`batch-ne`, killpoint `leg-refused`): same shape with leg-2 via `effect-ne:settle`.
Both the kind+killpoint and E-name runner forms are accepted, as with the S-corpus.

## Recovery and modes

- Per-leg standing is derived per leg from records alone; the batch contributes only a
  **derived census** (rendering + human report). Leg-3 of E2/E3 reports `NONE`.
- `redispatch <batch-id>` refuses with the batch record and per-leg census cited;
  `redispatch <leg-id>` uses the frozen per-leg gate (obligation 2).
- `admit <batch-id>` refuses (providers issue receipts per leg, not per batch);
  `admit <leg-id>` resolves exactly that leg — siblings unaffected (obligation 3).
- **New mode `bsucceed <old-batch> <new-batch>`** (obligation 4): writes a successor
  `batch` record (`sup`, `aband`), then for each leg: known-executed legs
  (SETTLED/ATTESTED-executed) are **abandoned** (re-attempt would double-execute) and
  recorded in `aband`; all other legs are re-attempted under fresh per-leg identities
  — a `succ` declaration with `sup=<old leg>` when a predecessor leg exists, else an
  initial `op` declaration. Re-attempts dispatch `effect:<label>` (the leg's
  underlying intent; `effect-ne:` was a scripted refusal probe, not the intent).
  Predecessor legs' standings remain on record and visible.
- `succeed` on a batch id refuses and points at `bsucceed`.

## Digest spec `ss0-recovery/2` (obligation 5 — the documented change)

v2 = v1 with two additions: (a) every op line gains two trailing fields
`|batch=<id|->|leg=<i|->`; (b) after the op lines, a census section:
`batches=<count>` then per batch, in declaration order,
`batch=<id>|tag=<tag>|legs=<n>|sup=<id|->|census=<i:STANDING|i:NONE,…>|aband=<csv|->`.
Header string is `ss0-recovery/2`. v2 digests therefore differ from the frozen v1
digests even on v1 corpora — that is intentional and documented; the independent CL
reader implements v2 and agrees byte-for-byte (verified on 24 run-directories:
10 harness runs, successor/attestation states, 7 planted-fault logs, 4 payload runs).

## Extension assumptions

Descriptor responses are metadata (not recorded; the batch declaration already carries
`legs` from the tag). Leg membership is recovered from the `batch`/`leg` fields, not
from id naming. `CONFLICT`/anomaly handling extends to batch records (duplicate batch
declaration, batch without id, leg of undeclared batch, successor batch of undeclared
batch) with the same report-never-repair stance.

## Verified before freeze (this delta)

- Substrate selftest on v1.1: **11/11 PASS** (SBCL 2.4.11, Python 3.12).
- Harness v1.1, all ten scenarios: S1–S7 byte-identical record hashes vs the frozen
  runs (regression clean); E1 exit 0 (3 legs executed); E2 SIGKILL mid-batch with
  leg-2 executed-but-unrecorded and no leg-3; E3 SIGKILL after durable leg-2 refusal.
- Per-leg obligations exercised live: batch and leg re-dispatch refusals with
  citations (exit 3), batch-admit refusal, per-leg attestation (E3 leg-2 →
  ATTESTED/not-executed, siblings untouched), `bsucceed` lineage census
  (abandons executed leg-1, re-attempts 2–3, predecessor UNRESOLVED stays visible).
- Python ↔ CL digest agreement: **24/24** run-directories.
- AFEL (`ss0-afel.py`): `ss0.py` 513 (10 excluded `@harness` lines = the original 8 +
  the 2 E-scenario kill-waits), `ss0-reader.lisp` 166, total 679. Extension delta
  (added/changed application lines, same counting rules over `EXTENSION-DELTA.diff`):
  **225** (net growth over frozen: 152 Python + 45 CL = 197).
