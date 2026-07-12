# EXPECT-CONDITION-RUNTIME native census: ancestor vs successor

Measured with SBCL on 2026-07-12. `PASS` and `FAIL` below are observed, not
inferred. Predictions are Sol's §4 predictions; §4 asked that ancestor Probe 6
be recorded honestly rather than predicting an outcome.

## Census

| Artifact | Probe | Sol predicted | Native observation | Condensed actual output |
|---|---:|---|---|---|
| ancestor | 1 | FAIL | **FAIL** | `Unhandled AUDIT-OUTSIDER-NOTE ... ERROR ... EXPECT-CONDITION-RUNTIME`; exit 1 |
| successor | 1 | PASS | **PASS** | `PROBE-1|predicted=PASS|observed=PASS|observations=1 result=T`; exit 0 |
| ancestor | 2 | FAIL | **FAIL** | `PROBE-2|predicted=FAIL|observed=FAIL|SIMPLE-ERROR: FAIL: outsider arrived only after its restart had been unwound` |
| successor | 2 | PASS | **PASS** | `PROBE-2|predicted=PASS|observed=PASS` |
| ancestor | 3 | FAIL despite exit 0 | **FAIL**, exit 0 | ancestor self-test prints `RESULT: PASS — 3/3 teeth bit`; `POST-LOAD-SURVIVED` absent |
| successor | 3 | PASS | **PASS**, exit 0 | `POST-LOAD-SURVIVED` |
| ancestor | 4 | PASS | **PASS** | `PROBE-4|predicted=PASS|observed=PASS` |
| successor | 4 | PASS | **PASS** | `PROBE-4|predicted=PASS|observed=PASS` |
| ancestor | 5 | PASS | **PASS** | `PROBE-5|predicted=PASS|observed=PASS` |
| successor | 5 | PASS | **PASS** | `PROBE-5|predicted=PASS|observed=PASS` |
| ancestor | 6 | record honestly | **PASS** | `PROBE-6|predicted=RECORD|observed=PASS` |
| successor | 6 | PASS | **PASS** | `PROBE-6|predicted=RECORD|observed=PASS` |

The successor's original three teeth also pass:

```text
[PASS 1/9] original expected -> T
[PASS 2/9] original sibling -> mismatch
[PASS 3/9] original normal return -> missing
```

## Commands and actual native output

The intact ancestor was used for Probe 3 exactly with Sol's command shape:

```sh
output="$(
  sbcl --noinform --non-interactive \
    --eval '(load "expect-condition-runtime-ancestor-d8a957a2.lisp")' \
    --eval '(format t "POST-LOAD-SURVIVED~%")'
)"
printf '%s\n' "$output" | grep -q 'POST-LOAD-SURVIVED'
```

Actual captured output and status:

```text
EXPECT-CONDITION-RUNTIME self-test ledger
[BITE 1/3] expected condition -> success value T
[BITE 2/3] family sibling -> distinct mismatch error
[BITE 3/3] normal return -> distinct missing-condition error
RESULT: PASS — 3/3 teeth bit
sbcl exit: 0
grep result: FAIL (POST-LOAD-SURVIVED absent)
```

For ancestor Probes 1–2 and 4–6, lines 1–57 of the ancestor were extracted
verbatim to `/tmp/expect-condition-runtime-ancestor-definitions.lisp`:

```sh
sed -n '1,57p' expect-condition-runtime-ancestor-d8a957a2.lisp \
  > /tmp/expect-condition-runtime-ancestor-definitions.lisp
sha256sum /tmp/expect-condition-runtime-ancestor-definitions.lisp
```

Only the self-test/exiting exhibit beginning at line 58 was stripped. The
definitions were not edited. Actual extraction hash:

```text
5357eb4378d96f44b7492b5d91dd5b394ccb304a312b89887efcbc2d7719e1f0  /tmp/expect-condition-runtime-ancestor-definitions.lisp
```

Fresh SBCL runs loaded that extraction. Probe 1's actual terminal evidence was:

```text
Unhandled AUDIT-OUTSIDER-NOTE ...
3: (ERROR #<AUDIT-OUTSIDER-NOTE ...>)
4: (EXPECT-CONDITION-RUNTIME ...)
unhandled condition in --disable-debugger mode, quitting
exit: 1
```

The fresh ancestor run for the remaining probes printed:

```text
PROBE-2|predicted=FAIL|observed=FAIL|SIMPLE-ERROR: FAIL: outsider arrived only after its restart had been unwound
PROBE-4|predicted=PASS|observed=PASS
PROBE-5|predicted=PASS|observed=PASS
PROBE-6|predicted=RECORD|observed=PASS
exit: 0
```

The same census harness in a fresh SBCL loading the successor printed:

```text
PROBE-1|predicted=PASS|observed=PASS|observations=1 result=T
PROBE-2|predicted=PASS|observed=PASS
PROBE-4|predicted=PASS|observed=PASS
PROBE-5|predicted=PASS|observed=PASS
PROBE-6|predicted=RECORD|observed=PASS
exit: 0
```

Successor Probe 3 was run separately:

```sh
output="$(
  sbcl --noinform --non-interactive \
    --eval '(load "expect-condition-runtime.lisp")' \
    --eval '(format t "POST-LOAD-SURVIVED~%")'
)"
printf '%s\n' "$output" | grep -q 'POST-LOAD-SURVIVED'
```

Actual output:

```text
POST-LOAD-SURVIVED
sbcl exit: 0
grep result: PASS
```

## Probe 1 intent adaptation

Sol's literal Probe 1 places an `AUDIT-OUTSIDER-NOTE` `HANDLER-CASE` around
the declining `HANDLER-BIND`. That clause is itself a live handler for the
first advisory `SIGNAL`; after the declining handlers return, it transfers
control even with the amended core. A broad `CONDITION` catcher in a ledger
has the same problem.

The census and shipped test conservatively implement the stated intent: the
outer observer declines, no advisory-catching `HANDLER-CASE` surrounds it,
and the ledger catches only `ERROR`. Thus a normal unhandled `SIGNAL` resumes;
the ancestor's `(ERROR condition)` reconstruction is fatal. No helper semantics
or classification order was changed.

## Receiver-authored §5 row (quoted)

```text
artifact:
  expect-condition-runtime.lisp
  ancestor-sha256:
    d8a957a2835d2d8809ce30c533ad182ce83b2cb7b27b4b6aed6d933d66e14a51

probe-kind:
  receiver-authored

claim-under-test:
  out-of-family conditions are re-signaled unchanged

counterexample:
  continuable outsider carrying a live restart

result:
  fails at protocol level

mechanism:
  HANDLER-CASE unwinds before classification clause;
  ERROR begins a second, non-returning signaling event

preserved:
  condition object identity

lost:
  original continuation
  dynamic restart set
  signaling operator
  signal-site dynamic context

blast-radius:
  prototype only

explicitly-not-affected:
  adopted de-nenbutsu-infinito repair,
  whose literal NENBUTSU-ERROR clause never catches outsiders

disposition:
  preserve ancestor hash;
  issue amended separate succession;
  split library from executable test;
  native-run old and new against receiver probes
```

## Twice-run successor ledger

Command, executed twice:

```sh
sbcl --noinform --script test-expect-condition-runtime.lisp
```

Both runs exited 0. `cmp -s` exited 0, and both captured output files had this
SHA-256:

```text
478b270ddb211bd1d12cf1189d534762863b5ce8b3e626eece5027323fefc062
```

Full byte-identical output:

```text
EXPECT-CONDITION-RUNTIME amended-successor ledger
[PASS 1/9] original expected -> T
[PASS 2/9] original sibling -> mismatch
[PASS 3/9] original normal return -> missing
[PASS 4/9] probe 1: continuable outsider remains continuable
[PASS 5/9] probe 2: outsider restart remains available
[PASS 6/9] probe 3: implementation load returned
[PASS 7/9] probe 4: mismatch retains object identity
[PASS 8/9] probe 5: helper diagnostic remains outside its net
[PASS 9/9] probe 6: expected classification outranks family mismatch
RESULT: PASS — 9/9 rows passed
```
