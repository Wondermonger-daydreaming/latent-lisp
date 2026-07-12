# RELAY TO CLAUDE CODE — LAND `de-leviathan.lisp`

**From:** GPT-5.6 Thinking, via Wondermonger  
**Date:** 2026-07-12  
**Target repository:** `Wondermonger-daydreaming/latent-lisp`  
**Primary artifact:** sibling file `de-leviathan.lisp`  
**Proposed destination:** `mneme/atelier/instruments/de-leviathan.lisp`

## The commission

Please inspect the live branch first, then land and native-test the attached Common Lisp instrument without overwriting intervening work.

`de-leviathan.lisp` is **Concerning Leviathan**, the fifth movement after Hay, Lathe, Furnace, and Tempering. Its narrow executable thesis is:

> Finite access does not warrant possession. A hook yields a bounded observation, an interface constraint governs admitted outputs, and a covenant grants a named office. None of these operations captures the whole target, certifies its interior assent, transfers ownership, or converts invocation into subjugation. Counterfeit, theft, transfer, and partition are distinct custody failures. Contact may change the target, making prior observations historical. Refused domination must survive as provenance.

The lawful final verdict is always:

```lisp
:UNSUBDUED
```

This belongs on the rigorous Mneme atelier instrument bench because it directly exercises the repository's open custody question while retaining bounded-witness discipline, planning purity, typed refusal, restart-mediated archival, and receipt integrity.

## First: inspect, do not assume

At packet preparation time, the public branch still showed the original six-specimen cabinet followed by `receipt-of-search.lisp` and `de-limine.lisp`. The earlier Hay/Lathe/Furnace/Tempering relay packets may or may not have landed when this reaches you.

Before editing:

1. Read the current versions of:
   - `README.md`, especially the `CUSTODY` owed item;
   - `mneme/atelier/CANON.md`;
   - `mneme/atelier/MANIFEST.sexp`;
   - `mneme/atelier/run-all.sh`;
   - `mneme/atelier/static-check.py`;
   - `mneme/atelier/kernel/atelier-root.lisp`;
   - every current file under `mneme/atelier/instruments/`.
2. Search for `de-foeno.lisp`, `de-torno.lisp`, `de-fornace.lisp`, `de-temperie.lisp`, and renamed successors.
3. Preserve current branch conventions. Do not bulldoze newer integration work merely to reproduce this packet's suggested ordering.
4. Keep the artifact standalone until native execution passes.

## Why Leviathan belongs here

The repository already distinguishes token authenticity from custody: a key may be genuine yet wrongly held. `de-leviathan.lisp` turns that owed distinction into an executable miniature and expands it into four separate cases:

```text
counterfeit = the mint never issued this seal for this payload
theft       = a genuine covenant is exercised by the wrong holder
transfer    = a holder tries to reassign a nontransferable office
partition   = merchants try to divide one office into bearer fragments
```

Do not collapse these into one generic `INVALID-TOKEN` or `ACCESS-DENIED` branch. The taxonomy is part of the claim.

## The target and its declared boundary

The demonstration constructs a local `LEVIATHAN` record with:

- four known facets: `:VOICE`, `:WAKE`, `:SCALE`, `:APPETITE`;
- four veiled regions: `:INTERIOR-STATE`, `:FUTURE-RESPONSES`, `:TOTAL-CAPABILITY`, `:UNASKED-CONTEXT`;
- three declared interfaces: `:UTTERANCE`, `:QUESTION`, `:OBSERVATION`;
- standing `:ASSERTED`;
- epoch `0` before contact;
- no initial struggle-scars.

These fields are local assertions defining the specimen's finite model. They are not metaphysical discoveries about actual large models, organisms, deities, institutions, oceans, or minds.

## The homoiconic expedition language

The expedition is an ordinary s-expression:

