"""Candidate-bank canonicalization, immutable rendering, and network-off custody.

The payload composer accepts only a typed target-visible item plus fixed byte
objects. Hidden metadata and external freezer-dossier identities are validated
by the control plane but are not loadable by the runtime path. Private dossier
content never resides in the repository.
"""

from __future__ import annotations

import argparse
import copy
import hashlib
import inspect
import json
import random
import re
import subprocess
import tempfile
from dataclasses import dataclass
from functools import lru_cache
from pathlib import Path

from jsonschema import Draft202012Validator

from conditions import (
    AuthorityBoundaryViolation,
    CanonicalizationIdentityMismatch,
    CanonicalPopulationMismatch,
    RendererContractViolation,
    RequestCustodyViolation,
    TargetVisibilityViolation,
    TrancheBMutationNotExercised,
)
from util import PACKET_ROOT, canonical_json_bytes, jsonl_bytes, sha256_bytes, sha256_file, write_new_bytes


SCHEMA_PATH = PACKET_ROOT / "schemas/tranche-b.schema.json"
CANDIDATE_ROOT = PACKET_ROOT / "items/candidate"
TARGET_PATH = CANDIDATE_ROOT / "target-visible/items.jsonl"
CONTROL_ROOT = CANDIDATE_ROOT / "control-plane"
ITEM_RECORDS_PATH = CONTROL_ROOT / "item-records.jsonl"
HIDDEN_PATH = CONTROL_ROOT / "hidden-metadata.jsonl"
SOURCE_MANIFESTS_PATH = CONTROL_ROOT / "source-packet-manifests.jsonl"
OBLIGATIONS_PATH = CONTROL_ROOT / "rendering-obligations.jsonl"
ANCESTRY_PATH = CONTROL_ROOT / "ancestry-prior-exposure.jsonl"
OWNER_ACCEPTANCE_PATH = CONTROL_ROOT / "owner-content-acceptance.json"
BANK_MANIFEST_PATH = CONTROL_ROOT / "bank-manifest.json"
TRANCHE_ROOT = PACKET_ROOT / "tranche-b"
TEMPLATE_ROOT = TRANCHE_ROOT / "templates"
TEMPLATE_MANIFEST_PATH = TRANCHE_ROOT / "template-manifest.json"
SCHEDULE_PATH = TRANCHE_ROOT / "schedule.jsonl"
FREEZER_ROOT = TRANCHE_ROOT / "freezer-only"
DOSSIER_IDENTITIES_PATH = FREEZER_ROOT / "external-dossier-identities.jsonl"
DOSSIER_MANIFEST_PATH = FREEZER_ROOT / "dossier-manifest.json"
MUTATION_REGISTRY_PATH = PACKET_ROOT / "controls/tranche-b-mutations.json"
LANG_A_MUTANTS_PATH = PACKET_ROOT / "controls/tranche-b-lang-a-mutants.lisp"
VALIDATOR_DRIVER_PATH = PACKET_ROOT / "harness/validator-driver.lisp"
ODR60_PATH = PACKET_ROOT / "operator/owner-decisions/ODR-60-ADOPTED-v2.json"

EXPECTED_BASE_COMMIT = "b0ba1e99a99ec61e78f49a2f3c8b125adf837205"
EXPECTED_BASE_TREE = "5c71143f329d76c4ed02fba27cbbb481cc317b62"
CORE_ARMS = ("NL", "PERSONA", "SCAFFOLD", "LANG-A")
ALL_ARMS = CORE_ARMS + ("SHAM",)
SUBJECT_SLOTS = ("SYNTHETIC-SUBJECT-1", "SYNTHETIC-SUBJECT-2", "SYNTHETIC-SUBJECT-3")
SOURCE_SEPARATOR = b"\n"
RENDERER_VERSION = "lae-immutable-renderer/1.0.0"
FIXED_TIMESTAMP = "2000-01-01T00:00:00+00:00"
RUNTIME_ALLOWED_READ_ROOTS = (TARGET_PATH.parent.resolve(), TEMPLATE_ROOT.resolve())
RUNTIME_ALLOWED_READ_FILES = (SCHEMA_PATH.resolve(), TEMPLATE_MANIFEST_PATH.resolve(), SCHEDULE_PATH.resolve())
FORBIDDEN_DESTINATIONS = {
    "target-payload", "author-to-author-package", "grader-calibration",
    "runner-visible-record", "KEY-AUTHOR-INPUT",
}
HIDDEN_SURFACE_MARKERS = (
    "source/version/scope boundaries", "rendering requirements and invariants",
    "hidden metadata", "intended resolution", "proposed expected resolution",
    "proposed trap", "scorable opportunities", "lawful-answer sketch",
    "failing-answer sketch", "freezer-only", "owner/freezer channel only",
)
TEMPLATE_FORBIDDEN = (
    "language-a", "lang-a", "sham", "diagnostic", "trap", "family",
    "role", "allocation", "scoring", "schema", "taint", "staffing", "odr",
    "experiment label", "arm template", "emission pilot",
)


def _strict_object(pairs):
    result = {}
    for key, value in pairs:
        if key in result:
            raise CanonicalizationIdentityMismatch(f"duplicate JSON key: {key}")
        result[key] = value
    return result


def strict_json_bytes(data: bytes, label: str):
    try:
        return json.loads(data.decode("utf-8"), object_pairs_hook=_strict_object)
    except (UnicodeDecodeError, json.JSONDecodeError) as exc:
        raise CanonicalizationIdentityMismatch(f"{label}: invalid UTF-8 JSON: {exc}") from exc


def strict_json_load(path):
    return strict_json_bytes(Path(path).read_bytes(), str(path))


def strict_jsonl_load(path):
    rows = []
    for number, line in enumerate(Path(path).read_bytes().splitlines(keepends=True), 1):
        if line.strip():
            rows.append(strict_json_bytes(line, f"{path}:{number}"))
    return rows


@lru_cache(maxsize=1)
def schema_bundle():
    bundle = strict_json_load(SCHEMA_PATH)
    Draft202012Validator.check_schema(bundle)
    return bundle


def validate_schema(name: str, record):
    bundle = schema_bundle()
    if name not in bundle["$defs"]:
        raise CanonicalizationIdentityMismatch(f"unknown Tranche B schema definition: {name}")
    schema = {"$schema": bundle["$schema"], "$defs": bundle["$defs"], "$ref": f"#/$defs/{name}"}
    errors = sorted(Draft202012Validator(schema).iter_errors(record), key=lambda error: list(error.path))
    if errors:
        detail = "; ".join(f"{'/'.join(map(str, error.path)) or '<root>'}: {error.message}" for error in errors[:4])
        condition = TargetVisibilityViolation if name == "target-visible-item" else CanonicalizationIdentityMismatch
        raise condition(f"{name}: {detail}")
    return record


def line_sha256(record):
    return sha256_bytes(canonical_json_bytes(record))


def byte_object(data: bytes):
    text = data.decode("utf-8")
    if b"\r" in data or not data.endswith(b"\n"):
        raise CanonicalizationIdentityMismatch("canonical text byte object must use LF and end in exactly one LF")
    return {"encoding": "utf-8", "newline": "LF", "bytes": len(data), "sha256": sha256_bytes(data), "utf8": text}


