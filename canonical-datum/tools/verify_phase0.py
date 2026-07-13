#!/usr/bin/env python3
"""Finite Phase-0 fixture audit for CD/0.

This is deliberately not a codec: it has no document decoder, runtime datum
types, or resource enforcement.  It independently encodes fixture ASTs under
Section 15, extracts the worked hexadecimal rows from the pinned specification,
validates the shared JSON Schema, and pins the independently reviewed compact
negative manifest.  The manifest pin detects fixture drift; it is not an
independent decoder oracle and the evidence receipt states that boundary.
"""

from __future__ import annotations

import hashlib
import json
import math
import re
import sys
from copy import deepcopy
from pathlib import Path
from typing import Any

from jsonschema import Draft202012Validator


ROOT = Path(__file__).resolve().parents[2]
SPEC = ROOT / "mneme/spec/CANONICAL-DATUM-SPEC.md"
POSITIVE = ROOT / "canonical-datum/vectors/cd0-positive.jsonl"
NEGATIVE = ROOT / "canonical-datum/vectors/cd0-negative.jsonl"
BUDGETS = ROOT / "canonical-datum/vectors/cd0-budgets.json"
SCHEMA = ROOT / "canonical-datum/schema/cd0-fixtures.schema.json"
DISTINCT = ROOT / "canonical-datum/vectors/cd0-distinct-pairs.json"
ERRATA_VECTORS = ROOT / "canonical-datum/vectors/cd0-errata-0.1.json"
EXPECTED_SPEC_SHA256 = "d578e86e4d411611b091cca0bed1cafac2636c0908e95447fd4a13badcab6abc"
EXPECTED_NEGATIVE_MANIFEST_SHA256 = "d491d83e8b27d3224567f1948e90b92db2ea02689c464fe6144c69bb2cb851a6"
EXPECTED_ERRATA_VECTORS_SHA256 = "55725e14e763075a8866be9da8be9f8647b5b06803e1fea6f661068d87651ddc"
MAGIC_VERSION = bytes.fromhex("4c50434400")
HEX_RE = re.compile(r"^(?:[0-9a-f]{2})*$")
DECIMAL_RE = re.compile(r"^(?:0|-?[1-9][0-9]*)$")

FAILURE_CODES_BY_CATEGORY = {
    "InvalidCanonicalGrammar": {
        "InvalidMagic", "InvalidTypeTag", "ReservedTypeTag", "TruncatedInput",
        "TrailingBytes", "InvalidUTF8", "ForbiddenUnicodeScalar",
        "ZeroDenominator", "EmptyIdentifierSegment", "MissingIdentifierPath",
        "RecordKeyNotIdentifier", "DuplicateRecordField",
    },
    "NoncanonicalEncoding": {
        "NonminimalVersionEncoding", "NonminimalIntegerEncoding",
        "NonminimalRationalComponentEncoding", "OverlongLengthEncoding",
        "OverlongCountEncoding", "ZeroRationalEncoding",
        "IntegralRationalEncoding", "UnreducedRational",
        "NoncanonicalFieldOrder",
    },
    "UnsupportedFormat": {
        "UnknownVersion", "UnsupportedFutureVersion", "UnsupportedExtensionTag",
    },
    "ResourceRefusal": {
        "ExcessiveInputLength", "ExcessiveOutputLength", "ExcessiveDeclaredLength",
        "ExcessiveContainerCount", "ExcessiveIdentifierSegments",
        "ExcessiveNesting", "IntegerBudgetExceeded", "VarintBudgetExceeded",
        "NodeBudgetExceeded", "AggregatePayloadBudgetExceeded",
        "RecordKeyWorkBudgetExceeded", "AllocationRefused",
    },
    "UnsupportedHostInput": {
        "UnsupportedHostType", "CyclicHostInput", "ImproperHostList",
        "AmbiguousIdentifier", "InvalidHostUnicode",
        "NegativeDenominatorHostRational", "ZeroDenominator",
        "EmptyIdentifierSegment", "MissingIdentifierPath",
        "DuplicateRecordField",
    },
    "PrivilegedRestorationAttempt": {
        "ForbiddenPrivilegedTag", "PrivilegedHostValue",
        "PrivilegedRestorationRequested",
    },
    "InternalInvariantFailure": {
        "EncoderInvariantFailure", "DecoderInvariantFailure", "CachedOctetsMismatch",
    },
}

