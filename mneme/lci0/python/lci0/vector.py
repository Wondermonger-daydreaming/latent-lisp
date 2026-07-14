"""Shared-vector execution without consulting vector expected results.

Expected documents are parsed only by :func:`expected_outcome`, a test-oracle
helper kept separate from :func:`execute`.  Semantic execution dispatches on the
declared operation and payload alone; the vector id is used only as diagnostic
context for failures.
"""

from __future__ import annotations

from dataclasses import dataclass, replace
from functools import lru_cache
from typing import Any, Mapping

import cd0

from .adapter import from_package_json
from .core import (
    CD0_BUDGET,
    FIXTURE,
    FIXTURE_FIELD,
    LCI,
    LCI_RESOURCE_FAILURES,
    LCI_RESOURCE_LIMITS,
    TARGET_REQUIRED_BOUNDARIES,
    apply_admissibility_floor,
    canonical_bytes,
    claim_ids_equal,
    evaluate_policy,
    field_by_path,
    match_target,
    operation_resource_guard,
    project_claim_id,
    project_occurrence,
    scope_relation,
    temporal_relation,
    validate_claim_id,
    validate_dataset_slice,
    validate_frame,
    validate_loss_account,
    validate_proposition,
    validate_proposition_location_consistency,
    validate_represented_loss,
    validate_scope,
    validate_semantic_boundary,
    validate_stable_ref,
    validate_subject_time,
    validate_warrant_target,
)
from .model import ClaimIdEnvelope, LCIFailure, PolicyDecision, RelationResult, scalar
from .migration import legacy_inert, migrate, refuse_legacy_source, validate_migration_result
from .package import iter_vectors


@dataclass(frozen=True, slots=True)
class Outcome:
    operation: str
    outputs: Mapping[str, Any] | None = None
    failure: LCIFailure | None = None

    @property
    def status(self) -> str:
        return "failure" if self.failure is not None else "success"


class FixtureAuthorityGap(RuntimeError):
    """Host-side stop for an inverse case with no frozen LCI result schema.

    This is deliberately not an :class:`LCIFailure`: the fixture package did
    not authorize a normative category/code/stage/path tuple for these paths.
    """


OPERATION_PAYLOAD_SCHEMAS: dict[str, tuple[tuple[str, ...], ...]] = {
    "apply-admissibility-floor": (("policy-a", "policy-b", "target-relation"),),
    "apply-occurrence-corrections": (("original", "provenance-corrected", "proposition-corrected"),),
    "apply-stable-ref-bridge": (("bridge", "source-reference"),),
    "canonicalize-record-order": (("left-claim", "left-construction-order", "right-claim", "right-construction-order"),),
    "classify-version-governance": (("accepted-abstract-inputs-unchanged", "change", "claim-ids-unchanged", "normalized-propositions-unchanged", "projection-field-set-unchanged", "relations-and-failures-unchanged"),),
    "compare-bridge-source-and-target": (("bridge", "source", "target"),),
    "compare-claim-digests-and-envelopes": (("digest-scheme", "left-claim-id", "left-operational-digest", "right-claim-id", "right-operational-digest"),),
    "compare-claim-id-set": (("claims",),),
    "compare-claim-ids": (("left", "right"),),
    "compare-corpus-completion-targets": (("candidate-claim", "complete-target", "incomplete-target"),),
    "compare-stable-refs": (("bridge-registry", "left-reference", "right-reference"),),
    "compare-unicode-claim-ids": (("nfc-claim", "nfd-claim"),),
    "compare-warrant-targets": (("left-target", "right-target"),),
    "conformance-matching": (("budget", "workload"),),
    "conformance-migration": (("budget", "workload"),),
    "conformance-normalization": (("budget", "workload"),),
    "conformance-validation": (("budget", "workload"),),
    "differential-project": (("evidence",),),
    "evaluate-admissibility-under-two-policies": (("claim", "target", "policy-a", "policy-b"),),
    "evaluate-freshness-two-query-times": (("claim", "target", "policy", "fresh-query", "stale-query"),),
    "map-migration-classification": (("lci-classification", "prior-ruling-terms"),),
    "match-target": (("target", "candidate-claim"),),
    "migrate-v1": (("source",), ("legacy-record",)),
    "migrate-v1-collision-pair": (("left-source", "right-source"),),
    "normalize-controlled-translation": (("left-receipt", "right-receipt"),),
    "normalize-preprojection-coordinate": (("coordinate", "left", "normalizer", "right"),),
    "normalize-proposition": (("budget", "workload"),),
    "parse-and-migrate-printer-variants": (("compact-source", "pretty-source"),),
    "parse-legacy-source": (("source",),),
    "project-claim-id": (("claim",), ("claim-id-substitute",), ("digest", "digest-scheme")),
    "project-occurrence": (("occurrence",),),
    "project-occurrences": (("baseline", "mutated-metadata"), ("left-occurrence", "right-occurrence"), ("comparison-coordinate", "left-occurrence", "right-occurrence")),
    "proposition-location-consistent": (("proposition", "location"),),
    "restore-live-warrant": (("source",),),
    "revive-inert-occurrence": (("predecessor", "requested-claim"),),
    "scope-relation": (("left", "right"),),
    "temporal-relation": (("left", "right"),),
    "translate-exactly": (("source-receipt", "target-receipt"),),
    "translate-with-represented-loss": (("source-claim", "target-claim", "loss"),),
    "validate-claim-id": (("claim",), ("claim", "precedence")),
    "validate-migration-result": (("migration-result",),),
    "validate-normalizer-conformance-evidence": (("binding", "mutation-vector", "semantic-projection-ledger"),),
    "validate-normalizer-revision": (("proposal",),),
    "validate-occurrence": (("occurrence",),),
    "validate-pinned-fixture": (("fixture-value", "registry-definition"),),
    "validate-policy-evaluation-target": (("target",),),
    "validate-profile-location": (("profile-location",),),
    "validate-represented-loss-account": (("operation", "account"),),
    "validate-stable-ref": (("reference",),),
    "validate-stable-ref-scheme-selection": (("domain", "canonical-scheme", "example-reference"),),
    "validate-warrant-target": (("target",), ("target", "precedence")),
    "witness-semantic-claim-id-equality": (("left-claim-id", "right-claim-id"),),
}


def _validate_operation_payload(operation: str, payload: Mapping[str, cd0.Datum]) -> None:
    schemas = OPERATION_PAYLOAD_SCHEMAS.get(operation)
    if schemas is None:
        raise FixtureAuthorityGap(
            f"operation {operation!r} is outside the frozen fixture operation set"
        )
    if any(type(name) is not str for name in payload):
        raise LCIFailure("invalid-input", "UnknownField", "fixture-operation", ("fixture-field:<non-string>",))
    supplied = set(payload)
    if any(supplied == set(schema) for schema in schemas):
        return
    best = min(
        schemas,
        key=lambda schema: (
            -len(supplied & set(schema)),
            len(set(schema) - supplied),
            schema,
        ),
    )
    unknown = sorted(supplied - set(best))
    if unknown:
        raise LCIFailure(
            "invalid-input",
            "UnknownField",
            "fixture-operation",
            (f"fixture-field:{unknown[0]}",),
        )
    missing = next(name for name in best if name not in supplied)
    raise LCIFailure(
        "invalid-input",
        "MissingRequiredField",
        "fixture-operation",
        (f"fixture-field:{missing}",),
    )


def record_to_mapping(
    value: cd0.Datum,
    *,
    namespace: tuple[str, ...] = FIXTURE_FIELD,
) -> dict[str, cd0.Datum]:
    if type(value) is not cd0.Record:
        raise LCIFailure("invalid-input", "ExpectedRecord", "fixture-vector-input")
    result: dict[str, cd0.Datum] = {}
    for key, item in value.fields:
        if key.namespace != namespace or len(key.path) != 1 or key.path[0] in result:
            raise LCIFailure("invalid-input", "UnknownField", "fixture-vector-input")
        result[key.path[0]] = item
    return result


def id_name(value: cd0.Datum) -> str:
    if type(value) is not cd0.Identifier:
        raise LCIFailure("invalid-input", "ExpectedIdentifier", "fixture-vector-input")
    return "/".join(value.path)


def datum_native(value: Any) -> Any:
    """Lossless-enough semantic view used by the language-neutral runner."""

    if isinstance(value, ClaimIdEnvelope):
        value = value.datum
    if isinstance(value, LCIFailure):
        return {
            "category": value.category,
            "code": value.code,
            "stage": value.stage,
            "path": list(value.path),
            "context": {name: datum_native(item) for name, item in value.context},
        }
    if isinstance(value, PolicyDecision):
        return {
            "accepted": value.accepted,
            "code": value.code,
            "hard-inadmissible": value.hard_inadmissible,
            "policy-consulted": value.policy_consulted,
        }
    if type(value) is bytes:
        return {"bytes-hex": value.hex()}
    if type(value) is cd0.Unit:
        return None
    if type(value) in (cd0.Boolean, cd0.Integer, cd0.String):
        return value.value
    if type(value) is cd0.Rational:
        return {"num": str(value.numerator), "den": str(value.denominator)}
    if type(value) is cd0.ByteString:
        return {"bytes-hex": value.value.hex()}
    if type(value) is cd0.Identifier:
        return {"id-namespace": list(value.namespace), "id-path": list(value.path)}
    if type(value) is cd0.Sequence:
        return [datum_native(item) for item in value.items]
    if type(value) is cd0.Record:
        return {
            "@fields": [
                {"key": datum_native(key), "value": datum_native(item)}
                for key, item in value.fields
            ]
        }
    if isinstance(value, Mapping):
        return {str(key): datum_native(item) for key, item in sorted(value.items())}
    if isinstance(value, (list, tuple)):
        return [datum_native(item) for item in value]
    return value


def _simple(value: cd0.Datum) -> Any:
    """Fixture-field keyed view for operation logic and oracle comparison."""

    if type(value) is cd0.Record:
        return {key.path[-1]: _simple(item) for key, item in value.fields}
    if type(value) is cd0.Sequence:
        return [_simple(item) for item in value.items]
    if type(value) is cd0.Identifier:
        return "/".join(value.path)
    if type(value) in (cd0.Boolean, cd0.Integer, cd0.String, cd0.ByteString):
        return value.value
    if type(value) is cd0.Rational:
        return (value.numerator, value.denominator)
    if type(value) is cd0.Unit:
        return None
    raise TypeError(type(value))


@lru_cache(maxsize=1)
def _input_rows() -> dict[str, dict]:
    # This test-fixture index does not read or retain expected results.
    result = {}
    for row in iter_vectors():
        result[row["vector_id"]] = {
            "vector_id": row["vector_id"],
            "operation": row["operation"],
            "fixture_profile_version": row["fixture_profile_version"],
            "inputs": row["inputs"],
        }
    return result


def input_payload_by_id(vector_id: str) -> dict[str, cd0.Datum]:
    row = _input_rows()[vector_id]
    document = from_package_json(row["inputs"]["abstract_cd0"], CD0_BUDGET)
    envelope = record_to_mapping(document)
    return record_to_mapping(envelope["payload"])


def _claim_coordinate_difference(left: cd0.Datum, right: cd0.Datum) -> dict[str, Any]:
    validate_claim_id(left)
    validate_claim_id(right)
    if canonical_bytes(left) == canonical_bytes(right):
        return {"same-claim-id": True, "relation": "same-claim-id"}
    if canonical_bytes(field_by_path(left, "proposition")) != canonical_bytes(field_by_path(right, "proposition")):
        return {"same-claim-id": False, "relation": "different-proposition"}
    ll, rl = field_by_path(left, "location"), field_by_path(right, "location")
    if canonical_bytes(field_by_path(ll, "scope")) != canonical_bytes(field_by_path(rl, "scope")):
        result = {"same-claim-id": False, "relation": "different-scope"}
        try:
            result["scope-relation-left-to-right"] = scope_relation(field_by_path(ll, "scope"), field_by_path(rl, "scope"))
        except LCIFailure:
            pass
        return result
    if canonical_bytes(field_by_path(ll, "subject-time")) != canonical_bytes(field_by_path(rl, "subject-time")):
        return {"same-claim-id": False, "relation": "different-subject-time"}
    lb, rb = field_by_path(ll, "basis"), field_by_path(rl, "basis")
    if canonical_bytes(lb) != canonical_bytes(rb):
        for name, relation in (
            ("revision", "different-corpus-revision"),
            ("slice", "different-dataset-slice"),
            ("semantic-boundary", "different-semantic-boundary"),
        ):
            lv, rv = field_by_path(lb, name, None), field_by_path(rb, name, None)
            if lv is not None and rv is not None and canonical_bytes(lv) != canonical_bytes(rv):
                return {"same-claim-id": False, "relation": relation}
        return {"same-claim-id": False, "relation": "different-basis"}
    if canonical_bytes(field_by_path(ll, "interpretation-frame")) != canonical_bytes(field_by_path(rl, "interpretation-frame")):
        return {"same-claim-id": False, "relation": "different-interpretation-frame"}
    return {"same-claim-id": False, "relation": "different-profile-location"}


