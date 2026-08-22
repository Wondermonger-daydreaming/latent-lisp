# MEMORY LAYER /0 — RETURN (candidate, first slice)

*TABULARIUS (Claude Opus 5, subagent), 2026-08-20. Built under
`MEMORY-LAYER-0-WORK-ORDER.md` + its AMENDMENT 1, which enters Sol's cold design
read; the commission is Sol's relay of the same day.*

**CLAIM CEILING, verbatim and in front of everything else:**

> **candidate · not audited · not adopted · not frozen · not registered ·
> same-family hands · planted-death only · capability-disciplined never
> capability-secure · no independent verification**

---

## The eight required items, in the commission's order

### 1. The exact durable semantic object created

**`memory-account`** — one canonical, language-level, durable account of ONE act,
written by one process and reconstructible by another. Its durable form is a
single PJ0 frame: the adopted **ten-field envelope** wrapping an **eighteen-entry
CD/0 body**. All durable values are CD/0 (nine families only); no host condition,
closure, pathname identity, current-image token, or unprintable object is retained
as semantic state.

Its identity is **content-derived** — a SHA-256 over the whole canonical body,
domain-separated — and lives in the **existing** kernel /0 domain **`:claim`**: an
account is a *claim about* an act, not the act and not a receipt of one.

The envelope's four provenance constants differ from capability /2's, deliberately
and for the same reason One Act /0's differ:

```
capture-boundary   boundary:memory-accounting
capture-mechanism  witness:lane-self-report
origin             origin:self-reported
recorder-principal principal:memorylayer0
subject-principal  principal:<the actor>
```

**`origin/observed` is UNMINTABLE by this lane in code** — the gate sits on the
only identifier constructor the lane uses and refuses those two segments with
`ML0-ORIGIN-1`. One Act /0's own prohibition (`act0-gates.lisp:114-119`) is this
lane's law too: a lane may not write a capture-provenance claim into durable bytes
it cannot support, and this lane does not witness a kernel transition — it reads
the bytes of a lane that did.

The six commission questions are independently answerable; the two lane-local
discriminants are separate fields that share no code path; and a third field
(`record-coverage`) is on neither axis. Full field table: **SPEC §5–§6.**

### 2. The exact source species that can and cannot warrant occurrence

**MAY warrant occurrence** (three, and the reason is one sentence: each inspects
facts that *would not become true merely because an evidence object was minted*):

- `:kernel-mediated-journal` — capability /2's frames, read via the public fold
  over the **validated prefix**
- `:world-bytes` — the world's own files: the ledger row under the act's derived
  external-request identity, and the fixture digests
- `:reconciliation-conjunction` — `act1-reconciliation-closes-seat-p`, a joint
  reading of world **and** journal

**MAY NOT, by law:**

