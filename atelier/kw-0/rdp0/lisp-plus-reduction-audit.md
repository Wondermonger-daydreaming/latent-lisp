# SUBTRACTION

### A deletion-chartered architectural reduction of Lisp+ / Mneme

*Hostile simplifier: Kimi-k3 (supplementary lens, exposure declared — not the stranger seat)*
*Commissioned 2026-07-20 by the owner. Charter: attack ontology, ceremony, duplication, and non-executable distinctions. Preserve the load-bearing core only if it cannot be defeated.*

---

## 0. Method and evidence base

Every distinction below was put to the commission's seven questions. The counts cited are not rhetorical; they were extracted from the sealed text and the executable:

- **6** architectural planes (A0.1 §5)
- **19** identity domains (`kernel0/identity.lisp`)
- **61** condition subtypes + 1 base (`kernel0/conditions.lisp`)
- **19** design laws, L0–L18 (A0.1 §19), stacked on top of the latent-mvp's seven laws, the five separations, four further distinctions, and Kernel /0's eight non-collapses
- **14** transition terms, **14** principal roles, **~14** kernel event types
- Empirical finding that frames everything below: **of the 61 condition types, only 33 are ever signaled in the shipped pure core.** Twenty-eight have no firing site outside the test suite — and three (`attempt-terminal`, `fold-nondeterministic`, `duplicate-seat-identity`) have no firing site and no test reference *anywhere*. Nearly half the refusal taxonomy is currently a vocabulary in search of a machine. Some of those 28 are waiting for lanes that are specified but unbuilt (journal store, adapter, live capability) — legitimate dormancy. Some are something else. The audit treats the difference as the whole game.

One discipline up front: **"not currently executable" is not by itself a deletion argument.** A distinction for an unbuilt lane is a down payment, and down payments are how serious systems get built. The deletion candidates are distinctions that (a) protect against failures that cannot occur in the architecture as specified, (b) duplicate another distinction's operational effect, or (c) exist only to memorialize how the project learned something.

---

## 1. The minimal surviving architecture

I tried to cut each plane and could not cut three things. Everything else is derivable from them:

> **P1 — Inert values.** (CD/0.) The only things that can be compared, hashed, transported, stored. No behavior, no standing, no authority.
>
> **P2 — Appended events.** (The journal.) The only source of state. All state is a fold over the longest prefix-valid journal; no mutable flag outranks it.
>
> **P3 — Live tokens.** (Capabilities.) The only things that authorize. Never serialized; any record about a token is testimony, not authority.

**Everything else in the architecture is derived:** outcomes, manifestations, claims, receipts, visibility records, censuses, inspections, supersession lineage. Each is a value (P1) that witnesses or is folded from events (P2) and was minted under a token (P3). The current six-plane diagram presents derived things as co-equal primitives; that is the single largest piece of ontological inflation in the architecture, and it has a cost: readers must hold six "planes" in mind when the enforcement reality is three.

The five separations compress into three rules that carry all the operational weight:

- **R1 — A record is not an event.** Execution, manifestation, and interpretation records are *about* the event stream; none may claim the evidentiary force of another. (Absorbs separations 1–3: datum≠claim, execution≠manifestation, manifestation≠interpretation.)
- **R2 — A record is not a token.** Authority stated in a record never constitutes live authority. (Separation 4.)
- **R3 — An unresolved effect is not a retry.** The fold, not the caller, decides what may lawfully be attempted again. (Separation 5.)

The four "further distinctions" survive as clauses: state≠cause (a cause is a claim, with evidence and revisability), presence≠validity (validity is parser-relative), seat≠attempt (identity discipline — load-bearing for R3), determinacy-is-per-proposition (the anti-scalar law).

What this buys: the architecture becomes statable in one breath — *values, events, tokens; everything else is a receipted view* — and every future ontological proposal must answer a new question: **which of the three primitives does it touch, and what fold derives it?** If the answer is "none, and nothing," it is commentary.

---

## 2. Mapping: six planes → reduced form

