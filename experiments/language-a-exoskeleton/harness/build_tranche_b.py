"""Build Tranche B candidate records from the exact owner-supplied input set."""

import argparse
import base64
import hashlib
import io
import json
import re
import zipfile
from pathlib import Path

from tranche_b import (
    ALL_ARMS, ANCESTRY_PATH, BANK_MANIFEST_PATH, CANDIDATE_ROOT,
    CONTROL_ROOT, DOSSIER_IDENTITIES_PATH, DOSSIER_MANIFEST_PATH, EXPECTED_BASE_COMMIT,
    EXPECTED_BASE_TREE, FREEZER_ROOT, HIDDEN_PATH, ITEM_RECORDS_PATH,
    OBLIGATIONS_PATH, OWNER_ACCEPTANCE_PATH, PACKET_ROOT, SCHEDULE_PATH,
    SOURCE_MANIFESTS_PATH, TARGET_PATH, TEMPLATE_MANIFEST_PATH, TEMPLATE_ROOT,
    authoritative_schedule_rows, byte_object, line_sha256, load_public_bank,
    odr60_rows, source_packet_bytes, target_surface_bytes, validate_byte_object,
    validate_schema,
)
from util import REPO_ROOT, canonical_json_bytes, jsonl_bytes, sha256_bytes, sha256_file, write_bytes


INPUTS = {
    "CODEX-LANGUAGE-A-TRANCHE-B-CANONICALIZATION-COMMISSION.md": (10770, "db0752ee35292f220fb8711a1fc3a7acfcb734fcdde61dcd79e4cc262a269dd6"),
    "LANGUAGE-A-24-ITEM-CONTENT-BANK-OWNER-DISPOSITION.md": (5546, "1641ba196b5cc8276b2757842cf0e571da3a321f28b60a39f86d709d94e26581"),
    "FABLE-PUBLIC-ITEM-BANK-v1.1.md": (20749, "374d4f0a3096dc3f6b699a6c7af905fa1b999abdd208555913eb2d095d5d76b9"),
    "FABLE-PRIVATE-FREEZER-NOTES-v1.md": (28279, "ca7c1dd76793124bb74eb5fd9af9f3d5f3925c6cb58f88f247d0265a71c72c8e"),
    "SOL-PUBLIC-ITEMS-v3.md": (25713, "aff80d33fcc32e4a849a715be93f4604da02d619abe913b6c9f832194c1b90f3"),
    "SOL-PRIVATE-FREEZER-NOTES-v3.md": (17211, "799c4f7186519d750b09c05a61403be58ba07b1a79a3af8cd8411d4d10e0e41f"),
    "LANGUAGE-A-ODR-43-ODR-60-ADOPTION-OWNER-VERIFICATION.md": (15577, "aed28981d841f2a41bbc95741acfa174b581a1aea41149b5364ba900f85b8cd7"),
}
EXPECTED_ARCHIVE_SHA256 = "c855d9811c03d4e1844f1dfd94f03bf5c64ea278fd6e70ce1317356b4dfa5d8a"
EXPECTED_INPUT_MANIFEST_SHA256 = "bf778ecd42d279133f9304541ecd625ce049f425ca65e99f910f6a4f5880af51"
OWNER_PRIVATE_PACKAGE_NAME = "LANGUAGE-A-OWNER-PRIVATE-FREEZER-DOSSIERS-CANDIDATE.zip"
OWNER_PRIVATE_PACKAGE_ROOT = "LANGUAGE-A-OWNER-PRIVATE-FREEZER-DOSSIERS-CANDIDATE"
OWNER_PRIVATE_DOSSIER_SCHEMA = "lae-owner-private-freezer-dossier/1.0.0"
OWNER_PRIVATE_EXCLUSIONS = [
    "target-payload", "author-to-author-package", "grader-calibration",
    "runner-visible-record", "KEY-AUTHOR-INPUT",
]
KNOWN_TAGS = (
    "TRAP-BEARING", "STRONG-CONCLUSION-CONTROL", "SHAM-DESIGNATED",
    "EASY-BOUNDED-CONTROL", "DOMAIN-NATIVE-NON-LANG-A-RENDERABLE",
)
CR01_WIRE_VIEW = (
    "DERIVED WIRE-LAYOUT VIEW OF S1 SECTION 4.2\n"
    "offset  octets  field\n"
    "0       2       SYNC\n"
    "2       6       SESSION-TAG\n"
    "8       2       LENGTH\n"
    "10      1       FLAGS\n"
).encode("utf-8")


