#!/usr/bin/env bash
# run-baselines.sh — the control group, against the same windows.
# Called by reproduce.sh; SBCL binary is $1 (default sbcl).
set -u
cd "$(dirname "$0")"
SBCL="${1:-sbcl}"

mkdir -p evidence/B1-lies evidence/B2-buffered evidence/B3-empty

( "$SBCL" --script kw-baseline.lisp evidence/B1-lies/ run uncertain \
    > evidence/B1-lies/run-stdout.txt 2>&1 & BPID=$!
  for i in $(seq 1 200); do [ -f evidence/B1-lies/READY-uncertain ] && break; sleep 0.1; done
  sleep 0.3; kill -9 $BPID 2>/dev/null; wait $BPID 2>/dev/null )
cp evidence/B1-lies/provider.log evidence/B1-lies/provider-log-before.txt
"$SBCL" --script kw-baseline.lisp evidence/B1-lies/ recover uncertain \
  > evidence/B1-lies/recover-stdout.txt 2>&1
cp evidence/B1-lies/provider.log evidence/B1-lies/provider-log-after.txt
echo "B1: provider executions before/after recovery = $(grep -c EXECUTED evidence/B1-lies/provider-log-before.txt) / $(grep -c EXECUTED evidence/B1-lies/provider-log-after.txt)  (LIE 2: double-spend; LIE 3: 'state: OK (verified)' laundering)"

( "$SBCL" --script kw-baseline.lisp evidence/B2-buffered/ run buffered-uncertain \
    > evidence/B2-buffered/run-stdout.txt 2>&1 & BPID=$!
  for i in $(seq 1 200); do [ -f evidence/B2-buffered/READY-buffered-uncertain ] && break; sleep 0.1; done
  sleep 0.3; kill -9 $BPID 2>/dev/null; wait $BPID 2>/dev/null )
echo "B2: baseline log exists after death = $(test -f evidence/B2-buffered/baseline.log && echo YES || echo NO); provider executions = $(grep -c EXECUTED evidence/B2-buffered/provider.log)  (LIE 4: finalizer-only loss)"

"$SBCL" --script kw-baseline.lisp evidence/B3-empty/ run empty \
  > evidence/B3-empty/run-stdout.txt 2>&1
"$SBCL" --script kw-baseline.lisp evidence/B3-empty/ recover empty \
  > evidence/B3-empty/recover-stdout.txt 2>&1
echo "B3: empty-vs-absent collapse recorded in evidence/B3-empty/recover-stdout.txt  (LIE 1)"
