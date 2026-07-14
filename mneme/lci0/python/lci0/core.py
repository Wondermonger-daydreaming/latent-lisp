"""LCI/0 validation, projection, relation, policy, and inert migration core."""

from __future__ import annotations

from contextvars import ContextVar
from dataclasses import replace
from functools import wraps
from typing import Any, Callable

import cd0

from .model import (
    AUTHORIZED_LCI_FAILURE_CODES,
    ClaimIdEnvelope,
    FixtureAuthorityGap,
    FixtureIntegrityError,
    LCIFailure,
    PolicyDecision,
    RelationResult,
    field_by_path,
    scalar,
)


CD0_BUDGET = cd0.ResourceBudget(
    max_input_octets=16 * 1024 * 1024,
    max_output_octets=16 * 1024 * 1024,
    max_varint_octets=64,
    max_integer_bits=4096,
    max_depth=256,
    max_nodes=1_000_000,
    max_sequence_items=100_000,
    max_record_fields=100_000,
    max_identifier_segments=4096,
    max_segment_octets=65536,
    max_single_string_octets=16 * 1024 * 1024,
    max_single_bytes_octets=16 * 1024 * 1024,
    max_aggregate_payload_octets=16 * 1024 * 1024,
    max_total_record_key_octets=16 * 1024 * 1024,
    identifier="lci0-python-fixture-cd0",
)

LCI = ("lisp-plus", "lci", "0")
TAG = LCI + ("tag",)
FIXTURE = LCI + ("fixture",)
FIXTURE_FIELD = FIXTURE + ("field",)
MNEME_PROPOSITION_FIELD = FIXTURE + ("mneme-proposition", "field")
MNEME_PROPOSITION_ARGUMENT = FIXTURE + ("mneme-proposition", "argument")

LCI_RESOURCE_LIMITS = {
    "maximum-nesting": 64,
    "node-count": 4096,
    "record-fields": 64,
    "sequence-length": 256,
    "identifier-segments": 32,
    "aggregate-payload-octets": 131_072,
    "stable-reference-material-octets": 4096,
    "proposition-normalization-work": 10_000,
    "scope-relation-work": 4096,
    "temporal-relation-work": 4096,
    "migration-input-octets": 32_768,
    "target-boundary-work": 8192,
    "represented-loss-account-entries": 64,
}

LCI_RESOURCE_FAILURES = {
    "maximum-nesting": "LCIMaxNestingExceeded",
    "node-count": "LCINodeCountExceeded",
    "record-fields": "LCIRecordFieldBudgetExceeded",
    "sequence-length": "LCISequenceLengthBudgetExceeded",
    "identifier-segments": "LCIIdentifierSegmentBudgetExceeded",
    "aggregate-payload-octets": "LCIAggregatePayloadBudgetExceeded",
    "stable-reference-material-octets": "StableReferenceMaterialBudgetExceeded",
    "proposition-normalization-work": "PropositionNormalizationWorkExceeded",
    "scope-relation-work": "ScopeRelationWorkExceeded",
    "temporal-relation-work": "TemporalRelationWorkExceeded",
    "migration-input-octets": "MigrationInputSizeExceeded",
    "target-boundary-work": "TargetBoundaryWorkExceeded",
    "represented-loss-account-entries": "RepresentedLossAccountSizeExceeded",
}


def ident(namespace: tuple[str, ...], *path: str) -> cd0.Identifier:
    return cd0.identifier(namespace, path)


def record_field(namespace: tuple[str, ...], name: str, value: cd0.Datum) -> tuple[cd0.Identifier, cd0.Datum]:
    return (ident(namespace, name), value)


def canonical_bytes(value: cd0.Datum) -> bytes:
    return cd0.encode_exact(value, CD0_BUDGET)


def _path_names(
    value: cd0.Datum,
    *,
    namespace: tuple[str, ...] | None = None,
    stage: str = "shape",
    prefix: tuple[str, ...] = (),
) -> tuple[str, ...]:
    if type(value) is not cd0.Record:
        raise FixtureAuthorityGap("unsupported fixture record shape")
    names: list[str] = []
    for key, _ in value.fields:
        if len(key.path) != 1 or (namespace is not None and key.namespace != namespace):
            name = key.path[-1] if key.path else "<empty-field-path>"
            raise LCIFailure("invalid-input", "UnknownField", stage, prefix + (name,))
        names.append(key.path[0])
    return tuple(names)


def _closed(
    value: cd0.Datum,
    allowed: tuple[str, ...],
    *,
    stage: str,
    prefix: tuple[str, ...] = (),
    required: tuple[str, ...] | None = None,
    namespace: tuple[str, ...] | None = None,
    check_unknown: bool = True,
) -> None:
    if type(value) is not cd0.Record:
        raise FixtureAuthorityGap("unsupported fixture record shape")
    names = tuple(
        key.path[0]
        for key, _ in value.fields
        if len(key.path) == 1 and (namespace is None or key.namespace == namespace)
    )
    required = allowed if required is None else required
    for name in required:
        if name not in names:
            raise LCIFailure("invalid-input", "MissingRequiredField", stage, prefix + (name,))
    if check_unknown:
        _reject_unknown(value, allowed, stage=stage, prefix=prefix, namespace=namespace)


def _reject_unknown(
    value: cd0.Datum,
    allowed: tuple[str, ...],
    *,
    stage: str,
    prefix: tuple[str, ...] = (),
    namespace: tuple[str, ...] | None = None,
) -> None:
    names = _path_names(value, namespace=namespace, stage=stage, prefix=prefix)
    for name in names:
        if name not in allowed:
            raise LCIFailure("invalid-input", "UnknownField", stage, prefix + (name,))


def _integer_zero(value: cd0.Datum, code: str, stage: str, path: tuple[str, ...]) -> None:
    if code not in AUTHORIZED_LCI_FAILURE_CODES:
        raise FixtureIntegrityError("internal validator requested an unauthorized LCI failure code")
    if type(value) is not cd0.Integer or value.value != 0:
        raise LCIFailure("unsupported-version-or-profile", code, stage, path)


def _id_tail(value: cd0.Datum) -> tuple[str, ...]:
    if type(value) is not cd0.Identifier:
        raise FixtureAuthorityGap("unsupported fixture identifier shape")
    return value.path


def _kind(value: cd0.Datum) -> str:
    kind = field_by_path(value, "kind")
    tail = _id_tail(kind)
    return tail[-1]


def _require_kind(
    value: cd0.Datum,
    expected: str,
    code: str,
    stage: str,
    path: tuple[str, ...],
    *,
    namespace: tuple[str, ...] = TAG,
) -> None:
    if code not in AUTHORIZED_LCI_FAILURE_CODES:
        raise FixtureIntegrityError("internal validator requested an unauthorized LCI failure code")
    kind = field_by_path(value, "kind", None)
    expected_path = (expected,) if namespace == TAG else ("tag", expected)
    if type(kind) is not cd0.Identifier or kind.namespace != namespace or kind.path != expected_path:
        raise LCIFailure("invalid-input", code, stage, path + ("kind",))


def _value_bytes_length(value: cd0.Datum) -> int:
    # CD/0 format version 0 occupies one canonical uvarint octet.
    return len(canonical_bytes(value)) - len(cd0.MAGIC) - 1


def _resource_failure(resource: str, stage: str, path: tuple[str, ...]) -> None:
    raise LCIFailure("resource-refusal", LCI_RESOURCE_FAILURES[resource], stage, path)


def enforce_structural_resources(
    value: cd0.Datum,
    *,
    stage: str,
    path: tuple[str, ...] = (),
) -> dict[str, int]:
    """Apply the frozen LCI structural counters to one operation payload root."""

    metrics = {
        "maximum-nesting": 0,
        "node-count": 0,
        "record-fields": 0,
        "sequence-length": 0,
        "identifier-segments": 0,
        "aggregate-payload-octets": 0,
        "stable-reference-material-octets": 0,
    }
    stable_materials: list[cd0.Datum] = []
    stack: list[tuple[cd0.Datum, int, tuple[str, ...]]] = [(value, 1, path)]
    while stack:
        current, depth, current_path = stack.pop()
        metrics["node-count"] += 1
        metrics["maximum-nesting"] = max(metrics["maximum-nesting"], depth)
        if type(current) is cd0.Identifier:
            metrics["identifier-segments"] = max(
                metrics["identifier-segments"], len(current.namespace) + len(current.path)
            )
        elif type(current) is cd0.Sequence:
            metrics["sequence-length"] = max(metrics["sequence-length"], len(current.items))
            for index in range(len(current.items) - 1, -1, -1):
                stack.append((current.items[index], depth + 1, current_path + (str(index),)))
        elif type(current) is cd0.Record:
            metrics["record-fields"] = max(metrics["record-fields"], len(current.fields))
            kind = field_by_path(current, "kind", None)
            if (
                type(kind) is cd0.Identifier
                and kind.namespace == TAG
                and kind.path == ("stable-reference",)
            ):
                material = field_by_path(current, "material", None)
                if material is not None:
                    stable_materials.append(material)
            for key, item in reversed(current.fields):
                name = key.path[-1] if key.path else "<empty-field-path>"
                stack.append((item, depth + 1, current_path + (name,)))
                stack.append((key, depth + 1, current_path + (name, "<key>")))
    for resource in (
        "maximum-nesting",
        "node-count",
        "record-fields",
        "sequence-length",
        "identifier-segments",
    ):
        if metrics[resource] > LCI_RESOURCE_LIMITS[resource]:
            _resource_failure(resource, stage, path)
    metrics["aggregate-payload-octets"] = _value_bytes_length(value)
    if metrics["aggregate-payload-octets"] > LCI_RESOURCE_LIMITS["aggregate-payload-octets"]:
        _resource_failure("aggregate-payload-octets", stage, path)
    if stable_materials:
        metrics["stable-reference-material-octets"] = max(
            _value_bytes_length(material) for material in stable_materials
        )
    if metrics["stable-reference-material-octets"] > LCI_RESOURCE_LIMITS["stable-reference-material-octets"]:
        _resource_failure("stable-reference-material-octets", stage, path)
    return metrics


_RESOURCE_OPERATION_DEPTH: ContextVar[int] = ContextVar(
    "lci0_resource_operation_depth", default=0
)
_RESOURCE_OPERATION_STAGE: ContextVar[str | None] = ContextVar(
    "lci0_resource_operation_stage", default=None
)


class _OperationResourceGuard:
    """Class-based guard so frozen LCIFailure can cross ``__exit__`` intact."""

    __slots__ = ("payload", "stage", "path", "depth_token", "stage_token")

    def __init__(self, payload: cd0.Datum, stage: str, path: tuple[str, ...]):
        self.payload = payload
        self.stage = stage
        self.path = path
        self.depth_token = None
        self.stage_token = None

    def __enter__(self):
        if _RESOURCE_OPERATION_DEPTH.get():
            return self
        self.depth_token = _RESOURCE_OPERATION_DEPTH.set(1)
        self.stage_token = _RESOURCE_OPERATION_STAGE.set(self.stage)
        try:
            enforce_structural_resources(self.payload, stage=self.stage, path=self.path)
        except BaseException:
            _RESOURCE_OPERATION_STAGE.reset(self.stage_token)
            _RESOURCE_OPERATION_DEPTH.reset(self.depth_token)
            self.stage_token = None
            self.depth_token = None
            raise
        return self

    def __exit__(self, exc_type, exc, traceback):
        if self.depth_token is not None:
            _RESOURCE_OPERATION_STAGE.reset(self.stage_token)
            _RESOURCE_OPERATION_DEPTH.reset(self.depth_token)
            self.stage_token = None
            self.depth_token = None
        return False


def operation_resource_guard(
    payload: cd0.Datum,
    *,
    stage: str,
    path: tuple[str, ...] = (),
) -> _OperationResourceGuard:
    """Measure one public operation payload, never its nested validators again."""

    return _OperationResourceGuard(payload, stage, path)


def _single_datum_resource_guard(stage: str):
    def decorate(function):
        @wraps(function)
        def guarded(value: cd0.Datum, *args, **kwargs):
            with operation_resource_guard(value, stage=stage):
                return function(value, *args, **kwargs)

        return guarded

    return decorate


def _pair_payload(left_name: str, left: cd0.Datum, right_name: str, right: cd0.Datum) -> cd0.Record:
    return cd0.record(
        (
            record_field(FIXTURE_FIELD, left_name, left),
            record_field(FIXTURE_FIELD, right_name, right),
        )
    )


def _current_resource_stage(default: str) -> str:
    return _RESOURCE_OPERATION_STAGE.get() or default


def _datum_node_count(value: cd0.Datum) -> int:
    """Count every CD/0 value node, including record keys."""

    count = 0
    stack = [value]
    while stack:
        current = stack.pop()
        count += 1
        if type(current) is cd0.Sequence:
            stack.extend(reversed(current.items))
        elif type(current) is cd0.Record:
            for key, item in reversed(current.fields):
                stack.append(item)
                stack.append(key)
    return count


def proposition_normalization_work(
    source: cd0.Datum,
    normalized: cd0.Datum,
    represented_loss_entries: int = 0,
) -> int:
    """Frozen work formula: source nodes + emitted nodes + loss entries."""

    if type(represented_loss_entries) is not int or represented_loss_entries < 0:
        raise FixtureAuthorityGap("unsupported represented-loss work input")
    return (
        _datum_node_count(source)
        + _datum_node_count(normalized)
        + represented_loss_entries
    )


def scope_relation_work(left: cd0.Datum, right: cd0.Datum) -> int:
    """Frozen formula: dispatch + table lookup + inspected finite members."""

    work = 2
    for scope in (left, right):
        expression = field_by_path(scope, "expression")
        form = _id_tail(field_by_path(expression, "form"))[-1]
        if form == "region-set":
            members = field_by_path(expression, "members")
            if type(members) is cd0.Sequence:
                work += len(members.items)
    return work


def temporal_relation_work(left: cd0.Datum, right: cd0.Datum) -> int:
    """Frozen formula: dispatch + forms + endpoints/periodic residues."""

    work = 1
    for subject_time in (left, right):
        expression = field_by_path(subject_time, "expression")
        form = _id_tail(field_by_path(expression, "form"))[-1]
        work += 1
        if form == "instant":
            work += 1
        elif form == "interval":
            work += 2
        elif form == "periodic-set":
            work += 1
    return work


def _check_operation_work(resource: str, work: int, *, stage: str, path: tuple[str, ...]) -> int:
    if work > LCI_RESOURCE_LIMITS[resource]:
        _resource_failure(resource, stage, path)
    return work