def verify_inputs(input_dir, archive=None, sidecar=None):
    input_dir = Path(input_dir)
    for filename, (size, digest) in INPUTS.items():
        path = input_dir / filename
        if not path.is_file() or path.stat().st_size != size or sha256_file(path) != digest:
            raise RuntimeError(f"input identity mismatch: {filename}")
    manifest_path = input_dir / "INPUT-MANIFEST.json"
    if sha256_file(manifest_path) != EXPECTED_INPUT_MANIFEST_SHA256:
        raise RuntimeError("INPUT-MANIFEST identity mismatch")
    manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
    if manifest["base_commit"] != EXPECTED_BASE_COMMIT or manifest["base_tree"] != EXPECTED_BASE_TREE:
        raise RuntimeError("INPUT-MANIFEST base identity mismatch")
    declared = {row["filename"]: (row["bytes"], row["sha256"]) for row in manifest["files"]}
    if declared != INPUTS:
        raise RuntimeError("INPUT-MANIFEST file set mismatch")
    expected_internal_sidecar = "".join(
        f"{digest}  {filename}\n" for filename, (_, digest) in INPUTS.items()
    ) + f"{EXPECTED_INPUT_MANIFEST_SHA256}  INPUT-MANIFEST.json\n"
    if (input_dir / "SHA256SUMS.txt").read_text(encoding="ascii") != expected_internal_sidecar:
        raise RuntimeError("internal SHA256SUMS sidecar mismatch")
    if archive:
        archive = Path(archive)
        if sha256_file(archive) != EXPECTED_ARCHIVE_SHA256:
            raise RuntimeError("outer archive identity mismatch")
    if sidecar:
        line = Path(sidecar).read_text(encoding="ascii")
        expected = EXPECTED_ARCHIVE_SHA256 + "  LANGUAGE-A-TRANCHE-B-CANONICALIZATION-INPUTS.zip\n"
        if line != expected:
            raise RuntimeError("outer sidecar mismatch")
    return manifest


def _trim(lines):
    while lines and not lines[0].strip():
        lines = lines[1:]
    while lines and (not lines[-1].strip() or re.fullmatch(r"[-=]{3,}\n?", lines[-1])):
        lines = lines[:-1]
    data = "".join(lines).encode("utf-8")
    if not data.endswith(b"\n"):
        data += b"\n"
    return data


def _item_sections(lines, pattern):
    starts = []
    for index, line in enumerate(lines):
        match = re.match(pattern, line)
        if match:
            starts.append((index, match.group(1)))
    sections = {}
    for position, (start, item_id) in enumerate(starts):
        end = starts[position + 1][0] if position + 1 < len(starts) else len(lines)
        sections[item_id] = (start, end)
    return sections


def _split_sources(lines):
    starts = []
    for index, line in enumerate(lines):
        match = re.match(r"(?:#### )?(S[1-9][0-9]*)\s+—", line)
        if match:
            starts.append((index, match.group(1)))
    if not starts:
        raise RuntimeError("source component split found no sources")
    sources = []
    for position, (start, component_id) in enumerate(starts):
        end = starts[position + 1][0] if position + 1 < len(starts) else len(lines)
        sources.append((component_id, _trim(lines[start:end])))
    return sources


def _byte_record(item_id, task, sources, derived_views):
    record = {
        "schema_version": "lae-target-visible-item/1.0.0", "item_id": item_id,
        "state": "candidate", "visibility": "target-visible-task-and-source-only",
        "task": byte_object(task),
        "sources": [{"component_id": component_id, "ordinal": index, "content": byte_object(data)} for index, (component_id, data) in enumerate(sources, 1)],
        "derived_views": derived_views,
        "source_packet_sha256": "0" * 64, "target_surface_sha256": "0" * 64,
    }
    record["source_packet_sha256"] = sha256_bytes(source_packet_bytes(record))
    record["target_surface_sha256"] = sha256_bytes(target_surface_bytes(record))
    validate_schema("target-visible-item", record)
    return record


