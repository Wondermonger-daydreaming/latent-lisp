# LANGUAGE SLICE /2 — CANDIDATE /0 ADOPTION

*The chair's record. Companion to `LANGUAGE-SLICE-2-CLOSURE.md`, which is the
builder's: that file says what was built and what it costs; this one says what
the chair verified **with its own hands**, what it declined to inherit, and what
is still owed.*

*— Claude Opus 5 (1M context), chair · SBCL 2.4.6 operation-checked through the
wrapper*

```
status:                    owner-authorized implementation, chair-adopted
implementation-authorized: yes  (LANGUAGE-SLICE-2-WORK-ORDER-0.md)
public-api:                candidate /0 surface
specification-frozen:      NO
representation-selected:   yes  (D2-0.1, first-class contract)
attachment-locus-selected: yes  (D2-0.2, per premise)
stranger audit:            OWED, against this record too
```

---

## 1. Live custody

Built by **PONS** in a throwaway clone (`/tmp/lisp-plus-PONS`) with **no git
remotes and hooks disabled**, which committed nothing and never touched the live
tree. Patch `/tmp/PONS-SLICE2-CANDIDATE-0.patch`, 254 404 bytes, SHA-256
`0657aeb7a2a5cb98a686c83e23c738dd8faeeab6f5448644744fb082faa423ac` — **hash
verified by the chair before the diff was opened.**

Applied to a **pristine verification clone first**, exercised there in full, and
only then to the live tree. Published as `2f918a6d` (kernel) and `58940c44`
(applications). Mirror verified **by content**, not by its commit message.

## 2. SIGNATOR adoption

§0 of the work order was **already discharged** when this chair took the seat:
the patch it names had landed as `a875112d`, whose message is verbatim the one
§0 asks for. Rather than inherit that, the chair re-checked it — patch SHA-256
matched, `git apply --check --reverse` confirmed the content is in the tree, 61
exports live, full floor green.

Two of §0's items were **not** inherited but re-probed independently
(`/tmp/CHAIR-PROBE-signator-acceptance.lisp`, 13/13, loads no selftest):

- **§0.4** — the registry key is the account's **content, not its object
  identity**: a field-by-field rebuild is issued; the same rebuild with one field
  changed is not. **Stated ceiling:** this does *not* distinguish byte-comparison
  from digest-comparison, which would need a collision. That octets rather than
  the hex index are the authority is **read** in `core0.lisp`, recorded as read,
  not run.
- **§0.7** — an unissued account mints nothing, **and the ledger is not asked.**

**A correction to the prior chair's method, since the conclusion outlived its
evidence.** §0.7 had been verified by measuring *ledger row count*. A ledger
**query appends no row**, so that instrument reads "unchanged" whether or not the
query fired — it could not have detected consultation at all. This chair
instrumented the adapter's own `ledger-query` closure with a counter, **proved
the counter live on the lawful path first** (1 call), then read zero on the
unissued path. The conclusion stands; the evidence for it now bears on it.

Per §0's instruction, **no new adjudication document was written** — nothing
failed.

## 3. What the chair verified, run not read

Every number below was produced in this session, from actual runs.

| criterion | verified how | result |
|---|---|---|
| Slice /1 untouched | SHA-256 per file + recursive `diff -rq` | `slice1.lisp`, `slice1-selftest.lisp`, `SMOKE-1.lisp`, Slice /0, Kernel /0 **byte-identical** |
| Core /0 delta | live `do-external-symbols` | **61 → 62**, exactly one |
| `R-SOURCE-1.10` intact | live `find-symbol` | `CORE0-EVIDENCE-REQUEST` = **INTERNAL** |
| relation vocabulary | grep on `slice2.lisp` | exactly three; no `:ESTABLISHES`; no domain proposition emitted |
| missing contract | selftest, teeth shown firing | typed `PREMISE-CONTRACT-MISSING` / `-DUPLICATE` / `-UNKNOWN-PREMISE` |
| full floor | `verify-language-floor.sh`, **twice** | **10 floors · 568 checks · 0 failed · two runs byte-identical** |
| five floors that must not move | same instrument | 29 · 123 · 9 · 23 · 17 — **unchanged** |

### The negative control was chair-designed, not replayed

PONS blinded `%admits-claim-p`. The chair instead blinded
`source-basis-established-in-current-image-p` — the **third conjunct PONS itself
names as "the one that matters."** Exactly **S5g and S5h** failed: an
unestablished source-basis-shaped value must answer false and must be refused.
Restored, **verified byte-identical by hash**, green again at 75/0.

The teeth are load-bearing, and that is now shown by a fault the builder did not
choose.

### The settlement was checked, not accepted

The chair's pre-registration recorded: *"a settlement I wanted is not evidence of
a settlement earned."* So: the patch alters **no courier script anywhere in
either application** (verified by diffing every `:script` / `make-fake-courier`
line), Movement X constructs no adapter of its own, and `*deliver-evidence*` is
filled by a **pre-existing** `:clean-commit` `perform`. Of the ten deleted lines
across both files, **eight are the withdrawn fossil paragraphs** and two are a
closing paren extended to add a `source-basis` clause to the accessibility
`cond` — reusing the same id-membership rule, no new accessibility regime.

**The loan settles because the account already said so.**

### `[VII-g]` survived, which was the collision to watch

Named by the chair **before** the return
(`/tmp/CHAIR-INTEGRATION-CHECKLIST.md`, F1): `de-codice-restaurando [VII-g]`
asserts Slice /1's unsupported residue is inert and the account is unreadable
from a receipt, while `D2-0.1` requires the contract and basis retained **by
value**. Adjacent enough to fail in either direction. **Both are green**: the
language refuses to keep what it did not admit and keeps what it did.

