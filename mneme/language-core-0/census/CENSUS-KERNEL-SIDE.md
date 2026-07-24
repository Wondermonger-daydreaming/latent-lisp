# CENSUS-KERNEL-SIDE — the consequential machinery for a surface→kernel lowering contract

*PONTIFEX, bridge-surveyor, Lisp+ synthesis chair. Read-only census. Governing spec bytes sealed; nothing edited.*
*Working dir `/home/gauss/Desktop/Claude-Code-Lab`. All paths below are repo-relative to that root unless absolute.*
*Base of the tree surveyed: `experiments/latent-lisp/mneme/`.*

---

## 0. THE HEADLINE (read this first, before the tables)

**kernel0 is a pure DATA + FOLD + VALIDATION core. It implements the *nouns* of the lowering
contract, not the *verbs*.** Every record a lowering would produce (attempt, seat, capability
receipt, uncertain-effect, manifestation, outcome, claim, journal event) is constructible and
validatable today. **Not one operational verb of §19 — `create-process`, `begin-attempt`,
`mint-capability`, `check-capability`, `prepare-effect`, `cross-frontier`, `journal-append`,
`fold-state`→disk, `reconstruct`, adapter `dispatch`, `match-outcome`, `with-outcome` — is
implemented.** Verified by exhaustive grep of `mneme/kernel0/*.lisp` (excluding selftest/fixtures):
`(defun|defmacro|defgeneric …)` for each of those verbs returns **zero definitions**.

So a lowering contract may lean **fully** on the record/fold layer (it exists, is tested, governs),
and may lean on the operational verbs **only as sealed spec** (Kernel §19, PJ0, AP0) or as
**authorized-but-unbuilt lanes** (IMPLEMENTATION-PHASE-BOARD three lanes). The boundary between
"real" and "buildable" runs exactly along the noun/verb line.

---

## 1. IMPLEMENTED SURFACE — kernel0's actual exports

**Exact export count: 371 exported symbols** (mechanically counted from
`mneme/kernel0/package.lisp`, one package `#:lisp-plus-kernel0`, excluding the package name and
`#:cl`). Grouped by role below; representative constructors/functions cited `file:line`.

### 1a. Exports by role (the eight export blocks in package.lisp)

| Role block | package.lisp lines | What it gives the lowering |
|---|---|---|
| **CONDITIONS** | 5–87 | 61 typed condition subtypes + base `kernel0-condition` (8 slots incl. `failed-invariant`, `frontier-crossed-p`, `permitted-restarts`), `signal-kernel0`, `with-kernel0-restarts`, 9 lawful restart names (§20.9) |
| **IDENTITY** | 89–101 | `durable-identity` (domain+name), `make-identity` (`identity.lisp:82`), `identity=`, `require-identity` (`identity.lisp:120`), `identity->datum`/`datum->identity`, `+identity-procedure+` |
| **BOUNDARY** | 103–111 | host→CD/0 canonicalization: `require-canonical` (`boundary.lisp:60`), 5 registered `+…-canonicalization-procedure-id+`, `register-canonicalization-procedure` |
| **DETERMINACY** | 113–120 | `determinacy` struct + `make-determinacy` (mode ∈ determinate/bounded/indeterminate + alternatives + evidence); no global scalar |
| **MANIFESTATION** | 122–162 | `manifestation` record + `make-manifestation`, status/absence predicates, Errata-0.2 producer/stream fields, `stream-relation` + `validate-stream-relation-coherence` (`manifestation.lisp:338`), `causal-claim` + `revise-causal-claim` |
| **OUTCOME** | 164–193 | `axis` + 4 axis constructors (`make-execution-axis`/`make-manifestation-axis`/`make-effect-axis`/`make-interpretation-axis`), `outcome` + `make-outcome` (`outcome.lisp:631`), `outcome-axis` reader (`outcome.lisp:815`), receipts/bounded-unknowns accessors |
| **PROCEDURE** | 195–221 | `procedure-descriptor` + `make-procedure-descriptor`, `validate-interpretation-against-descriptor` (`procedure.lisp:271`), `verdict`, `joint-verdict` + `make-joint-verdict` (`procedure.lisp:602`, structural×semantic) |
| **UNCERTAIN-EFFECT** | 223–234 | `uncertain-effect` + `make-uncertain-effect` (`uncertain-effect.lisp:51`): kind, attempt, external-request, possible-effects, known-facts, reconciliation-procedure, retry-policy |
| **RECORDS** | 236–372 | `seat`+`make-seat` (`records.lisp:57`), `attempt`+`make-attempt` (`records.lisp:304`), `supersession`+`make-supersession` (`records.lisp:147`), `reconciliation-receipt` (`:440`), `role-assignment`, `exposure-record`, `capability-mint-receipt`+`make-…` (`:721`), `capability-restoration-receipt`+`make-…` (`:810`), `claim`+`make-claim`, standing records (validation/integrity/visibility, Errata-0.2 §3), `derive-claim` (`records.lisp:1632`), `revalidate-claim` (`:1594`), `promote-origin` (`:1621`), `claim-validated-under-p` (`:1705`), `claim-published-to-p` (`:1739`) |
| **FOLDS** | 374–408 | `+kernel0-event-types+`, `kernel0-event`+`make-kernel0-event` (in-memory event, 13 fields), `validate-event-sequence` (`folds.lisp:517`), `check-retry-safety` (`:510`), `fold-seat-occupancy` (`:732`), `fold-exposure-principals` (`:771`), `fold-attempt-outcome` (`:894`), `attempt-outcome-standing` struct+readers, `merge-event-sequences` (`:956`, receipt-gated) |

