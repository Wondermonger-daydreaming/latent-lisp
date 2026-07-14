"""LCI/0 validation, projection, relation, policy, and inert migration core."""

from __future__ import annotations

from dataclasses import replace
from typing import Any, Callable

import cd0

from .model import (
    ClaimIdEnvelope,
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


def ident(namespace: tuple[str, ...], *path: str) -> cd0.Identifier:
    return cd0.identifier(namespace, path)


def record_field(namespace: tuple[str, ...], name: str, value: cd0.Datum) -> tuple[cd0.Identifier, cd0.Datum]:
    return (ident(namespace, name), value)


def canonical_bytes(value: cd0.Datum) -> bytes:
    return cd0.encode_exact(value, CD0_BUDGET)


def _path_names(value: cd0.Datum) -> tuple[str, ...]:
    if type(value) is not cd0.Record:
        raise LCIFailure("invalid-input", "ExpectedRecord", "shape")
    names: list[str] = []
    for key, _ in value.fields:
        if len(key.path) != 1:
            raise LCIFailure("invalid-input", "UnknownField", "shape", ("/".join(key.path),))
        names.append(key.path[0])
    return tuple(names)


def _closed(
    value: cd0.Datum,
    allowed: tuple[str, ...],
    *,
    stage: str,
    prefix: tuple[str, ...] = (),
    required: tuple[str, ...] | None = None,
) -> None:
    names = _path_names(value)
    required = allowed if required is None else required
    for name in required:
        if name not in names:
            raise LCIFailure("invalid-input", "MissingRequiredField", stage, prefix + (name,))
    for name in names:
        if name not in allowed:
            raise LCIFailure("invalid-input", "UnknownField", stage, prefix + (name,))


def _integer_zero(value: cd0.Datum, code: str, stage: str, path: tuple[str, ...]) -> None:
    if type(value) is not cd0.Integer or value.value != 0:
        raise LCIFailure("unsupported-version-or-profile", code, stage, path)


def _id_tail(value: cd0.Datum) -> tuple[str, ...]:
    if type(value) is not cd0.Identifier:
        raise LCIFailure("invalid-input", "ExpectedIdentifier", "shape")
    return value.path


def _kind(value: cd0.Datum) -> str:
    kind = field_by_path(value, "kind")
    tail = _id_tail(kind)
    return tail[-1]


def _require_kind(value: cd0.Datum, expected: str, code: str, stage: str, path: tuple[str, ...]) -> None:
    try:
        actual = _kind(value)
    except LCIFailure as exc:
        raise LCIFailure("invalid-input", code, stage, path) from exc
    if actual != expected:
        raise LCIFailure("invalid-input", code, stage, path + ("kind",))


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
    _closed(value, ("kind", "domain", "scheme", "material"), stage="stable-reference", prefix=path)
    if _kind(value) != "stable-reference":
        raise LCIFailure("reference-refusal", "UnstableReference", "stable-reference", path + ("kind",))
    domain = field_by_path(value, "domain")
    scheme = field_by_path(value, "scheme")
    if type(domain) is not cd0.Identifier or type(scheme) is not cd0.Identifier:
        raise LCIFailure("reference-refusal", "UnstableReference", "stable-reference", path)
    if len(domain.path) < 2 or len(scheme.path) < 4:
        raise LCIFailure("reference-refusal", "UnknownStableReferenceScheme", "stable-reference", path + ("scheme",))
    domain_name = domain.path[-1]
    if domain_name not in STABLE_REF_DOMAINS:
        raise LCIFailure("reference-refusal", "UnknownStableReferenceScheme", "stable-reference", path + ("domain",))
    if tuple(scheme.path[-3:]) != (domain_name, "structural", "0"):
        raise LCIFailure("reference-refusal", "UnknownStableReferenceScheme", "stable-reference", path + ("scheme",))
    material = field_by_path(value, "material")
    _closed(
        material,
        ("kind", "schema-version", "object-id", "object-version"),
        stage="stable-reference",
        prefix=path + ("material",),
    )
    _integer_zero(
        field_by_path(material, "schema-version"),
        "RecursiveUnsupportedNestedVersion",
        "stable-reference",
        path + ("material", "schema-version"),
    )
    _require_kind(material, "fixture-stable-material", "UnstableReference", "stable-reference", path + ("material",))
    object_id = field_by_path(material, "object-id")
    if type(object_id) is not cd0.Identifier:
        raise LCIFailure("reference-refusal", "UnstableReference", "stable-reference", path + ("material", "object-id"))
    lowered = tuple(segment.casefold() for segment in object_id.path)
    object_version = field_by_path(material, "object-version")
    if type(object_version) is not cd0.Integer or object_version.value < 0:
        raise LCIFailure("reference-refusal", "UnstableReference", "stable-reference", path + ("material", "object-version"))
    aliases = {"latest", "main", "display-model", "filename", "file.txt", "mutable-url"}
    if any(segment in aliases for segment in lowered) or any(
        segment.startswith("http://") or segment.startswith("https://") for segment in lowered
    ):
        failure_path = path if path else ("material", "object-id")
        raise LCIFailure("reference-refusal", "UnresolvedAlias", "stable-reference", failure_path)
    return value


def _validate_versioned_expression(value: cd0.Datum, allowed_by_form: dict[str, tuple[str, ...]], stage: str, path: tuple[str, ...]) -> str:
    if type(value) is not cd0.Record:
        raise LCIFailure("invalid-input", f"Invalid{stage.title().replace('-', '')}", stage, path)
    form_value = field_by_path(value, "form", None)
    if type(form_value) is not cd0.Identifier:
        raise LCIFailure("invalid-input", f"Invalid{stage.title().replace('-', '')}", stage, path)
    form = form_value.path[-1]
    allowed = allowed_by_form.get(form)
    if allowed is None:
        raise LCIFailure("invalid-input", f"Invalid{stage.title().replace('-', '')}", stage, path)
    _closed(value, allowed, stage=stage, prefix=path)
    _integer_zero(
        field_by_path(value, "schema-version"),
        "RecursiveUnsupportedNestedVersion",
        stage,
        path + ("schema-version",),
    )
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
    _closed(value, ("kind", "schema-version", "calculus", "expression"), stage="scope", prefix=path)
    _require_kind(value, "scope", "InvalidScope", "scope", path)
    _integer_zero(field_by_path(value, "schema-version"), "RecursiveUnsupportedNestedVersion", "scope", path + ("schema-version",))
    validate_stable_ref(field_by_path(value, "calculus"), path=path + ("calculus",))
    if _id_tail(field_by_path(field_by_path(value, "calculus"), "domain"))[-1] != "scope-calculus":
        raise LCIFailure("invalid-input", "InvalidScope", "scope", path + ("calculus",))
    try:
        form = _validate_versioned_expression(field_by_path(value, "expression"), SCOPE_FORMS, "scope", path + ("expression",))
    except LCIFailure as exc:
        if exc.code == "MissingRequiredField":
            raise LCIFailure("invalid-input", "InvalidScope", "scope", path + ("expression",)) from exc
        raise
    expression = field_by_path(value, "expression")
    if form == "region-set":
        members = field_by_path(expression, "members")
        if type(members) is not cd0.Sequence or not members.items or any(type(item) is not cd0.Identifier for item in members.items):
            raise LCIFailure("invalid-input", "InvalidScope", "scope", path + ("expression",))
        encoded = [canonical_bytes(item) for item in members.items]
        if encoded != sorted(set(encoded)):
            raise LCIFailure("invalid-input", "InvalidScope", "scope", path + ("expression", "members"))
    if form == "symbolic-predicate" and type(field_by_path(expression, "known-proper-subset")) is not cd0.Boolean:
        raise LCIFailure("invalid-input", "InvalidScope", "scope", path + ("expression", "known-proper-subset"))
    return value


def validate_subject_time(value: cd0.Datum, *, projection: bool = False, path: tuple[str, ...] = ("location", "subject-time")) -> cd0.Datum:
    if type(value) is cd0.Unit:
        raise LCIFailure("invalid-input", "UnexpectedUnit", "subject-time", path)
    _closed(value, ("kind", "schema-version", "temporal-model", "expression"), stage="subject-time", prefix=path)
    _require_kind(value, "subject-time", "InvalidSubjectTime", "subject-time", path)
    _integer_zero(field_by_path(value, "schema-version"), "RecursiveUnsupportedNestedVersion", "subject-time", path + ("schema-version",))
    validate_stable_ref(field_by_path(value, "temporal-model"), path=path + ("temporal-model",))
    if _id_tail(field_by_path(field_by_path(value, "temporal-model"), "domain"))[-1] != "temporal-model":
        raise LCIFailure("invalid-input", "InvalidSubjectTime", "subject-time", path + ("temporal-model",))
    expression = field_by_path(value, "expression")
    form_value = field_by_path(expression, "form", None)
    if projection and type(form_value) is cd0.Identifier and form_value.path[-1] == "relative":
        raise LCIFailure("projection-refusal", "UnresolvedRelativeTime", "subject-time", path + ("expression",))
    form = _validate_versioned_expression(expression, TEMPORAL_FORMS, "subject-time", path + ("expression",))
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
    return value


def validate_dataset_slice(value: cd0.Datum, path: tuple[str, ...]) -> cd0.Datum:
    _closed(value, ("kind", "schema-version", "calculus", "expression"), stage="dataset-slice", prefix=path)
    _require_kind(value, "dataset-slice", "InvalidDatasetSlice", "dataset-slice", path)
    _integer_zero(field_by_path(value, "schema-version"), "RecursiveUnsupportedNestedVersion", "dataset-slice", path + ("schema-version",))
    validate_stable_ref(field_by_path(value, "calculus"), path=path + ("calculus",))
    if _id_tail(field_by_path(field_by_path(value, "calculus"), "domain"))[-1] != "dataset-slice-calculus":
        raise LCIFailure("invalid-input", "InvalidDatasetSlice", "dataset-slice", path + ("calculus",))
    form = _validate_versioned_expression(field_by_path(value, "expression"), SLICE_FORMS, "dataset-slice", path + ("expression",))
    expression = field_by_path(value, "expression")
    if form == "explicit-members":
        members = field_by_path(expression, "members")
        if type(members) is not cd0.Sequence or not members.items:
            raise LCIFailure("invalid-input", "InvalidDatasetSlice", "dataset-slice", path + ("expression", "members"))
        encoded: list[bytes] = []
        for index, member in enumerate(members.items):
            validate_stable_ref(member, path=path + ("expression", "members", str(index)))
            if _id_tail(field_by_path(member, "domain"))[-1] != "artifact":
                raise LCIFailure("invalid-input", "InvalidDatasetSlice", "dataset-slice", path + ("expression", "members", str(index)))
            encoded.append(canonical_bytes(member))
        if encoded != sorted(set(encoded)):
            raise LCIFailure("invalid-input", "InvalidDatasetSlice", "dataset-slice", path + ("expression", "members"))
    if form == "predicate":
        if scalar(field_by_path(expression, "predicate")) != "slice-predicate/artifact-object-id-prefix" or type(field_by_path(expression, "argument")) is not cd0.String:
            raise LCIFailure("invalid-input", "InvalidDatasetSlice", "dataset-slice", path + ("expression",))
        evaluation_domain = field_by_path(expression, "evaluation-domain")
        validate_stable_ref(evaluation_domain, path=path + ("expression", "evaluation-domain"))
        if _id_tail(field_by_path(evaluation_domain, "domain"))[-1] != "immutable-corpus-revision":
            raise LCIFailure("invalid-input", "InvalidDatasetSlice", "dataset-slice", path + ("expression", "evaluation-domain"))
    return value


def validate_semantic_boundary(value: cd0.Datum, path: tuple[str, ...]) -> cd0.Datum:
    _closed(value, ("kind", "schema-version", "calculus", "expression"), stage="semantic-boundary", prefix=path)
    _require_kind(value, "semantic-boundary", "InvalidSemanticBoundary", "semantic-boundary", path)
    _integer_zero(field_by_path(value, "schema-version"), "RecursiveUnsupportedNestedVersion", "semantic-boundary", path + ("schema-version",))
    validate_stable_ref(field_by_path(value, "calculus"), path=path + ("calculus",))
    if _id_tail(field_by_path(field_by_path(value, "calculus"), "domain"))[-1] != "semantic-boundary-calculus":
        raise LCIFailure("invalid-input", "InvalidSemanticBoundary", "semantic-boundary", path + ("calculus",))
    form = _validate_versioned_expression(field_by_path(value, "expression"), BOUNDARY_FORMS, "semantic-boundary", path + ("expression",))
    expression = field_by_path(value, "expression")
    if form == "snapshot-manifest":
        validate_stable_ref(field_by_path(expression, "manifest"), path=path + ("expression", "manifest"))
    if form == "log-horizon":
        validate_stable_ref(field_by_path(expression, "stream"), path=path + ("expression", "stream"))
        _validate_versioned_expression(field_by_path(expression, "horizon"), TEMPORAL_FORMS, "subject-time", path + ("expression", "horizon"))
    if form == "path-root":
        root = scalar(field_by_path(expression, "path"))
        semantics = scalar(field_by_path(expression, "path-semantics"))
        if type(root) is not str or not root.startswith("/") or root == "/" or "//" in root or "/../" in root or root.endswith("/.."):
            raise LCIFailure("invalid-input", "InvalidSemanticBoundary", "semantic-boundary", path + ("expression", "path"))
        if semantics != "path-semantics/posix-absolute-byte-exact-utf8":
            raise LCIFailure("invalid-input", "InvalidSemanticBoundary", "semantic-boundary", path + ("expression", "path-semantics"))
    return value


def validate_basis(value: cd0.Datum, *, projection: bool = False, path: tuple[str, ...] = ("location", "basis")) -> cd0.Datum:
    mode = field_by_path(value, "mode", None)
    if type(mode) is not cd0.Identifier:
        raise LCIFailure("invalid-input", "InvalidBasis", "basis", path)
    variant = mode.path[-1]
    _require_kind(value, "claim-basis", "InvalidBasis", "basis", path)
    if variant == "world":
        _closed(value, ("kind", "schema-version", "mode", "parameters"), stage="basis", prefix=path)
        if type(field_by_path(value, "parameters")) is not cd0.Record or len(field_by_path(value, "parameters").fields):
            raise LCIFailure("invalid-input", "InvalidBasis", "basis", path + ("parameters",))
    elif variant == "corpus":
        _closed(
            value,
            ("kind", "schema-version", "mode", "corpus", "revision", "slice", "semantic-boundary"),
            stage="basis",
            prefix=path,
        )
        validate_stable_ref(field_by_path(value, "corpus"), path=path + ("corpus",))
        if _id_tail(field_by_path(field_by_path(value, "corpus"), "domain"))[-1] != "logical-corpus":
            raise LCIFailure("invalid-input", "InvalidBasis", "basis", path + ("corpus",))
        try:
            validate_stable_ref(field_by_path(value, "revision"), path=path + ("revision",))
        except LCIFailure as exc:
            if exc.code == "UnresolvedAlias":
                raise
            raise
        if _id_tail(field_by_path(field_by_path(value, "revision"), "domain"))[-1] != "immutable-corpus-revision":
            raise LCIFailure("invalid-input", "InvalidBasis", "basis", path + ("revision",))
        validate_dataset_slice(field_by_path(value, "slice"), path + ("slice",))
        validate_semantic_boundary(field_by_path(value, "semantic-boundary"), path + ("semantic-boundary",))
    else:
        raise LCIFailure("invalid-input", "InvalidBasis", "basis", path + ("mode",))
    _integer_zero(field_by_path(value, "schema-version"), "RecursiveUnsupportedNestedVersion", "basis", path + ("schema-version",))
    return value


def validate_frame(value: cd0.Datum, path: tuple[str, ...] = ("location", "interpretation-frame")) -> cd0.Datum:
    _closed(value, ("kind", "schema-version", "frame-schema", "components"), stage="interpretation-frame", prefix=path)
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
        _closed(components, allowed, stage="interpretation-frame", prefix=path + ("components",))
        validate_stable_ref(field_by_path(components, "ontology"), path=path + ("components", "ontology"))
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
    _closed(value, ("kind", "schema-version", "form", "arguments"), stage="proposition", prefix=("proposition",))
    _require_kind(value, "mneme-fixture-proposition", "InvalidProposition", "proposition", ("proposition",))
    _integer_zero(field_by_path(value, "schema-version"), "UnsupportedClaimProfile", "claim-profile", ("proposition", "schema-version"))
    form_value = field_by_path(value, "form")
    if type(form_value) is not cd0.Identifier or form_value.path[-1] not in PROPOSITION_ARGUMENTS:
        raise LCIFailure("projection-refusal" if projection else "invalid-input", "UnnormalizedProposition", "proposition", ("proposition",))
    form = form_value.path[-1]
    arguments = field_by_path(value, "arguments")
    expected = PROPOSITION_ARGUMENTS[form]
    try:
        _closed(arguments, expected, stage="proposition", prefix=("proposition", "arguments"))
    except LCIFailure as exc:
        if projection:
            raise LCIFailure("projection-refusal", "UnnormalizedProposition", "proposition", ("proposition",)) from exc
        raise
    for name in expected:
        argument = field_by_path(arguments, name)
        _closed(argument, ("kind", "schema-version", "placement", "value"), stage="proposition", prefix=("proposition", "arguments", name))
        _integer_zero(field_by_path(argument, "schema-version"), "RecursiveUnsupportedNestedVersion", "proposition", ("proposition", "arguments", name, "schema-version"))
        placement = scalar(field_by_path(argument, "placement"))
        should_locator = name.endswith("locator") or name in {"quantified-domain", "population-domain"}
        expected_placement = "proposition-placement/external-claim-location-locator" if should_locator else "proposition-placement/proposition-subject-content"
        if placement != expected_placement:
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
                _closed(locator, ("kind", "schema-version", "coordinate", "locator-role"), stage="proposition", prefix=locator_path)
                _require_kind(locator, "locator-slot", "PropositionLocationInconsistent", "proposition", locator_path)
                _integer_zero(field_by_path(locator, "schema-version"), "RecursiveUnsupportedNestedVersion", "proposition", locator_path + ("schema-version",))
                coordinate, role = LOCATOR_RULES[name]
                actual_coordinate = _id_tail(field_by_path(locator, "coordinate"))[-1]
                actual_role = _id_tail(field_by_path(locator, "locator-role"))[-1]
            except LCIFailure as exc:
                if exc.code == "RecursiveUnsupportedNestedVersion":
                    raise
                raise LCIFailure("projection-refusal", "PropositionLocationInconsistent", "proposition", locator_path) from exc
            if (actual_coordinate, actual_role) != (coordinate, role):
                raise LCIFailure("projection-refusal", "PropositionLocationInconsistent", "proposition", locator_path)
    return value


def validate_location(value: cd0.Datum, *, projection: bool = False) -> cd0.Datum:
    _closed(
        value,
        ("kind", "scope", "subject-time", "basis", "interpretation-frame", "profile-location"),
        stage="location-shape",
        prefix=("location",),
    )
    validate_scope(field_by_path(value, "scope"))
    validate_subject_time(field_by_path(value, "subject-time"), projection=projection)
    validate_basis(field_by_path(value, "basis"), projection=projection)
    validate_frame(field_by_path(value, "interpretation-frame"))
    profile = field_by_path(value, "profile-location")
    if type(profile) is not cd0.Record:
        raise LCIFailure("invalid-input", "InvalidProfileLocation", "profile-location", ("location", "profile-location"))
    # Mneme/0 reserves an exact empty record.  The explicit tagged schema is
    # accepted for its I12 conformance vector, but coordinates remain closed.
    if len(profile.fields):
        _closed(profile, ("kind", "schema-version", "coordinates"), stage="profile-location", prefix=("location", "profile-location"))
        coordinates = field_by_path(profile, "coordinates")
        if type(coordinates) is not cd0.Record or len(coordinates.fields):
            name = _path_names(coordinates)[0] if type(coordinates) is cd0.Record and coordinates.fields else "coordinates"
            raise LCIFailure("invalid-input", "UnknownField", "profile-location", ("location", "profile-location", "coordinates", name))
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
    )
    _require_kind(value, "claim-id-envelope", "InvalidClaimRecord", "claim-shape", ())
    _integer_zero(field_by_path(value, "lci-version"), "UnsupportedLCIVersion", "lci-version", ("lci-version",))
    policy = field_by_path(value, "identity-policy")
    _closed(policy, ("kind", "policy-id", "policy-version"), stage="identity-policy", prefix=("identity-policy",))
    _require_kind(policy, "identity-policy", "UnsupportedIdentityPolicy", "identity-policy", ("identity-policy",))
    if _id_tail(field_by_path(policy, "policy-id"))[-1] != "located-claim-identity":
        raise LCIFailure("unsupported-version-or-profile", "UnsupportedIdentityPolicy", "identity-policy", ("identity-policy", "policy-id"))
    _integer_zero(field_by_path(policy, "policy-version"), "UnsupportedIdentityPolicy", "identity-policy", ("identity-policy", "policy-version"))
    profile = field_by_path(value, "claim-profile")
    _closed(profile, ("kind", "profile-id", "profile-version"), stage="claim-profile", prefix=("claim-profile",))
    _require_kind(profile, "claim-profile", "UnsupportedClaimProfile", "claim-profile", ("claim-profile",))
    if _id_tail(field_by_path(profile, "profile-id"))[-1] != "located-claim":
        raise LCIFailure("unsupported-version-or-profile", "UnsupportedClaimProfile", "claim-profile", ("claim-profile", "profile-id"))
    _integer_zero(field_by_path(profile, "profile-version"), "UnsupportedClaimProfile", "claim-profile", ("claim-profile", "profile-version"))
    validate_proposition(field_by_path(value, "proposition"), projection=projection)
    validate_location(field_by_path(value, "location"), projection=projection)
    validate_proposition_location_consistency(field_by_path(value, "proposition"), field_by_path(value, "location"))
    return value


