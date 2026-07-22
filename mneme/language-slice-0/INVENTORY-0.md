# INVENTORY-0 — Existing Claim / Witness / Condition / Descriptor / Explanation Machinery

**Bounded observational artifact.** Step 1 of the R6 execution order
(`WORK-ORDER-0.md` §123). Prepares the substrate reading for
`LANGUAGE-SLICE-0-CHARTER.md` (step 2) and `de-promotione.lisp` (step 4). This
file **inventories and classifies**; it designs nothing, implements no forms,
amends no file, writes no roadmap.

- **Officer:** ASSIZER (Opus 4.8 subagent)
- **Date:** 2026-07-22
- **Runtime evidence:** `sbcl` on PATH resolves to `~/.local/sbcl-2.4.6/bin/sbcl`;
  `(lisp-implementation-version)` = **2.4.6** (operation-checked before any run).
  `kernel0/kernel0-selftest.lisp` run read-only: **33 passed, 0 failed, 59
  planted mutants killed, 0 survived, 24 controls fired, 0 controls failed.**

### Sweep territory actually covered

| Area | Depth |
|------|-------|
| `kernel0/package.lisp`, `conditions.lisp`, `records.lisp`, `procedure.lisp`, `folds.lisp` | **read in full** |
| `kernel0/outcome.lisp`, `manifestation.lisp` | **read in part** (grep-targeted: axis, interpretation-descriptor, causal-claim, projection-receipt) |
| `kernel0/identity.lisp`, `boundary.lisp`, `determinacy.lisp`, `uncertain-effect.lisp`, `manifestation.lisp` (full), `outcome.lisp` (full) | **NOT finished** — referenced through package exports + call sites only |
| `language-slice-0/de-projectione.lisp` (+ D1–D5), `WORK-ORDER-0.md` | **read in full** |
| `latent-mvp/evidence-kernel.lisp` | **read in full**; `surviving-witness.lisp` grepped |
| `latent-mvp/` remainder (`kernel.lisp`, `judgment.lisp`, `certificate-kernel.lisp`, `continuity.lisp`, `handoff-kernel.lisp`, `counterexample-closure.lisp`, `conformance-walk.lisp`, `kernel-hardened.lisp`, …) | **NOT finished** — filenames + role only |
| `lci0/` | **NOT finished** — `common-lisp/package.lisp` head + `spec/` titles only (byte-frozen, READ-ONLY) |
| `spec/`, `architecture/`, `canon/canonical.lisp`, `language-a/validator.lisp`, `v0.1/`, `v0.2/`, `v0.3/`, `latent-mvp/boundary/` | **NOT finished** — headers / grep only |
| `atelier/` (17 `.lisp` specimens) | **NOT opened** — filenames only |

The de-promotione needs (`WORK-ORDER-0.md` §83, §131): **claim · witness ·
checked `raise` · transition receipts · typed conditions · lawful restarts ·
structured `why`**, over the concrete domain of an *honest test runner*
(launched → exited → suite-completed → output-parsed → reported-passing →
expected-suite-matched → release-admissible), whose failure mode is *execution
evidence silently becoming verification standing.*

---

## A. Kernel /0 findings (the governed pure core — conformance-verified, immutable, typed)

Every object below is an **immutable `defstruct`** with a strict keyword
constructor (`%strict-constructor-arguments`), read-only slots, defensive
`%snapshot-tree` copy-out, and no mutator. All conditions are subtypes of
`kernel0-condition`; all refusals route through `signal-kernel0`.

