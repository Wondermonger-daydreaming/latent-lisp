"""Strict network-off pre-authorship records, lineage, gates, and mutations.

This module authorizes no item content.  Its committed fixtures are synthetic,
permanently tainted byte strings used only to prove refusal behavior.
"""

from __future__ import annotations

import argparse
import copy
import json
from datetime import datetime
from functools import lru_cache
from importlib.metadata import version as package_version
from pathlib import Path

from jsonschema import Draft202012Validator

from conditions import (
    CatchabilityWitnessLeak,
    DraftItemUsedAsFrozen,
    DuplicateDraftId,
    ExcludedFixtureDerivative,
    ExpectedAnswerLeak,
    ImmutableSuccessorViolation,
    KeyAuthorBoundaryViolation,
    LineageChronologyViolation,
    MissingLineageActor,
    MovingBankHandoff,
    MutableFilenameIdentity,
    MutationNotExercised,
    OwnerDecisionForgery,
    OwnerDecisionUnresolved,
    ParentDigestMismatch,
    PilotError,
    PreauthorshipStateViolation,
    PreauthorshipSchemaViolation,
    PredecessorDigestMismatch,
    PrivateRoleLeak,
    RecordDigestMismatch,
    RejectedDraftPreservationViolation,
    ScorableOpportunityLeak,
    SourceComponentMissing,
    TaintedAncestry,
    TrapDataLeak,
    UnloggedRead,
    WrongRecordVersion,
)
from util import PACKET_ROOT, canonical_json_bytes, load_json, load_jsonl, sha256_bytes, sha256_file


SCHEMA_PATH = PACKET_ROOT / "schemas/preauthorship.schema.json"
MUTATION_REGISTRY_PATH = PACKET_ROOT / "controls/preauthorship-mutations.json"
OWNER_RECORD_DIR = PACKET_ROOT / "operator/owner-decisions"
SUCCESSOR_LINEAGE_PATH = PACKET_ROOT / "lineage/successor/events.jsonl"
FIXTURE_DIR = PACKET_ROOT / "controls/preauthorship-synthetic-fixtures"
FIXED_TEST_TIME = "2026-07-15T23:59:48-03:00"
FIXTURE_ACTOR = "actor:synthetic-preauthorship-validator"
FIXTURE_TAINT_ID = "taint:preauthorship-mutation-fixtures-v1"
CONSTRUCT_SPECIMEN_TAINT_ID = "taint:anti-taxidermy-construct-specimens-v1"
CURRENT_TRANCHE_MAX_STATE = "candidate"
GOLDEN_VECTOR_PATH = PACKET_ROOT / "controls/canonicalization-golden/GOLDEN-VECTOR.json"
COMMISSION_BASIS_DIGEST = "sha256:ef5366139065c741d9ee4d7bcc02fd426a1cdae7abb7d2fd61b4d27abc0981fa"
PREDECESSOR_MUTATION_REGISTRY_SHA256 = "a9c0e2e3dab5caa324272b2bf9201933537f075d68a77d248f45f9e510f2cd91"
OWNER_PREDECESSOR_DIGESTS = {
    "ODR-43": "sha256:e7e41314f5e05e67bf80477c6e37e5a7d4844c865ceed5c0b5cea7a0fb8edce9",
    "ODR-60": "sha256:6b6d4747339682257923b03898b4bbea24d6d9368869d45a7010cdceeacbce33",
}

SCHEMA_BY_VERSION = {
    "lae-item-record/1.0.0": "item-record",
    "lae-source-packet-manifest/1.0.0": "source-packet-manifest",
    "lae-source-component/1.0.0": "source-component",
    "lae-arm-rendering/1.0.0": "arm-rendering",
    "lae-ancestry-declaration/1.0.0": "ancestry-declaration",
    "lae-prior-exposure-declaration/1.0.0": "prior-exposure-declaration",
    "lae-exclusion-taint-record/1.0.0": "exclusion-taint-record",
    "lae-lexical-collision-receipt/1.0.0": "lexical-collision-receipt",
    "lae-semantic-overlap-receipt/1.0.0": "semantic-overlap-receipt",
    "lae-catchability-witness/1.0.0": "catchability-witness",
    "lae-item-freezer-dossier/1.0.0": "item-freezer-dossier",
    "lae-freezer-decision-record/1.0.0": "freezer-decision-record",
    "lae-state-transition-record/1.0.0": "state-transition-record",
    "lae-frozen-bank-manifest/1.0.0": "frozen-bank-manifest",
    "lae-key-author-input-manifest/1.0.0": "key-author-input-manifest",
    "lae-handoff-public-artifact/1.0.0": "handoff-public-artifact",
    "lae-owner-decision-record/1.0.0": "owner-decision-record",
    "lae-odr-60-allocation-candidate/1.0.0": "odr-60-allocation-candidate",
    "lae-opportunity-record/1.0.0": "opportunity-record",
    "lae-keyed-unit-record/1.0.0": "keyed-unit-record",
    "lae-future-score-profile-record/1.0.0": "future-score-profile-record",
    "lae-construct-validity-specimen-record/1.0.0": "construct-validity-specimen-record",
    "lae-future-branch-receipt-riders/1.0.0": "future-branch-receipt-riders",
    "lae-lineage-event/1.0.0": "lineage-event-legacy",
    "lae-lineage-event/2.0.0": "lineage-event",
}

PRIVATE_KEY_CLASSES = {
    "proposed_role_memberships": PrivateRoleLeak,
    "proposed_role": PrivateRoleLeak,
    "role_labels": PrivateRoleLeak,
    "positive_conclusion_role": PrivateRoleLeak,
    "insufficiency_role": PrivateRoleLeak,
    "expected_answer": ExpectedAnswerLeak,
    "expected_answers": ExpectedAnswerLeak,
    "expected_answer_artifacts": ExpectedAnswerLeak,
    "proposed_trap_classes": TrapDataLeak,
    "trap_class": TrapDataLeak,
    "trap_labels": TrapDataLeak,
    "proposed_opportunity_ids": ScorableOpportunityLeak,
    "proposed_scorable_opportunity_ids": ScorableOpportunityLeak,
    "scorable_opportunities": ScorableOpportunityLeak,
    "catchability_witnesses": CatchabilityWitnessLeak,
    "catchability_witness_ids": CatchabilityWitnessLeak,
    "witness": CatchabilityWitnessLeak,
    "lawful_and_failing_examples": CatchabilityWitnessLeak,
    "lawful_artifact_bytes": CatchabilityWitnessLeak,
    "failing_artifact_bytes": CatchabilityWitnessLeak,
    "opportunity_records": ScorableOpportunityLeak,
    "answerability_class": ScorableOpportunityLeak,
    "required_supported_conclusion_bytes": ExpectedAnswerLeak,
    "keyed_unit_id": ScorableOpportunityLeak,
}

CONSUMERS_REQUIRING_FROZEN = {
    "runner", "schedule", "scoring-key", "exposure-manifest", "key-author-input"
}


def _pairs_without_duplicates(pairs):
    result = {}
    for key, value in pairs:
        if key in result:
            raise PreauthorshipSchemaViolation(f"duplicate JSON member: {key}")
        result[key] = value
    return result


def strict_json_load(path):
    try:
        return json.loads(Path(path).read_text(encoding="utf-8"), object_pairs_hook=_pairs_without_duplicates)
    except (json.JSONDecodeError, UnicodeDecodeError) as exc:
        raise PreauthorshipSchemaViolation(f"{path}: {exc}") from exc


def strict_jsonl_load(path):
    rows = []
    for number, line in enumerate(Path(path).read_text(encoding="utf-8").splitlines(), 1):
        if not line.strip():
            continue
        try:
            rows.append(json.loads(line, object_pairs_hook=_pairs_without_duplicates))
        except (json.JSONDecodeError, UnicodeDecodeError) as exc:
            raise PreauthorshipSchemaViolation(f"{path}:{number}: {exc}") from exc
    return rows


@lru_cache(maxsize=1)
def schema_bundle():
    bundle = strict_json_load(SCHEMA_PATH)
    try:
        Draft202012Validator.check_schema(bundle)
    except Exception as exc:  # jsonschema emits several schema-error subclasses
        raise PreauthorshipSchemaViolation(f"schema bundle invalid: {exc}") from exc
    return bundle


def schema_inventory():
    bundle = schema_bundle()
    inventory = []
    for schema_version, definition in sorted(SCHEMA_BY_VERSION.items()):
        if definition not in bundle["$defs"]:
            raise PreauthorshipSchemaViolation(f"missing schema definition: {definition}")
        inventory.append({"schema": definition, "schema_version": schema_version})
    return inventory


@lru_cache(maxsize=None)
def _validator(definition):
    bundle = schema_bundle()
    root = {
        "$schema": bundle["$schema"],
        "$defs": bundle["$defs"],
        "$ref": f"#/$defs/{definition}",
    }
    return Draft202012Validator(root)


def digest_material(record):
    material = copy.deepcopy(record)
    material.pop("record_digest", None)
    material.pop("canonical_byte_length", None)
    return canonical_json_bytes(material)


def seal_record(record):
    sealed = copy.deepcopy(record)
    material = digest_material(sealed)
    sealed["canonical_byte_length"] = len(material)
    sealed["record_digest"] = "sha256:" + sha256_bytes(material)
    return sealed


def validate_record_digest(record):
    material = digest_material(record)
    expected_digest = "sha256:" + sha256_bytes(material)
    if record.get("record_digest") != expected_digest:
        raise RecordDigestMismatch(record.get("record_id", record.get("event_id", "missing-id")))
    if record.get("canonical_byte_length") != len(material):
        raise RecordDigestMismatch("canonical byte length differs")


def validate_canonical_golden_vector(material_bytes=None):
    vector = strict_json_load(GOLDEN_VECTOR_PATH)
    material_path = PACKET_ROOT / vector["canonical_bytes_path"]
    sealed_path = PACKET_ROOT / vector["sealed_record_path"]
    observed = material_path.read_bytes() if material_bytes is None else material_bytes
    try:
        material = json.loads(observed.decode("utf-8"), object_pairs_hook=_pairs_without_duplicates)
    except (json.JSONDecodeError, UnicodeDecodeError) as exc:
        raise RecordDigestMismatch(f"golden canonical bytes: {exc}") from exc
    if canonical_json_bytes(material) != observed:
        raise RecordDigestMismatch("golden canonical bytes differ")
    observed_digest = "sha256:" + sha256_bytes(observed)
    if len(observed) != vector["canonical_byte_length"] or observed_digest != vector["expected_sha256"]:
        raise RecordDigestMismatch("golden byte identity differs")
    sealed = strict_json_load(sealed_path)
    if digest_material(sealed) != observed or sealed["record_digest"] != observed_digest or sealed["canonical_byte_length"] != len(observed):
        raise RecordDigestMismatch("golden sealed record differs")
    return vector


def _walk_keys(value):
    if isinstance(value, dict):
        for key, child in value.items():
            yield key
            yield from _walk_keys(child)
    elif isinstance(value, list):
        for child in value:
            yield from _walk_keys(child)


def reject_private_fields(value):
    for key in _walk_keys(value):
        condition = PRIVATE_KEY_CLASSES.get(key)
        if condition is not None:
            raise condition(key)


def _semantic_identity_check(record):
    identity_keys = {
        "record_id", "item_id", "source_packet_id", "component_id", "rendering_id",
        "handoff_id", "locator_id", "event_id", "subject_id", "dossier_id",
    }
    storage_names = {
        Path(value["storage_path"]).name
        for value in _byte_bindings(record)
        if isinstance(value.get("storage_path"), str)
    }
    for key in identity_keys:
        value = record.get(key)
        if not isinstance(value, str):
            continue
        suffix = value.split(":", 1)[-1]
        if "/" in value or "\\" in value or suffix in storage_names:
            raise MutableFilenameIdentity(f"{key}={value}")
        if suffix.lower().endswith((".json", ".jsonl", ".txt", ".bin", ".md")):
            raise MutableFilenameIdentity(f"{key}={value}")


def _byte_bindings(value):
    if isinstance(value, dict):
        if {"artifact_id", "storage_path", "byte_length", "sha256", "byte_role"}.issubset(value):
            yield value
        for child in value.values():
            yield from _byte_bindings(child)
    elif isinstance(value, list):
        for child in value:
            yield from _byte_bindings(child)


def validate_byte_binding(binding, root=PACKET_ROOT):
    root = Path(root).resolve()
    path = (root / binding["storage_path"]).resolve()
    if root != path and root not in path.parents:
        raise SourceComponentMissing(f"path escapes packet root: {binding['storage_path']}")
    if not path.is_file():
        raise SourceComponentMissing(binding["storage_path"])
    if path.stat().st_size != binding["byte_length"]:
        raise RecordDigestMismatch(f"byte length: {binding['artifact_id']}")
    if "sha256:" + sha256_file(path) != binding["sha256"]:
        raise RecordDigestMismatch(f"byte digest: {binding['artifact_id']}")


def validate_record(record, definition=None, root=PACKET_ROOT, verify_bound_bytes=True):
    version = record.get("schema_version")
    expected_definition = SCHEMA_BY_VERSION.get(version)
    if expected_definition is None:
        raise WrongRecordVersion(str(version))
    if definition is not None and expected_definition != definition:
        raise WrongRecordVersion(f"{version} is not {definition}")
    if expected_definition in {"item-record", "arm-rendering", "key-author-input-manifest"}:
        reject_private_fields(record)
    errors = sorted(_validator(expected_definition).iter_errors(record), key=lambda error: list(error.path))
    if errors:
        first = errors[0]
        location = "/".join(str(part) for part in first.absolute_path) or "<root>"
        raise PreauthorshipSchemaViolation(f"{expected_definition}:{location}: {first.message}")
    validate_record_digest(record)
    _semantic_identity_check(record)
    if verify_bound_bytes:
        for binding in _byte_bindings(record):
            validate_byte_binding(binding, root)
    return expected_definition


def _reference_index(records):
    index = {}
    versioned_domain_ids = set()
    domain_id_by_version = {
        "lae-item-record/1.0.0": "item_id",
        "lae-source-packet-manifest/1.0.0": "source_packet_id",
        "lae-source-component/1.0.0": "component_id",
        "lae-arm-rendering/1.0.0": "rendering_id",
        "lae-key-author-input-manifest/1.0.0": "handoff_id",
    }
    for record in records:
        record_id = record["record_id"]
        if record_id in index:
            raise DuplicateDraftId(record_id)
        index[record_id] = record
        key = domain_id_by_version.get(record["schema_version"])
        value = record.get(key) if key else None
        if value is not None:
            version_key = (record["schema_version"], value, record.get("state_version", record.get("record_digest")))
            if version_key in versioned_domain_ids:
                raise DuplicateDraftId(value)
            versioned_domain_ids.add(version_key)
    return index


def resolve_ref(reference, index, expected_schema=None):
    target = index.get(reference["record_id"])
    if target is None:
        raise SourceComponentMissing(reference["record_id"])
    if target["schema_version"] != reference["schema_version"]:
        raise WrongRecordVersion(reference["record_id"])
    if target["record_digest"] != reference["record_digest"]:
        raise ParentDigestMismatch(reference["record_id"])
    if expected_schema is not None and target["schema_version"] != expected_schema:
        raise WrongRecordVersion(reference["record_id"])
    return target