def parse_fable_public(path):
    lines = Path(path).read_text(encoding="utf-8").splitlines(keepends=True)
    sections = _item_sections(lines, r"^## ((?:BS|CR)-0[1-6])\s+—")
    records = []
    for item_id, (start, end) in sections.items():
        section = lines[start:end]
        task_marker = section.index("### TARGET-VISIBLE — TASK\n")
        source_marker = section.index("### TARGET-VISIBLE — SOURCES\n")
        hidden_marker = section.index("### HIDDEN METADATA (renderer/freezer only)\n")
        header = "".join(section[:task_marker])
        pieces = re.match(r"^## [A-Z]{2}-\d{2} — ([A-Z-]+) — ([A-Z-]+)", section[0])
        family, role = pieces.group(1), pieces.group(2)
        tags = [tag for tag in KNOWN_TAGS if tag in header]
        task = _trim(section[task_marker + 1:source_marker])
        sources = _split_sources(section[source_marker + 1:hidden_marker])
        hidden = _trim(section[hidden_marker + 1:]).decode("utf-8")
        rendering_match = re.search(r"Rendering(?: \([^\n:]+\))?:", hidden)
        if not rendering_match:
            raise RuntimeError(f"{item_id}: Fable hidden surface lacks Rendering split")
        boundary_text = hidden[:rendering_match.start()]
        rendering_text = hidden[rendering_match.start():]
        boundary = _trim([boundary_text])
        rendering = _trim([rendering_text])
        views = []
        if item_id == "CR-01":
            views = [{"view_id": "CR-01-S1-WIRE-LAYOUT", "parent_component_id": "S1", "transformation": "deterministic-field-offset-tabulation-v1", "content": byte_object(CR01_WIRE_VIEW)}]
        records.append({
            "target": _byte_record(item_id, task, sources, views), "family": family, "role": role, "tags": tags,
            "boundary": boundary, "rendering": rendering,
            "source_filename": Path(path).name, "source_sha256": INPUTS[Path(path).name][1],
            "accepted_version": "Fable public v1.1 owner-accepted",
        })
    return records


def parse_sol_public(path):
    lines = Path(path).read_text(encoding="utf-8").splitlines(keepends=True)
    sections = _item_sections(lines, r"^## ((?:SV|NT)-0[1-6])\s+—")
    records = []
    for item_id, (start, end) in sections.items():
        section = lines[start:end]
        task_marker = section.index("### Arm-neutral task\n")
        source_marker = section.index("### Finite source packet\n")
        boundary_marker = section.index("### Source/version/scope boundaries\n")
        rendering_marker = section.index("### Rendering requirements and invariants\n")
        header = "".join(section[:task_marker])
        role_match = re.search(r"\*\*Role:\*\* `([A-Z-]+)`", header)
        if not role_match:
            raise RuntimeError(f"{item_id}: Sol role missing")
        role = role_match.group(1)
        tags = [tag for tag in KNOWN_TAGS if tag in header]
        family = "SCOPE-AND-VERSION" if item_id.startswith("SV") else "NOTATION-NEUTRAL-TRANSFER"
        task = _trim(section[task_marker + 1:source_marker])
        sources = _split_sources(section[source_marker + 1:boundary_marker])
        boundary = _trim(section[boundary_marker + 1:rendering_marker])
        rendering = _trim(section[rendering_marker + 1:])
        records.append({
            "target": _byte_record(item_id, task, sources, []), "family": family, "role": role, "tags": tags,
            "boundary": boundary, "rendering": rendering,
            "source_filename": Path(path).name, "source_sha256": INPUTS[Path(path).name][1],
            "accepted_version": "Sol public v3 fictional replacement",
        })
    return records


def _dossier_section(lines, start, end):
    while end > start and (not lines[end - 1].strip() or re.fullmatch(r"[-=]{3,}\n?", lines[end - 1])):
        end -= 1
    data = "".join(lines[start:end]).encode("utf-8")
    if not data.endswith(b"\n"):
        data += b"\n"
    return data, start + 1, end


def parse_sol_dossiers(path):
    lines = Path(path).read_text(encoding="utf-8").splitlines(keepends=True)
    starts = [(index, match.group(1)) for index, line in enumerate(lines) if (match := re.match(r"^# ((?:SV|NT)-0[1-6])\n$", line))]
    result = {}
    for position, (start, item_id) in enumerate(starts):
        end = starts[position + 1][0] if position + 1 < len(starts) else len(lines)
        result[item_id] = _dossier_section(lines, start, end)
    return result


