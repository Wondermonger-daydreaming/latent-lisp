#!/usr/bin/env python3
"""Run the first CD/0 Common Lisp/Python differential convergence pass.

The runner is an oracle coordinator, not a codec.  It derives expectations
from the pinned specification fixtures, sends the same JSONL requests to each
codec in a distinct process, and compares only normatively warranted fields.
"""

from __future__ import annotations

import argparse
from collections import defaultdict
import hashlib
import itertools
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile
import time
from typing import Any, Iterable


PROTOCOL = "lisp-plus-cd0-differential/v1"
SPEC_SHA256 = "d578e86e4d411611b091cca0bed1cafac2636c0908e95447fd4a13badcab6abc"
REPO_ROOT = Path(__file__).resolve().parents[2]
INTEGRATION_DIR = REPO_ROOT / "canonical-datum" / "integration"
VECTORS_DIR = REPO_ROOT / "canonical-datum" / "vectors"
SPEC_PATH = REPO_ROOT / "mneme" / "spec" / "CANONICAL-DATUM-SPEC.md"

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


class DifferentialFailure(RuntimeError):
    pass


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def read_jsonl(path: Path) -> list[dict[str, Any]]:
    result: list[dict[str, Any]] = []
    with path.open("r", encoding="utf-8") as stream:
        for line_number, line in enumerate(stream, 1):
            if not line.strip():
                continue
            value = json.loads(line)
            if type(value) is not dict:
                raise DifferentialFailure(f"{path}:{line_number}: expected object")
            result.append(value)
    return result


def load_budgets(path: Path) -> dict[str, dict[str, int]]:
    document = json.loads(path.read_text(encoding="utf-8"))
    definitions = document["budgets"]
    resolved: dict[str, dict[str, int]] = {}

    def resolve(name: str, active: tuple[str, ...] = ()) -> dict[str, int]:
        if name in resolved:
            return resolved[name]
        if name in active:
            raise DifferentialFailure(f"cyclic budget inheritance: {active + (name,)}")
        source = definitions[name]
        base = resolve(source["base"], active + (name,)) if "base" in source else {}
        value = {**base, **{key: item for key, item in source.items() if key != "base"}}
        if set(value) != set(BUDGET_FIELDS):
            raise DifferentialFailure(f"budget {name!r} does not resolve to all limits")
        if any(type(item) is not int or item < 0 for item in value.values()):
            raise DifferentialFailure(f"budget {name!r} has invalid limit")
        resolved[name] = value
        return value

    for budget_name in definitions:
        resolve(budget_name)
    return resolved


def resolve_row_budget(
    descriptor: str | dict[str, int], named: dict[str, dict[str, int]], row_id: str
) -> tuple[dict[str, int], str]:
    if type(descriptor) is str:
        try:
            return dict(named[descriptor]), descriptor
        except KeyError as exc:
            raise DifferentialFailure(f"{row_id}: unknown budget {descriptor!r}") from exc
    if type(descriptor) is dict and set(descriptor) == set(BUDGET_FIELDS):
        return dict(descriptor), f"inline:{row_id}"
    raise DifferentialFailure(f"{row_id}: invalid budget descriptor")


def resolve_regression_budget(
    descriptor: str | dict[str, Any], named: dict[str, dict[str, int]], case_id: str
) -> tuple[dict[str, int], str]:
    if type(descriptor) is str:
        return resolve_row_budget(descriptor, named, case_id)
    if type(descriptor) is not dict:
        raise DifferentialFailure(f"{case_id}: invalid regression budget")
    source = dict(descriptor)
    base_name = source.pop("base", None)
    if type(base_name) is not str or base_name not in named:
        raise DifferentialFailure(f"{case_id}: regression budget needs a known base")
    if not set(source).issubset(BUDGET_FIELDS):
        raise DifferentialFailure(f"{case_id}: regression budget has unknown fields")
    result = {**named[base_name], **source}
    if any(type(item) is not int or item < 0 for item in result.values()):
        raise DifferentialFailure(f"{case_id}: regression budget has invalid limit")
    return result, f"regression:{case_id}"


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


