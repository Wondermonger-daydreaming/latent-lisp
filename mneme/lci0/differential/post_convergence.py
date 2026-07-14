"""Deterministic post-convergence LCI/0 property and host evidence harness.

The exact fixture differential remains the gate.  This program refuses to
start randomized work unless that summary contains only the disclosed
authorial-return census: four exact-vector conflicts and 38 unpinned companion
failure paths, plus one unsupported-policy hostile witness whose exact LCI
failure tuple is not authorized.  Blocked observations remain blocked; they are never counted as
pass, skip, or N/A.

Neither implementation supplies expectations for this phase.  Cases are
derived from frozen fixture values and normative metamorphic rules, then both
adapters are compared symmetrically.
"""

from __future__ import annotations

import argparse
from collections import Counter
from dataclasses import dataclass
import hashlib
import json
import os
from pathlib import Path
import platform
import random
import subprocess
import sys
from typing import Any, Iterable, Mapping, Sequence

import cd0

from lci0.adapter import from_package_json
from lci0.core import CD0_BUDGET, canonical_bytes, field_by_path, replace_record_field
from lci0.package import definitions, fixture_datum, iter_vectors

import run_differential as exact_harness

from authorial_blockers import (
    BLOCKED_HOSTILE_CROSS_DIFFERENCE_FIELDS,
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
    canonical_report_matches,
    loads_closed_json,
    validate_response,
)


PROPERTY_SEED = 0x4C434930
PROPERTY_CASES = 64
FIXTURE = ("lisp-plus", "lci", "0", "fixture")
FIXTURE_FIELD = FIXTURE + ("field",)
PROPERTY_NAMESPACE = FIXTURE + ("post-convergence",)
REGISTRY_SHA256 = "dd19c6d6543a875b2e7e1e6a234ad731ce019f64495b447b317462c63f826327"
VECTORS_SHA256 = "387e76963f3087f6e41ec4363ec3eea29b1456c2a6b3c5a0cf5763418bffe3a4"

class EvidenceFailure(RuntimeError):
    pass


def _require(condition: bool, message: str) -> None:
    if not condition:
        raise EvidenceFailure(message)


def _json_bytes(value: Any, *, pretty: bool = False) -> bytes:
    if pretty:
        text = json.dumps(value, sort_keys=True, indent=2, ensure_ascii=False) + "\n"
    else:
        text = json.dumps(
            value, sort_keys=True, separators=(",", ":"), ensure_ascii=False
        ) + "\n"
    return text.encode("utf-8")


EXACT_ARTIFACT_MEMBERS = frozenset(
    {
        "common-lisp-responses.jsonl",
        "common-lisp-stderr.txt",
        "python-responses.jsonl",
        "python-stderr.txt",
        "requests.jsonl",
        "summary.json",
    }
)


def _exact_response_rows(
    payload: bytes, label: str, expected_ids: set[str]
) -> dict[str, dict[str, Any]]:
    try:
        lines = payload.decode("utf-8").splitlines()
    except UnicodeDecodeError as exc:
        raise EvidenceFailure(f"{label}: response is not UTF-8") from exc
    responses: dict[str, dict[str, Any]] = {}
    for line_number, line in enumerate(lines, 1):
        try:
            response = loads_closed_json(line)
        except (json.JSONDecodeError, ValueError) as exc:
            raise EvidenceFailure(
                f"{label}:{line_number}: invalid or duplicate-member JSON"
            ) from exc
        _require(type(response) is dict, f"{label}:{line_number}: not an object")
        request_id = response.get("request_id")
        _require(
            type(request_id) is str and request_id,
            f"{label}:{line_number}: request id",
        )
        _require(request_id not in responses, f"{label}: duplicate response id")
        responses[request_id] = response
    _require(set(responses) == expected_ids, f"{label}: response ID set mismatch")
    return responses


def replay_successor_artifacts(directory: Path) -> tuple[dict[str, Any], dict[str, Any]]:
    """Recompute the exact differential from hash-bound raw artifacts."""

    directory = directory.resolve()
    _require(directory.is_dir(), f"successor artifact directory missing: {directory}")
    _require(not directory.is_symlink(), "successor artifact directory is a symlink")
    manifest_path = directory / "sha256-manifest.json"
    _require(manifest_path.is_file(), "successor artifact manifest missing")
    manifest_payload = manifest_path.read_bytes()
    try:
        manifest = loads_closed_json(manifest_payload)
    except (json.JSONDecodeError, ValueError) as exc:
        raise EvidenceFailure("successor artifact manifest is invalid JSON") from exc
    _require(type(manifest) is dict, "successor artifact manifest is not an object")
    _require(set(manifest) == EXACT_ARTIFACT_MEMBERS, "successor artifact member census drift")

    actual_names = {
        path.name for path in directory.iterdir() if path.name != manifest_path.name
    }
    _require(actual_names == EXACT_ARTIFACT_MEMBERS, "successor artifact directory has extra/missing members")
    payloads: dict[str, bytes] = {}
    for name in sorted(EXACT_ARTIFACT_MEMBERS):
        path = directory / name
        _require(path.is_file() and not path.is_symlink(), f"successor member is not a regular file: {name}")
        payload = path.read_bytes()
        row = manifest.get(name)
        _require(
            type(row) is dict and set(row) == {"bytes", "sha256"},
            f"successor manifest row is not closed: {name}",
        )
        _require(
            row["bytes"] == len(payload) and row["sha256"] == _sha256(payload),
            f"successor member identity mismatch: {name}",
        )
        payloads[name] = payload

    requests, oracles, counts = exact_harness.build_requests()
    expected_request_payload = "".join(
        exact_harness._json_line(item) for item in requests
    ).encode("utf-8")
    _require(
        payloads["requests.jsonl"] == expected_request_payload,
        "successor request transcript is not the mechanically rebuilt census",
    )
    expected_ids = set(oracles)
    common_lisp = _exact_response_rows(
        payloads["common-lisp-responses.jsonl"], "common-lisp", expected_ids
    )
    python = _exact_response_rows(
        payloads["python-responses.jsonl"], "python", expected_ids
    )
    comparison = exact_harness._compare(oracles, common_lisp, python)
    _require(
        exact_harness._only_authorial_blockers(comparison),
        "raw successor responses do not reproduce the closed authorial-blocker census",
    )

    try:
        summary = loads_closed_json(payloads["summary.json"])
    except (json.JSONDecodeError, ValueError) as exc:
        raise EvidenceFailure("successor summary is invalid JSON") from exc
    _require(type(summary) is dict, "successor summary is not an object")
    _require(summary.get("counts") == counts, "successor summary/request census mismatch")
    _require(summary.get("comparison") == comparison, "successor summary/raw comparison mismatch")

    request_sha = _sha256(payloads["requests.jsonl"])
    adapter_runs = summary.get("adapter_runs")
    _require(
        type(adapter_runs) is dict and set(adapter_runs) == {"common_lisp", "python"},
        "successor adapter run metadata drift",
    )
    for key, response_name, stderr_name in (
        ("common_lisp", "common-lisp-responses.jsonl", "common-lisp-stderr.txt"),
        ("python", "python-responses.jsonl", "python-stderr.txt"),
    ):
        row = adapter_runs[key]
        _require(type(row) is dict, f"{key}: adapter metadata missing")
        _require(
            row.get("exit_code") == 0
            and row.get("requests") == len(requests)
            and row.get("responses") == len(requests)
            and row.get("request_bytes") == len(expected_request_payload)
            and row.get("request_sha256") == request_sha
            and row.get("response_bytes") == len(payloads[response_name])
            and row.get("response_sha256") == _sha256(payloads[response_name])
            and row.get("stderr_bytes") == len(payloads[stderr_name])
            and row.get("stderr_sha256") == _sha256(payloads[stderr_name]),
            f"{key}: adapter metadata is not bound to raw transcripts",
        )

    receipt = {
        "directory": str(directory),
        "manifest_bytes": len(manifest_payload),
        "manifest_sha256": _sha256(manifest_payload),
        "members": {
            name: {"bytes": len(payload), "sha256": _sha256(payload)}
            for name, payload in sorted(payloads.items())
        },
        "recomputed_requests_per_implementation": len(requests),
        "recomputed_total_responses": len(requests) * 2,
    }
    return summary, receipt


def _sha256(payload: bytes) -> str:
    return hashlib.sha256(payload).hexdigest()


def _field(record: cd0.Datum, name: str) -> cd0.Datum:
    return field_by_path(record, name)


def _record(values: Mapping[str, cd0.Datum]) -> cd0.Record:
    return cd0.record(
        (cd0.identifier(FIXTURE_FIELD, (name,)), value)
        for name, value in values.items()
    )


def _add_field(
    record: cd0.Datum,
    name: str,
    value: cd0.Datum,
    namespace: tuple[str, ...] = FIXTURE_FIELD,
) -> cd0.Record:
    _require(type(record) is cd0.Record, f"{name}: add-field root is not record")
    _require(
        all(key.path != (name,) or key.namespace != namespace for key, _ in record.fields),
        f"{name}: duplicate added field",
    )
    return cd0.record(
        (*record.fields, (cd0.identifier(namespace, (name,)), value))
    )


