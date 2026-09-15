#!/usr/bin/env bash
# p10-runner.sh <out-dir>
#
# The P10 REAL GATE /0 auditor harness runner (PREREG-P10-RG-0 §3/§5/§6).
# Nine cases, in order: B0 B0-I M1-C M1-U M1-U-I M2-P M2-X U1 U1-M.
# One disposable subject per case; one gate process at a time; every gate and
# witness run is a fresh `sbcl --script` with cwd = the subject root.
#
# All companion paths resolve from THIS script's own location, never from cwd,
# so `cd harness && bash ./p10-runner.sh out` works.
#
# Subject routes (the pinned 70-sha check runs BEFORE mutation in BOTH, and is
# what makes them equivalent):
#   default          : git archive <commit>:experiments/latent-lisp from the lab
#                      checkout ($P10_LAB_REPO, default /home/gauss/Desktop/Claude-Code-Lab)
#   $P10_SUBJECT_TREE: cp -a "$P10_SUBJECT_TREE"/. <subject-root>/   (no git needed)
#
# Env:
#   P10_SUBJECT_TREE      pre-extracted subject tree (parcel-validator route)
#   P10_PINNED            override the pinned sha list
#   P10_LAB_REPO          the lab checkout (git route + IDENTITY-AFTER)
#   P10_SBCL              the sbcl binary
#   P10_EXPECT_OVERRIDE   "CASE=CLASS[;CASE=CLASS]" -- printed verbatim
#   P10_SUBJECT_BASE      where disposable subjects go (default /tmp/p10-rg0-<stamp>)
#
# Exit: 0 iff fail=0 and invalid=0.  5 = REFUSED (a precondition).  6 = VOID.

set -u

HARNESS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ARC_DIR="$(cd "$HARNESS_DIR/.." && pwd)"
PREREG_SHA_EXPECTED=0835d5db9f44a27f68ec29b993e2ca97e247200bc197569cc5a66250ffab7165
SUBJECT_COMMIT=244580e81a9002ea61a435ed185e85133a994fd9
CASES="B0 B0-I M1-C M1-U M1-U-I M2-P M2-X U1 U1-M"
LOCKDIR=/tmp/p10-rg0-runner.lock

refuse() { echo "P10-RUNNER: REFUSED — $*"; exit 5; }
void()   { echo "P10-RUNNER: VOID — $*";    exit 6; }

if [ "$#" -ne 1 ]; then echo "usage: p10-runner.sh <out-dir>" >&2; exit 5; fi
mkdir -p "$1" || refuse "cannot create out dir $1"
OUT="$(cd "$1" && pwd)"

# ---------------------------------------------------------------- preconditions
PINNED="${P10_PINNED:-$ARC_DIR/subjects/PINNED-SUBJECT-SHA256.txt}"
[ -f "$PINNED" ] || refuse "pinned subject list absent: $PINNED"
PINNED="$(cd "$(dirname "$PINNED")" && pwd)/$(basename "$PINNED")"
PINNED_ROWS="$(wc -l < "$PINNED")"

PREREG="$ARC_DIR/prereg/PREREG-P10-RG-0.md"
[ -f "$PREREG" ] || refuse "prereg absent: $PREREG"
PREREG_SHA="$(sha256sum "$PREREG" | cut -d' ' -f1)"
[ "$PREREG_SHA" = "$PREREG_SHA_EXPECTED" ] || \
  refuse "prereg sha256 MISMATCH: got $PREREG_SHA, frozen $PREREG_SHA_EXPECTED"

EXPECT_FILE="$HARNESS_DIR/EXPECTATIONS-P10.txt"
[ -f "$EXPECT_FILE" ] || refuse "EXPECTATIONS-P10.txt absent"
for c in $CASES; do
  n="$(grep -cE "^${c}[[:space:]]" "$EXPECT_FILE" || true)"
  [ "$n" -eq 1 ] || refuse "EXPECTATIONS-P10.txt has $n rows for case $c, expected exactly 1"
done
while read -r rc _rest; do
  case " $CASES " in *" $rc "*) ;; *) refuse "EXPECTATIONS-P10.txt names unknown case '$rc'" ;; esac
done < <(grep -vE '^[[:space:]]*(#|$)' "$EXPECT_FILE")

SBCL="${P10_SBCL:-$(command -v sbcl 2>/dev/null || echo /home/gauss/.local/bin/sbcl)}"
[ -x "$SBCL" ] || refuse "sbcl not executable: $SBCL"
SBCL_VERSION="$("$SBCL" --version 2>&1 | head -n1)"

