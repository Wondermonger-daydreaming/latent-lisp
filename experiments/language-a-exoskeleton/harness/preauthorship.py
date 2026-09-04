"""Strict network-off pre-authorship records, lineage, gates, and mutations.

This module authorizes no item content.  Its committed fixtures are synthetic,
permanently tainted byte strings used only to prove refusal behavior.
"""

from __future__ import annotations

import argparse
import copy
import json
from datetime import datetime
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
    "lae-key-author-input-manifest/1.0.0": "key-author-input-manifest",
    "lae-handoff-public-artifact/1.0.0": "handoff-public-artifact",
    "lae-owner-decision-record/1.0.0": "owner-decision-record",
    "lae-opportunity-record/1.0.0": "opportunity-record",
    "lae-keyed-unit-record/1.0.0": "keyed-unit-record",
    "lae-future-score-profile-record/1.0.0": "future-score-profile-record",
    "lae-construct-validity-specimen-record/1.0.0": "construct-validity-specimen-record",
    "lae-future-branch-receipt-riders/1.0.0": "future-branch-receipt-riders",
    "lae-lineage-event/1.0.0": "lineage-event",
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
    stable_ids = set()
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
            if value in stable_ids:
                raise DuplicateDraftId(value)
            stable_ids.add(value)
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
    if state in {"freezer-accepted", "frozen"} and not allow_synthetic:
        raise PreauthorshipStateViolation(f"{record['record_id']} -> {state}")


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
    return index


def validate_consumption(item, consumer):
    if consumer not in CONSUMERS_REQUIRING_FROZEN:
        raise ValueError(f"unknown consumer: {consumer}")
    if item.get("draft_state") != "frozen":
        raise DraftItemUsedAsFrozen(f"{item.get('item_id')} -> {consumer}")


def validate_key_author_input(manifest, records, root=PACKET_ROOT):
    reject_private_fields(manifest)
    try:
        validate_record(manifest, "key-author-input-manifest", root=root)
    except PreauthorshipSchemaViolation as exc:
        raise KeyAuthorBoundaryViolation(exc.detail) from exc
    index = _reference_index(records)
    expected = {
        "frozen-item": ("lae-item-record/1.0.0", "task_bytes"),
        "frozen-rendering": ("lae-arm-rendering/1.0.0", "visible_bytes"),
        "source-packet-manifest": ("lae-source-packet-manifest/1.0.0", "manifest_bytes"),
        "source-component": ("lae-source-component/1.0.0", "component_bytes"),
        "controlling-scoring-doctrine": ("lae-handoff-public-artifact/1.0.0", "public_bytes"),
        "authority-identity": ("lae-handoff-public-artifact/1.0.0", "public_bytes"),
        "neutral-custody-receipt": ("lae-handoff-public-artifact/1.0.0", "public_bytes"),
    }
    item_digests = []
    for entry in manifest["entries"]:
        artifact_kind = entry["artifact_kind"]
        if artifact_kind not in expected:
            raise KeyAuthorBoundaryViolation(entry["artifact_kind"])
        schema_version, binding_field = expected[artifact_kind]
        try:
            target = resolve_ref(entry["record"], index, schema_version)
        except (SourceComponentMissing, WrongRecordVersion, ParentDigestMismatch) as exc:
            raise KeyAuthorBoundaryViolation(f"{artifact_kind}: {exc.detail}") from exc
        if schema_version == "lae-handoff-public-artifact/1.0.0" and target["handoff_artifact_kind"] != artifact_kind:
            raise KeyAuthorBoundaryViolation(f"kind mismatch: {artifact_kind}")
        binding = target[binding_field]
        if entry["bytes"]["sha256"] != binding["sha256"] or entry["bytes"]["byte_length"] != binding["byte_length"]:
            raise KeyAuthorBoundaryViolation(f"byte mismatch: {artifact_kind}")
        if artifact_kind == "frozen-item" and target.get("draft_state") != "frozen":
            raise MovingBankHandoff(target.get("item_id", target["record_id"]))
        if artifact_kind == "frozen-item":
            item_digests.append(target["record_digest"])
        if artifact_kind in {"frozen-rendering", "source-packet-manifest", "source-component"} and target.get("state") != "frozen":
            raise MovingBankHandoff(target["record_id"])
    expected_bank_digest = "sha256:" + sha256_bytes(canonical_json_bytes(sorted(item_digests)))
    if not item_digests or manifest["item_bank_digest"] != expected_bank_digest:
        raise MovingBankHandoff("item-bank digest does not close over exact frozen item records")
    for authority_ref in manifest["authority_identities"]:
        try:
            authority = resolve_ref(authority_ref, index, "lae-handoff-public-artifact/1.0.0")
        except (SourceComponentMissing, WrongRecordVersion, ParentDigestMismatch) as exc:
            raise KeyAuthorBoundaryViolation(f"authority identity: {exc.detail}") from exc
        if authority["handoff_artifact_kind"] != "authority-identity":
            raise KeyAuthorBoundaryViolation("authority identity kind mismatch")
    return True