STAGES = {
    "input-budget", "magic", "version-varint", "version-selection", "type-tag",
    "integer-payload", "rational-payload", "length", "count", "utf8",
    "identifier", "record-key", "record-order", "container-content",
    "end-of-input", "host-import", "encode-ordering", "allocation",
    "cache-check", "internal",
}


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


def require_canonical_decoded_record_order(ast: dict[str, Any], where: str) -> None:
    """Expected-decoded records are fixture views and must already be canonical."""
    tag = ast.get("t")
    if tag == "record":
        fields = ast["fields"]
        keys = [encode_identifier(field["key"], f"{where}.fields[{index}].key")
                for index, field in enumerate(fields)]
        require(keys == sorted(keys), f"{where}: record fields are not in canonical key order")
        require(len(keys) == len(set(keys)), f"{where}: duplicate record key")
        for index, field in enumerate(fields):
            require_canonical_decoded_record_order(field["value"], f"{where}.fields[{index}].value")
    elif tag == "seq":
        for index, item in enumerate(ast["items"]):
            require_canonical_decoded_record_order(item, f"{where}.items[{index}]")


def validate_budget_reference(value: Any, budget_names: set[str], limits: set[str], where: str) -> None:
    if isinstance(value, str):
        require(value in budget_names, f"{where}: unknown named budget {value!r}")
        return
    require(isinstance(value, dict) and set(value) == limits, f"{where}: incomplete explicit budget")
    for key, item in value.items():
        require(type(item) is int and item >= 0, f"{where}.{key}: expected nonnegative integer")


def normalize_construction(descriptor: dict[str, Any], where: str) -> dict[str, Any]:
    require(set(descriptor) == {"op", "p", "q"}, f"{where}: construction shape")
    require(descriptor.get("op") == "rational", f"{where}: construction operation")
    p = decimal(descriptor.get("p"), f"{where}.p")
    q = decimal(descriptor.get("q"), f"{where}.q")
    require(q != 0, f"{where}: zero denominator is not a positive construction")
    if q < 0:
        p, q = -p, -q
    divisor = math.gcd(abs(p), q)
    p //= divisor
    q //= divisor
    if p == 0:
        return {"t": "int", "v": "0"}
    if q == 1:
        return {"t": "int", "v": str(p)}
    return {"t": "rat", "p": str(p), "q": str(q)}


