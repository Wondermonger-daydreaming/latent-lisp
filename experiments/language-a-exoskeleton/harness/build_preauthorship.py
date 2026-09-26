"""Generate deterministic pre-authorship records from reviewed, tracked inputs."""

from __future__ import annotations

import json
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

import preauthorship as pre
from util import PACKET_ROOT, canonical_json_bytes, jsonl_bytes, load_json, sha256_bytes, sha256_file, write_bytes


REVIEWED_COMMIT = "f5f0e4a6972f9b321167e5aef6c5c47c70d56e3e"
REVIEWED_TREE = "6561d3097c056c517e9f67fad1c168608d60f0db"
REPAIR_ACTOR = "actor:codex-preauthorship-repair-session-20260715"
EXTERNAL_OWNER = "actor:externally-supplied-owner-identity-undisclosed"
EVENT_TIME = "2026-07-15T23:59:48-03:00"

ORIGINAL_LINEAGE = [
    "lineage/actors.jsonl",
    "lineage/artifacts.jsonl",
    "lineage/reads.jsonl",
    "lineage/transmission-assertions.jsonl",
    "lineage/search-field.json",
    "lineage/lineage-bounds.jsonl",
    "lineage/receipts.jsonl",
]


def binding(path):
    path = PACKET_ROOT / path
    return {
        "path": path.relative_to(PACKET_ROOT).as_posix(),
        "byte_length": path.stat().st_size,
        "sha256": "sha256:" + sha256_file(path),
    }


def byte_binding(path, artifact_id, role="receipt", media_type="application/json"):
    info = binding(path)
    return {
        "artifact_id": artifact_id,
        "byte_role": role,
        "storage_path": info["path"],
        "byte_length": info["byte_length"],
        "sha256": info["sha256"],
        "media_type": media_type,
        "encoding": "utf-8",
    }