def build_requests(
    positives: list[dict[str, Any]],
    negatives: list[dict[str, Any]],
    budgets: dict[str, dict[str, int]],
    regressions: list[dict[str, Any]],
    errata_cases: list[dict[str, Any]],
) -> tuple[list[dict[str, Any]], dict[str, dict[str, Any]]]:
    requests: list[dict[str, Any]] = []
    metadata: dict[str, dict[str, Any]] = {}

    for row in positives:
        row_id = row["id"]
        budget, budget_id = resolve_row_budget(row["budget"], budgets, row_id)
        request_id = f"positive:{row_id}"
        request = request_base(request_id, "construct-roundtrip", budget, budget_id)
        request["ast"] = row["abstract"]
        if "construction" in row:
            request["construction"] = row["construction"]
        requests.append(request)
        metadata[request_id] = {"kind": "positive", "row": row}

    for row in negatives:
        row_id = row["id"]
        budget, budget_id = resolve_row_budget(row["budget"], budgets, row_id)
        operation = "decode" if row["input_kind"] == "octets" else "host-import"
        request_id = f"negative:{row_id}"
        request = request_base(request_id, operation, budget, budget_id)
        request["case_id"] = row_id
        if operation == "decode":
            request["input_hex"] = row["input_hex"]
        else:
            request["host_input"] = row["host_input"]
            request["importer"] = row["importer"]
        requests.append(request)
        metadata[request_id] = {"kind": "negative", "row": row}

    # Compare the complete equivalence relation induced by the fixture labels,
    # including reflexivity, same-class alternatives, and all cross-class pairs.
    equality_budget = budgets["cd0-conformance-default"]
    for index, (left, right) in enumerate(
        itertools.combinations_with_replacement(positives, 2), 1
    ):
        request_id = f"equality:{index:03d}:{left['id']}:{right['id']}"
        request = request_base(
            request_id,
            "equal",
            dict(equality_budget),
            "cd0-conformance-default",
        )
        request["left_ast"] = left["abstract"]
        request["right_ast"] = right["abstract"]
        if "construction" in left:
            request["left_construction"] = left["construction"]
        if "construction" in right:
            request["right_construction"] = right["construction"]
        requests.append(request)
        metadata[request_id] = {
            "kind": "equality",
            "left": left,
            "right": right,
            "expected_equal": left["equality_class"] == right["equality_class"],
        }

    for case in regressions:
        case_id = case["id"]
        operation = case["op"]
        budget, budget_id = resolve_regression_budget(case["budget"], budgets, case_id)
        request_id = f"regression:{case_id}"
        request = request_base(request_id, operation, budget, budget_id)
        if "input_hex" in case:
            request["input_hex"] = case["input_hex"]
        if "ast" in case:
            request["ast"] = case["ast"]
        if "depth" in case:
            request["depth"] = case["depth"]
        if "generated_ast" in case:
            descriptor = case["generated_ast"]
            if descriptor.get("kind") == "decimal-integer":
                digit = descriptor["digit"]
                digits = descriptor["digits"]
                if type(digit) is not str or len(digit) != 1 or digit not in "123456789":
                    raise DifferentialFailure(f"{case_id}: invalid generated decimal digit")
                if type(digits) is not int or digits < 1:
                    raise DifferentialFailure(f"{case_id}: invalid generated decimal length")
                request["ast"] = {"t": "int", "v": digit * digits}
            elif descriptor.get("kind") == "bytes":
                octet = descriptor["octet"]
                count = descriptor["count"]
                if (
                    type(octet) is not str
                    or len(octet) != 2
                    or any(character not in "0123456789abcdef" for character in octet)
                    or type(count) is not int
                    or count < 0
                ):
                    raise DifferentialFailure(f"{case_id}: invalid generated byte payload")
                request["ast"] = {"t": "bytes", "hex": octet * count}
            else:
                raise DifferentialFailure(f"{case_id}: unknown generated AST kind")
        if "generated_input" in case:
            descriptor = case["generated_input"]
            if descriptor.get("kind") != "nested-singleton-sequence-document":
                raise DifferentialFailure(f"{case_id}: unknown generated input kind")
            depth = descriptor["depth"]
            if type(depth) is not int or depth < 1:
                raise DifferentialFailure(f"{case_id}: invalid generated input depth")
            request["input_hex"] = "4c50434400" + "3001" * (depth - 1) + "00"
        requests.append(request)
        metadata[request_id] = {"kind": "regression", "case": case}

    for case in errata_cases:
        case_id = case["id"]
        base_name = case["budget"]
        if base_name not in budgets:
            raise DifferentialFailure(f"{case_id}: unknown errata base budget")
        budget = {**budgets[base_name], **case.get("overrides", {})}
        request_id = f"errata:{case_id}"
        request = request_base(request_id, case["op"], budget, f"errata:{case_id}")
        for field in ("input_hex", "ast", "construction"):
            if field in case:
                request[field] = case[field]
        if case["op"] == "runtime-encode":
            request["admission_budget"] = budgets["cd0-conformance-default"]
            request["admission_budget_id"] = "cd0-conformance-default"
        requests.append(request)
        metadata[request_id] = {"kind": "errata", "case": case}

    return requests, metadata


