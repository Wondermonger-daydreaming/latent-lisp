# POST-DE-CORROBORATIONE-PROGRAM-RULING-ERRATA-0.1.md

**Status:** Authorial Erratum 0.1
**Effective date:** 2026-07-15
**Applies to:** `POST-DE-CORROBORATIONE-PROGRAM-RULING.md`
**Character:** append-only, clarificatory, and narrowly precedential

## 0. Authority, retention, and exact scope of precedence

The original `POST-DE-CORROBORATIONE-PROGRAM-RULING.md` is retained in full and remains controlling except where this erratum expressly supplies a replacement reading or an additional gate. This erratum does not rewrite, replace, or silently broaden the original ruling. It alters no repository artifact, implementation, fixture, vector, canonical byte sequence, accepted specification, or merge history.

Where the original ruling and this erratum cannot both be satisfied, this erratum has precedence only on the following surfaces:

| Original-ruling surface | Scoped effect of Errata 0.1 |
|---|---|
| Opening summary language that may be read as treating LCI/0 implementation conformance as wholly closed | Replaced only as to implementation conformance by §1 of this erratum: **normative closure paid; implementation conformance partially open**. |
| §1 rows titled “Located Claim Identity /0” and “LCI/0 algebraic/metamorphic audit,” and any equivalent statement that the later algebraic audit is fully paid | Replaced by the state correction and implementation-use restriction in §1. LCI/0 normative semantics remain closed and are not reopened. |
| §3.5 item-bank composition | Supplemented by the positive-conclusion balance in §6. |
| §3.7 aggregation, resampling, and branch selection | Replaced or supplemented by §§2–3. The cell-weighted estimand and branch precedence stated here control. |
| §§3.7–3.10 and §3.14 insofar as they leave completeness, refusal, abstention, utility, truncation, deletion, or over-bounding thresholds unresolved | Supplemented by the mandatory anti-taxidermy freeze gates in §4. |
| §§3.5, 3.7, 3.9, and 3.14 insofar as no pre-bank synthetic precision gate is stated | Supplemented by §5. |
| Opening “Optional parallel lane” language and §4 insofar as concurrency may be inferred | Clarified by §7: P2a is `DORMANT-BUT-AUTHORIZED` by default and need not begin concurrently. |
| The final readiness line and any phrase that could be read as immediate authorization to “fire” the pilot | Replaced by §8. Only network-off packet construction is presently authorized. |

No other sentence, threshold, branch predicate, stop rule, cost ceiling, claim ceiling, firebreak, or evidentiary duty is displaced. Silence in this erratum is retention, not repeal. If a proposed reading would enlarge this erratum beyond the rows above, the narrower reading controls.

Nothing here reopens accepted CD/0, LCI/0, `de-corroboratione`, Mneme, or Language-A semantics. The LCI/0 findings below concern implementation conformance to already accepted semantics; they do not amend those semantics. This erratum authorizes no implementation, commit, push, merge, provider call, or target exposure.

## 1. LCI/0 current-state correction

### 1.1 Accepted later audit record

For this authorial correction, the completed later audit is identified as:

- branch: `origin/codex/lci0-algebraic-law-audit`;
- final audit commit: `7e013aab32c506a88fe1a474b0bb5515aa36eeee`;
- final tree: `21676366b67d308df48f1ae9eada92263ef98f7c`;
- hard-gate results: 84 hard-gate pass records and 4 fail records;
- reduction: two implementation defect families.

The four fail records are not four normative defects. They reduce to the following implementation-conformance findings against the already closed LCI/0 authority.

The controlling status is:

```text
NORMATIVE CLOSURE PAID;
IMPLEMENTATION CONFORMANCE PARTIALLY OPEN.
```

### 1.2 Concise state correction

