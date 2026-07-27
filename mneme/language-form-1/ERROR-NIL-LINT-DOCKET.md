# SIEVE — BROAD CONDITION HANDLER DOCKET

**Date:** 2026-07-27
**Tree scanned:** `/home/gauss/Desktop/wt-form1-candidate-0/experiments/latent-lisp/`
**Branch / HEAD:** `language-form-1-candidate-0` @ `7db2da943f383f2a82c2136d17eb48e769d7771f` (unchanged across the scan)
**Scan type:** read-only. **No file in the tree was modified by this scan.**

## ⚠ THE TREE WAS LIVE DURING THE SCAN — read this before trusting a line number

At scan open the worktree was clean except two untracked files
(`mneme/language-form-1/REVIEW-1-NC31-BEFORE.lisp`, `…-RUN.txt`). At scan close
(`2026-07-27T16:59:50Z`, from `date -u`) it read:

```
 M mneme/language-form-1/form1-selftest.lisp
 M mneme/language-form-1/form1.lisp
 M mneme/language-form-1/package.lisp
?? mneme/language-form-1/REVIEW-1-HOLLOW-CHECKS-AT-TIP.txt
?? mneme/language-form-1/REVIEW-1-HOLLOW-CHECKS.lisp
?? mneme/language-form-1/REVIEW-1-NC31-BEFORE-RUN.txt
?? mneme/language-form-1/REVIEW-1-NC31-BEFORE.lisp
```

**Another hand is editing `mneme/language-form-1/` concurrently** (mtimes: `form1.lisp`
13:48:47, `form1-selftest.lisp` 13:58:42, both 2026-07-27). `REVIEW-1-HOLLOW-CHECKS.lisp`
did not exist when this scan began and appeared partway through it. **I did not write any
of it.** Consequences, all re-verified after the fact:

- **The 9 severe sites are unaffected.** All nine were re-read at their stated line numbers
  after the change and are byte-identical; every one of their files has mtime `01:55:17`
  (worktree creation) and has not been touched since.
- **`form1-selftest.lisp` line numbers in this docket are as-read-at-scan-time and are now
  STALE.** The file grew from ~1984 to **2355** lines. The seven occurrences are the same
  seven — none added, none removed, same shapes — at new lines. Mapping, re-verified by
  `grep` after the edit: `1259→1373` · `1571→1942` · `1609→1980` · `1680→2051` ·
  `1697→2068` · `1751→2122` · `1824→2195`. **Relocate by content, not by line.**
- **`REVIEW-1-HOLLOW-CHECKS.lisp:318` is unchanged** (file is 344 lines; re-verified).
- **`form1.lisp` is still clean** at its new mtime — re-checked after the edit: five handler
  forms total (29, 32 `style-warning`; 490, 502 `petition-refused`; 1464 with clauses
  `slice2-derivation-refused` at 1473 and `slice2-schema-error` at 1478). Zero broad handlers.
- **`package.lisp` was modified**; it contains no handler forms of any kind.

A whole-tree re-sweep to diff against the first sweep could not be completed — `ripgrep`
timed out twice at 90s and 120s against this tree while the concurrent writes were in
flight. The targeted re-verification above was done with `grep` instead and is what the
above claims rest on. **What I cannot claim: that no broad handler appeared elsewhere in
the tree in the last ~40 minutes of the scan.** I verified the nine severe sites and the
whole of `mneme/language-form-1/`; the remaining 108 occurrences are as-read at scan time,
in files with no evidence of concurrent modification.

**Final state of that directory at 14:05 local (last look), after a second re-check:**
`de-forma-petente/APPLICATION.lisp` had also become modified (its only new handler form,
`:986`, has the typed clause `petition-refused` — clean), and two more artifacts had
appeared: `CONDITION-PARTITION.lisp` / `.md` and `VERDICT-LIVENESS-SWEEP.sh`. Neither
contains a handler; `CONDITION-PARTITION.lisp:377-380` is a **scanner of the same
defect-class as this docket**, with its own teeth-check —

```lisp
  (check (plusp (count-occurrences "handler-case" text))
         "T-NO-BLANKET teeth: the scanner does find HANDLER-CASE in this file, so a null result above is a measurement and not a broken search")
  (check (zerop (count-occurrences "ignore-errors" text))
         "T-NO-BLANKET: no IGNORE-ERRORS — it is a blanket handler with a quiet name")
```

— written independently of this scan, and reaching the same judgement about `ignore-errors`
that this docket applies tree-wide. **Note for anyone re-running my sweep now: that string
literal is a 122nd textual hit that did not exist when I counted 121.** It is not a handler.

## Scan surface

| | count |
|---|---|
| Files walked by ripgrep (whole tree minus `.git`, `*.md`, `*.txt`, `*.diff`) | **2,647** |
| of which `*.lisp` | **415** |
| of which `*.sh` | **17** |
| of which `*.lisp+` | **3** (zero hits) |
| other executable/data source walked (`.py` 116, `.sexp` 36, `.asd` 4, `.pj0`/`.pjs`/`.json`/`.jsonl`/…) | remainder (zero handler hits) |
| Total non-`.git` files in tree | 3,877 |

Patterns swept (each verified against the file at the reported line, not banked from the grep):
`\(error\s*\(…\)` · `\(condition\s*\(…\)` · `\(serious-condition\s*\(…\)` · `ignore-errors` · clause heads with the lambda-list on the following line (`\((error|condition|serious-condition)\s*$`) · `handler-bind` bindings of the form `((error|condition|serious-condition) (lambda …))` or `#'fn` · package-qualified and odd-spaced spellings (`cl:error (`, `( error (`).

## Totals

| | count |
|---|---|
| **Total broad-handler occurrences** | **121** |
| — `governed semantics` | **9** |
| — `test/suite` | **38** |
| — `tooling/harness` | **15** |
| — `specimen` | **59** |
| — `bootstrap` | **0** (see appendix) |
| **Converts implementation failure → protocol result: YES** | **33** |
| — of which in `governed semantics` | **9** (all 9 — the severe class) |
| — of which are the *planted-failure teeth* idiom (`(error () (setf teeth t))` and kin: a check that passes on any error) | **13** |
| — remaining YES outside governed semantics | **11** |
| **UNCLEAR** | **6** |
| **NO** | **82** |

Per-class conversion breakdown (rows sum to 121):

| class | YES | UNCLEAR | NO | total |
|---|---|---|---|---|
| governed semantics | 9 | 0 | 0 | 9 |
| tooling/harness | 4 | 2 | 9 | 15 |
| test/suite | 1 | 2 | 35 | 38 |
| specimen | 19 | 2 | 38 | 59 |
| **all** | **33** | **6** | **82** | **121** |

**Categories with zero hits, stated explicitly:**
- `serious-condition` as a handler clause type or handler-bind binding anywhere in executable source: **ZERO**. The only occurrence of the word in the tree is prose in `mneme/language-surface-0/LANGUAGE-SURFACE-0-SPEC.md:106`, forbidding it.
- `handler-bind` bound to `error` (any handler body): **ZERO**.
- `handler-bind` whose handler does a non-local exit that **discards** the condition: **ZERO**. One `handler-bind` on `condition` with a non-local exit exists (`expect-condition-runtime.lisp:54`), and it *carries* the condition out and *declines* outsiders — it is in the table with a `NO`.
- `bootstrap`-classified occurrences: **ZERO**. Every broad-looking construct above a `;;; ==== BOOTSTRAP ENDS HERE ====` marker is `(handler-bind ((style-warning …)))` load-time warning muffling, excluded by the brief (appendix).
- Broad handlers anywhere in `mneme/language-form-1/form1.lisp` — the subject of Form /1 Review 1: **ZERO**, verified two independent ways (§ "Form /1 itself" below).

---

# TABLE — EVERY OCCURRENCE

Columns: path:line · verbatim · class · converts? · prior docket.
`class` ∈ {**GOV** governed semantics, **SPEC** specimen, **TEST** test/suite, **TOOL** tooling/harness, **BOOT** bootstrap}.

