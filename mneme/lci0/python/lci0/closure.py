"""Authorial-closure execution surfaces for the LCI/0 Python successor.

This module implements the formerly blocked surfaces ruled in
LCI0-IMPLEMENTATION-CLOSURE-RULING.md and instantiated by fixture overlay 0.2:

- LCI0-AC-002-RELATION-FAILURE-PATHS: the relation-table evaluation
  operations (``evaluate-scope_relation_table_0`` /
  ``evaluate-temporal_relation_table_0``) with ruled companion failure
  coordinates and precedence evidence;
- LCI0-AC-005-POLICY-EVALUATION-ORDER: the Policy-C fail-closed
  authority-gap document;
- LCI0-AC-007-OPERATION-PAYLOAD-FAILURES: the hostile direct-document
  validation operations with exact ruled tuples, never host exceptions;
- LCI0-AC-010-P024-INERT-REVIVAL: the exact inert defensive revival result
  document, emitted only after verifying the defensive-copy invariants.

Semantic result documents follow the closure-vector encoding: failures carry
``category``/``code``/``stage`` plus a slash-joined ``semantic_path`` that
never exposes Python indexes or host coordinates (adapter obligation,
LCI0-AC-002).  The module also provides the canonical outcome-document
renderer used to compare produced results byte-for-byte against
``canonical_cd0_hex`` expectations.
"""

from __future__ import annotations

from typing import Any, Mapping

import cd0

from .core import (
    CD0_BUDGET,
    FIXTURE,
    FIXTURE_FIELD,
    LCI,
    LCI_RESOURCE_LIMITS,
    TAG,
    _id_tail,
    canonical_bytes,
    evaluate_policy,
    field_by_path,
    scope_relation,
    temporal_relation,
    validate_stable_ref,
    validate_warrant_target,
)
from .model import (
    ClaimIdEnvelope,
    FixtureAuthorityGap,
    LCIFailure,
    RelationResult,
)
from .vector import Outcome, execute, id_name, record_to_mapping, scalar


FIXTURE_FIELD_PREFIX = "fixture-field:"

RELATION_TABLE_OPERATIONS = {
    "evaluate-scope_relation_table_0": ("left-scope", "right-scope"),
    "evaluate-temporal_relation_table_0": ("left-subject-time", "right-subject-time"),
}

HOSTILE_DIRECT_OPERATIONS = frozenset(
    {"hostile-validate-stable-ref", "hostile-validate-warrant-target"}
)

DIRECT_DOCUMENT_OPERATIONS = frozenset(RELATION_TABLE_OPERATIONS) | HOSTILE_DIRECT_OPERATIONS

# Ruled precedence evidence, uniform per relation family
# (LCI0-IMPLEMENTATION-CLOSURE-RULING.md § LCI0-AC-002-RELATION-FAILURE-PATHS).
SCOPE_PRECEDENCE_EVIDENCE = {
    "retained_competing_causes": ["/left-scope/calculus", "/right-scope/calculus"],
    "rule": (
        "left operand validated first; the right nested calculus is the first "
        "coordinate that completes proof of cross-calculus incompatibility"
    ),
    "selected_coordinate": "/right-scope/calculus",
}
TEMPORAL_PRECEDENCE_EVIDENCE = {
    "retained_competing_causes": [],
    "rule": "right symbolic form independently prevents determination",
    "selected_coordinate": "/right-subject-time/expression/form",
}


def _strip(name: str) -> str:
    return name[len(FIXTURE_FIELD_PREFIX):] if name.startswith(FIXTURE_FIELD_PREFIX) else name


def semantic_path(path: tuple[str, ...]) -> str:
    """Render an LCI failure path as the ruled semantic spelling."""

    return "/" + "/".join(_strip(item) for item in path)


def failure_semantics(failure: LCIFailure) -> dict[str, str]:
    return {
        "category": failure.category,
        "code": failure.code,
        "semantic_path": semantic_path(failure.path),
        "stage": failure.stage,
    }


# ---------------------------------------------------------------------------
# Outcome -> canonical result document (byte-exact expected-document schema)
# ---------------------------------------------------------------------------


def _path_identifier(name: str) -> cd0.Identifier:
    if name.startswith(FIXTURE_FIELD_PREFIX):
        return cd0.identifier(FIXTURE_FIELD, (name[len(FIXTURE_FIELD_PREFIX):],))
    return cd0.identifier(LCI, (name,))