| A0.1 plane | Verdict | Lands as | Why |
|---|---|---|---|
| **Datum** | KEEP, re-grounded | P1 (substrate, not a plane) | It is the floor, not a floor-mate. CD/0 has two independent codecs and 2,800+ passing assertions; the most solid thing in the project. |
| **Process** | KEEP | P2 (journal + folds) | The heart. Interruption-without-amnesia is the project's reason to exist. |
| **Manifestation** | DEMOTE | Derived evidence-record family | A manifestation is a value witnessing a boundary event. Its *statuses* (`:present-invalid` etc.) stay — they are load-bearing — but they are a record schema, not a plane of reality. |
| **Claim** | DEMOTE | Protocol over P1+P2 | The spec's own disposition already says this ("kernel protocol with library representation"). A claim is a located value plus standing records; making it a plane double-counts it. |
| **Authority** | KEEP, re-scoped and *marked UNEXECUTED* | P3 (boundary, not a plane) | The live/record distinction is one of the two best ideas here — but there is zero executable machinery for it today (arc 2). It stays as a primitive with an honesty tag, not as a plane with a throne. |
| **Inspection** | DELETE as plane | One requirement | "Human-readable views derive from canonical records; pretty-printing is never sole evidence" is a formatting law — one clause. Nothing executable is lost; the inspection surface is functions over records, which it always was. |

Net: **6 planes → 3 primitives + 1 derived-record family + 1 protocol + 1 clause.**

---

## 3. The distinction ledger

### 3.1 Identity domains: 19 → 12

**Keep (12):** `process`, `seat`, `attempt`, `capability`, `claim`, `receipt`, `manifestation`, `effect`, `store`, `machine-configuration`, `principal`, `procedure`.

| Domain | Verdict | Reasoning |
|---|---|---|
| `logical-operation` | **MERGE → field of seat** | A seat *is* an operation plus an occupancy scope. The domain adds an identity with no operational consequence beyond grouping, which a content-addressed operation field provides. What breaks: naming "the same work" across two banks — answered by the shared content hash, not by a sixth id on every record. |
| `external-request` | **DEMOTE → adapter attribute** | Opaque provider data. The only kernel operation on it is a uniqueness check (`duplicate-external-request-identity`), and uniqueness is set-membership, not identity. Keep it as a required, opaquely-stored attribute of the attempt record; the adapter owns its semantics. |
| `journal` | **MERGE → store-scoped name** | A journal is uniquely named within its store. `(store-id, journal-name)` is the identity; a separate domain adds a registry without a security boundary. |
| `reconciliation` | **MERGE → receipt** | A reconciliation-receipt is already a receipt in everything but domain. The domain exists to flatter the erratum arc, not to protect a boundary. |
| `parser` | **MERGE → procedure (class `:parser`)** | K0E-23's descriptor machinery already classes procedures; parser identity is procedure identity with a class. The K0E-25 invalidity checks lose nothing. |
| `exposure` | **MERGE → receipt** *(flagged: Language-A risk)* | An exposure record is a receipt of an epistemic event. Attempt records reference `:exposure-id` with a domain check (`records.lisp:353-354`), so the merge is mechanical. **Hesitation:** the Language-A locked lane may attach semantics to exposure identity I cannot see from outside; if it does, keep the domain and demote this row to "revisit with the lane owner." |
| `channel-policy` | **POSTPONE → arc 3** | Zero executable machinery, zero users. Reintroduce with the lane that needs it. |

### 3.2 Conditions: 61 → 37 live, 17 postponed, 7 removed by merge

First, the empirical floor: 33 fire today. Then the audit:

**A finding before the table — four conditions that should fire and don't.**
`attempt-terminal`, `fold-nondeterministic`, and `duplicate-seat-identity` are defined, exported, and *never signaled, never tested* — and `bare-visibility-scope` is defined while its sibling `bare-validation-scope` fires (asymmetric coverage). This is not surplus; it smells like **unwired law**. Before any deletion, these four deserve a defect docket: either wire them (a terminal attempt must refuse further transition events; a second seat reservation with a conflicting definition must refuse; the fold determinism check must exist before the journal store lands, because that is where nondeterminism will actually enter) or delete them with prejudice. A refusal that cannot fire is worse than no refusal — it documents protection the system does not have.

