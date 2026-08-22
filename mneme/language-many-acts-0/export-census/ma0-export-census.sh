#!/usr/bin/env bash
# ma0-export-census.sh — MA0 EXPORT CENSUS /0: the exact-export-set gate.
#
# CANDIDATE.  Running a candidate is not adopting it (Many Acts /0 contract
# §0, §8).  Nothing this script prints is independent verification, independent
# validation, a portability claim, or a conformance claim (AP0 adoption
# Rider 2, binding).
#
#   ./ma0-export-census.sh              # run the census.  No other invocation.
#
# ===========================================================================
# CENSUS R1 REPAIR — Owner Ruling 6A, items 1, 2 and 3
# ===========================================================================
#
# THE DEFECT, as ruled: "`ma0-export-census.sh --table P' and the Lisp half's
# arbitrary table argument permit expectation substitution.  A live package with
# `ma0-selftest' replaced by the bound internal `ma0-refuse' can be paired with
# a correspondingly substituted table and obtain the success sentinel."
#
# THE REPAIR HERE, in three parts:
#
#   (1) `--table' IS GONE.  This driver takes no argument that selects an
#       expected side.  Any argument other than -h/--help is refused with
#       exit 2.  There is no alternate-table mode to enter.
#
#   (2) The expected side is BOUND (Ruling 6A item 2) to:
#         adopted coordinate    231873c7be8ba275cd5756c929efba2f9c807157
#         package.lisp blob     a97d3c3e2f6baa21f21c52ae0c4986140eb1fa5c
#         EXPECTED-EXPORTS.txt  78592073905450ff9afcd22dea53afbf53764fa1
#
#   (3) BEFORE any census evaluation, three checks must all pass, and any
#       failure exits 2 without loading the subject at all (Ruling 6A item 3):
#         3a  git hash-object EXPECTED-EXPORTS.txt == the bound table blob;
#         3b  the adopted coordinate exists and its package.lisp is the bound
#             package blob;
#         3c  BYTE-REGENERATION: derive-expected-exports.sh is re-run against
#             the adopted coordinate and its output is `cmp'-ed against the
#             committed table.  This is the strong form — it proves the table
#             IS the table derived from that coordinate, not merely a file
#             whose name has been seen before.
#
# The Lisp half performs its OWN binding check besides (it re-derives the git
# blob id of the table with a SHA-1 implemented in that file), so a direct
# `sbcl --script' invocation bypassing this driver cannot reach the sentinel
# either.  Neither half trusts the other.
#
# Authorized by Owner Ruling 6 §3 B7 (AMENDED OPTION 1) and §5.2, repaired
# under Owner Ruling 6A: enforce the EXACT EXPORT SET, not a count.  `38' is
# the derived cardinality of the adopted exact set, never a substitute for
# checking identity — so no comparison against a literal count occurs anywhere
# in this gate.
#
# EXIT: 0 = exact set equality AND every expected export bound in its
#           designated sense (the sentinel is printed on that path only)
#       1 = census findings (missing / unexpected / unbound / foreign home)
#       2 = the census could not be conducted (substituted or unbound expected
#           table, load failure, unauthorized SBCL, unknown argument)
#           — a refusal to judge, never a pass
#
# — Claude Opus (agent CENSOR), 2026-08-10
# — R1 repair: Claude Opus (agent CENSOR-II), 2026-08-10, under Owner Ruling 6A

set -uo pipefail

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
table="$here/EXPECTED-EXPORTS.txt"

# --- BOUND IDENTITIES (Ruling 6A item 2) -----------------------------------
BOUND_COORD='231873c7be8ba275cd5756c929efba2f9c807157'
BOUND_PKG_BLOB='a97d3c3e2f6baa21f21c52ae0c4986140eb1fa5c'
BOUND_TABLE_BLOB='78592073905450ff9afcd22dea53afbf53764fa1'
LANE='experiments/latent-lisp/mneme/language-many-acts-0'

# --- (1) no arbitrary-table selection --------------------------------------
while [ $# -gt 0 ]; do
  case "$1" in
    -h|--help) sed -n '2,60p' "${BASH_SOURCE[0]}"; exit 0 ;;
    --table|--table=*)
      echo "ma0-export-census.sh: REFUSED — '--table' was REMOVED by Census R1" >&2
      echo "  (Owner Ruling 6A item 1).  The expected side of this census is bound" >&2
      echo "  to blob $BOUND_TABLE_BLOB, derived from coordinate" >&2
      echo "  $BOUND_COORD.  There is no alternate-table mode." >&2
      exit 2 ;;
    *) echo "ma0-export-census.sh: unknown argument '$1'" >&2; exit 2 ;;
  esac