### A1. `claim` — REUSE-AS-IS / ADAPT-BEHIND-LISP+-SURFACE
- **Path / symbol:** `kernel0/records.lisp:1386` `claim` (`make-claim`, `%validated-claim`).
- **Status:** public (exported).
- **Runtime rep:** immutable struct — `claim-id`, `content-datum` (canonical CD/0 datum), `source-ids`, `origin`, `validation-records`, `integrity-records`, `visibility-records`, `determinacy`, `bounded-unknowns`.
- **Distinction enforced:** standing rides **typed constructed records only** (K0E-18/19/20), never an opaque list; each standing record MUST name **this** claim as `:subject-id` and (integrity/visibility) **this** claim's exact canonical representation (`equal-datum`) — kills standing-laundering and redaction-collapse. `origin` is one of `:asserted :observed :derived :reconstructed`, historical, no writer slot.
- **Merely documented / assumed:** `:checked` validation with empty evidence is lawful "only when the procedure defines an inspectable negative check" — **procedure-relative, NOT structurally enforced** (flagged in-code). Single-representation ruling assumed (multi-representation claim is a future lane).
- **Mutation:** none. `revalidate`/`derive` return **new** claims.
- **Conditions:** `standing-inflation`, `bare-validation-scope`, `bare-visibility-scope`, `malformed-constructor-shape`, `unresolved-identity`, `noncanonical-durable-value`.
- **Restarts:** none at construction.
- **Explanation:** accessors expose every standing facet; `claim-validated-under-p` / `claim-published-to-p` are the inspection surface.
- **RPPTAT fields (receiver / proposition / procedure / time / authority / transmissibility):** proposition = `content-datum`; procedure = *inside* validation-records (per record), not on the claim; authority = `source-ids` + per-record principals; **receiver / time / transmissibility = absent by design** (time: §13.2 no-timestamp discipline; receiver: de-projectione's concern; transmissibility: de-infando's).
- **Tests:** kernel0-selftest tests 18–22, mutants `sealed-to-verified`, `published-to-truth`, `foreign-subject-*`, `seal-over-other-representation`.
- **Coupling:** none to Language A. Pure kernel + CD/0.
- **Suitability:** **the single most load-bearing reuse candidate.** de-promotione's `claim` is this claim, or a Lisp+ surface over it.

### A2. `validation-record` — ADAPT-BEHIND-LISP+-SURFACE (the closest existing "witness")
- **Path / symbol:** `records.lisp:936` `validation-record` (`make-validation-record`).
- **Status:** public.
- **Runtime rep:** immutable struct — `status` ∈ `{:unchecked :checked :verified :refuted}`, `subject-id`, `validator-principal-id`, `procedure-id`, `procedure-version`, `scope`, `evidence`, `bounded-unknowns`.
- **Distinction enforced:** a **4-rung standing ladder** keyed by status; `:verified`/`:refuted` MUST bind subject+validator+procedure+version+scope AND non-empty evidence; `:checked` MUST bind the same minus evidence; `:unchecked` MUST still name subject+scope. Standing is **procedure-and-scope-relative** — there is deliberately no context-free `verified-p`.
- **Merely documented:** the `:checked`-empty-evidence proviso (procedure-relative, see A1).
- **Mutation:** none. **Conditions:** `bare-validation-scope`, `malformed-constructor-shape`, `identity-drift`. **Restarts:** none.
- **Explanation:** `claim-validated-under-p` (A6) is its query.
- **RPPTAT:** proposition = `subject-id`; procedure = `procedure-id`+`procedure-version`; authority = `validator-principal-id`; receiver/time/transmissibility absent.
- **Coupling:** none. **Suitability:** the honest-test-runner "witness" maps onto this shape; the charter must decide whether a de-promotione `witness` **is** a validation-record or a new object (see MISSING M2, Q2).

