#!/usr/bin/env bash
# derive-expected-exports.sh — MA0 EXPORT CENSUS /0: materialize the expected table.
#
# CANDIDATE.  Nothing this script produces is independent verification,
# independent validation, or a portability or conformance claim
# (AP0 adoption Rider 2, binding; Many Acts /0 contract §0).
#
# WHAT THIS DOES, AND WHY IT IS NOT CIRCULAR
# ------------------------------------------
# The expected export set is read STATICALLY out of `package.lisp' AS IT EXISTS
# AT THE ADOPTED R1 COORDINATE, via `git show' — never from a loaded image and
# never from the working tree.  The census gate then loads the LIVE system and
# compares the live package's external-symbol set against this table.  The two
# sides therefore have genuinely different provenance: a committed text derived
# from a pinned git object, versus a runtime package.  Deriving the expected
# set from the same package the gate tests would prove only that a set equals
# itself (Owner Ruling 6 §3 B7 item 2).
#
# TWO INDEPENDENT EXTRACTIONS MUST AGREE.  A regex sweep and a READER-based
# structural walk of the `defpackage' form are both run, and the script fails
# closed if they disagree.  A single extraction is one unaudited opinion.
#
# DESIGNATIONS are derived by searching the R1 sources at the SAME coordinate
# for the form that actually defines each name.  Every designation is emitted
# with its defining file and line, so the classification can be re-checked
# without trusting this script's summary.
#
#   usage:  ./derive-expected-exports.sh [<coordinate>] > EXPECTED-EXPORTS.txt
#
# — Claude Opus (agent CENSOR), 2026-08-10

set -euo pipefail

COORD="${1:-231873c7be8ba275cd5756c929efba2f9c807157}"
LANE="experiments/latent-lisp/mneme/language-many-acts-0"
PKG="$LANE/package.lisp"

# Repo root: this file lives at <root>/$LANE/export-census/.
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
root="$(cd "$here/../../../../.." && pwd)"
cd "$root"

if [ ! -d .git ] && [ ! -f .git ]; then
  echo "derive-expected-exports.sh: not a git checkout root: $root" >&2
  exit 2
fi

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

git show "$COORD:$PKG" > "$tmp/package.lisp"
PKG_BLOB="$(git hash-object "$tmp/package.lisp")"

# ---------------------------------------------------------------------------
# Extraction A — regex sweep of the exporting defpackage's own lines.
# ---------------------------------------------------------------------------
awk '/^\(defpackage #:lisp-plus-many-acts0$/,0' "$tmp/package.lisp" \
  | grep -oE '^[[:space:]]*#:[A-Za-z0-9+*<>=/-]+' \
  | sed 's/^[[:space:]]*#://' > "$tmp/extract-a.txt"

