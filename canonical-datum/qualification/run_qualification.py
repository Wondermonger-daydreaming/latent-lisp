#!/usr/bin/env python3
"""Bounded post-errata qualification for the two CD/0 seed codecs.

This coordinator is not a codec and is not a source of datum semantics.  It
drives the public codec APIs through the existing process adapters, reruns the
reviewed hand corpus, and records exactly which finite properties were checked.
The deterministic pseudo-random values are ephemeral probes, not the Phase-3
release corpus and not normative vectors.
"""

from __future__ import annotations

import argparse
from collections import Counter
import copy
import hashlib
import json
import math
import os
from pathlib import Path
import random
import subprocess
import sys
import tempfile
from typing import Any, Iterable


SCHEMA = "lisp-plus-cd0-qualification/v2"
PROTOCOL = "lisp-plus-cd0-differential/v1"
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
ERRATA_CASE_COUNTS = {
    "A1": 6,
    "A2": 5,
    "A3": 6,
    "A4": 3,
    "A5": 3,
    "A6": 2,
    "A7": 1,
    "A8": 6,
    "A9": 7,
}
QUALIFICATION_BASE_REVISION = "fac17dd701c59f6da8eb2536dd022853b2e258fe"
RANDOM_SEED = 0xCD0004

REPO_ROOT = Path(__file__).resolve().parents[2]
QUALIFICATION_DIR = REPO_ROOT / "canonical-datum" / "qualification"
INTEGRATION_DIR = REPO_ROOT / "canonical-datum" / "integration"
PYTHON_DIR = REPO_ROOT / "canonical-datum" / "python"
COMMON_LISP_DIR = REPO_ROOT / "canonical-datum" / "common-lisp"
SPEC_PATH = REPO_ROOT / EXPECTED_NORMATIVE_SHA256["base-specification"]["path"]
BUDGET_PATH = REPO_ROOT / "canonical-datum" / "vectors" / "cd0-budgets.json"

MODE_CONFIG = {
    "small": {"random_values": 48, "python_hash_seeds": ("1", "777")},
    "default": {
        "random_values": 512,
        "python_hash_seeds": ("0", "1", "137", "777"),
    },
}


class QualificationFailure(RuntimeError):
    """The harness or an exercised obligation failed."""


def sha256_bytes(value: bytes) -> str:
    return hashlib.sha256(value).hexdigest()