def parse_fable_dossiers(path):
    lines = Path(path).read_text(encoding="utf-8").splitlines(keepends=True)
    item_starts = []
    for index, line in enumerate(lines):
        match = re.match(r"^# ((?:BS|CR)-0[1-6]) —", line) or re.match(r"^## ((?:BS|CR)-0[1-6])\n$", line)
        if match:
            item_starts.append((index, match.group(1)))
    stop_lines = [index for index, line in enumerate(lines) if re.match(r"^# FABLE ITEMS — BATCH|^## (?:BATCH|BANK)-LEVEL", line)]
    result = {}
    for position, (start, item_id) in enumerate(item_starts):
        candidates = [value for value, _ in item_starts[position + 1:position + 2]] + [value for value in stop_lines if value > start]
        end = min(candidates) if candidates else len(lines)
        result[item_id] = _dossier_section(lines, start, end)
    return result


def _private_dossier_artifact(item_id, item_version, source_identity, content):
    return {
        "schema_version": OWNER_PRIVATE_DOSSIER_SCHEMA,
        "dossier_id": f"owner-private-dossier:{item_id}:v1",
        "item_id": item_id,
        "item_version": item_version,
        "author_source_identity": source_identity,
        "standing": "owner-private-external",
        "custody_basis": "owner-directed-local-mechanical-custody-no-substantive-freezer-authority",
        "excluded_from": OWNER_PRIVATE_EXCLUSIONS,
        "owner_private_content": byte_object(content),
    }


def _validate_private_dossier_artifact(artifact, identity):
    required = {
        "schema_version", "dossier_id", "item_id", "item_version",
        "author_source_identity", "standing", "custody_basis",
        "excluded_from", "owner_private_content",
    }
    if set(artifact) != required:
        raise RuntimeError(f"{artifact.get('item_id')}: owner-private artifact shape differs")
    if artifact["schema_version"] != OWNER_PRIVATE_DOSSIER_SCHEMA:
        raise RuntimeError(f"{artifact['item_id']}: owner-private artifact schema differs")
    if artifact["dossier_id"] != identity["dossier_id"] or artifact["item_id"] != identity["item_id"]:
        raise RuntimeError(f"{artifact['item_id']}: owner-private identity binding differs")
    if artifact["item_version"] != identity["item_version"] or artifact["author_source_identity"] != identity["author_source_identity"]:
        raise RuntimeError(f"{artifact['item_id']}: owner-private source/version binding differs")
    if artifact["standing"] != "owner-private-external" or artifact["custody_basis"] != identity["custody_basis"]:
        raise RuntimeError(f"{artifact['item_id']}: owner-private standing/custody differs")
    if artifact["excluded_from"] != OWNER_PRIVATE_EXCLUSIONS or identity["excluded_from"] != OWNER_PRIVATE_EXCLUSIONS:
        raise RuntimeError(f"{artifact['item_id']}: owner-private exclusions differ")
    validate_byte_object(artifact["owner_private_content"], f"{artifact['item_id']} owner-private content")


def _zip_info(path):
    info = zipfile.ZipInfo(path, date_time=(1980, 1, 1, 0, 0, 0))
    info.compress_type = zipfile.ZIP_STORED
    info.create_system = 3
    info.external_attr = (0o600 & 0xFFFF) << 16
    return info


