import argparse
from pathlib import Path

from conditions import IncompleteRunCensus, SchemaViolation, SilentRetryDetected
from util import load_json


def require(record, names, label):
    missing = [name for name in names if name not in record]
    if missing:
        raise SchemaViolation(f"{label} missing {','.join(missing)}")


def validate_request(record):
    require(record, ("run_id", "call_id", "item_id", "item_version", "arm", "subject_slot", "provider_id", "model_id_requested", "parameters", "schedule_index", "attempt", "retry_parent"), "request")
    if record["arm"] not in {"NL", "PERSONA", "SCAFFOLD", "LANG-A", "SHAM"}:
        raise SchemaViolation("unknown arm")
    if record["attempt"] > 1 and not record["retry_parent"]:
        raise SilentRetryDetected(record["call_id"])


def validate_response(record):
    require(record, ("call_id", "status", "finish_reason", "raw_response_path", "raw_response_bytes", "raw_response_sha256", "usage", "billed_cost_usd"), "response")
    if record["status"] not in {"completed", "transport-failure", "refused", "truncated"}:
        raise SchemaViolation("unknown response status")


def validate_census(record):
    require(record, ("complete", "expected", "observed", "records"), "census")
    if record["complete"] and (record["expected"] != record["observed"] or record["observed"] != len(record["records"])):
        raise IncompleteRunCensus("false completion claim")
    ids = [row["call_id"] for row in record["records"]]
    if len(ids) != len(set(ids)):
        raise SilentRetryDetected("duplicate call id in census")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("kind", choices=("request", "response", "census"))
    parser.add_argument("path")
    args = parser.parse_args()
    record = load_json(Path(args.path))
    {"request": validate_request, "response": validate_response, "census": validate_census}[args.kind](record)
    print(f"{args.kind.upper()}-SCHEMA: PASS")


if __name__ == "__main__":
    main()