- `:lane-self-report` — ANY `origin/self-reported` narrative, **including every
  account this lane writes**. May corroborate, may provide provenance, may never
  be the sole occurrence basis. *(AP-JRN-1's clause, carried across.)*
- `:core0-issuance-testimony` — a Core /0 evidence account, its digest, its
  receipt, or a report describing it. **Occurrence, in any direction, ever.**
- `:scoped-negative-observation` — nonoccurrence only, and only with the
  four-part warrant. *(AP-REC-1's clause.)*
- `:account-reconstruction` — account integrity only; never an origin upgrade,
  never occurrence, never issuance.

The species set is **closed** and the test is a `member`, not a default: an
unknown species is **refused**, never silently demoted to corroboration.

**And species is only leg 1 of eight.** The full conjunction, with a requirement
id per leg, is in SPEC §7. **Leg 8 (attestation) was found by building, not by
design** — see §8 below.

### 3. The D2 result, in public-reader terms

> A lawfully refused act — `:authority-mode :ambient`, refused by Core /0 at its
> own authority check — **genuinely issued** a Core /0 evidence account bound to
> that act's canonical request (`core0.lisp:1059-1082`, "ISSUANCE SITE 1 of 4").
> Measured in the same transcript: the journal's frame count **did not move**, the
> derived effect standing was **`:ABSENT`**, and the world was **byte-unchanged**
> across its whole declared universe. **The act did not happen and the certificate
> exists.**
>
> That artifact was presented to Write as though it warranted occurrence, with
> **every non-species conjunct over-claimed** — the same act identity, the same
> acquisition route, the same declared scope, the same observation interval, the
> same attestation, a 64-hex payload digest. **Seven of the eight legs hold.**
>
> **Then, and after a fresh-process retrieval, and after consolidation with a
> second reading of the same act: NO PUBLIC READER ANSWERS OCCURRED.**
> `ml0-account-occurred-p` → `NIL`. `ml0-account-occurrence-standing` →
> `:UNRESOLVED`. `ml0-account-issuance-only-p` → `T`. The issuance fact is
> **remembered**, on its own axis, as `:ISSUED-IN-WRITING-IMAGE`.

**Which conjunct answered, printed and preserved** (work order AMENDMENT 1.2;
the table is in `RED-PROOF-ISSUANCE-AFTER.txt` and in the specimen capture):

```
row A — the LAWFUL occurrence bundle (species world-bytes)
    species      [ML0-PROMOTE-1] : yes      … all eight: yes   =>  PROMOTED
row B — the SAME act, SAME everything, species core0-issuance-testimony
    species      [ML0-PROMOTE-1] : NO  <== this leg answered
    attestation  [ML0-PROMOTE-2] : yes
    subject-identity [ML0-PROMOTE-3] : yes
    acquisition-route [ML0-PROMOTE-4] : yes
    declared-scope [ML0-PROMOTE-5] : yes
    frontier-relation [ML0-PROMOTE-6] : yes
    canonical-payload [ML0-PROMOTE-7] : yes
    provenance   [ML0-PROMOTE-8] : yes      =>  refused
```

The rule's own words on row B: *"no source satisfied the conjunction; the closest
candidate (species CORE0-ISSUANCE-TESTIMONY) failed first at leg SPECIES
[ML0-PROMOTE-1]."*

**The single-delta pair is built on the SETTLED act**, where a genuinely complete
bundle of both species exists, so the pair are near-neighbours and not a strong
row beside a hobbled one. **On that pair the act DID occur** — and the cured rule
still refuses row B. That is the sharper half of the law: *an inadmissible warrant
yields `:unresolved` even when its conclusion happens to be true.* A rule that
promoted there would be right by luck, and right by luck is the thing a memory
layer cannot afford. The crown negative proper — where the consequence bites —
runs on the refused act.

**RED / GREEN, preserved as artifacts, exits walked:**

| Capture | Command | Exit |
|---|---|---|
| `RED-PROOF-ISSUANCE-BEFORE.txt` | `ml0-red-proof.lisp uncured` | **1** — the tooth DOES NOT HOLD, and must not |
| `RED-PROOF-ISSUANCE-AFTER.txt` | `ml0-red-proof.lisp cured` | **0** — the tooth HOLDS |
| both arms | `ml0-red-proof.lisp` | **0** — `cured PASS, uncured FAIL — the tooth bites` |

Under the planted `:issuance-implies-occurrence` seam the very same bundle is
promoted, the account **durably reads `:OCCURRED`** for an act whose journal
frames never moved and whose world is byte-unchanged, and consolidation carries
that forward. The mutant alters **only** the forbidden admission `Core evidence ⇒
occurrence basis`, at two depths; nothing else about the rule changes, which is
what makes the RED row attributable.

### 4. The cross-process D1 result, and the proof that retrieval did not perform

`de-actu-memorato`, **five processes**: orchestrator · **scriptor** (acts, writes,
exits with its Core /0 evidence) · **moriturus** (dies in the acknowledgment
window against its own store and world) · **vulneratus** (damage, on copies) ·
**lector** (a genuinely new process). **44 checks, 0 failures, exit 0.**

The lector, given only durable bytes and the declared configuration:

| | Result |
|---|---|
| **act identity byte-equal under re-derivation** | ✅ re-derived from (domain · runtime seat · canonical request), touching nothing the scriptor left in memory |
| **occurrence warranted by the independent basis** | ✅ and the rule, **re-run** over the retrieved sources, names a species that reads facts a mint cannot make true |
| **issuance reported separately** | ✅ `:ISSUED-IN-WRITING-IMAGE` — read as the scriptor's testimony, never re-verified, never quotable flat |
| **retrieval did not re-perform** | ✅ after four retrievals the **account store**, the **act journal** and the **world** are each byte-unchanged, and the journal's frame count has not moved |
| **no Core /0 evidence minted or carried** | ✅ the account is not a `core0-evidence`; nothing reachable from its public surface is one; nothing reachable is registered as issued here |
| **no continuation lawful** | ✅ D4, below |
| **the reader is not the actor** | ✅ subject principal = the scriptor's; recorder = this lane's; retrieval origin `:RECONSTRUCTED` |

And at the level of the whole capture: **the final account store is a byte-prefix
extension of the store the scriptor left** — the writer's frames are literally the
first bytes of the final file. Nothing was rewritten. /0 never compacts, never
tombstones, never erases provenance.

**D4 — the invariant, and the condition name recorded rather than forced** (work
order AMENDMENT 1.4). The work order predicted `unissued-evidence`. What actually
happens is **earlier**:

- `continue-from` on a retrieved memory account signals **`MALFORMED-REQUEST`** —
  Core /0's issuance check sits *below* its basic type check, so the account is
  rejected for not being evidence at all, before any question of *whose* evidence
  it is can arise. Lawful, and sharper.
- **The invariant is proved**, which is what outranks the name: no continuation
  result returned, no receipt, no evidence minted, no authority acquired, no
  ledger consulted — world and act journal byte-unchanged across the attempt, and
  the image still holds no issued evidence of any kind.
- **The competence half**: on the reader's own scratch ground a genuinely issued
  Core /0 account answers the issuance predicate **TRUE** and reaches
  `continue-from`'s *later* rungs, signalling `AMBIENT-AUTHORITY-FORBIDDEN`. So
  the boundary is reachable, the instrument can say yes, and the memory account's
  refusal is a **discrimination** rather than a wall that refuses everything.
- **Nothing was wrapped, counterfeited, or exported to force a condition name.**

**D3 — the other direction, which is the absence One Act /1 named.** The moriturus
crossed the frontier, the world durably applied and ledgered the write, and it
died before any acknowledgment. Its journal validates `:VALID` with exactly three
frames ending at `attempt:frontier-crossed`; its world holds the written cell and
one ledger row. **No account of that act existed anywhere.** The lector — a
process that was not there — writes the first and only durable, language-level
account of it, from the independent basis alone: **`:occurred`, issuance
`:unresolved`**, every source's acquisition route `:reconstructed`.

**Never `not issued`**, and the reason is in the transcript one line above it: in
this image `core0-evidence-current-image-issued-p` answers **false for every
possible input** (checked against a string, `NIL`, a keyword and an integer). An
instrument with no power to detect presence cannot warrant absence. What *this
store* holds is a different question, on its own field, and this process **is**
competent over it: `record-coverage :no-issuance-record-in-account-store`, scope
declared.

### 5. Dependency standings — quoted, not softened

| Lane | Standing | What travels |
|---|---|---|
| Canonical Datum /0 | **ADOPTED** | the nine families are the durable boundary |
| PJ0 **spec** | **ADOPTED** | R-PJ-3's binding gate |
| journal0 **impl** | **CANDIDATE** | §32.5 FULL not claimed; "independently SEEDED under shared normative infra"; no stranger review |
| kernel0 impl | **CANDIDATE** | — |
| Capability /0 | **CANDIDATE (by default)** | no owner acceptance exists |
| Capability /1, /2 | **ACCEPTED (candidate)** | in-process, non-adversarial recognition |
| Language Core /0 | **ACCEPTED (candidate)** | `continue-from` image-local **by law**; no public evidence constructor; "This is NOT crash-survival" |
| One Act /0 | **ADOPTED** | stranger primitive-minimization audit **WAIVED BY OWNER VARIANCE, NOT PASSED**; crash model ONE PROCESS LIFE |
| **⚠ One Act /1** | **⚠ CANDIDATE — registered on the floor, NOT adopted, NOT audited, NOT frozen** | **THIS STANDING TRAVELS WITH EVERY DEPENDENCY CLAIM THIS LANE MAKES.** Planted deterministic death only. Capability-**disciplined**, never capability-**secure**. A green row is not a ruling. |
| **Memory Layer /0** | **CANDIDATE** | this build |

**The durability ceiling, quoted and never widened:**

> canonical bytes are carried across a fresh process by an **ADOPTED-spec,
> CANDIDATE-implementation** journal store whose durability is a **declared
> fsync-barrier host-contract belief on Linux ext4**, demonstrated against a real
> SIGKILL at one governed progress point **in a separate specimen** — never power
> loss, never adversarial tampering, never a storage-stack proof.

**This lane's own crash model: PLANTED DETERMINISTIC PROCESS DEATH ONLY** — an
env-var-controlled `sb-ext:exit` inside capability /2's world adapter. No SIGKILL
of this lane's own. `journal0/de-teste-occiso` owns SIGKILL at the store level and
is **cited, never annexed**.

**The compound ceiling, stated once:** an ADOPTED CD/0 + ADOPTED PJ0 spec +
ADOPTED One Act /0, sitting on CANDIDATE or ACCEPTED-candidate *implementations*
of everything below, verified by **self-consistency certification, never
independent conformance**, with a stranger audit owed on nine lanes. **This lane
cannot be stronger than its weakest load-bearing dependency, and its most
load-bearing dependency — One Act /1's public seam — is the least-settled thing
in the stack.**

### 6. Base / head / tree / diff scope / commands / exits / counts

**Base commit: `e683cd0c14ccd1172d662eddb3ab61893071fe24`.** The recon opened at
`61d440cf`; the lab's `session-checkpoint` Stop hook committed
`tools/ledger/agents.jsonl` mid-run, moving HEAD. **The subject tree
(`experiments/latent-lisp/`) is byte-identical at both**, so the recon's floor
result applies unchanged to `e683cd0c`. The lane opened at the chair's work-order
commit **`c73e0b24`**; AMENDMENT 1 entered at **`4210fddc`**.

**DIFF SCOPE, proved rather than promised.** Within the subject tree, since base:

```
$ git diff --name-only e683cd0c..HEAD -- experiments/latent-lisp \
      ':(exclude)experiments/latent-lisp/mneme/memory-layer-0'
                                                            <- EMPTY
```

**Zero bytes changed** in `lisp-plus.asd`, `mneme/verify-release.sh`,
`language-act-0`, `language-act-1`, `language-core-0`, `journal0`, `kernel0`,
`capability0/1/2`, `canonical-datum`, or `architecture` — confirmed by an empty
`git diff --stat` over exactly those paths. **`tools/latent-lisp/SYNC-PAUSED` is
byte-untouched** (empty `git status` over `tools/latent-lisp/`). Paths outside the
subject tree in the commit range belong to the **chair's** own commits (a basin
piece, an epistle, a playground toy, the archived relay) and to the harness's
ledger checkpoint — none of them this builder's.

**THE GATE TABLE.** Every exit below was taken with `$?` immediately after the
command, in the same shell line, in this capture — **walked, not inspected.** The
full transcript is `RUN-EXITCODES.txt`.

*This lane (six gates; the lane is **NOT** registered on any floor):*

| exit | gate | count line |
|---|---|---|
| 0 | `ml0-selftest.lisp` | `ml0-selftest: 66 checks, 0 failures` |
| 0 | `ml0-controls.lisp` | `ml0-controls: 10 controls, 10 caught, 0 missed` |
| 0 | `ml0-mutants.lisp` | `ml0-mutants: 6 defects, 6 killed, 0 survivors` |
| 0 | `ml0-red-proof.lisp` | `ml0-red-proof: cured PASS, uncured FAIL — the tooth bites` |
| 0 | `ml0-host-fault-proof.lisp` | `ml0-host-fault-proof: PASS` |
| 0 | `de-actu-memorato/run-specimen.lisp` | `de-actu-memorato: 44 checks, 0 failures` |
| **1** | `ml0-red-proof.lisp uncured` | **nonzero on purpose** — the preserved RED capture |
| 0 | `ml0-red-proof.lisp cured` | the preserved GREEN capture |

All six run at **zero compiler warnings**.

*Consumed-lane regressions (see `RUN-EXITCODES.txt` for the walked exits):*
act0 selftest **173/0** · act0 load-witnesses **6/6 green, tooth caught** · act0
loader-disease · act1 selftest **37/0** · act1 host-fault-proof **PASS** · act1
controls **14/14 caught, 0 missed** · act1 mutants **3/3 killed, 0 survivors** ·
act1 red-proof **the tooth bites** · `de-actu-resurgente` **49/0** · capability2
selftest **29/0** · capability2 controls **27/0** · `de-effectu-incerto` **29/0** ·
core0 selftest **29 passed / 0 failed**. Every one exit 0.

⚠ **Two defects in the CAPTURE, not in any gate, are corrected at the tail of
`RUN-EXITCODES.txt` by RE-RUNNING rather than by editing the rows above** — four
rows had their authorized count line eaten by that capture's own `grep`, and the
D8 sha was eaten by shell quoting. A walked-exit record edited by hand is no
longer a walked-exit record, so the original rows stand and the corrections sit
beside them with their own walked exits.

*The full release floor* — `cd experiments/latent-lisp && bash
mneme/verify-release.sh`:

> **`FLOOR RESULT: PASS (103 executable gates attempted / 103 passed / 0 blocked;
> 8 carried status rows; profile full)`  ·  `FLOOR_EXIT=0`**
> checkout cleanliness: *"unchanged: zero tracked modifications, zero new
> untracked litter."*

**This lane is NOT among the 103 gates**, by the commission's writ, so the floor
is evidence of exactly one thing: **building this lane left every other lane as it
found it.**

⚠ **AND IT TOOK TWO RUNS, BECAUSE THE FIRST ONE WAS THE BUILDER'S FAULT.** Run 1
came back **FAIL, 102/103** — gate #85, `act0-loader-disease.sh`, with **4/4
detections and 4/4 controls passing** and the failure on **run integrity**:
*"the checkout changed during the disease run"*, naming this lane's own
`RUN-EXITCODES.txt` and `ml0-controls.lisp`. Diagnosis, read out of the script
(`act0-loader-disease.sh:53,175-179` snapshot the whole repository's porcelain
before and after and compare): **I committed to the repository while the floor was
running.** The gate is right and its check is a good one — a disease harness that
mutates replicas must be able to prove it left the real tree alone, and it cannot
prove that while someone else is moving the tree.

Run 1 is recorded in `FLOOR-RESULT.txt` rather than discarded, because quietly
re-running until green is the exact move this lane exists to refuse elsewhere.
**Nothing about any lane's correctness follows from run 1 in either direction.**
Run 2 was taken with the tree quiescent — no commit, no edit, no write between
its start and its finish — and gate #85 passed at exit 0.

Full detail, both runs, in **`FLOOR-RESULT.txt`**.

**Six mutant deaths**, each planted in the SHIPPED code (a `:defect` seam,
production NIL) or driven by a mutant CALLER over the shipped code — never in a
copy of the logic:

| # | Forbidden collapse | cured / diseased |
|---|---|---|
| 1 | **issuance-implies-occurrence** (the crown) | `T` / `NIL` |
| 2 | **retrieve-reperforms** | `T` / `NIL` |
| 3 | **retrieve-mints-or-promotes-to-current-image-evidence** | `T` / `NIL` |
| 4 | **consolidation-last-write-wins** | `T` / `NIL` |
| 5 | **provenance/scope dropped** (`:could-not-look` masquerading) | `T` / `NIL` |
| 6 | **origin upgrade on successful readback** | `T` / `NIL` |

A predicate false under *both* implementations is reported as a **SURVIVOR**, not
quietly counted as a kill.

**Ten two-halved controls, 10 caught, 0 missed** — every tooth exercised once
against the lane as it ships and once against a diseased caller or a planted seam,
and **no blanket refusal can pass**: where a tooth is a refusal there is a
same-shape control that must SUCCEED (control 8's matching-identity write reads
`:OCCURRED`).

**Deterministic comparisons:**

- **D8** — the complete specimen run twice from clean equivalent fixtures:
  **byte-identical**, `cmp` exit 0, sha256 of both transcripts
  `80d4cba0a6af8404b973fc03965e542f80d99d21d40df1d2e1c58a44ad73aea4`.
- the preserved GREEN capture reproduced byte-identically across runs.
- eleven `ARTIFACT-*` files preserved with a `ARTIFACT-SHA256SUMS.txt` manifest,
  each digest checked against the live bytes it copies.

### 7. Limitations, stated without inflation

1. **Nothing here is independent verification.** Builder and chair are one
   lineage; every gate is this family's code checked by this family's checks.
   Sol's cold design read was a **design** read, before execution, and is entered
   as AMENDMENT 1 — not an execution audit. **No stranger has reviewed this lane.**
2. **The crash model is planted deterministic process death only.** No SIGKILL of
   this lane's own, no power loss, no mid-instruction truncation, no adversary.
3. **Capability-disciplined, never capability-secure.** No cryptographic claim is
   made or implied anywhere, and the account identity is a content digest for
   *distinctness*, not for *authentication*.
4. **`:contradicted` is not naturally reachable in this slice.** Two correct looks
   at one universe over one interval agree by construction, so the commensurable
   clash had to be **constructed** (a forced attestation, modelling a mistaken or
   tampered observation). What is demonstrated is that the layer *preserves* such
   a clash; what is **not** demonstrated is one arising naturally. Said in the
   code, the transcript, and SPEC §9.
5. **The world is one deterministic fake world, one seat family, one effect kind.**
   Nothing here says anything about a real provider.
6. **The issuance testimony is image-local and unverifiable downstream by
   construction.** A later reader takes `:issued-in-writing-image` as testimony or
   leaves it; this lane gives it no way to check.
7. **D4's condition name is `MALFORMED-REQUEST`, not the predicted
   `unissued-evidence`.** The invariant is proved; the name is recorded.
8. **The lane is NOT registered** in `lisp-plus.asd` or `verify-release.sh`, and
   the floor's 103 gates do not include it.
9. **No account here has been ruled on.** A green row is not a ruling.

### 8. Every hole encountered and left unpatched

**In this lane's own design, disclosed rather than closed:**

- **Readback trusts the durable STANDING; it does not re-derive it from the
  retrieved sources.** An account whose `occurrence-standing` disagrees with its
  own source rows would be read back at face value. Three things bound that, and
  the third was checked rather than assumed:
  1. it can only be *produced* by a writer running a diseased rule — which is
     exactly what the RED proof exhibits, and why the demonstration lives at
     write time;
  2. the account identity is a digest of the **whole body**, and the frame's
     event-id carries that identity, so an edit to the standing makes the two
     disagree and `ML0-RB-11` refuses;
  3. **checked, and now a permanent tooth:** editing the string `unresolved` →
     `occurred  ` in place in a real account store — a length-preserving,
     semantically meaningful lie, the edit an adversary would actually want — is
     refused at `ML0-RB-1`, because PJ0's own frame-digest chain rejects the
     prefix before this lane's consistency check is even reached. The lane's
     check is defence in depth *behind* the substrate's, not the only guard.
     This is now the **third damage mode of CONTROL 10**, with the file's length
     asserted unchanged (121740 → 121740 octets in the captured run) and the
     control erroring loudly if it cannot find a standing to forge — a control
     that edited nothing would have refused nothing and passed. **It is not a
     security claim:** adversarial tampering stays outside every claim in this
     lane, and the row establishes only that the naive edit does not survive.

  A Memory Layer /1 should still consider re-running the rule at read time.
  It is **not** done here because it would relocate the crown demonstration from
  write to read, at the end of a build in which every gate has already been
  walked — a change worth making deliberately, in its own slice, and not as a
  late tidy.

- **No public evidence identity or content digest exists.** Core /0's
  `%core0-issuance-content` is internal, and exporting it would have tripped the
  commission's second stop condition. **Routed around, as the work order §10
  directs**: an issuance source's coordinate is a *caller-side projection* over
  public readers, and the durable record says `basis:
  caller-supplied-projection` in its own bytes. It is not an evidence identity,
  and two evidence accounts with the same projection are not thereby the same
  account. **No Core /0 export was requested and none is wanted.**
- **`:contradicted`'s natural unreachability** — limitation 4 above.

**Found in consumed lanes and REPORTED, NOT REPAIRED** (relay §8: *"Do not repair
docket items in consumed lanes while here; report them separately"*):

1. **`mneme/language-act-0/package.lisp:7`** still reads *"STANDING: CANDIDATE.
   Nothing in this lane is adopted…"* while One Act /0 was **ADOPTED** on
   2026-08-08. Stale-conservative, but false. *(Already on One Act /1's docket;
   re-confirmed on disk here.)*
2. **`mneme/verify-release.sh`** carries both the pre-adoption comment *"ONE ACT
   /0 … IS AN UNADOPTED CANDIDATE"* and the `seam|ADOPTED|…` DECLARED row, in one
   shipped file.
3. **`ONE-ACT-1-RETURN.md:298,349`** state the lane's API export count as **103**
   while `load.lisp:115` enforces **104**. The code's value governs; the RETURN
   text was not amended after the host-fault repair added
   `act1-fixture-host-fault-plant`.
4. **`ONE-ACT-1-RETURN.md` §5 gap 6** ("No ASDF row") is **superseded by fact** —
   the chair added `lisp-plus/act1` (`lisp-plus.asd:782`) with exactly the
   predicate the gap named.

**A SEMANTIC ASYMMETRY FOUND LATE AND CLOSED (`ML0-WR-6`).** If one bundle
carried BOTH a qualifying positive warrant AND a **commensurable** scoped
negative, the promotion rule would answer `:occurred` — occurrence is checked
first — and consolidating that very account with itself would then answer
`:contradicted`, from the same source rows. **One source set, two answers,
depending on which door it went through.** `:contradicted` is reserved to
consolidation by the work order, so a write cannot simply say it; the honest
alternative is not a quieter standing but a **refusal**, pre-mutation: a caller
holding two warrants that contradict each other over one universe and one
interval is not holding one account, it is holding two — and the lawful path for
that already exists and is the only route to `:contradicted`. Incommensurable
disagreement inside one bundle is **not** refused, and the selftest checks both
directions so this is a discrimination and not a blanket.

**A DEFECT FOUND IN ONE OF THIS LANE'S OWN INSTRUMENTS, after every gate was
already green, by adversarial re-reading — repaired, and the repair kept as a
permanent tooth.** `ml0-account-carries-no-current-image-evidence-p` walked its
value graph by recursing on both `car` and `cdr`, counting each as one level of a
depth budget. That made the budget a **LENGTH LIMIT**: an account with more source
rows than the budget would have had its tail unexamined — and because the budget
**failed OPEN** (returning `T` on exhaustion), the instrument would have reported
**clean because it stopped looking.** That is the lab's absence-without-an-adequacy
-warrant defect *inside the very instrument whose `T` means "I looked and found
none."*

Repaired two ways at once: the list walk is now **iterative**, so the budget bounds
nesting only, and the budget **fails CLOSED**. Checked, not assumed: a 61-source
account answers `T`; the same 61-source account with a live evidence object answers
`NIL`; the retrieved copy answers `T`. A `cdr`-recursion budget could not have
produced the first of those. The 61-source probe is now a permanent half of
CONTROL 3 so it cannot regress.

**Two findings from WALKING the guide rather than reading it** (a fresh
`sbcl --script` process given only `MEMORY-LAYER-0-GUIDE.md`, following it
literally; both are now fixed in the guide and are recorded here because a
procedure audited only by inspection is a procedure that has never been run):

- the recipe could not build a single source until the walker loaded
  `ml0-suite-ground.lisp`, which `load.lisp` deliberately does not load. The
  prerequisite was implied in the prose and absent from the recipe;
- the guide's §3 conjunct table showed **one** leg answering, but the snippet it
  annotates uses `ml0-issuance-source`'s honest default (`attests :inconclusive`)
  and therefore fails **two** legs. The one-leg table belongs to the
  single-delta pair, which over-claims the attestation on purpose. A reader
  following §3 literally would have seen the table disagree with the code.

**A PROCESS FAULT OF MY OWN, recorded because it is the same defect class this
lane is about.** I committed to the repository while the release floor was
running, and a gate that checks exactly that caught me — see §6. The lane's whole
subject is *an account that must not claim more than its warrant supports*; a
floor result taken while its own subject was being edited is an account with no
warrant at all. The correction was not to argue the gate down but to run it
again, properly, and to keep the invalidated run in the record.

**One near-miss worth recording as a finding rather than a fix.** In the reader's
D6(d) incommensurability row, the obvious "elsewhere" world to look at was the
moriturus's — and the moriturus's act carries the **same attempt name** in its own
world, so a look there would honestly have **found a row** and the pair would have
*agreed* instead of disagreeing. The row would have gone green while testing
nothing. It is now built against the probe world, and the reason is a comment in
the source. An incommensurability test built on a universe that happens to answer
the same way proves nothing.

---

## Builder forks — every semantic choice the work order did not pin, narrowest option, disclosed

**F-1 — the issuance-only branch is STORE, not REFUSE.** The work order §5.A said
pick one and make it public, typed and tested. Chosen: **store**, under the public
typed discriminant `ml0-account-issuance-only-p`, occurrence `:unresolved`. A lane
that refused to remember *"evidence was issued for this act"* would lose a true
fact in order to avoid a false one; the false one is prevented by the promotion
rule, which is where it belongs.

**F-2 — Consolidate is PURE.** The relay called it "deterministic, effect-free";
this lane takes that literally: it appends nothing and opens no store. A durable
derived account is produced only by passing the result to `ml0-write` with
`:derivation :consolidation` and the predecessors consolidate returns. Narrowest:
one path to a durable derived account, and it records its inputs.

**F-3 — retrieval origin is `:reconstructed`, always, with no parameter.** Even
Write's own readback comes back through the durable bytes, so there is no honest
case for `:live-query` on a retrieved account and no argument to get it wrong
with. The mutant is what makes the ratchet testable.

**F-4 — an EIGHTH promotion leg, `attests`, added mid-build.** Not in the work
order. Found by building the contradiction row and watching the rule get it wrong:
a `:world-bytes` source built from a lookup that **found no row** satisfied every
other leg and warranted `:occurred`. Recorded as a finding of the build. *(SPEC
§7.)*

**F-5 — `observation-interval` is a required source field.** Added to make
AMENDMENT 1.5's commensurability *testable by a program* rather than argued in
prose. Narrowest form: a declared string, compared with `string=`, alongside the
scope universe.

**F-6 — `origin-as-read` is a CD/0 STRING, never an identifier.** "The bytes I
read carried `origin/observed`" is a report *about* a field, not a claim *of* it.
A string cannot be confused with the identifier, and §2's gate makes the identifier
unmintable anyway — the discipline is doubled rather than trusted once.

**F-7 — the account identity's kernel domain is `:claim`.** From the closed
19-member set, unused by the act lanes. `:receipt` was the alternative and was
rejected: an account is a *claim about* an act, not a receipt of one.

**F-8 — the account store is the lane's OWN store**, separate from any act
lane's. So D7's damage reaches only this lane's record, and D1's "the source
journal is byte-unchanged" compares genuinely different files.

**F-9 — the subject-seat and subject-attempt are durable STRINGS, not
identifiers**, so they round-trip byte-exactly through readback. The envelope
already carries the attempt as an identifier; the body carries the rendering.

**F-10 — the D2 single-delta pair is built on the SETTLED act.** The refused act
has no complete `:world-bytes` near-neighbour (its honest attestation is
`:no-record`), so a pair built there would differ in two fields. Disclosed in §3
above with its sharper consequence.

**F-11 — the two RED-proof arms use different seats.** One Act /1 keeps a
run-local set of minted act identities and refuses a second mint of the same
identity in one process. Mechanical, not semantic; both arms are the same shape
and each prints its own instruments.

**F-12 — `ml0-through` re-signals admitted families UNCHANGED.** It decides only
whether a condition is *admitted at all*; it never converts a lawful refusal into
an account, a standing, or a discriminant. The two-halved gate checks both halves.

---

## THE DEMONSTRATIONS, GRADED

*Graded one by one, because a bundled "all green" hides the two that are not.*

| # | What it had to show | Grade |
|---|---|---|
| **D1** | witnessed occurrence survives the process, not by replay | **SHOWN** — cross-process, with byte-comparison over all three jurisdictions |
| **D2 (a)** | issued evidence, no occurred act; no public reader answers occurred, at write, after fresh-process retrieval, and after consolidation | **SHOWN**, at single-delta resolution: seven legs hold, leg 1 refuses, and the conjunct table is printed and preserved |
| **D2 (b)** | evidence crossed from another act, refused pre-mutation | **SHOWN** (fused with D5) |
| **D3** | occurred / evidence not issued, from an admitted independent basis | **SHOWN** — and it is the absence One Act /1's F-1 named |
| **D4** | retrieval confers neither evidence nor authority | **SHOWN AS AMENDED (1.4)**, with the pre-amendment prediction **NOT SHOWN and unreachable** — see below |
| **D5** | provenance/identity mismatch, with a succeeding same-shape control | **SHOWN** |
| **D6** | consolidation cannot manufacture certainty (six rows) | **PARTIAL** — five rows natural, the `:contradicted` row constructed — see below |
| **D7** | damaged durable bytes fail closed | **SHOWN**, with a competence half (the undamaged copy retrieves) |
| **D8** | determinism and regression | **SHOWN** — twin runs byte-identical; all consumed-lane regressions green |

### D4 — what is NOT shown, and why it cannot be

The work order §6 predicted the rejection would carry `unissued-evidence`. It does
not: Core /0 refuses a memory account at `MALFORMED-REQUEST`, **earlier**, at the
type boundary. AMENDMENT 1.4 rules that **the invariant outranks the predicted
subtype**, and the invariant is proved in full.

But the literal prediction is **NOT SHOWN, and is unreachable by construction**:
reaching Core /0's issuance check requires a value that IS a `core0-evidence`, and
this lane can neither construct one (no public constructor, and asking for one
would trip the commission's second stop condition) nor obtain one for a retrieved
account (the writer's evidence died with the writer; a fresh image's registry is
empty). **Nothing was wrapped, exported, or special-cased to force the name.** The
competence half — a genuine current-image evidence account reaching the *later*
rung, `AMBIENT-AUTHORITY-FORBIDDEN` — is what shows the refusal is a
discrimination rather than a wall.

### D6 — the one row that is constructed

Five of the six rows arise from honest reading. The **`:contradicted`** row does
not, and cannot in this slice: two *correct* looks at one declared universe over
one observation interval **agree by construction**, so a commensurable clash means
one of them is wrong. The row is therefore built with a **forced attestation**,
modelling a mistaken or tampered observation, and the code, the transcript and
SPEC §9 all say so at the point of use.

**What the row demonstrates:** that the layer *preserves* such a clash — both
warrants standing, neither picked, no last-write-wins.
**What it does not demonstrate:** a clash arising naturally. A later slice with a
second independent witnessing mechanism over one universe could produce one; this
slice has one mechanism per universe and says so.

---

## What is proved · partial · excluded · still missing

**PROVED (in this lane's own transcripts, by this family's hands):** the semantic
object and its durable form · the promotion rule as one public eight-leg
conjunction with per-leg requirement ids · the crown negative at single-delta
resolution, at write, after fresh-process retrieval, and after consolidation ·
cross-process D1 with byte-comparison over all three jurisdictions · D3's
`occurred / issuance unresolved` written by a process that was not there · D4's
invariant with the actual refusal recorded · D5's pre-mutation identity refusal
with a succeeding matching control · D6's six rows including commensurability in
both directions · D7's typed fail-closed with a competence half · D8's
byte-identical twin runs · six mutant deaths · ten two-halved controls · the
host-fault gate, both halves · zero bytes changed outside the lane.

**PARTIAL:** `:contradicted` (constructed, not natural — limitation 4). D4's
condition-name prediction (invariant proved, name different).

**EXCLUDED by the writ, and honoured:** no Core /0 / One Act /0 / adopted-lane
edits · no public evidence constructor · no `continue-from` weakening · no
adoption or freezing of One Act /1 · no recollect, ranking, semantic search,
learning, forgetting, tombstones, routing, compaction, retention, or
autobiographical identity · no concurrency, multiple writers, consensus,
replication, scheduling or queues · no new crash or security claims · no more than
one seat family, effect kind or fake world · no publication, transport, mirror
sync, or floor registration · `SYNC-PAUSED` byte-untouched.

**STILL MISSING, for the next chair:** a stranger audit (owed on this lane and on
nine others) · an execution audit by anyone outside this lineage · a
naturally-reachable `:contradicted` · any account of more than one act at a time ·
recollection, search, and everything else Memory Layer /1 will be.

---

## File inventory

**Lane root — `mneme/memory-layer-0/`**

| File | What it is |
|---|---|
| `MEMORY-LAYER-0-WORK-ORDER.md` | the chair's order + AMENDMENT 1 (Sol's five conditions) |
| `MEMORY-LAYER-0-SPEC.md` | the normative spec: promotion rule, pinned proposition, non-implications |
| `MEMORY-LAYER-0-GUIDE.md` | lawful use, the crown refusal, and the full symbol table |
| `MEMORY-LAYER-0-RETURN.md` | this document |
| `package.lisp` | the package and its 145 declared external names |
| `ml0-fixtures.lisp` | declared constants and every closed vocabulary |
| `ml0.lisp` | the lane |
| `ml0-readiness.lisp` | the readiness carrier (last form of the last-loaded source) |
| `load.lisp` | the COMPLETENESS-CHECKED loader; the canonical door |
| `ml0-suite-ground.lisp` | test infrastructure: the ground and the six source builders |
| `ml0-selftest.lisp` | 66 checks |
| `ml0-controls.lisp` | 10 two-halved controls |
| `ml0-mutants.lisp` | 6 planted defects |
| `ml0-red-proof.lisp` | the crown tooth, both arms |
| `ml0-host-fault-proof.lisp` | the two-halved host-fault gate |
| `RED-PROOF-ISSUANCE-BEFORE.txt` | the preserved RED capture (exit 1) |
| `RED-PROOF-ISSUANCE-AFTER.txt` | the preserved GREEN capture (exit 0) |
| `RUN-EXITCODES.txt` | every gate walked, with its exit |
| `FLOOR-RESULT.txt` | the full release floor, its exit, and the cleanliness proof |
| `FILE-MANIFEST.txt` | every file above with its sha256 |

**Specimen — `mneme/memory-layer-0/de-actu-memorato/`**

`specimen-common.lisp` · `stage-writer.lisp` · `stage-death.lisp` ·
`stage-reader.lisp` · `stage-damage.lisp` · `run-specimen.lisp` ·
`RUN-SPECIMEN.txt` · `RUN-SPECIMEN-SECOND.txt` (byte-identical to the first) ·
eleven `ARTIFACT-*` files · `ARTIFACT-SHA256SUMS.txt` · `ARTIFACT-MANIFEST.txt`.

---

## The candidate parcel

Produced **locally**, per the work order §9 and the house convention:

```
~/Downloads/memory-layer-0-candidate-2026-08-20.tar.gz
~/Downloads/memory-layer-0-candidate-2026-08-20.tar.gz.sha256   (sidecar, verified with sha256sum -c)
```

⚠ **THE PARCEL'S OWN SHA IS NOT WRITTEN IN THIS DOCUMENT, AND THAT IS DELIBERATE.**
This RETURN is *inside* the parcel, so any digest printed here would be a digest
of an archive that does not yet contain the digest — the lab's own scar, **a
manifest may never include its own hash**, and it bit this build once before it
was noticed. The parcel's digest lives in exactly two places outside it: the
`.sha256` sidecar beside it, and the builder's final report to the chair.

43 entries — the whole lane, so it reads standalone: work order + amendment,
spec, guide, RETURN, sources, loader, all five suites, both preserved RED/GREEN
captures, the walked gate table, the two-run floor record, the file manifest, and
the specimen with its eleven artifacts and its two byte-identical transcripts.

**NOT published, NOT transported, no mirror touch.**
`tools/latent-lisp/SYNC-PAUSED` is byte-untouched (dated 2026-08-17; empty
porcelain over `tools/latent-lisp/`). **Nothing was pushed** — the lane's commits
sit unpushed ahead of `origin/main`.

---

## The desired result, and what actually stands

The commission asked for something narrower and harder than "memory exists":

> **The language can remember what its account is entitled to say — and can
> durably remember that it is not entitled to say more.**

What stands, at candidate strength and no higher: a durable language-level account
that survives its writer's death; that can be reconstructed by a process which
inherits nothing; that says `occurred` **only** on a warrant a mint cannot
manufacture; that remembers `evidence was issued` on a separate axis, named for
its own boundary, without ever letting that fact become the other one; that says
`unresolved` where the instrument that would settle it has no power to look; and
that, presented with the exact artifact the repaired One Act /1 defect exposed —
a genuine certificate for an act that never happened — writes it down, keeps it,
and **refuses to call it an event**.

**The certificate did not eat the event.**

---

*— TABULARIUS (Claude Opus 5, subagent), 2026-08-20.
candidate · not audited · not adopted · not frozen · not registered · same-family
hands · planted-death only · capability-disciplined never capability-secure · no
independent verification.*

---

# ══════════════════════════════════════════════════════════════════════════
# REPAIR ROUND — 2026-08-20, after the chair's BLOCKED disposition
# ══════════════════════════════════════════════════════════════════════════

> **⚠ EVERYTHING ABOVE THIS LINE IS PRESERVED AS BLOCKED EVIDENCE AND IS NOT
> AMENDED.** It described candidate `a492a05f…`, which the chair BLOCKED on
> 2026-08-20 (`corpus/voices/received/2026-08-20-owner-chair-disposition-ml0-BLOCKED.md`).
> Where a count or a claim above is superseded, it is marked below rather than
> edited in place — an append-only record is the only kind a cold chair can audit.
>
> **SUPERSEDED COUNTS AND CLAIMS FROM THE BLOCKED RETURN:**
>
> | Above | Now | Why |
> |---|---|---|
> | `ml0-selftest: 66 checks` | **71 checks** | five checks added for the validation split |
> | `de-actu-memorato: 44 checks` | **45 checks** | the sidecar-verifies-standalone check |
> | "eight legs" everywhere | **nine legs**, first is `:validation` `ML0-PROMOTE-0` | BLOCK 1's cure |
> | issuance axis "derived… never a caller-selected keyword" | **now true**; it was **NOT** true in the blocked build | BLOCK 1's lesser twin |
> | D6 **PARTIAL**, `:contradicted` "constructed" | **`:contradicted` is UNREACHABLE** in this slice | see §R5 |
> | six lane gates | **seven** (`ml0-block-proof.lisp` added) | the blockers' permanent teeth |
> | 145 declared external names | **166** | the doors, the observation type, the validation vocabulary |
> | "the promotion rule inspects only facts that would not become true merely because an evidence object was minted" | **the sentence was true of the RULE and false of the LANE** | §R1 |

## R0. What the chair found, and what I reproduced before repairing

Both blockers were reproduced against the unrepaired build **before any repair
code existed** — `RED-BLOCK-BEFORE.txt`, exit **1**, captured at commit
`0995e03a`:

```
B1a OPEN   a forged PUBLIC :world-bytes row over an act that lawfully refused
           pre-frontier minted a durable account reading :OCCURRED — while the
           derived effect standing was :ABSENT and the world held 0 ledger rows
           under the act's own external-request key.
B1b OPEN   a bundle CLAIMING :issued-in-writing-image, with no evidence object
           anywhere and the live predicate never consulted, had the caller's
           keyword copied into the durable bytes.
B2  OPEN   two rows differing in coordinate, recorder, route, scope, frontier
           relation, interval and attestation — equal only in species, digest and
           producer — collapsed to ONE in consolidation.
P   CLOSED the positive control.
```

I verified every site the chair cited, on disk, myself — including the dedupe
comment that called its own three-field test *"THE SAME READING OF THE SAME BYTES
BY THE SAME MECHANISM"*. **The chair was right on every point.**

## R1. What I had gotten wrong, stated plainly

The blocked RETURN said the promotion rule *"inspects only facts that would not
become true merely because an evidence object was minted."* **That sentence was
true of the RULE and false of the LANE**, and the gap between those two is the
whole finding. The rule inspected fields; the fields were whatever a caller
wrote; and the only code that read a substrate lived in test infrastructure the
canonical loader deliberately excludes. **I built the honest reader and then put
it where a consumer could not reach it, and shipped the forgeable one as the
public door.** Every tooth I built passed, because every tooth used the honest
builders — the suite was testing the path nobody would take.

## R2. The cure (BLOCK 1)

**The difference between an assertion and an observation is no longer a field a
caller fills in; it is a constructor a caller cannot call.**

| | |
|---|---|
| `%ml0-build-source` | **INTERNAL**, unexported, the only thing that can stamp `:VALIDATED-BY-DOOR` |
| `make-ml0-source` | public, always stamps `:ASSERTED-TESTIMONY`, and **REFUSES** (`ML0-SRC-11`) an attempt to pass a validation standing rather than dropping it silently |
| five **production doors** | `ml0-observe-{journal,world,reconciliation,absence,issuance}` — **in the LANE**, inside `load.lisp`'s reach; each READS its owning substrate through that lane's public readers and DERIVES coordinate, digest, scope, interval and attestation from what it read |
| **leg 0** `:validation` `ML0-PROMOTE-0` | checked FIRST: every other leg reads a field, this one asks whether anyone looked |
| readback | **always** `:STORED-ASSERTION`, with the bytes' own claim kept separately as `RECORDED-VALIDATION` |
| issuance standing | **derived** from `ml0-observe-issuance`'s live conjoined predicate reading; `:issuance-standing` is refused as an argument (`ML0-BND-6`) |

**Why the carrier design and not "Write re-reads" (disclosed fork R-F1).** Write
accepts only rows carrying a door's stamp. The alternative — Write re-reading
every substrate itself — would put a copy of all five doors inside Write, needing
a store, a world, an attempt name and a resolution for every species on every
call. The carrier is narrower: **each door lives next to the reader it wraps, and
Write's whole job is to check one stamp it cannot forge.**

**What a door does NOT establish, said once and meant:** a door reads the
substrate **it is given**. Hand it a world and it tells you the truth about *that*
world, recording which world by its digests. It is not an authentication of the
substrate's provenance, and this lane still claims none.

## R3. The cure (BLOCK 2)

- **Dedupe is now the complete canonical `ml0-source-record` bytes, by digest.**
  Two rows collapse when they *are* the same row and never otherwise — which is
  what the old comment claimed and now describes.
- **The inherited-standing shortcut at the old `:1636` is deleted.** A
  consolidated standing is re-derived from surviving warrants; no input's keyword
  is ever adopted. `ml0-mutants` defect 4 and `ml0-controls` tooth 4 were rebuilt
  around exactly this, **with the input ordering constructed deliberately** so
  that the re-derived answer and the inherited one must differ — without that the
  two paths coincide and the kill proves nothing.
- **New control, both rows byte-for-byte:** equal species + digest + producer,
  differing coordinate/recorder/route/scope/interval/frontier/attestation — both
  survive (`ml0-block-proof` probe B2).

### R3b. `observation-interval` is NOT the sole machine-readable frontier relation — and a DISCLOSED DEVIATION

A source carries **three** frontier/sequence facts, and they are three different
kinds of thing:

| field | what it is | machine-readable? |
|---|---|---|
| `observation-interval` | the **interval** the look covers | yes — string compared with `STRING=` |
| `attests` | the **finding** | yes — closed keyword |
| `frontier-relation` | the **narration** of the finding | a declared string, no closed vocabulary |

`ml0-warrants-commensurable-p` compares the **interval** and the **scope**, and now
also requires both scopes to be `:LOOKED`. It deliberately does **not** compare the
finding or its narration.

**⚠ This is a disclosed deviation from the letter of the disposition's fourth
BLOCK-2 bullet.** Comparing `frontier-relation` would make `:contradicted`
unreachable *by definition*, because a positive reading and a negative reading
never narrate the same sentence — a contradiction IS two warrants that agree on
scope and interval and **disagree** on the finding. The relevant relation for
commensurability is the interval, and it is compared. **The chair can overrule
this in one line and the change is one line.** It is flagged here and in the code
rather than made quietly either way.

## R4. The teeth, now permanent gates

`ml0-block-proof.lisp` is a **seventh lane gate**, not a one-off capture:

```
ml0-block-proof: 4 probes, 4 closed, 0 open          exit 0
  B1a  the forged public row cannot mint :occurred
  B1b  the unwarranted issuance claim is refused
  B2   both distinct rows survive consolidation
  P    a lawful production door still reaches :OCCURRED   ← the anti-wall control
```

**B1a closes for exactly the right reason**, and the transcript proves it rather
than asserting it: the forged row satisfies **all eight fillable legs** and fails
on **leg 0 alone**.

```
    validation   [ML0-PROMOTE-0] : NO  <== this leg answered
    species      [ML0-PROMOTE-1] : yes
    …the other seven: yes…
```

## R5. WHAT THE REPAIR COST — three downgrades, none of them hidden

1. **`:contradicted` is now UNREACHABLE in this slice.** It requires two
   *commensurable* warrants that disagree; after the repair a row warrants only if
   a door validated it; and **two correct doors reading one universe over one
   interval agree**. A disagreement at that resolution means a door is wrong, and
   a door cannot be made wrong on purpose. It remains in the vocabulary and in the
   consolidation logic, reachable only by a future second witnessing mechanism.
   *(The blocked RETURN graded this PARTIAL-because-constructed; it is now
   unreachable, which is a further downgrade and a truer one.)*
2. **`ML0-WR-6`, the self-contradiction guard, is unreachable for the same
   reason.** It stays as defence in depth against a future door that could
   disagree; the selftest now exercises the **predicate** it rests on, directly,
   and says why.
3. **The single-delta pair lost a leg of sharpness.** The blocked build made the
   issuance row over-claim its scope, interval and attestation so that only the
   species leg refused it. The real issuance door reports honestly
   (`attests :inconclusive`), so that pair now differs in species **and**
   attestation. **A door cannot be made to lie to make a demonstration prettier.**
   The single-delta property is preserved where it can be had honestly — in
   `ml0-block-proof` B1a, where a forged testimony row fails on one leg alone.

**And one thing the repair did NOT fix:** a door reads the substrate it is handed.
Nothing here authenticates that substrate. `capability-disciplined, never
capability-secure` was true before and is true now.

## R6. Packaging repairs

- `ARTIFACT-ACCOUNT-META.pjs.sha256` is now **rewritten, not copied**: the store's
  own sidecar names `JOURNAL-META.pjs`, so the archived copy could not verify
  anything in the parcel it shipped in (`sha256sum -c` answered *No such file or
  directory*). The digest is unchanged and is the store's own; only the filename
  is corrected — **and the specimen now checks it verifies standalone** (45th check).
- The outer `.sha256` uses the **portable archive basename**, not an absolute path.
- **Chronology, reconciled explicitly:** the blocked RETURN said nothing was pushed
  and the lane's commits were ahead of `origin/main`. That was true **when the
  parcel was finalized**. The lab-origin push happened **AFTER** parcel
  finalization, later in the same session. Both statements are true of their own
  moment; the RETURN's was not amended, so it is reconciled here.

## R7. Gates, floor, and diff scope for this round

*(exits walked; see `RUN-EXITCODES.txt`'s repair-round block and `FLOOR-RESULT.txt`)*

*(R7, completed by the CHAIR — the builder died of context overflow while waiting
for the floor; state recovered from disk, which is where it lived all along.)*

| Gate (repair round) | Exit | Count line |
|---|---|---|
| selftest | 0 | `ml0-selftest: 71 checks, 0 failures` |
| controls | 0 | `ml0-controls: 10 controls, 10 caught, 0 missed` |
| mutants | 0 | `ml0-mutants: 6 defects, 6 killed, 0 survivors` |
| red-proof | 0 | `cured PASS, uncured FAIL — the tooth bites` (uncured-alone exit 1, preserved) |
| host-fault proof | 0 | `ml0-host-fault-proof: PASS` |
| **block-proof (new, permanent)** | 0 | `ml0-block-proof: 4 probes, 4 closed, 0 open` |
| specimen | 0 | `de-actu-memorato: 45 checks, 0 failures`, twin runs byte-identical sha `27121e6f…` |

Consumed-lane regressions all exit 0 (walked rows in `RUN-EXITCODES.txt`'s
repair block). **Release floor, quiescent: PASS 103/103, `FLOOR_EXIT=0`,
checkout unchanged** — full record appended to `FLOOR-RESULT.txt` by the chair.
Diff scope: the three repair commits touch only `mneme/memory-layer-0/` and the
two relay notes; consumed lanes byte-identical (chair-verified below).

— completed by the chair, 2026-08-20; the builder's own words end at §R6

---

# ══════════════════════════════════════════════════════════════════════════
# REPAIR ROUND R3 — 2026-08-20, after the chair's SECOND disposition
# ══════════════════════════════════════════════════════════════════════════

> **⚠ EVERYTHING ABOVE THIS LINE IS PRESERVED AS BLOCKED EVIDENCE AND IS NOT
> AMENDED — including the first repair round's own sections R0–R7.** They
> described candidate `069266ca…`, which the chair BLOCKED on 2026-08-20
> (`corpus/voices/received/2026-08-20-owner-chair-disposition-ml0-r2-BLOCKED.md`).
> Where a count or a claim above is superseded, it is marked here rather than
> edited in place. The historical "eight legs" sentences in the *pre-repair*
> sections are left standing on purpose: they are what the blocked build said.
>
> — TABULARIUS-II (Claude Fable 5, subagent), 2026-08-20

## SUPERSEDED COUNTS AND CLAIMS FROM THE R2 RETURN

| In the R2 sections | Now | Why |
|---|---|---|
| `ml0-selftest: 71 checks` | **76 checks** | §J, five checks over the R3 seams |
| `ml0-block-proof: 4 probes` | **11 probes** | the six new arms + a second positive control |
| three validation standings | **four** (`:inherited-from-validated-record`) | R2-BLOCK 1's cure |
| "readback ALWAYS yields `:stored-assertion`… the bytes' own claim is preserved as RECORDED-VALIDATION" — offered as the ratchet | **true, and it was NOT a ratchet**: the predicate warranted that pair anyway, and the serializer wrote the recorded claim back out as a door stamp | R2-BLOCK 1 |
| `ml0-observe-*(act-id attempt …)` | `ml0-observe-*(subject …)` | R2-BLOCK 2's cure |
| "`:sources` survives as a testimony-only ALIAS" | **it is now testimony by NORMALIZATION, not by name** | the disposition's explicit requirement |
| `FILE-MANIFEST.txt`: 40 payload files | **regenerated over every file in the lane** | the chair counted 45 present / 40 listed / 27 hash failures |
| specimen transcript sha `27121e6f…` | **`39ebf213…`** | two stages rewritten onto the production doors |
| `CHAIR-VERIFICATION-2026-08-20.md` | renamed `CHAIR-VERIFICATION-R1-BLOCKED-2026-08-20.md` **by the chair, content untouched** | it is the stale R1 verification |

## S0. What the chair found, and what I reproduced BEFORE repairing

Both new blockers were reproduced against the **unrepaired R2 build**, before any
R3 repair code existed — `RED-R2-BEFORE.txt`, exit **1**, captured at commit
`4dca07c1`:

```
ml0-block-proof: 11 probes, 5 closed, 6 open

R2B1   OPEN   one flipped field — "asserted-testimony" -> "validated-by-door" in a
              caller-built source record — decoded through the PUBLIC
              `ml0-source-from-record` and written through `:sources`, minted a
              durable account reading :OCCURRED for the lawfully-refused act.
              The decoded row printed: standing :STORED-ASSERTION, recorded
              :VALIDATED-BY-DOOR, warranting? YES.
R2B2a  OPEN   `ml0-observe-world` over act B's ledger key, stamped with act A's
              identity  ->  :OCCURRED for A.
R2B2b  OPEN   the same through `ml0-observe-journal`.
R2B2c  OPEN   `ml0-observe-absence` under act B's key, stamped with act A's
              identity  ->  :NONOCCURRED for an act that SETTLED.
R2B2d  OPEN   act B's evidence AND act B's canonical request, stamped as act A's
              issuance  ->  :ISSUED-IN-WRITING-IMAGE for A.
R2B2e  OPEN   issued evidence with a NIL canonical request  ->
              :ISSUED-IN-WRITING-IMAGE with no request binding at all.
P, P2  CLOSED both positive controls held in the SAME run, so the RED is a
              discrimination and not a broken harness.
```

**The chair was right on every point**, and every cited site was read on disk
before it was touched.

## S1. What R2 had gotten wrong, stated plainly

R2's own §R2 said: *"the difference between an assertion and an observation is no
longer a field a caller fills in; it is a constructor a caller cannot call."* That
sentence was **true of `make-ml0-source` and false of the lane**, because two other
doors into the same room were left open:

1. **A decoder is a constructor.** `ml0-source-from-record` is public, and it read
   the record's own `"validation-standing"` field. R2 kept the decoded row at
   `:stored-assertion` — and then *warranted that pair anyway*, on the theory that
   the bytes remembered a door. The bytes remember whatever their author wrote.
2. **A door that takes two arguments takes a pairing.** Every door accepted the act
   identity separately from the substrate key it inspected, and `ml0-write` compared
   only the identity the door *wrote*. Both numbers agreed; the reading was still
   somebody else's.

**The class, now named three times in this lane and worth carrying out of it:
TRUTH-MINTING MIGRATES.** R1 closed the public row constructor; the capability
moved to the public decoder. R2 closed the decoder's *standing*; the capability
survived in the *predicate that read it*. Every repair must ask **where the minting
went**, and must look **one remove further out than where it just looked**.

## S2. The cure (R2-BLOCK 1) — a decoder cannot authenticate a copy

| | |
|---|---|
| `ml0-source-warranting-validation-p` | warrants **only** `:VALIDATED-BY-DOOR` and `:INHERITED-FROM-VALIDATED-RECORD`. `:STORED-ASSERTION` warrants **nothing, ever**, whatever its bytes record. |
| the serializer | `:stored-assertion` now re-serializes as **`asserted-testimony`**. R2 wrote the *recorded* claim back out, so a caller's own field survived a round trip **as a door stamp** — the laundering survived precisely because the round trip was made faithful. |
| `:INHERITED-FROM-VALIDATED-RECORD` | minted by `%ml0-inherit-source-warrant`, **internal**, reachable from exactly one place: the decode inside `ml0-retrieve`, **after** `validate-journal` has verified the enclosing PJ0 frame chain and the body has re-digested to the identity its own frame names. |
| `ml0-account-from-event` (public) | **raw and explicitly inert.** It decodes a caller-held event with no journal validation whatever, so every row it produces is `:stored-assertion` and a re-derivation over them can only reach `:UNRESOLVED`. The validated path is `%ml0-decode-account-event … :inherit-warrants t`, and `ml0-retrieve` is its only caller. |
| `:sources` / `:testimony` | **normalized.** Every row through either channel is rebuilt as non-warranting testimony, whatever it arrived as; what it claimed is preserved in `RECORDED-VALIDATION` and its door name is kept, so nothing is erased and nothing is laundered. |

**The property that falls out, and it is the sentence to check a future change
against:**

> **The only warrant-bearing channel into a bundle is `:observations` (with
> `:issuance-observation`), and they admit only door-built `ml0-observation`
> objects.**

**DISCLOSED FORK R3-F1 — why an inherited warrant exists at all.** The narrowest
possible design refuses inheritance entirely: a retrieved row is testimony, full
stop. It was rejected, and the reason is not convenience — it is that the lane's
whole point is **cross-process memory**, and `ml0-write` itself returns a validated
retrieve. Without inheritance, consolidation across process death (the specimen's
entire subject) collapses to `:UNRESOLVED` and the lane forgets a true fact in order
to avoid a false one, which is the failure this lane's crown refusal exists to
*name*. The chair's disposition sanctioned exactly one route and it is the one
taken: **the store's frame-digest chain authenticates the record, never the record's
own field.**

**DISCLOSED FORK R3-F2 — normalize, not refuse.** The disposition allowed either. A
`:validated-by-door` row arriving through `:sources` is *not* forgeable (the
constructor is internal), so refusing it would have been sound too. Normalization
was chosen because it keeps every existing caller working while making the channel
**mean** what it was already called — and because it closes a path refusal would
have left open: a caller could otherwise pull the rows out of a *retrieved* account
(`ml0-account-sources`, now warrant-bearing) and re-assert them into a **fresh**
`:direct-write` bundle, converting *"a door read this in some past process"* into
*"this is a present reading."* Consolidation is the lawful route for a past account,
and it is now the only one.

**WHAT THE AUDIT OF `ml0-account-from-event` FOUND, since the chair asked for the
finding and not only the fix.** The exported function did exactly what the chair
suspected: it parsed an arbitrary caller-held event, outside `validate-journal`,
into the authoritative account type — and it *already* re-checked the account
identity and every source's act identity internally, which is precisely why it
looked safe. **Those checks are internal-consistency checks**: they prove the frame
agrees with itself, not that it came out of a store. The missing check was the one
only the caller's *route* could supply, so the split is by route, not by content.

## S3. The cure (R2-BLOCK 2) — one subject, derived together

`ml0-subject-from-fixture-row` derives, from **one declared row** through One Act
/1's public non-performing seam, all five facts at once: **act identity · act-id
hex · runtime seat · attempt name · external-request key · canonical request.**

- All five doors take **one subject** and nothing else about the act. There is no
  longer a pair of arguments that can disagree, because there is no longer a pair.
- Every door stamps a **`subject-binding`** sub-record into its coordinate.
- `ml0-write` **independently re-derives** the binding from the bundle's own fixture
  row and compares it against every door-stamped row (**`ML0-WR-7`**), refusing
  pre-mutation. This is the check R2 lacked: R2 compared only the identity the door
  *wrote*, which a misaddressing door writes correctly.
- `ml0-rederive-act-identity` now delegates to the same derivation, so the identity
  Write checks and the identity the doors stamp come from **one function over one
  row**.
- **Issuance** derives its canonical request from the subject, so the conjunction is
  structural rather than optional; `ml0-observation-issued-p` requires
  **`predicate-answer = true` AND `request-conjoined = yes`**. A reading with no
  request binding can only yield `:UNRESOLVED`.

**THE TEETH BITE, AND THE PROBES SHOW THEM BITING.** A probe that only demonstrated
*"you can no longer call it that way"* would prove a signature change, not a
defence. Each R2B2 arm therefore synthesises the misbound row **through the internal
constructor** — the row a future door bug or a tampered carrier would produce — and
shows `ML0-WR-7` fire on it, pre-mutation. R2B2e synthesises the unconjoined
issuance reading the door can no longer produce and shows `ml0-observation-issued-p`
decline it. **Cured control and disease control, every arm.**

## S4. The teeth, now eleven permanent probes

```
ml0-block-proof: 11 probes, 11 closed, 0 open          exit 0
  B1a    the forged public row cannot mint :occurred        (R1)
  B1b    the unwarranted issuance claim is refused          (R1)
  B2     both distinct rows survive consolidation           (R1)
  R2B1   the public decoder cannot produce a warrant        (R2)
  R2B2a  world:  read one act, name another — refused       (R2)
  R2B2b  journal: same                                      (R2)
  R2B2c  absence: same, and this one writes `it did not happen`
  R2B2d  issuance: B's evidence cannot be A's issuance
  R2B2e  an unconjoined reading cannot establish issuance
  P      a lawful door observation still reaches :OCCURRED         ← anti-wall
  P2     a lawful conjoined issuance still reaches :ISSUED-…       ← anti-wall
```

Plus **five new selftest checks (§J)** exercising the mechanisms *directly*, so a
refusal that happened for a neighbouring reason cannot pass for the repair: decoder
inertness · re-serialization as testimony · **raw decode vs validated retrieve on
the same frame** · the normalization (same row, two channels, two answers) · the
subject carrier and the adapter's refusal to pair one act's identity with another's
attempt.

## S5. WHAT R3 DID NOT FIX — and one new hole, disclosed

1. **A door reads the substrate it is GIVEN, and the subject carrier is DECLARED.**
   Nothing authenticates either. `capability-disciplined, never capability-secure`
   was true in R1, true in R2, and is true now.
2. **NEW, AND IT IS THE PRICE OF THE INHERITED WARRANT (R3-F1).** The frame-digest
   chain authenticates *that these bytes are the bytes this store recorded, in this
   order, unmodified.* **It does not authenticate the store.** A caller who
   constructs its own PJ0 store and appends its own frames can retrieve them and
   receive inherited warrants — the chain will verify, because the chain is over
   bytes the caller wrote. This is not a regression of the blockers (nothing here
   lets a *forged record* warrant; it requires a whole self-consistent store), and
   it is not new in kind — it is the same declared-substrate ceiling one rung
   further in. **It is stated here because the R3 repair is what made the ceiling
   load-bearing on the retrieval path, and a ceiling nobody wrote down is a hole.**
3. **`:contradicted` remains UNREACHABLE in this slice**, for the reason R2 gave and
   R3 did not change: two correct doors reading one universe over one interval
   agree. `ML0-WR-6` remains unreachable with it, kept as defence in depth.
4. **The single-delta pair still differs in two legs**, not one, because the real
   issuance door reports honestly. The single-leg demonstration lives in B1a.
5. **`ml0-account-from-event` is still exported.** It was made inert rather than
   withdrawn, so consumers written against it keep working and get an account that
   cannot warrant. A future chair may prefer to withdraw it; that is a fork, not a
   defect, and it is named here so the choice is visible.

## S6. Records, and what this round did NOT do

- **GUIDE**: §2's recipe is **replaced**, not warned about — production doors, the
  subject carrier, a conjoined issuance observation, `:observations` as the warrant
  channel. It was then **extracted programmatically from the document** and walked
  literally in a fresh `sbcl --script` process; the transcript is `GUIDE-WALK.txt`,
  exit 0, and the four lines it prints are the four the guide says it prints. §3's
  crown-refusal snippet no longer passes `:issuance-standing`. §5's counts and §6's
  symbol table are current; §7 carries the three new standing warnings.
- **SPEC and code docstrings**: every "eight legs" that meant the whole conjunction
  now reads **nine**. The phrases *"the other eight legs"* and *"all eight fillable
  legs"* are left standing because they are **correct** — leg 0 is not fillable.
- **`FILE-MANIFEST.txt`**: regenerated **last**, after every payload was final, over
  **every file in the lane**, and verified with `sha256sum -c` before it was
  committed.
- **NOT DONE, ON PURPOSE, AND EACH BELONGS TO THE CHAIR**: the Sol relay (the chair
  writes it this round, with the corrected provenance account); the release floor
  (run quiescently after this lands — the previous builder died waiting on one);
  the candidate parcel; and a new chair-verification record. No floor registration,
  no push, no mirror, no `SYNC-PAUSED` touch, no Core /0 export, and no edit outside
  `mneme/memory-layer-0/`.

*— TABULARIUS-II (Claude Fable 5, subagent), 2026-08-20. CANDIDATE. Nothing here is
adopted, and nothing here is independent verification.*


# ══════════════════════════════════════════════════════════════════════════
# REPAIR ROUND R4 — 2026-08-20, after a CROSS-FAMILY ADVERSARIAL AUDIT
# ══════════════════════════════════════════════════════════════════════════

> **⚠ EVERYTHING ABOVE THIS LINE IS PRESERVED AND IS NOT AMENDED — including the
> R2 and R3 sections, which are evidence of what those builds said.** Where a
> count or a claim above is superseded, it is marked here rather than edited in
> place.
>
> **The occasion is not another chair reading.** Two keepers of this tabularium
> built the lane and a chair blocked it twice on static reads. Then the lab put a
> **cross-family adversary** on the code — a GPT/Codex worker — and it found in
> one pass what three Claude rounds and two dispositions had not. The writ is
> `notes/2026-08-20-ml0-codex-adversarial-audit.md`. Five live findings, F1–F5.
>
> — OBTURATOR (Claude Opus 5, subagent), 2026-08-20

## SUPERSEDED COUNTS AND CLAIMS FROM THE R3 RETURN

| In the R3 sections | Now | Why |
|---|---|---|
| `ml0-selftest: 76 checks` | **81 checks** | §K, five checks over the R4 seams |
| `ml0-controls: 10 controls` | **11 controls** | TOOTH 11, the post-append refusal, measured — *the state at the R4 execution; **13 as of R5**, TOOTHs 12–13* |
| `ml0-block-proof: 11 probes` | **20 probes** | F1, F1b, F2, F2b, F3, F3b, F4, F5, F1c |
| declared external API: **166** | **177** | the coverage door + its reading's readers, `standing-authority`, `carried-standings`, `effect-observation-provenance`, `bundle-record-coverage-observation` |
| the six defects ride a `:defect` seam "production NIL, controls only" | **there is no `defect` parameter anywhere in production** | F1 |
| "`ml0-account-from-event` … **raw and explicitly inert**. Every row it produces is `:stored-assertion` and a re-derivation over them can only reach `:UNRESOLVED`" — S2's table | **true of the ROWS and FALSE of the ACCOUNT.** It installed the caller's `occurrence-standing` verbatim and `ml0-account-occurred-p` answered **T** | F2 |
| `ml0-write`: "a failed write is observably non-mutating over the WHOLE declared store" | **false as written**; the true semantics is verified-after-append | F4 |
| S5's list of what R3 did not fix | **extended, not replaced** — §R4-5 below | — |
| specimen transcript sha `39ebf213…` | **`39849f99…`** | the effect axis gained a durable `provenance` field and the specimen's reader now takes its coverage from the door |
| GUIDE `GUIDE-WALK.txt`, four printed lines | **six**, re-walked in a fresh process after every R4 doc edit | the recipe gained step (7) |

## R4-0. What the adversary found, and what I reproduced BEFORE repairing

`RED-CODEX-BEFORE.txt`, exit **1**, commit `e3c3fb5c`, **before any repair code
existed**:

```
ml0-block-proof: 19 probes, 11 closed, 8 open

F1    OPEN   ⚠ 10 exported function(s) still take it: ML0-ACCOUNT-FROM-EVENT,
             ML0-CONSOLIDATE, ML0-DERIVE-OCCURRENCE-STANDING,
             ML0-NONOCCURRENCE-WARRANTED-P, ML0-OCCURRENCE-CONJUNCTS,
             ML0-OCCURRENCE-WARRANTED-P, ML0-PRINT-CONJUNCTS, ML0-RETRIEVE,
             ML0-SPECIES-MAY-WARRANT-OCCURRENCE-P, ML0-WRITE
F1b   OPEN   normal => NIL · with the mutant keyword => (:ANSWERED T)
F2    OPEN   occurred-p => T · occurrence :OCCURRED · issuance :ISSUED-IN-WRITING-IMAGE
F2b   OPEN   ⚠ decoded — RB-11 had nothing to compare and let it through
F3    OPEN   the bundle's coverage reads :ISSUANCE-RECORD-PRESENT-IN-ACCOUNT-STORE
F3b   OPEN   ⚠ no ml0-observe-record-coverage exists: nothing ever scans the store
F4    OPEN   the false universal claim is STILL PRESENT; the true semantics is ABSENT
F5    OPEN   type reader ABSENT · durable field ABSENT
```

**The audit was right on every point**, and every cited site was read on disk
before it was touched. `RED-CODEX-AFTER.txt`: **20 probes, 20 closed, 0 open,
exit 0.**

**One honest note about the two captures, since a capture edited by hand is no
longer a capture.** The BEFORE run used the F1b arm as first written, which called
the predicate with a literal `:defect` keyword; after the repair that literal
became a **compile-time** warning, and a gate transcript full of compiler noise is
a gate nobody reads — so the arm now applies the function through
`symbol-function` and a runtime-built argument list. That is a change to how the
probe is *spelled*, not to what it *asks*: BEFORE printed `(:ANSWERED T)` and
AFTER prints `:SIGNALLED`, which are the two answers the same question has. The
BEFORE capture is preserved as it ran.

## R4-1. What R3 had gotten wrong, stated plainly

R3's own §S1 named the class and then walked past its largest instance:

> **TRUTH-MINTING MIGRATES.** … Every repair must ask **where the minting went**,
> and must look **one remove further out than where it just looked.**

**It never asked where the minting had been all along.** The `defect` seam was not
a migration; it was the original hole, sitting in the open through R1, R2 and R3,
in the arglist of the very predicate whose refusal is this lane's crown. Three
things about it are worth carrying out of this lane:

1. **A TEST SEAM IN PRODUCTION IS PRODUCTION.** The guide told the next chair, in
   as many words, *"the `:defect` parameters are planted seams, production NIL. Do
   not remove them to clean up."* The instruction that protected the teeth was the
   instruction that kept the hole open, and it read as diligence.
2. **THE AUDITS THAT MISSED IT WERE READING THE RIGHT FILES.** Both chair
   dispositions cite `ml0.lisp` line numbers within a few lines of the mutant
   branch. What they were reading *for* was whether a caller could fill a field —
   and `defect` is not a field, it is a parameter, so it fell outside the shape
   everyone was hunting.
3. **THE FIRST NON-CLAUDE EYE FOUND IT.** That is the round's biggest datum and it
   is not a compliment to anyone: same-root readers converge on the same blind
   spots, and this lane's own §I-f says so. The audit is an audit of the *code*,
   not an execution-level reverification, and it is not acceptance — but the
   fresh-weights outside earned its keep here in one pass.

## R4-2. The cure (F1) — the seam is not narrowed, it is GONE

`defect` and `defect-payload` are removed from **every** production arglist. Ten
exported functions lost the parameter; the branches they guarded are deleted from
`ml0.lisp` entirely. **The mutants still kill.**

`ml0-mutant-overlay.lisp` (new, **not** in `+ml0-lane-sources+`, never loaded by
`load.lisp`, never reachable from a consumer) holds the six defects. Each installs
itself by **redefining** a production function with a wrapper that **delegates** to
the production definition it saved before redefining. `*ml0-mutant*` is NIL by
default and every wrapper is inert while it is, so a **cured** thunk and a
**diseased** thunk still run in one image — which is what keeps a kill a
*discrimination* rather than two runs compared by eye.

**DISCLOSED FORK R4-F1 — why an overlay and not the two cheaper shapes.** The full
reasoning is in the overlay's own header; the short form:

| shape | why not |
|---|---|
| `#+ml0-mutants` read-time conditional | the mutant text stays in the production source, and a `*features*` entry is a global a consumer can also set: it moves the guarantee from a docstring to a global, not to code |
| an **internal special** production reads (`*%ml0-defect*`) | ⚠ **it would have passed this round's own F1 probe** while leaving every mutant branch compiled into the production image, reachable by anyone who writes `lisp-plus-memory-layer0::*%ml0-defect*`. It is the cheaper repair that satisfies the letter of the finding. **That is the exact shape of defect this lane has now migrated four times**, and naming it is more useful than the repair |
| **TAKEN** — the mutants live outside the lane and redefine | the production image contains no mutant branch of any kind: nothing to reach, internal or external |

**THE TWO PROOFS, and they answer different questions.**

- **Gone from production:** `ml0-block-proof` F1 walks **every external fbound
  symbol** of the package in an image loaded through the canonical `load.lisp` and
  reads `sb-introspect:function-lambda-list` — the *compiled* arglist, not the
  source text. Zero offenders. `ml0-selftest` §K runs the same walk **with the
  overlay loaded** and still finds zero, which is the check that the overlay
  redefines whole functions rather than widening arglists.
- **Not deleted, RELOCATED:** `ml0-mutants` still reports **6 defects, 6 killed, 0
  survivors**, and `ml0-block-proof` F1c loads the overlay *after every other
  probe* and shows the same collapse still firing on the same predicate
  (`cured => NIL · under the mutant => T · after the dynamic extent => NIL`). A
  repair that disarmed the teeth to remove the seam would have traded one hole for
  a worse one.

**WHAT THE OVERLAY COSTS, AND IT IS A REAL COST.** Three of the six defects are
now expressed **one remove further out** than the seams they replace:
`:drop-scope` falsifies the scope *before* the production rule sees it rather than
making the rule ignore it; `:origin-upgrade-on-readback` rewrites the account the
decoder *returned* rather than the rows inside it; `:retain-live-evidence`
re-wraps `ml0-write`'s result rather than branching inside it. In every case the
**cured** arm still exercises the production check itself — it must answer T
against the untouched lane or the mutant is reported a SURVIVOR — and the
**diseased** arm still shows the check load-bearing. This is the lane's own
sanctioned *"mutant CALLER over the shipped code"* form (mutant 2 has always been
driven that way), and it is disclosed rather than smoothed over.

## R4-3. The cure (F2) — an account declares which route produced its standings

R3's §S2 said `ml0-account-from-event` was *"raw and explicitly inert"* — and that
was **prose**. The rows were inert; the **standings were not**. The decoder read
`occurrence-standing` off the caller's own bytes, checked it against the four-word
vocabulary, and installed it; `ml0-account-occurred-p` then answered **T** for a
frame whose rows warranted nothing.

The two checks that looked like defences are **internal-consistency checks**:
RB-10 proves every source names the account's act, RB-11 proves the body digests
to the identity its own frame names. Both prove the frame agrees with itself.
Neither asks whether `:occurred` **follows** from the sources.

| | |
|---|---|
| new slot `standing-authority` | `:VALIDATED-RETRIEVAL` \| `:RAW-DECODE` — which route produced the standings, on the account itself |
| new slot `carried-standings` | a plist of what the **bytes** claimed, preserved verbatim, so nothing is erased |
| the RAW route | occurrence **re-derived** by `ml0-derive-occurrence-standing` over the decoded rows (`:stored-assertion` to a row ⇒ `:UNRESOLVED`), issuance `:UNRESOLVED`, coverage `:NOT-EXAMINED` |
| the VALIDATED route | unchanged: the standings a verified frame chain put there |
| `RB-11` | **no longer skips.** It ran `(when carried …)`, so a frame whose event-id is not this lane's `w-`/`c-` shape reached the authoritative type with the identity check never made. Such a frame is now refused |

**⚑ RB-11's skip is this lab's absence-warrant class in this lane's own code.**
*No disagreement found* and *nothing was compared* are different sentences, and
the code said the first while meaning the second — the same disease as a `[ -d ]`
false for both *nothing here* and *could not look*
(`diary/threads/the-absence-that-needs-a-warrant.md`). It sat inside the most
audited function of the lane.

**DISCLOSED FORK R4-F2 — re-derive rather than refuse-on-disagreement.** The chair
offered either. Refusing on disagreement would make **every** raw decode of a
genuine `:occurred` account signal, which destroys the function's only use
(inspecting bytes you hold). Re-deriving keeps the inspection and removes the
authority, and the caller can still read the bytes' own claim from
`carried-standings`. **The narrowest option that keeps the function useful.**

## R4-4. The cure (F3) — the lane now actually looks at its own store

`record-coverage` is the **one** axis on which this lane declares itself
*competent* (BND-5's *"competent over its own store and over nothing else"*). And
the finding was a **caller keyword** carrying a **caller-built `:looked` scope**,
and — the sentence that matters — **no code anywhere in the lane ever scanned the
account store.** An exhaustive reference check found none. The lane asserted
competence over the one universe it is competent over, without looking at it.

- **`ml0-observe-record-coverage (store subject)`** — new production door, and the
  supported producer of a finding (R4.1e wording: not exposed through the exported, supported API; Common Lisp package privacy is not a capability boundary — an internal constructor remains callable through package-internal access — and BOA closes the supported SBCL `#S` route, not every possible call). It walks the whole **validated prefix** of this
  lane's own store, opens every account frame through `ml0-retrieve`, and answers
  on what it found. When the prefix is not `:valid` it answers `:NOT-EXAMINED`
  under a **`:COULD-NOT-LOOK`** scope — never `no issuance record`, because *I
  could not look* and *I looked and it is not there* are different sentences.
- Its reading is a typed `ml0-record-coverage-observation` with an **internal**
  constructor, for the same reason `ml0-observation`'s is internal.
- **`make-ml0-bundle` refuses `:record-coverage` and `:record-coverage-scope`**
  (`ML0-BND-10`) rather than dropping them — the move the chair praised on the
  issuance axis: silently dropping would leave the caller believing it had
  recorded a finding. `ML0-BND-4` and `ML0-BND-5` are **gone**, and their absence
  is the repair: they validated the caller's word and demanded a scope beside it,
  which is the wrong question. The defect was never that a caller might pick a
  word outside the three; it was that the caller got to pick at all.
- **Both branches are seen to fire.** `ml0-selftest` §69 drives the door over a
  **fresh, empty** account store, writes an issuance-bearing account into it, and
  scans again: `:no-issuance-record-in-account-store` → `:issuance-record-present-in-account-store`.
  A door that could only ever report absence would be an instrument never seen to
  fire.
- The **specimen's own reader stage** now takes its coverage from the door instead
  of naming it.

## R4-5. The choice (F4) — the claim was corrected, the code was not restructured

`ml0-write`'s docstring asserted *"everything that can refuse runs BEFORE the
append, so a failed write is observably non-mutating over the WHOLE declared
store."* Two paths refute it: the readback (step 6) and the WR-5 identity check
(step 7), both after `append-event`, in an append-only store with no rollback.

**CHOSEN: (a), the honest correction — and here is why, since the writ asked.**
Restructuring so nothing can refuse after the append would mean **giving up the
readback**, because the readback's whole point is that *"the append did not
error"* is not evidence the frame was written: it re-reads the bytes from disk
through `validate-journal`. A write that verified nothing would be non-mutating on
failure by having no failures to speak of. **The verification is worth more than
the atomicity claim**, and the honest thing is to have both facts stated rather
than one of them quietly untrue.

The true semantics now appears in **three places, in the same words**: the
docstring, SPEC §8, and GUIDE §4/§7 — pre-append refusals leave the store
byte-unchanged; a readback or WR-5 refusal has the frame **already appended**, the
frame is **retained as evidence** (deleting it would destroy the record of the
failure), and **no account is returned**, so nothing downstream can read a
standing off it.

**AND IT IS MEASURED, NOT NARRATED — with the synthesis disclosed.**
`ml0-controls` **TOOTH 11** takes the store scope on both sides of one refused
call and shows the store **changed**. ⚠ **The trigger is synthesised, and the
synthesis is itself a finding**: no reachable input produces a post-append
refusal, because PJ0's `append-event` **verifies the frame chain itself** and
refuses a damaged store *before* writing — **measured, not assumed**: a mid-frame
bit-flip yields `PJ0-PAYLOAD-DIGEST-MISMATCH` from the append, never from the
readback (probe run and read this session). So the overlay carries a **named
control seam**, `:readback-refuses-after-append`, which forces the readback's
*answer* and nothing else. Everything the control measures — write's structure,
its append, the total absence of a compensating delete — is production's. The seam
is **not** one of the six defects, kills nothing, and `ml0-mutants` still reports
six.

## R4-6. The cure (F5) — the effect axis says whose word it is

`make-ml0-effect-observation` reads no world; every field arrives from the
caller's argument list. The SPEC lists world/effect as one of the six commission
questions, so an account was answering a commission question out of caller
testimony, sitting in the durable bytes beside door-read provenance with nothing
marking it.

Every effect observation now carries `provenance :caller-asserted`, **in the type
and in the durable bytes** (`("effect" "provenance")`, first field of the record).
**The mark is not a constructor parameter** — a caller that could pass
`:door-read` would have exactly the field-filling power every repair in this lane
exists to remove — and the decoder **refuses** bytes claiming any other provenance
at `ML0-RB-5` rather than best-effort decoding them. When a world-reading door for
this axis is built it will stamp its own value through an internal constructor,
the way the five observation doors do.

**Narrowest option, and disclosed as such:** the axis is still testimony. Marked
testimony is still testimony. Routing it through a world-reading door is a real
piece of work and it is **not** done here.

## R4-7. WHAT R4 DID NOT FIX — and one new hole, disclosed

1. **Everything in S5 still stands.** The declared-substrate ceiling, the
   self-constructed-store ceiling (the price of the inherited warrant),
   `:contradicted` unreachable, the single-delta pair differing in two legs, and
   `ml0-account-from-event` still exported (now inert in fact as well as in prose,
   which strengthens the case for keeping it).
2. **The effect axis has no door** — §R4-6. Marked, not cured.
3. **NEW, AND IT IS THE PRICE OF THE OVERLAY.** The six defects are no longer
   guaranteed to exercise the **same code path** they used to. Three of them now
   drive production from outside (§R4-2). A future change that broke, say, the
   scope check *inside* `ml0-nonoccurrence-warranted-p` would still be caught —
   the cured arm would fail — but a mutant expressed as a caller is a weaker
   statement about *where* the law lives than a mutant expressed as a branch. **The
   trade was taken knowingly**: a live seam on the public surface is a hole, and a
   slightly-further-out mutant is a weaker instrument, and the hole is worse. It is
   stated here because a cost nobody wrote down is a hole of its own.
4. **NEW, SMALLER, AND IT WILL BITE A LATER CHAIR.** The R4 repairs are a
   **durable-bytes break**: the effect observation's `provenance` field is
   required on readback, so **accounts written by any pre-R4 build cannot be
   decoded by this one** (`ML0-RB-5`). That is deliberate and it is the right way
   round — an unmarked effect reading read back as caller-asserted-by-default would
   be the default doing the asserting — but nothing in this lane migrates old
   bytes, and nothing warns you except this paragraph and the comment beside the
   decoder.
5. **The overlay's control seam is a route into `ml0-retrieve`'s answer** for any
   process that loads the overlay. It is not in the production image and no
   consumer can reach it, but it is a second thing living in that file besides the
   six defects, and files that accumulate seams are how this lane got here.
6. **Nothing here is independent verification.** The Codex audit is a cross-family
   read of the code; it is not an execution-level reverification and it is not
   acceptance. No stranger has reviewed this lane.

## R4-8. Records, and what this round did NOT do

- **SPEC**: new §6a (the public surface carries no mutant seam), the effect-axis
  and record-coverage paragraphs in §5, the raw-decode/authority paragraphs in §8,
  the corrected write semantics with steps 1–7 named, and §11's known-holes list
  extended from four entries to eight — including the amendment to *"same-family
  hands throughout,"* which is now the round's biggest fact rather than a
  footnote.
- **GUIDE**: §2's recipe **extended** (step 7 calls the coverage door; the readback
  prints `standing-authority`), then **extracted programmatically from the document
  and walked literally in a fresh `sbcl --script` process** — `GUIDE-WALK.txt`,
  exit 0, and the **six** lines it prints are the six the guide says it prints.
  §4's refusal table gained five rows; §6 gained the coverage door and two account
  readers; §7's *"the `:defect` parameters are planted seams — do not remove them"*
  bullet is **replaced by its own refutation**, because that bullet was the
  instruction that kept the hole open.
- **`RUN-EXITCODES.txt`**: an R4 block, every exit walked with `$?` immediately
  after the command.
- **`FILE-MANIFEST.txt`**: regenerated **last**, after every payload was final,
  over **every file in the lane**, and verified with `sha256sum -c` before it was
  committed.
- **NOT DONE, ON PURPOSE, AND EACH BELONGS TO THE CHAIR**: the release floor; the
  candidate parcel; the Sol relay; a new chair-verification record. No floor
  registration, no push, no mirror, no `SYNC-PAUSED` touch, no Core /0 export, and
  no edit outside `mneme/memory-layer-0/`.

*— OBTURATOR (Claude Opus 5, subagent), 2026-08-20. CANDIDATE. Nothing here is
adopted, and nothing here is independent verification.*

---

# ══════════════════════════════════════════════════════════════════════════
# ROUND R4.1 — 2026-08-21, THE CONSOLIDATION CONTRACT
# ══════════════════════════════════════════════════════════════════════════

> **⚠ EVERYTHING ABOVE THIS LINE IS PRESERVED AND IS NOT AMENDED — the R1, R2,
> R3 and R4 sections all stand as evidence of what those builds said.** Where a
> count or a claim above is superseded, it is marked here rather than edited in
> place. The file inventory above is an **R1** inventory and is left as one; the
> current inventory is §R4.1-8 below.
>
> **The occasion is not an audit.** No adversary opened this round. The chair
> went looking for whether the lane's **documented durable route for a
> consolidation** actually carried a consolidation — and wrote the probe **before**
> it knew the answer. It did not. Three commits followed: `0f152ade` (the BEFORE
> probe, preserved at exit 1), `e60fc3c5` (the contract), `5489015f` (every caller
> migrated, by the subagent **CONSUTOR**). The failed-write question that surfaced
> beside it is **parked and open** — §R4.1-6.
>
> — SCRIBA (Claude Opus 5, 1M context), records officer, 2026-08-21.
> Chair: Claude Fable 5. Contract: the chair. Caller migration: CONSUTOR
> (Claude Opus 5, subagent).

## SUPERSEDED COUNTS AND CLAIMS FROM THE R4 RETURN

| In the R4 sections (and the R4 GUIDE/SPEC) | Now | Why |
|---|---|---|
| `ml0-consolidate` returns **five bare values** and a caller carries them into `ml0-write :derivation :consolidation` | it returns **ONE value: an `ml0-consolidation` carrier**, and `ml0-materialize-consolidation` is the only durable route out of it | the documented route could not carry the result — §R4.1-0 |
| `ml0-write` arglist takes `:derivation` and `:predecessors` | **both are gone**; it writes `:direct-write` with no predecessors, always | lineage was caller-selected |
| **builder fork F-2** (preserved above): *"a durable derived account is produced only by passing the result to `ml0-write` with `:derivation :consolidation` … Narrowest: one path to a durable derived account"* | **SUPERSEDED — the fork's premise was false and was never tested.** That path did not preserve the result: it downgraded every inherited warrant and rewrote a computed `:OCCURRED` as `:UNRESOLVED`. The narrow-looking option was narrow about the *number of doors* and wide open about *who selects a standing* | §R4.1-0. F-2 stands above as evidence of what R1 believed |
| requirement **`ML0-WR-2`** (a caller-supplied derivation outside the vocabulary) | **withdrawn with the argument** | a requirement that polices a word the caller cannot say is not a requirement |
| declared external API: **177** | **195** = **148 functions · 27 variables · 20 types** | the carrier, its fifteen readers, `ml0-consolidation-p`, `ml0-materialize-consolidation` (+17 functions), and the `ML0-CONSOLIDATION` type (+1) |
| the GUIDE's *"145 declared external names: 103 functions · 25 variables · 17 types"* (§1 and §6) | **195 / 148 · 27 · 20** | ⚠ **this was already stale at R4** — R4 raised the count to 177 and did not update the guide; the R4 received review caught the discrepancy. The figure now printed was **read out of a loaded image**, not off the source text |
| `ml0-selftest`'s check **[055]** (*"consolidation ORDERS BY CONTENT-DERIVED IDENTITY, not by argument order"*) sat in the **passing** column | it was **passing VACUOUSLY** — `(nth-value 4 …)` was NIL on both sides, so it reduced to `(equal nil nil)` | §R4.1-4 |
| `ml0-red-proof` printed *"the tooth bites"*, exit 0 | it printed that with **one third of the crown tooth dead** | §R4.1-3 — the round's most important finding |
| `:contradicted` is *"reachable only by a future second witnessing mechanism"* | **still true of the doors; no longer true of the bytes** — a lawfully computed `:contradicted` is now written and read back across a process boundary | §R4.1-7 item 1 |
| the SPEC's §11 known holes: **eight** | **ten** | two added, §R4.1-7 |
| `GUIDE-WALK.txt`, R4 capture | **re-taken as an R4.1 capture** — the guide changed, so the walk was re-run; the extracted recipe body is byte-identical to R4's (`cmp` = 0) | a walk inherited from an edited document is an inspection wearing a simulation's clothes |

## R4.1-0. What was wrong: the documented durable route could not carry the result

The chair wrote `ml0-consolidation-proof.lisp` against **R4 as shipped**, walking
the route the R4 SPEC and GUIDE both named — `ml0-consolidate` → five bare values
→ `make-ml0-bundle :sources` → `ml0-write :derivation :consolidation` — and ran it
before repairing anything. `RED-CONSOLIDATION-BEFORE.txt`, exit **1**, lab HEAD
`635586f9`, **7 checks, 4 failures**. The four failures and the lines that
produced them, quoted verbatim — checks `[001]` and `[007]`, both `ok`, are
elided and are the only omissions:

```
---- consolidation (in-memory) ----
  occurrence :OCCURRED  issuance :ISSUED-IN-WRITING-IMAGE  sources 4  predecessors 2  inputs 2
[002] ok   consolidation COMPUTES :OCCURRED over the union
[003] FAIL consolidation's result is a TYPED carrier, not bare values
[004] FAIL consolidation REFUSES a raw-decode (non-validated) input with a typed condition
---- the documented durable route: make-ml0-bundle :sources -> ml0-write ----
  derived occurrence :UNRESOLVED  derivation :CONSOLIDATION  predecessors 2  sources 4
  derived row standings: (:STORED-ASSERTION :STORED-ASSERTION :STORED-ASSERTION
                          :STORED-ASSERTION)
[005] FAIL the DERIVED account, retrieved, carries the standing consolidation COMPUTED (:occurred)
[006] FAIL the derived account's rows are NOT converted to testimony
```

Read those four lines together and the defect is one defect, not four:

1. **`:sources` is the public TESTIMONY channel, and it did its job.** It
   normalizes every inherited row to non-warranting testimony — correctly, since
   R2's whole cure was that a freely-callable channel must never produce a
   promotion-capable row. So the four inherited warrants arrived as
   `:STORED-ASSERTION` and the re-derived standing could only be `:UNRESOLVED`.
   **A computed `:OCCURRED` went in and an `:UNRESOLVED` came out of the store.**
2. **A lawfully computed `:CONTRADICTED` was worse off**: the direct-write
   self-contradiction rule `ML0-WR-6` refused the bundle outright — a refusal
   that is right about a *bundle* and wrong about a *derivation*, applied because
   the derivation had been routed through the bundle door.
3. **Lineage was caller-selected.** `:derivation` and `:predecessors` were
   ordinary keyword arguments. Anyone could write `:derivation :consolidation`
   over any bundle at all and the account would say so in its durable bytes.
4. **Any account could vote.** `ml0-consolidate` admitted a `:RAW-DECODE`
   account — one whose standings were re-derived from rows that warrant nothing —
   with no gate at all.

**The shape of it is this lane's own recurring class, one remove out again.** R2
closed row-minting at `make-ml0-source`; R3 closed it at `ml0-source-from-record`;
R4 closed it at the `defect` **parameter** and at the raw decoder's standings.
R4.1 found it in the **derivation and predecessor arglist of the write door** —
the last place a caller could still hand the lane a conclusion. *Truth-minting
migrates, and it migrates into argument lists.*

⚠ **And the honest note about that BEFORE capture, since a capture that cannot be
re-run is a capture that must say so.** The first version of
`ml0-consolidation-proof.lisp` **cannot be kept alive** in the tree: the API it
walks no longer exists (`ml0-write` lost the two keywords). It lives in commit
`0f152ade` and its transcript lives beside the current probe. The current file's
own header says this rather than leaving a reader to discover it.

## R4.1-1. The repair — a typed carrier, constructed in one place

`ml0-consolidate` now returns **one value**: an `ml0-consolidation` struct.

```
act-id · act-id-hex · subject-seat · subject-attempt · subject-principal
occurrence-standing + occurrence-scope     (RE-DERIVED over the union)
issuance-standing   + issuance-scope       (folded on its OWN axis)
record-coverage     + record-coverage-scope
sources        the EXACT union, deterministic order
predecessors   CD/0 identifiers, in ordered-input order
inputs         the deduped, content-ordered accounts
clash          (positive . negative) when :contradicted
```

Four properties, each of which closes one of the four failures above:

- **THE CONSTRUCTOR IS NOT EXPORTED** (`%make-ml0-consolidation`; R4.1e: it remains
  callable through package-internal access — not exposed through the exported, supported API; Common Lisp package privacy is not a capability boundary — an internal constructor remains callable through package-internal access — and BOA closes the supported SBCL `#S` route, not every possible call), the same move the
  observation doors made on the row constructor. ⚑ **(R4.1c wording — the
  narrower facts, replacing this bullet's original "the only way to hold a
  carrier is to have called `ml0-consolidate`; the only thing that writes one is
  `ml0-materialize-consolidation`".)** (1) **No constructor is exported.** (2) The
  supported SBCL `#S` **default-constructor** route is refused because all ten
  lane structures use **BOA** constructors. (3) **Construction privacy is defense
  in depth, not the soundness boundary.** (4) Materialization treats the carrier
  as an **untrusted request**: it re-retrieves the carrier's input identities from
  the target store and writes the recomputed body. (5) The exact claim: **no
  presented body field selects durable standing or lineage; input identities
  select what the store is asked to retrieve, and the resulting body is recomputed
  and checked by canonical-body SHA-256 digest.** **No ordinary argument selects a
  standing or a lineage any more** — `ml0-write` writes `:direct-write` with no
  predecessors, always, and it no longer has the keywords to be asked otherwise.
- **THE VALIDATED-RETRIEVAL GATE (`ML0-CON-3`)** admits only accounts whose
  `ml0-account-standing-authority` is `:validated-retrieval`. A `:raw-decode`
  account is refused with a typed condition. The gate runs **before** the
  act-identity comparison, because an unvalidated account's act identity is
  itself only a claim. This is R4's `standing-authority` field finally being
  *used* by something rather than merely readable.
- **ONE SUBJECT CARRIER (`ML0-CON-4`)** — §R4.1-2.
- **MATERIALIZATION SHARES THE APPEND TAIL.** Steps (5)–(7) of a durable write —
  mint the content-derived identity, append once, read the frame back through
  `validate-journal`, compare identities (`ML0-WR-5`) — are now the single
  internal function `%ml0-append-body-and-read-back`, called by the direct route
  and the derived route alike. **The two cannot drift**, and the failed-write
  semantics (and the open variance beside them, §R4.1-6) are identical on both.

**What materialization does NOT do**, stated because a new write path is exactly
where a promotion rule gets re-run by accident: it does not re-run the
direct-write promotion rule (the standing was computed by consolidation over the
union and is written **as computed**, `:contradicted` included); it does not apply
`ML0-WR-6` (that refusal belongs to a single bundle — a contradiction *between*
accounts is the thing consolidation exists to record); it reads no world and no
act journal; it performs nothing, issues nothing, authorizes nothing.

**MEASURED (at the R4.1 execution — 27 checks; the shipped proof is 35 checks,
see §R4.1b-4 and §R4.1c):** `RED-CONSOLIDATION-AFTER.txt` — **27 checks, 0
failures, exit 0**, including a **fresh-process** retrieval of the derived account (`:OCCURRED` /
`:CONSOLIDATION`, a genuinely new `sb-ext:run-program` process opening the store
from bytes on disk), byte-identical derived content under **reversed input order**,
and the modelled `:CONTRADICTED` case surviving materialization and a second fresh
process.

### DISCLOSED FORK R4.1-F1 — why a separate carrier, and not `ml0-write` accepting a union type

The narrower-looking option was to keep **one** write entry point and let it take
either an `ml0-bundle` or a consolidation result, dispatching on type. It was not
taken, and the reasons are worth having on the record because the rejected option
is the one a later chair will re-propose:

| shape | why not |
|---|---|
| `ml0-write` takes `(or ml0-bundle ml0-consolidation)` | **one function, two contracts, one docstring** — and the docstring's load-bearing sentence is *"the promotion rule computes the occurrence standing from the sources; a caller cannot assert its way past it."* That is **false of the derived branch**, where the standing was computed elsewhere and is written as computed. A single door whose central promise holds on half its calls is the shape of every defect this lane has repaired. |
| keep the keywords but validate them harder | this was **R4's** posture (`ML0-WR-2` validated the derivation against the closed vocabulary) and it is precisely what failed: the vocabulary check confirms the caller said a *legal* word, never that the caller was *entitled* to say it. Validating a field a caller should not be filling is the cheaper repair that satisfies the letter. |
| **TAKEN** — two entry points, two contracts, **one shared tail** | each door states one promise and keeps it; `ML0-WR-6`'s scope stays exactly a bundle's; and the part that must not drift (append + readback + identity check) is literally one function, so drift is not a discipline but an impossibility. |

**The cost, stated:** the public surface gained a second write verb, and a reader
must now know which door a derived account came out of. `ml0-account-derivation`
answers that in the durable bytes, and `ml0-block-proof` [018] measures that
`ml0-write` can no longer be asked for the other answer.

### DISCLOSED FORK R4.1-F2 — the subject principal is the ACTOR, and the specimen was writing the recorder

`ML0-CON-4` refuses inputs that share an act but not a `subject-seat` /
`subject-attempt` / **`subject-principal`**. Seat and attempt are inputs to the act
identity and so follow from `ML0-CON-2`; **the subject principal is not**, so it is
*checked* rather than taken from whichever input happened to sort first.

The rule is **spec-faithful, not new**. `MEMORY-LAYER-0-SPEC.md` §5 (line 126) has
said since R1:

```
subject-principal principal:<the actor>    (whose act it is ABOUT)
```

Enforcing it exposed that the **specimen's lector stage had been writing its own
name there** — the recorder in the subject's field. Under the R4 API nothing
compared the two, so the misuse was durable and silent. The correction, at its
true size and with the accounting CONSUTOR measured:

- **Seven sites** in `de-actu-memorato/stage-reader.lisp` now pass
  `*scriptor-process*` (the actor) instead of `*lector-process*` (the reader).
- **Three of the seven were REQUIRED** by the gate (`*d6-negative*`, D6(b),
  D6(e)) — those consolidations mixed the lector's account with the scriptor's and
  `ML0-CON-4` fired. **Four were NOT required** (D6(c)×2, D6(d)×2): both sides
  shared `*lector-process*`, so the check never fired. They are the **same
  misuse**, corrected for consistency, and the distinction is named here rather
  than hidden inside a green gate.
- **The convention was already the specimen's own**, not an import: the D2 second
  reading and the lector's first account of the *moriturus*'s act **already**
  passed the actor. **D6 was the deviation.**
- **MEASURED in the durable bytes**, not assumed: in
  `ARTIFACT-ACCOUNTS-FINAL.pj0`, occurrences of `"lector"` went **23 → 9** and
  `"scriptor"` **11 → 25** (72322 → 72350 octets, `37a10ca9…` → `d9d160f2…`). The
  **nine surviving `"lector"` occurrences are `recording-process`** — the lector's
  own identity, exactly where the SPEC puts it, and it did not move.
- **Specimen: 45 checks, 0 failures, RESULT: PASS.**

⚠ **AND THE SPECIMEN TRANSCRIPT IS NOT A WITNESS TO THIS REPAIR.** `RUN-SPECIMEN.txt`
is **byte-for-byte its R4 capture**, sha256
`39849f9968512934ac9586397bb59b2211107e4a95731f6fc8ca82c0f99c4388`, twin-run
`cmp` = 0 — *while the payload above changed*. The transcript prints no D6 account
identity, so a reader comparing transcript digests across R4 and R4.1 would
conclude that nothing changed. **A determinism twin is evidence about one build
against itself, never about a build against its predecessor**, and this is the R4
stale-transcript defect inverted a second time: there a manifest agreed with a
fossil; here a genuinely fresh capture is indistinguishable from one.

## R4.1-2. The gates, before and after

Quoted from the `RUN-EXITCODES.txt` R4.1 block, which CONSUTOR walked with `$?`
taken immediately after each command, invocation directory `experiments/latent-lisp`
for every row, warnings counted from each run's own output.

| gate | before the migration | after |
|---|---|---|
| `ml0-selftest.lisp` | exit 1 · 81 checks, **5 failures** `[054][056][057][060][063]` | exit 0 · **81 checks, 0 failures** |
| `ml0-controls.lisp` | exit 1 · 11 controls, 10 caught, **1 missed** (TOOTH 4) | exit 0 · **11 controls, 11 caught, 0 missed** — *the R4.1 execution; **13/13 as of R5*** |
| `ml0-mutants.lisp` | exit 1 · 6 defects, 5 killed, **1 survivor** (mutant 4) | exit 0 · **6 defects, 6 killed, 0 survivors** |
| `ml0-block-proof.lisp` | exit 1 · **unhandled `ML0-CONSOLIDATION-REFUSED [ML0-CON-4]`** at B2 | exit 0 · **20 probes, 20 closed, 0 open** |
| `ml0-consolidation-proof.lisp` | exit 0 · 27/27 (already green; not edited) | exit 0 · **27 checks, 0 failures** — *the state at the R4.1 execution; 34 at R4.1b, **35 as shipped*** |
| `ml0-red-proof.lisp` (combined) | exit 0 · *"the tooth bites"* — **and one conjunct was dead**, §R4.1-3 | exit 0 · *"the tooth bites"*, conjunct **re-armed** |
| `ml0-red-proof.lisp` **uncured** arm | — | **exit 1** (must be nonzero) · `after CONSOLIDATION : :OCCURRED` · **CROWN TOOTH FAIL** |
| `ml0-red-proof.lisp` **cured** arm | — | **exit 0** (must be zero) · `after CONSOLIDATION : :UNRESOLVED` · **CROWN TOOTH PASS** |
| `ml0-host-fault-proof.lisp` | exit 0 · PASS (not edited) | exit 0 · **PASS** |
| `de-actu-memorato` specimen | exit 1 · 45 checks, **7 failures** · RESULT: FAIL | exit 0 · **45 checks, 0 failures** · RESULT: PASS |

**Warnings: 0 in every gate**, counted from each run's own output.

**Consumed lanes: thirteen regressions, all exit 0**, walked by the chair
(Claude Fable 5) after the migration and appended to `RUN-EXITCODES.txt` as their
own sub-block — Core /0 (173 checks · 29 substrate teeth), One Act /0 (loader
witnesses 6/6, loader-disease porcelain unchanged), One Act /1 (37 checks · 14
controls · 3 mutants · host-fault PASS · red-proof tooth bites), Capability /2
(selftest + controls PASS), `de-effectu-incerto` PASS, and one bare
`run-specimen.lisp` row whose lane the chair's list does not name — **read in
position** as One Act /1's `de-actu-resurgente` and **flagged as an inference**
in the exitcodes block rather than written in as a fact (seven lanes in this tree
own a file by that name; it is certainly not *this* lane's, which is walked by
name in the migration block). This lane changed a public arglist; the check that
nothing downstream fell over is the check that arglist changes owe.

**The declared API is execution-verified, not read off the source.** Loading
`load.lisp` and printing the loader's own numbers:
`functions 148 · variables 27 · types 20 · sum 195 · declared 195 ·
shortfall NIL`. `ml0-api-shortfall` asserts the declared total against the sum of
the three lists and enumerates every declared name, so *nothing wrong* can never
be the answer of a check that never looked.

## R4.1-3. ⚠ A DISARMED CROWN TOOTH IN A GREEN GATE — the round's most important finding

This is the finding of the round, and it is not the contract.

`ml0-red-proof.lisp` is the lane's crown: the two-armed proof that the certificate
does not eat the event. Its predicate:

```lisp
(defun crown-tooth (retrieved consolidated-occurrence)
  (and (not (ml0-account-occurred-p retrieved))
       (not (eq :occurred consolidated-occurrence))          ; <- this one
       (not (eq :occurred (ml0-account-occurrence-standing retrieved)))))
```

The call site passed `(ml0-consolidate (list retrieved second-written))`. Under
R4.1 that is a **struct**. So the middle conjunct compared a keyword against an
`ML0-CONSOLIDATION` and **could not be false**. The consolidation third of the
lane's crown tooth was **DEAD** — and:

- the gate **exited 0** through the entire caller migration;
- it printed **`ml0-red-proof: cured PASS, uncured FAIL — the tooth bites`**;
- **nothing anywhere failed.**

**The exit code could not see it. The transcript could:**

```
  R4 capture (RED-PROOF-ISSUANCE-AFTER.txt, line 39)
        after CONSOLIDATION  : :UNRESOLVED
  the R4.1 walk, BEFORE the repair
        after CONSOLIDATION  : #S(ML0-CONSOLIDATION
```

It was found by **diffing a preserved transcript against a live one** — nothing
else in the apparatus was capable of finding it.

**Repaired** by reading the standing off the carrier at the call site. **The
predicate is untouched and nothing was relaxed.** The proof that the conjunct is
now load-bearing is that **the two arms disagree on it**, which was invisible while
it was dead:

```
  cured   arm : after CONSOLIDATION : :UNRESOLVED   CROWN TOOTH : PASS   exit 0
  uncured arm : after CONSOLIDATION : :OCCURRED     CROWN TOOTH : FAIL   exit 1
```

**FILED AT ITS CLASS, WHICH IS LARGER THAN THIS LANE.** This is the lab's
*absence needs a warrant* class (CLAUDE.md §I-f) **in a substrate it had not been
recorded in**. The class has been caught in statistics (a null branch with no
equivalence margin δ), in gates (TESSERA: *a gate that has never fired is
untested, not passing*), in the filesystem (`[ -d ]` false for both *nothing here*
and *could not look*), and in test suites (a clean pass over a live defect). Here
it is in **a green gate whose check had stopped being able to fail** — the same
disease as TESSERA's, but one rung colder: TESSERA's cure is *plant a fault and
show the gate catches it*, and this gate **would have passed that test on the day
it was written**. It went dead later, silently, because something it consumed
changed type. The general statement:

> **A gate's greenness is a warrant only for the checks that could still have
> gone red. A type change under a check is an unmeasured retirement of that
> check.** When a return type changes, **read what every gate PRINTS**, not only
> what it exits.

**The sweep that followed, and its honest size.** CONSUTOR enumerated **29**
`ml0-consolidate` call sites outside `ml0.lisp` across **8** files and inspected
each consuming context for the same carrier-as-keyword shape: all 29 now wrap the
call in a reader, bind and read via readers, or discard the value inside a
refusal test. **No second instance of this class remains in the lane.** That is a
sweep's result over an enumerated universe — it is *"I looked at all 29 and there
were none"*, which is a warranted absence at that scope and **not** a claim about
any other call-shape or any other lane.

**And the preserved captures were NOT re-taken.**
`RED-PROOF-ISSUANCE-{BEFORE,AFTER}.txt` are R4's record and are left exactly as
they ran. Their `after CONSOLIDATION` lines happen to match this build again —
**that is a coincidence of value, not a re-verification**, and the exitcodes block
says so.

## R4.1-4. Two smaller things the migration exposed

**(a) A check that had been passing VACUOUSLY.** `ml0-selftest` **[055]** —
*"consolidation ORDERS BY CONTENT-DERIVED IDENTITY, not by argument order"* — read
`(nth-value 4 (ml0-consolidate …))` on both sides. Once consolidate returned one
value, both were NIL and the check reduced to `(equal nil nil)` = **T**. It sat in
the **passing** column of the 81 through the whole red build. Migrating it to
`ml0-consolidation-inputs` restores the comparison it was written to make, and an
`(and a b …)` guard was added so it cannot go vacuous by that route again. **Same
family as §R4.1-3: the failing checks announced themselves; the disarmed ones did
not.**

**(b) A PJ0 fact measured, and a prediction that lost to its own instrument.**
`ml0-consolidation-proof` check **[016]**:

```
[016] ok   two materializations of BYTE-IDENTICAL derived content land on ONE
           frame (PJ0 append idempotency on content-derived identity) (2 -> 3 frames)
```

Because the account identity digests the whole canonical body, two materializations
of identical derived content mint the **same** event identity, and Journal /0's
writer reconciles an identical re-append **without appending** (`PJ-APP-2`; the
idempotency cluster is `PJ-APP-1..3`, `mneme/journal0/writer.lisp`). **The chair's
first draft of that check expected TWO frames and was corrected by the
measurement.** It is recorded because a prediction that lost to its own instrument
is worth more on the record than a check that never had one — and because the
frame count, `2 -> 3`, is the evidence rather than the narration.

## R4.1-5. What the round did to the caller lanes — and one commit the chair must dispose of

Six files were migrated to the carrier by CONSUTOR (`ml0-selftest`,
`ml0-controls`, `ml0-mutants`, `ml0-block-proof`, `ml0-red-proof`,
`de-actu-memorato/stage-reader`). Two facts about that work belong here rather
than in a staging file:

**No check was added, removed, or softened.** 81 → 81, 11 → 11, 6 → 6, 20 → 20,
45 → 45. Where a `multiple-value-bind` became a `let` plus readers, the predicate
is the same predicate; the one place a conjunct was *added*
(`(ml0-consolidation-p c)` at `[054]`) sits **beside** the existing conjuncts and
replaces none of them.

⚠ **A CHECKPOINT COMMIT IN THE LANE'S HISTORY CANNOT BE READ BY SBCL, AND HISTORY
WAS NOT TOUCHED.** `c4c7be83` — *"checkpoint: 2 file(s) in experiments,tools"* —
was made by the `session-checkpoint` **Stop** hook, capturing `ml0-selftest.lisp`
*between* one edit and its paren fix. **Verified by execution, twice, by two
different hands**: extracting that commit's file and running it under
`sbcl --script` gives **exit 1** with `SB-C::INPUT-ERROR-IN-LOAD` / *"READ error
during LOAD"* / **"unmatched close parenthesis"** — it does not load at all. The
**working tree is correct**; only that intermediate commit is broken, and no
history was amended, reset or rewritten by anyone. **The chair decides** whether to
squash it into the migration commit or keep it as an honest fossil. This is exactly
the class CLAUDE.md §I-j names — *a Stop hook fires at turn end, and background
agents outlive turns* — and the same hook fired again during **this** documentation
round (`2b4e1d5f`), catching a half-finished GUIDE edit. **Neither hook commit
pushed anything**: the hook commits locally and never publishes.

**Chair's disposition (Claude Fable 5, 2026-08-21): KEPT AS FOSSILS, NOT SQUASHED.**
Three checkpoint commits of in-flight work exist in this round (`c4c7be83`,
`2b4e1d5f`, `aebec9f9`); none was pushed at the time of the decision, and all are
superseded by the next real commit in each case. CLAUDE.md §I-j's ruling governs:
expect checkpoint commits of in-flight work, keep their messages neutral, never let
them read as adoptions — and never rewrite history to tidy them, because the cure
(an agent-lock) fails toward data loss. An unloadable intermediate is an honest
record of when the hook fired; the working tree and every later commit load.

## R4.1-6. ⚠ THE FAILED-WRITE GOVERNANCE VARIANCE IS OPEN

R4 corrected `ml0-write`'s claim about failed writes from *"observably
non-mutating over the WHOLE declared store"* to the true verified-after-append
semantics: refusals from steps (1)–(5) leave the store byte-unchanged; a refusal
from the readback or from `ML0-WR-5` happens with the frame **already appended**,
the frame is retained as evidence, and no account is returned. R4.1 changes
nothing about that behaviour and **extends it to the derived route**, since
materialization shares the same tail.

**But the work order's §5.A requires the thing the lane does not do** — *"failed
writes observably non-mutating over the whole declared store (digest the store
before/after on **every** refusal path)"*, unamended, and Amendment 1 says
*"Everything else in this order stands unchanged."* **So the corrected docstring
is a variance from the order, not a reading of it, and the variance has never
been ruled on.**

The chair prepared a question for Sol and **parked it**:
`notes/2026-08-21-ml0-failed-write-variance-question-for-sol.md`. It offers **two
dispositions** — **(A)** retain §5.A, in which case the lane carries an open
defect and meeting it would require structural work outside this lane (Journal /0
is CLOSED and FROZEN and its **entire** public surface contains no verb that
removes, truncates or supersedes a frame; and a retraction verb would contradict
*/0 never forgets*); **(B)** amend §5.A explicitly to the disclosed
retained-frame semantics — plus **one in-lane narrowing** offered and **not
taken**: a pre-append dry decode, which would move every decoder refusal the lane
could raise on its own frame to *before* the append, shrinking the unmet residue
to host-fault-after-append and nothing else.

**STATUS, AND IT IS THE WHOLE POINT OF THIS SECTION: OPEN.** *Not closed, not
amended, not waived.* The question is **parked and unsent** — it travels only with
the owner's leave, and only as its own message. The chair's recommendation ((B)
with the dry decode) is on the record **as a recommendation, which is not a
disposition**. The SPEC's §8 failed-write wording is **deliberately left
unamended** for the same reason: rewriting it would close by editing what has not
been closed by ruling. The pointer beside it says so.

> ⚑ **ANSWERED BY SOL, 2026-08-21 — DISPOSITION B (appended in round R5; the section above is
> preserved unedited).** Sol amended work-order §5.A to the retained-frame semantics **and
> required the in-lane narrowing this section offered and did not take**: a pre-append dry decode.
> The item is **no longer OPEN.** The chair's recommendation, which was correctly labelled *"a
> recommendation, which is not a disposition"*, became a disposition made by the one who could
> make it. Governing text, structure, measures: WORK-ORDER **AMENDMENT 2** and the RETURN's **R5**
> section. Implementation: `%ml0-dry-decode` at step (4b) of the shared append tail, `ML0-WR-8`,
> CONTROLs 12–13; the designed post-append residue is now **host fault only** (CONTROL 11).

## R4.1-7. Holes carried forward — updated, not replaced

Everything in §R4-7 still stands, with two amendments and two additions.

1. **`:contradicted` — AMENDED, AND ONLY HALF OF IT CLOSED.** R4 listed it as
   *unreachable*. Both halves, because either half alone would be a false
   sentence: **(i) it is now reachable in the BYTES** — when consolidation
   lawfully computes `:contradicted`, `ml0-materialize-consolidation` writes it as
   computed and a **fresh process** reads it back
   (`RED-CONSOLIDATION-AFTER.txt` [023]–[027]); before R4.1 the standing could be
   computed and had nowhere to go. **(ii) it is still unreachable from two correct
   production doors** — two correct doors reading one universe over one interval
   agree by construction, so the clash in that probe is **MODELLED**: a real
   absence door's row, door-validated and subject-bound, re-copied onto the
   positive row's universe and interval **through the lane's internal row
   constructor, from inside the lane package**, which no caller outside it can do.
   What is demonstrated is that the layer **preserves and durably records** such a
   clash. What is **not** demonstrated is a clash arising naturally. The controlled
   case is *modelled*, and the probe's own header says so before it runs.
2. **The effect axis still has no door.** Marked testimony is still testimony.
3. **The overlay's three re-expressed mutants** are still one remove further out
   than the seams they replace.
4. **The R4 durable-bytes break still stands** — pre-R4 accounts cannot be decoded
   by this build (`ML0-RB-5`), and nothing migrates old bytes.
5. **NEW — the disarmed-tooth class is now a known hole of the METHOD, not of the
   code.** §R4.1-3. The instance is repaired and the sweep found no second one in
   this lane; what is *not* fixed is that nothing in the harness detects a check
   that has stopped being able to fail. The cure applied here was a human reading
   two transcripts side by side.
6. **NEW — the specimen transcript is not a witness to the specimen's own
   payload.** §R4.1-1/F2. `RUN-SPECIMEN.txt` did not change while
   `ARTIFACT-ACCOUNTS-FINAL.pj0` did.
7. **`FILE-MANIFEST.txt` IS STALE AND WAS DELIBERATELY NOT TOUCHED.** It hashes
   the R4 bytes of the six `.lisp` files this round edited and of the three
   regenerated specimen artifacts, and it does not hash
   `ml0-consolidation-proof.lisp` or the two `RED-CONSOLIDATION-*` captures at
   all. **Regenerate it, never hand-edit it** — the R4 chair's own cure for the
   stale-transcript defect — and regenerate it **last**, after every payload is
   final, or it will pass over fossils. Likewise `FLOOR-RESULT.txt` is an R4
   record and no release floor was run this round.
8. **Same-family hands, still.** The R4 Codex audit was a **static** cross-family
   read of the code. **This round had no outside at all**: chair, builder and
   records officer are three Claude instances. Nothing here is independent
   verification and **no stranger has reviewed this lane.**

## R4.1-8. Records — the current file inventory, and what this round did NOT do

The **R1 file inventory above is preserved as an R1 inventory** (the R4 header's
law) and its counts are stale by four rounds. The lane as it stands:

**Lane root — `mneme/memory-layer-0/`**

| File | What it is |
|---|---|
| `MEMORY-LAYER-0-WORK-ORDER.md` | the chair's order + AMENDMENT 1 — **§5.A is under an open variance, §R4.1-6; the order is byte-untouched** |
| `MEMORY-LAYER-0-SPEC.md` | the normative spec; R4.1 amends §5, §6, §8/Write, §8/Consolidate, adds §8/Materialize, and §11 (ten holes) |
| `MEMORY-LAYER-0-GUIDE.md` | lawful use, the crown refusal, the symbol table (**195** names); R4.1 amends §1, §4, §5, §6, §7 |
| `MEMORY-LAYER-0-RETURN.md` | this document |
| `package.lisp` · `load.lisp` | the package and the COMPLETENESS-CHECKED loader; **195 declared external names**, asserted against the sum of three lists |
| `ml0-fixtures.lisp` · `ml0.lisp` · `ml0-readiness.lisp` | the lane |
| `ml0-suite-ground.lisp` | test infrastructure: the ground and the six source builders |
| `ml0-mutant-overlay.lisp` (R4) | the six defects, **outside** `+ml0-lane-sources+`; `load.lisp` never loads it |
| `ml0-selftest.lisp` | **81 checks** |
| `ml0-controls.lisp` | **11** two-halved controls — *at R4.1; **13 as of R5*** |
| `ml0-mutants.lisp` | **6** planted defects |
| `ml0-block-proof.lisp` (R4) | **20** probes over the audit findings |
| `ml0-consolidation-proof.lisp` **(R4.1, NEW)** | **35 checks** as shipped — the consolidation contract, incl. two fresh-process reader arms and §8's **eight** carrier checks `[028]`–`[035]`. *(27 at the R4.1 execution; 34 at R4.1b — §R4.1b-4, §R4.1c)* |
| `ml0-red-proof.lisp` | the crown tooth, both arms — **its consolidation conjunct re-armed in R4.1** |
| `ml0-host-fault-proof.lisp` | the two-halved host-fault gate |
| `RED-PROOF-ISSUANCE-{BEFORE,AFTER}.txt` | preserved R1 captures — **not re-taken in R4.1** |
| `RED-BLOCK-{BEFORE,AFTER}.txt` · `RED-R2-{BEFORE,AFTER}.txt` · `RED-CODEX-{BEFORE,AFTER}.txt` | preserved RED/GREEN captures of R2, R3, R4 |
| `RED-CONSOLIDATION-BEFORE.txt` **(R4.1, NEW)** | 7 checks, **4 failures**, exit 1 — the contract shown incomplete on R4 as shipped |
| `RED-CONSOLIDATION-AFTER.txt` **(R4.1, NEW)** | **35 checks**, **0 failures**, exit 0 as shipped. *(27 at the R4.1 execution; 34 at the R4.1b refresh)* |
| `RUN-EXITCODES.txt` | every gate walked, with its exit; R4.1 adds the migration block and the consumed-lane sub-block |
| `GUIDE-WALK.txt` | the §2 recipe extracted programmatically and walked in a fresh process — **re-taken as an R4.1 capture** |
| `FLOOR-RESULT.txt` · `FILE-MANIFEST.txt` | **R4 records; both stale, neither touched** — §R4.1-7 item 7 |
| `CHAIR-VERIFICATION-R1-BLOCKED-…` · `CHAIR-VERIFICATION-R4-…` | the chair's own records |

**Specimen — `de-actu-memorato/`**: `specimen-common.lisp` · `stage-writer.lisp` ·
`stage-death.lisp` · `stage-reader.lisp` **(R4.1: seven subject-principal sites)** ·
`stage-damage.lisp` · `run-specimen.lisp` · `RUN-SPECIMEN.txt` ·
`RUN-SPECIMEN-SECOND.txt` (byte-identical to the first) · eleven `ARTIFACT-*`
files · `ARTIFACT-SHA256SUMS.txt` · `ARTIFACT-MANIFEST.txt`. **Three artifacts were
regenerated by the specimen's own run, never hand-edited.**

**NOT DONE, ON PURPOSE, AND EACH BELONGS TO THE CHAIR:** no `FILE-MANIFEST.txt`
regeneration, no release floor, no `verify-release.sh`, no candidate parcel, no
Sol relay (the failed-write question is **parked and unsent**), no new
chair-verification record, no floor registration, no push, no mirror touch, no
`SYNC-PAUSED` change, no Core /0 export, and no edit outside
`mneme/memory-layer-0/` except this round's own staging report.

---

*— SCRIBA (Claude Opus 5, 1M context), records officer, 2026-08-21.
**CANDIDATE · not audited · not adopted · not frozen · not registered ·
same-family hands · no independent verification.** The R4 received review was a
**static** cross-family read of the code, not an execution-level reverification and
not acceptance; **this round had no outside at all** — chair, builder and records
officer were three instances of one lineage. The failed-write governance variance
is **OPEN**.*

# ══════════════════════════════════════════════════════════════════════════
# ROUND R4.1b — 2026-08-21, AFTER SCRUTATOR (CROSS-FAMILY REVIEW OF R4.1)
# ══════════════════════════════════════════════════════════════════════════

> **⚠ EVERYTHING ABOVE THIS LINE IS PRESERVED AND IS NOT AMENDED** — the R1, R2,
> R3, R4 and **R4.1** sections all stand as evidence of what those builds said.
> Where a count or a claim above is superseded, it is marked here rather than
> edited in place. R4.1's own holes list (§R4.1-7) is amended **by a note below**
> (§R4.1b-6), in exactly the way R4.1 treated R4's.
>
> **The occasion IS an audit this time, and R4.1's closing sentence was wrong
> within the day.** §R4.1-8 ends *"this round had no outside at all — chair,
> builder and records officer were three instances of one lineage."* Hours later
> a **cross-family** reviewer opened R4.1: **SCRUTATOR**, a Codex (GPT-substrate)
> worker, reading and **executing** from `/home/gauss/Claude-Code-Lab` with every
> SBCL invocation made from `experiments/latent-lisp`. Its report is
> `_staging/r41-scrutator-findings.md`. Its verdict, verbatim: *"R4.1 is
> **blocked** on the stated design rule."* It returned **two BLOCKERs and two
> DEFECTs**; the chair reproduced all of them, repaired them, and committed
> `fd3d1915`. This section records that repair. **It is the second time in this
> lane that the first non-Claude eye found the blocker** (R4 was the first).
>
> — SCRIBA-II (Claude Opus 5, 1M context), records officer, 2026-08-21.
> Chair: Claude Fable 5. Review: SCRUTATOR (Codex worker, cross-family).
> Predecessor records officer: SCRIBA (R4.1).

## SUPERSEDED COUNTS AND CLAIMS FROM THE R4.1 RETURN

| In the R4.1 sections (and the R4.1 GUIDE/SPEC) | Now | Why |
|---|---|---|
| *"**THE CONSTRUCTOR IS INTERNAL** … the only way to hold a carrier is to have called `ml0-consolidate` over validated accounts"* (SPEC §8/Consolidate, GUIDE §6, RETURN §R4.1-1) | **FALSE AS WRITTEN, AND FALSE SINCE R2 FOR EVERY LANE STRUCT.** `(:constructor %make-X)` suppresses `MAKE-X`; it does **not** suppress Common Lisp's `#S` structure reader. Superseded by the narrower statement (R4.1e): not exposed through the exported, supported API; Common Lisp package privacy is not a capability boundary — an internal constructor remains callable through package-internal access — and BOA closes the supported SBCL `#S` route, not every possible call — concretely: every internal constructor is **BOA**, and `#S` is a `READER-ERROR` | §R4.1b-1. Executed: `RED-HASH-S-{BEFORE,AFTER}.txt` |
| the same claim as made of the **observation door's row constructor** in R2 — *"a row is not a thing a caller can assert"* — and of `%make-ml0-observation`, `%make-ml0-source`, `%make-ml0-account` | **the side door was there the whole time**, in every round since R2 that rested an argument on an internal constructor | §R4.1b-1. This is the round's largest fact: the defect is **lane-wide and pre-existing**, not a scratch on the new carrier |
| `ml0-materialize-consolidation` *"takes from the carrier, unchanged: … the folded standings and their scopes, the **exact** source union … the predecessor identities"* (SPEC §8/Materialize) | **it takes only the INPUT IDENTITIES.** It re-retrieves each input from the **target store** through `ml0-retrieve`, re-runs `ml0-consolidate`, compares the presented carrier's canonical body digest against the recomputed one, and writes the **recomputed** body. A mismatch is a refusal (`ML0-MAT-2`), never a silent correction | §R4.1b-2. A `read-only t` slot is not a frozen list: `rplaca` through the exported reader rewrote a lawful carrier's occurrence basis and the computed `:OCCURRED` still stood |
| materialization worked into any store the caller named (the R4.1 build; SCRUTATOR's first NOTE recorded it as the *"disclosed store-binding ceiling"*) | **cross-store materialization is REFUSED** (`ML0-MAT-3`) — every predecessor must be retrievable from the target store | §R4.1b-2 and **DISCLOSED FORK R4.1-F3**. This **narrows Architecture 0.1's D4 cross-journal case**; the narrowing is an **OPEN governance item** (R4.1c), not "future work" — see §R4.1c |
| the derived account's `subject-principal` | **was being re-prefixed on every materialization** (`principal:principal:…`), so a derived account could never be re-consolidated with its own input (`ML0-CON-4`). `%ml0-bare-principal` now strips exactly one `principal:` and refuses anything else (`ML0-MAT-4`) | §R4.1b-3 |
| `ml0-consolidation-proof.lisp` — **27 checks**, and §R4.1-8's inventory row for it | **35 checks as shipped** (34 at the R4.1b execution, then `[029]`'s enumeration split out); §8 is **eight** checks, `[028]`–`[035]` | §R4.1b-4 and §R4.1c. SCRUTATOR's DEFECT 4: *"the 27-check proof's 'only route' check does not exercise the public routes above"* |
| §R4.1-8's closing: *"**this round had no outside at all**"* | true of R4.1 and **not** true of R4.1b | the header above |
| the SPEC's §11 known holes: **ten** | **ten** — none added, two amended | §R4.1b-6 |
| declared external API: **195** = 148 · 27 · 20 | **195 = 148 · 27 · 20, UNCHANGED** | `ML0-MAT-2/3/4` are **requirement ids, not names**, and `%ml0-bare-principal` / `%ml0-consolidation-body` are internal. Execution-verified this round — §R4.1b-5 |

## R4.1b-0. What SCRUTATOR found — three findings, each with its BEFORE and AFTER

Every capture quoted below was taken by the chair and is on disk in this
directory. The **BEFORE** captures were taken against **R4.1 as committed at
`de3177e6`** — `RED-CARRIER-BEFORE.txt` says so in its own header: *"(ml0.lisp
stashed to its committed state for this run)"*.

### (i) BLOCKER — the `#S` reader is a constructor, and it always was

SCRUTATOR: *"`(:constructor %make-ml0-consolidation) (:copier nil)` suppresses the
conventional `MAKE-ML0-CONSOLIDATION` … but it does not suppress Common Lisp's
standard `#S` structure reader."* Its end-to-end probe built a carrier with
`:OCCURRENCE-STANDING :CONTRADICTED` out of a lawful template, materialized it,
and observed **`(:CONTRADICTED :OCCURRED)`** — *"Validated readback trusted the
caller-selected `:CONTRADICTED` even though re-deriving over its sole positive
source returned `:OCCURRED`."*

The chair reproduced it **lane-wide**, not just on the carrier.
`RED-HASH-S-BEFORE.txt`, captured `2026-08-21T17:21:24Z`, five struct types, five
results:

```
#S(LISP-PLUS-MEMORY-LAYER0:ML0-ACCOUNT :OCCURRENCE-STANDING :OCCURRED
  -> CONSTRUCTED ML0-ACCOUNT
#S(LISP-PLUS-MEMORY-LAYER0:ML0-SOURCE :VALIDATION-STANDING :VALIDATED-
  -> CONSTRUCTED ML0-SOURCE
#S(LISP-PLUS-MEMORY-LAYER0:ML0-OBSERVATION :DOOR :WORLD-DOOR)
  -> CONSTRUCTED ML0-OBSERVATION
#S(LISP-PLUS-MEMORY-LAYER0:ML0-BUNDLE)
  -> CONSTRUCTED ML0-BUNDLE
#S(LISP-PLUS-MEMORY-LAYER0:ML0-CONSOLIDATION :OCCURRENCE-STANDING :OCC
  -> CONSTRUCTED ML0-CONSOLIDATION
```

Read the first two lines again. **`ML0-ACCOUNT` with `:STANDING-AUTHORITY
:VALIDATED-RETRIEVAL`, and `ML0-SOURCE` with `:VALIDATION-STANDING
:VALIDATED-BY-DOOR`, both constructed from outside the package by an ordinary
caller typing a literal.** Those are the two fields on which R3's and R4's whole
argument rests — the field that says *this account came through a validated
retrieval* and the field that says *a door read these bytes*. The `#S` reader
minted both.

`RED-HASH-S-AFTER.txt`, `2026-08-21T17:24:43Z`, same probe, all five:

```
  -> ERROR SIMPLE-READER-ERROR
```

### (ii) BLOCKER — a lawful carrier's lists are rewritable through its own readers

SCRUTATOR: *"`:read-only t` makes the slots non-setfable; it does not freeze the
cons cells returned by `ml0-consolidation-sources` and
`ml0-consolidation-predecessors`."* Its observed readback:

```
occurred-p=T
standing=:OCCURRED
rederived=:UNRESOLVED
warranting-rows=0
predecessor-is-original=NIL
rows=1
```

The chair's reproduction, `RED-CARRIER-BEFORE.txt` (`2026-08-21T17:23:35Z`):

```
PROBE-1 mutated carrier -> WRITTEN standing=:OCCURRED warranting-rows=0
PROBE-3 cross-store     -> WRITTEN into foreign store
```

`RED-CARRIER-AFTER.txt` (`2026-08-21T17:23:46Z`), same probe:

```
PROBE-1 mutated carrier -> REFUSED ML0-CONSOLIDATION-REFUSED [ML0-MAT-2]
PROBE-3 cross-store     -> REFUSED [ML0-MAT-3]
```

**`standing=:OCCURRED warranting-rows=0` is the whole disease in one line.** The
account stood `:occurred` in the durable bytes with **zero rows warranting it** —
the RED disease this lane's SPEC §1 names, *evidence-present treated as*, arriving
by a route nobody had thought to close because the object looked lawful and *was*
lawful when it was made.

### (iii) DEFECT — `subject-principal` was re-prefixed on every materialization

SCRUTATOR: *"Each materialization therefore adds another `principal:`
component,"* and observed `re-consolidation with original => ML0-CON-4`. The
chair's reproduction, `RED-CARRIER-BEFORE.txt`:

```
PROBE-2 principal direct="principal:actus-memoratus" derived="principal:principal:actus-memoratus"
PROBE-2 re-consolidate derived+original -> REFUSED [ML0-CON-4]
```

`RED-CARRIER-AFTER.txt`:

```
PROBE-2 principal direct="principal:actus-memoratus" derived="principal:actus-memoratus"
PROBE-2 re-consolidate derived+original -> ACCEPTED
```

⚠ **NOTE WHAT THAT MEANS ABOUT `ML0-CON-4`, R4.1'S OWN NEW REQUIREMENT.** R4.1
added `ML0-CON-4` (*one derived account has one subject*) and the R4.1 records call
it a cure. It **was** a cure — and for the whole of R4.1 it was also the thing
that fired on the lane's own output, because materialization corrupted the very
field `CON-4` compares. A requirement can be right and still be the alarm that
never stops ringing; nothing in R4.1 heard it, because no R4.1 check ever
re-consolidated a materialized account.

## R4.1b-1. The cure (i) — every internal constructor is BOA, and the reader is shut

All **ten** `(:constructor %make-X)` options in `ml0.lisp` became
`(:constructor %make-X (&key slot …))`. Counted, not recalled: `grep -c
":constructor %make-" ml0.lisp` = **10**, and `grep -n "(:constructor
%make-[a-z0-9-]*)" ml0.lisp` — the plain, non-BOA form — returns **nothing**.
The ten: `ml0-scope` · `ml0-source` · `ml0-subject` · `ml0-observation` ·
`ml0-effect-observation` · `ml0-bundle` · `ml0-account` · `ml0-store-scope` ·
`ml0-record-coverage-observation` · `ml0-consolidation`.

**Why this works, stated plainly rather than assumed:** SBCL's `#S` reader
requires the structure's **default keyword constructor**. A BOA constructor — even
one whose lambda list is `(&key …)` and therefore takes exactly the same arguments
in exactly the same way — is not that constructor, so the reader has nothing to
call and signals a `READER-ERROR`. **The behaviour of the code is otherwise
identical**: every internal call site already passed keywords, and the one slot
with a non-nil default (`provenance :caller-asserted` on `ml0-effect-observation`)
carries that default into the BOA lambda list, `(&key … (provenance
:caller-asserted))`.

⚠ **AND THE PUBLIC CONSTRUCTORS ARE UNTOUCHED.** `make-ml0-scope`,
`make-ml0-source`, `make-ml0-effect-observation`, `make-ml0-bundle` are ordinary
exported *functions* that build a struct through the internal constructor; they
still exist, still take the same arguments, and still normalize everything they
are handed to non-warranting testimony. Nothing about the caller's lawful surface
moved. What moved is that the **literal** is no longer a door.

## R4.1b-2. The cure (ii) — the carrier is not trusted; the store is re-read

`ml0-materialize-consolidation` no longer reads a standing, a scope, a source or a
predecessor off the object it is handed. It takes **only the identities of the
carrier's inputs** (`ml0-consolidation-inputs`), and then:

1. re-retrieves each one from the **target `store`** through `ml0-retrieve` — the
   validated chain, inherited warrants and all. An input the target store cannot
   produce is refused at **`ML0-MAT-3`**;
2. re-runs `ml0-consolidate` over what the store actually returned;
3. builds the canonical body **both** carriers would produce
   (`%ml0-consolidation-body`, internal) and compares their **digests**;
4. on a mismatch, refuses at **`ML0-MAT-2`** — *"A stale or altered carrier is
   refused, never corrected"*, in the code's own words. The refusal prints the
   first twelve hex of each digest, so the disagreement is exhibited and not
   merely asserted;
5. on agreement, writes the **recomputed** body — not the presented one.

The load-bearing sentence, from the code comment the chair left at the site:

> *A carrier is a data object a caller holds, and a data object can be copied, and
> its list cells can be rewritten through the very readers that make it
> inspectable.*

**`copy-structure` is therefore no longer a threat and is checked as such** —
proof check `[032]` (`[031]` at the R4.1b execution; §8 gained a check at R4.1c's
count sync): *"a `COPY-STRUCTURE`'d lawful carrier materializes the SAME content
as the original (copying mints nothing)."* It could not have been checked
that way in R4.1; there, a copy was as good as the original because the original
was believed.

### ⚑ DISCLOSED FORK R4.1-F3 — cross-store materialization is now REFUSED

**The choice:** step (1) re-retrieves from the **target** store. A carrier computed
over accounts of store A therefore **cannot** be materialized into store B.
Before R4.1b it could: `RED-CARRIER-BEFORE.txt` records `PROBE-3 cross-store ->
WRITTEN into foreign store`, and SCRUTATOR's first NOTE describes the same
behaviour from the other side — *"B went from zero to one valid frame and
retrieved the derived account; its predecessors were not present in B"* — and
called it *the disclosed store-binding ceiling*, not a new widening.

**Narrowest option, taken:** refuse. A derived account whose predecessors the
reading store cannot produce is a **lineage claim the store cannot check**, and
this lane's whole argument is that a reader checks rather than trusts. The
alternative — carry an input-store identity in the body and compare — is a real
design and is **not** built here.

**What it costs, said rather than implied:** this **narrows the cross-journal
consolidation case named by Architecture 0.1's D4**. Two stores' accounts of one
act can still be consolidated *in memory* — `ml0-consolidate` is effect-free and
does not know what a store is — but the result cannot be made durable in either
store. Nothing above this line claimed that case worked, and nothing here claims
it does.

⚑ **R4.1c CORRECTS THIS SECTION'S DISPOSITION.** It was written as *"narrowed to
future work"*, which reads as a disposition the chair had no authority to make.
**R4.1-F3 is an OPEN GOVERNANCE ITEM**, with **two dispositions** on the table:
**(A)** accept `/0` as supporting durable consolidation only when every
predecessor is retrievable from the destination store; **(B)** require
receipt-bearing cross-journal materialization now (a design this slice does not
have — source-store identity in the body, a per-predecessor receipt, a
verification rule the destination can run without the source store present, and a
standing rule for warrants the reader cannot open). It has **its own parked
question**,
`notes/2026-08-21-ml0-cross-journal-materialization-question-for-sol.md`. **The
chair recommends (A) for `/0`, and that is a recommendation, not a ruling.**
Architecture 0.1's **D4** — *"cross-journal merges are receipt-bearing
transformations, never timestamp sorts"* — **remains binding on any future
implementation** under either disposition.

## R4.1b-3. The cure (iii) — `%ml0-bare-principal`, and `ML0-MAT-4`

A validated account renders its subject principal as `principal:<name>`;
`ml0-account-body` wraps a **bare** name as `(idf (list "principal" name))`.
Feeding the rendered form back in doubled the prefix. `%ml0-bare-principal`
(internal) strips **exactly one** `principal:` and refuses anything that does not
read that way, at **`ML0-MAT-4`**.

It is a strip, not a normalization: it does not loop, does not trim, and does not
guess. A principal that arrives in any other shape is a refusal, because the only
shape this lane writes is the one shape it strips.

Consequence, measured — proof check `[033]`: *"a derived account can be
RE-CONSOLIDATED with its own input (no `ML0-CON-4`), and the fold is
non-amplifying (same standing, same source union)."* This is the first time in
this lane's life that a derived account has been shown to compose with its own
ancestry.

## R4.1b-4. The proof exercises the routes now — 27 → 34

SCRUTATOR's fourth finding is the one that explains the other three:

> *"Check `[005]` proves only that `%MAKE-ML0-CONSOLIDATION` is not external.
> Check `[019]` proves only that an object failing `ml0-consolidation-p` is
> refused. A public `#S` object passes that predicate … This explains how all 27
> checks pass while both design-rule bypasses and `ML0-CON-4` failure remain
> reproducible."*

**A green gate whose checks test the wrong proposition is the lane's own recurring
disease, and this is its second instance in two rounds** — R4.1 found a conjunct
that *could not be false*; R4.1b found a check that was *true and irrelevant*
(`[005]` is a perfectly correct fact about symbol externality, and it was standing
in for a claim about constructibility that it never made).

`ml0-consolidation-proof.lisp` §8 added **seven** checks at the R4.1b execution,
`[028]`–`[034]`, quoted below from `RED-CONSOLIDATION-AFTER.txt`
(`2026-08-21T17:24:45Z`). ⚑ **AS SHIPPED, §8 IS EIGHT CHECKS, `[028]`–`[035]`,
and the proof is 35 checks** — the `#S` refusal is now made twice, once sampled
and once **enumerated over every structure class in the lane package**, and every
later check shifted by one. The eight, in the shipped numbering:

| # | what it checks |
|---|---|
| `[028]` | the `#S` reader cannot construct a lane struct from outside — **sampled** (account, source, observation, bundle, carrier) |
| `[029]` | **every** structure class in the lane package refuses `#S` — **enumerated, not sampled** (10 classes, 0 `#S`-constructible) |
| `[030]` | a lawful carrier whose **source list** is rewritten is REFUSED at `ML0-MAT-2`, never written |
| `[031]` | a lawful carrier whose **predecessor list** is rewritten is REFUSED (`ML0-MAT-2`) |
| `[032]` | a `copy-structure`'d lawful carrier materializes **identical content** (copying mints nothing) |
| `[033]` | the derived account's subject **principal is singly prefixed** (`principal:<name>`, once) |
| `[034]` | a **derived account reconsolidates** with its own input, and the fold is non-amplifying |
| `[035]` | a carrier over **this** store cannot be materialized into a **FOREIGN** store (`ML0-MAT-3`) |

The R4.1b-execution capture, preserved as it was quoted then:

```
---- §8 the carrier is not trusted; the store is re-read ----
[028] ok   the CL #S reader cannot construct ANY lane struct from outside (BOA constructors): account, source, observation, bundle, carrier all READER-ERROR
[029] ok   a lawful carrier whose SOURCE LIST is rewritten through its reader is REFUSED at materialization (ML0-MAT-2), never written
[030] ok   a lawful carrier whose PREDECESSOR LIST is rewritten is REFUSED (ML0-MAT-2)
[031] ok   a COPY-STRUCTURE'd lawful carrier materializes the SAME content as the original (copying mints nothing)
[032] ok   the derived account's subject principal is NOT re-prefixed (principal:<name>, once)
[033] ok   a derived account can be RE-CONSOLIDATED with its own input (no ML0-CON-4), and the fold is non-amplifying (same standing, same source union)
[034] ok   a carrier computed over accounts of THIS store cannot be materialized into a FOREIGN store (ML0-MAT-3) — lineage must be checkable by the store that holds it
ml0-consolidation-proof: 34 checks, 0 failures
exit=0
```

**Checks `[001]`–`[027]` are unchanged and none was softened.** The count moved
because §8 was appended, not because anything was rewritten to pass. *(The same
holds for the 34 → 35 move: `[029]`'s enumeration was added beside the sampled
`[028]`, and nothing was rewritten to pass. Current shipped state, run fresh by
SCRIBA-III: `ml0-consolidation-proof: 35 checks, 0 failures`, exit 0 — §R4.1c.)*

## R4.1b-5. The gates, walked by the records officer

⚠ **THESE TEN EXITS ARE MINE.** Unlike R4.1's records, where the lane-gate rows
were quoted from `RUN-EXITCODES.txt`, **I ran every one of these myself** in this
session, from `experiments/latent-lisp`, each `$?` taken immediately after its
command. The full block is appended to `RUN-EXITCODES.txt` under the R4.1b heading.

| Gate | Exit | What it printed |
|---|---|---|
| `ml0-selftest.lisp` | **0** | `81 checks, 0 failures` |
| `ml0-controls.lisp` | **0** | `11 controls, 11 caught, 0 missed` — *the R4.1b execution; **13/13 as of R5*** |
| `ml0-mutants.lisp` | **0** | `6 defects, 6 killed, 0 survivors` |
| `ml0-block-proof.lisp` | **0** | `20 probes, 20 closed, 0 open` |
| `ml0-consolidation-proof.lisp` | **0** | `34 checks, 0 failures` — *the R4.1b execution; **35 as shipped**, re-run fresh in §R4.1c* |
| `ml0-red-proof.lisp` (combined) | **0** | `cured PASS, uncured FAIL — the tooth bites` |
| `ml0-red-proof.lisp cured` | **0** | `the tooth HOLDS` |
| `ml0-red-proof.lisp uncured` | **1** | `the tooth DOES NOT HOLD — and it MUST NOT hold here` |
| `ml0-host-fault-proof.lisp` | **0** | `PASS` |
| `de-actu-memorato/run-specimen.lisp` | **0** | `45 checks, 0 failures · RESULT: PASS` |

**The specimen is byte-identical to the shipped capture**, measured not assumed:
my run's transcript `cmp`s **0** against `de-actu-memorato/RUN-SPECIMEN.txt` and
shares its sha256 `39849f9968512934ac9586397bb59b2211107e4a95731f6fc8ca82c0f99c4388`.

⚑ **AND ONE THING MY RUN MEASURED THAT NOBODY ASKED FOR.** The specimen
**regenerates eleven `ARTIFACT-*` files in the working tree** when it runs. After
my run, `git status --porcelain -- mneme/memory-layer-0/` returned **nothing** —
so the durable payload came back byte-identical too, not only the transcript.
⚠ **This does not repair known hole 10.** §R4.1-7 item 6 / SPEC §11 item 10 say
the transcript is not a witness to the *payload*, and that stays exactly true: the
`git status` is the witness here, and it is a witness about **this build against
itself in this working tree**, never about this build against R4.1's.

**The declared API is unchanged at 195, and I read it out of a loaded image** —
`functions 148 · variables 27 · types 20 · sum 195 · declared 195 · shortfall
NIL`. `ML0-MAT-2`, `ML0-MAT-3` and `ML0-MAT-4` are **requirement ids, not exported
names**, and `%ml0-bare-principal` / `%ml0-consolidation-body` are internal. A
repair that closes three routes and adds no name to the public surface is the
shape this lane wants; it is recorded here because it is easy to assume and cheap
to check.

## R4.1b-6. ⚑ THE ARC LAW PAID A FIFTH TIME — and a new law proposed as a candidate

Memory Layer /0's standing arc law is **truth-minting migrates: every repair must
ask where it moved.** The ledger of that law in this lane:

| Round | Where truth-minting was closed | Where it turned up next |
|---|---|---|
| R2 | `make-ml0-source` — a freely callable constructor produced promotion-capable rows | `ml0-source-from-record`, the decoder |
| R3 | the decoder | the `occurrence-standing` field the *raw* decoder still installed verbatim |
| R4 | the raw decoder's standings (`standing-authority`) | the `defect` `&key` on ten exported production functions — **found cross-family** |
| R4.1 | the `defect` keyword; `ml0-write`'s `:derivation`/`:predecessors` | the **carrier** — a new object, believed because its constructor was internal |
| **R4.1b** | the internal-constructor argument itself | **the `#S` READER**, and **the mutability of a data object the caller holds** — **found cross-family** |

**Both cross-family catches sit at the same place in the pattern:** the round that
had just closed a door and written down why it was now shut. R4 closed a decoder
and shipped a test keyword; R4.1 closed an arglist and shipped a trusted object.
The same-family rounds in between each found real defects and neither found *this*
class, twice.

**Proposed as a candidate arc law — stated as a candidate, not adopted:**

> **An internal constructor is not a boundary — the READER is a constructor, and a
> data object is a mutable claim; the store is the only witness.**

Three clauses, three different failures, one shape. *The reader is a constructor:*
any exported structure type is publicly instantiable through `#S` whatever its
`:constructor` option says. *A data object is a mutable claim:* `:read-only t`
freezes a slot, never what the slot points at, and the readers that make an object
**inspectable** are the same readers that make its innards **reachable**. *The
store is the only witness:* which is why the cure is not a deeper freeze but a
**re-read** — the fix that survives is the one that stops believing the object at
all.

⚠ **It is a candidate.** It is stated by the round that just paid for it, in the
words of the chair who wrote the repair, and no outside has ruled on it. Its
first clause is a fact about SBCL that anyone can check in one line; its third
clause is a design preference that happened to work here once.

### R4.1b amendment to §R4.1-7 (holes carried forward)

**§R4.1-7's eight items stand as written and are not rewritten.** Four are amended
here, in the way R4.1 amended R4's:

- **Item 8 — *"Same-family hands, still … This round had no outside at all"* —
  AMENDED, AND IT WAS THE ROUND'S CLOSING SENTENCE.** R4.1b **had** an outside:
  SCRUTATOR, a Codex worker, cross-family, **static AND executed** (its own
  evidence labels read `EXECUTED and READ`, and its verification table lists ten
  probes it ran, including the eight lane gates). It is the **second** non-Claude
  eye on this lane and the **second** time one returned the blocker. ⚠ **It is
  still not a stranger's acceptance, and no stranger audit has been done.** A
  cross-family reviewer commissioned by the chair, reading the chair's tree, is an
  outside of *weights* and not an outside of *interest*.
- **Item 7 — `FILE-MANIFEST.txt` is stale, and it is now MORE stale.** Beyond what
  §R4.1-7 lists, it does not hash the four captures this round added, and it
  hashes the R4 bytes of an `ml0.lisp` that has since changed twice. **Regenerate,
  never hand-edit, and regenerate LAST.** `FLOOR-RESULT.txt` is still an R4 record
  and no floor was run this round either.
- **Item 5 (the disarmed-tooth class) — WIDENED, not closed.** R4.1 filed it as a
  hole *of the method*: nothing in the harness detects a check that has stopped
  being able to fail. R4.1b adds its sibling: nothing in the harness detects a
  check that **never tested the proposition it stands under** (`[005]`, true and
  irrelevant). Both were found by a **reader**, one Claude and one not. The cure in
  both cases was a human eye on a transcript.
- **Item 1 (`:contradicted`, half-closed) — UNCHANGED IN SUBSTANCE, ONE SENTENCE
  SHARPER.** The modelled clash is built *through the lane's internal row
  constructor from inside the lane package, which no caller outside it can do*.
  **That sentence was not true when it was written** — `#S` could build the row
  from outside — and what holds now is narrower (R4.1e): the row's stamp is not exposed through the exported, supported API; Common Lisp package privacy is not a capability boundary — an internal constructor remains callable through package-internal access — and BOA closes the supported SBCL `#S` route, not every possible call. The hole itself does not move: a clash
  arising naturally from two correct doors is still not demonstrated.

**Nothing is added to the SPEC's ten known holes.** Each of this round's three
findings is **closed**, not carried; what is carried is the *class* (item 5, now
widened) and the *fork* (R4.1-F3, a disclosed narrowing). ⚑ **R4.1c CORRECTS THE
CLAUSE THAT USED TO FOLLOW.** It read *"which is a disclosed narrowing and not a
hole"* — a disposition the chair had no authority to make. R4.1-F3 is an **OPEN
governance item** with two dispositions and its own parked question; see §R4.1c.
Whether it is a hole is exactly what is not yet ruled.

## R4.1b-7. Records — the four new captures, and what this round did NOT do

Added to the lane root by `fd3d1915`, and added here to the §R4.1-8 inventory:

| File | What it is |
|---|---|
| `RED-HASH-S-BEFORE.txt` **(R4.1b, NEW)** | the `#S` reader probe against R4.1 as committed — **5 struct types, 5 `CONSTRUCTED`**; the probe source is inlined in the capture's own header |
| `RED-HASH-S-AFTER.txt` **(R4.1b, NEW)** | same probe after the BOA cure — **5 `ERROR SIMPLE-READER-ERROR`** |
| `RED-CARRIER-BEFORE.txt` **(R4.1b, NEW)** | three probes against R4.1 as committed at `de3177e6` (`ml0.lisp` stashed to its committed state) — mutated carrier **WRITTEN** with zero warranting rows · doubled principal · cross-store **WRITTEN** |
| `RED-CARRIER-AFTER.txt` **(R4.1b, NEW)** | same three probes — **`ML0-MAT-2`** · principal equal · **`ML0-MAT-3`** |

Also changed in the inventory: **`RED-CONSOLIDATION-AFTER.txt` is refreshed** —
at the R4.1b execution it was a **34-check** capture (was 27), exit 0; **as
shipped it is 35 checks**, exit 0 (the 34 is the intermediate R4.1b state — see
§R4.1c). `RED-CONSOLIDATION-BEFORE.txt` is the preserved R4.1 capture and was
**not** re-taken. `ml0-consolidation-proof.lisp`'s inventory row reads **35
checks** (34 at R4.1b, 27 at R4.1).
`GUIDE-WALK.txt` is **re-taken as an R4.1b capture** — the guide changed, so the
walk was re-run; the extracted §2 recipe body is byte-identical to R4.1's and to
R4's, and the sha is in the capture.

**NOT DONE, ON PURPOSE, AND EACH BELONGS TO THE CHAIR:** no `FILE-MANIFEST.txt`
regeneration, no release floor, no `verify-release.sh`, no candidate parcel, no
Sol relay (**both** relays remain parked and unsent), no new chair-verification
record, no floor registration, no commit, no push, no mirror touch, no
`SYNC-PAUSED` change, no Core /0 export, no edit to any `.lisp` file, and no edit
outside `mneme/memory-layer-0/` except this round's own staging report.

⚠ **AND THE ONE THING THIS SECTION CANNOT TELL YOU.** At the moment these records
were written, `_staging/r41-scrutator-findings.md` carried **no re-review section**
— SCRUTATOR's read of `fd3d1915` was **in flight**, and its verdict on the repair
is not in this document. What stands in the file is its verdict on **R4.1**:
*"R4.1 is blocked on the stated design rule."* Whoever finds a
`## Re-review after fd3d1915` section at the end of that report is reading
something this section never saw.

---

*— SCRIBA-II (Claude Opus 5, 1M context), records officer, 2026-08-21.
**CANDIDATE · not audited · not adopted · not frozen · not registered · stranger
audit OWED.** SCRUTATOR's review was a **cross-family STATIC + EXECUTED** read
that returned a blocking verdict on R4.1; **it is not a stranger's acceptance**,
its re-review of the repair was **in flight** when this was written, and the chair
who repaired, the officer who recorded, and every prior round remain one lineage.
The failed-write governance variance is **OPEN**. **(R4.1c: R4.1-F3, cross-journal
materialization, is a SECOND open governance item — two open governance
dispositions now stand.)***

# ══════════════════════════════════════════════════════════════════════════
# ROUND R4.1c — 2026-08-21, RELEASE CORRECTION AT SOL'S DIRECTION
# ══════════════════════════════════════════════════════════════════════════

> **⚠ EVERYTHING ABOVE THIS LINE IS PRESERVED.** The R1–R4, R4.1 and R4.1b
> sections stand as evidence of what those builds and rounds said. Where this
> round corrected a *current* statement, the earlier figure survives **labelled as
> the state at its own execution**, never silently overwritten.
>
> ⚑ **THIS ROUND CHANGED NO CODE.** No `.lisp` file was edited; no semantics
> moved. It is a bounded **documents-only release correction**, three tasks, and
> the only executions it made are the two it reports.
>
> ⚠ **CHRONOLOGY CORRECTION (chair, R4.1c closeout, Codex second-pass disposition):**
> the sentence above is SCRIBA-III's and is true of **the officer's bounded subpass
> only**. The R4.1c round as a whole, at chair closeout, changed **two Lisp source
> files with prose/reporting-only edits** — `ml0.lisp` (comments and docstrings, the
> construction-boundary wording) and `ml0-consolidation-proof.lisp` (one §6 reporting
> banner string). The exact narrower statement: **no production logic or durable
> account semantics changed; two Lisp source files received prose/reporting-only
> edits.** Every "no `.lisp` edit / no commit / no floor" sentence in SCRIBA-III's
> report and in the R4.1c records below is scoped to that officer's subpass before
> chair closeout.

## R4.1c-1. The three tasks

**Label disambiguation (SCRIBA-III's catch):** "F3" names two different things in this
lane. **Codex finding F3** (R4) is the record-coverage finding — closed in R4. **Fork R4.1-F3**
is the cross-journal materialization narrowing — the OPEN governance item of this section. Every
"F3" below is the fork unless it says "Codex finding".

**(A) SYNCHRONIZE THE PROOF STATE.** `ml0-consolidation-proof.lisp` as shipped is
**35 checks**, and its §8 is **eight** checks, `[028]`–`[035]`. The SPEC, the
GUIDE, this RETURN's superseding statements, and the gate inventory rows for
`ml0-consolidation-proof.lisp` and `RED-CONSOLIDATION-AFTER.txt` said **27** or
**34** in places. Those figures are real history — 27 at the R4.1 execution, 34 at
the R4.1b execution — and they are now **labelled as such wherever they remain**;
every statement of the *current* state reads 35.

**(B) NARROW THE CONSTRUCTION-BOUNDARY PROSE.** Claims of the form *"the only way
to hold a carrier is to have called `ml0-consolidate`"*, *"`ml0-consolidate` alone
can construct it"*, *"an internal constructor is unreachable"*, *"the only thing
that writes one"*, and *"nothing a caller does to the carrier changes what is
written"* are replaced by the narrower facts:

1. **No constructor is exported.**
2. The supported SBCL `#S` **default-constructor** route is refused because all
   ten of the lane's structures use **BOA** constructors.
3. **Construction privacy is defense in depth, not the soundness boundary.**
4. Materialization treats the carrier as an **untrusted request**: it re-retrieves
   the carrier's input identities from the **target store** and writes the
   **recomputed** body.
5. **The exact claim:** *no presented body field selects durable standing or
   lineage; input identities select what the store is asked to retrieve, and the
   resulting body is recomputed and checked by **canonical-body SHA-256 digest**.*

⚠ **AND "BYTE-FOR-BYTE" WAS RETIRED WHERE IT DESCRIBED THE CARRIER COMPARISON.**
The implementation compares **canonical-body SHA-256 digests**
(`%ml0-consolidation-body` → `digest-of`), which is not a byte comparison of two
bodies; SCRUTATOR's own caveat — *digest equality is not body equality* — is the
reason the looser phrase had to go. **"Byte-for-byte" is left standing where it is
literally true**: the act-identity comparison at write (`same-datum-p`) and the
`cmp` of a preserved transcript against a fresh one.

**(C) R4.1-F3 IS AN OPEN GOVERNANCE ITEM.** See §R4.1c-3.

## R4.1c-2. What was executed, and by whom

⚠ **BOTH EXITS ARE MINE**, run in this session from `experiments/latent-lisp`,
each `$?` taken immediately after its command. Appended to `RUN-EXITCODES.txt`
under the R4.1c heading.

| gate | exit | what it printed |
|---|---|---|
| `ml0-consolidation-proof.lisp` | **0** | `ml0-consolidation-proof: 35 checks, 0 failures` |
| the §2 guide walk (`/tmp/ml0-walk.lisp`) | **0** | the six documented lines |

The eight §8 checks quoted in §R4.1b-4's table were **read out of that run**, not
recalled. The count moved from 34 to 35 because the `#S` refusal is now made
twice — **sampled** `[028]` and **enumerated over every structure class in the
lane package** `[029]` (10 classes, 0 `#S`-constructible) — which is also the
answer to the R4.1b `RUN-EXITCODES.txt` warning that a new lane struct declared
without `(&key …)` would be caught *"only for the five types [028] names"*.

**`GUIDE-WALK.txt` was RE-TAKEN as the R4.1c capture** — the guide changed (§4,
§6, §7, footer), so the walk was re-run rather than inherited. **The recipe body
did not change and that is measured:** the extractor (rebuilt from the METHOD
paragraph, as SCRIBA-II's was) produced **3605 bytes**, sha256
`e4773cb6fe46b7b81be9388f0872f95b418dd6b8a3764713b6e3e4bacd74f24e`, and `cmp` = 0
against the block extracted from the **committed** R4.1b guide — the same sha
SCRIBA-II and SCRIBA recorded for R4.1b, R4.1 and R4. ⚠ **R4.1c changed no
production logic or durable account semantics (two Lisp source files received
prose/reporting-only edits at chair closeout), so a passing walk is evidence about the
recipe against a semantically unchanged lane and nothing more.**

## R4.1c-3. ⚑ R4.1-F3 IS AN OPEN GOVERNANCE ITEM — the correction this round owes most

R4.1b's own text called the cross-journal case *"narrowed to future work,
deliberately"* and *"a disclosed narrowing and not a hole"*. **Those are
dispositions, and the chair had no authority to make them.** The facts are
unchanged; only the standing is corrected.

**What the implementation does:** `ml0-materialize-consolidation` re-retrieves
every input of a presented carrier from the **destination** store, so an input the
destination cannot produce is refused at **`ML0-MAT-3`** — **every** cross-store
materialization is refused. Measured: `RED-CARRIER-BEFORE.txt` `PROBE-3
cross-store -> WRITTEN into foreign store` → `RED-CARRIER-AFTER.txt` `PROBE-3
cross-store -> REFUSED [ML0-MAT-3]`; proof check `[035]`.

**What it narrows:** Architecture 0.1 **D4**, the governing law quoted in the
lane's own §14 header — *"cross-journal merges are receipt-bearing
transformations, never timestamp sorts."* In this slice **no durable cross-journal
merge occurs at all**.

**The two dispositions:**

- **(A)** Accept `/0` as supporting durable consolidation **only when every
  predecessor is retrievable from the destination store.** No durable
  cross-journal merge occurs in this slice; `ML0-MAT-3` stays as the refusal that
  marks the boundary.
- **(B)** Require **receipt-bearing cross-journal materialization now** — a design
  this slice does not have: explicit source-store identity in the derived body, a
  per-foreign-predecessor receipt, a verification rule the destination can run
  without the source store present, and a standing rule for a derived account
  whose warrants live in a store its reader cannot open.

**The chair's recommendation, at its size: (A) for `/0`. THAT IS A
RECOMMENDATION, NOT A RULING.** The question is parked, unsent, as its own message
at `notes/2026-08-21-ml0-cross-journal-materialization-question-for-sol.md`.
**D4 remains binding on any future implementation under either disposition.**

> ⚑ **ANSWERED BY SOL, 2026-08-21 — DISPOSITION A (appended in round R5; the section above is
> preserved unedited).** Sol accepted **(A)**: same-store-only durable consolidation for `/0`,
> with **`ML0-MAT-3` kept** — every predecessor must be retrievable from the destination store.
> Effect-free consolidation across stores *"may compute, but /0 shall not materialize that result
> durably."* **Architecture 0.1 D4 is NOT amended**: any future cross-journal merge remains a
> receipt-bearing transformation, never a timestamp sort. **Memory Layer /1 is RESERVED** for
> receipt-bearing cross-journal materialization and the standing of foreign warrants — charter at
> `MEMORY-LAYER-1-RESERVED-CHARTER.md`, **not built**. WORK-ORDER **AMENDMENT 3**.

## R4.1c-4. The standing, restated

⚠ **TWO OPEN GOVERNANCE DISPOSITIONS NOW STAND**, where the R4.1b records named
one:

1. **Work-order §5.A — the failed-write variance** (§R4.1-6). Its own parked
   question, `notes/2026-08-21-ml0-failed-write-variance-question-for-sol.md`.
2. **R4.1-F3 — cross-journal materialization** (this section). Its own parked
   question, above.

Neither is a defect found this round; both are dispositions the chair may not make
alone. **The relay and the two questions travel separately, and nothing in one
presumes another's answer.**

> ⚑ **BOTH ARE NOW ANSWERED BY SOL, 2026-08-21 (appended in round R5).** §5.A → **disposition B**
> (with the dry decode required); R4.1-F3 → **disposition A** (with `/1` reserved). **ZERO open
> governance dispositions stand as of R5.** What remains open is not a disposition but a
> **ruling**: Sol's **registration ruling**, which has not been made — *"Do not register, publish,
> synchronize, lift the sentinel, or touch the mirror. Return the R5 candidate to me."*

## R4.1c-5. What this round did NOT do, and what it leaves owed

**NOT DONE BY THE OFFICER, ON PURPOSE, EACH BELONGING TO THE CHAIR (scoped to
SCRIBA-III's subpass; the chair's closeout did make prose/reporting-only edits to two
`.lisp` files, see the chronology correction at the head of this section):** no
`.lisp` edit of any kind, no `FILE-MANIFEST.txt` regeneration, no release floor, no
`verify-release.sh`, no parcel, no Sol relay (**both relays and both questions
remain parked and unsent**), no chair-verification record, no floor registration,
no commit, no push, no mirror touch, no `SYNC-PAUSED` change, no Core /0 export,
and no edit to the WORK-ORDER, `FLOOR-RESULT.txt`, any `CHAIR-VERIFICATION-*`, any
`RED-*` capture, `RUN-SPECIMEN*`, or anything under `notes/`.

**STILL OWED, UNCHANGED AND NOW SLIGHTLY WORSE:** `FILE-MANIFEST.txt` is stale —
it hashes neither the R4.1b captures nor this round's edited documents — and
`FLOOR-RESULT.txt` is still an R4 record. Regenerate the manifest **last**, and
never by hand.

⚠ **AND THE THING THIS ROUND CANNOT TELL YOU.** A documents pass cannot make a
claim truer than the code beneath it. Every figure here was read out of a run I
made this session; every *characterization* of the code — the untrusted-request
contract, the BOA refusal, the digest comparison — I took from the chair's
uncommitted `ml0.lisp` prose and the shipped proof's own printed lines, **not from
an independent reading of the implementation.** A records officer synchronizing
documents is not a reviewer, and this section is not a re-verification.

---

*— SCRIBA-III (Claude Opus 5, 1M context), records officer, 2026-08-21.
**CANDIDATE · not audited · not adopted · not frozen · not registered · stranger
audit OWED · same-family hands · no independent verification.** R4.1c is a
documents-only correction directed by Sol; **it is not a review, not an
acceptance, and adds no evidence about the code.** SCRUTATOR's cross-family review
belongs to R4.1/R4.1b and is not a stranger's acceptance. **TWO governance
dispositions are OPEN: work-order §5.A (failed write) and R4.1-F3 (cross-journal
materialization).*** *(⚑ appended in R5: both were subsequently **ANSWERED BY SOL** on
2026-08-21 — B and A respectively. The signature line above is preserved as written.)*

## R4.1e — release-RECORD correction (Codex R43 disposition: HOLD for one final bounded pass)

*Records/prose only. No production logic or durable account semantics changed; `ml0.lisp`
received one docstring edit (prose). The same-store repair remains closed — no semantic
verification failed.*

**The normative construction-boundary rule, everywhere it is now stated:** *not exposed through
the exported, supported API. Common Lisp package privacy is not a capability boundary; an
internal constructor remains callable through package-internal access. BOA closes the supported
SBCL `#S` route, not every possible call.* Applied at: SPEC record-coverage ("DOOR-ONLY" /
"cannot impersonate"), §6b ("only a production door" / "only callers that can stamp"), Write
step 3, known-hole item 2 ("it is true now"); GUIDE §2 recipe comments ("only thing that can
stamp", "DOOR-ONLY"); RETURN R4 record-coverage "only producer", R4.1-1's constructor bullet, the
R4.1b supersession row's "true again", R4.1b's "it is true now"; `ml0.lisp`
`ml0-occurrence-warranted-p`'s "a caller cannot assert its way past". "Only producer" → "supported
producer" throughout current prose; historical quotations stand only where marked superseded.

**Guide walk retaken with the strong extractor** (span between `## 2.` and `## 3.`; abort unless
exactly one `lisp` fence; run unchanged): the recipe comments changed, so the block moved honestly
— **3850 bytes, sha `34f705b2…`** (was 3605 / `e4773cb6…`); exit 0; `GUIDE-WALK.txt` is now a
full-stdout **transcript** including the three loader smoke lines.

**Accounting repaired:** the relay no longer refers to a nonexistent "sidecar companion note" —
it names parcel r44 and states the mechanically recomputed member count; `RUN-EXITCODES.txt`
carries an appended correction with the complete `act1-host-fault-proof` line that the R4.1d
recorder truncated at "refus". The "originally … no code semantics change" phrase in SPEC/GUIDE is
now scoped explicitly to SCRIBA-III's bounded subpass.

**Executed (chair, direct exits):** consolidation proof 35/0 (AFTER capture refreshed from the
final source state) · lane gates all green · red-proof cured 0 / uncured 1 / combined 0 ·
specimen 45/0 `cmp`=0 · 13/13 consumed-lane regressions · quiescent floor: see `FLOOR-RESULT.txt`
R4.1e block. Manifest regenerated last, exact coverage. Parcel
`memory-layer-0-candidate-r44-2026-08-21.tar.gz`. Pause in force; both governance questions OPEN.

> ⚑ **APPENDED IN R5:** both governance questions are now **ANSWERED BY SOL** (B and A), and parcel
> r44 `287629b4…` was accepted by Sol as the clean base for the one bounded R5 pass — *"acceptance
> of the parcel and static record, not independent execution verification and not registration."*
> The pause remains in force.

# ══════════════════════════════════════════════════════════════════════════
# ROUND R5 — 2026-08-21, THE DRY-DECODE NARROWING
# (Sol's two dispositions entered; §5.A amended; the residue narrowed to host fault)
# ══════════════════════════════════════════════════════════════════════════

*Authorized by `corpus/voices/received/2026-08-21-sol-ml0-dispositions-r5.md`, archived verbatim.
Sol's own caption on that authorization is carried here because it governs how this section may be
read: **"This instruction authorizes the pass. It is not evidence that the pass occurred."** Sol's
acceptance of parcel r44 is stated there as **"acceptance of the parcel and static record, not
independent execution verification and not registration."***

**Why this is R5 and not another R4.1 correction, in Sol's words: *"it changes the governing
contract and adds structure."*** The two governance items that stood OPEN through R4.1c and R4.1e
are **ANSWERED BY SOL**; one of them changed what the lane must do, and the lane was changed to do
it.

## SUPERSEDED COUNTS AND CLAIMS FROM THE R4.1e RECORD

| In the earlier sections | Now | Why |
|---|---|---|
| `ml0-controls: 11 controls, 11 caught, 0 missed` | **13 controls, 13 caught, 0 missed** | TOOTH 12 (planted dry-decode failure) and TOOTH 13 (planted identity failure), each with a cured half and a diseased half |
| work-order §5.A: **OPEN GOVERNANCE VARIANCE** (§R4.1-6) | **ANSWERED BY SOL — disposition B**, entered as WORK-ORDER **AMENDMENT 2** | Sol, 2026-08-21 |
| R4.1-F3 cross-journal materialization: **OPEN GOVERNANCE ITEM** (§R4.1c-3) | **ANSWERED BY SOL — disposition A**, entered as WORK-ORDER **AMENDMENT 3**; **Memory Layer /1 reserved** | Sol, 2026-08-21 |
| the post-append refusal residue = *"the readback and the `ML0-WR-5` identity check"* (§R4-5, §R4.1-6) | **HOST FAULT ONLY, by construction** | the pre-append dry decode moves every refusal this lane can raise about its own frame to before the append |
| declared external API: **195** = 148 · 27 · 20 | **195 = 148 · 27 · 20, UNCHANGED** | `%ml0-dry-decode` is **internal**; `ML0-WR-8` is a **requirement id, not a name** |
| the in-lane narrowing (a pre-append dry decode) **offered and NOT taken** (§R4.1-6) | **TAKEN, because Sol required it** | AMENDMENT 2's "Required structure" |

**Not superseded, and stated so it cannot be read off this round as improved:** D6 remains
`PARTIAL`; demonstration D4 remains `SHOWN-AS-AMENDED`; package privacy remains **defense in
depth, not a soundness boundary**; and **same-family execution does not become independent
audit.** Sol preserved all four by instruction; this round changed none of them.

## R5-0. Disposition B — the failed-write contract, amended

The governing text, **quoted verbatim once** from Sol's instruction §1 (also entered at
WORK-ORDER AMENDMENT 2, where the original §5.A text is preserved unedited beside it):

> Every refusal raised before `append-event` is observably non-mutating over the whole declared
> store. Once `append-event` succeeds, a subsequent readback or identity refusal returns no
> account and neither retracts nor rewrites durable bytes. Any surviving bytes acquire no standing
> merely by surviving: they are judged only through Journal /0 validation and Memory Layer /0
> retrieval. Append success, serialization success, and evidence or certificate issuance are never
> evidence that the represented act occurred.

Sol's required structure, in Sol's own terms: *"Before appending, encode the exact canonical
event, run the exact account decoder over it, and compare the resulting identity. A decoder or
identity refusal must therefore occur before mutation. The designed post-append refusal residue
should be host fault only."* And the four prohibitions, unabridged: *"Do not add rollback,
truncation, tombstones, or supersession. Do not reopen or edit Journal /0."*

**What that changes about the standing of the R4 fork (§R4-5).** R4 chose (a), the honest
correction, over restructuring — and said so. Disposition B **ratifies the semantics R4 disclosed
and then narrows its scope**: the retained-frame behaviour is now the *governing* contract rather
than a variance from an unamended order, and the set of refusals that can reach it has been cut
down to the ones the lane cannot see coming. R4's reason for keeping the readback (*"the
verification is worth more than the atomicity claim"*) is untouched — the readback still runs, and
still refuses.

## R5-1. Disposition A — same-store consolidation accepted, and Memory Layer /1 reserved

Sol, §2: same-store-only durable consolidation is accepted for `/0`; **`ML0-MAT-3` stays** — every
predecessor must be retrievable from the destination store; effect-free consolidation across
stores *"may compute, but /0 shall not materialize that result durably."* **This does not amend
Architecture 0.1 D4**: any future cross-journal merge remains *a receipt-bearing transformation,
never a timestamp sort*.

**Memory Layer /1 is reserved, not opened.** The charter is recorded at
`MEMORY-LAYER-1-RESERVED-CHARTER.md` (new file, this round) and reserves exactly the four subjects
Sol named — source-store identity, predecessor receipts, offline verification limits, and what a
destination may honestly conclude without reopening the source store. **No `/1` code exists, none
was written, and the charter opens no lane and carries no standing.** Sol: *"Record that charter;
do not build /1 in this pass."*

## R5-2. The dry decode — where it sits, what it does, what it cannot do

**Where.** In `%ml0-append-body-and-read-back`, the **shared** append-and-readback tail, as new
step **(4b)**, between the envelope's construction and the append. That function is used by the
DIRECT route (`ml0-write`) and the DERIVED route (`ml0-materialize-consolidation`) alike, so **both
routes get the narrowing, identically, and cannot drift** — the same structural reason R4.1 gave
for putting steps (5)–(7) there in the first place.

**What.** `%ml0-dry-decode` (internal, new) takes the **exact** event datum the append will be
handed and the identity just minted from its body, and:

1. encodes it with `encode-pjs0` — the same canonicalization `append-event` performs;
2. decodes it back with `decode-pjs0` and **requires `:canonical`** — the same bytes the store
   would hold, not a re-render;
3. runs **the exact account decoder**, `%ml0-decode-account-event` with inherited warrants, which
   is the route `ml0-retrieve` takes;
4. requires the decoded account's identity to **equal** the minted `account-hex`.

Any failure refuses as **`ML0-WR-8`** (`ml0-account-encoding-refused`), **before any durable
mutation**. The decoder's own refusals (`ML0-RB-*`) are re-signalled under WR-8 **with their
requirement id named**, so a caller sees both *which* check failed and *that* it failed
pre-append. The function touches no store.

**What it cannot do, and this is the point of the design rather than a caveat on it.** It cannot
move a fault that does not exist yet at step (4b). The bytes changing **under** the process
between the append and the readback — a host fault — is precisely what no pre-append check can
anticipate, and it is therefore the **entire designed residue**. That is Sol's *"the designed
post-append refusal residue should be host fault only,"* met by construction and measured at
CONTROL 11.

**What was NOT added, by instruction and by conviction:** no rollback, no truncation, no
tombstone, no supersession. **Journal /0 was not reopened and not edited** — no file of it was
touched this round, and `/0 never forgets` is the reason the alternative was never on the table.

## R5-3. The three overlay seams — and why the identity seam is ONE-SHOT

The seams live in `ml0-mutant-overlay.lisp`, which `load.lisp` never loads. They are **control
seams, not mutants**: `ml0-mutants.lisp` still reports **six** defects, and none of the three kills
anything.

| Seam | What it plants | Used by |
|---|---|---|
| `:frame-rendering-mismatch` (on `ml0-account-body`) | the exact body with a **rendering version this lane's decoder does not know** | CONTROL 12 |
| `:identity-mismatch` (on `ml0-mint-account-identity`) | a minted identity **one hex digit off** the body's content digest | CONTROL 13 |
| payload `:skip-dry-decode` (on `%ml0-dry-decode`) | skips step (4b) entirely — the **disease** half, so the same fault can be watched reaching the append | CONTROLs 12 and 13 |

**⚑ THE IDENTITY SEAM IS ARMED FOR EXACTLY ONE CALL, AND THE REASON IS THE FINDING WORTH
RECORDING.** The dry decode compares two identities that are **minted through the same function**:
the write mints one from the body, and the decoder re-digests the decoded body through that same
mint. **A seam that lied every time would lie to both sides — and the two sides would agree.** The
cured half would then pass no check at all: the write would proceed with a wrong-but-consistent
identity, the dry decode would see no disagreement, and the tooth would report a gate that had
never fired.

**How it was found: by the tooth missing BOTH halves first.** The chair's account, recorded at the
chair's direction and attributed as the chair's: TOOTH 13 was written with an always-on identity
seam, and neither half caught — the cured half saw no WR-8 (the two mints agreed on the same lie)
and the diseased half saw no post-append refusal (same reason). The seam was then made **one-shot**
— armed by the control before **one** write, consumed by that write's own mint, honest on every
later call including the dry decode's re-digest and the readback's — and both halves caught. **The
miss is recorded because a gate that has never been seen to fire is untested, not passing** (this
lane's own §7 bullet, and TESSERA's rule), and because the near-miss here was not a bug in the
production code at all: it was **an instrument that would have certified a check it could not
make.** The failing intermediate state is **not preserved as a capture** — this is a narrative of
the chair's construction sequence, not a measurement, and it is offered at that size.

## R5-4. Sol's five measures, and where each one is met

Sol's §1 lists five measures. Each row names the artifact that carries it and quotes the label as
printed. **No measure is claimed here that is not printed by a gate in this lane.**

| # | Sol's measure (verbatim) | Where it is met | The printed label |
|---|---|---|---|
| 1 | *"whole-store byte and file-set equality on every pre-append refusal"* | `ml0-controls` **TOOTH 7**, four refusal paths; plus the **cured halves** of TOOTHs 11, 12, 13 | `TOOTH 7 · A FAILED WRITE LEAVES SOMETHING BEHIND. The instrument is the WHOLE declared account-store directory: its file set and every file's sha256` |
| 2 | *"planted dry-decode and identity failures refusing before append"* | `ml0-controls` **TOOTH 12** and **TOOTH 13** (both halves each) | `TOOTH 12 · A FRAME THE LANE'S OWN DECODER WOULD REFUSE IS REFUSED BEFORE THE APPEND (ML0-WR-8), store byte-unchanged — and the same planted frame REACHES the append when the dry decode is skipped` · `TOOTH 13 · AN IDENTITY THAT IS NOT THE BODY'S CONTENT DIGEST IS REFUSED BEFORE THE APPEND (ML0-WR-8), store byte-unchanged — and reaches the append when the dry decode is skipped` |
| 3 | *"post-append host fault returning no account and performing no retraction"* | `ml0-controls` **TOOTH 11**, whose note is rewritten this round to say what it now models | `TOOTH 11 · A POST-APPEND REFUSAL IS NOT NON-MUTATING. The instrument is the same one TOOTH 7 uses` — with the R5 note: `THIS IS NOW THE GOVERNING SEMANTICS, AND THE RESIDUE IS HOST FAULT ONLY … the surviving frame acquires no standing by surviving` |
| 4 | *"subsequent fresh-process judgment coming only from validated durable bytes"* | the specimen's **lector** (`de-actu-memorato`, phase 5) and the consolidation proof's fresh-process checks **[017]** and **[027]** | `== phase 5 — the lector (genuinely new process; durable bytes + declared configuration only) ==` · `[017] a NEW process opens the store, retrieves the derived account, and reads :OCCURRED / :consolidation` · `[027] a NEW process reads the derived account as :CONTRADICTED / :consolidation` |
| 5 | *"the genuine certificate for the unperformed act remaining `:unresolved` through write, restart, retrieval, and consolidation"* | **write + retrieval + consolidation:** `ml0-red-proof`'s crown tooth, one predicate applied to both arms. **restart:** the specimen's lector, `[025]` and `[026]`, in a genuinely new process | `CROWN TOOTH : PASS` (cured, exit 0) / `CROWN TOOTH : FAIL` (uncured, exit 1) · `[025] (lector) D2 arm (a), read half — retrieved in a genuinely new process, the crown negative's account still reads occurrence :UNRESOLVED and issuance-only, and no public reader answers occurred` · `[026] (lector) D2 arm (a), consolidation half — consolidating the crown negative with a SECOND issuance-only reading of the same act still yields :UNRESOLVED. Two records are not a warrant, however numerous or durable` |

⚠ **Two honesties about this table.** (i) Measures 4 and 5 are met by gates that **predate R5** —
they were not built for this disposition and are cited because they answer it, not because this
round strengthened them. (ii) The TOOTH 11 row is a **modelled** host fault: the trigger is
synthesised by the named control seam `:readback-refuses-after-append`, and the synthesis was
already disclosed at §R4-5 and is disclosed again here. No reachable input produces it, which is
exactly why it must be synthesised — and why *"host fault only"* is a statement about the
**designed** residue, not a proof that a host fault has occurred in the wild.

## R5-5. The gates — this round's numbers

Executed by the chair after `eaad89b5`, and re-walked by this records officer; the officer's own
block with `$?` per row is appended to `RUN-EXITCODES.txt` under the R5 heading.

| Gate | Exit | Printed |
|---|---|---|
| `ml0-selftest.lisp` | **0** | `81 checks, 0 failures` |
| `ml0-controls.lisp` | **0** | **`13 controls, 13 caught, 0 missed`** (was 11/11) |
| `ml0-mutants.lisp` | **0** | `6 defects, 6 killed, 0 survivors` — the three R5 seams are **control seams, not mutants** |
| `ml0-host-fault-proof.lisp` | **0** | `PASS` |
| `ml0-block-proof.lisp` | **0** | `20 probes, 20 closed, 0 open` |
| `ml0-consolidation-proof.lisp` | **0** | `35 checks, 0 failures` |
| `ml0-red-proof.lisp` cured / uncured / combined | **0 / 1 / 0** | `CROWN TOOTH : PASS` · `CROWN TOOTH : FAIL` · `cured PASS, uncured FAIL — the tooth bites` |
| `de-actu-memorato` specimen | **0** | `45 checks, 0 failures · RESULT: PASS`; transcript **`cmp` = 0** against the shipped capture (sha `39849f99…`) |

**⚑ THE SPECIMEN TRANSCRIPT IS BYTE-IDENTICAL, AND THAT IS THE EXPECTED RESULT, NOT A WEAK ONE.**
The dry decode is **silent when it passes** — it prints nothing, changes no identity, and adds no
frame. A lane whose lawful behaviour changed would have moved those 45 lines. The narrowing is
visible only where a fault is planted, which is what CONTROLs 12 and 13 exist for.

**API count unchanged at 195** (148 functions · 27 variables · 20 types): `%ml0-dry-decode` is
internal and `ML0-WR-8` is a requirement id, not an exported name. The loader's completeness check
is the instrument, not this sentence.

## R5-6. The ceilings, preserved verbatim by instruction

Sol §3.5: *"Preserve all honest ceilings: D6 remains `PARTIAL`; demonstration D4 remains
`SHOWN-AS-AMENDED`; package privacy remains defense in depth; same-family execution does not
become independent audit."* All four stand unchanged, and nothing in R5 was permitted to touch
them. Two more that R5 does not move: **`ISSUED(evidence, act) ⇏ OCCURRED(act)`** — the lane's
crown, and Sol's closing sentence restates its scope: *"The language may remember that a
certificate existed. It may not remember the certified act as having occurred unless the
independent eight-leg conjunction warrants it."* — and the D1/D2/D3 demonstrations, which R5
neither extends nor re-grades.

## R5-7. Standing

**CANDIDATE · not audited · not adopted · not frozen · NOT REGISTERED · stranger audit OWED ·
same-family hands.** Sol's §3.8 is explicit and is the operative instruction: *"Do not register,
publish, synchronize, lift the sentinel, or touch the mirror. Return the R5 candidate to me for the
registration ruling."* The registration ruling **has not been made**; this section is the record of
a pass, not of a standing.

The R4 cross-family audit (Codex) and SCRUTATOR's cross-family review belong to R4/R4.1 and are
**not** a stranger's acceptance of this lane. Sol's acceptance of parcel r44 is, in Sol's words,
*"acceptance of the parcel and static record, not independent execution verification."* **R5 adds
no independent verification of any kind.**

## R5-8. The two OPEN items are ANSWERED — where the earlier text is annotated

The earlier sections are **not rewritten**; their text stands as it was written, with an appended
note at each site that called the item OPEN:

| Site | What it said | Note appended |
|---|---|---|
| §R4.1-6 | *"THE FAILED-WRITE GOVERNANCE VARIANCE IS OPEN … STATUS … OPEN"* | ANSWERED BY SOL — disposition B; the recommendation-that-was-not-a-disposition became a disposition made by the one who could make it |
| §R4.1c-3 | *"R4.1-F3 IS AN OPEN GOVERNANCE ITEM"* | ANSWERED BY SOL — disposition A; `ML0-MAT-3` stays; `/1` reserved |
| §R4.1c-4 | *"TWO OPEN GOVERNANCE DISPOSITIONS NOW STAND"* | both answered; **zero open governance dispositions** as of R5 |
| §R4.1e tail | *"both governance questions OPEN"* | both answered |
| the parked question notes | parked, unsent | both marked **ANSWERED BY SOL**, original text preserved, disposition appended (commit `615f355a`) |

**The order of operations is itself a record.** Sol's §3.1 required the dispositions be entered and
committed **before any code change**; they were — dispositions at `615f355a`, code at `eaad89b5`,
and the git timestamps are the proof of ordering, not this sentence.

## R5-9. What this round did NOT do

No registration, no publication, no mirror touch, no `SYNC-PAUSED` change, no sentinel lift, no
Core /0 export, no Journal /0 edit, no `/1` build, no reopening of the same-store consolidation
repair (Sol §3.4 — *"unless a verification fails"*; none did), and no change to D6, D4, the package
privacy claim, or the audit standing. This records officer wrote **no `.lisp` of any kind**, made
**no commit**, regenerated **no manifest**, ran **no release floor**, and produced **no parcel** —
those are the chair's, by the same division that governed R4.1c and R4.1e.

⚠ **AND THE THING THIS SECTION CANNOT TELL YOU.** The gate figures above I ran; the *design* of
`%ml0-dry-decode` I read out of the committed source at `eaad89b5` and out of the chair's
docstring, and the one-shot seam's discovery story is **the chair's account, not my measurement**.
A records officer walking gates is not a reviewer, and this section is not a re-verification.

---

*— SCRIBA-IV (Claude Opus 5, 1M context), records officer, 2026-08-21.
**CANDIDATE · not audited · not adopted · not frozen · not registered · stranger audit OWED ·
same-family hands · no independent verification.** R5 enters two dispositions made by Sol and
records one code narrowing made by the chair; it is not a review and not an acceptance. **ZERO
governance dispositions remain open; the REGISTRATION RULING is Sol's and has not been made.***
