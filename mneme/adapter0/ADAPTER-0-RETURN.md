# ADAPTER-0-RETURN — the membrane candidate, phase 1

**Lane:** Adapter /0 — the first independently seeded Common Lisp
deterministic fake adapter under the adopted Adapter Protocol /0 reissue
(`LISP-PLUS-ADAPTER-PROTOCOL-0-SPEC.md`, adopted with riders,
`AP0-ADOPTION-2026-07-18.md`).
**Package:** `#:lisp-plus-adapter0` · **dir** `mneme/adapter0/` ·
**specimen** `de-membrana-loquente/`.
**Fence:** `ALLOWED-SOURCES.md`, commit `41df2330`, sealed BEFORE any
implementation code existed; **no Class B artifact was opened in this
phase** (`SEAL-RECORD.md`, `ADAPTER-0-PROVENANCE.md`).
**Builder:** CLAVIGER-IV (Claude Fable 5 subagent), 2026-07-30.

**Substrate statuses, at first mention and binding throughout:** Kernel
/0, Process Journal /0, and Adapter Protocol /0 are **adopted
specifications**; Canonical Datum /0 is the frozen datum layer; the CL
implementations `#:lisp-plus-journal0`, `#:lisp-plus-capability0/1/2`
are **candidates** (each at its own recorded standing); this lane is a
**candidate** and nothing more.  All substrate sources are byte-unchanged
by this lane (regression table in `SEAL-RECORD.md`; filtered
`git status` empty).

---

## 1. What is demonstrated (each with its check ids)

- **Registry-arbitrated vector conformance:** all 81 registered cases
  judged with counts derived live from `AP0-FIXTURE-REGISTRY.sexp` — 48
  positive accepted, 33 adversarial rejected **each with its declared
  condition** (the right law fires, not just any law) — vectors
  [V001]-[V084].
- **Rule-exact mutation kills (§24.2):** all 20 frozen rule-omission
  mutants killed two-sidedly — strict table rejects the target with its
  declared condition AND the table minus exactly the named rule accepts
  it — vectors [V085]-[V105].
- **Deterministic script machine (§19, AP-FAKE-1/2/3):** all ten frozen
  scripts execute cursor-driven; computed fold-derived terminals equal
  declared terminals; two-pass record-trail digests byte-identical,
  printed in the transcript — scripts [S001]-[S021].  The four crash
  windows and every terminal shape are produced (W1 unresolved-effect ·
  W2 present-partial · W3 captured-unprojected · W4
  projected-unconsumed) — scripts [S021], selftest [038].
- **Joint jurisdiction (§24.3):** structural AP0 validity and Kernel
  semantic validity reported as SEPARATE verdicts; the state-as-status
  fixture lands structural PASS + semantic FAIL under Kernel /0's own
  adopted `manifestation-status-p`; malformed and noncanonical bytes
  land structural FAIL with semantics not consulted; the adopted
  journal-side joint surface (`joint-structural-semantic-report`,
  K0E-26) exercised — joint [J001]-[J024].
- **L17 route audit (§25):** the lawful route is 4 public actions,
  matching every vector's declared `lawful-route-steps`; zero supported
  bypass routes; the audit emitted as a generated artifact
  (`L17-ROUTE-AUDIT-ARTIFACT.md`) — l17 [L001]-[L004].
- **The owner's fifteen non-equivalences held mechanically**, each with
  a check that fails if collapsed — selftest [018]-[034] (descriptor ≠
  live object · alias ≠ resolved identity · local ≠ idempotency ≠
  provider identity · prepared ≠ dispatched · dispatch ≠ acknowledgment
  ≠ execution ≠ manifestation · envelope ≠ projection · partial ≠
  nothing · cancel request ≠ settlement · usage ≠ cost · estimated ≠
  billed · not-found ≠ no-effect · testimony ≠ observation).
- **Permanent negative controls:** the 23 charged forbidden designs each
  presented and refused by the identified law, plus planted-fault and
  planted-truncation teeth seen to fire — controls [C001]-[C024];
  selftest [037], [039]; vectors [V106]-[V107].
- **The inhabited demonstration** (`de-membrana-loquente/`): one
  deterministic run in which the lawful operation reaches the membrane
  through the full authority route — /0 grant → AP0 pre-frontier account
  journaled → /1 mint + fresh presentation → /2 authorization → /2
  crossing and evidence-derived settlement → AP0 membrane evidence
  (dispatch, crossing-evidence binding, acknowledgment, envelope,
  world-evidence capture, derived projection, usage, typed missing-cost)
  → /2 fold standing `:settled` → a STRUCTURED outcome record, never a
  bare answer string — specimen [M001]-[M012], run twice byte-identical.
- **Determinism of the whole gate surface:** every suite transcript's
  second run is byte-identical to its first (digests in
  `SEAL-RECORD.md`).

## 2. Design adjudications (all resolved to spec text; recorded, challengeable)

