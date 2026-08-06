# Surface Account /0 — R1 Amendment Log (document/TSV jurisdiction)

**Seat:** JURIST (Claude Fable 5), third sitting. Jurisdiction: all lane
documents and TSVs **except `probes/`** (owned by the parallel probe seat).
**Governing law:** `OWNER-ADJUDICATION-R0-AND-R1-COMMISSION.md` (committed
`063e4d31`); where this log and its text differ, its text wins.
**Date:** 2026-08-04. Committed by the chair, not this seat.

Format: per adjudication section — what changed, where, which clause drove
it. All amendments below were entered by JURIST; cross-seat entries into
CARTOGRAPHER's (`CARTOGRAPHY-NOTES.md`, the TSVs) and WARDEN's
(`OPENING-BASE-AND-CUSTODY.md`) artifacts are attributed in those files.

---

## Section A — artifact algebra closed

- `SURFACE-ACCOUNT-0-CONTRACT-CANDIDATE.md` **I.0 (new):** the
  pure-projection law adopted verbatim (four bullets); explicit statement
  of what the composite DOES construct (sealed routing requests; sealed
  pre-delegation refusal records); the unqualified "mints nothing" deleted
  lane-wide (sweep shown in the R1 report; docket §2-B/§6 rephrased to the
  qualified form).
- **I.2:** Door 2 now returns the **exact native receipt** + expanded form;
  try doors return the exact native retained refusal or the sealed
  composite pre-delegation refusal; `account-refusal-p` added (Account-owned
  public predicate for the composite refusal species).
- **I.8:** union re-enumerated as **exactly five members** (S1 receipt, S1
  refusal, S2 receipt, S2 refusal, composite pre-delegation/protocol
  refusal), every member reachable in /0; idempotent self-admission
  **withdrawn** and the hidden sixth branch removed — the inspector's own
  output is in the not-admitted list; no reserved entry in the union.
- **I.8b (new):** complete fixed schema for every branch; no optional field
  whose presence changes a schema (value-absences are explicit constants;
  S2's missing upstream fields are schema-level absence); the R0 "may carry
  live identities `current-at-inspection`" clause removed (optionality +
  live read); **S2 verifier output omitted from the pure inspector
  entirely** — only a constant `verifier-availability` standing field
  remains per branch; purity law extended with "read any live provider
  declaration".
- **I.9:** composite request schema fixed-field (anchor always present,
  value may be `:anchor-not-captured`); the R0 composite wrapper refusal
  record **withdrawn** (the composite wraps nothing).
- **II.5b (new):** the /1 union extension enumerated as **two separate
  branches** (Account-owned completed account; Account-owned retained
  refusal), each with its own predicate and schema; "the fifth member"
  phrasing for the /1 reservation removed everywhere (the fifth member of
  the /0 union is the composite refusal).
- `PROPOSED-API-AND-INTEGRATION-DELTA.md` §1 rewritten to mirror all of the
  above (twelve proposed exports).

## Section B — failure species separated

- Two public condition species proposed — `account-protocol-refused`,
  `account-integrity-alarm` — optionally beneath one base
  (`account-condition`); **an integrity alarm is never an
  ACCOUNT-PROTOCOL-REFUSED condition** (contract I.2; jurisdiction §1, §3;
  API delta §1; R4 §1 and §4(c) gate).
- The exact S2 caught-condition partition (category first: `:integrity-alarm`
  → re-signal original unchanged; then phase for `:protocol-refusal`:
  `:request`/`:perform` → account-domain; `:expansion`/`:runtime`/
  unanticipated → re-signal unchanged) confirmed in jurisdiction §4 (now
  marked RATIFIED), and **propagated** through contract I.4.5, the API
  proposal, the lifecycle (step 7 reference), and the R4 plan (§4(c)).
  Controls propagation is the probe seat's.
- "Phase is the only separator" survives in exactly two places (docket E4,
  jurisdiction §4 fact paragraph), both **explicitly restricted to S2
  `:protocol-refusal` rows**, as the ruling permits.

## Section C — /0→/1 lifecycle repaired

- `SURFACE-ACCOUNT-0-CONTRACT-CANDIDATE.md` **II.1b (new):** the versioned
  coexistence law, all six clauses as ruled; II.1's "movement is what makes
  /0 requests fail closed" **replaced**.
- **I.4.2:** the /0 manifest declared immutable; Door 2's recheck relabelled
  corruption/tamper detection (integrity), never version movement.
- `SURFACE-3-LIFECYCLE.md` **step 5 rewritten:** the fail-closed boundary is
  /1's door (`incompatible-account-version` / `wrong-request-species`,
  before invocation); a /0 request at the unchanged /0 door may remain
  valid under /0's closed law; the R0 live-manifest-recheck mechanism named
  as the error it was.
- `ARCHITECTURE-DOCKET.md` §2-D identity/version cell rewritten to the
  coexistence law. Grep swept: no claim remains that /1 manifest movement
  automatically invalidates a live /0 request inside /0.

## Section D — architecture comparison repaired

- `ARCHITECTURE-DOCKET.md` §2-C judgment **rewritten**: "C buys nothing
  today" **withdrawn**; the four genuine benefits recorded (mint-time
  stored identities; manifest-bound records; uniform schema/refusal law;
  potential fresh temporal occurrence identity); the real tradeoff argued
  (no third live authority, no new grammar/audit burden, no premature
  supersession — and all four benefits arrive with the governed /1 mint);
  §5's C bullet rewritten to match. **The D/B recommendation stands under
  the honest comparison** — verdict unchanged.
