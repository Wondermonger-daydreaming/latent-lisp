# MANY ACTS /0 — FAILURE MATRIX (pre-code)

STANDING: standing in this lane attaches to immutable object identities and explicit
dispositions, never merely to filenames, directories, or descent from an adopted commit
(Owner Ruling 6 §3 B1; rule and coordinates in `MANY-ACTS-0-STANDING.md`). This file's path
confers no standing on its bytes in either direction.

Laws to be tested, not merely examples. Counts will be reported as
mechanically enumerated; no round-number targets. Witness naming: `W-*` = a check that
must be GREEN; `D-*` = a planted executable disease whose paired witness must go RED
while the restored control stays GREEN.

## 1. Validator laws (all refusals typed, pre-act, zero journal footprint)

| Witness | Law | Red condition it catches |
|---|---|---|
| W-V-SHAPE | malformed/non-closed source refused | unknown heads, dotted lists, wrong clause shapes |
| W-V-READ | reader-eval cannot reach the validator | `#.` source refused at read boundary (`*read-eval*` nil) |
| W-V-DATA | host objects refused | closures, functions, structs, vectors in source |
| W-V-PKG | package-internal symbols refused | any symbol homed outside grammar/program packages |
| W-V-BIND | unknown bindings + illegal shadowing refused | use-before-define; duplicate IDENT anywhere |
| W-V-FIELD | binding-class confusion refused | `field` over act-result or ordinary value; `ref` over outcome |
| W-V-AUTH | authority position closed | string/outcome/act/literal in `:authority-slot`; slot used as value |
| W-V-ARM | arm vocabulary + once-per-program | unknown arm; same arm twice (static) |
| W-V-PATTERN | closed patterns; mandatory otherwise; duplicate/shadowed clauses refused | this lane's own closed expansion laws at validation (informed by similar principles; no equivalence claimed — owner ruling, Parcel B item B6) |
| W-V-TERM | terminal discipline | missing terminal; steps after terminal |
| W-V-FOOTPRINT | invalid source has NO footprint | any store/journal/mint effect from a refused validation |

## 2. Runtime laws

| Witness | Law |
|---|---|
| W-AUTH-EXPLICIT | live authority retrieved explicitly from the environment per act step, by slot name; unfilled slot → `ma0-authority-slot-unfilled`, no act begins |
| W-AUTH-ABSENT | authority named in source but absent/unjournaled in environment → act refuses through the adopted lane's own decision; program sees structured act refusal |
| W-RES-NOT-AUTH | a result object substituted for authority is refused statically (V-AUTH) AND, if forced via a hostile driver against `ma0-complete-act`, unrecognized upstream (Capability /1 law witnessed, not claimed) |
| W-BRANCH-ONE | exactly one branch arm evaluates; untaken arm leaves no journal footprint and no act summary (prefix count + census witness, both P1 arms + P2 α) |
| W-BRANCH-EXACT | selection is exact matching (value + standing), never truthiness; textual-order first-match |
| W-UNCERTAIN-HALT | after `:uncertain-unresolved` evidence, the dependent act does not run (P2 α: no F1 for the untaken seat) |
| W-NO-BLIND-REPLAY | no construct re-fires an act; a hostile second invocation of a consumed arm (driver-level) is refused by the ADOPTED lane (identity/seat law) — witnessed firing, attributed to One Act not MA0 |
| W-NO-ERASE | a later act's refusal (P2 β B-R) leaves earlier acts' frames byte-identical (prefix digests before/after) |
| W-DERIVE-NE-PERFORM | derive steps append nothing (prefix length invariant across every derive) |
| W-IMMUTABLE | program/result/summary structures resist mutation through returned references (read-only slots + defensive copies; mutation attempt errors or leaves originals bit-identical) |
| W-ORDER-STORE | MA0's appender ordering guard derives state from the store prefix; an out-of-order frame attempt refuses before append |
| W-RESULT-STRUCT | terminal result carries ordered act summaries + store-id; disposition honest (`:refused` never laundered to `:completed`) |

## 3. Concordance teeth (the re-composition risk, pinned)