### A3. `verdict` + `joint-verdict` — ADAPT / REUSE-AS-IS (structured `why` carrier)
- **Path / symbol:** `procedure.lisp:464` `verdict` (`make-verdict`); `:571` `joint-verdict` (`make-joint-verdict`); `joint-verdict-divergent-p`.
- **Status:** public.
- **Runtime rep:** `verdict` = `value` ∈ `{:pass :fail :not-run}` + `procedure-id` + `condition-ids` + `requirement-ids`. `joint-verdict` = `structural` verdict + `semantic` verdict.
- **Distinction enforced:** **verdict REASON law** — a `:fail` MUST carry ≥1 condition-id or requirement-id ("a reasonless failure is uninspectable"); a `:pass`/`:fail` MUST name its procedure. **No boolean collapse** — there is deliberately **no** `joint-verdict-pass-p`, and none may be added; structural PASS with semantic FAIL is lawful and survives.
- **Merely documented:** nothing material.
- **Mutation:** none. **Conditions:** `malformed-constructor-shape`. **Restarts:** none.
- **Explanation:** IS the explanation object — the inspectable "why" of a judgment.
- **RPPTAT:** procedure = `procedure-id`; the reason lists are the structured why; receiver/proposition/time/authority/transmissibility absent.
- **Tests:** mutants `flattened-boolean-verdict`, `flattened-counter-verdict`, `reasonless-fail`, `anonymous-structural-pass`, `anonymous-semantic-fail`.
- **Coupling:** none. **Suitability:** de-promotione's structured `why` should reuse `verdict`'s reason-law shape; the no-collapse discipline is exactly what "execution evidence must not silently become verification standing" needs (see D-evidence).

