#!/usr/bin/env bash
# run_one.sh TARGET K V OUTDIR — one instance: encode, solve (DRAT), check UNSAT proof, decode SAT model.
# Appends one line to OUTDIR/summary.V.tsv (V, vars, clauses, result, proof_check, seconds). Keeps the proof
# only if drat-trim did NOT verify it (so a failure can be inspected).
set -u
T="$1"; K="$2"; V="$3"; OUT="$4"
CADICAL="${CADICAL:-$SAT/cadical/build/cadical}"; DRAT="${DRAT:-$SAT/drat-trim/drat-trim}"
HERE="$(cd "$(dirname "$0")" && pwd)"
mkdir -p "$OUT"
P="$OUT/${T}_K${K}_V${V}"
python3 "$HERE/sat_search.py" encode --target "$T" --V "$V" --K "$K" --symbreak "${SYMBREAK:-bfs}" ${VARSYM:+--varsym} --out "$P.cnf" --meta "$P.json" > "$P.encode.log"
VARS=$(head -1 "$P.cnf" | awk '{print $3}'); CLS=$(head -1 "$P.cnf" | awk '{print $4}')
S=$(date +%s.%N)
"$CADICAL" --binary=false "$P.cnf" "$P.drat" > "$P.model" 2>&1; RC=$?
E=$(date +%s.%N); SEC=$(python3 -c "print(round($E-$S,2))")
case $RC in
  10) RES=SAT; PC=n/a
      python3 "$HERE/sat_search.py" decode --meta "$P.json" --model "$P.model" --out "$P.net.json" >> "$P.encode.log"; rm -f "$P.drat" ;;
  20) RES=UNSAT
      "$DRAT" "$P.cnf" "$P.drat" > "$P.drat-trim.log" 2>&1
      if grep -q "s VERIFIED" "$P.drat-trim.log"; then PC=VERIFIED; rm -f "$P.drat"; else PC=NOT_VERIFIED; fi ;;
  *)  RES="EXIT$RC"; PC=n/a ;;
esac
echo -e "$V\t$VARS\t$CLS\t$RES\t$PC\t$SEC" | tee "$OUT/summary.V$V.tsv"
