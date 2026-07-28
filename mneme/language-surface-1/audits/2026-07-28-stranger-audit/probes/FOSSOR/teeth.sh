#!/usr/bin/env bash
# FOSSOR — runner teeth.  Every mutation happens in the WORKING COPY only.
W=/tmp/claude-1000/-home-gauss-Desktop-Claude-Code-Lab/d214ea40-d602-4f0d-b684-e6f5fddf4447/scratchpad/surface1-audit/probes/FOSSOR
S=$W/copy/mneme/language-surface-1
P=$W/pristine-s1
T=$W/teeth
mkdir -p "$T"
restore() { rm -rf "$S"; cp -a "$P" "$S"; }
run_case() {
  local name="$1"; shift
  restore
  ( cd "$S" && "$@" )            # the mutation
  ( cd "$S" && ./run-surface1-candidate.sh ) > "$T/$name.txt" 2>&1
  local code=$?
  printf '%-42s runner exit = %s\n' "$name" "$code" | tee -a "$T/SUMMARY.txt"
  ( cd "$S" && cat RUN-EXITCODES.txt ) | sed 's/^/        /' >> "$T/SUMMARY.txt"
  ( cd "$S" && grep -h "checks passed\|REPRODUCTION-RESULT" RUN-SELFTEST.txt RUN-STUB-IMAGE.txt RUN-APPLICATION.txt RUN-REPRODUCTION.txt RUN-REPRODUCTION-II.txt 2>/dev/null ) | sed 's/^/        /' >> "$T/SUMMARY.txt"
  echo >> "$T/SUMMARY.txt"
}
: > "$T/SUMMARY.txt"
run_case T0-control true
# (a) truncate REPRODUCTION.lisp MID-FORM
run_case T1a-repro-truncated-mid-form bash -c 'head -160 errata-0.1/REPRODUCTION.lisp > t && mv t errata-0.1/REPRODUCTION.lisp'
# (a2) truncate REPRODUCTION.lisp at a CLEAN FORM BOUNDARY (before the summary)
run_case T1b-repro-truncated-clean-boundary bash -c 'head -295 errata-0.1/REPRODUCTION.lisp > t && mv t errata-0.1/REPRODUCTION.lisp'
# (b) sabotage a reproduction to CRASH before printing anything
run_case T2-repro-crashes-before-printing bash -c 'sed -i "s|^(defparameter \*verdicts\* .*|(error \"FOSSOR planted crash\")|" errata-0.2/REPRODUCTION-II.lisp'
# (c) tamper the canonical line: TRAILING SPACE
run_case T3a-canonical-line-trailing-space bash -c 'sed -i "s|REPRODUCTION-RESULT verdicts=~D expected=~D confirmed=~D~%|REPRODUCTION-RESULT verdicts=~D expected=~D confirmed=~D ~%|" errata-0.2/REPRODUCTION-II.lisp'
# (c2) tamper the canonical line: CHANGED LABEL
run_case T3b-canonical-line-renamed-label bash -c 'sed -i "s|REPRODUCTION-RESULT verdicts=|REPRODUCTION-RESULTS verdicts=|" errata-0.2/REPRODUCTION-II.lisp'
# (c3) tamper the canonical line: hard-code the PASSING line while a finding is CONFIRMED
run_case T3c-canonical-line-hardcoded-but-confirmed bash -c 'sed -i "s|(format t \"~%REPRODUCTION-RESULT verdicts=~D expected=~D confirmed=~D~%\"|(format t \"~%REPRODUCTION-RESULT verdicts=4 expected=4 confirmed=0~%\") (format t \"~*~*~*\"|" errata-0.2/REPRODUCTION-II.lisp'
# (d) make a SELFTEST check fail
run_case T4-selftest-check-fails bash -c 'sed -i "s|(= 75 (length \*declared\*))|(= 76 (length *declared*))|" surface1-selftest.lisp'
# (e) HOLE HUNT 1 — truncate the SELFTEST at a clean form boundary
run_case T5-selftest-truncated-clean-boundary bash -c 'head -266 surface1-selftest.lisp > t && mv t surface1-selftest.lisp && printf "\n(format t \"~%%== surface1-selftest: ~D checks passed / ~D failed ==~%%\" (- *checks* *failed*) *failed*)\n(when (plusp *failed*) (sb-ext:exit :code 1))\n" >> surface1-selftest.lisp'
# (e2) HOLE HUNT 2 — truncate the SELFTEST and DROP its summary/exit gate entirely
run_case T6-selftest-truncated-no-summary bash -c 'head -266 surface1-selftest.lisp > t && mv t surface1-selftest.lisp'
# (e3) HOLE HUNT 3 — delete every check from sections F..O of the SELFTEST
run_case T7-selftest-gutted bash -c 'head -354 surface1-selftest.lisp > t && mv t surface1-selftest.lisp && printf "\n(format t \"~%%== surface1-selftest: ~D checks passed / ~D failed ==~%%\" (- *checks* *failed*) *failed*)\n(when (plusp *failed*) (sb-ext:exit :code 1))\n" >> surface1-selftest.lisp'
# (e4) HOLE HUNT 4 — gut the STUB-IMAGE fixture down to nothing
run_case T8-stub-fixture-gutted bash -c 'head -30 STUB-IMAGE-FIXTURE.lisp > t && mv t STUB-IMAGE-FIXTURE.lisp'
# (e5) HOLE HUNT 5 — gut the APPLICATION down to nothing
run_case T9-application-gutted bash -c 'head -41 de-expansione-testata/APPLICATION.lisp > t && mv t de-expansione-testata/APPLICATION.lisp'
# (f) canonical line PRESENT but instrument exits NONZERO
run_case T10-canonical-line-then-nonzero-exit bash -c 'printf "\n(sb-ext:exit :code 3)\n" >> errata-0.1/REPRODUCTION.lisp'
restore
