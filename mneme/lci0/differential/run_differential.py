"""Oracle-neutral LCI/0 fixture-corpus differential coordinator.

The coordinator owns expected fixture results.  It sends adapters only a
closed operation name, canonical input, fixture/profile metadata, and pinned
budgets.  Every request, response, stderr stream, and comparison is retained.
"""

from __future__ import annotations

import argparse
from collections import Counter
import hashlib
import json
import os
from pathlib import Path
import platform
import subprocess
import sys
import time
from typing import Any, Iterable, Mapping

import cd0

from lci0.adapter import from_package_json
from lci0.core import CD0_BUDGET, canonical_bytes, field_by_path, replace_record_field
from lci0.package import definitions, iter_vectors, registry

from authorial_blockers import (
    BLOCKED_HOSTILE_AUTHORITY_GAP_REQUESTS,
    BLOCKED_HOSTILE_CROSS_DIFFERENCE_FIELDS,
    BLOCKED_HOSTILE_FAILURE_CANDIDATES,
    BLOCKED_HOSTILE_REQUESTS,
    BLOCKED_HOSTILE_SUCCESS_REQUESTS,
    BLOCKED_RELATION_PATH_REQUESTS,
    BLOCKED_VECTOR_REQUESTS,
    EXPECTED_SUCCESSOR_IMPLEMENTATION_COUNTS,
    EXPECTED_SUCCESSOR_REQUEST_COUNTS,
)
from protocol import (
    COMMON_LISP_SEED_COMMIT,
    COMMON_LISP_SEED_TREE,
    FIXTURE_PROFILE_VERSION,
    PROTOCOL,
    PYTHON_SEED_COMMIT,
    PYTHON_SEED_TREE,
    request,
)
from response_validation import (
    canonical_failure_path,
    canonical_report_matches,
    failure_path_matches,
    loads_closed_json,
    validate_response,
)


MAGIC_HEX = "4c50434400"
FIXTURE = ("lisp-plus", "lci", "0", "fixture")
FIXTURE_FIELD = FIXTURE + ("field",)
HOSTILE_NAMESPACE = FIXTURE + ("hostile",)
LCI = ("lisp-plus", "lci", "0")
TAG = LCI + ("tag",)
FAILURE = LCI + ("failure",)


class HarnessFailure(RuntimeError):
    pass


def _require(condition: bool, message: str) -> None:
    if not condition:
        raise HarnessFailure(message)


def _json_line(value: Any) -> str:
    return json.dumps(value, sort_keys=True, separators=(",", ":"), ensure_ascii=False) + "\n"


def _walk(value: Any, path: tuple[Any, ...] = ()):
    yield path, value
    if type(value) is dict:
        for key, child in value.items():
            yield from _walk(child, path + (key,))
    elif type(value) is list:
        for index, child in enumerate(value):
            yield from _walk(child, path + (index,))


def _verify_document_row(row: Mapping[str, Any], label: str) -> str:
    encoded_hex = row.get("canonical_cd0_hex")
    _require(
        type(encoded_hex) is str
        and encoded_hex.startswith(MAGIC_HEX)
        and encoded_hex == encoded_hex.lower()
        and len(encoded_hex) % 2 == 0,
        f"{label}: invalid canonical hex",
    )
    encoded = bytes.fromhex(encoded_hex)
    if "canonical_octets_byte_count" in row:
        _require(len(encoded) == row["canonical_octets_byte_count"], f"{label}: byte count mismatch")
    if "sha256_checksum_of_canonical_octets" in row:
        _require(
            hashlib.sha256(encoded).hexdigest() == row["sha256_checksum_of_canonical_octets"],
            f"{label}: canonical checksum mismatch",
        )
    abstract = from_package_json(row["abstract_cd0"], CD0_BUDGET)
    decoded = cd0.decode_exact(encoded, CD0_BUDGET)
    _require(decoded == abstract, f"{label}: abstract datum mismatch")
    if "expected_decoded_abstract_value" in row:
        expected = from_package_json(row["expected_decoded_abstract_value"], CD0_BUDGET)
        _require(decoded == expected, f"{label}: expected decoded datum mismatch")
    _require(canonical_bytes(decoded) == encoded, f"{label}: local re-encoding mismatch")
    return encoded_hex


def _replace_key_namespace(record: cd0.Datum, field_name: str, namespace: tuple[str, ...]) -> cd0.Record:
    _require(type(record) is cd0.Record, "key replacement requires a record")
    found = False
    fields: list[tuple[cd0.Identifier, cd0.Datum]] = []
    for key, value in record.fields:
        if key.path == (field_name,):
            _require(not found, f"duplicate field path {field_name}")
            fields.append((cd0.identifier(namespace, key.path), value))
            found = True
        else:
            fields.append((key, value))
    _require(found, f"field not found: {field_name}")
    return cd0.record(fields)


def _replace_identifier_namespace(
    record: cd0.Datum,
    field_name: str,
    namespace: tuple[str, ...],
) -> cd0.Record:
    value = field_by_path(record, field_name)
    _require(type(value) is cd0.Identifier, f"{field_name}: expected identifier")
    return replace_record_field(record, field_name, cd0.identifier(namespace, value.path))


def _replace_identifier_path(
    record: cd0.Datum,
    field_name: str,
    path: tuple[str, ...],
) -> cd0.Record:
    value = field_by_path(record, field_name)
    _require(type(value) is cd0.Identifier, f"{field_name}: expected identifier")
    return replace_record_field(record, field_name, cd0.identifier(value.namespace, path))