done

if [ ! -f "$table" ]; then
  echo "ma0-export-census.sh: expected table not found: $table" >&2
  exit 2
fi

# ---------------------------------------------------------------------------
# Operation check before the run.  The lab's SBCL has been shipped behind a
# wrapper before; a census conducted by a misbehaving reader is worthless, and
# a silent workaround would be worse than a stop.
# ---------------------------------------------------------------------------
echo "== operation check =="
sbcl --version || { echo "ma0-export-census.sh: sbcl --version failed" >&2; exit 2; }
probe="$(echo '(print (lisp-implementation-version))' | sbcl --script /dev/stdin 2>&1 | tr -d '\r')"
echo "sbcl --script reports: $probe"
case "$probe" in
  *'"2.4.6"'*) : ;;
  *) echo "ma0-export-census.sh: FAIL CLOSED — unexpected --script probe: $probe" >&2; exit 2 ;;
esac

command -v git >/dev/null 2>&1 || {
  echo "ma0-export-census.sh: FAIL CLOSED — git is required to verify the bound" >&2
  echo "  expected table; without it the binding cannot be checked and the census" >&2
  echo "  must not proceed." >&2
  exit 2; }

root="$(cd "$here/../../../../.." && pwd)"

# ---------------------------------------------------------------------------
# (3) THE BINDING CHECKS — all before any census evaluation.
# ---------------------------------------------------------------------------
echo
echo "== expected-table binding (Owner Ruling 6A items 2-3) =="
echo "path             : $table"
echo "bound coordinate : $BOUND_COORD"
echo "bound pkg  blob  : $BOUND_PKG_BLOB"
echo "bound table blob : $BOUND_TABLE_BLOB"

# 3a — the committed table's own blob identity.
observed_table_blob="$(git hash-object "$table")"
echo "observed table blob : $observed_table_blob"
if [ "$observed_table_blob" != "$BOUND_TABLE_BLOB" ]; then
  echo "ma0-export-census.sh: FAIL CLOSED — the expected table is not the bound table." >&2
  echo "  observed $observed_table_blob, bound $BOUND_TABLE_BLOB" >&2
  exit 2
fi
echo "  [3a] table blob identity      : MATCH"

# 3b — the coordinate exists and carries the bound package.lisp.
if ! git -C "$root" cat-file -e "${BOUND_COORD}^{commit}" 2>/dev/null; then
  echo "ma0-export-census.sh: FAIL CLOSED — adopted coordinate $BOUND_COORD not found." >&2
  exit 2
fi
observed_pkg_blob="$(git -C "$root" rev-parse "${BOUND_COORD}:${LANE}/package.lisp" 2>/dev/null || true)"
echo "observed pkg blob at coordinate : $observed_pkg_blob"
if [ "$observed_pkg_blob" != "$BOUND_PKG_BLOB" ]; then
  echo "ma0-export-census.sh: FAIL CLOSED — package.lisp at $BOUND_COORD is not the bound blob." >&2
  echo "  observed '$observed_pkg_blob', bound $BOUND_PKG_BLOB" >&2
  exit 2
fi
echo "  [3b] coordinate package blob  : MATCH"

# 3c — byte-regeneration from the coordinate, then cmp.  The strong form.
regen="$(mktemp)"; trap 'rm -f "$regen"' EXIT
if ! "$here/derive-expected-exports.sh" "$BOUND_COORD" > "$regen" 2>/dev/null; then
  echo "ma0-export-census.sh: FAIL CLOSED — the expected table could not be regenerated" >&2
  echo "  from coordinate $BOUND_COORD; the binding is unverifiable." >&2
  exit 2
fi
if ! cmp -s "$regen" "$table"; then
  echo "ma0-export-census.sh: FAIL CLOSED — the expected table is NOT the table derived" >&2
  echo "  from coordinate $BOUND_COORD.  Regenerated bytes differ:" >&2
  diff "$regen" "$table" >&2 || true
  exit 2
fi
echo "  [3c] byte-regeneration + cmp  : IDENTICAL ($(git hash-object "$regen"))"
echo "rows : $(grep -cv '^#' "$table" | tr -d ' ') (comment lines excluded)"
echo "expected side BOUND; proceeding to census evaluation."

echo
exec sbcl --script "$here/ma0-export-census.lisp" "$table"
