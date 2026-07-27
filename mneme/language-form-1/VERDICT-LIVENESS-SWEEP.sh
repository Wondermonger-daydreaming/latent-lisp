#!/usr/bin/env bash
# ============================================================================
#  VERDICT-LIVENESS-SWEEP.sh  --  form1-selftest.lisp
#  TITHE, 2026-07-27.  Re-run with one command:
#
#      bash VERDICT-LIVENESS-SWEEP.sh
#
#  Writes VERDICT-LIVENESS-SWEEP-RUN.txt beside itself.  Modifies nothing else
#  in this directory, and nothing at all outside it.
# ============================================================================
#
#  WHAT THIS SWEEP ESTABLISHES, AND IT IS ONE SENTENCE:
#
#      every rendered verdict is connected to the suite's failure result.
#
#  WHAT IT DOES NOT ESTABLISH:
#
#      It does NOT establish that a check's predicate correctly measures its
#      label.  A check whose predicate is a tautology -- (check (or x t) "...")
#      -- is forced red by this instrument exactly as easily as a sound one,
#      and still tells you nothing whatever about the world.  BOTH HOLLOW
#      CHECKS THIS SUITE HAS ALREADY SHIPPED WOULD HAVE BEEN FORCED RED
#      SUCCESSFULLY BY THIS INSTRUMENT.  The sweep catches DISCONNECTED
#      verdicts.  It does not catch VACUOUS ones.  Semantic mutation evidence
#      -- the five claim-directed planted faults in the suite's Section M --
#      remains the only thing that speaks to whether a tooth measures its
#      label, and this sweep does not replace it, does not reduce the need for
#      it, and does not stand in for it.  A reader who takes a clean sweep for
#      a proof of soundness has been misled.
#
#  METHOD.  The suite's own harness is
#
#      (defun check (condition label)
#        (incf *checks*)
#        (if condition ...ok... ...FAIL...))
#
#  so the sweep injects, immediately after (incf *checks*), a single clause:
#  if *checks* equals the forced index, treat CONDITION as NIL.  CONDITION is
#  an already-evaluated argument, so THE FIXTURE STILL RUNS EXACTLY AS IT DOES
#  NOW -- every side effect, every ledger push, every shim install and restore.
#  Only the REPORTED VERDICT is flipped.  No fixture, and no other line of the
#  suite, is altered.
#
#  ISOLATION.  One fresh SBCL process per index.  The suite mutates globals and
#  rebinds fdefinitions; sweeping several indices inside one image would let one
#  index's residue contaminate the next, and the sweep would then be measuring
#  contamination rather than liveness.
#
#  THE ORIGINAL FILES ARE NOT TOUCHED.  The injected copies are built inside a
#  temporary rig directory whose other entries are SYMLINKS back to this
#  directory, so form1.lisp, package.lisp, de-forma-petente/ and the frozen
#  sibling slices are read through their real paths and are never written.  The
#  rig is deleted on exit.
#
#  THIS INSTRUMENT IS ITSELF TEETH-CHECKED BEFORE IT IS BELIEVED.  A sweep that
#  reports no survivors has, by construction, never once rendered the SURVIVED
#  verdict -- and an unfired gate is untested, not passing.  So two negative
#  controls run first, each a planted fault the adjudicator MUST catch:
#    NC-A (deaf)   the injection is made blind, so the forced index stays green
#                  and the process exits 0.  Must classify SURVIVED.
#    NC-B (decoy)  a DIFFERENT index is forced red, so the process exits
#                  nonzero while the requested index still prints ok.  Must
#                  classify SURVIVED.  This is the limb that stops a nonzero
#                  exit alone from being read as a tooth having bitten.
#  If either control fails to produce SURVIVED, the sweep aborts: the adjudi-
#  cator would be incapable of reporting the one finding it exists to report.
#
#  CLASSIFICATION, held precisely:
#    EXACT EXPECTED TOOTH REACHED  index N printed FAIL, exit was nonzero, no
#                                  other index went red, and all N-1 earlier
#                                  verdicts still printed with their own labels
#                                  under contiguous numbering.
#    DIED ELSEWHERE                the run failed, but not cleanly at index N.
#    SURVIVED                      exit was 0, or index N still printed ok.
#                                  THIS IS THE FINDING.
#    SWEEP HARNESS FAILURE         the instrument broke on that index.
# ============================================================================

