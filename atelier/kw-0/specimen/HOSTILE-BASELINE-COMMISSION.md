# HOSTILE BASELINE COMMISSION — HB-0

**Status:** open commission, awaiting an independently seeded implementer (Fable, or another chair not identical to the specimen author). **Kimi-k3 is explicitly barred from authoring the hardened control** — the specimen author may not also build the strongest version of its control group. This document is the complete brief; the implementer needs nothing from the specimen author beyond it and the bundled fixtures.

## Brief

Write a **conventional** event-log implementation — the best 100 lines (see budget definition below) a competent engineer would write — that attempts to match the Killed Witness specimen's observed behavior on the same scenario corpus, **without** using the specimen's journal/framing/fold machinery. JSON-lines, SQLite, files — implementer's choice, but *conventional*: no capability discipline, no outcome algebra, no per-axis determinacy vocabulary. The point is not to cripple the control; the point is to give the incumbent discipline the strongest conventional opponent 100 lines can buy.

## Fixtures provided (in the bundle)

- `src/kw-oracle.lisp` — the deterministic fake provider, unchanged. The control must drive the same oracle and accept the same deaths.
- `harness.py` — the death harness (kill windows cw0, cw1, uncertain, cw2cw3, midstream, nonexec). The control runs against these windows unmodified.
- The six+one scenario definitions in `harness.py:SCENARIOS`.
- `f6v3.py` — the mechanical AFEL metric; the 100-line budget is measured by it.

## What the control must achieve to falsify (F5, owner-revised)

The conventional implementation, in ≤100 AFEL, must:

1. **Prevent, not merely detect**, the four lies — empty→null collapse, blind-retry double-spend, reconstruction→observation laundering, finalizer-only loss — *by construction*;
2. **Preserve** the distinctions across crash recovery (not only in the happy path);
3. **Reproduce** the result in an independent implementation (a second, separately written reader of the control's records must derive the same recovery state);
4. **Provide equivalent auditability** — receipts, scoped visibility, origin tags distinguishing observed from reconstructed;
5. **Extend** to a new effect type without hand-recreating the discipline.

If the implementer achieves all five within budget, **F5 falsifies**: the specimen's distinctions buy nothing over a competent conventional log, and the architecture is ceremony at this scale. Partial success is reported per-clause. Failure modes must be reported unrepaired — a control that almost makes it is more informative than either pole.

## Independence conditions

- The implementer reads this brief and the fixtures. The implementer does **not** read `kw-common.lisp`, `kw-runner.lisp`, `kw-reconstruct.lisp`, `folder.py`, or the specimen's report before delivering. (The specimen's report §6 describes the baseline's observed failures at the level of behavior, which is fair context — but the cleanest run reads nothing but this brief and the fixtures.)
- The implementer's implementation language is their choice.
- The implementer signs a one-line provenance note (who, when, what was read) that ships with the control.

## Evaluation

The control is run by a third party against the same harness. Verdict script compares: recovery classifications on all seven corpses-equivalents, retry behavior on the uncertain window, provider-log execution counts (no double-spend), census origin honesty, and the F6-v3 AFEL budget. Results append to the specimen's report as F5-round-2, replacing "provisionally supported" with a verdict.

*Drafted 2026-07-20 by Kimi-k3 at the owner's direction. The specimen author recuses from authoring the control.*