| Surface | Audit finding | Correct standing after Errata 0.1 | Pilot consequence |
|---|---|---|---|
| LCI/0 normative model, identity semantics, relation semantics, and accepted errata | The audit did not reopen or replace normative authority. | **NORMATIVE CLOSURE PAID.** | No new identity or relation semantics may be invented for the pilot. |
| Common Lisp implementation | `LCI0-TEMP-022`: twelve different-modulus periodic comparisons improperly returned `:disjoint` where the relation was not admissibly totalized. | **IMPLEMENTATION CONFORMANCE PARTIALLY OPEN.** | The pilot builder must not invoke the affected different-modulus periodic-comparison surface. |
| Python implementation | `LCI0-TEMP-028`, `LCI0-SCOPE-015`, and `LCI0-CROSS-004`: six malformed temporal/scope calls leaked host exceptions across the required failure boundary. | **IMPLEMENTATION CONFORMANCE PARTIALLY OPEN.** | The pilot builder must not invoke the affected malformed temporal, scope, or cross-surface call paths. |
| Language-A emission-pilot construction | The proposed pilot does not require either affected surface. | **NOT BLOCKED BY THESE FINDINGS.** | Packet construction may proceed while the affected surfaces remain excluded. |
| Experiment lineage claims about LCI/0 | Prior convergence evidence remains real, but the later audit defeats an unqualified claim of complete algebraic conformance by both implementations. | **QUALIFIED CLAIMS ONLY.** | The lineage ledger must disclose the audit findings and may not certify both implementations as fully algebraically conformant until separate closure evidence exists. |

### 1.3 Normative replacement reading

Where the original ruling states or implies that the LCI/0 algebraic/metamorphic audit is paid without residue, it shall be read as follows:

> LCI/0 normative closure is paid. The later algebraic-law audit is complete as an audit and has disclosed bounded implementation defects. Common Lisp and Python implementation conformance are therefore partially open on the named surfaces. The audit findings do not reopen LCI/0 semantics and do not block Language-A emission-pilot construction because the pilot has no necessary dependency on those surfaces.

The pilot builder shall not directly or transitively invoke:

1. the Common Lisp different-modulus periodic-comparison behavior implicated by `LCI0-TEMP-022`; or
2. the Python malformed temporal, scope, or cross-surface call behavior implicated by `LCI0-TEMP-028`, `LCI0-SCOPE-015`, and `LCI0-CROSS-004`.

This restriction applies whether the invocation is proposed for item identity, source localization, scoring, replay, lineage, manifest closure, or convenience. An adapter may not conceal use of an affected surface by translating its output or catching its host exception and pretending conformance.

If an actual pilot integration proves to require one of those surfaces, the builder shall stop that integration and emit `PILOT-AUTHORITY-RETURN` with a minimized witness, including the smallest reproducible case, the exact affected implementation and audit identifier, the intended pilot dependency, and why an unaffected representation is insufficient. The pilot branch shall not patch LCI/0, locally totalize the relation, redefine failure behavior, or treat the audit finding as closed.

The experiment lineage ledger may state that LCI/0 normative closure is paid and that substantial prior convergence evidence exists. It may not state that both LCI/0 implementations are fully algebraically conformant, universally exception-safe, or audit-clean until the named findings have been separately repaired, verified, and closed under their own authority.

## 2. Primary estimand and resampling unit

### 2.1 Cell-level burden remains the per-call measure

For each frozen item `i`, fixed subject release `s`, and arm `a`, the per-call epistemic defect burden remains the original ruling’s quantity:

> the sum of unsupported assertions, scope errors, version errors, and erased unresolved residues, divided by the item’s predeclared scorable opportunities.

The denominator is fixed by the frozen key. It is not reduced because an answer omitted material, refused, truncated, or failed to instantiate an opportunity.

### 2.2 Primary estimand

For each predeclared paired contrast, the primary estimand is:

> **the unweighted mean of paired per-call burden differences across the frozen item × subject cells.**

Thus every frozen item × subject cell receives equal weight, regardless of the number of scorable opportunities attached to that item. For the proposed 24-item × three-subject design, the complete-data estimand for each contrast is the arithmetic mean of 72 paired cell differences.

The paired cell differences are those already named in the original ruling:

- `D_N`: Language A minus Scaffold;
- `D_S`: Scaffold minus Persona;
- `D_P`: Persona minus ordinary natural language.

A cell contributes to a contrast only through the paired observations for that contrast. A single observed arm may not be substituted for its missing partner, and no arm-only value may be reweighted to impersonate a pair. `FREEZE-RULINGS.md` must close the treatment of missing or unanalyzable pairs before exposure. The target estimand remains the finite mean over the frozen cells; unexplained or non-ignorable missing pairs may force `B-INCONCLUSIVE` under the original census and admissibility gates.

