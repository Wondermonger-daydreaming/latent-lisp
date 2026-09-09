#!/usr/bin/env bash
# finish_v9.sh — after the FIRST of the two V=9 runs (lex, lex+varsym) reaches a verdict:
#   UNSAT VERIFIED → witness-ref from the hardlinked proof, core LRAT → zstd → ~/freezer, delete the raw; kill the other run
#   SAT            → decode already done by the runner; keep everything, kill the other run, print loudly
#   anything else  → leave both running, print
set -u
cd "$(dirname "$0")/.." || exit 1
DRAT="$SAT/drat-trim/drat-trim"; CADICAL="$SAT/cadical/build/cadical"; KEEP=~/freezer/shannon-synthesis-0; mkdir -p "$KEEP"
until [ -f evidence/A_K12_lex/summary.V9.tsv ] || [ -f evidence/A_K12_lexvs/summary.V9.tsv ]; do sleep 60; done
for d in A_K12_lex A_K12_lexvs; do
  f=evidence/$d/summary.V9.tsv; [ -f "$f" ] || continue
  RES=$(cut -f4 "$f"); PC=$(cut -f5 "$f"); P=evidence/$d/A_K12_V9
  echo "$(date '+%Y-%m-%dT%H:%M:%S%:z') $d V9 $RES $PC"
  if [ "$RES" = UNSAT ] && [ "$PC" = VERIFIED ]; then
    OTHER=$([ "$d" = A_K12_lex ] && echo A_K12_lexvs || echo A_K12_lex)
    pid=$(pgrep -f "evidence/$OTHER/A_K12_V9.cnf" | head -1); [ -n "$pid" ] && kill "$pid" && echo "killed redundant $OTHER V9 ($pid)"
    rm -f evidence/$OTHER/A_K12_V9.drat evidence/$OTHER/A_K12_V9.drat.keep
    { echo "proof_sha256 $(sha256sum "$P.drat.keep" | cut -d' ' -f1)"; echo "proof_bytes $(stat -c %s "$P.drat.keep")";
      echo "cnf_sha256 $(sha256sum "$P.cnf" | cut -d' ' -f1)"; echo "solver_sha256 $(sha256sum "$CADICAL" | cut -d' ' -f1)";
      echo "solver_version $("$CADICAL" --version)"; echo "checker_sha256 $(sha256sum "$DRAT" | cut -d' ' -f1)";
      echo "command $CADICAL --binary=false $P.cnf $P.drat"; echo "seconds $(cut -f6 "$f")"; echo "verified_at $(date '+%Y-%m-%dT%H:%M:%S%:z')"; } > "$P.witness-ref"
    echo "witness-ref written; core-trimming (hours)…"
    "$DRAT" "$P.cnf" "$P.drat.keep" -l "$P.core.lrat" > "$P.drat-trim-core.log" 2>&1
    if grep -q "s VERIFIED" "$P.drat-trim-core.log"; then
      zstd -q -19 -T8 "$P.core.lrat" -o "$KEEP/A_K12_V9.core.lrat.zst" && rm -f "$P.core.lrat"
      sha256sum "$KEEP/A_K12_V9.core.lrat.zst" > "$KEEP/A_K12_V9.core.lrat.zst.sha256"
      echo "core_lrat_zst $KEEP/A_K12_V9.core.lrat.zst $(stat -c %s "$KEEP/A_K12_V9.core.lrat.zst") bytes" >> "$P.witness-ref"
      rm -f "$P.drat.keep" "$P.drat"
      echo "DONE: raw proof deleted; core kept at $KEEP; record in $P.witness-ref"
    else
      echo "CORE TRIM DID NOT VERIFY — raw proof KEPT at $P.drat.keep for inspection"
    fi
    exit 0
  elif [ "$RES" = SAT ]; then
    echo "!!! V=9 SAT under $d — a 12-contact network exists; net at $P.net.json; NOT deleting anything"
    exit 0
  fi
done
echo "V9 verdict present but not UNSAT/VERIFIED or SAT — inspect evidence/*/summary.V9.tsv"; exit 1