def project_claim_id(value: Any) -> ClaimIdEnvelope:
    """Pure ClaimId projection; no cache, digest, ambient state, or lookup."""

    if isinstance(value, ClaimIdEnvelope):
        datum = value.datum
    elif type(value) is cd0.Record:
        names = _path_names(value)
        if "semantic-claim-core" in names:
            datum = field_by_path(value, "semantic-claim-core")
        elif set(names) == {"identity-policy", "claim-profile", "proposition", "location"}:
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
            datum = value
    else:
        # Mutable test views carry an immutable source datum.  Only explicit
        # mutations are interpreted; no semantic field is inferred.
        source = getattr(value, "_lci_source_datum", None)
        if source is None:
            raise LCIFailure("invalid-input", "UnsupportedHostInput", "projection")
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
    octets = canonical_bytes(datum)
    return ClaimIdEnvelope(datum, octets)


def replace_record_field(value: cd0.Datum, name: str, replacement_value: cd0.Datum) -> cd0.Record:
    if type(value) is not cd0.Record:
        raise LCIFailure("invalid-input", "ExpectedRecord", "shape")
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
    _closed(
        value,
        (
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
        ),
        stage="claim-shape",
    )
    projected = project_claim_id(field_by_path(value, "semantic-claim-core"))
    cached = field_by_path(value, "cached-claim-id")
    if canonical_bytes(cached) != projected.canonical_bytes:
        raise LCIFailure("projection-refusal", "ClaimIdCacheMismatch", "claim-id-cache", ("cached-claim-id",))
    return projected


