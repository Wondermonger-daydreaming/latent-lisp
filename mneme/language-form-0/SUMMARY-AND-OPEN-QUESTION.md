# LANGUAGE FORM /0 — SUMMARY, AND ONE OPEN QUESTION

*Written 2026-07-26, after three rounds: the build, chair review 1, and the
owner's option-(c) ruling. Branch `language-form-0` @ `0dcf96d3`, pushed, not
merged.*

---

## 1. What Form /0 is, in one paragraph

A closed three-production grammar over already-decoded Canonical Datum /0 trees,
and four immutable phases between a candidate datum and a realized result:
**propose → instantiate → validate → realize**. Each transition returns a new
object with its own content-derived identity; no mutable status slot advances
one object through four lives. The law it exists to make executable:

> **In Lisp+, code may be data before it becomes authority.**

The demonstration that matters: a deterministic fake latent adapter emits a
program naming `perform`. It is **admitted** as a lawful shape and **refused**
at validation, because the name resolves to nothing. *Naming a consequential act
is not performing one.*

## 2. Where it sits

A **sibling** directory, `mneme/language-form-0/`. Not under the eleven existing
layers — beside them. Kernel /0, Core /0, Slice /0, Slice /1, Slice /2, Surface
/0 and Canonical Datum /0 are byte-untouched, and both existing floors are
unchanged at 654/0 and 6/6.

```
form floor      3 floors · 199 checks · 0 failed   (verify-form-floor.sh)
language floor  11 floors · 654 checks · 0 failed  unchanged
verify-all      6/6 suites green                   unchanged
mutants         10 planted · 10 killed · 0 survived
exports         99, every one with a declared disposition (the census is a tooth)
```

## 3. What the three rounds actually found

**Round 1 — the build.** The vertical works. The one design commitment beyond
the work order: *a hole is a data position*, and a bound value is spliced in
wrapped as a literal, which makes single-pass substitution structural rather
than a discipline. Consequence, stated plainly: **a value inserted into a hole
can never be a program.**

**Round 2 — chair review 1. Both bolts were loose.**

- The **dual identity model was absent**. `validated-form-identity` returned the
  instantiated form's *syntax* identity. The first return printed one value at
  four stages because at three of them it genuinely was one value.
- A **live exploit**: a form validated under an honest environment **realized
  under a substituted one and returned `"forged"`**, with all five drift gates
  green, because every gate compared names and versions and none compared
  contents.

**Round 3 — the owner's option-(c) ruling.** Handler installation is now
package-controlled. `MAKE-OPERATOR-DESCRIPTOR` is gone under any status;
`MAKE-FORM-ENVIRONMENT` takes a **selection of built-in operator names**
resolved by a closed dispatcher to package-internal functions. The exploit is
not mitigated — it is **unconstructible through the public API**, and a planted
mutant restoring the old constructor is killed at its intended tooth. The
subject-identity doctrine was corrected: instantiation is precisely where the
syntax moves, from a hole-bearing **template** to a **closed** form, and the
instantiated phase now records both sides.

## 4. What is honestly claimed, and what is not

**Claimed.** Form /0 protects against malformed, adversarial or model-emitted
Canonical Datum forms attempting to acquire operations not installed in their
sealed environment.

**Not claimed.** Protection against malicious Common Lisp already executing in
the same image, `SYMBOL-FUNCTION` redefinition, package-internal access,
replacement of the implementation, callers bypassing Form /0 entirely, or a
compromised Lisp. **Package-controlled installation is a public-API enforcement
boundary, not process isolation.**

Every green in this lane is **self-consistency certification**: one model family
wrote the layer, its operators, the inhabited program and its checks. The
**stranger audit is OWED**.

## 5. Recurring lesson, stated once

Across three rounds, the layer's *semantics* held up better than its *reporting*
about itself. The defects that survived longest were:

- a display that truncated four distinct identities into one appearance —
  and told the chair so;
- a CI banner that printed "3 floors" while running two;
- the same banner advertising two limits after they were closed;
- a mutation battery whose five "kills" were five identical crashes;
- a flat kill-count that treated an early death as evidence for a tooth it never
  reached.

None of those were wrong code. All of them were **instruments misreporting**.
The teeth now police the display, the banner derives its count from verdicts
actually produced, and the mutation ledger records *where* each mutant died.

---

## 6. THE OPEN QUESTION

**How strictly should "package-controlled operator installation" be read?**

The ruling said external callers must not be able to construct an operator
descriptor carrying a host function, provide a handler closure, or install
arbitrary new operators. Two readings satisfy that sentence:

| | **(i) no public constructor at all** *(what I built)* | **(ii) a public constructor with an allowlist check)** |
|---|---|---|
| shape | `MAKE-OPERATOR-DESCRIPTOR` does not exist; `MAKE-FORM-ENVIRONMENT` takes names | the constructor survives, refuses any handler not package-owned |
| enforcement | nothing to bypass — there is no entry point | equivalent *today*, but the entry point exists |
| audit cost | one absence to check | a check that must stay correct forever |
| future trusted-extension lane | **cannot reuse this entry point** — it must mint its own | could relax the allowlist in place |

**I chose (i), the stronger reading**, on the grounds that an entry point that
exists is an entry point a later round can be tempted to widen — and this lane
has already watched a "trusted caller" wording get used to justify keeping a
dangerous export.

**The consequence I want ruled on, not assumed:** under (i), the future
**trusted-extension lane** — *a trusted host deliberately teaches the form system
new operators* — cannot reuse `MAKE-FORM-ENVIRONMENT`'s operator argument. It
will need its own separately-named constructor, its own descriptor type, or its
own environment species.

That is *more* work later, and I think it is the right kind of more work: it
keeps the three beasts in separate cages —

```
Form /0                    untrusted forms inside a trusted host
trusted-extension lane     a trusted host deliberately teaches new operators
authority lane             consequential operators petition Lisp+ authority semantics
```

— rather than letting the second quietly grow out of the first's argument list.

**But if you intended (ii), say so before merge.** Reversing (i) later is a
public-API change to a merged candidate; reversing it now is an hour.

---

*Nothing adopted. Nothing frozen. Slice /3 not opened. Form /1 not opened.
Branch pushed, not merged, mirror not published.*

— **Claude Opus 5 (1M context)**, 2026-07-26
