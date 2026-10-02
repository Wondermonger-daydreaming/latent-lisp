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

# 2026-09-30 (RALLY, Astra's disposition of dossier r0): only where the process boundary matters.
# RE14: ,help through the one command. The banner names ,help and ,quit, so the check looks for the
# three controls only the help text names, and for the next form still being in[1].
run ',help\n(car 5)\n'
[ "$(rc)" = 0 ] && has ',names' && has ',reset' && has ',cancel' && has 'E-TYPE at in[1]:1:0' && ! has 'E-READ' && ok ",help lists the controls, reaches no Lisp+ and counts nothing (the next form is in[1]); exit 0" || bad "help" "rc=$(rc)"

# G-A through the process: a code the one command had not shown recovering, then an earlier binding answers.
run '(define k 5)\n(/ k 0)\n(+ k 1)\n'
[ "$(rc)" = 0 ] && has 'E-ARITH at in[2]:1:0' && has '=> 6' && ok "E-ARITH, then a submission reading the earlier binding succeeds, same session; exit 0" || bad "recover-arith" "rc=$(rc)"

# RE15: the packages of the image main.lisp builds. NOT the one command itself (lisp-plus-repl.sh runs
# main.lisp with --script): a fresh sbcl with the launcher's runtime flags, argv reset to the
# command-line REPL, and a TEST-ONLY exit hook that lists every package when the session ends at EOF.
# Names from each lane's package.lisp at candidate 12379a8cf (act0, act1 + its loader, many-acts0 x2, core0).
printf '' | sbcl --noinform --control-stack-size 64MB --non-interactive --no-sysinit --no-userinit \
  --eval '(setf sb-ext:*posix-argv* (list "sbcl"))' \
  --eval '(push (lambda () (dolist (p (list-all-packages)) (format *error-output* "~&PKG ~a~%" (package-name p)))) sb-ext:*exit-hooks*)' \
  --load "$HERE/main.lisp" > "$TMP/out" 2> "$TMP/err"; r=$?
pk() { grep -qxF "PKG $1" "$TMP/err"; }
[ "$r" = 0 ] && has '; bye' && pk LISP-PLUS-REPL0 && pk LISP-PLUS-PROGRAM0 && pk LISP-PLUS-KERNEL0 \
  && ! pk LISP-PLUS-LANGUAGE-ACT0 && ! pk LISP-PLUS-LANGUAGE-ACT1 && ! pk LISP-PLUS-LANGUAGE-ACT1-LOADER \
  && ! pk LISP-PLUS-MANY-ACTS0 && ! pk LISP-PLUS-MANY-ACTS0.PROGRAM && ! pk LISP-PLUS-CORE0 \
  && ok "main.lisp's image (test-only exit hook): no act0, act1, many-acts0 or core0 package; REPL, PROGRAM /0, Kernel /0 present" || bad "image-packages" "rc=$r"

echo "repl0 test-cli: $pass passed, $fail failed"
[ "$fail" -eq 0 ]
