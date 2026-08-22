# MEMORY LAYER /0 — GUIDE AND SYMBOL TABLE (candidate)

*How to use this lane lawfully, what it will refuse and why, and the whole public
interface in one table. For the next chair. — TABULARIUS, 2026-08-20.*

**STANDING: CANDIDATE.** Not adopted, not accepted, not frozen, not audited, not
registered on any floor. Nothing here is independent verification.

---

## 1. Loading it

```lisp
(load "mneme/memory-layer-0/load.lisp")   ; the canonical door
```

The loader enters One Act /1's door (which owns the Stack-A chain order), loads
this lane's four sources, and then **asserts the lane is complete** — a predicate
over all **195** declared external names plus a readiness carrier that is the last
form of the last-loaded source. A package existing is not the lane being ready.

There is **no ASDF row and no floor row**, by the commission's writ. If a later
chair adds one, the lane belongs in the COMPLETENESS-CHECKED class and
`ml0-api-complete-p` is already the predicate for it.

---

## 2. The lawful use, in six steps

> ## ⚠ REWRITTEN 2026-08-20, IN REPAIR ROUND R3 — AND THE OLD RECIPE IS GONE, NOT WARNED ABOUT.
>
> The chair BLOCKED candidate `a492a05f…` in part **because of what this guide told
> you to do**, and BLOCKED its successor `069266ca…` in part because the guide's
> "lawful use" still **executed the blocked API** under a warning banner. A warning
> above broken executable instructions is not a repaired guide. The recipe below is
> the current one; it was **walked in a fresh `sbcl --script` process, following it
> literally**, and that walk's transcript is preserved beside it as
> `GUIDE-WALK.txt`.
>
> | To do this | Use | Result |
> |---|---|---|
> | say something durable about an act | `make-ml0-source` (public) | `:ASSERTED-TESTIMONY` — carried, retrievable, **can never warrant occurrence** |
> | establish that something happened | a **production door**: `ml0-observe-world`, `ml0-observe-journal`, `ml0-observe-reconciliation`, `ml0-observe-absence`, `ml0-observe-issuance` | `:VALIDATED-BY-DOOR` — the door READ the substrate and derived every field from it |
> | carry a past account's warrant into a new process | `ml0-retrieve` (never `ml0-account-from-event`) | `:INHERITED-FROM-VALIDATED-RECORD` — the store's frame chain verified first |
>
> **THREE THINGS THAT ARE NOW STRUCTURAL, not advisory:**
>
> 1. **A door takes ONE SUBJECT.** `ml0-subject-from-fixture-row` derives the act
>    identity, the attempt, the external-request key and the canonical request
>    **together** from one declared row. There is no `act-id` argument to pair with
>    somebody else's `attempt`.
> 2. **`:observations` is the only warrant-bearing channel into a bundle.**
>    `:sources` and `:testimony` still work and are still durable — and every row
>    through them is **normalized to non-warranting testimony**, whatever it
>    arrived as.
> 3. **Issuance is a reading, never a keyword.** `:issuance-standing` is
>    **refused** (`ML0-BND-6`). Pass an `:issuance-observation` from
>    `ml0-observe-issuance`; a reading that was not conjoined with the subject's own
>    canonical request can only yield `:unresolved`.

⚠ **Prerequisite for the snippet below.** `load.lisp` gives you **the lane**,
including all five production doors. It does **not** give you a store, a world or a
fixture table — those belong to One Act /1 and capability /2. The worked example
therefore loads `ml0-suite-ground.lisp`, which is **test infrastructure and not one
of the lane's four sources**, purely for that GROUND. *Nothing that warrants
anything comes from that file:* every row below is built by a door that lives in
`ml0.lisp`.