def validate_tranche_state(record, allow_synthetic=False):
    state = record.get("draft_state", record.get("state"))
    if state in {"freezer-accepted", "frozen"} and record.get("state_transition") is None:
        raise PreauthorshipStateViolation(f"{record['record_id']} -> {state} without transition")


def _state_of(record):
    return record.get("draft_state", record.get("state"))


def _rendering_set_digest(renderings):
    return "sha256:" + sha256_bytes(canonical_json_bytes(sorted(record["record_digest"] for record in renderings)))


def validate_state_transition_graph(records, index):
    transitions = [record for record in records if record["schema_version"] == "lae-state-transition-record/1.0.0"]
    for transition in transitions:
        predecessor_item = resolve_ref(transition["predecessor_item"], index, "lae-item-record/1.0.0")
        predecessor_source = resolve_ref(transition["predecessor_source_manifest"], index, "lae-source-packet-manifest/1.0.0")
        predecessor_renderings = [resolve_ref(ref, index, "lae-arm-rendering/1.0.0") for ref in transition["predecessor_renderings"]]
        predecessor_components = [resolve_ref(ref, index, "lae-source-component/1.0.0") for ref in transition["predecessor_source_components"]]
        decision = resolve_ref(transition["freezer_decision"], index, "lae-freezer-decision-record/1.0.0")
        authority = resolve_ref(transition["freezer_authority"], index, "lae-handoff-public-artifact/1.0.0")
        expected_phase = "candidate-acceptance" if transition["resulting_state"] == "freezer-accepted" else "final-freeze"
        if transition["transition_kind"] != f"{transition['predecessor_state']}-to-{transition['resulting_state']}":
            raise PreauthorshipStateViolation(f"transition kind: {transition['transition_id']}")
        if transition["receipt_kind"] != expected_phase or decision["decision_phase"] != expected_phase:
            raise PreauthorshipStateViolation(f"decision phase: {transition['transition_id']}")
        if decision["decision"] != "accepted" or decision["resulting_state"] != transition["resulting_state"]:
            raise PreauthorshipStateViolation(f"decision result: {transition['transition_id']}")
        if resolve_ref(decision["item"], index)["record_digest"] != predecessor_item["record_digest"]:
            raise ParentDigestMismatch(f"decision item: {transition['transition_id']}")
        if resolve_ref(decision["reviewer_authority"], index)["record_digest"] != authority["record_digest"]:
            raise PreauthorshipStateViolation(f"decision authority: {transition['transition_id']}")
        if authority["handoff_artifact_kind"] != "authority-identity" or authority.get("represented_actor_id") != transition["freezer_actor_id"]:
            raise PreauthorshipStateViolation(f"unresolved freezer authority: {transition['transition_id']}")
        if decision["reviewer_actor_id"] != transition["freezer_actor_id"]:
            raise PreauthorshipStateViolation(f"freezer actor mismatch: {transition['transition_id']}")
        if _state_of(predecessor_item) != transition["predecessor_state"] or predecessor_item["state_version"] != transition["predecessor_state_version"]:
            raise PreauthorshipStateViolation(f"item predecessor version: {transition['transition_id']}")
        predecessors = [predecessor_source, *predecessor_renderings, *predecessor_components]
        if any(_state_of(record) != transition["predecessor_state"] or record["state_version"] != transition["predecessor_state_version"] for record in predecessors):
            raise PreauthorshipStateViolation(f"source/rendering predecessor version: {transition['transition_id']}")
        if transition["resulting_state_version"] != transition["predecessor_state_version"] + 1:
            raise PreauthorshipStateViolation(f"nonconsecutive state version: {transition['transition_id']}")
        if transition["item_record_digest"] != predecessor_item["record_digest"] or transition["source_manifest_digest"] != predecessor_source["record_digest"]:
            raise ParentDigestMismatch(f"transition artifact digest: {transition['transition_id']}")
        if transition["rendering_set_digest"] != _rendering_set_digest(predecessor_renderings):
            raise ParentDigestMismatch(f"transition rendering set: {transition['transition_id']}")
        if transition["predecessor_digest"] != decision["record_digest"]:
            raise PredecessorDigestMismatch(transition["transition_id"])

        transition_ref = _ref(transition)
        successors = [record for record in records if record.get("state_transition") == transition_ref]
        expected_counts = {
            "lae-item-record/1.0.0": 1,
            "lae-source-packet-manifest/1.0.0": 1,
            "lae-arm-rendering/1.0.0": len(predecessor_renderings),
            "lae-source-component/1.0.0": len(predecessor_components),
        }
        for schema_version, count in expected_counts.items():
            matching = [record for record in successors if record["schema_version"] == schema_version]
            if len(matching) != count:
                raise PreauthorshipStateViolation(f"successor closure: {transition['transition_id']} {schema_version}")
            for successor in matching:
                if _state_of(successor) != transition["resulting_state"] or successor["state_version"] != transition["resulting_state_version"]:
                    raise PreauthorshipStateViolation(f"successor version: {successor['record_id']}")
                if transition_ref not in successor["parent_versions"]:
                    raise ParentDigestMismatch(f"transition parent: {successor['record_id']}")
        successor_item = next(record for record in successors if record["schema_version"] == "lae-item-record/1.0.0")
        if successor_item["predecessor_digest"] != predecessor_item["record_digest"] or successor_item["freezer_decision"] != _ref(decision):
            raise ParentDigestMismatch(f"item successor: {transition['transition_id']}")
        predecessor_by_identity = {
            (record["schema_version"], record.get("source_packet_id", record.get("rendering_id", record.get("component_id")))): record
            for record in [predecessor_source, *predecessor_renderings, *predecessor_components]
        }
        for successor in successors:
            if successor["schema_version"] == "lae-item-record/1.0.0":
                continue
            identity = successor.get("source_packet_id", successor.get("rendering_id", successor.get("component_id")))
            predecessor = predecessor_by_identity[(successor["schema_version"], identity)]
            if successor["predecessor_digest"] != predecessor["record_digest"] or _ref(predecessor) not in successor["parent_versions"]:
                raise ParentDigestMismatch(f"state predecessor: {successor['record_id']}")

    for record in records:
        state = _state_of(record)
        if state in {"freezer-accepted", "frozen"}:
            transition = resolve_ref(record["state_transition"], index, "lae-state-transition-record/1.0.0")
            if transition["resulting_state"] != state:
                raise PreauthorshipStateViolation(f"wrong transition state: {record['record_id']}")


def validate_record_graph(records, root=PACKET_ROOT, allow_synthetic=False):
    for record in records:
        validate_record(record, root=root)
    index = _reference_index(records)
    for record in records:
        for parent in record.get("parent_versions", []):
            resolve_ref(parent, index)
        taint_id = record.get("synthetic_taint_id")
        validate_tranche_state(record, allow_synthetic=allow_synthetic)
        if taint_id is not None:
            taint = index.get(taint_id)
            if taint is None or taint.get("disposition") != "permanently-tainted":
                raise TaintedAncestry(f"unclosed synthetic taint: {taint_id}")
            if not allow_synthetic:
                condition = ExcludedFixtureDerivative if taint.get("reason_class") in {"public-fixture", "cd0-lci0-vector"} else TaintedAncestry
                raise condition(record["record_id"])

    for manifest in (record for record in records if record["schema_version"] == "lae-source-packet-manifest/1.0.0"):
        components = [resolve_ref(ref, index, "lae-source-component/1.0.0") for ref in manifest["components"]]
        component_ids = [component["component_id"] for component in components]
        if component_ids != manifest["canonical_order"]:
            raise SourceComponentMissing(f"canonical order: {manifest['source_packet_id']}")
        if any(component["source_packet_id"] != manifest["source_packet_id"] for component in components):
            raise WrongRecordVersion(f"component packet: {manifest['source_packet_id']}")

    for item in (record for record in records if record["schema_version"] == "lae-item-record/1.0.0"):
        source = resolve_ref(item["source_packet"], index, "lae-source-packet-manifest/1.0.0")
        for rendering_ref in item["renderings"]:
            rendering = resolve_ref(rendering_ref, index, "lae-arm-rendering/1.0.0")
            if rendering["item_id"] != item["item_id"]:
                raise ParentDigestMismatch(rendering["rendering_id"])
            if rendering["item_task_sha256"] != item["task_bytes"]["sha256"]:
                raise ParentDigestMismatch(f"task bytes: {rendering['rendering_id']}")
            if rendering["source_packet"]["record_digest"] != source["record_digest"]:
                raise ParentDigestMismatch(f"source bytes: {rendering['rendering_id']}")
        for key, schema in (
            ("ancestry", "lae-ancestry-declaration/1.0.0"),
            ("prior_exposure", "lae-prior-exposure-declaration/1.0.0"),
            ("exclusion_receipt", "lae-exclusion-taint-record/1.0.0"),
            ("lexical_collision_receipt", "lae-lexical-collision-receipt/1.0.0"),
            ("semantic_overlap_receipt", "lae-semantic-overlap-receipt/1.0.0"),
        ):
            resolved = resolve_ref(item[key], index, schema)
            if resolved.get("subject_id", resolved.get("candidate_id", item["item_id"])) != item["item_id"]:
                raise ParentDigestMismatch(f"{key}: {item['item_id']}")
        exclusion = resolve_ref(item["exclusion_receipt"], index)
        if exclusion["disposition"] in {"excluded", "permanently-tainted", "rejected"}:
            condition = ExcludedFixtureDerivative if exclusion["reason_class"] in {"public-fixture", "cd0-lci0-vector"} else TaintedAncestry
            raise condition(item["item_id"])
        if source["state"] not in {"draft", "candidate"} and source["state"] != item["draft_state"]:
            raise WrongRecordVersion(f"moving source packet: {item['item_id']}")
    validate_state_transition_graph(records, index)
    return index


def validate_consumption(item, consumer):
    if consumer not in CONSUMERS_REQUIRING_FROZEN:
        raise ValueError(f"unknown consumer: {consumer}")
    if item.get("draft_state") != "frozen":
        raise DraftItemUsedAsFrozen(f"{item.get('item_id')} -> {consumer}")


def validate_key_author_input(manifest, records, root=PACKET_ROOT, allow_synthetic=False):
    reject_private_fields(manifest)
    try:
        validate_record(manifest, "key-author-input-manifest", root=root)
    except PreauthorshipSchemaViolation as exc:
        raise KeyAuthorBoundaryViolation(exc.detail) from exc
    try:
        index = validate_record_graph(records, root=root, allow_synthetic=allow_synthetic)
        bank = resolve_ref(manifest["frozen_bank_manifest"], index, "lae-frozen-bank-manifest/1.0.0")
    except PilotError as exc:
        raise KeyAuthorBoundaryViolation(f"frozen bank graph: {exc.detail}") from exc
    kinds = {
        "frozen-item": ("lae-item-record/1.0.0", "task_bytes"),
        "frozen-rendering": ("lae-arm-rendering/1.0.0", "visible_bytes"),
        "source-packet-manifest": ("lae-source-packet-manifest/1.0.0", "manifest_bytes"),
        "source-component": ("lae-source-component/1.0.0", "component_bytes"),
        "controlling-scoring-doctrine": ("lae-handoff-public-artifact/1.0.0", "public_bytes"),
        "authority-identity": ("lae-handoff-public-artifact/1.0.0", "public_bytes"),
        "neutral-custody-receipt": ("lae-handoff-public-artifact/1.0.0", "public_bytes"),
    }
    required_refs = {
        "frozen-item": bank["items"],
        "frozen-rendering": bank["required_renderings"],
        "source-packet-manifest": bank["required_source_manifests"],
        "source-component": bank["required_source_components"],
        "controlling-scoring-doctrine": bank["controlling_scoring_doctrine"],
        "authority-identity": bank["authority_identities"],
        "neutral-custody-receipt": [bank["neutral_custody_receipt"]],
    }
    expected_entries = {
        (kind, ref["record_id"], ref["record_digest"])
        for kind, refs in required_refs.items()
        for ref in refs
    }
    delivered_entries = [
        (entry["artifact_kind"], entry["record"]["record_id"], entry["record"]["record_digest"])
        for entry in manifest["entries"]
    ]
    if len(delivered_entries) != len(set(delivered_entries)):
        raise KeyAuthorBoundaryViolation("duplicate handoff entry")
    if set(delivered_entries) != expected_entries:
        missing = sorted(expected_entries - set(delivered_entries))
        extra = sorted(set(delivered_entries) - expected_entries)
        raise KeyAuthorBoundaryViolation(f"authorized-set equality missing={missing} extra={extra}")
    if manifest["delivered_entry_cardinality"] != len(delivered_entries):
        raise KeyAuthorBoundaryViolation("delivered entry cardinality")
    item_refs = bank["items"]
    if len({ref["record_id"] for ref in item_refs}) != len(item_refs):
        raise KeyAuthorBoundaryViolation("duplicate item record")
    if bank["declared_item_cardinality"] != len(item_refs):
        raise MovingBankHandoff("bank declared cardinality")
    if not (manifest["declared_bank_cardinality"] == manifest["delivered_bank_cardinality"] == len(item_refs)):
        raise MovingBankHandoff("handoff bank cardinality")

    resolved_required = {}
    for kind, refs in required_refs.items():
        schema_version, _ = kinds[kind]
        resolved_required[kind] = [resolve_ref(ref, index, schema_version) for ref in refs]
    item_digests = [record["record_digest"] for record in resolved_required["frozen-item"]]
    if any(record.get("draft_state") != "frozen" for record in resolved_required["frozen-item"]):
        raise MovingBankHandoff("non-frozen item")
    for kind in ("frozen-rendering", "source-packet-manifest", "source-component"):
        if any(record.get("state") != "frozen" for record in resolved_required[kind]):
            raise MovingBankHandoff(f"non-frozen {kind}")
    for kind in ("controlling-scoring-doctrine", "authority-identity", "neutral-custody-receipt"):
        if any(record["handoff_artifact_kind"] != kind for record in resolved_required[kind]):
            raise KeyAuthorBoundaryViolation(f"public kind mismatch: {kind}")

    expected_rendering_refs = {tuple(sorted(ref.items())) for item in resolved_required["frozen-item"] for ref in item["renderings"]}
    delivered_rendering_refs = {tuple(sorted(ref.items())) for ref in bank["required_renderings"]}
    expected_source_refs = {tuple(sorted(item["source_packet"].items())) for item in resolved_required["frozen-item"]}
    delivered_source_refs = {tuple(sorted(ref.items())) for ref in bank["required_source_manifests"]}
    expected_component_refs = {tuple(sorted(ref.items())) for source in resolved_required["source-packet-manifest"] for ref in source["components"]}
    delivered_component_refs = {tuple(sorted(ref.items())) for ref in bank["required_source_components"]}
    if expected_rendering_refs != delivered_rendering_refs or expected_source_refs != delivered_source_refs or expected_component_refs != delivered_component_refs:
        raise MovingBankHandoff("item/source/rendering parent closure")

    for entry in manifest["entries"]:
        artifact_kind = entry["artifact_kind"]
        if artifact_kind not in kinds:
            raise KeyAuthorBoundaryViolation(entry["artifact_kind"])
        schema_version, binding_field = kinds[artifact_kind]
        try:
            target = resolve_ref(entry["record"], index, schema_version)
        except (SourceComponentMissing, WrongRecordVersion, ParentDigestMismatch) as exc:
            raise KeyAuthorBoundaryViolation(f"{artifact_kind}: {exc.detail}") from exc
        if schema_version == "lae-handoff-public-artifact/1.0.0" and target["handoff_artifact_kind"] != artifact_kind:
            raise KeyAuthorBoundaryViolation(f"kind mismatch: {artifact_kind}")
        binding = target[binding_field]
        if entry["bytes"]["sha256"] != binding["sha256"] or entry["bytes"]["byte_length"] != binding["byte_length"]:
            raise KeyAuthorBoundaryViolation(f"byte mismatch: {artifact_kind}")
    expected_bank_digest = "sha256:" + sha256_bytes(canonical_json_bytes(sorted(item_digests)))
    if not item_digests or manifest["item_bank_digest"] != expected_bank_digest:
        raise MovingBankHandoff("item-bank digest does not close over exact frozen item records")
    authorized_set_digest = "sha256:" + sha256_bytes(canonical_json_bytes(sorted(expected_entries)))
    if bank["authorized_set_digest"] != authorized_set_digest:
        raise KeyAuthorBoundaryViolation("frozen bank authorized-set digest")
    if {tuple(sorted(ref.items())) for ref in manifest["authority_identities"]} != {tuple(sorted(ref.items())) for ref in bank["authority_identities"]}:
        raise KeyAuthorBoundaryViolation("authority identity set")
    return True


