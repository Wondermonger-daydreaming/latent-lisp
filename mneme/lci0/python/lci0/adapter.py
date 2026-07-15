"""Pure, total adapter from the frozen LCI fixture JSON surface to CD/0.

The fixture package deliberately does *not* use the frozen codec fixture AST.
This module is the only translation boundary.  It performs no registry lookup,
normalization, or semantic inference and rejects every shape outside the census.
"""

from __future__ import annotations

from dataclasses import dataclass
import math
from typing import Any

import cd0


@dataclass(frozen=True, slots=True)
class FixtureAdapterFailure(ValueError):
    code: str
    path: tuple[object, ...] = ()
    detail: str = ""

    def __str__(self) -> str:
        suffix = f": {self.detail}" if self.detail else ""
        return f"{self.code} at {self.path!r}{suffix}"


PACKAGE_SHAPES = frozenset({"unit", "bool", "int", "rat", "bytes", "string", "id", "seq", "record"})


def _fail(code: str, path: tuple[object, ...], detail: str = "") -> FixtureAdapterFailure:
    return FixtureAdapterFailure(code, path, detail)


def _exact_object(value: Any, fields: set[str], path: tuple[object, ...]) -> dict[str, Any]:
    if type(value) is not dict:
        raise _fail("UnknownFixtureShape", path, "expected an exact JSON object")
    supplied = set(value)
    if supplied != fields:
        raise _fail(
            "UnknownFixtureShape",
            path,
            f"expected={sorted(fields)!r} supplied={sorted(supplied)!r}",
        )
    return value


def _decimal(value: Any, path: tuple[object, ...]) -> int:
    if type(value) is not str or not value:
        raise _fail("InvalidFixtureInteger", path)
    negative = value.startswith("-")
    digits = value[1:] if negative else value
    if not digits or any(ch < "0" or ch > "9" for ch in digits):
        raise _fail("InvalidFixtureInteger", path)
    if (len(digits) > 1 and digits.startswith("0")) or value == "-0":
        raise _fail("InvalidFixtureInteger", path, "noncanonical decimal")
    return int(value)


def _hex(value: Any, path: tuple[object, ...]) -> bytes:
    if type(value) is not str or len(value) % 2:
        raise _fail("InvalidFixtureHex", path)
    if any(not ("0" <= ch <= "9" or "a" <= ch <= "f") for ch in value):
        raise _fail("InvalidFixtureHex", path, "only lowercase hexadecimal is accepted")
    return bytes.fromhex(value)


def _scalar_text(value: Any, path: tuple[object, ...], *, nonempty: bool = False) -> str:
    if type(value) is not str or (nonempty and not value):
        raise _fail("InvalidFixtureText", path)
    if any(0xD800 <= ord(ch) <= 0xDFFF for ch in value):
        raise _fail("InvalidFixtureText", path, "surrogate code point")
    return value


