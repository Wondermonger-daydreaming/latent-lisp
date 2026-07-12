# RELAY TO CLAUDE CODE — `de-abysso.lisp`

*Prepared for the live `Wondermonger-daydreaming/latent-lisp` repository on 2026-07-12.*

## Mission

Land and validate the attached candidate instrument:

`mneme/atelier/instruments/de-abysso.lisp`

Title: **Concerning the Deep**.

This is the sixth chamber in the optional Hay–Lathe–Furnace–Tempering–Leviathan sequence, but the live public branch may not contain the earlier relay artifacts. Inspect before integrating. Do not invent continuity in Git that does not exist.

## Governing claim

The instrument separates six non-coercible outcomes of bounded inquiry:

`ANSWER`, `BOUNDED-ABSENCE`, `REFUSED`, `TIMEOUT`, `OCCLUDED`, and `IN-TRANSIT`.

Only completed coverage of every depth inside the declared aperture may warrant `:BOUNDED-ABSENCE`. Refusal, timeout, occlusion, and transit remain distinct. Bare `NIL` is rejected because it carries no aperture, clock, custody, policy, or delivery account.

## Files in this packet

- `de-abysso.lisp` — Common Lisp specimen.
- `check-de-abysso.py` — lexical/mechanism preflight, not a runtime substitute.
- `reference-de-abysso.py` — independent behavioral model.
- `HEXAD-MANIFEST.sexp` — relay-family manifest.
- `README-LISP-PLUS-HEXAD.md` — conceptual overview.

Source SHA-256 before receiving repairs:

`b6ae994eee321eb58d170723eb06da8da045bd0c2a3d920bca9f43d06ed59c88`

## Receiving sequence

1. Inspect the live tree and recent history:

   `git status --short`

   `git log --oneline -12`

   `sed -n '1,240p' mneme/atelier/CANON.md`

   `cat mneme/atelier/MANIFEST.sexp`

   `sed -n '1,240p' mneme/atelier/run-all.sh`

2. Compare the candidate with existing instruments and the shared root. Preserve package isolation and the standalone `../kernel/atelier-root.lisp` load convention.

3. Run the independent checks before editing:

   `python3 check-de-abysso.py de-abysso.lisp`

   `python3 reference-de-abysso.py`

4. Run the actual Lisp gate:

   `sbcl --script de-abysso.lisp`

   If the relative root path requires repository placement first, copy it to `mneme/atelier/instruments/de-abysso.lisp` and run it there.

5. Repair only genuine Common Lisp or integration failures. Do not weaken a condition merely to turn the exhibit green. Report every source change and provide a new hash.

6. Integrate minimally:

   - add a concise entry to `CANON.md`;
   - add an artifact record to `MANIFEST.sexp`;
   - append the instrument to the appropriate post-cabinet array in `run-all.sh`;
   - preserve the original six-specimen loop byte-for-byte unless the live branch has already deliberately reorganized it.

7. Run repository gates:

   `python3 mneme/atelier/static-check.py`

   `bash mneme/atelier/run-all.sh`

   Also run any newer project-local test or lint commands discovered in the live branch.

## Expected public behavior

The script should display and assert all of the following:

- pure query planning leaves the abyss digest unchanged;
- an aperture narrower than the requested depth span raises `APERTURE-EXCEEDED`;
- a near answer returns `:ANSWER`;
- `ANSWER-IS-NOT-TOTALITY` bites;
- a protected term returns `:REFUSED`;
- `REFUSAL-IS-NOT-ABSENCE` bites;
- a fully surveyed missing term returns `:BOUNDED-ABSENCE`;
- insufficient budget can be recorded as `:TIMEOUT`;
- `TIMEOUT-IS-NOT-ABSENCE` bites;
- explicit `SUPPLY-BUDGET` restarts add exactly five units and reach the deep bell;
- a sonar query becomes `:OCCLUDED` at the first line-only layer;
- `OCCLUSION-IS-NOT-ABSENCE` bites;
- a found but delayed word returns `:IN-TRANSIT`;
- `TRANSIT-IS-NOT-ABSENCE` and `ANSWER-STILL-TRAVELLING` bite;
- `WAIT-UNTIL-ARRIVAL` advances only declared virtual time and surfaces the payload;
- bare `NIL` raises `UNTYPED-SILENCE`;
- a timeout receipt recomputed as alleged absence raises `FORGED-ABSENCE-CLAIM`;
- recorded budget repairs reproduce the same bounded judgment;
- a recharted abyss makes the old plan stale;
- cosmetic receipt mutation raises `ALTERED-DEPTH-JUDGMENT`.

## Invariants not to “simplify” away

### 1. Six shapes, not a boolean

Do not replace the judgment sum with found/not-found or truthy/NIL. The specimen exists to prevent exactly that collapse.

### 2. Bounded absence is coverage-dependent

The verifier must require `SURVEYED-DEPTHS == PLANNED-DEPTHS` before accepting `:BOUNDED-ABSENCE`. A recomputed pedagogical digest is not enough.

### 3. Timeout repair remains provenance

Supplied budget is recorded as ordered `BUDGET-EVENT` structures. Repaired completion must not masquerade as completion under the original budget.

### 4. Transit is not timeout

`:IN-TRANSIT` means the answer was located and a pending payload exists. `:TIMEOUT` means the inquiry did not finish the planned field.

### 5. Silence is not self-interpreting

Keep `UNTYPED-SILENCE`. A raw null return cannot tell the reader whether the cause was absence, refusal, occlusion, timeout, transit, crash, or a bug in the caller.

### 6. Answer is not totality

The source depth and unsearched region remain in the receipt after an answer returns.

## Exact nonclaims

Do not describe this as proving metaphysical absence, distributed-system liveness, cryptographic integrity, physical timing, semantic truth, consciousness, or exhaustive knowledge of an actual model. The abyss is finite and locally charted. The clock, costs, channels, actors, and entries are cooperative specimen data. The shared FNV digest is pedagogical.

## Suggested canon entry

> `instruments/de-abysso.lisp` — answer, bounded absence, refusal, timeout, occlusion, and transit remain distinct; silence acquires evidential force only through a declared aperture and completed coverage.

## Suggested manifest thesis

> “No answer, no answer yet, no answer here, and refusal to answer are different judgment shapes.”

## Return packet requested

Report:

- final paths and commit hash;
- SBCL command and complete pass/fail result;
- static/reference/repository gate results;
- every repair made to the candidate;
- final SHA-256;
- whether the five preceding relay chambers were present, absent, or integrated in this same pass;
- any caveat that remains open.
