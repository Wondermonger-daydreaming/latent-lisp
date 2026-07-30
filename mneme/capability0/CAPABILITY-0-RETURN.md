# CAPABILITY-0-RETURN — the deliverable

Lane: **Capability /0** (`mneme/capability0/`, package
`#:lisp-plus-capability0`). Status: **candidate**. Builder: CLAVIGER
(Claude Fable 5 subagent), 2026-07-29. Substrate: Journal /0 (itself a
candidate — not audited, not adopted, not frozen; PJ0 §32.5 FULL NOT
CLAIMED) through its public exports; Kernel /0's exported conditions; SBCL
2.4.6, Linux host.

> History may prove that authority once existed; only the validated present
> prefix can say whether it remains live.

---

## 1. What is demonstrated (every item executable; transcript references)

The authority lifecycle, inhabited end to end
(`de-potestate-revocata/RUN-SPECIMEN.txt`, 24 checks / 0 failures, two runs
byte-identical):

explicit bootstrap authority → capability grant event (durable Journal /0
commit, ordinal 1) → live-authority query at prefix P → truthful
authorization receipt **bound to P** (store-id · terminal ordinal · valid
byte count · terminal digest) → receipt bytes preserved to disk → unrelated
committed event at P+1 (**still :authorized**; the P-receipt already
detectably not-current) → explicit revocation committed at P+2 → governed
refusal (`capability-revoked`, naming grant g-001 AND revoking event r-001)
→ **process restart** (the first life exited; a genuinely new `sbcl
--script` process consulting only durable bytes + declared configuration —
enforced by construction and stage-source inspection, not by a sandbox;
see the specimen's Honest limits)
→ **identical refusal reconstructed** (origin `:reconstructed`, no byte
sequence "observed") → the original receipt file **byte-identical** across
the restart (sha256 `1a0abfd1…adca4a`) and **still truthful about P** (its
bound digest IS the surviving frame-1 digest) → presenting it as PRESENT
authority refused with `cap0-stale-receipt` **naming both prefixes**.

The twelve laws, each with a check that would fail if the law broke
(`RUN-CONTROLS.txt`, 36 checks / 0 failures; bracketed = check number):

| law | evidence |
|---|---|
| 1. grant does not mutate into revocation | [015] find-event g-a01 post-revocation: ordinal 1, payload byte-identical to canonical grant encoding |
| 2. revocation does not erase the grant | [016] history shows grant ordinal 1 AND revocation ordinal 5 at once |
| 3. live authority fold-derived, no status slot | design: ledger built fresh per query, discarded after; teeth: `:cached-status` mutant KILLED [023] (+ selftest [025], [026]: strict path never touches the cache) |
| 4. receipt bound to exact validated prefix | [005]; teeth: `:receipt-unbound-to-prefix` mutant KILLED [024] |
| 5. receipt at P not current at P+ | detection [011]; typed refusal [025]; still-truthful-about-P [026]; specimen [018], [021] |
| 6. unrelated event does not revoke | [010] |
| 7. foreign-target revocation does not revoke this one | [013] (two grants, sibling revoked, this one live) |
| 8. second revocation: precise disposition, never a second transition | [017] different-event case: `:already-revoked` naming ORIGINAL r-a01; [018] identical-event case: journal-idempotent (`:already-committed-identical`, zero frame growth) — the two cases explicitly distinguished |
| 9. torn-tail revocation cannot silently revoke | [030] :authorized from valid prefix WITH tail offset+sha surfaced in the receipt; contrast [031]: the committed twin DOES revoke |
| 10. invalid interior frame blocks derivation, typed refusal | [032] `journal-prefix-invalid` signaled, NOT truncation-and-answer; teeth [033]: uncorrupted twin answers |
| 11. `:reconstructed`, never `:observed` | [034] + specimen [015]; `:observed` refused **in code** (closed ecase, selftest [017]) |
| 12. no effect execution | [012] EVENTS.pj0 sha unchanged across query and escalated refusal; the lane exports no effect verb |

Negative controls (each exhibits the INTENDED predicate, with its identifying
fields): wrong subject/action/resource [006]-[008] (`capability-scope-mismatch`,
mismatched term named, kernel0 `offending-field`), wrong capability identity
[009] (`capability-missing`), revocation-before-grant [027]-[028]
(`:revocation-without-grant` disposition surfaced; later grant live),
duplicate grant/revocation identity with altered content [019]-[020]
(journal0's `pj0-event-identity-collision`, the exact type, zero bytes),
interior corruption [032], torn tail [030], stale receipt [025],
bootstrap absent [001] / wrong store binding [002] (`expected`/`actual`
carried) / foreign issuer [004] (`minting-authority-invalid`), planted
fault [035], truncated child [036] + specimen [023].

Gates run (exit codes + determinism shas in `RUN-EXITCODES.txt`):
selftest 28/0 · controls 36/0 · specimen 24/0, each twice, transcripts
byte-identical; regression: journal0-selftest 66/0, journal0-vectors 89/0,
`verify-all.sh` 6/6 — journal0 untouched.

## 2. Design decisions, adjudicated to spec text

1. **Naming.** Lane is **Capability /0** per the recon adjudication ("Live
   Authority /0" would collide with the board's reservation of "arc 2,
   capability and live-authority machinery" as the production's name).
   "Vertical Specimen /0" is nowhere claimed. The Kernel §19.5 reserved
   verbs are NOT claimed: this slice journals grant/revocation *events*
   through `append-event` and answers with `query-live-authority` — a
   deliberately unreserved name — because claiming `check-capability` would
   imply the full §11.4 check (budgets, counts, roles, expiry,
   unresolved-effect restrictions), which this slice does not perform.
   §11.7 restoration and the §11.3 minting bridge are not implemented
   (owner's scope line).

2. **Condition homes** (never both for one meaning). Reused from kernel0:
   `capability-missing`, `capability-revoked`, `capability-scope-mismatch`
   (offending-field carries WHICH term), `minting-authority-invalid`
   (journaled issuer the bootstrap does not ground),
   `journal-prefix-invalid` (interior corruption). Own-minted, with why:
   `cap0-bootstrap-missing` / `cap0-bootstrap-store-mismatch` (the QUERY
   PROCEDURE's configuration, not a capability's standing — reuse would
   let a config omission masquerade as a ledger fact),
   `cap0-malformed-authority-event` (a fold refusal over durable bytes;
   kernel0's `malformed-constructor-shape` is a constructor-argument
   refusal), `cap0-stale-receipt` (kernel0's `capability-expired` is
   wall-clock expiry — banned here; `frontier-precondition-failed`
   presumes an effect frontier — law 12 forbids one; prefix-binding
   staleness is its own fact and carries BOTH prefixes). Full inline
   adjudication: `conditions.lisp` header.

3. **Two refusal classes, split on answerability.** Answerable questions
   get **decision receipts** (`:refused` + reason + full prefix binding):
   missing / revoked / term mismatch — these are truths about the
   validated prefix. Unanswerable questions get **typed signals with no
   receipt**: absent/mismatched bootstrap, foreign issuer, interior
   corruption, stale presentation — issuing a decision receipt there would
   be false testimony about a prefix never validly examined.
   `require-live-authority` escalates the receipt refusals to kernel0's
   own condition types, so the reuse preference is executable, not
   decorative.

4. **Terminal-classification law (law 9 vs law 10 — the adjudicated
   choice).** `:torn-tail` → answer from the valid prefix WITH the tail's
   offset and sha256 surfaced into the receipt: a torn tail is, by PJ0
   §13, a trailing INCOMPLETE frame — never a committed event, so it
   cannot carry a committed revocation. `:corruption` → **refuse
   outright** (`journal-prefix-invalid`): committed frames beyond an
   invalid interior frame are unreachable (per the strict reader's
   observed classification at controls [032]/[033]; the no-skip-forward
   property is journal0's and is not re-derived here), so a committed
   revocation could be buried past the damage and no liveness claim is
   bounded (L13). This deliberately **diverges from journal0's
   own `reconstruct`**, which answers over the pre-corruption prefix:
   reconstructing HISTORY at a named prefix is a bounded claim; asserting
   PRESENT LIVENESS is not. Both branches have teeth (controls [030]-[033]).

5. **Revocation before grant; the later grant.** A revocation for a
   never-granted identity receives the precise disposition
   `:revocation-without-grant` — it grants nothing, revokes nothing,
   forbids nothing; the query refuses `capability-missing` and SURFACES
   the dangling revocation's event identity. A LATER grant of that
   identity is live: revocation is an act upon existing authority, not a
   standing prohibition against future minting — a forward-reaching ban
   would be policy, out of /0 scope. Tested [027]-[028].

6. **Re-grant of a revoked identity does not restore it** (disposition
   `:grant-of-revoked-identity`, query stays refused naming the original
   revocation, [021]): re-granting the same identity would be restoration
   by the back door, and §11.7 (CAP-3) requires restoration to create a
   NEW capability identity — reserved to a future slice.

7. **Law 8's two cases are distinct mechanisms and are kept distinct.** A
   repeated IDENTICAL revocation event never reaches the fold twice —
   journal0's event identity reconciles it (`:already-committed-identical`,
   no frame). A second revocation with a DIFFERENT event identity IS
   committed (it is history) but receives disposition `:already-revoked`
   naming the ORIGINAL revoking event; the transition happened once.

8. **Queries and receipts are never journaled.** Journaled: grant and
   revocation events (+ whatever unrelated events the world commits).
   The query occurrence lives as the query-id + terms INSIDE the receipt;
   receipts are derived artifacts rendered as canonical PJ-S/0 bytes and
   preserved by callers — appending one would dress derived state as a
   primary fact (L9), and it would also move the prefix on every question
   asked, making the question change the answer.

9. **Bootstrap explicitness.** The fold refuses to derive anything without
   an explicitly supplied `bootstrap-authority` (issuer identifier + the
   store identity it binds). In the specimen, the expected store identity
   is derived from DECLARED configuration alone (metadata rebuilt from the
   fixed nonce + durability through journal0's public metadata surface) —
   not copied off the live store — so the restart's binding is config, not
   tautology. Negative controls: no bootstrap, wrong store binding, wrong
   issuer.

10. **Exact equality only.** `datum=` is byte-equality of canonical
    PJ-S/0 encodings; `(id "a:b")` ≠ `(id "a" "b")` (selftest [002] —
    the RESTITUTOR aliasing scar honored on the consumer side). No
    wildcards, hierarchies, patterns, or policy evaluation anywhere.

11. **§11.1 CAP-1 divergence, named.** A /0 capability names: subject,
    action, resource, scope, issuer, capability identity, grant event
    identity (the owner's charge set). It does NOT carry §11.1's minting
    receipt identity, restoration delegates, revocation registry, or
    expiry/effective interval — those belong to the minting-bridge and
    restoration slices this lane reserves. Likewise §11.2 opaqueness is
    **not implemented and not claimed**: this slice has no live opaque
    authority OBJECT at all — only fold-derived liveness. §11.2's MUST —
    *"a capability MUST NOT be reconstructible from serialized public
    fields"* — is **not satisfied here and not attempted**: this slice has
    no capability object at all, and liveness is derived entirely FROM
    serialized public fields. That is a scope choice standing in open
    tension with §11.2, not a form of compliance with it; an opaque
    authority object belongs to the minting-bridge slice.

12. **The lawful path toward attenuation/delegation (documented, not
    built).** By inspection — untested — the schema appears to leave room
    without a rewrite: (a) an
    `attenuated-grant` event kind carrying a `predecessor-capability-id`
    plus equal-or-narrower terms, folded with a subset-check per term
    under exact equality (narrowing = replacing a term, not patterning
    it); (b) delegation as issuer-chains grounded in the SAME bootstrap
    root — a grant whose issuer is the subject of a live delegation
    capability, checked by the same fold, ordinal-ordered; (c) §11.7
    restoration as a new-identity event linking predecessor identity, per
    CAP-3. All three stay fold-derived and journal-only; we see no
    requirement for journal0 changes or a mutable registry, though none of
    this has been executed.

## 3. What this return does NOT claim

- **no cryptographic authenticity** — receipts and events are canonical
  bytes with content digests, not signatures; anyone who can write the
  store can write events;
- **no distributed revocation** — one store, one host, no propagation;
- **no real-time expiry** — no wall-clock anywhere;
- **no multi-writer safety** — this lane adds none, and journal0's lock is
  itself candidate-level with the stale-lock kill path owed;
- **no effect authorization** — nothing here licenses executing anything;
  the query answers "was authority live at this validated prefix",
  nothing more;
- **no delegation closure** — no attenuation, no delegation, no
  restoration (§11.7 and §11.3 unimplemented, path documented only);
- **no full capability security** — §11.1 field set not carried, §11.2
  opaqueness not implemented, §11.4 check performed only as exact term
  equality (no budgets, counts, roles, expiry, unresolved-effect
  restrictions);
- **no adoption, no freeze, no floor, no audit** — candidate status only;
- **not Vertical Specimen /0** — no deterministic fake adapter, no four
  interruption trials;
- **no standing custody service** — no process holds authority for
  others; every answer is a fresh fold by whoever asks (Kernel §0.4
  carve-out respected);
- **all greens are same-family self-consistency; a stranger audit was not
  commissioned** — the same hand wrote the laws' implementation and the
  laws' checks.

## 4. Verification discipline notes

- Every "verified" in this lane's documents either exhibits its step in a
  transcript check or is written against `RUN-EXITCODES.txt` sha lines —
  with one named exception: the SBCL operation-check in both
  `RUN-EXITCODES.txt` headers is asserted, its output not
  transcript-preserved. Compressed verifications: that one; the
  journal0/kernel0/CD0 substrate is trusted on ITS transcripts (66/0,
  89/0, 6/6 re-run this session), not re-derived — and those are a
  candidate's own suites: they do not cover what journal0 itself does not
  claim (PJ0 §32.5 FULL; the §30 SIGKILL harness).
- Gate teeth are permanent (planted mutants + planted-fault/truncation
  child runs live inside the suites), not one-off demonstrations.

— CLAVIGER (Claude Fable 5 subagent), 2026-07-29
