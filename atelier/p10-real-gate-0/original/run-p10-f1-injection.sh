#!/usr/bin/env bash
set -u

transcript=$(mktemp /tmp/frigus-p10-f1-XXXXXX.txt)
printf '%s\n' 'INNER-COMMAND: cd substrate && sbcl --script ../evidence/p10-f1-introspection-injection.lisp'
(
  cd substrate
  sbcl --script ../evidence/p10-f1-introspection-injection.lisp
) >"$transcript" 2>&1
rc=$?

printf '%s\n' '---- DIRECT SBCL OUTPUT ----'
sed -n '1,$p' "$transcript"
printf 'INNER-DIRECT-EXIT: %d\n' "$rc"

injection_count=$(rg -c '^FRIGUS-INJECTED-INTROSPECTION-ERROR:' "$transcript" || true)
target_count=$(sed -n 's/^FRIGUS-TARGET-INJECTIONS: //p' "$transcript" | tail -n 1)
green_count=$(rg -c '^ml0-block-proof: 20 probes, 20 closed, 0 open$' "$transcript" || true)

printf 'OBSERVED-INJECTION-LINES: %s\n' "$injection_count"
printf 'EXIT-HOOK-TARGET-COUNT: %s\n' "$target_count"
printf 'UNCHANGED-GREEN-SUMMARY-LINES: %s\n' "$green_count"

if [ "$rc" -eq 0 ] && [ "$injection_count" -eq 1 ] && \
   [ "$target_count" -eq 1 ] && [ "$green_count" -eq 1 ]; then
  printf '%s\n' 'P10-F1-INTROSPECTION-INJECTION: PASS — the injected failure was swallowed and absent from F1 accounting while the gate remained green.'
  exit 0
fi

printf '%s\n' 'P10-F1-INTROSPECTION-INJECTION: FAIL'
exit 1
