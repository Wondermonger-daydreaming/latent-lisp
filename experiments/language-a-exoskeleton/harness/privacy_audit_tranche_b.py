"""Audit reachable Git blobs against the owner-private freezer corpus.

The private inputs are read only by this explicit custody audit. No private
bytes, phrases, or reversible encodings are written to the repository or
reported on failure; failures identify only the Git path and a signature
digest.
"""

import argparse
import base64
import hashlib
import json
import re
import subprocess
from pathlib import Path

from build_tranche_b import parse_fable_dossiers, parse_sol_dossiers
from util import REPO_ROOT


REJECTED_PRIVATE_COMMIT = "79c19fb291dfcc483e581a8a01633d00419cfed1"
PRIVATE_SOURCE_FILENAMES = {
    "FABLE-PRIVATE-FREEZER-NOTES-v1.md",
    "SOL-PRIVATE-FREEZER-NOTES-v3.md",
}
FORBIDDEN_REPOSITORY_PATHS = {
    "experiments/language-a-exoskeleton/tranche-b/freezer-only/dossiers.jsonl",
    "LANGUAGE-A-OWNER-PRIVATE-FREEZER-DOSSIERS-CANDIDATE.zip",
    "LANGUAGE-A-OWNER-PRIVATE-FREEZER-DOSSIERS-CANDIDATE.zip.sha256",
}
ALLOWED_IDENTITY_PATHS = {
    "experiments/language-a-exoskeleton/tranche-b/freezer-only/external-dossier-identities.jsonl",
    "experiments/language-a-exoskeleton/tranche-b/freezer-only/dossier-manifest.json",
}
FORBIDDEN_IDENTITY_KEYS = {
    "private_text", "owner_private_content", "intended_resolution",
    "trap_description", "scorable_opportunities", "lawful_sketch",
    "failing_sketch", "source_locator_deliberation",
}


def git(*args, input_bytes=None):
    return subprocess.run(
        ["git", *args], cwd=REPO_ROOT, input=input_bytes,
        check=True, capture_output=True,
    ).stdout


def private_item_contents(input_dir):
    root = Path(input_dir)
    fable = parse_fable_dossiers(root / "FABLE-PRIVATE-FREEZER-NOTES-v1.md")
    sol = parse_sol_dossiers(root / "SOL-PRIVATE-FREEZER-NOTES-v3.md")
    return {item_id: row[0] for item_id, row in {**fable, **sol}.items()}


def _signature_set(input_dir):
    signatures = {}

    def add(kind, data):
        data = data.strip()
        if len(data) < 64:
            return
        variants = {
            "raw": data,
            "json-escaped": json.dumps(data.decode("utf-8"), ensure_ascii=False)[1:-1].encode("utf-8"),
            "base64": base64.b64encode(data),
            "hex": data.hex().encode("ascii"),
        }
        for encoding, value in variants.items():
            digest = hashlib.sha256(value).hexdigest()
            signatures.setdefault(digest, (f"{kind}:{encoding}", value))

    root = Path(input_dir)
    for filename in sorted(PRIVATE_SOURCE_FILENAMES):
        add(f"source:{filename}", (root / filename).read_bytes())
    for item_id, content in private_item_contents(root).items():
        add(f"dossier:{item_id}:complete", content)
        sections = re.split(rb"(?m)(?=^##+ )", content)
        for index, section in enumerate(sections, 1):
            add(f"dossier:{item_id}:section-{index}", section)
            lines = section.splitlines(keepends=True)
            if len(lines) > 1:
                add(f"dossier:{item_id}:section-body-{index}", b"".join(lines[1:]))
    return signatures


def _reachable_blobs(commit):
    objects = git("rev-list", "--objects", commit).decode("utf-8").splitlines()
    object_ids = [line.split(" ", 1)[0] for line in objects]
    paths = {}
    for line in objects:
        parts = line.split(" ", 1)
        if len(parts) == 2:
            paths.setdefault(parts[0], set()).add(parts[1])
    query = "".join(f"{object_id}\n" for object_id in object_ids).encode("ascii")
    types = git("cat-file", "--batch-check=%(objectname) %(objecttype)", input_bytes=query).decode("ascii").splitlines()
    return [(object_id, paths.get(object_id, {"<historical-path-unavailable>"})) for object_id, type_ in (line.split() for line in types) if type_ == "blob"]