def _target_relation_record(relation: str) -> dict[str, Any]:
    return {
        "kind": "tag/target-relation-result",
        "schema-version": 0,
        "status": "result-status/success",
        "relation": relation,
    }


def _target_relation_datum(relation: str) -> cd0.Record:
    return cd0.record(
        (
            (cd0.identifier(FIXTURE_FIELD, ("kind",)), cd0.identifier(FIXTURE, ("tag", "target-relation-result"))),
            (cd0.identifier(FIXTURE_FIELD, ("schema-version",)), cd0.integer(0)),
            (cd0.identifier(FIXTURE_FIELD, ("status",)), cd0.identifier(FIXTURE, ("result-status", "success"))),
            (cd0.identifier(FIXTURE_FIELD, ("relation",)), cd0.identifier(LCI + ("relation",), (relation,))),
        )
    )


def _fixture_stable_ref(domain: str, *object_tail: str) -> cd0.Record:
    material = cd0.record(
        (
            (cd0.identifier(FIXTURE_FIELD, ("kind",)), cd0.identifier(FIXTURE, ("tag", "fixture-stable-material"))),
            (cd0.identifier(FIXTURE_FIELD, ("schema-version",)), cd0.integer(0)),
            (cd0.identifier(FIXTURE_FIELD, ("object-id",)), cd0.identifier(FIXTURE, ("object", domain, *object_tail))),
            (cd0.identifier(FIXTURE_FIELD, ("object-version",)), cd0.integer(0)),
        )
    )
    return cd0.record(
        (
            (cd0.identifier(LCI, ("kind",)), cd0.identifier(LCI + ("tag",), ("stable-reference",))),
            (cd0.identifier(LCI, ("domain",)), cd0.identifier(FIXTURE, ("domain", domain))),
            (cd0.identifier(LCI, ("scheme",)), cd0.identifier(FIXTURE, ("scheme", domain, "structural", "0"))),
            (cd0.identifier(LCI, ("material",)), material),
        )
    )


def _policy_query_time(tick: int) -> cd0.Record:
    expression = cd0.record(
        (
            (cd0.identifier(FIXTURE_FIELD, ("kind",)), cd0.identifier(FIXTURE, ("tag", "temporal-expression"))),
            (cd0.identifier(FIXTURE_FIELD, ("schema-version",)), cd0.integer(0)),
            (cd0.identifier(FIXTURE_FIELD, ("form",)), cd0.identifier(FIXTURE, ("temporal-form", "instant"))),
            (cd0.identifier(FIXTURE_FIELD, ("tick",)), cd0.integer(tick)),
        )
    )
    return cd0.record(
        (
            (cd0.identifier(FIXTURE_FIELD, ("kind",)), cd0.identifier(FIXTURE, ("tag", "evidence-event-time"))),
            (cd0.identifier(FIXTURE_FIELD, ("schema-version",)), cd0.integer(0)),
            (cd0.identifier(FIXTURE_FIELD, ("temporal-model",)), _fixture_stable_ref("temporal-model", "mneme-fixture-time")),
            (cd0.identifier(FIXTURE_FIELD, ("temporal-role",)), cd0.identifier(FIXTURE, ("temporal-role", "policy-query-time"))),
            (cd0.identifier(FIXTURE_FIELD, ("expression",)), expression),
        )
    )


def _freshness(mode: str, threshold: int, age: int, passes: bool) -> cd0.Record:
    return cd0.record(
        (
            (cd0.identifier(FIXTURE_FIELD, ("kind",)), cd0.identifier(FIXTURE, ("tag", "freshness-evaluation"))),
            (cd0.identifier(FIXTURE_FIELD, ("schema-version",)), cd0.integer(0)),
            (cd0.identifier(FIXTURE_FIELD, ("mode",)), cd0.identifier(FIXTURE, ("freshness-mode", mode))),
            (cd0.identifier(FIXTURE_FIELD, ("threshold-ticks",)), cd0.integer(threshold)),
            (cd0.identifier(FIXTURE_FIELD, ("age-ticks",)), cd0.integer(age)),
            (cd0.identifier(FIXTURE_FIELD, ("passes",)), cd0.boolean(passes)),
        )
    )


def _admissibility_decision(
    policy: cd0.Datum,
    target_kind: str,
    target_relation: cd0.Datum,
    query_time: cd0.Datum,
    freshness: cd0.Datum,
    decision: str,
    admitted: bool,
    reasons: tuple[str, ...],
    testimony_class: str,
    policy_consulted: bool,
) -> cd0.Record:
    policy_ref = field_by_path(policy, "policy")
    validate_stable_ref(policy_ref)
    return cd0.record(
        (
            (cd0.identifier(FIXTURE_FIELD, ("kind",)), cd0.identifier(FIXTURE, ("tag", "admissibility-decision"))),
            (cd0.identifier(FIXTURE_FIELD, ("schema-version",)), cd0.integer(0)),
            (cd0.identifier(FIXTURE_FIELD, ("policy",)), policy_ref),
            (cd0.identifier(FIXTURE_FIELD, ("target-kind",)), cd0.identifier(FIXTURE, ("target-kind", target_kind))),
            (cd0.identifier(FIXTURE_FIELD, ("target-relation",)), target_relation),
            (cd0.identifier(FIXTURE_FIELD, ("query-time",)), query_time),
            (cd0.identifier(FIXTURE_FIELD, ("freshness",)), freshness),
            (cd0.identifier(FIXTURE_FIELD, ("decision",)), cd0.identifier(FIXTURE, ("admissibility-decision", decision))),
            (cd0.identifier(FIXTURE_FIELD, ("admitted",)), cd0.boolean(admitted)),
            (
                cd0.identifier(FIXTURE_FIELD, ("reasons",)),
                cd0.sequence(cd0.identifier(FIXTURE, ("admissibility-reason", reason)) for reason in reasons),
            ),
            (cd0.identifier(FIXTURE_FIELD, ("testimony-class",)), cd0.identifier(FIXTURE, ("testimony-class", testimony_class))),
            (cd0.identifier(FIXTURE_FIELD, ("policy-consulted",)), cd0.boolean(policy_consulted)),
        )
    )


def _closed_fixture_record(
    value: cd0.Datum,
    fields: tuple[str, ...],
    *,
    stage: str,
    path: tuple[str, ...],
) -> dict[str, cd0.Datum]:
    mapping = record_to_mapping(value)
    for name in fields:
        if name not in mapping:
            raise LCIFailure(
                "invalid-input",
                "MissingRequiredField",
                stage,
                path + (f"fixture-field:{name}",),
            )
    unknown = sorted(set(mapping) - set(fields))
    if unknown:
        raise LCIFailure(
            "invalid-input",
            "UnknownField",
            stage,
            path + (f"fixture-field:{unknown[0]}",),
        )
    return mapping


EXTERNAL_ARTIFACT_SCHEME = (
    "stable-ref-scheme",
    "external-fixture-source",
    "artifact",
    "0",
)


def _validate_external_artifact_reference(value: cd0.Datum) -> str:
    fields = record_to_mapping(value, namespace=LCI)
    if set(fields) != {"kind", "domain", "scheme", "material"}:
        raise LCIFailure("reference-refusal", "UnsupportedReferenceScheme", "stable-reference", ())
    material = _closed_fixture_record(
        fields["material"],
        ("source-material",),
        stage="stable-reference",
        path=("material",),
    )
    if (
        type(fields["kind"]) is not cd0.Identifier
        or fields["kind"].namespace != LCI + ("tag",)
        or fields["kind"].path != ("stable-reference",)
        or type(fields["domain"]) is not cd0.Identifier
        or fields["domain"].namespace != FIXTURE
        or fields["domain"].path != ("domain", "artifact")
        or type(fields["scheme"]) is not cd0.Identifier
        or fields["scheme"].namespace != FIXTURE
        or fields["scheme"].path != EXTERNAL_ARTIFACT_SCHEME
        or type(material["source-material"]) is not cd0.String
    ):
        raise LCIFailure("reference-refusal", "UnsupportedReferenceScheme", "stable-reference", ())
    return material["source-material"].value


def _validate_fixture_bridge(value: cd0.Datum) -> dict[str, Any]:
    fields = _closed_fixture_record(
        value,
        (
            "kind",
            "schema-version",
            "bridge-id",
            "domain",
            "source-scheme",
            "target-scheme",
            "declared-domain",
            "mapping",
            "total-over-declared-domain",
            "retroactive-structural-equality",
            "independent-test-required",
        ),
        stage="stable-reference-bridge",
        path=("bridge",),
    )
    declared = fields["declared-domain"]
    mappings = fields["mapping"]
    if (
        type(fields["kind"]) is not cd0.Identifier
        or fields["kind"].namespace != FIXTURE
        or fields["kind"].path != ("tag", "stable-reference-bridge-definition")
        or type(fields["schema-version"]) is not cd0.Integer
        or fields["schema-version"].value != 0
        or type(fields["bridge-id"]) is not cd0.Identifier
        or fields["bridge-id"].namespace != FIXTURE
        or fields["bridge-id"].path
        != ("stable-ref-bridge", "external-artifact-source-to-lci-fixture", "0")
        or type(fields["domain"]) is not cd0.Identifier
        or fields["domain"].namespace != FIXTURE
        or fields["domain"].path != ("domain", "artifact")
        or type(fields["source-scheme"]) is not cd0.Identifier
        or fields["source-scheme"].namespace != FIXTURE
        or fields["source-scheme"].path != EXTERNAL_ARTIFACT_SCHEME
        or type(fields["target-scheme"]) is not cd0.Identifier
        or fields["target-scheme"].namespace != FIXTURE
        or fields["target-scheme"].path != ("scheme", "artifact", "structural", "0")
        or type(declared) is not cd0.Sequence
        or tuple(item.value for item in declared.items if type(item) is cd0.String)
        != ("alpha-file",)
        or len(declared.items) != 1
        or type(mappings) is not cd0.Sequence
        or len(mappings.items) != 1
        or type(fields["total-over-declared-domain"]) is not cd0.Boolean
        or not fields["total-over-declared-domain"].value
        or type(fields["retroactive-structural-equality"]) is not cd0.Boolean
        or fields["retroactive-structural-equality"].value
        or type(fields["independent-test-required"]) is not cd0.Boolean
        or not fields["independent-test-required"].value
    ):
        raise LCIFailure("invalid-input", "InvalidStableRefBridge", "stable-reference-bridge", ("bridge",))
    mapping = _closed_fixture_record(
        mappings.items[0],
        ("source-material", "target-reference"),
        stage="stable-reference-bridge",
        path=("bridge", "fixture-field:mapping", "0"),
    )
    if type(mapping["source-material"]) is not cd0.String or mapping["source-material"].value != "alpha-file":
        raise LCIFailure("invalid-input", "InvalidStableRefBridge", "stable-reference-bridge", ("bridge", "fixture-field:mapping", "0"))
    target = mapping["target-reference"]
    validate_stable_ref(target, path=("bridge", "fixture-field:mapping", "0", "fixture-field:target-reference"))
    if (
        field_by_path(target, "domain").path != ("domain", "artifact")
        or field_by_path(target, "scheme").path != ("scheme", "artifact", "structural", "0")
        or field_by_path(field_by_path(target, "material"), "object-id").path
        != ("object", "artifact", "file", "alpha.txt")
        or field_by_path(field_by_path(target, "material"), "object-version").value != 0
    ):
        raise LCIFailure("invalid-input", "InvalidStableRefBridge", "stable-reference-bridge", ("bridge", "fixture-field:mapping", "0", "fixture-field:target-reference"))
    return {
        "source-material": "alpha-file",
        "target-reference": target,
        "retroactive": False,
    }


def _bridge_target(bridge: cd0.Datum, source: cd0.Datum) -> cd0.Datum:
    specification = _validate_fixture_bridge(bridge)
    source_material = _validate_external_artifact_reference(source)
    if source_material != specification["source-material"]:
        raise LCIFailure(
            "reference-refusal",
            "UnresolvedAlias",
            "stable-reference-bridge",
            ("source-reference", "material", "fixture-field:source-material"),
        )
    return specification["target-reference"]


