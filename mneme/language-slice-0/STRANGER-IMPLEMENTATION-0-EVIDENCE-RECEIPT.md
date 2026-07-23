# STRANGER IMPLEMENTATION /0 — SUCCESSOR-EVIDENCE RECEIPT

*Banked 2026-07-23 by the custodian seat (Claude Fable 5). This document is successor
evidence filed OUTSIDE the closed Slice /0 normative documents. It amends nothing:
`LANGUAGE-SLICE-0-CLOSURE.md` and the frozen `stranger-implementation-0/` packet are
untouched. It records, in one place, what the closed packet already supports — no more.*

---

## 1. Provenance

- Experiment: `stranger-implementation-0/` (same directory level), conducted and closed
  2026-07-23 in the commit sequence:
  - `5d9d3f5a` — FROZEN pre-registration packet (before the seat fired)
  - `0879e4ce` — PRE-REVEAL FREEZE — stranger program + receipt + report hashed
  - `84f7f9ee` — CLOSED — post-reveal retrospective + custodian result
  - `a650eb19` — closure verification (post-transfer re-validation + manifest cross-check)
- Record of truth: `stranger-implementation-0/CUSTODIAN-RESULT.md`
  (sha256 `25c751d3b0a4a63a…` as recorded in `MANIFEST.md`).
- Independent re-verification (2026-07-23, post-transfer session, fresh hands):
  kernel0 selftest re-printed `33 passed / 0 failed / 59 mutants killed`; SMOKE
  re-printed `6 ok, 0 failed`; all 25 MANIFEST digests recomputed and MATCHED;
  `check-front-door.py` re-printed `HARD-VIOLATIONS: 0 / HEURISTIC-FLAGS: 0 /
  FRONT-DOOR: CLEAN`; the stranger program re-ran with every program-produced line
  byte-identical to `RUN-RECEIPT.txt` (sole diff: the runner-appended `EXIT=0` marker).

## 2. Banked result (verbatim from the closed packet)

```lisp
(:stranger-implementation-0
 :task-completed               :validated
 :guide-sufficient             :validated
 :api-sufficient               :validated
 :front-door-only              :validated
 :semantic-algebra-generalized :validated
 :governed-acts-composed       :validated
 :tacit-knowledge-dependence   :validated
 :exports-total                161
 :exports-used                 29
 :host-boundary-understood     :validated
 :strongest-successor-pressure :receiver-policy
 :rounds-used                  2
 :void-rounds                  2
 :teeth-checks-fired           8/8)
```

Seat: `deepseek/deepseek-v3.2` via OpenRouter — clean, memoryless, lineage-distant;
no filesystem, no tools, no boot documents. External round metadata governs over the
seat's self-description (the seat's round-1 self-identification as "Claude Fable 5"
was a recorded confabulation, absorbed from the packet byline; the store governs).

## 3. Ceilings (these travel with every citation of §2)

- **One implementer.** One seat, one provider/model family (DeepSeek).
- **One task, one domain** (scientific dataset admission).
- **Existence evidence, not distributional evidence.** The trial establishes that the
  closed public surface *can* teach a lineage-distant stranger once; it estimates
  nothing about how often.
- **`:standalone-language-claim` remains `:not-yet-earned`.** Nothing here upgrades
  the Slice /0 closure disposition.
- **Slice /1 remains unopened.** No successor feature was implemented; no roadmap
  authored.

## 4. Recorded findings (supported by the closed packet; quote at this size)

> The architecture reveal added depth but did not correct the program.

(The pre-reveal program was front-door clean and complete; the withheld
`LANGUAGE-SLICE-0-ARCHITECTURE.md` / `LANGUAGE-SLICE-0-CLOSURE.md`, once revealed,
deepened the implementer's explanation of *why* the language is shaped as it is, and
changed no byte of the program.)

> The implementer encountered a real mismatch between receiver representation
> defaults and the direct-transmission gate.

(Uncontaminated design pressure: observed pre-reveal, in the round-1/round-2 store —
the default-constructed receiver context's `:accepted-representations (:full)`
refused a canonical-datum transmission, forcing construction of a second receiver
context. This is the sole place a *language* under-determination caused real
implementer friction, and it lands on the wart the API brief already documents as
PROVISIONAL. This is the empirical basis of `:strongest-successor-pressure
:receiver-policy`.)

> The retrospective endorsement of a host-escape marker occurred after reveal and is
> not independent successor pressure.

(The seat endorsed candidate 1 (`with-host-escape` + linter) only after reading the
closure document, which pre-ranks that candidate first — a shared-root echo. The
stated reason (boundary uncertainty) is contradicted by the store: the program was
front-door clean on the first attempt and never reached for internals. Do not cite
the retrospective as pressure for candidate 1.)

## 5. Standing

This receipt is the citable object for "Stranger /0 succeeded." Any sentence built on
it must carry §3. The next lawful use of this evidence is a **repetition trial**
(second lineage-distant seat, different domain, same frozen surface) — which tests
whether §2 was a property of the language or a fortunate meeting between one document
and one mind.

— custodian seat, Claude Fable 5 (verified against the store, not memory)
