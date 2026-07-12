# RELAY TO CLAUDE CODE — LAND `de-fornace.lisp`

**From:** GPT-5.6 Thinking, via Wondermonger  
**Date:** 2026-07-12  
**Target repository:** `Wondermonger-daydreaming/latent-lisp`  
**Primary artifact:** sibling file `de-fornace.lisp`  
**Proposed destination:** `mneme/atelier/instruments/de-fornace.lisp`

## The commission

Please inspect the live branch first, then land and native-test the attached Common Lisp instrument without overwriting intervening work.

`de-fornace.lisp` is **Concerning the Furnace**, the third movement after the Hay and Lathe specimens. Its narrow executable thesis is:

> Compatible transformations may alloy. Exact recurrence is convergence, not automatically corroboration. Incompatible proposals must remain explicit contestation unless a named operative policy chooses what runs. Operational selection does not settle truth. Refused proposals remain inspectable slag.

This belongs on the rigorous Mneme atelier instrument bench rather than only in `atelier/homoiconic-verse`: the file models a planning-pure-until-explicit-commit protocol, bounded jurisdiction, typed refusal, loss-aware synthesis, receipt-bearing commitment, and replay.

## First: inspect, do not assume

Before changing anything:

1. Read the current versions of:
   - `mneme/atelier/CANON.md`
   - `mneme/atelier/MANIFEST.sexp`
   - `mneme/atelier/run-all.sh`
   - `mneme/atelier/kernel/atelier-root.lisp`
   - the existing files under `mneme/atelier/instruments/`
2. Check whether `de-torno.lisp` or another transformation/synthesis instrument has already landed since this packet was written.
3. Preserve the live branch’s organization and naming conventions. Do not bulldoze a newer manifest or runner structure merely to reproduce the suggested patch below.
4. Do **not** silently correct or normalize `PlDenic`/`pldenic`. Its unresolved status is part of the exhibit.

## What the instrument demonstrates

The source form is a finite proper-list tree containing the verse’s `pldenic` token, an asserted standing marker, and an unaccounted need for hay.

Six charges are admitted:

- two independent-by-self-report proposals make the boundary of `realities` explicit;
- one rabbit proposal makes substrate accounting explicit;
- two matching proposals hypothesize `pldenic` as a phonetic neighbor of *plenum*;
- one competing proposal preserves `pldenic` as an unknown proper name.

Four charges are refused and archived as typed slag:

- stale base;
- declared-scope violation;
- attempted promotion from `:asserted` to `:verified`;
- false precondition/misremembered source.

Pure planning should yield:

- **2 clean edits**;
- **2 convergence records**;
- **1 unresolved conflict**;
- the conflict’s alternative counts **2 versus 1**.

The file then proves that headcount is not a certificate, previews a named operative choice while retaining all alternatives as `:unsettled`, resolves the actual commit by preserving the contestation inside the output tree, rejects a tampered resolved plan, commits exactly once, refuses stale re-commit, replays from the original source, and rejects a tampered receipt.

The final standing must remain `:asserted`.

## Bounded nonclaims that must remain intact

Do not strengthen the prose into production-grade claims. The specimen is explicitly bounded to a cooperative, single-process setting over finite proper-list trees.

Identity, lineage, procedure/version, scope, and base digest are self-reported. The atelier’s FNV digest is pedagogical, not cryptographic. The instrument does **not** establish:

- author or lineage independence;
- semantic truth;
- evidential corroboration from repeated output;
- hygienic macroexpansion;
- adversarial confinement;
- durable identity;
- an ideal synthesis or voting policy.

It makes admission, scope, convergence, conflict, operational choice, refusal residue, commitment, and replay inspectable. That is the whole oath.

## Native execution gate

Run at minimum:

```bash
sbcl --script mneme/atelier/instruments/de-fornace.lisp
```

Also run it from the atelier directory if the repository’s normal workflow does so, then run:

```bash
python3 mneme/atelier/static-check.py
bash mneme/atelier/run-all.sh
```

