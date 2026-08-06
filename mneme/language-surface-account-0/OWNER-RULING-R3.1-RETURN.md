# SURFACE ACCOUNT /0 — OWNER RULING: RETURN R3.1 (bounded repair)

*Received 2026-08-05 from the lab owner (Tomás P. Pavan), filed verbatim by the chair
(Claude Fable 5) — sandbox artifact paths preserved as received. This document is the
governing law of the R3.2 repair round.*

---

## Owner ruling — RETURN R3.1

Custody is accepted; technical closure is not.

| Area | Ruling | Basis |
|---|---|---|
| Custody | **PASS** | SHA-256 matches; all 529 non-self manifest rows verify; bundle is the exact linear four-commit delta from `a2bdb061…` to `4f2ecbc9…`. |
| Schema totality | **RETURN** | Native `detail` is defined as a string-or-standing union, but the exact branch table says string only. NIL/1024 witnesses validate a datum, not a complete recognized record. See [schema](sandbox:/workspace/scratch/72427f1bb7e2/r31_unpack_20260805/CD0-INSPECTION-RECORD-SCHEMA.md) and [schema witness](sandbox:/workspace/scratch/72427f1bb7e2/r31_unpack_20260805/probes/probe-schema-witness.lisp). |
| Identity law | **RETURN** | Representation is 16 octets, but only eight are OS-random entropy; concurrent/re-entrant initialization is neither safely implemented nor tested. See [identity probe](sandbox:/workspace/scratch/72427f1bb7e2/r31_unpack_20260805/probes/probe-identity.lisp), lines 67–93 and 106–167. |
| Refusal taxonomy | **RETURN** | Door-1 has no precedence for overlapping defects; operative prose wrongly calls provider refusals Account-owned. Current 20/29 provider catalogues and five composite codes otherwise enumerate cleanly. See [jurisdiction](sandbox:/workspace/scratch/72427f1bb7e2/r31_unpack_20260805/REFUSAL-AND-CONDITION-JURISDICTION.md). |
| Transcript grammar | **STRUCTURE PASS; PROVENANCE RETURN** | Profiles, counts, planted failures, CR/tab/footer teeth, deterministic repeat, and specimen suite pass. But [verify-transcript.sh](sandbox:/workspace/scratch/72427f1bb7e2/r31_unpack_20260805/probes/verify-transcript.sh), lines 252–266, omits `GIT_NO_LAZY_FETCH=1`; a wholly local promisor repository caused the verifier to import a missing tip and then accept it as "physically present." |

I therefore:

1. **ACCEPT parcel custody** at tip `4f2ecbc94719fe1080b40dc6cb7c73b4ee060b64`.
2. **RATIFY exactly** `85a33ca5`, `1dbdefbf`, `a736742f`, `3ada23c7`, `6a854368`, and `ca4a7d1c` as ledger-only custody dispositions—not design acceptance or precedent.
3. **RETURN R3.1 for bounded repair.** Do not adopt, merge, declare terminal closure, or open Surface /3.

Required repairs: reconcile the `detail` schema and construct full records; bind Door-1 precedence and correct ownership; supply 16 actual entropy octets and re-entrant-safe once-only initialization with hostile tests; set `GIT_NO_LAZY_FETCH=1` inside `git_clean` and add a promisor specimen.

Nonblocking errata: the ZIP has 530 regular files but 537 members including directories; correct the citation-count header fossils. No network action was performed. The shell/parser gates were freshly rerun; no Common Lisp runtime was installed, so Lisp execution evidence was reviewed statically against the supplied SBCL transcripts.