def _walk_keys(value):
    if isinstance(value, dict):
        for key, child in value.items():
            yield key
            yield from _walk_keys(child)
    elif isinstance(value, list):
        for child in value:
            yield from _walk_keys(child)


def _audit_identity_blob(path, data):
    records = []
    for line in data.splitlines():
        if line.strip():
            records.append(json.loads(line))
    for record in records:
        forbidden = FORBIDDEN_IDENTITY_KEYS.intersection(_walk_keys(record))
        if forbidden:
            raise RuntimeError(f"private content key in identity blob {path}: {sorted(forbidden)}")


def audit_reachable(commit, input_dir, forbidden_commit=REJECTED_PRIVATE_COMMIT):
    commit = git("rev-parse", f"{commit}^{{commit}}").decode("ascii").strip()
    commits = git("rev-list", commit).decode("ascii").splitlines()
    if forbidden_commit in commits:
        raise RuntimeError("rejected private-bearing commit is reachable")
    signatures = _signature_set(input_dir)
    blobs = _reachable_blobs(commit)
    audited = set()
    for object_id, paths in blobs:
        if object_id in audited:
            continue
        audited.add(object_id)
        data = git("cat-file", "blob", object_id)
        for path in paths:
            if path in FORBIDDEN_REPOSITORY_PATHS or Path(path).name in PRIVATE_SOURCE_FILENAMES:
                raise RuntimeError(f"forbidden owner-private path reachable: {path}")
            if path.startswith("experiments/language-a-exoskeleton/tranche-b/freezer-only/"):
                if path not in ALLOWED_IDENTITY_PATHS:
                    raise RuntimeError(f"non-identity freezer blob reachable: {path}")
                _audit_identity_blob(path, data)
        for signature_digest, (kind, signature) in signatures.items():
            if signature in data:
                path = sorted(paths)[0]
                raise RuntimeError(f"owner-private signature in reachable blob path={path} signature={signature_digest} kind={kind}")
    print(
        "TRANCHE-B-REACHABLE-PRIVACY: PASS "
        f"commit={commit} commits={len(commits)} blobs={len(audited)} "
        f"private_signatures={len(signatures)} rejected_ancestor=false"
    )
    return {"commit": commit, "commits": len(commits), "blobs": len(audited), "signatures": len(signatures)}


def audit_working_tree(input_dir):
    signatures = _signature_set(input_dir)
    changed = set(filter(None, git("diff", "--name-only").decode("utf-8").splitlines()))
    changed.update(filter(None, git("ls-files", "--others", "--exclude-standard").decode("utf-8").splitlines()))
    for path in sorted(changed):
        candidate = REPO_ROOT / path
        if not candidate.is_file():
            continue
        if path in FORBIDDEN_REPOSITORY_PATHS or candidate.name in PRIVATE_SOURCE_FILENAMES:
            raise RuntimeError(f"forbidden owner-private working path: {path}")
        data = candidate.read_bytes()
        if path.startswith("experiments/language-a-exoskeleton/tranche-b/freezer-only/"):
            if path not in ALLOWED_IDENTITY_PATHS:
                raise RuntimeError(f"non-identity freezer working blob: {path}")
            _audit_identity_blob(path, data)
        for signature_digest, (kind, signature) in signatures.items():
            if signature in data:
                raise RuntimeError(f"owner-private signature in working path={path} signature={signature_digest} kind={kind}")
    print(f"TRANCHE-B-WORKTREE-PRIVACY: PASS paths={len(changed)} private_signatures={len(signatures)}")
    return {"paths": len(changed), "signatures": len(signatures)}


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--input-dir", required=True)
    parser.add_argument("--commit")
    parser.add_argument("--working-tree", action="store_true")
    parser.add_argument("--forbidden-commit", default=REJECTED_PRIVATE_COMMIT)
    args = parser.parse_args()
    if not args.commit and not args.working_tree:
        parser.error("select --commit and/or --working-tree")
    if args.working_tree:
        audit_working_tree(args.input_dir)
    if args.commit:
        audit_reachable(args.commit, args.input_dir, args.forbidden_commit)


if __name__ == "__main__":
    main()
