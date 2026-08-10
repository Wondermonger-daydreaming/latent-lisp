#!/usr/bin/env bash
#
# ma0-coverage.sh — the SEVEN-ARM END-TO-END TRAVERSAL TABLE (R1 §7).
#
# ⚠ THE TABLE IS HARVESTED, NOT DECLARED.  An arm counts as covered because a
# real run in a real image came back with an act summary naming it — never
# because a list in this file says so.  The arm→source column below is a
# ROUTING hint (which run to spawn); the COVERED column is evidence.
#
# That distinction has teeth here: P3's source NAMES arm D and never reaches it
# (the itinerary refuses before the feast), so a declared table built by reading
# `:arm' out of the sources would have reported D covered when it was not.  The
# harvest reports it uncovered, which is why arm D needed r1-d-traversal.
#
# Sentinel on the green path:
#   ma0-coverage: 7 arms, 7 traversed, 0 uncovered
#
# CANDIDATE.  Running a candidate is not adopting it (contract §0, §8), and
# nothing this script prints is independent verification (AP0 Rider 2).

set -u
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
lane="$(cd "$here/.." && pwd)"
work="$(mktemp -d "${TMPDIR:-/tmp}/ma0-coverage.XXXXXX")"
trap 'rm -rf "$work"' EXIT

ARMS=(A B-L1 B-L2 B-R C-i C-ii D)

covered_by=""   # newline-separated "<ARM>\t<SOURCE>"
note() { printf '%s\n' "$*"; }

# harvest <label> <outfile> — pull arm names out of one run's transcript.
# Two shapes are recognised, both emitted by runners this lane already owns:
#   MA0 summary <n> arm="<ARM>" ...     (the driver and run-r1-program)
#   MA0 COVER <ARM>                     (run-r1-program)
#   <ARM>/:<KEYWORD>                    (the P3 holdout's own check details)
harvest() {
  local label="$1" out="$2" found
  found="$(
    {
      grep -oE 'arm="[A-Za-z0-9-]+"' "$out" | sed 's/arm="//; s/"//'
      grep -oE '^MA0 COVER [A-Za-z0-9-]+' "$out" | awk '{print $3}'
      # ⚠ `sed', not `tr -d "[:space:]"'.  `tr' deletes across the whole
      # stream, newlines included, so three arms on three lines came back as
      # one token "AB-L2C-ii" and read as three UNCOVERED arms.  `sed' strips
      # within each line and leaves the line breaks alone.
      grep -oE '(^|[[:space:]])(A|B-L1|B-L2|B-R|C-i|C-ii|D)/:' "$out" \
        | sed 's|/:||; s|[[:space:]]||g'
    } 2>/dev/null | sort -u
  )"
  local a
  for a in $found; do
    covered_by="${covered_by}${a}	${label}
"
  done
  note "  harvested from ${label}: $(echo $found | tr '\n' ' ')"
}

echo "==========================================================================="
echo " MANY ACTS /0 — R1 §7 SEVEN-ARM TRAVERSAL COVERAGE"
echo " date -u : $(date -u)"
echo "==========================================================================="
echo
echo "-- spawning traversals, one program per image --"

run() { # run <label> <command...>
  local label="$1"; shift
  local out="$work/${label//\//_}.txt"
  ( cd "$lane" && "$@" ) >"$out" 2>&1
  local rc=$?
  note "  [$( [ $rc -eq 0 ] && echo ok || echo "EXIT $rc" )] $label"
  harvest "$label" "$out"
  return 0
}

# ⚠ THE `w-branch-*' SCENARIOS ARE DELIBERATELY ABSENT.  They witness the
# selection law over a DERIVED outcome and perform no act at all
# (`summary-count=0'), so they traverse nothing and would pad this table with a
# run that contributes no evidence.
run "p1"            bash "$lane/ma0-run.sh" p1
run "p2-alpha"      bash "$lane/ma0-run.sh" p2-alpha
run "p2-beta"       bash "$lane/ma0-run.sh" p2-beta
run "p3-holdout"    sbcl --script "$lane/p3/run-p3.lisp"
run "r1-bl1"        sbcl --script "$here/run-r1-program.lisp" r1-bl1-traversal B-L1
run "r1-d"          sbcl --script "$here/run-r1-program.lisp" r1-d-traversal D

echo
echo "==========================================================================="
echo " ARM   TRAVERSED   BY"
echo "==========================================================================="
uncovered=0
for arm in "${ARMS[@]}"; do
  sources="$(printf '%s' "$covered_by" | awk -F'\t' -v a="$arm" '$1==a {print $2}' | sort -u | tr '\n' ' ')"
  if [ -z "$sources" ]; then
    printf ' %-5s %-11s %s\n' "$arm" "NO" "(none)"
    uncovered=$((uncovered + 1))
  else
    printf ' %-5s %-11s %s\n' "$arm" "yes" "$sources"
  fi
done

traversed=$(( ${#ARMS[@]} - uncovered ))
echo "==========================================================================="
echo
if [ "$uncovered" -eq 0 ]; then
  echo "ma0-coverage: ${#ARMS[@]} arms, ${traversed} traversed, 0 uncovered"
  exit 0
else
  echo "ma0-coverage: RUN REFUSED — ${uncovered} of ${#ARMS[@]} arms have no"
  echo "end-to-end traversal.  The success sentinel is WITHHELD."
  exit 1
fi