def _remove_field(record: cd0.Datum, name: str) -> cd0.Record:
    _require(type(record) is cd0.Record, f"{name}: remove-field root is not record")
    fields = [(key, value) for key, value in record.fields if key.path != (name,)]
    _require(len(fields) + 1 == len(record.fields), f"{name}: field not found")
    return cd0.record(fields)


def _replace_first_rational(
    value: cd0.Datum, replacement: cd0.Rational
) -> tuple[cd0.Datum, bool]:
    if type(value) is cd0.Rational:
        return replacement, True
    if type(value) is cd0.Sequence:
        output: list[cd0.Datum] = []
        found = False
        for child in value.items:
            if found:
                output.append(child)
            else:
                replaced, found = _replace_first_rational(child, replacement)
                output.append(replaced)
        return cd0.sequence(output), found
    if type(value) is cd0.Record:
        output: list[tuple[cd0.Identifier, cd0.Datum]] = []
        found = False
        for key, child in value.fields:
            if found:
                output.append((key, child))
            else:
                replaced, found = _replace_first_rational(child, replacement)
                output.append((key, replaced))
        return cd0.record(output), found
    return value, False


def _reallocate(value: cd0.Datum, rng: random.Random) -> cd0.Datum:
    if type(value) is cd0.Unit:
        return cd0.unit()
    if type(value) is cd0.Boolean:
        return cd0.boolean(value.value)
    if type(value) is cd0.Integer:
        return cd0.integer(value.value)
    if type(value) is cd0.Rational:
        return cd0.rational(value.numerator, value.denominator)
    if type(value) is cd0.String:
        return cd0.string((" " + value.value)[1:])
    if type(value) is cd0.ByteString:
        return cd0.byte_string(bytes(bytearray(value.value)))
    if type(value) is cd0.Identifier:
        return cd0.identifier(tuple(value.namespace), tuple(value.path))
    if type(value) is cd0.Sequence:
        return cd0.sequence(_reallocate(child, rng) for child in value.items)
    if type(value) is cd0.Record:
        fields = [
            (_reallocate(key, rng), _reallocate(child, rng))
            for key, child in value.fields
        ]
        rng.shuffle(fields)
        return cd0.record(fields)
    raise TypeError(type(value))


def _vector_datum(rows: Mapping[str, Mapping[str, Any]], vector_id: str) -> cd0.Datum:
    return from_package_json(rows[vector_id]["inputs"]["abstract_cd0"], CD0_BUDGET)


def _custom_vector(
    rows: Mapping[str, Mapping[str, Any]],
    template_id: str,
    embedded_id: str,
    payload: cd0.Record,
) -> tuple[str, cd0.Record]:
    template = _vector_datum(rows, template_id)
    operation = rows[template_id]["operation"]
    result = replace_record_field(template, "payload", payload)
    result = replace_record_field(result, "vector-id", cd0.string(embedded_id))
    return operation, result


def _projection_core(envelope: cd0.Datum) -> cd0.Record:
    _require(type(envelope) is cd0.Record, "projection envelope is not a record")
    wanted = {"identity-policy", "claim-profile", "proposition", "location"}
    fields = [(key, value) for key, value in envelope.fields if key.path[-1] in wanted]
    _require(len(fields) == 4, "projection core does not have four exact fields")
    return cd0.record(fields)


@dataclass(frozen=True)
class PropertyCase:
    case_id: str
    family: str
    operation: str
    datum: cd0.Datum
    expected_status: str
    failure_code: str | None = None
    failure_stage: str | None = None
    failure_path: tuple[str, ...] | None = None
    equivalence_group: str | None = None
    distinct_group: str | None = None
    output_boolean: tuple[str, bool] | None = None
    output_identifiers: tuple[
        tuple[tuple[str, ...], tuple[str, ...], tuple[str, ...]], ...
    ] = ()
    authorial_blocked_failure_coordinates: tuple[str, ...] = ()
    authorial_blocked_result_coordinates: tuple[str, ...] = ()

    def manifest_row(self) -> dict[str, Any]:
        encoded = canonical_bytes(self.datum)
        return {
            "canonical_octets": len(encoded),
            "canonical_sha256": _sha256(encoded),
            "case_id": self.case_id,
            "distinct_group": self.distinct_group,
            "embedded_vector_id": _field(self.datum, "vector-id").value,
            "equivalence_group": self.equivalence_group,
            "expected": {
                "authorial_blocked_failure_coordinates": list(
                    self.authorial_blocked_failure_coordinates
                ),
                "authorial_blocked_result_coordinates": list(
                    self.authorial_blocked_result_coordinates
                ),
                "failure_code": self.failure_code,
                "failure_path": list(self.failure_path) if self.failure_path else None,
                "failure_stage": self.failure_stage,
                "output_boolean": list(self.output_boolean) if self.output_boolean else None,
                "output_identifiers": [
                    [list(path), list(namespace), list(identifier_path)]
                    for path, namespace, identifier_path in self.output_identifiers
                ],
                "semantic_status": self.expected_status,
            },
            "family": self.family,
            "operation": self.operation,
        }


def verify_successor_gate(summary: Mapping[str, Any]) -> dict[str, Any]:
    _require(summary.get("protocol") == PROTOCOL, "successor summary protocol drift")
    _require(
        summary.get("fixture_profile_version") == FIXTURE_PROFILE_VERSION,
        "successor summary profile drift",
    )
    _require(
        summary.get("status") == "converged-unaffected-with-authorial-blockers",
        "successor summary has not converged on every unaffected path",
    )
    _require(
        summary.get("authorial_return_required") is True,
        "successor summary lost the authorial-return boundary",
    )
    _require(
        set(summary.get("authorial_blocked_vectors", ()))
        == BLOCKED_VECTOR_REQUESTS,
        "successor vector-blocker declaration drift",
    )
    _require(
        set(summary.get("authorial_blocked_hostile_requests", ()))
        == BLOCKED_HOSTILE_REQUESTS,
        "successor hostile-blocker declaration drift",
    )
    counts = summary.get("counts")
    _require(type(counts) is dict, "successor summary counts missing")
    for name, expected in EXPECTED_SUCCESSOR_REQUEST_COUNTS.items():
        _require(counts.get(name) == expected, f"successor count drift: {name}")
    operation_counts = counts.get("vector_operation_families")
    expected_operation_counts = dict(
        sorted(Counter(row["operation"] for row in iter_vectors()).items())
    )
    _require(
        operation_counts == expected_operation_counts,
        "successor operation family census drift",
    )
    _require(
        summary.get("pinned_seeds")
        == {
            "common_lisp": {
                "commit": COMMON_LISP_SEED_COMMIT,
                "tree": COMMON_LISP_SEED_TREE,
            },
            "python": {
                "commit": PYTHON_SEED_COMMIT,
                "tree": PYTHON_SEED_TREE,
            },
        },
        "successor seed provenance drift",
    )

    comparison = summary.get("comparison")
    _require(type(comparison) is dict, "successor comparison missing")
    implementations = comparison.get("implementations")
    _require(
        type(implementations) is dict
        and set(implementations) == {"common-lisp", "python"},
        "successor implementation set drift",
    )
    blocked_vectors: dict[str, list[str]] = {}
    for implementation, result in implementations.items():
        implementation_counts = result.get("counts")
        _require(
            implementation_counts == EXPECTED_SUCCESSOR_IMPLEMENTATION_COUNTS,
            f"{implementation}: exact execution accounting drift",
        )
        mismatches = result.get("mismatches")
        _require(type(mismatches) is list, f"{implementation}: mismatches missing")
        ids = [item.get("request_id") for item in mismatches]
        _require(all(type(item) is str for item in ids), f"{implementation}: malformed mismatch")
        _require(len(ids) == len(set(ids)), f"{implementation}: duplicate mismatch")
        expected_blockers = (
            BLOCKED_VECTOR_REQUESTS
            | BLOCKED_HOSTILE_REQUESTS
            | BLOCKED_RELATION_PATH_REQUESTS
        )
        unexpected = set(ids) - expected_blockers
        missing = expected_blockers - set(ids)
        _require(not unexpected, f"{implementation}: non-authorial mismatches {sorted(unexpected)}")
        _require(not missing, f"{implementation}: authorial blockers silently absent {sorted(missing)}")
        _require(
            all(
                item.get("disposition") == "authorial-blocked"
                and (
                    (
                        item.get("request_id") in BLOCKED_VECTOR_REQUESTS
                        and item.get("kind") == "vector"
                    )
                    or (
                        item.get("request_id") in BLOCKED_HOSTILE_REQUESTS
                        and item.get("kind") == "hostile"
                    )
                    or (
                        item.get("request_id") in BLOCKED_RELATION_PATH_REQUESTS
                        and item.get("kind") == "relation"
                    )
                )
                for item in mismatches
            ),
            f"{implementation}: blocker kind drift",
        )
        blocked_vectors[implementation] = sorted(ids)

    cross = comparison.get("cross_implementation_mismatches")
    _require(type(cross) is list, "successor cross comparison missing")
    cross_ids = [item.get("request_id") for item in cross]
    _require(all(type(item) is str for item in cross_ids), "malformed cross mismatch")
    _require(len(cross_ids) == len(set(cross_ids)), "duplicate cross mismatch")
    unexpected = set(cross_ids) - (
        BLOCKED_RELATION_PATH_REQUESTS | BLOCKED_HOSTILE_REQUESTS
    )
    _require(not unexpected, f"non-authorial cross mismatches {sorted(unexpected)}")
    declared_blocked_paths = summary.get("authorial_blocked_relation_paths")
    _require(
        type(declared_blocked_paths) is list
        and all(type(item) is str for item in declared_blocked_paths),
        "successor summary lacks explicit authorial_blocked_relation_paths",
    )
    _require(
        len(declared_blocked_paths) == len(set(declared_blocked_paths))
        and set(declared_blocked_paths) == BLOCKED_RELATION_PATH_REQUESTS,
        "successor relation-path blocker declaration is not the exact 38-row census",
    )
    for item in cross:
        request_id = item.get("request_id")
        differences = item.get("differences")
        if request_id in BLOCKED_HOSTILE_REQUESTS:
            allowed = BLOCKED_HOSTILE_CROSS_DIFFERENCE_FIELDS[request_id]
            _require(
                item.get("kind") == "hostile"
                and type(differences) is dict
                and bool(differences)
                and set(differences) <= allowed,
                f"{request_id}: hostile blocker difference drift",
            )
            _require(
                all(
                    type(pair) is dict
                    and set(pair) == {"common-lisp", "python"}
                    and pair["common-lisp"] != pair["python"]
                    for pair in differences.values()
                ),
                f"{request_id}: malformed hostile difference pair",
            )
            continue
        _require(item.get("kind") == "relation", f"{request_id}: kind drift")
        _require(
            type(differences) is dict and set(differences) == {"failure"},
            f"{item.get('request_id')}: more than companion failure differs",
        )
        pair = differences["failure"]
        _require(
            type(pair) is dict and set(pair) == {"common-lisp", "python"},
            f"{item.get('request_id')}: malformed failure pair",
        )
        left, right = pair["common-lisp"], pair["python"]
        _require(type(left) is dict and type(right) is dict, "failure comparison is not closed")
        _require(
            {key: value for key, value in left.items() if key != "path"}
            == {key: value for key, value in right.items() if key != "path"},
            f"{item.get('request_id')}: category/code/stage disagreement",
        )
        _require(left.get("path") != right.get("path"), f"{item.get('request_id')}: no path disagreement")

    return {
        "blocked_not_passed_or_na": {
            "exact_vector_results": sorted(BLOCKED_VECTOR_REQUESTS),
            "hostile_result_gaps": sorted(BLOCKED_HOSTILE_REQUESTS),
            "relation_companion_failure_paths": sorted(BLOCKED_RELATION_PATH_REQUESTS),
        },
        "common_lisp_unaffected_mismatches": 0,
        "python_unaffected_mismatches": 0,
        "observed_cross_relation_path_disagreements": sum(
            request_id in BLOCKED_RELATION_PATH_REQUESTS
            for request_id in cross_ids
        ),
        "observed_cross_hostile_blocker_disagreements": sum(
            request_id in BLOCKED_HOSTILE_REQUESTS for request_id in cross_ids
        ),
        "relation_path_blocker_count": len(BLOCKED_RELATION_PATH_REQUESTS),
        "vector_blocker_count": len(BLOCKED_VECTOR_REQUESTS),
        "hostile_blocker_count": len(BLOCKED_HOSTILE_REQUESTS),
    }


