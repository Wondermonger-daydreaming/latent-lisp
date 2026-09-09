#!/usr/bin/env bash
# regen_witness_refs.sh — regenerate the K=12 UNSAT witness-refs under run_one_v2.sh (lex encoding), cheap counts first,
# then V=10 and V=8 niced.  Astra's receipt (2026-09-08 00:29): "verified-in-run-record" ≠ "verification-witness-retained".
set -u; cd "$(dirname "$0")/.." || exit 1
OUT=evidence/A_K12_lex_v2; mkdir -p "$OUT"
for V in 2 3 4 5 6 7 11 12 13; do SYMBREAK=lex KEEP_CORE=~/freezer/shannon-synthesis-0 tools/run_one_v2.sh A 12 $V "$OUT"; done
echo "cheap counts done $(date '+%Y-%m-%dT%H:%M:%S%:z')"
for V in 10 8; do SYMBREAK=lex KEEP_CORE=~/freezer/shannon-synthesis-0 nice -n 10 tools/run_one_v2.sh A 12 $V "$OUT"; done
echo "all done $(date '+%Y-%m-%dT%H:%M:%S%:z')"
