#!/usr/bin/env bash
# test-cli.sh — REPL /0's command-line checks THROUGH THE ONE COMMAND (a real sbcl
# process on a pipe), complementing repl0-selftest.lisp (which drives run-cli in-process).
#   bash mneme/language-repl-0/test-cli.sh     (exit 0 iff every check passed)
# Each check captures the command's exit status BEFORE any pipe, and prints one line.
set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CMD="$HERE/lisp-plus-repl.sh"
TMP="$(mktemp -d)"; trap 'rm -rf "$TMP"' EXIT
pass=0; fail=0
ok()   { pass=$((pass+1)); echo "ok   $1"; }
bad()  { fail=$((fail+1)); echo "FAIL $1${2:+  — $2}"; }
run()  { printf '%b' "$1" | bash "$CMD" > "$TMP/out" 2> "$TMP/err"; echo $? > "$TMP/rc"; }
rc()   { cat "$TMP/rc"; }
has()  { grep -qF -- "$1" "$TMP/out"; }

run '(define x 2)\n(* x 21)\n'
[ "$(rc)" = 0 ] && has '=> 42' && ok "a definition persists into the next submission; exit 0 at end of input" || bad "persist" "rc=$(rc)"

run '(define (f n)\n  (* n 2))\n(f 21)\n'
has '   ..> ' && has '=> 42' && ok "a multi-line form through the real command" || bad "multiline"

run '(define k 1)\n(car 5)\n(+ k 1)\n'
[ "$(rc)" = 0 ] && has 'E-TYPE at in[2]:1:0' && has '=> 2' && ok "an error, then success, same session; exit 0" || bad "recover" "rc=$(rc)"

run '(define half 1)\n(print 777\n'
[ "$(rc)" = 0 ] && has 'discarded, NOT evaluated' && ! grep -qx '777' "$TMP/out" && ok "EOF inside an unfinished form: discarded, not run, clean exit 0" || bad "eof-mid-form" "rc=$(rc)"

run ''
[ "$(rc)" = 0 ] && has '; bye' && ok "EOF at once (no input): clean exit 0" || bad "eof-empty" "rc=$(rc)"

run ',quit\n(print 999)\n'
[ "$(rc)" = 0 ] && ! grep -qx '999' "$TMP/out" && ok ",quit leaves before later input runs; exit 0" || bad "quit" "rc=$(rc)"

run '#.(sb-ext:quit :unix-status 7)\n(+ 1 1)\n'
[ "$(rc)" = 0 ] && has 'E-READ' && has '=> 2' && ok "#.(sb-ext:quit …) cannot reach the host: E-READ, the session lives, exit 0 not 7" || bad "read-eval" "rc=$(rc)"

bash "$CMD" --bogus > "$TMP/out" 2> "$TMP/err"; r=$?
[ "$r" = 3 ] && ok "an unknown option is a usage error, exit 3" || bad "usage" "rc=$r"

grep -q 'kernel0 foundations smoke: PASS' "$TMP/err" 2>/dev/null; run '(+ 1 2)\n'
! grep -q 'kernel0' "$TMP/out" && grep -q 'kernel0' "$TMP/err" && ok "load chatter goes to stderr; stdout is the session" || bad "streams"

echo "repl0 test-cli: $pass passed, $fail failed"
[ "$fail" -eq 0 ]