def claim_ids_equal(left: Any, right: Any) -> bool:
    left_datum = left.datum if isinstance(left, ClaimIdEnvelope) else left
    right_datum = right.datum if isinstance(right, ClaimIdEnvelope) else right
    return type(left_datum) is cd0.Record and type(right_datum) is cd0.Record and canonical_bytes(left_datum) == canonical_bytes(right_datum)


def _ref_id(value: cd0.Datum) -> tuple[str, ...]:
    material = field_by_path(value, "material")
    object_id = field_by_path(material, "object-id")
    return _id_tail(object_id)


def scope_relation(left: cd0.Datum, right: cd0.Datum) -> str:
    validate_scope(left, path=("left",))
    validate_scope(right, path=("right",))
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
        raise LCIFailure("relation-undetermined", "ScopeRelationUnknown", "target-relation", ("right",))
    if (lf == "region-set") != (rf == "region-set"):
        raise LCIFailure("relation-undetermined", "ScopeRelationUnknown", "target-relation", ("right",))
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
        raise LCIFailure("relation-undetermined", "ScopeRelationUnknown", "target-relation", ("right",))
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
    if canonical_bytes(field_by_path(left, "temporal-model")) != canonical_bytes(field_by_path(right, "temporal-model")):
        raise LCIFailure("relation-undetermined", "UnsupportedTemporalModel", "subject-time", ("right", "temporal-model"))
    le = field_by_path(left, "expression")
    re = field_by_path(right, "expression")
    if canonical_bytes(le) == canonical_bytes(re):
        return "equal"
    lf = _id_tail(field_by_path(le, "form"))[-1]
    rf = _id_tail(field_by_path(re, "form"))[-1]
    if "atemporal" in {lf, rf}:
        return "incompatible"
    if "symbolic" in {lf, rf}:
        raise LCIFailure("relation-undetermined", "AdmissibilityUndetermined", "subject-time", ("left" if lf == "symbolic" else "right",))
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
    raise LCIFailure("relation-undetermined", "AdmissibilityUndetermined", "subject-time", ("left",))


