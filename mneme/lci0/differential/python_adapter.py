"""Expected-free Python adapter for the LCI/0 differential protocol."""

from __future__ import annotations

import json
import sys
from typing import Any, Mapping, TextIO

import cd0

from lci0.core import (
    CD0_BUDGET,
    canonical_bytes,
    claim_ids_equal,
    evaluate_policy,
    match_target,
    project_claim_id,
    scope_relation,
    temporal_relation,
    validate_claim_id,
    validate_stable_ref,
    validate_warrant_target,
)
from lci0.model import (
    ClaimIdEnvelope,
    FixtureAuthorityGap,
    LCIFailure,
    LCIValue,
    RelationResult,
    field_by_path,
    scalar,
)
from lci0.vector import execute, id_name, record_to_mapping
from lci0 import closure

from protocol import (
    FIXTURE_PROFILE_VERSION,
    PROTOCOL,
    PYTHON_SEED_COMMIT,
    PYTHON_SEED_TREE,
    ProtocolError,
    validate_request,
)
from response_validation import canonical_failure_path, loads_closed_json


LCI = ("lisp-plus", "lci", "0")
TAG = LCI + ("tag",)
FAILURE = LCI + ("failure",)
RELATION = LCI + ("relation",)
FIXTURE = LCI + ("fixture",)
FIXTURE_FIELD = FIXTURE + ("field",)

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


def _identifier(namespace: tuple[str, ...], *path: str) -> cd0.Identifier:
    return cd0.identifier(namespace, path)


def _record(namespace: tuple[str, ...], values: Mapping[str, cd0.Datum]) -> cd0.Record:
    return cd0.record((_identifier(namespace, name), value) for name, value in values.items())


def _fixture_record(values: Mapping[str, cd0.Datum]) -> cd0.Record:
    return _record(FIXTURE_FIELD, values)


def _path_part(part: str, previous: str | None) -> cd0.Identifier:
    if part.startswith("fixture-field:"):
        return _identifier(FIXTURE_FIELD, part[14:])
    if previous == "arguments":
        return _identifier(FIXTURE + ("mneme-proposition", "argument"), part)
    if (
        previous in PROPOSITION_PATH_ARGUMENTS
        and part in {"kind", "schema-version", "placement", "value", "coordinate", "locator-role"}
    ):
        return _identifier(FIXTURE + ("mneme-proposition", "field"), part)
    if part in STANDARD_PATH_FIELDS:
        return _identifier(LCI, part)
    if part == "arguments":
        return _identifier(FIXTURE + ("mneme-proposition", "field"), part)
    return _identifier(FIXTURE_FIELD, part)


def _path_datum(path: tuple[str, ...]) -> cd0.Sequence:
    previous: str | None = None
    parts: list[cd0.Datum] = []
    for part in path:
        parts.append(_path_part(part, previous))
        previous = part
    return cd0.sequence(parts)


def _failure_datum(failure: LCIFailure, vector_id: str) -> cd0.Record:
    if failure.context:
        context = cd0.record(
            (
                _identifier(
                    FIXTURE_FIELD if name.startswith("fixture-field:") else LCI,
                    name.split(":", 1)[-1],
                ),
                value,
            )
            for name, value in failure.context
        )
    else:
        context = _fixture_record({"vector-id": cd0.string(vector_id)})
    return _record(
        LCI,
        {
            "kind": _identifier(TAG, "failure"),
            "schema-version": cd0.integer(0),
            "category": _identifier(FAILURE, failure.category),
            "code": _identifier(FAILURE, failure.code),
            "stage": _identifier(FAILURE, failure.stage),
            "path": _path_datum(failure.path),
            "context": context,
        },
    )


def _embedded_failure(value: Mapping[str, Any]) -> cd0.Record:
    path = tuple(str(part) for part in value["path"])
    return _record(
        LCI,
        {
            "kind": _identifier(TAG, "failure"),
            "schema-version": cd0.integer(0),
            "category": _identifier(FAILURE, str(value["category"])),
            "code": _identifier(FAILURE, str(value["code"])),
            "stage": _identifier(FAILURE, str(value["stage"])),
            "path": _path_datum(path),
            "context": _fixture_record({}),
        },
    )


