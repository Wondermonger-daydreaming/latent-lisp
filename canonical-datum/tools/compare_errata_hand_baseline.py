#!/usr/bin/env python3
"""Compare Errata 0.1 hand-differential results to the audited hand baseline.

This is a finite receipt check, not a codec oracle. It compares the complete
observable response payload for every historical positive, negative, equality,
and integration-regression request while allowing the errata run to add new
requests under separately counted IDs.
"""

from __future__ import annotations

import argparse
import json
from pathlib import Path
from typing import Any


class ComparisonFailure(RuntimeError):
    pass


def read_jsonl(path: Path) -> dict[str, dict[str, Any]]:
    responses: dict[str, dict[str, Any]] = {}
    for line_number, raw in enumerate(path.read_text(encoding="utf-8").splitlines(), 1):
        if not raw:
            continue
        value = json.loads(raw)
        request_id = value.get("request_id")
        if type(request_id) is not str or request_id in responses:
            raise ComparisonFailure(f"{path}:{line_number}: duplicate or invalid request_id")
        responses[request_id] = value
    return responses


def equality_key(request_id: str) -> tuple[str, str]:
    pieces = request_id.split(":", 3)
    if len(pieces) != 4 or pieces[0] != "equality":
        raise ComparisonFailure(f"malformed equality request id: {request_id}")
    return pieces[2], pieces[3]


def payload(response: dict[str, Any]) -> dict[str, Any]:
    return {
        key: value
        for key, value in response.items()
        if key not in {"protocol", "implementation", "request_id"}
    }


def compare_one(
    implementation: str,
    baseline_path: Path,
    errata_path: Path,
) -> dict[str, Any]:
    baseline = read_jsonl(baseline_path)
    errata = read_jsonl(errata_path)
    issues: list[str] = []
    compared = {"positive": 0, "negative": 0, "equality": 0, "regression": 0}

    errata_equalities = {
        equality_key(request_id): response
        for request_id, response in errata.items()
        if request_id.startswith("equality:")
    }
    for request_id, old_response in baseline.items():
        kind = request_id.split(":", 1)[0]
        if kind == "equality":
            new_response = errata_equalities.get(equality_key(request_id))
        else:
            new_response = errata.get(request_id)
        if new_response is None:
            issues.append(f"{implementation}: missing historical request {request_id}")
            continue
        if payload(old_response) != payload(new_response):
            issues.append(
                f"{implementation}: historical response changed for {request_id}: "
                f"old={payload(old_response)!r} new={payload(new_response)!r}"
            )
        if kind not in compared:
            issues.append(f"{implementation}: unknown historical request class {kind}")
        else:
            compared[kind] += 1

    expected = {"positive": 22, "negative": 71, "equality": 253, "regression": 7}
    if compared != expected:
        issues.append(f"{implementation}: historical comparison counts {compared} != {expected}")

    errata_counts = {
        "positive": sum(key.startswith("positive:") for key in errata),
        "negative": sum(key.startswith("negative:") for key in errata),
        "equality": sum(key.startswith("equality:") for key in errata),
        "regression": sum(key.startswith("regression:") for key in errata),
        "errata": sum(key.startswith("errata:") for key in errata),
    }
    expected_errata = {
        "positive": 25,
        "negative": 71,
        "equality": 325,
        "regression": 7,
        "errata": 37,
    }
    if errata_counts != expected_errata:
        issues.append(f"{implementation}: errata request counts {errata_counts} != {expected_errata}")

    return {
        "implementation": implementation,
        "baseline_path": str(baseline_path),
        "errata_path": str(errata_path),
        "historical_compared": compared,
        "errata_counts": errata_counts,
        "differences": len(issues),
        "issues": issues,
    }


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--baseline-dir", required=True, type=Path)
    parser.add_argument("--errata-dir", required=True, type=Path)
    parser.add_argument("--json", action="store_true")
    args = parser.parse_args()

    results = [
        compare_one(
            implementation,
            args.baseline_dir / f"{implementation}-responses.jsonl",
            args.errata_dir / f"{implementation}-responses.jsonl",
        )
        for implementation in ("common-lisp", "python")
    ]
    issues = [issue for result in results for issue in result["issues"]]
    summary = {
        "status": "PASS" if not issues else "FAIL",
        "scope": "finite audited hand corpus and promoted Errata 0.1 operation vectors",
        "canonical_octet_changes_in_historical_positives": 0 if not issues else None,
        "normalized_abstract_datum_changes_in_historical_positives": 0 if not issues else None,
        "equality_result_changes_in_historical_matrix": 0 if not issues else None,
        "historical_disposition_changes": 0 if not issues else None,
        "results": results,
        "issues": issues,
    }
    if args.json:
        print(json.dumps(summary, indent=2, sort_keys=True))
    else:
        print(f"CD/0 Errata hand-baseline comparison: {summary['status']}")
        for result in results:
            print(
                f"{result['implementation']}: historical "
                f"{result['historical_compared']}; errata {result['errata_counts']}; "
                f"differences {result['differences']}"
            )
        print("bounded result: no historical hand-corpus byte, AST, equality, or disposition change")
        if issues:
            for issue in issues:
                print(f"- {issue}")
    return 0 if not issues else 1


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except (ComparisonFailure, KeyError, TypeError, ValueError) as exc:
        print(f"CD/0 Errata hand-baseline comparison fatal: {exc}")
        raise SystemExit(2)