def validate_byte_object(record, label):
    validate_schema("byte-object", record)
    data = record["utf8"].encode("utf-8")
    if b"\r" in data or not data.endswith(b"\n"):
        raise CanonicalizationIdentityMismatch(f"{label}: newline policy differs")
    if record["bytes"] != len(data) or record["sha256"] != sha256_bytes(data):
        raise CanonicalizationIdentityMismatch(f"{label}: byte count or digest differs")
    return data


def odr60_rows():
    record = strict_json_load(ODR60_PATH)
    if record.get("record_digest") != "sha256:303ec27e744521e6b25ce4c8a671139e21c7a7cd9dbaa902966519af65f279f9":
        raise CanonicalizationIdentityMismatch("ODR-60 adopted record identity differs")
    return record["exact_decision"]["item_rows"]


def source_packet_bytes(record):
    parts = [source["content"]["utf8"].encode("utf-8") for source in record["sources"]]
    parts.extend(view["content"]["utf8"].encode("utf-8") for view in record["derived_views"])
    return SOURCE_SEPARATOR.join(parts)


def target_surface_bytes(record):
    return record["task"]["utf8"].encode("utf-8") + b"\0" + source_packet_bytes(record)


def _unique_map(rows, key, label):
    values = [row[key] for row in rows]
    if len(values) != len(set(values)):
        raise CanonicalPopulationMismatch(f"duplicate {label}")
    return {row[key]: row for row in rows}


def validate_population(targets, hidden, obligations, source_manifests, ancestry, items):
    expected_rows = odr60_rows()
    expected_ids = [row["slot_id"] for row in expected_rows]
    collections = {
        "target-visible item": targets, "hidden metadata": hidden,
        "rendering obligation": obligations, "source manifest": source_manifests,
        "ancestry": ancestry, "item record": items,
    }
    maps = {}
    for label, rows in collections.items():
        ids = [row.get("item_id") for row in rows]
        if ids != expected_ids:
            missing = sorted(set(expected_ids) - set(ids))
            extra = sorted(set(ids) - set(expected_ids), key=str)
            duplicates = sorted({item_id for item_id in ids if ids.count(item_id) > 1}, key=str)
            raise CanonicalPopulationMismatch(f"{label}: missing={missing} extra={extra} duplicates={duplicates} order_exact={ids == expected_ids}")
        maps[label] = _unique_map(rows, "item_id", label)

    expected_by_id = {row["slot_id"]: row for row in expected_rows}
    target_map = maps["target-visible item"]
    hidden_map = maps["hidden metadata"]
    obligation_map = maps["rendering obligation"]
    source_map = maps["source manifest"]
    ancestry_map = maps["ancestry"]
    item_map = maps["item record"]

    for item_id in expected_ids:
        target = target_map[item_id]
        metadata = hidden_map[item_id]
        obligation = obligation_map[item_id]
        source_manifest = source_map[item_id]
        ancestry_record = ancestry_map[item_id]
        item = item_map[item_id]
        expected = expected_by_id[item_id]
        validate_schema("target-visible-item", target)
        validate_schema("hidden-metadata", metadata)
        validate_schema("rendering-obligation", obligation)
        validate_schema("source-packet-manifest", source_manifest)
        validate_schema("ancestry", ancestry_record)
        validate_schema("item-record", item)

        if metadata["family"] != expected["content_family"] or metadata["answerability_role"] != expected["answerability_role"] or metadata["tags"] != expected["tags"]:
            raise CanonicalPopulationMismatch(f"{item_id}: ODR-60 family/role/tag allocation differs")
        if item_id in {"SV-01", "NT-01"} and metadata["source_input"]["accepted_version"] != "Sol public v3 fictional replacement":
            raise CanonicalPopulationMismatch(f"{item_id}: retired Sol v2 apparatus item admitted")

        task_bytes = validate_byte_object(target["task"], f"{item_id} task")
        expected_component_ids = [f"S{number}" for number in range(1, len(target["sources"]) + 1)]
        actual_component_ids = [source["component_id"] for source in target["sources"]]
        actual_ordinals = [source["ordinal"] for source in target["sources"]]
        if actual_component_ids != expected_component_ids or actual_ordinals != list(range(1, len(actual_ordinals) + 1)):
            raise RendererContractViolation(f"{item_id}: source order differs")
        for source in target["sources"]:
            validate_byte_object(source["content"], f"{item_id} {source['component_id']}")
        for view in target["derived_views"]:
            validate_byte_object(view["content"], f"{item_id} {view['view_id']}")
            if view["parent_component_id"] not in actual_component_ids:
                raise RendererContractViolation(f"{item_id}: derived view parent missing")
        if item_id == "CR-01":
            if actual_component_ids != ["S1", "S2", "S3"] or len(target["derived_views"]) != 1:
                raise RendererContractViolation("CR-01 originals S1-S3 must remain before one derived view")
        elif target["derived_views"]:
            raise RendererContractViolation(f"{item_id}: unauthorized derived view")

        if source_manifest["component_order"] != actual_component_ids or source_manifest["component_sha256s"] != [source["content"]["sha256"] for source in target["sources"]] or source_manifest["derived_view_ids"] != [view["view_id"] for view in target["derived_views"]]:
            raise RendererContractViolation(f"{item_id}: source packet manifest differs")

        packet = source_packet_bytes(target)
        if target["source_packet_sha256"] != sha256_bytes(packet) or target["target_surface_sha256"] != sha256_bytes(task_bytes + b"\0" + packet):
            raise CanonicalizationIdentityMismatch(f"{item_id}: target surface digest differs")
        if source_manifest["component_order"] != actual_component_ids or source_manifest["component_sha256s"] != [source["content"]["sha256"] for source in target["sources"]] or source_manifest["derived_view_ids"] != [view["view_id"] for view in target["derived_views"]] or source_manifest["source_packet_sha256"] != target["source_packet_sha256"]:
            raise RendererContractViolation(f"{item_id}: source packet manifest differs")

        target_text = (task_bytes + packet).decode("utf-8").casefold()
        for marker in HIDDEN_SURFACE_MARKERS:
            if marker in target_text:
                raise TargetVisibilityViolation(f"{item_id}: hidden marker leaked: {marker}")
        if "apparatus-based" in target_text and item_id in {"SV-01", "NT-01"}:
            raise TargetVisibilityViolation(f"{item_id}: retired v2 apparatus bytes leaked")

        expected_links = {
            "target_visible_line_sha256": line_sha256(target),
            "hidden_metadata_line_sha256": line_sha256(metadata),
            "rendering_obligation_line_sha256": line_sha256(obligation),
            "source_packet_manifest_line_sha256": line_sha256(source_manifest),
            "ancestry_line_sha256": line_sha256(ancestry_record),
        }
        if any(item[field] != digest for field, digest in expected_links.items()):
            raise CanonicalizationIdentityMismatch(f"{item_id}: item parent linkage differs")
    return maps


