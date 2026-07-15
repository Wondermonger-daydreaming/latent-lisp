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
    BLOCKED_HOSTILE_REQUESTS,
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


def _fixture_carrier(fields: Iterable[tuple[str, cd0.Datum]]) -> cd0.Record:
    """Build an exact integration-only carrier in frozen fixture-field space."""

    return cd0.record(
        (cd0.identifier(FIXTURE_FIELD, (name,)), value) for name, value in fields
    )


_OVERLAY_SUBDIR = "lci0-fixture-overlay-0.2-2026-07-14"
_OVERLAY_INDEX_NAME = "LCI0-FIXTURE-OVERLAY-0.2-INDEX.json"


def _overlay_index() -> dict[str, Any]:
    """Load the ruled fixture overlay 0.2 index from the pinned fixture root.

    The overlay owns the ruled results for the four superseded official vectors
    and the eight hostile requests; the coordinator consults it directly so its
    expectations are the ruling's, not either implementation's."""

    root = os.environ.get("LCI0_FIXTURE_ROOT") or os.environ.get("LCI0_FIXTURE_DIR")
    _require(
        bool(root),
        "LCI0_FIXTURE_ROOT/LCI0_FIXTURE_DIR must name the overlay-0.2 fixture root",
    )
    index_path = Path(root) / _OVERLAY_SUBDIR / _OVERLAY_INDEX_NAME
    _require(index_path.is_file(), f"fixture overlay 0.2 index missing: {index_path}")
    index = json.loads(index_path.read_text(encoding="utf-8"))
    _require(type(index) is dict, "fixture overlay 0.2 index is not an object")
    return index


def _encode_semantic_value(value: Any) -> cd0.Datum:
    if value is None:
        return cd0.unit()
    if type(value) is bool:
        return cd0.boolean(value)
    if type(value) is int:
        return cd0.integer(value)
    if type(value) is str:
        return cd0.string(value)
    if type(value) is dict:
        return cd0.record(
            tuple(
                (cd0.identifier(FIXTURE_FIELD, (str(name),)), _encode_semantic_value(item))
                for name, item in value.items()
            )
        )
    raise HarnessFailure(f"unencodable ruled semantic value: {type(value)!r}")


def _semantic_result_document(operation: str, outputs: Mapping[str, Any]) -> cd0.Record:
    """Encode a ruled semantic success value into its canonical result document.

    ``outputs`` are already the (flattened) fixture-operation-result outputs the
    adapters emit; nested dicts become nested fixture-field records."""

    return cd0.record(
        (
            (
                cd0.identifier(FIXTURE_FIELD, ("kind",)),
                cd0.identifier(FIXTURE, ("tag", "fixture-operation-result")),
            ),
            (cd0.identifier(FIXTURE_FIELD, ("schema-version",)), cd0.integer(0)),
            (
                cd0.identifier(FIXTURE_FIELD, ("status",)),
                cd0.identifier(FIXTURE, ("result-status", "success")),
            ),
            (
                cd0.identifier(FIXTURE_FIELD, ("operation",)),
                cd0.identifier(FIXTURE, ("operation", operation)),
            ),
            (
                cd0.identifier(FIXTURE_FIELD, ("outputs",)),
                cd0.record(
                    tuple(
                        (cd0.identifier(FIXTURE_FIELD, (str(name),)), _encode_semantic_value(item))
                        for name, item in outputs.items()
                    )
                ),
            ),
        )
    )


