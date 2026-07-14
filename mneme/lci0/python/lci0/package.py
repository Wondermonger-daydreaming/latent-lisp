"""Checksum-bound fixture package access used by conformance and examples."""

from __future__ import annotations

from functools import lru_cache
import hashlib
import json
import os
from pathlib import Path
from typing import Iterator
import zipfile

from .adapter import from_package_json
from .core import CD0_BUDGET


REGISTRY_SHA256 = "dd19c6d6543a875b2e7e1e6a234ad731ce019f64495b447b317462c63f826327"
VECTORS_SHA256 = "387e76963f3087f6e41ec4363ec3eea29b1456c2a6b3c5a0cf5763418bffe3a4"
FIXTURE_ARCHIVE_SHA256 = "36cc71ccf3c310a055199c54e84bf436c4505d92a6378f22e8b1d932f02e987d"
PACKAGE_ROOT = "lci0-errata-0.1-fixture-package-2026-07-14"


def fixture_root() -> Path:
    return Path(os.environ.get("LCI0_FIXTURE_DIR", "/tmp/lci0-seed-fixtures-20260714"))


def _verified_bytes(name: str, expected: str) -> bytes:
    candidate = fixture_root() / name
    if candidate.is_file():
        payload = candidate.read_bytes()
    else:
        archive_path = Path(__file__).resolve().parents[2] / "fixtures" / "archives" / f"{PACKAGE_ROOT}.zip"
        archive_bytes = archive_path.read_bytes()
        if hashlib.sha256(archive_bytes).hexdigest() != FIXTURE_ARCHIVE_SHA256:
            raise RuntimeError("frozen LCI fixture archive identity mismatch")
        with zipfile.ZipFile(archive_path) as archive:
            payload = archive.read(f"{PACKAGE_ROOT}/{name}")
    if hashlib.sha256(payload).hexdigest() != expected:
        raise RuntimeError(f"frozen LCI fixture identity mismatch: {name}")
    return payload


@lru_cache(maxsize=1)
def registry() -> dict:
    return json.loads(_verified_bytes("LCI0-FIXTURE-REGISTRY.json", REGISTRY_SHA256))


@lru_cache(maxsize=1)
def definitions() -> dict[str, dict]:
    rows = registry()["definitions"]
    result = {row["fixture_id"]: row for row in rows}
    if len(result) != 675:
        raise RuntimeError("fixture registry definition count mismatch")
    return result


def definition(fixture_id: str) -> dict:
    return definitions()[fixture_id]


def fixture_datum(fixture_id: str):
    return from_package_json(definition(fixture_id)["abstract_cd0"], CD0_BUDGET)


def iter_vectors() -> Iterator[dict]:
    data = _verified_bytes("LCI0-FIXTURE-VECTORS.jsonl", VECTORS_SHA256).decode("utf-8")
    for line in data.splitlines():
        if line:
            yield json.loads(line)
