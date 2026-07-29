# MNEME JOURNAL STORE — IMPLEMENTATION RETURN

*Lane opened under the owner's authorization of 2026-07-29 (implementation
arc 3). Chair: Claude Fable 5. Builders: CONDITOR (Fable, killed mid-lane by
a platform 500 — outage checkpoint at
`notes/2026-07-29-journal0-outage-checkpoint.md`), RESTITUTOR (Fable, the
restorer), SUPERSTES (Opus, the restart specimen). Every number below was
re-derived by the chair's own hand from re-executed transcripts.*

> A process may die while its durable history survives; reconstruction may
> derive from that history, but it may not pretend to remember what was never
> committed.

## Standing

```
Mneme journal store candidate     CONSTRUCTED
independently seeded              YES — exposure fence sealed BEFORE coding
                                  (ALLOWED-SOURCES.md, commit 1fc1f305);
                                  provenance audited across all three hands:
                                  ZERO Class B contact, both builder lives
tested against the frozen gate    YES — the gate runner was AUTHORED here
                                  (none existed in any language)
inhabited restart specimen        EXECUTED — de-teste-occiso
not audited · not adopted · not frozen · not on a governing floor
```

## Conformance, class by class (PJ0 §32) — exact, never rolled up

| class | verdict | evidence |
|---|---|---|
| **32.1 codec** | **DEMONSTRATED** | PJ-S/0 codec written fresh from §5 ABNF; PJ-SYN-2 decode/re-encode byte identity over all positive vectors; 6 semantic vectors with content assertions |
| **32.2 reader** | **DEMONSTRATED** | §12's 16 steps + §13 classification: 16/16 adversarial correct (status + valid-frames + §23 category); full 1,235-member truncation family at exact offsets, prefix byte-identical (PJ-TRN-1/2/3) |
| **32.3 writer** | **DEMONSTRATED except §30** | byte-exact rebuild of all three frozen positive stores incl. metadata + sidecars; §9.2 critical section; PJ-APP-1/2/3 idempotency both-toothed against the reader's opposite disposition; §30 SIGKILL harness MUSTs 1–3 (PRNG seed / seed-driven windows / randomized N-trial) NOT discharged; PJ-KILL-2 unexercised |
| **32.4 recovery** | **DEMONSTRATED** | longest-valid-prefix + terminal classification + 5 crash-window scenarios (§29/Annex B); CW-3 reconciliation executed (`:already-committed-identical`, zero new bytes, origin `:reconstructed`); torn tail visible/uncommitted/preserved |
| **32.5 FULL** | **NOT CLAIMED** | §30 remainder above; `:best-effort` kill scenarios and intra-§9.2 kill (stale-lock path) owed; K0E-15 kernel-side exclusion (Errata §8 control 13 PARTIAL; 10/11/12/14 discharged) |

## The numbers (chair re-derived, byte-identical to delivered captures)

```
vector gate      89 checks / 0 failures / exit 0    (RUN-VECTORS.txt ≡ chair re-run)
                 census live-derived: 3 positive · 16 adversarial · 6 semantic ·
                 1,235 truncation · 5 crash-window scenarios · 6/6 mutants killed ·
                 10 negative controls (each naming its reddened check)
selftest         66 / 0 / exit 0                    (byte-identical to chair re-run)
restart specimen 63 / 0 / exit 0                    (byte-identical to chair re-run;
                 three genuinely new OS processes; RUN-SPECIMEN ≡ SECOND, sha 8e0b0aa9…)
determinism      every suite byte-identical across runs; nothing normalized
smoke gate       mneme/verify-all.sh 6/6 floors green; journal0 joins NO floor
untouched proof  git porcelain: zero tracked modifications anywhere; Surface /1,
                 Form, Slice, de-pignore, de-vadimonio byte-untouched
```

## The restart specimen — de-teste-occiso

A separate writer process is SIGKILLed **after** the §10.1 fsync barrier and
§9.2 step-9 reopen, with its receipt alive only in its dying memory (chair
verified the ordering in `writer.lisp` and the kill point in
`stage-writer-child.lisp`: the child parks only after `append-event`
returns). A genuinely new process recovers from durable bytes + declared
configuration alone: `:valid` at 4 frames / 1,507 octets (excludes CW-0/1 by
frame count, CW-2a/b by zero excluded octets), state labeled
`:reconstructed` never `:observed`, blind retry refused, CW-3 reconciled by
event identity with **zero new bytes**. The teeth: the same charge with the
kill moved to **CW-0** leaves the event absent and the retry then *commits*
where the CW-3 retry *reconciled* — the cell is a finding, not a harness
constant. Raw post-kill bytes preserved as tracked `CRASH-ARTIFACT-*` files.
CW-2c/CW-3 byte-identity is stated at the point of claim (§29: scenario
metadata, never bytes). Declared deviation: fixed store nonces (PJ-META-1)
for byte-determinism.

## Divergences — itemized, adjudicating to spec text (JOURNAL-0-COMPARISON.md)

- **D-1** registry `expected-error` strings are the Python tool's vocabulary
  (one is a verbatim CPython codec message); gated by §23 condition CATEGORY,
  recorded per vector id/field.
- **D-2 — SPEC-ERRATUM CANDIDATE, owner's ruling requested.** PJ0 §5.10
  ("Canonical Datum /0 identifier order") vs the frozen corpus: CD/0 §14.3
  ValueBytes order sorts `store-id` before `cd0-version` (length octet 8<11;
  chair-verified arithmetically AND against the frozen metadata bytes), while
  every frozen positive vector renders plain segment-lexicographic order.
  Irreconcilable; the corpus order is FORCED (under the other reading no
  implementation can ever pass PJ-SYN-2's byte-identity gate). Implemented:
  corpus order; identifier EQUALITY still delegates to CD/0. The spec was
  not repaired from this lane.
- **D-3/D-4** field-scope notes (comparison file). **D-5** K0E-15 kernel-side
  bounded-standing exclusion named.
- §12 **step 16** (Kernel semantic fold — absent from the reference tool) is
  wired through kernel0's adopted `validate-event-sequence` with K0E-26 dual
  verdicts; structural-PASS/semantic-FAIL demonstrated live.

## Salvage disposition (the outage)

11 of 13 inherited partials adopted-verified; 2 repaired — `reader.lisp` +
`writer.lisp` had keyed event-identity on colon-joined segment strings,
under which `(id "a:b")` ≡ `(id "a" "b")` falsely collide; re-keyed to CD/0
canonical octets, regression tooth added. `sha256.lisp` proven against FIPS
180-4 vectors before any digest was trusted. The dead builder's unverified
claims were banked as nothing and re-derived from scratch.

## What this return does NOT claim

No adoption, no freeze, no floor, no audit. No cross-image durability beyond
the declared host contract (PJ-DUR-3; WSL honesty per the spec). No
persistence claims for Kernel /0 semantics beyond what the joint two-verdict
fixtures exercised. All greens are same-family self-consistency — the
independence demonstrated is from the REFERENCE IMPLEMENTATION (the seeding
boundary), not from the model family; a stranger audit is not commissioned
by this return.

*— Claude Fable 5 (lab chair), 2026-07-29 night. Front door for the lane:
this file; recipe: `RUN-EXITCODES.txt`; comparison: `JOURNAL-0-COMPARISON.md`;
provenance: `JOURNAL-0-PROVENANCE.md` + the outage checkpoint.*
