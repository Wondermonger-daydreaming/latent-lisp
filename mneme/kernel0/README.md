# Kernel /0 pure core — first implementation arc

Arc identity: **Kernel /0 pure core, first implementation arc, 2026-07-18**.

This directory implements the pure Common Lisp data algebra, typed refusals,
immutable semantic records, and deterministic in-memory folds governed by
[`LISP-PLUS-KERNEL-0-SPEC.md`](../architecture/LISP-PLUS-KERNEL-0-SPEC.md).
The runtime target is SBCL 2.4.6 under `sbcl --script`.

This is not a claim of complete Kernel /0 conformance. It is the pure-core
subset that can be exercised without inventing the successor journal, adapter,
live-capability, channel-policy, or publication protocols.

## What this arc adds

- `fixtures.lisp` preserves the §22 call-296 projection **as data**
  (`call-296-historical-projection`, non-constructible, K0E-5/K0E-5a), supplies
  the synthetic bounded-manifestation fixture that discharges its algebra during
  the stay (`make-synthetic-bounded-manifestation-fixture`, K0E-6), and builds
  the pure-constructible §23 shapes (each with a lawful producer branch, K0E-27).
- `kernel0-selftest.lisp` loads `load.lisp`, then the fixtures, runs the
  implemented subset of all 56 numbered §25 tests, the 29 Errata 0.2 §8 controls,
  the K0E-5a named-exclusion report, planted negative controls, and planted
  mutants; it reports every exclusion and exits nonzero on any failing test,
  negative-control failure, control failure, or surviving mutant.
- The synthetic K0E-6 fixture's effect axis carries a structured §10.8
  `uncertain-effect` with kind `:provider-call`, a synthetic placeholder attempt
  identity, external request `(:unavailable :reason :synthetic-request-identity)`,
  alternatives `(:billed :not-billed)`, non-empty known facts, a reconciliation
  procedure, and retry policy `:forbidden-without-reconciliation`.
- The R-SYN-1 twin plants the illegal inline-only bounded effect axis and proves
  that `unstructured-uncertainty` fires.
- Pure §23 constructors cover 23.1–23.6, the pre-reconstruction partial shape
  of 23.7, the records-only authorized replacement of 23.8, the reconstructed
  claim shape of 23.9, the asserted self-report of 23.11, and the exposure
  record of 23.12.

`load.lisp` is untouched. Fixtures are intentionally test-loaded after the
plain core so the ordinary loader retains its existing three-smoke-check
behavior.

## R-SYN repairs at this boundary

- **R-SYN-1:** §22 is treated as a canonical axis projection, not a complete
  outcome. The concrete bounded effect axis is bound to a structured
  uncertain-effect record, and inline-only construction is refused.
- **R-SYN-2:** folds consume immutable in-memory event lists only. This arc
  makes no journal grammar, byte, framing, durability, or torn-tail claim.
- **R-SYN-3:** dependency-respecting live preflight is governing law, but there
  is no live invocation/capability/adapter surface in this arc; affected tests
  are excluded rather than simulated with invented semantics.

## Deliberately not implemented

The following phrases are the scope boundary, verbatim:

- **journal store bytes/framing awaits Process-Journal-/0**
- **adapters and anything live-provider**
- **capability live-authority machinery (arc 2 — record shapes for
  minting/restoration receipts ARE defined as data)**
- **channel-policy enforcement**
- **publication effects**

The §23 kill/reconstruct/byte-compare obligation is JOURNAL-dependent and out
of scope for this arc. The constructors establish only the outcome, record, or
claim shapes described below. No shape-only PASS is presented as evidence of
journal persistence, host-kill survival, reconstruction, or byte identity.

## Run

From `experiments/latent-lisp`:

```sh
sbcl --script mneme/kernel0/kernel0-selftest.lisp
```

Expected final lines (Errata 0.2, verbatim from a real run):