def _output_datum(value: Any) -> cd0.Datum:
    if isinstance(value, ClaimIdEnvelope):
        return value.datum
    if type(value) in (
        cd0.Unit,
        cd0.Boolean,
        cd0.Integer,
        cd0.Rational,
        cd0.String,
        cd0.ByteString,
        cd0.Identifier,
        cd0.Sequence,
        cd0.Record,
    ):
        return value
    if isinstance(value, bool):
        return cd0.boolean(value)
    if isinstance(value, int):
        return cd0.integer(value)
    if isinstance(value, bytes):
        return cd0.byte_string(value)
    if isinstance(value, str):
        if "/" in value:
            return cd0.identifier(FIXTURE, tuple(value.split("/")))
        return cd0.string(value)
    if isinstance(value, Mapping):
        return cd0.record(
            (cd0.identifier(FIXTURE_FIELD, (str(name),)), _output_datum(item))
            for name, item in value.items()
        )
    if isinstance(value, (list, tuple)):
        return cd0.sequence(tuple(_output_datum(item) for item in value))
    raise FixtureAuthorityGap(f"unsupported outcome output value type {type(value).__name__}")


def failure_document(failure: LCIFailure) -> cd0.Record:
    """The canonical LCI failure document (frozen expected-document schema)."""

    return cd0.record(
        (
            (cd0.identifier(LCI, ("kind",)), cd0.identifier(TAG, ("failure",))),
            (cd0.identifier(LCI, ("schema-version",)), cd0.integer(0)),
            (
                cd0.identifier(LCI, ("category",)),
                cd0.identifier(LCI + ("failure",), (failure.category,)),
            ),
            (
                cd0.identifier(LCI, ("code",)),
                cd0.identifier(LCI + ("failure",), (failure.code,)),
            ),
            (
                cd0.identifier(LCI, ("stage",)),
                cd0.identifier(LCI + ("failure",), (failure.stage,)),
            ),
            (
                cd0.identifier(LCI, ("path",)),
                cd0.sequence(tuple(_path_identifier(item) for item in failure.path)),
            ),
            (
                cd0.identifier(LCI, ("context",)),
                cd0.record(
                    tuple(
                        (_path_identifier(name), _output_datum(item))
                        for name, item in failure.context
                    )
                ),
            ),
        )
    )


def success_document(operation: str, outputs: Mapping[str, Any]) -> cd0.Record:
    """The canonical fixture-operation-result success document."""

    return cd0.record(
        (
            (
                cd0.identifier(FIXTURE_FIELD, ("kind",)),
                cd0.identifier(FIXTURE, ("tag", "fixture-operation-result")),
            ),
            (cd0.identifier(FIXTURE_FIELD, ("schema-version",)), cd0.integer(0)),
            (
                cd0.identifier(FIXTURE_FIELD, ("operation",)),
                cd0.identifier(FIXTURE, ("operation", operation)),
            ),
            (
                cd0.identifier(FIXTURE_FIELD, ("status",)),
                cd0.identifier(FIXTURE, ("result-status", "success")),
            ),
            (
                cd0.identifier(FIXTURE_FIELD, ("outputs",)),
                cd0.record(
                    tuple(
                        (cd0.identifier(FIXTURE_FIELD, (str(name),)), _output_datum(item))
                        for name, item in outputs.items()
                    )
                ),
            ),
        )
    )


def outcome_document(outcome: Outcome) -> cd0.Record:
    if outcome.failure is not None:
        return failure_document(outcome.failure)
    return success_document(outcome.operation, outcome.outputs or {})


def outcome_canonical_octets(outcome: Outcome) -> bytes:
    return cd0.encode_exact(outcome_document(outcome), CD0_BUDGET)


# ---------------------------------------------------------------------------
# LCI0-AC-002: relation-table evaluation operations
# ---------------------------------------------------------------------------


def _closed_direct_payload(
    operation: str, document: cd0.Datum, names: tuple[str, ...]
) -> dict[str, cd0.Datum]:
    payload = record_to_mapping(document)
    if any(type(name) is not str for name in payload):
        raise LCIFailure(
            "invalid-input", "UnknownField", "fixture-operation", ("fixture-field:<non-string>",)
        )
    supplied = set(payload)
    expected = set(names)
    unknown = sorted(supplied - expected)
    if unknown:
        raise LCIFailure(
            "invalid-input",
            "UnknownField",
            "fixture-operation",
            (f"fixture-field:{unknown[0]}",),
        )
    missing = [name for name in names if name not in supplied]
    if missing:
        raise LCIFailure(
            "invalid-input",
            "MissingRequiredField",
            "fixture-operation",
            (f"fixture-field:{missing[0]}",),
        )
    return payload


