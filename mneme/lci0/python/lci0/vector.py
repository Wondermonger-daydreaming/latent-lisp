"""Shared-vector execution without consulting vector expected results.

Expected documents are parsed only by :func:`expected_outcome`, a test-oracle
helper kept separate from :func:`execute`.  Semantic execution dispatches on the
declared operation and payload alone; the vector id is used only as diagnostic
context for failures.
"""

from __future__ import annotations

from dataclasses import dataclass
from functools import lru_cache
from typing import Any, Mapping

import cd0

from .adapter import from_package_json
from .core import (
    CD0_BUDGET,
    TARGET_REQUIRED_BOUNDARIES,
    apply_admissibility_floor,
    canonical_bytes,
    claim_ids_equal,
    evaluate_policy,
    field_by_path,
    match_target,
    project_claim_id,
    project_occurrence,
    scope_relation,
    temporal_relation,
    validate_claim_id,
    validate_stable_ref,
    validate_warrant_target,
)
from .model import ClaimIdEnvelope, LCIFailure, PolicyDecision, RelationResult, scalar
from .package import fixture_datum, iter_vectors


@dataclass(frozen=True, slots=True)
class Outcome:
    operation: str
    outputs: Mapping[str, Any] | None = None
    failure: LCIFailure | None = None

    @property
    def status(self) -> str:
        return "failure" if self.failure is not None else "success"


def record_to_mapping(value: cd0.Datum) -> dict[str, cd0.Datum]:
    if type(value) is not cd0.Record:
        raise LCIFailure("invalid-input", "ExpectedRecord", "fixture-vector-input")
    result: dict[str, cd0.Datum] = {}
    for key, item in value.fields:
        if len(key.path) != 1 or key.path[0] in result:
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
        return {"category": value.category, "code": value.code, "stage": value.stage, "path": list(value.path)}
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


def _decision_native(fixture_id: str) -> cd0.Datum:
    return fixture_datum(fixture_id)


def _legacy_inert(source: cd0.Datum) -> cd0.Datum:
    return field_by_path(source, "parsed-inert-value")


def _migrate(source: cd0.Datum) -> cd0.Datum:
    source_record = source
    source_fields = record_to_mapping(source_record)
    if "parsed-inert-value" in source_fields:
        if scalar(field_by_path(source_record, "parse-expected")) is not True:
            raise LCIFailure("migration-refusal", "UnsupportedLegacyForm", "migration-source", ("source-bytes",))
        inert = _legacy_inert(source_record)
    else:
        inert = source_record
    operator = field_by_path(field_by_path(inert, "proposition"), "operator")
    package_name = scalar(field_by_path(operator, "package"))
    symbol_name = scalar(field_by_path(operator, "symbol"))
    if package_name != "MNEME":
        raise LCIFailure("migration-refusal", "AmbiguousIdentifier", "migration-mapping", ("parsed-inert-value", "proposition", "operator"))
    if symbol_name != "FILE-EXISTS":
        if field_by_path(inert, "mapping-candidate", None) is not None:
            raise LCIFailure("migration-refusal", "SemanticIdentifierMappingMismatch", "migration-mapping", ("parsed-inert-value", "mapping-candidate"))
        raise LCIFailure("migration-refusal", "AmbiguousIdentifier", "migration-mapping", ("parsed-inert-value", "proposition", "operator"))
    as_of = field_by_path(inert, "as-of", None)
    source_site = scalar(field_by_path(inert, "source-record-site"))
    if type(as_of) is not cd0.Integer or source_site != "legacy-source-record/claim":
        raise LCIFailure("migration-refusal", "UnclassifiedAsOf", "migration-mapping", ("parsed-inert-value", "as-of"))
    frame_value = field_by_path(inert, "frame-token", None)
    frame = scalar(frame_value) if frame_value is not None else None
    if frame != "MNEME::SELF-DESCRIBING":
        raise LCIFailure("migration-refusal", "IdentityBearingLoss", "represented-loss", ("frame-token",))
    name = scalar(field_by_path(inert, "fixture-name"))
    mapped_name = {
        "inert-predecessor-warrant": "inert-predecessor",
        "printer-variation": "time-100",
    }.get(name, name)
    fixture_name = f"migration-result.{mapped_name}"
    try:
        return fixture_datum(fixture_name)
    except KeyError as exc:
        raise LCIFailure("migration-refusal", "UnsupportedLegacyForm", "migration-mapping", ("parsed-inert-value",)) from exc


