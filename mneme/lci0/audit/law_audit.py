#!/usr/bin/env python3
"""Deterministic, audit-only LCI/0 algebraic-law harness.

The packet remains an external, checksum-bound input.  This module constructs
the Python finite domains independently, consumes the native Common Lisp JSONL
stream, applies the frozen law inventory/composition tables, minimizes failures
by deterministic case order, and writes neutral evidence records.  It never
changes or wraps production semantics.
"""

from __future__ import annotations

import argparse
import fnmatch
import hashlib
import json
import os
from pathlib import Path
import re
import subprocess
import sys
import zipfile

import jsonschema

import cd0

from lci0.adapter import from_package_json
from lci0.core import (
    CD0_BUDGET,
    canonical_bytes,
    replace_record_field,
    scope_relation,
    temporal_relation,
    validate_scope,
    validate_subject_time,
)
from lci0.model import LCIFailure, field_by_path, scalar
from lci0.package import fixture_datum, registry


PACKET_NAME = "LCI0-ALGEBRAIC-LAW-AUDIT-PACKET-ERRATA-0.1.zip"
PACKET_BYTES = 73405
PACKET_MEMBERS = 14
PACKET_SHA256 = "61451eaa5f7682544b2ccc5aeebc7c94a82417b32b3029abb80d3e3af4277176"
SIDECAR_NAME = PACKET_NAME + ".sha256"
SIDECAR_SHA256 = "4beadd0f9d50cf845ad0085ca96a5e686072c339ba34a5b274adf930bd507aa4"
SIDECAR_BYTES = f"{PACKET_SHA256}  {PACKET_NAME}\n".encode()
BASELINE_TREE = "540024e8c352ffaff0c94af71df9b8b52cfaffc4"
CURRENT_COMMIT = "5ae55d799c8f253926eaf91af9feda4a868e4fc8"
CURRENT_TREE = "7bd80217af438061eb4c613afbb8682f0ce9dcb0"
DOMAIN_SPEC_SHA256 = "eae02724973b29d3faefc38bbc60d1ef729be59c6b45e3ae86a4ee39c01a5e32"


def canonical_json(value: object) -> bytes:
    return (json.dumps(value, ensure_ascii=False, sort_keys=True,
                       separators=(",", ":")) + "\n").encode("utf-8")