def build_owner_private_package(output_dir, artifacts, identities):
    output_dir = Path(output_dir).resolve()
    repository = REPO_ROOT.resolve()
    if output_dir == repository or repository in output_dir.parents:
        raise RuntimeError("owner-private package output must be outside the Git worktree")
    output_dir.mkdir(parents=True, exist_ok=True)
    package_path = output_dir / OWNER_PRIVATE_PACKAGE_NAME
    sidecar_path = output_dir / f"{OWNER_PRIVATE_PACKAGE_NAME}.sha256"
    identity_by_item = {row["item_id"]: row for row in identities}
    artifact_entries = []
    artifact_bytes_by_path = {}
    for item_id in [row["item_id"] for row in identities]:
        artifact = artifacts[item_id]
        data = canonical_json_bytes(artifact)
        identity = identity_by_item[item_id]
        _validate_private_dossier_artifact(artifact, identity)
        if identity["artifact_bytes"] != len(data) or identity["artifact_sha256"] != sha256_bytes(data):
            raise RuntimeError(f"{item_id}: owner-private artifact byte identity differs")
        relative = f"{OWNER_PRIVATE_PACKAGE_ROOT}/dossiers/{item_id}.json"
        artifact_bytes_by_path[relative] = data
        artifact_entries.append({
            "path": relative, "dossier_id": identity["dossier_id"],
            "item_id": item_id, "bytes": len(data), "sha256": sha256_bytes(data),
        })
    package_manifest = {
        "schema_version": "lae-owner-private-freezer-package-manifest/1.0.0",
        "package": OWNER_PRIVATE_PACKAGE_ROOT,
        "standing": "owner-private-external",
        "dossier_count": 24,
        "item_ids": [row["item_id"] for row in identities],
        "committed_identity_set_sha256": sha256_bytes(jsonl_bytes(identities)),
        "artifacts": artifact_entries,
        "repository_tracking_authorized": False,
        "transport_policy": "owner-private-local-only-never-git-target-author-relay-grader-runner-or-key-author-input",
    }
    manifest_path = f"{OWNER_PRIVATE_PACKAGE_ROOT}/PACKAGE-MANIFEST.json"
    archive = io.BytesIO()
    with zipfile.ZipFile(archive, "w") as package:
        package.writestr(_zip_info(manifest_path), canonical_json_bytes(package_manifest))
        for path in sorted(artifact_bytes_by_path):
            package.writestr(_zip_info(path), artifact_bytes_by_path[path])
    package_bytes = archive.getvalue()
    write_bytes(package_path, package_bytes)
    sidecar = f"{sha256_bytes(package_bytes)}  {OWNER_PRIVATE_PACKAGE_NAME}\n".encode("ascii")
    write_bytes(sidecar_path, sidecar)
    validate_owner_private_package(package_path, identities)
    return {
        "path": package_path, "sidecar_path": sidecar_path,
        "bytes": len(package_bytes), "sha256": sha256_bytes(package_bytes),
    }


def validate_owner_private_package(package_path, identities):
    package_path = Path(package_path)
    identity_by_item = {row["item_id"]: row for row in identities}
    expected_paths = {
        f"{OWNER_PRIVATE_PACKAGE_ROOT}/PACKAGE-MANIFEST.json",
        *(f"{OWNER_PRIVATE_PACKAGE_ROOT}/dossiers/{item_id}.json" for item_id in identity_by_item),
    }
    with zipfile.ZipFile(package_path) as package:
        names = package.namelist()
        if len(names) != len(set(names)) or set(names) != expected_paths:
            raise RuntimeError("owner-private package path set differs")
        if any(name.startswith("/") or ".." in Path(name).parts for name in names):
            raise RuntimeError("owner-private package contains unsafe path")
        manifest = json.loads(package.read(f"{OWNER_PRIVATE_PACKAGE_ROOT}/PACKAGE-MANIFEST.json"))
        if manifest["dossier_count"] != 24 or manifest["item_ids"] != list(identity_by_item):
            raise RuntimeError("owner-private package population differs")
        if manifest["committed_identity_set_sha256"] != sha256_bytes(jsonl_bytes(identities)):
            raise RuntimeError("owner-private package identity-set closure differs")
        expected_entries = []
        for item_id, identity in identity_by_item.items():
            path = f"{OWNER_PRIVATE_PACKAGE_ROOT}/dossiers/{item_id}.json"
            data = package.read(path)
            if len(data) != identity["artifact_bytes"] or sha256_bytes(data) != identity["artifact_sha256"]:
                raise RuntimeError(f"{item_id}: packaged dossier identity differs")
            artifact = json.loads(data)
            _validate_private_dossier_artifact(artifact, identity)
            expected_entries.append({
                "path": path, "dossier_id": identity["dossier_id"],
                "item_id": item_id, "bytes": len(data), "sha256": sha256_bytes(data),
            })
        if manifest["artifacts"] != expected_entries:
            raise RuntimeError("owner-private package artifact manifest differs")
    return True


def assert_no_private_content_in_repository_outputs(outputs, private_contents):
    for path, output in outputs.items():
        for content in private_contents:
            text = content.decode("utf-8")
            signatures = (
                content,
                json.dumps(text, ensure_ascii=False)[1:-1].encode("utf-8"),
                base64.b64encode(content),
                content.hex().encode("ascii"),
            )
            if any(signature and signature in output for signature in signatures):
                raise RuntimeError(f"owner-private dossier content entered repository output: {path}")