def sha256_path(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def git_rev_parse(expression: str) -> str:
    completed = subprocess.run(
        ["git", "rev-parse", expression],
        cwd=REPO_ROOT,
        text=True,
        capture_output=True,
        check=False,
    )
    if completed.returncode != 0:
        raise QualificationFailure(f"cannot resolve git object {expression!r}")
    return completed.stdout.strip()


def canonical_json(value: Any) -> str:
    return json.dumps(value, sort_keys=True, separators=(",", ":"), ensure_ascii=True)


def default_budget() -> dict[str, int]:
    document = json.loads(BUDGET_PATH.read_text(encoding="utf-8"))
    value = document["budgets"]["cd0-conformance-default"]
    if "base" in value or any(type(item) is not int for item in value.values()):
        raise QualificationFailure("default budget is no longer a resolved integer mapping")
    return dict(value)


def budget_with(base: dict[str, int], **changes: int) -> dict[str, int]:
    result = {**base, **changes}
    if set(result) != set(base):
        raise QualificationFailure("qualification budget introduced an unknown field")
    return result


def request(
    request_id: str,
    operation: str,
    budget: dict[str, int],
    **payload: Any,
) -> dict[str, Any]:
    return {
        "protocol": PROTOCOL,
        "request_id": request_id,
        "op": operation,
        "budget": budget,
        "budget_id": f"qualification:{request_id}",
        **payload,
    }


def string_ast(value: str) -> dict[str, Any]:
    return {"t": "string", "utf8_hex": value.encode("utf-8").hex()}


def identifier_ast(namespace: Iterable[str], path: Iterable[str]) -> dict[str, Any]:
    return {
        "t": "id",
        "namespace_utf8_hex": [item.encode("utf-8").hex() for item in namespace],
        "path_utf8_hex": [item.encode("utf-8").hex() for item in path],
    }


SCALAR_TEXT = ("A", "z", "\u0000", "\n", "\u00e9", "e\u0301", "\U0010ffff")


def random_integer(rng: random.Random) -> int:
    bits = rng.randrange(0, 130)
    magnitude = rng.getrandbits(bits)
    return -magnitude if magnitude and rng.randrange(2) else magnitude


def random_rational(rng: random.Random) -> tuple[int, int]:
    while True:
        denominator = rng.randrange(2, 102)
        numerator = random_integer(rng)
        if numerator and math.gcd(abs(numerator), denominator) == 1:
            return numerator, denominator


def random_segment(rng: random.Random) -> str:
    pieces = [rng.choice(SCALAR_TEXT) for _ in range(rng.randrange(1, 4))]
    value = "".join(pieces)
    return value if value else "x"


def random_scalar_ast(rng: random.Random, family: int | None = None) -> dict[str, Any]:
    choice = rng.randrange(7) if family is None else family
    if choice == 0:
        return {"t": "unit"}
    if choice == 1:
        return {"t": "bool", "v": bool(rng.randrange(2))}
    if choice == 2:
        return {"t": "int", "v": str(random_integer(rng))}
    if choice == 3:
        numerator, denominator = random_rational(rng)
        return {"t": "rat", "p": str(numerator), "q": str(denominator)}
    if choice == 4:
        value = "".join(rng.choice(SCALAR_TEXT) for _ in range(rng.randrange(0, 7)))
        return string_ast(value)
    if choice == 5:
        length = rng.randrange(0, 17)
        return {"t": "bytes", "hex": bytes(rng.randrange(256) for _ in range(length)).hex()}
    namespace = tuple(random_segment(rng) for _ in range(rng.randrange(0, 3)))
    path = tuple(random_segment(rng) for _ in range(rng.randrange(1, 4)))
    return identifier_ast(namespace, path)


def random_ast(rng: random.Random, depth: int = 0) -> dict[str, Any]:
    if depth >= 4 or rng.randrange(10) < 7:
        return random_scalar_ast(rng)
    if rng.randrange(2) == 0:
        return {
            "t": "seq",
            "items": [random_ast(rng, depth + 1) for _ in range(rng.randrange(0, 5))],
        }
    field_count = rng.randrange(0, 4)
    fields: list[dict[str, Any]] = []
    nonce = rng.randrange(1 << 30)
    for index in range(field_count):
        key = identifier_ast(("qualification",), (f"d{depth}", f"{nonce:08x}-{index}"))
        fields.append({"key": key, "value": random_ast(rng, depth + 1)})
    fields.reverse()  # Deliberately make host source order non-canonical.
    return {"t": "record", "fields": fields}


def fixed_family_prelude() -> list[dict[str, Any]]:
    key = identifier_ast(("qualification",), ("key",))
    return [
        {"t": "unit"},
        {"t": "bool", "v": True},
        {"t": "int", "v": "-65"},
        {"t": "rat", "p": "-5", "q": "7"},
        string_ast("e\u0301"),
        {"t": "bytes", "hex": "00ff80"},
        identifier_ast(("n",), ("p",)),
        {"t": "seq", "items": [{"t": "unit"}, {"t": "bool", "v": False}]},
        {"t": "record", "fields": [{"key": key, "value": {"t": "int", "v": "7"}}]},
    ]


def generate_values(count: int, seed: int = RANDOM_SEED) -> list[dict[str, Any]]:
    if count < 9:
        raise ValueError("qualification value count must exercise all nine root families")
    rng = random.Random(seed)
    result = fixed_family_prelude()
    while len(result) < count:
        result.append(random_ast(rng))
    return result


def equivalent_ast(value: dict[str, Any]) -> dict[str, Any]:
    result = copy.deepcopy(value)
    work = [result]
    while work:
        node = work.pop()
        if node["t"] == "seq":
            work.extend(node["items"])
        elif node["t"] == "record":
            node["fields"].reverse()
            for field in node["fields"]:
                work.append(field["key"])
                work.append(field["value"])
    return result


def build_property_requests(
    value_count: int,
    base_budget: dict[str, int],
) -> tuple[list[dict[str, Any]], dict[str, dict[str, Any]]]:
    values = generate_values(value_count)
    requests: list[dict[str, Any]] = []
    metadata: dict[str, dict[str, Any]] = {}

    for index, ast in enumerate(values):
        roundtrip_id = f"random-roundtrip:{index:04d}"
        requests.append(request(roundtrip_id, "construct-roundtrip", base_budget, ast=ast))
        metadata[roundtrip_id] = {"kind": "roundtrip", "root_family": ast["t"]}

        equality_id = f"random-equality:{index:04d}"
        requests.append(
            request(
                equality_id,
                "equal",
                base_budget,
                left_ast=ast,
                right_ast=equivalent_ast(ast),
            )
        )
        metadata[equality_id] = {"kind": "equal", "expected": True}

    namespace_id = "namespace-distinction"
    requests.append(
        request(
            namespace_id,
            "equal",
            base_budget,
            left_ast=identifier_ast(("a",), ("b",)),
            right_ast=identifier_ast((), ("a", "b")),
        )
    )
    metadata[namespace_id] = {"kind": "equal", "expected": False}

    hostile_cases = [
        (
            "mutation-invalid-magic",
            "005043440000",
            ("InvalidCanonicalGrammar", "InvalidMagic", "magic"),
            ("category", "code", "stage"),
            "mutation-derived-single-defect",
        ),
        (
            "mutation-future-version",
            "4c5043440100",
            ("UnsupportedFormat", "UnsupportedFutureVersion", "version-selection"),
            ("category", "code", "stage"),
            "mutation-derived-single-defect",
        ),
        (
            "mutation-trailing-byte",
            "4c504344000000",
            ("InvalidCanonicalGrammar", "TrailingBytes", "end-of-input"),
            ("category", "code", "stage"),
            "mutation-derived-single-defect",
        ),
        (
            "mutation-reserved-tag",
            "4c5043440003",
            ("InvalidCanonicalGrammar", "ReservedTypeTag", "type-tag"),
            ("category", "code", "stage"),
            "mutation-derived-single-defect",
        ),
        (
            "mutation-forbidden-tag",
            "4c50434400f0",
            ("PrivilegedRestorationAttempt", "ForbiddenPrivilegedTag", "type-tag"),
            ("category", "code", "stage"),
            "mutation-derived-single-defect",
        ),
        (
            "mutation-overlong-integer-zero",
            "4c50434400108000",
            ("NoncanonicalEncoding", "NonminimalIntegerEncoding", "integer-payload"),
            ("category", "code", "stage"),
            "mutation-derived-single-defect",
        ),
        (
            "mutation-overlong-string-length",
            "4c5043440020810041",
            ("NoncanonicalEncoding", "OverlongLengthEncoding", "length"),
            ("category", "code", "stage"),
            "mutation-derived-single-defect",
        ),
        (
            "mutation-record-order",
            "4c50434400310222000101620222000101611002",
            ("NoncanonicalEncoding", "NoncanonicalFieldOrder", "record-order"),
            ("category", "code", "stage"),
            "mutation-derived-single-defect",
        ),
    ]
    for case_id, input_hex, triple, warranted, classification in hostile_cases:
        requests.append(request(case_id, "decode", base_budget, input_hex=input_hex))
        metadata[case_id] = {
            "kind": "failure",
            "expected": dict(zip(("category", "code", "stage"), triple)),
            "warranted_fields": warranted,
            "classification": classification,
        }

    resource_cases = [
        (
            "resource-input-threshold",
            "4c5043440000",
            budget_with(base_budget, max_input_octets=5),
            ("ResourceRefusal", "ExcessiveInputLength", "input-budget"),
        ),
        (
            "resource-varint-threshold",
            "4c50434400108001",
            budget_with(base_budget, max_varint_octets=1),
            ("ResourceRefusal", "VarintBudgetExceeded", "integer-payload"),
        ),
        (
            "resource-string-threshold",
            "4c5043440020024142",
            budget_with(base_budget, max_single_string_octets=1),
            ("ResourceRefusal", "ExcessiveDeclaredLength", "length"),
        ),
        (
            "resource-depth-threshold",
            "4c50434400300100",
            budget_with(base_budget, max_depth=1),
            ("ResourceRefusal", "ExcessiveNesting", "type-tag"),
        ),
        (
            "resource-node-threshold",
            "4c50434400300100",
            budget_with(base_budget, max_nodes=1),
            ("ResourceRefusal", "NodeBudgetExceeded", "type-tag"),
        ),
    ]
    for case_id, input_hex, tight_budget, triple in resource_cases:
        requests.append(request(case_id, "decode", tight_budget, input_hex=input_hex))
        metadata[case_id] = {
            "kind": "failure",
            "expected": dict(zip(("category", "code", "stage"), triple)),
            "warranted_fields": ("category", "code", "stage"),
            "classification": "resource-boundary",
        }
        retry_id = f"{case_id}:retry"
        requests.append(request(retry_id, "decode", base_budget, input_hex=input_hex))
        metadata[retry_id] = {"kind": "retry", "expected_hex": input_hex}

    deep_depth = 96
    deep_hex = "4c50434400" + "3001" * (deep_depth - 1) + "00"
    deep_failure_id = "resource-deep-semantic-threshold"
    requests.append(
        request(
            deep_failure_id,
            "decode-probe",
            budget_with(
                base_budget,
                max_input_octets=1000,
                max_output_octets=1000,
                max_depth=deep_depth - 1,
                max_nodes=deep_depth,
                max_sequence_items=1,
            ),
            input_hex=deep_hex,
        )
    )
    metadata[deep_failure_id] = {
        "kind": "failure",
        "expected": {
            "category": "ResourceRefusal",
            "code": "ExcessiveNesting",
            "stage": "type-tag",
        },
        "warranted_fields": ("category", "code", "stage"),
        "classification": "resource-boundary",
    }
    deep_retry_id = f"{deep_failure_id}:retry"
    requests.append(
        request(
            deep_retry_id,
            "decode-probe",
            budget_with(
                base_budget,
                max_input_octets=1000,
                max_output_octets=1000,
                max_depth=deep_depth,
                max_nodes=deep_depth,
                max_sequence_items=1,
            ),
            input_hex=deep_hex,
        )
    )
    metadata[deep_retry_id] = {"kind": "retry-probe", "expected_hex": deep_hex}
    return requests, metadata


def serialize_requests(requests: Iterable[dict[str, Any]]) -> str:
    return "".join(canonical_json(item) + "\n" for item in requests)


def parse_response_lines(
    text: str,
    implementation: str,
    expected_ids: set[str],
) -> dict[str, dict[str, Any]]:
    result: dict[str, dict[str, Any]] = {}
    for line_number, line in enumerate(text.splitlines(), 1):
        if not line.strip():
            continue
        try:
            value = json.loads(line)
        except json.JSONDecodeError as exc:
            raise QualificationFailure(
                f"{implementation} response line {line_number} is not JSON"
            ) from exc
        if value.get("protocol") != PROTOCOL or value.get("implementation") != implementation:
            raise QualificationFailure(f"{implementation} emitted mismatched protocol metadata")
        request_id = value.get("request_id")
        if type(request_id) is not str or request_id in result:
            raise QualificationFailure(f"{implementation} emitted duplicate/invalid request id")
        result[request_id] = value
    if set(result) != expected_ids:
        raise QualificationFailure(
            f"{implementation} response IDs differ: "
            f"missing={sorted(expected_ids - set(result))[:3]} "
            f"extra={sorted(set(result) - expected_ids)[:3]}"
        )
    return result


def run_command(
    label: str,
    command: list[str],
    *,
    environment: dict[str, str] | None = None,
    timeout: int = 240,
) -> dict[str, Any]:
    completed = subprocess.run(
        command,
        cwd=REPO_ROOT,
        env=environment,
        text=True,
        capture_output=True,
        timeout=timeout,
        check=False,
    )
    result = {
        "label": label,
        "command": command,
        "returncode": completed.returncode,
        "stdout": completed.stdout,
        "stderr": completed.stderr,
        "stdout_sha256": sha256_bytes(completed.stdout.encode("utf-8")),
        "stderr_sha256": sha256_bytes(completed.stderr.encode("utf-8")),
    }
    if completed.returncode != 0:
        raise QualificationFailure(
            f"{label} exited {completed.returncode}\n"
            f"stdout tail:\n{completed.stdout[-3000:]}\n"
            f"stderr tail:\n{completed.stderr[-3000:]}"
        )
    return result


def run_property_matrix(
    mode: str,
    base_budget: dict[str, int],
) -> tuple[dict[str, Any], list[dict[str, Any]]]:
    requests, metadata = build_property_requests(
        MODE_CONFIG[mode]["random_values"], base_budget
    )
    request_text = serialize_requests(requests)
    expected_ids = set(metadata)
    with tempfile.TemporaryDirectory(prefix="cd0-qualification-") as temporary:
        request_path = Path(temporary) / "requests.jsonl"
        request_path.write_text(request_text, encoding="utf-8")
        python_environment = dict(os.environ)
        python_environment["PYTHONPATH"] = str(PYTHON_DIR)
        python_environment["PYTHONHASHSEED"] = "137"
        python_environment["PYTHONINTMAXSTRDIGITS"] = "640"
        runs = [
            run_command(
                "qualification-common-lisp-adapter",
                [
                    "sbcl",
                    "--noinform",
                    "--disable-debugger",
                    "--script",
                    str(INTEGRATION_DIR / "common_lisp_adapter.lisp"),
                    str(request_path),
                ],
            ),
            run_command(
                "qualification-python-adapter",
                [
                    sys.executable,
                    str(INTEGRATION_DIR / "python_adapter.py"),
                    str(request_path),
                ],
                environment=python_environment,
            ),
        ]
    responses = {
        "common-lisp": parse_response_lines(runs[0]["stdout"], "common-lisp", expected_ids),
        "python": parse_response_lines(runs[1]["stdout"], "python", expected_ids),
    }

    counters: Counter[str] = Counter()
    family_counts: Counter[str] = Counter()
    classifications: Counter[str] = Counter()
    for request_id, meta in metadata.items():
        cl = responses["common-lisp"][request_id]
        py = responses["python"][request_id]
        kind = meta["kind"]
        if kind == "roundtrip":
            counters["random_roundtrips"] += 1
            family_counts[meta["root_family"]] += 1
            for label, response in (("common-lisp", cl), ("python", py)):
                if response.get("status") != "ok":
                    raise QualificationFailure(f"{request_id}: {label} roundtrip failed: {response}")
                value = response["result"]
                if value.get("canonical_hex") != value.get("reencoded_hex"):
                    raise QualificationFailure(f"{request_id}: {label} canonical-byte retry changed")
                if value.get("constructed_equal_decoded") is not True:
                    raise QualificationFailure(f"{request_id}: {label} roundtrip equality false")
            if cl["result"] != py["result"]:
                raise QualificationFailure(f"{request_id}: randomized codec results disagree")
            continue
        if kind == "equal":
            counters["equality_properties"] += 1
            expected = meta["expected"]
            for label, response in (("common-lisp", cl), ("python", py)):
                if response.get("status") != "ok" or response["result"].get("equal") is not expected:
                    raise QualificationFailure(f"{request_id}: {label} equality result mismatch")
                same_bytes = response["result"]["left_hex"] == response["result"]["right_hex"]
                if same_bytes is not expected:
                    raise QualificationFailure(
                        f"{request_id}: {label} equality/encoding equivalence mismatch"
                    )
            if cl["result"] != py["result"]:
                raise QualificationFailure(f"{request_id}: codec equality results disagree")
            continue
        if kind == "failure":
            counters["classified_failures"] += 1
            classifications[meta["classification"]] += 1
            fields = meta["warranted_fields"]
            expected = meta["expected"]
            for label, response in (("common-lisp", cl), ("python", py)):
                if response.get("status") != "failure":
                    raise QualificationFailure(f"{request_id}: {label} hostile input succeeded")
                failure = response["failure"]
                if any(failure.get(field) != expected[field] for field in fields):
                    raise QualificationFailure(
                        f"{request_id}: {label} warranted failure mismatch "
                        f"actual={failure} expected={expected} fields={fields}"
                    )
            if any(cl["failure"].get(field) != py["failure"].get(field) for field in fields):
                raise QualificationFailure(f"{request_id}: warranted cross-codec failure disagreement")
            counters["normative_failure_rows"] += 1
            continue
        if kind in ("retry", "retry-probe"):
            counters["resource_retries"] += 1
            expected_hex = meta["expected_hex"]
            result_key = "canonical_hex" if kind == "retry" else "reencoded_hex"
            for label, response in (("common-lisp", cl), ("python", py)):
                if response.get("status") != "ok":
                    raise QualificationFailure(f"{request_id}: {label} retry failed")
                if response["result"].get(result_key) != expected_hex:
                    raise QualificationFailure(f"{request_id}: {label} retry bytes changed")
            if cl["result"] != py["result"]:
                raise QualificationFailure(f"{request_id}: retry codec results disagree")
            continue
        raise QualificationFailure(f"{request_id}: unknown qualification metadata kind {kind}")

    if set(family_counts) != {"unit", "bool", "int", "rat", "string", "bytes", "id", "seq", "record"}:
        raise QualificationFailure(f"root-family coverage incomplete: {dict(family_counts)}")
    summary = {
        "status": "PASS",
        "random_seed": RANDOM_SEED,
        "request_count_per_codec": len(requests),
        "request_sha256": sha256_bytes(request_text.encode("utf-8")),
        "counts": dict(sorted(counters.items())),
        "root_family_counts": dict(sorted(family_counts.items())),
        "failure_classifications": dict(sorted(classifications.items())),
        "warranted_cross_codec_disagreements": 0,
    }
    return summary, runs


def parse_one_json_object(run: dict[str, Any], label: str) -> dict[str, Any]:
    lines = [line for line in run["stdout"].splitlines() if line.strip()]
    if len(lines) != 1:
        raise QualificationFailure(f"{label} emitted {len(lines)} nonempty stdout lines")
    try:
        value = json.loads(lines[0])
    except json.JSONDecodeError as exc:
        raise QualificationFailure(f"{label} did not emit JSON") from exc
    if value.get("status") != "PASS":
        raise QualificationFailure(f"{label} probe did not report PASS: {value}")
    return value


def run_runtime_probes(mode: str) -> tuple[dict[str, Any], list[dict[str, Any]]]:
    runs: list[dict[str, Any]] = []
    python_results: list[dict[str, Any]] = []
    for seed in MODE_CONFIG[mode]["python_hash_seeds"]:
        environment = dict(os.environ)
        environment["PYTHONPATH"] = str(PYTHON_DIR)
        environment["PYTHONHASHSEED"] = seed
        environment["PYTHONINTMAXSTRDIGITS"] = "640"
        environment["CD0_QUALIFICATION_MODE"] = mode
        run = run_command(
            f"python-runtime-probe-hash-{seed}",
            [sys.executable, str(QUALIFICATION_DIR / "python_runtime_probe.py")],
            environment=environment,
        )
        runs.append(run)
        python_results.append(parse_one_json_object(run, f"python runtime seed {seed}"))
    first_python = python_results[0]
    if any(result != first_python for result in python_results[1:]):
        raise QualificationFailure("Python runtime probe changed across hash seeds")

    cl_environment = dict(os.environ)
    cl_environment["CD0_QUALIFICATION_MODE"] = mode
    cl_run = run_command(
        "common-lisp-runtime-probe",
        [
            "sbcl",
            "--noinform",
            "--disable-debugger",
            "--script",
            str(QUALIFICATION_DIR / "common_lisp_runtime_probe.lisp"),
        ],
        environment=cl_environment,
    )
    runs.append(cl_run)
    common_lisp = parse_one_json_object(cl_run, "Common Lisp runtime")
    if first_python["identity_hex"] != common_lisp["identity_hex"]:
        raise QualificationFailure("ambient cross-process identity bytes disagree")
    return {
        "status": "PASS",
        "python_hash_seeds": list(MODE_CONFIG[mode]["python_hash_seeds"]),
        "python": first_python,
        "common_lisp": common_lisp,
        "ambient_cross_process_identity": first_python["identity_hex"],
    }, runs


def compact_run(run: dict[str, Any]) -> dict[str, Any]:
    command = [
        "<temporary-requests.jsonl>" if "cd0-qualification-" in item else item
        for item in run["command"]
    ]
    return {
        "label": run["label"],
        "command": command,
        "returncode": run["returncode"],
        "stdout_sha256": run["stdout_sha256"],
        "stderr_sha256": run["stderr_sha256"],
        "stdout_bytes": len(run["stdout"].encode("utf-8")),
        "stderr_bytes": len(run["stderr"].encode("utf-8")),
    }


def write_artifacts(destination: Path, summary: dict[str, Any], runs: list[dict[str, Any]]) -> None:
    destination.mkdir(parents=True, exist_ok=True)
    (destination / "summary.json").write_text(
        json.dumps(summary, indent=2, sort_keys=True) + "\n", encoding="utf-8"
    )
    for index, run in enumerate(runs, 1):
        stem = f"{index:02d}-{run['label']}"
        (destination / f"{stem}.stdout.txt").write_text(run["stdout"], encoding="utf-8")
        (destination / f"{stem}.stderr.txt").write_text(run["stderr"], encoding="utf-8")


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--mode", choices=tuple(MODE_CONFIG), default="default")
    parser.add_argument("--artifacts-dir", type=Path)
    parser.add_argument("--json", action="store_true")
    args = parser.parse_args(argv)

    normative_inputs: dict[str, dict[str, str]] = {}
    for role, expected in EXPECTED_NORMATIVE_SHA256.items():
        observed = sha256_path(REPO_ROOT / expected["path"])
        if observed != expected["sha256"]:
            raise QualificationFailure(
                f"normative input digest mismatch for {role}: "
                f"{observed} != {expected['sha256']}"
            )
        normative_inputs[role] = dict(expected)
    base_budget = default_budget()
    all_runs: list[dict[str, Any]] = []

    selftest = run_command(
        "qualification-self-tests",
        [sys.executable, "-m", "unittest", "-v", "canonical-datum/qualification/test_qualification.py"],
    )
    all_runs.append(selftest)

    phase0 = run_command(
        "phase0-vector-verifier",
        [sys.executable, "canonical-datum/tools/verify_phase0.py"],
    )
    all_runs.append(phase0)

    golden = run_command(
        "phase2-golden-differential",
        [sys.executable, "canonical-datum/integration/run_differential.py", "--json"],
    )
    all_runs.append(golden)
    golden_summary = json.loads(golden["stdout"])
    if golden_summary.get("status") != "PASS":
        raise QualificationFailure("reviewed golden differential did not pass")
    golden_counts = golden_summary.get("counts", {})
    if golden_counts.get("errata_vectors") != sum(ERRATA_CASE_COUNTS.values()):
        raise QualificationFailure("golden differential did not execute all 39 errata vectors")
    observed_errata_counts = {
        adjudication: golden_counts.get(f"errata_{adjudication.lower()}", 0)
        for adjudication in ERRATA_CASE_COUNTS
    }
    if observed_errata_counts != ERRATA_CASE_COUNTS:
        raise QualificationFailure(
            f"golden A1-A9 execution counts changed: {observed_errata_counts}"
        )
    common_lisp_host_na = golden_summary["counts"].get("common-lisp_host_not_applicable", 0)
    if common_lisp_host_na != 3:
        raise QualificationFailure(
            "Common Lisp language-specific host N/A disposition changed: "
            f"{common_lisp_host_na} != 3"
        )

    if args.mode == "default":
        python_environment = dict(os.environ)
        python_environment["PYTHONPATH"] = str(PYTHON_DIR)
        python_suite = run_command(
            "python-seed-suite",
            [
                sys.executable,
                "-m",
                "unittest",
                "discover",
                "-s",
                "canonical-datum/python/tests",
                "-v",
            ],
            environment=python_environment,
        )
        common_lisp_suite = run_command(
            "common-lisp-seed-suite",
            [
                "sbcl",
                "--noinform",
                "--disable-debugger",
                "--script",
                "canonical-datum/common-lisp/run-tests.lisp",
            ],
            timeout=360,
        )
        all_runs.extend((python_suite, common_lisp_suite))

    property_summary, property_runs = run_property_matrix(args.mode, base_budget)
    all_runs.extend(property_runs)
    runtime_summary, runtime_runs = run_runtime_probes(args.mode)
    all_runs.extend(runtime_runs)

    summary = {
        "schema": SCHEMA,
        "status": "PASS",
        "mode": args.mode,
        "qualification_base_revision": QUALIFICATION_BASE_REVISION,
        "run_revision": git_rev_parse("HEAD"),
        "run_tree": git_rev_parse("HEAD^{tree}"),
        "normative_specifications": normative_inputs,
        "scope": {
            "phase3_release_corpus_consumed": False,
            "phase3_release_corpus_claimed": False,
            "a1_through_a9_adjudicated": True,
            "promoted_errata_vectors_executed": True,
            "classified_failure_triples_complete": True,
        },
        "golden": {
            "status": golden_summary["status"],
            "requests_per_codec": golden_summary["requests"],
            "counts": golden_counts,
            "issues": golden_summary["issues"],
            "promoted_errata_execution": {
                "classified_total": golden_counts["errata_vectors"],
                "by_adjudication": observed_errata_counts,
                "failures": 0,
                "skips": 0,
            },
            "host_descriptor_dispositions": {
                "common_lisp_not_applicable": common_lisp_host_na,
                "common_lisp_not_applicable_is_pass": False,
                "details": golden_summary["host_not_applicable"],
            },
        },
        "property_matrix": property_summary,
        "runtime_probes": runtime_summary,
        "commands": [compact_run(run) for run in all_runs],
    }
    if args.artifacts_dir:
        write_artifacts(args.artifacts_dir, summary, all_runs)
    if args.json:
        print(json.dumps(summary, indent=2, sort_keys=True))
    else:
        print(f"CD/0 post-errata qualification ({args.mode}): PASS")
        print(
            "normative sha256: "
            + ", ".join(
                f"{role}={record['sha256']}" for role, record in normative_inputs.items()
            )
        )
        print(f"golden requests per codec: {golden_summary['requests']}")
        print(
            "ephemeral randomized round trips: "
            f"{property_summary['counts']['random_roundtrips']}"
        )
        print(
            "ephemeral equality/encoding properties: "
            f"{property_summary['counts']['equality_properties']}"
        )
        print(
            "classified hostile/resource failures: "
            f"{property_summary['counts']['classified_failures']}"
        )
        print(f"resource retries: {property_summary['counts']['resource_retries']}")
        print("warranted cross-codec disagreements: 0")
        print(
            "Common Lisp language-specific host descriptors: "
            f"{common_lisp_host_na} not applicable (not passes)"
        )
        print("A1-A9: 39 promoted vectors executed with complete adjudicated expectations")
        print("Phase-3 10k/20k corpus: neither consumed nor claimed")
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except QualificationFailure as exc:
        print(f"CD/0 qualification fatal: {exc}", file=sys.stderr)
        raise SystemExit(2)