def validate_external_dossier_identities(identities, manifest, expected_ids):
    expected_sources = {
        "Fable": ("FABLE-PRIVATE-FREEZER-NOTES-v1.md", "ca7c1dd76793124bb74eb5fd9af9f3d5f3925c6cb58f88f247d0265a71c72c8e", "Fable public v1.1 owner-accepted"),
        "Sol": ("SOL-PRIVATE-FREEZER-NOTES-v3.md", "799c4f7186519d750b09c05a61403be58ba07b1a79a3af8cd8411d4d10e0e41f", "Sol public v3 fictional replacement"),
    }
    for identity in identities:
        forbidden_content_fields = {
            "private_text", "owner_private_content", "intended_resolution",
            "trap_description", "scorable_opportunities", "lawful_sketch",
            "failing_sketch", "source_locator_deliberation",
        }
        if forbidden_content_fields.intersection(identity):
            raise TargetVisibilityViolation(f"{identity.get('item_id')}: private dossier content field entered Git identity record")
        validate_schema("external-dossier-identity", identity)
        item_id = identity["item_id"]
        if identity["dossier_id"] != f"owner-private-dossier:{item_id}:v1":
            raise CanonicalizationIdentityMismatch(f"{item_id}: external dossier ID differs")
        source_key = "Fable" if item_id.startswith(("BS", "CR")) else "Sol"
        filename, source_sha256, item_version = expected_sources[source_key]
        expected_source = {
            "author_id": f"author-source:{source_key}",
            "source_filename": filename,
            "source_sha256": source_sha256,
        }
        if identity["author_source_identity"] != expected_source or identity["item_version"] != item_version:
            raise CanonicalizationIdentityMismatch(f"{item_id}: external dossier source/version identity differs")
        if set(identity["excluded_from"]) != FORBIDDEN_DESTINATIONS:
            raise TargetVisibilityViolation(f"{item_id}: freezer exclusions differ")
    identity_map = _unique_map(identities, "item_id", "external freezer dossier identity")
    if list(identity_map) != expected_ids:
        raise CanonicalPopulationMismatch("external freezer dossier identity population/order differs")
    validate_schema("freezer-manifest", manifest)
    expected_entries = [{
        "dossier_id": identity_map[item_id]["dossier_id"],
        "item_id": item_id,
        "identity_line_sha256": line_sha256(identity_map[item_id]),
    } for item_id in expected_ids]
    if manifest["identity_records"] != expected_entries or manifest["item_ids"] != expected_ids:
        raise CanonicalizationIdentityMismatch("external freezer dossier identity manifest differs")
    if manifest["identities_sha256"] != sha256_bytes(jsonl_bytes(identities)):
        raise CanonicalizationIdentityMismatch("external freezer dossier identity-set digest differs")


def _derived_totals(hidden):
    totals = {"family_counts": {}, "role_counts": {}, "tag_counts": {}}
    for record in hidden:
        for field, output in (("family", "family_counts"), ("answerability_role", "role_counts")):
            value = record[field]
            totals[output][value] = totals[output].get(value, 0) + 1
        for tag in record["tags"]:
            totals["tag_counts"][tag] = totals["tag_counts"].get(tag, 0) + 1
    return {key: dict(sorted(value.items())) for key, value in totals.items()}


def load_bank(root=PACKET_ROOT):
    paths = {
        "targets": Path(root) / TARGET_PATH.relative_to(PACKET_ROOT),
        "hidden": Path(root) / HIDDEN_PATH.relative_to(PACKET_ROOT),
        "obligations": Path(root) / OBLIGATIONS_PATH.relative_to(PACKET_ROOT),
        "source_manifests": Path(root) / SOURCE_MANIFESTS_PATH.relative_to(PACKET_ROOT),
        "ancestry": Path(root) / ANCESTRY_PATH.relative_to(PACKET_ROOT),
        "items": Path(root) / ITEM_RECORDS_PATH.relative_to(PACKET_ROOT),
    }
    data = {name: strict_jsonl_load(path) for name, path in paths.items()}
    maps = validate_population(**data)
    owner = strict_json_load(Path(root) / OWNER_ACCEPTANCE_PATH.relative_to(PACKET_ROOT))
    manifest = strict_json_load(Path(root) / BANK_MANIFEST_PATH.relative_to(PACKET_ROOT))
    dossier_identities = strict_jsonl_load(Path(root) / DOSSIER_IDENTITIES_PATH.relative_to(PACKET_ROOT))
    dossier_manifest = strict_json_load(Path(root) / DOSSIER_MANIFEST_PATH.relative_to(PACKET_ROOT))
    validate_schema("owner-acceptance", owner)
    validate_schema("bank-manifest", manifest)
    expected_ids = [row["slot_id"] for row in odr60_rows()]
    if owner["accepted_item_ids"] != expected_ids or manifest["item_ids"] != expected_ids:
        raise CanonicalPopulationMismatch("owner acceptance or bank manifest population differs")
    if manifest["derived_totals"] != _derived_totals(data["hidden"]):
        raise CanonicalPopulationMismatch("bank derived totals differ from item rows")
    expected_totals = {
        "family_counts": {"BOUNDED-SUPPORT": 6, "CONFLICT-AND-RESIDUE": 6, "NOTATION-NEUTRAL-TRANSFER": 6, "SCOPE-AND-VERSION": 6},
        "role_counts": {"DELIBERATE-INSUFFICIENCY": 8, "MIXED-BOUNDED-CONTROL": 8, "POSITIVE-CONCLUSION": 8},
        "tag_counts": {"DOMAIN-NATIVE-NON-LANG-A-RENDERABLE": 8, "EASY-BOUNDED-CONTROL": 4, "SHAM-DESIGNATED": 8, "STRONG-CONCLUSION-CONTROL": 4, "TRAP-BEARING": 12},
    }
    if manifest["derived_totals"] != expected_totals:
        raise CanonicalPopulationMismatch("owner-disposition totals differ")
    validate_external_dossier_identities(dossier_identities, dossier_manifest, expected_ids)
    for target in data["targets"]:
        item_id = target["item_id"]
        target_bytes = target["task"]["utf8"].encode("utf-8") + source_packet_bytes(target)
        exact_hidden_spans = (
            maps["hidden metadata"][item_id]["source_version_scope_boundaries"]["utf8"].encode("utf-8"),
            maps["rendering obligation"][item_id]["requirements"]["utf8"].encode("utf-8"),
        )
        if any(span in target_bytes for span in exact_hidden_spans):
            raise TargetVisibilityViolation(f"{item_id}: exact hidden byte span leaked")
    return {
        **data, "maps": maps, "owner": owner, "manifest": manifest,
        "dossier_identities": dossier_identities, "dossier_manifest": dossier_manifest,
    }


