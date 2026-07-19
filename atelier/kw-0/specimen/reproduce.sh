#!/usr/bin/env bash
# reproduce.sh — the one-command reproduction of the Killed Witness specimen.
#
# Usage:
#   SBCL_HOME=/path/to/sbcl-home bash reproduce.sh /path/to/latent-lisp [sbcl-binary]
#
# Requires: an SBCL 2.4.6 binary (arg 2, or $SBCL_BIN, or sbcl on PATH) and its
# SBCL_HOME (the directory containing sbcl.core and the contribs; required,
# via env), Python 3.8+, and a checkout of Wondermonger-daydreaming/latent-lisp
# at the pinned commit (see deps/PINNED-COMMIT.txt) for the CD0 codecs.
# The reference generation ships in ../evidence relative to src/; the
# reproduction regenerates into src/evidence and byte-compares.
#
# PACKAGING-EDIT (2026-07-20, packager: Kimi-k3): four changes relative to the
# script as found, each marked PACKAGING-EDIT inline. No specimen source was
# modified; the edits make the byte-identical sources runnable from any
# extraction path and keep the shipped reference generation read-only.
set -u
cd "$(dirname "$0")/src"

REPO="${1:?usage: SBCL_HOME=/path/to/sbcl-home bash reproduce.sh /path/to/latent-lisp [sbcl-binary]}"
SBCL="${2:-${SBCL_BIN:-sbcl}}"
SBCL_HOME="${SBCL_HOME:?set SBCL_HOME to the directory containing sbcl.core and contribs}"
export SBCL_HOME
export KW_REPO="${1%/}/"

# PACKAGING-EDIT 1: bind the sources' hardcoded paths via symlink, so the
# shipped bytes run unmodified from any extraction directory.
# (/tmp must be writable; recorded as an environment assumption.)
ln -sfn "$PWD" /tmp/kw
SBCL_REAL="$(readlink -f "$(command -v "$SBCL")")"
SBCL_HOME_REAL="$(readlink -f "$SBCL_HOME")"
[ -n "$SBCL_REAL" ] || { echo "cannot resolve SBCL binary: $SBCL"; exit 2; }
[ -f "$SBCL_HOME_REAL/sbcl.core" ] || { echo "SBCL_HOME lacks sbcl.core: $SBCL_HOME"; exit 2; }
SBCL="$SBCL_REAL"; SBCL_HOME="$SBCL_HOME_REAL"
rm -f /tmp/sbcl-bin   # clear any stale (possibly circular) link before binding
ln -sfn "$SBCL_REAL" /tmp/sbcl-bin
mkdir -p /tmp/sbcl-2.4.6-x86-64-linux/obj
ln -sfn "$SBCL_HOME_REAL" /tmp/sbcl-2.4.6-x86-64-linux/obj/sbcl-home

echo "== environment =="
"$SBCL" --version
python3 --version
uname -a
grep -E " /tmp | / " /proc/mounts | head -2

echo "== step 0/5: clean slate (specimen output only; the shipped reference
   generation at ../evidence is NOT touched) =="
rm -rf evidence

echo "== step 1/5: deaths =="
python3 harness.py

echo "== step 2/5: cold reconstruction + classifications =="
for s in S1-clean S2-cw0 S3-cw1 S4-uncertain S5-cw2cw3 S6-midstream S7-nonexec; do
  "$SBCL" --script kw-reconstruct.lisp "evidence/$s/" classify \
    > "evidence/$s/reconstruction.txt" 2>&1
  python3 folder.py "evidence/$s/witness.journal" \
    > "evidence/$s/python-fold.txt" 2>&1
done

echo "== step 3/5: retry law (blind / reconciled-executed / supersede / nonexecution) =="
for b in blind:blind-retry resolve:resolve supersede:supersede; do
  n="${b%%:*}"; m="${b##*:}"
  rm -rf "evidence/S4-$n"; cp -r evidence/S4-uncertain "evidence/S4-$n"
  "$SBCL" --script kw-reconstruct.lisp "evidence/S4-$n/" "$m" \
    > "evidence/S4-$n/verdict.txt" 2>&1
  python3 folder.py "evidence/S4-$n/witness.journal" \
    > "evidence/S4-$n/python-fold.txt" 2>&1
done
rm -rf evidence/S7-retry; cp -r evidence/S7-nonexec evidence/S7-retry
"$SBCL" --script kw-reconstruct.lisp evidence/S7-retry/ retry-nonexecution \
  > evidence/S7-retry/verdict.txt 2>&1
python3 folder.py evidence/S7-retry/witness.journal \
  > evidence/S7-retry/python-fold.txt 2>&1

echo "== step 4/5: differential + F6-v3 =="
fail=0
for s in S1-clean S2-cw0 S3-cw1 S4-uncertain S5-cw2cw3 S6-midstream S7-nonexec; do
  cl=$(grep -oP 'state-digest: \K[0-9A-F]+' "evidence/$s/reconstruction.txt" | head -1)
  py=$(grep -oP 'state-digest=\K[0-9A-F]+' "evidence/$s/python-fold.txt")
  [ "$cl" = "$py" ] && [ -n "$cl" ] && echo "$s: MATCH $cl" || { echo "$s: MISMATCH cl=$cl py=$py"; fail=1; }
done
for s in S4-resolve S4-supersede S7-retry; do
  cl=$(grep -oP 'post-state-digest: \K[0-9A-F]+' "evidence/$s/verdict.txt")
  py=$(grep -oP 'state-digest=\K[0-9A-F]+' "evidence/$s/python-fold.txt")
  [ "$cl" = "$py" ] && [ -n "$cl" ] && echo "$s: MATCH $cl" || { echo "$s: MISMATCH cl=$cl py=$py"; fail=1; }
done
python3 f6v3.py kw-runner.lisp kw-baseline.lisp

echo "== baselines (control group, same deaths) =="
bash run-baselines.sh "$SBCL"

# PACKAGING-EDIT 2: byte-compare the regenerated journals against the shipped
# reference generation (the determinism claim, made checkable).
echo "== step 5/5: reference comparison (regenerated vs shipped reference) =="
refmismatch=0
for s in S1-clean S2-cw0 S3-cw1 S4-uncertain S5-cw2cw3 S6-midstream S7-nonexec; do
  new=$(md5sum "evidence/$s/witness.journal" | cut -d' ' -f1)
  ref=$(md5sum "../evidence/$s/witness.journal" | cut -d' ' -f1)
  [ "$new" = "$ref" ] && echo "$s: journal byte-identical ($new)" \
    || { echo "$s: JOURNAL DIVERGES new=$new ref=$ref"; refmismatch=1; }
done

# PACKAGING-EDIT 3: explicit exit status (0 = full reproduction success).
echo
if [ "$fail" = 0 ] && [ "$refmismatch" = 0 ]; then
  echo "REPRODUCTION: all differentials MATCH; all journals byte-identical to reference"
  exit 0
else
  echo "REPRODUCTION: FAILURE (differential fail=$fail, reference mismatch=$refmismatch)"
  exit 1
fi
