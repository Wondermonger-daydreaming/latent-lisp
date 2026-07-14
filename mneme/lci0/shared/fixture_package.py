#!/usr/bin/env python3
"""Integrity and materialization tool for the frozen LCI/0 fixture package.

This module deliberately has no LCI semantic adapter. It verifies sealed bytes,
counts top-level fixture records, and safely materializes archive members. Each
language implementation owns its own JSON-to-CD/0 adapter.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import os
from pathlib import Path, PurePosixPath
import re
import shutil
import tempfile
import zipfile


LCI_ROOT = Path(__file__).resolve().parents[1]
FIXTURE_ARCHIVE = LCI_ROOT / "fixtures" / "archives" / "lci0-errata-0.1-fixture-package-2026-07-14.zip"
PASS_ARCHIVE = LCI_ROOT / "fixtures" / "archives" / "FABLE-LCI0-PASS-RECEIPT-PACKET-2026-07-14.zip"
PACKAGE_ROOT = "lci0-errata-0.1-fixture-package-2026-07-14"
FIXTURE_SHA256 = "36cc71ccf3c310a055199c54e84bf436c4505d92a6378f22e8b1d932f02e987d"
PASS_SHA256 = "89cd11ac52478a9e3ff9ebdefcc60b2fff8fa2c8707e159b4f4bd0b6e2cefdfd"
MAGIC = "4c50434400"

# LCI/0 authorial-closure additive fixture overlay 0.2 (LCI0-FIXTURE-PACKAGE-
# ERRATA-0.2.md; ruling LCI0-IMPLEMENTATION-CLOSURE-RULING.md).  The overlay is
# a sibling archive: fixture 0.1 stays byte-for-byte unchanged and every 0.1
# verification path above is untouched.  A materialized fixture root optionally
# carries the overlay as the subdirectory OVERLAY_ROOT next to the 0.1 members;
# loaders consult the overlay first for exactly the four superseded vector
# expectations and fall through to 0.1 otherwise.
OVERLAY_ARCHIVE = LCI_ROOT / "fixtures" / "archives" / "lci0-fixture-overlay-0.2-2026-07-14.zip"
OVERLAY_ROOT = "lci0-fixture-overlay-0.2-2026-07-14"
OVERLAY_SHA256 = "5e03c2f5a17cf69f9b562dcfc5b7dfde85563fc7f88d52fcb01ffe858c1a10eb"

TRACKED_PACKAGE_COPIES = {
    "reviewed-inputs/normative-candidate/LOCATED-CLAIM-IDENTITY-SPEC.md": "spec/LOCATED-CLAIM-IDENTITY-SPEC.md",
    "LCI0-POST-REVIEW-RULING.md": "spec/LCI0-POST-REVIEW-RULING.md",
    "LOCATED-CLAIM-IDENTITY-SPEC-ERRATA-0.1.md": "spec/LOCATED-CLAIM-IDENTITY-SPEC-ERRATA-0.1.md",
    "LCI0-NORMATIVE-FIXTURE-PACKAGE-SPEC.md": "spec/LCI0-NORMATIVE-FIXTURE-PACKAGE-SPEC.md",
    "LCI0-FIXTURE-PACKAGE-MANIFEST.md": "fixtures/LCI0-FIXTURE-PACKAGE-MANIFEST.md",
    "LCI0-FIXTURE-SHA256SUMS.txt": "fixtures/LCI0-FIXTURE-SHA256SUMS.txt",
    "reviewed-inputs/review/FABLE-LCI0-CONSTITUTIONAL-REVIEW.md": "spec/FABLE-LCI0-CONSTITUTIONAL-REVIEW.md",
    "reviewed-inputs/review/FABLE-LCI0-ISSUE-REGISTER.md": "spec/FABLE-LCI0-ISSUE-REGISTER.md",
    "reviewed-inputs/review/FABLE-LCI0-IMPLEMENTATION-READINESS-RELAY.md": "spec/FABLE-LCI0-IMPLEMENTATION-READINESS-RELAY.md",
}


class VerificationError(RuntimeError):
    pass


def _sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for chunk in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def _sha256_zip_member(archive: zipfile.ZipFile, member: str) -> tuple[str, int]:
    digest = hashlib.sha256()
    count = 0
    with archive.open(member, "r") as stream:
        for chunk in iter(lambda: stream.read(1024 * 1024), b""):
            count += len(chunk)
            digest.update(chunk)
    return digest.hexdigest(), count


def _safe_member(name: str) -> None:
    path = PurePosixPath(name)
    if path.is_absolute() or ".." in path.parts or not path.parts:
        raise VerificationError(f"unsafe archive member: {name!r}")


def _parse_sha256_lines(text: str) -> list[tuple[str, str]]:
    rows: list[tuple[str, str]] = []
    for line in text.splitlines():
        match = re.fullmatch(r"([0-9a-f]{64})  (?:\./)?(.+)", line)
        if match:
            rows.append((match.group(1), match.group(2)))
    return rows


def verify_fixture_archive() -> dict[str, object]:
    if _sha256_file(FIXTURE_ARCHIVE) != FIXTURE_SHA256:
        raise VerificationError("fixture archive SHA-256 mismatch")
    with zipfile.ZipFile(FIXTURE_ARCHIVE) as archive:
        bad = archive.testzip()
        if bad is not None:
            raise VerificationError(f"fixture archive CRC failure: {bad}")
        files = [info.filename for info in archive.infolist() if not info.is_dir()]
        for name in files:
            _safe_member(name)
        checksum_member = f"{PACKAGE_ROOT}/LCI0-FIXTURE-SHA256SUMS.txt"
        checksum_rows = _parse_sha256_lines(archive.read(checksum_member).decode("utf-8"))
        if len(checksum_rows) != 21:
            raise VerificationError(f"expected 21 fixture checksum rows, got {len(checksum_rows)}")
        expected_files = {
            checksum_member,
            *(_package_member(relative) for _, relative in checksum_rows),
        }
        if set(files) != expected_files:
            raise VerificationError("fixture checksum manifest does not cover every non-manifest member")
        for expected, relative in checksum_rows:
            actual, _ = _sha256_zip_member(archive, f"{PACKAGE_ROOT}/{relative}")
            if actual != expected:
                raise VerificationError(f"fixture member SHA-256 mismatch: {relative}")
        for archived, local in TRACKED_PACKAGE_COPIES.items():
            source_hash, _ = _sha256_zip_member(archive, f"{PACKAGE_ROOT}/{archived}")
            if source_hash != _sha256_file(LCI_ROOT / local):
                raise VerificationError(f"tracked package copy differs: {local}")
    return {"archive_sha256": FIXTURE_SHA256, "file_members": len(files), "sealed_members": 21}


def verify_pass_archive() -> dict[str, object]:
    if _sha256_file(PASS_ARCHIVE) != PASS_SHA256:
        raise VerificationError("Fable PASS archive SHA-256 mismatch")
    with zipfile.ZipFile(PASS_ARCHIVE) as archive:
        bad = archive.testzip()
        if bad is not None:
            raise VerificationError(f"Fable PASS archive CRC failure: {bad}")
        files = [info.filename for info in archive.infolist() if not info.is_dir()]
        for name in files:
            _safe_member(name)
        rows = _parse_sha256_lines(archive.read("packet/PACKET-MANIFEST.md").decode("utf-8"))
        if len(rows) != 41:
            raise VerificationError(f"expected 41 PASS manifest rows, got {len(rows)}")
        expected_files = {"packet/PACKET-MANIFEST.md", *(f"packet/{relative}" for _, relative in rows)}
        if set(files) != expected_files:
            raise VerificationError("PASS manifest does not cover every non-manifest member")
        for expected, relative in rows:
            actual, _ = _sha256_zip_member(archive, f"packet/{relative}")
            if actual != expected:
                raise VerificationError(f"PASS member SHA-256 mismatch: {relative}")
        receipt_hash, _ = _sha256_zip_member(
            archive, "packet/FABLE-LCI0-ERRATA-0.1-FIXTURE-PACKAGE-PASS-RECEIPT.md"
        )
        if receipt_hash != _sha256_file(
            LCI_ROOT / "spec" / "FABLE-LCI0-ERRATA-0.1-FIXTURE-PACKAGE-PASS-RECEIPT.md"
        ):
            raise VerificationError("tracked Fable PASS receipt differs from sealed packet")
    return {"archive_sha256": PASS_SHA256, "file_members": len(files), "sealed_members": 41}


def _package_member(relative: str) -> str:
    return f"{PACKAGE_ROOT}/{relative}"


def census() -> dict[str, object]:
    with zipfile.ZipFile(FIXTURE_ARCHIVE) as archive:
        with archive.open(_package_member("LCI0-FIXTURE-REGISTRY.json")) as stream:
            registry = json.load(stream)
        definitions = registry.get("definitions")
        if not isinstance(definitions, list):
            raise VerificationError("registry definitions is not a list")
        fixture_ids = [row.get("fixture_id") for row in definitions]
        if len(fixture_ids) != len(set(fixture_ids)):
            raise VerificationError("duplicate fixture_id")
        vectors: list[dict[str, object]] = []
        with archive.open(_package_member("LCI0-FIXTURE-VECTORS.jsonl")) as stream:
            for raw in stream:
                if raw.strip():
                    vectors.append(json.loads(raw))
        vector_ids = [row.get("vector_id") for row in vectors]
        if len(vector_ids) != len(set(vector_ids)):
            raise VerificationError("duplicate vector_id")
        required = {*(f"LCI0-P{i:03d}" for i in range(1, 31)), *(f"LCI0-N{i:03d}" for i in range(1, 33))}
        missing = sorted(required.difference(vector_ids))
        if missing:
            raise VerificationError(f"missing required vectors: {missing}")
        official_docs = len(definitions) + 2 * len(vectors)
        relation_docs = 0
        for table in registry.get("relation_and_mapping_tables", {}).values():
            if isinstance(table, dict):
                relation_docs += sum(
                    1 for entry in table.get("entries", [])
                    if isinstance(entry, dict) and str(entry.get("canonical_cd0_hex", "")).startswith(MAGIC)
                )
        nested_e1 = 0
        for row in vectors:
            if str(row.get("vector_id", "")).startswith("LCI0-E1-"):
                stack: list[object] = [row]
                while stack:
                    value = stack.pop()
                    if isinstance(value, dict):
                        for key, child in value.items():
                            if key in {"canonical_cd0_hex", "hex"} and isinstance(child, str) and child.startswith(MAGIC):
                                if key == "hex":
                                    nested_e1 += 1
                            else:
                                stack.append(child)
                    elif isinstance(value, list):
                        stack.extend(value)
        result = {
            "registry_definitions": len(definitions),
            "vectors": len(vectors),
            "official_documents": official_docs,
            "relation_table_documents": relation_docs,
            "nested_e1_documents": nested_e1,
            "supplementary_documents": relation_docs + nested_e1,
            "total_documents": official_docs + relation_docs + nested_e1,
        }
        expected = {
            "registry_definitions": 675,
            "vectors": 215,
            "official_documents": 1105,
            "relation_table_documents": 458,
            "nested_e1_documents": 30,
            "supplementary_documents": 488,
            "total_documents": 1593,
        }
        if result != expected:
            raise VerificationError(f"fixture census mismatch: {result!r}")
        return result


def materialize(destination: Path) -> Path:
    verify_fixture_archive()
    destination = destination.resolve()
    if destination.exists():
        raise VerificationError(f"destination already exists: {destination}")
    destination.parent.mkdir(parents=True, exist_ok=True)
    staging = Path(tempfile.mkdtemp(prefix=".lci0-materialize-", dir=destination.parent))
    try:
        with zipfile.ZipFile(FIXTURE_ARCHIVE) as archive:
            for info in archive.infolist():
                _safe_member(info.filename)
                parts = PurePosixPath(info.filename).parts
                if not parts or parts[0] != PACKAGE_ROOT:
                    raise VerificationError(f"unexpected package root: {info.filename}")
                relative = Path(*parts[1:])
                target = staging / relative
                if info.is_dir():
                    target.mkdir(parents=True, exist_ok=True)
                    continue
                target.parent.mkdir(parents=True, exist_ok=True)
                with archive.open(info, "r") as source, target.open("xb") as sink:
                    shutil.copyfileobj(source, sink, length=1024 * 1024)
        os.replace(staging, destination)
        return destination
    except BaseException:
        shutil.rmtree(staging, ignore_errors=True)
        raise


def verify_overlay_archive() -> dict[str, object]:
    """Verify the additive 0.2 overlay archive (never touches 0.1 paths)."""

    if _sha256_file(OVERLAY_ARCHIVE) != OVERLAY_SHA256:
        raise VerificationError("overlay archive SHA-256 mismatch")
    with zipfile.ZipFile(OVERLAY_ARCHIVE) as archive:
        bad = archive.testzip()
        if bad is not None:
            raise VerificationError(f"overlay archive CRC failure: {bad}")
        files = [info.filename for info in archive.infolist() if not info.is_dir()]
        for name in files:
            _safe_member(name)
            if PurePosixPath(name).parts[0] != OVERLAY_ROOT:
                raise VerificationError(f"unexpected overlay root: {name}")
        checksum_member = f"{OVERLAY_ROOT}/LCI0-FIXTURE-OVERLAY-0.2-SHA256SUMS.txt"
        checksum_rows = _parse_sha256_lines(archive.read(checksum_member).decode("utf-8"))
        expected_files = {
            checksum_member,
            *(f"{OVERLAY_ROOT}/{relative}" for _, relative in checksum_rows),
        }
        if set(files) != expected_files:
            raise VerificationError("overlay checksum manifest does not cover every non-manifest member")
        for expected, relative in checksum_rows:
            actual, _ = _sha256_zip_member(archive, f"{OVERLAY_ROOT}/{relative}")
            if actual != expected:
                raise VerificationError(f"overlay member SHA-256 mismatch: {relative}")
    return {
        "archive_sha256": OVERLAY_SHA256,
        "file_members": len(files),
        "sealed_members": len(checksum_rows),
    }


def materialize_overlay(fixture_root: Path) -> Path:
    """Extract the verified 0.2 overlay into an existing 0.1 fixture root.

    Additive only: refuses to overwrite anything, so the 0.1 members remain
    byte-identical.  The overlay lands as the subdirectory OVERLAY_ROOT — the
    cross-language fixture-root layout contract.
    """

    verify_overlay_archive()
    fixture_root = fixture_root.resolve()
    if not fixture_root.is_dir():
        raise VerificationError(f"fixture root does not exist: {fixture_root}")
    destination = fixture_root / OVERLAY_ROOT
    if destination.exists():
        raise VerificationError(f"overlay destination already exists: {destination}")
    staging = Path(tempfile.mkdtemp(prefix=".lci0-overlay-", dir=fixture_root))
    try:
        with zipfile.ZipFile(OVERLAY_ARCHIVE) as archive:
            for info in archive.infolist():
                _safe_member(info.filename)
                parts = PurePosixPath(info.filename).parts
                if not parts or parts[0] != OVERLAY_ROOT:
                    raise VerificationError(f"unexpected overlay root: {info.filename}")
                relative = Path(*parts[1:])
                target = staging / relative
                if info.is_dir():
                    target.mkdir(parents=True, exist_ok=True)
                    continue
                target.parent.mkdir(parents=True, exist_ok=True)
                with archive.open(info, "r") as source, target.open("xb") as sink:
                    shutil.copyfileobj(source, sink, length=1024 * 1024)
        os.replace(staging, destination)
        return destination
    except BaseException:
        shutil.rmtree(staging, ignore_errors=True)
        raise


def main() -> int:
    parser = argparse.ArgumentParser()
    subparsers = parser.add_subparsers(dest="command", required=True)
    subparsers.add_parser("verify")
    subparsers.add_parser("census")
    materialize_parser = subparsers.add_parser("materialize")
    materialize_parser.add_argument("--destination", type=Path, required=True)
    subparsers.add_parser("verify-overlay")
    overlay_parser = subparsers.add_parser("materialize-overlay")
    overlay_parser.add_argument("--fixture-root", type=Path, required=True)
    arguments = parser.parse_args()
    if arguments.command == "verify":
        print(json.dumps({"fixture": verify_fixture_archive(), "pass": verify_pass_archive()}, sort_keys=True))
    elif arguments.command == "census":
        print(json.dumps(census(), sort_keys=True))
    elif arguments.command == "verify-overlay":
        print(json.dumps({"overlay": verify_overlay_archive()}, sort_keys=True))
    elif arguments.command == "materialize-overlay":
        print(materialize_overlay(arguments.fixture_root))
    else:
        print(materialize(arguments.destination))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