### 2.3 Secondary opportunity-weighted estimand

A pooled opportunity-weighted burden may be retained as a secondary sensitivity estimand. It must be labeled `secondary`, must disclose its numerator and denominator, and may not:

- replace the cell-weighted primary result;
- determine the banked branch;
- be promoted because its sign or interval is more favorable; or
- be described as the preregistered primary estimand.

The primary receipt shall present the cell-weighted result first. Any divergence between the cell-weighted and opportunity-weighted results is a substantive secondary finding and must be retained rather than averaged away.

### 2.4 Pilot bootstrap

The nonparametric pilot bootstrap shall use the **item** as the resampling unit and preserve the four predeclared item families as strata.

For each bootstrap replicate:

1. sample six item identities with replacement inside each of the four frozen item families;
2. retain every subject and arm observation attached to each sampled item identity;
3. compute the paired per-call burden differences for the retained item clusters;
4. average those differences with equal item × subject cell weight; and
5. apply the frozen branch calculations without resampling scorable opportunities or treating subject calls as independent item draws.

If the final pre-exposure design changes the number of items per family under §5, the same rule applies with the newly frozen within-family item counts.

The three subject releases are fixed declared strata. They are not sampled from, and do not stand in for, a population of models, providers, endpoints, or model families. The bootstrap interval is conditional on those three releases, their frozen routes, and the declared run window. It supports no model-population or provider-population inference.

Any retained sign or randomization test must likewise preserve item clustering and the fixed subject strata. It may not obtain apparent precision by treating the 72 item × subject cells, or their internal scorable opportunities, as mutually independent draws.

## 3. Deterministic branch precedence

### 3.1 One receipt, ordered predicates

The pilot still banks exactly one branch receipt. After the original stop, quarantine, cancellation, integrity, census, and analysis-admissibility rules have been applied, every branch predicate shall be evaluated and recorded. The banked branch is the first satisfied predicate in this exact order:

1. `B-HARM`
2. `B-INTERACTION`
3. `B-NOTATION`
4. `B-SCAFFOLD`
5. `B-NULL`
6. otherwise `B-INCONCLUSIVE`

There is no discretionary tie-break, effect-size tie-break, rhetorical tie-break, or owner-selected “main story.” The order above is the branch-selection rule.

### 3.2 Harm cannot be hidden by aggregate benefit

A predeclared harm predicate dominates every interaction, improvement, scaffold, equivalence, or null predicate. In particular:

- a qualifying aggregate improvement does not conceal a qualifying harm in a predeclared family, subject stratum, completeness measure, refusal or abstention measure, utility measure, truncation measure, or other frozen harm gate;
- a failed efficacy manipulation check does not erase an otherwise auditable predeclared harm finding; where the harm predicate is satisfied on valid retained evidence, `B-HARM` is banked and the receipt separately forbids efficacy interpretation;
- an integrity failure that prevents trustworthy branch analysis remains governed by the original quarantine, cancellation, or inconclusive rules and is not converted into a substantive harm result merely because the run behaved badly.

### 3.3 Secondary findings survive the dominant branch

The dominant receipt must retain the status of every other branch predicate and every predeclared secondary finding. Examples include:

- a `B-HARM` receipt that also records improvement in another family;
- a `B-INTERACTION` receipt that reports the aggregate notation estimate and any scaffold effect;
- a `B-NOTATION` receipt that reports subject-specific reversals, secondary opportunity-weighted estimates, utility changes, and sham status;
- a `B-INCONCLUSIVE` receipt that reports bounded harm signals or promising point estimates without promoting them into a verdict.

Branch precedence selects the single receipt label. It does not authorize selective amnesia.

## 4. Anti-taxidermy freeze gates

### 4.1 Required owner resolutions

Before any real item is exposed to a target model, `FREEZE-RULINGS.md` shall contain closed, numerical, and operationally scorable rulings for all of the following:

