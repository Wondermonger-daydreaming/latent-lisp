"""Closed response-schema validation for every LCI/0 adapter JSON line."""

from __future__ import annotations

import json
from typing import Any, Mapping

import cd0

from lci0.core import CD0_BUDGET, canonical_bytes
from protocol import (
    COMMON_LISP_SEED_COMMIT,
    COMMON_LISP_SEED_TREE,
    FIXTURE_PROFILE_VERSION,
    PROTOCOL,
    PYTHON_SEED_COMMIT,
    PYTHON_SEED_TREE,
)


BASE_FIELDS = frozenset(
    {
        "protocol",
        "request_id",
        "operation",
        "fixture_profile_version",
        "implementation",
        "implementation_seed_commit",
        "implementation_seed_tree",
        "protocol_status",
        "input_reencoded_canonical_hex",
    }
)
IMPLEMENTATION_PINS = {
    "common-lisp": (COMMON_LISP_SEED_COMMIT, COMMON_LISP_SEED_TREE),
    "python": (PYTHON_SEED_COMMIT, PYTHON_SEED_TREE),
}
FAILURE_FIELDS = frozenset({"category", "code", "stage", "path"})
RESPONSE_SHAPES = frozenset(
    {
        "document",
        "relation",
        "hostile-validation",
        "fixture-operation",
        "fixture-authority-gap",
    }
)
LCI = ("lisp-plus", "lci", "0")
TAG = LCI + ("tag",)
FAILURE = LCI + ("failure",)
FIXTURE = LCI + ("fixture",)
FIXTURE_FIELD = FIXTURE + ("field",)
PROPOSITION_ARGUMENT = FIXTURE + ("mneme-proposition", "argument")
PROPOSITION_FIELD = FIXTURE + ("mneme-proposition", "field")
FAILURE_PATH_NAMESPACES = frozenset(
    {LCI, FIXTURE_FIELD, PROPOSITION_ARGUMENT, PROPOSITION_FIELD}
)
STANDARD_PATH_FIELDS = frozenset(
    {
        "kind", "schema-version", "lci-version", "identity-policy",
        "claim-profile", "proposition", "location", "scope", "subject-time",
        "basis", "interpretation-frame", "profile-location", "policy-id",
        "policy-version", "profile-id", "profile-version", "calculus",
        "expression", "mode", "parameters", "corpus", "revision", "slice",
        "semantic-boundary", "frame-schema", "components", "coordinates",
        "temporal-model", "domain", "scheme", "material", "issuer",
        "target-kind", "target-schema", "claim", "boundaries", "operation",
        "source", "lost-dimensions", "consequence", "account",
        "represented-loss", "digest",
    }
)
PROPOSITION_PATH_ARGUMENTS = frozenset(
    {
        "artifact", "content", "scope-locator", "subject-time-locator",
        "basis-locator", "frame-locator", "measure", "expected", "unit",
        "population-domain", "query", "corpus-locator",
        "dataset-slice-locator", "semantic-boundary-locator", "procedure",
        "input", "left", "right", "predicate", "quantified-domain",
        "embedded-proposition", "probability", "uncertainty-model", "producer",
        "invocation", "value", "source-text", "source-language",
        "target-language", "candidate-readings", "ambiguity-mode",
    }
)
PROPOSITION_CHILD_FIELDS = frozenset(
    {"kind", "schema-version", "placement", "value", "coordinate", "locator-role"}
)


class DuplicateJSONMember(ValueError):
    """Raised before schema validation when a JSON object repeats a key."""


def _closed_json_object(pairs: list[tuple[str, Any]]) -> dict[str, Any]:
    value: dict[str, Any] = {}
    for key, item in pairs:
        if key in value:
            raise DuplicateJSONMember(key)
        value[key] = item
    return value


def loads_closed_json(payload: str | bytes) -> Any:
    """Decode JSON while rejecting duplicate members at every nesting depth."""

    return json.loads(payload, object_pairs_hook=_closed_json_object)