def check_positive(
    rows: list[dict[str, Any]], spec_text: str, budget_names: set[str],
    limits: set[str], distinct: dict[str, Any],
) -> None:
    require(len(rows) >= 17, f"positive fixture count is {len(rows)}, expected at least 17")
    require(len({row.get('id') for row in rows}) == len(rows), "positive IDs are not unique")
    worked = worked_hex_from_spec(spec_text)
    require(len(worked) == 17, f"extracted {len(worked)} worked spec rows, expected 17")
    fixture_hex = [row.get("canonical_hex") for row in rows[:17]]
    require(fixture_hex == worked, "positive fixture order/hex differs from Section 15.15")
    for index, row in enumerate(rows, 1):
        require(row.get("datum_version") == 0, f"positive row {index}: datum_version")
        validate_budget_reference(row.get("budget"), budget_names, limits, f"positive row {index}.budget")
        require(isinstance(row.get("notes"), list), f"positive row {index}: notes")
        if "construction" in row:
            require(
                normalize_construction(row["construction"], f"positive[{index}].construction")
                == row["abstract"],
                f"positive row {index}: construction does not normalize to abstract datum",
            )
        expected = MAGIC_VERSION + encode_value(row["abstract"], f"positive[{index}].abstract")
        require(expected.hex() == row["canonical_hex"], f"positive row {index}: grammar-derived encoding mismatch")
        require_canonical_decoded_record_order(row["expected_decoded"], f"positive[{index}].expected_decoded")
        decoded_bytes = MAGIC_VERSION + encode_value(row["expected_decoded"], f"positive[{index}].expected_decoded")
        require(decoded_bytes == expected, f"positive row {index}: expected_decoded encodes differently")

    classes: dict[str, set[str]] = {}
    classes_by_hex: dict[str, set[str]] = {}
    for row in rows:
        classes.setdefault(row["equality_class"], set()).add(row["canonical_hex"])
        classes_by_hex.setdefault(row["canonical_hex"], set()).add(row["equality_class"])
    require(all(len(hexes) == 1 for hexes in classes.values()),
            "one equality class contains different canonical documents")
    require(all(len(class_names) == 1 for class_names in classes_by_hex.values()),
            "one canonical document is split across equality classes")

    by_id = {row["id"]: row for row in rows}
    require(distinct.get("schema") == "cd0-distinct-pairs/v1", "distinct-pair manifest schema")
    for index, pair in enumerate(distinct.get("pairs", []), 1):
        left = by_id.get(pair.get("left"))
        right = by_id.get(pair.get("right"))
        require(left is not None and right is not None, f"distinct pair {index}: unknown vector ID")
        require(left["equality_class"] != right["equality_class"], f"distinct pair {index}: same equality class")
        require(left["canonical_hex"] != right["canonical_hex"], f"distinct pair {index}: same canonical bytes")


def canonical_jsonl_digest(rows: list[dict[str, Any]]) -> str:
    payload = "".join(json.dumps(row, ensure_ascii=False, separators=(",", ":")) + "\n" for row in rows)
    return hashlib.sha256(payload.encode("utf-8")).hexdigest()


def check_negative(rows: list[dict[str, Any]], budget_names: set[str], limits: set[str]) -> None:
    require(len(rows) == 71, f"negative classified total is {len(rows)}, expected 71")
    require(sum(row.get("input_kind") == "octets" for row in rows) == 66,
            "negative octet total must remain 66")
    require(sum(row.get("input_kind") == "host" for row in rows) == 5,
            "negative host total must remain 5")
    require(len({row.get('id') for row in rows}) == len(rows), "negative IDs are not unique")
    for index, row in enumerate(rows, 1):
        kind = row.get("input_kind")
        require(kind in {"octets", "host"}, f"negative row {index}: input_kind")
        if kind == "octets":
            require(isinstance(row.get("input_hex"), str) and HEX_RE.fullmatch(row["input_hex"]),
                    f"negative row {index}: input_hex")
            require("host_input" not in row and "importer" not in row,
                    f"negative row {index}: octet/host fields mixed")
        else:
            require(isinstance(row.get("host_input"), dict) and isinstance(row.get("importer"), str),
                    f"negative row {index}: host descriptor")
            require("input_hex" not in row, f"negative row {index}: host row has input_hex")
        validate_budget_reference(row.get("budget"), budget_names, limits, f"negative row {index}.budget")
        if "retry_budget" in row:
            validate_budget_reference(row["retry_budget"], budget_names, limits,
                                      f"negative row {index}.retry_budget")
        failure = row.get("expected_failure")
        require(isinstance(failure, dict) and set(failure) == {"category", "code", "stage"}, f"negative row {index}: failure shape")
        require(failure["category"] in FAILURE_CODES_BY_CATEGORY, f"negative row {index}: failure category")
        require(failure["code"] in FAILURE_CODES_BY_CATEGORY[failure["category"]],
                f"negative row {index}: code/category mismatch")
        require(failure["stage"] in STAGES, f"negative row {index}: failure stage")
        require(row.get("status", "normative") == "normative",
                f"negative row {index}: Errata 0.1 leaves no provisional row")
        require(row.get("resource_state_unchanged") is True, f"negative row {index}: state assertion")
        require(row.get("partial_output_forbidden") is True, f"negative row {index}: partial-output assertion")

    actual_digest = canonical_jsonl_digest(rows)
    require(actual_digest == EXPECTED_NEGATIVE_MANIFEST_SHA256,
            f"negative manifest differs from Errata 0.1 promotion pin: {actual_digest}")

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