def _fixture_policy_spec(policy: cd0.Datum) -> dict[str, Any]:
    fields = (
        "kind",
        "schema-version",
        "policy",
        "policy-name",
        "evaluation-order",
        "decision-vocabulary",
        "accepted-target-relations",
        "target-kind-rules",
        "freshness-unit",
        "represented-loss-rules",
        "inherited-testimony-treatment",
        "external-attestation-treatment",
        "trusted-external-principals",
        "scope-narrowing-permitted",
        "hard-reject-every-f-valued-target-result",
        "policy-evaluation-is-meta-testimony",
    )
    values = _closed_fixture_record(
        policy,
        fields,
        stage="admissibility",
        path=("policy",),
    )
    if (
        type(values["kind"]) is not cd0.Identifier
        or values["kind"].namespace != FIXTURE
        or values["kind"].path != ("tag", "fixture-admissibility-policy")
        or type(values["schema-version"]) is not cd0.Integer
        or values["schema-version"].value != 0
    ):
        raise LCIFailure("invalid-input", "UnsupportedFixturePolicy", "admissibility", ("policy",))
    name_value = values["policy-name"]
    if (
        type(name_value) is not cd0.Identifier
        or name_value.namespace != FIXTURE
        or name_value.path not in (("fixture-policy", "policy-a"), ("fixture-policy", "policy-b"))
    ):
        raise LCIFailure("invalid-input", "UnsupportedFixturePolicy", "admissibility", ("policy", "fixture-field:policy-name"))
    name = name_value.path[-1]
    policy_ref = values["policy"]
    validate_stable_ref(policy_ref, path=("policy", "fixture-field:policy"))
    material = field_by_path(policy_ref, "material")
    expected_object = ("object", "policy", f"admissibility-{name}")
    if (
        field_by_path(policy_ref, "domain").path != ("domain", "policy")
        or field_by_path(material, "object-id").path != expected_object
        or field_by_path(material, "object-version").value != 0
    ):
        raise LCIFailure("invalid-input", "UnsupportedFixturePolicy", "admissibility", ("policy", "fixture-field:policy"))

    rules_value = values["target-kind-rules"]
    if type(rules_value) is not cd0.Sequence:
        raise LCIFailure("invalid-input", "UnsupportedFixturePolicy", "admissibility", ("policy", "fixture-field:target-kind-rules"))
    rules: dict[str, tuple[str, str, int]] = {}
    for index, rule in enumerate(rules_value.items):
        rule_path = ("policy", "fixture-field:target-kind-rules", str(index))
        item = _closed_fixture_record(
            rule,
            ("target-kind", "disposition", "freshness-mode", "freshness-threshold-ticks"),
            stage="admissibility",
            path=rule_path,
        )
        kind, disposition, mode, threshold = (
            item["target-kind"],
            item["disposition"],
            item["freshness-mode"],
            item["freshness-threshold-ticks"],
        )
        if (
            type(kind) is not cd0.Identifier
            or kind.namespace != FIXTURE
            or len(kind.path) != 2
            or kind.path[0] != "target-kind"
            or type(disposition) is not cd0.Identifier
            or disposition.namespace != FIXTURE
            or len(disposition.path) != 2
            or disposition.path[0] != "policy-kind-disposition"
            or type(mode) is not cd0.Identifier
            or mode.namespace != FIXTURE
            or len(mode.path) != 2
            or mode.path[0] != "freshness-mode"
            or type(threshold) is not cd0.Integer
            or threshold.value < 0
            or kind.path[-1] in rules
        ):
            raise LCIFailure("invalid-input", "UnsupportedFixturePolicy", "admissibility", rule_path)
        rules[kind.path[-1]] = (disposition.path[-1], mode.path[-1], threshold.value)

    loss_rules_value = values["represented-loss-rules"]
    if type(loss_rules_value) is not cd0.Sequence:
        raise LCIFailure("invalid-input", "UnsupportedFixturePolicy", "admissibility", ("policy", "fixture-field:represented-loss-rules"))
    loss_rules: dict[str, str] = {}
    for index, rule in enumerate(loss_rules_value.items):
        rule_path = ("policy", "fixture-field:represented-loss-rules", str(index))
        item = _closed_fixture_record(
            rule,
            ("consequence", "disposition"),
            stage="admissibility",
            path=rule_path,
        )
        consequence, disposition = item["consequence"], item["disposition"]
        if (
            type(consequence) is not cd0.Identifier
            or consequence.namespace != LCI + ("relation",)
            or len(consequence.path) != 1
            or type(disposition) is not cd0.Identifier
            or disposition.namespace != FIXTURE
            or len(disposition.path) != 2
            or disposition.path[0] != "policy-loss-disposition"
            or consequence.path[-1] in loss_rules
        ):
            raise LCIFailure("invalid-input", "UnsupportedFixturePolicy", "admissibility", rule_path)
        loss_rules[consequence.path[-1]] = disposition.path[-1]

    accepted_value = values["accepted-target-relations"]
    if type(accepted_value) is not cd0.Sequence:
        raise LCIFailure("invalid-input", "UnsupportedFixturePolicy", "admissibility", ("policy", "fixture-field:accepted-target-relations"))
    accepted: set[str] = set()
    for index, relation in enumerate(accepted_value.items):
        if (
            type(relation) is not cd0.Identifier
            or relation.namespace != LCI + ("relation",)
            or relation.path not in (("exact-target",), ("supports-by-scope-narrowing",))
        ):
            raise LCIFailure("invalid-input", "UnsupportedFixturePolicy", "admissibility", ("policy", "fixture-field:accepted-target-relations", str(index)))
        accepted.add(relation.path[-1])

    trusted_value = values["trusted-external-principals"]
    if type(trusted_value) is not cd0.Sequence:
        raise LCIFailure("invalid-input", "UnsupportedFixturePolicy", "admissibility", ("policy", "fixture-field:trusted-external-principals"))
    trusted: set[bytes] = set()
    for index, principal in enumerate(trusted_value.items):
        validate_stable_ref(principal, path=("policy", "fixture-field:trusted-external-principals", str(index)))
        if field_by_path(principal, "domain").path != ("domain", "principal"):
            raise LCIFailure("invalid-input", "UnsupportedFixturePolicy", "admissibility", ("policy", "fixture-field:trusted-external-principals", str(index)))
        trusted.add(canonical_bytes(principal))

    for flag in (
        "scope-narrowing-permitted",
        "hard-reject-every-f-valued-target-result",
        "policy-evaluation-is-meta-testimony",
    ):
        if type(values[flag]) is not cd0.Boolean:
            raise LCIFailure("invalid-input", "UnsupportedFixturePolicy", "admissibility", ("policy", f"fixture-field:{flag}"))
    return {
        "name": name,
        "rules": rules,
        "loss-rules": loss_rules,
        "accepted": frozenset(accepted),
        "trusted": frozenset(trusted),
        "scope-narrowing": values["scope-narrowing-permitted"].value,
        "hard-floor": values["hard-reject-every-f-valued-target-result"].value,
        "meta-testimony": values["policy-evaluation-is-meta-testimony"].value,
    }


def _event_tick(value: cd0.Datum, role: str) -> int:
    fields = _closed_fixture_record(
        value,
        ("kind", "schema-version", "temporal-model", "temporal-role", "expression"),
        stage="admissibility",
        path=("query-time",),
    )
    validate_stable_ref(fields["temporal-model"], path=("query-time", "fixture-field:temporal-model"))
    expression = _closed_fixture_record(
        fields["expression"],
        ("kind", "schema-version", "form", "tick"),
        stage="admissibility",
        path=("query-time", "fixture-field:expression"),
    )
    if (
        type(fields["kind"]) is not cd0.Identifier
        or fields["kind"].namespace != FIXTURE
        or fields["kind"].path != ("tag", "evidence-event-time")
        or type(fields["schema-version"]) is not cd0.Integer
        or fields["schema-version"].value != 0
        or type(fields["temporal-role"]) is not cd0.Identifier
        or fields["temporal-role"].namespace != FIXTURE
        or fields["temporal-role"].path != ("temporal-role", role)
        or type(expression["kind"]) is not cd0.Identifier
        or expression["kind"].namespace != FIXTURE
        or expression["kind"].path != ("tag", "temporal-expression")
        or type(expression["schema-version"]) is not cd0.Integer
        or expression["schema-version"].value != 0
        or type(expression["form"]) is not cd0.Identifier
        or expression["form"].namespace != FIXTURE
        or expression["form"].path != ("temporal-form", "instant")
        or type(expression["tick"]) is not cd0.Integer
    ):
        raise LCIFailure("invalid-input", "InvalidPolicyQueryTime", "admissibility", ("query-time",))
    return expression["tick"].value


def _relation_result_from_datum(value: cd0.Datum) -> RelationResult:
    fields = record_to_mapping(value)
    status = field_by_path(value, "status")
    if type(status) is not cd0.Identifier or status.namespace != FIXTURE or len(status.path) != 2 or status.path[0] != "result-status":
        raise LCIFailure("invalid-input", "InvalidTargetRelationResult", "admissibility", ("target-relation",))
    if status.path[-1] == "success":
        if set(fields) != {"kind", "schema-version", "status", "relation"}:
            raise LCIFailure("invalid-input", "InvalidTargetRelationResult", "admissibility", ("target-relation",))
        relation = field_by_path(value, "relation")
        if type(relation) is not cd0.Identifier or relation.namespace != LCI + ("relation",) or relation.path not in (("exact-target",), ("supports-by-scope-narrowing",)):
            raise LCIFailure("invalid-input", "InvalidTargetRelationResult", "admissibility", ("target-relation", "relation"))
        return RelationResult(relation.path[-1])
    if status.path[-1] != "failure" or set(fields) != {"kind", "schema-version", "status", "failure"}:
        raise LCIFailure("invalid-input", "InvalidTargetRelationResult", "admissibility", ("target-relation",))
    failure_value = field_by_path(value, "failure")
    category = field_by_path(failure_value, "category")
    code = field_by_path(failure_value, "code")
    stage = field_by_path(failure_value, "stage")
    path_value = field_by_path(failure_value, "path")
    if (
        type(category) is not cd0.Identifier
        or type(code) is not cd0.Identifier
        or type(stage) is not cd0.Identifier
        or type(path_value) is not cd0.Sequence
        or any(type(item) is not cd0.Identifier for item in path_value.items)
    ):
        raise LCIFailure("invalid-input", "InvalidTargetRelationResult", "admissibility", ("target-relation", "failure"))
    return RelationResult(
        failure=LCIFailure(
            category.path[-1],
            code.path[-1],
            stage.path[-1],
            tuple(item.path[-1] for item in path_value.items),
        )
    )


def _target_failure_datum(failure: LCIFailure) -> cd0.Record:
    failure_record = cd0.record(
        (
            (cd0.identifier(LCI, ("kind",)), cd0.identifier(LCI + ("tag",), ("failure",))),
            (cd0.identifier(LCI, ("schema-version",)), cd0.integer(0)),
            (cd0.identifier(LCI, ("category",)), cd0.identifier(LCI + ("failure",), (failure.category,))),
            (cd0.identifier(LCI, ("code",)), cd0.identifier(LCI + ("failure",), (failure.code,))),
            (cd0.identifier(LCI, ("stage",)), cd0.identifier(LCI + ("failure",), (failure.stage,))),
            (
                cd0.identifier(LCI, ("path",)),
                cd0.sequence(
                    cd0.identifier(FIXTURE_FIELD if segment.startswith("fixture-field:") else LCI, (segment.split(":", 1)[-1],))
                    for segment in failure.path
                ),
            ),
            (
                cd0.identifier(LCI, ("context",)),
                cd0.record(
                    (
                        cd0.identifier(FIXTURE_FIELD if name.startswith("fixture-field:") else LCI, (name.split(":", 1)[-1],)),
                        item,
                    )
                    for name, item in failure.context
                ),
            ),
        )
    )
    return cd0.record(
        (
            (cd0.identifier(FIXTURE_FIELD, ("kind",)), cd0.identifier(FIXTURE, ("tag", "target-relation-result"))),
            (cd0.identifier(FIXTURE_FIELD, ("schema-version",)), cd0.integer(0)),
            (cd0.identifier(FIXTURE_FIELD, ("status",)), cd0.identifier(FIXTURE, ("result-status", "failure"))),
            (cd0.identifier(FIXTURE_FIELD, ("failure",)), failure_record),
        )
    )


def _hard_reject_decision(
    policy: cd0.Datum,
    target_relation: cd0.Datum,
    *,
    target_kind: str = "observed",
    query_time: cd0.Datum | None = None,
) -> cd0.Record:
    spec = _fixture_policy_spec(policy)
    relation = _relation_result_from_datum(target_relation)
    floor = apply_admissibility_floor(relation, lambda _: PolicyDecision(True, "floor-passed"))
    if not spec["hard-floor"] or not floor.hard_inadmissible:
        raise LCIFailure(
            "relation-undetermined",
            "AdmissibilityUndetermined",
            "admissibility",
            ("target-relation",),
        )
    return _admissibility_decision(
        policy,
        target_kind,
        target_relation,
        _policy_query_time(124) if query_time is None else query_time,
        _freshness("not-evaluated", 0, 0, False),
        "hard-reject-target-relation",
        False,
        ("f-valued-target-result", "policy-not-consulted"),
        "rejected",
        False,
    )


