#!/usr/bin/env python3
"""Phase-0 fixture audit for CD/0.

This is deliberately not a codec: it has no document decoder, runtime datum
types, resource enforcement, or failure classifier.  It independently encodes
the fixture AST under Section 15, extracts the worked hexadecimal rows from the
pinned specification, and checks fixture metadata/coverage.
"""

from __future__ import annotations

import hashlib
import json
import math
import re
import sys
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parents[2]
SPEC = ROOT / "mneme/spec/CANONICAL-DATUM-SPEC.md"
POSITIVE = ROOT / "canonical-datum/vectors/cd0-positive.jsonl"
NEGATIVE = ROOT / "canonical-datum/vectors/cd0-negative.jsonl"
BUDGETS = ROOT / "canonical-datum/vectors/cd0-budgets.json"
SCHEMA = ROOT / "canonical-datum/schema/cd0-fixtures.schema.json"
EXPECTED_SPEC_SHA256 = "d578e86e4d411611b091cca0bed1cafac2636c0908e95447fd4a13badcab6abc"
MAGIC_VERSION = bytes.fromhex("4c50434400")
HEX_RE = re.compile(r"^(?:[0-9a-f]{2})*$")
DECIMAL_RE = re.compile(r"^-?(?:0|[1-9][0-9]*)$")


def require(condition: bool, message: str) -> None:
    if not condition:
        raise AssertionError(message)


def read_jsonl(path: Path) -> list[dict[str, Any]]:
    rows: list[dict[str, Any]] = []
    for line_no, raw in enumerate(path.read_text(encoding="utf-8").splitlines(), 1):
        require(bool(raw.strip()), f"{path}:{line_no}: blank JSONL row")
        value = json.loads(raw)
        require(isinstance(value, dict), f"{path}:{line_no}: row is not an object")
        rows.append(value)
    return rows


def uvar(n: int) -> bytes:
    require(n >= 0, "UVAR input must be nonnegative")
    out = bytearray()
    while True:
        octet = n & 0x7F
        n >>= 7
        if n:
            out.append(octet | 0x80)
        else:
            out.append(octet)
            return bytes(out)


def zigzag(z: int) -> int:
    return 2 * z if z >= 0 else -2 * z - 1


def utf8_payload(hex_text: str, where: str, *, nonempty: bool = False) -> bytes:
    require(bool(HEX_RE.fullmatch(hex_text)), f"{where}: malformed lowercase octet hex")
    data = bytes.fromhex(hex_text)
    require(not nonempty or bool(data), f"{where}: empty identifier segment")
    text = data.decode("utf-8", errors="strict")
    require(text.encode("utf-8") == data, f"{where}: non-shortest UTF-8")
    require(not any(0xD800 <= ord(ch) <= 0xDFFF for ch in text), f"{where}: surrogate scalar")
    return data


def decimal(text: str, where: str) -> int:
    require(bool(DECIMAL_RE.fullmatch(text)), f"{where}: malformed decimal integer")
    return int(text)


def encode_identifier(ast: dict[str, Any], where: str) -> bytes:
    require(ast.get("t") == "id", f"{where}: record key is not id AST")
    namespace = ast.get("namespace_utf8_hex")
    path = ast.get("path_utf8_hex")
    require(isinstance(namespace, list), f"{where}: namespace is not a list")
    require(isinstance(path, list) and path, f"{where}: path must be nonempty")
    out = bytearray([0x22])
    out += uvar(len(namespace))
    for index, segment in enumerate(namespace):
        require(isinstance(segment, str), f"{where}: namespace segment is not hex text")
        payload = utf8_payload(segment, f"{where}.namespace[{index}]", nonempty=True)
        out += uvar(len(payload)) + payload
    out += uvar(len(path))
    for index, segment in enumerate(path):
        require(isinstance(segment, str), f"{where}: path segment is not hex text")
        payload = utf8_payload(segment, f"{where}.path[{index}]", nonempty=True)
        out += uvar(len(payload)) + payload
    return bytes(out)


