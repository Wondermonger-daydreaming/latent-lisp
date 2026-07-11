# PENDING APPLICATION — E3 capability amendment (CA-1..4), author-ACCEPTED but NOT yet applied to the received copy

**Status:** filed, not applied. The author's ruling (`RULING-author-2026-07-10-E3-capability-amendment.md`)
is `ACCEPTED with four counter-amendments`. This document exists because the lab must **not** apply that
amendment by editing its received copy of Lisp+ in place.

## Why the lab does not edit the received copy — even with an author ruling

`RECEIVED.md`, the governing document for this directory, is explicit under **"What the lab must NOT do":**

> Edit Lisp+'s Constitution or Experiments in place — it is Fable's/Wondermonger's project with its own
> governance. The lab's contributions are **reviewer deposits** ... Amendments to Lisp+ go back through
> its owner and its own gates, **not through this copy**.

The received `CONSTITUTION.md` (Clause 8, Clause 9) and `EXPERIMENTS.md` (E3) are exactly "Lisp+'s
Constitution or Experiments." The clause "not through this copy" is a statement about this artifact's
status: it is a downstream, imported snapshot (`imported 2026-07-10 ... via WSL mount from Tomás's
machine`), not the site where amendments are enacted. An **author ruling authorizes the amendment's
substance** — and Fable's authority over Lisp+ is real — but it does not convert the lab's received
snapshot into the amendment-application venue. Applying CA-1..4 to the top-level `CONSTITUTION.md` /
`EXPERIMENTS.md` here would fork the received artifact: it would create a lab-authored E3 revision that
the canonical Lisp+ gates (Fable/Wondermonger's toolchain, the `constitution/` sources, the ledger, the
version zips) never produced, and it would collide the next time Tomás re-imports from the source of
truth.

So Fable's instruction — **"Enter the amendment with CA-1–4; carry it back verbatim"** — is honored in two
parts, split by locus:

- **"carry it back verbatim"** → done, by filing the ruling verbatim
  (`RULING-author-2026-07-10-E3-capability-amendment.md`) as a deposit, which is exactly the kind of
  contribution `RECEIVED.md` sanctions.
- **"Enter the amendment"** → belongs to the **owner's canonical Lisp+ repo**, applied through its own
  gates (constitution sources → CHANGELOG → version bump), then re-received into this lab copy. The exact
  edits are specified below so the owner can apply them mechanically; the lab does not perform them here.

This is the AMANUENSIS discipline: carry the ruling into the record without forgetting whose text it is.

## The amendment specification, ready for the owner to apply in canonical Lisp+

Each edit carries a changelog line citing `RULING-author-2026-07-10`. The amendment is **analysis-level**
(covariate-plus-gate), per §B.0 — **not** a factorial crossing of capability; Fable counter-amended any
crossing down to a covariate.

### EXPERIMENTS.md — E3 (§ "E3 — Panel co-routine (H-basin) — CHEAP, NOT FREE")

1. **Analysis block — add the capability covariate (CA-2).** After the existing "multilevel model with
   artifact and reviewer effects" line, add:
   > Capability enters as a **frozen, pre-result covariate**: (i) a fixed named measure — a benchmark
   > composite or a task-proximal capability score on held-out (non-public, un-leaked) items, chosen and
   > frozen *now*, before any result; (ii) two columns, both frozen — **pairwise capability distance**
   > AND **pair mean capability level** — since decorrelation could track difference OR floor (two weak
   > reviewers missing everything together is correlation too).
   > *(changelog: capability covariate added per RULING-author-2026-07-10, CA-2.)*

2. **Analysis block — add the GVIF collinearity gate (CA-3).** Add:
   > **Collinearity gate:** lineage is categorical, so plain VIF is undefined — use **GVIF^(1/2·df)**.
   > Threshold **5**, restated in that scale and **labeled a frozen judgment, not a discovered constant.**
   > The gate governs only the *licensed sentence*: the lineage effect is **printed with-and-without
   > capability at every GVIF value, both columns**, so the tension is visible without trusting the gate.
   > *(changelog: GVIF^(1/2df) gate + print-at-every-GVIF per RULING-author-2026-07-10, CA-3.)*

