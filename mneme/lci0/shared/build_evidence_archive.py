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
import os
from pathlib import Path, PurePosixPath
import stat
import subprocess
import tarfile
from typing import Iterable


ARCHIVE_SCHEMA = "lisp-plus-lci0-evidence-archive/v1"
MANIFEST_MEMBER = "LCI0-EVIDENCE-ARCHIVE-MANIFEST.json"
DETRITUS_DIRECTORY_NAMES = frozenset(
    {"__pycache__", ".mypy_cache", ".pytest_cache", ".ruff_cache"}
)
DETRITUS_FILE_NAMES = frozenset({".DS_Store", ".coverage"})
DETRITUS_SUFFIXES = (".fasl", ".pyc", ".pyo", ".tmp")


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


def _is_detritus(root: Path, path: Path) -> bool:
    relative = path.relative_to(root)
    return (
        any(part in DETRITUS_DIRECTORY_NAMES for part in relative.parts)
        or path.name in DETRITUS_FILE_NAMES
        or path.name.endswith(DETRITUS_SUFFIXES)
    )


def _selected_files(root: Path, includes: Iterable[str], excluded: set[Path]) -> list[Path]:
    files: set[Path] = set()
    for raw in includes:
        lexical_candidate = root / raw
        for component in (lexical_candidate, *lexical_candidate.parents):
            if component == root:
                break
            if component.is_symlink():
                raise ArchiveBuildError(f"symbolic-link include is not permitted: {raw}")
        candidate = lexical_candidate.resolve()
        if not _contained(root, candidate):
            raise ArchiveBuildError(f"include escapes repository root: {raw}")
        if not candidate.exists():
            raise ArchiveBuildError(f"include does not exist: {raw}")
        if candidate.is_symlink():
            raise ArchiveBuildError(f"symbolic-link include is not permitted: {raw}")
        if candidate.is_file():
            if _is_detritus(root, candidate):
                raise ArchiveBuildError(
                    f"generated detritus selected as include: {_posix_relative(root, candidate)}"
                )
            files.add(candidate)
            continue
        if not candidate.is_dir():
            raise ArchiveBuildError(f"unsupported include kind: {raw}")
        for path in candidate.rglob("*"):
            if _is_detritus(root, path):
                raise ArchiveBuildError(
                    f"generated detritus found below include: {_posix_relative(root, path)}"
                )
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