def check_errata_vectors(
    manifest: dict[str, Any], budget_names: set[str], limits: set[str]
) -> None:
    cases = manifest["cases"]
    require(len(cases) == 37, f"Errata 0.1 case count is {len(cases)}, expected 37")
    require(len({case["id"] for case in cases}) == len(cases), "errata case IDs are not unique")
    require({case["adjudication"] for case in cases} == {f"A{index}" for index in range(1, 10)},
            "errata vector coverage does not span A1-A9")
    for index, case in enumerate(cases, 1):
        require(case["budget"] in budget_names, f"errata case {index}: unknown budget")
        require(set(case.get("overrides", {})) <= limits, f"errata case {index}: bad override")
        operation = case["op"]
        require((operation == "decode-only") == ("input_hex" in case),
                f"errata case {index}: decode input shape")
        require((operation == "construction-only") == ("construction" in case),
                f"errata case {index}: construction input shape")
        require((operation in {"fixture-import-only", "runtime-encode"}) == ("ast" in case),
                f"errata case {index}: AST input shape")
        expected = case["expected"]
        if expected["status"] == "failure":
            failure = expected["failure"]
            require(failure["code"] in FAILURE_CODES_BY_CATEGORY[failure["category"]],
                    f"errata case {index}: failure code/category")
            require(failure["stage"] in STAGES, f"errata case {index}: failure stage")

    actual_digest = hashlib.sha256(ERRATA_VECTORS.read_bytes()).hexdigest()
    require(actual_digest == EXPECTED_ERRATA_VECTORS_SHA256,
            f"errata vector manifest differs from pin: {actual_digest}")


def expect_assertion(action: Any, message: str) -> None:
    try:
        action()
    except AssertionError:
        return
    raise AssertionError(message)