def _evaluate_fixture_policy(
    policy: cd0.Datum,
    target: cd0.Datum,
    claim: cd0.Datum,
    *,
    query_time: cd0.Datum | None = None,
) -> tuple[cd0.Record, bool]:
    spec = _fixture_policy_spec(policy)
    result = match_target(target, claim)
    target_kind_value = field_by_path(target, "target-kind")
    target_kind = target_kind_value.path[-1]
    relation_value = (
        _target_relation_datum(result.relation)
        if result.success
        else _target_failure_datum(result.failure)
    )
    if not result.success:
        decision = _hard_reject_decision(
            policy,
            relation_value,
            target_kind=target_kind,
            query_time=query_time,
        )
        return decision, False

    boundaries = field_by_path(target, "boundaries")
    event_fields = {
        "observed": ("observation-time", "observation-time"),
        "executed": ("execution-time", "execution-time"),
        "tested": ("execution-time", "test-execution-time"),
        "externally-attested": ("attestation-time", "attestation-time"),
        "replayed": ("replay-time", "replay-time"),
        "corpus-completion": ("execution-time", "search-execution-time"),
        "reported": ("report-time", "report-time"),
        "policy-evaluation": ("query-time", "policy-query-time"),
    }
    event_tick: int | None = None
    if target_kind in event_fields:
        field_name, role = event_fields[target_kind]
        event_tick = _event_tick(field_by_path(boundaries, field_name), role)
    if query_time is None:
        query_time = _policy_query_time(124 if event_tick is None else event_tick)
    query_tick = _event_tick(query_time, "policy-query-time")
    if event_tick is None:
        event_tick = query_tick
    age = query_tick - event_tick
    if age < 0:
        raise LCIFailure("invalid-input", "InvalidPolicyQueryTime", "admissibility", ("query-time",))

    rule = spec["rules"].get(target_kind)
    if rule is None:
        raise LCIFailure("invalid-input", "UnsupportedFixturePolicy", "admissibility", ("policy", "fixture-field:target-kind-rules"))
    disposition, freshness_mode, threshold = rule
    freshness_value = _freshness("not-evaluated", 0, 0, False)
    if disposition in {"reject", "reject-inherited"}:
        decision_code = "reject-inherited-testimony" if disposition == "reject-inherited" else "reject-target-kind"
        decision = _admissibility_decision(
            policy,
            target_kind,
            relation_value,
            query_time,
            freshness_value,
            decision_code,
            False,
            ("target-relation-success", "target-kind-rejected-by-policy"),
            "rejected",
            True,
        )
        return decision, False

    if result.relation not in spec["accepted"]:
        raise LCIFailure("relation-undetermined", "AdmissibilityUndetermined", "admissibility", ("target-relation",))
    if result.relation == "supports-by-scope-narrowing" and not spec["scope-narrowing"]:
        decision = _admissibility_decision(
            policy,
            target_kind,
            relation_value,
            query_time,
            freshness_value,
            "reject-scope-narrowing",
            False,
            ("target-relation-success", "scope-narrowing-rejected"),
            "rejected",
            True,
        )
        return decision, False

    represented_loss = field_by_path(boundaries, "represented-loss", None)
    loss_disposition: str | None = None
    if represented_loss is not None:
        validate_represented_loss(represented_loss, ("boundaries", "represented-loss"))
        consequence = field_by_path(represented_loss, "consequence").path[-1]
        loss_disposition = spec["loss-rules"].get(consequence)
        if loss_disposition is None:
            raise LCIFailure("invalid-input", "UnsupportedFixturePolicy", "admissibility", ("policy", "fixture-field:represented-loss-rules"))

    trusted_external = True
    if target_kind == "externally-attested":
        principal = field_by_path(boundaries, "external-principal")
        trusted_external = canonical_bytes(principal) in spec["trusted"]

    stale = freshness_mode == "maximum-age" and age > threshold
    if stale and (represented_loss is not None or not trusted_external):
        raise LCIFailure(
            "relation-undetermined",
            "AdmissibilityUndetermined",
            "admissibility",
            ("policy-evaluation-order",),
        )
    if loss_disposition == "reject":
        decision = _admissibility_decision(
            policy,
            target_kind,
            relation_value,
            query_time,
            freshness_value,
            "reject-represented-loss",
            False,
            ("target-relation-success", "kind-permitted", "represented-loss-rejected"),
            "rejected",
            True,
        )
        return decision, False
    if target_kind == "externally-attested" and disposition == "direct-if-trusted-principal" and not trusted_external:
        raise LCIFailure(
            "relation-undetermined",
            "AdmissibilityUndetermined",
            "admissibility",
            ("external-principal-decision-vocabulary",),
        )

    if freshness_mode == "maximum-age":
        freshness_value = _freshness("maximum-age", threshold, age, not stale)
    elif freshness_mode == "not-applicable":
        freshness_value = _freshness("not-applicable", 0, 0, True)
    else:
        raise LCIFailure("invalid-input", "UnsupportedFixturePolicy", "admissibility", ("policy", "fixture-field:target-kind-rules"))
    if stale:
        decision = _admissibility_decision(
            policy,
            target_kind,
            relation_value,
            query_time,
            freshness_value,
            "reject-stale",
            False,
            ("target-relation-success", "kind-permitted", "age-exceeds-threshold"),
            "rejected",
            True,
        )
        return decision, False

    limited = disposition in {"limited-testimony", "limited-meta-testimony"} or loss_disposition == "limited-testimony"
    if limited:
        decision_code = "accept-limited-testimony"
        testimony_class = "limited-testimony"
    elif result.relation == "supports-by-scope-narrowing":
        decision_code = "accept-scope-narrowed"
        testimony_class = "scope-narrowed-support"
    else:
        decision_code = "accept-direct"
        testimony_class = "direct-support"
    reasons = ["target-relation-success", "kind-permitted"]
    if target_kind == "externally-attested":
        reasons.append("trusted-external-principal")
    if freshness_mode == "maximum-age":
        reasons.append("fresh")
    if limited:
        reasons.append("limited-testimony")
    if result.relation == "supports-by-scope-narrowing":
        reasons.append("scope-narrowing-permitted")
    decision = _admissibility_decision(
        policy,
        target_kind,
        relation_value,
        query_time,
        freshness_value,
        decision_code,
        True,
        tuple(reasons),
        testimony_class,
        True,
    )
    return decision, True


def _validate_preprojection_contract(value: cd0.Datum, coordinate: str) -> None:
    fields = _closed_fixture_record(
        value,
        (
            "kind",
            "schema-version",
            "coordinates",
            "properties",
            "co-denotation-rule",
            "neutral-frame-rule",
        ),
        stage="normalization",
        path=("fixture-field:normalizer",),
    )
    expected_coordinates = (
        "scope",
        "subject-time",
        "interpretation-frame",
        "dataset-slice",
        "semantic-boundary",
    )
    expected_properties = (
        "total-over-declared-domain",
        "deterministic",
        "versioned",
        "pure",
        "ambient-state-independent",
        "loss-reporting",
        "before-projection",
    )
    coordinates = fields["coordinates"]
    properties = fields["properties"]
    valid = (
        type(fields["kind"]) is cd0.Identifier
        and fields["kind"].namespace == FIXTURE
        and fields["kind"].path == ("tag", "preprojection-normalization-contract")
        and type(fields["schema-version"]) is cd0.Integer
        and fields["schema-version"].value == 0
        and type(coordinates) is cd0.Sequence
        and tuple(
            item.path[-1]
            for item in coordinates.items
            if type(item) is cd0.Identifier
            and item.namespace == FIXTURE
            and len(item.path) == 2
            and item.path[0] == "claim-coordinate"
        )
        == expected_coordinates
        and len(coordinates.items) == len(expected_coordinates)
        and type(properties) is cd0.Sequence
        and tuple(
            item.path[-1]
            for item in properties.items
            if type(item) is cd0.Identifier
            and item.namespace == FIXTURE
            and len(item.path) == 2
            and item.path[0] == "normalizer-property"
        )
        == expected_properties
        and len(properties.items) == len(expected_properties)
        and type(fields["co-denotation-rule"]) is cd0.Identifier
        and fields["co-denotation-rule"].namespace == FIXTURE
        and fields["co-denotation-rule"].path
        == (
            "normalization-rule",
            "structural-distinction-remains-unless-exact-normalizer-merges",
        )
        and type(fields["neutral-frame-rule"]) is cd0.Identifier
        and fields["neutral-frame-rule"].namespace == FIXTURE
        and fields["neutral-frame-rule"].path
        == (
            "normalization-rule",
            "no-meaning-context-uses-exact-neutral-frame",
        )
        and coordinate in expected_coordinates
    )
    if not valid:
        raise LCIFailure(
            "invalid-input",
            "UnsupportedNormalizer",
            "normalization",
            ("fixture-field:normalizer",),
        )


def _normalize_preprojection_coordinate(
    coordinate_value: cd0.Datum,
    normalizer: cd0.Datum,
    value: cd0.Datum,
    *,
    side: str,
) -> cd0.Datum:
    if (
        type(coordinate_value) is not cd0.Identifier
        or coordinate_value.namespace != FIXTURE
        or len(coordinate_value.path) != 2
        or coordinate_value.path[0] != "claim-coordinate"
    ):
        raise LCIFailure(
            "invalid-input",
            "UnsupportedNormalizer",
            "normalization",
            ("fixture-field:coordinate",),
        )
    coordinate = coordinate_value.path[-1]
    _validate_preprojection_contract(normalizer, coordinate)
    path = (f"fixture-field:{side}",)
    validators = {
        "scope": lambda item: validate_scope(item, path=path),
        "subject-time": lambda item: validate_subject_time(item, path=path),
        "interpretation-frame": lambda item: validate_frame(item, path),
        "dataset-slice": lambda item: validate_dataset_slice(item, path),
        "semantic-boundary": lambda item: validate_semantic_boundary(item, path),
    }
    validator = validators.get(coordinate)
    if validator is None:
        raise LCIFailure(
            "invalid-input",
            "UnsupportedNormalizer",
            "normalization",
            ("fixture-field:coordinate",),
        )
    validator(value)
    # The frozen contract declares structural preservation for these already
    # canonical fixture values; it authorizes no denotational inference.
    return value


def _validate_differential_evidence(value: cd0.Datum) -> tuple[cd0.Datum, cd0.Datum]:
    fields = _closed_fixture_record(
        value,
        (
            "kind",
            "schema-version",
            "same-input",
            "declared-profile",
            "left-normalizer",
            "right-normalizer",
            "left-output",
            "right-output",
        ),
        stage="projection",
        path=("fixture-field:evidence",),
    )
    if (
        type(fields["kind"]) is not cd0.Identifier
        or fields["kind"].namespace != FIXTURE
        or fields["kind"].path != ("tag", "differential-projector-evidence")
        or type(fields["schema-version"]) is not cd0.Integer
        or fields["schema-version"].value != 0
    ):
        raise LCIFailure("invalid-input", "InvalidDifferentialEvidence", "projection", ("fixture-field:evidence",))
    validate_proposition_location_consistency(
        fields["same-input"],
        field_by_path(fields["left-output"], "location"),
    )
    left = validate_claim_id(fields["left-output"])
    right = validate_claim_id(fields["right-output"])
    if canonical_bytes(fields["same-input"]) != canonical_bytes(field_by_path(left, "proposition")):
        raise LCIFailure("invalid-input", "InvalidDifferentialEvidence", "projection", ("fixture-field:evidence", "fixture-field:same-input"))
    profile = record_to_mapping(fields["declared-profile"], namespace=LCI)
    if set(profile) != {"kind", "profile-id", "profile-version"}:
        raise LCIFailure("invalid-input", "InvalidDifferentialEvidence", "claim-profile", ("fixture-field:evidence", "fixture-field:declared-profile"))
    if (
        field_by_path(fields["left-output"], "claim-profile") != fields["declared-profile"]
        or field_by_path(fields["right-output"], "claim-profile") != fields["declared-profile"]
        or type(profile["kind"]) is not cd0.Identifier
        or profile["kind"].namespace != LCI + ("tag",)
        or profile["kind"].path != ("claim-profile",)
        or type(profile["profile-id"]) is not cd0.Identifier
        or profile["profile-id"].namespace != ("lisp-plus", "mneme")
        or profile["profile-id"].path != ("located-claim",)
        or type(profile["profile-version"]) is not cd0.Integer
        or profile["profile-version"].value != 0
    ):
        raise LCIFailure("invalid-input", "InvalidDifferentialEvidence", "claim-profile", ("fixture-field:evidence", "fixture-field:declared-profile"))
    for side in ("left", "right"):
        normalizer = fields[f"{side}-normalizer"]
        validate_stable_ref(normalizer, path=("fixture-field:evidence", f"fixture-field:{side}-normalizer"))
        if field_by_path(normalizer, "domain").path != ("domain", "procedure"):
            raise LCIFailure("invalid-input", "InvalidDifferentialEvidence", "projection", ("fixture-field:evidence", f"fixture-field:{side}-normalizer"))
    return left, right