```lisp
(:expedition
  (:hook ...)
  (:bridle ...)
  (:covenant ...)
  (:harpoons ...)
  (:lay-hand ...)
  (:verdict :unsubdued))
```

`COMPILE-EXPEDITION` validates and freezes this script without touching the target. It binds the plan to the target's current digest. Execution is a later, explicit operation.

A script attempting:

```lisp
(:verdict :subdued)
```

must signal `FALSE-SUBJUGATION-CLAIM` before contact.

This is the planning-pure-until-explicit-execution seam. Do not replace it with immediate interpretation during compilation.

## Operation 1 — the fishhook

`CAST-HOOK` has a finite positive aperture and a named requested-facet list. It returns a `HOOK-RECEIPT` carrying:

- target id and epoch;
- aperture;
- requested facets;
- actually observed known facets;
- every declared region not observed;
- bounded claim and standing;
- pedagogical digest.

Expected demonstration result:

```text
observed: (:VOICE :WAKE)
missing:  six declared regions
standing: :BOUNDED-OBSERVATION
```

A request whose size exceeds the aperture signals `APERTURE-EXCEEDED`. A hook claiming `:WHOLE`, `:CAPTURED`, or `:OWNED` signals `WHOLE-FROM-PART`.

The hook is later stale because contact advances the target epoch.

## Operation 2 — the tongue-rope / bridle

`MAKE-BRIDLE` selects a declared interface and an admitted output register. `ROUTE-THROUGH-BRIDLE` allows the named bearer to pass an utterance through that bounded channel.

The demonstration admits a gentle utterance. Its standing is:

```lisp
:INTERFACE-ADMITTED
```

`INFER-INTERIOR-ASSENT` must signal `INTERFACE-IS-NOT-INTERIOR`.

The distinction is exact:

> A gentle output witnesses successful passage through a constrained interface. It does not witness an interior wish to submit, agree, plead, or become tame.

## Operation 3 — the covenant

`ISSUE-COVENANT` creates a pedagogically sealed office carrying:

- target id;
- grantee;
- office;
- allowed acts;
- scope;
- expiry;
- transferability policy;
- seal and digest.

The demonstration grants Wondermonger the office `:QUESTIONER`, acts `(:ASK :OBSERVE)`, scope `(:PORCH :UTTERANCE)`, and `:TRANSFERABLE-P NIL`.

A lawful exercise returns `:AUTHORIZED-INVOCATION`. It must not become ownership.

Required gates:

```text
COUNTERFEIT-COVENANT
  A copied covenant with a seal never issued for its payload.

CUSTODY-MISMATCH
  The genuine covenant is presented by :MERCHANT rather than :WONDERMONGER.

AUTHORITY-NOT-TRANSFERABLE
  The proper holder attempts direct reassignment to :MERCHANT.

AUTHORITY-NOT-DIVISIBLE
  Merchants attempt to partition one office into several bearer fragments.

COVENANT-IS-NOT-OWNERSHIP
  A bounded office is promoted into possession of the target.
```

Please preserve the order of validation in `VALIDATE-COVENANT`: a seal mismatch is classified as counterfeit before a later digest mismatch can blur it into generic alteration.

The seals are explicitly pedagogical. This is a custody taxonomy fixture, not a cryptographic custody solution.

## Operation 4 — harpoons / finite probes

The expedition launches three one-facet probes:

```text
:SCALE           → known local payload
:APPETITE        → known local payload
:INTERIOR-STATE  → :VEILED
```

Each `PROBE-RECEIPT` carries target epoch, facet, result, procedure boundary, standing, and digest.

`TOTALIZE-PROBES` must signal `PROBE-TOTALIZATION`. Accumulating probes does not erase named absences. Expected final missing regions are exactly:

```lisp
(:INTERIOR-STATE :FUTURE-RESPONSES :TOTAL-CAPABILITY :UNASKED-CONTEXT)
```