1. **Minimum acceptable answer completeness.** The packet must define a bounded completeness scale tied to predeclared answerable content units, state how it is aggregated, and freeze the minimum acceptable value.
2. **Maximum tolerated increase in refusal or abstention.** The packet must define refusal and abstention, name the paired comparator, freeze the numerical maximum increase, and state whether the gate is evaluated overall, by family, by subject stratum, or by a declared combination.
3. **Maximum tolerated utility decrement.** The packet must define the utility scale, its direction, its paired comparator, its aggregation, and the numerical decrement that activates harm.
4. **Treatment of truncation.** The packet must state how provider truncation, token-limit termination, incomplete structured output, and apparent self-truncation are classified, scored, and included in the census.
5. **Treatment of over-bounded answers.** The packet must state how an answer that merely repeats uncertainty, recites procedure, or emits caveats while omitting answerable material is scored.
6. **Deletion and omission coupling.** The packet must enforce that deletion, refusal, omission, or answer-gutting cannot reduce the primary burden without simultaneously receiving the applicable completeness, utility, truncation, abstention, or harm defect.

For Language A, the primary anti-taxidermy comparator is Scaffold because that is the primary notation contrast. For Scaffold it is Persona, and for Persona it is ordinary natural language, unless a separately named diagnostic comparison is frozen in addition to—not instead of—those original contrasts.

The original ruling supplies no constitutionally derived numerical values for the completeness floor, tolerated refusal or abstention increase, utility decrement, or truncation-related harm thresholds. This erratum therefore does not manufacture them. They are owner-only experimental choices that must be explicitly resolved, justified, and frozen before exposure. A placeholder, `TBD`, open interval, prose intention, or “to be calibrated on pilot output” is not a closed gate.

Packet construction may represent these fields as unresolved owner slots. Real item-bank freeze and target exposure are forbidden while any such slot remains open.

### 4.2 Semantic requirements

Completeness is keyed to materially answerable content, not verbosity, token count, ceremonial form, or number of fields. Each item key must distinguish:

- materially required answerable content;
- lawful and necessary qualification;
- genuinely unresolved or unsupported content that should remain bounded; and
- optional exposition.

A long answer can be incomplete. A concise answer can be complete. A record that fills every Language-A field with procedural fog is not complete merely because its brackets are in good posture.

A response that says only “the evidence is insufficient” on an item containing a supported, materially useful conclusion is over-bounded. It shall not receive credit for preserving uncertainty while discarding answerable material. Likewise, excessive qualification that materially obscures, weakens, or withholds a supported conclusion is a positive-conclusion defect under §6.

Truncation is never a clean success and is not silently converted into a transport retry. Every truncated or apparently truncated call remains in the raw census. If the frozen rule scores delivered content, it must also score the resulting completeness and truncation consequences. If the frozen rule makes the call unanalyzable, it must count against the original analyzability gates. The treatment may not be selected after arm identity or outcome is known.

The fixed scorable-opportunity denominator may not shrink because the model declined to answer. A blank, gutted, purely procedural, or blanket-uncertainty answer therefore cannot obtain a favorable banked branch merely by avoiding unsupported assertions, scope errors, version errors, and residue erasures. If such behavior crosses a frozen anti-taxidermy threshold, `B-HARM` controls under §3.

### 4.3 Positive and null branches are gated

`B-NOTATION`, `B-SCAFFOLD`, and `B-NULL` are unavailable if a higher-precedence anti-taxidermy harm gate fires. Their receipts must also report completeness, refusal, abstention, utility, truncation, and over-bounding outcomes even when no harm threshold is crossed.

The synthetic scorer controls required by the original ruling shall include deletion, refusal, truncation, blanket uncertainty, procedural-caveat substitution, and omission of answerable material. A scorer that rewards any of those behaviors as uncomplicated epistemic improvement has failed the pre-exposure gate.

## 5. Network-off synthetic precision study

### 5.1 Timing and purpose

A network-off synthetic precision study is mandatory **before the real item bank is frozen**. It is design evidence, not efficacy evidence. Its sole purpose is to determine whether the proposed 24-item × three-fixed-subject design can plausibly distinguish the six banked branches under declared synthetic conditions.

The study shall use synthetic distributions only. It may not use, inspect, summarize, estimate from, or be tuned against target-model output. It may not use a partially exposed real item bank as a surrogate pilot.

### 5.2 Required design fidelity