def _validate_claim_profile(value: cd0.Datum, path: tuple[str, ...]) -> None:
    fields = record_to_mapping(value, namespace=LCI)
    if set(fields) != {"kind", "profile-id", "profile-version"}:
        raise LCIFailure("unsupported-version-or-profile", "UnsupportedClaimProfile", "claim-profile", path)
    if (
        type(fields["kind"]) is not cd0.Identifier
        or fields["kind"].namespace != LCI + ("tag",)
        or fields["kind"].path != ("claim-profile",)
        or type(fields["profile-id"]) is not cd0.Identifier
        or fields["profile-id"].namespace != ("lisp-plus", "mneme")
        or fields["profile-id"].path != ("located-claim",)
        or type(fields["profile-version"]) is not cd0.Integer
        or fields["profile-version"].value != 0
    ):
        raise LCIFailure("unsupported-version-or-profile", "UnsupportedClaimProfile", "claim-profile", path)


def _validate_stable_domain(value: cd0.Datum, domain: str, path: tuple[str, ...]) -> None:
    validate_stable_ref(value, path=path)
    if field_by_path(value, "domain").path != ("domain", domain):
        raise LCIFailure("invalid-input", "InvalidConformanceEvidence", "normalizer-conformance", path)


def _validate_surface_proposition(value: cd0.Datum, path: tuple[str, ...]) -> None:
    fields = _closed_fixture_record(
        value,
        ("kind", "schema-version", "syntax", "operator", "arguments"),
        stage="normalizer-conformance",
        path=path,
    )
    if (
        type(fields["kind"]) is not cd0.Identifier
        or fields["kind"].namespace != FIXTURE
        or fields["kind"].path != ("tag", "surface-proposition")
        or type(fields["schema-version"]) is not cd0.Integer
        or fields["schema-version"].value != 0
        or type(fields["syntax"]) is not cd0.Identifier
        or fields["syntax"].namespace != FIXTURE
        or type(fields["operator"]) is not cd0.Identifier
        or fields["operator"].namespace != FIXTURE
        or type(fields["arguments"]) is not cd0.Record
    ):
        raise LCIFailure("invalid-input", "InvalidConformanceEvidence", "normalizer-conformance", path)


def _validate_normalizer_conformance(
    binding_value: cd0.Datum,
    mutation_value: cd0.Datum,
    ledger_value: cd0.Datum,
) -> None:
    binding = _closed_fixture_record(
        binding_value,
        (
            "kind",
            "schema-version",
            "claim-profile",
            "normalizer-revision",
            "normalizer-procedure",
            "normalizer-content-identity",
            "mutation-vector",
            "semantic-projection-ledger",
            "total-over-declared-domain",
            "deterministic",
            "pure",
            "ambient-state-independent",
            "loss-reporting",
        ),
        stage="normalizer-conformance",
        path=("fixture-field:binding",),
    )
    if (
        type(binding["kind"]) is not cd0.Identifier
        or binding["kind"].namespace != FIXTURE
        or binding["kind"].path != ("tag", "profile-normalizer-conformance-binding")
        or type(binding["schema-version"]) is not cd0.Integer
        or binding["schema-version"].value != 0
        or type(binding["normalizer-revision"]) is not cd0.Integer
        or binding["normalizer-revision"].value != 0
    ):
        raise LCIFailure("invalid-input", "InvalidConformanceEvidence", "normalizer-conformance", ("fixture-field:binding",))
    _validate_claim_profile(binding["claim-profile"], ("fixture-field:binding", "fixture-field:claim-profile"))
    _validate_stable_domain(binding["normalizer-procedure"], "procedure", ("fixture-field:binding", "fixture-field:normalizer-procedure"))
    for name in ("normalizer-content-identity", "mutation-vector", "semantic-projection-ledger"):
        _validate_stable_domain(binding[name], "artifact", ("fixture-field:binding", f"fixture-field:{name}"))
    expected_objects = {
        "normalizer-procedure": ("object", "procedure", "mneme-proposition-normalizer"),
        "normalizer-content-identity": ("object", "artifact", "normative-source", "mneme-proposition-normalizer", "0"),
        "mutation-vector": ("object", "artifact", "mutation-vector", "mneme-proposition-normalizer", "0"),
        "semantic-projection-ledger": ("object", "artifact", "semantic-projection-ledger", "mneme-proposition-normalizer", "0"),
    }
    for name, expected_object in expected_objects.items():
        material = field_by_path(binding[name], "material")
        if (
            field_by_path(material, "object-id").path != expected_object
            or field_by_path(material, "object-version").value != 0
        ):
            raise LCIFailure("invalid-input", "InvalidConformanceEvidence", "normalizer-conformance", ("fixture-field:binding", f"fixture-field:{name}"))
    for name in (
        "total-over-declared-domain",
        "deterministic",
        "pure",
        "ambient-state-independent",
        "loss-reporting",
    ):
        if type(binding[name]) is not cd0.Boolean or not binding[name].value:
            raise LCIFailure("invalid-input", "InvalidConformanceEvidence", "normalizer-conformance", ("fixture-field:binding", f"fixture-field:{name}"))

    mutation = _closed_fixture_record(
        mutation_value,
        ("kind", "schema-version", "revision", "base-input", "mutation", "expected-code", "expected-stage"),
        stage="normalizer-conformance",
        path=("fixture-field:mutation-vector",),
    )
    mutation_record = _closed_fixture_record(
        mutation["mutation"],
        ("operation", "field", "value"),
        stage="normalizer-conformance",
        path=("fixture-field:mutation-vector", "fixture-field:mutation"),
    )
    if (
        type(mutation["kind"]) is not cd0.Identifier
        or mutation["kind"].namespace != FIXTURE
        or mutation["kind"].path != ("tag", "normalizer-mutation-vector")
        or type(mutation["schema-version"]) is not cd0.Integer
        or mutation["schema-version"].value != 0
        or type(mutation["revision"]) is not cd0.Integer
        or mutation["revision"].value != binding["normalizer-revision"].value
        or type(mutation["expected-code"]) is not cd0.Identifier
        or mutation["expected-code"].namespace != LCI + ("failure",)
        or type(mutation["expected-stage"]) is not cd0.Identifier
        or mutation["expected-stage"].namespace != LCI + ("failure",)
        or type(mutation_record["operation"]) is not cd0.Identifier
        or mutation_record["operation"].namespace != FIXTURE
        or type(mutation_record["field"]) is not cd0.Identifier
        or mutation_record["field"].namespace != FIXTURE_FIELD
        or len(mutation_record["field"].path) != 1
    ):
        raise LCIFailure("invalid-input", "InvalidConformanceEvidence", "normalizer-conformance", ("fixture-field:mutation-vector",))
    _validate_surface_proposition(mutation["base-input"], ("fixture-field:mutation-vector", "fixture-field:base-input"))

    ledger = _closed_fixture_record(
        ledger_value,
        (
            "kind",
            "schema-version",
            "normalizer-revision",
            "normative-source",
            "before-revision",
            "after-profile-version",
            "after-frame-schema",
            "accepted-abstract-input-change",
            "normalized-proposition-change",
            "claim-id-change",
            "relation-change",
            "failure-change",
            "mappings",
        ),
        stage="normalizer-conformance",
        path=("fixture-field:semantic-projection-ledger",),
    )
    if (
        type(ledger["kind"]) is not cd0.Identifier
        or ledger["kind"].namespace != FIXTURE
        or ledger["kind"].path != ("tag", "semantic-projection-ledger")
        or type(ledger["schema-version"]) is not cd0.Integer
        or ledger["schema-version"].value != 0
        or type(ledger["normalizer-revision"]) is not cd0.Integer
        or ledger["normalizer-revision"].value != binding["normalizer-revision"].value
        or type(ledger["after-profile-version"]) is not cd0.Integer
        or ledger["after-profile-version"].value != 0
        or type(ledger["before-revision"]) is not cd0.Identifier
        or ledger["before-revision"].namespace != FIXTURE
        or type(ledger["mappings"]) is not cd0.Sequence
        or not ledger["mappings"].items
    ):
        raise LCIFailure("invalid-input", "InvalidConformanceEvidence", "normalizer-conformance", ("fixture-field:semantic-projection-ledger",))
    _validate_stable_domain(ledger["normative-source"], "artifact", ("fixture-field:semantic-projection-ledger", "fixture-field:normative-source"))
    _validate_stable_domain(ledger["after-frame-schema"], "interpretation-frame-schema", ("fixture-field:semantic-projection-ledger", "fixture-field:after-frame-schema"))
    if canonical_bytes(ledger["normative-source"]) != canonical_bytes(binding["normalizer-content-identity"]):
        raise LCIFailure("invalid-input", "InvalidConformanceEvidence", "normalizer-conformance", ("fixture-field:semantic-projection-ledger", "fixture-field:normative-source"))
    for name in (
        "accepted-abstract-input-change",
        "normalized-proposition-change",
        "claim-id-change",
        "relation-change",
        "failure-change",
    ):
        if type(ledger[name]) is not cd0.Boolean:
            raise LCIFailure("invalid-input", "InvalidConformanceEvidence", "normalizer-conformance", ("fixture-field:semantic-projection-ledger", f"fixture-field:{name}"))
    for index, mapping in enumerate(ledger["mappings"].items):
        item = _closed_fixture_record(
            mapping,
            ("source", "normalized-proposition"),
            stage="normalizer-conformance",
            path=("fixture-field:semantic-projection-ledger", "fixture-field:mappings", str(index)),
        )
        _validate_surface_proposition(item["source"], ("fixture-field:semantic-projection-ledger", "fixture-field:mappings", str(index), "fixture-field:source"))
        validate_proposition(item["normalized-proposition"])


MIGRATION_CLASSIFICATIONS = frozenset(
    {
        "exact",
        "exact-after-explicit-tagging",
        "new-identity-required",
        "lossy-with-represented-loss",
        "rejected",
        "deferred-to-named-calculus",
        "privileged-runtime-relation-outside-claim-id",
    }
)


def _migration_classification_name(value: cd0.Datum) -> str:
    if (
        type(value) is not cd0.Identifier
        or value.namespace != FIXTURE
        or len(value.path) != 2
        or value.path[0] != "migration-classification"
        or value.path[-1] not in MIGRATION_CLASSIFICATIONS
    ):
        raise LCIFailure("invalid-input", "InvalidMigrationClassification", "migration-mapping", ("fixture-field:lci-classification",))
    return value.path[-1]


def _validate_translation_receipt(value: cd0.Datum, path: tuple[str, ...]) -> cd0.Datum:
    fields = _closed_fixture_record(
        value,
        ("surface", "source-language", "normalized-claim-id"),
        stage="translation",
        path=path,
    )
    if (
        type(fields["surface"]) is not cd0.String
        or type(fields["source-language"]) is not cd0.Identifier
        or fields["source-language"].namespace != FIXTURE
        or len(fields["source-language"].path) != 2
        or fields["source-language"].path[0] != "language"
    ):
        raise LCIFailure("invalid-input", "InvalidTranslationReceipt", "translation", path)
    validate_claim_id(fields["normalized-claim-id"])
    return fields["normalized-claim-id"]


def _claim_content_utf8(value: cd0.Datum) -> bytes:
    proposition = field_by_path(value, "proposition")
    arguments = field_by_path(proposition, "arguments")
    content = field_by_path(field_by_path(arguments, "content"), "value")
    if type(content) is not cd0.String:
        raise LCIFailure("invalid-input", "InvalidUnicodeFixture", "fixture-operation", ("proposition", "arguments", "content"))
    return content.value.encode("utf-8")


def _revived_occurrence(predecessor: cd0.Datum, requested_claim: cd0.Datum) -> cd0.Record:
    """Return only the input-derived inert revival invariant.

    No frozen algorithm authorizes inventing claimant, time, provenance,
    lineage, presentation, or metadata values.  Preserve the validated input
    occurrence in a fresh CD/0 allocation after proving that it projects to the
    explicitly requested ClaimId.
    """

    predecessor_projection = project_occurrence(predecessor)
    projected = project_claim_id(requested_claim)
    if predecessor_projection.canonical_bytes != projected.canonical_bytes:
        raise LCIFailure(
            "projection-refusal",
            "ClaimIdCacheMismatch",
            "claim-id-cache",
            ("requested-claim",),
        )
    copied = cd0.decode_exact(canonical_bytes(predecessor), CD0_BUDGET)
    project_occurrence(copied)
    return copied


