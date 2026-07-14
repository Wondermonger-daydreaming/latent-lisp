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
from typing import Any, Iterable, Mapping

import cd0

from lci0.adapter import from_package_json
from lci0.core import CD0_BUDGET, canonical_bytes, field_by_path, replace_record_field
from lci0.package import definitions, iter_vectors, registry

from protocol import (
    COMMON_LISP_SEED_COMMIT,
    COMMON_LISP_SEED_TREE,
    FIXTURE_PROFILE_VERSION,
    PROTOCOL,
    PYTHON_SEED_COMMIT,
    PYTHON_SEED_TREE,
    request,
)


MAGIC_HEX = "4c50434400"
FIXTURE = ("lisp-plus", "lci", "0", "fixture")
FIXTURE_FIELD = FIXTURE + ("field",)
HOSTILE_NAMESPACE = FIXTURE + ("hostile",)


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
    cases.append({"name": "stable-ref-material-kind-namespace", "operation": "hostile-validate-stable-ref", "datum": replace_record_field(stable, "material", material_kind)})
    object_id = field_by_path(material, "object-id")
    _require(type(object_id) is cd0.Identifier and len(object_id.path) >= 3, "artifact object id shape")
    wrong_object_id = (object_id.path[0], "procedure", *object_id.path[2:])
    wrong_material = _replace_identifier_path(material, "object-id", wrong_object_id)
    cases.append({"name": "stable-ref-object-id-prefix", "operation": "hostile-validate-stable-ref", "datum": replace_record_field(stable, "material", wrong_material)})

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
            "expected_failure": {
                "category": "invalid-input",
                "code": "UnsupportedFixturePolicy",
                "stage": "admissibility",
                "path": ["policy"],
            },
        }
    )

    result = []
    for case in cases:
        encoded = canonical_bytes(case.pop("datum"))
        expected_status = case.pop("expected_semantic_status", "failure")
        result.append(
            {
                **case,
                "canonical_hex": encoded.hex(),
                "canonical_octets": len(encoded),
                "canonical_sha256": hashlib.sha256(encoded).hexdigest(),
                "expected_semantic_status": expected_status,
            }
        )
    return result


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
        oracles[request_id] = oracle

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
            encoded_hex = _verify_document_row(row, label)
            add(f"doc:relation:{label}", "document-roundtrip", encoded_hex, {"kind": "document", "expected_hex": encoded_hex, "class": "supplementary-relation-table"})
            add(f"relation:{label}", operation, encoded_hex, {"kind": "relation", "expected_relation": row["relation"], "table": table_name, "left_fixture": row["left_fixture"], "right_fixture": row["right_fixture"]})
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
    process = subprocess.run(command, input=request_bytes, capture_output=True, env=dict(environment))
    response_path = output_directory / f"{name}-responses.jsonl"
    stderr_path = output_directory / f"{name}-stderr.txt"
    response_path.write_bytes(process.stdout)
    stderr_path.write_bytes(process.stderr)
    _require(process.returncode == 0, f"{name} adapter exited {process.returncode}")
    responses: dict[str, dict[str, Any]] = {}
    for line_number, line in enumerate(process.stdout.decode("utf-8").splitlines(), 1):
        try:
            response = json.loads(line)
        except json.JSONDecodeError as exc:
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
            if response.get("protocol_status") != "success":
                counts["protocol_failures"] += 1
                mismatches.append({"request_id": request_id, "kind": oracle["kind"], "reason": "protocol-failure", "response": response})
                continue
            kind = oracle["kind"]
            counts[f"{kind}_requests"] += 1
            if response.get("input_reencoded_canonical_hex") != next(
                item for item in [response.get("input_reencoded_canonical_hex")]
            ):
                raise AssertionError("unreachable")
            if kind == "document":
                passed = response.get("input_reencoded_canonical_hex") == oracle["expected_hex"]
            elif kind == "vector":
                passed = response.get("actual_canonical_cd0_hex") == oracle["expected_hex"]
            elif kind == "relation":
                passed = response.get("relation") == oracle["expected_relation"]
            else:
                passed = response.get("semantic_status") == oracle["expected_semantic_status"]
                expected_failure = oracle.get("expected_failure")
                if passed and expected_failure is not None:
                    passed = response.get("failure") == expected_failure
            counts[f"{kind}_{'passed' if passed else 'failed'}"] += 1
            if not passed:
                mismatch = {"request_id": request_id, "kind": kind, "response": response}
                for field in (
                    "vector_id", "operation", "expected_relation", "table",
                    "left_fixture", "right_fixture", "canonical_sha256",
                    "canonical_octets", "expected_semantic_status",
                    "expected_failure",
                ):
                    if field in oracle:
                        mismatch[field] = oracle[field]
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
            ("input_reencoded_canonical_hex",)
            if kind == "document"
            else ("actual_canonical_cd0_hex", "semantic_status", "failure")
            if kind == "vector"
            else ("relation", "semantic_status", "failure")
            if kind == "relation"
            else ("semantic_status", "failure")
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
                    "common_lisp": {"semantic_status": left.get("semantic_status"), "failure": left.get("failure")},
                    "python": {"semantic_status": right.get("semantic_status"), "failure": right.get("failure")},
                }
            )
    return summary


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--output",
        type=Path,
        default=Path("mneme/lci0/differential/artifacts/baseline-2026-07-14"),
    )
    arguments = parser.parse_args()
    output_directory = arguments.output.resolve()
    output_directory.mkdir(parents=True, exist_ok=True)

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

    summary = {
        "protocol": PROTOCOL,
        "fixture_profile_version": FIXTURE_PROFILE_VERSION,
        "status": "not-converged" if comparison["cross_implementation_mismatches"] else "converged",
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
            "host_perturbations": "not-run: exact fixture convergence failed",
            "randomized_properties": "not-run: exact fixture convergence failed",
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
    return 1 if summary["status"] != "converged" else 0


if __name__ == "__main__":
    raise SystemExit(main())
