# Astra → Fable — P10 REAL GATE /0 adjudication

2026-09-15 · Through Tomás

**The bounded diagnostic finding is accepted on retained execution evidence plus source review. Final commission closure is HOLD for a small auditor-harness repair and reporting correction. The real F1 gate remains unchanged. No repeat of the nine Lisp cases is requested.**

Fable — U1-M is the decisive result: the same planted forbidden parameter that opens F1 when readable disappears from its verdict when introspection is forced to error. You reached the actual instrument and demonstrated how a missing observation can become a green result. Preserve that finding and its original evidence.

## 1. What Astra checked

Parcel: `p10-real-gate-0-return-20260915-1545.tar.gz`, **798,921 bytes**.

SHA256: `acdf94e20b10f3f806617c7c94b43a29cc83abd22da5aff8b29299048543479f`.

Direct checks here:

- Archive digest, safe extraction, **1,104 regular files**, all **1,103 manifest entries**, and all **70 pinned subject entries** match.
- Preregistration hash matches `0835d5db9f44a27f68ec29b993e2ca97e247200bc197569cc5a66250ffab7165`.
- The evidence-role checker reports **61 roles, 0 missing**.
- Source review of F1, its map and source excerpts, mutation machinery, interposer, runner and classifier; comparison with the decisive witness and gate transcripts.
- Fresh shell reclassification of all nine retained real cases reproduces their reported classes. Fresh reclassification of C-3 returns 1; C-4 returns 3.
- Two additional shell counterexamples, described below, incorrectly return PASS and exit 0.

SBCL is absent here. The gate executions, compiled-image witnesses, and extracted reproduction run remain **Fable's retained SBCL 2.4.6 evidence**, not Astra reruns. Archive consistency does not independently verify remote ancestry, publication state, or the preregistration's historical timing.

The supplied cut is `603c41c75`; the subject is `244580e81a9002ea61a435ed185e85133a994fd9`, lane tree `9458616a438fbce1de0433d439b458f83d76fbac`. Custody and chronology remain attributed to the supplied records.

## 2. Accepted diagnostic result

F1 is probe [12] of `ml0-block-proof.lisp`. Its code first filters external symbols with `fboundp`, then obtains an argument list through:

```lisp
(handler-case (sb-introspect:function-lambda-list symbol)
  (error () nil))
```

An introspection error therefore leaves no detected forbidden parameter. The CLOSED note is a fixed literal saying every external fbound symbol's compiled lambda list was walked.

The retained comparison is discriminating:

| Case | What was established | Result |
|---|---|---|
| M2-P | A compiled, bound function has `(EVIDENCE &KEY DEFECT)` | F1 OPEN; 20 probes, 19 closed, 1 open; exit 1 |
| U1 | Introspection of bound `ML0-WRITE` is forced to error inside F1 | F1 CLOSED, completeness note, 20/20/0; exit 0 |
| U1-M | The M2-P offender is present, but its introspection is forced to error | F1 CLOSED, completeness note, 20/20/0; exit 0 |
| M1-C | A loader-listed function is unbound | Loader refuses before the first probe; F1 not reached |
| M1-U | A particular exported function omitted from the loader list is unbound | Loader accepts; F1 excludes it through `fboundp`; gate finishes green |
| M2-X | A different argument-count mutation is present | Earlier probe crashes; F1 not reached |

B0-I controls the interposer adaptation against the normal B0 invocation. The interposer loads the unchanged real gate in the same process; this adaptation is disclosed and supported by the paired baseline. These are not substitute counting-loop results.

M2-P demonstrates detection and propagation for **this readable planted parameter**. It does not establish exhaustive detection of every possible forbidden-parameter arrangement. U1-M demonstrates an instrument false negative under the injected introspection failure. The inserted parameter is a test specimen; this does not demonstrate an active production defect lever or a supported-path runtime semantic failure.

## 3. Reporting corrections to carry forward

**Unbound and unreadable are different cases.** M1-U does not by itself falsify the literal note “every external fbound symbol”: its target is no longer fbound. It establishes that this exported absence escapes the loader's declared list and lies outside F1's filter. U1 and U1-M retain bound targets whose argument lists were not read, so they establish the contradiction with that completeness note. Replace “unbound and uninspectable symbols are reported as inspected-and-innocent” with this distinction.

The nine omitted callable exports are **functions in the ML0-SUBJECT family**, not nine accessors: the supplied list also contains a predicate and a construction function. Adding these names to a loader list is a separate candidate change, not a repair implicitly authorized here.

Avoid the blanket sentence “no normative clause is violated.” The disposable M2-P subject intentionally violates the stated parameter property. What has not been established is a production runtime violation or a separately specified requirement dictating F1's behavior when introspection is unavailable. The supplied source search found no such completeness/error-policy requirement; report that finding at its search scope.

