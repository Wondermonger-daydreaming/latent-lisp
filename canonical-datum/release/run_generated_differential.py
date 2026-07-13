#!/usr/bin/env python3
"""Stream the generated CD/0.1 corpus through both independently seeded codecs.

This program coordinates two process adapters.  It does not implement datum
semantics and neither implementation is used as an oracle for the other.
Before any adapter is started it verifies the pinned specification and every
generated-corpus provenance, count, size, and digest claim.
"""

from __future__ import annotations

import argparse
from collections import defaultdict
import hashlib
from itertools import zip_longest
import json
import os
from pathlib import Path
import re
import shlex
import shutil
import subprocess
import sys
import tempfile
import time
from typing import Any, Callable, Iterable, Iterator, Mapping, Sequence


PROTOCOL = "lisp-plus-cd0-differential/v1"
RUNNER_SCHEMA = "cd0-generated-differential-summary/v2"
MANIFEST_SCHEMA = "cd0-generated-corpus-manifest/v4"
GENERATOR_VERSION = "cd0-corpus-generator/4"
EXPECTED_NORMATIVE_SHA256 = {
    "base-specification": {
        "path": "mneme/spec/CANONICAL-DATUM-SPEC.md",
        "sha256": "d578e86e4d411611b091cca0bed1cafac2636c0908e95447fd4a13badcab6abc",
    },
    "post-implementation-ruling": {
        "path": "CD0-POST-IMPLEMENTATION-RULING.md",
        "sha256": "1a0e8ff844790c93e681f7541a23266aa73d2ee8e9ca9a6e0d753bf4e044b2bc",
    },
    "errata-0.1": {
        "path": "CANONICAL-DATUM-SPEC-ERRATA-0.1.md",
        "sha256": "5f1568e53c4e6ef5fc8de2e125e7a6ef2d861392048c7ead144c7df05eb16271",
    },
}
REPO_ROOT = Path(__file__).resolve().parents[2]
SPEC_PATH = REPO_ROOT / EXPECTED_NORMATIVE_SHA256["base-specification"]["path"]
ERRATA_VECTOR_PATH = REPO_ROOT / "canonical-datum" / "vectors" / "cd0-errata-0.1.json"
AUDITED_CORPUS_DIR = REPO_ROOT / "canonical-datum" / "generated" / "release-v0"
INTEGRATION_DIR = REPO_ROOT / "canonical-datum" / "integration"
BUDGET_PATH = REPO_ROOT / "canonical-datum" / "vectors" / "cd0-budgets.json"

ARTIFACT_NAMES = {
    "positive": "cd0-generated-positive.jsonl",
    "negative": "cd0-generated-negative.jsonl",
    "negative_derivations": "cd0-generated-negative-derivations.jsonl",
    "mutations": "cd0-mutation-candidates.jsonl",
    "host_scenarios": "cd0-host-property-scenarios.json",
}
COUNT_KEYS = {
    "positive": "positive",
    "negative": "classified_negative",
    "negative_derivations": "negative_derivations",
    "mutations": "unclassified_mutation_candidates",
}
SOURCE_INPUT_PATHS = (
    "mneme/spec/CANONICAL-DATUM-SPEC.md",
    "CD0-POST-IMPLEMENTATION-RULING.md",
    "CANONICAL-DATUM-SPEC-ERRATA-0.1.md",
    "CANONICAL-DATUM-DIVERGENCES.md",
    "canonical-datum/schema/cd0-fixtures.schema.json",
    "canonical-datum/vectors/cd0-budgets.json",
    "canonical-datum/vectors/cd0-errata-0.1.json",
    "canonical-datum/vectors/cd0-positive.jsonl",
    "canonical-datum/vectors/cd0-negative.jsonl",
    "canonical-datum/vectors/cd0-distinct-pairs.json",
    "canonical-datum/python/cd0/__init__.py",
    "canonical-datum/generator/generate_corpus.py",
)
MANIFEST_COUNT_KEYS = {
    "positive",
    "classified_adversarial_total",
    "classified_negative",
    "classified_negative_by_status",
    "authored_and_host_coverage_negative",
    "demonstrated_primary_minimal_negative",
    "negative_derivations",
    "negative_retry_verified",
    "negative_by_minimization_kind",
    "unclassified_mutation_candidates",
    "host_property_scenarios",
    "resource_boundary_scenarios",
}
BUDGET_FIELDS = (
    "max_input_octets",
    "max_output_octets",
    "max_varint_octets",
    "max_integer_bits",
    "max_depth",
    "max_nodes",
    "max_sequence_items",
    "max_record_fields",
    "max_identifier_segments",
    "max_segment_octets",
    "max_single_string_octets",
    "max_single_bytes_octets",
    "max_aggregate_payload_octets",
    "max_total_record_key_octets",
)
ERRATA_CASE_COUNTS = {
    "A1": 6,
    "A2": 5,
    "A3": 6,
    "A4": 3,
    "A5": 3,
    "A6": 2,
    "A7": 1,
    "A8": 6,
    "A9": 5,
}
OPTIONAL_CL_IMPORTERS = {
    "symbol-to-identifier/v0",
    "strict-integer-import/v0",
    "core-datum-import/v0",
}
EXPECTED_HOST_SCENARIOS = {
    "cd0-host-property-cycle",
    "cd0-host-property-improper-list",
    "cd0-host-property-shared-acyclic",
    "cd0-host-property-mutable-aliases",
    "cd0-host-property-symbols-bool",
    "cd0-host-property-namespaces",
    "cd0-host-property-live-privileged",
    "cd0-host-property-inert-records",
    "cd0-host-property-rational-construction",
}
HEX_RE = re.compile(r"^(?:[0-9a-f]{2})*$")
COMMIT_RE = re.compile(r"^[0-9a-f]{40}$")


class ReleaseDifferentialError(RuntimeError):
    """A provenance, protocol, or conformance invariant failed."""


def canonical_json(value: Any) -> str:
    return json.dumps(value, ensure_ascii=True, sort_keys=True, separators=(",", ":"))


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def sha256_bytes(payload: bytes) -> str:
    return hashlib.sha256(payload).hexdigest()


def jsonl_rows(path: Path) -> Iterator[tuple[int, dict[str, Any]]]:
    with path.open("r", encoding="ascii") as stream:
        for line_number, line in enumerate(stream, 1):
            if not line.strip():
                continue
            try:
                value = json.loads(line)
            except json.JSONDecodeError as exc:
                raise ReleaseDifferentialError(
                    f"{path}:{line_number}: invalid JSON: {exc}"
                ) from exc
            if type(value) is not dict:
                raise ReleaseDifferentialError(f"{path}:{line_number}: row is not an object")
            yield line_number, value


def count_jsonl(path: Path) -> int:
    return sum(1 for _ in jsonl_rows(path))


def compare_audited_positive_semantics(
    current_path: Path, *, release_qualified: bool
) -> dict[str, Any]:
    """Hard-stop release evidence if generated valid datums or bytes changed."""

    baseline_path = AUDITED_CORPUS_DIR / ARTIFACT_NAMES["positive"]
    if not release_qualified:
        return {
            "disposition": "not-applicable-generator-test-mode",
            "baseline_path": str(baseline_path.relative_to(REPO_ROOT)),
            "compared_rows": 0,
            "canonical_octet_changes": 0,
            "abstract_datum_changes": 0,
            "decoded_ast_changes": 0,
            "equality_class_changes": 0,
        }
    if not baseline_path.is_file():
        raise ReleaseDifferentialError("audited positive corpus baseline is unavailable")
    baseline_rows = list(jsonl_rows(baseline_path))
    current_rows = list(jsonl_rows(current_path))
    if len(baseline_rows) != 10_000 or len(current_rows) != len(baseline_rows):
        raise ReleaseDifferentialError("release positive compatibility row count changed")
    changes = {
        "canonical_octet_changes": 0,
        "abstract_datum_changes": 0,
        "decoded_ast_changes": 0,
        "equality_class_changes": 0,
    }
    baseline_projection = hashlib.sha256()
    current_projection = hashlib.sha256()
    for baseline_item, current_item in zip(baseline_rows, current_rows):
        _, baseline = baseline_item
        _, current = current_item
        if baseline.get("id") != current.get("id"):
            raise ReleaseDifferentialError("release positive case identity/order changed")
        fields = {
            "canonical_hex": "canonical_octet_changes",
            "abstract": "abstract_datum_changes",
            "expected_decoded": "decoded_ast_changes",
            "equality_class": "equality_class_changes",
        }
        for field, counter in fields.items():
            changes[counter] += int(baseline.get(field) != current.get(field))
        baseline_projection.update(
            (canonical_json({field: baseline[field] for field in fields}) + "\n").encode("ascii")
        )
        current_projection.update(
            (canonical_json({field: current[field] for field in fields}) + "\n").encode("ascii")
        )
    if any(changes.values()):
        raise ReleaseDifferentialError(
            f"unauthorized generated valid-datum compatibility change: {changes}"
        )
    return {
        "disposition": "compared-byte-and-abstract-identical",
        "baseline_path": str(baseline_path.relative_to(REPO_ROOT)),
        "baseline_source_revision": "aed2f393781456dfd495ac5d5822bdcd58bea711",
        "audited_integration_anchor": "baeecd5e0347435b9e1362000344f46ea441c6ec",
        "compared_rows": len(current_rows),
        **changes,
        "baseline_projection_sha256": baseline_projection.hexdigest(),
        "current_projection_sha256": current_projection.hexdigest(),
    }


def corpus_digest(artifacts: Mapping[str, Mapping[str, Any]]) -> str:
    material = b"".join(
        name.encode("utf-8")
        + b"\0"
        + artifacts[name]["sha256"].encode("ascii")
        + b"\n"
        for name in sorted(artifacts)
    )
    return sha256_bytes(material)


