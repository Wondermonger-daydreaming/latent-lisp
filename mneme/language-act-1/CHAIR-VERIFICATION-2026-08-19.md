# One Act /1 — Chair Verification (2026-08-19, same night as the build)

*Claude Fable 5 (1M context), the commissioning chair. Same-family caveat travels:
builder (PONTIFEX, Opus subagent) and chair are one lineage, fresh-context only —
nothing below is independent verification, and the outside has not read this lane.*

## Third-hand re-runs (chair's own shell, latent-lisp root, exits captured directly)

| Gate | Chair exit | Chair-observed result line | Matches builder |
|---|---|---|---|
| act1-selftest | 0 | `oneact1-selftest: 37 checks, 0 failures` | ✓ |
| act1-controls | 0 | `oneact1-controls: 11 controls, 11 caught, 0 missed` | ✓ |
| act1-mutants | 0 | `oneact1-mutants: 3 defects, 3 killed, 0 survivors` | ✓ |
| act1-red-proof | 0 | `oneact1-red-proof: cured PASS, uncured FAIL — the tooth bites` | ✓ |
| de-actu-resurgente | 0 | `49 checks, 0 failures / RESULT: PASS` — chair transcript **byte-identical** to committed `RUN-SPECIMEN.txt` (third reproduction; builder ran twice) | ✓ |
| act0 regression | 0 | `oneact0-selftest: 173 checks, 0 failures` | ✓ |

Consumed lanes untouched, chair-verified rather than trusted: `git status
--porcelain` and `git diff --stat` over act0 · core0 · journal0 · capability0/1/2 ·
kernel0 · canonical-datum · `lisp-plus.asd` · `verify-release.sh` — both EMPTY.

## Claims pass (the work order §7 censor-style read, one pass, chair-applied)

**No blocking claims found.** The RETURN carries the ceiling verbatim, downgrades
its own demonstration 3 to PARTIAL where a lazier document would have claimed
SHOWN, names the over-determination of its crown refusal in its own transcript,
and closes with "nothing in it is independent verification." Two non-blocking
scope notes, recorded here rather than edited into the builder's document:

1. **"Pays One Act /0's deferred D1 debt" is true at THIS lane's scope only** —
   the runtime door's refusal (typed `cap2` condition + facet
   `:fresh-derivation-refused` + requirement `CAP2-AUTH-1`) is demonstrated by
   /1's arm R; One Act /0's own adoption record and vector set are unchanged, and
   nothing about /0's standing moves. Read "paid" as "demonstrated in the
   successor," never as an /0 amendment.
2. **Demo 2's named gap stands as named:** no arm presents a *stale* capability
   across the death (nothing in this design can carry one across a process
   boundary); that path remains owned by capability /1 and de-effectu-incerto.

## Standing after this verification

**One Act /1 is a CANDIDATE: constructed · tested · chair-re-verified (same
family) · committed · NOT registered on any floor · not audited · not adopted ·
not frozen.** Registration in `lisp-plus.asd` (completeness-checked class;
`act1-api-complete-p` is the ready predicate) and `mneme/verify-release.sh`
(additive candidate rows, act0-row precedent) is deliberately DEFERRED to a fresh
session or the owner's word — a shared release-umbrella edit at the end of a long
build session is exactly where mistakes land, and the lane is fully runnable
through its own door (`load.lisp`) meanwhile.

## Owner docket (carried from §9 of the RETURN, chair-endorsed, report-not-patch)

- act0 `package.lisp:7` standing header stale-conservative since the 08-08 adoption.
- `verify-release.sh` carries both the pre-adoption act0 comment (~:104-112) and
  the ADOPTED `seam` row (~:228) in one file; the floor's own doctrine gates the
  edit on a ruling.

*— the chair, before the closing commit, sentinel raised throughout (every commit
of this arc harvested as a truthful WITHHELD; nothing published, nothing
transported).*

---

## ADDENDUM — repair-round chair verification (2026-08-20)

Sol's blocking finding (archived `corpus/voices/received/2026-08-20-sol-…-blocking-finding.md`)
was chair-confirmed on disk BEFORE commissioning (the `(error (c))` clause read exactly as
Sol read it). PONTIFEX's repair (`c8a5f31a` RED → `52011c98` repair) chair-verified:

**Third-hand re-runs, post-repair (exits captured directly):** selftest 37/0 · controls
**14/14** (11 pre-repair; CONTROL 3b added three, two-halved so over-refusal cannot pass) ·
mutants 3/3 · crown red-proof cured-PASS/uncured-FAIL · **host-fault proof PASS** (planted
implementation fault → `:HOST-FAULT-PRE-FRONTIER`, no Outcome, no evidence, no reason
keyword, verdict slot unwritten, journal+world byte-unchanged with universe printed) ·
specimen 49/0, chair transcript **byte-identical** to committed AND to the pre-repair
capture (checked, not hoped: no specimen arm raises an unadmitted condition).

**Handler read by the chair's eyes** (`act1.lisp:860-893`): admits BY FAMILY —
`cap2-condition · cap1-condition · cap0-condition · pj0-condition · kernel0-condition`
(single-colon references; exportedness proven by the suite loading at all) · first clause
re-signals `act1-condition` unchanged (the lane's own violations can never be reclassified
into the refusal they complain about) · trailing `(error …)` → `act1-bridge-contract-violated`
`ACT1-BRIDGE-2`, no plist/Outcome/evidence/reason, verdict slot left unwritten ·
`core0-condition` deliberately not admitted (Core /0 is the caller), absence documented.

**The finding was sharper than filed:** the pre-repair reproduction
(`RED-PROOF-HOST-FAULT-BEFORE.txt`, exit 1) shows a `TYPE-ERROR` not only classified
`:REFUSED` but **issuing a fresh Core /0 evidence account for an act that never happened**,
with forged reason `:TYPE-ERROR/-` shape-identical to the legitimate
`:ACT1-DURABLE-GUARD/UNSAFE-RETRY/-` (the requirement-reader's `"-"` fallback was the
hiding place — now closed with cap0/pj0 branches). **Carry into Memory Layer /0's design:
a memory layer that treats issued evidence as durable-worthy would have inherited a record
of an act that never happened.**

**Claims pass on §11:** append-only discipline held (§2 row 6 + §7 counts carry dated
markers; two stale §10 file-list labels dated by the chair in this commit). Ops note: a
`session-checkpoint` Stop hook swept part of the repair into local-only `1c35fe23`
mid-flight — expected per §I-j, recorded in the repair commit body, never pushed alone.

*— the chair, before registration. Same-family caveat unchanged; the outside that found
this was Sol's cold static read — the repair itself has NOT been outside-read.*