```text
=== Kernel /0 Errata 0.2 conformance summary ===
implemented test numbers: 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 23, 26, 27, 29, 31, 32, 33, 34, 39, 41, 42, 43, 44, 45, 46, 47, 48, 49, 55
excluded test numbers: 15, 16, 17, 18, 19, 20, 21, 22, 24, 25, 28, 30, 35, 36, 37, 38, 40, 50, 51, 52, 53, 54, 56
failing test numbers: none
negative controls: 8 fired, 2 excluded, 0 failed
named exclusions: K0E-5a, K0E-8/K0E-26, K0E-11, K0E-9, K0E-15, K0E-16, K0E-24/K0E-32, K0E-28a, K0E-21/validation-transfer, K0E-23/global-descriptor-resolution
controls fired: 1, 2, 3, 4, 5, 6, 7, 8, 9, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29
controls excluded (named): 10, 11, 12, 13, 14
controls failed: none
planted mutants: 59 killed (56 independent + 3 re-attributions), 0 survived
mutant kill list: singleton-bounded[K0E-2], incomplete-alternatives[K0E-1], value-outside-alternatives[K0E-3], effect-set-drift[K0E-4], attempt-indeterminate-before-begun[K0E-17], attempt-indeterminate-no-evidence[K0E-17], sealed-to-verified[K0E-18], published-to-truth[K0E-18], seal-over-other-representation[K0E-21], structural-licenses-accepted[K0E-25], flattened-boolean-verdict[K0E-26], flattened-counter-verdict[K0E-26], missing-producer-branch[K0E-27], missing-stream-lineage[K0E-28], aggregate-without-receipt[K0E-30], missing-emptiness-rule[base-spec], global-scalar[K0E-33], effect-axis-unknown-key[base-spec], foreign-subject-validation[K0E-18], foreign-subject-visibility[K0E-20], foreign-subject-integrity-same-representation[K0E-19], transfer-license-refused[K0E-21], authorizing-basis-arbitrary-object[K0E-20], semantic-domain-rejects-kind[K0E-25], semantic-domain-rejects-status[K0E-25], semantic-required-evidence-missing[K0E-25], semantic-required-evidence-wrong[K0E-25], procedure-version-drift[K0E-23], same-id-version-conflicting-class[K0E-23], cache-omitted-descriptor-substitution[K0E-23], class-only-version-substitution[K0E-23], anonymous-structural-pass[K0E-26], anonymous-semantic-fail[K0E-26], reasonless-fail[K0E-26], accepted-outcome-without-descriptor[K0E-25], rejected-outcome-without-descriptor[K0E-25], accepted-outcome-domain-bypass[K0E-25], accepted-outcome-evidence-bypass[K0E-25], descriptor-nil-version[K0E-23], axis-noncanonical-version-object[K0E-23], descriptor-list-version-refused[K0E-23], descriptor-input-domain-atom[K0E-23], descriptor-input-domain-odd-plist[K0E-23], descriptor-input-domain-duplicate-key[K0E-23], descriptor-input-domain-unknown-key[K0E-23], descriptor-evidence-requirement-nonidentity[K0E-23], foreign-representation-visibility-same-subject[K0E-20], redacted-representation-publishes-full-claim[K0E-20], publication-query-ignores-representation[K0E-20], authorizing-basis-store-identity[K0E-20], authorizing-basis-effect-identity[K0E-20], streamed-on-producer-branch[K0E-28], invalid-outcome-without-descriptor[K0E-23], unversioned-invalid-interpretation[K0E-23], unversioned-refused-interpretation[K0E-23], descriptor-erasure-after-validation[K0E-23], call-296-counted-complete[K0E-5a], context-free-standing-accessor[K0E-22], partial-erasure[K0E-31]
kernel0 selftest: 33 passed, 23 excluded (out-of-scope), 24 controls fired, 5 controls named-excluded, 59 mutants killed (56 independent + 3 re-attributions), 0 failed
```

Tests 43, 44, 47, and 48 are now **executable** under Errata 0.2 (K0E-18..22
claim-standing records + scoped queries); they move from excluded to
implemented. The suite additionally runs the 29 §8 controls (24 fired, 5 named
exclusions), the K0E-5a named-exclusion report with a report-bites control, and
37 planted mutants — 34 independently executed + 3 control-backed
re-attributions (N2 split, printed with every mutant total) — all killed for
their intended requirement id.

The plain loader remains independently runnable:

```sh
sbcl --script mneme/kernel0/load.lisp
```

## §23 fixture status

