# CONFORMANCE-MATRIX — Adapter /0 (phase 1, at the seal)

§23 names six conformance classes.  Each row below states this
implementation's standing for that class AT ITS EARNED SIZE, with the
evidence row that earns it.  **Every green in this table is labeled per
§24.1: it is a self-consistency-plus-independent-seeding result** — the
implementation was derived from the contract and frozen fixtures under a
sealed exposure fence (commit `41df2330`), and its greens are exactly
that; whether they lift the adoption riders is the OWNER'S adjudication,
not this table's.  No class is claimed merely because adjacent classes
passed.

| # | Class (§23) | Standing claimed here | Evidence (check ids) |
|---|---|---|---|
| 1 | descriptor conformance | demonstrated over the two frozen canonical descriptors: canonical decode, distinct identities, witnessable-set law, boolean-capability refusal, descriptor ≠ live object | selftest [001][002][018]; vectors BAD-CAP-01, BAD-ACK-RELABELLED rows; controls [C001] |
| 2 | projection conformance | demonstrated: custody-before-projection, the exhaustive 11-row table, table-miss refusal, deterministic projection with derived origin and receipt, status/state split | selftest [003]-[005][025]-[027]; vectors ABS-01..ABS-11 + BAD-PRJ-*/BAD-ENV-* rows; joint [J001]-[J020]; controls [C016]-[C018] |
| 3 | stream conformance | demonstrated: chunk identity/relation fields, duplicate/collision/conflict/gap laws, §10.5 persistence order with teeth, partial preservation | selftest [013][014][024][034][036][037]; vectors STR-01..04 + BAD-STR-*/BAD-PART-01 rows; controls [C011]-[C015] |
| 4 | reconciliation conformance | demonstrated: identity timing classes, AP-REC-6 conjunction, distinct-witness law, not-found ≠ no-effect | selftest [031]; vectors RID-01..07 + REC-01..03 + BAD-REC-*/BAD-RID-* rows; controls [C009] |
| 5 | fake-adapter conformance | demonstrated at the frozen-script size: all ten scripts execute deterministically (two-pass byte-identical digests), computed terminals equal declared terminals, all four crash windows and all terminal shapes produced, planted defects killed | scripts [S001]-[S021]; selftest [033]-[038]; FAKE-01 vector row |
| 6 | full AP0 conformance | **NOT CLAIMED.** All five classes above plus the joint gate and the L17 audit ran green in THIS lane's own harness, but §23-full is claimed at no larger size than the conjunction of the rows above: a co-authored-fixture, self-run result under independent seeding. The riders' standing (and with it any stronger conformance language) awaits the owner's adjudication; "independently verified/validated" is not said of any row here | joint [J001]-[J024]; l17 [L001]-[L004]; SEAL-RECORD.md |

Notes held to exact size:

- "Demonstrated" in every row means: shown by the cited checks over the
  frozen Class A fixture set and this lane's synthetic controls — not
  over any live provider, and not by any outside hand.
- The registry's own scalars arbitrate every count (derived live,
  vectors [V001]).
- The mutation gate's 20 kills are rule-exact (vectors [V085]-[V104]),
  which is what §24.2 requires of negative-control evidence.

*— CLAVIGER-IV (Claude Fable 5), 2026-07-30*