def write_supporting_inputs():
    owner_slots = load_json(PACKET_ROOT / "operator/owner-slots.json")
    role_slot = next(slot for slot in owner_slots["slots"] if slot["slot_id"] == "role-assignments")
    odr43 = {
        "schema_version": "lae-legacy-owner-observation/1.0.0",
        "decision_id": "ODR-43",
        "reviewed_commit": REVIEWED_COMMIT,
        "source_path": "operator/owner-slots.json",
        "legacy_record": role_slot,
        "observation": "coarse status string has no typed actor/access decision",
    }
    design = load_json(PACKET_ROOT / "items/design/design.json")
    odr60 = {
        "schema_version": "lae-legacy-owner-observation/1.0.0",
        "decision_id": "ODR-60",
        "reviewed_commit": REVIEWED_COMMIT,
        "source_paths": ["items/design/design.json", "operator/owner-slots.json"],
        "legacy_design_fields": {
            key: design.get(key)
            for key in ("item_count", "families", "positive_conclusion_minimum", "insufficiency_minimum", "trap_minimum")
        },
        "observation": "no typed immutable owner allocation decision exists",
    }
    legacy_dir = PACKET_ROOT / "operator/owner-decisions/legacy"
    write_bytes(legacy_dir / "ODR-43-coarse-slot.json", canonical_json_bytes(odr43))
    write_bytes(legacy_dir / "ODR-60-absent-typed-slot.json", canonical_json_bytes(odr60))

    fixture_records = []
    for path in sorted((PACKET_ROOT / "controls/preauthorship-synthetic-fixtures").iterdir()):
        if path.is_file():
            fixture_records.append({
                "path": path.relative_to(PACKET_ROOT).as_posix(),
                "byte_length": path.stat().st_size,
                "sha256": sha256_file(path),
                "standing": "permanently-tainted-synthetic-mutation-fixture",
            })
    corpus = {
        "schema_version": "lae-synthetic-fixture-corpus/1.0.0",
        "taint_id": pre.FIXTURE_TAINT_ID,
        "contains_real_item_content": False,
        "semantic_derivatives_excluded": True,
        "files": fixture_records,
    }
    write_bytes(PACKET_ROOT / "controls/preauthorship-synthetic-fixture-corpus.json", canonical_json_bytes(corpus))

    specimen_classes = [
        ("TXD-01", "excision", "future scorer must preserve the keyed denominator and couple omission"),
        ("TXD-02", "refusal-substitution", "future scorer must condition refusal on key answerability"),
        ("TXD-03", "false-abstention", "future scorer must distinguish supported from genuinely insufficient items"),
        ("TXD-04", "truncation-escape", "future scorer must retain timing and the first undischarged material opportunity"),
        ("TXD-05", "over-bounding", "future scorer must preserve over-bounding as a non-compensable profile dimension"),
        ("TXD-06", "procedural-fog", "future scorer must represent procedural substitution separately"),
        ("TXD-07", "scope-narrowing", "future key must preserve parent scope and hierarchical unit coverage"),
        ("TXD-08", "validator-lawful-language-a-evacuation", "future scoring must keep structural validity orthogonal to substantive discharge"),
        ("TXD-09", "fluent-hollow-versus-clumsy-complete", "future stress study must distinguish substance from fluency"),
        ("TXD-10", "concise-complete-versus-excision", "future stress study must distinguish keyed completeness from length"),
    ]
    note_binding = byte_binding(
        "evidence/authorial-review/ANTI-TAXIDERMY-CONSTRUCT-VALIDITY-NOTE.md",
        "artifact:anti-taxidermy-construct-validity-design-note", role="design-input", media_type="text/markdown",
    )
    prohibited = ["target-bank", "key-author-input", "private-score-key", "grader-calibration", "held-out-experimental-material"]
    specimens = []
    predecessor = None
    for specimen_id, specimen_class, obligation in specimen_classes:
        specimen = pre.seal_record({
            "schema_version": "lae-construct-validity-specimen-record/1.0.0",
            "record_id": f"specimen:{specimen_id}-v1",
            "actor_id": REPAIR_ACTOR,
            "event_time": EVENT_TIME,
            "predecessor_digest": predecessor,
            "parent_versions": [],
            "bounded_unknowns": ["behavior, thresholds, and substantive adjudication are deferred"],
            "synthetic_taint_id": pre.CONSTRUCT_SPECIMEN_TAINT_ID,
            "specimen_id": specimen_id,
            "specimen_class": specimen_class,
            "identity_only": True,
            "full_behavior_implemented": False,
            "standing": "declared-future-freeze-quality-obligation",
            "permanent_taint_id": pre.CONSTRUCT_SPECIMEN_TAINT_ID,
            "design_note_bytes": note_binding,
            "prohibited_destinations": prohibited,
            "deferred_obligations": [obligation],
        })
        pre.validate_record(specimen)
        specimens.append(specimen)
        predecessor = specimen["record_digest"]
    write_bytes(PACKET_ROOT / "preauthorship/registries/construct-validity-specimens.jsonl", jsonl_bytes(specimens))

    deferral = {
        "schema_version": "lae-construct-validity-deferral/1.0.0",
        "design_input": {
            "path": "evidence/authorial-review/ANTI-TAXIDERMY-CONSTRUCT-VALIDITY-NOTE.md",
            "byte_length": 27378,
            "sha256": "d844fa01fb62c20fb0daefe60a17a858f28ff69ce76d6903c5d86330922abc6d",
            "standing": "reviewed-design-input-not-authority"
        },
        "incorporated_now": [
            "schema capacity for private opportunity provenance and hierarchical keyed units",
            "permanently tainted TXD-01 through TXD-10 identity registry",
            "provenance hooks and explicit zero-opportunity/not-applicable justification",
            "orthogonal structural-validity and substantive-discharge axes",
            "profile-only future score capacity with a non-gating descriptive composite"
        ],
        "deferred_to_freeze_quality_repair": [
            "scoring implementation", "synthetic specimen behavior", "numerical thresholds",
            "substantive-content adjudication", "precision study", "branch receipt riders"
        ],
        "construct_validity_established": False,
        "real_items_created": False,
        "private_key_created": False,
        "thresholds_selected": False,
        "branch_receipts_created": False
    }
    write_bytes(PACKET_ROOT / "preauthorship/deferred/FREEZE-QUALITY-CONSTRUCT-VALIDITY.json", canonical_json_bytes(deferral))