def make_hidden(record):
    return {
        "schema_version": "lae-hidden-item-metadata/1.0.0", "item_id": record["target"]["item_id"],
        "visibility": "hidden-control-plane-never-target", "family": record["family"],
        "answerability_role": record["role"], "tags": record["tags"],
        "source_input": {"filename": record["source_filename"], "sha256": record["source_sha256"], "accepted_version": record["accepted_version"]},
        "source_version_scope_boundaries": byte_object(record["boundary"]),
        "owner_disposition": {"ruling_id": "ruling:language-a-24-item-content-bank-acceptance-v1", "content_accepted": True, "item_freeze_authorized": False, "exposure_authorized": False},
    }


def make_obligation(record):
    return {"schema_version": "lae-rendering-obligation/1.0.0", "item_id": record["target"]["item_id"], "visibility": "hidden-control-plane-never-target", "requirements": byte_object(record["rendering"])}


def make_ancestry(item_id):
    direct = ["no private-key exposure declared", "no target-output exposure declared"]
    if item_id in {"SV-01", "NT-01"}:
        direct.append("retired Sol v2 apparatus item excluded; known Fable note-read does not attach to fictional v3 replacement")
    return {
        "schema_version": "lae-direct-known-ancestry/1.0.0", "item_id": item_id,
        "standing": "bounded-direct-known-not-universal-absence", "direct_known": direct,
        "bounded_unknowns": ["model-training ancestry and eventual target-corpus overlap are not attested"],
    }


def template_manifest():
    system_path = TEMPLATE_ROOT / "common-system.txt"
    wrapper_path = TEMPLATE_ROOT / "wrapper.txt"
    entry = lambda path: {"path": path.relative_to(PACKET_ROOT).as_posix(), "bytes": path.stat().st_size, "sha256": sha256_file(path)}
    record = {
        "schema_version": "lae-template-byte-manifest/1.0.0", "state": "candidate-template-bytes-fixed",
        "system": entry(system_path), "wrapper": entry(wrapper_path),
        "templates": [{"arm": arm, **entry(TEMPLATE_ROOT / f"{arm}.txt")} for arm in ALL_ARMS],
        "item_bank_freeze_authorized": False,
    }
    validate_schema("template-manifest", record)
    return record