def git_check_revision(revision: str) -> None:
    if not COMMIT_RE.fullmatch(revision):
        raise ReleaseDifferentialError("manifest source_revision is not a full lowercase commit id")
    exists = subprocess.run(
        ["git", "cat-file", "-e", f"{revision}^{{commit}}"],
        cwd=REPO_ROOT,
        capture_output=True,
        check=False,
    )
    if exists.returncode != 0:
        raise ReleaseDifferentialError(
            f"manifest source_revision is not available in this repository: {revision}"
        )
    ancestor = subprocess.run(
        ["git", "merge-base", "--is-ancestor", revision, "HEAD"],
        cwd=REPO_ROOT,
        capture_output=True,
        check=False,
    )
    if ancestor.returncode != 0:
        raise ReleaseDifferentialError(
            f"manifest source_revision is not an ancestor of the runner revision: {revision}"
        )

    generator_path = "canonical-datum/generator/generate_corpus.py"
    source = subprocess.run(
        ["git", "show", f"{revision}:{generator_path}"],
        cwd=REPO_ROOT,
        capture_output=True,
        check=False,
    )
    if source.returncode != 0:
        raise ReleaseDifferentialError(
            f"manifest source_revision does not contain {generator_path}"
        )
    current = (REPO_ROOT / generator_path).read_bytes()
    if source.stdout != current:
        raise ReleaseDifferentialError(
            "generator source at manifest source_revision differs from the checked-out generator"
        )


def command_option(argv: Sequence[str], option: str) -> str:
    matches = [index for index, value in enumerate(argv) if value == option]
    if len(matches) != 1 or matches[0] + 1 >= len(argv):
        raise ReleaseDifferentialError(f"logical_command_argv needs exactly one {option}")
    return argv[matches[0] + 1]


def verify_derivation_alignment(negative_path: Path, derivation_path: Path) -> int:
    """Check one-for-one provenance and count mechanically demonstrated rows."""

    demonstrated = 0
    demonstrated_cases: set[str] = set()
    missing = object()
    for negative_item, derivation_item in zip_longest(
        jsonl_rows(negative_path), jsonl_rows(derivation_path), fillvalue=missing
    ):
        if negative_item is missing or derivation_item is missing:
            raise ReleaseDifferentialError("negative/derivation sidecars differ in length")
        _, negative = negative_item
        _, derivation = derivation_item
        if negative.get("id") != derivation.get("id"):
            raise ReleaseDifferentialError(
                "negative/derivation sidecars are not aligned by case id"
            )
        proof = derivation.get("minimization_proof")
        if type(proof) is not dict or type(derivation.get("primary_defect_basis")) is not str:
            raise ReleaseDifferentialError(
                f"{negative.get('id')}: minimization provenance is malformed"
            )
        kind = derivation.get("minimization_kind")
        if kind == "byte-deletion-primary-minimal":
            budget = negative.get("budget")
            if (
                negative.get("input_kind") != "octets"
                or type(budget) is not dict
                or set(budget) != set(BUDGET_FIELDS)
                or budget.get("max_input_octets") != 8
                or len(validate_hex(negative.get("input_hex"), negative["id"], "input_hex"))
                // 2
                != 9
                or "retry_budget" not in negative
                or negative.get("expected_failure")
                != {
                    "category": "ResourceRefusal",
                    "code": "ExcessiveInputLength",
                    "stage": "input-budget",
                }
                or proof.get("all_one_octet_deletions_remove_primary_defect") is not True
                or proof.get("canonical_retry_document") is not True
                or proof.get("input_octets") != 9
                or proof.get("max_input_octets") != 8
            ):
                raise ReleaseDifferentialError(
                    f"{negative.get('id')}: demonstrated byte-deletion proof is inconsistent"
                )
            case_key = canonical_json(
                {"input_hex": negative["input_hex"], "budget": budget}
            )
            if case_key in demonstrated_cases:
                raise ReleaseDifferentialError(
                    f"{negative.get('id')}: duplicate demonstrated input/budget case"
                )
            demonstrated_cases.add(case_key)
            demonstrated += 1
        elif kind not in {"authored-primary-template", "host-graph-scenario"}:
            raise ReleaseDifferentialError(
                f"{negative.get('id')}: unknown minimization kind {kind!r}"
            )
    return demonstrated


