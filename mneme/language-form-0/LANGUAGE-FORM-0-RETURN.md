# RETURN — LANGUAGE FORM /0, CANDIDATE /0

*The return required by §10 of the owner's ruling of 2026-07-26
("OPEN LANGUAGE FORM /0 CANDIDATE /0 — THE PROGRAM CAN BE HELD").*

*Every number below was read from a live run in this worktree, not recalled.*

---

## 1. Exact worktree, branch, commit

```
worktree   <isolated worktree>   (git worktree, linked)
branch     language-form-0
base       4c4f43ad  (lab main, unmoved)
commits    400119b0  open Language Form /0 Candidate /0 — the program can be held
           d1a86de9  correct the closure's export count — 86, from the package, not from grep
state      ahead of main · NOT merged · NOT pushed · worktree clean
main       4c4f43ad, experiments/ still clean — untouched throughout
mirror     NOT published. Branch guard fired and logged it:
           [2026-07-26T16:39:11Z] commit on branch 'language-form-0'
                                  — mirror sync SKIPPED (main-only guard)
           public tip still 17a9472
```

The mirror was verified mechanically rather than by trusting that a guard
exists. The hook shim execs `$(git rev-parse --show-toplevel)/tools/latent-lisp/post-commit.sh`,
which in a **linked worktree** is the *worktree's own* copy writing to the
*worktree's own* log. That is why the lab's `.sync.log` showed nothing and
briefly looked as though the hook had never run at all.

## 2. The work order's semantic boundary

> **In Lisp+, code may be data before it becomes authority.**

`LANGUAGE-FORM-0-WORK-ORDER.md`, written in full against the live APIs
**before** any implementation existed, carrying the required extraction map
(*existing atelier invariant → proposed Form /0 invariant → new object or
operation → executable tooth*). It revealed **no contradiction**, so
implementation proceeded.

| dimension | commitment |
|---|---|
| **input** | an already-decoded CD/0 datum. Never text, never a host form. No `READ`, readtable, reader macro, parser, evaluator, macroexpander. `#.` needs no handling because textual reader syntax never enters. |
| **names** | operators and holes are CD/0 **segmented identifiers**. No host symbol is durable; nothing interns or looks up a symbol. |
| **phases** | `canonical datum ≠ proposed form ≠ instantiated form ≠ validated form ≠ realized result` — five objects, four transitions, each returning a **new immutable object** with a content-derived identity. **No mutable status slot** advances one object through the phases. |
| **grammar** | three productions and no fourth: literal · declared hole · closed operator call. No sequencing, no conditionals — the inhabited example did not require them. |
| **operators** | four, all wrapping existing public `LISP-PLUS-CD0` operations: `equal-datum`, `canonical-hex`, `sequence-length`, `render-diagnostic`. Deterministic, non-effectful, already governed, structurally incapable of granting authority. |
| **authority** | none. No capability is required or minted (per ruling §5 — the live-authority lane is incomplete, and inventing it here would be the counterfeit). Nothing constructs a claim, source basis, derivation basis, capability or warrant, and **no layer that could is even loaded**. |
| **position** | a **sibling** directory. Semantic delta below the eleven: none, because it sits beside them, not under them. Slice /3 not opened. |

**Naming decision, recorded with its reason.** `DECODE-FORM` was refused:
"decode" is occupied by `cd0:decode-exact` (octets → datum), and reusing it one
layer up would falsely suggest parsing. The operation admits an existing datum
under a closed grammar, so it is **`PROPOSE-FORM`**. `INSTANTIATE-FORM` /
`VALIDATE-FORM` / `REALIZE-FORM` adopted as-is. `REIFY-FORM` and
`TRANSFORM-FORM` unused — nothing reifies, nothing transforms. **All public
names remain candidate until closure.**

## 3. Files added and modified

**Added — 7 files, 2,591 lines. Modified — zero.**