def _path_identifier(part: str, previous: str | None) -> cd0.Identifier:
    if part.startswith("fixture-field:"):
        return cd0.identifier(FIXTURE_FIELD, (part[14:],))
    if previous == "arguments":
        return cd0.identifier(PROPOSITION_ARGUMENT, (part,))
    if previous in PROPOSITION_PATH_ARGUMENTS and part in PROPOSITION_CHILD_FIELDS:
        return cd0.identifier(PROPOSITION_FIELD, (part,))
    if part in STANDARD_PATH_FIELDS:
        return cd0.identifier(LCI, (part,))
    if part == "arguments":
        return cd0.identifier(PROPOSITION_FIELD, (part,))
    return cd0.identifier(FIXTURE_FIELD, (part,))


def failure_path_matches(
    items: tuple[cd0.Datum, ...], path: list[str]
) -> bool:
    if len(items) != len(path) or any(type(part) is not str for part in path):
        return False
    previous: str | None = None
    for item, part in zip(items, path):
        if item != _path_identifier(part, previous):
            return False
        previous = part
    return True


def canonical_failure_path(path: list[str] | tuple[str, ...]) -> list[str]:
    """Render a structural path without losing its Identifier namespace."""

    result: list[str] = []
    previous: str | None = None
    for part in path:
        identifier = _path_identifier(part, previous)
        result.append(
            f"fixture-field:{identifier.path[0]}"
            if identifier.namespace == FIXTURE_FIELD
            else identifier.path[0]
        )
        previous = part
    return result


def _lower_hex(value: object) -> bool:
    return (
        type(value) is str
        and bool(value)
        and len(value) % 2 == 0
        and value == value.lower()
        and all(character in "0123456789abcdef" for character in value)
    )


def _failure_closed(value: object) -> bool:
    return (
        type(value) is dict
        and set(value) == FAILURE_FIELDS
        and all(type(value[name]) is str and value[name] for name in ("category", "code", "stage"))
        and type(value["path"]) is list
        and all(type(part) is str for part in value["path"])
    )


def _closed_record_fields(
    value: cd0.Datum, namespace: tuple[str, ...]
) -> dict[str, cd0.Datum] | None:
    if type(value) is not cd0.Record:
        return None
    fields: dict[str, cd0.Datum] = {}
    for key, item in value.fields:
        if key.namespace != namespace or len(key.path) != 1 or key.path[0] in fields:
            return None
        fields[key.path[0]] = item
    return fields


def _identifier_is(
    value: cd0.Datum, namespace: tuple[str, ...], path: tuple[str, ...]
) -> bool:
    return (
        type(value) is cd0.Identifier
        and value.namespace == namespace
        and value.path == path
    )


def _decoded_failure_object(decoded: cd0.Datum) -> dict[str, Any] | None:
    fields = _closed_record_fields(decoded, LCI)
    if fields is None or set(fields) != {
        "kind", "schema-version", "category", "code", "stage", "path", "context"
    }:
        return None
    values: dict[str, str] = {}
    for name in ("category", "code", "stage"):
        value = fields[name]
        if type(value) is not cd0.Identifier or value.namespace != FAILURE or len(value.path) != 1:
            return None
        values[name] = value.path[0]
    if not (
        _identifier_is(fields["kind"], TAG, ("failure",))
        and type(fields["schema-version"]) is cd0.Integer
        and fields["schema-version"].value == 0
        and type(fields["path"]) is cd0.Sequence
        and type(fields["context"]) is cd0.Record
    ):
        return None
    path: list[str] = []
    for item in fields["path"].items:
        if (
            type(item) is not cd0.Identifier
            or item.namespace not in FAILURE_PATH_NAMESPACES
            or len(item.path) != 1
        ):
            return None
        path.append(
            f"fixture-field:{item.path[-1]}"
            if item.namespace == FIXTURE_FIELD
            else item.path[-1]
        )
    if not failure_path_matches(fields["path"].items, path):
        return None
    return {**values, "path": path}