def encode_value(ast: dict[str, Any], where: str = "datum") -> bytes:
    require(isinstance(ast, dict) and isinstance(ast.get("t"), str), f"{where}: invalid AST")
    tag = ast["t"]
    if tag == "unit":
        require(set(ast) == {"t"}, f"{where}: unexpected unit fields")
        return b"\x00"
    if tag == "bool":
        require(type(ast.get("v")) is bool, f"{where}: bool payload must be JSON boolean")
        return b"\x02" if ast["v"] else b"\x01"
    if tag == "int":
        z = decimal(ast.get("v"), f"{where}.v")
        return b"\x10" + uvar(zigzag(z))
    if tag == "rat":
        p = decimal(ast.get("p"), f"{where}.p")
        q = decimal(ast.get("q"), f"{where}.q")
        require(p != 0 and q > 1 and math.gcd(abs(p), q) == 1, f"{where}: noncanonical rational AST")
        return b"\x11" + uvar(zigzag(p)) + uvar(q)
    if tag == "string":
        payload = utf8_payload(ast.get("utf8_hex"), f"{where}.utf8_hex")
        return b"\x20" + uvar(len(payload)) + payload
    if tag == "bytes":
        hex_text = ast.get("hex")
        require(isinstance(hex_text, str) and HEX_RE.fullmatch(hex_text), f"{where}.hex: malformed hex")
        payload = bytes.fromhex(hex_text)
        return b"\x21" + uvar(len(payload)) + payload
    if tag == "id":
        return encode_identifier(ast, where)
    if tag == "seq":
        items = ast.get("items")
        require(isinstance(items, list), f"{where}.items: not a list")
        return b"\x30" + uvar(len(items)) + b"".join(
            encode_value(item, f"{where}.items[{index}]") for index, item in enumerate(items)
        )
    if tag == "record":
        fields = ast.get("fields")
        require(isinstance(fields, list), f"{where}.fields: not a list")
        encoded: list[tuple[bytes, bytes]] = []
        seen: set[bytes] = set()
        for index, field in enumerate(fields):
            require(isinstance(field, dict) and set(field) == {"key", "value"}, f"{where}.fields[{index}]: invalid field")
            key = encode_identifier(field["key"], f"{where}.fields[{index}].key")
            require(key not in seen, f"{where}: duplicate record key")
            seen.add(key)
            encoded.append((key, encode_value(field["value"], f"{where}.fields[{index}].value")))
        encoded.sort(key=lambda pair: pair[0])
        return b"\x31" + uvar(len(encoded)) + b"".join(key + value for key, value in encoded)
    raise AssertionError(f"{where}: unknown AST tag {tag!r}")


def worked_hex_from_spec(text: str) -> list[str]:
    start = text.index("### 15.15 Worked canonical documents")
    end = text.index("## 16. Human-readable notation", start)
    result: list[str] = []
    for line in text[start:end].splitlines():
        if not line.startswith("|") or "`" not in line:
            continue
        candidate = line.rsplit("`", 2)[1]
        if re.fullmatch(r"[0-9a-f]+", candidate):
            result.append(candidate)
    return result


def check_positive(rows: list[dict[str, Any]], spec_text: str, budget_names: set[str]) -> None:
    require(len(rows) == 17, f"positive fixture count is {len(rows)}, expected exactly 17")
    require(len({row.get('id') for row in rows}) == 17, "positive IDs are not unique")
    worked = worked_hex_from_spec(spec_text)
    require(len(worked) == 17, f"extracted {len(worked)} worked spec rows, expected 17")
    fixture_hex = [row.get("canonical_hex") for row in rows]
    require(fixture_hex == worked, "positive fixture order/hex differs from Section 15.15")
    for index, row in enumerate(rows, 1):
        require(row.get("datum_version") == 0, f"positive row {index}: datum_version")
        require(row.get("budget") in budget_names, f"positive row {index}: unknown budget")
        require(isinstance(row.get("notes"), list), f"positive row {index}: notes")
        expected = MAGIC_VERSION + encode_value(row["abstract"], f"positive[{index}].abstract")
        require(expected.hex() == row["canonical_hex"], f"positive row {index}: grammar-derived encoding mismatch")
        decoded_bytes = MAGIC_VERSION + encode_value(row["expected_decoded"], f"positive[{index}].expected_decoded")
        require(decoded_bytes == expected, f"positive row {index}: expected_decoded encodes differently")