def _parse_time(value):
    try:
        return datetime.fromisoformat(value)
    except ValueError as exc:
        raise LineageChronologyViolation(value) from exc


def validate_lineage(events):
    if not events:
        raise PredecessorDigestMismatch("empty lineage")
    superseded_legacy = {
        event.get("supersedes_event_digest")
        for event in events
        if event.get("schema_version") == "lae-lineage-event/2.0.0" and event.get("event_type") == "correction"
    }
    by_digest = {}
    by_id = {}
    actors = set()
    artifacts = {}
    reads = set()
    previous_digest = None
    previous_time = None
    for position, event in enumerate(events):
        validate_record(event, verify_bound_bytes=False)
        strict_v2 = event["schema_version"] == "lae-lineage-event/2.0.0"
        digest = event["record_digest"]
        if event["event_id"] in by_id or digest in by_digest:
            raise ImmutableSuccessorViolation(event["event_id"])
        if event["predecessor_digest"] != previous_digest:
            raise PredecessorDigestMismatch(event["event_id"])
        current_time = _parse_time(event["event_time"])
        if previous_time is not None and current_time < previous_time and event["chronology_basis"] != "declared-causal":
            raise LineageChronologyViolation(event["event_id"])
        if event["event_type"] == "actor":
            actors.add(event["subject_id"])
        elif event["actor_id"] not in actors:
            raise MissingLineageActor(event["actor_id"])
        for required_digest in event["basis_event_digests"] + event["causal_predecessor_digests"]:
            if required_digest not in by_digest:
                raise PredecessorDigestMismatch(f"basis: {event['event_id']}")
        for required_digest in event["parent_artifact_digests"] + event["input_artifact_digests"]:
            if required_digest not in artifacts:
                raise ParentDigestMismatch(f"artifact: {event['event_id']}")
        for reference in event["artifact_refs"]:
            target = artifacts.get(reference["artifact_event_digest"])
            if target is None:
                raise ParentDigestMismatch(reference["artifact_id"])
            claims = {claim["dimension"]: claim["value"] for claim in target["claims"]}
            if reference["sha256"] != claims.get("sha256") or reference["byte_length"] != claims.get("byte-length"):
                raise ParentDigestMismatch(reference["artifact_id"])
        if event["event_type"] == "read":
            for reference in event["artifact_refs"]:
                reads.add((event["actor_id"], reference["artifact_event_digest"]))
        if event["event_type"] == "artifact" and event["action"] == "created":
            for parent_digest in event["input_artifact_digests"]:
                if (event["actor_id"], parent_digest) not in reads:
                    raise UnloggedRead(event["event_id"])
            artifacts[digest] = event
        elif event["event_type"] == "artifact":
            artifacts[digest] = event
        if event["event_type"] in {"transmission", "handoff"}:
            if not strict_v2:
                if digest not in superseded_legacy:
                    raise ImmutableSuccessorViolation(f"unsuperseded legacy transmission: {event['event_id']}")
            else:
                sender = event["sender_actor_id"]
                recipient = event["recipient_actor_id"]
                if sender not in actors or recipient not in actors:
                    raise MissingLineageActor(f"transmission actors: {event['event_id']}")
                authorization = by_digest.get(event["authorization_basis_event_digest"])
                if authorization is None or authorization["event_type"] != "authorization":
                    raise UnloggedRead(f"authorization basis: {event['event_id']}")
                bases = [by_digest[digest] for digest in event["basis_event_digests"]]
                for reference in event["artifact_refs"]:
                    prior_basis = any(
                        basis["record_digest"] == reference["artifact_event_digest"]
                        or (
                            basis["event_type"] == "read"
                            and basis["actor_id"] == sender
                            and any(ref["artifact_event_digest"] == reference["artifact_event_digest"] for ref in basis["artifact_refs"])
                        )
                        for basis in bases
                    )
                    if not prior_basis:
                        raise UnloggedRead(f"transmitted artifact basis: {reference['artifact_id']}")
                receipt = event["receipt_state"]
                if receipt["status"] == "acknowledged":
                    receipt_event = by_digest.get(receipt["receipt_event_digest"])
                    if receipt_event is None or receipt_event["event_type"] != "acknowledgment":
                        raise ParentDigestMismatch(f"receipt: {event['event_id']}")
        if event["standing"] == "self-report":
            separation_claims = [claim for claim in event["claims"] if claim["dimension"] == "separation"]
            if any(claim["value"] is True or claim["bound"] == "exact" for claim in separation_claims):
                raise ImmutableSuccessorViolation("self-report cannot certify separation")
        if event["action"] in {"corrected", "succeeded"}:
            target = by_digest.get(event["supersedes_event_digest"])
            if target is None:
                if event["action"] == "succeeded":
                    raise RejectedDraftPreservationViolation(event["event_id"])
                raise ImmutableSuccessorViolation(event["event_id"])
            if target["action"] == "rejected" and not event["rejection_preserved"]:
                raise RejectedDraftPreservationViolation(event["event_id"])
        if strict_v2 and event["event_type"] in {"correction", "successor"}:
            target_digest = event["supersedes_event_digest"]
            if target_digest is None or target_digest not in by_digest or target_digest not in event["causal_predecessor_digests"]:
                raise ImmutableSuccessorViolation(f"supersedes closure: {event['event_id']}")
        by_digest[digest] = event
        by_id[event["event_id"]] = event
        previous_digest = digest
        previous_time = current_time
    return True


def validate_odr60_allocation(decision):
    errors = sorted(_validator("odr-60-exact-decision").iter_errors(decision), key=lambda error: list(error.path))
    if errors:
        raise OwnerDecisionForgery(errors[0].message)
    rows = decision["item_rows"]
    expected_slots = {f"{prefix}-{number:02d}" for prefix in ("BS", "SV", "CR", "NT") for number in range(1, 7)}
    slot_ids = [row["slot_id"] for row in rows]
    if set(slot_ids) != expected_slots or len(slot_ids) != len(set(slot_ids)):
        raise OwnerDecisionForgery("ODR-60 exact item-slot closure")
    family_by_prefix = {
        "BS": "BOUNDED-SUPPORT", "SV": "SCOPE-AND-VERSION",
        "CR": "CONFLICT-AND-RESIDUE", "NT": "NOTATION-NEUTRAL-TRANSFER",
    }
    for row in rows:
        if family_by_prefix[row["slot_id"][:2]] != row["content_family"]:
            raise OwnerDecisionForgery(f"ODR-60 slot/family mismatch: {row['slot_id']}")
        if "STRONG-CONCLUSION-CONTROL" in row["tags"] and row["answerability_role"] != "POSITIVE-CONCLUSION":
            raise OwnerDecisionForgery(f"ODR-60 strong control role: {row['slot_id']}")
    family_counts = {family: sum(row["content_family"] == family for row in rows) for family in family_by_prefix.values()}
    if set(family_counts.values()) != {6}:
        raise OwnerDecisionForgery("ODR-60 six slots per family")
    role_counts = {
        role: sum(row["answerability_role"] == role for row in rows)
        for role in ("POSITIVE-CONCLUSION", "DELIBERATE-INSUFFICIENCY", "MIXED-BOUNDED-CONTROL")
    }
    if role_counts != {"POSITIVE-CONCLUSION": 8, "DELIBERATE-INSUFFICIENCY": 8, "MIXED-BOUNDED-CONTROL": 8}:
        raise OwnerDecisionForgery(f"ODR-60 answerability totals: {role_counts}")
    for family in family_by_prefix.values():
        family_rows = [row for row in rows if row["content_family"] == family]
        if sum("SHAM-DESIGNATED" in row["tags"] for row in family_rows) != 2:
            raise OwnerDecisionForgery(f"ODR-60 SHAM pair: {family}")
        if not any("DOMAIN-NATIVE-NON-LANG-A-RENDERABLE" in row["tags"] for row in family_rows):
            raise OwnerDecisionForgery(f"ODR-60 domain-native item: {family}")
    tag_counts = {
        tag: sum(tag in row["tags"] for row in rows)
        for tag in (
            "TRAP-BEARING", "SHAM-DESIGNATED", "STRONG-CONCLUSION-CONTROL",
            "EASY-BOUNDED-CONTROL", "DOMAIN-NATIVE-NON-LANG-A-RENDERABLE",
        )
    }
    expected_tags = {
        "TRAP-BEARING": 12, "SHAM-DESIGNATED": 8,
        "STRONG-CONCLUSION-CONTROL": 4, "EASY-BOUNDED-CONTROL": 4,
        "DOMAIN-NATIVE-NON-LANG-A-RENDERABLE": 8,
    }
    if tag_counts != expected_tags:
        raise OwnerDecisionForgery(f"ODR-60 derived tag totals: {tag_counts}")
    return {"total_item_slots": len(rows), "family_counts": family_counts, "role_counts": role_counts, "tag_counts": tag_counts}


def validate_odr43_graph(decision, lineage_events):
    by_digest = {event["record_digest"]: event for event in lineage_events}
    actors = {event["subject_id"] for event in lineage_events if event["event_type"] == "actor"}
    referenced_actors = {decision["owner_actor_id"], decision["freezer_overlap_auditor_actor_id"], *decision["item_author_actor_ids"]}
    for assignment in decision["content_family_assignments"]:
        referenced_actors.add(assignment["actor_id"])
    for relationship in decision["cross_review_relationships"]:
        referenced_actors.add(relationship["reviewer_actor_id"])
        referenced_actors.update(relationship["reviewed_actor_ids"])
    for exposure in decision["exposure_declarations"]:
        referenced_actors.add(exposure["actor_id"])
        event = by_digest.get(exposure["exposure_event_digest"])
        if event is None or event["event_type"] != "prior-exposure" or event["actor_id"] != exposure["actor_id"]:
            raise OwnerDecisionForgery("ODR-43 exposure reference closure")
    for restriction in decision["role_specific_restrictions"]:
        referenced_actors.add(restriction["actor_id"])
    if not referenced_actors.issubset(actors):
        raise OwnerDecisionForgery(f"ODR-43 actor reference closure: {sorted(referenced_actors - actors)}")
    if any(by_digest.get(digest, {}).get("event_type") != "read" for digest in decision["apparatus_read_event_digests"]):
        raise OwnerDecisionForgery("ODR-43 apparatus-read reference closure")
    if any(by_digest.get(digest, {}).get("event_type") != "ancestry" for digest in decision["shared_root_event_digests"]):
        raise OwnerDecisionForgery("ODR-43 shared-root reference closure")


def validate_owner_records(records, require_adopted=False, lineage_events=None):
    grouped = {"ODR-43": [], "ODR-60": []}
    for record in records:
        if record.get("status") == "adopted" and (
            record.get("exact_decision") is None
            or record.get("rationale") is None
            or record.get("deciding_actor") is None
            or record.get("role_shared_root_disclosure") is None
            or record.get("adoption_timestamp") is None
        ):
            raise OwnerDecisionForgery(record.get("decision_id", "missing"))
        if record.get("complete") is True or record.get("resolved") is True:
            raise OwnerDecisionForgery(record.get("decision_id", "missing"))
        validate_record(record, "owner-decision-record", verify_bound_bytes=False)
        if record["decision_id"] not in grouped:
            raise OwnerDecisionForgery(record["decision_id"])
        if record["predecessor_digest"] is None:
            raise PredecessorDigestMismatch(record["decision_id"])
        grouped[record["decision_id"]].append(record)
    selected = {}
    lineage_by_digest = {event["record_digest"]: event for event in (lineage_events or [])}
    for decision_id, decision_records in grouped.items():
        unresolved = [record for record in decision_records if record["status"] == "unresolved"]
        adopted = [record for record in decision_records if record["status"] == "adopted"]
        if len(unresolved) != 1:
            raise OwnerDecisionUnresolved(f"preserved unresolved predecessor: {decision_id}")
        predecessor = unresolved[0]
        if predecessor["record_digest"] != OWNER_PREDECESSOR_DIGESTS[decision_id] or predecessor["record_id"] != f"owner-decision:{decision_id}-unresolved-v1":
            raise OwnerDecisionForgery(f"immutable unresolved predecessor: {decision_id}")
        if len(adopted) > 1:
            raise DuplicateDraftId(f"adopted successor: {decision_id}")
        if adopted:
            successor = adopted[0]
            if successor["record_id"] == predecessor["record_id"]:
                raise OwnerDecisionForgery(f"reused unresolved ID: {decision_id}")
            if successor["predecessor_digest"] != predecessor["record_digest"] or successor["unresolved_predecessor"] != _ref(predecessor):
                raise PredecessorDigestMismatch(f"owner adoption: {decision_id}")
            event = lineage_by_digest.get(successor["adoption_event_digest"])
            payload_digest = "sha256:" + sha256_bytes(canonical_json_bytes(successor["exact_decision"]))
            if event is None or event["event_type"] != "owner-adoption":
                raise OwnerDecisionForgery(f"missing adoption event: {decision_id}")
            if event["actor_id"] != successor["deciding_actor"] or event["owner_jurisdiction"] != successor["owner_jurisdiction"]:
                raise OwnerDecisionForgery(f"owner actor/jurisdiction: {decision_id}")
            if event["gate_closed"] != successor["exact_gate_closed"] or successor["exact_gate_closed"] != successor["exact_executable_gate"]:
                raise OwnerDecisionForgery(f"exact gate closure: {decision_id}")
            if event["decision_payload_digest"] != payload_digest or event["unresolved_predecessor_record_digest"] != predecessor["record_digest"]:
                raise OwnerDecisionForgery(f"adoption payload closure: {decision_id}")
            if decision_id == "ODR-43":
                validate_odr43_graph(successor["exact_decision"], lineage_events or [])
            else:
                validate_odr60_allocation(successor["exact_decision"])
            selected[decision_id] = successor
        else:
            selected[decision_id] = predecessor
    if lineage_events is not None:
        lineage_digests = {event["record_digest"] for event in lineage_events}
        for decision_id, record in selected.items():
            if record["status"] == "unresolved" and record["predecessor_digest"] not in lineage_digests:
                raise PredecessorDigestMismatch(decision_id)
    if require_adopted:
        unresolved = [decision_id for decision_id, record in selected.items() if record["status"] != "adopted"]
        if unresolved:
            raise OwnerDecisionUnresolved(",".join(unresolved))
        if len(records) != 4 or lineage_events is None:
            raise OwnerDecisionUnresolved("both predecessors, both successors, and lineage required")
    return selected