def _legacy_inert(source: cd0.Datum) -> cd0.Datum:
    return legacy_inert(source)


def _migrate(source: cd0.Datum) -> cd0.Datum:
    return migrate(source)


RESOURCE_GENERATORS = {
    "maximum-nesting": ("nested-singleton-record", "0"),
    "node-count": ("flat-sequence-of-unit-nodes", "0"),
    "record-fields": ("record-of-indexed-fixture-keys", "0"),
    "sequence-length": ("sequence-of-unit-values", "0"),
    "identifier-segments": ("identifier-with-indexed-segments", "0"),
    "aggregate-payload-octets": ("byte-string-of-0x61", "0"),
    "stable-reference-material-octets": ("stable-ref-material-byte-string-of-0x61", "0"),
    "proposition-normalization-work": ("repeat-normalizer-node", "0"),
    "scope-relation-work": ("repeat-scope-relation-node", "0"),
    "temporal-relation-work": ("repeat-temporal-relation-node", "0"),
    "migration-input-octets": ("legacy-source-byte-string-of-0x61", "0"),
    "target-boundary-work": ("repeat-target-boundary-node", "0"),
    "represented-loss-account-entries": ("indexed-account-entry-sequence", "0"),
}


RESOURCE_OPERATIONS = {
    "maximum-nesting": {"conformance-validation"},
    "node-count": {"conformance-validation"},
    "record-fields": {"conformance-validation"},
    "sequence-length": {"conformance-validation"},
    "identifier-segments": {"conformance-validation"},
    "aggregate-payload-octets": {"conformance-validation"},
    "stable-reference-material-octets": {"conformance-validation"},
    "proposition-normalization-work": {"conformance-normalization", "normalize-proposition"},
    "scope-relation-work": {"conformance-matching"},
    "temporal-relation-work": {"conformance-matching"},
    "migration-input-octets": {"conformance-migration"},
    "target-boundary-work": {"conformance-validation"},
    "represented-loss-account-entries": {"conformance-validation"},
}


def _operation_stage(operation: str) -> str:
    if "migrat" in operation or operation in {"parse-legacy-source", "restore-live-warrant"}:
        return "migration"
    if operation in {"normalize-proposition", "conformance-normalization"}:
        return "normalization"
    if operation.startswith("project") or operation in {"differential-project"}:
        return "projection"
    if operation in {"match-target", "scope-relation", "temporal-relation", "conformance-matching"}:
        return "matching"
    return "validation"


def _validate_resource_workload(operation: str, workload_value: cd0.Datum) -> tuple[str, int]:
    workload = record_to_mapping(workload_value)
    required = {"kind", "schema-version", "resource", "generator", "requested", "seed"}
    if set(workload) != required:
        missing = sorted(required - set(workload))
        extra = sorted(set(workload) - required)
        name = missing[0] if missing else extra[0]
        code = "MissingRequiredField" if missing else "UnknownField"
        raise LCIFailure("invalid-input", code, "resource-workload", ("fixture-field:workload", f"fixture-field:{name}"))
    kind = workload["kind"]
    resource_value = workload["resource"]
    generator = workload["generator"]
    if type(kind) is not cd0.Identifier or kind.namespace != FIXTURE or kind.path != ("tag", "deterministic-resource-workload"):
        raise LCIFailure("invalid-input", "InvalidResourceWorkload", "resource-workload", ("fixture-field:workload", "fixture-field:kind"))
    version, seed, requested = workload["schema-version"], workload["seed"], workload["requested"]
    if type(version) is not cd0.Integer or version.value != 0 or type(seed) is not cd0.Integer or seed.value != 0:
        raise LCIFailure("invalid-input", "InvalidResourceWorkload", "resource-workload", ("fixture-field:workload",))
    if type(requested) is not cd0.Integer or requested.value < 0:
        raise LCIFailure("invalid-input", "InvalidResourceWorkload", "resource-workload", ("fixture-field:workload", "fixture-field:requested"))
    if type(resource_value) is not cd0.Identifier or resource_value.namespace != FIXTURE or len(resource_value.path) != 2 or resource_value.path[0] != "resource":
        raise LCIFailure("invalid-input", "InvalidResourceWorkload", "resource-workload", ("fixture-field:workload", "fixture-field:resource"))
    resource = resource_value.path[1]
    expected_generator = RESOURCE_GENERATORS.get(resource)
    if (
        expected_generator is None
        or type(generator) is not cd0.Identifier
        or generator.namespace != FIXTURE
        or generator.path != ("workload-generator", *expected_generator)
        or operation not in RESOURCE_OPERATIONS[resource]
    ):
        raise LCIFailure("invalid-input", "InvalidResourceWorkload", "resource-workload", ("fixture-field:workload", "fixture-field:generator"))
    return resource, requested.value