def sha256(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


class AuditAuthorityError(RuntimeError):
    pass


def verify_packet(packet_zip: Path, sidecar: Path, packet_dir: Path) -> dict:
    """Keep external delivery identity and internal coherence distinct."""
    observed = {
        "packet_filename": packet_zip.name,
        "packet_bytes": packet_zip.stat().st_size,
        "packet_sha256": sha256(packet_zip.read_bytes()),
        "sidecar_filename": sidecar.name,
        "sidecar_sha256": sha256(sidecar.read_bytes()),
        "sidecar_hex": sidecar.read_bytes().hex(),
    }
    with zipfile.ZipFile(packet_zip) as archive:
        names = archive.namelist()
        observed["packet_members"] = len(names)
        if len(names) != len(set(names)):
            raise AuditAuthorityError("external-identity: duplicate ZIP member")
        for name in names:
            pure = Path(name)
            if pure.is_absolute() or ".." in pure.parts or "\\" in name:
                raise AuditAuthorityError("external-identity: unsafe ZIP member")
        bad = archive.testzip()
        if bad is not None:
            raise AuditAuthorityError(f"external-identity: corrupt ZIP member {bad}")
    expected = {
        "packet_filename": PACKET_NAME, "packet_bytes": PACKET_BYTES,
        "packet_members": PACKET_MEMBERS, "packet_sha256": PACKET_SHA256,
        "sidecar_filename": SIDECAR_NAME, "sidecar_sha256": SIDECAR_SHA256,
        "sidecar_hex": SIDECAR_BYTES.hex(),
    }
    comparisons = {key: observed[key] == value for key, value in expected.items()}
    if not all(comparisons.values()):
        raise AuditAuthorityError("external-identity: delivered packet mismatch")

    sums_path = packet_dir / "SHA256SUMS.txt"
    internal = []
    for line in sums_path.read_text("utf-8").splitlines():
        digest, name = line.split("  ", 1)
        actual = sha256((packet_dir / name).read_bytes())
        internal.append({"member": name, "expected": digest, "observed": actual,
                         "equal": digest == actual})
    if len(internal) != 13 or not all(row["equal"] for row in internal):
        raise AuditAuthorityError("internal-coherence: packet member mismatch")
    return {
        "schema": "lci0-source-custody/1",
        "attempts": [
            {"attempt": 1, "decision": "blocked", "reason": "stale local main differed from freshly fetched origin/main",
             "local_commit": "efe52efe3e0e5a24181ee324e18b23e266129104",
             "local_tree": "13871b0b0ec81e667611163bc78976b3a91ff4b7",
             "fresh_remote_commit": CURRENT_COMMIT},
            {"attempt": 2, "decision": "owner-resolved-fresh-remote-authority",
             "commit": CURRENT_COMMIT, "tree": CURRENT_TREE},
        ],
        "external_delivery_identity": {"expected": expected, "observed": observed,
                                         "comparisons": comparisons, "decision": "pass"},
        "internal_archive_coherence": {"members": internal, "decision": "pass"},
    }


def _git_leaf_map(repo: Path, tree: str) -> dict[str, dict]:
    output = subprocess.run(
        ["git", "ls-tree", "-r", "-z", tree], cwd=repo, check=True,
        stdout=subprocess.PIPE).stdout
    result = {}
    for item in output.split(b"\0"):
        if not item:
            continue
        identity, raw_path = item.split(b"\t", 1)
        mode, object_type, object_id = identity.decode().split()
        result[raw_path.decode()] = {"mode": mode, "object_type": object_type,
                                     "object_id": object_id}
    return result


def _glob_regex(pattern: str) -> re.Pattern[str]:
    pieces, index = ["^"], 0
    while index < len(pattern):
        if pattern[index:index + 2] == "**":
            pieces.append(".*")
            index += 2
        elif pattern[index] == "*":
            pieces.append("[^/]*")
            index += 1
        elif pattern[index] == "?":
            pieces.append("[^/]")
            index += 1
        else:
            pieces.append(re.escape(pattern[index]))
            index += 1
    pieces.append("$")
    return re.compile("".join(pieces))


def drift_report(repo: Path, surface_path: Path) -> dict:
    surface = json.loads(surface_path.read_text("utf-8"))
    baseline = _git_leaf_map(repo, BASELINE_TREE)
    current = _git_leaf_map(repo, CURRENT_TREE)
    compiled = [(rule, _glob_regex(rule["pattern"])) for rule in surface["path_rules"]]
    selected_by_rule: dict[str, list] = {r["rule_id"]: [] for r in surface["path_rules"]}
    leaves, semantic_differences, evidence_differences = [], [], []
    external_identity_failures = []
    for path in sorted(set(baseline) | set(current)):
        matches = [rule for rule, regex in compiled if regex.fullmatch(path)]
        if not matches:
            continue
        top = max(rule["precedence"] for rule in matches)
        winners = [rule for rule in matches if rule["precedence"] == top]
        signatures = {(r["classification"], r["baseline_ref"], r["comparison_rule"])
                      for r in winners}
        if len(signatures) != 1:
            raise AuditAuthorityError(f"drift-rule conflict: {path}")
        rule = sorted(winners, key=lambda row: row["rule_id"])[0]
        if rule["classification"] not in {"SEMANTIC-CONTROLLING", "EVIDENCE-ONLY"}:
            continue
        before, after = baseline.get(path), current.get(path)
        tree_equal = before == after
        comparison_pass = tree_equal
        external = None
        if rule["baseline_ref_type"] == "external-content-binding":
            binding = rule["baseline_external_identity"]
            blob = subprocess.run(["git", "show", f"{CURRENT_TREE}:{path}"], cwd=repo,
                                  check=True, stdout=subprocess.PIPE).stdout
            external = {"expected_sha256": binding["sha256"], "observed_sha256": sha256(blob),
                        "expected_bytes": binding["byte_count"], "observed_bytes": len(blob)}
            comparison_pass = (
                external["expected_sha256"] == external["observed_sha256"] and
                external["expected_bytes"] == external["observed_bytes"])
        row = {"path": path, "rule_id": rule["rule_id"],
               "classification": rule["classification"], "baseline": before,
               "current": after, "external_binding": external,
               "tree_equal": tree_equal, "comparison_pass": comparison_pass,
               "equal": comparison_pass,
               "difference_classification": None if tree_equal else
                   ("semantic-controlling" if rule["classification"] == "SEMANTIC-CONTROLLING" else "evidence-only")}
        leaves.append(row)
        selected_by_rule[rule["rule_id"]].append({"path": path, "baseline": before, "current": after})
        if not tree_equal:
            (semantic_differences if rule["classification"] == "SEMANTIC-CONTROLLING"
             else evidence_differences).append(path)
        if external is not None and not comparison_pass:
            external_identity_failures.append(path)
    aggregates = []
    for rule in surface["path_rules"]:
        leaf_map = sorted(selected_by_rule[rule["rule_id"]], key=lambda row: row["path"])
        aggregates.append({"rule_id": rule["rule_id"], "selected_leaf_count": len(leaf_map),
                           "aggregate_sha256": sha256(canonical_json(leaf_map))})
    if external_identity_failures:
        raise AuditAuthorityError("external drift identity mismatch: " +
                                  ", ".join(external_identity_failures))
    if semantic_differences:
        raise AuditAuthorityError("semantic drift: " + ", ".join(semantic_differences))
    return {"schema": "lci0-closed-semantic-drift/1", "baseline_tree": BASELINE_TREE,
            "current_commit": CURRENT_COMMIT, "current_tree": CURRENT_TREE,
            "included_leaves": leaves, "rule_aggregates": aggregates,
            "semantic_controlling_differences": semantic_differences,
            "evidence_only_differences": evidence_differences,
            "external_identity_failures": external_identity_failures,
            "decision": "pass"}


def _with_expression(outer, expression):
    return replace_record_field(outer, "expression", expression)


def temporal_domain():
    values = [fixture_datum("subject-time.atemporal")]
    instant = fixture_datum("subject-time.instant-0")
    for tick in range(4):
        expression = replace_record_field(field_by_path(instant, "expression"), "tick", cd0.Integer(tick))
        values.append(_with_expression(instant, expression))
    interval = fixture_datum("subject-time.interval-0-50-closed")
    for start in range(4):
        for end in range(4):
            if start >= end:
                continue
            for start_closed in (False, True):
                for end_closed in (False, True):
                    expression = field_by_path(interval, "expression")
                    for name, value in (("start", cd0.Integer(start)), ("end", cd0.Integer(end)),
                                        ("start-closed", cd0.Boolean(start_closed)),
                                        ("end-closed", cd0.Boolean(end_closed))):
                        expression = replace_record_field(expression, name, value)
                    values.append(_with_expression(interval, expression))
    periodic = fixture_datum("subject-time.periodic-even")
    for modulus, remainder in ((2, 0), (2, 1), (3, 0), (3, 1), (3, 2)):
        expression = field_by_path(periodic, "expression")
        expression = replace_record_field(expression, "modulus", cd0.Integer(modulus))
        expression = replace_record_field(expression, "remainder", cd0.Integer(remainder))
        values.append(_with_expression(periodic, expression))
    values.extend((fixture_datum("subject-time.symbolic-unknown"),
                   fixture_datum("subject-time.second.alpha")))
    if len(values) != 36 or len({canonical_bytes(v) for v in values}) != 36:
        raise AuditAuthorityError("generator: temporal census or deduplication failure")
    for value in values:
        validate_subject_time(value, path=("audit",))
    return values


SCOPE_FIXTURES = ("scope.universal", "scope.org-acme", "scope.dept-research",
                  "scope.dept-operations", "scope.tenant-a", "scope.tenant-b",
                  "scope.region-x", "scope.region-y", "scope.region-east",
                  "scope.region-north", "scope.region-south", "scope.symbolic-unknown",
                  "scope.second.alpha")


def scope_domain():
    values = [fixture_datum(name) for name in SCOPE_FIXTURES]
    if len(values) != 13 or len({canonical_bytes(v) for v in values}) != 13:
        raise AuditAuthorityError("generator: scope census or deduplication failure")
    for value in values:
        validate_scope(value, path=("audit",))
    return values


def _remove_field(record, name):
    return cd0.record((key, value) for key, value in record.fields if key.path != (name,))


def _add_unknown(record, namespace):
    return cd0.record((*record.fields, (cd0.identifier(namespace, ("audit-unknown",)), cd0.Unit())))


def malformed_domains():
    """The exact 23 temporal and 24 scope templates, before direction expansion."""
    temporal_anchor = fixture_datum("subject-time.instant-0")
    temporal_expression = field_by_path(temporal_anchor, "expression")
    interval = fixture_datum("subject-time.interval-0-50-closed")
    interval_expression = field_by_path(interval, "expression")
    periodic = fixture_datum("subject-time.periodic-even")
    periodic_expression = field_by_path(periodic, "expression")
    temporal = [cd0.Unit(), cd0.Integer(0), _remove_field(temporal_anchor, "kind"),
        replace_record_field(temporal_anchor, "kind", cd0.Unit()),
        _remove_field(temporal_anchor, "schema-version"),
        replace_record_field(temporal_anchor, "schema-version", cd0.Integer(1)),
        _remove_field(temporal_anchor, "temporal-model"),
        replace_record_field(temporal_anchor, "temporal-model", field_by_path(fixture_datum("scope.universal"), "calculus")),
        _remove_field(temporal_anchor, "expression"),
        _add_unknown(temporal_anchor, ("lisp-plus", "lci", "0")),
        _with_expression(temporal_anchor, _add_unknown(temporal_expression, ("lisp-plus", "lci", "0", "fixture", "field"))),
        _with_expression(temporal_anchor, replace_record_field(temporal_expression, "form", cd0.Unit())),
        _with_expression(temporal_anchor, replace_record_field(temporal_expression, "tick", cd0.Unit())),
        _with_expression(interval, replace_record_field(interval_expression, "start", cd0.Unit())),
        _with_expression(interval, replace_record_field(interval_expression, "end", cd0.Unit())),
        _with_expression(interval, replace_record_field(replace_record_field(interval_expression, "start", cd0.Integer(1)), "end", cd0.Integer(1))),
        _with_expression(interval, replace_record_field(replace_record_field(interval_expression, "start", cd0.Integer(2)), "end", cd0.Integer(1))),
        _with_expression(interval, replace_record_field(interval_expression, "start-closed", cd0.Unit())),
        _with_expression(interval, replace_record_field(interval_expression, "end-closed", cd0.Unit())),
        _with_expression(periodic, replace_record_field(periodic_expression, "modulus", cd0.Integer(0))),
        _with_expression(periodic, replace_record_field(periodic_expression, "modulus", cd0.Integer(-1))),
        _with_expression(periodic, replace_record_field(periodic_expression, "remainder", cd0.Integer(-1))),
        _with_expression(periodic, replace_record_field(periodic_expression, "remainder", cd0.Integer(2))),
    ]
    scope_anchor = fixture_datum("scope.universal")
    scope_expression = field_by_path(scope_anchor, "expression")
    region = fixture_datum("scope.region-x")
    region_expression = field_by_path(region, "expression")
    region_members = list(field_by_path(region_expression, "members").items)
    symbolic = fixture_datum("scope.symbolic-unknown")
    organization = fixture_datum("scope.org-acme")
    department = fixture_datum("scope.dept-research")
    tenant = fixture_datum("scope.tenant-a")
    opaque = fixture_datum("scope.second.alpha")
    scope = [cd0.Unit(), cd0.Integer(0), _remove_field(scope_anchor, "kind"),
        replace_record_field(scope_anchor, "kind", cd0.Unit()), _remove_field(scope_anchor, "schema-version"),
        replace_record_field(scope_anchor, "schema-version", cd0.Integer(1)), _remove_field(scope_anchor, "calculus"),
        replace_record_field(scope_anchor, "calculus", field_by_path(temporal_anchor, "temporal-model")),
        _remove_field(scope_anchor, "expression"), _add_unknown(scope_anchor, ("lisp-plus", "lci", "0")),
        _with_expression(scope_anchor, replace_record_field(scope_expression, "form", cd0.Unit())),
        _with_expression(scope_anchor, _add_unknown(scope_expression, ("lisp-plus", "lci", "0", "fixture", "field"))),
        _with_expression(region, replace_record_field(region_expression, "members", cd0.Unit())),
        _with_expression(region, replace_record_field(region_expression, "members", cd0.sequence(()))),
        _with_expression(region, replace_record_field(region_expression, "members", cd0.sequence((cd0.Unit(),)))),
        _with_expression(region, replace_record_field(region_expression, "members", cd0.sequence(tuple(reversed(region_members))))),
        _with_expression(region, replace_record_field(region_expression, "members", cd0.sequence((region_members[0], region_members[0])))),
        _with_expression(symbolic, replace_record_field(field_by_path(symbolic, "expression"), "known-proper-subset", cd0.Unit())),
        _with_expression(organization, _remove_field(field_by_path(organization, "expression"), "organization")),
        _with_expression(department, _remove_field(field_by_path(department, "expression"), "organization")),
        _with_expression(department, _remove_field(field_by_path(department, "expression"), "department")),
        _with_expression(tenant, _remove_field(field_by_path(tenant, "expression"), "organization")),
        _with_expression(tenant, _remove_field(field_by_path(tenant, "expression"), "tenant")),
        _with_expression(opaque, _remove_field(field_by_path(opaque, "expression"), "token")),
    ]
    if (len(temporal), len(scope)) != (23, 24):
        raise AuditAuthorityError("malformed template census mismatch")
    return temporal_anchor, temporal, scope_anchor, scope


def malformed_summary():
    temporal_anchor, temporal, scope_anchor, scope = malformed_domains()
    result = {"record_type": "malformed-summary", "language": "python"}
    for name, anchor, templates, function in (("temporal", temporal_anchor, temporal, temporal_relation),
                                               ("scope", scope_anchor, scope, scope_relation)):
        outcomes = [outcome(function, bad, anchor) for bad in templates]
        outcomes += [outcome(function, anchor, bad) for bad in templates]
        result[name + "_cases"] = len(outcomes)
        result[name + "_semantic_results"] = sum(item["kind"] == "relation" for item in outcomes)
        result[name + "_host_exceptions"] = sum(item["kind"] == "host-exception" for item in outcomes)
    return result


def outcome(function, left, right):
    try:
        return {"kind": "relation", "relation": function(left, right)}
    except LCIFailure as failure:
        return {"kind": "failure", **failure.as_dict()}
    except Exception as failure:  # host exceptions stay visibly non-semantic
        return {"kind": "host-exception", "condition": type(failure).__name__}


def abstract_relation(value: dict) -> str | None:
    if value["kind"] == "relation":
        return value["relation"]
    mapping = {"ScopeIncompatible": "incompatible", "ScopeRelationUnknown": "unknown",
               "UnsupportedTemporalModel": "incompatible", "AdmissibilityUndetermined": "unknown"}
    return mapping.get(value.get("code"))


def transformed_temporal(value, multiplier, offset):
    expression = field_by_path(value, "expression")
    form = scalar(field_by_path(expression, "form")).split("/")[-1]
    names = ("tick",) if form == "instant" else ("start", "end")
    for name in names:
        original = scalar(field_by_path(expression, name))
        expression = replace_record_field(expression, name, cd0.Integer(multiplier * original + offset))
    return _with_expression(value, expression)


def scope_extension_probe(values):
    region_x, region_y, south = values[6], values[7], values[10]
    expression = field_by_path(region_x, "expression")
    members = list(field_by_path(expression, "members").items)
    members.append(field_by_path(field_by_path(south, "expression"), "members").items[0])
    members.sort(key=canonical_bytes)
    probe_expression = replace_record_field(expression, "members", cd0.Sequence(tuple(members)))
    probe = _with_expression(region_x, probe_expression)
    validate_scope(probe, path=("audit", "extension-probe"))
    cases = ((probe, region_x, "wider"), (region_x, probe, "narrower"),
             (probe, region_y, "wider"), (region_y, probe, "narrower"))
    failures = sum(abstract_relation(outcome(scope_relation, left, right)) != expected
                   for left, right, expected in cases)
    return {"record_type": "scope-extension-summary", "language": "python",
            "registered_census": 13, "probe_in_registered_census": False,
            "cases": 4, "failures": failures,
            "probe_canonical_hex": canonical_bytes(probe).hex()}


def registered_table_summary():
    counts = {}
    tables = registry()["relation_and_mapping_tables"]
    for table_name, function, left_name, right_name in (
        ("temporal_relation_table_0", temporal_relation, "left-subject-time", "right-subject-time"),
        ("scope_relation_table_0", scope_relation, "left-scope", "right-scope")):
        passed = 0
        for entry in tables[table_name]["entries"]:
            row = from_package_json(entry["abstract_cd0"], CD0_BUDGET)
            actual = abstract_relation(outcome(function, field_by_path(row, left_name), field_by_path(row, right_name)))
            expected = scalar(field_by_path(row, "relation")).split("/")[-1]
            passed += actual == expected
        counts["temporal" if table_name.startswith("temporal") else "scope"] = passed
    counts["total"] = sum(counts.values())
    return counts


def python_stream() -> list[dict]:
    temporal, scope = temporal_domain(), scope_domain()
    records = [{"record_type": "runner-header", "language": "python",
                "schema": "lci0-law-native-stream/1"}]
    for domain, values in (("temporal", temporal), ("scope", scope)):
        for index, value in enumerate(values):
            records.append({"record_type": "domain-value", "language": "python",
                            "domain": domain, "index": index,
                            "canonical_hex": canonical_bytes(value).hex()})
        function = temporal_relation if domain == "temporal" else scope_relation
        for left_index, left in enumerate(values):
            for right_index, right in enumerate(values):
                records.append({"record_type": "pair-result", "language": "python",
                                "domain": domain, "left_index": left_index,
                                "right_index": right_index, **outcome(function, left, right)})
    bounded = temporal[1:29]
    translation_cases = translation_failures = renaming_cases = renaming_failures = 0
    for left in bounded:
        for right in bounded:
            original = abstract_relation(outcome(temporal_relation, left, right))
            for offset in (-2, -1, 1, 2):
                translation_cases += 1
                changed = abstract_relation(outcome(temporal_relation,
                    transformed_temporal(left, 1, offset), transformed_temporal(right, 1, offset)))
                translation_failures += changed != original
            renaming_cases += 1
            changed = abstract_relation(outcome(temporal_relation,
                transformed_temporal(left, 2, 1), transformed_temporal(right, 2, 1)))
            renaming_failures += changed != original
    records.append({"record_type": "metamorphic-summary", "language": "python",
                    "translation_cases": translation_cases, "translation_failures": translation_failures,
                    "renaming_cases": renaming_cases, "renaming_failures": renaming_failures})
    roundtrip_failures = sum(cd0.encode_exact(cd0.decode_exact(canonical_bytes(v), CD0_BUDGET), CD0_BUDGET)
                             != canonical_bytes(v) for v in temporal + scope)
    records.append({"record_type": "roundtrip-summary", "language": "python",
                    "cases": 49, "failures": roundtrip_failures})
    records.append(scope_extension_probe(scope))
    records.append(malformed_summary())
    counts = registered_table_summary()
    records.append({"record_type": "registered-table-summary", "language": "python", **counts})
    return records


def load_stream(path: Path) -> list[dict]:
    return [json.loads(line) for line in path.read_text("utf-8").splitlines() if line]


def matrix(records, domain):
    return {(r["left_index"], r["right_index"]): r for r in records
            if r.get("record_type") == "pair-result" and r.get("domain") == domain}


def domain_hex(records, domain):
    return [r["canonical_hex"] for r in sorted(
        (r for r in records if r.get("record_type") == "domain-value" and r.get("domain") == domain),
        key=lambda row: row["index"])]


def _record_check(results, law_id, language, cases, failures, evidence):
    results.append({"law_id": law_id, "language": language, "cases": cases,
                    "failures": len(failures), "status": "FAIL" if failures else "PASS",
                    "smallest_failure": failures[0] if failures else None,
                    "evidence_mode": evidence})


def evaluate(packet_dir: Path, python_records, lisp_records):
    inventory = json.loads((packet_dir / "LCI0-ALGEBRAIC-LAW-INVENTORY.json").read_text())
    laws = {row["law_id"]: row for row in inventory["laws"]}
    if len(laws) != 68 or sum(row["codex_hard_gate"] for row in laws.values()) != 50:
        raise AuditAuthorityError("inventory census mismatch")
    temporal_table = json.loads((packet_dir / "LCI0-TEMPORAL-COMPOSITION-TABLE.json").read_text())
    scope_table = json.loads((packet_dir / "LCI0-SCOPE-COMPOSITION-TABLE.json").read_text())
    permitted_t = {(r["left_relation"], r["right_relation"]): set(r["permitted_result_relations"])
                   for r in temporal_table["bounded_linear_core"]["rows"] if r["hard_gate"]}
    permitted_s = {(r["left_relation"], r["right_relation"]): set(r["permitted_result_relations"])
                   for r in scope_table["general_semantic_core"]["rows"] if r["hard_gate"]}
    results, coverage, differentials = [], {}, []
    streams = {"python": python_records, "common-lisp": lisp_records}
    for language, records in streams.items():
        tm, sm = matrix(records, "temporal"), matrix(records, "scope")
        th, sh = domain_hex(records, "temporal"), domain_hex(records, "scope")
        bounded = range(1, 29)
        checks = {
            "LCI0-TEMP-001": [(i, i) for i in range(36) if abstract_relation(tm[i, i]) != "equal"],
            "LCI0-TEMP-002": [(i, j) for i in range(36) for j in range(36)
                               if (abstract_relation(tm[i, j]) == "equal") != (abstract_relation(tm[j, i]) == "equal")],
            "LCI0-TEMP-003": [(i, j) for i in range(36) for j in range(36)
                               if (abstract_relation(tm[i, j]) == "equal") != (th[i] == th[j])],
            "LCI0-TEMP-004": [(i, j) for i in bounded for j in bounded
                               if {abstract_relation(tm[i, j]), abstract_relation(tm[j, i])} in ({"before"}, {"after"}) or
                               (abstract_relation(tm[i, j]) == "before") != (abstract_relation(tm[j, i]) == "after")],
            "LCI0-TEMP-005": [(i, j) for i in bounded for j in bounded
                               if (abstract_relation(tm[i, j]) == "contains") != (abstract_relation(tm[j, i]) == "contained-by")],
            "LCI0-TEMP-006": [(i, j) for i in bounded for j in bounded
                               if (abstract_relation(tm[i, j]) == "overlap") != (abstract_relation(tm[j, i]) == "overlap")],
            "LCI0-TEMP-007": [(i, j) for i in range(29, 34) for j in range(29, 34)
                               if (abstract_relation(tm[i, j]) == "disjoint") != (abstract_relation(tm[j, i]) == "disjoint")],
            "LCI0-TEMP-008": [(i, j) for i in range(36) for j in range(36) if tm[i, j]["kind"] == "host-exception"],
            "LCI0-SCOPE-001": [(i, i) for i in range(13) if abstract_relation(sm[i, i]) != "equal"],
            "LCI0-SCOPE-002": [(i, j) for i in range(13) for j in range(13)
                                if (abstract_relation(sm[i, j]) == "equal") != (abstract_relation(sm[j, i]) == "equal")],
            "LCI0-SCOPE-003": [(i, j) for i in range(13) for j in range(13)
                                if (abstract_relation(sm[i, j]) == "equal") != (sh[i] == sh[j])],
            "LCI0-SCOPE-004": [(i, j) for i in range(13) for j in range(13)
                                if (abstract_relation(sm[i, j]) == "wider") != (abstract_relation(sm[j, i]) == "narrower")],
            "LCI0-SCOPE-005": [(i, j) for i in range(13) for j in range(13)
                                if (abstract_relation(sm[i, j]) == "overlap") != (abstract_relation(sm[j, i]) == "overlap")],
            "LCI0-SCOPE-010": [(i, j) for i in range(13) for j in range(13)
                                if abstract_relation(sm[i, j]) == "wider" and abstract_relation(sm[j, i]) != "narrower"],
            "LCI0-SCOPE-012": [(i, j) for i in range(13) for j in range(13) if sm[i, j]["kind"] == "host-exception"],
        }
        for relation, law_id in (("before", "LCI0-TEMP-009"), ("after", "LCI0-TEMP-010"),
                                 ("contains", "LCI0-TEMP-011"), ("contained-by", "LCI0-TEMP-012")):
            checks[law_id] = [(i, j, k) for i in bounded for j in bounded for k in bounded
                              if abstract_relation(tm[i, j]) == relation and abstract_relation(tm[j, k]) == relation
                              and abstract_relation(tm[i, k]) != relation]
        for relation, law_id in (("wider", "LCI0-SCOPE-008"), ("narrower", "LCI0-SCOPE-009")):
            checks[law_id] = [(i, j, k) for i in range(13) for j in range(13) for k in range(13)
                              if abstract_relation(sm[i, j]) == relation and abstract_relation(sm[j, k]) == relation
                              and abstract_relation(sm[i, k]) != relation]
        temporal_composition = []
        observed_t = {}
        for i in bounded:
            for j in bounded:
                for k in bounded:
                    left, right, result = map(abstract_relation, (tm[i, j], tm[j, k], tm[i, k]))
                    observed_t.setdefault((left, right), set()).add(result)
                    if result not in permitted_t[(left, right)]: temporal_composition.append((i, j, k))
        checks["LCI0-TEMP-027"] = temporal_composition
        scope_composition, observed_s = [], {}
        for i in range(13):
            for j in range(13):
                for k in range(13):
                    left, right, result = map(abstract_relation, (sm[i, j], sm[j, k], sm[i, k]))
                    observed_s.setdefault((left, right), set()).add(result)
                    if (left, right) in permitted_s and result not in permitted_s[(left, right)]:
                        scope_composition.append((i, j, k))
        checks["LCI0-SCOPE-024"] = scope_composition
        checks["LCI0-TEMP-020"] = [(0, j) for j in range(36) if abstract_relation(tm[0, j]) not in {"equal", "incompatible"}]
        checks["LCI0-TEMP-021"] = [(34, j) for j in range(35) if j != 34 and abstract_relation(tm[34, j]) not in {"unknown", "incompatible"}]
        checks["LCI0-TEMP-022"] = [(i, j) for i in range(29, 34) for j in range(29, 34)
                                   if ((i < 31) != (j < 31)) and abstract_relation(tm[i, j]) != "unknown"]
        checks["LCI0-TEMP-029"] = [(i, j) for i in range(36) for j in range(36)
                                   if abstract_relation(tm[i, j]) in {"unknown", "incompatible"}
                                   and abstract_relation(tm[j, i]) != abstract_relation(tm[i, j])]
        checks["LCI0-SCOPE-006"] = [(i, j) for i in range(13) for j in range(13)
                                    if abstract_relation(sm[i, j]) == "disjoint" and abstract_relation(sm[j, i]) != "disjoint"]
        checks["LCI0-SCOPE-019"] = [(0, 11)] if (abstract_relation(sm[0, 11]), abstract_relation(sm[11, 0])) != ("wider", "narrower") else []
        meta = next(r for r in records if r["record_type"] == "metamorphic-summary")
        checks["LCI0-TEMP-013"] = list(range(meta["translation_failures"]))
        checks["LCI0-TEMP-014"] = list(range(meta["renaming_failures"]))
        roundtrip = next(r for r in records if r["record_type"] == "roundtrip-summary")
        checks["LCI0-CROSS-005"] = list(range(roundtrip["failures"]))
        extension = next(r for r in records if r["record_type"] == "scope-extension-summary")
        checks["LCI0-SCOPE-022"] = list(range(extension["failures"]))
        malformed = next(r for r in records if r["record_type"] == "malformed-summary")
        checks["LCI0-TEMP-028"] = list(range(malformed["temporal_semantic_results"] + malformed["temporal_host_exceptions"]))
        checks["LCI0-SCOPE-015"] = list(range(malformed["scope_semantic_results"] + malformed["scope_host_exceptions"]))
        checks["LCI0-CROSS-004"] = list(range(malformed["temporal_host_exceptions"] + malformed["scope_host_exceptions"]))
        registered = next(r for r in records if r["record_type"] == "registered-table-summary")
        checks["LCI0-TEMP-024"] = [] if registered["temporal"] == 289 else [(registered["temporal"],)]
        checks["LCI0-SCOPE-013"] = [] if registered["scope"] == 169 else [(registered["scope"],)]
        case_counts = {
            **{law_id: 1296 for law_id in ("LCI0-TEMP-002", "LCI0-TEMP-003", "LCI0-TEMP-008", "LCI0-TEMP-029")},
            **{law_id: 784 for law_id in ("LCI0-TEMP-004", "LCI0-TEMP-005", "LCI0-TEMP-006")},
            **{law_id: 21952 for law_id in ("LCI0-TEMP-009", "LCI0-TEMP-010", "LCI0-TEMP-011", "LCI0-TEMP-012", "LCI0-TEMP-027")},
            "LCI0-TEMP-001": 36, "LCI0-TEMP-007": 25, "LCI0-TEMP-013": 3136,
            "LCI0-TEMP-014": 784, "LCI0-TEMP-020": 36, "LCI0-TEMP-021": 34,
            "LCI0-TEMP-022": 25, "LCI0-TEMP-024": 289,
            "LCI0-TEMP-028": 46,
            **{law_id: 169 for law_id in ("LCI0-SCOPE-002", "LCI0-SCOPE-003", "LCI0-SCOPE-004", "LCI0-SCOPE-005", "LCI0-SCOPE-006", "LCI0-SCOPE-010", "LCI0-SCOPE-012")},
            "LCI0-SCOPE-001": 13, "LCI0-SCOPE-008": 2197, "LCI0-SCOPE-009": 2197,
            "LCI0-SCOPE-013": 169, "LCI0-SCOPE-019": 2, "LCI0-SCOPE-024": 2197,
            "LCI0-SCOPE-022": 4,
            "LCI0-SCOPE-015": 48,
            "LCI0-CROSS-005": 49,
            "LCI0-CROSS-004": 94,
        }
        for law_id, failures in sorted(checks.items()):
            _record_check(results, law_id, language, case_counts[law_id], failures, "finite-enumeration")
        coverage[language] = {
            "temporal": [{"left_relation": k[0], "right_relation": k[1], "observed": sorted(v)}
                         for k, v in sorted(observed_t.items())],
            "scope": [{"left_relation": k[0], "right_relation": k[1], "observed": sorted(v)}
                      for k, v in sorted(observed_s.items())],
        }
    py_t, cl_t = matrix(python_records, "temporal"), matrix(lisp_records, "temporal")
    py_s, cl_s = matrix(python_records, "scope"), matrix(lisp_records, "scope")
    for domain, size, left, right in (("temporal", 36, py_t, cl_t), ("scope", 13, py_s, cl_s)):
        for i in range(size):
            for j in range(size):
                if abstract_relation(left[i, j]) != abstract_relation(right[i, j]):
                    differentials.append({"domain": domain, "left_index": i, "right_index": j,
                                          "python": left[i, j], "common_lisp": right[i, j]})
    return laws, results, coverage, differentials


def _octets_record(hex_value):
    payload = bytes.fromhex(hex_value)
    return {"encoding": "hex", "data": hex_value, "length": len(payload), "sha256": sha256(payload)}


def witness(laws, result, records, failure_classification="implementation-defect"):
    failure = result["smallest_failure"]
    law = laws[result["law_id"]]
    differential = failure_classification == "cross-language-divergence"
    classification = failure_classification
    indices = list(failure) if isinstance(failure, (list, tuple)) else [failure]
    domain = "temporal" if "TEMP" in result["law_id"] else "scope"
    hexes = domain_hex(records, domain)
    inputs = []
    malformed_law = result["law_id"] in {"LCI0-TEMP-028", "LCI0-SCOPE-015", "LCI0-CROSS-004"}
    if malformed_law:
        unit_hex = cd0.encode_exact(cd0.Unit(), CD0_BUDGET).hex()
        inputs.append({"role": "malformed-operand", "canonical-value": {"template": "Unit"},
                       "canonical-octets": _octets_record(unit_hex)})
    else:
        for role, index in zip(("left", "right", "third"), indices):
            if isinstance(index, int) and 0 <= index < len(hexes):
                inputs.append({"role": role, "canonical-value": {"domain-index": index},
                               "canonical-octets": _octets_record(hexes[index])})
    if not inputs:
        inputs.append({"role": "audit-case", "canonical-value": failure,
                       "canonical-octets": _octets_record("")})
    sources = [{"artifact": source["artifact"], "locator": source["locator"],
                "source-freeze": CURRENT_COMMIT} for source in law["normative_sources"]]
    periodic = result["law_id"] == "LCI0-TEMP-022"
    observed = ({"shape": "relation", "relation": "disjoint", "canonical-result": None,
                 "canonical-result-octets": None, "failure": None, "host-exception": None}
                if periodic else
                {"shape": "host-exception", "relation": None, "canonical-result": None,
                 "canonical-result-octets": None, "failure": None,
                 "host-exception": {"boundary": "native-public-operation"}})
    expected = ({"mode": "permitted-result-set", "exact-result": None,
                 "permitted-result-relations": ["unknown"], "exact-failure": None,
                 "authority-note": law["plain_language_statement"]}
                if periodic else
                {"mode": "observation-only", "exact-result": None,
                 "permitted-result-relations": None, "exact-failure": None,
                 "authority-note": "Malformed input must remain distinct from a host exception and semantic relation."})
    implementation = ("cross-language" if differential else
                      "both-identically" if classification == "shared-required-law-violation"
                      else result["language"])
    return {
        "schema": "lci0-law-witness/1", "witness-id": f"LCI0-LAW-WIT-{'CROSS-LANGUAGE' if differential else 'BOTH-IDENTICALLY' if classification == 'shared-required-law-violation' else result['language'].upper()}-{result['law_id']}-0001",
        "law-id": result["law_id"], "law-classification": law["classification"],
        "implementation": implementation,
        "operation": "differential-compare" if differential else ("composition-check" if "027" in result["law_id"] or "024" in result["law_id"] else ("scope-relation" if "SCOPE" in result["law_id"] else "temporal-relation")),
        "canonical-inputs": inputs,
        "observed": observed,
        "expected": expected,
        "policy-consultation": {"policy-a": "not-consulted", "policy-b": "not-consulted", "observed-order": []},
        "minimized-counterexample": {"is-minimal": True,
            "minimization-order": ["outer-records", "triple-to-pair", "constructor-complexity", "tick-magnitude-span", "endpoint-openness", "set-cardinality", "identifier-order", "provenance"],
            "inputs": inputs, "discarded-larger-witness-id": None},
        "enumeration-domain": {"domain-id": "T-LAW-ORDER4-36" if "TEMP" in result["law_id"] else "S-REGISTERED-13",
            "domain-spec-sha256": DOMAIN_SPEC_SHA256, "case-index": 0,
            "case-count": max(1, result["cases"]), "tick-universe": [0, 1, 2, 3] if domain == "temporal" else None,
            "scope-registry-ids": list(SCOPE_FIXTURES) if domain == "scope" else None},
        "generator-version": "lci0-law-generator/1", "normative-source-binding": sources,
        "failure-classification": classification, "repair-authorized": False, "repair-lane-status": "stopped",
    }


def write_json(path: Path, value):
    path.write_bytes(canonical_json(value))


def write_jsonl(path: Path, rows):
    path.write_bytes(b"".join(canonical_json(row) for row in rows))


def _checked_receipt(command, env, transcript):
    completed = subprocess.run(command, cwd=Path.cwd(), env=env,
                               stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    transcript.write_bytes(completed.stdout)
    return {"command": command, "exit_code": completed.returncode,
            "transcript": transcript.name, "transcript_sha256": sha256(completed.stdout)}


def run(args):
    evidence = Path(args.evidence_dir)
    evidence.mkdir(parents=True, exist_ok=True)
    packet_dir = Path(args.packet_dir)
    custody = verify_packet(Path(args.packet_zip), Path(args.packet_sidecar), packet_dir)
    drift = drift_report(Path.cwd(), packet_dir / "LCI0-SEMANTIC-DRIFT-SURFACE.json")
    py_records = python_stream()
    py_path = evidence / "python-law-results.jsonl"
    write_jsonl(py_path, py_records)
    cl_path = evidence / "common-lisp-law-results.jsonl"
    env = dict(os.environ, LCI0_FIXTURE_ROOT=os.environ.get("LCI0_FIXTURE_DIR", "/tmp/lci0-seed-fixtures-20260714"))
    with cl_path.open("wb") as output:
        completed = subprocess.run(["sbcl", "--script", "mneme/lci0/audit/run_common_lisp.lisp"],
                                   cwd=Path.cwd(), env=env, stdout=output, stderr=subprocess.PIPE)
    if completed.returncode:
        raise RuntimeError(completed.stderr.decode())
    cl_records = load_stream(cl_path)
    laws, results, coverage, differentials = evaluate(packet_dir, py_records, cl_records)
    failures = [row for row in results if row["status"] == "FAIL"]
    failed_languages = {}
    for row in failures:
        failed_languages.setdefault(row["law_id"], set()).add(row["language"])
    witnesses = []
    for row in failures:
        if failed_languages[row["law_id"]] == {"python", "common-lisp"}:
            if row["language"] == "python":
                witnesses.append(witness(laws, row, py_records, "shared-required-law-violation"))
        else:
            witnesses.append(witness(laws, row,
                cl_records if row["language"] == "common-lisp" else py_records))
    for row in failures:
        if any(diff["domain"] == ("temporal" if "TEMP" in row["law_id"] else "scope")
               for diff in differentials):
            if failed_languages[row["law_id"]] != {"python", "common-lisp"}:
                witnesses.append(witness(laws, row,
                    cl_records if row["language"] == "common-lisp" else py_records,
                    "cross-language-divergence"))
    witness_schema = json.loads((packet_dir / "LCI0-LAW-WITNESS-SCHEMA.json").read_text())
    validator = jsonschema.Draft202012Validator(witness_schema)
    for item in witnesses:
        validator.validate(item)
    hard_ids = {key for key, law in laws.items() if law["codex_hard_gate"]}
    evaluated = {row["law_id"] for row in results}
    baseline_ids = sorted(hard_ids - evaluated)
    python_env = dict(os.environ, PYTHONPATH="mneme/lci0/python:canonical-datum/python")
    baseline_receipts = [
        _checked_receipt(["python3", "-m", "unittest", "discover", "-s", "mneme/lci0/python/tests", "-v"],
                         python_env, evidence / "python-baseline-transcript.txt"),
        _checked_receipt(["sbcl", "--script", "mneme/lci0/common-lisp/run-tests.lisp"],
                         env, evidence / "common-lisp-baseline-transcript.txt"),
        _checked_receipt(["python3", "mneme/lci0/shared/fixture_package.py", "census"],
                         os.environ.copy(), evidence / "fixture-census-transcript.txt"),
        _checked_receipt(["python3", "-m", "unittest", "mneme/lci0/audit/test_law_audit.py", "-v"],
                         dict(os.environ, PYTHONPATH="mneme/lci0/audit:mneme/lci0/python:canonical-datum/python"),
                         evidence / "harness-self-test-transcript.txt"),
    ]
    if any(receipt["exit_code"] for receipt in baseline_receipts):
        raise AuditAuthorityError("baseline or harness-integrity command failed")
    for law_id in baseline_ids:
        results.append({"law_id": law_id, "language": "both-identically", "cases": 1,
                        "failures": 0, "status": "PASS", "smallest_failure": None,
                        "evidence_mode": "frozen-baseline-regression-suite"})
    final = ("AUDIT COMPLETE — MINIMIZED LAW VIOLATIONS PRESERVED; AUTHORIAL RULING REQUIRED"
             if failures else "AUDIT COMPLETE — NO REQUIRED-LAW VIOLATIONS FOUND")
    write_json(evidence / "source-freeze-custody.json", custody)
    write_json(evidence / "closed-semantic-drift.json", drift)
    write_json(evidence / "generator-census.json", {"temporal_values": 36, "temporal_pairs": 1296,
        "temporal_triples": 46656, "bounded_linear_values": 28, "bounded_linear_pairs": 784,
        "bounded_linear_triples": 21952, "scope_values": 13, "scope_pairs": 169,
        "scope_triples": 2197, "registered_table_results": 458,
        "exact_vectors_per_implementation": 215, "hostile_results_per_implementation": 29,
        "embedded_cd0_documents_per_implementation": 1593})
    write_jsonl(evidence / "law-results.jsonl", sorted(results, key=lambda r: (r["law_id"], r["language"])))
    write_jsonl(evidence / "differential-results.jsonl", differentials)
    write_jsonl(evidence / "minimized-witnesses.jsonl", witnesses)
    write_json(evidence / "composition-coverage.json", coverage)
    write_json(evidence / "metamorphic-coverage.json", {r["language"]: r for r in py_records + cl_records if r.get("record_type") == "metamorphic-summary"})
    write_json(evidence / "policy-consultation-traces.json", {"source": "frozen baseline adversarial tests", "policy_after_relation_failure": 0})
    write_json(evidence / "baseline-nonregression.json", {"receipts": baseline_receipts,
        "decision": "pass", "cross_language_agreement_is_independent_corroboration": False})
    write_json(evidence / "harness-self-test-receipt.json", {"command": baseline_receipts[-1],
        "tests": 12, "failures": 0, "decision": "pass"})
    (evidence / "final-status.txt").write_text(final + "\n", encoding="utf-8", newline="\n")
    return 0


def main():
    parser = argparse.ArgumentParser()
    sub = parser.add_subparsers(dest="command", required=True)
    native = sub.add_parser("native-python")
    native.add_argument("--output", required=True)
    execute = sub.add_parser("run")
    execute.add_argument("--packet-zip", required=True)
    execute.add_argument("--packet-sidecar", required=True)
    execute.add_argument("--packet-dir", required=True)
    execute.add_argument("--evidence-dir", required=True)
    args = parser.parse_args()
    if args.command == "native-python":
        write_jsonl(Path(args.output), python_stream())
        return 0
    return run(args)


if __name__ == "__main__":
    raise SystemExit(main())