def _native_datum(value: Any, *, operation: str, path: tuple[str, ...] = ()) -> cd0.Datum:
    if isinstance(value, (ClaimIdEnvelope, LCIValue)):
        return value.datum
    if type(value) in (
        cd0.Unit, cd0.Boolean, cd0.Integer, cd0.Rational, cd0.String,
        cd0.ByteString, cd0.Identifier, cd0.Sequence, cd0.Record,
    ):
        return value
    if type(value) is bytes:
        return cd0.byte_string(value)
    if type(value) is bool:
        return cd0.boolean(value)
    if type(value) is int:
        return cd0.integer(value)
    if type(value) is str:
        field = path[-1] if path else ""
        if field == "surface":
            return cd0.string(value)
        if field in {"relation", "scope-relation-left-to-right"} and "/" not in value:
            return _identifier(RELATION, value)
        if "/" in value:
            return _identifier(FIXTURE, *value.split("/"))
        raise TypeError(f"unclassified integration string at {path!r}: {value!r}")
    if isinstance(value, Mapping):
        if path and path[-1] == "incomplete-failure":
            return _embedded_failure(value)
        return _fixture_record(
            {
                str(name): _native_datum(item, operation=operation, path=path + (str(name),))
                for name, item in value.items()
            }
        )
    if isinstance(value, (list, tuple)):
        return cd0.sequence(
            _native_datum(item, operation=operation, path=path + (str(index),))
            for index, item in enumerate(value)
        )
    raise TypeError(f"unclassified integration result at {path!r}: {type(value)!r}")


def _result_datum(
    operation_identifier: cd0.Identifier,
    operation: str,
    outputs: Mapping[str, Any],
    payload: Mapping[str, cd0.Datum],
) -> cd0.Record:
    # The Python seed's semantic view intentionally simplifies these two
    # receipts.  Restore their exact immutable input datums before encoding the
    # result; this is representation, not semantic inference.
    if operation == "translate-exactly":
        outputs = dict(outputs)
        lineage = dict(outputs["lineage"])
        lineage["source"] = payload["source-receipt"]
        lineage["target"] = payload["target-receipt"]
        outputs["lineage"] = lineage
    encoded_outputs = {
        str(name): _native_datum(item, operation=operation, path=(str(name),))
        for name, item in outputs.items()
    }
    return _fixture_record(
        {
            "kind": _identifier(FIXTURE, "tag", "fixture-operation-result"),
            "schema-version": cd0.integer(0),
            "status": _identifier(FIXTURE, "result-status", "success"),
            "operation": operation_identifier,
            "outputs": _fixture_record(encoded_outputs),
        }
    )


def _failure_object(failure: LCIFailure) -> dict[str, Any]:
    return {
        "category": failure.category,
        "code": failure.code,
        "stage": failure.stage,
        "path": canonical_failure_path(failure.path),
    }


def _base_response(request: Mapping[str, Any]) -> dict[str, Any]:
    return {
        "protocol": PROTOCOL,
        "request_id": request["request_id"],
        "operation": request["operation"],
        "fixture_profile_version": request["fixture_profile_version"],
        "implementation": "python",
        "implementation_seed_commit": PYTHON_SEED_COMMIT,
        "implementation_seed_tree": PYTHON_SEED_TREE,
    }


def _relation_failure_value(failure: LCIFailure) -> str | None:
    if failure.code in {"ScopeIncompatible", "UnsupportedTemporalModel"}:
        return "incompatible"
    if failure.code in {"ScopeRelationUnknown", "AdmissibilityUndetermined"}:
        return "unknown"
    return None


def _right_operand_symbolic(right: cd0.Datum) -> bool:
    """True when the right temporal operand's expression form is symbolic.

    Mirror of lci0.closure.evaluate_relation_table's temporal predicate; the
    symbolic right operand is the coordinate that independently prevents
    relation determination (LCI0-AC-002)."""

    try:
        form = field_by_path(field_by_path(right, "expression"), "form")
    except (LCIFailure, FixtureAuthorityGap, KeyError, ValueError, TypeError):
        return False
    return type(form) is cd0.Identifier and form.path[-1:] == ("symbolic",)