```lisp
;;; The whole recipe, executable.  Save as e.g. /tmp/ml0-walk.lisp and run
;;;   sbcl --script /tmp/ml0-walk.lisp
;;; from the subject-tree root (experiments/latent-lisp).

(load "mneme/memory-layer-0/ml0-suite-ground.lisp")   ; the GROUND only
(in-package #:lisp-plus-memory-layer0)

;; (0) A run root OUTSIDE the subject tree, and the ground under it.
(defvar *root* (ml0-fresh-run-root "ml0-guide" #p"mneme/../"))
(ml0-ground *root*)

;; (1) PERFORM the act through One Act /1's public seam.  This lane never
;;     performs anything; it reads what performing left behind.
(defvar *row* (ml0-settled-row))
(setf lisp-plus-language-act1:*act1-fixture-table* (list *row*))
(ml0-open-authority (list *row*))
(defvar *result* (lisp-plus-language-act1:run-act1 *row* :verbose nil))

;; (2) DERIVE THE SUBJECT — once, from the one declared row.  Act identity,
;;     attempt, external-request key and canonical request come out together.
(defvar *subject* (ml0-subject-from-fixture-row *row*))

;; (3) OBSERVE.  Each door READS its own substrate and derives every field from
;;     what it read.  A door is the SUPPORTED producer of a warrant stamp (R4.1e:
;;     not exposed through the exported, supported API; package privacy is not a
;;     capability boundary; BOA closes the supported #S route, not every call).
(defvar *world-obs*   (ml0-observe-world   *subject* (ml0-world)))
(defvar *journal-obs* (ml0-observe-journal *subject* *ml0-act-store*))

;; (4) OBSERVE THE ISSUANCE — conjoined, in THIS image, at write time, and never
;;     anywhere else.  The canonical request comes from the subject; you do not
;;     supply it and you cannot supply a standing.
(defvar *issuance-obs*
  (ml0-observe-issuance
   *subject*
   (lisp-plus-language-act1:act1-result-evidence *result*)))

;; (5) BUNDLE and WRITE.  The bundle carries the FIXTURE ROW, not a derived
;;     record: the lane does the identity arithmetic itself and re-derives the
;;     door binding independently (ML0-WR-7).
(defvar *account*
  (ml0-write *ml0-account-store*
             (make-ml0-bundle
              :fixture-row *row*
              :claimed-act-id (ml0-subject-act-id *subject*)  ; compared byte-for-byte
              :subject-principal "the actor"                  ; NEVER the recorder
              :observations (list *world-obs* *journal-obs*)  ; the warrant channel
              :issuance-observation *issuance-obs*            ; a READING, not a word
              :sources (list (ml0-self-report-source          ; testimony, normalized
                              (ml0-subject-act-id *subject*)
                              "the writing process read both instruments itself"))
              :effect-observation
              (ml0-effect-observation-of (ml0-subject-attempt *subject*)))))

;; (6) LATER, IN ANOTHER PROCESS: retrieve, and read the two axes separately.
(defvar *back* (ml0-retrieve *ml0-account-store*
                             :account-hex (ml0-account-id-hex *account*)))
(format t "~&occurred?          ~a~%" (ml0-account-occurred-p *back*))
(format t "~&issuance standing  ~s~%" (ml0-account-issuance-standing *back*))
(format t "~&retrieval origin   ~s~%" (ml0-account-retrieval-origin *back*))
(format t "~&may continue?      ~a~%" (ml0-account-may-continue-p *back*))
(format t "~&standing authority ~s~%" (ml0-account-standing-authority *back*))

;; (7) R4 — ASK THIS LANE'S OWN STORE WHAT IT HOLDS.  `record-coverage` is the
;;     one axis this lane is COMPETENT over, and it is DOOR-PRODUCED through the
;;     supported API (R4.1e; see the stamp note at step 3): passing
;;     `:record-coverage` is refused (ML0-BND-10).  The door SCANS.
(defvar *coverage* (ml0-observe-record-coverage *ml0-account-store* *subject*))
(format t "~&coverage finding   ~s~%"
        (ml0-record-coverage-observation-finding *coverage*))
```

**What that prints, and every line of it is load-bearing:**

```
occurred?          T
issuance standing  :ISSUED-IN-WRITING-IMAGE
retrieval origin   :RECONSTRUCTED
may continue?      NIL
standing authority :VALIDATED-RETRIEVAL
coverage finding   :ISSUANCE-RECORD-PRESENT-IN-ACCOUNT-STORE
```

`:ISSUED-IN-WRITING-IMAGE` and `T` sit on **separate axes** and neither implies the
other: **ISSUED ⇏ OCCURRED** is the law this lane exists to keep. `:RECONSTRUCTED`
is the origin ratchet — a retrieval is never a live observation. `NIL` is not a
limitation of this build: a memory account is not a capability, and
`ml0-account-may-continue-p` is **always** NIL, by law.

`:VALIDATED-RETRIEVAL` (R4) says **which route produced the standings above** —
`ml0-retrieve` validated the enclosing frame chain first. The same bytes through
the public raw decoder, `ml0-account-from-event`, answer `:RAW-DECODE`, and on
that route the standings are **re-derived from the rows** rather than read off the
bytes: `occurred?` becomes NIL and `ml0-account-carried-standings` holds what the
bytes claimed. That pair — same frame, two routes, two answers — is
`ml0-selftest` §K's F2 check, which is where to read it as executable code rather
than as an illustration in a guide.

`:ISSUANCE-RECORD-PRESENT-IN-ACCOUNT-STORE` (R4) is a finding **the door made by
scanning**, not a word you chose. Its universe is the whole validated prefix of
*this* store and nothing else; when the prefix is not `:valid` the door answers
`:NOT-EXAMINED` under a `:COULD-NOT-LOOK` scope, because *I could not look* and
*I looked and it is not there* are different sentences.

---

## 3. THE CROWN REFUSAL, and how to see it for yourself

The one thing this lane exists to refuse:

```lisp
;; A LAWFULLY refused act — `:authority-mode :ambient` makes Core /0 refuse at
;; its own authority check — GENUINELY ISSUES a Core /0 evidence account bound to
;; that act's canonical request (core0.lisp:1059-1082, "ISSUANCE SITE 1 of 4").
;; The journal frame count does not move; the derived standing is :ABSENT; the
;; world is byte-unchanged.  The act did not happen and the certificate exists.
(let* ((subject (ml0-subject-from-fixture-row refused-row))
       (issuance (ml0-observe-issuance
                  subject
                  (lisp-plus-language-act1:act1-result-evidence refused-result))))
  (ml0-write store
             (make-ml0-bundle
              :fixture-row refused-row
              :claimed-act-id (ml0-subject-act-id subject)
              :subject-principal "the actor"
              :issuance-observation issuance)))
;; =>  an ACCOUNT.  Not a refusal — the lane REMEMBERS that evidence was issued.
;;     But:  (ml0-account-occurred-p it)          => NIL
;;           (ml0-account-occurrence-standing it) => :UNRESOLVED
;;           (ml0-account-issuance-only-p it)     => T
;;           (ml0-account-issuance-standing it)   => :ISSUED-IN-WRITING-IMAGE
```

⚠ **The standing is DERIVED from the door's live conjoined reading.** There is no
`:issuance-standing` argument any more; passing one is refused (`ML0-BND-6`). And
the conjunction is not optional: a reading that carries no request binding yields
`:unresolved`, because the unconjoined predicate says an account was minted in this
image and does not say **which act** it belongs to.

To see **which leg answered**, and to satisfy yourself that the refusal is not an
accident of a malformed bundle:

```lisp
(ml0-print-conjuncts "the issuance bundle" act-id source)
;;    validation   [ML0-PROMOTE-0] : yes
;;    species      [ML0-PROMOTE-1] : NO  <== this leg answered
;;    attestation  [ML0-PROMOTE-2] : NO  <== this leg answered
;;    subject-identity [ML0-PROMOTE-3] : yes
;;    …the other five: yes…
```

⚠ **TWO legs answer here, and that is worth understanding before you read the RED
proof's table.** The issuance door's *honest reading* attests `:inconclusive` — a
mint is not a finding about a frontier — so an ordinary issuance row fails leg 1
**and** leg 2. That is the truthful shape of the ordinary case, and it is also a
weaker demonstration: with two legs refusing, a reader cannot tell which one is
load-bearing.

**The single-leg demonstration lives in `ml0-block-proof.lisp` probe B1a**, where a
forged **testimony** row satisfies all eight fillable legs and fails on **leg 0
alone** — the validation leg, which asks whether anyone looked. `ml0-single-delta-pair`
(in the suite ground) still builds the near-neighbour pair the RED proof uses; since
the repair its issuance row comes from the real door and therefore reports honestly,
so that pair now differs in species **and** attestation. **A door cannot be made to
lie in order to make a demonstration prettier**, and the lost sharpness is recorded
rather than recovered by a fiction.

Run it:

```sh
sbcl --script mneme/memory-layer-0/ml0-red-proof.lisp          # both arms
sbcl --script mneme/memory-layer-0/ml0-red-proof.lisp uncured  # exits 1, on purpose
sbcl --script mneme/memory-layer-0/ml0-block-proof.lisp        # the twenty probes
```

---

## 4. What it will refuse, and the requirement id it refuses with

| You did | It answers | Id |
|---|---|---|
| claimed an act identity the declared row does not derive to | `ml0-subject-identity-mismatch` | `ML0-WR-3` |
| put a source about **another** act in this bundle | `ml0-subject-identity-mismatch` | `ML0-WR-4` |
| put a qualifying positive **and** a commensurable scoped negative in ONE bundle | `ml0-provenance-incomplete` | `ML0-WR-6` |
| offered a frame that **this lane's own decoder would refuse**, or a minted identity that is not the body's content digest — caught by the **pre-append dry decode** (R5), on the direct route **and** the derived one | `ml0-account-encoding-refused` | `ML0-WR-8` |
| offered a bundle with no sources | `ml0-provenance-incomplete` | `ML0-BND-2` |
| said `:not-issued`, or anything not in the two-member axis | `ml0-standing-vocabulary-refused` | `ML0-BND-3` |
| supplied `:record-coverage` or `:record-coverage-scope` at all (R4) | `ml0-standing-vocabulary-refused` | `ML0-BND-10` |
| passed something that is not an `ml0-record-coverage-observation` (R4) | `ml0-provenance-incomplete` | `ML0-BND-11` |
| called the coverage door without the canonical subject carrier (R4) | `ml0-provenance-incomplete` | `ML0-RC-1` |
| handed `ml0-account-from-event` a frame whose event-id is not this lane's shape (R4) | `ml0-account-readback-refused` | `ML0-RB-11` |
| read back an effect observation whose provenance is not `caller-asserted` (R4) | `ml0-account-readback-refused` | `ML0-RB-5` |
| built a source with a species outside the closed set | `ml0-source-species-refused` | `ML0-SRC-1` |
| built a source without an observation interval | `ml0-provenance-incomplete` | `ML0-SRC-9` |
| tried to mint `origin/observed` | `ml0-provenance-incomplete` | `ML0-ORIGIN-1` |
| passed `:observed` as an acquisition route | a `type-error` from the `ecase` | — |
| retrieved from a damaged store | `ml0-account-readback-refused` | `ML0-RB-1` |
| asked for an account identity that is not there | `ml0-account-readback-refused` | `ML0-RB-2` |
| consolidated across two different acts | `ml0-consolidation-refused` | `ML0-CON-2` |
| consolidated an account that did not come through a validated retrieval — a `:raw-decode` (R4.1) | `ml0-consolidation-refused` | `ML0-CON-3` |
| consolidated inputs that share an act but not a subject carrier (seat / attempt / subject-principal) (R4.1) | `ml0-consolidation-refused` | `ML0-CON-4` |
| handed `ml0-materialize-consolidation` anything that is not an `ml0-consolidation` carrier (R4.1) | `ml0-consolidation-refused` | `ML0-MAT-1` |
| materialized a carrier that **disagrees with the store** — its source or predecessor list was rewritten, or it went stale (R4.1b) | `ml0-consolidation-refused` | `ML0-MAT-2` |
| materialized a carrier into a store that **cannot retrieve its inputs** — including any cross-store materialization (R4.1b) | `ml0-consolidation-refused` | `ML0-MAT-3` |
| materialized a carrier whose subject principal does not read `principal:<name>` (R4.1b) | `ml0-consolidation-refused` | `ML0-MAT-4` |
| typed a `#S(LISP-PLUS-MEMORY-LAYER0:ML0-…)` literal for **any** lane struct (R4.1b) | a `reader-error` — **every internal constructor is BOA, so `#S` has nothing to call** | — |
| passed `:derivation` or `:predecessors` to `ml0-write` (R4.1) | a `program-error` — **the keywords are gone from the arglist** | — |
| handed it something that isn't a fixture row | `ml0-bridge-contract-violated` | `ML0-BRIDGE-2` |

**Refusals are named by CONDITION TYPE + REQUIREMENT-ID, never by message text.**
SBCL's condition report text is not a stable interface.