def _hostile_cases() -> list[dict[str, Any]]:
    cases: list[dict[str, Any]] = []

    stable = from_package_json(definitions()["stable-ref.artifact.file.alpha"]["abstract_cd0"], CD0_BUDGET)
    cases.append({"name": "stable-ref-domain-namespace", "operation": "hostile-validate-stable-ref", "datum": _replace_identifier_namespace(stable, "domain", HOSTILE_NAMESPACE)})
    cases.append({"name": "stable-ref-scheme-namespace", "operation": "hostile-validate-stable-ref", "datum": _replace_identifier_namespace(stable, "scheme", HOSTILE_NAMESPACE)})
    material = field_by_path(stable, "material")
    material_kind = _replace_identifier_namespace(material, "kind", HOSTILE_NAMESPACE)
    cases.append(
        {
            "name": "stable-ref-material-kind-namespace",
            "operation": "hostile-validate-stable-ref",
            "datum": replace_record_field(stable, "material", material_kind),
            "expected_failure": {
                "category": "reference-refusal",
                "code": "InvalidStableReference",
                "stage": "stable-reference",
                "path": ["material", "kind"],
            },
        }
    )
    object_id = field_by_path(material, "object-id")
    _require(type(object_id) is cd0.Identifier and len(object_id.path) >= 3, "artifact object id shape")
    wrong_object_id = (object_id.path[0], "procedure", *object_id.path[2:])
    wrong_material = _replace_identifier_path(material, "object-id", wrong_object_id)
    cases.append({"name": "stable-ref-object-id-prefix", "operation": "hostile-validate-stable-ref", "datum": replace_record_field(stable, "material", wrong_material)})

    # Exact mutable-alias witnesses required by Errata E7 and the implementation
    # authorization.  Registered segmented/case-sensitive object identifiers
    # remain valid; these display-like spellings never become stable identity.
    alias_paths = {
        "display-model": ("object", "artifact", "display-model"),
        "bare-filename": ("object", "artifact", "file.txt"),
        "mutable-url": ("object", "artifact", "https://mutable.invalid/x"),
        "latest-case-folded": ("object", "artifact", "LaTeSt"),
        "main-case-folded": ("object", "artifact", "MAIN"),
        "package-symbol-spelling": ("object", "artifact", "MNEME::FILE"),
    }
    for name, path in alias_paths.items():
        alias_material = _replace_identifier_path(material, "object-id", path)
        cases.append(
            {
                "name": f"stable-ref-alias-{name}",
                "operation": "hostile-validate-stable-ref",
                "datum": replace_record_field(stable, "material", alias_material),
                "expected_failure": {
                    "category": "reference-refusal",
                    "code": "UnresolvedAlias",
                    "stage": "stable-reference",
                    "path": ["material", "object-id"],
                },
            }
        )

    observed = from_package_json(definitions()["warrant-target.observed.file-alpha.exact"]["abstract_cd0"], CD0_BUDGET)
    executed = from_package_json(definitions()["warrant-target.executed.call-17"]["abstract_cd0"], CD0_BUDGET)
    cases.append({"name": "observed-with-executed-target-schema", "operation": "hostile-validate-warrant-target", "datum": replace_record_field(observed, "target-schema", field_by_path(executed, "target-schema"))})
    cases.append({"name": "executed-with-observed-target-schema", "operation": "hostile-validate-warrant-target", "datum": replace_record_field(executed, "target-schema", field_by_path(observed, "target-schema"))})

    boundaries = field_by_path(observed, "boundaries")
    coverage = field_by_path(boundaries, "coverage-scope")
    expression = field_by_path(coverage, "expression")
    future_expression = cd0.record((*expression.fields, (cd0.identifier(FIXTURE_FIELD, ("future-selector",)), cd0.unit())))
    future_coverage = replace_record_field(coverage, "expression", future_expression)
    future_boundaries = replace_record_field(boundaries, "coverage-scope", future_coverage)
    cases.append({"name": "target-nested-coverage-future-selector", "operation": "hostile-validate-warrant-target", "datum": replace_record_field(observed, "boundaries", future_boundaries)})

    claim = from_package_json(definitions()["claim-id.file-alpha-neutral"]["abstract_cd0"], CD0_BUDGET)
    cases.append({"name": "claim-outer-kind-key-namespace", "operation": "hostile-validate-claim-id", "datum": _replace_key_namespace(claim, "kind", HOSTILE_NAMESPACE)})
    location = field_by_path(claim, "location")
    scope = field_by_path(location, "scope")
    expression = field_by_path(scope, "expression")
    hostile_expression = _replace_key_namespace(expression, "kind", HOSTILE_NAMESPACE)
    hostile_scope = replace_record_field(scope, "expression", hostile_expression)
    hostile_location = replace_record_field(location, "scope", hostile_scope)
    cases.append({"name": "claim-nested-expression-kind-key-namespace", "operation": "hostile-validate-claim-id", "datum": replace_record_field(claim, "location", hostile_location)})

    # Resource-boundary witnesses.  The 5,000-octet material segment is within
    # CD/0's frozen decoder budget but exceeds the fixture StableRef material
    # budget.  The second witness moves RESOURCE-01 from 65 to the inclusive
    # limit 64 without inventing a success-result envelope.
    long_object_id = cd0.identifier(FIXTURE, ("object", "artifact", "x" * 5000))
    long_material = replace_record_field(material, "object-id", long_object_id)
    cases.append(
        {
            "name": "resource-stable-ref-material-5000",
            "operation": "hostile-validate-stable-ref",
            "datum": replace_record_field(stable, "material", long_material),
            "expected_failure": {
                "category": "resource-refusal",
                "code": "StableReferenceMaterialBudgetExceeded",
                "stage": "validation",
                "path": ["material"],
            },
        }
    )

    vector_rows = {row["vector_id"]: row for row in iter_vectors()}
    resource_envelope = from_package_json(vector_rows["LCI0-RESOURCE-01"]["inputs"]["abstract_cd0"], CD0_BUDGET)
    resource_payload = field_by_path(resource_envelope, "payload")
    workload = field_by_path(resource_payload, "workload")
    _require(field_by_path(workload, "requested") == cd0.integer(65), "RESOURCE-01 requested value drift")
    within_workload = replace_record_field(workload, "requested", cd0.integer(64))
    within_payload = replace_record_field(resource_payload, "workload", within_workload)
    cases.append(
        {
            "name": "resource-maximum-nesting-at-limit-64",
            "operation": "conformance-validation",
            "datum": replace_record_field(resource_envelope, "payload", within_payload),
            "expected_semantic_status": "success",
        }
    )

    # Bounded non-evaluating migration grammar witnesses.
    migration_envelope = from_package_json(vector_rows["LCI0-N027"]["inputs"]["abstract_cd0"], CD0_BUDGET)
    migration_payload = field_by_path(migration_envelope, "payload")
    legacy = from_package_json(definitions()["legacy-source.time-100"]["abstract_cd0"], CD0_BUDGET)
    grammar_substitution = replace_record_field(legacy, "grammar", stable)
    unknown_legacy = cd0.record((*legacy.fields, (cd0.identifier(FIXTURE_FIELD, ("future-grammar-option",)), cd0.boolean(False))))
    forbidden_bytes = replace_record_field(legacy, "source-bytes", cd0.byte_string(b"#."))
    for name, source, expected_failure in (
        (
            "migration-grammar-reference-substitution",
            grammar_substitution,
            {"category": "migration-refusal", "code": "UnsupportedLegacyForm", "stage": "migration-source", "path": ["grammar"]},
        ),
        (
            "migration-unknown-top-level-field",
            unknown_legacy,
            {"category": "invalid-input", "code": "UnknownField", "stage": "migration-source", "path": ["future-grammar-option"]},
        ),
        (
            "migration-forbidden-reader-bytes",
            forbidden_bytes,
            {"category": "migration-refusal", "code": "UnsupportedLegacyForm", "stage": "migration-source", "path": ["source-bytes"]},
        ),
    ):
        payload = replace_record_field(migration_payload, "legacy-record", source)
        cases.append(
            {
                "name": name,
                "operation": "migrate-v1",
                "datum": replace_record_field(migration_envelope, "payload", payload),
                "expected_failure": expected_failure,
            }
        )

    policy_carrier = cd0.record(
        (
            (cd0.identifier(FIXTURE_FIELD, ("policy",)), cd0.identifier(FIXTURE, ("policy-name", "policy-c"))),
            (
                cd0.identifier(FIXTURE_FIELD, ("target-relation",)),
                cd0.record(
                    (
                        (cd0.identifier(FIXTURE_FIELD, ("kind",)), cd0.identifier(FIXTURE, ("tag", "target-relation-result"))),
                        (cd0.identifier(FIXTURE_FIELD, ("schema-version",)), cd0.integer(0)),
                        (cd0.identifier(FIXTURE_FIELD, ("status",)), cd0.identifier(FIXTURE, ("result-status", "success"))),
                        (cd0.identifier(FIXTURE_FIELD, ("relation",)), cd0.identifier(("lisp-plus", "lci", "0", "relation"), ("exact-target",))),
                    )
                ),
            ),
        )
    )
    cases.append(
        {
            "name": "policy-c-fail-closed",
            "operation": "hostile-evaluate-policy-c",
            "datum": policy_carrier,
            "expected_authority_gap": "unsupported fixture policy",
        }
    )

    result = []
    for case in cases:
        datum = case.pop("datum")
        encoded = canonical_bytes(datum)
        expected_status = case.pop("expected_semantic_status", "failure")
        if "expected_failure" in case:
            case["expected_failure"] = {
                **case["expected_failure"],
                "path": canonical_failure_path(
                    case["expected_failure"].get("path", [])
                ),
            }
        if "expected_authority_gap" in case:
            response_shape = "fixture-authority-gap"
            expected_vector_id = None
        elif case["operation"].startswith("hostile-"):
            response_shape = "hostile-validation"
            expected_vector_id = None
        else:
            response_shape = "fixture-operation"
            vector_id = field_by_path(datum, "vector-id")
            _require(type(vector_id) is cd0.String, "hostile vector-id is not a string")
            expected_vector_id = vector_id.value
        result.append(
            {
                **case,
                "canonical_hex": encoded.hex(),
                "canonical_octets": len(encoded),
                "canonical_sha256": hashlib.sha256(encoded).hexdigest(),
                "expected_semantic_status": expected_status,
                "response_shape": response_shape,
                "expected_vector_id": expected_vector_id,
            }
        )
    return result