set -u

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SUBJECT="$HERE/form1-selftest.lisp"
OUT="$HERE/VERDICT-LIVENESS-SWEEP-RUN.txt"
JOBS="${TITHE_JOBS:-8}"

sweep_one() {
  local n="$1"
  ( cd "$RIG" && TITHE_FORCE_INDEX="$n" sbcl --non-interactive --load "$COPY" ) \
      > "$RUNS/$n.out" 2>&1
  echo "$?" > "$RUNS/$n.exit"
}
export -f sweep_one

main() {

WORK="$(mktemp -d "${TMPDIR:-/tmp}/tithe-sweep-XXXXXX")"
trap 'rm -rf "$WORK"' EXIT
RIG="$WORK/rig"
mkdir -p "$RIG"
export RIG

cat <<'BANNER'
============================================================================
 VERDICT-LIVENESS-SWEEP  --  form1-selftest.lisp        (TITHE, 2026-07-27)
============================================================================

 WHAT THIS SWEEP ESTABLISHES, AND IT IS ONE SENTENCE:

     every rendered verdict is connected to the suite's failure result.

 WHAT IT DOES NOT ESTABLISH:

     It does NOT establish that a check's predicate correctly measures its
     label.  A check whose predicate is a tautology -- (check (or x t) "...")
     -- is forced red by this instrument exactly as easily as a sound one, and
     still tells you nothing whatever about the world.  BOTH HOLLOW CHECKS
     THIS SUITE HAS ALREADY SHIPPED WOULD HAVE BEEN FORCED RED SUCCESSFULLY
     BY THIS INSTRUMENT.  The sweep catches DISCONNECTED verdicts.  It does
     not catch VACUOUS ones.  Semantic mutation evidence -- the five
     claim-directed planted faults in the suite's Section M -- remains the
     only thing that speaks to whether a tooth measures its label, and this
     sweep does not replace it, does not reduce the need for it, and does not
     stand in for it.  A reader who takes a clean sweep for a proof of
     soundness has been misled.

----------------------------------------------------------------------------
BANNER
echo " run started: $(date -u '+%Y-%m-%d %H:%M:%S UTC')"
echo

# --- 0. operation-check the toolchain --------------------------------------
SBCL_VERSION="$(sbcl --non-interactive --eval '(progn (princ (lisp-implementation-version)) (terpri))' 2>/dev/null | tail -1 | tr -d '[:space:]')"
echo "[0] SBCL operation-check, through the wrapper actually on PATH: ${SBCL_VERSION}"
if [ "$SBCL_VERSION" != "2.4.6" ]; then
  echo "    STOP: expected 2.4.6.  Refusing to sweep on an unverified toolchain."
  return 2
fi
echo "    sbcl   : $(command -v sbcl)"
echo "    subject: $SUBJECT"
echo "    sha256 : $(sha256sum "$SUBJECT" | cut -d' ' -f1)"
echo

# --- 1. pristine baseline ---------------------------------------------------
echo "[1] PRISTINE BASELINE -- the unmodified suite, run as the chair runs it."
( cd "$HERE" && sbcl --non-interactive --load form1-selftest.lisp ) > "$WORK/pristine.txt" 2>&1
PRISTINE_EXIT=$?
PRISTINE_TAIL="$(grep -E '^== form1-selftest:' "$WORK/pristine.txt" | tail -1)"
VERDICT_COUNT="$(grep -cE '^  \[[0-9]+\] (ok|FAIL) ' "$WORK/pristine.txt")"
echo "    exit=$PRISTINE_EXIT   $PRISTINE_TAIL"
echo "    verdict lines rendered: $VERDICT_COUNT"
if [ "$PRISTINE_EXIT" != "0" ] || ! echo "$PRISTINE_TAIL" | grep -q '/ 0 failed =='; then
  echo "    STOP: the suite is not green.  The chair may still be editing."
  return 3
fi
echo

# --- 2. build the rig and the three injected copies -------------------------
for f in "$HERE"/*; do
  b="$(basename "$f")"
  [ "$b" = "form1-selftest.lisp" ] && continue
  ln -s "$f" "$RIG/$b"
done

cat > "$WORK/inject.py" <<'PYEOF'
import sys, io
src_path, dst_path, mode = sys.argv[1], sys.argv[2], sys.argv[3]
text = io.open(src_path, encoding='utf-8').read()

ANCHOR = "(defun check (condition label)\n  (incf *checks*)\n  (if condition\n"
if text.count(ANCHOR) != 1:
    sys.stderr.write("TITHE-HARNESS-FAILURE: CHECK's definition is not the shape this "
                     "sweep was written against (%d matches).  Refusing to inject blind.\n"
                     % text.count(ANCHOR))
    sys.exit(9)

TEST = {
    # the real instrument: flip the verdict at the requested index
    'live':  '(= *checks* *tithe-force-index*)',
    # NEGATIVE CONTROL A -- deaf: the clause can never fire
    'deaf':  '(= *checks* -1)',
    # NEGATIVE CONTROL B -- decoy: force some OTHER index red instead
    'decoy': '(= *checks* (if (= *tithe-force-index* 1) 2 1))',
}[mode]

PREAMBLE = """;;; ---- TITHE LIVENESS-SWEEP INJECTION (generated; NOT part of the suite) ----
;;; MODE: %s
;;; Reads TITHE_FORCE_INDEX from the environment.  When it is unset or empty
;;; this file is behaviourally identical to form1-selftest.lisp -- an identity
;;; the CONTROL run proves by byte-comparison before any sweep row is believed.
(defparameter *tithe-force-index*
  (let ((raw (sb-ext:posix-getenv "TITHE_FORCE_INDEX")))
    (and raw (plusp (length raw)) (parse-integer raw))))

""" % mode

REPLACEMENT = """(defun check (condition label)
  (incf *checks*)
  ;; TITHE injection: flip the REPORTED VERDICT only.  CONDITION was already
  ;; evaluated by the caller, so the fixture ran in full and unaltered.
  (when (and *tithe-force-index* %s)
    (setf condition nil))
  (if condition
""" % TEST

io.open(dst_path, 'w', encoding='utf-8').write(text.replace(ANCHOR, PREAMBLE + REPLACEMENT, 1))
PYEOF

for mode in live deaf decoy; do
  python3 "$WORK/inject.py" "$SUBJECT" "$RIG/sweep-$mode.lisp" "$mode" || {
    echo "[2] STOP: injection generator refused or failed (mode=$mode)."; return 4; }
done
echo "[2] INJECTED COPIES built: sweep-live.lisp, sweep-deaf.lisp, sweep-decoy.lisp."
echo "    The live instrument in FULL -- shown, not described:"
echo
diff -u "$SUBJECT" "$RIG/sweep-live.lisp" | sed 's/^/      /'
echo
echo "    The two negative controls differ from it in ONE token each:"
diff "$RIG/sweep-live.lisp" "$RIG/sweep-deaf.lisp"  | sed 's/^/      NC-A(deaf)  /'
diff "$RIG/sweep-live.lisp" "$RIG/sweep-decoy.lisp" | sed 's/^/      NC-B(decoy) /'
echo

# --- the adjudicator, written once and used for the controls and the sweep --
cat > "$WORK/adjudicate.py" <<'PYEOF'
import sys, os, re, json

pristine_path, runs_dir, total, which = sys.argv[1], sys.argv[2], int(sys.argv[3]), sys.argv[4]
indices = list(range(1, total + 1)) if which == 'all' else [int(x) for x in which.split(',')]
report = (sys.argv[5] == 'full') if len(sys.argv) > 5 else True

LINE = re.compile(r'^  \[(\d+)\] (ok|FAIL) (.*)$')

def parse(path):
    rows = []
    try:
        with open(path, encoding='utf-8', errors='replace') as fh:
            for line in fh:
                m = LINE.match(line.rstrip('\n'))
                if m:
                    rows.append((int(m.group(1)), m.group(2), m.group(3)))
    except OSError:
        return None
    return rows

labels = {i: lab for (i, _s, lab) in parse(pristine_path)}

EXACT, DIED, SURVIVED, HARNESS = [], [], [], []
forced = 0

for n in indices:
    out = os.path.join(runs_dir, '%d.out' % n)
    exf = os.path.join(runs_dir, '%d.exit' % n)
    if not (os.path.exists(out) and os.path.exists(exf)):
        HARNESS.append((n, labels.get(n, '<no label>'), 'no run artefact produced'))
        continue
    try:
        code = int(open(exf).read().strip())
    except Exception as exc:
        HARNESS.append((n, labels.get(n, '<no label>'), 'unreadable exit code (%s)' % exc))
        continue
    rows = parse(out)
    if rows is None:
        HARNESS.append((n, labels.get(n, '<no label>'), 'unreadable run output'))
        continue

    idx = [r[0] for r in rows]
    status = {r[0]: r[1] for r in rows}
    fails = sorted(i for i in idx if status[i] == 'FAIL')
    contiguous = (idx == list(range(1, len(idx) + 1)))
    complete = (len(rows) == total)
    n_status = status.get(n)

    # SURVIVED -- the forced verdict is not connected to the failure result.
    if code == 0 or n_status == 'ok':
        SURVIVED.append((n, labels.get(n, '<no label>'),
                         'exit=%d, index %d reported %s%s'
                         % (code, n, n_status or 'NOTHING',
                            (', run went red at %s instead'
                             % ', '.join(str(i) for i in fails)) if fails else '')))
        continue

    if n_status == 'FAIL':
        forced += 1

    if (n_status == 'FAIL' and code != 0 and fails == [n] and contiguous and complete):
        EXACT.append(n)
        continue

    why = []
    if n_status is None:
        why.append('index %d never printed (run rendered %d of %d verdicts)' % (n, len(rows), total))
    if not complete:
        why.append('rendered %d verdicts, expected %d' % (len(rows), total))
    if not contiguous:
        why.append('numbering not contiguous 1..%d' % len(rows))
    collateral = [i for i in fails if i != n]
    if collateral:
        why.append('collateral FAIL at ' + ', '.join(str(i) for i in collateral))
    if code == 0:
        why.append('exit 0')
    DIED.append((n, labels.get(n, '<no label>'), '; '.join(why) or 'unclassified'))

if not report:
    # control mode: emit a one-line machine summary and a per-index line
    for n, lab, why in SURVIVED:
        print("      [%03d] SURVIVED  -- %s" % (n, why))
    for n in EXACT:
        print("      [%03d] EXACT     -- forced red at its own index" % n)
    for n, lab, why in DIED:
        print("      [%03d] DIED-ELSEWHERE -- %s" % (n, why))
    for n, lab, why in HARNESS:
        print("      [%03d] HARNESS-FAILURE -- %s" % (n, why))
    print("SUMMARY %s" % json.dumps({'survived': len(SURVIVED), 'exact': len(EXACT),
                                     'died': len(DIED), 'harness': len(HARNESS),
                                     'n': len(indices)}))
    sys.exit(0)

print("    verdict count                 %d" % total)
print("    verdicts successfully forced  %d" % forced)
print("    exact expected tooth reached  %d" % len(EXACT))
print("    died elsewhere                %d" % len(DIED))
print("    sweep harness failure         %d" % len(HARNESS))
print("    survived                      %d" % len(SURVIVED))
print()

def dump(title, rows, note):
    print("    " + "-" * 72)
    print("    %s  (%d)" % (title, len(rows)))
    for line in note:
        print("    %s" % line)
    print()
    if not rows:
        print("      (none)")
    else:
        for n, lab, why in rows:
            print("      [%03d] %s" % (n, why))
            print("            label: %s" % lab)
    print()

dump("SURVIVED", SURVIVED,
     ["A verdict that cannot be forced red is NOT CONNECTED to the suite's",
      "failure result.  This is the finding this instrument exists to produce."])
dump("DIED ELSEWHERE", DIED,
     ["The run failed, but not cleanly at the forced index.  NOT folded into",
      "success."])
dump("SWEEP HARNESS FAILURE", HARNESS,
     ["The instrument broke on these indices.  Reported, not hidden."])

print("    " + "-" * 72)
print("    FULL TABLE -- every index, its outcome, its label")
print()
outcome = {}
for n in EXACT: outcome[n] = 'EXACT'
for r in DIED: outcome[r[0]] = 'DIED-ELSEWHERE'
for r in SURVIVED: outcome[r[0]] = 'SURVIVED'
for r in HARNESS: outcome[r[0]] = 'HARNESS-FAILURE'
for n in range(1, total + 1):
    lab = labels.get(n, '<no label>')
    if len(lab) > 110:
        lab = lab[:107] + '...'
    print("      [%03d] %-15s %s" % (n, outcome.get(n, '?'), lab))
print()
print("    " + "-" * 72)
if SURVIVED or DIED or HARNESS:
    print("    SWEEP RESULT: NOT CLEAN.  See the sections above.")
else:
    print("    SWEEP RESULT: each of the %d rendered verdicts was forced red at its" % total)
    print("    own index, with nonzero process exit, with no collateral red, and with")
    print("    every other verdict still printed under contiguous numbering.")
print()
print("    THIS LICENSES EXACTLY ONE SENTENCE: every rendered verdict is connected")
print("    to the suite's failure result.")
print()
print("    IT LICENSES NOTHING ABOUT WHETHER ANY PREDICATE MEASURES ITS LABEL.  A")
print("    tautological check -- (check (or x t) \"...\") -- is forced red by this")
print("    instrument exactly as easily as a sound one.  Both hollow checks this")
print("    suite already shipped would have been forced red successfully here.  The")
print("    sweep catches DISCONNECTED verdicts; it does not catch VACUOUS ones.")
print("    Semantic mutation evidence -- the five claim-directed planted faults in")
print("    Section M -- remains the only thing that speaks to whether a tooth")
print("    measures its label, and this sweep does not replace it.")
sys.exit(1 if (SURVIVED or DIED or HARNESS) else 0)
PYEOF

# --- 3. THE CONTROL.  NOT OPTIONAL. ----------------------------------------
echo "[3] CONTROL -- the live injected copy, with NO index forced."
echo "    If the harness changes the subject, every sweep row below would be"
echo "    measuring the instrument instead of the suite.  So this is proved."
( cd "$RIG" && env -u TITHE_FORCE_INDEX sbcl --non-interactive --load sweep-live.lisp ) \
    > "$WORK/control.txt" 2>&1
CONTROL_EXIT=$?
echo "    exit=$CONTROL_EXIT   $(grep -E '^== form1-selftest:' "$WORK/control.txt" | tail -1)"
echo "    verdict lines rendered: $(grep -cE '^  \[[0-9]+\] (ok|FAIL) ' "$WORK/control.txt")"
if diff -q "$WORK/pristine.txt" "$WORK/control.txt" >/dev/null 2>&1; then
  echo "    BYTE-IDENTICAL to the pristine baseline (diff empty)."
  echo "      pristine sha256: $(sha256sum "$WORK/pristine.txt" | cut -d' ' -f1)"
  echo "      control  sha256: $(sha256sum "$WORK/control.txt"  | cut -d' ' -f1)"
  CONTROL_OK=1
else
  echo "    *** CONTROL FAILED -- output differs from the pristine baseline ***"
  diff -u "$WORK/pristine.txt" "$WORK/control.txt" | head -80 | sed 's/^/      /'
  CONTROL_OK=0
fi
if [ "$CONTROL_EXIT" != "0" ] || [ "$CONTROL_OK" != "1" ]; then
  echo
  echo "    STOP.  The harness changes the subject.  No sweep row would be"
  echo "    trustworthy.  Fix the harness before sweeping."
  return 5
fi
echo "    CONTROL PASSED: exit 0, ${VERDICT_COUNT} checks, 0 failed, byte-identical"
echo "    to the pristine suite.  The instrument is transparent to the subject."
echo

# --- 3b/3c. TEETH-CHECK THE ADJUDICATOR -------------------------------------
SAMPLE="1,$((VERDICT_COUNT / 2)),$VERDICT_COUNT"
echo "[3b] NEGATIVE CONTROLS -- planted faults the adjudicator MUST call SURVIVED."
echo "     A sweep reporting no survivors has never once rendered that verdict,"
echo "     and an unfired gate is untested, not passing.  Sample indices: $SAMPLE"
echo

NC_OK=1
for nc in deaf decoy; do
  case "$nc" in
    deaf)  desc="NC-A (deaf)  -- injection blind; forced index stays green, exit 0" ;;
    decoy) desc="NC-B (decoy) -- a DIFFERENT index forced red; exit nonzero while the"$'\n'"                     requested index still prints ok.  This is the limb that"$'\n'"                     stops a nonzero exit alone from reading as a bite." ;;
  esac
  echo "     $desc"
  RUNS="$WORK/nc-$nc"; mkdir -p "$RUNS"; export RUNS
  COPY="sweep-$nc.lisp"; export COPY
  echo "$SAMPLE" | tr ',' '\n' | xargs -P "$JOBS" -I{} bash -c 'sweep_one {}'
  NC_OUT="$(python3 "$WORK/adjudicate.py" "$WORK/pristine.txt" "$RUNS" "$VERDICT_COUNT" "$SAMPLE" brief)"
  echo "$NC_OUT" | grep -v '^SUMMARY'
  NC_SUM="$(echo "$NC_OUT" | grep '^SUMMARY' | cut -d' ' -f2-)"
  NC_N="$(python3 -c 'import json,sys; d=json.loads(sys.argv[1]); print(d["n"])' "$NC_SUM")"
  NC_S="$(python3 -c 'import json,sys; d=json.loads(sys.argv[1]); print(d["survived"])' "$NC_SUM")"
  if [ "$NC_S" = "$NC_N" ]; then
    echo "     ==> CONTROL FIRED: $NC_S/$NC_N classified SURVIVED, as required."
  else
    echo "     ==> *** CONTROL DID NOT FIRE: only $NC_S/$NC_N classified SURVIVED. ***"
    echo "         The adjudicator cannot report the finding it exists to report."
    NC_OK=0
  fi
  echo
done
if [ "$NC_OK" != "1" ]; then
  echo "     STOP.  The adjudicator is blind.  A clean sweep from a blind"
  echo "     adjudicator is a green banner on a rumour.  Fix it before sweeping."
  return 6
fi
echo "     Both negative controls fired.  The SURVIVED verdict is REACHABLE, so a"
echo "     sweep that reports zero survivors is reporting an observation, not a"
echo "     gate that never ran."
echo

# --- 4. the sweep -----------------------------------------------------------
RUNS="$WORK/runs"; mkdir -p "$RUNS"; export RUNS
COPY="sweep-live.lisp"; export COPY
echo "[4] SWEEP -- indices 1..${VERDICT_COUNT}, one FRESH SBCL process each, ${JOBS} concurrent."
SWEEP_START=$(date +%s)
seq 1 "$VERDICT_COUNT" | xargs -P "$JOBS" -I{} bash -c 'sweep_one {}'
SWEEP_END=$(date +%s)
echo "    $((SWEEP_END - SWEEP_START))s wall for ${VERDICT_COUNT} independent processes."
echo

# --- 5. adjudication --------------------------------------------------------
echo "[5] ADJUDICATION"
echo
python3 "$WORK/adjudicate.py" "$WORK/pristine.txt" "$RUNS" "$VERDICT_COUNT" all full
ADJ=$?
echo
echo "============================================================================"
echo " END VERDICT-LIVENESS-SWEEP   (adjudication exit ${ADJ}: 0 = clean sweep)"
echo "============================================================================"
return $ADJ

}

main 2>&1 | tee "$OUT"
exit "${PIPESTATUS[0]}"