def _boundary_value_node_count(value: cd0.Datum) -> int:
    """Count a boundary value tree without the boundaries record or record keys."""

    count = 0
    stack = [value]
    while stack:
        current = stack.pop()
        count += 1
        if type(current) is cd0.Sequence:
            stack.extend(reversed(current.items))
        elif type(current) is cd0.Record:
            stack.extend(item for _, item in reversed(current.fields))
    return count


def target_boundary_work(boundaries: cd0.Datum) -> int:
    if type(boundaries) is not cd0.Record:
        raise FixtureAuthorityGap("unsupported fixture boundary shape")
    return len(boundaries.fields) + sum(
        _boundary_value_node_count(item) for _, item in boundaries.fields
    )


STABLE_REF_DOMAINS = frozenset(
    {
        "scope-calculus",
        "temporal-model",
        "dataset-slice-calculus",
        "semantic-boundary-calculus",
        "interpretation-frame-schema",
        "logical-corpus",
        "immutable-corpus-revision",
        "module",
        "procedure",
        "model",
        "prompt-invocation",
        "artifact",
        "principal",
        "policy",
    }
)


def validate_stable_ref(value: cd0.Datum, *, path: tuple[str, ...] = ()) -> cd0.Datum:
    if type(value) is not cd0.Record:
        raise LCIFailure(
            "reference-refusal",
            "InvalidStableReference",
            "stable-reference",
            path,
        )
    _closed(
        value,
        ("kind", "domain", "scheme", "material"),
        stage="stable-reference",
        prefix=path,
        namespace=LCI,
        check_unknown=False,
    )
    _require_kind(value, "stable-reference", "InvalidStableReference", "stable-reference", path)
    domain = field_by_path(value, "domain")
    scheme = field_by_path(value, "scheme")
    if type(domain) is not cd0.Identifier or type(scheme) is not cd0.Identifier:
        raise LCIFailure("reference-refusal", "InvalidStableReference", "stable-reference", path)
    if domain.namespace != FIXTURE or len(domain.path) != 2 or domain.path[0] != "domain":
        raise LCIFailure("reference-refusal", "InvalidStableReference", "stable-reference", path + ("domain",))
    domain_name = domain.path[1]
    if domain_name not in STABLE_REF_DOMAINS:
        raise LCIFailure("unsupported-version-or-profile", "UnsupportedReferenceScheme", "stable-reference", path + ("domain",))
    if scheme.namespace != FIXTURE or scheme.path != ("scheme", domain_name, "structural", "0"):
        raise LCIFailure("unsupported-version-or-profile", "UnsupportedReferenceScheme", "stable-reference", path + ("scheme",))
    material = field_by_path(value, "material")
    _closed(
        material,
        ("kind", "schema-version", "object-id", "object-version"),
        stage="stable-reference",
        prefix=path + ("material",),
        namespace=FIXTURE_FIELD,
        check_unknown=False,
    )
    material_kind = field_by_path(material, "kind")
    if (
        type(material_kind) is not cd0.Identifier
        or material_kind.namespace != FIXTURE
        or material_kind.path != ("tag", "fixture-stable-material")
    ):
        raise LCIFailure(
            "reference-refusal",
            "InvalidStableReference",
            "stable-reference",
            path + ("material", "kind"),
        )
    _integer_zero(
        field_by_path(material, "schema-version"),
        "RecursiveUnsupportedNestedVersion",
        "stable-reference",
        path + ("material", "schema-version"),
    )
    object_id = field_by_path(material, "object-id")
    if type(object_id) is not cd0.Identifier:
        raise LCIFailure("reference-refusal", "InvalidStableReference", "stable-reference", path + ("material", "object-id"))
    lowered = tuple(segment.casefold() for segment in object_id.path)
    aliases = {
        "latest",
        "main",
        "production",
        "model-current",
        "display-model",
        "filename",
        "file.txt",
        "mutable-url",
    }
    if (
        any(segment in aliases for segment in lowered)
        or any(
            segment.startswith("http://") or segment.startswith("https://")
            for segment in lowered
        )
        or any("::" in segment for segment in object_id.path)
    ):
        failure_path = path + ("material", "fixture-field:object-id")
        raise LCIFailure("reference-refusal", "UnresolvedAlias", "stable-reference", failure_path)
    if (
        object_id.namespace != FIXTURE
        or len(object_id.path) < 3
        or object_id.path[:2] != ("object", domain_name)
    ):
        raise LCIFailure("reference-refusal", "InvalidStableReference", "stable-reference", path + ("material", "object-id"))
    object_version = field_by_path(material, "object-version")
    if type(object_version) is not cd0.Integer or object_version.value < 0:
        raise LCIFailure("reference-refusal", "InvalidStableReference", "stable-reference", path + ("material", "object-version"))
    _reject_unknown(
        material,
        ("kind", "schema-version", "object-id", "object-version"),
        stage="stable-reference",
        prefix=path + ("material",),
        namespace=FIXTURE_FIELD,
    )
    _reject_unknown(
        value,
        ("kind", "domain", "scheme", "material"),
        stage="stable-reference",
        prefix=path,
        namespace=LCI,
    )
    return value


def _validate_versioned_expression(
    value: cd0.Datum,
    allowed_by_form: dict[str, tuple[str, ...]],
    stage: str,
    path: tuple[str, ...],
    kind_name: str,
    *,
    invalid_code: str | None,
) -> str:
    if invalid_code is not None and invalid_code not in AUTHORIZED_LCI_FAILURE_CODES:
        raise FixtureIntegrityError("internal validator requested an unauthorized LCI failure code")

    def reject() -> None:
        if invalid_code is None:
            raise FixtureAuthorityGap(f"unsupported fixture {stage} expression")
        raise LCIFailure("invalid-input", invalid_code, stage, path)

    if type(value) is not cd0.Record:
        reject()
    _closed(
        value,
        ("kind", "schema-version", "form"),
        stage=stage,
        prefix=path,
        required=("kind", "schema-version", "form"),
        namespace=FIXTURE_FIELD,
        check_unknown=False,
    )
    form_value = field_by_path(value, "form", None)
    form_prefix = {
        "scope-expression": "scope-form",
        "temporal-expression": "temporal-form",
        "dataset-slice-expression": "slice-form",
        "semantic-boundary-expression": "boundary-form",
    }[kind_name]
    form = form_value.path[1] if type(form_value) is cd0.Identifier and len(form_value.path) == 2 else None
    allowed = allowed_by_form.get(form) if form is not None else None
    kind = field_by_path(value, "kind", None)
    if (
        type(kind) is not cd0.Identifier
        or kind.namespace != FIXTURE
        or kind.path != ("tag", kind_name)
    ):
        reject()
    _integer_zero(
        field_by_path(value, "schema-version"),
        "RecursiveUnsupportedNestedVersion",
        stage,
        path + ("schema-version",),
    )
    if allowed is None or form_value.namespace != FIXTURE or form_value.path != (form_prefix, form):
        if invalid_code is None:
            raise FixtureAuthorityGap(f"unsupported fixture {stage} expression")
        raise LCIFailure("invalid-input", invalid_code, stage, path + ("form",))
    assert form is not None
    return form


SCOPE_FORMS = {
    "universal": ("kind", "schema-version", "form"),
    "organization": ("kind", "schema-version", "form", "organization"),
    "department": ("kind", "schema-version", "form", "organization", "department"),
    "region-set": ("kind", "schema-version", "form", "members"),
    "tenant": ("kind", "schema-version", "form", "organization", "tenant"),
    "opaque-token": ("kind", "schema-version", "form", "token"),
    "symbolic-predicate": ("kind", "schema-version", "form", "symbol", "known-proper-subset"),
}

TEMPORAL_FORMS = {
    "atemporal": ("kind", "schema-version", "form"),
    "instant": ("kind", "schema-version", "form", "tick"),
    "interval": ("kind", "schema-version", "form", "start", "end", "start-closed", "end-closed"),
    "periodic-set": ("kind", "schema-version", "form", "modulus", "remainder"),
    "opaque-token": ("kind", "schema-version", "form", "token"),
    "symbolic": ("kind", "schema-version", "form", "symbol"),
    "relative": ("kind", "schema-version", "form", "offset", "anchor"),
}

SLICE_FORMS = {
    "all-members": ("kind", "schema-version", "form"),
    "explicit-members": ("kind", "schema-version", "form", "members"),
    "predicate": ("kind", "schema-version", "form", "predicate", "argument", "evaluation-domain"),
}

BOUNDARY_FORMS = {
    "not-applicable": ("kind", "schema-version", "form"),
    "snapshot-manifest": ("kind", "schema-version", "form", "manifest"),
    "path-root": ("kind", "schema-version", "form", "path", "path-semantics"),
    "log-horizon": ("kind", "schema-version", "form", "stream", "horizon"),
}


def validate_scope(value: cd0.Datum, *, path: tuple[str, ...] = ("location", "scope")) -> cd0.Datum:
    _closed(value, ("kind", "schema-version", "calculus", "expression"), stage="scope", prefix=path, namespace=LCI, check_unknown=False)
    _require_kind(value, "scope", "InvalidScope", "scope", path)
    _integer_zero(field_by_path(value, "schema-version"), "RecursiveUnsupportedNestedVersion", "scope", path + ("schema-version",))
    validate_stable_ref(field_by_path(value, "calculus"), path=path + ("calculus",))
    if _id_tail(field_by_path(field_by_path(value, "calculus"), "domain"))[-1] != "scope-calculus":
        raise LCIFailure("invalid-input", "InvalidScope", "scope", path + ("calculus",))
    try:
        form = _validate_versioned_expression(
            field_by_path(value, "expression"),
            SCOPE_FORMS,
            "scope",
            path + ("expression",),
            "scope-expression",
            invalid_code="InvalidScope",
        )
        expression = field_by_path(value, "expression")
        _closed(
            expression,
            SCOPE_FORMS[form],
            stage="scope",
            prefix=path + ("expression",),
            namespace=FIXTURE_FIELD,
            check_unknown=False,
        )
    except LCIFailure as exc:
        if exc.code == "MissingRequiredField":
            raise LCIFailure("invalid-input", "InvalidScope", "scope", path + ("expression",)) from exc
        raise
    if form == "region-set":
        members = field_by_path(expression, "members")
        if type(members) is not cd0.Sequence or not members.items or any(type(item) is not cd0.Identifier for item in members.items):
            raise LCIFailure("invalid-input", "InvalidScope", "scope", path + ("expression",))
        encoded = [canonical_bytes(item) for item in members.items]
        if encoded != sorted(set(encoded)):
            raise LCIFailure("invalid-input", "InvalidScope", "scope", path + ("expression", "members"))
    if form == "symbolic-predicate" and type(field_by_path(expression, "known-proper-subset")) is not cd0.Boolean:
        raise LCIFailure("invalid-input", "InvalidScope", "scope", path + ("expression", "known-proper-subset"))
    _reject_unknown(expression, SCOPE_FORMS[form], stage="scope", prefix=path + ("expression",), namespace=FIXTURE_FIELD)
    _reject_unknown(value, ("kind", "schema-version", "calculus", "expression"), stage="scope", prefix=path, namespace=LCI)
    return value


def validate_subject_time(value: cd0.Datum, *, projection: bool = False, path: tuple[str, ...] = ("location", "subject-time")) -> cd0.Datum:
    if type(value) is cd0.Unit:
        raise LCIFailure("invalid-input", "UnexpectedUnit", "subject-time", path)
    _closed(value, ("kind", "schema-version", "temporal-model", "expression"), stage="subject-time", prefix=path, namespace=LCI, check_unknown=False)
    _require_kind(value, "subject-time", "InvalidSubjectTime", "subject-time", path)
    _integer_zero(field_by_path(value, "schema-version"), "RecursiveUnsupportedNestedVersion", "subject-time", path + ("schema-version",))
    validate_stable_ref(field_by_path(value, "temporal-model"), path=path + ("temporal-model",))
    if _id_tail(field_by_path(field_by_path(value, "temporal-model"), "domain"))[-1] != "temporal-model":
        raise LCIFailure("invalid-input", "InvalidSubjectTime", "subject-time", path + ("temporal-model",))
    expression = field_by_path(value, "expression")
    form = _validate_versioned_expression(
        expression,
        TEMPORAL_FORMS,
        "subject-time",
        path + ("expression",),
        "temporal-expression",
        invalid_code="InvalidSubjectTime",
    )
    if projection and form == "relative":
        raise LCIFailure("projection-refusal", "UnresolvedRelativeTime", "subject-time", path + ("expression",))
    _closed(expression, TEMPORAL_FORMS[form], stage="subject-time", prefix=path + ("expression",), namespace=FIXTURE_FIELD, check_unknown=False)
    if form == "instant" and type(field_by_path(expression, "tick")) is not cd0.Integer:
        raise LCIFailure("invalid-input", "InvalidSubjectTime", "subject-time", path + ("expression", "tick"))
    if form == "interval":
        start, end = field_by_path(expression, "start"), field_by_path(expression, "end")
        start_closed, end_closed = field_by_path(expression, "start-closed"), field_by_path(expression, "end-closed")
        if type(start) is not cd0.Integer or type(end) is not cd0.Integer or start.value >= end.value:
            raise LCIFailure("invalid-input", "InvalidSubjectTime", "subject-time", path + ("expression",))
        if type(start_closed) is not cd0.Boolean or type(end_closed) is not cd0.Boolean:
            raise LCIFailure("invalid-input", "InvalidSubjectTime", "subject-time", path + ("expression",))
    if form == "periodic-set":
        modulus, remainder = field_by_path(expression, "modulus"), field_by_path(expression, "remainder")
        if type(modulus) is not cd0.Integer or type(remainder) is not cd0.Integer or modulus.value <= 0 or not 0 <= remainder.value < modulus.value:
            raise LCIFailure("invalid-input", "InvalidSubjectTime", "subject-time", path + ("expression",))
    _reject_unknown(expression, TEMPORAL_FORMS[form], stage="subject-time", prefix=path + ("expression",), namespace=FIXTURE_FIELD)
    _reject_unknown(value, ("kind", "schema-version", "temporal-model", "expression"), stage="subject-time", prefix=path, namespace=LCI)
    return value