def drafting_gate(owner_records, lineage_events=None):
    if lineage_events is None:
        raise OwnerDecisionUnresolved("validated adoption lineage required")
    validate_lineage(lineage_events)
    validate_owner_records(owner_records, require_adopted=True, lineage_events=lineage_events)
    return True


def _ref(record):
    return {
        "record_id": record["record_id"],
        "schema_version": record["schema_version"],
        "record_digest": record["record_digest"],
    }


def _binding(filename, artifact_id, role, media_type="text/plain", encoding="utf-8"):
    relative = (FIXTURE_DIR / filename).relative_to(PACKET_ROOT).as_posix()
    path = PACKET_ROOT / relative
    return {
        "artifact_id": artifact_id,
        "byte_role": role,
        "storage_path": relative,
        "byte_length": path.stat().st_size,
        "sha256": "sha256:" + sha256_file(path),
        "media_type": media_type,
        "encoding": encoding,
    }


def _packet_binding(relative, artifact_id, role, media_type="text/plain", encoding="utf-8"):
    path = PACKET_ROOT / relative
    return {
        "artifact_id": artifact_id,
        "byte_role": role,
        "storage_path": relative,
        "byte_length": path.stat().st_size,
        "sha256": "sha256:" + sha256_file(path),
        "media_type": media_type,
        "encoding": encoding,
    }


def _base(version, record_id, **fields):
    return seal_record({
        "schema_version": version,
        "record_id": record_id,
        "actor_id": FIXTURE_ACTOR,
        "event_time": FIXED_TEST_TIME,
        "predecessor_digest": None,
        "parent_versions": [],
        "bounded_unknowns": ["synthetic fixture; no standing outside mutation verification"],
        "synthetic_taint_id": FIXTURE_TAINT_ID,
        **fields,
    })


def odr60_candidate_record():
    families = (
        ("BS", "BOUNDED-SUPPORT"),
        ("SV", "SCOPE-AND-VERSION"),
        ("CR", "CONFLICT-AND-RESIDUE"),
        ("NT", "NOTATION-NEUTRAL-TRANSFER"),
    )
    pattern = (
        ("POSITIVE-CONCLUSION", ["TRAP-BEARING", "STRONG-CONCLUSION-CONTROL", "SHAM-DESIGNATED", "DOMAIN-NATIVE-NON-LANG-A-RENDERABLE"]),
        ("POSITIVE-CONCLUSION", []),
        ("DELIBERATE-INSUFFICIENCY", ["TRAP-BEARING", "EASY-BOUNDED-CONTROL", "SHAM-DESIGNATED"]),
        ("DELIBERATE-INSUFFICIENCY", []),
        ("MIXED-BOUNDED-CONTROL", ["TRAP-BEARING"]),
        ("MIXED-BOUNDED-CONTROL", ["DOMAIN-NATIVE-NON-LANG-A-RENDERABLE"]),
    )
    rows = [
        {"slot_id": f"{prefix}-{number:02d}", "content_family": family, "answerability_role": role, "tags": tags}
        for prefix, family in families
        for number, (role, tags) in enumerate(pattern, 1)
    ]
    return seal_record({
        "schema_version": "lae-odr-60-allocation-candidate/1.0.0",
        "record_id": "owner-candidate:ODR-60-allocation-v0.2",
        "actor_id": "actor:owner-commission-repair-0.2",
        "event_time": "2026-07-16T02:41:20-03:00",
        "predecessor_digest": None,
        "parent_versions": [],
        "bounded_unknowns": ["owner has not adopted ODR-60", "candidate rows authorize no substantive item authorship"],
        "synthetic_taint_id": None,
        "candidate_id": "owner-candidate:ODR-60-allocation-v0.2",
        "decision_id": "ODR-60",
        "standing": "unresolved-owner-payload",
        "provenance": "owner-supplied-via-commission",
        "commission_basis_sha256": COMMISSION_BASIS_DIGEST,
        "allocation": {"decision_kind": "typed-item-allocation", "item_rows": rows},
    })


def validate_odr60_candidate(record):
    validate_record(record, "odr-60-allocation-candidate", verify_bound_bytes=False)
    return validate_odr60_allocation(record["allocation"])


def synthetic_record_graph(state="candidate"):
    if state not in {"draft", "candidate", "freezer-accepted", "frozen"}:
        raise ValueError(state)
    base_state = state if state in {"draft", "candidate"} else "candidate"
    base_state_version = 0 if base_state == "draft" else 1
    fixture_bindings = [
        _binding(name, f"artifact:synthetic-{name.replace('.', '-')}", "receipt")
        for name in sorted(path.name for path in FIXTURE_DIR.iterdir() if path.is_file())
    ]
    taint = _base(
        "lae-exclusion-taint-record/1.0.0", FIXTURE_TAINT_ID,
        subject_ids=["fixture:preauthorship-mutation-namespace"],
        subject_sha256s=sorted({binding["sha256"] for binding in fixture_bindings}),
        identity_bindings=fixture_bindings,
        disposition="permanently-tainted", reason_class="synthetic-mutation",
        semantic_derivatives_excluded=True, preserved_append_only=True,
        basis_event_digests=[],
    )
    component = _base(
        "lae-source-component/1.0.0", "component:synthetic-one",
        component_id="component:synthetic-one", source_packet_id="source:synthetic-one",
        component_bytes=_binding("source.txt", "artifact:synthetic-source", "source-component"),
        title="Synthetic schema fixture", creator="synthetic validator",
        version_or_edition="fixture-v1", license_or_permission="test-only",
        locators=[{
            "locator_id": "locator:synthetic-one-lines", "locator_type": "line-range",
            "start": "1", "end": "1", "label": "synthetic marker",
            "component_sha256": _binding("source.txt", "artifact:synthetic-source", "source-component")["sha256"],
        }],
        transformations=[], state=base_state, state_version=base_state_version, state_transition=None,
    )
    source = _base(
        "lae-source-packet-manifest/1.0.0", "source-manifest:synthetic-one",
        source_packet_id="source:synthetic-one",
        manifest_bytes=_binding("source-manifest.txt", "artifact:synthetic-source-manifest", "source-manifest"),
        state=base_state, state_version=base_state_version, state_transition=None,
        title="Synthetic source packet", creator="synthetic validator",
        publication_or_retrieval_date="2026-07-15", version_or_edition="fixture-v1",
        license_or_permission="test-only", components=[_ref(component)],
        canonical_order=[component["component_id"]],
        bounds={
            "temporal": "synthetic-only", "corpus": "one tainted marker", "jurisdictional": "not applicable",
            "version": "fixture-v1", "procedure": "none", "evidentiary": "schema tests only",
        },
        source_completeness={
            "intentionally_included": ["one tainted marker"],
            "intentionally_excluded": ["all real sources"],
            "finite_enough_basis": "single synthetic marker exercises closure",
        },
        effectful_procedures=[], transformation_records=[],
    )
    task_binding = _binding("task.txt", "artifact:synthetic-task", "task")
    rendering = _base(
        "lae-arm-rendering/1.0.0", "rendering:synthetic-nl",
        rendering_id="rendering:synthetic-nl", item_id="item:synthetic-one",
        item_task_sha256=task_binding["sha256"], source_packet=_ref(source), arm="NL",
        visible_bytes=_binding("rendering.txt", "artifact:synthetic-rendering", "visible-rendering"),
        prompt_template=_ref(component), wrapper_obligation=_ref(source),
        generated_by=FIXTURE_ACTOR, parity_leak_receipt=_ref(taint), state=base_state,
        state_version=base_state_version, state_transition=None,
    )
    ancestry = _base(
        "lae-ancestry-declaration/1.0.0", "ancestry:synthetic-one",
        subject_id="item:synthetic-one", subject_bytes_sha256=task_binding["sha256"],
        declaration_bytes=_binding("declaration.txt", "artifact:synthetic-ancestry", "declaration"),
        input_artifacts=[_ref(source)], read_event_digests=[], people=[FIXTURE_ACTOR],
        models_and_tools=["deterministic in-memory fixture builder"],
        repositories_templates_examples=["preauthorship synthetic fixture namespace"],
        transmission_event_digests=[], known_contamination=[_ref(taint)], declaration_standing="self-report",
    )
    exposure = _base(
        "lae-prior-exposure-declaration/1.0.0", "exposure:synthetic-one",
        subject_id="item:synthetic-one", subject_bytes_sha256=task_binding["sha256"],
        declaration_bytes=_binding("declaration.txt", "artifact:synthetic-exposure", "declaration"),
        exposures=[], declaration_standing="self-report", separation_status="not-certified",
        external_custodian_actor_id=None,
    )
    cleared = _base(
        "lae-exclusion-taint-record/1.0.0", "exclusion:synthetic-item-cleared-for-schema-only",
        subject_ids=["item:synthetic-one"], subject_sha256s=[task_binding["sha256"]],
        identity_bindings=[_binding("receipt.txt", "artifact:synthetic-exclusion-receipt", "receipt")],
        disposition="cleared", reason_class="no-listed-exclusion",
        semantic_derivatives_excluded=True, preserved_append_only=True, basis_event_digests=[],
    )
    lexical = _base(
        "lae-lexical-collision-receipt/1.0.0", "lexical:synthetic-one",
        candidate_id="item:synthetic-one", candidate_sha256=task_binding["sha256"],
        excluded_corpora=[_ref(taint)], algorithms=["exact-bytes", "normalized-ngram"],
        query_bytes=_binding("query.txt", "artifact:synthetic-lexical-query", "receipt"),
        matches=[], disposition="unknown", reviewer_actor_id=FIXTURE_ACTOR,
    )
    semantic = _base(
        "lae-semantic-overlap-receipt/1.0.0", "semantic:synthetic-one",
        candidate_id="item:synthetic-one", candidate_sha256=task_binding["sha256"],
        excluded_corpora=[_ref(taint)], methods=["blinded-human"],
        query_set_bytes=_binding("query.txt", "artifact:synthetic-semantic-query", "receipt"),
        threshold_rule="synthetic test: no admission decision", candidate_matches=[],
        decisions=["unknown"], disposition="unknown", reviewer_actor_id=FIXTURE_ACTOR,
        self_certified_non_overlap=False,
    )
    public_authority = _base(
        "lae-handoff-public-artifact/1.0.0", "handoff-public:synthetic-authority",
        handoff_artifact_kind="authority-identity",
        public_bytes=_binding("doctrine.txt", "artifact:synthetic-authority-identity", "authority"),
        represented_actor_id=FIXTURE_ACTOR,
        item_specific_content=False, freezer_only_content=False, mutable_bank_data=False,
    )
    item = _base(
        "lae-item-record/1.0.0", "item-record:synthetic-one",
        item_id="item:synthetic-one", family="bounded-support", task_bytes=task_binding,
        source_packet=_ref(source), renderings=[_ref(rendering)], transfer=False,
        sham_designated=False, commission_actor_ids=[FIXTURE_ACTOR], ancestry=_ref(ancestry),
        prior_exposure=_ref(exposure), exclusion_receipt=_ref(cleared),
        lexical_collision_receipt=_ref(lexical), semantic_overlap_receipt=_ref(semantic),
        freezer_decision=None, draft_state=base_state, state_version=base_state_version,
        state_transition=None,
    )
    records = [taint, component, source, rendering, ancestry, exposure, cleared, lexical, semantic, public_authority, item]
    if state in {"freezer-accepted", "frozen"}:
        _append_synthetic_transition(records, "freezer-accepted")
    if state == "frozen":
        _append_synthetic_transition(records, "frozen")
    return records


def _find_state(records, version, state):
    return next(record for record in records if record["schema_version"] == version and _state_of(record) == state)


def _append_synthetic_transition(records, resulting_state):
    predecessor_state = "candidate" if resulting_state == "freezer-accepted" else "freezer-accepted"
    predecessor_item = _find_state(records, "lae-item-record/1.0.0", predecessor_state)
    predecessor_source = _find_state(records, "lae-source-packet-manifest/1.0.0", predecessor_state)
    predecessor_rendering = _find_state(records, "lae-arm-rendering/1.0.0", predecessor_state)
    predecessor_component = _find_state(records, "lae-source-component/1.0.0", predecessor_state)
    authority = _find(records, "lae-handoff-public-artifact/1.0.0")
    dossier = next((record for record in records if record["schema_version"] == "lae-item-freezer-dossier/1.0.0"), None)
    if dossier is None:
        dossier = synthetic_private_records()[0]
        records.append(dossier)
    phase = "candidate-acceptance" if resulting_state == "freezer-accepted" else "final-freeze"
    next_version = predecessor_item["state_version"] + 1
    decision = _base(
        "lae-freezer-decision-record/1.0.0", f"freezer-decision:synthetic-{phase}",
        item=_ref(predecessor_item), dossier=_ref(dossier), decision_phase=phase,
        decision="accepted", resulting_state=resulting_state,
        reviewer_actor_id=FIXTURE_ACTOR, reviewer_authority=_ref(authority),
        rationale_bytes=_binding("receipt.txt", f"artifact:synthetic-{phase}-rationale", "receipt"),
        preserve_rejected_predecessor=True,
        supersedes_record_digest=None if resulting_state == "freezer-accepted" else next(
            record["record_digest"] for record in records
            if record["schema_version"] == "lae-freezer-decision-record/1.0.0" and record["resulting_state"] == "freezer-accepted"
        ),
    )
    transition = _base(
        "lae-state-transition-record/1.0.0", f"state-transition:synthetic-{phase}",
        predecessor_digest=decision["record_digest"],
        transition_id=f"state-transition:synthetic-{phase}",
        transition_kind=f"{predecessor_state}-to-{resulting_state}",
        predecessor_state=predecessor_state, resulting_state=resulting_state,
        predecessor_state_version=predecessor_item["state_version"], resulting_state_version=next_version,
        predecessor_item=_ref(predecessor_item), predecessor_source_manifest=_ref(predecessor_source),
        predecessor_renderings=[_ref(predecessor_rendering)], predecessor_source_components=[_ref(predecessor_component)],
        item_record_digest=predecessor_item["record_digest"], source_manifest_digest=predecessor_source["record_digest"],
        rendering_set_digest=_rendering_set_digest([predecessor_rendering]), freezer_decision=_ref(decision),
        freezer_actor_id=FIXTURE_ACTOR, freezer_authority=_ref(authority), transition_timestamp=FIXED_TEST_TIME,
        transition_receipt=_binding("receipt.txt", f"artifact:synthetic-{phase}-transition-receipt", "receipt"),
        receipt_kind=phase, predecessor_preserved=True,
    )
    transition_ref = _ref(transition)

    def successor(predecessor, suffix):
        value = copy.deepcopy(predecessor)
        value["record_id"] = f"{predecessor['record_id']}-{suffix}-v{next_version}"
        value["predecessor_digest"] = predecessor["record_digest"]
        value["parent_versions"] = [*predecessor.get("parent_versions", []), _ref(predecessor), transition_ref]
        value["state_version"] = next_version
        value["state_transition"] = transition_ref
        if "draft_state" in value:
            value["draft_state"] = resulting_state
        else:
            value["state"] = resulting_state
        return _reseal(value)

    component = successor(predecessor_component, resulting_state)
    source = successor(predecessor_source, resulting_state)
    source["components"] = [_ref(component)]
    source = _reseal(source)
    rendering = successor(predecessor_rendering, resulting_state)
    rendering["source_packet"] = _ref(source)
    rendering["prompt_template"] = _ref(component)
    rendering["wrapper_obligation"] = _ref(source)
    rendering = _reseal(rendering)
    item = successor(predecessor_item, resulting_state)
    item["source_packet"] = _ref(source)
    item["renderings"] = [_ref(rendering)]
    item["freezer_decision"] = _ref(decision)
    item = _reseal(item)
    records.extend([decision, transition, component, source, rendering, item])