def _relation_failure_expectation(
    *, code: str, stage: str, allowed_paths: tuple[tuple[str, ...], ...]
) -> dict[str, Any]:
    return {
        "expected_semantic_status": "failure",
        "expected_failure": {
            "category": "relation-undetermined",
            "code": code,
            "stage": stage,
        },
        "allowed_failure_paths": [list(path) for path in allowed_paths],
    }


def _relation_expectation(
    *,
    request_id: str,
    table_name: str,
    relation: str,
    left_fixture: str,
    right_fixture: str,
) -> dict[str, Any]:
    """Return the frozen companion status/tuple for a pinned relation row.

    The registry pins the relation token.  The LCI calculus and Errata E6 pin
    whether that token is returned normally or as a typed F-valued failure.
    Thirty-eight fixture rows leave only the structural path underdetermined;
    those rows admit the two witnessed paths and nothing else.
    """

    if table_name == "scope_relation_table_0":
        if relation == "unknown":
            return _relation_failure_expectation(
                code="ScopeRelationUnknown",
                stage="target-relation",
                allowed_paths=(("fixture-field:right",),),
            )
        if relation == "incompatible":
            _require(
                request_id in BLOCKED_RELATION_PATH_REQUESTS,
                "unclassified scope incompatibility path",
            )
            return _relation_failure_expectation(
                code="ScopeIncompatible",
                stage="target-relation",
                allowed_paths=(
                    ("fixture-field:right",),
                    ("fixture-field:right", "calculus"),
                ),
            )
    elif table_name == "temporal_relation_table_0":
        if relation == "unknown":
            paths = (
                (("fixture-field:left",), ("fixture-field:right",))
                if request_id in BLOCKED_RELATION_PATH_REQUESTS
                else (("fixture-field:left",),)
            )
            return _relation_failure_expectation(
                code="AdmissibilityUndetermined",
                stage="subject-time",
                allowed_paths=paths,
            )
        if relation == "incompatible" and "subject-time.second.alpha" in {
            left_fixture,
            right_fixture,
        }:
            return _relation_failure_expectation(
                code="UnsupportedTemporalModel",
                stage="subject-time",
                allowed_paths=(("fixture-field:right", "temporal-model"),),
            )
    else:
        raise HarnessFailure(f"unknown relation table: {table_name}")

    _require(
        request_id not in BLOCKED_RELATION_PATH_REQUESTS,
        "blocked relation path unexpectedly classified as success",
    )
    return {
        "expected_semantic_status": "success",
        "expected_failure": None,
        "allowed_failure_paths": [],
    }


def _relation_response_matches(
    response: Mapping[str, Any], oracle: Mapping[str, Any]
) -> bool:
    expected_status = oracle.get("expected_semantic_status")
    if response.get("semantic_status") != expected_status:
        return False
    expected_failure = oracle.get("expected_failure")
    if expected_status == "success":
        return expected_failure is None and "failure" not in response
    observed = response.get("failure")
    if type(observed) is not dict or type(expected_failure) is not dict:
        return False
    return bool(
        {name: observed.get(name) for name in ("category", "code", "stage")}
        == expected_failure
        and observed.get("path") in oracle.get("allowed_failure_paths", [])
    )