def verify_manifest(corpus_dir: Path, *, allow_small: bool) -> dict[str, Any]:
    """Verify corpus bytes and provenance before returning immutable metadata."""

    observed_normative: dict[str, dict[str, str]] = {}
    for role, expected in EXPECTED_NORMATIVE_SHA256.items():
        path = REPO_ROOT / expected["path"]
        observed = sha256_file(path)
        if observed != expected["sha256"]:
            raise ReleaseDifferentialError(
                f"normative input digest mismatch for {role}: "
                f"{observed} != {expected['sha256']}"
            )
        observed_normative[role] = dict(expected)
    manifest_path = corpus_dir / "cd0-corpus-manifest.json"
    try:
        manifest = json.loads(manifest_path.read_text(encoding="ascii"))
    except (OSError, json.JSONDecodeError) as exc:
        raise ReleaseDifferentialError(f"cannot read corpus manifest: {exc}") from exc
    if type(manifest) is not dict or manifest.get("schema") != MANIFEST_SCHEMA:
        raise ReleaseDifferentialError("generated corpus manifest schema mismatch")
    if manifest.get("generator_version") != GENERATOR_VERSION:
        raise ReleaseDifferentialError("generated corpus generator version mismatch")

    if manifest.get("normative_specifications") != observed_normative:
        raise ReleaseDifferentialError("manifest normative input pins mismatch")
    infrastructure = manifest.get("fixture_infrastructure")
    if type(infrastructure) is not dict or set(infrastructure) != {
        "schema",
        "promoted_errata_vectors",
    }:
        raise ReleaseDifferentialError("fixture infrastructure provenance is missing")
    schema_record = infrastructure["schema"]
    if (
        type(schema_record) is not dict
        or schema_record.get("path") != "canonical-datum/schema/cd0-fixtures.schema.json"
        or schema_record.get("revision") != "0.1"
        or schema_record.get("sha256") != sha256_file(REPO_ROOT / schema_record["path"])
    ):
        raise ReleaseDifferentialError("fixture schema provenance mismatch")
    errata_record = infrastructure["promoted_errata_vectors"]
    if (
        type(errata_record) is not dict
        or errata_record.get("path") != str(ERRATA_VECTOR_PATH.relative_to(REPO_ROOT))
        or errata_record.get("sha256") != sha256_file(ERRATA_VECTOR_PATH)
        or errata_record.get("schema") != "cd0-errata-vectors/0.1"
        or errata_record.get("classified_cases") != sum(ERRATA_CASE_COUNTS.values())
        or errata_record.get("cases_by_adjudication") != ERRATA_CASE_COUNTS
    ):
        raise ReleaseDifferentialError("promoted errata vector provenance mismatch")
    source_revision = manifest.get("source_revision")
    if type(source_revision) is not str:
        raise ReleaseDifferentialError("manifest source_revision is missing")
    git_check_revision(source_revision)

    source_hashes = manifest.get("source_input_sha256")
    if type(source_hashes) is not dict or set(source_hashes) != {
        "before_generation",
        "after_generation",
    }:
        raise ReleaseDifferentialError("source-input hash checkpoints are missing")
    before_hashes = source_hashes.get("before_generation")
    after_hashes = source_hashes.get("after_generation")
    if type(before_hashes) is not dict or before_hashes != after_hashes:
        raise ReleaseDifferentialError("source inputs changed during generation")
    if set(before_hashes) != set(SOURCE_INPUT_PATHS):
        raise ReleaseDifferentialError("source-input hash path set is not exact")
    for relative in SOURCE_INPUT_PATHS:
        recorded = before_hashes.get(relative)
        if type(recorded) is not str or not re.fullmatch(r"[0-9a-f]{64}", recorded):
            raise ReleaseDifferentialError(f"invalid recorded source hash: {relative}")
        path = REPO_ROOT / relative
        if not path.is_file() or sha256_file(path) != recorded:
            raise ReleaseDifferentialError(
                f"recorded source input differs from the checked-out source: {relative}"
            )

    source_worktree = manifest.get("source_worktree")
    if type(source_worktree) is not dict or set(source_worktree) != {
        "clean_before",
        "status_before",
        "dirty_override_requested",
        "dirty_override_used",
        "release_requires_clean",
    }:
        raise ReleaseDifferentialError("source-worktree provenance is invalid")
    status_before = source_worktree.get("status_before")
    if type(status_before) is not list or not all(type(item) is str for item in status_before):
        raise ReleaseDifferentialError("source-worktree status transcript is invalid")
    if source_worktree.get("release_requires_clean") is not True:
        raise ReleaseDifferentialError("source-worktree release cleanliness boundary changed")
    if source_worktree.get("clean_before") is not (not status_before):
        raise ReleaseDifferentialError("source-worktree clean flag disagrees with its transcript")
    override_requested = source_worktree.get("dirty_override_requested")
    override_used = source_worktree.get("dirty_override_used")
    if type(override_requested) is not bool or type(override_used) is not bool:
        raise ReleaseDifferentialError("source-worktree override flags are invalid")
    if override_used is not bool(status_before and override_requested):
        raise ReleaseDifferentialError("source-worktree override-use flag is inconsistent")
    if status_before and not override_used:
        raise ReleaseDifferentialError("dirty source was recorded without the required override")

    counts = manifest.get("counts")
    artifacts = manifest.get("artifacts")
    if type(counts) is not dict or type(artifacts) is not dict:
        raise ReleaseDifferentialError("manifest counts/artifacts are missing")
    if set(counts) != MANIFEST_COUNT_KEYS:
        raise ReleaseDifferentialError("manifest v4 count key set is not exact")
    expected_artifact_names = set(ARTIFACT_NAMES.values())
    if set(artifacts) != expected_artifact_names:
        raise ReleaseDifferentialError("manifest artifact set is not exact")

    observed_counts: dict[str, int] = {}
    observed_status_counts: defaultdict[str, int] = defaultdict(int)
    observed_retry_count = 0
    observed_minimization_counts: defaultdict[str, int] = defaultdict(int)
    for logical_name, filename in ARTIFACT_NAMES.items():
        path = corpus_dir / filename
        if not path.is_file():
            raise ReleaseDifferentialError(f"generated artifact is missing: {filename}")
        record = artifacts[filename]
        if type(record) is not dict:
            raise ReleaseDifferentialError(f"manifest artifact record is invalid: {filename}")
        observed_hash = sha256_file(path)
        observed_octets = path.stat().st_size
        if record.get("sha256") != observed_hash or record.get("octets") != observed_octets:
            raise ReleaseDifferentialError(
                f"generated artifact hash/size mismatch: {filename}"
            )
        if logical_name == "host_scenarios":
            try:
                document = json.loads(path.read_text(encoding="ascii"))
                host_rows = document["scenarios"]
                resource_rows = document["resource_boundary_scenarios"]
                if type(host_rows) is not list or type(resource_rows) is not list:
                    raise TypeError("scenario arrays are not lists")
                observed_counts["host_scenarios"] = len(host_rows)
                observed_counts["resource_boundary_scenarios"] = len(resource_rows)
                observed_rows = len(host_rows) + len(resource_rows)
            except (OSError, json.JSONDecodeError, KeyError, TypeError) as exc:
                raise ReleaseDifferentialError(
                    f"generated host-scenario artifact is invalid: {exc}"
                ) from exc
            if counts.get("host_property_scenarios") != len(host_rows):
                raise ReleaseDifferentialError("manifest host-property scenario count mismatch")
            if counts.get("resource_boundary_scenarios") != len(resource_rows):
                raise ReleaseDifferentialError("manifest resource-boundary scenario count mismatch")
        else:
            observed_rows = 0
            for _, row in jsonl_rows(path):
                observed_rows += 1
                if logical_name == "negative":
                    observed_status_counts[row.get("status", "normative")] += 1
                    observed_retry_count += int("retry_budget" in row)
                elif logical_name == "negative_derivations":
                    kind = row.get("minimization_kind")
                    if type(kind) is not str or not kind:
                        raise ReleaseDifferentialError(
                            f"{filename}: derivation lacks minimization_kind"
                        )
                    observed_minimization_counts[kind] += 1
            expected_count = counts.get(COUNT_KEYS[logical_name])
            if type(expected_count) is not int or expected_count < 0:
                raise ReleaseDifferentialError(f"manifest count is invalid: {logical_name}")
            if observed_rows != expected_count:
                raise ReleaseDifferentialError(
                    f"generated artifact row-count mismatch: {filename}: "
                    f"observed={observed_rows} manifest={expected_count}"
                )
            observed_counts[logical_name] = observed_rows
        if record.get("rows") != observed_rows:
            raise ReleaseDifferentialError(
                f"generated artifact row-count mismatch: {filename}: "
                f"observed={observed_rows} artifact-record={record.get('rows')}"
            )

    if observed_counts["negative"] != observed_counts["negative_derivations"]:
        raise ReleaseDifferentialError("negative derivation sidecar is not one-for-one")
    demonstrated_primary_minimal = verify_derivation_alignment(
        corpus_dir / ARTIFACT_NAMES["negative"],
        corpus_dir / ARTIFACT_NAMES["negative_derivations"],
    )
    if counts.get("classified_adversarial_total") != observed_counts["negative"]:
        raise ReleaseDifferentialError("classified adversarial total is inconsistent")
    if counts.get("demonstrated_primary_minimal_negative") != demonstrated_primary_minimal:
        raise ReleaseDifferentialError(
            "demonstrated primary-minimal negative count is inconsistent"
        )
    authored_and_host = observed_counts["negative"] - demonstrated_primary_minimal
    if counts.get("authored_and_host_coverage_negative") != authored_and_host:
        raise ReleaseDifferentialError(
            "authored/host coverage negative count is inconsistent"
        )
    if authored_and_host != 308:
        raise ReleaseDifferentialError("authored/host coverage row count changed from 308")
    if counts.get("classified_negative_by_status") != dict(
        sorted(observed_status_counts.items())
    ):
        raise ReleaseDifferentialError("classified negative status counts are inconsistent")
    if counts.get("negative_retry_verified") != observed_retry_count:
        raise ReleaseDifferentialError("negative retry count is inconsistent")
    minimization_counts = dict(sorted(observed_minimization_counts.items()))
    if counts.get("negative_by_minimization_kind") != minimization_counts:
        raise ReleaseDifferentialError("negative minimization-kind counts are inconsistent")
    minimization = manifest.get("negative_minimization")
    if (
        type(minimization) is not dict
        or set(minimization) != {
            "kind_counts",
            "demonstrated_primary_minimal_count",
            "demonstrated_primary_minimal_threshold",
            "primary_defect_scope",
            "compact_padding_family",
        }
        or minimization.get("kind_counts") != minimization_counts
    ):
        raise ReleaseDifferentialError("negative minimization summary is inconsistent")
    if minimization.get("demonstrated_primary_minimal_count") != demonstrated_primary_minimal:
        raise ReleaseDifferentialError("negative demonstrated-minimal summary is inconsistent")
    if minimization.get("demonstrated_primary_minimal_threshold") != 20_000:
        raise ReleaseDifferentialError("negative demonstrated-minimal threshold changed")
    if minimization.get("primary_defect_scope") != (
        "proofs remove only the declared primary defect; no global semantic uniqueness is claimed"
    ):
        raise ReleaseDifferentialError("negative primary-defect scope boundary changed")
    if minimization.get("compact_padding_family") != (
        "canonical two-octet Bytes documents, nine input octets under max_input_octets=8"
    ):
        raise ReleaseDifferentialError("negative compact-padding family changed")
    if manifest.get("negative_distinctness_scope") != (
        "distinct input-kind/input-or-host-descriptor/budget cases only; not global semantic uniqueness"
    ):
        raise ReleaseDifferentialError("negative distinctness scope boundary changed")
    observed_corpus_digest = corpus_digest(artifacts)
    if manifest.get("corpus_sha256") != observed_corpus_digest:
        raise ReleaseDifferentialError("generated corpus digest mismatch")

    thresholds = manifest.get("release_thresholds")
    if type(thresholds) is not dict or set(thresholds) != {
        "positive_minimum",
        "adversarial_total_minimum",
        "demonstrated_primary_minimal_minimum",
        "preferred_negative_count",
        "observed_adversarial_total",
        "observed_demonstrated_primary_minimal",
        "qualifies",
        "count_scope",
        "allow_small_test_mode",
    }:
        raise ReleaseDifferentialError("release threshold metadata is missing")
    qualifies = (
        observed_counts["positive"] >= thresholds.get("positive_minimum", -1)
        and counts["classified_adversarial_total"]
        >= thresholds.get("adversarial_total_minimum", -1)
        and demonstrated_primary_minimal
        >= thresholds.get("demonstrated_primary_minimal_minimum", -1)
    )
    if thresholds.get("positive_minimum") != 10_000:
        raise ReleaseDifferentialError("positive release threshold changed")
    if thresholds.get("adversarial_total_minimum") != 20_000:
        raise ReleaseDifferentialError("adversarial release threshold changed")
    if thresholds.get("demonstrated_primary_minimal_minimum") != 20_000:
        raise ReleaseDifferentialError("demonstrated-primary release threshold changed")
    if thresholds.get("preferred_negative_count") != 20_308:
        raise ReleaseDifferentialError("preferred release negative count changed")
    if thresholds.get("observed_adversarial_total") != observed_counts["negative"]:
        raise ReleaseDifferentialError("observed adversarial threshold count is inconsistent")
    if (
        thresholds.get("observed_demonstrated_primary_minimal")
        != demonstrated_primary_minimal
    ):
        raise ReleaseDifferentialError(
            "observed demonstrated-primary threshold count is inconsistent"
        )
    if thresholds.get("count_scope") != (
        "qualification requires at least 20000 demonstrated byte-deletion-primary-minimal "
        "rows; 308 authored/host coverage rows are additional and every classified row "
        "carries a complete normative failure triple"
    ):
        raise ReleaseDifferentialError("classified-adversarial count scope changed")
    if thresholds.get("qualifies") is not qualifies:
        raise ReleaseDifferentialError("manifest release qualification flag is inconsistent")
    small_mode = thresholds.get("allow_small_test_mode")
    if type(small_mode) is not bool:
        raise ReleaseDifferentialError("manifest small/release mode metadata is invalid")
    if not qualifies and not small_mode:
        raise ReleaseDifferentialError("below-floor corpus was not marked as generator test mode")
    if (not qualifies or small_mode) and not allow_small:
        raise ReleaseDifferentialError(
            "corpus is generator test-mode or below release floors "
            "(use --allow-small-corpus only for tests)"
        )
    if not small_mode and (
        not source_worktree["clean_before"]
        or status_before
        or override_requested
        or override_used
    ):
        raise ReleaseDifferentialError(
            "release corpus was not generated from a clean, non-overridden source worktree"
        )

    logical_argv = manifest.get("logical_command_argv")
    if (
        type(logical_argv) is not list
        or not all(type(item) is str for item in logical_argv)
        or logical_argv[:2]
        != ["python3", "canonical-datum/generator/generate_corpus.py"]
    ):
        raise ReleaseDifferentialError("logical generator command metadata is invalid")
    expected_options = {
        "--seed": manifest.get("deterministic_seed"),
        "--positive-count": observed_counts["positive"],
        "--negative-count": observed_counts["negative"],
        "--mutation-sample-count": None,
        "--truncation-max-document-octets": manifest.get(
            "truncation_configuration", {}
        ).get("maximum_generated_document_octets"),
    }
    for option, expected in expected_options.items():
        observed = command_option(logical_argv, option)
        if expected is not None and observed != str(expected):
            raise ReleaseDifferentialError(
                f"logical command {option} disagrees with manifest metadata"
            )
        if expected is None:
            try:
                if int(observed) < 1:
                    raise ValueError
            except ValueError as exc:
                raise ReleaseDifferentialError(
                    f"logical command {option} is not a positive integer"
                ) from exc
    has_small_flag = "--allow-small" in logical_argv
    if has_small_flag is not small_mode:
        raise ReleaseDifferentialError("logical command small-mode flag is inconsistent")
    has_dirty_flag = "--allow-dirty-source" in logical_argv
    if has_dirty_flag is not override_requested:
        raise ReleaseDifferentialError("logical command dirty-source flag is inconsistent")
    if has_dirty_flag and not has_small_flag:
        raise ReleaseDifferentialError("dirty-source override was not restricted to test mode")
    if manifest.get("logical_command") != shlex.join(logical_argv):
        raise ReleaseDifferentialError("logical command transcript is missing")
    invocation = manifest.get("invocation_argv")
    if type(invocation) is not list or not all(type(item) is str for item in invocation):
        raise ReleaseDifferentialError("invocation_argv metadata is invalid")
    if manifest.get("invocation_command") != shlex.join(invocation):
        raise ReleaseDifferentialError("invocation command transcript is inconsistent")
    invocation_cwd = manifest.get("invocation_cwd")
    if type(invocation_cwd) is not str or not Path(invocation_cwd).is_absolute():
        raise ReleaseDifferentialError("invocation working-directory metadata is invalid")
    runtime = manifest.get("generator_runtime")
    if (
        type(runtime) is not dict
        or runtime.get("implementation") not in {"CPython", "PyPy"}
        or type(runtime.get("version")) is not str
        or type(runtime.get("random_engine")) is not str
    ):
        raise ReleaseDifferentialError("generator runtime metadata is invalid")
    if "A1-A9 are closed" not in str(manifest.get("errata_closure", "")):
        raise ReleaseDifferentialError("manifest does not record A1-A9 closure")
    root_tag_counts = manifest.get("positive_root_tag_counts")
    if (
        type(root_tag_counts) is not dict
        or any(type(value) is not int or value < 0 for value in root_tag_counts.values())
        or sum(root_tag_counts.values()) != observed_counts["positive"]
    ):
        raise ReleaseDifferentialError("positive root-tag count metadata is inconsistent")

    return {
        "manifest": manifest,
        "manifest_path": manifest_path,
        "manifest_sha256": sha256_file(manifest_path),
        "corpus_dir": corpus_dir,
        "counts": observed_counts,
        "normative_specifications": observed_normative,
        "corpus_sha256": observed_corpus_digest,
        "qualifies_for_release": qualifies and not small_mode,
        "demonstrated_primary_minimal": demonstrated_primary_minimal,
    }