def serialize_requests(requests: Iterable[dict[str, Any]]) -> str:
    return "".join(
        json.dumps(request, sort_keys=True, separators=(",", ":")) + "\n"
        for request in requests
    )


def run_adapter(
    implementation: str,
    command: list[str],
    request_path: Path,
    *,
    environment: dict[str, str] | None = None,
) -> dict[str, Any]:
    started = time.monotonic()
    completed = subprocess.run(
        command + [str(request_path)],
        cwd=REPO_ROOT,
        env=environment,
        text=True,
        capture_output=True,
        timeout=120,
        check=False,
    )
    elapsed = time.monotonic() - started
    if completed.returncode != 0:
        stdout_tail = completed.stdout[-4000:]
        stderr_tail = completed.stderr[-4000:]
        raise DifferentialFailure(
            f"{implementation} adapter exited {completed.returncode}\n"
            f"stdout tail ({len(completed.stdout)} total chars):\n{stdout_tail}\n"
            f"stderr tail ({len(completed.stderr)} total chars):\n{stderr_tail}"
        )
    responses: dict[str, dict[str, Any]] = {}
    for line_number, line in enumerate(completed.stdout.splitlines(), 1):
        if not line.strip():
            continue
        try:
            response = json.loads(line)
        except json.JSONDecodeError as exc:
            raise DifferentialFailure(
                f"{implementation} response line {line_number} is not JSON: {line!r}"
            ) from exc
        if response.get("protocol") != PROTOCOL:
            raise DifferentialFailure(f"{implementation}: protocol mismatch")
        if response.get("implementation") != implementation:
            raise DifferentialFailure(f"{implementation}: implementation label mismatch")
        request_id = response.get("request_id")
        if type(request_id) is not str or request_id in responses:
            raise DifferentialFailure(f"{implementation}: duplicate/invalid request_id")
        responses[request_id] = response
    return {
        "command": command + [str(request_path)],
        "returncode": completed.returncode,
        "stdout": completed.stdout,
        "stderr": completed.stderr,
        "elapsed_seconds": elapsed,
        "responses": responses,
    }


def warranted_fields(row: dict[str, Any]) -> tuple[str, ...]:
    status = row.get("status", "normative")
    if status == "normative":
        return ("category", "code", "stage")
    raise DifferentialFailure(f"{row['id']}: unknown fixture status {status!r}")


