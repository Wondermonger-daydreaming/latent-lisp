#!/usr/bin/env bash
# reclassify.sh — RECLASSIFICATION, not fresh Lisp execution (Astra's adjudication §5.1–5.2, 2026-09-15).
# Replays the RETAINED transcripts of the recorded run and the existing controls through the REPAIRED classifier, then feeds it the
# rejection specimens (Astra's R1a/R1b and their twins) and a witness-free baseline that must still be accepted. No gate runs.
#   reclassify.sh <atelier-dir> <out-dir>
set -u
A="$(cd "$1" && pwd)"; OUT="$2"; mkdir -p "$OUT"; CL="$A/harness/p10-classify.sh"; REAL="$(ls -d "$A"/runs/*-real | tail -n1)"
EXP="$A/harness/EXPECTATIONS-P10.txt"
expected_for(){ grep -E "^$1[[:space:]]" "$EXP" | awk '{print $2}'; }
echo "RECLASSIFICATION — $(date --iso-8601=seconds) · classifier sha256 $(sha256sum "$CL" | cut -c1-16)… · source run $(basename "$REAL") (transcripts copied, never modified)"
ok=0; bad=0
run(){ # run <label> <dir> <expected> <want-verdict-word> <want-exit>
  local label="$1" dir="$2" exp="$3" want="$4" wexit="$5" got vexit
  bash "$CL" "$dir" "$exp" > "$OUT/$label.txt" 2>&1; vexit=$?
  got="$(grep -oE '^(PASS|FAIL|INVALID|EXPLORATORY) ' "$OUT/$label.txt" | tail -n1 | tr -d ' ')"
  if [ "$got" = "$want" ] && [ "$vexit" = "$wexit" ]; then echo "OK   $label: $got (exit $vexit) — $(grep -m1 -E '^(CLASS|INVALID)' "$OUT/$label.txt" | cut -c1-150)"; ok=$((ok+1))
  else echo "BAD  $label: got '$got' exit $vexit, wanted '$want' exit $wexit — $(tail -n1 "$OUT/$label.txt" | cut -c1-150)"; bad=$((bad+1)); fi
}
echo "--- 1. the nine retained real cases (copies)"
for c in B0 B0-I M1-C M1-U M1-U-I M2-P M2-X U1 U1-M; do
  rm -rf "$OUT/real/$c"; mkdir -p "$OUT/real"; cp -a "$REAL/$c" "$OUT/real/$c"
  e="$(expected_for $c)"; if [ "$e" = "EXPLORATORY" ]; then run "real-$c" "$OUT/real/$c" "$e" EXPLORATORY 0; else run "real-$c" "$OUT/real/$c" "$e" PASS 0; fi
done
echo "--- 2. the existing synthetic controls (retained dirs)"
C3="$(ls -d "$A"/runs/*-control-C-3 | tail -n1)"; C4="$(ls -d "$A"/runs/*-control-C-4 | tail -n1)"
rm -rf "$OUT/ctl"; mkdir -p "$OUT/ctl/C-3" "$OUT/ctl/C-4"; cp -a "$C3/B0" "$OUT/ctl/C-3/B0"; cp -a "$C4/M1-U" "$OUT/ctl/C-4/M1-U"
run "C-3-green-sentinel-exit-1" "$OUT/ctl/C-3/B0" GATE-GREEN FAIL 1
run "C-4-witness-line-removed" "$OUT/ctl/C-4/M1-U" GATE-GREEN INVALID 3
echo "--- 3. Astra's specimens and their twins (each a disposable copy of a REAL case dir)"
rm -rf "$OUT/spec"; mkdir -p "$OUT/spec/R1a" "$OUT/spec/R1b" "$OUT/spec/R1b-w" "$OUT/spec/wexit-absent" "$OUT/spec/expect-absent" "$OUT/spec/loader-expect-absent" "$OUT/spec/gate-exit-absent" "$OUT/spec/unknown-case"
cp -a "$REAL/M1-U" "$OUT/spec/R1a/M1-U"; rm "$OUT/spec/R1a/M1-U/witness.out.txt";                      run "R1a-witness-file-deleted" "$OUT/spec/R1a/M1-U" GATE-GREEN INVALID 3
cp -a "$REAL/B0" "$OUT/spec/R1b/B0"; printf 'EXIT 1\nEXIT 0\n' > "$OUT/spec/R1b/B0/gate.exit.txt";       run "R1b-two-gate-exit-records" "$OUT/spec/R1b/B0" GATE-GREEN INVALID 3
cp -a "$REAL/M2-P" "$OUT/spec/R1b-w/M2-P"; printf 'EXIT 1\nEXIT 0\n' > "$OUT/spec/R1b-w/M2-P/witness.exit.txt"; run "R1b-two-witness-exit-records" "$OUT/spec/R1b-w/M2-P" GATE-OPEN-F1 INVALID 3
cp -a "$REAL/M2-P" "$OUT/spec/wexit-absent/M2-P"; rm "$OUT/spec/wexit-absent/M2-P/witness.exit.txt";   run "witness-exit-file-absent" "$OUT/spec/wexit-absent/M2-P" GATE-OPEN-F1 INVALID 3
cp -a "$REAL/U1-M" "$OUT/spec/expect-absent/U1-M"; rm "$OUT/spec/expect-absent/U1-M/WITNESS-EXPECT.txt"; run "witness-expect-file-absent" "$OUT/spec/expect-absent/U1-M" GATE-GREEN INVALID 3
cp -a "$REAL/M1-C" "$OUT/spec/loader-expect-absent/M1-C"; rm "$OUT/spec/loader-expect-absent/M1-C/WITNESS-EXPECT-LOADER.txt"; run "loader-expect-file-absent" "$OUT/spec/loader-expect-absent/M1-C" BLOCKED-AT-LOADER INVALID 3
cp -a "$REAL/B0" "$OUT/spec/gate-exit-absent/B0"; rm "$OUT/spec/gate-exit-absent/B0/gate.exit.txt";     run "gate-exit-file-absent" "$OUT/spec/gate-exit-absent/B0" GATE-GREEN INVALID 3
cp -a "$REAL/B0" "$OUT/spec/unknown-case/R1a-B0";                                                         run "unknown-case-name" "$OUT/spec/unknown-case/R1a-B0" GATE-GREEN INVALID 3
echo "--- 4. legitimately witness-free baselines must still be accepted"
rm -rf "$OUT/base"; mkdir -p "$OUT/base"; for c in B0 B0-I U1; do cp -a "$REAL/$c" "$OUT/base/$c"; rm -f "$OUT/base/$c"/witness.* "$OUT/base/$c"/WITNESS-EXPECT*.txt; run "baseline-no-witness-$c" "$OUT/base/$c" GATE-GREEN PASS 0; done
echo "RECLASSIFICATION: ok=$ok bad=$bad"; [ "$bad" -eq 0 ]