def build_requests() -> tuple[list[dict[str, Any]], dict[str, dict[str, Any]], dict[str, Any]]:
    package_registry = registry()
    vectors = list(iter_vectors())
    _require(len(vectors) == 215, "vector count is not 215")
    vector_ids = [row["vector_id"] for row in vectors]
    _require(len(set(vector_ids)) == 215, "vector IDs are not unique")
    required_ids = {*(f"LCI0-P{i:03d}" for i in range(1, 31)), *(f"LCI0-N{i:03d}" for i in range(1, 33))}
    _require(required_ids <= set(vector_ids), "required P/N vectors are missing")

    requests: list[dict[str, Any]] = []
    oracles: dict[str, dict[str, Any]] = {}
    document_count = 0

    def add(request_id: str, operation: str, input_hex: str, oracle: dict[str, Any]) -> None:
        _require(request_id not in oracles, f"duplicate request id: {request_id}")
        requests.append(request(request_id, operation, input_hex))
        _require("expected_input_hex" not in oracle, "oracle input identity collision")
        _require("request_operation" not in oracle, "oracle operation identity collision")
        oracles[request_id] = {
            **oracle,
            "expected_input_hex": input_hex,
            "request_operation": operation,
        }

    definition_rows = list(package_registry["definitions"])
    _require(len(definition_rows) == 675, "definition count is not 675")
    for row in definition_rows:
        label = f"definition:{row['fixture_id']}"
        encoded_hex = _verify_document_row(row, label)
        add(f"doc:{label}", "document-roundtrip", encoded_hex, {"kind": "document", "expected_hex": encoded_hex, "class": "official-definition"})
        document_count += 1

    operation_counts = Counter()
    for row in vectors:
        vector_id = row["vector_id"]
        input_hex = _verify_document_row(row["inputs"], f"vector-input:{vector_id}")
        expected_hex = _verify_document_row(row["expected"], f"vector-expected:{vector_id}")
        add(f"doc:vector-input:{vector_id}", "document-roundtrip", input_hex, {"kind": "document", "expected_hex": input_hex, "class": "official-vector-input"})
        add(f"doc:vector-expected:{vector_id}", "document-roundtrip", expected_hex, {"kind": "document", "expected_hex": expected_hex, "class": "official-vector-expected"})
        add(f"vector:{vector_id}", row["operation"], input_hex, {"kind": "vector", "vector_id": vector_id, "expected_hex": expected_hex, "operation": row["operation"]})
        operation_counts[row["operation"]] += 1
        document_count += 2
    _require(document_count == 1105, "official document count is not 1,105")
    _require(len(operation_counts) == 52 and sum(operation_counts.values()) == 215, "vector operation census mismatch")

    relation_document_count = 0
    relation_semantic_count = 0
    tables = package_registry["relation_and_mapping_tables"]
    for table_name, operation in (
        ("scope_relation_table_0", "scope-relation-table"),
        ("temporal_relation_table_0", "temporal-relation-table"),
    ):
        for index, row in enumerate(tables[table_name]["entries"]):
            label = f"{table_name}:{index:03d}:{row['left_fixture']}:{row['right_fixture']}"
            request_id = f"relation:{label}"
            encoded_hex = _verify_document_row(row, label)
            add(f"doc:relation:{label}", "document-roundtrip", encoded_hex, {"kind": "document", "expected_hex": encoded_hex, "class": "supplementary-relation-table"})
            add(
                request_id,
                operation,
                encoded_hex,
                {
                    "kind": "relation",
                    "expected_relation": row["relation"],
                    "table": table_name,
                    "left_fixture": row["left_fixture"],
                    "right_fixture": row["right_fixture"],
                    **_relation_expectation(
                        request_id=request_id,
                        table_name=table_name,
                        relation=row["relation"],
                        left_fixture=row["left_fixture"],
                        right_fixture=row["right_fixture"],
                    ),
                },
            )
            relation_document_count += 1
            relation_semantic_count += 1
    _require(relation_document_count == relation_semantic_count == 458, "relation table count mismatch")

    nested_count = 0
    for row in vectors:
        vector_id = row["vector_id"]
        nested = [
            (path, value)
            for path, value in _walk(row)
            if path and path[-1] == "hex" and type(value) is str and value.startswith(MAGIC_HEX)
        ]
        if vector_id.startswith("LCI0-E1-"):
            _require(len(nested) == 3, f"{vector_id}: nested E1 triple missing")
            _require(len({value for _, value in nested}) == 1, f"{vector_id}: nested E1 triple differs")
            for occurrence, (path, encoded_hex) in enumerate(nested):
                decoded = cd0.decode_exact(bytes.fromhex(encoded_hex), CD0_BUDGET)
                _require(canonical_bytes(decoded).hex() == encoded_hex, f"{vector_id}: nested E1 noncanonical")
                add(f"doc:nested-e1:{vector_id}:{occurrence}:{'.'.join(map(str, path))}", "document-roundtrip", encoded_hex, {"kind": "document", "expected_hex": encoded_hex, "class": "supplementary-nested-e1"})
                nested_count += 1
        else:
            _require(not nested, f"{vector_id}: unclassified nested canonical document")
    _require(nested_count == 30, "nested E1 count is not 30")

    registry_magic = [(path, value) for path, value in _walk(package_registry) if type(value) is str and value.startswith(MAGIC_HEX)]
    vector_magic = [(path, value) for index, row in enumerate(vectors) for path, value in _walk(row, (index,)) if type(value) is str and value.startswith(MAGIC_HEX)]
    registry_named = [item for item in registry_magic if item[0] and item[0][-1] == "canonical_cd0_hex"]
    vector_named = [item for item in vector_magic if item[0] and item[0][-1] in {"canonical_cd0_hex", "hex"}]
    _require(len(registry_magic) == len(registry_named) == 1133, "registry magic census mismatch")
    _require(len(vector_magic) == len(vector_named) == 460, "vector magic census mismatch")

    hostile = _hostile_cases()
    for row in hostile:
        add(f"hostile:{row['name']}", row["operation"], row["canonical_hex"], {"kind": "hostile", **row})

    counts = {
        "official_documents": 1105,
        "supplementary_relation_documents": relation_document_count,
        "supplementary_nested_e1_documents": nested_count,
        "supplementary_documents": relation_document_count + nested_count,
        "total_documents": document_count + relation_document_count + nested_count,
        "vector_semantic_requests": 215,
        "relation_semantic_requests": relation_semantic_count,
        "baseline_requests_per_implementation": document_count + relation_document_count + nested_count + 215 + relation_semantic_count,
        "hostile_requests_per_implementation": len(hostile),
        "total_requests_per_implementation": len(requests),
        "vector_operation_families": dict(sorted(operation_counts.items())),
        "magic_registry_values": len(registry_magic),
        "magic_vector_values": len(vector_magic),
    }
    _require(counts["total_documents"] == 1593, "total document count is not 1,593")
    _require(counts["supplementary_documents"] == 488, "supplementary count is not 488")
    _require(counts["baseline_requests_per_implementation"] == 2266, "baseline request count is not 2,266")
    for name, expected in EXPECTED_SUCCESSOR_REQUEST_COUNTS.items():
        _require(counts[name] == expected, f"successor request count drift: {name}")
    _require(len(operation_counts) == 52, "fixture operation family count is not 52")
    _require(sum(operation_counts.values()) == 215, "fixture operation request count is not 215")
    return requests, oracles, counts


