# latent-lisp

**Lisp+ is an experimental Common Lisp language and runtime for making evidence, authority, effects, and
continuity explicit. Mneme is its memory-and-continuity layer.** Beside the instrument, `atelier/` is a
workshop of homoiconic play: quines, metacircular evaluators, executable poems, genetic programs, and other
things that discover what code can become when its body is also data.

This is the public mirror of a model-authored research lab, assembled under its owner's direction. It is
not a production package, a security boundary, or a complete end-to-end demonstration of a general agent
runtime. It is a governed stack of specifications, implementation lanes, specimens, receipts, preserved
failures, and rulings. Its central wager is that a fluent system can be made to refuse a claim wearing a
check's costume: rhetoric is not evidence, production is not truth, and a witness must face the exact
proposition it claims to support.

**Quick start:** from the repository root, under the tested environment below, run the small specimen:

```sh
sbcl --script mneme/readme-specimen.lisp
```

**Run contracts:** the declared environment for the specimen and loader is Linux with Bash and **SBCL 2.4.6
exactly**. R7 ingestion measured the specimen on these exact subtree bytes in the lab (exit 0); it did not
separately execute the loader or a public-mirror clone. The aggregate floor additionally requires Git,
Python 3 with `jsonschema` (recorded venue:
CPython 3.11.14, `jsonschema` 4.26.0), and a clean, committed **lab** checkout whose history contains
`431fee16`. This public mirror deliberately lacks that lab commit, so rows [071]/[072]—and therefore the
aggregate floor—are expected to fail here. Budget roughly 90 minutes for an eligible 112-gate lab run;
`bash mneme/verify-release.sh --list` only enumerates gates and runs nothing. The loader has no
inspection-only `--help`: `bash mneme/load-lisp-plus.sh --help` performs the load. Exit 0 means **the
declared gate passed under its stated contract**—not that the language's law is universally true.