**And an admitted family's lawful refusal arrives as ITSELF.** A
`act1-request-lexis-refused` from the identity re-derivation is not reclassified
into an `ml0-` anything. `ml0-host-fault-proof.lisp` checks both halves of that
gate, because a gate that answered "bridge violation" to everything would pass the
first half perfectly.

### What a failed write leaves — §5.A as amended (AMENDMENT 2, Sol, 2026-08-21)

The governing sentence, verbatim: *"Every refusal raised before `append-event` is
observably non-mutating over the whole declared store. Once `append-event`
succeeds, a subsequent readback or identity refusal returns no account and neither
retracts nor rewrites durable bytes. Any surviving bytes acquire no standing merely
by surviving: they are judged only through Journal /0 validation and Memory Layer
/0 retrieval. Append success, serialization success, and evidence or certificate
issuance are never evidence that the represented act occurred."*

In practice, for a caller of a durable write — `ml0-write` or
`ml0-materialize-consolidation`, which share one append tail: **if you get a
refusal, look at its requirement id.** Every write-path id in the table above
except `ML0-RB-*` and `ML0-WR-5` refuses **before** the append, and the store —
file set and every file's sha256 — is **unchanged**;
that now includes `ML0-WR-8`, which is the lane running its **own decoder over the
exact bytes it is about to write** and refusing if that decoder would refuse them
or if the identity disagrees. **What is left after the append is host fault only:**
the bytes moving under the process between the append and the readback. If that
happens you get **no account** — nothing downstream can read a standing off the
retained frame — and **nothing is retracted, truncated, tombstoned or superseded**,
because no such verb exists in this lane or in Journal /0. The frame stays as the
record of what was actually written, and it is judged like any other bytes: by
Journal /0 validation and Memory Layer /0 retrieval, never by having survived.
**Measured:** `ml0-controls` TOOTH 7 (four pre-append paths), TOOTH 12 and TOOTH 13
(planted dry-decode and identity faults, each shown refusing pre-append **and**
shown reaching the append when the check is skipped), TOOTH 11 (the modelled host
fault).

---

## 5. The gates

```sh
sbcl --script mneme/memory-layer-0/ml0-selftest.lisp
#   ml0-selftest: 81 checks, 0 failures
sbcl --script mneme/memory-layer-0/ml0-controls.lisp
#   ml0-controls: 13 controls, 13 caught, 0 missed
sbcl --script mneme/memory-layer-0/ml0-mutants.lisp
#   ml0-mutants: 6 defects, 6 killed, 0 survivors
sbcl --script mneme/memory-layer-0/ml0-red-proof.lisp
#   ml0-red-proof: cured PASS, uncured FAIL — the tooth bites
sbcl --script mneme/memory-layer-0/ml0-host-fault-proof.lisp
#   ml0-host-fault-proof: PASS
sbcl --script mneme/memory-layer-0/ml0-block-proof.lisp
#   ml0-block-proof: 20 probes, 20 closed, 0 open
sbcl --script mneme/memory-layer-0/ml0-consolidation-proof.lisp     # R4.1, §8 added R4.1b
#   ml0-consolidation-proof: 35 checks, 0 failures
sbcl --script mneme/memory-layer-0/de-actu-memorato/run-specimen.lisp
#   de-actu-memorato: 45 checks, 0 failures  ·  RESULT: PASS
```

⚠ **THE RED PROOF HAS TWO SINGLE-ARM INVOCATIONS AND THEIR EXITS ARE PART OF THE
GATE (R4.1).** The combined run above must exit **0**; run alone, the **uncured**
arm must exit **NONZERO** and the **cured** arm must exit **0**. Read what they
*print*, not only what they exit: the two arms must **disagree** on
`after CONSOLIDATION` (`:OCCURRED` uncured, `:UNRESOLVED` cured) and on
`CROWN TOOTH` (`FAIL` / `PASS`). In R4.1 that conjunct was found **dead** — it
compared a keyword against a struct after `ml0-consolidate` changed its return
type, so it could not be false while the gate went on exiting 0 and printing *the
tooth bites*. **A gate never seen to fire is untested, not passing.**

Every suite runs its own **W-ENV pre-flight** first and **VOIDS** (exit 4) if any
process-ending switch is set. A void is not a failure and is never reported as a
pass. Every suite writes its run root under `/tmp` and **refuses to run** (exit 3)
if that root falls inside the subject tree.

---

## 6. THE SYMBOL TABLE — package `#:lisp-plus-memory-layer0`

**195** declared external names: **148 functions · 27 variables · 20 types.** Loader
package `#:lisp-plus-memory-layer0-loader`: `ensure-ml0-lane`,
`ml0-api-complete-p`, `ml0-api-shortfall`, `ml0-lane-files`, `load-ml0-lane`,
`ml0-lane-incomplete`.

⚠ **R4.1 — THIS COUNT WAS STALE, AND IT WAS ALREADY STALE AT R4.** This guide said
*"145 declared external names: 103 functions · 25 variables · 17 types"* in both
places it states the number; R4 had already raised the declared API to 177 and the
guide was not updated with it (the R4 received review caught the discrepancy). The
figure above is the R4.1 loader's own declaration — `+ml0-api-count+` **195**,
asserted in `ml0-api-shortfall` against the sum of the three declared lists — and
it was **read out of a loaded image**, not off the source text: 148 + 27 + 20 =
195, shortfall NIL. R4.1 added **17 functions and 1 type**: the
`ml0-consolidation` carrier with its fifteen readers and `ml0-consolidation-p`,
plus `ml0-materialize-consolidation`. *What is built is a query, never a memory
line* — run the loader.

### The semantic object

