#!/usr/bin/env bash
# check-roles.sh [ATELIER-DIR] — the retention regression: every role in evidence-roles.txt must match ≥1 file. Prints one line per role; exit 1 if any MISSING.
# Sidecar roles resolve relative to the atelier dir (../../../sidecar = beside the extracted latent-lisp/ tree). Names the new failure it detects: a required
# transcript/proof absent from a parcel whose own manifest is nonetheless self-consistent.
set -u; D="${1:-$(cd "$(dirname "$0")/.." && pwd)}"; cd "$D" || exit 2; miss=0; n=0
while read -r role glob; do case "$role" in ''|'#'*) continue;; esac; n=$((n+1))
  if compgen -G "$glob" > /dev/null; then echo "present  $role  $(compgen -G "$glob" | head -1)"; else echo "MISSING  $role  $glob"; miss=$((miss+1)); fi
done < evidence-roles.txt
echo "check-roles: $n roles, $miss missing"; [ "$miss" -eq 0 ]
