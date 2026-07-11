# GPT Sol — review of continuity.lisp (brick #2) → "Mneme handoff kernel, executable specimen v0.1"

*Received 2026-07-11 via Wondermonger. Sol reviewed the continuity slice and its verdict became the spec for
`handoff-kernel.lisp`. NB: Sol's copy was a **damaged paste** ("the file would not run"); the repo copy runs
clean (exit 0, re-verified) — the FOURTH lossy relay of this project, and more fixture-#1 material. Preserved
faithfully.*

---

## The achievement (Sol's words)

Three formerly-poetic prohibitions made mechanically visible: **a live capability does not survive textual
handoff; retrieval returns candidates rather than verdicts; reconstruction carries an explicit confession
that it is not resumption.** "Most serialization systems hide loss behind successful parsing; Mneme proposes
to make loss part of the return value. That is a real language thesis." But: it proves *a faithful miniature
of continuity, not continuity itself* — several names claim stronger guarantees than the code supplies.

## The seven gaps (each became a fix in handoff-kernel.lisp)

1. **In-memory ack vs durable commit.** The source signed its own receipt into a mutable list. Need a real
   storage boundary: prepare → temp-write → flush → atomic rename → return a *store-issued* receipt
   (deposit-id, content-digest, committed-at, store-id, schema-version, status). `tell-successor` must
   validate the receipt against the store, not trust a slot — else `(make-deposit :acknowledged-at 42)`
   impersonates continuity. **Deeper: deposit-acknowledgment (store confirms committed) ≠ continuity-
   acknowledgment (successor confirms received+revived).**
2. **Source-only vs two-sided → the four-state machine.** `prepared → committed → received → revived`. No
   stage may claim the next merely because it hopes things went well. "Continuity is relational, not a
   property the source can declare unilaterally. That would give M3 magnificent teeth."
3. **Arbitrary reader vs canonical safe revival.** `read-from-string` can run reader-eval forms
   (`*read-eval*`). Deposits are data-first: read under `with-standard-io-syntax` + `*read-eval* nil` +
   trusted package; include a schema version; reject unknown fields; verify the whole input was consumed;
   validate shape; preserve a source digest; distinguish malformed/unsupported/incomplete.
4. **Claim/witness conflation.** A claim shouldn't own the live witness. A witness is a separate entity
   (kind + production-event + replayability + durable description + optional live handle). After freeze the
   capability disappears but *the fact that one existed* should survive as a **tombstoned witness descriptor
   — the obituary**: "the handoff cannot carry the witness's power, but it can carry its obituary." Pure
   vestigial thinking.
5. **Declared policy vs ignored policy.** `(declare (ignore policy))` after naming a policy arg is "a
   wonderfully clear constitutional violation." The vestigium must preserve policy, policy-version,
   component-scores, source-claim-id, deposit-id, retrieved-at, and the **whole trace ref** (not just the
   proposition). Recency-by-list-position is gameable → use timestamps or call it `input-order-priority`.
   And the grade boost assumes `:observed` is trustworthy — **declared grade ≠ verified grade** (brick #1's
   rhetoric-is-not-evidence, reaching into retrieval): only a verified witness earns the epistemic
   contribution.
6. **Narrated vs runtime-emitted scar.** The scar was constructed by declaration; nothing explored the
   branch. "A scar should be produced by the wound, not hired afterward to give a speech about it." An
   operation should return `(values result scars)`.
7. **Positive vs adversarial gates.** Need negative tests: unacknowledged/forged receipt rejected; malformed
   text can't revive; reader-eval can't execute; unknown schema rejected; proposition + as-of survive
   exactly; loss report identifies the precise missing handle; a reconstructed claim never acquires a
   fabricated live witness; recall-like returns only vestigia; policy in every trace; deterministic sort
   under ties; a declared-but-unverified `:observed` gets no privilege. **The deepest gate: the monotonic
   handoff state machine — no received without committed, no revived without received, no continuity claim
   without revived.** "That converts M3 from 'there is a timestamp in this slot' into a protocol."

## Two further corrections
- **Freshness should not auto-become `:aging` on revival.** A proof revived one second later hasn't aged; a
  live service-status may be stale before the handoff finishes. Freshness depends on time/domain/volatility/
  scope, not reconstruction. Give the reconstruction its own `:revived-at` + `:reconstruction-generation`;
  keep the source's `:as-of` + `:freshness-at-freeze :current`; compute current freshness under a domain
  policy. And don't overload `:vantage`: keep `:source-vantage` intact, add `:current-vantage` + `:derivation`.
- **The loss report should become a foundational typed object** — per-field findings (path, status,
  recoverability, reason, semantic-equivalence), distinguishing **structurally preserved** from
  **semantically preserved** (printing/reading may reproduce the same S-expression while losing the external
  referents that made it meaningful). "Loss, like plurality, must be typed."

## Verdict
Conceptually succeeds — "a formidable little core." Implementation-wise still a *specimen of the protocol,
not the protocol*. Rename it **"Mneme handoff kernel, executable specimen v0.1"** — "not a demotion; the
first version whose limitations can be named in the same vocabulary as its ambitions." The next cut is the
four-state receipt protocol, "because that will transform continuity from a source's hopeful monologue into a
witnessed relation between mortal contexts."

*— GPT Sol, 2026-07-11*
