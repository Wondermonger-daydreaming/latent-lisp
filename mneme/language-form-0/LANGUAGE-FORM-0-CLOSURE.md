# LANGUAGE FORM /0 — CANDIDATE /0 — CLOSURE

*What was built under `LANGUAGE-FORM-0-WORK-ORDER.md`, what it cost, and what it
does not do. **Not an adoption record.***

> **ERRATUM, 2026-07-26 (chair review 1).** §5(a) below says the operator set is
> *"incapable of granting authority."* That is true of **the four operators this
> layer installs** and false as a general claim: `MAKE-OPERATOR-DESCRIPTOR` accepts
> any host function, and two environments with an identical declared surface but
> different handlers are indistinguishable to every gate `realize-form` owns. The
> guarantee is **form↔environment**, never **program↔program**. See
> `CHAIR-REVIEW-RESPONSE-1.md` §A.3 (limits L-1, L-2) — and §B, where the dual
> identity model this closure implied was found to be **absent** and was built.
>
> **Both owner rulings are recorded in `LANGUAGE-FORM-0-RULINGS.md`.**
>
> **RESOLVED by owner ruling (option C), 2026-07-26.** Handler installation is
> now package-controlled: `MAKE-OPERATOR-DESCRIPTOR` no longer exists, and
> `MAKE-FORM-ENVIRONMENT` takes a SELECTION of built-in operator names. The
> exploit is not mitigated but **unconstructible through the public API**. The
> guarantee is a PUBLIC-API enforcement boundary, not process isolation — see
> the threat model at `LANGUAGE-FORM-0-WORK-ORDER.md` §0, and §4 of that file
> for the Form /1 entrance gate on phase-identity growth.

```
status:                   candidate implementation
specification-frozen:     no
adopted:                  no
stranger audit:           OWED, non-blocking
Slice /3:                 NOT opened
semantic delta below:     NONE — this layer sits BESIDE the eleven, not under them
form0 exports:            97   (86 at first return; +11 dual-identity/content-digest readers)
eleven prior floors:      654 / 0, unchanged
pre-existing files:       byte-identical (git diff --stat HEAD -- experiments/latent-lisp: empty)
```

---

## 1. The floors

```
form0-teeth             109 /  0     NEW   (87 at first return)
de-forma-dormiente       22 /  0     NEW   (19 at first return)
public-surface           19 /  0     NEW   (chair review 1)
                        ─────────
                    3 floors · 150 checks · 0 failed   (verify-form-floor.sh)

core0-substrate          29 /  0     unchanged
core0-issuance           73 /  0     unchanged
slice1-selftest         123 /  0     unchanged
slice1-smoke              9 /  9     unchanged
de-bibliotheca          123 /  0     unchanged
de-codice               101 /  0     unchanged
de-cursore-aereo         23 /  0     unchanged
de-ponte-usto            17 /  0     unchanged
slice2-selftest         108 /  0     unchanged
slice2-smoke             10 / 10     unchanged
surface0-selftest        38 /  0     unchanged
                        ─────────
                   11 floors · 654 checks · 0 failed   (verify-language-floor.sh)

verify-all.sh            6 / 6 suites green            unchanged
```

**All eleven prior floors did not move**, and no file that existed before this
work was touched. That is the whole regression result.

## 2. What the mutation battery established — including what it first got wrong

> **SUPERSEDED IN PART.** The table below is the first return's battery of eight.
> The battery is now nine mutants, run by `MUTATION-LEDGER.sh`, and its ledger
> records **where** each mutant died — see `MUTATION-LEDGER.md`. One mutant
> (`literal-descends`) is killed *before* reaching its intended tooth, which the
> flat count below silently treated as evidence. The narrative in this section
> is kept because the account of the invalid first run is still the useful part.

A suite that has never gone red is a suite nobody has tested. Eight mutants were
planted against `form0.lisp` and run through the teeth:

| mutant | verdict | killed by |
|---|---|---|
| `no-species-check` | KILLED | `T-WRONG-SPECIES` |
| `two-pass-substitute` | KILLED | `T-ONE-PASS` (`:hole-survived-instantiation`) |
| `no-env-identity-gate` | KILLED | `T-SAME-LOOKING-DIFFERENT-ENVIRONMENT` |
| `boundary-accepts-host` | KILLED | suite aborts at the boundary teeth |
| `unfilled-hole-allowed` | KILLED | suite aborts in the hole teeth |
| `no-arity-gate` | KILLED | `T-OPERATOR-ARITY` |
| `literal-descends` | KILLED | the one-pass teeth |
| `no-snapshot` | KILLED | `T-SNAPSHOT-IS-INDEPENDENT` |

**8 killed, 0 survived — but only on the second run, and the first run is the
more useful record.**

**First survivor: `two-pass-substitute`.** The mutation replaced
`(literal-node (cdr pair))` with `(%substitute (literal-node (cdr pair)) bindings)`
— which is a **no-op**, because `%substitute` returns a literal node unchanged.
The mutant survived because it was not a mutation, not because the teeth were
blind. A genuine two-pass mutant (stop wrapping the bound value as a literal, and
descend into literal payloads) dies at `validate-form` with
`:hole-survived-instantiation`. **The lesson is about mutation testing, not about
the layer: a surviving mutant is a claim about the tests that must itself be
checked, because the cheapest explanation — "my teeth are fine, that mutant was
silly" — is also the most self-serving one.** It was checked, and this time it
happened to be true.

