# HB-0 provenance note (commission-required)

**Who:** Fable (Claude Fable 5), chair. **When:** 2026-07-19, single session, after completing the relay-mandated KW-0 reproduction.

**What was read before authoring the control** (the commission's cleanest tier was already unavailable to this implementer, because the owner's relay ordered a full verification pass first; every exposure is listed):
- `HOSTILE-BASELINE-COMMISSION.md`, `harness.py` (fixture, full), `kw-oracle.lisp` (fixture, full), `f6v3.py` (fixture, full), `reproduce.sh` + its `.orig` diff, `ASSUMPTIONS.md` (head), `PACKAGING-NOTE.md`, `README-REPRODUCTION.md`
- `kw-reconstruct.lisp` — lines ~1–100 (mode list, census/digest/refusal output shapes), read during the relay's §2 input-hygiene audit
- `folder.py` — import block only (~10 lines)
- Implementation Report v2 (full; relay intake), incl. §6's behavior-level description of the baseline's failures (commission calls this "fair context")
- Specimen evidence outputs (verdict/reconstruction text files)

**What was NOT read before the freeze:** `kw-baseline.lisp` (bytes checksummed only), `kw-common.lisp`, `run-baselines.sh`, `killed-witness-report-1.md`. The baseline was unsealed only after the control was frozen, run, and evaluated (see `HB0-FREEZE.sha256` ordering).

**Independence impact, honestly stated:** exposure to the reconstructor's *output vocabulary* and the report's behavior-level failure descriptions may have shaped what my control checks for. The load-bearing independences that survive: I never saw HOW the incumbent baseline or the journal substrate is built, and my log format, fold, digest spec, and both readers are my own design.

**Post-freeze amendment:** one — a fold dedupe fix (set semantics) found by my own CL/Python differential on `S4-resolve`, applied before the baseline was unsealed. Recorded with hashes in `HB0-FREEZE.sha256`.