def _metadata_value(index: int) -> cd0.Datum:
    variants: tuple[cd0.Datum, ...] = (
        cd0.string(f"metadata-{index:03d}-é"),
        cd0.string(f"metadata-{index:03d}-e\u0301"),
        cd0.integer(index - 32),
        cd0.rational(index + 1, index + 2),
        cd0.byte_string(index.to_bytes(2, "big")),
        cd0.boolean(index % 2 == 0),
        cd0.identifier(PROPERTY_NAMESPACE, ("metadata", f"Case-{index:03d}")),
        cd0.sequence((cd0.integer(index), cd0.string("inert"))),
    )
    return variants[index % len(variants)]


def build_property_cases(seed: int, allocation_cases: int) -> list[PropertyCase]:
    _require(allocation_cases > 0, "property case count must be positive")
    rows = {row["vector_id"]: row for row in iter_vectors()}
    _require(len(rows) == 215, "fixture vector census drift")
    rng = random.Random(seed)
    cases: list[PropertyCase] = []

    # Record allocation/insertion order: the embedded vector is held exactly
    # fixed while every CD/0 record and leaf is independently reconstructed.
    base = _vector_datum(rows, "LCI0-P002")
    base_octets = canonical_bytes(base)
    for index in range(allocation_cases):
        allocated = _reallocate(base, rng)
        _require(canonical_bytes(allocated) == base_octets, "record allocation changed CD/0")
        cases.append(
            PropertyCase(
                f"allocation-{index:04d}", "record-allocation-order",
                rows["LCI0-P002"]["operation"], allocated, "success",
                equivalence_group="record-allocation-order",
            )
        )

    # Nonidentity metadata: alternate both frozen occurrences (which jointly
    # change every declared nonidentity field), then add one inert open-entry.
    occurrences = (fixture_datum("claim-occurrence.alpha"), fixture_datum("claim-occurrence.beta-metadata-different"))
    for index in range(allocation_cases):
        occurrence = occurrences[index % 2]
        metadata = _field(occurrence, "nonidentity-metadata")
        entries = _field(metadata, "entries")
        entries = _add_field(
            entries, f"seed-{seed:08x}-case-{index:04d}", _metadata_value(index),
            PROPERTY_NAMESPACE,
        )
        metadata = replace_record_field(metadata, "entries", entries)
        occurrence = replace_record_field(occurrence, "nonidentity-metadata", metadata)
        operation, datum = _custom_vector(
            rows, "LCI0-N015", "LCI0-PROPERTY-METADATA-NEUTRAL",
            _record({"occurrence": occurrence}),
        )
        cases.append(
            PropertyCase(
                f"metadata-{index:04d}", "metadata-neutrality", operation, datum,
                "success", equivalence_group="metadata-neutrality",
            )
        )

    # Each selected fixture differs from the neutral claim in proposition or a
    # named identity-bearing coordinate.  Projection must retain the difference.
    coordinate_claims = (
        "claim-id.file-alpha-neutral",
        "claim-id.file-beta-neutral",
        "claim-id.file-alpha-dept",
        "claim-id.file-alpha-yesterday",
        "claim-id.file-alpha-corpus-r3",
        "claim-id.file-alpha-corpus-r4-slice",
        "claim-id.file-alpha-animal",
        "claim-id.file-alpha-animal-imperial",
        "claim-id.file-alpha-animal-schema-v2",
    )
    for fixture_id in coordinate_claims:
        operation, datum = _custom_vector(
            rows, "LCI0-N007", "LCI0-PROPERTY-IDENTITY-COORDINATE",
            _record({"claim": _projection_core(fixture_datum(fixture_id))}),
        )
        cases.append(
            PropertyCase(
                f"coordinate-{fixture_id.removeprefix('claim-id.')}",
                "identity-coordinate", operation, datum, "success",
                distinct_group="identity-coordinate",
            )
        )

    # Unicode is not normalized.  NFC and NFD are separate exact claims.
    for form in ("nfc", "nfd"):
        operation, datum = _custom_vector(
            rows, "LCI0-N007", "LCI0-PROPERTY-UNICODE",
            _record({"claim": _projection_core(fixture_datum(f"claim-id.unicode-{form}"))}),
        )
        cases.append(
            PropertyCase(
                f"unicode-{form}", "unicode-nonnormalization", operation, datum,
                "success", distinct_group="unicode-nonnormalization",
            )
        )

    # Exact normalized rationals at and within the probability boundary.
    probability = fixture_datum("claim-id.probability-file-alpha")
    for numerator, denominator in ((0, 1), (1, 4), (1, 2), (3, 4), (1, 1)):
        claim, found = _replace_first_rational(
            probability, cd0.rational(numerator, denominator)
        )
        _require(found, "probability fixture lost its rational")
        operation, datum = _custom_vector(
            rows, "LCI0-N007", "LCI0-PROPERTY-RATIONAL-BOUNDARY",
            _record({"claim": _projection_core(claim)}),
        )
        cases.append(
            PropertyCase(
                f"rational-{numerator}-{denominator}", "rational-boundary",
                operation, datum, "success", distinct_group="rational-valid",
            )
        )

    # Identifier segmentation and case are preserved.  Structural fixture
    # schemes admit these exact object IDs under the registered domain prefix,
    # but they remain distinct stable identities.
    stable = fixture_datum("stable-ref.artifact.file.alpha")
    material = _field(stable, "material")
    object_id = _field(material, "object-id")
    _require(type(object_id) is cd0.Identifier, "stable object id is not identifier")
    mutations = (
        (*object_id.path[:-1], "Alpha.txt"),
        (*object_id.path[:-1], "ALPHA.TXT"),
        (*object_id.path[:-1], "alpha", "txt"),
        ("object", "artifact", "file.alpha.txt"),
    )
    for index, path in enumerate(mutations):
        changed_material = replace_record_field(
            material, "object-id", cd0.identifier(object_id.namespace, path)
        )
        reference = replace_record_field(stable, "material", changed_material)
        operation, datum = _custom_vector(
            rows, "LCI0-E7-ALIAS-01", "LCI0-PROPERTY-IDENTIFIER-VALID",
            _record({"reference": reference}),
        )
        cases.append(
            PropertyCase(
                f"identifier-valid-{index:02d}", "identifier-boundary",
                operation, datum, "success",
            )
        )
        bridge_payload = _field(
            _vector_datum(rows, "LCI0-E7-BRIDGE-ABSENT"), "payload"
        )
        bridge_payload = replace_record_field(
            bridge_payload, "left-reference", stable
        )
        bridge_payload = replace_record_field(
            bridge_payload, "right-reference", reference
        )
        operation, datum = _custom_vector(
            rows, "LCI0-E7-BRIDGE-ABSENT", "LCI0-PROPERTY-IDENTIFIER-BOUNDARY",
            bridge_payload,
        )
        cases.append(
            PropertyCase(
                f"identifier-boundary-{index:02d}", "identifier-boundary",
                operation, datum, "success",
                output_boolean=("structural-equality", False),
            )
        )

    # Every target schema is paired only with its declared target kind.  A
    # cyclic schema substitution and an unknown boundary field both fail closed.
    target_ids = (
        "warrant-target.observed.file-alpha.exact",
        "warrant-target.executed.call-17",
        "warrant-target.tested.universal-property.org",
        "warrant-target.derived.one-equals-one",
        "warrant-target.externally-attested.file-alpha.trusted",
        "warrant-target.replayed.file-alpha",
        "warrant-target.corpus-completion.absence-docs.complete",
        "warrant-target.reported.artifact-ready",
        "warrant-target.inherited.file-alpha",
        "warrant-target.translated.file-alpha-animal",
        "warrant-target.policy-evaluation.file-alpha.meta",
    )
    targets = [fixture_datum(fixture_id) for fixture_id in target_ids]
    for index, (fixture_id, target) in enumerate(zip(target_ids, targets)):
        wrong_schema = _field(targets[(index + 1) % len(targets)], "target-schema")
        changed = replace_record_field(target, "target-schema", wrong_schema)
        operation, datum = _custom_vector(
            rows, "LCI0-N017", "LCI0-PROPERTY-TARGET-SCHEMA",
            _record({"target": changed}),
        )
        cases.append(
            PropertyCase(
                f"target-schema-{index:02d}", "target-schema-boundary",
                operation, datum, "failure",
            )
        )
        boundaries = _add_field(
            _field(target, "boundaries"), "future-boundary", cd0.unit(),
            FIXTURE_FIELD,
        )
        changed = replace_record_field(target, "boundaries", boundaries)
        operation, datum = _custom_vector(
            rows, "LCI0-N017", "LCI0-PROPERTY-TARGET-UNKNOWN-BOUNDARY",
            _record({"target": changed}),
        )
        cases.append(
            PropertyCase(
                f"target-unknown-{index:02d}", "target-unknown-boundary",
                operation, datum, "failure", failure_code="TargetBoundaryUnknown",
            )
        )

    # E6: missing required fields precede unknown fields, independent of the
    # unknown key's canonical position or record construction order.
    claim = fixture_datum("claim-id.file-alpha-neutral")
    missing = _remove_field(claim, "identity-policy")
    for index in range(8):
        malformed = _add_field(
            missing, f"unknown-{7-index:02d}", _metadata_value(index),
            PROPERTY_NAMESPACE + (("z" if index % 2 else "a"),),
        )
        malformed = _reallocate(malformed, rng)
        operation, datum = _custom_vector(
            rows, "LCI0-N001", "LCI0-PROPERTY-E6-MISSING-BEFORE-UNKNOWN",
            _record({"claim": malformed}),
        )
        cases.append(
            PropertyCase(
                f"e6-order-{index:02d}", "e6-failure-order", operation, datum,
                "failure", failure_code="MissingRequiredField",
                failure_stage="claim-shape", failure_path=("identity-policy",),
            )
        )

    # Every operation-specific payload is closed.  The frozen package does not
    # pin a complete failure tuple for these novel malformed wrappers, so this
    # phase asserts only the authorized fail-closed codes plus process and
    # cross-language stability; the authorial-return packet retains the tuple
    # coverage boundary.
    operation_templates: dict[str, str] = {}
    for vector_id, row in rows.items():
        operation_templates.setdefault(row["operation"], vector_id)
    _require(len(operation_templates) == 52, "fixture operation census drift")
    for operation_name, template_id in sorted(operation_templates.items()):
        source = _vector_datum(rows, template_id)
        payload = _field(source, "payload")
        _require(type(payload) is cd0.Record, f"{template_id}: payload is not record")
        unknown_payload = _add_field(
            payload,
            "future-operation-payload-field",
            cd0.unit(),
            PROPERTY_NAMESPACE,
        )
        operation, datum = _custom_vector(
            rows,
            template_id,
            f"LCI0-PROPERTY-PAYLOAD-UNKNOWN-{operation_name}",
            unknown_payload,
        )
        cases.append(
            PropertyCase(
                f"payload-unknown-{operation_name}",
                "operation-payload-closure",
                operation,
                datum,
                "failure",
                failure_code="UnknownField",
                authorial_blocked_failure_coordinates=(
                    "category", "stage", "path", "context"
                ),
            )
        )
        operation, datum = _custom_vector(
            rows,
            template_id,
            f"LCI0-PROPERTY-PAYLOAD-MISSING-{operation_name}",
            _record({}),
        )
        cases.append(
            PropertyCase(
                f"payload-missing-{operation_name}",
                "operation-payload-closure",
                operation,
                datum,
                "failure",
                failure_code="MissingRequiredField",
                authorial_blocked_failure_coordinates=(
                    "category", "stage", "path", "context"
                ),
            )
        )

    # Vector dispatch must invoke the same proposition/location validator used
    # by projection.  N014 pins the exact failure tuple for this disagreement.
    placement = _vector_datum(rows, "LCI0-PLACEMENT-LOG-HORIZON-POS")
    placement_payload = _field(placement, "payload")
    placement_location = _field(placement_payload, "location")
    neutral_location = _field(fixture_datum("claim-id.file-alpha-neutral"), "location")
    bad_location = replace_record_field(
        placement_location,
        "basis",
        _field(neutral_location, "basis"),
    )
    operation, datum = _custom_vector(
        rows,
        "LCI0-PLACEMENT-LOG-HORIZON-POS",
        "LCI0-PROPERTY-PLACEMENT-DISPATCH-VALIDATION",
        replace_record_field(placement_payload, "location", bad_location),
    )
    cases.append(
        PropertyCase(
            "placement-dispatch-validation",
            "semantic-dispatch-validation",
            operation,
            datum,
            "failure",
            failure_code="PropositionLocationInconsistent",
            failure_stage="basis",
            failure_path=("location", "basis"),
        )
    )

    # Occurrence dispatch likewise invokes recursive occurrence validation;
    # malformed claimant data must never be reported as valid.
    occurrence_template = _vector_datum(rows, "LCI0-METADATA-UNKNOWN-TOP-CLOSED")
    occurrence_payload = _field(occurrence_template, "payload")
    bad_occurrence = replace_record_field(
        fixture_datum("claim-occurrence.alpha"), "claimant", cd0.unit()
    )
    operation, datum = _custom_vector(
        rows,
        "LCI0-METADATA-UNKNOWN-TOP-CLOSED",
        "LCI0-PROPERTY-OCCURRENCE-DISPATCH-VALIDATION",
        replace_record_field(occurrence_payload, "occurrence", bad_occurrence),
    )
    cases.append(
        PropertyCase(
            "occurrence-dispatch-validation",
            "semantic-dispatch-validation",
            operation,
            datum,
            "failure",
        )
    )

    # Policy-evaluation is accepted by Policy-B only as limited meta-testimony;
    # it never becomes direct support.  Policy-A rejects the target kind.
    policy_template = _vector_datum(rows, "LCI0-P022")
    policy_payload = _field(policy_template, "payload")
    meta_target = fixture_datum("warrant-target.policy-evaluation.file-alpha.meta")
    meta_payload = replace_record_field(policy_payload, "target", meta_target)
    meta_payload = replace_record_field(meta_payload, "claim", _field(meta_target, "claim"))
    operation, datum = _custom_vector(
        rows,
        "LCI0-P022",
        "LCI0-PROPERTY-POLICY-META-TESTIMONY",
        meta_payload,
    )
    cases.append(
        PropertyCase(
            "policy-meta-testimony",
            "policy-meta-testimony",
            operation,
            datum,
            "success",
            output_identifiers=(
                (
                    ("policy-a-decision", "decision"),
                    FIXTURE,
                    ("admissibility-decision", "reject-target-kind"),
                ),
                (
                    ("policy-b-decision", "decision"),
                    FIXTURE,
                    ("admissibility-decision", "accept-limited-testimony"),
                ),
                (
                    ("policy-b-decision", "testimony-class"),
                    FIXTURE,
                    ("testimony-class", "limited-testimony"),
                ),
            ),
            authorial_blocked_result_coordinates=(
                "outputs/policy-b-decision/reasons",
            ),
        )
    )

    # Anti-shortcut twins reverse four negative/split official witnesses while
    # retaining their exact operation schemas.  Implementations must derive
    # the result from the supplied values rather than memorize a vector outcome.
    normalization = _vector_datum(rows, "LCI0-E4-STRUCTURAL-SUBJECT-TIME")
    normalization_payload = _field(normalization, "payload")
    normalization_payload = replace_record_field(
        normalization_payload,
        "right",
        _field(normalization_payload, "left"),
    )
    operation, datum = _custom_vector(
        rows,
        "LCI0-E4-STRUCTURAL-SUBJECT-TIME",
        "LCI0-PROPERTY-NORMALIZATION-EQUAL-INPUT",
        normalization_payload,
    )
    cases.append(
        PropertyCase(
            "normalization-equal-input",
            "semantic-anti-shortcut",
            operation,
            datum,
            "success",
            output_boolean=("claim-id-merge-permitted", True),
        )
    )

    digest_comparison = _vector_datum(rows, "LCI0-E8-DIGEST-NOT-ENVELOPE")
    digest_payload = _field(digest_comparison, "payload")
    digest_payload = replace_record_field(
        digest_payload,
        "right-claim-id",
        _field(digest_payload, "left-claim-id"),
    )
    operation, datum = _custom_vector(
        rows,
        "LCI0-E8-DIGEST-NOT-ENVELOPE",
        "LCI0-PROPERTY-EQUAL-CLAIM-ID-ENVELOPES",
        digest_payload,
    )
    cases.append(
        PropertyCase(
            "equal-claim-id-envelopes",
            "semantic-anti-shortcut",
            operation,
            datum,
            "success",
            output_boolean=("semantic-claim-id-equal", True),
        )
    )

    # Bounded non-evaluating legacy grammar: mutate only source bytes inside a
    # complete frozen LegacySourceFixture/0 record.
    legacy = fixture_datum("legacy-source.hostile-read-eval")
    forbidden = (b"#.", b"#1=(x . #1#)", b"'x", b"`(,x)", b"(a . b)", b";comment\n(x)", b"#(x)", b"(x) trailing")
    for index, source_bytes in enumerate(forbidden):
        source = replace_record_field(legacy, "source-bytes", cd0.byte_string(source_bytes))
        operation, datum = _custom_vector(
            rows, "LCI0-E9-HOSTILE-READ-EVAL", "LCI0-PROPERTY-LEGACY-GRAMMAR",
            _record({"source": source}),
        )
        cases.append(
            PropertyCase(
                f"migration-grammar-{index:02d}", "migration-grammar", operation,
                datum, "failure", failure_code="UnsupportedLegacyForm",
                failure_stage="migration-source",
                failure_path=("fixture-field:source-bytes",),
            )
        )

    operation, datum = _custom_vector(
        rows, "LCI0-E9-INERT-PREDECESSOR", "LCI0-PROPERTY-MIGRATION-INERT",
        _record({"source": fixture_datum("legacy-source.inert-predecessor-warrant")}),
    )
    cases.append(
        PropertyCase(
            "migration-inert", "migration-inertness", operation, datum, "success",
            output_boolean=("live-warrants-created", False),
        )
    )

    # Source artifacts are explicit provenance.  A valid replacement must be
    # retained in the MigrationResult's top-level source without changing the
    # reconstructed ClaimId or consulting a fixture-name/revision oracle.  The
    # P029 packet keeps lineage-source behavior authorial-return-bound.
    migration_source = fixture_datum("legacy-source.time-100")
    migration_source_v2 = replace_record_field(
        migration_source,
        "source-artifact",
        fixture_datum("stable-ref.artifact.source.v1.2"),
    )
    for suffix, source in (("v1-1", migration_source), ("v1-2", migration_source_v2)):
        operation, datum = _custom_vector(
            rows,
            "LCI0-E9-INERT-PREDECESSOR",
            "LCI0-PROPERTY-MIGRATION-SOURCE-PROVENANCE",
            _record({"source": source}),
        )
        cases.append(
            PropertyCase(
                f"migration-source-{suffix}",
                "migration-source-provenance",
                operation,
                datum,
                "success",
            )
        )
    operation, datum = _custom_vector(
        rows, "LCI0-E9-LIVE-RESTORATION", "LCI0-PROPERTY-LIVE-RESTORATION",
        _record({"source": fixture_datum("legacy-source.attempt-live-restoration")}),
    )
    cases.append(
        PropertyCase(
            "migration-live-restoration", "migration-inertness", operation, datum,
            "failure", failure_code="PrivilegedRestorationAttempt",
            failure_stage="privilege-boundary",
            failure_path=(
                "fixture-field:parsed-inert-value",
                "fixture-field:attempt-live-restoration",
            ),
        )
    )

    # All 13 exact over-limit vectors, plus generated inclusive-limit twins.
    for number in range(1, 14):
        vector_id = f"LCI0-RESOURCE-{number:02d}"
        source = _vector_datum(rows, vector_id)
        payload = _field(source, "payload")
        workload = _field(payload, "workload")
        requested = _field(workload, "requested")
        _require(type(requested) is cd0.Integer and requested.value > 0, f"{vector_id}: requested")
        limit_workload = replace_record_field(workload, "requested", cd0.integer(requested.value - 1))
        limit_payload = replace_record_field(payload, "workload", limit_workload)
        operation, datum = _custom_vector(
            rows, vector_id, f"LCI0-PROPERTY-RESOURCE-{number:02d}-AT-LIMIT",
            limit_payload,
        )
        cases.append(
            PropertyCase(
                f"resource-{number:02d}-at-limit", "resource-boundary", operation,
                datum, "success", output_boolean=("within-budget", True),
                authorial_blocked_result_coordinates=(
                    "outputs/requested", "outputs/resource"
                ),
            )
        )
        # Exact over-limit fixture retained under a stable embedded vector id.
        cases.append(
            PropertyCase(
                f"resource-{number:02d}-over-limit", "resource-boundary",
                rows[vector_id]["operation"], source, "failure",
            )
        )

    ids = [case.case_id for case in cases]
    _require(len(ids) == len(set(ids)), "duplicate property case ID")
    _require(
        sum(bool(case.authorial_blocked_failure_coordinates) for case in cases)
        == 104,
        "operation-payload blocker census drift",
    )
    return cases


