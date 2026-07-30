# CAPABILITY-2-RETURN — the deliverable

Lane: **Capability /2** (`mneme/capability2/`, package
`#:lisp-plus-capability2`). Status: **candidate**. Builder: CLAVIGER-III
(Claude Fable 5 subagent), 2026-07-30. Substrates, statuses at first
mention: **Capability /1** (itself a candidate — not audited, not adopted,
not frozen) through its public exports; **Capability /0** (candidate)
through its public exports; **Journal /0** (candidate; PJ0 §32.5 FULL NOT
CLAIMED) through its public exports; Kernel /0's exported conditions,
records, and folds (the spec is adopted; the partner implementation is
smoke-checked, and consuming it imports no conformance); AP0 is an
adopted **specification** whose vocabulary this lane uses under a labeled
subset — **no AP0 conformance is claimed**. SBCL 2.4.6, Linux host. **No
transitive guarantee imports: nothing here inherits a guarantee from any
substrate. Three substrate behaviours are RELIED ON and named as such:**
journal0's append-moves-the-prefix property and capability0's
revocation-commits-an-event property (§2.6 — the conjunction that makes
a second invocation-time fold unreachable; exercised at one instance,
C011, not universally), and kernel0's payload re-validation on every
fold (§2.4). Each is by inspection of the substrate, none re-derived
here.

> A recognized, current capability may justify attempting one exact
> protected effect — but neither the capability nor its presentation
> receipt proves that the effect occurred.

Transcript keys used below: S = `RUN-SELFTEST.txt` (29/0), C =
`RUN-CONTROLS.txt` (27/0), P = `de-effectu-incerto/RUN-SPECIMEN.txt`
(29/0); every pair run twice, byte-identical (`RUN-EXITCODES.txt`).

---

## 1. What is demonstrated (every item traces to a numbered transcript check except where marked by-inspection)

**The owner's vertical, inhabited end to end** (C, 27 checks / 0
failures, two runs byte-identical):

fresh live capability presentation — and presenting changed nothing
[C001] → exact effect request → **authorization to attempt** (the §11.4
named subset: fresh /0 fold `:authorized` · fresh presentation · exact
effect match · attempt identity unbound · seat fold clean) yielding the
prefix-bound authorization-to-attempt receipt, with cell, ledger, and
journal untouched [C002] → **explicit effect invocation**:
`attempt:prepared` + `attempt:frontier-crossed` journaled per the PJ0
fixture grammar, the adapter dispatched, the ONE exact cell set, and
settlement **derived from verified evidence**, not from the
acknowledgment class [C003] → **the durable journal account**: five
frames in order — grant · prepared · frontier-crossed · acknowledged ·
settled; queries and receipts not in it [C004] → the acknowledgment as
journaled testimony whose evidence digests re-verify against the
surviving world [C005] → the cell set EXACTLY ONCE; standing `:settled`
derived from bytes [C006].

**The uncertain outcome and its resolution, same-life** (C): the
scripted evidence-free acknowledgment yields the typed state
`:uncertain` — not refusal, not failure — with the §10.8 record
journaled under the UNC-1 default retry policy [C013]; blind retry
refuses `unsafe-retry` even for a fresh, fully current key [C014], and
identically from reopened byte-handles [C015]; reconciliation branch (a)
resolves `:applied` with ledger evidence and the double-apply
counterfactual standing in bytes [C016]; the seat then lawfully frees
while the dead identity stays duplicate-refused [C017]; a second
reconciliation is a disposition, not a transition [C018]; branch (b) —
frontier journaled as crossed, request lost — resolves `:not-applied` on
the ledger's own digest as absence evidence, cell byte-identically
untouched, and a fresh attempt under a NEW identity then succeeds: the
effect happens exactly once, afterward [C019]. (Conceded: C019's
*printed transcript label* shows only the not-applied half; the
fresh-attempt-succeeds half is asserted inside the same check's body —
`capability2-controls.lisp`, the C019 form — and the frozen transcript
under-shows it. A reader with only the transcript sees the first half.)