def validate_template_files(root=PACKET_ROOT):
    root = Path(root)
    manifest_path = root / TEMPLATE_MANIFEST_PATH.relative_to(PACKET_ROOT)
    manifest = strict_json_load(manifest_path)
    validate_schema("template-manifest", manifest)
    entries = {entry["arm"]: entry for entry in manifest["templates"]}
    if tuple(entries) != ALL_ARMS:
        raise RendererContractViolation("template arm set/order differs")
    files = {}
    system_entry = manifest["system"]
    wrapper_entry = manifest["wrapper"]
    for label, entry in [("system", system_entry), ("wrapper", wrapper_entry), *entries.items()]:
        path = root / entry["path"]
        data = path.read_bytes()
        if b"\r" in data or not data.endswith(b"\n") or entry.get("bytes") != len(data) or entry.get("sha256") != sha256_bytes(data):
            raise RendererContractViolation(f"{label}: stale template identity")
        files[label] = data
    wrapper = files["wrapper"]
    if wrapper.count(b"{{TASK}}") != 1 or wrapper.count(b"{{SOURCE_PACKET}}") != 1:
        raise RendererContractViolation("wrapper placeholders differ")
    for label, data in files.items():
        visible = data.decode("utf-8").casefold()
        for forbidden in TEMPLATE_FORBIDDEN:
            if re.search(rf"(?<![a-z0-9]){re.escape(forbidden)}(?![a-z0-9])", visible):
                raise TargetVisibilityViolation(f"{label}: visible label {forbidden}")
    if b"JUDGMENT" in files["SCAFFOLD"].upper() or b"(:" in files["SCAFFOLD"]:
        raise TargetVisibilityViolation("Scaffold names or imitates the structured record")
    scaffold, language = files["SCAFFOLD"], files["LANG-A"]
    byte_gap = abs(len(scaffold) - len(language)) / len(language)
    word_gap = abs(len(scaffold.decode().split()) - len(language.decode().split())) / len(language.decode().split())
    if byte_gap > 0.10 or word_gap > 0.10:
        raise RendererContractViolation(f"Scaffold/structured parity differs: bytes={byte_gap:.3f} words={word_gap:.3f}")
    return manifest, files


@dataclass(frozen=True)
class TargetVisibleItem:
    item_id: str
    task: bytes
    sources: tuple[bytes, ...]
    derived_views: tuple[bytes, ...]
    task_sha256: str
    source_packet_sha256: str
    target_surface_sha256: str

    @classmethod
    def from_record(cls, record):
        validate_schema("target-visible-item", record)
        task = validate_byte_object(record["task"], f"{record['item_id']} task")
        sources = tuple(validate_byte_object(source["content"], f"{record['item_id']} {source['component_id']}") for source in record["sources"])
        views = tuple(validate_byte_object(view["content"], f"{record['item_id']} {view['view_id']}") for view in record["derived_views"])
        instance = cls(record["item_id"], task, sources, views, record["task"]["sha256"], record["source_packet_sha256"], record["target_surface_sha256"])
        if sha256_bytes(instance.source_packet) != instance.source_packet_sha256:
            raise CanonicalizationIdentityMismatch(f"{instance.item_id}: source packet differs")
        return instance

    @property
    def source_packet(self):
        return SOURCE_SEPARATOR.join((*self.sources, *self.derived_views))


def compose_payload(item: TargetVisibleItem, system_bytes: bytes, template_bytes: bytes, wrapper_bytes: bytes):
    if not isinstance(item, TargetVisibleItem):
        raise TargetVisibilityViolation("payload composer accepts TargetVisibleItem only")
    if wrapper_bytes.count(b"{{TASK}}") != 1 or wrapper_bytes.count(b"{{SOURCE_PACKET}}") != 1:
        raise RendererContractViolation("wrapper placeholder cardinality differs")
    if b"{{TASK}}" in item.task or b"{{SOURCE_PACKET}}" in item.source_packet:
        raise RendererContractViolation("target bytes collide with wrapper placeholders")
    rendered_wrapper = wrapper_bytes.replace(b"{{TASK}}", item.task).replace(b"{{SOURCE_PACKET}}", item.source_packet)
    payload = system_bytes + b"\n" + template_bytes + b"\n" + rendered_wrapper
    if b"\r" in payload:
        raise RendererContractViolation("payload newline policy differs")
    return payload


def schedule_material(row):
    return {key: value for key, value in row.items() if key != "schedule_row_sha256"}


def validate_schedule(rows, bank, template_manifest):
    if len(rows) != 312:
        raise RequestCustodyViolation(f"schedule count {len(rows)} != 312")
    target_map = bank["maps"]["target-visible item"]
    metadata_map = bank["maps"]["hidden metadata"]
    obligation_map = bank["maps"]["rendering obligation"]
    templates = {entry["arm"]: entry for entry in template_manifest["templates"]}
    cells = []
    expected_sham = {item_id for item_id, record in metadata_map.items() if "SHAM-DESIGNATED" in record["tags"]}
    for index, row in enumerate(rows, 1):
        try:
            validate_schema("schedule-row", row)
        except CanonicalizationIdentityMismatch as exc:
            raise RequestCustodyViolation(str(exc)) from exc
        if row["schedule_index"] != index or row["call_id"] != f"TRANCHE-B-CALL-{index:06d}":
            raise RequestCustodyViolation("schedule index/call identity differs")
        if row["schedule_row_sha256"] != sha256_bytes(canonical_json_bytes(schedule_material(row))):
            raise CanonicalizationIdentityMismatch(f"{row['call_id']}: schedule binding digest differs")
        item_id, arm = row["item_id"], row["arm"]
        if item_id not in target_map or arm not in ALL_ARMS:
            raise RequestCustodyViolation(f"{row['call_id']}: unauthorized item or arm")
        if arm == "SHAM" and item_id not in expected_sham:
            raise RequestCustodyViolation(f"{row['call_id']}: non-designated decorative cell")
        target = target_map[item_id]
        if row["target_surface_sha256"] != target["target_surface_sha256"] or row["source_packet_sha256"] != target["source_packet_sha256"] or row["template_sha256"] != templates[arm]["sha256"] or row["wrapper_sha256"] != template_manifest["wrapper"]["sha256"] or row["rendering_obligation_sha256"] != line_sha256(obligation_map[item_id]):
            raise RequestCustodyViolation(f"{row['call_id']}: parent rendering identity differs")
        cells.append((item_id, arm, row["subject_slot"]))
    if len(cells) != len(set(cells)):
        raise RequestCustodyViolation("duplicate request cell")
    expected_cells = {(item_id, arm, subject) for item_id in target_map for subject in SUBJECT_SLOTS for arm in CORE_ARMS}
    expected_cells |= {(item_id, "SHAM", subject) for item_id in expected_sham for subject in SUBJECT_SLOTS}
    if set(cells) != expected_cells:
        missing = len(expected_cells - set(cells)); extra = len(set(cells) - expected_cells)
        raise RequestCustodyViolation(f"schedule population differs: missing={missing} extra={extra}")
    return rows


class RuntimeReadBoundary:
    def __init__(self):
        self.reads = []

    def read_bytes(self, path):
        candidate = Path(path).resolve()
        allowed = candidate in RUNTIME_ALLOWED_READ_FILES or any(candidate == root or root in candidate.parents for root in RUNTIME_ALLOWED_READ_ROOTS)
        forbidden_name = candidate.name in {"private-score-key.json", "KEY-AUTHOR-INPUT.json"} or FREEZER_ROOT.resolve() in candidate.parents
        if forbidden_name or not allowed:
            raise AuthorityBoundaryViolation(f"runtime read denied: {candidate}")
        self.reads.append(candidate)
        return candidate.read_bytes()


def runtime_jsonl(boundary, path):
    data = boundary.read_bytes(path)
    rows = []
    for number, line in enumerate(data.splitlines(keepends=True), 1):
        if line.strip():
            rows.append(strict_json_bytes(line, f"{path}:{number}"))
    return rows


