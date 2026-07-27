# LANGUAGE FORM /0 — OWNER RULINGS

*The rulings that govern this lane, recorded here so a stranger does not have to
reconstruct them from commit messages. Documentation only — no executable change
accompanies this file.*

---

## RULING 1 — Package-controlled installation: the stronger reading (option i)

**Affirmed 2026-07-26.** For Language Form /0:

- **no public operator-descriptor constructor exists;**
- no public operation accepts a host function or handler closure;
- `MAKE-FORM-ENVIRONMENT` accepts only **names** selecting package-owned
  built-in operators;
- operator resolution remains a **closed package-owned mapping**;
- ordinary callers are **selectors** of Form /0 operations, **not constructors
  of operator behaviour.**

`MAKE-OPERATOR-DESCRIPTOR` is not to be restored, and no public
allowlist-checked descriptor constructor is to be added.

### Why the two readings are not equivalent, even today

Enforcement is equivalent for the present four operators. **Public semantics are
not.**

> **Option (ii)** — a public constructor with an allowlist — declares operator
> construction to be *a caller role governed by policy*.
>
> **Option (i)** — no constructor at all — declares operator construction to be
> *outside Form /0 entirely.*

An API is not merely the set of attacks that presently fail; it is a declaration
of **which roles callers are entitled to inhabit**. A public descriptor
constructor appoints ordinary callers as would-be operator manufacturers and
then posts a guard at the factory door. Removing the factory says that
manufacturing operators is not part of Form /0's social contract at all.

**Form /0 adopts the latter.**

### The consequence, accepted and intended

A future **trusted-extension lane** — *a trusted host deliberately teaching the
form system new operators* — **must enter through a separately named public
protocol.** It may reuse internal machinery (normalization, identity
composition, descriptor validation, realization), but it may **not** be created
by relaxing `MAKE-FORM-ENVIRONMENT`'s operator argument or by widening the
package-owned dispatcher.

It must carry a visibly distinct constructor, descriptor species, environment
species, installation receipt, or equivalent boundary, sufficient to keep three
things apart:

```
Form /0                    untrusted forms selecting package-owned behaviour
trusted-extension lane     trusted host code explicitly installing new behaviour
authority lane             consequential operations petitioning Lisp+ authority semantics
```

This is the right kind of later work. A new constructor **forces** the project to
answer what widening an allowlist would quietly evade: who is trusted to install
the handler · what identity commits to its implementation · is installation
durable or image-local · can an extension be revoked · does the environment's
species disclose that host behaviour is present · what is the replay story.

**Form /0 does not pre-answer those by leaving a temptingly generic socket in the
wall.** No design for the latter two lanes is authorized now.

---

## RULING 2 — The instrument finding, and the stranger's preflight

**Accepted 2026-07-26.** Recorded because it changes how this lane should be
audited:

> **In this lane, the longest-lived defects were misreports by instruments
> rather than failures of the underlying semantics.**

The evidence, across three rounds:

| instrument | how it misreported |
|---|---|
| identity display | truncated four distinct identities into one appearance — and told the chair so, in a filed return |
| floor runner banner | printed *"3 floors"* while executing two |
| floor runner banner | advertised limits L-1/L-2 as open after they were closed |
| mutation battery | five "kills" that were five identical missing-file crashes |
| mutation count | a flat total that treated an early death as evidence for a tooth it never reached |
| export census | two greps disagreeing (86/87) on a number the closure had asserted as 72 |

None of those were wrong code. **All were instruments lying about the code.**

In this project instruments are part of the **epistemic runtime**: they
determine what chairs believe happened, which gates appear closed, and whether a
defect is promoted into a finding. A banner that hallucinates a floor count is
not ugly output — it is **a small false witness.**

### The stranger audit must begin with an instrument preflight

**Distrust the ushers before judging the play.** Do not begin by trusting
banners, abbreviated identities, generated censuses or aggregate mutation
counts. At minimum, independently confirm:

1. that **reported floors were actually executed** — not merely counted;
2. that **displayed identities discriminate** the full identities they abbreviate;
3. that the **generated export and mutation ledgers match** the live package and
   the live suite;
4. that **every counted mutant changed the intended source** *and* **reached the
   intended tooth**;
5. that **aggregate counts derive from actual verdicts** rather than being
   maintained separately.

Each of these corresponds to a defect this lane actually shipped and later
caught. They are not hypothetical.

---

## Standing after these rulings

```
Language Form /0 Candidate /0   MERGED to main as a CANDIDATE IMPLEMENTATION
adopted                          no
specification-frozen             no
authoritative language suite     NOT added — verify-form-floor.sh stays separate
standing publishable             self-consistency certification, nothing stronger
stranger audit                   OWED
Form /1                          NOT opened
trusted-extension lane           NOT opened
authority lane                   NOT opened
```

Merging is **not** adoption. It places Candidate /0 in the workshop as a real
piece of it, and nothing more.

— recorded by **Claude Opus 5 (1M context)**, 2026-07-26

---

## ADDENDUM — the species behind the six misreports (owner, 2026-07-26, at close)

The six instrument failures in Ruling 2 were filed as a list. They are not
miscellaneous accidents. They are **one defect wearing six costumes:**

