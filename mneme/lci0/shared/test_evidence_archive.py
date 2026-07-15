from __future__ import annotations

import gzip
import hashlib
import io
import json
from pathlib import Path
import subprocess
import tarfile
import tempfile
import unittest

from build_evidence_archive import ArchiveBuildError, MANIFEST_MEMBER, build_archive


def _build(root: Path, output_name: str) -> tuple[Path, dict[str, object]]:
    output = root / output_name
    result = build_archive(
        root=root,
        output=output,
        includes=["evidence"],
        evidence_date="2026-07-14",
        repository_head="0123456789abcdef",
        status="blocked test evidence",
    )
    return output, result


class EvidenceArchiveTests(unittest.TestCase):
    def test_archive_is_reproducible_and_self_describing(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            evidence = root / "evidence"
            evidence.mkdir()
            (evidence / "receipt.txt").write_text("observed\n", encoding="utf-8")
            executable = evidence / "verify.sh"
            executable.write_text("#!/bin/sh\nexit 0\n", encoding="utf-8")
            executable.chmod(0o755)

            first, first_result = _build(root, "first.tar.gz")
            second, second_result = _build(root, "second.tar.gz")
            self.assertEqual(first.read_bytes(), second.read_bytes())
            self.assertEqual(first_result["sha256"], second_result["sha256"])
            self.assertEqual(first_result["bytes"], len(first.read_bytes()))

            with gzip.GzipFile(fileobj=io.BytesIO(first.read_bytes())) as stream:
                with tarfile.open(fileobj=stream, mode="r:") as archive:
                    names = archive.getnames()
                    self.assertEqual(
                        names,
                        [MANIFEST_MEMBER, "evidence/receipt.txt", "evidence/verify.sh"],
                    )
                    self.assertTrue(
                        all(member.uid == member.gid == member.mtime == 0 for member in archive)
                    )
                    manifest_stream = archive.extractfile(MANIFEST_MEMBER)
                    self.assertIsNotNone(manifest_stream)
                    manifest_payload = manifest_stream.read()
                    manifest = json.loads(manifest_payload)
                    self.assertEqual(
                        manifest["schema"], "lisp-plus-lci0-evidence-archive/v1"
                    )
                    rows = {row["path"]: row for row in manifest["members"]}
                    self.assertEqual(
                        rows["evidence/receipt.txt"]["sha256"],
                        hashlib.sha256(b"observed\n").hexdigest(),
                    )
                    self.assertEqual(rows["evidence/verify.sh"]["mode"], "0755")

    def test_archive_excludes_its_own_existing_output(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            evidence = root / "evidence"
            evidence.mkdir()
            (evidence / "receipt.txt").write_text("one\n", encoding="utf-8")
            output = evidence / "archive.tar.gz"
            build_archive(
                root=root,
                output=output,
                includes=["evidence"],
                evidence_date="2026-07-14",
                repository_head="head",
                status="test",
            )
            first = output.read_bytes()
            build_archive(
                root=root,
                output=output,
                includes=["evidence"],
                evidence_date="2026-07-14",
                repository_head="head",
                status="test",
            )
            self.assertEqual(output.read_bytes(), first)

    def test_archive_rejects_escaping_include(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            with self.assertRaisesRegex(ArchiveBuildError, "escapes repository root"):
                build_archive(
                    root=root,
                    output=root / "archive.tar.gz",
                    includes=["../outside"],
                    evidence_date="2026-07-14",
                    repository_head="head",
                    status="test",
                )

    def test_archive_rejects_generated_detritus(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            evidence = root / "evidence"
            cache = evidence / "__pycache__"
            cache.mkdir(parents=True)
            (evidence / "receipt.txt").write_text("observed\n", encoding="utf-8")
            (cache / "subject.cpython-311.pyc").write_bytes(b"bytecode")
            with self.assertRaisesRegex(ArchiveBuildError, "generated detritus"):
                build_archive(
                    root=root,
                    output=root / "archive.tar.gz",
                    includes=["evidence"],
                    evidence_date="2026-07-14",
                    repository_head="head",
                    status="test",
                )

    def test_archive_rejects_direct_detritus_file_include(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            bytecode = root / "direct.pyc"
            bytecode.write_bytes(b"bytecode")
            with self.assertRaisesRegex(ArchiveBuildError, "generated detritus"):
                build_archive(
                    root=root,
                    output=root / "archive.tar.gz",
                    includes=["direct.pyc"],
                    evidence_date="2026-07-14",
                    repository_head="head",
                    status="test",
                )

    def test_archive_clean_git_gate_binds_head_and_worktree(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            subprocess.run(["git", "init", "-q", str(root)], check=True)
            subprocess.run(
                ["git", "-C", str(root), "config", "user.name", "Archive Test"],
                check=True,
            )
            subprocess.run(
                ["git", "-C", str(root), "config", "user.email", "archive@example.invalid"],
                check=True,
            )
            evidence = root / "evidence"
            evidence.mkdir()
            receipt = evidence / "receipt.txt"
            receipt.write_text("observed\n", encoding="utf-8")
            subprocess.run(["git", "-C", str(root), "add", "evidence/receipt.txt"], check=True)
            subprocess.run(
                ["git", "-C", str(root), "commit", "-q", "-m", "evidence"],
                check=True,
            )
            head = subprocess.run(
                ["git", "-C", str(root), "rev-parse", "HEAD"],
                check=True,
                stdout=subprocess.PIPE,
                text=True,
            ).stdout.strip()

            build_archive(
                root=root,
                output=root / "archive.tar.gz",
                includes=["evidence"],
                evidence_date="2026-07-14",
                repository_head=head,
                status="test",
                require_clean_git_tree=True,
            )

            receipt.write_text("mutated\n", encoding="utf-8")
            with self.assertRaisesRegex(ArchiveBuildError, "worktree is not clean"):
                build_archive(
                    root=root,
                    output=root / "archive.tar.gz",
                    includes=["evidence"],
                    evidence_date="2026-07-14",
                    repository_head=head,
                    status="test",
                    require_clean_git_tree=True,
                )

    def test_archive_clean_git_gate_defeats_assume_unchanged(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            subprocess.run(["git", "init", "-q", str(root)], check=True)
            subprocess.run(
                ["git", "-C", str(root), "config", "user.name", "Archive Test"],
                check=True,
            )
            subprocess.run(
                [
                    "git", "-C", str(root), "config", "user.email",
                    "archive@example.invalid",
                ],
                check=True,
            )
            evidence = root / "evidence"
            evidence.mkdir()
            receipt = evidence / "receipt.txt"
            receipt.write_text("observed\n", encoding="utf-8")
            subprocess.run(
                ["git", "-C", str(root), "add", "evidence/receipt.txt"],
                check=True,
            )
            subprocess.run(
                ["git", "-C", str(root), "commit", "-q", "-m", "evidence"],
                check=True,
            )
            head = subprocess.run(
                ["git", "-C", str(root), "rev-parse", "HEAD"],
                check=True,
                stdout=subprocess.PIPE,
                text=True,
            ).stdout.strip()
            subprocess.run(
                [
                    "git", "-C", str(root), "update-index", "--assume-unchanged",
                    "evidence/receipt.txt",
                ],
                check=True,
            )
            receipt.write_text("hidden mutation\n", encoding="utf-8")
            status = subprocess.run(
                ["git", "-C", str(root), "status", "--porcelain=v1"],
                check=True,
                stdout=subprocess.PIPE,
                text=True,
            ).stdout
            self.assertEqual(status, "")

            with self.assertRaisesRegex(ArchiveBuildError, "index has assume-unchanged"):
                build_archive(
                    root=root,
                    output=root / "archive.tar.gz",
                    includes=["evidence"],
                    evidence_date="2026-07-14",
                    repository_head=head,
                    status="test",
                    require_clean_git_tree=True,
                )

    def test_archive_rejects_hidden_nonincluded_tracked_file(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            subprocess.run(["git", "init", "-q", str(root)], check=True)
            subprocess.run(
                ["git", "-C", str(root), "config", "user.name", "Archive Test"],
                check=True,
            )
            subprocess.run(
                [
                    "git", "-C", str(root), "config", "user.email",
                    "archive@example.invalid",
                ],
                check=True,
            )
            evidence = root / "evidence"
            evidence.mkdir()
            (evidence / "receipt.txt").write_text("observed\n", encoding="utf-8")
            outside = root / "outside.txt"
            outside.write_text("tracked\n", encoding="utf-8")
            subprocess.run(["git", "-C", str(root), "add", "."], check=True)
            subprocess.run(
                ["git", "-C", str(root), "commit", "-q", "-m", "evidence"],
                check=True,
            )
            head = subprocess.run(
                ["git", "-C", str(root), "rev-parse", "HEAD"],
                check=True,
                stdout=subprocess.PIPE,
                text=True,
            ).stdout.strip()
            subprocess.run(
                [
                    "git", "-C", str(root), "update-index", "--assume-unchanged",
                    "outside.txt",
                ],
                check=True,
            )
            outside.write_text("hidden outside mutation\n", encoding="utf-8")
            with self.assertRaisesRegex(ArchiveBuildError, "index has assume-unchanged"):
                build_archive(
                    root=root,
                    output=root / "archive.tar.gz",
                    includes=["evidence"],
                    evidence_date="2026-07-14",
                    repository_head=head,
                    status="test",
                    require_clean_git_tree=True,
                )

    def test_archive_rejects_top_level_symlink_include(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            real = root / "real-evidence"
            real.mkdir()
            (real / "receipt.txt").write_text("observed\n", encoding="utf-8")
            (root / "evidence").symlink_to(real, target_is_directory=True)
            with self.assertRaisesRegex(ArchiveBuildError, "symbolic-link include"):
                build_archive(
                    root=root,
                    output=root / "archive.tar.gz",
                    includes=["evidence"],
                    evidence_date="2026-07-14",
                    repository_head="head",
                    status="test",
                )

    def test_archive_refuses_preexisting_temporary_symlink_without_writing_victim(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory) / "repo"
            root.mkdir()
            evidence = root / "evidence"
            evidence.mkdir()
            (evidence / "receipt.txt").write_text("observed\n", encoding="utf-8")
            victim = Path(directory) / "victim.txt"
            victim.write_text("preserve me\n", encoding="utf-8")
            temporary = root / "archive.tar.gz.tmp"
            temporary.symlink_to(victim)

            with self.assertRaisesRegex(ArchiveBuildError, "temporary path already exists"):
                build_archive(
                    root=root,
                    output=root / "archive.tar.gz",
                    includes=["evidence"],
                    evidence_date="2026-07-14",
                    repository_head="head",
                    status="test",
                )
            self.assertEqual(victim.read_text(encoding="utf-8"), "preserve me\n")
            self.assertTrue(temporary.is_symlink())


if __name__ == "__main__":
    unittest.main()
