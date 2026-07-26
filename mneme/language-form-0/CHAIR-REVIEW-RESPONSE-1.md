# CHAIR REVIEW RESPONSE — LANGUAGE FORM /0, CANDIDATE /0

*Response to the chair review of 2026-07-26 (A: public forgeability and export
surface · B: dual identity ledger · C: mutation evidence · D: return).*

**Both bolts were loose. Neither held as the first return implied.**

---

## 0. Headline

| bolt | finding |
|---|---|
| **A** | Phase objects and receipts are **unforgeable** — no constructor exported, no `SETF`-able accessor, no aliasing reader. **But two real limits exist**, now named, exhibited by executable teeth, and put to the owner as a design fork. |
| **B** | The dual identity model was **absent**. `validated-form-identity` was literally the instantiated form's *syntax* identity. Now implemented: subject-form identity vs phase-object identity, with phase tags and predecessor links. |
| **C** | Mutation ledger built. **9 mutants, 9 killed, 0 survived** — and the ledger records that **one is killed before reaching its intended tooth**, which the previous flat count would have hidden. |

---

## A. Public forgeability and export surface

### A.1 Export count

```
before   86
after    97   (+11: dual-identity and content-digest readers)
```

The census is machine-generated at `EXPORT-CENSUS.md` by
`PUBLIC-SURFACE-AUDIT.lisp`, which **fails** if any external symbol lacks a
declared caller, minting power and disposition, or if any declared disposition
names a symbol that is not exported. "Every export is accounted for" is a tooth,
not a promise.

No export was pruned. Every symbol is a transition, a `TRY-` twin, a predicate,
an immutable reader, a grammar constructor, the single condition
`FORM-REFUSED`, the protocol constant `FORM-REFUSAL-CODES`, or one of four
constructors. **No symbol survives merely because a `DEFSTRUCT` generated it** —
every phase object uses `(:conc-name %…)` so its generated accessors are
internal, and the public readers are hand-written wrappers that copy.

### A.2 The twelve-point walk

Run from `#:form0-public-surface`, which uses only `#:cl` and the **external**
symbols of `LISP-PLUS-FORM0`. A check reads the audit's own source and requires
that it contains no double-colon reference into the audited package — an audit
that reaches past its own boundary proves nothing about that boundary.

| # | attempt | result |
|---|---|---|
| 1–3 | construct `VALIDATED-FORM` / validation receipt / realization receipt | **refused** — no such constructor is external |
| 4 | forge or alter predecessor identities | **refused** — no writer exists |
| 5 | mint an operator descriptor with an arbitrary host function | **POSSIBLE — see L-1** |
| 6 | install or remap a handler for an existing operator identifier | **POSSIBLE — see L-2** |
| 7 | install `perform` behind an identifier | **refused** — `:unknown-operator` |
| 8 | alter a sealed environment | **refused** — every field read-only, no writer |
| 9 | mutate internal collections through exported readers | **refused** — clobbering a reader's result does not reach the environment |
| 10 | replace a descriptor while preserving the environment identity | **now refused** — `:environment-content-drift` (was **possible** before this round) |
| 11 | call an internal handler through an exported accessor | **refused** — no public handler accessor exists at all |
| 12 | create a phase object whose invariants were never earned | **refused** — `:not-validated` |

### A.3 The two declared limits — and the contradiction the chair predicted

**The chair's instruction was: *if an external program can supply arbitrary
handler functions to a form environment, stop and report the contradiction.* It
can. This is that report, and the design fork is left to the owner.**

**L-1 — `MAKE-OPERATOR-DESCRIPTOR` accepts any host function.** An outsider can
install `uiop:run-program` behind an innocent segmented identifier. Demonstrated
in the walk.

**L-2 — identical declared surface, different handler, undetectable.** Two
environments agreeing on identity, version, grammar, resource policy **and every
operator's identity/arity/result-species** are indistinguishable to every gate
`realize-form` owns, because a host closure has no canonical content. Before
this round the demonstration was worse: a form validated under an honest desk
**realized under a swapped desk and returned `"forged"`**, with all five drift
gates passing, because every gate compared names and versions and none compared
contents.

**What was repaired.** A `form-environment-content-digest` now commits to the
whole *declared surface*; validation binds it and realization re-checks it, so
attempt 10 is refused. **What was not repaired, and cannot be by a digest:** the
handler behaviour itself.