## GOVERNED SEMANTICS (9)

| path:line | verbatim | class | converts? | prior docket |
|---|---|---|---|---|
| `experiments/latent-lisp/mneme/kernel0/boundary.lisp:84` | `(error ()` / `(%signal-noncanonical-durable-value context))))` | GOV | **YES** — any host error inside a registered canonicalization predicate/converter is emitted as the governed `NONCANONICAL-DURABLE-VALUE` refusal. | **NEW** |
| `experiments/latent-lisp/mneme/language-core-0/core0.lisp:887` | `(error () nil)))` | GOV | **YES** — a crash inside `%core0-issued-content-p` is returned as "not issued." | **NEW** (behaviour *specified* at `LANGUAGE-SLICE-2-SPEC-0.md:222`, never docketed as a defect) |
| `experiments/latent-lisp/mneme/language-core-0/core0.lisp:935` | `(error () nil)))` | GOV | **YES** — same, for the conjunction predicate. | **NEW** (same spec line) |
| `experiments/latent-lisp/mneme/language-core-0/core0.lisp:947` | `(error (c)` / `(signal-core0 'malformed-request …)` | GOV | **YES** — any condition raised while normalising a request is re-emitted as the governed `MALFORMED-REQUEST` refusal. | **NEW** |
| `experiments/latent-lisp/mneme/language-slice-1/slice1.lisp:382` | `(ignore-errors (equal x (proposition x))))` | GOV | **YES** — a crash inside `PROPOSITION` is returned as "not in normal form" by the exported predicate `NORMAL-FORM-P`. | **PARTIAL** — characterised as "errors swallowed" at `mneme/language-core-0/census/CENSUS-SLICE-1.md:102`; form quoted at `mneme/language-form-1/LANGUAGE-FORM-1-WORK-ORDER.md:162-164`. Never docketed as a defect. |
| `experiments/latent-lisp/mneme/language-slice-2/slice2.lisp:634` | `(error () (values :not-reported nil))))` | GOV | **YES** — a crashing Kernel /0 fold is reported as `:NOT-REPORTED`, i.e. as an account that said nothing. | **NEW** |
| `experiments/latent-lisp/mneme/language-slice-2/slice2.lisp:809` | `(error ()` / `(%refuse 'source-basis-refused :request request …)` | GOV | **YES** — any condition from `slice1:proposition` becomes the governed `SOURCE-BASIS-REFUSED`. | **NEW** |
| `experiments/latent-lisp/mneme/language-slice-2/slice2.lisp:1540` | `(error () nil))))` | GOV | **YES** — a broken registry read is indistinguishable from an unregistered schema. | **DOCKETED as D-1**, `mneme/language-form-1/LANGUAGE-FORM-1-WORK-ORDER.md:1432-1434` (cited there as `slice2.lisp:1539-1540`) |
| `experiments/latent-lisp/mneme/lci0/common-lisp/migration.lisp:169` | `(error () (%legacy-source-fail)))))` | GOV | **YES** — any condition from `sb-ext:octets-to-string` becomes the frozen protocol failure `migration-refusal/UnsupportedLegacyForm`. | **NEW** |

## TOOLING / HARNESS (15)

| path:line | verbatim | class | converts? | prior docket |
|---|---|---|---|---|
| `experiments/latent-lisp/mneme/lci0/differential/common_lisp_adapter.lisp:110` | `(error () nil)))` | TOOL | **YES** — the adapter's mirror of the lci0 closure temporal predicate answers "not symbolic" on any crash; the differential comparator sees a decision, not a fault. | NEW |
| `experiments/latent-lisp/mneme/lci0/differential/common_lisp_adapter.lisp:421` | `(error (condition)` / `(declare (ignore condition))` / `(integration-validated-protocol-failure-response …)` | TOOL | **YES** — any host condition is re-emitted as a well-formed protocol-failure response; the condition object is explicitly discarded. | NEW |
| `experiments/latent-lisp/mneme/lci0/differential/common_lisp_adapter.lisp:445` | `(error (condition)` / `(declare (ignore condition))` / `(list (cons "protocol" …))` | TOOL | **YES** — same, in the response-rendering fallback. | NEW |
| `experiments/latent-lisp/mneme/lci0/differential/common_lisp_adapter.lisp:466` | `(error (condition)` / `(declare (ignore condition))` / `(list (cons "protocol" …))` | TOOL | **YES** — same, at the top-level request loop. | NEW |
| `experiments/latent-lisp/mneme/lci0/audit/common_lisp_runner.lisp:119` | `(error (condition)` / `(list (cons "kind" "host-exception") …)` | TOOL | **NO** — the broad catch is present but the result is *tagged* `"host-exception"`, a category distinct from `"failure"`. This is the correct shape: catch broadly, then say so. | n/a |
| `experiments/latent-lisp/canonical-datum/integration/common_lisp_adapter.lisp:388` | `(condition (condition)` / `… (sb-ext:exit :code 2)))` | TOOL | **NO** — top-level driver; prints, backtraces, exits nonzero. No semantic result is handed back. | n/a |
| `experiments/latent-lisp/canonical-datum/qualification/common_lisp_runtime_probe.lisp:239` | `(condition (condition) condition)))))))` | TOOL | **NO** — a worker thread's condition is *returned as the condition object* and re-signalled by the joiner at line 242. Nothing is flattened. | n/a |
| `experiments/latent-lisp/canonical-datum/qualification/common_lisp_runtime_probe.lisp:289` | `(condition (condition)` / `… (sb-ext:exit :code 1)))` | TOOL | **NO** — top-level driver; FAIL + backtrace + nonzero exit. | n/a |
| `experiments/latent-lisp/mneme/atelier/kernel/atelier-root.lisp:64` | `(error () t)))` | TOOL | **NO** — this is the definition of `SIGNALS-ERROR-P`; returning T on any error *is* its semantics. | n/a |
| `experiments/latent-lisp/mneme/language-slice-0/stranger-implementation-0/check-external-symbols.lisp:98` | `(error (e)` / `(push (format nil "~a" e) read-errors)` | TOOL | **NO** — reader errors are collected into a reported `read-errors` list, not silently absorbed. | n/a |
| `experiments/latent-lisp/mneme/language-slice-0/stranger-implementation-0/check-external-symbols.lisp:109` | `(handler-case (eval form) (error () nil)))` | TOOL | **UNCLEAR** — a failed `defpackage`/`in-package` eval is swallowed, so subsequent symbol resolution proceeds against a wrong package and the audit's findings degrade silently. Whether that can flip an audit *verdict* requires reading `walk-form`'s package sensitivity (same file, lines 30-88) to decide. | n/a |
| `experiments/latent-lisp/mneme/language-slice-0/stranger-implementation-0/check-external-symbols.lisp:111` | `(error (e)` / `… "FATAL — could not open/scan …"` / `(sb-ext:exit :code 2)` | TOOL | **NO** — announces FATAL and exits 2. | n/a |
| `experiments/latent-lisp/mneme/language-slice-0/stranger-implementation-1/check-external-symbols.lisp:98` | *(byte-identical to `…-0/…:98`)* | TOOL | **NO** — as above. | n/a |
| `experiments/latent-lisp/mneme/language-slice-0/stranger-implementation-1/check-external-symbols.lisp:109` | *(byte-identical to `…-0/…:109`)* | TOOL | **UNCLEAR** — as above. | n/a |
| `experiments/latent-lisp/mneme/language-slice-0/stranger-implementation-1/check-external-symbols.lisp:111` | *(byte-identical to `…-0/…:111`)* | TOOL | **NO** — as above. | n/a |

## TEST / SUITE (38)

> **Line-number warning:** the five `form1-selftest.lisp` rows below are as-read at scan time.
> That file was edited concurrently and is now 2355 lines. Current locations, re-verified:
> `1259→1373` · `1571→1942` · `1609→1980` · `1751→2122` · `1824→2195`. Content unchanged.

