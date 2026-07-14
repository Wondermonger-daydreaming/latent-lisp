from __future__ import annotations

import gzip
import hashlib
import io
import json
from pathlib import Path
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


if __name__ == "__main__":
    unittest.main()