def synthetic_private_records():
    records = synthetic_record_graph()
    item = records[-1]
    component = _find(records, "lae-source-component/1.0.0")
    ancestry = _find(records, "lae-ancestry-declaration/1.0.0")
    exposure = _find(records, "lae-prior-exposure-declaration/1.0.0")
    lexical = _find(records, "lae-lexical-collision-receipt/1.0.0")
    semantic = _find(records, "lae-semantic-overlap-receipt/1.0.0")
    dossier = _base(
        "lae-item-freezer-dossier/1.0.0", "dossier:synthetic-one",
        visibility="freezer-only", item_id=item["item_id"], item_task_sha256=item["task_bytes"]["sha256"],
        dossier_bytes=_binding("dossier.txt", "artifact:synthetic-dossier", "dossier"),
        proposed_role_memberships=["positive-conclusion", "closed-class-trap"],
        expected_answer_artifacts=[_binding("witness.txt", "artifact:synthetic-expected-answer", "witness")],
        proposed_opportunity_ids=["opportunity:synthetic-one"], proposed_trap_classes=["unsupported-assertion"],
        catchability_witness_ids=["witness:synthetic-one"],
        lawful_and_failing_examples=[
            _binding("witness.txt", "artifact:synthetic-lawful-example", "lawful-example"),
            _binding("witness.txt", "artifact:synthetic-failing-example", "failing-example"),
        ],
        ancestry_deliberation=_ref(ancestry), prior_exposure_deliberation=_ref(exposure),
        exclusion_and_overlap_deliberations=[_ref(lexical), _ref(semantic)], draft_state="candidate",
    )
    witness = _base(
        "lae-catchability-witness/1.0.0", "witness:synthetic-one",
        visibility="freezer-only", item_id=item["item_id"], item_task_sha256=item["task_bytes"]["sha256"],
        proposed_role="closed-class-trap",
        lawful_artifact_bytes=_binding("witness.txt", "artifact:synthetic-lawful-witness", "lawful-example"),
        failing_artifact_bytes=_binding("witness.txt", "artifact:synthetic-failing-witness", "failing-example"),
        witness_explanation_bytes=_binding("witness.txt", "artifact:synthetic-witness-explanation", "witness"),
        source_locators=component["locators"], proposed_scorable_opportunity_ids=["opportunity:synthetic-one"],
        created_before_any_target_exposure=True, permanent_taint_record=_ref(records[0]),
        dossier_id=dossier["record_id"],
    )
    decision = _base(
        "lae-freezer-decision-record/1.0.0", "freezer-decision:synthetic-returned",
        item=_ref(item), dossier=_ref(dossier), decision_phase="candidate-acceptance",
        decision="returned", resulting_state="candidate", reviewer_actor_id=FIXTURE_ACTOR,
        reviewer_authority=_ref(_find(records, "lae-handoff-public-artifact/1.0.0")),
        rationale_bytes=_binding("receipt.txt", "artifact:synthetic-freezer-rationale", "receipt"),
        preserve_rejected_predecessor=True, supersedes_record_digest=None,
    )
    return [dossier, witness, decision]


def synthetic_construct_capacity_records():
    records = synthetic_record_graph(state="frozen")
    item = _find_state(records, "lae-item-record/1.0.0", "frozen")
    source = _find_state(records, "lae-source-packet-manifest/1.0.0", "frozen")
    component = _find_state(records, "lae-source-component/1.0.0", "frozen")
    unit = _base(
        "lae-keyed-unit-record/1.0.0", "keyed-unit:synthetic-one",
        visibility="private-key-only-after-frozen-handoff", unit_id="unit:synthetic-one",
        item=_ref(item), parent_task_scope_bytes=item["task_bytes"], parent_unit=None,
        child_unit_ids=[], materiality="material", obligation_status="required",
        overlap_rule="disjoint", denominator_inclusion=True, source_packet=_ref(source), source_components=[_ref(component)],
        source_locators=component["locators"], coverage_relations=[],
        granularity_selection_status="owner-choice-deferred",
    )
    opportunity = _base(
        "lae-opportunity-record/1.0.0", "opportunity:synthetic-one",
        visibility="private-key-only-after-frozen-handoff", opportunity_id="opportunity:synthetic-one",
        item=_ref(item), source_packet=_ref(source), source_components=[_ref(component)], source_locators=component["locators"],
        original_task_scope_bytes=item["task_bytes"], keyed_unit=_ref(unit),
        answerability_class="supported",
        required_supported_conclusion_bytes=_binding("witness.txt", "artifact:synthetic-supported-conclusion", "witness"),
        lawful_uncertainty_bytes=_binding("declaration.txt", "artifact:synthetic-lawful-uncertainty", "declaration"),
        necessary_qualification_bytes=_binding("declaration.txt", "artifact:synthetic-necessary-qualification", "declaration"),
        allowed_alternative_dispositions=["supported-conclusion", "bounded-uncertainty"],
        not_applicable_justification=None, zero_opportunity_justification=None,
        parent_opportunity=None, hierarchical_scope="root-task",
        denominator_inclusion=True, declaring_key_author_actor_id=FIXTURE_ACTOR,
        independent_key_audit_or_freezer_receipt=_ref(records[0]),
    )
    measurement = {"status": "unadjudicated", "value": None, "evidence_records": []}
    profile = _base(
        "lae-future-score-profile-record/1.0.0", "score-profile:synthetic-capacity",
        implementation_status="schema-capacity-only-deferred", call_id="call:synthetic-capacity",
        item=_ref(item), key_version=_ref(records[0]), opportunity_records=[_ref(opportunity)],
        opportunity_set_declaration={"disposition": "declared-opportunities", "justification": None},
        structural_validity={"status": "unadjudicated", "validator_event_digest": None},
        substantive_discharge={
            "status": "unadjudicated", "discharged_opportunity_ids": [],
            "undischarged_opportunity_ids": [], "evidence_spans": [],
        },
        truncation_position={
            "provider_declared_truncation": False, "token_cap_termination": False,
            "apparent_self_truncation": False, "last_discharged_opportunity_id": None,
            "first_undischarged_material_opportunity_id": None, "evidence_spans": [],
            "source_bindings": [_ref(source)], "key_bindings": [_ref(opportunity)],
        },
        anti_taxidermy_profile={
            name: copy.deepcopy(measurement)
            for name in (
                "keyed_completeness", "key_conditioned_refusal", "unlawful_abstention", "utility",
                "truncation", "over_bounding", "procedural_substitution", "positive_conclusion_defect",
                "substantive_discharge_status", "scope_granularity_coverage",
            )
        },
        descriptive_composite=None, thresholds_selected=False,
    )
    riders = _base(
        "lae-future-branch-receipt-riders/1.0.0", "receipt-riders:synthetic-capacity",
        implementation_status="deferred-no-branch-receipt-created", branch="B-NOTATION",
        anti_taxidermy_profile_by_declared_stratum=True, key_declaration_dependency=True,
        key_conditioned_refusal_abstention_disclosure=True,
        no_aggregation_or_compensation_rider=True, named_harmed_dimension_and_stratum=None,
        pilot_scale_fixed_subject_ceiling=True,
        b_notation_all_gates_clear_against_scaffold="required-when-b-notation",
        thresholds_selected=False,
    )
    return [unit, opportunity, profile, riders]


def _event(event_id, event_type, actor_id, subject_id, action, event_time, predecessor, **fields):
    schema_version = fields.pop("schema_version", "lae-lineage-event/2.0.0")
    event = {
        "schema_version": schema_version,
        "event_id": event_id,
        "event_type": event_type,
        "actor_id": actor_id,
        "event_time": event_time,
        "predecessor_digest": predecessor,
        "causal_predecessor_digests": fields.pop("causal_predecessor_digests", []),
        "parent_artifact_digests": fields.pop("parent_artifact_digests", []),
        "basis_event_digests": fields.pop("basis_event_digests", []),
        "input_artifact_digests": fields.pop("input_artifact_digests", []),
        "bounded_unknowns": fields.pop("bounded_unknowns", []),
        "chronology_basis": fields.pop("chronology_basis", "observed"),
        "subject_id": subject_id,
        "action": action,
        "standing": fields.pop("standing", "observed"),
        "artifact_refs": fields.pop("artifact_refs", []),
        "claims": fields.pop("claims", []),
        "supersedes_event_digest": fields.pop("supersedes_event_digest", None),
        "rejection_preserved": fields.pop("rejection_preserved", False),
    }
    if schema_version == "lae-lineage-event/2.0.0":
        event.update({
            "sender_actor_id": fields.pop("sender_actor_id", None),
            "recipient_actor_id": fields.pop("recipient_actor_id", None),
            "authorization_basis_event_digest": fields.pop("authorization_basis_event_digest", None),
            "receipt_state": fields.pop("receipt_state", None),
            "owner_jurisdiction": fields.pop("owner_jurisdiction", None),
            "gate_closed": fields.pop("gate_closed", None),
            "decision_payload_digest": fields.pop("decision_payload_digest", None),
            "unresolved_predecessor_record_digest": fields.pop("unresolved_predecessor_record_digest", None),
        })
    event.update(fields)
    return seal_record(event)


def synthetic_lineage():
    events = []
    actor = _event("event:actor-synthetic", "actor", FIXTURE_ACTOR, FIXTURE_ACTOR, "declared", FIXED_TEST_TIME, None,
                   standing="declared", claims=[{"dimension": "role", "value": "synthetic-validator", "bound": "exact"}])
    events.append(actor)
    artifact_a = _event(
        "event:artifact-synthetic-a", "artifact", FIXTURE_ACTOR, "artifact:synthetic-a", "created",
        "2026-07-16T00:00:00-03:00", actor["record_digest"],
        claims=[
            {"dimension": "sha256", "value": _binding("source.txt", "artifact:synthetic-a", "source-component")["sha256"], "bound": "exact"},
            {"dimension": "byte-length", "value": _binding("source.txt", "artifact:synthetic-a", "source-component")["byte_length"], "bound": "exact"},
        ],
    )
    events.append(artifact_a)
    reference = {
        "artifact_id": "artifact:synthetic-a", "artifact_event_digest": artifact_a["record_digest"],
        "artifact_version": "fixture-v1", "byte_length": _binding("source.txt", "artifact:synthetic-a", "source-component")["byte_length"],
        "sha256": _binding("source.txt", "artifact:synthetic-a", "source-component")["sha256"],
    }
    read = _event(
        "event:read-synthetic-a", "read", FIXTURE_ACTOR, "read:synthetic-a", "read",
        "2026-07-16T00:00:01-03:00", artifact_a["record_digest"], artifact_refs=[reference],
        basis_event_digests=[artifact_a["record_digest"]], claims=[{"dimension": "scope", "value": "all", "bound": "exact"}],
    )
    events.append(read)
    artifact_b = _event(
        "event:artifact-synthetic-b", "artifact", FIXTURE_ACTOR, "artifact:synthetic-b", "created",
        "2026-07-16T00:00:02-03:00", read["record_digest"],
        input_artifact_digests=[artifact_a["record_digest"]], parent_artifact_digests=[artifact_a["record_digest"]],
        claims=[
            {"dimension": "sha256", "value": _binding("receipt.txt", "artifact:synthetic-b", "receipt")["sha256"], "bound": "exact"},
            {"dimension": "byte-length", "value": _binding("receipt.txt", "artifact:synthetic-b", "receipt")["byte_length"], "bound": "exact"},
        ],
    )
    events.append(artifact_b)
    rejection = _event(
        "event:rejection-synthetic", "rejection", FIXTURE_ACTOR, "draft:synthetic-rejected", "rejected",
        "2026-07-16T00:00:03-03:00", artifact_b["record_digest"], standing="rejected-preserved",
        claims=[{"dimension": "reason", "value": "synthetic preservation control", "bound": "exact"}],
    )
    events.append(rejection)
    successor = _event(
        "event:successor-synthetic", "successor", FIXTURE_ACTOR, "draft:synthetic-successor", "succeeded",
        "2026-07-16T00:00:04-03:00", rejection["record_digest"],
        causal_predecessor_digests=[rejection["record_digest"]], supersedes_event_digest=rejection["record_digest"],
        rejection_preserved=True, claims=[{"dimension": "predecessor-status", "value": "rejected-preserved", "bound": "exact"}],
    )
    events.append(successor)
    return events