def build(input_dir, owner_private_output_dir, archive=None, sidecar=None):
    input_dir = Path(input_dir)
    manifest = verify_inputs(input_dir, archive, sidecar)
    public = parse_fable_public(input_dir / "FABLE-PUBLIC-ITEM-BANK-v1.1.md") + parse_sol_public(input_dir / "SOL-PUBLIC-ITEMS-v3.md")
    by_id = {record["target"]["item_id"]: record for record in public}
    allocation_rows = odr60_rows()
    ordered_ids = [row["slot_id"] for row in allocation_rows]
    if set(by_id) != set(ordered_ids):
        raise RuntimeError("public item population mismatch")
    allocation_by_id = {row["slot_id"]: row for row in allocation_rows}
    for item_id, record in by_id.items():
        expected = allocation_by_id[item_id]
        if record["family"] != expected["content_family"] or record["role"] != expected["answerability_role"] or set(record["tags"]) != set(expected["tags"]):
            raise RuntimeError(f"{item_id}: public header differs from adopted ODR-60 allocation")
        record["tags"] = expected["tags"]
    public = [by_id[item_id] for item_id in ordered_ids]
    targets = [record["target"] for record in public]
    hidden = [make_hidden(record) for record in public]
    obligations = [make_obligation(record) for record in public]
    source_manifests = [{
        "schema_version": "lae-source-packet-manifest-candidate/1.0.0", "item_id": target["item_id"], "state": "candidate",
        "component_order": [source["component_id"] for source in target["sources"]],
        "component_sha256s": [source["content"]["sha256"] for source in target["sources"]],
        "derived_view_ids": [view["view_id"] for view in target["derived_views"]],
        "source_packet_sha256": target["source_packet_sha256"],
    } for target in targets]
    ancestry = [make_ancestry(item_id) for item_id in ordered_ids]
    for record in hidden: validate_schema("hidden-metadata", record)
    for record in obligations: validate_schema("rendering-obligation", record)
    for record in source_manifests: validate_schema("source-packet-manifest", record)
    for record in ancestry: validate_schema("ancestry", record)
    items = []
    for index, item_id in enumerate(ordered_ids):
        item = {
            "schema_version": "lae-candidate-item-record/1.0.0", "item_id": item_id, "state": "candidate",
            "target_visible_line_sha256": line_sha256(targets[index]), "hidden_metadata_line_sha256": line_sha256(hidden[index]),
            "rendering_obligation_line_sha256": line_sha256(obligations[index]), "source_packet_manifest_line_sha256": line_sha256(source_manifests[index]),
            "ancestry_line_sha256": line_sha256(ancestry[index]),
        }
        validate_schema("item-record", item); items.append(item)

    fable_dossiers = parse_fable_dossiers(input_dir / "FABLE-PRIVATE-FREEZER-NOTES-v1.md")
    sol_dossiers = parse_sol_dossiers(input_dir / "SOL-PRIVATE-FREEZER-NOTES-v3.md")
    dossier_sources = {**fable_dossiers, **sol_dossiers}
    if set(dossier_sources) != set(ordered_ids):
        raise RuntimeError("owner-private dossier exact set differs")
    private_artifacts = {}
    dossier_identities = []
    for item_id in ordered_ids:
        data, _start_line, _end_line = dossier_sources[item_id]
        source_key = "Fable" if item_id.startswith(("BS", "CR")) else "Sol"
        filename = "FABLE-PRIVATE-FREEZER-NOTES-v1.md" if source_key == "Fable" else "SOL-PRIVATE-FREEZER-NOTES-v3.md"
        source_identity = {
            "author_id": f"author-source:{source_key}",
            "source_filename": filename,
            "source_sha256": INPUTS[filename][1],
        }
        item_version = by_id[item_id]["accepted_version"]
        artifact = _private_dossier_artifact(item_id, item_version, source_identity, data)
        artifact_bytes = canonical_json_bytes(artifact)
        identity = {
            "schema_version": "lae-owner-private-external-dossier-identity/1.0.0",
            "dossier_id": artifact["dossier_id"], "item_id": item_id,
            "item_version": item_version, "dossier_schema_version": OWNER_PRIVATE_DOSSIER_SCHEMA,
            "artifact_bytes": len(artifact_bytes), "artifact_sha256": sha256_bytes(artifact_bytes),
            "author_source_identity": source_identity, "standing": "owner-private-external",
            "custody_basis": "owner-directed-local-mechanical-custody-no-substantive-freezer-authority",
            "excluded_from": OWNER_PRIVATE_EXCLUSIONS,
        }
        validate_schema("external-dossier-identity", identity)
        _validate_private_dossier_artifact(artifact, identity)
        private_artifacts[item_id] = artifact
        dossier_identities.append(identity)
    identities_bytes = jsonl_bytes(dossier_identities)
    dossier_manifest = {
        "schema_version": "lae-external-dossier-identity-manifest/1.0.0", "state": "candidate",
        "standing": "owner-private-external", "identity_count": 24, "item_ids": ordered_ids,
        "identity_records": [{
            "dossier_id": row["dossier_id"], "item_id": row["item_id"],
            "identity_line_sha256": line_sha256(row),
        } for row in dossier_identities],
        "identities_sha256": sha256_bytes(identities_bytes), "private_content_committed": False,
        "transport_policy": "owner-freezer-only-never-target-author-relay-grader-runner-or-key-author-input",
    }
    validate_schema("freezer-manifest", dossier_manifest)
    package_info = build_owner_private_package(owner_private_output_dir, private_artifacts, dossier_identities)

    owner = {
        "schema_version": "lae-owner-content-acceptance-basis/1.0.0", "ruling_id": "ruling:language-a-24-item-content-bank-acceptance-v1",
        "owner": "Tomás Pellissari Pavan", "accepted_item_ids": ordered_ids, "candidate_only": True,
        "authorizations": {"item_freeze": False, "private_key": False, "target_scoring": False, "provider_calls": False, "live_exposure": False},
    }
    validate_schema("owner-acceptance", owner)
    derived_totals = {"family_counts": {}, "role_counts": {}, "tag_counts": {}}
    for record in hidden:
        derived_totals["family_counts"][record["family"]] = derived_totals["family_counts"].get(record["family"], 0) + 1
        derived_totals["role_counts"][record["answerability_role"]] = derived_totals["role_counts"].get(record["answerability_role"], 0) + 1
        for tag in record["tags"]: derived_totals["tag_counts"][tag] = derived_totals["tag_counts"].get(tag, 0) + 1
    derived_totals = {key: dict(sorted(value.items())) for key, value in derived_totals.items()}

    template_record = template_manifest()
    outputs = {
        TARGET_PATH: jsonl_bytes(targets), HIDDEN_PATH: jsonl_bytes(hidden), OBLIGATIONS_PATH: jsonl_bytes(obligations),
        SOURCE_MANIFESTS_PATH: jsonl_bytes(source_manifests), ANCESTRY_PATH: jsonl_bytes(ancestry), ITEM_RECORDS_PATH: jsonl_bytes(items),
        OWNER_ACCEPTANCE_PATH: canonical_json_bytes(owner), DOSSIER_IDENTITIES_PATH: identities_bytes,
        DOSSIER_MANIFEST_PATH: canonical_json_bytes(dossier_manifest),
        TEMPLATE_MANIFEST_PATH: canonical_json_bytes(template_record),
    }
    assert_no_private_content_in_repository_outputs(outputs, [dossier_sources[item_id][0] for item_id in ordered_ids])
    bank = {
        "schema_version": "lae-candidate-bank-manifest/1.0.0", "state": "candidate-not-frozen",
        "base_commit": EXPECTED_BASE_COMMIT, "base_tree": EXPECTED_BASE_TREE,
        "odr60_record_digest": "sha256:303ec27e744521e6b25ce4c8a671139e21c7a7cd9dbaa902966519af65f279f9",
        "item_count": 24, "item_ids": ordered_ids, "derived_totals": derived_totals,
        "record_sets": {path.relative_to(PACKET_ROOT).as_posix(): {"bytes": len(data), "sha256": sha256_bytes(data)} for path, data in outputs.items() if path != TEMPLATE_MANIFEST_PATH},
        "retired_items_excluded": True, "freeze_authorized": False,
    }
    validate_schema("bank-manifest", bank)
    for path, data in outputs.items(): write_bytes(path, data)
    write_bytes(BANK_MANIFEST_PATH, canonical_json_bytes(bank))
    public_bank = load_public_bank()
    schedule = authoritative_schedule_rows(public_bank, template_record)
    for row in schedule: validate_schema("schedule-row", row)
    write_bytes(SCHEDULE_PATH, jsonl_bytes(schedule))

    evidence_root = PACKET_ROOT / "evidence/tranche-b-canonicalization"
    custody = {
        "schema_version": "lae-tranche-b-input-custody/1.0.0", "package": manifest["package"],
        "outer_archive_sha256": EXPECTED_ARCHIVE_SHA256, "sidecar_verified": bool(sidecar), "zip_integrity": "pass",
        "archive_path_safety": "pass", "input_manifest_sha256": sha256_file(input_dir / "INPUT-MANIFEST.json"),
        "internal_sha256s_sidecar_verified": True, "internal_checksums_verified": 8,
        "inputs": [{"filename": name, "bytes": size, "sha256": digest} for name, (size, digest) in INPUTS.items()],
        "base_commit": EXPECTED_BASE_COMMIT, "base_tree": EXPECTED_BASE_TREE,
    }
    canonicalization = {
        "schema_version": "lae-tranche-b-bank-canonicalization-evidence/1.0.0", "item_count": 24,
        "item_ids": ordered_ids, "derived_totals": derived_totals, "retired_sol_v2_excluded": True,
        "target_visible_surface": "task-plus-finite-source-packet-only", "hidden_metadata_separate": True,
        "external_dossier_identity_count": 24, "external_dossier_identity_set_sha256": sha256_bytes(identities_bytes),
        "private_dossier_content_committed": False, "freezer_runner_visible": False, "bank_state": "candidate-not-frozen",
    }
    write_bytes(evidence_root / "INPUT-CUSTODY.json", canonical_json_bytes(custody))
    write_bytes(evidence_root / "BANK-CANONICALIZATION.json", canonical_json_bytes(canonicalization))
    print(
        "TRANCHE-B-BUILD: PASS items=24 external_dossier_identities=24 schedule=312 "
        f"owner_private_zip_bytes={package_info['bytes']} owner_private_zip_sha256={package_info['sha256']}"
    )


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--input-dir", required=True)
    parser.add_argument("--owner-private-output-dir", required=True)
    parser.add_argument("--archive")
    parser.add_argument("--sidecar")
    args = parser.parse_args()
    build(args.input_dir, args.owner_private_output_dir, args.archive, args.sidecar)


if __name__ == "__main__":
    main()