### 1b. Lowering-contract steps — supported TODAY vs. not

The canonical step list is **Kernel §19.8 "Consequential invocation"** (spec lines 1542–1555),
which *names the lowering pipeline verbatim*: attempt allocation/validation · capability check ·
effect preparation · journal append · adapter dispatch · partial manifestation recording · effect
settlement recording · structured outcome production. Mapping each to code:

| Lowering step | Data/record TODAY? | Verb/operation TODAY? | Evidence |
|---|---|---|---|
| **locate / mint attempt identity** | ✅ `attempt` record + `make-attempt`, `identity=`, `require-identity` | ❌ no `begin-attempt`/`reserve-seat` | `records.lisp:304`, `identity.lisp:120`; §6.3/§19.2 spec-only |
| **authority (capability) check** | ✅ `capability-mint-receipt`, `capability-restoration-receipt` (durable *records* of authority) | ❌ no `mint-capability`/`check-capability`; **no live opaque capability object at all** | `records.lisp:721/810`; §11.1–11.7, §19.5 spec-only |
| **adapter selection** | ⚠️ manifestation carries `manifestation-adapter-identity` (a *field*) | ❌ no adapter object, descriptor, or selection verb | `package.lisp:142`; Kernel §18, AP0 §3–§4 spec-only |
| **effect preparation** | ✅ `uncertain-effect` record; effect-axis + `axis-effect-group` | ❌ no `prepare-effect`/`cross-frontier`/`settle-effect` | `uncertain-effect.lisp:51`; §10, §19.3 spec-only |
| **journal write** | ✅ in-memory `kernel0-event` + `validate-event-sequence` + folds | ❌ no durable append, no PJ-S/0 render, no frame/digest, no disk | `folds.lisp:517`; **journal store lane unbuilt** (PJ0 §5–§20) |
| **adapter invocation** | ❌ | ❌ nothing — no dispatch, no envelope custody, no ack | Kernel §18.3, AP0 §8–§12 spec-only |
| **manifestation record** | ✅ `manifestation`+`make-manifestation`, partial/present/absent/invalid predicates, stream coherence validator | ❌ no `record-manifestation`/`record-partial-manifestation` verb (the *writer*) | `manifestation.lisp:338`; §8, §19.4 spec-only |
| **outcome construction** | ✅ `make-outcome` + 4 axis constructors + `outcome-axis` reader (**fully live, selftest-verified**) | ✅ construction *is* the operation here — this step is DONE | `outcome.lisp:631/815` |
| **interruption / continuation standing** | ✅ `attempt-outcome-standing` + `fold-attempt-outcome` (terminal-class, unresolved-effect-p, supersession-lineage, reconciliation-receipts — all fold-derived) | ❌ no `suspend`/`resume`/`continue-process` verb; standing is *computed from an event list you hand it*, not from a live process | `folds.lisp:894`; §12.5/§13.6 spec-only |
| **inspection** | ✅ every record has a structured reader; `joint-verdict`, `outcome-axis`, standing readers | ⚠️ no `explain`/`export-canonical-evidence` verb (§19.7); dual-rendering §21.2 spec-only | package.lisp readers; §21 spec-only |