| Fixture | Pure artifact in this arc | Deferred obligation |
|---|---|---|
| §22 call-296 | **Historical projection preserved as data** (non-constructible, K0E-5/K0E-5a); the synthetic K0E-6 fixture discharges its algebra during the stay | Sealed evidentiary act (K0E-5); then journal, kill/reconstruct, and byte comparison |
| 23.1 untouched seat | Complete outcome | Journal, kill/reconstruct, and byte comparison |
| 23.2 pre-frontier refusal | Complete outcome | Journal, kill/reconstruct, and byte comparison |
| 23.3 completed present | Complete outcome with manifestation and interpretation procedure | Journal, kill/reconstruct, and byte comparison |
| 23.4 present-empty | Complete outcome preserving payload and emptiness-rule identities | Journal, kill/reconstruct, and byte comparison |
| 23.5 completed absent | Complete outcome plus a separate causal claim | Journal, kill/reconstruct, and byte comparison |
| 23.6 present-invalid | Complete outcome preserving payload, parser, and interpretation procedure identities | Journal, kill/reconstruct, and byte comparison |
| 23.7 partial then host death | Pure post-interruption outcome shape with `:present-partial` payload and post-frontier failure | Actual kill, prefix derivation, reconstruction, and byte comparison |
| 23.8 authorized replacement | Predecessor attempt, new attempt, and explicit supersession record | Journal/reconstruction obligations |
| 23.9 reconstructed derived view | Claim shape with origin `:reconstructed` | Actual reconstruction and byte comparison |
| 23.10 mirror-bound publication | None | Channel-policy enforcement and publication effects |
| 23.11 self-report | Claim with origin `:asserted` | Journal/reconstruction obligations |
| 23.12 secret opened to invoker | Exposure record naming the invoker and induced restriction data | Live policy enforcement of later role eligibility and journal/reconstruction obligations |

## Excluded §25 tests

Every omitted number is excluded for one concrete missing protocol or surface.

| Test | Reason |
|---:|---|
| 15 | Provider-alias drift is a machine-configuration/live preflight check. |
| 16 | Missing capability requires live capability machinery (arc 2). |
| 17 | Revocation requires a live capability and revocation registry (arc 2). |
| 18 | Expiry requires live capability validation (arc 2). |
| 19 | Scope mismatch requires live authority/preflight machinery (arc 2). |
| 20 | Defensive live capability-scope copying belongs to arc 2. |
| 21 | Self-restoration is a live-authority operation (arc 2). |
| 22 | Restorer authorization requires live-authority machinery (arc 2). |
| 24 | Restoration-scope enforcement requires live-authority machinery (arc 2). |
| 25 | Blocking live restoration past a frontier requires arc-2/preflight state. |
| 28 | Implicit fallback is an adapter/configuration preflight behavior. |
| 30 | Provider-enforced idempotency requires the adapter protocol. |
| 35 | Torn-tail representation awaits Process-Journal-/0 bytes/framing. |
| 36 | Settled-prefix recovery from a torn tail awaits Process-Journal-/0. |
| 37 | Durability standing requires a journal store and durability protocol. |
| 38 | Cache-versus-prefix precedence requires the journal store/prefix model. |
| 40 | Finalizer loss and reconstruction require the journal store. |
| 50 | Adapter-version drift requires an adapter/configuration preflight. |
| 51 | Mirror-bound channel-policy enforcement is out of scope. |
| 52 | Channel-policy amendment authority is out of scope. |
| 53 | Publication capability enforcement requires live authority and publication. |
| 54 | Private-staging publication-effect behavior requires channel policy/publication. |
| 56 | No adapter/raw-host escape API exists in this pure-core arc. |

Test 23 is explicitly the **pure-data half** only: the restoration-receipt
constructor enforces a new identity distinct from its predecessor. It does not
restore or grant authority.

## Negative controls

Each executable control plants the violation rather than merely inspecting a
lawful example.

| Control | Result expected from the selftest |
|---|---|
| a blind retry | `unsafe-retry` fires on a second attempt begun over an unresolved bounded effect |
| b payload erasure | `manifestation-payload-missing` fires; the exported/core function surface also has no payload writer |
| c forged observed origin | `standing-inflation` fires through `promote-origin` |
| h mutable capability scope alias | Excluded: live capability machinery is arc 2 |
| d missing exposed principal | `exposed-principal-missing` fires |
| e timestamp-only journal merge | `journal-merge-receipt-required` fires before any merge transformation |
| f global uncertainty collapse | typed `global-uncertainty-scalar-rejected` fires on the `:confidence` outcome field (K0E-33 retype; pre-erratum this was `standing-inflation`) |
| g seat/attempt conflation | `identity-drift` fires |
| i finalizer-only primary fact | Excluded: journal/finalizer machinery awaits Process-Journal-/0 |
| j shorter unsafe convenience accessor | A planted local bare-value shortcut measurably fails the Test-55 axis/context detector; exported outcome accessors are scanned |