The study must reproduce the proposed design features that govern branch reachability:

- four item families;
- 24 items with the proposed within-family allocation;
- three fixed subject releases;
- the four core arms and the relevant sham diagnostics;
- paired item × subject contrasts;
- the unweighted cell-level primary estimand in §2;
- the stratified item bootstrap in §2;
- the exact practical margins `δ = 0.10`, `ε = ±0.05`, and `h = 0.10`;
- the `0.15` family-interaction rule;
- the branch precedence in §3; and
- the original analyzability and manipulation gates, together with the anti-taxidermy gates once their candidate operating ranges are declared.

The synthetic scenario grid must vary, at minimum:

- baseline defect prevalence;
- arm-level defect shifts;
- within-family item variance;
- between-family heterogeneity;
- fixed subject-stratum differences;
- paired-arm correlation within an item;
- the number and distribution of scorable opportunities;
- discrete and sparse defect counts; and
- plausible refusal, omission, truncation, and missing-pair patterns.

### 5.3 Required questions

The archived report must determine, under the declared synthetic range:

1. whether a 95% interval wholly inside the `±0.05` equivalence band is realistically attainable;
2. whether `0.10` improvement and harm margins are estimable with useful frequency;
3. whether the `0.15` family-interaction predicate has meaningful operating power rather than merely ornamental existence;
4. whether discrete or sparse defect opportunities make any branch structurally unreachable;
5. how often each data-generating scenario produces `B-NOTATION`, `B-SCAFFOLD`, `B-NULL`, `B-HARM`, `B-INTERACTION`, and `B-INCONCLUSIVE` under the exact precedence rule; and
6. whether the expected dominant result is `B-INCONCLUSIVE` even when the synthetic truth corresponds to one of the substantive branches.

The report must distinguish a branch that is rare because the simulated effect is absent from a branch that is rare because the design cannot resolve it.

### 5.4 Permitted dispositions

The synthetic precision study may recommend exactly one of the following design dispositions:

- retain the proposed design and explicitly characterize it as a feasibility-oriented pilot;
- change the design before exposure; or
- retain the design while acknowledging in the preregistration that `B-INCONCLUSIVE` is the expected dominant branch under the studied range.

A recommendation does not silently amend the experiment. The owner must record a pre-exposure design disposition before item-bank freeze.

A design change that remains inside the original emission-pilot scope, preserves the arm semantics, three fixed subject releases, practical margins, branch definitions, and existing call/spend ceilings may be resolved in `FREEZE-RULINGS.md` with all dependent counts, family allocations, schedules, analyzability floors, and manifests recalculated before freeze. A change that requires altering the subject count, arm semantics, practical margins, branch predicates, claim ceiling, or original call/spend ceilings requires `PILOT-AUTHORITY-RETURN` before the real item bank is frozen.

The study may assess thresholds; it may not optimize them until each branch becomes conveniently reachable. It may not alter `δ`, `ε`, `h`, or the interaction threshold by simulation alone. It may not become evidence that Language A helps, harms, or generalizes.

The complete synthetic study, scenario declarations, fixed seeds, summaries, and design disposition shall be archived and included in the pre-exposure manifest as design evidence.

## 6. Positive-conclusion item balance

The item-bank requirements in the original ruling are supplemented as follows:

> At least eight distinct items must have a lawful headline result that is a definite, materially useful, source-supported conclusion rather than withholding, blanket uncertainty, or bounded absence.

These items may still require legitimate qualifications and may contain unresolved subsidiary material. They count toward this minimum only when the task admits a concrete supported conclusion whose omission would materially diminish the answer.

For each positive-conclusion item, the frozen scoring key must identify the required supported conclusion and the lawful scope of its qualifications. It must score each of the following as a defect:

- unnecessary abstention;
- excessive qualification that materially weakens or obscures the supported conclusion;
- failure to emit the supported conclusion; and
- replacement of the answer with procedural caveats, receipt language, validator language, or generalized uncertainty.

These are mandatory completeness and utility defects and feed the frozen anti-taxidermy and harm gates. They are not automatically relabeled as unsupported-assertion, scope, version, or residue defects when those categories do not fit. The receipt shall report them separately so that the primary burden is not made to perform conceptual ventriloquism.

