# Builder-host observations — HISTORICAL ONLY, from a retired instrument

**Integration Baseline /0 R5 · 2026-08-03**

The executable probe census was **retired** by owner ruling at R5. This page preserves the only
figures from it that survive, and says exactly what they are and are not.

---

## What these numbers are

During R4 the retired census ran the twenty-eight historical probe files on the builder's host and
recorded their exit codes:

| observation | count |
|---|---|
| exit 0 | 19 |
| exit 1 | 8 |
| exit 124 (this builder's 90-second limit) | 1 |
| **total** | **28** |

and, within the twenty-three files the retired instrument then classified as host-bound:

| observation | count |
|---|---|
| exit 0 | 19 |
| exit 1 | 3 |
| exit 124 | 1 |
| **total** | **23** |

## What they are NOT

- **They are not clean-checkout findings.** Every one of those runs loaded, or tried to load, a
  subject out of a tree that is not this repository — the July-28 audit scratchpad, or the main lab
  checkout. A green from a wrong tree is not a green.
- **They are not reproducible here, and must not be reproduced.** The ruling is explicit: *do not
  rerun the twenty-eight probes.* The trees those runs read no longer travel with the repository,
  and re-running would produce a fresh observation of a fresh accident, filed under an old figure.
- **They do not license any partition, flag, or cardinality.** In particular there is **no global
  `DANGLING-REF` figure** anywhere in this lane any more. R1–R4 published one; it ambiguously mixed
  raw pathname values, effective filesystem dereferences and historical host state, and it is
  withdrawn rather than corrected.
- **They are not derived from anything that still runs.** The instrument that produced them is gone
  from the active surface. What remains is the static inventory
  (`PROBE-SOURCE-INVENTORY.tsv`), which makes no execution claims at all.

## What binds them

The figures above are bound to the raw logs of that R4 run by hash, in
`HISTORICAL-BUILDER-HOST-RAW-LOGS.sha256` — twenty-eight entries, one per probe, captured at
`c3f3c1fc8bd8209eae416af7764555400e388720`. The logs themselves are gitignored working evidence and
travel in the R4 and R5 parcels; they are not re-imported into the active tree, because an artefact
a future instance could mistake for a governing instrument is exactly what this round removed.

If the hashes and the logs are ever separated, **these figures lose their evidence and should be
struck**, not re-derived.

---

*Historical observation of a wrong tree, preserved at its true size and no larger.*
