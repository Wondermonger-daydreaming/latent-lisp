#!/usr/bin/env bash
# validate-parcel.sh — run by tools/parcel/pack.sh INSIDE the extracted payload, and by tools/repro.sh on a reviewer's machine.
# Copies the payload to a FRESH directory (the parcel bytes are never written back), then, in order:
#   1. check-roles.sh   — every preregistered evidence role present (the retention contract; a self-consistent manifest is not enough)
#   2. p8-runner.sh     — the P8 cases V-R V-D V-J F-D F-R F-W E-J E-R E-L, each a FRESH sbcl process, against EXPECTATIONS-P8.txt, into <fresh>/p8-validate/
#   3. form-identity    — the P9 candidate proof file vs its HEAD copy: identical top-level forms (comments differ, program does not)
# exit 0 iff all three pass. Everything it writes stays under the fresh dir; the lane copy in the payload is read, never modified.
set -u
SRC="$(pwd)"; FRESH="$(mktemp -d /tmp/mneme-debt-disposition-0-parcel-test.XXXXXX)"
echo "validate-parcel: fresh dir $FRESH (payload copied; nothing is written back to $SRC)"
cp -a "$SRC"/. "$FRESH"/; cd "$FRESH" || exit 2
AT="$(find . -type d -path '*/atelier/mneme-debt-disposition-0' | head -1)"; [ -n "$AT" ] || { echo "validate-parcel: no atelier/mneme-debt-disposition-0 in payload"; exit 3; }
A="$FRESH/$AT"; LL="$(cd "$A/../.." && pwd)"; LANE="$LL/mneme/memory-layer-0"
[ -f "$LANE/ml0-suite-ground.lisp" ] || { echo "validate-parcel: lane not in payload at $LANE"; exit 3; }
command -v sbcl >/dev/null || { echo "validate-parcel: sbcl not on PATH — BLOCKED (venue), not a result"; exit 4; }
rc=0
echo "--- 1. roles"; bash "$A/tools/check-roles.sh" "$A" | tail -3; [ "${PIPESTATUS[0]}" -eq 0 ] || rc=1
echo "--- 2. P8 runner (fresh processes; cwd = $LL)"
(cd "$LL" && bash "$A/p8/harness/p8-runner.sh" "$LANE" "$FRESH/p8-validate" > "$FRESH/validate-p8.txt" 2>&1); e=$?
grep -E '^(PASS|FAIL|BLOCKED|BLOCKED-AS-EXPECTED|P8-RUNNER)' "$FRESH/validate-p8.txt"; [ "$e" -eq 0 ] || rc=1
echo "--- 3. P9 form identity (candidate proof file vs HEAD copy)"
(cd "$LL" && sbcl --script "$A/p9/form-identity.lisp" "$LANE" "$A/p9/before/ml0-consolidation-proof.lisp" "$LANE/ml0-consolidation-proof.lisp" > "$FRESH/validate-form-identity.txt" 2>&1); e=$?
grep -E '^FORMS' "$FRESH/validate-form-identity.txt"; [ "$e" -eq 0 ] || rc=1
echo "validate-parcel: rc=$rc (fresh dir $FRESH retained for inspection)"; exit $rc