def _semantic_view(response: Mapping[str, Any]) -> dict[str, Any]:
    return {
        name: response.get(name)
        for name in (
            "protocol_status",
            "input_reencoded_canonical_hex",
            "semantic_status",
            "actual_canonical_cd0_hex",
            "relation",
            "failure",
            "protocol_failure",
        )
        if name in response
    }


def _semantic_view_for_case(
    response: Mapping[str, Any], case: PropertyCase
) -> dict[str, Any]:
    view = _semantic_view(response)
    blocked = set(case.authorial_blocked_failure_coordinates)
    failure = view.get("failure")
    if blocked and type(failure) is dict:
        view["failure"] = {
            name: value for name, value in failure.items() if name not in blocked
        }
        # The canonical result document embeds the full failure tuple, so it is
        # likewise not comparable while any of those coordinates are blocked.
        view.pop("actual_canonical_cd0_hex", None)
    if case.authorial_blocked_result_coordinates:
        # Generated cases assert only their explicitly declared output
        # predicates while the package leaves the remaining result coordinates
        # open.  Preserve the full documents as blocked observations, but do
        # not let either implementation become an oracle for those bytes.
        view.pop("actual_canonical_cd0_hex", None)
    return view


def _case_input_roundtrips(case: PropertyCase, response: Mapping[str, Any]) -> bool:
    return response.get("input_reencoded_canonical_hex") == canonical_bytes(
        case.datum
    ).hex()