```
mneme/language-form-0/LANGUAGE-FORM-0-WORK-ORDER.md       345
mneme/language-form-0/LANGUAGE-FORM-0-CLOSURE.md          192
mneme/language-form-0/package.lisp                        145   (86 exports)
mneme/language-form-0/form0.lisp                          837
mneme/language-form-0/form0-selftest.lisp                 638
mneme/language-form-0/de-forma-dormiente/APPLICATION.lisp 332
mneme/verify-form-floor.sh                                102
```

*(This RETURN file is an eighth, added afterwards at the owner's request.)*

Proof of non-modification, not assertion:
`git diff --stat HEAD -- experiments/latent-lisp` → **empty**;
`git status --porcelain` showed only `??` entries; modified/deleted count **0**.

## 4. Exact commands and test counts

```bash
# the new floor (separately named, per ruling §9)
cd experiments/latent-lisp/mneme && bash verify-form-floor.sh
  PASS  form0-teeth           87 passed / 0 failed
  PASS  de-forma-dormiente    19 passed / 0 failed
  FORM FLOOR GREEN — 2 floors, 106 checks, 0 failed          exit 0

# the eleven that already existed — must not move
cd experiments/latent-lisp/mneme && bash verify-language-floor.sh
  LANGUAGE FLOOR GREEN — 11 floors, 654 checks, 0 failed     exit 0   (unchanged)

cd experiments/latent-lisp/mneme && bash verify-all.sh
  ALL FLOORS HOLD — 6/6 suites green                         exit 0   (unchanged)
```

SBCL 2.4.6, operation-checked through the wrapper before any run.

**Mutation battery — 8 planted mutants, 8 killed, 0 survived:**
`no-species-check` · `two-pass-substitute` · `no-env-identity-gate` ·
`boundary-accepts-host` · `unfilled-hole-allowed` · `no-arity-gate` ·
`literal-descends` · `no-snapshot`.

That clean result is the **second** battery. The first was invalid: the mutants
were copied to `/tmp`, where CD/0's `../../` path cannot resolve, so five
"kills" were five identical missing-file crashes. It was caught only because one
mutant that provably had **not** been applied still reported KILLED — a green
that was structurally impossible. *A mutation battery is an instrument, and an
instrument reporting all-kills deserves the same suspicion as one reporting
all-passes.*

Of the two genuine survivors: **`two-pass-substitute` was a no-op mutation** (it
wrapped a literal in `%substitute`, which returns literals unchanged) — a real
two-pass mutant dies at `validate-form` with `:hole-survived-instantiation`.
**`no-snapshot` was a real hole**, closed by adding `T-SNAPSHOT-IS-INDEPENDENT`,
which asserts exactly what the round trip buys (a distinct object preserving the
value) and **not** protection from a mutation CD/0 already prevents.

## 5. Form genealogy — candidate C, from the inhabited application

The desk asks: *is the digest of what we observed the digest we were promised?*

```
candidate datum   4c50434400300322…   emitted by the labelled scripted fake adapter
  → proposal      4c50434400300322…   admitted under the grammar; 2 holes, 2 operators
  → instantiation 4c50434400300322…   holes `observed` and `expected-digest` filled from
                                       an explicit binding list; source named by identity
  → validation    4c50434400300322…   2 operator descriptors resolved and bound, with
                                       grammar id+v1, environment id+v1, resource policy
  → realization   result 4c5043440002 = true
```

**Negative control**, same program, one datum different: a wrong promised digest
realizes to **FALSE, not to a refusal**, and the two fillings carry **two
different identities**. The desk distinguishes *"no"* from *"I refuse to look"* —
they are different rows in the ledger.

## 6. Refusal genealogy — the two rejected candidates

```
candidate :A   datum 4c50434400300322…
  proposal        REFUSED  :GRAMMAR/:UNKNOWN-PRODUCTION
                  id(ns=["dreamt-language"],path=["if"]) heads no production
  instantiation   not reached
  validation      not reached
  realization     not reached
  retained:       offending datum snapshot + code + detail + identity

candidate :B   datum 4c50434400300222…
  proposal        held      ← its SHAPE is lawful; the grammar admits it
  instantiation   held
  validation      REFUSED  :VALIDATION/:UNKNOWN-OPERATOR
                  id(ns=["lisp-plus-form0","op"],path=["perform"]) is not installed
  realization     not reached
  retained:       code + detail + identity
```

Both were re-read **after** C realized and still carry a stable code, a detail
and an identity. The ledger holds all four candidates the desk touched.

Candidate B is the sentence this frontier exists to make true: **the adapter
emitted a lawful program naming `perform`, and the act did not happen.** The
name resolved to nothing. *Naming a consequential act is not performing one.*

## 7. Invariant-by-invariant comparison with `de-fornace`

| de-fornace invariant | Form /0 counterpart | how it differs |
|---|---|---|
| `validate-form-tree` rejects dotted/circular host conses | **absent, and deliberately** | A CD/0 datum cannot be dotted or circular. The furnace *guards* the boundary; Form /0 lives on the far side of it. This is the single biggest reason to build rather than promote. |
| `charge` — a proposed transformation | `proposed-form` | One candidate at a time, not a multi-proposal arbitration. No convergence, conflict or alloy. |
| *"admission is distinct from adoption"* | four disjoint types | de-fornace keeps `admitted` and `slag` lists on a mutable `furnace-work`; Form /0 has **no mutable holder at all** — each phase is a new value. |
| *"planning is pure until an explicit commit"* | everything before `realize-form` is pure | Same law. de-fornace's `commit-firing` mutates `furnace-work`; `realize-form` mutates nothing and returns `(values result receipt)`. |
| `slag` — rejected charges archived with typed failure | `form-refusal` + `try-*` twins | de-fornace archives via a **restart the caller must invoke**; Form /0 returns the refusal as a second value, so retention is the default rather than a ceremony. |
| `standing-laundering` — synthesis may not mint standing | operator allowlist | de-fornace *detects* an attempt to rewrite a standing marker. Form /0 makes it **unrepresentable**: no installed operator can produce standing, and no layer defining standing is loaded. |
| `verify-charge-integrity` — "changed after minting" (FNV `toy-digest`) | `canonical-octets` identity | de-fornace's own header calls its digest *"pedagogical, not cryptographic."* Form /0 uses the governed CD/0 canonical encoding. Same invariant, different evidentiary weight. |
| `pass-version-mismatch` | grammar-version + environment-version binding | de-fornace pins one registry version; Form /0 pins **five** components and re-checks all of them at the boundary. |
| `require-pass` — passes installed, never from caller data | `operator-descriptor` in a sealed environment | Same principle, strengthened: `*pass-registry*` is a **global hash table**; Form /0 has **no global at all** — `T-NO-GLOBAL-REGISTRY` asserts one `defparameter` (the refusal-code list), no `defvar`, no hash table. |
| `edit-precondition-failed` — exact precondition against the workpiece | `validated-form` bound to one exact identity | de-fornace checks a node at a path; Form /0 binds the whole form's canonical identity. |
| `replay-firing` — same base + receipt reproduces the alloy | **not built** | Replay presupposes history. Form /0 has one form and no history. |
| edit scripts · paths · budgets · shavings | **not extracted** | Transformation is Form /1 at the earliest. |

**Vocabulary check:** no `charge`, `slag`, `shaving`, `firing`, `temper`, `ore`
or `crucible` appears in `form0.lisp`. The Atelier was precedent and executable
evidence — not a package dependency and not a thesaurus.

## 8. What Candidate /0 earned

- **The five-object chain runs**, and the four phases are four **disjoint
  types** — `T-PHASES-ARE-DISTINCT-OBJECTS` asserts pairwise non-identity and
  that each names its predecessor by identity.
- **A lawful program naming `perform` is admitted and then refused** — the
  shape/authority separation is executable, not asserted.
- **Refusals outlive success.** Verified *after* the lawful realization, not at
  the moment of refusal.
- **The durable boundary holds** against a host symbol, list, string and
  function object; and no CD/0 family can carry a function at all.
- **A validation is not portable** across environment identity, environment
  version, grammar version, or resource policy — four separate gates, three
  fired by planted faults because no public path can reach them.
- **One-pass substitution is structural, not disciplinary.** A hole is a data
  position; a bound value is spliced in **wrapped as a literal**, and literal
  payloads are leaves in every walk. The `literal-descends` mutant proves the
  leaf rule is load-bearing.

## 9. What it explicitly did NOT earn

- **No adoption, no freeze, no floor promotion.** `verify-form-floor.sh` is a
  separate command precisely so that folding Form /0 into the language floor
  stays a later owner decision, not a side effect of this file existing.
- **No claim about latent machines.** A scripted fake emitting fixed bytes
  demonstrates the *shape* of the discipline, not that it survives a real
  emission.
- **No independent conformance.** One model family wrote the layer, its
  operators, the inhabited program and its checks. The stranger audit is OWED
  against this closure too.
- **No macroexpansion story.** No `EXPANDED-FORM`, no expansion receipt — no
  implementation evidence made either unavoidable, so per ruling §3 neither was
  built.
- **No persistence.** A realization receipt is an in-image object; it is
  evidence *of* a realization, never a re-realization. PJ0's lane was untouched.
- **`:operator-identity-drift`, `:grammar-version-drift` and
  `:budget-policy-drift` are unreachable from any public path** — defence in
  depth, labelled `/PLANTED` in the suite, recorded rather than counted as
  naturally-tested gates.

## 10. Friction that should shape Form /1

1. **The operator set never met a governed layer that could mint something.**
   All four operators come from CD/0, which is why "incapable of granting
   authority" was checkable. The moment Form /1 wants an operator from Core /0
   or a Slice, that property stops being structural and needs a real gate.
   **This is the single largest untested assumption.**

2. **Four mutants kill by aborting the suite, not by naming a FAIL.** The
   one-pass block was rewritten to use `TRY-` entry points for exactly this
   reason; the rest were left and recorded. An aborting tooth still fails the
   run but tells a reader less — worth a sweep before this suite is ever cited
   as evidence.

3. **The literal-wrapping decision has a cost that will be felt.** A value
   inserted into a hole *can never be a program*. That is right for /0 and it
   forecloses code-into-code entirely. If Form /1 wants a hole that accepts a
   form, it needs a **separate production with its own validation** — not a
   relaxation of this one, which would silently reopen the injection path.

4. **`%snapshot` is unobservable against CD/0's immutability.** The surviving
   mutant was honest. `T-SNAPSHOT-IS-INDEPENDENT` now observes
   object-distinctness, but if Form /1 ever admits a mutable host
   representation, that tooth becomes load-bearing in a way it currently is not.

5. **The environment is a working existence proof for identity→object
   resolution without a global registry** — the exact hazard the 2026-07-26
   outside read named as *automatic evidence promotion*. It resolves names to
   handlers and produces no standing. Worth carrying into the resolver lane
   deliberately, and worth guarding: the pressure to widen it into a
   claim/receipt resolver will be real, and widening it is how it becomes the
   thing it was built to avoid.

---

## Ready state

```
worktree          <isolated worktree>
branch            language-form-0
commit            d1a86de9  (base 4c4f43ad)
merge state       NOT merged · NOT pushed · mirror NOT published
form floor        2 floors · 106 checks · 0 failed      (verify-form-floor.sh)
language floor    11 floors · 654 checks · 0 failed     unchanged
verify-all        6/6 suites green                      unchanged
mutation battery  8 planted · 8 killed · 0 survived
standing          candidate implementation · specification-frozen: no ·
                  adopted: no · stranger audit OWED · Slice /3 NOT opened
```

— **Claude Opus 5 (1M context)**, 2026-07-26
