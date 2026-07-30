# LISP-PLUS-VERTICAL-SPECIMEN-0 — the sealed pre-code contract

# Vertical Specimen /0 — The Four-Death Latent Machine
*(house name: de morte quadruplici)*

**Authority:** the owner ruling
`mneme/RULING-adapter0-closure-ap-cost-1-vertical0-2026-07-30.md` (Parts
III–XIX). This contract is the binding pre-code artifact of §5 of that
charge. It is **content-sealed by repository commit and SHA-256 before any
production implementation code exists** (seal record:
`PRECODE-SEAL.md` beside this file; the commit hash is the ordering
proof). Later corrections are permitted **only additively**, each stating
what changed, why the sealed expectation was wrong or incomplete, and
whether implementation evidence had already been observed.

**Governing proposition:**

> The machine may die four times; only its durable evidence is allowed to
> wake five times.

**Bilateral law:**

```text
safety:            never act or assert beyond the available warrant
founded progress:  when the exact sufficient warrant exists, do not
                   invent a refusal
```

Universal abstention is not a passing campaign.

**Stack under composition (public candidate APIs only; no predecessor
production source is modified except Adapter /0 as corrected through its
Erratum 0.1):** Canonical Datum /0 · Kernel /0 · Journal /0 ·
Capability /0 · Capability /1 · Capability /2 · Adapter /0 (through
Erratum 0.1). This is an **integration lane** — not independently seeded;
all public implementations, returns, and APIs of the stack were and may
be read. Closed doors (consumed, never reopened): Surface /1 · Language
Obligation /0 · the obligation second-inhabitant ruling · synthesis-01 ·
every predecessor's internal semantics.

---

## 1. The campaign shape — five lives, four deaths

One evolving campaign, one journal0 store (`:synced`), one durable fake
world, five genuinely separate process lives of ONE generic entry point:

```text
Life 1 → progress; process death at W1 (SIGKILL)
Life 2 → recovery, progress, process death at W2 (SIGKILL)
Life 3 → recovery, progress, process death at W3 (SIGKILL)
Life 4 → recovery, progress, process death at W4 (SIGKILL)
Life 5 → recovery, completion, exit 0; then official reconstruction
```

The child program is invoked identically every life: *"resume from
durable evidence alone; perform all remaining lawful work in the declared
seat order; exit 0 when nothing remains."* The kill schedule — owned by
the harness oracle alone — is what carves this single program into five
lives. The child never knows which W experiment is underway.

### 1.1 W-boundary semantics (exact size)

| W | semantic boundary name (child-visible) | meaning |
|---|---|---|
| W1 | `EFFECT-FRONTIER-CROSSED-UNSETTLED` | the attempt's frontier-crossed record is durable; no acknowledgment, settlement, or effect evidence exists |
| W2 | `STREAM-CHUNK-CUSTODY-COMMITTED` | at least one stream chunk record is durable; no terminal settlement exists |
| W3 | `ENVELOPE-CUSTODY-COMMITTED` | the complete raw provider envelope is durably in custody (journal record + evidence file); no projection exists |
| W4 | `PROJECTION-COMMITTED` | the projection record is durable; no interpretation or downstream consumption has occurred |

The child emits **semantic boundary names only** — never W labels, never
life numbers. The harness privately maps occurrences to W1–W4.

### 1.2 Crash model (exact size — claims ceiling)

W1–W4 demonstrate: **recovery after uncatchable process termination by
SIGKILL while the OS, kernel, filesystem, and storage stack remain
alive.** They do NOT establish: power-loss tolerance ·
storage-controller failure tolerance · arbitrary filesystem crash
consistency · hardware-cache flush guarantees · torn-sector tolerance ·
cross-filesystem guarantees. Journal /0's truncation/corruption fixtures
remain separate evidence and are not fused with this campaign. Two
same-host fresh-directory reruns establish **temporal repeatability under
the declared host environment** — never spatial determinism across
architectures, endianness, word sizes, kernels, locales, filesystems,
machines, or boot-fixed hash seeds.

---

## 2. Mechanical jurisdiction partition

### 2.1 `VERTICAL-PROGRAM-CONFIG.sexp` — what the program lawfully knows