Control letters follow the task docket. The docket places capability aliasing
at `h` and finalizer-only facts at `i`; output therefore does not alphabetize
their presentation around `d`–`g`.

## Implementation decisions visible in typed conditions

These are existing core choices that the suite asserts; the test arc did not
change them.

- Inline-only bounded/indeterminate effect axes signal
  `unstructured-uncertainty`; a non-record uncertainty reference does too.
- `:refused` with `:post-frontier` signals `frontier-already-crossed`.
  A complete refused outcome whose effects are not `:not-entered` signals
  `frontier-precondition-failed`.
- A present manifestation without payload signals
  `manifestation-payload-missing`; present-invalid without parser signals
  `invalidity-parser-missing`; present-empty without an emptiness procedure
  signals `interpretation-procedure-missing`.
- Duplicate process, attempt, and external-request identities signal their
  corresponding typed duplicate conditions. A completed occupant followed by
  another attempt in the same seat signals `seat-occupied`.
- Reusing the predecessor attempt identity in a supersession signals
  `duplicate-attempt-identity`. Reusing the predecessor capability identity in
  a restoration receipt signals `capability-restoration-denied`.
- Beginning a new attempt over unresolved bounded/indeterminate predecessor
  effects signals `unsafe-retry`. Supersession authorizes a named successor but
  does not erase predecessor uncertainty.
- Cross-sequence merge without an explicit receipt signals
  `journal-merge-receipt-required`; supplying a receipt still reaches
  `unsupported-reconstruction` because the merge format belongs to
  Process-Journal-/0.
- `promote-origin` always signals `standing-inflation`; `revalidate-claim`
  appends validation while preserving historical origin.
- Global scalar keys (`:confidence`, `:uncertainty`, `:probability`) signal
  `global-uncertainty-scalar-rejected` (K0E-33); other unknown outcome keys
  signal `malformed-constructor-shape` — the version-zero constructor accepts
  only its closed schema. (Pre-erratum both cases were the generic
  `standing-inflation` borrow, retired by Errata 0.2 §6.)
- A noncanonical float at the durable boundary signals
  `noncanonical-durable-value`; a seat used as an attempt signals
  `identity-drift`.

## Governing basis — Errata 0.2

This arc is governed by `LISP-PLUS-KERNEL-0-ERRATA-0.2`
(`../architecture/kernel-0-errata/LISP-PLUS-KERNEL-0-ERRATA-0.2.md`), which
rides beside the sealed Kernel /0 specification. The pure core implements
requirements K0E-1..K0E-33 that fall inside the pure-core boundary; requirements
needing the successor Process-Journal-/0, Adapter-Protocol-/0, live-capability,
channel-policy, or publication protocols remain named exclusions (never counted
as passed). See `_staging/kernel0-impl/W4-PROBA-notes.md` for the per-requirement
integration map.

### Hostile-review repair round (2026-07-19)

An external static hostile review (GPT-5.6 Thinking,
`_staging/kernel0-impl/hostile-review/`) returned **NOT READY FOR MERGE — REFUSE**
(2 blockers, 4 repair-needed, 4 notes): records were typed but several of their
relations were unbound. A targeted repair sitting followed and closed each item.
**B1** binds every validation/integrity/visibility record's `:subject-id` to its
containing claim (K0E-18/19/20), keeping the integrity representation check as an
additional invariant. **B2** retires the wholesale validation-transfer copy: under
the refusal-first disposition any non-NIL `validation-transfer-license` is refused
(K0E-21) and carried as a **named exclusion** pending a typed transfer protocol —
so the review's four behavioral transfer mutants are non-constructible here and are
subsumed by the single `transfer-license-refused` mutant. **R1** enforces the
K0E-25 input-domain and evidence requirements at the validator (previously inert);
**R2** binds the descriptor version at the interpretation reference (K0E-23);
**R3** requires a `:procedure-id` for `:pass`/`:fail` verdicts and refuses a
reasonless `:fail` (K0E-26). **R4** reclassifies K0E-28a from SCOPED to a **named
exclusion** — ID accessors are lineage reference exposure, not traversal, which
awaits the AP0 chunk store/joint resolver (the running accessor/read-only checks
are retained). **N1** types the inert `authorizing-basis` reference; **N2**'s
re-attribution split is now printed with every mutant total (36 killed = 33
independent + 3 re-attributions). All 15 review mutants were added. The suite
returns to full green (0 failed, 0 survived). This paragraph records the sequence
as it happened: the review refused merge, and the repairs answered it.

