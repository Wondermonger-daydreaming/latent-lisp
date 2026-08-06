# Surface Account /0 — Proposed Public API and Proposed Integration Delta

**Parcel item 12.** Proposed, **NOT implemented**. Every name, row, and
count below is a proposal for the future governed production round
(`R4-SURVIVAL-PLAN.md`); nothing exists in the accepted tree, and this
round creates none of it.

**Author:** Claude Fable 5 (JURIST seat). Same-family cross-checks, not an
independent audit. **Date:** 2026-08-04. **R1-amended** per the owner
adjudication Sections A and B (pure-projection returns; five-member union;
two condition species; Account-owned refusal predicate).

---

## 1. Proposed public API surface

Proposed package: `LISP-PLUS-SURFACE-ACCOUNT` (name is a proposal). Proposed
exports — the complete list, twelve symbols:

```lisp
;; Door 1 (action): validate protocol, key the seven-head manifest by EQ,
;; delegate to exactly one native REQUEST-EXPANSION, seal the result.
;; Constructs the ONE composite artifact kind Door 1 may construct:
;; the sealed composite routing request (pure-projection law, contract I.0).
(account-request-expansion source-form operation occurrence-tag)
  => account-request

;; Door 2 (action): require the exact sealed request species, recheck the
;; immutable /0 manifest binding (any difference = integrity alarm, never
;; movement of any kind: /0 declarations never move, R3.1-C), delegate
;; exactly once to the matching native
;; PERFORM-EXPANSION, and return the EXACT NATIVE RECEIPT plus expanded
;; host form. No projection here; the inspector is the only projection.
;; Never retries, never tries both providers.
(account-perform-expansion account-request)
  => native-receipt, expanded-host-form

;; Try doors: the refusal position holds either the EXACT native retained
;; refusal, or a sealed composite pre-delegation refusal where delegation
;; never occurred. Implemented over the PLAIN native doors with the
;; category-first-then-phase law (jurisdiction §4): caught provider
;; refusals with category :integrity-alarm re-signal the original
;; condition unchanged; then, for :protocol-refusal rows only,
;; phase :request/:perform -> refusal position, any other phase
;; -> re-signal the original condition unchanged.
(account-try-request-expansion source-form operation occurrence-tag)
  => request-or-nil, refusal-or-nil
(account-try-perform-expansion account-request)
  => native-receipt-or-nil, expanded-form-or-nil, refusal-or-nil

;; The /0 inspector — one exact address per version (R2 Section B):
;; /0 = LISP-PLUS-SURFACE-ACCOUNT:INSPECT-ACCOUNT (this export);
;; a future /1 ships its OWN inspector at its OWN address
;; (LISP-PLUS-SURFACE-ACCOUNT-1:INSPECT-EXPANSION, contract II.2) — the
;; /0 inspector, schema, and five-member domain are IMMUTABLE, never
;; extended. Pure projection over the closed tagged union of EXACTLY FIVE
;; members: {S1 receipt, S1 refusal, S2 receipt, S2 refusal,
;;           composite pre-delegation/protocol refusal}.
;; Admission by exact public predicates only (providers' own for the four
;; native members; account-refusal-p for the fifth). The inspector's own
;; output is NOT admitted (no idempotent self-admission, no hidden sixth
;; branch). Output: a DIRECT INERT CD/0 RECORD DATUM (never a wrapper);
;; the exact authoritative schema is CD0-INSPECTION-RECORD-SCHEMA.md.
(inspect-account object)
  => account-inspection-record          ; a CD/0 record datum

;; Account-owned public predicate for the composite refusal species —
;; the fifth union member's admission instrument.
(account-refusal-p object) => boolean

;; Recognizes the EXACT CD/0 schema (CD0-INSPECTION-RECORD-SCHEMA.md §7)
;; — a schema-conformance check over record datums, never a wrapper
;; species recognizer.
(account-inspection-record-p object) => boolean

;; TWO public condition species, optionally beneath one base (R1
;; Section B). An integrity alarm is NEVER an ACCOUNT-PROTOCOL-REFUSED
;; condition. Within Account-owned argument and constructor validation,
;; no raw host type error leaks (R2 Section C qualification — delegate,
;; macro, and host conditions escape unchanged and are not covered by
;; this claim).
account-condition                     ; proposed base condition-type
account-protocol-refused              ; condition-type (species 1)
account-integrity-alarm               ; condition-type (species 2)
(account-condition-code condition)    => keyword
(account-condition-detail condition)  => string (bounded; never a printed host object)
```

**Justification of smallest sufficiency** (contract I.2): two action doors
are the commissioned request/perform minimum; the try doors exist because
the S2 class-conflation makes caller-built try-semantics unsafe
(`REFUSAL-AND-CONDITION-JURISDICTION.md` §4); one inspector; two
predicates, each the admission/type-gate instrument for an artifact only
this package can vouch for; two condition species because the adjudication
rules an integrity alarm is never a protocol refusal, plus one optional
base and two shared readers. **Deliberately absent:** re-exported native
predicates or readers (provider authority is not duplicated), convenience
wrappers, pretty printers, any `VERIFY-RECEIPT` passthrough (verifier
output is omitted from the pure inspector entirely — adjudication
Section A; `VERIFY-RECEIPT`'s own standing is Locked Ruling 6's,
`provider-recomputation`, recorded in the provenance matrix).

## 2. Proposed system delta (`lisp-plus.asd`) — NOT implemented

One additive component; no existing row moves:

```lisp
;; PROPOSED — not present in the accepted tree
(:file "mneme/language-surface-account-0/surface-account"
       :depends-on (<surface1-component> <surface2-component>))
```

(Exact component names to be read from the real `lisp-plus.asd` at
implementation time, not guessed here.)

## 3. Proposed loader / umbrella / matrix delta — NOT implemented

- `mneme/load-lisp-plus.sh`: package count `19 → 20` in the success banner;
  the new package loaded after both providers; transcript must stay
  `0 warnings, 0 redefinitions, 0 undefined variables`.
- `mneme/load-order-matrix.sh`: one new row — the lane loads standalone via
  its direct loader and under the umbrella, after `lisp-plus-surface1` and
  `lisp-plus-surface2`.
- A direct loader for the lane (house shape of the other governed lanes).

## 4. Proposed floor delta — NOT implemented

| Gate | Accepted (historical) | Proposed |
|---|---|---|
| Full | `89/89` | `89+N / 89+N`, `N` = **the number of verify-release rows the lane actually adds to `mneme/verify-release.sh`'s full mode**, stated exactly at the production round's freeze |
| CI | `73/73` | `73+M / 73+M`, `M` = the rows added to CI mode, same law |

**Floor arithmetic is derived from actual verify-release rows, never from
internal self-test assertion counts** (adjudication Section G): the lane's
self-test may hold hundreds of assertions behind one gate row, and an
assertion does not become a release-floor row merely because it exists. A
row is one gate invocation in `verify-release.sh`. Check families behind
the rows are enumerated in `R4-SURVIVAL-PLAN.md` §4. The historical counts
remain historical closure facts of Integration Baseline /0; they are never
re-labelled as current, and the lane may not be left outside the release
organism to preserve them.

## 5. What this delta does not contain

No Account-owned mint, grammar, or receipt species (deferred whole to the
governed /1 successor — no dormant mint); no Surface /3 path, package, or
system; no registry or extension seam of any kind; no change to any
predecessor byte.

— Claude Fable 5 (JURIST, Surface Account /0 opening round), 2026-08-04