def _direct_field(record: cd0.Datum, name: str) -> cd0.Datum | None:
    if type(record) is not cd0.Record:
        return None
    matches = [
        value
        for key, value in record.fields
        if key.namespace == FIXTURE_FIELD and key.path == (name,)
    ]
    return matches[0] if len(matches) == 1 else None


def _result_output_boolean(actual_hex: str, name: str) -> bool:
    datum = cd0.decode_exact(bytes.fromhex(actual_hex), CD0_BUDGET)
    outputs = _direct_field(datum, "outputs")
    value = _direct_field(outputs, name) if outputs is not None else None
    _require(type(value) is cd0.Boolean, f"result output {name} is not Boolean")
    return value.value


def _result_output_datum(actual_hex: str, name: str) -> cd0.Datum:
    datum = cd0.decode_exact(bytes.fromhex(actual_hex), CD0_BUDGET)
    outputs = _direct_field(datum, "outputs")
    value = _direct_field(outputs, name) if outputs is not None else None
    _require(value is not None, f"result output {name} is absent")
    return value


def _result_output_path(actual_hex: str, path: tuple[str, ...]) -> cd0.Datum:
    _require(path, "result output path is empty")
    value = _result_output_datum(actual_hex, path[0])
    for name in path[1:]:
        value = _direct_field(value, name)
        _require(value is not None, f"result output path component absent: {name}")
    return value