def validate_dataset_slice(value: cd0.Datum, path: tuple[str, ...]) -> cd0.Datum:
    _closed(value, ("kind", "schema-version", "calculus", "expression"), stage="dataset-slice", prefix=path, namespace=LCI, check_unknown=False)
    kind = field_by_path(value, "kind", None)
    if type(kind) is not cd0.Identifier or kind.namespace != TAG or kind.path != ("dataset-slice",):
        raise FixtureAuthorityGap("unsupported fixture dataset-slice shape")
    _integer_zero(field_by_path(value, "schema-version"), "RecursiveUnsupportedNestedVersion", "dataset-slice", path + ("schema-version",))
    validate_stable_ref(field_by_path(value, "calculus"), path=path + ("calculus",))
    if _id_tail(field_by_path(field_by_path(value, "calculus"), "domain"))[-1] != "dataset-slice-calculus":
        raise FixtureAuthorityGap("unsupported fixture dataset-slice calculus")
    form = _validate_versioned_expression(
        field_by_path(value, "expression"),
        SLICE_FORMS,
        "dataset-slice",
        path + ("expression",),
        "dataset-slice-expression",
        invalid_code=None,
    )
    expression = field_by_path(value, "expression")
    _closed(expression, SLICE_FORMS[form], stage="dataset-slice", prefix=path + ("expression",), namespace=FIXTURE_FIELD, check_unknown=False)
    if form == "explicit-members":
        members = field_by_path(expression, "members")
        if type(members) is not cd0.Sequence or not members.items:
            raise FixtureAuthorityGap("unsupported fixture dataset-slice members")
        encoded: list[bytes] = []
        for index, member in enumerate(members.items):
            validate_stable_ref(member, path=path + ("expression", "members", str(index)))
            if _id_tail(field_by_path(member, "domain"))[-1] != "artifact":
                raise FixtureAuthorityGap("unsupported fixture dataset-slice member domain")
            encoded.append(canonical_bytes(member))
        if encoded != sorted(set(encoded)):
            raise FixtureAuthorityGap("unsupported fixture dataset-slice member ordering")
    if form == "predicate":
        predicate = field_by_path(expression, "predicate")
        if (
            type(predicate) is not cd0.Identifier
            or predicate.namespace != FIXTURE
            or predicate.path != ("slice-predicate", "artifact-object-id-prefix")
            or type(field_by_path(expression, "argument")) is not cd0.String
        ):
            raise FixtureAuthorityGap("unsupported fixture dataset-slice predicate")
        evaluation_domain = field_by_path(expression, "evaluation-domain")
        validate_stable_ref(evaluation_domain, path=path + ("expression", "evaluation-domain"))
        if _id_tail(field_by_path(evaluation_domain, "domain"))[-1] != "immutable-corpus-revision":
            raise FixtureAuthorityGap("unsupported fixture dataset-slice evaluation domain")
    _reject_unknown(expression, SLICE_FORMS[form], stage="dataset-slice", prefix=path + ("expression",), namespace=FIXTURE_FIELD)
    _reject_unknown(value, ("kind", "schema-version", "calculus", "expression"), stage="dataset-slice", prefix=path, namespace=LCI)
    return value


def validate_semantic_boundary(value: cd0.Datum, path: tuple[str, ...]) -> cd0.Datum:
    _closed(value, ("kind", "schema-version", "calculus", "expression"), stage="semantic-boundary", prefix=path, namespace=LCI, check_unknown=False)
    kind = field_by_path(value, "kind", None)
    if type(kind) is not cd0.Identifier or kind.namespace != TAG or kind.path != ("semantic-boundary",):
        raise FixtureAuthorityGap("unsupported fixture semantic-boundary shape")
    _integer_zero(field_by_path(value, "schema-version"), "RecursiveUnsupportedNestedVersion", "semantic-boundary", path + ("schema-version",))
    validate_stable_ref(field_by_path(value, "calculus"), path=path + ("calculus",))
    if _id_tail(field_by_path(field_by_path(value, "calculus"), "domain"))[-1] != "semantic-boundary-calculus":
        raise FixtureAuthorityGap("unsupported fixture semantic-boundary calculus")
    form = _validate_versioned_expression(
        field_by_path(value, "expression"),
        BOUNDARY_FORMS,
        "semantic-boundary",
        path + ("expression",),
        "semantic-boundary-expression",
        invalid_code=None,
    )
    expression = field_by_path(value, "expression")
    _closed(expression, BOUNDARY_FORMS[form], stage="semantic-boundary", prefix=path + ("expression",), namespace=FIXTURE_FIELD, check_unknown=False)
    if form == "snapshot-manifest":
        manifest = field_by_path(expression, "manifest")
        validate_stable_ref(manifest, path=path + ("expression", "manifest"))
        if field_by_path(manifest, "domain") != ident(FIXTURE, "domain", "artifact"):
            raise FixtureAuthorityGap("unsupported fixture semantic-boundary manifest")
    if form == "log-horizon":
        stream = field_by_path(expression, "stream")
        validate_stable_ref(stream, path=path + ("expression", "stream"))
        if field_by_path(stream, "domain") != ident(FIXTURE, "domain", "artifact"):
            raise FixtureAuthorityGap("unsupported fixture semantic-boundary stream")
        horizon = field_by_path(expression, "horizon")
        horizon_form = _validate_versioned_expression(
            horizon,
            TEMPORAL_FORMS,
            "subject-time",
            path + ("expression", "horizon"),
            "temporal-expression",
            invalid_code="InvalidSubjectTime",
        )
        _closed(horizon, TEMPORAL_FORMS[horizon_form], stage="subject-time", prefix=path + ("expression", "horizon"), namespace=FIXTURE_FIELD, check_unknown=False)
        _reject_unknown(
            horizon,
            TEMPORAL_FORMS[horizon_form],
            stage="subject-time",
            prefix=path + ("expression", "horizon"),
            namespace=FIXTURE_FIELD,
        )
    if form == "path-root":
        root = scalar(field_by_path(expression, "path"))
        semantics_value = field_by_path(expression, "path-semantics")
        if type(root) is not str or not root.startswith("/") or root == "/" or "//" in root or "/../" in root or root.endswith("/.."):
            raise FixtureAuthorityGap("unsupported fixture semantic-boundary path")
        if (
            type(semantics_value) is not cd0.Identifier
            or semantics_value.namespace != FIXTURE
            or semantics_value.path != ("path-semantics", "posix-absolute-byte-exact-utf8")
        ):
            raise FixtureAuthorityGap("unsupported fixture semantic-boundary path semantics")
    _reject_unknown(expression, BOUNDARY_FORMS[form], stage="semantic-boundary", prefix=path + ("expression",), namespace=FIXTURE_FIELD)
    _reject_unknown(value, ("kind", "schema-version", "calculus", "expression"), stage="semantic-boundary", prefix=path, namespace=LCI)
    return value


def validate_basis(value: cd0.Datum, *, projection: bool = False, path: tuple[str, ...] = ("location", "basis")) -> cd0.Datum:
    base = ("kind", "schema-version", "mode")
    _closed(
        value,
        base,
        required=base,
        stage="basis",
        prefix=path,
        namespace=LCI,
        check_unknown=False,
    )
    mode = field_by_path(value, "mode", None)
    variant = (
        mode.path[0]
        if type(mode) is cd0.Identifier
        and mode.namespace == TAG
        and mode.path in (("world",), ("corpus",))
        else None
    )
    if variant == "world":
        allowed = ("kind", "schema-version", "mode", "parameters")
    elif variant == "corpus":
        allowed = ("kind", "schema-version", "mode", "corpus", "revision", "slice", "semantic-boundary")
    else:
        allowed = base
    _closed(value, allowed, stage="basis", prefix=path, namespace=LCI, check_unknown=False)
    _require_kind(value, "claim-basis", "InvalidBasis", "basis", path)
    _integer_zero(field_by_path(value, "schema-version"), "RecursiveUnsupportedNestedVersion", "basis", path + ("schema-version",))
    if variant is None:
        raise LCIFailure("invalid-input", "InvalidBasis", "basis", path + ("mode",))
    if variant == "world":
        if type(field_by_path(value, "parameters")) is not cd0.Record or len(field_by_path(value, "parameters").fields):
            raise LCIFailure("invalid-input", "InvalidBasis", "basis", path + ("parameters",))
    else:
        validate_stable_ref(field_by_path(value, "corpus"), path=path + ("corpus",))
        if _id_tail(field_by_path(field_by_path(value, "corpus"), "domain"))[-1] != "logical-corpus":
            raise LCIFailure("invalid-input", "InvalidBasis", "basis", path + ("corpus",))
        try:
            validate_stable_ref(field_by_path(value, "revision"), path=path + ("revision",))
        except LCIFailure as exc:
            if exc.code == "UnresolvedAlias":
                # N008 freezes the CorpusBasis boundary contract at the
                # revision coordinate.  Generic StableRef validation retains
                # its deeper material/object-id path everywhere else.
                raise LCIFailure(
                    exc.category,
                    exc.code,
                    exc.stage,
                    path + ("revision",),
                    exc.context,
                ) from exc
            raise
        if _id_tail(field_by_path(field_by_path(value, "revision"), "domain"))[-1] != "immutable-corpus-revision":
            raise LCIFailure("invalid-input", "InvalidBasis", "basis", path + ("revision",))
        corpus = field_by_path(value, "corpus")
        revision = field_by_path(value, "revision")
        corpus_material = field_by_path(corpus, "material")
        revision_material = field_by_path(revision, "material")
        corpus_identity = (
            field_by_path(corpus_material, "object-id").path,
            field_by_path(corpus_material, "object-version").value,
        )
        revision_identity = (
            field_by_path(revision_material, "object-id").path,
            field_by_path(revision_material, "object-version").value,
        )
        registered_pairs = {
            (("object", "logical-corpus", "alpha-corpus"), 0): {
                (("object", "immutable-corpus-revision", "alpha-corpus", "revision-3"), 3),
                (("object", "immutable-corpus-revision", "alpha-corpus", "revision-4"), 4),
            },
            (("object", "logical-corpus", "beta-corpus"), 0): {
                (("object", "immutable-corpus-revision", "beta-corpus", "revision-1"), 1),
            },
        }
        if revision_identity not in registered_pairs.get(corpus_identity, set()):
            raise LCIFailure("invalid-input", "InvalidBasis", "basis", path + ("revision",))
        dataset_slice = field_by_path(value, "slice")
        semantic_boundary = field_by_path(value, "semantic-boundary")
        validate_dataset_slice(dataset_slice, path + ("slice",))
        validate_semantic_boundary(semantic_boundary, path + ("semantic-boundary",))

        # The frozen fixture calculus binds the only registered corpus
        # revisions to their slice/boundary coordinates.  This is a named
        # cross-field check, after recursive validation, rather than a lookup
        # or an inference from display text.  InvalidBasis is authorized for
        # the fail-closed result; the exact stage/path for this previously
        # unvectored cross-product remains recorded as authorially unpinned.
        slice_expression = field_by_path(dataset_slice, "expression")
        slice_form = _id_tail(field_by_path(slice_expression, "form"))[-1]
        if slice_form == "predicate" and canonical_bytes(
            field_by_path(slice_expression, "evaluation-domain")
        ) != canonical_bytes(revision):
            raise LCIFailure(
                "invalid-input",
                "InvalidBasis",
                "basis",
                path + ("slice", "expression", "evaluation-domain"),
            )

        boundary_expression = field_by_path(semantic_boundary, "expression")
        boundary_form = _id_tail(field_by_path(boundary_expression, "form"))[-1]
        registered_boundary_forms = {
            (("object", "immutable-corpus-revision", "alpha-corpus", "revision-3"), 3): {
                "snapshot-manifest"
            },
            (("object", "immutable-corpus-revision", "alpha-corpus", "revision-4"), 4): {
                "snapshot-manifest",
                "path-root",
                "log-horizon",
            },
        }
        if boundary_form not in registered_boundary_forms.get(revision_identity, set()):
            raise LCIFailure(
                "invalid-input",
                "InvalidBasis",
                "basis",
                path + ("semantic-boundary",),
            )
        if boundary_form == "snapshot-manifest":
            manifest = field_by_path(boundary_expression, "manifest")
            manifest_material = field_by_path(manifest, "material")
            manifest_identity = (
                field_by_path(manifest_material, "object-id").path,
                field_by_path(manifest_material, "object-version").value,
            )
            expected_manifests = {
                (("object", "immutable-corpus-revision", "alpha-corpus", "revision-3"), 3): (
                    ("object", "artifact", "manifest", "alpha", "3"),
                    0,
                ),
                (("object", "immutable-corpus-revision", "alpha-corpus", "revision-4"), 4): (
                    ("object", "artifact", "manifest", "alpha", "4"),
                    0,
                ),
            }
            if manifest_identity != expected_manifests.get(revision_identity):
                raise LCIFailure(
                    "invalid-input",
                    "InvalidBasis",
                    "basis",
                    path + ("semantic-boundary", "expression", "manifest"),
                )
    _reject_unknown(value, allowed, stage="basis", prefix=path, namespace=LCI)
    return value


def validate_frame(value: cd0.Datum, path: tuple[str, ...] = ("location", "interpretation-frame")) -> cd0.Datum:
    _closed(
        value,
        ("kind", "schema-version", "frame-schema", "components"),
        stage="interpretation-frame",
        prefix=path,
        namespace=LCI,
        check_unknown=False,
    )
    _require_kind(value, "interpretation-frame", "InvalidInterpretationFrame", "interpretation-frame", path)
    _integer_zero(field_by_path(value, "schema-version"), "RecursiveUnsupportedNestedVersion", "interpretation-frame", path + ("schema-version",))
    validate_stable_ref(field_by_path(value, "frame-schema"), path=path + ("frame-schema",))
    if _id_tail(field_by_path(field_by_path(value, "frame-schema"), "domain"))[-1] != "interpretation-frame-schema":
        raise LCIFailure("invalid-input", "InvalidInterpretationFrame", "interpretation-frame", path + ("frame-schema",))
    components = field_by_path(value, "components")
    if type(components) is not cd0.Record:
        raise LCIFailure("invalid-input", "InvalidInterpretationFrame", "interpretation-frame", path + ("components",))
    allowed = ("ontology", "unit-system", "schema-edition", "language-semantics", "evaluator-semantics")
    if len(components.fields):
        _closed(
            components,
            allowed,
            stage="interpretation-frame",
            prefix=path + ("components",),
            namespace=FIXTURE_FIELD,
            check_unknown=False,
        )
        ontology = field_by_path(components, "ontology")
        validate_stable_ref(ontology, path=path + ("components", "ontology"))
        if field_by_path(ontology, "domain") != ident(FIXTURE, "domain", "artifact"):
            raise LCIFailure(
                "invalid-input",
                "InvalidInterpretationFrame",
                "interpretation-frame",
                path + ("components", "ontology"),
            )
        exact_identifiers = {
            "unit-system": {("unit-system", "si"), ("unit-system", "imperial")},
            "schema-edition": {("schema-edition", "measurement-v1"), ("schema-edition", "measurement-v2")},
            "language-semantics": {("language-semantics", "fixture-literal-v0")},
            "evaluator-semantics": {("evaluator-semantics", "fixture-inert-v0")},
        }
        for name, accepted_paths in exact_identifiers.items():
            item = field_by_path(components, name)
            if type(item) is not cd0.Identifier or item.namespace != FIXTURE or item.path not in accepted_paths:
                raise LCIFailure(
                    "invalid-input",
                    "InvalidInterpretationFrame",
                    "interpretation-frame",
                    path + ("components", name),
                )
        _reject_unknown(
            components,
            allowed,
            stage="interpretation-frame",
            prefix=path + ("components",),
            namespace=FIXTURE_FIELD,
        )
    _reject_unknown(
        value,
        ("kind", "schema-version", "frame-schema", "components"),
        stage="interpretation-frame",
        prefix=path,
        namespace=LCI,
    )
    return value