def _require_clean_git_tree(
    root: Path,
    output: Path,
    repository_head: str,
    members: list[Member],
) -> None:
    def git(*arguments: str) -> str:
        try:
            completed = subprocess.run(
                ["git", "-C", str(root), *arguments],
                check=True,
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                text=True,
            )
        except (OSError, subprocess.CalledProcessError) as error:
            detail = getattr(error, "stderr", "") or str(error)
            raise ArchiveBuildError(f"Git provenance check failed: {detail.strip()}") from error
        return completed.stdout.strip()

    def git_bytes(*arguments: str) -> bytes:
        try:
            completed = subprocess.run(
                ["git", "-C", str(root), *arguments],
                check=True,
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
            )
        except (OSError, subprocess.CalledProcessError) as error:
            detail = getattr(error, "stderr", b"")
            if isinstance(detail, bytes):
                detail = detail.decode("utf-8", "replace")
            raise ArchiveBuildError(
                f"Git provenance check failed: {(detail or str(error)).strip()}"
            ) from error
        return completed.stdout

    top_level = Path(git("rev-parse", "--show-toplevel")).resolve()
    if top_level != root:
        raise ArchiveBuildError(
            f"archive root is not the Git top-level: {root} != {top_level}"
        )
    actual_head = git("rev-parse", "HEAD")
    declared_head = git("rev-parse", "--verify", f"{repository_head}^{{commit}}")
    if actual_head != declared_head:
        raise ArchiveBuildError(
            f"repository HEAD does not match declared archive source: {actual_head} != {declared_head}"
        )

    concealed = []
    for entry in git_bytes("ls-files", "-v", "-z").split(b"\0"):
        if not entry:
            continue
        tag = chr(entry[0])
        if tag.islower() or tag == "S":
            concealed.append(entry[2:].decode("utf-8", "surrogateescape"))
    if concealed:
        preview = "; ".join(concealed[:10])
        if len(concealed) > 10:
            preview += f"; ... ({len(concealed) - 10} more)"
        raise ArchiveBuildError(
            "repository index has assume-unchanged/skip-worktree concealment: "
            + preview
        )

    status_lines = git(
        "status",
        "--porcelain=v1",
        "--untracked-files=all",
        "--ignored=matching",
    ).splitlines()
    allowed_outputs = {_posix_relative(root, output)}
    unexpected: list[str] = []
    for line in status_lines:
        if len(line) < 4:
            unexpected.append(line)
            continue
        path_text = line[3:]
        if " -> " in path_text:
            path_text = path_text.split(" -> ", 1)[1]
        if line[:2] not in {"??", "!!"} or path_text not in allowed_outputs:
            unexpected.append(line)
    if unexpected:
        preview = "; ".join(unexpected[:10])
        if len(unexpected) > 10:
            preview += f"; ... ({len(unexpected) - 10} more)"
        raise ArchiveBuildError(f"repository worktree is not clean at declared HEAD: {preview}")

    # Status is only a convenience signal: index flags such as
    # `assume-unchanged` can hide worktree mutations.  Bind every captured
    # archive member directly to the declared commit blob and executable bit.
    # Member payloads were captured once before this check and those same bytes
    # are written to the archive, closing the check/read race.
    for member in members:
        tree_row = git_bytes(
            "ls-tree", "-z", repository_head, "--", member.archive_name
        )
        if not tree_row.endswith(b"\0") or tree_row.count(b"\0") != 1:
            raise ArchiveBuildError(
                f"archive member is not exactly one tracked commit file: {member.archive_name}"
            )
        metadata, separator, tracked_name = tree_row[:-1].partition(b"\t")
        parts = metadata.split()
        if (
            not separator
            or tracked_name.decode("utf-8", "surrogateescape") != member.archive_name
            or len(parts) != 3
            or parts[1] != b"blob"
            or parts[0] not in {b"100644", b"100755"}
        ):
            raise ArchiveBuildError(
                f"archive member commit entry is unsupported: {member.archive_name}"
            )
        commit_payload = git_bytes(
            "cat-file", "blob", f"{repository_head}:{member.archive_name}"
        )
        if commit_payload != member.payload:
            raise ArchiveBuildError(
                f"archive member bytes differ from declared commit: {member.archive_name}"
            )
        expected_executable = parts[0] == b"100755"
        if member.executable != expected_executable:
            raise ArchiveBuildError(
                f"archive member mode differs from declared commit: {member.archive_name}"
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
    require_clean_git_tree: bool = False,
) -> dict[str, object]:
    root = root.resolve()
    if output.is_symlink():
        raise ArchiveBuildError("archive output cannot be a symbolic link")
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
    if require_clean_git_tree:
        _require_clean_git_tree(root, output, repository_head, members)

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
    if temporary.exists() or temporary.is_symlink():
        raise ArchiveBuildError(f"archive temporary path already exists: {temporary}")
    temporary_created = False
    try:
        flags = os.O_WRONLY | os.O_CREAT | os.O_EXCL
        if hasattr(os, "O_NOFOLLOW"):
            flags |= os.O_NOFOLLOW
        descriptor = os.open(temporary, flags, 0o600)
        temporary_created = True
        with os.fdopen(descriptor, "wb") as raw:
            with gzip.GzipFile(filename="", mode="wb", fileobj=raw, mtime=0) as compressed:
                with tarfile.open(fileobj=compressed, mode="w", format=tarfile.PAX_FORMAT) as archive:
                    archive.addfile(_tar_info(MANIFEST_MEMBER, len(manifest_payload)), io.BytesIO(manifest_payload))
                    for member in members:
                        archive.addfile(
                            _tar_info(member.archive_name, len(member.payload), member.executable),
                            io.BytesIO(member.payload),
                        )
        temporary.replace(output)
        temporary_created = False
    finally:
        if temporary_created and temporary.exists() and not temporary.is_symlink():
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
    parser.add_argument(
        "--require-clean-git-tree",
        action="store_true",
        required=True,
        help="mandatory provenance gate for production evidence archives",
    )
    arguments = parser.parse_args()
    result = build_archive(
        root=arguments.root,
        output=arguments.output,
        includes=arguments.include,
        evidence_date=arguments.evidence_date,
        repository_head=arguments.repository_head,
        status=arguments.status,
        require_clean_git_tree=arguments.require_clean_git_tree,
    )
    print(json.dumps(result, sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