def _parse_time(value):
    try:
        return datetime.fromisoformat(value)
    except ValueError as exc:
        raise LineageChronologyViolation(value) from exc


def validate_lineage(events):
    if not events:
        raise PredecessorDigestMismatch("empty lineage")
    by_digest = {}
    by_id = {}
    actors = set()
    artifacts = {}
    reads = set()
    previous_digest = None
    previous_time = None
    for position, event in enumerate(events):
        validate_record(event, "lineage-event", verify_bound_bytes=False)
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
        if event["event_type"] == "transmission":
            if any(by_digest[basis]["event_type"] != "read" for basis in event["basis_event_digests"]):
                raise UnloggedRead(event["event_id"])
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
        by_digest[digest] = event
        by_id[event["event_id"]] = event
        previous_digest = digest
        previous_time = current_time
    return True


def validate_owner_records(records, require_adopted=False, lineage_events=None):
    decisions = {}
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
        if record["status"] == "adopted" and record["decision_id"] == "ODR-60":
            decision = record["exact_decision"]
            families = [allocation["family"] for allocation in decision["family_allocations"]]
            if set(families) != {"bounded-support", "scope-and-version", "conflict-and-residue", "notation-neutral-transfer"}:
                raise OwnerDecisionForgery("ODR-60 family allocation closure")
            for field, minimum_field in (
                ("positive_conclusion", "positive_conclusion_minimum"),
                ("insufficiency", "insufficiency_minimum"),
                ("closed_class_trap", "closed_class_trap_minimum"),
            ):
                if sum(allocation[field] for allocation in decision["family_allocations"]) < decision[minimum_field]:
                    raise OwnerDecisionForgery(f"ODR-60 {field} allocation below adopted minimum")
        if record["decision_id"] in decisions:
            raise DuplicateDraftId(record["decision_id"])
        if record["predecessor_digest"] is None:
            raise PredecessorDigestMismatch(record["decision_id"])
        decisions[record["decision_id"]] = record
    if set(decisions) != {"ODR-43", "ODR-60"}:
        raise OwnerDecisionUnresolved("ODR-43,ODR-60 records required")
    if lineage_events is not None:
        lineage_digests = {event["record_digest"] for event in lineage_events}
        for decision_id, record in decisions.items():
            if record["predecessor_digest"] not in lineage_digests:
                raise PredecessorDigestMismatch(decision_id)
    if require_adopted:
        unresolved = [decision_id for decision_id, record in decisions.items() if record["status"] != "adopted"]
        if unresolved:
            raise OwnerDecisionUnresolved(",".join(unresolved))
    return decisions


def drafting_gate(owner_records):
    validate_owner_records(owner_records, require_adopted=True)
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


def synthetic_record_graph(state="candidate"):
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
        transformations=[], state=state,
    )
    source = _base(
        "lae-source-packet-manifest/1.0.0", "source-manifest:synthetic-one",
        source_packet_id="source:synthetic-one",
        manifest_bytes=_binding("source-manifest.txt", "artifact:synthetic-source-manifest", "source-manifest"),
        state=state, title="Synthetic source packet", creator="synthetic validator",
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
        generated_by=FIXTURE_ACTOR, parity_leak_receipt=_ref(taint), state=state,
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
        item_specific_content=False, freezer_only_content=False, mutable_bank_data=False,
    )
    item = _base(
        "lae-item-record/1.0.0", "item-record:synthetic-one",
        item_id="item:synthetic-one", family="bounded-support", task_bytes=task_binding,
        source_packet=_ref(source), renderings=[_ref(rendering)], transfer=False,
        sham_designated=False, commission_actor_ids=[FIXTURE_ACTOR], ancestry=_ref(ancestry),
        prior_exposure=_ref(exposure), exclusion_receipt=_ref(cleared),
        lexical_collision_receipt=_ref(lexical), semantic_overlap_receipt=_ref(semantic),
        freezer_decision=None, draft_state=state,
    )
    return [taint, component, source, rendering, ancestry, exposure, cleared, lexical, semantic, public_authority, item]


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
        item=_ref(item), dossier=_ref(dossier), decision="returned", resulting_state="candidate",
        reviewer_actor_id=FIXTURE_ACTOR,
        rationale_bytes=_binding("receipt.txt", "artifact:synthetic-freezer-rationale", "receipt"),
        preserve_rejected_predecessor=True, supersedes_record_digest=None,
    )
    return [dossier, witness, decision]