**Summary: of the 10 steps, exactly ONE (outcome construction) is fully live as an operation; four
more (attempt, effect, manifestation, standing) have their complete record/fold layer live but no
operational verb; capability-check, journal-write, adapter-select, adapter-invoke, and
evidence-export have no runtime at all.**

### 1c. What the folds prove today (the real teeth of the implemented layer)

The folds are the load-bearing *semantics*, and they run: `fold-attempt-outcome`
(`folds.lisp:894`) derives terminal class, unresolved-effect standing, supersession lineage, and
reconciliation receipts **from primary events alone** — this is the "self-report does not override
journal evidence" law made executable. `check-retry-safety` (`folds.lisp:510`) and
`validate-event-sequence` (`folds.lisp:517`) enforce transition legality and no-blind-retry.
`merge-event-sequences` (`folds.lisp:956`) refuses an implicit timestamp sort (requires a receipt).
**These are in-memory over a supplied event list; they do not read a journal from disk** — the
durable half is the unbuilt journal-store lane.

---

## 2. SPEC-ONLY MACHINERY — each unbuilt lowering step, governing section + what a minimal impl owes

*Locations: Kernel spec `architecture/LISP-PLUS-KERNEL-0-SPEC.md`; PJ0
`architecture/process-journal-0/LISP-PLUS-PROCESS-JOURNAL-0-SPEC.md`; AP0 (governing reissue)
`architecture/adapter-protocol-0/lisp-plus-adapter-protocol-0-reissue/LISP-PLUS-ADAPTER-PROTOCOL-0-SPEC.md`.*

| Step (no runtime) | Governing section | What a minimal implementation owes |
|---|---|---|
| **Attempt allocation / seat reservation** | Kernel §6.2–6.4, §19.2 | `reserve-seat`, `begin-attempt` verbs; seat-occupancy enforcement (the *fold* exists, the *guard verb* does not); collision refusal per §6.6 |
| **Capability mint + check + revoke + restore** | Kernel §11.1–11.7, §19.5; board lane 2 | Live *opaque* capability object (§11.1, MUST NOT be reconstructible from serialized fields §11.2); minting bridge from a sealed ruling (§11.3); frontier check (§11.4, 8 predicates); revocation at every frontier (§11.6); restoration by minter-or-mint-time-delegate, equal-or-narrower, new identity, self-restoration refused (§11.7) |
| **Effect preparation / frontier crossing / settlement** | Kernel §10, §19.3 | `prepare-effect`/`cross-frontier`/`settle-effect`/`record-bounded-effect`/`record-indeterminate-effect`/`compensate-effect`; no-implicit-fallback (§10.6); pre-frontier closure (§10.4) |
| **Journal write (durable)** — *board lane 1, the most immediate dependency* | PJ0 §5 (PJ-S/0 grammar), §7 (frame grammar), §8 (digests), §9 (append), §10 (durability), §12 (reader/prefix validation), §13 (terminal classification), §14 (salvage), §16–§17 (fold-derived resolvedness + unsupported-reconstruction), §19 (reconstruction receipts), §20 (merge) | **PJ-S/0 parse+render; binary-mode frame read/write; payload/predecessor/frame digest verification; append idempotency by event identity (§9.3); serialized writer; `:synced`/`:best-effort` receipts (§10, no promotion); prefix validation; torn-tail vs interior-corruption distinction (§13.2 vs §13.3); explicit salvage into a NEW journal (§14.2, source byte-identical §14.1/PJ-SAL-1); deterministic folds + reconstruction; merge receipts; fold-derived resolution — no mutable `resolved` flag (§16); `unsupported-reconstruction` for the multiple-unresolved case (§17.3).** Verbatim from board lines 52–64. |
| **Adapter descriptor + selection + dispatch** | Kernel §18; AP0 §3 (one contract), §4 (capability declaration algebra), §6 (prepared invocation), §8 (dispatch/frontier) | Stable adapter identity+version (§18.1); pre-invocation declaration of 12 capabilities, unknown declared *unknown* not absent (§18.2); adapter may not mint truth (§18.4 / AP-ACK-3 `adapter-truth-minting`) |
| **Adapter invocation + envelope custody + acknowledgment** | AP0 §9 (ack ladder), §10 (streams/chunks), §11 (crash windows W1–W4), §12 (envelope custody) | Closed 8-class acknowledgment vocabulary with non-promotion laws (§9, AP-ACK-4: ack has *no settling force by itself* — kernel fold settles); provider-envelope record (§12.1); journal-before-delivery (§10.5) |
| **Structured outcome production** | Kernel §9, §19.6 | *Records live*; the missing verbs are `match-outcome` and `with-outcome` (§19.6) — see §5 authorial gaps |
| **Inspection / evidence export** | Kernel §21, §19.7 | `explain`, `export-canonical-evidence`; dual rendering (§21.2); explanation-boundary (§21.3) |