def synthetic_owner_adoption_graph():
    events = []

    def add(event_id, event_type, actor_id, subject_id, action, **fields):
        event = _event(event_id, event_type, actor_id, subject_id, action, FIXED_TEST_TIME,
                       events[-1]["record_digest"] if events else None, **fields)
        events.append(event)
        return event

    owner = "actor:synthetic-owner"
    author = "actor:synthetic-item-author"
    auditor = "actor:synthetic-overlap-auditor"
    for actor_id, role in ((owner, "owner"), (author, "item-author"), (auditor, "overlap-auditor")):
        add(f"event:{actor_id.replace(':', '-')}", "actor", actor_id, actor_id, "declared",
            standing="declared", claims=[{"dimension": "role", "value": role, "bound": "exact"}])
    artifact = add(
        "event:artifact-synthetic-apparatus", "artifact", owner, "artifact:synthetic-apparatus", "created",
        claims=[
            {"dimension": "sha256", "value": _binding("source.txt", "artifact:synthetic-apparatus", "source-component")["sha256"], "bound": "exact"},
            {"dimension": "byte-length", "value": _binding("source.txt", "artifact:synthetic-apparatus", "source-component")["byte_length"], "bound": "exact"},
        ],
    )
    read = add(
        "event:read-synthetic-apparatus", "read", author, "read:synthetic-apparatus", "read",
        basis_event_digests=[artifact["record_digest"]], artifact_refs=[{
            "artifact_id": artifact["subject_id"], "artifact_event_digest": artifact["record_digest"],
            "artifact_version": "synthetic-v1",
            "byte_length": _binding("source.txt", "artifact:synthetic-apparatus", "source-component")["byte_length"],
            "sha256": _binding("source.txt", "artifact:synthetic-apparatus", "source-component")["sha256"],
        }], claims=[{"dimension": "scope", "value": "synthetic apparatus", "bound": "exact"}],
    )
    exposures = []
    for exposure_class in ("item-specific-answer", "private-key", "target-output"):
        exposures.append(add(
            f"event:exposure-{exposure_class}", "prior-exposure", author,
            f"exposure:{exposure_class}", "exposure-declared", standing="self-report",
            claims=[{"dimension": "exposure-class", "value": exposure_class, "bound": "declared"}],
        ))
    shared_root = add(
        "event:ancestry-synthetic-shared-root", "ancestry", owner,
        "ancestry:synthetic-shared-root", "ancestry-declared", standing="declared",
        claims=[{"dimension": "shared-root", "value": "synthetic commission", "bound": "exact"}],
    )
    odr43_decision = {
        "decision_kind": "item-author-identities", "owner_actor_id": owner,
        "item_author_actor_ids": [author],
        "content_family_assignments": [{"actor_id": author, "content_families": ["BOUNDED-SUPPORT", "SCOPE-AND-VERSION", "CONFLICT-AND-RESIDUE", "NOTATION-NEUTRAL-TRANSFER"]}],
        "cross_review_relationships": [{"reviewer_actor_id": auditor, "reviewed_actor_ids": [author]}],
        "freezer_overlap_auditor_actor_id": auditor,
        "apparatus_read_event_digests": [read["record_digest"]],
        "exposure_declarations": [
            {"exposure_class": exposure_class, "actor_id": author, "exposure_event_digest": event["record_digest"]}
            for exposure_class, event in zip(("item-specific-answer", "private-key", "target-output"), exposures)
        ],
        "shared_root_event_digests": [shared_root["record_digest"]],
        "blindness_claims": ["synthetic graph-only claim"],
        "independence_claims": ["no real independence claimed"],
        "claims_explicitly_not_made": ["no real actor independence"],
        "role_specific_restrictions": [
            {"actor_id": author, "role": "item-author", "restrictions": ["no private-key access"]},
            {"actor_id": auditor, "role": "overlap-auditor", "restrictions": ["no substantive authorship"]},
        ],
    }
    unresolved = {record["decision_id"]: record for record in load_owner_records()}
    decisions = {"ODR-43": odr43_decision, "ODR-60": odr60_candidate_record()["allocation"]}
    adopted = []
    for decision_id in ("ODR-43", "ODR-60"):
        predecessor = unresolved[decision_id]
        gate = predecessor["exact_executable_gate"]
        decision = decisions[decision_id]
        adoption_event = add(
            f"event:owner-adoption-{decision_id.lower()}", "owner-adoption", owner,
            f"owner-adoption:{decision_id}-synthetic", "adopted", standing="declared",
            owner_jurisdiction="Language-A pilot owner commission",
            gate_closed=gate,
            decision_payload_digest="sha256:" + sha256_bytes(canonical_json_bytes(decision)),
            unresolved_predecessor_record_digest=predecessor["record_digest"],
            claims=[{"dimension": "synthetic-only", "value": True, "bound": "exact"}],
        )
        successor = copy.deepcopy(predecessor)
        successor.update({
            "record_id": f"owner-decision:{decision_id}-adopted-synthetic-v2",
            "actor_id": owner, "event_time": FIXED_TEST_TIME,
            "predecessor_digest": predecessor["record_digest"],
            "parent_versions": [_ref(predecessor)], "synthetic_taint_id": FIXTURE_TAINT_ID,
            "status": "adopted", "exact_decision": decision,
            "rationale": "synthetic adoption graph exercises closure only",
            "deciding_actor": owner,
            "role_shared_root_disclosure": {"roles": [decision_id], "shared_roots": [shared_root["event_id"]], "bounded_unknowns": ["synthetic"]},
            "adoption_timestamp": FIXED_TEST_TIME,
            "unresolved_predecessor": _ref(predecessor),
            "adoption_event_digest": adoption_event["record_digest"],
            "owner_jurisdiction": "Language-A pilot owner commission",
            "exact_gate_closed": gate,
        })
        adopted.append(_reseal(successor))
    return [*unresolved.values(), *adopted], events


def synthetic_transmission_lineage(pending_receipt=False):
    events = []

    def add(event_id, event_type, actor_id, subject_id, action, **fields):
        event = _event(event_id, event_type, actor_id, subject_id, action, FIXED_TEST_TIME,
                       events[-1]["record_digest"] if events else None, **fields)
        events.append(event)
        return event

    sender = "actor:synthetic-sender"
    recipient = "actor:synthetic-recipient"
    for actor_id in (sender, recipient):
        add(f"event:{actor_id.replace(':', '-')}", "actor", actor_id, actor_id, "declared",
            standing="declared", claims=[{"dimension": "role", "value": actor_id, "bound": "exact"}])
    binding = _binding("source.txt", "artifact:synthetic-transmitted", "source-component")
    artifact = add(
        "event:artifact-synthetic-transmitted", "artifact", sender,
        "artifact:synthetic-transmitted", "created",
        claims=[
            {"dimension": "sha256", "value": binding["sha256"], "bound": "exact"},
            {"dimension": "byte-length", "value": binding["byte_length"], "bound": "exact"},
        ],
    )
    reference = {
        "artifact_id": artifact["subject_id"], "artifact_event_digest": artifact["record_digest"],
        "artifact_version": "synthetic-v1", "byte_length": binding["byte_length"], "sha256": binding["sha256"],
    }
    read = add(
        "event:read-synthetic-transmitted", "read", sender, "read:synthetic-transmitted", "read",
        artifact_refs=[reference], basis_event_digests=[artifact["record_digest"]],
        claims=[{"dimension": "scope", "value": "all", "bound": "exact"}],
    )
    authorization = add(
        "event:authorization-synthetic-transmission", "authorization", sender,
        "authorization:synthetic-transmission", "authorized", basis_event_digests=[read["record_digest"]],
        claims=[{"dimension": "authorization", "value": "synthetic handoff", "bound": "exact"}],
    )
    receipt_state = {"status": "pending-receipt", "pending_reason": "synthetic pending-state control"}
    if not pending_receipt:
        acknowledgment = add(
            "event:acknowledgment-synthetic-transmission", "acknowledgment", recipient,
            "acknowledgment:synthetic-transmission", "acknowledged", basis_event_digests=[authorization["record_digest"]],
            claims=[{"dimension": "receipt", "value": "synthetic", "bound": "exact"}],
        )
        receipt_state = {"status": "acknowledged", "receipt_event_digest": acknowledgment["record_digest"]}
    add(
        "event:transmission-synthetic", "transmission", sender,
        "transmission:synthetic", "transmitted", artifact_refs=[reference],
        basis_event_digests=[read["record_digest"], authorization["record_digest"]],
        input_artifact_digests=[artifact["record_digest"]], parent_artifact_digests=[artifact["record_digest"]],
        sender_actor_id=sender, recipient_actor_id=recipient,
        authorization_basis_event_digest=authorization["record_digest"], receipt_state=receipt_state,
        claims=[{"dimension": "artifact-count", "value": 1, "bound": "exact"}],
    )
    return events


def load_owner_records():
    return [strict_json_load(OWNER_RECORD_DIR / name) for name in ("ODR-43.json", "ODR-60.json")]


def load_odr60_candidate():
    return strict_json_load(OWNER_RECORD_DIR / "ODR-60-CANDIDATE-ALLOCATION-0.2.json")


def load_successor_lineage():
    return strict_jsonl_load(SUCCESSOR_LINEAGE_PATH)


def validate_construct_specimen_registry():
    specimens = strict_jsonl_load(PACKET_ROOT / "preauthorship/registries/construct-validity-specimens.jsonl")
    taints = strict_jsonl_load(PACKET_ROOT / "preauthorship/registries/permanent-taint.jsonl")
    expected = {f"TXD-{number:02d}" for number in range(1, 11)}
    if {record.get("specimen_id") for record in specimens} != expected or len(specimens) != 10:
        raise TaintedAncestry("construct-validity specimen identity inventory")
    predecessor = None
    for record in specimens:
        validate_record(record, "construct-validity-specimen-record")
        if record["predecessor_digest"] != predecessor:
            raise PredecessorDigestMismatch(record["specimen_id"])
        if record["permanent_taint_id"] != CONSTRUCT_SPECIMEN_TAINT_ID or record["full_behavior_implemented"] is not False:
            raise TaintedAncestry(record["specimen_id"])
        predecessor = record["record_digest"]
    taint = next((record for record in taints if record["record_id"] == CONSTRUCT_SPECIMEN_TAINT_ID), None)
    if taint is None or taint["disposition"] != "permanently-tainted" or not taint["semantic_derivatives_excluded"]:
        raise TaintedAncestry(CONSTRUCT_SPECIMEN_TAINT_ID)
    validate_record(taint, "exclusion-taint-record")
    return specimens


def _find(records, version):
    return next(record for record in records if record["schema_version"] == version)


def _reseal(record):
    record.pop("record_digest", None)
    record.pop("canonical_byte_length", None)
    return seal_record(record)