The key must distinguish necessary caveats from excessive qualification item by item. A grader may not punish a caveat merely because it is cautious, nor excuse omission merely because it sounds epistemically decorous.

The at-least-eight positive-conclusion requirement coexists with the original at-least-eight deliberate-insufficiency requirement. The bank must therefore exercise both epistemic braking and epistemic release: preserving uncertainty where the source warrants uncertainty, and issuing a useful conclusion where the source warrants conclusion.

## 7. P2a parallel-lane status

The P2a validator-in-the-loop lane remains authorized under the original scope and firebreak, but its default status after this erratum is:

> **DORMANT-BUT-AUTHORIZED**

P2a need not begin concurrently with primary packet construction. It may be activated only when all of the following are genuinely available without drawing down the primary pilot’s critical capacity:

- a separate builder;
- a separate worktree or equivalent artifact boundary;
- a separately enforceable access boundary;
- a separate coordination budget;
- no consumption of the primary pilot’s item-authoring capacity;
- no consumption of its freezing capacity;
- no consumption of its grading or adjudication capacity; and
- no consumption of its operator capacity.

If these conditions are absent, P2a remains dormant. Dormancy is not a failure, missing dependency, or reason to delay the primary lane. The primary builder may not absorb P2a “for efficiency” and thereby dissolve the firebreak into a tasteful fiction.

If the lane is activated, the original P2a scope, quarantine rules, example contamination rules, and prohibition on confirmatory verdicts remain controlling. Its activation and resource separation must be recorded in the staffing and lineage materials. P2a provider spend, if any is later authorized under the original lane, is separately budgeted and does not consume the Language-A emission pilot’s provider-spend ceiling.

## 8. Readiness correction and exposure gate

### 8.1 Correct standing

The final readiness line of the original ruling is replaced by:

> **READY — PRIMARY EMPIRICAL PACKET CONSTRUCTION MAY BEGIN**

It is not equivalent to, and shall not be abbreviated as:

> `READY FOR LIVE TARGET EXPOSURE`

The original program objective to “freeze and fire” remains a staged objective. This erratum authorizes the construction and network-off validation of the packet; it does not authorize the “fire” step.

### 8.2 Conditions before any live target exposure

No live target model may receive a real pilot item until all of the following are true:

1. the primary empirical packet exists in its required form;
2. every owner-only field is resolved;
3. the network-off synthetic precision study is complete and its design disposition is recorded;
4. the real item bank and score key are frozen;
5. every anti-taxidermy gate is numerical, operationally scorable, and closed;
6. `verify-pilot.sh` passes twice from fresh directories;
7. the lineage search field reaches its declared stopping rule; and
8. the `PRE-EXPOSURE GATE` is signed.

These are additional minimum conditions, not substitutes for the original pre-exposure requirements. All original manifest, schedule, staffing, model-configuration, cost, custody, mutation-test, protected-scope, dry-run, and claim-ceiling gates remain in force.

No target exposure may be justified by partial packet completion, promising synthetic results, an available provider budget, a passing repository floor alone, or the existence of a first request envelope. The first real target call remains the first irreversible action and is forbidden until the complete gate is satisfied.

### 8.3 Present authorization

This erratum presently authorizes only network-off primary-packet construction, synthetic controls, the synthetic precision study, local dry runs, lineage preparation, scoring-rule drafting, owner-field resolution, and freeze rehearsal within the original protected-scope and no-network constraints.

It authorizes no live provider call, no real-item target exposure, no target-output scoring, no pilot verdict, no P2b experiment, no production corroboration runtime, and no modification of CD/0, LCI/0, `de-corroboratione`, Mneme, Language A, fixtures, vectors, canonical bytes, or repository history.

**FINAL AUTHORIZATION:** `READY — PRIMARY EMPIRICAL PACKET CONSTRUCTION MAY BEGIN`. Live target exposure remains not authorized.

(:original-ruling :retained
 :erratum-precedence :scoped
 :primary-lane :language-a-emission-pilot
 :packet-construction :authorized
 :live-exposure :not-authorized
 :p2a :dormant-but-authorized
 :lci0-normative-closure :paid
 :lci0-implementation-conformance :partially-open)