| path:line | verbatim | class | converts? | prior docket |
|---|---|---|---|---|
| `experiments/latent-lisp/mneme/kernel0/kernel0-selftest.lisp:144` | `(condition (condition)` / `(push (cons ,number condition) *failed-tests*)` | TEST | **NO** — `RUN-TEST` macro; any condition ⇒ recorded FAIL. Fails closed. | n/a |
| `…/kernel0-selftest.lisp:1072` | `(condition (condition)` / `… *negative-controls-failed*` | TEST | **NO** — negative control; any condition ⇒ FAILED. Fails closed. | n/a |
| `…/kernel0-selftest.lisp:1109` | `(condition (condition)` / `… "NC-b … FAILED"` | TEST | **NO** — fails closed. | n/a |
| `…/kernel0-selftest.lisp:1159` | `(condition (condition)` / `… "NC-j … FAILED"` | TEST | **NO** — fails closed. | n/a |
| `…/kernel0-selftest.lisp:1213` | `(condition (condition)` / `… "CONTROL 06 … FAILED"` | TEST | **NO** — fails closed. | n/a |
| `…/kernel0-selftest.lisp:1228` | `(condition (condition)` / `… *controls-failed*` | TEST | **NO** — `CONTROL-REFUSAL`; fails closed. | n/a |
| `…/kernel0-selftest.lisp:1241` | `(condition (condition)` / `… *controls-failed*` | TEST | **NO** — `CONTROL-POSITIVE`; fails closed. | n/a |
| `…/kernel0-selftest.lisp:1463` | `(condition (condition)` / `… "CONTROL 21 … FAILED"` | TEST | **NO** — fails closed. | n/a |
| `…/kernel0-selftest.lisp:1552` | `(condition (condition)` / `… *mutants-survived*` | TEST | **NO** — `EXPECT-MUTANT-KILLED`; a condition ⇒ SURVIVED-OR-WRONG-REASON, the conservative side. | n/a |
| `…/kernel0-selftest.lisp:1729` | `(condition (condition)` / `… *mutants-survived*` | TEST | **NO** — fails closed. | n/a |
| `…/kernel0-selftest.lisp:2404` | `(condition (condition)` / `… *mutants-survived*` | TEST | **NO** — fails closed. | n/a |
| `experiments/latent-lisp/mneme/language-form-0/form0-selftest.lisp:90` | `(error () t))` | TEST | **NO** — `T-NO-RAW-FUNCTION`: the tooth asserts CD/0 refuses a host function; a *wrong* error would also pass, but the check is corroborated by the surrounding refusal-code assertions. Deliberately broad, narrow blast radius. | n/a |
| `experiments/latent-lisp/mneme/language-form-1/form1-selftest.lisp:1259` | `(condition () nil)))` | TEST | **UNCLEAR** — NC-20(a): a crash anywhere in the aliasing probe reads as "not safe" (the check then fails). Fails closed for the *verdict*, but the diagnostic is erased. Deciding whether it can fail *open* needs `nc20-support-references-safe-p`'s full body (lines 1230-1259). | n/a |
| `…/form1-selftest.lisp:1571` | `(condition (c) c)))))` | TEST | **NO** — NC-21: the condition object is *returned*, then inspected by the assertions at 1573-1580. Nothing is discarded. | n/a |
| `…/form1-selftest.lisp:1609` | `(condition () nil))))` | TEST | **NO** — NC-34: the probe asserts `reached` is still `:no-values-ever-returned`; swallowing is the mechanism by which "nothing was returned" is observable. | n/a |
| `…/form1-selftest.lisp:1751` | `(condition () nil))` | TEST | **NO** — inside planted fault PF-1's injected lambda; the fault is *supposed* to be defective. | n/a |
| `…/form1-selftest.lisp:1824` | `(condition () (values nil borrowed-refusal)))))` | TEST | **NO** — planted fault PF-5 *is* this exact defect, deliberately simulated so NC-21 can kill it. Its record line (1828) names it verbatim: "submission path wrapped in (ERROR () …) so an implementation condition becomes a petition refusal". | n/a |
| `experiments/latent-lisp/mneme/language-form-1/REVIEW-1-HOLLOW-CHECKS.lisp:318` | `(condition () nil)))` | TEST | **NO** — the repaired `[129]` predicate, transcribed verbatim for the before/after witness. Same shape and same reasoning as `form1-selftest.lisp:1609`. | n/a |
| `experiments/latent-lisp/mneme/language-surface-0/surface0-selftest.lisp:697` | `(ignore-errors (delete-file src))` | TEST | **NO** — temp-file cleanup. | n/a |
| `…/surface0-selftest.lisp:698` | `(when fasl (ignore-errors (delete-file fasl))))` | TEST | **NO** — temp-file cleanup. | n/a |
| `experiments/latent-lisp/mneme/lci0/common-lisp/tests.lisp:14` | `(error (condition)` / `(incf *lci0-test-failures*)` | TEST | **NO** — `LCI0-CHECK`; fails closed. | n/a |
| `…/tests.lisp:25` | `(error (condition)` / `(incf *lci0-test-failures*)` | TEST | **NO** — `LCI0-BLOCKED-CHECK`; fails closed. | n/a |
| `experiments/latent-lisp/mneme/lci0/common-lisp/closure-tests.lisp:193` | `(error () nil))))` | TEST | **NO** — trailing clause after a typed clause; leaves `condition` NIL and the `(and condition …)` assertion at 195 then fails. Fails closed. | n/a |
| `experiments/latent-lisp/mneme/lci0/common-lisp/pre-seed-red-tests.lisp:59` | `(error (condition)` / `(incf failures)` / `"RED   ~A -- ~A"` | TEST | **NO** — fails closed, prints the condition. | n/a |
| `experiments/latent-lisp/mneme/lci0/common-lisp/harness.lisp:205` | `(error (condition)` / `(incf (gethash operation failures 0))` | TEST | **NO** — fails closed, prints the condition. | n/a |
| `experiments/latent-lisp/mneme/latent-mvp/adversarial-conformance.lisp:23` | `(error (e) (bad ,name (format nil "unexpected error: ~a" e)))))` | TEST | **NO** — `EXPECT-OK`; fails closed with the condition text. | n/a |
| `…/adversarial-conformance.lisp:31` | `(error (e) (bad ,name (format nil "non-Mneme failure: ~a" (type-of e))))))` | TEST | **NO** — final clause after the typed ones; explicitly names the case "non-Mneme failure" and FAILS it. Exemplary. | n/a |
| `experiments/latent-lisp/mneme/latent-mvp/boundary/boundary-revive.lisp:37` | `(error (e) (bad ,name … "unexpected error: ~a"))))` | TEST | **NO** — as above. | n/a |
| `…/boundary-revive.lisp:44` | `(error (e) (bad ,name … "non-Mneme failure: ~a"))))` | TEST | **NO** — as above. | n/a |
| `experiments/latent-lisp/mneme/latent-mvp/counterexample-closure.lisp:29` | `(error (e) (bad ,name … "unexpected error: ~a"))))` | TEST | **NO** — as above. | n/a |
| `…/counterexample-closure.lisp:52` | `(error (e)` / `(bad ,name (format nil "non-Mneme failure: ~a" (type-of e)))))` | TEST | **NO** — as above. | n/a |
| `experiments/latent-lisp/mneme/language-slice-2/de-pignore/APPLICATION.lisp:936` | `(and (null (ignore-errors (eval '(setf (de-pignore::%obligation-occurrence-identity …) :x)) t))` | TEST | **UNCLEAR** — the §2 immutability tooth reads "any error ⇒ no slot writer exists." A typo in the accessor symbol, or a package error, would also read as PASS. Deciding whether it is hollow requires running it against a build where the writer *does* exist (the fixture is not in the tree). | n/a |
| `…/APPLICATION.lisp:1023` | `(error () (setf escaped :implementation-failure))))` | TEST | **NO** — this is the D2 repair's own tooth: it exists precisely to *classify* a planted unexpected condition as `:IMPLEMENTATION-FAILURE` and assert it did not become a refusal. | Repair recorded, `mneme/language-slice-2/de-pignore/DESIGN-NOTE.md:449-457` |
| `experiments/latent-lisp/atelier/siblings/nimbus/TESTS.lisp:18` | `(error (condition)` / `(incf *failed*)` | TEST | **NO** — `CHECK` macro; fails closed. | n/a |
| `…/nimbus/TESTS.lisp:59` | `(error () t)))` | TEST | **YES** (mild) — "empty fields refuse counterfeit condensation" passes on *any* error, including an arity or package error in `CONDENSE`. A broken implementation reads as a correct refusal. Specimen-grade test. | n/a |
| `experiments/latent-lisp/atelier/leibnitiana/post-decad/expect-condition-runtime/test-expect-condition-runtime.lisp:18` | `(error (condition)` / `"[FAIL ~d/9] ~a — ~a"` | TEST | **NO** — fails closed, prints the condition. | n/a |
| `experiments/latent-lisp/received/s-expression-garden-sol/tests.lisp:432` | `(error (condition)` / `(incf failed)` / `(push (list :test name :condition … :message …))` | TEST | **NO** — fails closed, retains condition type and message. | n/a |
| `experiments/latent-lisp/canonical-datum/common-lisp/run-tests.lisp:9` | `(condition (condition)` / `… (sb-ext:exit :code 1)))` | TEST | **NO** — top-level driver; FAIL + backtrace + nonzero exit. | n/a |

