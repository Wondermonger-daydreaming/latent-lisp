#!/usr/bin/env python3
"""Finalize and build a deterministic LCI/0 law-audit evidence ZIP."""

from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path
import zipfile


def digest(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def canonical_json(value) -> bytes:
    return (json.dumps(value, ensure_ascii=False, sort_keys=True,
                       separators=(",", ":")) + "\n").encode()


def finalize(evidence: Path) -> list[Path]:
    excluded = {"manifest.json", "SHA256SUMS.txt"}
    members = sorted(path for path in evidence.iterdir()
                     if path.is_file() and path.name not in excluded)
    manifest = {
        "schema": "lci0-law-audit-evidence-manifest/1",
        "deterministic_serialization": "UTF-8 LF; canonical JSON; lexicographic paths",
        "members": [{"path": path.name, "bytes": path.stat().st_size,
                     "sha256": digest(path)} for path in members],
    }
    (evidence / "manifest.json").write_bytes(canonical_json(manifest))
    members.append(evidence / "manifest.json")
    members.sort()
    sums = "".join(f"{digest(path)}  {path.name}\n" for path in members)
    (evidence / "SHA256SUMS.txt").write_text(sums, encoding="utf-8", newline="\n")
    return sorted((*members, evidence / "SHA256SUMS.txt"))


def build(evidence: Path, output: Path) -> None:
    members = finalize(evidence)
    with zipfile.ZipFile(output, "w", compression=zipfile.ZIP_DEFLATED,
                         compresslevel=9, strict_timestamps=True) as archive:
        for path in members:
            info = zipfile.ZipInfo(path.name, (1980, 1, 1, 0, 0, 0))
            info.create_system = 3
            info.external_attr = 0o100644 << 16
            info.compress_type = zipfile.ZIP_DEFLATED
            archive.writestr(info, path.read_bytes(), compress_type=zipfile.ZIP_DEFLATED,
                             compresslevel=9)


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--evidence-dir", required=True)
    parser.add_argument("--output", required=True)
    args = parser.parse_args()
    build(Path(args.evidence_dir), Path(args.output))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