def load_budgets(path: Path) -> dict[str, dict[str, int]]:
    try:
        document = json.loads(path.read_text(encoding="utf-8"))
        definitions = document["budgets"]
    except (OSError, json.JSONDecodeError, KeyError, TypeError) as exc:
        raise ReleaseDifferentialError(f"cannot load shared budgets: {exc}") from exc
    resolved: dict[str, dict[str, int]] = {}

    def resolve(name: str, active: tuple[str, ...] = ()) -> dict[str, int]:
        if name in resolved:
            return resolved[name]
        if name in active or name not in definitions:
            raise ReleaseDifferentialError(f"invalid budget inheritance at {name!r}")
        source = definitions[name]
        base = resolve(source["base"], active + (name,)) if "base" in source else {}
        value = {**base, **{key: item for key, item in source.items() if key != "base"}}
        if set(value) != set(BUDGET_FIELDS):
            raise ReleaseDifferentialError(f"budget {name!r} is incomplete")
        if any(type(item) is not int or item < 0 for item in value.values()):
            raise ReleaseDifferentialError(f"budget {name!r} has invalid limits")
        resolved[name] = value
        return value

    for name in definitions:
        resolve(name)
    return resolved


def resolve_budget(
    descriptor: str | Mapping[str, int],
    budgets: Mapping[str, Mapping[str, int]],
    row_id: str,
) -> tuple[dict[str, int], str]:
    if type(descriptor) is str:
        if descriptor not in budgets:
            raise ReleaseDifferentialError(f"{row_id}: unknown budget {descriptor!r}")
        return dict(budgets[descriptor]), descriptor
    if type(descriptor) is dict and set(descriptor) == set(BUDGET_FIELDS):
        if any(type(value) is not int or value < 0 for value in descriptor.values()):
            raise ReleaseDifferentialError(f"{row_id}: invalid inline budget")
        return dict(descriptor), f"inline:{row_id}"
    raise ReleaseDifferentialError(f"{row_id}: invalid budget descriptor")


def request_base(
    request_id: str, operation: str, budget: dict[str, int], budget_id: str
) -> dict[str, Any]:
    return {
        "protocol": PROTOCOL,
        "request_id": request_id,
        "op": operation,
        "budget": budget,
        "budget_id": budget_id,
    }


def validate_hex(value: Any, row_id: str, field: str) -> str:
    if type(value) is not str or HEX_RE.fullmatch(value) is None:
        raise ReleaseDifferentialError(f"{row_id}: {field} is not lowercase even-length hex")
    return value


def validate_positive(row: dict[str, Any], line_number: int) -> None:
    required = {
        "id",
        "datum_version",
        "abstract",
        "canonical_hex",
        "expected_decoded",
        "equality_class",
        "budget",
        "notes",
    }
    if set(row) != required:
        raise ReleaseDifferentialError(
            f"positive line {line_number}: fields differ from shared fixture schema"
        )
    row_id = row.get("id")
    if type(row_id) is not str or not row_id.startswith("cd0-pos-generated-"):
        raise ReleaseDifferentialError(f"positive line {line_number}: invalid id")
    if row.get("datum_version") != 0:
        raise ReleaseDifferentialError(f"{row_id}: datum version is not zero")
    if type(row.get("abstract")) is not dict or type(row.get("expected_decoded")) is not dict:
        raise ReleaseDifferentialError(f"{row_id}: fixture AST is not an object")
    validate_hex(row.get("canonical_hex"), row_id, "canonical_hex")
    if type(row.get("equality_class")) is not str or not row["equality_class"]:
        raise ReleaseDifferentialError(f"{row_id}: equality class is invalid")
    if type(row.get("notes")) is not list or not all(type(x) is str for x in row["notes"]):
        raise ReleaseDifferentialError(f"{row_id}: notes are invalid")


def validate_negative(row: dict[str, Any], line_number: int) -> None:
    required = {
        "id",
        "input_kind",
        "budget",
        "expected_failure",
        "input_classification",
        "resource_state_unchanged",
        "partial_output_forbidden",
        "notes",
    }
    if not required.issubset(row):
        raise ReleaseDifferentialError(f"negative line {line_number}: required fields missing")
    row_id = row.get("id")
    if type(row_id) is not str or not row_id.startswith("cd0-neg-generated-"):
        raise ReleaseDifferentialError(f"negative line {line_number}: invalid id")
    kind = row.get("input_kind")
    if kind == "octets":
        validate_hex(row.get("input_hex"), row_id, "input_hex")
        if "host_input" in row or "importer" in row:
            raise ReleaseDifferentialError(f"{row_id}: octet row has host fields")
    elif kind == "host":
        if type(row.get("host_input")) is not dict or type(row.get("importer")) is not str:
            raise ReleaseDifferentialError(f"{row_id}: host descriptor/importer invalid")
        if "input_hex" in row:
            raise ReleaseDifferentialError(f"{row_id}: host row has octets")
    else:
        raise ReleaseDifferentialError(f"{row_id}: unknown input kind")
    failure = row.get("expected_failure")
    if type(failure) is not dict or set(failure) != {"category", "code", "stage"}:
        raise ReleaseDifferentialError(f"{row_id}: expected failure triple invalid")
    if not all(type(failure[field]) is str and failure[field] for field in failure):
        raise ReleaseDifferentialError(f"{row_id}: expected failure member invalid")
    if "status" in row:
        raise ReleaseDifferentialError(f"{row_id}: v4 classified rows must not carry a provisional status")
    if row.get("resource_state_unchanged") is not True or row.get("partial_output_forbidden") is not True:
        raise ReleaseDifferentialError(f"{row_id}: refusal invariants are not asserted")
    allowed = required | {"input_hex", "host_input", "importer", "retry_budget"}
    if not set(row).issubset(allowed):
        raise ReleaseDifferentialError(f"{row_id}: fields differ from shared fixture schema")


def validate_mutation(row: dict[str, Any], line_number: int) -> None:
    required = {
        "id",
        "input_hex",
        "budget",
        "classification_status",
        "operation",
        "parameter",
        "promotion_rule",
        "source_hex",
        "source_positive_id",
        "source_scope",
    }
    if set(row) != required:
        raise ReleaseDifferentialError(
            f"mutation line {line_number}: fields differ from unclassified schema"
        )
    row_id = row.get("id")
    if type(row_id) is not str or not row_id.startswith("cd0-mut-"):
        raise ReleaseDifferentialError(f"mutation line {line_number}: invalid id")
    validate_hex(row.get("input_hex"), row_id, "input_hex")
    validate_hex(row.get("source_hex"), row_id, "source_hex")
    if row.get("classification_status") != "unclassified-may-have-multiple-defects":
        raise ReleaseDifferentialError(f"{row_id}: mutation acquired a classification")
    if "expected_failure" in row:
        raise ReleaseDifferentialError(f"{row_id}: mutation acquired a permanent triple")
    if "minimize" not in str(row.get("promotion_rule", "")):
        raise ReleaseDifferentialError(f"{row_id}: mutation promotion rule lost minimization")


def warranted_fields(row: Mapping[str, Any]) -> tuple[str, ...]:
    if "status" in row:
        raise ReleaseDifferentialError("v4 classified rows must use the complete normative triple")
    return ("category", "code", "stage")


class DifferenceLedger:
    def __init__(self, path: Path | None, sample_limit: int = 32) -> None:
        self.count = 0
        self._digest = hashlib.sha256()
        self.samples: list[dict[str, Any]] = []
        self._stream = path.open("w", encoding="ascii", newline="\n") if path else None
        self.sample_limit = sample_limit

    def add(self, record: dict[str, Any]) -> None:
        line = canonical_json(record) + "\n"
        self._digest.update(line.encode("ascii"))
        if self._stream:
            self._stream.write(line)
        if len(self.samples) < self.sample_limit:
            self.samples.append(record)
        self.count += 1

    def finish(self) -> dict[str, Any]:
        if self._stream:
            self._stream.close()
        return {
            "count": self.count,
            "sha256": self._digest.hexdigest(),
            "sample_limit": self.sample_limit,
            "samples": self.samples,
            "truncated": self.count > len(self.samples),
        }


class Report:
    def __init__(self, difference_ledger: DifferenceLedger) -> None:
        self.counts: defaultdict[str, int] = defaultdict(int)
        self.issues: list[str] = []
        self.issue_count = 0
        self._issue_digest = hashlib.sha256()
        self.issue_sample_limit = 100
        self.host_row_dispositions: list[dict[str, Any]] = []
        self.mutation_outcomes: defaultdict[str, int] = defaultdict(int)
        self.differences = difference_ledger

    def issue(self, message: str) -> None:
        self.issue_count += 1
        self._issue_digest.update((message + "\n").encode("utf-8"))
        if len(self.issues) < self.issue_sample_limit:
            self.issues.append(message)

    def issue_summary(self) -> dict[str, Any]:
        return {
            "count": self.issue_count,
            "sha256": self._issue_digest.hexdigest(),
            "sample_limit": self.issue_sample_limit,
            "samples": self.issues,
            "truncated": self.issue_count > len(self.issues),
        }


def require_ok(response: dict[str, Any], request_id: str, label: str, report: Report) -> bool:
    if response.get("status") != "ok" or type(response.get("result")) is not dict:
        report.issue(f"{request_id}: {label} did not succeed: {response}")
        return False
    return True


