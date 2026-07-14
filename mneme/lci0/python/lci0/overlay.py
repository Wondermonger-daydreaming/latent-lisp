"""Checksum-bound access to the LCI/0 authorial-closure fixture overlay 0.2.

The overlay (LCI0-FIXTURE-PACKAGE-ERRATA-0.2.md; ruling
LCI0-IMPLEMENTATION-CLOSURE-RULING.md) is additive fixture authority: it
supersedes exactly four 0.1 vector expectations, adds 38 relation companion
failures, eight hostile expectations, and four register-only closure records.
Resolution consults the overlay first for the supersession keys and falls
through to the untouched 0.1 package otherwise.

When the fixture root carries no overlay subdirectory, every function here
reports absence (``overlay_present() -> False``; lookups return ``None`` or
raise :class:`OverlayUnavailable`) and the 0.1 loading path in
:mod:`lci0.package` behaves exactly as before.
"""

from __future__ import annotations

from functools import lru_cache
import hashlib
import json
from pathlib import Path
import re

from .package import fixture_root


OVERLAY_ROOT_NAME = "lci0-fixture-overlay-0.2-2026-07-14"
# Exact deliverable hashes from OVERLAY-BUILD-RECEIPT.md §6.
OVERLAY_ARCHIVE_SHA256 = "5e03c2f5a17cf69f9b562dcfc5b7dfde85563fc7f88d52fcb01ffe858c1a10eb"
INDEX_NAME = "LCI0-FIXTURE-OVERLAY-0.2-INDEX.json"
INDEX_SHA256 = "949d0c802ea02903b858aa692ee5b846220a2442c3f481b397b4171a3b4a44ff"
SUMS_NAME = "LCI0-FIXTURE-OVERLAY-0.2-SHA256SUMS.txt"

SUPERSESSION_KEYS = frozenset(
    {"LCI0-N012", "LCI0-E5-COVERAGE-INSUFFICIENT", "LCI0-P029", "LCI0-P024"}
)


class OverlayUnavailable(RuntimeError):
    """No verified 0.2 overlay is present in the fixture root."""


class OverlayIntegrityError(RuntimeError):
    """Overlay bytes contradict their sealed checksums."""


def overlay_root() -> Path:
    return fixture_root() / OVERLAY_ROOT_NAME


def overlay_present() -> bool:
    return (overlay_root() / INDEX_NAME).is_file()


def _sha256(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


@lru_cache(maxsize=1)
def _verified_root() -> Path:
    """Verify SHA256SUMS over the on-disk overlay tree once, then trust it."""

    root = overlay_root()
    sums_path = root / SUMS_NAME
    if not sums_path.is_file():
        raise OverlayUnavailable(f"no fixture overlay at {root}")
    rows: list[tuple[str, str]] = []
    for line in sums_path.read_text("utf-8").splitlines():
        match = re.fullmatch(r"([0-9a-f]{64})  (?:\./)?(.+)", line)
        if match:
            rows.append((match.group(1), match.group(2)))
    if not rows:
        raise OverlayIntegrityError("overlay checksum manifest is empty")
    listed = {relative for _, relative in rows}
    on_disk = {
        str(path.relative_to(root))
        for path in root.rglob("*")
        if path.is_file()
    }
    if on_disk != listed | {SUMS_NAME}:
        raise OverlayIntegrityError(
            "overlay checksum manifest does not cover the on-disk tree"
        )
    for expected, relative in rows:
        if _sha256((root / relative).read_bytes()) != expected:
            raise OverlayIntegrityError(f"overlay member SHA-256 mismatch: {relative}")
    return root


@lru_cache(maxsize=1)
def index() -> dict:
    root = _verified_root()
    payload = (root / INDEX_NAME).read_bytes()
    if _sha256(payload) != INDEX_SHA256:
        raise OverlayIntegrityError("overlay index identity mismatch")
    document = json.loads(payload)
    if document.get("format") != "lci0-fixture-overlay-0.2-index":
        raise OverlayIntegrityError("unsupported overlay index format")
    if set(document.get("supersession_keys", ())) != SUPERSESSION_KEYS:
        raise OverlayIntegrityError("overlay supersession keys differ from the ruled four")
    return document


def member(relative: str) -> dict:
    """Load one overlay member document, verified against its index hash."""

    document = index()
    root = _verified_root()
    recorded = None
    for section in ("supersessions", "relation_failures", "hostile", "closure_records"):
        for entry in document.get(section, {}).values():
            if entry.get("member") == relative:
                recorded = entry.get("member_sha256")
                break
    payload = (root / relative).read_bytes()
    if recorded is not None and _sha256(payload) != recorded:
        raise OverlayIntegrityError(f"overlay member identity mismatch: {relative}")
    return json.loads(payload)


def supersessions() -> dict:
    return index()["supersessions"]


def superseded_expected(vector_id: str) -> dict | None:
    """Overlay-first resolution for the four superseded 0.1 vector keys.

    Returns the supersession entry (expected result inline per the index
    schema) or ``None`` so callers fall through to the frozen 0.1 expectation.
    """

    if vector_id not in SUPERSESSION_KEYS or not overlay_present():
        return None
    return supersessions().get(vector_id)


def relation_failures() -> dict:
    return index()["relation_failures"]


def hostile_expectations() -> dict:
    return index()["hostile"]


def closure_records() -> dict:
    return index()["closure_records"]