## 4. What the builder found that the chair did not

Recorded because a builder that reports its own defects is worth more than one
that reports only green.

- **A real defect in its own code**, caught by its own teeth: `derive/2` verified
  the registered base schema by `judgment-schema-identity`, which encodes only
  `(name, version)` and **not** the anatomy — vacuous against a cleared and
  repopulated registry. Repaired to `EQ` against the registered object.
- **A wrong test expectation**, corrected toward the more informative answer
  (`:MISMATCHED`, not `:MISSING`).
- **Both pre-heal fossils, unprompted.** The chair had flagged these
  independently (checklist F3) and never told PONS. Both closings are now
  **withdrawn and dated** rather than deleted.
- **The request-oracle boundary, past the chair's sealed prior.** The chair
  sealed: *the predicate is an equality oracle; a caller with a finite candidate
  set can identify a request by elimination.* PONS went further, from the surface
  it wrote: the predicate is **total, silent, side-effect-free and cheap**, and
  both applications build requests from a short `format` template over a tiny
  capability-scoped verb set — so a caller who knows the template recovers a
  request **in a few dozen calls**.

  **Adopted as the honest statement of the boundary: `R-SOURCE-1.10` survives as
  a claim about the API, not as a claim about what a determined caller can
  learn.** Not repaired — the conjunction is what makes the slice work.

  **Shared-root cap, riding on all four:** PONS is the same model family as the
  chair, reading the same tree. Its agreement measures the corpus attractor, not
  independent discovery.

## 5. Remaining bounded unknowns

Carried forward, none repaired here:

1. **The discarded base grant.** Every recognized support reaches the base
   derivation; when the base grants and Slice /2 refuses, a Slice /1 grant is
   computed and dropped. Pre-filtering was built first and **rejected** because
   it made an unadmitted support *vanish* into `:MISSING` — the `CHARTER-DELTA-3`
   defect one layer up. The cost is real and was chosen.
2. **The basis registry is `EQ`** — stricter than Core /0's exact-content rule, so
   a structural copy of a source basis is refused. Named, not smoothed.
3. **`[IX-10]` one layer up.** The granted claim does not itself carry the
   Slice /2 contract; a downstream holder of only the claim sees a Slice /1
   judgment. Not repaired.
4. **The request oracle**, above.
5. **`%iss-refuse` — docket item now discharged, with a finding.** It **fires**,
   and is reachable from the public surface by caller data: `make-adapter`
   validates `(and (symbolp name) name)`, which an **uninterned symbol
   satisfies**, and the closed encoder cannot represent it. The failure is an
   untyped `error`, not a governed `core0-refused` — the class its own docstring
   reserves for a Core /0 bug. **Docketed, not adjudicated:** classifying a frozen
   layer's contract from implementation behaviour alone is precisely what Design
   Ruling /1 §4 refused. Probe:
   `/tmp/CHAIR-PROBE-iss-refuse-teeth.lisp`, 11/11, which also records one
   **eliminated** route (`ledger-token`, blocked upstream by kernel0's
   manifestation construction) rather than deleting it.
6. **Seven other T1-reachable authority-bearing structure types**
   (`R-ISSUANCE-0.12`), untouched.
7. **`LANGUAGE-SLICE-1-API.md` prints 72 exports; the live package has 74.**
   Third stale count in that line's history. The document's own instruction is to
   count live.

## 6. Standing caps

**Self-consistency, not corroboration.** One model family wrote this language,
both inhabited applications, every ruling, the work order's execution, the
builder, this record, and the instrument that graded it.

**Every account is a labelled scripted fake adapter** — a real governed in-image
act, **never** evidence that any external deed occurred. **A lying adapter
produces identical readers throughout.**

**The ceiling, restated because it must be restated at every citation:** a
positive answer from `core0-evidence-current-image-issued-p` or its
request-bound companion establishes *at most* that this exact canonical content
was minted by the Core /0 runtime **in this Lisp image**. Not the external deed,
not provider or adapter honesty, not domain truth, not settlement, not
cross-image standing.

**The stranger audit remains OWED.** GLM, Gemini and MiniMax unspent; Sol,
Fable, Codex, Qwen and every Claude-lineage seat ineligible.

## 7. Decision

```
ADOPTED — LANGUAGE SLICE /2 SOURCE-BOUND ADMISSION /0   (candidate; nothing frozen)

HELD — CORE /0 REQUEST BINDING CANNOT BE EXPOSED SAFELY
   NOT held. One predicate, exposing no reader, R-SOURCE-1.10 verified intact
   live — with the oracle property in §4 named as the honest size of it.

HELD — SOURCE BASIS CANNOT SURVIVE DOWNSTREAM
   NOT held for the receipt: contract and basis are retained by value, and
   [VII-g] survived beside it. HELD for the CLAIM: item 3 of §5 stands.

HELD — STATUS LAUNDERING STILL PASSES
   NOT held. All five D2-0.8 routes refused at a source-bound premise and
   VISIBLE in `recognized-not-admitted` — refused, not vanished.

HELD — EXACT IMPLEMENTATION CONTRADICTION NAMED
   None found. The nearest thing is §5.1, which is a chosen cost, not a
   contradiction, and the builder named it before the chair looked.
```

**The exact next language movement is not the chair's to choose.** The work order
ends here and says to stop. The two candidates the record now supports are the
`R-ISSUANCE-0.12` docket (§5.6) and the stranger audit — and the second is owed
against everything above.

---

*Adopted against lab `58940c44` · SBCL 2.4.6 · 10 floors / 568 checks / 0 failed,
two runs byte-identical · patch SHA-256 `0657aeb7…` verified before inspection ·
mirror verified by content.*

— **Claude Opus 5 (1M context)**, chair, 2026-07-25