def compare_positive(
    meta: dict[str, Any], cl: dict[str, Any], py: dict[str, Any], report: Report
) -> None:
    row = meta["row"]
    request_id = meta["request_id"]
    report.counts["positive_rows"] += 1
    expected = {
        "canonical_hex": row["canonical_hex"],
        "fixture_ast": row["expected_decoded"],
        "reencoded_hex": row["canonical_hex"],
        "constructed_equal_decoded": True,
    }
    both_ok = True
    for label, response in (("common-lisp", cl), ("python", py)):
        if not require_ok(response, request_id, label, report):
            both_ok = False
            continue
        for field, value in expected.items():
            if response["result"].get(field) != value:
                report.issue(f"{request_id}: {label} positive field {field} differs")
                both_ok = False
    if both_ok and cl["result"] != py["result"]:
        report.issue(f"{request_id}: successful codec positive results disagree")


def compare_equality(
    meta: dict[str, Any], cl: dict[str, Any], py: dict[str, Any], report: Report
) -> None:
    request_id = meta["request_id"]
    left = meta["left"]
    right = meta["right"]
    expected_equal = left["equality_class"] == right["equality_class"]
    bytes_equal = left["canonical_hex"] == right["canonical_hex"]
    report.counts["equality_judgments"] += 1
    report.counts[f"equality_{meta['pair_kind']}_pairs"] += 1
    if expected_equal is not bytes_equal:
        report.issue(
            f"{request_id}: fixture equality class violates equality iff canonical bytes"
        )
    both_ok = True
    for label, response in (("common-lisp", cl), ("python", py)):
        if not require_ok(response, request_id, label, report):
            both_ok = False
            continue
        result = response["result"]
        if result.get("equal") is not expected_equal:
            report.issue(f"{request_id}: {label} equality judgment differs")
            both_ok = False
        if result.get("left_hex") != left["canonical_hex"]:
            report.issue(f"{request_id}: {label} left equality bytes differ")
            both_ok = False
        if result.get("right_hex") != right["canonical_hex"]:
            report.issue(f"{request_id}: {label} right equality bytes differ")
            both_ok = False
        if (result.get("left_hex") == result.get("right_hex")) is not bool(
            result.get("equal")
        ):
            report.issue(f"{request_id}: {label} violates equality iff encoding")
            both_ok = False
    if both_ok and cl["result"] != py["result"]:
        report.issue(f"{request_id}: codec equality results disagree")


def compare_negative(
    meta: dict[str, Any], cl: dict[str, Any], py: dict[str, Any], report: Report
) -> None:
    row = meta["row"]
    request_id = meta["request_id"]
    status = "normative"
    fields = warranted_fields(row)
    report.counts["classified_negative_rows"] += 1
    report.counts[f"negative_{status}_rows"] += 1
    is_host = row["input_kind"] == "host"
    cl_optional = is_host and row["importer"] in OPTIONAL_CL_IMPORTERS
    applicable: list[tuple[str, dict[str, Any]]] = []

    if cl_optional:
        if cl.get("status") != "not-applicable":
            report.issue(f"{request_id}: Common Lisp optional importer must be N/A: {cl}")
        else:
            report.counts["common_lisp_host_not_applicable"] += 1
            if type(cl.get("reason")) is not str or not cl["reason"]:
                report.issue(f"{request_id}: Common Lisp N/A lacks an explicit reason")
        report.counts["negative_partial_language_applicability_rows"] += 1
    else:
        if cl.get("status") == "not-applicable":
            report.issue(f"{request_id}: unexpected Common Lisp N/A")
        else:
            applicable.append(("common-lisp", cl))

    if py.get("status") == "not-applicable":
        report.issue(f"{request_id}: unexpected Python N/A")
    else:
        applicable.append(("python", py))

    if not cl_optional:
        report.counts["negative_fully_executed_rows"] += 1
    failures: list[tuple[str, dict[str, Any]]] = []
    for label, response in applicable:
        report.counts[f"{label}_negative_executions"] += 1
        if response.get("status") != "failure" or type(response.get("failure")) is not dict:
            report.issue(f"{request_id}: {label} negative did not fail: {response}")
            continue
        actual = response["failure"]
        if set(actual) != {"category", "code", "stage"}:
            report.issue(f"{request_id}: {label} returned a malformed failure triple")
            continue
        expected = row["expected_failure"]
        if any(actual.get(field) != expected[field] for field in fields):
            report.issue(
                f"{request_id}: {label} warranted failure mismatch "
                f"actual={actual} expected={expected} fields={fields}"
            )
        failures.append((label, actual))

    if len(failures) == 2:
        left, right = failures
        if any(left[1].get(field) != right[1].get(field) for field in fields):
            report.issue(
                f"{request_id}: cross-codec warranted failure disagreement "
                f"CL={left[1]} Python={right[1]} fields={fields}"
            )

    if is_host:
        report.host_row_dispositions.append(
            {
                "id": row["id"],
                "importer": row["importer"],
                "common_lisp": "not-applicable" if cl_optional else "executed-failure",
                "python": "executed-failure",
                "row_disposition": (
                    "partial-language-applicability"
                    if cl_optional
                    else "fully-executed"
                ),
                "common_lisp_n_a_counts_as_pass": False if cl_optional else None,
            }
        )


def compare_retry(
    meta: dict[str, Any], cl: dict[str, Any], py: dict[str, Any], report: Report
) -> None:
    request_id = meta["request_id"]
    expected_hex = meta["input_hex"]
    report.counts["retry_budget_checks"] += 1
    both_ok = True
    for label, response in (("common-lisp", cl), ("python", py)):
        if not require_ok(response, request_id, label, report):
            both_ok = False
            continue
        result = response["result"]
        if result.get("canonical_hex") != expected_hex:
            report.issue(f"{request_id}: {label} retry did not preserve canonical input")
            both_ok = False
        if type(result.get("fixture_ast")) is not dict:
            report.issue(f"{request_id}: {label} retry omitted normalized fixture AST")
            both_ok = False
    if both_ok and cl["result"] != py["result"]:
        report.issue(f"{request_id}: retry normalized results disagree")


def mutation_observation(response: dict[str, Any]) -> dict[str, Any]:
    status = response.get("status")
    if status == "ok" and type(response.get("result")) is dict:
        canonical_hex = response["result"].get("canonical_hex")
        fixture_ast = response["result"].get("fixture_ast")
        if (
            type(canonical_hex) is str
            and HEX_RE.fullmatch(canonical_hex) is not None
            and type(fixture_ast) is dict
        ):
            return {
                "status": "ok",
                "canonical_hex": canonical_hex,
                "fixture_ast": fixture_ast,
            }
        return {"status": "malformed-ok", "protocol_response": response}
    if status == "failure" and type(response.get("failure")) is dict:
        failure = response["failure"]
        if set(failure) == {"category", "code", "stage"} and all(
            type(failure[field]) is str and failure[field] for field in failure
        ):
            return {"status": "failure", "failure": failure}
        return {"status": "malformed-failure", "protocol_response": response}
    return {"status": status, "protocol_response": response}


def compare_mutation(
    meta: dict[str, Any], cl: dict[str, Any], py: dict[str, Any], report: Report
) -> None:
    row = meta["row"]
    request_id = meta["request_id"]
    report.counts["unclassified_mutation_candidates"] += 1
    cl_obs = mutation_observation(cl)
    py_obs = mutation_observation(py)
    classification = (
        "unclassified; minimization required before assigning a primary defect"
    )
    issue = f"{request_id}: unclassified mutation disagreement; minimization required"
    if cl_obs == py_obs and cl_obs["status"] == "failure":
        report.mutation_outcomes["both_failure_same_triple"] += 1
        return
    if cl_obs == py_obs and cl_obs["status"] == "ok":
        if cl_obs["canonical_hex"] == row["input_hex"]:
            report.mutation_outcomes["both_success_identical"] += 1
            return
        report.mutation_outcomes["both_success_changed_input"] += 1
        classification = (
            "both codecs accepted exact-decode input but normalized to different bytes; "
            "conformance review and minimization required"
        )
        issue = (
            f"{request_id}: both codecs accepted a mutation but changed its canonical bytes; "
            "conformance review and minimization required"
        )
    report.mutation_outcomes["minimization_required_disagreements"] += 1
    record = {
        "id": row["id"],
        "source_positive_id": row["source_positive_id"],
        "operation": row["operation"],
        "input_octets": len(row["input_hex"]) // 2,
        "input_sha256": sha256_bytes(bytes.fromhex(row["input_hex"])),
        "common_lisp": cl_obs,
        "python": py_obs,
        "classification": classification,
    }
    report.differences.add(record)
    report.issue(issue)


Comparator = Callable[[dict[str, Any], dict[str, Any], dict[str, Any], Report], None]


def serialize_requests(requests: Sequence[dict[str, Any]]) -> bytes:
    return "".join(canonical_json(request) + "\n" for request in requests).encode("ascii")


def parse_responses(
    payload: bytes,
    implementation: str,
    expected_ids: set[str],
) -> dict[str, dict[str, Any]]:
    responses: dict[str, dict[str, Any]] = {}
    try:
        text = payload.decode("utf-8")
    except UnicodeDecodeError as exc:
        raise ReleaseDifferentialError(f"{implementation} adapter output is not UTF-8") from exc
    for line_number, line in enumerate(text.splitlines(), 1):
        if not line.strip():
            continue
        try:
            response = json.loads(line)
        except json.JSONDecodeError as exc:
            raise ReleaseDifferentialError(
                f"{implementation} response line {line_number} is invalid JSON"
            ) from exc
        if type(response) is not dict:
            raise ReleaseDifferentialError(f"{implementation} response is not an object")
        if response.get("protocol") != PROTOCOL:
            raise ReleaseDifferentialError(f"{implementation} protocol mismatch")
        if response.get("implementation") != implementation:
            raise ReleaseDifferentialError(f"{implementation} label mismatch")
        request_id = response.get("request_id")
        if type(request_id) is not str or request_id in responses:
            raise ReleaseDifferentialError(f"{implementation} duplicate/invalid request id")
        responses[request_id] = response
    missing = sorted(expected_ids - set(responses))
    extra = sorted(set(responses) - expected_ids)
    if missing or extra:
        raise ReleaseDifferentialError(
            f"{implementation} response set mismatch: missing={missing[:3]} extra={extra[:3]}"
        )
    return responses