- **Part II occurrence identity — the mechanism arm chosen** (contract
  II.3 rewritten): a specified performance datum (image-epoch datum minted
  at load + per-image monotonic counter), folded into occurrence/account
  identities, with three named testable properties (T1 same-image
  freshness; T2 request stability; T3 epoch behaviour) and an explicit
  claims ceiling (no cross-image temporal uniqueness). II.5 schema gains
  the performance-datum row. **Flagged to the probe seat**: the freshness
  primitive is demonstrable via public CD/0 constructors in a
  non-production probe.

## Section G — R4 plan corrected (five ruled points)

- `R4-SURVIVAL-PLAN.md` §4(c): category-first jurisdiction teeth including
  a planted provider-**integrity-alarm** arm and the
  two-condition-species-distinctness tooth.
- §6: the stale enumerate-phase-vocabulary-later obligation **deleted**
  (already enumerated, jurisdiction §4).
- §4(g) (new): gate the exact corrected five-member union and the
  composite-refusal path, plus the not-admitted set including the
  inspector's own output.
- §4 floors + `PROPOSED-API-AND-INTEGRATION-DELTA.md` §4: floor arithmetic
  derived from **actual verify-release rows**, never self-test assertion
  counts (a row is one gate invocation).
- §7 exit 1: adoption must include or be followed by the explicit owner
  ruling naming the composite the canonical cross-surface front door;
  docket §6 carries the same requirement.

## Locked Ruling 2 (STOP-cell ratification) — cited

Citations added where the STOP cells are discussed: docket E2 and §3;
`TERM-GRAMMAR-DECISION.md` §5; jurisdiction §6; contract I.8 and
cross-cutting law 2.

## Locked Ruling 3 — cited

`TERM-GRAMMAR-DECISION.md` §2's elimination marked CONFIRMED with the
ruling's verbatim ground.

## Locked Ruling 4 — recorded

`OPENING-BASE-AND-CUSTODY.md` §6.3 (new): the six named checkpoint commits
ratified as ledger-only housekeeping, "not a general waiver" carried
verbatim; the §6.2 submission answered. **Packing obligation docketed:**
the parcel's `BUNDLE-INSTRUCTIONS.md` (not a lane file; none exists in the
lane) must state the three pre-opening housekeeping commits were accepted
at opening and the six checkpoints are accepted now by this ruling.

## Locked Ruling 5 — vocabulary extension applied

- `READER-PROVENANCE-MATRIX.tsv`: all `OUT-OF-VOCABULARY:` prefixes
  dropped (labels first-class); the two `EXPANSION-CONDITION-REFUSAL` rows
  relabelled **`condition-stored-reference`** with the ruled bearer (the
  condition bears the carrying relation); bearer cells updated; final
  distribution 30/16/12/9/6/6/2/2/1/1 over 85 rows, verified by field
  count.
- `CARTOGRAPHY-NOTES.md` §10 and jurisdiction §7 rewritten from
  "proposed/flagged" to "RULED", each keeping exactly one historical note
  that the labels originated as flags; census phrased **"25 classified TSV
  rows"**, never "25 atomic facts", everywhere (docket E9/§6b included);
  the value-exercised vs merely-enumerated distinction named as preserved
  by the `measured-this-session` column.

## Locked Ruling 6 — verify-receipt standing rewritten, glosses deleted

The ruled standing (bounded re-derivation of stored source-form and
expanded-form identity projections from stored datums; independent of live
grammar/procedure/policy declarations) written verbatim into: matrix
verifier row (bearer + note), `CARTOGRAPHY-NOTES.md` §10, jurisdiction §7,
docket E6, contract I.8b branch 3. Every "against live declarations" /
"inherits the identity trap's exposure" gloss deleted from the lane's live
documents — sweep run and shown clean in the R1 report. **Noted for the
record:** the R0 gloss was a genuinely wrong mechanism diagnosis (if the
verifier recomputed against live declarations, a post-redefinition receipt
would *fail*; its continued `T` demonstrates independence — the ruling's
reading is the one the Control-6 data actually supports). The filed R0
review and response documents retain the superseded gloss as historical
record and were deliberately not edited; Ruling 6 supersedes them.

## Citation durability (chair's R1 law)

Every transcript citation in the lane documents converted to stable
grep-able anchors: `CASE NN` block labels, `REPRESENTABILITY STOPS`,
`OBSERVED MAXIMA OVER THE FOURTEEN FIXTURES`,
`PROVIDER DECLARATIONS AS READ IN THIS IMAGE`, `CONTROL 6`/`CONTROL 7`
blocks, `MEASURED ASYMMETRY, REPORTED NOT SMOOTHED`, and named check lines
(docket E1–E4, E6; `TERM-GRAMMAR-DECISION.md` §4–§5; jurisdiction §1).
Source-file line citations (`surface1.lisp:…`, `surface2.lisp:…`) retained
— those files are closed and byte-frozen. The probe seat guarantees the
anchors exist in the replaced transcript format.

## Not amended, deliberately

`FRESH-CONTEXT-REVIEW.md` and `RESPONSE-TO-FRESH-CONTEXT-REVIEW.md` are
filed historical records of R0 and keep their superseded glosses and
counts; `PREDECESSOR-IDENTITIES.md` and `SEVEN-HEAD-MANIFEST-CANDIDATE.tsv`
and `PROVIDER-API-MATRIX.tsv` required no R1 change (swept, clean);
`probes/` is the parallel seat's jurisdiction and was not touched by this
seat.

— Claude Fable 5 (JURIST, Surface Account /0 opening round, R1 sitting),
2026-08-04

---

# R2 AMENDMENTS (fourth sitting)

**Governing law:** `OWNER-ADJUDICATION-R1-AND-R2-COMMISSION.md` (committed
`c6a2738f`); its text wins over this log. Jurisdiction as before: all lane
documents and TSVs except `probes/` (parallel seat; Section E is theirs).
Chair commits; this seat committed nothing. One chronological log is kept
(this file), R2 appended — the seat's stated choice.