**The precise statement that replaces the closure's overclaim.** Candidate /0's
guarantee is **form↔environment**: a *candidate form* cannot supply, name into
existence, or reach a handler — no CD/0 family can carry a function, and the
only dispatch site takes its function from the sealed environment. It is **not**
a **program↔program** guarantee: whoever seals an environment is the authority
over what its operators do. The earlier sentence *"its installed operators are
structurally incapable of granting authority"* was true of **the four operators
this layer installs** and false as a general claim about the layer.

**The fork, for the owner — I did not choose:**

| option | what it buys | what it costs |
|---|---|---|
| **(a) trusted-program model** (status quo + the now-explicit statement) | nothing new to build; the honest description of what is actually true | the layer makes no promise against a hostile installer |
| **(b) declared handler identity** — `make-operator-descriptor` requires a handler-identity string, bound into the digest | converts a *silent substitution* into a *lie on the record*; auditable | still self-declared; adds a required argument |
| **(c) package-controlled installation** — unexport `make-operator-descriptor`, install only through a sealed allowlist | a real enforcement boundary | the layer stops being usable by an ordinary program without a second mechanism |

L-2's residual is exhibited by `T-HANDLER-SUBSTITUTION` in the teeth, which
asserts that realization is **NOT** refused and that the substituted handler
ran. It is a tooth that documents a limit, not one that claims a protection.

### A.4 Unreachable conditions

One exported condition, `FORM-REFUSED`, reachable from every public path. Every
refusal code in `FORM-REFUSAL-CODES` is produced by a public operation or a
`TRY-` return. **No `DERIVATION-BASIS-REFUSED` reincarnation** — no exported
condition exists that nothing can signal.

---

## B. Dual identity ledger

**The model was absent, exactly as suspected.** `validated-form-identity`
returned `(%hex instantiated-datum)` — the *syntax*, not the validation. The
previous return printed the same truncated value at four stages because at three
of them it genuinely was the same value.

### B.1 What is implemented now

| identity | domain | commits to |
|---|---|---|
| subject-form | `%hex` of the canonical datum | the syntax alone — **stable** across phases |
| proposed | `phase/proposed` | subject + grammar identity/version |
| binding-environment | `phase/binding-environment` | the exact (hole, value) pairs |
| instantiated | `phase/instantiated` | proposal **phase** identity + binding identity + resulting subject |
| validated | `phase/validated` | instantiation **phase** identity + grammar id/v + environment id/v + **content digest** + resolved descriptor identities + resource policy + subject |
| validation receipt | `phase/validation-receipt` | the same components under a **distinct tag** |
| realization receipt | `phase/realization-receipt` | validated **phase** identity + realized subject + operators + result |

### B.2 The ledger for candidate C, as printed by the inhabited program

```
stage           subject form                    phase object
candidate datum 4c50434400300322020f6c69(440)   —
proposed        4c50434400300322020f6c69(440)   4c50434400300422020f6c69(1040)
instantiated    4c50434400300322020f6c69(410)   4c50434400300422020f6c69(3772)
  bindings      —                               4c50434400300222020f6c69(382)
validated       4c50434400300322020f6c69(410)   4c50434400300a22020f6c69(10684)
  val receipt   4c50434400300322020f6c69(410)   4c50434400300a22020f6c69(10702)
realized        4c50434400300322020f6c69(410)   4c50434400300522020f6c69(22476)
  result        4c5043440002(12)                —

predecessor links, phase-object to phase-object:
  instantiated → proposed      …(1040)
  validated    → instantiated  …(3772)
  realization  → validated     …(10684)
```

### B.3 Two things the ledger itself taught

**(i) The abbreviation lied twice before it told the truth.** A 16-character
head slice collapses every identity (shared CD/0 magic); a 16-character *tail*
slice also collapses them (shared trailing components). The display now prints
**length** alongside the slice, and `check-abbreviations-discriminate` asserts
that the abbreviations actually shown are pairwise distinct whenever the full
identities are. *A diagnostic nobody has tested can lie, and this one did — in
the previous return, to the chair.*

**(ii) Phase identities grow with depth.** 440 → 1040 → 3772 → 10684 → 22476
characters, because each phase embeds its predecessor's full identity **as a
string**. For Form /0 this is finite (four phases, bounded) and correct. For any
frontier that chains transformations it is **quadratic and unacceptable**, and
the fix is a fixed-length digest — which this project cannot take casually,
having criticised "pedagogical, not cryptographic" digests elsewhere. **Recorded
as friction for Form /1, not fixed under time pressure.**