def _deepen_relation_failure(
    operation: str, failure: LCIFailure, right: cd0.Datum
) -> LCIFailure:
    """Deepen the engine's own companion failure path to the ruled coordinate.

    Only the 38 LCI0-AC-002 closure rows are deepened; the ruling normalizes
    the underdetermined companion path to a single operand coordinate.  Scope
    cross-calculus incompatibility selects the right operand's calculus; a
    symbolic right temporal form selects the right operand's expression form.
    The relation VALUE and every other coordinate are untouched."""

    if operation == "scope-relation-table" and failure.code == "ScopeIncompatible":
        return LCIFailure(
            failure.category,
            failure.code,
            failure.stage,
            ("fixture-field:right", "calculus"),
            failure.context,
        )
    if (
        operation == "temporal-relation-table"
        and failure.code == "AdmissibilityUndetermined"
        and _right_operand_symbolic(right)
    ):
        return LCIFailure(
            failure.category,
            failure.code,
            failure.stage,
            ("fixture-field:right", "expression", "form"),
            failure.context,
        )
    return failure


def _ruled_hostile_failure(operation: str, failure: LCIFailure) -> LCIFailure:
    """Normalize a hostile direct-validation failure to its ruled tuple.

    Mirror of lci0.closure.hostile_validate: a stable-reference material budget
    failure points at /material; a warrant-target boundary-value defect surfaces
    at stage target-boundary.  Every other failure is returned unchanged."""

    if (
        operation == "hostile-validate-stable-ref"
        and failure.code == "StableReferenceMaterialBudgetExceeded"
        and not failure.path
    ):
        return LCIFailure(
            failure.category, failure.code, failure.stage, ("material",), failure.context
        )
    if (
        operation == "hostile-validate-warrant-target"
        and failure.path[:1] == ("boundaries",)
        and not failure.stage.startswith("target")
    ):
        return LCIFailure(
            failure.category, failure.code, "target-boundary", failure.path, failure.context
        )
    return failure


def _value_datum(value: Any) -> cd0.Datum:
    """Encode a ruled semantic-value scalar into its CD/0 datum (None -> unit)."""

    if value is None:
        return cd0.unit()
    if type(value) is bool:
        return cd0.boolean(value)
    if type(value) is int:
        return cd0.integer(value)
    if type(value) is str:
        return cd0.string(value)
    if isinstance(value, (cd0.Unit, cd0.Boolean, cd0.Integer, cd0.Rational, cd0.String, cd0.ByteString, cd0.Identifier, cd0.Sequence, cd0.Record)):
        return value
    raise TypeError(f"unencodable ruled value: {type(value)!r}")


def _fixture_result_document(operation: str, outputs: Mapping[str, cd0.Datum]) -> cd0.Record:
    """The canonical fixture-operation-result success document, from ruled outputs."""

    return _fixture_record(
        {
            "kind": _identifier(FIXTURE, "tag", "fixture-operation-result"),
            "schema-version": cd0.integer(0),
            "status": _identifier(FIXTURE, "result-status", "success"),
            "operation": _identifier(FIXTURE, "operation", operation),
            "outputs": _fixture_record(dict(outputs)),
        }
    )


def _ruled_revival_document(
    payload: Mapping[str, cd0.Datum], outcome: Any
) -> cd0.Record:
    """The exact ruled inert defensive revival result (LCI0-AC-010, P024).

    Derived from lci0.closure.revival_semantics, which verifies every invariant
    (byte-identical fresh defensive copy, preserved ClaimId, zero live warrants)
    before the ruled document is emitted."""

    semantics = closure.revival_semantics(payload, outcome)
    value = _fixture_record({name: _value_datum(item) for name, item in semantics["value"].items()})
    return _fixture_result_document(
        "revive-inert-occurrence",
        {
            "production_revival": cd0.string(semantics["production_revival"]),
            "value": value,
        },
    )


def _ruled_conformance_document(outcome: Any) -> cd0.Record:
    """The ruled within-budget conformance value document (LCI0-AC-007).

    Derived from lci0.closure.conformance_semantics: limit read from the same
    frozen resource table the guard enforces, requested from the validated
    workload, within-budget from the executed result, workload from the
    validated resource identity."""

    semantics = closure.conformance_semantics(outcome)
    value = semantics["value"]
    return _fixture_result_document(
        "conformance-validation",
        {name: _value_datum(value[name]) for name in ("limit", "requested", "within-budget", "workload")},
    )


