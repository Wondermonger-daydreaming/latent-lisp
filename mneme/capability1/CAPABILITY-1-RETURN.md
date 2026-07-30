# CAPABILITY-1-RETURN — the deliverable

Lane: **Capability /1** (`mneme/capability1/`, package
`#:lisp-plus-capability1`). Status: **candidate**. Builder: CLAVIGER-II
(Claude Fable 5 subagent), 2026-07-29. Substrates, statuses at first
mention: **Capability /0** (itself a candidate — not audited, not adopted,
not frozen) through its public exports; **Journal /0** (itself a candidate
— not audited, not adopted, not frozen; PJ0 §32.5 FULL NOT CLAIMED)
through its public exports; Kernel /0's exported conditions; SBCL 2.4.6,
Linux host. **No transitive guarantee imports: nothing here inherits a
guarantee from any substrate. Two substrate behaviours are RELIED ON and
named as such — §2.7 (fold purity under a fixed bootstrap) and §2.14
(term-completeness of an `:authorized` receipt); each by inspection of
capability0, neither re-derived nor exercised by a check in this lane.**

> A receipt may explain why a key was minted; it is not the key, and its
> description cannot forge one.

---

## 1. What is demonstrated (every item traces to a transcript check except where marked by-inspection)

**The owner's vertical, inhabited end to end**
(`capability1-controls.lisp`, 27 checks / 0 failures, two runs
byte-identical; bracketed = check number in `RUN-CONTROLS.txt`):

fresh Capability /0 authority query at validated prefix P → `:authorized`
receipt bound to P [001] → explicit minting occurrence → opaque live
capability, EQ-recognized by its explicit minting context, bound to P's
four facets (store-id · terminal ordinal · valid byte count · terminal
digest) [002] → public minting receipt: truthful canonical testimony
naming occurrence identity, capability public identity, minter,
authorizing query, grant g-a01, all terms, all facets, both identified
procedures [003] → successful presentation while P is current [004] →
journal advances (unrelated event) → old capability refuses **STALE by
type**, `cap1-stale-capability` naming BOTH prefixes [005] → fresh query
still `:authorized`; fresh mint yields a **NEW** key (new occurrence + new
public identity) **linked to the SAME grant** [006] → new key presents at
the moved prefix [007] → revocation commits → the key refuses STALE (the
adjudicated subsumption, §2.7) [008] → the fresh /0 query refuses
`capability-revoked` naming g-a01 AND r-a01 [009] → **no key can be
freshly minted**: the pre-revocation receipt refuses with /0's
`cap0-stale-receipt`, and a doctored receipt claiming `:authorized` at the
current prefix refuses with `cap1-mint-refused :fresh-derivation-refused`,
fresh reason `capability-revoked`, the revoking event named [010].

**The restart specimen** (`de-clave-mortua/RUN-SPECIMEN.txt`, 29 checks /
0 failures, two runs byte-identical): the key's complete public record —
authorization receipt, minting receipt, printed form — preserved by the
first life, **still current and still truthful at the restart**, and
exhibited as NOT the key: presented receipts refused
(`cap1-unrecognized-object`), an internal-constructor mimic built from the
minting receipt's public fields refused, the printed form reader-rejected;
the same authorization decision re-derived `origin :reconstructed` (L10);
a fresh mint yields a NEW key (identities differ across lives; same grant
g-001) that presents successfully; journal and testimony byte-identical
throughout. Full accounting: `de-clave-mortua/SPECIMEN-RETURN.md`.

**The required object properties, each with a check that would fail if it
broke** (`RUN-SELFTEST.txt`, 30 checks / 0 failures):