def run_adapter(
    implementation: str,
    command: Sequence[str],
    request_path: Path,
    timeout_seconds: float,
    environment: Mapping[str, str] | None,
) -> dict[str, Any]:
    started = time.monotonic()
    try:
        completed = subprocess.run(
            [*command, str(request_path)],
            cwd=REPO_ROOT,
            env=None if environment is None else dict(environment),
            capture_output=True,
            check=False,
            timeout=timeout_seconds,
        )
    except subprocess.TimeoutExpired as exc:
        raise ReleaseDifferentialError(
            f"{implementation} adapter exceeded {timeout_seconds:g}s batch timeout"
        ) from exc
    except OSError as exc:
        raise ReleaseDifferentialError(
            f"{implementation} adapter could not be started: {exc}"
        ) from exc
    elapsed = time.monotonic() - started
    if completed.returncode != 0:
        raise ReleaseDifferentialError(
            f"{implementation} adapter exited {completed.returncode}; "
            f"stdout_tail={completed.stdout[-2000:]!r}; stderr_tail={completed.stderr[-4000:]!r}"
        )
    return {
        "stdout": completed.stdout,
        "stderr": completed.stderr,
        "elapsed_seconds": elapsed,
        "command": [*command, "<batch-requests.jsonl>"],
    }


class BatchCoordinator:
    def __init__(
        self,
        *,
        report: Report,
        batch_size: int,
        timeout_seconds: float,
        artifacts_dir: Path | None,
    ) -> None:
        self.report = report
        self.batch_size = batch_size
        self.timeout_seconds = timeout_seconds
        self.artifacts_dir = artifacts_dir
        self.requests: list[dict[str, Any]] = []
        self.metadata: list[tuple[dict[str, Any], Comparator]] = []
        self.batch_ledger: list[dict[str, Any]] = []
        self.batch_index = 0
        self._seen_request_ids: set[str] = set()

    def add(self, request: dict[str, Any], meta: dict[str, Any], comparator: Comparator) -> None:
        request_id = request["request_id"]
        if request_id in self._seen_request_ids:
            raise ReleaseDifferentialError(f"duplicate request id: {request_id}")
        self._seen_request_ids.add(request_id)
        meta["request_id"] = request_id
        self.requests.append(request)
        self.metadata.append((meta, comparator))
        if len(self.requests) >= self.batch_size:
            self.flush()

    def flush(self) -> None:
        if not self.requests:
            return
        self.batch_index += 1
        request_bytes = serialize_requests(self.requests)
        expected_ids = {request["request_id"] for request in self.requests}
        if len(expected_ids) != len(self.requests):
            raise ReleaseDifferentialError("batch request ids are not unique")
        temporary: tempfile.TemporaryDirectory[str] | None = None
        if self.artifacts_dir:
            work = self.artifacts_dir
        else:
            temporary = tempfile.TemporaryDirectory(prefix="cd0-release-batch-")
            work = Path(temporary.name)
        stem = f"batch-{self.batch_index:05d}"
        request_path = work / f"{stem}-requests.jsonl"
        request_path.write_bytes(request_bytes)

        python_environment = dict(os.environ)
        python_environment["PYTHONPATH"] = str(REPO_ROOT / "canonical-datum" / "python")
        python_environment["PYTHONHASHSEED"] = "137"
        python_environment["PYTHONINTMAXSTRDIGITS"] = "640"
        runs = {
            "common-lisp": run_adapter(
                "common-lisp",
                [
                    "sbcl",
                    "--noinform",
                    "--disable-debugger",
                    "--script",
                    str(INTEGRATION_DIR / "common_lisp_adapter.lisp"),
                ],
                request_path,
                self.timeout_seconds,
                None,
            ),
            "python": run_adapter(
                "python",
                [sys.executable, str(INTEGRATION_DIR / "python_adapter.py")],
                request_path,
                self.timeout_seconds,
                python_environment,
            ),
        }
        responses = {
            label: parse_responses(run["stdout"], label, expected_ids)
            for label, run in runs.items()
        }
        for meta, comparator in self.metadata:
            request_id = meta["request_id"]
            comparator(
                meta,
                responses["common-lisp"][request_id],
                responses["python"][request_id],
                self.report,
            )

        response_records: dict[str, Any] = {}
        for label, run in runs.items():
            if self.artifacts_dir:
                (work / f"{stem}-{label}-responses.jsonl").write_bytes(run["stdout"])
                (work / f"{stem}-{label}-stderr.txt").write_bytes(run["stderr"])
            response_records[label] = {
                "response_count": len(responses[label]),
                "response_sha256": sha256_bytes(run["stdout"]),
                "response_octets": len(run["stdout"]),
                "stderr_sha256": sha256_bytes(run["stderr"]),
                "stderr_octets": len(run["stderr"]),
                "elapsed_seconds": round(run["elapsed_seconds"], 6),
                "command": run["command"],
            }
        self.batch_ledger.append(
            {
                "batch": self.batch_index,
                "request_count": len(self.requests),
                "request_sha256": sha256_bytes(request_bytes),
                "request_octets": len(request_bytes),
                "responses": response_records,
            }
        )
        self.report.counts["adapter_requests_per_implementation"] += len(self.requests)
        self.requests.clear()
        self.metadata.clear()
        if temporary:
            temporary.cleanup()


def positive_requests(
    path: Path,
    budgets: Mapping[str, Mapping[str, int]],
    coordinator: BatchCoordinator,
) -> dict[str, Any]:
    ids: set[str] = set()
    equality_to_hex: dict[str, str] = {}
    hex_to_equality: dict[str, str] = {}
    for line_number, row in jsonl_rows(path):
        validate_positive(row, line_number)
        row_id = row["id"]
        if row_id in ids:
            raise ReleaseDifferentialError(f"duplicate positive id: {row_id}")
        ids.add(row_id)
        equality_class = row["equality_class"]
        canonical_hex = row["canonical_hex"]
        if canonical_hex in hex_to_equality:
            raise ReleaseDifferentialError(
                f"{row_id}: generated positive canonical document is not unique"
            )
        previous_hex = equality_to_hex.setdefault(equality_class, canonical_hex)
        hex_to_equality[canonical_hex] = equality_class
        if previous_hex != canonical_hex:
            raise ReleaseDifferentialError(
                f"{row_id}: global equality-class/canonical-byte bijection violated"
            )
        budget, budget_id = resolve_budget(row["budget"], budgets, row_id)
        request = request_base(f"positive:{row_id}", "construct-roundtrip", budget, budget_id)
        request["ast"] = row["abstract"]
        coordinator.add(request, {"row": row}, compare_positive)
    return {"ids": ids, "count": len(ids)}


def equality_requests(
    path: Path,
    budgets: Mapping[str, Mapping[str, int]],
    coordinator: BatchCoordinator,
) -> int:
    default, default_id = resolve_budget(
        "cd0-conformance-default", budgets, "generated-equality"
    )
    first: dict[str, Any] | None = None
    previous: dict[str, Any] | None = None
    count = 0

    def add_pair(left: dict[str, Any], right: dict[str, Any], kind: str) -> None:
        nonlocal count
        count += 1
        request_id = f"equality:{kind}:{count:08d}:{left['id']}:{right['id']}"
        request = request_base(request_id, "equal", dict(default), default_id)
        request["left_ast"] = left["abstract"]
        request["right_ast"] = right["abstract"]
        coordinator.add(
            request,
            {"left": left, "right": right, "pair_kind": kind},
            compare_equality,
        )

    for _, row in jsonl_rows(path):
        if first is None:
            first = row
        add_pair(row, row, "self")
        if previous is not None:
            add_pair(previous, row, "neighbor")
        previous = row
    if first is not None and previous is not first:
        add_pair(previous, first, "neighbor")
    return count


def negative_requests(
    path: Path,
    budgets: Mapping[str, Mapping[str, int]],
    coordinator: BatchCoordinator,
) -> dict[str, Any]:
    ids: set[str] = set()
    host_ids: list[str] = []
    retry_count = 0
    for line_number, row in jsonl_rows(path):
        validate_negative(row, line_number)
        row_id = row["id"]
        if row_id in ids:
            raise ReleaseDifferentialError(f"duplicate negative id: {row_id}")
        ids.add(row_id)
        budget, budget_id = resolve_budget(row["budget"], budgets, row_id)
        operation = "decode" if row["input_kind"] == "octets" else "host-import"
        request = request_base(f"negative:{row_id}", operation, budget, budget_id)
        request["case_id"] = row_id
        if operation == "decode":
            request["input_hex"] = row["input_hex"]
        else:
            host_ids.append(row_id)
            request["host_input"] = row["host_input"]
            request["importer"] = row["importer"]
            # The CL adapter constructs these two language-neutral shapes by a
            # stable seed case name; generated row ids must not become semantics.
            if row["importer"] == "generic-sequence-import/v0":
                request["case_id"] = (
                    "cd0-neg-host-cycle"
                    if row["expected_failure"]["code"] == "CyclicHostInput"
                    else "cd0-neg-host-improper-list"
                )
        coordinator.add(request, {"row": row}, compare_negative)

        if "retry_budget" in row:
            if row["input_kind"] != "octets":
                raise ReleaseDifferentialError(f"{row_id}: host row cannot have retry_budget")
            retry_count += 1
            retry_budget, retry_id = resolve_budget(
                row["retry_budget"], budgets, f"{row_id}:retry"
            )
            retry = request_base(
                f"retry:{row_id}", "decode", retry_budget, retry_id
            )
            retry["input_hex"] = row["input_hex"]
            coordinator.add(
                retry,
                {"row_id": row_id, "input_hex": row["input_hex"]},
                compare_retry,
            )
    return {"count": len(ids), "host_ids": host_ids, "retry_count": retry_count}


def mutation_requests(
    path: Path,
    budgets: Mapping[str, Mapping[str, int]],
    coordinator: BatchCoordinator,
) -> int:
    ids: set[str] = set()
    for line_number, row in jsonl_rows(path):
        validate_mutation(row, line_number)
        row_id = row["id"]
        if row_id in ids:
            raise ReleaseDifferentialError(f"duplicate mutation id: {row_id}")
        ids.add(row_id)
        budget, budget_id = resolve_budget(row["budget"], budgets, row_id)
        request = request_base(f"mutation:{row_id}", "decode", budget, budget_id)
        request["input_hex"] = row["input_hex"]
        coordinator.add(request, {"row": row}, compare_mutation)
    return len(ids)