# ---------------------------------------------------------------------------
# Extraction B — READ the file as data; walk the defpackage form structurally.
# Independent of A's line shape: catches names sharing a line, which a
# line-anchored regex would silently drop.
# ---------------------------------------------------------------------------
cat > "$tmp/extract-b.lisp" <<'LISP'
(let ((names '()) (path (second sb-ext:*posix-argv*)))
  (with-open-file (s path)
    (let ((*package* (find-package :cl-user)) (*read-eval* nil))
      (loop for form = (read s nil :eof)
            until (eq form :eof)
            do (when (and (consp form) (symbolp (first form))
                          (string= (symbol-name (first form)) "DEFPACKAGE")
                          (string= (string (second form)) "LISP-PLUS-MANY-ACTS0"))
                 (dolist (clause (cddr form))
                   (when (and (consp clause) (symbolp (car clause))
                              (string= (symbol-name (car clause)) "EXPORT"))
                     (dolist (n (cdr clause)) (push (string-downcase (string n)) names))))))))
  (dolist (n (nreverse names)) (format t "~A~%" n)))
LISP
sbcl --script "$tmp/extract-b.lisp" "$tmp/package.lisp" > "$tmp/extract-b.txt"

LC_ALL=C sort "$tmp/extract-a.txt" > "$tmp/a.sorted"
LC_ALL=C sort "$tmp/extract-b.txt" > "$tmp/b.sorted"
if ! cmp -s "$tmp/a.sorted" "$tmp/b.sorted"; then
  echo "derive-expected-exports.sh: FAIL CLOSED — the two extractions disagree." >&2
  diff "$tmp/a.sorted" "$tmp/b.sorted" >&2 || true
  exit 3
fi
if [ -s "$(LC_ALL=C sort "$tmp/a.sorted" | uniq -d > "$tmp/dups"; echo "$tmp/dups")" ]; then
  echo "derive-expected-exports.sh: FAIL CLOSED — duplicate name(s) in the export list:" >&2
  cat "$tmp/dups" >&2
  exit 3
fi

COUNT="$(wc -l < "$tmp/a.sorted" | tr -d ' ')"

# ---------------------------------------------------------------------------
# Designations — derived from the defining form in the R1 sources at $COORD.
# ---------------------------------------------------------------------------
SOURCES="package.lisp ma0-structures.lisp ma0-validate.lisp ma0-environment.lisp \
ma0-compose.lisp ma0-eval.lisp ma0-selftest-suite.lisp"

mkdir -p "$tmp/src"
for f in $SOURCES; do git show "$COORD:$LANE/$f" > "$tmp/src/$f"; done

# The condition families are minted inside a `macrolet' — no `define-condition'
# line carries their names.  Harvest that block explicitly; a grep for
# "define-condition" alone would misclassify all six as undefined.
awk '/\(families ma0-refusal/,/\)\);/' "$tmp/src/ma0-structures.lisp" \
  | grep -oE '^[[:space:]]+ma0-[A-Za-z0-9-]+' | tr -d ' ' > "$tmp/families.txt"

# Escape every character that is not alphanumeric or a hyphen, so that names
# carrying `+' or `*' (the constants) survive into ERE as literals.  An
# under-escaped `+ma0-arms+' silently matches nothing and the name would be
# reported UNDERIVED — a designation hole wearing a clean exit.
esc() { printf '%s' "$1" | sed 's/[^A-Za-z0-9-]/\\&/g'; }

find_def() {  # $1=name  -> prints "CATEGORY<TAB>file:line<TAB>evidence"
  local n="$1" e; e="$(esc "$1")" || true
  local f line hit

  for f in $SOURCES; do
    hit="$(grep -nE "^\(define-condition ${e}([[:space:]]|\()" "$tmp/src/$f" | head -1 || true)"
    [ -n "$hit" ] && { printf 'condition-class\t%s:%s\tdefine-condition\n' "$f" "${hit%%:*}"; return; }
  done

  if grep -qxF "$n" "$tmp/families.txt"; then
    # The last family name is followed by `))', not whitespace — allow both,
    # else its line number comes back empty and the evidence column lies.
    line="$(grep -nE "^[[:space:]]+${e}([[:space:]]|\)|$)" \
              "$tmp/src/ma0-structures.lisp" | head -1 || true)"
    printf 'condition-class\t%s:%s\tmacrolet families of ma0-refusal\n' \
      "ma0-structures.lisp" "${line%%:*}"; return
  fi

  for f in $SOURCES; do
    hit="$(grep -nE "^\(defstruct \(?${e}([[:space:]]|\()" "$tmp/src/$f" | head -1 || true)"
    [ -n "$hit" ] && { printf 'structure-type\t%s:%s\tdefstruct\n' "$f" "${hit%%:*}"; return; }
  done

  for f in $SOURCES; do
    hit="$(grep -nE "^\((defparameter|defvar) ${e}([[:space:]]|$)" "$tmp/src/$f" | head -1 || true)"
    [ -n "$hit" ] && { printf 'variable\t%s:%s\t%s\n' "$f" "${hit%%:*}" \
        "$(printf '%s' "${hit#*:}" | grep -oE 'defparameter|defvar')"; return; }
  done

  for f in $SOURCES; do
    hit="$(grep -nE "^\(defun ${e}([[:space:]]|\()" "$tmp/src/$f" | head -1 || true)"
    [ -n "$hit" ] && { printf 'function\t%s:%s\tdefun\n' "$f" "${hit%%:*}"; return; }
  done

  for f in $SOURCES; do
    hit="$(grep -nE "\(:predicate ${e}\)" "$tmp/src/$f" | head -1 || true)"
    [ -n "$hit" ] && { printf 'function\t%s:%s\tdefstruct :predicate\n' "$f" "${hit%%:*}"; return; }
  done

  for f in $SOURCES; do
    hit="$(grep -nE ":reader ${e}\)" "$tmp/src/$f" | head -1 || true)"
    [ -n "$hit" ] && { printf 'function\t%s:%s\tcondition slot :reader\n' "$f" "${hit%%:*}"; return; }
  done

  printf 'UNDERIVED\t-\tno defining form found at this coordinate\n'
}

{
  printf '# MA0 EXPORT CENSUS /0 — EXPECTED EXPORT TABLE (CANDIDATE)\n'
  printf '#\n'
  printf '# Nothing here is independent verification, independent validation, a\n'
  printf '# portability claim, or a conformance claim.  Candidate, branch-local.\n'
  printf '#\n'
  printf '# Adopted R1 coordinate : %s\n' "$COORD"
  printf '# Source of record      : %s\n' "$PKG"
  printf '# package.lisp blob     : %s\n' "$PKG_BLOB"
  printf '# Extraction            : regex sweep AND reader-based structural walk of\n'
  printf '#                         the (defpackage #:lisp-plus-many-acts0 ...) form;\n'
  printf '#                         both run, sets compared, fail-closed on disagreement.\n'
  printf '# Sort                  : LC_ALL=C sort, by NAME, ascending\n'
  printf '# Cardinality           : %s  (DERIVED, never assumed)\n' "$COUNT"
  printf '# Designations          : derived from the defining form in the R1 sources at\n'
  printf '#                         the same coordinate; file:line evidence in column 3.\n'
  printf '# Generated by          : export-census/derive-expected-exports.sh\n'
  printf '#\n'
  printf '# Columns: NAME<TAB>DESIGNATION<TAB>DEFINING-SITE<TAB>HOW-DERIVED\n'
  printf '# The gate reads columns 1 and 2.  Lines beginning with # are comments.\n'
  printf '#\n'
  while IFS= read -r n; do
    printf '%s\t%s\n' "$n" "$(find_def "$n")"
  done < "$tmp/a.sorted"
} > "$tmp/table.txt"

# FAIL CLOSED on any name whose defining form was not found.  An UNDERIVED row
# is a hole in the designation, and a table with a hole in it must not be
# emitted as though it were complete.
if grep -q 'UNDERIVED' "$tmp/table.txt"; then
  echo "derive-expected-exports.sh: FAIL CLOSED — undesignated export(s):" >&2
  grep 'UNDERIVED' "$tmp/table.txt" >&2
  exit 4
fi
# FAIL CLOSED if any evidence cell lost its line number.
if grep -qE '^[^#][^\t]*\t[a-z-]+\t[A-Za-z0-9._-]+:\t' "$tmp/table.txt"; then
  echo "derive-expected-exports.sh: FAIL CLOSED — evidence row(s) missing a line number:" >&2
  grep -E '^[^#][^\t]*\t[a-z-]+\t[A-Za-z0-9._-]+:\t' "$tmp/table.txt" >&2
  exit 5
fi

cat "$tmp/table.txt"