## SPECIMEN (59)

| path:line | verbatim | class | converts? | prior docket |
|---|---|---|---|---|
| `experiments/latent-lisp/mneme/language-slice-2/de-pignore/APPLICATION.lisp:275` | `:offending-snapshot (ignore-errors (%snapshot offending))))` | SPEC | **NO** — the refusal is minted for its own protocol reason regardless; the swallow only blanks a diagnostic field. **But** `%snapshot` signals a *typed* `UNSUPPORTED-SNAPSHOT-VALUE` (line 105) and that typed refusal is discarded here. | n/a |
| `…/APPLICATION.lisp:460` | `:offending-snapshot (ignore-errors (%snapshot ,offending)))))))` | SPEC | **NO** — same, in the `REFUSE` macrolet. Same caveat. | n/a |
| `experiments/latent-lisp/mneme/language-slice-0/de-infando/SPECIMEN.lisp:119` | `(error () (check "teeth-6 standing cannot be copy-constructed" t)))` | SPEC | **YES** (mild) — a tooth that passes on any error; a constructor arity change would read as the invariant holding. | n/a |
| `experiments/latent-lisp/mneme/language-slice-0/de-promotione/SPECIMEN.lisp:44` | `(error (e)` / `(check … (search "charter" (format nil "~a" e)))))` | SPEC | **NO** — the message text is asserted; a wrong error fails the check. | n/a |
| `…/de-promotione/SPECIMEN.lisp:52` | `(error (e)` / `(check … (search "not a slice0-condition" …))))` | SPEC | **NO** — message asserted. | n/a |
| `…/de-promotione/SPECIMEN.lisp:60` | `(error (e)` / `(check … (search "not permitted by charter" …))))` | SPEC | **NO** — message asserted. | n/a |
| `…/de-promotione/SPECIMEN.lisp:222` | `(error () (check "T5a constructor cannot mint judgment" t)))` | SPEC | **YES** (mild) — passes on any error. | n/a |
| `…/de-promotione/SPECIMEN.lisp:230` | `(error () (check "T5b no setf on claim-judgment" t)))` | SPEC | **YES** (mild) — passes on any error, and the body is an `EVAL` of a `SETF` form, where a symbol typo also signals. | n/a |
| `experiments/latent-lisp/mneme/atelier/instruments/de-abysso.lisp:130` | `(let ((length-or-nil (ignore-errors (list-length object))))` | SPEC | **NO** — the only condition `LIST-LENGTH` can signal here is `TYPE-ERROR` on an improper list (circular lists return NIL, not an error); the swallowed class is provably the intended one. Shape is broad, blast radius is not. | n/a |
| `…/instruments/de-concordia.lisp:127` | *(identical `PROPER-LIST-P` idiom)* | SPEC | **NO** — as above. | n/a |
| `…/instruments/de-dilatatione.lisp:134` | *(identical)* | SPEC | **NO** — as above. | n/a |
| `…/instruments/de-foeno.lisp:93` | *(identical)* | SPEC | **NO** — as above. | n/a |
| `…/instruments/de-fornace.lisp:127` | *(identical)* | SPEC | **NO** — as above. | n/a |
| `…/instruments/de-fornace.lisp:198` | `(ignore-errors (node-at-path tree (butlast path)))` | SPEC | **YES** — `STANDING-EDIT-P` answers on a NIL parent when path traversal fails for *any* reason; a failed traversal is indistinguishable from "the parent is not a `:STANDING` node." This one is materially broader than its sibling `PROPER-LIST-P` idiom. | n/a |
| `…/instruments/de-incantatione.lisp:149` | *(`PROPER-LIST-P` idiom)* | SPEC | **NO** — as above. | n/a |
| `…/instruments/de-leviathan.lisp:131` | *(identical)* | SPEC | **NO** — as above. | n/a |
| `…/instruments/de-nenbutsu-infinito.lisp:140` | *(identical)* | SPEC | **NO** — as above. | n/a |
| `…/instruments/de-resonantia.lisp:141` | *(identical)* | SPEC | **NO** — as above. | n/a |
| `…/instruments/de-symmetria-tremenda.lisp:125` | *(identical)* | SPEC | **NO** — as above. | n/a |
| `…/instruments/de-temperie.lisp:131` | *(identical)* | SPEC | **NO** — as above. | n/a |
| `…/instruments/de-temperie.lisp:299` | `(error (condition)` / `(fire 'transport-contamination "handoff text was not one inert form: ~a" condition)))` | SPEC | **YES** — any condition from `SAFE-READ-ONE` becomes the instrument's typed `TRANSPORT-CONTAMINATION` verdict. It does preserve the condition in the message, which is the mitigating half. | n/a |
| `experiments/latent-lisp/mneme/latent-mvp/kernel.lisp:38` | `(defun signals-error-p (th) (handler-case (progn (funcall th) nil) (error () t)))` | SPEC | **NO** — definitional. | n/a |
| `…/latent-mvp/evidence-kernel.lisp:124` | *(identical `SIGNALS-ERROR-P`)* | SPEC | **NO** — definitional. | n/a |
| `…/latent-mvp/certificate-kernel.lisp:105` | *(identical)* | SPEC | **NO** — definitional. | n/a |
| `…/latent-mvp/handoff-kernel.lisp:195` | *(identical)* | SPEC | **NO** — definitional. | n/a |
| `…/latent-mvp/surviving-witness.lisp:112` | *(identical)* | SPEC | **NO** — definitional. | n/a |
| `…/latent-mvp/lisp-plus.lisp:127` | `(error (e) (list :signalled (type-of e)))))` | SPEC | **NO** — the signalled *type* is retained and becomes the recorded observation; the record says "signalled X," not "returned X." | n/a |
| `…/latent-mvp/lisp-plus.lisp:177` | `(condition (c) (type-of c))))` | SPEC | **NO** — `RESOLVE-RAISES`; catching `condition` broadly is correct for a predicate that asks *which* condition fired, and the type is retained and `SUBTYPEP`-checked at 178. | n/a |
| `…/latent-mvp/lisp-plus.lisp:194` | `(let* ((val (handler-case (apply fn input) (error (e) (list :signalled (type-of e)))))` | SPEC | **NO** — type retained, as at :127. | n/a |
| `…/latent-mvp/lisp-plus.lisp:195` | `(ok (ignore-errors (funcall pred input val)))` | SPEC | **YES** — a broken post-condition predicate reads as `:VIOLATED`. An implementation failure in the *contract checker* becomes a contract verdict. | n/a |
| `experiments/latent-lisp/atelier/kw-0/hb0/hb0-control.lisp:95` | `(error () (setf torn t) (return))))` | SPEC | **YES** — any condition from `READ-FROM-STRING` marks the journal `torn`; a reader bug and a torn tail are indistinguishable in the HB/0 control's output. | n/a |
| `experiments/latent-lisp/atelier/kw-0/next/ss0/seats/a/base/ss0-reader.lisp:45` | `(error () (anom "record ~D: undecodable payload" i))))` | SPEC | **YES** — any condition from `SER-DECODE` is recorded as the anomaly "undecodable payload," a finding the SS-0 seat reports. | n/a |
| `experiments/latent-lisp/atelier/kw-0/next/ss0/seats/a/extension/ss0-reader.lisp:48` | *(identical to base:45)* | SPEC | **YES** — as above. | n/a |
| `…/extension/ss0-reader.lisp:124` | `(t (or (ignore-errors (parse-integer (princ-to-string v))) 0))))` | SPEC | **YES** (mild) — an unparseable value silently becomes `0` in a counted column. Also present as `+` context in `EXTENSION-DELTA.diff:417`. | n/a |
| `experiments/latent-lisp/atelier/kw-0/specimen/src/kw-common.lisp:250` | `(let ((d (ignore-errors (decode-event (journal-frame-payload f)))))` | SPEC | **YES** — a frame that fails to decode for *any* reason is silently dropped from the fold (`(when d …)` at 251), so a decoder bug reads as a journal with fewer events. | n/a |
| `experiments/latent-lisp/atelier/leibnitiana/post-decad/expect-condition-runtime/expect-condition-runtime.lisp:54` | `(handler-bind` / `((condition` / `(lambda (condition) …)` | SPEC | **NO** — the `condition`-typed `handler-bind` is the *correct* pattern here: matching conditions exit via `return-from capture` **carrying the condition**, and non-matching conditions fall through the `(t nil)` branch, declining and preserving the original signalling context (comment at 66-70). | n/a |
| `…/expect-condition-runtime-ancestor-d8a957a2.lisp:44` | `(condition (condition)` / `(cond ((typep condition condition-type) …)` | SPEC | **UNCLEAR** — the *superseded ancestor*. It catches `condition` broadly and inspects; but unlike its successor, a `handler-case` transfers control, so an outsider condition's original signalling context is destroyed even when re-signalled. Whether that is a defect *for this specimen's purpose* is the exact question the successor was written to settle. | Superseded by design; see `atelier/leibnitiana/post-decad/expect-condition-runtime/README.md` |
| `…/expect-condition-runtime-ancestor-d8a957a2.lisp:102` | `(condition (condition)` / `"RESULT: FAIL — ~a"` / `(sb-ext:exit :code 1)))` | SPEC | **NO** — top-level driver; FAIL + nonzero exit. | n/a |
| `experiments/latent-lisp/atelier/homoiconic-verse/specimens/claude37-recreational.lisp:84` | `(error (c)` / `"reality-warped as designed: ~a"` | SPEC | **NO** — the crash *is* the demonstration; the type is printed. | n/a |
| `…/homoiconic-verse/specimens/de-anadiplosi.lisp:55` | `(error () (format t "teeth: a line that did not inherit its head is refused~%")))` | SPEC | **YES** (mild) — the tooth prints success on any error; the guarded body exits 1 if no error fires, so it fails closed on the *absent*-teeth side but open on the *wrong*-error side. | n/a |
| `…/specimens/de-lectore.lisp:139` | `(error (c)` / `"   refused at parse: ~a"` | SPEC | **NO** — condition printed. | n/a |
| `…/specimens/de-lectore.lisp:149` | `(error (c)` / `"   refused at parse: ~a"` | SPEC | **NO** — condition printed. | n/a |
| `…/specimens/de-officio.lisp:142` | `(error (c)` / `"      error reach the lab: ~a"` | SPEC | **NO** — condition printed; the crash is the point of the demonstration. | n/a |
| `…/specimens/de-phasibus.lisp:62` | `(error (e) (format nil "BITE: ~A" e))))` | SPEC | **NO** — the message is asserted at 65 (`(search "unknown device D" bite)`). | n/a |
| `…/specimens/de-praescripto.lisp:189` | `(error () (setf refused-p t) …)` | SPEC | **YES** (mild) — `refused-p` is set on any error; the assertion at 191 then passes. | n/a |
| `…/specimens/de-vinculis.lisp:195` | `(error (e)` / `(assert (search "unlawful drift" (format nil "~a" e)))` | SPEC | **NO** — the message is asserted. Exemplary planted-fault shape. | n/a |
| `…/specimens/the-absent-chair.lisp:120` | `(error () (setf refused-p t) …)` | SPEC | **YES** (mild) — as `de-praescripto.lisp:189`. | n/a |
| `…/specimens/transpositio-non-inversa.lisp:295` | `(error (c)` / `"   caught, as designed: ~a"` | SPEC | **NO** — planted failure; condition printed, and the un-caught path exits 1. | n/a |
| `experiments/latent-lisp/atelier/nugae/carmen-viride.lisp:61` | `(error (e) (setf bitten t) (format t ";; [teeth] ~A~%" e))` | SPEC | **NO** — condition printed alongside the flag. | n/a |
| `experiments/latent-lisp/atelier/quine-orchard/relay-sol/verify-relay.lisp:85` | `(error () (setf teeth t)))` | SPEC | **YES** (mild) — planted-failure teeth check passes on any error. | n/a |
| `experiments/latent-lisp/atelier/quine-orchard/witnessed-lineage/verify-descent.lisp:373` | `(error () (setf teeth t)))` | SPEC | **YES** (mild) — as above. | n/a |
| `experiments/latent-lisp/atelier/sexp-garden/garden.lisp:306` | `(error () (setf teeth t)))` | SPEC | **YES** (mild) — as above. | n/a |
| `experiments/latent-lisp/atelier/sexp-garden/glider-herbarium.lisp:351` | `(error () (setf teeth t)))` | SPEC | **YES** (mild) — as above. | n/a |
| `experiments/latent-lisp/atelier/sexp-garden/graft-receipt.lisp:474` | `(error () (setf teeth t)))` | SPEC | **YES** (mild) — as above. | n/a |
| `experiments/latent-lisp/atelier/tower-of-selves/tower.lisp:351` | `(error (e) (format nil "signalled a structured CL error: ~a" (type-of e)))))` | SPEC | **NO** — the *type* is the reported datum; the whole probe is about error-shape degradation across floors. | n/a |
| `experiments/latent-lisp/received/s-expression-garden-sol/garden.lisp:444` | `(error (condition)` / `(push (list :kind :unreadable-atom … :condition (princ-to-string condition)) issues)` | SPEC | **NO** — the condition text is carried into the reported issue. | n/a |
| `…/s-expression-garden-sol/garden.lisp:535` | `(ignore-errors (constantp symbol))))` | SPEC | **NO** — guarded by `(eq (symbol-package symbol) (find-package :common-lisp))`; `CONSTANTP` is total on symbols. Vestigial. | n/a |
| `…/s-expression-garden-sol/garden.lisp:1146` | `(error (condition)` / `(list :args … :outcome :error :condition (condition-symbol condition) :message …)` | SPEC | **NO** — outcome is explicitly `:ERROR`, distinct from the semantic outcomes; type and message retained. Exemplary. | n/a |
| `…/s-expression-garden-sol/garden.lisp:1752` | `(error (condition)` / *(restore-and-resignal graft rollback)* | SPEC | **UNCLEAR** — the handler restores the mutated cells before the condition leaves. Whether the condition is re-signalled or converted into a receipt requires reading the clause body to its close (lines 1752-1800), beyond the window read. | n/a |

