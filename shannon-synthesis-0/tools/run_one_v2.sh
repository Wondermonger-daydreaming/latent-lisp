#!/usr/bin/env bash
# run_one_v2.sh TARGET K V OUTDIR   (v2: writes a .witness-ref before deleting a verified proof; KEEP_CORE=<dir> keeps a zstd core LRAT off-tree) — one instance: encode, solve (DRAT), check UNSAT proof, decode SAT model.
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
      if grep -q "s VERIFIED" "$P.drat-trim.log"; then
        PC=VERIFIED
        # witness-ref: hash + size + recipe BEFORE the file goes (a verified proof is regenerable; the record is the evidence)
        { echo "proof_sha256 $(sha256sum "$P.drat" | cut -d' ' -f1)"; echo "proof_bytes $(stat -c %s "$P.drat")";
          echo "cnf_sha256 $(sha256sum "$P.cnf" | cut -d' ' -f1)"; echo "solver_sha256 $(sha256sum "$CADICAL" | cut -d' ' -f1)";
          echo "solver_version $("$CADICAL" --version)"; echo "checker_sha256 $(sha256sum "$DRAT" | cut -d' ' -f1)";
          echo "command $CADICAL --binary=false $P.cnf $P.drat"; echo "seconds $SEC"; echo "verified_at $(date '+%Y-%m-%dT%H:%M:%S%:z')"; } > "$P.witness-ref"
        if [ -n "${KEEP_CORE:-}" ]; then   # core LRAT, zstd, off-tree
          mkdir -p "$KEEP_CORE"; "$DRAT" "$P.cnf" "$P.drat" -l "$P.core.lrat" > "$P.drat-trim-core.log" 2>&1
          zstd -q -f -19 -T4 "$P.core.lrat" -o "$KEEP_CORE/$(basename "$P").core.lrat.zst"; rm -f "$P.core.lrat"
          sha256sum "$KEEP_CORE/$(basename "$P").core.lrat.zst" > "$KEEP_CORE/$(basename "$P").core.lrat.zst.sha256"
          echo "core_lrat_zst $KEEP_CORE/$(basename "$P").core.lrat.zst" >> "$P.witness-ref"
        fi
        rm -f "$P.drat"
      else PC=NOT_VERIFIED; fi ;;
  *)  RES="EXIT$RC"; PC=n/a ;;
esac
echo -e "$V\t$VARS\t$CLS\t$RES\t$PC\t$SEC" | tee "$OUT/summary.V$V.tsv"
