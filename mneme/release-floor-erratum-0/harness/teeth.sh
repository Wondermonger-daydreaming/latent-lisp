#!/usr/bin/env bash
# teeth.sh — RELEASE FLOOR ERRATUM /0, phase 2.  Sol I §IV: twelve teeth, each OBSERVED
# FIRING against the REPAIRED aggregator.
#
#   bash teeth.sh <clone subject root> <out dir>
#
# Every tooth drives the REAL repaired mneme/verify-release.sh — never a reimplementation.
# Teeth 1-11 use a REDUCED AUTHORIZED TABLE (five rows taken verbatim from the real table;
# tooth 10 adds one synthetic lane, declared) so that each tooth costs seconds instead of
# ninety minutes.  mkvariant.sh PROVES the reduction is confined to the GATES heredoc body
# and the two AUTHORIZED_GATES_* constants: the classifier, the materializer, the identity
# check, the cleanliness probes, the lane derivation and the terminal conjunction under test
# are byte-identical to the full-table script.  Tooth 12 is the genuine full 112-row floor
# and is run separately (phase 3).
#
# Teeth that need a FAILING git or a MUTILATING tar use a PATH-shadowed wrapper; each
# wrapper's source is copied into its tooth transcript, so the mechanism is on the record.
set -uo pipefail
PT="${1:?clone subject root}"; OUT="${2:?out dir}"
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
mkdir -p "$OUT" "$OUT/park"
PRISTINE="$OUT/verify-release.PRISTINE.sh"
cp "$PT/mneme/verify-release.sh" "$PRISTINE"
CAND="$(git -C "$PT" rev-parse HEAD)"
SUMMARY="$OUT/SUMMARY.txt"
: > "$SUMMARY"

banner() {  # banner <file> <n> <title> <sol-item> <mechanism> <table>
  {
    echo "==========================================================================="
    echo " ERRATUM /0 TOOTH $2 — $3"
    echo "==========================================================================="
    echo " Sol I §IV item : $4"
    echo " subject        : the REAL repaired mneme/verify-release.sh at candidate $CAND"
    echo " venue          : $PT  (history-complete clone, detached at the candidate)"
    echo " table          : $6"
    echo " mechanism      : $5"
    echo " date           : $(date -u +%FT%TZ)"
    echo
  } > "$1"
}

# generate the reduced variant into the plant tree; append the confinement proof
variant() {  # variant <transcript> <rows file>
  echo "--- mkvariant confinement proof ---" >> "$1"
  MKVARIANT_ALLOW_SYNTHETIC="${ALLOW_SYNTH:-0}" \
    bash "$HERE/mkvariant.sh" "$PRISTINE" "$2" "$PT/mneme/verify-release.sh" >> "$1" 2>&1
  echo >> "$1"
}

fire() {  # fire <transcript> [extra PATH dir]
  local t="$1" extra="${2:-}"
  echo "=== RUN ===" >> "$t"
  if [ -n "$extra" ]; then
    ( cd "$PT" && PATH="$extra:$PATH" bash mneme/verify-release.sh ) >> "$t" 2>&1
  else
    ( cd "$PT" && bash mneme/verify-release.sh ) >> "$t" 2>&1
  fi
  local rc=$?
  echo "=== aggregator exit: $rc" >> "$t"
  echo "$rc"
}

finish() {  # finish <n> <transcript> <expectation> <grep-proof-regex>
  cp "$PRISTINE" "$PT/mneme/verify-release.sh"
  local n="$2" ; :
  local t="$2" want="$3" re="$4"
  local res; res="$(grep -m1 '^FLOOR RESULT' "$t")"
  local proof=FAILED
  grep -qE "$re" "$t" && proof=OBSERVED
  {
    echo
    echo "--- VERDICT ---"
    echo " expected  : $want"
    echo " terminal  : $res"
    echo " proof re  : $re"
    echo " firing    : $proof"
  } >> "$t"
  printf 'tooth %-2s %-11s %s\n' "$1" "$proof" "$res" | tee -a "$SUMMARY"
  # the plant tree must be back to (pristine script + nothing else) between teeth
  local dirt; dirt="$(git -C "$PT" status --porcelain | grep -v 'mneme/verify-release.sh' | grep -v 'release-floor-erratum-0' | head -5)"
  if [ -n "$dirt" ]; then echo "!! PLANT TREE NOT RESTORED after tooth $1:"; printf '%s\n' "$dirt"; fi
}