PROPOSITION_ARGUMENTS = {
    "file-exists": ("artifact", "scope-locator", "subject-time-locator", "basis-locator", "frame-locator"),
    "exact-equality": ("left", "right", "scope-locator", "subject-time-locator", "basis-locator", "frame-locator"),
    "call-result-equality": ("procedure", "input", "expected", "scope-locator", "subject-time-locator", "basis-locator", "frame-locator"),
    "universal-property-over-scope": ("predicate", "quantified-domain", "subject-time-locator", "basis-locator", "frame-locator"),
    "existential-property": ("predicate", "quantified-domain", "subject-time-locator", "basis-locator", "frame-locator"),
    "average-statistical-value": ("measure", "expected", "unit", "population-domain", "subject-time-locator", "basis-locator", "frame-locator"),
    "bounded-corpus-absence": ("query", "scope-locator", "subject-time-locator", "corpus-locator", "dataset-slice-locator", "semantic-boundary-locator", "frame-locator"),
    "artifact-contains-says": ("artifact", "content", "scope-locator", "subject-time-locator", "basis-locator", "frame-locator"),
    "producer-returned-value": ("producer", "invocation", "value", "scope-locator", "subject-time-locator", "basis-locator", "frame-locator"),
    "translation-ambiguity": ("source-text", "source-language", "target-language", "candidate-readings", "ambiguity-mode", "scope-locator", "subject-time-locator", "basis-locator", "frame-locator"),
    "probabilistic-claim": ("embedded-proposition", "probability", "uncertainty-model", "scope-locator", "subject-time-locator", "basis-locator", "frame-locator"),
}

LOCATOR_RULES = {
    "scope-locator": ("scope", "claim-scope"),
    "subject-time-locator": ("subject-time", "proposition-subject-time"),
    "basis-locator": ("basis", "claim-basis"),
    "frame-locator": ("interpretation-frame", "claim-interpretation-frame"),
    "quantified-domain": ("scope", "quantified-domain"),
    "population-domain": ("scope", "population-domain"),
    "corpus-locator": ("basis", "logical-corpus-and-revision"),
    "dataset-slice-locator": ("dataset-slice", "claim-dataset-slice"),
    "semantic-boundary-locator": ("semantic-boundary", "bounded-search-horizon"),
}


def validate_proposition(value: cd0.Datum, *, projection: bool = False) -> cd0.Datum:
    if type(value) is not cd0.Record:
        raise LCIFailure(
            "projection-refusal" if projection else "invalid-input",
            "UnnormalizedProposition",
            "proposition",
            ("proposition",),
        )
    _closed(
        value,
        ("kind", "schema-version", "form", "arguments"),
        stage="proposition",
        prefix=("proposition",),
        namespace=MNEME_PROPOSITION_FIELD,
        check_unknown=False,
    )
    _require_kind(
        value,
        "mneme-fixture-proposition",
        "InvalidProposition",
        "proposition",
        ("proposition",),
        namespace=FIXTURE,
    )
    _integer_zero(field_by_path(value, "schema-version"), "UnsupportedClaimProfile", "claim-profile", ("proposition", "schema-version"))
    form_value = field_by_path(value, "form")
    if (
        type(form_value) is not cd0.Identifier
        or form_value.namespace != FIXTURE
        or len(form_value.path) != 2
        or form_value.path[0] != "proposition-form"
        or form_value.path[1] not in PROPOSITION_ARGUMENTS
    ):
        raise LCIFailure("projection-refusal" if projection else "invalid-input", "UnnormalizedProposition", "proposition", ("proposition",))
    form = form_value.path[1]
    arguments = field_by_path(value, "arguments")
    expected = PROPOSITION_ARGUMENTS[form]
    try:
        _closed(
            arguments,
            expected,
            stage="proposition",
            prefix=("proposition", "arguments"),
            namespace=MNEME_PROPOSITION_ARGUMENT,
            check_unknown=False,
        )
    except LCIFailure as exc:
        if projection:
            raise LCIFailure("projection-refusal", "UnnormalizedProposition", "proposition", ("proposition",)) from exc
        raise
    for name in expected:
        argument = field_by_path(arguments, name)
        _closed(
            argument,
            ("kind", "schema-version", "placement", "value"),
            stage="proposition",
            prefix=("proposition", "arguments", name),
            namespace=MNEME_PROPOSITION_FIELD,
            check_unknown=False,
        )
        _require_kind(
            argument,
            "proposition-argument",
            "InvalidProposition",
            "proposition",
            ("proposition", "arguments", name),
            namespace=FIXTURE,
        )
        _integer_zero(field_by_path(argument, "schema-version"), "RecursiveUnsupportedNestedVersion", "proposition", ("proposition", "arguments", name, "schema-version"))
        placement_value = field_by_path(argument, "placement")
        should_locator = name.endswith("locator") or name in {"quantified-domain", "population-domain"}
        expected_placement = "external-claim-location-locator" if should_locator else "proposition-subject-content"
        if (
            type(placement_value) is not cd0.Identifier
            or placement_value.namespace != FIXTURE
            or placement_value.path != ("proposition-placement", expected_placement)
        ):
            raise LCIFailure(
                "projection-refusal",
                "PropositionLocationInconsistent",
                "proposition",
                ("proposition", "arguments", name, "placement"),
            )
        if should_locator:
            locator = field_by_path(argument, "value")
            locator_path = ("proposition", "arguments", name, "value")
            try:
                _closed(
                    locator,
                    ("kind", "schema-version", "coordinate", "locator-role"),
                    stage="proposition",
                    prefix=locator_path,
                    namespace=MNEME_PROPOSITION_FIELD,
                    check_unknown=False,
                )
                _require_kind(
                    locator,
                    "locator-slot",
                    "PropositionLocationInconsistent",
                    "proposition",
                    locator_path,
                    namespace=FIXTURE,
                )
                _integer_zero(field_by_path(locator, "schema-version"), "RecursiveUnsupportedNestedVersion", "proposition", locator_path + ("schema-version",))
                coordinate, role = LOCATOR_RULES[name]
                coordinate_value = field_by_path(locator, "coordinate")
                role_value = field_by_path(locator, "locator-role")
                actual_coordinate = (
                    coordinate_value.path[1]
                    if type(coordinate_value) is cd0.Identifier
                    and coordinate_value.namespace == FIXTURE
                    and len(coordinate_value.path) == 2
                    and coordinate_value.path[0] == "locator-coordinate"
                    else None
                )
                actual_role = (
                    role_value.path[1]
                    if type(role_value) is cd0.Identifier
                    and role_value.namespace == FIXTURE
                    and len(role_value.path) == 2
                    and role_value.path[0] == "locator-role"
                    else None
                )
            except LCIFailure as exc:
                if exc.code == "RecursiveUnsupportedNestedVersion":
                    raise
                raise LCIFailure("projection-refusal", "PropositionLocationInconsistent", "proposition", locator_path) from exc
            if (actual_coordinate, actual_role) != (coordinate, role):
                raise LCIFailure("projection-refusal", "PropositionLocationInconsistent", "proposition", locator_path)
            _reject_unknown(
                locator,
                ("kind", "schema-version", "coordinate", "locator-role"),
                stage="proposition",
                prefix=locator_path,
                namespace=MNEME_PROPOSITION_FIELD,
            )
        _reject_unknown(
            argument,
            ("kind", "schema-version", "placement", "value"),
            stage="proposition",
            prefix=("proposition", "arguments", name),
            namespace=MNEME_PROPOSITION_FIELD,
        )
    _reject_unknown(
        arguments,
        expected,
        stage="proposition",
        prefix=("proposition", "arguments"),
        namespace=MNEME_PROPOSITION_ARGUMENT,
    )
    _reject_unknown(
        value,
        ("kind", "schema-version", "form", "arguments"),
        stage="proposition",
        prefix=("proposition",),
        namespace=MNEME_PROPOSITION_FIELD,
    )
    return value


def normalize_proposition(value: cd0.Datum) -> cd0.Datum:
    """Normalize the frozen fixture grammar (already in its unique normal form)."""

    with operation_resource_guard(value, stage="normalization"):
        normalized = validate_proposition(value)
        _check_operation_work(
            "proposition-normalization-work",
            proposition_normalization_work(value, normalized),
            stage="normalization",
            path=("proposition",),
        )
        return normalized


def validate_location(value: cd0.Datum, *, projection: bool = False) -> cd0.Datum:
    _closed(
        value,
        ("kind", "scope", "subject-time", "basis", "interpretation-frame", "profile-location"),
        stage="location-shape",
        prefix=("location",),
        namespace=LCI,
        check_unknown=False,
    )
    _require_kind(value, "claim-location", "InvalidClaimRecord", "location-shape", ("location",))
    validate_scope(field_by_path(value, "scope"))
    validate_subject_time(field_by_path(value, "subject-time"), projection=projection)
    validate_basis(field_by_path(value, "basis"), projection=projection)
    validate_frame(field_by_path(value, "interpretation-frame"))
    profile = field_by_path(value, "profile-location")
    if type(profile) is not cd0.Record:
        raise FixtureAuthorityGap("unsupported fixture profile-location shape")
    # Mneme/0 reserves exactly Record{} here.  N009 carries an author-supplied
    # tagged witness solely to pin the more specific nested-unknown diagnostic;
    # that diagnostic does not authorize the tagged carrier itself.
    if len(profile.fields):
        kind = field_by_path(profile, "kind", None)
        schema_version = field_by_path(profile, "schema-version", None)
        coordinates = field_by_path(profile, "coordinates", None)
        names = _path_names(
            profile,
            namespace=LCI,
            stage="profile-location",
            prefix=("location", "profile-location"),
        )
        if (
            set(names) == {"kind", "schema-version", "coordinates"}
            and type(kind) is cd0.Identifier
            and kind.namespace == TAG
            and kind.path == ("profile-location",)
            and type(schema_version) is cd0.Integer
            and schema_version.value == 0
            and type(coordinates) is cd0.Record
            and coordinates.fields
        ):
            coordinate_names = _path_names(
                coordinates,
                namespace=FIXTURE_FIELD,
                stage="profile-location",
                prefix=("location", "profile-location", "coordinates"),
            )
            raise LCIFailure(
                "invalid-input",
                "UnknownField",
                "profile-location",
                (
                    "location",
                    "profile-location",
                    "coordinates",
                    f"fixture-field:{coordinate_names[0]}",
                ),
            )
        raise LCIFailure(
            "invalid-input",
            "UnknownField",
            "profile-location",
            ("location", "profile-location", names[0]),
        )
    _reject_unknown(
        value,
        ("kind", "scope", "subject-time", "basis", "interpretation-frame", "profile-location"),
        stage="location-shape",
        prefix=("location",),
        namespace=LCI,
    )
    return value


def validate_proposition_location_consistency(proposition: cd0.Datum, location: cd0.Datum) -> None:
    """Enforce the fixture profile's identity-coordinate ownership rules."""

    form = _id_tail(field_by_path(proposition, "form"))[-1]
    basis = field_by_path(location, "basis")
    basis_mode = _id_tail(field_by_path(basis, "mode"))[-1]
    if form == "bounded-corpus-absence":
        if basis_mode != "corpus":
            raise LCIFailure("projection-refusal", "PropositionLocationInconsistent", "basis", ("location", "basis"))
        boundary = field_by_path(basis, "semantic-boundary")
        boundary_form = _id_tail(field_by_path(field_by_path(boundary, "expression"), "form"))[-1]
        time_form = _id_tail(
            field_by_path(field_by_path(field_by_path(location, "subject-time"), "expression"), "form")
        )[-1]
        if time_form != "atemporal" and boundary_form != "log-horizon":
            raise LCIFailure(
                "projection-refusal",
                "PropositionLocationInconsistent",
                "basis",
                ("location", "basis", "semantic-boundary"),
            )


def validate_claim_id(value: cd0.Datum, *, projection: bool = False) -> cd0.Datum:
    _closed(
        value,
        ("kind", "lci-version", "identity-policy", "claim-profile", "proposition", "location"),
        stage="claim-shape",
        namespace=LCI,
        check_unknown=False,
    )
    _require_kind(value, "claim-id-envelope", "InvalidClaimRecord", "claim-shape", ())
    _integer_zero(field_by_path(value, "lci-version"), "UnsupportedLCIVersion", "lci-version", ("lci-version",))
    policy = field_by_path(value, "identity-policy")
    _closed(
        policy,
        ("kind", "policy-id", "policy-version"),
        stage="identity-policy",
        prefix=("identity-policy",),
        namespace=LCI,
        check_unknown=False,
    )
    _require_kind(policy, "identity-policy", "UnsupportedIdentityPolicy", "identity-policy", ("identity-policy",))
    policy_id = field_by_path(policy, "policy-id")
    if type(policy_id) is not cd0.Identifier or policy_id.namespace != ("lisp-plus", "lci") or policy_id.path != ("located-claim-identity",):
        raise LCIFailure("unsupported-version-or-profile", "UnsupportedIdentityPolicy", "identity-policy", ("identity-policy", "policy-id"))
    _integer_zero(field_by_path(policy, "policy-version"), "UnsupportedIdentityPolicy", "identity-policy", ("identity-policy", "policy-version"))
    _reject_unknown(
        policy,
        ("kind", "policy-id", "policy-version"),
        stage="identity-policy",
        prefix=("identity-policy",),
        namespace=LCI,
    )
    profile = field_by_path(value, "claim-profile")
    _closed(
        profile,
        ("kind", "profile-id", "profile-version"),
        stage="claim-profile",
        prefix=("claim-profile",),
        namespace=LCI,
        check_unknown=False,
    )
    _require_kind(profile, "claim-profile", "UnsupportedClaimProfile", "claim-profile", ("claim-profile",))
    profile_id = field_by_path(profile, "profile-id")
    if type(profile_id) is not cd0.Identifier or profile_id.namespace != ("lisp-plus", "mneme") or profile_id.path != ("located-claim",):
        raise LCIFailure("unsupported-version-or-profile", "UnsupportedClaimProfile", "claim-profile", ("claim-profile", "profile-id"))
    _integer_zero(field_by_path(profile, "profile-version"), "UnsupportedClaimProfile", "claim-profile", ("claim-profile", "profile-version"))
    _reject_unknown(
        profile,
        ("kind", "profile-id", "profile-version"),
        stage="claim-profile",
        prefix=("claim-profile",),
        namespace=LCI,
    )
    validate_proposition(field_by_path(value, "proposition"), projection=projection)
    validate_location(field_by_path(value, "location"), projection=projection)
    _reject_unknown(
        value,
        ("kind", "lci-version", "identity-policy", "claim-profile", "proposition", "location"),
        stage="claim-shape",
        namespace=LCI,
    )
    validate_proposition_location_consistency(field_by_path(value, "proposition"), field_by_path(value, "location"))
    return value


