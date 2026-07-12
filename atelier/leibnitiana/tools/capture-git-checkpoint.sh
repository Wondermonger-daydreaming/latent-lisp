#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET="${1:-data/council-process-2026-07-12.sexp}"
REVISION="${2:-HEAD}"
REPOSITORY="${LEIBNITIANA_MIRROR_REPOSITORY:-not-supplied}"
PROVIDER="${LEIBNITIANA_MIRROR_PROVIDER:-not-supplied}"
OBSERVER="${LEIBNITIANA_CHECKPOINT_OBSERVER:-landing-script}"

if ! git -C "${ROOT}" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "The chamber must be inside a Git worktree." >&2
  exit 2
fi

commit_hash="$(git -C "${ROOT}" rev-parse "${REVISION}^{commit}")"
tree_hash="$(git -C "${ROOT}" show -s --format=%T "${commit_hash}")"
blob_hash="$(git -C "${ROOT}" rev-parse "${commit_hash}:${TARGET}")"
commit_time="$(git -C "${ROOT}" show -s --format=%cI "${commit_hash}")"
object_format="$(git -C "${ROOT}" rev-parse --show-object-format 2>/dev/null || echo sha1)"

cat <<SEXP
(:schema-version 1
 :kind :git-mirror-checkpoint
 :repository "${REPOSITORY}"
 :provider "${PROVIDER}"
 :revision "${REVISION}"
 :commit-hash "${commit_hash}"
 :tree-hash "${tree_hash}"
 :blob-hash "${blob_hash}"
 :object-format :${object_format}
 :path "${TARGET}"
 :commit-time "${commit_time}"
 :captured-at "$(date --iso-8601=seconds)"
 :observer "${OBSERVER}"
 :publication-status :captured-from-local-git
 :selection-relation :carrier-selected-not-independent
 :standing :local-content-addressed-checkpoint-only
 :next-step :observe-same-commit-and-blob-on-public-mirror)
SEXP