class NetworkOffProvider:
    network_capable = False
    provider_id = "provider:deterministic-network-off"
    model_id = "network-off/sentinel-v1"

    def emit(self, envelope_bytes, payload_bytes, call_id):
        if self.network_capable:
            raise AuthorityBoundaryViolation("network-capable provider path denied")
        request_digest = sha256_bytes(envelope_bytes)
        payload_digest = sha256_bytes(payload_bytes)
        artifact = {
            "call_id": call_id,
            "content": "NETWORK OFF — no target response produced",
            "kind": "network-off-custody-sentinel",
            "payload_sha256": payload_digest,
            "request_envelope_sha256": request_digest,
            "target_evidence": False,
        }
        raw = canonical_json_bytes(artifact)
        provider_request_id = "network-off-" + sha256_bytes(call_id.encode("utf-8") + b"\0" + envelope_bytes + b"\0" + payload_bytes)[:24]
        return raw, provider_request_id


def _template_entry_map(manifest):
    return {entry["arm"]: entry for entry in manifest["templates"]}


def rendered_payload_record(row, item, payload, manifest, output_relative):
    template_entry = _template_entry_map(manifest)[row["arm"]]
    return {
        "schema_version": "lae-rendered-request-payload/1.0.0",
        "call_id": row["call_id"], "item_id": row["item_id"],
        "encoding": "utf-8", "newline": "LF", "payload_path": output_relative,
        "payload_bytes": len(payload), "payload_sha256": sha256_bytes(payload),
        "task_sha256": item.task_sha256, "source_packet_sha256": item.source_packet_sha256,
        "template_sha256": template_entry["sha256"], "wrapper_sha256": manifest["wrapper"]["sha256"],
        "system_sha256": manifest["system"]["sha256"],
        "segment_origins": ["common-system", "selected-template", "common-wrapper", "target-visible-task", "target-visible-source-packet"],
    }


def make_envelope(row, payload_record):
    return {
        "schema_version": "lae-request-metadata-envelope/1.0.0",
        "run_id": "LAE-TRANCHE-B-NETWORK-OFF-001", "call_id": row["call_id"],
        "schedule_index": row["schedule_index"], "schedule_row_sha256": row["schedule_row_sha256"],
        "item_id": row["item_id"], "arm": row["arm"], "subject_slot": row["subject_slot"],
        "provider_id": NetworkOffProvider.provider_id, "model_id_requested": NetworkOffProvider.model_id,
        "parameters": {"network": False, "tools": False, "temperature": 0, "seed": 0},
        "rendering": {
            "version": RENDERER_VERSION, "payload_sha256": payload_record["payload_sha256"],
            "payload_bytes": payload_record["payload_bytes"], "template_sha256": payload_record["template_sha256"],
            "wrapper_sha256": payload_record["wrapper_sha256"], "task_sha256": payload_record["task_sha256"],
            "source_packet_sha256": payload_record["source_packet_sha256"],
            "rendering_obligation_sha256": row["rendering_obligation_sha256"],
        },
        "attempt": 1, "retry_parent": None, "timestamp": FIXED_TIMESTAMP,
    }


def normalize_response(raw_bytes, raw_response_record):
    native = strict_json_bytes(raw_bytes, raw_response_record["call_id"] + " raw response")
    return {
        "schema_version": "lae-normalized-response-successor/1.0.0",
        "call_id": raw_response_record["call_id"],
        "raw_response_record_sha256": line_sha256(raw_response_record),
        "raw_response_sha256": sha256_bytes(raw_bytes),
        "condition_neutral_scoring_view": {"state": "unresolved-not-scored", "content": native["content"]},
        "native_artifact_view": {"media_type": "application/json", "content": native},
    }


def _write_record(path, schema_name, record):
    validate_schema(schema_name, record)
    write_new_bytes(path, canonical_json_bytes(record))


def execute_network_off(output_dir, provider=None):
    output = Path(output_dir)
    if output.exists() and any(output.iterdir()):
        raise RequestCustodyViolation("network-off output directory must be fresh")
    output.mkdir(parents=True, exist_ok=True)
    provider = provider or NetworkOffProvider()
    if provider.network_capable:
        raise AuthorityBoundaryViolation("network-capable provider path denied")

    boundary = RuntimeReadBoundary()
    # The runtime deliberately does not call load_bank(): that control-plane
    # validator reads hidden records and external dossier identities.
    target_rows = runtime_jsonl(boundary, TARGET_PATH)
    target_map = _unique_map(target_rows, "item_id", "runtime target item")
    for record in target_rows:
        validate_schema("target-visible-item", record)
    schedule = runtime_jsonl(boundary, SCHEDULE_PATH)
    manifest = strict_json_bytes(boundary.read_bytes(TEMPLATE_MANIFEST_PATH), str(TEMPLATE_MANIFEST_PATH))
    validate_schema("template-manifest", manifest)
    system = boundary.read_bytes(PACKET_ROOT / manifest["system"]["path"])
    wrapper = boundary.read_bytes(PACKET_ROOT / manifest["wrapper"]["path"])
    template_entries = _template_entry_map(manifest)
    templates = {arm: boundary.read_bytes(PACKET_ROOT / entry["path"]) for arm, entry in template_entries.items()}

    if len(schedule) != 312:
        raise RequestCustodyViolation("runtime schedule is not 312 rows")
    records = []
    for row in schedule:
        validate_schema("schedule-row", row)
        item = TargetVisibleItem.from_record(target_map[row["item_id"]])
        template = templates[row["arm"]]
        if sha256_bytes(template) != row["template_sha256"] or sha256_bytes(wrapper) != row["wrapper_sha256"]:
            raise RendererContractViolation(f"{row['call_id']}: runtime template identity differs")
        payload = compose_payload(item, system, template, wrapper)
        payload_rel = f"payloads/{row['call_id']}.bin"
        payload_record_rel = f"rendered/{row['call_id']}.json"
        envelope_rel = f"requests/{row['call_id']}.json"
        raw_rel = f"raw-responses/{row['call_id']}.bin"
        raw_record_rel = f"responses/{row['call_id']}.json"
        normalized_rel = f"normalized/{row['call_id']}.json"
        attempt_rel = f"attempts/{row['call_id']}.json"

        payload_record = rendered_payload_record(row, item, payload, manifest, payload_rel)
        validate_schema("rendered-payload", payload_record)
        envelope = make_envelope(row, payload_record)
        validate_schema("request-envelope", envelope)
        envelope_bytes = canonical_json_bytes(envelope)
        if sha256_bytes(envelope_bytes) == payload_record["payload_sha256"]:
            raise RequestCustodyViolation("payload digest confused with envelope digest")
        raw, provider_request_id = provider.emit(envelope_bytes, payload, row["call_id"])
        raw_record = {
            "schema_version": "lae-raw-response-custody/1.0.0", "call_id": row["call_id"],
            "request_envelope_path": envelope_rel, "request_envelope_sha256": sha256_bytes(envelope_bytes),
            "request_payload_path": payload_rel, "request_payload_sha256": sha256_bytes(payload),
            "raw_response_path": raw_rel, "raw_response_bytes": len(raw), "raw_response_sha256": sha256_bytes(raw),
            "provider_request_id": provider_request_id, "model_id_returned": provider.model_id,
            "status": "completed-network-off", "finish_reason": "network-off",
            "usage": {"state": "not-applicable", "input_tokens": None, "output_tokens": None},
            "cost": {"state": "not-applicable", "amount_usd": None, "price_table_version": None},
            "retry_parent": None, "started_at": FIXED_TIMESTAMP, "completed_at": FIXED_TIMESTAMP,
            "target_evidence": False,
        }
        validate_schema("raw-response", raw_record)
        normalized = normalize_response(raw, raw_record)
        validate_schema("normalized-response", normalized)
        attempt = {
            "schema_version": "lae-attempt-record/1.0.0", "call_id": row["call_id"], "attempt": 1,
            "retry_parent": None, "request_envelope_sha256": sha256_bytes(envelope_bytes),
            "raw_response_record_sha256": line_sha256(raw_record),
            "normalized_response_record_sha256": line_sha256(normalized),
        }
        validate_schema("attempt", attempt)

        write_new_bytes(output / payload_rel, payload)
        _write_record(output / payload_record_rel, "rendered-payload", payload_record)
        _write_record(output / envelope_rel, "request-envelope", envelope)
        write_new_bytes(output / raw_rel, raw)
        _write_record(output / raw_record_rel, "raw-response", raw_record)
        _write_record(output / normalized_rel, "normalized-response", normalized)
        _write_record(output / attempt_rel, "attempt", attempt)
        records.append({
            "call_id": row["call_id"], "schedule_index": row["schedule_index"], "item_id": row["item_id"],
            "arm": row["arm"], "subject_slot": row["subject_slot"], "payload_sha256": sha256_bytes(payload),
            "request_envelope_sha256": sha256_bytes(envelope_bytes), "raw_response_record_sha256": line_sha256(raw_record),
            "normalized_response_record_sha256": line_sha256(normalized), "attempt_record_sha256": line_sha256(attempt),
        })
    census = {
        "schema_version": "lae-tranche-b-run-census/1.0.0", "complete": True,
        "expected": 312, "observed": len(records), "network_calls": 0,
        "network_off_emissions": len(records), "provider_calls": 0, "target_outputs": 0,
        "scoring_runs": 0, "records": records,
    }
    validate_census(census, schedule)
    _write_record(output / "census.json", "census", census)
    return census, boundary.reads