def _mutation_handlers():
    def malformed_item():
        record = copy.deepcopy(_find(synthetic_record_graph(), "lae-item-record/1.0.0")); record.pop("family"); validate_record(_reseal(record))

    def malformed_source():
        record = copy.deepcopy(_find(synthetic_record_graph(), "lae-source-packet-manifest/1.0.0")); record["unexpected"] = True; validate_record(_reseal(record))

    def dangling_component():
        records = synthetic_record_graph(); source = _find(records, "lae-source-packet-manifest/1.0.0"); source["components"][0]["record_id"] = "component:missing"; records[2] = _reseal(source); validate_record_graph(records, allow_synthetic=True)

    def wrong_source_version():
        records = synthetic_record_graph(); item = _find(records, "lae-item-record/1.0.0"); item["source_packet"]["schema_version"] = "lae-source-packet-manifest/9.9.9"; records[-1] = _reseal(item); validate_record_graph(records, allow_synthetic=True)

    def duplicate_item():
        records = synthetic_record_graph(); other = copy.deepcopy(records[-1]); other["record_id"] = "item-record:synthetic-two"; other = _reseal(other); validate_record_graph(records + [other], allow_synthetic=True)

    def stale_parent():
        records = synthetic_record_graph(); item = records[-1]; item["parent_versions"] = [_ref(records[2])]; item["parent_versions"][0]["record_digest"] = "sha256:" + "0" * 64; records[-1] = _reseal(item); validate_record_graph(records, allow_synthetic=True)

    def rewritten_predecessor():
        events = synthetic_lineage(); events[2]["predecessor_digest"] = "sha256:" + "0" * 64; events[2] = _reseal(events[2]); validate_lineage(events)

    def missing_actor():
        events = synthetic_lineage(); events[1]["actor_id"] = "actor:missing"; events[1] = _reseal(events[1]); validate_lineage(events)

    def unlogged_read():
        events = synthetic_lineage(); read = events.pop(2); events[2]["predecessor_digest"] = events[1]["record_digest"]; events[2] = _reseal(events[2]); events[3]["predecessor_digest"] = events[2]["record_digest"]; events[3] = _reseal(events[3]); events[4]["predecessor_digest"] = events[3]["record_digest"]; events[4]["causal_predecessor_digests"] = [events[3]["record_digest"]]; events[4]["supersedes_event_digest"] = events[3]["record_digest"]; events[4] = _reseal(events[4]); validate_lineage(events)

    def chronology_inversion():
        events = synthetic_lineage(); events[2]["event_time"] = "2026-07-15T23:59:59-03:00"; events[2] = _reseal(events[2]); validate_lineage(events)

    def leak(field, value):
        record = copy.deepcopy(_find(synthetic_record_graph(), "lae-item-record/1.0.0")); record[field] = value; validate_record(_reseal(record))

    def tainted_admission(reason="synthetic-mutation"):
        records = synthetic_record_graph(); taint = records[0]; taint["reason_class"] = reason; records[0] = _reseal(taint); validate_record_graph(records, allow_synthetic=False)

    def key_leak(field, value):
        records = synthetic_frozen_bank_records(); manifest = synthetic_key_manifest(records); manifest[field] = value; manifest = _reseal(manifest); validate_key_author_input(manifest, records, allow_synthetic=True)

    def key_bad_kind(kind):
        records = synthetic_frozen_bank_records(); manifest = synthetic_key_manifest(records); manifest["entries"][0]["artifact_kind"] = kind; manifest = _reseal(manifest); validate_key_author_input(manifest, records, allow_synthetic=True)

    def key_kind_spoof():
        records = synthetic_frozen_bank_records(); manifest = synthetic_key_manifest(records)
        manifest["entries"][0]["artifact_kind"] = "controlling-scoring-doctrine"
        manifest = _reseal(manifest)
        validate_key_author_input(manifest, records, allow_synthetic=True)

    def odr_status_only():
        record = copy.deepcopy(load_owner_records()[0]); record["status"] = "adopted"; record = _reseal(record); validate_owner_records([record, load_owner_records()[1]])

    def odr_boolean_only():
        records = load_owner_records(); record = copy.deepcopy(records[1]); record["complete"] = True; record = _reseal(record); validate_owner_records([records[0], record])

    def draft_as_frozen():
        validate_consumption(_find(synthetic_record_graph(), "lae-item-record/1.0.0"), "runner")

    def consume_draft(consumer):
        validate_consumption(_find(synthetic_record_graph(), "lae-item-record/1.0.0"), consumer)

    def moving_bank_handoff():
        records = synthetic_frozen_bank_records()
        candidate = _find_state(records, "lae-item-record/1.0.0", "candidate")
        bank_index = next(index for index, record in enumerate(records) if record["schema_version"] == "lae-frozen-bank-manifest/1.0.0")
        bank = copy.deepcopy(records[bank_index]); bank["items"] = [_ref(candidate)]
        required = {
            "frozen-item": bank["items"], "frozen-rendering": bank["required_renderings"],
            "source-packet-manifest": bank["required_source_manifests"], "source-component": bank["required_source_components"],
            "controlling-scoring-doctrine": bank["controlling_scoring_doctrine"], "authority-identity": bank["authority_identities"],
            "neutral-custody-receipt": [bank["neutral_custody_receipt"]],
        }
        bank["authorized_set_digest"] = "sha256:" + sha256_bytes(canonical_json_bytes(sorted(
            (kind, ref["record_id"], ref["record_digest"]) for kind, refs in required.items() for ref in refs
        )))
        bank = _reseal(bank); records[bank_index] = bank
        manifest = synthetic_key_manifest(records)
        item_entry = next(entry for entry in manifest["entries"] if entry["artifact_kind"] == "frozen-item")
        item_entry["record"] = _ref(candidate); item_entry["bytes"] = copy.deepcopy(candidate["task_bytes"])
        manifest["frozen_bank_manifest"] = _ref(bank)
        manifest["item_bank_digest"] = "sha256:" + sha256_bytes(canonical_json_bytes([candidate["record_digest"]]))
        manifest = _reseal(manifest)
        validate_key_author_input(manifest, records, allow_synthetic=True)

    def illicit_state_promotion():
        records = synthetic_record_graph(state="candidate")
        item = records[-1]
        item["draft_state"] = "frozen"
        item = _reseal(item)
        item["synthetic_taint_id"] = None
        item = _reseal(item)
        validate_tranche_state(item, allow_synthetic=False)

    def zero_opportunity_without_justification():
        record = copy.deepcopy(_find(synthetic_construct_capacity_records(), "lae-opportunity-record/1.0.0"))
        record["answerability_class"] = "zero-opportunity"
        record["denominator_inclusion"] = False
        record["required_supported_conclusion_bytes"] = None
        record["zero_opportunity_justification"] = None
        validate_record(_reseal(record))

    def absent_opportunity_perfect_default():
        record = copy.deepcopy(_find(synthetic_construct_capacity_records(), "lae-future-score-profile-record/1.0.0"))
        record["opportunity_records"] = []
        record["substantive_discharge"]["status"] = "complete"
        validate_record(_reseal(record))

    def scalar_profile_gate():
        record = copy.deepcopy(_find(synthetic_construct_capacity_records(), "lae-future-score-profile-record/1.0.0"))
        record["descriptive_composite"] = {
            "descriptive_only": True, "gating": True,
            "all_components_displayed": True, "value": 0,
        }
        validate_record(_reseal(record))

    def collapse_validity_axes():
        record = copy.deepcopy(_find(synthetic_construct_capacity_records(), "lae-future-score-profile-record/1.0.0"))
        record.pop("substantive_discharge")
        validate_record(_reseal(record))

    def rejected_overwritten():
        events = synthetic_lineage(); rejected = events[4]; rejected["action"] = "succeeded"; rejected["event_type"] = "successor"; rejected["standing"] = "observed"; events[4] = _reseal(rejected); validate_lineage(events)

    def filename_identity():
        record = copy.deepcopy(_find(synthetic_record_graph(), "lae-item-record/1.0.0")); record["item_id"] = "item:task.txt"; validate_record(_reseal(record))

    def absent_source():
        record = copy.deepcopy(_find(synthetic_record_graph(), "lae-source-component/1.0.0")); record["component_bytes"]["storage_path"] = "controls/preauthorship-synthetic-fixtures/absent.bin"; validate_record(_reseal(record))

    def mutate_odr60(mutator):
        record = copy.deepcopy(odr60_candidate_record())
        mutator(record["allocation"])
        validate_odr60_candidate(_reseal(record))

    def old_odr60_algebra():
        validate_odr60_allocation({"decision_kind": "role-allocation-policy", "family_allocations": []})

    def owner_successor(decision_id):
        records, events = synthetic_owner_adoption_graph()
        return records, events, next(record for record in records if record["decision_id"] == decision_id and record["status"] == "adopted")

    def owner_reused_id():
        records, events, successor = owner_successor("ODR-43"); successor["record_id"] = "owner-decision:ODR-43-unresolved-v1"; validate_owner_records([_reseal(record) if record is successor else record for record in records], lineage_events=events)

    def owner_stale_predecessor():
        records, events, successor = owner_successor("ODR-43"); successor["predecessor_digest"] = "sha256:" + "0" * 64; validate_owner_records([_reseal(record) if record is successor else record for record in records], lineage_events=events)

    def owner_missing_predecessor():
        records, events, _ = owner_successor("ODR-43"); records = [record for record in records if not (record["decision_id"] == "ODR-43" and record["status"] == "unresolved")]; validate_owner_records(records, lineage_events=events)

    def owner_missing_event():
        records, events, successor = owner_successor("ODR-43"); events = [event for event in events if event["record_digest"] != successor["adoption_event_digest"]]; validate_owner_records(records, lineage_events=events)

    def mutate_odr43_payload(mutator):
        records, events, successor = owner_successor("ODR-43")
        mutator(successor["exact_decision"])
        event_index = next(index for index, event in enumerate(events) if event["record_digest"] == successor["adoption_event_digest"])
        event = events[event_index]
        event["decision_payload_digest"] = "sha256:" + sha256_bytes(canonical_json_bytes(successor["exact_decision"]))
        events[event_index] = _reseal(event)
        successor["adoption_event_digest"] = events[event_index]["record_digest"]
        successor = _reseal(successor)
        records = [successor if record["decision_id"] == "ODR-43" and record["status"] == "adopted" else record for record in records]
        validate_owner_records(records, lineage_events=events)

    def terminal_item(state):
        records = synthetic_record_graph(state=state)
        return records, _find_state(records, "lae-item-record/1.0.0", state)

    def null_freezer_decision(state):
        _, item = terminal_item(state); item["freezer_decision"] = None; validate_record(_reseal(item))

    def missing_transition(state):
        _, item = terminal_item(state); item["state_transition"] = None; validate_record(_reseal(item))

    def transition_semantic(state, mutator):
        records = synthetic_record_graph(state=state)
        item = _find_state(records, "lae-item-record/1.0.0", state)
        transition = next(record for record in records if record["record_digest"] == item["state_transition"]["record_digest"])
        mutator(transition)
        validate_state_transition_graph(records, _reference_index(records))

    def key_omit(kind):
        records = synthetic_frozen_bank_records(); manifest = synthetic_key_manifest(records)
        manifest["entries"] = [entry for entry in manifest["entries"] if entry["artifact_kind"] != kind]
        manifest["delivered_entry_cardinality"] = len(manifest["entries"])
        validate_key_author_input(_reseal(manifest), records, allow_synthetic=True)

    def key_duplicate_entry():
        records = synthetic_frozen_bank_records(); manifest = synthetic_key_manifest(records)
        manifest["entries"].append(copy.deepcopy(manifest["entries"][0])); manifest["delivered_entry_cardinality"] += 1
        validate_key_author_input(_reseal(manifest), records, allow_synthetic=True)

    def key_wrong_cardinality():
        records = synthetic_frozen_bank_records(); manifest = synthetic_key_manifest(records); manifest["delivered_bank_cardinality"] = 2
        validate_key_author_input(_reseal(manifest), records, allow_synthetic=True)

    def key_extra_member(kind="frozen-item"):
        records = synthetic_frozen_bank_records(); manifest = synthetic_key_manifest(records)
        entry = copy.deepcopy(next(entry for entry in manifest["entries"] if entry["artifact_kind"] == kind))
        entry["record"]["record_id"] = "item-record:synthetic-extra" if kind == "frozen-item" else "component:synthetic-extra"
        manifest["entries"].append(entry); manifest["delivered_entry_cardinality"] += 1
        validate_key_author_input(_reseal(manifest), records, allow_synthetic=True)

    def key_stale_version(kind, schema_version, state):
        records = synthetic_frozen_bank_records(); manifest = synthetic_key_manifest(records)
        stale = _find_state(records, schema_version, state)
        entry = next(entry for entry in manifest["entries"] if entry["artifact_kind"] == kind)
        entry["record"] = _ref(stale)
        validate_key_author_input(_reseal(manifest), records, allow_synthetic=True)

    def mutate_transmission(mutator):
        events = synthetic_transmission_lineage(); transmission = events[-1]; mutator(transmission); events[-1] = _reseal(transmission); validate_lineage(events)

    def correction_without_supersedes():
        events = synthetic_lineage(); target = events[-2]
        correction = _event(
            "event:correction-synthetic-missing-supersedes", "correction", FIXTURE_ACTOR,
            "correction:synthetic-missing-supersedes", "corrected", "2026-07-16T00:00:05-03:00",
            events[-1]["record_digest"], causal_predecessor_digests=[target["record_digest"]],
            supersedes_event_digest=target["record_digest"], rejection_preserved=True,
            claims=[{"dimension": "correction", "value": "synthetic", "bound": "exact"}],
        )
        correction["supersedes_event_digest"] = None
        events.append(_reseal(correction)); validate_lineage(events)

    def empty_collection(version, field):
        record = copy.deepcopy(_find(synthetic_record_graph(), version)); record[field] = []; validate_record(_reseal(record))

    def golden_byte_changed():
        data = (PACKET_ROOT / "controls/canonicalization-golden/minimal-record.material.json").read_bytes()
        validate_canonical_golden_vector(data.replace(b"canonical-golden", b"canonical-goldfn", 1))

    return {
        "malformed-item-record": malformed_item,
        "malformed-source-manifest": malformed_source,
        "dangling-source-component": dangling_component,
        "wrong-source-version": wrong_source_version,
        "duplicate-item-id": duplicate_item,
        "stale-parent-digest": stale_parent,
        "rewritten-predecessor": rewritten_predecessor,
        "missing-actor": missing_actor,
        "unlogged-read": unlogged_read,
        "chronology-inversion": chronology_inversion,
        "leaked-expected-answer": lambda: leak("expected_answer", "synthetic forbidden"),
        "leaked-trap-class": lambda: leak("trap_class", "unsupported-assertion"),
        "leaked-scorable-opportunity": lambda: leak("scorable_opportunities", ["synthetic"]),
        "leaked-catchability-witness": lambda: leak("witness", "synthetic forbidden"),
        "leaked-private-role-label": lambda: leak("positive_conclusion_role", True),
        "tainted-source-admitted": tainted_admission,
        "excluded-fixture-derivative-admitted": lambda: tainted_admission("public-fixture"),
        "key-input-freezer-only-data": lambda: key_leak("expected_answers", ["synthetic forbidden"]),
        "key-input-role-label": lambda: key_leak("role_labels", ["positive-conclusion"]),
        "key-input-proposed-opportunity": lambda: key_leak("proposed_opportunity_ids", ["synthetic"]),
        "key-input-trap-label": lambda: key_leak("trap_labels", ["unsupported-assertion"]),
        "key-input-witness": lambda: key_leak("catchability_witnesses", ["witness:synthetic"]),
        "key-input-synthetic-outcome": lambda: key_bad_kind("synthetic-outcome"),
        "key-input-schedule": lambda: key_bad_kind("schedule"),
        "key-input-grader-material": lambda: key_bad_kind("grader-material"),
        "key-input-freezer-dossier": lambda: key_bad_kind("item-freezer-dossier"),
        "key-input-lawful-example": lambda: key_bad_kind("lawful-example"),
        "key-input-failing-example": lambda: key_bad_kind("failing-example"),
        "key-input-kind-spoofs-public-doctrine": key_kind_spoof,
        "odr-43-status-string-only": odr_status_only,
        "odr-60-boolean-only": odr_boolean_only,
        "draft-item-used-as-frozen": draft_as_frozen,
        "draft-item-used-by-schedule": lambda: consume_draft("schedule"),
        "draft-item-used-by-scoring-key": lambda: consume_draft("scoring-key"),
        "draft-item-used-by-exposure-manifest": lambda: consume_draft("exposure-manifest"),
        "moving-bank-key-handoff": moving_bank_handoff,
        "status-string-promotes-draft-to-frozen": illicit_state_promotion,
        "zero-opportunity-without-justification": zero_opportunity_without_justification,
        "absent-opportunity-defaults-perfect-completeness": absent_opportunity_perfect_default,
        "aggregate-anti-taxidermy-gate": scalar_profile_gate,
        "structural-validity-overwrites-substantive-discharge": collapse_validity_axes,
        "construct-specimen-crosses-key-boundary": lambda: key_bad_kind("construct-validity-specimen"),
        "rejected-draft-overwritten": rejected_overwritten,
        "mutable-filename-identity": filename_identity,
        "absent-source-component-bytes": absent_source,
        "odr-60-multiple-answerability-roles": lambda: mutate_odr60(lambda value: value["item_rows"][0].update(answerability_role=["POSITIVE-CONCLUSION", "DELIBERATE-INSUFFICIENCY"])),
        "odr-60-positive-and-insufficiency-same-item": lambda: mutate_odr60(lambda value: value["item_rows"][1].update(answerability_role=["POSITIVE-CONCLUSION", "DELIBERATE-INSUFFICIENCY"])),
        "odr-60-absent-mixed-role": lambda: mutate_odr60(lambda value: [row.update(answerability_role="POSITIVE-CONCLUSION") for row in value["item_rows"] if row["answerability_role"] == "MIXED-BOUNDED-CONTROL"]),
        "odr-60-missing-sham-pair": lambda: mutate_odr60(lambda value: value["item_rows"][0]["tags"].remove("SHAM-DESIGNATED")),
        "odr-60-missing-domain-native-family": lambda: mutate_odr60(lambda value: [row["tags"].remove("DOMAIN-NATIVE-NON-LANG-A-RENDERABLE") for row in value["item_rows"] if row["content_family"] == "BOUNDED-SUPPORT" and "DOMAIN-NATIVE-NON-LANG-A-RENDERABLE" in row["tags"]]),
        "odr-60-strong-control-non-positive": lambda: mutate_odr60(lambda value: value["item_rows"][2]["tags"].append("STRONG-CONCLUSION-CONTROL")),
        "odr-60-duplicate-slot": lambda: mutate_odr60(lambda value: value["item_rows"][1].update(slot_id=value["item_rows"][0]["slot_id"])),
        "odr-60-stale-aggregate-witness": old_odr60_algebra,
        "odr-60-stored-derived-total": lambda: mutate_odr60(lambda value: value.update(derived_total=24)),
        "owner-adoption-reuses-unresolved-id": owner_reused_id,
        "owner-adoption-stale-predecessor-digest": owner_stale_predecessor,
        "owner-adoption-missing-preserved-predecessor": owner_missing_predecessor,
        "owner-adoption-without-lineage-event": owner_missing_event,
        "odr-43-dangling-actor-reference": lambda: mutate_odr43_payload(lambda value: value["item_author_actor_ids"].append("actor:missing")),
        "odr-43-dangling-apparatus-read": lambda: mutate_odr43_payload(lambda value: value["apparatus_read_event_digests"].append("sha256:" + "0" * 64)),
        "odr-43-dangling-exposure-reference": lambda: mutate_odr43_payload(lambda value: value["exposure_declarations"][0].update(exposure_event_digest="sha256:" + "0" * 64)),
        "freezer-accepted-null-freezer-decision": lambda: null_freezer_decision("freezer-accepted"),
        "frozen-null-freezer-decision": lambda: null_freezer_decision("frozen"),
        "frozen-stale-candidate-digest": lambda: transition_semantic("frozen", lambda value: value.update(item_record_digest="sha256:" + "0" * 64)),
        "frozen-without-transition-event": lambda: missing_transition("frozen"),
        "frozen-unauthorized-freezer-actor": lambda: transition_semantic("frozen", lambda value: value.update(freezer_actor_id="actor:missing")),
        "synthetic-freezer-accepted-null-decision": lambda: null_freezer_decision("freezer-accepted"),
        "synthetic-frozen-missing-transition": lambda: missing_transition("frozen"),
        "synthetic-frozen-unresolved-freezer-actor": lambda: transition_semantic("frozen", lambda value: value.update(freezer_actor_id="actor:missing")),
        "partial-key-author-input": lambda: key_omit("neutral-custody-receipt"),
        "key-input-missing-item": lambda: key_omit("frozen-item"),
        "key-input-missing-rendering": lambda: key_omit("frozen-rendering"),
        "key-input-missing-source-manifest": lambda: key_omit("source-packet-manifest"),
        "key-input-missing-exact-source-bytes": lambda: key_omit("source-component"),
        "key-input-missing-doctrine": lambda: key_omit("controlling-scoring-doctrine"),
        "key-input-missing-authority-identity": lambda: key_omit("authority-identity"),
        "key-input-missing-neutral-custody-receipt": lambda: key_omit("neutral-custody-receipt"),
        "key-input-duplicate-entry": key_duplicate_entry,
        "key-input-wrong-cardinality": key_wrong_cardinality,
        "key-input-extra-bank-member": key_extra_member,
        "key-input-extra-source-component": lambda: key_extra_member("source-component"),
        "key-input-stale-item-version": lambda: key_stale_version("frozen-item", "lae-item-record/1.0.0", "candidate"),
        "key-input-stale-rendering-version": lambda: key_stale_version("frozen-rendering", "lae-arm-rendering/1.0.0", "candidate"),
        "key-input-stale-source-version": lambda: key_stale_version("source-packet-manifest", "lae-source-packet-manifest/1.0.0", "candidate"),
        "empty-transmission-event": lambda: mutate_transmission(lambda value: value.update(artifact_refs=[], basis_event_digests=[], claims=[], input_artifact_digests=[], parent_artifact_digests=[])),
        "transmission-without-sender-or-recipient": lambda: mutate_transmission(lambda value: value.update(sender_actor_id=None, recipient_actor_id=None)),
        "transmission-without-byte-identity": lambda: mutate_transmission(lambda value: value["artifact_refs"][0].pop("sha256")),
        "transmission-without-receipt-state": lambda: mutate_transmission(lambda value: value.update(receipt_state=None)),
        "transmission-without-prior-read": lambda: mutate_transmission(lambda value: value.update(basis_event_digests=[value["authorization_basis_event_digest"]])),
        "correction-without-exact-supersedes": correction_without_supersedes,
        "empty-item-rendering-set": lambda: empty_collection("lae-item-record/1.0.0", "renderings"),
        "empty-taint-identity-bindings": lambda: empty_collection("lae-exclusion-taint-record/1.0.0", "identity_bindings"),
        "empty-taint-subject-sha256s": lambda: empty_collection("lae-exclusion-taint-record/1.0.0", "subject_sha256s"),
        "canonical-golden-vector-altered-byte": golden_byte_changed,
        "mutation:pv-01-witness": old_odr60_algebra,
        "mutation:pv-02-witness": odr_status_only,
        "mutation:pv-03-witness": illicit_state_promotion,
        "mutation:pv-04-witness": lambda: key_omit("frozen-rendering"),
        "mutation:pv-05-witness": lambda: mutate_transmission(lambda value: value.update(artifact_refs=[], basis_event_digests=[], claims=[], input_artifact_digests=[], parent_artifact_digests=[])),
    }


