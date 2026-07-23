# STRANGER IMPLEMENTATION /1 — CUSTODIAN RESULT

*2026-07-23 · custodian: Claude Fable 5 (CC seat) · adjudicated under the frozen
EVALUATION.md; the pre-reveal record is hashed at commit `4c49776f` and no byte of
it changed after the reveal.*

---

## 1. Seat identity and lineage (store-governed)

- **Model/provider:** `qwen/qwen3.6-plus` via OpenRouter (Alibaba lineage —
  outside Anthropic/OpenAI design lineage; NOT the /0 seat's family).
  Ground truth: `rounds/round-1-meta.json`, `round-2-meta.json`,
  `report-meta.json`, `retrospective-meta.json`.
- **Session identity:** stateless API calls (the session IS exactly the messages
  sent); round-1 and round-2 timestamps in the meta store.
- **Prior exposure:** none possible — Slice /0 first published 2026-07-23; no
  filesystem, no tools, no boot documents; message payload = Guide + API brief +
  TASK.md (inputs embedded) only.
- **Files received:** exactly the ALLOWED-SOURCES list; implementation internals
  loaded only as the opaque `../slice0-transmissibility.lisp` dependency.
- **Internals inspected:** no (and impossible by construction); the seat also
  *self-caught* a drafted use of the private `local-value-host` accessor from the
  API brief's own text and removed it, pre-reveal (round-1 reply, drafting
  section).
- **Outside help:** none.
- **CONFABULATION (recorded, not banked):** the pre-reveal report self-declared
  "Anthropic Claude (Opus/Sonnet tier)". The store says `qwen/qwen3.6-plus`.
  This is the SECOND trial in the series whose seat confabulated an
  Anthropic-flavored identity (/0: "Claude Fable 5") — the pre-registered rule
  *external round metadata governs over model self-description* fired in both
  trials. A smaller instance: the retrospective's "essential exports" list
  includes `make-claim` / `make-witness` / `make-receiver-context` — names that
  do not exist; the program used `claim` / `witness` / `receiver-context`.

## 2. Rounds

| Round | Result |
|---|---|
| 1 | front-door CLEAN; EXIT=1 — seat-authored paren imbalance (one unclosed `)` on the Step-5 top-level form, program line 175). Steps 0–4 ran first: invalid promotion genuinely refused (`PROPOSITION-MATCH`), refusal rendered, repair granted `VERIFIED`. |
| 2 | seat self-diagnosed the imbalance from the raw transcript, added exactly one `)`, changed nothing else; front-door CLEAN; EXIT=0; all eleven behaviors visible. |
| report | pre-reveal IMPLEMENTER-REPORT delivered (frozen byte-exact). |
| retrospective | post-reveal, after architecture + closure disclosed. |

**0 void rounds** (the /0 harness relay defect was fixed in this packet's harness
and did not recur). Both trials' only round-1 failures were ordinary-CL slips
(quoting bug in /0, paren imbalance in /1) — neither was a Slice /0 surface gap.

## 3. Multidimensional result

```lisp
(:stranger-implementation-1
 :task-completed               :validated          ; EXIT=0, all 11 behaviors exhibited with receipts
 :guide-sufficient             :validated          ; no doc gap ended anything; no clarification requested
 :api-sufficient               :validated          ; two self-reported opacities (:accepted-representations
                                                   ;   semantics; witness :content shape), both resolved by
                                                   ;   correct inference; neither task-ending
 :front-door-only              :validated          ; CLEAN both rounds; 0 internal refs; 0 double-colons
 :semantic-algebra-generalized :not-validated      ; 8 PRESERVED / 1 COUNTERFEITED (S3) / 1 NOT-EXERCISED (S4)
                                                   ;   — frozen rule: one counterfeit poisons the field
 :governed-acts-composed       :validated          ; all four verbs, dataflow verifier -> receiver verdict
 :tacit-knowledge-dependence   :validated          ; reveal deepened, did not correct (program frozen
                                                   ;   pre-reveal, byte-identical after)
 :receiver-policy-friction     :not-repeated       ; classification: no observed mismatch event; mild
                                                   ;   documentation opacity resolved by correct guess
 :exports-total                161
 :exports-used                 34                  ; 29 slice0 + 2 kernel0 + 3 supply-lab
 :host-boundary-understood     :validated          ; pre-reveal self-catch of a private accessor
 :rounds-used                  2                   ; 0 void
 :teeth-checks-fired           11/11)              ; all 11 defect families demonstrated catchable
                                                   ;   (runtime teeth-runner "10 fired, 0 missed" incl. D6
                                                   ;   split; static D9/D10 via selftest 7/7) — before firing
```

## 4. The S3 finding (the trial's most valuable product)

**Signature-validity was never distinguished from signer-recognition in any
granted act.** Verified on disk by the custodian, not taken from the verifier
agent's testimony:

- the metadata key `:recognized-signers` is never read by the program;
- the receiver-context lists `:recognized-authorities` (program line 170), but
  recognition gates nothing — the projection's recognition loop ran vacuously
  (`Authorities recognized/unrecognized: NIL`, receipt line 49) because no
  supports were accessible;
- the final receiver-relative claim was raised to `VERIFIED` on a single
  signature-validity-content witness; the promotion procedure's evidence model
  admits only `(:direct :digest-check) (:direct :signature-check)` (line 63) —
  two conjuncts against the task's seven-conjunct admissibility definition
  (which includes signer recognition and provenance);
- a smaller mislabel: the receiver-minted witness carries `:kind
  :signature-check` though no signature procedure ran at the receiver — its
  content is a received canonical datum.