CLAIM_OCCURRENCE_FIELDS = (
    "kind",
    "schema-version",
    "semantic-claim-core",
    "claimant",
    "assertion-time",
    "provenance",
    "lineage",
    "cached-claim-id",
    "presentation",
    "nonidentity-metadata",
)


def project_claim_id(value: Any) -> ClaimIdEnvelope:
    """Pure ClaimId projection; no cache, digest, ambient state, or lookup."""

    if isinstance(value, ClaimIdEnvelope):
        resource_source = value.datum
    elif type(value) is cd0.Record:
        resource_source = value
    else:
        resource_source = getattr(value, "_lci_source_datum", None)
        if resource_source is None:
            raise FixtureAuthorityGap("unsupported host projection input")

    with operation_resource_guard(resource_source, stage="projection"):
        projection_core = None
        if isinstance(value, ClaimIdEnvelope):
            datum = value.datum
        elif type(value) is cd0.Record:
            kind = field_by_path(value, "kind", None)
            if (
                type(kind) is cd0.Identifier
                and kind.namespace == TAG
                and kind.path == ("claim-id-envelope",)
            ):
                datum = value
            else:
                core_fields = ("identity-policy", "claim-profile", "proposition", "location")
                _closed(
                    value,
                    core_fields,
                    stage="claim-shape",
                    namespace=LCI,
                    check_unknown=False,
                )
                projection_core = value
                datum = cd0.record(
                    (
                        record_field(LCI, "kind", ident(TAG, "claim-id-envelope")),
                        record_field(LCI, "lci-version", cd0.integer(0)),
                        record_field(LCI, "identity-policy", field_by_path(value, "identity-policy")),
                        record_field(LCI, "claim-profile", field_by_path(value, "claim-profile")),
                        record_field(LCI, "proposition", field_by_path(value, "proposition")),
                        record_field(LCI, "location", field_by_path(value, "location")),
                    )
                )
        else:
            # Mutable test views carry an immutable source datum.  Only explicit
            # mutations are interpreted; no semantic field is inferred.
            source = resource_source
            unknown = set(value) - {"kind", "lci-version", "identity-policy", "claim-profile", "proposition", "location"}
            if unknown:
                raise LCIFailure("invalid-input", "UnknownField", "claim-shape", (sorted(unknown)[0],))
            if getattr(value, "_nested_version_changed", False):
                raise LCIFailure("unsupported-version-or-profile", "RecursiveUnsupportedNestedVersion", "scope", ("location", "scope", "schema-version"))
            datum = source
            coordinate_override = getattr(value, "_lci_coordinate_override", None)
            if coordinate_override is not None:
                coordinate, replacement_value = coordinate_override
                location = field_by_path(datum, "location")
                replaced_location = replace_record_field(location, coordinate, replacement_value)
                datum = replace_record_field(datum, "location", replaced_location)

        validate_claim_id(datum, projection=True)
        if projection_core is not None:
            _reject_unknown(
                projection_core,
                ("identity-policy", "claim-profile", "proposition", "location"),
                stage="claim-shape",
                namespace=LCI,
            )
        proposition = field_by_path(datum, "proposition")
        _check_operation_work(
            "proposition-normalization-work",
            proposition_normalization_work(proposition, proposition),
            stage="projection",
            path=("proposition",),
        )
        octets = canonical_bytes(datum)
    return ClaimIdEnvelope(datum, octets)


def replace_record_field(value: cd0.Datum, name: str, replacement_value: cd0.Datum) -> cd0.Record:
    if type(value) is not cd0.Record:
        raise FixtureAuthorityGap("unsupported fixture record shape")
    found = False
    result: list[tuple[cd0.Identifier, cd0.Datum]] = []
    for key, item in value.fields:
        if key.path == (name,):
            result.append((key, replacement_value))
            found = True
        else:
            result.append((key, item))
    if not found:
        raise LCIFailure("invalid-input", "MissingRequiredField", "shape", (name,))
    return cd0.record(result)


def project_occurrence(value: cd0.Datum) -> ClaimIdEnvelope:
    allowed = CLAIM_OCCURRENCE_FIELDS
    _closed(
        value,
        allowed,
        stage="claim-shape",
        namespace=FIXTURE_FIELD,
        check_unknown=False,
    )
    _require_kind(value, "full-claim-occurrence", "InvalidClaimRecord", "claim-shape", (), namespace=FIXTURE)
    _integer_zero(field_by_path(value, "schema-version"), "RecursiveUnsupportedNestedVersion", "claim-shape", ("schema-version",))
    projected = project_claim_id(field_by_path(value, "semantic-claim-core"))
    claimant = field_by_path(value, "claimant")
    validate_stable_ref(claimant, path=("claimant",))
    if field_by_path(claimant, "domain") != ident(FIXTURE, "domain", "principal"):
        raise LCIFailure("invalid-input", "InvalidClaimRecord", "claim-shape", ("claimant",))
    _validate_event_time(
        field_by_path(value, "assertion-time"),
        "assertion-time",
        ("assertion-time",),
        stage="claim-shape",
        code="InvalidClaimRecord",
    )
    provenance = field_by_path(value, "provenance")
    if type(provenance) is not cd0.Sequence:
        raise LCIFailure("invalid-input", "InvalidClaimRecord", "claim-shape", ("provenance",))
    for index, entry in enumerate(provenance.items):
        entry_path = ("provenance", str(index))
        entry_allowed = ("kind", "schema-version", "provenance-kind", "artifact", "note")
        _closed(entry, entry_allowed, stage="claim-shape", prefix=entry_path, namespace=FIXTURE_FIELD, check_unknown=False)
        _require_kind(entry, "provenance-entry", "InvalidClaimRecord", "claim-shape", entry_path, namespace=FIXTURE)
        _integer_zero(field_by_path(entry, "schema-version"), "RecursiveUnsupportedNestedVersion", "claim-shape", entry_path + ("schema-version",))
        provenance_kind = field_by_path(entry, "provenance-kind")
        if (
            type(provenance_kind) is not cd0.Identifier
            or provenance_kind.namespace != FIXTURE
            or provenance_kind.path not in {
                ("provenance-kind", "source-artifact"),
                ("provenance-kind", "correction"),
            }
        ):
            raise LCIFailure("invalid-input", "InvalidClaimRecord", "claim-shape", entry_path + ("provenance-kind",))
        artifact = field_by_path(entry, "artifact")
        validate_stable_ref(artifact, path=entry_path + ("artifact",))
        if field_by_path(artifact, "domain") != ident(FIXTURE, "domain", "artifact") or type(field_by_path(entry, "note")) is not cd0.String:
            raise LCIFailure("invalid-input", "InvalidClaimRecord", "claim-shape", entry_path)
        _reject_unknown(entry, entry_allowed, stage="claim-shape", prefix=entry_path, namespace=FIXTURE_FIELD)
    lineage = field_by_path(value, "lineage")
    if type(lineage) is not cd0.Sequence:
        raise LCIFailure("invalid-input", "InvalidClaimRecord", "claim-shape", ("lineage",))
    for index, entry in enumerate(lineage.items):
        entry_path = ("lineage", str(index))
        entry_allowed = ("kind", "schema-version", "relation", "predecessor")
        _closed(entry, entry_allowed, stage="claim-shape", prefix=entry_path, namespace=FIXTURE_FIELD, check_unknown=False)
        _require_kind(entry, "lineage-entry", "InvalidClaimRecord", "claim-shape", entry_path, namespace=FIXTURE)
        _integer_zero(field_by_path(entry, "schema-version"), "RecursiveUnsupportedNestedVersion", "claim-shape", entry_path + ("schema-version",))
        relation = field_by_path(entry, "relation")
        if (
            type(relation) is not cd0.Identifier
            or relation.namespace != FIXTURE
            or relation.path not in {
                ("lineage-relation", "independent-reassertion"),
                ("lineage-relation", "corrects"),
            }
        ):
            raise LCIFailure("invalid-input", "InvalidClaimRecord", "claim-shape", entry_path + ("relation",))
        predecessor = field_by_path(entry, "predecessor")
        validate_stable_ref(predecessor, path=entry_path + ("predecessor",))
        if field_by_path(predecessor, "domain") != ident(FIXTURE, "domain", "artifact"):
            raise LCIFailure("invalid-input", "InvalidClaimRecord", "claim-shape", entry_path + ("predecessor",))
        _reject_unknown(entry, entry_allowed, stage="claim-shape", prefix=entry_path, namespace=FIXTURE_FIELD)
    cached = field_by_path(value, "cached-claim-id")
    validate_claim_id(cached)
    presentation = field_by_path(value, "presentation")
    presentation_allowed = ("kind", "schema-version", "title", "surface")
    _closed(presentation, presentation_allowed, stage="claim-shape", prefix=("presentation",), namespace=FIXTURE_FIELD, check_unknown=False)
    _require_kind(presentation, "claim-presentation", "InvalidClaimRecord", "claim-shape", ("presentation",), namespace=FIXTURE)
    _integer_zero(field_by_path(presentation, "schema-version"), "RecursiveUnsupportedNestedVersion", "claim-shape", ("presentation", "schema-version"))
    if type(field_by_path(presentation, "title")) is not cd0.String or type(field_by_path(presentation, "surface")) is not cd0.String:
        raise LCIFailure("invalid-input", "InvalidClaimRecord", "claim-shape", ("presentation",))
    _reject_unknown(presentation, presentation_allowed, stage="claim-shape", prefix=("presentation",), namespace=FIXTURE_FIELD)
    metadata = field_by_path(value, "nonidentity-metadata")
    metadata_allowed = ("kind", "schema-version", "metadata-schema", "entries")
    _closed(metadata, metadata_allowed, stage="claim-shape", prefix=("nonidentity-metadata",), namespace=FIXTURE_FIELD, check_unknown=False)
    _require_kind(metadata, "nonidentity-metadata", "InvalidClaimRecord", "claim-shape", ("nonidentity-metadata",), namespace=FIXTURE)
    _integer_zero(field_by_path(metadata, "schema-version"), "RecursiveUnsupportedNestedVersion", "claim-shape", ("nonidentity-metadata", "schema-version"))
    metadata_schema = field_by_path(metadata, "metadata-schema")
    if (
        type(metadata_schema) is not cd0.Identifier
        or metadata_schema.namespace != FIXTURE
        or metadata_schema.path != ("metadata-schema", "open-inert-nonidentity", "0")
        or type(field_by_path(metadata, "entries")) is not cd0.Record
    ):
        raise LCIFailure("invalid-input", "InvalidClaimRecord", "claim-shape", ("nonidentity-metadata",))
    _reject_unknown(metadata, metadata_allowed, stage="claim-shape", prefix=("nonidentity-metadata",), namespace=FIXTURE_FIELD)
    for name in _path_names(value, namespace=FIXTURE_FIELD, stage="claim-shape"):
        if name not in allowed:
            raise LCIFailure(
                "invalid-input",
                "UnknownField",
                "claim-shape",
                (f"fixture-field:{name}",),
            )
    if canonical_bytes(cached) != projected.canonical_bytes:
        raise LCIFailure("projection-refusal", "ClaimIdCacheMismatch", "claim-id-cache", ("fixture-field:cached-claim-id",))
    return projected


def claim_ids_equal(left: Any, right: Any) -> bool:
    left_datum = left.datum if isinstance(left, ClaimIdEnvelope) else left
    right_datum = right.datum if isinstance(right, ClaimIdEnvelope) else right
    validate_claim_id(left_datum)
    validate_claim_id(right_datum)
    return canonical_bytes(left_datum) == canonical_bytes(right_datum)


def _ref_id(value: cd0.Datum) -> tuple[str, ...]:
    material = field_by_path(value, "material")
    object_id = field_by_path(material, "object-id")
    return _id_tail(object_id)


def scope_relation(left: cd0.Datum, right: cd0.Datum) -> str:
    validate_scope(left, path=("left",))
    validate_scope(right, path=("right",))
    _check_operation_work(
        "scope-relation-work",
        scope_relation_work(left, right),
        stage="matching",
        path=(),
    )
    if canonical_bytes(field_by_path(left, "calculus")) != canonical_bytes(field_by_path(right, "calculus")):
        raise LCIFailure("relation-undetermined", "ScopeIncompatible", "target-relation", ("right", "calculus"))
    le = field_by_path(left, "expression")
    re = field_by_path(right, "expression")
    if canonical_bytes(le) == canonical_bytes(re):
        return "equal"
    lf = _id_tail(field_by_path(le, "form"))[-1]
    rf = _id_tail(field_by_path(re, "form"))[-1]
    if lf == "universal":
        return "wider"
    if rf == "universal":
        return "narrower"
    if "symbolic-predicate" in {lf, rf}:
        raise LCIFailure("relation-undetermined", "ScopeRelationUnknown", "target-relation", ("fixture-field:right",))
    if (lf == "region-set") != (rf == "region-set"):
        raise LCIFailure("relation-undetermined", "ScopeRelationUnknown", "target-relation", ("fixture-field:right",))
    if lf == "organization" and rf in {"department", "tenant"}:
        return "wider" if canonical_bytes(field_by_path(le, "organization")) == canonical_bytes(field_by_path(re, "organization")) else "disjoint"
    if rf == "organization" and lf in {"department", "tenant"}:
        return "narrower" if canonical_bytes(field_by_path(le, "organization")) == canonical_bytes(field_by_path(re, "organization")) else "disjoint"
    if lf == rf == "region-set":
        ls = {canonical_bytes(item) for item in field_by_path(le, "members").items}
        rs = {canonical_bytes(item) for item in field_by_path(re, "members").items}
        if ls > rs:
            return "wider"
        if ls < rs:
            return "narrower"
        return "overlap" if ls & rs else "disjoint"
    if lf == rf == "tenant":
        return "disjoint"
    if lf == rf == "department":
        return "disjoint"
    if "opaque-token" in {lf, rf}:
        raise LCIFailure("relation-undetermined", "ScopeRelationUnknown", "target-relation", ("fixture-field:right",))
    return "disjoint"