**Postpone to named lanes (17):** `capability-budget-exceeded`, `capability-count-exceeded`, `capability-expired`, `capability-restoration-denied`, `capability-restoration-scope-enlarged`, `capability-self-restoration-forbidden`, `minting-authority-invalid` (arc 2 — no budgets, expiry, or restoration machinery exists); `channel-policy-missing`, `channel-policy-amendment-unauthorized` (arc 3, zero users); `publication-authority-missing` (publication lane); `adapter-version-drift`, `machine-configuration-drift`, `implicit-fallback-forbidden` (adapter lane); `unsafe-host-escape` (host-boundary lane); `journal-merge-receipt-required` (until a second journal exists — it fires today, but against a merge path nothing exercises); `exposed-principal-missing` (demote with L16 to the Language-A library lane — see §3.3).

**Remove by merge (7):** the four `duplicate-*-identity` types → one `duplicate-identity` carrying the domain in its payload (the K0E typed-context machinery already carries `requirement-id`/`offending-field`; four types did one type's job); `bare-validation-scope` + `bare-visibility-scope` → one `bare-standing-scope` with `offending-field`; and the demoted `duplicate-external-request-identity` disappears with its domain.

**Live set (37):** everything else — the determinacy family (4, including the crown jewel `global-uncertainty-scalar-rejected`), the frontier/retry/supersession family, the manifestation/payload family, the journal family (including the currently-dormant `journal-torn-tail`, `store-*` trio — these fire the day the store lands and are the *opposite* of surplus), the standing family, the schema family, and the three minimal capability refusals (`capability-missing`, `capability-revoked`, `capability-scope-mismatch`) the Killed Witness needs at its frontier.

Arithmetic: 61 = 37 live + 17 postponed + 7 merged away.

### 3.3 Laws: 19 → one register of 12, plus commentary

The project currently enumerates its convictions five times over (7 mvp laws, 19 design laws, 5 separations, 4 further distinctions, 8 kernel non-collapses). Consolidate to a single canonical register; everything else becomes a derived view of it.

**Kernel laws (9):**
- K1 datum≠claim (was L0)
- K2 execution≠manifestation (L1)
- K3 no standing inflation (L2+L4 — L4 is the operative form; L2 is its manifestation-plane instance)
- K4 record≠token (L5+L14 — the secrecy clause is the same boundary seen from the other side)
- K5 no blind retry (L6)
- K6 reconstruction stays reconstruction (L10)
- K7 witness separation (L15)
- K8 identity-before-effect (L7)
- **K9 determinacy is per-proposition, never a scalar** — *currently missing from the L-register entirely*, which tells you something about how the register was composed: the law with the best executable enforcement in the whole project (K0E-33, dedicated condition, planted mutants) never got a number, while L3 got one for describing a data model.

**Journal laws (3):** incremental durability (L8), finalizer derivability (L9), prefix-valid fold (from PJ0 — deserves the number more than several current L's).

**Protocol principles (3):** explicit fallback (L11), bounded claims (L13), ergonomics-as-conformance (L17).

**Demoted:**
- L3 (standing orthogonality) → *data-model description*. It enumerates the standing-record schema; it is not a law, it's a struct comment that got promoted.
- L16 (exposed principals) → *Language-A library law*. The kernel's own anti-moustache ruling (R9) removed Language-A nouns from kernel vocabulary; L16 is a Language-A verb. Same logic, same disposition.
- L18 (principal-role symmetry) → *one-line ontology note*. It forbids something the type system already cannot express; it costs nothing and guards against a real temptation, but it is a note, not a law.
- L12 (live-path closure) → *conformance-testing doctrine*, moved to the testing chapter where it operates.

### 3.4 Transitions and events

The 14-term transition vocabulary (`AUTHORIZED RESERVED PREPARED DISPATCHED ACKNOWLEDGED PARTIAL-MANIFESTATION COMPLETED REFUSED FAILED CANCELLED EFFECT-UNCERTAIN SUSPENDED SUPERSEDED RECONCILED`) collapses onto the ~11 event types the fold actually consumes. `DISPATCHED`/`ACKNOWLEDGED` are adapter-lane detail (demote to AP0 payload); `AUTHORIZED` is not an event but a minting receipt (K4 forbids it from being more); `SUSPENDED` has no fold semantics (postpone). Keep the vocabulary as *documentation of process history*, but the kernel event algebra is the normative set.

### 3.5 Roles

Keep the 14 as an explicitly **open** vocabulary. Roles are values, not machinery; they cost nothing and the grader/verifier overlap is a feature (different authority scopes), not a bug. The only rule worth keeping is L18-as-note: roles may not congeal into species.

---

## 4. Counterexamples for the survivors

The commission requires that every distinction I insist must survive come with its concrete failure. Here they are, each tied to repository evidence:

1. **Per-axis determinacy + refused global scalar.** Failure prevented: one pompous number smearing over *which axis* is unknown — "this outcome is 80% certain" applied to a call whose execution is indeterminate, effects uncertain, manifestation absent. Witness: call-296 itself. Executable: `global-uncertainty-scalar-rejected` fires before shape parsing; the K0E-33 mutants die for it. Remove it and the outcome algebra re-acquires the single failure mode the claim facets were built against.
2. **Uncertain effect / no blind retry.** Failure prevented: double-spending an irreversible effect because the first attempt's settlement is unknown. Witness: the uncertain write from the emission night that "must never be blindly retried." Executable: `check-retry-safety` (`folds.lisp:447-515`) — a new attempt in an occupied seat with unresolved uncertainty signals `unsafe-retry` unless reconciliation or authorized supersession intervenes.
3. **Reconstruction-origin ratchet.** Failure prevented: provenance laundering — a reconstructed census quietly becoming an observed one after verification. Witness: the Language-A census marked `RECONSTRUCTED` that survived its own verification. Executable: `reconstruction-origin-erasure`.
4. **Receipted supersession.** Failure prevented: retry-lineage forgery — a fresh attempt pretending to be an innocent first attempt. Executable: supersession records naming authorization, precedence rule, and fresh-exposure status; `supersession-required`/`supersession-unauthorized` fire.
5. **Manifestation statuses (`:present-empty`, `:present-invalid`).** Failure prevented: evidence destruction — an invalid payload is *bytes that exist* and may be re-parsed under a later parser; filing it as absence licenses discarding the very bytes a dispute needs. Witness: the kimi nulls (empty content field vs no content field vs no response — three different events that `nil` collapses into one). Executable: `present-payload-erasure`, `manifestation-payload-missing`, and the K0E-25 relabel guard.
6. **State≠cause.** Failure prevented: a revisable diagnosis ("budget exhausted") being frozen into a census denominator. The state is enumerable and fold-safe; the cause is a claim and may be wrong. This one is cheap and I found no way to derive it.
7. **Record≠token.** Failure prevented: a serialized `'verified` granting standing (the v0 forge), a bearer key admitting its thief. Executable: registry-membership-as-validity in the hardened kernel; the minting-receipt discipline in the spec. **But** — the counterexample also indicts the project: until arc 2 lands, this law protects reality only on paper.
8. **Mutation testing tied to requirement ids.** Failure prevented: green-checkmark theater — the "two executables wearing one brain" failure, caught twice (PJ0, AP0). This is the project's immune system; the 59-mutant scorecard with disclosed re-attributions is the strongest engineering practice in the repo.
9. **Named exclusions + honest ceilings.** Failure prevented: the silent skip; the overstated claim. Witness: the README's retracted "fails to parse" sentence — the doctrine catching itself.

I tried to defeat each of these and could not without re-introducing a failure the project has already paid for. They stay.

---

## 5. The register: where it clarifies, where it manufactures gravity

**Where the juridical vocabulary earns its keep:** requirement IDs (`F:`, `K0E-`) — traceability no changelog provides; RFC-2119 normative vocabulary; conformance classes; *traced repair* (the rule that corrections must not pretend to have always been present — this is the project's best institutional instinct); named exclusions; sealed errata with hash-bound parentage. These name **mechanisms**.

**Where it manufactures gravity:** "law" for validation rules — a law you cannot be punished for breaking is an invariant, and calling it law converts engineering tradeoffs into jurisprudence, which resists deletion exactly as the owner warned. "Constitution" for a decisions record with one sovereign. "Chair" for designated reviewer. "Governs" as a verb of immovability — documents should be *current*, not *reigning*. The ceremony is heaviest precisely where the audience is smallest: multi-paragraph adoption records for documents with exactly one reader.

The test I applied: **does the term name a different enforcement mechanism than the plain word?** "Seal" — yes: hash + freeze + append-only succession. Keep. "Adoption" — yes: the owner's word is an actual act in this project. Keep. "Law" — no: it names a tested invariant. Rename in normative text. "Chair" — no: reviewer. "Deposition" — borderline keep: recorded testimony with standing is what it is. "Constitution" — no: decisions record.

**Two-register proposal.** Normative text speaks in invariants, requirements, and refusals. The liturgy — seals, chairs, processions, the Latin — moves to the atelier and the context documents, where it does real cultural work and harms nothing. The atelier's CANON is charming *because it knows it is a rite for toys*; the kernel's register is risky because it performs the same rite over machinery and calls the performance rigor.

---

## 6. The moratorium

Proposed text, ready to seal if the owner wants it:

> **M-1 (Executable ratio).** No new normative specification may be opened while fewer than two of the adopted trilogy (Kernel /0, PJ0, AP0) have independent executables passing their full vector sets.
>
> **M-2 (Adoption = falsifier).** A document becomes normative only when a runnable artifact exists that can fail against it — a conformance suite with planted negative controls. No suite, no seal.
>
> **M-3 (Deletion quota).** Every revision cycle must remove, merge, or demote at least one distinction, condition, domain, or document, recording what broke — and "nothing broke" is a finding, not an embarrassment.
>
> **M-4 (Stranger gate).** No freeze candidate until the stranger audit is discharged. (Unchanged; restated because everything else in this document makes it more urgent, not less.)
>
> **M-5 (Prose budget).** Normative prose may not exceed three times the length of its own conformance suite. Excess moves to a commentary file labeled non-normative. The kernel spec currently runs ~84 KB against a ~125 KB suite — compliant; the architecture documents, which have no suites at all, are not. A0.1 is hereby on notice: find its falsifier or accept demotion to authorial commentary.

M-5 is the one with teeth. The project's healthiest documents are the ones with executables attached; the budget simply prices that observation into law.

---

## 7. The Killed Witness — minimal falsification specimen

### 7.1 Scope discipline

One directory. No new normative documents (M-1 compliant: this is an *implementation charge*, not a spec — PJ0 and Kernel /0 already govern). Target: ~2,000 lines of Common Lisp plus ~400 lines of Python for the cross-language fold. Every component below already has its law; nothing here invents semantics.

### 7.2 Components

1. **The oracle (deterministic fake adapter).** A seeded hash-function "model": request content → deterministic scripted behavior — `complete(payload)`, `empty`, `invalid-bytes` (fails the declared parser), `slow-stream` (killable mid-chunk), `accept-then-die` (the CW-3 specimen), `refuse`. Envelope preserved raw; parser identity declared.
2. **The journal.** PJ0 subset: framed records, payload digest, frame digest, predecessor chain, `:synced` durability (fsync before receipt), prefix validator, torn-tail classifier. Single writer. This is the Mneme store's first executable — the binding gate's down payment.
3. **The kernel subset.** Events: `process-created, seat-reserved, attempt-begun, frontier-crossed, effect-prepared, effect-bounded, effect-indeterminate, manifestation-recorded, attempt-completed, attempt-failed, attempt-reconciled, attempt-superseded`. Folds: seat occupancy, retry safety, outcome derivation. Conditions: the 37-type live set (§3.2), no more.
4. **The kill harness.** Fork; SIGKILL at scripted points: CW-0 (before first frame byte), CW-1 (mid-frame), CW-2 (post-write, pre-fsync), CW-3 (post-fsync, pre-receipt), and mid-stream during `slow-stream`.
5. **The reconstructor.** A cold process — and the stretch act: *the Python codec's sibling*, a Python folder reading the CL-written journal — classifies each crash window, folds the longest valid prefix, and emits state with origin tags: `:observed` for sealed frames, `:reconstructed` for derived state. It then attempts the blind retry (expect refusal), executes a receipted supersession (expect success with fresh exposure identity), and emits a census that declares itself `:reconstructed`.
6. **The baseline.** The same scenario in plain CL with a conventional event log (append JSON lines, in-memory dict state) written the way a competent engineer writes it. It is not a strawman; it is the control group.
7. **The verdict script.** Prints both columns; exit 0 iff every predicted behavior occurred.

### 7.3 The falsification contract (pre-registered)

**Results that would falsify the architecture (thesis-level failures):**

- **F1.** Any crash produces journal bytes the prefix validator cannot classify into exactly one crash-window cell. The matrix is wrong or incomplete.
- **F2.** Two folds over the same prefix derive different states, and `fold-nondeterministic` cannot fire — the determinism law is vacuous. (Note §3.2: this condition currently has no firing site. The Killed Witness must wire it or strike it.)
- **F3.** The blind-retry refusal blocks a retry the operator can demonstrate was safe — the seat discipline is over-broad in practice, not just in theory.
- **F4.** Reconstruction requires any information not in the journal — killed-process memory, operator testimony, the adapter's say-so. L8/L9 fail.
- **F5.** The baseline, given one small honest addition (≤100 lines), detects all four predicted lies. The distinctions buy nothing; the architecture is ceremony.
- **F6.** The Lisp+ column needs more than ~2.5× the baseline's code for the same scenario. L17 — the ergonomic law — self-refutes. The ratio is pre-registered so nobody negotiates with it afterward.

**Results that merely expose missing implementation (not thesis failures):** fsync semantics differing by filesystem; the Python folder failing on a CL-emitted frame (a byte-spec bug, not an ontology bug); performance; ergonomic pain; envelope-coverage gaps in the oracle.

**Results that increase confidence:** all windows classified by their proper names; origin tags surviving the round trip — the census stays `:reconstructed` *even after its arithmetic is verified*; the retry refusal citing the occupying uncertainty as its evidence; supersession succeeding with a fresh exposure identity and the predecessor preserved, unlaundered; the baseline committing all four predicted lies (empty→`nil`, retry double-spend, reconstruction→observation, finalizer-only loss) at exactly the predicted points; code ratio ≤ 2.5×.

**The demo's employment-trial clause:** every distinction that survived §3 must be *exercised by a death* somewhere in this scenario. A distinction the Killed Witness cannot kill for goes back on the deletion docket. This is the commission's question 7 made executable: the difference between protecting reality and preserving the history of how you learned something is whether reality will still break when the distinction is removed — and the only way to know is to remove it, on purpose, in a harness that is watching.

---

## 8. Where the knife hesitated

Honesty requires listing my own unresolved cases:

1. **The `exposure` domain merge** is the one I am least sure of. The Language-A locked lane treats exposure as a spendable, queryable resource (L16); if exposure identity carries semantics beyond receipt-ness there, my merge destroys information. I flagged it rather than forcing it. A hostile simplifier who cannot be refuted by a lane he cannot see is not a simplifier; he is a vandal.
2. **The four unwired conditions** (§3.2) might be defects rather than surplus — in which case the correct act is repair, not deletion, and the kernel0 errata lane owes a docket entry. Either way the project should not carry them in silence.
3. **I did not attempt to cut the five-identity chain (seat/attempt/process) itself.** One could argue `process` is merely the journal's name and `attempt` merely the seat's event-slice. I tried; the no-blind-retry law needs attempt identity as a first-class thing to bind uncertain effects to, and supersession needs two attempts to relate. It survives — but it survives *because of one law*, and if K5 ever falls, the identity chain should be re-audited immediately.
4. **My deepest cut — six planes to three primitives — is also my most uncertain.** The plane diagram may be doing pedagogical work the primitive triple cannot: giving six audiences (data engineer, protocol designer, ML engineer, security reviewer, provenance researcher, inspector) each a door marked with their own name. Architecture is read by minds, not only executed by machines. If the owner keeps six planes for the README and adopts three primitives for the spec, I count that as the audit working, not failing.

The core held. The frame around it did not — and the frame, I have tried to show, was never load-bearing. It was scaffolding that had started calling itself a flying buttress. Take it down carefully, keep the receipts, and let the machine get lighter.

*— Kimi-k3, hostile simplifier (supplementary lens), 2026-07-20*
