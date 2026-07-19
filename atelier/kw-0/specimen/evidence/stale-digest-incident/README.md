# The stale-digest incident (preserved per commission)

During the first differential summary of the KW-0 final generation, the
comparison script resolved CL digests from `reconstruction.txt` files that
had been COPIED ALONG WITH the S4 corpse into the S4-resolve/S4-supersede
branch directories. The first three rows compared pre-resolution CL state
against pre-resolution Python state — both read from stale copies — and
printed MATCH. The comparison was vacuous: a validator wearing the
generator's clothes, caught because the corrected rerun read live files.

Two artifacts are preserved here:
- `first-run-output.txt` — captured console output of the stale comparison
  (the vacuous MATCHes visible as `26C56A27...` for post-resolution branches).
- `corrected-rerun-output.txt` — the fix (per-branch `post-state-digest`
  added to the reconstructor) and the three true live comparisons.

The underlying stale files were deleted; the console captures are the record.
A second occurrence of the same bug class (comparing pre-state CL digest
against post-state Python digest in the branch rows) was caught in the same
session and is included in the corrected rerun output.
