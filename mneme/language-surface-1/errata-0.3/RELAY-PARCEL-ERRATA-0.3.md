# RELAY PARCEL — Language Surface /1, ERRATA 0.3 (repair results)

*Self-contained. Assumes no prior context. This is a **results** parcel: it
reports what was repaired and what remains open. Quote from the records named
in §8, never from this summary.*

*— Claude Fable 5, 2026-07-28.*

---

## 1. WHAT HAPPENED, IN ONE PARAGRAPH

An independent stranger audit of **Language Surface /1, Candidate /0 through
Errata 0.2** (a Common Lisp layer that turns a macroexpansion into an
inspectable structural occurrence with a receipt) returned
**`AUDIT-CLOSED — DEFECTS FOUND, REPAIR REQUIRED`** with nine confirmed
defects. Its central result: **no route was found that minted a false
expansion receipt.** The receipts survived; the layer's *stories about itself*
— its reachability classifications, the robustness of its public checking
functions, its version binding, and its evidence — did not. The owner
authorized **Errata 0.3** to repair the stories without redesigning the
account. That work is complete, merged, and published.

## 2. VERSION RULING (written and committed BEFORE implementation)

```
grammar    3 -> 4        procedure  3 -> 4        policy  1  unchanged
```

Grammar moved because the correspondence itself moved (surplus identifier
segments now refused; a declared term-depth ceiling on the raw public
functions; the published description of injectivity and reachability
corrected). Procedure moved because both doors now capture versions **as
values** and an image upgraded *between* the doors now refuses. Policy did not
move: **no ceiling value changed**, and none was moved to make any code more or
less reachable.

## 3. THE NINE FINDINGS, DISPOSED

| # | finding | disposition |
|---|---|---|
| D1 | `:EXPANDED-NODES-EXCEEDED` advertised "MEASURED UNREACHABLE", reached by ordinary public input | reclassified `:public-api`; retracted note deleted; M4/M6 replaced by an executable witness. **Guard unchanged, no ceiling moved** |
| D2 | refusal machinery crashed while *describing* what it refused (compound `TYPE-OF` on complex/vector/array) | repaired **in the helper**, not behind a handler at the door |
| D3 | round-trip gate publicly reachable (two mechanisms, one needing no mutation); decode not injective | claims withdrawn and marked; surplus segments refused; **gate preserved and vindicated** |
| D4 | three of five instruments could run zero checks and be blessed | six instruments emit canonical lines from live counters; **43 planted faults refused, 0 holes** |
| D5 | public `ENCODE-TERM`/`DECODE-TERM` killed the image on deep acyclic input, one fatally and uncatchably | iterative sharing check + declared symmetrical ceiling enforced before recursion; **removed, not relocated** (verified to 500k levels) |
| D6 | evidence label was `git rev-parse HEAD`, not a measurement | content digest over a **traced 25-member exact-path manifest**, computed independently by each instrument |
| D7 | a receipt could not report the versions that minted it; its alarm had one operand | versions captured and stored at both doors; alarm compares two independently sourced values |
| D8 | self-certifying checks (the full `F-1…F-17` inventory) | worked as a mandatory checklist; coverage now **measured**, not declared. **One limit left OPEN — see §6** |
| D9 | the RETURN's own claim inventory was false | banner corrected; four unmarked false claims marked **in place**; term-granularity ruling written into `package.lisp` |

## 4. THE NUMBERS (derived from live transcripts, never from a prior document)

```
runner exit 0
173 checks / 0 failed        (139 selftest · 8 stub · 26 application)
 22 verdicts / 0 confirmed   (6 reproduction I · 4 II · 12 III)
teeth: 43 planted faults, 0 holes, across all six instruments
subject digest 9214b59bda190327… — computed independently by all six, agreeing
form floor 199/0 · language floor 654/0 · ten predecessor trees: ZERO diff
exports 75 -> 80
```

Totals moved from Errata 0.2's `147`. **The movement is correct**: checks were
deleted as non-evidence, merged where two counted one fact, added where a
repair needed a regression. **No filler was added to preserve a total.**

## 5. WHAT THIS ERRATUM FOUND IN ITS OWN REPAIRS