**The restart specimen** (P, 29 checks / 0 failures, two runs
byte-identical): a first life is granted, minted, authorized, dispatches
— and **dies inside the acknowledgment window** (planted deterministic
interruption; exit 7, no sentinel, seen to fire) [P005]. The survivors
exhibit **the asymmetry the lane exists for**: the journal ends at
`attempt:frontier-crossed` — three frames, nothing after [P006] — while
the world holds the written cell and one ledger entry [P007]. A
genuinely new process, over durable bytes and declared configuration
only: derives `:crossed-unsettled` and does not rewrite it as refusal or
failure [P014]; **refuses blind retry from bytes alone** — a fresh mint
is lawful [P015] but authorization of a new attempt into the seat
refuses `unsafe-retry` with the world not yet consulted [P016], and the
dead identity itself refuses `duplicate-attempt-identity` [P017];
refuses inline reconciliation [P018]; **structures** the §10.8 record
from journaled facts through kernel /0's own constructor [P019]; stays
refused after structuring, now carried by the record itself [P020];
**reconciles `:applied` with evidence** — the entry is there; a blind
retry would have double-applied [P021]; only then is the seat free
[P022]; second reconciliation is a disposition [P023]; the dead life's
authorization receipt is byte-unchanged and still truthful [P024,
P028]. The world is sha-identical across the entire restart [P026]; the
journal grew by exactly the two accounting frames, the death-state bytes
a verbatim prefix of the final journal [P027]; both journal states,
world files, and the receipt preserved as ARTIFACT-* with a SHA256SUMS
manifest [P029].

**The ten laws — plus the §11.4 subset row — each with the check that
would fail if it broke:**