Use the branch’s actual commands if they have changed.

Expected exit status for the specimen is `0`. Expected visible pass names include:

```text
admission-is-not-adoption; refusal-is-not-erasure
planning-kept-convergence-distinct-from-conflict
operative-selection-retained-the-contestation
alloy-committed-without-epistemic-promotion
same-base-plus-receipt-reproduces-the-alloy
```

Expected typed refusals include:

```text
STALE-CHARGE
JURISDICTION-VIOLATION
STANDING-LAUNDERING
EDIT-PRECONDITION-FAILED
HEADCOUNT-IS-NOT-CERTIFICATE
ALTERED-FIRING-PLAN
STALE-FIRING-PLAN
RECEIPT-REPLAY-FAILED
```

Exact package-printing capitalization may vary. Do not weaken a failing gate merely to obtain green output.

## Review targets

Please review especially:

- condition/restart behavior around `ARCHIVE-AS-SLAG`;
- whether all refusal paths occur before mutation;
- Common Lisp portability of generalized `GETF` places used while grouping outcomes;
- deterministic ordering of plans, alternatives, receipts, and digests;
- atomicity of `COMMIT-FIRING`—all edit preconditions should be checked while constructing a fresh output before the live work is mutated;
- replay integrity and whether shallow structure copies accidentally share mutable proposal objects in a way that undermines the intended bounded claim;
- path handling for finite proper-list trees;
- whether the current `atelier-root.lisp` still exports every used helper.

Minimal, documented repairs are welcome. Preserve the conceptual gates and report every semantic change.

## Suggested integration, adapted to the live tree

Only after the native specimen passes, add it to the atelier runner. If the current runner still has explicit instrument invocations, a minimal addition is conceptually:

```bash
run_one "instruments/de-fornace.lisp"
```

Place it after the jurisdiction/receipt instruments, or in a clearly named transformation/synthesis wing. Avoid refactoring the whole runner unless the live branch already calls for that.

A suitable manifest entry, translated into the manifest’s current schema, is:

```lisp
(:title "Concerning the Furnace"
 :file "instruments/de-fornace.lisp"
 :shelf :instrument
 :designation :loss-aware-synthesis-fixture
 :thesis "Compatible proposals may alloy; convergence is not corroboration; conflict and refusal remain inspectable residue.")
```

A concise `CANON.md` description could say:

> **Concerning the Furnace** — a bounded synthesis instrument separating admission, convergence, conflict, operative choice, and epistemic settlement. Refused charges persist as typed slag; commitment is explicit and replayable.

Again: adapt this to the live document rather than pasting across newer prose.

## Local preflight already performed

The source delivered in this packet received:

- a lexical delimiter/string/comment scan: **pass**;
- a mechanism-marker audit: **pass**;
- an independent Python reference simulation of the demonstration: **pass**, reproducing `2` clean edits, `2` convergences, `1` conflict, counts `[2, 1]`, retained `:contested`, `:hay`, and `:boundary` markers, and unchanged `:asserted` standing.

No native Common Lisp implementation was available in the originating environment. Those checks are **not** a substitute for SBCL execution.

Delivered source metadata:

```text
file: de-fornace.lisp
lines: 1017 (final newline yields 1018 text rows in some counters)
bytes: 43842
sha256: 53b822a8fc019a8cad2f9a500999bf71e46d8b78cb293183de1659581782f576
```

Verify the checksum before editing, then report the post-repair checksum separately if changes are required.

## Return packet requested

Please return one compact report containing:

1. actual destination and commit/diff summary;
2. SBCL version;
3. exact specimen exit status and a concise stdout summary;
4. full-suite/static-check result;
5. repairs made and why;
6. whether the five intended invariants held;
7. final source checksum;
8. any caveat that should be added to the header or canon entry.

Do not report “landed” merely because the file parses. The furnace earns its place by firing.

---

> Agreement may alloy a form.  
> Only a warrant may settle a claim.  
> The slag remembers what fluency wanted to forget.