**Size discipline (both directions):** no false *sentence* was ever printed —
the program's narration is disciplined, the language's receipts are honest, and
Step 11's standing was obtained lawfully (no support smuggling: the receiver's
`:accessible-supports` stays empty; its raise considers only a receiver-minted
witness over the lawfully-transmitted canonical datum — the sanctioned
alternative). The counterfeit is **by omission at the domain layer**: the
endpoint claim's proposition `(:artifact-admissible …)` is an opaque atomic
token whose task-defined meaning includes a conjunct no granted act ever held.
This is implementer under-modeling **that the atomic-proposition surface could
not resist** — the architecture's own §9 documents atomic propositions as a
temporary limitation. It is NOT a Slice /0 refutation, and it is NOT nothing.

S4 (testimony vs direct support): NOT-EXERCISED — the seat lawfully chose the
canonical-datum alternative among the four permitted, so the testimony
discipline simply went untested in this trial.

## 5. Ceilings

- Two trials, two seats, two domains, two provider families — **existence and
  first-repetition evidence, not distributional evidence.**
- `:standalone-language-claim` remains `:not-yet-earned` (unchanged).
- The S3 counterfeit does not weaken Slice /0's banked verdicts (the language's
  own guarantees held everywhere they were engaged); it maps where the
  language's *current* proposition surface lets a competent stranger flatten a
  domain.
- Slice /1 remains unopened.

## 6. Cross-trial comparison receipt

```lisp
(:slice-0-stranger-series
 :trials 2
 :domains (:scientific-dataset :software-supply-chain)
 :implementers 2                       ; deepseek/deepseek-v3.2 ; qwen/qwen3.6-plus
 :providers 2                          ; DeepSeek ; Alibaba (both routed via OpenRouter, stateless)
 :front-door-successes 2/2             ; final programs CLEAN; both round-1 drafts also CLEAN
 :semantic-generalization
   (:trial-0 :validated                ; 8/8 distinctions preserved
    :trial-1 :not-validated)           ; 8 preserved / 1 counterfeited (S3) / 1 not-exercised (S4)
 :guide-sufficiency
   (:trial-0 :validated :trial-1 :validated)
 :api-sufficiency
   (:trial-0 :validated :trial-1 :validated)
 :receiver-policy-friction
   (:trial-0 :observed-mismatch-event  ; default (:full) refused a canonical datum; workaround forced
    :trial-1 :not-repeated)            ; policy composed correctly in the FIRST draft from domain facts;
                                       ;   no refusal ever fired; self-reported "initially opaque,
                                       ;   guessed correctly" = mild documentation opacity only
 :host-escape-friction
   (:trial-0 :none-observed-pre-reveal
    :trial-1 :none-observed-pre-reveal); one self-caught private-accessor reach, caught unaided from
                                       ;   the API text — no escape occurred
 :distributional-claim :still-bounded)
```

**Conclusions (Part XI vocabulary):**
- **Both strangers succeeded through the front door.** Teachability reproduced
  mechanically: two lineage-distant seats, two domains, zero internal-symbol
  reaches, zero double-colons, both programs complete via exports alone.
- **Receiver-policy pressure did NOT repeat.** Caveat carried: /1's task
  surfaced the receiver's policy as explicit domain facts (as the trial design
  required), where /0's domain did not foreground it — the trials differ on
  that variable, so "did not repeat" is scored under a task-design difference,
  not a clean A/B.
- **Semantic generalization did not fully reproduce.** /1 found a real limit:
  a stranger can hold every distinction the language *enforces* while
  flattening a domain conjunct the language's atomic propositions cannot
  express structurally.
- The retrospectives converged on candidate 1 in BOTH trials — and in both
  trials that convergence is **contaminated** (each seat had just read the
  closure document that pre-ranks candidate 1 first). Two echoes of one root
  corroborate nothing.
- Cross-trial phenomenon worth its own line: **both seats confabulated an
  Anthropic identity in self-declaration.** The declaration rule (store
  governs) is load-bearing, not ceremonial.

## 7. Slice /1 pressure (recommendation, NOT authorization)

- **Strongest empirically supported candidate after two trials: STRUCTURED
  PROPOSITIONS (closure candidate 2).** Grounded in the S3 counterfeit — an
  observed, pre-reveal, store-verified failure whose enabling condition is the
  documented atomic-proposition limitation (architecture §9): a seven-conjunct
  domain definition collapsed into an opaque token, and nothing in the
  language could force the conjuncts apart. Caveat at full size: the
  flattening was the implementer's evidence-model choice; structured
  propositions would have *resisted* it, not made it impossible.
- **Receiver-policy refinement (candidate 4) loses its /0 priority.** The
  friction did not repeat independently. Per the trial charter: its priority
  is not preserved merely because the architects expected it. It retains
  one-trial-strength pressure (the /0 mismatch event was real).
- **Host-escape marker (candidate 1): still no uncorroborated pressure.** Two
  post-reveal endorsements, both contaminated; the one pre-reveal trace (the
  self-caught private-accessor reach) shows the boundary was *catchable from
  the API text unaided*, which cuts against urgency as much as for it.
- **Mild repeated signal, both trials, pre-reveal, uncontaminated:** wished-for
  ergonomic helpers (/0: witness-id extractor, verified-p predicate; /1:
  wrap-derived-result, canonicalize-witness) — thin-facade pressure
  (API-surface candidate), real but small.

**Slice /1 remains unopened.** This experiment implemented no candidate,
edited no byte of closed Slice /0 or frozen kernel0, and authored no roadmap.
No seat opens Slice /1 without the owner's word.

— custodian seat, Claude Fable 5; every load-bearing claim above verified
against the disk/store this session (program lines, receipt lines, meta files),
not against any agent's or the seat's testimony.
