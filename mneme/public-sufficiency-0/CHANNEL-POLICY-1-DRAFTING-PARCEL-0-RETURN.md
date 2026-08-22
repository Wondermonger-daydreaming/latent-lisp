# CHANNEL POLICY /1 — R-1 INCORPORATION DRAFTING PARCEL /0 — RETURN

**Constructed by the chair (Claude Fable 5), 2026-08-13, on the owner-relayed
drafting commission (relay archived:
`corpus/voices/received/2026-08-13-sol-channel-policy-1-drafting-commission.md`).
Drafting only: nothing adopted, published, merged, synchronized, or
repaired; the held D-4 draft untouched as historical evidence; R-3/R-4/R-8
expressly NOT decided (candidate §9). Status:
CHANNEL POLICY /1 — R-1 INCORPORATION CANDIDATE /0 — NOT ADOPTED.**

## 1. The candidate

`mneme/architecture/CHANNEL-POLICY-1-latent-lisp-mirror-CANDIDATE.md` —
finite (nine sections, two tables), candidate-bannered, anti-bootstrap
stated, R-1 controlling on ambiguity. The held draft's file was not edited.

## 2. Held-D-4 → /1 conceptual concordance

| Held draft (2026-07-18) | /1 candidate | Disposition |
|---|---|---|
| Model A: "a commit whose diff touches source-scope IS the publication act" | §1/§2: commit creates NO publication state; authorization is an owner act; published = authorized ∧ verified transport | **REPLACED by R-1** (the clause FRIGUS found empirically false 81-fold is gone, not patched) |
| "Known deviation": *authorized at commit*, failed settlement = unsettled effect | §6 failure states: authorization is an owner act, not a commit side-effect; failures reportable in exact terms | **REPLACED by R-1** |
| `:propagation-mode :automatic-detached`, rsync `--delete`, working-tree source | §7: git-archive of committed subject tree, ancestry guard, sentinel — DESCRIPTIVE only | **RE-TRANSCRIBED against the current machine** (FRIGUS R-5) |
| `:authorized-principals` (owner · chairs · six siblings · Codex-via-adoption) | §4 carried | **COPIED** (verbatim in substance) |
| `:content-prohibitions` (5 items) | §4 carried | **COPIED** |
| `:amendment-authority` / `:amendment-rule` (A-3, no silent enlargement) | §4 adapted (new policy-identity per enlargement) | **ADAPTED** |
| `:review-trigger` (redraft before changed hook runs) | §4 adapted **with a discharge mechanism** (successor candidate or dated erratum; undischarged = reportable defect) | **ADAPTED** (cures FRIGUS R-9: the old trigger fired 4× unperformed with no discharge form) |
| anti-bootstrap ("operative only upon adoption") | §4 carried and sharpened (transport of the text confers nothing) | **COPIED+SHARPENED** |
| `_staging/**` exclusion; off-mirror stricter channel note | §7 carried | **COPIED** |
| — (word "published": 0 definitions in the held draft) | §1 single-sense definition + §3 prohibited substitutions | **NEW, consequence of R-1** (cures FRIGUS R-2) |
| — (no standing-of-mirrored-text clause) | §2.5 + §6 (presence confers nothing) | **NEW, consequence of R-1** (answers FRIGUS R-3's principle; marker residue stays owner's) |
| — (no commencement/savings) | §9 R-4 placeholder; **adoption blocked on R-4** | **RESIDUAL, owner-only** (FRIGUS R-4) |
| — (no failure semantics) | §6 table (six states, exact reporting language) | **NEW, consequence of R-1** (cures FRIGUS R-6) |
| — (verify-sync unmentioned) | §5.3 content-verification requirement | **NEW** (cures FRIGUS R-7) |
| — (out-of-scope-dependency class) | §9 R-8 residual | **RESIDUAL, owner-only** (FRIGUS R-8) |
| — (moving counts) | none baked anywhere | **R-10 discipline observed** |

**FRIGUS R-1..R-10 disposition summary:** R-1 ruled by the owner; R-2, R-5,
R-6, R-7, R-9 repaired in the candidate as consequences of R-1 + current
machinery + adopted standing law (provenance above — no new doctrine
invented); R-3/R-4/R-8 held as owner residuals; R-10 observed. Plus one
surface FRIGUS numbered R-2 implicitly split: **R-2b** (evidence
sufficiency/receipt form) surfaced as a NEW residual rather than smuggled
into §5 — R-1 fixes that verification is necessary; the sufficient
standard is the owner's.

## 3. R-1 exact-carriage proof

Candidate §2 items 1–6 against the filed disposition, clause by clause:
authorization-as-durable-standing (disposition ¶1) · published-only-on
verified transport (¶1) · adoption orthogonal (operative wording) · guard
withholds transport, never authorization, never adoption (¶1) ·
mirror-presence-confers-nothing (¶4) · unreached-reported-as-unreached
(¶2). No clause of the candidate broadens R-1; §5 marks the one place
where breadth was *tempting* (evidence sufficiency) and refuses it into
R-2b. The candidate cites the disposition as controlling on any two-way
reading (header).

## 4. State-machine and failure-state tables

In the candidate itself (§1, §6) — six states, none collapsed, each with
kind / creator / proof / supersession; six failure states with exact
required reporting language. No extra standing was invented for mechanical
intermediates (transport-attempted exists only inside §5's evidence, not
as a standing).

## 5. Policy obligations presently unimplemented/violated (TD-linked; not sanctified)

Enumerated in candidate §7: exclusive-writer expectation ↔ **TD-6**;
transport-failure surfacing (§5.2) ↔ **TD-7**; merge-path commit
identification ↔ **TD-8** (**hard pre-merge blocker, restated**); durable
withholding records for §2.6 reporting ↔ **TD-9**. The clauses stand as
law the machinery must grow into; the docket carries the defects.

## 6. Residual owner-fork docket

Candidate §9: **R-4** (commencement/savings — BLOCKS adoption) · **R-2b**
(evidence sufficiency + receipt form — blocks the first attachment of
published standing) · **R-3 residual** (standing marker) · **R-8**
(partial transport treatment).

**Recommendation (marked as such): rule R-4 next.** Grounds: it is the
only residual that blocks adoption of the candidate itself; R-2b blocks
nothing until a publication act is actually attempted (which TD-8 already
blocks mechanically); R-3/R-8 can trail the first publication. Sequence
thereafter unchanged: TD-6..9 repair → TD-8 demonstrably dead → owner-gated
main integration → verified publication receipt (R-2b ruled by then) →
PS/0 far-side readback.

## 7. Delta / identities (for a cold policy read)

New files (2): the candidate (blob recorded in the parcel commit) and this
return. Modified: none — **the held D-4 draft is byte-untouched** (its
blob unchanged in git; assert with `git status` / `git log -1 --
<draft-path>`). No implementation, tooling, or law text of any other lane
touched. **Earned: nothing** — a candidate policy is a text with no
operative force; zero evidence; nothing published; stranger audit OWED.

*— Claude Fable 5, chair, 2026-08-13.*
