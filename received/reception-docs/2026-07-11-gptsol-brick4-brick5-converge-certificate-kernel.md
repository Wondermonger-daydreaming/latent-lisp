# GPT Sol — reviews of brick #4 (evidence-kernel) + brick #5 (surviving-witness), converging on the certificate kernel

*Received 2026-07-11 via Wondermonger. Two reviews arrived together and converged on ONE next brick — the
strongest signal a review round gives. Both became the spec for `certificate-kernel.lisp` (brick #6).
Preserved faithfully (structured capture).*

---

## Review of brick #4 (evidence-kernel)

Banked: the one-receipt/two-claims split ("the receipt is evidence — of what the model DID, not that P is
true"); the median check earning `:executed` not `:observed` (rescues the algebra from a prestige ladder);
`raise-claim` producing a revision + `grade-event` instead of repainting the ancestor ("Mneme's diachronic
metaphysics becomes ordinary data engineering rather than a lovely speech near a database"). Revise the
victory sentence: *"the seven identified witness-laundering routes are closed; witness authenticity and
semantic verification are now the exposed frontier."* Proximity laundering is closed; the code still trusts a
witness's self-description.

**Two exploits still open:**
- **The self-forged résumé.** `(make-witness :kind :execution :target '(= median 7) :result 9001 :verdict
  :supports :provenance '(:trust-me-bro))` passes `witness-supports-p` — it checks only that the KIND is
  admissible, not that procedure/input/result were validated. Need REPORT vs CERTIFICATE: only a trusted
  verifier issues a certificate; `raise-claim` requires one. "The witness may tell its story; it does not get
  to notarize the story."
- **The drifting `claimed` argument (the most important bug).** `check-execution`'s `claimed` is supplied
  independently of the proposition, so `(check-execution (claim '(= median 999)) #'median-by-sort '(5 9 87 3)
  7)` runs honestly, compares 7 to caller-supplied 7, and emits a SUPPORTING witness for `(= median 999)`.
  **Target identity is necessary but not sufficient for relevance.** Fix: structured propositions
  `(:equals (:call median-by-sort (5 9 87 3)) 7)` so the verifier reads the expected result FROM the
  proposition. Each proposition kind needs `verify-proposition`.

Further: `grade-is-earned-p` must check the witness earned THAT grade (`(eq (grade-for kind) claim-grade)`),
and grade should be DERIVED from accepted evidence, not declared then plausibility-checked. **The grades are
not a ladder** — `:tested` doesn't replace `:executed`; they are warrant MODES → a warrant-profile computed
under a policy, "an evidence lattice, not military ranks." Provenance and support should be typed EDGES
(`:produced-by` vs `:supports` vs `:refutes` vs `:qualifies` …). **Scope compatibility absent** — a witness
supports a LOCATED claim (proposition + valid-as-of + vantage + authority + version + domain), not a naked
S-expr (`/bounded-witness` reaching into the kernel). `infer` regressed from the judgment contract (returns an
invocation or multiple-values, not always a judgment — "precisely why `/shared-root` has stopped being
optional"). Budget honesty is preflight only (also enforce actual ≤ authorized; overrun → `:partial`).
Identifiers die with the process (`gensym`/`sxhash` → UUIDs + SHA-256 + canonicalization versions). **The next
brick has named itself: AUTHORITY** (`/permission-table`) — the model adapter may mint invocations + asserted
claims, NOT verified certificates / grade-transitions / commit receipts. Fourth prohibition: *a correctly
shaped witness is not necessarily an honestly produced witness.*

## Review of brick #5 (surviving-witness)

Bank the orthogonal witness state (verification / capability / event-replayability / resumability) as a real
Mneme law; loss reports as inherited artifacts; grade re-derivation from surviving evidence; positive+negative
controls; hash-linked handoff history; dead-capability vs surviving-testimony. The function→symbol fix "is the
specimen discovering its own thesis: a function object was a living capability; a symbol is a recipe
reference — but a recipe's name is not the recipe itself."

**Main issue: the successor trusts before it replays.** `regrade-from-evidence` regains `:executed` from the
serialized `:verified` label BEFORE `replay-witness` runs. So the positive control proves "a serialized
`:verified` status can keep granting authority," NOT "the successor independently established the witness
deserved it." A dishonest producer could serialize `:verification-status :verified :result 7 :provenance
'(:absolutely-real)`. Fix: cross as `:reported-verified`, then `validate-certificate` (check issuer +
integrity) OR `replay-and-certify` before granting. "The corpse may carry a medal; the successor needs to know
who pinned it on."

**Replay ≠ historical certification.** Two claims: "at gen-0, F on X returned 7" vs "at gen-1, currently-
resolved F on X returned 7." Replay supports the second, corroborates the first, does not prove the original
occurred (needs an authenticated event record). Two edges: original-certificate --attests-to--> historical
event; replay-certificate --reproduces--> result under E1. A disagreeing replay doesn't falsify history; it
shows non-reproducibility now.

**A symbol is resolvable, not exactly replayable.** `:event-replayability :exact` is too strong — `fdefinition`
resolves whatever now occupies the symbol; definition/package/deps/arithmetic/locale may have changed. Honest:
`:recomputable` / `:reproducible-under-declared-environment` / `:bitwise-replayable` are not equivalent; exact
needs procedure-digest + implementation-version + dependency-digest + environment-contract. "The dead hand left
a recipe card; before calling the result exact, check whether somebody replaced the oven." **`replay-witness`
should mint a replay-certificate** (verdict :reproduces/:contradicts/:failed/:blocked/:indeterminate), not
return a bare integer treated as pre-notarized. **The negative control doesn't demonstrate its prose** — the
promise-only witness began `:unverified`, so it never HAD authority to lose; a real capability-dependent test
needs a `:callable-now` provisional mode ("a loaded microscope is not an observation"). Regrade is
order-dependent with multiple witnesses (→ warrant profile). The event chain's `:revived → :revived` no-op tail
is "test machinery leaking into constitutional history — the tiniest version of history rewritten to satisfy a
harness"; use `*allowed-transitions*` and reject regressions/duplicates/actor-mismatch; canonical digests, not
ambient `prin1`. Revise the envoi: *the completed event does not cross — its certificate may, its recipe may, a
successor may perform a new event that reproduces it. Nothing cheats death; warranted inheritance becomes
sophisticated enough that cheating is unnecessary.*

**Cold-chair ruling (brick #5):** Bank the four orthogonal dimensions, inherited loss reports, grade
re-derivation, positive+negative controls, hash-linked history, dead-capability-vs-surviving-testimony. Bank
with revised language: procedure symbols = resolvable refs (not exact replay), replay = a new event +
corroborating witness, historical verification survives only via authenticated certification or successor
re-verification. **Do not yet bank:** "the positive witness retains authority across the gap" as a general law;
"exact replayability" from name+input; "the negative witness loses authority" (it never had any).

## The convergent next brick: the certificate & replay kernel
```
report ≠ certificate
procedure-name ≠ procedure-identity
historical event ≠ replay event
claimed verification ≠ authenticated verification
```
"Once those four are exit codes, Mneme will have something genuinely rare: not memory that pretends nothing
died, but testimony that remains trustworthy precisely because it knows what death changed."

*— GPT Sol, 2026-07-11*