| Witness | Law |
|---|---|
| W-CONCORD-A / -BL1 / -BL2 / -BR / -CI / -CII / -D | for **each of the seven adopted arms** (the pre-code draft pinned four — A, C-i, C-ii, B-R — and R1 §7 closed the coverage to all seven): MA0-composed act vs canonical `run-all-arms` act (separate images/stores) agree on **18 enumerated facets** — frame kinds present+absent, `classify-act-frames` classification, class, act-id-hex, the F2 quartet, F3 ledger answer, F4 runtime resolution, correspondence row+verdict (C-arms), F5 execution standing + evidence class, agreement row+verdict, mint refusal. **7 × 18 = 126 comparisons.** A missing facet is RED, not skipped; the comparator carries its own planted-divergence tooth |
| W-VF-UNCHANGED | One Act V-F digest `2b51b4df…` byte-unchanged after the whole campaign |
| W-ONEACT-GREEN | One Act 173-check selftest green after the whole campaign |
| W-FLOOR-UNTOUCHED | `verify-release.sh` executed table + authorized counts untouched (diff witness); reduced floor still 77/77 |

## 4. Generic-evaluator laws (the counterfactual's teeth)

| Witness | Law |
|---|---|
| W-GENERIC | evaluator source contains no dispatch on program names, source hashes, fixture identities beyond the closed ARM vocabulary, or domain payloads (mechanical grep witness + review) |
| W-P3-HOLDOUT | P3 (third domain) authored post-freeze against the author guide alone runs without evaluator/grammar change — or its failure is preserved verbatim (a red P3 is a finding, not a defect to cosmetize) |

## 5. Planted diseases (each: witness red under disease, green under restored control)

**Four counts, never interchangeable (R1 adoption Rider 6).** **Five** named disease
FAMILIES — the five rows below. **Six** disease/control INVOCATIONS, because
`D-SKIP-VALIDATE` is exhibited on both of its witnesses (`ma0-footprint-witness` and
`ma0-selftest`). **Six** CONTROL arms, one per invocation — every diseased run is preceded
by the same witness on an unmutated replica, so that a column of red proves the witness
reddens rather than that the disease exists. **Twelve** witness executions in all, and
twelve reported checks. `ma0-diseases.sh` reports the family count in the sentinel’s first
field, the count of clean CONTROL ARMS in its second field, and `$PAIRS` on the following
parenthetical line, so a green run prints `5 diseases detected, 6 controls clean`. Until
Parcel B item B2 the second field reused `DISEASE_COUNT` and therefore printed
`5 controls clean` although six controls ran; transcripts taken before that repair record
the old output and are not regenerated.

| Disease (family) | Plants |
|---|---|
| D-BOTH-ARMS | evaluator evaluates every branch arm → W-BRANCH-ONE red |
| D-AMBIENT | evaluator fills an unoccupied authority slot from a dynamic variable → W-AUTH-EXPLICIT red |
| D-AUTO-RETRY | evaluator re-invokes an act after an uncertain/refused act-result → W-NO-BLIND-REPLAY / adopted-lane refusal witnessed red |
| D-SKIP-VALIDATE | the validator's atom scan and step check are skipped, so unvalidated source is evaluated → **two invocations**: `ma0-footprint-witness` red on "the invalid program appended NOTHING to the live store", and `ma0-selftest` red on "W-V-SHAPE dotted pair". ⚠ The named checks were chosen **by running, not by reading**: "W-V-SHAPE unknown program head" stays GREEN under this disease (the head test lives in `ma0-validate` itself, not in the two functions the mutation removes), and it is named here as surviving rather than quietly swapped out |
| D-SPECIAL-CASE | evaluator dispatches on a program NAME and short-circuits P1's second derive → `ma0-selftest` red on the named check "W-GENERIC ma0-eval.lisp names no program and no fixture identity". (The pre-code draft also promised "P1/P2 concordance drift" as a second detector; the built disease asserts the W-GENERIC named check and nothing else) |

## 6. Error vs refusal boundary witnesses

| Witness | Law |
|---|---|
| W-REFUSE-LAWFUL | `refuse` terminal → orderly `:refused` result, journal intact |
| W-ERROR-PROPAGATES | host fault / unbranched lane condition propagates as a condition; never converted to `:completed`; runner exit nonzero |