def _temporal_interval(expression: cd0.Datum) -> tuple[int, int, bool, bool] | None:
    form = _id_tail(field_by_path(expression, "form"))[-1]
    if form == "instant":
        tick = scalar(field_by_path(expression, "tick"))
        return tick, tick, True, True
    if form == "interval":
        return (
            scalar(field_by_path(expression, "start")),
            scalar(field_by_path(expression, "end")),
            scalar(field_by_path(expression, "start-closed")),
            scalar(field_by_path(expression, "end-closed")),
        )
    return None


def _before(a: tuple[int, int, bool, bool], b: tuple[int, int, bool, bool]) -> bool:
    return a[1] < b[0] or (a[1] == b[0] and not (a[3] and b[2]))


def _contains(a: tuple[int, int, bool, bool], b: tuple[int, int, bool, bool]) -> bool:
    left = a[0] < b[0] or (a[0] == b[0] and (a[2] or not b[2]))
    right = a[1] > b[1] or (a[1] == b[1] and (a[3] or not b[3]))
    return left and right


def temporal_relation(left: cd0.Datum, right: cd0.Datum) -> str:
    validate_subject_time(left, path=("left",))
    validate_subject_time(right, path=("right",))
    _check_operation_work(
        "temporal-relation-work",
        temporal_relation_work(left, right),
        stage="matching",
        path=(),
    )
    if canonical_bytes(field_by_path(left, "temporal-model")) != canonical_bytes(field_by_path(right, "temporal-model")):
        raise LCIFailure("relation-undetermined", "UnsupportedTemporalModel", "subject-time", ("fixture-field:right", "temporal-model"))
    le = field_by_path(left, "expression")
    re = field_by_path(right, "expression")
    if canonical_bytes(le) == canonical_bytes(re):
        return "equal"
    lf = _id_tail(field_by_path(le, "form"))[-1]
    rf = _id_tail(field_by_path(re, "form"))[-1]
    if "atemporal" in {lf, rf}:
        return "incompatible"
    if "symbolic" in {lf, rf}:
        raise LCIFailure("relation-undetermined", "AdmissibilityUndetermined", "subject-time", (f"fixture-field:{'left' if lf == 'symbolic' else 'right'}",))
    li = _temporal_interval(le)
    ri = _temporal_interval(re)
    if li is not None and ri is not None:
        if _before(li, ri):
            return "before"
        if _before(ri, li):
            return "after"
        if _contains(li, ri):
            return "contains"
        if _contains(ri, li):
            return "contained-by"
        return "overlap"
    if lf == rf == "periodic-set":
        lm, lr = scalar(field_by_path(le, "modulus")), scalar(field_by_path(le, "remainder"))
        rm, rr = scalar(field_by_path(re, "modulus")), scalar(field_by_path(re, "remainder"))
        if lm == rm and lr != rr:
            return "disjoint"
    if lf == rf == "atemporal":
        return "equal"
    raise LCIFailure("relation-undetermined", "AdmissibilityUndetermined", "subject-time", ("fixture-field:left",))


TARGET_REQUIRED_BOUNDARIES = {
    "observed": ("observer-or-instrument", "observation-procedure", "observation-time", "coverage-scope", "observation-mode", "observation-artifact-or-event"),
    "executed": ("procedure-reference", "immutable-code-or-semantics", "invocation", "execution-environment-semantics", "execution-time", "execution-event-or-trace", "coverage-scope"),
    "tested": ("system-or-procedure-under-test", "immutable-tested-version", "test-case-or-suite", "test-input", "expected-relation", "execution-environment-semantics", "execution-time", "test-event-or-trace", "coverage-scope"),
    "derived": ("inference-calculus", "premise-claim-ids", "rule-or-derivation-identity", "derivation-artifact-or-trace", "coverage-scope"),
    "externally-attested": ("external-principal", "external-statement-or-artifact", "attestation-time", "mapping-receipt", "coverage-scope"),
    "replayed": ("predecessor-warrant-testimony-or-event", "replay-procedure", "immutable-code-or-semantics", "replay-invocation", "execution-environment-semantics", "replay-time", "new-replay-trace-or-result", "coverage-scope"),
    "corpus-completion": ("exact-corpus-basis", "search-procedure", "immutable-code-or-semantics", "query-or-search-expression", "coverage-plan", "completion-boundary", "execution-time", "completion-receipt-or-trace", "coverage-scope"),
    "reported": ("reporter-or-source-principal", "source-artifact", "report-time", "content-to-claim-interpretation-receipt", "coverage-scope"),
    "inherited": ("predecessor-occurrence-or-artifact", "predecessor-warrant-testimony", "inheritance-or-handoff-rule", "handoff-freeze-revival-receipt", "represented-loss", "coverage-scope"),
    "translated": ("source-claim-id", "source-interpretation-frame", "target-interpretation-frame", "translation-procedure", "translation-receipt", "represented-loss", "coverage-scope"),
    "policy-evaluation": ("policy", "evaluated-warrant", "state-snapshot", "query-time", "testimony-mode", "inner-target-relation", "coverage-scope"),
}

TARGET_BOUNDARY_TYPES = {
    "observed": ("principal", "procedure", "event:observation-time", "scope", "identifier", "artifact"),
    "executed": ("procedure", "artifact", "prompt-invocation", "module", "event:execution-time", "artifact", "scope"),
    "tested": ("procedure", "artifact", "artifact", "datum", "identifier", "module", "event:test-execution-time", "artifact", "scope"),
    "derived": ("module", "claim-sequence", "procedure", "artifact", "scope"),
    "externally-attested": ("principal", "artifact", "event:attestation-time", "artifact", "scope"),
    "replayed": ("artifact", "procedure", "artifact", "prompt-invocation", "module", "event:replay-time", "artifact", "scope"),
    "corpus-completion": ("corpus-basis", "procedure", "artifact", "proposition", "artifact", "semantic-boundary", "event:search-execution-time", "artifact", "scope"),
    "reported": ("principal", "artifact", "event:report-time", "artifact", "scope"),
    "inherited": ("artifact", "artifact", "policy", "artifact", "represented-loss", "scope"),
    "translated": ("claim", "frame", "frame", "procedure", "artifact", "represented-loss", "scope"),
    "policy-evaluation": ("policy", "artifact", "artifact", "event:policy-query-time", "identifier", "target-relation", "scope"),
}

TARGET_DOWNWARD_MONOTONE_FORMS = {
    "observed": frozenset({"universal-property-over-scope"}),
    "executed": frozenset(),
    "tested": frozenset({"universal-property-over-scope"}),
    "derived": frozenset({"universal-property-over-scope", "bounded-corpus-absence"}),
    "externally-attested": frozenset(),
    "replayed": frozenset({"universal-property-over-scope"}),
    "corpus-completion": frozenset({"bounded-corpus-absence"}),
    "reported": frozenset(),
    "inherited": frozenset(),
    "translated": frozenset(),
    "policy-evaluation": frozenset(),
}

LOSS_ACCOUNT_FIELDS = {
    "v1-migration": ("kind", "schema-version", "account-schema", "source-format", "adapter", "recovered-dimensions", "unresolved-dimensions", "mapping-receipts", "classification"),
    "translation": ("kind", "schema-version", "account-schema", "source-language", "target-language", "lost-features", "preserved-features", "ambiguity-resolved", "translation-receipt"),
    "reconstruction": ("kind", "schema-version", "account-schema", "source-fragments", "recovered-fields", "unresolved-fields", "reconstruction-procedure", "confidence-class"),
    "compaction": ("kind", "schema-version", "account-schema", "removed-metadata-fields", "retained-identity-fields", "reversible", "compaction-procedure"),
    "identifier-mapping": ("kind", "schema-version", "account-schema", "source-identifier", "mapped-identifier", "mapping-table", "mapping-class", "candidate-count"),
    "temporal-role-classification": ("kind", "schema-version", "account-schema", "source-site", "source-value", "selected-role", "classification-table", "ambiguity-class"),
    "handoff": ("kind", "schema-version", "account-schema", "predecessor-occurrence", "handoff-receipt", "live-authority-transferred", "custody-continuity-proven", "successor-live-warrants", "handoff-procedure"),
}

LOSS_ACCOUNT_TYPES = {
    "v1-migration": {
        "source-format": "identifier",
        "adapter": "stable:procedure",
        "recovered-dimensions": "identifiers",
        "unresolved-dimensions": "identifiers",
        "mapping-receipts": "stable-sequence:artifact",
        "classification": "identifier",
    },
    "translation": {
        "source-language": "identifier",
        "target-language": "identifier",
        "lost-features": "identifiers",
        "preserved-features": "identifiers",
        "ambiguity-resolved": "boolean",
        "translation-receipt": "stable:artifact",
    },
    "reconstruction": {
        "source-fragments": "stable-sequence:artifact",
        "recovered-fields": "identifiers",
        "unresolved-fields": "identifiers",
        "reconstruction-procedure": "stable:procedure",
        "confidence-class": "identifier",
    },
    "compaction": {
        "removed-metadata-fields": "identifiers",
        "retained-identity-fields": "identifiers",
        "reversible": "boolean",
        "compaction-procedure": "stable:procedure",
    },
    "identifier-mapping": {
        "source-identifier": "datum",
        "mapped-identifier": "identifier",
        "mapping-table": "stable:artifact",
        "mapping-class": "identifier",
        "candidate-count": "integer",
    },
    "temporal-role-classification": {
        "source-site": "identifier",
        "source-value": "datum",
        "selected-role": "identifier",
        "classification-table": "stable:artifact",
        "ambiguity-class": "identifier",
    },
    "handoff": {
        "predecessor-occurrence": "stable:artifact",
        "handoff-receipt": "stable:artifact",
        "live-authority-transferred": "boolean",
        "custody-continuity-proven": "boolean",
        "successor-live-warrants": "integer",
        "handoff-procedure": "stable:procedure",
    },
}


def _require_stable_domain(
    value: cd0.Datum,
    domain: str,
    path: tuple[str, ...],
    *,
    stage: str = "target-boundaries",
    code: str = "TargetBoundaryMismatch",
) -> None:
    if code not in AUTHORIZED_LCI_FAILURE_CODES:
        raise FixtureIntegrityError("internal validator requested an unauthorized LCI failure code")
    validate_stable_ref(value, path=path)
    if field_by_path(value, "domain") != ident(FIXTURE, "domain", domain):
        raise LCIFailure("invalid-input", code, stage, path)


def _validate_event_time(
    value: cd0.Datum,
    role: str,
    path: tuple[str, ...],
    *,
    stage: str = "target-boundaries",
    code: str = "TargetBoundaryMismatch",
) -> None:
    if code not in AUTHORIZED_LCI_FAILURE_CODES:
        raise FixtureIntegrityError("internal validator requested an unauthorized LCI failure code")
    allowed = ("kind", "schema-version", "temporal-model", "temporal-role", "expression")
    _closed(
        value,
        allowed,
        stage=stage,
        prefix=path,
        namespace=FIXTURE_FIELD,
        check_unknown=False,
    )
    _require_kind(value, "evidence-event-time", code, stage, path, namespace=FIXTURE)
    _integer_zero(field_by_path(value, "schema-version"), "RecursiveUnsupportedNestedVersion", stage, path + ("schema-version",))
    _require_stable_domain(field_by_path(value, "temporal-model"), "temporal-model", path + ("temporal-model",))
    role_value = field_by_path(value, "temporal-role")
    if type(role_value) is not cd0.Identifier or role_value.namespace != FIXTURE or role_value.path != ("temporal-role", role):
        raise LCIFailure("invalid-input", code, stage, path + ("temporal-role",))
    expression = field_by_path(value, "expression")
    form = _validate_versioned_expression(
        expression,
        TEMPORAL_FORMS,
        stage,
        path + ("expression",),
        "temporal-expression",
        invalid_code=code,
    )
    _closed(
        expression,
        TEMPORAL_FORMS[form],
        stage=stage,
        prefix=path + ("expression",),
        namespace=FIXTURE_FIELD,
        check_unknown=False,
    )
    if form == "instant" and type(field_by_path(expression, "tick")) is not cd0.Integer:
        raise LCIFailure("invalid-input", code, stage, path + ("expression", "tick"))
    _reject_unknown(expression, TEMPORAL_FORMS[form], stage=stage, prefix=path + ("expression",), namespace=FIXTURE_FIELD)
    _reject_unknown(value, allowed, stage=stage, prefix=path, namespace=FIXTURE_FIELD)