## Section A — CD/0 inspection schema made implementation-determinate

- **New authoritative file: `CD0-INSPECTION-RECORD-SCHEMA.md`** — every
  identifier-datum key with namespace/path (§1); the value-encoding law for
  every enum/keyword/integer/string/code/category/phase/disposition/
  standing value, with the mandatory `("standing" …)` absence encoding
  (§2); the four-key envelope + nested branch body (§3); exact key sets for
  all five branches — 18/18/9/6/6 (§§4–5); schema identity/version datums;
  the 1024-octet detail ceiling with `:detail-string-exceeds-ceiling`
  refusal, never truncation; the native pass-through law (§6); the
  predicate-as-schema-conformance law (§7); and the witness specification
  (§8). Grounded in the read CD/0 export list and the read
  `%normalize-record-entries` sorting law (keys must be identifier datums;
  canonical order = octet comparison of encoded key ValueBytes).
- Contract **I.6** rewritten: the inspection record is **not** a sealed
  semantic object — the private-constructor/read-only-slot ontology is
  withdrawn for it (it stays for the routing request, the composite
  refusal record, and the /1 sealed semantic objects, where it lawfully
  applies); **I.8b** slimmed to law + authoritative pointer; the
  "(first field)" prose deleted (CD/0 canonical key sorting authoritative);
  **I.2** and the API delta: `account-inspection-record-p` recognizes the
  exact CD/0 schema, never a wrapper species; output stated as a direct
  inert CD/0 record datum.
- **Witness address for the probe seat: `CD0-INSPECTION-RECORD-SCHEMA.md`
  §§1–7 (build), §8 (what to prove).**

## Section B — /0→/1 inspector lifecycle closed

- Every "same inspector extended" / "enter the union by schema version
  movement" claim deleted: contract I.8 and II.5b (rewritten — the /0
  inspector, function identity, schema, and five-member domain are
  immutable; /1 ships its own distinct inspector), docket §2-D (three
  cells + the one-inspector-coherence paragraph, now per-version),
  lifecycle step 7, API delta. Sweep shown in the R2 report; the sole
  surviving occurrence is the disavowal quotation in II.5b.
- Naming resolved, one exact address per version:
  /0 = `LISP-PLUS-SURFACE-ACCOUNT:INSPECT-ACCOUNT`;
  /1 = `LISP-PLUS-SURFACE-ACCOUNT-1:INSPECT-EXPANSION` (contract II.2
  table). Dual authority keeps both addresses explicit; alias/supersession/
  rebinding only by later owner adoption ruling, never by registration or
  implication (carried verbatim into II.5b).

## Section C — failure and refusal ownership closed

