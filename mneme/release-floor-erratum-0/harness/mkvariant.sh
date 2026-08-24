#!/usr/bin/env bash
# mkvariant.sh — derive a REDUCED-AUTHORIZED-TABLE variant of a real verify-release.sh.
#
#   bash mkvariant.sh <src verify-release.sh> <rows file> <dst path>
#
# The ONLY changes it makes are (i) the body of the GATES heredoc and (ii) the two
# AUTHORIZED_GATES_* constants, recomputed from the rows file by the same grep the floor
# itself runs.  It then PROVES that claim: it diffs src against dst and refuses unless every
# changed line lies inside the table body or is one of the two constant lines.  The classifier,
# the materializer, the identity check, the cleanliness probes, the lane derivation and the
# terminal doctrine are therefore byte-identical to the real script under test.
#
# Every row in the rows file must be a REAL row of the real table (checked).
set -uo pipefail
SRC="${1:?src}"; ROWS="${2:?rows}"; DST="${3:?dst}"

# every reduced row must appear verbatim in the source table
# (MKVARIANT_ALLOW_SYNTHETIC=1 relaxes this for the ONE tooth that must introduce a
#  lane the real table does not contain -- Sol I §IV tooth 10.  It is recorded loudly.)
missing=0
while IFS= read -r r; do
  [ -z "$r" ] && continue
  grep -qxF -- "$r" "$SRC" || {
    if [ "${MKVARIANT_ALLOW_SYNTHETIC:-0}" = "1" ]; then
      echo "!! SYNTHETIC ROW (allowed explicitly for this tooth): $r"
    else
      echo "!! row not present verbatim in $SRC: $r" >&2; missing=1
    fi
  }
done < "$ROWS"
[ "$missing" -eq 0 ] || exit 1

FULL="$(grep -c -E '^(both|full)\|' "$ROWS")"
CI="$(grep -c -E '^both\|' "$ROWS")"

awk -v rowsfile="$ROWS" -v full="$FULL" -v ci="$CI" '
  BEGIN { n=0; while ((getline l < rowsfile) > 0) if (length(l)) R[++n]=l }
  intable == 1 { if ($0 == "TABLE") { print; intable=2 } next }
  /^read -r -d .. GATES <</ && intable == 0 { print; for (i=1;i<=n;i++) print R[i]; intable=1; next }
  /^AUTHORIZED_GATES_FULL=/ { print "AUTHORIZED_GATES_FULL=" full; next }
  /^AUTHORIZED_GATES_CI=/   { print "AUTHORIZED_GATES_CI=" ci;   next }
  { print }
' "$SRC" > "$DST" || exit 1

# --- prove the mutation is confined ---------------------------------------
# Extract the table body of each file and confirm the two files are identical once each
# table body is replaced by a single placeholder and the two constants are normalised.
norm() {
  awk '
    intable == 1 { if ($0 == "TABLE") { print "<<GATES TABLE BODY>>"; print; intable=2 } next }
    /^read -r -d .. GATES <</ && intable == 0 { print; intable=1; next }
    /^AUTHORIZED_GATES_FULL=/ { print "AUTHORIZED_GATES_FULL=<N>"; next }
    /^AUTHORIZED_GATES_CI=/   { print "AUTHORIZED_GATES_CI=<N>";   next }
    { print }
  ' "$1"
}
if ! diff <(norm "$SRC") <(norm "$DST") > /dev/null; then
  echo "!! REFUSING: the variant differs from the source OUTSIDE the gate table and the two authorized constants:" >&2
  diff <(norm "$SRC") <(norm "$DST") >&2
  exit 1
fi
echo "variant written : $DST"
echo "rows            : $FULL full / $CI ci  (from $ROWS)"
echo "confinement     : PROVEN — src and dst are byte-identical outside the GATES table body"
echo "                  and the two AUTHORIZED_GATES_* lines (diff of normalised files is empty)."
