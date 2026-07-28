#!/usr/bin/env bash
W=/tmp/claude-1000/-home-gauss-Desktop-Claude-Code-Lab/d214ea40-d602-4f0d-b684-e6f5fddf4447/scratchpad/surface1-audit/probes/FOSSOR
S=$W/copy/mneme/language-surface-1; P=$W/pristine-s1; T=$W/teeth
restore() { rm -rf "$S"; cp -a "$P" "$S"; }
run_case() { local name="$1"; shift; restore; ( cd "$S" && "$@" )
  ( cd "$S" && ./run-surface1-candidate.sh ) > "$T/$name.txt" 2>&1; local c=$?
  printf '%-46s runner exit = %s\n' "$name" "$c" | tee -a "$T/SUMMARY2.txt"
  ( cd "$S" && cat RUN-EXITCODES.txt ) | sed 's/^/        /' >> "$T/SUMMARY2.txt"
  ( cd "$S" && grep -h "checks passed\|REPRODUCTION-RESULT\|CONFIRMED" RUN-SELFTEST.txt RUN-STUB-IMAGE.txt RUN-APPLICATION.txt RUN-REPRODUCTION.txt RUN-REPRODUCTION-II.txt 2>/dev/null | head -12 ) | sed 's/^/        /' >> "$T/SUMMARY2.txt"
  echo >> "$T/SUMMARY2.txt"; }
: > "$T/SUMMARY2.txt"
# (c) canonical line with a TRAILING SPACE — correct sed this time
run_case T3a2-canonical-line-trailing-space bash -c 'sed -i "s|REPRODUCTION-RESULT verdicts=~D expected=4 confirmed=~D~%|REPRODUCTION-RESULT verdicts=~D expected=4 confirmed=~D ~%|" errata-0.2/REPRODUCTION-II.lisp && grep -n "REPRODUCTION-RESULT" errata-0.2/REPRODUCTION-II.lisp'
# stub fixture truncated at a CLEAN form boundary (line 28 ends a form)
run_case T8b-stub-truncated-clean-boundary bash -c 'head -28 STUB-IMAGE-FIXTURE.lisp > t && mv t STUB-IMAGE-FIXTURE.lisp'
# application truncated at a clean boundary, summary+gate re-appended
run_case T11-application-truncated-with-summary bash -c 'head -47 de-expansione-testata/APPLICATION.lisp > t && mv t de-expansione-testata/APPLICATION.lisp && printf "\n(format t \"~%%== de-expansione-testata: ~D checks passed / ~D failed ==~%%\" (- *checks* *failed*) *failed*)\n(when (plusp *failed*) (sb-ext:exit :code 1))\n" >> de-expansione-testata/APPLICATION.lisp'
# THE SUBJECT REGRESSION: re-open the errata 0.2 home-package hole in surface1.lisp
run_case T12-subject-regressed-home-package-guard bash -c "sed -i \"s|(unless (and (member status '(:internal :external))|(unless (and t|; s|(eq (symbol-package symbol) package))|t)|\" surface1.lisp && sed -n '489,494p' surface1.lisp"
restore