def to_cd0_fixture_ast(value: Any, path: tuple[object, ...] = ()) -> dict[str, Any]:
    """Translate one package abstract datum into the frozen codec fixture AST."""

    if type(value) is not dict or type(value.get("t")) is not str:
        raise _fail("UnknownFixtureShape", path)
    tag = value["t"]
    if tag not in PACKAGE_SHAPES:
        raise _fail("UnknownFixtureShape", path + ("t",), f"unknown tag {tag!r}")
    if tag == "unit":
        _exact_object(value, {"t"}, path)
        return {"t": "unit"}
    if tag == "bool":
        row = _exact_object(value, {"t", "v"}, path)
        if type(row["v"]) is not bool:
            raise _fail("BooleanIntegerCollapse", path + ("v",))
        return {"t": "bool", "v": row["v"]}
    if tag == "int":
        row = _exact_object(value, {"t", "v"}, path)
        _decimal(row["v"], path + ("v",))
        return {"t": "int", "v": row["v"]}
    if tag == "rat":
        row = _exact_object(value, {"t", "num", "den"}, path)
        numerator = _decimal(row["num"], path + ("num",))
        denominator = _decimal(row["den"], path + ("den",))
        if numerator == 0 or denominator <= 1 or math.gcd(abs(numerator), denominator) != 1:
            raise _fail("NoncanonicalFixtureRational", path)
        return {"t": "rat", "p": row["num"], "q": row["den"]}
    if tag == "bytes":
        row = _exact_object(value, {"t", "hex"}, path)
        _hex(row["hex"], path + ("hex",))
        return {"t": "bytes", "hex": row["hex"]}
    if tag == "string":
        row = _exact_object(value, {"t", "text", "utf8_hex"}, path)
        text = _scalar_text(row["text"], path + ("text",))
        encoded = _hex(row["utf8_hex"], path + ("utf8_hex",))
        if text.encode("utf-8") != encoded:
            raise _fail("RedundantStringFieldMismatch", path)
        return {"t": "string", "utf8_hex": row["utf8_hex"]}
    if tag == "id":
        row = _exact_object(value, {"t", "namespace", "path"}, path)
        if type(row["namespace"]) is not list or type(row["path"]) is not list or not row["path"]:
            raise _fail("InvalidFixtureIdentifier", path)
        namespace = [
            _scalar_text(item, path + ("namespace", index), nonempty=True)
            for index, item in enumerate(row["namespace"])
        ]
        id_path = [
            _scalar_text(item, path + ("path", index), nonempty=True)
            for index, item in enumerate(row["path"])
        ]
        return {
            "t": "id",
            "namespace_utf8_hex": [item.encode("utf-8").hex() for item in namespace],
            "path_utf8_hex": [item.encode("utf-8").hex() for item in id_path],
        }
    if tag == "seq":
        row = _exact_object(value, {"t", "items"}, path)
        if type(row["items"]) is not list:
            raise _fail("UnknownFixtureShape", path + ("items",))
        return {
            "t": "seq",
            "items": [to_cd0_fixture_ast(item, path + ("items", index)) for index, item in enumerate(row["items"])],
        }
    row = _exact_object(value, {"t", "fields"}, path)
    if type(row["fields"]) is not list:
        raise _fail("UnknownFixtureShape", path + ("fields",))
    fields: list[dict[str, Any]] = []
    for index, field in enumerate(row["fields"]):
        field_path = path + ("fields", index)
        pair = _exact_object(field, {"key", "value"}, field_path)
        key = to_cd0_fixture_ast(pair["key"], field_path + ("key",))
        if key["t"] != "id":
            raise _fail("RecordKeyNotIdentifier", field_path + ("key",))
        fields.append({"key": key, "value": to_cd0_fixture_ast(pair["value"], field_path + ("value",))})
    return {"t": "record", "fields": fields}


def from_package_json(value: Any, budget: cd0.ResourceBudget) -> cd0.Datum:
    """Adapt and import one package datum without consulting ambient state."""

    return cd0.from_fixture_ast(to_cd0_fixture_ast(value), budget)


def schema_census(value: Any) -> dict[str, int]:
    """Count every encountered package surface shape, rejecting unknown forms."""

    counts = {name: 0 for name in sorted(PACKAGE_SHAPES)}
    wrappers = 0
    stack: list[tuple[Any, tuple[object, ...]]] = [(value, ())]
    while stack:
        current, path = stack.pop()
        # Full conversion at each root is intentionally avoided; exact local
        # checks below mirror to_cd0_fixture_ast and make this a true census.
        if type(current) is not dict or type(current.get("t")) is not str:
            raise _fail("UnknownFixtureShape", path)
        tag = current["t"]
        if tag not in counts:
            raise _fail("UnknownFixtureShape", path + ("t",))
        counts[tag] += 1
        if tag == "seq":
            _exact_object(current, {"t", "items"}, path)
            if type(current["items"]) is not list:
                raise _fail("UnknownFixtureShape", path + ("items",))
            stack.extend((item, path + ("items", index)) for index, item in enumerate(current["items"]))
        elif tag == "record":
            _exact_object(current, {"t", "fields"}, path)
            if type(current["fields"]) is not list:
                raise _fail("UnknownFixtureShape", path + ("fields",))
            for index, field in enumerate(current["fields"]):
                wrappers += 1
                pair = _exact_object(field, {"key", "value"}, path + ("fields", index))
                stack.append((pair["key"], path + ("fields", index, "key")))
                stack.append((pair["value"], path + ("fields", index, "value")))
        else:
            # Invoke the authoritative local validator for leaf exactness.
            to_cd0_fixture_ast(current, path)
    counts["field-wrapper"] = wrappers
    return counts
