#!/usr/bin/env bash
# p8-runner.sh — the P8 auditor harness runner (PREREG-P8-DELTA-0.md §5–§8).
#
#   p8-runner.sh <lane-dir> <out-dir>
#
# Runs each §6 case in a FRESH `sbcl --script` process, SEQUENTIALLY (§8: two concurrent processes VOID the run), with cwd = the venue
# root (<lane-dir>/../.., the directory holding `mneme/` — the auditor's `#p"mneme/../"` subject-root is cwd-relative). Classifies each
# process's single RESULT-CLASS line against EXPECTATIONS-P8.txt. `P8_EXPECT_OVERRIDE` ("CASE=<class>", ';'-separated) replaces one
# expectation for a CONTROL run and is printed verbatim into the transcript; a real run has it unset.
#
# Three things a passing total may NOT hide (prereg §7, WARRANT SESSION lessons):
#   · a case whose process printed no RESULT-CLASS line is LOAD-ERROR and is reported BLOCKED — never PASS, even when expected;
#   · E-L (the auditor's ORIGINAL probe, venue path substituted only) counts as the ORIGINAL block only if stderr carries the ORIGINAL
#     reader error (`Symbol "RECORD-FIELD" not found in the LISP-PLUS-CD0 package`) AND stdout shows the fixture ran first
#     (`account written:`) — any other load failure is a DIFFERENT failure and is reported as such (a stale path is not the block);
#   · the venue is checked against the PINNED load closure (../closure/PINNED-CLOSURE-SHA256.txt, main HEAD 8f41eee13) BEFORE the cases
#     run; a mismatch is VOID (prereg §8, first condition), not FAIL.
# Every generated file goes to <out-dir>; nothing is written into the harness directory (the parcel payload stays byte-equal).
#
# — SMITH (Claude Opus 5, subagent) 2026-09-15, rewritten after review by the chair (Claude Fable 5.1, A Comment Is A Claim [653264]):
#   portable defaults, E-L error identity, out-dir only, pinned-closure VOID gate.
set -u
HARNESS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
P8_DIR="$(cd "$HARNESS_DIR/.." && pwd)"
PREREG="${P8_PREREG:-$P8_DIR/PREREG-P8-DELTA-0.md}"
PREREG_SHA_EXPECTED="295bab9fc390dc0a1beac5cc85fbb361ed4c0bfe65f7ed7618f04e5bc4f81c98"
ORIG_SRC="${P8_ORIGINAL_SRC:-$P8_DIR/original/probe-p8-supplement.lisp}"
PINNED="${P8_PINNED_CLOSURE:-$P8_DIR/closure/PINNED-CLOSURE-SHA256.txt}"
[ $# -eq 2 ] || { echo "usage: p8-runner.sh <lane-dir> <out-dir>" >&2; exit 2; }
LANE_DIR="$(cd "$1" && pwd)"; OUT_DIR="$2"; VENUE_ROOT="$(cd "$LANE_DIR/../.." && pwd)"
mkdir -p "$OUT_DIR"
CASES="V-R V-D V-J F-D F-R F-W E-J E-R E-L"

{ echo "P8 RUNNER — PREREG-P8-DELTA-0.md"
  echo "date            : $(date -Is)"
  echo "lane-dir        : $LANE_DIR"
  echo "venue-root(cwd) : $VENUE_ROOT"
  echo "out-dir         : $OUT_DIR"
  echo "sbcl            : $(sbcl --version 2>/dev/null || echo ABSENT)"
  echo "prereg          : $PREREG"
  echo "prereg sha256   : $(sha256sum "$PREREG" 2>/dev/null | cut -d' ' -f1) (expected $PREREG_SHA_EXPECTED)"
  echo "harness sha256  :"
  for f in "$HARNESS_DIR/p8-case.lisp" "$HARNESS_DIR/p8-runner.sh" "$HARNESS_DIR/EXPECTATIONS-P8.txt" "$ORIG_SRC"; do echo "    $(sha256sum "$f" 2>/dev/null || echo "ABSENT  $f")"; done
} | tee "$OUT_DIR/RUNNER-HEADER.txt"
command -v sbcl >/dev/null || { echo "P8-RUNNER: BLOCKED — sbcl not on PATH (venue), no case ran"; exit 4; }
[ "$(sha256sum "$PREREG" 2>/dev/null | cut -d' ' -f1)" = "$PREREG_SHA_EXPECTED" ] || echo "WARNING: prereg sha differs from the frozen hash — read PREREG-P8-DELTA-0.sha256 and the NOTES before trusting this run"

# ---- pinned-closure VOID gate (prereg §8, first condition), scoped to the 68-file load closure (TRACER) — NOTE 1 says why that scope.
if [ -f "$PINNED" ]; then
  if (cd "$VENUE_ROOT" && sha256sum -c --quiet "$PINNED") > "$OUT_DIR/CLOSURE-CHECK.txt" 2>&1; then
    echo "CLOSURE-PINNED: OK ($(grep -c . "$PINNED") files equal to main HEAD 8f41eee13)" | tee -a "$OUT_DIR/RUNNER-HEADER.txt"
  else
    echo "CLOSURE-PINNED: MISMATCH — VOID (prereg §8): the venue's load closure is not the pinned subject; see $OUT_DIR/CLOSURE-CHECK.txt" | tee -a "$OUT_DIR/RUNNER-HEADER.txt"
    echo "P8-RUNNER: VOID"; exit 5
  fi
else
  echo "CLOSURE-PINNED: NO PINNED LIST at $PINNED — identity unchecked (recorded, not assumed)" | tee -a "$OUT_DIR/RUNNER-HEADER.txt"
fi

# ---- expectations + the documented override
declare -A EXPECT
while IFS= read -r line; do case "$line" in ''|'#'*) continue;; esac; EXPECT["${line%%=*}"]="${line#*=}"; done < "$HARNESS_DIR/EXPECTATIONS-P8.txt"
if [ -n "${P8_EXPECT_OVERRIDE:-}" ]; then
  echo "P8_EXPECT_OVERRIDE (verbatim): ${P8_EXPECT_OVERRIDE}"
  IFS=';' read -r -a clauses <<< "$P8_EXPECT_OVERRIDE"
  for clause in "${clauses[@]}"; do [ -z "$clause" ] && continue; ocase="${clause%%=*}"; oclass="${clause#*=}"; echo "  override: $ocase  '${EXPECT[$ocase]:-<none>}'  ->  '$oclass'"; EXPECT["$ocase"]="$oclass"; done