def canonical_report_matches(response: Mapping[str, Any]) -> bool:
    """Bind JSON semantic status/failure to one canonical closed result document."""

    actual_hex = response.get("actual_canonical_cd0_hex")
    if not _lower_hex(actual_hex):
        return False
    try:
        decoded = cd0.decode_exact(bytes.fromhex(actual_hex), CD0_BUDGET)
    except (ValueError, cd0.CD0Failure):
        return False
    if canonical_bytes(decoded).hex() != actual_hex:
        return False
    failure = _decoded_failure_object(decoded)
    if response.get("semantic_status") == "failure":
        return failure is not None and response.get("failure") == failure
    if response.get("semantic_status") != "success" or failure is not None:
        return False
    fields = _closed_record_fields(decoded, FIXTURE_FIELD)
    return bool(
        fields is not None
        and set(fields) == {"kind", "schema-version", "status", "operation", "outputs"}
        and _identifier_is(fields["kind"], FIXTURE, ("tag", "fixture-operation-result"))
        and type(fields["schema-version"]) is cd0.Integer
        and fields["schema-version"].value == 0
        and _identifier_is(fields["status"], FIXTURE, ("result-status", "success"))
        and _identifier_is(
            fields["operation"],
            FIXTURE,
            ("operation", response.get("operation")),
        )
        and _closed_record_fields(fields["outputs"], FIXTURE_FIELD) is not None
    )


def validate_response(
    response: object,
    *,
    implementation: str,
    request_id: str,
    operation: str,
    shape: str,
    expected_vector_id: str | None = None,
    expected_authority_gap: str | None = None,
) -> tuple[bool, str | None]:
    """Validate an adapter response without accepting implementation-local fields."""

    if type(response) is not dict:
        return False, "response-is-not-object"
    if implementation not in IMPLEMENTATION_PINS:
        return False, "unknown-implementation-pin"
    if shape not in RESPONSE_SHAPES:
        return False, "unknown-response-shape"

    seed_commit, seed_tree = IMPLEMENTATION_PINS[implementation]
    base_values = {
        "protocol": PROTOCOL,
        "request_id": request_id,
        "operation": operation,
        "fixture_profile_version": FIXTURE_PROFILE_VERSION,
        "implementation": implementation,
        "implementation_seed_commit": seed_commit,
        "implementation_seed_tree": seed_tree,
    }
    for field, expected in base_values.items():
        if response.get(field) != expected:
            return False, f"wrong-{field}"
    if not _lower_hex(response.get("input_reencoded_canonical_hex")):
        return False, "invalid-input-reencoding"

    if shape == "fixture-authority-gap":
        expected_fields = BASE_FIELDS | {"status", "authority_gap"}
        if set(response) != expected_fields:
            return False, "authority-gap-field-set"
        if (
            response.get("protocol_status") != "fixture-authority-gap"
            or response.get("status") != "blocked"
            or response.get("authority_gap") != expected_authority_gap
        ):
            return False, "authority-gap-value"
        return True, None

    if response.get("protocol_status") != "success":
        return False, "non-success-protocol-status"
    semantic_status = response.get("semantic_status")
    if semantic_status not in {"success", "failure"}:
        return False, "invalid-semantic-status"
    failure_fields = {"failure"} if semantic_status == "failure" else set()
    if semantic_status == "failure" and not _failure_closed(response.get("failure")):
        return False, "invalid-failure-object"

    if shape == "document":
        expected_fields = BASE_FIELDS | {"semantic_status"}
        if set(response) != expected_fields or semantic_status != "success":
            return False, "document-response-shape"
    elif shape == "relation":
        expected_fields = BASE_FIELDS | {"semantic_status", "relation"} | failure_fields
        if set(response) != expected_fields or type(response.get("relation")) is not str:
            return False, "relation-response-shape"
    elif shape == "hostile-validation":
        expected_fields = BASE_FIELDS | {"semantic_status"} | failure_fields
        if set(response) != expected_fields:
            return False, "hostile-response-shape"
    else:
        expected_fields = (
            BASE_FIELDS
            | {"semantic_status", "vector_id", "actual_canonical_cd0_hex"}
            | failure_fields
        )
        if set(response) != expected_fields:
            return False, "fixture-operation-response-shape"
        if response.get("vector_id") != expected_vector_id:
            return False, "wrong-vector_id"
        if not _lower_hex(response.get("actual_canonical_cd0_hex")):
            return False, "invalid-actual-canonical-hex"
    return True, None