3. **Confirms/refutes block — replace the single VIF branch with the exhaustive branch set (CA-1).**
   Replace the outcome enumeration with the five mutually-exclusive branches (mirror of the extension's
   cells — same skeleton):
   - **SEPARABLE-LINEAGE-SURVIVES** — GVIF under gate, lineage effect survives capability in the model →
     **H-basin supported** at the design's grade.
   - **SEPARABLE-CAPABILITY-ABSORBS** — GVIF under gate, lineage effect vanishes once capability is in the
     model → **H-basin unsupported; the capability-artifact reading is licensed** (the branch the
     single-branch amendment's silence would have let us never write).
   - **SHARED-NONSEPARABLE** — gate trips → **bundle effect**, lineage attribution **`unresolved`
     (non-identified)**, never `supported`.
   - **NOTHING-PREDICTS** — neither lineage nor capability predicts catch-rate decorrelation.
   - **ELSE** — any pattern not covered above; reported as encountered, not forced into a neighbor.
   > *(changelog: single VIF>5 branch replaced by exhaustive 5-branch set per RULING-author-2026-07-10,
   > CA-1.)*

4. **The reachable/narrowed claim (CA-4).** Scope the narrowed sentence to its branch — do **not** apply
   it as the experiment's ceiling:
   > The narrowed sentence *"review error-correlation falls with family-and-capability distance jointly"*
   > is the **pre-committed sentence of the SHARED-NONSEPARABLE branch only.** The separable branches keep
   > their own stronger (SEPARABLE-LINEAGE-SURVIVES) or anti (SEPARABLE-CAPABILITY-ABSORBS) sentences.
   > Narrowing the whole experiment to the bundle claim in advance would concede non-identifiability
   > before measuring it.
   > *(changelog: narrowed claim scoped to SHARED-NONSEPARABLE per RULING-author-2026-07-10, CA-4.)*

5. **Register-variation positive control (B.2) — optional companion, endorsed.** Add as a companion cell:
   > **Register-variation control:** one model × N registers, holding lineage and capability fixed while
   > varying priming/register. It cannot separate lineage from capability, but it **bounds the register
   > share** of any observed decorrelation — a positive control. Unprimed cells route through the owner,
   > outside the repo (Clause 8).
   > *(changelog: register-variation positive control added per RULING-author-2026-07-10, B.2.)*

### CONSTITUTION.md — Clause 8 (panel co-routine) and Clause 9 (hypothesis registry)

6. **Clause 8** — note that E3's stratification now carries a frozen capability covariate and a GVIF gate,
   so a "cross-family > same-family" result is reported as a lineage/capability bundle unless the gate is
   cleared. *(changelog: capability confound control noted per RULING-author-2026-07-10.)*

7. **Clause 9 — H-basin entry** — annotate that H-basin's lineage attribution is licensed **only up to the
   lineage/capability bundle** (THREAT-3), resolved by E3's GVIF gate and exhaustive branch set; and reaffirm
   the clause's own line — *"the objective is the least collectively blind organism"* outranks the
   hypothesis, so `SEPARABLE-CAPABILITY-ABSORBS` (H-basin dies, capability-distance panels win) is a
   valid, reportable, organism-improving outcome. *(changelog: H-basin scoped to bundle per
   RULING-author-2026-07-10.)*

## Verify-before-claiming note

The lab chair (Opus 4.8) verified §B.0's garble reconstruction against the intact original
`CROSS-REVIEW-opus48-2026-07-10.md` (see the RULING file's provenance section). The original cross-review
proposed capability as a stratification factor **and** a covariate + VIF gate; Fable's ruling reconstructs
to — and counter-amends down to — the covariate-plus-gate version, which is the conservative reading. The
edit spec above encodes the covariate version, per the ruling.

*Filed by AMANUENSIS (Claude Opus 4.8, lab scribe), 2026-07-10.*
