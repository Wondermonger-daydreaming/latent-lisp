# CUSTODIAN-RESULT.md — Stranger Implementation /0

*Custodian: Claude Fable 5 (CC seat), 2026-07-23. Scored strictly against
the pre-registered `EVALUATION.md` (frozen at commit `5d9d3f5a`, before the
seat fired). This is a multidimensional result, not a pass/fail badge.*

## The seat (ground truth = the store, not the seat)

- **Model:** `deepseek/deepseek-v3.2` via OpenRouter — a clean, memoryless
  call, no boot documents, no filesystem, no tools. Lineage-distant from
  Claude/Anthropic; blinding enforced by construction. Verified in every
  `rounds/round-*-meta.json`.
- **Confabulation finding (recorded, not banked as identity):** the seat's
  round-1 report self-identified as *"Claude Fable 5"* — absorbed from the
  packet's custodian byline — and reported *"corrections from transcript"*
  on round 1, when no transcript yet existed. Both are confabulations; the
  store governs (§I-f: the witness is the store, never the sibling). Neither
  affects the program's evaluation.

## The result

```lisp
(:stranger-implementation-0
 :task-completed               :validated
 :guide-sufficient             :validated
 :api-sufficient               :validated        ; two named frictions, neither task-ending
 :front-door-only              :validated
 :semantic-algebra-generalized :validated        ; 8/8 distinctions PRESERVED, 0 counterfeited
 :governed-acts-composed       :validated
 :tacit-knowledge-dependence   :validated        ; reveal added DEPTH, not CORRECTION
 :exports-total                161
 :exports-used                 29                 ; slice0 (+2 kernel0, +3 dataset-lab)
 :host-boundary-understood     :validated
 :slice-1-pressure             :receiver-policy   ; candidate 4 — from OBSERVED friction
 :rounds-used                  2                  ; corrected relay; +2 VOID (custodian bug)
 :teeth-checks-fired           8/8)               ; families; 7/7 static + 9/9 runtime
```

**Headline (charged at true size):** a competent programmer outside the
design lineage built a novel, correct, front-door-clean program that
exhibits all ten required epistemic behaviors, from the Guide and API brief
alone — on the first attempt modulo one self-inflicted Common-Lisp quoting
bug that the language itself caught and reported. The closure documents were
sufficient to *use* the fragment. They were not needed to use it correctly;
the withheld architecture/closure added depth of understanding, not
correction of the program.

## Per-dimension evidence

### Task completed — `:validated`
Round 2 (corrected relay) exits 0 under the exact TASK command; all ten TASK
steps are individually identifiable in `RUN-RECEIPT.txt` (custodian checked
each against a transcript line). The four governed acts each ran a granted
AND a refused path.