| # | law | evidence |
|---|---|---|
| 1 | authority is not execution | S014 (mint+present: zero effects; cell bytes compared), C001, P003 |
| 2 | authorization-to-attempt is not acknowledgment | S015 (receipt exists; no ack, no world byte), C002, P004 |
| 3 | acknowledgment is not settlement (AP-ACK-4) | C003/C005 (settlement from verified evidence); mutant killed S026, C023 |
| 4 | uncertainty is not failure and not refusal (§9.2) | C013 (own typed state; terminal stays open), P014 |
| 5 | **a retry after uncertain execution is not an innocent first attempt** | same-life C014; from byte-handles C015; **new process, bytes alone P016/P020**; mutant killed S027, C024 (ledger's two entries = the exhibited double-apply) |
| 6 | failure after authorization does not retroactively invalidate authorization | S021, P024, P028 (receipt bytes unchanged, decode :canonical, still truthful) |
| 7 | refusal is pre-frontier, typed, `:not-entered`, cell untouched | S023, C007, C011, C012 (no refused invocation journaled an attempt event or moved a world byte) |
| 8 | revocation at the frontier (§11.6) | C011 (revoke between authorization and invocation → refused pre-frontier; mechanism named: prefix-staleness; the /0 fold names the revocation itself); authorization-side naming: C009 |
| 9 | fold-derived resolvedness; no stored resolved flag | S024 (the standing walk), S008 (no resolvedness field in any shape); mutant killed S028, C025; grep note in §4 |
| 10 | duplicate refuses pre-frontier · a reconciled seat frees · second reconciliation gets a disposition | C008/P017 · C017/P022 · C018/S025/P023 |
| — | the §11.4 subset + unresolved-effect restrictions at authorization | C002 (the aggregate authorization passes; each bullet's own refusal branch is exhibited separately — liveness C010/C011, unrevoked C009, effect-authorized C007/S019, attempt legality C008, seat fold C014) |

**The novel seam, demonstrated as such** (S009–S013): a journaled
`effect:uncertain` event rehydrates through kernel /0's **own**
`make-uncertain-effect` (UNC-1 re-validated at every fold) [S009];
kernel /0's **own** `check-retry-safety`, fed purely rehydrated records,
itself signals `unsafe-retry` [S010]; the extension-event projection is
explicit and counted [S011]; the pre-declaration W1 half is genuinely
this lane's addition — kernel /0's fold alone is silent on a
crossed-unsettled attempt with no §10.8 record, and the composed gate
refuses exactly there [S012]; and a rehydrated §14.2 receipt satisfies
kernel /0's own resolution predicate, so the prohibition lifts from
bytes end to end [S013].

**Negative controls** (each exhibits the intended typed predicate):
wrong/unauthorized effect (cell) → `cap2-effect-not-authorized` S019,
C007 · revoked at authorization → `cap2-attempt-authorization-refused`
naming the fold's reason C009 · stale authorization receipt at
invocation, both prefixes named → `cap2-stale-authorization` S020, C011
· invocation without authorization → `cap2-authorization-missing` S017 ·
authorization/capability mismatch → `cap2-authorization-mismatch` S022 ·
missing world → `cap2-world-missing` S018 · duplicate attempt identity
pre-frontier C008, P017 · blind retry same-life C014 /
from-bytes C015 / new-process P016 → `unsafe-retry` · inline uncertainty
→ `unstructured-uncertainty` C020, P018 · insufficient evidence (ledger
gone; nothing resolves) → `reconciliation-insufficient` C021 · nothing
uncertain → `cap2-nothing-uncertain` C022, S025 · both reconciliation
branches C016/C019, P021 · cell bytes byte-compared at every claim
(set-exactly-once C006, P026; double-apply counterfactual C016/S027) ·
truncated children C027, P012 · three mutants killed in both suites
S026–S028, C023–C025.

Gates run (exit codes + determinism shas in `RUN-EXITCODES.txt`):
selftest 29/0 · controls 27/0 · specimen 29/0, each twice, transcripts
byte-identical; regression: capability1 30/0 + 27/0 + specimen 29/0 with
transcript diffed byte-identical against its committed capture and its
ARTIFACT files re-verified (7 OK); capability0 28/0 + 36/0 + 24/0
byte-identical (4 artifact shas OK); journal0 66/0 + 89/0;
`verify-all.sh` 6/6 — every substrate untouched.

## 2. Design decisions, adjudicated to spec text

1. **Naming.** Lane is **Capability /2** (`mneme/capability2/`), the
   effect frontier over /1's mortal key. Specimen `de-effectu-incerto`.
   The *directory and package* names `capability2` /
   `de-effectu-incerto` are free of the rest of the tree (re-checkable:
   `grep -rln "capability2\|Capability /2\|de-effectu-incerto"`, run at
   repair time, whose only outside hit is the ruling next named); the
   *production* name **Capability /2** is not free — it is the owner's,
   from `mneme/RULING-capability1-arc-closure-2026-07-30.md` §"The next
   seam — NAMED, not opened", which also supplies this lane's governing
   sentence and the vertical §1 reports (ALLOWED-SOURCES.md carries the
   full accounting). No ordering claim beyond that.
   **Reserved names declined, each with its reason** (the /1 idiom):
   §19.5 `check-capability` implies the FULL §11.4 check — this lane
   implements a named subset (§2.3), so claiming the verb would claim
   the missing bullets; §19.3 `prepare-effect` / `cross-frontier` /
   `settle-effect` / `record-bounded-effect` /
   `record-indeterminate-effect` / `compensate-effect` and §19.2
   `begin-attempt` / `reconcile-attempt` / `supersede-attempt` name
   kernel-evaluator operations with full §12/§13/§14 semantics
   (compensation and supersession are not even present here); §19.4
   manifestation verbs — no manifestation machinery exists in this
   lane; `perform` and `mint-capability` are OCCUPIED by
   `lisp-plus-core0`, a closed lane, and colliding would shadow a
   working door. The entry points are the deliberately unreserved
   `authorize-effect-attempt` · `attempt-protected-effect` ·
   `declare-uncertain-effect` · `reconcile-uncertain-effect`.

2. **The world's jurisdiction split.** The adapter's two files are the
   fake OUTSIDE: not part of the PJ0 journal, never validated by it,
   never written by reconciliation — P026 exhibits the whole restart
   **byte-neutral** against it (cells and ledger sha256 unchanged);
   read-only-ness itself is by inspection of `reconcile.lisp`. The journal is the process's evidence; the
   world is what the effect touched; reconciliation is precisely the
   act of carrying a journaled identity (the external-request-id)
   across that line and asking the survivor. The asymmetry after the
   death — world knows, journal does not [P006/P007] — is the lane's
   subject, so the two jurisdictions are kept byte-visibly separate
   (separate directories, separate formats, separate digest lines in
   every transcript).

3. **The §11.4 subset, bullet by bullet** (authorize.lisp header is the
   in-code copy). IMPLEMENTED: *live* (fresh presentation through /1 —
   recognition, exact terms, fresh journal validation, four-facet
   binding); *unrevoked* (a fresh /0 fold at the current prefix — run
   FIRST, so a committed revocation is refused by name [C009] rather
   than masked by the object's own staleness [C010]; adjudicated order
   under §10.4 R-SYN-3's freedom to order independent checks
   deterministically); *requested effect is authorized* (the requested
   cell must BE the capability's resource, exact canonical equality —
   no pattern language); *scope within scope* (exact equality via the
   presentation's term discipline — a named degenerate case of the
   spec's "within"); *unresolved-effect restrictions satisfied* (the
   duplicate-identity gate + the composed retry fold, §2.5). NOT
   IMPLEMENTED, named: expiry, budget and call-count limits, principal
   roles. No budget/count/role/expiry field exists anywhere in the
   receipt — refusing to fake them is the honesty (the /1
   `capability-mint-receipt` precedent).

4. **The extension-event adjudication (the seam, argued and tested).**
   Storage side: the uncertain effect is journaled as kind
   `(id "effect" "uncertain")` — the PJ0 crash-window fixture grammar
   verbatim (cw3 frame 6), which is NOT in kernel0's closed
   `+kernel0-event-types+` and therefore travels as an explicit
   extension event under Kernel §13.3; the frozen fixture is the
   corpus's own exhibit of how Mneme stores this fact, so the byte side
   follows it. Fold side: this lane's rehydration projects the stored
   event to kernel `:effect-bounded` — not `:effect-indeterminate` —
   because the stored record names a finite duplicate-free alternatives
   set ({cell-written, cell-not-written}), which is §7.3's definition
   of BOUNDED standing; mapping to `:indeterminate` would discard the
   bound the record carries. §9.4 requires a `:bounded`/`:indeterminate`
   effect **axis** to reference a structured §10.8 record; **this lane
   reads that as satisfied** by attaching the rehydrated record as the
   projected event's payload, so kernel0's own payload conventions
   re-validate it on every fold (`rehydrate.lisp`). That is our reading,
   not a conformance claim — no §9.4 conformance is asserted (§3). For
   the retry law
   the choice is load-neutral (kernel0 counts both kinds identically —
   exercised S010); the adjudication is therefore about truthful
   standing, not about reaching the refusal.

5. **The retry gate is composed of two halves, each load-bearing where
   the other is silent** (S012 is the exhibit). (a) The STRUCTURED
   half: kernel /0's own `check-retry-safety` over rehydrated records —
   once the §10.8 record is journaled, *it* carries the prohibition,
   and only a rehydrated §14.2 receipt satisfying kernel0's own
   resolution predicate lifts it (S013). (b) The PRE-DECLARATION half,
   this lane's addition, adjudicated from §10.3 + AP0 W1/AP-CRASH-4: a
   process that dies after journaling `frontier-crossed` and before
   journaling anything else leaves no record for the kernel fold to
   count — yet "after send, before reliable response" is exactly W1,
   whose required fold disposition is *unresolved uncertain effect; no
   blind retry*. So any attempt in the seat that crossed the frontier
   with neither journaled settlement nor journaled reconciliation
   refuses dispatch. Without (b), the crown law would hold only after a
   declaration the dead process never got to make.

6. **Where the retry gate runs — and why invocation does not re-fold.**
   The §14.1 fold runs at AUTHORIZATION (§10.4 step 5's home in this
   design). At INVOCATION, "no unresolved predecessor" is established
   by conjunction: the authorization gate ran at prefix P, and every
   journal event that could create a new unresolved predecessor moves
   the prefix, which refuses at invocation as
   `cap2-stale-authorization` before any dispatch (C011). A second fold
   at invocation would be an unreachable gate on the strict path — no
   state reaches it — and this lane does not plant unreachable gates
   (the /1 §2.14 discipline). The same conjunction is the §11.6
   re-check: a revocation between authorization and invocation
   necessarily moves the prefix and is refused pre-frontier; the
   mechanism is prefix-staleness plus re-check, **not** an atomic
   authority ledger — that ledger is the escalation remedy named in
   E6's refutes-branch (`mneme/EXPERIMENTS.md` §E6, gated from
   `CONSTITUTION.md`), and neither it nor a no-TOCTOU property is
   claimed here.

7. **Settlement is a derivation, not a promotion (AP-ACK-4 in
   executable form).** The acknowledgment is journaled as testimony
   carrying its class and, when the adapter held it, evidence digests.
   The settlement branch then re-reads the world — ledger entry by
   request identity, recomputed digest, cell bytes — and journals
   `effect:settled` only when the evidence verifies; an
   evidence-free or unverifiable acknowledgment yields the §10.8 record
   instead. The `:ack-promotes-to-settled` mutant is exactly the
   forbidden promotion and dies in both suites. AP0's acknowledgment
   vocabulary is used where honest (`:provider-terminal`,
   `:acknowledgment-ambiguous`) without claiming the closed ladder's
   semantics; the adapter emits only classes it genuinely witnesses —
   **by construction, not by a declared witnessable set: AP0's
   adapter-descriptor declaration (AP-ACK-2) is not implemented (§3).**

8. **What is journaled and what is not.** Journaled: attempt, effect,
   acknowledgment, and reconciliation EVENTS — primary facts whose
   absence would erase the prohibition the journal exists to carry.
   Not journaled: queries, authorization receipts, presentation
   receipts (derived state over a validated prefix — the /0 L9 and /1
   §2.10 adjudications carried forward; S016), and preflight refusals
   (pre-frontier, `:not-entered`, re-derivable from the same prefix;
   §13.3's fuller event vocabulary — `attempt:refused` etc. — is
   reserved, not contradicted, and §13.5's "refusal cannot follow
   frontier crossing" is never reached: nothing in this lane ever
   reaches a post-frontier state that §9.2 would forbid rewriting, and
   the controls verify refusals leave zero frames [C012]).

9. **Reconciliation's two directions are one settlement class.** Both
   branches journal `attempt:reconciled` with resulting effect value
   SETTLED (§10.3's terminal) and the direction — `:applied` /
   `:not-applied` — as its own field with its own evidence; the live
   §14.2 receipt is constructed through kernel /0's own validating
   constructor BEFORE the event is appended, and kernel0's
   `%reconciliation-resolves-effect-p` is the predicate that frees the
   seat (via rehydration, S013). Empty evidence is unrepresentable:
   kernel0's constructor itself signals `reconciliation-insufficient`,
   and an unanswerable world (ledger gone) refuses with the same type
   before any receipt exists [C021] — refusal resolves nothing (the
   standing stays uncertain and the gate still refuses, checked in the
   same control).

10. **Determinism and the planted interruption.** Fixed nonces
    (declared PJ-META-1 deviation), declared identities, derived
    external-request ids (`external-request:cap2:<attempt>`), no clock
    anywhere. The interruption is a deterministic env-var early exit in
    the ADAPTER's acknowledgment path — after durable apply + ledger
    append, before return — the capability1 planted-death precedent.
    Honestly bounded: no SIGKILL, no mid-instruction truncation
    (de-teste-occiso owns real crash-window truncation); what is
    exercised is byte-equivalent to any death in that window as far as
    surviving state is concerned, and that equivalence — not the death
    mechanics — is what the lane's claims rest on. The
    `:request-lost` interruption keyword is the mirror seam (frontier
    journaled, world never reached), used by controls for branch (b).

11. **Condition homes** (never both for one meaning): reused —
    kernel0's `unsafe-retry` (signaled by kernel0's own fold where the
    record exists; by this lane's W1 scan where it cannot yet),
    `duplicate-attempt-identity`, `unstructured-uncertainty`,
    `reconciliation-insufficient`; /1's and /0's refusals propagate
    unwrapped. Own-minted, each with its why-not-substrate adjudication
    inline in `conditions.lisp`: `cap2-world-missing`,
    `cap2-authorization-missing`, `cap2-authorization-mismatch`,
    `cap2-stale-authorization`, `cap2-effect-not-authorized`,
    `cap2-attempt-authorization-refused`, `cap2-nothing-uncertain`.

12. **The effect declaration.** Kind `:external-write` (§10.1
    vocabulary; the cell write is also honestly a `:tool-action` — the
    declaration names the primary kind), class `:irreversible` (§10.2:
    the ledger append cannot be unmade and no compensation machinery
    exists in this lane; declaring `:compensable` would advertise a
    verb this lane declined). Both are stated in the authorization
    receipt and the prepared event.

## 3. What this return does NOT claim

- **not Vertical Specimen /0** — a first, deliberately partial
  inhabitant of the Deterministic-fake-adapter board lane; ONE
  interruption point (board point 2) exercised, points 1/3/4 untouched;
  no streams/chunks/ordering/journal-before-delivery; no derived final
  view, no finalization-loss trial; VS/0's four-trial obligation and its
  capability-interaction, duplicate-behavior, and negative-control
  obligations remain entirely open; **nor is this the board's 4c-ii
  CROSS-DEATH specimen** — one of its four placements, one interruption
  point, and no Core /0 result is cited as it;
- **nothing outside this lane is reopened** — Capability /1 and
  Journal /0 stay closed at their rulings, Language Obligation /0 stays
  unopened, the second-inhabitant ruling
  (`mneme/RULING-obligation-second-inhabitant-2026-07-29.md`) is not
  reconsidered, and `_staging/synthesis-01/` stays staged,
  non-governing, and separate (owner's word, capability1 arc-closure
  ruling);
- **no AP0 conformance** — no descriptor completeness, no AP-FAKE-3
  terminal-fixture coverage, no closed acknowledgment ladder; the world
  is a controlled effect adapter under a labeled AP0 subset, and
  nothing here is "independently verified" (AP0 adoption riders);
- **no full §11.4** — no budgets, counts, roles, expiry (named subset,
  §2.3); the §19.5/§19.3/§19.2/§19.4 reserved verbs stay unclaimed;
- **no atomic authority ledger and no no-TOCTOU property** — the
  check-then-effect gap is closed by prefix-binding + re-check at the
  frontier; the atomic ledger is the escalation remedy named in E6's
  refutes-branch (`mneme/EXPERIMENTS.md` §E6, gated from
  `CONSTITUTION.md`), and neither it nor E6's no-time-travel claim is
  claimed here;
- **no compensation, no supersession, no manifestation machinery, no
  derived views** — reserved to later slices;
- **no SIGKILL, no real crash-window byte truncation** — the
  interruption is a planted deterministic early exit (§2.10);
  de-teste-occiso owns real truncation;
- **no general PJ0→kernel0 rehydration** — the seam covers this lane's
  six event shapes under a closed vocabulary;
- **no host-process adversarial security, no cryptographic
  authenticity, no distributed authority** — /1's boundaries hold
  unchanged here; anyone who can write the store or the world files can
  rewrite history: the discipline is structural, not adversarial;
- **no idempotency** — the adapter declares none, deliberately (§14.5);
- **no live providers, no spending, no standing service** — the world
  and its adapter are per-run fixtures, so none of Kernel §0.4's
  non-authorized acts (live provider calls, spending, creation of a
  standing authority-custody service) is performed — §0.4 is a
  non-authorization clause and grants no carve-out;
- **durability is declared, not proven** — FINISH-OUTPUT, no fsync
  claim, the journal0 standing;
- **capability1, capability0, journal0 unchanged** — consumed through
  exports; all remain candidates (journal0 §32.5 FULL not claimed);
- **no adoption, no freeze, no floor, no audit** — candidate status
  only; `verify-all.sh` is the CD/0 floor and does not sweep this lane;
- **all greens are same-family self-consistency; no stranger audit was
  commissioned** — the same hand wrote the world, the door, and the
  checks.

## 4. Verification discipline notes

- Every "demonstrated" above traces to a numbered check in this lane's
  captured transcripts (S/C/P; uncommitted at the time of writing — the
  chair commits), and every "verified" either exhibits its step there
  or is written against `RUN-EXITCODES.txt` sha lines — with the named
  exceptions, compressed: (i) the SBCL operation-check in the
  `RUN-EXITCODES.txt` header is asserted, its output not
  transcript-preserved; (ii) the substrate regressions are trusted on
  THEIR transcripts (30/0 + 27/0 + 29/0-byte-identical + 7 artifact
  shas, 28/0 + 36/0 + 24/0-byte-identical + 4 shas, 66/0, 89/0, 6/6 —
  all re-run this session), not re-derived, and those are candidates'
  own suites covering only what they claim; (iii) the name-freeness
  greps (§2.1) — re-run at repair time with the corrected pattern
  (`"capability2\|Capability /2\|de-effectu-incerto"`), whose one
  outside hit is the capability1 arc-closure ruling, the owner's source
  of the production name and governing sentence (ALLOWED-SOURCES.md);
  output not preserved, re-checkable; (iv) the "no stored resolved flag anywhere" claim is
  carried by S008/S024 plus a grep of the lane for `RESOLVED.flag`
  (exactly one reader, in the guarded mutant branch of
  `check-retry-safety-from-store`; one planter, in the kill harness;
  no strict-path writer) — re-checkable, output not preserved; (v) the
  specimen transcripts were re-captured after a check-numbering repair
  (noted in `RUN-EXITCODES.txt`); the recorded shas are of the
  post-repair pair.
- Gate teeth are permanent (three planted mutants + planted-fault +
  two die-children + the specimen's window death live inside the
  suites), not one-off demonstrations; each has been seen to fire
  (`RUN-EXITCODES.txt`, "Gate teeth").
- The `:interruption` keyword and the `defect` keywords are test seams,
  guarded by explicit keyword checks; the strict paths (all NIL) never
  enter them. They are part of the public surface deliberately, so the
  suites exercise the same door production callers get.

— CLAVIGER-III (Claude Fable 5 subagent), 2026-07-30