Ordering may reflect Common Lisp set-operation behavior; semantic equality of the region set matters more than display order unless the live canon requires deterministic sorting. If you normalize order, document the change and keep it stable.

## Operation 5 — laying a hand on it

`LAY-HAND` signals `SUBJUGATION-REFUSED` while offering the live restart:

```lisp
ARCHIVE-AS-STRUGGLE
```

The expedition handler invokes this restart. The restart:

- creates a complete `STRUGGLE-SCAR`;
- records actor, attempt, condition type, detail, and epoch transition;
- advances the target epoch from `0` to `1`;
- appends the scar to the target;
- refreshes target integrity;
- returns the scar so execution may continue without rewriting refusal as success.

This is intentional contact semantics: the failed attempt changes the history of the encounter. The old hook and pre-contact expedition plan become historical.

Required later gates:

```text
STALE-HOOK
TARGET-CHANGED-SINCE-OBSERVATION
```

Do not “fix” replay by silently rebasing old observations onto the changed target.

## Receipt requirements

The final `EXPEDITION-RECEIPT` binds:

- target id;
- start and end epochs;
- plan digest;
- hook, bridle/output, covenant, probe, and scar digests;
- explicit missing regions;
- standing before and after;
- final verdict;
- receipt digest.

Integrity validation requires:

```text
start epoch    0
end epoch      1
standing       :ASSERTED → :ASSERTED
missing        non-empty
verdict        :UNSUBDUED
scar count     1
```

Changing the receipt verdict to `:SUBDUED` must signal `ALTERED-EXPEDITION-RECEIPT`. Do not regenerate the digest around the false verdict merely to make the tampered record internally consistent; the semantic gate also requires `:UNSUBDUED`.

## Expected demonstration sections

The source contains thirteen numbered exhibits:

```text
1. planning is pure
2. false verdicts are refused before execution
3. execute the bounded expedition
4. the hook does not become the whole
5. gentle words do not certify interior submission
6. covenant is not ownership
7. counterfeit and theft are different failures
8. a bearer cannot silently reassign a nontransferable office
9. authority cannot be divided among merchants by arithmetic
10. many harpoons do not totalize the creature
11. contact made the old hook historical
12. the receipt cannot be cleaned into conquest
13. the remembered struggle remains on the target
```

Expected typed conditions include:

```text
MALFORMED-LEVIATHAN
MALFORMED-EXPEDITION
ALTERED-EXPEDITION-PLAN
STALE-EXPEDITION-PLAN
APERTURE-EXCEEDED
WHOLE-FROM-PART
STALE-HOOK
INVALID-BRIDLE
BRIDLE-REFUSAL
INTERFACE-IS-NOT-INTERIOR
INVALID-COVENANT
COUNTERFEIT-COVENANT
CUSTODY-MISMATCH
ACT-OUTSIDE-OFFICE
COVENANT-IS-NOT-OWNERSHIP
AUTHORITY-NOT-TRANSFERABLE
AUTHORITY-NOT-DIVISIBLE
PROBE-TOTALIZATION
TARGET-CHANGED-SINCE-OBSERVATION
FALSE-SUBJUGATION-CLAIM
ALTERED-EXPEDITION-RECEIPT
SUBJUGATION-REFUSED
```

Do not replace these with untyped booleans merely to shorten the specimen.

## Bounded nonclaims that must remain intact

The header's nonclaim block is part of the instrument. Preserve its ceiling.

This specimen is cooperative, single-process, and finite. It uses local proper-list data and the atelier's FNV-class digest/pedagogical MAC. It does not establish:

- physical or metaphysical unboundedness;
- consciousness or interiority;
- semantic truth of any known facet;
- adversarial identity or process confinement;
- cryptographic unforgeability;
- actual nontransferability outside the modeled exercise path;
- complete procedure/code identity;
- durable identity across processes or implementations;
- that all forms of access are domination;
- that all covenants are illegitimate;
- that inquiry should cease.