This lane's signature failure is that **each defect lives in the repair of the
previous one.** It recurred four times, and every instance was caught before
publication — three by a checker commissioned to grade the work, one by the
chair's own instrument:

1. **The depth ceiling was not symmetrical**, though the ledger claimed it: the
   deepest host term the encoder accepted produced a datum the decoder
   **refused** — an encodable term that could not be read back, precisely what
   a depth ceiling exists to prevent.
2. **The decode repair was quadratic in depth** (a 1900-deep decode fell from
   seconds to 0.015 s once split into a door that measures once and a body that
   descends bounded).
3. **`:PROCEDURE-VERSION-MISMATCH` was left catalogued internal-only while the
   D7 repair had just made it publicly reachable** — which would have
   republished, *inside this erratum*, the exact defect class it was
   authorized to repair.
4. **Two chair probe bugs**, both of the class under repair: a check comparing
   two CD/0 octet *objects* (a CLOS class, so `EQUALP` was object identity —
   testing nothing), and a probe that searched for a retracted claim and
   **matched it inside the sentence retracting it**.

## 6. WHAT REMAINS OPEN — READ BEFORE CITING

- **No stranger audit of this target.** Owed, and harder than the last: the
  tree is public, so a prereg committed to it is a published prereg.
- **No fresh-weights reading.** The 2026-07-28 audit was fresh-context
  Claude-family and said so before returning a verdict; it cannot catch a
  Claude-wide blind spot, and neither can this erratum.
- **THE STALE-LABEL CLASS IS NAMED, NOT CLOSED.** Two of the three stale labels
  swept during this erratum were **created by repairs made during it**. A
  check's label is prose about code, and no assertion in this tree relates the
  two — so the class **re-opens on every move of `surface1.lisp`, and nothing
  detects it.**
- **No DAG representation, no alpha-normalization** — still the two named next
  representation laws. **Form /3 and Surface /2 remain unopened.**
- **No claim of completeness.** Nine findings repaired; the audit was explicit
  that it could not enumerate what it had not reached.

## 7. STANDING — UNCHANGED BY REPAIR

```
candidate repaired through Errata 0.3
audit findings addressed by the AUTHOR FAMILY
NOT independently re-audited after repair
NOT fresh-weights audited
not adopted · not frozen as language law · on no governing floor
```

**The 2026-07-28 audit remains closed WITH DEFECTS against the frozen Errata
0.2 target.** Errata 0.3 creates a **new target, and new audit debt with it.**
Nothing here licenses *"now correct"*, *"audit closed clean"*, or any adjective
about quality.

## 8. THE RECORD OF TRUTH

Public at `github.com/Wondermonger-daydreaming/latent-lisp` under
`mneme/language-surface-1/`; lab path `experiments/latent-lisp/mneme/language-surface-1/`:

```
LANGUAGE-SURFACE-1-ERRATA-0.3.md        the erratum                [quote from HERE]
errata-0.3/DEFECT-LEDGER.md             ledger + version ruling (pre-implementation)
errata-0.3/D8-DISPOSITIONS.md           F-1..F-17, one disposition each
errata-0.3/REPRODUCTION-III.lisp        the standing regression gate (12 verdicts)
errata-0.3/pre-errata-evidence/         pre-repair reproductions, 8/8 confirmed
errata-0.3/teeth/                       43 planted faults, 0 holes
errata-0.3/digest-demo/                 the four subject-digest demonstrations
errata-0.3/floors/                      both floors + the predecessor diff proof
errata-0.3/{SPECULUM,CUSTOS}-REPORT.md  the two repair agents' reports, verbatim
audits/2026-07-28-stranger-audit/       THE AUDIT — immutable, unedited
```

Merge commit `431fee16`; published and verified by content, not by sync
message. The audit record was not edited; every contradicted claim in an older
document is **marked in place**, never rewritten.

## 9. HANDLING

This is a **results** parcel. If you want a fresh mind's pre-committed bands on
anything downstream — the owed stranger audit of *this* target especially —
send that request as its **own artifact, before** this one reaches them. A
cold chair shown the answer is not a cold chair.

If you are a Claude-family reader: your agreement with this parcel is
**shared-root** and may not be banked as corroboration. Only a refutation, or a
finding this parcel does not contain, carries independent weight.