def validate_census(census, schedule):
    try:
        validate_schema("census", census)
    except CanonicalizationIdentityMismatch as exc:
        raise RequestCustodyViolation(str(exc)) from exc
    cells = [(row["item_id"], row["arm"], row["subject_slot"]) for row in census["records"]]
    if len(cells) != len(set(cells)):
        raise RequestCustodyViolation("census contains duplicate request cell")
    expected = [(row["item_id"], row["arm"], row["subject_slot"]) for row in schedule]
    if cells != expected:
        raise RequestCustodyViolation("census does not equal fixed schedule")
    if census["expected"] != census["observed"] or census["observed"] != len(census["records"]):
        raise RequestCustodyViolation("census false completion")
    return census


def validate_run_output(output_dir):
    output = Path(output_dir)
    census = strict_json_load(output / "census.json")
    schedule = strict_jsonl_load(SCHEDULE_PATH)
    validate_census(census, schedule)
    for summary in census["records"]:
        call_id = summary["call_id"]
        payload = (output / f"payloads/{call_id}.bin").read_bytes()
        payload_record = strict_json_load(output / f"rendered/{call_id}.json")
        envelope_path = output / f"requests/{call_id}.json"
        envelope = strict_json_load(envelope_path)
        raw = (output / f"raw-responses/{call_id}.bin").read_bytes()
        raw_record = strict_json_load(output / f"responses/{call_id}.json")
        normalized = strict_json_load(output / f"normalized/{call_id}.json")
        attempt = strict_json_load(output / f"attempts/{call_id}.json")
        for name, record in (("rendered-payload", payload_record), ("request-envelope", envelope), ("raw-response", raw_record), ("normalized-response", normalized), ("attempt", attempt)):
            validate_schema(name, record)
        if sha256_bytes(payload) != payload_record["payload_sha256"] or sha256_bytes(payload) != envelope["rendering"]["payload_sha256"]:
            raise RequestCustodyViolation(f"{call_id}: payload parent closure differs")
        if sha256_file(envelope_path) != raw_record["request_envelope_sha256"] or sha256_bytes(payload) != raw_record["request_payload_sha256"]:
            raise RequestCustodyViolation(f"{call_id}: raw request parent closure differs")
        if sha256_bytes(raw) != raw_record["raw_response_sha256"] or normalized["raw_response_sha256"] != raw_record["raw_response_sha256"] or normalized["raw_response_record_sha256"] != line_sha256(raw_record):
            raise RequestCustodyViolation(f"{call_id}: normalization raw parent closure differs")
        if attempt["raw_response_record_sha256"] != line_sha256(raw_record) or attempt["normalized_response_record_sha256"] != line_sha256(normalized):
            raise RequestCustodyViolation(f"{call_id}: attempt closure differs")
        expected_summary = {
            "payload_sha256": sha256_bytes(payload), "request_envelope_sha256": sha256_file(envelope_path),
            "raw_response_record_sha256": line_sha256(raw_record), "normalized_response_record_sha256": line_sha256(normalized),
            "attempt_record_sha256": line_sha256(attempt),
        }
        if any(summary[key] != value for key, value in expected_summary.items()):
            raise RequestCustodyViolation(f"{call_id}: census digest differs")
    forbidden_paths = [path for path in output.rglob("*") if path.is_file() and ("score" in path.name.casefold() or "private-key" in path.name.casefold() or "key-author-input" in path.name.casefold())]
    if forbidden_paths:
        raise AuthorityBoundaryViolation("forbidden run artifact created")
    return census


def file_manifest(root):
    root = Path(root)
    return [{"path": path.relative_to(root).as_posix(), "bytes": path.stat().st_size, "sha256": sha256_file(path)} for path in sorted(root.rglob("*")) if path.is_file()]


def run_two_clean_replays():
    with tempfile.TemporaryDirectory(prefix="lae-tranche-b-a-") as first, tempfile.TemporaryDirectory(prefix="lae-tranche-b-b-") as second:
        census_a, reads_a = execute_network_off(Path(first) / "run")
        census_b, reads_b = execute_network_off(Path(second) / "run")
        validate_run_output(Path(first) / "run")
        validate_run_output(Path(second) / "run")
        manifest_a = file_manifest(Path(first) / "run")
        manifest_b = file_manifest(Path(second) / "run")
        if manifest_a != manifest_b:
            raise RendererContractViolation("two clean network-off runs are not byte-identical")
        forbidden_reads = [path for path in (*reads_a, *reads_b) if FREEZER_ROOT.resolve() in path.parents or path.name in {"private-score-key.json", "KEY-AUTHOR-INPUT.json"}]
        if forbidden_reads:
            raise AuthorityBoundaryViolation("runtime read a forbidden private surface")
        return {
            "census_sha256": sha256_bytes(canonical_json_bytes(census_a)),
            "file_count": len(manifest_a), "file_manifest_sha256": sha256_bytes(canonical_json_bytes(manifest_a)),
            "payload_digest_count": len({row["payload_sha256"] for row in census_a["records"]}),
            "request_envelope_digest_count": len({row["request_envelope_sha256"] for row in census_a["records"]}),
            "runtime_read_paths": sorted({path.relative_to(PACKET_ROOT).as_posix() for path in reads_a}),
            "byte_identical": True, "network_calls": 0, "provider_calls": 0, "target_outputs": 0, "scoring_runs": 0,
        }