| property | evidence |
|---|---|
| non-serializable as authority | print = public identity only, unreadable `#<`, deterministic [007]; read-back signals [008]; specimen print-necromancy refused |
| non-reconstructible from public fields | authorization receipt refused [013]; minting receipt refused [014]; full-field counterfeit via the REAL internal constructor refused [015]; controls NC-1/2/3 [011]-[013]; specimen [016]-[018] |
| no public constructor | `%MAKE-LIVE-CAPABILITY` :internal, no `MAKE-`/`COPY-LIVE-CAPABILITY`, external-symbol scan [025]; limits named in §2.12 and §3 |
| bound to exact store + validated prefix (four facets) | [006]; staleness whenever the current validated prefix differs — exercised as a journal advance [017], controls [005], [008]; the four-facet conjunction, and the store-id facet in particular, are by inspection of `present.lisp`, not separately exercised (a cross-store presentation refuses earlier, at the bootstrap gate — selftest [024], controls [018]) |
| exact subject/action/resource/scope, defensively exposed | term discipline [012], controls NC-8 [015]; §11.5 codec-copy readers [009], [010] |
| unusable when prefix not current, typed, both prefixes named | [017]; controls [005] |
| dies with the process; never reconstructed; fresh mint required after restart | specimen phases 1–3; cross-life identity difference [027] of `RUN-SPECIMEN.txt` |
| confers no effect by existence | no effect machinery exists in the lane (by inspection of `package.lisp`'s export list — readers, the two entry points, the mutant harness; nothing that executes); minting/presenting write nothing [029]; specimen journal sha unchanged |
| context recognizes / journal decides (never a liveness cache) | recognition survives staleness while presentation still refuses [018]; `:context-as-liveness-cache` mutant KILLED [028], controls [025]; fresh validation per presentation: controls [021]/[022] — same object, same context, changed bytes, opposite outcomes |

**Negative controls** (each exhibits the INTENDED predicate with its
identifying fields; controls numbering): authorization receipt as key
NC-1 [011] · minting receipt as key NC-2 [012] · full-field counterfeit
NC-3 [013] · foreign context NC-4 [014] · later prefix NC-5 [005] ·
post-revocation NC-6 [008]-[010] · restart NC-7 (specimen) · foreign terms
NC-8 [015] · refusal-receipt mint NC-9 [016] · non-receipt mints NC-9b
[017] · stale-receipt mint NC-10 [010i] · bootstrap absence/mismatch NC-11
[018] · torn tail (presents, tail surfaced) + committed contrast [019],
[020] · interior corruption (typed refusal) + restored-twin teeth [021],
[022] · three planted mutants killed NC-12 [023]-[025] · planted fault
[026] · truncated child NC-13 [027], specimen [028].

Gates run (exit codes + determinism shas in `RUN-EXITCODES.txt`): selftest
30/0 · controls 27/0 · specimen 29/0, each twice, transcripts
byte-identical; regression: capability0 28/0 + 36/0 + specimen 24/0 with
its transcript diffed byte-identical against the committed capture and its
ARTIFACT files re-verified against its committed SHA256SUMS,
journal0-selftest 66/0, journal0-vectors 89/0, `verify-all.sh` 6/6 —
capability0 and journal0 untouched.

## 2. Design decisions, adjudicated to spec text

1. **Naming.** Lane is **Capability /1** (`mneme/capability1/`), the
   minting-bridge slice that capability0's own RETURN reserved ("§11.7
   restoration and the §11.3 minting bridge are not implemented"; "an
   opaque authority object belongs to the minting-bridge slice").
   Specimen `de-clave-mortua` — name grep-checked free of the rest of the
   tree (re-checkable: `grep -rl de-clave-mortua experiments/latent-lisp`);
   no ordering is claimed.
   "Vertical Specimen /0" is nowhere claimed. The Kernel **§19.5 reserved
   verbs stay unclaimed**: the entry points are `mint-from-authorization`
   and `present-live-capability`, deliberately unreserved, because
   `mint-capability` would imply full §11.3 (delegates identified,
   policy-claim standing) and `check-capability` full §11.4 (effect
   authorization, budgets, counts, roles, expiry, unresolved-effect
   restrictions) — neither performed here. This is the same
   reservation-respect capability0 exercised with `query-live-authority`.

2. **§11.2, satisfied at this slice's scope — the exact boundary.** The
   MUST — *"a capability MUST NOT be reconstructible from serialized
   public fields"* — is executed as **process-local EQ recognition**: the
   minting context recognizes exactly the objects it minted; every public
   artifact (authorization receipt, minting receipt, printed form,
   field-copy) refuses at presentation, demonstrated against the
   strongest description-based forger available in-package (the internal
   constructor itself, fed the complete public record, on a CURRENT
   prefix — specimen [018]).
   The durable records preserve exactly what §11.2 permits (public
   identity, scope description, minting receipt, lineage) and the
   specimen executes "these records do not grant authority" four separate
   ways. **Boundary:** this is in-process opaqueness against honest
   misuse and description-forgery. It is NOT resistance to a hostile
   same-process attacker with introspection access to a LIVING context
   (e.g. walking the context's hash table); no such claim is made — §3.

3. **§11.3 [CAP-2], subset executed; divergences named.** Step 1
   (validate authorizing claim identity and standing): the claim must BE
   a /0 authority receipt claiming authorization, and standing is /0's
   own present-receipt discipline — stale binding → /0's
   `cap0-stale-receipt`; current binding → **fresh re-derivation, whose
   decision alone counts** (the receipt's decision field is never trusted
   TO AUTHORIZE: it is read only as a claim shape — a receipt not
   claiming `:authorized` is refused on its face, controls [016] — and
   only the fresh derivation's decision authorizes; the doctored-receipt
   controls execute exactly the forgery the governing sentence forbids). Divergence: the authorizing claim is a
   /0 authorization receipt only — no sealed rulings, no policy claims
   (out of slice). Step 2 (derive scope under an identified procedure):
   procedure `cap1-scope:exact-from-authorization` version 0 — exact copy
   of the fresh receipt's terms; identified in the minting receipt.
   Step 3 (identify minter and delegates): minter is the caller-declared
   principal, recorded in object and receipt; **delegates: NONE — named
   divergence** (no restoration machinery in this slice). Step 4: the
   opaque object, created internally and registered — registration IS
   the grant of recognizability. Step 5: the public minting receipt,
   §2.9.

4. **§11.1 [CAP-1], subset carried; divergences named.** Carried:
   capability identity (public), scope — as the four exact terms
   (subject/action/resource/scope; the "scope predicate" is exact
   canonical equality, no predicate language), minter principal,
   authorizing claim identity (the /0 query-id, in the minting receipt;
   the object's identities derive from the fresh receipt), minting
   receipt identity (the occurrence identity, carried in both object and
   receipt). NOT carried, reserved to later slices: effect classes,
   restoration delegates, revocation registry object, expiry/effective
   interval, predecessor capability identity. (Revocation is handled, but
   as /0's journaled events consulted by fresh derivation — not as a
   registry the object references.)

5. **Condition homes** (never both for one meaning). REUSED:
   `cap0-bootstrap-missing` / `cap0-bootstrap-store-mismatch` (identical
   meaning — the caller's declared configuration absent / binding another
   store; signaled by presentation's own gate, propagated from /0 on the
   mint path), `cap0-stale-receipt` (the stale thing at the mint step IS
   a /0 receipt; /0's discipline propagates unwrapped),
   `lisp-plus-kernel0:journal-prefix-invalid` (presentation over a
   `:corruption` prefix — /0's fold adjudication adopted at the
   presentation frontier, controls [021]/[022] with restored-twin teeth).
   OWN-MINTED, with why (full inline adjudications in `conditions.lisp`):
   `cap1-context-missing` (a different configuration value than the
   bootstrap), `cap1-unrecognized-object` (a PROCESS fact, not kernel0's
   LEDGER fact `capability-missing`), `cap1-term-mismatch`
   (presentation-vs-OBJECT terms; kernel0's `capability-scope-mismatch`
   already has its one home in /0's escalated query refusal),
   `cap1-stale-capability` (owner's charge: do not overload /0's
   receipt-staleness; carries both prefixes, all eight facets),
   `cap1-mint-refused` (the claim handed to the bridge, not journaled
   history — kernel0's `minting-authority-invalid` home is /0's
   foreign-issuer fold refusal).

6. **Presentation semantics — three ordered moves, refusals as typed
   signals only.** (1) EQ recognition; (2) exact term discipline — the
   adjudicated reading is the STRICTER of the two the charge offered:
   the caller states all four requested terms and each must equal the
   minted term exactly (an omitted term is a mismatch), because a
   presentation that names no terms is a key waved at the building rather
   than put into a lock; (3) FRESH `validate-journal` on every
   presentation, four-facet comparison. Success returns a presentation
   receipt (public, truthful, prefix-bound); **every refusal is a typed
   signal and no refusal receipt exists**: a presentation refusal is not
   a truth about the validated prefix alone (recognition is process-local
   and unreproducible from bytes), so a durable refusal record would
   manufacture testimony history cannot check — /0's answerability split,
   carried one step further.

7. **The honest subsumption, stated as charged.** Under exact prefix
   binding, ANY journal advance — including the advance containing this
   capability's own matching revocation — makes presentation refuse as
   STALE (`cap1-stale-capability`), never as "revoked": controls [008].
   **Revocation therefore distinctly governs MINTING:** a fresh mint
   after revocation refuses because the fresh /0 derivation refuses,
   naming the revoking event ([009], [010]). Presentation does not re-run
   the /0 query at an unchanged prefix because, by inspection of
   capability0's fold (not re-derived here — a named substrate reliance,
   see the header banner), the derivation is a function of the validated
   prefix under a fixed bootstrap, so a matching prefix would return the
   mint-time answer; a moved prefix already refused as stale. The nearest
   executed corroboration is controls [019]/[020] — only commitment moves
   the prefix.

8. **Occurrence and public identity — derived, deterministic, and only a
   name.** `("cap1-mint"|"cap1-key") · sha256(fresh authorization
   receipt's canonical bytes) · per-context serial`. Deterministic
   (selftest [005] recomputes it from the public recipe), process-local,
   and **not authority** — recognition never consults identity (the
   full-field counterfeit carries the true public identity and still
   refuses). Named limit: no global uniqueness — two lives asking under
   the same query identity at the same prefix would derive the same NAME;
   the specimen makes cross-life difference deterministic by declared
   charge (distinct query identities per life). Legible corollary,
   checkable in the specimen artifacts: the dead key's identity sha IS
   the sha256 of `ARTIFACT-AUTH-RECEIPT.pjs`, because a current receipt's
   fresh re-derivation is byte-identical.

9. **The minting receipt records; it cannot recreate.** Canonical PJ-S/0
   bytes (the /0 receipt precedent) carrying: occurrence identity ·
   capability public identity · minter · authorizing query identity +
   its full prefix binding · grant linkage · the four terms · the two
   identified procedures (+ torn-tail surfacing passed through when the
   fresh receipt carries it). **It contains no reconstruction material
   because none exists anywhere**: there is no secret in the object —
   recognition is EQ membership, so NOTHING serializable re-enters the
   table; the receipt could truthfully record every bit of the object
   and still confer nothing (the specimen's mimic executes exactly this).
   Kernel0's exported `capability-mint-receipt` host record was
   considered and NOT used: its field set (delegates, revocation
   registry, expiry) presumes the full CAP-1/CAP-2 semantics this slice
   does not perform — recording those fields would fabricate or
   null-dress; the lane's canonical-record receipt states the subset
   truthfully.

10. **Minting occurrences and receipts are never journaled** (the /0 L9
    adjudication, adopted): a mint is a process-local occurrence over a
    validated prefix — derived state; appending it would dress derived
    state as a primary fact, and would also move the prefix on every
    mint, staling every outstanding key as a side effect of creating a
    new one. The journaled facts remain /0's grant/revocation events.
    Executed: selftest [029], specimen frame-count checks.

11. **The context is a recognizer, never a liveness cache.** It stores EQ
    membership (+ the occurrence identity as a diagnostic value), no
    liveness verdicts, no reports; nothing in it is consulted to skip a
    validation. Teeth: the `:context-as-liveness-cache` mutant answers
    from recognition alone and is KILLED by a journal advance (strict
    stale vs mutant presented) in both suites; the companion fact —
    recognition SURVIVES staleness while presentation refuses — is
    checked separately (selftest [018]); and the sharpest exhibit of
    fresh-validation-per-presentation is controls [021]/[022] — the same
    object, the same context, changed store bytes, opposite outcomes
    (corruption refusal, then success on the restored twin).

12. **No public constructor — mechanism and limits.** CL package
    discipline: `%make-live-capability` unexported, copier suppressed,
    external-symbol scan in the suite. Named limits (also §3): `::`
    syntax reaches internals for any same-process caller — which is why
    the design does NOT rest on constructor privacy: the controls build
    counterfeits **through the real constructor** and recognition still
    refuses them. Package discipline stops honest misuse; EQ-recognition
    stops description-forgery; neither stops hostile introspection
    against a living context.

13. **§11.5 defensive exposure.** Every exported reader returns a value
    whose mutation cannot reach live authority: datum slots re-read
    through the canonical codec (encode→decode = fresh isomorphic datum;
    CD/0's own accessors are already defensive, and the codec-copy makes
    the property independent of that), strings copied, integers
    immutable. Executed: selftest [009] (non-EQ, `datum=`-equal reads),
    [010] (mutated returned strings; subsequent reads unchanged).

14. **A relied-on invariant, documented rather than dead-coded:** a fresh
    /0 receipt with decision `:authorized` always carries all four terms,
    because /0's term matching treats an unqueried (nil) term as a
    mismatch — so an authorized receipt implies four exact matches, hence
    four present term fields. The bridge extracts terms from the fresh
    receipt without a reachable missing-term branch; writing one would
    have planted an untestable gate.

## 3. What this return does NOT claim

- **no host-process adversarial security** — package discipline and
  EQ-recognition stop honest misuse and description-forgery, not a
  hostile same-process attacker: `::` reaches internal symbols, and
  introspection of a LIVING minting context (its hash table, its
  registered objects) would yield presentable objects. Said plainly: the
  opaqueness claim is structural, not adversarial;
- **no cryptographic authenticity** — receipts are canonical bytes with
  content digests, not signatures; anyone who can write the store can
  write events, and anyone in the process can call the mint;
- **no distributed authority** — one store, one host, one process's
  recognition; nothing propagates;
- **no delegation, no attenuation, no expiry, no restoration** — §11.3
  delegates, §11.7, and every widening/narrowing/interval semantic are
  reserved to later slices;
- **no effect execution** — nothing in this lane executes, licenses, or
  models an effect; presentation returns testimony, not access (§11.4's
  frontier check is NOT implemented — no effect classes, budgets, counts,
  roles, or unresolved-effect restrictions);
- **no durable capability handles** — nothing survives the process as
  authority, by design and by demonstration;
- **no full §11.1 CAP-1 compliance** — subset named in §2.4;
- **§11.2 satisfied AT THIS SLICE'S SCOPE only** — in-process opaqueness
  by recognition; not against adversarial introspection (§2.2 boundary);
- **Capability /0 unchanged; Journal /0 unchanged** — both consumed
  through exports; both remain candidates themselves (journal0 §32.5 FULL
  not claimed; no crash-window property claimed anywhere in this lane);
- **no adoption, no freeze, no floor, no audit** — candidate status only;
  the substrate suites are candidate gates, not floors (`verify-all.sh`
  is the CD/0 floor and does not sweep this lane);
- **not Vertical Specimen /0**;
- **all greens are same-family self-consistency; no stranger audit was
  commissioned** — the same hand wrote the object, the bridge, and the
  checks.

## 4. Verification discipline notes

- Every "demonstrated" above traces to a numbered check in this lane's
  captured transcripts (`RUN-SELFTEST.txt`, `RUN-CONTROLS.txt`,
  `de-clave-mortua/RUN-SPECIMEN.txt`; uncommitted at the time of writing
  — the chair commits), and every "verified" either exhibits its step
  there or is written against `RUN-EXITCODES.txt` sha lines — with the
  named exceptions, compressed: (i) the SBCL operation-check in the
  `RUN-EXITCODES.txt` headers is asserted, its output not
  transcript-preserved; (ii) the capability0/journal0/CD0 substrate is
  trusted on ITS transcripts (28/0 + 36/0 + 24/0-byte-identical, 66/0,
  89/0, 6/6 — all re-run this session), not re-derived, and those are
  candidates' own suites covering only what they claim; (iii) the
  `de-clave-mortua` name-freeness grep (§2.1) — re-checkable, output not
  preserved; (iv) the "chair-verified" naming attributions in
  `ALLOWED-SOURCES.md` and `CAPABILITY-1-PROVENANCE.md` — assertions of
  the owner's charge text, carrying no verification artifact in this
  lane; (v) the capability0 ARTIFACT re-verification (`sha256sum -c` all
  OK) and transcript diff in the third bullet and in
  `RUN-EXITCODES.txt` — performed, outputs not preserved in either file.
- Gate teeth are permanent (three planted mutants + planted-fault +
  truncation children live inside the suites), not one-off
  demonstrations; each has been seen to fire (`RUN-EXITCODES.txt`, "Gate
  teeth").
- The regression re-run of capability0's specimen rewrote its
  deterministic ARTIFACT-* files; byte-identity was verified against its
  committed `ARTIFACT-SHA256SUMS.txt` (all OK) and its transcript diffed
  byte-identical — no content change anywhere in that lane.

— CLAVIGER-II (Claude Fable 5 subagent), 2026-07-29
