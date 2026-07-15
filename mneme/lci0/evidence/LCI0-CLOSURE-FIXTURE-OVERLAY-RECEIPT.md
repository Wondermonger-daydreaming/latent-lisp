# LCI/0 Closure Fixture-Overlay Receipt (overlay 0.2)

Date: 2026-07-15
Author: INTEGRATOR (Claude Fable 5)

## The artifact

`mneme/lci0/fixtures/archives/lci0-fixture-overlay-0.2-2026-07-14.zip`
SHA-256 `5e03c2f5a17cf69f9b562dcfc5b7dfde85563fc7f88d52fcb01ffe858c1a10eb`.

Both forge branches installed the SAME archive independently; at merge the
two adds were the identical git blob
(`273d922da4e717992a226a6c0a331f0bfcf822c5`) — verified before and after the
merge; the post-merge working-tree file re-hashes to `5e03c2f5…` exactly.
No shared file differed between the two forge branches (contract held).

## Contents (from the overlay INDEX; counts verified)

- `supersessions` (4): overlay-first expectations for exactly
  `LCI0-N012`, `LCI0-E5-COVERAGE-INSUFFICIENT`, `LCI0-P029`, `LCI0-P024` —
  N012/E5/P029 pinned as canonical CD/0 hex (502 B / 1 747 B / 54 022 B);
  P024 pinned as a semantic document (byte-form carries implementation
  freedom).
- `relation-failures` (38): ruled companion coordinates + precedence
  evidence per row.
- `hostile` (8): ruled tuples/values for `LCI0-ACV-HOSTILE-001..008`.
- `closure-records` (4): AC-005/006/008/009 unique normative results or
  explicit deferrals.
- Lookup precedence: for a superseded 0.1 vector key consult the overlay
  FIRST; every other key falls through to frozen 0.1; the overlay never
  shadows any determinate 0.1 result beyond the four supersession keys.

## Additivity — 0.1 byte-unchanged (proof)

- 0.1 fixture archive
  (`lci0-errata-0.1-fixture-package-2026-07-14.zip`): git blob
  `dcaaa3ebd40ee505950ef5ea8215e18607d33271` identical at base `2513c354`
  and at the integrated HEAD; file SHA-256
  `36cc71ccf3c310a055199c54e84bf436c4505d92a6378f22e8b1d932f02e987d`.
- Materialized 0.1 members: `LCI0-FIXTURE-REGISTRY.json` SHA-256
  `dd19c6d6543a875b2e7e1e6a234ad731ce019f64495b447b317462c63f826327`;
  `LCI0-FIXTURE-VECTORS.jsonl`
  `387e76963f3087f6e41ec4363ec3eea29b1456c2a6b3c5a0cf5763418bffe3a4` —
  verified in every fixture root used (integration root and the pinned
  post-convergence root), before and after `materialize-overlay`.
- `materialize-overlay` is additive-only and refuses overwrite; loaders in
  both languages verify the overlay SHA256SUMS and pin the INDEX hash;
  supersessions are limited in code to exactly the ruled four keys.

## Fixture roots used by this integration (choice recorded)

- `/tmp/lci0-integration-fixtures-1784084025` — fresh root materialized for
  this integration (base 0.1 + overlay 0.2); used by every language battery
  and the differential run.
- `/tmp/lci0-seed-fixtures-20260714` — the baseline's root, whose path the
  post-convergence harness **pins by design** (the CL seed froze the
  extraction location; the harness verifies the two 0.1 member hashes).
  The task sanctioned modifying this root after the baseline banked; the
  overlay was materialized into it **additively** (0.1 member hashes
  verified unchanged before and after — same values as above). Without the
  overlay, the harness's embedded CL unit suite fails the three
  overlay-superseded green regressions against superseded 0.1
  expectations — observed once and re-run green after the additive
  materialization (see `LCI0-CLOSURE-FINAL-VERIFICATION-TRANSCRIPT.md`).
- `/tmp/lci0-baseline-rerun-1784064852` — banked baseline differential
  evidence; untouched.

## No-overlay mode proof (forge, carried by merge)

The CL loader on a 0.1-only root produces a byte-identical vector-gate
transcript to the pre-change baseline (forge-cl
`newcode-no-overlay-vectors.log`, diff empty); the Python pre-existing
100-test suite passes on a no-overlay root. The overlay is normative for a
conforming successor root; its absence reproduces the pre-closure state
rather than corrupting anything.