def evaluate_relation_table(operation: str, document: cd0.Datum) -> dict[str, Any]:
    """Evaluate one frozen relation-table row; F-valued rows carry the ruled
    companion failure (LCI0-AC-002-RELATION-FAILURE-PATHS).

    The relation VALUE is the frozen row operand supplied with the pair; it is
    echoed unchanged.  The companion coordinates are produced from the actual
    engine failure, normalized to the operation's operand spelling and — for
    the temporal family — deepened to the symbolic operand's expression/form
    coordinate.  Determinate rows and unruled failure shapes remain a fixture
    authority gap.
    """

    left_name, right_name = RELATION_TABLE_OPERATIONS[operation]
    payload = _closed_direct_payload(operation, document, (left_name, right_name, "relation"))
    relation_value = payload["relation"]
    if (
        type(relation_value) is not cd0.Identifier
        or relation_value.namespace != LCI + ("relation",)
        or len(relation_value.path) != 1
    ):
        raise FixtureAuthorityGap("unsupported fixture relation-table row")
    frozen_relation = relation_value.path[0]
    left, right = payload[left_name], payload[right_name]

    engine = scope_relation if operation == "evaluate-scope_relation_table_0" else temporal_relation
    try:
        engine(left, right)
    except LCIFailure as failure:
        if operation == "evaluate-scope_relation_table_0" and failure.code == "ScopeIncompatible":
            # Retain the engine's right-calculus selection; normalize the
            # operand spelling to this operation's field names.
            ruled = LCIFailure(
                failure.category,
                failure.code,
                failure.stage,
                (f"fixture-field:{right_name}", "calculus"),
            )
            evidence = dict(SCOPE_PRECEDENCE_EVIDENCE)
        elif (
            operation == "evaluate-temporal_relation_table_0"
            and failure.code == "AdmissibilityUndetermined"
            and _id_tail(field_by_path(field_by_path(right, "expression"), "form"))[-1]
            == "symbolic"
        ):
            # Deepen to the symbolic right operand's expression/form
            # coordinate — the coordinate that independently prevents
            # relation determination.
            ruled = LCIFailure(
                failure.category,
                failure.code,
                failure.stage,
                (f"fixture-field:{right_name}", "expression", "form"),
            )
            evidence = dict(TEMPORAL_PRECEDENCE_EVIDENCE)
        else:
            raise FixtureAuthorityGap(
                "no ruled companion failure for this relation-table row"
            ) from failure
        return {
            "failure": failure_semantics(ruled),
            "precedence_evidence": evidence,
            "relation": frozen_relation,
            "status": "failure",
        }
    raise FixtureAuthorityGap(
        "no frozen table-evaluation result for a determinate relation row"
    )


# ---------------------------------------------------------------------------
# LCI0-AC-007: hostile direct-document validation operations
# ---------------------------------------------------------------------------


def hostile_validate(operation: str, document: cd0.Datum) -> dict[str, Any]:
    """Validate a raw hostile request document; malformed payloads fail
    structurally with the exact ruled tuples, never by host exception
    (LCI0-AC-007-OPERATION-PAYLOAD-FAILURES)."""

    try:
        if operation == "hostile-validate-stable-ref":
            validate_stable_ref(document, path=())
        elif operation == "hostile-validate-warrant-target":
            validate_warrant_target(document)
        else:
            raise FixtureAuthorityGap(f"operation {operation!r} is not a hostile surface")
    except LCIFailure as failure:
        ruled = failure
        if (
            operation == "hostile-validate-stable-ref"
            and failure.code == "StableReferenceMaterialBudgetExceeded"
            and not failure.path
        ):
            # The material octet budget is the budgeted coordinate of a
            # stable reference; the ruled tuple points at /material.
            ruled = LCIFailure(failure.category, failure.code, failure.stage, ("material",))
        elif (
            operation == "hostile-validate-warrant-target"
            and failure.path[:1] == ("boundaries",)
            and not failure.stage.startswith("target")
        ):
            # Boundary-value defects surface at the target-boundary stage on
            # this validation surface; nested value validators keep their own
            # stages everywhere else.
            ruled = LCIFailure(failure.category, failure.code, "target-boundary", failure.path)
        return {"failure": failure_semantics(ruled), "status": "failure"}
    raise FixtureAuthorityGap("no frozen positive result for this hostile request")


# ---------------------------------------------------------------------------
# LCI0-AC-005: Policy-C fail-closed authority gap
# ---------------------------------------------------------------------------


