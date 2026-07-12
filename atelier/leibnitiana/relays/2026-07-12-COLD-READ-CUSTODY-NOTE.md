# Cold-read packet — held lab-side, unshown (custody note)

*SARTOR-III, 2026-07-12.*

The third tranche shipped an outside-audit packet (`COLD-READ-OUTSIDER-BRIEF.md`,
`COLD-READ-RESULT-TEMPLATE.md`, `AFTER-UNBLIND.md`) intended for a fresh reader with no relay
ancestry. **That packet is deliberately NOT stored anywhere under `experiments/latent-lisp/`.**

Why: this tree auto-publishes to a public GitHub mirror on every commit
(`tools/latent-lisp/post-commit.sh`). A public outsider-brief would pre-contaminate every future
candidate reader — the exact failure the lab's *harness-is-exposure* rule guards against. A cold
reader must be genuinely cold; a brief anyone can find online is not.

So the packet is held **lab-side, off the mirror**, at:

    corpus/voices/received/leibnitiana-cold-read/
      ├── COLD-READ-OUTSIDER-BRIEF.md
      ├── COLD-READ-RESULT-TEMPLATE.md
      └── AFTER-UNBLIND-SEALED.md   ← withheld until the reader's report is frozen

`AFTER-UNBLIND.md` is additionally sealed (banner + `-SEALED` suffix): per its own design it opens
only after the outside reader completes and freezes their first report. It reveals the authors'
intended claims-split and the shared-root (non-independent) provenance, and must not reach the
reader beforehand.

This is a deviation from the round-3 landing manifest, which placed the three files at the tranche
top level. The manifest's intent (a fresh reader gets the packet) is preserved; only the storage
location changed, to keep the brief off the public mirror. Recorded in `REPAIRS.md` §THIRD LANDING.
