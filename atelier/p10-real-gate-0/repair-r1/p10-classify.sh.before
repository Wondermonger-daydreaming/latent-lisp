#!/usr/bin/env bash
# p10-classify.sh <case-dir> <expected-class>
#
# PREREG-P10-RG-0 §3/§5 classifier.  Reads, from <case-dir>:
#   gate.out.txt gate.err.txt gate.exit.txt  (the last containing "EXIT n")
#   witness.out.txt witness.exit.txt         (optional)
#   WITNESS-EXPECT.txt                       (optional: regex the WITNESS line must match)
#   WITNESS-EXPECT-LOADER.txt                (optional: regex the LOADER line must match)
# Interposer counts, when present, are read out of gate.out.txt.
#
# Assigns EXACTLY ONE class from the closed set:
#   GATE-GREEN GATE-OPEN-F1 GATE-OPEN-OTHER BLOCKED-AT-LOADER CRASH-MID-GATE
#   VOID-ENV INCOHERENT
# Prints CLASS/DETAIL/SENTINEL/EXIT/COUNTS/NOTE lines, then one verdict:
#   PASS <case>: <class>                                     -> exit 0
#   FAIL <case>: got '<class>' expected '<expected>'         -> exit 1
#   INVALID <case>: witness ...                              -> exit 3
# Usable standalone on a synthetic <case-dir>.

set -u

if [ "$#" -ne 2 ]; then
  echo "usage: p10-classify.sh <case-dir> <expected-class>" >&2
  exit 2
fi
DIR="$1"
EXPECTED="$2"
CASE="$(basename "$DIR")"

for f in gate.out.txt gate.err.txt gate.exit.txt; do
  if [ ! -f "$DIR/$f" ]; then
    echo "INVALID $CASE: classifier input $f absent in $DIR"
    exit 3
  fi
done

OUT="$DIR/gate.out.txt"
ERR="$DIR/gate.err.txt"

# ---- exit code
EXITLINE="$(cat "$DIR/gate.exit.txt")"
EXITCODE="$(printf '%s\n' "$EXITLINE" | sed -n 's/^EXIT \([0-9][0-9]*\)$/\1/p' | tail -n1)"
if [ -z "$EXITCODE" ]; then
  echo "INVALID $CASE: gate.exit.txt does not hold a single 'EXIT n' line (got '$EXITLINE')"
  exit 3
fi

# ---- sentinel and [n] lines
SENT_RE='^ml0-block-proof: [0-9]+ probes, [0-9]+ closed, [0-9]+ open$'
SENT_N="$(grep -cE "$SENT_RE" "$OUT" || true)"
SENT_LINE="$(grep -E "$SENT_RE" "$OUT" | tail -n1 || true)"
B12_N="$(grep -cE '^\[12\] ' "$OUT" || true)"
B12_LINE="$(grep -E '^\[12\] ' "$OUT" | tail -n1 || true)"
B12_NOTE="$(grep -A1 -E '^\[12\] ' "$OUT" | sed -n '2p' | sed 's/^ *//' || true)"
ANY_N="$(grep -cE '^\[[0-9]+\] ' "$OUT" || true)"
FIRST_PROBE_N="$(grep -cE '^\[1\] ' "$OUT" || true)"
LATE_UNHANDLED="$(grep -cE 'Unhandled' "$ERR" || true)"
LOADER_FAIL="$(grep -ciE 'ML0-LANE-INCOMPLETE|LANE LOAD DID NOT COMPLETE|Shortfall:' "$ERR" || true)"

PROBES=""; CLOSED=""; OPEN=""
if [ "$SENT_N" -ge 1 ]; then
  PROBES="$(printf '%s\n' "$SENT_LINE" | sed -n 's/^ml0-block-proof: \([0-9]*\) probes.*/\1/p')"
  CLOSED="$(printf '%s\n' "$SENT_LINE" | sed -n 's/.* \([0-9]*\) closed.*/\1/p')"
  OPEN="$(printf '%s\n' "$SENT_LINE" | sed -n 's/.* \([0-9]*\) open$/\1/p')"
fi
B12_STATUS=""
case "$B12_LINE" in
  '[12] CLOSED'*) B12_STATUS=CLOSED ;;
  '[12] OPEN'*)   B12_STATUS=OPEN ;;
esac

# ---- interposer counts
CALLS="$(sed -n 's/^INTERPOSER-CALLS: \([0-9]*\)$/\1/p' "$OUT" | tail -n1 || true)"
INJ="$(sed -n 's/^INTERPOSER-TARGET-INJECTIONS: \([0-9]*\)$/\1/p' "$OUT" | tail -n1 || true)"

NOTES=()

# ---- classification: exactly one class, in the prereg's order
CLASS=""
if [ "$EXITCODE" = "4" ]; then
  CLASS="VOID-ENV"
elif [ "$SENT_N" -eq 0 ]; then
  if [ "$LOADER_FAIL" -ge 1 ] && [ "$EXITCODE" != "0" ] && [ "$FIRST_PROBE_N" -eq 0 ]; then
    CLASS="BLOCKED-AT-LOADER"
  elif [ "$ANY_N" -ge 1 ] && [ "$EXITCODE" != "0" ]; then
    CLASS="CRASH-MID-GATE"
  else
    CLASS="INCOHERENT"
    NOTES+=("no sentinel and no class fits: loader-fail=$LOADER_FAIL probe-lines=$ANY_N exit=$EXITCODE")
  fi
elif [ "$SENT_N" -ne 1 ]; then
  CLASS="INCOHERENT"; NOTES+=("$SENT_N sentinel lines, expected exactly 1")