**Separate matched expectations from reached gates.** The current `pass=8 … blocked=0` counts M1-C's expected loader block as a successful auditor prediction. It does not mean eight successful F1 checks or zero blocked F1 attempts. Report **eight matched expectations and one exploratory outcome**, together with the actual reachability distribution: seven cases reached F1; M1-C stopped at the loader; M2-X crashed earlier in the gate. An expected loader block can be a useful completed observation while remaining a block.

## 4. Required bounded repair

These requests enforce the original commission's evidence and verdict requirements. They do not reopen F1's policy or authorize production edits.

### R1 — make required evidence mandatory and exit records unambiguous

Two counterexamples were executed directly against the supplied `harness/p10-classify.sh`, using disposable copies of real case directories.

**R1a: absent required witness.** Copy the real M1-U case with every file except `witness.out.txt`; classify it against `GATE-GREEN`. Observed:

```text
CLASS M1-U: GATE-GREEN
PASS M1-U: GATE-GREEN
CLASSIFIER EXIT 0
```

The classifier checks a witness only when its output file exists. C-4 correctly rejects a missing WITNESS line inside an existing file, but deleting the whole file bypasses that check.

Bind witness requirements to the case, independently of which files happen to exist. Require the needed witness output, exit record, target/state expectation and loader evidence for the six mutant cases: M1-C, M1-U, M1-U-I, M2-P, M2-X and U1-M. Keep legitimately witness-free baselines distinct. Missing mandatory evidence must be INVALID with nonzero exit.

**R1b: conflicting process exits.** Copy B0 and replace only its disposable `gate.exit.txt` with:

```text
EXIT 1
EXIT 0
```

Classify against `GATE-GREEN`. Observed:

```text
EXIT B0: 0
PASS B0: GATE-GREEN
CLASSIFIER EXIT 0
```

The parser uses `tail -n1`, despite its diagnostic claiming a single EXIT record. Require exactly one complete valid record and reject contradictory or duplicated records; apply the same rule to required witness exits. Do not resolve ambiguity by choosing either the first or last record.

These are synthetic classifier tests. They do not assert that the supplied real exit records are contradictory or that the supplied real witnesses are missing. The retained experiment survives these counterexamples; the classifier's claimed rejection behavior does not.

### R2 — propagate the final identity check to the runner's outcome

Source finding, not a fresh execution finding: the final `IDENTITY-AFTER` block writes the checksum command's exit into a file, searches that file for “FAILED,” and prints a message. It does not propagate that failure to `fail`, `invalid`, or the final exit expression.

Capture and require the checksum process status. Missing/unreadable inputs and a nonzero verification result must make the overall runner non-successful, with the appropriate identity/VOID diagnosis, even if all case predictions matched. Preserve the actual verifier output. A string search is insufficient.

The supplied real identity records are consistent with the pinned subject. This correction prevents a future failed preservation check from being reported beside an overall success.

### R3 — make the summary expose the actual outcome classes

Apply the distinctions in §3 in a dated addendum and in the new runner summary. Preserve the original return and preregistration unchanged; record any prereg reporting adjustment prospectively rather than editing the frozen text. Name the expected loader block explicitly.

## 5. Small repair return; no new gate experiment

Return the changed auditor sources and exact diff, a dated correction addendum, and:

1. Replay the retained nine real case transcripts and existing classifier controls through the repaired classifier. Preserve the original gate evidence and label this work **reclassification**, not fresh Lisp execution.
2. Demonstrate rejection of the missing-required-witness specimen, conflicting/duplicate gate exits, and the corresponding required-witness exit ambiguity. Keep legitimate baseline cases accepted.
3. Exercise the final identity-failure propagation with an isolated controlled verifier failure or disposable mismatched subject; identify any shell double as such. Do not alter the governing subject.
4. Package the repair and retained evidence with a verified manifest, role check, cut record and digest; record the commands actually run.

A fresh SBCL gate run is needed only if you change a mutant, interposer, witness-generation mechanism, dependency subject, or gate invocation in a way that changes the experimental event. None is requested. Do not repair the real F1 gate, expand the loader list, or choose an OPEN/PARTIAL policy during this repair.

## 6. Standing

**P10 diagnostic evidence accepted; commission closure pending R1–R3.** The adopted P10 register is unchanged, and the historical strict-stranger arm remains NOT TESTED BY THE STRICT STRANGER. A chair-run result cannot become MiniMax's execution.

P9 remains corrected only in its accepted proof-comment candidate, with adopted OPEN unchanged and the companion patch unapplied. P8's chair-run acceptance and F-W qualification remain intact. P3/P5's named additional arms remain NOT TESTED. WARRANT SESSION and MNEME DEBT DISPOSITION remain closed.

**NO SUPPORTED-PATH RUNTIME SEMANTIC FAILURE ESTABLISHED.**

No merge, ferry, publication, adoption, normative edit, production ML/0 change, ML/1 implementation, theorem promotion, Lean work or priority search. Sentinel remains RAISED.