A **second static hostile review** (GPT-5.6 Thinking,
`_staging/kernel0-impl/hostile-review-2/`) followed the R2 packet and returned
**FAIL — MERGE: REFUSE** (3 blockers, 3 repair-needed, 3 notes) under one theme:
*a validator correct when invoked enforces no law if the public constructor can
create the governed standing without invoking it.* The round-1 findings were
confirmed substantially answered; the new failures were sibling defects one step
farther along the repaired relations. A second targeted repair sitting (R3, not
reopening Errata 0.2) closed each: **B1** makes the K0E-25 semantic gate mandatory
on the public path — `make-outcome` now REQUIRES the `:interpretation-descriptor`
for an `:accepted`/`:rejected` interpretation and validates the interpretation
against that descriptor AND the outcome's own manifestation (review option 1), so
the shorter walk-around through the axis alone is closed (and a descriptor supplied
for a non-semantic interpretation is refused, the stricter lawful reading). **B2**
makes the exact procedure version a NONNEGATIVE INTEGER at both constructors —
immutable and un-aliasable — so the review's `mutable-shared-version-alias` and
`descriptor-version-accessor-alias` are impossible by representation (a
type-refusal, `descriptor-list-version-refused`, stands in). **B3** binds visibility
standing to the containing claim's representation, not only its subject
(`%validated-claim` refuses a foreign-representation record; `claim-published-to-p`
defensively rechecks it) — closing the redaction-collapse. **R1** restricts a
present `:authorizing-basis` to the `{:claim,:capability}` identity domains. **R2**
adds `K0E-21/validation-transfer` to the named exclusions with its refusal-first
reason (the transfer protocol is reported as absent, not merely refused in prose;
the `transfer-license-refused` mutant is never counted as implementing it). **R3**
makes the nested procedure-descriptor schema refusal-safe at construction
(`:input-domain` a strict duplicate-free `:kinds`/`:statuses` plist; every
`:evidence-requirements` entry a durable identity — K0E-23). **N2**'s streamed⇒
adapter adjudication is enforced: a streamed manifestation on the non-AP0
`:producer-identity` branch is refused (K0E-28). All 18 pass-2 mutants were added
(through the public paths); the suite returns to full green — 33 passed, 0 failed,
55 mutants killed (52 independent + 3 re-attributions), 0 survived. The CL
independence gate remains open (locally run, not independently reproduced), and
ARGUS-II's F2 joint-report binding stays an explicit successor obligation.

## Specification gaps and bounded claims

Errata 0.2 **closed** the four pre-erratum gaps 1–4 that this section previously
recorded as open. The former singleton call-296 fixture, the missing standing
surfaces, the missing `:attempt-indeterminate` event, and the borrowed generic
`standing-inflation` refusal are all resolved by the K0E map. What remains bounded
is only the journal-/AP0-dependent obligation surface.

1. **§22 call-296 is STAYED, not repaired with a singleton (K0E-5/K0E-5a).**
   The complete call-296 outcome is **non-constructible** under the closed
   absence-state vocabulary: its bounded manifestation axis needs a second
   complete alternative that is unnameable without a payload identity (K0E-7,
   `:absence-state-name-presupposes-completion`, an architecture-level
   row-class unknown). The former singleton-constructing fixture is **deleted**;
   `call-296-historical-projection` now preserves the exact §22 bytes **as
   data** and never constructs. Under K0E-5a the §22/§23 call-296 row is a
   **named exclusion** that appears with its requirement id in every conformance
   report (a report that counts it passed or omits it is nonconforming — proven
   by the report-bites control). `make-synthetic-bounded-manifestation-fixture`
   discharges the row's algebra-coverage intent during the stay: a complete
   four-axis outcome whose manifestation axis carries `:bounded` determinacy over
   two complete synthetic `(:absent :state …)` alternatives (K0E-6).
2. **Claim standing is now enforced structure (K0E-18..22).** Validation,
   integrity, and visibility are constructed immutable records, not opaque
   lists. A seal establishes bytes/chain integrity only; publication establishes
   a scoped visibility relation only; neither upgrades the others (K0E-21
   orthogonality). Standing queries are procedure/scope-bound
   (`claim-validated-under-p`, `claim-published-to-p`); there is deliberately no
   context-free `verified-p`/`published-p`. This makes tests 43, 44, 47, 48
   executable and kills the sealed→verified and published→truth promotion
   mutants.
