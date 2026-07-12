#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET="${ROOT}/data/council-process-2026-07-12.sexp"
BACKUP="$(mktemp)"
cp "${TARGET}" "${BACKUP}"
original_sum="$(sha256sum "${TARGET}" | awk '{print $1}')"

restore() {
  cp "${BACKUP}" "${TARGET}"
  rm -f "${BACKUP}"
}
trap restore EXIT

python - "${TARGET}" <<'PY'
from pathlib import Path
import sys
p = Path(sys.argv[1])
s = p.read_text()
old = ''':field :carrier-selection-and-omission-history
   :status :not-established'''
new = ''':field :carrier-selection-and-omission-history
   :status :no-curation-observed'''
if old not in s:
    raise SystemExit("mutation target not found")
p.write_text(s.replace(old, new, 1))
PY

set +e
sbcl --script "${ROOT}/storms/council-process-ledger.lisp" >/tmp/leibnitiana-silence-mutation.out 2>&1
status=$?
set -e

if [[ ${status} -eq 0 ]]; then
  cat /tmp/leibnitiana-silence-mutation.out >&2
  echo "Mutation survived: unknown carrier history was laundered into a benign claim." >&2
  exit 1
fi

restore
trap - EXIT
restored_sum="$(sha256sum "${TARGET}" | awk '{print $1}')"
if [[ "${original_sum}" != "${restored_sum}" ]]; then
  echo "Source restoration failed." >&2
  exit 1
fi

echo "PASS: silence laundering was killed; source restored byte-identical (${restored_sum})."