### A4. `procedure-descriptor` + `validate-interpretation-against-descriptor` — ADAPT (the core hypothesis, in kernel form)
- **Path / symbol:** `procedure.lisp:32` `procedure-descriptor` (`make-procedure-descriptor`); `:271` `validate-interpretation-against-descriptor`.
- **Status:** public.
- **Runtime rep:** descriptor = `procedure-id`, `version` (nonnegative integer, immutable), `judgment-class` ∈ `{:structural :semantic}`, `input-domain` (strict `:kinds`/`:statuses` plist), `result-vocabulary`, `evidence-requirements`, `bounded-unknowns`. A descriptor is **data resolved by the caller** — no registry, no global table.
- **Distinction enforced (K0E-23/25):** **a structural procedure MUST NOT license `:accepted`/`:rejected`; those require a `:semantic` descriptor.** Cache-must-match (a cached class/version MUST equal the descriptor's). Domain + evidence law: an accepted/rejected semantic judgment MUST bind the manifestation it judges, whose kind/status fall inside the descriptor's input-domain, with every declared evidence requirement present.
- **Merely documented / deferred:** global descriptor resolution is a **named exclusion** (K0E-23/global-descriptor-resolution) — the caller owns resolution.
- **Mutation:** none. **Conditions:** `interpretation-class-violation`, `identity-drift`, `malformed-constructor-shape`. **Restarts:** none.
- **RPPTAT:** procedure = `procedure-id`+`version`; the rest carried by the axis/manifestation it judges.
- **Tests:** mutants `structural-licenses-accepted`, `procedure-version-drift`, `same-id-version-conflicting-class`, `semantic-domain-rejects-*`, `semantic-required-evidence-*`.
- **Coupling:** none. **Suitability:** **structurally identical to de-promotione's hypothesis** — "making evidential promotion an explicit checked act prevents execution evidence from silently becoming verification standing" ≡ "a structural procedure MUST NOT license acceptance." The `descriptor` half of the R6 order (`claim, witness, condition, descriptor, explanation`) is this.

### A5. `kernel0-condition` family + `signal-kernel0` + `with-kernel0-restarts` — REUSE-AS-IS (typed conditions) / ADAPT (restart names)
- **Path / symbol:** `conditions.lisp` — `kernel0-condition` (base, `:38`), `%define-kernel0-condition-family` (8 families, `:96`–`189`), `signal-kernel0` (`:223`), `with-kernel0-restarts` (`:271`), `%permitted-restart-name-p` (`:27`).
- **Status:** public.
- **Runtime rep:** base condition carries `process-id`, `attempt-id`, `seat-id`, `operation-id`, **`failed-invariant`** (required non-empty string), `evidence-ids`, `frontier-crossed-p`, `permitted-restarts`, `requirement-id`, `offending-field`, `offending-value`. Standing family (`§20.7`): `standing-inflation`, `witness-separation-violation`, `reconstruction-origin-erasure`, `bare-visibility-scope`, `bare-validation-scope`, `exposed-principal-missing`.
- **Distinction enforced:** **every** refusal is a typed subtype with structured diagnostic context (the structured "why" of a *refusal*, distinct from `verdict`'s "why" of a *judgment*). `with-kernel0-restarts` accepts **only** the 7 whitelisted restart names; the signalling site's `permitted-restarts` must match.
- **The 7 lawful restart names (frozen):** `supply-resolved-identity`, `choose-private-staging-channel`, `request-lawful-capability-restoration`, `begin-reconciliation`, `authorize-supersession`, `preserve-payload-mark-invalid`, `stop-and-export-evidence`. The two **standing-transition** restarts are `begin-reconciliation` and `authorize-supersession`.
- **Mutation:** conditions defensively snapshot `offending-value` on construction. **Restarts:** the mechanism itself.
- **Coupling:** none. **Suitability:** the typed-condition apparatus + `signal-kernel0` + `with-kernel0-restarts` are **directly reusable**. de-promotione's *own* promotion conditions and its *own* restart names are MISSING (M5) — and the frozen whitelist is a hard fork point (Q4).

### A6. `claim-validated-under-p` / `claim-published-to-p` — ADAPT (scoped standing queries)
- **Path / symbol:** `records.lisp:1705`, `:1739`.
- **Distinction enforced:** standing is **only** answerable relative to a (procedure, scope) or scope — no context-free predicate exists (K0E-22). Defense-in-depth: the query independently rechecks subject + representation.
- **Conditions:** `standing-inflation`. **Tests:** mutant `context-free-standing-accessor`, `publication-query-ignores-representation`.
- **Suitability:** the shape for de-promotione's "is this claim admissible under procedure P / scope S" inspection.

### A7. `revalidate-claim` — REUSE-AS-IS (the lawful append) & `promote-origin` — REUSE-AS-IS (the refusal precedent)
- **Path / symbol:** `records.lisp:1594` `revalidate-claim`; `:1621` `promote-origin`.
- **Distinction enforced:** `revalidate-claim` **appends** a validation record and returns a new claim; **origin is unchanged** — "verification strengthens validation only; a `:reconstructed` claim remains `:reconstructed`" (§15.7). `promote-origin` is a **pure refusal surface**: every attempted origin promotion signals `standing-inflation` and never mutates.
- **Suitability:** these two set the governing rule de-promotione's `raise` must obey or consciously depart from (Q5): **forward validation-strengthening is lawful; rewriting historical origin is refused.** But neither is a *checked raise with a lawful restart* — that form is MISSING (M1).

### A8. `reconciliation-receipt` — ADAPT (transition-receipt precedent) & `supersession` — INVENTORY-EVIDENCE-ONLY
- **Path / symbol:** `records.lisp:398` `reconciliation-receipt`; `:90` `supersession`.
- **Runtime rep:** `reconciliation-receipt` = `target-attempt-id`, `procedure-id`+`version`, `new-evidence` (non-empty), **`previous-axis-values+determinacy`** → **`resulting-axis-values+determinacy`**, `unresolved-residue`. `supersession` = receipt-id, seat-id, predecessor→superseding attempt, `authorized-by` (claim/capability identity), `reason`, `fresh-exposure-p`, `precedence-rule`, `cost-effect-treatment`, `residual-unknowns`.
- **Distinction enforced:** the reconciliation-receipt is an **append-only refinement that records before-state, after-state, the new evidence, and the unresolved residue** — an exact structural precedent for a *promotion transition receipt*. Supersession requires a **new** attempt identity and a claim/capability authorizer.
- **Coupling:** both are keyed to **attempt/seat** lineage, not claim standing. **Suitability:** `reconciliation-receipt` = **ADAPT** (rebase its previous→resulting+evidence+residue shape onto claim standing). `supersession` = evidence only (attempt-axis vocabulary, not claim-standing).

### A9. `attempt-outcome-standing` (fold) + `check-retry-safety` — INVENTORY-EVIDENCE-ONLY (standing-as-derived precedent)
- **Path / symbol:** `folds.lisp:795` `attempt-outcome-standing` (`fold-attempt-outcome` `:894`); `check-retry-safety` `:510`.
- **Distinction enforced:** standing is **derived by fold from an immutable event list**, not stored as a mutable flag (§6.2: "occupancy MUST NOT be stored as a mutable flag"). `check-retry-safety` refuses blind retry into a seat with unresolved predecessor uncertainty unless reconciliation resolves or supersession authorizes — the closest existing "a standing transition must be checked" machinery.
- **Coupling:** attempt/seat/journal vocabulary. **Suitability:** evidence for *how* the lab models standing (as fold + refusal), not directly reusable for claim promotion.

### A10. `causal-claim` + `revise-causal-claim` — ADAPT (testimony ≠ evidence; carries D-evidence)
- **Path / symbol:** `manifestation.lisp:623` `causal-claim`; `:711` `revise-causal-claim`.
- **Runtime rep:** `subject`, `predicate`, `evidence`, `origin` (`:asserted :observed :derived :reconstructed`), `validation` facet.
- **Distinction enforced:** a causal *claim* (testimony) carries its own origin and a **separate** validation facet — testimony about P is structurally distinct from validation of P. `revise-causal-claim` returns a new record. **Suitability:** direct kernel witness for D-evidence "testimony about P is not automatically evidence for P."

### A11. Substrate: `durable-identity` / `make-identity` / `require-canonical` (CD/0 boundary), `determinacy` — REUSE-AS-IS
- **Path / symbol:** `identity.lisp` (`durable-identity`, `identity=`, `require-identity`); `boundary.lisp` (`require-canonical`, canonicalization procedures); `determinacy.lisp` (`determinacy`, `make-determinacy`).
- **Distinction enforced:** domain-tagged durable identities with `identity=` equality; every durable value canonicalized at a named boundary (`noncanonical-durable-value` refusal); **proposition-specific determinacy** with **no global uncertainty scalar** (`global-uncertainty-scalar-rejected`).
- **Coupling:** none (CD/0 is the shared canonical-datum layer). **Suitability:** unconditional substrate for any Lisp+ specimen.

---

## B. Non-kernel findings (ancestors, frozen subsystems, Language-A layer)

### B1. `latent-mvp/evidence-kernel.lisp` — INVENTORY-EVIDENCE-ONLY (the conceptual ancestor of de-promotione)
- **Path / symbols:** `witness` (`:34`), `witness-supports-p` (`:36`), `claim` (`:47`), `grade-event` (`:50`: `claim-id from to witness at reason`), `raise-claim` (`:52`), `grade-is-earned-p` (`:69`), `*witness-kind->grade*` ladder (`:27`).
- **What it demonstrates (all seven de-promotione failure modes, as passing tests):** an irrelevant/disagreeing/mistargeted witness cannot upgrade; a production receipt supports the *production* claim not the *world* claim; a fake `:observed` label earns nothing; raising mints a new revision and **never erases the asserted ancestor**. `raise-claim` = **checked raise** (refuses unless `witness-supports-p`), `grade-event` = **transition receipt** (from→to + witness + reason), the grade set `{:asserted :observed :executed :tested :derived :contract :classified}` = a **candidate standing ladder**.
- **Why NOT reusable as code:** uses raw `error` (not typed `kernel0-condition`), **no restarts**, mutable `copy-claim`/`setf`/`gensym`, ad-hoc `*now*`/`tick` timestamps. Language-A / Mneme-brick era; superseded by the governed kernel0.
- **Suitability:** **the blueprint for de-promotione's shape** (witness / raise / grade-event / earned-p / ladder), to be **re-expressed** in kernel0's immutable-typed-restart idiom. Companion: `surviving-witness.lisp` (same `witness`/`claim`/`grade`, plus `handoff-event`). Not opened as substrate — evidence only.

### B2. `lci0/` (Located Claim Identity /0) — REJECT-AS-EXPERIMENT-SPECIFIC (byte-frozen, READ-ONLY)
- **Path / symbols:** `lci0/common-lisp/package.lisp` — `lci-value`, `lci-failure`, `parse-json`, `verify-fixture-corpus`, `validate-claim-profile`, `validate-warrant-target`, `validate-scope`, `validate-interpretation-frame`, …
- **What it is:** a JSON/fixture-boundary **validator** for *located* public claim records + warrant/scope vocabulary; a distinct closed subsystem with its own CL+Python differential harness. Byte-frozen (mirror law — never edit).
- **Coupling:** fixture-schema-specific; its `warrant`/`scope` vocabulary is the ancestor de-projectione's `warrant` echoes (evidence for D3 grantability, D-evidence "warrant/proposition matching is a constitutive seam"), but the machinery is JSON-boundary validation, not standing-transition semantics.
- **Suitability:** reject for direct reuse; consult as warrant-vocabulary evidence only. **Not finished** (package head + spec titles only).

### B3. `language-a/validator.lisp` + `canon/canonical.lisp` — REJECT-AS-EXPERIMENT-SPECIFIC (Language A — flagged for coupling only)
- **Path / symbols:** `validator.lisp` — `*claim-standings*` = `(:asserted :observed :bounded-absence :externally-verified)`, conditions `unsupported-standing`, `answer-without-claim`, `scope-extension-requested`; a deterministic **coherence** checker for public Language-A judgment records. `canon/canonical.lisp` — the `mneme-canon/0` byte-stable printer for the Language-A judgment grammar.
- **Coupling:** **Language A** — explicitly out of bounds as substrate. The `*claim-standings*` set is a **third** candidate standing vocabulary (differs from both A2 and B1), which is a coupling-flag, not an import. The validator "checks whether a claim record states its relations coherently" and "owns coherence; neither owns truth" — a clean statement of the wall de-promotione must not cross.
- **Suitability:** reject; retain as vocabulary evidence and as the coherence/standing/truth separation precedent.

### B4. `v0.1/ v0.2/ v0.3/`, `latent-mvp/` remainder, `atelier/`, `spec/`, `architecture/` — INVENTORY-EVIDENCE-ONLY / NOT-FINISHED
- **v0.1–v0.3, latent-mvp/{kernel,judgment,certificate-kernel,continuity,handoff-kernel,counterexample-closure}.lisp:** the Language-A-era prototype lineage that kernel0 supersedes; evidence for the arc, not substrate. Not opened.
- **atelier/ (17 specimens: `de-corroboratione`, `de-testimonio-postumo`, `de-limine`, …):** creative jurisdiction specimens; experiment-specific. Not opened.
- Flagged not-finished; none is a de-promotione substrate candidate on present evidence.

---

## C. MISSING rows (de-promotione needs nothing in the tree provides)

### M1. Checked `raise` as a governed language form — MISSING
- **Need:** a form that takes (claim, witness/evidence, check) and either promotes standing or **signals a typed condition offering a lawful restart** — the R6 "checked `raise`."
- **What would enforce it:** nothing found as a governed form. `revalidate-claim` (A7) appends validation but offers no restart and performs no check-against-a-descriptor; `promote-origin` (A7) only refuses; `raise-claim` (B1) checks but uses raw `error`, no restart, mutable copy.
- **Searched:** `kernel0/*.lisp`, `latent-mvp/*.lisp`, `language-slice-0/*.lisp`.

### M2. A first-class `witness` object with receiver / authority / transmissibility — MISSING (in the governed core)
- **Need:** de-promotione names `witness` as a primitive. Kernel0's nearest is `validation-record` (A2), which carries procedure+scope+authority but **no receiver, no transmissibility, and no time**; `causal-claim` (A10) carries testimony but not a checked-support relation. B1's `witness` has authority/provenance/produced-at but is ungoverned.
- **What would enforce it:** nothing in the governed core. **Searched:** as M1.

### M3. An ordered STANDING LADDER for the test-runner domain — MISSING
- **Need:** launched → exited → suite-completed → output-parsed → reported-passing → expected-suite-matched → release-admissible, with lawful adjacency.
- **What provides a partial precedent:** `validation-record` status `{:unchecked :checked :verified :refuted}` (A2, 4 rungs); `*witness-kind->grade*` (B1, 7 kinds); `*claim-standings*` (B3, 4 rungs) — **three different vocabularies, none the test-runner ladder, none ordered as an adjacency law.**
- **Searched:** as M1.

### M4. A claim-standing transition receipt (from→to standing + witness + why) — MISSING
- **Need:** an append-only receipt binding previous standing, resulting standing, the witness that licensed it, and the structured why.
- **What would enforce it:** `reconciliation-receipt` (A8) has the previous→resulting+evidence+residue **shape** but is keyed to attempt-axis values, not claim standing; `grade-event` (B1) has from→to+witness+reason but is ungoverned. Neither is a governed claim-standing transition receipt.
- **Searched:** as M1.

### M5. Lawful restarts specific to standing transitions — MISSING (mechanism present, names absent)
- **Need:** restart names around a refused promotion (e.g. supply-a-supporting-witness, raise-with-evidence, refuse-and-hold-at-current-standing).
- **What would enforce it:** `with-kernel0-restarts` + `%permitted-restart-name-p` (A5) supply the mechanism, but the **whitelist is frozen at 7 names**, only `begin-reconciliation` and `authorize-supersession` touch standing transitions, and neither fits claim promotion. Adding names is a fork against a byte-frozen file (Q4).
- **Searched:** `kernel0/conditions.lisp`, `kernel0/package.lisp`.

### M6. Structured `why` wired to a standing transition — MISSING (carrier present, wiring absent)
- **Need:** the reason a raise succeeded or was refused, attached to the transition.
- **What would enforce it:** `verdict` (A3) is a complete why-carrier and the `kernel0-condition` triple (`failed-invariant`/`requirement-id`/`offending-field`) is a complete refusal-why, but **neither is wired to a claim standing transition** — no transition object exists to carry them (see M4).
- **Searched:** as M1.

---

## D. D1–D5 evidence (from `de-projectione.lisp`, weighed as evidence, not as governing semantics)

| Discovery | Kernel witness already present |
|-----------|-------------------------------|
| D1 — projection results compose → structured **receipts**; support-mode × standing × obligation must not be flattened | `reconciliation-receipt` (before→after+evidence+residue, A8); `joint-verdict` no-boolean-collapse + `procedure-descriptor` structural/semantic wall (A3, A4) are the anti-flattening precedent |
| D2 — receiver descriptor must carry **domains** (a modeling commitment) | absent in the claim/witness core; `manifestation-source-boundary` + `input-domain` (A4) are the nearest domain-bearing shapes — **de-projectione's, not de-promotione's** |
| testimony about P ≠ evidence for P | `causal-claim` vs `validation-record` (A10, A2); the evidence-kernel's 7 attacks (B1) enact it |
| source context = unresolved semantic input | `manifestation-source-boundary` / `axis-evidence`; not resolved anywhere — a live seam |
| warrant/proposition matching + redaction derivation = constitutive seams | `visibility-record` + `redaction-receipt-id` (A1) and lci0 warrant vocabulary (B2) touch it; **no warrant-arithmetic exists** — de-projectione/de-infando territory |

D5 (bare-assertion-survives fork) is a standing-semantics question the charter must settle for de-promotione too (Q7).

---

## THREE CLOSING OUTPUTS

### 1. Smallest reusable substrate for de-promotione
Kernel /0 symbols, reusable now (immutable, typed, conformance-verified at SBCL 2.4.6):

- **Claim + standing:** `claim` / `make-claim` / `revalidate-claim` / `promote-origin` (refusal) / `claim-validated-under-p` / `claim-published-to-p` — `kernel0/records.lisp`.
- **Witness (as validation):** `validation-record` / `make-validation-record` — `records.lisp`.
- **Structured why:** `verdict` / `make-verdict` / `joint-verdict` / `joint-verdict-divergent-p` — `kernel0/procedure.lisp`.
- **Descriptor (the core hypothesis):** `procedure-descriptor` / `make-procedure-descriptor` / `validate-interpretation-against-descriptor` — `procedure.lisp`.
- **Transition-receipt shape:** `reconciliation-receipt` / `make-reconciliation-receipt` — `records.lisp` (adapt onto claim standing).
- **Typed conditions + restarts (mechanism):** `kernel0-condition` + the `§20.7` standing family + `signal-kernel0` + `with-kernel0-restarts` + `%permitted-restart-name-p` — `kernel0/conditions.lisp`.
- **Substrate:** `durable-identity` / `make-identity` / `identity=` / `require-identity` (`identity.lisp`), `require-canonical` (`boundary.lisp`), `determinacy` / `make-determinacy` (`determinacy.lisp`).
- **Blueprint (evidence, re-express — do not import):** `witness` / `witness-supports-p` / `raise-claim` / `grade-event` / `grade-is-earned-p` — `latent-mvp/evidence-kernel.lisp`.

### 2. Concrete blockers that cannot be solved inside Slice /0
*(none)* — every de-promotione need is either provided (§C reuse list) or a lawful **new** construction inside Slice /0 (M1–M6 are constructions, not blockers). The one caution, not a blocker: extending the frozen 7-name restart whitelist (M5) must be done by de-promotione's **own** condition/restart layer, never by editing byte-frozen `kernel0/conditions.lisp` — Q4 decides whether that is a wrapper or a parallel apparatus.

### 3. Questions the charter must decide before implementation
1. Is de-promotione's standing set the `validation-record` ladder (`:unchecked/:checked/:verified/:refuted`), the evidence-kernel grade set (`:asserted/:observed/:executed/:tested/:derived/:contract/:classified`), the Language-A `*claim-standings*` set, or a new test-runner-specific ladder (launched…admissible)?
2. Is a de-promotione `witness` a **new** first-class object, or the existing kernel0 `validation-record`?
3. Does the transition receipt reuse `reconciliation-receipt`'s `previous→resulting+evidence+residue` shape rebased onto claim standing, or a new `grade-event`-style `from/to/witness/why` record?
4. Must de-promotione's lawful restarts extend the frozen kernel0 7-name whitelist, and if so does it do that in a **new** condition/restart layer (leaving `kernel0/conditions.lisp` byte-frozen) rather than editing the core?
5. Does `promote-origin`'s hard rule (origin is historical, never rewritten; verification strengthens validation only) govern de-promotione's `raise`, or does `raise` permit a genuine grade change that origin-promotion forbids?
6. Does the structured `why` reuse `verdict` (value + condition-ids + requirement-ids), the `kernel0-condition` triple (`failed-invariant`/`requirement-id`/`offending-field`), or both — one for a granted raise, one for a refused one?
7. (D5 fork) On an all-support-inaccessible / all-witnesses-refuting claim, does a failed promotion regrade-to-`:asserted` (bare assertion survives) or refuse outright (nothing survives)?
8. Does the `witness` carry a **time** field (as `evidence-kernel`'s `produced-at`) or inherit kernel0's deliberate no-timestamp discipline (§13.2 — list-ordinal only)?

---
*End INVENTORY-0 — ASSIZER (Opus 4.8), 2026-07-22. Observational only; no file amended; selftest run read-only.*
