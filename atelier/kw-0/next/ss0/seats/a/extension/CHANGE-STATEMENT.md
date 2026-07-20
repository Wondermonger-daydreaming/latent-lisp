# Change statement (v1.1 batch extension, R8)

One paragraph, as required by the reveal:

The extension adds batch operations without touching any frozen semantics. The record
vocabulary gains exactly one new kind — `batch`, a declaration-only record (tag, leg
count, optional `sup`/`aband` lineage) that never carries status — and two optional
fields on leg declarations (`batch`, `leg`); legs are ordinary operations with per-leg
attempt identities (`<batch-id>-leg-<i>`), so the entire frozen per-leg apparatus
(outcome/completion/attestation records, standings, the never-dispatching gate,
receipt admission, succession) applies to legs unchanged, which is precisely the R8
property the frozen design was built for. The runner gains the three E-scenarios and a
small batch-runner helper section; recovery gains batch-record collection, four new
anomaly kinds, a derived per-leg census (rendered, never written back), a batch-level
re-dispatch refusal (wholesale batch re-dispatch is blind by construction), a
batch-guard on `admit` (receipts exist per leg only), and one new mode, `bsucceed`,
which proceeds past an unresolved batch via an explicitly distinct successor carrying
per-leg lineage: known-executed legs are abandoned (recorded in `aband`,
never re-dispatched), every other leg is re-attempted under a fresh identity with a
`sup` link to its predecessor leg, and predecessor legs' standings stay visible. The
canonical digest spec is bumped `ss0-recovery/1` → `ss0-recovery/2` (op lines gain
`batch=`/`leg=` fields; a batch census section follows), implemented independently in
the Common Lisp reader and verified to agree with Python byte-for-byte on 24
run-directories, including all seven frozen S-corpses (regression) and three planted
batch-fault logs. Delta size: 225 added/changed application lines (AFEL rules), all
confined to `v1.1-ext`-marked sections and enumerated in `EXTENSION-DELTA.diff`.