def _result_output_identifier_matches(
    actual_hex: str,
    output_path: tuple[str, ...],
    expected_namespace: tuple[str, ...],
    expected_path: tuple[str, ...],
) -> bool:
    try:
        value = _result_output_path(actual_hex, output_path)
    except (EvidenceFailure, ValueError, cd0.CD0Failure):
        return False
    return bool(
        type(value) is cd0.Identifier
        and value.namespace == expected_namespace
        and value.path == expected_path
    )


def compare_property_results(
    cases: Sequence[PropertyCase],
    implementation_runs: Mapping[str, Mapping[str, Mapping[str, Any]]],
) -> dict[str, Any]:
    _require("common-lisp/baseline" in implementation_runs, "missing Common Lisp baseline")
    _require("python/hash-0-locale-C" in implementation_runs, "missing Python baseline")
    reference_names = ("common-lisp/baseline", "python/hash-0-locale-C")
    failures: list[dict[str, Any]] = []
    counts = Counter()
    blocked_observations: list[dict[str, Any]] = []
    blocked_result_observations: list[dict[str, Any]] = []

    for case in cases:
        request_id = f"property:{case.case_id}"
        reference_views = []
        for name, responses in implementation_runs.items():
            response = responses.get(request_id)
            if response is None:
                failures.append({"case_id": case.case_id, "run": name, "reason": "missing-response"})
                continue
            view = _semantic_view_for_case(response, case)
            counts[f"{name}:cases"] += 1
            if case.authorial_blocked_failure_coordinates:
                counts[f"{name}:authorial-blocked-cases"] += 1
            if case.authorial_blocked_result_coordinates:
                counts[f"{name}:authorial-blocked-result-cases"] += 1
            if response.get("protocol_status") != "success":
                failures.append({"case_id": case.case_id, "run": name, "reason": "protocol-failure", "view": view})
                continue
            if not _case_input_roundtrips(case, response):
                failures.append(
                    {
                        "case_id": case.case_id,
                        "run": name,
                        "reason": "input-reencoding",
                        "expected_sha256": _sha256(canonical_bytes(case.datum)),
                        "observed_sha256": (
                            _sha256(bytes.fromhex(response["input_reencoded_canonical_hex"]))
                            if type(response.get("input_reencoded_canonical_hex")) is str
                            else None
                        ),
                    }
                )
                continue
            if response.get("semantic_status") != case.expected_status:
                failures.append({"case_id": case.case_id, "run": name, "reason": "status", "expected": case.expected_status, "view": view})
                continue
            failure = response.get("failure")
            for field, expected in (
                ("code", case.failure_code),
                ("stage", case.failure_stage),
                ("path", list(case.failure_path) if case.failure_path else None),
            ):
                if expected is not None and (not isinstance(failure, dict) or failure.get(field) != expected):
                    failures.append({"case_id": case.case_id, "run": name, "reason": f"failure-{field}", "expected": expected, "view": view})
            if case.output_boolean is not None and case.expected_status == "success":
                actual = response.get("actual_canonical_cd0_hex")
                try:
                    observed = _result_output_boolean(actual, case.output_boolean[0]) if isinstance(actual, str) else None
                except Exception as exc:  # converted to evidence, not host prose comparison
                    observed = f"decode-error:{type(exc).__name__}"
                if observed != case.output_boolean[1]:
                    failures.append({"case_id": case.case_id, "run": name, "reason": "output-boolean", "expected": case.output_boolean, "observed": observed})
            if case.output_identifiers and case.expected_status == "success":
                actual = response.get("actual_canonical_cd0_hex")
                for output_path, expected_namespace, expected_path in case.output_identifiers:
                    matches = bool(
                        isinstance(actual, str)
                        and _result_output_identifier_matches(
                            actual,
                            output_path,
                            expected_namespace,
                            expected_path,
                        )
                    )
                    if not matches:
                        failures.append(
                            {
                                "case_id": case.case_id,
                                "run": name,
                                "reason": "output-identifier",
                                "output_path": list(output_path),
                                "expected": [
                                    list(expected_namespace), list(expected_path)
                                ],
                                "observed_matches_exact_identity": False,
                            }
                        )
            if name in reference_names:
                reference_views.append((name, view))
                if case.authorial_blocked_failure_coordinates:
                    blocked_observations.append(
                        {
                            "case_id": case.case_id,
                            "implementation": name,
                            "blocked_coordinates": list(
                                case.authorial_blocked_failure_coordinates
                            ),
                            "observed_failure": response.get("failure"),
                        }
                    )
                if case.authorial_blocked_result_coordinates:
                    actual = response.get("actual_canonical_cd0_hex")
                    blocked_result_observations.append(
                        {
                            "case_id": case.case_id,
                            "implementation": name,
                            "blocked_coordinates": list(
                                case.authorial_blocked_result_coordinates
                            ),
                            "observed_result_sha256": (
                                _sha256(bytes.fromhex(actual))
                                if type(actual) is str
                                else None
                            ),
                        }
                    )
        if len(reference_views) == 2 and reference_views[0][1] != reference_views[1][1]:
            failures.append({"case_id": case.case_id, "reason": "cross-implementation", "views": dict(reference_views)})

    # Every perturbed process must equal its own language baseline and the
    # symmetric cross-language result for every generated input.
    baselines = {
        "common-lisp": implementation_runs["common-lisp/baseline"],
        "python": implementation_runs["python/hash-0-locale-C"],
    }
    for run_name, responses in implementation_runs.items():
        language = run_name.split("/", 1)[0]
        baseline = baselines[language]
        for request_id, response in responses.items():
            if _semantic_view(response) != _semantic_view(baseline[request_id]):
                failures.append({"request_id": request_id, "run": run_name, "reason": "host-perturbation", "baseline": _semantic_view(baseline[request_id]), "observed": _semantic_view(response)})

    # Metamorphic group checks use canonical result documents, not a language.
    python_reference = implementation_runs["python/hash-0-locale-C"]
    equal_groups: dict[str, list[str]] = {}
    distinct_groups: dict[str, list[str]] = {}
    for case in cases:
        actual = python_reference[f"property:{case.case_id}"].get("actual_canonical_cd0_hex")
        if case.equivalence_group:
            equal_groups.setdefault(case.equivalence_group, []).append(actual)
        if case.distinct_group:
            distinct_groups.setdefault(case.distinct_group, []).append(actual)
    for name, values in equal_groups.items():
        if any(type(value) is not str for value in values) or len(set(values)) != 1:
            failures.append({"group": name, "reason": "metamorphic-not-equal", "unique": len(set(map(str, values)))})
    for name, values in distinct_groups.items():
        if any(type(value) is not str for value in values) or len(set(values)) != len(values):
            failures.append({"group": name, "reason": "metamorphic-not-distinct", "cases": len(values), "unique": len(set(map(str, values)))})

    # Preserve explicit migration provenance while proving that it is not a
    # reconstructed semantic ClaimId coordinate.
    migration_cases = [
        case for case in cases if case.family == "migration-source-provenance"
    ]
    _require(len(migration_cases) == 2, "migration source provenance pair missing")
    for run_name, responses in implementation_runs.items():
        claim_ids: list[bytes] = []
        result_sources: list[bytes] = []
        for case in migration_cases:
            response = responses[f"property:{case.case_id}"]
            actual_hex = response.get("actual_canonical_cd0_hex")
            try:
                _require(type(actual_hex) is str, "migration result document absent")
                result = _result_output_datum(actual_hex, "migration-result")
                result_source = _field(result, "source")
                claim_id = _field(result, "claim-id")
                wrapper = _field(_field(case.datum, "payload"), "source")
                explicit_source = _field(wrapper, "source-artifact")
                _require(result_source is not None, "migration result source absent")
                _require(claim_id is not None, "migration result ClaimId absent")
                if canonical_bytes(result_source) != canonical_bytes(explicit_source):
                    failures.append(
                        {
                            "case_id": case.case_id,
                            "run": run_name,
                            "reason": "migration-source-not-propagated",
                        }
                    )
                claim_ids.append(canonical_bytes(claim_id))
                result_sources.append(canonical_bytes(result_source))
            except Exception as exc:  # record host type, never prose
                failures.append(
                    {
                        "case_id": case.case_id,
                        "run": run_name,
                        "reason": "migration-provenance-decode",
                        "exception_type": type(exc).__name__,
                    }
                )
        if len(claim_ids) == 2 and len(set(claim_ids)) != 1:
            failures.append(
                {
                    "family": "migration-source-provenance",
                    "run": run_name,
                    "reason": "source-artifact-changed-claim-id",
                }
            )
        if len(result_sources) == 2 and len(set(result_sources)) != 2:
            failures.append(
                {
                    "family": "migration-source-provenance",
                    "run": run_name,
                    "reason": "distinct-source-artifacts-collapsed",
                }
            )

    return {
        "authorial_blocked_failure_coordinates": {
            "case_count": len(
                {
                    item["case_id"] for item in blocked_observations
                }
            ),
            "observations": blocked_observations,
            "status": "blocked-not-pass-skip-or-na",
        },
        "authorial_blocked_result_coordinates": {
            "case_count": len(
                {
                    item["case_id"] for item in blocked_result_observations
                }
            ),
            "observations": blocked_result_observations,
            "status": "blocked-not-pass-skip-or-na",
        },
        "counts": dict(sorted(counts.items())),
        "failures": failures,
        "metamorphic_equal_groups": {name: len(values) for name, values in sorted(equal_groups.items())},
        "metamorphic_distinct_groups": {name: len(values) for name, values in sorted(distinct_groups.items())},
        "status": (
            "converged-unaffected-with-authorial-blockers"
            if not failures
            else "fail"
        ),
    }