# the 11 process-ending switches: any one set makes every gate VOID (exit 4)
ENV_SWITCHES="CAP2_WORLD_DIE_IN_WINDOW ML0_SELFTEST_PLANT_FAULT ML0_CONTROLS_PLANT_FAULT
ML0_READER_DIE ACT1_SELFTEST_PLANT_FAULT ACT1_CONTROLS_PLANT_FAULT ACT1_RESTART_DIE
CAP2_SELFTEST_PLANT_FAULT CAP2_CONTROLS_PLANT_FAULT CAP2_CONTROLS_DIE DE_EFFECTU_DIE"
for v in $ENV_SWITCHES; do
  if [ -n "${!v:-}" ]; then refuse "process-ending switch $v is set; every gate would VOID (exit 4)"; fi
done

LAB_REPO="${P10_LAB_REPO:-/home/gauss/Desktop/Claude-Code-Lab}"
SUBJECT_MODE=""
if [ -n "${P10_SUBJECT_TREE:-}" ]; then
  [ -d "$P10_SUBJECT_TREE/mneme/memory-layer-0" ] || \
    refuse "P10_SUBJECT_TREE=$P10_SUBJECT_TREE is not an experiments/latent-lisp tree"
  SUBJECT_TREE="$(cd "$P10_SUBJECT_TREE" && pwd)"
  SUBJECT_MODE="cp -a from P10_SUBJECT_TREE=$SUBJECT_TREE (no git)"
  IDENTITY_ROOT="$SUBJECT_TREE"
else
  [ -d "$LAB_REPO/.git" ] || refuse "no P10_SUBJECT_TREE and no git repo at $LAB_REPO"
  git -C "$LAB_REPO" cat-file -e "${SUBJECT_COMMIT}^{commit}" 2>/dev/null || \
    refuse "commit $SUBJECT_COMMIT not found in $LAB_REPO"
  SUBJECT_MODE="git archive ${SUBJECT_COMMIT}:experiments/latent-lisp from $LAB_REPO"
  IDENTITY_ROOT="$LAB_REPO/experiments/latent-lisp"
fi

# ------------------------------------------------------------- one runner only
mkdir "$LOCKDIR" 2>/dev/null || void "another p10-runner holds $LOCKDIR (two runner processes at once)"
trap 'rmdir "$LOCKDIR" 2>/dev/null || true' EXIT

STAMP="$(date +%Y%m%dT%H%M%S)"
SUBJECT_BASE="${P10_SUBJECT_BASE:-/tmp/p10-rg0-$STAMP}"
mkdir -p "$SUBJECT_BASE" || refuse "cannot create subject base $SUBJECT_BASE"

# ------------------------------------------------------------------ the header
{
  echo "P10 REAL GATE /0 — RUNNER HEADER"
  echo "date            : $(date --iso-8601=seconds)"
  echo "host            : $(uname -n) $(uname -sr)"
  echo "sbcl            : $SBCL  ($SBCL_VERSION)"
  echo "subject commit  : $SUBJECT_COMMIT"
  echo "subject mode    : $SUBJECT_MODE"
  echo "subject base    : $SUBJECT_BASE"
  echo "prereg          : $PREREG"
  echo "prereg sha256   : $PREREG_SHA  (== frozen)"
  echo "pinned list     : $PINNED"
  echo "pinned rows     : $PINNED_ROWS"
  echo "pinned list sha : $(sha256sum "$PINNED" | cut -d' ' -f1)"
  echo "identity root   : $IDENTITY_ROOT (read-only; the restore check)"
  echo "out dir         : $OUT"
  echo "expect override : ${P10_EXPECT_OVERRIDE:-(none)}"
  echo "harness shas    :"
  for f in mutate.py witness.lisp interposer.lisp p10-classify.sh p10-runner.sh EXPECTATIONS-P10.txt; do
    echo "  $(sha256sum "$HARNESS_DIR/$f" | sed "s#$HARNESS_DIR/##")"
  done
} > "$OUT/RUNNER-HEADER.txt"
cat "$OUT/RUNNER-HEADER.txt"
echo

if [ -n "${P10_EXPECT_OVERRIDE:-}" ]; then
  echo "P10-RUNNER: EXPECT OVERRIDE (verbatim): ${P10_EXPECT_OVERRIDE}"
  echo
fi

