#!/usr/bin/env bash
# run_search.sh TARGET K OUTDIR [CADICAL] [DRATTRIM]
# For every V in 2..K+1: encode, solve with CaDiCaL writing a DRAT proof, check UNSAT proofs with drat-trim,
# decode SAT models to net.json. Writes OUTDIR/summary.tsv (V, vars, clauses, result, proof-check, seconds).
set -u
T="$1"; K="$2"; OUT="$3"
CADICAL="${4:-$SAT/cadical/build/cadical}"; DRAT="${5:-$SAT/drat-trim/drat-trim}"
HERE="$(cd "$(dirname "$0")" && pwd)"
mkdir -p "$OUT"
echo -e "V\tvars\tclauses\tresult\tproof_check\tseconds" > "$OUT/summary.tsv"
for V in $(seq 2 $((K+1))); do
  P="$OUT/${T}_K${K}_V${V}"
  python3 "$HERE/sat_search.py" encode --target "$T" --V "$V" --K "$K" --out "$P.cnf" --meta "$P.json" > "$P.encode.log"
  VARS=$(head -1 "$P.cnf" | awk '{print $3}'); CLS=$(head -1 "$P.cnf" | awk '{print $4}')
  S=$(date +%s.%N)
  "$CADICAL" --binary=false "$P.cnf" "$P.drat" > "$P.model" 2>&1; RC=$?
  E=$(date +%s.%N); SEC=$(python3 -c "print(round($E-$S,2))")
  case $RC in
    10) RES=SAT;   PC=n/a
        python3 "$HERE/sat_search.py" decode --meta "$P.json" --model "$P.model" --out "$P.net.json" >> "$P.encode.log" ;;
    20) RES=UNSAT
        "$DRAT" "$P.cnf" "$P.drat" > "$P.drat-trim.log" 2>&1
        if grep -q "s VERIFIED" "$P.drat-trim.log"; then PC=VERIFIED; else PC=NOT_VERIFIED; fi ;;
    *)  RES="EXIT$RC"; PC=n/a ;;
  esac
  echo -e "$V\t$VARS\t$CLS\t$RES\t$PC\t$SEC" | tee -a "$OUT/summary.tsv"
  rm -f "$P.drat"   # proofs are large; the drat-trim log is the record (re-run to regenerate)
done
