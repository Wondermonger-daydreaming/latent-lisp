# LANGUAGE SLICE /2 — CANDIDATE /0 CLOSURE

*What was built under `LANGUAGE-SLICE-2-WORK-ORDER-0.md`, what it costs, and
what it does not do. Nothing here is frozen.*

```
specification-frozen:      no
public-api:                candidate /0 surface
core0 exports:             61 → 62   (exactly one, D2-0.7)
slice1 exports:            74 → 74   (slice1.lisp byte-untouched)
slice0 / kernel0:          untouched
stranger audit:            OWED, against this closure too
```

---

## 1. Suites, as run

```
kernel0-selftest            33 passed · 59 mutants killed · 0 failed   (untouched)
core0-selftest              29 /  0                                    (baseline 29/0)
core0-issuance-selftest     73 /  0                                    (baseline 59/0, +14)
slice1-selftest            123 /  0                                    (baseline 123/0)
slice2-selftest             75 /  0                                    (new)
SMOKE-1                      9 /  9                                    (baseline 9/9)
SMOKE-2                     10 / 10                                    (new)
de-bibliotheca-peregrina   108 /  0                                    (baseline 97/0, +11)
de-codice-restaurando      101 /  0                                    (baseline 89/0, +12)
de-cursore-aereo            23 /  0                                    (baseline 23/0)
de-ponte-usto               17 /  0                                    (baseline 17/0)
```

No existing assertion was weakened, deleted or renumbered. Every new check is
appended.

---

## 2. What the two migrations actually did

**`de-bibliotheca-peregrina` — Movement X. The loan settles.** The He-9
dispatch account was performed against the `:clean-commit` script, so it
genuinely reports an acknowledgment and a completed attempt. The source-bound
road therefore reaches settlement lawfully, and the loan moves from
`:DISPATCH-UNACKNOWLEDGED` to `:SETTLED` on the receipt's own disposition. That
is reported rather than engineered: the account was not chosen to make the
movement land, it is the account Movement VII already produced.

Movements I–IX are untouched. Their finding stands as measured on the surface
that existed when they were written, and the fabricated ledger witness and its
raised claim return in Movement X as negative probes — where both are refused,
and where the receipt shows Slice /1 still saying `:SATISFIED` beside Slice /2
saying `:NOT-ADMITTED`.

**`de-codice-restaurando` — Movement X. Nothing settles, deliberately.** The
post-treatment standing is derived under a two-contract schema: the completion
premise is source-bound, its sibling accepts the conservator's own `:SURVEY`
witness with the ceiling written `:ASSERTED`. The same witness species is
admitted at one premise and refused at the other **inside one derivation**,
which is the per-premise claim tested rather than asserted.

The workshop's file is **not** rewritten. `WO-1101` still reads
`:TREATED-UNASSESSED` and `XR-7` still reads `:NOT-SAFE-TO-EXHIBIT`, because
those were the decisions actually taken under the schemas actually in force.
A standing derived later under a new schema version is a new fact with a new
date, not a correction to an old record.

Both applications had the sentence *"No bridge is proposed and none should be
read in"* in their closings. A bridge was built and both now walk one, so in
both files that sentence is **withdrawn and dated** rather than left standing.

---

## 3. Costs and holes, named

**A discarded base grant.** Every recognized support reaches the base Slice /1
derivation, so when the base grants and Slice /2 then refuses, a Slice /1 grant
is computed and thrown away. The alternative — pre-filtering — was implemented
first and rejected because it makes an unadmitted support *vanish*, reproducing
the `CHARTER-DELTA-3` defect one layer up. `raise` writes no registry and no
store, so the discarded value is unreachable; and the base receipt rides in the
Slice /2 receipt, so the fact is visible rather than hidden.

**A structural copy of a source basis is not admitted.** The established-basis
registry is an `EQ` table. This is stricter than Core /0's exact-content
registry and is stated rather than smoothed: a reconstruction of a basis is
refused, and Slice /2 does not pretend copies are safe.

**A source basis cannot be transported across images**, serialized, or
persisted. Nothing here earns durability.

**The granted claim does not carry the Slice /2 contract.** `derive/2` returns
the Slice /1 grant, narrowed — it does not mint a second, competing promotion
for one act. A downstream consumer holding only the claim sees a Slice /1
judgment; the admission record lives in the Slice /2 receipt. This is the same
shape as the finding `de-bibliotheca-peregrina` `[IX-10]` recorded one layer
down, and it is not repaired here.

**One defect this build's own teeth caught, recorded because a silent fix is a
lost lesson.** `derive/2` originally checked that the registered base schema
matched by `judgment-schema-identity`. That identity is derived from
`(name, version)` **alone**, so the check was vacuous against a registry that
had been cleared and repopulated with a different anatomy under the same key.
Measured, not assumed; repaired to an `EQ` check against the registered object.

**The whole apparatus is measured against scripted fake adapters.** A Core /0
account is a real governed in-image act and not evidence that any external deed
occurred. If an adapter lies to Core /0, every reader in this slice returns
exactly what it returns now.

---

## 4. The ceiling, once more

A source basis establishes at most:

> this exact canonical account content was minted by the Core /0 runtime in
> this Lisp image, for this request, and the account **reports** the stated
> field.

What Slice /2 changed is narrow and real: at a source-bound premise, evidence a
program minted with its own hand is no longer indistinguishable from evidence
the runtime issued, the refusal is recorded against a named contract, and a
reader can see which support discharged which premise under which ceiling. The
frontier did not vanish. It moved from *"the program asserted it"* to *"the
runtime issued it"*, and the distance from there to the world is unchanged.

**Self-consistency, not corroboration.** One model family wrote this language,
both inhabited applications, every ruling this movement rests on, and this
text. Nothing here is independent verification.

---

*Built and verified against SBCL 2.4.6, operation-checked through the wrapper,
in an isolated clone with no git remotes. Nothing was committed.*

— **PONS, builder, 2026-07-25**