def _run_adapter(
    name: str,
    command: list[str],
    environment: Mapping[str, str],
    requests: list[dict[str, Any]],
    output_directory: Path,
) -> tuple[dict[str, dict[str, Any]], dict[str, Any]]:
    request_path = output_directory / "requests.jsonl"
    if not request_path.exists():
        request_path.write_text("".join(_json_line(item) for item in requests), encoding="utf-8")
    request_bytes = request_path.read_bytes()
    started_ns = time.monotonic_ns()
    process = subprocess.run(command, input=request_bytes, capture_output=True, env=dict(environment))
    elapsed_ns = time.monotonic_ns() - started_ns
    response_path = output_directory / f"{name}-responses.jsonl"
    stderr_path = output_directory / f"{name}-stderr.txt"
    response_path.write_bytes(process.stdout)
    stderr_path.write_bytes(process.stderr)
    _require(process.returncode == 0, f"{name} adapter exited {process.returncode}")
    responses: dict[str, dict[str, Any]] = {}
    for line_number, line in enumerate(process.stdout.decode("utf-8").splitlines(), 1):
        try:
            response = loads_closed_json(line)
        except (json.JSONDecodeError, ValueError) as exc:
            raise HarnessFailure(f"{name} response line {line_number}: invalid JSON") from exc
        request_id = response.get("request_id")
        _require(type(request_id) is str and request_id, f"{name} response line {line_number}: missing request id")
        _require(request_id not in responses, f"{name}: duplicate response {request_id}")
        responses[request_id] = response
    expected_ids = {item["request_id"] for item in requests}
    _require(set(responses) == expected_ids, f"{name}: response request-id set mismatch")
    metadata = {
        "command": command,
        "exit_code": process.returncode,
        "requests": len(requests),
        "responses": len(responses),
        "request_bytes": len(request_bytes),
        "request_sha256": hashlib.sha256(request_bytes).hexdigest(),
        "response_bytes": len(process.stdout),
        "response_sha256": hashlib.sha256(process.stdout).hexdigest(),
        "stderr_bytes": len(process.stderr),
        "stderr_sha256": hashlib.sha256(process.stderr).hexdigest(),
        "elapsed_monotonic_ns": elapsed_ns,
    }
    return responses, metadata


def _compare(
    oracles: Mapping[str, dict[str, Any]],
    common_lisp: Mapping[str, dict[str, Any]],
    python: Mapping[str, dict[str, Any]],
) -> dict[str, Any]:
    implementation_rows = {"common-lisp": common_lisp, "python": python}
    summary: dict[str, Any] = {
        "implementations": {},
        "cross_implementation_mismatches": [],
        "hostile_results": [],
    }
    for name, responses in implementation_rows.items():
        counts = Counter()
        mismatches: list[dict[str, Any]] = []
        for request_id, oracle in oracles.items():
            response = responses[request_id]
            kind = oracle["kind"]
            counts[f"{kind}_requests"] += 1
            shape = (
                oracle["response_shape"]
                if kind == "hostile"
                else "fixture-operation"
                if kind == "vector"
                else kind
            )
            expected_vector_id = (
                oracle["vector_id"]
                if kind == "vector"
                else oracle.get("expected_vector_id")
            )
            schema_valid, schema_reason = validate_response(
                response,
                implementation=name,
                request_id=request_id,
                operation=oracle["request_operation"],
                shape=shape,
                expected_vector_id=expected_vector_id,
                expected_authority_gap=oracle.get("expected_authority_gap"),
            )
            if not schema_valid:
                counts["response_schema_failures"] += 1
                mismatches.append(
                    {
                        "request_id": request_id,
                        "kind": kind,
                        "reason": schema_reason,
                        "response": response,
                    }
                )
                continue
            input_passed = (
                response.get("input_reencoded_canonical_hex")
                == oracle["expected_input_hex"]
            )
            vector_metadata_passed = (
                kind != "vector"
                or (
                    response.get("vector_id") == oracle["vector_id"]
                    and response.get("operation") == oracle["operation"]
                    and response.get("fixture_profile_version")
                    == FIXTURE_PROFILE_VERSION
                )
            )
            if kind == "hostile" and request_id in BLOCKED_HOSTILE_REQUESTS:
                if input_passed and _valid_blocked_hostile_response(
                    request_id, response, oracle
                ):
                    counts["hostile_blocked"] += 1
                    mismatches.append(
                        {
                            "request_id": request_id,
                            "kind": "hostile",
                            "disposition": "authorial-blocked",
                            "bounded_expectation": _blocked_hostile_expectation(
                                request_id, oracle
                            ),
                            "response": response,
                        }
                    )
                else:
                    counts["hostile_failed"] += 1
                    mismatches.append(
                        {
                            "request_id": request_id,
                            "kind": "hostile",
                            "reason": "blocked-hostile-response-outside-bounds",
                            "response": response,
                        }
                    )
                continue
            if response.get("protocol_status") != "success":
                counts["protocol_failures"] += 1
                mismatches.append({"request_id": request_id, "kind": kind, "reason": "protocol-failure", "response": response})
                continue
            if kind == "document":
                passed = input_passed and oracle["expected_input_hex"] == oracle["expected_hex"]
            elif kind == "vector":
                passed = (
                    input_passed
                    and vector_metadata_passed
                    and response.get("actual_canonical_cd0_hex")
                    == oracle["expected_hex"]
                    and canonical_report_matches(response)
                )
            elif kind == "relation":
                passed = (
                    input_passed
                    and response.get("relation") == oracle["expected_relation"]
                    and _relation_response_matches(response, oracle)
                )
            else:
                passed = input_passed and response.get("semantic_status") == oracle["expected_semantic_status"]
                expected_failure = oracle.get("expected_failure")
                if passed and expected_failure is not None:
                    passed = response.get("failure") == expected_failure
                if passed and shape == "fixture-operation":
                    passed = canonical_report_matches(response)
            relation_path_blocked = bool(
                passed
                and kind == "relation"
                and request_id in BLOCKED_RELATION_PATH_REQUESTS
            )
            if relation_path_blocked:
                passed = False
            blocked = relation_path_blocked or (
                not passed
                and input_passed
                and vector_metadata_passed
                and kind == "vector"
                and request_id in BLOCKED_VECTOR_REQUESTS
                and _valid_authorial_blocked_response(request_id, response, oracle)
            )
            disposition = "blocked" if blocked else "passed" if passed else "failed"
            counts[f"{kind}_{disposition}"] += 1
            if not passed:
                mismatch = {"request_id": request_id, "kind": kind, "response": response}
                if blocked:
                    mismatch["disposition"] = "authorial-blocked"
                for field in (
                    "vector_id", "operation", "expected_relation", "table",
                    "left_fixture", "right_fixture", "canonical_sha256",
                    "canonical_octets", "expected_semantic_status",
                    "expected_failure", "allowed_failure_paths",
                ):
                    if field in oracle:
                        mismatch[field] = oracle[field]
                mismatch["expected_input_canonical_sha256"] = hashlib.sha256(
                    bytes.fromhex(oracle["expected_input_hex"])
                ).hexdigest()
                actual_input = response.get("input_reencoded_canonical_hex")
                mismatch["actual_input_canonical_sha256"] = (
                    hashlib.sha256(bytes.fromhex(actual_input)).hexdigest()
                    if type(actual_input) is str
                    else None
                )
                if kind == "vector":
                    mismatch["expected_canonical_sha256"] = hashlib.sha256(bytes.fromhex(oracle["expected_hex"])).hexdigest()
                    actual = response.get("actual_canonical_cd0_hex")
                    mismatch["actual_canonical_sha256"] = hashlib.sha256(bytes.fromhex(actual)).hexdigest() if type(actual) is str else None
                mismatches.append(mismatch)
        summary["implementations"][name] = {"counts": dict(sorted(counts.items())), "mismatches": mismatches}

    for request_id, oracle in oracles.items():
        left, right = common_lisp[request_id], python[request_id]
        kind = oracle["kind"]
        fields = (
            ("protocol", "operation", "fixture_profile_version", "protocol_status", "input_reencoded_canonical_hex")
            if kind == "document"
            else ("protocol", "operation", "fixture_profile_version", "protocol_status", "input_reencoded_canonical_hex", "vector_id", "actual_canonical_cd0_hex", "semantic_status", "failure")
            if kind == "vector"
            else ("protocol", "operation", "fixture_profile_version", "protocol_status", "input_reencoded_canonical_hex", "relation", "semantic_status", "failure")
            if kind == "relation"
            else ("protocol", "operation", "fixture_profile_version", "protocol_status", "input_reencoded_canonical_hex", "status", "authority_gap", "vector_id", "actual_canonical_cd0_hex", "semantic_status", "failure")
        )
        differences = {field: {"common-lisp": left.get(field), "python": right.get(field)} for field in fields if left.get(field) != right.get(field)}
        if differences:
            summary["cross_implementation_mismatches"].append({"request_id": request_id, "kind": kind, "differences": differences})
        if kind == "hostile":
            summary["hostile_results"].append(
                {
                    "request_id": request_id,
                    "canonical_octets": oracle["canonical_octets"],
                    "canonical_sha256": oracle["canonical_sha256"],
                    "expected_semantic_status": oracle["expected_semantic_status"],
                    "expected_failure": oracle.get("expected_failure"),
                    "expected_authority_gap": oracle.get("expected_authority_gap"),
                    "common_lisp": {"protocol_status": left.get("protocol_status"), "status": left.get("status"), "authority_gap": left.get("authority_gap"), "semantic_status": left.get("semantic_status"), "failure": left.get("failure")},
                    "python": {"protocol_status": right.get("protocol_status"), "status": right.get("status"), "authority_gap": right.get("authority_gap"), "semantic_status": right.get("semantic_status"), "failure": right.get("failure")},
                }
            )
    return summary