TARGET_REQUIRED_BOUNDARIES = {
    "observed": ("coverage-scope", "observation-mode", "observation-time", "observation-procedure", "observer-or-instrument", "observation-artifact-or-event"),
    "executed": ("invocation", "coverage-scope", "execution-time", "procedure-reference", "execution-event-or-trace", "immutable-code-or-semantics", "execution-environment-semantics"),
    "tested": ("test-input", "coverage-scope", "execution-time", "expected-relation", "test-case-or-suite", "test-event-or-trace", "immutable-tested-version", "system-or-procedure-under-test", "execution-environment-semantics"),
    "derived": ("coverage-scope", "premise-claim-ids", "inference-calculus", "rule-or-derivation-identity", "derivation-artifact-or-trace"),
    "externally-attested": ("coverage-scope", "mapping-receipt", "attestation-time", "external-principal", "external-statement-or-artifact"),
    "replayed": ("replay-time", "coverage-scope", "replay-procedure", "replay-invocation", "new-replay-trace-or-result", "immutable-code-or-semantics", "execution-environment-semantics", "predecessor-warrant-testimony-or-event"),
    "corpus-completion": ("coverage-plan", "coverage-scope", "execution-time", "search-procedure", "exact-corpus-basis", "completion-boundary", "query-or-search-expression", "completion-receipt-or-trace", "immutable-code-or-semantics"),
    "reported": ("report-time", "coverage-scope", "source-artifact", "reporter-or-source-principal", "content-to-claim-interpretation-receipt"),
    "inherited": ("coverage-scope", "represented-loss", "inheritance-or-handoff-rule", "predecessor-warrant-testimony", "handoff-freeze-revival-receipt", "predecessor-occurrence-or-artifact"),
    "translated": ("coverage-scope", "source-claim-id", "represented-loss", "translation-receipt", "translation-procedure", "source-interpretation-frame", "target-interpretation-frame"),
    "policy-evaluation": ("policy", "query-time", "coverage-scope", "state-snapshot", "testimony-mode", "evaluated-warrant", "inner-target-relation"),
}