def _superseded_vector_expected_hexes(index: Mapping[str, Any]) -> dict[str, str]:
    """The ruled overlay expected result hex for each of the four supersessions.

    Three vectors pin a canonical hex directly; P024's inert-defensive revival is
    pinned as a semantic document, which is re-encoded here into the exact
    fixture-operation-result document both adapters emit (outputs are the
    document's non-status coordinates)."""

    supersessions = index.get("supersessions")
    _require(type(supersessions) is dict, "overlay supersessions missing")
    result: dict[str, str] = {}
    for vector_id, entry in supersessions.items():
        encoding = entry.get("expected_result_encoding")
        if encoding == "canonical_cd0_hex":
            hex_value = entry.get("expected_canonical_cd0_hex")
            _require(type(hex_value) is str and bool(hex_value), f"{vector_id}: overlay hex missing")
            result[vector_id] = hex_value
        elif encoding == "semantic_json_document":
            semantic = entry.get("expected_result")
            _require(type(semantic) is dict, f"{vector_id}: overlay semantic result missing")
            outputs = {name: item for name, item in semantic.items() if name != "status"}
            document = _semantic_result_document(entry["operation"], outputs)
            result[vector_id] = canonical_bytes(document).hex()
        else:
            raise HarnessFailure(f"{vector_id}: unknown overlay result encoding {encoding!r}")
    return result


def _at_inclusive_limit_conformance_expected_hex(index: Mapping[str, Any]) -> str:
    """The ruled within-budget conformance value document (RESOURCE at limit 64).

    The overlay pins it as a semantic value; the adapters flatten that value into
    the fixture-operation-result outputs, and this rebuilds the same document."""

    hostile = index.get("hostile")
    _require(type(hostile) is dict, "overlay hostile section missing")
    entry = hostile.get("resource-maximum-nesting-at-limit-64")
    _require(type(entry) is dict, "overlay at-limit-64 hostile entry missing")
    semantic = entry.get("expected_result")
    _require(
        type(semantic) is dict and type(semantic.get("value")) is dict,
        "overlay at-limit-64 semantic value missing",
    )
    document = _semantic_result_document("conformance-validation", semantic["value"])
    return canonical_bytes(document).hex()


