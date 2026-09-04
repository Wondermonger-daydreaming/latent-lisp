import argparse
import builtins
import json
import os
import sys
from decimal import Decimal
from pathlib import Path

from conditions import CostCeilingExceeded, KeyExposureBoundaryViolated, NetworkAccessForbidden, SyntheticOnlyViolation
from normalize import normalize
from provider_dry_run import DryRunProvider
from util import PACKET_ROOT, canonical_json_bytes, load_jsonl, sha256_bytes, write_new_bytes


PRIVATE_KEY_PATH = (PACKET_ROOT / "scoring/private-score-key.json").resolve()


class CostLedger:
    def __init__(self, attempt_ceiling=344, output_token_ceiling=264192, spend_ceiling="8.00"):
        self.attempt_ceiling = attempt_ceiling
        self.output_token_ceiling = output_token_ceiling
        self.spend_ceiling = Decimal(spend_ceiling)
        self.attempts = 0
        self.reserved_output_tokens = 0
        self.spend = Decimal("0.00")

    def reserve(self, max_output_tokens):
        if self.attempts + 1 > self.attempt_ceiling or self.reserved_output_tokens + max_output_tokens > self.output_token_ceiling:
            raise CostCeilingExceeded("next worst-case call reservation exceeds call/token ceiling")
        self.attempts += 1
        self.reserved_output_tokens += max_output_tokens

    def record_cost(self, billed_cost_usd):
        candidate = self.spend + Decimal(billed_cost_usd)
        if candidate > self.spend_ceiling:
            raise CostCeilingExceeded("billed spend exceeds USD 8.00")
        self.spend = candidate


def install_key_denial():
    denied = str(PRIVATE_KEY_PATH)

    def audit(event, args):
        if event == "open" and args:
            try:
                candidate = str(Path(args[0]).resolve())
            except (TypeError, OSError):
                return
            if candidate == denied:
                raise KeyExposureBoundaryViolated("synthetic runner denied private score-key open")

    sys.addaudithook(audit)


def prove_key_denial():
    install_key_denial()
    try:
        builtins.open(PRIVATE_KEY_PATH, "rb")
    except KeyExposureBoundaryViolated:
        return True
    except FileNotFoundError as exc:
        raise KeyExposureBoundaryViolated("boundary relied on key absence instead of access denial") from exc
    raise KeyExposureBoundaryViolated("private score-key open unexpectedly succeeded")


def make_request(row, index):
    if not row.get("synthetic_only"):
        raise SyntheticOnlyViolation(f"item {row.get('item_id')} is not marked synthetic_only")
    return {
        "schema_version": "lae-request/0.2", "run_id": "LAE-SYNTHETIC-DRY-RUN-001",
        "call_id": f"SYN-CALL-{index:06d}", "item_id": row["item_id"], "item_version": row["item_version"],
        "family": row["family"], "arm": row["arm"], "prompt_artifact_version": row["prompt_artifact_version"],
        "subject_slot": row["subject_slot"], "provider_id": DryRunProvider.provider_id,
        "model_id_requested": DryRunProvider.model_id,
        "parameters": {"temperature": 0, "top_p": 1, "max_output_tokens": 768, "seed": 0, "tools": False},
        "schedule_index": index, "randomization_seed_digest": row["randomization_seed_digest"],
        "attempt": 1, "retry_parent": None, "synthetic_only": True
    }


def execute(items_path, output_dir):
    provider = DryRunProvider()
    if provider.network_capable:
        raise NetworkAccessForbidden("selected provider advertises network capability")
    if os.environ.get("HTTP_PROXY") == "LAE_TEST_NETWORK_REQUIRED":
        raise NetworkAccessForbidden("network-required sentinel present")
    install_key_denial()
    output = Path(output_dir)
    budget = CostLedger()
    records = []
    for index, row in enumerate(load_jsonl(items_path), 1):
        request = make_request(row, index)
        budget.reserve(request["parameters"]["max_output_tokens"])
        prompt = (row["synthetic_prompt"] + "\n").encode("utf-8")
        request["request_bytes_sha256"] = sha256_bytes(canonical_json_bytes(request))
        request_bytes = canonical_json_bytes(request)
        emitted = provider.emit(request, prompt)
        if emitted["billed_cost_usd"] != "0.00":
            raise CostCeilingExceeded("dry-run provider returned nonzero cost")
        budget.record_cost(emitted["billed_cost_usd"])
        raw = emitted.pop("raw_bytes")
        raw_rel = f"raw-responses/{request['call_id']}.bin"
        normalized_rel = f"normalized/{request['call_id']}.json"
        request_rel = f"requests/{request['call_id']}.json"
        write_new_bytes(output / request_rel, request_bytes)
        write_new_bytes(output / raw_rel, raw)
        write_new_bytes(output / normalized_rel, normalize(raw))
        response = {
            "schema_version": "lae-response/0.2", "call_id": request["call_id"], **emitted,
            "started_at": "2000-01-01T00:00:00+00:00", "completed_at": "2000-01-01T00:00:00+00:00",
            "raw_response_path": raw_rel, "raw_response_bytes": len(raw), "raw_response_sha256": sha256_bytes(raw),
            "price_table_version": "synthetic:no-price-table", "operator_actor_id": "actor:synthetic-operator", "anomalies": [],
            "synthetic_only": True
        }
        response_rel = f"responses/{request['call_id']}.json"
        write_new_bytes(output / response_rel, canonical_json_bytes(response))
        records.append({"call_id": request["call_id"], "request": request_rel, "response": response_rel, "raw": raw_rel, "normalized": normalized_rel})
    census = {"schema_version": "lae-census/0.2", "complete": True, "expected": len(records), "observed": len(records), "network_calls": 0,
              "attempt_ceiling": budget.attempt_ceiling, "output_token_ceiling": budget.output_token_ceiling,
              "reserved_output_tokens": budget.reserved_output_tokens, "spend_ceiling_usd": str(budget.spend_ceiling), "billed_cost_usd": str(budget.spend), "records": records}
    write_new_bytes(output / "census.json", canonical_json_bytes(census))
    return census


def main():
    parser = argparse.ArgumentParser(description="Synthetic-only Language-A emission packet runner")
    parser.add_argument("--items", default=str(PACKET_ROOT / "controls/synthetic-items.jsonl"))
    parser.add_argument("--output", required=True)
    parser.add_argument("--prove-key-denial", action="store_true")
    args = parser.parse_args()
    if args.prove_key_denial:
        prove_key_denial()
        print("KEY-EXPOSURE-BOUNDARY: PASS")
        return
    census = execute(args.items, args.output)
    print(f"SYNTHETIC-DRY-RUN: PASS calls={census['observed']} network_calls=0")


if __name__ == "__main__":
    main()