R="$HERE/rows-reduced.txt"
RED5="5 REAL rows of the real table (reduction proven confined below)"

# ---------------------------------------------------------------- tooth 1
T="$OUT/01-missing-python-gate.transcript.txt"
banner "$T" 1 "missing Python gate file -> terminal non-pass, not blocked" \
  "1. missing Python gate file -> terminal non-pass, not blocked" \
  "row [001]'s script mneme/atelier/static-check.py is moved out of the tree; python3 exits 2" "$RED5"
variant "$T" "$R"
mv "$PT/mneme/atelier/static-check.py" "$OUT/park/static-check.py"
fire "$T" >/dev/null
mv "$OUT/park/static-check.py" "$PT/mneme/atelier/static-check.py"
finish 1 "$T" "FAIL; row [001] FAIL (exit 2), never BLOCKED" '^      -> FAIL \(exit 2\)'

# ---------------------------------------------------------------- tooth 2
T="$OUT/02-python-argparse-exit2.transcript.txt"
banner "$T" 2 "Python argparse exit 2 -> terminal non-pass" \
  "2. Python argparse exit 2 -> terminal non-pass" \
  "row [002]'s script renames its 'verify' subcommand, so argparse rejects the gate's argument with exit 2" "$RED5"
variant "$T" "$R"
F="$PT/mneme/lci0/shared/fixture_package.py"
cp "$F" "$OUT/park/fixture_package.py"
sed -i 's/subparsers.add_parser("verify")/subparsers.add_parser("verify-RENAMED-BY-TOOTH-2")/' "$F"
fire "$T" >/dev/null
cp "$OUT/park/fixture_package.py" "$F"
finish 2 "$T" "FAIL; row [002] FAIL (exit 2)" '^      -> FAIL \(exit 2\)'

# ---------------------------------------------------------------- tooth 3
T="$OUT/03-bash-syntax-exit2.transcript.txt"
banner "$T" 3 "Bash syntax exit 2 -> terminal non-pass" \
  "3. Bash syntax exit 2 -> terminal non-pass" \
  "a syntax error is planted at line 2 of row [003]'s script subject-digest.sh; bash exits 2 at parse time" "$RED5"
variant "$T" "$R"
F="$PT/mneme/language-surface-1/errata-0.3/subject-digest.sh"
cp "$F" "$OUT/park/subject-digest.sh"
sed -i '1a if [ ; then' "$F"
fire "$T" >/dev/null
cp "$OUT/park/subject-digest.sh" "$F"
finish 3 "$T" "FAIL; row [003] FAIL (exit 2)" '^      -> FAIL \(exit 2\)'

# ---------------------------------------------------------------- tooth 4
T="$OUT/04-hard-refuser-manifest-removed.transcript.txt"
banner "$T" 4 "an existing hard-refuser with its internal manifest removed -> terminal non-pass" \
  "4. one existing hard-refuser with its internal manifest removed -> terminal non-pass" \
  "errata-0.3/SUBJECT-MANIFEST.txt is moved aside; subject-digest.sh prints 'HARD FAIL — manifest absent' and exits 2. THIS IS PRE-CURE CONTROL B's PLANT, RE-FIRED AFTER THE CURE." "$RED5"
variant "$T" "$R"
mv "$PT/mneme/language-surface-1/errata-0.3/SUBJECT-MANIFEST.txt" "$OUT/park/SUBJECT-MANIFEST.txt"
fire "$T" >/dev/null
mv "$OUT/park/SUBJECT-MANIFEST.txt" "$PT/mneme/language-surface-1/errata-0.3/SUBJECT-MANIFEST.txt"
finish 4 "$T" "FAIL; row [003] FAIL (exit 2) with the leaf's own refusal in the log" 'HARD FAIL — manifest absent'

# ---------------------------------------------------------------- tooth 5
T="$OUT/05-missing-declared-cwd.transcript.txt"
banner "$T" 5 "missing declared CWD -> distinct CWD failure with a nonempty diagnosis" \
  "5. missing declared CWD -> distinct CWD failure with nonempty diagnosis" \
  "the whole directory row [003] declares as its cwd (mneme/language-surface-1/errata-0.3) is moved aside" "$RED5"