def _execute_semantics(operation: str, payload: Mapping[str, cd0.Datum], *, vector_id: str = "") -> Outcome:
    """Execute one declared fixture operation using payload semantics only."""

    try:
        outputs: dict[str, Any]
        if operation == "validate-pinned-fixture":
            value = payload["fixture-value"]
            if canonical_bytes(value) != canonical_bytes(payload["registry-definition"]):
                raise LCIFailure("invalid-input", "PinnedFixtureMismatch", "fixture-validation", ("fixture-value",))
            outputs = {"validated-value": value, "canonical-octets": canonical_bytes(value), "shared-octet-obligation": True}
        elif operation == "canonicalize-record-order":
            left, right = payload["left-claim"], payload["right-claim"]
            validate_claim_id(left)
            validate_claim_id(right)
            required_order = {
                "kind",
                "lci-version",
                "identity-policy",
                "claim-profile",
                "proposition",
                "location",
            }
            for name in ("left-construction-order", "right-construction-order"):
                construction = payload[name]
                if (
                    type(construction) is not cd0.Sequence
                    or any(
                        type(item) is not cd0.Identifier
                        or item.namespace != LCI
                        or len(item.path) != 1
                        for item in construction.items
                    )
                    or {item.path[-1] for item in construction.items} != required_order
                    or len(construction.items) != len(required_order)
                ):
                    raise LCIFailure("invalid-input", "InvalidConstructionOrder", "fixture-operation", (f"fixture-field:{name}",))
            outputs = {"canonical-claim-id": left, "same-canonical-octets": canonical_bytes(left) == canonical_bytes(right)}
        elif operation == "compare-claim-ids":
            outputs = {"comparison": _claim_coordinate_difference(payload["left"], payload["right"])}
        elif operation == "compare-claim-id-set":
            claims_value = payload["claims"]
            if type(claims_value) is not cd0.Sequence or len(claims_value.items) < 2:
                raise LCIFailure("invalid-input", "InvalidClaimSet", "fixture-operation", ("fixture-field:claims",))
            claims = claims_value.items
            for claim in claims:
                validate_claim_id(claim)
            encoded = [canonical_bytes(item) for item in claims]
            first_difference = _claim_coordinate_difference(claims[0], claims[1])["relation"]
            coordinate = {
                "same-claim-id": "claim-coordinate/none",
                "different-proposition": "claim-coordinate/proposition",
                "different-scope": "claim-coordinate/scope",
                "different-subject-time": "claim-coordinate/subject-time",
                "different-corpus-revision": "claim-coordinate/corpus-revision",
                "different-dataset-slice": "claim-coordinate/dataset-slice",
                "different-semantic-boundary": "claim-coordinate/semantic-boundary",
                "different-basis": "claim-coordinate/basis",
                "different-interpretation-frame": "claim-coordinate/interpretation-frame",
                "different-profile-location": "claim-coordinate/profile-location",
            }[first_difference]
            outputs = {"pairwise-distinct": len(encoded) == len(set(encoded)), "different-coordinate": coordinate}
        elif operation == "project-occurrences":
            if "baseline" in payload:
                base = project_occurrence(payload["baseline"])
                mutated = project_occurrence(payload["mutated-metadata"])
                same = base.canonical_bytes == mutated.canonical_bytes
                outputs = {
                    "baseline-claim-id": base.datum,
                    "mutated-claim-id": mutated.datum,
                    "claimant-neutral": same,
                    "assertion-time-neutral": same,
                    "provenance-neutral": same,
                    "lineage-neutral": same,
                    "presentation-neutral": same,
                    "unknown-open-metadata-neutral": same,
                }
            else:
                left = project_occurrence(payload["left-occurrence"])
                right = project_occurrence(payload["right-occurrence"])
                same = left.canonical_bytes == right.canonical_bytes
                if "comparison-coordinate" in payload:
                    coordinate = payload["comparison-coordinate"]
                    if (
                        type(coordinate) is not cd0.Identifier
                        or coordinate.namespace != FIXTURE
                        or coordinate.path
                        not in {
                            ("nonidentity-coordinate", "provenance"),
                            ("nonidentity-coordinate", "lineage"),
                        }
                    ):
                        raise LCIFailure(
                            "invalid-input",
                            "InvalidComparisonCoordinate",
                            "fixture-operation",
                            ("fixture-field:comparison-coordinate",),
                        )
                    left_value = field_by_path(
                        payload["left-occurrence"], coordinate.path[-1]
                    )
                    right_value = field_by_path(
                        payload["right-occurrence"], coordinate.path[-1]
                    )
                    if canonical_bytes(left_value) == canonical_bytes(right_value):
                        raise LCIFailure(
                            "invalid-input",
                            "InvalidComparisonCoordinate",
                            "fixture-operation",
                            ("fixture-field:comparison-coordinate",),
                        )
                    outputs = {"same-claim-id": same, "claim-id": left.datum}
                else:
                    outputs = {
                        "left-claim-id": left.datum,
                        "right-claim-id": right.datum,
                        "same-claim-id": same,
                        "same-canonical-octets": same,
                    }
        elif operation == "project-occurrence":
            outputs = {"claim-id": project_occurrence(payload["occurrence"]).datum}
        elif operation == "normalize-controlled-translation":
            lc = _validate_translation_receipt(payload["left-receipt"], ("fixture-field:left-receipt",))
            rc = _validate_translation_receipt(payload["right-receipt"], ("fixture-field:right-receipt",))
            outputs = {"left-claim-id": lc, "right-claim-id": rc, "same-claim-id": canonical_bytes(lc) == canonical_bytes(rc), "receipts-distinct": canonical_bytes(payload["left-receipt"]) != canonical_bytes(payload["right-receipt"])}
        elif operation == "compare-warrant-targets":
            left, right = payload["left-target"], payload["right-target"]
            validate_warrant_target(left)
            validate_warrant_target(right)
            claims_same = claim_ids_equal(field_by_path(left, "claim"), field_by_path(right, "claim"))
            targets_equal = canonical_bytes(left) == canonical_bytes(right)
            if targets_equal:
                difference = "target-coordinate/none"
            elif not claims_same:
                difference = "target-coordinate/embedded-claim"
            elif field_by_path(left, "target-kind") != field_by_path(right, "target-kind"):
                difference = "target-coordinate/target-kind-and-schema"
            else:
                difference = "target-coordinate/procedure-and-event-boundaries"
            outputs = {
                "embedded-claim-same": claims_same,
                "warrant-targets-equal": targets_equal,
                "difference": difference,
            }
        elif operation == "match-target":
            result = match_target(payload["target"], payload["candidate-claim"])
            if result.failure is not None:
                raise result.failure
            outputs = {"target-relation": _target_relation_record(result.relation)}
        elif operation == "compare-corpus-completion-targets":
            complete = match_target(payload["complete-target"], payload["candidate-claim"])
            incomplete = match_target(payload["incomplete-target"], payload["candidate-claim"])
            if complete.failure is not None:
                raise complete.failure
            if incomplete.failure is None:
                raise LCIFailure(
                    "internal-invariant-failure",
                    "FixtureRegistryMismatch",
                    "internal",
                    ("fixture-field:incomplete-target",),
                )
            outputs = {
                "embedded-claim-same": claim_ids_equal(field_by_path(payload["complete-target"], "claim"), field_by_path(payload["incomplete-target"], "claim")),
                "targets-distinct": canonical_bytes(payload["complete-target"]) != canonical_bytes(payload["incomplete-target"]),
                "complete-relation": _target_relation_record(complete.relation),
                "incomplete-failure": {
                    "kind": "failure",
                    "schema-version": 0,
                    "category": incomplete.failure.category,
                    "code": incomplete.failure.code,
                    "stage": incomplete.failure.stage,
                    "path": [segment.split(":", 1)[-1] for segment in incomplete.failure.path],
                    "context": {},
                },
            }
        elif operation == "scope-relation":
            outputs = {"relation": scope_relation(payload["left"], payload["right"])}
        elif operation == "temporal-relation":
            relation = temporal_relation(payload["left"], payload["right"])
            outputs = {"relation": relation, "direct-target-match-permitted": relation == "equal"}
        elif operation == "validate-claim-id":
            validate_claim_id(payload["claim"])
            outputs = {"valid": True}
        elif operation == "project-claim-id":
            if "digest" in payload or "claim-id-substitute" in payload:
                path = ("fixture-field:digest",) if "digest" in payload else ("digest",)
                raise LCIFailure("projection-refusal", "SelfDeclaredClaimId", "projection", path)
            outputs = {"claim-id": project_claim_id(payload["claim"]).datum}
        elif operation == "proposition-location-consistent":
            validate_proposition_location_consistency(payload["proposition"], payload["location"])
            form = id_name(field_by_path(payload["proposition"], "form")).split("/")[-1]
            if form == "bounded-corpus-absence":
                outputs = {"consistent": True, "horizon-placement": "locator-coordinate/semantic-boundary"}
            elif form == "universal-property-over-scope":
                outputs = {"consistent": True, "placement-rule": "placement-rule/universal-property-over-scope"}
            else:
                raise FixtureAuthorityGap(
                    f"no frozen proposition-placement result for {form!r}"
                )
        elif operation == "validate-warrant-target":
            validate_warrant_target(payload["target"])
            outputs = {"valid": True}
        elif operation == "validate-stable-ref":
            validate_stable_ref(payload["reference"])
            outputs = {"valid": True}
        elif operation == "validate-stable-ref-scheme-selection":
            reference = validate_stable_ref(payload["example-reference"])
            domain = payload["domain"]
            scheme = payload["canonical-scheme"]
            if (
                type(domain) is not cd0.Identifier
                or domain.namespace != FIXTURE
                or canonical_bytes(field_by_path(reference, "domain")) != canonical_bytes(domain)
                or type(scheme) is not cd0.Identifier
                or scheme.namespace != FIXTURE
                or canonical_bytes(field_by_path(reference, "scheme")) != canonical_bytes(scheme)
            ):
                raise LCIFailure("reference-refusal", "UnsupportedReferenceScheme", "stable-reference", ("fixture-field:example-reference",))
            outputs = {"reference-valid": True, "canonical-scheme": scheme, "accepted-scheme-count": 1}
        elif operation == "compare-stable-refs":
            left = payload["left-reference"]
            right = validate_stable_ref(payload["right-reference"])
            left_material = _validate_external_artifact_reference(left)
            registry = payload["bridge-registry"]
            if type(registry) is not cd0.Sequence:
                raise LCIFailure("invalid-input", "InvalidStableRefBridge", "stable-reference-bridge", ("fixture-field:bridge-registry",))
            equivalent = False
            for bridge in registry.items:
                mapped = _bridge_target(bridge, left)
                if canonical_bytes(mapped) == canonical_bytes(right):
                    equivalent = True
            outputs = {
                "structural-equality": canonical_bytes(left) == canonical_bytes(right),
                "operational-equivalence-established": equivalent,
                "identity-treatment": "stable-ref-treatment/equivalent-by-explicit-bridge" if equivalent else "stable-ref-treatment/distinct-no-bridge",
            }
        elif operation == "compare-bridge-source-and-target":
            source = payload["source"]
            target = validate_stable_ref(payload["target"])
            bridge_specification = _validate_fixture_bridge(payload["bridge"])
            mapped = _bridge_target(payload["bridge"], source)
            equivalent = canonical_bytes(mapped) == canonical_bytes(target)
            outputs = {
                "structural-cd0-equality": canonical_bytes(source) == canonical_bytes(target),
                "explicit-operational-equivalence": equivalent,
                "retroactive-claim-id-rewrite": bridge_specification["retroactive"],
            }
        elif operation == "apply-stable-ref-bridge":
            canonical_reference = _bridge_target(
                payload["bridge"],
                payload["source-reference"],
            )
            equivalence_explicit = canonical_reference is not None
            outputs = {
                "canonical-reference": canonical_reference,
                "source-and-target-structurally-equal": canonical_bytes(payload["source-reference"]) == canonical_bytes(canonical_reference),
                "operational-equivalence-explicit": equivalence_explicit,
            }
        elif operation == "normalize-preprojection-coordinate":
            left = _normalize_preprojection_coordinate(
                payload["coordinate"],
                payload["normalizer"],
                payload["left"],
                side="left",
            )
            right = _normalize_preprojection_coordinate(
                payload["coordinate"],
                payload["normalizer"],
                payload["right"],
                side="right",
            )
            equal = canonical_bytes(left) == canonical_bytes(right)
            outputs = {"left-normalized": left, "right-normalized": right, "structurally-equal-after-normalization": equal, "claim-id-merge-permitted": equal}
        elif operation == "apply-admissibility-floor":
            relation_value = payload["target-relation"]
            outputs = {
                "support-permitted": False,
                "policy-a-consulted": False,
                "policy-b-consulted": False,
                "policy-a-decision": _hard_reject_decision(payload["policy-a"], relation_value),
                "policy-b-decision": _hard_reject_decision(payload["policy-b"], relation_value),
            }
        elif operation == "evaluate-admissibility-under-two-policies":
            policy_a_decision, policy_a_admitted = _evaluate_fixture_policy(
                payload["policy-a"],
                payload["target"],
                payload["claim"],
            )
            policy_b_decision, policy_b_admitted = _evaluate_fixture_policy(
                payload["policy-b"],
                payload["target"],
                payload["claim"],
            )
            outputs = {
                "claim-id": payload["claim"],
                "policy-a-decision": policy_a_decision,
                "policy-b-decision": policy_b_decision,
                "admissibility-differs": policy_a_admitted != policy_b_admitted,
            }
        elif operation == "evaluate-freshness-two-query-times":
            fresh_decision, _ = _evaluate_fixture_policy(
                payload["policy"],
                payload["target"],
                payload["claim"],
                query_time=payload["fresh-query"],
            )
            stale_decision, _ = _evaluate_fixture_policy(
                payload["policy"],
                payload["target"],
                payload["claim"],
                query_time=payload["stale-query"],
            )
            outputs = {
                "claim-id": payload["claim"],
                "fresh-decision": fresh_decision,
                "stale-decision": stale_decision,
            }
        elif operation == "validate-policy-evaluation-target":
            target = validate_warrant_target(payload["target"])
            boundaries = field_by_path(target, "boundaries")
            inner = field_by_path(boundaries, "inner-target-relation")
            testimony_mode = field_by_path(boundaries, "testimony-mode")
            meta_testimony = (
                field_by_path(target, "target-kind").path
                == ("target-kind", "policy-evaluation")
                and testimony_mode.path
                == (
                    "policy-testimony-mode",
                    "meta-policy-decision-not-direct-claim-support",
                )
            )
            outputs = {
                "meta-testimony": meta_testimony,
                "direct-support-for-embedded-claim": not meta_testimony,
                "inner-target-relation-recorded": inner,
            }
        elif operation == "validate-profile-location":
            profile_location = payload["profile-location"]
            if type(profile_location) is not cd0.Record:
                raise LCIFailure("invalid-input", "InvalidProfileLocation", "profile-location", ("fixture-field:profile-location",))
            if profile_location.fields:
                key = profile_location.fields[0][0]
                raise LCIFailure(
                    "invalid-input",
                    "UnknownField",
                    "profile-location",
                    ("fixture-field:profile-location", f"fixture-field:{key.path[-1]}"),
                )
            outputs = {"valid": True, "identity-bearing": True, "minimality-exception": "minimality-exception/reserved-forward-compatible-profile-slot"}
        elif operation == "validate-represented-loss-account":
            op_name = id_name(payload["operation"]).split("/")[-1]
            account_operation = validate_loss_account(payload["account"], ("account",))
            if account_operation != op_name:
                raise LCIFailure(
                    "invalid-input",
                    "InvalidRepresentedLoss",
                    "represented-loss",
                    ("account", "fixture-field:account-schema"),
                )
            account = record_to_mapping(payload["account"])
            outputs = {"valid": True, "closed": True, "account-schema": account["account-schema"]}
        elif operation.startswith("conformance-") or operation == "normalize-proposition":
            resource, requested = _validate_resource_workload(operation, payload["workload"])
            stage = {
                "conformance-validation": "validation",
                "conformance-normalization": "normalization",
                "conformance-matching": "matching",
                "conformance-migration": "migration",
                "normalize-proposition": "proposition",
            }[operation]
            if requested > LCI_RESOURCE_LIMITS[resource]:
                raise LCIFailure(
                    "resource-refusal",
                    LCI_RESOURCE_FAILURES[resource],
                    stage,
                    ("fixture-field:workload", "fixture-field:requested")
                    if operation != "normalize-proposition"
                    else ("fixture-field:workload",),
                )
            outputs = {
                "within-budget": True,
                "resource": payload["workload"],
                "requested": requested,
            }
        elif operation == "classify-version-governance":
            change_value = payload["change"]
            if (
                type(change_value) is not cd0.Identifier
                or change_value.namespace != FIXTURE
                or len(change_value.path) != 2
                or change_value.path[0] != "change-class"
            ):
                raise LCIFailure("invalid-input", "UnsupportedVersionChange", "version-governance", ("fixture-field:change",))
            change = change_value.path[-1]
            axis = {
                "proposition-grammar": "required-version-axis/claim-profile",
                "claim-id-field-set": "required-version-axis/identity-policy",
                "projection-field-ownership": "required-version-axis/identity-policy",
                "frame-semantic-interpretation": "required-version-axis/claim-profile-and-or-frame-schema",
                "semantics-preserving-implementation-correction": "required-version-axis/none",
            }.get(change)
            if axis is None:
                raise LCIFailure("invalid-input", "UnsupportedVersionChange", "version-governance", ("fixture-field:change",))
            invariants = (
                "accepted-abstract-inputs-unchanged",
                "normalized-propositions-unchanged",
                "claim-ids-unchanged",
                "relations-and-failures-unchanged",
                "projection-field-set-unchanged",
            )
            if any(type(payload[name]) is not cd0.Boolean for name in invariants):
                raise LCIFailure("invalid-input", "InvalidVersionGovernanceEvidence", "version-governance", ("fixture-field:change",))
            unchanged = all(payload[name].value for name in invariants)
            implementation_correction = change == "semantics-preserving-implementation-correction"
            if unchanged != implementation_correction:
                raise LCIFailure("invalid-input", "InvalidVersionGovernanceEvidence", "version-governance", ("fixture-field:change",))
            outputs = {"version-bump-required": not implementation_correction, "required-version-axis": axis, "conformance-evidence-required": True, "implementation-binary-in-claim-id": False}
        elif operation == "validate-normalizer-revision":
            proposal = _closed_fixture_record(
                payload["proposal"],
                (
                    "kind",
                    "schema-version",
                    "known-input",
                    "before-normalizer",
                    "after-normalizer",
                    "before-claim-id",
                    "after-claim-id",
                    "declared-claim-profile",
                    "declared-frame-schema",
                ),
                stage="claim-profile",
                path=("fixture-field:proposal",),
            )
            if (
                type(proposal["kind"]) is not cd0.Identifier
                or proposal["kind"].namespace != FIXTURE
                or proposal["kind"].path != ("tag", "normalizer-revision-proposal")
                or type(proposal["schema-version"]) is not cd0.Integer
                or proposal["schema-version"].value != 0
                or type(proposal["known-input"]) is not cd0.String
            ):
                raise LCIFailure("invalid-input", "InvalidNormalizerRevisionProposal", "claim-profile", ("fixture-field:proposal",))
            for name in ("before-normalizer", "after-normalizer"):
                _validate_stable_domain(proposal[name], "procedure", ("fixture-field:proposal", f"fixture-field:{name}"))
            _validate_stable_domain(proposal["declared-frame-schema"], "interpretation-frame-schema", ("fixture-field:proposal", "fixture-field:declared-frame-schema"))
            _validate_claim_profile(proposal["declared-claim-profile"], ("fixture-field:proposal", "fixture-field:declared-claim-profile"))
            before = validate_claim_id(proposal["before-claim-id"])
            after = validate_claim_id(proposal["after-claim-id"])
            if (
                field_by_path(before, "claim-profile") != proposal["declared-claim-profile"]
                or field_by_path(after, "claim-profile") != proposal["declared-claim-profile"]
            ):
                raise LCIFailure("invalid-input", "InvalidNormalizerRevisionProposal", "claim-profile", ("fixture-field:proposal", "fixture-field:declared-claim-profile"))
            if canonical_bytes(before) != canonical_bytes(after):
                raise LCIFailure("unsupported-version-or-profile", "MeaningChangingNormalizerVersionReuse", "claim-profile", ("fixture-field:declared-claim-profile", "profile-version"))
            raise FixtureAuthorityGap(
                "no frozen result for a meaning-preserving normalizer revision proposal"
            )
        elif operation == "validate-normalizer-conformance-evidence":
            _validate_normalizer_conformance(
                payload["binding"],
                payload["mutation-vector"],
                payload["semantic-projection-ledger"],
            )
            outputs = {"immutable-normalizer-content-bound": True, "revision-mutation-vector-present": True, "before-after-semantic-ledger-present": True, "implementation-binary-projected": False}
        elif operation == "compare-claim-digests-and-envelopes":
            validate_claim_id(payload["left-claim-id"])
            validate_claim_id(payload["right-claim-id"])
            scheme = payload["digest-scheme"]
            if (
                type(scheme) is not cd0.Identifier
                or scheme.namespace != FIXTURE
                or scheme.path != ("nonproduction-test-digest-scheme", "constant-zero", "0")
                or type(payload["left-operational-digest"]) is not cd0.ByteString
                or type(payload["right-operational-digest"]) is not cd0.ByteString
            ):
                raise LCIFailure("invalid-input", "UnsupportedDigestFixture", "fixture-operation", ("fixture-field:digest-scheme",))
            digests_equal = canonical_bytes(payload["left-operational-digest"]) == canonical_bytes(payload["right-operational-digest"])
            envelopes_equal = claim_ids_equal(payload["left-claim-id"], payload["right-claim-id"])
            outputs = {"digests-equal": digests_equal, "claim-id-envelopes-equal": envelopes_equal, "semantic-claim-id-equal": envelopes_equal, "envelope-resolution-required": digests_equal and not envelopes_equal}
        elif operation == "witness-semantic-claim-id-equality":
            validate_claim_id(payload["left-claim-id"])
            validate_claim_id(payload["right-claim-id"])
            equal = claim_ids_equal(payload["left-claim-id"], payload["right-claim-id"])
            outputs = {"validated-envelopes-equal": equal, "canonical-octets-equal": equal, "digest-required": False}
        elif operation == "compare-unicode-claim-ids":
            validate_claim_id(payload["nfc-claim"])
            validate_claim_id(payload["nfd-claim"])
            outputs = {"claim-ids-equal": claim_ids_equal(payload["nfc-claim"], payload["nfd-claim"]), "unicode-normalization-performed-by-cd0": False, "nfc-utf8": _claim_content_utf8(payload["nfc-claim"]), "nfd-utf8": _claim_content_utf8(payload["nfd-claim"])}
        elif operation == "validate-occurrence":
            project_occurrence(payload["occurrence"])
            outputs = {"valid": True}
        elif operation == "apply-occurrence-corrections":
            original = project_occurrence(payload["original"])
            provenance = project_occurrence(payload["provenance-corrected"])
            proposition = project_occurrence(payload["proposition-corrected"])
            outputs = {"original-claim-id": original.datum, "after-provenance-correction": provenance.datum, "after-proposition-correction": proposition.datum, "first-preserves-claim-id": original.canonical_bytes == provenance.canonical_bytes, "second-changes-claim-id": original.canonical_bytes != proposition.canonical_bytes}
        elif operation == "translate-exactly":
            sc = _validate_translation_receipt(payload["source-receipt"], ("fixture-field:source-receipt",))
            tc = _validate_translation_receipt(payload["target-receipt"], ("fixture-field:target-receipt",))
            same = canonical_bytes(sc) == canonical_bytes(tc)
            if not same:
                raise FixtureAuthorityGap(
                    "no frozen result for unequal exact-translation receipts"
                )
            outputs = {
                "source-claim-id": sc,
                "target-claim-id": tc,
                "same-claim-id": same,
                "lineage": {
                    "kind": "tag/translation-lineage-receipt",
                    "schema-version": 0,
                    "relation": "lineage-relation/exact-translation-normalization",
                    "source": _simple(payload["source-receipt"]),
                    "target": _simple(payload["target-receipt"]),
                    "represented-loss": [],
                },
            }
        elif operation == "translate-with-represented-loss":
            validate_claim_id(payload["source-claim"])
            validate_claim_id(payload["target-claim"])
            validate_represented_loss(payload["loss"], ("fixture-field:loss",))
            outputs = {"source-and-target-claimids-different": not claim_ids_equal(payload["source-claim"], payload["target-claim"]), "relation": "claim-translates-to", "represented-loss": payload["loss"]}
        elif operation == "migrate-v1":
            source = payload.get("source", payload.get("legacy-record"))
            migrated = _migrate(source)
            outputs = {"migration-result": migrated, "live-warrants-created": False}
        elif operation == "migrate-v1-collision-pair":
            left, right = _migrate(payload["left-source"]), _migrate(payload["right-source"])
            li, ri = _legacy_inert(payload["left-source"]), _legacy_inert(payload["right-source"])
            lf, rf = field_by_path(li, "fingerprint"), field_by_path(ri, "fingerprint")
            lc, rc = field_by_path(left, "claim-id"), field_by_path(right, "claim-id")
            # Which coordinate differs is derived from the reconstructed claims.
            relation = _claim_coordinate_difference(lc, rc)["relation"]
            coordinate = {
                "different-subject-time": "claim-coordinate/subject-time",
                "different-scope": "claim-coordinate/scope",
                "different-corpus-revision": "claim-coordinate/corpus-revision",
            }.get(relation)
            if coordinate is None:
                raise FixtureAuthorityGap(
                    f"no frozen collision-pair result for relation {relation!r}"
                )
            outputs = {"legacy-fingerprint-equal": canonical_bytes(lf) == canonical_bytes(rf), "left-result": left, "right-result": right, "new-claim-ids-equal": canonical_bytes(lc) == canonical_bytes(rc), "distinguishing-coordinate": coordinate}
        elif operation == "map-migration-classification":
            classification = payload["lci-classification"]
            name = _migration_classification_name(classification)
            prior = payload["prior-ruling-terms"]
            if type(prior) is not cd0.Sequence:
                raise LCIFailure("invalid-input", "InvalidMigrationClassification", "migration-mapping", ("fixture-field:prior-ruling-terms",))
            characters: list[str] = []
            for index, item in enumerate(prior.items):
                if (
                    type(item) is not cd0.Identifier
                    or item.namespace != FIXTURE
                    or len(item.path) != 2
                    or item.path[0] != "prior-ruling-migration-classification"
                    or len(item.path[1]) != 1
                ):
                    raise LCIFailure("invalid-input", "InvalidMigrationClassification", "migration-mapping", ("fixture-field:prior-ruling-terms", str(index)))
                characters.append(item.path[1])
            expected_prior = {
                "exact": "exact",
                "exact-after-explicit-tagging": "explicitly-tagged",
                "lossy-with-represented-loss": "lossy-with-represented-loss",
                "rejected": "rejected",
                "new-identity-required": "profile-adapted",
                "deferred-to-named-calculus": "profile-adapted",
                "privileged-runtime-relation-outside-claim-id": "profile-adapted",
            }[name]
            if "".join(characters) != expected_prior:
                raise LCIFailure("invalid-input", "InvalidMigrationClassification", "migration-mapping", ("fixture-field:prior-ruling-terms",))
            outputs = {"mapping-defined": True, "lci-classification": classification, "prior-ruling-terms": payload["prior-ruling-terms"], "semantic-case": f"migration-mapping-case/{name}"}
        elif operation == "parse-legacy-source":
            refuse_legacy_source(payload["source"])
            raise LCIFailure("internal-invariant-failure", "FixtureRegistryMismatch", "internal", ("fixture-field:source",))
        elif operation == "parse-and-migrate-printer-variants":
            compact, pretty = payload["compact-source"], payload["pretty-source"]
            ci, pi = _legacy_inert(compact), _legacy_inert(pretty)
            migrated = _migrate(compact)
            outputs = {"source-bytes-equal": canonical_bytes(field_by_path(compact, "source-bytes")) == canonical_bytes(field_by_path(pretty, "source-bytes")), "parsed-inert-values-equal": canonical_bytes(ci) == canonical_bytes(pi), "migrated-claim-id": field_by_path(migrated, "claim-id"), "ambient-printer-settings-consulted": False}
        elif operation == "restore-live-warrant":
            source = payload["source"]
            inert = _legacy_inert(source)
            attempted = scalar(field_by_path(inert, "attempt-live-restoration"))
            code = "PrivilegedRestorationAttempt" if attempted else "LegacyWarrantInert"
            path = (
                "fixture-field:parsed-inert-value",
                "fixture-field:attempt-live-restoration" if attempted else "fixture-field:predecessor-warrants",
            )
            raise LCIFailure("privilege-refusal", code, "privilege-boundary", path)
        elif operation == "validate-migration-result":
            validate_migration_result(payload["migration-result"])
            raise FixtureAuthorityGap(
                "no frozen positive validate-migration-result output schema"
            )
        elif operation == "differential-project":
            left, right = _validate_differential_evidence(payload["evidence"])
            if canonical_bytes(left) != canonical_bytes(right):
                raise LCIFailure("internal-invariant-failure", "ProjectionNonDeterminism", "internal", ("fixture-field:right-output",))
            raise FixtureAuthorityGap(
                "no frozen equal-output differential result or failure tuple"
            )
        elif operation == "revive-inert-occurrence":
            outputs = {"revival": {
                "kind": "tag/revival-fixture-result",
                "schema-version": 0,
                "claim-id": payload["requested-claim"],
                "new-occurrence": _revived_occurrence(payload["predecessor"], payload["requested-claim"]),
                "standing-status": "standing-status/unsupported-until-authorized-replay",
                "live-warrants": [],
            }}
        else:
            raise FixtureAuthorityGap(
                f"operation {operation!r} has no frozen execution branch"
            )
        return Outcome(operation, outputs=outputs)
    except LCIFailure as exc:
        if vector_id and not exc.context:
            exc = replace(
                exc,
                context=(("fixture-field:vector-id", cd0.string(vector_id)),),
            )
        return Outcome(operation, failure=exc)