| Symbol | What it answers |
|---|---|
| `ml0-account-p` · `ml0-account-id` · `ml0-account-id-hex` · `ml0-account-id-datum` | is it an account; its kernel `:claim` identity; the 64-hex content digest; the same as a CD/0 identifier (for predecessor rows) |
| `ml0-account-act-id` · `-act-id-hex` · `-subject-seat` · `-subject-attempt` | **which act** |
| `ml0-account-occurrence-standing` · `-occurrence-scope` | **occurrence standing**, and the scope that warrants it |
| `ml0-account-issuance-standing` · `-issuance-scope` | **issuance standing** — a separate axis |
| `ml0-account-record-coverage` · `-record-coverage-scope` | what THIS store holds — on neither axis |
| `ml0-account-effect-observation` | a scoped observation of the adopted external-effect axis |
| `ml0-account-sources` | **why it may say this** — typed provenance rows |
| `ml0-account-derivation` · `-predecessors` | **how it was derived** |
| `ml0-account-recorder-principal` · `-subject-principal` | who wrote it / whose act it is about |
| `ml0-account-retrieval-origin` | `:reconstructed`, always |
| `ml0-account-standing-authority` (R4) | `:validated-retrieval` \| `:raw-decode` — **which route produced the standings above** |
| `ml0-account-carried-standings` (R4) | a plist of what the **bytes** claimed, preserved verbatim beside the lane's own answer |
| `ml0-account-body-record` | the exact durable body |

### The public readers

| Symbol | Contract |
|---|---|
| `ml0-account-occurred-p` | **the only positive-occurrence reader in the lane** |
| `ml0-account-issuance-only-p` | issuance testimony present, no occurrence-admitted species |
| `ml0-account-carries-no-current-image-evidence-p` | walks the whole public surface; shown able to fire |
| `ml0-account-may-continue-p` | **always NIL, by law** |
| `ml0-render-account` | diagnostic rendering, never an identity representation |

### The promotion rule

`ml0-occurrence-warranted-p` · `ml0-occurrence-conjuncts` · `ml0-failing-leg` ·
`ml0-print-conjuncts` · `ml0-species-may-warrant-occurrence-p` ·
`ml0-nonoccurrence-warranted-p` · `ml0-derive-occurrence-standing` ·
`ml0-warrants-commensurable-p` · `ml0-acquisition-route-identifier` ·
`ml0-mint-account-identity` · `ml0-evidence-projection-digest`

### The operations

`ml0-write` · `ml0-retrieve` · `ml0-consolidate` ·
`ml0-materialize-consolidation` (R4.1) · `ml0-fold-issuance` ·
`ml0-fold-record-coverage` · `ml0-list-account-ids` · `ml0-account-hex-of-event` ·
`ml0-account-from-event` · `ml0-rederive-act-identity` · `ml0-through`

| Call | Takes | Returns |
|---|---|---|
| `(ml0-write store bundle &key recording-process)` | a public **testimony/observation** bundle | ONE **direct** account, read back from the store. Always `:direct-write`, always no predecessors. **`:derivation` and `:predecessors` are not arguments (R4.1)** |
| `(ml0-consolidate accounts)` | accounts whose `ml0-account-standing-authority` is `:validated-retrieval` | ONE **`ml0-consolidation` carrier** (R4.1 — *not* five bare values). Effect-free: it appends nothing and opens no store |
| `(ml0-materialize-consolidation store consolidation &key recording-process)` | a carrier `ml0-consolidate` built | ONE **derived** account (`:consolidation`, predecessors named), read back from the store. **The lane's durable route out of a consolidation — the carrier is handled as an untrusted request** |

### The consolidation carrier (R4.1 — the consolidation contract's cure)

`ml0-consolidation-p` ·
`ml0-consolidation-{act-id,act-id-hex,subject-seat,subject-attempt,subject-principal,occurrence-standing,occurrence-scope,issuance-standing,issuance-scope,record-coverage,record-coverage-scope,sources,predecessors,inputs,clash}`
· `ml0-materialize-consolidation`

**The constructor is INTERNAL** (`%make-ml0-consolidation`), exactly as the
observation doors' row constructor is. ⚑ **R4.1c — SAY IT NARROWLY.** (1) **No
constructor is exported.** (2) The supported SBCL `#S` **default-constructor**
route is refused because all ten lane structures use **BOA** constructors. (3)
**Construction privacy is defense in depth, not the soundness boundary** — do not
rest an argument on it; rest it on the paragraph below. **No ordinary argument
selects a standing or a lineage any more.**

Until 2026-08-21 `ml0-consolidate` returned five bare values and this guide's route out of them was `make-ml0-bundle :sources` +
`ml0-write :derivation :consolidation` — a route that **could not carry the
result**: `:sources` is the public *testimony* channel and normalizes every
inherited row to testimony, so a computed `:OCCURRED` was written back as
`:UNRESOLVED`, and a lawful `:CONTRADICTED` was refused at `ML0-WR-6`.
`RED-CONSOLIDATION-BEFORE.txt` measures that, and `RED-CONSOLIDATION-AFTER.txt`
(**35 checks**, 0 failures — 27 at the R4.1 execution, 34 at R4.1b) measures the
carrier route, including a **fresh-process** retrieval of the derived account.

⚠ **A carrier is not an account.** It has no identity and no frame; holding one
proves nothing durable. Only materialization does.