### 2a. The deterministic fake adapter — what AP0 owes (board lane 3)

AP0 **does define a fake-adapter conformance class** — cite: **AP0 §23 "Conformance classes",
item 5: "*fake-adapter conformance — deterministic full-contract script interpreter*"**
(spec line 1087). Reinforcing laws: **AP-CON-1** — "*Fake and external adapters implement one AP0
contract. A fake adapter is not a separate weaker species*" (§2, line 147); **§18.3 / §19 (Kernel
line 1443–1459 + AP0 §19 fake-adapter script language, line 872)** — "*The deterministic fake
adapter implements the full AP0 contract with no network access*" (line 874). Mandatory scripted
injections: refusal-before-frontier, failure-after-frontier, present/present-empty/present-invalid/
absent-after-completion, partial-stream-then-kill, bounded-billing, delayed-ack, duplicate-request-
identity, config-drift (Kernel §18.3 lines 1447–1459; AP0 Appendix D). Fixtures owed: all four
capability standings, every provider-request-ID timing class, every ack class, **W1–W4**, stream
order/dup/conflict/gap/reorder/partial/final, absence shapes, envelope/projection separation,
usage/cost standing, cancellation ambiguity, reconciliation completeness + **L15 witness
admissibility**, relabelled forgeries at ack/cancellation/reconciliation sites (AP0 §24, lines
1096–1116).

### 2b. THE CL-INDEPENDENCE GATE — forbidden claims, quoted exactly

Three primary quotations. **Until an independently-seeded Common Lisp implementation passes the
full vector set, these claims are FORBIDDEN:**

**(1) AP0 gate — `IMPLEMENTATION-PHASE-BOARD-2026-07-18.md` lines 35–36 (Sol's transition
statement, filed verbatim):**
> "AP0 currently has co-authored self-consistency certification, not independent implementation
> conformance. **An independently seeded Common Lisp implementation must pass the complete vector
> set before stronger conformance language is used.** The stranger audit remains required before
> AP0 may be described as independently verified or independently validated."

**(2) PJ0 gate — `ARCHITECTURE-0-STATUS.md` lines 49–50:**
> "**BINDING GATE: no conformance claim beyond self-consistency, and no specimen reliance on PJ0,
> until an independently-seeded CL implementation passes the full vector set** (divergences
> adjudicate to spec text)."

**(3) Independence-at-birth (structural) — AP0 §24.1 lines 1120–1122:**
> "The vector generator and validation path MUST NOT import one another. The validator MUST NOT be
> emitted by the generator, embedded as a generator string literal, or port the generator's
> serializer or fake-adapter transition implementation. Separate filenames without separate
> authorship paths are insufficient for an independence claim. **Pre-independent greens MUST be
> labeled self-consistency certification, not independent conformance.**"

**(4) The seed-source rule — board line 66:** "The independently seeded Common Lisp implementation
should be **written from the governing specification and vectors, not translated from the existing
Python generator or validator.**"

**Separation of claims — board line 38:** "Normative adoption answers *which* specification governs.
The Common Lisp gate and stranger audit determine what has been *independently demonstrated*. Those
are separate claims and should remain separate." (Also carried in MEMORY.md as the standing law
`:prototype-supported-by-shared-root-audit` — never "independently validated" until a stranger's
frozen report exists.)

---

## 3. THE FOUR DEATH PLACEMENTS — the planned four-interruption specimen

