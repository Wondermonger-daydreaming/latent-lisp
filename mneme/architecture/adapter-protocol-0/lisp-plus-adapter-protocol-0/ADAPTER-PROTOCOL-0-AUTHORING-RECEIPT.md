# Adapter Protocol /0 — Authoring Receipt

**Author:** GPT-5.6 Sol  
**Date:** 2026-07-18  
**Standing:** candidate specification packet, not adoption and not live-provider authorization.

## Governing source identities

| Source | SHA-256 |
|---|---|
| Architecture 0.1 | `dd4894d45ad55dc1c051af44fcca22367b5b0718e1129adbd30059e3a58c7161` |
| Kernel /0 | `386fead212bf8baccd116d673993145e6f2bea077516ee4770ebf9521503093c` |
| Process Journal /0 | `f98bf397932ed1d37787bed62840a002346f86b2611a78bebac92c729cd04a80` |
| PJ0 pre-seal repairs | `0c95b7292f9591c05f250aac89fb3bd0e592e34249ca9510dc04c3435df82741` |
| AP0 DRAFT-S | `f1f40a725efed7a0ec4168ceeaddd2f7d24bf21bb79473e7844b26f0f86c9854` |
| AP0 DRAFT-F | `f66d3debf00b84e32b788161db590a4dc2c2e4c7680a0c3d7fca35db4e617847` |
| AP0 concordance | `f71e3d36609e81b1ab017281b214af15b30bfd60832a987f66633e094554c329` |
| AP0 authoring charge | `53754f63bdcf217f1ded00c0e2b23f3c6b854eb730fb2cd977a7c853996b3e5c` |

## Deliverables

- `LISP-PLUS-ADAPTER-PROTOCOL-0-SPEC.md`
- `AP0-FIXTURE-REGISTRY.sexp`
- fake-adapter descriptor and absence table;
- 10 deterministic scripts;
- 44 positive vectors;
- 20 adversarial vectors;
- 12 planted mutants;
- independent vector validator;
- generator source;
- fake-adapter smoke runner;
- mutation runner;
- conformance matrices;
- authoring transcript;
- mutation scorecard;
- relay to Fable;
- checksum manifest and deterministic ZIP.

## Executed checks

- `AP0 VECTOR VALIDATION: 64/64 PASS`
- `AP0 MUTATION SCORE: 12/12 KILLED`
- `FAKE ADAPTER SCRIPT SMOKE: 10/10 PASS`
- balanced Markdown fences checked;
- no live network/provider call was made by the packet tools;
- validator does not import generator source;
- fixture content is synthetic.

## Bounded unknowns

- The adopted Kernel appendix erratum for AP-G4 remains in the gaps-1–4 two-chair lane.
- The candidate has not yet received Fable’s SCAR-TRACER/MALLET review.
- No separately seeded Common Lisp adapter implementation has run these vectors.
- No live provider behavior is certified.