---

# SEVERE — GOVERNED SEMANTICS, CONVERTS FAILURE TO RESULT

Nine sites. All nine answer **YES**. Each is quoted from the file at the stated line.

The measure they are being judged against is not mine — it is the tree's own, stated at
`experiments/latent-lisp/mneme/language-surface-0/LANGUAGE-SURFACE-0-SPEC.md:105-107`:

> **Only the governed derivation-refusal type is caught.** Never `error`, never
> `serious-condition`, never `condition`. An unexpected host error escapes — a
> surface that swallowed a real bug as a refusal would be lying about the language.

Surface /0 holds that line. The nine sites below are one and two layers beneath it.

---

## S-1 · `experiments/latent-lisp/mneme/kernel0/boundary.lisp:71-85`

```lisp
  (handler-case
      (let ((procedures (%applicable-canonicalization-procedures value)))
        (unless (= 1 (length procedures))
          (%signal-noncanonical-durable-value context))
        (let ((datum
                (funcall
                 (%canonicalization-procedure-function (first procedures))
                 value)))
          (unless (lisp-plus-cd0:datum-p datum)
            (%signal-noncanonical-durable-value context))
          datum))
    (kernel0-condition (condition)
      (error condition))
    (error ()
      (%signal-noncanonical-durable-value context))))
```

