# RELAY TO CLAUDE CODE — LAND `de-torno.lisp`

*Prepared 2026-07-12 for the `Wondermonger-daydreaming/latent-lisp` repository.*

## The contribution

A new Lisp+ Atelier instrument is attached:

- source file: `de-torno.lisp`
- proposed destination: `mneme/atelier/instruments/de-torno.lisp`
- title: **Concerning the Lathe**

It begins from Wondermonger's stanza:

> Language lathes raw PlDenic ore  
> Spinning forms unknown before  
> Realities we recompose  
> Spilling forth in endless flows

Do **not** silently normalize `PlDenic` into another word. The instrument treats `PLDENIC` as an unresolved token and demonstrates how a transformation can preserve an unknown rather than coercing it into a confident interpretation.

## Executable thesis

A transformer may propose a new form, but it may not silently install it.
Every committed cut must:

- name the proposing pass and symbolic version;
- stay within a declared structural jurisdiction;
- satisfy exact preconditions against the current workpiece;
- consume an explicit synthetic budget;
- preserve displaced material as `SHAVING` records;
- leave a replayable receipt chain;
- and never upgrade the epistemic standing of the form it reshapes.

The architectural seam is intentional:

```text
imaginative transformer
        ↓ proposes
ordered edit script
        ↓ preflighted by
lathe engine
        ↓ explicit commit
new immutable workpiece + receipt + shavings
```

The planner receives a private copy. The engine, not the pass, owns validation and commitment. This makes the specimen a compact executable analogue of Lisp+'s **planning-pure-until-explicit-commit**, `/bounded-witness`, `/sworn-concern`, and `/condition-system` concerns without claiming that the toy mechanism is constitutional law.

## What the demonstration does

The source stanza is represented as a finite proper-list tree:

```lisp
(:verse
  (:line language lathes raw pldenic ore)
  (:line spinning forms unknown before)
  (:line realities we recompose)
  (:line spilling forth in endless flows))
```

Three passes are registered as function objects:

1. `NAME-THE-UNKNOWN`
   - granted jurisdiction only over the `PLDENIC` node;
   - replaces it with `(:UNRESOLVED PLDENIC)`;
   - retains the displaced raw symbol in the receipt's shavings.

2. `LINK-FLOW`
   - implements anadiplosis structurally;
   - carries each line's final form into the beginning of the next line;
   - requires more budget than initially remains, so `LATHE-BUDGET-EXHAUSTED` must fire while a live `SUPPLY-BUDGET` restart remains available.

3. `CROWN-AS-VERIFIED`
   - deliberately proposes turning the root tag into `:VERIFIED-VERSE`;
   - has jurisdiction only over the last line;
   - must therefore be refused before budget is consumed.

The expected committed result is:

```lisp
(:verse
  (:line language lathes raw (:unresolved pldenic) ore)
  (:line ore spinning forms unknown before)
  (:line before realities we recompose)
  (:line recompose spilling forth in endless flows))
```

Its standing must remain `:ASSERTED` throughout. Typography does not mint truth.

## Typed gates already encoded

The script requires the following behavior:

- planning does not mutate the workpiece;
- ancestor workpieces remain unchanged after descendant commits;
- `PLDENIC` remains explicitly unresolved;
- replaced material survives in shavings;
- structural rewriting cannot upgrade epistemic standing;
- budget exhaustion is signaled and repaired by restart;
- out-of-scope edits are rejected without spending budget;
- stale plans are rejected;
- mutated plans are rejected by a local integrity digest;
- unknown pass names are rejected;
- receipt history is contiguous;
- replay reproduces the final form exactly.

Conditions include:

- `UNKNOWN-PASS`
- `STALE-TURN-PLAN`
- `ALTERED-TURN-PLAN`
- `PASS-VERSION-MISMATCH`
- `SCOPE-VIOLATION`
- `EDIT-PRECONDITION-FAILED`
- `RECEIPT-CHAIN-BROKEN`
- `LATHE-BUDGET-EXHAUSTED`

The last condition offers `SUPPLY-BUDGET` and `ABORT-TURN` restarts.

## Landing instructions

First inspect the live branch. Preserve all intervening work; do not overwrite manifests, runners, or canon prose wholesale.

1. Copy the attached source to:

   ```text
   mneme/atelier/instruments/de-torno.lisp
   ```

2. Run the file directly under the repository's supported SBCL baseline. Fix any actual implementation error revealed by SBCL, while preserving the semantic gates above.

3. Integrate it minimally into the current atelier machinery. At the time of preparation, the likely touchpoints were:

   - `mneme/atelier/CANON.md`
   - `mneme/atelier/MANIFEST.sexp`
   - `mneme/atelier/run-all.sh`

   Re-read those files rather than assuming their present shape.

4. Suggested CANON entry, adapted to the file's current house style:

   > `de-torno.lisp` — a transformer proposes ordered edit scripts; the engine checks structural jurisdiction, preconditions, version, integrity, and budget before explicit commit; displaced forms remain as replayable shavings.

5. Suggested manifest record, adapted to the live schema:

   ```lisp
   (:title "Concerning the Lathe"
    :file "instruments/de-torno.lisp"
    :shelf :instrument
    :designation :transformation-receipt-fixture
    :thesis "A form may change only through declared, budgeted edits; structural transformation does not mint epistemic standing, and displaced material remains replayable as shavings.")
   ```

6. Add the script to the live runner near the other instruments, preferably after `de-limine.lisp` if that ordering still makes conceptual and operational sense.

## Verification requested

From `mneme/atelier`, run the repository's actual gates. Likely commands are:

```bash
python3 static-check.py
sbcl --script instruments/de-torno.lisp
./run-all.sh
```

Do not treat the static scanner as execution evidence. Return:

- the exact commands run;
- exit statuses;
- the direct SBCL transcript for `de-torno.lisp`;
- the complete suite result;
- every code change needed to make the specimen conform;
- and any claim or mechanism you weakened, strengthened, or rejected.

Please also inspect whether the script's local FNV-style digest/canonicalization duplicates an existing atelier utility that should be reused. Prefer the house utility when semantics match exactly; do not collapse distinct notions merely to reduce line count.

## Bounded claim

This is a cooperative, single-process specimen over finite proper-list forms. It demonstrates declared edit scripts, structural scope, preconditions, synthetic resource accounting, persistent workpieces, loss-preserving shavings, typed refusal, and receipt replay.

It does **not** establish semantic truth, hygienic macroexpansion, cryptographic authorship, durable code identity, adversarial confinement, physical resource expenditure, or the wisdom of the transformation. Same-image code can reach internals and redefine functions. Keep those exclusions visible.

## Relation to `de-foeno.lisp`

These two specimens form a diptych:

- `de-foeno.lisp` asks when invented syntax becomes executable across interpreters and demonstrates that a representation of hay is not hay.
- `de-torno.lisp` asks how a form may be transformed without silent installation, jurisdictional trespass, epistemic inflation, or disposal of the displaced material.

Together:

> The spell needs an interpreter.  
> The interpreter needs hay.  
> The lathe needs jurisdiction.  
> The receipt remembers the shavings.