⚠ **THE CARRIER IS INSPECTABLE, NOT TRUSTED — MATERIALIZATION RE-READS THE STORE
(R4.1b).** Read every field you like; nothing durable follows from any of them.
`ml0-materialize-consolidation` takes **only the identities of the carrier's
inputs**, re-retrieves each one from the **target store** through `ml0-retrieve`,
re-runs `ml0-consolidate` over what the store actually returned, and writes
**that**. **The exact claim (R4.1c): no presented body field selects durable
standing or lineage; the carrier's input identities select what the store is asked
to retrieve, and the resulting body is recomputed from those retrievals and
checked against the presented one by canonical-body SHA-256 digest.** If the
carrier you present disagrees with the store, you get `ML0-MAT-2` and **nothing is
written** — a stale or altered carrier is refused,
never quietly corrected. If the target store cannot retrieve an input, you get
`ML0-MAT-3`, and that includes **every cross-store materialization**: a carrier
computed over store A's accounts cannot be made durable in store B, because a
lineage the reading store cannot check is not a lineage it can hold. ⚑ **That
narrowing was fork R4.1-F3, an open governance item; it is now RULED —
DISPOSITION A** (Sol, 2026-08-21; WORK-ORDER AMENDMENT 3): same-store-only durable
consolidation is accepted for `/0`, `ML0-MAT-3` stays, and effect-free
consolidation across stores may compute but `/0` will not materialize it durably.
**Memory Layer /1 is RESERVED** for receipt-bearing cross-journal materialization
and the standing of foreign warrants (`MEMORY-LAYER-1-RESERVED-CHARTER.md`) — a
reserved subject, **not a built lane**. Architecture 0.1's
**D4** — *"cross-journal merges are receipt-bearing transformations, never
timestamp sorts"* — remains binding on any future implementation. This is why
`copy-structure` on a carrier is harmless, and why `rplaca` through
`ml0-consolidation-sources` — which *works*, the list is a real list — buys
nothing: in R4.1 it wrote `:OCCURRED` with **zero warranting rows**
(`RED-CARRIER-BEFORE.txt`), and now it is a refusal
(`RED-CARRIER-AFTER.txt`).

⚠ **AND `#S` IS REFUSED FOR EVERY LANE STRUCT (R4.1b).** All ten internal
constructors are **BOA**, so a `#S(LISP-PLUS-MEMORY-LAYER0:ML0-ACCOUNT …)`
literal — or `ML0-SOURCE`, `ML0-OBSERVATION`, `ML0-BUNDLE`, `ML0-CONSOLIDATION` —
is a `READER-ERROR`. Until 2026-08-21 every one of them was publicly
constructible that way, with every slot chosen; SPEC §6c has the property and the
reason.

### The constructors and their accessors

`make-ml0-scope` / `ml0-scope-{p,universe,status,detail,record,from-record}` ·
`make-ml0-source` /
`ml0-source-{p,species,acquisition-route,producer-principal,recorder-principal,coordinate,observation-scope,observation-interval,origin-as-read,subject-act-id,payload-digest,frontier-relation,attests,record,from-record}` ·
`make-ml0-effect-observation` /
`ml0-effect-observation-{p,standing-as-read,determinacy,world-digest,scope,provenance,record,from-record}`
(R4: `provenance` is `:caller-asserted`, always, in this slice — there is no
world-reading door on this axis, and the mark is not a constructor parameter) ·
`make-ml0-bundle` /
`ml0-bundle-{p,fixture-row,claimed-act-id,subject-principal,sources,observations,testimony,issuance-observation,issuance-standing,issuance-scope,record-coverage,record-coverage-scope,effect-observation}`

### The canonical subject carrier (R3, the R2-BLOCK 2 cure)

`ml0-subject-from-fixture-row` /
`ml0-subject-{p,fixture-row,act-id,act-id-hex,seat,attempt,external-request-key,canonical-request}`

**Every door takes one of these and nothing else about the subject.** The five
facts are derived together from one declared fixture row through One Act /1's
public non-performing seam, so no caller can pair one act's identity with another
act's attempt, ledger key or canonical request.

### The production observation doors (R2, the BLOCK 1 cure)

`ml0-observe-{journal,world,reconciliation,absence,issuance}` ·
`ml0-observation-{p,source,door,read-summary,species,issued-p}`

`(ml0-observe-journal subject store)` · `(ml0-observe-world subject world)` ·
`(ml0-observe-reconciliation subject store world resolution)` ·
`(ml0-observe-absence subject world &key universe directory)` ·
`(ml0-observe-issuance subject evidence)`

### The record-coverage door (R4, the Codex-audit F3 cure)

`ml0-observe-record-coverage` ·
`ml0-record-coverage-observation-{p,finding,scope,read-summary,account-hexes}`

`(ml0-observe-record-coverage store subject)` — scans the whole validated prefix
of **this lane's own account store**, opens every account frame through
`ml0-retrieve`, and answers `:issuance-record-present-in-account-store` /
`:no-issuance-record-in-account-store` on what it found, or `:not-examined` under
a `:could-not-look` scope when the prefix is not `:valid`. It is the **only**
producer of a coverage finding: `make-ml0-bundle` refuses `:record-coverage` and
`:record-coverage-scope` at `ML0-BND-10` and takes `:record-coverage-observation`.

### The store-scope absence instrument

`ml0-take-store-scope` · `ml0-store-scope-unchanged-p` ·
`ml0-print-store-universe` ·
`ml0-store-scope-{p,files,digests,directory}`

### The closed vocabularies (all exported, all checked by the selftest)

`+ml0-source-species+` (7) · `+ml0-occurrence-species+` (3) ·
`+ml0-nonoccurrence-species+` (1) · `+ml0-attestations+` (3) ·
`+ml0-acquisition-routes+` (2) · `+ml0-occurrence-standings+` (4) ·
`+ml0-issuance-standings+` (**2**) · `+ml0-record-coverages+` (3) ·
`+ml0-effect-determinacies+` (3) · `+ml0-derivations+` (2) ·
`+ml0-scope-statuses+` (2) · `+ml0-promotion-legs+` (**9**) ·
`+ml0-source-validations+` (**4**) · `+ml0-observation-doors+` (5) ·
`+ml0-occurred-proposition+` (the pinned proposition, verbatim)