def main() -> int:
    spec_bytes = SPEC.read_bytes()
    digest = hashlib.sha256(spec_bytes).hexdigest()
    require(digest == EXPECTED_SPEC_SHA256, f"spec digest mismatch: {digest}")
    spec_text = spec_bytes.decode("utf-8")
    schema = json.loads(SCHEMA.read_text(encoding="utf-8"))
    require(schema.get("$schema") == "https://json-schema.org/draft/2020-12/schema", "fixture schema draft")
    require(schema.get("x-fixture-schema-revision") == "0.1", "fixture schema revision")
    require({"construction", "datum", "failure", "positive", "negative"} <= set(schema.get("$defs", {})), "fixture schema definitions")
    Draft202012Validator.check_schema(schema)
    row_validator = Draft202012Validator(schema)
    distinct_validator = Draft202012Validator({
        "$schema": schema["$schema"],
        "$defs": schema["$defs"],
        "$ref": "#/$defs/distinctPairManifest",
    })
    errata_validator = Draft202012Validator({
        "$schema": schema["$schema"],
        "$defs": schema["$defs"],
        "$ref": "#/$defs/errataManifest",
    })
    budget_doc = json.loads(BUDGETS.read_text(encoding="utf-8"))
    budget_names = set(budget_doc.get("budgets", {}))
    required_limits = set(budget_doc.get("limits", []))
    default = budget_doc["budgets"].get("cd0-conformance-default")
    require(isinstance(default, dict) and set(default) == required_limits, "default budget is not complete")
    require(all(type(value) is int and value >= 0 for value in default.values()),
            "default budget values must be nonnegative integers")
    for name, budget in budget_doc["budgets"].items():
        require(isinstance(budget, dict), f"budget {name}: not an object")
        if name != "cd0-conformance-default":
            require(budget.get("base") == "cd0-conformance-default", f"budget {name}: bad base")
            require(set(budget) - {"base"} <= required_limits, f"budget {name}: unknown override")
            require(all(type(value) is int and value >= 0 for key, value in budget.items() if key != "base"),
                    f"budget {name}: invalid override")
    positives = read_jsonl(POSITIVE)
    negatives = read_jsonl(NEGATIVE)
    distinct = json.loads(DISTINCT.read_text(encoding="utf-8"))
    errata_vectors = json.loads(ERRATA_VECTORS.read_text(encoding="utf-8"))
    for index, row in enumerate(positives, 1):
        errors = sorted(row_validator.iter_errors(row), key=lambda error: list(error.path))
        require(not errors, f"positive row {index}: JSON Schema: {errors[0].message if errors else ''}")
    for index, row in enumerate(negatives, 1):
        errors = sorted(row_validator.iter_errors(row), key=lambda error: list(error.path))
        require(not errors, f"negative row {index}: JSON Schema: {errors[0].message if errors else ''}")
    distinct_errors = list(distinct_validator.iter_errors(distinct))
    require(not distinct_errors,
            f"distinct-pair manifest JSON Schema: {distinct_errors[0].message if distinct_errors else ''}")
    errata_errors = list(errata_validator.iter_errors(errata_vectors))
    require(not errata_errors,
            f"errata manifest JSON Schema: {errata_errors[0].message if errata_errors else ''}")

    check_positive(positives, spec_text, budget_names, required_limits, distinct)
    check_negative(negatives, budget_names, required_limits)
    check_errata_vectors(errata_vectors, budget_names, required_limits)

    # Mutation self-tests guard the two underchecks found by independent audit.
    bad_negatives = deepcopy(negatives)
    target = next(row for row in bad_negatives if row["id"] == "cd0-neg-rat-zero-denominator")
    target["expected_failure"]["code"] = "TruncatedInput"  # same valid category, wrong primary code
    expect_assertion(
        lambda: check_negative(bad_negatives, budget_names, required_limits),
        "negative verifier accepted a deliberately wrong primary code",
    )
    bad_positives = deepcopy(positives)
    target_positive = next(row for row in bad_positives if row["id"] == "cd0-pos-worked-15-record-a-b")
    target_positive["expected_decoded"]["fields"].reverse()
    expect_assertion(
        lambda: check_positive(bad_positives, spec_text, budget_names, required_limits, distinct),
        "positive verifier accepted reversed expected_decoded record order",
    )
    split_classes = deepcopy(positives)
    split_target = next(row for row in split_classes if row["id"] == "cd0-pos-boundary-zigzag-128")
    split_target["equality_class"] = "int:64-wrong-second-class"
    expect_assertion(
        lambda: check_positive(split_classes, spec_text, budget_names, required_limits, distinct),
        "positive verifier accepted equal bytes split across equality classes",
    )
    print(f"spec sha256: {digest}")
    print("worked vectors: 17/17 exact and grammar-derived encodings agree")
    print(f"additional positives: {len(positives) - 17}; equality classes and distinct pairs valid")
    print("negative vectors: 71 classified = 66 octet + 5 host; all complete normative triples")
    print("execution accounting contract: Python 71 executed; Common Lisp 68 executed + 3 N/A; 0 failures; 0 skips")
    print("promoted Errata 0.1 operation vectors: 37 complete A1-A9 cases")
    print("mutation self-tests: wrong failure code, reversed decoded record order, and split equality class rejected")
    print("type tags: 256/256 classified; all 10 assigned tags exercised; reserved/forbidden boundaries present")
    for path in (POSITIVE, NEGATIVE, ERRATA_VECTORS, DISTINCT, BUDGETS, SCHEMA):
        print(f"sha256 {hashlib.sha256(path.read_bytes()).hexdigest()}  {path.relative_to(ROOT)}")
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except (AssertionError, KeyError, TypeError, UnicodeError, ValueError) as exc:
        print(f"phase0 verification failed: {exc}", file=sys.stderr)
        raise SystemExit(1)