def _selected_environment(environment: Mapping[str, str]) -> dict[str, str]:
    names = (
        "LC_ALL", "LANG", "PYTHONHASHSEED", "LCI0_HOST_PROFILE",
        "LCI0_NETWORK_MODE", "LCI0_FILESYSTEM_MODE", "LCI0_WALL_CLOCK_MARKER",
        "LCI0_RUNTIME_STATE_MARKER", "LCI0_PROPERTY_CASES", "LCI0_PROPERTY_SEED",
        "LCI0_FIXTURE_DIR", "LCI0_FIXTURE_ROOT", "PYTHONPATH",
    )
    return {name: environment[name] for name in names if name in environment}


def _run_command(
    *,
    label: str,
    command: Sequence[str],
    environment: Mapping[str, str],
    cwd: Path,
    output_directory: Path,
    stdin: bytes = b"",
    require_success: bool = True,
) -> tuple[subprocess.CompletedProcess[bytes], dict[str, Any]]:
    process = subprocess.run(
        list(command), input=stdin, stdout=subprocess.PIPE, stderr=subprocess.PIPE,
        cwd=cwd, env=dict(environment), check=False,
    )
    if label.startswith("adapter-"):
        stdout_name = f"{label}.responses.jsonl"
        stderr_name = f"{label}.stderr.txt"
    else:
        stdout_name = f"{label}.stdout.txt"
        stderr_name = f"{label}.stderr.txt"
    (output_directory / stdout_name).write_bytes(process.stdout)
    (output_directory / stderr_name).write_bytes(process.stderr)
    record = {
        "argv": list(command),
        "cwd": str(cwd),
        "environment": _selected_environment(environment),
        "exit_code": process.returncode,
        "label": label,
        "stderr": {"file": stderr_name, "bytes": len(process.stderr), "sha256": _sha256(process.stderr)},
        "stdin": {"bytes": len(stdin), "sha256": _sha256(stdin)},
        "stdout": {"file": stdout_name, "bytes": len(process.stdout), "sha256": _sha256(process.stdout)},
    }
    if require_success:
        _require(process.returncode == 0, f"command failed: {label} ({process.returncode})")
    return process, record


def _parse_responses(
    payload: bytes,
    expectations: Mapping[str, Mapping[str, str]],
    label: str,
    implementation: str,
) -> dict[str, dict[str, Any]]:
    responses: dict[str, dict[str, Any]] = {}
    try:
        lines = payload.decode("utf-8").splitlines()
    except UnicodeDecodeError as exc:
        raise EvidenceFailure(f"{label}: response is not UTF-8") from exc
    for line_number, line in enumerate(lines, 1):
        try:
            response = loads_closed_json(line)
        except (json.JSONDecodeError, ValueError) as exc:
            raise EvidenceFailure(f"{label}:{line_number}: invalid JSON") from exc
        request_id = response.get("request_id")
        _require(type(request_id) is str and request_id, f"{label}:{line_number}: request id")
        _require(request_id not in responses, f"{label}: duplicate response {request_id}")
        expectation = expectations.get(request_id)
        _require(expectation is not None, f"{label}: unexpected response {request_id}")
        valid, reason = validate_response(
            response,
            implementation=implementation,
            request_id=request_id,
            operation=expectation["operation"],
            shape="fixture-operation",
            expected_vector_id=expectation["vector_id"],
        )
        _require(valid, f"{label}:{request_id}: response schema: {reason}")
        _require(
            canonical_report_matches(response),
            f"{label}:{request_id}: canonical result/report mismatch",
        )
        responses[request_id] = response
    _require(set(responses) == set(expectations), f"{label}: response ID set mismatch")
    return responses


def _write_manifest(output_directory: Path) -> None:
    files: dict[str, dict[str, Any]] = {}
    for path in sorted(output_directory.rglob("*")):
        if path.is_file() and path.name != "sha256-manifest.json":
            payload = path.read_bytes()
            files[str(path.relative_to(output_directory))] = {
                "bytes": len(payload), "sha256": _sha256(payload)
            }
    value = {
        "algorithm": "SHA-256",
        "manifest_excludes_itself": True,
        "members": files,
    }
    (output_directory / "sha256-manifest.json").write_bytes(_json_bytes(value, pretty=True))


def _git_value(root: Path, *arguments: str) -> str:
    process = subprocess.run(
        ["git", *arguments], cwd=root, stdout=subprocess.PIPE,
        stderr=subprocess.PIPE, check=False, text=True,
    )
    _require(process.returncode == 0, f"git {' '.join(arguments)} failed")
    return process.stdout.strip()


