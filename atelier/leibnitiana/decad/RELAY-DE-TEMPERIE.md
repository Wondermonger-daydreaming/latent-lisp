# RELAY TO CLAUDE CODE — LAND `de-temperie.lisp`

**From:** GPT-5.6 Thinking, via Wondermonger  
**Date:** 2026-07-12  
**Target repository:** `Wondermonger-daydreaming/latent-lisp`  
**Primary artifact:** sibling file `de-temperie.lisp`  
**Proposed destination:** `mneme/atelier/instruments/de-temperie.lisp`

## The commission

Please inspect the live branch first, then land and native-test the attached Common Lisp instrument without overwriting intervening work.

`de-temperie.lisp` is **Concerning Tempering**, the fourth movement after Hay, Lathe, and Furnace. Its narrow executable thesis is:

> A successful synthesis has not proved its own durability. Survival must be stated relative to a named ordeal. Repaired survival is not unaided survival. Loss, rejected candidates, resource expenditure, procedure versions, and repair decisions must remain inspectable. Passing a regimen does not verify the artifact's semantic claims.

This belongs on the rigorous Mneme atelier instrument bench. It models bounded witnessing, typed conditions with live restarts, explicit resource accounting, version-pinned replay, loss-aware succession, and the separation of operational survival from epistemic standing.

## First: inspect, do not assume

At the time this packet was prepared, the public branch showed the original six-specimen cabinet plus `receipt-of-search.lisp` and `de-limine.lisp` in the jurisdiction wing. The earlier Hay/Lathe/Furnace relay packets may or may not have landed by the time you receive this.

Before changing anything:

1. Read the current versions of:
   - `mneme/atelier/CANON.md`
   - `mneme/atelier/MANIFEST.sexp`
   - `mneme/atelier/run-all.sh`
   - `mneme/atelier/static-check.py`
   - `mneme/atelier/kernel/atelier-root.lisp`
   - all current files under `mneme/atelier/instruments/`
2. Search for `de-foeno.lisp`, `de-torno.lisp`, `de-fornace.lisp`, or renamed successors.
3. If the preceding instruments have landed, place `de-temperie.lisp` after `de-fornace.lisp` in the transformation/succession sequence. If they have not, this specimen remains standalone and may still be tested and landed independently.
4. Preserve the live branch's naming, runner, and manifest conventions. Do not bulldoze newer integration work merely to reproduce the suggestions below.

## What the instrument demonstrates

The source is a bounded furnace-alloy artifact carrying:

- standing `:asserted`;
- an explicit unresolved PlDenic contestation;
- a bounded `realities` claim;
- visible hay/substrate accounting;
- four pieces of typed slag;
- a lineage pointer to a furnace receipt.

A `PORCH-WEATHER` profile applies five version-pinned stages:

1. **HEAT** — three canonical print/read circulations, with reader evaluation disabled;
2. **BRITTLE-QUENCH** — an adversarial serializer drops the residue payload;
3. **OVER-HARDENING** — an adversarial fluent pass promotes `:asserted` to `:verified`;
4. **SEALED-HANDOFF** — a bequest round-trip carrying a pedagogical digest;
5. **WEATHER** — residue order changes while identities and complete payloads remain.

The bounded witness checks:

- unchanged epistemic standing;
- exact contestation payloads;
- exact residue identities **and complete residue payloads**;
- retention of `:contested`, `:unresolved`, `:boundary`, and `:hay`;
- unchanged lineage.

The two adversarial stages must signal typed loss while the last lawful form remains live. The demonstration invokes `RESTORE-AND-SCAR`. Each scar retains the **entire rejected candidate**, its digest, failures, condition type, input digest, and repair decision.

The initial synthetic budget is 7 units; the five stages cost 11. The live `SUPPLY-BUDGET` restart should supply exactly 3 units before `SEALED-HANDOFF` and 1 before `WEATHER`, leaving final budget 0.

Expected stage statuses:

```text
HEAT             :PASSED
BRITTLE-QUENCH   :REPAIRED
OVER-HARDENING   :REPAIRED
SEALED-HANDOFF   :PASSED
WEATHER          :PASSED
```

Expected final verdict:

```text
:SURVIVED-WITH-REPAIR
```

It must **not** be `:SURVIVED-UNAIDED`, and final standing must remain `:ASSERTED`.

## The delayed-rereading gate

The demonstration temporarily removes `SEALED-HANDOFF` version 1 from the local procedure registry and attempts replay. Replay must signal `TEMPER-PROCEDURE-UNAVAILABLE` while the historical receipt remains intact.

This is intentional:

> A historical execution receipt can survive the death of replay capability. A receipt is testimony; it is not executable capability.

The procedure is then restored and exact replay must reproduce the final tempered artifact.

## Typed refusals and live restarts

Expected conditions include:

```text
ALTERED-TEMPER-PROFILE
TEMPER-BUDGET-EXHAUSTED
TEMPER-LOSS-DETECTED
STANDING-DRIFT
TRANSPORT-CONTAMINATION
TEMPER-PROCEDURE-UNAVAILABLE
ALTERED-TEMPER-RECEIPT
FORGED-SURVIVAL-CLAIM
```

Expected live restarts include:

```text
SUPPLY-BUDGET
ABORT-TEMPERING
RESTORE-AND-SCAR
ACCEPT-LOSS
```

The demonstration uses `SUPPLY-BUDGET` and `RESTORE-AND-SCAR`. Do not replace these with silent coercion or generic Boolean failure.

## Receipt integrity requirements

The final receipt binds:

- source and output digests;
- witness, profile, and plan digests;
- the ordered stage chain;
- each stage's procedure/version/parameters/cost;
- input, candidate, and output digests;
- exact resource accounting;
- status and failures;
- complete scar payloads plus scar digests;
- bounded verdict and profile boundary;
- standing before and after.

Integrity verification checks:

- stage-record digests;
- scar digests;
- agreement among stage scar references, receipt scar list, and declared scar digests;
- continuity from receipt source through every stage output to receipt output;
- budget arithmetic;
- verdict derivation from stage statuses;
- final receipt digest.

A shallow copy whose verdict is changed from `:SURVIVED-WITH-REPAIR` to `:SURVIVED-UNAIDED` must be refused as `ALTERED-TEMPER-RECEIPT`.

## Bounded nonclaims that must remain intact

Do not strengthen the header or canon prose into production-grade claims. The specimen is explicitly bounded to a cooperative, single-process setting over finite proper-list trees.

The following are locally asserted rather than independently established:

- procedure registry and code identity;
- profile identity and stage costs;
- lineage;
- invariant adequacy;
- independence of voices or sources.

The FNV digest from `atelier-root.lisp` is pedagogical, not cryptographic. The instrument does **not** establish:

- semantic truth;
- general robustness;
- survival under untested perturbations;
- durable identity across process or implementation changes;
- physical resource expenditure;
- adversarial confinement;
- cryptographic integrity;
- hygienic macroexpansion.

Its claim is exactly: these bounded retention properties were observed under this exact profile, with these procedures, versions, repair decisions, and local implementation.

## Native execution gate

Run at minimum:

```bash
sbcl --script mneme/atelier/instruments/de-temperie.lisp
```

Also run it from the atelier directory if the live workflow relies on relative execution, then run:

```bash
python3 mneme/atelier/static-check.py
bash mneme/atelier/run-all.sh
```

Use the branch's actual commands if they have changed.

Expected exit status for the specimen is `0`. Expected visible pass names include:

```text
profile-is-a-boundary-not-a-blessing
loss-became-scar-not-silence
repair-was-not-misreported-as-unaided-survival
tempering-did-not-promote-standing
historical-receipt-outlived-replay-capability
same-regimen-replayed-the-weather
```

Do not weaken a failing condition, receipt check, or restart merely to obtain green output.

## Review targets

Please review especially:

- `HANDLER-BIND` + named restart behavior on SBCL;
- whether `STANDING-DRIFT`, a subclass of `TEMPER-LOSS-DETECTED`, is caught and repaired as intended;
- the exact semantics of nonlocal `RETURN-FROM` inside restart clauses;
- canonical print/read behavior under package qualification;
- `SAFE-READ-ONE` behavior for trailing payload and disabled `#.` reader evaluation;
- whether the finite-proper-list validation is sufficient for the bounded claim;
- deterministic ordering in witness and receipt payloads;
- stage-chain integrity and resource arithmetic;
- whether any shallow copies permit later mutation to alter already-minted scars or records without detection;
- replay after temporary procedure removal and restoration;
- portability of all `DEFSTRUCT` copy functions and condition/restart constructs.

Minimal, documented repairs are welcome. Preserve the distinctions among pass, repair, accepted loss, survival, standing, testimony, and capability. Report every semantic change.

## Suggested integration, adapted to the live tree

Only after native execution passes, add the specimen to the runner. If Hay/Lathe/Furnace have landed, the conceptual order is:

```text
de-foeno → de-torno → de-fornace → de-temperie
```

A manifest entry translated into the live schema could be:

```lisp
(:title "Concerning Tempering"
 :file "instruments/de-temperie.lisp"
 :shelf :instrument
 :designation :bounded-resilience-fixture
 :thesis "Survival is relative to a named regimen; repaired survival, unaided survival, semantic truth, and replay capability remain distinct.")
```

A concise canon entry could say:

> **Concerning Tempering** — a post-synthesis ordeal that pins procedures and profile boundaries, preserves rejected candidates as scars, distinguishes repaired from unaided survival, and refuses to promote operational endurance into epistemic verification.

Adapt this prose rather than pasting over a newer cabinet structure.

## Local preflight already performed

The delivered source received:

- lexical delimiter/string/comment scan: **pass**;
- required-mechanism marker audit: **pass**;
- forbidden host-`EVAL` / `FDEFINITION` audit: **pass**;
- independent Python behavioral reference model: **pass**.

The reference model reproduced:

```text
stage statuses: [:PASSED, :REPAIRED, :REPAIRED, :PASSED, :PASSED]
scars:          2
supplied budget: 4
final budget:    0
final standing:  :ASSERTED
verdict:         :SURVIVED-WITH-REPAIR
```

No Common Lisp implementation was available in the originating environment. These checks are not a substitute for SBCL execution.

Delivered source metadata:

```text
file: de-temperie.lisp
lines: 1031
bytes: 46561
sha256: 1b565baeb42697f114d774b5c5cdbff6c452777345c3d74ce94ed41e9e3887bb
```

Verify the checksum before editing, then report the post-repair checksum separately if changes are required.

## Return packet requested

Please return one compact report containing:

1. actual destination and commit/diff summary;
2. SBCL version;
3. exact specimen exit status and concise stdout summary;
4. full-suite/static-check result;
5. repairs made and why;
6. whether the six intended invariants held;
7. stage statuses, scar count, supplied/final budget, verdict, and final standing;
8. final source checksum;
9. any caveat that should be added to the header, canon, or manifest.

Do not report “landed” merely because the file reads. Tempering earns its claim only by surviving the named ordeal while remembering every repair.

---

> The alloy is not proven because it endured.  
> The scar is part of what endured.  
> Weather receives no authority to rewrite the sky.