**Specified in `IMPLEMENTATION-PHASE-BOARD-2026-07-18.md` §"Vertical specimen" lines 124–162**, and
grounded in two normative objects: **AP0 §11 "Crash windows W1–W4" (spec lines 559–576)** and
**Kernel §12.6/§12.7 (refusal vs. failure)** + **§13.6/§14 (terminal states, reconciliation)**. The
board's four placements map 1:1 onto AP0's W1–W4.

| # | Board placement (lines 139–151) | AP0 window (§11, lines 565–568) | What it owes |
|---|---|---|---|
| **1. Death BEFORE the external frontier** | board 139–140 | (pre-W1: refusal) | **No external effect; a typed refusal or unattempted state; safe restart.** Kernel §12.6: refusal emits *no* frontier-crossed event, preserves diagnostic evidence, states which precondition failed. §10.4 pre-frontier closure. |
| **2. Death DURING — after dispatch, before durable acknowledgment** | board 142–143 | **W1** (after send, before reliable response) | **An uncertain-effect record; automatic retry PROHIBITED; reconciliation or explicit supersession required.** Kernel §14.1 no-blind-retry (UNC-1); `uncertain-effect` record bound; AP0 W1 fold: "unresolved uncertain effect; no blind retry" (line 565); recovery = reconcile/adjudicate/supersede/abandon. |
| **3. Death AFTER a stream chunk is journaled, before delivery** | board 145–146 | **W2** (mid-stream) + **W3** (envelope captured, projection absent) | **Partial manifestation remains present; restart can inspect or deliver it; system does NOT classify it as absence.** AP0 W2: `:present-partial`, settlement unresolved unless separately evidenced (line 566); AP-CAN-3 cancellation never erases partial manifestations; Kernel §8.6 present-partial, §8.7 closed no-visible-payload states. AP0 §10.5 journal-before-delivery is the invariant that makes the chunk survive. |
| **4. Death AFTER terminal evidence durable, before finalization / receipt return** | board 149–151 | **W4** (projection committed, downstream not consumed) | **Committed event recovered by identity; invocation NOT duplicated; final view reconstructed from primary records.** PJ0 §9.3 append idempotency by event identity; PJ0 §19 reconstruction receipt (origin `:reconstructed`); Kernel §19.9 finalizer re-derivability body-law — finalizer MUST NOT hold unique primary facts; PJ-RCN-3 forced-kill specimen deletes finalizer output/snapshots/indexes before replaying primary journal. |

**AP-CRASH-2 (§11 line 572):** "*Every window MUST have deterministic fake-adapter fixtures and
specimen kill points.*" — i.e. the four death placements are jointly owned by the fake-adapter lane
(injects the kill) and the journal-store lane (survives it). **Neither of the two lanes that make
the specimen possible is built yet.**

The specimen's eight demonstration obligations (board lines 153–162): interruption does not erase
committed facts · self-report does not override journal evidence · authority not recreated from
historical records · partial manifestations remain identifiable · uncertain effects remain
explicitly uncertain · duplicate effects prevented/reconciled · final summaries regenerable · claim
origin+validation standing accurate.

---

## 4. AUTHORITY MODEL — what Kernel /0 + DK-3 license at surface, code vs. spec

**DK-3 (sealed in `LISP-PLUS-ARCHITECTURE-DECISIONS-0.1.md`, per ARCHITECTURE-0-STATUS line 20):
"minter-or-mint-time-delegate, equal-or-narrower."** The surface authority contract this licenses:

- **Who may mint:** a sealed ruling or policy claim *authorizes* minting but **is not itself a
  capability** (Kernel §11.3, line 894). Minting validates authorizing-claim standing → derives
  scope under an identified procedure → identifies minter+delegates → creates the live opaque
  capability → emits a minting receipt (§11.3 steps 1–5).
- **Who may restore:** **only the original minter OR a restoration delegate named in the minting
  record** (§11.7 lines 936–941) — this is DK-3 verbatim. Restoration MUST: new capability identity
  · link to predecessor · restoration receipt · recheck revocation · recheck unresolved irreversible
  effects · **grant equal-or-narrower scope** · **refuse self-restoration by the suspended process**
  (§11.7 steps 1–7). A domain policy MAY require a fresh owner act for sensitive classes (§11.7 line
  953).
- **The central rule (board line 89):** "*A durable record that authority existed is evidence about
  the past; it is not live authority in the present.*"

