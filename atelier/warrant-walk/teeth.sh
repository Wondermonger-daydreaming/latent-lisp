#!/usr/bin/env bash
# teeth.sh — WARRANT WALK /0: planted defects on COPIES must make the checker fail FOR THE INTENDED REASON.
# v2 (2026-09-08, Astra R3), v3 (P3): every plant's stdout+stderr and exit code are RETAINED under $TEETH_OUT (default:
# ./teeth-out beside the specimen — persistent); a plant counts as CAUGHT only when its intended failure line appears; any reader,
# compiler or runtime error in a plant's output is a HARNESS FAILURE (a crash is not a catch). Baseline must pass.
# Exit 0 iff every plant is caught for its reason, no harness failure, baseline green. The specimen is never edited.
set -u
HERE="$(cd "$(dirname "$0")" && pwd)"; T="$(mktemp -d)"
# v3 (2026-09-08, Astra P3): the DEFAULT output directory must survive the scratch cleanup. v2 defaulted to $T/out and the
# EXIT trap deleted it — the announced retention held only when TEETH_OUT was set explicitly (as it was in the recorded
# validation). Default now: $HERE/teeth-out (persistent, beside the specimen). The scratch copies in $T are still removed.
OUT="${TEETH_OUT:-$HERE/teeth-out}"; mkdir -p "$OUT"
case "$OUT" in "$T"/*) echo "refusing: TEETH_OUT lies inside the scratch dir that is deleted on exit"; exit 2;; esac
trap 'rm -rf "$T"' EXIT
cp "$HERE/expectations.lisp" "$HERE/expectations-1.lisp" "$T/"
plant() { python3 - "$T/warrant-walk.lisp" "$1" "$2" <<'PY'
import sys; p,old,new=sys.argv[1:]; s=open(p).read()
assert s.count(old)==1, "plant anchor not found exactly once"
open(p,'w').write(s.replace(old,new))
PY
}
CRASH_RE='debugger invoked|Unhandled|READ error|unhandled condition|is undefined|error during LOAD|COMPILER-ERROR'
fails=0
run_plant() {  # name, intended-regex (all lines must match somewhere), ...
  local name="$1"; shift; local log="$OUT/$name.txt"
  ( cd "$T" && sbcl --script warrant-walk.lisp --check ) >"$log" 2>&1; local rc=$?
  echo "exit=$rc" >> "$log"
  if grep -qE "$CRASH_RE" "$log"; then echo "$name: HARNESS FAILURE — the plant crashed the specimen (see $log)"; fails=$((fails+1)); return; fi
  if [ "$rc" -eq 0 ]; then echo "$name: NOT CAUGHT — checker exit 0 (see $log)"; fails=$((fails+1)); return; fi
  local missing=0; for re in "$@"; do grep -qE "$re" "$log" || { echo "$name: intended line '$re' ABSENT"; missing=1; }; done
  if [ "$missing" -eq 1 ]; then echo "$name: FAILED FOR THE WRONG REASON — nonzero exit without the intended failure (see $log)"; fails=$((fails+1)); return; fi
  echo "$name: caught for the intended reason (exit $rc; $log)"
}
# Plant A — hide the defect: the "defective" walker secretly calls the corrected one. Intended: DEFECT NOT EXPOSED + E2-D FAIL.
cp "$HERE/warrant-walk.lisp" "$T/"
plant '  "DEFECTIVE comparison walker. Labelled. Imports obligations from routes the conclusion never selected."
  (let ((acc (make-acc)))' '  "PLANTED"
  (return-from assess-defective (assess store claim :via via))
  (let ((acc (make-acc)))'
run_plant "plant-A-defect-hidden" '^  E2-D FAIL' 'DEFECT NOT EXPOSED'
# Plant C — silent substitution: on missing support under a selected route, take another route for the claim. Intended: E5 FAIL and E6 FAIL.
cp "$HERE/warrant-walk.lisp" "$T/"
plant '                (walk-route store via acc))
               (t (push' '                (walk-route store via acc)
                (when (acc-missing acc)
                  (let ((alt (find-if (lambda (r) (and (eq (getf r :kind) :route) (not (eq (getf r :id) via)))) (records-for store claim))))
                    (when alt (setf (acc-missing acc) nil) (walk-route store (getf alt :id) acc)))))
               (t (push'
run_plant "plant-C-silent-substitution" '^  E5 FAIL' '^  E6 FAIL'
# Plant D — the carried label repairs the result. Intended: E6 FAIL (result :established where :blocked is expected).
cp "$HERE/warrant-walk.lisp" "$T/"
plant '     (list :claim claim :route route :result word' '     (list :claim claim :route route :result (if (carried-testimony store) :established word)'
run_plant "plant-D-label-repairs-result" '^  E6 FAIL \(:RESULT :EXPECTED :BLOCKED :GOT :ESTABLISHED\)'
# Plant E (added with the repair) — drop the correspondence check at the leaf. Intended: E11 FAIL.
cp "$HERE/warrant-walk.lisp" "$T/"
plant '               ((not (eq (getf support :for) claim))                                 ; WW-R8' '               ((and nil (not (eq (getf support :for) claim)))                        ; PLANTED'
run_plant "plant-E-no-correspondence-check" '^  E11 FAIL' '^  E12 FAIL'
# Plant F (added with the repair) — never release completed routes (the d8c4d860 behaviour). Intended: E8 FAIL with :CYCLE.
cp "$HERE/warrant-walk.lisp" "$T/"
plant '    (when (member route-id (acc-completed acc))' '    (when (and nil (member route-id (acc-completed acc)))'
plant '      (return-from walk-route acc))
    (push route-id (acc-path acc))' '      (return-from walk-route acc))
    (when (member route-id (acc-visited acc)) (push (list route-id :on-path (reverse (acc-path acc))) (acc-cycle acc)) (return-from walk-route acc))
    (push route-id (acc-path acc))'
run_plant "plant-F-completed-never-released" '^  E8 FAIL \(:RESULT :EXPECTED :ESTABLISHED :GOT :CYCLE\)'
# Green baseline — the unplanted specimen must PASS and must not crash, or the reds above mean nothing.
cp "$HERE/warrant-walk.lisp" "$T/"
( cd "$T" && sbcl --script warrant-walk.lisp --check ) >"$OUT/baseline.txt" 2>&1; rc=$?; echo "exit=$rc" >> "$OUT/baseline.txt"
if [ "$rc" -eq 0 ] && ! grep -qE "$CRASH_RE" "$OUT/baseline.txt" && grep -qE 'PASS 15/15' "$OUT/baseline.txt"; then echo "baseline (no plant): PASS 15/15, no crash"; else echo "baseline (no plant): FAIL — teeth void ($OUT/baseline.txt)"; fails=$((fails+1)); fi
echo "teeth: $fails failure(s); outputs retained under $OUT"; exit $fails