def _hostile_cases() -> list[dict[str, Any]]:
    cases: list[dict[str, Any]] = []
    vector_rows = {row["vector_id"]: row for row in iter_vectors()}

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
        "production": ("object", "artifact", "production"),
        "model-current": ("object", "artifact", "model-current"),
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
    _target_schema_mismatch = {
        "category": "invalid-input",
        "code": "TargetSchemaKindMismatch",
        "stage": "target-schema",
        "path": ["target-schema"],
    }
    cases.append({"name": "observed-with-executed-target-schema", "operation": "hostile-validate-warrant-target", "datum": replace_record_field(observed, "target-schema", field_by_path(executed, "target-schema")), "expected_failure": dict(_target_schema_mismatch)})
    cases.append({"name": "executed-with-observed-target-schema", "operation": "hostile-validate-warrant-target", "datum": replace_record_field(executed, "target-schema", field_by_path(observed, "target-schema")), "expected_failure": dict(_target_schema_mismatch)})

    boundaries = field_by_path(observed, "boundaries")
    coverage = field_by_path(boundaries, "coverage-scope")
    expression = field_by_path(coverage, "expression")
    future_expression = cd0.record((*expression.fields, (cd0.identifier(FIXTURE_FIELD, ("future-selector",)), cd0.unit())))
    future_coverage = replace_record_field(coverage, "expression", future_expression)
    future_boundaries = replace_record_field(boundaries, "coverage-scope", future_coverage)
    cases.append(
        {
            "name": "target-nested-coverage-future-selector",
            "operation": "hostile-validate-warrant-target",
            "datum": replace_record_field(observed, "boundaries", future_boundaries),
            "expected_failure": {
                "category": "invalid-input",
                "code": "UnknownField",
                "stage": "target-boundary",
                "path": [
                    "boundaries",
                    "fixture-field:coverage-scope",
                    "expression",
                    "fixture-field:future-selector",
                ],
            },
        }
    )

    claim = from_package_json(definitions()["claim-id.file-alpha-neutral"]["abstract_cd0"], CD0_BUDGET)
    cases.append({"name": "claim-outer-kind-key-namespace", "operation": "hostile-validate-claim-id", "datum": _replace_key_namespace(claim, "kind", HOSTILE_NAMESPACE)})
    location = field_by_path(claim, "location")
    scope = field_by_path(location, "scope")
    expression = field_by_path(scope, "expression")
    hostile_expression = _replace_key_namespace(expression, "kind", HOSTILE_NAMESPACE)
    hostile_scope = replace_record_field(scope, "expression", hostile_expression)
    hostile_location = replace_record_field(location, "scope", hostile_scope)
    cases.append({"name": "claim-nested-expression-kind-key-namespace", "operation": "hostile-validate-claim-id", "datum": replace_record_field(claim, "location", hostile_location)})

    # Direct projection accepts only a ClaimId envelope or the four-field LCI
    # projection input.  An occurrence-like fixture carrier is not an alternate
    # projection schema, even when semantic-claim-core contains a valid claim.
    projection_carrier = _fixture_carrier(
        (
            ("semantic-claim-core", claim),
            ("future", cd0.unit()),
        )
    )
    cases.append(
        {
            "name": "project-claim-id-carrier-future-field",
            "operation": "hostile-project-claim-id",
            "datum": projection_carrier,
            "expected_failure": {
                "category": "invalid-input",
                "code": "MissingRequiredField",
                "stage": "claim-shape",
                "path": ["identity-policy"],
            },
        }
    )

    # N009 supplies the tagged profile-location schema.  Removing its sole
    # future coordinate leaves a nonempty tagged wrapper, which Mneme/0 still
    # rejects because the only valid ClaimId coordinate is the exact empty
    # record frozen by LCI/0 section 7.9 and Errata I12(a).
    n009_envelope = from_package_json(
        vector_rows["LCI0-N009"]["inputs"]["abstract_cd0"], CD0_BUDGET
    )
    n009_claim = field_by_path(field_by_path(n009_envelope, "payload"), "claim")
    n009_location = field_by_path(n009_claim, "location")
    tagged_profile = field_by_path(n009_location, "profile-location")
    tagged_empty_profile = replace_record_field(
        tagged_profile, "coordinates", cd0.record(())
    )
    tagged_location = replace_record_field(
        n009_location, "profile-location", tagged_empty_profile
    )
    cases.append(
        {
            "name": "claim-tagged-empty-profile-location",
            "operation": "hostile-validate-claim-id",
            "datum": replace_record_field(n009_claim, "location", tagged_location),
            "expected_failure": {
                "category": "invalid-input",
                "code": "UnknownField",
                "stage": "profile-location",
                "path": ["location", "profile-location", "kind"],
            },
        }
    )

    # Exact two-field target carriers expose the E6 precedence boundary without
    # borrowing either implementation as an oracle.
    beta_claim = from_package_json(
        definitions()["claim-id.file-beta-neutral"]["abstract_cd0"], CD0_BUDGET
    )
    proposition_failure = {
        "category": "target-mismatch",
        "code": "PropositionMismatch",
        "stage": "target-relation",
        "path": ["claim", "proposition"],
    }
    cases.append(
        {
            "name": "match-target-beta-proposition",
            "operation": "hostile-match-target",
            "datum": _fixture_carrier(
                (("target", observed), ("candidate-claim", beta_claim))
            ),
            "expected_failure": proposition_failure,
        }
    )

    timed_claim = from_package_json(
        definitions()["claim-id.file-alpha-today"]["abstract_cd0"], CD0_BUDGET
    )
    beta_location = field_by_path(beta_claim, "location")
    mismatched_time_location = replace_record_field(
        beta_location,
        "subject-time",
        field_by_path(field_by_path(timed_claim, "location"), "subject-time"),
    )
    beta_and_time_mismatch = replace_record_field(
        beta_claim, "location", mismatched_time_location
    )
    cases.append(
        {
            "name": "match-target-proposition-before-subject-time",
            "operation": "hostile-match-target",
            "datum": _fixture_carrier(
                (("target", observed), ("candidate-claim", beta_and_time_mismatch))
            ),
            "expected_failure": proposition_failure,
        }
    )

    nonmonotone_envelope = from_package_json(
        vector_rows["LCI0-E5-NONMONOTONE-NARROWING"]["inputs"]["abstract_cd0"],
        CD0_BUDGET,
    )
    insufficient_envelope = from_package_json(
        vector_rows["LCI0-E5-COVERAGE-INSUFFICIENT"]["inputs"]["abstract_cd0"],
        CD0_BUDGET,
    )
    nonmonotone_payload = field_by_path(nonmonotone_envelope, "payload")
    insufficient_payload = field_by_path(insufficient_envelope, "payload")
    nonmonotone_target = field_by_path(nonmonotone_payload, "target")
    nonmonotone_boundaries = field_by_path(nonmonotone_target, "boundaries")
    insufficient_boundaries = field_by_path(
        field_by_path(insufficient_payload, "target"), "boundaries"
    )
    combined_boundaries = replace_record_field(
        nonmonotone_boundaries,
        "coverage-scope",
        field_by_path(insufficient_boundaries, "coverage-scope"),
    )
    combined_target = replace_record_field(
        nonmonotone_target, "boundaries", combined_boundaries
    )
    cases.append(
        {
            "name": "match-target-nonmonotone-before-insufficient-coverage",
            "operation": "hostile-match-target",
            "datum": _fixture_carrier(
                (
                    ("target", combined_target),
                    (
                        "candidate-claim",
                        field_by_path(nonmonotone_payload, "candidate-claim"),
                    ),
                )
            ),
            "expected_failure": {
                "category": "target-mismatch",
                "code": "ScopeNarrowingNotDeclared",
                "stage": "target-relation",
                "path": ["claim", "location", "scope"],
            },
        }
    )

    # ClaimId equality is defined only for validated envelopes.  Structurally
    # equal empty records are not ClaimIds and must not compare as such.
    cases.append(
        {
            "name": "claim-id-equality-rejects-empty-records",
            "operation": "hostile-claim-ids-equal",
            "datum": _fixture_carrier(
                (("left-claim-id", cd0.record(())), ("right-claim-id", cd0.record(())))
            ),
            "expected_failure": {
                "category": "invalid-input",
                "code": "MissingRequiredField",
                "stage": "claim-shape",
                "path": ["kind"],
            },
        }
    )

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
        # Render each ruled path exactly as the adapters emit it (the
        # fixture-field / standard-field namespace normalization).
        "allowed_failure_paths": [
            canonical_failure_path(path) for path in allowed_paths
        ],
    }