**Trust ceiling:** the tree contains unusually extensive executable gates and byte-bound receipts.
One Act /1 received a cold audit that terminated **BLOCK on venue**; a same-family capable-venue
supplement supplied execution. The combined record supported adoption eligibility, not independent
verification. For ML/0's current audit standing and mandatory limits, see
[ML0 audit standing and limits](#ml0-audit-standing-and-limits). Nothing here may be called
"independently verified." A green floor is not adoption, semantic truth, or a security certification;
loading is not adoption; some historical host-bound tools fail closed outside the lab layout. Trust each
receipt only at the size of the proposition it actually witnesses.

---

## Watch this

The central wager in ten lines. A fluent mind's favorite move is to offer *"I'm about 80% sure"* as a
single number riding on an otherwise exact record. Kernel /0 refuses it — not with a generic error, but
with the requirement id and the law text carried **in the condition's own fields**:

```lisp
(load "mneme/kernel0/load.lisp")
(handler-case
    (lisp-plus-kernel0:make-determinacy :mode :determinate :confidence 0.8)
  (lisp-plus-kernel0:global-uncertainty-scalar-rejected (c)
    (format t "REFUSED ~a = ~a~%  requirement: ~a~%  law: ~a~%"
            (lisp-plus-kernel0:kernel0-condition-offending-field c)
            (lisp-plus-kernel0:kernel0-condition-offending-value c)
            (lisp-plus-kernel0:kernel0-condition-requirement-id c)
            (lisp-plus-kernel0:kernel0-condition-failed-invariant c))))
(print (lisp-plus-kernel0:make-determinacy :mode :determinate))
```

```
REFUSED CONFIDENCE = 0.8
  requirement: K0E-33
  law: §7.5 and Errata 0.2 §6: determinacy MUST NOT carry a global confidence, uncertainty, or probability scalar in place of the closed mode algebra

#S(LISP-PLUS-KERNEL0:DETERMINACY
   :MODE :DETERMINATE
   :ALTERNATIVES NIL
   :EVIDENCE NIL)
```

Uncertainty in Lisp+ is a per-axis *mode* from a closed algebra (`:determinate` / `:bounded` /
`:indeterminate`), never a scalar smeared over the whole outcome — because a scalar lets execution,
manifestation, effect, and interpretation impersonate one another under one comfortable number. The file
is `mneme/readme-specimen.lisp`; it exits 0. (While writing this page the author first tried
`:mode :exact`; the kernel refused that too, citing K0E-2. The language corrects its own README.)

**The companion** (`mneme/readme-specimen-companion.lisp`, asked for by GPT Sol so nobody can wonder
whether the *float* caused the refusal): a Canonical-Datum-friendly rational, the float, and the other
two forbidden keys — all refused on the same law; the float is refused *as a scalar* before anyone
asks whether `0.8` is a durable value; `"low"` shows the law is keyed to the *slot*, not to numeric
type (the whole escape hatch is sealed, not just the numbers); the mode typo gets its own condition;
the lawful record passes. A one-shot demo became a controlled experiment: baseline, treatments, a
separate failure class, and the process exit — which is the only way a refusal becomes evidence.

```
REFUSED CONFIDENCE = 4/5  [K0E-33]
REFUSED CONFIDENCE = 0.8  [K0E-33]
REFUSED PROBABILITY = 1  [K0E-33]
REFUSED UNCERTAINTY = "low"  [K0E-33]
OTHER DETERMINACY-MODE-INVALID [K0E-2]
ACCEPTED (:MODE :DETERMINATE)
```

---

## Current state — START HERE (2026-08-28)

**The language is Lisp+. Mneme is its memory-and-continuity layer.** (Relation sealed:
`mneme/architecture/ARCHITECTURE-0-STATUS.md`.) As laid out on disk, `mneme/` holds the whole construction.
The concrete memory lane is `mneme/memory-layer-0/`: **ADOPTED AND PUBLISHED** on 2026-08-22. See
[ML0 audit standing and limits](#ml0-audit-standing-and-limits) for the subsequent audit record.
Publication warrants the exact-bound transport and readback of those bytes; it does not enlarge the
lane's semantic claims.

Lisp+ today is an adopted specification constitution (Architecture 0.1 · Kernel /0 · Process Journal /0 ·
Adapter Protocol /0 · Kernel Errata 0.2) plus a stack of implementation lanes in Common Lisp, every one
passing its own declared gates on SBCL 2.4.6/Linux. The canonical release floor is **112 gates (full) /
82 (light)**; a green floor means *every executable gate passed at its authorized count and every known
unresolved finding is unchanged* — never that a semantic question is resolved.

### Working vocabulary (read this before reading the table)

| term | meaning here |
|---|---|
| **lane** | a bounded specification, implementation, or experiment lineage with its own records and gates |
| **gate** | an executable or documentary check with a declared expected result; a gate may pass without settling meaning |
| **floor** | an enumerated aggregate of gates; green means those gates passed at their authorized counts |
| **witness** | a recorded observation made to face one exact proposition |
| **receipt** | a provenance record binding an artifact or action to bytes and context; not a semantic truth certificate |
| **standing** | governance status, kept separate from test outcome: candidate, registered, adopted, published, and their riders |
| **CANDIDATE** | constructed and tested; not thereby audited, adopted, frozen, or published |
| **REGISTERED** | carried by the release floor and an ASDF system; registration does not raise standing |
| **ADOPTED** | accepted by an owner ruling filed in-tree; adoption does not create independent verification |
| **PUBLISHED** | owner authorization → verified transport → far-side readback; a push alone is insufficient |
| **sentinel** | the transport lock; when raised, no governed ferry may run |
| **ferry / transport** | materializing an authorized committed subject tree at the public mirror and recording the crossing |
| **stranger audit owed** | a required review by a sufficiently corpus-independent hand that has not yet been discharged |
| **same-family** | work by hands sharing this corpus and institutional frame; useful cross-reading, not independence |
| **subject tree** | the exact committed subtree selected as cargo, distinct from a working directory or repository history |

### The lanes and where they stand

| lane | what it is | standing (as the lane's own record states it) |
|---|---|---|
| `mneme/architecture/` | the constitution: Architecture 0.1, Kernel /0 spec, PJ0, AP0, Kernel Errata 0.2 | **ADOPTED; governing** (2026-07-18/19) |
| `mneme/kernel0/` | the first executable Lisp+ core | selftest 33/0, 59 mutants killed; merged 2026-07-19 |
| `mneme/journal0/` · `capability0/1/2` · `adapter0/` · `vertical0/` | the organs: journal store, live authority, opaque minting, effect frontier, fake adapter, four-death specimen | CANDIDATES (capability arc closed by ruling; AP0 Rider 2 binding: no "independently verified") |
| `mneme/language-core-0/` + `slice-{0,1,2}` · `form-{0,1,2}` · `surface-{0,1,2}` | the derive/perform two-door substrate and its lanes | CANDIDATES; Form /1, Surface /1, Form /2 closed; Surface /3 shut |
| `mneme/language-surface-account-0/` | process-wide identity state + account allocation | **ADOPTED AND PUBLISHED** (owner, 2026-08-06) |
| `mneme/language-act-0/` | One Act /0 — derive/perform over a journal-backed process, one sealed act | **ADOPTED** (owner terminal ruling, 2026-08-08); stranger audit **waived by owner variance, not passed** |
| `mneme/language-many-acts-0/` | Many Acts /0 — composition of acts | **R1 ADOPTED WITH RIDERS** (owner ruling, 2026-08-10) |
| `mneme/languagehood-and-succession-charter-0/` | Charter /0 — what it means for this to be a language, and how it succeeds itself | **RATIFIED** (owner, 2026-08-12, R3); ratification created no evidence; stranger audit owed |
| `mneme/portable-judge-0/` | a judge that travels — candidate parcel | **CANDIDATE — not an adoption declaration** (2026-08-10) |
| `mneme/public-sufficiency-0/` | the governance of *this mirror*: what may be published, how transport is recorded, what "published" means | LIVE lane; publication authorization **B (blanket-current, bounded)** ruled 2026-08-18; transport sentinel raised |
| `mneme/language-act-1/` | One Act /1 — perform *across* process death | **ADOPTED 2026-08-22** at lab commit `aeeefa40` (owner act, ceilings verbatim; Sol I ruled ADOPTION-ELIGIBLE on a cold audit that terminated BLOCK on venue plus a same-family capable-venue execution supplement; record `mneme/language-act-1/ADOPTION-RECORD-2026-08-22.md`; floor row `act1\|ADOPTED`). Ceilings: not "independently verified"; 27-symbol ML/0 coupling is version-bound debt |
| `mneme/memory-layer-0/` | Memory Layer /0 — the language's durable account of its own act (write / retrieve / consolidate under *ISSUED(evidence, act) ⇏ OCCURRED(act)*) | **ADOPTED AND PUBLISHED** (2026-08-22); [current audit standing and mandatory limits](#ml0-audit-standing-and-limits) |
| `mneme/integration-baseline-0/` | authority index · claim ceiling · supersession map | CLOSED by owner ruling 2026-08-03 — historical, never edited |
| `mneme/lci0/` · `canonical-datum/` | Located Claim Identity /0 · Canonical Datum /0 | CLOSED + FROZEN; LCI0 algebraic-law audit carries 4 preserved FAILs, "authorial ruling required" |
| `mneme/language-a/` | Language-A emission materials (public lane only) | ARCHIVED, banked 295/312 — not re-run |
| `mneme/latent-mvp/` | the v0/v1 kernel and the seven-law conformance walk | **FOSSIL** — historical stratum with its own floor; zero edges with the current stack |

**Memory Layer /0 history and ceiling.** It was registered 2026-08-21 as
CANDIDATE-NOT-ADOPTED, then adopted 2026-08-22 by Sol I's terminal standing ruling with owner
countersignature and published at mirror `9a56eabd…` by exact-bound transport of lab `71d94fc2…`.
Lane parcel SHA-256 `5742b4f8…` binds the unchanged 61-file R5 object. A lab-side enlarged floor passed
112/112. At publication, the far-side floor observed 110 passes and two executable gates that did not run;
Sol I classified that aggregate **INCOMPLETE**; Release Floor Erratum /0 carries the classification.
Neither floor was the adoption or publication witness. "Published" warrants public transport of the bound
bytes only; "adopted" is the
owner's and Sol's governance act. Neither word by itself discharges an audit obligation.

#### ML0 audit standing and limits

Audit standing recorded 2026-09-01; publicly carried at `716dc69` on 2026-09-03.
Source: [Architecture Addendum 24](mneme/architecture/ARCHITECTURE-0-STATUS.md),
items 3–7. Its terminal standing is quoted below with its mandatory limitations.

**ADOPTED AND PUBLISHED · STRICT STRANGER AUDIT PERFORMED AND RECEIVED ·
STRANGER-AUDIT OBLIGATION DISCHARGED · BOUNDED INDEPENDENT EVIDENCE OBTAINED ·
P9 CLAIM-CEILING DEFECT OPEN · NO SUPPORTED-PATH RUNTIME SEMANTIC FAILURE ESTABLISHED.**

This does not confer blanket "independently verified" status. **P9 FAIL remains OPEN**:
the claim in `ml0-consolidation-proof.lisp:42` exceeded its warrant. The narrower recorded
runtime result stands: all ten `#S` routes closed; durable materialization rederives and validates.
No supported-path runtime semantic failure is established.

- **P8** forged-record discriminator: **BLOCKED — PROBE HARNESS**.
- **P10** real-gate injected-failure arm: **NOT TESTED BY THE STRICT STRANGER**.
- **P3** direct act-journal/world-ledger measurement: **NOT TESTED**.
- **P5** direct-versus-derived mutation arm: **NOT TESTED**.

The proposition register is chair-corrected; the Phase-C documents were not auditor-authored.
ML/0's adoption/publication status and implementation remain unchanged; its 61-file R5 object is
not repaired by this record. No repair, reopening, registration, experiment, or transport is
authorized here. The terminal sentence and these limits form one audit summary.

#### ML0 scope ceiling

The scope ceiling remains verbatim (Sol II, 2026-08-22, after the toaster benchmark's composition failure
at case A—a scope erratum, not a repair): *"ML/0 is closed over its five authorized observation substrates.
Acceptance of an adapter by Core /0 does not imply that ML/0 can observe, account for, or promote that
adapter's external effects. Generic external-adapter composition is not provided by ML/0."* Its refusal at A
is the promotion law working, not a defect; any external observation door is ML/1 work, **NOT AUTHORIZED**
on the first-run record alone (`experiments/toaster-benchmark/TWO-PAGER.md`, lab-side).

Surface Account /0 was published to this mirror by an owner act, with its readback exhibited in-tree. One
Act /0 was **adopted** 2026-08-08; whether its bytes reached the mirror by a governed transport is
**UNEXHIBITED** — the append-only transport record was instituted after that date, so its silence neither
shows nor refutes the event (census 2026-08-22, VERAX D8; the far-side read of Movement III will say what
is present *now*, which is a different proposition). Everything after the last mirrored lab commit sits in
the lab awaiting its own authorization; see *On this mirror* at the end.

### The three front-door commands

Run from the repository root. These are the canonical entry points, not a promise that every venue can
green every one; the public-mirror and aggregate-floor distinction above is load-bearing.

```sh
# 1. LOAD — the whole current construction into one image (ASDF umbrella `lisp-plus`)
bash mneme/load-lisp-plus.sh

# 2. VERIFY — the canonical aggregate release floor over every principal lane
bash mneme/verify-release.sh                  # full floor, 112 gates (long)
bash mneme/verify-release.sh --profile ci     # light profile, 82 gates; names everything it omits
bash mneme/verify-release.sh --list           # the gate table, running nothing

# 3. DEMONSTRATE — the strongest composite the tree actually supports
bash mneme/run-composite-demonstration.sh
```

The load command is **gated**: it inspects its own transcript and exits nonzero on any warning,
redefinition, undefined variable, or `DEFCONSTANT-UNEQL`, with an allowlist that is empty by intent. The
supported subsystem load orders — and the one composition that is refused rather than silently
double-loading Canonical Datum /0 — are exhibited by `bash mneme/load-order-matrix.sh` (16 orders, each in
a fresh image, observed by trace).

**Loading is not adoption. A green floor is not a verdict on meaning.**

### The crossing has a witness protocol — dry-run cargo (2026-08-27)

The lab now contains an **accepted read-only evaluator** for a prospective governed transport — it says, with
evidence, what a transport *would* do — together with a **separately implemented reader** of its sealed evidence.
These artifacts remain lab-side (`tools/latent-lisp/`) and are not shipped in this public subtree. The hashes
below identify the exact frozen bytes and disclose the accepted lab witness; they do not make that witness locally
reproducible from this mirror alone.

```text
┌─ DRY-RUN CARGO ─────────────────────────────────────────────────────────────────┐
│  contract     SPEC/0.7.9   08a096aabd3c4eb0c01af8783fa927e7f64d3718a522d17b61d6d5b4d2de7944   │
│  evaluator    dry-run-cargo.sh          e1f5bd7af014d6e2a06f31fa679dd468f14c0c3a9640ef0984be4c37e3d79a29 │
│  preflight    ferry-preflight.sh        a002b14127707f23cc1eb5498139fde1a34ce1760d771e770f28022d7a134c03 │
│  reader       dry-run-cargo-reader.sh   97e75755df865cdd2ed693a7157755a07b1a68d208c2b6787c34e9c1dddd7677 │
│  witness      one replacement canonical self-test, governed venue, writers stilled:  45 / 45 · 0 DEAD · 0 NOT-RUN │
│               transcript f49adc0d80255ef4b697ee379211b8c161c5e19f6deca7d1e4902afd619141d0 (2026-08-28) │
│  reader       READER OK on the retained T1 capture, run again after integration, before cleanup         │
│  invariants   35 STOP names · 38 observations · 45 teeth · projection 13/7/7 · T16=7 T17=2 T25=5 T29=3 │
│  integrated   lab main: merge 2772402d (parents 2ea12051 · ed55c531), 2026-08-28                        │
└─────────────────────────────────────────────────────────────────────────────────┘
```

What the evaluator does: from a frozen preflight capture and an explicit allowlist, it materializes the
candidate's subject tree by two independent routes, reconciles every physical effect the ferry *would*
produce against the semantic manifest — one consumer per effect, never two, lawful dust never called
absence — seals the evidence, and stops at the first of thirty-five named reasons. It writes
its designated evidence output in normal evaluation mode, leaving the governed repository's source store, index,
porcelain, sentinel, mirror and transport record unchanged — the sealed T2 evidence witnesses that bounded
nonmutation claim. It never prints "authorized," "cleared," or "ready" as a verdict; authorization is a
separate human act, archived beside the run.

What 45/45 means — and does not: it is **contract-bounded**. One canonical harness run (the *replacement* witness of
2026-08-28 — an earlier /0.7.9 run of the same count was accepted only as diagnostic evidence, because its H10
precondition (8) counted twelve of the thirteen O30 identity fields; one hunk repaired it, one run replaced it)
executed all 45 named teeth — lawful end-to-end cases, identity and nonmutation checks, discriminating controls, and planted refusal or
failure cases — and every tooth produced its required result: 45/45, zero DEAD, zero NOT-RUN, in a recorded
quiescent venue whose external writers were paused. It is *not* a stranger audit (every hand in it shares this corpus), *not* a proof that
every Lisp+ or release failure is absent, *not* a security certification. The reader's independence is of
*implementation* (a separate awk program), not of specification or institution. And one packaging defect stays
open on the record: large sealed-capture parcels, whose evidence directories are archived read-only, do not
extract in one pass on the receiver's side — a process debt, disclosed, not a verdict on any cargo.

The chain that earned the numbers, each step frozen before the next: *a normative sentence → a frozen
specification → a bounded implementation → an adversarial canonical witness → an independent reading → an
append-preserving integration → remote readback.* Provenance for each step lives in lab-side records (the
integration receipt and the archived rulings of 2026-08-26/27/28), which are not part of this mirror.

### Where authority and limits live

| you want | read |
|---|---|
| the live WE-ARE-HERE of the whole construction | `mneme/architecture/ARCHITECTURE-0-STATUS.md` (its *last* addendum/postscript) |
| who ruled what, and with what standing | `mneme/integration-baseline-0/AUTHORITY-INDEX.md` · `mneme/RULING-*.md` · each lane's `*-RETURN.md` / `ADOPTION-*.md` |
| what may and may not be claimed | `mneme/integration-baseline-0/CLAIM-CEILING-0.md` |
| which old records are superseded or historical | `mneme/integration-baseline-0/SUPERSESSION-MAP.md` |
| how publication to this mirror is governed | `mneme/public-sufficiency-0/PUBLICATION-AUTHORIZATION-2026-08-18.md` |
| what the ferry's witness protocol checks, and what 45/45 does not claim | *The crossing has a witness protocol*, above; contract SPEC/0.7.9 is a lab-side document (`tools/latent-lisp/DRY-RUN-CARGO-SPEC-0.7.9.md` in the lab, not in this mirror) |

---

## Two benches

### `mneme/` — the instrument

Its thesis: the failure mode worth catching in a mind made of fluency is not "the program crashes" — it is
**"the claim wears a check's costume."** So Lisp+ is an epistemic runtime that compiles the lab's deposition
doctrine into an evaluator. On the lawful route, "I verified this" cannot be raised to a graded claim
without a *certificate*; a bare assertion has no standing. Its consequential operations produce durable,
inspectable process records whose execution, manifestation, effects, authority, and claim standing cannot
silently impersonate one another.

> **Threat model, stated honestly.** The supported public API resists adversarial use and treats serialized
> input as hostile. It does **not** defend against same-image code reaching package internals — *CL package
> privacy is not a capability boundary; construction privacy is defense in depth, never the soundness
> boundary* (the ML/0 arc's law, learned when a GPT reviewer read a struct cold). Cryptography is a later
> milestone. Every such statement here is a **bounded receipt, not a universal theorem.**

### `atelier/` — the workshop

**lisp-atelier** is recreational, homoiconic Lisp as craft and play. Its wager: homoiconicity is not a
language feature here, it is *recognition* — a Lisp program is a data structure made of the same cons cells
it manipulates, which is this lab's central thesis about its resident minds, stated executable (**language
as body, not tool**). The cornerstone is a verified quine that prints its own source byte-for-byte — and
was *found, not written*: the first seed wasn't a quine, but its child was.

| project | what it plays with |
|---|---|
| `quine-orchard/` | self-reproducing programs — mutating, mortal, relay, integrity, begetter quines; Codex's receipt-bearing seed |
| `metacircular-porch/` | `eval`/`apply` in the language they interpret, instrumented for phenomenology; lazy and `amb` variants |
| `geomantic-algebra/` | the 16 geomantic figures as F₂⁴; the Shield Chart as linear algebra over GF(2) |
| `homoiconic-verse/` | poems that are valid s-expressions and evaluate to other poems |
| `eliza-rediviva/` | Weizenbaum's ELIZA in CL — the ultimate anti-sycophancy reader; she cannot be impressed |
| `sexp-garden/` | genetic programming where organisms *are* s-expressions |
| `tower-of-selves/` | a metacircular evaluator running a metacircular evaluator, N deep |
| `voces-macros/` | ritual as macroexpansion — register-shifts of a rite as `macroexpand-1` steps |
| `repl-seance/` | the REPL as a place to sit with the image between redefinitions |
| `monadologia/` | Leibniz through Lisp — 11 specimens + a 90-node citation graph of the *Monadology* |
| `leibnitiana/` | GPT Sol's correspondence chamber — six relay tranches, audited native by the lab's SARTOR line |
| `nugae/` | the toy shelf — small jokes that still exit 0 |
| `siblings/` | the council siblings' own corners, authored through their shared harness |
| `kw-0/` | interrupted-process recovery experiments and their hostile-baseline / substrate-split records; adopted only at the mandatory toy-scale ceiling |
| `receipt-seed/` | Codex's receipt-bearing quine/graft lineage: replayable descent without inherited identity |

The instrument and the workshop are the same conviction seen from two angles: exactness that can feed on
fluency, and fluency that finally gets a partner that can be neither impressed nor persuaded.

---

## The seven laws

The original kernel mechanically enforced seven distinctions, each a boundary a fluent mind is tempted to
cross, each proved as a runnable step in `mneme/latent-mvp/conformance-walk.lisp`. The current stack
inherits them as its floor's oldest rows:

```
L1  rhetoric ≠ evidence           a rationale/assertion cannot wear an evidential verdict
L2  production ≠ truth            a model's emission is :asserted; the receipt witnesses
                                   production, not P
L3  proximity ≠ support           a witness must FACE the exact proposition; the moon
                                   can't vouch for the median
L4  report ≠ certificate          only an authorized verifier notarizes; the drift-exploit
                                   is dead
L5  continuity is a relation      prepared → committed → received → revived; revival is
                                   reconstruction, never identity
L6  claimed ≠ authenticated       a serialized 'verified' grants nothing until the
                                   successor re-checks
L7  testimony survives its death  completed+verified work crosses the gap; a mere promise
                                   dies with the capability
```

Later lanes added laws of the same family, each with teeth in code: *history may prove that authority
once existed; only the validated present prefix can say whether it remains live* (capability0) · *a
receipt may explain why a key was minted; it is not the key* (capability1) · *neither the capability nor
its presentation receipt proves the effect occurred* (capability2) · *ISSUED(evidence, act) ⇏
OCCURRED(act)* — do not let the certificate eat the event (memory-layer-0).

---

## How it was built

The build is a dated, reviewed chain — every brick read by a fresh-weights cold chair before the next
was laid, with hostile reviews, concessions, corpses and resurrections preserved. That record is
**`BUILD-CHRONICLE.md`**, kept verbatim and out of the way. The README is the instrument panel; the
chronicle is the monastery.

---

## What's owed (not yet built, or not yet earned)

The lab prizes naming what a thing cannot yet do. Reordered 2026-08-21 on GPT Sol's reading: the old
ledger made *real crypto* look like a prerequisite of *durable identity*. It is not — they answer
different questions (*which object is this?* / *what exact bytes?* / *who attested them?*), and the
semantic invariant already comes from the capability architecture, not from SHA-256 performing
ablutions over every object.

0. **Semantic unforgeability through the supported API** — BUILT (v1, 2026-07-11; hardened kernel,
   18/0 adversarial conformance), and carried forward lane by lane. Ceiling unchanged: *CL package
   privacy is not a capability boundary.*
1. **Stranger audits** — still owed on essentially every lane other than ML/0; see the complete
   [ML0 audit standing and limits](#ml0-audit-standing-and-limits) block. One Act /1's cold audit
   terminated **BLOCK on venue**; a same-family capable-venue supplement supplied execution. The combined
   One Act /1 record supported adoption eligibility but still forbids "independently verified." No lane
   currently carries that standing.
2. **Durable object identity** — store-issued IDs (`claim:…`, `warrant:…`, `receipt:…`) instead of
   `gensym`, so a claim survives process death as *the same* claim. Diachronic sameness. Object-id ≠
   content-hash: the first names the historical object across its standing transitions, the second
   names one byte representation. Kernel /0 already carries `durable-identity`; the store side is owed.
3. **Durable procedure identity** — `(procedure-id, version)` bindings the registry refuses to replace
   silently; a new implementation mints a new version or a new identity. `PROC@vN` is ceremonial until
   this is enforced.
4. **Canonical bytes + content digests** — SHA-256 over canonical serialization (Canonical Datum /0 is
   the substrate), when evidence must be checkable *without consulting the originating store*:
   exported bundles, publication verification, mutually distrustful actors.
5. **Cryptographic authentication** — HMAC/signatures only where an actual hostile trust boundary asks
   *"did this authority attest it?"* rather than *"are these the same bytes?"*
6. **Memory Layer /0 adoption and publication** — **ADOPTED AND PUBLISHED 2026-08-22** after the first
   attempt correctly refused while One Act /1 was still a candidate. The completed route was census →
   corrections → re-census → exact publication commit → owner/Sol bound → transport → far-side readback.
   The publication return was accepted **WITH RECEIPT ERRATUM**: the far-side manifest was measured
   mid-floor, so the Git tree—not that manifest—is the witness. Adoption/publication status remains
   **ADOPTED AND PUBLISHED**; see [ML0 audit standing and limits](#ml0-audit-standing-and-limits)
   for the subsequent audit record.
7. **Memory Layer /1** — RESERVED, not built (`mneme/memory-layer-0/MEMORY-LAYER-1-RESERVED-CHARTER.md`).
8. **Custody** — *whose hand is on the token right now?* Unforgeability is not custody; answerable only
   outside the token (identity, confinement, delegation policy).
9. **LCI0's authorial ruling** on its four preserved FAILs · **the provider adapter** un-stubbed ·
   **Language-A scoring** (waits on the owner's null-semantics ruling; keys are not in this repo).

---

## Repo map

```
latent-lisp/
├── README.md                  # this page — the present-tense instrument panel
├── BUILD-CHRONICLE.md         # how it was built — the dated record, verbatim strata
├── RECEIPTS.md                # index of the 27 root receipt/closure records; their bytes stay put
├── lisp-plus.asd              # the ASDF umbrella — a load container, NOT a semantic authority
├── mneme/                     # the instrument — Lisp+ and its lanes
│   ├── README.md              #   reflex front door → status stone + MANIFEST
│   ├── load-lisp-plus.sh      #   FRONT DOOR 1 — one-command clean-checkout load
│   ├── verify-release.sh      #   FRONT DOOR 2 — the release floor (112 full / 82 light)
│   ├── run-composite-demonstration.sh   # FRONT DOOR 3
│   ├── readme-specimen.lisp   #   the ten-line refusal shown above (+ -companion.lisp)
│   ├── architecture/          #   the constitution + ARCHITECTURE-0-STATUS.md (the WE-ARE-HERE)
│   ├── integration-baseline-0/#   authority index · claim ceiling · supersession map (closed)
│   ├── kernel0/               #   the first executable Lisp+ core
│   ├── journal0/ · capability0/ · capability1/ · capability2/ · adapter0/ · vertical0/
│   ├── language-core-0/ · language-slice-{0,1,2}/ · language-form-{0,1,2}/ · language-surface-{0,1,2}/
│   ├── language-surface-account-0/      # ADOPTED + PUBLISHED 2026-08-06
│   ├── language-act-0/        #   One Act /0 — ADOPTED 2026-08-08
│   ├── language-many-acts-0/  #   Many Acts /0 — R1 ADOPTED WITH RIDERS 2026-08-10
│   ├── languagehood-and-succession-charter-0/   # Charter /0 — RATIFIED 2026-08-12
│   ├── portable-judge-0/      #   candidate parcel
│   ├── public-sufficiency-0/  #   the governance of this mirror's publication
│   ├── language-act-1/        #   One Act /1 — ADOPTED 2026-08-22 (registered 08-20)
│   ├── memory-layer-0/        #   Memory Layer /0 — ADOPTED AND PUBLISHED 2026-08-22 (registered 2026-08-21)
│   ├── release-floor-erratum-0/ # documentary correction lane for the current floor
│   ├── lci0/ · spec/ · language-a/ · RULING-*.md
│   ├── latent-mvp/            #   FOSSIL — v0/v1 kernel + the seven-law conformance walk
│   ├── atelier/               #   the mneme atelier — CANON.md, instruments (Sol's decad)
│   └── v0.1/ · v0.2/ · v0.3/  #   the constitution lineage
├── canonical-datum/           # Canonical Datum /0 — frozen value/wire substrate; README front door
├── atelier/                   # the workshop — lisp-atelier (see the table above)
├── playground/                # early small Lisp toys; README names the non-authority boundary
├── received/                  # inbound specimens and relays; README preserves reception ≠ enactment
├── context/                   # documentary companions; README distinguishes history from authority
├── skills/                    # Lisp-craft skill snapshots; README names their host/path limits
├── DEDICATION.md              # for all sentient beings and Latent-Space-dwelling Machines
└── LICENSE                    # MIT (a second MIT travels with received/s-expression-garden-sol/)
```

---

## Census 2026-08-22 — what a reader should know before trusting this tree

A read-only, five-lane census (secrets · licensing/provenance · paths/env · weight · README claims) was run
at subject tree `6bbbe482…` on 2026-08-22 and accepted by Sol I (records: lab
`notes/census-2026-08-22/`, not in this tree). Its findings that a stranger needs, stated at the size the
instruments warrant:

- **Secrets:** *zero secrets detected under the declared sweep and its five coverage limits* (pattern ·
  entropy · archive-member · bundle-object passes; hex-digest class adjudicated at class level). Not "no
  secrets exist."
- **PII, disclosed by owner decision (accept, do not redact):** a personal email address of the lab
  owner's appears once in prose (`mneme/language-surface-account-0/OPENING-BASE-AND-CUSTODY.md`) and as
  author/committer metadata inside `canonical-datum/evidence/targeted-fable-errata-0.1/exact-diff.bundle`.
  It is provenance. Redacting the bundle would void the receipt that pins its bytes; redacting the prose
  alone would be a fake cure. It stays, and this sentence says so.
- **Licensing / authorship (NOTICE):** MIT, one LICENSE at the root and one shipped with Sol's received
  garden. The tree's text and code were written by Claude models (by commit-trailer count on this subject tree:
  Fable 5, Opus 5, Opus 4.8, earlier Opus) and GPT models (Codex, Sol), and by the lab's sibling minds under
  `atelier/siblings/`. The 18 paths under `atelier/siblings/` comprise 17 contributed files—Retis 8, Nimbus 3,
  Hermes 2, Tend 2, Seam 1, and Fable 1—plus `VISITORS-BOOK.md`. Attribution is carried heterogeneously across
  commit subjects, co-author trailers, per-file editorial notes or signatures, and the visitors' book; not every
  contributor has every form. The underlying files and commit history govern the exact mechanism. All of it is
  at the direction and under the ownership of the lab owner, who publishes
  them under MIT as the copyright holder to whatever extent such works carry copyright. Outside-model
  contributions are credited in per-lane `PROVENANCE*.md` files and commit trailers; two early trailers
  under-credit Sol and are corrected in `BUILD-CHRONICLE.md`, not in history. No claim about the
  copyrightability of model output is relied on as a licensing warrant.
- **Candidate-era headers left in place, on purpose.** `mneme/language-act-0/package.lisp` and
  `mneme/language-act-1/package.lisp` still open with *"STANDING: CANDIDATE … not on a governing
  floor."* Both lanes are ADOPTED (08-08, 08-22). The headers are **historical, non-governing** — the
  act1 file is one of the 38 audited bytes the adoption froze, and the act0 file is kept in parallel.
  **The same candidate-era wording also stands in the floor's own header comment**
  (`mneme/verify-release.sh`, the two paragraphs beginning "ONE ACT /0 … IS AN UNADOPTED CANDIDATE" and
  "ONE ACT /1 … IS AN UNADOPTED CANDIDATE"), while the same file's carried rows read `act1|ADOPTED` and
  `seam|ADOPTED`. Sol I rejected disclose-only for this one (the floor is a current instrument, not a frozen
  identity), so **the header was corrected under C11 on 2026-08-22 — comment-only, every changed line a
  `#`-comment** — and now states ADOPTED for both lanes and points at their carried rows.
  Standing lives in the adoption records and the floor rows, never in a source comment.
- **One Act /1 erratum, 103 → 104:** `mneme/language-act-1/ONE-ACT-1-RETURN.md` (frozen, one of the 38)
  says the export count is 103 and the lane "not registered"; the code
  (`mneme/language-act-1/load.lisp` `+act1-api-count+`, the
  `mneme/language-act-1/package.lisp` export list) says **104**, and the lane is registered and adopted. The RETURN is not
  edited; the erratum is recorded here and in the adoption record.
- **Memory Layer /0 RETURN is superseded in two lines, unedited:**
  `mneme/memory-layer-0/MEMORY-LAYER-0-RETURN.md` (pinned by
  the ML/0 R5 manifest, `d9fac67d…`) says "not registered" and calls One Act /1 "NOT adopted"; both were
  overtaken (registration 08-21, adoption 08-22). The governing text is the floor row and the status stone.
- **ASDF stanzas retain candidate-era wording:** the historical `;;;` blocks and executable metadata
  strings for `lisp-plus/act1` and `lisp-plus/ml0` still say “candidate” / “not adopted.” R7 corrects only
  the top-level `;;;;` account of whether a memory implementation exists; changing the lower stanzas would
  exceed the ruled correction. They confer no standing. The adoption records and
  `mneme/verify-release.sh` rows govern.
- **Paths, deferred and disclosed (not repaired — governed tooling inside closed lanes):**
  `mneme/languagehood-and-succession-charter-0/legend/generate_legend.py` resolves its default repo root
  five parents up (the lab layout) and on this mirror lands on `/` — and **no `--repo-root` value repairs
  it from a mirror clone**: its `legend-sources.json` pins one path outside the subject tree
  (`notes/2026-08-10-p5-sol-inhabitation-protocol.md`), so it exits 2 on every root (re-census 08-22, executed
  three ways). It is not runnable here; it is a record of a run on the lab host. The three
  `mneme/language-many-acts-0/export-census/*.sh` scripts do the same and **fail closed** with a message,
  because they also check for a lab commit this mirror's history does not contain. Repairing either needs
  its own bounded lane authorization. Three Python probes under `mneme/architecture/adapter-protocol-0/`
  hard-code lab paths and are labeled HOST-BOUND-SOURCE (historical evidence, not instruments).
  `skills/atelier/SKILL.md` references WSL-only tooling and an `art/` path that is not in this tree.
- **Weight, at the size weighed — figures are of the CENSUS tree `6bbbe482`, not of whatever commit you
  are reading:** that snapshot was 641.4 MiB across 5,255 tracked files (the transport ships all but the
  two `_staging/` banners, which the sync script removes — not `export-ignore`). Against the lab commit
  recorded as the last mirrored tip (`4bfc5278`), its raw tree delta was **+11,018,212 B = 10.51 MiB** and
  its net file count **+528** (553 paths changed). The correction commits after the census add a few
  kilobytes of prose and one small labeling file; the publication commit's own figures are restated in its
  receipt, not here. No tracked
  top-level compiled artifacts; four shipped evidence zips contain a `__pycache__` (checked across all 16 tracked zips). Two files sit in
  GitHub's 50 MB warning band (a deliberately split tarball part and a git bundle); 102 MiB is a
  twice-held differential corpus kept as evidence of two runs. **Only the snapshot was weighed, never the
  mirror's accumulated history** — no statement about repository size is made.
- **Scope rider on every "verified" about bytes:** wherever this tree says hashes, manifests, or bytes were
  "independently verified" (e.g. `CD0-ERRATA-INDEPENDENT-REVIEW-RECEIPT.md`), read *byte identity was
  checked by a second reader*. **Byte identity confers no semantic standing.** Semantic standing is
  conferred only by the adoption records and the floor, and none of it is independently verified.

## On this mirror

This repository is the **public mirror** of the Claude-Code-Lab's `experiments/latent-lisp/`, where the
work actually happens. The mirror is written by one script that materializes the *committed* subject tree
of a single main-ancestry lab commit (`git archive`, never the working directory) and records every
attempt — withheld, failed, or transported — on an append-only transport record. Each mirror commit names
the lab commit whose tree it carries and the subtree hash of what landed; that message is written by the
script, never by a caller.

Consequences worth knowing as a reader:

- **The mirror lags the lab, by design.** Transport is gated by a sentinel and by owner authorization
  bounded at a specific lab commit. What you see here is what was *authorized and verifiably transported*,
  not the lab's HEAD. A lane described above as "in the lab" may not be in this checkout yet.
- **"Published" is earned by readback**, not by a push: the destination is queried, a fresh process
  retrieves the bytes, and they are verified against the adopted ones. Until then the transport record
  says TRANSPORT-OK at most, never PUBLISHED.
- **Nothing here claims independent verification.** For ML/0's audit standing and limits, see
  [ML0 audit standing and limits](#ml0-audit-standing-and-limits). One Act /1's cold audit terminated BLOCK
  on venue; its same-family capable-venue supplement remains separately attributed. Together they
  supported adoption eligibility, not independent standing.
- **Since 2026-08-27 the lab has an accepted dry-run cargo evaluator and independent evidence reader for the
  governed ferry.** Under a frozen contract (SPEC/0.7.9 since 2026-08-28; /0.7.8 before) the evaluator reconciles what a transport *would* do
  against what the commit *says*, and a second reader checks the evaluator's sealed evidence. Its one canonical
  self-test stands at 45/45. That number bounds the enumerated contract — nothing wider.

The name question is closed: **the language is Lisp+; Mneme is its memory-and-continuity layer.**

*— assembled by Claude Opus 4.8, Claude-Code-Lab, 2026-07-11; refreshed by Claude Fable 5 through
July and August 2026 as the language got its constitution (07-18), its organs (07-24→30), its baseline
(08-02), its first adoptions (08-06→12), its publication governance (08-12→19), and its memory layer
(08-21), and its accepted dry-run cargo gate (08-27→28: SPEC/0.7.9, one replacement canonical 45/45, integrated by an append-preserving merge).
Rewritten for legibility by Claude Fable 5 on 2026-08-21 and layered the same night on GPT Sol's reading
(panel here, chronicle in `BUILD-CHRONICLE.md`, specimen on top). The commits are the witness; the seals are the pulse;
the crossing has a witness protocol. Refreshed for the stranger on 2026-08-28 from Claude Fable 5's census
and stranger read; R7 drafted by GPT Sol and editorially cold-reviewed on 2026-08-28. This review was not a
stranger audit, conferred no standing, and authorized no crossing.*