_BLOCKED_VECTOR_FAILURE_SHAPES = {
    "vector:LCI0-N012": {
        "category": "target-mismatch",
        "code": "ScopeNarrowingNotDeclared",
        "stage": "target-relation",
        "path": ["claim", "location", "scope"],
    },
    "vector:LCI0-E5-COVERAGE-INSUFFICIENT": {
        "category": "target-mismatch",
        "code": "ScopeNarrowingCoverageInsufficient",
        "stage": "target-relation",
        "path": ["boundaries", "fixture-field:coverage-scope"],
    },
}

_BLOCKED_VECTOR_SUCCESS_SHAPES = {
    "vector:LCI0-P024": {
        "operation": "revive-inert-occurrence",
        "vector_id": "LCI0-P024",
    },
    "vector:LCI0-P029": {
        "operation": "migrate-v1-collision-pair",
        "vector_id": "LCI0-P029",
    },
}


def _valid_authority_gap_response(
    response: Mapping[str, Any], oracle: Mapping[str, Any]
) -> bool:
    return (
        response.get("protocol_status") == "fixture-authority-gap"
        and response.get("status") == "blocked"
        and response.get("authority_gap") == oracle.get("expected_authority_gap")
        and "failure" not in response
        and "semantic_status" not in response
        and "actual_canonical_cd0_hex" not in response
    )


def _blocked_hostile_expectation(
    request_id: str, oracle: Mapping[str, Any]
) -> dict[str, Any]:
    if request_id in BLOCKED_HOSTILE_AUTHORITY_GAP_REQUESTS:
        return {
            "kind": "fixture-authority-gap",
            "authority_gap": oracle.get("expected_authority_gap"),
        }
    if request_id in BLOCKED_HOSTILE_FAILURE_CANDIDATES:
        return {
            "kind": "bounded-failure-candidates",
            "semantic_status": "failure",
            "failure_candidates": list(
                BLOCKED_HOSTILE_FAILURE_CANDIDATES[request_id]
            ),
        }
    if request_id in BLOCKED_HOSTILE_SUCCESS_REQUESTS:
        return {
            "kind": "bounded-success",
            "semantic_status": "success",
            "required_output": {"within-budget": True},
        }
    raise HarnessFailure(f"unknown hostile blocker: {request_id}")


def _valid_blocked_hostile_response(
    request_id: str,
    response: Mapping[str, Any],
    oracle: Mapping[str, Any],
) -> bool:
    """Validate only the frozen subset of one authorially blocked result."""

    if request_id in BLOCKED_HOSTILE_AUTHORITY_GAP_REQUESTS:
        return _valid_authority_gap_response(response, oracle)
    if request_id in BLOCKED_HOSTILE_FAILURE_CANDIDATES:
        if not (
            response.get("protocol_status") == "success"
            and response.get("semantic_status") == "failure"
            and response.get("failure")
            in BLOCKED_HOSTILE_FAILURE_CANDIDATES[request_id]
        ):
            return False
        return (
            canonical_report_matches(response)
            if "actual_canonical_cd0_hex" in response
            else True
        )
    if request_id in BLOCKED_HOSTILE_SUCCESS_REQUESTS:
        if not (
            response.get("protocol_status") == "success"
            and response.get("semantic_status") == "success"
            and canonical_report_matches(response)
        ):
            return False
        try:
            decoded = cd0.decode_exact(
                bytes.fromhex(response["actual_canonical_cd0_hex"]), CD0_BUDGET
            )
        except (KeyError, TypeError, ValueError, cd0.CD0Failure):
            return False
        fields = _closed_record_fields(decoded, FIXTURE_FIELD)
        outputs = (
            _closed_record_fields(fields["outputs"], FIXTURE_FIELD)
            if fields is not None and "outputs" in fields
            else None
        )
        within_budget = (
            outputs.get("within-budget") if outputs is not None else None
        )
        return type(within_budget) is cd0.Boolean and within_budget.value is True
    return False


