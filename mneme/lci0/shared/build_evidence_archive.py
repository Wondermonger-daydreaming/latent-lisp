#!/usr/bin/env python3
"""Build a byte-reproducible standalone LCI/0 evidence archive.

The archive contains only explicitly selected repository-relative paths plus an
internal manifest.  Source file metadata is normalized so two invocations over
the same bytes and arguments produce the same gzip stream.
"""

from __future__ import annotations

import argparse
from dataclasses import dataclass
import gzip
import hashlib
import io
import json
from pathlib import Path, PurePosixPath
import stat
import tarfile
from typing import Iterable


ARCHIVE_SCHEMA = "lisp-plus-lci0-evidence-archive/v1"
MANIFEST_MEMBER = "LCI0-EVIDENCE-ARCHIVE-MANIFEST.json"


class ArchiveBuildError(RuntimeError):
    """Raised when an archive selection is unsafe or underdetermined."""


@dataclass(frozen=True)
class Member:
    source: Path
    archive_name: str
    payload: bytes
    executable: bool

    @property
    def sha256(self) -> str:
        return hashlib.sha256(self.payload).hexdigest()


def _contained(root: Path, candidate: Path) -> bool:
    try:
        candidate.relative_to(root)
    except ValueError:
        return False
    return True


def _posix_relative(root: Path, path: Path) -> str:
    relative = path.relative_to(root)
    name = PurePosixPath(*relative.parts).as_posix()
    if not name or name == ".":
        raise ArchiveBuildError("archive member cannot be repository root")
    return name


def _selected_files(root: Path, includes: Iterable[str], excluded: set[Path]) -> list[Path]:
    files: set[Path] = set()
    for raw in includes:
        candidate = (root / raw).resolve()
        if not _contained(root, candidate):
            raise ArchiveBuildError(f"include escapes repository root: {raw}")
        if not candidate.exists():
            raise ArchiveBuildError(f"include does not exist: {raw}")
        if candidate.is_symlink():
            raise ArchiveBuildError(f"symbolic-link include is not permitted: {raw}")
        if candidate.is_file():
            files.add(candidate)
            continue
        if not candidate.is_dir():
            raise ArchiveBuildError(f"unsupported include kind: {raw}")
        for path in candidate.rglob("*"):
            if path.is_symlink():
                raise ArchiveBuildError(
                    f"symbolic link found below include: {_posix_relative(root, path)}"
                )
            if path.is_file():
                files.add(path.resolve())
    return sorted(path for path in files if path not in excluded)


def _member(root: Path, path: Path) -> Member:
    mode = path.stat().st_mode
    return Member(
        source=path,
        archive_name=_posix_relative(root, path),
        payload=path.read_bytes(),
        executable=bool(mode & stat.S_IXUSR),
    )


def _json_bytes(value: object) -> bytes:
    return (
        json.dumps(value, ensure_ascii=False, sort_keys=True, separators=(",", ":"))
        + "\n"
    ).encode("utf-8")


def _tar_info(name: str, size: int, executable: bool = False) -> tarfile.TarInfo:
    info = tarfile.TarInfo(name)
    info.size = size
    info.mtime = 0
    info.uid = 0
    info.gid = 0
    info.uname = ""
    info.gname = ""
    info.mode = 0o755 if executable else 0o644
    info.type = tarfile.REGTYPE
    return info


def build_archive(
    *,
    root: Path,
    output: Path,
    includes: list[str],
    evidence_date: str,
    repository_head: str,
    status: str,
) -> dict[str, object]:
    root = root.resolve()
    output = output.resolve()
    if not root.is_dir():
        raise ArchiveBuildError(f"repository root is not a directory: {root}")
    if not _contained(root, output):
        raise ArchiveBuildError("archive output must remain below repository root")
    excluded = {output}
    members = [_member(root, path) for path in _selected_files(root, includes, excluded)]
    if not members:
        raise ArchiveBuildError("archive selection is empty")
    names = [member.archive_name for member in members]
    if len(names) != len(set(names)):
        raise ArchiveBuildError("duplicate archive member name")
    if MANIFEST_MEMBER in names:
        raise ArchiveBuildError(f"reserved member name selected: {MANIFEST_MEMBER}")

    manifest: dict[str, object] = {
        "schema": ARCHIVE_SCHEMA,
        "evidence_date": evidence_date,
        "repository_head_before_archive_commit": repository_head,
        "status": status,
        "provenance": {
            "authorship": "Codex implementation and evidence run under user authorization",
            "prompt_context": "LCI/0 dual-seed implementation, differential conformance, documentation, archival, and safe cleanup",
            "factual_boundary": (
                "Observed command output and raw protocol transcripts are evidence; "
                "normative files are frozen inputs; draft or blocked receipts retain "
                "their explicit status and are not PASS claims."
            ),
            "reproducibility": (
                "Members are repository-relative, byte-preserved, lexically ordered, "
                "and archived with uid/gid/mtime/mode metadata normalized."
            ),
        },
        "include_paths": includes,
        "member_count_excluding_manifest": len(members),
        "members": [
            {
                "path": member.archive_name,
                "bytes": len(member.payload),
                "sha256": member.sha256,
                "mode": "0755" if member.executable else "0644",
            }
            for member in members
        ],
    }
    manifest_payload = _json_bytes(manifest)

    output.parent.mkdir(parents=True, exist_ok=True)
    temporary = output.with_name(output.name + ".tmp")
    try:
        with temporary.open("wb") as raw:
            with gzip.GzipFile(filename="", mode="wb", fileobj=raw, mtime=0) as compressed:
                with tarfile.open(fileobj=compressed, mode="w", format=tarfile.PAX_FORMAT) as archive:
                    archive.addfile(_tar_info(MANIFEST_MEMBER, len(manifest_payload)), io.BytesIO(manifest_payload))
                    for member in members:
                        archive.addfile(
                            _tar_info(member.archive_name, len(member.payload), member.executable),
                            io.BytesIO(member.payload),
                        )
        temporary.replace(output)
    finally:
        if temporary.exists():
            temporary.unlink()

    archive_payload = output.read_bytes()
    return {
        "archive": _posix_relative(root, output),
        "bytes": len(archive_payload),
        "sha256": hashlib.sha256(archive_payload).hexdigest(),
        "members_including_manifest": len(members) + 1,
        "manifest_bytes": len(manifest_payload),
        "manifest_sha256": hashlib.sha256(manifest_payload).hexdigest(),
    }


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--root", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--include", action="append", required=True)
    parser.add_argument("--evidence-date", required=True)
    parser.add_argument("--repository-head", required=True)
    parser.add_argument("--status", required=True)
    arguments = parser.parse_args()
    result = build_archive(
        root=arguments.root,
        output=arguments.output,
        includes=arguments.include,
        evidence_date=arguments.evidence_date,
        repository_head=arguments.repository_head,
        status=arguments.status,
    )
    print(json.dumps(result, sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