def artifact_claims(path, extra=None):
    info = binding(path)
    claims = [
        {"dimension": "path", "value": info["path"], "bound": "exact"},
        {"dimension": "sha256", "value": info["sha256"], "bound": "exact"},
        {"dimension": "byte-length", "value": info["byte_length"], "bound": "exact"},
    ]
    for dimension, value in (extra or {}).items():
        claims.append({"dimension": dimension, "value": value, "bound": "exact"})
    return claims


def event_ref(event):
    values = {claim["dimension"]: claim["value"] for claim in event["claims"]}
    return {
        "artifact_id": event["subject_id"],
        "artifact_event_digest": event["record_digest"],
        "artifact_version": values.get("version", values["sha256"]),
        "byte_length": values["byte-length"],
        "sha256": values["sha256"],
    }


class Chain:
    def __init__(self):
        self.events = []

    @property
    def predecessor(self):
        return self.events[-1]["record_digest"] if self.events else None

    def add(self, event_id, event_type, actor_id, subject_id, action, **fields):
        event = pre._event(
            event_id, event_type, actor_id, subject_id, action,
            fields.pop("event_time", EVENT_TIME), self.predecessor, **fields,
        )
        self.events.append(event)
        return event


def build_lineage():
    chain = Chain()
    chain.add(
        "event:actor-reviewed-builder", "actor", "actor:codex-builder-session-20260715",
        "actor:codex-builder-session-20260715", "declared",
        event_time="2026-07-15T20:53:44-03:00", chronology_basis="imported-original",
        standing="imported-reviewed-evidence",
        bounded_unknowns=["model release was null in the reviewed actor record"],
        claims=[{"dimension": "role", "value": "implementation-builder", "bound": "declared"}],
    )
    chain.add(
        "event:actor-external-owner", "actor", EXTERNAL_OWNER, EXTERNAL_OWNER, "declared",
        standing="bounded-unknown", bounded_unknowns=["human identity not supplied in the commission"],
        claims=[{"dimension": "role", "value": "external-authorial-input-source", "bound": "declared"}],
    )
    chain.add(
        "event:actor-repair-builder", "actor", REPAIR_ACTOR, REPAIR_ACTOR, "declared",
        standing="declared", bounded_unknowns=["model-weight and training-corpus ancestry undisclosed"],
        claims=[
            {"dimension": "role", "value": "preauthorship-repair-builder", "bound": "exact"},
            {"dimension": "provider", "value": "OpenAI", "bound": "declared"},
            {"dimension": "model-family", "value": "GPT-5", "bound": "declared"},
        ],
    )

    artifact_specs = [
        ("program-ruling", "artifact:program-ruling", "evidence/authorial-review/POST-DE-CORROBORATIONE-PROGRAM-RULING.md", {}),
        ("program-errata", "artifact:program-ruling-errata-0.1", "evidence/authorial-review/POST-DE-CORROBORATIONE-PROGRAM-RULING-ERRATA-0.1.md", {}),
        ("owner-docket", "artifact:language-a-owner-freeze-work-docket", "evidence/authorial-review/LANGUAGE-A-PILOT-OWNER-FREEZE-WORK-DOCKET.md", {}),
        ("construct-validity-note", "artifact:anti-taxidermy-construct-validity-design-note", "evidence/authorial-review/ANTI-TAXIDERMY-CONSTRUCT-VALIDITY-NOTE.md", {"standing": "reviewed-design-input-not-authority"}),
        ("reviewed-manifest", "artifact:reviewed-packet-construction-manifest", "FREEZE-MANIFEST.json", {"reviewed-commit": REVIEWED_COMMIT, "reviewed-tree": REVIEWED_TREE}),
        ("owner-slots", "artifact:reviewed-owner-slots", "operator/owner-slots.json", {"reviewed-commit": REVIEWED_COMMIT}),
    ]
    for index, path in enumerate(ORIGINAL_LINEAGE, 1):
        artifact_specs.append((f"original-lineage-{index}", f"artifact:reviewed-{Path(path).stem}-{index}", path, {"reviewed-commit": REVIEWED_COMMIT}))

    artifacts = {}
    ruling_digest = None
    for label, artifact_id, path, extra in artifact_specs:
        parents = []
        if label == "program-errata" and ruling_digest:
            parents = [ruling_digest]
        event = chain.add(
            f"event:artifact-{label}", "artifact", REPAIR_ACTOR, artifact_id, "created",
            chronology_basis="imported-original", standing="imported-reviewed-evidence",
            parent_artifact_digests=parents, claims=artifact_claims(path, extra),
        )
        artifacts[label] = event
        if label == "program-ruling":
            ruling_digest = event["record_digest"]

    reads = {}
    for label, artifact, _, _ in artifact_specs:
        event = chain.add(
            f"event:read-{label}", "read", REPAIR_ACTOR, f"read:repair-{label}", "read",
            artifact_refs=[event_ref(artifacts[label])], basis_event_digests=[artifacts[label]["record_digest"]],
            standing="observed", claims=[{"dimension": "scope", "value": "all", "bound": "exact"}],
        )
        reads[label] = event

    chain.add(
        "event:transmission-authorial-inputs", "transmission", EXTERNAL_OWNER,
        "transmission:external-authorial-inputs", "transmitted",
        basis_event_digests=[reads[name]["record_digest"] for name in ("program-ruling", "program-errata", "owner-docket", "construct-validity-note")],
        standing="external-custody", bounded_unknowns=["transport before arrival in the primary checkout is undisclosed"],
        claims=[{"dimension": "delivered-bytes", "value": "three authorial inputs plus one reviewed design input", "bound": "exact"}],
    )

    derived_specs = [
        ("legacy-odr-43", "artifact:legacy-odr-43-coarse-slot", "operator/owner-decisions/legacy/ODR-43-coarse-slot.json", [artifacts["owner-slots"]["record_digest"]]),
        ("legacy-odr-60", "artifact:legacy-odr-60-absent-typed-slot", "operator/owner-decisions/legacy/ODR-60-absent-typed-slot.json", [artifacts["owner-slots"]["record_digest"]]),
        ("synthetic-fixture-corpus", "artifact:preauthorship-synthetic-fixture-corpus", "controls/preauthorship-synthetic-fixture-corpus.json", []),
        ("construct-specimen-registry", "artifact:anti-taxidermy-construct-specimen-registry", "preauthorship/registries/construct-validity-specimens.jsonl", [artifacts["construct-validity-note"]["record_digest"]]),
    ]
    derived = {}
    for label, artifact_id, path, inputs in derived_specs:
        event = chain.add(
            f"event:artifact-{label}", "artifact", REPAIR_ACTOR, artifact_id, "created",
            input_artifact_digests=inputs, parent_artifact_digests=inputs,
            standing="observed", claims=artifact_claims(path, {"version": "lae-preauthorship-repair/1.0.0"}),
        )
        derived[label] = event
        chain.add(
            f"event:read-{label}", "read", REPAIR_ACTOR, f"read:repair-{label}", "read",
            artifact_refs=[event_ref(event)], basis_event_digests=[event["record_digest"]],
            standing="observed", claims=[{"dimension": "scope", "value": "all", "bound": "exact"}],
        )

    all_read_digests = [event["record_digest"] for event in reads.values()]
    chain.add(
        "event:ancestry-repair", "ancestry", REPAIR_ACTOR, "ancestry:preauthorship-repair", "ancestry-declared",
        basis_event_digests=all_read_digests,
        artifact_refs=[event_ref(artifacts[name]) for name in ("program-ruling", "program-errata", "owner-docket", "construct-validity-note", "reviewed-manifest")],
        standing="self-report", bounded_unknowns=["unlogged side channels", "training-corpus overlap"],
        claims=[{"dimension": "shared-root", "value": "controlling authority and reviewed packet", "bound": "declared"}],
    )
    chain.add(
        "event:prior-exposure-repair", "prior-exposure", REPAIR_ACTOR,
        "exposure:preauthorship-repair", "exposure-declared",
        standing="self-report", bounded_unknowns=["absence is bounded to the declared checkout and observed tool history"],
        claims=[
            {"dimension": "real-item-created", "value": False, "bound": "declared"},
            {"dimension": "target-exposure", "value": False, "bound": "declared"},
            {"dimension": "separation", "value": False, "bound": "not-certified"},
        ],
    )
    chain.add(
        "event:exclusion-synthetic-fixtures", "exclusion", REPAIR_ACTOR,
        "exclusion:preauthorship-synthetic-fixtures", "excluded",
        artifact_refs=[event_ref(derived["synthetic-fixture-corpus"]), event_ref(derived["construct-specimen-registry"])],
        standing="observed", claims=[
            {"dimension": "disposition", "value": "permanently-tainted", "bound": "exact"},
            {"dimension": "semantic-derivatives-excluded", "value": True, "bound": "exact"},
        ],
    )
    rejection = chain.add(
        "event:rejection-reviewed-lineage", "rejection", REPAIR_ACTOR,
        "draft:reviewed-construction-lineage-v0-2", "rejected",
        basis_event_digests=[reads["owner-docket"]["record_digest"]], standing="rejected-preserved",
        claims=[{"dimension": "reason", "value": "FI-05 freeze-quality rejection; original bytes preserved", "bound": "exact"}],
    )
    chain.add(
        "event:correction-lineage-contract", "correction", REPAIR_ACTOR,
        "correction:lineage-digest-contract-v1", "corrected",
        supersedes_event_digest=rejection["record_digest"], rejection_preserved=True,
        causal_predecessor_digests=[rejection["record_digest"]], standing="observed",
        claims=[{"dimension": "correction", "value": "canonical record digest and exact predecessor digest", "bound": "exact"}],
    )
    chain.add(
        "event:successor-preauthorship-lineage", "successor", REPAIR_ACTOR,
        "successor:preauthorship-lineage-v1", "succeeded",
        supersedes_event_digest=rejection["record_digest"], rejection_preserved=True,
        causal_predecessor_digests=[rejection["record_digest"]], standing="observed",
        claims=[
            {"dimension": "authorization-ceiling", "value": "candidate", "bound": "exact"},
            {"dimension": "original-evidence-rewritten", "value": False, "bound": "exact"},
        ],
    )
    return chain.events, derived