def _closed_record_fields(
    value: cd0.Datum, namespace: tuple[str, ...]
) -> dict[str, cd0.Datum] | None:
    if type(value) is not cd0.Record:
        return None
    result: dict[str, cd0.Datum] = {}
    for key, item in value.fields:
        if key.namespace != namespace or len(key.path) != 1 or key.path[0] in result:
            return None
        result[key.path[0]] = item
    return result


def _identifier_is(
    value: cd0.Datum, namespace: tuple[str, ...], path: tuple[str, ...]
) -> bool:
    return (
        type(value) is cd0.Identifier
        and value.namespace == namespace
        and value.path == path
    )


def _decoded_failure_matches(
    decoded: cd0.Datum, expected: Mapping[str, Any]
) -> bool:
    fields = _closed_record_fields(decoded, LCI)
    if fields is None or set(fields) != {
        "kind", "schema-version", "category", "code", "stage", "path", "context"
    }:
        return False
    if not (
        _identifier_is(fields["kind"], TAG, ("failure",))
        and type(fields["schema-version"]) is cd0.Integer
        and fields["schema-version"].value == 0
        and _identifier_is(fields["category"], FAILURE, (expected["category"],))
        and _identifier_is(fields["code"], FAILURE, (expected["code"],))
        and _identifier_is(fields["stage"], FAILURE, (expected["stage"],))
        and type(fields["path"]) is cd0.Sequence
        and type(fields["context"]) is cd0.Record
    ):
        return False
    observed_path: list[str] = []
    for item in fields["path"].items:
        if (
            type(item) is not cd0.Identifier
            or item.namespace not in {
                LCI,
                FIXTURE_FIELD,
                FIXTURE + ("mneme-proposition", "argument"),
                FIXTURE + ("mneme-proposition", "field"),
            }
            or len(item.path) != 1
        ):
            return False
        observed_path.append(
            f"fixture-field:{item.path[-1]}"
            if item.namespace == FIXTURE_FIELD
            else item.path[-1]
        )
    return (
        observed_path == expected["path"]
        and failure_path_matches(fields["path"].items, observed_path)
    )


def _field_named(record: cd0.Datum, name: str) -> cd0.Datum:
    if type(record) is not cd0.Record:
        raise ValueError(f"{name}: parent is not a record")
    matches = [value for key, value in record.fields if key.path == (name,)]
    if len(matches) != 1:
        raise ValueError(f"{name}: expected one record field")
    return matches[0]


def _replace_named(
    record: cd0.Datum, name: str, replacement: cd0.Datum
) -> cd0.Record:
    if type(record) is not cd0.Record:
        raise ValueError(f"{name}: parent is not a record")
    found = 0
    fields: list[tuple[cd0.Identifier, cd0.Datum]] = []
    for key, value in record.fields:
        if key.path == (name,):
            found += 1
            fields.append((key, replacement))
        else:
            fields.append((key, value))
    if found != 1:
        raise ValueError(f"{name}: expected one record field")
    return cd0.record(fields)


def _blocked_success_candidate(
    request_id: str, input_datum: cd0.Datum, expected: cd0.Datum
) -> cd0.Datum:
    """Construct the sole input-derived candidate tolerated under each blocker.

    This is not an alternate fixture oracle.  It narrowly proves that a blocked
    implementation response differs from the frozen expected result only where
    the package contradicts its own explicit input, and that no ambient lookup
    or arbitrary value was substituted.
    """

    input_payload = _field_named(input_datum, "payload")
    expected_outputs = _field_named(expected, "outputs")
    if request_id == "vector:LCI0-P024":
        predecessor = _field_named(input_payload, "predecessor")
        revival = _field_named(expected_outputs, "revival")
        candidate_revival = _replace_named(revival, "new-occurrence", predecessor)
        candidate_outputs = _replace_named(
            expected_outputs, "revival", candidate_revival
        )
        return _replace_named(expected, "outputs", candidate_outputs)
    if request_id == "vector:LCI0-P029":
        right_source = _field_named(input_payload, "right-source")
        source_artifact = _field_named(right_source, "source-artifact")
        right_result = _field_named(expected_outputs, "right-result")
        lineage = _field_named(right_result, "lineage")
        if type(lineage) is not cd0.Sequence or len(lineage.items) != 1:
            raise ValueError("P029: expected one right-result lineage edge")
        candidate_edge = _replace_named(lineage.items[0], "source", source_artifact)
        candidate_lineage = cd0.sequence((candidate_edge,))
        candidate_right = _replace_named(right_result, "source", source_artifact)
        candidate_right = _replace_named(
            candidate_right, "lineage", candidate_lineage
        )
        candidate_outputs = _replace_named(
            expected_outputs, "right-result", candidate_right
        )
        return _replace_named(expected, "outputs", candidate_outputs)
    raise ValueError(f"no blocked-success candidate for {request_id}")


def _decoded_success_matches(
    request_id: str,
    decoded: cd0.Datum,
    input_datum: cd0.Datum,
    expected: cd0.Datum,
) -> bool:
    try:
        return decoded == _blocked_success_candidate(
            request_id, input_datum, expected
        )
    except ValueError:
        return False


def _valid_authorial_blocked_response(
    request_id: str,
    response: Mapping[str, Any],
    oracle: Mapping[str, Any],
) -> bool:
    actual_hex = response.get("actual_canonical_cd0_hex")
    if (
        type(actual_hex) is not str
        or not actual_hex
        or len(actual_hex) % 2
        or actual_hex != actual_hex.lower()
    ):
        return False
    try:
        decoded = cd0.decode_exact(bytes.fromhex(actual_hex), CD0_BUDGET)
    except (ValueError, cd0.CD0Failure):
        return False
    if canonical_bytes(decoded).hex() != actual_hex:
        return False
    if request_id in _BLOCKED_VECTOR_FAILURE_SHAPES:
        expected = _BLOCKED_VECTOR_FAILURE_SHAPES[request_id]
        return (
            response.get("semantic_status") == "failure"
            and response.get("failure") == expected
            and _decoded_failure_matches(decoded, expected)
        )
    shape = _BLOCKED_VECTOR_SUCCESS_SHAPES.get(request_id)
    try:
        input_datum = cd0.decode_exact(
            bytes.fromhex(oracle["expected_input_hex"]), CD0_BUDGET
        )
        expected = cd0.decode_exact(bytes.fromhex(oracle["expected_hex"]), CD0_BUDGET)
    except (KeyError, TypeError, ValueError, cd0.CD0Failure):
        return False
    return bool(
        shape is not None
        and response.get("semantic_status") == "success"
        and response.get("failure") is None
        and response.get("vector_id") == shape["vector_id"]
        and response.get("operation") == shape["operation"]
        and _decoded_success_matches(
            request_id, decoded, input_datum, expected
        )
    )