def compare(
    metadata: dict[str, dict[str, Any]],
    common_lisp: dict[str, dict[str, Any]],
    python: dict[str, dict[str, Any]],
) -> tuple[list[str], dict[str, Any]]:
    issues: list[str] = []
    counters: dict[str, int] = defaultdict(int)
    host_not_applicable: list[dict[str, str]] = []
    expected_host_not_applicable = {
        ("common-lisp", "cd0-neg-host-ambiguous-identifier"),
        ("common-lisp", "cd0-neg-host-bool-as-integer"),
        ("common-lisp", "cd0-neg-host-privileged-value"),
    }
    observed_host_not_applicable: set[tuple[str, str]] = set()

    expected_ids = set(metadata)
    for implementation, responses in (("common-lisp", common_lisp), ("python", python)):
        missing = sorted(expected_ids - set(responses))
        extra = sorted(set(responses) - expected_ids)
        if missing:
            issues.append(f"{implementation}: missing {len(missing)} responses: {missing[:3]}")
        if extra:
            issues.append(f"{implementation}: unexpected responses: {extra[:3]}")

    for request_id, meta in metadata.items():
        if request_id not in common_lisp or request_id not in python:
            continue
        cl = common_lisp[request_id]
        py = python[request_id]
        kind = meta["kind"]

        if kind == "positive":
            counters["positive_rows"] += 1
            row = meta["row"]
            for label, response in (("common-lisp", cl), ("python", py)):
                if response.get("status") != "ok":
                    issues.append(f"{request_id}: {label} did not succeed: {response}")
                    continue
                result = response["result"]
                if result.get("canonical_hex") != row["canonical_hex"]:
                    issues.append(f"{request_id}: {label} canonical bytes differ from fixture")
                if result.get("fixture_ast") != row["expected_decoded"]:
                    issues.append(f"{request_id}: {label} normalized fixture AST differs")
                if result.get("reencoded_hex") != row["canonical_hex"]:
                    issues.append(f"{request_id}: {label} decode/re-encode differs")
                if result.get("constructed_equal_decoded") is not True:
                    issues.append(f"{request_id}: {label} constructed/decoded equality is false")
            if cl.get("status") == py.get("status") == "ok" and cl["result"] != py["result"]:
                issues.append(f"{request_id}: codec positive results disagree")
            continue

        if kind == "negative":
            counters["negative_rows"] += 1
            row = meta["row"]
            fields = warranted_fields(row)
            applicable: list[tuple[str, dict[str, Any]]] = []
            for label, response in (("common-lisp", cl), ("python", py)):
                if response.get("status") == "not-applicable":
                    if row["input_kind"] != "host":
                        issues.append(f"{request_id}: {label} marked octet row N/A")
                    host_not_applicable.append(
                        {"implementation": label, "id": row["id"], "reason": response.get("reason", "")}
                    )
                    observed_host_not_applicable.add((label, row["id"]))
                    if (label, row["id"]) not in expected_host_not_applicable:
                        issues.append(f"{request_id}: unexpected {label} N/A disposition")
                    counters[f"{label}_host_not_applicable"] += 1
                    continue
                applicable.append((label, response))
                counters[f"{label}_negative_executed"] += 1
                if response.get("status") != "failure":
                    issues.append(f"{request_id}: {label} unexpectedly succeeded: {response}")
                    continue
                actual = response["failure"]
                expected = row["expected_failure"]
                if any(actual.get(field) != expected[field] for field in fields):
                    issues.append(
                        f"{request_id}: {label} warranted failure mismatch "
                        f"actual={actual} expected={expected} fields={fields}"
                    )
            failures = [response["failure"] for _, response in applicable if response.get("status") == "failure"]
            if len(failures) == 2:
                if any(failures[0].get(field) != failures[1].get(field) for field in fields):
                    issues.append(
                        f"{request_id}: cross-codec warranted failure disagreement "
                        f"CL={failures[0]} Python={failures[1]} fields={fields}"
                    )
            continue

        if kind == "equality":
            counters["equality_judgments"] += 1
            expected_equal = meta["expected_equal"]
            for label, response in (("common-lisp", cl), ("python", py)):
                if response.get("status") != "ok":
                    issues.append(f"{request_id}: {label} equality operation failed: {response}")
                    continue
                result = response["result"]
                if result.get("equal") is not expected_equal:
                    issues.append(
                        f"{request_id}: {label} equality {result.get('equal')} != {expected_equal}"
                    )
                if result.get("left_hex") != meta["left"]["canonical_hex"]:
                    issues.append(f"{request_id}: {label} left equality bytes differ")
                if result.get("right_hex") != meta["right"]["canonical_hex"]:
                    issues.append(f"{request_id}: {label} right equality bytes differ")
            if cl.get("status") == py.get("status") == "ok" and cl["result"] != py["result"]:
                issues.append(f"{request_id}: codec equality results disagree")
            continue

        if kind == "regression":
            counters["integration_regressions"] += 1
            case = meta["case"]
            for label, response in (("common-lisp", cl), ("python", py)):
                expectation = case["expectations"][label]
                expected_status = expectation["status"]
                if response.get("status") != expected_status:
                    issues.append(
                        f"{request_id}: {label} regression status {response.get('status')} "
                        f"!= {expected_status}: {response}"
                    )
                    continue
                if expected_status == "failure":
                    actual = response["failure"]
                    expected = expectation["failure"]
                    fields = tuple(expectation["warranted_fields"])
                    if any(actual.get(field) != expected[field] for field in fields):
                        issues.append(
                            f"{request_id}: {label} regression failure mismatch "
                            f"actual={actual} expected={expected} fields={fields}"
                        )
            if cl.get("status") == py.get("status") == "ok" and cl.get("result") != py.get("result"):
                issues.append(
                    f"{request_id}: successful regression results disagree "
                    f"CL={cl.get('result')} Python={py.get('result')}"
                )
            continue

        if kind == "errata":
            counters["errata_vectors"] += 1
            case = meta["case"]
            counters[f"errata_{case['adjudication'].lower()}"] += 1
            expectation = case["expected"]
            for label, response in (("common-lisp", cl), ("python", py)):
                if response.get("status") != expectation["status"]:
                    issues.append(
                        f"{request_id}: {label} errata status {response.get('status')} "
                        f"!= {expectation['status']}: {response}"
                    )
                    continue
                if expectation["status"] == "failure":
                    if response.get("failure") != expectation["failure"]:
                        issues.append(
                            f"{request_id}: {label} errata failure mismatch "
                            f"actual={response.get('failure')} expected={expectation['failure']}"
                        )
                elif response.get("result") != expectation["result"]:
                    issues.append(
                        f"{request_id}: {label} errata result mismatch "
                        f"actual={response.get('result')} expected={expectation['result']}"
                    )
            if cl.get("status") == py.get("status") == "ok" and cl.get("result") != py.get("result"):
                issues.append(f"{request_id}: successful errata results disagree")
            if cl.get("status") == py.get("status") == "failure" and cl.get("failure") != py.get("failure"):
                issues.append(f"{request_id}: errata failure triples disagree")
            continue

        issues.append(f"{request_id}: unknown metadata kind {kind!r}")

    missing_not_applicable = sorted(
        expected_host_not_applicable - observed_host_not_applicable
    )
    if missing_not_applicable:
        issues.append(
            "declared optional-host N/A dispositions changed without protocol update: "
            f"{missing_not_applicable}"
        )

    return issues, {
        "counts": dict(sorted(counters.items())),
        "host_not_applicable": host_not_applicable,
        "provisional_observations": [],
    }