def check_negative(rows: list[dict[str, Any]], budget_names: set[str]) -> None:
    require(len({row.get('id') for row in rows}) == len(rows), "negative IDs are not unique")
    categories = {"InvalidCanonicalGrammar", "NoncanonicalEncoding", "UnsupportedFormat", "ResourceRefusal", "PrivilegedRestorationAttempt"}
    stages = {"input-budget", "magic", "version-varint", "version-selection", "type-tag", "integer-payload", "rational-payload", "length", "count", "utf8", "identifier", "record-key", "record-order", "end-of-input"}
    for index, row in enumerate(rows, 1):
        require(row.get("input_kind") == "octets", f"negative row {index}: Phase 0 corpus is octet-only")
        require(isinstance(row.get("input_hex"), str) and HEX_RE.fullmatch(row["input_hex"]), f"negative row {index}: input_hex")
        require(row.get("budget") in budget_names, f"negative row {index}: unknown budget")
        failure = row.get("expected_failure")
        require(isinstance(failure, dict) and set(failure) == {"category", "code", "stage"}, f"negative row {index}: failure shape")
        require(failure["category"] in categories and failure["stage"] in stages, f"negative row {index}: failure vocabulary")
        require(row.get("resource_state_unchanged") is True, f"negative row {index}: state assertion")
        require(row.get("partial_output_forbidden") is True, f"negative row {index}: partial-output assertion")

    ids = {row["id"] for row in rows}
    required_fragments = [
        "magic-", "version-", "int-zero-overlong", "zigzag-127", "zigzag-128", "zigzag-16384",
        "rat-zero-denominator", "rat-zero-numerator", "rat-integral", "rat-unreduced",
        "utf8-continuation", "utf8-overlong", "utf8-surrogate", "utf8-above",
        "id-missing-path", "id-empty-segment", "record-key-not-id", "record-order", "record-duplicate",
        "trailing-concatenated", "resource-input", "resource-varint", "resource-string",
        "resource-sequence", "resource-record", "resource-identifier"
    ]
    for fragment in required_fragments:
        require(any(fragment in item for item in ids), f"negative coverage missing {fragment}")

    assigned = {0x00, 0x01, 0x02, 0x10, 0x11, 0x20, 0x21, 0x22, 0x30, 0x31}
    assigned_fixture_tags = {int(match.group(1), 16) for item in ids if (match := re.search(r"tag-([0-9a-f]{2})-", item))}
    require(assigned_fixture_tags == assigned, "negative corpus does not exercise every assigned /0 tag")
    reserved = set(range(0x03, 0x10)) | set(range(0x12, 0x20)) | set(range(0x23, 0x30)) | set(range(0x32, 0xF0))
    forbidden = set(range(0xF0, 0x100))
    require(not (assigned & reserved or assigned & forbidden or reserved & forbidden), "tag classes overlap")
    require(assigned | reserved | forbidden == set(range(256)), "tag allocation is not exhaustive")
    for tag in (0x03, 0x0F, 0x12, 0x1F, 0x23, 0x2F, 0x32, 0xEF):
        require(f"cd0-neg-reserved-{tag:02x}" in ids, f"missing reserved-range boundary {tag:02x}")
    for tag in (0xF0, 0xFF):
        require(f"cd0-neg-forbidden-{tag:02x}" in ids, f"missing forbidden boundary {tag:02x}")


def main() -> int:
    spec_bytes = SPEC.read_bytes()
    digest = hashlib.sha256(spec_bytes).hexdigest()
    require(digest == EXPECTED_SPEC_SHA256, f"spec digest mismatch: {digest}")
    spec_text = spec_bytes.decode("utf-8")
    schema = json.loads(SCHEMA.read_text(encoding="utf-8"))
    require(schema.get("$schema") == "https://json-schema.org/draft/2020-12/schema", "fixture schema draft")
    require({"datum", "failure", "positive", "negative"} <= set(schema.get("$defs", {})), "fixture schema definitions")
    budget_doc = json.loads(BUDGETS.read_text(encoding="utf-8"))
    budget_names = set(budget_doc.get("budgets", {}))
    required_limits = set(budget_doc.get("limits", []))
    default = budget_doc["budgets"].get("cd0-conformance-default")
    require(isinstance(default, dict) and set(default) == required_limits, "default budget is not complete")
    for name, budget in budget_doc["budgets"].items():
        require(isinstance(budget, dict), f"budget {name}: not an object")
        if name != "cd0-conformance-default":
            require(budget.get("base") == "cd0-conformance-default", f"budget {name}: bad base")
    positives = read_jsonl(POSITIVE)
    negatives = read_jsonl(NEGATIVE)
    check_positive(positives, spec_text, budget_names)
    check_negative(negatives, budget_names)
    print(f"spec sha256: {digest}")
    print(f"worked vectors: {len(positives)}/17 exact and grammar-derived encodings agree")
    print(f"negative vectors: {len(negatives)} structurally valid; required compact coverage present")
    print("type tags: 256/256 classified; all 10 assigned tags exercised; reserved/forbidden boundaries present")
    for path in (POSITIVE, NEGATIVE, BUDGETS, SCHEMA):
        print(f"sha256 {hashlib.sha256(path.read_bytes()).hexdigest()}  {path.relative_to(ROOT)}")
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except (AssertionError, KeyError, TypeError, UnicodeError, ValueError) as exc:
        print(f"phase0 verification failed: {exc}", file=sys.stderr)
        raise SystemExit(1)