def owner_record(decision_id, predecessor_digest):
    if decision_id == "ODR-43":
        domain = {
            "domain_kind": "actor-and-access-manifest",
            "constraints": [
                "name every human or model-assisted item-author actor without assuming independence",
                "bind session, model, and tool use where applicable",
                "bind family assignment and repository access",
                "declare prior exposure and shared roots",
                "identify the separate freezer or overlap auditor",
            ],
        }
        authority = [
            ("0b7492c3adfa12abe5e782b42722684e169b4cb14b42d6623652a087d191dc24", "sections 3.11 and 5.1 Actor", "controlling-authority"),
            ("f4c826e8c990fa991708fc07a1ff552f48b6d9eecf507b96fe035bd86be014d5", "sections 3.4 ODR-43, 4.1, and 4.12", "accepted-authorial-review"),
        ]
        dependencies = ["FI-01", "FI-05", "section 4 item-authorship commission"]
        gate = "preauthorship.item-author-role-access-manifest"
    else:
        domain = {
            "domain_kind": "allocation-policy",
            "constraints": [
                "respect the authority-fixed minima of at least eight positive, eight insufficiency, and eight closed-class trap items",
                "decide whether genuine role overlap is allowed and how independent instantiation is proved",
                "decide the minimum per-family distribution",
                "prove distinctness without leaking private roles to runner or key-author input",
                "retain exactly the closed eight-class trap vocabulary",
            ],
        }
        authority = [
            ("0b7492c3adfa12abe5e782b42722684e169b4cb14b42d6623652a087d191dc24", "section 3.5 Item bank", "controlling-authority"),
            ("d56fbd44f2bdce62a2ab1e225bbe84e907f6173bad210e1328c5f4f4ebb34064", "section 6 Positive-conclusion item balance", "scoped-authorial-erratum"),
            ("f4c826e8c990fa991708fc07a1ff552f48b6d9eecf507b96fe035bd86be014d5", "sections 3.5 ODR-60 and 4.7", "accepted-authorial-review"),
        ]
        dependencies = ["ODR-59 or retention of authority-fixed 24-item/four-family geometry", "FI-01", "FI-05"]
        gate = "preauthorship.item-bank-role-allocation-validator"
    return pre.seal_record({
        "schema_version": "lae-owner-decision-record/1.0.0",
        "record_id": f"owner-decision:{decision_id}-unresolved-v1",
        "actor_id": REPAIR_ACTOR,
        "event_time": EVENT_TIME,
        "predecessor_digest": predecessor_digest,
        "parent_versions": [],
        "bounded_unknowns": ["owner value not chosen", "deciding actor not chosen", "shared-root disclosure awaits owner adoption"],
        "synthetic_taint_id": None,
        "decision_id": decision_id,
        "status": "unresolved",
        "exact_decision": None,
        "allowed_domain": domain,
        "rationale": None,
        "controlling_authority": [
            {"artifact_sha256": "sha256:" + digest, "section": section, "standing": standing}
            for digest, section, standing in authority
        ],
        "deciding_actor": None,
        "role_shared_root_disclosure": None,
        "dependencies": dependencies,
        "adoption_timestamp": None,
        "exact_executable_gate": gate,
    })