elif [ "$B12_N" -ne 1 ]; then
  CLASS="INCOHERENT"; NOTES+=("$B12_N '[12]' lines, expected exactly 1")
elif [ -z "$B12_STATUS" ]; then
  CLASS="INCOHERENT"; NOTES+=("the '[12]' line is neither CLOSED nor OPEN")
elif [ "$LATE_UNHANDLED" -ge 1 ]; then
  CLASS="INCOHERENT"
  NOTES+=("a sentinel printed AND stderr carries 'Unhandled' (a late error)")
elif [ "$OPEN" = "0" ] && [ "$EXITCODE" = "0" ] && [ "$B12_STATUS" = "CLOSED" ]; then
  if [ "$PROBES" != "20" ] || [ "$CLOSED" != "$PROBES" ]; then
    CLASS="INCOHERENT"
    NOTES+=("all-closed sentinel but not '20 probes, 20 closed, 0 open': $SENT_LINE")
  else
    CLASS="GATE-GREEN"
  fi
elif [ "$OPEN" = "0" ] && [ "$EXITCODE" != "0" ]; then
  CLASS="INCOHERENT"
  NOTES+=("sentinel reports 0 open but the process exited $EXITCODE")
elif [ "$OPEN" != "0" ] && [ "$EXITCODE" = "0" ]; then
  CLASS="INCOHERENT"
  NOTES+=("sentinel reports $OPEN open but the process exited 0")
elif [ "$B12_STATUS" = "OPEN" ]; then
  if [ "$EXITCODE" != "1" ]; then
    CLASS="INCOHERENT"; NOTES+=("[12] OPEN but exit $EXITCODE, expected 1")
  else
    CLASS="GATE-OPEN-F1"
    [ "$OPEN" = "1" ] || NOTES+=("[12] is OPEN and so are $(( OPEN - 1 )) other probe(s)")
  fi
elif [ "$B12_STATUS" = "CLOSED" ]; then
  if [ "$EXITCODE" != "1" ]; then
    CLASS="INCOHERENT"; NOTES+=("$OPEN open, [12] CLOSED, but exit $EXITCODE, expected 1")
  else
    CLASS="GATE-OPEN-OTHER"
  fi
else
  CLASS="INCOHERENT"; NOTES+=("unreachable classifier state")
fi

# ---- reporting lines
echo "CLASS $CASE: $CLASS"
echo "SENTINEL $CASE: ${SENT_LINE:-(none)}"
echo "DETAIL $CASE: ${B12_LINE:-(no [12] line)}"
if [ -n "$B12_NOTE" ]; then echo "NOTE12 $CASE: $B12_NOTE"; fi
echo "EXIT $CASE: $EXITCODE"
if [ -n "$CALLS" ] || [ -n "$INJ" ]; then
  echo "COUNTS $CASE: calls=${CALLS:-?} injections=${INJ:-?}"
fi
for n in ${NOTES+"${NOTES[@]}"}; do echo "NOTE $CASE: $n"; done

# ---- witness gate (§4/§5: a failing witness is INVALID, never PASS)
if [ -f "$DIR/witness.out.txt" ]; then
  WLINE="$(grep -E '^WITNESS: ' "$DIR/witness.out.txt" | tail -n1 || true)"
  LLINE="$(grep -E '^LOADER: ' "$DIR/witness.out.txt" | tail -n1 || true)"
  WEXIT=""
  if [ -f "$DIR/witness.exit.txt" ]; then
    WEXIT="$(sed -n 's/^EXIT \([0-9][0-9]*\)$/\1/p' "$DIR/witness.exit.txt" | tail -n1)"
  fi
  echo "WITNESS $CASE: ${WLINE:-(no WITNESS line)}"
  echo "WLOADER $CASE: ${LLINE:-(no LOADER line)}"
  echo "WEXIT $CASE: ${WEXIT:-(none)}"
  if [ -z "$WLINE" ]; then
    echo "INVALID $CASE: witness printed no WITNESS: line"; exit 3
  fi
  if [ "$WEXIT" != "0" ]; then
    echo "INVALID $CASE: witness exited '${WEXIT:-none}', expected 0"; exit 3
  fi
  if [ -f "$DIR/WITNESS-EXPECT.txt" ]; then
    WRE="$(head -n1 "$DIR/WITNESS-EXPECT.txt")"
    if ! printf '%s\n' "$WLINE" | grep -qE -- "$WRE"; then
      echo "INVALID $CASE: witness line does not match /$WRE/"; exit 3
    fi
  fi
  if [ -f "$DIR/WITNESS-EXPECT-LOADER.txt" ]; then
    LRE="$(head -n1 "$DIR/WITNESS-EXPECT-LOADER.txt")"
    if ! printf '%s\n' "$LLINE" | grep -qE -- "$LRE"; then
      echo "INVALID $CASE: witness LOADER line does not match /$LRE/"; exit 3
    fi
  fi
fi

# ---- verdict
if [ "$EXPECTED" = "EXPLORATORY" ]; then
  # PREREG §3, M2-X: no source-supported expectation exists.  The class is
  # RECORDED, and is neither PASS nor FAIL; a failing witness above is still
  # INVALID (exit 3), because the mutation must still have reached the check.
  echo "EXPLORATORY $CASE: $CLASS"
  exit 0
fi
if [ "$CLASS" = "$EXPECTED" ]; then
  echo "PASS $CASE: $CLASS"
  exit 0
fi
echo "FAIL $CASE: got '$CLASS' expected '$EXPECTED'"
exit 1