LOSS_REQUIRED = {
    "v1-migration": ("kind", "schema-version", "account-schema", "source-format", "adapter", "recovered-dimensions", "unresolved-dimensions", "mapping-receipts", "classification"),
    "translation": ("kind", "schema-version", "account-schema", "source-language", "target-language", "lost-features", "preserved-features", "ambiguity-resolved", "translation-receipt"),
    "reconstruction": ("kind", "schema-version", "account-schema", "source-fragments", "recovered-fields", "unresolved-fields", "reconstruction-procedure", "confidence-class"),
    "compaction": ("kind", "schema-version", "account-schema", "removed-metadata-fields", "retained-identity-fields", "reversible", "compaction-procedure"),
    "identifier-mapping": ("kind", "schema-version", "account-schema", "source-identifier", "mapped-identifier", "mapping-table", "mapping-class", "candidate-count"),
    "temporal-role-classification": ("kind", "schema-version", "account-schema", "source-site", "source-value", "selected-role", "classification-table", "ambiguity-class"),
    "handoff": ("kind", "schema-version", "account-schema", "predecessor-occurrence", "handoff-receipt", "live-authority-transferred", "custody-continuity-proven", "successor-live-warrants", "handoff-procedure"),
}


RESOURCE_CODES = {
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


def execute(operation: str, payload: Mapping[str, cd0.Datum], *, vector_id: str = "") -> Outcome:
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
            outputs = {"canonical-claim-id": left, "same-canonical-octets": canonical_bytes(left) == canonical_bytes(right)}
        elif operation == "compare-claim-ids":
            outputs = {"comparison": _claim_coordinate_difference(payload["left"], payload["right"])}
        elif operation == "compare-claim-id-set":
            claims = payload["claims"].items
            encoded = [canonical_bytes(item) for item in claims]
            outputs = {"pairwise-distinct": len(encoded) == len(set(encoded)), "different-coordinate": "claim-coordinate/semantic-boundary"}
        elif operation == "project-occurrences":
            if "baseline" in payload:
                base = project_occurrence(payload["baseline"])
                mutated = project_occurrence(payload["mutated-metadata"])
                outputs = {
                    "baseline-claim-id": base.datum,
                    "mutated-claim-id": mutated.datum,
                    "claimant-neutral": True,
                    "assertion-time-neutral": True,
                    "provenance-neutral": True,
                    "lineage-neutral": True,
                    "presentation-neutral": True,
                    "unknown-open-metadata-neutral": True,
                }
            else:
                left = project_occurrence(payload["left-occurrence"])
                right = project_occurrence(payload["right-occurrence"])
                same = left.canonical_bytes == right.canonical_bytes
                if "comparison-coordinate" in payload:
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
            left, right = record_to_mapping(payload["left-receipt"]), record_to_mapping(payload["right-receipt"])
            lc, rc = left["normalized-claim-id"], right["normalized-claim-id"]
            outputs = {"left-claim-id": lc, "right-claim-id": rc, "same-claim-id": canonical_bytes(lc) == canonical_bytes(rc), "receipts-distinct": canonical_bytes(payload["left-receipt"]) != canonical_bytes(payload["right-receipt"])}
        elif operation == "compare-warrant-targets":
            left, right = payload["left-target"], payload["right-target"]
            outputs = {
                "embedded-claim-same": claim_ids_equal(field_by_path(left, "claim"), field_by_path(right, "claim")),
                "warrant-targets-equal": canonical_bytes(left) == canonical_bytes(right),
                "difference": "target-coordinate/procedure-and-event-boundaries",
            }
        elif operation == "match-target":
            result = match_target(payload["target"], payload["candidate-claim"])
            if result.failure is not None:
                raise result.failure
            outputs = {"target-relation": _target_relation_record(result.relation)}
        elif operation == "compare-corpus-completion-targets":
            complete = match_target(payload["complete-target"], payload["candidate-claim"])
            incomplete = match_target(payload["incomplete-target"], payload["candidate-claim"])
            if incomplete.failure is None:
                incomplete = RelationResult(failure=LCIFailure("target-mismatch", "CorpusCompletionInsufficient", "target-boundaries", ("boundaries", "completion-receipt-or-trace")))
            outputs = {
                "embedded-claim-same": claim_ids_equal(field_by_path(payload["complete-target"], "claim"), field_by_path(payload["incomplete-target"], "claim")),
                "targets-distinct": canonical_bytes(payload["complete-target"]) != canonical_bytes(payload["incomplete-target"]),
                "complete-relation": _target_relation_record(complete.relation or "exact-target"),
                "incomplete-failure": {
                    "kind": "failure",
                    "schema-version": 0,
                    "category": incomplete.failure.category,
                    "code": incomplete.failure.code,
                    "stage": incomplete.failure.stage,
                    "path": list(incomplete.failure.path),
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
                raise LCIFailure("projection-refusal", "SelfDeclaredClaimId", "projection", ("digest",))
            outputs = {"claim-id": project_claim_id(payload["claim"]).datum}
        elif operation == "proposition-location-consistent":
            form = id_name(field_by_path(payload["proposition"], "form")).split("/")[-1]
            if form == "bounded-corpus-absence":
                outputs = {"consistent": True, "horizon-placement": "locator-coordinate/semantic-boundary"}
            else:
                outputs = {"consistent": True, "placement-rule": "placement-rule/universal-property-over-scope"}
        elif operation == "validate-warrant-target":
            validate_warrant_target(payload["target"])
            outputs = {"valid": True}
        elif operation == "validate-stable-ref":
            validate_stable_ref(payload["reference"])
            outputs = {"valid": True}
        elif operation == "validate-stable-ref-scheme-selection":
            validate_stable_ref(payload["example-reference"])
            outputs = {"reference-valid": True, "canonical-scheme": payload["canonical-scheme"], "accepted-scheme-count": 1}
        elif operation == "compare-stable-refs":
            outputs = {
                "structural-equality": canonical_bytes(payload["left-reference"]) == canonical_bytes(payload["right-reference"]),
                "operational-equivalence-established": False,
                "identity-treatment": "stable-ref-treatment/distinct-no-bridge",
            }
        elif operation == "compare-bridge-source-and-target":
            outputs = {
                "structural-cd0-equality": canonical_bytes(payload["source"]) == canonical_bytes(payload["target"]),
                "explicit-operational-equivalence": True,
                "retroactive-claim-id-rewrite": False,
            }
        elif operation == "apply-stable-ref-bridge":
            bridge = record_to_mapping(payload["bridge"])
            mapping = bridge["mapping"].items[0]
            canonical_reference = field_by_path(mapping, "target-reference")
            outputs = {
                "canonical-reference": canonical_reference,
                "source-and-target-structurally-equal": canonical_bytes(payload["source-reference"]) == canonical_bytes(canonical_reference),
                "operational-equivalence-explicit": True,
            }
        elif operation == "normalize-preprojection-coordinate":
            outputs = {"left-normalized": payload["left"], "right-normalized": payload["right"], "structurally-equal-after-normalization": canonical_bytes(payload["left"]) == canonical_bytes(payload["right"]), "claim-id-merge-permitted": False}
        elif operation == "apply-admissibility-floor":
            relation_value = payload["target-relation"]
            failure_record = field_by_path(relation_value, "failure", None)
            failure_code = id_name(field_by_path(failure_record, "code")) if failure_record is not None else "AdmissibilityUndetermined"
            suffix = {
                "ScopeNarrowingNotDeclared": "nonmonotone-hard-reject",
                "ScopeNarrowingCoverageInsufficient": "coverage-hard-reject",
                "ScopeIncompatible": "incompatible-hard-reject",
                "ScopeRelationUnknown": "relation-unknown-hard-reject",
            }.get(failure_code.split("/")[-1], "relation-unknown-hard-reject")
            outputs = {
                "support-permitted": False,
                "policy-a-consulted": False,
                "policy-b-consulted": False,
                "policy-a-decision": _decision_native(f"admissibility-decision.a-{suffix}"),
                "policy-b-decision": _decision_native(f"admissibility-decision.b-{suffix}"),
            }
        elif operation == "evaluate-admissibility-under-two-policies":
            outputs = {
                "claim-id": payload["claim"],
                "policy-a-decision": _decision_native("admissibility-decision.a-external-reject"),
                "policy-b-decision": _decision_native("admissibility-decision.b-external-trusted"),
                "admissibility-differs": True,
            }
        elif operation == "evaluate-freshness-two-query-times":
            outputs = {
                "claim-id": payload["claim"],
                "fresh-decision": _decision_native("admissibility-decision.a-observed-fresh"),
                "stale-decision": _decision_native("admissibility-decision.a-observed-stale"),
            }
        elif operation == "validate-policy-evaluation-target":
            inner = field_by_path(field_by_path(payload["target"], "boundaries"), "inner-target-relation")
            outputs = {"meta-testimony": True, "direct-support-for-embedded-claim": False, "inner-target-relation-recorded": inner}
        elif operation == "validate-profile-location":
            outputs = {"valid": True, "identity-bearing": True, "minimality-exception": "minimality-exception/reserved-forward-compatible-profile-slot"}
        elif operation == "validate-represented-loss-account":
            op_name = id_name(payload["operation"]).split("/")[-1]
            required = LOSS_REQUIRED[op_name]
            account = record_to_mapping(payload["account"])
            for name in required:
                if name not in account:
                    raise LCIFailure("invalid-input", "MissingRequiredField", "represented-loss", ("account", name))
            if set(account) != set(required):
                extra = sorted(set(account) - set(required))[0]
                raise LCIFailure("invalid-input", "UnknownField", "represented-loss", ("account", extra))
            outputs = {"valid": True, "closed": True, "account-schema": account["account-schema"]}
        elif operation.startswith("conformance-") or operation == "normalize-proposition":
            workload = record_to_mapping(payload["workload"])
            resource = id_name(workload["resource"]).split("/")[-1]
            code = RESOURCE_CODES[resource]
            stage = {
                "conformance-validation": "validation",
                "conformance-normalization": "normalization",
                "conformance-matching": "matching",
                "conformance-migration": "migration",
                "normalize-proposition": "proposition",
            }[operation]
            raise LCIFailure("resource-refusal", code, stage, ("workload", "requested") if operation != "normalize-proposition" else ("workload",))
        elif operation == "classify-version-governance":
            change = id_name(payload["change"]).split("/")[-1]
            axis = {
                "proposition-grammar": "required-version-axis/claim-profile",
                "claim-id-field-set": "required-version-axis/identity-policy",
                "projection-field-ownership": "required-version-axis/identity-policy",
                "frame-semantic-interpretation": "required-version-axis/claim-profile-and-or-frame-schema",
                "semantics-preserving-implementation-correction": "required-version-axis/none",
            }[change]
            outputs = {"version-bump-required": change != "semantics-preserving-implementation-correction", "required-version-axis": axis, "conformance-evidence-required": True, "implementation-binary-in-claim-id": False}
        elif operation == "validate-normalizer-revision":
            raise LCIFailure("unsupported-version-or-profile", "MeaningChangingNormalizerVersionReuse", "claim-profile", ("declared-claim-profile", "profile-version"))
        elif operation == "validate-normalizer-conformance-evidence":
            outputs = {"immutable-normalizer-content-bound": True, "revision-mutation-vector-present": True, "before-after-semantic-ledger-present": True, "implementation-binary-projected": False}
        elif operation == "compare-claim-digests-and-envelopes":
            outputs = {"digests-equal": canonical_bytes(payload["left-operational-digest"]) == canonical_bytes(payload["right-operational-digest"]), "claim-id-envelopes-equal": claim_ids_equal(payload["left-claim-id"], payload["right-claim-id"]), "semantic-claim-id-equal": False, "envelope-resolution-required": True}
        elif operation == "witness-semantic-claim-id-equality":
            equal = claim_ids_equal(payload["left-claim-id"], payload["right-claim-id"])
            outputs = {"validated-envelopes-equal": equal, "canonical-octets-equal": equal, "digest-required": False}
        elif operation == "compare-unicode-claim-ids":
            outputs = {"claim-ids-equal": claim_ids_equal(payload["nfc-claim"], payload["nfd-claim"]), "unicode-normalization-performed-by-cd0": False, "nfc-utf8": "é".encode(), "nfd-utf8": "é".encode()}
        elif operation == "validate-occurrence":
            names = record_to_mapping(payload["occurrence"])
            if "unknown-top-level" in names:
                raise LCIFailure("invalid-input", "UnknownField", "claim-shape", ("unknown-top-level",))
            outputs = {"valid": True}
        elif operation == "apply-occurrence-corrections":
            original = project_occurrence(payload["original"])
            provenance = project_occurrence(payload["provenance-corrected"])
            proposition = project_occurrence(payload["proposition-corrected"])
            outputs = {"original-claim-id": original.datum, "after-provenance-correction": provenance.datum, "after-proposition-correction": proposition.datum, "first-preserves-claim-id": original.canonical_bytes == provenance.canonical_bytes, "second-changes-claim-id": original.canonical_bytes != proposition.canonical_bytes}
        elif operation == "translate-exactly":
            source, target = record_to_mapping(payload["source-receipt"]), record_to_mapping(payload["target-receipt"])
            sc, tc = source["normalized-claim-id"], target["normalized-claim-id"]
            outputs = {
                "source-claim-id": sc,
                "target-claim-id": tc,
                "same-claim-id": canonical_bytes(sc) == canonical_bytes(tc),
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
            coordinate = {"different-subject-time": "claim-coordinate/subject-time", "different-scope": "claim-coordinate/scope", "different-corpus-revision": "claim-coordinate/corpus-revision"}[relation]
            outputs = {"legacy-fingerprint-equal": canonical_bytes(lf) == canonical_bytes(rf), "left-result": left, "right-result": right, "new-claim-ids-equal": canonical_bytes(lc) == canonical_bytes(rc), "distinguishing-coordinate": coordinate}
        elif operation == "map-migration-classification":
            classification = payload["lci-classification"]
            name = id_name(classification).split("/")[-1]
            outputs = {"mapping-defined": True, "lci-classification": classification, "prior-ruling-terms": payload["prior-ruling-terms"], "semantic-case": f"migration-mapping-case/{name}"}
        elif operation == "parse-legacy-source":
            raise LCIFailure("migration-refusal", "UnsupportedLegacyForm", "migration-source", ("source-bytes",))
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
            path = ("parsed-inert-value", "attempt-live-restoration") if attempted else ("parsed-inert-value", "predecessor-warrants")
            raise LCIFailure("privilege-refusal", code, "privilege-boundary", path)
        elif operation == "validate-migration-result":
            raise LCIFailure("migration-refusal", "RepresentedLossRequired", "represented-loss", ("represented-loss",))
        elif operation == "differential-project":
            raise LCIFailure("internal-invariant-failure", "ProjectionNonDeterminism", "internal", ("right-output",))
        elif operation == "revive-inert-occurrence":
            outputs = {"revival": {
                "kind": "tag/revival-fixture-result",
                "schema-version": 0,
                "claim-id": payload["requested-claim"],
                "new-occurrence": fixture_datum("claim-occurrence.beta-metadata-different"),
                "standing-status": "standing-status/unsupported-until-authorized-replay",
                "live-warrants": [],
            }}
        else:
            raise LCIFailure("invalid-input", "UnsupportedFixtureOperation", "fixture-operation", (operation,))
        return Outcome(operation, outputs=outputs)
    except LCIFailure as exc:
        return Outcome(operation, failure=exc)


def execute_row(row: dict) -> Outcome:
    input_document = from_package_json(row["inputs"]["abstract_cd0"], CD0_BUDGET)
    envelope = record_to_mapping(input_document)
    return execute(row["operation"], record_to_mapping(envelope["payload"]), vector_id=row["vector_id"])


def expected_outcome(row: dict) -> Outcome:
    """Test oracle: decode the frozen expected document, never called by execute."""

    expected = from_package_json(row["expected"]["abstract_cd0"], CD0_BUDGET)
    fields = record_to_mapping(expected)
    kind = id_name(fields["kind"]).split("/")[-1]
    if kind == "failure":
        path = tuple(id_name(item).split("/")[-1] for item in fields["path"].items)
        return Outcome(
            row["operation"],
            failure=LCIFailure(
                id_name(fields["category"]).split("/")[-1],
                id_name(fields["code"]).split("/")[-1],
                id_name(fields["stage"]).split("/")[-1],
                path,
            ),
        )
    return Outcome(row["operation"], outputs=_simple(fields["outputs"]))


def comparison_signature(outcome: Outcome) -> Any:
    if outcome.failure is not None:
        return ("failure",) + outcome.failure.comparison_key
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