variant "$T" "$R"
mv "$PT/mneme/language-surface-1/errata-0.3" "$OUT/park/errata-0.3"
fire "$T" >/dev/null
mv "$OUT/park/errata-0.3" "$PT/mneme/language-surface-1/errata-0.3"
finish 5 "$T" "FAIL; row [003] GATE-CWD-ABSENT, log nonempty and names the directory" 'GATE-CWD-ABSENT'

# ---------------------------------------------------------------- wrappers for 6-9
mkdir -p "$OUT/bin-archive-fail" "$OUT/bin-tar-mutilate" "$OUT/bin-status-fail-1" "$OUT/bin-status-fail-2"
REALGIT="$(command -v git)"; REALTAR="$(command -v tar)"
cat > "$OUT/bin-archive-fail/git" <<WRAP
#!/usr/bin/env bash
# tooth 6: pass every git verb through to the real git EXCEPT 'archive', which fails.
for a in "\$@"; do [ "\$a" = archive ] && { echo "tooth-6: simulated archive failure" >&2; exit 1; }; done
exec "$REALGIT" "\$@"
WRAP
cat > "$OUT/bin-tar-mutilate/tar" <<WRAP
#!/usr/bin/env bash
# tooth 7: run the real tar, then silently delete ONE file from the extraction
# destination, so the copy is materially incomplete while tar's exit status is 0.
"$REALTAR" "\$@"; rc=\$?
dest=""; prev=""
for a in "\$@"; do [ "\$prev" = "-C" ] && dest="\$a"; prev="\$a"; done
[ -n "\$dest" ] && rm -f "\$dest/mneme/kernel0/kernel0-selftest.lisp"
exit \$rc
WRAP
for n in 1 2; do
cat > "$OUT/bin-status-fail-$n/git" <<WRAP
#!/usr/bin/env bash
# tooth 8/9: fail the ${n}$([ $n = 1 ] && echo st || echo nd) 'git status' invocation only; every other git verb, and every
# other status call, is passed through to the real git.
CNT=\${TOOTH_STATUS_COUNTER:-/tmp/tooth-status-counter}
is_status=0
for a in "\$@"; do [ "\$a" = status ] && is_status=1; done
if [ "\$is_status" = 1 ]; then
  n=\$(( \$(cat "\$CNT" 2>/dev/null || echo 0) + 1 )); echo "\$n" > "\$CNT"
  if [ "\$n" = "$n" ]; then echo "tooth: simulated git status failure (call \$n)" >&2; exit 128; fi
fi
exec "$REALGIT" "\$@"
WRAP
done
chmod +x "$OUT"/bin-*/git "$OUT"/bin-tar-mutilate/tar 2>/dev/null

# ---------------------------------------------------------------- tooth 6
T="$OUT/06-archive-failure.transcript.txt"
banner "$T" 6 "failed archive/extraction -> NO GATE RUNS" \
  "6. failed archive/extraction -> no gate runs" \
  "a PATH-shadowed git wrapper fails the 'archive' verb only (wrapper source below)" "$RED5"
sed 's/^/   /' "$OUT/bin-archive-fail/git" >> "$T"; echo >> "$T"
variant "$T" "$R"
fire "$T" "$OUT/bin-archive-fail" >/dev/null
finish 6 "$T" "FAIL before any gate; transcript contains NO '[001]' row" 'NO GATE RAN'

# ---------------------------------------------------------------- tooth 7
T="$OUT/07-incomplete-materialization.transcript.txt"
banner "$T" 7 "deliberately incomplete materialization -> identity check fails BEFORE gates" \
  "7. deliberately incomplete materialization -> identity check fails before gates" \
  "a PATH-shadowed tar wrapper extracts correctly, exits 0, and then deletes one file from the copy (wrapper source below)" "$RED5"
sed 's/^/   /' "$OUT/bin-tar-mutilate/tar" >> "$T"; echo >> "$T"
variant "$T" "$R"
fire "$T" "$OUT/bin-tar-mutilate" >/dev/null
finish 7 "$T" "FAIL before any gate; the manifest diff names the missing path" 'is not the committed subject object'

# ---------------------------------------------------------------- tooth 8
T="$OUT/08-initial-git-status-fails.transcript.txt"
banner "$T" 8 "failed INITIAL git status -> CLEANLINESS-UNKNOWN" \
  "8. failed initial git status -> CLEANLINESS-UNKNOWN" \
  "a PATH-shadowed git wrapper fails the FIRST 'status' call only (wrapper source below)" "$RED5"
