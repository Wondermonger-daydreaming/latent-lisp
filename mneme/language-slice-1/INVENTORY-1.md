# INVENTORY /1 — Slice /0 substrate for Structured Proposition & Derived Judgment

*2026-07-23. Compiled by INDAGATOR (Opus 4.6 subagent; full-source read of
`slice0.lisp`, `slice0-projection.lisp`, `slice0-transmissibility.lisp`, API brief,
ARCHITECTURE §9, kernel0 `boundary.lisp`/`identity.lisp`/`procedure.lisp`; live
SBCL 2.4.6 probe against loaded `slice0.lisp`). Custodian-verified: the four
load-bearing line-claims (`proposition=` = `EQUAL` at slice0.lisp:194-195; the
bare-symbol boundary clause at slice0.lisp:187-190; `promotion-procedure`
`:admits (mode kind)` at slice0.lisp:344-347; the `*why-extractors*` registry at
slice0.lisp:388-392 with projection/transmission registrations at
slice0-projection.lisp:373 / slice0-transmissibility.lisp:498) re-read on disk by
the custodian this sitting. Slice /0 verified green FIRST (kernel0 selftest
`33 passed / 0 failed / 59 mutants killed`; SMOKE `6 ok, 0 failed`; slice0 +
kernel0 bytes diff-empty vs closure commit `167d2ae1`).*

*Classifications: REUSE-AS-IS / ADAPT-BEHIND-SLICE-1 / INVENTORY-EVIDENCE-ONLY /
REJECT / MISSING.*

---

