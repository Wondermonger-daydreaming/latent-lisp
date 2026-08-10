# MANY ACTS /0 — FAILURE MATRIX (pre-code)

STANDING: CANDIDATE. Laws to be tested, not merely examples. Counts will be reported as
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
| W-V-PATTERN | closed patterns; mandatory otherwise; duplicate/shadowed clauses refused | Surface-/2-mirrored expansion laws at validation |
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
| W-CONCORD-A / -CI / -CII / -BR | for each arm MA0 uses: MA0-composed act vs canonical `run-all-arms` act (separate images/stores) agree on: frame kinds present+absent, `classify-act-frames` classification, agreement row+verdict, correspondence row+verdict (C-arms), unpaired shape (B-R) |
| W-VF-UNCHANGED | One Act V-F digest `2b51b4df…` byte-unchanged after the whole campaign |
| W-ONEACT-GREEN | One Act 173-check selftest green after the whole campaign |
| W-FLOOR-UNTOUCHED | `verify-release.sh` executed table + authorized counts untouched (diff witness); reduced floor still 77/77 |

## 4. Generic-evaluator laws (the counterfactual's teeth)

| Witness | Law |
|---|---|
| W-GENERIC | evaluator source contains no dispatch on program names, source hashes, fixture identities beyond the closed ARM vocabulary, or domain payloads (mechanical grep witness + review) |
| W-P3-HOLDOUT | P3 (third domain) authored post-freeze against the author guide alone runs without evaluator/grammar change — or its failure is preserved verbatim (a red P3 is a finding, not a defect to cosmetize) |

## 5. Planted diseases (each: witness red under disease, green under restored control)

| Disease | Plants |
|---|---|
| D-BOTH-ARMS | evaluator evaluates every branch arm → W-BRANCH-ONE red |
| D-AMBIENT | evaluator fills an unoccupied authority slot from a dynamic variable → W-AUTH-EXPLICIT red |
| D-AUTO-RETRY | evaluator re-invokes an act after an uncertain/refused act-result → W-NO-BLIND-REPLAY / adopted-lane refusal witnessed red |
| D-SKIP-VALIDATE | evaluator runs unvalidated source → W-V-FOOTPRINT red (an invalid program reaches the store) |
| D-SPECIAL-CASE | evaluator special-cases P1's name/hash (e.g., short-circuits its second derive) → W-GENERIC red + P1/P2 concordance drift |

## 6. Error vs refusal boundary witnesses

| Witness | Law |
|---|---|
| W-REFUSE-LAWFUL | `refuse` terminal → orderly `:refused` result, journal intact |
| W-ERROR-PROPAGATES | host fault / unbranched lane condition propagates as a condition; never converted to `:completed`; runner exit nonzero |