sed 's/^/   /' "$OUT/bin-status-fail-1/git" >> "$T"; echo >> "$T"
variant "$T" "$R"
rm -f /tmp/tooth-status-counter
fire "$T" "$OUT/bin-status-fail-1" >/dev/null
rm -f /tmp/tooth-status-counter
finish 8 "$T" "FAIL; CLEANLINESS-UNKNOWN at the initial probe; never 'unchanged'" 'CLEANLINESS-UNKNOWN'

# ---------------------------------------------------------------- tooth 9
T="$OUT/09-final-git-status-fails.transcript.txt"
banner "$T" 9 "failed FINAL git status after a started-clean run -> CLEANLINESS-UNKNOWN" \
  "9. failed final git status after a started-clean run -> CLEANLINESS-UNKNOWN" \
  "a PATH-shadowed git wrapper fails the SECOND 'status' call only; the first succeeds, so the run genuinely started clean (wrapper source below)" "$RED5"
sed 's/^/   /' "$OUT/bin-status-fail-2/git" >> "$T"; echo >> "$T"
variant "$T" "$R"
rm -f /tmp/tooth-status-counter
fire "$T" "$OUT/bin-status-fail-2" >/dev/null
rm -f /tmp/tooth-status-counter
finish 9 "$T" "FAIL; all five gates PASS, yet the floor refuses because quiescence was unobservable" 'the final git status probe failed'

# ---------------------------------------------------------------- tooth 10
T="$OUT/10-synthetic-extra-lane.transcript.txt"
banner "$T" 10 "synthetic extra lane in the table -> the lane appears automatically, totals exact" \
  "10. synthetic extra lane in the table -> lane appears automatically and totals remain exact" \
  "a sixth row is added in a lane name the real table has never contained (erratum0-synthetic); nothing else changes" \
  "5 REAL rows + 1 SYNTHETIC-LANE row (MKVARIANT_ALLOW_SYNTHETIC=1, declared)"
cp "$R" "$OUT/rows-tooth10.txt"
echo 'both|erratum0-synthetic|.|python3 mneme/atelier/static-check.py|Static relay check passed for 22 Lisp files.|no' >> "$OUT/rows-tooth10.txt"
ALLOW_SYNTH=1 variant "$T" "$OUT/rows-tooth10.txt"
fire "$T" >/dev/null
finish 10 "$T" "PASS with SIX lanes printed, one of them erratum0-synthetic, sum 6 == 6 attempted" '^PASS +erratum0-synthetic'

# ---------------------------------------------------------------- tooth 11
T="$OUT/11-planted-lane-omission.transcript.txt"
banner "$T" 11 "planted omission from the printed lane accounting -> the invariant fires" \
  "11. planted omission from the printed lane accounting -> the accounting invariant fires" \
  "ONE line is added to the repaired script's lane derivation so that lane 'kernel0' is dropped from LANES_PRINTED while its row still executes. The diff of the plant is shown below. This is the only tooth whose subject is a MUTATED copy of the repaired script: an invariant can only be seen to fire when the thing it guards is broken." "$RED5"
variant "$T" "$R"
cp "$PT/mneme/verify-release.sh" "$OUT/park/pre-tooth11.sh"
python3 - "$PT/mneme/verify-release.sh" <<'PY'
import sys
p=sys.argv[1]; s=open(p).read()
old='''  NF>=6 && $1 != "" { if (prof == "ci" && $1 != "both") next; if (!seen[$2]++) print $2 }')"'''
new='''  NF>=6 && $1 != "" { if (prof == "ci" && $1 != "both") next; if (!seen[$2]++) print $2 }' | grep -v '^kernel0$')"'''
assert s.count(old)==1
open(p,"w").write(s.replace(old,new))
PY
{ echo "--- planted diff (repaired variant -> tooth 11 subject) ---"; diff "$OUT/park/pre-tooth11.sh" "$PT/mneme/verify-release.sh"; echo; } >> "$T"
fire "$T" >/dev/null
finish 11 "$T" "FAIL; LANE ACCOUNTING VIOLATED on both counts (uncovered row and short sum)" 'LANE ACCOUNTING VIOLATED'

echo
echo "teeth 1-11 complete. Tooth 12 (ordinary clean control, all 112 rows) is the phase-3 full floor."
cp "$PRISTINE" "$PT/mneme/verify-release.sh"