**Reasoning.** The `(kernel0-condition (condition) (error condition))` clause at 82-83 is the
right instinct — Kernel /0's own conditions pass through untouched. What follows it converts
*everything else*. A registered canonicalization procedure that has a bug — a wrong-arity call,
an unbound variable, a `TYPE-ERROR` in the converter body — emits
`NONCANONICAL-DURABLE-VALUE`, which is the layer's statement *about the value*. The docstring
at 60-68 lists "predicate/converter failure" as an intended trigger, so this is deliberate; but
"the converter refused this value" and "the converter is broken" are the same output. Note the
downstream reach: `slice0-transmissibility.lisp:91-92` exposes exactly this as the public
predicate `REIFIABLE-P` (`accepts→T / refuses→NIL`), so a broken procedure makes a value read
as non-reifiable to any program asking.

## S-2 · `experiments/latent-lisp/mneme/language-core-0/core0.lisp:886-887`

```lisp
  (handler-case (%core0-issued-content-p evidence)
    (error () nil)))
```

**Reasoning.** The docstring immediately above (884-885) states the contract: *"Answers false —
never signals — for a value that is not a core0-evidence, and for an account whose content has
no canonical representation at all."* The handler delivers that totality by absorbing every
condition, so a fault inside `%core0-issued-content-p` — a registry corruption, a canonicalizer
crash — is reported as **"this account was not issued by Core /0."** That is the strongest
negative this layer can say, and it is exactly what a crash produces. The specification is
complicit: `LANGUAGE-SLICE-2-SPEC-0.md:222` freezes "answers false — never signals". This is
therefore a *specified* conversion, not an accident — which makes it more, not less, worth the
docket line.

## S-3 · `experiments/latent-lisp/mneme/language-core-0/core0.lisp:929-935`

```lisp
  (handler-case
      (and (%core0-issued-content-p evidence)
           (lisp-plus-slice1:structured-proposition=
            (lisp-plus-slice1:proposition canonical-request)
            (%core0-evidence-request evidence))
           t)
    (error () nil)))
```

**Reasoning.** Same shape, wider body. Three sub-operations sit inside the guard, and the second
one — `(lisp-plus-slice1:proposition canonical-request)` — is a *constructor* that signals
`MALFORMED-STRUCTURED-PROPOSITION` on bad input. A caller who hands a malformed request gets
`NIL`, i.e. "not issued for this request," which is a claim about *issuance*. So this site
additionally **collapses two distinct facts into one answer**: "the account was not issued for
this request" and "your request was not well-formed" are indistinguishable at the call site.

## S-4 · `experiments/latent-lisp/mneme/language-core-0/core0.lisp:944-952`

```lisp
  (handler-case
      (let ((nf (lisp-plus-slice1:proposition request)))
        nf)
    (error (c)
      (signal-core0 'malformed-request
                    :failed-invariant
                    (format nil "the :request MUST be a Slice /1 ground structured ~
proposition (CD/0-lawful); ~A" (type-of c))
                    :offending-field :request :offending-value request))))
```

**Reasoning.** This is the archetype of the class: *any* condition from `slice1:proposition`
is re-emitted as the governed refusal `MALFORMED-REQUEST`, a statement about the **caller's
input**. If Slice /1's constructor has a bug, Core /0 blames the caller. The mitigating detail,
and it is real: `(type-of c)` is spliced into the failed-invariant string, so a reader of the
refusal *can* see the underlying condition type. That makes this the least opaque of the nine —
but the refusal's *classification* is still wrong, and any program branching on the condition
type rather than reading the string cannot tell.

## S-5 · `experiments/latent-lisp/mneme/language-slice-1/slice1.lisp:380-382`

```lisp
(defun normal-form-p (x)
  "True when X is structurally a normal-form ground proposition."
  (ignore-errors (equal x (proposition x))))
```

**Reasoning.** An exported Slice /1 predicate whose entire body is inside an `IGNORE-ERRORS`.
`PROPOSITION` is a validating constructor with a rich typed refusal vocabulary — duplicate
roles, raw `(:var …)`, non-boundary values — and every one of those, plus any implementation
fault, comes back as `NIL`, "not in normal form." The docstring says *structurally*, which is a
promise about shape; the implementation delivers a promise about "did the constructor survive."
Note the sharp edge for Form /1 specifically: `LANGUAGE-FORM-1-WORK-ORDER.md:162-164` reasons
*from* this predicate — it is cited there as testing "a strictly stronger property than either
gate," which is a claim about what the predicate refuses. Anything the constructor throws for a
non-shape reason silently joins that refusal set.

## S-6 · `experiments/latent-lisp/mneme/language-slice-2/slice2.lisp:625-634`

```lisp
  (handler-case
      (let ((standing (lisp-plus-kernel0:fold-attempt-outcome
                       (lisp-plus-core0:core0-evidence-events evidence)
                       (lisp-plus-core0:core0-evidence-attempt-id evidence))))
        (values (or (lisp-plus-kernel0:attempt-outcome-standing-terminal-class
                     standing)
                    :not-reported)
                (lisp-plus-kernel0:attempt-outcome-standing-unresolved-effect-p
                 standing)))
    (error () (values :not-reported nil))))
```

**Reasoning.** The docstring at 621-624 is emphatic that this value is *fold-derived*: "never
read off a self-reported field." The handler undoes that. A crash inside Kernel /0's
`FOLD-ATTEMPT-OUTCOME` returns `(values :NOT-REPORTED NIL)` — byte-identical to the answer for
an account whose fold legitimately names no terminal class. **And note the second value**: `NIL`
for `unresolved-effect-p` is the *reassuring* answer. A fold that crashed reports "no terminal
class, and no unresolved effect" — the shape of a clean, quiet account. This is the most
dangerous of the nine, because the swallowed failure produces an affirmatively calm result
rather than an absence.

## S-7 · `experiments/latent-lisp/mneme/language-slice-2/slice2.lisp:808-813`

```lisp
  (let ((request-nf (handler-case (lisp-plus-slice1:proposition request)
                      (error ()
                        (%refuse 'source-basis-refused :request request
                                 "the :REQUEST must be a Slice /1 ground ~
structured proposition — the same vocabulary PERFORM's own :REQUEST is stated ~
in; got ~S" request)))))
```

**Reasoning.** Structurally S-4 one layer up, but *without* S-4's mitigation: the condition
object is dropped entirely — no variable is bound, no `(type-of c)` reaches the message. The
emitted `SOURCE-BASIS-REFUSED` is documented in `LANGUAGE-SLICE-2-API.md:127-128` as meaning
"an unknown relation, a non-account, a malformed request, or a reported value that is not the
expected one" — four caller-facing meanings, now five, the fifth being "Slice /1 broke and
nobody will ever know."

## S-8 · `experiments/latent-lisp/mneme/language-slice-2/slice2.lisp:1539-1540` — **D-1**

```lisp
         (registered (handler-case (lisp-plus-slice1:resolve-schema name version)
                       (error () nil))))
```

**Reasoning.** Already docketed; restated here for completeness and because the docket line is
exactly right. `registered` becomes `NIL`, the `EQ` identity check below it fails, and
`DERIVE/2` emits `SLICE2-SCHEMA-ERROR` — "this schema is not the registered one." A registry
whose read *crashed* is indistinguishable from a schema that was never registered. The existing
docket's operative sentence is the one to carry forward verbatim: **"Never read
`slice2-schema-error` as proof of absence."**