def validate_warrant_target(value: cd0.Datum) -> cd0.Datum:
    if type(value) is cd0.Record:
        preliminary_names = _path_names(value)
        if "claim" not in preliminary_names and "legacy-fingerprint" in preliminary_names:
            raise LCIFailure("migration-refusal", "LegacyFingerprintNotClaimId", "target-shape", ("claim",))
    _closed(value, ("kind", "lci-version", "target-kind", "target-schema", "claim", "boundaries"), stage="target-shape")
    _integer_zero(field_by_path(value, "lci-version"), "UnsupportedLCIVersion", "lci-version", ("lci-version",))
    kind_value = field_by_path(value, "target-kind")
    if type(kind_value) is not cd0.Identifier or kind_value.path[-1] not in TARGET_REQUIRED_BOUNDARIES:
        raise LCIFailure("invalid-input", "UnknownTargetKind", "target-shape", ("target-kind",))
    target_kind = kind_value.path[-1]
    validate_stable_ref(field_by_path(value, "target-schema"), path=("target-schema",))
    boundaries = field_by_path(value, "boundaries")
    if type(boundaries) is not cd0.Record:
        raise LCIFailure("invalid-input", "TargetBoundaryMissing", "target-boundaries", ("boundaries",))
    names = _path_names(boundaries)
    for required in TARGET_REQUIRED_BOUNDARIES[target_kind]:
        if required not in names:
            if target_kind == "executed" and required == "immutable-code-or-semantics":
                raise LCIFailure("reference-refusal", "ProcedureIdentityInsufficient", "target-boundaries", ("boundaries", required))
            raise LCIFailure("invalid-input", "TargetBoundaryMissing", "target-boundaries", ("boundaries", required))
    allowed = set(TARGET_REQUIRED_BOUNDARIES[target_kind])
    for name in names:
        if name not in allowed:
            raise LCIFailure("invalid-input", "TargetBoundaryUnknown", "target-boundaries", ("boundaries", name))
    claim = field_by_path(value, "claim")
    if type(claim) is not cd0.Record or _kind(claim) != "claim-id-envelope":
        raise LCIFailure("migration-refusal", "LegacyFingerprintNotClaimId", "target-shape", ("claim",))
    validate_claim_id(claim)
    return value