| costume | what happened |
|---|---|
| **representation collapse** | distinct full identities rendered indistinguishably |
| **execution/report divergence** | the banner claimed more floors than ran |
| **stale declaration** | closed limitations remained advertised |
| **common-cause false kills** | mutants died from the harness, not their mutations |
| **evidence misattribution** | a death *before* the intended tooth credited *to* that tooth |
| **publication-state ambiguity** | hooks and logs implied a sync history without proving present public equivalence |

> **In every case a secondary representation stood in for the underlying event
> and quietly became more authoritative than the event itself.**
>
> The banner impersonated execution. The abbreviation impersonated identity.
> The exit code impersonated a semantic kill. The sync log impersonated
> publication.

**And the reflexive symmetry, which is the finding's real weight.** Form /0
exists to refuse exactly this — a datum impersonating a proposal, a proposal
impersonating a validation, a validation impersonating an authorized act. Its
own instruments then committed that sin *around* it, while reporting that the
law held.

**Operational consequence.** The instrument preflight is not a separate
discipline bolted onto this lane; it is **Form /0's own law turned on Form /0's
own reporting.** Every misreport above is a phase transition taken without a
re-check at the boundary: a representation admitted as authority because it
*looked* like the thing it stood for. An auditor may therefore structure the
preflight the way `realize-form` structures realization — refuse to accept any
summary until the thing it summarizes has been independently re-resolved.

### Two additions to the stranger's brief

**(a) Audit the PUBLIC MIRROR, not the lab repository.** The outside read must
begin from a fresh clone of `github.com/Wondermonger-daydreaming/latent-lisp`.
The public repository is part of the claimed result and must not be left outside
the audited causal chain.

**(b) The mirror's correctness rests on a topology, not a hook.** Reproduce one
publication transition, or inspect both hook paths:

```
ordinary commits   → post-commit path
merge commits      → post-merge path      (git skips post-commit on merges)
main-only guard    → branch work stays unpublished
content verifier   → logs are never treated as proof
```

That machinery is **not to be altered now.** It is to be *verified* by someone
who did not write it.

### Standing, restated at close

Candidate /0 sits on `main` as a completed experimental organ. **Form /1, the
trusted-extension lane and the authority lane remain unopened**, and the
workshop being warm is not a reason to open them. The next meaningful event in
this lane is the stranger audit. The preserved branch `language-form-0` and its
worktree remain as provenance fossils until that audit closes.

---

## RULING 3 — the stranger audit is ACCEPTED AND FILED (owner, 2026-07-27)

The independent audit by `x-ai/grok-4.5` (snapshot `x-ai/grok-4.5-20260708`, via
OpenRouter, provider xAI, no fallback) is **accepted as claim-directed stranger
corroboration** of Candidate /0 at the exact published target:

```
public commit  5ed23c7d5f768d8e8f13c83842f572cf563270d3
root tree      e0950634a7b0791ea58db2463928f6a4e68a6521
subject tree   a0941e749cf0fb23de74de811ca69e1447d397c1
```

**Verdict: `FINDINGS — CANDIDATE REMAINS CONTINUABLE`.** No reproducible semantic
finding. No reproducible public-API finding. 59 independently written probes, 0
failures. Report `GROK-FORM0-STRANGER-AUDIT.md`, 29,719 bytes, sha256
`226c6e435c5e6b6c0cfd3bcc84dc9eef44edbe9d60bc0a73235bb35b9619cb70`.

**The stranger-audit debt is satisfied for that subject tree and no other.** Any
later executable change to Form /0 creates a new audit delta.

**What this does NOT do.** It does not adopt Form /0, does not freeze the
specification, does not establish external-standard conformance, does not prove
process isolation, and does not prove anything against arbitrary Common Lisp
already executing in the image. Successor dependence is permitted
**experimentally**, with the named limitations carried forward.

**Three rulings on how to cite it.**

**(a) State the epistemic class as *independent claim-directed corroboration*** —
never as blind discovery. The commission named B1–B14 and disclosed the instrument
history in advance. That does not weaken the corroboration; it fixes what kind of
evidence it is, and citing it as anything wider is an inflation.

**(b) B7 keeps its exact shape.** *Five components bound and rechecked; three
publicly perturbable; two structurally non-forkable through the public API.* The
auditor drove identity-, version- and content-drift refusals through the public
surface; grammar identity and resource policy cannot be varied by the public
constructor at all. **Do not round this up to five independently demonstrated
external residual codes.**

**(c) The mutation headline may not travel alone.** *"10 planted, 10 killed"* is
numerically true and epistemically compressed. The distribution is **7** named
failures at the intended tooth, **2** deaths through a different CD/0 marker near
the relevant path, **1** death before its tooth — so `literal-descends` does not
demonstrate `T-ONE-PASS` (`two-pass-substitute` does). This is an
instrument-reporting limit on what the battery *establishes*, **not a semantic
defect**, and it is **docketed as an optional future instrument refinement — not a
repair gate.**

**The model's contradictory self-identifications are not routing evidence.** Two
probes claimed two different wrong identities while every routing field held
constant. Preserved as a recorded anomaly; the OpenRouter generation record is the
auditor-identity basis.

Full standing record and the three filed artifacts:
`audits/2026-07-27-grok-4.5/LANGUAGE-FORM-0-STRANGER-AUDIT-INTAKE.md`.

— recorded by **Claude Opus 5 (1M context)**, 2026-07-27, under owner ruling
