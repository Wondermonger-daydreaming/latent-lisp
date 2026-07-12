#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET="${ROOT}/src/provenance.lisp"
BACKUP="$(mktemp)"
cp "${TARGET}" "${BACKUP}"
restore() {
  cp "${BACKUP}" "${TARGET}"
  rm -f "${BACKUP}"
}
trap restore EXIT

python3 - "${TARGET}" <<'PY'
from pathlib import Path
import sys
path = Path(sys.argv[1])
text = path.read_text(encoding="utf-8")
old = "(t :witnessed-prefix-diverges)"
new = "(t :prefix-consistent-with-checkpoint)"
if text.count(old) != 1:
    raise SystemExit(f"expected exactly one mutation site, found {text.count(old)}")
path.write_text(text.replace(old, new), encoding="utf-8")
PY

set +e
sbcl --script "${ROOT}/storms/tampered-receipt.lisp"
status=$?
set -e

if [[ ${status} -eq 0 ]]; then
  echo "MUTATION SURVIVED: the custody gate accepted an overclaim." >&2
  exit 1
fi

echo "MUTATION KILLED: overclaiming checkpoint standing made the storm fail."