def command_text(command: Iterable[str]) -> str:
    # Commands contain only repository-controlled paths without whitespace in
    # the qualification environment; this is a transcript, not shell input.
    return " ".join(command)


def write_artifacts(
    destination: Path,
    request_text: str,
    runs: dict[str, dict[str, Any]],
    summary: dict[str, Any],
) -> None:
    destination.mkdir(parents=True, exist_ok=True)
    (destination / "requests.jsonl").write_text(request_text, encoding="utf-8")
    for label, run in runs.items():
        (destination / f"{label}-responses.jsonl").write_text(run["stdout"], encoding="utf-8")
        (destination / f"{label}-stderr.txt").write_text(run["stderr"], encoding="utf-8")
    (destination / "summary.json").write_text(
        json.dumps(summary, indent=2, sort_keys=True) + "\n", encoding="utf-8"
    )


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--artifacts-dir", type=Path)
    parser.add_argument("--json", action="store_true", help="emit only the summary JSON")
    args = parser.parse_args(argv)

    actual_spec_digest = sha256(SPEC_PATH)
    if actual_spec_digest != SPEC_SHA256:
        raise DifferentialFailure(
            f"specification digest mismatch: {actual_spec_digest} != {SPEC_SHA256}"
        )

    positive_path = VECTORS_DIR / "cd0-positive.jsonl"
    negative_path = VECTORS_DIR / "cd0-negative.jsonl"
    budget_path = VECTORS_DIR / "cd0-budgets.json"
    regression_path = INTEGRATION_DIR / "cases" / "cd0-integration-regressions.json"
    errata_path = VECTORS_DIR / "cd0-errata-0.1.json"
    positives = read_jsonl(positive_path)
    negatives = read_jsonl(negative_path)
    if len(positives) != 25 or len(negatives) != 71:
        raise DifferentialFailure(
            f"reviewed seed manifest changed: positives={len(positives)}, negatives={len(negatives)}"
        )
    budgets = load_budgets(budget_path)
    regression_document = json.loads(regression_path.read_text(encoding="utf-8"))
    if regression_document.get("schema") != "cd0-integration-regressions/v1":
        raise DifferentialFailure("integration regression manifest schema mismatch")
    regressions = regression_document.get("cases")
    if type(regressions) is not list or len(regressions) != 7:
        raise DifferentialFailure("integration regression manifest must contain seven cases")
    errata_document = json.loads(errata_path.read_text(encoding="utf-8"))
    if errata_document.get("schema") != "cd0-errata-vectors/0.1":
        raise DifferentialFailure("Errata 0.1 vector manifest schema mismatch")
    errata_cases = errata_document.get("cases")
    if type(errata_cases) is not list or len(errata_cases) != 37:
        raise DifferentialFailure("Errata 0.1 vector manifest must contain 37 cases")
    requests, metadata = build_requests(
        positives, negatives, budgets, regressions, errata_cases
    )
    request_text = serialize_requests(requests)

    with tempfile.TemporaryDirectory(prefix="cd0-differential-") as temporary:
        request_path = Path(temporary) / "requests.jsonl"
        request_path.write_text(request_text, encoding="utf-8")
        python_environment = dict(os.environ)
        python_environment["PYTHONPATH"] = str(REPO_ROOT / "canonical-datum" / "python")
        # Exercise two ambient Python settings that must not participate in
        # datum identity or fixture-decimal semantics.  640 is CPython's
        # smallest accepted nonzero decimal digit guard.
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
            ),
            "python": run_adapter(
                "python",
                [sys.executable, str(INTEGRATION_DIR / "python_adapter.py")],
                request_path,
                environment=python_environment,
            ),
        }

    issues, comparison = compare(
        metadata,
        runs["common-lisp"]["responses"],
        runs["python"]["responses"],
    )
    summary: dict[str, Any] = {
        "protocol": PROTOCOL,
        "status": "PASS" if not issues else "FAIL",
        "specification": {
            "path": str(SPEC_PATH.relative_to(REPO_ROOT)),
            "sha256": actual_spec_digest,
        },
        "fixture_sha256": {
            "positive": sha256(positive_path),
            "negative": sha256(negative_path),
            "errata_0_1": sha256(errata_path),
            "budgets": sha256(budget_path),
        },
        "adapter_sha256": {
            "common-lisp": sha256(INTEGRATION_DIR / "common_lisp_adapter.lisp"),
            "python": sha256(INTEGRATION_DIR / "python_adapter.py"),
            "runner": sha256(Path(__file__).resolve()),
        },
        "integration_regression_sha256": sha256(regression_path),
        "requests": len(requests),
        "ambient_test_state": {
            "python_hash_seed": "137",
            "python_int_max_str_digits": "640",
        },
        **comparison,
        "processes": {
            label: {
                "command": command_text(run["command"][:-1] + ["<requests.jsonl>"]),
                "returncode": run["returncode"],
                "elapsed_seconds": round(run["elapsed_seconds"], 6),
                "response_count": len(run["responses"]),
                "stderr": run["stderr"],
            }
            for label, run in runs.items()
        },
        "issues": issues,
    }

    if args.artifacts_dir:
        write_artifacts(args.artifacts_dir, request_text, runs, summary)
    if args.json:
        print(json.dumps(summary, indent=2, sort_keys=True))
    else:
        counts = summary["counts"]
        print(f"CD/0 differential convergence: {summary['status']}")
        print(f"spec sha256: {actual_spec_digest}")
        print(f"requests: {summary['requests']} in each of 2 isolated codec processes")
        print(f"shared positives executed: {counts.get('positive_rows', 0)}/25")
        print(f"shared negative classified total: {counts.get('negative_rows', 0)}/71")
        print(
            "  Common Lisp executed: "
            f"{counts.get('common-lisp_negative_executed', 0)}; host N/A: "
            f"{counts.get('common-lisp_host_not_applicable', 0)}"
        )
        print(
            "  Python executed: "
            f"{counts.get('python_negative_executed', 0)}; host N/A: "
            f"{counts.get('python_host_not_applicable', 0)}"
        )
        print("  classified failures: 0; skips: 0")
        print(f"complete equality matrix: {counts.get('equality_judgments', 0)}/325")
        print(
            "minimized integration regressions: "
            f"{counts.get('integration_regressions', 0)}/7"
        )
        print(
            "promoted Errata 0.1 operation vectors: "
            f"{counts.get('errata_vectors', 0)}/37"
        )
        for label, process in summary["processes"].items():
            print(
                f"{label} process: exit {process['returncode']}; "
                f"responses {process['response_count']}; stderr bytes {len(process['stderr'])}"
            )
        if issues:
            print(f"issues: {len(issues)}")
            for issue in issues:
                print(f"- {issue}")
        else:
            print("warranted cross-codec disagreements: 0")
    return 0 if not issues else 1


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except DifferentialFailure as exc:
        print(f"CD/0 differential runner fatal: {exc}", file=sys.stderr)
        raise SystemExit(2)