def match_target(target: cd0.Datum, candidate: cd0.Datum) -> RelationResult:
    try:
        validate_warrant_target(target)
        validate_claim_id(candidate)
        target_kind = _id_tail(field_by_path(target, "target-kind"))[-1]
        if target_kind == "corpus-completion":
            receipt = field_by_path(field_by_path(target, "boundaries"), "completion-receipt-or-trace")
            receipt_id = field_by_path(field_by_path(receipt, "material"), "object-id")
            if "incomplete" in _id_tail(receipt_id):
                raise LCIFailure("target-mismatch", "CorpusCompletionInsufficient", "target-boundaries", ("boundaries", "completion-receipt-or-trace"))
        claimed = field_by_path(target, "claim")
        if canonical_bytes(claimed) == canonical_bytes(candidate):
            return RelationResult("exact-target")
        left_location = field_by_path(claimed, "location")
        right_location = field_by_path(candidate, "location")
        for coordinate, code in (
            ("subject-time", "SubjectTimeMismatch"),
            ("basis", "BasisMismatch"),
            ("interpretation-frame", "InterpretationFrameMismatch"),
        ):
            if canonical_bytes(field_by_path(left_location, coordinate)) != canonical_bytes(field_by_path(right_location, coordinate)):
                raise LCIFailure("target-mismatch", code, "target-relation", ("claim", "location", coordinate))
        if canonical_bytes(field_by_path(claimed, "proposition")) != canonical_bytes(field_by_path(candidate, "proposition")):
            raise LCIFailure("target-mismatch", "ProfileLocationMismatch", "target-relation", ("claim", "proposition"))
        left_scope = field_by_path(left_location, "scope")
        right_scope = field_by_path(right_location, "scope")
        left_scope_form = _id_tail(field_by_path(field_by_path(left_scope, "expression"), "form"))[-1]
        right_scope_form = _id_tail(field_by_path(field_by_path(right_scope, "expression"), "form"))[-1]
        if "symbolic-predicate" in {left_scope_form, right_scope_form}:
            raise LCIFailure("relation-undetermined", "ScopeRelationUnknown", "target-relation", ("claim", "location", "scope"))
        try:
            relation = scope_relation(left_scope, right_scope)
        except LCIFailure as exc:
            if exc.code in {"ScopeIncompatible", "ScopeRelationUnknown"}:
                raise LCIFailure(exc.category, exc.code, exc.stage, ("claim", "location", "scope")) from exc
            raise
        if relation == "wider":
            boundaries = field_by_path(target, "boundaries")
            proposition_form = _id_tail(field_by_path(field_by_path(claimed, "proposition"), "form"))[-1]
            declared = proposition_form in {"universal-property-over-scope", "bounded-corpus-absence"}
            if not declared:
                raise LCIFailure("target-mismatch", "ScopeNarrowingNotDeclared", "target-relation", ("claim", "location", "scope"))
            coverage = field_by_path(boundaries, "coverage-scope", None)
            if coverage is not None:
                coverage_relation = scope_relation(coverage, field_by_path(right_location, "scope"))
                if coverage_relation not in {"equal", "wider"}:
                    raise LCIFailure("target-mismatch", "ScopeNarrowingCoverageInsufficient", "target-relation", ("boundaries", "coverage-scope"))
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
    return RelationResult(failure=LCIFailure("relation-undetermined", code, "target-relation"))