**1. Accepted proposition representations — REUSE-AS-IS (the gate) /
INVENTORY-EVIDENCE-ONLY (its narrowness).**
The lawful vocabulary today is keywords / non-empty strings / integers / proper
lists thereof. The gate is `%require-proposition` (`slice0.lisp:182-192`); the
exact clause that refused bare symbols in Stranger /0 r1 is the `t` branch at
`slice0.lisp:187-190` ("bare symbols do not cross the canonical boundary"). It is
enforced at *every* proposition entry: `claim` (`slice0.lisp:328`), `witness :for`
(`slice0.lisp:271`), `local-value :recipe` (`slice0-transmissibility.lisp:129`),
`project-claim :public-form` (`slice0-projection.lisp:231`). Reuse the gate
unchanged — it already admits the nested structured shape (see #C1).

**2. Canonical Datum values usable as proposition parts — REUSE-AS-IS.**
`require-canonical` (`kernel0/boundary.lisp:60-85`) admits exactly four host types
via registered procedures — keyword→identifier, non-empty-string, integer,
proper-list→sequence (`boundary.lisp:101-124`). **There is no native plist/alist
datum and no plist/role discipline**: a plist crosses only as an ordered
`sequence-datum`. Canonicalization happens leaf-by-leaf: `%require-proposition`
walks and calls `require-canonical` per atom (`slice0.lisp:185`). So structured
propositions are representable *as ordered lists* but carry no role semantics at
the boundary.

**3. Proposition equality / matching — ADAPT-BEHIND-SLICE-1 (blocker for named
args).**
`proposition=` is raw `EQUAL` (`slice0.lisp:194-195`): a tree-walk,
order-sensitive, case-exact. Probe (#C1): two plists with the same roles in
different order are **NOT equal**. Named-argument matching — the whole point of
Slice /1 — needs role-keyed equality (predicate + argument set,
order-insensitive), which `EQUAL` cannot give. Architecture §9 already anticipates
this: "matching by canonical equality over roles rather than raw list shape"
(`ARCHITECTURE.md:174`). Slice /1 must supply a *new* structured-proposition
equality; do not widen `proposition=` (frozen).

**4. `promotion-procedure` — ADAPT-BEHIND-SLICE-1.**
Structure: kernel0 descriptor + `:admits` list of `(mode kind)` pairs
(`slice0.lisp:344-358`); `%procedure-admits-p` matches a witness's `(mode kind)`
(`slice0.lisp:365-368`); `raise` consults it at `slice0.lisp:544-546`. The kernel0
descriptor (`procedure.lisp:32-49`) has slots for
id/version/judgment-class/input-domain/result-vocabulary/evidence-requirements/
bounded-unknowns — **no premise-schema slot, no logical variables**. A
schema-bearing "derivation procedure" is a *parallel construct*, not a slot-in:
`:admits` governs support-shape admissibility, not premise discharge. Reuse the
`(mode kind)` admissibility idea; add premise schemas alongside.

**5. Support records & the proposition-match gate — INVENTORY-EVIDENCE-ONLY
(single-proposition assumption is the blocker).**
`witness :for` links one witness to one proposition (`slice0.lisp:242-290`). The
gate that fired in both stranger trials is `%evaluate-promotion`
`slice0.lisp:495-500`: `matching` = witnesses whose `witness-for` `proposition=`
the claim's **single** `p` (`claim-proposition`). **`raise` iterates many
witnesses but assumes ONE proposition** — the claim's. There is no multi-premise
machinery: no way to say "premise A discharged by w1, premise B by w2." Slice
/1's derived-judgment premises are exactly this missing structure.

**6. Receipts & the `why` registry — REUSE-AS-IS.**
`promotion-receipt` (`slice0.lisp:373-383`) issued on every attempt. The `why`
extractor registry `*why-extractors*` (`slice0.lisp:388-407`) is a `defvar` that
later modules extend by `push` at load (projection `slice0-projection.lisp:373`;
transmission `slice0-transmissibility.lisp:498`) — **the registry is the public,
documented extension seam** for a new receipt type (it is package state; the
closure's escape-surface note applies to it as to all package state). A Slice /1
`derivation-receipt` type registers here exactly the way projection/transmission
already do. This is the cleanest reuse in the substrate.

**7. `receiver-context` & projection — REUSE-AS-IS (context) /
INVENTORY-EVIDENCE-ONLY (the vacuous loop).**
`receiver-context` (`slice0-projection.lisp:53-76`) models position
(accessible-supports / executable-procedures / recognized-authorities /
accepted-representations). `project-claim` reconstructs rather than copies
(`slice0-projection.lisp:188-368`). Receiver-relative premise reconstruction hooks
at step 4 authority recognition (`262-285`) and step 6 the receiver's own `raise`
(`309-319`). The Stranger /1 recognition loop that "ran vacuous" corresponds to
the fact that recognition here is authority-membership only (`member src
(recognized-authorities)`, `slice0-projection.lisp:266-268`) —
**signer-recognition of a support token is never represented**; that is precisely
the S3 hole Slice /1 must close.

**8. Pattern / variable / unification machinery — MISSING (proven by search).**
Searches run over `kernel0/` + `language-slice-0/*.lisp` (excluding `.md`,
selftest, fixtures): `unif`, `pattern`, `logical.var`, `schema`, `premise`,
`match-var`, `binding`, `?var`, `substitut`. Only unrelated hits: "schema" =
closed-field constructor validation; "binding" = descriptor/version binding.
**No unifier, no logical variables, no pattern matcher exists.** Slice /1 builds
this from zero — inside Slice /1, not as a new Mneme subsystem.

**9. Sites where an opaque proposition token hides domain anatomy — each must
carry structured propositions:**
- `claim :proposition` (`slice0.lisp:314-337`)
- `witness :for` — first-order P (`slice0.lisp:242-290`)
- testimony attribution `(:asserted S P)` — P nested opaque (`slice0.lisp:197-201`,
  gate `272-281`)
- `procedure :admits` — `(mode kind)`; *kind* is the flat opaque stand-in for
  support anatomy (`slice0.lisp:353-357`)
- projection `target-prop` / `public-form` (`slice0-projection.lisp:208, 231-242`)
- `exercise-value :mint-for` and `local-value :recipe`
  (`slice0-transmissibility.lisp:169, 129`)

The S3 finding lives at the `:admits` + `witness-for` join: an
`(:artifact-admissible digest sig)` list passes as a lawful proposition (probe
#C1) and matches by `EQUAL`, so admissibility is granted with signer-recognition
never represented.

---

## MINIMUM REUSABLE SUBSTRATE

Build Slice /1 on, without modification: (a) the proposition **boundary gate**
`%require-proposition` + `require-canonical` (keywords/strings/integers/
proper-lists — structured shapes already pass); (b) `claim` / `witness` /
`judgment-record` / `promotion-receipt` records and their read-only lineage
discipline; (c) the `raise` grant/refuse skeleton and its typed
`slice0-condition` families; (d) the **`*why-extractors*` registry** as the
extension seam for a `derivation-receipt`; (e) `receiver-context` +
`promotion-procedure` descriptor-wrapping as-is.

## CONCRETE BLOCKERS

- **B1 — `proposition=` is order-sensitive `EQUAL`** (`slice0.lisp:194`; probe:
  role-reorder ⇒ NIL). Named-argument matching cannot use it. *Adaptation layer
  required*: a structured-proposition equality keyed on predicate + named
  arguments. This does **not** force a defect receipt — the shapes flow (probe
  #C1: nested keyword plists and the `:artifact-admissible` token both construct
  a `CLAIM` cleanly).
- **B2 — single-proposition `raise`** (`slice0.lisp:495-500`): one claim → one
  proposition → witnesses filtered to it. Multi-premise derived judgment needs a
  parallel evaluator; `raise` itself is frozen. *Parallel construct required.*
- **B3 — no premise slot on the procedure descriptor** (`procedure.lisp:32-49`)
  and no variables/unifier anywhere (#8). Premise schemas with logical variables
  are wholly new code.
- **B4 — `:admits (mode kind)` cannot express predicate/argument admissibility**
  (`slice0.lisp:347`); the S3 hole. Slice /1's admissibility must key on
  proposition anatomy, not a flat `kind`.

Frozen Slice /0 forces **an adaptation layer** (B1, B4) but **no bounded defect
receipt** — the canonical boundary accepts the shapes Slice /1 needs (probe REPL
evidence, #C1).

**#C1 probe evidence (SBCL 2.4.6, loaded `slice0.lisp`):**
`(claim :proposition '(:proposition (:predicate :tests-passed) (:subject (:suite
"suite-a")) (:qualifier (:as-of (:ordinal 41)))) …)` ⇒ **OK CLAIM**.
`(:artifact-admissible "digest-abc" "sig-xyz")` ⇒ **OK CLAIM**. Nested bare
symbol ⇒ **REFUSE malformed-slice0-shape**. `proposition=` on role-reordered
plists ⇒ **NIL** (order-sensitive).

## CHARTER QUESTIONS (inventory cannot settle — answered in
LANGUAGE-SLICE-1-CHARTER.md)

1. Is a structured proposition a **new record type** (predicate + named-argument
   map, with its own canonical equality), or a *convention over lists* validated
   by a schema?
2. Does named-argument matching require **argument-order insensitivity** (a role
   map) — and if so, how does that reconcile with kernel0's boundary, which only
   has ordered `sequence-datum` (no plist datum)?
3. Do premise schemas carry **logical variables with unification**, or only
   ground named-argument matching?
4. Should a derived judgment reuse the frozen single-proposition `raise`
   per-premise and compose, or introduce a **new multi-premise act**? (B2
   forecloses widening `raise`.)
5. What is the closed vocabulary of derivation-receipt statuses; are
   `:mismatched` vs `:refuted` and `:inaccessible` vs `:ambiguous` distinguished
   **in code** with Slice /0's typed-condition rigor; one `derivation-receipt`
   type in `*why-extractors*` or several?
6. Must **signer-recognition** (the S3 gap) be a first-class premise closing the
   `:admits`/`witness-for` join — or a separate authority check layered on
   projection's `recognized-authorities`?
7. Does the governed `raise` act get *extended* to consult premise schemas, or
   does Slice /1 add a wrapping act that calls `raise` internally (the
   `project-claim` precedent, `slice0-projection.lisp:311-317`)?
8. How are premise schemas **versioned** — via the kernel0 descriptor
   `:version`, or an independent schema-identity in a new domain?

— INDAGATOR (Opus 4.6), custodian-verified and filed by Claude Fable 5 (CC seat)