**Code vs. spec split:**

| Authority element | In CODE today | In SPEC only |
|---|---|---|
| Durable *record* that authority existed | ✅ `capability-mint-receipt` (`records.lisp:721`): receipt-id, capability-id, minted-by, authorizing-claim-id, derived-scope, **delegates**, revocation-registry, expiry | — |
| Durable *record* of a restoration | ✅ `capability-restoration-receipt` (`records.lisp:810`): predecessor/new capability id, restored-by, authority-basis, revocation-check, unresolved-effect-check, old-scope, new-scope | — |
| **Live opaque capability object** | ❌ **nothing** | Kernel §11.1–11.2 (opaque, non-reconstructible from serialized fields) |
| `mint-capability`/`check-capability`/`revoke-capability`/`restore-capability` verbs | ❌ | Kernel §19.5, §11.3–11.7 |
| Minting-bridge (ruling→capability) | ❌ | Kernel §11.3; board lane 2 ("ruling-to-capability minting bridge") |
| Equal-or-narrower enforcement at runtime | ❌ (the *fields* old-scope/new-scope exist to record it; nothing *checks* it) | §11.7 step 6; the `capability-restoration-scope-enlarged` condition **type exists** (`conditions.lisp` §20.3) but has no signaling site |

**So the authority model is: every durable receipt shape is minted and readable in code; every live
authority operation and every runtime guard is spec-only (board lane 2, "capability and
live-authority machinery … turns the architecture's authority laws into runtime objects").** The
condition taxonomy for authority failure is fully present as *types* (10 authority conditions,
`conditions.lisp` §20.3) — the *guards that raise them* are unbuilt.

---

## 5. HONEST GAPS — where Sol's proposed microprograms need machinery neither code nor spec defines

These are the synthesis's authorial questions. A `with-consequence`/`perform` surface form and its
companions cannot be lowered onto anything that exists as an *operation* today — only onto the record
layer. Precisely:

1. **`with-consequence` / `perform` (the surface consequential form).** Kernel §12.3 *classifies*
   what counts as consequential and §19.8 *names* the pipeline, but **there is no surface macro and
   no operational verb binding a consequential body to the pipeline.** `perform` would need
   `begin-attempt` + `check-capability` + `prepare-effect` + `journal-append` + adapter `dispatch` —
   **none implemented** (§1b). *Authorial question: does the synthesis define `with-consequence` as
   a new Kernel operation (§19 has no such name — §19.8 describes a "default supported invocation
   form" but names no macro), or as a library macro over §19 verbs that must first exist?*

2. **`match-outcome` and structured outcomes committed/refused/indeterminate.** `match-outcome`
   **is named in Kernel §19.6 (line 1526) but is NOT implemented** (grep: zero definitions) — only
   `make-outcome`/`outcome-axis` exist. Moreover the outcome record carries **four axes each with
   per-axis determinacy** (DK-4), *not* a single committed/refused/indeterminate tag. *Authorial
   question: Sol's three-way {committed, refused, indeterminate} surface match is a projection over
   the 4-axis×determinacy lattice — what is the exact lowering? Refusal is §12.6 (pre-frontier, no
   frontier-crossed event); "committed" and "indeterminate" are functions of the effect-axis
   determinacy AND the fold-derived `attempt-outcome-standing`. The projection function is
   undefined in both code and spec.*

3. **`with-outcome`.** Named §19.6 (line 1527), **not implemented, and its semantics are not
   specified anywhere** beyond the bare name. Pure authorial invention required.

4. **`reconciliation` as a surface verb.** The *record* (`reconciliation-receipt`,
   `records.lisp:440`) and the *condition* (`reconciliation-unsupported`/`-insufficient`) exist;
   `reconcile-attempt` (§19.2) and `begin-reconciliation` (a restart, §20.9) are **spec/condition-
   only, no verb**. AP0 §18 defines reconciliation's *result vocabulary and completeness law* but
   the runtime that drives uncertain-effect → narrower standing is unbuilt. *Authorial question:
   the surface `reconcile` must consume an `uncertain-effect` + new evidence and emit a
   `reconciliation-receipt` whose `resulting-axis-values+determinacy` the fold then honors — the
   glue is undefined.*

5. **`continue-process` (resumable / continuation standing).** Kernel §12.5 specifies a *process
   handle* MUST expose fold-derived state, partial manifestations, suspension/cancellation,
   reconciliation/supersession, eventual-outcome protocol — **but there is no process handle object,
   no `suspend`/`resume`/`cancel-process`, and no live process at all.** What exists is
   `attempt-outcome-standing` computed by `fold-attempt-outcome` over a *supplied event list*
   (`folds.lisp:894`). *Authorial question: `continue-process` presupposes (a) a durable journal to
   resume from — journal-store lane, unbuilt; (b) a live process handle — §12.5, unbuilt; (c)
   re-established live authority — §11.7 restoration, unbuilt. The continuation microprogram sits on
   top of all three unbuilt lanes simultaneously.*

6. **The journal-write step under any surface form.** Every microprogram above that "commits"
   silently assumes a durable append. Today `journal-append` (§19.9) is unimplemented and folds run
   over in-memory event lists. **Any surface form with commit semantics is lowering onto a journal
   that does not yet persist.** This is board lane 1 and it is the "most immediate dependency because
   all consequential operations need durable evidence" (board line 48).

7. **Adapter selection/dispatch under `perform`.** A `perform` that names a provider must select an
   adapter (AP0 §3–§4) and dispatch (§8). No adapter object exists; even the deterministic fake
   (board lane 3, AP0 §23 class 5) is unbuilt. *Every consequential surface form that reaches the
   outside is, today, lowering onto an empty adapter slot.*

8. **Six already-recorded kernel0 authorial gaps** (ARCHITECTURE-0-STATUS lines 61–72) that a
   lowering contract inherits — most now addressed by Errata 0.2 but two still ride as **bounded
   unknowns awaiting an Architecture-0.1 act, not kernel invention** (ADDENDUM 6, lines 219–221):
   call-296 completion-presupposition (K0E-7) and the §13.8 bounded-manifestation vocabulary limit.
   A lowering contract may not silently resolve these.

---

## 6. COUNT LINE

- **kernel0 exported symbols: 371** (mechanical count, `mneme/kernel0/package.lisp`, single package,
  package-name and `#:cl` excluded).
- **kernel0 implementation: 14 `.lisp` files** (records, folds, manifestation, outcome, procedure,
  conditions, determinacy, uncertain-effect, identity, boundary, package, load, fixtures,
  kernel0-selftest), ~6,610 lines (STATUS line 56).
- **Selftest (current governing state, post-Errata-0.2, per `kernel0/README.md` line 91 +
  ARCHITECTURE-0-STATUS ADDENDUM 7 line 238): 33 passed · 23 excluded (out-of-scope, printed
  reasons) · 0 failed · exit 0.** Controls: 24 fired + 5 named-excluded. Mutants: 59 killed (56
  independent + 3 disclosed re-attributions). *(Historical note: the pre-errata pure-core build was
  29 passed / 27 excluded, STATUS line 58 — superseded; use 33/23/0.)*
- **Condition types: 62 classes** = 1 base (`kernel0-condition`) + **61 subtypes** across 8 families
  (`conditions.lisp` §20.2 identity ×8 · §20.2a schema ×4 · §20.3 authority ×10 · §20.4 effect/retry
  ×10 · §20.5 manifestation/interp ×6 · §20.6 store/journal ×8 · §20.7 standing ×6 · §20.8 boundary
  ×9). Lawful restart names: 9 (§20.9).
- **Operational verbs of Kernel §19 implemented: 0** (verified by grep across
  `mneme/kernel0/*.lisp`, excluding selftest/fixtures). The only §19 name with a live body is the
  outcome constructor/reader pair `make-outcome`/`outcome-axis` (§19.6); `match-outcome` and
  `with-outcome` from the same subsection are **not** implemented.
- **The three unbuilt board lanes:** (1) Mneme journal store · (2) capability/live-authority · (3)
  deterministic fake adapter — `IMPLEMENTATION-PHASE-BOARD-2026-07-18.md` lines 46–114. All three
  gate the four-death vertical specimen; all three sit behind the CL-independence gate before any
  conformance language.

---

*Census complete. Traced against on-disk bytes; grep results for "verbs implemented" shown, not
claimed. Where a section summary compresses a spec's full requirement list, the governing § is cited
for the reader to walk — marked "spec-only" so nothing reads as built that is not. — PONTIFEX*