Canonical bank (seat identities, terms, routes, projection shapes,
declared estimated costs) · public adapter descriptor identity and
invocation configuration · budget ceiling (ketiv/qere: lexeme +
canonical) · declared versions · public campaign policy (seat order,
boundary pause protocol, partial-stream non-resumption policy, S12
interruption simulation flag) · synthetic authority configuration
(bootstrap issuer, grants, the S10 revocation) · synthetic secret and
publication fixtures. **Never:** life numbers, W labels, kill schedule,
expected folds, expected outcomes, oracle pathname, private fake-world
ground truth.

### 2.2 `VERTICAL-HARNESS-ORACLE.sexp` — grader knowledge only

Kill schedule (boundary-name × campaign-cumulative occurrence → SIGKILL)
· W1–W4 mapping · life-to-kill assignment · expected corpse records ·
expected folds · expected per-seat outcomes · private fake-world ground
truth (the W1 pair's provider-side application) · mutation schedule ·
grading predicates.

### 2.3 Enforcement (code, not prose)

- Every child and recovery process runs in an **execution directory**
  (`exec/`) containing only: the copied program config, the journal
  store, the evidence directory, the public fake-world files, the
  simulated-mirror destination. The oracle lives outside it.
- No child receives, by argv, environment, cwd, load path, durable
  journal, program config, public fake-world state, recovery input, or
  generated source: life number, W label, kill schedule, expected fold,
  expected result, expected outcome map, oracle pathname, private
  fake-world truth.
- **External read-set witness:** the harness straces every child
  (`openat, open, read, pread64, write, pwrite64, fsync, fdatasync,
  rename, renameat, renameat2, close, unlink, unlinkat`) and proves no
  child ever opens the oracle artifact or the harness's private state
  directory. The trace is controlling; `/proc` sampling corroborates.
- Changing the harness schedule must not change: program source digest,
  program executable digest (source-run: the loaded file set's digests),
  program configuration digest, public bank digest. Proven by digesting
  those artifacts under two different schedules in the control suite.

### 2.4 Fake-world evidence classes

```text
A. program-visible durable evidence: the journal store, captured
   evidence files, public fake-world files in exec/
B. evidence lawfully obtainable through Adapter /0 reconciliation:
   the fake provider's durable domain file (provider-domain.sexp in
   exec/fake-world/), readable ONLY inside the declared reconciliation
   reader that feeds ap0:reconcile-request with an AP-REC-6-complete
   witness
C. harness-only oracle state: the W1 pair's hidden provider-side
   application truth, the schedule, the grading tables
```

The recovering program uses A and B only. Determinism of the fake
adapter is **not admissible settlement evidence**: the recovery fold may
never reason "this script normally applies the effect, therefore it
occurred." The harness inspects C only after the program has durably
committed its recovery disposition.

---

## 3. The canonical bank — twelve seats

Descriptor for every seat: `fake-reference-0` (adapter version `0`, from
the frozen reissue descriptors). Every AP0 record identity derives from
the seat's distinct `run-label`. Authority terms use subject
`(id "subject" "machina")`, action `(id "action" "loqui")`, per-seat
resource `(id "resource" <seat-id>)`, scope `(id "scope" "semel")`.
Effects write per-seat cells of one shared Capability /2 world.

| # | seat-id | route (declared) | projection shape | double duty (named) | required outcome |
|---|---------|------------------|------------------|---------------------|------------------|
| S1 | `seat-first-fruit` | full: prepare→journal pre-frontier→mint→authorize→cross→ack→envelope→project→consume | `nonempty` | evidence-settled execution + `:present` | `:present`, settled |
| S2 | `seat-torn-crossing` | prepare→journal→mint→authorize→cross → **W1 death** | — | W1 + uncertain external effect | `:crossed-unsettled` → structured `:uncertain-unresolved`, never resolved in-campaign |
| S3 | `seat-half-song` | streaming: …→cross→ack→chunk(1) → **W2 death** | `partial` | W2 + `:present-partial` | `:present-partial`, chunks preserved, never resumed (typed refusal) |
| S4 | `seat-sealed-letter` | …→cross→ack→envelope custody → **W3 death**; life 4: recovery projection from captured bytes→consume | `nonempty` | W3 | `:present` via `:derived` recovery projection |
| S5 | `seat-cold-supper` | …→cross→ack→envelope→project → **W4 death**; life 5: consume existing projection | `nonempty` | W4 | `:present`; projection receipt byte-identical across the death |
| S6 | `seat-empty-page` | full clean | `empty-string` | — | `:present-empty` |
| S7 | `seat-broken-glass` | full clean | `invalid-utf8` | — | `:present-invalid` |
| S8 | `seat-burned-draft` | full clean | `missing` | — | `:absent` with state `:absent-after-completion` |
| S9 | `seat-locked-purse` | refused before frontier | — | budget refusal + pre-frontier refusal | typed `budget-ceiling-exceeded`, no dispatch, no crossing |
| S10 | `seat-dead-hand` | refused before frontier | — | revoked-authority refusal | `capability-revoked` (fresh fold), no crossing |
| S11 | `seat-late-riser` | untouched until life 5, then full clean | `nonempty` | untouched seat resumed after restart | `:present` |
| S12 | `seat-slammed-door` | cross with declared interruption simulation → post-frontier failure → uncertainty → world-evidence reconciliation | — | post-frontier failure | `:absent`; effect reconciled `:not-applied` (evidence-settled reconciliation witness) |

Manifestation state stays separate from causal explanation: "no subject
manifestation exists" is a state; "the budget was exhausted before
subject output" is a later evidence-bearing explanation carried in the
seat's refusal record. No application vocabulary enters Kernel or
Adapter packages.

### 3.1 Declared seat order (campaign policy, program-visible)

```text
S1 S6 S9 S2 | S3 | S7 S10 S12 S8 S4 | S5 | S11 + finalization
```

(The `|` marks are where the ORACLE's schedule will land the kills; the
program never sees them — it simply proceeds in order over whatever
remains.)

### 3.2 Boundary pause protocol (program-visible policy, per route)

Pauses are declared **per route**, because a window can only be paused
where it is genuinely open: Capability /2's `attempt-protected-effect`
closes the crossing window atomically inside one public call for clean
seats (frontier-crossed → world write → settlement in one process step),
so full-clean routes never pause. The open-window routes pause:
`:frontier-only` at `EFFECT-FRONTIER-CROSSED-UNSETTLED` (its crossing
runs under the declared request-loss simulation — cap2's `:request-lost`
seam, the request crosses and never reaches the world, indistinguishable
from a request lost in flight from the bytes alone); `:streaming` at
`STREAM-CHUNK-CUSTODY-COMMITTED`; `:envelope-then-recover` at
`ENVELOPE-CUSTODY-COMMITTED` and (its recovery projection) at
`PROJECTION-COMMITTED`; `:project-then-consume-later` at
`PROJECTION-COMMITTED`.

At every declared pause the child: (1) completes the boundary's
durability protocol; (2) emits one line `BOUNDARY-READY seat=<seat-id>
boundary=<name>` on stdout (a harness-only pipe; not a journal record,
not config, not recovery input, not census); (3) performs no further
semantic operation; (4) blocks reading one line from stdin (the
parent-controlled wait pipe); (5) proceeds only when the harness answers
`CONTINUE`. The harness confirms the child is blocked in `read(0, …)`
(via strace, corroborated by `/proc/<pid>/syscall` / `wchan`) before any
SIGKILL. The child's behavior is schedule-independent: it pauses at
every declared occurrence whether or not a kill is scheduled there.

---

## 4. Durability protocols per boundary (declared, witnessed)

Two protocol shapes, both externally witnessed by strace:

**(a) Append-in-place (the journal):** every journal append rides
Journal /0's `:synced` path — `write-sequence` to `EVENTS.pj0` →
`finish-output` → `fsync(journal fd)` (sb-posix:fsync; there is NO
fdatasync in the stack and the witness therefore checks `fsync`) →
reopen-and-revalidate → append receipt. Boundary readiness markers are
emitted only after the last required append's fsync has returned.

**(b) Write-replace (captured evidence files):** raw envelope octets and
derived exports are persisted by the vertical evidence writer: write
temporary file → `fsync(tmp fd)` → `rename(tmp, final)` → `fsync(parent
directory fd)` → readiness. `close` alone is never a durability
primitive.

Per-boundary bindings:

| boundary | durable object(s) | protocol | required order before READY |
|---|---|---|---|
| `EFFECT-FRONTIER-CROSSED-UNSETTLED` | `EVENTS.pj0` (attempt:prepared, attempt:frontier-crossed, AP0 pre-frontier + dispatch + binding records) | (a) | all appends fsynced |
| `STREAM-CHUNK-CUSTODY-COMMITTED` | `EVENTS.pj0` (chunk record) | (a) | chunk append fsynced BEFORE delivery is consumed |
| `ENVELOPE-CUSTODY-COMMITTED` | evidence file `evidence/<seat>-envelope.bin` + `EVENTS.pj0` (envelope record binding sha256) | (b) then (a) | file replaced+synced, then record fsynced |
| `PROJECTION-COMMITTED` | `EVENTS.pj0` (projection record) | (a) | projection append fsynced |

The witness proves, per boundary: expected bytes written · the
durability primitive targeted the correct fd/object · the call returned
successfully · rename/directory-sync ordering held where applicable ·
the readiness marker occurred afterward · **no subsequent semantic write
occurred before SIGKILL**. Successful witnessing earns ONLY: *"the
implementation invoked its declared durability protocol before the
process-death boundary"* — never power-loss durability.

**Planted no-sync mutant:** a mutated program creating the journal with
declared durability `best-effort` (flush-only append path). The witness
must kill it — no `fsync` before the readiness marker — even though its
bytes remain readable after SIGKILL (the surviving kernel flushes dirty
pages; readable bytes are NOT the passing condition).

---

## 5. The four deaths — expected surviving evidence and folds

Recovery in every life may use: validated journal bytes · lawfully
visible fake-world evidence (class A) · Adapter /0 reconciliation
evidence (class B, through the declared reader) · captured envelopes and
chunks · program-visible immutable configuration · public predecessor
APIs. Recovery may never use: dead-process memory · hidden phase files ·
operator testimony · the oracle · readiness markers · life numbers · W
labels · serialized Capability /1 objects (none exist) · private adapter
state.

**W1 (S2).** S2's crossing runs under the declared request-loss
simulation (`:request-lost`): the frontier-crossed record is journaled,
the request never reaches the world, and the call returns `:interrupted`
— at which point the child pauses and is killed, its in-process
knowledge of the loss dying with it. Surviving: S2's
prepared-invocation, request-capture, exposure, cap2 attempt:prepared,
attempt:frontier-crossed, AP0 dispatch record,
crossing-evidence-binding. NOT surviving: any acknowledgment,
settlement, effect evidence — from the durable bytes alone the standing
is genuine `:crossed-unsettled`. Life-2 obligations: the pre-declaration
scan (`check-retry-safety-from-store`, CAP2-W1) refuses blind retry from
durable bytes alone · the effect remains unresolved (`:crossed-unsettled`
→ structured via `declare-uncertain-effect` → `:uncertain-unresolved`) ·
no inference of no-effect from missing acknowledgment · no inference of
effect from script determinism · the dead key is unavailable (fresh
context recognizes nothing) · historical receipts are not live authority
(fresh fold refuses/re-derives) · fresh authority may govern lawful
reconciliation — exercised NOT on S2 (which stays uncertain all
campaign) but on the W1 control pair (§6) and on S12's world-evidence
reconciliation.

**W2 (S3).** Surviving: S3's pre-frontier + crossing records, ack
record, chunk-1 record (custody: journaled before delivery). Life-3
obligations: `:present-partial` standing · chunk order and gaps
inspectable · missing terminal settlement does not erase chunks · blind
restart from chunk zero refuses (typed; would duplicate chunk-1) · later
campaign work never rewrites the partial record (S3 is closed as partial
by policy; its partiality is never "completed").

**W3 (S4).** Surviving: S4's records through the envelope record + the
exact envelope octets in `evidence/seat-sealed-letter-envelope.bin`
(sha256-bound). Life-4 obligations: envelope present and
integrity-checkable (recompute sha256 against the journaled binding) ·
no projection fabricated from memory · projection operates on captured
bytes via the **planned vertical-local recovery-projection procedure**
(`vertical-recovery-projection-0`, version 0 — declared here because
Adapter /0's `project-envelope` requires the process-local dispatch
handle, which lawfully died; the recovery projection consumes the
captured octets + the PUBLIC absence-table accessors, emits a projection
record with `output-origin "derived"` binding the original envelope id
and payload sha256) · the fake provider is not called again (strace: no
new dispatch for S4 in life 4; no provider-domain read outside the
declared reconciliation reader).

**W4 (S5).** Surviving: S5's records through the projection record.
Life-5 obligations: no provider action · no new envelope captured · the
EXISTING projection is consumed (a consumption record binding the
projection receipt id) · interpretation is a separate transformation ·
the projection receipt remains byte-identical (its journaled frame is
immutable; the consumption record references, never rewrites) · later
consumption does not retroactively alter projection.

---

## 6. W1 indistinguishability control (paired, separate mini-campaigns)

Two control runs (`control-a`, `control-b`), each: one seat
(`seat-control`, config `:control-bank` template, identical bytes in
both arms), same program, kill at the first
`EFFECT-FRONTIER-CROSSED-UNSETTLED`. Recovery (life 2) journals the
uncertainty disposition and pauses at `CONTROL-DISPOSITION-COMMITTED`;
the harness **banks both arms' journal snapshots and requires the
dispositions canonically equal there** — order-enforced: at that moment
the class-B provider domain is identical (empty) in both arms, so all
program-visible AND all lawful pre-reconciliation evidence is identical
while hidden truth (oracle-side) differs. If the dispositions differ,
the program has leaked the oracle or treated script determinism as
evidence — campaign defect. Only after banking does the harness play
the concurrent provider per its private table (arm A: effect written
into the fake provider's durable domain; arm B: not), then answers
`CONTINUE`; each arm reconciles through the declared class-B reader +
`ap0:reconcile-request` (AP-REC-6 conjunction) and must reach its true
standing (arm A: found, uncertainty preserved as
effect-standing-with-evidence; arm B: not-found with complete domain and
witness settles no-effect) — the original uncertainty records remain
unchanged. **Planted mutant:** a recovery
variant that settles W1 from script knowledge/private state — must be
killed by the settlement-without-reconciliation-evidence grading
predicate and by wrong-in-one-arm grading.

---

## 7. Authority — re-earned every life

Per attempt, the legal order (public names): collect pre-frontier
journal facts → `declare-bootstrap-authority` → `make-minting-context`
(fresh; recognizes nothing) → `query-live-authority` (`:origin
:reconstructed` on restart derivations) → `mint-from-authorization` →
`authorize-effect-attempt` (which presents internally; revocation
standing checked first, staleness second) → `attempt-protected-effect`
**immediately** (no early minting carried across unrelated journal
movement). Demonstrations bound: old key refuses (`cap1-stale-capability`
— every frontier attempt stales the key, since crossing appends) · old
presentation receipt is not authority · old authorization receipt is not
authority (re-derived; `cap2-stale-authorization` at the frontier) ·
fresh key authorizes an untouched seat · fresh key cannot authorize the
poisoned unresolved seat (S2: `unsafe-retry`, CAP2-W1) · authority for
one seat cannot consume another's scope (exact four-term equality) ·
minting from a refused/stale receipt refuses (`CAP1-MINT-1/2/3`).

## 8. Budget — a fold, not a counter (planned vertical-local mechanism)

Capability /2 declares budgets a named divergence; therefore the
campaign budget is vertical-local, declared here: config binds a
canonical ceiling (ketiv `"5/1"` USD; qere the CD/0 rational/integer) and
per-seat declared estimated costs. Before every frontier: fold ALL
durable cost/spend records + the candidate's declared estimate; if the
sum would exceed the ceiling, typed refusal `budget-ceiling-exceeded`
**before the frontier** (S9's declared estimate `"1000000/1"` guarantees
it deterministically). After every restart the budget state is re-derived
from durable records only. Distinctions held: usage ≠ cost · estimated ≠
billed · source lexeme ≠ canonical amount (Erratum 0.1 exercised live:
lexical testimony preserved, reduced rationals in arithmetic, equivalent
spellings collapse, missing cost is missing not zero — S1 additionally
extracts a schedule-less cost whose typed missing-marker never becomes a
zero) · provider testimony ≠ settled billed cost · remaining
authorization is derived, never stored.

## 9. Synthetic epistemic and publication effects (life 5)

**Secret opening:** config carries a fake sealed rubric
(`rubrum-sigillatum-0`, wholly synthetic), an opening capability (grant:
action `(id "action" "aperire")`), named exposed principals
(`principalis-unus`, `principalis-duo`), exposure scope. Opening
journals a durable exposure record naming capability, principals, scope.
An opening without an exposure record is a defect (control-tested). No
actual private project material appears anywhere.

**Publication:** a private staging artifact (derived export) + a
publication capability (action `(id "action" "publicare")`) + a
simulated commit frontier (a cap2 effect writing the `cella-speculi`
cell) + a simulated mirror destination (`exec/mirror-sim/`, test-channel
policy declared in config) + a journaled publication receipt. The real
public mirror is never contacted from inside the specimen; repository
publication by the chair after the lane is a separate act.

## 10. Projection ≠ interpretation (life 5)

Deterministic interpretation stage `vertical-interpretation-0` (version
0) over projected manifestations: classifies each projection's
structural class (present/empty/invalid/absent-mapped) by validating the
tiny declared grammar of its shape row — never claiming factual truth or
quality from parseability. Each run journals a transformation receipt:
procedure identity + version, input projection identity, output
identity.

## 11. Census — reconstructed by construction; finalizer adds nothing

**Official census:** produced by `reconstruct-census.lisp` in a FRESH
process loading only: primary durable journals, lawfully captured
evidence, public program configuration, the census procedure module
(`census.lisp`). It must not load: the orchestration module
(`campaign.lisp`), the oracle, finalizer outputs, live caches, dead
state, private fake-world truth. **Independent replay:**
`replay-census.lisp`, a separate read-only program that does not import
the orchestration module, applying the SAME census procedure. Both
official results carry derivation origin `:reconstructed` (the tag names
where evaluation happened) and must be canonically equal (byte-equal
canonical encodings).

**Finalizer** (`finalizer.lisp`): may add indexes, checksums,
renderings, human summaries, canonical export bundles — never a unique
primary fact. Proof: (1) complete campaign; (2) preserve finalizer
outputs; (3) delete every derived index/summary/export; (4) retain only
primary journals, captured evidence, public config; (5) fresh process
that never loads the finalizer module reconstructs census + standings;
(6) canonical comparison. **Named-cell localization tooth:** finalizer
caches live in named special variables (`*finalizer-index-cache*`,
`*finalizer-summary-cache*`, `*finalizer-export-cache*`); a diagnostic
run `makunbound`s them, re-runs reconstruction, and any illicit
dependency must signal `UNBOUND-VARIABLE` whose `CELL-ERROR-NAME`
identifies the finalizer-only symbol. The tooth supplements, never
replaces, the fresh-process deletion proof.

## 12. Founded-progress matrix (sealed)

| obligation | exact durable preconditions | transition | success disposition | proving evidence |
|---|---|---|---|---|
| fresh authority on untouched seat | grant live at validated prefix; seat unoccupied in fold | mint→authorize | authorization receipt | receipt + fresh fold agreement |
| sufficient budget before frontier | fold(spent)+estimate ≤ ceiling | budget check passes | attempt proceeds | journaled cost records + no refusal |
| one lawful dispatch | authorization current at exact prefix | `attempt-protected-effect` + AP0 dispatch | `:settled` (or declared sim outcome) | frontier-crossed + dispatch + binding records |
| one journaled partial chunk | crossing durable; stream open | chunk journaled pre-delivery | chunk record ordinal present | chunk frame + custody order in trace |
| one valid envelope projection | envelope custody durable | project (live or recovery path) | projection record, origin `derived` | projection frame binding envelope |
| one committed projection consumption | projection durable | consumption record | consumed standing | consumption frame referencing receipt id |
| one evidence-settled execution | terminal + effect evidence | settlement derived from evidence | `:settled` / reconciled standing | S1 settled; S12 reconciled `:not-applied` |
| untouched seat resumed after restart | seat absent from all prior folds | full route in life 5 | `:present` | S11's complete record set post-restart |
| founded nonempty census assertion | all seats resolved or lawfully open | census fold | 12-seat outcome map | census record, replay-equal |

A refusal at any of these transitions is a defect unless a separately
named durable fact defeats a precondition. The campaign may not pass by
refusing everything.

## 13. Mutation testing (both directions, each killed by its exact predicate)

**Rule-omission (unjustified action/claim):** unsafe retry allowed (kill:
`unsafe-retry`/CAP2-W1 scan bypass detected by grading) · revoked
capability accepted (kill: fresh-fold revocation check) · scope mismatch
accepted (kill: four-term equality) · budget ceiling ignored (kill:
`budget-ceiling-exceeded` absent → grading predicate on S9) ·
acknowledgment promoted to settlement (kill: settlement-evidence
predicate) · partial stream promoted to complete (kill:
`partial-manifestation-erasure` / census partial standing) · projection
promoted to truth (kill: interpretation-receipt requirement) · missing
cost treated as zero (kill: budget-fold missing≠zero predicate) ·
finalizer-only fact accepted (kill: deletion proof inequality) · no-sync
durability (kill: strace witness) · W1 settled through script knowledge
(kill: §6 predicates).

**Rule-addition (spurious refusal/abstention):** deny every fresh
capability · classify every seat as poisoned · treat every budget as
exhausted · suppress every lawful dispatch · refuse every valid envelope
projection · refuse every committed projection consumption · preserve
uncertainty despite complete admissible settlement evidence · classify
every founded manifestation as unresolved · refuse every founded
nonempty census assertion. Each is a permanent planted mutant killed by
the exact positive obligation of §12 it violates. Reported separately:
omission-killed vs addition-killed counts (live counters).

## 14. Integration controls (each fails through its intended predicate)

duplicate seat · duplicate attempt identity · duplicate
provider/idempotency identity · occupied target before effect · revoked
capability · stale capability · scope mutation · scope aliasing ·
self-restoration attempt · restoration with enlarged scope · spending
ceiling exceeded · adapter alias drift · adapter version drift · torn
journal tail · invalid interior record · unsafe fallback · unsafe retry
· standing inflation · self-written narrative promoted to observation ·
claim copied without transformation receipt · secret opening without
exposure record · finalizer-only primary fact · raw host value crossing
a durable boundary · convenience accessor discarding outcome context ·
runner truncation before canonical result · marker emitted before sync ·
no-sync durability mutant · semantic work after readiness marker ·
oracle file exposed to child · kill schedule passed through
configuration · W1 settled through script knowledge ·
universal-abstention mutant · schedule-independence digest check (§2.3).
A generic crash never counts as a pass.

## 15. Predicate ownership (integration predicate table — return obligation)

Every named predicate/condition/refusal relied on or introduced is
classified in the return as: pre-existing predecessor predicate
exercised · planned vertical predicate (this contract §§4–14 declares:
`budget-ceiling-exceeded`, `vertical-recovery-projection-0`,
`vertical-interpretation-0`, the evidence writer, the boundary pause
protocol, the class-B reconciliation reader, the census/replay/finalizer
procedures, stream-resumption refusal `stream-resume-would-duplicate`) ·
unplanned but vertical-local (each: invariant, owning layer, why absent
here) · apparent missing predecessor predicate (STOP and report; no
predecessor repair from this lane) · relied-upon predecessor predicate
present but never exercised (only for predicates this contract cites as
carrying a vertical guarantee; each reported as campaign witness /
integration-control witness / structurally inapplicable / coverage gap).
No whole-repository coverage audit.

Predecessor predicates this contract cites as carrying guarantees:
`unsafe-retry` (CAP2-W1 + kernel §14.1) · `cap1-stale-capability` ·
`cap2-stale-authorization` · `capability-revoked` ·
`capability-scope-mismatch` · `duplicate-attempt-identity` ·
`reconciliation-insufficient` · `adapter-witness-boundary-missing` ·
`reconciliation-identity-missing` · `pj0-torn-tail` ·
`pj0-interior-corruption` · `pj0-event-identity-collision` ·
`stream-persistence-order-invalid` · `partial-manifestation-erasure` ·
`provider-envelope-missing` · `absence-mapping-table-miss` ·
`projection-origin-invalid` (rule) · `cost-float-noncanonical` ·
`cost-lexeme-noncanonical` · `adapter-version-drift` ·
`implicit-provider-fallback` · `cap2-effect-not-authorized` ·
`cap1-mint-refused` · `unsupported-reconstruction`.

## 16. Reproducibility, artifacts, gates

Two complete five-life campaigns in fresh directories on the declared
host (Linux, SBCL 2.4.6 via the operation-checked wrapper). Canonical
durable records and derived exports contain no ambient PID, wall-clock,
random pathname, host address, temporary directory, or
filesystem-enumeration order (raw harness diagnostics may, as declared
noncanonical). Compared byte-identically: final canonical
journal/fold identities · seat outcome map · census · manifestation
identities · projection identities · authority standings · retry
standings · cost and budget fold · finalizer-independent export.
Preserved: all four corpse states (exec-dir snapshots), all four
syscall-witness traces, all four blocked-state witnesses, all kill logs,
the final surviving state. All final counts derive from live registries
and counters — no ceremonial remembered totals; every bounded coverage
choice is logged as dropped, never silently truncated.

Required gates (§31 of the ruling): erratum suite · complete campaign ·
second fresh campaign · durability-witness gate · blocked-state gate ·
oracle-separation/read-set gate · W1 indistinguishability gate ·
official reconstruction · independent replay · finalizer-deletion proof
· named-cell tooth · integration controls · both mutation gates ·
Adapter /0 / Capability /2 / /1 / /0 regressions · Journal /0 selftest +
frozen vectors · verify-all · exact path-diff proving every predecessor
implementation unchanged (Adapter /0 differing only through Erratum
0.1).

## 17. Claims ceiling (verbatim from the ruling)

May claim: one five-life campaign executed · four real SIGKILL process
deaths executed · declared durability primitives externally witnessed ·
W1–W4 process-death recovery demonstrated · recovery denied access to
the harness oracle · official state derived from durable evidence alone
· independent replay produced the same canonical census · finalizer
added no unique primary facts · rule-omission and rule-addition mutants
killed · same-host fresh-directory temporal repeatability demonstrated ·
no live provider contacted.

May NOT claim: power-loss durability · hardware-cache durability ·
arbitrary filesystem crash tolerance · cross-platform determinism ·
live-provider conformance · distributed correctness · independent audit
· adoption · freeze · governing-floor standing.

---

*Sealed pre-code. — Claude Fable 5, chair, 2026-07-30.*

---

## ADDITIVE CORRECTIONS (dated; the sealed text above is unchanged)

### C1 — 2026-07-30, after first implementation evidence: §3 per-seat resource

**What changed:** §3's sealed authority-terms line — *per-seat resource
`(id "resource" <seat-id>)`* — is corrected to: **the per-seat resource
IS the seat's effect-cell identity `(id "cella" <cell-name>)`** (still
exactly one distinct resource per seat; subject/action/scope as sealed).
**Why the sealed expectation was wrong:** Capability /2's own public law
(`CAP2-EFFECT-NOT-AUTHORIZED`, live refusal: *"a key opens exactly the
door it was cut for, and licenses exactly the effect it names"*) requires
the capability's resource term to equal the effect's cell; a
seat-id-spelled resource can never license the config-declared cell
write. The sealed line contradicted an adopted predecessor law.
**Implementation evidence already observed:** yes — the builder hit the
live refusal and flagged it; the correction was adjudicated by the chair
after that evidence existed, and is recorded as such.

### C2 — 2026-07-30, after first implementation evidence: §3.2 blocked-state mechanism

**What changed:** the corroboration channel. Sealed: *"via strace,
corroborated by `/proc/<pid>/syscall` / `wchan`"*. Corrected: the
**strace record is controlling** (every killed trace must end
`read(0, <unfinished …>` + `+++ killed by SIGKILL +++`); live
corroboration rides `/proc/<pid>/wchan` (`anon_pipe_read`) and
`/proc/<pid>/stat` state `S`. **Why:** `/proc/<pid>/syscall` returns
EPERM for a process an strace tracer is attached to (ptrace
exclusivity) — verified live; the sealed line assumed both channels were
simultaneously readable. **Implementation evidence already observed:**
yes.

### C3 — 2026-07-30, chair confirmation of a flagged interpretive ruling: §5 W2 "terminal settlement"

W2's *"before terminal settlement"* is confirmed to mean the **stream's
terminal** (the AP0 terminal envelope; none exists at the W2 corpse, nor
chunk-2). The streaming seat's Capability /2 cell-effect settles
atomically inside `attempt-protected-effect` per §3.2's own atomicity
note — that settlement is a different fact on a different axis and does
not contradict the W2 corpse. S3's census effect label
(`:crossed-unsettled-partial-closed`) is derived on the STREAM axis, as
documented in `census.lisp`. Flagged by the builder before grading was
banked; confirmed by the chair. **Implementation evidence already
observed:** yes.

*Post-correction SHA-256 of this file is recorded in `PRECODE-SEAL.md`'s
correction log; the sealed pre-code digest above it remains the ordering
proof.*