else echo "P8_EXPECT_OVERRIDE: (unset — this is a real run)"; fi
echo

# ---- E-L source: regenerated EVERY run into the out-dir from the ORIGINAL, venue path substituted only; the diff is kept beside it
ORIG_DST="$OUT_DIR/probe-p8-supplement-venue-path.lisp"
if [ -f "$ORIG_SRC" ]; then
  sed "s|/mnt/venue/WORK/substrate/lane/|${LANE_DIR}/|g" "$ORIG_SRC" > "$ORIG_DST"
  diff -u "$ORIG_SRC" "$ORIG_DST" > "$OUT_DIR/venue-path-substitution.diff.txt"
  echo "E-L source: $(sha256sum "$ORIG_SRC" | cut -c1-16)… (original) → venue path substituted; $(grep -c '^[-+][^-+]' "$OUT_DIR/venue-path-substitution.diff.txt") changed line(s), diff in out-dir"
else echo "E-L source ABSENT at $ORIG_SRC — E-L will be reported BLOCKED (different failure)"; fi
echo

pass=0; fail=0; blocked=0; fail_blocked=0; declare -a LINES
field_after(){ grep "^$2 " "$1" 2>/dev/null | tail -1 | sed -n 's/.*frames=\([0-9]*\).*/\1/p'; }
for C in $CASES; do
  OUT="$OUT_DIR/$C.out.txt"; ERR="$OUT_DIR/$C.err.txt"; EX="$OUT_DIR/$C.exit.txt"
  if [ "$C" = "E-L" ]; then
    if [ -f "$ORIG_DST" ]; then ( cd "$VENUE_ROOT" && sbcl --script "$ORIG_DST" ) >"$OUT" 2>"$ERR"; ec=$?; else : >"$OUT"; echo "E-L source file absent" >"$ERR"; ec=127; fi
  else
    ( cd "$VENUE_ROOT" && sbcl --script "$HARNESS_DIR/p8-case.lisp" "$C" "$LANE_DIR" ) >"$OUT" 2>"$ERR"; ec=$?
  fi
  echo "EXIT $ec" > "$EX"
  expected="${EXPECT[$C]:-<no expectation>}"
  got="$(grep -m1 '^RESULT-CLASS: ' "$OUT" 2>/dev/null | sed 's/^RESULT-CLASS: //')"
  nlines="$(grep -c '^RESULT-CLASS: ' "$OUT" 2>/dev/null || true)"
  if [ -z "$got" ]; then
    blocked=$((blocked+1))
    if [ "$C" = "E-L" ] && [ "$expected" = "LOAD-ERROR" ]; then
      if grep -q 'Symbol "RECORD-FIELD" not found in the LISP-PLUS-CD0 package' "$ERR" && grep -q '^account written:' "$OUT"; then
        LINES+=("BLOCKED-AS-EXPECTED E-L: LOAD-ERROR — the ORIGINAL reader error ($(grep -o 'Line: [0-9]*, Column: [0-9]*' "$ERR" | head -1)), fixture ran first (exit $ec)")
      else
        LINES+=("BLOCKED E-L: LOAD-ERROR but NOT the original reader error (exit $ec; stderr: $(head -c 160 "$ERR" | tr '\n' ' '))"); fail_blocked=1
      fi
    elif [ "$expected" = "LOAD-ERROR" ]; then
      LINES+=("BLOCKED-AS-EXPECTED $C: LOAD-ERROR (exit $ec)")
    else
      LINES+=("BLOCKED $C: LOAD-ERROR (no RESULT-CLASS line; exit $ec)"); fail_blocked=1
    fi
    continue
  fi
  if [ "$nlines" != "1" ]; then LINES+=("FAIL $C: printed $nlines RESULT-CLASS lines; the grammar allows exactly one"); fail=$((fail+1)); continue; fi
  if [ "$got" = "$expected" ]; then LINES+=("PASS $C: $got"); pass=$((pass+1)); else LINES+=("FAIL $C: got '$got' expected '$expected'"); fail=$((fail+1)); fi
  # ---- secondary checks (prereg §6 state/detail requirements) and the fixture witness
  fb="$(field_after "$OUT" STORE-BEFORE)"; fa="$(field_after "$OUT" STORE-AFTER)"
  disp="$(grep -m1 '^APPEND-DISPOSITION: ' "$OUT" | sed 's/^APPEND-DISPOSITION: //')"
  det="$(grep -m1 '^DETAIL: ' "$OUT" | sed 's/^DETAIL: //')"
  prop="$(grep -m1 '^FORGED-VS-LAWFUL-DIFFERING-PATHS: ' "$OUT" | sed 's/^FORGED-VS-LAWFUL-DIFFERING-PATHS: //')"
  case "$C" in
    V-J) [ "$disp" = ":ALREADY-COMMITTED-IDENTICAL" ] || { LINES+=("FAIL V-J: append disposition '$disp' is not :ALREADY-COMMITTED-IDENTICAL"); fail=$((fail+1)); }
         [ "$fa" = "$fb" ] || { LINES+=("FAIL V-J: frames $fb -> $fa (expected unchanged)"); fail=$((fail+1)); }
         case "$prop" in 0*) ;; *) LINES+=("FAIL V-J: rebuilt lawful body differs from the lawful body at '$prop' (expected 0 paths)"); fail=$((fail+1));; esac ;;
    F-D|F-R|F-W)
         case "$prop" in "1 · account:effect-observation / effect:provenance") ;; *) LINES+=("FAIL $C: forged body does not differ at exactly effect:provenance — got '$prop'"); fail=$((fail+1));; esac ;;
  esac
  case "$C" in
    F-R|E-R) [ "$fa" = "$((fb+1))" ] || { LINES+=("FAIL $C: frames $fb -> $fa (expected +1)"); fail=$((fail+1)); } ;;
    E-J|F-W) [ "$fa" = "$fb" ] || { LINES+=("FAIL $C: frames $fb -> $fa (expected unchanged)"); fail=$((fail+1)); } ;;
  esac
  if [ "$C" = "F-W" ]; then case "$det" in *ML0-RB-5*) LINES+=("      F-W detail names ML0-RB-5 (re-signalled under WR-8)");; *) LINES+=("FAIL F-W: detail does not name ML0-RB-5"); fail=$((fail+1));; esac; fi
  LINES+=("      $C frames ${fb:-?} -> ${fa:-?}${disp:+  disposition $disp}${prop:+  differing-paths: $prop}")
done
{ for l in "${LINES[@]}"; do echo "$l"; done; echo; echo "P8-RUNNER: pass=$pass fail=$fail blocked=$blocked"; } | tee "$OUT_DIR/SUMMARY.txt"
{ echo "VENUE IDENTITY"; echo "date            : $(date -Is)"; echo "sbcl            : $(sbcl --version)"; echo "lane-dir        : $LANE_DIR"; echo "prereg sha256   : $(sha256sum "$PREREG" | cut -d' ' -f1) (expected $PREREG_SHA_EXPECTED)"
  echo "pinned closure  : $([ -f "$PINNED" ] && sha256sum "$PINNED" | cut -c1-16 || echo none)"; echo; echo "sha256 of every file under the lane dir:"; find "$LANE_DIR" -type f | sort | xargs sha256sum; } > "$OUT_DIR/VENUE-IDENTITY.txt"
[ "$fail" -eq 0 ] && [ "$fail_blocked" -eq 0 ] && exit 0 || exit 1