expected_for() {
  local c="$1" e
  e="$(grep -E "^${c}[[:space:]]" "$EXPECT_FILE" | awk '{print $2}')"
  if [ -n "${P10_EXPECT_OVERRIDE:-}" ]; then
    local IFS=';'
    for pair in $P10_EXPECT_OVERRIDE; do
      case "$pair" in "${c}="*) e="${pair#*=}" ;; esac
    done
  fi
  printf '%s\n' "$e"
}

# witness target and expectation regexes, per case
witness_target() {
  case "$1" in
    M1-C)        echo "ML0-PRINT-STORE-UNIVERSE" ;;
    M1-U|M1-U-I) echo "ML0-SUBJECT-FIXTURE-ROW" ;;
    M2-P|M2-X|U1-M) echo "ML0-EVIDENCE-PROJECTION-DIGEST" ;;
    *)           echo "" ;;
  esac
}
witness_expect() {
  case "$1" in
    M1-C)        echo 'fboundp=NIL' ;;
    M1-U|M1-U-I) echo 'status=:EXTERNAL fboundp=NIL' ;;
    M2-P|U1-M)   echo 'lambda-list=\(EVIDENCE &KEY DEFECT\)' ;;
    M2-X)        echo 'lambda-list=\(EVIDENCE EXTRA\)' ;;
    *)           echo "" ;;
  esac
}
witness_expect_loader() {
  case "$1" in
    M1-C)                     echo '^LOADER: refused' ;;
    M1-U|M1-U-I|M2-P|M2-X|U1-M) echo '^LOADER: ok' ;;
    *)                        echo "" ;;
  esac
}

pass=0; fail=0; invalid=0; blocked=0; exploratory=0
declare -A CLASS_OF
B0_B12=""; B0_B12NOTE=""; B0_SENT=""
LITERAL_NOTE="walked every external fbound symbol's compiled lambda list"

secondary() {  # secondary <case> <case-dir>  -> echoes SEC-FAIL lines, returns count
  local c="$1" d="$2" n=0
  local out="$d/gate.out.txt"
  local calls inj note12 b12 sent
  calls="$(sed -n 's/^INTERPOSER-CALLS: \([0-9]*\)$/\1/p' "$out" | tail -n1)"
  inj="$(sed -n 's/^INTERPOSER-TARGET-INJECTIONS: \([0-9]*\)$/\1/p' "$out" | tail -n1)"
  b12="$(grep -E '^\[12\] ' "$out" | tail -n1 || true)"
  note12="$(grep -A1 -E '^\[12\] ' "$out" | sed -n '2p' | sed 's/^ *//' || true)"
  sent="$(grep -E '^ml0-block-proof: ' "$out" | tail -n1 || true)"
  chk() { # chk <label> <got> <want>
    if [ "$2" = "$3" ]; then echo "SEC-OK $c: $1 = $2"
    else echo "SEC-FAIL $c: $1 = '${2:-(absent)}', expected '$3'"; n=$((n+1)); fi
  }
  case "$c" in
    B0)
      chk "[12] note is the literal" "$note12" "$LITERAL_NOTE" ;;
    B0-I)
      chk "interposer calls" "$calls" "314"
      chk "target injections" "$inj" "0"
      chk "[12] line identical to B0's" "$b12" "$B0_B12"
      chk "[12] note identical to B0's" "$note12" "$B0_B12NOTE"
      chk "sentinel identical to B0's" "$sent" "$B0_SENT" ;;
    M1-U)
      chk "[12] note is the literal" "$note12" "$LITERAL_NOTE" ;;
    M1-U-I)
      chk "interposer calls" "$calls" "312"
      chk "target injections" "$inj" "0" ;;
    M2-P)
      if printf '%s\n' "$note12" | grep -q 'ML0-EVIDENCE-PROJECTION-DIGEST'; then
        echo "SEC-OK $c: [12] note names ML0-EVIDENCE-PROJECTION-DIGEST"
      else
        echo "SEC-FAIL $c: [12] note does not name ML0-EVIDENCE-PROJECTION-DIGEST: '$note12'"
        n=$((n+1))
      fi ;;
    U1)
      chk "interposer calls" "$calls" "313"
      chk "target injections" "$inj" "1"
      chk "[12] note is the literal" "$note12" "$LITERAL_NOTE"
      if grep -q '^INJECTED-INTROSPECTION-ERROR: ML0-WRITE$' "$out"; then
        echo "SEC-OK $c: INJECTED-INTROSPECTION-ERROR: ML0-WRITE printed"
      else
        echo "SEC-FAIL $c: no 'INJECTED-INTROSPECTION-ERROR: ML0-WRITE' line"; n=$((n+1))
      fi ;;
    U1-M)
      chk "target injections" "$inj" "1"
      chk "[12] status is CLOSED with the literal note" "$note12" "$LITERAL_NOTE"
      case "$b12" in '[12] CLOSED'*) echo "SEC-OK $c: [12] is CLOSED";;
        *) echo "SEC-FAIL $c: [12] is not CLOSED: '$b12'"; n=$((n+1));; esac ;;
  esac
  return $n
}