def validate_loss_account(
    account: cd0.Datum,
    path: tuple[str, ...] = ("account",),
) -> str:
    base = ("kind", "schema-version", "account-schema")
    _closed(
        account,
        base,
        required=base,
        stage="represented-loss",
        prefix=path,
        namespace=FIXTURE_FIELD,
        check_unknown=False,
    )
    schema = field_by_path(account, "account-schema", None)
    operation = (
        schema.path[1]
        if type(schema) is cd0.Identifier
        and schema.namespace == FIXTURE
        and len(schema.path) == 3
        and schema.path[0] == "represented-loss-account-schema"
        and schema.path[2] == "0"
        else None
    )
    fields = LOSS_ACCOUNT_FIELDS.get(operation) if operation is not None else None
    if fields is not None:
        present = _path_names(
            account,
            namespace=FIXTURE_FIELD,
            stage="represented-loss",
            prefix=path,
        )
        for name in fields:
            if name not in present:
                raise LCIFailure(
                    "invalid-input",
                    "MissingRequiredField",
                    "represented-loss",
                    path + (f"fixture-field:{name}",),
                )
    kind = field_by_path(account, "kind", None)
    if (
        type(kind) is not cd0.Identifier
        or kind.namespace != FIXTURE
        or kind.path != ("tag", "represented-loss-account")
    ):
        raise FixtureAuthorityGap("unsupported represented-loss account shape")
    _integer_zero(
        field_by_path(account, "schema-version"),
        "RecursiveUnsupportedNestedVersion",
        "represented-loss",
        path + ("schema-version",),
    )
    if fields is None:
        raise LCIFailure(
            "unsupported-version-or-profile",
            "UnsupportedRepresentedLossAccountSchema",
            "represented-loss",
            path + ("account-schema",),
        )
    assert operation is not None
    for name in fields[3:]:
        item = field_by_path(account, name)
        type_name = LOSS_ACCOUNT_TYPES[operation][name]
        item_path = path + (f"fixture-field:{name}",)
        if type_name == "identifier":
            if type(item) is not cd0.Identifier:
                raise FixtureAuthorityGap("unsupported represented-loss account value")
        elif type_name == "identifiers":
            if type(item) is not cd0.Sequence:
                raise FixtureAuthorityGap("unsupported represented-loss account value")
            for index, member in enumerate(item.items):
                if type(member) is not cd0.Identifier:
                    raise FixtureAuthorityGap("unsupported represented-loss account value")
        elif type_name.startswith("stable:"):
            domain = type_name.split(":", 1)[1]
            validate_stable_ref(item, path=item_path)
            if field_by_path(item, "domain") != ident(FIXTURE, "domain", domain):
                raise FixtureAuthorityGap("unsupported represented-loss stable-reference domain")
        elif type_name.startswith("stable-sequence:"):
            domain = type_name.split(":", 1)[1]
            if type(item) is not cd0.Sequence:
                raise FixtureAuthorityGap("unsupported represented-loss account value")
            for index, member in enumerate(item.items):
                member_path = item_path + (str(index),)
                validate_stable_ref(member, path=member_path)
                if field_by_path(member, "domain") != ident(FIXTURE, "domain", domain):
                    raise FixtureAuthorityGap("unsupported represented-loss stable-reference domain")
        elif type_name == "boolean":
            if type(item) is not cd0.Boolean:
                raise FixtureAuthorityGap("unsupported represented-loss account value")
        elif type_name == "integer":
            if type(item) is not cd0.Integer or item.value < 0:
                raise FixtureAuthorityGap("unsupported represented-loss account value")
        elif type_name != "datum":
            raise FixtureIntegrityError("unknown frozen represented-loss account field type")
    entries = sum(len(item.items) for _, item in account.fields if type(item) is cd0.Sequence)
    if entries > LCI_RESOURCE_LIMITS["represented-loss-account-entries"]:
        _resource_failure(
            "represented-loss-account-entries",
            _current_resource_stage("validation"),
            path,
        )
    present = _path_names(
        account,
        namespace=FIXTURE_FIELD,
        stage="represented-loss",
        prefix=path,
    )
    for name in present:
        if name not in fields:
            raise LCIFailure(
                "invalid-input",
                "UnknownField",
                "represented-loss",
                path + (f"fixture-field:{name}",),
            )
    return operation


def validate_represented_loss(value: cd0.Datum, path: tuple[str, ...] = ("represented-loss",)) -> None:
    allowed = ("kind", "schema-version", "operation", "source", "lost-dimensions", "consequence", "account")
    _closed(
        value,
        allowed,
        stage="represented-loss",
        prefix=path,
        namespace=LCI,
        check_unknown=False,
    )
    kind = field_by_path(value, "kind", None)
    if type(kind) is not cd0.Identifier or kind.namespace != TAG or kind.path != ("represented-loss",):
        raise FixtureAuthorityGap("unsupported represented-loss shape")
    _integer_zero(field_by_path(value, "schema-version"), "RecursiveUnsupportedNestedVersion", "represented-loss", path + ("schema-version",))
    operation_ref = field_by_path(value, "operation")
    validate_stable_ref(operation_ref, path=path + ("operation",))
    if field_by_path(operation_ref, "domain") != ident(FIXTURE, "domain", "procedure"):
        raise FixtureAuthorityGap("unsupported represented-loss operation domain")
    source_ref = field_by_path(value, "source")
    validate_stable_ref(source_ref, path=path + ("source",))
    if field_by_path(source_ref, "domain") != ident(FIXTURE, "domain", "artifact"):
        raise FixtureAuthorityGap("unsupported represented-loss source domain")
    dimensions = field_by_path(value, "lost-dimensions")
    if type(dimensions) is not cd0.Sequence:
        raise FixtureAuthorityGap("unsupported represented-loss dimensions")
    for index, item in enumerate(dimensions.items):
        if (
            type(item) is not cd0.Identifier
            or item.namespace != FIXTURE
            or len(item.path) != 2
            or item.path[0] != "lost-dimension"
        ):
            raise FixtureAuthorityGap("unsupported represented-loss dimension")
    consequence = field_by_path(value, "consequence")
    if type(consequence) is not cd0.Identifier or consequence.namespace != LCI + ("relation",):
        raise FixtureAuthorityGap("unsupported represented-loss consequence")
    account = field_by_path(value, "account")
    account_operation = validate_loss_account(account, path + ("account",))
    _reject_unknown(value, allowed, stage="represented-loss", prefix=path, namespace=LCI)

    operation_id = field_by_path(field_by_path(operation_ref, "material"), "object-id")
    operation_leaf = operation_id.path[-1] if type(operation_id) is cd0.Identifier and operation_id.path else None
    operation_accounts = {
        "migrate-v1": "v1-migration",
        "translate": "translation",
        "handoff": "handoff",
    }
    expected_account = operation_accounts.get(operation_leaf)
    if expected_account != account_operation:
        raise FixtureAuthorityGap("unsupported represented-loss account binding")
    expected_dimensions = {
        "v1-migration": ("source-record-field-order",),
        "translation": ("lexical-sense-resolution",),
        "handoff": ("live-authority", "custody-continuity"),
    }[account_operation]
    if tuple(item.path[1] for item in dimensions.items) != expected_dimensions:
        raise FixtureAuthorityGap("unsupported represented-loss dimensions")
    expected_consequence = {
        "v1-migration": "identity-neutral-loss",
        "translation": "semantic-translation-loss",
        "handoff": "authority-or-custody-loss",
    }[account_operation]
    if consequence.path != (expected_consequence,):
        raise FixtureAuthorityGap("unsupported represented-loss consequence")
    if account_operation == "v1-migration" and canonical_bytes(operation_ref) != canonical_bytes(field_by_path(account, "adapter")):
        raise FixtureAuthorityGap("unsupported represented-loss adapter binding")
    if account_operation == "handoff":
        if canonical_bytes(operation_ref) != canonical_bytes(field_by_path(account, "handoff-procedure")):
            raise FixtureAuthorityGap("unsupported represented-loss handoff binding")
        if canonical_bytes(source_ref) != canonical_bytes(field_by_path(account, "predecessor-occurrence")):
            raise FixtureAuthorityGap("unsupported represented-loss predecessor binding")


def _validate_target_relation(value: cd0.Datum, path: tuple[str, ...]) -> None:
    allowed = ("kind", "schema-version", "status", "relation")
    _closed(value, allowed, stage="target-boundaries", prefix=path, namespace=FIXTURE_FIELD, check_unknown=False)
    _require_kind(value, "target-relation-result", "TargetBoundaryMismatch", "target-boundaries", path, namespace=FIXTURE)
    _integer_zero(field_by_path(value, "schema-version"), "RecursiveUnsupportedNestedVersion", "target-boundaries", path + ("schema-version",))
    status = field_by_path(value, "status")
    relation = field_by_path(value, "relation")
    if type(status) is not cd0.Identifier or status.namespace != FIXTURE or status.path != ("result-status", "success"):
        raise LCIFailure("invalid-input", "TargetBoundaryMismatch", "target-boundaries", path + ("status",))
    if type(relation) is not cd0.Identifier or relation.namespace != LCI + ("relation",) or relation.path not in (("exact-target",), ("supports-by-scope-narrowing",)):
        raise LCIFailure("invalid-input", "TargetBoundaryMismatch", "target-boundaries", path + ("relation",))
    _reject_unknown(value, allowed, stage="target-boundaries", prefix=path, namespace=FIXTURE_FIELD)


def _validate_target_boundary(value: cd0.Datum, type_name: str, path: tuple[str, ...]) -> None:
    if type_name in STABLE_REF_DOMAINS:
        _require_stable_domain(value, type_name, path)
    elif type_name.startswith("event:"):
        _validate_event_time(value, type_name.split(":", 1)[1], path)
    elif type_name == "scope":
        validate_scope(value, path=path)
    elif type_name == "semantic-boundary":
        validate_semantic_boundary(value, path)
    elif type_name == "corpus-basis":
        validate_basis(value, path=path)
        mode = field_by_path(value, "mode")
        if type(mode) is not cd0.Identifier or mode.namespace != TAG or mode.path != ("corpus",):
            raise LCIFailure("invalid-input", "TargetBoundaryMismatch", "target-boundaries", path)
    elif type_name == "proposition":
        validate_proposition(value)
    elif type_name == "claim":
        validate_claim_id(value)
    elif type_name == "claim-sequence":
        if type(value) is not cd0.Sequence:
            raise LCIFailure("invalid-input", "TargetBoundaryMismatch", "target-boundaries", path)
        for index, claim in enumerate(value.items):
            validate_claim_id(claim)
    elif type_name == "frame":
        validate_frame(value, path)
    elif type_name == "represented-loss":
        validate_represented_loss(value, path)
    elif type_name == "target-relation":
        _validate_target_relation(value, path)
    elif type_name == "identifier":
        if type(value) is not cd0.Identifier:
            raise LCIFailure("invalid-input", "TargetBoundaryMismatch", "target-boundaries", path)
    elif type_name != "datum":
        raise FixtureIntegrityError("unknown frozen target-boundary field type")


def validate_warrant_target(value: cd0.Datum) -> cd0.Datum:
    if type(value) is cd0.Record:
        preliminary_names = {
            key.path[0]
            for key, _ in value.fields
            if key.namespace == LCI and len(key.path) == 1
        }
        if "claim" not in preliminary_names and "legacy-fingerprint" in preliminary_names:
            raise LCIFailure("migration-refusal", "LegacyFingerprintNotClaimId", "target-shape", ("claim",))
    allowed = ("kind", "lci-version", "target-kind", "target-schema", "claim", "boundaries")
    _closed(
        value,
        allowed,
        stage="target-shape",
        namespace=LCI,
        check_unknown=False,
    )
    _require_kind(value, "warrant-target", "InvalidWarrantTarget", "target-shape", ())
    _integer_zero(field_by_path(value, "lci-version"), "UnsupportedLCIVersion", "lci-version", ("lci-version",))
    kind_value = field_by_path(value, "target-kind")
    if type(kind_value) is not cd0.Identifier or kind_value.namespace != FIXTURE or len(kind_value.path) != 2 or kind_value.path[0] != "target-kind" or kind_value.path[1] not in TARGET_REQUIRED_BOUNDARIES:
        raise LCIFailure("invalid-input", "UnsupportedTargetKind", "target-shape", ("target-kind",))
    target_kind = kind_value.path[1]
    target_schema = field_by_path(value, "target-schema")
    _require_stable_domain(target_schema, "module", ("target-schema",))

    claim = field_by_path(value, "claim")
    if type(claim) is not cd0.Record or field_by_path(claim, "kind", None) != ident(TAG, "claim-id-envelope"):
        raise LCIFailure("migration-refusal", "LegacyFingerprintNotClaimId", "target-shape", ("claim",))
    validate_claim_id(claim)

    boundaries = field_by_path(value, "boundaries")
    if type(boundaries) is not cd0.Record:
        raise LCIFailure("invalid-input", "TargetBoundaryMissing", "target-boundaries", ("boundaries",))
    required_boundaries = TARGET_REQUIRED_BOUNDARIES[target_kind]
    present_boundaries = {
        key.path[0]
        for key, _ in boundaries.fields
        if key.namespace == FIXTURE_FIELD and len(key.path) == 1
    }
    for required in required_boundaries:
        if required not in present_boundaries:
            if target_kind == "executed" and required == "immutable-code-or-semantics":
                raise LCIFailure("reference-refusal", "ProcedureIdentityInsufficient", "target-boundaries", ("boundaries", f"fixture-field:{required}"))
            raise LCIFailure("invalid-input", "TargetBoundaryMissing", "target-boundaries", ("boundaries", f"fixture-field:{required}"))
    boundary_work = target_boundary_work(boundaries)
    if boundary_work > LCI_RESOURCE_LIMITS["target-boundary-work"]:
        _resource_failure(
            "target-boundary-work",
            _current_resource_stage("validation"),
            ("boundaries",),
        )
    for name, type_name in zip(required_boundaries, TARGET_BOUNDARY_TYPES[target_kind]):
        _validate_target_boundary(field_by_path(boundaries, name), type_name, ("boundaries", name))
    for key, _ in boundaries.fields:
        name = key.path[-1] if key.path else "<empty-field-path>"
        if key.namespace != FIXTURE_FIELD or len(key.path) != 1 or name not in required_boundaries:
            raise LCIFailure("invalid-input", "TargetBoundaryUnknown", "target-boundaries", ("boundaries", f"fixture-field:{name}"))
    _reject_unknown(value, allowed, stage="target-shape", namespace=LCI)

    # The registry declares common-envelope coherence checks after all fields.
    material = field_by_path(target_schema, "material")
    object_id = field_by_path(material, "object-id")
    object_version = field_by_path(material, "object-version")
    if (
        type(object_id) is not cd0.Identifier
        or object_id.namespace != FIXTURE
        or object_id.path != ("object", "module", "target-schema", target_kind)
        or type(object_version) is not cd0.Integer
        or object_version.value != 0
    ):
        raise LCIFailure("invalid-input", "TargetSchemaKindMismatch", "target-schema", ("target-schema",))
    return value


