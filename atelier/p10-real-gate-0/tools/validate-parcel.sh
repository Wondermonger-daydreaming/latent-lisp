#!/usr/bin/env bash
# validate-parcel.sh — run by tools/parcel/pack.sh INSIDE the extracted payload, and by tools/repro.sh on a reviewer's machine.
# Copies the payload to a FRESH directory (parcel bytes never written back), then:
#   1. check-roles.sh      — every declared evidence role present (retention contract)
#   2. p10-runner.sh       — the nine P10 cases on FRESH disposable subjects cut from the payload's own experiments/latent-lisp tree
#                            (the runner extracts each subject from the pinned COMMIT when a git repo is available; inside a parcel there is
#                            no repo, so it copies the payload tree instead — the pinned-sha check on every subject BEFORE mutation is what
#                            makes the two routes equivalent), into <fresh>/p10-validate/
# exit 0 iff both pass. Needs SBCL 2.4.6 + sb-posix + sb-introspect, a writable /tmp.
set -u
SRC="$(pwd)"; FRESH="$(mktemp -d /tmp/p10-real-gate-0-parcel-test.XXXXXX)"
echo "validate-parcel: fresh dir $FRESH (payload copied; nothing is written back to $SRC)"
cp -a "$SRC"/. "$FRESH"/; cd "$FRESH" || exit 2
AT="$(find . -type d -path '*/atelier/p10-real-gate-0' | head -1)"; [ -n "$AT" ] || { echo "validate-parcel: no atelier/p10-real-gate-0 in payload"; exit 3; }
A="$FRESH/$AT"; LL="$(cd "$A/../.." && pwd)"
[ -f "$LL/mneme/memory-layer-0/ml0-block-proof.lisp" ] || { echo "validate-parcel: gate not in payload"; exit 3; }
command -v sbcl >/dev/null || { echo "validate-parcel: sbcl not on PATH — BLOCKED (venue), not a result"; exit 4; }
rc=0
echo "--- 1. roles"; bash "$A/tools/check-roles.sh" "$A" | tail -3; [ "${PIPESTATUS[0]}" -eq 0 ] || rc=1
echo "--- 2. P10 runner (fresh subjects from the payload tree; one gate process at a time)"
(cd "$A/harness" && P10_SUBJECT_TREE="$LL" bash ./p10-runner.sh "$FRESH/p10-validate" > "$FRESH/validate-p10.txt" 2>&1); e=$?
grep -E "^(PASS|FAIL|INVALID|BLOCKED|EXPLORATORY|P10-RUNNER)" "$FRESH/validate-p10.txt"; [ "$e" -eq 0 ] || rc=1
echo "validate-parcel: rc=$rc (fresh dir $FRESH retained for inspection)"; exit $rc
