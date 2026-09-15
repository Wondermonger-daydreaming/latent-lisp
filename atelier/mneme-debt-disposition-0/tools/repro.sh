#!/usr/bin/env bash
# repro.sh — the reviewer's extraction/reproduction recipe for the MNEME DEBT DISPOSITION /0 review parcel.
#   tools/repro.sh <parcel>.tar.gz
# 1. verifies the .sha256 sidecar beside the tarball (OUTSIDE the archive, first)
# 2. extracts into a fresh directory
# 3. verifies the parcel's own SHA256SUMS (every payload row; the manifest never lists itself)
# 4. runs tools/validate-parcel.sh from inside the payload (roles → P8 runner in fresh processes → P9 form identity)
# Needs: sbcl (2.4.6 was used) with the sb-posix contrib, a writable /tmp, sha256sum, tar. Exit 0 iff every step passed.
set -u
P="${1:-}"; [ -f "$P" ] || { echo "usage: tools/repro.sh <parcel>.tar.gz"; exit 2; }
D="$(cd "$(dirname "$P")" && pwd)"; B="$(basename "$P")"
echo "--- 1. sidecar"; (cd "$D" && sha256sum -c "$B.sha256") || { echo "repro: sidecar FAILED"; exit 1; }
X="$(mktemp -d /tmp/mneme-debt-disposition-0-repro.XXXXXX)"; echo "--- 2. extract to $X"; tar -xzf "$P" -C "$X" || exit 1
PAY="$(find "$X" -mindepth 1 -maxdepth 1 -type d | head -1)"; [ -d "$PAY" ] || { echo "repro: no payload dir"; exit 1; }
echo "--- 3. manifest"; (cd "$PAY" && sha256sum -c --quiet SHA256SUMS && echo "SHA256SUMS: $(grep -c . SHA256SUMS) rows verified") || { echo "repro: manifest FAILED"; exit 1; }
echo "--- 4. validate"; AT="$(find "$PAY" -type d -path '*/atelier/mneme-debt-disposition-0' | head -1)"
(cd "$PAY" && bash "$AT/tools/validate-parcel.sh"); e=$?
echo "repro: validate rc=$e (extracted at $X)"; exit $e