def synthetic_construct_capacity_records():
    records = synthetic_record_graph(state="frozen")
    item = records[-1]
    source = _find(records, "lae-source-packet-manifest/1.0.0")
    component = _find(records, "lae-source-component/1.0.0")
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
    return seal_record({
        "schema_version": "lae-lineage-event/1.0.0",
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
        **fields,
    })


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


def load_owner_records():
    return [strict_json_load(OWNER_RECORD_DIR / name) for name in ("ODR-43.json", "ODR-60.json")]


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
        manifest = synthetic_key_manifest(); manifest[field] = value; manifest = _reseal(manifest); validate_key_author_input(manifest, synthetic_record_graph(state="frozen"))

    def key_bad_kind(kind):
        manifest = synthetic_key_manifest(); manifest["entries"][0]["artifact_kind"] = kind; manifest = _reseal(manifest); validate_key_author_input(manifest, synthetic_record_graph(state="frozen"))

    def key_kind_spoof():
        manifest = synthetic_key_manifest()
        manifest["entries"][0]["artifact_kind"] = "controlling-scoring-doctrine"
        manifest = _reseal(manifest)
        validate_key_author_input(manifest, synthetic_record_graph(state="frozen"))

    def odr_status_only():
        record = copy.deepcopy(load_owner_records()[0]); record["status"] = "adopted"; record = _reseal(record); validate_owner_records([record, load_owner_records()[1]])

    def odr_boolean_only():
        records = load_owner_records(); record = copy.deepcopy(records[1]); record["complete"] = True; record = _reseal(record); validate_owner_records([records[0], record])

    def draft_as_frozen():
        validate_consumption(_find(synthetic_record_graph(), "lae-item-record/1.0.0"), "runner")

    def consume_draft(consumer):
        validate_consumption(_find(synthetic_record_graph(), "lae-item-record/1.0.0"), consumer)

    def moving_bank_handoff():
        candidate_records = synthetic_record_graph(state="candidate")
        item = _find(candidate_records, "lae-item-record/1.0.0")
        manifest = synthetic_key_manifest()
        manifest["entries"][0]["record"] = _ref(item)
        manifest = _reseal(manifest)
        validate_key_author_input(manifest, candidate_records)

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
    }


def synthetic_key_manifest():
    records = synthetic_record_graph(state="frozen")
    item = _find(records, "lae-item-record/1.0.0")
    authority = _find(records, "lae-handoff-public-artifact/1.0.0")
    return _base(
        "lae-key-author-input-manifest/1.0.0", "handoff:synthetic-key-input",
        handoff_id="handoff:synthetic-key-input", handoff_state="frozen",
        item_bank_digest="sha256:" + sha256_bytes(canonical_json_bytes([item["record_digest"]])),
        freezer_actor_id=FIXTURE_ACTOR, accepted_at=FIXED_TEST_TIME,
        entries=[{
            "artifact_kind": "frozen-item", "record": _ref(item),
            "bytes": _binding("task.txt", "artifact:synthetic-handoff-item", "handoff-entry"),
        }],
        authority_identities=[_ref(authority)],
    )


def execute_mutations(registry=None):
    registry = registry if registry is not None else strict_json_load(MUTATION_REGISTRY_PATH)
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
    verify_authorial_inputs()
    owner_records = load_owner_records()
    successor_lineage = load_successor_lineage()
    validate_owner_records(owner_records, require_adopted=False, lineage_events=successor_lineage)
    try:
        drafting_gate(owner_records)
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
    frozen_records = synthetic_record_graph(state="frozen")
    validate_key_author_input(synthetic_key_manifest(), frozen_records)
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
        drafting_gate(load_owner_records())
    elif args.command == "lineage":
        validate_lineage(load_successor_lineage())
        print("PREAUTHORSHIP-LINEAGE: PASS")


if __name__ == "__main__":
    main()