### Constants and harness

`+ml0-id-domain+` · `+ml0-lane-stem+` · `+ml0-runtime-process-name+` ·
`+ml0-store-nonce+` · `+ml0-rendering-version+` · `+ml0-env-class-i+` ·
`+ml0-env-class-ii+` · `+ml0-env-class-iii-declared-out-of-stack+` ·
`*ml0-run-root*` · `*ml0-account-store*` · `*ml0-checks-passed*` ·
`*ml0-checks-failed*` · `ml0-check` · `ml0-note` · `ml0-env-preflight` ·
`build-ml0-account-store`

### The typed refusals

`ml0-condition` (root) → `ml0-source-species-refused` ·
`ml0-subject-identity-mismatch` · `ml0-provenance-incomplete` ·
`ml0-scope-undeclared` · `ml0-standing-vocabulary-refused` ·
`ml0-account-encoding-refused` · `ml0-account-readback-refused` ·
`ml0-consolidation-refused` · `ml0-bridge-contract-violated` · `ml0-run-void`.
Readers: `ml0-condition-detail` · `ml0-condition-requirement-id`.

---

## 7. What a next chair should know before touching it

- **The lane appends to its OWN store only.** It never writes an act journal, a
  world, or anything belonging to a consumed lane. If you give it a store that is
  also an act journal, nothing stops you, and the D1 byte-comparison stops being
  a comparison of different files.
- **⚠ THERE ARE NO `:defect` PARAMETERS ANY MORE, AND PUTTING ONE BACK WOULD
  REOPEN THE BLOCKER (R4).** This bullet used to say the opposite — *"planted
  seams, production NIL; do not remove them to clean up"* — and that instruction
  was the hole. `defect` was a live `&key` on **ten exported production
  functions**, defended by a docstring, and a cross-family adversarial reader
  flipped the crown predicate through the front door with one keyword. The six
  defects now live in `ml0-mutant-overlay.lisp`, which `load.lisp` never loads;
  each installs itself by **redefining** a production function with a wrapper that
  **delegates** to the saved production definition. If you add a mutant, add it
  there. **Never widen a production arglist for a test.**
- **Leg 8 (attestation) is the one to be careful about** if you add a species. A
  species that reads admitted bytes and finds nothing must attest
  `:no-record-for-this-identity` or `:inconclusive` — never a crossing. The
  builders derive it from what they read; a builder that took it from its
  argument list would make the whole suite a tautology.
- **The issuance axis has no negative member and this was a correction, not an
  oversight.** See SPEC §6.
- **The only warrant-bearing channel into a bundle is `:observations`** (with
  `:issuance-observation`). `:sources` and `:testimony` normalize everything to
  non-warranting testimony. If you add a channel, ask first who can reach it.
- **A freely callable decoder must never produce a promotion-capable row.** This
  was blocked twice, in two different disguises: first `make-ml0-source`, then
  `ml0-source-from-record`. The class is *truth-minting migrates* — when you close
  a path, ask where it moved to, and look one remove further out than where you
  just looked.
- **A door reads the substrate it is GIVEN, and the subject carrier is DECLARED.**
  Nothing here authenticates either. `capability-disciplined, never
  capability-secure` was true in R1, in R2, and is true now.
- **A STANDING IN THE BYTES IS NOT A STANDING YOU MAY READ (R4).** R3 declared the
  raw decoder *"explicitly inert"* in prose while it still installed the
  `occurrence-standing` field verbatim. The rows were inert; the standings were
  not. `ml0-account-standing-authority` is how a reader tells; if you add a route
  that produces an account, it must set that field honestly, and a route that did
  not validate a frame chain must re-derive.
- **A CHECK THAT CANNOT RUN IS NOT A CHECK THAT PASSED (R4).** `RB-11` used to run
  only `(when carried …)`, so an unrecognized frame reached the authoritative type
  with the identity check never made. That is the lab's absence-warrant class in
  this lane's own code: *no disagreement found* is not *nothing was compared*.
- **A GREEN GATE IS NOT A WARRANT FOR THE CHECK BEHIND IT (R4.1).** When
  `ml0-consolidate` became a struct, `ml0-red-proof`'s `crown-tooth` kept its
  middle conjunct `(not (eq :occurred consolidated-occurrence))` while the call
  site now handed it a **carrier**. The conjunct compared a keyword against a
  struct, **could not be false**, and the gate went on exiting 0 and printing *the
  tooth bites* with one third of the lane's crown dead. **No exit code could see
  it**; it was found by diffing a preserved transcript against a live one
  (`after CONSOLIDATION : :UNRESOLVED` had become
  `after CONSOLIDATION : #S(ML0-CONSOLIDATION`). Same class as R4's `RB-11` bullet
  above, one substrate further out: *a gate never seen to fire is untested, not
  passing.* When you change a return type, **read what every gate PRINTS**, not
  only what it exits.
- **THE DURABLE ROUTE TO A DERIVED ACCOUNT IS THE CARRIER (R4.1; wording R4.1c).**
  `ml0-consolidate` returns an `ml0-consolidation`; `ml0-materialize-consolidation`
  is the lane's route from a carrier to durable bytes, and it treats the carrier as
  an **untrusted request** (re-retrieve, recompute, compare by canonical-body
  SHA-256 digest); `ml0-write` no longer takes `:derivation` or
  `:predecessors`. If you find yourself wanting to hand a lineage to `ml0-write`
  as an ordinary argument, that is the hole this round closed — **truth-minting
  migrates**, and the arglist is where it lands.