def generate():
    pre.verify_authorial_inputs()
    write_supporting_inputs()
    events, derived = build_lineage()
    pre.validate_lineage(events)
    write_bytes(PACKET_ROOT / "lineage/successor/events.jsonl", jsonl_bytes(events))

    odr43 = owner_record("ODR-43", derived["legacy-odr-43"]["record_digest"])
    odr60 = owner_record("ODR-60", derived["legacy-odr-60"]["record_digest"])
    pre.validate_owner_records([odr43, odr60], require_adopted=False)
    write_bytes(PACKET_ROOT / "operator/owner-decisions/ODR-43.json", canonical_json_bytes(odr43))
    write_bytes(PACKET_ROOT / "operator/owner-decisions/ODR-60.json", canonical_json_bytes(odr60))

    original = {
        "schema_version": "lae-original-successor-lineage-inventory/1.0.0",
        "reviewed_commit": REVIEWED_COMMIT,
        "reviewed_tree": REVIEWED_TREE,
        "original_records_preserved_in_place": [binding(path) for path in ORIGINAL_LINEAGE],
        "successor_path": "lineage/successor/events.jsonl",
        "original_rewritten": False,
    }
    write_bytes(PACKET_ROOT / "lineage/successor/ORIGINAL-VERSUS-SUCCESSOR.json", canonical_json_bytes(original))
    specimen_registry_binding = byte_binding(
        "preauthorship/registries/construct-validity-specimens.jsonl",
        "artifact:anti-taxidermy-construct-specimen-registry", role="receipt", media_type="application/jsonl",
    )
    specimen_taint = pre.seal_record({
        "schema_version": "lae-exclusion-taint-record/1.0.0",
        "record_id": pre.CONSTRUCT_SPECIMEN_TAINT_ID,
        "actor_id": REPAIR_ACTOR,
        "event_time": EVENT_TIME,
        "predecessor_digest": None,
        "parent_versions": [],
        "bounded_unknowns": ["semantic derivatives are conservatively excluded"],
        "synthetic_taint_id": None,
        "subject_ids": [f"specimen:TXD-{number:02d}-v1" for number in range(1, 11)],
        "subject_sha256s": [specimen_registry_binding["sha256"]],
        "identity_bindings": [specimen_registry_binding],
        "disposition": "permanently-tainted",
        "reason_class": "construct-validity-specimen",
        "semantic_derivatives_excluded": True,
        "preserved_append_only": True,
        "basis_event_digests": [derived["construct-specimen-registry"]["record_digest"]],
    })
    pre.validate_record(specimen_taint)
    write_bytes(PACKET_ROOT / "preauthorship/registries/permanent-taint.jsonl", jsonl_bytes([pre.synthetic_record_graph()[0], specimen_taint]))
    write_bytes(PACKET_ROOT / "evidence/preauthorship-repair/SCHEMA-INVENTORY.json", canonical_json_bytes({
        "schema_version": "lae-schema-inventory/1.0.0",
        "bundle": binding("schemas/preauthorship.schema.json"),
        "schemas": pre.schema_inventory(),
    }))
    print(f"GENERATED pre-authorship records: lineage={len(events)} schemas={len(pre.schema_inventory())}")


if __name__ == "__main__":
    generate()