def load_promoted_errata_cases() -> list[dict[str, Any]]:
    try:
        document = json.loads(ERRATA_VECTOR_PATH.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as exc:
        raise ReleaseDifferentialError(f"cannot load promoted errata vectors: {exc}") from exc
    if document.get("schema") != "cd0-errata-vectors/0.1":
        raise ReleaseDifferentialError("promoted errata vector schema mismatch")
    if document.get("ruling_sha256") != EXPECTED_NORMATIVE_SHA256["post-implementation-ruling"]["sha256"]:
        raise ReleaseDifferentialError("promoted vectors do not pin the ruling")
    if document.get("errata_sha256") != EXPECTED_NORMATIVE_SHA256["errata-0.1"]["sha256"]:
        raise ReleaseDifferentialError("promoted vectors do not pin Errata 0.1")
    cases = document.get("cases")
    if type(cases) is not list or any(type(case) is not dict for case in cases):
        raise ReleaseDifferentialError("promoted errata cases are malformed")
    counts: defaultdict[str, int] = defaultdict(int)
    ids: set[str] = set()
    for case in cases:
        case_id = case.get("id")
        adjudication = case.get("adjudication")
        if type(case_id) is not str or case_id in ids:
            raise ReleaseDifferentialError("promoted errata ids are invalid or duplicated")
        if adjudication not in ERRATA_CASE_COUNTS:
            raise ReleaseDifferentialError(f"{case_id}: unknown errata adjudication")
        ids.add(case_id)
        counts[adjudication] += 1
    if dict(sorted(counts.items())) != ERRATA_CASE_COUNTS:
        raise ReleaseDifferentialError("promoted A1-A9 case counts changed")
    return cases


def compare_promoted_errata(
    meta: dict[str, Any], cl: dict[str, Any], py: dict[str, Any], report: Report
) -> None:
    case = meta["case"]
    request_id = meta["request_id"]
    expected = case["expected"]
    report.counts["promoted_errata_vectors"] += 1
    report.counts[f"promoted_errata_{case['adjudication'].lower()}"] += 1
    successful_responses: list[tuple[str, dict[str, Any]]] = []
    for label, response in (("common-lisp", cl), ("python", py)):
        if response.get("status") != expected.get("status"):
            report.issue(
                f"{request_id}: {label} errata disposition differs: "
                f"actual={response.get('status')} expected={expected.get('status')}"
            )
            continue
        if expected["status"] == "failure":
            if response.get("failure") != expected.get("failure"):
                report.issue(
                    f"{request_id}: {label} errata failure differs: "
                    f"actual={response.get('failure')} expected={expected.get('failure')}"
                )
                continue
        elif expected["status"] == "ok":
            result = response.get("result")
            expected_result = expected.get("result", {})
            if type(result) is not dict or any(
                result.get(field) != value for field, value in expected_result.items()
            ):
                report.issue(
                    f"{request_id}: {label} errata result differs: "
                    f"actual={result} expected_fields={expected_result}"
                )
                continue
        else:
            report.issue(f"{request_id}: malformed expected errata disposition")
            continue
        successful_responses.append((label, response))
    if len(successful_responses) == 2:
        left = successful_responses[0][1]
        right = successful_responses[1][1]
        outcome_field = "failure" if expected["status"] == "failure" else "result"
        if left.get(outcome_field) != right.get(outcome_field):
            report.issue(f"{request_id}: codecs disagree on promoted errata result")


def promoted_errata_requests(
    budgets: Mapping[str, Mapping[str, int]],
    coordinator: BatchCoordinator,
) -> int:
    cases = load_promoted_errata_cases()
    for case in cases:
        case_id = case["id"]
        budget, budget_id = resolve_budget(case["budget"], budgets, case_id)
        overrides = case.get("overrides", {})
        if (
            type(overrides) is not dict
            or not set(overrides).issubset(BUDGET_FIELDS)
            or any(type(value) is not int or value < 0 for value in overrides.values())
        ):
            raise ReleaseDifferentialError(f"{case_id}: invalid errata budget overrides")
        budget.update(overrides)
        request = request_base(
            f"errata:{case_id}", case["op"], budget, f"errata:{budget_id}"
        )
        for field in ("input_hex", "ast", "construction"):
            if field in case:
                request[field] = case[field]
        if case["op"] == "runtime-encode":
            request["admission_budget"] = dict(budgets["cd0-conformance-default"])
            request["admission_budget_id"] = "cd0-conformance-default"
        coordinator.add(request, {"case": case}, compare_promoted_errata)
    return len(cases)


def host_scenario_dispositions(path: Path, positive_ids: set[str]) -> dict[str, Any]:
    document = json.loads(path.read_text(encoding="ascii"))
    if document.get("schema") != "cd0-host-property-scenarios/v1":
        raise ReleaseDifferentialError("host property scenario schema mismatch")
    if document.get("factual_status") != (
        "scenario metadata only; execution is owned by separately retained Phase-4 "
        "evidence and is not asserted here"
    ):
        raise ReleaseDifferentialError("host scenario factual-status boundary changed")
    if document.get("integration_adapter_note") != (
        "generated host rows require explicit Common Lisp and Python integration adapters "
        "before differential execution"
    ):
        raise ReleaseDifferentialError("host scenario integration-adapter boundary changed")
    if set(document) != {
        "schema",
        "factual_status",
        "integration_adapter_note",
        "scenarios",
        "resource_boundary_scenarios",
    }:
        raise ReleaseDifferentialError("host/resource scenario document field set changed")
    scenarios = document.get("scenarios")
    if (
        type(scenarios) is not list
        or len(scenarios) != len(EXPECTED_HOST_SCENARIOS)
        or {row.get("id") for row in scenarios} != EXPECTED_HOST_SCENARIOS
    ):
        raise ReleaseDifferentialError("host property scenario id set mismatch")
    dispositions: list[dict[str, Any]] = []
    for scenario in scenarios:
        if scenario.get("execution_status") != "not-executed-by-generator":
            raise ReleaseDifferentialError(
                f"{scenario.get('id')}: host execution-status boundary changed"
            )
        scenario_id = scenario["id"]
        if scenario_id in {"cd0-host-property-cycle", "cd0-host-property-improper-list"}:
            state = "covered-by-equivalent-classified-host-negative"
            owner = "generated differential runner"
        elif scenario_id == "cd0-host-property-inert-records":
            refs = scenario.get("positive_vector_refs")
            if type(refs) is not list or not set(refs).issubset(positive_ids):
                raise ReleaseDifferentialError("inert-record scenario references missing positives")
            state = "canonical-shapes-validated; inertness-instrumentation-not-run-here"
            owner = "Phase-4 qualification"
        else:
            state = "metadata-validated; property-not-run-here"
            owner = "Phase-4 qualification"
        dispositions.append(
            {
                "id": scenario_id,
                "kind": scenario.get("kind"),
                "disposition": state,
                "evidence_owner": owner,
                "counts_as_exercised": state.startswith("covered-by-equivalent"),
                "metadata_disposition_alone_counts_as_pass": False,
            }
        )

    resource_rows = document.get("resource_boundary_scenarios")
    if type(resource_rows) is not list or len(resource_rows) != len(BUDGET_FIELDS):
        raise ReleaseDifferentialError("resource-boundary scenario count mismatch")
    if {row.get("limit") for row in resource_rows} != set(BUDGET_FIELDS):
        raise ReleaseDifferentialError("resource-boundary scenarios do not cover all limits")
    resource_dispositions: list[dict[str, Any]] = []
    for row in resource_rows:
        row_id = row.get("id")
        if type(row_id) is not str or not row_id.startswith("cd0-resource-boundary-"):
            raise ReleaseDifferentialError("resource-boundary scenario id is invalid")
        if row.get("execution_status") != "not-executed-by-generator":
            raise ReleaseDifferentialError(
                f"{row_id}: resource execution-status boundary changed"
            )
        if row.get("operation") not in {
            "decode-exact",
            "encode-exact",
            "fixture-import-then-encode-exact",
        }:
            raise ReleaseDifferentialError(f"{row_id}: resource operation is invalid")
        if row.get("budget_base") != "cd0-conformance-default":
            raise ReleaseDifferentialError(f"{row_id}: resource base budget changed")
        if type(row.get("accept_value")) is not int or type(row.get("refuse_value")) is not int:
            raise ReleaseDifferentialError(f"{row_id}: resource boundary values are invalid")
        failure = row.get("expected_refusal")
        if (
            type(failure) is not dict
            or set(failure) != {"category", "code", "stage", "status"}
            or failure.get("category") != "ResourceRefusal"
        ):
            raise ReleaseDifferentialError(f"{row_id}: resource failure metadata is invalid")
        if type(row.get("success_assertion")) is not str:
            raise ReleaseDifferentialError(f"{row_id}: resource success assertion is missing")
        if "input_hex" in row:
            validate_hex(row["input_hex"], row_id, "input_hex")
        elif type(row.get("fixture_ast")) is not dict:
            raise ReleaseDifferentialError(f"{row_id}: resource probe input is missing")
        status = failure["status"]
        if status != "normative":
            raise ReleaseDifferentialError(f"{row_id}: resource refusal is not normative")
        resource_dispositions.append(
            {
                "id": row_id,
                "limit": row["limit"],
                "operation": row["operation"],
                "expected_status": status,
                "disposition": "metadata-validated; boundary-probe-not-run-here",
                "evidence_owner": "Phase-4 qualification",
                "metadata_disposition_alone_counts_as_pass": False,
            }
        )
    return {
        "host_properties": dispositions,
        "resource_boundaries": resource_dispositions,
    }


def prepare_artifacts_dir(path: Path | None) -> Path | None:
    if path is None:
        return None
    path = path.resolve()
    if path.exists() and any(path.iterdir()):
        raise ReleaseDifferentialError(f"refusing nonempty artifacts directory: {path}")
    path.mkdir(parents=True, exist_ok=True)
    return path


def run(
    corpus_dir: Path,
    *,
    allow_small: bool,
    batch_size: int,
    timeout_seconds: float,
    artifacts_dir: Path | None,
) -> dict[str, Any]:
    if batch_size < 1:
        raise ReleaseDifferentialError("batch size must be positive")
    if timeout_seconds <= 0:
        raise ReleaseDifferentialError("timeout must be positive")
    corpus_dir = corpus_dir.resolve()
    provenance = verify_manifest(corpus_dir, allow_small=allow_small)
    valid_datum_compatibility = compare_audited_positive_semantics(
        corpus_dir / ARTIFACT_NAMES["positive"],
        release_qualified=provenance["qualifies_for_release"],
    )
    if artifacts_dir is not None and artifacts_dir.resolve().is_relative_to(corpus_dir):
        raise ReleaseDifferentialError(
            "artifacts directory must not be the corpus directory or one of its descendants"
        )
    artifacts_dir = prepare_artifacts_dir(artifacts_dir)
    difference_path = artifacts_dir / "mutation-disagreements.jsonl" if artifacts_dir else None
    report = Report(DifferenceLedger(difference_path))
    coordinator = BatchCoordinator(
        report=report,
        batch_size=batch_size,
        timeout_seconds=timeout_seconds,
        artifacts_dir=artifacts_dir,
    )
    budgets = load_budgets(BUDGET_PATH)

    positives = positive_requests(
        corpus_dir / ARTIFACT_NAMES["positive"], budgets, coordinator
    )
    equality_count = equality_requests(
        corpus_dir / ARTIFACT_NAMES["positive"], budgets, coordinator
    )
    negatives = negative_requests(
        corpus_dir / ARTIFACT_NAMES["negative"], budgets, coordinator
    )
    mutation_count = mutation_requests(
        corpus_dir / ARTIFACT_NAMES["mutations"], budgets, coordinator
    )
    errata_count = promoted_errata_requests(budgets, coordinator)
    coordinator.flush()

    if positives["count"] != provenance["counts"]["positive"]:
        raise ReleaseDifferentialError("positive request count changed after provenance verification")
    if negatives["count"] != provenance["counts"]["negative"]:
        raise ReleaseDifferentialError("negative request count changed after provenance verification")
    if negatives["retry_count"] != provenance["manifest"]["counts"]["negative_retry_verified"]:
        raise ReleaseDifferentialError("retry request count changed after provenance verification")
    if mutation_count != provenance["counts"]["mutations"]:
        raise ReleaseDifferentialError("mutation request count changed after provenance verification")
    if errata_count != sum(ERRATA_CASE_COUNTS.values()):
        raise ReleaseDifferentialError("promoted errata request count changed")
    expected_equality = positives["count"] * 2 if positives["count"] > 1 else positives["count"]
    if equality_count != expected_equality:
        raise ReleaseDifferentialError("deterministic equality pair count is inconsistent")
    if len(report.host_row_dispositions) != len(negatives["host_ids"]):
        raise ReleaseDifferentialError("not every generated host negative was dispositioned")
    observed_optional = {
        row["importer"] for row in report.host_row_dispositions if row["common_lisp"] == "not-applicable"
    }
    if observed_optional != OPTIONAL_CL_IMPORTERS:
        raise ReleaseDifferentialError(
            "the three declared Common Lisp optional/language-specific importers changed"
        )

    scenario_dispositions = host_scenario_dispositions(
        corpus_dir / ARTIFACT_NAMES["host_scenarios"], positives["ids"]
    )
    difference_summary = report.differences.finish()
    counts = dict(sorted(report.counts.items()))
    if {"normative": counts.get("negative_normative_rows", 0)} != provenance[
        "manifest"
    ]["counts"]["classified_negative_by_status"]:
        raise ReleaseDifferentialError("executed negative status counts differ from manifest")
    observed_errata_counts = {
        adjudication: counts.get(f"promoted_errata_{adjudication.lower()}", 0)
        for adjudication in ERRATA_CASE_COUNTS
    }
    if observed_errata_counts != ERRATA_CASE_COUNTS:
        raise ReleaseDifferentialError("executed promoted A1-A9 counts changed")
    expected_requests = (
        positives["count"]
        + equality_count
        + negatives["count"]
        + negatives["retry_count"]
        + mutation_count
        + errata_count
    )
    if counts.get("adapter_requests_per_implementation") != expected_requests:
        raise ReleaseDifferentialError("adapter request ledger count mismatch")

    summary: dict[str, Any] = {
        "schema": RUNNER_SCHEMA,
        "status": "PASS" if report.issue_count == 0 else "FAIL",
        "interpretation": (
            "PASS means every warranted, applicable comparison agreed. "
            "Common Lisp N/A rows and unexecuted host-property metadata are not counted as passes."
        ),
        "normative_specifications": provenance["normative_specifications"],
        "corpus": {
            "directory": str(corpus_dir),
            "manifest_sha256": provenance["manifest_sha256"],
            "corpus_sha256": provenance["corpus_sha256"],
            "source_revision": provenance["manifest"]["source_revision"],
            "source_worktree": provenance["manifest"]["source_worktree"],
            "source_input_sha256": provenance["manifest"]["source_input_sha256"],
            "generator_version": provenance["manifest"]["generator_version"],
            "deterministic_seed": provenance["manifest"]["deterministic_seed"],
            "qualifies_for_release": provenance["qualifies_for_release"],
            "mechanically_verified_demonstrated_primary_minimal": provenance[
                "demonstrated_primary_minimal"
            ],
            "counts": provenance["manifest"]["counts"],
            "release_thresholds": provenance["manifest"]["release_thresholds"],
            "artifact_sha256": {
                name: record["sha256"]
                for name, record in sorted(provenance["manifest"]["artifacts"].items())
            },
            "valid_datum_compatibility": valid_datum_compatibility,
        },
        "runner": {
            "path": str(Path(__file__).resolve().relative_to(REPO_ROOT)),
            "sha256": sha256_file(Path(__file__).resolve()),
            "batch_size": batch_size,
            "batch_timeout_seconds": timeout_seconds,
            "batch_count": len(coordinator.batch_ledger),
            "ambient_python": {
                "PYTHONHASHSEED": "137",
                "PYTHONINTMAXSTRDIGITS": "640",
            },
            "adapter_sha256": {
                "common_lisp": sha256_file(INTEGRATION_DIR / "common_lisp_adapter.lisp"),
                "python": sha256_file(INTEGRATION_DIR / "python_adapter.py"),
            },
        },
        "counts": counts,
        "failure_status_counts": {
            "normative": counts.get("negative_normative_rows", 0),
        },
        "promoted_errata_execution": {
            "classified_total": counts.get("promoted_errata_vectors", 0),
            "by_adjudication": observed_errata_counts,
            "failures": 0 if report.issue_count == 0 else None,
        },
        "host_negative_dispositions": report.host_row_dispositions,
        "host_property_dispositions": scenario_dispositions["host_properties"],
        "resource_boundary_dispositions": scenario_dispositions[
            "resource_boundaries"
        ],
        "unclassified_mutation_outcomes": dict(sorted(report.mutation_outcomes.items())),
        "mutation_disagreements": difference_summary,
        "batch_artifact_ledger": coordinator.batch_ledger,
        "issues": report.issue_summary(),
        "residual_boundaries": [
            "A1-A9 are closed by the pinned ruling and Errata 0.1; all 37 promoted cases are compared on their complete adjudicated expectations.",
            "Unclassified mutations receive no expected triple; any disagreement requires minimization.",
            "Seven host-property scenarios remain owned by Phase-4 qualification or instrumentation.",
            "All fourteen generated resource-boundary descriptors remain metadata here; the promoted operation vectors and Phase-4 qualification execute adjudicated boundaries.",
            "Three Common Lisp optional/language-specific importer rows remain N/A, not pass.",
        ],
    }
    if artifacts_dir:
        (artifacts_dir / "summary.json").write_text(
            json.dumps(summary, indent=2, sort_keys=True) + "\n", encoding="ascii"
        )
    return summary


def main(argv: Sequence[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--corpus-dir", type=Path, required=True)
    parser.add_argument(
        "--allow-small-corpus",
        action="store_true",
        help="accept generator test mode; never use for release evidence",
    )
    parser.add_argument("--batch-size", type=int, default=2048)
    parser.add_argument("--timeout-seconds", type=float, default=120.0)
    parser.add_argument("--artifacts-dir", type=Path)
    parser.add_argument("--json", action="store_true")
    args = parser.parse_args(argv)
    summary = run(
        args.corpus_dir,
        allow_small=args.allow_small_corpus,
        batch_size=args.batch_size,
        timeout_seconds=args.timeout_seconds,
        artifacts_dir=args.artifacts_dir,
    )
    if args.json:
        print(json.dumps(summary, indent=2, sort_keys=True))
    else:
        counts = summary["counts"]
        print(f"CD/0 generated differential: {summary['status']}")
        print(
            "normative sha256: "
            + ", ".join(
                f"{role}={record['sha256']}"
                for role, record in summary["normative_specifications"].items()
            )
        )
        print(f"manifest sha256: {summary['corpus']['manifest_sha256']}")
        print(f"corpus sha256: {summary['corpus']['corpus_sha256']}")
        print(f"release-qualified corpus: {summary['corpus']['qualifies_for_release']}")
        print(
            "rows: "
            f"positive={counts.get('positive_rows', 0)} "
            f"classified-negative={counts.get('classified_negative_rows', 0)} "
            f"mutation={counts.get('unclassified_mutation_candidates', 0)}"
        )
        status_counts = summary["failure_status_counts"]
        print(
            "negative status: "
            f"normative={status_counts['normative']}"
        )
        errata = summary["promoted_errata_execution"]
        print(
            f"promoted errata: classified={errata['classified_total']} "
            + " ".join(
                f"{name}={count}" for name, count in errata["by_adjudication"].items()
            )
        )
        print(
            "equality: "
            f"self={counts.get('equality_self_pairs', 0)} "
            f"neighbor={counts.get('equality_neighbor_pairs', 0)}"
        )
        print(
            "resource retries: "
            f"{counts.get('retry_budget_checks', 0)} exact retry/re-encodes"
        )
        print(
            "Common Lisp optional importer N/A (not pass): "
            f"{counts.get('common_lisp_host_not_applicable', 0)}"
        )
        outcomes = summary["unclassified_mutation_outcomes"]
        print(
            "unclassified mutations: "
            f"both-success-identical={outcomes.get('both_success_identical', 0)} "
            f"same-failure={outcomes.get('both_failure_same_triple', 0)} "
            f"minimize-required={outcomes.get('minimization_required_disagreements', 0)}"
        )
        print(
            f"batches: {summary['runner']['batch_count']}; "
            f"requests per codec: {counts.get('adapter_requests_per_implementation', 0)}"
        )
        issues = summary["issues"]
        if issues["count"]:
            print(f"issues: {issues['count']}")
            for issue in issues["samples"][:50]:
                print(f"- {issue}")
            if issues["count"] > 50:
                print(f"- ... {issues['count'] - 50} more (see JSON summary digest/samples)")
        else:
            print("warranted cross-codec disagreements: 0")
    return 0 if summary["status"] == "PASS" else 1


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except ReleaseDifferentialError as exc:
        print(f"CD/0 generated differential fatal: {exc}", file=sys.stderr)
        raise SystemExit(2)