def _only_authorial_blockers(comparison: Mapping[str, Any]) -> bool:
    """Accept only the closed authorial-return census, never nearby failures."""

    implementations = comparison.get("implementations")
    if type(implementations) is not dict or set(implementations) != {
        "common-lisp", "python"
    }:
        return False
    for result in implementations.values():
        if type(result) is not dict:
            return False
        mismatches = result.get("mismatches")
        if type(mismatches) is not list:
            return False
        expected_blockers = (
            BLOCKED_VECTOR_REQUESTS
            | BLOCKED_HOSTILE_REQUESTS
            | BLOCKED_RELATION_PATH_REQUESTS
        )
        if {item.get("request_id") for item in mismatches} != expected_blockers:
            return False
        if any(
            item.get("disposition") != "authorial-blocked"
            or (
                item.get("request_id") in BLOCKED_VECTOR_REQUESTS
                and item.get("kind") != "vector"
            )
            or (
                item.get("request_id") in BLOCKED_HOSTILE_REQUESTS
                and item.get("kind") != "hostile"
            )
            or (
                item.get("request_id") in BLOCKED_RELATION_PATH_REQUESTS
                and item.get("kind") != "relation"
            )
            for item in mismatches
        ):
            return False
        counts = result.get("counts")
        if counts != EXPECTED_SUCCESSOR_IMPLEMENTATION_COUNTS:
            return False

    cross = comparison.get("cross_implementation_mismatches")
    if type(cross) is not list:
        return False
    cross_ids = [item.get("request_id") for item in cross]
    if (
        any(type(request_id) is not str for request_id in cross_ids)
        or len(cross_ids) != len(set(cross_ids))
        or not set(cross_ids)
        <= (BLOCKED_RELATION_PATH_REQUESTS | BLOCKED_HOSTILE_REQUESTS)
    ):
        return False
    for item in cross:
        request_id = item.get("request_id")
        differences = item.get("differences")
        if type(differences) is not dict or not differences:
            return False
        if request_id in BLOCKED_HOSTILE_REQUESTS:
            allowed = BLOCKED_HOSTILE_CROSS_DIFFERENCE_FIELDS[request_id]
            if item.get("kind") != "hostile" or not set(differences) <= allowed:
                return False
            if any(
                type(pair) is not dict
                or set(pair) != {"common-lisp", "python"}
                or pair["common-lisp"] == pair["python"]
                for pair in differences.values()
            ):
                return False
            continue
        if item.get("kind") != "relation" or set(differences) != {"failure"}:
            return False
        pair = differences["failure"]
        if type(pair) is not dict or set(pair) != {"common-lisp", "python"}:
            return False
        left, right = pair["common-lisp"], pair["python"]
        if type(left) is not dict or type(right) is not dict:
            return False
        if left.get("path") == right.get("path"):
            return False
        if (
            {name: value for name, value in left.items() if name != "path"}
            != {name: value for name, value in right.items() if name != "path"}
        ):
            return False
    return True


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--output",
        type=Path,
        default=Path("mneme/lci0/differential/artifacts/baseline-2026-07-14"),
    )
    arguments = parser.parse_args()
    output_directory = arguments.output.resolve()
    if output_directory.exists():
        raise HarnessFailure(f"evidence output already exists: {output_directory}")
    output_directory.mkdir(parents=True, exist_ok=False)

    requests, oracles, counts = build_requests()
    root = Path(__file__).resolve().parents[3]
    python_path = os.pathsep.join(
        (
            str(root / "mneme/lci0/differential"),
            str(root / "mneme/lci0/python"),
            str(root / "canonical-datum/python"),
        )
    )
    environment = dict(os.environ)
    environment["PYTHONPATH"] = python_path
    python_command = [sys.executable, str(root / "mneme/lci0/differential/python_adapter.py")]
    common_lisp_command = ["sbcl", "--noinform", "--disable-debugger", "--script", str(root / "mneme/lci0/differential/common_lisp_adapter.lisp")]

    common_lisp, common_lisp_metadata = _run_adapter("common-lisp", common_lisp_command, environment, requests, output_directory)
    python_responses, python_metadata = _run_adapter("python", python_command, environment, requests, output_directory)
    comparison = _compare(oracles, common_lisp, python_responses)
    only_authorial_blockers = _only_authorial_blockers(comparison)

    summary = {
        "protocol": PROTOCOL,
        "fixture_profile_version": FIXTURE_PROFILE_VERSION,
        "status": (
            "converged-unaffected-with-authorial-blockers"
            if only_authorial_blockers
            else "not-converged"
        ),
        "authorial_return_required": True,
        "authorial_blocked_vectors": sorted(BLOCKED_VECTOR_REQUESTS),
        "authorial_blocked_hostile_requests": sorted(BLOCKED_HOSTILE_REQUESTS),
        "authorial_blocked_relation_paths": sorted(
            BLOCKED_RELATION_PATH_REQUESTS
        ),
        "counts": counts,
        "runtime": {
            "python": sys.version,
            "python_executable": sys.executable,
            "platform": platform.platform(),
        },
        "pinned_seeds": {
            "common_lisp": {"commit": COMMON_LISP_SEED_COMMIT, "tree": COMMON_LISP_SEED_TREE},
            "python": {"commit": PYTHON_SEED_COMMIT, "tree": PYTHON_SEED_TREE},
        },
        "adapter_runs": {"common_lisp": common_lisp_metadata, "python": python_metadata},
        "comparison": comparison,
        "post_convergence_phases": {
            "host_perturbations": (
                "eligible-not-run"
                if only_authorial_blockers
                else "not-run: non-authorial differential mismatch"
            ),
            "randomized_properties": (
                "eligible-not-run"
                if only_authorial_blockers
                else "not-run: non-authorial differential mismatch"
            ),
        },
    }
    summary_path = output_directory / "summary.json"
    summary_path.write_text(json.dumps(summary, sort_keys=True, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    manifest = {}
    for path in sorted(output_directory.iterdir()):
        if path.is_file():
            payload = path.read_bytes()
            manifest[path.name] = {"bytes": len(payload), "sha256": hashlib.sha256(payload).hexdigest()}
    (output_directory / "sha256-manifest.json").write_text(json.dumps(manifest, sort_keys=True, indent=2) + "\n", encoding="utf-8")

    print(json.dumps({"status": summary["status"], "counts": counts, "cross_mismatches": len(comparison["cross_implementation_mismatches"]), "summary": str(summary_path)}, sort_keys=True))
    return 0 if only_authorial_blockers else 1


if __name__ == "__main__":
    raise SystemExit(main())