- **Impossible-route exception removed** (jurisdiction §2 row 2 and §3
  identity-mismatch second arm): `NOT-A-KNOWN-SURFACE2-CONSTRUCT` (and
  S1's counterpart) is `:protocol-refusal`/`:perform` → account-domain
  passthrough, never a composite integrity alarm.
- Jurisdiction §2 split into the **three exact tables**: (1) /0
  Account-constructed codes (7, all `pre-invocation`); (2) exact native
  passthrough outcomes — every measured code enumerated from the survey's
  own catalog read, S1 9+8 and S2 9+7, with **per-code derived standing**
  (`:perform` split: `not-a-known-*`, `construct-not-a-macro`,
  `source-not-reconstructible` = `pre-invocation`; all `:expanded-*`
  ceiling/representability codes = `invoked-no-completion-account`) and
  the never-passthrough codes listed for totality; (3) conditional /1
  codes incl. `:incompatible-account-version` / `:wrong-request-species`
  / `:expanded-p-nil` with standings. §6 re-pointed at the per-code table
  ("never inferred from phase alone").
- "No raw host type error leaks" **qualified to Account-owned argument and
  constructor validation only** (contract I.2 + I.8; API delta).
- Native passthrough refusals stated as **account-domain but
  provider-owned** (table 2 preamble).

## Section D — architecture and identity text corrected

- **Manifest-binding precision** (a sharpening of locked benefit 2, not a
  reopening): under B/D the binding lives in the composite routing request
  **only**; a successful projection from an exact native receipt cannot
  expose it (inspector receives neither the request nor any composite
  completion record; only branch 5 carries manifest identity/version).
  Docket benefit 2 and §2-B canonical-representation cell rewritten;
  preserved as a genuine Candidate-C advantage.
- **/1 occurrence identity — the chosen exact law: a LINEARIZABLE
  Account-owned allocator** (contract II.3 rewritten): one initialization
  per image; linearizability under arbitrary thread interleaving via
  synchronization (lock or CAS, /1 documents which); exact encoded path
  `("performance" <epoch-hex> <counter-decimal>)`; the R1 "unsynchronized
  INCF" honesty defect conceded in the text. **"Load-time unique seed"
  replaced** by the weaker true claim: an image-epoch/entropy datum, no
  cross-image uniqueness guarantee, reload = new epoch + counter restart,
  no cross-reload ordering. T1 upgraded to the concurrent claim; T3
  re-scoped to observation. **The concurrent allocator tooth is flagged to
  the probe seat** (planted arm: unsynchronized counter shown losing
  allocations; clean arm: N×M distinct ordered values).

## Section F — R4/adoption strengthened

- R4 §4 gains family **(h)**: the four production teeth (h1 Door-2
  identical-object `EQ` return; h2 try-door identical refusal object; h3
  byte-identical CD/0 output across live declaration movement; h4 no
  branch reads live declarations, with a planted arm).
- R4 §7 exit 1: **the canonical front-door ruling is part of the Adopt
  exit**, and — in the ruling's words — **Surface /3 may not open merely
  because an implementation exists and passes; it remains blocked until
  the owner explicitly names the canonical authority or explicitly accepts
  labelled dual authority** (also carried into §8).
- Fixed future schemas: "where publicly available" and "if adopted"
  removed from contract II.5 (native-antecedent row now a mandatory field
  with standing datum `("standing" "absent-no-public-antecedent")`; the
  anchor row unconditional, existing only to state its exclusion from
  canonical data); the docket's image-local cell tightened to the
  fixed-field law.

## Custody corrections (folded, no special repair commit)

Both stale numbers lived in `R1-COMPLIANCE-CHECK.md` (the chair's
freeze-time record; corrected in place with visible bracketed attribution):
P1's "21 files" → **22 files (16 modified, 6 added)**; LR5d's "76 / 9
enumerated-only (plus one not-measured)" → **76 value-exercised yes / 8
enumerated-only / 1 explicitly unmeasured**. Swept the rest of the lane's
live documents: no other occurrence of either stale number.

## Locked-acceptance guard

Checked each amendment against the LOCKED ACCEPTANCES list: the
five-member union is untouched (Section B changes /1's side only); the
exclusion list, pure delegation, STOP cells, five labels / 25 rows,
VERIFY-RECEIPT standing, category-first-then-phase, coexistence clauses,
Candidate-C benefits (sharpened, not reopened), and the verdict all stand
byte-consistent with the ruling.

## Not amended, deliberately (R2)

`FRESH-CONTEXT-REVIEW.md`, `RESPONSE-TO-FRESH-CONTEXT-REVIEW.md`: filed
historical records. `PREDECESSOR-IDENTITIES.md`,
`SEVEN-HEAD-MANIFEST-CANDIDATE.tsv`, `PROVIDER-API-MATRIX.tsv`,
`READER-PROVENANCE-MATRIX.tsv`, `CARTOGRAPHY-NOTES.md`,
`TERM-GRAMMAR-DECISION.md`, `OPENING-BASE-AND-CUSTODY.md`: swept, no R2
change required (the R2 custody ratifications concern commits and a ledger
row outside the lane; the five post-R0 ledger commits and the LECTOR row
are the chair's packing record). `probes/` and Section E: the parallel
seat's, untouched by this seat.

## Erratum (measurement-driven, credited to the probe seat)

The R2 schema witness (probe seat; `probe-r2/final-a/
schema-witness-transcript.txt`, `SCHEMA-DOC-DEVIATION` lines with an
exact-count check) measured the actual native datums and found
`CD0-INSPECTION-RECORD-SCHEMA.md` §§4–5 misnamed **twelve keys' value
species**: the native identity values are CD/0 **bytes datums**, not
identifier datums as first written — `receipt-identity`,
`request-identity`, `occurrence-identity`, `source-identity`,
`expanded-identity` in each of the two receipt branches (×10, §4.2 via
"As §4.1"), and `refusal-identity` in each refusal branch (×2, §5.2 via
"as §5.1"). The `occurrence-tag` and `construct-identity` keys were
measured as identifier datums and stand as written. §6's pass-through law
is unaffected (byte-equality proved by the witness). Corrected in place in
§§4–5 with visible erratum marks and a species-erratum note on §2's
pass-through row; no other document repeats the species claim (grep-swept).
JURIST's original species assignment was an unmeasured inference from the
identifier-styled hex renderings — the witness's measurement is the
correction's authority.

— Claude Fable 5 (JURIST, Surface Account /0 opening round, R2 sitting),
2026-08-04

---

# R3 AMENDMENTS (sixth sitting)

**Governing law:** `OWNER-ADJUDICATION-R2-AND-R3-COMMISSION.md` (committed
`d3566d6f`); its text wins over this log. Jurisdiction as before: lane
documents/TSVs except `probes/` (parallel seat; R3-D and the witness/teeth
builds are theirs — this seat's tables drive them). Chair commits; this
seat committed nothing. Twelve locked acceptances guarded throughout.

## R3-A — the /0 schema made TOTAL and the predicate law made exact

- `CD0-INSPECTION-RECORD-SCHEMA.md`: **totality law** added (one complete
  encoding branch for every object each of the five predicates admits);
  **§5.1-T / §5.2-T** enumerate every admitted native refusal
  category/phase/code (S1's 20 rows; S2's 29 — including the two formerly
  unencodable classes, S2 `PROTOCOL-REFUSAL`/`EXPANSION` and S2
  `INTEGRITY-ALARM` objects, now encodable with `derived-standing`
  `("standing" "not-applicable")`); **derived-standing made total**
  (`not-applicable` for admitted provider-owned artifacts outside the
  Account pre/invoked partition; `pre-invocation` /
  `invoked-no-completion-account` retained only where actually derived,
  per code); **§7 rewritten to the full-exactness comparison law**
  (complete key identifier datum; exact namespace; exact path
  head/length/segments; exact schema identity+version; exact species;
  exact enum/standing/category/phase/disposition/code values against
  closed sets); **§8-T** specifies the conformance teeth (wrong namespace,
  wrong path head, extra path segment, wrong schema identity/version/
  species, unknown enum/code, and the two positive
  formerly-unencodable-class encodings) for the probe seat to build.
- **The composite refusal code fixed to exactly `head-not-in-manifest`**
  (schema §5.3; jurisdiction table 1) — the witness's R2
  `not-a-manifest-head` spelling superseded. Read together with the
  singular "the composite refusal code" and the R3-C tag lock, table 1 is
  consolidated: Door 1's ONLY refusal is `head-not-in-manifest`
  (`:request`); Door 2's is `wrong-request-species` (`:perform`); the R2
  composite rows `source-form-not-a-call` / `source-form-head-not-a-symbol`
  / `operation-not-declared` are withdrawn as composite codes (form-shape
  and operation validation are the delegate's, reaching the caller as
  provider-owned passthrough) **[SUPERSEDED — the R3.1 owner adjudication
  REJECTED this consolidation and RESTORED the four Door-1 codes; see the
  R3.1 section below; this entry stands only as the historical record of
  the flagged fork]**; the two inspector validation codes are
  condition signals only, never branch-5 records. Contract I.3 rewritten
  to match. *(Flagged in the report: the consolidation reads the ruling's
  singular "the composite refusal code"; if the owner meant only the
  spelling fix, the R2 multi-code table is restorable without touching
  anything else.)*
- **§8.6 / OWNER DISPOSITION OF THE R2 VOID stated honestly** in schema §8
  point 6 and `R4-SURVIVAL-PLAN.md` §4(h5): the four native-predicate
  non-admission measurements accepted for this round; the actual
  Account-predicate and typed-condition tooth moved into the mandatory
  production gate; no artifact claims the Account-side tooth passed.

## R3-B — the /1 identity law normalized

- Contract II.3: **"one image" defined** (one running Lisp image/process);
  **reload law REVERSED as ruled** *(and the R2 reload law recorded
  earlier in this log's R2 section is SUPERSEDED — historical quotation
  only, per R3.1-E)* — allocator state, epoch datum, and
  counter initialize once and SURVIVE package/source reload (the R2
  reload-reinitializes text withdrawn in place); new image = new state; no
  cross-image uniqueness. **One exact shared representation** given
  (epoch/entropy datum; canonical lowercase epoch-hex projection;
  namespace `("lisp-plus-surface-account")`; path
  `("performance" <epoch-hex> <counter-decimal>)`), with the
  same-constructor law for both witnesses and unsynchronized `INCF`
  confined to the labelled negative tooth. **The injective,
  domain-separated identity construction** specified (occurrence and
  account identity basis records with exact fixed keys and
  `("identity" "occurrence")` / `("identity" "account")` separators; the
  complete performance datum an injective component; injectivity argued
  from CD/0 canonical-encoding exactness) — every "folded into" phrase
  replaced (sweep clean; survivors are the disavowal and a never-clause).
  **The five ruled proofs listed verbatim** (including the new
  package-reload persistence proof) for the probe seat to build to.

## R3-C — refusal ownership and lifecycle residues closed

- Jurisdiction **table 3 rewritten**: every grouped phrase replaced by an
  exact named code with exact category, phase, owner, and derived
  standing (21 protocol rows + the /1 integrity-alarm families at
  `not-applicable`); /1 `wrong-request-species` and
  `incompatible-account-version` moved to **phase `:perform`** (Door-2
  rejection — lock 4), contract II.1b clause 3 aligned.
- **The four ownership rulings locked verbatim** in jurisdiction table 1's
  new lock block; contract I.3 rewritten (Door 1 does not prevalidate the
  occurrence tag — or operation or form-shape **[the operation/form-shape
  half of this parenthetical is SUPERSEDED by the R3.1 Door-1 restoration:
  Door 1 DOES validate form shape and operation membership; only the
  occurrence-tag half survives]**; the delegate validates and
  returns the exact provider-owned refusal).
- Contract II.5 retained-refusal schema: **every key always present**;
  absent occurrence tags / request identities carried by mandatory
  `("standing" "not-applicable")` datums, never conditional keys.
- **"/0 declarations move" deleted** (contract I.1 now: they never move;
  a successor introduces its own distinct declarations) and **"live
  declarations as current" deleted** from both docket cells (Candidates A
  and B: the pure inspector reports stored artifact facts only) — both
  sweeps clean.

## Custody precision corrections (folded, no special repair commit)

`R2-COMPLIANCE-CHECK.md` T2: "24 paths" → **25 paths (18M+7A)**, bracketed
attribution. `OPENING-BASE-AND-CUSTODY.md` §6.4 (new, attributed): the six
R3-ratified post-R1 commits with the ruling's no-standing/no-waiver limits,
and the four precision corrections recorded (push nuance — design branch
never pushed, one disclosed ledger commit `4b66c013` pushed; untracked
evidence proves same eight NAMES, not byte-identical contents; one
raw-clean status captured, per-run statuses absent — packer fixes forward;
25-path figure). Grep found no other lane doc carrying the old figures.

— Claude Fable 5 (JURIST, Surface Account /0 opening round, R3 sitting),
2026-08-04

---

# R3.1 AMENDMENTS (seventh sitting)

**Governing law:** `OWNER-ADJUDICATION-R3-AND-R3.1-COMMISSION.md` (committed
`d385dde5`); its text wins over this log. Jurisdiction as before: lane
documents/TSVs except `probes/` (parallel seat; R3.1-D and all witness/teeth
builds are theirs — this seat's tables drive them). Chair commits; this seat
committed nothing. Twelve locked acceptances verified intact at close.

## Owner disposition 1 — DOOR-1 OWNERSHIP RESTORED

The owner REJECTS R3's consolidation of every Door-1 failure into
`head-not-in-manifest` (this seat's R3 reading of the singular "the
composite refusal code" — flagged as a fork in the R3 log, now resolved by
the owner to the other branch; repaired without relitigation). Restored
consistently in: contract I.3 (Door 1 validates form shape, operation
membership, exact `EQ` manifest membership; ONLY occurrence-tag validation
is the delegate's); jurisdiction table 1 (the retainable set is exactly
five: `source-form-not-a-call`, `source-form-head-not-a-symbol`,
`head-not-in-manifest` — corrected spelling kept — `operation-not-declared`,
`wrong-request-species`; ownership locks re-affirmed); schema §5.3
(five-code closed set with per-code phases); `R3-COMPLIANCE-CHECK.md` A9
relabelled PARTIAL. Every claim that form-shape or operation validation
reaches a delegate through the composite is deleted (sweep clean; the R3
consolidation prose withdrawn in place).

## Owner disposition 2 — DETAIL TOTALITY

The two-stage total decision law written verbatim into the schema head
(species admission via the five predicates; projection → exact record OR
typed Account protocol refusal from field validation; no raw host or CD/0
condition escapes Account-owned validation), replacing R3's
one-stage-too-strong totality law. The closed detail union (scalar CD/0
string ≤1024 payload octets | `standing/measured-nil`) and the three exact
validation codes (`native-detail-not-string`,
`native-detail-not-cd0-scalar-string`, `detail-string-exceeds-ceiling` —
all protocol-refusal / `:request` / Account / `pre-invocation`, no record
produced; `NIL` encodes as `standing/measured-nil`) are in schema §2 and
jurisdiction table 1. Actual condition signalling stays a production tooth
(R4 §4(h5) family); R3.1 gets non-production validators only.

## R3.1-A — schema closed (spec side; probe seat builds)

S1 upstream union restated as exactly three members with the
no-other-standing law; §7 predicate law extended to ten clauses (adds:
manifest version exactly 1; detail union+ceiling; exact provider
`(code, category, phase)` TRIPLES — catalogue comparison as triples, never
code-name sets; exact derived standing per triple; exact
operation/disposition pairings). `MACROEXPANDED-TO-FIXPOINT` DELETED from
the S1 vocabulary (verified against `surface1.lisp:884–885`: exactly
`MACROEXPANDED-ONE-STEP` ← `:macroexpand-1`, `MACROEXPANDED-REPEATEDLY` ←
`:macroexpand`; S2 pairings verified at `surface2.lisp:272–273`). New §8-P:
both locked S1 STOP cells as POSITIVE records with their actual three
string-valued upstream fields, required to satisfy
`account-inspection-record-p`. §8-T reproduces the R3.1-A adversarial
teeth list verbatim (S1 STOP cells; S2 detail NIL / integer 42 / 1024 /
1025; non-CD/0 scalar; overlong composite detail; manifest version 2;
invented dispositions incl. the deleted FIXPOINT name; both wrong
pairings; every unlawful upstream standing; category/phase drift with
unchanged code name).

## R3.1-B — /1 identity law made exact (spec side; probe seat builds)

Contract II.3: the NORMATIVE identity definition (a CD/0 bytes datum
containing `canonical-octets` of the exact domain-separated identity basis
record; the unnamed "/1 identity projection" retired; **digest substitution
FORBIDDEN while the injectivity claim remains**); exact performance binding
(16 entropy octets; 32 lowercase hex; counter init 0, first allocation 1;
canonical unsigned decimal, no leading zero); the shape-predicate rejection
list (short/long epoch text, uppercase hex, zero, negative, leading-zero,
nondecimal); the synchronized once-per-image initialization law (concurrent
or re-entrant loading gathers exactly one epoch; the unlocked epoch
bookkeeping INCF replaced); linearizability restated conventionally (one
increasing total order respecting non-overlapping call order) with the
stronger, false completion-return-order claim DELETED; the
`ALLOCATOR-OBSERVATION` bare-INCF arm deletion recorded (probe side;
barrier tooth suffices).

## R3.1-C — future refusal and lifecycle law closed

Jurisdiction table 3: the four Account-owned integrity-alarm rows verbatim
(`manifest-key-collision` `:request`; `captured-manifest-binding-mismatch`
`:perform`; `delegated-artifact-species-mismatch` `:perform`;
`inspection-schema-projection-mismatch` `:request` — all `not-applicable`);
the /1 inspector's `not-an-admitted-account-object` row; the three
detail-validation rows; the R3 "families" closing sentence deleted. Door-2
precedence bound (recognized /0 request → `incompatible-account-version`;
everything else failing the exact /1 request predicate →
`wrong-request-species`; both `:perform`, Account-owned, `pre-invocation`)
with two future contract teeth specified for the probe seat
(t-precedence-1/-2). Table 2 headed with the verbatim standing
("provider-owned, Account-domain outcome, exact native object returned
unchanged — never Account-owned"). Movement ontology deleted from
`SURFACE-3-LIFECYCLE.md` (steps 3 and 4), `ARCHITECTURE-DOCKET.md`
(Candidate C cell), contract (I.1 "never move" already R3; the II.1b
withdrawal sentence rephrased off the ontology), `PROPOSED-API` comment,
and jurisdiction §3 note — sweep clean; sole survivor is the II.5b
disavowal quotation.

## R3.1-E — evidence claims corrected

`R3-COMPLIANCE-CHECK.md` rewritten under a prominent attributed R3.1
SUPERSESSION AUDIT banner: A1 → SUPERSEDED-DEFECTIVE; A9 → PARTIAL; B7 →
NOT SATISFIED; D2, D4 → PARTIAL; A2/A3 relabelled (the forbidden
"independently verified" withdrawn — same-family recount); B1 annotated
(retention held; the cited linearizability phrasing was the false claim).
LECTOR-3's original text preserved beneath the relabelled cells. The old
R2 reload paragraph marked explicitly SUPERSEDED where it survives as
historical quotation (`R2-COMPLIANCE-CHECK.md` D6; this log's R2 section
bullet). Census recomputation after the observation-arm removal is the
probe seat's (R3.1-E's numbers-from-final-files clause).

## Locked-acceptance guard (twelve)

Verified intact by sweep at close: seven-head union; five-species /0
domain + exclusions; exact native object preservation; the two S1 STOP
cells (now also positive schema records — encoding them does not reopen
them); five labels / 25 rows; VERIFY-RECEIPT provider-recomputation;
category-first-then-phase; immutable separately-addressed /0 and /1
inspectors; Candidate C benefits + non-adoption; the linearizable
allocator choice (retained; only its statement was corrected); the honest
deferral of the Account-side tooth; the verdict.

— Claude Fable 5 (JURIST, Surface Account /0 opening round, R3.1 sitting),
2026-08-04

---

# R3.2 AMENDMENTS (eighth sitting — bounded repair, document halves)

**Governing law:** `OWNER-RULING-R3.1-RETURN.md` (committed `fd7303be`);
custody accepted, technical closure returned on four defects — three with
document halves owned by this seat; the fourth (`GIT_NO_LAZY_FETCH=1` +
promisor specimen) and every implementation/hostile-tooth half are the
probe seat's. Chair commits; this seat committed nothing; locked
acceptances guarded.

## Repair 1 — detail schema reconciliation (schema totality RETURN)

`CD0-INSPECTION-RECORD-SCHEMA.md`: the branch tables now carry the exact
two-member union the ruled law defines — §5.1 `"detail"` cell (scalar CD/0
string ≤1024 payload octets | `("standing" "measured-nil")`); §5.2's
inheritance sentence names the union explicitly; §5.3 states the composite
branch's per-branch exactness (scalar string only — Account-authored, the
standing member unreachable, stated rather than silently narrowed); §7
clause 7 sharpened (either union member in a COMPLETE record satisfies the
predicate in the native branches; branch 5 string-only; 1024/1025
boundary); §8's NIL and 1024 arms upgraded per the return: each constructs
the COMPLETE fixed-schema record and proves predicate satisfaction — a
datum-level check alone is insufficient. Witness construction is the probe
seat's; these tables are what it builds against.

## Repair 2 — Door-1 precedence and ownership (refusal taxonomy RETURN)

(a) **The precedence law bound**: one fixed validation order, exactly one
refusal (the first failing check's code; validation stops):
`source-form-not-a-call` → `source-form-head-not-a-symbol` →
`head-not-in-manifest` → `operation-not-declared` — ruled on the merits as
the structural order (each later predicate well-defined only once the
earlier passes; the form-independent operation check last, so the refusal
names the deepest structural defect first). Written into contract I.3
clause 1 and jurisdiction table 1 (precedence column + law paragraph).
(b) **Ownership sweep**: four operative statements in jurisdiction §4's
keying prose called native `:request`/`:perform` refusals "account-owned"
— all four corrected to the ruled standing (account-domain outcome,
provider-owned, exact native object unchanged, never Account-owned); grep
shows no surviving operative instance (filed historical records retain
their text).

## Repair 3 — identity law (document half)

Contract II.3: the epoch entropy claim now matches what the probe seat
must implement — **exactly 16 octets of actual OS-random entropy, never
time/PID/address or derived padding** (the R3.1 witness's
eight-random-plus-padding construction rejected in the text; no padded
octet counts as entropy) — and law 2b is restated as the
**re-entrant-safe once-only initialization law**, operationally: exactly
one epoch under concurrent first-call and re-entrant load; no
partially-initialized state ever published (publication behind the
synchronization); no unsynchronized double-checked reads (a bare
read-check-then-lock fast path forbidden unless its safety is established,
not assumed). Implementation and hostile teeth are the probe seat's.

— Claude Fable 5 (JURIST, Surface Account /0 opening round, R3.2 sitting),
2026-08-05

---

# R3.3 AMENDMENTS (ninth sitting — surgical identity closure, document half)

**Governing law:** `OWNER-ADJUDICATION-R3.2-AND-R3.3-COMMISSION.md`
(committed `d25ace69`); every seam LOCKED except the two returns (once-only
initialization / true re-entry; canonical ASCII counter text). Fresh
worktree `surface-account-0-r33` from exact R3.2 tip `7b032616`. This
seat's entire jurisdiction: the identity portion (II.3) of
`SURFACE-ACCOUNT-0-CONTRACT-CANDIDATE.md` and this log — **exactly two
files**; probes/, the schema document, jurisdiction, and every locked file
untouched. Chair commits; this seat committed nothing.

## Amendment 1 — the once-only initialization law (R3.3-A)

Contract II.3 law 2b rewritten to the six-clause law (stable bootstrap
carrier / atomic state machine whose installation cannot be undone by any
delayed defining-form initializer; exactly one winner; private
construction + coherent publication with no observable mixture;
non-winners wait/retry and return only after observing the complete ready
state; no path gathers a second epoch / resets the counter / replaces
synchronization / republishes readiness; failure publishes neither
half-state nor false ready), with the owner's finding recorded in place
(CAS serializes CAS against CAS, not a delayed defining write against a
later CAS publication — the R3.2 DEFGLOBAL claim returned). **Rejected
repairs named:** DEFVAR-swap; second-check-around-vulnerable-cells;
DEFGLOBAL-then-CAS-with-more-commentary. The
one-coherent-state-object/one-publication-point preference carried. The
implementation choice is the probe seat's and the contract text **demands
its naming** with the exact SBCL version and the ordering argument —
"'atomic' is not an incense word; identify the place, the competing
writes, and the ordering relation" carried verbatim; the eight-thread arm
demoted to broad contention control, never proof.

## Amendment 2 — true re-entry defined; the mislabel corrected

New II.3 law 2c: a genuine re-entry is a same-thread recursive `LOAD` of
the identity source during the outer initialization, before ready
publication — no self-deadlock; no second state; owner re-entry may take
an explicitly documented probe-local deferred path but may not claim
ready; the outermost initialization owns the sole transition to ready; a
concurrent non-owner never takes the shortcut. **The R3.2 mislabel is
corrected in the contract:** the later top-level `(load …)` is a
SEQUENTIAL RELOAD (law 1's case), not re-entrant, and no statement in
this lane may call it that; the contract's identity portion swept — every
remaining "re-entry/re-entrant" instance is the operational definition
itself (probe-side prose is the probe seat's).

## Amendment 3 — canonical ASCII decimal (R3.3-C)

II.3 law 3's counter bullet now carries the ruling's normative sentence
verbatim (one or more ASCII characters from `0123456789`, first from
`123456789`; zero, signs, leading zeroes, non-ASCII digits, and every
other character excluded), with the owner's finding recorded
(`DIGIT-CHAR-P` admits U+0661/U+06F1/U+0967/U+FF11 on the parcel's
runtime). The predicate is **explicit ASCII membership**; rejected by
name as admission predicates: `DIGIT-CHAR-P`, Unicode numeric properties,
locale-sensitive classification, `PARSE-INTEGER`-as-admission; parsing
only after exact shape admission; every character restricted, not only
the first. **The epoch hex predicate is locked and untouched.**

## Confinement proof (for the packer)

`git diff --stat` at this seat's close: exactly one subject file changed
(`SURFACE-ACCOUNT-0-CONTRACT-CANDIDATE.md`, 3 hunks, all within the II.3
allocator-law block, lines ~561–660) plus this log. No non-identity
clause of the contract moved; no other lane file touched by this seat.

— Claude Fable 5 (JURIST, Surface Account /0 opening round, R3.3 sitting),
2026-08-05

## R3.3.1 — exceptional initialization closure (chair-recorded; probe seat's round)

Governing law: `OWNER-RULING-R3.3-RETURN-AND-R3.3.1.md` (filed `9f79df9a`).
Both returned defects repaired in `probes/` by the probe seat (FABER-8,
Claude Opus): **(1)** the post-election window is structurally empty — the
`UNWIND-PROTECT` is established before the election CAS, with the cleanup
flag armed before the compare and disarmed only by proof of loss, so no
instruction exists between election and protection; a condition anywhere in
the protected span publishes the definitive failure marker and wakes
waiters (terminal-image law, exercised). **(2)** election is total: CAS from
the exact observed plist to `(list* 'sa0-identity-cell candidate observed)`,
unrelated properties surviving by identity; termination argued (a defeated
compare implies the indicator writer ran; next read exits as observer);
arm (b) rejected on the merits as converting benign coexistence into denial
of service. Three new teeth sections (24 checks) replicate both returned
shapes on camera. VOLATILE hygiene: multi-thread gate logs and peer-image
PID/epoch lines marked at emission — an unobserved order is not sorted into
false determinism. `run-probe.sh` wiring edits disclosed (parser spelling +
three new child runs). Contract text unchanged this round: law 2b clause 6
already stated the obligation these repairs make true; no non-identity
clause moved anywhere. — Chair (Claude Fable 5), 2026-08-05.

## R3.3.2 — publication finality and carrier-slot closure (chair-recorded; probe seat's round)

Governing law: `OWNER-RULING-R3.3.1-RETURN-AND-R3.3.2.md` (filed `566e44dc`).
Both returned seams closed by the probe seat (FABER-9, Claude Opus):
**(1)** the state/failure pair collapsed into one DISPOSITION slot — the
cleanup's failure token installs by CAS-from-NIL into the very slot the
state publishes into, so state-present and failure-present are mutually
exclusive as a property of the place; the lagging local `published` flag is
deleted, not shadowed. **(2)** reserved-indicator presence is detected by a
counting plist walk that never consults a value; one adjudication law
serves reader and election alike (0 → elect; exactly one lawful cell →
observe; NIL/duplicate/malformed → immediate bounded error with one
greppable text — DEFINE-CONDITION avoided against the recorded concurrent
DEFSTRUCT layout scar, disclosed in-source). Two new roles
(INIT-PUBLICATION-FINALITY:11, INIT-CARRIER-SLOT:8) with replica
confessions of both returned shapes and disease-reintroduction teeth
(restoring either old law → named FAILs, exit 1). Two seat disclosures on
the record: phase-partitioned strictly-stronger predicates on two R3.3-era
gate checks (same IDs/positions/profiles), and the five-arm one-image
carrier-slot design with its zero-election argument printed. Census
483 IDs / 13 sections / 12 transcripts, derived. — Chair (Claude Fable 5),
2026-08-05.

## R3.3.3 — malformed-carrier totality closure (chair-recorded; probe seat's round)

Governing law: `OWNER-RULING-R3.3.2-RETURN-AND-R3.3.3.md` (filed `1a42b877`).
The walker is TOTAL: SA0-SCAN-RESERVED walks with an EQ-identity visited
hash-table under a five-way enumeration written into the source (lawful NIL
end; improper terminal tail; odd list; dotted value position; cycle), with
termination argued by pigeonhole over the finitely many reachable conses —
covering odd-period and rho-shaped cycles — and rejection that reads and
never writes. Three exact-source teeth (dotted; dotted-with-lawful-cell,
refused because totality outranks the fragment; circular under a hard
timeout converted to failure, thread JOINED not expired) plus replica
confessions of both revenants on captive symbols and a disease-
reintroduction comparator (5/7 FAIL, exit 1) whose own first run HUNG —
the readers met the malformed carrier under the returned law — a hazard
found and closed mid-round: they now run bounded and report :HUNG as a
distinct failing outcome. R3.3.2 lawful arms untouched (under the lane's own
VOLATILE-excluded comparison, nine transcripts plus the peer image are
identical to baseline and three differ only in an SBCL load-notice line
number; raw byte comparison differs additionally on VOLATILE lines, as it
does between any two runs). Census 490 IDs / 14 real sections / 13 transcripts, derived; the
probe seat also restored two R3.3.2 ID-family rows the README had never
gained. This entry supersedes the R3.3.2 row's census figures as current.
— Chair (Claude Fable 5), 2026-08-06.