def evaluate_policy_c(document: cd0.Datum) -> dict[str, Any]:
    """The unknown-policy refusal is a non-LCI fixture authority gap; never a
    Policy-B-like accept and never an LCIFailure."""

    fields = record_to_mapping(document)
    policy_name = id_name(fields["policy"]).split("/")[-1]
    relation_name = id_name(field_by_path(fields["target-relation"], "relation")).split("/")[-1]
    try:
        evaluate_policy(policy_name, RelationResult(relation_name))
    except FixtureAuthorityGap:
        return {
            "authority_gap": "unsupported fixture policy",
            "lci_failure": None,
            "status": "authority-gap",
        }
    raise FixtureAuthorityGap("no frozen semantic result for a supported policy on this surface")


# ---------------------------------------------------------------------------
# HOSTILE-006 / HOSTILE-007 semantic renderings (envelope operations)
# ---------------------------------------------------------------------------


def conformance_semantics(outcome: Outcome) -> dict[str, Any]:
    """Semantic value document for a within-budget conformance validation.

    ``limit`` is read from the same frozen table the guard enforces; the
    workload name is the validated resource identity from the outcome."""

    if outcome.failure is not None:
        return {"failure": failure_semantics(outcome.failure), "status": "failure"}
    outputs = outcome.outputs or {}
    workload = outputs["resource"]
    resource_name = field_by_path(workload, "resource").path[-1]
    requested = outputs["requested"]
    return {
        "status": "success",
        "value": {
            "limit": LCI_RESOURCE_LIMITS[resource_name],
            "requested": requested,
            "within-budget": bool(outputs["within-budget"]),
            "workload": resource_name,
        },
    }


def migration_failure_semantics(outcome: Outcome) -> dict[str, Any]:
    if outcome.failure is None:
        raise FixtureAuthorityGap("no frozen semantic document for this migration result")
    return {"failure": failure_semantics(outcome.failure), "status": "failure"}


# ---------------------------------------------------------------------------
# LCI0-AC-010: exact inert defensive revival result
# ---------------------------------------------------------------------------


def revival_semantics(payload: Mapping[str, cd0.Datum], outcome: Outcome) -> dict[str, Any]:
    """Emit the ruled inert defensive revival document, but only after
    verifying every invariant it states against the actual outcome:

    - the new occurrence is a byte-identical *fresh* defensive copy of the
      supplied predecessor (nothing invented — no claimant, assertion time,
      provenance, standing, warrant effect, authority, custody, or verified
      lineage values beyond the copy);
    - the supplied ClaimId is preserved exactly; and
    - zero live warrants were created.
    """

    if outcome.failure is not None:
        return {"failure": failure_semantics(outcome.failure), "status": "failure"}
    revival = (outcome.outputs or {})["revival"]
    new_occurrence = revival["new-occurrence"]
    predecessor = payload["predecessor"]
    if canonical_bytes(new_occurrence) != canonical_bytes(predecessor):
        raise FixtureAuthorityGap("revival output is not the defensive predecessor copy")
    if new_occurrence is predecessor:
        raise FixtureAuthorityGap("revival output is not a fresh allocation")
    if canonical_bytes(revival["claim-id"]) != canonical_bytes(payload["requested-claim"]):
        raise FixtureAuthorityGap("revival output does not preserve the supplied ClaimId")
    if list(revival["live-warrants"]) != []:
        raise FixtureAuthorityGap("revival output created live warrants")
    return {
        "production_revival": "deferred",
        "status": "success",
        "value": {
            "assertion_time": None,
            "authority": None,
            "claimant": None,
            "custody": None,
            "live_warrants_created": 0,
            "mode": "inert-defensive-reconstruction",
            "predecessor": "defensive copy of supplied predecessor only",
            "provenance_edge": None,
            "requested_claim": "preserve supplied ClaimId exactly",
            "standing_effect": False,
            "verified_lineage": False,
            "warrant_effect": False,
        },
    }


# ---------------------------------------------------------------------------
# Unified direct-document dispatch (used by the runner)
# ---------------------------------------------------------------------------


def execute_direct(operation: str, document: cd0.Datum) -> dict[str, Any]:
    if operation in RELATION_TABLE_OPERATIONS:
        return evaluate_relation_table(operation, document)
    if operation in HOSTILE_DIRECT_OPERATIONS:
        return hostile_validate(operation, document)
    raise FixtureAuthorityGap(f"operation {operation!r} has no direct-document surface")


def execute_envelope(document: cd0.Datum) -> tuple[str, dict[str, cd0.Datum], Outcome]:
    """Execute a fixture-vector-input envelope through the frozen operation
    dispatch; returns (vector_id, payload, outcome)."""

    envelope = record_to_mapping(document)
    operation = id_name(envelope["operation"]).split("/")[-1]
    vector_id = scalar(envelope["vector-id"])
    payload = record_to_mapping(envelope["payload"])
    return vector_id, payload, execute(operation, payload, vector_id=vector_id)