def run_request(raw: Any) -> dict[str, Any]:
    try:
        request = validate_request(raw)
    except ProtocolError as failure:
        return {
            "protocol": PROTOCOL,
            "request_id": raw.get("request_id", "") if type(raw) is dict else "",
            "implementation": "python",
            "protocol_status": "failure",
            "protocol_failure": {"code": failure.code, "path": list(failure.path)},
        }
    response = _base_response(request)
    try:
        encoded = bytes.fromhex(request["input_canonical_hex"])
        datum = cd0.decode_exact(encoded, CD0_BUDGET)
        reencoded = canonical_bytes(datum)
        if reencoded != encoded:
            raise ProtocolError("NoncanonicalDifferentialInput", ("input_canonical_hex",))
        operation = request["operation"]
        response["protocol_status"] = "success"
        response["input_reencoded_canonical_hex"] = reencoded.hex()
        if operation == "document-roundtrip":
            response["semantic_status"] = "success"
            return response
        if operation in {"scope-relation-table", "temporal-relation-table"}:
            fields = record_to_mapping(datum)
            left_name, right_name = (
                ("left-scope", "right-scope")
                if operation == "scope-relation-table"
                else ("left-subject-time", "right-subject-time")
            )
            try:
                relation = (
                    scope_relation(fields[left_name], fields[right_name])
                    if operation == "scope-relation-table"
                    else temporal_relation(fields[left_name], fields[right_name])
                )
            except LCIFailure as failure:
                relation = _relation_failure_value(failure)
                if relation is None:
                    raise
                ruled = _deepen_relation_failure(operation, failure, fields[right_name])
                response["semantic_status"] = "failure"
                response["failure"] = _failure_object(ruled)
            else:
                response["semantic_status"] = "success"
            response["relation"] = relation
            return response
        if operation in {"hostile-validate-stable-ref", "hostile-validate-warrant-target"}:
            try:
                if operation == "hostile-validate-stable-ref":
                    validate_stable_ref(datum)
                else:
                    validate_warrant_target(datum)
            except LCIFailure as failure:
                response["semantic_status"] = "failure"
                response["failure"] = _failure_object(
                    _ruled_hostile_failure(operation, failure)
                )
                return response
            response["semantic_status"] = "success"
            return response
        if operation == "hostile-validate-claim-id":
            validate_claim_id(datum)
            response["semantic_status"] = "success"
            return response
        if operation == "hostile-project-claim-id":
            project_claim_id(datum)
            response["semantic_status"] = "success"
            return response
        if operation in {"hostile-match-target", "hostile-claim-ids-equal"}:
            try:
                fields = record_to_mapping(datum)
            except (LCIFailure, FixtureAuthorityGap) as failure:
                raise ProtocolError(
                    "InvalidHostileCarrier", ("operation",)
                ) from failure
            expected = (
                {"target", "candidate-claim"}
                if operation == "hostile-match-target"
                else {"left-claim-id", "right-claim-id"}
            )
            if set(fields) != expected:
                raise ProtocolError("InvalidHostileCarrier", ("operation",))
            if operation == "hostile-match-target":
                relation = match_target(fields["target"], fields["candidate-claim"])
                if relation.failure is not None:
                    response["semantic_status"] = "failure"
                    response["failure"] = _failure_object(relation.failure)
                else:
                    response["semantic_status"] = "success"
                return response
            claim_ids_equal(fields["left-claim-id"], fields["right-claim-id"])
            response["semantic_status"] = "success"
            return response
        if operation == "hostile-evaluate-policy-c":
            fields = record_to_mapping(datum)
            if set(fields) != {"policy", "target-relation"}:
                raise ProtocolError("InvalidPolicyCCarrier", ("operation",))
            policy_name = id_name(fields["policy"]).split("/")[-1]
            if fields["policy"] != _identifier(FIXTURE, "policy-name", "policy-c"):
                raise ProtocolError("InvalidPolicyCCarrier", ("operation",))
            relation_fields = record_to_mapping(fields["target-relation"])
            if (
                set(relation_fields)
                != {"kind", "schema-version", "status", "relation"}
                or relation_fields["kind"]
                != _identifier(FIXTURE, "tag", "target-relation-result")
                or relation_fields["schema-version"] != cd0.integer(0)
                or relation_fields["status"]
                != _identifier(FIXTURE, "result-status", "success")
                or relation_fields["relation"]
                != _identifier(RELATION, "exact-target")
            ):
                raise ProtocolError("InvalidPolicyCCarrier", ("operation",))
            relation_name = "exact-target"
            try:
                evaluate_policy(policy_name, RelationResult(relation_name))
            except FixtureAuthorityGap:
                response["protocol_status"] = "fixture-authority-gap"
                response["status"] = "blocked"
                response["authority_gap"] = "unsupported fixture policy"
                return response
            except LCIFailure as failure:
                raise ProtocolError(
                    "UnexpectedPolicyCLciFailure", ("operation",)
                ) from failure
            raise ProtocolError("UnexpectedPolicyCSuccess", ("operation",))

        envelope = record_to_mapping(datum)
        required = {"kind", "schema-version", "vector-id", "operation", "fixture-profile-version", "payload"}
        if set(envelope) != required:
            raise ProtocolError("InvalidFixtureVectorEnvelope", ("input_canonical_hex",))
        embedded_operation = id_name(envelope["operation"]).split("/")[-1]
        if embedded_operation != operation:
            raise ProtocolError("DifferentialOperationMismatch", ("operation",))
        if scalar(envelope["fixture-profile-version"]) != FIXTURE_PROFILE_VERSION:
            raise ProtocolError("EmbeddedFixtureProfileMismatch", ("input_canonical_hex",))
        vector_id = scalar(envelope["vector-id"])
        try:
            payload = record_to_mapping(envelope["payload"])
        except LCIFailure as failure:
            actual = _failure_datum(failure, vector_id)
            response["vector_id"] = vector_id
            response["semantic_status"] = "failure"
            response["failure"] = _failure_object(failure)
            response["actual_canonical_cd0_hex"] = canonical_bytes(actual).hex()
            return response
        outcome = execute(operation, payload, vector_id=vector_id)
        response["vector_id"] = vector_id
        if outcome.failure is not None:
            actual = _failure_datum(outcome.failure, vector_id)
            response["semantic_status"] = "failure"
            response["failure"] = _failure_object(outcome.failure)
        elif operation == "revive-inert-occurrence":
            # LCI0-AC-010 (P024): the sole ruled inert defensive revival result.
            actual = _ruled_revival_document(payload, outcome)
            response["semantic_status"] = "success"
        elif operation == "conformance-validation":
            # LCI0-AC-007 (RESOURCE at the inclusive limit): the ruled
            # within-budget value document.  Over-limit conformance vectors are
            # failures and never reach this branch.
            actual = _ruled_conformance_document(outcome)
            response["semantic_status"] = "success"
        else:
            actual = _result_datum(envelope["operation"], operation, outcome.outputs or {}, payload)
            response["semantic_status"] = "success"
        response["actual_canonical_cd0_hex"] = canonical_bytes(actual).hex()
        return response
    except ProtocolError as failure:
        response["protocol_status"] = "failure"
        response["protocol_failure"] = {"code": failure.code, "path": list(failure.path)}
        return response
    except cd0.CD0Failure as failure:
        response["protocol_status"] = "failure"
        response["protocol_failure"] = {
            "code": failure.code,
            "path": [str(part) for part in failure.path],
        }
        return response
    except LCIFailure as failure:
        response["semantic_status"] = "failure"
        response["failure"] = _failure_object(failure)
        return response
    except FixtureAuthorityGap:
        response["protocol_status"] = "failure"
        response["protocol_failure"] = {
            "code": "UnexpectedFixtureAuthorityGap",
            "path": ["operation"],
        }
        return response
    except Exception:  # adapter defects are visible without host exception prose
        response["protocol_status"] = "failure"
        response["protocol_failure"] = {
            "code": "PythonAdapterDefect",
            "path": [],
        }
        return response


def run_lines(source: TextIO, sink: TextIO) -> int:
    for line_number, line in enumerate(source, 1):
        try:
            raw = loads_closed_json(line)
        except (json.JSONDecodeError, ValueError):
            raw = {"request_id": f"invalid-json-line-{line_number}"}
        response = run_request(raw)
        sink.write(json.dumps(response, sort_keys=True, separators=(",", ":"), ensure_ascii=False) + "\n")
        sink.flush()
    return 0


if __name__ == "__main__":
    raise SystemExit(run_lines(sys.stdin, sys.stdout))