- **ONE DERIVED ACCOUNT HAS ONE SUBJECT (`ML0-CON-4`, R4.1).** Consolidation
  refuses inputs that share an act but not a seat / attempt / **subject
  principal**, rather than taking whichever input sorted first. SPEC §5:
  `subject-principal` is *"whose act it is ABOUT"* — the actor, never the process
  doing the recording. The recorder's own identity has a field of its own
  (`recording-process` in the envelope, `recorder-principal` in the body).
- **THE FIRST NON-CLAUDE EYE FOUND THE BLOCKER (R4).** Three same-family rounds and
  two chair dispositions read this lane and did not see the `defect` seam; a
  cross-family worker found it in one pass. Whatever you do next, get an outside
  on it.
- **AN INTERNAL CONSTRUCTOR IS NOT A BOUNDARY (R4.1b).** Four rounds of this
  lane's argument rested on `(:constructor %make-X)` meaning *"a caller cannot
  assert one of these."* It never meant that: `#S` builds any exported structure
  from a literal, every slot chosen, and it built `ML0-ACCOUNT` with
  `:standing-authority :validated-retrieval` and `ML0-SOURCE` with
  `:validation-standing :validated-by-door` from outside the package. Declare
  every new lane struct **BOA** (`(:constructor %make-X (&key …))`); check `[029]`
  enumerates every structure class automatically and is the coverage gate — `[028]`
  is only the five-type sample, and adding names to it protects nothing (R4.1c
  correction). **A `:read-only t` slot is not
  a frozen list, either** — the readers that make an object inspectable are the
  readers that make its innards reachable. The cure that survived was not a deeper
  freeze: it was to **stop believing the object and re-read the store**. Candidate
  arc law, stated as a candidate: *the reader is a constructor, a data object is a
  mutable claim, and the store is the only witness.*
- **A CHECK WHOSE TWO SIDES SHARE ONE FUNCTION CAN AGREE ON A LIE (R5).** The
  pre-append dry decode compares the identity the write minted against the identity
  its own decoder re-derives — **through the same mint**. The control seam that
  plants a wrong identity therefore had to be made **ONE-SHOT** (armed before one
  write, consumed by that write, honest afterwards): an always-on seam lies to both
  sides, the two sides agree, and **neither half of the tooth catches** — which is
  what happened on the first draft of TOOTH 13, before the seam was narrowed. The
  production code was never wrong; the *instrument* was about to certify a check it
  could not make. When you add a tooth to a self-comparing check, ask which side of
  the comparison your seam touches, and **make it fire once**. *A gate never seen to
  fire is untested, not passing* — this guide's own rule, met from a new direction.
- **What is built is a query, never a memory line.** The counts in this guide
  were true when it was written; run the gates.

---

*— TABULARIUS (Claude Opus 5, subagent), 2026-08-20; §2, §3, §5, §6, §7 rewritten
by TABULARIUS-II in repair round R3, same day, and §2 walked (`GUIDE-WALK.txt`);
§2, §4, §5, §6, §7 amended by OBTURATOR in repair round R4, same day, and §2
walked again in a fresh process. §1, §4, §5, §6, §7 amended by SCRIBA in round R4.1,
2026-08-21 (Claude Opus 5, 1M context) — the counts corrected against a loaded
image, the consolidation carrier documented, and **§2 re-walked in a fresh process
because this document changed** (`GUIDE-WALK.txt`, R4.1 capture): the recipe body
itself was **not** edited — it never touched consolidation — and the re-walk is
this guide keeping its own rule that a procedure is audited by simulation, not by
inspection. CANDIDATE.*

*§4, §5, §6, §7 amended by SCRIBA-II in round R4.1b, 2026-08-21 (Claude Opus 5, 1M
context), after SCRUTATOR's cross-family review — the `ML0-MAT-2/3/4` refusal rows
and the `#S` reader-error row, the consolidation-proof's check count (**34 at that
execution; 35 as shipped**), the carrier's *inspectable, not trusted* paragraph,
and the internal-constructor bullet. **§2 re-walked in a fresh process because this
document changed again** (`GUIDE-WALK.txt`, R4.1b capture); the recipe body is
byte-identical to R4.1's and to R4's. CANDIDATE.*

*§4, §6 and §7 amended by SCRIBA-III in round **R4.1c** (release correction),
2026-08-21 (Claude Opus 5, 1M context), at Sol's direction and with **no production-logic or durable-semantics change; Lisp source received prose/reporting-only edits at chair closeout (SCRIBA-III's bounded subpass itself was documents-only)**: the shipped proof state synchronized to **35 checks** (§8 of
the proof is **eight** checks, `[028]`–`[035]`, observed in a fresh run), the
construction-boundary prose narrowed (**construction privacy is defense in depth,
not the soundness boundary**), and **R4.1-F3 named as an OPEN governance item**.
**§2 re-walked again because this document changed again** (`GUIDE-WALK.txt`,
R4.1c capture); the recipe body is byte-identical to R4.1b's, R4.1's and R4's.
CANDIDATE.*

*§4 (the `ML0-WR-8` refusal row and the **what a failed write leaves** section), §5
(the controls count), §6/§8 prose touching `ML0-MAT-3`, and §7 (the self-comparing-check
bullet) amended by SCRIBA-IV (Claude Opus 5, 1M context) in round **R5**, 2026-08-21,
entering Sol's two dispositions. **§2 re-walked in a fresh process because this document
changed** (`GUIDE-WALK.txt`, R5 capture) — the §2 recipe body was **not** edited this
round, and the walk says so with the block's byte count and digest. CANDIDATE · NOT
REGISTERED · stranger audit OWED.*
