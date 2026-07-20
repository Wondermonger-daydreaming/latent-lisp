# SS-0 Protocol — budgets, VOID criteria, freeze procedure

*FROZEN 2026-07-19 (owner-approved); hashes in SS0-FREEZE-LEDGER.md.*

## Roles

Chair & verifier: Fable (may not implement either side — has read both KW-0 implementations). Falsifier/mutation co-author & hostile prereg reader: Kimi packager instance (recused from implementation). Implementers: two clean-context seats (see SEATING-PROPOSAL). Owner: seeds sessions, reviews and freezes all documents, adjudicates disputes.

## Budgets & measurements (Kimi's substrate-boundary rule, adopted)

- The shared substrate is a **counted deliverable** with its own line budget, identical for both sides by construction (same bytes).
- Each side's semantic layer is measured after subtracting **only** the shared substrate; **per-side private helpers count in full** (AFEL tool, marker rule audited).
- Nine measurements per side: application-facing effective lines; call-site obligations per consequential operation; recovery branches; manually coordinated identities; invariant violations under planted mutations; effort (AFEL delta + description) to add the sealed extension; cross-language recovery agreement; audit-trail completeness (R9 walk by the chair); whether information loss appears only in derived views or contaminates the durable record.

## VOID criteria (each gate teeth-checked with a planted fault before it is trusted)

- **VOID-1:** a side's recovery path reads scenario metadata, `READY-*` markers, harness state, or provider internals directly → that run VOID.
- **VOID-2:** any of the eight excluded concepts appears in the shared substrate under any name (lexical audit + planted-concept probe) → affected runs VOID.
- **VOID-3:** cross-language agreement achieved via shared fold code or shared expected-value fixtures → VOID.
- **VOID-4:** the sealed extension is revealed to either seat before both implementation freezes → that arm VOID.
- **VOID-5 (boot-context):** a seat's session context contains anything beyond the frozen brief + Substrate API (enumerated and logged at seeding; the seat is asked to confirm; per the harness-is-exposure rule the enumeration, not the confirmation, is the evidence) → that seat VOID.
- **Mutation-scope rule:** "production paths" for the mutation battery are pre-registered per side by the chair *from the frozen sources, before any mutation runs*, so the instrumentation-boundary dispute cannot recur post-hoc.

## Freeze procedure (strict order; every freeze = SHA-256 recorded in a public ledger file)

1. Substrate spec + implementation frozen; VOID-2 lexical audit + teeth-check pass recorded.
2. Adjudication packet completed (mutation battery co-authored with Kimi; interpretation bands; run-VOID conditions) and **sealed**: full text held outside the mirror-synced tree; its SHA-256 committed publicly. The sealed extension effect type is hash-committed the same way.
3. Neutral brief frozen; identical bytes prepared for both seats.
4. Owner seeds Seat A and Seat B (clean-context sessions). Boot context enumerated + logged per seat (VOID-5).
5. Each implementation frozen on delivery (hash). No edits after freeze.
6. Extension revealed to both seats simultaneously; each implements; extension deltas frozen (hash).
7. Chair runs: scenario corpus, recovery invocations, cross-language differentials, mutation battery (per pre-registered scope). All raw outputs preserved.
8. Adjudication packet unsealed; plaintext published; hash verified against step-2 commitment; bands applied as written. Both implementations, all evidence, and the full ledger published together.

## Standing rule

Until SS-0 completes, F5 remains `SUPPORTED-AT-TOY-SCALE-UNDER-HB0` and may not be strengthened. SS-0's own results inherit `TOY-SCALE`-class qualifiers appropriate to its declared scope (multi-effect-type, still one seat, one host, `SIGKILL` not power loss) unless the owner rules otherwise at adoption.