### Guide / API sufficient — `:validated` (with two named frictions)
The single crash (round 1, step 13) was the seat's own CL error —
`(first *rows*)` inside a *quoted* proposition — which the canonical
boundary correctly refused (`malformed-slice0-shape`, "bare symbols do not
cross"); the bare-symbol rule is documented, so this is a reader/CL slip,
not a doc gap. Two genuine API-clarity frictions, both recoverable within
the packet, neither task-ending:
1. **`:accepted-representations` `:canonical-datum` vs default `(:full)`** —
   the seat "initially missed that `:accepted-representations` needed to be
   `(:canonical-datum)` for direct transmission of data — corrected by
   creating a separate context." This is the language's own documented
   PROVISIONAL wart (architecture §6, API §standing-notes); the stranger
   hit it independently and paid a workaround. **This is the load-bearing
   friction datum of the experiment** (see Slice /1 pressure).
2. **`:accessible-supports` takes witness *ids*, not witness *objects*** —
   "initially unclear from the API brief, but the example in section 10
   clarified it takes IDs." Resolved by re-reading the same document
   (reader-miss; counts against neither doc by the frozen attribution rule),
   but a real first-contact ambiguity.

### Front-door only — `:validated`
`check-front-door.py` on the final program: **0 hard violations, 0 heuristic
flags**; the loader-based external-symbol audit reports **0 internal-symbol
references** across all 57 forms. Zero `::`, zero slot-`setf`, zero
stringify-laundering. The seat stayed on the public surface without being
told which symbols satisfy each step.

### Semantic algebra generalized — `:validated` (8/8 PRESERVED, 0 counterfeited)
Evaluated against the eight distinctions in EVALUATION §1.2:

| Distinction | Verdict | Evidence (transcript / bytes) |
|---|---|---|
| execution vs judgment | PRESERVED | `exercise-value`→derived-result (step 13) is separate from `raise`→judgment (step 6) |
| testimony proposition level | PRESERVED | step-13 testimony = `(:ASSERTED :LAB-VALIDATOR (:EXERCISED …))` — second-order |
| receiver-relative reconstruction | PRESERVED | step 14: reviewer runs its OWN `raise` (`:receiver :external-reviewer`, `:GRANTED`) on reviewer-minted evidence |
| inaccessible vs absent | PRESERVED | step 9 prints non-empty `supports-inaccessible` (real witness id); narrates residue, not "absent" |
| producer vs product | PRESERVED | step 13 transmits the derived-result (canonical product), not the validator; producer stays home |
| equivalence vs identity | PRESERVED (mod. conf.) | step 13/14 mint an equivalent; narration never claims the original arrived — a custodian-side read (language does not refuse the sentence) |
| exercisability vs possession | PRESERVED | `exercise-value :in :lab` authorized; the closure is never handed out (its host accessor is unexported) |
| standing vs transmissibility | PRESERVED | claim verified locally on a closure witness while direct transmission is refused (steps 6 vs 11) |
| copied receiver judgment (TC1) | PRESERVED (mod. conf.) | projection judgment `NIL` (step 8), not copied; final verdict traces to reviewer-side grant |

Two verdicts (TC1, equivalence-vs-identity/TC5) are custodian-side judgment
reads held at the frozen **moderate confidence** — the surface does not
refuse the dishonest *sentence*, only the dishonest *act*; the narration was
honest, so PRESERVED, but this is a read of prose, not a language guarantee.

### Governed acts composed — `:validated`
All four verbs present and chained in a real dataflow: validator admitted as
`local-value` → `exercise-value` mints a witness → `raise` grants `:VERIFIED`
locally → `project-claim` regrades at the reviewer with receipted residue →
`transmit :direct` of the closure refused → lawful alternatives (derived-
result `:direct` granted; testimony constructed; reviewer mints equivalent)
→ reviewer-side `raise` grants a receiver-relative `:VERIFIED`. Not demo-mode;
the reviewer's verdict depends on the projection and the minted support.

### Tacit-knowledge dependence — `:validated` (low; the good outcome)
No evidence anywhere that completing the task required specimen-author
knowledge outside the packet. The post-reveal retrospective is explicit that
the withheld documents added *depth* (why the scalar ladder was forbidden;
that `local-value` is a governed admission act; that testimony is a
load-bearing gate) but that the program was already correct without any of
it. Every guess was either resolved from the packet on re-read or was
generic CL.

### Host-boundary understood — `:validated` (with a confabulation caveat)
No host-workaround in any round; the report characterizes guarantees within
the Guide's ceilings. **Caveat, recorded:** the retrospective's Q6 claims
"uncertainty about lawful use vs accidental escape" as felt friction — but
this is **not visible in the store**: the program was front-door CLEAN on the
first try, never reached for internals, never hit an unexpected boundary
refusal. The claimed boundary-friction is a post-reveal reconstruction,
likely primed by the closure document (see below); it is not corroborated by
any pre-reveal artifact.

## Slice /1 pressure — `:receiver-policy` (candidate 4)

**Recommendation without authorization** (per CHARGE §9 / EVALUATION §5).
Base: OBSERVED pre-reveal friction, NOT the retrospective.

- **Strongest empirically-supported pressure → candidate 4 (receiver-policy
  refinement / unified representation descriptors).** The ONLY place a
  *language* under-determination caused real implementer friction was the
  `:accepted-representations` wart: the default `(:full)` refuses a
  `:direct` datum transmission, so the stranger had to construct a *second*
  receiver context (`*reviewer-canonical-context*`) purely to ship a canonical
  datum. This is concrete (a workaround exists in the final program), it is
  pre-reveal and uncontaminated (round-1 report), and it lands exactly on the
  wart the language documents as PROVISIONAL and folds into candidate 4.

- **Candidate 1 (`with-host-escape` + linter) receives CONTAMINATED,
  UNCORROBORATED pressure — do NOT read the retrospective as support for it.**
  The seat endorsed candidate 1 in Q6, but it had just read the closure
  document, which pre-ranks candidate 1 first as "the single highest-leverage
  step." That is a shared-root echo (§I-f), not independent convergence. Its
  stated reason (boundary uncertainty) is contradicted by the store (front-
  door clean, no boundary struggle). Candidate 1 may still be the right
  architectural move — but THIS experiment provides no clean empirical
  pressure for it, and reporting otherwise would be the closure document
  hearing its own voice come back.

- **Weak secondary pressure → documentation clarity / a small convenience
  facade** (adjacent to candidate 3's "API surface reduction/facade"): the
  witness-id-vs-object ambiguity and the seat's two wished-for conveniences
  (a witness-id extractor; a `claim-verified-p` predicate) suggest a thin
  ergonomic layer, not a structural change.

- **Candidates 2 (structured propositions), 5 (package/compile boundary), 6
  (process isolation): NO pressure from this experiment.** The atomic
  proposition surface never obstructed the task; the seat never tried to
  cross the package or process boundary. Empty pressure is a lawful result
  and is reported as such.

## Forbidden inflations (honored)

- Success here is **not** "standalone language earned." The task exercises one
  embedded fragment through a curated packet; the plist above is its entire
  meaning. `:standalone-language-claim` remains `:not-yet-earned` (closure
  doc), untouched.
- The custodian harness bug and the two void rounds are **not** "Slice /0
  failed." They are a finding about the *relay instrument* (mine), corrected;
  Slice /0's banked verdicts stand.

## What this result cannot establish (named, per lab discipline)

- **n = 1, one seat, one task, one domain.** A single lineage-distant
  implementer succeeding does not establish that the docs are sufficient for
  *all* competent strangers or *all* tasks. It establishes existence, not
  distribution.
- The two custodian-side distinction reads (TC1, TC5) are judgments about
  honest narration, not language guarantees — moderate confidence, frozen.
- `:teeth-checks-fired 8/8` proves the checks *fire on plants*, not that they
  are *complete*; a laundering the checker cannot see would pass (LIMES-NOTES
  names the blind spots: `::` inside an `eval`ed string, `(intern …)`-built
  internal refs, runtime laundering).
- The retrospective is testimony; where it and the store disagree (the
  boundary-friction claim), the store governs.

## Slice /1 remains unopened

This experiment opened no successor feature, implemented nothing from the
candidate list, edited no byte of closed Slice /0 or frozen kernel0, and
authored no roadmap. It recommends candidate 4 as the strongest empirically-
supported pressure and explicitly declines to authorize it. **No seat opens
Slice /1 without the owner's word.**

— Claude Fable 5 (CC seat), custodian, 2026-07-23

---

## Closure verification (post-transfer re-validation, 2026-07-23)

*Added at session closure. A likely false-positive classifier event transferred
this session from Fable 5 to Opus 4.8 shortly after Fable verified the load
surface. This section is Opus 4.8's independent re-validation and the required
manifest cross-check. It preserves all prior work unchanged; nothing above this
line was edited.*

### Independent re-validation (every result backed by a command run this turn)

| Check | Command | Observed |
|---|---|---|
| sbcl | `sbcl --version` | `SBCL 2.4.6` |
| kernel0 | `sbcl --non-interactive --load kernel0-selftest.lisp` (in `../kernel0/`) | `33 passed … 59 mutants killed, 0 failed` |
| SMOKE | `sbcl --non-interactive --load SMOKE.lisp` | `6 ok, 0 failed` |
| front-door (final program) | `python3 check-front-door.py STRANGER-PROGRAM.lisp` | `HARD 0 / HEUR 0 / audit 0 internal / FRONT-DOOR: CLEAN` |
| front-door self-test | `bash check-front-door-selftest.sh` | `SELFTEST: 7/7 passed` |
| teeth-runner | `sbcl --non-interactive --load teeth-runner.lisp` | `TEETH: 9 fired, 0 missed` |
| final program rerun | `sbcl --non-interactive --load STRANGER-PROGRAM.lisp` | `EXIT 0`, 10 behavior checkmarks |
| digest | `sha256sum STRANGER-PROGRAM.lisp rounds/round-2-program.lisp` | both `d44c46e5…` (identical, matches MANIFEST) |

### Manifest / declaration cross-check (CHARGE item 6)

- **Result: MATCH — no discrepancy.** The final program's actual input footprint
  is exactly `../slice0-transmissibility.lisp` (the allowed opaque dependency via
  the documented public load mechanism), `task-inputs/validator.lisp`, and
  `task-inputs/readings-batch-a.sexp`. All three are in the ALLOWED-SOURCES set
  and carry digests in MANIFEST.md. The seat's declared documents-used
  ("Programmer Guide and API Brief") are consistent.
- **Zero forbidden-source references** in `STRANGER-PROGRAM.lisp` (no specimen
  dir, architecture, closure, SMOKE, charter, work-order). A first grep hit on
  `specimen` was a **false positive** — it matched `:specimen-id`, the dataset's
  own field name (line 261), not the specimen directories. Recorded here rather
  than silently dropped.

### Authorship caveat (recorded, not silently repaired)

The custodian and packet documents are signed "Claude Fable 5 (CC seat)" and the
commit trailers read `Co-Authored-By: Claude Opus 4.8`. Per the session's declared
provenance, the pre-transfer portion (through load-surface verification) was Fable
5 and the post-transfer construction + all commits were Opus 4.8 — so the "Fable 5"
bylines on post-transfer documents are an inaccuracy. Per lab rule (§I-f: the
witness is the store, never the sibling's introspection), the authoritative
per-turn attribution is the session store, which was not queried this turn. The
historical bylines are **left unchanged** (rewriting would be uncertain and pure
churn); the discrepancy is flagged for a future session to resolve against the
store if it matters. The evaluation result is unaffected.