def apply_admissibility_floor(result: RelationResult, policy: Callable[[RelationResult], PolicyDecision]) -> PolicyDecision:
    if result.failure is not None:
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
) -> PolicyDecision:
    floor = apply_admissibility_floor(relation, lambda r: PolicyDecision(True, "floor-passed"))
    if floor.hard_inadmissible:
        return floor
    if relation.relation == "supports-by-scope-narrowing":
        return PolicyDecision(True, "accept-scope-narrowed")
    if policy_name == "policy-a":
        if target_kind in {"externally-attested", "reported", "inherited", "translated", "policy-evaluation"}:
            return PolicyDecision(False, "reject-target-kind")
        if age > 24 and target_kind in {"observed", "executed", "tested", "replayed", "corpus-completion"}:
            return PolicyDecision(False, "reject-stale")
        if represented_loss is not None:
            return PolicyDecision(False, "reject-represented-loss")
        return PolicyDecision(True, "accept-direct")
    if age > 168 and target_kind != "derived":
        return PolicyDecision(False, "reject-stale")
    if target_kind == "externally-attested" and not trusted_external:
        return PolicyDecision(False, "reject-external-principal")
    if target_kind in {"reported", "inherited", "translated", "policy-evaluation"} or represented_loss in {
        "authority-or-custody-loss", "semantic-translation-loss"
    }:
        return PolicyDecision(True, "accept-limited-testimony")
    if represented_loss in {"identity-bearing-loss", "unknown-consequence"}:
        return PolicyDecision(False, "reject-represented-loss")
    return PolicyDecision(True, "accept-direct")


def restore_live_warrant(_: Any) -> None:
    raise LCIFailure("privilege-refusal", "PrivilegedRestorationAttempt", "privilege-boundary", ("parsed-inert-value", "attempt-live-restoration"))