Worth recording alongside it: `de-pignore`'s Review 2 found and repaired *this same defect*
in its own calls to `resolve-schema` and `derive/2` (`DESIGN-NOTE.md:437-457`), measuring
`resolve-schema -> planted SIMPLE-ERROR became :BASE-SCHEMA-NO-LONGER-LIVE`. The specimen was
hardened; the governed layer it calls was not.

## S-9 · `experiments/latent-lisp/mneme/lci0/common-lisp/migration.lisp:167-169`

```lisp
  (let ((text (handler-case
                  (sb-ext:octets-to-string octets :external-format :utf-8)
                (error () (%legacy-source-fail)))))
```

with, at lines 54-56:

```lisp
(defun %legacy-source-fail (&optional (path '("fixture-field:source-bytes")))
  (lci-fail "migration-refusal" "UnsupportedLegacyForm" "migration-source"
            :path path))
```

**Reasoning.** Any condition from the host's UTF-8 decoder is emitted as the **frozen,
cross-language, normatively-specified** failure code `migration-refusal/UnsupportedLegacyForm`
(registry entry at `mneme/lci0/spec/LCI0-NORMATIVE-FIXTURE-PACKAGE-SPEC.md:1172`; semantics at
`LOCATED-CLAIM-IDENTITY-SPEC.md:2154`: *"Source form has no declared adapter."*). This is the
most consequential conversion in the nine because the output is **differential-test currency**:
`LCI0-CLOSURE-HOSTILE-RESULT-RECEIPT.md:21` records cross-implementation agreement/divergence
on exactly this code. A Common-Lisp-side decoder fault would be published as a semantic
agreement or divergence about legacy-form support, and the receipt would carry it.

---

# PRIOR DOCKET COVERAGE

## Already docketed

| occurrence | docketed where | as what |
|---|---|---|
| `mneme/language-slice-2/slice2.lisp:1540` | `experiments/latent-lisp/mneme/language-form-1/LANGUAGE-FORM-1-WORK-ORDER.md:1432-1434` | **D-1** — "a broad `(handler-case … (error () nil))` inside a Slice /2 semantic path (`slice2.lisp:1539-1540`): a *broken* registry read is indistinguishable from an *unregistered* schema. **Never read `slice2-schema-error` as proof of absence.**" Listed under §22 "DOCKET — observed, NOT repaired in this branch"; `WORK-ORDER.md:1209` states D-1…D-4 are not repaired here. |

**That is the only one.** One of 121, one of 9 severe.

## Partially covered — named in prose, never docketed as a defect

| occurrence | where mentioned | what it says |
|---|---|---|
| `mneme/language-slice-1/slice1.lisp:382` | `experiments/latent-lisp/mneme/language-core-0/census/CENSUS-SLICE-1.md:102` | Census row 3: "Predicate: `(equal x (proposition x))`, **errors swallowed**." Recorded as a behaviour description in a standing-assignment table (proposed standing **LIB**), not as a finding. |
| `mneme/language-slice-1/slice1.lisp:382` | `experiments/latent-lisp/mneme/language-form-1/LANGUAGE-FORM-1-WORK-ORDER.md:162-164` | Quotes the form verbatim while *reasoning from* the predicate's refusal set; the swallow is not commented on. |
| `mneme/language-core-0/core0.lisp:887` and `:935` | `experiments/latent-lisp/mneme/language-slice-2/LANGUAGE-SLICE-2-SPEC-0.md:222` (also `core0.lisp:884-885`, `:927-928`) | The behaviour is **specified**: "answers false — never signals — for a non-evidence value, unencodable content, or a malformed or non-ground request." Specification, not docket. Read as: the conversion is intentional and frozen, and nobody has recorded what it costs. |

## Adjacent prior work that does NOT cover any live occurrence

- `experiments/latent-lisp/mneme/language-slice-2/de-pignore/DESIGN-NOTE.md:437-457` and
  `…/SPECIMEN-RETURN.md:89-91` — **D2**, "broad handlers mistaken for refusal semantics,"
  REPRODUCED on two paths, with measurements (`derive/2 -> planted SIMPLE-ERROR became
  :PREMISE-NOT-SATISFIED`; `resolve-schema -> planted SIMPLE-ERROR became
  :BASE-SCHEMA-NO-LONGER-LIVE`). **Repaired.** Those handler sites no longer exist in
  `APPLICATION.lisp`; what remains at `:1023` is the *tooth* that proves the repair. D2 covers
  the specimen's own call sites only — not the governed layers it calls.
- `experiments/latent-lisp/mneme/language-surface-0/LANGUAGE-SURFACE-0-SPEC.md:105-109` — the
  doctrine, stated as Surface /0 policy. A rule, not a docket, and Surface /0 keeps it.
- `experiments/latent-lisp/mneme/language-slice-0/stranger-implementation-0/EVALUATION.md:557-559`
  — notes that a defective stranger program might wrap an attempt in `ignore-errors`, and that
  such swallowing is recorded. An evaluation criterion, not a site docket.

## NEW — not previously docketed anywhere

**120 of 121 occurrences.** Of the severe class: **8 of 9 are NEW** (S-1 through S-7 and S-9;
only S-8 = D-1 is docketed). Two of the eight (S-2, S-3) are *specified* behaviour with no
defect record; six (S-1, S-4, S-5, S-6, S-7, S-9) have no record of any kind.

Beyond the severe class, the occurrences most worth a reader's eye, none previously docketed:

- `mneme/lci0/differential/common_lisp_adapter.lisp:421`, `:445`, `:466` — three broad handlers
  that `(declare (ignore condition))` and render a protocol-failure response. The differential
  comparator cannot distinguish an adapter crash from a protocol failure.
- `atelier/kw-0/specimen/src/kw-common.lisp:250` — a journal frame that fails to decode is
  silently dropped from the fold. In a killed-witness bench, a decoder fault reads as a shorter
  journal.
- `atelier/kw-0/next/ss0/seats/a/{base,extension}/ss0-reader.lisp:45/:48` — any condition becomes
  the reported anomaly "undecodable payload," in the SS-0 seat readers whose lane is closed.
- `mneme/atelier/instruments/de-fornace.lisp:198` — `STANDING-EDIT-P` answers on a NIL parent
  when path traversal fails for any reason.

---

# APPENDIX — EXCLUDED, AND WHY

## A. `style-warning` / `warning` muffling at load time — **49 occurrences across 35 files, excluded by the brief**

`(handler-bind ((style-warning (lambda (w) (muffle-warning w)))) (load …))` and
`(handler-bind ((style-warning #'muffle-warning)) (load …))`. Warning suppression during
bootstrap loading, not failure conversion. Every one of these sits **above** its file's
`;;; ==== BOOTSTRAP ENDS HERE ====` marker where such a marker exists (`form0.lisp:31`,
`form1.lisp:37`). One variant binds `warning` rather than `style-warning`
(`mneme/language-surface-0/surface0-selftest.lisp:679`) — broader, still warning-only, still
excluded. Counted mechanically (`rg -c 'handler-bind\s*\(\((style-warning|warning)\b'`):