def _target_kind_coherence(target: cd0.Datum, target_kind: str) -> None:
    boundaries = field_by_path(target, "boundaries")
    claim = field_by_path(target, "claim")
    proposition = field_by_path(claim, "proposition")
    location = field_by_path(claim, "location")
    proposition_form = _id_tail(field_by_path(proposition, "form"))[-1]

    if target_kind == "executed" and proposition_form == "call-result-equality":
        procedure_argument = field_by_path(
            field_by_path(field_by_path(proposition, "arguments"), "procedure"),
            "value",
        )
        if canonical_bytes(procedure_argument) != canonical_bytes(
            field_by_path(boundaries, "procedure-reference")
        ):
            raise LCIFailure(
                "target-mismatch",
                "ProcedureMismatch",
                "target-boundaries",
                ("boundaries", "fixture-field:procedure-reference"),
            )

    if target_kind == "corpus-completion":
        claim_basis = field_by_path(location, "basis")
        exact_basis = field_by_path(boundaries, "exact-corpus-basis")
        if canonical_bytes(exact_basis) != canonical_bytes(claim_basis):
            raise LCIFailure(
                "target-mismatch",
                "BasisMismatch",
                "target-boundaries",
                ("boundaries", "fixture-field:exact-corpus-basis"),
            )
        if canonical_bytes(field_by_path(boundaries, "query-or-search-expression")) != canonical_bytes(proposition):
            raise LCIFailure(
                "target-mismatch",
                "TargetBoundaryMismatch",
                "target-boundaries",
                ("boundaries", "fixture-field:query-or-search-expression"),
            )
        if canonical_bytes(field_by_path(boundaries, "completion-boundary")) != canonical_bytes(
            field_by_path(claim_basis, "semantic-boundary")
        ):
            raise LCIFailure(
                "target-mismatch",
                "TargetBoundaryMismatch",
                "target-boundaries",
                ("boundaries", "fixture-field:completion-boundary"),
            )
        receipt = field_by_path(boundaries, "completion-receipt-or-trace")
        receipt_id = field_by_path(field_by_path(receipt, "material"), "object-id")
        if "incomplete" in _id_tail(receipt_id):
            raise LCIFailure(
                "target-mismatch",
                "CorpusCompletionInsufficient",
                "target-boundaries",
                ("boundaries", "fixture-field:completion-receipt-or-trace"),
            )

    if target_kind == "translated":
        target_frame = field_by_path(boundaries, "target-interpretation-frame")
        if canonical_bytes(target_frame) != canonical_bytes(field_by_path(location, "interpretation-frame")):
            raise LCIFailure(
                "target-mismatch",
                "TranslationBoundaryMismatch",
                "target-boundaries",
                ("boundaries", "fixture-field:target-interpretation-frame"),
            )
        source_claim = field_by_path(boundaries, "source-claim-id")
        source_frame = field_by_path(boundaries, "source-interpretation-frame")
        if canonical_bytes(source_frame) != canonical_bytes(
            field_by_path(field_by_path(source_claim, "location"), "interpretation-frame")
        ):
            raise LCIFailure(
                "target-mismatch",
                "TranslationBoundaryMismatch",
                "target-boundaries",
                ("boundaries", "fixture-field:source-interpretation-frame"),
            )

    if target_kind == "policy-evaluation":
        testimony_mode = field_by_path(boundaries, "testimony-mode")
        if (
            type(testimony_mode) is not cd0.Identifier
            or testimony_mode.namespace != FIXTURE
            or testimony_mode.path
            != ("policy-testimony-mode", "meta-policy-decision-not-direct-claim-support")
        ):
            raise LCIFailure(
                "target-mismatch",
                "TargetBoundaryMismatch",
                "target-boundaries",
                ("boundaries", "fixture-field:testimony-mode"),
            )


def _coverage_supports_scope(coverage: cd0.Datum, required: cd0.Datum) -> bool:
    try:
        return scope_relation(coverage, required) in {"equal", "wider"}
    except LCIFailure:
        return False


def _require_target_coverage(
    target: cd0.Datum,
    claimed_scope: cd0.Datum,
    candidate_scope: cd0.Datum,
) -> None:
    boundaries = field_by_path(target, "boundaries")
    coverage = field_by_path(boundaries, "coverage-scope")
    if not (
        _coverage_supports_scope(coverage, claimed_scope)
        and _coverage_supports_scope(coverage, candidate_scope)
    ):
        raise LCIFailure(
            "target-mismatch",
            "ScopeNarrowingCoverageInsufficient",
            "target-relation",
            ("boundaries", "fixture-field:coverage-scope"),
            (
                ("fixture-field:target-kind", field_by_path(target, "target-kind")),
                ("fixture-field:actual-coverage-scope", coverage),
                ("fixture-field:required-candidate-scope", candidate_scope),
            ),
        )


def match_target(target: cd0.Datum, candidate: cd0.Datum) -> RelationResult:
    try:
        validate_warrant_target(target)
        validate_claim_id(candidate)
        target_kind = _id_tail(field_by_path(target, "target-kind"))[-1]
        claimed = field_by_path(target, "claim")
        _target_kind_coherence(target, target_kind)
        left_location = field_by_path(claimed, "location")
        right_location = field_by_path(candidate, "location")
        if canonical_bytes(field_by_path(claimed, "proposition")) != canonical_bytes(field_by_path(candidate, "proposition")):
            raise LCIFailure("target-mismatch", "PropositionMismatch", "target-relation", ("claim", "proposition"))
        for coordinate, code in (
            ("identity-policy", "IdentityPolicyMismatch"),
            ("claim-profile", "ClaimProfileMismatch"),
        ):
            if canonical_bytes(field_by_path(claimed, coordinate)) != canonical_bytes(field_by_path(candidate, coordinate)):
                raise LCIFailure("target-mismatch", code, "target-relation", ("claim", coordinate))
        for coordinate, code in (
            ("subject-time", "SubjectTimeMismatch"),
            ("basis", "BasisMismatch"),
            ("interpretation-frame", "InterpretationFrameMismatch"),
            ("profile-location", "ProfileLocationMismatch"),
        ):
            if canonical_bytes(field_by_path(left_location, coordinate)) != canonical_bytes(field_by_path(right_location, coordinate)):
                raise LCIFailure("target-mismatch", code, "target-relation", ("claim", "location", coordinate))
        left_scope = field_by_path(left_location, "scope")
        right_scope = field_by_path(right_location, "scope")
        try:
            relation = scope_relation(left_scope, right_scope)
        except LCIFailure as exc:
            if exc.code in {"ScopeIncompatible", "ScopeRelationUnknown"}:
                raise LCIFailure(exc.category, exc.code, exc.stage, ("claim", "location", "scope")) from exc
            raise
        if relation == "equal":
            _require_target_coverage(target, left_scope, right_scope)
            return RelationResult("exact-target")
        if relation == "wider":
            proposition_form_value = field_by_path(field_by_path(claimed, "proposition"), "form")
            proposition_form = _id_tail(proposition_form_value)[-1]
            declared = proposition_form in TARGET_DOWNWARD_MONOTONE_FORMS[target_kind]
            if not declared:
                raise LCIFailure(
                    "target-mismatch",
                    "ScopeNarrowingNotDeclared",
                    "target-relation",
                    ("claim", "location", "scope"),
                    (
                        ("fixture-field:target-kind", field_by_path(target, "target-kind")),
                        ("fixture-field:proposition-form", proposition_form_value),
                    ),
                )
            _require_target_coverage(target, left_scope, right_scope)
            return RelationResult("supports-by-scope-narrowing")
        failures = {
            "narrower": "ScopeWideningForbidden",
            "overlap": "ScopeOverlapInsufficient",
            "disjoint": "ScopeDisjoint",
        }
        if relation in failures:
            raise LCIFailure("target-mismatch", failures[relation], "target-relation", ("claim", "location", "scope"))
        raise LCIFailure("relation-undetermined", "ScopeRelationUnknown", "target-relation", ("claim", "location", "scope"))
    except LCIFailure as exc:
        return RelationResult(failure=exc)


def failure(code: str) -> RelationResult:
    if code not in AUTHORIZED_LCI_FAILURE_CODES:
        raise FixtureAuthorityGap("unsupported fixture relation failure code")
    return RelationResult(failure=LCIFailure("relation-undetermined", code, "target-relation"))


def apply_admissibility_floor(result: RelationResult, policy: Callable[[RelationResult], PolicyDecision]) -> PolicyDecision:
    if not result.success:
        return PolicyDecision(False, "hard-reject-target-relation", hard_inadmissible=True, policy_consulted=False)
    return policy(result)


def evaluate_policy(
    policy_name: str,
    relation: RelationResult,
    *,
    target_kind: str = "observed",
    age: int = 0,
    represented_loss: str | None = None,
    trusted_external: bool = False,
    boundary_coherent: bool = True,
) -> PolicyDecision:
    if policy_name not in {"policy-a", "policy-b"}:
        raise FixtureAuthorityGap("unsupported fixture policy")
    floor = apply_admissibility_floor(relation, lambda r: PolicyDecision(True, "floor-passed"))
    if floor.hard_inadmissible:
        return floor

    policy_a_kinds = {
        "observed": 24,
        "executed": 24,
        "tested": 24,
        "derived": None,
        "replayed": 24,
        "corpus-completion": 24,
    }
    policy_b_kinds = {
        "observed": 168,
        "executed": 168,
        "tested": 168,
        "derived": None,
        "externally-attested": 168,
        "replayed": 168,
        "corpus-completion": 168,
        "reported": 168,
        "inherited": None,
        "translated": None,
        "policy-evaluation": 168,
    }

    if policy_name == "policy-a":
        if target_kind not in policy_a_kinds:
            return PolicyDecision(False, "reject-target-kind")
        if not boundary_coherent:
            return PolicyDecision(False, "reject-boundary-coherence")
        threshold = policy_a_kinds[target_kind]
        stale = threshold is not None and age > threshold
        if stale and represented_loss is not None:
            raise LCIFailure(
                "relation-undetermined",
                "AdmissibilityUndetermined",
                "admissibility",
                ("policy-evaluation-order",),
            )
        if represented_loss is not None:
            return PolicyDecision(False, "reject-represented-loss")
        if stale:
            return PolicyDecision(False, "reject-stale")
        if relation.relation == "supports-by-scope-narrowing":
            return PolicyDecision(True, "accept-scope-narrowed")
        return PolicyDecision(True, "accept-direct")

    if target_kind not in policy_b_kinds:
        return PolicyDecision(False, "reject-target-kind")
    if not boundary_coherent:
        return PolicyDecision(False, "reject-boundary-coherence")
    limited_testimony = target_kind in {"reported", "inherited", "translated", "policy-evaluation"}
    loss_rejected = represented_loss in {"identity-bearing-loss", "unknown-consequence"}
    external_untrusted = target_kind == "externally-attested" and not trusted_external
    threshold = policy_b_kinds[target_kind]
    stale = threshold is not None and age > threshold
    if stale and (loss_rejected or external_untrusted):
        raise LCIFailure(
            "relation-undetermined",
            "AdmissibilityUndetermined",
            "admissibility",
            ("policy-evaluation-order",),
        )
    if loss_rejected:
        return PolicyDecision(False, "reject-represented-loss")
    if represented_loss in {"authority-or-custody-loss", "semantic-translation-loss"}:
        limited_testimony = True
    if external_untrusted:
        # Package prose and the frozen policy record disagree on the exact
        # decision vocabulary for this refusal.  Preserve the no-support
        # boundary without silently selecting either spelling.
        raise LCIFailure(
            "relation-undetermined",
            "AdmissibilityUndetermined",
            "admissibility",
            ("external-principal-decision-vocabulary",),
        )
    if stale:
        return PolicyDecision(False, "reject-stale")
    if limited_testimony:
        return PolicyDecision(True, "accept-limited-testimony")
    if relation.relation == "supports-by-scope-narrowing":
        return PolicyDecision(True, "accept-scope-narrowed")
    return PolicyDecision(True, "accept-direct")


def restore_live_warrant(_: Any) -> None:
    raise LCIFailure("privilege-refusal", "PrivilegedRestorationAttempt", "privilege-boundary", ("parsed-inert-value", "attempt-live-restoration"))


# Public datum operations own one structural-resource measurement.  Internal
# recursion resolves these globals too, but the ContextVar makes every nested
# wrapper a no-op until the outer operation completes.
validate_stable_ref = _single_datum_resource_guard("validation")(validate_stable_ref)
validate_scope = _single_datum_resource_guard("validation")(validate_scope)
validate_subject_time = _single_datum_resource_guard("validation")(validate_subject_time)
validate_dataset_slice = _single_datum_resource_guard("validation")(validate_dataset_slice)
validate_semantic_boundary = _single_datum_resource_guard("validation")(validate_semantic_boundary)
validate_basis = _single_datum_resource_guard("validation")(validate_basis)
validate_frame = _single_datum_resource_guard("validation")(validate_frame)
validate_proposition = _single_datum_resource_guard("validation")(validate_proposition)
validate_location = _single_datum_resource_guard("validation")(validate_location)
validate_claim_id = _single_datum_resource_guard("validation")(validate_claim_id)
project_occurrence = _single_datum_resource_guard("projection")(project_occurrence)
validate_loss_account = _single_datum_resource_guard("validation")(validate_loss_account)
validate_represented_loss = _single_datum_resource_guard("validation")(validate_represented_loss)
validate_warrant_target = _single_datum_resource_guard("validation")(validate_warrant_target)


_scope_relation_semantics = scope_relation


@wraps(_scope_relation_semantics)
def scope_relation(left: cd0.Datum, right: cd0.Datum) -> str:
    with operation_resource_guard(
        _pair_payload("left-scope", left, "right-scope", right),
        stage="matching",
    ):
        return _scope_relation_semantics(left, right)


_temporal_relation_semantics = temporal_relation


@wraps(_temporal_relation_semantics)
def temporal_relation(left: cd0.Datum, right: cd0.Datum) -> str:
    with operation_resource_guard(
        _pair_payload(
            "left-subject-time",
            left,
            "right-subject-time",
            right,
        ),
        stage="matching",
    ):
        return _temporal_relation_semantics(left, right)


_proposition_location_consistency_semantics = validate_proposition_location_consistency


@wraps(_proposition_location_consistency_semantics)
def validate_proposition_location_consistency(proposition: cd0.Datum, location: cd0.Datum) -> None:
    with operation_resource_guard(
        _pair_payload("proposition", proposition, "location", location),
        stage="validation",
    ):
        _proposition_location_consistency_semantics(proposition, location)


_match_target_semantics = match_target


@wraps(_match_target_semantics)
def match_target(target: cd0.Datum, candidate: cd0.Datum) -> RelationResult:
    try:
        with operation_resource_guard(
            _pair_payload("target", target, "candidate-claim", candidate),
            stage="matching",
        ):
            return _match_target_semantics(target, candidate)
    except LCIFailure as exc:
        return RelationResult(failure=exc)