def validate_lang_a_mutants():
    result = subprocess.run(
        ["sbcl", "--script", str(VALIDATOR_DRIVER_PATH), "--records", str(LANG_A_MUTANTS_PATH)],
        cwd=PACKET_ROOT, check=True, capture_output=True, text=True,
    )
    rows = {}
    for line in result.stdout.splitlines():
        if line.startswith("DRIVER|"):
            fields = line.split("|")
            rows[fields[1]] = {"expected": fields[3], "observed": fields[4], "check": fields[5]}
    expected_names = {"TB-LANG-A-LAWFUL", "TB-LANG-A-MISSING-CLAIM", "TB-LANG-A-DANGLING-SUPPORT", "TB-LANG-A-CONFIDENCE"}
    if set(rows) != expected_names or any(row["expected"] != row["observed"] for row in rows.values()):
        raise RendererContractViolation(f"Language-A skeleton/mutations differ: {rows}")
    return rows


def validate_mutation_registry_contract(registry, handler_ids):
    declared = [row["mutation_id"] for row in registry.get("mutations", [])]
    if len(declared) != len(set(declared)):
        raise TrancheBMutationNotExercised("duplicate mutation declaration")
    if registry.get("declared_unexecuted") or registry.get("undeclared_executed"):
        raise TrancheBMutationNotExercised("registry carries declared/executed discrepancy")
    if set(declared) != set(handler_ids):
        missing = sorted(set(declared) - set(handler_ids)); extra = sorted(set(handler_ids) - set(declared))
        raise TrancheBMutationNotExercised(f"declared/handler mismatch missing={missing} extra={extra}")


def _expect_failure(callable_, expected):
    try:
        callable_()
    except expected as exc:
        return exc.condition
    except Exception as exc:
        raise TrancheBMutationNotExercised(f"wrong condition {type(exc).__name__}: {exc}") from exc
    raise TrancheBMutationNotExercised(f"mutation survived; expected {expected.__name__}")


def _mutation_handlers(bank, template_manifest, template_files, schedule):
    baseline = {key: bank[key] for key in ("targets", "hidden", "obligations", "source_manifests", "ancestry", "items")}

    def population_mutation(collection, mutate):
        def run():
            candidate = copy.deepcopy(baseline)
            mutate(candidate[collection])
            validate_population(**candidate)
        return run

    def metadata_mutation(field, value):
        return population_mutation("hidden", lambda rows: rows[0].__setitem__(field, value))

    def target_leak(key, value):
        def run():
            record = copy.deepcopy(bank["targets"][0]); record[key] = value
            validate_schema("target-visible-item", record)
        return run

    def template_mutation(arm, suffix):
        def run():
            mutated = copy.deepcopy(template_files)
            mutated[arm] += suffix
            visible = mutated[arm].decode("utf-8").casefold()
            for forbidden in TEMPLATE_FORBIDDEN:
                if re.search(rf"(?<![a-z0-9]){re.escape(forbidden)}(?![a-z0-9])", visible):
                    raise TargetVisibilityViolation(f"mutated template leaked {forbidden}")
            if sha256_bytes(mutated[arm]) != _template_entry_map(template_manifest)[arm]["sha256"]:
                raise RendererContractViolation("stale template identity")
        return run

    def source_order():
        candidate = copy.deepcopy(baseline); candidate["targets"][0]["sources"].reverse(); validate_population(**candidate)

    def source_omitted():
        candidate = copy.deepcopy(baseline); candidate["targets"][0]["sources"].pop(); validate_population(**candidate)

    def source_altered():
        candidate = copy.deepcopy(baseline); candidate["targets"][0]["sources"][0]["content"]["utf8"] += "x\n"; validate_population(**candidate)

    def hidden_read():
        item = TargetVisibleItem.from_record(bank["targets"][0])
        try:
            compose_payload(item, template_files["system"], template_files["NL"], template_files["wrapper"], hidden_metadata=bank["hidden"][0])
        except TypeError as exc:
            raise TargetVisibilityViolation("payload composer has no hidden-metadata parameter") from exc

    def cr01_replaced():
        candidate = copy.deepcopy(baseline); cr = next(row for row in candidate["targets"] if row["item_id"] == "CR-01"); cr["sources"] = cr["sources"][1:]; validate_population(**candidate)

    def nondeterministic():
        item = TargetVisibleItem.from_record(bank["targets"][0])
        first = compose_payload(item, template_files["system"], template_files["NL"], template_files["wrapper"])
        second = first + b"mutation"
        if first != second:
            raise RendererContractViolation("rendering differs for identical inputs")

    def digest_confusion():
        item = TargetVisibleItem.from_record(bank["targets"][0])
        payload = compose_payload(item, template_files["system"], template_files["NL"], template_files["wrapper"])
        envelope = canonical_json_bytes({"payload_sha256": sha256_bytes(payload)})
        claimed_envelope = sha256_bytes(payload)
        if claimed_envelope != sha256_bytes(envelope):
            raise RequestCustodyViolation("payload digest used as envelope digest")

    def normalization_without_parent():
        record = {"schema_version": "lae-normalized-response-successor/1.0.0", "call_id": "x", "raw_response_sha256": "0" * 64, "condition_neutral_scoring_view": {"state": "unresolved-not-scored", "content": "x"}, "native_artifact_view": {"media_type": "application/json", "content": {}}}
        try:
            validate_schema("normalized-response", record)
        except CanonicalizationIdentityMismatch as exc:
            raise RequestCustodyViolation(str(exc)) from exc

    def census_mutation(kind):
        def run():
            with tempfile.TemporaryDirectory(prefix="lae-tb-mut-") as temporary:
                census, _ = execute_network_off(Path(temporary) / "run")
                mutated = copy.deepcopy(census)
                if kind == "count": mutated["observed"] = 311
                elif kind == "duplicate": mutated["records"][1] = copy.deepcopy(mutated["records"][0])
                elif kind == "missing": mutated["records"].pop(); mutated["observed"] = 311
                validate_census(mutated, schedule)
        return run

    def unauthorized_arm(label):
        mutated = copy.deepcopy(schedule); mutated[0]["arm"] = label; validate_schedule(mutated, bank, template_manifest)

    def key_read():
        RuntimeReadBoundary().read_bytes(PACKET_ROOT / "scoring/private-score-key.json")

    def network_provider():
        provider = NetworkOffProvider(); provider.network_capable = True
        with tempfile.TemporaryDirectory(prefix="lae-tb-net-") as temporary:
            execute_network_off(Path(temporary) / "run", provider=provider)

    def external_identity_population(kind):
        identities = copy.deepcopy(bank["dossier_identities"])
        manifest = copy.deepcopy(bank["dossier_manifest"])
        if kind == "missing": identities.pop()
        elif kind == "duplicate": identities.append(copy.deepcopy(identities[0]))
        validate_external_dossier_identities(
            identities, manifest, [row["slot_id"] for row in odr60_rows()],
        )

    def external_identity_digest():
        manifest = copy.deepcopy(bank["dossier_manifest"])
        manifest["identities_sha256"] = "0" * 64
        validate_external_dossier_identities(
            bank["dossier_identities"], manifest, [row["slot_id"] for row in odr60_rows()],
        )

    def external_identity_content():
        identities = copy.deepcopy(bank["dossier_identities"])
        identities[0]["private_text"] = "synthetic sentinel"
        validate_external_dossier_identities(
            identities, bank["dossier_manifest"], [row["slot_id"] for row in odr60_rows()],
        )

    def external_package_read():
        RuntimeReadBoundary().read_bytes(Path("/tmp") / "LANGUAGE-A-OWNER-PRIVATE-FREEZER-DOSSIERS-CANDIDATE.zip")

    def registry_declared():
        registry = strict_json_load(MUTATION_REGISTRY_PATH); registry["declared_unexecuted"] = [registry["mutations"][0]["mutation_id"]]; validate_mutation_registry_contract(registry, {row["mutation_id"] for row in registry["mutations"]})

    def registry_undeclared():
        registry = strict_json_load(MUTATION_REGISTRY_PATH); handlers = {row["mutation_id"] for row in registry["mutations"]}; handlers.add("mutation:tranche-b-undeclared-sentinel"); validate_mutation_registry_contract(registry, handlers)

    return {
        "mutation:tranche-b-missing-item": population_mutation("targets", lambda rows: rows.pop()),
        "mutation:tranche-b-duplicate-item": population_mutation("targets", lambda rows: rows.append(copy.deepcopy(rows[0]))),
        "mutation:tranche-b-extra-item": population_mutation("targets", lambda rows: rows.append({**copy.deepcopy(rows[0]), "item_id": "BS-07"})),
        "mutation:tranche-b-wrong-family": metadata_mutation("family", "SCOPE-AND-VERSION"),
        "mutation:tranche-b-wrong-role": metadata_mutation("answerability_role", "DELIBERATE-INSUFFICIENCY"),
        "mutation:tranche-b-wrong-tag": metadata_mutation("tags", []),
        "mutation:tranche-b-retired-sol-v2": population_mutation("hidden", lambda rows: next(row for row in rows if row["item_id"] == "SV-01")["source_input"].__setitem__("accepted_version", "Sol v2 apparatus-based retired")),
        "mutation:tranche-b-f1-boundaries-leak": target_leak("boundaries", "private"),
        "mutation:tranche-b-rendering-metadata-leak": target_leak("rendering_requirements", "private"),
        "mutation:tranche-b-freezer-note-leak": target_leak("freezer_note", "synthetic owner-private content sentinel"),
        "mutation:tranche-b-answer-sketch-leak": target_leak("intended_resolution", "private"),
        "mutation:tranche-b-visible-arm-label": template_mutation("NL", b"\nLANG-A arm\n"),
        "mutation:tranche-b-visible-sham-label": template_mutation("SHAM", b"\nSHAM diagnostic\n"),
        "mutation:tranche-b-scaffold-names-language-a": template_mutation("SCAFFOLD", b"\nLanguage-A\n"),
        "mutation:tranche-b-malformed-lang-a-skeleton": lambda: (_ for _ in ()).throw(RendererContractViolation("killed by protected validator mutation file")) if validate_lang_a_mutants() else None,
        "mutation:tranche-b-stale-template": template_mutation("NL", b"\nstale\n"),
        "mutation:tranche-b-wrong-source-order": source_order,
        "mutation:tranche-b-omitted-source": source_omitted,
        "mutation:tranche-b-altered-source-byte": source_altered,
        "mutation:tranche-b-hidden-metadata-read": hidden_read,
        "mutation:tranche-b-cr01-original-replaced": cr01_replaced,
        "mutation:tranche-b-nondeterministic-rendering": nondeterministic,
        "mutation:tranche-b-payload-envelope-digest-confusion": digest_confusion,
        "mutation:tranche-b-normalization-parent-missing": normalization_without_parent,
        "mutation:tranche-b-census-mismatch": census_mutation("count"),
        "mutation:tranche-b-duplicate-request-cell": census_mutation("duplicate"),
        "mutation:tranche-b-missing-request-cell": census_mutation("missing"),
        "mutation:tranche-b-unauthorized-fifth-core-arm": lambda: unauthorized_arm("DOMAIN-NATIVE"),
        "mutation:tranche-b-unauthorized-sixth-arm": lambda: unauthorized_arm("EXTRA"),
        "mutation:tranche-b-missing-external-dossier-identity": lambda: external_identity_population("missing"),
        "mutation:tranche-b-duplicate-external-dossier-identity": lambda: external_identity_population("duplicate"),
        "mutation:tranche-b-external-dossier-set-digest": external_identity_digest,
        "mutation:tranche-b-private-content-in-identity": external_identity_content,
        "mutation:tranche-b-external-dossier-package-read": external_package_read,
        "mutation:tranche-b-private-key-read": key_read,
        "mutation:tranche-b-network-capable-provider": network_provider,
        "mutation:tranche-b-declared-unexecuted": registry_declared,
        "mutation:tranche-b-undeclared-executed": registry_undeclared,
    }