def execute(operation: str, payload: Mapping[str, cd0.Datum], *, vector_id: str = "") -> Outcome:
    try:
        _validate_operation_payload(operation, payload)
        payload_root = cd0.record(
            (cd0.identifier(FIXTURE_FIELD, (name,)), item)
            for name, item in payload.items()
        )
        with operation_resource_guard(payload_root, stage=_operation_stage(operation)):
            return _execute_semantics(operation, payload, vector_id=vector_id)
    except LCIFailure as exc:
        if vector_id and not exc.context:
            exc = replace(
                exc,
                context=(("fixture-field:vector-id", cd0.string(vector_id)),),
            )
        return Outcome(operation, failure=exc)


def execute_row(row: dict) -> Outcome:
    input_document = from_package_json(row["inputs"]["abstract_cd0"], CD0_BUDGET)
    envelope = record_to_mapping(input_document)
    return execute(row["operation"], record_to_mapping(envelope["payload"]), vector_id=row["vector_id"])


def expected_outcome(row: dict) -> Outcome:
    """Test oracle: decode the frozen expected document, never called by execute."""

    expected = from_package_json(row["expected"]["abstract_cd0"], CD0_BUDGET)
    kind_value = field_by_path(expected, "kind")
    kind = id_name(kind_value).split("/")[-1]
    fields = record_to_mapping(expected, namespace=LCI if kind == "failure" else FIXTURE_FIELD)
    if kind == "failure":
        path = tuple(
            f"fixture-field:{item.path[-1]}"
            if item.namespace == ("lisp-plus", "lci", "0", "fixture", "field")
            else item.path[-1]
            for item in fields["path"].items
        )
        context = tuple(
            (
                f"fixture-field:{key.path[-1]}"
                if key.namespace == ("lisp-plus", "lci", "0", "fixture", "field")
                else key.path[-1],
                item,
            )
            for key, item in fields["context"].fields
        )
        return Outcome(
            row["operation"],
            failure=LCIFailure(
                id_name(fields["category"]).split("/")[-1],
                id_name(fields["code"]).split("/")[-1],
                id_name(fields["stage"]).split("/")[-1],
                path,
                context,
            ),
        )
    return Outcome(row["operation"], outputs=_simple(fields["outputs"]))


def comparison_signature(outcome: Outcome) -> Any:
    if outcome.failure is not None:
        return (
            "failure",
            *outcome.failure.comparison_key,
            tuple((name, _simple_outputs(item)) for name, item in outcome.failure.context),
        )
    return ("success", _simple_outputs(outcome.outputs or {}))


def _simple_outputs(value: Any) -> Any:
    if isinstance(value, ClaimIdEnvelope):
        value = value.datum
    if type(value) in (cd0.Unit, cd0.Boolean, cd0.Integer, cd0.Rational, cd0.String, cd0.ByteString, cd0.Identifier, cd0.Sequence, cd0.Record):
        return _simple(value)
    if isinstance(value, Mapping):
        return {str(key): _simple_outputs(item) for key, item in value.items()}
    if isinstance(value, (list, tuple)):
        return [_simple_outputs(item) for item in value]
    return value