3. **Structural vs. semantic judgment is walled (K0E-23..26).** A procedure
   descriptor fixes one judgment class per identity/version; a structural
   procedure may not license `:accepted`/`:rejected`; a joint verdict keeps
   structural and semantic standing apart and never collapses to one boolean
   (structural PASS + semantic FAIL survives).
4. **Producer identity and stream lineage are required (K0E-27..32).** Every
   manifestation binds exactly one producer branch (adapter- or
   producer-identity); a streamed manifestation carries a non-empty ordered
   chunk-record reference list with the receipt discipline; captured partials
   are a read-only surface and cannot be erased.
5. **§23 reconstruction exactness still has no protocol here.** Journal bytes,
   framing, kill points, durability, prefix selection, byte comparison, torn-tail
   and salvage standing, and the dual-standing report over a structurally valid
   PJ0 prefix are **journal-dependent named exclusions** (controls 10–14, and the
   remainder of control 24), carried with their requirement ids. Shape
   construction is strictly weaker evidence and is never presented as journal
   persistence, host-kill survival, or byte identity.
6. **Test 45 is bounded to enforceable structure.** The core preserves a
   present-invalid payload and parser identity, requires an interpretation
   procedure, and refuses `:accepted`/`:rejected` over present-invalid or absent
   manifestations (now cited alongside K0E-25).
7. **Test 55 cannot police arbitrary future local functions.** It proves that
   `outcome-axis` returns a complete axis and scans the exported Kernel /0
   `OUTCOME-*` function surface against the context-preserving allowlist.
8. **Capability receipts are historical data only.** The pure restoration
   receipt checks new identity inequality, but liveness, revocation, delegate
   authority, and scope non-enlargement require arc 2.
9. **§23.12 policy consequences are data, not enforcement.** The invoker and
   induced restrictions are recorded; later-role eligibility enforcement
   awaits live policy machinery.

No core defect was observed by the implemented pure subset. That statement is
bounded to the exact SBCL command above and does not cover the 23 excluded
tests, the two excluded negative controls, or the journal-/AP0-dependent named
exclusions.

— pure core built by Codex workers under the conductor's verification; Errata 0.2
integration (call-296 quarantine, synthetic fixture, 43/44/47/48, the 29 §8
controls, named exclusions, and planted mutants) by PROBA-SUITE / Wave 4,
Claude Fable 5 chair — Claude Opus 4.8 (1M context)

## GPT hostile pass 3 static correction overlay — pending SBCL rerun

An external static pass over the R3 packet found one internally contradictory procedure path:
`validate-interpretation-against-descriptor` expressly permits `:invalid` under either judgment
class, while `make-outcome` rejected every descriptor supplied for `:invalid` and also allowed the
same procedure-relative judgment to survive without descriptor resolution.  The outcome then
discarded the descriptor used for semantic validation, leaving K0E-23 standing dependent on
forgotten caller state.

The correction overlay now:

- requires a nonnegative-integer procedure version whenever an interpretation names a procedure;
- requires and validates an exact descriptor for every procedure-relative interpretation, not only
  `:accepted`/`:rejected`;
- permits and validates descriptor-bearing `:invalid` under structural or semantic class;
- retains the exact immutable descriptor in the outcome and exports
  `OUTCOME-INTERPRETATION-DESCRIPTOR` for inspection;
- machine-lists `K0E-23/global-descriptor-resolution` as a named exclusion: the
  pure core can bind and expose one descriptor per outcome, but global
  one-id/version-one-body concordance requires the successor journal/fold resolver
  — and (ARGUS-IV widening, 2026-07-19) the residual also covers the kernel's
  version-free procedure-relative surfaces, each lawful as written and none
  descriptor-resolved here: K0E-26 verdicts (version-free by the erratum's own
  closed schema; reports that grant nothing), AP0-delegated parser/emptiness-rule
  identities, and §8.9.1 causal predicates;
- updates the §23.6 present-invalid fixture and adds hostile mutants for descriptor omission,
  unversioned invalid/refused standing, and descriptor erasure.

This overlay was syntax/static checked but not executed in the GPT environment because no Common
Lisp runtime was present.  The preceding R3 green transcript does **not** cover these changed bytes.
Fable/Claude must run the full suite and probes, regenerate counts/transcript, and either accept the
overlay or return exact failing forms.  Until then the corrected tree is test-ready, not merge-ready.
