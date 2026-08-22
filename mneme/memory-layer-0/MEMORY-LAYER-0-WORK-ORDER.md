# MEMORY LAYER /0 — WORK ORDER (first slice)

*Chair: Claude Fable 5 (1M context), 2026-08-20. Committed BEFORE any implementation
code exists in this lane. Commission: Sol's relay, owner-relayed 2026-08-20
(`corpus/voices/received/2026-08-20-sol-relay-memory-layer-0-first-slice.md` — NORMATIVE;
this order binds the builder's semantic choices under it, it does not replace it).
Pre-code recon: INDAGATRIX-IV, `notes/2026-08-20-ml0-recon-indagatrix-iv.md` (repo-root
path; lab-internal, not part of the lane). Recon verdict: floor reproduced PASS 103/103
exit 0, subject tree byte-unchanged; all seven relay-§10 stop conditions DO NOT HOLD.*

---

## 0. Base state and standing (verify, then build)

- **Base commit: `e683cd0c14ccd1172d662eddb3ab61893071fe24`** (main). The recon opened at
  `61d440cf`; a harness Stop hook committed `tools/ledger/agents.jsonl` mid-run. The
  subject tree (`experiments/latent-lisp/`) is byte-identical at both. State both in the
  RETURN and say why they differ.
- Dependencies and standings (recon §6, quote-don't-soften): CD/0 ADOPTED · PJ0 **spec**
  ADOPTED / **impl** CANDIDATE · kernel0 impl CANDIDATE · Core /0 ACCEPTED-candidate ·
  capability /0 CANDIDATE, /1 and /2 ACCEPTED-candidate · One Act /0 **ADOPTED**
  (stranger audit WAIVED BY OWNER VARIANCE, not passed) · **One Act /1 CANDIDATE —
  registered on the floor, not adopted, not audited, not frozen; planted-death crash
  model only; capability-disciplined never capability-secure. THIS STANDING TRAVELS WITH
  EVERY DEPENDENCY CLAIM THIS LANE MAKES.**
- The one durable substrate is the PJ0 store, and its ceiling sentence is fixed
  (recon §7): *"canonical bytes are carried across a fresh process by an ADOPTED-spec,
  CANDIDATE-implementation journal store whose durability is a declared fsync-barrier
  host-contract belief on Linux ext4, demonstrated against a real SIGKILL at one governed
  progress point in a separate specimen — never power loss, never adversarial tampering,
  never a storage-stack proof."* Quote it; claim nothing beyond it.
- **This lane's own crash model: planted deterministic process death only** (orchestrated
  separate `sbcl --script` processes, One Act /1's F-10 environment discipline). No
  SIGKILL claim of this lane's own; `de-teste-occiso` owns SIGKILL at the store level and
  may be cited, never annexed.

## 1. The law (non-negotiable, from the relay §1)

```text
ISSUED(evidence, act)        ⇏ OCCURRED(act)
DURABLE(evidence)            ⇏ OCCURRED(act)
RETRIEVED(memory-account)    ⇏ CURRENT-IMAGE-EVIDENCE(memory-account)
RETRIEVED(memory-account)    ⇏ AUTHORIZED-TO-CONTINUE(act)
```

**RED disease in one sentence: evidence-present is treated as occurrence-present.**

Governing adopted law, by its OWN name (recon §8.4 — Sol's `Observation<State> ≠ State`
does not exist in the tree under that spelling; the lab's adopted form does):
**L15 — Witness separation** (`architecture/LISP-PLUS-LATENT-MACHINE-ARCHITECTURE-0.1.md:1553-1555`):
*"A process's unaided account of its own history is asserted testimony. Observational
standing requires a distinct, inspectable witnessing mechanism."* Its operational
ancestors, cited as governing precedent whose reasoning transfers (they are written for
the adapter/provider boundary — say which clause is carried across, do not claim they
bind this lane automatically): **AP-JRN-1** (self-written narrative remains asserted),
**AP-REC-1** (scoped nonoccurrence needs the four-part warrant: domain completeness +
authority over the identity + distinct inspectable witness + a record binding
witness-mechanism/evidence-identity/procedure-identity/origin/validation-standing),
**AP-CAN-6** (promotion from self-report = `adapter-truth-minting`, refused).

Adopted vocabulary that MUST be used instead of new coinages (recon §8.3):
- Retrieve is **evidence replay** (Architecture 0.1 **D6** replay triad) — never
  execution replay, never output reproduction.
- Consolidation obeys **D4** verbatim: *"cross-journal merges are receipt-bearing
  transformations, never timestamp sorts"* — torn tails visible evidence, never laundered.
- Authority: **D5/DK-3** — persist requirement + public authority identity + scope +
  minting receipt, **never the live capability**; a record that authority existed is not
  itself authority.
- The world/effect question reuses the adopted **external-effect axis** determinacies
  (`:determinate / :bounded / :indeterminate`) as a *scoped observation of* cap2's
  fold-derived standing — never the standing itself, never collapsed into the act outcome.
- Occurrence-standing and issuance-standing are **NOT covered by the four axes** — they
  are the two lane-local discriminants this lane mints, and the RETURN must flag them as
  the architecture gap they fill (relay §3: minimum discriminants, gap flagged, no silent
  architecture amendment).

## 2. Names, fixed by the chair

| Thing | Name |
|---|---|
| Lane home | `mneme/memory-layer-0/` |
| Package | `#:lisp-plus-memory-layer0`, symbol prefix `ml0-` |
| Loader package | `#:lisp-plus-memory-layer0-loader` (`ensure-ml0-lane`, `ml0-api-complete-p`, `ml0-api-shortfall`, `ml0-lane-files`) — COMPLETENESS-CHECKED class, readiness carrier = last form of last-loaded source (act1 pattern) |
| The semantic object | `memory-account` (`ml0-account` in symbols) |
| Specimen | `de-actu-memorato/` — *concerning the remembered act* |
| Condition root | `ml0-condition`; violations carry requirement ids `ML0-…`; refusals named by TYPE + REQUIREMENT-ID, never message text |
| Account store | the lane's OWN PJ0 store (one `create-journal`, own directory, declared durability) — separate from any act lane's store, so D7 corrupts only its own record and D1's source-unchanged check compares different files |

## 3. The semantic object — `memory-account`

One canonical, language-level, durable account of ONE act. All durable fields are CD/0
values (nine families only; no host condition, closure, pathname identity, current-image
token, or unprintable object). Durable frames ride the adopted TEN-FIELD envelope
(recon §5.6) with honest values: this lane's frames are the MEMORY LANE's self-report of
what it READ — **`origin` may NEVER be `origin/observed`** (One Act /0's own prohibition,
`act0-gates.lisp:114-119`, is this lane's law too). The cap0 origin ratchet's closed set
governs acquisition routes (`:live-query | :reconstructed`; `:observed` unmintable by any
reader; recon §5.7).

Independently answerable questions (relay §4), with fixed vocabularies:

1. **Which act?** — act identity re-derived WITHOUT performing, via One Act /1's public
   seam (`make-act1-record :register nil` / `mint-act1-identity`), compared byte-for-byte.
   Account identity: a NEW content-derived identity in an EXISTING kernel /0 domain
   (**`:claim`**), never host-derived (`make-identity`'s own law). Act identity, attempt
   identity, evidence coordinate, account identity, principal identity: five species,
   never conflated (recon §9).
2. **Occurrence standing** — `:occurred | :nonoccurred | :unresolved | :contradicted`.
   `:occurred` ONLY via the promotion rule (§4). `:nonoccurred` ONLY with the AP-REC-1-shaped
   four-part warrant, scope declared in the account (`:could-not-look` remains distinct
   from looked-and-absent). `:unresolved` is the lawful default and is never a defect.
   `:contradicted` may be emitted by consolidation only, and preserves both warrants.
3. **Issuance standing** — SEPARATE field, never folded into occurrence:
   `:issued | :not-issued-in-scope | :unresolved`. `:issued` only from
   `core0-evidence-current-image-issued-p` / `…-for-request-p` **in the issuing image at
   write time**, recorded as the writing process's testimony and discriminated as such.
   `:not-issued-in-scope` carries a declared scope (this lane's account store — a claim
   about the STORE, never about Core /0's registry). **Bare/global `not-issued` is
   unmintable.** In a fresh process `core0-evidence-current-image-issued-p` answers false
   for every input — a predicate that is false universally is not an absence warrant
   (the lab's absence-warrant class; recon §10.3). Retrieval NEVER upgrades or
   re-derives issuance standing.
4. **World/effect** — a scoped observation: cap2 fold standing as read + world-scope
   snapshot digests (act1's instrument), with the snapshot's declared universe and
   `:could-not-look` semantics intact. Observation of state, never state.
5. **Why may it say this?** — typed source provenance per source: source species (§4's
   closed set), acquisition route (ratchet), producer/recorder principal (recorder ≠
   subject, both fields), canonical source coordinate (store-id + ordinal/event-id +
   frame digest where the source is journal bytes; ledger key + line sha where it is a
   world row), declared observation scope, origin standing.
6. **How derived?** — `:direct-write | :consolidation`, with predecessor ACCOUNT
   identities retained verbatim. A consolidation output is a derived account whose own
   provenance names its inputs; it never rewrites what the inputs were.

## 4. The promotion rule — one explicit, executable conjunction

Model: `act1-reconciliation-closes-seat-p` (`act1.lisp:1327-1341`) — a conjunction over
multiple independent instruments, with a mutant kept alive to be killed — and
`act1-derive-class`'s discipline: computed **by reading durable bytes, never by reading
a condition's type name or a claim's own text**.

Source species table (grounded in AP-JRN-1/AP-REC-1/AP-CAN-6; recon §8.4):

| Species | May warrant | Forbidden to warrant |
|---|---|---|
| Kernel-mediated journal frames (cap2, `origin/observed`, read via public `derive-effect-standing` / `act1-journal-kinds` over the validated prefix) | occurrence (as one leg) | — |
| World bytes (public `world-ledger-lookup` via `external-request-key`, `world-cell-value`, world-scope digests) | occurrence (as one leg) | — |
| The reconciliation conjunction (`act1-reconciliation-closes-seat-p`-shaped joint reading) | occurrence | — |
| Lane self-reports (act0 F1–F5-style frames; ANY `origin/self-reported` narrative, including this lane's own accounts) | corroboration, provenance | **sole occurrence basis** |
| Core /0 evidence accounts, digests, receipts, reports describing them | issuance testimony (in the issuing image only) | **occurrence, in any direction, ever** |
| Scoped negative observation with the four-part warrant | nonoccurrence (scoped) | unscoped nonoccurrence |
| Reconstruction/validation success of durable account bytes | account integrity | origin upgrade, occurrence, issuance |

`:occurred` requires: admitted species + subject/act identity byte-match under
re-derivation + acquisition route + declared scope + frontier/sequence relation +
canonical payload + provenance, ALL satisfied — the rule inspects only facts that would
not become true merely because an evidence object was minted. The rule is ONE function,
public, and under mutant test.

## 5. Operations (relay §5 is normative; chair pins)

**A. Write** — typed source bundle → one durable account. Re-derive + compare act
identity first; refuse subject mismatch PRE-mutation; refuse (typed) any bundle whose
occurrence basis is bare evidence/digest/receipt/report — an issuance-only bundle is
either refused-as-occurrence-account or stored under the explicit issuance-only/
`:unresolved` discriminant (pick ONE behavior, make it public, typed, tested); append
through the lane's own PJ0 store; failed writes observably non-mutating over the whole
declared store (digest the store before/after on every refusal path); never performs,
never mints Core /0 evidence, never authorizes, never infers occurrence from a
successful serialization.

**B. Retrieve (evidence replay)** — runs in a genuinely fresh process; deterministic
validate + fold; preserves every standing/provenance/lineage field; returns a
`memory-account`, never evidence/capability/witness/world-state/continuation; performs
no act, makes no journal or world transition by reading (prove byte-unchanged);
refuses corruption/truncation/version/identity-inconsistency in the typed idiom with NO
plausible partial account; origin ratchet holds (validation success upgrades nothing).

**C. Consolidate** — deterministic, effect-free, over validated accounts. Stated
ordering + exact-duplicate rule; distinct provenance never deduplicated on matching
projected claims; predecessor identities + source provenance retained; issuance-only
never upgraded; `:occurred` only where a qualifying basis SURVIVES validation;
contradiction preserved explicitly (no last-write-wins); cross-act inputs refused before
output; **/0 never compacts, forgets, tombstones, GCs, or erases provenance** — source
records untouched.

## 6. Demonstrations (relay §6 normative; chair's D2 design binding)

Small specimen, not a platform: one seat, one effect kind, one deterministic fake world,
one writer process + one fresh reader process.

- **D1** — process A performs one bounded act through One Act /1's public seam, obtains
  a qualifying occurrence basis, writes the account, exits. Full declared universe +
  digests captured. Process B (fresh) retrieves: act identity byte-equal under
  re-derivation; occurrence warranted by the independent basis; issuance reported
  separately; no re-perform; world + effect ledger + source journal byte-unchanged
  across retrieval; no Core /0 evidence minted; no continuation lawful.
- **D2 — the crown negative, TWO ARMS (chair's design, resolving the recon's biggest
  risk; the fixture must NOT reintroduce the repaired production bug and must NOT add a
  public evidence constructor):**
  - **Arm (a) — same identity, species leg.** A LAWFULLY REFUSED act: Core /0's
    pre-frontier refusal issues a genuine `core0-evidence` account (evidence-so-far,
    refused outcome) for an act that did NOT occur — journal frames unmoved, world
    byte-unchanged, shown by the independent instruments. Present that genuinely-issued
    account to Write as though it warranted occurrence. The cured lane refuses-or-stores-
    as-issuance-only; after fresh-process retrieval AND after consolidation, **no public
    reader answers `:occurred`**. The `evidence-present ⇒ occurred` mutant must die on
    THIS arm — the species leg, with identities matching, so identity mismatch cannot
    mask the disease.
  - **Arm (b) — cross identity (fuses with D5).** Evidence genuinely issued for occurred
    act B presented in act A's bundle: refused PRE-mutation on identity. Same-shape
    control with all identities matching succeeds, so blanket refusal cannot pass.
- **D3** — the other direction: from `de-actu-memorato`'s own planted-death window
  (world applied + ledgered, process dead before language evidence survives — One Act
  /1's life-1 state), record **`:occurred` / issuance `:unresolved`** from the admitted
  independent basis. NOT `not-issued` — recon §10.3's qualification is binding: the
  registry leaves no durable footprint, so a fresh process cannot distinguish
  never-issued from issued-and-died. If any narrower lawful state supports
  `:not-issued-in-scope`, its scope is the account store, said in the account.
- **D4** — feed a retrieved account toward `continue-from` through the lawful public
  route: rejected as `unissued-evidence` — because a memory account is not current-image
  evidence, tested at the semantic boundary, no object-identity special case.
- **D5** — arm (b) above + matching-identity control.
- **D6** — consolidation rows, at least: issuance-only + issuance-only → never occurred;
  issuance-only + qualifying basis → occurred BECAUSE the basis is present and named;
  unresolved + scoped negative → nonoccurred(scoped) if supported; contradictory
  qualified observations → `:contradicted`, both preserved; same projected claim,
  distinct provenance → two records; cross-act → refused.
- **D7** — corrupt/truncate the LANE'S OWN store at controlled boundaries; typed failure,
  no account, no broadened durability claim.
- **D8** — full specimen twice from clean equivalent fixtures, semantic output
  byte-compared; all consumed-lane regressions (act0 173/0 + witnesses + disease, act1
  full gate set, capability2 29/0 + 27/0 + de-effectu-incerto 29/0, core0 29/0) re-run
  with direct exits; full release floor at the end: expect **PASS 103/103** (this lane is
  NOT registered — relay §11), checkout unchanged.

## 7. Teeth (relay §7; every tooth has a cured control AND a disease control)

Mutants, each one forbidden collapse: (1) issuance-implies-occurrence — dies on D2 arm
(a); (2) retrieve-reperforms; (3) retrieve-mints-or-promotes-to-current-image-evidence;
(4) consolidation-last-write-wins / contradiction erased; (5) provenance/scope dropped —
`:could-not-look` masquerading as absence; (6) origin upgrade on successful readback.
Preserve RED-before/GREEN-after for the central disease as committed artifacts. Exits
captured directly; the specimen prints enough of the declared universe that "no
transition" and "read did not perform" are measured.

## 8. Host-fault discipline (One Act /1's repair is the pattern — do not relearn it)

Enumerate admitted condition families BY ROOT, read out of each lane's own package:
`pj0-condition`, `kernel0-condition`, `cd0-failure`, `act1-condition`, `cap2-condition`
(only where actually driven). `ml0-condition` re-signaled unchanged first. Everything
else → typed `ml0-bridge-contract-violated` (requirement `ML0-BRIDGE-…`): no account, no
standing, no discriminant written. A two-halved CONTROL-3b-style gate: the unadmitted
fault refused AND a lawful refusal from an admitted family still classifies properly.

## 9. RETURN, parcel, exclusions

RETURN leads with relay §9's eight items, in order; claim ceiling verbatim: **candidate ·
not audited · not adopted · not frozen · not registered · same-family hands · planted-
death only · capability-disciplined never capability-secure · no independent
verification**. Every builder fork disclosed, narrowest option. Every encountered hole
outside this writ REPORTED, not patched (consumed-lane docket items included — recon
already reports: act0 stale header; verify-release.sh internal contradiction; act1
RETURN's API count 103 vs code's 104; RETURN §5 gap-6 superseded text). Candidate
archive: produced locally with SHA-256, NOT published, NOT transported, no mirror
touch — `SYNC-PAUSED` byte-untouched. Out of scope: everything relay §8 lists —
especially: no Core /0 / One Act /0 / adopted-lane edits; no adoption or freezing of One
Act /1; no recollect/search/forgetting/retention; no concurrency; no new crash or
security claims; no floor registration.

## 10. Stop conditions

Relay §10's seven, all re-checked by recon (DO NOT HOLD at base). If ANY becomes true
mid-build — most plausibly: the design turning out to require a public Core /0
evidence-content digest (route around it instead: caller-supplied projection digest,
discriminated as such, or issuance testimony with no coordinate) — STOP, return a
bounded finding, do not widen the writ. At a genuine hole, stop: no forged witness, no
report-called-certificate, no observation-called-state, no disk-survival-called-
occurrence.

---

*The desired result, verbatim from the commission: "The language can remember what its
account is entitled to say — and can durably remember that it is not entitled to say
more."*

— the chair, pre-code, 2026-08-20

---

## AMENDMENT 1 — 2026-08-20 (same day, mid-build): Sol's cold design read — one required correction + four audit conditions

*Appended, not substituted. Source: Sol's cold read of the docked design-calls parcel
(sha `8fe4099a…b993`, verified by the reader), owner-relayed, archived verbatim at
`corpus/voices/received/2026-08-20-sol-ml0-design-read-five-conditions.md`. Sol's
disposition: "The design is worthy and TABULARIUS should continue. No stop condition is
revived." These are PRE-RETURN semantic teeth — explicitly NOT authorization to reopen
architecture, edit consumed lanes, register the floor, or interrupt the sentinel.
Everything else in this order stands unchanged. Where this amendment conflicts with
§3–§6 above, the amendment governs.*

**A1.1 — Issuance-standing vocabulary CORRECTED (supersedes §3.3's set).** The account
store cannot establish "Core /0 evidence was not issued" — Core issuance lives in an
image-local registry the store never observes; **scope cannot confer observational
competence.** The issuance-standing axis is now exactly:
`:issued-in-writing-image` (provenanced testimony from the live issuance predicate in
that image, at write time) | `:unresolved`.
**`:not-issued-in-scope` is STRUCK from the axis.** If useful, the record-coverage fact
may be preserved as a SEPARATE observation (e.g. `:no-issuance-record-in-account-store`)
on its own field — never on the issuance-standing axis, never named `not-issued`.

**A1.2 — D2 arm (a) is a SINGLE-DELTA species test.** The lawfully-refused and
lawful-occurrence bundles must be structurally complete near-neighbours: same act
identity, binding, scope, provenance shape, and every non-species conjunct — ONLY the
proposed occurrence-basis species differs. The cured failure must name the
promotion/source-species requirement (not malformed input, not missing
provenance/scope, not identity mismatch). The mutant alters ONLY the forbidden
admission `Core evidence ⇒ occurrence basis`, and under it the row must wrongly reach
`:occurred` and turn RED. **Print or preserve which conjunct answered.**

**A1.3 — The `:occurred` proposition is PINNED.** `:occurred` warrants exactly: *the
governed protected effect associated with canonical act identity A crossed/applied and
is present in the declared journal/world universe under its derived external-request
identity.* It must NOT mean "`perform` was invoked" — a lawful refusal is itself an
execution event whose protected deed did not occur. Occurrence-standing is the later
reader's epistemic standing toward this precisely named proposition — not a fifth
outcome axis, not a duplicate of the execution axis. State this in the spec verbatim.

**A1.4 — D4's invariant outranks its predicted subtype.** §6's D4 predicted
`unissued-evidence`; Core /0 runs that check after basic type checking, so an earlier
lawful rejection of the wrong semantic/type species is lawful and perhaps sharper. D4
must PROVE: no continuation result, no ledger consultation, no receipt, no evidence
mint, no authority acquisition — and RECORD the actual earliest lawful refusal. Do not
wrap, counterfeit, or export anything to force the condition name.

**A1.5 — `:contradicted` requires COMMENSURABLE warrants.** Same act identity plus
opposite keywords is insufficient: `:contradicted` requires qualified warrants
addressing the SAME proposition over compatible/overlapping declared scope and
frontier/sequence interval. Non-comparable observations are preserved without
last-write-wins, but their combination is `:unresolved` or plural — not contradictory.

— the chair, entering Sol's conditions, 2026-08-20

---

## AMENDMENT 2 — §5.A failed-write contract: DISPOSITION B (Sol, 2026-08-21; entered before any R5 code change)

*Source: `corpus/voices/received/2026-08-21-sol-ml0-dispositions-r5.md`. The original §5.A text
above is preserved unedited; this amendment governs where it conflicts. The parked question that
led here (`notes/2026-08-21-ml0-failed-write-variance-question-for-sol.md`) is marked ANSWERED BY
SOL with this disposition appended, its text preserved.*

**§5.A, governing text (Sol, verbatim):**

> Every refusal raised before `append-event` is observably non-mutating over the whole declared
> store. Once `append-event` succeeds, a subsequent readback or identity refusal returns no
> account and neither retracts nor rewrites durable bytes. Any surviving bytes acquire no standing
> merely by surviving: they are judged only through Journal /0 validation and Memory Layer /0
> retrieval. Append success, serialization success, and evidence or certificate issuance are never
> evidence that the represented act occurred.

**Required structure:** before appending, encode the exact canonical event, run the exact account
decoder over it, and compare the resulting identity. A decoder or identity refusal must therefore
occur before mutation. The designed post-append refusal residue is host fault only. No rollback,
truncation, tombstones, or supersession. Journal /0 is neither reopened nor edited.

**Measures required:** whole-store byte and file-set equality on every pre-append refusal · planted
dry-decode and identity failures refusing before append · post-append host fault returning no
account and performing no retraction · subsequent fresh-process judgment coming only from validated
durable bytes · the genuine certificate for the unperformed act remaining `:unresolved` through
write, restart, retrieval, and consolidation.

## AMENDMENT 3 — cross-journal materialization: DISPOSITION A (Sol, 2026-08-21)

Same-store-only durable consolidation is accepted for Memory Layer /0. `ML0-MAT-3` stays: every
predecessor must be retrievable from the destination store. Effect-free consolidation across stores
may compute; /0 shall not materialize that result durably. **This does not amend Architecture 0.1
D4**: any future cross-journal merge remains a receipt-bearing transformation, never a timestamp
sort. **Memory Layer /1 is reserved** for receipt-bearing cross-journal materialization and the
standing of foreign warrants — charter recorded in `MEMORY-LAYER-1-RESERVED-CHARTER.md`; not built
in this pass. The parked question (`notes/2026-08-21-ml0-cross-journal-materialization-question-
for-sol.md`) is marked ANSWERED BY SOL, its text preserved.

**R5 ceilings, preserved by instruction:** D6 remains `PARTIAL`; demonstration D4 remains
`SHOWN-AS-AMENDED`; package privacy remains defense in depth; same-family execution does not
become independent audit.
