# LCI/0 Closure P029 Receipt (LCI0-AC-004-P029-SOURCE-PRESERVATION)

Date: 2026-07-15
Author: INTEGRATOR (Claude Fable 5)

## The question and the ruling

`LCI0-P029` (`migrate-v1-collision-pair`) was blocked because the frozen 0.1
expected document substituted the migration source artifact
`object/artifact/legacy-source/v1/2` where the input supplied
`object/artifact/legacy-source/v1/1` (ledger LCI0-DIV-016; packet
`LCI0-AUTHORIAL-RETURN-PACKET-P029-SOURCE-ARTIFACT.md`). The ruling
(`LCI0-AC-004-P029-SOURCE-PRESERVATION`): preserve the supplied source
exactly in both result source and lineage; **"no change if final successor
preserves source exactly."**

## Prior (RED)

Baseline vector gate: `FAIL LCI0-P029 migrate-v1-collision-pair` (211/215);
unit gate `BLOCKED official-red-P029-unsourced-right-migration-artifact`.
The failure was the 0.1 *expectation's*, not the implementations': both
implementations already preserved the supplied source.

## Already-conforming — the record

- CL pre-change actual canonical octets: SHA-256
  `9da0098f2448aaea7d0d3720281a6d02eb78dafb908a4c06831b08b7358089b5`
  (54 022 B) — **equal to the overlay expectation exactly** (forge-cl
  report §AC-004).
- Python pre-change rendered success document: **byte-identical to the same
  ruled 54 022-octet expected document with zero implementation change**
  (forge-py report §AC-004).
- Consequently: **no migration-semantics change in either language.** The
  closure is carried entirely by the fixture layer (overlay supersession of
  the 0.1 expectation) and permanent byte-exact regression tests on both
  sides (CL `official-green-P029-closed-by-LCI0-AC-004` + closure runner
  ORIG-003; Py `test_four_superseded_official_vectors` subTest LCI0-P029).

## Final (GREEN)

- CL vector gate 215/215 (P029 exact against the overlay expectation).
- Python suite green under all `PYTHONHASHSEED` profiles.
- Converged differential: `vector:LCI0-P029` passes in both
  implementations; its result documents carry
  `live-warrants-created = false` on both collision-pair sides in both
  implementations (live-warrant scan log, battery item e).
- The supplied `object/artifact/legacy-source/v1/1` appears preserved in
  result source and lineage; no `v1/2` substitution anywhere.