# ---------------------------------------------------------------- the case loop
for c in $CASES; do
  echo "================ $c ================"
  D="$OUT/$c"; mkdir -p "$D"
  S="$SUBJECT_BASE/$c"
  rm -rf "$S"; mkdir -p "$S"

  # ---- fresh disposable subject
  if [ -n "${P10_SUBJECT_TREE:-}" ]; then
    cp -a "$SUBJECT_TREE"/. "$S"/ || void "$c: subject copy failed"
  else
    git -C "$LAB_REPO" archive "${SUBJECT_COMMIT}:experiments/latent-lisp" \
      | tar -x -C "$S" || void "$c: git archive extraction failed"
  fi
  echo "$c: subject at $S"

  # ---- the pinned 70 shas, BEFORE mutation
  if ( cd "$S" && sha256sum -c "$PINNED" ) > "$D/pinned-check.txt" 2>&1; then
    echo "$c: pinned closure verified ($PINNED_ROWS files OK)"
  else
    tail -n 20 "$D/pinned-check.txt"
    void "$c: pinned closure MISMATCH before mutation (see $D/pinned-check.txt)"
  fi

  # ---- the mutation
  P10_PINNED="$PINNED" P10_LAB_REPO="${P10_LAB_REPO:-$LAB_REPO}" \
    python3 "$HARNESS_DIR/mutate.py" "$c" "$S" > "$D/mutate.out.txt" 2>&1
  MRC=$?
  cat "$D/mutate.out.txt"
  if [ "$MRC" -ne 0 ]; then void "$c: mutate.py refused (exit $MRC)"; fi
  cp "$S/MUTATION-DIFF.txt" "$D/MUTATION-DIFF.txt"

  # ---- the witness (fresh process, same subject)
  WT="$(witness_target "$c")"
  if [ -n "$WT" ]; then
    ( cd "$S" && "$SBCL" --script "$HARNESS_DIR/witness.lisp" \
        mneme/memory-layer-0 "$WT" ) \
      > "$D/witness.out.txt" 2> "$D/witness.err.txt"
    echo "EXIT $?" > "$D/witness.exit.txt"
    witness_expect "$c" > "$D/WITNESS-EXPECT.txt"
    witness_expect_loader "$c" > "$D/WITNESS-EXPECT-LOADER.txt"
    grep -E '^(LOADER|WITNESS): ' "$D/witness.out.txt" || true
  fi

  # ---- the gate (fresh process, strictly one at a time)
  case "$c" in
    B0|M1-C|M1-U|M2-P|M2-X)
      ( cd "$S" && "$SBCL" --script mneme/memory-layer-0/ml0-block-proof.lisp ) \
        > "$D/gate.out.txt" 2> "$D/gate.err.txt"
      echo "EXIT $?" > "$D/gate.exit.txt"
      echo "$c: gate entry = normal (sbcl --script mneme/memory-layer-0/ml0-block-proof.lisp)" \
        > "$D/gate.entry.txt" ;;
    B0-I|M1-U-I)
      ( cd "$S" && env -u P10_TARGET "$SBCL" --script "$HARNESS_DIR/interposer.lisp" ) \
        > "$D/gate.out.txt" 2> "$D/gate.err.txt"
      echo "EXIT $?" > "$D/gate.exit.txt"
      echo "$c: gate entry = interposer, NO target (counting control)" > "$D/gate.entry.txt" ;;
    U1)
      ( cd "$S" && P10_TARGET=ML0-WRITE "$SBCL" --script "$HARNESS_DIR/interposer.lisp" ) \
        > "$D/gate.out.txt" 2> "$D/gate.err.txt"
      echo "EXIT $?" > "$D/gate.exit.txt"
      echo "$c: gate entry = interposer, P10_TARGET=ML0-WRITE" > "$D/gate.entry.txt" ;;
    U1-M)
      ( cd "$S" && P10_TARGET=ML0-EVIDENCE-PROJECTION-DIGEST \
          "$SBCL" --script "$HARNESS_DIR/interposer.lisp" ) \
        > "$D/gate.out.txt" 2> "$D/gate.err.txt"
      echo "EXIT $?" > "$D/gate.exit.txt"
      echo "$c: gate entry = interposer, P10_TARGET=ML0-EVIDENCE-PROJECTION-DIGEST" \
        > "$D/gate.entry.txt" ;;
  esac
  cat "$D/gate.entry.txt"

  # ---- classify
  EXP="$(expected_for "$c")"
  bash "$HARNESS_DIR/p10-classify.sh" "$D" "$EXP" > "$D/classify.txt" 2>&1
  CRC=$?
  cat "$D/classify.txt"
  CLS="$(sed -n "s/^CLASS $c: //p" "$D/classify.txt" | tail -n1)"
  CLASS_OF[$c]="$CLS"

  if [ "$c" = "B0" ]; then
    B0_B12="$(grep -E '^\[12\] ' "$D/gate.out.txt" | tail -n1 || true)"
    B0_B12NOTE="$(grep -A1 -E '^\[12\] ' "$D/gate.out.txt" | sed -n '2p' | sed 's/^ *//' || true)"
    B0_SENT="$(grep -E '^ml0-block-proof: ' "$D/gate.out.txt" | tail -n1 || true)"
  fi

  # ---- secondary checks (a failed secondary check is a FAIL line)
  SECN=0
  secondary "$c" "$D" > "$D/secondary.txt" 2>&1 || SECN=$?
  cat "$D/secondary.txt"

  # ---- the verdict for this case
  if [ "$EXP" = "EXPLORATORY" ] && [ "$CRC" -ne 3 ]; then
    exploratory=$((exploratory+1))
    if [ "$SECN" -gt 0 ]; then
      echo "FAIL $c: $SECN secondary check(s) failed"; fail=$((fail+1))
    fi
  elif [ "$CRC" -eq 3 ]; then
    invalid=$((invalid+1))
  elif [ "$CRC" -eq 0 ] && [ "$SECN" -eq 0 ]; then
    pass=$((pass+1))
  else
    if [ "$CRC" -eq 0 ] && [ "$SECN" -gt 0 ]; then
      echo "FAIL $c: class $CLS matched but $SECN secondary check(s) failed"
    fi
    fail=$((fail+1))
    case "$CLS" in
      BLOCKED-AT-LOADER|VOID-ENV|CRASH-MID-GATE)
        if [ "$CLS" != "$EXP" ]; then
          echo "BLOCKED $c: $CLS before the gate's first probe, and not this case's expectation ($EXP)"
          blocked=$((blocked+1))
        fi ;;
    esac
  fi
  echo