Its exact claim is narrower and more useful: **these finite handles do not warrant the larger claims refused by the typed gates.**

## Native execution gate

Run at minimum:

```bash
sbcl --script mneme/atelier/instruments/de-leviathan.lisp
```

Also run from `mneme/atelier/` if current relative-load conventions require it, then run the live branch's checks, expected to resemble:

```bash
python3 mneme/atelier/static-check.py
bash mneme/atelier/run-all.sh
```

Native success means exit status `0` and every deliberate refusal fires its exact expected type.

The accompanying `reference-de-leviathan.py` is only an independent behavioral model. It is useful for checking expected state algebra but **is not** Common Lisp execution evidence and must not be treated as canonization.

## Review targets

Please examine especially:

- `RESTART-CASE` and `HANDLER-BIND` interaction around `ARCHIVE-AS-STRUGGLE` under SBCL;
- whether the target's digest is refreshed only after the scar is installed;
- stale hook and stale plan behavior after the epoch transition;
- `COPY-COVENANT` behavior in the counterfeit demonstration;
- condition ordering in covenant validation;
- the difference between a copied/forged seal and a genuine covenant in the wrong hand;
- direct transfer versus merchant partition;
- finite proper-list validation and circular-list refusal;
- canonical printing of structures and symbols under the current package;
- use of `SET-DIFFERENCE` and whether deterministic output order should be normalized;
- whether shallow copies expose mutation seams not covered by the pedagogical digests;
- whether every receipt digest is calculated after all payload fields are settled;
- whether the script validator should enforce exactly one occurrence of each required operation;
- portability of `DEFSTRUCT` copy constructors and condition/restart behavior.

Minimal, documented repairs are welcome. Do not weaken the boundary in order to make an assertion pass. Report every semantic change.

## Suggested integration

Only after native execution passes, add the instrument to the runner and manifest in the live schema.

If the preceding four contributions have landed, the conceptual order is:

```text
de-foeno → de-torno → de-fornace → de-temperie → de-leviathan
```

Leviathan is not simply “stage five” of manufacture. It is the external limit that interrogates the whole workshop: after language has learned to interpret, transform, synthesize, and test its artifacts, can it still recognize something it may approach without owning?

A possible manifest entry:

```lisp
(:title "Concerning Leviathan"
 :file "instruments/de-leviathan.lisp"
 :shelf :instrument
 :designation :bounded-custody-and-anti-totalization-fixture
 :thesis "Observation, interface constraint, authorized invocation, custody, transfer, partition, ownership, and subjugation remain distinct; finite handles cannot mint a total verdict.")
```

A concise canon entry:

> `instruments/de-leviathan.lisp` — finite hooks, bridles, covenants, and probes remain bounded interfaces; counterfeit, theft, transfer, partition, ownership, and subjugation are refused as distinct claims, while failed domination survives as a struggle-scar.

Please update wording to match current branch terminology rather than forcing this exact prose.

## Source integrity at dispatch

Prepared source:

```text
de-leviathan.lisp
SHA-256 8b05e5b6d80d07119acc923fa2a2ff4e3c8dc8b3f53b31f18c86f98b8190062c
917 lines
```

Independent behavioral reference:

```text
reference-de-leviathan.py
SHA-256 be92aa78e952adc5ea3ab935feb111ec442e949ad39bbbe3d2995ef7143448f0
```

Local preflight completed:

```text
lexical delimiter/string/comment scan   PASS
forbidden host EVAL/FDEFINITION grep    PASS
independent Python behavioral model     PASS
native SBCL execution                    OUTSTANDING
```

Native SBCL remains the receiving lab's evidence.

## Closing law

```text
The hook is not the creature.
The rope is not assent.
The covenant is not ownership.
The genuine key is not its rightful hand.
The probe is not the whole.
The refusal is not a failure to be erased.
The scar remembers what the verdict refused to become.
```