`language-core-0/`: `core0.lisp` 1 · `core0-selftest.lisp` 1 · `core0-issuance-selftest.lisp` 1 ·
`fake-courier.lisp` 1 · `de-abaco/SPECIMEN.lisp` 1 · `de-bibliotheca-peregrina/APPLICATION.lisp` 4 ·
`de-codice-restaurando/APPLICATION.lisp` 3 · `de-cursore-aereo/SPECIMEN.lisp` 1 ·
`de-ponte-usto/SPECIMEN.lisp` 1 —
`language-form-0/`: `form0.lisp` 2 —
`language-form-1/`: `form1.lisp` 2 · `form1-selftest.lisp` 1 · `de-forma-petente/APPLICATION.lisp` 2 ·
`EG4-IDENTITY-VALUE-MEASUREMENT.lisp` 1 · `EG4-MEASUREMENT.lisp` 1 · `EG4-WHEN-THE-GATE-FIRES.lisp` 1 ·
`EXPORT-CENSUS.lisp` 1 · `REVIEW-1-HOLLOW-CHECKS.lisp` 1 · `REVIEW-1-NC31-BEFORE.lisp` 1 —
`language-slice-1/`: `slice1-selftest.lisp` 2 · `SMOKE-1.lisp` 1 · `CHAIR-REPRO-B1-B2.lisp` 1 ·
`de-praemissis/{SPECIMEN,ABLATION}.lisp` 1+1 ·
`de-admissione-datorum/{SPECIMEN,ABLATION,MULTIPLICITY,MULTIPLICITY-REPAIRED}.lisp` 1+1+1+1 ·
`stranger-implementation-codex/STRANGER-PROGRAM.lisp` 1 —
`language-slice-2/`: `slice2.lisp` 1 · `slice2-selftest.lisp` 2 · `SMOKE-2.lisp` 2 ·
`de-pignore/APPLICATION.lisp` 1 —
`language-surface-0/`: `surface0.lisp` 2 · `surface0-selftest.lisp` 3.

## B. `(error 'typed-condition …)` — SIGNALLING, not handling — **not counted**

Every `(error 'some-condition-type …)` and `(error condition)` re-signal form in the tree.
These are the *correct* pattern and the brief forbids reporting them. A representative sample,
so the reader can see they were looked at and dismissed on purpose:
`mneme/kernel0/conditions.lisp:192`, `:252` · `mneme/kernel0/boundary.lisp:83`
(`(error condition)` — a deliberate re-signal *inside* a typed clause, and the good half of S-1) ·
`mneme/language-slice-2/de-pignore/APPLICATION.lisp:105`
(`(error 'unsupported-snapshot-value …)`) ·
`mneme/lci0/differential/common_lisp_adapter.lisp:20`
(`(error 'integration-protocol-failure …)`) ·
`atelier/leibnitiana/post-decad/expect-condition-runtime/expect-condition-runtime.lisp:80`, `:86` ·
`mneme/atelier/kernel/atelier-root.lisp:57`, `:59`, `:68`. The scan pattern
`\(error\s*\(\s*[a-zA-Z0-9_-]*\s*\)` cannot match these (a quoted symbol or a variable follows
`error`, not a lambda-list), and `form1-selftest.lisp:1684-1686` encodes the same distinction as
an executable test — **T-SCAN-06**: *"the scanner does NOT flag (ERROR 'PETITION-REFUSED …) —
signalling a typed condition is not a blanket handler."*

## C. Typed `handler-case` clauses naming a specific condition — **not counted**

The correct pattern, present throughout and dominant: `petition-refused`, `form-refused`,
`slice2-derivation-refused`, `slice2-schema-error`, `slice0-condition`, `kernel0-condition`,
`identity-drift`, `noncanonical-durable-value`, `standing-inflation`,
`journal-merge-receipt-required`, `lci-failure`, `lci-unsupported-fixture-behavior`,
`fixture-operation-authorial-gap`, `integration-protocol-failure`, `schema-not-found`,
`validation-error`, `non-canonical-object`, `storage-condition`, `evaluation-budget-exhausted`,
`lathe-budget-exhausted`, `audit-outsider-note`, `audit-repairable-outsider`,
`mneme.client:mneme-error`, plus macro-parameterised `(,condition-type () …)` clauses (which are
specific by construction at expansion). Of the 503 total `handler-case`/`handler-bind` textual
mentions in the tree, the overwhelming majority are of this kind.

## D. String literals and quoted source that *mention* a broad handler — **2, not counted as sites**

| path:line | what it is |
|---|---|
| `experiments/latent-lisp/mneme/language-form-1/form1-selftest.lisp:1680` *(now `:2051`)* | `(check (substring-present-p (strip-comments-and-strings "(handler-case (f) (error () nil))") "(error (")` — a **planted fault for the scanner**, T-SCAN-05: proves the source scanner can *find* a blanket handler before the scanner is believed. The broad handler exists only as characters inside a string. |
| `experiments/latent-lisp/mneme/language-form-1/form1-selftest.lisp:1697` *(now `:2068`)* | `(check (not (substring-present-p *form1-code* "(error ()")))` — T-NO-BROAD-HANDLER, the **gate itself**. Not a handler. |

## E. Shell scripts — **2 textual hits, 0 sites**

`experiments/latent-lisp/mneme/language-surface-0/PLANTED-FAULTS.sh:68` and `:92` both contain
`` `(handler-case `` inside Python heredoc string constants used to rewrite `surface0.lisp` for
planted faults A and B. The quoted text is Surface /0's *existing* macro-expansion template
(whose clause is the typed `slice2-derivation-refused`); neither introduces a broad clause. All
17 `.sh` files were scanned; no other hit of any kind.

## F. Non-Lisp source — **0 sites**

`.py` (116), `.sexp` (36), `.asd` (4), `.lisp+` (3), `.patch` (7), `.pj0` (1,261), `.pjs` (227),
`.json`/`.jsonl` — swept for all patterns. **Zero handler occurrences.** The single textual hit,
`mneme/atelier/MANIFEST.sexp:125`, is a prose repair-note *describing* a `handler-case` clause-type
bug; no code.

## G. Documentation and diffs — **excluded from the site count by construction**

`*.md`, `*.txt`, `*.diff` were excluded from the pattern pass and searched separately for prior
docket coverage only. One diff carries a live-code line already counted from its `.lisp` source:
`atelier/kw-0/next/ss0/seats/a/extension/EXTENSION-DELTA.diff:417` is the `+` side of
`ss0-reader.lisp:124`. One archived source, `mneme/atelier/evidence/de-corroboratione-0.4a-verification/de-corroboratione.FABLE-DELIVERED.lisp.txt:96`,
contains a `handler-case` whose clause type is a gensym'd variable — typed by construction, not broad.

---

# FORM /1 ITSELF — the subject of Review 1

`experiments/latent-lisp/mneme/language-form-1/form1.lisp` contains **ZERO** broad handlers.
Verified two independent ways:

1. **This scan.** The only `handler-case`/`handler-bind` forms in the file are at lines 29, 32
   (`style-warning` muffling, above the marker at line 37), 490, 502 (`petition-refused`), and
   1464 — whose clauses at 1473 and 1478 are `lisp-plus-slice2:slice2-derivation-refused` and
   `lisp-plus-slice2:slice2-schema-error`. Nothing else. **Re-checked after the concurrent edit
   of 13:48:47** (file now 1569 lines): identical, same five forms, same line numbers.
2. **The file's own gate.** `form1-selftest.lisp` scans the code below the marker for
   `"(error ()"` and, more strongly, `"(error ("` — *"however the variable is named"* — and the
   scanner is itself teeth-checked immediately before it is believed (T-SCAN-01…06, including a
   planted broad handler it must find and a typed `(error 'petition-refused …)` it must not
   flag). At scan time those gates sat at `:1697-1701` with the teeth-check at `:1664-1686`;
   after the concurrent edit they read at **`:2068-2072`**, verbatim unchanged.

Form /1's own escape doctrine is stated at `form1.lisp:1487`: *"An unexpected condition ESCAPES,
and leaves no semantic object behind."* It holds it. The nine severe sites are all beneath it —
in Slice /1, Slice /2, Core /0, Kernel /0 and LCI/0 — which is precisely why they are worth a
docket that Form /1 Review 1 does not have to act on.

---

*— SIEVE. Read-only. 2,647 files walked; 121 occurrences recorded; 33 convert an implementation
failure into a protocol result, 9 of those in governed semantics; 120 of 121 previously
undocketed. No file in `/home/gauss/Desktop/wt-form1-candidate-0/experiments/latent-lisp/` was
modified by this scan. Every line number here was read at the file, not taken from the grep —
and the nine severe ones were read twice, before and after another hand began editing
`mneme/language-form-1/` mid-scan. Where the tree moved under me, the movement is on the record
above rather than smoothed out of it.*
