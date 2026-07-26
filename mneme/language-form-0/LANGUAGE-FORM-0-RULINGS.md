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