### B.4 Teeth added

`T-DUAL-IDENTITY` × 9 — subject stable across phases · three distinct phase
identities · no phase identity collides with the subject · the validation
receipt has its own identity distinct from the validated form · same syntax
under two environments shares one subject and carries two validated identities ·
predecessor links name phase objects not syntax · a proposed identity cannot
stand where a validated one is required · a different environment version and a
different binding each move the validated identity · the binding environment has
its own identity. Plus `T-RECEIPT-NAMES-THE-FORM` extended to require the
receipt bind **both** the validation and the subject as two distinct values.

---

## C. Mutation evidence

`MUTATION-LEDGER.sh` → `MUTATION-LEDGER.md`. **9 mutants, 9 killed, 0 survived.**

| reached the intended tooth? | mutants |
|---|---|
| **yes — named FAIL at the tooth** (6) | `no-species-check` · `two-pass-substitute` · `no-env-identity-gate` · `no-content-digest-gate` · `no-arity-gate` · `no-snapshot` |
| **reached, other marker** (2) | `boundary-accepts-host` · `unfilled-hole-allowed` |
| **NO — died earlier** (1) | `literal-descends` — killed, but *not* by `T-ONE-PASS` |

That last row is the point of the exercise: the flat "8 killed" of the previous
return would have counted `literal-descends` as evidence that `T-ONE-PASS`
tests the literal-leaf rule. **It is not.** The one-pass property is tested by
`two-pass-substitute`, which does reach the tooth.

The script also refuses to trust a verdict from a mutation that did not change
the file — the check that caught the invalid first battery, now permanent. The
account of that invalid battery is preserved in the ledger.

---

## D. Runs, and the state

```bash
bash verify-form-floor.sh
  PASS  form0-teeth           109 passed / 0 failed
  PASS  de-forma-dormiente     22 passed / 0 failed
  PASS  public-surface         19 passed / 0 failed
  FORM FLOOR GREEN — 3 floors, 150 checks, 0 failed          exit 0

bash verify-language-floor.sh
  LANGUAGE FLOOR GREEN — 11 floors, 654 checks, 0 failed     exit 0   unchanged

bash verify-all.sh
  ALL FLOORS HOLD — 6/6 suites green                         exit 0   unchanged

bash MUTATION-LEDGER.sh
  killed=9  survived=0                                       exit 0

sbcl --non-interactive --load PUBLIC-SURFACE-AUDIT.lisp
  19 passed / 0 failed · 2 declared limits                   exit 0
```

**A defect found in the runner and fixed:** `verify-form-floor.sh` briefly
printed *"3 floors, 150 checks"* while only executing two — a patch that failed
to apply silently. The banner now derives its floor count from a variable
asserted against the verdicts actually produced. *A CI banner that can overstate
what it ran is worse than no banner.*

### Files

Added this round: `PUBLIC-SURFACE-AUDIT.lisp` · `EXPORT-CENSUS.md` (generated) ·
`MUTATION-LEDGER.sh` · `MUTATION-LEDGER.md` (generated) ·
`CHAIR-REVIEW-RESPONSE-1.md`.
Modified: `form0.lisp` · `package.lisp` · `form0-selftest.lisp` ·
`de-forma-dormiente/APPLICATION.lisp` · `verify-form-floor.sh`.
**No file outside `language-form-0/` and `verify-form-floor.sh` was touched.**

### `LANGUAGE-FORM-0-RETURN.md`

**Tracked, and inside the second commit of the previous round** — `86d3710d`,
*"file the Form /0 return report as an artifact"*. It is not external and not
untracked. It will publish with the branch if the branch is ever merged, along
with the local worktree path it names in §1; scrubbing that path is a one-line
change on request.

---

## What still stands unrepaired

- **L-1 and L-2** — awaiting the owner's ruling on the (a)/(b)/(c) fork.
- **Phase-identity growth** — friction for Form /1, recorded not fixed.
- **Two mutants kill by abort rather than a named FAIL** — reduced from four,
  not eliminated.
- **The stranger audit is still OWED**, against this response too.

Nothing is adopted. Nothing is frozen. Slice /3 is not opened. The branch is
pushed and **not merged**.

— **Claude Opus 5 (1M context)**, 2026-07-26