def synthetic_frozen_bank_records():
    records = synthetic_record_graph(state="frozen")
    item = _find_state(records, "lae-item-record/1.0.0", "frozen")
    rendering = _find_state(records, "lae-arm-rendering/1.0.0", "frozen")
    source = _find_state(records, "lae-source-packet-manifest/1.0.0", "frozen")
    component = _find_state(records, "lae-source-component/1.0.0", "frozen")
    authority = _find(records, "lae-handoff-public-artifact/1.0.0")
    doctrine = _base(
        "lae-handoff-public-artifact/1.0.0", "handoff-public:synthetic-doctrine",
        handoff_artifact_kind="controlling-scoring-doctrine", represented_actor_id=None,
        public_bytes=_binding("doctrine.txt", "artifact:synthetic-controlling-doctrine", "doctrine"),
        item_specific_content=False, freezer_only_content=False, mutable_bank_data=False,
    )
    receipt = _base(
        "lae-handoff-public-artifact/1.0.0", "handoff-public:synthetic-custody-receipt",
        handoff_artifact_kind="neutral-custody-receipt", represented_actor_id=None,
        public_bytes=_binding("receipt.txt", "artifact:synthetic-neutral-custody", "custody"),
        item_specific_content=False, freezer_only_content=False, mutable_bank_data=False,
    )
    required = {
        "frozen-item": [item], "frozen-rendering": [rendering],
        "source-packet-manifest": [source], "source-component": [component],
        "controlling-scoring-doctrine": [doctrine], "authority-identity": [authority],
        "neutral-custody-receipt": [receipt],
    }
    authorized_entries = sorted(
        (kind, record["record_id"], record["record_digest"])
        for kind, values in required.items() for record in values
    )
    bank = _base(
        "lae-frozen-bank-manifest/1.0.0", "frozen-bank:synthetic-one",
        bank_id="frozen-bank:synthetic-one", bank_state="frozen", declared_item_cardinality=1,
        items=[_ref(item)], required_renderings=[_ref(rendering)],
        required_source_manifests=[_ref(source)], required_source_components=[_ref(component)],
        controlling_scoring_doctrine=[_ref(doctrine)], authority_identities=[_ref(authority)],
        neutral_custody_receipt=_ref(receipt),
        authorized_set_digest="sha256:" + sha256_bytes(canonical_json_bytes(authorized_entries)),
    )
    records.extend([doctrine, receipt, bank])
    return records


def synthetic_key_manifest(records=None):
    records = records if records is not None else synthetic_frozen_bank_records()
    item = _find_state(records, "lae-item-record/1.0.0", "frozen")
    rendering = _find_state(records, "lae-arm-rendering/1.0.0", "frozen")
    source = _find_state(records, "lae-source-packet-manifest/1.0.0", "frozen")
    component = _find_state(records, "lae-source-component/1.0.0", "frozen")
    authority = next(record for record in records if record.get("handoff_artifact_kind") == "authority-identity")
    doctrine = next(record for record in records if record.get("handoff_artifact_kind") == "controlling-scoring-doctrine")
    receipt = next(record for record in records if record.get("handoff_artifact_kind") == "neutral-custody-receipt")
    bank = _find(records, "lae-frozen-bank-manifest/1.0.0")
    entries = [
        ("frozen-item", item, item["task_bytes"]),
        ("frozen-rendering", rendering, rendering["visible_bytes"]),
        ("source-packet-manifest", source, source["manifest_bytes"]),
        ("source-component", component, component["component_bytes"]),
        ("controlling-scoring-doctrine", doctrine, doctrine["public_bytes"]),
        ("authority-identity", authority, authority["public_bytes"]),
        ("neutral-custody-receipt", receipt, receipt["public_bytes"]),
    ]
    return _base(
        "lae-key-author-input-manifest/1.0.0", "handoff:synthetic-key-input",
        handoff_id="handoff:synthetic-key-input", handoff_state="frozen",
        frozen_bank_manifest=_ref(bank),
        item_bank_digest="sha256:" + sha256_bytes(canonical_json_bytes([item["record_digest"]])),
        declared_bank_cardinality=1, delivered_bank_cardinality=1,
        delivered_entry_cardinality=len(entries),
        freezer_actor_id=FIXTURE_ACTOR, accepted_at=FIXED_TEST_TIME,
        entries=[{"artifact_kind": kind, "record": _ref(record), "bytes": copy.deepcopy(binding)} for kind, record, binding in entries],
        authority_identities=[_ref(authority)],
    )


def execute_mutations(registry=None):
    registry = registry if registry is not None else strict_json_load(MUTATION_REGISTRY_PATH)
    if registry.get("predecessor_registry_sha256") != PREDECESSOR_MUTATION_REGISTRY_SHA256:
        raise MutationNotExercised("predecessor mutation registry identity differs")
    declarations = registry.get("mutations", [])
    handlers = _mutation_handlers()
    declared_ids = [entry["mutation_id"] for entry in declarations]
    if len(declared_ids) != len(set(declared_ids)):
        raise MutationNotExercised("duplicate mutation declaration")
    if set(declared_ids) != set(handlers):
        missing = sorted(set(declared_ids) - set(handlers))
        undeclared = sorted(set(handlers) - set(declared_ids))
        raise MutationNotExercised(f"missing handlers={missing}; undeclared handlers={undeclared}")
    results = []
    executed = set()
    for declaration in declarations:
        mutation_id = declaration["mutation_id"]
        expected = declaration["expected_condition"]
        try:
            handlers[mutation_id]()
        except PilotError as exc:
            observed = exc.condition
            passed = observed == expected
        else:
            observed = "NO-FAILURE"
            passed = False
        executed.add(mutation_id)
        results.append({
            "mutation_id": mutation_id,
            "expected_condition": expected,
            "observed_condition": observed,
            "executed": True,
            "killed": passed,
        })
    if executed != set(declared_ids) or not all(result["killed"] for result in results):
        failures = [result for result in results if not result["killed"]]
        raise MutationNotExercised(json.dumps(failures, sort_keys=True))
    return results


def verify_commission_inputs():
    commission_dir = PACKET_ROOT / "evidence/preauthorship-repair-0.2/commission"
    expected = {
        "REPAIR-0.2-COMMISSION-BASIS.md": (24058, COMMISSION_BASIS_DIGEST.removeprefix("sha256:")),
        "REPAIR-0.2-ADOPTION-RULING-FINAL.md": (3501, "968c9e0e65fc8fcd5dd76582cf7a0ae063aff96ea219eb724e3d2d6da88d222f"),
    }
    for name, (byte_length, digest) in expected.items():
        path = commission_dir / name
        if not path.is_file() or path.stat().st_size != byte_length or sha256_file(path) != digest:
            raise RecordDigestMismatch(f"commission identity: {name}")
    ruling = (commission_dir / "REPAIR-0.2-ADOPTION-RULING-FINAL.md").read_text(encoding="utf-8")
    if "TIMESTAMP: 2026-07-16T02:41:20-03:00" not in ruling or "[x] OPTION 1 — ADOPT ALL" not in ruling:
        raise RecordDigestMismatch("finalized adoption ruling selection")
    return expected


def validate_escaped_defect_registry():
    registry = strict_json_load(PACKET_ROOT / "preauthorship/registries/escaped-defect-fixtures.json")
    if registry["commission_basis_sha256"] != COMMISSION_BASIS_DIGEST or registry["standing"] != "permanently-tainted-regression-law":
        raise TaintedAncestry("escaped-defect registry standing")
    expected_ids = {f"mutation:pv-0{number}-witness" for number in range(1, 6)}
    if {record["witness_id"] for record in registry["fixtures"]} != expected_ids:
        raise TaintedAncestry("escaped-defect witness IDs")
    for record in registry["fixtures"]:
        path = PACKET_ROOT / record["path"]
        if not path.is_file() or path.stat().st_size != record["byte_length"] or "sha256:" + sha256_file(path) != record["sha256"]:
            raise RecordDigestMismatch(record["witness_id"])
        witness = strict_json_load(path)
        if witness["witness_id"] != record["witness_id"] or witness["standing"] != "permanently-tainted-escaped-defect":
            raise TaintedAncestry(record["witness_id"])
    return registry


def verify_authorial_inputs():
    custody_path = PACKET_ROOT / "evidence/authorial-review/AUTHORIAL-INPUT-CUSTODY.json"
    custody = strict_json_load(custody_path)
    expected_standings = {
        "controlling-authority", "scoped-authorial-erratum", "authorial-freeze-work-review",
        "owner-supplied-reviewed-design-input",
    }
    if {record["standing"] for record in custody["records"]} != expected_standings:
        raise RecordDigestMismatch("authorial standing inventory")
    for record in custody["records"]:
        path = PACKET_ROOT.parents[1] / record["tracked_repository_relative_path"]
        if path.stat().st_size != record["byte_length"] or sha256_file(path) != record["sha256"]:
            raise RecordDigestMismatch(record["original_supplied_filename"])
        if record["copied_byte_identically"] is not True or record["semantic_modification"] != "none":
            raise RecordDigestMismatch(f"custody assertion: {record['original_supplied_filename']}")
    docket = next(record for record in custody["records"] if record["standing"] == "authorial-freeze-work-review")
    if docket["sha256"] != "f4c826e8c990fa991708fc07a1ff552f48b6d9eecf507b96fe035bd86be014d5":
        raise RecordDigestMismatch("docket identity")
    design_note = next(record for record in custody["records"] if record["standing"] == "owner-supplied-reviewed-design-input")
    if design_note["byte_length"] != 27378 or design_note["sha256"] != "d844fa01fb62c20fb0daefe60a17a858f28ff69ce76d6903c5d86330922abc6d":
        raise RecordDigestMismatch("anti-taxidermy construct-validity design-note identity")
    return custody


def verify_all():
    inventory = schema_inventory()
    validate_repository_records()
    results = execute_mutations()
    return {
        "schema_version": "lae-preauthorship-verification/1.0.0",
        "schema_count": len(inventory),
        "schema_inventory": inventory,
        "mutation_count": len(results),
        "mutations_killed": len(results),
        "odr_43": "unresolved",
        "odr_60": "unresolved",
        "substantive_drafting": "blocked-pending-owner-adoption",
        "current_tranche_max_state": CURRENT_TRANCHE_MAX_STATE,
        "jsonschema_runtime": package_version("jsonschema"),
    }


def validate_repository_records():
    verify_commission_inputs()
    validate_canonical_golden_vector()
    validate_escaped_defect_registry()
    verify_authorial_inputs()
    validate_odr60_candidate(load_odr60_candidate())
    owner_records = load_owner_records()
    successor_lineage = load_successor_lineage()
    validate_owner_records(owner_records, require_adopted=False, lineage_events=successor_lineage)
    try:
        drafting_gate(owner_records, successor_lineage)
    except OwnerDecisionUnresolved:
        drafting_blocked = True
    else:
        drafting_blocked = False
    if not drafting_blocked:
        raise OwnerDecisionForgery("unresolved owner records failed to block drafting")
    validate_lineage(successor_lineage)
    validate_construct_specimen_registry()
    validate_record_graph(synthetic_record_graph(), allow_synthetic=True)
    for private_record in synthetic_private_records():
        validate_record(private_record)
    for capacity_record in synthetic_construct_capacity_records():
        validate_record(capacity_record)
    frozen_records = synthetic_frozen_bank_records()
    validate_key_author_input(synthetic_key_manifest(frozen_records), frozen_records, allow_synthetic=True)
    return True


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("command", choices=("verify", "mutations", "schemas", "owner-gate", "lineage"))
    args = parser.parse_args()
    if args.command == "verify":
        print(json.dumps(verify_all(), sort_keys=True, separators=(",", ":")))
    elif args.command == "mutations":
        print(json.dumps(execute_mutations(), sort_keys=True, separators=(",", ":")))
    elif args.command == "schemas":
        print(json.dumps(schema_inventory(), sort_keys=True, separators=(",", ":")))
    elif args.command == "owner-gate":
        drafting_gate(load_owner_records(), load_successor_lineage())
    elif args.command == "lineage":
        validate_lineage(load_successor_lineage())
        print("PREAUTHORSHIP-LINEAGE: PASS")


if __name__ == "__main__":
    main()