1. **Case-validator conditions where the spec leaves the choice open.**
   Every adversarial fixture's declared condition was reproducible from
   an identified requirement; for UNFIXTURED negative branches the
   conditions chosen are: W2 fold mismatch → `partial-manifestation-erasure`,
   W3/W4 mismatch → `projection-failed`, stream terminal-claimed-complete
   → `stream-finality-conflict`, batching undeclared →
   `stream-durability-unknown` (rules.lisp comments cite each).
2. **AP-COST-1 string amounts.** The case grammar carries amounts as
   strings; the rule enforces EXACTNESS (integer/rational syntax; every
   float spelling refused).  String-level reducedness is NOT enforced:
   the frozen positive CST-01 carries the exact-but-unreduced
   `"1932912/1000000"`, and CD/0's constructor owns reduction of durable
   rational VALUES.  Recorded as the narrow reading.
3. **Projection-receipt enforcement site.** AP-PRJ-6's receipt
   obligation is enforced in the OPERATIONS layer (`project-envelope`
   always emits a receipt-bearing record; origin ≠ derived refuses); the
   case validator polices origin.  Reason: the frozen adversarial
   projection fixtures omit the receipt field while naming OTHER
   conditions, so a receipt-required case rule would misattribute their
   conditions and break the rule-exact mutation gate.
4. **Specimen ordering.** Capability /2's freshness law (CAP2-INV-1 /
   cap1's staleness law) binds receipts and keys to the EXACT prefix, so
   the AP0 pre-frontier account is journaled FIRST and the /2
   authorization is the LAST pre-frontier act.  AP0 §21's ordering is
   fully preserved (preparation records commit before any crossing).
   The first draft hit the staleness refusal live; the reorder is the
   lawful composition, not a workaround.
5. **One crossing, two jurisdictions.** In the specimen, Capability /2's
   door performs and settles the crossing; Adapter /0 journals membrane
   FACTS about that same crossing, with the AP0 dispatch record bound to
   the cap2 frontier event by an explicit journaled binding record.  The
   AP0 layer settles nothing (AP-ACK-4 honored structurally).
6. **Config/alias drift at dispatch → `implicit-provider-fallback`.**
   A resolved-configuration change between preparation and dispatch is
   refused as fallback (AP-ID-9: fallback ≠ continuation); descriptor
   version change is refused as `adapter-version-drift` (AP-DESC-3).
7. **Reuse, not twinning:** `reconciliation-insufficient` and
   `unsafe-retry` are Kernel /0's conditions, imported and re-exported;
   the PJ-S/0 codec and digests are journal0's; the status algebra is
   kernel0's.  No predecessor semantic was re-derived under a new name.

## 3. What this lane does NOT claim

- **The riders bind, verbatim** (`AP0-ADOPTION-2026-07-18.md`):
  1. *"CL gate (PJ0 precedent): no conformance claim beyond co-authored
     self-consistency, and no specimen reliance on live-provider claims,
     until an independently-seeded Common Lisp implementation passes the
     full AP0 vector set. Divergences adjudicate to spec text."*
  2. *"Stranger audit before independence language: the
     separately-recruited stranger audit … remains mandatory; no
     artifact may use the words 'independently verified/validated' of
     AP0 until a stranger's frozen report exists."*
- This lane's green run is, by its construction, an independently-SEEDED
  CL implementation passing the full vector set — but **whether that
  lifts rider 1 is the owner's adjudication, not this lane's to
  declare.**  Until that adjudication, every green here is labeled
  **self-consistency-plus-independent-seeding, pending owner ruling.**
- The stranger audit has **not** been commissioned; the words
  "independently verified" / "independently validated" are used of
  nothing here.
- **No live provider** was contacted, simulated as contacted, or relied
  on; no spending, no credentials, no network.
- The specimen is **NOT Vertical Specimen /0** and binds none of §30's
  successor obligations.
- **Full AP0 conformance (§23 class 6) is not claimed** — see
  `CONFORMANCE-MATRIX.md` for each class at its earned size.
- The independence claimed is of the DERIVATION (fence-sealed seeding);
  it is not a claim that any outside hand has checked this work.  The
  first outside eyes will be phase 2's/the chair's, and any stranger
  audit is future work under the owner's direction.
- The `ap0-script-nondeterministic` verdict label used on a
  determinism-gate failure is this lane's own naming (no §22 condition
  covers that suite-internal failure); it appears in no green path.

## 4. Where things live

| Artifact | Path |
|---|---|
| implementation | `package/conditions/data/descriptor/registry/script-machine/rules/operations/mutants.lisp` + `load.lisp` |
| gates | `adapter0-{selftest,vectors,scripts,joint,l17,controls}.lisp` |
| transcripts | `RUN-*.txt` (+ `-SECOND` for every determinism claim) |
| seal | `SEAL-RECORD.md` (digests of every transcript) |
| exit codes | `RUN-EXITCODES.txt` |
| route audit | `L17-ROUTE-AUDIT-ARTIFACT.md` (generated) |
| conformance | `CONFORMANCE-MATRIX.md` |
| provenance | `ADAPTER-0-PROVENANCE.md` |
| specimen | `de-membrana-loquente/` (own README, RETURN, PROVENANCE, artifacts + sha256 ledger) |

*— CLAVIGER-IV (Claude Fable 5), 2026-07-30*