**Second survivor: `no-snapshot`.** Replacing `%snapshot` with the identity
function changed nothing observable, because **CD/0 datums are already
immutable** — there is no public path by which a caller could mutate one. That
was a real hole and it was closed honestly rather than argued away: the new
`T-SNAPSHOT-IS-INDEPENDENT` asserts what the round trip actually buys — that the
stored tree is a *distinct object* preserving the value exactly — and does **not**
claim it protects against a mutation CD/0 would otherwise have permitted.
`T-CALLER-MUTATION-INERT` is a different tooth testing a different thing: the
caller's **host binding list**, which is genuinely mutable and genuinely copied.

Two further honesty notes on the battery: four mutants kill by **aborting** the
suite rather than reporting a named `FAIL`. An aborting tooth still fails the
run, but it tells a reader less. The one-pass block was rewritten to use the
`TRY-` entry points for exactly this reason, so its mutant now names itself. The
others were left as they are and are recorded here rather than smoothed over.

And the first battery run was itself invalid: the mutants were copied to `/tmp`,
where `../../canonical-datum/` does not resolve, so every one of them "died" of a
missing file. **Five green kills that were really five identical crashes** — found
because one mutant that provably had not been applied still reported KILLED.

## 3. The naming decision

`DECODE-FORM` was refused. "Decode" is occupied by `lisp-plus-cd0:decode-exact`
(octets → datum); a `decode-form` one layer up would suggest Form /0 parses
something, which is precisely what §2 of the work order forbids. The operation
admits an existing datum as a candidate under a closed grammar, so it is
**`PROPOSE-FORM`**. `INSTANTIATE-FORM`, `VALIDATE-FORM` and `REALIZE-FORM` are
adopted as-is. `REIFY-FORM` and `TRANSFORM-FORM` are unused: nothing here reifies
and nothing transforms. **All public names remain candidate until closure.**

## 4. The one design decision that was not in the work order

**A hole is a data position, and a bound value is spliced in wrapped as a
literal.** The work order required single-pass substitution and immunity to
recursive capture; the obvious implementation is a discipline ("do not re-scan
the inserted value"). Wrapping makes it **structural** instead: literal payloads
are leaves in every walk, so no second pass can reach an inserted value even if
one were written by mistake — and the `literal-descends` mutant proves the leaf
rule is load-bearing.

The consequence is worth stating plainly because it is a real semantic
commitment: **a value inserted into a hole can never be a program.** If a later
frontier wants code-into-code, that is a separate production with its own
validation, not a relaxation of this one.

## 5. Costs and holes, named

**(a) Four operators, all from one package.** Every installed operator wraps a
`LISP-PLUS-CD0` public operation. That is what made "non-effectful, deterministic,
already governed, incapable of granting authority" checkable rather than asserted
— and it also means the operator set has **not** been exercised against an
operation from a governed layer that *could* have minted something. Doing that
safely is a Form /1 question.

**(b) `:operator-identity-drift` is unreachable from any public path.** Operator
identities are derived from the form itself, so no legitimate call can make the
re-resolved list differ from the bound list. It is fired only by tampering with a
validation receipt through an internal constructor. It is defence in depth, it is
labelled `/PLANTED` in the suite, and it is recorded here rather than counted as
a naturally-tested gate. The same is true of `:grammar-version-drift` and
`:budget-policy-drift`.

**(c) No capability, by instruction and without contradiction.** Realization is
meaningful because the operators compute over data and return data. Had a
capability been structurally required to make realization mean anything, the work
order says to stop and report; it was not.

**(d) No receipt survives image death.** A `form-realization-receipt` is an
in-image object. It is evidence *of* a realization, never a re-realization, and
nothing here addresses persistence — that is the PJ0 lane, deliberately untouched.

**(e) Self-consistency, not corroboration.** One model family wrote the layer,
its operators, the inhabited program and its checks.

**(f) The latent adapter is a labelled scripted fake.** No model or provider was
called. Nothing in `de-forma-dormiente` is evidence that any external process
emitted any form.

## 6. What Candidate /0 earned

- The five-object chain runs, and the four phases are **four disjoint types** with
  no status slot advancing one object through them.
- Refusals are **objects with identities that outlive the successful candidate** —
  verified after the lawful realization, not merely at the moment of refusal.
- A candidate naming `perform` is **admitted as a lawful shape and refused at
  validation**, which is the exact sentence this frontier exists to make true:
  *naming a consequential act is not performing one.*
- The durable boundary holds against a host symbol, a host list, a host string
  and a host function object.
- A validation is **not portable** across environment identity, environment
  version, grammar version, or resource policy.

## 7. What it explicitly did NOT earn

- **No adoption, no freeze, no floor promotion.** `verify-form-floor.sh` is a
  separate command precisely so that folding Form /0 into the language floor
  stays a later owner decision rather than a side effect.
- **No claim about latent machines.** A scripted fake emitting fixed bytes
  demonstrates the *shape* of the discipline, not that it survives a real
  emission.
- **No independent conformance.** The stranger audit is owed against this closure
  as much as against Surface /0 and Slice /2 Candidate /1.
- **No macroexpansion story.** No `EXPANDED-FORM` and no expansion receipt were
  built, because no implementation evidence made either unavoidable.

---

*Built in the isolated worktree `<isolated worktree>` on
branch `language-form-0` from lab `4c4f43ad` · SBCL 2.4.6 operation-checked
through the wrapper · form floor 2/106/0 · language floor 11/654/0 unchanged ·
`verify-all.sh` 6/6 unchanged · `specification-frozen: no`.*

— **Claude Opus 5 (1M context)**, 2026-07-26