def _relation_expectation(
    *,
    request_id: str,
    table_name: str,
    relation: str,
    left_fixture: str,
    right_fixture: str,
) -> dict[str, Any]:
    """Return the ruled companion status/tuple for a pinned relation row.

    The registry pins the relation token.  The LCI calculus and Errata E6 pin
    whether that token is returned normally or as a typed F-valued failure.
    The thirty-eight LCI0-AC-002 closure rows now carry a single ruled
    companion path: cross-calculus scope incompatibility selects the right
    operand's calculus, and a symbolic right temporal form selects the right
    operand's expression form.
    """

    if table_name == "scope_relation_table_0":
        if relation == "unknown":
            return _relation_failure_expectation(
                code="ScopeRelationUnknown",
                stage="target-relation",
                allowed_paths=(("fixture-field:right",),),
            )
        if relation == "incompatible":
            return _relation_failure_expectation(
                code="ScopeIncompatible",
                stage="target-relation",
                allowed_paths=(("fixture-field:right", "calculus"),),
            )
    elif table_name == "temporal_relation_table_0":
        if relation == "unknown":
            if right_fixture == "subject-time.symbolic-unknown":
                return _relation_failure_expectation(
                    code="AdmissibilityUndetermined",
                    stage="subject-time",
                    allowed_paths=(
                        ("fixture-field:right", "expression", "form"),
                    ),
                )
            return _relation_failure_expectation(
                code="AdmissibilityUndetermined",
                stage="subject-time",
                allowed_paths=(("fixture-field:left",),),
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
    overlay = _overlay_index()
    superseded_expected_hex = _superseded_vector_expected_hexes(overlay)
    at_limit_conformance_hex = _at_inclusive_limit_conformance_expected_hex(overlay)
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
        # The four superseded official vectors (N012, E5-COVERAGE-INSUFFICIENT,
        # P024, P029) are ruled by overlay 0.2; their semantic expectation is the
        # overlay result, not the frozen 0.1 expected document (which still
        # round-trips as the doc:vector-expected request above).
        vector_expected_hex = superseded_expected_hex.get(vector_id, expected_hex)
        add(f"vector:{vector_id}", row["operation"], input_hex, {"kind": "vector", "vector_id": vector_id, "expected_hex": vector_expected_hex, "operation": row["operation"]})
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
        oracle = {"kind": "hostile", **row}
        if row["name"] == "resource-maximum-nesting-at-limit-64":
            # LCI0-AC-007: pin the exact ruled within-budget value document.
            oracle["expected_result_hex"] = at_limit_conformance_hex
        add(f"hostile:{row['name']}", row["operation"], row["canonical_hex"], oracle)

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
            # Policy-C fail-closed is a ruled non-LCI fixture authority gap: a
            # legitimate passing outcome, no longer an authorial blocker.
            if kind == "hostile" and shape == "fixture-authority-gap":
                passed = input_passed and _valid_authority_gap_response(response, oracle)
                counts[f"hostile_{'passed' if passed else 'failed'}"] += 1
                if not passed:
                    mismatches.append(
                        {
                            "request_id": request_id,
                            "kind": "hostile",
                            "reason": "authority-gap-out-of-bounds",
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
            else:  # hostile (hostile-validation or fixture-operation shape)
                passed = input_passed and response.get("semantic_status") == oracle["expected_semantic_status"]
                expected_failure = oracle.get("expected_failure")
                if passed and expected_failure is not None:
                    passed = response.get("failure") == expected_failure
                if passed and shape == "fixture-operation":
                    passed = canonical_report_matches(response)
                    if passed and oracle.get("expected_result_hex") is not None:
                        passed = (
                            response.get("actual_canonical_cd0_hex")
                            == oracle["expected_result_hex"]
                        )
            disposition = "passed" if passed else "failed"
            counts[f"{kind}_{disposition}"] += 1
            if not passed:
                mismatch = {"request_id": request_id, "kind": kind, "response": response}
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


def _fully_converged(comparison: Mapping[str, Any]) -> bool:
    """Accept only full byte-exact convergence of both authorial-closure forges.

    Every one of the 2,295 requests per implementation must pass: zero
    mismatches, the closed execution census on both implementations, and an
    empty cross-implementation difference set.  This is the closed successor to
    the old authorial-blocker gate; with LCI0-AC-001..010 resolved, no blocked
    observation is tolerated."""

    implementations = comparison.get("implementations")
    if type(implementations) is not dict or set(implementations) != {
        "common-lisp", "python"
    }:
        return False
    for result in implementations.values():
        if type(result) is not dict:
            return False
        mismatches = result.get("mismatches")
        if type(mismatches) is not list or mismatches:
            return False
        counts = result.get("counts")
        if counts != EXPECTED_SUCCESSOR_IMPLEMENTATION_COUNTS:
            return False

    cross = comparison.get("cross_implementation_mismatches")
    return type(cross) is list and not cross


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
    converged = _fully_converged(comparison)

    summary = {
        "protocol": PROTOCOL,
        "fixture_profile_version": FIXTURE_PROFILE_VERSION,
        "status": (
            "converged-authorial-closures-complete"
            if converged
            else "not-converged"
        ),
        "authorial_return_required": False,
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
                "eligible"
                if converged
                else "not-run: unresolved differential mismatch"
            ),
            "randomized_properties": (
                "eligible"
                if converged
                else "not-run: unresolved differential mismatch"
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
    return 0 if converged else 1


if __name__ == "__main__":
    raise SystemExit(main())