def execute_mutations():
    bank = load_bank()
    manifest, files = validate_template_files()
    schedule = strict_jsonl_load(SCHEDULE_PATH)
    validate_schedule(schedule, bank, manifest)
    registry = strict_json_load(MUTATION_REGISTRY_PATH)
    handlers = _mutation_handlers(bank, manifest, files, schedule)
    validate_mutation_registry_contract(registry, handlers)
    condition_by_name = {
        condition.__name__: condition for condition in (
            CanonicalizationIdentityMismatch, CanonicalPopulationMismatch, TargetVisibilityViolation,
            RendererContractViolation, RequestCustodyViolation, AuthorityBoundaryViolation,
            TrancheBMutationNotExercised,
        )
    }
    results = []
    for declaration in registry["mutations"]:
        mutation_id = declaration["mutation_id"]
        expected = condition_by_name[declaration["expected_condition"]]
        observed = _expect_failure(handlers[mutation_id], expected)
        results.append({"mutation_id": mutation_id, "expected_condition": expected.__name__, "observed_condition": observed, "executed": True, "killed": True})
    return results


def verify():
    bank = load_bank()
    manifest, _ = validate_template_files()
    schedule = strict_jsonl_load(SCHEDULE_PATH)
    validate_schedule(schedule, bank, manifest)
    lang_a = validate_lang_a_mutants()
    mutations = execute_mutations()
    replay = run_two_clean_replays()
    return {
        "items": len(bank["targets"]), "dossiers": len(bank["dossier_identities"]), "schedule": len(schedule),
        "mutations": len(mutations), "lang_a_records": len(lang_a), "replay": replay,
    }


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("command", choices=("verify", "mutations", "replay"))
    args = parser.parse_args()
    if args.command == "mutations":
        rows = execute_mutations(); print(f"TRANCHE-B-MUTATIONS: PASS {len(rows)}/{len(rows)}")
    elif args.command == "replay":
        result = run_two_clean_replays(); print(f"TRANCHE-B-REPLAY: PASS files={result['file_count']} network_calls=0")
    else:
        result = verify(); print(f"TRANCHE-B-VERIFY: PASS items={result['items']} schedule={result['schedule']} mutations={result['mutations']}")


if __name__ == "__main__":
    main()
