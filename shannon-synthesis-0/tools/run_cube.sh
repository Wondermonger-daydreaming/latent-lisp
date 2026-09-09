#!/usr/bin/env bash
# run_cube.sh TARGET K V CUBE OUTDIR — one cube (exact per-variable contact counts) of the lex+varsym instance, BINARY DRAT,
# drat-trim check, witness-ref written before the verified proof is deleted.  Appends a line to OUTDIR/cube.<CUBE>.tsv:
#   cube  vars  clauses  result  proof_check  seconds  proof_bytes
set -u
T="$1"; K="$2"; V="$3"; C="$4"; OUT="$5"
CADICAL="${CADICAL:-$SAT/cadical/build/cadical}"; DRAT="${DRAT:-$SAT/drat-trim/drat-trim}"
HERE="$(cd "$(dirname "$0")" && pwd)"; mkdir -p "$OUT"
TAG="${C//,/-}"; P="$OUT/${T}_K${K}_V${V}_cube${TAG}"
python3 "$HERE/sat_search.py" encode --target "$T" --V "$V" --K "$K" --symbreak lex --varsym --cube "$C" --out "$P.cnf" --meta "$P.json" > "$P.encode.log"
VARS=$(head -1 "$P.cnf" | awk '{print $3}'); CLS=$(head -1 "$P.cnf" | awk '{print $4}')
S=$(date +%s.%N)
"$CADICAL" --binary=true "$P.cnf" "$P.drat" > "$P.model" 2>&1; RC=$?
E=$(date +%s.%N); SEC=$(python3 -c "print(round($E-$S,2))")
BYTES=$(stat -c %s "$P.drat" 2>/dev/null || echo 0)
case $RC in
  10) RES=SAT; PC=n/a
      python3 "$HERE/sat_search.py" decode --meta "$P.json" --model "$P.model" --out "$P.net.json" >> "$P.encode.log"; rm -f "$P.drat" ;;
  20) RES=UNSAT
      "$DRAT" "$P.cnf" "$P.drat" > "$P.drat-trim.log" 2>&1
      if grep -q "s VERIFIED" "$P.drat-trim.log"; then
        PC=VERIFIED
        { echo "cube $C"; echo "proof_sha256 $(sha256sum "$P.drat" | cut -d' ' -f1)"; echo "proof_bytes $BYTES"; echo "proof_format binary-drat";
          echo "cnf_sha256 $(sha256sum "$P.cnf" | cut -d' ' -f1)"; echo "solver_sha256 $(sha256sum "$CADICAL" | cut -d' ' -f1)";
          echo "solver_version $("$CADICAL" --version)"; echo "checker_sha256 $(sha256sum "$DRAT" | cut -d' ' -f1)";
          echo "command $CADICAL --binary=true $P.cnf $P.drat"; echo "seconds $SEC"; echo "verified_at $(date '+%Y-%m-%dT%H:%M:%S%:z')"; } > "$P.witness-ref"
        rm -f "$P.drat"
      else PC=NOT_VERIFIED; fi ;;
  *)  RES="EXIT$RC"; PC=n/a ;;
esac
echo -e "$C\t$VARS\t$CLS\t$RES\t$PC\t$SEC\t$BYTES" | tee "$OUT/cube.$TAG.tsv"
