#!/usr/bin/env bash
# repeatability.sh — temporal repeatability report for Vertical Specimen /0.
#
# A report WITH an exit discipline (chair revision, same day): exit 0 only
# when every canonical comparison reads IDENTICAL; any DIFFERS or MISSING
# exits 1 (cannot-run exits 2).  The teeth are proven by
# RUN-REPEATABILITY-TEETH.txt: a planted single-byte difference must
# produce DIFFERS + exit 1.  Optional args $1 $2 override the two
# campaign roots (used only by the teeth run).
#
# Run from the latent-lisp root:
#
#     bash mneme/vertical0/harness/repeatability.sh
#
# What it does, in order:
#   A. byte-compares every CANONICAL artifact of contract §16 between
#      runs/campaign-1/ and runs/campaign-2/ (cmp, not checksums-of-checksums);
#   B. byte-compares, as a SUPPLEMENT beyond the §16 list, the complete exec/
#      and corpse-W*/ trees;
#   C. runs the OFFICIAL reconstruction (reconstruction/reconstruct-census.lisp)
#      in a fresh child over campaign-2/exec and compares its census artifact's
#      sha256 against campaign-1's official census digest, recorded in the
#      committed RUN-RECONSTRUCTION.txt.
#
# DECLARED NONCANONICAL, therefore excluded from every comparison below:
#   · runs/campaign-*/trace-life{1..5}.txt   (strace diagnostics; carry pids,
#     fds, timings, kernel-scheduling detail)
#   · runs/campaign-*/private/kill-log.txt   (harness kill log; carries pids and
#     live /proc wchan/state samples)
#   Contract §16: "raw harness diagnostics may [carry ambient pids/paths], as
#   declared noncanonical".  Their exclusion is a declaration, not a finding.
#
# — PRAETOR (Claude Fable 5 subagent), 2026-07-30

set -u

ROOT="mneme/vertical0"
A="${1:-$ROOT/runs/campaign-1}"
B="${2:-$ROOT/runs/campaign-2}"
OFFICIAL_CENSUS_SHA256="706f7e1e582e06cce14ba44428b7c0705bd6480a8dcbd5ebf5a9a85874cdd05a"

if [ ! -d "$A" ] || [ ! -d "$B" ]; then
  echo "repeatability: missing $A or $B — run from the latent-lisp root" >&2
  exit 2
fi

identical=0
differs=0
missing=0

compare () { # $1 = relative-to-campaign-root path, $2 = classification label
  local rel="$1" label="$2" fa="$A/$1" fb="$B/$1"
  if [ ! -f "$fa" ] || [ ! -f "$fb" ]; then
    printf '  %-11s %-58s %s\n' "MISSING" "$rel" "$label"
    missing=$((missing + 1))
    return
  fi
  if cmp -s "$fa" "$fb"; then
    printf '  %-11s %-58s %s\n' "IDENTICAL" "$rel" "$label"
    identical=$((identical + 1))
  else
    printf '  %-11s %-58s %s\n' "DIFFERS" "$rel" "$label"
    differs=$((differs + 1))
  fi
}

echo "vertical0 temporal repeatability — campaign-1 vs campaign-2"
echo "byte comparison by cmp(1); every canonical item must read IDENTICAL."
echo
echo "== A. canonical artifacts (contract §16) =="
echo
echo "  -- the durable journal --"
compare "exec/store/EVENTS.pj0"                       "primary journal"
compare "exec/store/JOURNAL-META.pjs"                 "journal meta"
echo
echo "  -- captured evidence (all bytes the program ever custodied) --"
for f in "$A"/exec/evidence/*.bin; do
  compare "exec/evidence/$(basename "$f")"            "evidence"
done
echo
echo "  -- derived exports --"
compare "exec/export/campaign-export.sexp"            "finalizer-independent export"
compare "exec/mirror-sim/campaign-export.sexp"        "simulated publication copy"
echo
echo "  -- world state (class A) and the fake provider domain (class B) --"
compare "exec/world/CELLS.txt"                        "world cells"
compare "exec/world/REQUEST-LEDGER.txt"               "world request ledger"
compare "exec/fake-world/provider-domain.sexp"        "provider domain"
echo
echo "  -- the four corpse journals (state at each SIGKILL) --"
for w in W1 W2 W3 W4; do
  compare "corpse-$w/exec/store/EVENTS.pj0"           "corpse journal $w"
done

echo
echo "== B. SUPPLEMENT (beyond the §16 list): complete exec/ and corpse trees =="
echo
sup_diff=0
for sub in exec corpse-W1 corpse-W2 corpse-W3 corpse-W4; do
  out=$(diff -rq "$A/$sub" "$B/$sub" 2>&1)
  if [ -z "$out" ]; then
    printf '  %-11s %s/  (recursive diff -rq clean)\n' "IDENTICAL" "$sub"
  else
    printf '  %-11s %s/\n' "DIFFERS" "$sub"
    echo "$out" | sed 's/^/      /'
    sup_diff=$((sup_diff + 1))
  fi
done

echo
echo "== C. official reconstruction over campaign-2, against campaign-1's digest =="
echo
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT
sbcl --script "$ROOT/reconstruction/reconstruct-census.lisp" \
     "$B/exec/" "$work/census-campaign-2.sexp" > "$work/recon.log" 2>&1
recon_exit=$?
echo "  reconstruct-census.lisp (fresh child) over $B/exec/ — exit $recon_exit"
sed 's/^/      | /' "$work/recon.log"
if [ "$recon_exit" -eq 0 ] && [ -s "$work/census-campaign-2.sexp" ]; then
  got=$(sha256sum "$work/census-campaign-2.sexp" | cut -d' ' -f1)
  bytes=$(wc -c < "$work/census-campaign-2.sexp")
  echo "  campaign-2 official census: $bytes octets, sha256 $got"
  echo "  campaign-1 official census (RUN-RECONSTRUCTION.txt): sha256 $OFFICIAL_CENSUS_SHA256"
  if [ "$got" = "$OFFICIAL_CENSUS_SHA256" ]; then
    echo "  IDENTICAL   official census digest"
    identical=$((identical + 1))
  else
    echo "  DIFFERS     official census digest"
    differs=$((differs + 1))
  fi
else
  echo "  MISSING     official census could not be produced"
  missing=$((missing + 1))
fi

echo
echo "== verdict =="
echo "  canonical comparisons: $identical IDENTICAL, $differs DIFFERS, $missing MISSING"
echo "  supplementary tree comparisons differing: $sup_diff"
if [ "$differs" -eq 0 ] && [ "$missing" -eq 0 ]; then
  echo "  VERDICT: every canonical artifact of §16 is byte-identical across the two"
  echo "           campaigns, and campaign-2's officially reconstructed census equals"
  echo "           campaign-1's official census digest."
  echo "  This earns exactly: same-host fresh-directory temporal repeatability."
  echo "  It does NOT earn: cross-platform determinism, power-loss durability, or"
  echo "  any claim about a host other than the declared one."
else
  echo "  VERDICT: NOT repeatable as declared — see the DIFFERS/MISSING rows above."
fi
if [ "$differs" -eq 0 ] && [ "$missing" -eq 0 ]; then exit 0; else exit 1; fi