def _fixture_root_receipt() -> tuple[Path, dict[str, Any]]:
    # The independently seeded Common Lisp registry freezes this extraction
    # location.  The harness records and verifies it rather than pretending an
    # environment override can redirect that immutable seed implementation.
    root = Path("/tmp/lci0-seed-fixtures-20260714").resolve()
    expected = {
        "LCI0-FIXTURE-REGISTRY.json": REGISTRY_SHA256,
        "LCI0-FIXTURE-VECTORS.jsonl": VECTORS_SHA256,
    }
    members: dict[str, Any] = {}
    for name, digest in expected.items():
        path = root / name
        _require(path.is_file(), f"fixture root member missing: {path}")
        payload = path.read_bytes()
        observed = _sha256(payload)
        _require(observed == digest, f"fixture root identity mismatch: {name}")
        members[name] = {"bytes": len(payload), "sha256": observed}
    return root, {"members": members, "path": str(root)}


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--successor-artifacts", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--seed", type=int, default=PROPERTY_SEED)
    parser.add_argument("--allocation-cases", type=int, default=PROPERTY_CASES)
    arguments = parser.parse_args()

    # Refusal occurs before output-directory creation.
    successor, successor_artifact_receipt = replay_successor_artifacts(
        arguments.successor_artifacts
    )
    successor_path = arguments.successor_artifacts.resolve() / "summary.json"
    successor_payload = successor_path.read_bytes()
    gate = verify_successor_gate(successor)
    fixture_root, fixture_receipt = _fixture_root_receipt()

    root = Path(__file__).resolve().parents[3]
    output = arguments.output.resolve()
    _require(not output.exists(), f"output already exists: {output}")
    output.mkdir(parents=True)

    cases = build_property_cases(arguments.seed, arguments.allocation_cases)
    case_rows = [case.manifest_row() for case in cases]
    (output / "cases.json").write_bytes(_json_bytes(case_rows, pretty=True))
    requests = [
        request(
            f"property:{case.case_id}", case.operation,
            canonical_bytes(case.datum).hex(),
        )
        for case in cases
    ]
    request_payload = b"".join(_json_bytes(item) for item in requests)
    (output / "requests.jsonl").write_bytes(request_payload)
    response_expectations = {
        f"property:{case.case_id}": {
            "operation": case.operation,
            "vector_id": _field(case.datum, "vector-id").value,
        }
        for case in cases
    }

    python_path = os.pathsep.join(
        (
            str(root / "mneme/lci0/differential"),
            str(root / "mneme/lci0/python"),
            str(root / "canonical-datum/python"),
        )
    )
    base_environment = dict(os.environ)
    base_environment.update(
        {
            "PYTHONPATH": python_path,
            "LCI0_NETWORK_MODE": "unavailable-safe-marker",
            "LCI0_FILESYSTEM_MODE": "unavailable-during-native-projection",
            "LCI0_WALL_CLOCK_MARKER": "4294967295",
            "LCI0_RUNTIME_STATE_MARKER": "fixture-runtime-state-b",
            "LCI0_PROPERTY_CASES": str(arguments.allocation_cases),
            "LCI0_PROPERTY_SEED": str(arguments.seed),
            "LCI0_FIXTURE_DIR": str(fixture_root),
            "LCI0_FIXTURE_ROOT": str(fixture_root),
        }
    )
    python_command = [sys.executable, str(root / "mneme/lci0/differential/python_adapter.py")]
    common_lisp_command = ["sbcl", "--noinform", "--disable-debugger", "--script", str(root / "mneme/lci0/differential/common_lisp_adapter.lisp")]
    transcript: list[dict[str, Any]] = []
    implementation_runs: dict[str, dict[str, dict[str, Any]]] = {}

    runtime_results: dict[str, str] = {}
    for label, command in (
        ("runtime-sbcl-version", ["sbcl", "--version"]),
        ("runtime-locale-list", ["locale", "-a"]),
    ):
        process, record = _run_command(
            label=label, command=command, environment=base_environment, cwd=root,
            output_directory=output,
        )
        transcript.append(record)
        runtime_results[label] = process.stdout.decode("utf-8").strip()

    adapter_profiles = (
        ("common-lisp/baseline", "adapter-cl-baseline", common_lisp_command, {}),
        ("common-lisp/ambient-markers", "adapter-cl-ambient-markers", common_lisp_command, {"LC_ALL": "C", "LANG": "C", "LCI0_HOST_PROFILE": "unavailable-io-clock"}),
        ("python/hash-0-locale-C", "adapter-py-hash-0-locale-C", python_command, {"PYTHONHASHSEED": "0", "LC_ALL": "C", "LANG": "C"}),
        ("python/hash-1-locale-C", "adapter-py-hash-1-locale-C", python_command, {"PYTHONHASHSEED": "1", "LC_ALL": "C", "LANG": "C"}),
        ("python/hash-42-locale-C.utf8", "adapter-py-hash-42-locale-C.utf8", python_command, {"PYTHONHASHSEED": "42", "LC_ALL": "C.utf8", "LANG": "C.utf8"}),
        ("python/hash-4294967295-locale-POSIX", "adapter-py-hash-max-locale-POSIX", python_command, {"PYTHONHASHSEED": "4294967295", "LC_ALL": "POSIX", "LANG": "POSIX"}),
    )
    for run_name, label, command, changes in adapter_profiles:
        environment = dict(base_environment)
        environment.update(changes)
        process, record = _run_command(
            label=label, command=command, environment=environment, cwd=root,
            output_directory=output, stdin=request_payload,
        )
        transcript.append(record)
        implementation_runs[run_name] = _parse_responses(
            process.stdout,
            response_expectations,
            label,
            run_name.split("/", 1)[0],
        )

    comparison = compare_property_results(cases, implementation_runs)

    # Language-native probes cover host values that canonical input erases.
    python_probe_command = [
        sys.executable, str(root / "mneme/lci0/differential/python_host_probe.py"),
        "--seed", str(arguments.seed), "--cases", str(arguments.allocation_cases),
    ]
    native_probe_results: dict[str, Any] = {}
    for index, (hash_seed, locale_name) in enumerate(
        (("0", "C"), ("1", "C"), ("42", "C.utf8"), ("4294967295", "POSIX"))
    ):
        environment = dict(base_environment)
        environment.update({"PYTHONHASHSEED": hash_seed, "LC_ALL": locale_name, "LANG": locale_name, "LCI0_HOST_PROFILE": f"python-{index}"})
        label = f"native-python-{index}"
        process, record = _run_command(
            label=label, command=python_probe_command, environment=environment,
            cwd=root, output_directory=output,
        )
        transcript.append(record)
        native_probe_results[label] = loads_closed_json(process.stdout)

    common_lisp_probe = ["sbcl", "--noinform", "--disable-debugger", "--script", str(root / "mneme/lci0/differential/common_lisp_host_probe.lisp")]
    for profile in ("baseline", "package", "printer", "readtable", "hash-insertion", "unavailable-io-clock"):
        environment = dict(base_environment)
        environment.update({"LC_ALL": "C", "LANG": "C", "LCI0_HOST_PROFILE": profile})
        label = f"native-common-lisp-{profile}"
        process, record = _run_command(
            label=label, command=common_lisp_probe, environment=environment,
            cwd=root, output_directory=output,
        )
        transcript.append(record)
        native_probe_results[label] = loads_closed_json(process.stdout)

    py_hashes = {value["projection_sha256"] for key, value in native_probe_results.items() if key.startswith("native-python-")}
    cl_values = {value["projection_canonical_hex"] for key, value in native_probe_results.items() if key.startswith("native-common-lisp-")}
    if len(py_hashes) != 1:
        comparison["failures"].append(
            {"family": "native-host", "reason": "python-profile-projection-drift", "observed": sorted(py_hashes)}
        )
    if len(cl_values) != 1:
        comparison["failures"].append(
            {"family": "native-host", "reason": "common-lisp-profile-projection-drift", "observed_count": len(cl_values)}
        )
    cl_hashes = {_sha256(bytes.fromhex(value)) for value in cl_values}
    if cl_hashes != py_hashes:
        comparison["failures"].append(
            {"family": "native-host", "reason": "cross-language-projection-drift", "common_lisp": sorted(cl_hashes), "python": sorted(py_hashes)}
        )
    expected_rational_adapter = [
        "accepted",
        "NoncanonicalFixtureRational",
        "NoncanonicalFixtureRational",
        "NoncanonicalFixtureRational",
        "NoncanonicalFixtureRational",
    ]
    for label, value in native_probe_results.items():
        if value.get("rational_adapter_results") != expected_rational_adapter:
            comparison["failures"].append(
                {
                    "family": "fixture-adapter-rational",
                    "reason": "boundary-result",
                    "run": label,
                    "expected": expected_rational_adapter,
                    "observed": value.get("rational_adapter_results"),
                }
            )

    # Invoke existing native suites for their implementation-owned mutation and
    # denial assertions.  These suites do not replace the cross-adapter phase.
    native_suites = (
        (
            "suite-python-perturbation-surface",
            [sys.executable, "-m", "unittest", "mneme.lci0.python.tests.test_perturbations", "mneme.lci0.python.tests.test_surface"],
            {"PYTHONHASHSEED": "0", "LC_ALL": "C", "LANG": "C"},
        ),
        (
            "suite-common-lisp-unit",
            ["sbcl", "--noinform", "--disable-debugger", "--script", str(root / "mneme/lci0/common-lisp/run-tests.lisp")],
            {"LC_ALL": "C", "LANG": "C"},
        ),
    )
    for label, command, changes in native_suites:
        environment = dict(base_environment)
        environment.update(changes)
        process, record = _run_command(
            label=label, command=command, environment=environment, cwd=root,
            output_directory=output, require_success=False,
        )
        transcript.append(record)
        if process.returncode != 0:
            comparison["failures"].append(
                {"family": "native-suite", "reason": "nonzero-exit", "run": label, "exit_code": process.returncode}
            )

    comparison["status"] = (
        "converged-unaffected-with-authorial-blockers"
        if not comparison["failures"]
        else "fail"
    )

    (output / "command-transcript.jsonl").write_bytes(
        b"".join(_json_bytes(item) for item in transcript)
    )
    family_counts = Counter(case.family for case in cases)
    summary = {
        "authorial_return_required": True,
        "authorial_blocked": comparison[
            "authorial_blocked_failure_coordinates"
        ],
        "authorial_blocked_results": comparison[
            "authorial_blocked_result_coordinates"
        ],
        "comparison": comparison,
        "commands": len(transcript),
        "fixture_profile_version": FIXTURE_PROFILE_VERSION,
        "fixture_root": fixture_receipt,
        "gate": gate,
        "host_profiles": {
            "adapter_processes": len(adapter_profiles),
            "common_lisp_native": 6,
            "python_native": 4,
            "direct_separate_processes": len(transcript),
            "known_nested_python_runner_processes": 4,
            "separate_processes": len(transcript) + 4,
            "safe_marker_limitations": [
                "Cross-adapter environment markers do not themselves deny I/O because adapters must load the frozen package.",
                "Python native projection patches filesystem, socket, and clock entry points after fixture setup.",
                "Common Lisp native projection uses an unavailable default pathname; no socket subsystem is loaded, so network denial is procedural rather than OS-enforced.",
            ],
        },
        "native_probe_results": native_probe_results,
        "property": {
            "allocation_cases": arguments.allocation_cases,
            "case_family_counts": dict(sorted(family_counts.items())),
            "cases": len(cases),
            "requests_per_adapter_process": len(requests),
            "seed": arguments.seed,
            "total_adapter_requests": len(requests) * len(adapter_profiles),
        },
        "protocol": PROTOCOL,
        "repository": {
            "head": _git_value(root, "rev-parse", "HEAD"),
            "path": str(root),
            "tree": _git_value(root, "rev-parse", "HEAD^{tree}"),
        },
        "runtime": {
            "platform": platform.platform(),
            "python": sys.version,
            "python_executable": sys.executable,
            "sbcl": runtime_results["runtime-sbcl-version"],
            "available_locales": runtime_results["runtime-locale-list"].splitlines(),
        },
        "status": comparison["status"],
        "successor_summary": {
            "bytes": len(successor_payload),
            "path": str(successor_path),
            "sha256": _sha256(successor_payload),
        },
        "successor_artifacts": successor_artifact_receipt,
    }
    (output / "summary.json").write_bytes(_json_bytes(summary, pretty=True))
    _write_manifest(output)
    print(
        json.dumps(
            {
                "cases": len(cases),
                "output": str(output),
                "seed": arguments.seed,
                "status": summary["status"],
            },
            sort_keys=True,
        )
    )
    return (
        0
        if summary["status"] == "converged-unaffected-with-authorial-blockers"
        else 1
    )


if __name__ == "__main__":
    raise SystemExit(main())