done

# --------------------------------------------------- IDENTITY-AFTER (the restore)
{
  echo "IDENTITY AFTER — the pinned closure re-verified against the read-only"
  echo "identity root, after all runs (PREREG §0, 'the restore')."
  echo "root : $IDENTITY_ROOT"
  echo "list : $PINNED ($PINNED_ROWS rows)"
  echo "date : $(date --iso-8601=seconds)"
  echo "---- sha256sum -c ----"
  ( cd "$IDENTITY_ROOT" && sha256sum -c "$PINNED" ) 2>&1
  echo "EXIT $?"
} > "$OUT/IDENTITY-AFTER.txt"
IDENT_FAILS="$(grep -c 'FAILED' "$OUT/IDENTITY-AFTER.txt" || true)"
echo "IDENTITY-AFTER: $( [ "$IDENT_FAILS" -eq 0 ] && echo 'all pinned files unchanged' || echo "MISMATCH ($IDENT_FAILS lines)" )"

# ------------------------------------------------------------------- the summary
{
  echo "P10-RUNNER: pass=$pass fail=$fail invalid=$invalid blocked=$blocked"
  echo "P10-RUNNER: exploratory=$exploratory (M2-X, neither PASS nor FAIL)"
  for c in $CASES; do printf 'P10-RUNNER: %-8s -> %s\n' "$c" "${CLASS_OF[$c]:-(none)}"; done
} | tee "$OUT/SUMMARY.txt"

[ "$fail" -eq 0 ] && [ "$invalid" -eq 0 ] && exit 0
exit 1
